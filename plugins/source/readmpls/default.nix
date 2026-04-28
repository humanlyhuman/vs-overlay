{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libbluray,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "readmpls";
  version = "5";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-ReadMpls";
    rev = "r${version}";
    hash = "sha256-cQaGasNRI0p6sz1hecErDrw6lf6G3vk98SshGdRMn+Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libbluray
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'" "get_option('libdir') / 'vapoursynth'"
  '';

  meta = with lib; {
    description = "ReadMpls filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-ReadMpls";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
