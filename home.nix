{ config, lib, pkgs, ... }:

{
  home.stateVersion = "26.05";

  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
    "$HOME/llama.cpp/build/bin"
    "$HOME/.local/share/coursier/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    SEARXNG_URL = "http://searxng.tail9bbb5.ts.net:8080/";
    FZF_DEFAULT_OPTS = "--height 60% --layout=reverse --border --inline-info";
    FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
  };

  programs.direnv.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  programs.kitty = {
    enable = true;
    font.name = "MonaspiceAr Nerd Font";
    settings = {
      background_opacity = "0.5";
      hide_window_decorations = true;
    };
    extraConfig = ''
      include current-theme.conf
    '';
  };

  programs.git = {
    enable = true;
    userName = "yanknvim";
    userEmail = "yanknvim@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      ghq.root = "~/src";
      ghq.user = "yanknvim";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    fastSyntaxHighlighting.enable = true;
    shellAliases = {
      v = "nvim";
      z = "zoxide";
      lg = "lazygit";
      hx = "helix";
    };
    initContent = ''
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions
      fpath+=${pkgs.pure-prompt}/share/zsh/site-functions

      autoload -U promptinit && promptinit
      prompt pure

      ghcd() {
        local dir
        dir=$(ghq list | fzf --prompt='repos> ' --preview 'ls -la $(ghq root)/{}' --preview-window 'right:50%')
        if [[ -n "$dir" ]]; then
          cd "$(ghq root)/$dir"
        fi
      }
    '';
  };

  home.packages = with pkgs; [
    lua-language-server
    nil
    typescript-language-server
    elmPackages.elm-language-server
    pyright
    racket
    clojure-lsp
    clang-tools
    zls
    tinymist
  ];

  xdg.configFile."kitty/current-theme.conf".source = ./kitty/current-theme.conf;
  xdg.configFile."nvim".source = ./nvim;
  xdg.configFile."zellij".source = ./zellij;

  home.file.".emacs.d/init.el".source = ./emacs/init.el;
}
