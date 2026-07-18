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
  };

  outputs = { self, nixpkgs, home-manager, niri, nixvim, ... }@inputs: {
    nixosConfigurations.sanatia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        niri.nixosModules.niri
        { nixpkgs.overlays = [ niri.overlays.niri ]; }
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
