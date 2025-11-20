{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dynamic_title = true;
        decorations = "none";
        opacity = 0.96;
        padding = {
          x = 0;
          y = 0;
        };
      };

      selection = {
        save_to_clipboard = true;
      };

      mouse = {
        hide_when_typing = false;
        bindings = [
          {
            mouse = "Right";
            mods = "Control";
            action = "Paste";
          }
          {
            mouse = "Right";
            action = "Copy";
          }
        ];
      };

      keyboard = {
        bindings = [
          {
            action = "CreateNewWindow";
            key = "N";
            mods = "Control|Shift";
          }
        ];
      };

      font = {
        glyph_offset = {
          x = 0;
          y = 0;
        };
        size = 15.0;
        builtin_box_drawing = true;
        offset = {
          x = 0;
          y = 0;
        };
        normal = {
          family = "Iosevka Nerd Font";
          style = "Regular";
        };
      };

      cursor = {
        style = "Underline";
        unfocused_hollow = false;
      };

      colors = {
        # Primary
        primary = {
          background = "#1D1D20"; # libadwaita_dark_alt
          foreground = "#FCFCFC"; # light_2
        };

        # Cursor
        cursor = {
          text = "#242428";
          cursor = "#FCFCFC";
        };

        # Normal colours
        normal = {
          black = "#242424"; # dark_5
          red = "#ED333B"; # red_2
          green = "#2EC27E"; # green_4
          yellow = "#FD983E"; # yellow_4
          blue = "#3584E4"; # blue_3
          magenta = "#9141AC"; # purple_3
          cyan = "#26A1A2"; # teal_4
          white = "#DEDDDA"; # light_4
        };

        # Bright colours
        bright = {
          black = "#5E5E5E"; # dark_2
          red = "#F66151"; # red_1
          green = "#57E389"; # green_2
          yellow = "#F9F06B"; # yellow_1
          blue = "#62A0EA"; # blue_2
          magenta = "#C061CB"; # purple_2
          cyan = "#5BC8AF"; # teal_2
          white = "#FFFFFF"; # light_1
        };

        # Optional dim colours (comment out if unused)
        dim = {
          black = "#121212"; # dark_6
          red = "#C01C28"; # red_4
          green = "#26A269"; # green_5
          yellow = "#E5A50A"; # yellow_5
          blue = "#1C71D8"; # blue_4
          magenta = "#813D9C"; # purple_4
          cyan = "#218787"; # teal_5
          white = "#B0AFAC"; # light_6
        };
      };
    };
  };
}
