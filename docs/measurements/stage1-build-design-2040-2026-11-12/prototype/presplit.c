// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// A measurement prototype for buster#2040's design, derived from tools/codegen/split.c: the partition of one unit's
// module BEFORE LLVM's optimizer, so that the optimizer and the code generator run on each part as a job of its own, and
// a rebuild repeats only the parts an edit changed.
//
//   presplit INPUT.bc PARTS DIRECTORY [--anchor M] [--import LIMIT] [--by-file] [--cohere CAP] [--lean-imports] [--verify] [--report]
//
// writes DIRECTORY/part0.bc to DIRECTORY/partPARTS.bc and DIRECTORY/locals.txt. Parts 0 to PARTS - 1 hold function
// definitions; part PARTS holds the global variables more than one part refers to, and no function.
//
// Which part a function goes to:
// - with --anchor M, by content-defined chunking of the module's function order (clang's order, which follows the
//   source): a function whose name's hash is 0 modulo M starts a chunk, and a chunk goes to the part its first function's
//   name selects. A function's part then depends only on the names around it, so an edit moves no other function, and
//   neighbours (a function and the static helpers clang emits after it) stay together;
// - with --by-file as well (and debug information, which names each function's file), the chunks are each source
//   file's own and a file's chunks go to a run of parts of its own, as many as its share of the unit;
// - without --anchor, contiguous ranges of the module's order, balanced by instruction count;
// - with --cohere CAP, a local function that one function alone calls then goes to its caller's part, until that
//   caller's tree holds CAP instructions (0: without limit).
//
// What each part's optimizer sees of the others:
// - a local function another part refers to keeps its local name where it is defined, and a hidden alias,
//   NAME.buster_split, names it for the others (as split.c does);
// - with --import LIMIT, a part also reads, available_externally, the body of every function its code calls that
//   another part defines and whose unoptimized body is at most LIMIT instructions (always_inline ones whatever their
//   size), and so on through those bodies: the optimizer may inline it and emits no copy; with --lean-imports such a
//   body comes without its debug information, so that the part holds no line number of another part's function;
// - a local global variable that exactly one code part refers to, and whose initializer names no other global, stays
//   local to that part; any other one a code part refers to becomes a hidden external one in the data part, and the
//   code parts that refer to a strong constant read its initializer available_externally, so that loads from it still
//   fold;
// - what __attribute__((used)) kept (llvm.used) is kept by a hidden name instead, which the merge makes local again;
// - a local variable whose name ends in a number given in the order clang met them (.str.N, a string literal;
//   constinit.N; a second static of one name) is named by its contents and its users instead, so that an edit that
//   adds a literal renames no other part's; and an inline assembly
//   statement loses its !srcloc, its offset in the translation unit, which every earlier edit would move.
// - a function whose inline assembly has text stays in part 0, with the module's own assembly, and no part reads its
//   body: such text can define a label that another function's text names.
// BusterCodegenMerge.cmake joins the parts' objects and restores local binding as it does for split.c's parts.
//
// The plan is made on the module, parsed once; each part is then a clone of its own definitions (presplit_shim.cpp's
// CloneModule), written by a child process, as many at once as the CPUs allow. A child reads the shared module and
// builds only its part, so its cost follows the part's size, not the module's.

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sched.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <llvm-c/Analysis.h>
#include <llvm-c/BitReader.h>
#include <llvm-c/Core.h>
#include <llvm-c/DebugInfo.h>
#include <llvm-c/Error.h>
#include <llvm-c/Transforms/PassBuilder.h>

#define PRESPLIT_ALIAS_SUFFIX ".buster_split"
#define PRESPLIT_MAXIMUM_PARTS 62

// presplit_shim.cpp
bool presplit_write_bitcode(LLVMModuleRef module, const char* path);
LLVMModuleRef presplit_clone(LLVMModuleRef module, LLVMValueRef* keep, uint64_t count, LLVMValueRef* owned, uint64_t owned_count, bool lists, bool lean);

typedef struct PresplitFunction PresplitFunction;
struct PresplitFunction
{
    LLVMValueRef function;
    uint64_t cost;
    // The parts that read the body, available_externally.
    uint64_t imported;
    uint32_t* callees;
    uint32_t callee_count;
    // The part that emits it.
    uint32_t part;
    // Emitted by some part: a definition that isn't available_externally.
    bool defined;
    bool local;
    // A local definition another part refers to, or one llvm.used kept: an alias names it.
    bool aliased;
    bool importable;
    bool used;
    // Holds inline assembly with text: kept in part 0 and never read by another part (presplit_scan).
    bool pinned;
};

typedef struct PresplitGlobal PresplitGlobal;
struct PresplitGlobal
{
    LLVMValueRef global;
    // The parts whose code or data refers to it.
    uint64_t readers;
    uint32_t part;
    bool defined;
    bool used;
};

// Values to their indices, by address.
typedef struct PresplitMap PresplitMap;
struct PresplitMap
{
    LLVMValueRef* keys;
    uint32_t* values;
    uint64_t capacity;
};

typedef struct PresplitPlan PresplitPlan;
struct PresplitPlan
{
    LLVMModuleRef module;
    PresplitFunction* functions;
    PresplitGlobal* globals;
    PresplitMap function_indices;
    PresplitMap global_indices;
    uint32_t function_count;
    uint32_t global_count;
    uint32_t parts;
    uint64_t anchor;
    uint64_t import_limit;
    unsigned srcloc;
    // --cohere CAP: 0 is off, UINT64_MAX no limit.
    uint64_t cohere;
    bool lean;
    bool by_file;
    bool verify;
    bool report;
};

static PresplitMap presplit_map_create(uint64_t minimum)
{
    uint64_t capacity = 1;
    while (capacity < minimum * 2)
    {
        capacity <<= 1;
    }
    return (PresplitMap){ .keys = calloc(capacity, sizeof(LLVMValueRef)), .values = calloc(capacity, sizeof(uint32_t)), .capacity = capacity };
}

