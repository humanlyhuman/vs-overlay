{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage {
  pname = "vapoursynth-eedi3";
  version = "9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "r9";
    sha256 = "sha256-/3elqMGarp1+T7K0wOIEbePsa80UUhMEwnYUudNnGxg=";
  };

  build-system = [
    python3Packages.meson-python
  ];

  postPatch = ''
    sed -i '/run_command/,/\.stdout()\.strip()/c\' meson.build
  
    substituteInPlace pyproject.toml \
      --replace-fail '"VapourSynth>=74"' ""
  '';

  dependencies = [
    python3Packages.vapoursynth
  ];

  dontUseMesonConfigure = true;

  meta = with lib; {
    description = "Renewed EEDI3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.x86 ++ platforms.x86_64;
  };
}
