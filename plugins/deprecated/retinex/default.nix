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
  pname = "retinex";
  version = "4";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-Retinex";
    rev = "r${version}";
    hash = "sha256-z7B9M2BLV1Me8StOYN19G2UxV9ZgzX6Xav4g67iqEoE=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  installPhase = let
    ext = stdenv.targetPlatform.extensions.sharedLibrary;
  in ''
    install -D libretinex${ext} $out/lib/vapoursynth/libretinex${ext}
  '';

  meta = with lib; {
    description = "Retinex algorithm for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Retinex";
    license = licenses.gpl3;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
