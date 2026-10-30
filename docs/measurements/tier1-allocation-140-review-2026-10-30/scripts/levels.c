// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Measurement harness for buster #140's review (buster-performance record).
// Scratch prototype for the #140 review: register assignment of one class (32 registers) over the instruction stream,
// three ways, on the same kills:
//   - lowest-free: a free mask in a register, each definition takes tzcnt (stream.c's assignment, one class);
//   - levels, scalar: the LIFO "level" rule of tier1_allocation_color (a kill at height h deposits its register at
//     level h - 1; a definition at height h takes level h's register), in event order;
//   - levels, AVX-512: the same rule, 21 instructions (63 events: two use slots and a definition each) per 64-byte
//     chunk, all in registers. Heights are a prefix sum; each definition's partner (the last kill at its level) is
//     the last earlier lane whose height reaches its own, found by a 6-step descent over window maxima; registers
//     flow by 6 rounds of vpermb pointer jumping. Only a 32-level register state and the height cross chunks, so
//     everything else of chunk n+1 can run while chunk n finishes.
// The vector kernel must reproduce the scalar levels twin byte for byte; every result is checked by simulation.
#include "levels_head.c"

static __attribute__((noinline)) bool stream_assign_lowest(Stream* stream)
{
    const Stream s = *stream;
    uint32_t free = UINT32_MAX;
    uint32_t lost = 0;
    for (uint32_t i = 0; i < s.count; i += 1)
    {
        for (uint32_t k = 0; k < SLOTS; k += 1)
        {
            const uint32_t slot = i * SLOTS + k;
            const uint32_t r = s.value_register[s.ops[slot]];
            s.physical[slot] = (uint8_t)r;
            free |= (uint32_t)s.kill[slot] << r;
        }
        lost |= free == 0;
        const uint32_t r = (uint32_t)__builtin_ctz(free | 0x80000000u);
        free &= free - 1;
        s.value_register[i] = (uint8_t)r;
        s.def_physical[i] = (uint8_t)r;
    }
    return lost == 0;
}

static __attribute__((noinline)) bool stream_assign_levels(Stream* stream)
{
    const Stream s = *stream;
    uint8_t state[64];
    for (uint32_t d = 0; d < 64; d += 1)
    {
        state[d] = (uint8_t)d;
    }
    uint32_t height = 0;
    uint32_t peak = 0;
    for (uint32_t i = 0; i < s.count; i += 1)
    {
        for (uint32_t k = 0; k < SLOTS; k += 1)
        {
            const uint32_t slot = i * SLOTS + k;
            const uint8_t r = s.value_register[s.ops[slot]];
            s.physical[slot] = r;
            height -= s.kill[slot];
            state[height & 63] = s.kill[slot] != 0 ? r : state[height & 63];
        }
        const uint8_t r = state[height & 63];
        height += 1;
        peak = height > peak ? height : peak;
        s.value_register[i] = r;
        s.def_physical[i] = r;
    }
    return peak <= 32;
}

#define CHUNK_INSTRUCTIONS 21

typedef struct LevelConstants LevelConstants;
struct LevelConstants
{
    __m512i lane;              // 0..63
    __m512i shift_index[6];    // lane - 2^k
    __mmask64 shift_mask[6];   // lane >= 2^k
    __m512i slot_of_lane;      // use lane 3i+k -> slot 2i+k
    __m512i lane_of_slot;      // slot 2i+k -> lane 3i+k
    __m512i def_lane;          // instruction i -> lane 3i+2
    __m512i level_threshold;   // relative threshold q - 31 for the state descent's lane q
    __mmask64 use_lanes;
    __mmask64 def_lanes;
};

