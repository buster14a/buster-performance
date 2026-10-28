// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Independent PR627 checks: malformed scalar/reference precedence, publication rollback, reference liveness,
// and the exact bounded witness window. The baseline build changes only c_check_data.c through an include overlay.
#define BUSTER_UNIT 99
#define BUSTER_CHECK_DATA_WITNESS_PARTS 8u
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

static void review627_expect(CheckTest* test, bool valid, uint32_t scenario, uint32_t limited, uint32_t tls, const char* message)
{
    if (!valid)
    {
        fprintf(stderr, "scenario=%u limited=%u tls=%u: ", scenario, limited, tls);
    }
    check_test_expect(test, valid, message);
}

static void review627_cases(CheckTest* test, TypeTable* types)
{
    const TypeId array = type_array(types, BUSTER_TYPE_UCHAR, 32);
    const TypeId pointer = type_pointer(types, BUSTER_TYPE_INT);
    for (uint32_t tls = 0; tls < 2; tls += 1)
    {
        for (uint32_t scenario = 0; scenario < 12; scenario += 1)
        {
            for (uint32_t limited = 0; limited < 2; limited += 1)
            {
                CheckDataTestLink fixture = { 0 };
                const bool ready = check_data_test_open(&fixture, 8);
                review627_expect(test, ready, scenario, limited, tls, "fixture storage");
                if (ready)
                {
                    const uint64_t original_capacity = fixture.bytes.capacity;
                    const uint64_t prefix = 17;
                    uint8_t* prefix_bytes = arena_push(&fixture.bytes, prefix, 1);
                    memset(prefix_bytes, 0x69, prefix);
                    SymbolId map[3] = { 0 };
                    map[1] = check_data_test_symbol(&fixture.link, "object", (tls != 0 ? BUSTER_LINK_SYMBOL_TLS : BUSTER_LINK_SYMBOL_OBJECT) | BUSTER_LINK_SYMBOL_GLOBAL);
                    map[2] = check_data_test_symbol(&fixture.link, "target", ((scenario == 4 || scenario == 5) ? BUSTER_LINK_SYMBOL_TLS : BUSTER_LINK_SYMBOL_OBJECT) | BUSTER_LINK_SYMBOL_GLOBAL);
                    CheckInitPart parts[4] = {
                        { .kind = CHECK_INIT_CLEAR, .type = array, .byte_count = 32 },
                        { .kind = CHECK_INIT_VALUE, .type = BUSTER_TYPE_UCHAR, .value = check_test_integer(BUSTER_TYPE_UCHAR, 1) },
                        { .kind = CHECK_INIT_VALUE, .type = BUSTER_TYPE_UCHAR, .bit_offset = 16, .value = check_test_integer(BUSTER_TYPE_UCHAR, 3) },
                    };
                    uint32_t part_count = 3;
                    CheckDataStatus expected = CHECK_DATA_INVALID;
                    const bool good = scenario == 5 || scenario >= 8;
                    if (scenario == 0)
                    {
                        parts[1].value.integer = 256;
                    }
                    else if (scenario == 1)
                    {
                        parts[1].value.type = BUSTER_TYPE_UINT;
                    }
                    else
                    {
                        parts[1] = (CheckInitPart){
                            .kind = CHECK_INIT_VALUE,
                            .type = pointer,
                            .bit_offset = 64,
                            .value = {
                                .type = pointer,
                                .category = CHECK_RVALUE,
                                .flags = BUSTER_CHECK_STATIC_OBJECT,
                                .constant_kind = CHECK_CONSTANT_ADDRESS,
                                .object = scenario == 2 || scenario == 6 ? 99 : 2,
                                .offset = 7,
                            },
                        };
                        expected = scenario == 4 ? CHECK_DATA_UNSUPPORTED : scenario == 7 ? CHECK_DATA_NON_CONSTANT : CHECK_DATA_SYMBOL;
                        if (scenario >= 5 && scenario <= 7)
                        {
                            parts[3] = parts[2];
                            parts[2] = (CheckInitPart){ .kind = CHECK_INIT_CLEAR, .type = pointer, .bit_offset = 64, .byte_count = 8 };
                            part_count = 4;
                        }
                        if (scenario == 3)
                        {
                            map[2] = 0;
                        }
                        if (scenario == 7)
                        {
                            parts[1].value.flags = 0;
                        }
                    }
                    if (limited != 0)
                    {
                        fixture.bytes.capacity = prefix;
                    }
                    if (scenario == 9)
                    {
                        fixture.link.atoms.capacity = fixture.link.atoms.count;
                    }
                    else if (scenario == 10)
                    {
                        fixture.link.fixups.capacity = fixture.link.fixups.count;
                    }
                    const CheckInitializer initializer = { .type = array, .parts = parts, .count = part_count };
                    CheckDataObject objects[2] = {
                        { .type = array, .object = 1, .initializer = BUSTER_CHECK_NONE, .token = 101, .initializer_plan = &initializer },
                        { .type = array, .object = 1, .initializer = BUSTER_CHECK_NONE, .token = 202, .initializer_plan = &initializer },
                    };
                    const uint32_t count = scenario == 11 ? 2 : 1;
                    const Link previous = fixture.link;
                    const uint64_t tables_size = fixture.tables.length;
                    uint8_t* tables = malloc(tables_size);
                    review627_expect(test, tables != 0, scenario, limited, tls, "table snapshot storage");
                    if (tables != 0)
                    {
                        memcpy(tables, fixture.tables.base, tables_size);
                        CheckDataResult result = { 0 };
                        const bool emitted = check_data_emit(types, 0, objects, count, map, BUSTER_ARRAY_LENGTH(map), &fixture.link, 0,
                                                             &fixture.bytes, &fixture.scratch, &result);
                        const bool successful = good && limited == 0 && scenario != 9 && scenario != 10 && scenario != 11;
                        if (good)
                        {
                            expected = successful ? CHECK_DATA_OK : scenario == 11 ? CHECK_DATA_SYMBOL : CHECK_DATA_RESOURCE;
                        }
                        review627_expect(test, emitted == successful && result.status == expected, scenario, limited, tls, "status and diagnostic precedence");
                        bool prefix_ok = true;
                        for (uint32_t i = 0; i < prefix; i += 1)
                        {
                            prefix_ok &= fixture.bytes.base[i] == 0x69;
                        }
                        review627_expect(test, prefix_ok && fixture.scratch.length == 0, scenario, limited, tls, "live input prefix and scratch preserved");
                        if (successful)
                        {
                            uint8_t expected_bytes[32] = { 0 };
                            expected_bytes[2] = 3;
                            const AtomId atom = fixture.link.symbols.atom[map[1]];
                            const uint32_t fixups = scenario == 5 ? 0 : 1;
                            const uint8_t class = tls != 0 ? BUSTER_LINK_CLASS_TDATA : BUSTER_LINK_CLASS_DATA;
                            const bool payload = atom != 0 && fixture.link.atoms.class[atom] == class &&
                                                 memcmp(fixture.link.atoms.bytes[atom], expected_bytes, sizeof(expected_bytes)) == 0 &&
                                                 result.byte_count == 32 && result.fixup_count == fixups && fixture.bytes.length == prefix + 32;
                            review627_expect(test, payload && link_check(&fixture.link) == LINK_ERROR_NONE, scenario, limited, tls, "bytes, class, fixups and retained demand");
                            if (fixups != 0)
                            {
                                const FixupId fixup = fixture.link.atoms.fixup_begin[atom];
                                review627_expect(test, fixture.link.fixups.offset[fixup] == 8 && fixture.link.fixups.target[fixup] == map[2], scenario, limited, tls, "live relocation offset and target");
                            }
                        }
                        else
                        {
                            const bool rollback = memcmp(&previous, &fixture.link, sizeof(previous)) == 0 &&
                                                  memcmp(tables, fixture.tables.base, tables_size) == 0 && fixture.bytes.length == prefix;
                            review627_expect(test, rollback, scenario, limited, tls, "failed planning preserves Link tables, symbols and byte length");
                            if (expected == CHECK_DATA_RESOURCE && good)
                            {
                                review627_expect(test, result.atom_count == 1 && result.fixup_count == (scenario == 5 ? 0u : 1u) && result.byte_count == 32,
                                                 scenario, limited, tls, "capacity failure retains exact valid demand");
                            }
                            else
                            {
                                review627_expect(test, result.atom_count == 0 && result.byte_count == 0 && result.failed_record == (scenario == 11 ? 1u : 0u),
                                                 scenario, limited, tls, "semantic planning failure publishes no demand");
                            }
                        }
                        printf("case=%u limited=%u tls=%u status=%u atoms=%u fixups=%u bytes=%" PRIu64 "\n",
                               scenario, limited, tls, result.status, result.atom_count, result.fixup_count, result.byte_count);
                        free(tables);
                    }
                    fixture.bytes.capacity = original_capacity;
                }
                check_data_test_close(&fixture);
            }
        }
    }
}

