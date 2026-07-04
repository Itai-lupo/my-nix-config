{
  description = "my system setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { nixpkgs, home-manager, impermanence, ... }@inputs:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostname = "itaiPc";
        profile = "personal";
        timezone = "Asia/Jerusalem";
        bootMode = "uefi";
        bootMountPath = "/boot";
        dotfilePath = "/persist/settings/etc/nixos/";
        secretsPath = "./secrets/";
        wm = "kde";
        wmType = "wayland";
        gpuType = "amd";
      };

      userSettings = rec {
        username = "itai";
        name = "itai lupo";
        email = "itailupo@gmail.com";
        dotfiles = "";
        browser = "brave";
        term = "konsole";
        editor = "nvim";
        spawnEditor = "exec " + term + " -e " + editor;
      };

      myutils = import ./utils/main.nix;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
        modules = [
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userSettings.username} = import (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix");
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit systemSettings;
              inherit userSettings;
              inherit inputs;
              inherit myutils;
            };
          }
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
        ];

        specialArgs = {
          # pass config variables from above
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
          inherit myutils;
        };

      };
    };
}
