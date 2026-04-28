{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "fmtconv";
  version = "31";

  src = fetchFromGitLab {
    owner = "EleonoreMizo";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-SyctXpfhIOyx1R9XUi2DVlSRHYeODmYxs/4ZzCp1rWo=";
  };

  preAutoreconf = "cd build/unix";

  configureFlags = ["--libdir=$(out)/lib/vapoursynth"];

  nativeBuildInputs = [autoreconfHook];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "Format conversion tools for VapourSynth";
    homepage = "https://gitlab.com/EleonoreMizo/fmtconv/";
    license = licenses.wtfpl;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
