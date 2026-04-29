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
  vapoursynth-with-plugins = vapoursynth.withPlugins [
    vapoursynthPlugins.ffms2
    vapoursynthPlugins.lsmashsource
    vapoursynthPlugins.descale
    vapoursynthPlugins.akarin
    vapoursynthPlugins.resize2
    vapoursynthPlugins.bestsource
  ];

  jetpytools = vapoursynthPlugins.jetpytools.override {
    vapoursynth = vapoursynth-with-plugins;
  };

  resize2 = vapoursynthPlugins.resize2.override {
    vapoursynth = vapoursynth-with-plugins;
  };

  akarin = vapoursynthPlugins.akarin.override {
    vapoursynth = vapoursynth-with-plugins;
  };

  vsjetengine = vapoursynthPlugins.vsjetengine.override {
    vapoursynth = vapoursynth-with-plugins;
  };

  vsjetpack = vapoursynthPlugins.vsjetpack.override {
    vapoursynth = vapoursynth-with-plugins;
  };
in
  buildPythonApplication rec {
    pname = "vsview";
    version = "0.5.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = "vs-view";
      rev = "vsview/v${version}";
      hash = "sha256-3+j/YKmiAcESbnxJS+Cp6EAZix37OTMT0g5HG/TEsTM=";
      fetchSubmodules = true;
    };

    build-system = [
      hatchling
      versioningit
    ];

    dependencies = [
      typer
      rich
      pyside6
      numpy
      scipy

      vapoursynth-with-plugins

      jetpytools
      vsjetengine
      vsjetpack
    ];

    nativeCheckInputs = [
      imagemagick
    ];

    doCheck = false;

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
        --replace-fail '"vsjetengine>=1.2.0",' "" \
        --replace-fail '"vsjetpack>=1.3.0",' ""
    '';

    meta = with lib; {
      description = "A VapourSynth script viewer and editor";
      homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-view";
      license = licenses.mit;
      mainProgram = "vsview";
      platforms = platforms.linux;
    };
  }
