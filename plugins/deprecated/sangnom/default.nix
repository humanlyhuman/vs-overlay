{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "sangnom";
  version = "42";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = "vapoursynth-sangnom";
    rev = "r${version}";
    hash = "sha256-2lEnwms2wSOyMRmasRG1r8iPAFmBObP6pDzPIinJLz0=";
  };

  mesonFlags = ["--libdir=${placeholder "out"}/lib/vapoursynth"];

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "VapourSynth Single Field Deinterlacer";
    homepage = "https://github.com/dubhatervapoursynth/vapoursynth-sangnom";
    license = licenses.mit;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
