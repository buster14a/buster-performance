typedef char v64i8 __attribute__((vector_size(64)));
typedef unsigned long long u64;
u64 scan(const v64i8* blocks, unsigned count, const v64i8* k, u64* counts)
{
    u64 idents = counts[0];
    u64 lines = counts[1];
    u64 quotes = counts[2];
    u64 carry = 0;
    v64i8 acc = k[0] ^ k[0];
    for (unsigned i = 0; i < count; i += 1)
    {
        const v64i8 v = blocks[i];
        const v64i8 folded = v | k[6];
        const u64 letters = __builtin_ia32_ucmpb512_mask(folded - k[0], k[1], 2, (u64)-1);
        const u64 digits = __builtin_ia32_ucmpb512_mask(v - k[2], k[3], 2, (u64)-1);
        const u64 under = __builtin_ia32_cmpb512_mask(v, k[4], 0, (u64)-1);
        const u64 ident = letters | digits | under;
        const u64 starts = ident & ~((ident << 1) | carry);
        carry = ident >> 63;
        idents += (u64)__builtin_popcountll(starts);
        lines += (u64)__builtin_popcountll(__builtin_ia32_cmpb512_mask(v, k[5], 0, (u64)-1));
        quotes += (u64)__builtin_popcountll(__builtin_ia32_cmpb512_mask(v, k[7], 0, (u64)-1));
        acc = (acc + (v & k[6])) ^ (folded - acc);
    }
    counts[0] = idents;
    counts[1] = lines;
    counts[2] = quotes;
    return __builtin_ia32_cmpb512_mask(acc, k[0], 4, (u64)-1) ^ __builtin_ia32_cmpb512_mask(acc, k[6], 6, (u64)-1);
}
