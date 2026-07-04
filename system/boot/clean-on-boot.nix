{ lib, pkgs, ... }:

{

  boot.supportedFilesystems = [ "btrfs" ];
  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=0"
    "pcie_aspm=off"
    "systemd.debug_shell=1"
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "nvme_core"
    "btrfs"
    "amdgpu"
    "pci_hyperv"
    "ahci"
    "xhci_pci"
    "vfat"
    "nls_cp437"
    "nls_iso8859_1"
    "usbhid"
  ];
  boot.initrd.systemd.settings.Manager.DefaultTimeoutStartSec = "20s";
  environment.etc = {
    nixos.source = "/persist/settings/etc/nixos";
    adjtime.source = "/persist/settings/etc/adjtime";
    NIXOS.source = "/persist/settings/etc/NIXOS";
    machine-id.source = "/persist/settings/etc/machine-id";
  };

  environment.persistence."/persist" =
    {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/bluetooth"
      ];
    };

  systemd.tmpfiles.rules = [
  ];

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  boot.initrd.systemd.initrdBin = with pkgs; [
    util-linux
    btrfs-progs
    coreutils
  ];

  boot.initrd.services.udev.binPackages = [ pkgs.btrfs-progs ];
  boot.initrd.services.udev.rules = ''
    ACTION=="add|change", SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="btrfs", RUN+="${pkgs.btrfs-progs}/bin/btrfs device scan"
  '';


  boot.initrd.systemd.services.rollback = {
    description = "Rollback Btrfs root subvolume to a pristine state";
    wantedBy = [ "initrd.target" ];
    unitConfig.RequiresMountsFor = [ "/dev/disk/by-uuid/28c813c2-69a5-45ca-b48a-3d7defbead5a" ];
    after = [ "dev-disk-by\\xuuid-28c813c2\\x2d69a5\\x2d45ca\\x2db48a\\x2d3d7defbead5a.device" ];
    requires = [ "dev-disk-by\\x2duuid-28c813c2\\x2d69a5\\x2d45ca\\x2db48a\\x2d3d7defbead5a.device" ];
    before = [ "sysroot.mount" ];

    unitConfig.DefaultDependencies = "no";

    serviceConfig.Type = "oneshot";

    path = with pkgs; [ btrfs-progs util-linux coreutils ];
    script = ''

    DEVICE="/dev/disk/by-uuid/28c813c2-69a5-45ca-b48a-3d7defbead5a"
    
    echo "Waiting for $DEVICE..."
    for i in {1..20}; do
      if [ -e "$DEVICE" ]; then
        echo "Device found!"
        break
      fi
      echo "Still waiting... ($i)"
      sleep 0.5
    done

    if [ ! -e "$DEVICE" ]; then
      echo "ERROR: Device never appeared. Dropping to shell."
      exit 1
    fi
      echo "Starting Btrfs rollback..."
      mkdir -p /mnt-root
      ls /dev/

      /bin/mount -t btrfs -o subvol=/ /dev/disk/by-uuid/28c813c2-69a5-45ca-b48a-3d7defbead5a /mnt-root

      if [ -e /mnt-root/root ]; then
          echo "Cleaning up existing /root subvolume..."
          btrfs subvolume list -o /mnt-root/root | cut -f9 -d' ' | while read subvolume; do
              echo "Deleting subvolume /$subvolume..."
              ${pkgs.btrfs-progs}/bin/btrfs subvolume delete "/mnt-root/$subvolume"
          done
          ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /mnt-root/root
      fi

      echo "Restoring /root from root-blank..."
      btrfs subvolume snapshot /mnt-root/root-blank /mnt-root/root

      /bin/umount /mnt-root
      rmdir /mnt-root
      echo "Btrfs rollback completed successfully."
    '';
  };

}
