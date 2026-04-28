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
  pname = "edgemasks";
  version = "4";

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-EdgeMasks";
    rev = "r${version}";
    hash = "sha256-H9kAmgoktxmxKWSG9ZBdxY4vGONlxOXwadNJdnIEjUI=";
  };
  mesonFlags = ["-Db_lto=false"];
  postPatch = ''
    python3 -c "
    content = open('meson.build').read()
    import re
    content = re.sub(
      r'run_command\(.*?find_program\(.python., .python3.\).*?\)\.stdout\(\)\.strip\(\)',
      \"'${vapoursynth}/include/vapoursynth'\",
      content,
      flags=re.DOTALL
    )
    content = content.replace(
      \"py.get_install_dir() / 'vapoursynth/plugins'\",
      \"'${placeholder "out"}/lib/vapoursynth'\"
    )
    open('meson.build', 'w').write(content)
    "
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (vapoursynth.python3)
  ];
  buildInputs = [vapoursynth];

  meta = with lib; {
    description = "EdgeMasks filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-EdgeMasks";
    license = licenses.mit;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
