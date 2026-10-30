// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#define _POSIX_C_SOURCE 200809L

#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

enum fixture_mode
{
    fixture_valid,
    fixture_missing_record,
    fixture_duplicate_record,
    fixture_nonzero_status,
    fixture_zero_wall,
    fixture_zero_cycles,
    fixture_zero_instructions,
    fixture_missing_file,
    fixture_warning,
    fixture_failed_done,
    fixture_missing_done,
    fixture_extra_file,
    fixture_overflow_run,
    fixture_overflow_status,
    fixture_overflow_counters,
    fixture_overflow_cycles,
    fixture_overflow_instructions,
    fixture_run_tab,
    fixture_unknown_text,
    fixture_trailing_text,
    fixture_valid_producer,
    fixture_signed_range_counter,
    fixture_valid_wide_summary,
    fixture_valid_reversed,
    fixture_wrong_reference,
    fixture_mode_count
};

static const char *const mode_names[fixture_mode_count] =
{
    "valid",
    "missing-record",
    "duplicate-record",
    "nonzero-status",
    "zero-wall",
    "zero-cycles",
    "zero-instructions",
    "missing-file",
    "warning",
    "failed-done",
    "missing-done",
    "extra-file",
    "overflow-run",
    "overflow-status",
    "overflow-counters",
    "overflow-cycles",
    "overflow-instructions",
    "run-tab",
    "unknown-text",
    "trailing-text",
    "valid-producer",
    "signed-range-counter",
    "valid-wide-summary",
    "valid-reversed",
    "wrong-reference"
};

enum
{
    path_capacity = 4096,
    name_capacity = 32
};

static bool write_record(FILE *output, unsigned int sample, unsigned int list,
                         unsigned int build, unsigned int copy,
                         enum fixture_mode mode, bool first_record)
{
    unsigned int copy_offset = (copy - 1U) * 100U;
    unsigned int wall_us = (build == 0U ? 1000U : 500U) + sample + copy_offset;
    unsigned int cycles = (build == 0U ? 1000U : 900U) + sample + copy_offset;
    unsigned int instructions = (build == 0U ? 2000U : 1800U) + sample + copy_offset;
    unsigned int status = 0U;
    char sample_number[16];
    char cycles_number[32];
    char instructions_number[32];
    char status_number[16];

    if (first_record)
    {
        if (mode == fixture_nonzero_status)
        {
            status = 1U;
        }
        else if (mode == fixture_zero_wall)
        {
            wall_us = 0U;
        }
        else if (mode == fixture_zero_cycles)
        {
            cycles = 0U;
        }
        else if (mode == fixture_zero_instructions)
        {
            instructions = 0U;
        }
    }

    (void)snprintf(sample_number, sizeof(sample_number), "%u", sample);
    (void)snprintf(cycles_number, sizeof(cycles_number), "%u", cycles);
    (void)snprintf(instructions_number, sizeof(instructions_number), "%u", instructions);
    (void)snprintf(status_number, sizeof(status_number), "%u", status);

    const char *separator = first_record && mode == fixture_run_tab ? "\t" : " ";
    const char *sample_text = first_record && mode == fixture_overflow_run
                              ? "4294967297" : sample_number;
    const char *cycles_text = cycles_number;
    const char *instructions_text = instructions_number;
    if (first_record && (mode == fixture_overflow_counters || mode == fixture_overflow_cycles))
    {
        cycles_text = "18446744073709551616";
    }
    if (first_record && (mode == fixture_overflow_counters || mode == fixture_overflow_instructions))
    {
        instructions_text = "18446744073709551616";
    }
    if (first_record && mode == fixture_signed_range_counter)
    {
        cycles_text = "9223372036854775808";
        instructions_text = "9223372036854775808";
    }
    const char *status_text = first_record && mode == fixture_overflow_status
                              ? "4294967296" : status_number;
    int result = fprintf(output,
                         "run%s%s list %u %s copy %u: %u.%03u ms wall, "
                         "0.900 ms user, 0.100 ms system, 1000 KiB wait4 peak, "
                         "10 minor faults, 0 major, %s user cycles, "
                         "%s instructions, status %s\n",
                         separator, sample_text, list, build == 0U ? "base" : "head",
                         copy, wall_us / 1000U, wall_us % 1000U, cycles_text,
                         instructions_text, status_text);

    return result >= 0;
}

