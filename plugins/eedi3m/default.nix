{
  lib,
  python3Packages,
  fetchFromGitHub,
  vapoursynth,
}:
python3Packages.buildPythonPackage {
  pname = "vapoursynth-eedi3";
  version = "9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "r9";
    hash = "sha256-/3elqMGarp1+T7K0wOIEbePsa80UUhMEwnYUudNnGxg=";
  };

  build-system = [
    python3Packages.meson-python
  ];

  buildInputs = [
    vapoursynth
  ];

  mesonFlags = [ "-Db_lto=false" ];
  postPatch = ''
    sed -i "/^incdir = include_directories(/,/^)/c\incdir = include_directories('${vapoursynth}/include/vapoursynth')" meson.build
    substituteInPlace pyproject.toml \
      --replace-fail '"VapourSynth>=74"' ""
  '';

  installPhase = ''
    mkdir -p $out/lib/vapoursynth
    find . -name "*.so" -exec cp {} $out/lib/vapoursynth/ \;
  '';

  dependencies = [
    python3Packages.vapoursynth
  ];

  meta = with lib; {
    description = "Renewed EEDI3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2Plus;
    platforms = platforms.x86 ++ platforms.x86_64;
  };
}
