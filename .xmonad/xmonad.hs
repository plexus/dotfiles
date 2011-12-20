-- -*- haskell -*-

import XMonad
 
main = do
    xmonad $ defaultConfig
     { terminal    = "gnome-terminal --hide-menubar"
     , modMask = mod4Mask
     , borderWidth = 3
     }