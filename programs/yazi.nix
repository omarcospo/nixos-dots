{
  config,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;

    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      mount = pkgs.yaziPlugins.mount;
      yatline = pkgs.yaziPlugins.yatline;
      no-status = pkgs.yaziPlugins.no-status;
      mime-ext = pkgs.yaziPlugins.mime-ext;
    };

    initLua = ''
      require("mime-ext"):setup()
      require("no-status"):setup()
      require("full-border"):setup()
      require("smart-enter"):setup { open_multi = true }
      require("yatline"):setup({
      	show_background = false,
      	header_line = {
      		left = {
      			section_a = { {type = "string", custom = false, name = "tab_mode"}, },
      			section_b = { {type = "string", custom = false, name = "hovered_size"}, },
      			section_c = {
              {type = "string", custom = false, name = "hovered_path"},
              {type = "coloreds", custom = false, name = "permissions"},
              {type = "coloreds", custom = false, name = "count"},
      			}
      		},
      		right = {
      			section_a = {
      			  {type = "string", custom = false, name = "cursor_position"},
      			  {type = "line", custom = false, name = "tabs", params = {"right"}},
      			},
      			section_b = {  },
      			section_c = { }
      		}
      	},

      	status_line = {
          left = {
           section_a = { },
           section_b = { },
           section_c = { }
          },
          right = {
           section_a = { },
           section_b = { },
           section_c = { }
          }
      	},
      })
    '';

    settings = {
      plugin = {
        prepend_fetchers = [
          {
            id = "mime";
            name = "*";
            run = "mime-ext";
            prio = "high";
          }
        ];
      };

      mgr = {
        ratio = [1 4 3];
        sort_by = "alphabetical";
        sort_dir_first = true;
        scrolloff = 5;
        show_hidden = true;
        show_symlink = true;
      };

      preview = {
        wrap = "no";
        max_width = 600;
        max_height = 900;
        image_quality = 75;
      };

      opener = {
        edit = [
          {
            run = ''nvim "$@"'';
            desc = "nvim";
            block = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = ''xdg-open "$1"'';
            desc = "Open";
            for = "linux";
          }
        ];
        reveal = [
          {
            run = ''xdg-open "$(dirname "$1")"'';
            desc = "Reveal";
            for = "linux";
          }
        ];
        play = [
          {
            run = ''mpv --force-window "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
      };

      open.rules = [
        {
          name = "*/";
          use = ["edit" "open" "reveal"];
        }
        {
          mime = "text/*";
          use = ["edit" "reveal"];
        }
        {
          mime = "image/*";
          use = ["open" "reveal"];
        }
        {
          mime = "application/*";
          use = ["open" "reveal"];
        }
        {
          mime = "{audio,video}/*";
          use = ["play" "reveal"];
        }
        {
          mime = "application/{zip,rar,7z*,tar*}";
          use = ["extract" "reveal"];
        }
        {
          name = "*";
          use = ["edit" "reveal"];
        }
      ];

      input.cursor_blink = false;
    };

    # DRY keymap helper function
    keymap = let
      baseKeys = [
        {
          on = "<Esc>";
          run = "escape";
        }
        {
          on = "<C-c>";
          run = "close";
        }
        {
          on = "k";
          run = "arrow -1";
        }
        {
          on = "j";
          run = "arrow 1";
        }
        {
          on = "~";
          run = "help";
        }
        {
          on = "<F1>";
          run = "help";
        }
      ];

      movementKeys = [
        {
          on = ["g" "g"];
          run = "arrow top";
          desc = "Move cursor to the top";
        }
        {
          on = "G";
          run = "arrow bot";
          desc = "Move cursor to the bottom";
        }
        {
          on = "h";
          run = "leave";
          desc = "Go to parent directory";
        }
        {
          on = "l";
          run = "enter";
          desc = "enter directory";
        }
        {
          on = "H";
          run = "back";
          desc = "Go back in history";
        }
        {
          on = "L";
          run = "forward";
          desc = "Go forward in history";
        }
        {
          on = "<Space>";
          run = ["toggle" "arrow 1"];
          desc = "Toggle selection";
        }
      ];

      fileOps = [
        {
          on = "y";
          run = "yank";
          desc = "Copy files";
        }
        {
          on = "x";
          run = "yank --cut";
          desc = "Cut files";
        }
        {
          on = "p";
          run = "paste";
          desc = "Paste files";
        }
        {
          on = "P";
          run = "paste --force";
          desc = "Paste yanked files (overwrite if the destination exists)";
        }
        {
          on = "d";
          run = "remove";
          desc = "Trash files";
        }
        {
          on = "D";
          run = "remove --permanently";
          desc = "Delete files";
        }
        {
          on = "c";
          run = "create";
          desc = "Create file/dir";
        }
        {
          on = "r";
          run = "rename --cursor=before_ext";
          desc = "Rename file";
        }
      ];

      searchKeys = [
        {
          on = "s";
          run = "filter --smart";
          desc = "Filter files";
        }
      ];

      tabKeys = [
        {
          on = "t";
          run = "tab_create --current";
          desc = "New tab";
        }
        {
          on = "1";
          run = "tab_switch -1 --relative";
          desc = "Previous tab";
        }
        {
          on = "2";
          run = "tab_switch 1 --relative";
          desc = "Next tab";
        }
      ];

      pluginKeys = [
        {
          on = "!";
          for = "unix";
          run = "shell '$SHELL' --block";
          desc = "Open $SHELL here";
        }
        {
          on = "M";
          run = "plugin mount";
          desc = "Mount devices";
        }
        {
          on = "f";
          run = "plugin zoxide";
          desc = "Jump with zoxide";
        }
        {
          on = "<C-f>";
          run = "plugin fzf";
          desc = "Jump with fzf";
        }
      ];
    in {
      mgr = {
        keymap =
          baseKeys
          ++ movementKeys
          ++ fileOps
          ++ searchKeys
          ++ tabKeys
          ++ pluginKeys
          ++ [
            {
              on = "q";
              run = "quit";
              desc = "Quit Yazi";
            }
            {
              on = "<C-a>";
              run = "toggle_all --state=on";
              desc = "Select all files";
            }
            {
              on = "<C-r>";
              run = "toggle_all";
              desc = "Invert selection of all files";
            }
            {
              on = "v";
              run = "visual_mode";
              desc = "Enter visual mode (selection mode)";
            }
            {
              on = "V";
              run = "visual_mode --unset";
              desc = "Enter visual mode (unset mode)";
            }
            {
              on = "o";
              run = "open --interactive";
              desc = "Open interactively";
            }
            {
              on = ".";
              run = "hidden toggle";
              desc = "Toggle hidden files";
            }
            {
              on = "w";
              run = "tasks_show";
              desc = "Show tasks";
            }

            # Quick directory navigation
            {
              on = ["g" "h"];
              run = "cd ~";
              desc = "Go home";
            }
            {
              on = ["g" "c"];
              run = "cd ~/.config";
              desc = "Go to config";
            }
            {
              on = ["g" "d"];
              run = "cd ~/Downloads";
              desc = "Go to downloads";
            }
          ];
        prepend_keymap = [
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
        ];
      };

      # Simplified other keymaps using common patterns
      tasks.keymap =
        baseKeys
        ++ [
          {
            on = "<Enter>";
            run = "inspect";
            desc = "Inspect task";
          }
          {
            on = "x";
            run = "cancel";
            desc = "Cancel task";
          }
        ];

      input.keymap = [
        {
          on = "<C-c>";
          run = "close";
        }
        {
          on = "<Enter>";
          run = "close --submit";
        }
        {
          on = "<Esc>";
          run = "escape";
        }
        {
          on = "i";
          run = "insert";
        }
        {
          on = "a";
          run = "insert --append";
        }
        {
          on = "h";
          run = "move -1";
        }
        {
          on = "l";
          run = "move 1";
        }
        {
          on = "<C-h>";
          run = "backspace";
        }
        {
          on = "<Backspace>";
          run = "backspace";
        }
        {
          on = "<Delete>";
          run = "backspace --under";
        }
      ];

      # Minimal keymaps for other modes
      confirm.keymap =
        baseKeys
        ++ [
          {
            on = "<Enter>";
            run = "close --submit";
          }
          {
            on = "y";
            run = "close --submit";
          }
          {
            on = "n";
            run = "close";
          }
        ];

      help.keymap =
        baseKeys
        ++ [
          {
            on = "f";
            run = "filter";
            desc = "Filter help";
          }
        ];
    };
  };
}
