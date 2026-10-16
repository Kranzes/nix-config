{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  hidapi,
  wireplumber,
  udevCheckHook,
}:

stdenv.mkDerivation {
  pname = "btd700ctl";
  version = "0-unstable-2026-07-19";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "sobalap";
    repo = "btd700ctl";
    rev = "747f3d6bcac91bdb36872038225e06eebc93f07a";
    hash = "sha256-qi/bWpGxeBbJeWLGdAnMzUFLNRvTTmUrBedSK4LkSF4=";
  };

  postPatch = ''
    substituteInPlace daemon/btd700d.service \
      --replace-fail /usr/local/bin/btd700d $out/bin/btd700d
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [ hidapi ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    echo 'SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3542", ATTRS{idProduct}=="3001", ENV{ID_USB_INTERFACE_NUM}=="00", TAG+="uaccess", TAG+="systemd", ENV{SYSTEMD_ALIAS}+="/dev/btd700", ENV{SYSTEMD_USER_WANTS}+="btd700d.service"' \
      > $out/lib/udev/rules.d/70-btd700.rules

    wrapProgram $out/bin/btd700d \
      --prefix PATH : ${lib.makeBinPath [ wireplumber ]}
  '';

  nativeInstallCheckInputs = [ udevCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Unofficial linux driver for the Sennheiser BTD 700 dongle";
    homepage = "https://github.com/sobalap/btd700ctl";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "btd700d";
    platforms = lib.platforms.linux;
  };
}