static LevelConstants level_constants(void)
{
    LevelConstants c = { 0 };
    uint8_t lane[64];
    uint8_t slot_of_lane[64];
    uint8_t lane_of_slot[64];
    uint8_t def_lane[64];
    int8_t threshold[64];
    for (uint32_t l = 0; l < 64; l += 1)
    {
        lane[l] = (uint8_t)l;
        slot_of_lane[l] = (uint8_t)(l < 63 && l % 3 < 2 ? 2 * (l / 3) + l % 3 : 0);
        lane_of_slot[l] = (uint8_t)(l < 42 ? 3 * (l / 2) + l % 2 : 63);
        def_lane[l] = (uint8_t)(l < CHUNK_INSTRUCTIONS ? 3 * l + 2 : 63);
        threshold[l] = (int8_t)((int32_t)l - 31);
        if (l < 63 && l % 3 < 2)
        {
            c.use_lanes |= 1ull << l;
        }
        if (l < 63 && l % 3 == 2)
        {
            c.def_lanes |= 1ull << l;
        }
    }
    c.lane = _mm512_loadu_si512(lane);
    for (uint32_t k = 0; k < 6; k += 1)
    {
        c.shift_index[k] = _mm512_sub_epi8(c.lane, _mm512_set1_epi8((char)(1 << k)));
        c.shift_mask[k] = ~((1ull << (1 << k)) - 1);
    }
    c.slot_of_lane = _mm512_loadu_si512(slot_of_lane);
    c.lane_of_slot = _mm512_loadu_si512(lane_of_slot);
    c.def_lane = _mm512_loadu_si512(def_lane);
    c.level_threshold = _mm512_loadu_si512(threshold);
    return c;
}

// Last lane j <= start with values[j] >= threshold, per lane, by skipping windows of 32..1 lanes whose maximum is
// below the threshold (window maxima[k][j] = max(values[j - 2^k + 1 .. j])). Lanes without one end negative.
static inline __m512i level_descent(const __m512i* maxima, __m512i start, __m512i threshold)
{
    const __m512i below = _mm512_set1_epi8(-128);
    __m512i position = start;
    for (int32_t k = 5; k >= 0; k -= 1)
    {
        const __mmask64 valid = ~_mm512_movepi8_mask(position);
        const __m512i window = _mm512_mask_permutexvar_epi8(below, valid, position, maxima[k]);
        const __mmask64 skip = _mm512_cmplt_epi8_mask(window, threshold);
        position = _mm512_mask_sub_epi8(position, skip, position, _mm512_set1_epi8((char)(1 << k)));
    }
    return position;
}

