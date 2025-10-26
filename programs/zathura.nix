{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zathura = {
    enable = true;
    options = {
      "adjust-open" = "width";
      "window-title-basename" = "true";
      "selection-clipboard" = "clipboard";
      "guioptions" = "none";
      "pages-per-row" = "1";
      "scroll-page-aware" = "true";
      "scroll-full-overlap" = "0.01";
      "scroll-step" = "40";
      "font" = "Noto Sans Regular 11";
    };
    mappings = {
      "<Space>" = "focus_inputbar /";
      "d" = "scroll half-down";
      "u" = "scroll half-up";
      "<C-d>" = "toggle_page_mode";
      "<C-r>" = "rotate";
      "<C-k>" = "zoom in";
      "<C-j>" = "zoom out";
      "<C-i>" = "toggle_statusbar";
      "<C-a>" = "mark_add";
      "<C-w>" = "toggle_index";
      "r" = "reload";
      "i" = "recolor";
      "p" = "print";
    };
    extraConfig = ''
      set notification-error-bg     "#ff5555" # Red
      set notification-error-fg     "#f8f8f2" # Foreground
      set notification-warning-bg   "#ffb86c" # Orange
      set notification-warning-fg   "#44475a" # Selection
      set notification-bg           "#282828" # Background
      set notification-fg           "#f8f8f2" # Foreground
      # --------------------------------------------------
      set completion-bg             "#282828" # Background
      set completion-fg             "#6272a4" # Comment
      set completion-group-bg       "#282828" # Background
      set completion-group-fg       "#6272a4" # Comment
      set completion-highlight-bg   "#44475a" # Selection
      set completion-highlight-fg   "#f8f8f2" # Foreground
      # --------------------------------------------------
      set index-bg                  "#282828" # Background
      set index-fg                  "#f8f8f2" # Foreground
      set index-active-bg           "#44475a" # Current Line
      set index-active-fg           "#f8f8f2" # Foreground
      # --------------------------------------------------
      set inputbar-bg               "#282828" # Background
      set inputbar-fg               "#f8f8f2" # Foreground
      set statusbar-bg              "#282828" # Background
      set statusbar-fg              "#f8f8f2" # Foreground
      # --------------------------------------------------
      set highlight-color           "#ffb86c" # Orange
      set highlight-active-color    "#ff79c6" # Pink
      # --------------------------------------------------
      set render-loading            true
      set render-loading-fg         "#282828" # Background
      set render-loading-bg         "#bbc2cf" # Foreground
      # --------------------------------------------------
      set default-fg                "#C9C1B5" # Foreground
      set recolor-darkcolor         "#C9C1B5" # Font in dark-mode
      set default-bg                "#282828" # Background
      set recolor-lightcolor        "#282828" # Background in dark-mode
    '';
  };
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
    "application/epub+zip" = "org.pwmt.zathura.desktop";
    "application/x-pdf" = "org.pwmt.zathura.desktop";
    "application/postscript" = "org.pwmt.zathura.desktop";
  };
}
