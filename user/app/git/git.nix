{ pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  programs.git.userName = userSettings.name;
  programs.git.userEmail = userSettings.email;
  programs.git.extraConfig = {
    init.defaultBranch = "master";
  };

  home.persistence."/persist/dotfiles" = {
    files = [
      ".ssh/id_ed25519.pub"
      ".ssh/id_ed25519"
      ".ssh/known_hosts"
    ];
  };
}

