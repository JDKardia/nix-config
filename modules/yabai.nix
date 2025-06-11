_:
{
  services.yabai = {
    enable = false;
    enableScriptingAddition = false;
    config = {
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";

      window_origin_display = "focused";
      window_placement = "second_child";
      window_topmost = "off";
      window_shadow = "off";
      window_opacity = "off";

      window_border = "on";
      window_border_width = 2;
      active_window_border_color = "0xFFd65d0e"; # gruvbox orange
      normal_window_border_color = "0xFF32302f"; # gruvbox bg0_s
      insert_feedback_color = "0xffd75f5f";

      split_ratio = 0.50;
      auto_balance = "off";

      mouse_modifier = "ctrl";
      mouse_action2 = "resize";

      # general space settings
      layout = "bsp";
      top_padding = 2;
      bottom_padding = 2;
      left_padding = 2;
      right_padding = 2;
      window_gap = 0;

    };
    extraConfig = ''
      # Space specific settings
      yabai -m config --space 1 layout stack

      # Don't Manage These
      yabai -m rule --add app="^GIMP$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Finder$" manage=off
      yabai -m rule --add app="^MeetingBar$" manage=off
      yabai -m rule --add app="^Bartender$" manage=off

      # workspace management
      yabai -m space 1  --label todo
      yabai -m space 2  --label productive
      yabai -m space 3  --label chat
      yabai -m space 4  --label utils
      yabai -m space 5  --label code
    '';
  };
}
