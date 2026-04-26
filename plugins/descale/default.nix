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
  python = python3.withPackages (ps: [ ps.vapoursynth ]);
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
      python
    ];

    buildInputs = [
      vapoursynth
    ];

    preConfigure = ''
      export PYTHON=${python}/bin/python3
    '';

    postPatch = ''
      substituteInPlace meson.build \
          --replace "vs.get_pkgconfig_variable('libdir')" "get_option('libdir')"
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
