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
  pname = "CTMF";
  version = "5";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-pScmi7160vyGn9cFiGc7XI0f8+vMFvbjEo+NGp5aD40=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "A CTMF filter plugin for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CTMF";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
