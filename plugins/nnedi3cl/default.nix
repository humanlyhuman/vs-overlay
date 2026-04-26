{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost,
  ocl-icd,
  opencl-headers,
  vapoursynth,
}:

stdenv.mkDerivation rec {
  pname = "VapourSynth-NNEDI3CL";
  version = "8";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    sha256 = "0j99ihxy295plk1x5flgwzjkcjwyzqdmxnxmda9r632ksq9flvyd";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    boost
    ocl-icd
    opencl-headers
    vapoursynth
  ];

  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
  preConfigure = ''
    mkdir -p $TMPDIR/boost-patched
    cp -r ${lib.getDev boost}/include/boost $TMPDIR/boost-patched/
    chmod -R u+w $TMPDIR/boost-patched
  
    sed -i 's/desc\.mem_object = 0;//g' \
      $TMPDIR/boost-patched/boost/compute/image/image2d.hpp \
      $TMPDIR/boost-patched/boost/compute/image/image3d.hpp
  
    sed -i 's/desc\.mem_object = d->weights1Buffer\.get();//g' \
      NNEDI3CL/NNEDI3CL.cpp
  
    export NIX_CFLAGS_COMPILE="-I$TMPDIR/boost-patched $NIX_CFLAGS_COMPILE"
  '';
  
  postPatch = ''
    substituteInPlace meson.build \
      --replace "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';
        
  meta = with lib; {
    description = "An OpenCL accelerated nnedi3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
