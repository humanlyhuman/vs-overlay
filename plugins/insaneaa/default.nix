{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  vapoursynthPlugins,
  python,
  vapoursynth,
}:
buildPythonPackage {
  pname = "insaneaa";
  version = "unstable-2021-10-22";
  src = fetchFromGitHub {
    owner = "Beatrice-Raws";
    repo = "VapourSynth-insaneAA";
    rev = "9a7e646804997be888bf629be9df86e32ae967ce";
    sha256 = "sha256-BafAq61ObDw4h8sLzm0VJdV3ekp0vIHjxk4zQPEUjIY=";
  };
  propagatedBuildInputs = with vapoursynthPlugins; [
    eedi3m
    nnedi3
    descale
  ];
  format = "other";
  installPhase = ''
    runHook preInstall
    install -D insaneAA.py $out/${python.sitePackages}/insaneAA.py
    runHook postInstall
  '';
  checkInputs = [ vapoursynth ];
  checkPhase = ''
    runHook preCheck
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
    runHook postCheck
  '';
  pythonImportsCheck = [ "insaneAA" ];
  meta = with lib; {
    description = "insaneAA anti-aliasing script for VapourSynth";
    homepage = "https://github.com/Beatrice-Raws/VapourSynth-insaneAA";
    license = licenses.unfree;
    platforms = with platforms; x86 ++ x86_64;
  };
}
