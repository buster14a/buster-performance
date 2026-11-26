typedef unsigned int u32;

typedef u32 Vec4 __attribute__((vector_size(16)));
__attribute__((noinline)) void put_v4(Vec4* out, const u32* input, u32 seed)
{
    union { u32 lane[4]; Vec4 value; } scratch;
    scratch.lane[0] = input[0] + seed + 0u;
    scratch.lane[1] = input[1] + seed + 1u;
    scratch.lane[2] = input[2] + seed + 2u;
    scratch.lane[3] = input[3] + seed + 3u;
    *out = scratch.value;
}

typedef u32 Vec8 __attribute__((vector_size(32)));
__attribute__((noinline)) void put_v8(Vec8* out, const u32* input, u32 seed)
{
    union { u32 lane[8]; Vec8 value; } scratch;
    scratch.lane[0] = input[0] + seed + 0u;
    scratch.lane[1] = input[1] + seed + 1u;
    scratch.lane[2] = input[2] + seed + 2u;
    scratch.lane[3] = input[3] + seed + 3u;
    scratch.lane[4] = input[4] + seed + 4u;
    scratch.lane[5] = input[5] + seed + 5u;
    scratch.lane[6] = input[6] + seed + 6u;
    scratch.lane[7] = input[7] + seed + 7u;
    *out = scratch.value;
}

typedef u32 Vec16 __attribute__((vector_size(64)));
__attribute__((noinline)) void put_v16(Vec16* out, const u32* input, u32 seed)
{
    union { u32 lane[16]; Vec16 value; } scratch;
    scratch.lane[0] = input[0] + seed + 0u;
    scratch.lane[1] = input[1] + seed + 1u;
    scratch.lane[2] = input[2] + seed + 2u;
    scratch.lane[3] = input[3] + seed + 3u;
    scratch.lane[4] = input[4] + seed + 4u;
    scratch.lane[5] = input[5] + seed + 5u;
    scratch.lane[6] = input[6] + seed + 6u;
    scratch.lane[7] = input[7] + seed + 7u;
    scratch.lane[8] = input[8] + seed + 8u;
    scratch.lane[9] = input[9] + seed + 9u;
    scratch.lane[10] = input[10] + seed + 10u;
    scratch.lane[11] = input[11] + seed + 11u;
    scratch.lane[12] = input[12] + seed + 12u;
    scratch.lane[13] = input[13] + seed + 13u;
    scratch.lane[14] = input[14] + seed + 14u;
    scratch.lane[15] = input[15] + seed + 15u;
    *out = scratch.value;
}
