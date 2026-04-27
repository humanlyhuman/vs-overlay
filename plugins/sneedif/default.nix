{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # Python build backend
  hatchling,
  # Native build tools
  meson,
  ninja,
  pkg-config,
  # Runtime / Python deps
  vapoursynth,
  # C++ deps
  boost,
  opencl-headers,
  ocl-icd,
}:
buildPythonPackage rec {
  pname = "vapoursynth-sneedif";
  version = "4.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-SNEEDIF";
    rev = "R${version}";
    hash = "sha256-LmSANVwS6g5575Xsms9cwg+9SikNObZ/kgdh+sh/PAw=";
  };

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    opencl-headers
    ocl-icd
  ];

  dependencies = [
    vapoursynth
  ];

  postPatch = ''
    sed -i '/incdir = include_directories(/,/^)/d' meson.build
    sed -i '/vapoursynth>=74/d' pyproject.toml

    sed -i '/r = run_command(/,/^)/d' meson.build

    substituteInPlace meson.build \
      --replace "include_directories: incdir," "dependencies: vapoursynth_dep," \
      --replace "install_dir: py.get_install_dir() / 'vapoursynth/plugins'," \
                "install_dir: get_option('libdir') / 'vapoursynth',"
  '';

  doCheck = false;
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "Setsugen No Ensemble of Edge Directed Interpolation Functions for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF";
    license = licenses.wtfpl;
    platforms = platforms.linux;
    maintainers = [];
  };
}
