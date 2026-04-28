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
  mkZigDep = name: src:
    runCommand name {} ''
      mkdir -p $out
      cd ${src}
      tar -czf "$out/${name}.tar.gz" .
      cp -r . "$out/${name}"
    '';

  deps = linkFarm "vszip-zig-deps" [
    (let
      name = "vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2";
    in {
      inherit name;
      path = mkZigDep name (fetchgit {
        url = "https://github.com/dnjulek/vapoursynth-zig";
        rev = "8e93fe3433bb977135f81040bb59d964c58a1cb9";
        hash = "sha256-tcBr4q7/8u/8xmBO2dbtExi3n5j006nh6/fniO37UK4=";
      });
    })
    (let
      name = "zigimg-0.1.0-8_eo2jNrFQD4mu3EAUkfQRmCkyfprdIXc8JQ6uyxhjSQ";
    in {
      inherit name;
      path = mkZigDep name (fetchgit {
        url = "https://github.com/zigimg/zigimg";
        rev = "362cdd6bce109f7bc674be134cddd378f52da5d4";
        hash = "sha256-Pe7OAtocaH18FhpSwz3NNZLrBI9BS1rfOehq2UVmu6g=";
      });
    })
  ];
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
      for dep in ${deps}/*; do
        name=$(basename $dep)
        ln -s "$dep" "$ZIG_GLOBAL_CACHE_DIR/p/$name"
        tar -czf "$ZIG_GLOBAL_CACHE_DIR/p/${name}.tar.gz" -C "$dep" .
      done
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
