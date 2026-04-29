{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ispc,
  vapoursynth,
  cudaPackages,
}:
stdenv.mkDerivation rec {
  pname = "vs-nlm-cuda";
  version = "4";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-nlm-cuda";
    rev = "v${version}";
    hash = "sha256-LXYLzZ8Gu3Qomus65eIAbP/p3eDdIBkCwnUHq5O/ia8=";
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
    homepage = "https://github.com/AmusementClub/vs-nlm-cuda";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
