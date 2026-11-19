#!/usr/bin/env python3
# warns.py COMPILER STATEMENTS: for each line `CONTEXT @@ SOURCE` (probe4.py's format), whether the compiler and clang
# warn of a null pointer constant that is no literal (-Wnon-literal-null-conversion) and whether each rejects the program.
import subprocess, sys, os, re
compiler = sys.argv[1]
head = '''enum color { RED, GREEN };
enum shade { DARK = 0, LIGHT = 1 };
struct pair { int* first; char* second; };
typedef int* intp;
void fp(const char*);
void fv(void*);
void f2(int, char*);
void fe(int, ...);
int* gp;
'''
templates = {
    'assign': ('int g(int* ip, int a)\n{\n    ip = X;\n    return a;\n}\n'),
    'init': ('int g(int* ip, int a)\n{\n    int* np = X;\n    return a;\n}\n'),
    'argument': ('int g(int* ip, int a)\n{\n    fp(X);\n    return a;\n}\n'),
    'second': ('int g(int* ip, int a)\n{\n    f2(a, X);\n    return a;\n}\n'),
    'return': ('char* g(int* ip, int a)\n{\n    return X;\n}\n'),
}
os.makedirs('lines5', exist_ok=True)
counts = {}
for line in open(sys.argv[2]):
    line = line.rstrip('\n')
    if not line.strip() or line.startswith('#'):
        continue
    context, source = [part.strip() for part in line.split(' @@ ', 1)]
    body = templates[context] if context in templates else 'int g(int* ip, int a)\n{\n    ' + context + '\n    return a;\n}\n'
    open('lines5/one.c', 'w').write(head + body.replace('X', source))
    ours = subprocess.run([compiler, '-fsyntax-only', 'lines5/one.c'], capture_output=True, text=True)
    theirs = subprocess.run(['clang', '-fsyntax-only', '-x', 'c', 'lines5/one.c'], capture_output=True, text=True)
    def read(run):
        text = run.stdout + run.stderr
        return ('non-literal-null-conversion' in text, run.returncode != 0, sorted(set(re.findall(r'\[(-W[\w-]+)\]', text)) - {'-Wnon-literal-null-conversion'}))
    a = read(ours); b = read(theirs)
    shown = (context if context in templates else 'stmt') + ': ' + (source if context in templates else context.replace('X', source))
    same = a[0] == b[0] and a[1] == b[1]
    key = (a[0], b[0], a[1], b[1])
    counts[key] = counts.get(key, 0) + 1
    print('%-44s compiler: warns=%d rejects=%d clang: warns=%d rejects=%d%s%s%s' % (shown[:44], a[0], a[1], b[0], b[1], '' if same else ' DIFFERENT', (' compiler-other=' + ','.join(a[2])) if a[2] else '', (' clang-other=' + ','.join(b[2])) if b[2] else ''))
for key in sorted(counts):
    print('# compiler warns=%d clang warns=%d compiler rejects=%d clang rejects=%d: %d' % (*key, counts[key]))
