{
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    nixpkgs.useGlobalPackages = true;
    defaultEditor = true;
    vimdiffAlias = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      nixfmt
    ];
    opts = {
      number = true;
      cursorline = true;
      cursorlineopt = "number";
      showmode = false;
      winborder = "rounded";
    };
    colorschemes.catppuccin = {
      enable = true;
      package = pkgs.vimPlugins.catppuccin-nvim.overrideAttrs {
        patches = [
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/catppuccin/nvim/pull/941.patch";
            hash = "sha256-1vdLNr0lCwXdJBIB4xG/1fY3Znli356UgMbfprCuUgQ=";
          })
        ];
      };
      settings = {
        flavour = config.catppuccin.flavor;
        integrations = {
          telescope.enabled = true;
          gitsigns = true;
          treesitter_context = true;
          rainbow_delimiters = true;
          blink_cmp.style = "bordered";
        };
      };
    };
    autoCmd = [
      {
        event = "FileType";
        pattern = "markdown";
        callback.__raw = "function() vim.opt_local.linebreak = true end";
      }
      {
        event = "FileType";
        pattern = "terraform";
        callback.__raw = "function() vim.opt_local.shiftwidth = 2 end ";
      }
    ];
    keymaps = [
      # Copy to system clipboard
      {
        mode = "v";
        key = "<F12>";
        action = "\"+y";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<F12>";
        action = ":%+y<CR>";
        options.silent = true;
      }
    ];
    plugins = {
      numbertoggle.enable = true;
      lualine = {
        enable = true;
        settings.options.theme = config.programs.nixvim.colorscheme;
      };
      web-devicons.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<space>ff".action = "find_files";
          "<space>fg".action = "live_grep";
        };
        extensions.fzf-native.enable = true;
      };
      highlight-colors.enable = true;
      autoclose.enable = true;
      gitsigns.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context.enable = true;
      rainbow-delimiters.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "enter";
          completion = {
            list.selection.preselect = false;
            documentation.auto_show = true;
          };
          appearance.use_nvim_cmp_as_default = true;
          signature.enabled = true;
        };
      };
      nix.enable = true;
      lspconfig.enable = true;
      rustaceanvim.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [ floating-input-nvim ];
    dependencies = {
      ripgrep.enable = true;
      fd.enable = true;
    };
    lsp = {
      onAttach = ''
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '*',
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      '';
      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gr";
          action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          key = "<space>rn";
          lspBufAction = "rename";
        }
        {
          key = "<space>ca";
          lspBufAction = "code_action";
        }
        {
          key = "<space>ih";
          action = config.lib.nixvim.mkRaw "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
        }
        {
          key = "<space>e";
          action = config.lib.nixvim.mkRaw "function() vim.diagnostic.open_float() end";
        }
      ];
      servers = {
        nixd.enable = true;
        pyright.enable = true;
        bashls.enable = true;
        hls.enable = true;
        terraformls.enable = true;
      };
    };
  };
}
