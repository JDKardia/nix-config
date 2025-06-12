_:
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
            #{{{
      # ################################################################ #
      # THE FOLLOWING IS AN EXPLANATION OF THE GRAMMAR THAT SKHD PARSES. #
      # FOR SIMPLE EXAMPLE MAPPINGS LOOK FURTHER DOWN THIS FILE..        #
      # ################################################################ #

      # A list of all built-in modifier and literal keywords can
      # be found at https://github.com/koekeishiya/skhd/issues/1
      #
      # A hotkey is written according to the following rules:
      #
      #   hotkey       = <mode> '<' <action> | <action>
      #
      #   mode         = 'name of mode' | <mode> ',' <mode>
      #
      #   action       = <keysym> '[' <proc_map_lst> ']' | <keysym> '->' '[' <proc_map_lst> ']'
      #                  <keysym> ':' <command>          | <keysym> '->' ':' <command>
      #                  <keysym> ';' <mode>             | <keysym> '->' ';' <mode>
      #
      #   keysym       = <mod> '-' <key> | <key>
      #
      #   mod          = 'modifier keyword' | <mod> '+' <mod>
      #
      #   key          = <literal> | <keycode>
      #
      #   literal      = 'single letter or built-in keyword'
      #
      #   keycode      = 'apple keyboard kVK_<Key> values (0x3C)'
      #
      #   proc_map_lst = * <proc_map>
      #
      #   proc_map     = <string> ':' <command> | <string>     '~' |
      #                  '*'      ':' <command> | '*'          '~'
      #
      #   string       = '"' 'sequence of characters' '"'
      #
      #   command      = command is executed through '$SHELL -c' and
      #                  follows valid shell syntax. if the $SHELL environment
      #                  variable is not set, it will default to '/bin/bash'.
      #                  when bash is used, the ';' delimeter can be specified
      #                  to chain commands.
      #
      #                  to allow a command to extend into multiple lines,
      #                  prepend '\' at the end of the previous line.
      #
      #                  an EOL character signifies the end of the bind.
      #
      #   ->           = keypress is not consumed by skhd
      #
      #   *            = matches every application not specified in <proc_map_lst>
      #
      #   ~            = application is unbound and keypress is forwarded per usual, when specified in a <proc_map>
      #
      # A mode is declared according to the following rules:
      #
      #   mode_decl = '::' <name> '@' ':' <command> | '::' <name> ':' <command> |
      #               '::' <name> '@'               | '::' <name>
      #
      #   name      = desired name for this mode,
      #
      #   @         = capture keypresses regardless of being bound to an action
      #
      #   command   = command is executed through '$SHELL -c' and
      #               follows valid shell syntax. if the $SHELL environment
      #               variable is not set, it will default to '/bin/bash'.
      #               when bash is used, the ';' delimeter can be specified
      #               to chain commands.
      #
      #               to allow a command to extend into multiple lines,
      #               prepend '\' at the end of the previous line.
      #
      #               an EOL character signifies the end of the bind.
      #}}}
      #{{{
      #############
      # MODIFIERS #
      #############

      # fn

      # cmd
      # lcmd
      # rcmd

      # shift
      # lshift
      # rshift

      # alt
      # lalt
      # ralt

      # ctrl
      # lctrl
      # rctrl

      # hyper (cmd + shift + alt + ctrl)

      # meh (shift + alt + ctrl)

      ############
      # LITERALS #
      ############
      # "return"     (kVK_Return)
      # "tab"        (kVK_Tab)
      # "space"      (kVK_Space)
      # "backspace"  (kVK_Delete)
      # "escape"     (kVK_Escape)

      # The following keys can not be used with the fn-modifier:

      # "delete"     (kVK_ForwardDelete)
      # "home"       (kVK_Home)
      # "end"        (kVK_End)
      # "pageup"     (kVK_PageUp)
      # "pagedown"   (kVK_PageDown)
      # "insert"     (kVK_Help)
      # "left"       (kVK_LeftArrow)
      # "right"      (kVK_RightArrow)
      # "up"         (kVK_UpArrow)
      # "down"       (kVK_DownArrow)
      # "f1"         (kVK_F1)
      # "f2"         (kVK_F2)
      # "f3"         (kVK_F3)
      # "f4"         (kVK_F4)
      # "f5"         (kVK_F5)
      # "f6"         (kVK_F6)
      # "f7"         (kVK_F7)
      # "f8"         (kVK_F8)
      # "f9"         (kVK_F9)
      # "f10"        (kVK_F10)
      # "f11"        (kVK_F11)
      # "f12"        (kVK_F12)
      # "f13"        (kVK_F13)
      # "f14"        (kVK_F14)
      # "f15"        (kVK_F15)
      # "f16"        (kVK_F16)
      # "f17"        (kVK_F17)
      # "f18"        (kVK_F18)
      # "f19"        (kVK_F19)
      # "f20"        (kVK_F20)

      # "sound_up"          (NX_KEYTYPE_SOUND_UP)
      # "sound_down"        (NX_KEYTYPE_SOUND_DOWN)
      # "mute"              (NX_KEYTYPE_MUTE)
      # "play"              (NX_KEYTYPE_PLAY)
      # "previous"          (NX_KEYTYPE_PREVIOUS)
      # "next"              (NX_KEYTYPE_NEXT)
      # "rewind"            (NX_KEYTYPE_REWIND)
      # "fast"              (NX_KEYTYPE_FAST)
      # "brightness_up"     (NX_KEYTYPE_BRIGHTNESS_UP)
      # "brightness_down"   (NX_KEYTYPE_BRIGHTNESS_DOWN)
      # "illumination_up"   (NX_KEYTYPE_ILLUMINATION_UP)
      # "illumination_down" (NX_KEYTYPE_ILLUMINATION_DOWN)
      #################################################################################
      #}}}

      # System Hotkeys I want to kill
      cmd - h:
      cmd - w:

      # quick hotkeys
      hyper - r : yabai --restart-service && skhd --restart-service

      # toggle window zoom
      # alt - d : yabai -m window --toggle zoom-parent
      # alt - f : yabai -m window --toggle zoom-fullscreen
      ctrl + alt + cmd - f: yabai -m window --toggle zoom-fullscreen

      # quick start commands
      # ctrl + alt + cmd - return : bash ~/.config/skhd/new-term.sh
      ctrl + alt + cmd - return : osascript -e 'tell application "iTerm2" to create window with default profile'
      #ctrl + alt + cmd - return : open -na kitty

      ctrl + alt + cmd + shift - return : open -na "Google Chrome" --args --new-window

      # execute scripts
      rctrl + ralt + rcmd + lshift - a : ~/bin/textshot
      rctrl + ralt + rcmd + lshift - s : ~/bin/screenshot

      # window tree operations
      ctrl + alt + cmd - t : yabai -m window --toggle split
      ctrl + alt + cmd - r : yabai -m space --balance
      # 270 -> clockwise, 90 -> widdershins
      ctrl + alt + cmd - w : yabai -m space --rotate 270
      ctrl + alt + cmd - c : yabai -m space --rotate 90
      ctrl + alt + cmd + shift - f : yabai -m window --toggle float

      ctrl + alt + cmd - s : yabai -m space --layout stack
      ctrl + alt + cmd - b : yabai -m space --layout bsp

      #move focus east,north,west, or south
      ctrl + alt + cmd - h : yabai -m window --focus west || yabai -m display --focus west
      ctrl + alt + cmd - j : yabai -m window --focus stack.next || yabai -m window --focus south || yabai -m display --focus south
      ctrl + alt + cmd - k : yabai -m window --focus stack.prev || yabai -m window --focus north || yabai -m display --focus north
      ctrl + alt + cmd - l : yabai -m window --focus east || yabai -m display --focus east
      #move window east,north,west, or south
      ctrl + alt + cmd + shift - h : yabai -m window --warp west || $(yabai -m window --display west; yabai -m display --focus west)
      ctrl + alt + cmd + shift - j : yabai -m window --warp south || $(yabai -m window --display south; yabai -m display --focus south)
      ctrl + alt + cmd + shift - k : yabai -m window --warp north || $(yabai -m window --display north; yabai -m display --focus north)
      ctrl + alt + cmd + shift - l : yabai -m window --warp east || $(yabai -m window --display east; yabai -m display --focus east)

      # move window to workspace
      rctrl + ralt + rcmd + lshift - 1 : yabai -m window --space 1
      rctrl + ralt + rcmd + lshift - 2 : yabai -m window --space 2
      rctrl + ralt + rcmd + lshift - 3 : yabai -m window --space 3
      rctrl + ralt + rcmd + lshift - 4 : yabai -m window --space 4
      rctrl + ralt + rcmd + lshift - 5 : yabai -m window --space 5
      rctrl + ralt + rcmd + lshift - 6 : yabai -m window --space 6
      rctrl + ralt + rcmd + lshift - 7 : yabai -m window --space 7
      rctrl + ralt + rcmd + lshift - 8 : yabai -m window --space 8
      rctrl + ralt + rcmd + lshift - 9 : yabai -m window --space 9
      rctrl + ralt + rcmd + lshift - 0 : yabai -m window --space 10
      rctrl + ralt + rcmd + lshift - 0x1B : yabai -m window --space 11
      rctrl + ralt + rcmd + lshift - 0x18 : yabai -m window --space 12
    '';
  };
}
