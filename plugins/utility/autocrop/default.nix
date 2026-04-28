{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
}: let
  ext = stdenv.targetPlatform.extensions.sharedLibrary;
in
  stdenv.mkDerivation rec {
    pname = "autocrop";
    version = "0.1";

    src = fetchFromGitHub {
      owner = "Irrational-Encoding-Wizardry";
      repo = pname;
      rev = version;
      hash = "sha256-TAVogEE09JvIGOiw5UJbQXdggyJC+9KNNeWChg4v8JY=";
    };

    buildInputs = [vapoursynth];

    buildPhase = ''
      c++ -std=c++11 -shared -fPIC -O2 -I${vapoursynth}/include/vapoursynth \
          autocrop.cpp -o libautocrop${ext}
    '';

    installPhase = ''
      install -D libautocrop${ext} $out/lib/vapoursynth/libautocrop${ext}
    '';

    meta = with lib; {
      description = "Autocrop for VapourSynth";
      homepage = "https://github.com/Irrational-Encoding-Wizardry/vapoursynth-autocrop";
      license = licenses.unfree; 
      maintainers = with maintainers; [humanlyhuman];
      platforms = platforms.linux;
    };
  }
