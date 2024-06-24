{ pkgs, ... }:

{
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    extensions = [
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
      "--enable-features=UseOzonePlatform,ForceDarkMode --ozone-platform=wayland"
      "--force-dark-mode='Enabled with selective inversion of non-image elements'"
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  };

  home.packages = with pkgs;
    let
      brave = makeDesktopItem {
        name = "BraveBrowser";
        desktopName = "Brave Browser";
        exec = "braveContainer-launcher";
        icon = "brave-browser";
        comment = "run brave inside a container";
        genericName = "Desktop application to manage brave.";
        categories = [ "Network" "WebBrowser" ];
      };
    in
    [
      brave
    ];
}
