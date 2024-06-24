{ config, userSettings, pkgs, inputs, lib, myutils, ... }:

{


  environment.systemPackages =
    let
      containerName = "braveContainer";
      braveLauncher = pkgs.writeScriptBin "${containerName}-launcher" ''
          #!${pkgs.stdenv.shell}
          set -euo pipefail
        if [[ "$(systemctl is-active container@${containerName}.service)" != "active" ]]; then
            systemctl start container@${containerName}.service
              machinectl shell ${userSettings.username}@${containerName} /usr/bin/env bash --login -c "exec ${pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --ozone-platform=wayland"
              machinectl kill ${containerName} 
          else
              machinectl shell ${userSettings.username}@${containerName} /usr/bin/env bash --login -c "exec ${pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --ozone-platform=wayland"
          fi

      '';
    in
    [ braveLauncher ];


  containers.braveContainer =
    let
      hostCfg = config;
      userUid = hostCfg.users.users."${userSettings.username}".uid;

      inherit userSettings;
    in
    {
      ephemeral = true;
      #      autoStart = true;

      bindMounts = {
        waylandSocket = rec {
          hostPath = "/run/user/${toString userUid}/";
          mountPoint = hostPath;
          #          isReadOnly = false;
        };

        dri = rec {
          hostPath = "/dev/dri";
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
        imports = [
          (import "${inputs.home-manager}/nixos")
        ];

        hardware.opengl = {
          enable = true;
          extraPackages = hostCfg.hardware.opengl.extraPackages;
        };

        environment.systemPackages = with pkgs; [
          brave
        ];

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 ];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;
        system.stateVersion = "23.11";
        users.users.${userSettings.username} = {
          isNormalUser = true;
          description = userSettings.name;
          extraGroups = [ "input" "dialout" "networkmanager" ];
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
