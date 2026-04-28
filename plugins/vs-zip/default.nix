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
  vsynth-src = fetchgit {
    url = "https://github.com/dnjulek/vapoursynth-zig.git";
    rev = "8e93fe3433bb977135f81040bb59d964c58a1cb9";
    hash = "sha256-MkNqPTsPu0bi3V6364kUX7a2qFa/NCthLBOnaDjbdwQ=";
  };
  zigimg-src = fetchgit {
    url = "https://github.com/zigimg/zigimg.git";
    rev = "362cdd6bce109f7bc674be134cddd378f52da5d4";
    hash = "sha256-WI2J34iVt8aBBkS/C2WMj80khTt6US6o+gmpofBHSk=";
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
