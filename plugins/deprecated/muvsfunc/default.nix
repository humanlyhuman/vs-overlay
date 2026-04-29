{
  lib,
  vapoursynthPlugins,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  python,
  vapoursynth,
}: let
  propagatedBinaryPlugins = with vapoursynthPlugins; [
    descale
    histogram
    median
    tcanny
  ];
in
  buildPythonPackage rec {
    pname = "muvsfunc";
    version = "unstable-2020-09-09";

    src = fetchFromGitHub {
      owner = "WolframRhodium";
      repo = pname;
      rev = "5b5f245f090b6a4de7910ae6168b3ef0e28d2c70";
      hash = "sha256-ILEO2RWZvX2VyFdElVKYjZn/XkXETbfXAbf8rWlt2Ps=";
    };

    propagatedBuildInputs =
      [
        matplotlib
      ]
      ++ (with vapoursynthPlugins; [
        havsfunc
        mt_lutspa
        mvsfunc
        nnedi3_resample
      ])
      ++ propagatedBinaryPlugins;

    format = "other";

    installPhase = ''
      install -D muvsfunc.py $out/${python.sitePackages}/muvsfunc.py
    '';

    checkInputs = [(vapoursynth.withPlugins propagatedBinaryPlugins)];
    checkPhase = ''
      PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
    '';
    pythonImportsCheck = ["muvsfunc"];

    meta = with lib; {
      description = "Muonium’s VapourSynth functions";
      homepage = "https://github.com/WolframRhodium/muvsfunc";
      license = licenses.unfree; # no license
      maintainers = with maintainers; [sbruder];
      platforms = platforms.linux;
    };
  }
