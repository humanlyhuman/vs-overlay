{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
  onnxruntime,
  protobuf,
  onnxruntime,
}:
stdenv.mkDerivation rec {
  pname = "vsort";
  version = "15.16";
  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    sha256 = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };
  sourceRoot = "source/vsort";
  patches = [
    ./no-git-call-in-cmake.patch
  ];
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    vapoursynth
    onnxruntime
    protobuf
    onnxruntime
  ];
  cmakeFlags = [
    "-DVCS_TAG=v${version}"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
    "-DCMAKE_SKIP_RPATH=ON"
  ];
  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libvsort.so $out/lib/vapoursynth/
  '';
  meta = with lib; {
    description = "ONNX Runtime-based CPU/GPU Runtime";
    homepage = "https://github.com/AmusementClub/vs-mlrt/blob/master/vsort";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aidalgol ];
    platforms = platforms.all;
  };
}
