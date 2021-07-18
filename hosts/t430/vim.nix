with import <nixpkgs> {};
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

set mouse=a


noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>


" startify bookmarks
let g:startify_bookmarks = [ '~/.config/nvim/init.vim', '~/.zshrc', '~/.config/polybar/config', '~/.config/rofi/config', '~/.config/sxhkd/sxhkdrc', '~/.config/bspwm/bspwmrc' ]

" startify padding
let g:startify_padding_left = 20

" startify lists
let g:startify_lists = [                                                                         
          \ { 'type': 'files',     'header': ['                    Recents']        },                    
          \ { 'type': 'bookmarks', 'header': ['                    Dotfiles']       },                     
          \ ]                 

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
            "lightline-vim" ];
        };
      };
    }

