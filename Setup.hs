{-# LANGUAGE CPP #-}
import Distribution.PackageDescription
import Distribution.Simple hiding (Module)
import Distribution.Simple.PreProcess
import Distribution.Simple.LocalBuildInfo

#ifdef VERSION_text
import Control.Arrow
import Language.Preprocessor.Cpphs
import System.FilePath

import Text.XkbCommon.ParseDefines

import Module
import Utils

generateSource :: FilePath -> IO ()
generateSource fp = do
  parsedDefs <- getKeysymDefs
  saveModule fp (keysymsModule parsedDefs)
  return ()

keysymsModule :: [(String,Integer)] -> Module
keysymsModule defs = Module "Text.XkbCommon.KeysymPatterns" [] $
                     Import ["Text.XkbCommon.InternalTypes"] :
                     map (\(name,val) ->
                           Pattern ("Keysym_" ++ name)
                                   Nothing
                                   ("= Keysym " ++ show val))
                         defs
#else

import System.IO

generateSource :: FilePath -> IO ()
generateSource outFile = withFile outFile WriteMode $ \handle -> do
    hPutStrLn handle "module Text.XkbCommon.KeysymPatterns where"

#endif

sourceLoc :: FilePath
sourceLoc = "./"

#if MIN_VERSION_base(4, 10, 0)
preProc :: BuildInfo -> LocalBuildInfo -> ComponentLocalBuildInfo  -> PreProcessor
preProc _ _ _ = PreProcessor
#else
preProc :: BuildInfo -> LocalBuildInfo -> PreProcessor
preProc _ _ = PreProcessor
#endif
    { platformIndependent = True
    , runPreProcessor = mkSimplePreProcessor $ \_ outFile verbosity ->
        generateSource outFile
    }

main :: IO ()
main = defaultMainWithHooks simpleUserHooks
    { hookedPreProcessors = [("empty", preProc)]
    }
