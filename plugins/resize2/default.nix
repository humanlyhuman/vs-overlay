{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  meson,
  ninja,
  packaging,
  pkg-config,
  vapoursynth,
}:
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
  ];

  build-system = [
    hatchling
    meson
    ninja
    packaging
    vapoursynth
  ];

  buildInputs = [
    vapoursynth
  ];

  dependencies = [
    vapoursynth
  ];

  dontCheckRuntimeDeps = true;

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
      "py = import('python').find_installation()" \
      "py = import('python').find_installation(pure: false)"

    substituteInPlace meson.build \
      --replace-fail \
      "vapoursynth_include_command = run_command(" \
      "# disabled by nix"

    substituteInPlace meson.build \
      --replace-fail \
      "vapoursynth_include = include_directories(vapoursynth_include_command.stdout().strip())" \
      "deps += dependency('vapoursynth')"
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
