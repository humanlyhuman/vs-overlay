{ lib, stdenv, fetchFromGitHub, pkg-config, which, vapoursynth, ffmpeg, l-smash }:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsmashsource";
  version = "1194.0.0.0";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "L-SMASH-Works";
    rev = finalAttrs.version;
    sha256 = "1pb8rrh184pxy5calwfnmm02i0by8vc91c07w4ygj50y8yfqa3br";
  };

  preConfigure = ''
    patchShebangs .
    cd VapourSynth
  '';

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ vapoursynth ffmpeg l-smash ];

  meta = with lib; {
    description = "L-SMASH source plugin for VapourSynth";
    homepage = "https://github.com/VFR-maniac/L-SMASH-Works";
    license = with licenses; [ isc lgpl21Plus ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
})
