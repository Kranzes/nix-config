{ stdenv, fetchFromGitHub }:

let
  pack = "1";
  theme = "connect";
in

stdenv.mkDerivation rec {
  pname = "adi1090x-plymouth";
  version = "2021-07-12";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    sha256 = "VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
  };

  dontBuild = false;

  installPhase = ''
  mkdir -p $out/share/plymouth/themes
  cp -r $src/pack_${pack}/${theme} $out/share/plymouth/themes
  substituteInPlace $out/share/plymouth/themes/${theme}/${theme}.plymouth \
      --replace '/usr' $out
  '';
}

