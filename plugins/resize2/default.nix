{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  automake,
  autoconf,
  libtool,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "zimg_patched";
  version = "unstable-2026-04-27";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://github.com/sekrit-twc/zimg.git";
    rev = "df9c1472b9541d0e79c8d02dae37fdf12f189ec2";
    hash = "sha256-8PDjDlG3Bso3IQUwjrGqZZR0VtCiVLHB77Ul6n4I+XM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    automake
    autoconf
    libtool
    pkg-config
  ];

  configureFlags = [
    "--enable-static"
    "--disable-shared"
  ];

  postPatch = ''
    #
    if [ -f ${./0001.patch} ]; then
      patch -p1 < ${./0001.patch}
    fi
  '';

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig

    cat > $dev/lib/pkgconfig/zimg_patched.pc <<EOF
    prefix=$out
    exec_prefix=$out
    libdir=$out/lib
    includedir=$dev/include

    Name: zimg_patched
    Description: patched zimg for vapoursynth-resize2
    Version=${version}
    Libs: -L$out/lib -lzimg
    Cflags: -I$dev/include
    EOF
  '';

  meta = with lib; {
    description = "Patched zimg fork used by vapoursynth-resize2";
    homepage = "https://github.com/sekrit-twc/zimg";
    license = licenses.wtfpl;
    platforms = platforms.unix;
  };
}
