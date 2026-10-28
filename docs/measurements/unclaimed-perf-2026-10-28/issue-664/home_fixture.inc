static int tier0_test_home_key_compare(const void* left, const void* right)
{
    const uint64_t a = *(const uint64_t*)left;
    const uint64_t b = *(const uint64_t*)right;
    return (a > b) - (a < b);
}

static void tier0_test_home_oracle(const Tier0Function* function, Tier0Frame* frame, Tier0Home* homes, const uint32_t* references, const uint64_t* keys)
{
    uint32_t taken = frame->clobbers | 1u << X86_REGISTER_RSP | (frame->pointer ? 1u << X86_REGISTER_RBP : 0) | (frame->based ? 1u << X86_REGISTER_R15 : 0);
    memset(homes, 0, (uint64_t)function->local_count * sizeof(*homes));
    for (uint32_t k = 0; k < function->local_count; k += 1)
    {
        const uint32_t local = (uint32_t)keys[k];
        const bool eligible = references[local] != 0 && (function->local_flags[local] & BUSTER_TYPED_LOCAL_ADDRESS_TAKEN) == 0;
        uint32_t chosen = UINT32_MAX;
        const bool floating = tier0_class_floating(function->local_classes[local]);
        for (uint32_t x = 0; x < 16 && floating && eligible && chosen == UINT32_MAX; x += 1)
        {
            chosen = (taken & 1u << BUSTER_TIER0_XMM(x)) == 0 ? x : UINT32_MAX;
        }
        for (uint32_t d = 0; d < BUSTER_TIER0_CALLER_SAVED_DEPTHS && !floating && eligible && chosen == UINT32_MAX; d += 1)
        {
            const uint32_t reg = tier0_integer_depths[d];
            chosen = (taken & 1u << reg) == 0 ? reg : UINT32_MAX;
        }
        for (uint32_t c = 0; c < BUSTER_TIER0_CALLEE_SAVED && !floating && eligible && references[local] >= 2 && chosen == UINT32_MAX; c += 1)
        {
            const uint32_t reg = tier0_callee_saved[c];
            if ((taken & 1u << reg) == 0)
            {
                chosen = reg;
                frame->saved |= 1u << c;
            }
        }
        if (chosen != UINT32_MAX)
        {
            homes[local].is_register = 1;
            homes[local].reg = (uint8_t)chosen;
            taken |= 1u << (floating ? BUSTER_TIER0_XMM(chosen) : chosen);
        }
    }
    for (uint32_t c = 0; c < BUSTER_TIER0_CALLEE_SAVED; c += 1)
    {
        frame->saved |= (frame->clobbers & 1u << tier0_callee_saved[c]) != 0 ? 1u << c : 0;
    }
    frame->saved |= frame->based ? 1u << BUSTER_TIER0_SAVED_R15 : 0;
    frame->pushes = (uint32_t)__builtin_popcount(frame->saved) + (frame->pointer ? 1u : 0u);
}

