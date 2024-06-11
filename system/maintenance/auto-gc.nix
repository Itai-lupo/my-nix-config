{
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "daily";
    options = "-d";
  };
}
