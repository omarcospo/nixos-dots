{
  inputs,
  config,
  pkgs,
  ...
}: let
  FZF_OPTIONS = "--color=bg+:-1,gutter:-1 --reverse --border --bind ctrl-f:accept,ctrl-h:backward-delete-char";
in {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;

    shellAliases = {
      uh = "home-manager switch --flake ~/.nixos --show-trace -L -v";
      us = "sudo nixos-rebuild switch --flake ~/.nixos --show-trace -L -v";
      uu = "sudo nix flake update --flake ~/.nixos && sudo nixos-rebuild switch --flake ~/.nixos --show-trace -L -v && home-manager switch --flake ~/.nixos --show-trace -L -v";
      ee = "eza -lah";
      qq = "clear";
      ff = "yazi";
      eq = "exit";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
    };

    initContent = ''      # Changed from initContent to initExtra
          # Source extra configuration if it exists
          if [[ -f ~/.config/zsh/extra ]]; then
            source ~/.config/zsh/extra
          fi

          setopt PROMPT_SUBST
          PROMPT='%F{yellow}[%n]%f %~ '

          source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
          source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh

          # Initialize plugins using NixOS module system instead of manual sourcing
          autopair-init

          nix-fetch-sha256() {
            nix-hash --type sha256 --base32 --flat <(curl -o - "$@") | wl-copy
          }

          cd() {
            __zoxide_z "$@" && command eza -lah --color always
          }

          eza() {
            command eza -lah --color always "$@"
          }

          vv() {
            NVIM_APPNAME=nvim nvim "$@"
          }

          vq() {
            local config
            config=$(fd --max-depth 1 --glob 'nvim*' ~/.config | fzf --prompt="  Neovim Config: " --height=~50% --bind=ctrl-f:accept --color=bg+:-1,gutter:-1 --reverse --border)
            if [[ -z "$config" ]]; then
              echo "No config selected"
              return 1
            fi
            NVIM_APPNAME=$(basename "$config") nvim "$@"
          }

          yt-audio() {
            yt-dlp -x --audio-format mp3 --audio-quality 0 --output "%(artist)s - %(title)s.%(ext)s" "$@"
          }

          # Extensions configuration
          ZSH_AUTOSUGGEST_USE_ASYNC=1
          ZSH_AUTOSUGGEST_STRATEGY=(history completion)

          # Initialize zoxide
          eval "$(zoxide init zsh --cmd cd)"  # Explicitly set cd as the command
    '';

    sessionVariables = {
      FZF_DEFAULT_OPTS = FZF_OPTIONS;
      _ZO_FZF_OPTS = FZF_OPTIONS;
      MANWIDTH = "80";
      LESS = "-R";
      LESSHISTFILE = "-";
      LESS_TERMCAP_me = "\e[0m";
      LESS_TERMCAP_se = "\e[0m";
      LESS_TERMCAP_ue = "\e[0m";
      LESS_TERMCAP_us = "\e[32m";
      LESS_TERMCAP_mb = "\e[31m";
      LESS_TERMCAP_md = "\e[31m";
      LESS_TERMCAP_so = "\e[47;30m";
      LESSPROMPT = "?f%f .?ltLine %lt:?pt%pt\%:?btByte %bt:-...";
    };

    setOptions = [
      "CORRECT"
      "EXTENDED_GLOB"
      "NO_NOMATCH"
      "LIST_PACKED"
      "ALWAYS_TO_END"
      "GLOB_COMPLETE"
      "COMPLETE_ALIASES"
      "COMPLETE_IN_WORD"
      "AUTO_CD"
      "AUTO_CONTINUE"
      "LONG_LIST_JOBS"
      "HIST_VERIFY"
      "SHARE_HISTORY"
      "HIST_IGNORE_SPACE"
      "HIST_SAVE_NO_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "TRANSIENT_RPROMPT"
      "INTERACTIVE_COMMENTS"
    ];

    # Add history configuration
    history = {
      size = 1000;
      save = 1000;
      path = "$HOME/.cache/.zsh_history";
      ignoreSpace = true;
      ignoreDups = true;
      share = true;
      expireDuplicatesFirst = true;
    };
  };
}
