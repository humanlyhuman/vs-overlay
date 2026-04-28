{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  vapoursynth,
}: let
  vapoursynth-zig = fetchFromGitHub {
    owner = "dnjulek";
    repo = "vapoursynth-zig";
    rev = "8e93fe3433bb977135f81040bb59d964c58a1cb9";
    hash = "sha256-tcBr4q7/8u/8xmBO2dbtExi3n5j006nh6/fniO37UK4=";
  };
  zigimg = fetchFromGitHub {
    owner = "zigimg";
    repo = "zigimg";
    rev = "362cdd6bce109f7bc674be134cddd378f52da5d4";
    hash = "sha256-Pe7OAtocaH18FhpSwz3NNZLrBI9BS1rfOehq2UVmu6g=";
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
                  .url = "path:${vapoursynth-zig}",
              },
              .zigimg = .{
                  .url = "path:${zigimg}",
              },
          },
      }
      EOF
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      mv $out/lib/libvszip${stdenv.hostPlatform.extensions.sharedLibrary} \
         $out/lib/vapoursynth/
    '';

    meta = {
      description = "VapourSynth zip/vszip plugin";
      homepage = "https://github.com/dnjulek/vapoursynth-zip";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  })
