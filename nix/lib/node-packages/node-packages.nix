# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {};
in
{
  "@anthropic-ai/claude-code" = nodeEnv.buildNodePackage {
    name = "_at_anthropic-ai_slash_claude-code";
    packageName = "@anthropic-ai/claude-code";
    version = "0.2.32";
    src = fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-0.2.32.tgz";
      sha512 = "BhVAlBGkgMbkiWPein6fADLgfZKakR9FQNYGzReSebvBxxQRy9jypYuuZgd+4p5RIYsOtyevlUltAm0KHDgs7A==";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "Use Claude, Anthropic's AI assistant, right from your terminal. Claude can understand your codebase, edit files, run terminal commands, and handle entire workflows for you.";
      homepage = "https://github.com/anthropics/claude-code";
      license = "SEE LICENSE IN README.md";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
