{ pkgs, ... }:

{
  # Fonts are nice to have
  fonts.packages = with pkgs; [
    # Fonts
     (nerdfonts.override { fonts = [ "Inconsolata" ]; })
    # nerd-fonts._0xproto
    # nerd-fonts.droid-sans-mono
    # powerline
    inconsolata
    # nerd-fonts.inconsolata
    iosevka
    font-awesome
    ubuntu_font_family
    ubuntu-classic
    terminus_font
  ];

}
