// Candidate: one form of c_bindings_sort.
// count <= 16: stable ranks in one register (each lane's rank: the lanes with a smaller high half, and the earlier lanes
// with an equal one), then the keys stored at their ranks.
// Otherwise: LSD radix over the high half's bytes that vary (`varying`), each pass a counting loop, an in-register
// prefix sum of the 256 buckets, and a store of each key at its bucket's cursor.

static uint64_t* candidate_small(const uint64_t* keys, uint64_t* output, uint32_t count)
{
    const __mmask16 live = (__mmask16)_bzhi_u32(0xffffu, count);
    const __m512i high = digits16(keys, count, 32);
    const __m512i lane = _mm512_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
    __m512i rank = _mm512_setzero_si512();
    for (uint32_t j = 0; j < count; j += 1)
    {
        const __m512i other = _mm512_permutexvar_epi32(_mm512_set1_epi32((int32_t)j), high);
        const __mmask16 below = _mm512_mask_cmplt_epu32_mask(live, other, high);
        const __mmask16 equal = _mm512_mask_cmpeq_epu32_mask(live, other, high) & (__mmask16)(0xfffeu << j);
        rank = _mm512_mask_sub_epi32(rank, below | equal, rank, _mm512_set1_epi32(-1));
    }
    _Alignas(64) uint32_t ranks[16];
    _mm512_store_si512(ranks, rank);
    for (uint32_t i = 0; i < count; i += 1)
    {
        output[ranks[i]] = keys[i];
    }
    return output;
}

static uint64_t* candidate_sort(uint64_t* keys, uint64_t* temporary, uint32_t count, uint32_t varying)
{
    uint64_t* input = keys;
    if (count > 1 && count <= 16)
    {
        input = candidate_small(keys, temporary, count);
    }
    else if (count > 16)
    {
        uint64_t* output = temporary;
        for (uint32_t pass = 0; pass < 4; pass += 1)
        {
            if (((varying >> (pass * 8)) & 255) != 0)
            {
                _Alignas(64) uint32_t histogram[256];
                const uint32_t shift = 32 + pass * 8;
                for (uint32_t b = 0; b < 256; b += 16)
                {
                    _mm512_store_si512(histogram + b, _mm512_setzero_si512());
                }
                for (uint32_t i = 0; i < count; i += 1)
                {
                    histogram[(uint32_t)(input[i] >> shift) & 255] += 1;
                }
                __m512i carry = _mm512_setzero_si512();
                const __m512i zero = _mm512_setzero_si512();
                for (uint32_t b = 0; b < 256; b += 16)
                {
                    const __m512i frequency = _mm512_load_si512(histogram + b);
                    __m512i sum = _mm512_add_epi32(frequency, _mm512_alignr_epi32(frequency, zero, 15));
                    sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 14));
                    sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 12));
                    sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 8));
                    _mm512_store_si512(histogram + b, _mm512_add_epi32(carry, _mm512_sub_epi32(sum, frequency)));
                    carry = _mm512_add_epi32(carry, _mm512_permutexvar_epi32(_mm512_set1_epi32(15), sum));
                }
                for (uint32_t i = 0; i < count; i += 1)
                {
                    output[histogram[(uint32_t)(input[i] >> shift) & 255]++] = input[i];
                }
                uint64_t* swap = input;
                input = output;
                output = swap;
            }
        }
    }
    return input;
}
