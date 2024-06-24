let
  mkContainerPackage = { pkgs, username, containerName, appToLaunch }:
    let
      containerPackage = pkgs.writeScriptBin "${containerName}-launcher" ''
        #!${pkgs.stdenv.shell}
        set -euo pipefail

        if [[ "$(systemctl is-active container@${containerName}.service)" != "active" ]]; then
            systemctl start container@${containerName}.service
            machinectl shell ${username}@${containerName} /usr/bin/env bash --login -c "${appToLaunch}"
            machinectl kill ${containerName} 
        else
            machinectl shell ${username}@${containerName} /usr/bin/env bash --login -c "${appToLaunch}"
        fi
  
      '';
    in
    containerPackage;
in
mkContainerPackage
