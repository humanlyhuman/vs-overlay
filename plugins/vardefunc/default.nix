{
  lib,
  vapoursynthPlugins,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}: let
  propagatedBinaryPlugins = with vapoursynthPlugins; [
    neo-f3kdb
    ffms2
    scxvid
  ];
in
  buildPythonPackage rec {
    pname = "vardefunc";
    version = "0.13.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Ichunjo";
      repo = pname;
      rev = version;
      sha256 = "sha256-Tl2ElO6F3JIIvRLimpRlMXC4/Aju0wNbbXhYxzykWVU=";
    };

    build-system = [
      setuptools
      wheel
    ];

    propagatedBuildInputs =
      (with vapoursynthPlugins; [
        lvsfunc
        vsutil
      ])
      ++ propagatedBinaryPlugins;

    postPatch = ''
      substituteInPlace requirements.txt \
        --replace-fail "VapourSynth>=69" ""
    '';

    pythonImportsCheck = ["vardefunc"];

    meta = with lib; {
      description = "Some functions that may be useful";
      homepage = "https://github.com/Ichunjo/vardefunc";
      license = licenses.unfree;
      maintainers = with maintainers; [sbruder];
      platforms = platforms.all;
    };
  }
