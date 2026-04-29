{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
  yasm,
}:
stdenv.mkDerivation rec {
  pname = "nnedi3";
  version = "12";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jd/PCXhbCZGMsoXjekbeqMSRVBJAy4INdpkTbZFjVO0=";
  };

  configureFlags = ["--libdir=$(out)/lib/vapoursynth"];

  nativeBuildInputs = [pkg-config autoreconfHook];
  buildInputs = [vapoursynth yasm];

  meta = with lib; {
    description = "nnedi3 filter for VapourSynth";
    homepage = "https://github.com/dubhater/vapoursynth-nnedi3";
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
