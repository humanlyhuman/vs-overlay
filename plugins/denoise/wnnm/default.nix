{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  vapoursynth,
  mkl,
}:
stdenv.mkDerivation rec {
  pname = "vapoursynth-wnnm";
  version = "3";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "VapourSynth-WNNM";
    rev = "v${version}";
    hash = "sha256-fPtHaDrG1Ku1/Uv0Bh3hUfqbOEyfnhFVFblspRhHqlE=";
  };
  
  patches = [ ./wnnm-mkl-int.patch ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    mkl
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBLA_VENDOR=Intel10_64lp"
  ];

  meta = with lib; {
    description = "Weighted Nuclear Norm Minimization denoiser for VapourSynth";
    homepage = "https://github.com/AmusementClub/VapourSynth-WNNM";
    license = licenses.mit;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
