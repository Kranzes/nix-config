{ stdenv, lib, utillinux

, environment
, dockEvent
, undockEvent
}:

stdenv.mkDerivation {
  name = "thinkpad-dock-acpi_event.sh";

  src = lib.cleanSource ./.;

  postPatch = ''
    substituteInPlace acpi_event.sh \
      --subst-var-by logger ${utillinux}/bin/logger \
      --subst-var-by environment "${environment}" \
      --subst-var-by dockEvent "${dockEvent}" \
      --subst-var-by undockEvent "${undockEvent}"
  '';

  installPhase = ''
    runHook preInstall
    cp acpi_event.sh $out
    runHook postInstall
  '';
}
