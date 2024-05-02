{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";
  };


  outputs = { self, nixpkgs, ... }@inputs: 
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
      };

      userSettings = rec {
        username = "itai";
	name = "itai lupo";
	email = "itailupo@gmail.com";
	dotfiles = ""; # need to set
	wm = "kde6";
	wmType = "wayland";
	browser = "brave";
	term = "konsole";
	editor = "nvim";
	spawnEditor = "exec " + term + " -e " + editor;
       };
       
        system = systemSettings.system;
#	pkgs = nixpkgs.legacyPackagets.${system};
       in {
         nixosConfigurations.default = nixpkgs.lib.nixosSystem {
              modules = [
                  (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
		  inputs.home-manager-unstable.nixosModules.default
                ]; # load configuration.nix from selected PROFILE
              specialArgs = {
                # pass config variables from above
		inherit self;
                inherit systemSettings;
                inherit userSettings;
                inherit inputs;
             };
        };
       };
}
