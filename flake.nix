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
            # asunder は nixpkgs の定義で makeWrapper による PATH 付与しか行っておらず、
            # GTK3 の gsettings schemas (org.gtk.Settings.FileChooser 等) が
            # XDG_DATA_DIRS に入らない。起動時に
            #   Settings schema 'org.gtk.Settings.FileChooser' is not installed
            # で abort するため、wrapGAppsHook3 で schema パスをラッパーに付与する。
            (final: prev: {
              asunder = prev.asunder.overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.wrapGAppsHook3 ];
              });
            })
            # dsh は Node の internal module を node-addon-require-builtin の
            # prebuilt native addon 経由で読む。この addon は実行中の node の
            # マシンコードをパターン照合して V8 のフィールド offset を復元するため、
            # nixpkgs のビルドフラグ次第で一致しなくなり起動時に abort する:
            #   node-addon-require-builtin unsupported: Unsupported/no-getter
            #   (x64 sysv getter is not a recognized this->field accessor)
            # x86_64 の原因は hardening `zerocallusedregs`
            # (-fzero-call-used-regs=used-gpr) が getter の epilogue に足す xor。
            # node だけ再ビルドして外す (他パッケージへの波及なし)。
            # arm64 は原因が別で cc-wrapper の leaf frame pointer フラグなので、
            # そちらでは NIX_CFLAGS_COMPILE = "-fomit-frame-pointer -momit-leaf-frame-pointer"。
            (final: prev: {
              llm-agents = prev.llm-agents // {
                dsh = prev.llm-agents.dsh.override {
                  # runtime に npm は要らない (`dsh plugin` の pnpm は別途) ので slim でよい。
                  nodejs = final.nodejs-slim.overrideAttrs {
                    hardeningDisable = [ "zerocallusedregs" ];
                  };
                };
              };
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
