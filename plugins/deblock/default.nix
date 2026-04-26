{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "VapourSynth-Deblock";
  version = "8";
  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-ipQfEZY5ZD+notSD1jJxyxoU3zpGBRhcOIuz808TDn4=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];
  buildInputs = [ vapoursynth ];
  postPatch = ''
    substituteInPlace meson.build \
      --replace \
        "include_directories: incdir," \
        "dependencies: vapoursynth_dep," \
      --replace \
        "install_dir: py.get_install_dir() / 'vapoursynth/plugins'," \
        "install_dir: get_option('libdir') / 'vapoursynth'," \
      --replace \
        "name_prefix: ''''," \
        ""
  
    sed -i '/incdir = include_directories(/,/)/c\incdir = []' meson.build
  
    sed -i "s|py = import('python').find_installation(pure: false)|&\nvapoursynth_dep = dependency('vapoursynth')|" meson.build
  '';
  meta = with lib; {
    description = "A Deblock filter plugin for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ humanlyhuman ];
    platforms = platforms.all;
  };
}
