{ pkgs, userSettings, myutils, ... }:
myutils.mkContainerPackage
{
  inherit pkgs;
  inherit (userSettings) username;
  containerName = "steamContainer";
  appToLaunch = "bash steam "; #~/gs.sh";
}
