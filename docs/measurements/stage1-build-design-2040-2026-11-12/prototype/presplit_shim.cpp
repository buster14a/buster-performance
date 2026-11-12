// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// presplit.c's two calls LLVM's C API lacks (a measurement prototype for buster#2040's design): a module's clone with
// chosen definitions alone, and its bitcode.

#include <llvm-c/Core.h>
#include <llvm/ADT/DenseSet.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/IR/DebugInfo.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <llvm/Transforms/Utils/ValueMapper.h>

#include <cstdint>
#include <memory>

// `module`'s clone in the same context: every global value declared, and the `count` in `keep` defined as they are.
// The clone's debug information is its own definitions': the compile unit's list of global variables keeps the records
// of the `owned_count` variables in `owned` (and, with `lists`, the records no variable holds: the constants'), and its
// lists of enumerations, retained types, imports and macros stay only with `lists`, which the data part asks for. So a
// part's types are those its own functions and variables reach, not the whole unit's. `owned` also names the functions
// the part emits, for `lean`. Changes `module`: the caller is a child process that owns its copy.
extern "C" LLVMModuleRef presplit_clone(LLVMModuleRef module, LLVMValueRef* keep, uint64_t count, LLVMValueRef* owned, uint64_t owned_count, bool lists,
                                        bool lean)
{
    llvm::Module& source = *llvm::unwrap(module);
    llvm::DenseSet<const llvm::GlobalValue*> kept;
    for (uint64_t i = 0; i < count; i += 1)
    {
        kept.insert(llvm::cast<llvm::GlobalValue>(llvm::unwrap(keep[i])));
    }
    llvm::DenseSet<const llvm::GlobalValue*> own;
    for (uint64_t i = 0; i < owned_count; i += 1)
    {
        own.insert(llvm::cast<llvm::GlobalValue>(llvm::unwrap(owned[i])));
    }
    // With `lean`, a body the part only reads (an imported function's) loses its debug information: the part's
    // bitcode then holds no line number of another part's function, which an edit above that function would move.
    if (lean)
    {
        for (llvm::Function& function : source)
        {
            if (!function.isDeclaration() && kept.count(&function) != 0 && own.count(&function) == 0)
            {
                llvm::stripDebugInfo(function);
            }
        }
    }
    llvm::DenseSet<const llvm::Metadata*> attached;
    llvm::SmallVector<llvm::Metadata*, 0> expressions;
    for (llvm::GlobalVariable& global : source.globals())
    {
        llvm::SmallVector<llvm::DIGlobalVariableExpression*, 1> records;
        global.getDebugInfo(records);
        for (llvm::DIGlobalVariableExpression* record : records)
        {
            attached.insert(record);
            if (own.count(&global) != 0)
            {
                expressions.push_back(record);
            }
        }
        if (own.count(&global) == 0)
        {
            global.eraseMetadata(llvm::LLVMContext::MD_dbg);
        }
    }
    llvm::LLVMContext& context = source.getContext();
    llvm::DenseSet<const llvm::Metadata*> mine(expressions.begin(), expressions.end());
    for (llvm::DICompileUnit* unit : source.debug_compile_units())
    {
        // The unit's own list in its order: a function's static variable's record is its function's, not the unit's.
        llvm::SmallVector<llvm::Metadata*, 0> globals;
        for (llvm::DIGlobalVariableExpression* record : unit->getGlobalVariables())
        {
            if (mine.count(record) != 0 || (lists && attached.count(record) == 0))
            {
                globals.push_back(record);
            }
        }
        if (!lists)
        {
            // Absent lists, not empty ones: an empty macro list still makes the unit name a macro section.
            unit->replaceEnumTypes(llvm::DICompositeTypeArray());
            unit->replaceRetainedTypes(llvm::DITypeArray());
            unit->replaceImportedEntities(llvm::DIImportedEntityArray());
            unit->replaceMacros(llvm::DIMacroNodeArray());
        }
        unit->replaceGlobalVariables(llvm::MDTuple::get(context, globals));
    }
    llvm::ValueToValueMapTy map;
    std::unique_ptr<llvm::Module> clone = llvm::CloneModule(source, map, [&](const llvm::GlobalValue* value) { return kept.count(value) != 0; });
    return llvm::wrap(clone.release());
}

// Writes `module` to `path`. The optimizer follows, so the use-list order isn't kept.
extern "C" bool presplit_write_bitcode(LLVMModuleRef module, const char* path)
{
    std::error_code error;
    llvm::raw_fd_ostream output(path, error, llvm::sys::fs::OF_None);
    bool written = false;
    if (!error)
    {
        llvm::WriteBitcodeToFile(*llvm::unwrap(module), output, false);
        output.close();
        written = !output.has_error();
    }
    return written;
}
