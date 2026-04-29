{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fftwFloat,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "FFT3DFilter";
  version = "unstable-2020-08-05"; # last version before requiring v4 api

  src = fetchFromGitHub {
    owner = "myrsloik";
    repo = pname;
    rev = "64323f0fdee4dd4fe429ee6287906dbae8e7571c";
    hash = "sha256-NDFnaddkS4kvTH32YtOKtxSV/TwaOvMf1lmPcWJwXGg=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [fftwFloat vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "A VapourSynth port of FFT3DFilter";
    homepage = "https://github.com/myrsloik/VapourSynth-FFT3DFilter";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
