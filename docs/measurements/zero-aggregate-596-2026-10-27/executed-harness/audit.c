// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Include the compiler only to invoke its real data planner and arena/Link APIs; uncalled code is discarded.
#define BUSTER_UNIT 99
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(int argc, char** argv)
{
    const uint64_t size = argc == 3 ? strtoull(argv[2], NULL, 10) : 0;
    bool valid = size >= 8 && size <= (UINT64_C(1) << 30);
    CheckTestTypes types = { 0 };
    CheckDataTestLink fixture = { 0 };
    valid = valid && check_test_types_open(&types) && check_data_test_open(&fixture, 4);
    if (valid)
    {
        arena_release(&fixture.scratch);
        fixture.scratch = arena_reserve(size + (UINT64_C(1) << 20));
        const TypeId array = type_array(&types.table, BUSTER_TYPE_UCHAR, size);
        SymbolId map[3] = { 0 };
        const bool tls = strcmp(argv[1], "tls") == 0;
        map[1] = check_data_test_symbol(&fixture.link, "a", BUSTER_LINK_SYMBOL_GLOBAL | (tls ? BUSTER_LINK_SYMBOL_TLS : BUSTER_LINK_SYMBOL_OBJECT));
        CheckInitPart parts[3] = {
            { .kind = CHECK_INIT_CLEAR, .type = array, .byte_count = size },
            { .kind = CHECK_INIT_VALUE, .type = BUSTER_TYPE_UCHAR, .bit_offset = (size - 1) * 8,
              .value = check_test_integer(BUSTER_TYPE_UCHAR, 0) },
            { .kind = CHECK_INIT_CLEAR, .type = BUSTER_TYPE_UCHAR, .bit_offset = (size - 1) * 8, .byte_count = 1 },
        };
        const CheckInitializer initializer = {
            .type = array,
            .parts = parts,
            .count = strcmp(argv[1], "overwrite") == 0 ? 3 : 2,
        };
        if (initializer.count == 3)
        {
            parts[1].value.integer = 255;
        }
        const CheckDataObject object = {
            .type = array,
            .object = 1,
            .initializer = BUSTER_CHECK_NONE,
            .initializer_plan = &initializer,
        };
        CheckDataResult result = { 0 };
        audit_scratch = &fixture.scratch;
        valid = check_data_emit(&types.table, NULL, &object, 1, map, 3, &fixture.link, 0, &fixture.bytes, &fixture.scratch, &result);
        audit_scratch = NULL;
        const AtomId atom = fixture.link.symbols.atom[map[1]];
        valid = valid && result.byte_count == 0 && result.fixup_count == 0 && atom != 0 &&
                fixture.link.atoms.size[atom] == size && fixture.link.atoms.class[atom] == (tls ? BUSTER_LINK_CLASS_TBSS : BUSTER_LINK_CLASS_BSS);
        printf("%s\t%llu\trequested=%llu\tpeak=%llu\tcleared=%llu\tcopied=%llu\tscanned=%llu\tstatus=%u\n", argv[1],
               (unsigned long long)size, (unsigned long long)audit_requested, (unsigned long long)audit_peak,
               (unsigned long long)audit_cleared, (unsigned long long)audit_copied, (unsigned long long)audit_scanned, !valid);
    }
    check_data_test_close(&fixture);
    check_test_types_close(&types);
    return valid ? 0 : 1;
}
