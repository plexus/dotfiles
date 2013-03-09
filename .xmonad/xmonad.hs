-- -*- haskell -*-

-- mod-q to reload

-- http://www.nepherte.be/step-by-step-configuration-of-xmonad/
-- http://joeyh.name/blog/entry/xmonad_layouts_for_netbooks/

module Main (main) where

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Gaps

-- http://xmonad.org/xmonad-docs/xmonad/XMonad-Layout.html

defaultLayout = tall ||| wide ||| Full 
  where
    tall = Tall 1 (3/100) (1/2)
    wide = Mirror $ Tall 1 (3/100) (1/2)

gapLayout = gaps [(D,26)] $ -- gap at the bottom (L,R,D,U) for trayer
            defaultLayout 

-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-PerWorkspace.html
myLayoutHook = onWorkspace "9" gapLayout $ 
               defaultLayout

-- use xprop | grep WM_CLASS to find the className

myManageHook = composeAll
   [ className =? "Firefox"   --> doShift "9"
   , className =? "trayer"    --> doShift "9"
   , className =? "trayer"    --> doFloat
   , className =? "Emacs"     --> doShift "3:emacs"
   , resource  =? "desktop_window" --> doIgnore
   , className =? "Xmessage"       --> doFloat
   --, manageDocks
   ]

main :: IO ()
main = do
    xmonad $ defaultConfig
     { terminal    = "gnome-terminal"
     , modMask     = mod4Mask
     , borderWidth = 1
     , workspaces  = ["1:www","2:term","3:emacs","4","5","6","7","8","9","0","-:selenium","=:tmp"]
     , manageHook  = myManageHook <+> manageHook defaultConfig
     , layoutHook  = myLayoutHook
                     
     }
     `additionalKeys`
     [((0, 0x1008ff2d), spawn "sh -c 'xscreensaver-command -l && sudo /usr/sbin/pm-suspend'")
     ]
 


