{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  meson,
  ninja,
  packaging,
  pkg-config,
  vapoursynth,
  boost,
  opencl-headers,
  ocl-icd,
}:
buildPythonPackage rec {
  pname = "knlmeanscl";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-knlmeanscl";
    rev = "v${version}";
    hash = "sha256-mFOcKqUzDhWu7yiqiHReTFSzb5jA/YDPb7IOASX9JUo=";
  };

  build-system = [hatchling meson ninja packaging];

  nativeBuildInputs = [pkg-config];

  buildInputs = [
    vapoursynth
    boost
    opencl-headers
    ocl-icd
  ];

  dependencies = [vapoursynth];
  postPatch = ''
      sed -i '/vapoursynth>=74/d' pyproject.toml

      python3 - <<EOF
    from pathlib import Path
    p = Path("meson.build")
    s = p.read_text()

    old = """if enable_vs
      py = import('python').find_installation(pure: false)

      r = run_command(
        py,
        '-c', 'import vapoursynth as vs; print(vs.get_include())',
        check: true,
      )
      lib_inc += include_directories(r.stdout().strip())
      lib_src += ['KNLMeansCL/NLMVapoursynth.cpp', 'KNLMeansCL/NLMVapoursynth.h']
    endif
    """

    new = """if enable_vs
      lib_inc += include_directories('${vapoursynth}/include/vapoursynth')
      lib_src += ['KNLMeansCL/NLMVapoursynth.cpp', 'KNLMeansCL/NLMVapoursynth.h']
    endif
    """

    s = s.replace(old, new)
    s = s.replace(
        "install: false,",
        "install: true,\n  install_dir: get_option('libdir') / 'vapoursynth',"
    )

    p.write_text(s)
    EOF
  '';
  postInstall = ''
    mkdir -p $out/lib/vapoursynth

    ln -s \
      $out/lib/python*/site-packages/vapoursynth/plugins/libKNLMeansCL.so \
      $out/lib/vapoursynth/libKNLMeansCL.so
  '';
  doCheck = false;

  meta = with lib; {
    description = "Optimized OpenCL implementation of Non-local means denoising";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-knlmeanscl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
