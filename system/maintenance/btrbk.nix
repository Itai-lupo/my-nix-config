{ pkgs, ... }:
{

  services.btrbk = {
    instances."persist-backup" = {
      # onCalendar = "hourly";

      settings = {
        backend = "btrfs-progs";
        snapshot_preserve_min = "1w";
        snapshot_preserve = "2w";
        target_preserve = "5w";


        target = "/mnt/backup";
        volume."/persist/" = {
          subvolume = ".";
          snapshot_dir = ".snapshots";
        };
      };
    };
  };

  systemd.services."btrbk-manual-run" = {
    description = "Manual Btrbk Run (Bypassing Sandbox)";
    path = with pkgs; [ btrfs-progs coreutils bash btrbk ];
    unitConfig.OnFailure = "btrbk-notify-fail.service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.btrbk}/bin/btrbk -c /etc/btrbk/persist-backup.conf run";
      User = "root";
    };
  };

  systemd.timers."btrbk-manual-run" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
  systemd.services."btrbk-notify-fail" = {
    description = "Notify on btrbk failure";
    path = [ pkgs.libnotify ];
    serviceConfig = {
      Type = "oneshot";
      User = "itai";
      ExecStart = ''${pkgs.libnotify}/bin/notify-send -u critical "Backup Failed" "btrbk-manual-run failed. Check journalctl." '';
    };
  };

}
