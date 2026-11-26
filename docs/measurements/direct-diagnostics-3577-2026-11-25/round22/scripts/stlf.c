// stlf.c: cycles per iteration of a dependency chain through a store and a load: the store's data comes from the last
// load, the load reads bytes the store just wrote, at an offset into it. A jump in cycles means no store-to-load
// forwarding at that width and offset. Zen 5 (9700X), measured with rdtsc against a GPR store's chain.
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <x86intrin.h>

static uint8_t buf[16384] __attribute__((aligned(4096)));
#define N 2000000

#define CHAIN(name, store_asm, load_asm)                                                                                 \
static double name(uint8_t* st, uint8_t* ld)                                                                            \
{                                                                                                                       \
    uint64_t x = 0;                                                                                                     \
    uint64_t best = UINT64_MAX;                                                                                         \
    for (int rep = 0; rep < 5; rep += 1)                                                                                \
    {                                                                                                                   \
        uint64_t n = N;                                                                                                 \
        const uint64_t t0 = __rdtsc();                                                                                  \
        __asm__ volatile("1:\n\t" store_asm "\n\t" load_asm "\n\tdec %[n]\n\tjnz 1b"                                     \
                         : [x] "+r"(x), [n] "+r"(n) : [st] "r"(st), [ld] "r"(ld) : "xmm0", "xmm1", "rax", "k1", "memory", "cc");     \
        const uint64_t t1 = __rdtsc();                                                                                  \
        if (t1 - t0 < best) { best = t1 - t0; }                                                                         \
    }                                                                                                                   \
    return (double)best / N;                                                                                            \
}

