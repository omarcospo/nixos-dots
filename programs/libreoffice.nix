{
  inputs,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.pt_BR
  ];
}
