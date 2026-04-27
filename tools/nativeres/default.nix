{
  lib,
  python3Packages,
  fetchFromGitHub,
  vapoursynth,
  vapoursynthPlugins,
  imagemagick,
}:
let
  python = python3Packages;
  vapoursynth-with-plugins = vapoursynth.withPlugins (
    with vapoursynthPlugins; [
      ffms2
      descale
    ]
  );
in
python.buildPythonApplication rec {
  pname = "nativeres";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "nativeres";
    rev = "nativeres/v${version}";
    hash = lib.fakeHash;
  };

  build-system = with python; [
    hatchling
    versioningit
  ];

  propagatedBuildInputs = with python; [
    jetpytools
    vsjetengine
    vsjetpack
    typer
    rich
    pyside6
    numpy
    scipy
    vapoursynth-with-plugins
  ];

  nativeCheckInputs = [
    imagemagick
  ];

  doCheck = false;
  checkPhase = ''
    runHook preCheck
    convert -size 1280x720 canvas: +noise Random test.png
    $out/bin/nativeres getnative test.png \
      --dim-mode height \
      --min 699 \
      --max 700
    $out/bin/nativeres getscaler test.png 700
    $out/bin/nativeres getfreq test.png
    runHook postCheck
  '';

  pythonImportsCheck = [
    "nativeres"
  ];

  meta = {
    description = "Descale analysis tools for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/nativeres";
    changelog = "https://github.com/Jaded-Encoding-Thaumaturgy/nativeres/releases/tag/nativeres%2Fv${version}";  # fix: tag format
    license = lib.licenses.mit;
    mainProgram = "nativeres";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ humanlyhuman ];
  };
}
