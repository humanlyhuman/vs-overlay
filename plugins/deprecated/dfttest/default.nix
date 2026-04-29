{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  fftwFloat,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "DFTTest";
  version = "7";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-2FQnKBaLJiBHnB0UEqTQEqI4L5Lt/gzsZ8g6euOnI6g=";
  };

  patches = [
    # handle fftw3f_threads dependency
    (fetchpatch {
      url = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest/commit/89034df3fa630cbc9d73fd3ed9bcc222468f3fee.diff";
      hash = "sha256-PgnM3YlKRYwNupuJRT9uoICyzpC++73wDC4sizEHoEI=";
    })
  ];

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [fftwFloat vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "A DFTTest filter plugin for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
