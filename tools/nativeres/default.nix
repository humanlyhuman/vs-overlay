{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  hatchling,
  versioningit,
  typer,
  rich,
  pyside6,
  numpy,
  scipy,
  vapoursynth,
  vapoursynthPlugins,
  vapoursynth-bestsource,
  imagemagick,
}: let
  vapoursynth-with-plugins = vapoursynth.withPlugins (
    with vapoursynthPlugins; [
      ffms2
      descale
      vapoursynth-bestsource
    ]
  );
in
  buildPythonApplication rec {
    pname = "nativeres";
    version = "0.2.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = "nativeres";
      rev = "vsview-nativeres/v${version}";
      hash = "sha256-3+j/YKmiAcESbnxJS+Cp6EAZix37OTMT0g5HG/TEsTM=";
    };

    build-system = [
      hatchling
      versioningit
    ];

    buildInputs = [vapoursynth-with-plugins];

    dependencies = [
      typer
      rich
      pyside6
      numpy
      scipy
      vapoursynthPlugins.jetpytools
      vapoursynthPlugins.vs-jet-engine
      vapoursynthPlugins.vs-jetpack
    ];

    nativeCheckInputs = [
      imagemagick
    ];

    doCheck = false;

    pythonImportsCheck = [
      "nativeres"
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
        --replace-fail '"vsjetengine>=1.2.0",' "" \
        --replace-fail '"vsjetpack>=1.3.0",' ""
    '';
    postFixup = ''
      wrapProgram $out/bin/nativeres \
        --set VAPOURSYNTH_PLUGIN_PATH ${vapoursynth-with-plugins}/lib/vapoursynth
    '';
    meta = with lib; {
      description = "Descale analysis tools for VapourSynth";
      homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/nativeres";
      license = licenses.mit;
      mainProgram = "nativeres";
      platforms = platforms.all;
    };
  }
