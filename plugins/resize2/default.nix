{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  meson-python,
  meson,
  ninja,
  pkg-config,
  python,
  packaging,
  git,
  cmake,
  vapoursynth,
}:
buildPythonPackage rec {
  pname = "vapoursynth-resize2";
  version = "0.4.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = version;
    hash = "sha256-oOfDYHBZZ3JEYrbeiwSDNAaua7hlC61lYJOTqB6I7/Q=";
};

 zimgSrc = fetchgit {
    url = "https://github.com/sekrit-twc/zimg.git";
    rev = "df9c1472b9541d0e79c8d02dae37fdf12f189ec2";
    hash = "sha256-8PDjDlG3Bso3IQUwjrGqZZR0VtCiVLHB77Ul6n4I+XM=";
    fetchSubmodules = true;
  };


  nativeBuildInputs = [
    meson-python
    meson
    ninja
    pkg-config
    python
    packaging
  ];

  buildInputs = [
    vapoursynth
  ];
  propagatedBuildInputs = [
    vapoursynth
  ];

  dontCheckRuntimeDeps = true;
  postPatch = ''
      mkdir -p subprojects/packagecache
      rm -rf subprojects/packagecache/zimg
      cp -r ${zimgSrc} subprojects/packagecache/zimg
      chmod -R +w subprojects/packagecache/zimg

      python <<EOF
    import re
    p = open("pyproject.toml").read()
    p = re.sub(r'"vapoursynth>=.*?",?', "", p)
    p = re.sub(r'"ninja==.*?",?', '"ninja",', p)
    open("pyproject.toml", "w").write(p)
    EOF

      substituteInPlace meson.build \
        --replace-fail \
        "import vapoursynth as vs; print(vs.get_include())" \
        "print(\"${vapoursynth}/include/vapoursynth\")"
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    plugin="$(find $out/lib -name 'libresize2${stdenv.hostPlatform.extensions.sharedLibrary}' | head -n1)"
    ln -s "$plugin" $out/lib/vapoursynth/libresize2${stdenv.hostPlatform.extensions.sharedLibrary}
  '';
}
