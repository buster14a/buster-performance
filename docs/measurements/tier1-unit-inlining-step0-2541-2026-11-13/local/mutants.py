# Each mutant: (name, old, new) applied once to ir_optimize_inline.c in the mutant worktree.
import subprocess, sys, shutil
W='/home/user/buster-wt-mutants'
F=W+'/src/buster/compiler/ir_optimize_inline.c'
orig=open(F).read()
M=[
 ("result-phi-operand", "        if (returns->slice != BUSTER_IR_NONE)\n        {\n            rewritten->extra[returns->slice + returns->written * 2] = block_base + block;\n            rewritten->extra[returns->slice + returns->written * 2 + 1] = value;",
  "        if (returns->slice != BUSTER_IR_NONE)\n        {\n            rewritten->extra[returns->slice + returns->written * 2] = block_base + block;\n            rewritten->extra[returns->slice + returns->written * 2 + 1] = returns->written == 1 ? returns->single : value;"),
 ("phi-block-base", "            rewritten->extra[cursor->extra++] = callee->extra[callee->a[inner] + p * 2] + block_base;",
  "            rewritten->extra[cursor->extra++] = callee->extra[callee->a[inner] + p * 2];"),
 ("caller-predecessor-remap", "                            rewritten.extra[cursor.extra++] = block_last[source->extra[source->a[node] + p * 2]];",
  "                            rewritten.extra[cursor.extra++] = block_first[source->extra[source->a[node] + p * 2]];"),
 ("switch-constant-rebase", "            rewritten->extra[cursor->extra++] = callee->extra[callee->b[inner] + 1 + k * 2] + bases.constants;",
  "            rewritten->extra[cursor->extra++] = callee->extra[callee->b[inner] + 1 + k * 2];"),
 ("parameter-binding", "        inner_values[inner] = callee->op[inner] == IR_PARAM ? parameters[callee->a[inner]] : next++;",
  "        inner_values[inner] = callee->op[inner] == IR_PARAM ? parameters[0] : next++;"),
 ("vector-value-shift", "            rebased = _mm512_mask_add_epi32(rebased, value, operand, run);",
  "            rebased = _mm512_mask_add_epi32(rebased, value, operand, _mm512_sub_epi32(run, _mm512_set1_epi32(1)));"),
 ("scalar-cbr-block-base", "                    rewritten->b[at] += block_base;\n                    rewritten->c[at] += block_base;",
  "                    rewritten->b[at] += block_base;"),
 ("vector-kind-table", "    kinds->columns[2][IR_CBR] = BUSTER_IR_INLINE_BLOCK;\n", ""),
 ("lifetime-ends-before-copy", "    if (callee->result_size != 0 && source->c[node] != BUSTER_IR_NONE && shape->returns != 0)\n    {\n        const IrType whole = ir_inline_result_whole(callee->result_abi, callee->result_size, allowed);\n        ir_inline_emit_copy(rewritten, cursor, returned, values[source->c[node]], callee->result_size, whole);\n    }\n    for (uint32_t slot = copies; slot < copies_end; slot += 1)\n    {\n        ir_inline_emit(rewritten, cursor, IR_LIFETIME, IR_VOID, slot, 1, BUSTER_IR_NONE);\n    }\n    for (uint32_t slot = 0; slot < callee->slot_count; slot += 1)\n    {\n        if (shape->marked[slot] == 0)\n        {\n            ir_inline_emit(rewritten, cursor, IR_LIFETIME, IR_VOID, bases.slots + slot, 1, BUSTER_IR_NONE);\n        }\n    }",
  "    for (uint32_t slot = copies; slot < copies_end; slot += 1)\n    {\n        ir_inline_emit(rewritten, cursor, IR_LIFETIME, IR_VOID, slot, 1, BUSTER_IR_NONE);\n    }\n    for (uint32_t slot = 0; slot < callee->slot_count; slot += 1)\n    {\n        if (shape->marked[slot] == 0)\n        {\n            ir_inline_emit(rewritten, cursor, IR_LIFETIME, IR_VOID, bases.slots + slot, 1, BUSTER_IR_NONE);\n        }\n    }\n    if (callee->result_size != 0 && source->c[node] != BUSTER_IR_NONE && shape->returns != 0)\n    {\n        const IrType whole = ir_inline_result_whole(callee->result_abi, callee->result_size, allowed);\n        ir_inline_emit_copy(rewritten, cursor, returned, values[source->c[node]], callee->result_size, whole);\n    }"),
 ("caller-branch-target", "                        rewritten.a[cursor.node] = block_first[source->a[node]];",
  "                        rewritten.a[cursor.node] = source->a[node];"),
]
only = sys.argv[1:] 
for name, old, new in M:
    if only and name not in only: continue
    assert orig.count(old)==1, name
    open(F,'w').write(orig.replace(old,new))
    b=subprocess.run(['./build.sh','--config','Develop','--jobs','4'],cwd=W,capture_output=True,text=True)
    if b.returncode!=0:
        print(name,'BUILD FAILED',b.stderr[-500:]); continue
    t=subprocess.run(['./build/compiler','test-ir-inline'],cwd=W,capture_output=True,text=True)
    last=[l for l in t.stderr.splitlines() if 'checks=' in l]
    first=[l for l in t.stderr.splitlines() if 'checks=' not in l][:2]
    print(name, 'exit', t.returncode, last[-1] if last else '', '|', ' / '.join(first), flush=True)
open(F,'w').write(orig)
