{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.nixvim.homeModules.nixvim
    ./home/noctalia.nix
    ./home/niri.nix
    ./home/stylix.nix
    ./home/nixvim.nix
    ./home/zellij.nix
  ];

  home.stateVersion = "26.05";

  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    SEARXNG_URL = "http://searxng.tail9bbb5.ts.net:8080/";
  };

  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
  };

  programs.direnv.enable = true;

  programs.emacs = {
    enable = true;
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      window-decoration = false;
    };
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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;

      keys = {
        prefix = "ctrl+a";
      };
    };
  };

  programs.lazygit.enable = true;

  home.packages = with pkgs; [
    spotify
    nemo
    yazi
  ];


  home.file.".emacs.d/init.el".source = ./emacs/init.el;
}
