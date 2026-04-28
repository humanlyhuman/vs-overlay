{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg,
  setuptools,
  vapoursynth,
}:
buildPythonPackage rec {
  pname = "acsuite";
  version = "6.0.0";
  pyproject = true;

  build-system = [
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "OrangeChannel";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hjxKspiyM/0kVPJ9sY6ySxH8YAlrd7XPhwe7KMVz/VQ=";
  };

  postPatch = ''
    # Sets the default ffmpeg executable to nixpkgs’ ffmpeg. This still allows
    # overriding the executable by passing ffmpeg_path.
    substituteInPlace acsuite/__init__.py \
        --replace-fail 'raise FileNotFoundError("concat: ffmpeg executable not found in PATH")' 'ffmpeg_path = "${ffmpeg}/bin/ffmpeg"'

    # This does not depend on vapoursynth (since this is used from within
    # vapoursynth).
    substituteInPlace requirements.txt \
        --replace-fail "VapourSynth" ""
  '';

  nativeCheckInputs = [
    ffmpeg # the test depdends on ffmpeg from PATH
  ];
  checkInputs = [
    vapoursynth
  ];
  checkPhase = ''
    runHook preCheck

    pushd tests
    python3 test_acsuite.py
    popd

    runHook postCheck
  '';
  pythonImportsCheck = ["acsuite"];

  meta = with lib; {
    description = "An audiocutter.py replacement for VapourSynth using FFmpeg";
    homepage = "https://github.com/OrangeChannel/acsuite";
    license = licenses.unlicense;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
