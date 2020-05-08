%module cudapoa_batch

%{
#include <claragenomics/utils/graph.hpp>
#include <claragenomics/utils/cudautils.hpp>
#include <claragenomics/cudapoa/batch.hpp>
#include "cudapoa_batch.hpp"

#include <cuda_runtime_api.h>
#include "cudapoa_kernels.cuh"

using namespace claragenomics;
using namespace claragenomics::cudapoa;
%}

%include "typemaps.i"
%include "stdint.i"
%apply int32_t *OUTPUT { int32_t *length }

%include "std_string.i" 

%include "cudapoa_batch.hpp";
%ignore claragenomics::cudapoa::CudapoaBatch< int,int >::batches;

%template(CudapoaBatch) claragenomics::cudapoa::CudapoaBatch<int, int>;
