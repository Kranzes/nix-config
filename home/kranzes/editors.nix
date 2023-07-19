{ pkgs, lib, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.neovim;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
    plugins = with pkgs.vimPlugins; [
      nord-nvim
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
      nvim-ts-rainbow
      formatter-nvim
      rust-tools-nvim
      floating-input-nvim
    ];
    extraPackages = with pkgs; [
      ripgrep # telescope
      manix # telescope
      git # gitsigns
      nil # lspconfig
      nodePackages.bash-language-server # lspconfig
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
      require('nord').set()
      vim.g.nord_borders = true
      vim.g.lightline = { colorscheme = 'nord' }

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
      require('telescope').load_extension('manix')
      vim.keymap.set('n', '<space>ff', require('telescope.builtin').find_files, opts)
      vim.keymap.set('n', '<space>fg', require('telescope.builtin').live_grep, opts)
      vim.keymap.set('n', '<space>mn', require('telescope-manix').search, opts)
      vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)

      -- tree sitter
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true, },
        indent = { enable = true, },
        rainbow = { enable = true, }
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

      local on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            didChangeWatchedFiles = true,
          },
        },
      }

      local servers = { 'nil_ls', 'bashls' }
      for _, lsp in ipairs(servers) do
        require('lspconfig')[lsp].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            ['nil'] = {
              autoArchive = true,
              autoEvalInputs = true,
            }
          }
        }
      end

      require("rust-tools").setup({ server = { on_attach = on_attach }})

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

      -- formatting
      require("formatter").setup {
        filetype = {
          nix = { function() return { exe = "${lib.getExe pkgs.nixpkgs-fmt}" } end, },
        },
      }
      vim.cmd 'autocmd BufWritePost * FormatWrite'
      EOF
    '';
  };
  home.sessionVariables.EDITOR = "nvim";
}
