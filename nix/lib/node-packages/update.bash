#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

node2nix -18 -i packages.json
