final: prev: let
  # This is required to allow vapoursynth.withPlugins to be used inside python packages,
  # where normally python3Packages.vapoursynth would be used,
  # which only includes the python module without the frameserver.
  callPythonPackage = prev.lib.callPackageWith (
    final
    // final.vapoursynth.python3.pkgs
    // {
      inherit (final) vapoursynth;
    }
  );
in {
  vapoursynthPlugins = prev.lib.recurseIntoAttrs {
    # Native C plugins
    autocrop = prev.callPackage ./plugins/autocrop {};
    awarp = prev.callPackage ./plugins/awarp {};
    bm3d = prev.callPackage ./plugins/bm3d {};
    d2vsource = prev.callPackage ./plugins/d2vsource {};
    deblock = prev.callPackage ./plugins/deblock {};
    descale = prev.callPackage ./plugins/descale {};
    edgemasks = prev.callPackage ./plugins/edgemasks {};
    eedi3m = prev.callPackage ./plugins/eedi3m {};
    ffms2 = prev.ffms;
    fillborders = prev.callPackage ./plugins/fillborders {};
    fmtconv = prev.callPackage ./plugins/fmtconv {};
    lsmashsource = prev.callPackage ./plugins/lsmashsource {};
    mvtools = prev.vapoursynth-mvtools;
    neo-f3kdb = prev.callPackage ./plugins/neo_f3kdb {};
    nlm-ispc = prev.callPackage ./plugins/nlm-ispc {};
    ocr = prev.callPackage ./plugins/ocr {};
    placebo = prev.callPackage ./plugins/placebo {};
    readmpls = prev.callPackage ./plugins/readmpls {};
    subtext = prev.callPackage ./plugins/subtext {};
    scxvid = prev.callPackage ./plugins/scxvid {};
    tnlmeans = prev.callPackage ./plugins/tnlmeans {};
    vivtc = prev.callPackage ./plugins/vivtc {};
    vs-filtermod = prev.callPackage ./plugins/vsfiltermod {};
    vs-fpng = prev.callPackage ./plugins/vsfpng {};
    vs-hip = prev.callPackage ./plugins/vship {};
    vs-mlrt = prev.callPackage ./plugins/vs-mlrt {};
    vs-ncnn = prev.callPackage ./plugins/vs-mlrt/vsncnn {};
    vs-noise = prev.callPackage ./plugins/vs-noise {};
    vs-trt = prev.callPackage ./plugins/vs-mlrt/vstrt {};
    znedi3 = prev.callPackage ./plugins/znedi3 {};

    # Python wrappers
    acsuite = callPythonPackage ./plugins/acsuite {};
    akarin = callPythonPackage ./plugins/akarin {};
    awsmfunc = callPythonPackage ./plugins/awsmfunc {};
    finedehalo = callPythonPackage ./plugins/finedehalo {};
    jetpytools = callPythonPackage ./plugins/jetpytools {};
    knlmeanscl = callPythonPackage ./plugins/knlmeanscl {};
    lvsfunc = callPythonPackage ./plugins/lvsfunc {};
    rekt = callPythonPackage ./plugins/rekt {};
    sneedif = callPythonPackage ./plugins/sneedif {};
    vardefunc = callPythonPackage ./plugins/vardefunc {};
    vs-jetpack = callPythonPackage ./plugins/vsjetpack {
      inherit (final.vapoursynthPlugins) jetpytools;
    };
    vsutil = callPythonPackage ./plugins/vsutil {};
  };

  getnative = callPythonPackage ./tools/getnative {};
}
