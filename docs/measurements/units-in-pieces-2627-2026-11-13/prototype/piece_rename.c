// #2627 prototype: the local definitions of one piece's bitcode, so that the pieces of one unit, split apart
// (tools/codegen/presplit.c) and joined by one relocatable link, define no name twice and keep one copy of each object.
//   piece_rename INPUT.bc PREFIX OWNED OUTPUT.bc
// - a named local variable (internal linkage: a constant table, an inline function's static), which every piece that
//   uses it defines alike, is defined by one piece alone: if OWNED (a file of names, one a line) lists it, this piece
//   defines it, external and hidden; otherwise this piece reads a constant's initializer available_externally, and
//   declares a variable that isn't constant;
// - a local function (an inline one, each piece's copy) and clang's own variables (private linkage: strings, compound
//   literals) are renamed PREFIX.NAME, each piece's own.
// Locals that llvm.used or llvm.compiler.used keep are left alone: an assembly text may name them.
#include <llvm-c/BitReader.h>
#include <llvm-c/BitWriter.h>
#include <llvm-c/Core.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct PieceNames PieceNames;
struct PieceNames
{
    char* text;
    char** names;
    size_t count;
};

static int piece_compare(const void* a, const void* b)
{
    return strcmp(*(char* const*)a, *(char* const*)b);
}

static bool piece_names_read(PieceNames* names, const char* path)
{
    bool ok = false;
    FILE* file = fopen(path, "rb");
    if (file != 0)
    {
        fseek(file, 0, SEEK_END);
        long size = ftell(file);
        fseek(file, 0, SEEK_SET);
        names->text = malloc((size_t)size + 1);
        ok = fread(names->text, 1, (size_t)size, file) == (size_t)size;
        names->text[size] = 0;
        fclose(file);
        size_t lines = 0;
        for (long i = 0; i < size; i += 1)
        {
            lines += names->text[i] == '\n';
        }
        names->names = malloc((lines + 1) * sizeof(char*));
        names->count = 0;
        for (char* line = strtok(names->text, "\n"); line != 0; line = strtok(0, "\n"))
        {
            names->names[names->count] = line;
            names->count += 1;
        }
        qsort(names->names, names->count, sizeof(char*), piece_compare);
    }
    return ok;
}

static bool piece_owned(const PieceNames* names, const char* name)
{
    return bsearch(&name, names->names, names->count, sizeof(char*), piece_compare) != 0;
}

static bool piece_kept(LLVMModuleRef module, LLVMValueRef value)
{
    bool kept = false;
    const char* lists[] = { "llvm.used", "llvm.compiler.used" };
    for (int l = 0; l < 2 && !kept; l += 1)
    {
        LLVMValueRef list = LLVMGetNamedGlobal(module, lists[l]);
        LLVMValueRef array = list != 0 ? LLVMGetInitializer(list) : 0;
        int count = array != 0 ? LLVMGetNumOperands(array) : 0;
        for (int i = 0; i < count && !kept; i += 1)
        {
            LLVMValueRef element = LLVMGetOperand(array, (unsigned)i);
            while (element != 0 && LLVMIsAConstantExpr(element) != 0)
            {
                element = LLVMGetOperand(element, 0);
            }
            kept = element == value;
        }
    }
    return kept;
}

static void piece_prefix(LLVMValueRef value, const char* prefix, const char* name, size_t length)
{
    size_t prefix_length = strlen(prefix);
    char* fresh = malloc(prefix_length + 1 + length + 1);
    memcpy(fresh, prefix, prefix_length);
    fresh[prefix_length] = '.';
    memcpy(fresh + prefix_length + 1, name, length);
    fresh[prefix_length + 1 + length] = 0;
    LLVMSetValueName2(value, fresh, prefix_length + 1 + length);
    free(fresh);
}

int main(int argc, char** argv)
{
    int status = 2;
    LLVMMemoryBufferRef buffer = 0;
    char* message = 0;
    LLVMModuleRef module = 0;
    PieceNames owned = { 0 };
    if (argc == 5 && piece_names_read(&owned, argv[3]) && LLVMCreateMemoryBufferWithContentsOfFile(argv[1], &buffer, &message) == 0 &&
        LLVMParseBitcodeInContext2(LLVMContextCreate(), buffer, &module) == 0)
    {
        unsigned renamed = 0;
        unsigned defined = 0;
        unsigned read = 0;
        for (LLVMValueRef f = LLVMGetFirstFunction(module); f != 0; f = LLVMGetNextFunction(f))
        {
            size_t length = 0;
            const char* name = LLVMGetValueName2(f, &length);
            const LLVMLinkage linkage = LLVMGetLinkage(f);
            if (!LLVMIsDeclaration(f) && (linkage == LLVMInternalLinkage || linkage == LLVMPrivateLinkage) && length != 0 && !piece_kept(module, f))
            {
                piece_prefix(f, argv[2], name, length);
                renamed += 1;
            }
        }
        for (LLVMValueRef g = LLVMGetFirstGlobal(module); g != 0; g = LLVMGetNextGlobal(g))
        {
            size_t length = 0;
            const char* name = LLVMGetValueName2(g, &length);
            const LLVMLinkage linkage = LLVMGetLinkage(g);
            if (LLVMIsDeclaration(g) || length == 0 || piece_kept(module, g) || (length > 5 && memcmp(name, "llvm.", 5) == 0))
            {
            }
            else if (linkage == LLVMPrivateLinkage)
            {
                piece_prefix(g, argv[2], name, length);
                renamed += 1;
            }
            else if (linkage == LLVMInternalLinkage && piece_owned(&owned, name))
            {
                LLVMSetLinkage(g, LLVMExternalLinkage);
                LLVMSetVisibility(g, LLVMHiddenVisibility);
                defined += 1;
            }
            else if (linkage == LLVMInternalLinkage && LLVMIsGlobalConstant(g))
            {
                LLVMSetLinkage(g, LLVMAvailableExternallyLinkage);
                LLVMSetVisibility(g, LLVMHiddenVisibility);
                read += 1;
            }
            else if (linkage == LLVMInternalLinkage)
            {
                LLVMSetInitializer(g, 0);
                LLVMSetLinkage(g, LLVMExternalLinkage);
                LLVMSetVisibility(g, LLVMHiddenVisibility);
                read += 1;
            }
        }
        for (LLVMValueRef a = LLVMGetFirstGlobalAlias(module); a != 0; a = LLVMGetNextGlobalAlias(a))
        {
            size_t length = 0;
            const char* name = LLVMGetValueName2(a, &length);
            const LLVMLinkage linkage = LLVMGetLinkage(a);
            if ((linkage == LLVMInternalLinkage || linkage == LLVMPrivateLinkage) && length != 0)
            {
                piece_prefix(a, argv[2], name, length);
                renamed += 1;
            }
        }
        status = LLVMWriteBitcodeToFile(module, argv[4]) == 0 ? 0 : 1;
        fprintf(stderr, "piece_rename: %u renamed %s.NAME, %u variables defined here, %u read from their piece\n", renamed, argv[2], defined, read);
    }
    else
    {
        fprintf(stderr, "usage: piece_rename INPUT.bc PREFIX OWNED OUTPUT.bc%s%s\n", message != 0 ? ": " : "", message != 0 ? message : "");
    }
    return status;
}
