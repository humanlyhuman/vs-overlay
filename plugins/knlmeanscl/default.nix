{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  meson,
  ninja,
  packaging,
  pkg-config,
  vapoursynth,
  boost,
  opencl-headers,
  ocl-icd,
}:

buildPythonPackage rec {
  pname = "vapoursynth-knlmeanscl";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-knlmeanscl";
    rev = "v${version}";
    hash = "sha256-mFOcKqUzDhWu7yiqiHReTFSzb5jA/YDPb7IOASX9JUo=";
  };

  build-system = [ hatchling meson ninja packaging ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    vapoursynth
    boost
    opencl-headers
    ocl-icd
  ];

  dependencies = [ vapoursynth ];

  postPatch = ''
    sed -i '/vapoursynth>=74/d' pyproject.toml

    sed -i '/r = run_command(/,/^)/d' meson.build

    substituteInPlace meson.build \
      --replace-fail \
      "lib_inc += include_directories(r.stdout().strip())" \
      "lib_inc += include_directories('${vapoursynth}/include/vapoursynth')" \
      --replace-fail \
      "install: false," \
      "install: true, install_dir: get_option('libdir') / 'vapoursynth',"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Optimized OpenCL implementation of Non-local means denoising";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-knlmeanscl";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
