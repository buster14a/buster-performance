// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original current-source work/accounting adapter for #451. Generated copies preserve the production algorithms.
// These counters measure bytes/calls, never claim an instrumented wall-time improvement.
#include <stdint.h>
static uint64_t measure451_lexed_bytes;
static uint64_t measure451_lexer_calls;
static uint64_t measure451_page_bytes;
static uint64_t measure451_page_calls;
#define main buster_unused_main
#include "main451.c"
#undef main

#define MEASURE451_SOURCE_PADDING 512u

static bool prepare_file451(const char* path, uint64_t source)
{
    FILE* file = fopen(path, "rb");
    bool valid = file != NULL && fseek(file, 0, SEEK_END) == 0;
    const long length = valid ? ftell(file) : -1;
    valid = valid && length >= 0 && (uint64_t)length < UINT32_MAX - MEASURE451_SOURCE_PADDING;
    uint8_t* bytes = valid ? malloc((uint64_t)length + MEASURE451_SOURCE_PADDING) : NULL;
    valid = valid && bytes != NULL && fseek(file, 0, SEEK_SET) == 0;
    if (valid)
    {
        valid = fread(bytes, 1, (uint64_t)length, file) == (uint64_t)length;
        memset(bytes + length, 0, MEASURE451_SOURCE_PADDING);
    }
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    PPWindowTestRun runs[3] = { 0 };
    for (uint32_t run = 0; run < BUSTER_ARRAY_LENGTH(runs); run += 1)
    {
        valid = pp_window_test_initialize(runs + run) && valid;
    }
    if (valid)
    {
        const PPOptions options = { .language = { .standard = 2017, .gnu = true } };
        PPPrepare prepare = pp_prepare_options(&options);
        PPPrepare scalar = prepare;
        scalar.vectorized = false;
        const PPWindowTestText text = { .bytes = bytes, .length = (uint32_t)length, .capacity = (uint32_t)length };
        PPFileData whole;
        PPFileData twin;
        const PPPrepareStatus whole_status = pp_window_test_prepare(&runs[0], &prepare, &text, 0, &whole);
        const PPPrepareStatus twin_status = pp_window_test_prepare(&runs[1], &scalar, &text, 0, &twin);
        valid = whole_status == PP_PREPARE_DONE && pp_window_test_same(whole_status, &whole, twin_status, &twin, "scalar", source, 0);
        static const uint32_t windows[] = { 64, 4096, BUSTER_PP_WINDOW_BYTES };
        const bool applies = !c_tokenize_scalar_only(bytes, text.length, prepare.refine_flags);
        printf("source=%lu file=%s bytes=%u tokens=%u directives=%u scalar_equal=%u windows_apply=%u\n",
               (unsigned long)source, path, text.length, whole.token_count, whole.directive_count, (uint32_t)valid, (uint32_t)applies);
        for (uint32_t w = 0; valid && applies && w < BUSTER_ARRAY_LENGTH(windows); w += 1)
        {
            measure451_lexed_bytes = 0;
            measure451_lexer_calls = 0;
            measure451_page_bytes = 0;
            measure451_page_calls = 0;
            PPFileData data;
            const PPPrepareStatus status = pp_window_test_prepare(&runs[2], &prepare, &text, windows[w], &data);
            valid = pp_window_test_same(whole_status, &whole, status, &data, "windows", source, windows[w]) &&
                    status == PP_PREPARE_DONE && pp_window_test_line_pages(&data, source, windows[w]) && measure451_page_bytes == text.length;
            printf("source=%lu window=%u production_windowed=%u lexed_bytes=%lu relexed_bytes=%lu lexer_calls=%lu page_bytes=%lu page_calls=%lu exact_records_and_lines=%u\n",
                   (unsigned long)source, windows[w], (uint32_t)(prepare.vectorized && text.length >= (uint64_t)windows[w] * 2), (unsigned long)measure451_lexed_bytes,
                   (unsigned long)(measure451_lexed_bytes - text.length), (unsigned long)measure451_lexer_calls,
                   (unsigned long)measure451_page_bytes, (unsigned long)measure451_page_calls, (uint32_t)valid);
        }
    }
    for (uint32_t run = 0; run < BUSTER_ARRAY_LENGTH(runs); run += 1)
    {
        pp_window_test_release(runs + run);
    }
    free(bytes);
    return valid;
}

int main(int argc, char** argv)
{
    printf("prepare451 source=e7f89091648f68940b595aadd648841c1ffc3ec5 host_vector=%u\n", (uint32_t)BUSTER_HOST_VECTOR);
    bool valid = argc > 1;
    const bool preprocess = valid && strcmp(argv[1], "--preprocess") == 0;
    if (preprocess)
    {
        valid = argc > 2 && run_preprocessor_command(argc - 2, argv + 2) == 0;
        printf("preprocess451 windowed_lexed_bytes=%lu windowed_relexed_bytes=%lu lexer_calls=%lu page_bytes=%lu page_calls=%lu status=%u\n",
               (unsigned long)measure451_lexed_bytes, (unsigned long)(measure451_lexed_bytes - measure451_page_bytes),
               (unsigned long)measure451_lexer_calls, (unsigned long)measure451_page_bytes, (unsigned long)measure451_page_calls, (uint32_t)valid);
    }
    else
    {
        for (int file = 1; valid && file < argc; file += 1)
        {
            valid = prepare_file451(argv[file], (uint64_t)file);
        }
    }
    printf("prepare451: %s\n", valid ? "pass" : "FAIL");
    return !valid;
}
