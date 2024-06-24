{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true; # For 32 bit applications

    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      #amdvlk
    ];

    # For 32 bit applications 
    #extraPackages32 = with pkgs; [
    #driversi686Linux.amdvlk
    #];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

}
