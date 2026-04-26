{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
  ncnn
}:

stdenv.mkDerivation rec {
  pname = "vsncnn";
  version = "15.16";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    sha256 = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };

  sourceRoot = "source/vsncnn";

  patches = [
    ./no-git-call-in-cmake.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vapoursynth
    ncnn
  ];

  cmakeFlags = [
    "-DVCS_TAG=v${version}"
    "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libvsncnn.so $out/lib/vapoursynth/
  '';

  meta = with lib; {
    description = "NCNN-based GPU Runtime";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aidalgol ];
    platforms = platforms.all;
  };
}