static void review627_cutoff(CheckTest* test, TypeTable* types)
{
    enum { COUNT = 12, SIZE = 16 };
    const TypeId array = type_array(types, BUSTER_TYPE_UCHAR, SIZE);
    const uint64_t page = (uint64_t)sysconf(_SC_PAGESIZE);
    for (uint32_t distance = 8; distance <= 9; distance += 1)
    {
        uint8_t* mapping = mmap(0, page * 2, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        const bool guarded = mapping != MAP_FAILED && COUNT * sizeof(CheckInitPart) <= page && mprotect(mapping, page, PROT_READ | PROT_WRITE) == 0;
        check_test_expect(test, guarded, "guarded initializer parts");
        if (guarded)
        {
            CheckInitPart* parts = (CheckInitPart*)(mapping + page) - COUNT;
            for (uint32_t i = 0; i < COUNT; i += 1)
            {
                parts[i] = (CheckInitPart){
                    .kind = CHECK_INIT_VALUE,
                    .type = BUSTER_TYPE_UCHAR,
                    .bit_offset = (uint64_t)i * 8,
                    .value = check_test_integer(BUSTER_TYPE_UCHAR, i == COUNT - distance ? 71 : 0),
                };
            }
            const CheckInitializer initializer = { .type = array, .parts = parts, .count = COUNT };
            check_test_expect(test, mprotect(mapping, page, PROT_READ) == 0, "initializer parts immutable at guarded boundary");
#ifndef REVIEW_BASELINE
            check_test_expect(test, check_data_initializer_witness(types, &initializer, SIZE) == (distance == 8), "exact eighth/ninth witness cutoff");
#endif
            CheckDataTestLink fixture = { 0 };
            const bool ready = check_data_test_open(&fixture, 4);
            check_test_expect(test, ready, "cutoff emitter storage");
            if (ready)
            {
                SymbolId map[2] = { 0 };
                map[1] = check_data_test_symbol(&fixture.link, "cutoff", BUSTER_LINK_SYMBOL_OBJECT | BUSTER_LINK_SYMBOL_GLOBAL);
                const CheckDataObject object = { .type = array, .object = 1, .initializer = BUSTER_CHECK_NONE, .initializer_plan = &initializer };
                CheckDataResult result = { 0 };
                const bool emitted = check_data_emit(types, 0, &object, 1, map, BUSTER_ARRAY_LENGTH(map), &fixture.link, 0, &fixture.bytes, &fixture.scratch, &result);
                uint8_t expected[SIZE] = { 0 };
                expected[COUNT - distance] = 71;
                const AtomId atom = fixture.link.symbols.atom[map[1]];
                check_test_expect(test, emitted && atom != 0 && fixture.link.atoms.class[atom] == BUSTER_LINK_CLASS_DATA &&
                                       memcmp(fixture.link.atoms.bytes[atom], expected, SIZE) == 0 && result.byte_count == SIZE && result.fixup_count == 0,
                                  "cutoff changes no bytes, class or publication demand");
                printf("cutoff=%u status=%u bytes=%" PRIu64 " fixups=%u\n", distance, result.status, result.byte_count, result.fixup_count);
            }
            check_data_test_close(&fixture);
        }
        if (mapping != MAP_FAILED)
        {
            munmap(mapping, page * 2);
        }
    }
}

int main(void)
{
    CheckTest test = { .random = 627 };
    CheckTestTypes types = { 0 };
    const bool ready = check_test_types_open(&types);
    check_test_expect(&test, ready, "type storage");
    if (ready)
    {
        review627_cases(&test, &types.table);
        review627_cutoff(&test, &types.table);
    }
    check_test_types_close(&types);
    scratch_release();
    printf("review627: %" PRIu64 " assertions, %" PRIu64 " failures\n", test.checks, test.failures);
    return test.failures != 0;
}
