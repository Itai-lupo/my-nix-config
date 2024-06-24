{ ... }:

{
  home.persistence."/persist/dotfiles/steam" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [
      ".local/share/Steam/"
    ];
  };


}
