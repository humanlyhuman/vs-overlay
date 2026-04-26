{
  lib,
  stdenv,
  fetchFromGitHub, # still usable for Codeberg via fetchgit if preferred
  fetchgit,
  hostPlatform,
  rocmPackages,
  vapoursynth,
}:

stdenv.mkDerivation rec {
  pname = "vship";
  version = "5.0.1";

  src = fetchgit {
    url = "https://codeberg.org/Line-fr/Vship.git";
    rev = "v${version}";
    sha256 = "sha256-JkWw1dTBb47CBLG3fGXtqHTEwbiX9IDwKHroJtY9s+A=";
  };

  nativeBuildInputs = [
    rocmPackages.clr
  ];

  buildInputs =
    (with rocmPackages; [
      clr
      rocm-comgr
      rocm-runtime
    ])
    ++ [
      vapoursynth
    ];

  postPatch = ''
    rm -rf include
  '';

  buildPhase = ''
    echo $PATH
    hipcc src/main.cpp \
      -I "${vapoursynth}/include/vapoursynth" \
      --offload-arch=gfx1100,gfx1101,gfx1102,gfx1030,gfx1031,gfx1032,gfx906,gfx801,gfx802,gfx803 \
      -Wno-unused-result -Wno-ignored-attributes -shared -fPIC \
      -o "vship${hostPlatform.extensions.sharedLibrary}" -v
  '';

  installPhase = ''
    install -D -t "$out/lib/vapoursynth" vship${hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "GPU-accelerated VapourSynth plugin for SSIMULACRA2 & Butteraugli metrics";
    homepage = "https://codeberg.org/Line-fr/Vship";
    license = licenses.mit;
    maintainers = with maintainers; [ snaki ];
    mainProgram = "vship";
    platforms = platforms.all;
  };
}
