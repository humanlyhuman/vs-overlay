{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  versioningit,
}:
buildPythonPackage rec {
  pname = "jetpytools";
  version = "2.2.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "jetpytools";
    rev = "v${version}";
    sha256 = "sha256-adqVxwbnxElfSkt/1nDX360/HshX5jLu2V7r0AnT0xo=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  doCheck = false;
  pythonImportsCheck = [ ];

  meta = with lib; {
    description = "Python tools and utilities used by JET packages";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/jetpytools";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
