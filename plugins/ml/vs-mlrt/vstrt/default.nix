{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
  cudaPackages,
  pkgs,
}: let
  empty = name:
    pkgs.runCommand name {} ''
      mkdir -p $out
    '';

  cudaPackages' = cudaPackages.overrideScope (final: prev: {
    cuda_compat = empty "cuda_compat-empty";
    libcudla = empty "libcudla-empty";
  });
in
  stdenv.mkDerivation rec {
    pname = "vstrt";
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
      "-DVAPOURSYNTH_INCLUDE_DIRECTORY=${vapoursynth}/include/vapoursynth"
      "-DTENSORRT_HOME=${cudaPackages'.tensorrt}"
    ];

    sourceRoot = "source/vstrt";

    postPatch = ''
      sed -i '/find_package(Git REQUIRED)/,+5 d' CMakeLists.txt
    '';
    nativeBuildInputs = [
      cmake
    ];
    buildInputs = [
      vapoursynth
      cudaPackages'.cuda_cudart
      cudaPackages'.tensorrt
      cudaPackages'.cuda_nvcc
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
