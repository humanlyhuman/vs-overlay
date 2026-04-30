final: prev: let
  callPythonPackage = final.lib.callPackageWith (
    final
    // final.vapoursynth.python3.pkgs
    // {inherit (final) vapoursynth;}
    // {
      hatch-cython = final.python3Packages.buildPythonPackage rec {
        pname = "hatch-cython";
        version = "0.6.0";

        format = "pyproject";

        src = final.fetchPypi {
          pname = "hatch_cython";
          inherit version;
          hash = "sha256-tkgLQXuRnrcTjhZl4RnbVwWFtIb6zGI+piyzAmQYrEw=";
        };

        nativeBuildInputs = with final.python3Packages; [
          hatchling
          cython
          setuptools
        ];

        pythonImportsCheck = ["hatch_cython"];
      };
    }
  );

  legacyBoost =
    if final ? boost183
    then final.boost183
    else if final ? boost182
    then final.boost182
    else final.boost;

  legacyOpenCLPluginBoost = path:
    final.callPackage path {
      boost = legacyBoost;
    };

  legacyOpenCLPluginBoost183 = path:
    final.callPackage path {
      boost183 = legacyBoost;
    };
in {
  vapoursynthPlugins = final.lib.recurseIntoAttrs rec {
    neo_f3kdb = final.callPackage ./plugins/deband/neo_f3kdb {};
    placebo = final.callPackage ./plugins/deband/placebo {};

    sneedif = callPythonPackage ./plugins/deinterlace/sneedif {};
    vivtc = final.callPackage ./plugins/deinterlace/vivtc {};
    znedi3 = final.callPackage ./plugins/deinterlace/znedi3 {};

    bm3d = final.callPackage ./plugins/denoise/bm3d {};
    bm3dcuda = final.callPackage ./plugins/denoise/bm3dcuda {};
    bm3dhip = final.callPackage ./plugins/denoise/bm3dhip {};
    knlmeanscl = callPythonPackage ./plugins/denoise/knlmeanscl {};
    nlm-ispc = final.callPackage ./plugins/denoise/nlm-ispc {};
    nlm-cuda = final.callPackage ./plugins/denoise/nlm-cuda {};
    tnlmeans = final.callPackage ./plugins/denoise/tnlmeans {};
    dfttest2 = final.callPackage ./plugins/denoise/dfttest2 {};
    dfttest2-cuda = final.callPackage ./plugins/denoise/dfttest2cuda {};
    dfttest2-hip = final.callPackage ./plugins/denoise/dfttest2hip {};
    wnnm = callPythonPackage ./plugins/denoise/wnnm {};

    vsnoise = final.callPackage ./plugins/grain/vs-noise {};

    awarp = final.callPackage ./plugins/mask/awarp {};
    edgemasks = final.callPackage ./plugins/mask/edgemasks {};

    vsmlrtmodels = final.callPackage ./plugins/ml/vs-mlrt/models {};
    vsncnn = final.callPackage ./plugins/ml/vs-mlrt/vsncnn {};
    vsort = final.callPackage ./plugins/ml/vs-mlrt/vsort {};
    vsort-cuda = final.callPackage ./plugins/ml/vs-mlrt/vsort-cuda {};
    vstrt = final.callPackage ./plugins/ml/vs-mlrt/vstrt {};
    vsmigx = final.callPackage ./plugins/ml/vs-mlrt/vsmigx {};
    vsov = final.callPackage ./plugins/ml/vs-mlrt/vsov {};

    manipmv = callPythonPackage ./plugins/motion/manipmv {};

    descale = final.callPackage ./plugins/resize/descale {};
    fmtconv = final.callPackage ./plugins/resize/fmtconv {};
    resize2 = callPythonPackage ./plugins/resize/resize2 {};

    d2vsource = final.callPackage ./plugins/source/d2vsource {};
    dvdsrc2 = callPythonPackage ./plugins/source/dvdsrc2 {};
    lsmashsource = final.callPackage ./plugins/source/lsmashsource {};
    readmpls = final.callPackage ./plugins/source/readmpls {};
    vsfpng = final.callPackage ./plugins/source/vsfpng {};

    ocr = final.callPackage ./plugins/subtitle/ocr {};
    subtext = final.callPackage ./plugins/subtitle/subtext {};
    vsfiltermod = final.callPackage ./plugins/subtitle/vsfiltermod {};

    akarin = callPythonPackage ./plugins/utility/akarin {};
    autocrop = final.callPackage ./plugins/utility/autocrop {};
    deblock = final.callPackage ./plugins/utility/deblock {};
    fillborders = final.callPackage ./plugins/utility/fillborders {};
    remap = final.callPackage ./plugins/utility/remap {};
    scxvid = final.callPackage ./plugins/utility/scxvid {};
    vship = final.callPackage ./plugins/utility/vship {};
    vszip = final.callPackage ./plugins/utility/vszip {};
    zsmooth = callPythonPackage ./plugins/utility/zsmooth {};
    hysteresis = callPythonPackage ./plugins/utility/hysteresis {};

    acsuite = callPythonPackage ./plugins/misc/acsuite {};
    awsmfunc = callPythonPackage ./plugins/misc/awsmfunc {};
    finedehalo = callPythonPackage ./plugins/misc/finedehalo {};
    jetpytools = callPythonPackage ./plugins/misc/jetpytools {};
    lvsfunc = callPythonPackage ./plugins/misc/lvsfunc {};
    rekt = callPythonPackage ./plugins/misc/rekt {};
    vsjetengine = callPythonPackage ./plugins/misc/vsjetengine {};
    vsjetpack = callPythonPackage ./plugins/misc/vsjetpack {
      inherit jetpytools;
    };
    vsutil = callPythonPackage ./plugins/misc/vsutil {};

    ffms2 = final.ffms;
    mvtools = final.vapoursynth-mvtools;
    bestsource = final.vapoursynth-bestsource;

    ## DEPRECATED
    adaptivegrain = final.callPackage ./plugins/deprecated/adaptivegrain {};
    addgrain = final.callPackage ./plugins/deprecated/addgrain {};
    adjust = callPythonPackage ./plugins/deprecated/adjust {};
    bilateral = final.callPackage ./plugins/deprecated/bilateral {};
    cas = final.callPackage ./plugins/deprecated/cas {};
    ctmf = final.callPackage ./plugins/deprecated/ctmf {};
    dctfilter = final.callPackage ./plugins/deprecated/dctfilter {};
    dfttest = final.callPackage ./plugins/deprecated/dfttest {};
    eedi2 = final.callPackage ./plugins/deprecated/eedi2 {};
    eedi3m = legacyOpenCLPluginBoost ./plugins/deprecated/eedi3m;
    eoefunc = callPythonPackage ./plugins/deprecated/eoefunc {};
    fft3dfilter = final.callPackage ./plugins/deprecated/fft3dfilter {};
    fvsfunc = callPythonPackage ./plugins/deprecated/fvsfunc {};
    fluxsmooth = final.callPackage ./plugins/deprecated/fluxsmooth {};
    havsfunc = callPythonPackage ./plugins/deprecated/havsfunc {};
    histogram = final.callPackage ./plugins/deprecated/histogram {};
    hqdn3d = final.callPackage ./plugins/deprecated/hqdn3d {};
    kagefunc = callPythonPackage ./plugins/deprecated/kagefunc {};
    median = final.callPackage ./plugins/deprecated/median {};
    miscfilters-obsolete =
      final.callPackage ./plugins/deprecated/miscfilters-obsolete {};
    mvsfunc = callPythonPackage ./plugins/deprecated/mvsfunc {};
    muvsfunc = callPythonPackage ./plugins/deprecated/muvsfunc {};
    nnedi3 = final.callPackage ./plugins/deprecated/nnedi3 {};
    nnedi3cl = legacyOpenCLPluginBoost183 ./plugins/deprecated/nnedi3cl;
    nnedi3_rpow2 = callPythonPackage ./plugins/deprecated/nnedi3_rpow2 {};
    nnedi3_resample =
      callPythonPackage ./plugins/deprecated/nnedi3_resample {};
    mt_lutspa = callPythonPackage ./plugins/deprecated/mt_lutspa {};
    retinex = final.callPackage ./plugins/deprecated/retinex {};
    sangnom = final.callPackage ./plugins/deprecated/sangnom {};
    tcanny = legacyOpenCLPluginBoost183 ./plugins/deprecated/tcanny;
    ttempsmooth = final.callPackage ./plugins/deprecated/ttempsmooth {};

    vardefunc = callPythonPackage ./plugins/deprecated/vardefunc {
      inherit lvsfunc vsjetpack;
    };

    wwxd = final.callPackage ./plugins/deprecated/wwxd {};
  };

  getnative = callPythonPackage ./tools/getnative {};
  nativeres = callPythonPackage ./tools/nativeres {};
  vsview = callPythonPackage ./tools/vsview {};
}
