{
  lib,
  vapoursynthPlugins,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  setuptools,
  wheel,
  versioningit,
  pythonRelaxDepsHook,
  vapoursynth,
  numpy,
  mypy,
  ruff,
  ...
}: let
  propagatedBinaryPlugins = with vapoursynthPlugins; [
    adaptivegrain
    bilateral
    eedi3m
    neo_f3kdb
    ffms2
    nnedi3cl
    scxvid
    wwxd
  ];

  pytimeconv = buildPythonPackage rec {
    pname = "pytimeconv";
    version = "0.0.2";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "Ichunjo";
      repo = pname;
      rev = version;
      hash = "sha256-qb3EvstohPBBZYkJDVh+TpK2lNVpjK+wGQTMuZoxl9w=";
    };

    nativeBuildInputs = [
      setuptools
      wheel
    ];

    pythonImportsCheck = ["pytimeconv"];

    meta = {
      description = "Basic time conversion module";
      homepage = "https://github.com/Ichunjo/pytimeconv";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };
in
  buildPythonPackage rec {
    pname = "vardefunc";
    version = "0.13.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Ichunjo";
      repo = pname;
      rev = version;
      hash = "sha256-Tl2ElO6F3JIIvRLimpRlMXC4/Aju0wNbbXhYxzykWVU=";
    };

    build-system = [
      hatchling
      versioningit
      pythonRelaxDepsHook
    ];

    pythonRelaxDeps = [
      "pytimeconv"
      "vapoursynth"
      "vsjetpack"
    ];
    postPatch = ''
    substituteInPlace vardefunc/vsjet_proxy.py \
      --replace "FieldBasedT" "FieldBased"
  '';

    dontCheckRuntimeDeps = true;

    dependencies = with vapoursynthPlugins; [
      numpy
      pytimeconv
      vapoursynth
      vsjetpack
      fvsfunc
      havsfunc
      vsutil
    ];

    optional-dependencies = {
      comp = with vapoursynthPlugins; [lvsfunc];
    };

    nativeCheckInputs = [
      mypy
      ruff
    ];

    propagatedBuildInputs = propagatedBinaryPlugins;

    checkInputs = [
      (vapoursynth.withPlugins propagatedBinaryPlugins)
    ];

    doCheck = false;
    pythonImportsCheck = [];

    meta = {
      description = "Vardë's Vapoursynth functions";
      homepage = "https://github.com/Ichunjo/vardefunc";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  }
