{ ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.docker.storageDriver = "btrfs";

  virtualisation.docker.daemon.settings = {
    data-root = "/persist/dotfiles/docker/";
  };

}

