{
  inputs,
  config,
  pkgs,
  ...
}: let
  emacsWithDeps = pkgs.writeShellApplication {
    name = "emacs";
    runtimeInputs = with pkgs; [
      gnumake
      ninja
      gcc
      binutils
      nodejs
      bun
      #python
      python314
      ruff
      #csharp
      dotnet-sdk_9
      roslyn
      roslyn-ls
      csharp-ls
      csharpier
      #TYPST
      typst
      typstyle
      tinymist
      #NIX
      alejandra
    ];
    text = ''
      exec ${pkgs.emacs-unstable-nox}/bin/emacs "$@"
    '';
  };
in {
  home.packages = [emacsWithDeps];

  xdg.desktopEntries.emacs = {
    name = "Emacs";
    genericName = "Text Editor";
    comment = "Edit text";
    exec = "${emacsWithDeps}/bin/emacs %F";
    icon = "emacs";
    terminal = false;
    type = "Application";
    categories = ["Development" "TextEditor"];
    mimeType = [
      "text/plain"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-java"
      "text/x-tex"
    ];
  };
}
