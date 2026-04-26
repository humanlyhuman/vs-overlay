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
    sha256 = "sha256-/3elqMGarp1+T7K0wOIEbePsa80UUhMEwnYUudNnGxg=";
  };

  build-system = [
    python3Packages.meson-python
  ];

  buildInputs = [
    vapoursynth
  ];

  postPatch = ''
      sed -i "s|run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip()|'${vapoursynth}/include/vapoursynth'|" meson.build
  
      substituteInPlace pyproject.toml \
        --replace-fail '"VapourSynth>=74"' ""
    '';

  dependencies = [
    python3Packages.vapoursynth
  ];

  meta = with lib; {
    description = "Renewed EEDI3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.x86 ++ platforms.x86_64;
  };
}
