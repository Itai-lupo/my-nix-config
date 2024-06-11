# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/28c813c2-69a5-45ca-b48a-3d7defbead5a";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" "noexec" "nodev" ];
    };
  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/28c813c2-69a5-45ca-b48a-3d7defbead5a";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" "nodev" ];
    };

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-uuid/28c813c2-69a5-45ca-b48a-3d7defbead5a";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" "noexec" "nodev" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    {
      device = "/dev/disk/by-uuid/28c813c2-69a5-45ca-b48a-3d7defbead5a";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" "noexec" "nodev" "nosuid" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/2660-12E5";
      fsType = "vfat";
      options = [ "umask=077" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/949bcac8-1064-4f61-a7a3-9cfb15a358c1"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
