{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  vapoursynth,
  mkl,
}:
stdenv.mkDerivation rec {
  pname = "vapoursynth-wnnm";
  version = "3";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "VapourSynth-WNNM";
    rev = "v${version}";
    hash = "sha256-fPtHaDrG1Ku1/Uv0Bh3hUfqbOEyfnhFVFblspRhHqlE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    vapoursynth
    mkl
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DVS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'install(TARGETS wnnm LIBRARY RUNTIME)' \
        'install(TARGETS wnnm LIBRARY DESTINATION lib/vapoursynth)'

      substituteInPlace source/wnnm.cpp \
        --replace-fail 'int * VS_RESTRICT svd_iwork' 'MKL_INT * VS_RESTRICT svd_iwork' \
        --replace-fail 'int * svd_iwork' 'MKL_INT * svd_iwork' \
        --replace-fail 'vs_aligned_malloc<int>' 'vs_aligned_malloc<MKL_INT>' \
        --replace-fail 'int m = square(block_size);' 'MKL_INT m = square(block_size);' \
        --replace-fail 'int n = active_group_size;' 'MKL_INT n = active_group_size;' \
        --replace-fail 'int k = 1;' 'MKL_INT k = 1;' \
        --replace-fail 'int svd_info;' 'MKL_INT svd_info;' \
        --replace-fail 'int svd_lwork' 'MKL_INT svd_lwork' \
        --replace-fail 'int svd_lda' 'MKL_INT svd_lda' \
        --replace-fail 'int svd_ldu' 'MKL_INT svd_ldu' \
        --replace-fail 'int svd_ldvt' 'MKL_INT svd_ldvt' \
        --replace-fail 'std::min(m, n)' 'std::min<MKL_INT>(m, n)'
  '';

  meta = with lib; {
    description = "Weighted Nuclear Norm Minimization denoiser for VapourSynth";
    homepage = "https://github.com/AmusementClub/VapourSynth-WNNM";
    license = licenses.mit;
    maintainers = with maintainers; [humanlyhuman];
    platforms = platforms.linux;
  };
}
