{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  importDir = dir: let
    files = builtins.readDir dir;
    nixFiles =
      builtins.filter (name: builtins.match ".*\\.nix" name != null)
      (builtins.attrNames files);
  in
    map (file: dir + "/${file}") nixFiles;
in {
  home.username = "nix";
  home.homeDirectory = "/home/nix";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports =
    (importDir ./programs)
    ++ [
      ./session/niri.nix
    ];

  xdg.mimeApps.enable = true;
  xdg.configFile."mimeapps.list".force = true;

  # Environment and variables
  home.sessionVariables = {
    BROWSER = "firefox";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    EDITOR = "nvim";
    VISUAL = "nvim";
    QT_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    NIXOS_OZONE_WL = "1";
  };
}
