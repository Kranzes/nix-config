{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      lightline-vim
      vim-nix
      nvim-colorizer-lua
      nvim-autopairs
      nvim-lspconfig
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-manix
      nvim-treesitter.withAllGrammars
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-spell
      cmp_luasnip
      luasnip
      gitsigns-nvim
      rainbow-delimiters-nvim
      rustaceanvim
      floating-input-nvim
      nvim-treesitter-context
    ];
    extraPackages = with pkgs; [
      ripgrep # telescope
      git # gitsigns
      nil # lspconfig
      nixpkgs-fmt # lspconfig
      pyright # lspconfig
      nodePackages.bash-language-server # lspconfig
      rust-analyzer # rustaceanvim
      rustfmt # lspconfig
      cargo # lspconfig
      clippy # lspconfig
    ];
    extraConfig = ''
      lua << EOF
      -- basic vim settings/keybinds
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.cursorline = true
      vim.o.cursorlineopt = 'number'
      vim.o.mouse = 'a'
      vim.o.hidden = true
      vim.cmd 'set noshowmode'

      -- theming
      require("catppuccin").setup({
        flavour = "${config.catppuccin.flavor}",
        custom_highlights = function(colors) return { NormalFloat = { bg = colors.base } } end
      })

      vim.cmd.colorscheme "catppuccin"
      vim.g.lightline = { colorscheme = 'catppuccin' }
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })

      -- set linebreak and spelling for markdown documents
      vim.cmd 'autocmd FileType markdown set linebreak'
      vim.cmd 'autocmd FileType markdown set spell'

      -- copy to system clipboard
      local opts = { noremap=true, silent=true }
      vim.keymap.set('v', '<F12>', '"+y', opts)
      vim.keymap.set('n', '<F12>', ':%+y<CR>', opts)

      -- telescope
      local opts = { noremap=true, silent=true }
      require('telescope').load_extension('fzf')
      vim.keymap.set('n', '<space>ff', require('telescope.builtin').find_files, opts)
      vim.keymap.set('n', '<space>fg', require('telescope.builtin').live_grep, opts)
      vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)

      -- tree sitter
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true, },
        indent = { enable = true, }
      }

      -- enable colorizer
      require'colorizer'.setup()

      -- autopairs
      require('nvim-autopairs').setup{}

      -- gitsigns
      require('gitsigns').setup()

      -- LSP & nvim-cmp setup
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', '<space>ih', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, bufopts)

        -- formatting
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '*',
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      end

      require('lspconfig').nil_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ['nil'] = {
            nix = {
              maxMemoryMB = 8192,
              flake = {
                autoArchive = true,
                autoEvalInputs = true,
              },
            },
            formatting = {
              command = { "nixpkgs-fmt" },
            },
          },
        },
      }

      require('lspconfig').pyright.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      require('lspconfig').bashls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = 'rounded'
          }
        },
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
      }

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {border = 'rounded'}
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {border = 'rounded'}
      )

      vim.diagnostic.config({
        float = {border = 'rounded'},
      })

      local cmp = require 'cmp'
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = 'spell' },
          { name = 'luasnip' },
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              path = "[Path]",
              spell = "[Spell]",
              luasnip = "[Snip]",
            })[entry.source.name]
            return vim_item
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true, })
        },
      }
      EOF
    '';
  };
  home.sessionVariables.EDITOR = "nvim";
}
