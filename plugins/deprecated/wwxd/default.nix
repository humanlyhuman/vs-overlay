{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  vapoursynth,
}: let
  ext = stdenv.targetPlatform.extensions.sharedLibrary;
in
  stdenv.mkDerivation rec {
    pname = "wwxd";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "dubhatervapoursynth";
      repo = "vapoursynth-wwxd";
      rev = "v${version}";
      hash = "sha256-1cP0a31SNRRnYemzvP+/6V1UqZZZorrq+SrVmjs8KQQ=";
    };

    nativeBuildInputs = [pkg-config];
    buildInputs = [vapoursynth];

    buildPhase = ''
      gcc -o libwwxd${ext} -fPIC -shared -O2 -Wall -Wextra -Wno-unused-parameter \
          $(pkg-config --cflags vapoursynth) \
          src/wwxd.c src/detection.c
    '';

    installPhase = ''
      install -D libwwxd${ext} $out/lib/vapoursynth/libwwxd${ext}
    '';

    meta = with lib; {
      description = "Xvid-like scene change detection for VapourSynth";
      homepage = "https://github.com/dubhatervapoursynth/vapoursynth-wwxd";
      license = licenses.unfree; # no license
      maintainers = with maintainers; [];
      platforms = platforms.linux;
    };
  }
