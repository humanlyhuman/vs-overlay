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
postPatch = ''
  substituteInPlace meson.build \
    --replace-fail \
      "run_command(
        find_program('python', 'python3'),
        '-c',
        'import vapoursynth as vs; print(vs.get_include())',
        check: true,
    ).stdout().strip()" \
      "'${vapoursynth}/include/vapoursynth'"
'';
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
  meta = with lib; {
    description = "D2V parser and decoder for VapourSynth";
    homepage = "https://github.com/dwbuiten/d2vsource";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [sbruder];
    platforms = platforms.all;
  };
})
