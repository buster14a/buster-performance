#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef char v64i8 __attribute__((vector_size(64)));
typedef unsigned long long u64;
u64 scan(const v64i8* blocks, unsigned count, const v64i8* k, u64* counts);
int main(int argc, char** argv)
{
    const unsigned passes = argc > 1 ? (unsigned)strtoul(argv[1], 0, 10) : 1;
    const unsigned long bytes = 1ul << 20;
    unsigned char* text = aligned_alloc(64, bytes);
    static const char line[] = "    total_count += lookup(table, \"key_%u\", 42) * factor_7;\n";
    for (unsigned long i = 0; i < bytes; i += 1) text[i] = (unsigned char)(line[i % (sizeof(line) - 1)] + ((i / 977) % 3 == 0 && line[i % (sizeof(line) - 1)] == 'a' ? 1 : 0));
    static const unsigned char splats[8] = { 'a', 25, '0', 9, '_', '\n', 0x20, '"' };
    v64i8 k[8];
    for (unsigned j = 0; j < 8; j += 1) memset(&k[j], splats[j], 64);
    u64 counts[3] = { 0, 0, 0 };
    u64 last = 0;
    for (unsigned pass = 0; pass < passes; pass += 1) last = last * 31 + scan((const v64i8*)text, (unsigned)(bytes / 64), k, counts);
    printf("%llu %llu %llu %016llx\n", counts[0], counts[1], counts[2], last);
    free(text);
    return 0;
}