static uint64_t presplit_map_slot(const PresplitMap* map, LLVMValueRef key)
{
    uint64_t slot = (((uint64_t)(uintptr_t)key * UINT64_C(0x9e3779b97f4a7c15)) >> 20) & (map->capacity - 1);
    while (map->keys[slot] != 0 && map->keys[slot] != key)
    {
        slot = (slot + 1) & (map->capacity - 1);
    }
    return slot;
}

static void presplit_map_put(PresplitMap* map, LLVMValueRef key, uint32_t value)
{
    const uint64_t slot = presplit_map_slot(map, key);
    map->keys[slot] = key;
    map->values[slot] = value;
}

// The index of `key`, or UINT32_MAX.
static uint32_t presplit_map_get(const PresplitMap* map, LLVMValueRef key)
{
    const uint64_t slot = presplit_map_slot(map, key);
    return map->keys[slot] == key ? map->values[slot] : UINT32_MAX;
}

static bool presplit_has_attribute(LLVMValueRef function, const char* name)
{
    const unsigned kind = LLVMGetEnumAttributeKindForName(name, strlen(name));
    return LLVMGetEnumAttributeAtIndex(function, LLVMAttributeFunctionIndex, kind) != 0;
}

static bool presplit_local(LLVMValueRef value)
{
    const LLVMLinkage linkage = LLVMGetLinkage(value);
    return linkage == LLVMInternalLinkage || linkage == LLVMPrivateLinkage;
}

static uint64_t presplit_hash(const char* name, size_t length)
{
    uint64_t hash = UINT64_C(0xcbf29ce484222325);
    for (size_t i = 0; i < length; i += 1)
    {
        hash = (hash ^ (uint8_t)name[i]) * UINT64_C(0x100000001b3);
    }
    // A final mix: FNV's low bits alone follow the last characters.
    hash ^= hash >> 32;
    hash *= UINT64_C(0xd6e8feb86659fd93);
    hash ^= hash >> 32;
    return hash;
}

// The function's instructions, and its direct callees in the plan, in `function`.
static void presplit_scan(PresplitPlan* plan, PresplitFunction* entry)
{
    uint64_t count = 0;
    uint32_t capacity = 0;
    for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(entry->function); block != 0; block = LLVMGetNextBasicBlock(block))
    {
        for (LLVMValueRef instruction = LLVMGetFirstInstruction(block); instruction != 0; instruction = LLVMGetNextInstruction(instruction))
        {
            count += 1;
            if (LLVMIsACallInst(instruction) != 0)
            {
                LLVMValueRef callee = LLVMGetCalledValue(instruction);
                // An inline assembly statement's !srcloc is its offset in the whole translation unit, which every
                // earlier edit moves; the parts' jobs can't map it back to a source line anyway.
                if (callee != 0 && LLVMIsAInlineAsm(callee) != 0)
                {
                    LLVMSetMetadata(instruction, plan->srcloc, 0);
                    // Assembly text can define a label and name another function's (x86_semantics_test.c's return
                    // label), which only the assembler resolves, within one object: every function with such text
                    // stays in part 0, and no other part reads its body. The empty barriers ("" with operands) don't.
                    size_t text = 0;
                    LLVMGetInlineAsmAsmString(callee, &text);
                    entry->pinned = entry->pinned || text != 0;
                }
                const uint32_t index = callee != 0 && LLVMIsAFunction(callee) != 0 ? presplit_map_get(&plan->function_indices, callee) : UINT32_MAX;
                const bool repeated = entry->callee_count != 0 && entry->callees[entry->callee_count - 1] == index;
                if (index != UINT32_MAX && !repeated)
                {
                    if (entry->callee_count == capacity)
                    {
                        capacity = capacity == 0 ? 8 : capacity * 2;
                        entry->callees = realloc(entry->callees, capacity * sizeof(uint32_t));
                    }
                    entry->callees[entry->callee_count] = index;
                    entry->callee_count += 1;
                }
            }
        }
    }
    entry->cost = count + 8;
}

// The parts that read `function`'s body: the one that emits it and those that import it.
static uint64_t presplit_where(const PresplitFunction* function)
{
    return function->defined ? (UINT64_C(1) << function->part) | function->imported : 0;
}

// The parts whose code or data refers to `value`, as a mask: an instruction's function's parts, and a global
// variable initializer's, the data part's (a global whose initializer names another stays in the data part). Constant
// expressions and aggregates pass references on; an alias or ifunc refers to it under a name every part can use.
static uint64_t presplit_references(const PresplitPlan* plan, LLVMValueRef value)
{
    uint64_t mask = 0;
    uint32_t capacity = 64;
    uint32_t depth = 1;
    LLVMValueRef* stack = malloc(capacity * sizeof(LLVMValueRef));
    stack[0] = value;
    while (depth != 0)
    {
        depth -= 1;
        LLVMValueRef current = stack[depth];
        for (LLVMUseRef use = LLVMGetFirstUse(current); use != 0; use = LLVMGetNextUse(use))
        {
            LLVMValueRef user = LLVMGetUser(use);
            if (LLVMIsAInstruction(user))
            {
                const uint32_t index = presplit_map_get(&plan->function_indices, LLVMGetBasicBlockParent(LLVMGetInstructionParent(user)));
                mask |= index != UINT32_MAX ? presplit_where(&plan->functions[index]) : 0;
            }
            else if (LLVMIsAGlobalVariable(user))
            {
                mask |= LLVMIsDeclaration(user) ? 0 : UINT64_C(1) << plan->parts;
            }
            else if (LLVMIsAGlobalValue(user))
            {
                mask = ~UINT64_C(0);
            }
            else
            {
                if (depth == capacity)
                {
                    capacity *= 2;
                    stack = realloc(stack, capacity * sizeof(LLVMValueRef));
                }
                stack[depth] = user;
                depth += 1;
            }
        }
    }
    free(stack);
    return mask;
}

