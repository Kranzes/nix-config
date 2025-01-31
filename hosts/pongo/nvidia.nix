{ pkgs, lib, ... }:

{
  services.xserver = {
    videoDrivers = lib.mkForce [ "nvidia" ];
    deviceSection = ''
      Option "Coolbits" "28"
    '';
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware = {
    graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
    nvidia.open = false; # Older GPUs are not supported in the open drivers.
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    GBM_BACKEND = "nvidia-drm";
  };
}

