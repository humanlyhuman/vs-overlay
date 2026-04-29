{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost183,
  ocl-icd,
  opencl-headers,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "NNEDI3CL";
  version = "8";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-NNEDI3CL";
    rev = "r${version}";
    hash = "sha256-zW/qEtZTDJOTarXbXhv+nks25eePutLDpLck4TuMKUk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    boost183
    ocl-icd
    opencl-headers
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"

    substituteInPlace NNEDI3CL/NNEDI3CL.cpp \
      --replace-fail "mem_object" "buffer"
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-DCL_TARGET_OPENCL_VERSION=120 \
                               -DCL_HPP_TARGET_OPENCL_VERSION=120 \
                               $NIX_CFLAGS_COMPILE"
  '';
}