static void presplit_hide(LLVMValueRef value)
{
    LLVMSetLinkage(value, LLVMExternalLinkage);
    LLVMSetVisibility(value, LLVMHiddenVisibility);
}

// Whether a code part reads `global`'s initializer, available_externally: a strong constant's, one whose initializer
// the single module took as definitive.
static bool presplit_readable(LLVMValueRef global)
{
    return !LLVMIsDeclaration(global) && LLVMIsGlobalConstant(global) && LLVMGetLinkage(global) == LLVMExternalLinkage &&
           !LLVMIsThreadLocal(global) && !LLVMIsExternallyInitialized(global);
}

// Whether the constant `value` names no global value: a leaf's definition can move to the one code part that uses it.
static bool presplit_leaf(LLVMValueRef value)
{
    bool leaf = true;
    uint32_t capacity = 64;
    uint32_t depth = 1;
    LLVMValueRef* stack = malloc(capacity * sizeof(LLVMValueRef));
    stack[0] = value;
    while (depth != 0 && leaf)
    {
        depth -= 1;
        LLVMValueRef current = stack[depth];
        if (LLVMIsAGlobalValue(current))
        {
            leaf = false;
        }
        else if (!LLVMIsAGlobalValue(current) && LLVMIsAConstant(current))
        {
            const int operands = LLVMGetNumOperands(current);
            for (int i = 0; i < operands; i += 1)
            {
                if (depth == capacity)
                {
                    capacity *= 2;
                    stack = realloc(stack, capacity * sizeof(LLVMValueRef));
                }
                stack[depth] = LLVMGetOperand(current, (unsigned)i);
                depth += 1;
            }
        }
    }
    free(stack);
    return leaf;
}

// What a code part reads, it may refer to: every local global a readable constant's initializer names is made a hidden
// external one, in the data part, in turn readable where it is a constant, until none is left.
static void presplit_readable_closure(PresplitPlan* plan)
{
    uint32_t capacity = 1024;
    uint32_t depth = 0;
    LLVMValueRef* stack = malloc(capacity * sizeof(LLVMValueRef));
    for (uint32_t i = 0; i < plan->global_count; i += 1)
    {
        if (presplit_readable(plan->globals[i].global))
        {
            if (depth == capacity)
            {
                capacity *= 2;
                stack = realloc(stack, capacity * sizeof(LLVMValueRef));
            }
            stack[depth] = LLVMGetInitializer(plan->globals[i].global);
            depth += 1;
        }
    }
    while (depth != 0)
    {
        depth -= 1;
        LLVMValueRef value = stack[depth];
        if (LLVMIsAGlobalVariable(value))
        {
            if (presplit_local(value) && !LLVMIsDeclaration(value))
            {
                presplit_hide(value);
                const uint32_t index = presplit_map_get(&plan->global_indices, value);
                if (index != UINT32_MAX)
                {
                    plan->globals[index].part = plan->parts;
                }
                if (presplit_readable(value))
                {
                    if (depth == capacity)
                    {
                        capacity *= 2;
                        stack = realloc(stack, capacity * sizeof(LLVMValueRef));
                    }
                    stack[depth] = LLVMGetInitializer(value);
                    depth += 1;
                }
            }
        }
        else if (!LLVMIsAGlobalValue(value) && LLVMIsAConstant(value))
        {
            const int operands = LLVMGetNumOperands(value);
            for (int i = 0; i < operands; i += 1)
            {
                if (depth == capacity)
                {
                    capacity *= 2;
                    stack = realloc(stack, capacity * sizeof(LLVMValueRef));
                }
                stack[depth] = LLVMGetOperand(value, (unsigned)i);
                depth += 1;
            }
        }
    }
    free(stack);
}

// Marks what llvm.used or llvm.compiler.used names.
static void presplit_mark_used(PresplitPlan* plan, const char* name)
{
    LLVMValueRef array = LLVMGetNamedGlobal(plan->module, name);
    LLVMValueRef initializer = array != 0 ? LLVMGetInitializer(array) : 0;
    const int operands = initializer != 0 ? LLVMGetNumOperands(initializer) : 0;
    for (int i = 0; i < operands; i += 1)
    {
        LLVMValueRef value = LLVMGetOperand(initializer, (unsigned)i);
        while (LLVMIsAConstantExpr(value))
        {
            value = LLVMGetOperand(value, 0);
        }
        const uint32_t function = presplit_map_get(&plan->function_indices, value);
        const uint32_t global = presplit_map_get(&plan->global_indices, value);
        if (function != UINT32_MAX)
        {
            plan->functions[function].used = true;
        }
        if (global != UINT32_MAX)
        {
            plan->globals[global].used = true;
        }
    }
}

// A hash of the names of the functions whose instructions refer to `value`, whatever their order.
static uint64_t presplit_user_hash(LLVMValueRef value)
{
    uint64_t hash = UINT64_C(0x2545f4914f6cdd1d);
    uint32_t capacity = 64;
    uint32_t depth = 1;
    LLVMValueRef* stack = malloc(capacity * sizeof(LLVMValueRef));
    stack[0] = value;
    while (depth != 0)
    {
        depth -= 1;
        LLVMValueRef current = stack[depth];
        for (LLVMUseRef use = LLVMGetFirstUse(current); use != 0; use = LLVMGetNextUse(use))
        {
            LLVMValueRef user = LLVMGetUser(use);
            if (LLVMIsAInstruction(user))
            {
                size_t length = 0;
                const char* name = LLVMGetValueName2(LLVMGetBasicBlockParent(LLVMGetInstructionParent(user)), &length);
                hash ^= presplit_hash(name, length) * UINT64_C(0x9e3779b97f4a7c15);
            }
            else if (!LLVMIsAGlobalValue(user))
            {
                if (depth == capacity)
                {
                    capacity *= 2;
                    stack = realloc(stack, capacity * sizeof(LLVMValueRef));
                }
                stack[depth] = user;
                depth += 1;
            }
        }
    }
    free(stack);
    return hash;
}

