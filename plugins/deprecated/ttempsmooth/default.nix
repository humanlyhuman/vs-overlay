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
  pname = "ttempsmooth";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-v33SDyonEyrEuMIYDogK9JQ3qaTyrynyFQnfOTLu/EA=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "A TTempSmooth filter plugin for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TTempSmooth";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
