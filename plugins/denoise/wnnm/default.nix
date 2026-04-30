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
    hash = "sha256-fPtHaDrG1Ku1/Uv0Bh3hUfqbOEyfnhFVFblspRhHqlE=";
  };
  nativeBuildInputs = [ hatchling ];
  buildInputs = [ vapoursynth ];
  meta = with lib; {
    description = "Weighted Nuclear Norm Minimization Denoiser for VapourSynth.";
    homepage = "https://github.com/AmusementClub/VapourSynth-WNNM";
    license = licenses.mit;
  };
}