// The per-unit kernels of a build's header images, timed alone, on 1 to N lanes (threads pinned one a core), each lane
// with its own unit state and every lane reading the same images. An experiment for the design, not compiler code.
//   validate: an image's observed names against the unit's macro definitions (definition ids by name id)
//   apply:    an image's macro effects written into the unit's definitions
//   reach:    the unit's own names tested against the images' declared-names bitset, the reached ones compressed out
//   copy:     reached declarations' token rows copied into the unit's view
// Each in a scalar form and an AVX-512 form. Prints TSC ticks a unit and a name (or row).
#define _GNU_SOURCE
#include <immintrin.h>
#include <pthread.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>

#define NAMES 65536u
#define IMAGES 4096u

typedef struct
{
    uint32_t count;
    uint32_t* ids;      // sorted name ids it observed
    uint32_t* defs;     // the definitions they had
    uint32_t effects;
    uint32_t* effect_ids;
    uint32_t* effect_defs;
} Image;

static Image images[IMAGES];
static uint32_t* image_rows;     // token rows of reached declarations: 16 bytes a token (kind, flags, value, location)
static uint64_t declared_bits[NAMES / 64];
static uint32_t root_defs[NAMES];

static uint32_t observed_size = 64;   // names an image observed
static uint32_t effect_size = 4;      // macros an image sets
static uint32_t images_per_unit = 12; // musl: 15,712 inclusions for 1,336 units
static uint32_t own_names = 256;      // musl: 342,572 own tokens for 1,336 units, about half of them names
static uint32_t copy_rows = 600;      // tokens of reached declarations a unit
static uint32_t lanes = 1;
static uint32_t units = 20000;

static uint64_t rng = 0x9e3779b97f4a7c15ull;
static uint32_t next_random(void)
{
    rng ^= rng << 13;
    rng ^= rng >> 7;
    rng ^= rng << 17;
    return (uint32_t)rng;
}

static int compare_u32(const void* a, const void* b)
{
    const uint32_t x = *(const uint32_t*)a;
    const uint32_t y = *(const uint32_t*)b;
    return x < y ? -1 : x > y;
}

static void make_images(void)
{
    for (uint32_t n = 0; n < NAMES; n += 1)
    {
        root_defs[n] = (next_random() % 8 == 0) ? next_random() | 1 : 0; // an eighth of the names are macros
    }
    for (uint32_t i = 0; i < IMAGES; i += 1)
    {
        Image* image = &images[i];
        image->count = observed_size;
        image->ids = aligned_alloc(64, ((observed_size + 15) / 16) * 64);
        image->defs = aligned_alloc(64, ((observed_size + 15) / 16) * 64);
        for (uint32_t k = 0; k < observed_size; k += 1)
        {
            image->ids[k] = next_random() % NAMES;
        }
        qsort(image->ids, observed_size, sizeof(uint32_t), compare_u32);
        for (uint32_t k = 0; k < observed_size; k += 1)
        {
            image->defs[k] = root_defs[image->ids[k]];
        }
        image->effects = effect_size;
        image->effect_ids = aligned_alloc(64, ((effect_size + 16) / 16) * 64);
        image->effect_defs = aligned_alloc(64, ((effect_size + 16) / 16) * 64);
        for (uint32_t k = 0; k < effect_size; k += 1)
        {
            // A macro an image sets is one it doesn't observe, and the unit's later images see it as the root has it.
            image->effect_ids[k] = next_random() % NAMES;
            image->effect_defs[k] = root_defs[image->effect_ids[k]];
        }
    }
    for (uint32_t n = 0; n < NAMES / 64; n += 1)
    {
        declared_bits[n] = ((uint64_t)next_random() << 32 | next_random()) & ((uint64_t)next_random() << 32 | next_random()) & ((uint64_t)next_random() << 32 | next_random());
    }
    image_rows = aligned_alloc(64, (size_t)copy_rows * 16 * 64);
    for (uint32_t r = 0; r < copy_rows * 64 * 4; r += 1)
    {
        image_rows[r] = next_random();
    }
}

typedef struct
{
    uint32_t lane;
    uint32_t cpu;
    uint32_t* defs;
    uint32_t* own;
    uint32_t* reached;
    uint32_t* view;
    uint64_t ticks[8];
    uint64_t sink;
} Lane;

static pthread_barrier_t barrier;

static __attribute__((noinline)) uint32_t validate_scalar(const uint32_t* defs, const Image* image)
{
    uint32_t bad = 0;
    for (uint32_t k = 0; k < image->count; k += 1)
    {
        bad |= defs[image->ids[k]] ^ image->defs[k];
    }
    return bad;
}

