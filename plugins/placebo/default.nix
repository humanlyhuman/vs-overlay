{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  libplacebo,
  vapoursynth,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation rec {
  pname = "vs-placebo";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Lypheo";
    repo = pname;
    rev = version;
    sha256 = "sha256-PlqqMBU9WedOqQkl8S77xIUzBpaU1Bgv9ZY8Rfh803o=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libplacebo
    vapoursynth
    vulkan-headers
    vulkan-loader
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')" \
      --replace \
        "run_command(python, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip()" \
        "vapoursynth_dep.get_variable(pkgconfig: 'includedir')"
  '';

  meta = with lib; {
    description = "A libplacebo-based debanding, scaling and color mapping plugin for VapourSynth";
    homepage = "https://github.com/Lypheo/vs-placebo";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
