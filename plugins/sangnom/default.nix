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
  pname = "vapoursynth-sangnom";
  version = "43";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-iuKqxrXrmyCVsPozmnXXy2uxNL88pAGZb0pAroyBnUY=";
  };

  mesonFlags = [ "--libdir=${placeholder "out"}/lib/vapoursynth" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ vapoursynth ];

  meta = with lib; {
    description = "VapourSynth Single Field Deinterlacer";
    homepage = "https://github.com/dubhater/vapoursynth-sangnom";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
