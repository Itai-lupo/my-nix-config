{ config, inputs, lib, userSettings, pkgs, ... }:
{
  imports = [ ./braveRunner.nix ];


  containers.braveContainer =
    let
      hostCfg = config;
      userUid = hostCfg.users.users."${userSettings.username}".uid;

      inherit userSettings;
    in
    {
      ephemeral = true;
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
      tmpfs = [ "/var" "/tmp" ];

      bindMounts = {
        waylandSocket = rec {
          hostPath = "/run/user/${toString userUid}/";
          mountPoint = hostPath;
        };

        braveConfig = {
          hostPath = "/persist/dotfiles/brave/";
          mountPoint = "/home/${userSettings.username}/";
          isReadOnly = false;
        };


        downloads = {
          hostPath = "/persist/Downloads/";
          mountPoint = "/home/${userSettings.username}/Downloads/";
          isReadOnly = false;
        };
      };

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

        environment.systemPackages = with pkgs; [
          brave
        ];

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 443 8080 ];
            allowedUDPPorts = [ ];
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

        home-manager = {
          useGlobalPkgs = true;
          extraSpecialArgs = {
            inherit userSettings;
          };

          users.${userSettings.username} = {
            home.username = userSettings.username;
            home.stateVersion = "23.11";

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


}