static __attribute__((noinline)) bool stream_assign_levels_avx512(Stream* stream, const LevelConstants* constants)
{
    const Stream s = *stream;
    const LevelConstants c = *constants;
    const __m512i zero = _mm512_setzero_si512();
    const __m512i one = _mm512_set1_epi8(1);
    const __m512i below = _mm512_set1_epi8(-128);
    __m512i state = c.lane;
    __m512i carry = zero;
    __mmask64 overflow = 0;
    for (uint32_t first = 0; first < s.count; first += CHUNK_INSTRUCTIONS)
    {
        const uint32_t remaining = s.count - first;
        const uint32_t n = remaining < CHUNK_INSTRUCTIONS ? remaining : CHUNK_INSTRUCTIONS;
        const uint32_t slots = n * SLOTS;
        const uint32_t last = n * 3 - 1;
        const __mmask64 valid_lanes = last == 62 ? (1ull << 63) - 1 : (1ull << (last + 1)) - 1;
        const __mmask64 use_lanes = c.use_lanes & valid_lanes;
        const __mmask64 def_lanes = c.def_lanes & valid_lanes;
        // Kills to per-lane deltas, then the chunk's own prefix sum (carry-free) and its window maxima.
        const __m512i kill_slots = _mm512_maskz_loadu_epi8(slots == 64 ? ~0ull : (1ull << slots) - 1, s.kill + first * SLOTS);
        const __m512i kills = _mm512_maskz_permutexvar_epi8(use_lanes, c.slot_of_lane, kill_slots);
        __m512i prefix = _mm512_sub_epi8(_mm512_maskz_mov_epi8(def_lanes, one), kills);
        for (uint32_t k = 0; k < 6; k += 1)
        {
            prefix = _mm512_add_epi8(prefix, _mm512_maskz_permutexvar_epi8(c.shift_mask[k], c.shift_index[k], prefix));
        }
        __m512i maxima[6];
        maxima[0] = prefix;
        for (uint32_t k = 1; k < 6; k += 1)
        {
            maxima[k] = _mm512_max_epi8(maxima[k - 1], _mm512_mask_permutexvar_epi8(below, c.shift_mask[k - 1], c.shift_index[k - 1], maxima[k - 1]));
        }
        // Each definition's partner: the kill after the last earlier lane whose height reaches the definition's.
        const __m512i position = level_descent(maxima, _mm512_sub_epi8(c.lane, one), prefix);
        const __mmask64 found = def_lanes & ~_mm512_movepi8_mask(position);
        const __mmask64 entry = def_lanes & ~found & _mm512_cmple_epi8_mask(prefix, zero);
        const __mmask64 external = def_lanes & ~found & ~entry;
        // Use slots: their value's definition lane in this chunk, or a register already assigned.
        uint64_t internal_slots = 0;
        uint64_t none_slots = 0;
        __m128i lanes_of_values[3];
        for (uint32_t g = 0; g < 3; g += 1)
        {
            const uint32_t base = g * 16;
            const __mmask16 group = (__mmask16)(slots > base ? (slots - base >= 16 ? 0xffff : (1u << (slots - base)) - 1) : 0);
            const __m512i values = _mm512_maskz_loadu_epi32(group, s.ops + first * SLOTS + base);
            const __m512i relative = _mm512_sub_epi32(values, _mm512_set1_epi32((int32_t)first));
            const __mmask16 internal = group & _mm512_cmplt_epu32_mask(relative, _mm512_set1_epi32((int32_t)n));
            const __mmask16 none = group & _mm512_cmpeq_epi32_mask(values, _mm512_set1_epi32((int32_t)s.none));
            const __m512i lane_of_value = _mm512_add_epi32(_mm512_add_epi32(relative, _mm512_add_epi32(relative, relative)), _mm512_set1_epi32(2));
            lanes_of_values[g] = _mm512_cvtepi32_epi8(lane_of_value);
            internal_slots |= (uint64_t)internal << base;
            none_slots |= (uint64_t)none << base;
        }
        __m512i slot_value_lanes = _mm512_castsi128_si512(lanes_of_values[0]);
        slot_value_lanes = _mm512_inserti32x4(slot_value_lanes, lanes_of_values[1], 1);
        slot_value_lanes = _mm512_inserti32x4(slot_value_lanes, lanes_of_values[2], 2);
        const __m512i value_lanes = _mm512_permutexvar_epi8(c.slot_of_lane, slot_value_lanes);
        const __mmask64 internal_lanes = use_lanes & _mm512_test_epi8_mask(_mm512_permutexvar_epi8(c.slot_of_lane, _mm512_maskz_mov_epi8(internal_slots, one)), one);
        // Roots point at themselves and hold their register; every other lane points at its source lane.
        __m512i pointer = c.lane;
        pointer = _mm512_mask_mov_epi8(pointer, found, _mm512_add_epi8(position, one));
        pointer = _mm512_mask_mov_epi8(pointer, entry, zero);
        pointer = _mm512_mask_mov_epi8(pointer, internal_lanes, value_lanes);
        __m512i registers = _mm512_maskz_permutexvar_epi8(external, _mm512_add_epi8(_mm512_add_epi8(prefix, carry), _mm512_set1_epi8(-1)), state);
        uint64_t external_slots = ((slots == 64 ? ~0ull : (1ull << slots) - 1)) & ~internal_slots & ~none_slots;
        while (external_slots != 0)
        {
            const uint32_t slot = (uint32_t)__builtin_ctzll(external_slots);
            external_slots &= external_slots - 1;
            const uint32_t lane = 3 * (slot / 2) + slot % 2;
            registers = _mm512_mask_set1_epi8(registers, 1ull << lane, (char)s.value_register[s.ops[first * SLOTS + slot]]);
        }
        for (uint32_t round = 0; round < 6; round += 1)
        {
            pointer = _mm512_permutexvar_epi8(pointer, pointer);
        }
        registers = _mm512_permutexvar_epi8(pointer, registers);
        // The state for the next chunk: per relative level, the lane of the last kill that deposited there.
        const __m512i level_position = level_descent(maxima, _mm512_set1_epi8((char)last), c.level_threshold);
        const __mmask64 level_found = ~_mm512_movepi8_mask(level_position);
        const __mmask64 level_entry = ~level_found & _mm512_cmple_epi8_mask(c.level_threshold, zero);
        __m512i level_lane = _mm512_mask_mov_epi8(below, level_found, _mm512_add_epi8(level_position, one));
        level_lane = _mm512_mask_mov_epi8(level_lane, level_entry, zero);
        const __m512i absolute = _mm512_permutexvar_epi8(_mm512_sub_epi8(_mm512_add_epi8(c.lane, _mm512_set1_epi8(32)), carry), level_lane);
        state = _mm512_mask_permutexvar_epi8(state, ~_mm512_movepi8_mask(absolute), absolute, registers);
        overflow |= _mm512_cmpgt_epi8_mask(_mm512_add_epi8(prefix, carry), _mm512_set1_epi8(32)) & valid_lanes;
        carry = _mm512_add_epi8(carry, _mm512_permutexvar_epi8(_mm512_set1_epi8((char)last), prefix));
        // Outputs: 64-byte stores into columns with 64 bytes of slack.
        const __m512i definitions = _mm512_permutexvar_epi8(c.def_lane, registers);
        _mm512_storeu_si512(s.value_register + first, definitions);
        _mm512_storeu_si512(s.def_physical + first, definitions);
        _mm512_storeu_si512(s.physical + first * SLOTS, _mm512_permutexvar_epi8(c.lane_of_slot, registers));
    }
    return overflow == 0;
}

