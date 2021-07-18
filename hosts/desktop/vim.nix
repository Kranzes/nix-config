with import <nixpkgs> { };
neovim.override {
  vimAlias = true;
  viAlias = true;
  configure = {
    customRC = ''
        colorscheme nord
      let g:netrw_liststyle = 3
      set clipboard+=unnamedplus
      set number
      syntax enable
      let g:nord_uniform_status_lines = 0
      syntax on
      set hidden
      set noshowmode

      set statusline+=%#warningmsg#
      set statusline+=%{SyntasticStatuslineFlag()}
      set statusline+=%*

      let g:syntastic_always_populate_loc_list = 1
      let g:syntastic_auto_loc_list = 1
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 0

      set mouse=a


      noremap <Up> <NOP>
      noremap <Down> <NOP>
      noremap <Left> <NOP>
      noremap <Right> <NOP>


      " startify padding
      let g:startify_padding_left = 20

      " startify header
      let g:startify_custom_header = startify#center([
        \ ' .__   __.  _______   ______   ____    ____  __  .___  ___. ',
        \ ' |  \ |  | |   ____| /  __  \  \   \  /   / |  | |   \/   | ',
        \ ' |   \|  | |  |__   |  |  |  |  \   \/   /  |  | |  \  /  | ',
        \ ' |  . `  | |   __|  |  |  |  |   \      /   |  | |  |\/|  | ',
        \ ' |  |\   | |  |____ |  `--`  |    \    /    |  | |  |  |  | ',
        \ ' |__| \__| |_______| \______/      \__/     |__| |__|  |__| ',
        \ ])


      " Lightline 
      let g:lightline = {
            \ 'colorscheme': 'nord',
            \ }
    '';

    pathogen = {
      knownPlugins = vimPlugins;
      pluginNames = [
        "vim-nix"
        "vim-startify"
        "nord-vim"
        "vim-surround"
        "colorizer"
        "syntastic"
        "lightline-vim"
      ];
    };
  };
}

