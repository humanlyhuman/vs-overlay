{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  rustPlatform,
  a52dec,
  libmpeg2
  libdvdread,
  rustc,
}:
buildPythonPackage rec {
  pname = "dvdsrc2";
  version = "4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsaowji";
    repo = "dvdsrc2";
    rev = "R${version}";
    hash = "sha256-LmSANVwS6g5575Xsms9cwg+9SikNObZ/kgdh+sh/PAw=";
  };

  build-system = [hatchling];

  nativeBuildInputs = [
    pkg-config
    hatchling
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
