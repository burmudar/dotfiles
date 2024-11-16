#!/usr/bin/env bash

function nix-sw() {
  cd $SRC/dotfiles/nix

  echo "--- step 1: building system configuration ---"
  nixos-rebuild build --flake .
  echo "--- done ---"

  echo "--- step 2: switch to the built system configuration ---"
  sudo ./result/bin/switch-to-configuration switch
  echo "--- done ---"

  cd -
}

function nix-darwin-sw() {
  cd $SRC/dotfiles/nix

  echo "--- step 1: building system configuration ---"
  darwin-rebuild build --flake .
  echo "--- done ---"

  echo "--- step 2: switch to the built system configuration ---"
  ./result/bin/switch-to-configuration switch
  echo "--- done ---"

  cd -
}
