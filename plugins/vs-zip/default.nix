{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  vapoursynth,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-plugin-vszip";
  version = "R13";

  src = fetchFromGitHub {
    owner = "dnjulek";
    repo = "vapoursynth-zip";
    rev = finalAttrs.version;
    hash = "sha256-k+HfMTn9FLUOCBHFAsSiqHHFF9Q4hUqJpfainN/e2Gc=";
  };

  zigDeps = fetchZigDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-...";
  };

  nativeBuildInputs = [ zig.hook ];
  buildInputs = [ vapoursynth ];

  zigBuildFlags = [ "-Doptimize=ReleaseFast" ];

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
