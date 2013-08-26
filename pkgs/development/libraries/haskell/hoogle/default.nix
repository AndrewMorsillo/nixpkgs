{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, hspec
, hspecExpectations, httpTypes, HUnit, parsec, random, safe
, systemFileio, tagsoup, text, time, transformers, uniplate, wai
, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.19";
  sha256 = "0mfmb3ky93gicwd1i4n3xfhlr3y6zgc4dv2nrilrr9l0kfka37f8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec random safe
    tagsoup text time transformers uniplate wai warp
  ];
  testDepends = [
    conduit hspec hspecExpectations HUnit systemFileio transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
