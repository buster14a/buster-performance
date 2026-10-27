// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original declaration-time expression fixtures, checked by both parser/checker paths and installed Clang.
static void check_test_constant_parameter_names(CheckTest* test)
{
    enum { COUNT = 1024 };
    const uint64_t page = (uint64_t)sysconf(_SC_PAGESIZE);
    const uint64_t bytes = COUNT * sizeof(CheckConstantParameter);
    const uint64_t readable = (bytes + page - 1) / page * page;
    uint8_t* mapping = mmap(0, readable + page, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    const bool ready = mapping != MAP_FAILED && mprotect(mapping + readable, page, PROT_NONE) == 0;
    check_test_expect(test, ready, "prototype name tree guarded records");
    if (ready)
    {
        CheckConstantParameter* parameters = (CheckConstantParameter*)(mapping + readable - bytes);
        CheckConstantPart functions[2] = { 0 };
        uint8_t owners[COUNT];
        for (uint32_t i = 0; i < COUNT - 2; i += 1)
        {
            // The first 33 names force every bit decision, including bit 31; later names mix duplicates,
            // unnamed parameters and two interleaved prototype scopes. The independent oracle scans only here.
            const uint32_t name = i < 32 ? ~(UINT32_C(1) << i) : i == 32 ? UINT32_MAX : (i * 73) % 193;
            owners[i] = i < 33 ? 0 : i & 1;
            parameters[i] = (CheckConstantParameter){ .name = name };
            bool expected = true;
            for (uint32_t previous = 0; previous < i; previous += 1)
            {
                expected &= name == 0 || owners[previous] != owners[i] || parameters[previous].name != name;
            }
            const bool unique = check_constant_parameter_unique(&functions[owners[i]], parameters, i);
            check_test_expect(test, unique == expected, "prototype name tree differs from independent membership");
        }
        parameters[COUNT - 1] = (CheckConstantParameter){ .name = UINT32_MAX };
        check_test_expect(test, !check_constant_parameter_unique(&functions[0], parameters, COUNT - 1), "prototype name tree full-depth duplicate");
        CheckConstantPart empty = { 0 };
        parameters[COUNT - 1] = (CheckConstantParameter){ 0 };
        check_test_expect(test, check_constant_parameter_unique(&empty, parameters, COUNT - 1) && empty.parameter_names == 0,
                          "unnamed parameter leaves prototype tree empty");
    }
    if (mapping != MAP_FAILED)
    {
        munmap(mapping, readable + page);
    }
}

