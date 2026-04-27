{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, vapoursynth }:

stdenv.mkDerivation rec {
  pname = "vapoursynth-awarp";
  version = "3";
  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-AWarp";
    rev = "661084c9112bdd0fa9f37c851c05ecbd78fbc060";
    sha256 = "sha256-lNKGCyFET63qirqCgxCq4HCNPpaqjPQp0jrifVb9VKQ=";
  };

  mesonFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
    "-Dvapoursynth:includedir=${vapoursynth}/include/vapoursynth"
  ];

  nativeBuildInputs = [ meson ninja pkg-config
    (vapoursynth.python3.withPackages (ps: [ vapoursynth ]))
  ];
  buildInputs = [ vapoursynth ];

  meta = with lib; {
    description = "VapourSynth edge sharpener plugin";
    homepage = "https://github.com/HolyWu/VapourSynth-AWarp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
