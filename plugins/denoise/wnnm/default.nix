{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
  hatchling,
  buildPythonPackage,
  hatch-vcs,
}:
buildPythonPackage rec {
  pname = "wnnm";
  version = "3";

  pyproject = true;

  build-system = [
    hatchling
    hatch-vcs
  ];
  nativeBuildInputs = [vapoursynth];
  buildInputs = [vapoursynth];

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "VapourSynth-WNNM";
    rev = "v${version}";
    hash = "sha256-fPtHaDrG1Ku1/Uv0Bh3hUfqbOEyfnhFVFblspRhHqlE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail '"vapoursynth>=74"' ' '
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    find $out -name '*.so' -path '*/vapoursynth/plugins/*' \
      -exec ln -s {} $out/lib/vapoursynth/ \;
  '';

  meta = with lib; {
    description = "Weighted Nuclear Norm Minimization Denoiser for VapourSynth.";
    homepage = "https://github.com/AmusementClub/VapourSynth-WNNM";
    license = licenses.mit;
  };
}
