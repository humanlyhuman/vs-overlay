{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # Python build backend
  hatchling,
  # Native build tools
  meson,
  ninja,
  pkg-config,
  # Runtime / Python deps
  vapoursynth,
  # C++ deps
  boost,
  opencl-headers,
  ocl-icd,
}:
buildPythonPackage rec {
  pname = "vapoursynth-sneedif";
  version = "4.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-SNEEDIF";
    rev = "R${version}";
    hash = "sha256-LmSANVwS6g5575Xsms9cwg+9SikNObZ/kgdh+sh/PAw=";
  };

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    opencl-headers
    ocl-icd
  ];

  dependencies = [
    vapoursynth
  ];

  postPatch = ''
      python3 -c "
    import re

    content = open('meson.build').read()

    content = re.sub(
        r'r = run_command\\(.*?check: true,\\s*\\)',
        \"\",
        content,
        flags=re.DOTALL
    )

    content = re.sub(
        r'incdir = include_directories\\(.*?\\n\\)',
        \"\",
        content,
        flags=re.DOTALL
    )

    content = content.replace(
        'include_directories: incdir,',
        'dependencies: vapoursynth_dep,'
    )

    content = content.replace(
        \"py.get_install_dir() / 'vapoursynth/plugins'\",
        \"'${placeholder "out"}/lib/vapoursynth'\"
    )

    open('meson.build', 'w').write(content)
    "

      python3 -c "
    content = open('pyproject.toml').read()

    content = '\\n'.join(
        line for line in content.splitlines()
        if 'vapoursynth>=74' not in line
    ) + '\\n'

    open('pyproject.toml', 'w').write(content)
    "
  '';

  doCheck = false;
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "Setsugen No Ensemble of Edge Directed Interpolation Functions for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF";
    license = licenses.wtfpl;
    platforms = platforms.linux;
    maintainers = [];
  };
}
