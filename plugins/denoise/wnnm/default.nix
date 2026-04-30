{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
  hatchling,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "wnnm";
  version = "3";
  pyproject = true;
  build-system = ["hatchling"];
  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "VapourSynth-WNNM";
    rev = "v${version}";
    hash = "";
  };
  nativeBuildInputs = [ hatchling ];
  buildInputs = [ vapoursynth ];
  meta = with lib; {
    description = "Weighted Nuclear Norm Minimization Denoiser for VapourSynth.";
    homepage = "https://github.com/AmusementClub/VapourSynth-WNNM";
    license = licenses.mit;
  };
}