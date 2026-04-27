{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  vapoursynthPlugins,
  python,
  vapoursynth,
}:
buildPythonPackage {
  pname = "finedehalo";
  version = "unstable-2026-04-26";

  src = fetchFromGitHub {
    owner = "humanlyhuman";
    repo = "VapourSynth-scripts";
    rev = "18aecf2f46b3273059eb7e7c258b3b670e2cfbe2";
    hash = "sha256-s1Pc2CT/yapfLjTFxjOvRcdiXhjDji8rbI1rW37vo18=";
  };

  propagatedBuildInputs = with vapoursynthPlugins; [
    vapoursynth
    vsjetpack
    jetpytools
  ];

  format = "other";

  installPhase = ''
    runHook preInstall
    install -D finedehalo.py $out/${python.sitePackages}/finedehalo.py
    runHook postInstall
  '';

  pythonImportsCheck = ["finedehalo"];

  meta = with lib; {
    description = "FineDehalo";
    homepage = "https://github.com/humanlyhuman/VapourSynth-scripts";
    license = licenses.unfree;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.x86 ++ platforms.x86_64;
  };
}
