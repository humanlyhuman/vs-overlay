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
  pname = "addgrain";
  version = "8";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-AddGrain";
    rev = "r${version}";
    hash = "sha256-kkArUXILOGymGkDEUikVGoma+PDbbWsoLdgG7WL7ymE=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "AddGrain filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain";
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
