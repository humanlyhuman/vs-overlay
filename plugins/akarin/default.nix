{
  lib,
  stdenv,
  fetchFromGitHub,
  darwinMinVersionHook,
  buildPythonPackage,
  hatchling,
  meson,
  ninja,
  packaging,
  pkg-config,
  vapoursynth,
  libllvm,
  libxml2,
  boost,
  vapoursynth-lib ? builtins.head vapoursynth.buildInputs,
  withBoostCharconv ? stdenv.hostPlatform.isDarwin,
}:
buildPythonPackage {
  pname = "vapoursynth-akarin";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "akarin-vapoursynth-plugin";
    rev = "v1.4.0";
    hash = "sha256-g4KgEYS7s7IeJkx1ww1+2XxgkOW2uHmE6sIyDyVF6yE=";
  };

  postPatch = ''
    python3 -c "
    import re
    content = open('pyproject.toml').read()
    content = re.sub(r'\s*\"vapoursynth>=\d+\",?\n', '\n', content)
    content = content.replace('\"meson==1.11.0\"', '\"meson\"')
    content = content.replace('\"ninja==1.13.0\"', '\"ninja\"')
    open('pyproject.toml', 'w').write(content)
    "
        substituteInPlace meson.build \
          --replace-fail \
            "py = import('python').find_installation(pure: false)

    r = run_command(
      py,
      '-c',
      'import vapoursynth as vs; print(vs.get_include())',
      check: true,
    )
    inc_vs = include_directories(r.stdout().strip())
    incdir += inc_vs" \
            "deps += dependency('vapoursynth')"
  '';
  dontCheckRuntimeDeps = true;
  nativeBuildInputs = [
    libllvm.dev
    libxml2.dev
    pkg-config
    vapoursynth
  ];

  build-system = [
    hatchling
    meson
    ninja
    packaging
    vapoursynth
  ];
  postInstall = ''
    mkdir -p $out/lib/vapoursynth
  
    ln -s \
      $out/lib/python*/site-packages/vapoursynth/plugins/akarin/libakarin.so \
      $out/lib/vapoursynth/libakarin.so
  '';
  env.MESON_ARGS = lib.optionalString withBoostCharconv "-Dboost-charconv=true";

  buildInputs =
    [
      libllvm
      libxml2.out
      vapoursynth-lib
    ]
    ++ lib.optional withBoostCharconv boost
    ++ lib.optional (stdenv.hostPlatform.isDarwin && !withBoostCharconv) (darwinMinVersionHook "26.0");

  dependencies = [vapoursynth];

  meta = with lib; {
    description = "Enhanced LLVM-based std.Expr and other filters for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/akarin-vapoursynth-plugin";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
