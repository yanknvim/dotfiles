{ config, lib, pkgs, inputs, ... }:

{
  hjem = {
    clobberByDefault = true;
    extraModules = [ inputs.hjem-rum.hjemModules.default ];

    users.yank = {
      enable = true;
      directory = "/home/yank";
      user = "yank";

      environment.sessionVariables = {
        PATH = [
          "/home/yank/.bun/bin"
          "/home/yank/.cargo/bin"
          "/home/yank/llama.cpp/build/bin"
          "/home/yank/.local/share/coursier/bin"
          "/home/yank/.local/bin"
          "$PATH"
        ];
        SEARXNG_URL = "http://searxng.tail9bbb5.ts.net:8080/";
        FZF_DEFAULT_OPTS = "--height 60% --layout=reverse --border --inline-info";
        FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
      };

      rum.programs.kitty = {
        enable = true;
        settings = {
          font_family = "family=\"MonaspiceAr Nerd Font\"";
          bold_font = "auto";
          italic_font = "auto";
          bold_italic_font = "auto";
          background_opacity = "0.5";
          include = "current-theme.conf";
          shell = "zsh";
          hide_window_decorations = "True";
        };
      };

      rum.programs.git = {
        enable = true;
        settings = {
          user = {
            email = "yanknvim@gmail.com";
            name = "yanknvim";
          };
          init.defaultBranch = "main";
          ghq = {
            root = "~/src";
            user = "yanknvim";
          };
        };
      };

      rum.programs.zsh = {
        enable = true;
        initConfig = ''
          alias v=nvim
          alias z=zoxide
          alias lg=lazygit
          alias hx=helix

          eval "$(direnv hook zsh)"

          ### Added by Zinit's installer
          if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
              print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
              command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
              command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
                  print -P "%F{33} %F{34}Installation successful.%f%b" || \
                  print -P "%F{160} The clone has failed.%f%b"
          fi

          source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
          autoload -Uz _zinit
          (( ''${+_comps} )) && _comps[zinit]=_zinit

          zinit light zdharma-continuum/fast-syntax-highlighting
          zinit light zsh-users/zsh-autosuggestions
          zinit light zsh-users/zsh-completions

          zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
          zinit light sindresorhus/pure

          # ghcd - ghq listをfzfで絞り込んでcd
          ghcd() {
            local dir
            dir=$(ghq list | fzf --prompt='repos> ' --preview 'ls -la $(ghq root)/{}' --preview-window 'right:50%')
            if [[ -n "$dir" ]]; then
              cd "$(ghq root)/$dir"
            fi
          }
        '';
      };

      xdg.config.files = {
        "kitty/current-theme.conf".source = ./kitty/current-theme.conf;
        "nvim".source = ./nvim;
        "zellij".source = ./zellij;
      };

      files = {
        ".emacs.d/init.el".source = ./emacs/init.el;
      };
    };
  };
}
