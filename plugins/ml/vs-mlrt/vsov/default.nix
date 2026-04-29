{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchurl,
  onnx,
  onnxruntime,
  vapoursynth,
  openvino,
  protobuf,
  abseil-cpp,
}: let
  onnxProto = fetchurl {
    url = "https://raw.githubusercontent.com/onnx/onnx/v1.21.0/onnx/onnx.proto3";
    hash = "sha256-iymPl0wQ1e/L/KsGEnGfn1Q8fJqvylxq7uTE0e6NvvI=";
  };
in
  stdenv.mkDerivation rec {
    pname = "vsov";
    version = "15.16";

    src = fetchFromGitHub {
      owner = "AmusementClub";
      repo = "vs-mlrt";
      rev = "v${version}";
      hash = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
    };

    sourceRoot = "source/vsov";

    buildInputs = [
      vapoursynth
      openvino
      abseil-cpp
      onnx
      onnxruntime.dev
      protobuf
    ];

    postPatch = ''
      sed -i '/find_package(Git REQUIRED)/,+5 d' CMakeLists.txt
    '';
    nativeBuildInputs = [cmake protobuf];
    preConfigure = ''
      export GEN=$NIX_BUILD_TOP/generated
      mkdir -p $GEN/onnx-proto/onnx $GEN/onnx-generated

      cp ${onnxProto} $GEN/onnx-proto/onnx/onnx.proto3

      protoc \
        --cpp_out=$GEN/onnx-generated \
        -I $GEN/onnx-proto \
        $GEN/onnx-proto/onnx/onnx.proto3

      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$GEN/onnx-generated"
    '';

    cmakeFlags = [
      "-DVCS_TAG=v${version}"
      "-DCMAKE_SKIP_RPATH=ON"
      "-DOpenVINO_DIR=${openvino}/runtime/cmake"
    ];
    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libvsov.so $out/lib/vapoursynth/libvsov.so
    '';
    NIX_CFLAGS_COMPILE = [
      "-I${vapoursynth}/include/vapoursynth"
      "-I${onnx}/include"
    ];

    meta = with lib; {
      description = "OpenVINO-based CPU/GPU Runtime";
      homepage = "https://github.com/AmusementClub/vs-mlrt/blob/master/vsov";
      license = licenses.gpl3;
      maintainers = with maintainers; [humanlyhuman];
      platforms = platforms.linux;
    };
  }
