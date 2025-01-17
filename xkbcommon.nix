{ mkDerivation, base, bytestring, Cabal, cpphs, data-flags
, directory, filepath, lib, libxkbcommon, process, random
, storable-record, template-haskell, text, time, transformers, unix
, vector, linuxHeaders, glibc
}:
mkDerivation {
  pname = "xkbcommon";
  version = "0.0.3";
  src = ./.;
  setupHaskellDepends = [
    base Cabal cpphs directory filepath process template-haskell text
  ];
  libraryHaskellDepends = [
    base bytestring cpphs data-flags filepath process storable-record
    template-haskell text transformers
  ];
  libraryPkgconfigDepends = [ libxkbcommon ];
  librarySystemDepends = [ linuxHeaders glibc ];
  testHaskellDepends = [ base unix ];
  benchmarkHaskellDepends = [ base random time vector ];
  description = "Haskell bindings for libxkbcommon";
  license = lib.licenses.mit;
}
