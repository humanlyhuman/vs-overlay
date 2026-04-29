{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  boost,
  opencl-headers,
  ocl-icd,
}:
stdenv.mkDerivation rec {
  pname = "eedi3";
  version = "4";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "r${version}";
    hash = "sha256-3YQzzKGpkZU6AUt33U0w2f3zybpaf5bIPNSxrI6g6eA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    boost
    opencl-headers
    ocl-icd
  ];
  mesonFlags = ["-Db_lto=false"];

  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  postUnpack = ''
    mkdir -p "$sourceRoot/patched-boost/boost/compute/image"

    for f in image1d image2d image3d; do
      substitute \
        "${lib.getDev boost}/include/boost/compute/image/$f.hpp" \
        "$sourceRoot/patched-boost/boost/compute/image/$f.hpp" \
        --replace-fail "mem_object" "buffer"
    done
  '';

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"

    substituteInPlace EEDI3/EEDI3CL.cpp \
      --replace-fail "mem_object" "buffer" || true
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I$PWD/patched-boost \
      -DCL_TARGET_OPENCL_VERSION=120 \
      -DCL_HPP_TARGET_OPENCL_VERSION=120 \
      -DCL_HPP_MINIMUM_OPENCL_VERSION=120 \
      $NIX_CFLAGS_COMPILE"
  '';

  meta = with lib; {
    description = "Renewed EEDI3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
