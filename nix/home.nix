{ config, pkgs, unstable, lib, ... }@inputs:
{
  # Import modules to split the 450+ line monolith into manageable pieces
  # Each module is a function that takes the same inputs and returns config options
  # The module system automatically merges all configs together
  imports = [
    ./home/core.nix        # Core settings, packages, aliases, and file management
    ./home/programs.nix    # All programs.* configurations (git, zsh, tmux, etc.)
    ./home/platform.nix    # OS-specific settings (XDG on Linux, etc.)
  ];
}
