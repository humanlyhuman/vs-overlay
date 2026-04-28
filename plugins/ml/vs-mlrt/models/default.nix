{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  p7zip,
  vapoursynth,
  python3,
  vapoursynthPlugins,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "vs-mlrt";
  version = "15.16";
  format = "other";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    hash = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };

  models = fetchurl {
    url = "https://github.com/AmusementClub/vs-mlrt/releases/download/v${version}/models.v${version}.7z";
    hash = "sha256-1OqowcRFkIIYWp4aLFTX4sd2q+6mrvau4MuPbBUd+wI=";
  };

  contribModels = fetchurl {
    url = "https://github.com/AmusementClub/vs-mlrt/releases/download/v${version}/contrib-models.v${version}.7z";
    hash = "sha256-Im515f+jHfcqxYR43LIv52bisiAMHutVHsKGEh8u43Y=";
  };

  nativeBuildInputs = [p7zip];
  buildInputs = [vapoursynth];

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace scripts/vsmlrt.py \
      --replace-fail \
        'models_path: str = os.path.join(plugins_path, "models")' \
        'models_path: str = "${placeholder "out"}/share/vs-mlrt/models"'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 scripts/vsmlrt.py \
      $out/${python3.sitePackages}/vsmlrt.py

    mkdir -p $out/share/vs-mlrt
    7z x ${models}        -o$out/share/vs-mlrt
    7z x ${contribModels} -o$out/share/vs-mlrt

    mkdir -p $out/lib/vapoursynth
    for pkg in ${vapoursynthPlugins.vsncnn}; do
      for lib in $pkg/lib/vapoursynth/*.so; do
        ln -s "$lib" $out/lib/vapoursynth/
      done
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Machine learning runtimes for VapourSynth (meta package: scripts + models)";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.unfree;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
