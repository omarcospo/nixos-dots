{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = "#292929";
        overlay_font = "Iosevka Nerd Font:14";
        overlay_background_alpha = "#FF";
        overlay_background_color = "#292929";
        overlay_text = ''"  $(basename $imv_current_file)" \($imv_width\x$imv_height\)'';
      };
      binds = {
        "<Ctrl+j>" = "zoom -2";
        "<Ctrl+k>" = "zoom 2";
        "<Ctrl+h>" = "flip horizontal";
        "<Ctrl+v>" = "flip vertical";
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/jpg" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/bmp" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/tiff" = "imv.desktop";
  };
}
