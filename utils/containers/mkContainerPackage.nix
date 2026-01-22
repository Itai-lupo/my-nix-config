let
  mkContainerPackage = { pkgs, username, containerName, appToLaunch }:
    {

      config.environment.systemPackages =
        let
          containerPackage = pkgs.writeScriptBin "${containerName}-launcher" ''
            #!${pkgs.stdenv.shell}
            set -euo pipefail

            if [[ "$(systemctl is-active container@${containerName}.service)" != "active" ]]; then
                sudo systemctl start container@${containerName}.service
                sudo machinectl shell ${username}@${containerName} /usr/bin/env bash --login -c "${appToLaunch}"
                sudo machinectl kill ${containerName} 
            else
                sudo machinectl shell ${username}@${containerName} /usr/bin/env bash --login -c "${appToLaunch}"
            fi
  
          '';
        in
        [ containerPackage ];
    };
in
mkContainerPackage
