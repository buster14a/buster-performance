#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <llvm-c/BitReader.h>
#include <llvm-c/Core.h>
static bool has(LLVMValueRef f, const char* n) { unsigned k = LLVMGetEnumAttributeKindForName(n, strlen(n)); return LLVMGetEnumAttributeAtIndex(f, LLVMAttributeFunctionIndex, k) != 0; }
int main(int argc, char** argv)
{
    LLVMContextRef c = LLVMContextCreate(); LLVMMemoryBufferRef b; char* m; LLVMModuleRef mod;
    if (LLVMCreateMemoryBufferWithContentsOfFile(argv[1], &b, &m) || LLVMParseBitcodeInContext2(c, b, &mod)) return 1;
    uint32_t i = 0;
    for (LLVMValueRef f = LLVMGetFirstFunction(mod); f; f = LLVMGetNextFunction(f), i++)
    {
        bool defined = !LLVMIsDeclaration(f) && LLVMGetLinkage(f) != LLVMAvailableExternallyLinkage;
        if (!defined) continue;
        uint64_t n = 0;
        for (LLVMBasicBlockRef bb = LLVMGetFirstBasicBlock(f); bb; bb = LLVMGetNextBasicBlock(bb))
            for (LLVMValueRef in = LLVMGetFirstInstruction(bb); in; in = LLVMGetNextInstruction(in)) n++;
        const char* s = LLVMGetSection(f);
        size_t len; const char* name = LLVMGetValueName2(f, &len);
        printf("%u\t%u\t%d\t%d\t%d\t%s\t%llu\t%.*s\n", i, LLVMGetAlignment(f), has(f, "optsize"), has(f, "minsize"), has(f, "cold"), s && s[0] ? s : "-", (unsigned long long)n, (int)len, name);
    }
    return 0;
}
