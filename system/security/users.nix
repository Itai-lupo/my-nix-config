{ self, config, lib, pkgs, systemSettings, userSettings, ... }:

{
  users.users."root".hashedPassword = lib.strings.fileContents /${systemSettings.dotfilePath}/${systemSettings.secretsPath}/passwords/root;

  users.users.${userSettings.username} = {
    hashedPassword = lib.strings.fileContents /${systemSettings.dotfilePath}/${systemSettings.secretsPath}/passwords/${userSettings.username};
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "wheel" "input" "dialout" "docker" "kvm" "libvirtd" "gamemode" "video" ];
    uid = 1000;
  };

  security.sudo.execWheelOnly = true;

  security.pam.services.systemd-run0 = { };

}
