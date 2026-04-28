{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  vapoursynth,
  hatchling,
  versioningit,
  trio ? null,
  mypy,
  pytest,
  pytest-cov,
  pytest-asyncio,
  ruff,
  vsstubs ? null,
  python,
}:
buildPythonPackage rec {
  pname = "vsjetengine";
  version = "1.2.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-jet-engine";
    rev = "v${version}";
    hash = "sha256-dkFm8PwIitv84pDsAZZe71ZUF6faP4mxXTlyW5ioJ5A=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    vapoursynth
  ];

  optional-dependencies = {
    trio = lib.optionals (trio != null) [trio];
  };

  nativeCheckInputs =
    [
      mypy
      pytest
      pytest-cov
      pytest-asyncio
      ruff
    ]
    ++ lib.optionals (trio != null) [trio]
    ++ lib.optionals (vsstubs != null && lib.versionAtLeast python.pythonVersion "3.13") [
      vsstubs
    ];

  env.VERSIONINGIT_OVERRIDE_VCS = version;

  pythonImportsCheck = [
    "vsengine"
  ];

  doCheck = false;
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "An engine for VapourSynth previewers, renderers and script analysis tools";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-jet-engine";
    license = licenses.eupl12;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
