# Overloadable functions (Itanium-mangled, with substitutions), enable_if conditions and calls choosing among them.
import sys
n = int(sys.argv[2])
out = ['struct S0 { int a; }; struct S1 { double b; }; struct S2 { char c[4]; };']
for i in range(n):
    out.append(f'__attribute__((overloadable)) int f{i}(struct S{i%3}* a, struct S{i%3}* b, int k) {{ return a == b ? k : {i}; }}')
    out.append(f'__attribute__((overloadable)) int f{i}(struct S{(i+1)%3}* a, struct S{(i+1)%3}* b, double k, long z) {{ return (int)k + (int)z; }}')
    out.append(f'__attribute__((overloadable)) int g{i}(int x) __attribute__((enable_if(x > {i}, "big"))) {{ return x; }}')
    out.append(f'__attribute__((overloadable)) int g{i}(int x) {{ return -x; }}')
out.append('int use(struct S0* p, struct S1* q, struct S2* r) { int t = 0;')
for i in range(n):
    a = f'S{i%3}'; b = f'S{(i+1)%3}'
    va = {'S0': 'p', 'S1': 'q', 'S2': 'r'}
    out.append(f'  t += f{i}({va[a]}, {va[a]}, {i}) + f{i}({va[b]}, {va[b]}, 1.0, 2L) + g{i}(t) + g{i}({i+5});')
out.append('  return t; }')
open(sys.argv[1], 'w').write('\n'.join(out) + '\n')
