{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nord-vim
      lightline-vim
      vim-nix
      colorizer
      lexima-vim
      nvim-lspconfig
    ];
    extraPackages = [ pkgs.rnix-lsp ];
    extraConfig = ''
      colorscheme nord
      let g:lightline = { "colorscheme": "nord" }
      set hidden
      set noshowmode
      set number
      set mouse=a

      lua << EOF
      require'lspconfig'.rnix.setup{}

      vim.api.nvim_set_keymap( 'v', '<F12>', '"+y', {noremap = true})
      vim.api.nvim_set_keymap( 'n', '<F12>', ':%+y<CR>', {noremap = true})
      EOF

      autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_sync(nil, nil)
    '';
  };

  home.sessionVariables.EDITOR = "nvim";
}
