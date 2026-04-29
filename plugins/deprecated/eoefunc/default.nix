{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  vapoursynthPlugins,
  python,
  numpy,
  setuptools,
  vapoursynth,
}: 
  buildPythonPackage rec {
    pname = "EoEfunc";
    version = "d0ee0dcaab232106ed09ac2fa9c6b0e4d25ded2e";
    src = fetchFromGitHub {
      owner = "End-of-Eternity";
      repo = pname;
      rev = version;
      hash = "sha256-xWjjGkSaielIrUCe/CgrAXzkD90bPNO/i4RcFRfAXz0=";
    };
    pyproject = true;

    build-system = [
      setuptools
    ];

    buildInputs = [
      vapoursynth
      numpy
    ];

    postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"vapoursynth",' '""'
    '';

    checkPhase = ''
      PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
    '';
    pythonImportsCheck = ["EoEfunc"];

    meta = with lib; {
      description = "Holy’s ported AviSynth functions for VapourSynth";
      homepage = "https://github.com/End-of-Eternity/EoEfunc/tree/master/EoEfunc";
      license = licenses.unfree; # no license
      maintainers = with maintainers; [sbruder];
      platforms = platforms.linux;
    };

}
