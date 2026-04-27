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
    bm3d           = prev.callPackage ./plugins/bm3d { };
    cas            = prev.callPackage ./plugins/cas { };
    d2vsource      = prev.callPackage ./plugins/d2vsource { };
    deblock        = prev.callPackage ./plugins/deblock { };
    descale        = prev.callPackage ./plugins/descale { };
    dfttest        = prev.callPackage ./plugins/dfttest { };
    edgemasks      = prev.callPackage ./plugins/edgemasks { };
    eedi3m         = prev.callPackage ./plugins/eedi3m { };
    ffms2          = prev.ffms;
    fillborders    = prev.callPackage ./plugins/fillborders { };
    fmtconv        = prev.callPackage ./plugins/fmtconv { };
    histogram      = prev.callPackage ./plugins/histogram { };
    lsmashsource   = prev.callPackage ./plugins/lsmashsource { };
    mvtools        = prev.vapoursynth-mvtools;
    neo-f3kdb      = prev.callPackage ./plugins/neo_f3kdb { };
    nlm-ispc       = prev.callPackage ./plugins/nlm-ispc { };
    ocr            = prev.callPackage ./plugins/ocr { };
    placebo        = prev.callPackage ./plugins/placebo { };
    readmpls       = prev.callPackage ./plugins/readmpls { };
    remap          = prev.callPackage ./plugins/remap { };
    removegrain    = prev.callPackage ./plugins/removegrain { };
    sneedif        = prev.callPackage ./plugins/sneedif { };
    subtext        = prev.callPackage ./plugins/subtext { };
    tnlmeans       = prev.callPackage ./plugins/tnlmeans { };
    ttempsmooth    = prev.callPackage ./plugins/ttempsmooth { };
    vivtc          = prev.callPackage ./plugins/vivtc { };
    vs-filtermod   = prev.callPackage ./plugins/vsfiltermod { };
    vs-fpng        = prev.callPackage ./plugins/vsfpng { };
    vs-hip         = prev.callPackage ./plugins/vship { };
    vs-mlrt        = prev.callPackage ./plugins/vs-mlrt { };
    vs-ncnn        = prev.callPackage ./plugins/vs-mlrt/vsncnn { };
    vs-noise       = prev.callPackage ./plugins/vs-noise { };
    vs-trt         = prev.callPackage ./plugins/vs-mlrt/vstrt { };
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
    rekt           = callPythonPackage ./plugins/rekt { };
    vardefunc      = callPythonPackage ./plugins/vardefunc { };
    vs-gan         = callPythonPackage ./plugins/vsgan { };
    vs-jetpack     = callPythonPackage ./plugins/vsjetpack {
      inherit (final.vapoursynthPlugins) jetpytools;
    };
    vs-taambk      = callPythonPackage ./plugins/vsTAAmbk { };
    vsutil         = callPythonPackage ./plugins/vsutil { };
  };

  getnative = callPythonPackage ./tools/getnative { };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      styler00dollar-vsgan-trt = callPythonPackage ./tools/styler00dollar-vsgan-trt { };
    })
  ];
}
