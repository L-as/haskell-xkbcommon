import Control.Arrow
import Distribution.PackageDescription
import Distribution.Simple hiding (Module)
import Distribution.Simple.PreProcess
import Distribution.Simple.LocalBuildInfo
import Language.Preprocessor.Cpphs
import System.FilePath

import Text.XkbCommon.ParseDefines

import Module
import Utils

sourceLoc :: FilePath
sourceLoc = "./"

preProc :: BuildInfo -> LocalBuildInfo -> PreProcessor
preProc _ _ = PreProcessor
    { platformIndependent = True
    , runPreProcessor = mkSimplePreProcessor $ \_ outFile verbosity ->
        generateSource outFile
    }

main :: IO ()
main = defaultMainWithHooks simpleUserHooks
    { hookedPreProcessors = [("empty", preProc)]
    }

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
