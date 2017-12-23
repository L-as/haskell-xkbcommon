{-# LANGUAGE TemplateHaskell, PatternSynonyms #-}
module Text.XkbCommon.KeysymPatterns where

import Text.XkbCommon.InternalTypes
import Text.XkbCommon.ParseDefines

$(getKeysymPats)