static __attribute__((noinline)) uint32_t validate_gather(const uint32_t* defs, const Image* image)
{
    __mmask16 bad = 0;
    uint32_t k = 0;
    for (; k + 16 <= image->count; k += 16)
    {
        const __m512i ids = _mm512_load_si512(image->ids + k);
        const __m512i got = _mm512_i32gather_epi32(ids, (const int*)defs, 4);
        bad |= _mm512_cmpneq_epi32_mask(got, _mm512_load_si512(image->defs + k));
    }
    if (k < image->count)
    {
        const __mmask16 m = (__mmask16)((1u << (image->count - k)) - 1);
        const __m512i ids = _mm512_maskz_loadu_epi32(m, image->ids + k);
        const __m512i got = _mm512_mask_i32gather_epi32(_mm512_setzero_si512(), m, ids, (const int*)defs, 4);
        bad |= _mm512_mask_cmpneq_epi32_mask(m, got, _mm512_maskz_loadu_epi32(m, image->defs + k));
    }
    return bad;
}

static __attribute__((noinline)) void apply_scalar(uint32_t* defs, const Image* image)
{
    for (uint32_t k = 0; k < image->effects; k += 1)
    {
        defs[image->effect_ids[k]] = image->effect_defs[k];
    }
}

static __attribute__((noinline)) void apply_scatter(uint32_t* defs, const Image* image)
{
    uint32_t k = 0;
    for (; k < image->effects; k += 16)
    {
        const __mmask16 m = image->effects - k >= 16 ? 0xffff : (__mmask16)((1u << (image->effects - k)) - 1);
        const __m512i ids = _mm512_maskz_loadu_epi32(m, image->effect_ids + k);
        _mm512_mask_i32scatter_epi32(defs, m, ids, _mm512_maskz_loadu_epi32(m, image->effect_defs + k), 4);
    }
}

static __attribute__((noinline)) uint32_t reach_scalar(const uint32_t* own, uint32_t count, uint32_t* reached)
{
    uint32_t n = 0;
    for (uint32_t k = 0; k < count; k += 1)
    {
        const uint32_t id = own[k];
        reached[n] = id;
        n += (uint32_t)(declared_bits[id / 64] >> (id % 64)) & 1;
    }
    return n;
}

static __attribute__((noinline)) uint32_t reach_vector(const uint32_t* own, uint32_t count, uint32_t* reached)
{
    uint32_t n = 0;
    const uint32_t* words = (const uint32_t*)declared_bits;
    for (uint32_t k = 0; k < count; k += 16)
    {
        const __mmask16 m = count - k >= 16 ? 0xffff : (__mmask16)((1u << (count - k)) - 1);
        const __m512i ids = _mm512_maskz_loadu_epi32(m, own + k);
        const __m512i word = _mm512_mask_i32gather_epi32(_mm512_setzero_si512(), m, _mm512_srli_epi32(ids, 5), (const int*)words, 4);
        const __m512i bit = _mm512_srlv_epi32(word, _mm512_and_si512(ids, _mm512_set1_epi32(31)));
        const __mmask16 hit = _mm512_mask_test_epi32_mask(m, bit, _mm512_set1_epi32(1));
        _mm512_mask_compressstoreu_epi32(reached + n, hit, ids);
        n += (uint32_t)__builtin_popcount(hit);
    }
    return n;
}

static __attribute__((noinline)) void copy_scalar(uint32_t* view, const uint32_t* rows, uint32_t count)
{
    for (uint32_t r = 0; r < count * 4; r += 1)
    {
        view[r] = rows[r];
    }
}

static __attribute__((noinline)) void copy_vector(uint32_t* view, const uint32_t* rows, uint32_t count)
{
    for (uint32_t r = 0; r < count * 4; r += 16)
    {
        _mm512_storeu_si512(view + r, _mm512_loadu_si512(rows + r));
    }
}

