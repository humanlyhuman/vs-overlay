{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  versioningit,
  numpy,
  pytimeconv,
  vapoursynth,
  vsjetpack,
  lvsfunc,
}:

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
    hatchling
    versioningit
  ];

  dependencies = [
    numpy
    pytimeconv
    vapoursynth
    vsjetpack
  ];

  optional-dependencies = {
    comp = [ lvsfunc ];
  };

  pythonImportsCheck = [ "vardefunc" ];

  meta = with lib; {
    description = "Vardë's Vapoursynth functions";
    homepage = "https://github.com/Ichunjo/vardefunc";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
