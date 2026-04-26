{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bifrost";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5miEJr8ys73G6NSpRJ3R50rgfUZ+F2VLGZQWF3j5K7s=";
  };

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [ vapoursynth ];

  meta = with lib; {
    description = "Bifrost (temporal derainbowing) plugin for Vapoursynth";
    homepage = "https://github.com/dubhater/vapoursynth-bifrost";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
