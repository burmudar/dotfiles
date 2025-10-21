{
  description = "William Flake config for his machines";

  inputs = {
    unstable-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
    flake-utils.url = "github:numtide/flake-utils";
    # see: https://github.com/nix-community/neovim-nightly-overlay/issues/176
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "unstable-nixpkgs";

    cloudflare-dns-ip.url = "github:burmudar/cloudflare-dns-ip";
    cloudflare-dns-ip.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";

    hyprland.url = "github:hyprwm/hyprland";
  };

  outputs =
    { self
    , cloudflare-dns-ip
    , darwin
    , flake-utils
    , home-manager
    , neovim-nightly-overlay
    , nixpkgs
    , unstable-nixpkgs
    , rust-overlay
    , ghostty
    , hyprland
    ,
    }@inputs:
    let
      pkgs = (inputs.flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (system: {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays =
            let
              nodejs-overlay = (final: prev: {
                # to get nodePackages.* to use a newer node version you have to overlay nodejs with the version you want
                nodejs = prev.nodejs_22;
              });
            in
            [
              # TODO Move these overlays into lib/overlay.nix
              nodejs-overlay
              cloudflare-dns-ip.overlay
              rust-overlay.overlays.default
              (import lib/overlay.nix)
            ];
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "aspnetcore-runtime-wrapped-6.0.36"
              "aspnetcore-runtime-6.0.36"
              "dotnet-sdk-6.0.428"
            ];
          };
        };
      })).pkgs;
      unstable-pkgs = (inputs.flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (system: {
        pkgs = import inputs.unstable-nixpkgs {
          inherit system;
          overlays =
            let
              neovim-unwrapped-overlay = (final: prev: {
                neovim-unwrapped = inputs.unstable-nixpkgs.legacyPackages."${system}".neovim-unwrapped.overrideAttrs (old: {
                  meta = old.meta or { } // { maintainers = [ ]; };
                });
              });
            in
            [
              neovim-unwrapped-overlay
              neovim-nightly-overlay.overlays.default
            ];
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "aspnetcore-runtime-wrapped-6.0.36"
              "electron-25.9.0"
              "dotnet-sdk-6.0.428"
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
        specialArgs = { pkgs = pkgs.x86_64-linux; unstable = unstable-pkgs.x86_64-linux; ghostty = ghostty.packages.x86_64-linux; hyprland = inputs.hyprland.packages.x86_64-linux; };
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
      darwinConfigurations.Machine-Spirit = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = { pkgs = pkgs.aarch64-darwin; unstable = unstable-pkgs.aarch64-darwin; hostname = "Machine-Spirit"; };
        modules = [
          ./hosts/mac/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.william = import ./home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
      darwinConfigurations.Williams-MacBook-Pro = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = { pkgs = pkgs.aarch64-darwin; unstable = unstable-pkgs.aarch64-darwin; hostname = "Williams-MacBook-Pro"; personal = true; };
        modules = [
          ./hosts/mac/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.william = import ./home.nix;
            home-manager.extraSpecialArgs = specialArgs;
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
          extraSpecialArgs = { unstable = unstable-pkgs.x86_64-linux; };
          modules = [ ./home.nix { home.homeDirectory = "/home/william"; } ];
        };
        "mac" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.aarch64-darwin;
          extraSpecialArgs = { unstable = unstable-pkgs.aarch64-darwin; };
          modules = [ ./home.nix { home.homeDirectory = "/Users/william"; } ];
        };
      };
      formatter.x86_64-linux = pkgs.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-darwin = pkgs.aarch64-darwin.nixpkgs-fmt;
    };
}
