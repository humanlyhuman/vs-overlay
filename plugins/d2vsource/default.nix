{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  ffmpeg,
  vapoursynth,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "d2vsource";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "dwbuiten";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-GVMhksXz3Dep9YqgbouEy7d7AuFiHezbkxwjWj1fqvk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    ffmpeg
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
      "'import vapoursynth as vs; print(vs.get_include())'" \
      "'print(\"${vapoursynth}/include/vapoursynth\")'"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 \
      libd2vsource${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/vapoursynth/libd2vsource${stdenv.hostPlatform.extensions.sharedLibrary}

    runHook postInstall
  '';

  meta = with lib; {
    description = "D2V parser and decoder for VapourSynth";
    homepage = "https://github.com/dwbuiten/d2vsource";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.all;
  };
})
