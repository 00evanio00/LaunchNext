# default.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./launchnext.nix {}
