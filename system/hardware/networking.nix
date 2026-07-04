{ self, lib, pkgs, systemSettings, ... }:

{


  networking = {
    # bridges.br0.interfaces = [ "enp8s0" ]; 
    # interfaces.br0.ipv4.addresses = [{
    #   address = "192.168.10.40";
    #   prefixLength = 24;
    # }];
    hostName = systemSettings.hostname; # Define your hostname.
    wireless.enable = lib.mkForce false;

    #firewall.interfaces."br0".allowedTCPPorts = [ 80 443 8080 57621 4070];
    #firewall.interfaces."br0".allowedUDPPorts = [ 5353 ];

    interfaces."enp8s0".useDHCP = true;
    #defaultGateway = "192.168.10.1";
    #nameservers = [ "192.168.10.1" ];

    # Lazy IPv6 connectivity for the container
    enableIPv6 = false;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8080 4070 ];
      allowedUDPPorts = [ 5353 ];
      allowedUDPPortRanges = [
        { from = 4000; to = 4007; }
        { from = 8000; to = 8010; }
      ];
    };

    networkmanager.enable = true;

  };

}
