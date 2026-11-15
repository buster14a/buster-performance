// features MODULE.bc: one line per function definition (not available_externally) of the module, in module order:
// name, instructions, blocks, the sum of the squares of block sizes, the largest block, calls, phis, loads, stores,
// vector-typed results, switch cases, optnone. For fitting code-generation time against (buster#2639).
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <llvm-c/BitReader.h>
#include <llvm-c/Core.h>

int main(int argc, char** argv)
{
    int status = 1;
    LLVMContextRef context = LLVMContextCreate();
    LLVMMemoryBufferRef buffer = 0;
    char* message = 0;
    LLVMModuleRef module = 0;
    if (argc != 2)
    {
        fprintf(stderr, "usage: features MODULE.bc\n");
    }
    else if (LLVMCreateMemoryBufferWithContentsOfFile(argv[1], &buffer, &message))
    {
        fprintf(stderr, "features: %s: %s\n", argv[1], message);
    }
    else if (LLVMParseBitcodeInContext2(context, buffer, &module))
    {
        fprintf(stderr, "features: can't read %s\n", argv[1]);
    }
    else
    {
        status = 0;
        const unsigned optnone = LLVMGetEnumAttributeKindForName("optnone", 7);
        printf("index\tname\tinstructions\tblocks\tsquares\tlargest\tcalls\tphis\tloads\tstores\tvectors\tcases\toptnone\n");
        uint32_t index = 0;
        for (LLVMValueRef function = LLVMGetFirstFunction(module); function != 0; function = LLVMGetNextFunction(function))
        {
            const bool defined = !LLVMIsDeclaration(function) && LLVMGetLinkage(function) != LLVMAvailableExternallyLinkage;
            if (defined)
            {
                uint64_t instructions = 0, blocks = 0, squares = 0, largest = 0, calls = 0, phis = 0, loads = 0, stores = 0, vectors = 0, cases = 0;
                for (LLVMBasicBlockRef block = LLVMGetFirstBasicBlock(function); block != 0; block = LLVMGetNextBasicBlock(block))
                {
                    uint64_t size = 0;
                    for (LLVMValueRef instruction = LLVMGetFirstInstruction(block); instruction != 0; instruction = LLVMGetNextInstruction(instruction))
                    {
                        size += 1;
                        const LLVMOpcode opcode = LLVMGetInstructionOpcode(instruction);
                        calls += opcode == LLVMCall || opcode == LLVMInvoke;
                        phis += opcode == LLVMPHI;
                        loads += opcode == LLVMLoad;
                        stores += opcode == LLVMStore;
                        const LLVMTypeKind kind = LLVMGetTypeKind(LLVMTypeOf(instruction));
                        vectors += kind == LLVMVectorTypeKind || kind == LLVMScalableVectorTypeKind;
                        if (opcode == LLVMSwitch)
                        {
                            cases += (uint64_t)LLVMGetNumSuccessors(instruction);
                        }
                    }
                    blocks += 1;
                    instructions += size;
                    squares += size * size;
                    largest = size > largest ? size : largest;
                }
                size_t length = 0;
                const char* name = LLVMGetValueName2(function, &length);
                const bool none = LLVMGetEnumAttributeAtIndex(function, LLVMAttributeFunctionIndex, optnone) != 0;
                printf("%u\t%.*s\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu\t%d\n", index, (int)length, name,
                       (unsigned long long)instructions, (unsigned long long)blocks, (unsigned long long)squares, (unsigned long long)largest,
                       (unsigned long long)calls, (unsigned long long)phis, (unsigned long long)loads, (unsigned long long)stores,
                       (unsigned long long)vectors, (unsigned long long)cases, none ? 1 : 0);
            }
            index += 1;
        }
    }
    return status;
}
