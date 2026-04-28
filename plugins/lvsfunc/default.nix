{
  lib,
  vapoursynthPlugins,
  buildPythonPackage,
  fetchFromGitHub,
  rich,
  toolz,
  vapoursynth,
  setuptools,
  pythonOlder,
  numpy,
}: let
  propagatedBinaryPlugins = with vapoursynthPlugins; [
    d2vsource
    descale
    vs-jetpack
    numpy
    fmtconv
    knlmeanscl
    readmpls
    znedi3
  ];
in
  buildPythonPackage rec {
    pname = "lvsfunc";
    version = "0.9.0";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-x1EDBddLKsCXIbMy8+en2G6L6+yZKTQq8SSoOP7kAvU=";
    };

postPatch = ''
  substituteInPlace requirements.txt \
    --replace-fail "VapourSynth>=69" "" \
    --replace-fail "vsjetpack>=1.1.0" "" \
    --replace-fail "numpy~=2.1.1" ""
'';

    propagatedBuildInputs =
      [
        rich
        toolz
      ]
      ++ (with vapoursynthPlugins; [
        vsutil
      ]);

    checkInputs = [(vapoursynth.withPlugins propagatedBinaryPlugins)];
    pythonImportsCheck = ["lvsfunc"];

    meta = with lib; {
      description = "A collection of LightArrowsEXE’s VapourSynth functions and wrappers";
      homepage = "https://lvsfunc.readthedocs.io";
      license = licenses.mit; # no license
      maintainers = with maintainers; [sbruder];
      platforms = platforms.all;
      broken = pythonOlder "3.10";
    };
  }
