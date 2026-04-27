{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "znedi3";
  version = "3";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-ehqihRoQwi17RlLLEgCoPeWSzcXP8PKG8yIGw8I+5Gs=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # use system vapoursynth headers (adapted from AUR PKGBUILD)
    rm -rf vsxx/{VapourSynth,VSScript,VSHelper}.h

    substituteInPlace vsxx/VapourSynth++.hpp \
        --replace-fail '"VapourSynth.h"' '<VapourSynth.h>' \
        --replace-fail '"VSHelper.h"' '<VSHelper.h>'
'';

  buildInputs = [vapoursynth];

  makeFlags = lib.optional stdenv.isx86_64 "X86=1";

  CPPFLAGS = lib.concatStringsSep " " [
    "-I${vapoursynth}/include/vapoursynth"
    "-DNNEDI3_WEIGHTS_PATH=\\\"\"${placeholder "out"}/share/znedi3/nnedi3_weights.bin\"\\\""
  ];

  installPhase = ''
    install -D vsznedi3.so $out/lib/vapoursynth/libvsznedi3.so
    install -D nnedi3_weights.bin $out/share/znedi3/nnedi3_weights.bin
  '';

  meta = with lib; {
    description = "A CPU optimised nnedi3 filter for VapourSynth";
    homepage = "https://github.com/sekrit-twc/znedi3";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.all;
  };
}
