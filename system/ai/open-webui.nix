{ config, pkgs, lib, ... }:

{
  services.open-webui = {
    enable = true;
    port = 8080;

    stateDir = "/persist/var/lib/open-webui";
    environment = {
      OPENAI_API_BASE_URL = "http://127.0.0.1:4000/v1";
      OPENAI_API_KEY = "sk-1234";

      WEBUI_AUTH = "False";


      # OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/open-webui - - - - /persist/var/lib/open-webui"
  ];

  systemd.services.open-webui = {
    after = [ "persist.mount" ];
    requires = [ "persist.mount" ];
    serviceConfig = {
      WorkingDirectory = lib.mkForce "/persist/var/lib/open-webui";

      StateDirectory = lib.mkForce "";

      DynamicUser = lib.mkForce false;
      User = "open-webui";
      Group = "open-webui";
    };
  };

  users.users.open-webui = {
    isSystemUser = true;
    group = "open-webui";
    home = "/persist/var/lib/open-webui";
  };
  users.groups.open-webui = { };
}

