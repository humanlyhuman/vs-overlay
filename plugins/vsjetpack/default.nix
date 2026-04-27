{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  vapoursynth,
  hatchling,
  versioningit,
  jetpytools,
  numpy,
}:
buildPythonPackage rec {
  pname = "vsjetpack";
  version = "1.4.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-jetpack";
    rev = "v${version}";
    hash = "sha256-oZi7LerJiLC12qlS3hrwemLtTij23F77a9dVU4MBur4=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    vapoursynth
    jetpytools
    numpy
  ];

  env.VERSIONINGIT_OVERRIDE_VCS = version;

  doCheck = false;
  dontCheckRuntimeDeps = true;
  pythonImportsCheck = [ ];

  meta = with lib; {
    description = "Full suite of filters, wrappers, and helper functions for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-jetpack";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
