%module batch

%{
#include <claragenomics/utils/graph.hpp>
#include <claragenomics/utils/cudautils.hpp>
#include "cudapoa_batch.hpp"


using namespace claragenomics;
using namespace claragenomics::cudapoa;


namespace claragenomics {
namespace cudapoa {

    std::shared_ptr<Batch> create_batch(int32_t device_id,
                                    cudaStream_t stream,
                                    size_t max_mem,
                                    int8_t output_mask,
                                    int16_t gap_score,
                                    int16_t mismatch_score,
                                    int16_t match_score,
                                    bool cuda_banded_alignment,
                                    int32_t max_seq_sz = 1024,
                                    int32_t max_seq_per_poa = 100) {

        BatchSize batch_size = BatchSize(max_seq_sz, max_seq_per_poa);

        return std::make_unique<CudapoaBatch<int, int>>(
            device_id, stream, max_mem, output_mask, batch_size, 
            gap_score, mismatch_score, match_score, cuda_banded_alignment);
    }

}
}

%}

%include "claragenomics/cudapoa/batch.hpp";
