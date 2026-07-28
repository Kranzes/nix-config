{ pkgs, ... }:
{
  services.deluge = {
    enable = true;
    web.enable = true;
    # TODO: remove when https://github.com/NixOS/nixpkgs/issues/540545 is fixed
    package = pkgs.deluge-2_x.overridePythonAttrs (old: {
      propagatedBuildInputs = map (
        p: if p.pname or null == "setuptools" then pkgs.python3Packages.setuptools_80 else p
      ) old.propagatedBuildInputs;
    });
  };
  systemd.services.deluged.serviceConfig.SupplementaryGroups = [ "media" ];

  networking.firewall.allowedTCPPorts = [ 58946 ];
  networking.firewall.allowedUDPPorts = [ 58946 ];
}
