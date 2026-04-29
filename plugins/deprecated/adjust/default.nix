{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  python,
  vapoursynth,
}:
buildPythonPackage rec {
  pname = "adjust";
  version = "1";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = "vapoursynth-adjust";
    rev = "v${version}";
    hash = "sha256-Cn05tduFqXGPJeRbOmbohtrTmdi/NGfkJktShA7UpnE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dubhatervapoursynth/vapoursynth-adjust/commit/a3af7cb57cb37747b0667346375536e65b1fed17.patch";
      hash = "sha256-0N7oSsYj0/F0PwswI+1hgM7Gu1KKWdlJOuYf24wlEUw=";
    })
  ];

  format = "other";

  installPhase = ''
    install -D adjust.py $out/${python.sitePackages}/adjust.py
  '';

  checkInputs = [vapoursynth];
  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';
  pythonImportsCheck = ["adjust"];

  meta = with lib; {
    description = "A VapourSynth port of the Avisynth filter Tweak";
    homepage = "https://github.com/dubhatervapoursynth/vapoursynth-adjust";
    license = licenses.wtfpl;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
