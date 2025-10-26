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
      dotnet-sdk
      roslyn
      roslyn-ls
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
    ];
  };
}
