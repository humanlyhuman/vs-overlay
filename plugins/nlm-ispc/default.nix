{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ispc,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "vs-nlm-ispc";
  version = "4";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-nlm-ispc";
    rev = "v${version}";
    hash = "sha256-+NOXOv6e/xoiD+IoZc8QxnKc64RSmWkABGJ0gT8gg5s=";
  };

  nativeBuildInputs = [
    cmake
    ispc
  ];

  buildInputs = [
    vapoursynth
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_SKIP_RPATH=ON"
    "-DCMAKE_ISPC_FLAGS=--opt=fast-math"
    "-DCMAKE_ISPC_INSTRUCTION_SETS=sse2-i32x4;avx1-i32x4;avx2-i32x8"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    for f in $out/lib/*.so; do
      ln -s "$f" $out/lib/vapoursynth/
    done
  '';

  meta = with lib; {
    description = "CPU Non-local Means denoise filter for VapourSynth using ISPC";
    homepage = "https://github.com/AmusementClub/vs-nlm-ispc";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
