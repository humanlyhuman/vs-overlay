{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  xvidcore,
  python3
}:

  stdenv.mkDerivation rec {
    pname = "vapoursynth-scxvid";
    version = "3";
  
    src = fetchFromGitHub {
      owner = "dubhatervapoursynth";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-WgoIF7ni2j6wNCutysV18B693OapzniZoy94iyZR3uA=";
    };
  
    nativeBuildInputs = [ meson ninja pkg-config python3 ];
  
    buildInputs = [ vapoursynth xvidcore ];
      
  postPatch = ''
      substituteInPlace meson.build \
        --replace-fail "incdir = include_directories(" "incdir = include_directories()" \
        ---replace-fail "run_command('python', 'python3')," "''"
        --replace-fail "py.get_install_dir() / 'vapoursynth/plugins'" \
        "get_option('libdir') / 'vapoursynth'"
    '';

    installPhase = ''
      mkdir -p $out/lib/vapoursynth
      cp build/src/scxvid.so $out/lib/vapoursynth/
    '';

  meta = with lib; {
    description = "Scene change detection plugin for VapourSynth using xvid";
    homepage = "https://github.com/dubhater/vapoursynth-scxvid";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
