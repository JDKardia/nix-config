{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    vimAlias = true;
    viAlias = true;
    keymaps = [
      # {{{
      {
        key = "<leader>p";
        action = ''"+p'';
        options.remap = false;
        mode = [
          "n"
          "v"
        ];
      }
      {
        key = "<leader>y";
        action = ''"+y'';
        options.remap = false;
        mode = [
          "n"
          "v"
        ];
      }
      {
        key = "<leader>Y";
        action = ''"*y'';
        options.remap = false;
        mode = [
          "n"
          "v"
        ];
      }
      {
        key = "<leader>P";
        action = ''"*p'';
        options.remap = false;
        mode = [
          "n"
          "v"
        ];
      }
      # }}}
    ];

    colorschemes.gruvbox = {
      enable = true;
      settings.contrast = "hard";
    };
    plugins = {
      # {{{
      web-devicons.enable = true;
      which-key = {
        # {{{
        enable = true;
        settings = {
          triggers = [
            {
              __unkeyed-1 = "<auto>";
              mode = "nixsoc";
            }
            {
              __unkeyed-1 = "<leader>";
              mode = "nv";
            }
            {
              __unkeyed-1 = "<localleader>";
              mode = "nv";
            }
          ];

          # Customize section names (prefixed mappings)
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffers";
            }
            {
              __unkeyed-1 = "<leader>bs";
              group = "Sort Buffers";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "Debugger";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Go";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "Language Tools";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "Session";
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "Terminal";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "UI/UX";
            }
            {
              __unkeyed-1 = "<localleader>c";
              group = "Connect";
            }
            {
              __unkeyed-1 = "<localleader>e";
              group = "Evaluate";
            }
            {
              __unkeyed-1 = "<localleader>g";
              group = "Go";
            }
            {
              __unkeyed-1 = "<localleader>l";
              group = "Log";
            }
            {
              __unkeyed-1 = "<localleader>r";
              group = "Refresh";
            }
            {
              __unkeyed-1 = "<localleader>s";
              group = "Session";
            }
            {
              __unkeyed-1 = "<localleader>t";
              group = "Test";
            }
            {
              __unkeyed-1 = "<localleader>v";
              group = "Values";
            }
          ];
          # }}}
        };
      };

      parinfer-rust.enable = true;
      conjure.enable = true;
      treesitter = {
        # {{{
        enable = true;
        folding = true;

        settings = {
          auto_install = true;
          indent.enable = true;
          highlight = {
            additional_vim_regex_highlighting = true;
            enable = true;
            disable = # Lua
              ''
                function(lang, bufnr)
                  return vim.api.nvim_buf_line_count(bufnr) > 10000
                end
              '';
          };
          # }}}
        };
      };
      treesitter-textobjects.enable = true;
      treesitter-context.enable = true;
      treesitter-refactor.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
      fidget.enable = true;

      lualine.enable = true;
      nix.enable = true;
      gitsigns.enable = true;
      rainbow-delimiters.enable = true;
      nvim-surround.enable = true;
      nvim-autopairs.enable = true;
      trouble.enable = true;
      lint = {
        enable = true;
        lintersByFt = {
          clojure = [
            "clj-kondo"
            "joker"
          ];

        };
      };
      lsp.servers = {
        #{{{
        # ruff={enable=true;};
        gopls = {
          enable = true;
        };
        pylsp = {
          enable = true;
          settings = {
            plugins = {
              ruff = {
                enabled = true; # Enable the plugin
                formatEnabled = true; # Enable formatting using ruffs formatter
                # executable = "<path-to-ruff-bin>";  # Custom path to ruff
                # config = "<path_to_custom_ruff_toml>";  # Custom config for ruff to use
                # extendSelect = { "I" };  # Rules that are additionally used by ruff
                # extendIgnore = { "C90" };  # Rules that are additionally ignored by ruff
                # format = { "I" };  # Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
                # severities = { ["D212"] = "I" };  # Optional table of rules where a custom severity is desired
                unsafeFixes = false; # Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

                # Rules that are ignored when a pyproject.toml or ruff.toml is present:
                lineLength = 88; # Line length to pass to ruff checking and formatting
                # exclude = { "__about__.py" };  # Files to be excluded by ruff checking
                # select = { "F" };  # Rules to be enabled by ruff
                # ignore = { "D210" };  # Rules to be ignored by ruff
                # perFileIgnores = { ["__init__.py"] = "CPY001" };  # Rules that should be ignored for specific files
                # preview = false;  # Whether to enable the preview style linting and formatting.
                # targetVersion = "py310";  # The minimum python version to target (applies for both linting and formatting).
              };
            };
          };
        };
        nixd = {
          enable = true;
        };

        #}}}
      };
      blink-cmp = {
        # {{{
        enable = true;
        settings = {
          keymap = {
            preset = "enter";
            "<Tab>" = [
              "select_next"
              "snippet_forward"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "snippet_backward"
              "fallback"
            ];
          };
          completion = {
            list.selection = {
              preselect = false;
              auto_insert = true;
            };
            ghost_text.enabled = true;
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 10;
            };
          };
        };
        # }}}
      };
      # }}}
    };

    opts = {
      # {{{
      mouse = "a";
      number = false; # ---------- the perfect line numbers, none
      scrolloff = 4; # ----------- sane scrolloff
      foldmethod = "marker"; # --- use {{{ to }}} for folding
      autoindent = true; # ------- preserve current line's indent
      smartindent = true; # ------ smartly add indents when necessary
      colorcolumn = "88,100"; # -- solid healthy line lengths
      expandtab = true; # -------- Use spaces instead of tabs
      shiftwidth = 0; # ---------- 0 => same shiftwidth as whatever softtabstop is
      softtabstop = 2; # --------- behave as if 1 tab == 2 spaces
      tabstop = 2; # ------------- all tabs show as length 2
      magic = true; # ------------ For regular expressions turn magic on
      mat = 2; # ----------------- tenths of a second to blink when matching brackets
      timeoutlen = 300; # -------- ms to wait for a mapped sequence to complete.
      ffs = "unix,dos,mac"; # ---- Use Unix as the standard file type
      encoding = "utf8"; # ------- cuz duh
      errorbells = false; # ------ disable errorbells
      visualbell = false; # ------ disable visual flash from bell
      ignorecase = true; # ------- Ignore case when searching
      showmatch = true; # -------- Show matching brackets when indicator is over them
      wildmenu = true; # --------- enable 'enhanced mode' of command completions
      spell = true; # ------------ enable spellchecking
      undofile = true; # --------- maintain undo history between sessions
      wildmode = "longest:full,full"; # -- Enable vim command completion
      nrformats = "bin,hex,alpha"; # -- increment alpha char with <C-A>
      completeopt = "menu,menuone,noselect,preview";
      swapfile = false; # -- no swapfiles so exiting terminal doesn't leave side effects if neovim is open

      suffixesadd = ".md,.py,.sh,.js";
      #}}}
    };
    extraConfigVim = ''
      set whichwrap+=<,>,h,l,[,] "allow cursor to wrap lines
    '';
    globals = {
      mapleader = " ";
      maplocalleader = ",";
      do_filetype_lua = true; # -- use filetype.lua
      did_load_filetypes = false; # -- use filetype.lua
    };
    autoCmd = [
      #{{{
      {
        # Automatically leave insert mode if idle for too long
        event = [ "CursorHoldI" ];
        pattern = [ "*" ];
        command = "stopinsert";
      }
      {
        # set 'updatetime' to 15 seconds when in insert mode, preserve old update time
        event = [ "InsertEnter" ];
        pattern = [ "*" ];
        command = "let updaterestore=&updatetime | set updatetime=30000";
      }
      {
        # set 'updatetime' to 15 seconds when in insert mode, preserve old update time
        event = [ "InsertLeave" ];
        pattern = [ "*" ];
        command = "let &updatetime=updaterestore";
      }
      {
        # automatically write if navigate away from buffer and filetype is markdown
        event = [ "Filetype" ];
        pattern = [ "*" ];
        command = "set autowriteall";
      }
      {
        event = [ "Filetype" ];
        pattern = [ "markdown" ];
        command = "set textwidth=88";
      }
      {
        event = [ "Filetype" ];
        pattern = [ "markdown" ];
        command = "setlocal formatoptions=jolwnt";
      }
      {
        event = [ "Filetype" ];
        pattern = [ "python" ];
        command = "set expandtab";
      }
      {
        event = [ "Filetype" ];
        pattern = [ "python" ];
        command = "set tabstop=4";
      }
      {
        event = [ "Filetype" ];
        pattern = [ "python" ];
        command = "set softtabstop=4";
      }
      #}}}
    ];
  };
}
