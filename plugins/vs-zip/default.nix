{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  zig_0_15,
  vapoursynth,
}: let
  vsynth-src = fetchzip {
    url = "https://github.com/dnjulek/vapoursynth-zig/archive/8e93fe3433bb977135f81040bb59d964c58a1cb9.tar.gz";
    sha256 = "sha256-tcBr4q7/8u/8xmBO2dbtExi3n5j006nh6/fniO37UK4=";
  };
  zigimg-src = fetchzip {
    url = "https://github.com/zigimg/zigimg/archive/362cdd6bce109f7bc674be134cddd378f52da5d4.tar.gz";
    sha256 = "sha256-Er1qOyhm+rpIubkcwWBCoWljFyjVDj+Arp583ocJlLs=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "vapoursynth-plugin-vszip";
    version = "R13";
    src = fetchFromGitHub {
      owner = "dnjulek";
      repo = "vapoursynth-zip";
      rev = finalAttrs.version;
      hash = "sha256-k+HfMTn9FLUOCBHFAsSiqHHFF9Q4hUqJpfainN/e2Gc=";
    };
    nativeBuildInputs = [zig_0_15.hook];
    buildInputs = [vapoursynth];
    zigBuildFlags = ["-Doptimize=ReleaseFast"];
    preBuild = ''
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"
      cp -r ${vsynth-src} "$ZIG_GLOBAL_CACHE_DIR/p/vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2"
      cp -r ${zigimg-src} "$ZIG_GLOBAL_CACHE_DIR/p/zigimg-0.1.0-8_eo2jNrFQD4mu3EAUkfQRmCkyfprdIXc8JQ6uyxhjSQ"
    '';
    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      mv $out/lib/libvszip${stdenv.hostPlatform.extensions.sharedLibrary} \
         $out/lib/vapoursynth/
    '';
    meta = {
      description = "VapourSynth zip plugin";
      homepage = "https://github.com/dnjulek/vapoursynth-zip";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  })
