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
  pname = "vapoursynth-eedi3";
  version = "9";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "r${version}";
    sha256 = "sha256-/3elqMGarp1+T7K0wOIEbePsa80UUhMEwnYUudNnGxg=";
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
      --replace-fail \
        "run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip()" \
        "'${lib.getDev vapoursynth}/include/vapoursynth'"
  '';

  meta = with lib; {
    description = "Renewed EEDI3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.x86 ++ platforms.x86_64;
  };
}