// Shapes and precision match src/buster/compiler/profile.c's shipping producer.
// Its pooled comparison uses the upper middle sample: the reader must recompute
// the required arithmetic median from raw rows instead of trusting these lines.
static bool write_producer_shapes(FILE *output, bool wide_summary, bool reversed)
{
    bool success = true;

    for (unsigned int list = 1U; success && list <= 3U; ++list)
    {
        for (unsigned int build = 0U; success && build < 2U; ++build)
        {
            for (unsigned int copy = 1U; success && copy <= 2U; ++copy)
            {
                unsigned int offset = (copy - 1U) * 100U;
                unsigned int wall = (build == 0U ? 1000U : 500U) + 11U + offset;
                unsigned int cycles = (build == 0U ? 1000U : 900U) + 11U + offset;
                unsigned int instructions = (build == 0U ? 2000U : 1800U) + 11U + offset;
                success = fprintf(output,
                                  "list %u %s copy %u [-fsyntax-only source-%u.c]: "
                                  "21 runs, median %u.%03u ms wall "
                                  "(%u.%03u to %u.%03u), 0.900 ms user, "
                                  "0.100 ms system, 1000 KiB wait4 peak, "
                                  "10 minor faults, 0 major, %u user cycles, "
                                  "%u instructions\n",
                                  list, build == 0U ? "base" : "head", copy, list,
                                  wall / 1000U, wall % 1000U,
                                  (wall - 10U) / 1000U, (wall - 10U) % 1000U,
                                  (wall + 10U) / 1000U, (wall + 10U) % 1000U,
                                  cycles, instructions) >= 0;
            }
        }
    }
    for (unsigned int list = 1U; success && list <= 3U; ++list)
    {
        for (unsigned int metric = 0U; success && metric < 2U; ++metric)
        {
            double reference = 1101.0;
            double candidate = metric == 0U ? 601.0 : 1001.0;
            double base_copy1 = 1011.0;
            double base_copy2 = 1111.0;
            double head_copy1 = metric == 0U ? 511.0 : 911.0;
            double head_copy2 = metric == 0U ? 611.0 : 1011.0;
            const char *reference_name = reversed ? "head" : "base";
            const char *candidate_name = reversed ? "base" : "head";
            double reference_copy1 = reversed ? head_copy1 : base_copy1;
            double reference_copy2 = reversed ? head_copy2 : base_copy2;
            double candidate_copy1 = reversed ? base_copy1 : head_copy1;
            double candidate_copy2 = reversed ? base_copy2 : head_copy2;
            if (reversed)
            {
                double previous = reference;
                reference = candidate;
                candidate = previous;
            }
            double scale = metric == 0U ? 1000.0 : 1000000.0;
            double reference_summary = wide_summary && metric == 1U
                                        ? 4000000.0 : reference / scale;
            double candidate_summary = wide_summary && metric == 1U
                                        ? 4000001.0 : candidate / scale;
            success = fprintf(output,
                              "list %u, %s:\n"
                              "  %s: 42 runs, median %.3f; copies within %.2f%%\n"
                              "  %s: 42 runs, median %.3f; copies within %.2f%%; "
                              "against %s %+.2f%% (over copies %+.2f%% to %+.2f%%)\n",
                              list, metric == 0U ? "wall time (ms)" : "user cycles (millions)",
                              reference_name, reference_summary, (reference_copy2 / reference_copy1 - 1.0) * 100.0,
                              candidate_name, candidate_summary, (candidate_copy2 / candidate_copy1 - 1.0) * 100.0,
                              reference_name,
                              (candidate / reference - 1.0) * 100.0,
                              (candidate_copy1 / reference_copy2 - 1.0) * 100.0,
                              (candidate_copy2 / reference_copy1 - 1.0) * 100.0) >= 0;
        }
    }

    return success;
}

static bool write_log(int root_fd, unsigned int parallelism, unsigned int size,
                      enum fixture_mode mode, bool first_file)
{
    char name[name_capacity];
    int name_length = snprintf(name, sizeof(name), "time-p%u-s%u.log",
                               parallelism, size);
    bool success = name_length >= 0 && (size_t)name_length < sizeof(name);
    int output_fd = -1;
    FILE *output = NULL;

    if (success)
    {
        output_fd = openat(root_fd, name,
                           O_WRONLY | O_CREAT | O_EXCL | O_NOFOLLOW | O_CLOEXEC,
                           0666);
        success = output_fd >= 0;
    }
    if (success)
    {
        output = fdopen(output_fd, "w");
        success = output != NULL;
        if (!success)
        {
            int saved_errno = errno;
            (void)close(output_fd);
            errno = saved_errno;
        }
    }
    if (!success)
    {
        fprintf(stderr, "Cannot create fixture %s: %s\n", name, strerror(errno));
    }

