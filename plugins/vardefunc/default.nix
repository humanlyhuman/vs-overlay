{
  lib,
  vapoursynthPlugins,
  buildPythonPackage,
  fetchFromGitHub,
  vapoursynth,
  setuptools,
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
in
  buildPythonPackage rec {
    pname = "vardefunc";
    version = "0.13.0";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchFromGitHub {
      owner = "Ichunjo";
      repo = pname;
      rev = "v${version}";
      sha256 = "0bkchcshxmfcfbqapw367y3cfj1rdz78a55fkcvznvy61fhqvzl7";
    };

    propagatedBuildInputs =
      (with vapoursynthPlugins; [
        fvsfunc
        havsfunc
        lvsfunc
        vsutil
      ])
      ++ propagatedBinaryPlugins;

    postPatch = ''
      substituteInPlace meson.build \
        --replace-fail \
          "run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip()" \
          "dependency('vapoursynth').get_variable(pkgconfig: 'includedir')" \
        --replace-fail \
          "py.get_install_dir() / 'vapoursynth/plugins'" \
          "get_option('libdir') / 'vapoursynth'"
      substituteInPlace requirements.txt \
          --replace-fail "VapourSynth>=69" ""
    '';

    checkInputs = [(vapoursynth.withPlugins propagatedBinaryPlugins)];
    pythonImportsCheck = ["vardefunc"];

    meta = with lib; {
      description = "Some functions that may be useful";
      homepage = "https://github.com/Ichunjo/vardefunc";
      license = licenses.unfree; # no license
      maintainers = with maintainers; [sbruder];
      platforms = platforms.all;
    };
  }
