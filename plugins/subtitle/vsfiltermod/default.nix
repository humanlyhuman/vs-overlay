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
llvmPackages.stdenv.mkDerivation rec {
  pname = "vsfiltermod";
  version = "unstable-2026-03-24";

  src = fetchFromGitHub {
    owner = "Cinea4678";
    repo = "VSFilterModButCMake";
    rev = "93f5a12bde15d4472c0fd8c86c18f6c1de0cf098";
    hash = "sha256-c3NDDG+AgY8ojAZ2fOKWLbByl4/FRIBJTy+zBbsE6dQ=";
  };

  patches = [
    ./0001-top-level-csri.patch
  ];
  postPatch = ''
      mkdir -p src/csri

      cat > src/csri/CMakeLists.txt <<'EOF'
    add_library(vsfiltermod-csri SHARED
      ../vsfilter/csriapi.cpp
    )

    target_link_libraries(vsfiltermod-csri PRIVATE
      subtitles
      subpic
      platform
      libssf
      libpng
      zlib
    )

    target_include_directories(vsfiltermod-csri PRIVATE
      ''${CMAKE_SOURCE_DIR}/src/vsfilter
    )

    set_target_properties(vsfiltermod-csri PROPERTIES
      OUTPUT_NAME vsfiltermod-csri
    )

    install(TARGETS vsfiltermod-csri
      LIBRARY DESTINATION lib
    )
    EOF

      sed -i '/afxdlgs.h/d' src/vsfilter/csriapi.cpp
      sed -i '/atlpath.h/d' src/vsfilter/csriapi.cpp

      substituteInPlace src/vsfilter/csriapi.cpp \
        --replace-fail '#include "stdafx.h"' '#include "../subtitles/stdafx.h"' \
        --replace-fail '..\subtitles\VobSubFile.h' '../subtitles/VobSubFile.h' \
        --replace-fail '..\subtitles\RTS.h' '../subtitles/RTS.h' \
        --replace-fail '..\subtitles\SSF.h' '../subtitles/SSF.h' \
        --replace-fail '..\SubPic\MemSubPic.h' '../subpic/MemSubPic.h' \
        --replace-fail 'enum csri_pixfmt pixfmt;' 'int pixfmt;' \
        --replace-fail 'MultiByteToWideChar(CP_UTF8,' 'MultiByteToWideChar(65001,'
  '';

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
    "-DVSFILTERMOD_BUILD_CSRI=ON"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vapoursynth

    install -Dm755 src/plugins/vsfiltermod.so \
      $out/lib/vapoursynth/libvsfm.so

    if [ -f src/csri/libvsfiltermod-csri.so ]; then
      install -Dm755 src/csri/libvsfiltermod-csri.so \
        $out/lib/libvsfiltermod-csri.so
    elif [ -f libvsfiltermod-csri.so ]; then
      install -Dm755 libvsfiltermod-csri.so \
        $out/lib/libvsfiltermod-csri.so
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "VSFilterMod with VapourSynth plugin and CSRI renderer";
    homepage = "https://github.com/Cinea4678/VSFilterModButCMake";
    license = licenses.gpl3;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
