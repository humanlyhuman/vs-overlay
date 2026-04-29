{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "dfttest2";
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

  buildInputs = [
    vapoursynth
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DVS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
    "-DENABLE_CPU=ON"
    "-DENABLE_HIP=OFF"
    "-DENABLE_CUDA=OFF"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  srcvectorclass = fetchFromGitHub {
    owner = "vectorclass";
    repo = "version2";
    rev = "a0a33986fb1fe8a5b7844e8a1b1f197ce19af35d";
    hash = "sha256-Lpj3IskrUwduRC4v7QobK1s2iVmkPCmiaVTSqOI0zvg=";
  };

  preConfigure = ''
    ln -s ${srcvectorclass}/* ./cpu_source/vectorclass/
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    for f in $out/lib/*.so; do
      ln -s "$f" $out/lib/vapoursynth/
    done
  '';

  meta = with lib; {
    description = "DFTTest2 denoise filter for VapourSynth using CPU";
    homepage = "https://github.com/AmusementClub/vs-dfttest2/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
