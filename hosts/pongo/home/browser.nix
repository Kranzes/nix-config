{ pkgs, lib, ... }:
let
  env = {
    MOZ_WEBRENDER = 1;
    MOZ_USE_XINPUT2 = 1;
    # Required for hardware video decoding.
    # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
    MOZ_DISABLE_RDD_SANDBOX = 1;
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
  envStr = lib.concatStringsSep " " (lib.mapAttrsToList (n: v: "${n}=${lib.escapeShellArg v}") env);
in
{
  programs.firefox = {
    package = pkgs.firefox.overrideAttrs (old: {
      buildCommand =
        old.buildCommand
        + ''
          substituteInPlace $out/bin/firefox \
            --replace "exec -a" ${lib.escapeShellArg envStr}" exec -a"
        '';
    });
    profiles."kranzes".settings = {
      # Hardware acceleration
      # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
      "gfx.webrender.all" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "media.av1.enabled" = false; # GTX 950 moment
      "gfx.x11-egl.force-enabled" = true;
      "widget.dmabuf.force-enabled" = true;
    };
  };
}
