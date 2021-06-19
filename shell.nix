{ pkgs ? import <nixpkgs> {} }:
pkgs.haskellPackages.shellFor {
  packages = p: [(p.callPackage ./xkbcommon.nix {})];
  withHoogle = false;
  buildInputs = [ pkgs.cabal-install pkgs.cabal2nix ];
}
