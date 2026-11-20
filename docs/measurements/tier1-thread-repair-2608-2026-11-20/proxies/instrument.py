# TEMPORARY (#2608 measurement): applies the counters to the working tree's ir_thread.c, by string, wherever a hook's
# anchor is present. Never committed.
import sys
p='/home/user/wt-2608/src/buster/compiler/ir_thread.c'
s=open(p).read()
INC='/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/h2608/fix/ir_thread_counters.inc'
def rep(old,new,required=True):
    global s
    n = s.count(old)
    if n != 1:
        if required:
            raise SystemExit('anchor %d: %r' % (n, old[:100]))
        return False
    s=s.replace(old,new)
    return True
rep('#define BUSTER_IR_THREAD_C\n', '#define BUSTER_IR_THREAD_C\n#include "%s"\n' % INC)
# repairable: step A and later have ir_thread_decides
if rep('            const bool repairable = escapes && !chain && alone && !header && ir_thread_decides(work, block, values, known);\n',
    '            const bool shaped = escapes && !chain && alone;\n            const bool repairable = shaped && !header && !ir_thread_mode_main && ir_thread_decides(work, block, values, known);\n            IR_THREAD_COUNT(escaping, escapes);\n            IR_THREAD_COUNT(repairable, shaped);\n            IR_THREAD_COUNT(headers, shaped && header);\n            IR_THREAD_COUNT(selected, repairable);\n', required=False):
    pass
elif not rep('            const bool repairable = escapes && !chain && alone && ir_thread_decides(work, block, values, known);\n',
    '            const bool shaped = escapes && !chain && alone;\n            const bool repairable = shaped && !ir_thread_mode_main && ir_thread_decides(work, block, values, known);\n            IR_THREAD_COUNT(escaping, escapes);\n            IR_THREAD_COUNT(repairable, shaped);\n            IR_THREAD_COUNT(selected, repairable);\n', required=False):
    rep('            const bool repairable = escapes && !chain && alone;\n',
        '            const bool repairable = escapes && !chain && alone && !ir_thread_mode_main;\n            IR_THREAD_COUNT(escaping, escapes);\n            IR_THREAD_COUNT(repairable, repairable);\n            IR_THREAD_COUNT(selected, repairable);\n')
rep('    work->analyses += 1;\n', '    work->analyses += 1;\n    IR_THREAD_COUNT(analyses, 1);\n    IR_THREAD_COUNT(analysis_blocks, cfg->block_count);\n', required=False)
rep('''    if (error == IR_OK)
    {
        ir_thread_escapes(work, BUSTER_IR_THREAD_REPAIRABLE);
    }''','''    if (error == IR_OK)
    {
        IR_THREAD_COUNT(scan2, 1);
        IR_THREAD_COUNT(scan2_instructions, f->instruction_count);
        ir_thread_escapes(work, BUSTER_IR_THREAD_REPAIRABLE);
    }''', required=False)
