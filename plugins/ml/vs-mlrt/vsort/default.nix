{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
  cudaPackages,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "vsort";
  version = "15.16";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    hash = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };

  cmakeFlags = [
    "-DVCS_TAG=v${version}"
    "-DCMAKE_SKIP_RPATH=ON"
    "-DENABLE_CUDA=OFF"
    "-DVAPOURSYNTH_INCLUDE_DIRECTORY=${vapoursynth}/include/vapoursynth"
    "-DTENSORRT_HOME=${cudaPackages.tensorrt}"
  ];

  sourceRoot = "source/vsort";

  postPatch = ''
    sed -i '/find_package(Git REQUIRED)/,+5 d' CMakeLists.txt
  '';
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = with cudaPackages; [
    vapoursynth
    tensorrt
    cudatoolkit
  ];

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libvstrt.so $out/lib/vapoursynth/libvstrt.so
  '';

  meta = with lib; {
    description = "TensorRTX-based GPU Runtime";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.gpl3;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
