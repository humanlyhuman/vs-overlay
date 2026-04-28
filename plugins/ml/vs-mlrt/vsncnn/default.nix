{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
  ncnn,
  protobuf,
  onnx,
}:
stdenv.mkDerivation rec {
  pname = "vsncnn";
  version = "15.16";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    hash = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };

  sourceRoot = "source/vsncnn";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vapoursynth
    ncnn
    protobuf
    onnx
  ];
  
  postPatch = ''
    sed -i '/find_package(Git REQUIRED)/,+5 d' CMakeLists.txt
  '';

  cmakeFlags = [
    "-DVCS_TAG=v${version}"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libvsncnn.so $out/lib/vapoursynth/
  '';

  meta = with lib; {
    description = "NCNN-based GPU Runtime";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.gpl3;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
