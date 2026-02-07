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
      # WEB
      prettier
      # AI
      github-copilot-cli
      copilot-language-server
      elinks
    ];
  };
}
