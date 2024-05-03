{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      vim = "nvim";

    };
  };
}