static inline __m512i level_descent2(const __m512i* maxima, __m512i start, __m512i threshold)
{
    const __m512i below = _mm512_set1_epi8(-128);
    __m512i position = start;
    for (int32_t k = 5; k >= 0; k -= 1)
    {
        // Negative positions have bit 6 set, so the two-table permute reads -128 from below for them.
        const __m512i window = _mm512_permutex2var_epi8(maxima[k], position, below);
        const __mmask64 skip = _mm512_cmplt_epi8_mask(window, threshold);
        position = _mm512_mask_sub_epi8(position, skip, position, _mm512_set1_epi8((char)(1 << k)));
    }
    return position;
}

static __attribute__((noinline)) bool stream_assign_levels_avx512_v2(Stream* stream, const LevelConstants* constants)
{
    const Stream s = *stream;
    const LevelConstants c = *constants;
    const __m512i zero = _mm512_setzero_si512();
    const __m512i one = _mm512_set1_epi8(1);
    const __m512i below = _mm512_set1_epi8(-128);
    __m512i state = c.lane;
    __m512i carry = zero;
    __m512i previous_registers = zero;
    __mmask64 overflow = 0;
    for (uint32_t first = 0; first < s.count; first += CHUNK_INSTRUCTIONS)
    {
        const uint32_t remaining = s.count - first;
        const uint32_t n = remaining < CHUNK_INSTRUCTIONS ? remaining : CHUNK_INSTRUCTIONS;
        const uint32_t slots = n * SLOTS;
        const uint32_t last = n * 3 - 1;
        const __mmask64 valid_lanes = last == 62 ? (1ull << 63) - 1 : (1ull << (last + 1)) - 1;
        const __mmask64 use_lanes = c.use_lanes & valid_lanes;
        const __mmask64 def_lanes = c.def_lanes & valid_lanes;
        // Kills to per-lane deltas, then the chunk's own prefix sum (carry-free) and its window maxima.
        const __m512i kill_slots = _mm512_maskz_loadu_epi8(slots == 64 ? ~0ull : (1ull << slots) - 1, s.kill + first * SLOTS);
        const __m512i kills = _mm512_maskz_permutexvar_epi8(use_lanes, c.slot_of_lane, kill_slots);
        __m512i prefix = _mm512_sub_epi8(_mm512_maskz_mov_epi8(def_lanes, one), kills);
        for (uint32_t k = 0; k < 6; k += 1)
        {
            prefix = _mm512_add_epi8(prefix, _mm512_maskz_permutexvar_epi8(c.shift_mask[k], c.shift_index[k], prefix));
        }
        __m512i maxima[6];
        maxima[0] = prefix;
        for (uint32_t k = 1; k < 6; k += 1)
        {
            maxima[k] = _mm512_max_epi8(maxima[k - 1], _mm512_mask_permutexvar_epi8(below, c.shift_mask[k - 1], c.shift_index[k - 1], maxima[k - 1]));
        }
        // Each definition's partner: the kill after the last earlier lane whose height reaches the definition's.
        const __m512i position = level_descent2(maxima, _mm512_sub_epi8(c.lane, one), prefix);
        const __mmask64 found = def_lanes & ~_mm512_movepi8_mask(position);
        const __mmask64 entry = def_lanes & ~found & _mm512_cmple_epi8_mask(prefix, zero);
        const __mmask64 external = def_lanes & ~found & ~entry;
        // Use slots: their value's definition lane in this chunk, or a register already assigned.
        uint64_t internal_slots = 0;
        uint64_t none_slots = 0;
        uint64_t previous_slots = 0;
        __m128i lanes_of_values[3];
        __m128i lanes_of_previous[3];
        for (uint32_t g = 0; g < 3; g += 1)
        {
            const uint32_t base = g * 16;
            const __mmask16 group = (__mmask16)(slots > base ? (slots - base >= 16 ? 0xffff : (1u << (slots - base)) - 1) : 0);
            const __m512i values = _mm512_maskz_loadu_epi32(group, s.ops + first * SLOTS + base);
            const __m512i relative = _mm512_sub_epi32(values, _mm512_set1_epi32((int32_t)first));
            const __mmask16 internal = group & _mm512_cmplt_epu32_mask(relative, _mm512_set1_epi32((int32_t)n));
            const __mmask16 none = group & _mm512_cmpeq_epi32_mask(values, _mm512_set1_epi32((int32_t)s.none));
            const __m512i lane_of_value = _mm512_add_epi32(_mm512_add_epi32(relative, _mm512_add_epi32(relative, relative)), _mm512_set1_epi32(2));
            const __mmask16 previous = first != 0 ? group & ~none & _mm512_cmplt_epu32_mask(_mm512_add_epi32(relative, _mm512_set1_epi32(CHUNK_INSTRUCTIONS)), _mm512_set1_epi32(CHUNK_INSTRUCTIONS)) : 0;
            lanes_of_values[g] = _mm512_cvtepi32_epi8(lane_of_value);
            lanes_of_previous[g] = _mm512_cvtepi32_epi8(_mm512_add_epi32(lane_of_value, _mm512_set1_epi32(3 * CHUNK_INSTRUCTIONS)));
            internal_slots |= (uint64_t)internal << base;
            none_slots |= (uint64_t)none << base;
            previous_slots |= (uint64_t)previous << base;
        }
        __m512i slot_value_lanes = _mm512_castsi128_si512(lanes_of_values[0]);
        slot_value_lanes = _mm512_inserti32x4(slot_value_lanes, lanes_of_values[1], 1);
        slot_value_lanes = _mm512_inserti32x4(slot_value_lanes, lanes_of_values[2], 2);
        const __m512i value_lanes = _mm512_permutexvar_epi8(c.slot_of_lane, slot_value_lanes);
        const __mmask64 internal_lanes = use_lanes & _mm512_test_epi8_mask(_mm512_permutexvar_epi8(c.slot_of_lane, _mm512_maskz_mov_epi8(internal_slots, one)), one);
        __m512i slot_previous_lanes = _mm512_castsi128_si512(lanes_of_previous[0]);
        slot_previous_lanes = _mm512_inserti32x4(slot_previous_lanes, lanes_of_previous[1], 1);
        slot_previous_lanes = _mm512_inserti32x4(slot_previous_lanes, lanes_of_previous[2], 2);
        const __mmask64 previous_lanes = use_lanes & _mm512_test_epi8_mask(_mm512_permutexvar_epi8(c.slot_of_lane, _mm512_maskz_mov_epi8(previous_slots, one)), one);
        // Roots point at themselves and hold their register; every other lane points at its source lane.
        __m512i pointer = c.lane;
        pointer = _mm512_mask_mov_epi8(pointer, found, _mm512_add_epi8(position, one));
        pointer = _mm512_mask_mov_epi8(pointer, entry, zero);
        pointer = _mm512_mask_mov_epi8(pointer, internal_lanes, value_lanes);
        __m512i registers = _mm512_maskz_permutexvar_epi8(external, _mm512_add_epi8(_mm512_add_epi8(prefix, carry), _mm512_set1_epi8(-1)), state);
        registers = _mm512_mask_permutexvar_epi8(registers, previous_lanes, _mm512_permutexvar_epi8(c.slot_of_lane, slot_previous_lanes), previous_registers);
        uint64_t external_slots = ((slots == 64 ? ~0ull : (1ull << slots) - 1)) & ~internal_slots & ~none_slots & ~previous_slots;
        while (external_slots != 0)
        {
            const uint32_t slot = (uint32_t)__builtin_ctzll(external_slots);
            external_slots &= external_slots - 1;
            const uint32_t lane = 3 * (slot / 2) + slot % 2;
            registers = _mm512_mask_set1_epi8(registers, 1ull << lane, (char)s.value_register[s.ops[first * SLOTS + slot]]);
        }
        for (uint32_t round = 0; round < 6; round += 1)
        {
            pointer = _mm512_permutexvar_epi8(pointer, pointer);
        }
        registers = _mm512_permutexvar_epi8(pointer, registers);
        previous_registers = registers;
        // The state for the next chunk: per relative level, the lane of the last kill that deposited there.
        const __m512i level_position = level_descent2(maxima, _mm512_set1_epi8((char)last), c.level_threshold);
        const __mmask64 level_found = ~_mm512_movepi8_mask(level_position);
        const __mmask64 level_entry = ~level_found & _mm512_cmple_epi8_mask(c.level_threshold, zero);
        __m512i level_lane = _mm512_mask_mov_epi8(below, level_found, _mm512_add_epi8(level_position, one));
        level_lane = _mm512_mask_mov_epi8(level_lane, level_entry, zero);
        const __m512i absolute = _mm512_permutexvar_epi8(_mm512_sub_epi8(_mm512_add_epi8(c.lane, _mm512_set1_epi8(32)), carry), level_lane);
        state = _mm512_mask_permutexvar_epi8(state, ~_mm512_movepi8_mask(absolute), absolute, registers);
        overflow |= _mm512_cmpgt_epi8_mask(_mm512_add_epi8(prefix, carry), _mm512_set1_epi8(32)) & valid_lanes;
        carry = _mm512_add_epi8(carry, _mm512_permutexvar_epi8(_mm512_set1_epi8((char)last), prefix));
        // Outputs: 64-byte stores into columns with 64 bytes of slack.
        const __m512i definitions = _mm512_permutexvar_epi8(c.def_lane, registers);
        _mm512_storeu_si512(s.value_register + first, definitions);
        _mm512_storeu_si512(s.def_physical + first, definitions);
        _mm512_storeu_si512(s.physical + first * SLOTS, _mm512_permutexvar_epi8(c.lane_of_slot, registers));
    }
    return overflow == 0;
}

