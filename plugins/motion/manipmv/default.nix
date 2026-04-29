{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "manipmv";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Mikewando";
    repo = "manipulate-motion-vectors";
    rev = version;
    hash = "";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [vapoursynth];
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth/include" "${vapoursynth}/include/vapoursynth" \
      --replace-fail "py.get_install_dir() / 'vapoursynth/plugins'" "'${placeholder "out"}/lib/vapoursynth'"
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=missing-field-initializers";

  meta = with lib; {
    description = "Manipulate Motion Vectors plugin for VapourSynth";
    homepage = "https://github.com/Mikewando/manipulate-motion-vectors";
    license = licenses.lgpl21;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
