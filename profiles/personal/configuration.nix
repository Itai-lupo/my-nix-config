{ pkgs, systemSettings, userSettings, myutils, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # system settings:
      ../../system/security/users.nix
      ../../system/maintenance/auto-update.nix
      ../../system/maintenance/auto-gc.nix
      ../../system/boot/clean-on-boot.nix
      ../../system/boot/systemd-boot.nix
      ../../system/hardware/opengl_${systemSettings.gpuType}.nix
      ../../system/hardware/networking.nix
      ../../system/hardware/sound.nix
      ../../system/wm/${systemSettings.wm}.nix
      ../../system/wm/fonts.nix

      # system apps:
      ../../system/app/tmux.nix
      ../../system/app/docker.nix
      ../../system/app/games/steam.nix


      ../../system/containers/browsers/brave.nix

    ];

  nixpkgs.config.allowUnfree = true;

  hardware.enableAllFirmware = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "eurosign:e,caps:escape";
  };

  services.ratbagd.enable = true;
  services.hardware.openrgb.enable = true;



  environment.systemPackages =
    with pkgs; [
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
      tree
      moreutils
      killall
      piper
      liquidctl

      (myutils.mkContainerPackage
      {
        inherit pkgs;
        inherit (userSettings) username;
        containerName = "braveContainer";
        appToLaunch = "exec ${pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --ozone-platform=wayland";
      })


    ];


  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };

  programs.dconf = {
    enable = true;
  };

  programs.fuse.userAllowOther = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.11";
}

