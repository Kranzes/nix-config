{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, makeWrapper, nodePackages, nss, openssl, xorg, electron_13, flac, libnotify }:

let
  electron = electron_13;
in

stdenv.mkDerivation rec {
  name = "freezer-${version}";
  pname = "freezer";
  version = "1.1.22";

  src = fetchurl {
    url = "https://files.freezer.life/0:/PC/${version}/${pname}_${version}_amd64.deb";
    sha256 = "sha256-qJk4HnHdn9UzpLd1p7RvPy8TpIsJLKSG1O8/s45oCZw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    nodePackages.asar
  ];

  buildInputs = [
    nss
    openssl
    xorg.libXtst
    flac
    libnotify
  ];

  unpackPhase = "${dpkg}/bin/dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/{lib,bin}
    mv opt/Freezer/* usr/share $out/
    mv $out/*.so $out/lib/
    mv $out/${pname} $out/bin/${pname}
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "/opt/Freezer" "$out/bin"
    asar e $out/resources/app.asar $out/resources/app.asar.unpacked   
    rm -rf opt usr $out/resources/app.asar
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/resources/app.asar.unpacked
  '';

  meta = with lib; {
    description = "Electron-based Deezer client";
    homepage = "https://freezer.life";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
