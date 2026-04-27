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
    owner = "humanlyhuman";
    repo = "VapourSynth-insaneAA";
    rev = "master";
    hash = "sha256-k/+PiVDC0pAgPQtHtToRBfX+k0LYNwj0BCm8CdpjlPY=";
  };
  propagatedBuildInputs = with vapoursynthPlugins; [
    eedi3m
    nnedi3
    descale
    finedehalo
  ];
  format = "other";

  installPhase = ''
    runHook preInstall
    install -D insaneAA.py $out/${python.sitePackages}/insaneAA.py
    runHook postInstall
  '';

  checkInputs = [vapoursynth];
  checkPhase = ''
    runHook preCheck
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
    runHook postCheck
  '';
  pythonImportsCheck = ["insaneAA"];
  meta = with lib; {
    description = "insaneAA anti-aliasing script for VapourSynth";
    homepage = "https://github.com/Beatrice-Raws/VapourSynth-insaneAA";
    license = licenses.unfree;
    platforms = platforms.x86 ++ platforms.x86_64;
  };
}