// Names the local variables whose names end in a number that LLVM gave them in the order clang met them (.str.N, a
// string literal; constinit.N; FUNCTION.NAME.N, a second static of one name) by what they are instead: the name's stem,
// .b and a hash of the type, the alignment and the initializer as LLVM prints it; a second one of the same contents
// adds the names of the functions that use it, and further ones .c1, .c2 and so on in the module's order. The leaves
// first (the strings), so that an initializer that names one prints its new name. An edit elsewhere then renames none.
static void presplit_content_names(PresplitPlan* plan)
{
    for (int pass = 0; pass < 2; pass += 1)
    {
        for (uint32_t i = 0; i < plan->global_count; i += 1)
        {
            LLVMValueRef global = plan->globals[i].global;
            size_t length = 0;
            const char* name = LLVMGetValueName2(global, &length);
            size_t dot = length;
            while (dot > 0 && name[dot - 1] >= '0' && name[dot - 1] <= '9')
            {
                dot -= 1;
            }
            // Every private variable is clang's own (the first .str has no number yet); a static only when numbered.
            const bool numbered = dot < length && dot > 1 && name[dot - 1] == '.';
            const bool generated = LLVMGetLinkage(global) == LLVMPrivateLinkage || numbered;
            dot = numbered ? dot : length + 1;
            if (plan->globals[i].defined && presplit_local(global) && generated && presplit_leaf(LLVMGetInitializer(global)) == (pass == 0))
            {
                LLVMValueRef initializer = LLVMGetInitializer(global);
                char* type = LLVMPrintTypeToString(LLVMGlobalGetValueType(global));
                uint64_t hash = presplit_hash(type, strlen(type));
                LLVMDisposeMessage(type);
                const unsigned shape[3] = { LLVMGetAlignment(global), (unsigned)LLVMIsGlobalConstant(global), (unsigned)LLVMGetLinkage(global) };
                hash ^= presplit_hash((const char*)shape, sizeof(shape));
                size_t size = 0;
                if (LLVMIsAConstantDataSequential(initializer) != 0 && LLVMIsConstantString(initializer))
                {
                    const char* bytes = LLVMGetAsString(initializer, &size);
                    hash ^= presplit_hash(bytes, size) * UINT64_C(0x9e3779b97f4a7c15);
                }
                else
                {
                    char* text = LLVMPrintValueToString(initializer);
                    hash ^= presplit_hash(text, strlen(text)) * UINT64_C(0x9e3779b97f4a7c15);
                    LLVMDisposeMessage(text);
                }
                char fresh[280];
                int written = snprintf(fresh, sizeof(fresh), "%.*s.b%016llx", (int)(dot - 1 < 200 ? dot - 1 : 200), name, (unsigned long long)hash);
                if (written > 0 && LLVMGetNamedGlobal(plan->module, fresh) != 0)
                {
                    // The same contents twice: told apart by the functions that use them, then by their order.
                    hash ^= presplit_user_hash(global);
                    written = snprintf(fresh, sizeof(fresh), "%.*s.b%016llx", (int)(dot - 1 < 200 ? dot - 1 : 200), name, (unsigned long long)hash);
                }
                for (unsigned copy = 1; written > 0 && LLVMGetNamedGlobal(plan->module, fresh) != 0 && copy < 100000; copy += 1)
                {
                    written = snprintf(fresh, sizeof(fresh), "%.*s.b%016llx.c%u", (int)(dot - 1 < 200 ? dot - 1 : 200), name, (unsigned long long)hash, copy);
                }
                if (written > 0 && LLVMGetNamedGlobal(plan->module, fresh) == 0)
                {
                    LLVMSetValueName2(global, fresh, (size_t)written);
                }
            }
        }
    }
}

// The one function whose calls are all that refers to the local function `function`, as an index, or UINT32_MAX: for
// a function several functions call, one whose address something takes, and one nothing refers to.
static uint32_t presplit_single_caller(const PresplitPlan* plan, LLVMValueRef function)
{
    uint32_t caller = UINT32_MAX;
    bool single = true;
    for (LLVMUseRef use = LLVMGetFirstUse(function); use != 0 && single; use = LLVMGetNextUse(use))
    {
        LLVMValueRef user = LLVMGetUser(use);
        single = LLVMIsACallInst(user) != 0 && LLVMGetCalledValue(user) == function;
        if (single)
        {
            const uint32_t index = presplit_map_get(&plan->function_indices, LLVMGetBasicBlockParent(LLVMGetInstructionParent(user)));
            single = index != UINT32_MAX && (caller == UINT32_MAX || caller == index);
            caller = index;
        }
    }
    return single ? caller : UINT32_MAX;
}

