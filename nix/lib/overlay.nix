{
  cloudflare-dns-ip,
  rust-overlay,
  jj-starship,
  copyparty
}:
[
  copyparty.overlays.default
  cloudflare-dns-ip.overlay
  rust-overlay.overlays.default
  jj-starship.overlays.default
  (final: prev: {
    jackett = prev.jackett.overrideAttrs { doCheck = false; };
    # to get nodePackages.* to use a newer node version you have to overlay nodejs with the version you want
    nodejs = prev.nodejs_22;
    customNodePackages = prev.callPackage ./node-packages/default.nix {
      pkgs = prev;
      nodejs = prev.nodejs_22;
    };
    # lutris = prev.lutris.override {
    #   extraLibraries = pkgs: [];
    #   extraPkgs = pkgs: [ pkgs.wine-mono ];
    # };
  })
]