#include "levels_gen.c"

int main(int argc, char** argv)
{
    const uint32_t only = argc > 1 ? (uint32_t)atoi(argv[1]) : 0;
    const int descriptor = cycles_open();
    const LevelConstants constants = level_constants();
    const uint32_t shapes[] = { 4, 4, 6, 6 };
    const uint32_t counts[] = { 4096, 65536, 4096, 65536 };
    const char* names[] = { "temps-fit", "temps-fit", "one-chain", "one-chain" };
    bool valid = true;
    printf("one class of 32 registers, %u use slots per instruction: cycles per instruction, median of %u\n", SLOTS, SAMPLES);
    for (uint32_t w = 0; valid && w < 4; w += 1)
    {
        const uint32_t count = counts[w];
        Stream s = { 0 };
        s.ops = malloc((uint64_t)count * SLOTS * 4 + 256);
        s.classes = malloc((uint64_t)count + 128);
        s.kill = malloc((uint64_t)count * SLOTS + 64);
        s.physical = malloc((uint64_t)count * SLOTS + 128);
        s.def_physical = malloc((uint64_t)count + 128);
        s.live = malloc((uint64_t)count + 128);
        s.last = malloc(((uint64_t)count + 128) * 4);
        s.value_register = malloc((uint64_t)count + 128);
        generate(&s, shapes[w], count);
        memset(s.classes, 0, (uint64_t)count + 128);
        stream_kills_backward(&s);
        uint8_t* physical = malloc((uint64_t)count * SLOTS);
        uint8_t* definitions = malloc(count);
        valid = stream_assign_levels(&s) && stream_check(&s);
        memcpy(physical, s.physical, (uint64_t)count * SLOTS);
        memcpy(definitions, s.def_physical, count);
        memset(s.physical, 0xee, (uint64_t)count * SLOTS);
        memset(s.def_physical, 0xee, count);
        memset(s.value_register, 0xee, count);
        s.value_register[s.none] = 0;
        valid = valid && stream_assign_levels_avx512(&s, &constants);
        s.value_register[s.none] = 0;
        const bool same = memcmp(physical, s.physical, (uint64_t)count * SLOTS) == 0 && memcmp(definitions, s.def_physical, count) == 0;
        if (!same)
        {
            uint32_t i = 0;
            while (i < count && definitions[i] == s.def_physical[i])
            {
                i += 1;
            }
            fprintf(stderr, "%s %u: AVX-512 levels differ from the scalar levels twin, first definition %u (%u vs %u)\n", names[w], count, i, i < count ? definitions[i] : 0, i < count ? s.def_physical[i] : 0);
        }
        valid = valid && same && stream_check(&s);
        memset(s.physical, 0xee, (uint64_t)count * SLOTS);
        memset(s.def_physical, 0xee, count);
        valid = valid && stream_assign_levels_avx512_v2(&s, &constants);
        s.value_register[s.none] = 0;
        const bool same2 = memcmp(physical, s.physical, (uint64_t)count * SLOTS) == 0 && memcmp(definitions, s.def_physical, count) == 0;
        if (!same2)
        {
            fprintf(stderr, "%s %u: AVX-512 v2 differs from the scalar levels twin\n", names[w], count);
        }
        valid = valid && same2 && stream_check(&s) && stream_assign_lowest(&s) && stream_check(&s);
        if (only != 0)
        {
            for (uint32_t r = 0; r < 20000; r += 1)
            {
                valid &= only == 1 ? stream_assign_lowest(&s) : only == 2 ? stream_assign_levels(&s) : only == 3 ? stream_assign_levels_avx512(&s, &constants) : stream_assign_levels_avx512_v2(&s, &constants);
            }
            printf("%s %u: ran variant %u 20000 times\n", names[w], count, only);
            break;
        }
        uint32_t repetitions = 1;
        uint64_t elapsed = 0;
        while (valid && elapsed < 2000000)
        {
            const uint64_t begin = now_ns();
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                valid &= stream_assign_levels(&s);
            }
            elapsed = now_ns() - begin;
            repetitions = elapsed < 2000000 ? repetitions * 2 : repetitions;
        }
        double lowest[SAMPLES];
        double levels[SAMPLES];
        double vector[SAMPLES];
        double vector2[SAMPLES];
        for (uint32_t pass = 0; valid && pass < SAMPLES; pass += 1)
        {
            const uint64_t c0 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                valid &= stream_assign_lowest(&s);
            }
            const uint64_t c1 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                valid &= stream_assign_levels(&s);
            }
            const uint64_t c2 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                valid &= stream_assign_levels_avx512(&s, &constants);
            }
            const uint64_t c3 = cycles_read(descriptor);
            for (uint32_t r = 0; r < repetitions; r += 1)
            {
                valid &= stream_assign_levels_avx512_v2(&s, &constants);
            }
            const uint64_t c4 = cycles_read(descriptor);
            vector2[pass] = (double)(c4 - c3) / repetitions / count;
            lowest[pass] = (double)(c1 - c0) / repetitions / count;
            levels[pass] = (double)(c2 - c1) / repetitions / count;
            vector[pass] = (double)(c3 - c2) / repetitions / count;
        }
        s.value_register[s.none] = 0;
        valid = valid && stream_check(&s);
        printf("%-10s %6u instructions: lowest-free %.2f, levels scalar %.2f, levels AVX-512 %.2f, v2 %.2f cycles/instruction\n", names[w], count, median(lowest), median(levels), median(vector), median(vector2));
        free(physical);
        free(definitions);
    }
    return valid ? 0 : 1;
}
