// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Measurement harness for buster14a/buster#3040. Run through count.sh.
#include <assert.h>
#include <elf.h>
#include <immintrin.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zlib.h>

static struct
{
    uint64_t builds, table_clear, table_fill, count_clear, length_init, blocks[3];
} counts;
#include "inflate-counted.c"

typedef struct
{
    uint8_t data[4096];
    unsigned bits;
    uint8_t plain[2048];
    unsigned size;
} Stream;

static void value(Stream* s, unsigned v, unsigned n)
{
    assert(s->bits + n <= 8 * sizeof(s->data));
    for (unsigned i = 0; i < n; ++i, ++s->bits)
        s->data[s->bits / 8] |= (uint8_t)(((v >> i) & 1) << (s->bits % 8));
}

static void code(Stream* s, unsigned v, unsigned n)
{
    while (n--)
        value(s, v >> n, 1);
}

static void block(Stream* s, char kind, bool last)
{
    assert(s->size + 4 <= sizeof(s->plain));
    value(s, last, 1);
    if (kind == 'f' || kind == 'F')
    {
        value(s, 1, 2);
        code(s, 0x30 + 'b', 8);
        s->plain[s->size++] = 'b';
        if (kind == 'F')
        {
            code(s, 1, 7); // length three
            code(s, 0, 5); // distance one
            memset(s->plain + s->size, 'b', 3);
            s->size += 3;
        }
        code(s, 0, 7);
    }
    else if (kind == 's' || kind == '0')
    {
        unsigned n = kind == 's';
        value(s, 0, 2);
        value(s, 0, (0u - s->bits) & 7);
        value(s, n, 16);
        value(s, n ^ 65535, 16);
        if (n)
        {
            value(s, 's', 8);
            s->plain[s->size++] = 's';
        }
    }
    else
    {
        assert(kind == 'd');
        value(s, 2, 2);
        value(s, 0, 5); // 257 literal/length codes
        value(s, 0, 5); // one absent distance code
        value(s, 14, 4);
        for (unsigned i = 0; i < 18; i++)
            value(s, i == 0 || i == 2 || i == 3 || i == 17 ? 2 : 0, 3);
        // The lengths alphabet is 0, 1, 16, 18 (two bits each).
        code(s, 3, 2); value(s, 97 - 11, 7);
        code(s, 1, 2);
        code(s, 3, 2); value(s, 138 - 11, 7);
        code(s, 3, 2); value(s, 20 - 11, 7);
        code(s, 1, 2); code(s, 0, 2);
        code(s, 0, 1); code(s, 1, 1); // 'a', end
        s->plain[s->size++] = 'a';
    }
}

static unsigned wrap(const Stream* s, uint8_t* result)
{
    unsigned n = (s->bits + 7) / 8;
    uint32_t check = (uint32_t)adler32(1, s->plain, s->size);
    result[0] = 0x78;
    result[1] = 0x01;
    memcpy(result + 2, s->data, n);
    for (unsigned i = 0; i < 4; i++)
        result[2 + n + i] = (uint8_t)(check >> (24 - 8*i));
    return n + 6;
}

static FILE* classes;
static unsigned statuses[INFLATE_ERROR_CHECKSUM + 1];
static unsigned checks;

// Stock libz consumes the same complete wrapper and must produce exactly 'size' bytes.
static InflateError check(const uint8_t* data, size_t n, const uint8_t* expected, size_t size, bool report, const char* name)
{
    uint8_t* memory = malloc(size + 32);
    uint8_t* oracle = malloc(size + 1);
    assert(memory && oracle);
    memset(memory, 0xa5, size + 32);
    memset(&counts, 0, sizeof(counts));
    InflateError result = inflate_zlib(data, n, memory + 16, size);
    uLong source = n, dest = size + 1;
    int z = uncompress2(oracle, &dest, data, &source);
    bool exact = z == Z_OK && source == n && dest == size;
    if ((result == INFLATE_ERROR_NONE) != exact)
        fprintf(stderr, "%s size=%zu input=%zu buster=%d zlib=%d consumed=%lu produced=%lu\n", name, size, n, result, z, source, dest);
    assert((result == INFLATE_ERROR_NONE) == exact);
    if (exact)
    {
        assert(memcmp(memory + 16, oracle, size) == 0);
        if (expected) assert(memcmp(memory + 16, expected, size) == 0);
    }
    for (unsigned i = 0; i < 16; i++)
        assert(memory[i] == 0xa5 && memory[size+16+i] == 0xa5);
    if (report)
        printf("%-18s input=%zu output=%zu S/F/D=%" PRIu64 "/%" PRIu64 "/%" PRIu64 " builds=%" PRIu64 " table_clear=%" PRIu64 " table_fill=%" PRIu64 " count_clear=%" PRIu64 " fixed_lengths=%" PRIu64 "\n",
               name, n, size, counts.blocks[0], counts.blocks[1], counts.blocks[2], counts.builds, counts.table_clear, counts.table_fill, counts.count_clear, counts.length_init);
    assert((unsigned)result < sizeof(statuses)/sizeof(statuses[0]));
    statuses[result]++;
    fprintf(classes, "%s %zu %zu %d\n", name, n, size, result);
    ++checks;
    free(oracle);
    free(memory);
    return result;
}