// The plan every part shares, made before the parts fork.
static void presplit_plan(PresplitPlan* plan)
{
    for (LLVMValueRef function = LLVMGetFirstFunction(plan->module); function != 0; function = LLVMGetNextFunction(function))
    {
        plan->function_count += 1;
    }
    for (LLVMValueRef global = LLVMGetFirstGlobal(plan->module); global != 0; global = LLVMGetNextGlobal(global))
    {
        plan->global_count += 1;
    }
    plan->functions = calloc(plan->function_count + 1, sizeof(PresplitFunction));
    plan->globals = calloc(plan->global_count + 1, sizeof(PresplitGlobal));
    plan->function_indices = presplit_map_create((uint64_t)plan->function_count + 1024);
    plan->global_indices = presplit_map_create((uint64_t)plan->global_count + 1024);
    uint64_t unnamed = 0;
    uint32_t at = 0;
    for (LLVMValueRef function = LLVMGetFirstFunction(plan->module); function != 0; function = LLVMGetNextFunction(function))
    {
        PresplitFunction* entry = &plan->functions[at];
        entry->function = function;
        entry->defined = !LLVMIsDeclaration(function) && LLVMGetLinkage(function) != LLVMAvailableExternallyLinkage;
        entry->local = presplit_local(function);
        entry->part = UINT32_MAX;
        size_t length = 0;
        LLVMGetValueName2(function, &length);
        if (length == 0)
        {
            char name[64];
            snprintf(name, sizeof(name), "__buster_split_function_%llu", (unsigned long long)unnamed);
            unnamed += 1;
            LLVMSetValueName2(function, name, strlen(name));
        }
        presplit_map_put(&plan->function_indices, function, at);
        at += 1;
    }
    // llvm.used and llvm.compiler.used go: what they kept is kept by a hidden name instead.
    at = 0;
    LLVMValueRef global = LLVMGetFirstGlobal(plan->module);
    while (global != 0)
    {
        LLVMValueRef following = LLVMGetNextGlobal(global);
        size_t length = 0;
        const char* name = LLVMGetValueName2(global, &length);
        if (strcmp(name, "llvm.compiler.used") != 0 && strcmp(name, "llvm.used") != 0)
        {
            PresplitGlobal* entry = &plan->globals[at];
            entry->global = global;
            entry->defined = !LLVMIsDeclaration(global);
            entry->part = plan->parts;
            if (length == 0)
            {
                char text[64];
                snprintf(text, sizeof(text), "__buster_split_global_%llu", (unsigned long long)unnamed);
                unnamed += 1;
                LLVMSetValueName2(global, text, strlen(text));
            }
            presplit_map_put(&plan->global_indices, global, at);
            at += 1;
        }
        global = following;
    }
    plan->global_count = at;
    presplit_mark_used(plan, "llvm.used");
    presplit_mark_used(plan, "llvm.compiler.used");
    for (uint32_t kind = 0; kind < 2; kind += 1)
    {
        LLVMValueRef array = LLVMGetNamedGlobal(plan->module, kind == 0 ? "llvm.used" : "llvm.compiler.used");
        if (array != 0)
        {
            LLVMDeleteGlobal(array);
        }
    }

    presplit_content_names(plan);

    // The functions' costs and callees, then their parts.
    uint64_t total = 0;
    for (uint32_t i = 0; i < plan->function_count; i += 1)
    {
        PresplitFunction* entry = &plan->functions[i];
        if (entry->defined)
        {
            presplit_scan(plan, entry);
            total += entry->cost;
            const bool always = presplit_has_attribute(entry->function, "alwaysinline");
            const bool never = presplit_has_attribute(entry->function, "noinline") || presplit_has_attribute(entry->function, "optnone") ||
                               presplit_has_attribute(entry->function, "naked");
            entry->importable = !never && !entry->pinned && (always || entry->cost <= plan->import_limit + 8);
        }
    }
    // --by-file (with --anchor and debug information): the chunks are each source file's own, and a file's chunks go
    // to a run of parts of its own, as many as its share of the unit's instructions, starting where its name selects.
    // An edit that moves a file's lines then changes the parts that hold that file, a share of the unit like the
    // file's, where chunks dealt over every part would change them all.
    typedef struct PresplitFile
    {
        uint64_t hash;
        uint64_t cost;
        uint64_t current;
        bool used;
    } PresplitFile;
    const uint32_t file_capacity = 4096;
    PresplitFile* files = calloc(file_capacity, sizeof(PresplitFile));
    uint64_t* file_of = calloc(plan->function_count + 1, sizeof(uint64_t));
    if (plan->by_file && plan->anchor != 0)
    {
        for (uint32_t i = 0; i < plan->function_count; i += 1)
        {
            PresplitFunction* entry = &plan->functions[i];
            if (entry->defined)
            {
                LLVMMetadataRef subprogram = LLVMGetSubprogram(entry->function);
                LLVMMetadataRef file = subprogram != 0 ? LLVMDIScopeGetFile(subprogram) : 0;
                unsigned length = 0;
                const char* name = file != 0 ? LLVMDIFileGetFilename(file, &length) : "";
                const uint64_t hash = presplit_hash(name, length) | 1;
                uint32_t slot = (uint32_t)(hash % file_capacity);
                while (files[slot].used && files[slot].hash != hash)
                {
                    slot = (slot + 1) % file_capacity;
                }
                files[slot].used = true;
                files[slot].hash = hash;
                files[slot].cost += entry->cost;
                file_of[i] = slot;
            }
        }
    }
    uint64_t before = 0;
    uint32_t current = 0;
    bool first = true;
    for (uint32_t i = 0; i < plan->function_count; i += 1)
    {
        PresplitFunction* entry = &plan->functions[i];
        if (entry->defined)
        {
            if (plan->by_file && plan->anchor != 0)
            {
                PresplitFile* file = &files[file_of[i]];
                size_t length = 0;
                const char* name = LLVMGetValueName2(entry->function, &length);
                const uint64_t hash = presplit_hash(name, length);
                if (file->current == 0 || hash % plan->anchor == 0)
                {
                    file->current = hash | 1;
                }
                uint64_t run = (file->cost * plan->parts + total / 2) / (total + 1);
                run = run == 0 ? 1 : run > plan->parts ? plan->parts : run;
                current = (uint32_t)(((file->hash >> 20) + (file->current >> 24) % run) % plan->parts);
            }
            else if (plan->anchor != 0)
            {
                size_t length = 0;
                const char* name = LLVMGetValueName2(entry->function, &length);
                const uint64_t hash = presplit_hash(name, length);
                if (first || hash % plan->anchor == 0)
                {
                    current = (uint32_t)((hash >> 24) % plan->parts);
                }
            }
            else
            {
                current = (uint32_t)((before * plan->parts) / (total + 1));
            }
            entry->part = current;
            before += entry->cost;
            first = false;
        }
    }
    free(files);
    free(file_of);

    // --cohere CAP: a local function that one function alone calls goes to that caller's part, and so on up to a
    // function that isn't one (the tree's root): the whole unit's inliner inlines such a function whatever its size,
    // which a part can only do for a body it holds. A tree stops taking functions at CAP instructions: the next one
    // keeps its own part and roots its own tree, so that no part grows without bound.
    if (plan->cohere != 0)
    {
        uint32_t* callers = calloc(plan->function_count + 1, sizeof(uint32_t));
        uint64_t* tree = calloc(plan->function_count + 1, sizeof(uint64_t));
        for (uint32_t i = 0; i < plan->function_count; i += 1)
        {
            const PresplitFunction* entry = &plan->functions[i];
            callers[i] = entry->defined && entry->local && !entry->used ? presplit_single_caller(plan, entry->function) : UINT32_MAX;
            callers[i] = callers[i] != UINT32_MAX && plan->functions[callers[i]].defined && callers[i] != i ? callers[i] : UINT32_MAX;
        }
        for (uint32_t i = 0; i < plan->function_count; i += 1)
        {
            if (plan->functions[i].defined)
            {
                uint32_t root = i;
                for (uint32_t steps = 0; callers[root] != UINT32_MAX && steps < plan->function_count; steps += 1)
                {
                    root = callers[root];
                }
                if (root != i && tree[root] + plan->functions[root].cost + plan->functions[i].cost > plan->cohere)
                {
                    callers[i] = UINT32_MAX;
                    root = i;
                }
                if (root != i)
                {
                    tree[root] += plan->functions[i].cost;
                    plan->functions[i].part = plan->functions[root].part;
                }
            }
        }
        free(callers);
        free(tree);
    }

    for (uint32_t i = 0; i < plan->function_count; i += 1)
    {
        if (plan->functions[i].defined && plan->functions[i].pinned)
        {
            plan->functions[i].part = 0;
        }
    }

    // What each part imports, to a fixed point: the importable callees of the bodies it reads.
    bool changed = true;
    while (changed)
    {
        changed = false;
        for (uint32_t i = 0; i < plan->function_count; i += 1)
        {
            const PresplitFunction* entry = &plan->functions[i];
            const uint64_t where = presplit_where(entry);
            for (uint32_t c = 0; c < entry->callee_count; c += 1)
            {
                PresplitFunction* callee = &plan->functions[entry->callees[c]];
                if (callee->importable)
                {
                    const uint64_t added = where & ~(UINT64_C(1) << callee->part) & ~callee->imported;
                    callee->imported |= added;
                    changed = changed || added != 0;
                }
            }
        }
    }

    for (uint32_t i = 0; i < plan->function_count; i += 1)
    {
        PresplitFunction* entry = &plan->functions[i];
        if (entry->defined && entry->local)
        {
            entry->aliased = entry->used || (presplit_references(plan, entry->function) & ~(UINT64_C(1) << entry->part)) != 0;
        }
    }
    const uint64_t data = UINT64_C(1) << plan->parts;
    for (uint32_t i = 0; i < plan->global_count; i += 1)
    {
        PresplitGlobal* entry = &plan->globals[i];
        entry->readers = entry->defined ? presplit_references(plan, entry->global) : 0;
        if (entry->defined && presplit_local(entry->global))
        {
            const uint64_t mask = entry->readers;
            const uint64_t code = mask & ~data;
            const bool single = mask == code && code != 0 && (code & (code - 1)) == 0;
            if (!entry->used && single && presplit_leaf(LLVMGetInitializer(entry->global)))
            {
                entry->part = (uint32_t)__builtin_ctzll(code);
            }
            else if (entry->used || code != 0)
            {
                presplit_hide(entry->global);
            }
        }
    }
    presplit_readable_closure(plan);
}

