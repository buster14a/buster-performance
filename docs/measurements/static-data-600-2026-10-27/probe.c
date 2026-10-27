// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original API-level telemetry for #600. Counter totals include scalar writes and metadata memset calls.
#define BUSTER_UNIT 99
#include "probe_main.h"

_Thread_local ThreadContext thread_context = {
    .lane = {
        .count = 1,
    },
};

int main(int argc, char** argv)
{
    bool valid = argc == 4;
    const char* mode = valid ? argv[1] : "";
    const uint64_t size = valid ? strtoull(argv[2], 0, 10) : 0;
    const uint32_t count = valid ? (uint32_t)strtoul(argv[3], 0, 10) : 0;
    valid = valid && size != 0 && count != 0 && count <= 256;
    CheckTestTypes types = { 0 };
    CheckDataTestLink fixture = { 0 };
    Arena input = arena_reserve(size + (uint64_t)count * (sizeof(CheckInitPart) + sizeof(CheckInitializer) + sizeof(CheckDataObject) + sizeof(SymbolId)) + 65536);
    valid = valid && check_test_types_open(&types) && check_data_test_open(&fixture, count + 1);
    if (valid)
    {
        arena_release(&fixture.bytes);
        arena_release(&fixture.scratch);
        fixture.bytes = arena_reserve(size * count + 65536);
        fixture.scratch = arena_reserve(size * count + 65536);
        const bool literal = strcmp(mode, "literal") == 0;
        const bool relocation = strcmp(mode, "relocation") == 0;
        const bool readonly = strcmp(mode, "readonly") == 0;
        const TypeId element = relocation ? type_pointer(&types.table, BUSTER_TYPE_UCHAR) : BUSTER_TYPE_UCHAR;
        TypeId array = type_array(&types.table, element, size / (relocation ? 8 : 1));
        if (readonly)
        {
            array = type_qualify(&types.table, array, BUSTER_TYPE_CONST);
        }
        CheckDataObject* objects = BUSTER_ARENA_PUSH_ARRAY(&input, CheckDataObject, count);
        CheckInitPart* parts = BUSTER_ARENA_PUSH_ARRAY(&input, CheckInitPart, count);
        CheckInitializer* initializers = BUSTER_ARENA_PUSH_ARRAY(&input, CheckInitializer, count);
        SymbolId* map = BUSTER_ARENA_PUSH_ARRAY(&input, SymbolId, (uint64_t)count + 2);
        uint8_t* literal_bytes = literal ? arena_push(&input, size, 1) : 0;
        valid = objects != 0 && parts != 0 && initializers != 0 && map != 0 && (!literal || literal_bytes != 0);
        if (literal_bytes != 0)
        {
            memset(literal_bytes, 'x', size);
            literal_bytes[size - 1] = 0;
        }
        for (uint32_t i = 0; valid && i < count; i += 1)
        {
            char name[32];
            snprintf(name, sizeof(name), "object_%u", i);
            map[i + 1] = check_data_test_symbol(&fixture.link, name, BUSTER_LINK_SYMBOL_OBJECT | BUSTER_LINK_SYMBOL_GLOBAL);
            parts[i] = (CheckInitPart){
                .kind = CHECK_INIT_VALUE,
                .type = element,
                .value = check_test_integer(element, 1),
            };
            if (relocation)
            {
                parts[i].value = (CheckValue){
                    .type = element,
                    .category = CHECK_RVALUE,
                    .flags = BUSTER_CHECK_STATIC_OBJECT,
                    .constant_kind = CHECK_CONSTANT_ADDRESS,
                    .object = count + 1,
                    .offset = 4,
                };
            }
            initializers[i] = (CheckInitializer){
                .type = array,
                .parts = parts + i,
                .count = 1,
            };
            objects[i] = (CheckDataObject){
                .type = array,
                .object = i + 1,
                .initializer = BUSTER_CHECK_NONE,
                .initializer_plan = literal ? 0 : initializers + i,
                .literal_bytes = literal_bytes,
                .literal_size = literal ? size : 0,
                .string_pool = literal,
            };
        }
        if (valid)
        {
            map[0] = 0;
            map[count + 1] = check_data_test_symbol(&fixture.link, "external", BUSTER_LINK_SYMBOL_OBJECT | BUSTER_LINK_SYMBOL_GLOBAL);
            data_byte_arena = &fixture.bytes;
            data_scratch_arena = &fixture.scratch;
            CheckDataResult result;
            valid = check_data_emit(&types.table, 0, objects, count, map, count + 2, &fixture.link, 0,
                                    &fixture.bytes, &fixture.scratch, &result);
            valid = valid && result.byte_count == size * count && result.fixup_count == (relocation ? count : 0) &&
                    fixture.scratch.length == 0 && link_check(&fixture.link) == LINK_ERROR_NONE;
            printf("%s\t%llu\t%u\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%d\n", mode,
                   (unsigned long long)size, count, (unsigned long long)data_cleared, (unsigned long long)data_copied,
                   (unsigned long long)data_scanned, (unsigned long long)data_byte_peak, (unsigned long long)data_scratch_peak,
                   (unsigned long long)fixture.bytes.length, (unsigned long long)fixture.scratch.length, valid);
        }
    }
    check_data_test_close(&fixture);
    check_test_types_close(&types);
    arena_release(&input);
    return valid ? 0 : 1;
}
