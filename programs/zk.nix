{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zk = {
    enable = true;
    settings = {
      notebook = {
        dir = "~/Documents/Notes/";
      };
    };
  };
}
