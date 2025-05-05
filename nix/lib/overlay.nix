final: prev: {
  jackett = prev.jackett.overrideAttrs { doCheck = false; };
  customNodePackages = prev.callPackage ./node-packages/default.nix {
    pkgs = prev;
    nodejs = prev.nodejs_22;
  };
}
