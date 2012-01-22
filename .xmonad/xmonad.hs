-- -*- haskell -*-

module Main (main) where

import XMonad
import XMonad.Util.EZConfig

main :: IO ()
main = do
    xmonad $ defaultConfig
     { terminal    = "lxterminal"
     , modMask = mod4Mask
     , borderWidth = 1
     }
     `additionalKeys`
     [((0, 0x1008ff2d), spawn "sh -c 'xscreensaver-command -l && sudo /usr/sbin/pm-suspend'")
     ]
