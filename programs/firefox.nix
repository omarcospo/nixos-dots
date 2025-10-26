{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/xml" = "firefox.desktop";
  };
}
