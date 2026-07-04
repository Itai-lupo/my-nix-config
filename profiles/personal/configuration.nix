{ pkgs
, lib
, systemSettings
, ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # system settings:
    ../../system/security/users.nix
    ../../system/maintenance/auto-update.nix
    ../../system/maintenance/auto-gc.nix
    ../../system/maintenance/btrbk.nix
    ../../system/boot/clean-on-boot.nix
    ../../system/boot/systemd-boot.nix
    ../../system/hardware/opengl_${systemSettings.gpuType}.nix
    ../../system/hardware/networking.nix
    ../../system/hardware/sound.nix
    ../../system/hardware/bluetooth.nix
    ../../system/wm/${systemSettings.wm}.nix
    ../../system/wm/fonts.nix

    # system apps:
    ../../system/app/tmux.nix
    ../../system/app/nvim.nix
    ../../system/app/games/steam.nix
    ../../system/containers/browsers/brave.nix
    ../../system/containers/games/steam.nix
    ../../system/ai/litellm.nix
    ../../system/ai/ollama.nix
    ../../system/ai/open-webui.nix
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
  services.blueman.enable = true;
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [
      "network.target"
      "sound.target"
    ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  environment.systemPackages = with pkgs; [
    wget
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
    man-pages-posix
    man-pages
    lua-language-server
    nixd
    bash-language-server
    ruff
    bambu-studio
    ryzen-monitor-ng
    btrfs-progs
  ];

  documentation.dev.enable = true;
  documentation.man = {
    # In order to enable to mandoc man-db has to be disabled.
    man-db.enable = false;
    mandoc.enable = true;
  };

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
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "23.11";
}
