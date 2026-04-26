{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:

stdenv.mkDerivation rec {
  pname = "VapourSynth-Deblock";
  version = "8";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-ipQfEZY5ZD+notSD1jJxyxoU3zpGBRhcOIuz808TDn4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ vapoursynth ];

  postPatch = ''
    substituteInPlace meson.build \
        --replace "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "A Deblock filter plugin for VapourSynth.";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