static void* run_lane(void* argument)
{
    Lane* lane = argument;
    cpu_set_t set;
    CPU_ZERO(&set);
    CPU_SET(lane->cpu, &set);
    pthread_setaffinity_np(pthread_self(), sizeof set, &set);
    lane->defs = aligned_alloc(64, NAMES * sizeof(uint32_t));
    lane->own = aligned_alloc(64, ((own_names + 15) / 16) * 64);
    lane->reached = aligned_alloc(64, ((own_names + 16) / 16) * 64);
    lane->view = aligned_alloc(64, (size_t)copy_rows * 16 + 64);
    uint64_t local = 0x1234 + lane->lane;
    for (uint32_t mode = 0; mode < 8; mode += 1)
    {
        memcpy(lane->defs, root_defs, sizeof root_defs);
        pthread_barrier_wait(&barrier);
        uint64_t sink = 0;
        const uint64_t start = __rdtsc();
        for (uint32_t u = 0; u < units; u += 1)
        {
            local ^= local << 13; local ^= local >> 7; local ^= local << 17;
            const uint32_t first = (uint32_t)(local % (IMAGES - images_per_unit));
            if (mode == 0 || mode == 1)
            {
                for (uint32_t i = 0; i < images_per_unit; i += 1)
                {
                    sink += mode == 0 ? validate_scalar(lane->defs, &images[first + i]) : validate_gather(lane->defs, &images[first + i]);
                }
            }
            else if (mode == 2 || mode == 3)
            {
                for (uint32_t i = 0; i < images_per_unit; i += 1)
                {
                    if (mode == 2) apply_scalar(lane->defs, &images[first + i]); else apply_scatter(lane->defs, &images[first + i]);
                }
            }
            else if (mode == 4 || mode == 5)
            {
                for (uint32_t k = 0; k < own_names; k += 1)
                {
                    local ^= local << 13; local ^= local >> 7; local ^= local << 17;
                    lane->own[k] = (uint32_t)(local % NAMES);
                }
                sink += mode == 4 ? reach_scalar(lane->own, own_names, lane->reached) : reach_vector(lane->own, own_names, lane->reached);
            }
            else
            {
                const uint32_t* rows = image_rows + (size_t)(first % 64) * copy_rows * 4;
                if (mode == 6) copy_scalar(lane->view, rows, copy_rows); else copy_vector(lane->view, rows, copy_rows);
                sink += lane->view[first % copy_rows];
            }
        }
        lane->ticks[mode] = __rdtsc() - start;
        lane->sink += sink;
        pthread_barrier_wait(&barrier);
    }
    return 0;
}

int main(int argc, char** argv)
{
    // image_kernels LANES CPU,CPU,... [observed effects images_per_unit own_names copy_rows units]
    lanes = (uint32_t)atoi(argv[1]);
    uint32_t cpus[64];
    char* list = strdup(argv[2]);
    uint32_t c = 0;
    for (char* t = strtok(list, ","); t != 0 && c < 64; t = strtok(0, ","))
    {
        cpus[c++] = (uint32_t)atoi(t);
    }
    if (argc > 3) observed_size = (uint32_t)atoi(argv[3]);
    if (argc > 4) effect_size = (uint32_t)atoi(argv[4]);
    if (argc > 5) images_per_unit = (uint32_t)atoi(argv[5]);
    if (argc > 6) own_names = (uint32_t)atoi(argv[6]);
    if (argc > 7) copy_rows = (uint32_t)atoi(argv[7]);
    if (argc > 8) units = (uint32_t)atoi(argv[8]);
    make_images();
    pthread_barrier_init(&barrier, 0, lanes);
    Lane* all = calloc(lanes, sizeof(Lane));
    pthread_t threads[64];
    for (uint32_t l = 0; l < lanes; l += 1)
    {
        all[l].lane = l;
        all[l].cpu = cpus[l % c];
        pthread_create(&threads[l], 0, run_lane, &all[l]);
    }
    for (uint32_t l = 0; l < lanes; l += 1)
    {
        pthread_join(threads[l], 0);
    }
    const char* names[8] = { "validate-scalar", "validate-gather", "apply-scalar", "apply-scatter", "reach-scalar", "reach-vector", "copy-scalar", "copy-vector" };
    const double per[8] = { (double)observed_size * images_per_unit, (double)observed_size * images_per_unit, (double)effect_size * images_per_unit, (double)effect_size * images_per_unit,
                            own_names, own_names, copy_rows, copy_rows };
    uint64_t sink = 0;
    for (uint32_t mode = 0; mode < 8; mode += 1)
    {
        double worst = 0;
        double sum = 0;
        for (uint32_t l = 0; l < lanes; l += 1)
        {
            const double t = (double)all[l].ticks[mode] / units;
            worst = t > worst ? t : worst;
            sum += t;
            sink += all[l].sink;
        }
        printf("%s\tlanes %u\tobserved %u\teffects %u\timages %u\town %u\trows %u\tticks/unit %.1f (worst lane %.1f)\tticks/item %.3f\n", names[mode], lanes, observed_size,
               effect_size, images_per_unit, own_names, copy_rows, sum / lanes, worst, sum / lanes / per[mode]);
    }
    fprintf(stderr, "sink %llu\n", (unsigned long long)sink);
    return 0;
}
