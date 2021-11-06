{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtraFirst = ''
      setopt PROMPT_SUBST
      source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
      PROMPT='[%n@%m %~]%(!.#.$)$(__git_ps1) '
      RPROMPT=
    '';
    initExtra = ''
      setopt INTERACTIVE_COMMENTS
      bindkey "^R" history-incremental-search-backward
      bindkey "^A" vi-beginning-of-line
      bindkey "^E" vi-end-of-line
      # Disable pasted text highlighting 
      zle_highlight+=(paste:none)
      # Completion options
      zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' menu select
      zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
      zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
      zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
      zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
      zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
      zstyle ':completion:*' group-name ""
      # Quote pasted URLs
      autoload -U url-quote-magic
      zle -N self-insert url-quote-magic
    '';
    shellAliases = {
      history = "history 1";
      rm = "rm -I";
      mv = "mv -i";
      ls = "ls --group-directories-first --color=auto";
      cat = "bat";
      ytdl = "yt-dlp";
      weather = "curl wttr.in/Rehovot";
      ssh = "TERM=xterm-256color ssh";
    };
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile "${pkgs.fetchurl {
      url = "https://github.com/arcticicestudio/nord-dircolors/raw/develop/src/dir_colors";
      sha256 = "sha256-hlezTQqouVKbxgQBxtZU4en0idDiTCRJtFGH6XYFmtc="; }
    }";
  };
}
