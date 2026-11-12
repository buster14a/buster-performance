// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// function_files INPUT.bc FUNCTIONS.tsv EDGES.tsv: a module compiled with -g, for the reducers of buster#2040's record.
// FUNCTIONS.tsv has every function definition, one a line, tab-separated: its name, the source file of its debug record
// (the file its definition is written in), its line, its linkage (local, external or available_externally), its
// instruction count and whether llvm.used names it. EDGES.tsv has every reference between definitions: "F name" or
// "V name" (a function or a global variable) of the definition that refers, then of the one referred to, through
// instructions' operands and initializers, constant expressions included. For a unit's unoptimized bitcode these are
// the functions clang emitted, the files they come from and what reaches what.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <llvm-c/BitReader.h>
#include <llvm-c/Core.h>
#include <llvm-c/DebugInfo.h>

static void edge(FILE* edges, char from_kind, LLVMValueRef from, LLVMValueRef to)
{
    size_t from_length = 0;
    size_t to_length = 0;
    const char* from_name = LLVMGetValueName2(from, &from_length);
    const char* to_name = LLVMGetValueName2(to, &to_length);
    fprintf(edges, "%c %.*s\t%c %.*s\n", from_kind, (int)from_length, from_name, LLVMIsAFunction(to) ? 'F' : 'V', (int)to_length, to_name);
}

// The global values the constant or operand `value` names, as edges from `from`.
static void references(FILE* edges, char from_kind, LLVMValueRef from, LLVMValueRef value)
{
    uint32_t capacity = 64;
    uint32_t depth = 1;
    LLVMValueRef* stack = malloc(capacity * sizeof(LLVMValueRef));
    stack[0] = value;
    while (depth != 0)
    {
        depth -= 1;
        LLVMValueRef current = stack[depth];
        if (LLVMIsAFunction(current) || LLVMIsAGlobalVariable(current))
        {
            edge(edges, from_kind, from, current);
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
}

static bool used(LLVMModuleRef module, LLVMValueRef value)
{
    bool found = false;
    for (int kind = 0; kind < 2 && !found; kind += 1)
    {
        LLVMValueRef array = LLVMGetNamedGlobal(module, kind == 0 ? "llvm.used" : "llvm.compiler.used");
        LLVMValueRef initializer = array != 0 ? LLVMGetInitializer(array) : 0;
        const int operands = initializer != 0 ? LLVMGetNumOperands(initializer) : 0;
        for (int i = 0; i < operands && !found; i += 1)
        {
            LLVMValueRef operand = LLVMGetOperand(initializer, (unsigned)i);
            while (LLVMIsAConstantExpr(operand))
            {
                operand = LLVMGetOperand(operand, 0);
            }
            found = operand == value;
        }
    }
    return found;
}

int main(int argc, char** argv)
{
    int status = 2;
    LLVMMemoryBufferRef buffer = 0;
    LLVMModuleRef module = 0;
    char* message = 0;
    FILE* functions = argc == 4 ? fopen(argv[2], "w") : 0;
    FILE* edges = argc == 4 ? fopen(argv[3], "w") : 0;
    if (argc != 4 || functions == 0 || edges == 0)
    {
        fprintf(stderr, "usage: function_files INPUT.bc FUNCTIONS.tsv EDGES.tsv\n");
    }
    else if (LLVMCreateMemoryBufferWithContentsOfFile(argv[1], &buffer, &message))
    {
        fprintf(stderr, "function_files: %s: %s\n", argv[1], message);
        status = 1;
    }
    else if (LLVMParseBitcodeInContext2(LLVMContextCreate(), buffer, &module))
    {
        fprintf(stderr, "function_files: can't read %s\n", argv[1]);
        status = 1;
    }
    else
    {
        for (LLVMValueRef function = LLVMGetFirstFunction(module); function != 0; function = LLVMGetNextFunction(function))
        {
            if (!LLVMIsDeclaration(function))
            {
                uint64_t instructions = 0;
                for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(function); block != 0; block = LLVMGetNextBasicBlock(block))
                {
                    for (LLVMValueRef instruction = LLVMGetFirstInstruction(block); instruction != 0; instruction = LLVMGetNextInstruction(instruction))
                    {
                        instructions += 1;
                        const int operands = LLVMGetNumOperands(instruction);
                        for (int i = 0; i < operands; i += 1)
                        {
                            LLVMValueRef operand = LLVMGetOperand(instruction, (unsigned)i);
                            if (LLVMIsAConstant(operand))
                            {
                                references(edges, 'F', function, operand);
                            }
                        }
                    }
                }
                size_t length = 0;
                const char* name = LLVMGetValueName2(function, &length);
                LLVMMetadataRef subprogram = LLVMGetSubprogram(function);
                LLVMMetadataRef file = subprogram != 0 ? LLVMDIScopeGetFile(subprogram) : 0;
                unsigned file_length = 0;
                const char* file_name = file != 0 ? LLVMDIFileGetFilename(file, &file_length) : "";
                const LLVMLinkage linkage = LLVMGetLinkage(function);
                const char* kind = linkage == LLVMInternalLinkage || linkage == LLVMPrivateLinkage ? "local" : linkage == LLVMAvailableExternallyLinkage ? "available_externally" : "external";
                fprintf(functions, "%.*s\t%.*s\t%u\t%s\t%llu\t%d\n", (int)length, name, (int)file_length, file_name, subprogram != 0 ? LLVMDISubprogramGetLine(subprogram) : 0, kind,
                        (unsigned long long)instructions, used(module, function));
            }
        }
        for (LLVMValueRef global = LLVMGetFirstGlobal(module); global != 0; global = LLVMGetNextGlobal(global))
        {
            size_t length = 0;
            const char* name = LLVMGetValueName2(global, &length);
            if (!LLVMIsDeclaration(global) && strcmp(name, "llvm.used") != 0 && strcmp(name, "llvm.compiler.used") != 0)
            {
                references(edges, 'V', global, LLVMGetInitializer(global));
            }
        }
        status = fclose(functions) == 0 && fclose(edges) == 0 ? 0 : 1;
    }
    return status;
}
