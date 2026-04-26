{ lib, buildPythonPackage, fetchFromGitHub, vapoursynthPlugins, python, vapoursynth }:
let
  plugins_native = with vapoursynthPlugins; [
    addgrain
    adjust
    bm3d
    cas
    ctmf
    dctfilter
    deblock
    dfttest
    eedi2
    eedi3m
    fft3dfilter
    fluxsmooth
    fmtconv
    hqdn3d
    knlmeanscl
    miscfilters-obsolete
    mvsfunc
    mvtools
    nnedi3
    nnedi3cl
    sangnom
    ttempsmooth
    znedi3
  ];
  plugins_python = with vapoursynthPlugins; [
    vsutil
  ];
in
buildPythonPackage rec {
  pname = "havsfunc";
  version = "r33";
  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r33";
    sha256 = "sha256-BafAq61ObDw4h8sLzm0VJdV3ekp0vIHjxk4zQPEUjIY=";
  };

  format = "other";

  propagatedBuildInputs = plugins_native ++ plugins_python;

  installPhase = ''
    runHook preInstall

    install -D havsfunc.py $out/${python.sitePackages}/havsfunc.py

    runHook postInstall
  '';

  checkInputs = [ (vapoursynth.withPlugins plugins_native ) ];
  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';
  pythonImportsCheck = [ "havsfunc" ];

  meta = with lib; {
    description = "Holy’s ported AviSynth functions for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/havsfunc";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
