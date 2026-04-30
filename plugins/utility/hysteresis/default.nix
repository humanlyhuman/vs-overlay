{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  packaging,
  a52dec,
  libmpeg2,
  libdvdread,
  rustc,
  cargo,
  pkg-config,
  vapoursynth,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "hysteresis";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-hysteresis";
    rev = "v${version}";
    hash = "sha256-JYgpJD+972vpWMai+SC4RxjbvgX/QkGabS7dwECFeDk=";
  };
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + "/Cargo.lock";
    outputHashes = {
      "vapoursynth4-rs-0.4.0" = "sha256-grhrX68DjmuMmUJBSodCK1kBZo8TCmyLFe55qfEkX5I=";
    };
  };

  build-system = [hatchling packaging];

  nativeBuildInputs = [
    pkg-config
    hatchling
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];
  buildInputs = [
    vapoursynth
    packaging
    rustc
  ];
  pythonImportsCheck = [];
  preBuild = ''
    export HOME=$TMPDIR
    export CARGO_HOME=$TMPDIR/cargo
  '';
  cargoRoot = ".";
  dependencies = [vapoursynth];
  postPatch = ''
    sed -i '/vapoursynth>=74/d' pyproject.toml
    sed -i 's/packaging==26.0/packaging/g' pyproject.toml

    substituteInPlace hatch_build.py \
      --replace-fail '["cargo", "build", "--release"]' \
                '["cargo", "build", "--release", "--offline", "--frozen"]'

  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth

    plugin=$(find $out/lib -name "*.so" | grep hysteresis | head -n1)

    ln -s "$plugin" $out/lib/vapoursynth/libhysteresis.so
  '';

  meta = with lib; {
    description = "Hysteresis filter for VapourSynth";
    homepage = "https://github.com/sgt0/vapoursynth-hysteresis";
    license = licenses.wtfpl;
    platforms = platforms.linux;
    maintainers = with maintainers; [humanlyhuman];
  };
}
