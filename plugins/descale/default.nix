{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  python3,
}:

# required to make python.buildEnv use descale’s python module
let
  python3Env = python3.withPackages (ps: [ ps.vapoursynth ]);
in
python3.pkgs.toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "vapoursynth-descale";
    version = "r12";

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = finalAttrs.pname;
      rev = "0d03b30194ea8588fcc345fcd84a6a1201ee0f34";
      sha256 = "sha256-cvd9anNeNM0dktZf85BgLYgLrpnfxqpkYWeGhc3A7wI=";
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

    postPatch = ''
      substituteInPlace meson.build \
        --replace-fail \
        "import('python').find_installation(pure: false)" \
        "import('python').find_installation('${python3Env}/bin/python3', pure: false)"
      substituteInPlace meson.build \
        --replace-fail \
        "r = run_command(
        py,
        '-c',
        'import vapoursynth as vs; print(vs.get_include())',
        check: true,
    )
    inc_vs = include_directories(r.stdout().strip())" \
        "inc_vs = include_directories('${vapoursynth}/include')"
    '';

    postInstall = ''
      install -D ../descale.py $out/${python3.sitePackages}/descale.py
    '';

    meta = with lib; {
      description = "VapourSynth plugin to undo upscaling";
      homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-descale";
      license = licenses.mit;
      maintainers = with maintainers; [ humanlyhuman ];
      platforms = platforms.all;
    };
  })
)
