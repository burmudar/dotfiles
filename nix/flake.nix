{
  description = "My first nix flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
  };

  outputs = { self, nixpkgs, home-manager, darwin }:
  let
  in {


      darwinConfigurations."Williams-MacBook-Pro" = darwin.lib.darwinSystem {
        # you can have multiple darwinConfigurations per flake, one per hostname

        system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
        modules = [
          ./hosts/mac/default.nix
          home-manager.darwinModules.home-manager
          ./home.nix
        ]; # will be important later
      };
    };

}
