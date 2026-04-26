{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  nasm,
  which,
  vapoursynth,
  ffmpeg,
  l-smash,
  xxHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsmashsource";
  version = "1282";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "L-SMASH-Works";
    rev = finalAttrs.version;
    hash = "sha256-0TSK5nvLAOwn6BrEFuMd342i+rAyu6JLWWk4czx9RXI=";
  };

  preConfigure = ''
    patchShebangs .
    cd VapourSynth
  '';

  postPatch = ''
    substituteInPlace VapourSynth/meson.build \
        --replace "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    which
  ];
  buildInputs = [
    l-smash
    vapoursynth
    xxHash
    (ffmpeg.override {
      source = fetchFromGitHub {
        owner = "HomeOfAviSynthPlusEvolution";
        repo = "FFmpeg";
        rev = "custom-patches-for-lsmashsource";
        hash = "sha256-vbnrdHOzANc+EXKr4SAW9Hcorbgih/apsFoTaJlIITQ=";
      };
    })
  ];

  meta = with lib; {
    description = "L-SMASH source plugin for VapourSynth";
    homepage = "https://github.com/VFR-maniac/L-SMASH-Works";
    license = with licenses; [
      isc
      lgpl21Plus
    ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
})
