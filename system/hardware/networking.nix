{ self, pkgs, systemSettings, ...}:

{
  networking.hostName = systemSettings.hostname; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
}
