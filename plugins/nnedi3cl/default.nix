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

  postPatch = ''
    substituteInPlace meson.build \
        --replace "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"

    for f in \
      ${lib.getDev boost}/include/boost/compute/image/image2d.hpp \
      ${lib.getDev boost}/include/boost/compute/image/image3d.hpp; do
      cp "$f" "$(basename $f).orig"
    done

    substituteInPlace ../NNEDI3CL/NNEDI3CL.cpp \
      --replace "desc.mem_object = d->weights1Buffer.get();" \
                "/* mem_object removed in OpenCL 3.0 */"
  '';

  env.NIX_CFLAGS_COMPILE = "-DCL_USE_DEPRECATED_OPENCL_1_2_APIS";

  meta = with lib; {
    description = "An OpenCL accelerated nnedi3 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
