{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  linkFarm,
  runCommand,
  zig,
  vapoursynth,
}: let
vsynth-tarball = mkZigTarball {
    name = "vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2";
    url = "git+https://github.com/dnjulek/vapoursynth-zig.git#8e93fe3433bb977135f81040bb59d964c58a1cb9";
    hash = "sha256:32436a3d3b0fbb46e2dd5eb7cb39145fb6ba856bf342b412c13a76838d3b7704";
  };
  zigimg-tarball = mkZigTarball {
    name = "zigimg-0.1.0-8_eo2jNrFQD4mu3EAUkfQRmCkyfprdIXc8JQ6uyxhjSQ";
    url = "git+https://github.com/zigimg/zigimg.git#362cdd6bce109f7bc674be134cddd378f52da5d4";
    hash = "sha256:588d89df8995b7c681064bf0b965cc8fcd24853b7a512eae8fa09aa1f0474a4b";
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

    nativeBuildInputs = [zig.hook];
    buildInputs = [vapoursynth];

    zigBuildFlags = ["-Doptimize=ReleaseFast"];

preBuild = ''
  mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"

  cp ${vsynth-tarball} "$ZIG_GLOBAL_CACHE_DIR/p/vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2.tar.gz"
  tar -xzf ${vsynth-tarball} -C "$ZIG_GLOBAL_CACHE_DIR/p/vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2"

  cp ${zigimg-tarball} "$ZIG_GLOBAL_CACHE_DIR/p/zigimg-0.1.0-8_eo2jNrFQD4mu3EAUkfQRmCkyfprdIXc8JQ6uyxhjSQ.tar.gz"
  tar -xzf ${zigimg-tarball} -C "$ZIG_GLOBAL_CACHE_DIR/p/zigimg-0.1.0-8_eo2jNrFQD4mu3EAUkfQRmCkyfprdIXc8JQ6uyxhjSQ"
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
