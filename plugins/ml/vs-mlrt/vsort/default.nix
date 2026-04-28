{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
  onnxruntime,
  onnx,
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

  buildInputs = [
    vapoursynth
    onnxruntime
    onnx
    protobuf
  ];

  cmakeFlags = [
    "-DVCS_TAG=v${version}"
    "-DCMAKE_SKIP_RPATH=ON"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
  ];

  postPatch = ''
    sed -i '/find_package(Git REQUIRED)/,+5 d' CMakeLists.txt
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libvsort.so $out/lib/vapoursynth/
  '';

  meta = with lib; {
    description = "ONNX Runtime-based CPU/GPU Runtime";
    homepage = "https://github.com/AmusementClub/vs-mlrt/blob/master/vsort";
    license = licenses.gpl3;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
