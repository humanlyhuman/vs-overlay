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
      cat > meson.build << 'EOF'
  project('Deblock', 'cpp',
      default_options: ['buildtype=release', 'warning_level=2', 'b_lto=true', 'b_ndebug=if-release', 'cpp_std=c++17'],
      license: 'GPL-2.0-or-later',
      license_files: 'LICENSE',
      meson_version: '>=1.2.3',
      version: '8.0',
  )
  vapoursynth_dep = dependency('vapoursynth')
  incdir = include_directories(vapoursynth_dep.get_variable(pkgconfig: 'includedir'))
  shared_module('deblock',
      files('Deblock/Deblock.cpp'),
      gnu_symbol_visibility: 'hidden',
      include_directories: incdir,
      install: true,
      install_dir: get_option('libdir'),
      name_prefix: ''
  )
  EOF
    '';
  meta = with lib; {
    description = "A Deblock filter plugin for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ humanlyhuman ];
    platforms = platforms.all;
  };
}
