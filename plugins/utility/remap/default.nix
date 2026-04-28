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
  pname = "remap";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Km8VSXCia1o+9dYr4Qqmhk5j1D6xpiVHhqMHnun2Jc4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "Vapoursynth port of RemapFrames";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/Vapoursynth-RemapFrames";
    license = licenses.bsd2;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.linux;
  };
}
