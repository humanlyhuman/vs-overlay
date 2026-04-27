{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  pkg-config,
  vapoursynth,
  boost,
  opencl-headers,
  ocl-icd,
}:

stdenv.mkDerivation rec {
  pname = "knlmeanscl";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-knlmeanscl";
    rev = "v${version}";
    sha256 = "sha256-mFOcKqUzDhWu7yiqiHReTFSzb5jA/YDPb7IOASX9JUo=";
  };

  nativeBuildInputs = [
    which
    pkg-config
  ];
  buildInputs = [
    vapoursynth
    boost
    opencl-headers
    ocl-icd
  ];

  configureFlags = [
    "--install=${placeholder "out"}/lib/vapoursynth"
  ];

  preInstall = ''
    mkdir -p $out/lib/vapoursynth
  '';

  meta = with lib; {
    description = "An optimized OpenCL implementation of the Non-local means de-noising algorithm";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-knlmeanscl";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
