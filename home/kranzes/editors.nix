{ config, pkgs, inputs, ... }:

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
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-spell
      gitsigns-nvim
      nvim-ts-rainbow
      formatter-nvim
    ];
    extraPackages = with pkgs; [
      ripgrep # telescope
      git # gitsigns
      inputs.nil.packages.${pkgs.system}.nil # lspconfig
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
      vim.g.mapleader = " "

       -- theming
      require('nord').set()
      vim.g.nord_borders = true
      vim.g.lightline = { colorscheme = 'nord' }

      -- set linebreak and spelling for markdown documents
      vim.cmd 'autocmd FileType markdown set linebreak'
      vim.cmd 'autocmd FileType markdown set spell'

      -- copy to system clipboard
      vim.keymap.set('v', '<F12>', '"+y', noremap, silent)
      vim.keymap.set('n', '<F12>', ':%+y<CR>', noremap, silent)

      -- telescope
      require('telescope').load_extension('fzf')
      vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<CR>', noremap)
      vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope live_grep<CR>', noremap)

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
      local servers = { 'nil_ls', 'bashls' }
      for _, lsp in ipairs(servers) do
        require('lspconfig')[lsp].setup {
          capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        }
      end

      local cmp = require 'cmp'
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

      -- LSP keybinds
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, noremap)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, noremap)

      -- formatting
      require("formatter").setup {
        filetype = {
          nix = { function() return { exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" } end, },
        },
      }
      vim.cmd 'autocmd BufWritePost * FormatWrite'
      EOF
    '';
  };
  home.sessionVariables.EDITOR = "nvim";
}
