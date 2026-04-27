final: prev:
let
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
in
{
  vapoursynthPlugins = prev.lib.recurseIntoAttrs {
    adaptivegrain = prev.callPackage ./plugins/adaptivegrain { };
    vs-noise = prev.callPackage ./plugins/vs-noise { };
    autocrop = prev.callPackage ./plugins/autocrop { };
    beziercurve = prev.callPackage ./plugins/beziercurve { };
    bifrost = prev.callPackage ./plugins/bifrost { };
    bm3d = prev.callPackage ./plugins/bm3d { };
    cas = prev.callPackage ./plugins/cas { };
    cnr2 = prev.callPackage ./plugins/cnr2 { };
    d2vsource = prev.callPackage ./plugins/d2vsource { };
    dctfilter = prev.callPackage ./plugins/dctfilter { };
    deblock = prev.callPackage ./plugins/deblock { };
    descale = prev.callPackage ./plugins/descale { };
    dfttest = prev.callPackage ./plugins/dfttest { };
    eedi3m = prev.callPackage ./plugins/eedi3m { };
    ffms2 = prev.ffms;
    fillborders = prev.callPackage ./plugins/fillborders { };
    fmtconv = prev.callPackage ./plugins/fmtconv { };
    histogram = prev.callPackage ./plugins/histogram { };
    lsmashsource = prev.callPackage ./plugins/lsmashsource { };
    mvtools = prev.vapoursynth-mvtools;
    neo_f3kdb = prev.callPackage ./plugins/neo_f3kdb { };
    nnedi3 = prev.callPackage ./plugins/nnedi3 { };
    nnedi3cl = prev.callPackage ./plugins/nnedi3cl { };
    ocr = prev.callPackage ./plugins/ocr { };
    placebo = prev.callPackage ./plugins/placebo { };
    readmpls = prev.callPackage ./plugins/readmpls { };
    remap = prev.callPackage ./plugins/remap { };
    removegrain = prev.callPackage ./plugins/removegrain { };
    sangnom = prev.callPackage ./plugins/sangnom { };
    scxvid = prev.callPackage ./plugins/scxvid { };
    subtext = prev.callPackage ./plugins/subtext { };
    tcanny = prev.callPackage ./plugins/tcanny { };
    tnlmeans = prev.callPackage ./plugins/tnlmeans { };
    ttempsmooth = prev.callPackage ./plugins/ttempsmooth { };
    vivtc = prev.callPackage ./plugins/vivtc { };
    znedi3 = prev.callPackage ./plugins/znedi3 { };
    vsncnn = prev.callPackage ./plugins/vs-mlrt/vsncnn { };
    vstrt = prev.callPackage ./plugins/vs-mlrt/vstrt { };
    vship = prev.callPackage ./plugins/vship { };
    vsfpng = prev.callPackage ./plugins/vsfpng { };
    knlmeanscl = prev.callPackage ./plugins/knlmeanscl { };
    vsfiltermod = prev.callPackage ./plugins/vsfiltermod { };
    vs-mlrt = prev.callPackage ./plugins/vs-mlrt { };

    insaneaa = callPythonPackage ./plugins/insaneaa { };
    acsuite = callPythonPackage ./plugins/acsuite { };
    astdr = callPythonPackage ./plugins/astdr { };
    dfmderainbow = callPythonPackage ./plugins/dfmderainbow { };
    finedehalo = callPythonPackage ./plugins/finedehalo { };
    nnedi3_resample = callPythonPackage ./plugins/nnedi3_resample { };
    nnedi3_rpow2 = callPythonPackage ./plugins/nnedi3_rpow2 { };
    rekt = callPythonPackage ./plugins/rekt { };
    vsgan = callPythonPackage ./plugins/vsgan { };
    vsTAAmbk = callPythonPackage ./plugins/vsTAAmbk { };
    vsutil = callPythonPackage ./plugins/vsutil { };
    jetpytools = callPythonPackage ./plugins/jetpytools { };
    vsjetpack = callPythonPackage ./plugins/vsjetpack {
      inherit (final.vapoursynthPlugins) jetpytools;
    };

    awsmfunc = callPythonPackage ./plugins/awsmfunc { };
    lvsfunc = callPythonPackage ./plugins/lvsfunc { };
    vardefunc = callPythonPackage ./plugins/vardefunc { };
  };

  getnative = callPythonPackage ./tools/getnative { };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      styler00dollar-vsgan-trt = callPythonPackage ./tools/styler00dollar-vsgan-trt { };
    })
  ];
}
