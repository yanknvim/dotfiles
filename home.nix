{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # NOTE: home-manager now ships its own programs.noctalia module
    # (modules/programs/noctalia). Importing noctalia's home module too
    # used to double-declare options like programs.noctalia.checkConfig.
    inputs.nixvim.homeModules.nixvim
    ./home/noctalia.nix
    ./home/niri.nix
    ./home/theme.nix
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
      font-family = "MonaspiceNe Nerd Font Mono";
      font-size = 12;
      font-feature = "-calt";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "yanknvim";
        email = "yanknvim@gmail.com";
      };
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

  programs.pi-coding-agent = {
    enable = true;
    extraPackages = [
      pkgs.nodejs
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-vkcapture
    ];
  };

  programs.lazygit.enable = true;
  programs.helix = {
    settings.theme = "kanagawa";
    enable = true;
  };

  home.packages = with pkgs; [
    spotify
    nemo
    yazi

    tree
    gh
    ghq
    deno
    fastfetch
    btop-rocm
    skkDictionaries.l
    llm-agents.codex
    llm-agents.hunk
    opencode
    uv
    gimp
    rocmPackages.amdsmi

    vesktop
    wayvr
    xrizer
    mangohud

    krita
    imv

    # niri のカーソルテーマ
    adwaita-icon-theme

    inputs.turboquant.packages.${pkgs.system}.vulkan

    pavucontrol
    inputs.hermes-agent.packages.${pkgs.system}.desktop
  ];

  home.file.".emacs.d/init.el".source = ./emacs/init.el;
}
