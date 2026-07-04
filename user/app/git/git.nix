{ pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  programs.git.settings.user = {
    name = userSettings.name;
    email = userSettings.email;
  };

  programs.git.settings.extraConfig = {
    init.defaultBranch = "master";
  };

  home.persistence."/persist/dotfiles/home_persistence/" = {
    files = [
      ".ssh/id_ed25519.pub"
      ".ssh/id_ed25519"
      ".ssh/known_hosts"
    ];
  };
}

