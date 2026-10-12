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
    version.enableNixpkgsReleaseCheck = false;
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
    colorscheme = "catppuccin-nvim";
    colorschemes.catppuccin = {
      enable = true;
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
      {
        event = "BufWritePre";
        pattern = "*.go";
        callback.__raw = ''
          function(args)
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, name = "gopls" })) do
              local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
              params.context = { only = { "source.organizeImports" } }
              local result = client:request_sync("textDocument/codeAction", params, 1000, args.buf)
              for _, action in pairs(result and result.result or {}) do
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                end
              end
            end
          end
        '';
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
    extraPlugins = with pkgs.vimPlugins; [
      floating-input-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "yaml-companion.nvim";
        version = "0-unstable-2026-08-28";
        src = pkgs.fetchFromGitHub {
          owner = "mosheavni";
          repo = "yaml-companion.nvim";
          rev = "fc8dc139ab8f410ae830d5cf48f9558f47c701f8";
          hash = "sha256-wSJntNdb01t6ptu4GWFC+zJOVtrZ03X8nAOcbGWHTlw=";
        };
        postPatch = ''
          echo 'return "v${pkgs.lib.versions.majorMinor pkgs.kubectl.version}.0"' > lua/yaml-companion/builtin/kubernetes/version.lua
        '';
      })
    ];
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
        yamlls = {
          enable = true;
          config.__raw = "require('yaml-companion').setup({})";
        };
        gopls = {
          enable = true;
          packageFallback = true;
          config.settings.gopls = {
            gofumpt = true;
            staticcheck = true;
            hints = {
              parameterNames = true;
              assignVariableTypes = true;
              rangeVariableTypes = true;
              compositeLiteralFields = true;
              ignoredError = true;
            };
          };
        };
      };
    };
  };
}
