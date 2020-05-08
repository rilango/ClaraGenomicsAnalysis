%module batch

%{
#include <claragenomics/utils/graph.hpp>
#include <claragenomics/utils/cudautils.hpp>
#include "cudapoa_batch.hpp"


using namespace claragenomics;
using namespace claragenomics::cudapoa;
%}

%include "claragenomics/cudapoa/batch.hpp";
