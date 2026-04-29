{
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  stdenv,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "median";
  version = "4";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-23rNaTanNgD1ClKSbEfRzLRbLekubY4TnL28ecKLoJs=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [vapoursynth];

  mesonFlags = ["--libdir=${placeholder "out"}/lib/vapoursynth"];

  meta = with lib; {
    description = "VapourSynth plugin to generate a pixel-by-pixel median of several clips";
    homepage = "https://github.com/dubhater/vapoursynth-median/";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
