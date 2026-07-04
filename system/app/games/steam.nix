{ userSettings, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
  ];

  programs.gamemode.enable = true;

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

}
