{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  buildPythonPackage,
  rustPlatform,
  maturin,
  hatchling,
  versioningit,
  cython,
  setuptools,
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
  vapoursynthPlugins,
}: let
  monorepo = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-view";
    rev = "vsview/v0.5.0";
    hash = "sha256-PtNjMA+/5MI2lZxjgqRc2PQZv2KcaI+AfFdb45+tl24=";
    fetchSubmodules = true;
  };

  vapoursynth' = vapoursynth.withPlugins (with vapoursynthPlugins; [
    ffms2
    lsmashsource
    descale
    akarin
    resize2
    bestsource
  ]);

  mkVsPlugin = p: p.override {vapoursynth = vapoursynth';};

  vspackrgb = buildPythonPackage rec {
    pname = "vspackrgb";
    version = "1.2.1";
    src = monorepo;
    sourceRoot = "source/src/vspackrgb";
    pyproject = true;

    build-system = [setuptools cython];
    dependencies = [vapoursynth' numpy];

    postPatch = ''
      cat > pyproject.toml << EOF
      [build-system]
      requires = ["setuptools", "cython>=3.0.0"]
      build-backend = "setuptools.build_meta"

      [project]
      name = "vspackrgb"
      version = "${version}"
      requires-python = ">=3.12"
      dependencies = []

      [tool.setuptools.packages.find]
      where = ["src"]

      [tool.setuptools.package-data]
      vspackrgb = ["py.typed", "*.pyi"]
      EOF

      cython -3 \
        -X boundscheck=False \
        -X wraparound=False \
        -X nonecheck=False \
        -X cdivision=True \
        src/vspackrgb/cython.pyx

      cat > setup.py << EOF
      from setuptools import setup, Extension
      setup(
          ext_modules=[
              Extension(
                  "vspackrgb.cython",
                  sources=["src/vspackrgb/cython.c"],
                  extra_compile_args=["-O3"],
                  define_macros=[("Py_LIMITED_API", "0x030C0000")],
              )
          ]
      )
      EOF
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
in
  buildPythonApplication {
    pname = "vsview";
    version = "0.5.0";
    src = monorepo;
    pyproject = true;

    build-system = [hatchling versioningit];

    dependencies = [
      vapoursynth'
      (mkVsPlugin vapoursynthPlugins.vsjetengine)
      (mkVsPlugin vapoursynthPlugins.vsjetpack)
      (mkVsPlugin vapoursynthPlugins.jetpytools)
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

    nativeCheckInputs = [imagemagick];
    doCheck = false;

    meta = {
      description = "The next-generation VapourSynth previewer";
      homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-view";
      mainProgram = "vsview";
      platforms = lib.platforms.linux;
    };
  }
