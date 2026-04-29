{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cudaPackages,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "dfttest2c";
  version = "10";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-dfttest2";
    rev = "v${version}";
    hash = "sha256-RpMHtNPAZf3Me5gFm74Lc0C5YTD0HqnmIlR4GeUlR28=";
  };
  nativeBuildInputs = [
    cmake
  ];

  buildInputs = with cudaPackages; [
    vapoursynth
    cudatoolkit
    cuda_nvrtc
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DVAPOURSYNTH_INCLUDE_DIRECTORY=${vapoursynth}/include/vapoursynth"
    "-DENABLE_CPU=OFF"
    "-DENABLE_HIP=OFF"
    "-DENABLE_CUDA=ON"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  postPatch = ''
    substituteInPlace rtc_source/CMakeLists.txt \
      --replace "nvrtc_static" "nvrtc" \
      --replace "nvrtc-builtins_static" "nvrtc"
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    for f in $out/lib/*.so; do
      ln -s "$f" $out/lib/vapoursynth/
    install -Dm644 "$out/dfftest2.py"
    done
  '';

  meta = with lib; {
    description = "DFTTest2 denoise filter for VapourSynth using CUDA";
    homepage = "https://github.com/AmusementClub/vs-dfttest2/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
