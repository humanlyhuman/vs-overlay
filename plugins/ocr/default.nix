{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  tesseract,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "vs-ocr";
  version = "3";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = pname;
    rev = "R3";
    hash = "sha256-N2+S4YRMzjpFdRnCXGgvxU1rUKIjmHe7ylzBrB4CPL8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    tesseract
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "OCR plugin for VapourSynth";
    homepage = "https://github.com/vapoursynth/vs-ocr";
    license = licenses.mit;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.all;
  };
}
