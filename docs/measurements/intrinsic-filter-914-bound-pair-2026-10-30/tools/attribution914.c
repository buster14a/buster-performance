// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded reader for this campaign's Linux/x86-64 cycles:u captures.
#define _GNU_SOURCE
#include <asm/perf_regs.h>
#include <dwarf.h>
#include <elf.h>
#include <elfutils/libdw.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <libelf.h>
#include <linux/perf_event.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#define SAMPLE_LIMIT 2000000u
#define PROCESS_LIMIT 4096u
#define FRAME_LIMIT 128u

typedef struct Bytes Bytes;
struct Bytes { unsigned char* data; size_t size; };
typedef struct Range Range;
struct Range { uint64_t start; uint64_t size; const char* name; };
typedef struct Image Image;
struct Image { Bytes bytes; Elf* elf; Dwarf_CFI* cfi; Elf64_Ehdr header; Range family[2]; unsigned families; };
typedef struct Process Process;
struct Process { uint32_t pid; bool compiler; uint64_t libc_bias; bool libc; unsigned compiler_execs; bool sampled; };
typedef struct Metadata Metadata;
struct Metadata { uint64_t time, bias; uint32_t pid; bool comm, exec, compiler; };
typedef struct Sample Sample;
struct Sample
{
    uint32_t pid, tid, cpu;
    uint16_t misc;
    uint64_t ip, period, time, regs[24], regs_mask, stack_size;
    const unsigned char* stack;
    bool compiler, libc;
    uint64_t libc_bias;
};
typedef struct Capture Capture;
struct Capture
{
    Bytes bytes;
    Sample* samples;
    size_t count, capacity;
    Process processes[PROCESS_LIMIT];
    unsigned process_count;
    uint64_t lost, lost_samples, throttles, unthrottles, records;
    uint64_t sample_type, regs_mask;
    Metadata* metadata;
    size_t metadata_count, metadata_capacity;
};
typedef struct TextSample TextSample;
struct TextSample
{
    uint32_t pid, tid;
    uint64_t period, ip[FRAME_LIMIT];
    char dso[FRAME_LIMIT][1024];
    unsigned frames;
};

static bool bounds(Bytes b, uint64_t off, uint64_t size)
{
    const bool valid = off <= b.size && size <= b.size - off;
    return valid;
}

static uint64_t little(const unsigned char* p, unsigned n)
{
    uint64_t value = 0;
    for (unsigned i = 0; i < n; i += 1) { value |= (uint64_t)p[i] << (8 * i); }
    return value;
}

