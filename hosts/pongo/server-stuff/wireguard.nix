{ config, pkgs, ... }:

{

  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp6s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/root/wireguard-keys/private";

      peers = [
        # List of allowed peers.
        {
          # Xiaomi Redmi Note 9 Pro
          publicKey = "WW8ZsvD86xn7gAcf+/5QUz8TGAUV+6wCdpnCzj8sXn8=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # Lenovo ThinkPad T430
          publicKey = "w4NkX56RIqepiNzhL+tnH+EOkDqVFrhSbR96jFtCqkA=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };

}

