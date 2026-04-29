{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  p7zip,
  vapoursynth,
  python3,
  vapoursynthPlugins,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "models";
  version = "15.16";
  format = "other";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v15.16";
    hash = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
  };
  models = fetchurl {
    url = "https://github.com/AmusementClub/vs-mlrt/releases/download/v15.16/models.v15.16.7z";
    hash = "sha256-1OqowcRFkIIYWp4aLFTX4sd2q+6mrvau4MuPbBUd+wI=";
  };

  contribModels = fetchurl {
    url = "https://github.com/AmusementClub/vs-mlrt/releases/download/v15.16/contrib-models.v15.16.7z";
    hash = "sha256-Im515f+jHfcqxYR43LIv52bisiAMHutVHsKGEh8u43Y=";
  };
  externalModelsList = [
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/anitoon_v1.7z";
      hash = "sha256-echZFenpIoYHoTinfP+IAGIf63VIJ9jYvo5KooJDSag=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/artcnn_v8.7z";
      hash = "sha256-ARYjZh9yc/53xxv0GYaNqXAGM+7qe93NrGGmgJUcarA=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/oidn_v2.7z";
      hash = "sha256-eNR0OVDy56lf/JIxYO7FRRxh5ohHxM4lbZAgxi3Ow4A=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/ppocr_v3.7z";
      hash = "sha256-aJDw1OBEUIvNR2QaVRywTmCauW6rPJchz+aQ/ZqsjPA=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.26_heavy.7z";
      hash = "sha256-HkcuPwMJkCRAwsmmywBv9EMHJIrOWMMKDOh4NMNnB3Y=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/waifu2x_swin_unet_v5.7z";
      hash = "sha256-VVLiJb2DcM+oRgXLptIsbWuFTwTzjGnkNanSEwAJvKs=";
    })

    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/anime-segmentation_v1.7z";
      hash = "sha256-JOGCTsN+eFhXTREIuYoko/pXtRxv8wNf1wpdz9A6QhE=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_ensemble_v1.7z";
      hash = "sha256-oxiOLf0dY8Hnjw/NZWKaymt7ab77v3Y0zsrA/AQASV4=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v2_v4.7z";
      hash = "sha256-yZmdavaAA2X089cW26pR9ZVOBfOEJPg7cFsFXXVMccw=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.7.7z";
      hash = "sha256-HfhIt99GLjuHi+csgedSEtPz+lxPNIdOC4VeB/jrgxM=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.8.7z";
      hash = "sha256-dpSPGSjfdOyMJCF6WpvnUOkAN6cETfP9Iv/hpqXMCn4=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.9.7z";
      hash = "sha256-gFrWbNRfic7P/dsb1LhUCZ41E8sfQzasQ6nRfo83f+Q=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.10.7z";
      hash = "sha256-pyHi8AaafxAGxh5zy7TsisAqw9qyEDJIzap04EeJNpw=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.11.7z";
      hash = "sha256-r0IRzfgtZcNhY1kgwRKGAo7i2ti8F3mdICU8zF7POto=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.12.7z";
      hash = "sha256-mWWfc7HFa6FzDCI3kanjkxoymWCMOo6DV4rK6h5Wp68=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.12_lite.7z";
      hash = "sha256-tq9nWVQotp3ZMsJiiM6vRvxReOYJF9fo232teZ8D2Hs=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.13.7z";
      hash = "sha256-PGQK40Ep/t+D95wiWITZQvg5PFaDm43KaYTOV3ra72k=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.13_lite.7z";
      hash = "sha256-a16I49JvF2gIa7JzzaaaPvb2MPs798InrZiIgko6ou0=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.14.7z";
      hash = "sha256-bSpSxE22a5ii5jFrf3cS5LoIxzrvTKo/E0LVghfvb7E=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.14_lite.7z";
      hash = "sha256-JIhnCxQymyfXrCDzr8nwJeOnrjlVBSL+awcHbEQBlik=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.15.7z";
      hash = "sha256-SKwExqZLJ3GCf1DT1vCdeRusCq7toBpJLj/rFiGkNc4=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.15_lite.7z";
      hash = "sha256-nIlLzLfb1b0P+dmWFjYChWKCMN6BN0GBuXppEk9z0ak=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.16_lite.7z";
      hash = "sha256-foorhMNHng0a5RNU5/oif3a5y5Ps3uFT7h6WIcqLye8=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.17.7z";
      hash = "sha256-/hf0XuzBpCLqtfPtaCBhJ878xsOovC2ufdbMRZb4Weo=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.17_lite.7z";
      hash = "sha256-5RB4zpcV2UQq7cP1435UhpAwzdbpAu49TCzgSqvLtAw=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.18.7z";
      hash = "sha256-ZsIrmi+gWac8aMJ0fSVvI6Tb3zf2abuVDo6VARN/FE8=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.19.7z";
      hash = "sha256-Dzr5OW1zuh6iKfYvDyaTu4gOGiN/j/EoYgasWhNItSo=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.20.7z";
      hash = "sha256-Hwu2AuZTYipvybWmV4Kw88MXMgCXWM89k57AgGMdwI0=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.21.7z";
      hash = "sha256-mhtlDsarIiby8ltfGVEpcD/bS/4IghWtftS7gDj/QtM=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.22.7z";
      hash = "sha256-ZxT7ZylyUSMGNQcE+D/oVCCr0hNQZp7Lrr4UAyDfVwU=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.22_lite.7z";
      hash = "sha256-58OHL9IXZjkR8LiaWUC9wxT1oGH9X6hjn9FnTTHS8c8=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.23.7z";
      hash = "sha256-1k/UsmESXT4ujRKe8iMD/FIgRNBywMzB4BER+dNuBVE=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.24.7z";
      hash = "sha256-XVE13L2q9R8ySocpzp9kim/BfmH7aiV+tF9QXjqR6Q8=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.25.7z";
      hash = "sha256-Fy/pdcF3UTS7hxCOTsbRqJ6GHMXTvirCO/CK/l7WJrg=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.25_heavy.7z";
      hash = "sha256-1RuSv08UCNHi4kPETLjKH8iF/f9CpKAfA7I7X1SRdZI=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.25_lite.7z";
      hash = "sha256-fVPin/9eZzRbGfTOl9/R40tJDu3HUt8iNpBP2hoThCw=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/rife_v4.26.7z";
      hash = "sha256-39q9hKKj23c/h2BLjMJV6UpqcvE1UNkQzNO07iYGzU8=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/safa_v0.1.7z";
      hash = "sha256-p9eoH3U1nyScYsIoCJhSqF+K/+gjECWJ3vXVTejvo9o=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/safa_v0.2.7z";
      hash = "sha256-wWQPvhSWNgQnIaQkwc/x7QR1xBZvp2AFuWsdtJoV6S4=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/safa_v0.3.7z";
      hash = "sha256-TpeAs+gh0LPBsqd/rAI4Vs2LGydPW0R2Z9X/qQoONxA=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/safa_v0.4.7z";
      hash = "sha256-Ou8NXtb1HA6maRi/BxytyKEosg/EJliqzlmiY5MN/F8=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/safa_v0.5.7z";
      hash = "sha256-15eGOEFjppsqOAgoGsEY23unIw2lCoovh+7KinqCjus=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/scunet_v2.7z";
      hash = "sha256-M8jjlt8nsKr2Okx7EJOWt9OUf40JegN+IXnrafgVwhg=";
    })
    (fetchurl {
      url = "https://github.com/AmusementClub/vs-mlrt/releases/download/external-models/swinir_v1.7z";
      hash = "sha256-iMzs7bLhHqzuDS86cOciCdXWkmltK560KjC/fmFKDgs=";
    })
  ];
  nativeBuildInputs = [p7zip];
  buildInputs = [vapoursynth];

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace scripts/vsmlrt.py \
      --replace-fail \
        'models_path: str = os.path.join(plugins_path, "models")' \
        'models_path: str = "${placeholder "out"}/share/vs-mlrt/models"'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 scripts/vsmlrt.py \
      $out/${python3.sitePackages}/vsmlrt.py
    mkdir -p $out/share/vs-mlrt
    7z x -y ${models}        -o$out/share/vs-mlrt
    7z x -y ${contribModels} -o$out/share/vs-mlrt
    for archive in ${lib.concatMapStringsSep " " (x: "${x}") externalModelsList}; do
      7z x -y "$archive" -o$out/share/vs-mlrt/models
    done
    mkdir -p $out/lib/vapoursynth
    for pkg in \
      ${vapoursynthPlugins.vsncnn} \
      ${vapoursynthPlugins.vsort} \
      ${vapoursynthPlugins.vsmigx} \
      ${vapoursynthPlugins.vsov} \
      ${vapoursynthPlugins.vstrt}
    do
      for lib in $pkg/lib/vapoursynth/*.so; do
        ln -s "$lib" $out/lib/vapoursynth/
      done
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "Machine learning runtimes for VapourSynth (scripts + bundled + external models)";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.unfree;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
