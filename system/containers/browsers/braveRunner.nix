{ pkgs, userSettings, myutils, ... }:
myutils.mkContainerPackage
{
  inherit pkgs;
  inherit (userSettings) username;
  containerName = "braveContainer";
  appToLaunch = "exec ${pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --ozone-platform=wayland";
}
