{ self, pkgs, ...}:
{
    hardware.opengl.enable = true;                                                                                                                                                                                   
    hardware.opengl.driSupport = true;   
    hardware.opengl.driSupport32Bit = true; # For 32 bit applications

    hardware.opengl.extraPackages = with pkgs; [
     amdvlk
   ];
   # For 32 bit applications 
   hardware.opengl.extraPackages32 = with pkgs; [
     driversi686Linux.amdvlk
   ];

}
