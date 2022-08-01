{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.defaultPackage."${pkgs.system}";
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nord-nvim
      lightline-vim
      vim-nix
      nvim-colorizer-lua
      nvim-autopairs
      nvim-lspconfig
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-treesitter
      cmp-spell
      gitsigns-nvim
      nvim-ts-rainbow
    ];
    extraPackages = with pkgs; [ ripgrep ];
    extraConfig = ''
      lua << EOF
      -- enable nord theme
      require('nord').set()

      -- enable colorizer
      require'colorizer'.setup()

      -- enable rnin via lspconfig
      require'lspconfig'.rnix.setup{
        cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" }
      }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, noremap)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, noremap)

      -- autopairs
      require('nvim-autopairs').setup{}

      --
      -- gitsigns
      require('gitsigns').setup()
      
      -- basic vim settings/keybinds
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.cursorline = true
      vim.o.cursorlineopt = 'number'
      vim.o.mouse = 'a'
      vim.o.hidden = true
      vim.cmd 'set noshowmode'
      vim.g.mapleader = " "

      -- enable nord borders
      vim.g.nord_borders = true

      -- tree sitter
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },  
        rainbow = {
          enable = true,
        }
      }

      -- cmp
      local cmp = require("cmp")
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = 'spell' },
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              path = "[Path]",
              spell = "[Spell]",
            })[entry.source.name]
            return vim_item
          end
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        },        
      }

      -- telescope
      require('telescope').load_extension('fzf')
      vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<CR>', noremap)
      vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope live_grep<CR>', noremap)

      -- set lightline theme to nord
      vim.g.lightline = { colorscheme = 'nord' }

      -- copy to system clipboard
      vim.keymap.set('v', '<F12>', '"+y', noremap, silent)
      vim.keymap.set('n', '<F12>', ':%+y<CR>', noremap, silent)

      -- run nixpkgs-fmt on save
      vim.cmd 'autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_sync(nil, nil)'
      -- set linebreak and spelling for markdown documents
      vim.cmd 'autocmd FileType markdown set linebreak'
      vim.cmd 'autocmd FileType markdown set spell'
      EOF
    '';
  };
  home.sessionVariables.EDITOR = "nvim";
}
