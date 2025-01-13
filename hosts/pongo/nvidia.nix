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
    graphics.extraPackages = with pkgs; [
      vaapiVdpau
      nvidia-vaapi-driver
    ];

    nvidia = {
      open = false; # Older GPUs are not supported in the open drivers.
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };
}

