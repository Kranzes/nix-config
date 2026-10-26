{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  libdbusmenu,
  udevCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "btd700-control";
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "justin-eckenweber";
    repo = "btd700linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mqihJltDAK5D+SkCBsX3rvlOp10MYj2x248w5C3se44=";
  };

  # Autostart entries otherwise run `python -m btd700`, which lacks the wrapper's environment
  postPatch = ''
    substituteInPlace btd700/integration.py \
      --replace-fail "else sys.executable)" "else 'btd700-control')" \
      --replace-fail "else ' -m btd700'" "else '''" \
      --replace-fail "else 'audio-headphones')" "else 'btd700-control')"
  '';

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libdbusmenu
  ];

  dependencies = [ python3Packages.pygobject3 ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    install -Dm644 packaging/70-btd700-control.rules -t $out/lib/udev/rules.d
    install -Dm644 packaging/appimage/btd700-control.desktop -t $out/share/applications
    install -Dm644 packaging/btd700-control.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Asserts the unpatched `python -m btd700` launcher
  disabledTests = [ "test_installed_package_launcher_uses_python_module" ];

  nativeInstallCheckInputs = [ udevCheckHook ];

  pythonImportsCheck = [ "btd700" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial control app and tray menu for the Sennheiser BTD 700 Bluetooth dongle";
    homepage = "https://github.com/justin-eckenweber/btd700linux";
    changelog = "https://github.com/justin-eckenweber/btd700linux/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "btd700-control";
    platforms = lib.platforms.linux;
  };
})
