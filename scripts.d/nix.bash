#!/usr/bin/env bash

function nix-sw() {
  cd $SRC/dotfiles/nix

  hostname="$(hostname)"

  echo "--- building system configuration ($hostname)---"
  sudo nixos-rebuild switch --flake .
  echo "--- done ---"

  cd -
}

function nix-darwin-sw() {
  cd $SRC/dotfiles/nix

  hostname="$(hostname)"

  echo "--- building system configuration (${hostname}) ---"
  sudo nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake ".#${hostname}"
  echo "--- done ---"

  cd -
}
