{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  pkg-config,
  vapoursynth,
  freetype,
  harfbuzz,
  fontconfig,
}:
llvmPackages.stdenv.mkDerivation {
  pname = "vsfiltermod";
  version = "unstable-2026-03-24";

  src = fetchFromGitHub {
    owner = "Cinea4678";
    repo = "VSFilterModButCMake";
    rev = "93f5a12bde15d4472c0fd8c86c18f6c1de0cf098";
    hash = "sha256-c3NDDG+AgY8ojAZ2fOKWLbByl4/FRIBJTy+zBbsE6dQ=";
  };

  sse2neon = fetchFromGitHub {
    owner = "DLTcollab";
    repo = "sse2neon";
    rev = "v1.7.0";
    hash = "sha256-riFFGIA0H7e5StYSjO0/JDrduzfwS+lOASzk5BRUyo4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    freetype
    harfbuzz
    fontconfig
  ];

  cmakeFlags = [
    "-DVSFILTERMOD_BUILD_DIRECTSHOW=OFF"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
    "-DCMAKE_SKIP_RPATH=ON"
    "-Dsse2neon_SOURCE_DIR=${sse2neon}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  dontInstall = true;

  postBuild = ''
    mkdir -p $out/lib/vapoursynth
    cp src/plugins/vsfiltermod.so $out/lib/vapoursynth/libvsfm.so
  '';

  meta = with lib; {
    description = "VSFilterMod subtitle renderer with VapourSynth interface and CMake build system";
    homepage = "https://github.com/Cinea4678/VSFilterModButCMake";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
