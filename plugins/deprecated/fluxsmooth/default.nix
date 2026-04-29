{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "fluxsmooth";
  version = "2";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = "vapoursynth-fluxsmooth";
    rev = "v${version}";
    hash = "sha256-u12XjXOZCasgQtrxtuAjFxYaziMCWFNK0rqV5qM/Qnw=";
  };

  configureFlags = ["--libdir=$(out)/lib/vapoursynth"];

  nativeBuildInputs = [pkg-config autoreconfHook];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "A vapoursynth filter plugin for smoothing of fluctuations";
    homepage = "https://github.com/dubhatervapoursynth/vapoursynth-fluxsmooth";
    license = licenses.unfree;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
