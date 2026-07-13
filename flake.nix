{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.sanatia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.hjem.nixosModules.default
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