static void stream(const char* name, const char* kinds, unsigned repeat, bool errors)
{
    Stream s = {0};
    uint8_t data[sizeof(s.data)+7];
    for (unsigned i = 0; i < repeat; ++i)
        for (size_t j = 0; kinds[j]; ++j)
            block(&s, kinds[j], i+1 == repeat && kinds[j+1] == 0);
    unsigned n = wrap(&s, data);
    assert(check(data,n,s.plain,s.size,true,name) == INFLATE_ERROR_NONE);
    if (errors)
    {
        for (unsigned i = 0; i < n; ++i)
            assert(check(data,i,NULL,s.size,false,"prefix") != INFLATE_ERROR_NONE);
        for (unsigned i = 2; i < n-4; ++i)
        {
            uint8_t rest[sizeof(data)];
            memcpy(rest,data,i);
            memcpy(rest+i,data+n-4,4);
            assert(check(rest,i+4,NULL,s.size,false,"deflate-cut") != INFLATE_ERROR_NONE);
        }
        for (unsigned i = 0; i < n; ++i)
            for (unsigned bit = 0; bit < 8; ++bit)
            {
                data[i] ^= 1u << bit;
                check(data,n,s.plain,s.size,false,"bit-change");
                data[i] ^= 1u << bit;
            }
        assert(check(data,n,NULL,s.size-1,false,"short") == INFLATE_ERROR_SIZE);
        assert(check(data,n,NULL,s.size+1,false,"long") == INFLATE_ERROR_SIZE);
        data[n-1] ^= 1;
        assert(check(data,n,NULL,s.size,false,"adler") == INFLATE_ERROR_CHECKSUM);
        data[n-1] ^= 1;
        memmove(data+n-3,data+n-4,4);
        data[n-4] = 0;
        assert(check(data,n+1,NULL,s.size,false,"spare") == INFLATE_ERROR_SIZE);
    }
}

static uint8_t* read_file(const char* path)
{
    FILE* f = fopen(path,"rb");
    assert(f && fseek(f,0,SEEK_END) == 0);
    long n = ftell(f);
    assert(n > 0 && fseek(f,0,SEEK_SET) == 0);
    uint8_t* data = malloc((size_t)n);
    assert(data && fread(data,1,(size_t)n,f) == (size_t)n);
    assert(fclose(f) == 0);
    return data;
}

static void elf(const char* path, const char* raw_path)
{
    uint8_t* obj = read_file(path);
    uint8_t* raw = read_file(raw_path);
    const Elf64_Ehdr* e = (const Elf64_Ehdr*)obj;
    const Elf64_Ehdr* r = (const Elf64_Ehdr*)raw;
    const Elf64_Shdr* sections = (const Elf64_Shdr*)(obj+e->e_shoff);
    const Elf64_Shdr* originals = (const Elf64_Shdr*)(raw+r->e_shoff);
    const char* names = (const char*)obj+sections[e->e_shstrndx].sh_offset;
    const char* raw_names = (const char*)raw+originals[r->e_shstrndx].sh_offset;
    unsigned found = 0;
    for (unsigned i = 0; i < e->e_shnum; ++i)
    {
        const Elf64_Shdr* section = sections+i;
        const char* name = names+section->sh_name;
        if ((section->sh_flags & SHF_COMPRESSED) && strncmp(name,".debug_",7) == 0)
        {
            Elf64_Chdr ch;
            memcpy(&ch,obj+section->sh_offset,sizeof(ch));
            assert(ch.ch_type == ELFCOMPRESS_ZLIB && section->sh_size >= sizeof(ch));
            unsigned j = 0;
            while (j < r->e_shnum && strcmp(raw_names+originals[j].sh_name,name)) ++j;
            assert(j < r->e_shnum && originals[j].sh_size == ch.ch_size);
            assert(check(obj+section->sh_offset+sizeof(ch), section->sh_size-sizeof(ch),raw+originals[j].sh_offset,ch.ch_size,true,name) == INFLATE_ERROR_NONE);
            ++found;
        }
    }
    assert(found);
    free(raw);
    free(obj);
}

int main(int argc, char** argv)
{
    assert(argc == 4);
    classes = fopen(argv[3],"w");
    assert(classes);
    printf("zlib=%s sizeof(InflateCode)=%zu table_workspace=%zu sizeof(bool)=%zu\n",zlibVersion(),sizeof(InflateCode),2*sizeof(InflateCode),sizeof(bool));
    stream("fixed-1","f",1,false);
    stream("fixed-16","f",16,false);
    stream("fixed-256","f",256,false);
    stream("fixed-stored","fs0F",1,false);
    stream("mixed","ff0fds0Ff",1,true);
    stream("dynamic-first","d0fdF",1,false);
    stream("stored-only","s00s",1,false);
    elf(argv[1],argv[2]);
    printf("oracle_checks=%u statuses none/header/data/truncated/size/checksum=%u/%u/%u/%u/%u/%u\n",checks,statuses[0],statuses[1],statuses[2],statuses[3],statuses[4],statuses[5]);
    return fclose(classes) != 0;
}