// Part `part` of the plan: a clone of the module with this part's definitions alone, written to `path`. Runs in its own
// child process.
static bool presplit_part(const PresplitPlan* plan, uint32_t part, const char* path)
{
    const bool code = part < plan->parts;
    const uint64_t bit = UINT64_C(1) << part;
    LLVMValueRef* keep = malloc(((uint64_t)plan->function_count + plan->global_count + 1) * sizeof(LLVMValueRef));
    uint64_t kept = 0;
    for (uint32_t i = 0; i < plan->function_count; i += 1)
    {
        const PresplitFunction* entry = &plan->functions[i];
        if (entry->defined && (entry->part == part || (entry->imported & bit) != 0))
        {
            keep[kept] = entry->function;
            kept += 1;
        }
    }
    LLVMValueRef* owned = malloc(((uint64_t)plan->function_count + plan->global_count + 1) * sizeof(LLVMValueRef));
    uint64_t owned_count = 0;
    for (uint32_t i = 0; i < plan->function_count; i += 1)
    {
        if (plan->functions[i].defined && plan->functions[i].part == part)
        {
            owned[owned_count] = plan->functions[i].function;
            owned_count += 1;
        }
    }
    for (uint32_t i = 0; i < plan->global_count; i += 1)
    {
        const PresplitGlobal* entry = &plan->globals[i];
        if (entry->defined && (entry->part == part || (code && (entry->readers & bit) != 0 && presplit_readable(entry->global))))
        {
            keep[kept] = entry->global;
            kept += 1;
        }
        if (entry->defined && entry->part == part)
        {
            owned[owned_count] = entry->global;
            owned_count += 1;
        }
    }
    LLVMModuleRef module = presplit_clone(plan->module, keep, kept, owned, owned_count, !code, plan->lean);
    free(keep);
    free(owned);
    bool consistent = true;
    for (uint32_t i = 0; i < plan->function_count; i += 1)
    {
        const PresplitFunction* entry = &plan->functions[i];
        if (entry->defined)
        {
            size_t length = 0;
            const char* name = LLVMGetValueName2(entry->function, &length);
            LLVMValueRef function = LLVMGetNamedFunction(module, name);
            const bool owned = entry->part == part;
            const bool imported = !owned && (entry->imported & bit) != 0;
            if (function != 0 && entry->aliased)
            {
                char* alias = malloc(length + sizeof(PRESPLIT_ALIAS_SUFFIX));
                memcpy(alias, name, length);
                memcpy(alias + length, PRESPLIT_ALIAS_SUFFIX, sizeof(PRESPLIT_ALIAS_SUFFIX));
                if (owned)
                {
                    presplit_hide(LLVMAddAlias2(module, LLVMGlobalGetValueType(function), 0, function, alias));
                }
                else
                {
                    LLVMSetValueName2(function, alias, strlen(alias));
                    presplit_hide(function);
                }
                free(alias);
            }
            if (function != 0 && imported)
            {
                LLVMSetLinkage(function, LLVMAvailableExternallyLinkage);
            }
            // A local function no other part refers to is no other part's business.
            if (function != 0 && !owned && entry->local && !entry->aliased && LLVMGetFirstUse(function) != 0)
            {
                fprintf(stderr, "presplit: part %u refers to %s, which stays local to part %u\n", part, name, entry->part);
                consistent = false;
            }
        }
    }
    for (uint32_t i = 0; i < plan->global_count; i += 1)
    {
        const PresplitGlobal* entry = &plan->globals[i];
        if (entry->defined)
        {
            size_t length = 0;
            const char* name = LLVMGetValueName2(entry->global, &length);
            LLVMValueRef global = LLVMGetNamedGlobal(module, name);
            if (global != 0 && entry->part != part)
            {
                if (code && (entry->readers & bit) != 0 && presplit_readable(entry->global))
                {
                    LLVMSetLinkage(global, LLVMAvailableExternallyLinkage);
                }
                else if (presplit_local(entry->global) && LLVMGetFirstUse(global) != 0)
                {
                    fprintf(stderr, "presplit: part %u refers to %s, which stays local to part %u\n", part, name, entry->part);
                    consistent = false;
                }
                // The other parts' globals' debug records go, so that each part's DWARF describes what it emits.
                LLVMGlobalClearMetadata(global);
            }
        }
    }
    // A global variable declaration nothing here uses goes: the code generator would still name a hidden one.
    LLVMValueRef global = LLVMGetFirstGlobal(module);
    while (global != 0)
    {
        LLVMValueRef following = LLVMGetNextGlobal(global);
        if (LLVMIsDeclaration(global) && LLVMGetFirstUse(global) == 0)
        {
            LLVMDeleteGlobal(global);
        }
        global = following;
    }
    if (part != 0)
    {
        LLVMSetModuleInlineAsm2(module, "", 0);
    }
    LLVMPassBuilderOptionsRef options = LLVMCreatePassBuilderOptions();
    LLVMErrorRef error = LLVMRunPasses(module, "strip-dead-debug-info,strip-dead-prototypes", 0, options);
    LLVMDisposePassBuilderOptions(options);
    bool written = false;
    char* message = 0;
    if (error != 0)
    {
        message = LLVMGetErrorMessage(error);
        fprintf(stderr, "presplit: part %u: %s\n", part, message);
        LLVMDisposeErrorMessage(message);
    }
    else if (!consistent)
    {
        fprintf(stderr, "presplit: part %u is inconsistent\n", part);
    }
    else if (plan->verify && LLVMVerifyModule(module, LLVMPrintMessageAction, &message))
    {
        fprintf(stderr, "presplit: part %u fails verification\n", part);
    }
    else
    {
        written = presplit_write_bitcode(module, path);
        if (!written)
        {
            fprintf(stderr, "presplit: can't write %s\n", path);
        }
    }
    return written;
}

