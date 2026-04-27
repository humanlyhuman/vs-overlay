{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  buildPythonPackage,
  meson-python,
  meson,
  ninja,
  pkg-config,
  packaging,
  python,
  vapoursynth,
}: let
  zimg_patched = stdenv.mkDerivation rec {
    pname = "zimg_patched";
    version = "unstable-2026-04-27";

    outputs = ["out" "dev"];
    outputDev = "dev";
    src = fetchgit {
      url = "https://github.com/sekrit-twc/zimg.git";
      rev = "df9c1472b9541d0e79c8d02dae37fdf12f189ec2";
      hash = "sha256-8PDjDlG3Bso3IQUwjrGqZZR0VtCiVLHB77Ul6n4I+XM=";
      fetchSubmodules = true;
    };
    patches = [./0001.patch];
    mesonFlags = ["-Db_lto=false"];
    nativeBuildInputs = [meson ninja pkg-config python];
    buildInputs = [vapoursynth];
    
    postPatch = ''
      substituteInPlace meson.build \
        --replace-fail "static_library('zimg'" "library('zimg'"
    '';

    buildPhase = ''
      ninja -C build
    '';
    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $dev/include
      mkdir -p $dev/lib/pkgconfig

      ninja -C build install
      cp -r graphengine/include/graphengine $dev/include/
      mkdir -p $dev/include/zimg
      cp -r src/zimg/api        $dev/include/zimg/
      cp -r src/zimg/common     $dev/include/zimg/
      cp -r src/zimg/colorspace $dev/include/zimg/
      cp -r src/zimg/depth      $dev/include/zimg/
      cp -r src/zimg/graph      $dev/include/zimg/
      cp -r src/zimg/resize     $dev/include/zimg/
      cp -r src/zimg/unresize   $dev/include/zimg/
      cp -r graphengine/include/graphengine $dev/include/

      cat > $dev/lib/pkgconfig/zimg_patched.pc <<EOF
      prefix=$out
      exec_prefix=$out
      libdir=$out/lib
      includedir=$dev/include
      Name: zimg_patched
      Description: patched zimg static library
      Version: ${version}
      Libs: -L$out/lib -lzimg
      Libs.private: -lstdc++
      Cflags: -I$dev/include -I$dev/include/zimg
      EOF
    '';
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
      meson-python
      meson
      ninja
      pkg-config
      python
      packaging
      zimg_patched.dev
    ];

    buildInputs = [vapoursynth zimg_patched];
    propagatedBuildInputs = [vapoursynth];

    dontCheckRuntimeDeps = true;
    mesonFlags = ["-Db_lto=false"];
    postPatch = ''
      python <<EOF
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
      plugin="$(find $out/lib -name 'libresize2${stdenv.hostPlatform.extensions.sharedLibrary}' | head -n1)"
      ln -s "$plugin" $out/lib/vapoursynth/libresize2${stdenv.hostPlatform.extensions.sharedLibrary}
    '';
  }
