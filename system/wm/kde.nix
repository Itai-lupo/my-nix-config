{ self, pkgs, lib, ... }:
{
  services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;


  programs.kdeconnect.enable = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/plasmalogin.conf.d"
      "/var/lib/plasmalogin/"
    ];
    files = [
      "/etc/plasmalogin.conf"
    ];
  };
}
