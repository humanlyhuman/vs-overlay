{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
  cudatoolkit,
  cudaPackages,
}:
stdenv.mkDerivation rec {
  pname = "vstrt";
  version = "15.16";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    hash = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };

  sourceRoot = "source/vstrt";

  patches = [
    ./no-git-call-in-cmake.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vapoursynth
    cudatoolkit
    cudaPackages.tensorrt
  ];

  cmakeFlags = [
    "-DVCS_TAG=v${version}"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libvstrt.so $out/lib/vapoursynth
  '';

  meta = with lib; {
    description = "TensorRT-based GPU Runtime";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.gpl3;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
