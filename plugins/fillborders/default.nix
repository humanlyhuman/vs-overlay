{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-fillborders";
  version = "2";

  src = fetchFromGitHub {
    owner = "dubhatervapoursynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zGVrqnzQ8ezN9eehwh5/eMdUNMmuS3PXvQ2wLL3Remg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ vapoursynth ];

  postInstall = ''
    # it installs the library in the wrong directory
    mkdir $out/lib/vapoursynth
    mv $out/lib/libfillborders.* $out/lib/vapoursynth/
  '';

  meta = with lib; {
    description = "VapourSynth plugin to fill the borders of a clip";
    homepage = "https://github.com/dubhatervapoursynth/vapoursynth-fillborders";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
