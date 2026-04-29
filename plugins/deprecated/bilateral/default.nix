{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "bilateral";
  version = "3";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-Bilateral";
    rev = "r${version}";
    hash = "sha256-wBmVICqDyVJUl5QPwGV9X1rM8FvKqM7kmJmcT9BbMBc=";
  };

  preConfigure = "chmod +x configure";
  dontAddPrefix = true;
  configureFlags = ["--install=$(out)/lib/vapoursynth"];

  nativeBuildInputs = [which];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "Bilateral filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bilateral";
    license = licenses.gpl3;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
