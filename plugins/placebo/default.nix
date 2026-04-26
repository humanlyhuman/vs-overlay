{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libplacebo,
  vapoursynth,
  vulkan-headers,
  vulkan-loader,
}:
let
  libp2p = fetchurl {
    url = "https://github.com/sekrit-twc/libp2p/archive/f50288b0c8db2cb14bb98fc25a5f056609d03652.tar.gz";
    hash = "sha256:37b14be5b1108268e55aa4fbaf838c287018ecc5b58e15efdfe064916afc44e9";
  };
in
stdenv.mkDerivation rec {
  pname = "vs-placebo";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "Lypheo";
    repo = pname;
    rev = version;
    sha256 = "sha256-PlqqMBU9WedOqQkl8S77xIUzBpaU1Bgv9ZY8Rfh803o=";
    fetchSubmodules = false;
  };
  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libplacebo vapoursynth vulkan-headers vulkan-loader ];
  postPatch = ''
    substituteInPlace meson.build \
      --replace-warn "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  
    mkdir -p subprojects/libp2p-f50288b0c8db2cb14bb98fc25a5f056609d03652
    tar -xzf ${libp2p} -C subprojects/libp2p-f50288b0c8db2cb14bb98fc25a5f056609d03652 \
      --strip-components=1
  
    cp -r subprojects/packagefiles/libp2p-f50288b0c8db2cb14bb98fc25a5f056609d03652/. \
      subprojects/libp2p-f50288b0c8db2cb14bb98fc25a5f056609d03652/
  '';
  mesonFlags = [
    "-Dr73-compat=true"
  ];
  meta = with lib; {
    description = "A libplacebo-based debanding, scaling and color mapping plugin for VapourSynth";
    homepage = "https://github.com/Lypheo/vs-placebo";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ humanlyhuman ];
    platforms = platforms.all;
  };
}
