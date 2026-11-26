// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// Real selected-IR pressure fixtures for tier1_emit.c. The integer oracle is independent of the machine plan.
// Both allocation paths execute through the frame helper, branch sizing and encoder in a child process. This file
// tests the bounded backend contract; tier1_pipeline_test.c separately exercises the upstream typed/IR/SSA producer.

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>

typedef struct Tier1EmitTest Tier1EmitTest;
struct Tier1EmitTest
{
    uint64_t checks;
    uint64_t failures;
    uint64_t stores;
    uint64_t loads;
    uint64_t copies;
    uint32_t terms;
    uint32_t width;
    bool selects;
    Arena input;
    Arena output;
    Arena scratch;
    uint8_t* allowed;
    const uint8_t* native_allowed;
    uint64_t native_skipped;
    // The floating fixtures' compiles whose calls save an xmm register (#1116's check of their rows).
    uint32_t vector_saves;
    // The call fixtures' register arguments whose hint each consumer was checked to name (#2646): the CFG consumer's
    // uses, and the straight-line consumer's intervals that end at their calls.
    uint32_t general_hints;
    uint32_t straight_hints;
};

// A requested output policy may exceed the current CPU. The policy/encoding checks still run; only the native call skips.
static bool tier1_emit_test_native(Tier1EmitTest* test, const X86Instruction* records, uint32_t count)
{
    const bool supported = test->native_allowed == 0 || x86_target_validate(test->native_allowed, records, count) == count;
    test->native_skipped += !supported;
    return supported;
}

static void tier1_emit_test_expect(Tier1EmitTest* test, bool passed, const char* message)
{
    test->checks += 1;
    if (!passed)
    {
        if (test->failures < 20)
        {
            fprintf(stderr, "tier1-emit: %s (terms=%u, width=%u, selects=%u)\n", message, test->terms, test->width, test->selects);
        }
        test->failures += 1;
    }
}

static uint64_t tier1_emit_test_random(uint64_t* random)
{
    *random ^= *random << 13;
    *random ^= *random >> 7;
    *random ^= *random << 17;
    return *random;
}

static void tier1_emit_test_node(IrFunction* function, uint32_t node, IrOp op, IrType type, uint32_t a, uint32_t b)
{
    function->op[node] = (uint8_t)op;
    function->type[node] = (uint8_t)type;
    function->a[node] = a;
    function->b[node] = b;
    function->c[node] = BUSTER_IR_NONE;
}

static bool tier1_emit_test_fixture(Tier1EmitTest* test, IrFunction* function)
{
    const uint32_t terms = test->terms;
    const uint32_t prefix = test->selects ? 4 : 2;
    const uint32_t count = terms * 3 + prefix + 1;
    const IrType type = test->width == 4 ? IR_I32 : IR_I64;
    const IrSizes sizes = { .instruction_count = count, .block_count = 1, .constant_count = terms + test->selects, .parameter_count = 2 };
    bool ok = ir_create(&test->input, &sizes, function) == IR_OK;
    if (ok)
    {
        function->result_type = (uint8_t)type;
        function->parameter_types[0] = (uint8_t)type;
        function->parameter_types[1] = (uint8_t)type;
        function->block_offsets[1] = count;
        tier1_emit_test_node(function, 0, IR_PARAM, (IrType)function->parameter_types[0], 0, BUSTER_IR_NONE);
        tier1_emit_test_node(function, 1, IR_PARAM, type, 1, BUSTER_IR_NONE);
        if (test->selects)
        {
            tier1_emit_test_node(function, 2, IR_CONST, type, terms, BUSTER_IR_NONE);
            tier1_emit_test_node(function, 3, IR_ICMP, IR_I1, 0, 2);
            function->c[3] = IR_NE;
        }
        uint64_t random = UINT64_C(0x34635a27d768b2f1);
        for (uint32_t term = 0; term < terms; term += 1)
        {
            const uint64_t value = tier1_emit_test_random(&random);
            function->constants[term].low = test->width == 4 ? (uint32_t)value : value;
            const uint32_t node = prefix + term * (test->selects ? 1 : 2);
            tier1_emit_test_node(function, node, IR_CONST, type, term, BUSTER_IR_NONE);
            if (!test->selects)
            {
                tier1_emit_test_node(function, node + 1, IR_XOR, type, 0, node);
            }
        }
        uint32_t sum = 1;
        uint32_t node = prefix + terms * (test->selects ? 1 : 2);
        for (uint32_t term = 0; term < terms; term += 1)
        {
            uint32_t value = 3 + term * 2;
            if (test->selects)
            {
                tier1_emit_test_node(function, node, IR_SELECT, type, 3, prefix + term);
                function->c[node] = 1;
                value = node++;
            }
            tier1_emit_test_node(function, node, IR_ADD, type, sum, value);
            sum = node++;
        }
        tier1_emit_test_node(function, node, IR_RET, IR_VOID, sum, BUSTER_IR_NONE);
        ok = node + 1 == count;
    }
    return ok;
}

