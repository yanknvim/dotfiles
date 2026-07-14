{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.stateVersion = "26.05";

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      launch_apps_as_systemd_services = true;
      wallpaper = {
        enabled = true;
        default.path = "/home/yank/Pictures/mousou_angel2.jpg";
      };
    };
  };

  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
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
  };

  programs.neovim = {
    enable = true;
    # sideloadInitLua lets Stylix inject the colorscheme config via --cmd
    # while keeping your custom ~/.config/nvim from xdg.configFile."nvim".source
    sideloadInitLua = true;
    extraPackages = with pkgs; [
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
      ripgrep
    ];
  };

  stylix.targets.neovim.enable = true;
  stylix.targets.ghostty.enable = true;
  stylix.targets.btop.enable = true;
  stylix.targets.gtk.enable = true;
  stylix.targets.yazi.enable = true;
  stylix.targets.zellij.enable = true;

  stylix.icons = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
    light = "Papirus-Light";
  };

  stylix.opacity = {
    terminal = 0.70;
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      window-decoration = false;
      working-directory = "/home/yank";
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
    spotify
    nemo
    yazi
  ];

  # Use Stylix colors for niri window decorations
  programs.niri.settings = let
    inherit (config.lib.stylix.colors.withHashtag) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;
  in {
    input = {
      keyboard.numlock = true;
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    layout = {
      gaps = 16;
      center-focused-column = "never";

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width = {
        proportion = 0.5;
      };

      focus-ring = {
        enable = true;
        width = 4;
        active = { color = base0A; };
        inactive = { color = base03; };
      };

      border = {
        enable = false;
      };

      shadow = {
        enable = false;
        softness = 30;
        spread = 5;
        offset.x = 0;
        offset.y = 5;
        color = "#0007";
      };

      background-color = "transparent";
    };

    spawn-at-startup = [
      { argv = [ "noctalia" ]; }
    ];

    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    animations = {
      # off = true;
      # slowdown = 3.0;
    };

    debug = {
      honor-xdg-activation-with-invalid-serial = [];
    };

    window-rules = [
      {
        geometry-corner-radius = {
          top-left = 20.0;
          top-right = 20.0;
          bottom-right = 20.0;
          bottom-left = 20.0;
        };
        clip-to-geometry = true;
        draw-border-with-background = false;
      }
      {
        matches = [ { app-id = "^com\\.mitchellh\\.ghostty$"; } ];
        background-effect = {
          blur = true;
          xray = true;
        };
      }
      {
        matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
        default-column-width = {};
      }
      {
        matches = [ { app-id = "firefox$"; title = "^Picture-in-Picture$"; } ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "^dev\\.noctalia\\.Noctalia$"; } ];
        open-floating = true;
        default-column-width = { fixed = 1080; };
        default-window-height = { fixed = 920; };
      }
    ];

    layer-rules = [
      {
        matches = [ { namespace = "^noctalia-backdrop"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^noctalia-wallpaper"; } ];
        place-within-backdrop = true;
      }
    ];

    outputs = {
      # HDMI-A-1 (LG IPS FULLHD): 上
      "HDMI-A-1" = {
        position = { x = 0; y = 0; };
      };
      # DP-3 (Xiaomi P24FBA-RAGL): 下
      "DP-3" = {
        position = { x = 0; y = 1080; };
      };
    };

    binds = {
      "Mod+Shift+Slash".action.show-hotkey-overlay = {};

      "Mod+D" = {
        action.spawn-sh = [ "noctalia msg panel-toggle launcher" ];
      };
      "Mod+S" = {
        action.spawn-sh = [ "noctalia msg panel-toggle control-center" ];
      };
      "Mod+Semicolon" = {
        action.spawn-sh = [ "noctalia msg settings-toggle" ];
      };

      "Mod+T" = {
        hotkey-overlay.title = "Open a Terminal: ghostty";
        action.spawn = "ghostty";
      };
      "Super+Alt+L" = {
        hotkey-overlay.title = "Lock the Screen: swaylock";
        action.spawn = "swaylock";
      };

      "Super+Alt+S" = {
        allow-when-locked = true;
        hotkey-overlay.hidden = true;
        action.spawn-sh = [ "pkill orca || exec orca" ];
      };

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn-sh = [ "noctalia msg volume-up" ];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn-sh = [ "noctalia msg volume-down" ];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn-sh = [ "noctalia msg volume-mute" ];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn-sh = [ "noctalia msg mic-mute" ];
      };

      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn-sh = [ "playerctl play-pause" ];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn-sh = [ "playerctl play-pause" ];
      };
      "XF86AudioStop" = {
        allow-when-locked = true;
        action.spawn-sh = [ "playerctl stop" ];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn-sh = [ "playerctl previous" ];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn-sh = [ "playerctl next" ];
      };

      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn-sh = [ "noctalia msg brightness-up" ];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn-sh = [ "noctalia msg brightness-down" ];
      };

      "Mod+O" = {
        repeat = false;
        action.toggle-overview = {};
      };

      "Mod+Q".action.close-window = {};

      "Mod+Left".action.focus-column-left = {};
      "Mod+Down".action.focus-window-down = {};
      "Mod+Up".action.focus-window-up = {};
      "Mod+Right".action.focus-column-right = {};
      "Mod+H".action.focus-column-left = {};
      "Mod+J".action.focus-window-down = {};
      "Mod+K".action.focus-window-up = {};
      "Mod+L".action.focus-column-right = {};

      "Mod+Ctrl+Left".action.move-column-left = {};
      "Mod+Ctrl+Down".action.move-window-down = {};
      "Mod+Ctrl+Up".action.move-window-up = {};
      "Mod+Ctrl+Right".action.move-column-right = {};
      "Mod+Ctrl+H".action.move-column-left = {};
      "Mod+Ctrl+J".action.move-window-down = {};
      "Mod+Ctrl+K".action.move-window-up = {};
      "Mod+Ctrl+L".action.move-column-right = {};

      "Mod+Home".action.focus-column-first = {};
      "Mod+End".action.focus-column-last = {};
      "Mod+Ctrl+Home".action.move-column-to-first = {};
      "Mod+Ctrl+End".action.move-column-to-last = {};

      "Mod+Shift+Left".action.focus-monitor-left = {};
      "Mod+Shift+Down".action.focus-monitor-down = {};
      "Mod+Shift+Up".action.focus-monitor-up = {};
      "Mod+Shift+Right".action.focus-monitor-right = {};
      "Mod+Shift+H".action.focus-monitor-left = {};
      "Mod+Shift+J".action.focus-monitor-down = {};
      "Mod+Shift+K".action.focus-monitor-up = {};
      "Mod+Shift+L".action.focus-monitor-right = {};

      "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};
      "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
      "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
      "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = {};
      "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = {};
      "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};

      "Mod+Page_Down".action.focus-workspace-down = {};
      "Mod+Page_Up".action.focus-workspace-up = {};
      "Mod+U".action.focus-workspace-down = {};
      "Mod+I".action.focus-workspace-up = {};
      "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
      "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
      "Mod+Ctrl+I".action.move-column-to-workspace-up = {};

      "Mod+Shift+Page_Down".action.move-workspace-down = {};
      "Mod+Shift+Page_Up".action.move-workspace-up = {};
      "Mod+Shift+U".action.move-workspace-down = {};
      "Mod+Shift+I".action.move-workspace-up = {};

      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action.focus-workspace-down = {};
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action.focus-workspace-up = {};
      };
      "Mod+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-down = {};
      };
      "Mod+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action.move-column-to-workspace-up = {};
      };

      "Mod+WheelScrollRight".action.focus-column-right = {};
      "Mod+WheelScrollLeft".action.focus-column-left = {};
      "Mod+Ctrl+WheelScrollRight".action.move-column-right = {};
      "Mod+Ctrl+WheelScrollLeft".action.move-column-left = {};

      "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
      "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
      "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
      "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+Ctrl+1".action.move-column-to-workspace = 1;
      "Mod+Ctrl+2".action.move-column-to-workspace = 2;
      "Mod+Ctrl+3".action.move-column-to-workspace = 3;
      "Mod+Ctrl+4".action.move-column-to-workspace = 4;
      "Mod+Ctrl+5".action.move-column-to-workspace = 5;
      "Mod+Ctrl+6".action.move-column-to-workspace = 6;
      "Mod+Ctrl+7".action.move-column-to-workspace = 7;
      "Mod+Ctrl+8".action.move-column-to-workspace = 8;
      "Mod+Ctrl+9".action.move-column-to-workspace = 9;

      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};

      "Mod+Comma".action.consume-window-into-column = {};
      "Mod+Period".action.expel-window-from-column = {};

      "Mod+R".action.switch-preset-column-width = {};
      "Mod+Shift+R".action.switch-preset-column-width-back = {};
      "Mod+Ctrl+Shift+R".action.switch-preset-window-height = {};
      "Mod+Ctrl+R".action.reset-window-height = {};

      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+M".action.maximize-window-to-edges = {};
      "Mod+Ctrl+F".action.expand-column-to-available-width = {};

      "Mod+C".action.center-column = {};
      "Mod+Ctrl+C".action.center-visible-columns = {};

      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      "Mod+V".action.toggle-window-floating = {};
      "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};
      "Mod+W".action.toggle-column-tabbed-display = {};

      "Print".action.screenshot = {};
      "Ctrl+Print".action.screenshot-screen = {};
      "Alt+Print".action.screenshot-window = {};

      "Mod+Escape" = {
        allow-inhibiting = false;
        action.toggle-keyboard-shortcuts-inhibit = {};
      };

      "Mod+Shift+E".action.quit = {};
      "Ctrl+Alt+Delete".action.quit = {};
      "Mod+Shift+P".action.power-off-monitors = {};
    };
  };

  xdg.configFile."nvim".source = ./nvim;

  programs.zellij = {
    enable = true;

    settings = {
      theme = "default";
      default_mode = "normal";
      default_shell = "zsh";
      show_startup_tips = false;

      plugins = {
        about._props.location = "zellij:about";
        compact-bar._props.location = "zellij:compact-bar";
        configuration._props.location = "zellij:configuration";
        filepicker = {
          _props = {
            location = "zellij:strider";
            cwd = "/";
          };
        };
        plugin-manager._props.location = "zellij:plugin-manager";
        session-manager._props.location = "zellij:session-manager";
        status-bar._props.location = "zellij:status-bar";
        strider._props.location = "zellij:strider";
        tab-bar._props.location = "zellij:tab-bar";
        welcome-screen = {
          _props = {
            location = "zellij:session-manager";
            welcome_screen = true;
          };
        };
      };

      load_plugins = {
        _children = [
          { "zellij:link" = []; }
        ];
      };

      web_client = {
        font = "monospace";
      };
    };

    extraConfig = ''
      keybinds clear-defaults=true {
          locked {
              bind "Ctrl g" { SwitchToMode "normal"; }
          }
          pane {
              bind "left" { MoveFocus "left"; }
              bind "down" { MoveFocus "down"; }
              bind "up" { MoveFocus "up"; }
              bind "right" { MoveFocus "right"; }
              bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
              bind "d" { NewPane "down"; SwitchToMode "normal"; }
              bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "normal"; }
              bind "f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
              bind "h" { MoveFocus "left"; }
              bind "i" { TogglePanePinned; SwitchToMode "normal"; }
              bind "j" { MoveFocus "down"; }
              bind "k" { MoveFocus "up"; }
              bind "l" { MoveFocus "right"; }
              bind "n" { NewPane; SwitchToMode "normal"; }
              bind "p" { SwitchFocus; }
              bind "Ctrl p" { SwitchToMode "normal"; }
              bind "r" { NewPane "right"; SwitchToMode "normal"; }
              bind "s" { NewPane "stacked"; SwitchToMode "normal"; }
              bind "w" { ToggleFloatingPanes; SwitchToMode "normal"; }
              bind "z" { TogglePaneFrames; SwitchToMode "normal"; }
          }
          tab {
              bind "left" { GoToPreviousTab; }
              bind "down" { GoToNextTab; }
              bind "up" { GoToPreviousTab; }
              bind "right" { GoToNextTab; }
              bind "1" { GoToTab 1; SwitchToMode "normal"; }
              bind "2" { GoToTab 2; SwitchToMode "normal"; }
              bind "3" { GoToTab 3; SwitchToMode "normal"; }
              bind "4" { GoToTab 4; SwitchToMode "normal"; }
              bind "5" { GoToTab 5; SwitchToMode "normal"; }
              bind "6" { GoToTab 6; SwitchToMode "normal"; }
              bind "7" { GoToTab 7; SwitchToMode "normal"; }
              bind "8" { GoToTab 8; SwitchToMode "normal"; }
              bind "9" { GoToTab 9; SwitchToMode "normal"; }
              bind "[" { BreakPaneLeft; SwitchToMode "normal"; }
              bind "]" { BreakPaneRight; SwitchToMode "normal"; }
              bind "b" { BreakPane; SwitchToMode "normal"; }
              bind "h" { GoToPreviousTab; }
              bind "j" { GoToNextTab; }
              bind "k" { GoToPreviousTab; }
              bind "l" { GoToNextTab; }
              bind "n" { NewTab; SwitchToMode "normal"; }
              bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
              bind "s" { ToggleActiveSyncTab; SwitchToMode "normal"; }
              bind "Ctrl t" { SwitchToMode "normal"; }
              bind "x" { CloseTab; SwitchToMode "normal"; }
              bind "tab" { ToggleTab; }
          }
          resize {
              bind "left" { Resize "Increase left"; }
              bind "down" { Resize "Increase down"; }
              bind "up" { Resize "Increase up"; }
              bind "right" { Resize "Increase right"; }
              bind "+" { Resize "Increase"; }
              bind "-" { Resize "Decrease"; }
              bind "=" { Resize "Increase"; }
              bind "H" { Resize "Decrease left"; }
              bind "J" { Resize "Decrease down"; }
              bind "K" { Resize "Decrease up"; }
              bind "L" { Resize "Decrease right"; }
              bind "h" { Resize "Increase left"; }
              bind "j" { Resize "Increase down"; }
              bind "k" { Resize "Increase up"; }
              bind "l" { Resize "Increase right"; }
              bind "Ctrl n" { SwitchToMode "normal"; }
          }
          move {
              bind "left" { MovePane "left"; }
              bind "down" { MovePane "down"; }
              bind "up" { MovePane "up"; }
              bind "right" { MovePane "right"; }
              bind "h" { MovePane "left"; }
              bind "Ctrl h" { SwitchToMode "normal"; }
              bind "j" { MovePane "down"; }
              bind "k" { MovePane "up"; }
              bind "l" { MovePane "right"; }
              bind "n" { MovePane; }
              bind "p" { MovePaneBackwards; }
              bind "tab" { MovePane; }
          }
          scroll {
              bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "normal"; }
              bind "Alt down" { MoveFocus "down"; SwitchToMode "normal"; }
              bind "Alt up" { MoveFocus "up"; SwitchToMode "normal"; }
              bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "normal"; }
              bind "e" { EditScrollback; SwitchToMode "normal"; }
              bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "normal"; }
              bind "Alt j" { MoveFocus "down"; SwitchToMode "normal"; }
              bind "Alt k" { MoveFocus "up"; SwitchToMode "normal"; }
              bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "normal"; }
              bind "s" { SwitchToMode "entersearch"; SearchInput 0; }
          }
          search {
              bind "c" { SearchToggleOption "CaseSensitivity"; }
              bind "n" { Search "down"; }
              bind "o" { SearchToggleOption "WholeWord"; }
              bind "p" { Search "up"; }
              bind "w" { SearchToggleOption "Wrap"; }
          }
          session {
              bind "a" {
                  LaunchOrFocusPlugin "zellij:about" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "normal"
              }
              bind "c" {
                  LaunchOrFocusPlugin "configuration" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "normal"
              }
              bind "l" {
                  LaunchOrFocusPlugin "zellij:layout-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "normal"
              }
              bind "Ctrl o" { SwitchToMode "normal"; }
              bind "p" {
                  LaunchOrFocusPlugin "plugin-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "normal"
              }
              bind "s" {
                  LaunchOrFocusPlugin "zellij:share" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "normal"
              }
              bind "w" {
                  LaunchOrFocusPlugin "session-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "normal"
              }
          }
          shared_except "locked" {
              bind "Alt +" { Resize "Increase"; }
              bind "Alt -" { Resize "Decrease"; }
              bind "Alt =" { Resize "Increase"; }
              bind "Alt [" { PreviousSwapLayout; }
              bind "Alt ]" { NextSwapLayout; }
              bind "Alt f" { ToggleFloatingPanes; }
              bind "Ctrl g" { SwitchToMode "locked"; }
              bind "Alt i" { MoveTab "left"; }
              bind "Alt n" { NewPane; }
              bind "Alt o" { MoveTab "right"; }
              bind "Alt p" { TogglePaneInGroup; }
              bind "Alt Shift p" { ToggleGroupMarking; }
              bind "Ctrl q" { Quit; }
          }
          shared_except "locked" "move" {
              bind "Ctrl h" { SwitchToMode "move"; }
          }
          shared_except "locked" "session" {
              bind "Ctrl o" { SwitchToMode "session"; }
          }
          shared_except "locked" "scroll" {
              bind "Alt left" { MoveFocusOrTab "left"; }
              bind "Alt down" { MoveFocus "down"; }
              bind "Alt up" { MoveFocus "up"; }
              bind "Alt right" { MoveFocusOrTab "right"; }
              bind "Alt h" { MoveFocusOrTab "left"; }
              bind "Alt j" { MoveFocus "down"; }
              bind "Alt k" { MoveFocus "up"; }
              bind "Alt l" { MoveFocusOrTab "right"; }
          }
          shared_except "locked" "scroll" "search" "tmux" {
              bind "Ctrl b" { SwitchToMode "tmux"; }
          }
          shared_except "locked" "scroll" "search" {
              bind "Ctrl s" { SwitchToMode "scroll"; }
          }
          shared_except "locked" "tab" {
              bind "Ctrl t" { SwitchToMode "tab"; }
          }
          shared_except "locked" "pane" {
              bind "Ctrl p" { SwitchToMode "pane"; }
          }
          shared_except "locked" "resize" {
              bind "Ctrl n" { SwitchToMode "resize"; }
          }
          shared_except "normal" "locked" "entersearch" {
              bind "enter" { SwitchToMode "normal"; }
          }
          shared_except "normal" "locked" "entersearch" "renametab" "renamepane" {
              bind "esc" { SwitchToMode "normal"; }
          }
          shared_among "pane" "tmux" {
              bind "x" { CloseFocus; SwitchToMode "normal"; }
          }
          shared_among "scroll" "search" {
              bind "PageDown" { PageScrollDown; }
              bind "PageUp" { PageScrollUp; }
              bind "left" { PageScrollUp; }
              bind "down" { ScrollDown; }
              bind "up" { ScrollUp; }
              bind "right" { PageScrollDown; }
              bind "Ctrl b" { PageScrollUp; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "normal"; }
              bind "d" { HalfPageScrollDown; }
              bind "Ctrl f" { PageScrollDown; }
              bind "h" { PageScrollUp; }
              bind "j" { ScrollDown; }
              bind "k" { ScrollUp; }
              bind "l" { PageScrollDown; }
              bind "Ctrl s" { SwitchToMode "normal"; }
              bind "u" { HalfPageScrollUp; }
          }
          entersearch {
              bind "Ctrl c" { SwitchToMode "scroll"; }
              bind "esc" { SwitchToMode "scroll"; }
              bind "enter" { SwitchToMode "search"; }
          }
          renametab {
              bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
          }
          shared_among "renametab" "renamepane" {
              bind "Ctrl c" { SwitchToMode "normal"; }
          }
          renamepane {
              bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
          }
          shared_among "session" "tmux" {
              bind "d" { Detach; }
          }
          tmux {
              bind "left" { MoveFocus "left"; SwitchToMode "normal"; }
              bind "down" { MoveFocus "down"; SwitchToMode "normal"; }
              bind "up" { MoveFocus "up"; SwitchToMode "normal"; }
              bind "right" { MoveFocus "right"; SwitchToMode "normal"; }
              bind "space" { NextSwapLayout; }
              bind "\"" { NewPane "down"; SwitchToMode "normal"; }
              bind "%" { NewPane "right"; SwitchToMode "normal"; }
              bind "," { SwitchToMode "renametab"; }
              bind "[" { SwitchToMode "scroll"; }
              bind "Ctrl b" { Write 2; SwitchToMode "normal"; }
              bind "c" { NewTab; SwitchToMode "normal"; }
              bind "h" { MoveFocus "left"; SwitchToMode "normal"; }
              bind "j" { MoveFocus "down"; SwitchToMode "normal"; }
              bind "k" { MoveFocus "up"; SwitchToMode "normal"; }
              bind "l" { MoveFocus "right"; SwitchToMode "normal"; }
              bind "n" { GoToNextTab; SwitchToMode "normal"; }
              bind "o" { FocusNextPane; }
              bind "p" { GoToPreviousTab; SwitchToMode "normal"; }
              bind "z" { ToggleFocusFullscreen; SwitchToMode "normal"; }
          }
      }
    '';
  };

  home.file.".emacs.d/init.el".source = ./emacs/init.el;
}
