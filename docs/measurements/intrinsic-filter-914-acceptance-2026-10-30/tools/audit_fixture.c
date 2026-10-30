// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original synthetic records; contains no sampled task or environment bytes.
#include <linux/perf_event.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void word(unsigned char* p, uint64_t v, unsigned n)
{
    for (unsigned i = 0; i < n; i += 1) { p[i] = (unsigned char)(v >> (8 * i)); }
}

int main(int argc, char** argv)
{
    unsigned char file[1024] = {0};
    const uint64_t attr_size = sizeof(struct perf_event_attr) + 16;
    const uint64_t data_off = 104 + attr_size;
    const uint64_t sample_size = 56 + 8 + 20 * 8 + 8;
    uint64_t data_size = 56 + sample_size;
    struct perf_event_attr attr = { .type = PERF_TYPE_HARDWARE, .size = sizeof(attr), .config = PERF_COUNT_HW_CPU_CYCLES,
        .sample_period = 250003, .sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU |
        PERF_SAMPLE_PERIOD | PERF_SAMPLE_CALLCHAIN | PERF_SAMPLE_REGS_USER | PERF_SAMPLE_STACK_USER,
        .exclude_kernel = 1, .exclude_hv = 1, .sample_id_all = 1, .sample_regs_user = UINT64_C(0xff0fff), .sample_stack_user = 4096 };
    int mode = argc == 3 ? atoi(argv[1]) : -1;
    if (mode == 6) { attr.sample_type |= PERF_SAMPLE_ADDR; }
    memcpy(file, "PERFILE2", 8); word(file + 8, 104, 8); word(file + 16, attr_size, 8);
    word(file + 24, 104, 8); word(file + 32, attr_size, 8); word(file + 40, data_off, 8);
    memcpy(file + 104, &attr, sizeof(attr));
    unsigned char* comm = file + data_off;
    word(comm, PERF_RECORD_COMM, 4); word(comm + 4, PERF_RECORD_MISC_COMM_EXEC, 2); word(comm + 6, 56, 2);
    word(comm + 8, 1, 4); word(comm + 12, 1, 4); memcpy(comm + 16, "compiler", 9);
    word(comm + 32, 1, 4); word(comm + 36, 1, 4); word(comm + 40, 0, 8); word(comm + 48, 2, 4);
    unsigned char* sample = comm + 56;
    word(sample, PERF_RECORD_SAMPLE, 4); word(sample + 4, PERF_RECORD_MISC_USER, 2); word(sample + 6, sample_size, 2);
    word(sample + 8, 0x1234, 8); word(sample + 16, 1, 4); word(sample + 20, 1, 4);
    word(sample + 24, 1, 8); word(sample + 32, 2, 4); word(sample + 40, 250003, 8);
    word(sample + 48, 0, 8); word(sample + 56, PERF_SAMPLE_REGS_ABI_64, 8);
    if (mode >= 1 && mode <= 4)
    {
        const uint32_t kinds[] = {0, PERF_RECORD_LOST, PERF_RECORD_LOST_SAMPLES, PERF_RECORD_THROTTLE, PERF_RECORD_UNTHROTTLE};
        word(comm, kinds[mode], 4); word(comm + (mode == 1 ? 16 : 8), 1, 8);
    }
    if (mode == 5) { word(comm + 6, 0, 2); }
    if (mode == 7) { word(sample + 6, sample_size - 8, 2); }
    if (mode == 8) { word(sample + 56, 17, 8); }
    word(file + 48, data_size, 8);
    uint64_t file_size = data_off + data_size;
    if (mode == 9) { file_size -= 1; }
    FILE* output = argc == 3 && mode >= 0 && mode <= 9 ? fopen(argv[2], "wb") : NULL;
    int result = 1;
    if (output != NULL)
    {
        const int wrote = fwrite(file, 1, (size_t)file_size, output) == file_size;
        result = fclose(output) == 0 && wrote ? 0 : 1;
    }
    return result;
}
