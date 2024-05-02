{ self, config, lib, pkgs, systemSettings, userSettings, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../system/users.nix
      ../../system/boot/clean-on-boot.nix
      ../../system/boot/systemd-boot.nix
      ../../system/hardware/opengl.nix
      ../../system/hardware/networking.nix
      ../../system/hardware/sound.nix
      ../../system/wm/kde6.nix
    ];

  nixpkgs.config.allowUnfree = true;

  hardware.enableAllFirmware = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;


  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  environment.systemPackages = with pkgs; [
     wget
     neovim
     tmux
     git
     fish
     manix 
     fishPlugins.done
     fishPlugins.fzf-fish
     fishPlugins.forgit
     fishPlugins.hydro
     fzf
     fishPlugins.grc
     grc

   ];

 
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11";
}

