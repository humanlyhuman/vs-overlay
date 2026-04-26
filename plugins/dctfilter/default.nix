{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fftwFloat,
  vapoursynth,
}:

stdenv.mkDerivation rec {
  pname = "VapourSynth-DCTFilter";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-Eif1WczZaJR4xQxqXFELVUJh2sr0ItyGN/uHlYOZcNI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    fftwFloat
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
        --replace "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "Renewed DCTFilter filter plugin for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DCTFilter";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