static bool open_bytes(const char* path, Bytes* b)
{
    const int fd = open(path, O_RDONLY | O_CLOEXEC);
    struct stat st;
    bool valid = fd >= 0 && fstat(fd, &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0 && (uint64_t)st.st_size <= UINT64_C(8589934592);
    if (valid)
    {
        void* map = mmap(NULL, (size_t)st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
        valid = map != MAP_FAILED;
        if (valid) { *b = (Bytes){map, (size_t)st.st_size}; }
    }
    if (fd >= 0) { close(fd); }
    return valid;
}

static bool section(Image* image, unsigned index, Elf64_Shdr* sh)
{
    const uint64_t off = image->header.e_shoff + (uint64_t)index * sizeof(*sh);
    const bool valid = index < image->header.e_shnum && bounds(image->bytes, off, sizeof(*sh));
    if (valid) { memcpy(sh, image->bytes.data + off, sizeof(*sh)); }
    return valid;
}

static const unsigned char* virtual_bytes(Image* image, uint64_t address, uint64_t size)
{
    const unsigned char* result = NULL;
    for (unsigned i = 0; i < image->header.e_phnum; i += 1)
    {
        Elf64_Phdr p;
        const uint64_t off = image->header.e_phoff + (uint64_t)i * sizeof(p);
        if (bounds(image->bytes, off, sizeof(p)))
        {
            memcpy(&p, image->bytes.data + off, sizeof(p));
            if (p.p_type == PT_LOAD && bounds(image->bytes, p.p_offset, p.p_filesz) && address >= p.p_vaddr && address - p.p_vaddr <= p.p_filesz &&
                size <= p.p_filesz - (address - p.p_vaddr) && bounds(image->bytes, p.p_offset + address - p.p_vaddr, size))
            { result = image->bytes.data + p.p_offset + address - p.p_vaddr; }
        }
    }
    return result;
}

static bool open_image(const char* path, Image* image, bool compiler)
{
    bool valid = open_bytes(path, &image->bytes) && image->bytes.size >= sizeof(image->header);
    if (valid)
    {
        memcpy(&image->header, image->bytes.data, sizeof(image->header));
        Elf64_Ehdr* h = &image->header;
        valid = memcmp(h->e_ident, ELFMAG, SELFMAG) == 0 && h->e_ident[EI_CLASS] == ELFCLASS64 &&
            h->e_ident[EI_DATA] == ELFDATA2LSB && h->e_machine == EM_X86_64 && h->e_shnum != 0 &&
            h->e_shentsize == sizeof(Elf64_Shdr) && h->e_phentsize == sizeof(Elf64_Phdr) &&
            bounds(image->bytes, h->e_shoff, (uint64_t)h->e_shnum * sizeof(Elf64_Shdr)) &&
            bounds(image->bytes, h->e_phoff, (uint64_t)h->e_phnum * sizeof(Elf64_Phdr)) &&
            h->e_type == (compiler ? ET_EXEC : ET_DYN);
    }
    const char* names[2] = { "check_input_intrinsic_initialize", "check_input_intrinsic_lookup" };
    unsigned found[2] = {0};
    for (unsigned i = 0; valid && compiler && i < image->header.e_shnum; i += 1)
    {
        Elf64_Shdr sh, strings;
        valid = section(image, i, &sh);
        if (valid && sh.sh_type == SHT_SYMTAB)
        {
            valid = sh.sh_entsize == sizeof(Elf64_Sym) && sh.sh_size % sizeof(Elf64_Sym) == 0 &&
                bounds(image->bytes, sh.sh_offset, sh.sh_size) && section(image, sh.sh_link, &strings) &&
                bounds(image->bytes, strings.sh_offset, strings.sh_size);
            for (uint64_t at = 0; valid && at < sh.sh_size; at += sizeof(Elf64_Sym))
            {
                Elf64_Sym sym;
                memcpy(&sym, image->bytes.data + sh.sh_offset + at, sizeof(sym));
                valid = sym.st_name < strings.sh_size;
                const char* name = valid ? (const char*)image->bytes.data + strings.sh_offset + sym.st_name : "";
                valid = valid && memchr(name, 0, (size_t)(strings.sh_size - sym.st_name)) != NULL;
                for (unsigned n = 0; valid && n < 2; n += 1)
                {
                    if (strcmp(name, names[n]) == 0)
                    {
                        Elf64_Shdr owner;
                        valid = ELF64_ST_TYPE(sym.st_info) == STT_FUNC && sym.st_size > 0 && section(image, sym.st_shndx, &owner) &&
                            (owner.sh_flags & SHF_EXECINSTR) != 0 && virtual_bytes(image, sym.st_value, sym.st_size) != NULL;
                        found[n] += 1;
                        image->family[n] = (Range){ sym.st_value, sym.st_size, names[n] };
                    }
                }
            }
        }
    }
    if (compiler) { valid = valid && found[0] == 1 && found[1] <= 1; image->families = found[1] != 0 ? 2 : 1; }
    if (valid)
    {
        image->elf = elf_memory((char*)image->bytes.data, image->bytes.size);
        image->cfi = image->elf != NULL ? dwarf_getcfi_elf(image->elf) : NULL;
        valid = image->cfi != NULL;
    }
    return valid;
}

static bool member(Image* image, uint64_t ip)
{
    bool found = false;
    for (unsigned i = 0; i < image->families; i += 1)
    { found |= ip >= image->family[i].start && ip - image->family[i].start < image->family[i].size; }
    return found;
}

static Process* process(Capture* capture, uint32_t pid)
{
    Process* result = NULL;
    for (unsigned i = 0; i < capture->process_count; i += 1)
    { if (capture->processes[i].pid == pid) { result = capture->processes + i; } }
    if (result == NULL && capture->process_count < PROCESS_LIMIT)
    { result = capture->processes + capture->process_count++; *result = (Process){ .pid = pid }; }
    return result;
}

static bool append_sample(Capture* capture, Sample sample)
{
    bool valid = capture->count < SAMPLE_LIMIT;
    if (valid && capture->count == capture->capacity)
    {
        const size_t capacity = capture->capacity == 0 ? 8192 : capture->capacity * 2;
        Sample* samples = realloc(capture->samples, capacity * sizeof(*samples));
        valid = samples != NULL;
        if (valid) { capture->samples = samples; capture->capacity = capacity; }
    }
    if (valid) { capture->samples[capture->count++] = sample; }
    return valid;
}

static bool append_metadata(Capture* capture, Metadata metadata)
{
    bool valid = capture->metadata_count < SAMPLE_LIMIT;
    if (valid && capture->metadata_count == capture->metadata_capacity)
    {
        const size_t capacity = capture->metadata_capacity == 0 ? 1024 : capture->metadata_capacity * 2;
        Metadata* values = realloc(capture->metadata, capacity * sizeof(*values));
        valid = values != NULL;
        if (valid) { capture->metadata = values; capture->metadata_capacity = capacity; }
    }
    if (valid) { capture->metadata[capture->metadata_count++] = metadata; }
    return valid;
}

static int metadata_order(const void* a, const void* b)
{
    const Metadata* x = a; const Metadata* y = b;
    const int result = x->time < y->time ? -1 : x->time > y->time ? 1 : x->pid < y->pid ? -1 : x->pid > y->pid ? 1 :
        x->comm != y->comm ? (x->comm ? -1 : 1) : 0;
    return result;
}

static int sample_order(const void* a, const void* b);

static bool bind_epochs(Capture* capture)
{
    qsort(capture->metadata, capture->metadata_count, sizeof(*capture->metadata), metadata_order);
    qsort(capture->samples, capture->count, sizeof(*capture->samples), sample_order);
    bool valid = true;
    size_t next = 0;
    for (size_t i = 0; valid && i < capture->count; i += 1)
    {
        Sample* sample = capture->samples + i;
        while (valid && next < capture->metadata_count && capture->metadata[next].time <= sample->time)
        {
            Metadata* m = capture->metadata + next++;
            Process* p = process(capture, m->pid);
            valid = p != NULL;
            if (valid && m->comm)
            {
                if (m->exec) { p->libc = false; p->libc_bias = 0; }
                if (m->exec && m->compiler) { p->compiler_execs += 1; valid = p->compiler_execs == 1; }
                p->compiler = m->compiler;
            }
            else if (valid && p->compiler)
            {
                valid = !p->libc || p->libc_bias == m->bias;
                p->libc = true; p->libc_bias = m->bias;
            }
        }
        Process* p = process(capture, sample->pid);
        valid = valid && p != NULL;
        if (valid) { sample->compiler = p->compiler; sample->libc = p->libc; sample->libc_bias = p->libc_bias; }
    }
    return valid;
}

static bool parse_capture(const char* path, Capture* capture)
{
    bool valid = open_bytes(path, &capture->bytes) && capture->bytes.size >= 104;
    uint64_t data_off = 0, data_size = 0;
    if (valid)
    {
        const unsigned char* h = capture->bytes.data;
        const uint64_t attr_size = little(h + 16, 8), attr_off = little(h + 24, 8), attrs = little(h + 32, 8);
        data_off = little(h + 40, 8); data_size = little(h + 48, 8);
        valid = memcmp(h, "PERFILE2", 8) == 0 && little(h + 8, 8) == 104 && attr_size >= 112 && attrs == attr_size &&
            bounds(capture->bytes, attr_off, attrs) && bounds(capture->bytes, data_off, data_size);
        unsigned features = 0;
        for (unsigned flag = 0; flag < 4; flag += 1) { features += (unsigned)__builtin_popcountll(little(h + 72 + flag * 8, 8)); }
        const uint64_t feature_table = data_off + data_size;
        valid = valid && bounds(capture->bytes, feature_table, (uint64_t)features * 16);
        for (unsigned feature = 0; valid && feature < features; feature += 1)
        {
            const unsigned char* f = h + feature_table + feature * 16;
            valid = bounds(capture->bytes, little(f, 8), little(f + 8, 8));
        }
        if (valid)
        {
            struct perf_event_attr attr = {0};
            memcpy(&attr, h + attr_off, attr_size - 16 < sizeof(attr) ? (size_t)attr_size - 16 : sizeof(attr));
            const uint64_t expected = PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU |
                PERF_SAMPLE_PERIOD | PERF_SAMPLE_CALLCHAIN | PERF_SAMPLE_REGS_USER | PERF_SAMPLE_STACK_USER;
            valid = attr.type == PERF_TYPE_HARDWARE && attr.config == PERF_COUNT_HW_CPU_CYCLES && attr.sample_type == expected &&
                !attr.freq && attr.exclude_kernel && attr.exclude_hv && attr.sample_id_all && attr.sample_period != 0 &&
                attr.sample_regs_user == UINT64_C(0xff0fff) && attr.sample_stack_user == 4096;
            capture->sample_type = attr.sample_type; capture->regs_mask = attr.sample_regs_user;
        }
    }
    for (uint64_t at = data_off; valid && at < data_off + data_size;)
    {
        const unsigned char* r = capture->bytes.data + at;
        valid = data_off + data_size - at >= 8;
        const uint32_t type = valid ? (uint32_t)little(r, 4) : 0;
        const uint16_t misc = valid ? (uint16_t)little(r + 4, 2) : 0;
        const uint64_t size = valid ? little(r + 6, 2) : 0;
        valid = valid && size >= 8 && size <= data_off + data_size - at;
        capture->records += 1;
        if (valid && type == PERF_RECORD_LOST)
        { valid = size >= 24 && little(r + 16, 8) <= UINT64_MAX - capture->lost; if (valid) { capture->lost += little(r + 16, 8); } }
        else if (valid && type == PERF_RECORD_LOST_SAMPLES)
        { valid = size >= 16 && little(r + 8, 8) <= UINT64_MAX - capture->lost_samples; if (valid) { capture->lost_samples += little(r + 8, 8); } }
        else if (valid && type == PERF_RECORD_THROTTLE) { capture->throttles += 1; }
        else if (valid && type == PERF_RECORD_UNTHROTTLE) { capture->unthrottles += 1; }
        else if (valid && type == PERF_RECORD_COMM)
        {
            valid = size >= 16 + 24 + 1;
            if (valid)
            {
                const char* name = (const char*)r + 16;
                valid = memchr(name, 0, (size_t)size - 16 - 24) != NULL;
                valid = valid && append_metadata(capture, (Metadata){ .pid = (uint32_t)little(r + 8, 4), .time = little(r + size - 16, 8),
                    .comm = true, .exec = (misc & PERF_RECORD_MISC_COMM_EXEC) != 0, .compiler = strcmp(name, "compiler") == 0 });
            }
        }
        else if (valid && type == PERF_RECORD_MMAP2)
        {
            valid = size >= 72 + 24 + 1;
            if (valid)
            {
                const char* name = (const char*)r + 72;
                valid = memchr(name, 0, (size_t)size - 72 - 24) != NULL;
                if (valid && strstr(name, "/libc.so.6") != NULL && (little(r + 64, 4) & PROT_EXEC) != 0)
                {
                    const uint64_t start = little(r + 16, 8), offset = little(r + 32, 8);
                    valid = start >= offset && append_metadata(capture, (Metadata){ .pid = (uint32_t)little(r + 8, 4),
                        .time = little(r + size - 16, 8), .bias = start - offset });
                }
            }
        }
        else if (valid && type == PERF_RECORD_SAMPLE)
        {
            valid = size >= 56;
            Sample s = { .misc = misc, .regs_mask = capture->regs_mask };
            uint64_t cursor = 56;
            if (valid)
            {
                s.ip = little(r + 8, 8); s.pid = (uint32_t)little(r + 16, 4); s.tid = (uint32_t)little(r + 20, 4);
                s.time = little(r + 24, 8); s.cpu = (uint32_t)little(r + 32, 4); s.period = little(r + 40, 8);
                const uint64_t chain = little(r + 48, 8);
                valid = s.period != 0 && chain <= (size - cursor) / 8;
                if (valid) { cursor += chain * 8; }
            }
            valid = valid && cursor <= size && size - cursor >= 8;
            const uint64_t abi = valid ? little(r + cursor, 8) : 0;
            cursor += 8;
            valid = valid && (abi == PERF_SAMPLE_REGS_ABI_64 || abi == PERF_SAMPLE_REGS_ABI_NONE);
            for (unsigned reg = 0; valid && abi != PERF_SAMPLE_REGS_ABI_NONE && reg < 24; reg += 1)
            {
                if ((capture->regs_mask & (UINT64_C(1) << reg)) != 0)
                { valid = cursor <= size && size - cursor >= 8; if (valid) { s.regs[reg] = little(r + cursor, 8); cursor += 8; } }
            }
            valid = valid && cursor <= size && size - cursor >= 8;
            const uint64_t stack = valid ? little(r + cursor, 8) : 0;
            cursor += 8;
            valid = valid && stack <= 4096 && cursor <= size && stack <= size - cursor;
            if (valid)
            {
                s.stack = r + cursor; cursor += stack;
                if (stack != 0)
                { valid = cursor <= size && size - cursor >= 8; s.stack_size = valid ? little(r + cursor, 8) : 0; cursor += 8; valid = valid && s.stack_size <= stack; }
            }
            valid = valid && cursor == size && append_sample(capture, s);
        }
        if (valid) { at += size; }
    }
    valid = valid && capture->lost == 0 && capture->lost_samples == 0 && capture->throttles == 0 && capture->unthrottles == 0 && bind_epochs(capture);
    return valid;
}

static bool signed_add(uint64_t base, int64_t displacement, uint64_t* value)
{
    const uint64_t magnitude = displacement < 0 ? 0 - (uint64_t)displacement : (uint64_t)displacement;
    const bool valid = displacement < 0 ? base >= magnitude : base <= UINT64_MAX - magnitude;
    if (valid) { *value = displacement < 0 ? base - magnitude : base + magnitude; }
    return valid;
}

static bool cfi_return(Image* image, uint64_t address, Sample* sample, uint64_t* cfa, uint64_t* ra_address, uint64_t* ra)
{
    Dwarf_Frame* frame = NULL;
    Dwarf_Op* ops = NULL;
    size_t count = 0;
    bool valid = dwarf_cfi_addrframe(image->cfi, address, &frame) == 0 && dwarf_frame_cfa(frame, &ops, &count) == 0;
    if (valid)
    {
        const bool extended = count == 1 && ops[0].atom == DW_OP_bregx && (ops[0].number == 6 || ops[0].number == 7);
        valid = extended || (count == 1 && (ops[0].atom == DW_OP_breg7 || ops[0].atom == DW_OP_breg6));
        if (valid)
        {
            const unsigned reg = extended ? (unsigned)ops[0].number : ops[0].atom - DW_OP_breg0;
            valid = signed_add(sample->regs[reg == 7 ? PERF_REG_X86_SP : PERF_REG_X86_BP], (int64_t)(extended ? ops[0].number2 : ops[0].number), cfa);
        }
    }
    Dwarf_Op memory[3];
    valid = valid && dwarf_frame_register(frame, 16, memory, &ops, &count) == 0;
    if (valid)
    {
        if (!(count == 2 && ops[0].atom == DW_OP_call_frame_cfa && ops[1].atom == DW_OP_plus_uconst))
        { fprintf(stderr, "unsupported RA addr=%" PRIx64 " count=%zu op0=%x op1=%x num0=%" PRIu64 " num1=%" PRIu64 "\n", address, count, count != 0 ? ops[0].atom : 0, count > 1 ? ops[1].atom : 0, count != 0 ? ops[0].number : 0, count > 1 ? ops[1].number : 0); }
        valid = count == 2 && ops[0].atom == DW_OP_call_frame_cfa && ops[1].atom == DW_OP_plus_uconst &&
            signed_add(*cfa, (int64_t)ops[1].number, ra_address);
        const uint64_t sp = sample->regs[PERF_REG_X86_SP];
        valid = valid && *ra_address >= sp && *ra_address - sp <= sample->stack_size && 8 <= sample->stack_size - (*ra_address - sp);
        if (valid) { *ra = little(sample->stack + *ra_address - sp, 8); }
    }
    free(frame);
    return valid;
}

static bool call_target(Image* image, uint64_t ra, uint64_t* target)
{
    const unsigned char* bytes = ra >= 5 ? virtual_bytes(image, ra - 5, 5) : NULL;
    int32_t relative = 0;
    bool valid = bytes != NULL && bytes[0] == 0xe8;
    if (valid) { memcpy(&relative, bytes + 1, 4); valid = signed_add(ra, relative, target); }
    return valid;
}

static bool memcmp_call(Image* image, uint64_t ra, uint64_t* got)
{
    uint64_t target = 0;
    bool valid = ra != 0 && member(image, ra - 1) && call_target(image, ra, &target);
    const unsigned char* plt = valid ? virtual_bytes(image, target, 16) : NULL;
    unsigned prefix = 0;
    if (plt != NULL && memcmp(plt, "\xf3\x0f\x1e\xfa", 4) == 0) { prefix = 4; }
    if (plt != NULL && plt[prefix] == 0xf2) { prefix += 1; }
    valid = valid && plt != NULL && plt[prefix] == 0xff && plt[prefix + 1] == 0x25;
    if (valid)
    { int32_t relative; memcpy(&relative, plt + prefix + 2, 4); valid = signed_add(target + prefix + 6, relative, got); }
    bool matched = false;
    for (unsigned i = 0; valid && i < image->header.e_shnum; i += 1)
    {
        Elf64_Shdr sh, syms, strings;
        valid = section(image, i, &sh);
        if (valid && sh.sh_type == SHT_RELA)
        {
            valid = sh.sh_entsize == sizeof(Elf64_Rela) && sh.sh_size % sizeof(Elf64_Rela) == 0 && bounds(image->bytes, sh.sh_offset, sh.sh_size) &&
                section(image, sh.sh_link, &syms) && syms.sh_entsize == sizeof(Elf64_Sym) && bounds(image->bytes, syms.sh_offset, syms.sh_size) &&
                section(image, syms.sh_link, &strings) && bounds(image->bytes, strings.sh_offset, strings.sh_size);
            for (uint64_t at = 0; valid && at < sh.sh_size; at += sizeof(Elf64_Rela))
            {
                Elf64_Rela rel; memcpy(&rel, image->bytes.data + sh.sh_offset + at, sizeof(rel));
                if (rel.r_offset == *got && (ELF64_R_TYPE(rel.r_info) == R_X86_64_GLOB_DAT || ELF64_R_TYPE(rel.r_info) == R_X86_64_JUMP_SLOT))
                {
                    const uint64_t index = ELF64_R_SYM(rel.r_info);
                    valid = index < syms.sh_size / sizeof(Elf64_Sym);
                    Elf64_Sym sym;
                    if (valid) { memcpy(&sym, image->bytes.data + syms.sh_offset + index * sizeof(sym), sizeof(sym)); valid = sym.st_name < strings.sh_size; }
                    const char* name = valid ? (const char*)image->bytes.data + strings.sh_offset + sym.st_name : "";
                    valid = valid && memchr(name, 0, (size_t)(strings.sh_size - sym.st_name)) != NULL;
                    matched |= valid && strcmp(name, "memcmp") == 0;
                }
            }
        }
    }
    return valid && matched;
}

typedef struct TextReader TextReader;
struct TextReader { FILE* file; char* line; size_t capacity; bool valid; };

static bool blank(const char* line)
{
    bool result = true;
    for (size_t i = 0; line[i] != 0; i += 1) { result &= line[i] == ' ' || line[i] == '\t' || line[i] == '\r' || line[i] == '\n'; }
    return result;
}

static bool text_frame(const char* line, uint64_t* ip, char dso[1024])
{
    int consumed = 0;
    bool valid = sscanf(line, " %" SCNx64 " %n", ip, &consumed) == 1;
    const char* begin = valid ? strrchr(line + consumed, '(') : NULL;
    const char* end = begin != NULL ? strchr(begin + 1, ')') : NULL;
    valid = valid && begin != NULL && end != NULL && end - begin > 1 && end - begin - 1 < 1024 && blank(end + 1);
    if (valid) { memcpy(dso, begin + 1, (size_t)(end - begin - 1)); dso[end - begin - 1] = 0; }
    return valid;
}

static bool text_next(TextReader* reader, TextSample* sample, bool chains)
{
    memset(sample, 0, sizeof(*sample));
    ssize_t got = 0;
    do { got = getline(&reader->line, &reader->capacity, reader->file); } while (got >= 0 && blank(reader->line));
    bool present = got >= 0;
    if (present)
    {
        char comm[64], event[64]; int used = 0;
        reader->valid = sscanf(reader->line, " %63s %" SCNu32 "/%" SCNu32 " %" SCNu64 " %63s %n", comm, &sample->pid, &sample->tid,
            &sample->period, event, &used) == 5 && strcmp(comm, "compiler") == 0 && strcmp(event, "cycles:u:") == 0;
        if (reader->valid && !chains)
        { reader->valid = text_frame(reader->line + used, sample->ip, sample->dso[0]); sample->frames = reader->valid ? 1 : 0; }
        else if (reader->valid)
        {
            reader->valid = blank(reader->line + used);
            while (reader->valid && (got = getline(&reader->line, &reader->capacity, reader->file)) >= 0 && !blank(reader->line))
            {
                reader->valid = sample->frames < FRAME_LIMIT && text_frame(reader->line, sample->ip + sample->frames, sample->dso[sample->frames]);
                sample->frames += reader->valid;
            }
        }
    }
    reader->valid = reader->valid && !ferror(reader->file);
    return present;
}

static int sample_order(const void* a, const void* b)
{
    const Sample* x = a; const Sample* y = b;
    const int result = x->time < y->time ? -1 : x->time > y->time ? 1 : x->pid < y->pid ? -1 : x->pid > y->pid ? 1 : 0;
    return result;
}

static bool add_weight(uint64_t* total, uint64_t weight)
{
    const bool valid = weight <= UINT64_MAX - *total;
    if (valid) { *total += weight; }
    return valid;
}

static const char* base_name(const char* path)
{
    const char* slash = strrchr(path, '/');
    const char* result = slash != NULL ? slash + 1 : path;
    return result;
}

static bool run_attribution(Capture* capture, Image* compiler, Image* libc, const char* primary_path, const char* chains_path, const char* proof_path)
{
    TextReader primary = { .file = fopen(primary_path, "r"), .valid = true };
    TextReader chains = { .file = fopen(chains_path, "r"), .valid = true };
    FILE* proof = fopen(proof_path, "w");
    bool valid = primary.file != NULL && chains.file != NULL && proof != NULL;
    uint64_t source = 0, precompiler = 0;
    for (size_t i = 0; valid && i < capture->count; i += 1)
    {
        Process* p = process(capture, capture->samples[i].pid);
        valid = p != NULL;
        if (valid && capture->samples[i].compiler) { p->sampled = true; capture->samples[source++] = capture->samples[i]; }
        else if (valid && p->compiler_execs != 0) { precompiler += 1; }
    }
    unsigned compiler_processes = 0;
    for (unsigned p = 0; p < capture->process_count; p += 1) { compiler_processes += capture->processes[p].sampled; }
    qsort(capture->samples, (size_t)source, sizeof(*capture->samples), sample_order);
    uint64_t total_period = 0, user_period = 0, family_period = 0, memcmp_period = 0;
    uint64_t direct = 0, compared = 0, family_cfi = 0, libc_unattributed = 0, nonuser = 0, empty = 0, mismatch = 0, complex = 0;
    uint64_t empty_user = 0, libc_samples = 0, libc_short = 0;
    if (valid) { fprintf(proof, "kind,pid,period,primary_ip,sp,cfa,ra_address,raw_ra,cfi_caller,call_target,got\n"); }
    for (uint64_t i = 0; valid && i < source; i += 1)
    {
        Sample* s = capture->samples + i;
        TextSample a, b;
        valid = text_next(&primary, &a, false) && text_next(&chains, &b, true) && primary.valid && chains.valid &&
            a.pid == s->pid && a.tid == s->tid && a.ip[0] == s->ip && a.period == s->period &&
            b.pid == a.pid && b.tid == a.tid && b.period == a.period && s->cpu == 2 && add_weight(&total_period, s->period);
        if (!valid) { fprintf(stderr, "sample join or CPU/period failure at ordinal=%" PRIu64 "\n", i); }
        if (valid)
        {
            const bool user = (s->misc & PERF_RECORD_MISC_CPUMODE_MASK) == PERF_RECORD_MISC_USER;
            nonuser += !user; empty += b.frames == 0;
            mismatch += user && b.frames != 0 && b.ip[0] != s->ip;
            valid = !user || add_weight(&user_period, s->period);
            const bool own = user && member(compiler, s->ip);
            const bool from_libc = user && strcmp(base_name(a.dso[0]), "libc.so.6") == 0;
            empty_user += user && b.frames == 0;
            libc_samples += from_libc;
            libc_short += from_libc && b.frames < 2;
            unsigned family_index = FRAME_LIMIT;
            for (unsigned f = 1; f < b.frames; f += 1)
            { if (family_index == FRAME_LIMIT && member(compiler, b.ip[f])) { family_index = f; } }
            complex += from_libc && family_index != FRAME_LIMIT && family_index != 1;
            if (own || (from_libc && family_index == 1))
            {
                uint64_t cfa = 0, ra_address = 0, ra = 0, target = 0, got = 0;
                bool attributed_memcmp = false;
                const bool own_ra = own;
                valid = b.frames >= 2 && b.ip[0] == s->ip && s->regs[PERF_REG_X86_IP] == s->ip &&
                    (own_ra || (s->libc && s->ip >= s->libc_bias));
                const uint64_t cfi_ip = own_ra ? s->ip : s->ip - s->libc_bias;
                valid = valid && cfi_return(own_ra ? compiler : libc, cfi_ip, s, &cfa, &ra_address, &ra) &&
                    (b.ip[1] == ra || (ra != 0 && b.ip[1] == ra - 1));
                if (valid && own_ra)
                {
                    const Range* owner = NULL;
                    for (unsigned f = 0; f < compiler->families; f += 1)
                    { if (s->ip >= compiler->family[f].start && s->ip - compiler->family[f].start < compiler->family[f].size) { owner = compiler->family + f; } }
                    valid = owner != NULL && call_target(compiler, ra, &target) && target == owner->start && add_weight(&family_period, s->period);
                    direct += valid; family_cfi += valid;
                }
                else if (valid)
                {
                    attributed_memcmp = memcmp_call(compiler, ra, &got);
                    if (attributed_memcmp) { valid = add_weight(&memcmp_period, s->period); compared += valid; call_target(compiler, ra, &target); }
                    else { libc_unattributed += 1; }
                }
                if (valid)
                { fprintf(proof, "%s,%u,%" PRIu64 ",0x%" PRIx64 ",0x%" PRIx64 ",0x%" PRIx64 ",0x%" PRIx64 ",0x%" PRIx64 ",0x%" PRIx64 ",0x%" PRIx64 ",0x%" PRIx64 "\n", own_ra ? "family" : attributed_memcmp ? "memcmp" : "other_libc", s->pid, s->period, s->ip, s->regs[PERF_REG_X86_SP], cfa, ra_address, ra, b.ip[1], target, got); }
                else { fprintf(stderr, "target CFA/RA/call validation failure ordinal=%" PRIu64 " ip=%" PRIx64 " ra=%" PRIx64 " cfa=%" PRIx64 " caller=%" PRIx64 "\n", i, s->ip, ra, cfa, b.frames >= 2 ? b.ip[1] : 0); }
            }
        }
    }
    TextSample tail;
    if (valid) { valid = !text_next(&primary, &tail, false) && !text_next(&chains, &tail, true) && primary.valid && chains.valid && source != 0 && direct != 0; }
    if (proof != NULL) { valid = fclose(proof) == 0 && valid; }
    if (primary.file != NULL) { fclose(primary.file); } if (chains.file != NULL) { fclose(chains.file); }
    free(primary.line); free(chains.line);
    printf("{\"valid\":%s,\"compiler_samples\":%" PRIu64 ",\"compiler_cycle_period\":%" PRIu64 ",\"user_ip_cycle_period\":%" PRIu64 ",\"family_leaf_samples\":%" PRIu64 ",\"family_leaf_cycle_period\":%" PRIu64 ",\"attributed_memcmp_samples\":%" PRIu64 ",\"attributed_memcmp_cycle_period\":%" PRIu64 ",\"family_cfa_proofs\":%" PRIu64 ",\"other_libc_from_family\":%" PRIu64 ",\"nonuser_ip_samples\":%" PRIu64 ",\"empty_chains\":%" PRIu64 ",\"user_leaf_chain_mismatches\":%" PRIu64 ",\"complex_libc_family_chains\":%" PRIu64 ",\"lost\":%" PRIu64 ",\"lost_samples\":%" PRIu64 ",\"throttles\":%" PRIu64 ",\"unthrottles\":%" PRIu64 "}\n", valid ? "true" : "false", source, total_period, user_period, direct, family_period, compared, memcmp_period, family_cfi, libc_unattributed, nonuser, empty, mismatch, complex, capture->lost, capture->lost_samples, capture->throttles, capture->unthrottles);
    const size_t coverage_length = strlen(proof_path) + sizeof(".coverage.json");
    char* coverage_path = malloc(coverage_length);
    FILE* coverage = NULL;
    if (coverage_path != NULL)
    {
        snprintf(coverage_path, coverage_length, "%s.coverage.json", proof_path);
        coverage = fopen(coverage_path, "w");
    }
    valid = valid && coverage != NULL;
    if (coverage != NULL)
    {
        valid = fprintf(coverage, "{\"compiler_processes\":%u,\"excluded_precompiler_samples\":%" PRIu64 ",\"empty_user_chains\":%" PRIu64 ",\"libc_samples\":%" PRIu64 ",\"libc_short_chains\":%" PRIu64 "}\n", compiler_processes, precompiler, empty_user, libc_samples, libc_short) > 0 && valid;
        valid = fclose(coverage) == 0 && valid;
    }
    free(coverage_path);
    return valid;
}

int main(int argc, char** argv)
{
    elf_version(EV_CURRENT);
    Capture capture = {0}; Image compiler = {0}, libc = {0};
    bool valid = (argc == 3 && strcmp(argv[1], "--audit") == 0) || argc == 7;
    if (valid)
    {
        valid = parse_capture(argv[argc == 3 ? 2 : 1], &capture);
        if (argc == 3) { printf("{\"valid\":%s,\"records\":%" PRIu64 ",\"samples\":%zu,\"lost\":%" PRIu64 ",\"lost_samples\":%" PRIu64 ",\"throttles\":%" PRIu64 ",\"unthrottles\":%" PRIu64 "}\n", valid ? "true" : "false", capture.records, capture.count, capture.lost, capture.lost_samples, capture.throttles, capture.unthrottles); }
        else { valid = valid && open_image(argv[2], &compiler, true) && open_image(argv[3], &libc, false) && run_attribution(&capture, &compiler, &libc, argv[4], argv[5], argv[6]); }
    }
    if (!valid) { fprintf(stderr, "attribution914 rejected input; usage: DATA COMPILER LIBC PRIMARY CHAINS PROOFS.csv, or --audit DATA\n"); }
    if (compiler.cfi != NULL) { dwarf_cfi_end(compiler.cfi); } if (compiler.elf != NULL) { elf_end(compiler.elf); }
    if (libc.cfi != NULL) { dwarf_cfi_end(libc.cfi); } if (libc.elf != NULL) { elf_end(libc.elf); }
    if (compiler.bytes.data != NULL) { munmap(compiler.bytes.data, compiler.bytes.size); }
    if (libc.bytes.data != NULL) { munmap(libc.bytes.data, libc.bytes.size); }
    if (capture.bytes.data != NULL) { munmap(capture.bytes.data, capture.bytes.size); }
    free(capture.samples);
    free(capture.metadata);
    return valid ? 0 : 1;
}
