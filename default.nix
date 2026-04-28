final: prev:
let
  callPythonPackage = final.lib.callPackageWith (
    final
    // final.vapoursynth.python3.pkgs
    // { inherit (final) vapoursynth; }
  );
in
{
  vapoursynthPlugins = final.lib.recurseIntoAttrs rec {

    neo_f3kdb = final.callPackage ./plugins/deband/neo_f3kdb {};
    placebo    = final.callPackage ./plugins/deband/placebo {};

    sneedif = callPythonPackage ./plugins/deinterlace/sneedif {};
    vivtc   = final.callPackage ./plugins/deinterlace/vivtc {};
    znedi3  = final.callPackage ./plugins/deinterlace/znedi3 {};

    bm3d      = final.callPackage ./plugins/denoise/bm3d {};
    knlmeanscl = callPythonPackage ./plugins/denoise/knlmeanscl {};
    nlm-ispc  = final.callPackage ./plugins/denoise/nlm-ispc {};
    tnlmeans  = final.callPackage ./plugins/denoise/tnlmeans {};

    vsnoise = final.callPackage ./plugins/grain/vs-noise {};

    awarp     = final.callPackage ./plugins/mask/awarp {};
    edgemasks = final.callPackage ./plugins/mask/edgemasks {};

    vsmlrtmodels = final.callPackage ./plugins/ml/vs-mlrt/models {};
    vsncnn       = final.callPackage ./plugins/ml/vs-mlrt/vsncnn {};
    vsort        = final.callPackage ./plugins/ml/vs-mlrt/vsort {};
    vstrt        = final.callPackage ./plugins/ml/vs-mlrt/vstrt {};

    descale = final.callPackage ./plugins/resize/descale {};
    fmtconv = final.callPackage ./plugins/resize/fmtconv {};
    resize2 = callPythonPackage ./plugins/resize/resize2 {};

    d2vsource   = final.callPackage ./plugins/source/d2vsource {};
    lsmashsource = final.callPackage ./plugins/source/lsmashsource {};
    readmpls    = final.callPackage ./plugins/source/readmpls {};

    ocr        = final.callPackage ./plugins/subtitle/ocr {};
    subtext    = final.callPackage ./plugins/subtitle/subtext {};
    vsfiltermod = final.callPackage ./plugins/subtitle/vsfiltermod {};

    akarin      = callPythonPackage ./plugins/utility/akarin {};
    autocrop    = final.callPackage ./plugins/utility/autocrop {};
    deblock     = final.callPackage ./plugins/utility/deblock {};
    fillborders = final.callPackage ./plugins/utility/fillborders {};
    remap       = final.callPackage ./plugins/utility/remap {};
    scxvid      = final.callPackage ./plugins/utility/scxvid {};
    vship       = final.callPackage ./plugins/utility/vship {};
    vsfpng      = final.callPackage ./plugins/source/vsfpng {};
    vszip       = final.callPackage ./plugins/utility/vszip {};

    acsuite    = callPythonPackage ./plugins/misc/acsuite {};
    awsmfunc   = callPythonPackage ./plugins/misc/awsmfunc {};
    finedehalo = callPythonPackage ./plugins/misc/finedehalo {};
    jetpytools = callPythonPackage ./plugins/misc/jetpytools {};
    lvsfunc    = callPythonPackage ./plugins/misc/lvsfunc {};
    rekt       = callPythonPackage ./plugins/misc/rekt {};
    vsjetengine = callPythonPackage ./plugins/misc/vsjetengine {};
    vsjetpack  = callPythonPackage ./plugins/misc/vsjetpack {inherit jetpytools;};
    vsutil     = callPythonPackage ./plugins/misc/vsutil {};

    ffms2   = final.ffms;
    mvtools = final.vapoursynth-mvtools;
    bestsource = final.vapoursynth-bestsource;
  };

  getnative = callPythonPackage ./tools/getnative {};
  nativeres = callPythonPackage ./tools/nativeres {};
}