// The store's data depends on x: a GPR store directly, a vector store through vmovq + broadcast.
CHAIN(gpr_q, "mov %[x], (%[st])", "mov (%[ld]), %[x]")
CHAIN(gpr_d, "mov %[x], (%[st])", "movl (%[ld]), %k[x]")
CHAIN(xmm_q, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%xmm0\n\tvmovdqu %%xmm0, (%[st])", "mov (%[ld]), %[x]")
CHAIN(ymm_q, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, (%[st])", "mov (%[ld]), %[x]")
CHAIN(ymm_d, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, (%[st])", "movl (%[ld]), %k[x]")
CHAIN(ymm_b, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, (%[st])", "movzbl (%[ld]), %k[x]")
CHAIN(zmm_q, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%zmm0\n\tvmovdqu64 %%zmm0, (%[st])", "mov (%[ld]), %[x]")
// The same chain with the vector reloaded whole (the store's own size), the forwarding case that always works.
CHAIN(ymm_y, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, (%[st])", "vmovdqu (%[ld]), %%ymm1\n\tvmovq %%xmm1, %[x]")
// Two overlapping 32-byte stores, the second (younger) at st, the first at st + 16: loads at offsets into the pair.
CHAIN(ymm2_q, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, 16(%[st])\n\tvmovdqu %%ymm0, (%[st])", "mov (%[ld]), %[x]")

// A byte-masked 32-byte store (all bytes but the last), a qword load at 0.
CHAIN(ymm_mask_q, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tmov $0x7fffffff, %%eax\n\tkmovd %%eax, %%k1\n\tvmovdqu8 %%ymm0, (%[st]) %{%%k1%}", "mov (%[ld]), %[x]")
// Two 4-byte stores (at 0 and 4), a qword load over both.
CHAIN(two_d_q, "mov %k[x], (%[st])\n\tmov %k[x], 4(%[st])", "mov (%[ld]), %[x]")
// 4K aliasing: the store at st, the load at st + 4096 (another address, the same low 12 bits), its result feeding the
// next store; against a load 64 bytes away. (The load doesn't read the store's bytes.)
CHAIN(alias_q, "mov %[x], (%[st])", "mov (%[ld]), %[x]")
// The same with a 32-byte store.
CHAIN(alias_ymm_q, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, (%[st])", "mov (%[ld]), %[x]")
// Vector loads from inside a larger vector store: the load's low qword goes back to x.
CHAIN(zmm_ymm, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%zmm0\n\tvmovdqu64 %%zmm0, (%[st])", "vmovdqu (%[ld]), %%ymm1\n\tvmovq %%xmm1, %[x]")
CHAIN(zmm_xmm, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%zmm0\n\tvmovdqu64 %%zmm0, (%[st])", "vmovdqu (%[ld]), %%xmm1\n\tvmovq %%xmm1, %[x]")
CHAIN(ymm_xmm, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, (%[st])", "vmovdqu (%[ld]), %%xmm1\n\tvmovq %%xmm1, %[x]")
CHAIN(zmm_zmm, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%zmm0\n\tvmovdqu64 %%zmm0, (%[st])", "vmovdqu64 (%[ld]), %%zmm1\n\tvmovq %%xmm1, %[x]")
// A ymm load spanning two ymm stores (offset 16 of a pair at 0 and 32).
CHAIN(ymm2_span, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%ymm0\n\tvmovdqu %%ymm0, (%[st])\n\tvmovdqu %%ymm0, 32(%[st])", "vmovdqu (%[ld]), %%ymm1\n\tvmovq %%xmm1, %[x]")
// The declarator's zeroing: two overlapping 64-byte stores, the older at st + 16, the younger at st; a dword load at
// an offset into both (as dr.attr.asm_label_len: st + 56), and loads only the older covers (st + 64 .. 79).
CHAIN(zmm2_d, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%zmm0\n\tvmovdqu64 %%zmm0, 16(%[st])\n\tvmovdqu64 %%zmm0, (%[st])", "movl (%[ld]), %k[x]")
CHAIN(zmm2_q, "vmovq %[x], %%xmm0\n\tvpbroadcastq %%xmm0, %%zmm0\n\tvmovdqu64 %%zmm0, 16(%[st])\n\tvmovdqu64 %%zmm0, (%[st])", "mov (%[ld]), %[x]")
// The same with zeros as the data (as a zeroing is): the chain then runs through the load's address instead.
CHAIN(zmm2_zero_addr, "vpxor %%xmm0, %%xmm0, %%xmm0\n\tvmovdqu64 %%zmm0, 16(%[st],%[x],1)\n\tvmovdqu64 %%zmm0, (%[st],%[x],1)", "movl (%[ld],%[x],1), %k[x]")
CHAIN(zmm1_zero_addr, "vpxor %%xmm0, %%xmm0, %%xmm0\n\tvmovdqu64 %%zmm0, (%[st],%[x],1)", "movl (%[ld],%[x],1), %k[x]")
CHAIN(gpr_zero_addr, "mov %[x], (%[st],%[x],1)", "movl (%[ld],%[x],1), %k[x]")
// Zero stores (data ready at once), the chain through the load's address: a single store at st (any alignment), a
// dword load at ld. Splits: where the store crosses a 64-byte line.
CHAIN(z1_zmm, "vpxor %%xmm0, %%xmm0, %%xmm0\n\tvmovdqu64 %%zmm0, (%[st],%[x],1)", "movl (%[ld],%[x],1), %k[x]")
CHAIN(z1_ymm, "vpxor %%xmm0, %%xmm0, %%xmm0\n\tvmovdqu %%ymm0, (%[st],%[x],1)", "movl (%[ld],%[x],1), %k[x]")
CHAIN(z1_xmm, "vpxor %%xmm0, %%xmm0, %%xmm0\n\tvmovdqu %%xmm0, (%[st],%[x],1)", "movl (%[ld],%[x],1), %k[x]")
CHAIN(z1_gpr, "movq $0, (%[st],%[x],1)", "movl (%[ld],%[x],1), %k[x]")

int main(int argc, char** argv)
{
    uint8_t* b = buf + 64;
    if (argc > 1)
    {
        // One case alone, for perf stat: "split" (a zero zmm store at line offset 56, a dword load 8 bytes into the
        // next line) or "aligned" (the store at offset 32, the load at the same address as split's).
        const int split = strcmp(argv[1], "split") == 0;
        double t = 0;
        for (int i = 0; i < 20; i += 1) { t += split ? z1_zmm(b + 56, b + 64) : z1_zmm(b + 32, b + 64); }
        printf("%s %.2f\n", argv[1], t / 20);
        return 0;
    }
    printf("gpr q@0 %.2f  gpr d@0 %.2f  gpr d@4 %.2f\n", gpr_q(b, b), gpr_d(b, b), gpr_d(b, b + 4));
    printf("ymm reloaded whole @0 %.2f\n", ymm_y(b, b));
    printf("xmm store, q load:");
    for (int k = 0; k <= 8; k += 4) { printf("  @%d %.2f", k, xmm_q(b, b + k)); }
    printf("\nymm store, q load:");
    for (int k = 0; k <= 24; k += 4) { printf("  @%d %.2f", k, ymm_q(b, b + k)); }
    printf("\nymm store, d load:");
    for (int k = 0; k <= 28; k += 4) { printf("  @%d %.2f", k, ymm_d(b, b + k)); }
    printf("\nymm store, b load:");
    for (int k = 0; k <= 31; k += 3) { printf("  @%d %.2f", k, ymm_b(b, b + k)); }
    printf("\nzmm store, q load:");
    for (int k = 0; k <= 56; k += 8) { printf("  @%d %.2f", k, zmm_q(b, b + k)); }
    printf("\ntwo ymm stores (younger at 0, older at 16), q load:");
    for (int k = 0; k <= 40; k += 8) { printf("  @%d %.2f", k, ymm2_q(b, b + k)); }
    printf("\nymm store at 64-byte offset 48 (crosses a line), q load:");
    for (int k = 0; k <= 24; k += 8) { printf("  @%d %.2f", k, ymm_q(b + 48, b + 48 + k)); }
    printf("\nmasked ymm store, q load @0 %.2f;  two dword stores, q load over both %.2f\n", ymm_mask_q(b, b), two_d_q(b, b));
    printf("gpr store, q load 4096 away %.2f, 64 away %.2f, 8192 away %.2f;  ymm store, q load 4096 away %.2f, 64 away %.2f\n",
           alias_q(b, b + 4096), alias_q(b, b + 64), alias_q(b, b + 8192), alias_ymm_q(b, b + 4096), alias_ymm_q(b, b + 64));
    printf("zmm store whole reload %.2f;  ymm load in a zmm store:", zmm_zmm(b, b));
    for (int k = 0; k <= 32; k += 8) { printf("  @%d %.2f", k, zmm_ymm(b, b + k)); }
    printf("\nxmm load in a zmm store:");
    for (int k = 0; k <= 48; k += 16) { printf("  @%d %.2f", k, zmm_xmm(b, b + k)); }
    printf("\nxmm load in a ymm store:");
    for (int k = 0; k <= 16; k += 8) { printf("  @%d %.2f", k, ymm_xmm(b, b + k)); }
    printf("\nymm load over two ymm stores @16 %.2f, @0 %.2f\n", ymm2_span(b, b + 16), ymm2_span(b, b));
    printf("two zmm stores (older at 16, younger at 0), d load:");
    for (int k = 0; k <= 76; k += 4) { printf(" @%d %.2f", k, zmm2_d(b, b + k)); }
    printf("\n  q load:");
    for (int k = 0; k <= 72; k += 8) { printf(" @%d %.2f", k, zmm2_q(b, b + k)); }
    printf("\nzeroing chains through the address: one zmm, d load @56 %.2f @0 %.2f; two zmm @56 %.2f @0 %.2f @64 %.2f; gpr %.2f\n",
           zmm1_zero_addr(b, b + 56), zmm1_zero_addr(b, b), zmm2_zero_addr(b, b + 56), zmm2_zero_addr(b, b), zmm2_zero_addr(b, b + 64), gpr_zero_addr(b, b));
    printf("zero zmm store at line offset S, dword load at store offset k (the chain through the address):\n");
    for (int so = 0; so < 64; so += 8)
    {
        printf("  S=%2d:", so);
        for (int k = 0; k < 64; k += 8) { printf(" %5.2f", z1_zmm(b + so, b + so + k)); }
        printf("\n");
    }
    printf("zero ymm store at S, dword load at k:\n");
    for (int so = 0; so < 64; so += 16)
    {
        printf("  S=%2d:", so);
        for (int k = 0; k < 32; k += 4) { printf(" %5.2f", z1_ymm(b + so, b + so + k)); }
        printf("\n");
    }
    printf("zero xmm store at S=56 (splits at 8), d load @0 %.2f @4 %.2f @8 %.2f @12 %.2f; at S=0: @8 %.2f; zero q store at S=60: @0 %.2f @4 %.2f\n",
           z1_xmm(b + 56, b + 56), z1_xmm(b + 56, b + 60), z1_xmm(b + 56, b + 64), z1_xmm(b + 56, b + 68), z1_xmm(b, b + 8), z1_gpr(b + 60, b + 60), z1_gpr(b + 60, b + 64));
    return 0;
}
