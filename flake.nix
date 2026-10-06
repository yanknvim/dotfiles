{
  description = "NixOS configuration";
inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    skkeleton = {
      url = "github:vim-skk/skkeleton";
      flake = false;
    };

    flix-nvim = {
      url = "github:flix/nvim";
      flake = false;
    };

    veryl-vim = {
      url = "github:veryl-lang/veryl.vim";
      flake = false;
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      # Do NOT follow the local nixpkgs: hermes-agent hardcodes the sha256 for
      # electron's node-v*-headers tarball in nix/desktop.nix, so it only builds
      # against its own pinned nixpkgs (electron 41.10.3). Following the local,
      # newer nixpkgs resolves electron 43.4.1 and breaks the fetch (hash
      # mismatch on node-v43.4.1-headers.tar.gz).
    };

    turboquant = {
      url = "github:TheTom/llama-cpp-turboquant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, nixvim, llm-agents, ... }@inputs: {
    nixosConfigurations.sanatia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        niri.nixosModules.niri
        {
          nixpkgs.overlays = [
            niri.overlays.niri
            llm-agents.overlays.shared-nixpkgs
            # herdr fails to link with binutils 2.46's bfd ld:
            # "ld.bfd: .eh_frame_hdr refers to overlapping FDEs". The FDE
            # overlap comes from the zig-built libghostty-vt objects + rustc's
            # .eh_frame under --gc-sections; newer bfd hard-errors where lld
            # tolerates it. Link herdr with lld instead.
            (final: prev: {
              herdr = prev.herdr.overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.lld ];
                NIX_LDFLAGS = (old.NIX_LDFLAGS or "") + " -fuse-ld=lld";
              });
            })
          ];
        }
        home-manager.nixosModules.home-manager
        ./configuration.nix
        ./hardware-configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.yank = import ./home.nix;
        }
      ];
    };
  };
}
