import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll [
    className =? "Gimp" --> doFloat,
    className =? "Vncviewer" --> doFloat
               ]

main = do

 xmproc <- spawnPipe "/home/ews/bin/xmobar-0.9.bin /home/ews/.xmonad/xmobar"
 xmonad $ defaultConfig {
        manageHook = manageDocks <+> manageHook defaultConfig,
        layoutHook = avoidStruts  $  layoutHook defaultConfig,
        logHook = dynamicLogWithPP $ xmobarPP {
                    ppOutput = hPutStrLn xmproc
                  , ppTitle = xmobarColor "green" "" . shorten 50
                  },
        modMask = mod4Mask     -- Rebind Mod to the Windows key
      } `additionalKeys`
      [((mod4Mask .|. shiftMask, xK_z),
        spawn "xscreensaver-command -lock"),
       ((controlMask, xK_Print), spawn "scrot -s"),
       ((0, xK_Print), spawn "scrot")
      ]

