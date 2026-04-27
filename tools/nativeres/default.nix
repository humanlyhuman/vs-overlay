{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  python3,
  hatchling,
  versioningit,
  typer,
  rich,
  pyside6,
  numpy,
  scipy,
  vapoursynth,
  vapoursynthPlugins,
  imagemagick,
}: let
  vapoursynth-with-plugins = vapoursynth.withPlugins (with vapoursynthPlugins; [
    ffms2
    descale
  ]);
in
  buildPythonApplication rec {
    pname = "nativeres";
    version = "0.2.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = "nativeres";
      rev = "nativeres/v${version}";
      hash = lib.fakeHash;
    };

    build-system = [
      hatchling
      versioningit
    ];

    propagatedBuildInputs = [
      vapoursynthPlugins.jetpytools
      vapoursynthPlugins.vs-jet-engine
      vapoursynthPlugins.vs-jetpack
      typer
      rich
      pyside6
      numpy
      scipy
      vapoursynth-with-plugins
    ];

    nativeCheckInputs = [
      imagemagick
    ];

    doCheck = false;

    pythonImportsCheck = [
      "nativeres"
    ];

    meta = with lib; {
      description = "Descale analysis tools for VapourSynth";
      homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/nativeres";
      license = licenses.mit;
      mainProgram = "nativeres";
      platforms = platforms.all;
    };
  }
