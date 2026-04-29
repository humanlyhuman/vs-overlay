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
  pname = "DCTFilter";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-AORb/bBVT+k9fklM4Mjo0NTqQP4QcY4gvfZLJGATVAw=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [fftwFloat vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "Renewed DCTFilter filter plugin for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DCTFilter";
    license = licenses.mit;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
