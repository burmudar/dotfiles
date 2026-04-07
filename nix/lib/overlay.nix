final: prev: {
  jackett = prev.jackett.overrideAttrs { doCheck = false; };
  customNodePackages = prev.callPackage ./node-packages/default.nix {
    pkgs = prev;
    nodejs = prev.nodejs_22;
  };
  lutris = prev.lutris.override {
    extraLibraries = pkgs: [];
    extraPkgs = pkgs: [ pkgs.wine-mono ];
  };
}
