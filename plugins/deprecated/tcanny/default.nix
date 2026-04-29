{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  boost183,
  opencl-headers,
  ocl-icd,
}:
stdenv.mkDerivation rec {
  pname = "tcanny";
  version = "12";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-TCanny";
    rev = "r${version}";
    hash = "sha256-Z8SS3zwpmyv/nMLRwUemNjeVEXcfCAQI5JhOklZ/W8s=";
  };

  nativeBuildInputs = [meson ninja pkg-config];

  buildInputs = [
    vapoursynth
    boost183
    opencl-headers
    ocl-icd
  ];

  NIX_CFLAGS_COMPILE = [
    "-DCL_TARGET_OPENCL_VERSION=120"
    "-DCL_HPP_TARGET_OPENCL_VERSION=120"
  ];

  BOOST_INCLUDEDIR = "${lib.getDev boost183}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost183}/lib";

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';
}
