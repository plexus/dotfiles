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


import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile
import XMonad.Layout.Grid

import qualified XMonad.StackSet as W

-- For full screen in Chromium
-- import XMonad.Hooks.EwmhDesktops

-- http://xmonad.org/xmonad-docs/xmonad/XMonad-Layout.html

defaultLayout = wide ||| tall ||| Grid ||| noBorders Full ||| StackTile 1 (3/100) (1/2) ||| stack_mirror
  where
    tall = Tall 1 (3/100) (1/2)
    wide = Mirror $ Tall 1 (3/100) (1/2)
    stack_mirror = Mirror $ StackTile 1 (3/100) (1/2)

gapLayout = gaps [(D,26)] $ -- gap at the bottom (L,R,D,U) for trayer
            defaultLayout

-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-PerWorkspace.html
myLayoutHook = onWorkspace "9" gapLayout $
               defaultLayout

-- use xprop | grep WM_CLASS to find the className

myManageHook = composeAll
   [ -- className =? "Firefox"   --> doShift "9"
     --,
     className =? "trayer"    --> doShift "9"
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
     , borderWidth = 0
     , focusedBorderColor = "#E00078"
     , workspaces  = ["1:www","2:term","3:emacs","4","5","6","7","8","9","0","-:selenium","=:tmp"]
     , manageHook  = myManageHook <+> manageHook defaultConfig
     , layoutHook  = myLayoutHook
     , handleEventHook = fullscreenEventHook
     }
     `additionalKeysP`
     [-- ("M-j", windows $ W.greedyView "3")
      ("C-.", spawn "suspend_record")
     , ("C-,", spawn "resume_record")
     ]
     `additionalKeys`
     [-- ((controlMask, xK_Print), spawn "sleep 1; scrot")
       ((controlMask, xK_Print), spawn "xdotool click 1")
     , ((0, xK_Print), spawn "scrot")
     ]

     -- [((0, 0x1008ff2d), spawn "sh -c 'xscreensaver-command -l && sudo /usr/sbin/pm-suspend'")]
