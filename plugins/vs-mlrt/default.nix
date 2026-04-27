{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  p7zip,
  cmake,
  vapoursynth,
  python3,
  vsncnn,
  # vsort,
  # vsov,
  # vstrt,
  # vsmigx,
}:
stdenv.mkDerivation rec {
  pname = "vs-mlrt";
  version = "15.16";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    sha256 = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };

  models = fetchurl {
    url = "https://github.com/AmusementClub/vs-mlrt/releases/download/v${version}/models.v${version}.7z";
    sha256 = "sha256-XkP/AtEWALNVjmwkXvRIRTl4Tk8OShEz4/IFCg84crA=";
  };

  contribModels = fetchurl {
    url = "https://github.com/AmusementClub/vs-mlrt/releases/download/v${version}/contrib-models.v${version}.7z";
    sha256 = "sha256-uxw6XJMF8yvMtHUpbiUuAuhf8n1kgeO3ZQuskbUeqwc=";
  };

  nativeBuildInputs = [
    p7zip
  ];

  buildInputs = [
    vapoursynth
    python3
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 scripts/vsmlrt.py \
      $out/${python3.sitePackages}/vsmlrt.py

    mkdir -p $out/share/vs-mlrt/models
    7z x ${models}       -o$out/share/vs-mlrt/models
    7z x ${contribModels} -o$out/share/vs-mlrt/models

    mkdir -p $out/lib/vapoursynth
    for pkg in ${vsncnn} do 
    # ${vsort} ${vsov} ${vstrt} ${vsmigx}; 
      for lib in $pkg/lib/vapoursynth/*.so; do
        ln -s "$lib" $out/lib/vapoursynth/
      done
    done

    runHook postInstall
  '';
  
  postPatch = ''
    substituteInPlace scripts/vsmlrt.py \
      --replace \
        'models_path: str = os.path.join(plugins_path, "models")' \
        'models_path: str = "${placeholder "out"}/share/vs-mlrt/models"'
  '';
  
    meta = with lib; {
    description = "Machine learning runtimes for VapourSynth (meta package: scripts + models)";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
