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
    rev = "${version}";
    hash = "sha256-spp+usDmiXW97PsPwZSmvsnMc7hWV9s4nZOZNwdg5Aw=";
  };

  nativeBuildInputs = [
    cmake
    rocmPackages.clr
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
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    for f in $out/lib/*.so; do
      ln -s "$f" $out/lib/vapoursynth/
    done
  '';

  meta = with lib; {
    description = "BM3D denoise filter for VapourSynth using HIP/ROCm";
    homepage = "https://github.com/WolframRhodium/VapourSynth-BM3DCUDA";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ humanlyhuman ];
    platforms = platforms.linux;
  };
}