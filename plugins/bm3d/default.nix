{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  fftwSinglePrec,
}:
stdenv.mkDerivation rec {
  pname = "vapoursynth-bm3d";
  version = "10";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-BM3D";
    rev = "r${version}";
    sha256 = "sha256-FMal1VlijqQbuY+jJ38tZqhlg0OCMJHhVihV+DLlZFs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    fftwSinglePrec
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        "run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip()" \
        "dependency('vapoursynth').get_variable(pkgconfig: 'includedir')"
  '';

  meta = with lib; {
    description = "BM3D denoising filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
