{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pkg-config,
  vapoursynth,
  python,
  fetchgit,
  hatchling,
  zig_0_15,
}: let
  vsynth-src = fetchgit {
    url = "https://github.com/dnjulek/vapoursynth-zig";
    rev = "8e93fe3433bb977135f81040bb59d964c58a1cb9";
    hash = "sha256-tcBr4q7/8u/8xmBO2dbtExi3n5j006nh6/fniO37UK4=";
  };
  zigsv-src = fetchgit {
    url = "https://github.com/ritalin/zig-set-version";
    rev = "14c65c533cd85b02ed5a7cff35398a413b9b6a7b";
    hash = "sha256-hoQLPYvDJfHpBDUKUtxRZjOVEKmHRK2EQm+R23DPxn0=";
  };
in
  buildPythonPackage rec {
    pname = "manipmv";
    version = "1.3.0";
    pyproject = true;
    build-system = [
      hatchling
    ];

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

    buildInputs = [
      vapoursynth
    ];
    preBuild = ''
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR/p"
      ln -s ${vsynth-src} "$ZIG_GLOBAL_CACHE_DIR/p/vapoursynth-4.0.0-jLYMQ799AgCA8sL5lgewK9acIrAKjs-ByT2pdKI5dHq2"
      ln -s ${zigsv-src} "$ZIG_GLOBAL_CACHE_DIR/p/zig_set_version-0.2.1-VcSFV0FkAAAr6WCGYZwuup5pWg62naL4FPuFiI0D5--P"
    '';
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail ', "ziglang==0.15.2"' " " \
        --replace-fail '"VapourSynth>=74",' " "

      substituteInPlace hatch_build.py \
        --replace-fail 'sys.executable, "-m", "ziglang"' '"${zig_0_15}/bin/zig"'
    '';
    postInstall = ''
      mkdir -p $out/lib/vapoursynth

      for f in $out/${python.sitePackages}/vapoursynth/plugins/manipmv/*.so; do
        [ -e "$f" ] && cp "$f" $out/lib/vapoursynth/
      done
    '';
    meta = with lib; {
      description = "Manipulate Motion Vectors plugin for VapourSynth";
      homepage = "https://github.com/Mikewando/manipulate-motion-vectors";
      license = licenses.lgpl21;
      maintainers = with maintainers; [humanlyhuman];
      platforms = platforms.linux;
    };
  }
