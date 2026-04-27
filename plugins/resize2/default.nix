{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  python3,
}: let
  python3Env = python3.withPackages (ps: [
    ps.vapoursynth
  ]);
in
  python3.pkgs.toPythonModule (
    stdenv.mkDerivation (finalAttrs: {
      pname = "vapoursynth-resize2";
      version = "0.4.2";

      src = fetchFromGitHub {
        owner = "Jaded-Encoding-Thaumaturgy";
        repo = finalAttrs.pname;
        rev = "v${finalAttrs.version}";
        hash = "sha256-oOfDYHBZZ3JEYrbeiwSDNAaua7hlC61lYJOTqB6I7/Q=";
      };

      nativeBuildInputs = [
        meson
        ninja
        pkg-config
        python3Env
      ];

      buildInputs = [
        vapoursynth
      ];
      mesonFlags = ["--wrap-mode=forcefallback"];
      postPatch = ''
        substituteInPlace meson.build \
          --replace-fail \
          "py = import('python').find_installation()" \
          "py = import('python').find_installation('${python3Env}/bin/python3')"

        substituteInPlace meson.build \
          --replace-fail \
          "vapoursynth_include_command = run_command(" \
          "# patched out by nixpkgs\n# vapoursynth_include_command = run_command("

        substituteInPlace meson.build \
          --replace-fail \
          "vapoursynth_include = include_directories(vapoursynth_include_command.stdout().strip())" \
          "vapoursynth_include = include_directories('${vapoursynth}/include/vapoursynth')"
      '';

      postInstall = ''
        mkdir -p $out/lib/vapoursynth
        ln -s \
          $out/${python3.sitePackages}/vapoursynth/plugins/resize2${stdenv.hostPlatform.extensions.sharedLibrary} \
          $out/lib/vapoursynth/resize2${stdenv.hostPlatform.extensions.sharedLibrary}
      '';

      meta = with lib; {
        description = "resize2 plugin for VapourSynth with blur support";
        homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-resize2";
        license = licenses.lgpl21Only;
        platforms = platforms.all;
      };
    })
  )
