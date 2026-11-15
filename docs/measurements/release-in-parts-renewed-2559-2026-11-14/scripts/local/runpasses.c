// runpasses IN.bc OUT.bc PIPELINE: LLVM's new pass manager PIPELINE on IN, for znver5, into OUT.
#include <llvm-c/BitReader.h>
#include <llvm-c/BitWriter.h>
#include <llvm-c/Core.h>
#include <llvm-c/Target.h>
#include <llvm-c/TargetMachine.h>
#include <llvm-c/Transforms/PassBuilder.h>
#include <stdio.h>

int main(int argc, char** argv)
{
    int status = 1;
    if (argc == 4)
    {
        LLVMInitializeX86TargetInfo();
        LLVMInitializeX86Target();
        LLVMInitializeX86TargetMC();
        LLVMMemoryBufferRef buffer = 0;
        char* message = 0;
        LLVMModuleRef module = 0;
        if (LLVMCreateMemoryBufferWithContentsOfFile(argv[1], &buffer, &message) == 0 && LLVMParseBitcode2(buffer, &module) == 0)
        {
            const char* triple = LLVMGetTarget(module);
            LLVMTargetRef target = 0;
            LLVMGetTargetFromTriple(triple, &target, &message);
            LLVMTargetMachineRef machine = LLVMCreateTargetMachine(target, triple, "znver5", "", LLVMCodeGenLevelAggressive, LLVMRelocPIC, LLVMCodeModelDefault);
            LLVMPassBuilderOptionsRef options = LLVMCreatePassBuilderOptions();
            LLVMErrorRef error = LLVMRunPasses(module, argv[3], machine, options);
            if (error)
            {
                char* text = LLVMGetErrorMessage(error);
                fprintf(stderr, "%s\n", text);
                LLVMDisposeErrorMessage(text);
            }
            else
            {
                status = LLVMWriteBitcodeToFile(module, argv[2]) != 0;
            }
        }
        else
        {
            fprintf(stderr, "can't read %s\n", argv[1]);
        }
    }
    return status;
}