static uint64_t tier1_emit_test_expected(const Tier1EmitTest* test, const IrFunction* function, uint64_t a, uint64_t b)
{
    const uint64_t mask = test->width == 4 ? UINT32_MAX : UINT64_MAX;
    uint64_t result = b;
    for (uint32_t term = 0; term < test->terms; term += 1)
    {
        const uint64_t value = function->constants[term].low;
        result += test->selects ? (a != 0 ? value : b) : a ^ value;
    }
    return result & mask;
}

static __attribute__((no_sanitize("function"))) uint64_t tier1_emit_test_call(const void* code, uint64_t a, uint64_t b)
{
    uint64_t (*function)(uint64_t, uint64_t);
    memcpy(&function, &code, sizeof(function));
    return function(a, b);
}

// The code with its branches sized, encoded into `bytes` of new pages and made executable: whether it runs natively
// here. The caller unmaps `executable` (MAP_FAILED where nothing was mapped).
static bool tier1_emit_test_load(Tier1EmitTest* test, Tier1SelectCode* code, void** executable, uint64_t* bytes)
{
    const uint64_t capacity = BUSTER_X86_ENCODER_CAPACITY(code->count);
    *bytes = (capacity + 4095) & ~UINT64_C(4095);
    *executable = mmap(0, *bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    uint32_t* offsets = malloc((uint64_t)code->count * sizeof(uint32_t));
    bool ready = *executable != MAP_FAILED && offsets != 0;
    tier1_emit_test_expect(test, ready, "native execution buffer");
    if (ready)
    {
        const BranchSizingCheck checked = branch_sizing_validate(code->records, code->count, code->branches, code->targets, code->branch_count);
        const BranchSizing sized = checked.error == BRANCH_SIZING_OK ? size_branches(code->records, code->count, code->branches, code->targets, code->branch_count, offsets) : (BranchSizing){ .error = checked.error };
        ready = sized.error == BRANCH_SIZING_OK;
        tier1_emit_test_expect(test, ready, "frame branches size with body records");
    }
    if (ready)
    {
        // #221: every record of the frame and body has a form x86_semantics.c covers, which the effects' consumers need.
        bool covered = true;
        for (uint32_t r = 0; r < code->count; r += 1)
        {
            covered &= x86_effects(code->records[r].form)->operation != X86_OPERATION_NONE;
        }
        tier1_emit_test_expect(test, covered, "every frame and body record has a covered form");
        // #181: and a complete Zen 5 row (x86_zen5_rows.c), which the model's consumers need.
        tier1_emit_test_expect(test, x86_zen5_missing(code->records, code->count, BUSTER_X86_COST_ALL_COLUMNS) == 0, "every frame and body record has a complete Zen 5 row");
        ready = x86_target_validate(test->allowed, code->records, code->count) == code->count && x86_encode(code->records, code->count, *executable, capacity, 0, 0) > 0;
        tier1_emit_test_expect(test, ready, "baseline encoder accepts complete frame and body");
        ready = ready && mprotect(*executable, *bytes, PROT_READ | PROT_EXEC) == 0;
        tier1_emit_test_expect(test, ready, "native code made executable");
    }
    free(offsets);
    return ready && tier1_emit_test_native(test, code->records, code->count);
}

static void tier1_emit_test_execute(Tier1EmitTest* test, const IrFunction* function, Tier1EmitResult* emitted)
{
    void* executable = MAP_FAILED;
    uint64_t bytes = 0;
    if (tier1_emit_test_load(test, &emitted->code, &executable, &bytes))
    {
        uint64_t random = UINT64_C(0x0a3385510b49decd);
        for (uint32_t sample = 0; sample < 64; sample += 1)
        {
            const uint64_t a = test->selects ? sample & 1 : sample < 4 ? UINT64_MAX >> sample : tier1_emit_test_random(&random);
            const uint64_t b = sample < 4 ? UINT64_MAX << sample : tier1_emit_test_random(&random);
            const uint64_t actual = tier1_emit_test_call(executable, a, b);
            tier1_emit_test_expect(test, actual == tier1_emit_test_expected(test, function, a, b), "native spilled function equals independent integer oracle");
        }
    }
    if (executable != MAP_FAILED)
    {
        munmap(executable, bytes);
    }
}

static void tier1_emit_test_pressure(Tier1EmitTest* test)
{
    const uint32_t terms[] = {1, 2, 7, 8, 9, 17, 65, 129, 600};
    for (uint32_t width = 4; width <= 8; width += 4)
    {
        test->width = width;
        for (uint32_t selects = 0; selects < 2; selects += 1)
        {
            test->selects = selects != 0;
            for (uint32_t size = 0; size < sizeof(terms) / sizeof(terms[0]); size += 1)
            {
                test->terms = terms[size];
                IrFunction function;
                const bool created = tier1_emit_test_fixture(test, &function);
                tier1_emit_test_expect(test, created, "construct original pressure IR");
                if (created)
                {
                    uint32_t ordinary_spills = 0;
                    for (uint32_t remat = 0; remat < 2; remat += 1)
                    {
                        Tier1SelectPlan plan;
                        uint32_t node;
                        const Tier1SelectError selected = tier1_select_plan(&function, 0, &test->output, &test->scratch, &plan, &node);
                        tier1_emit_test_expect(test, selected == TIER1_SELECT_OK, "select real pressure IR");
                        if (selected == TIER1_SELECT_OK)
                        {
                            const Tier1EmitOptions options = {
                                .certify = true,
                                .register_mask = (1u << X86_REGISTER_RAX) | (1u << X86_REGISTER_RDI) | (1u << X86_REGISTER_RSI),
                                .frame_flags = size % 3 == 0 ? 0 : size % 3 == 1 ? BUSTER_TIER1_FRAME_KEEP_POINTER : BUSTER_TIER1_FRAME_NO_RED_ZONE | BUSTER_TIER1_FRAME_PROBE_STACK,
                                .rematerialize = remat != 0,
                            };
                            Tier1EmitResult emitted;
                            const uint64_t scratch_mark = test->scratch.length;
                            const Tier1EmitError error = tier1_emit_function(&plan, &options, test->allowed, &test->output, &test->scratch, &emitted, &node);
                            tier1_emit_test_expect(test, error == TIER1_EMIT_OK, "liveness, allocation, frame and fragment emission succeed");
                            if (error != TIER1_EMIT_OK && test->failures < 20)
                            {
                                fprintf(stderr, "  emission error=%u node=%u remat=%u\n", error, node, remat);
                            }
                            tier1_emit_test_expect(test, test->scratch.length == scratch_mark, "complete emission returns scratch");
                            if (error == TIER1_EMIT_OK)
                            {
                                tier1_emit_test_expect(test, tier1_allocation_verify(&emitted.prepared.allocation, &emitted.allocation), "independent fragment interference oracle accepts");
                                tier1_emit_test_expect(test, emitted.frame.count == emitted.allocation.spill_count, "frame contains exactly the actual spill values");
                                if (test->terms > 8)
                                {
                                    tier1_emit_test_expect(test, emitted.transition_count != 0, "pressure actually changes physical locations");
                                    tier1_emit_test_expect(test, emitted.spill_stores != 0 && emitted.spill_loads != 0, "pressure actually executes spill stores and reloads");
                                    if (selects && remat)
                                    {
                                        tier1_emit_test_expect(test, emitted.rematerializations != 0, "selected constants are actually recomputed");
                                    }
                                }
                                if (remat == 0)
                                {
                                    ordinary_spills = emitted.allocation.spill_count;
                                }
                                else if (selects && test->terms > 8)
                                {
                                    tier1_emit_test_expect(test, emitted.allocation.spill_count < ordinary_spills, "rematerialization removes real frame slots");
                                }
                                test->stores += emitted.spill_stores;
                                test->loads += emitted.spill_loads;
                                test->copies += emitted.rematerializations;
                                tier1_emit_test_execute(test, &function, &emitted);
                            }
                        }
                        arena_pop_to(&test->output, 0);
                    }
                }
                arena_pop_to(&test->input, 0);
            }
        }
    }
}

static void tier1_emit_test_failures(Tier1EmitTest* test)
{
    test->terms = 17;
    test->width = 8;
    test->selects = true;
    IrFunction function;
    bool ready = tier1_emit_test_fixture(test, &function);
    Tier1SelectPlan plan;
    uint32_t node;
    ready = ready && tier1_select_plan(&function, 0, &test->output, &test->scratch, &plan, &node) == TIER1_SELECT_OK;
    tier1_emit_test_expect(test, ready, "failure fixture selected");
    if (ready)
    {
        const uint64_t mark = test->output.length;
        const uint64_t scratch_mark = test->scratch.length;
        for (uint32_t failure = 0; failure < 4; failure += 1)
        {
            Tier1EmitOptions options = { .register_mask = tier1_liveness_register_mask(), .rematerialize = true, .certify = true };
            Tier1EmitError wanted = TIER1_EMIT_INVALID;
            Arena limited = test->output;
            uint8_t* denied = calloc(X86_FORM_COUNT, 1);
            const uint8_t* allowed = test->allowed;
            if (failure == 0)
            {
                options.register_mask |= 1u << BUSTER_TIER1_SELECT_SCRATCH;
            }
            else if (failure == 1)
            {
                options.frame_flags = BUSTER_TIER1_FRAME_DYNAMIC_STACK;
                wanted = TIER1_EMIT_UNSUPPORTED;
            }
            else if (failure == 2)
            {
                limited.capacity = mark + 1;
                wanted = TIER1_EMIT_MEMORY;
            }
            else
            {
                allowed = denied;
                wanted = TIER1_EMIT_TARGET;
            }
            Tier1EmitResult output;
            memset(&output, 0xa5, sizeof(output));
            Tier1EmitResult before;
            memcpy(&before, &output, sizeof(output));
            const Tier1EmitError error = tier1_emit_function(&plan, &options, allowed, &limited, &test->scratch, &output, &node);
            tier1_emit_test_expect(test, error == wanted, "explicit failure category");
            tier1_emit_test_expect(test, limited.length == mark && test->scratch.length == scratch_mark && memcmp(&output, &before, sizeof(output)) == 0, "failure restores arenas and preserves result");
            free(denied);
        }
    }
    arena_pop_to(&test->output, 0);
    arena_pop_to(&test->input, 0);
    const IrSizes loop_sizes = { .instruction_count = 2, .block_count = 1, .parameter_count = 1 };
    ready = ir_create(&test->input, &loop_sizes, &function) == IR_OK;
    if (ready)
    {
        function.parameter_types[0] = IR_I64;
        function.block_offsets[1] = 2;
        tier1_emit_test_node(&function, 0, IR_PARAM, IR_I64, 0, BUSTER_IR_NONE);
        tier1_emit_test_node(&function, 1, IR_BR, IR_VOID, 0, BUSTER_IR_NONE);
        ready = tier1_select_plan(&function, 0, &test->output, &test->scratch, &plan, &node) == TIER1_SELECT_OK;
        tier1_emit_test_expect(test, ready, "loop fixture selected independently");
        if (ready)
        {
            // The entry is its own loop's header: the CFG consumer puts a block before it and jumps back to the loop.
            const Tier1EmitOptions options = { .register_mask = tier1_liveness_register_mask(), .certify = true };
            Tier1EmitResult output;
            const bool emitted = tier1_emit_function(&plan, &options, test->allowed, &test->output, &test->scratch, &output, &node) == TIER1_EMIT_OK;
            tier1_emit_test_expect(test, emitted, "a loop through the entry goes through the CFG consumer");
            bool back = false;
            for (uint32_t branch = 0; emitted && branch < output.code.branch_count; branch += 1)
            {
                back |= output.code.targets[branch] <= output.code.branches[branch];
            }
            tier1_emit_test_expect(test, !emitted || (output.general && output.cfg_input.block_count == 2 && back), "the loop keeps its jump back, after an added entry");
        }
    }
    arena_pop_to(&test->output, 0);
    arena_pop_to(&test->input, 0);
    const IrSizes empty_sizes = {0};
    ready = ir_create(&test->input, &empty_sizes, &function) == IR_OK && tier1_select_plan(&function, 0, &test->output, &test->scratch, &plan, &node) == TIER1_SELECT_OK;
    if (ready)
    {
        const Tier1EmitOptions options = { .certify = true };
        Tier1EmitResult output;
        const Tier1EmitError error = tier1_emit_function(&plan, &options, test->allowed, &test->output, &test->scratch, &output, &node);
        tier1_emit_test_expect(test, error == TIER1_EMIT_OK && output.code.count == 0 && output.allocation.spill_count == 0, "empty pipeline accepts null columns");
    }
    else
    {
        tier1_emit_test_expect(test, false, "empty fixture selected");
    }
}

// The call-save row that emitted record `r` stores to or loads from, as a bit of the rows' set, with *load saying which;
// 0 for any other record. The rows are a general register's (bits 0 to 15: tier1_emit_call_save's mov), an xmm
// register's (bits 16 to 31: a floating value's movsd, #141, or in a function with vectors the widest one's move, #141)
// and an opmask register's (bits 32 to 39: a mask's kmov of its width, #179), the latter two the CFG consumer's. Each
// row is the frame's, apart from every spill slot, so its displacement tells it from a spill of the same register.
static uint64_t tier1_emit_test_save_row(const Tier1EmitResult* emitted, uint32_t r, bool* load)
{
    const X86Instruction* record = &emitted->code.records[r];
    const uint16_t form = record->form & BUSTER_X86_FORM_NUMBER;
    const Tier1EmitPrepared* prepared = &emitted->prepared;
    const bool memory = record->mode == BUSTER_X86_MEMORY_BASE && record->rm == emitted->frame.base_register;
    const uint32_t reg = record->reg;
    uint64_t row = 0;
    *load = false;
    if (memory && reg < BUSTER_TIER1_EMIT_GENERAL_REGISTERS && ((prepared->call_save_mask >> reg) & 1) != 0 && (form == X86_FORM_MOV_RM64_R64 || form == X86_FORM_MOV_R64_RM64) &&
        record->displacement == tier1_emit_call_save(emitted, reg, false).displacement)
    {
        row = 1ull << reg;
        *load = form == X86_FORM_MOV_R64_RM64;
    }
    const uint32_t vector_row = emitted->general && reg < 16 && ((prepared->vector_save_mask >> reg) & 1) != 0 ? tier1_emit_cfg_vector_save_row(emitted, reg) : UINT32_MAX;
    const Tier1SelectFloatForms* wide = prepared->vector_bytes != 0 ? tier1_select_class_forms(prepared->vector_bytes, tier1_emit_encoding(prepared)) : NULL;
    const uint16_t vector_store = wide != NULL ? wide->store : X86_FORM_MOVSD_XM64_X;
    const uint16_t vector_load = wide != NULL ? wide->load : X86_FORM_MOVSD_X_XM64;
    if (memory && vector_row < emitted->frame.count && (form == vector_store || form == vector_load) && record->displacement == emitted->frame.offset[vector_row])
    {
        row = 1ull << (16 + reg);
        *load = form == vector_load;
    }
    const uint32_t mask_row = emitted->general && reg < 8 && ((prepared->mask_save_mask >> reg) & 1) != 0 ? tier1_emit_cfg_mask_save_row(emitted, reg) : UINT32_MAX;
    for (uint32_t width = 1; memory && mask_row < emitted->frame.count && width <= 8; width *= 2)
    {
        const Tier1SelectMaskForms* forms = tier1_select_mask_forms(width);
        const bool kmov = (form == forms->store || form == forms->load) && record->displacement == emitted->frame.offset[mask_row];
        row = kmov ? 1ull << (32 + reg) : row;
        *load = kmov ? form == forms->load : *load;
    }
    return row;
}

// The general registers' call-save stores among records [first, end).
static uint32_t tier1_emit_test_save_stores(const Tier1EmitResult* emitted, uint32_t first, uint32_t end)
{
    uint32_t stores = 0;
    for (uint32_t r = first; r < end && r < emitted->code.count; r += 1)
    {
        bool load = false;
        const uint64_t row = tier1_emit_test_save_row(emitted, r, &load);
        stores += row != 0 && row < (1ull << 16) && !load;
    }
    return stores;
}

// Whether the records store to some xmm call-save row where the frame has any (prepared's vector_save_mask), and to some
// opmask one where it has any (mask_save_mask): so tier1_emit_test_saves_loaded reads those rows' stores, not none. Not
// every row: the masks count each fragment that covers a call's definition phase, a floating result's among them, which
// its call doesn't store.
static bool tier1_emit_test_saves_seen(const Tier1EmitResult* emitted)
{
    uint64_t seen = 0;
    for (uint32_t r = 0; r < emitted->code.count; r += 1)
    {
        bool load = false;
        const uint64_t row = tier1_emit_test_save_row(emitted, r, &load);
        seen |= load ? 0 : row;
    }
    const bool vectors = emitted->prepared.vector_save_mask == 0 || ((seen >> 16) & 0xffff) != 0;
    const bool masks = emitted->prepared.mask_save_mask == 0 || ((seen >> 32) & 0xff) != 0;
    return !emitted->general || (vectors && masks);
}

// Whether the general registers' call-save rows are exactly those the records store to (#177): each row the frame has is
// one a call or a fixed register's sequence stores a value in, and none goes unused, where every caller-saved register's
// had a row in every function that calls. A store to a register with no row the emitter refuses itself
// (TIER1_EMIT_ALLOCATION).
static bool tier1_emit_test_general_rows_used(const Tier1EmitResult* emitted)
{
    uint64_t stored = 0;
    for (uint32_t r = 0; r < emitted->code.count; r += 1)
    {
        bool load = false;
        const uint64_t row = tier1_emit_test_save_row(emitted, r, &load);
        stored |= !load && row < (1ull << 16) ? row : 0;
    }
    return stored == emitted->prepared.call_save_mask;
}

// Whether every call-save store is loaded back (#1116), of a general, an xmm or an opmask register: a call owes its
// general registers' loads until something needs them, and loads the others back right after it, but each value it
// stores lives past it, so a load of that register from its row follows before the code leaves the straight-line run it
// is in (a branch, a return, a trap or an indirect jump). A store whose load is lost is the failure owing loads could
// introduce; this checks each store, not a total.
static bool tier1_emit_test_saves_loaded(const Tier1EmitResult* emitted)
{
    uint64_t pending = 0;
    bool loaded = true;
    uint32_t branch = 0;
    for (uint32_t r = 0; r < emitted->code.count; r += 1)
    {
        const uint16_t form = emitted->code.records[r].form & BUSTER_X86_FORM_NUMBER;
        while (branch < emitted->code.branch_count && emitted->code.branches[branch] < r)
        {
            branch += 1;
        }
        const bool leaves = form == X86_FORM_RET || form == X86_FORM_UD2 || form == X86_FORM_JMP_RM64 || (branch < emitted->code.branch_count && emitted->code.branches[branch] == r);
        loaded &= !leaves || pending == 0;
        pending = leaves ? 0 : pending;
        bool load = false;
        const uint64_t row = tier1_emit_test_save_row(emitted, r, &load);
        pending = load ? pending & ~row : pending | row;
    }
    return loaded && pending == 0;
}

// Every kind that adds space beyond the per-node bound, across a full chunk and a partial one. Two calls use
// one ABI descriptor; the covered call still counts records, but only the uncovered one can need references.
static void tier1_emit_test_capacity(Tier1EmitTest* test)
{
    uint8_t operations[130] = { [0] = IR_VCONST, [63] = IR_CALL, [64] = IR_CALL_INDIRECT, [65] = IR_CALL, [126] = IR_CALL, [127] = IR_ALLOCA, [128] = IR_RET, [129] = IR_VCONST };
    uint32_t descriptors[130] = { [65] = 1, [126] = 2 };
    uint8_t covered[130] = { [64] = 1 };
    IrCall calls[] = {
        { .abi = 1, .argument_count = 3 },
        { .row = 1 },
        { .body = 1 },
    };
    IrAbiCall abi = { .call.stack_bytes = 16 };
    IrAsmBody body = { .count = 5, .branch_count = 3, .passed = 2 };
    IrFunction function = {
        .op = operations,
        .b = descriptors,
        .instruction_count = 130,
        .calls = calls,
        .call_count = 3,
        .abi_calls = &abi,
        .abi_call_count = 1,
        .asm_bodies = &body,
        .asm_body_count = 1,
        .vector_constant_count = 1,
        .parameter_passed = 1,
        .parameter_count = 2,
        .result_size = 12,
    };
    const Tier1SelectPlan plan = { .function = &function, .covered = covered };
    const uint32_t call = 4 + 4 * 3 + 5 * (BUSTER_ABI_INTEGER_ARGUMENTS + BUSTER_ABI_VECTOR_ARGUMENTS) + 16;
    const uint32_t assembly = 5 + 4 + 2 + 2 * (BUSTER_TIER1_EMIT_GENERAL_REGISTERS + 15 + 7);
    const uint32_t records = 6 + 2 * call + BUSTER_TIER1_EMIT_ROW_RECORDS + assembly + 35 + 4;
    const Tier1EmitCfgCapacity plain = tier1_emit_cfg_capacity(&plan, false);
    const Tier1EmitCfgCapacity probed = tier1_emit_cfg_capacity(&plan, true);
    tier1_emit_test_expect(test, plain.records == records && plain.branches == 3 && plain.references == 7 && plain.literals == 2, "size each call occurrence and both vector literals");
    tier1_emit_test_expect(test, probed.records == records + 4 * 7 + BUSTER_TIER1_EMIT_PROBE_RECORDS && probed.branches == 3 + 2 + BUSTER_TIER1_EMIT_PROBE_BRANCHES &&
                                 probed.references == plain.references && probed.literals == plain.literals, "probe the dynamic allocation and the outgoing areas of function calls");
    function.instruction_count = 64;
    const Tier1EmitCfgCapacity full = tier1_emit_cfg_capacity(&plan, false);
    tier1_emit_test_expect(test, full.records == 6 + call + 2 && full.branches == 0 && full.references == 6 && full.literals == 1, "the last call in a complete 64-node chunk contributes");
    function.instruction_count = 0;
    const Tier1EmitCfgCapacity empty = tier1_emit_cfg_capacity(&plan, true);
    tier1_emit_test_expect(test, empty.records == 6 && empty.branches == 0 && empty.references == 0 && empty.literals == 0, "only the argument records contribute with no nodes");
}

// The call-save rows' helpers (Tier1EmitSaves) on random rows, owners and masks against their definitions: a reset leaves
// every row none and nothing owed; `kept` is the saved registers whose rows hold their owners; after a call the saved
// rows hold their owners and those registers are owed; after a fixed registers' sequence their rows are none. A third
// of the rows hold their owners, so `kept` sees both answers, and some owners are none.
static void tier1_emit_test_saves_rows(Tier1EmitTest* test)
{
    uint64_t random = UINT64_C(0x5be2b9d0c41f7a63);
    bool same = true;
    for (uint32_t round = 0; round < 4096; round += 1)
    {
        Tier1EmitSaves saves;
        Tier1EmitTransitions transitions = { 0 };
        memset(&saves, 0xa5, sizeof(saves));
        tier1_emit_saves_reset(&saves);
        uint32_t rows[BUSTER_TIER1_EMIT_GENERAL_REGISTERS];
        for (uint32_t reg = 0; reg < BUSTER_TIER1_EMIT_GENERAL_REGISTERS; reg += 1)
        {
            same &= saves.rows[reg] == BUSTER_IR_NONE;
            const uint64_t bits = tier1_emit_test_random(&random);
            transitions.owners[reg] = (bits & 7) == 7 ? BUSTER_IR_NONE : (uint32_t)(bits >> 8) & 63;
            rows[reg] = (bits >> 16) % 3 == 0 ? transitions.owners[reg] : (uint32_t)(bits >> 24) & 63;
            saves.rows[reg] = rows[reg];
        }
        same &= saves.owed == 0;
        const uint64_t masks = tier1_emit_test_random(&random);
        const uint32_t saved = (uint32_t)masks & 0xffff;
        const uint32_t fixed = (uint32_t)(masks >> 16) & 0xffff;
        uint32_t kept = 0;
        for (uint32_t reg = 0; reg < BUSTER_TIER1_EMIT_GENERAL_REGISTERS; reg += 1)
        {
            kept |= ((saved >> reg) & 1) != 0 && rows[reg] == transitions.owners[reg] ? 1u << reg : 0;
        }
        same &= tier1_emit_kept(&saves, &transitions, saved) == kept;
        tier1_emit_saved(&saves, &transitions, saved);
        tier1_emit_fixed_rows(&saves, fixed);
        same &= saves.owed == saved;
        for (uint32_t reg = 0; reg < BUSTER_TIER1_EMIT_GENERAL_REGISTERS; reg += 1)
        {
            const uint32_t after_call = ((saved >> reg) & 1) != 0 ? transitions.owners[reg] : rows[reg];
            same &= saves.rows[reg] == (((fixed >> reg) & 1) != 0 ? BUSTER_IR_NONE : after_call);
        }
    }
    tier1_emit_test_expect(test, same, "the call-save rows' helpers give their definitions' masks and rows");
}

// #2538: the calls before each position, on random sorted call positions over random lengths (a call at the last
// position, and none at all, among them): the vector prefix sum must give, at each position, the calls before it.
static void tier1_emit_test_calls_before(Tier1EmitTest* test)
{
    uint64_t random = UINT64_C(0x2538a1b2c3d4e5f6);
    uint32_t calls[256];
    uint32_t before[2][1024];
    bool same = true;
    for (uint32_t round = 0; round < 2048; round += 1)
    {
        const uint32_t positions = 1 + (uint32_t)(tier1_emit_test_random(&random) % 1000);
        const uint32_t density = 1 + (uint32_t)(tier1_emit_test_random(&random) % 16);
        uint32_t count = 0;
        for (uint32_t q = 0; q < positions && count < 256; q += 1)
        {
            const bool call = (tier1_emit_test_random(&random) % density == 0 && round % 7 != 0) || (round % 5 == 0 && q + 1 == positions);
            calls[count] = q;
            count += call;
        }
        // The definition: the calls at positions before q, a prefix sum over a bitmap of the call positions.
        uint8_t called[1024] = { 0 };
        for (uint32_t k = 0; k < count; k += 1)
        {
            called[calls[k]] = 1;
        }
        before[1][0] = 0;
        for (uint32_t q = 0; q < positions; q += 1)
        {
            before[1][q + 1] = before[1][q] + called[q];
        }
        memset(before[0], 0xa5, sizeof(before[0]));
        tier1_emit_cfg_calls_before_vector(calls, count, positions, before[0]);
        same &= memcmp(before[0], before[1], ((uint64_t)positions + 1) * sizeof(uint32_t)) == 0 && before[1][positions] == count;
        same &= before[0][positions + 1] == 0xa5a5a5a5u;
    }
    tier1_emit_test_expect(test, same, "the calls before each position: the vector prefix sum gives the count of calls before it");
}

