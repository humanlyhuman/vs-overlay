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
  pname = "vapoursynth-edgemasks";
  version = "4";

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-EdgeMasks";
    rev = "r${version}";
    sha256 = "sha256-H9kAmgoktxmxKWSG9ZBdxY4vGONlxOXwadNJdnIEjUI=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace \
        "run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip()" \
        "'${vapoursynth}/include/vapoursynth'" \
      --replace \
        "py.get_install_dir() / 'vapoursynth/plugins'" \
        "'${placeholder "out"}/lib/vapoursynth'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (vapoursynth.python3)
  ];
  buildInputs = [ vapoursynth ];

  meta = with lib; {
    description = "EdgeMasks filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-EdgeMasks";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
