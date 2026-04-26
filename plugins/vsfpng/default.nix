{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "vsfpng";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Mikewando";
    repo = "vsfpng";
    rev = "${version}";
    sha256 = "sha256-+OYUAp6T+ZGSFixw7W/QsqXVlPYea83WV88EVsI11KM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "vapoursynth/include" "${vapoursynth}/include" \
      --replace "py.get_install_dir() / 'vapoursynth/plugins'" "'${placeholder "out"}/lib/vapoursynth'"
  '';

  libdir = "lib/vapoursynth";
  meta = with lib; {
    description = "fpng plugin for VapourSynth";
    homepage = "https://github.com/Mikewando/vsfpng";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
