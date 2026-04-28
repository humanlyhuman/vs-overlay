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
  pname = "sneedif";
  version = "4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-SNEEDIF";
    rev = "R${version}";
    hash = "sha256-LmSANVwS6g5575Xsms9cwg+9SikNObZ/kgdh+sh/PAw=";
  };

  build-system = [hatchling];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    boost
    opencl-headers
    ocl-icd
  ];

  dependencies = [vapoursynth];
  postPatch = ''
    sed -i '/vapoursynth>=74/d' pyproject.toml

    sed -i '/r = run_command(/,/^)/d' meson.build

    substituteInPlace meson.build \
      --replace-fail \
        "inc_vs = include_directories(r.stdout().strip())" \
        "inc_vs = include_directories('${vapoursynth}/include/vapoursynth')" \
      --replace-fail \
        "install_dir: py.get_install_dir() / 'vapoursynth/plugins'," \
        "install_dir: get_option('libdir') / 'vapoursynth',"
  '';
  doCheck = false;
  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s \
      $out/lib/python*/site-packages/vapoursynth/plugins/sneedif/libsneedif.so \
      $out/lib/vapoursynth/libsneedif.so
  '';

  meta = with lib; {
    description = "Setsugen No Ensemble of Edge Directed Interpolation Functions for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF";
    license = licenses.wtfpl;
    platforms = platforms.linux;
    maintainers = with maintainers; [humanlyhuman];
  };
}
