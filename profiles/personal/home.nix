{ pkgs, userSettings, systemSettings, lib, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../user/app/browser/brave.nix
    ../../user/app/git/git.nix
    ../../user/app/shell/fish.nix
    ../../user/app/shell/bash.nix
    ../../user/app/shell/tmux.nix
    ../../user/app/games/steam.nix
    ../../user/app/ai/aider.nix

    ../../user/wm/${systemSettings.wm}/${systemSettings.wm}.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs;
    [
      spotube
      spotify
      obsidian
      vscode
      ripgrep

      litellm
    ]);


  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  home.persistence."/persist/" =
    {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
      ];
    };


  home.persistence."/persist/dotfiles/home_persistence/" = {
    directories = [
      ".local/share/spotube"
      ".config/spotify"
      ".config/nvim"
      ".config/direnv"
      ".local/share/direnv"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.starship = {
    enable = true;
  };


  home.stateVersion = "26.05";
}
