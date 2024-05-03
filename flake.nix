{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


     # Neovim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { nixpkgs, home-manager, ... }@inputs: 
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
		   home-manager.nixosModules.home-manager
                   {
                     home-manager.useGlobalPkgs = true;
                     home-manager.useUserPackages = true;
                     home-manager.users.${userSettings.username} = import  (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix");
		     home-manager.extraSpecialArgs = {
		       inherit systemSettings;
                       inherit userSettings;
                       inherit inputs;
		     };
                   }
                ];

              specialArgs = {
                # pass config variables from above
                inherit systemSettings;
                inherit userSettings;
                inherit inputs;
             };

	           };
       };
}
