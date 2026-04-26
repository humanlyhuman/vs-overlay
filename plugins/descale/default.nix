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
python3.pkgs.toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "vapoursynth-descale";
    version = "r12";

    src = fetchFromGitHub {
      owner = "Jaded-Encoding-Thaumaturgy";
      repo = finalAttrs.pname;
      rev = "master";
      sha256 = "sha256-nTAv/aQYA4DXmlOLvpuc6lr3IR0beEx8FqVid11H+Qw=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];
    buildInputs = [ vapoursynth ];

    postPatch = ''
      substituteInPlace meson.build \
          --replace "vs.get_pkgconfig_variable('libdir')" "get_option('libdir')"
    '';

    postInstall = ''
      install -D ../descale.py $out/${python3.sitePackages}/descale.py
    '';

    meta = with lib; {
      description = "VapourSynth plugin to undo upscaling";
      homepage = "https://github.com/Irrational-Encoding-Wizardry/vapoursynth-descale";
      license = licenses.wtfpl;
      maintainers = with maintainers; [ sbruder ];
      platforms = platforms.all;
    };
  })
)
