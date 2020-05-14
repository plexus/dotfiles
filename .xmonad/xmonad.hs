-- -*- haskell -*-

-- mod-q to reload

-- http://www.nepherte.be/step-by-step-configuration-of-xmonad/
-- http://joeyh.name/blog/entry/xmonad_layouts_for_netbooks/

module Main (main) where

import XMonad
-- import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Gaps

import XMonad.Layout.NoBorders
-- import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile
import XMonad.Layout.Grid
import XMonad.Layout.LayoutBuilder
import XMonad.Layout.Tabbed

import qualified XMonad.StackSet as W

-- For full screen in Chromium / wmctrl compatibility
-- import XMonad.Hooks.EwmhDesktops

import XMonad.Config.Desktop

-- http://xmonad.org/xmonad-docs/xmonad/XMonad-Layout.html

wideLayout = Mirror $ Tall 1 (3/100) (1/2)

defaultLayout = wideLayout ||| tall ||| Grid ||| noBorders Full ||| StackTile 1 (3/100) (1/2) ||| stack_mirror
  where
    tall = Tall 1 (3/100) (1/2)
    stack_mirror = Mirror $ StackTile 1 (3/100) (1/2)

gapLayout = gaps [(U,30)] $ -- gap at the bottom (L,R,D,U) for trayer
            defaultLayout

recordLayout = ( (layoutN 1              -- number of windows
                   (absBox 0 0 1280 720) -- position & size
                   Nothing               -- Possibly an alternative box that is
                                         -- used when this layout handles all
                                         -- windows that are left
                   $ Full)
                 $ (layoutN 1 (absBox 0 720 1280 (1080 - 720)) Nothing $ Full)
                 $ (layoutAll (absBox 1280 0 (1920 - 1280) 1080) $ wideLayout))

-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-PerWorkspace.html
myLayoutHook = onWorkspace "9" gapLayout
               $ onWorkspace "3:emacs" (defaultLayout ||| recordLayout)
               $ onWorkspace "4" (simpleTabbed ||| defaultLayout)
               $ defaultLayout

-- use xprop | grep WM_CLASS to find the className

myManageHook = composeAll
   [ -- className =? "Firefox"   --> doShift "9"
     --,
     className =? "trayer"         --> doShift "9"
   , className =? "trayer"         --> doFloat
   , className =? "Xfce4-panel"    --> doShift "9"
   , className =? "Xfce4-panel"    --> doFloat
   , className =? "Emacs"          --> doShift "3:emacs"
   , resource  =? "desktop_window" --> doIgnore
   , className =? "Xmessage"       --> doFloat
   , className =? "Viewnior" --> doFloat
   , className =? "java-lang-Thread" --> doFloat
   --, manageDocks
   ]

main :: IO ()
main = do
    xmonad $ defaultConfig
    -- xmonad $ ewmh $ defaultConfig
    -- xmonad $ desktopConfig
     { terminal    = "gnome-terminal"
     , modMask     = mod4Mask
     , borderWidth = 0
     , focusedBorderColor = "#E00078"
     -- , workspaces = ["1:www","2:term","3:emacs","4","5","6","7","8","9","0","-:selenium","=:tmp"]
     --, manageHook  = myManageHook <+> manageHook defaultConfig
     --, layoutHook  = myLayoutHook
     --, handleEventHook = fullscreenEventHook
     }
     -- `additionalKeysP`
     -- [-- ("M-j", windows $ W.greedyView "3")
     --  ("C-.", spawn "suspend_record")
     -- , ("C-,", spawn "resume_record")
     -- , ("<XF86MonBrightnessUp>", spawn "ruby /home/arne/bin/backlight +5")
     -- , ("<XF86MonBrightnessDown>", spawn "ruby /home/arne/bin/backlight -5")
     -- , ("<XF86AudioRaiseVolume>", spawn "amixer -D pulse sset Master 1%+")
     -- , ("<XF86AudioLowerVolume>", spawn "amixer -D pulse sset Master 1%-")
     -- , ("<XF86AudioMute>", spawn "amixer -q -D pulse sset Master toggle")
     -- ]
     `additionalKeys`
     [((mod4Mask, xK_p), spawn "dmenu_run")
     --, ((mod4Mask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
     ]
     -- [-- ((controlMask, xK_Print), spawn "sleep 1; scrot")
     --   ((controlMask, xK_Print), spawn "xdotool click 1")
     -- , ((0, xK_Print), spawn "scrot")
     -- ]

     -- [((0, 0x1008ff2d), spawn "sh -c 'xscreensaver-command -l && sudo /usr/sbin/pm-suspend'")]
