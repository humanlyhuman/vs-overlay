{
  lib,
  stdenv,
  fetchgit,
  hostPlatform,
  rocmPackages,
  vapoursynth,
  vapoursynthPlugins
}:

stdenv.mkDerivation rec {
  pname = "vship";
  version = "5.0.1";

  src = fetchgit {
    url = "https://codeberg.org/Line-fr/Vship.git";
    rev = "v${version}";
    hash = "sha256-JkWw1dTBb47CBLG3fGXtqHTEwbiX9IDwKHroJtY9s+A=";
  };

  nativeBuildInputs = [
    rocmPackages.clr
    stdenv.cc
  ];

  buildInputs =
    (with rocmPackages; [
      clr
      rocm-comgr
      rocm-runtime
    ])
    ++ [
      vapoursynth
      vapoursynthPlugins.ffms2
    ];

  strictDeps = true;
  
  buildPhase = ''
    runHook preBuild
  
    sources="
      src/VshipLib.cpp
    "
  
    hip_sources=$(find src/HIP -name '*.cpp' -o -name '*.hip')
  
    hipcc \
      $sources \
      $hip_sources \
      -I src \
      -I include \
      -I "${vapoursynth}/include/vapoursynth" \
      -I "${vapoursynthPlugins.ffms2}/include" \
      --offload-arch=gfx1100 \
      --offload-arch=gfx1101 \
      --offload-arch=gfx1102 \
      --offload-arch=gfx1030 \
      --offload-arch=gfx1031 \
      --offload-arch=gfx1032 \
      --offload-arch=gfx906 \
      --offload-arch=gfx801 \
      --offload-arch=gfx802 \
      --offload-arch=gfx803 \
      -O3 \
      -Wno-unused-result \
      -Wno-ignored-attributes \
      -shared -fPIC \
      -L "${vapoursynthPlugins.ffms2}/lib" -lffms2 \
      -o vship${hostPlatform.extensions.sharedLibrary}
  
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 vship${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/vapoursynth/vship${stdenv.hostPlatform.extensions.sharedLibrary}

    runHook postInstall
  '';

  meta = with lib; {
    description = "GPU-accelerated VapourSynth plugin for SSIMULACRA2 & Butteraugli";
    homepage = "https://codeberg.org/Line-fr/Vship";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
