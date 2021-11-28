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
      lexima-vim
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter
    ];
    extraPackages = with pkgs; [ rnix-lsp gcc ];
    extraConfig = ''
      lua << EOF
      -- enable nord theme
      require('nord').set()

      -- enable rnix via lspconfig
      require'lspconfig'.rnix.setup{}
      
      -- basic vim settings
      vim.o.number = true
      vim.o.mouse = 'a'
      vim.o.hidden = true
      vim.cmd 'set noshowmode'

      -- enable nord borders
      vim.g.nord_borders = true

      -- tree sitter
      require('nvim-treesitter.configs').setup {
        ensure_installed = {"bash", "nix", "toml", "yaml", "css", "html", "latex"},
        highlight_enable = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },  
      }

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
