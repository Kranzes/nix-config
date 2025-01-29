{ pkgs, ... }:
{
  programs.firefox = {
    package = pkgs.firefox.overrideAttrs (old: {
      makeWrapperArgs = old.makeWrapperArgs ++ [
        "--set"
        "MOZ_USE_XINPUT2"
        "1"
        "--set"
        "MOZ_WEBRENDER"
        "1"
        # Required for hardware video decoding.
        # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
        "--set"
        "MOZ_DISABLE_RDD_SANDBOX"
        "1"
        "--set"
        "LIBVA_DRIVER_NAME"
        "nvidia"
        "--set"
        "NVD_BACKEND"
        "direct"
      ];
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
