"""Compile instrumented alternatives of the final #3204 branch rule for isolated correctness checks."""
from pathlib import Path
import argparse, json, subprocess
p=argparse.ArgumentParser();p.add_argument('tree',type=Path);p.add_argument('revision');p.add_argument('manifest',type=Path);p.add_argument('--source',type=Path)
args=p.parse_args()
target = 'src/buster/compiler/c_check_program.c'
original = args.source.read_text() if args.source else subprocess.check_output(['git', 'show', f'{args.revision}:{target}'], cwd=args.tree).decode()
start = original.index('static bool check_program_branch_cast(')
walk = original.index('static bool check_program_branch_truth(', start)
end = original.index("// A switch's controlling type", walk)
helper = original[start:original.index("// A branch condition's truth",start)].strip()
fn = original[walk:end].strip()
probe = '(!cast || check_program_branch_cast(program, at))'
mutants = [
 ('always-follow', 'return !unproved;', '(void)unproved; return true;'),
 ('never-follow', 'return !unproved;', '(void)unproved; return false;'),
 ('omit-result-kind', 'check_stream_constant_kind(stream, node) == CHECK_CONSTANT_NONE && ', ''),
 ('guard-all-cast-origins', 'check_stream_constant_kind(stream, operand) == CHECK_CONSTANT_ADDRESS;', 'true;'),
 ('guard-all-unaries', probe, '(!unary || check_program_branch_cast(program, at))'),
 ('guard-only-explicit', probe, '(op != CHECK_OP_CAST || check_program_branch_cast(program, at))'),
 ('guard-only-implicit', probe, '(op != CHECK_OP_CONVERT || check_program_branch_cast(program, at))'),
]
# The normal source graph emits CAST in these source expressions. Replay the same checked values
# at the opcode discriminator as CONVERT for a separate, transparently labelled representation control.
op = 'const CheckOp op = at < graph->count ? graph->ops[at] : CHECK_OP_COUNT;'
replay = ('const CheckOp stored = at < graph->count ? graph->ops[at] : CHECK_OP_COUNT;\n'
          '        const CheckOp op = stored == CHECK_OP_CAST && getenv("BUSTER_QA_IMPLICIT_REPLAY") != NULL ? CHECK_OP_CONVERT : stored;')
assert fn.count(op) == 1
fn = fn.replace(op,replay)
variants, names = [], []
for label, old, new in mutants:
    body = helper + '\n\n' + fn
    if body.count(old) != 1:
        raise RuntimeError((label,old,body.count(old)))
    body = body.replace(old,new)
    for variable in ['strict','numeric_float','needs_boolean']:
        body = body.replace('const bool '+variable+' =', 'const bool __attribute__((unused)) '+variable+' =')
    names.append(label)
    i=len(names)
    body = body.replace('check_program_branch_truth(', f'check_program_branch_truth_fault_{i}(')
    body = body.replace('check_program_branch_cast(', f'check_program_branch_cast_fault_{i}(')
    variants.append(body)
body = original[start:end].replace('static bool check_program_branch_truth(', 'static bool check_program_branch_truth_control(').replace(op,replay)
selector = ['static bool check_program_branch_truth(const CheckProgram* program, uint32_t node, uint32_t condition, bool* truth)', '{', '    const char* name = getenv("BUSTER_QA_BRANCH_FAULT");', '    if (name != NULL)', '    {']
for i,label in enumerate(names,1):
    selector.append(f'        if (strcmp(name,"{label}") == 0) return check_program_branch_truth_fault_{i}(program, node, condition, truth);')
selector += ['    }','    return check_program_branch_truth_control(program, node, condition, truth);','}']
(args.tree/target).write_text(original[:start] + body + '\n\n'.join(variants) + '\n\n'+'\n'.join(selector)+'\n\n' + original[end:])
args.manifest.write_text(json.dumps(names,indent=2)+'\n')
