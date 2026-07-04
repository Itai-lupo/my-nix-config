{ config, inputs, lib, userSettings, pkgs, ... }:
{
  imports = [ ./steamRunner.nix ];


  containers.steamContainer =
    let
      hostCfg = config;
      userUid = hostCfg.users.users."${userSettings.username}".uid;

      inherit userSettings;
    in
    {
      # ephemeral = true;
      restartIfChanged = true;
      privateNetwork = false;
      hostAddress = "192.168.10.45";
      localAddress = "192.168.10.42/24";
      hostBridge = "br0";
      allowedDevices = [
        {
          modifier = "rwm";
          node = "/dev/dri/card1";
        }
        {
          modifier = "rwm";
          node = "/dev/dri/renderD128";
        }
      ];
      tmpfs = [ "/var" ];

      bindMounts = {
        waylandSocket = rec {
          hostPath = "/run/user/${toString userUid}/";
          mountPoint = hostPath;
        };

        steamConfig = {
          hostPath = "/persist/dotfiles/steam2/";
          mountPoint = "/home/${userSettings.username}/";
          isReadOnly = false;
        };

        dri = {
          hostPath = "/dev/dri/";
          mountPoint = "/dev/dri/";
          isReadOnly = false;
        };

        games = {
          hostPath = "/persist/Games/";
          mountPoint = "/Games";
          isReadOnly = false;
        };
      };
      additionalCapabilities = [
        "CAP_SYS_ADMIN"
        "CAP_SYS_PTRACE"
        "CAP_SYS_CHROOT"
        "CAP_SETUID"
        "CAP_SETGID"

      ];



      config = {

        boot.isContainer = true;

        imports = [
          (import "${inputs.home-manager}/nixos")
          ../../wm/fonts.nix
        ];

        hardware.graphics = {
          enable = true;
          extraPackages = hostCfg.hardware.graphics.extraPackages;
        };

        programs = {
          gamescope = {
            enable = true;
            capSysNice = true;
          };
          steam = {
            enable = true;
            gamescopeSession.enable = true;
          };
        };

        environment.systemPackages = with pkgs; [
          xterm
          mangohud
          protonup-ng
        ];
        /* environment. loginShellInit = ''
          [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
        ''; */
        programs.gamemode.enable = true;

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 443 8080 ];
            allowedTCPPortRanges = [{ from = 27015; to = 27050; }];

            allowedUDPPortRanges = [{ from = 27015; to = 27050; }];
            allowedUDPPorts = [ 3478 4379 43780 ];
          };
          defaultGateway = "192.168.10.1";
          nameservers = [ "192.168.10.1" ];
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        security.sudo.enable = false;

        services.resolved.enable = true;

        system.stateVersion = "23.11";

        users.users.${userSettings.username} = {
          isNormalUser = true;
          description = userSettings.name;
          extraGroups = [ "input" "dialout" "video" "render" ];
          uid = 1000;
        };

        nixpkgs.config.allowUnfree = true;

        home-manager = {
          useGlobalPkgs = true;
          extraSpecialArgs = {
            inherit userSettings;
          };

          users.${userSettings.username} = {
            home.username = userSettings.username;
            home.stateVersion = "26.05";

            programs.bash.enable = true;

            gtk.enable = true;

            home.sessionVariables = {
              WAYLAND_DISPLAY = "wayland-0";
              QT_QPA_PLATFORM = "wayland";
              QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
              SDL_VIDEODRIVER = "wayland";
              CLUTTER_BACKEND = "wayland";
              MOZ_ENABLE_WAYLAND = "1";
              _JAVA_AWT_WM_NONREPARENTING = "1";
              _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
              XDG_RUNTIME_DIR = "/run/user/${toString userUid}";
              DISPLAY = ":0";
              STEAM_DISABLE_SANDBOX = "1";
              STEAM_RUNTIME = 0;
            };
          };
        };

        systemd.services.fix-run-permission = {
          script = ''
            #!${pkgs.stdenv.shell}
            set -euo pipefail

            chown ${userSettings.username}:users /run/user/${toString userUid}
            chmod u=rwx /run/user/${toString userUid}
          '';
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
          };
        };
      };
    };

  systemd.services."container@steam-container".serviceConfig = {
    SystemCallFilter = ""; # Wipes the 5 seccomp filters entirely
    NoNewPrivileges = "no"; # Permits capset changes inside the sandbox
    CapabilityBoundingSet = "~"; # Gives the container permission to hold the caps you assigned
  };
}