// Writes DIRECTORY/locals.txt: the names of the module's local definitions and of the aliases the parts give them, one a
// line, which the merge checks no part left undefined. Whether it was written.
static bool presplit_locals(const PresplitPlan* plan, const char* directory)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/locals.txt", directory);
    FILE* file = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "w") : 0;
    bool written = file != 0;
    for (int kind = 0; written && kind < 2; kind += 1)
    {
        for (LLVMValueRef value = kind == 0 ? LLVMGetFirstFunction(plan->module) : LLVMGetFirstGlobal(plan->module); value != 0;
             value = kind == 0 ? LLVMGetNextFunction(value) : LLVMGetNextGlobal(value))
        {
            const LLVMLinkage linkage = LLVMGetLinkage(value);
            const bool hidden = LLVMGetVisibility(value) == LLVMHiddenVisibility && linkage == LLVMExternalLinkage;
            if (!LLVMIsDeclaration(value) && (presplit_local(value) || hidden))
            {
                size_t size = 0;
                const char* name = LLVMGetValueName2(value, &size);
                fprintf(file, "%.*s\n", (int)size, name);
                if (kind == 0 && presplit_local(value))
                {
                    fprintf(file, "%.*s" PRESPLIT_ALIAS_SUFFIX "\n", (int)size, name);
                }
            }
        }
    }
    written = file != 0 && fclose(file) == 0 && written;
    return written;
}

// Writes every part, a child process each, at most one per CPU this process may run on at once, and waits for them
// all: whether every part was written. A child clones its part from the module it shares with the others, so it adds
// its part's size to the memory, not the module's.
static bool presplit_parts(const PresplitPlan* plan, const char* directory)
{
    const uint32_t total = plan->parts + 1;
    cpu_set_t set;
    const uint32_t cpus = sched_getaffinity(0, sizeof(set), &set) == 0 ? (uint32_t)CPU_COUNT(&set) : 1;
    const uint32_t limit = cpus < total ? cpus : total;
    pid_t* children = calloc(total, sizeof(pid_t));
    bool done = true;
    uint32_t running = 0;
    for (uint32_t part = 0; part < total || running != 0;)
    {
        if (part < total && running < limit && done)
        {
            fflush(0);
            children[part] = fork();
            if (children[part] == 0)
            {
                char path[4096];
                const int length = snprintf(path, sizeof(path), "%s/part%u.bc", directory, part);
                _exit(length > 0 && (size_t)length < sizeof(path) && presplit_part(plan, part, path) ? 0 : 1);
            }
            done = done && children[part] > 0;
            running += children[part] > 0;
            part += 1;
        }
        else if (running != 0)
        {
            int status = 0;
            const pid_t child = waitpid(-1, &status, 0);
            const bool interrupted = child < 0 && errno == EINTR;
            done = done && (interrupted || (child > 0 && WIFEXITED(status) && WEXITSTATUS(status) == 0));
            running = child > 0 ? running - 1 : interrupted ? running : 0;
        }
        else
        {
            part = total;
        }
    }
    free(children);
    return done;
}

