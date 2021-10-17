{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
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

      -- nvim-tree
      vim.g.nvim_tree_hide_dotfiles = 1
      vim.g.nvim_tree_show_icons = {
        git = 0,
        folders = 0,
        files = 0,
        folder_arrows = 0
      }
      require'nvim-tree'.setup {
        disable_netrw = false,
        update_to_buf_dir  = { enable = false }
      }
      vim.api.nvim_set_keymap( 'n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true})

      -- enable nord borders
      vim.g.nord_borders = true

      -- set lightline theme to nord
      vim.g.lightline = { colorscheme = 'nord' }

      -- copy to system clipboard
      vim.api.nvim_set_keymap( 'v', '<F12>', '"+y', {noremap = true})
      vim.api.nvim_set_keymap( 'n', '<F12>', ':%+y<CR>', {noremap = true})

      -- run nixpkgs-fmt on save
      vim.cmd 'autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_sync(nil, nil)'
      EOF
    '';
  };
  home.sessionVariables.EDITOR = "nvim";
}
