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

      packages = with pkgs; [
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

      rum.programs.zsh = {
        enable = true;
        plugins = {
          fast-syntax-highlighting = {
            source = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
          };
          autosuggestions = {
            source = "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh";
          };
          completions = {
            completions = [ "${pkgs.zsh-completions}/share/zsh/site-functions" ];
          };
          pure = {
            completions = [ "${pkgs.pure-prompt}/share/zsh/site-functions" ];
            config = ''
              autoload -U promptinit
              promptinit
              prompt pure
            '';
          };
        };
        initConfig = ''
          alias v=nvim
          alias z=zoxide
          alias lg=lazygit
          alias hx=helix

          eval "$(direnv hook zsh)"

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
