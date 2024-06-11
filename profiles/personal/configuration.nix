{ pkgs, systemSettings, userSettings, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # system settings:
      ../../system/users.nix
      ../../system/maintenance/auto-update.nix
      ../../system/maintenance/auto-gc.nix
      ../../system/boot/clean-on-boot.nix
      ../../system/boot/systemd-boot.nix
      ../../system/hardware/opengl.nix
      ../../system/hardware/networking.nix
      ../../system/hardware/sound.nix
      ../../system/wm/${systemSettings.wm}.nix
      ../../system/wm/fonts.nix

      # system apps:
      ../../system/app/tmux.nix
      ../../system/app/docker.nix

      ../../system/containers/browsers/brave.nix

    ];

  nixpkgs.config.allowUnfree = true;

  hardware.enableAllFirmware = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;


  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  environment.systemPackages =
    let
      containerName = "braveContainer";
      braveLauncher = pkgs.writeScriptBin "${containerName}-launcher" ''
        #!${pkgs.stdenv.shell}
        set -euo pipefail

        if [[ "$(systemctl is-active container@${containerName}.service)" != "active" ]]; then
            systemctl start container@${containerName}.service
            machinectl shell ${userSettings.username}@${containerName} /usr/bin/env bash --login -c "exec ${pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --ozone-platform=wayland"
            machinectl kill ${containerName} 
        else
            machinectl shell ${userSettings.username}@${containerName} /usr/bin/env bash --login -c "exec ${pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --ozone-platform=wayland"
        fi

      '';
    in
    with pkgs; [
      braveLauncher
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