rep('''    ir_thread_escapes(work, BUSTER_IR_THREAD_REPAIRABLE);
}''', '''    IR_THREAD_COUNT(scan2, 1);
    IR_THREAD_COUNT(scan2_instructions, f->instruction_count);
    ir_thread_escapes(work, BUSTER_IR_THREAD_REPAIRABLE);
}''', required=False)
# header heuristics against the dominators' answer (step A)
rep('''        work->candidates[block] &= header ? ~BUSTER_IR_THREAD_REPAIRABLE : UINT32_MAX;
''', '''        work->candidates[block] &= header ? ~BUSTER_IR_THREAD_REPAIRABLE : UINT32_MAX;
        if (repairable)
        {
            bool retreating = false;
            for (uint32_t e = cfg->predecessor_offsets[block]; e < cfg->predecessor_offsets[(uint64_t)block + 1]; e += 1)
            {
                retreating = retreating || cfg->predecessors[e] >= block;
            }
            const bool backward = ir_thread_backward(f, f->block_offsets[block], f->block_offsets[(uint64_t)block + 1]);
            IR_THREAD_COUNT(headers, header);
            IR_THREAD_COUNT(retreating, retreating);
            IR_THREAD_COUNT(backward, backward);
            IR_THREAD_COUNT(header_missed, header && !retreating && !backward);
            IR_THREAD_COUNT(false_refusal, !header && (retreating || backward));
        }
''', required=False)
helper='''// TEMPORARY (#2608 measurement): each merged phi of threaded block J, classified.
static void ir_thread_count_merges(const IrThreadWork* work, uint32_t block)
{
    const IrFunction* f = work->function;
    const uint32_t first = f->block_offsets[block];
    const uint32_t last = f->block_offsets[(uint64_t)block + 1] - 1;
    uint8_t depends[1024];
    if (last - first < 1024)
    {
        memset(depends, 0, last - first);
        const uint32_t condition = f->a[last];
        depends[condition - first] = 1;
        for (uint32_t i = last; i > first; i -= 1)
        {
            const uint32_t at = i - 1;
            if (depends[at - first] != 0 && f->op[at] != IR_PHI)
            {
                const uint32_t mask = ir_value_mask(f, at);
                const uint32_t operands[2] = { f->a[at], f->b[at] };
                for (uint32_t k = 0; k < 2; k += 1)
                {
                    if (((mask >> k) & 1) != 0 && operands[k] >= first && operands[k] < last)
                    {
                        depends[operands[k] - first] = 1;
                    }
                }
            }
        }
        bool truth = false;
        bool all = true;
        for (uint32_t i = first; i < last && f->op[i] == IR_PHI; i += 1)
        {
            if (depends[i - first] != 0)
            {
                truth = true;
                for (uint32_t p = 0; p < f->b[i]; p += 1)
                {
                    all = all && f->op[f->extra[f->a[i] + p * 2 + 1]] == IR_CONST;
                }
            }
        }
        truth = truth && all;
        for (uint32_t i = first; i < last; i += 1)
        {
            if ((work->escapes[i] & BUSTER_IR_THREAD_COVERS) != 0)
            {
                IR_THREAD_COUNT(merges_tested, depends[i - first] != 0);
                IR_THREAD_COUNT(merges_truth, truth);
                IR_THREAD_COUNT(merges_truth_untested, truth && depends[i - first] == 0);
            }
        }
    }
}

// Thread block J where its predecessors allow it'''
rep('// Thread block J where its predecessors allow it', helper)
rep('    work->deferred += !apart;\n', '    work->deferred += !apart;\n    IR_THREAD_COUNT(deferred_roles, !apart);\n')
rep('    work->deferred += apart && !safe && (work->candidates[block] & BUSTER_IR_THREAD_REPAIRABLE) != 0;\n',
    '    work->deferred += apart && !safe && (work->candidates[block] & BUSTER_IR_THREAD_REPAIRABLE) != 0;\n    IR_THREAD_COUNT(deferred_repair, apart && !safe && (work->candidates[block] & BUSTER_IR_THREAD_REPAIRABLE) != 0);\n')
rep('        work->deferred += work->reachable[predecessor] != 0 && taken;\n', '        work->deferred += work->reachable[predecessor] != 0 && taken;\n        IR_THREAD_COUNT(deferred_roles, work->reachable[predecessor] != 0 && taken);\n')
if not rep('                work->deferred += work->actions[predecessor] == BUSTER_IR_THREAD_COPY && f->op[f->block_offsets[predecessor]] == IR_PHI;\n',
    '                work->deferred += !ir_thread_mode_main && work->actions[predecessor] == BUSTER_IR_THREAD_COPY && f->op[f->block_offsets[predecessor]] == IR_PHI;\n                IR_THREAD_COUNT(deferred_copy_phi, !ir_thread_mode_main && work->actions[predecessor] == BUSTER_IR_THREAD_COPY && f->op[f->block_offsets[predecessor]] == IR_PHI);\n', required=False):
    print('note: no copy-phi deferral anchor')
rep('        work->merged += merged;\n', '        work->merged += merged;\n        ir_thread_count_merges(work, block);\n')
rep('''    if (candidate)
    {
        check.error = ir_cfg_validated(function, scratch, scratch, &work.cfg);''','''    IR_THREAD_COUNT(attempts, 1);
    if (candidate)
    {
        IR_THREAD_COUNT(cfgs, 1);
        IR_THREAD_COUNT(cfg_blocks, blocks);
        IR_THREAD_COUNT(cfg_instructions, count);
        const uint64_t t0 = ir_thread_now();
        check.error = ir_cfg_validated(function, scratch, scratch, &work.cfg);
        IR_THREAD_COUNT(ns_cfg, ir_thread_now() - t0);''')
