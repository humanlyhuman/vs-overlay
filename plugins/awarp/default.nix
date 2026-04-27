{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "vapoursynth-awarp";
  version = "3";
  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-AWarp";
    rev = "661084c9112bdd0fa9f37c851c05ecbd78fbc060";
    hash = "sha256-lNKGCyFET63qirqCgxCq4HCNPpaqjPQp0jrifVb9VKQ=";
  };
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        "run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip()" \
        "'${vapoursynth}/include/vapoursynth'" \
      --replace-fail \
        "py.get_install_dir() / 'vapoursynth/plugins'" \
        "'${placeholder "out"}/lib/vapoursynth'"
  '';
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [vapoursynth];
  meta = with lib; {
    description = "VapourSynth AWarp plugin";
    homepage = "https://github.com/HolyWu/VapourSynth-AWarp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
