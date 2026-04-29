{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rocmPackages,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "dfttest2hip";
  version = "10";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-dfttest2";
    rev = "v${version}";
    hash = "sha256-RpMHtNPAZf3Me5gFm74Lc0C5YTD0HqnmIlR4GeUlR28=";
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
    description = "DFTTest2 denoise filter for VapourSynth using HIP/ROCm";
    homepage = "https://github.com/AmusementClub/vs-dfttest2/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
