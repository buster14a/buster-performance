#include <limits.h>
#include <stdint.h>
#include <stdio.h>

typedef unsigned (*Kernel)(const unsigned *, unsigned);
unsigned sum1(const unsigned *, unsigned);
unsigned sum3(const unsigned *, unsigned);
unsigned swap1(const unsigned *, unsigned);
unsigned swap3(const unsigned *, unsigned);
unsigned strict1(const unsigned *, unsigned);
long find1(const unsigned *, unsigned, unsigned);
long find3(const unsigned *, unsigned, unsigned);

int main(int argc, char **argv)
{
    static unsigned data[65536];
    static const unsigned inputs[] = {0, 1, 2, 3, 4, 7, 15, 16, 17, 1023,
                                     65533, 65534, 65535, 65536, 65537, 0x80000000u, UINT_MAX};
    static const Kernel kernel[] = {sum1, sum3, swap1, swap3, strict1};
    FILE *source = argc == 2 ? fopen(argv[1], "rb") : NULL;
    if (!source)
        return 2;
    unsigned read = 0;
    int byte;
    while (read < 65536 && (byte = fgetc(source)) != EOF)
        data[read++] = (unsigned)byte;
    if (ferror(source) || read == 0 || fclose(source) != 0)
        return 2;
    for (unsigned i = read; i < 65536; ++i)
        data[i] = data[i % read];
    uint64_t digest = 0;
    unsigned checks = 0;
    for (unsigned dataset = 0; dataset < 2; ++dataset)
    {
        for (unsigned k = 0; k < sizeof(kernel) / sizeof(kernel[0]); ++k)
        {
            unsigned stride = k == 1 || k == 3 ? 3 : 1;
            for (unsigned s = 0; s < sizeof(inputs) / sizeof(inputs[0]); ++s)
            {
                unsigned count = (inputs[s] & 65535u) + (k != 4);
                unsigned expected = 0;
                for (unsigned j = 0; j < count; j += stride)
                    expected += data[j];
                unsigned result = kernel[k](data, inputs[s]);
                if (result != expected)
                {
                    fprintf(stderr, "dataset=%u kernel=%u n=%u expected=%u actual=%u\n",
                            dataset, k, inputs[s], expected, result);
                    return 1;
                }
                digest = (digest ^ result) * UINT64_C(1099511628211);
                ++checks;
            }
        }
        for (unsigned stride = 1; stride <= 3; stride += 2)
        {
            for (unsigned s = 0; s < sizeof(inputs) / sizeof(inputs[0]); ++s)
            {
                unsigned limit = inputs[s] & 65535u;
                unsigned keys[] = {data[0], data[limit - limit % stride], data[limit / 2], 0xff00abdeu};
                for (unsigned k = 0; k < sizeof(keys) / sizeof(keys[0]); ++k)
                {
                    unsigned j = 0;
                    while (j <= limit && data[j] != keys[k])
                        j += stride;
                    long expected = j <= limit || stride == 1 ? (long)j : -1L;
                    long result = stride == 1 ? find1(data, inputs[s], keys[k]) : find3(data, inputs[s], keys[k]);
                    if (result != expected)
                    {
                        fprintf(stderr, "search dataset=%u stride=%u n=%u key=%u expected=%ld actual=%ld\n",
                                dataset, stride, inputs[s], keys[k], expected, result);
                        return 1;
                    }
                    digest = (digest ^ (uint64_t)result) * UINT64_C(1099511628211);
                    ++checks;
                }
            }
        }
        if (dataset == 0)
            for (unsigned i = 0; i < 65536; ++i)
                data[i] = 0xa5a55a5au ^ i * 2654435761u;
    }
    printf("source-bytes=%u checks=%u digest=%016llx\n", read, checks, (unsigned long long)digest);
    return 0;
}
