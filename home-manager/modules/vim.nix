{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  helpers = config.lib.nixvim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    vimAlias = true;
    viAlias = true;

    colorschemes.gruvbox.enable = true;
    plugins = {
      treesitter.enable = true;
      treesitter-textobjects.enable = true;
      treesitter-context.enable = true;
      treesitter-refactor.enable = true;
      nvim-colorizer.enable = true;
      illuminate.enable = true;
      fidget.enable = true;

      lualine.enable = true;
      nix.enable = true;
      gitsigns.enable = true;
      rainbow-delimiters.enable = true;
    };

    opts = {
      mouse = "a";
      number = false; # ---------- the perfect line numbers, none
      scrolloff = 4; #----------- sane scrolloff
      foldmethod = "marker"; #--- use {{{ to }}} for folding
      autoindent = true; #------- preserve current line's indent
      smartindent = true; #------ smartly add indents when necessary
      colorcolumn = "88,100"; #-- solid healthy line lengths
      expandtab = true; #-------- Use spaces instead of tabs
      shiftwidth = 0; #---------- 0 => same shiftwidth as whatever softtabstop is
      softtabstop = 2; #--------- behave as if 1 tab == 2 spaces
      tabstop = 2; #------------- all tabs show as length 2
      magic = true; #------------ For regular expressions turn magic on
      mat = 2; #----------------- tenths of a second to blink when matching brackets
      timeoutlen = 300; #-------- ms to wait for a mapped sequence to complete.
      ffs = "unix,dos,mac"; #---- Use Unix as the standard file type
      encoding = "utf8"; #------- cuz duh
      errorbells = false; #------ disable errorbells
      visualbell = false; #------ disable visual flash from bell
      ignorecase = true; #------- Ignore case when searching
      showmatch = true; #-------- Show matching brackets when indicator is over them
      wildmenu = true; #--------- enable 'enhanced mode' of command completions
      spell = true; #------------ enable spellchecking
      undofile = true; #--------- maintain undo history between sessions
      wildmode = "longest:full,full"; #-- Enable vim command completion
      nrformats = "bin,hex,alpha"; #-- increment alpha char with <C-A>
      completeopt = "menu,menuone,noselect,preview";
      swapfile = false; # -- no swapfiles so exiting terminal doesn't leave side effects if neovim is open

      suffixesadd = ".md,.py,.sh,.js";
    };
    extraConfigVim = ''
      set whichwrap+=<,>,h,l,[,]; "allow cursor to wrap lines
    '';
    globals.mapleader = " ";
    globalOpts = {
      do_filetype_lua = true; # -- use filetype.lua
      did_load_filetypes = false; # -- use filetype.lua
    };
    autoCmd = [
      {
        # Automatically leave insert mode if idle for too long
        event = ["CursorHoldI"];
        pattern = ["*"];
        command = "stopInsert";
      }
      # set 'updatetime' to 15 seconds when in insert mode, preserve old update time
      {
        event = ["InsertEnter"];
        pattern = ["*"];
        command = "let updaterestore=&updatetime | set updatetime=30000";
      }
      {
        event = ["InsertLeave"];
        pattern = ["*"];
        command = "let &updatetime=updaterestore";
      }
      {
        # automatically write if navigate away from buffer and filetype is markdown
        event = ["Filetype"];
        pattern = ["*"];
        command = "set autowriteall";
      }
      {
        event = ["Filetype"];
        pattern = ["markdown"];
        command = "set textwidth=88";
      }
      {
        event = ["Filetype"];
        pattern = ["markdown"];
        command = "setlocal formatoptions=jolwnt";
      }
      {
        event = ["Filetype"];
        pattern = ["python"];
        command = "set expandtab";
      }
      {
        event = ["Filetype"];
        pattern = ["python"];
        command = "set tabstop=4";
      }

      {
        event = ["Filetype"];
        pattern = ["python"];
        command = "set softtabstop=4";
      }
    ];
  };
}
