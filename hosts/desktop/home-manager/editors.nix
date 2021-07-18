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
      latex-live-preview
    ];

    extraConfig = ''
      colorscheme nord
      let g:lightline = { "colorscheme": "nord" }
      let g:livepreview_previewer = 'zathura'
      let g:netrw_liststyle = 3
      set clipboard+=unnamedplus
      set number
      syntax enable
      let g:nord_uniform_status_lines = 0
      syntax on
      set hidden
      set noshowmode
      
      set mouse=a
  
      noremap <Up> <NOP>
      noremap <Down> <NOP>
      noremap <Left> <NOP>
      noremap <Right> <NOP>
    '';
  };

  home.sessionVariables = { EDITOR = "nvim"; };

}
