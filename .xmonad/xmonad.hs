-- -*- haskell -*-

module Main (main) where

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig

myManageHook = composeAll
   [ className =? "Firefox"   --> doShift "9"
   , className =? "trayer"     --> doShift "9"
   , className =? "trayer"     --> doFloat
--, className =? "Xmessage"  --> doFloat
--   , manageDocks
   ]

main :: IO ()
main = do
    xmonad $ defaultConfig
     { terminal    = "lxterminal"
     , modMask     = mod4Mask
     , borderWidth = 1
     , workspaces  = ["1:www","2:term","3:emacs","4","5","6","7","8","9","0","-:selenium","=:tmp"]
     , manageHook  = myManageHook <+> manageHook defaultConfig
     }
     `additionalKeys`
     [((0, 0x1008ff2d), spawn "sh -c 'xscreensaver-command -l && sudo /usr/sbin/pm-suspend'")
     ]
 
