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
  pname = "eedi2";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI2";
    rev = "r${version}";
    hash = "sha256-Dt0rFwULpdZ83xKcwWd0NVQ4chgjtrJBIe0XTFazzoM=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "EEDI2 filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI2";
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
