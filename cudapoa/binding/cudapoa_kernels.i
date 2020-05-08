%module batch

%{
#include "cudapoa_kernels.cuh"

using namespace claragenomics::cudapoa;
%}

%include "cudapoa_kernels.cuh";
