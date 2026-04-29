{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  abseil-cpp,
  vapoursynth,
  onnxruntime,
  onnx,
  cudaPackages,
  protobuf,
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
  sourceRoot = "source/vsort";
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = with cudaPackages; [
    vapoursynth
    onnxruntime.dev
    onnx
    cudatoolkit
    protobuf
    abseil-cpp
  ];
  cmakeFlags = [
    "-DVCS_TAG=v${version}"
    "-DENABLE_CUDA=ON"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
    "-DCMAKE_SKIP_RPATH=ON"
  ];
  postPatch = ''
    sed -i '/find_package(Git REQUIRED)/,/string(STRIP/d' CMakeLists.txt
        substituteInPlace ${onnx}/lib/cmake/ONNX/ONNXTargets.cmake \
      --replace-fail \
        '"/build/source/thirdparty/protobuf/protobuf/src"' \
        ""  || true

    substituteInPlace ${onnx}/lib/cmake/ONNX/ONNXTargets.cmake \
      --replace-fail \
        "absl::absl_check" "" \
      --replace-fail \
        "absl::absl_log" "" \
      --replace-fail \
        "absl::base" "" \
      --replace-fail \
        "absl::throw_delegate" "" \
        || true
  '';
  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libvsort.so $out/lib/vapoursynth/libvsort-cuda.so
  '';
  meta = with lib; {
    description = "ONNX Runtime-based CPU/GPU Runtime";
    homepage = "https://github.com/AmusementClub/vs-mlrt/blob/master/vsort";
    license = licenses.gpl3;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
