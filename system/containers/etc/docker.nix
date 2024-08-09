_:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    storageDriver = "btrfs";

    daemon.settings = {
      data-root = "/persist/dotfiles/docker/";
    };

  };

  virtualisation.oci-containers.backend = "docker";

}

