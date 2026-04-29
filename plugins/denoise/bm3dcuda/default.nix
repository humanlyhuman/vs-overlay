{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cudaPackages,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "bm3dcuda";
  version = "R2.16";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = "VapourSynth-BM3DCUDA";
    rev = "${version}";
    hash = "sha256-spp+usDmiXW97PsPwZSmvsnMc7hWV9s4nZOZNwdg5Aw=";
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
    "-DENABLE_CUDA=ON"
    "-DENABLE_HIP=OFF"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  postPatch = ''
    substituteInPlace rtc_source/CMakeLists.txt \
      --replace-fail "nvrtc_static" "nvrtc" \
      --replace-fail "nvrtc-builtins_static" "nvrtc"
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    for f in $out/lib/*.so; do
      ln -s "$f" $out/lib/vapoursynth/
    done
  '';

  meta = with lib; {
    description = "BM3D denoise filter for VapourSynth using CUDA";
    homepage = "https://github.com/WolframRhodium/VapourSynth-BM3DCUDA";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
