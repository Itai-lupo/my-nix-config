{ pkgs, ... }:
{
  hardware = {
    cpu.amd.ryzen-smu.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

}

