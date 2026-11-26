// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #3641 lower-output-ISA compatibility probe. No third-party implementation or fixture is imported.
typedef unsigned long long GateVector __attribute__((vector_size(64)));

#if defined(BUSTER_3641_GATE_SUBJECT)

void gate_lane0(GateVector* out, unsigned long long x)
{
    *out = (GateVector){ x };
}

void gate_pair(GateVector* out, unsigned long long x, unsigned long long y)
{
    *out = (GateVector){ x, y, x, y, x, y, x, y };
}

void gate_mixed(GateVector* out, unsigned long long x, unsigned long long y)
{
    *out = (GateVector){ 0x0123456789abcdefull, x, 0, ~0ull, y, 0x8000000000000000ull, x, 0 };
}

void gate_all(GateVector* out, const unsigned long long* p)
{
    *out = (GateVector){ p[0], p[2], p[4], p[6], p[1], p[3], p[5], p[7] };
}

#else

#include <stdbool.h>
#include <stdio.h>
#include <string.h>

void gate_lane0(GateVector* out, unsigned long long x);
void gate_pair(GateVector* out, unsigned long long x, unsigned long long y);
void gate_mixed(GateVector* out, unsigned long long x, unsigned long long y);
void gate_all(GateVector* out, const unsigned long long* p);

static bool gate_bytes(const GateVector* value, const unsigned long long* lanes)
{
    unsigned char expected[64];
    for (unsigned b = 0; b < 64; b += 1)
    {
        expected[b] = (unsigned char)(lanes[b / 8] >> ((b % 8) * 8));
    }
    return memcmp(value, expected, sizeof(expected)) == 0;
}

int main(void)
{
    const unsigned long long inputs[] = {
        0,
        1,
        ~0ull,
        0x8000000000000000ull,
        0x0123456789abcdefull,
        0xfedcba9876543210ull,
        0x80ff800080008000ull,
        0x7f007fff7fffffffull,
    };
    bool valid = true;
    for (unsigned i = 0; i < 8; i += 1)
    {
        const unsigned long long x = inputs[i];
        for (unsigned j = 0; j < 8; j += 1)
        {
            const unsigned long long y = inputs[j];
            GateVector result;
            unsigned long long lanes[8] = { x };
            memset(&result, 0x5a, sizeof(result));
            gate_lane0(&result, x);
            valid = gate_bytes(&result, lanes) && valid;
            for (unsigned l = 0; l < 8; l += 1)
            {
                lanes[l] = (l & 1) != 0 ? y : x;
            }
            gate_pair(&result, x, y);
            valid = gate_bytes(&result, lanes) && valid;
            lanes[0] = 0x0123456789abcdefull;
            lanes[1] = x;
            lanes[2] = 0;
            lanes[3] = ~0ull;
            lanes[4] = y;
            lanes[5] = 0x8000000000000000ull;
            lanes[6] = x;
            lanes[7] = 0;
            gate_mixed(&result, x, y);
            valid = gate_bytes(&result, lanes) && valid;
            unsigned long long source[8];
            for (unsigned l = 0; l < 8; l += 1)
            {
                source[l] = inputs[(i + l) % 8] ^ y;
            }
            for (unsigned l = 0; l < 8; l += 1)
            {
                lanes[l] = source[(l % 4) * 2 + l / 4];
            }
            gate_all(&result, source);
            valid = gate_bytes(&result, lanes) && valid;
        }
    }
    puts(valid ? "#3641 lower-target bytes: 256 checks passed" : "#3641 lower-target bytes: FAIL");
    return valid ? 0 : 1;
}

#endif
