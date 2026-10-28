// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original external evidence harness: decode every nonempty executable ELF section with both existing decoders,
// require exact records and configured ISA eligibility, and refuse invalid header/ranges or undecodable bytes.
// Section boundaries avoid decoding unrelated inter-section padding as fallthrough code. This is not full ELF/loader
// validation, a reachable-instruction analysis, or an audit of executable bytes outside the executable sections.
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <elf.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wunterminated-string-initialization"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_64_disassembler.c"
#include "buster/compiler/x86_target_forms.c"
#pragma clang diagnostic pop

static bool audit_range(const uint8_t* bytes, uint64_t size, uint64_t offset, const uint8_t* allowed, bool report)
{
    bool passed = size != 0 && size <= UINT32_MAX;
    uint64_t consumed = 0;
    uint64_t instructions = 0;
    uint64_t hash = UINT64_C(14695981039346656037);
    while (passed && consumed < size)
    {
        X86Decoded scalar[512] = {0};
        X86Decoded vector[512] = {0};
        const X86DecodeResult a = x86_disassemble_scalar(bytes + consumed, size - consumed, scalar, BUSTER_ARRAY_LENGTH(scalar));
        const X86DecodeResult b = x86_disassemble(bytes + consumed, size - consumed, vector, BUSTER_ARRAY_LENGTH(vector));
        passed = a.status == b.status && a.count == b.count && a.consumed == b.consumed && a.count <= BUSTER_ARRAY_LENGTH(scalar) &&
            (a.status == X86_DECODE_OK || a.status == X86_DECODE_OUTPUT_FULL) && a.consumed > 0 && a.consumed <= size - consumed;
        passed &= a.count <= BUSTER_ARRAY_LENGTH(scalar) && memcmp(scalar, vector, a.count <= BUSTER_ARRAY_LENGTH(scalar) ? a.count * sizeof(*scalar) : 0) == 0;
        if (!passed && report)
        {
            fprintf(stderr, "ELF decoder refusal/mismatch at file byte 0x%llx: scalar status=%u count=%llu consumed=%llu; vector status=%u count=%llu consumed=%llu\n", (unsigned long long)(offset + consumed), a.status, (unsigned long long)a.count, (unsigned long long)a.consumed, b.status, (unsigned long long)b.count, (unsigned long long)b.consumed);
            for (uint64_t i = 0; i < a.count && i < BUSTER_ARRAY_LENGTH(scalar); i += 1)
            {
                if (memcmp(&scalar[i], &vector[i], sizeof(*scalar)) != 0)
                {
                    fprintf(stderr, "first differing record %llu: scalar form=%u offset=%u length=%u address32=%u; vector form=%u offset=%u length=%u address32=%u\n", (unsigned long long)i, scalar[i].instruction.form, scalar[i].offset, scalar[i].length, scalar[i].address32, vector[i].instruction.form, vector[i].offset, vector[i].length, vector[i].address32);
                    break;
                }
            }
        }
        for (uint64_t i = 0; passed && i < a.count; i += 1)
        {
            const X86Instruction* record = &scalar[i].instruction;
            passed = x86_target_form_allowed(allowed, record->form) &&
                (scalar[i].address32 ? x86_validate_address32(record, 1) : x86_validate(record, 1)) == 1;
            if (!passed && report)
            {
                fprintf(stderr, "ELF ISA refusal at file byte 0x%llx: form %u\n", (unsigned long long)(offset + consumed + scalar[i].offset), record->form);
            }
        }
        consumed += a.consumed;
        instructions += a.count;
    }
    for (uint64_t i = 0; i < size; i += 1)
    {
        hash = (hash ^ bytes[i]) * UINT64_C(1099511628211);
    }
    if (report)
    {
        printf("executable section: file=0x%llx bytes=%llu instructions=%llu fnv1a64=%016llx exact decoders, audit=%s\n", (unsigned long long)offset, (unsigned long long)size, (unsigned long long)instructions, (unsigned long long)hash, passed ? "pass" : "FAIL");
    }
    return passed && consumed == size && instructions != 0;
}

static bool audit_elf(const uint8_t* bytes, uint64_t size, const X86Target* target, bool report)
{
    Elf64_Ehdr header = {0};
    bool passed = size >= sizeof(header);
    if (passed)
    {
        memcpy(&header, bytes, sizeof(header));
        passed = memcmp(header.e_ident, ELFMAG, SELFMAG) == 0 && header.e_ident[EI_CLASS] == ELFCLASS64 &&
            header.e_ident[EI_DATA] == ELFDATA2LSB && header.e_ident[EI_VERSION] == EV_CURRENT &&
            header.e_version == EV_CURRENT && header.e_machine == EM_X86_64 &&
            (header.e_type == ET_REL || header.e_type == ET_EXEC || header.e_type == ET_DYN) && header.e_ehsize == sizeof(header) &&
            header.e_shentsize == sizeof(Elf64_Shdr) && header.e_shnum != 0 && header.e_shnum < SHN_LORESERVE &&
            header.e_shoff <= size && (uint64_t)header.e_shnum * sizeof(Elf64_Shdr) <= size - header.e_shoff;
    }
    uint8_t allowed[X86_FORM_COUNT];
    x86_target_forms(target, allowed);
    uint32_t sections = 0;
    for (uint32_t i = 0; passed && i < header.e_shnum; i += 1)
    {
        Elf64_Shdr section;
        memcpy(&section, bytes + header.e_shoff + (uint64_t)i * sizeof(section), sizeof(section));
        if ((section.sh_flags & SHF_EXECINSTR) != 0 && section.sh_size != 0)
        {
            passed = section.sh_type == SHT_PROGBITS && section.sh_offset <= size && section.sh_size <= size - section.sh_offset;
            passed = passed && audit_range(bytes + section.sh_offset, section.sh_size, section.sh_offset, allowed, report);
            sections += 1;
        }
    }
    return passed && sections != 0;
}

