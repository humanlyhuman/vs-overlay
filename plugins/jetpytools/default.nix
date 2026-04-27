{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  versioningit,
}:
buildPythonPackage rec {
  pname = "jetpytools";
  version = "2.2.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "jetpytools";
    rev = "v${version}";
    hash = "sha256-LDzOLkL/KKSOBT+FU9sdg0pZGVDMBzioN4C645GQvRI=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  doCheck = false;
  dontCheckRuntimeDeps = true;
  pythonImportsCheck = [ ];

  meta = with lib; {
    description = "Python tools and utilities used by JET packages";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/jetpytools";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
