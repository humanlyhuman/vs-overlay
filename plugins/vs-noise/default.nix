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
  pname = "vapoursynth-noise";
  version = "4";

  src = fetchFromGitHub {
    owner = "wwww-wwww";
    repo = "vs-noise";
    rev = "r${version}";
    hash = "sha256-pA5W9CxBgoqurMeIe8ekcOYNXr+Q/rFvWufu+7fLiAs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  mesonFlags = ["-Db_lto=false"];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'" \
                "'${placeholder "out"}/lib/vapoursynth'"
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    find $out -name "*.so" ! -path "*/vapoursynth/*" \
      -exec mv {} $out/lib/vapoursynth/ \;
  '';

  meta = with lib; {
    description = "AddNoise / vs-noise plugin for VapourSynth";
    homepage = "https://github.com/wwww-wwww/vs-noise";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
