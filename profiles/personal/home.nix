{ config, pkgs, userSettings, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
   inputs.nixvim.homeManagerModules.nixvim

    ../../user/app/browser/brave.nix
    ../../user/app/git/git.nix
    ../../user/app/shell/fish.nix
    ../../user/app/shell/bash.nix
    ../../user/app/shell/tmux.nix
    ../../user/app/editors/nvim.nix
    
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [
     spotify
     obsidian
   ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  home.stateVersion = "23.11"; 
}
