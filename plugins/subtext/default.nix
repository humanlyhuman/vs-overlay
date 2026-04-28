{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  ffmpeg,
  libass,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "subtext";
  version = "6";
  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = pname;
    rev = "R${version}";
    hash = "sha256-MX1QQ0h82PLXasYrnFbrkaeAXmGENCxyqWmnVUP27dY=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    ffmpeg
    libass
    vapoursynth
  ];
  meta = with lib; {
    description = "Subtitle plugin for VapourSynth based on libass";
    homepage = "https://github.com/vapoursynth/subtext";
    license = licenses.mit;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.all;
  };
}
