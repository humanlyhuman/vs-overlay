{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  buildPythonPackage,
  rustPlatform,
  maturin,
  hatchling,
  hatch-cython,
  versioningit,
  cython,
  setuptools,
  vapoursynthPlugins,
  rich,
  pyside6,
  cargo,
  rustc,
  numpy,
  platformdirs,
  pydantic,
  scipy,
  pygments,
  pluggy,
  imagemagick,
  vapoursynth,
}: let
  monorepo = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-view";
    rev = "vsview/v0.5.0";
    hash = "sha256-PtNjMA+/5MI2lZxjgqRc2PQZv2KcaI+AfFdb45+tl24=";
    fetchSubmodules = true;
  };

  vspackrgb = buildPythonPackage rec {
    pname = "vspackrgb";
    version = "1.2.1";

    src = monorepo;
    sourceRoot = "source/src/vspackrgb";
    pyproject = true;

    build-system = [
      hatchling
      hatch-cython
      setuptools
      cython
    ];

    buildInputs = [ vapoursynth ];
    dependencies = [ vapoursynth ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
        --replace-fail '"hatch-cython @ git+https://github.com/Varde-s-Forks/hatch-cython.git",' '"hatch-cython",' \
        --replace-fail '"versioningit",' "" \
        --replace-fail '"vapoursynth",' "" \
        --replace-fail '"vapoursynth"' ""
    '';

    doCheck = false;
  };

  vsview-cli = buildPythonPackage rec {
    pname = "vsview-cli";
    version = "1.0.0";
    pyproject = true;

    src = monorepo;
    sourceRoot = "source/src/vsview-cli";

    nativeBuildInputs = [
      rustPlatform.maturinBuildHook
      rustPlatform.cargoSetupHook
    ];

    cargoRoot = "rust";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      sourceRoot = "source/src/vsview-cli/rust";
      hash = "sha256-W+Us81dE/AMFzBO0yQKcC7QKZXqQpxN3JAHWAKLb6Kw=";
    };

    doCheck = false;
  };
defaultVsPlugins = with vapoursynthPlugins; [
  lsmas
  ffms2
  fmtconv
  resize2
  awarp
];

vsRuntime = vapoursynth.withPlugins defaultVsPlugins;

in
buildPythonApplication rec {
  pname = "vsview";
  version = "0.5.0";
  src = monorepo;
  pyproject = true;

  build-system = [ hatchling versioningit ];

  dependencies = [
    vsRuntime

    vapoursynthPlugins.vsjetengine
    vapoursynthPlugins.jetpytools
    vapoursynthPlugins.vsjetpack

    vspackrgb
    vsview-cli

    pyside6
    pydantic
    platformdirs
    rich
    pygments
    pluggy
    numpy
    scipy
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "0.5.0"' \
      --replace-fail '"vapoursynth>=69",' "" \
      --replace-fail '"vsjetengine>=1.2.0",' "" \
      --replace-fail '"vspackrgb>=1.0.0",' "" \
      --replace-fail '"vsview-cli>=1.0.0",' "" \
      --replace-fail '"jetpytools>=2.2.7",' "" \
      --replace-fail '"platformdirs>=4.9.2",' "" \
      --replace-fail '"pyside6>=6.11.0",' "" \
      --replace-fail '"pydantic>=2.0.0",' "" \
      --replace-fail '"rich>=14.0.0",' "" \
      --replace-fail '"pygments>=2.20.0",' "" \
      --replace-fail '"pluggy>=1.6.0",' ""
  '';

  nativeCheckInputs = [ imagemagick ];
  doCheck = false;

  meta = with lib; {
    description = "The next-generation VapourSynth previewer";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-view";
    mainProgram = "vsview";
    platforms = platforms.linux;
  };
}