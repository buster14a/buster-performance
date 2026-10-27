#!/usr/bin/env python3
# Makes mutant trees of the worktree: each a copy of src/ and build.sh (at -O1) with one exact replacement applied.
import os
import shutil
import sys

WORKTREE = "/home/david/dev/ai/claude/buster/.claude/worktrees/serene-merkle-0f3988"
ROOT = os.path.dirname(os.path.abspath(__file__))

MUTANTS = {
    "m1_and_16": ("src/buster/compiler/tier0.c",
                  "    tier0_put(writer, tier0_realignment(frame->alignment_log2));",
                  "    tier0_put(writer, tier0_realignment(BUSTER_TIER0_FRAME_ALIGNMENT_LOG2));"),
    "m2_incoming_rsp": ("src/buster/compiler/tier0.c",
                        "    const uint64_t incoming = realigned ? 16 : offset + above;\n    frame->incoming_base = realigned ? X86_REGISTER_RBP : X86_REGISTER_RSP;",
                        "    const uint64_t incoming = offset + above;\n    frame->incoming_base = X86_REGISTER_RSP;"),
    "m3_no_base": ("src/buster/compiler/tier0.c",
                   "    frame->base = frame->based ? X86_REGISTER_R15 : biased ? X86_REGISTER_RBP : X86_REGISTER_RSP;",
                   "    frame->base = biased ? X86_REGISTER_RBP : X86_REGISTER_RSP;"),
    "m4_alloca_16": ("src/buster/compiler/tier0.c",
                     "        const uint32_t log2 = frame->alignment_log2 != 0 ? frame->alignment_log2 : BUSTER_TIER0_FRAME_ALIGNMENT_LOG2;",
                     "        const uint32_t log2 = BUSTER_TIER0_FRAME_ALIGNMENT_LOG2;"),
    "m5_calls_ignored": ("src/buster/compiler/tier0.c",
                         "    for (uint32_t c = 0; c < function->call_count; c += 1)\n    {\n        const uint32_t alignment = function->calls[c].stack_alignment_log2;",
                         "    for (uint32_t c = 0; c < 0; c += 1)\n    {\n        const uint32_t alignment = function->calls[c].stack_alignment_log2;"),
    "m6_in_place_any": ("src/buster/compiler/tier0.c",
                        "    const bool aligned = alignment_log2 <= BUSTER_TIER0_FRAME_ALIGNMENT_LOG2 && location.stack_offset % (1u << alignment_log2) == 0;",
                        "    const bool aligned = location.stack_offset % (1u << alignment_log2) == 0;"),
    "m7_unwind_unchecked": ("src/buster/compiler/unwind_tier0.c",
                            "        error = unwind_tier0_realignment(&records[at], alignment_log2, base) ? UNWIND_OK : UNWIND_ERROR_UNSUPPORTED;",
                            "        error = unwind_tier0_realignment(&records[at], alignment_log2, base) ? UNWIND_OK : UNWIND_OK;"),
    "m8_vla_unpadded": ("src/buster/compiler/c_check_program_lower.c",
                        "            check_lower_emit(writer, BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_U64, alignment - 16);",
                        "            check_lower_emit(writer, BUSTER_TYPED_CONST, BUSTER_TYPED_CLASS_U64, 0);"),
    "m9_depths_unrealigned": ("src/buster/compiler/tier0.c",
                              "    return BUSTER_TIER0_INTEGER_DEPTHS - (realigned ? 1 : 0) - (moves ? 1 : 0);",
                              "    return BUSTER_TIER0_INTEGER_DEPTHS - (moves ? 1 : 0);"),
    "m10_r15_not_saved": ("src/buster/compiler/tier0.c",
                          "    frame->saved |= frame->based ? 1u << BUSTER_TIER0_SAVED_R15 : 0;",
                          "    frame->saved |= 0;"),
    "m11_vector_call_bytes": ("src/buster/compiler/tier0.c",
                              "(1u << 4 * left) - 1) & 0x2222u);",
                              "(1u << 4 * left) - 1) & 0xffffu);"),
    "m12_vector_tail": ("src/buster/compiler/tier0.c",
                        "const __mmask16 alignments = (__mmask16)((left >= 4 ? 0xffffu : (1u << 4 * left) - 1) & 0x2222u);",
                        "const __mmask16 alignments = (__mmask16)((left >= 4 ? 0xffffu : 0xffffu) & 0x2222u);"),
    "m13_vector_objects": ("src/buster/compiler/tier0.c",
                           "_mm512_cvtepu8_epi32(_mm_maskz_loadu_epi8(objects, function->local_alignments + first))",
                           "_mm512_cvtepu8_epi32(_mm_maskz_loadu_epi8(objects | (__mmask16)tier0_lanes(first, locals), function->local_alignments + first))"),
    "m14_vector_calls_ignored": ("src/buster/compiler/tier0.c",
                                 "    for (uint32_t first = 0; first < function->call_count; first += 4)",
                                 "    for (uint32_t first = 0; first < 0; first += 4)"),
}

def main():
    name = sys.argv[1]
    path, old, new = MUTANTS[name]
    tree = os.path.join(ROOT, name)
    if os.path.exists(tree):
        shutil.rmtree(tree)
    os.makedirs(tree)
    shutil.copytree(os.path.join(WORKTREE, "src"), os.path.join(tree, "src"))
    shutil.copytree(os.path.join(WORKTREE, "tests"), os.path.join(tree, "tests"))
    with open(os.path.join(WORKTREE, "build.sh")) as f:
        build = f.read()
    assert build.count("optimization=-O3") == 1
    with open(os.path.join(tree, "build.sh"), "w") as f:
        f.write(build.replace("optimization=-O3", "optimization=-O1"))
    os.chmod(os.path.join(tree, "build.sh"), 0o755)
    target = os.path.join(tree, path)
    with open(target) as f:
        text = f.read()
    assert text.count(old) == 1, (name, text.count(old))
    with open(target, "w") as f:
        f.write(text.replace(old, new))
    print(tree)

main()
