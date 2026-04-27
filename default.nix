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
    # Native C plugins
    adaptivegrain  = prev.callPackage ./plugins/adaptivegrain { };
    autocrop       = prev.callPackage ./plugins/autocrop { };
    awarp          = prev.callPackage ./plugins/awarp { };
    beziercurve    = prev.callPackage ./plugins/beziercurve { };
    bifrost        = prev.callPackage ./plugins/bifrost { };
    bm3d           = prev.callPackage ./plugins/bm3d { };
    cas            = prev.callPackage ./plugins/cas { };
    cnr2           = prev.callPackage ./plugins/cnr2 { };
    d2vsource      = prev.callPackage ./plugins/d2vsource { };
    dctfilter      = prev.callPackage ./plugins/dctfilter { };
    deblock        = prev.callPackage ./plugins/deblock { };
    descale        = prev.callPackage ./plugins/descale { };
    dfttest        = prev.callPackage ./plugins/dfttest { };
    edgemasks      = prev.callPackage ./plugins/edgemasks { };
    eedi3m         = prev.callPackage ./plugins/eedi3m { };
    ffms2          = prev.ffms;
    fillborders    = prev.callPackage ./plugins/fillborders { };
    fmtconv        = prev.callPackage ./plugins/fmtconv { };
    histogram      = prev.callPackage ./plugins/histogram { };
    knlmeanscl     = prev.callPackage ./plugins/knlmeanscl { };
    lsmashsource   = prev.callPackage ./plugins/lsmashsource { };
    mvtools        = prev.vapoursynth-mvtools;
    neo_f3kdb      = prev.callPackage ./plugins/neo_f3kdb { };
    ocr            = prev.callPackage ./plugins/ocr { };
    placebo        = prev.callPackage ./plugins/placebo { };
    readmpls       = prev.callPackage ./plugins/readmpls { };
    remap          = prev.callPackage ./plugins/remap { };
    removegrain    = prev.callPackage ./plugins/removegrain { };
    sangnom        = prev.callPackage ./plugins/sangnom { };
    scxvid         = prev.callPackage ./plugins/scxvid { };
    subtext        = prev.callPackage ./plugins/subtext { };
    tnlmeans       = prev.callPackage ./plugins/tnlmeans { };
    ttempsmooth    = prev.callPackage ./plugins/ttempsmooth { };
    vsfpng         = prev.callPackage ./plugins/vsfpng { };
    vivtc          = prev.callPackage ./plugins/vivtc { };
    vs-mlrt        = prev.callPackage ./plugins/vs-mlrt { };
    vs-noise       = prev.callPackage ./plugins/vs-noise { };
    vsfiltermod    = prev.callPackage ./plugins/vsfiltermod { };
    vship          = prev.callPackage ./plugins/vship { };
    vsncnn         = prev.callPackage ./plugins/vs-mlrt/vsncnn { };
    vstrt          = prev.callPackage ./plugins/vs-mlrt/vstrt { };
    znedi3         = prev.callPackage ./plugins/znedi3 { };

    # Python wrappers
    acsuite        = callPythonPackage ./plugins/acsuite { };
    akarin         = callPythonPackage ./plugins/akarin { };
    astdr          = callPythonPackage ./plugins/astdr { };
    awsmfunc       = callPythonPackage ./plugins/awsmfunc { };
    dfmderainbow   = callPythonPackage ./plugins/dfmderainbow { };
    finedehalo     = callPythonPackage ./plugins/finedehalo { };
    insaneaa       = callPythonPackage ./plugins/insaneaa { };
    jetpytools     = callPythonPackage ./plugins/jetpytools { };
    lvsfunc        = callPythonPackage ./plugins/lvsfunc { };
    nnedi3_resample = callPythonPackage ./plugins/nnedi3_resample { };
    nnedi3_rpow2   = callPythonPackage ./plugins/nnedi3_rpow2 { };
    rekt           = callPythonPackage ./plugins/rekt { };
    vardefunc      = callPythonPackage ./plugins/vardefunc { };
    vsgan          = callPythonPackage ./plugins/vsgan { };
    vsjetpack      = callPythonPackage ./plugins/vsjetpack {
      inherit (final.vapoursynthPlugins) jetpytools;
    };
    vsTAAmbk       = callPythonPackage ./plugins/vsTAAmbk { };
    vsutil         = callPythonPackage ./plugins/vsutil { };
  };

  getnative = callPythonPackage ./tools/getnative { };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      styler00dollar-vsgan-trt = callPythonPackage ./tools/styler00dollar-vsgan-trt { };
    })
  ];
}
