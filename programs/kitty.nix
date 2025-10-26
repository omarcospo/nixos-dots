{
  inputs,
  config,
  lib,
  pkgs,
  fileset,
  ...
}: {
  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkMedium";
    font = {
      name = "Iosevka Nerd Font Regular";
      size = 15;
    };
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      scrollback_lines = 1000;
      editor = "nvim";
    };
  };
}
