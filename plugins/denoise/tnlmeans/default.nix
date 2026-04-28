{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "tnlmeans";
  version = "unstable-2015-02-25";

  src = fetchFromGitHub {
    owner = "VFR-maniac";
    repo = "VapourSynth-TNLMeans";
    rev = "22a40afaf78b6932800f552c43edc510da2d50a3";
    hash = "sha256-VA6Gqapi9KzYxNlkLv8lS2i6vkl1eeLPs29r2MqSSwk=";
  };

  preConfigure = ''
    patchShebangs .
  '';

  nativeBuildInputs = [which];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "An implementation of the NL-means denoising algorithm";
    homepage = "https://github.com/VFR-maniac/VapourSynth-TNLMeans";
    license = licenses.lgpl2;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
