{ config, pkgs, lib, ... }:
{
  services.ollama = {
    enable = true;
    rocmOverrideGfx = "10.3.0";
    loadModels = [
      "qwen2.5-coder:7b" # around 7 Gib quick codeing tasks
      "qwen2.5-coder:1.5b" # around 1Gib of ram, code for code compliton and running in the background with other models
      "deepseek-r1:1.5b" # same but also good for preloading the heabey deepseek models
      "deepseek-r1:8b" # around 8 Gib - Quick terminal logic and general questions
      "deepseek-r1:32b" # around 20 to 24 Gib code for big context R&D
      "nomic-embed-text" # for file indexing very very small
    ];
    package = pkgs.ollama-rocm;

    environmentVariables = {
      OLLAMA_MAX_LOADED_MODELS = "3";
      HSA_OVERRIDE_GFX_VERSION = "10.3.0"; # 🔥 Forces ROCm to accept the RX 6600
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/ollama - - - - /persist/var/lib/ollama"
  ];

  systemd.services.ollama.serviceConfig = {
    DynamicUser = lib.mkForce false;
    StateDirectory = lib.mkForce "";
    WorkingDirectory = lib.mkForce "/persist/var/lib/ollama";
    Environment = "OLLAMA_MODELS=/persist/var/lib/ollama/models";
    User = "ollama";
    Group = [ "ollama" "video" "render" ];
  };

  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    home = "/persist/var/lib/ollama";
  };

  users.groups.ollama = { };
}
