{
  config,
  pkgs,
  ...
}: {
  programs.yt-dlp = {
    enable = true;
    settings = {
      add-metadata = true;
      embed-subs = true;
      embed-thumbnail = true;
      merge-output-format = "mkv";
      output = "'(%(uploader)s) %(title)s.%(ext)s'";
      S = "res:1920";
    };
  };
}
