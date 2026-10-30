// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original offline decoder adapter for the measured no-PIE Buster executables.
#define _GNU_SOURCE
#include <dlfcn.h>
#include <elf.h>
#include <elfutils/libdwfl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Offline, single-threaded perf decoding only. Sampling and measured ELF bytes
// are unchanged. Exposed counters make the narrowly guarded path auditable.
static unsigned long reuses;
static unsigned long delegates;

unsigned long perf914_reuses(void)
{
    return reuses;
}

unsigned long perf914_delegates(void)
{
    return delegates;
}

Dwfl_Module* dwfl_report_elf(Dwfl* dwfl, const char* name, const char* file_name, int fd, GElf_Addr base, bool add_p_vaddr)
{
    typedef Dwfl_Module* (*Report)(Dwfl*, const char*, const char*, int, GElf_Addr, bool);
    Report real_report = (Report)dlsym(RTLD_NEXT, "dwfl_report_elf");
    if (real_report == NULL)
    {
        abort();
    }
    Dwfl_Module* result = NULL;
    if (name != NULL && file_name != NULL && strcmp(name, "compiler") == 0 && fd == -1 && !add_p_vaddr)
    {
        FILE* file = fopen(file_name, "rb");
        Elf64_Ehdr header;
        const bool valid = file != NULL && fread(&header, 1, sizeof(header), file) == sizeof(header) &&
            memcmp(header.e_ident, ELFMAG, SELFMAG) == 0 && header.e_ident[EI_CLASS] == ELFCLASS64 &&
            header.e_ident[EI_DATA] == ELFDATA2LSB && header.e_type == ET_EXEC && header.e_machine == EM_X86_64;
        if (file != NULL)
        {
            fclose(file);
        }
        if (valid)
        {
            Dwfl_Module* existing = dwfl_addrmodule(dwfl, header.e_entry);
            const char* old_file = NULL;
            const char* old_name = existing != NULL ? dwfl_module_info(existing, NULL, NULL, NULL, NULL, NULL, &old_file, NULL) : NULL;
            if (old_name != NULL && old_file != NULL && strcmp(name, old_name) == 0 && strcmp(file_name, old_file) == 0)
            {
                result = existing;
                reuses += 1;
            }
        }
    }
    if (result == NULL)
    {
        delegates += 1;
        result = real_report(dwfl, name, file_name, fd, base, add_p_vaddr);
    }
    return result;
}
