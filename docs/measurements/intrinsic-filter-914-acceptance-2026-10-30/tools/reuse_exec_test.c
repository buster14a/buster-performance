// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Independent positive and negative guards for the offline decoder adapter.
#define _GNU_SOURCE
#include <dlfcn.h>
#include <elfutils/libdwfl.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

typedef unsigned long (*Count)(void);

int main(int argc, char** argv)
{
    Count reuses = (Count)dlsym(RTLD_DEFAULT, "perf914_reuses");
    Count delegates = (Count)dlsym(RTLD_DEFAULT, "perf914_delegates");
    bool valid = argc == 4 && reuses != NULL && delegates != NULL;
    const Dwfl_Callbacks callbacks = { .section_address = dwfl_offline_section_address };
    unsigned controls = 0;
    for (unsigned which = 0; valid && which < 6; which += 1)
    {
        Dwfl* dwfl = dwfl_begin(&callbacks);
        valid = dwfl != NULL;
        if (valid)
        {
            const char* first_file = which == 3 ? argv[3] : argv[1];
            const GElf_Addr base = which == 3 ? 0x700000000000ull : 0x401000;
            const unsigned long before = reuses();
            const unsigned long delegated_before = delegates();
            Dwfl_Module* first = dwfl_report_elf(dwfl, "compiler", first_file, -1, base, false);
            valid = first != NULL && reuses() == before && delegates() == delegated_before + 1;
            if (valid && which != 5)
            {
                const char* name = which == 1 ? "other" : "compiler";
                const char* file = which == 2 ? argv[2] : first_file;
                const bool add_p_vaddr = which == 4;
                Dwfl_Module* second = dwfl_report_elf(dwfl, name, file, -1, base, add_p_vaddr);
                if (which == 0)
                {
                    valid = second == first && reuses() == before + 1 && delegates() == delegated_before + 1;
                }
                else
                {
                    valid = reuses() == before && delegates() == delegated_before + 2;
                }
            }
            dwfl_end(dwfl);
        }
        controls += valid;
    }
    printf("duplicate-ET_EXEC decoder adapter: %u controls, %s\n", controls, valid ? "passed" : "FAILED");
    return valid ? 0 : 1;
}
