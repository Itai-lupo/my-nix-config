{ self, config, lib, pkgs, systemSettings, userSettings, ...}:

{
  users.users."root".hashedPassword = lib.strings.fileContents /${systemSettings.dotfilePath}/${systemSettings.secretsPath}/passwords/root;

  users.users.${userSettings.username} = {
     hashedPassword = lib.strings.fileContents /${systemSettings.dotfilePath}/${systemSettings.secretsPath}/passwords/${userSettings.username};
     isNormalUser = true;
     description = userSettings.name;
     extraGroups = [ "wheel" "input" "dialout" "networkmanager" ];
     uid = 1000;
  };
}
