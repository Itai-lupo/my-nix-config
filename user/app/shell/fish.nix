{ ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      vim = "nvim";

    };
  };


  home.persistence."/persist/dotfiles/fish" = {
    files = [
      ".local/share/fish/fish_history"
    ];
  };
}
