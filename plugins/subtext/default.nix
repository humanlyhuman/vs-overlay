{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  ffmpeg,
  libass,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "subtext";
  version = "6";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = pname;
    rev = "R${version}";
    hash = "sha256-MX1QQ0h82PLXasYrnFbrkaeAXmGENCxyqWmnVUP27dY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    ffmpeg
    libass
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
      "incdir = include_directories(
        run_command(
            find_program('python', 'python3'),
            '-c',
            'import vapoursynth as vs; print(vs.get_include())',
            check: true,
        ).stdout().strip(),
    )" \
      "incdir = include_directories('${vapoursynth}/include/vapoursynth')"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 \
      libsubtext${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/vapoursynth/libsubtext${stdenv.hostPlatform.extensions.sharedLibrary}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Subtitle plugin for VapourSynth based on libass";
    homepage = "https://github.com/vapoursynth/subtext";
    license = licenses.mit;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.all;
  };
}
