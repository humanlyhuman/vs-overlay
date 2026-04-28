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
}: let
  libp2p = fetchurl {
    url = "https://github.com/sekrit-twc/libp2p/archive/f50288b0c8db2cb14bb98fc25a5f056609d03652.tar.gz";
    hash = "sha256-N7FL5bEQgmjlWqT7r4OMKHAY7MW1jhXv3+BkkWr8ROk=";
  };
in
  stdenv.mkDerivation rec {
    pname = "vs-placebo";
    version = "2.0.1";
    src = fetchFromGitHub {
      owner = "Lypheo";
      repo = pname;
      rev = version;
      hash = "sha256-oHRwovTJBwfFOe2UmaSHxE/11F/ttE9H/gznS5xk/y8=";
      fetchSubmodules = false;
    };
    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];
    buildInputs = [
      libplacebo
      vapoursynth
      vulkan-headers
      vulkan-loader
    ];
    postPatch = ''
      substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"

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
      maintainers = with maintainers; [humanlyhuman];
      platforms = platforms.linux;
    };
  }
