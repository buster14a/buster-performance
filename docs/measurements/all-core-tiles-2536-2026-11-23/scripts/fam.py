#!/usr/bin/env python3
import sys, collections, re
period = 100003
def load(path, compiles):
    d = collections.defaultdict(float)
    for line in open(path):
        n, ev, sym = (line.rstrip('\n').split('\t') + [''])[:3]
        d[(ev, sym)] += int(n) * period / compiles / 1e6
    return d
one = load(sys.argv[1], int(sys.argv[3])); eight = load(sys.argv[2], int(sys.argv[4]))
fams = [
 ('parser', r'^parse_'), ('reader: expressions', r'^check_input_expression'), ('reader: resolve/bindings', r'^check_input_(resolve|binding)|^c_bindings|^c_environment'),
 ('reader: other check_input_*', r'^check_input_'), ('preprocessor+lexer', r'^(pp_|refine_|tokenize_|intern_|lex_|c_lex|pp[A-Z_])'),
 ('graph run + actions', r'^check_graph|^check_action|^check_constant|^check_cast|^check_convert|^check_binary|^check_unary|^check_call|^check_member'),
 ('program/controls', r'^check_program|^check_control|^check_cfg'), ('warnings', r'^check_common|^check_warning|^check_driver_common|^check_input_warning|^check_uninit|^check_unseq'),
 ('initializers/static data', r'^check_init|^check_data|^check_static'), ('lowering', r'^check_lower|^c_lowering'), ('emission', r'^tier0|^x86_|^branch_|^unwind|^emission|^object_|^link_'),
 ('libc mem*', r'^__mem'), ('page-fault skid in user samples', r'^(asm_exc_page_fault|lock_vma_under_rcu|mas_walk|do_user_addr_fault|exc_page_fault|__handle_mm_fault|handle_mm_fault)$'),
 ('types', r'^type_|^c_types'), ('driver', r'^check_driver'), ('other check_*', r'^check_'),
]
for ev in ('cycles:u',):
    tot = collections.defaultdict(lambda: [0.0, 0.0])
    for src, idx in ((one, 0), (eight, 1)):
        for (e, s), v in src.items():
            if e != ev: continue
            for name, pat in fams:
                if re.search(pat, s):
                    tot[name][idx] += v; break
            else:
                tot['(rest)'][idx] += v
    print(f"{'family':38s} {'one':>8s} {'eight':>8s} {'excess':>8s} {'times':>6s}")
    for name, (a, b) in sorted(tot.items(), key=lambda kv: kv[1][0] - kv[1][1]):
        print(f"{name:38s} {a:8.1f} {b:8.1f} {b - a:8.1f} {b / a if a else 0:6.2f}")
    print(f"{'total':38s} {sum(v[0] for v in tot.values()):8.1f} {sum(v[1] for v in tot.values()):8.1f}")
