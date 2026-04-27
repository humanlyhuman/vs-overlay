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

    nativeBuildInputs = [meson ninja pkg-config python];
    buildInputs = [vapoursynth];

    postPatch = ''
      cat > meson.build <<EOF
      project('zimg', 'cpp',
        default_options : ['c_std=c89', 'cpp_std=c++17'],
        meson_version : '>=0.51.0',
        version : '3.0.5'
      )

      vapoursynth_include = include_directories('${vapoursynth}/include/vapoursynth')

      incl_dirs = include_directories(
        'graphengine/include',
        'src/zimg',
        'src',
      )

      sources = files(
        'graphengine/graphengine/cpuinfo.cpp',
        'graphengine/graphengine/graph.cpp',
        'graphengine/graphengine/node.cpp',
        'src/zimg/api/zimg.cpp',
        'src/zimg/colorspace/colorspace.cpp',
        'src/zimg/common/cpuinfo.cpp',
        'src/zimg/common/libm_wrapper.cpp',
        'src/zimg/common/matrix.cpp',
        'src/zimg/depth/depth.cpp',
        'src/zimg/depth/depth_convert.cpp',
        'src/zimg/depth/dither.cpp',
        'src/zimg/graph/filter_base.cpp',
        'src/zimg/graph/filtergraph.cpp',
        'src/zimg/graph/graphbuilder.cpp',
        'src/zimg/graph/graphengine_except.cpp',
        'src/zimg/graph/simple_filters.cpp',
        'src/zimg/resize/filter.cpp',
        'src/zimg/resize/resize.cpp',
        'src/zimg/resize/resize_impl.cpp',
        'src/zimg/unresize/bilinear.cpp',
        'src/zimg/unresize/unresize.cpp',
        'src/zimg/unresize/unresize_impl.cpp'
      )

      zimg = static_library(
        'zimg',
        sources,
        include_directories: [vapoursynth_include, incl_dirs],
        dependencies: [dependency('threads')],
        gnu_symbol_visibility: 'hidden'
      )

      zimg_patched_dep = declare_dependency(
        link_with: zimg,
        include_directories: [vapoursynth_include, incl_dirs]
      )
      EOF
    '';

    configurePhase = ''
      meson setup build \
        --prefix=$out \
        --libdir=lib \
        --includedir=include \
        -Ddefault_library=static
    '';

    buildPhase = ''
      ninja -C build
    '';

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $dev/include
      mkdir -p $dev/lib/pkgconfig

      cp build/libzimg.a $out/lib/

      cp -r graphengine/include/graphengine $dev/include/
      mkdir -p $dev/include/zimg
      cp -r src/zimg/api        $dev/include/zimg/
      cp -r src/zimg/common     $dev/include/zimg/
      cp -r src/zimg/colorspace $dev/include/zimg/
      cp -r src/zimg/depth      $dev/include/zimg/
      cp -r src/zimg/graph      $dev/include/zimg/
      cp -r src/zimg/resize     $dev/include/zimg/
      cp -r src/zimg/unresize   $dev/include/zimg/

      cat > $dev/lib/pkgconfig/zimg_patched.pc <<EOF
      prefix=$out
      exec_prefix=$out
      libdir=$out/lib
      includedir=$dev/include
      Name: zimg_patched
      Description: patched zimg static library
      Version=${version}
      Libs: -L$out/lib -lzimg
      Cflags: -I$dev/include
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
