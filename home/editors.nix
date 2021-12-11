{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nord-nvim
      lightline-vim
      vim-nix
      colorizer
      nvim-autopairs
      nvim-lspconfig
      nvim-tree-lua
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      neogit
    ];
    extraPackages = with pkgs; [ rnix-lsp gcc ripgrep fd ];
    extraConfig = ''
      lua << EOF
      -- enable nord theme
      require('nord').set()

      -- enable rnix via lspconfig
      require'lspconfig'.rnix.setup{}

      -- autopairs
      require('nvim-autopairs').setup{}
      
      -- basic vim settings/keybinds
      vim.o.number = true
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
      }

      -- cmp
      local cmp = require("cmp")
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
            })[entry.source.name]
            return vim_item
          end
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          })
        },        
      }

      -- telescope
      require('telescope').load_extension('fzf')
      vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>Telescope find_files<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<Leader>fg', '<cmd>Telescope live_grep<CR>', {noremap = true})

      -- neogit
       require('neogit').setup {}

      -- set lightline theme to nord
      vim.g.lightline = { colorscheme = 'nord' }

      -- copy to system clipboard
      vim.api.nvim_set_keymap( 'v', '<F12>', '"+y', {noremap = true})
      vim.api.nvim_set_keymap( 'n', '<F12>', ':%+y<CR>', {noremap = true})

      -- run nixpkgs-fmt on save
      vim.cmd 'autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_sync(nil, nil)'
      -- set linebreak for markdown documents
      vim.cmd 'autocmd FileType markdown set linebreak'
      EOF
    '';
  };
  home.sessionVariables.EDITOR = "nvim";
}