rep('''                any = any || work.candidates[block] != 0;
            }''','''                any = any || work.candidates[block] != 0;
                IR_THREAD_COUNT(candidates, work.candidates[block] != 0);
            }''')
rep('''                ir_thread_escapes(&work, BUSTER_IR_THREAD_TRACK_CANDIDATES);''','''                IR_THREAD_COUNT(scan1, 1);
                IR_THREAD_COUNT(scan1_instructions, count);
                ir_thread_escapes(&work, BUSTER_IR_THREAD_TRACK_CANDIDATES);''')
rep('''                    check.error = ir_thread_repairs(&work, output, scratch);''','''                    const uint64_t t1 = ir_thread_now();
                    check.error = ir_thread_repairs(&work, output, scratch);
                    IR_THREAD_COUNT(ns_repairs, ir_thread_now() - t1);''', required=False)
rep('''            check.error = ir_thread_rewrite(&work, output, scratch, result);''','''            const uint64_t t2 = ir_thread_now();
            check.error = ir_thread_rewrite(&work, output, scratch, result);
            IR_THREAD_COUNT(ns_rewrite, ir_thread_now() - t2);''')
rep('''            totals->merges += work.merged;
        }''','''            totals->merges += work.merged;
            IR_THREAD_COUNT(changed_rounds, 1);
            IR_THREAD_COUNT(blocks, work.block_count);
            IR_THREAD_COUNT(copies, work.copy_count);
            IR_THREAD_COUNT(redirects, work.redirect_count);
            IR_THREAD_COUNT(merges, work.merged);
            IR_THREAD_COUNT(rewrite_instructions, result->instruction_count);
        }''')
rep('''    IrThreadResult totals = { .function = *function };
    bool changed = true;''','''    IrThreadResult totals = { .function = *function };
    IR_THREAD_COUNT(calls, 1);
    const uint64_t t_total = ir_thread_now();
    bool changed = true;''')
rep('''    if (check.error == IR_OK)
    {
        *result = totals;''','''    IR_THREAD_COUNT(ns_total, ir_thread_now() - t_total);
    if (check.error == IR_OK)
    {
        *result = totals;''')
# walk hooks (step B), optional
rep('    work->walks += 1;\n', '    work->walks += 1;\n    IR_THREAD_COUNT(walks, 1);\n    IR_THREAD_COUNT(walk_steps, count);\n    IR_THREAD_COUNT(walk_budget, full);\n', required=False)
rep('    work->walked += count;\n', '    work->walked += count;\n    IR_THREAD_COUNT(walks, 1);\n    IR_THREAD_COUNT(walk_steps, count);\n    IR_THREAD_COUNT(walk_budget, full);\n', required=False)
rep('                work->deferred += work->actions[predecessor] == BUSTER_IR_THREAD_COPY && ir_thread_shaped(work, predecessor);\n',
    '                work->deferred += !ir_thread_mode_main && !ir_thread_mode_nocopy && work->actions[predecessor] == BUSTER_IR_THREAD_COPY && ir_thread_shaped(work, predecessor);\n                IR_THREAD_COUNT(deferred_copy_phi, !ir_thread_mode_main && !ir_thread_mode_nocopy && work->actions[predecessor] == BUSTER_IR_THREAD_COPY && ir_thread_shaped(work, predecessor));\n', required=False)
if not rep('                work->deferred += work->actions[predecessor] == BUSTER_IR_THREAD_COPY && ir_thread_shaped(work, predecessor, chain);\n',
    '                work->deferred += !ir_thread_mode_main && work->actions[predecessor] == BUSTER_IR_THREAD_COPY && ir_thread_shaped(work, predecessor, chain);\n                IR_THREAD_COUNT(deferred_copy_phi, !ir_thread_mode_main && work->actions[predecessor] == BUSTER_IR_THREAD_COPY && ir_thread_shaped(work, predecessor, chain));\n', required=False):
    pass
if rep('''                    ir_thread_repairs(&work);''', '''                    const uint64_t t1 = ir_thread_now();
                    ir_thread_repairs(&work);
                    IR_THREAD_COUNT(ns_repairs, ir_thread_now() - t1);''', required=False):
    pass
open(p,'w').write(s)
print('instrumented')