static bool audit_self_test(void)
{
    static const uint8_t code[][8] = {
        { 0x31, 0xed, 0xc3 }, // XOR ebp,ebp; RET. Nonzero registers also exercise encoder validation initialization.
        { 0xc5, 0xf8, 0x77, 0xc3 }, // VZEROUPPER; RET.
        { 0x62, 0xf1, 0x7c, 0x48, 0x58, 0xc0, 0xc3 }, // VADDPS zmm0,zmm0,zmm0; RET.
        { 0x67, 0x8b, 0x00, 0xc3 }, // MOV eax,[eax]; RET. Address32 is valid at every ISA level.
    };
    static const uint32_t sizes[] = {3, 4, 7, 4};
    static const char* const profiles[] = {"x86-64", "x86-64-v3", "x86-64-v4"};
    bool passed = true;
    for (uint32_t p = 0; p < BUSTER_ARRAY_LENGTH(profiles); p += 1)
    {
        X86Target target = {0};
        passed &= x86_target_parse(profiles[p], strlen(profiles[p]), &target);
        for (uint32_t c = 0; c < BUSTER_ARRAY_LENGTH(code); c += 1)
        {
            uint8_t image[256 + 2 * sizeof(code[0]) + 1] = {0};
            Elf64_Ehdr header = {0};
            memcpy(header.e_ident, ELFMAG, SELFMAG);
            header.e_ident[EI_CLASS] = ELFCLASS64;
            header.e_ident[EI_DATA] = ELFDATA2LSB;
            header.e_ident[EI_VERSION] = EV_CURRENT;
            header.e_version = EV_CURRENT;
            header.e_machine = EM_X86_64;
            header.e_type = ET_REL;
            header.e_ehsize = sizeof(header);
            header.e_shoff = sizeof(header);
            header.e_shnum = 3;
            header.e_shentsize = sizeof(Elf64_Shdr);
            Elf64_Shdr first = { .sh_type = SHT_PROGBITS, .sh_flags = SHF_ALLOC | SHF_EXECINSTR, .sh_offset = 256, .sh_size = sizes[c], .sh_addralign = 1 };
            Elf64_Shdr second = first;
            second.sh_offset += sizes[c] + 1;
            memcpy(image, &header, sizeof(header));
            memcpy(image + sizeof(header) + sizeof(Elf64_Shdr), &first, sizeof(first));
            memcpy(image + sizeof(header) + 2 * sizeof(Elf64_Shdr), &second, sizeof(second));
            memcpy(image + first.sh_offset, code[c], sizes[c]);
            memcpy(image + second.sh_offset, code[c], sizes[c]);
            const uint64_t size = second.sh_offset + sizes[c];
            passed &= audit_elf(image, size, &target, false) == (c == 3 || p >= c);
            passed &= !audit_elf(image, 8, &target, false);
            first.sh_size = size + 1;
            memcpy(image + sizeof(header) + sizeof(Elf64_Shdr), &first, sizeof(first));
            passed &= !audit_elf(image, size, &target, false);
        }
    }
    printf("ELF audit self-test: %s (baseline/address32/VEX/EVEX positives and ISA negatives; section gaps, truncated headers and bounds)\n", passed ? "pass" : "FAIL");
    return passed;
}

int main(int argc, char** argv)
{
    bool passed = x86_encoder_initialize() && x86_encoder_initialize_address32() && x86_disassembler_initialize();
    if (argc == 2 && strcmp(argv[1], "--self-test") == 0)
    {
        passed &= audit_self_test();
    }
    else
    {
        X86Target target = {0};
        passed = passed && argc == 3 && x86_target_parse(argv[1], strlen(argv[1]), &target);
        const int fd = passed ? open(argv[2], O_RDONLY | O_CLOEXEC) : -1;
        struct stat info = {0};
        passed = passed && fd >= 0 && fstat(fd, &info) == 0 && info.st_size > 0 && (uint64_t)info.st_size <= UINT32_MAX;
        const uint64_t size = passed ? (uint64_t)info.st_size : 0;
        void* mapping = passed ? mmap(0, size, PROT_READ, MAP_PRIVATE, fd, 0) : MAP_FAILED;
        passed = passed && mapping != MAP_FAILED && audit_elf(mapping, size, &target, true);
        if (mapping != MAP_FAILED)
        {
            munmap(mapping, size);
        }
        if (fd >= 0)
        {
            close(fd);
        }
    }
    passed = fflush(stdout) == 0 && !ferror(stdout) && passed;
    if (!passed)
    {
        fprintf(stderr, "ELF ISA audit failed; usage: audit-elf --self-test | PROFILE ELF\n");
    }
    return passed ? 0 : 1;
}
