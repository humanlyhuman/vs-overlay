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
  pname = "dvdsrc2";
  version = "49e7e8b61800e51bb98be1fdc31c00d5b65844ce";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsaowji";
    repo = "dvdsrc2";
    rev = "49e7e8b61800e51bb98be1fdc31c00d5b65844ce";
    hash = "sha256-G+Du36fld2HNXV/QYCJ/h8bHvmZ1Ec1BhHojVt1D32g=";
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
    rustc
    a52dec
    libmpeg2
    libdvdread
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

    substituteInPlace hatch_build.py \
      --replace-fail '["cargo", "build", "--release"]' \
                '["cargo", "build", "--release", "--offline", "--frozen"]'

    substituteInPlace libdvdread-sys/build.rs \
      --replace-fail '"7.1.0"' '"7.0.1"'
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s \
      $out/lib/python*/site-packages/vapoursynth/plugins/dvdsrc2/.so \
      $out/lib/vapoursynth/libdvdsrc2.so
  '';

  meta = with lib; {
    description = "DVD source filter for VapourSynth";
    homepage = "https://github.com/jsaowji/dvdsrc2";
    license = licenses.wtfpl;
    platforms = platforms.linux;
    maintainers = with maintainers; [humanlyhuman];
  };
}
