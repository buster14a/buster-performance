# SCCP worklist mutants: name, old, new (each old occurs once in ir_optimize.c).
M = [
 ("w1-settle-no-requeue", "        pending = ir_optimize_settle_unknown(work, true);", "        pending = ir_optimize_settle_unknown(work, false);"),
 ("w2-settle-last-change", "            changed = ir_optimize_publish(work, i, IROPT_OVERDEFINED, (IrConstant){ 0 }, queue) || changed;", "            changed = ir_optimize_publish(work, i, IROPT_OVERDEFINED, (IrConstant){ 0 }, queue);"),
 ("w3-no-phi-deferral", "            const bool defer = work->queued_count != 0 && work->states[i] == IROPT_CONSTANT && work->function->op[i] == IR_PHI;", "            const bool defer = false;"),
 ("w4-deferred-not-marked", "        work->queued[instruction] = 1;\n        work->phis[work->phi_tail] = instruction;", "        work->phis[work->phi_tail] = instruction;"),
 ("w5-phi-dequeue-keeps-mark", "        work->phi_count -= 1;\n        work->queued[instruction] = 0;", "        work->phi_count -= 1;"),
 ("w6-dequeue-keeps-mark", "    work->queued_count -= 1;\n    work->queued[instruction] = 0;", "    work->queued_count -= 1;"),
 ("w7-defer-overdefined", "work->states[i] == IROPT_CONSTANT && work->function->op[i] == IR_PHI;", "work->states[i] != IROPT_UNKNOWN && work->function->op[i] == IR_PHI;"),
]
import sys
name = sys.argv[1]
p = 'src/buster/compiler/ir_optimize.c'
s = open(p).read()
for n, a, b in M:
    if n == name:
        assert s.count(a) == 1, (n, s.count(a))
        open(p, 'w').write(s.replace(a, b, 1))
if name == "list":
    print(" ".join(n for n, _, _ in M))