// All columns end at protected pages: tails around 16 and 64, then up to 100,000 locals. The keys cover ties, zeros,
// arbitrary u32 counts, increasing/decreasing orders and the alternating references builtin recipes produce. Check
// each prefix against the full order, then both complete home assignments against the original greedy policy.
static void tier0_test_home_candidates(Tier0TestTally* tally, uint64_t seed)
{
    const uint32_t maximum = 100000;
    const uint64_t span = ((uint64_t)maximum * sizeof(uint64_t) + BUSTER_TIER0_TEST_PAGE - 1) / BUSTER_TIER0_TEST_PAGE * BUSTER_TIER0_TEST_PAGE;
    const uint64_t stride = span + BUSTER_TIER0_TEST_PAGE;
    uint8_t* pages = mmap(0, 7 * stride, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    bool guarded = pages != MAP_FAILED;
    for (uint32_t column = 0; column < 7 && guarded; column += 1)
    {
        guarded = mprotect(pages + column * stride + span, BUSTER_TIER0_TEST_PAGE, PROT_NONE) == 0;
    }
    tier0_test_expect(tally, guarded, "home candidates", "no guarded columns");
    uint64_t random = seed ^ UINT64_C(0x363634686f6d6573);
    static const uint32_t sizes[] = { 81, 127, 255, 1024, 4097, 16384, 65536, 100000 };
    for (uint32_t test = 0; test < 81 + BUSTER_ARRAY_LENGTH(sizes) && guarded; test += 1)
    {
        const uint32_t locals = test < 81 ? test : sizes[test - 81];
        uint32_t* references = (uint32_t*)(pages + span) - locals;
        uint8_t* classes = pages + stride + span - locals;
        uint8_t* flags = pages + 2 * stride + span - locals;
        Tier0Home* expected = (Tier0Home*)(pages + 3 * stride + span) - locals;
        Tier0Home* scalar = (Tier0Home*)(pages + 4 * stride + span) - locals;
        Tier0Home* vector = (Tier0Home*)(pages + 5 * stride + span) - locals;
        uint64_t* keys = (uint64_t*)(pages + 6 * stride + span) - locals;
        for (uint32_t pattern = 0; pattern < 10; pattern += 1)
        {
            for (uint32_t local = 0; local < locals; local += 1)
            {
                static const uint32_t recipe[] = { 2, 26, 17, 1 };
                const uint32_t generated = tier0_generate_below(&random, UINT32_MAX);
                references[local] = pattern == 0 ? 0 : pattern == 1 ? 1 : pattern == 2 ? 2 : pattern == 3 ? local + 1 :
                                    pattern == 4 ? locals - local : pattern == 5 ? recipe[local % 4] : pattern == 6 ? generated % 7 :
                                    pattern == 7 ? UINT32_MAX - generated % 7 : pattern == 8 ? generated : (local % 97 == 0 ? generated : 0);
                classes[local] = pattern == 3 || pattern == 5 ? BUSTER_TYPED_CLASS_I64 : pattern == 4 ? BUSTER_TYPED_CLASS_F64 :
                                 local % 3 == 0 ? BUSTER_TYPED_CLASS_F32 : local % 3 == 1 ? BUSTER_TYPED_CLASS_F64 : BUSTER_TYPED_CLASS_I64;
                flags[local] = pattern % 2 == 0 && generated % 5 == 0 ? BUSTER_TYPED_LOCAL_ADDRESS_TAKEN : 0;
                keys[local] = (uint64_t)(UINT32_MAX - references[local]) << 32 | local;
                expected[local] = (Tier0Home){ .is_register = (uint8_t)(pattern % 3 == 0 && generated % 7 == 0) };
            }
            qsort(keys, locals, sizeof(*keys), tier0_test_home_key_compare);
            uint32_t old[1024];
            for (uint32_t local = 0; local < locals && locals <= BUSTER_ARRAY_LENGTH(old); local += 1)
            {
                uint32_t at = local;
                while (at > 0 && references[old[at - 1]] < references[local])
                {
                    old[at] = old[at - 1];
                    at -= 1;
                }
                old[at] = local;
            }
            bool stable = true;
            for (uint32_t local = 0; local < locals && locals <= BUSTER_ARRAY_LENGTH(old); local += 1)
            {
                stable &= old[local] == (uint32_t)keys[local];
            }
            tier0_test_expect(tally, stable, "home candidates", "%u locals, pattern %u: full-order oracle differs from old stable sort", locals, pattern);
            Tier0Function function = { .local_count = locals, .local_classes = classes, .local_flags = flags };
            uint32_t wanted[2 * BUSTER_TIER0_HOME_CANDIDATES];
            uint32_t count = 0;
            for (uint32_t kind = 0; kind < 2; kind += 1)
            {
                uint32_t kept = 0;
                for (uint32_t k = 0; k < locals && kept < BUSTER_TIER0_HOME_CANDIDATES; k += 1)
                {
                    const uint32_t local = (uint32_t)keys[k];
                    if (references[local] != 0 && expected[local].is_register == 0 && (flags[local] & BUSTER_TYPED_LOCAL_ADDRESS_TAKEN) == 0 &&
                        tier0_class_floating(classes[local]) == (kind != 0))
                    {
                        wanted[count++] = local;
                        kept += 1;
                    }
                }
            }
            uint32_t orders[2][2 * BUSTER_TIER0_HOME_CANDIDATES + 1];
            memset(orders, 0x9d, sizeof(orders));
            const uint32_t scalar_count = tier0_register_locals(&function, expected, references, orders[0]);
            const uint32_t vector_count = tier0_register_locals_vector(&function, expected, references, orders[1]);
            const bool same = scalar_count == count && vector_count == count && memcmp(wanted, orders[0], count * sizeof(*wanted)) == 0 &&
                              memcmp(wanted, orders[1], count * sizeof(*wanted)) == 0 && orders[0][count] == UINT32_C(0x9d9d9d9d) && orders[1][count] == UINT32_C(0x9d9d9d9d);
            tier0_test_expect(tally, same, "home candidates", "%u locals, pattern %u: eligible prefixes differ", locals, pattern);
            Tier0Frame frame = { .clobbers = pattern % 3 == 0 ? 0 : pattern % 3 == 1 ? UINT32_MAX : tier0_generate_below(&random, UINT32_MAX),
                                 .pointer = pattern % 2 != 0, .based = pattern % 4 == 3 };
            Tier0Frame scalar_frame = frame;
            Tier0Frame vector_frame = frame;
            tier0_test_home_oracle(&function, &frame, expected, references, keys);
            tier0_assign_homes(&function, &scalar_frame, scalar, references, orders[0], false);
            tier0_assign_homes(&function, &vector_frame, vector, references, orders[1], true);
            const bool homes = memcmp(expected, scalar, (uint64_t)locals * sizeof(*expected)) == 0 && memcmp(expected, vector, (uint64_t)locals * sizeof(*expected)) == 0 &&
                               frame.saved == scalar_frame.saved && frame.saved == vector_frame.saved && frame.pushes == scalar_frame.pushes && frame.pushes == vector_frame.pushes;
            tier0_test_expect(tally, homes, "home candidates", "%u locals, pattern %u: complete homes or save masks differ from greedy oracle", locals, pattern);
        }
    }
    if (pages != MAP_FAILED)
    {
        munmap(pages, 7 * stride);
    }
}

