{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  meson-python,
  meson,
  ninja,
  packaging,
  pkg-config,
  vapoursynth,
  git,
  autoreconfHook,
  fetchgit,
}: let
zimg_patched = stdenv.mkDerivation rec {
  pname = "zimg_patched";
  version = "unstable-2026-04-27";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://github.com/sekrit-twc/zimg.git";
    rev = "refs/heads/master";
    hash = "sha256-MRWQ6tM1LEL1C4le7Ha7CmiA/V9hXrwp27KgJiHxSes=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  mesonFlags = [ "-Ddefault_library=static" ];

  dontUseNinjaInstall = true;

  postBuild = ''
    mkdir -p $out/lib
    mkdir -p $dev/include/graphengine
    mkdir -p $dev/include/zimg
    mkdir -p $dev/lib/pkgconfig
    find . -name "libzimg.a" -exec cp {} $out/lib/ \;
    cp -r $src/graphengine/include/graphengine/. $dev/include/graphengine/
    cp -r $src/src/zimg/common     $dev/include/zimg/
    cp -r $src/src/zimg/graph      $dev/include/zimg/
    cp -r $src/src/zimg/depth      $dev/include/zimg/
    cp -r $src/src/zimg/colorspace $dev/include/zimg/
    cp -r $src/src/zimg/resize     $dev/include/zimg/
    cp -r $src/src/zimg/api        $dev/include/zimg/
    cat > $dev/lib/pkgconfig/zimg_patched.pc <<EOF
    Name: zimg_patched
    Description: Patched zimg
    Version: 3.0.6
    Libs: -L$out/lib -lzimg
    Cflags: -I$dev/include
    EOF
  '';

  meta = with lib; {
    description = "Patched zimg fork required by vapoursynth-resize2";
    homepage = "https://github.com/sekrit-twc/zimg";
    license = licenses.wtfpl;
    platforms = platforms.unix;
  };
};
in
  buildPythonPackage rec {
    pname = "vapoursynth-resize2";
    version = "0.4.2";

    pyproject = true;

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = pname;
      rev = version;
      hash = "sha256-oOfDYHBZZ3JEYrbeiwSDNAaua7hlC61lYJOTqB6I7/Q=";
    };

    nativeBuildInputs = [
      pkg-config
      vapoursynth
      zimg_patched
    ];

    build-system = [
      git
      meson-python
      meson
      ninja
      packaging
    ];

    buildInputs = [
      vapoursynth
      zimg_patched
    ];

    propagatedBuildInputs = [
      vapoursynth
    ];

    dontCheckRuntimeDeps = true;

    postPatch = ''
          python3 <<'EOF'
      import re
      p = open("pyproject.toml").read()
      p = re.sub(r'"vapoursynth>=.*?",?', "", p)
      p = re.sub(r'"ninja==.*?",?', '"ninja",', p)
      open("pyproject.toml", "w").write(p)
      EOF

          substituteInPlace meson.build \
            --replace-fail \
            "import vapoursynth as vs; print(vs.get_include())" \
            "print(\"${vapoursynth}/include/vapoursynth\")"
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth

      ln -s \
        $out/lib/python*/site-packages/vapoursynth/plugins/resize2/libresize2${stdenv.hostPlatform.extensions.sharedLibrary} \
        $out/lib/vapoursynth/libresize2${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

    meta = with lib; {
      description = "resize2 plugin for VapourSynth with blur support";
      homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-resize2";
      license = licenses.lgpl21Only;
      platforms = platforms.all;
    };
  }
