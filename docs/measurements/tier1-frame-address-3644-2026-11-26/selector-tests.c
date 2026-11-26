// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Standalone correctness driver for the unmodified production selector and its
// owning tests. It uses the benchmark unit's existing dependency set but runs
// no benchmarks. The compiler's C frontend is deliberately absent.
#include "buster/compiler/tier1_select_benchmark.c"
#include "buster/compiler/ir_validate.c"
#include "buster/compiler/ir_parse.c"
#include <dirent.h>

// The production test suite's input loader, from ir_parse_test.c at base
// 74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe. Its owning parse tests are not
// otherwise dependencies of this standalone selector/emitter driver.
static bool ir_parse_test_read(const char* path, Arena* source, String8* text)
{
    FILE* stream = fopen(path, "rb");
    bool ok = stream != 0;
    if (ok)
    {
        ok = fseek(stream, 0, SEEK_END) == 0;
        const long length = ok ? ftell(stream) : -1;
        ok = length >= 0 && fseek(stream, 0, SEEK_SET) == 0;
        char* bytes = ok ? arena_push(source, (uint64_t)length, 1) : 0;
        ok = bytes != 0 && ok;
        if (ok)
        {
            ok = fread(bytes, 1, (size_t)length, stream) == (size_t)length && ferror(stream) == 0;
            if (ok)
            {
                *text = (String8){
                    .pointer = bytes,
                    .length = (uint64_t)length,
                };
            }
        }
        fclose(stream);
    }
    return ok;
}

#define BUSTER_IN_UNIT(unit) 1
#define BUSTER_UNIT_BACKEND 8
#include "buster/compiler/tier1_select_test.c"
#include "buster/compiler/dominators_export.c"
#include "buster/compiler/dominators_test.c"
#include "buster/compiler/tier1_allocate_test.c"
#include "buster/compiler/tier1_cfg_test.c"
#include "buster/compiler/tier1_frame_execution_test.c"
// Shared scalar conversion oracle from tier0_test.c, copied unchanged from
// base 74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe, with its license notice.
#include "tier0-unsigned-oracle.inc"
#include "buster/compiler/tier1_emit_test.c"

int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 2 && strcmp(argv[1], "select") == 0)
    {
        result = run_tier1_select_tests(argc - 2, argv + 2);
    }
    else if (argc >= 2 && strcmp(argv[1], "emit") == 0)
    {
        result = run_tier1_emit_tests(argc - 2, argv + 2);
    }
    return result;
}
