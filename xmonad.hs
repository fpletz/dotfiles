import XMonad
import XMonad.Operations

import Graphics.X11.Xlib

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Ratio ((%))

import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Reflect
import XMonad.Layout.DwmStyle
import XMonad.Layout.TwoPane
import XMonad.Layout.ComboP

import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import XMonad.Prompt.RunOrRaise

import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer

import XMonad.Util.Run
import XMonad.Util.Scratchpad

import XMonad.Actions.NoBorders
import XMonad.Actions.DynamicWorkspaces
import qualified XMonad.Actions.FlexibleResize as Flex

import XMonad.Layout.WindowArranger

import System.IO
import System ( getArgs )

import XMonad.Hooks.ManageHelpers
import Control.Monad
import Data.Monoid (All (All))

-- Helper functions to fullscreen the window
fullFloat, tileWin :: Window -> X ()
fullFloat w = windows $ W.float w r
    where r = W.RationalRect 0 0 1 1
tileWin w = windows $ W.sink w

evHook :: Event -> X All
evHook (ClientMessageEvent _ _ _ dpy win typ dat) = do
  state <- getAtom "_NET_WM_STATE"
  fullsc <- getAtom "_NET_WM_STATE_FULLSCREEN"
  isFull <- runQuery isFullscreen win

  -- Constants for the _NET_WM_STATE protocol
  let remove = 0
      add = 1
      toggle = 2

      -- The ATOM property type for changeProperty
      ptype = 4

      action = head dat

  when (typ == state && (fromIntegral fullsc) `elem` tail dat) $ do
    when (action == add || (action == toggle && not isFull)) $ do
         io $ changeProperty32 dpy win state ptype propModeReplace [fromIntegral fullsc]
         fullFloat win
    when (head dat == remove || (action == toggle && isFull)) $ do
         io $ changeProperty32 dpy win state ptype propModeReplace []
         tileWin win

  -- It shouldn't be necessary for xmonad to do anything more with this event
  return $ All False

evHook _ = return $ All True

main = do
    xmobar <- spawnPipe ( "xmobar" )
    xmonad $ myConfig xmobar

