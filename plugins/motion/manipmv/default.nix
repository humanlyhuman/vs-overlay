{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  python3,
  fetchgit,
  zig_0_15,
}: let
  vsynth-src = fetchgit {
    url = "https://github.com/dnjulek/vapoursynth-zig";
    rev = "8e93fe3433bb977135f81040bb59d964c58a1cb9";
    hash = "sha256-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2";
  };
  zigsv-src = fetchgit {
    url = "https://github.com/ritalin/zig-set-version";
    rev = "14c65c533cd85b02ed5a7cff35398a413b9b6a7b";
    hash = "sha256-VcSFV0FkAAAr6WCGYZwuup5pWg62naL4FPuFiI0D5--P";
  };
in
stdenv.mkDerivation rec {
  pname = "manipmv";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Mikewando";
    repo = "manipulate-motion-vectors";
    rev = version;
    hash = "sha256-+aOdO7CqeIhOLfEPluv37rtxaucAdPMuNmpRVnkxw8I=";
  };

  nativeBuildInputs = [
    zig_0_15
    pkg-config
  ];
  
  buildInputs = [vapoursynth];
  preConfigure = ''
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"
    cp -r ${vsynth-src} "$ZIG_GLOBAL_CACHE_DIR/p/vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2"
    cp -r ${zigsv-src} "$ZIG_GLOBAL_CACHE_DIR/p/zig_set_version-0.2.1-VcSFV0FkAAAr6WCGYZwuup5pWg62naL4FPuFiI0D5--P"
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    mv $out/lib/libmanipmv${stdenv.hostPlatform.extensions.sharedLibrary} \
       $out/lib/vapoursynth/
  '';
  
  meta = with lib; {
    description = "Manipulate Motion Vectors plugin for VapourSynth";
    homepage = "https://github.com/Mikewando/manipulate-motion-vectors";
    license = licenses.lgpl21;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