    const bool producer = mode == fixture_valid_producer || mode == fixture_valid_wide_summary ||
                          mode == fixture_valid_reversed || mode == fixture_wrong_reference;
    if (success && producer)
    {
        success = fputs("memory: wait4 peaks include pre-exec memory and waited "
                        "descendants; executable-only peak unavailable (not measured)\n",
                        output) >= 0;
    }
    for (unsigned int list = 1U; success && list <= 3U; ++list)
    {
        for (unsigned int order = 0U; success && order < 2U; ++order)
        {
            const unsigned int build = parallelism == 2U ? 1U - order : order;
            for (unsigned int copy = 1U; success && copy <= 2U; ++copy)
            {
                for (unsigned int sample = 1U; success && sample <= 21U; ++sample)
                {
                    bool first_record = first_file && list == 1U && build == 0U
                                        && copy == 1U && sample == 1U;
                    if (!(first_record && mode == fixture_missing_record))
                    {
                        enum fixture_mode record_mode = mode == fixture_run_tab
                                                        ? fixture_valid : mode;
                        success = write_record(output, sample, list, build, copy,
                                               record_mode, first_record);
                        if (success && first_record && mode == fixture_duplicate_record)
                        {
                            success = write_record(output, sample, list, build,
                                                   copy, mode, first_record);
                        }
                    }
                }
            }
        }
    }

    if (success && producer)
    {
        success = write_producer_shapes(output, mode == fixture_valid_wide_summary,
                                        parallelism == 2U && mode != fixture_wrong_reference);
    }
    if (success && first_file && mode == fixture_run_tab)
    {
        success = write_record(output, 1U, 1U, 0U, 1U, mode, true);
    }
    if (success && first_file && mode == fixture_unknown_text)
    {
        success = fputs("time-runs: unexpected report text\n", output) >= 0;
    }
    if (success && first_file && mode == fixture_warning)
    {
        success = fputs("time-runs: user cycles weren't counted for every process, "
                        "so they aren't compared\n", output) >= 0;
    }
    if (success && !(first_file && mode == fixture_missing_done))
    {
        unsigned int failures = first_file && mode == fixture_failed_done ? 1U : 0U;
        success = fprintf(output, "time-runs: done, %u failed processes\n", failures) >= 0;
    }
    if (success && first_file && mode == fixture_trailing_text)
    {
        success = fputs("unexpected trailing report text\n", output) >= 0;
    }
    if (output != NULL)
    {
        bool closed = fclose(output) == 0;
        if (!success || !closed)
        {
            fprintf(stderr, "Cannot finish fixture %s: %s\n", name, strerror(errno));
            success = false;
        }
    }

    return success;
}

int main(int argc, char **argv)
{
    int result = 1;
    enum fixture_mode mode = fixture_mode_count;
    int root_fd = -1;

    if (argc != 3)
    {
        fprintf(stderr, "Usage: %s ROOT MODE\n", argv[0]);
    }
    else if (strlen(argv[1]) > path_capacity - name_capacity - 1U)
    {
        fputs("Fixture root path is too long\n", stderr);
    }
    else
    {
        for (unsigned int index = 0U; index < fixture_mode_count; ++index)
        {
            if (strcmp(argv[2], mode_names[index]) == 0)
            {
                mode = (enum fixture_mode)index;
            }
        }
        if (mode == fixture_mode_count)
        {
            fprintf(stderr, "Unknown fixture mode: %s\n", argv[2]);
        }
        else
        {
            root_fd = open(argv[1], O_RDONLY | O_DIRECTORY | O_CLOEXEC);
            if (root_fd < 0)
            {
                fprintf(stderr, "Cannot open fixture root: %s\n", strerror(errno));
            }
        }
    }

    if (root_fd >= 0)
    {
        const unsigned int sizes[] =
        {
            0U, 64U, 256U
        };
        bool success = true;

        for (unsigned int parallelism = 1U; success && parallelism <= 3U; ++parallelism)
        {
            for (unsigned int index = 0U; success && index < 3U; ++index)
            {
                bool first_file = parallelism == 1U && index == 0U;
                if (!(first_file && mode == fixture_missing_file))
                {
                    success = write_log(root_fd, parallelism, sizes[index], mode,
                                        first_file);
                }
            }
        }
        if (success && mode == fixture_extra_file)
        {
            success = write_log(root_fd, 4U, 0U, mode, false);
        }
        if (close(root_fd) != 0)
        {
            fprintf(stderr, "Cannot close fixture root: %s\n", strerror(errno));
            success = false;
        }
        result = success ? 0 : 1;
    }

    return result;
}