myConfig h = withUrgencyHook NoUrgencyHook $ defaultConfig
       { borderWidth        = 1
       , terminal           = "urxvt"
       , workspaces         = ["sh", "code", "www", "im", "@" ]
                              ++ map show [6 .. 8 :: Int]
                              ++ ["m"]
       , modMask            = mod4Mask
       , normalBorderColor  = "#ccc"
       , focusedBorderColor = "#05c"
       , focusFollowsMouse  = True
       , logHook            = (dynamicLogWithPP $ myPP h) >>
				updatePointer (Relative 0.5 0.5)
       , keys               = \c -> myKeys c `M.union` keys defaultConfig c
       , mouseBindings      = myMouseBindings
       , manageHook         = manageDocks <+> manageHook defaultConfig <+> myManageHook
       , layoutHook         = myLayouts
       , handleEventHook    = evHook
       , startupHook        = setWMName "LG3D"
       }
  where
    myKeys (XConfig {modMask = modm}) = M.fromList $
      [
      -- rotate workspaces
      ((modm .|. controlMask, xK_Right), nextWS)
      , ((modm .|. controlMask, xK_Left), prevWS)

      -- switch to previous workspace
      , ((modm, xK_z), toggleWS)

      , ((modm .|. shiftMask, xK_b),   withFocused toggleBorder)

      -- lock the screen with xtrlock
      , ((modm .|. shiftMask, xK_l), spawn "xlock")
      , ((0, 0x1008ff2d), spawn "xlock")

      -- some programs to start with keybindings.
      , ((modm .|. shiftMask, xK_f), spawn "iceweasel")
      , ((modm .|. shiftMask, xK_g), spawn "/home/fpletz/gajim/launch.sh")
      , ((modm .|. shiftMask, xK_m), spawn "claws-mail")

      -- prompts
      , ((modm .|. shiftMask, xK_s), sshPrompt defaultXPConfig)
      , ((modm .|. controlMask, xK_x), xmonadPrompt defaultXPConfig)
      , ((modm, xK_x), runOrRaisePrompt defaultXPConfig)
      --, ((modm, xK_s), scratchpadSpawnAction defaultConfig)
      
      , ((0, 0x1008ff12), spawn "amixer sset 'PCM' 0%")
      , ((0, 0x1008ff11), spawn "amixer sset 'PCM' 5%-")
      , ((0, 0x1008ff13), spawn "amixer sset 'PCM' 5%+")
      , ((modm, 0x1008ff12), spawn "amixer sset 'Master' 0%")
      , ((modm, 0x1008ff11), spawn "amixer sset 'Master' 5%-")
      , ((modm, 0x1008ff13), spawn "amixer sset 'Master' 5%+")

      -- window navigation keybindings.
      , ((modm,               xK_Right), sendMessage $ Go R)
      , ((modm,               xK_Left ), sendMessage $ Go L)
      , ((modm,               xK_Up   ), sendMessage $ Go U)
      , ((modm,               xK_Down ), sendMessage $ Go D)
      , ((modm .|. shiftMask, xK_Right), sendMessage $ Swap R)
      , ((modm .|. shiftMask, xK_Left ), sendMessage $ Swap L)
      , ((modm .|. shiftMask, xK_Up   ), sendMessage $ Swap U)
      , ((modm .|. shiftMask, xK_Down ), sendMessage $ Swap D)

      -- alarm
      , ((0            , 0x1008ff41), spawn "aplay /home/fpletz/augustiner.wav")
      , ((modm         , 0x1008ff41), spawn "aplay /home/fpletz/Downloads/alarm/alarm1.wav")
      , ((controlMask  , 0x1008ff41), spawn "aplay /home/fpletz/Downloads/alarm/alarm2.wav")
      , ((shiftMask    , 0x1008ff41), spawn "aplay /home/fpletz/Downloads/alarm/alarm0.wav")
      ]

    myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
        [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)) -- set the window to floating mode and move by dragging
        , ((modMask, button2), (\w -> focus w >> windows W.shiftMaster)) -- raise the window to the top of the stack
        , ((modMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) -- set the window to floating mode and resize by dragging
        , ((modMask, button4), (\_ -> prevWS)) -- switch to previous workspace
        , ((modMask, button5), (\_ -> nextWS)) -- switch to next workspace
        ]

    myManageHook :: ManageHook
    myManageHook = composeAll (
            [ className   =? "Gajim.py"           --> doShift "im"
            , className   =? "Iceweasel"          --> doShift "www"
            , className   =? "Chromium-browser"   --> doShift "www"
            , className   =? "Quodlibet"          --> doShift "m"
            , className   =? "Claws-mail"         --> doShift "@"
            ]
            ++ [ className =? c --> doFloat | c <- myFloats ])
      where myFloats = ["Volume", "XClock", "Network-admin", "frame", "MPlayer", "Pinentry-gtk-2", "Wicd-client.py"]

    myPP h = defaultPP { ppCurrent         = xmobarColor "#cc0000" ""
                       , ppVisible         = xmobarColor "#a00000" ""
                       , ppHiddenNoWindows = \wsId ->
                                    if (reads wsId :: [(Int, String)]) == []
                                        then wsId
                                        else xmobarColor "#777" "" wsId
                       , ppSep             = xmobarColor "#666" "" "]["
                       , ppUrgent	   = xmobarColor "#fff" "" . \wsId -> wsId ++ "*"
                       , ppTitle           = shorten 45
                       , ppWsSep           = xmobarColor "#666" "" "|"
                       , ppLayout          = xmobarColor "#15d" "" . (\x -> pad $ case x of
                                                "Full"                 -> "F"
                                                "DwmStyle Tall"        -> "DT"
                                                "DwmStyle Mirror Tall" -> "DMT"
                                                "Tabbed Bottom Simplest" -> "TB"
                                                "combining Tabbed Bottom Simplest and Full with TwoPane using Not (Role \"gimp-toolbox\")" -> "G"
                                                _                      -> x)
                       , ppOrder           = reverse
                       , ppOutput          = hPutStrLn h
                       }

    myLayouts = avoidStruts $ smartBorders
           -- $ onWorkspace "im" (IM (1%6) (Role "roster"))
              $ onWorkspaces ["www","@","m"] (Full ||| tabbedLayout)
              $ (dwmLayout $ tiled ||| Mirror tiled) ||| Full ||| gimpLayout
            where
                 tiled   = Tall nmaster delta ratio
                 nmaster = 1
                 delta   = 3/100
                 ratio   = 1/2

                 myTheme = defaultTheme
                 dwmLayout = dwmStyle shrinkText myTheme
                 tabbedLayout = tabbedBottomAlways shrinkText myTheme
                 gimpLayout = combineTwoP (TwoPane 0.04 0.82) (tabbedLayout) (Full) (Not (Role "gimp-toolbox"))

