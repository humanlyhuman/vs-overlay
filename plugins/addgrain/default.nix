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
  pname = "vapoursynth-addgrain";
  version = "10";
  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-AddGrain";
    rev = "r${version}";
    sha256 = "sha256-HNdYDpoyhWkpZZhcji2tWxWTojXKTKBbvm+iHp6Zdeo=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ vapoursynth ];
  postPatch = ''
    substituteInPlace meson.build \
      --replace "vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'" \
                "'${placeholder "out"}/lib/vapoursynth'"
  '';
  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    find $out -name "libaddgrain.so" ! -path "*/vapoursynth/*" \
      -exec mv {} $out/lib/vapoursynth/ \;
  '';
  meta = with lib; {
    description = "AddGrain filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
