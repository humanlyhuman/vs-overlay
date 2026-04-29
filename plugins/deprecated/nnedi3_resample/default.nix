{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  vapoursynthPlugins,
  python,
  vapoursynth,
}:
buildPythonPackage rec {
  pname = "nnedi3_resample";
  version = "unstable-2017-05-10";

  src = fetchFromGitHub {
    owner = "mawen1250";
    repo = "VapourSynth-script";
    rev = "0983895c8a0fe65d8b342e1875294d2681c75e84";
    hash = "sha256-zcKPokgBFGZXMRsAMwWsA2InuA+8UCHscVJuKmIP37A=";
  };

  propagatedBuildInputs = with vapoursynthPlugins; [
    fmtconv
    mvsfunc
    nnedi3
  ];

  format = "other";

  installPhase = ''
    install -D nnedi3_resample.py $out/${python.sitePackages}/nnedi3_resample.py
  '';

  checkInputs = [(vapoursynth.withPlugins propagatedBuildInputs)];
  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';
  pythonImportsCheck = ["nnedi3_resample"];

  meta = with lib; {
    description = "A vapoursynth plugin for resampling with nnedi3";
    homepage = "https://github.com/mawen1250/VapourSynth-script";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
