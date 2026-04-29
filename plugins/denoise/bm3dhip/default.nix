{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rocmPackages,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "bm3dhip";
  version = "R2.16";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = "VapourSynth-BM3DCUDA";
    rev = version;
    hash = "sha256-spp+usDmiXW97PsPwZSmvsnMc7hWV9s4nZOZNwdg5Aw=";
  };

  nativeBuildInputs = [
    cmake
    rocmPackages.clr
    rocmPackages.llvm.clang
  ];

  buildInputs = [
    vapoursynth
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DVAPOURSYNTH_INCLUDE_DIRECTORY=${vapoursynth}/include/vapoursynth"
    "-DENABLE_CPU=OFF"
    "-DENABLE_CUDA=OFF"
    "-DENABLE_HIP=ON"

    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
    "-DCMAKE_HIP_COMPILER=hipcc"

    "-DCMAKE_SKIP_RPATH=ON"
  ];

  env = {
    HIP_PATH = "${rocmPackages.clr}";
    ROCM_PATH = "${rocmPackages.clr}";
  };

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    for f in $out/lib/*.so; do
      ln -s "$f" $out/lib/vapoursynth/
    done
  '';

  meta = with lib; {
    description = "BM3D denoise filter for VapourSynth using HIP/ROCm";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
