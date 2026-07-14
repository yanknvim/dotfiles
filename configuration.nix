{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "sanatia";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "ja_JP.UTF-8";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-skk
      ];
    };
  };

  fonts.packages = with pkgs;[
    noto-fonts
    noto-fonts-cjk-sans
    nerd-fonts.monaspace
  ];

  services.udev.extraRules = ''
  ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    polarity = "dark";

    cursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 24;
    };

    fonts = {
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans CJK JP";
      };
      monospace = {
        package = pkgs.nerd-fonts.monaspace;
        name = "MonaspiceAr Nerd Font";
      };
      sizes = {
        applications = 11;
        desktop = 11;
        terminal = 11;
        popups = 11;
      };
    };

    targets = {
      nixos-icons.enable = true;
      grub.enable = false;
    };
  };

  programs.zsh.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  programs.noctalia-greeter = {
    enable = true;
    greeter-args = "--session niri";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.xkb.layout = "us";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    extraConfig.pipewire-pulse."99-stop-microphone-auto-adjust" = {
      "pulse.rules" = [
        {
          matches = [
            { "application.process.binary" = "Discord"; }
          ];
          actions = {
            quirks = [ "block-source-volume" "block-sink-volume" ];
          };
        }
      ];
    };
  };

  users.users.yank = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "render" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      gh
      ghq
      stow
      fzf
      lazygit
      deno
      fastfetch
      btop
      skkDictionaries.l
      pi-coding-agent

      vesktop
      wayvr
      xrizer
      mangohud

      pavucontrol
    ];
  };
  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.wivrn = {
    enable = true;
    openFirewall = true;

    steam = {
      enable = true;
      importOXRRuntimes = true;
    };
  };

  programs.direnv.enable = true;

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    git
    zsh
    rustup
    gcc
    zellij
  ];

  services.openssh.enable = true;

  services.tailscale = {
    enable = true;
  };

  system.stateVersion = "26.05";
}
