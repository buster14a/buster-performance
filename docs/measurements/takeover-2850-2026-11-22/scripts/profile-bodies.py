# profile-bodies.py WHOLE MASKED: what the unit's function bodies cost each stage, as the ordinary compile's profile less the
# profile with every body masked (two directories of perf report --sort symbol outputs, report-*.txt), in cycles a token
# of the frozen sqlite3.c (716,136) and ms at 5.49 GHz. The two profiles are of two trees, so it is an estimate.
import re, glob, collections, sys
def load(d):
    tot = collections.Counter(); runs = 0
    for f in sorted(glob.glob(d + '/report-*.txt')):
        runs += 1
        for line in open(f):
            m = re.match(r'\s*([0-9.]+)%\s+(\d+)\s+\[(.)\]\s+(\S+)', line)
            if m: tot[m.group(4).replace('.buster_split', '')] += int(m.group(2))
    return {k: v / runs / 716136 for k, v in tot.items()}
whole = load(sys.argv[1]); masked = load(sys.argv[2])
def group(name):
    if name.startswith('check_input_expression') or name in ('check_input_expressions_coded_range', 'check_input_warning_graph', 'check_input_window_assign'): return 'reader: the expressions\' walk'
    if name in ('check_input_resolve_range', 'check_input_binding_answer', 'check_input_binding_answers', 'check_input_bind_checked', 'c_bindings_sort', 'c_bindings_restore', 'check_sparse_set'): return 'reader: the names\' resolution'
    if name.startswith('check_literal') or name.startswith('check_constant') or name in ('check_input_string', 'check_input_literal_table_prepare', 'check_input_intrinsic_prepare'): return 'reader: literals and constants'
    if name.startswith('check_input') or name.startswith('c_bindings') or name.startswith('check_sparse') or name.startswith('type_'): return 'reader: declarations, types and the rest'
    if name.startswith('check_graph') or name.startswith('check_action') or name.startswith('cbuiltin') or name.startswith('check_integer'): return 'the graph run'
    if name.startswith(('check_program', 'check_control', 'check_common', 'check_driver', 'check_init', 'check_data', 'c_lowering', 'check_warning')): return 'the program, the warnings, the data'
    if name.startswith('check_lower') or name.startswith('tier0_validate') or name.startswith('abi_'): return 'the lowering'
    if name.startswith(('tier0', 'x86', 'branch', 'object', 'link', 'check_tier0', 'unwind')): return 'Tier 0 and the emission'
    if name.startswith(('parse', 'pp_', 'tokenize', 'refine', 'intern', 'c_tokenize', 'lex')): return 'the preprocessor and the parser'
    return 'the kernel, libc and the rest'
g = collections.defaultdict(lambda: [0.0, 0.0])
rows = []
for k in set(whole) | set(masked):
    w, m = whole.get(k, 0), masked.get(k, 0)
    g[group(k)][0] += w; g[group(k)][1] += m
    rows.append((w - m, w, m, k))
print(f"{'':<42} {'ordinary':>9} {'masked':>8} {'bodies':>8} {'ms':>6}")
tw = tm = 0
for k, (w, m) in sorted(g.items(), key=lambda kv: -(kv[1][0] - kv[1][1])):
    print(f"{k:<42} {w:>9.1f} {m:>8.1f} {w - m:>8.1f} {(w - m) * 716136 / 5.49e6:>6.1f}")
    tw += w; tm += m
print(f"{'all':<42} {tw:>9.1f} {tm:>8.1f} {tw - tm:>8.1f} {(tw - tm) * 716136 / 5.49e6:>6.1f}")
print('\nby function, the largest differences (ordinary, masked, difference in cycles a token):')
for d, w, m, k in sorted(rows, reverse=True)[:40]:
    print(f"  {k:<50} {w:>6.1f} {m:>6.1f} {d:>6.1f}")
