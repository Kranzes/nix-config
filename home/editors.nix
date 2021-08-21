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
      let g:netrw_liststyle = 3
      set clipboard+=unnamedplus
      syntax enable
      let g:nord_uniform_status_lines = 0
      syntax on
      set hidden
      set noshowmode
      set number
      set mouse=a

      noremap <Up> <NOP>
      noremap <Down> <NOP>
      noremap <Left> <NOP>
      noremap <Right> <NOP>

      lua << EOF
      require'lspconfig'.rnix.setup{}
      EOF

      autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_sync(nil, nil)
    '';
  };

  home.sessionVariables.EDITOR = "nvim";

}
