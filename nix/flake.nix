{
  description = "William Flake config for his machines";

  inputs = {
    unstable-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "darwin-nixpkgs";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
    flake-utils.url = "github:numtide/flake-utils";
    # see: https://github.com/nix-community/neovim-nightly-overlay/issues/176
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "unstable-nixpkgs";

    cloudflare-caddy.url = "github:burmudar/nix-cloudflare-caddy";
    cloudflare-caddy.inputs.nixpkgs.follows = "nixpkgs";

    cloudflare-dns-ip.url = "github:burmudar/cloudflare-dns-ip";
    cloudflare-dns-ip.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
    ghostty-hm.url = "github:clo4/ghostty-hm-module";
  };

  outputs =
    { self
    , cloudflare-caddy
    , cloudflare-dns-ip
    , darwin
    , flake-utils
    , home-manager
    , neovim-nightly-overlay
    , nixpkgs
    , darwin-nixpkgs
    , unstable-nixpkgs
    , rust-overlay
    , ghostty
    , ghostty-hm
    ,
    }@inputs:
    let
      # generate pkgs for each subsystem ie. this results in the following set:
      # pkgs {
      #   x86_64-linux = <nixpkgs>;
      #   aarch64-darwin = <nixpkgs>;
      # }
      pkgs = (inputs.flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (system: {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            cloudflare-caddy.overlay
            cloudflare-dns-ip.overlay
            neovim-nightly-overlay.overlays.default
            rust-overlay.overlays.default
          ];
          config = {
            allowUnfree = true;
          };
        };
      })).pkgs;
      darwin-pkgs = (inputs.flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (system: {
        pkgs = import inputs.darwin-nixpkgs {
          inherit system;
          overlays = [
            cloudflare-caddy.overlay
            cloudflare-dns-ip.overlay
            neovim-nightly-overlay.overlays.default
            rust-overlay.overlays.default
          ];
          config = { allowUnfree = true; };
        };
      })).pkgs;
      unstable-pkgs = (inputs.flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (system: {
        pkgs = import inputs.unstable-nixpkgs {
          inherit system;
          overlays = [
            neovim-nightly-overlay.overlays.default
          ];
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "electron-25.9.0"
            ];
          };
        };
      })).pkgs;
    in
    {
      nixConfig = {
        extra-substituters = [
          "https://colmena.cachix.org"
        ];
        extra-trusted-public-keys = [
          "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
        ];
      };
      nixosConfigurations.fort-kickass = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { pkgs = pkgs.x86_64-linux; unstable = unstable-pkgs.x86_64-linux; ghostty = ghostty.packages.x86_64-linux; };
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.william = import ./home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
      nixosConfigurations.media = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { pkgs = pkgs.x86_64-linux; unstable = unstable-pkgs.x86_64-linux; };
        modules = [
          ./hosts/media/configuration.nix
          inputs.cloudflare-dns-ip.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.william = import ./home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
      darwinConfigurations.Williams-MacBook-Pro = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = { pkgs = darwin-pkgs.aarch64-darwin; unstable = unstable-pkgs.aarch64-darwin; };
        modules = [
          ./hosts/mac/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.william = import ./home.nix;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.sharedModules = [ ghostty-hm.homeModules.default ];
          }
        ];
      };
      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { pkgs = pkgs.x86_64-linux; };
        modules = [
          ./hosts/vm/configuration.nix
          inputs.cloudflare-dns-ip.nixosModules.default
        ];
      };
      homeConfigurations = {
        "desktop" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.x86_64-linux;
          modules = [./home.nix { home.homeDirectory = "/home/william"; } ];
        };
        "mac" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.aarch64-darwin;
          modules = [./home.nix { home.homeDirectory = "/Users/william"; } ];
        };
      };
      formatter.x86_64-linux = pkgs.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-darwin = pkgs.aarch64-darwin.nixpkgs-fmt;
    };
}
