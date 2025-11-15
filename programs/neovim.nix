{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      # C#
      roslyn
      roslyn-ls
      csharp-ls
      csharpier
      # TYPST
      typst
      typstyle
      tinymist
      # Nix
      alejandra
      # Lua
      lua
      stylua
      lua-language-server
      # Markdown
      marksman
      # AI
      github-copilot-cli
      copilot-language-server
      sqlite
      elinks
      jq
    ];
  };
}
