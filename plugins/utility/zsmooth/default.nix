{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pkg-config,
  vapoursynth,
  python,
  hatchling,
  zig_0_15,
}: let
  vsynth-src = fetchFromGitHub {
    owner = "dnjulek";
    repo = "vapoursynth-zig";
    rev = "a94152c87e4242a582ec5f30f4d4e890c14e2233";
    hash = "sha256-ZhWDmdq15NMBZe9LxM+AhjAT78yI0xNz+My1UOF9mYc=";
  };
in
  buildPythonPackage rec {
    pname = "zsmooth";
    version = "0.15.5";
    pyproject = true;
    build-system = [
      hatchling
    ];

    src = fetchFromGitHub {
      owner = "adworacz";
      repo = "zsmooth";
      rev = "3e394359648cc9ed0bbb38131113eba11231cd29";
      hash = "sha256-/ESD6hrphuRd0QJEXWuC6a5VcYqMbN0DnUBxM1rcY1Q=";
    };

    nativeBuildInputs = [
      zig_0_15
      pkg-config
    ];

    buildInputs = [
      vapoursynth
    ];
    preBuild = ''
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"
      ln -s ${vsynth-src} "$ZIG_GLOBAL_CACHE_DIR/p/vapoursynth-4.0.0-jLYMQw95AgBWLJymsYybHIFxNu7d6shoYn8y8WZfH8T3"
    '';
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail ', "ziglang==0.15.2"' " " \
        --replace-fail '"vapoursynth>=74"' " "

      substituteInPlace hatch_build.py \
        --replace-fail '"python-zig"' '"${zig_0_15}/bin/zig"'
    ''; 
    postInstall = ''
      mkdir -p $out/lib/vapoursynth

      for f in $out/${python.sitePackages}/vapoursynth/plugins/zsmooth/*.so; do
        [ -e "$f" ] && cp "$f" $out/lib/vapoursynth/
      done
    '';
    meta = with lib; {
      description = "Manipulate Motion Vectors plugin for VapourSynth";
      homepage = "https://github.com/adworacz/zsmooth";
      license = licenses.mit;
      maintainers = with maintainers; [humanlyhuman];
      platforms = platforms.linux;
    };
  }
