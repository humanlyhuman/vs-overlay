{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  python,
  python3Packages,
  stdenv,
}:

let
  pythonEnv = python.withPackages (ps: [
    ps.vapoursynth
  ]);
in

python.pkgs.toPythonModule (
  meson.buildMesonPackage rec {
    pname = "vapoursynth-resize2";
    version = "0.4.2";

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = pname;
      rev = version;
      hash = "sha256-oOfDYHBZZ3JEYrbeiwSDNAaua7hlC61lYJOTqB6I7/Q=";
    };

    nativeBuildInputs = [
      pkg-config
      pythonEnv
    ];

    buildInputs = [
      vapoursynth
    ];

    mesonFlags = [
      "--wrap-mode=forcefallback"
    ];

    postPatch = ''
      substituteInPlace meson.build \
        --replace-fail \
        "py = import('python').find_installation()" \
        "py = import('python').find_installation('${pythonEnv}/bin/python')"

      substituteInPlace meson.build \
        --replace-fail \
        "vapoursynth_include = include_directories(vapoursynth_include_command.stdout().strip())" \
        "vapoursynth_include = include_directories('${vapoursynth}/include/vapoursynth')"
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s \
        $out/${python.sitePackages}/vapoursynth/plugins/resize2${stdenv.hostPlatform.extensions.sharedLibrary} \
        $out/lib/vapoursynth/resize2${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

    meta = with lib; {
      description = "resize2 plugin for VapourSynth with blur support";
      homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-resize2";
      license = licenses.lgpl21Only;
      platforms = platforms.all;
    };
  }
)
