{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "hqdn3d";
  version = "unstable-2018-06-29";

  src = fetchFromGitHub {
    owner = "Hinterwaeldlers";
    repo = pname;
    rev = "eb820cb23f7dc47eb67ea95def8a09ab69251d30";
    hash = "sha256-BObHZs7GQW6UFUwohII1MXHtk5ooGh/LfZ3ZsqoPQBU=";
  };

  configureFlags = ["--libdir=$(out)/lib/vapoursynth"];

  nativeBuildInputs = [autoreconfHook pkg-config];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "Vapoursynth port of hqdn3d from avisynth/mplayer";
    homepage = "https://github.com/Hinterwaeldlers/vapoursynth-hqdn3d";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
