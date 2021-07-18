{ config, pkgs, ... }:

{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
        
        let g:lightline = {
              \ 'colorscheme': 'nord',
              \ }

      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [
          nord-vim
          lightline-vim
          vim-nix
          colorizer
        ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [ syntastic ];
      };
    };
  };
}
