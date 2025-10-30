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
      # BUILDING DEPENDENCIES
      gnumake
      ninja
      gcc
      binutils
      nodejs
      gcc
      bun
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
      # LUA
      lua
      stylua
      lua-language-server
      # PYTHON
      uv
      python314
      ruff
      # Markdown
      marksman
      #AI
      github-copilot-cli
      copilot-language-server
      sqlite
      elinks
    ];
  };
}
