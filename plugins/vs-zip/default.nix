{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  linkFarm,
  zig,
  vapoursynth,
}: let
  zigDeps = linkFarm "vszip-zig-deps" [
    {
      name = "vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2";
      path = fetchFromGitHub {
        owner = "dnjulek";
        repo = "vapoursynth-zig";
        rev = "8e93fe3433bb977135f81040bb59d964c58a1cb9";
        hash = "sha256-tcBr4q7/8u/8xmBO2dbtExi3n5j006nh6/fniO37UK4=";
      };
    }
    {
      name = "zigimg-0.1.0-8_eo2jNrFQD4mu3EAUkfQRmCkyfprdIXc8JQ6uyxhjSQ";
      path = fetchFromGitHub {
        owner = "zigimg";
        repo = "zigimg";
        rev = "362cdd6bce109f7bc674be134cddd378f52da5d4";
        hash = "sha256-Pe7OAtocaH18FhpSwz3NNZLrBI9BS1rfOehq2UVmu6g=";
      };
    }
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

    postPatch = ''
      cat > build.zig.zon <<EOF
      .{
          .name = .vszip,
          .version = "13.0.0",
          .paths = .{""},
          .fingerprint = 0x7466a154dbe09310,
          .minimum_zig_version = "0.15.2",
          .dependencies = .{
              .vapoursynth = .{
                  .url = "https://github.com/dnjulek/vapoursynth-zig/archive/8e93fe3433bb977135f81040bb59d964c58a1cb9.tar.gz",
                  .hash = "vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2",
              },
              .zigimg = .{
                  .url = "https://github.com/zigimg/zigimg/archive/362cdd6bce109f7bc674be134cddd378f52da5d4.tar.gz",
                  .hash = "zigimg-0.1.0-8_eo2jNrFQD4mu3EAUkfQRmCkyfprdIXc8JQ6uyxhjSQ",
              },
          },
      }
      EOF

      mkdir -p /build/zig-cache/p
      ln -s ${zigDeps}/* /build/zig-cache/p/
    '';

    zigBuildFlags = [
      "-Doptimize=ReleaseFast"
      "--global-cache-dir"
      "/build/zig-cache"
    ];

    meta = {
      description = "VapourSynth zip/vszip plugin";
      homepage = "https://github.com/dnjulek/vapoursynth-zip";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  })