// Prints each part's definitions, estimated cost and imports, and the plan's totals.
static void presplit_report(const PresplitPlan* plan)
{
    uint64_t total = 0;
    uint64_t imported_total = 0;
    uint32_t aliased = 0;
    uint32_t defined_total = 0;
    for (uint32_t p = 0; p < plan->parts; p += 1)
    {
        uint64_t cost = 0;
        uint64_t imported_cost = 0;
        uint32_t defined = 0;
        uint32_t imported = 0;
        for (uint32_t i = 0; i < plan->function_count; i += 1)
        {
            const PresplitFunction* entry = &plan->functions[i];
            if (entry->defined && entry->part == p)
            {
                cost += entry->cost;
                defined += 1;
                aliased += entry->aliased;
            }
            else if (entry->defined && (entry->imported & (UINT64_C(1) << p)) != 0)
            {
                imported_cost += entry->cost;
                imported += 1;
            }
        }
        total += cost;
        imported_total += imported_cost;
        defined_total += defined;
        fprintf(stderr, "presplit: part %u: %u definitions, cost %llu; %u imported, cost %llu\n", p, defined, (unsigned long long)cost, imported,
                (unsigned long long)imported_cost);
    }
    uint32_t moved = 0;
    uint32_t hidden = 0;
    for (uint32_t i = 0; i < plan->global_count; i += 1)
    {
        const PresplitGlobal* entry = &plan->globals[i];
        moved += entry->defined && entry->part != plan->parts;
        hidden += entry->defined && LLVMGetVisibility(entry->global) == LLVMHiddenVisibility;
    }
    fprintf(stderr, "presplit: %u definitions, cost %llu, %u aliased; imports cost %llu (%.1f%%); %u globals, %u local to a code part, %u hidden\n",
            defined_total, (unsigned long long)total, aliased, (unsigned long long)imported_total, total != 0 ? 100.0 * (double)imported_total / (double)total : 0.0,
            plan->global_count, moved, hidden);
}

static double presplit_seconds(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (double)now.tv_sec + (double)now.tv_nsec / 1e9;
}

int main(int argc, char** argv)
{
    const double started = presplit_seconds();
    int status = 2;
    bool valid = argc >= 4;
    PresplitPlan plan = { 0 };
    for (int i = 4; i < argc && valid; i += 1)
    {
        char* end = 0;
        if (strcmp(argv[i], "--verify") == 0)
        {
            plan.verify = true;
        }
        else if (strcmp(argv[i], "--report") == 0)
        {
            plan.report = true;
        }
        else if (strcmp(argv[i], "--lean-imports") == 0)
        {
            plan.lean = true;
        }
        else if (strcmp(argv[i], "--by-file") == 0)
        {
            plan.by_file = true;
        }
        else if ((strcmp(argv[i], "--anchor") == 0 || strcmp(argv[i], "--import") == 0 || strcmp(argv[i], "--cohere") == 0) && i + 1 < argc)
        {
            const unsigned long long value = strtoull(argv[i + 1], &end, 10);
            valid = end != argv[i + 1] && *end == 0;
            if (strcmp(argv[i], "--anchor") == 0)
            {
                plan.anchor = value;
            }
            else if (strcmp(argv[i], "--cohere") == 0)
            {
                plan.cohere = value == 0 ? UINT64_MAX : value;
            }
            else
            {
                plan.import_limit = value;
            }
            i += 1;
        }
        else
        {
            valid = false;
        }
    }
    char* end = 0;
    const unsigned long parts = argc >= 4 ? strtoul(argv[2], &end, 10) : 0;
    if (!valid || end == argv[2] || *end != 0 || parts == 0 || parts > PRESPLIT_MAXIMUM_PARTS)
    {
        fprintf(stderr, "usage: presplit INPUT.bc PARTS DIRECTORY [--anchor M] [--import LIMIT] [--by-file] [--cohere CAP] [--lean-imports] [--verify] [--report]  (PARTS from 1 to %u)\n",
                PRESPLIT_MAXIMUM_PARTS);
    }
    else
    {
        status = 1;
        LLVMContextRef context = LLVMContextCreate();
        LLVMMemoryBufferRef buffer = 0;
        char* message = 0;
        LLVMModuleRef module = 0;
        if (LLVMCreateMemoryBufferWithContentsOfFile(argv[1], &buffer, &message))
        {
            fprintf(stderr, "presplit: %s: %s\n", argv[1], message);
            LLVMDisposeMessage(message);
        }
        else if (LLVMParseBitcodeInContext2(context, buffer, &module))
        {
            fprintf(stderr, "presplit: can't read %s\n", argv[1]);
        }
        else
        {
            plan.module = module;
            plan.parts = (uint32_t)parts;
            plan.srcloc = LLVMGetMDKindIDInContext(context, "srcloc", 6);
            const double parsed = presplit_seconds();
            presplit_plan(&plan);
            const double planned = presplit_seconds();
            if (plan.report)
            {
                presplit_report(&plan);
            }
            status = presplit_locals(&plan, argv[3]) && presplit_parts(&plan, argv[3]) ? 0 : 1;
            if (plan.report)
            {
                fprintf(stderr, "presplit: reading %.2f s, planning %.2f s, writing the parts %.2f s\n", parsed - started, planned - parsed, presplit_seconds() - planned);
            }
        }
    }
    return status;
}
