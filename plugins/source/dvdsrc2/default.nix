{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  rustPlatform,
  a52dec,
  libmpeg2,
  libdvdread,
  rustc,
  pkg-config,
  vapoursynth,
  ninja,
  meson,
  packaging,
}:
buildPythonPackage rec {
  pname = "dvdsrc2";
  version = "49e7e8b61800e51bb98be1fdc31c00d5b65844ce";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsaowji";
    repo = "dvdsrc2";
    rev = "49e7e8b61800e51bb98be1fdc31c00d5b65844ce";
    hash = "sha256-EJzoTQfzC95GK8BuV28YjKd6XoVqGonSLGoOKhYADps=";
  };

  build-system = [hatchling packaging];

  nativeBuildInputs = [
    pkg-config
    hatchling
    ninja
    meson
  ];
  buildInputs = [
    vapoursynth
    rustc
    a52dec
    libmpeg2
    libdvdread
  ];

  dependencies = [vapoursynth];
  postPatch = ''
    sed -i '/vapoursynth>=74/d' pyproject.toml
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
