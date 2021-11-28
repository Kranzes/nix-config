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
    ];
    extraPackages = [ pkgs.rnix-lsp ];
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
