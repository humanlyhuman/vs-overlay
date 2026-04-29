{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "histogram";
  version = "2";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = "vapoursynth-histogram";
    rev = "v${version}";
    hash = "sha256-NME20pZZndUCcR1fY+mieBVrHxBYpB0xO1wbyghxsvE=";
  };

  configureFlags = ["--libdir=$(out)/lib/vapoursynth"];

  nativeBuildInputs = [pkg-config autoreconfHook];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "Histogram plugin for VapourSynth";
    homepage = "https://github.com/dubhatervapoursynth/vapoursynth-histogram";
    license = licenses.gpl2Plus; # https://github.com/dubhatervapoursynth/vapoursynth-histogram/issues/2
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
