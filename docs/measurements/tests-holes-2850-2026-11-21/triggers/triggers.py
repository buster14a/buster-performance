#!/usr/bin/env python3
# triggers.py COMPILER OUT_DIR [PILE.tsv...]: a program a warning that node_census_warning_classes marks as tested.
# Each trigger below is (warning's ID, its name, the options that enable it, a piece of the compiler's own message, the
# program). A trigger is written to OUT_DIR, compiled with -fsyntax-only and its options, and must warn with its
# message; then it is run through the shadow (measure-node-machine --shadow --window-rows --passes 0) with its options
# alone, with -Wall -Wextra and with -Weverything -Wno-c++-compat beside them, and the three runs' statuses, their
# unsound takes and whether the census saw the warning's event in an expression are its line.
# A warning with no trigger here has the first program of the sweep's piles (PILE.tsv, sweep.py's) whose run saw its
# event in an expression, run the same way. One warning has neither: -Wavailability's, which warns of an attribute's
# platform, and the compiler has x86_64-linux-gnu's predefines alone.
import collections, os, re, subprocess, sys

compiler, out = sys.argv[1], sys.argv[2]
piles = sys.argv[3:]
os.makedirs(out, exist_ok=True)

FORMAT = 'int printf(const char*, ...);\n'
ENUMS = 'enum A { A0, A1 };\nenum B { B0, B1 };\n'
TRIGGERS = [
    (0, 'DISCARDED_QUALIFIERS', [], 'discards qualifiers', 'void f(const int* p)\n{\n    int* q;\n    q = p;\n    (void)q;\n}\n'),
    (4, 'SHIFT_COUNT_NEGATIVE', [], 'shift count is negative', 'int f(int a)\n{\n    return a << -1;\n}\n'),
    (11, 'POINTER_SIGN', [], '-Wpointer-sign', 'void f(unsigned* u, int* s)\n{\n    s = u;\n    (void)s;\n}\n'),
    (12, 'POINTER_INTEGER_COMPARE', [], '-Wpointer-integer-compare', 'int f(int* p, long a)\n{\n    return p == a;\n}\n'),
    (13, 'DISTINCT_POINTER_COMPARE', [], 'distinct pointer types', 'int f(int* p, long* q)\n{\n    return p == q;\n}\n'),
    (14, 'CONDITIONAL_POINTER_INTEGER', [], 'type mismatch in conditional', 'void* f(int c, int* p, long a)\n{\n    return c ? p : a;\n}\n'),
    (15, 'CONDITIONAL_POINTER_TYPES', [], 'pointer type mismatch', 'void* f(int c, int* p, long* q)\n{\n    return c ? p : q;\n}\n'),
    (16, 'ADDRESS_OF_PACKED_MEMBER', [], 'unaligned pointer value',
     'struct __attribute__((packed)) P { char c; int i; };\nint* f(struct P* p)\n{\n    return &p->i;\n}\n'),
    (17, 'ARGUMENT_OUTSIDE_RANGE', ['-Wno-error=argument-outside-range'], 'outside the valid range',
     'typedef char C16 __attribute__((vector_size(16)));\n__attribute__((target("avx512bw,avx512vl"))) unsigned short f(C16 a)\n{\n'
     '    return __builtin_ia32_cmpb128_mask(a, a, 8, 65535);\n}\n'),
    (19, 'IMPLICIT_FUNCTION_DECLARATION', ['-Wno-error=implicit-function-declaration'], '-Wimplicit-function-declaration',
     'int f(void)\n{\n    return undeclared_function(1);\n}\n'),
    (22, 'NON_PROTOTYPE_CALL', [], 'without a prototype', 'int g();\nint f(void)\n{\n    return g(1);\n}\n'),
    (23, 'KR_TOO_FEW', [], 'too few arguments', 'int g(a, b) int a; int b; { return a + b; }\nint f(void)\n{\n    return g(1);\n}\n'),
    (24, 'KR_TOO_MANY', [], 'too many arguments', 'int g(a) int a; { return a; }\nint f(void)\n{\n    return g(1, 2);\n}\n'),
    (40, 'BUILTIN_HEADER', ['-Wno-error=implicit-function-declaration'], 'include the header',
     'int f(void)\n{\n    return printf("x");\n}\n'),
    (42, 'DIVISION_BY_ZERO', [], '-Wdivision-by-zero', 'int f(int a)\n{\n    return a / 0;\n}\n'),
    (43, 'CONSTANT_CONVERSION', [], '-Wconstant-conversion', 'int f(void)\n{\n    char c = 300;\n    c = 400;\n    return c;\n}\n'),
    (44, 'ARRAY_BOUNDS', [], '-Warray-bounds', 'int f(void)\n{\n    int a[4];\n    a[0] = 0;\n    return a[5];\n}\n'),
    (45, 'SIGN_COMPARE', ['-Wsign-compare'], '-Wsign-compare', 'int f(int a, unsigned b)\n{\n    return a < b;\n}\n'),
    (46, 'UNUSED_COMPARISON', [], '-Wunused-comparison', 'void f(int a)\n{\n    a == 1;\n}\n'),
    (47, 'UNUSED_VALUE', [], '-Wunused-value', 'void f(int a)\n{\n    a + 1;\n}\n'),
    (48, 'LOGICAL_NOT_PARENTHESES', [], '-Wlogical-not-parentheses', 'int f(int a)\n{\n    return !a == 3;\n}\n'),
    (49, 'PARENTHESES', [], '-Wparentheses', 'int f(int a, int b)\n{\n    if (a = b) return 1;\n    return a & b == 2;\n}\n'),
    (51, 'SELF_ASSIGN', ['-Wself-assign'], '-Wself-assign', 'void f(int a)\n{\n    a = a;\n}\n'),
    (52, 'RETURN_STACK_ADDRESS', [], '-Wreturn-stack-address', 'int* f(void)\n{\n    int a = 0;\n    return &a;\n}\n'),
    (53, 'FORMAT', [], '-Wformat', FORMAT + 'void f(int a)\n{\n    printf("%s", a);\n}\n'),
    (54, 'FORMAT_SECURITY', [], '-Wformat-security', FORMAT + 'void f(const char* s)\n{\n    printf(s);\n}\n'),
    (63, 'FORMAT_EXTRA_ARGS', [], '-Wformat-extra-args', FORMAT + 'void f(int a)\n{\n    printf("x", a);\n}\n'),
    (64, 'FORMAT_INSUFFICIENT_ARGS', [], '-Wformat-insufficient-args', FORMAT + 'void f(void)\n{\n    printf("%d");\n}\n'),
    (65, 'FORMAT_INVALID_SPECIFIER', [], '-Wformat-invalid-specifier', FORMAT + 'void f(int a)\n{\n    printf("%y", a);\n}\n'),
    (84, 'LITERAL_CONVERSION', [], '-Wliteral-conversion', 'int f(void)\n{\n    int a = 1.5;\n    a = 2.5;\n    return a;\n}\n'),
    (94, 'MULTICHAR', [], '-Wmultichar', 'int f(void)\n{\n    return \'ab\';\n}\n'),
    (95, 'FOUR_CHAR_CONSTANTS', ['-Wfour-char-constants'], '-Wfour-char-constants', 'int f(void)\n{\n    return \'abcd\';\n}\n'),
    (96, 'CHARACTER_TOO_LONG', [], 'too long', 'int f(void)\n{\n    return \'abcde\';\n}\n'),
    (97, 'NULL_DEREFERENCE', [], '-Wnull-dereference', 'int f(void)\n{\n    return *(int*)0;\n}\n'),
    (100, 'UNUSED_RESULT', [], '-Wunused-result', 'int g(void) __attribute__((warn_unused_result));\nvoid f(void)\n{\n    g();\n}\n'),
    (101, 'INT_IN_BOOL_CONTEXT', ['-Wint-in-bool-context'], '-Wint-in-bool-context', 'int f(int a)\n{\n    if (a << 3) return 1;\n    return a * 2 ? 3 : 4;\n}\n'),
    (102, 'TAUTOLOGICAL_CONSTANT_COMPARE', [], '-Wtautological-constant', 'int f(_Bool b, unsigned u)\n{\n    return (b > 1) + (b == 2) + (u < 0);\n}\n'),
    (103, 'BITFIELD_CONSTANT_CONVERSION', [], '-Wbitfield-constant-conversion', 'struct B { unsigned f : 3; };\nvoid f(struct B* b)\n{\n    b->f = 9;\n}\n'),
    (104, 'SINGLE_BIT_BITFIELD_CONSTANT_CONVERSION', [], '-Wsingle-bit-bitfield-constant-conversion',
     'struct B { int f : 1; };\nvoid f(struct B* b)\n{\n    b->f = 1;\n}\n'),
    (106, 'ENUM_ENUM_CONVERSION', ['-Wenum-enum-conversion'], '-Wenum-enum-conversion', ENUMS + 'int f(enum A a, enum B b)\n{\n    return a + b;\n}\n'),
    (107, 'ENUM_COMPARE_CONDITIONAL', ['-Wenum-compare-conditional'], '-Wenum-compare-conditional', ENUMS + 'int f(int c, enum A a, enum B b)\n{\n    return c ? a : b;\n}\n'),
    (108, 'ENUM_FLOAT_CONVERSION', ['-Wenum-float-conversion'], '-Wenum-float-conversion', ENUMS + 'double f(enum A a, double d)\n{\n    return a + d;\n}\n'),
    (109, 'ANON_ENUM_ENUM_CONVERSION', ['-Wanon-enum-enum-conversion'], '-Wanon-enum-enum-conversion',
     ENUMS + 'enum { X0, X1 };\nint f(enum B b)\n{\n    return X1 + b;\n}\n'),
    (110, 'FOR_LOOP_ANALYSIS', ['-Wfor-loop-analysis'], '-Wfor-loop-analysis', 'void g(int);\nvoid f(int n)\n{\n    for (int i = 0, j = 0; i < n; j++) g(j);\n}\n'),
    (111, 'IMPLICIT_ENUM_ENUM_CAST', ['-Wimplicit-enum-enum-cast'], '-Wimplicit-enum-enum-cast', ENUMS + 'enum A f(enum B b)\n{\n    enum A a = b;\n    a = b;\n    return a;\n}\n'),
    (115, 'NONSTANDARD_ESCAPE', ['-Wpedantic'], 'non-standard escape', 'int f(void)\n{\n    return "\\e"[0];\n}\n'),
    (120, 'TYPE_SAFETY', [], '-Wtype-safety',
     'static const int tag_long __attribute__((type_tag_for_datatype(magic, long))) = 42;\nvoid take(void* buffer, int tag) __attribute__((pointer_with_type_tag(magic, 1, 2)));\n'
     'void f(int* p)\n{\n    take(p, 42);\n}\n'),
    (132, 'UNSEQUENCED', [], '-Wunsequenced', 'int f(int i)\n{\n    return i + i++;\n}\n'),
    (140, 'STRING_PLUS_INT', [], '-Wstring-plus-int', 'const char* f(int i)\n{\n    return "abc" + i;\n}\n'),
    (141, 'SHIFT_OP_PARENTHESES', ['-Wshift-op-parentheses'], '-Wshift-op-parentheses', 'int f(int a, int b)\n{\n    return a << b + 1;\n}\n'),
    (142, 'SIZEOF_ARRAY_DECAY', [], '-Wsizeof-array-decay', 'unsigned long f(void)\n{\n    int a[4];\n    return sizeof(a + 1);\n}\n'),
    (143, 'CHAINED_COMPARISON', ['-Wno-error=parentheses'], 'chained comparison', 'int f(int a, int b, int c)\n{\n    return a < b < c;\n}\n'),
    (150, 'PSABI', [], '-Wpsabi', 'typedef long long v4 __attribute__((vector_size(32)));\nv4 ext(v4);\nint f(int n)\n{\n    v4 z = { n };\n    return (int)ext(z)[0];\n}\n',
     ['-c', '-o', '/dev/null']),
    (154, 'ASSIGN_ENUM', ['-Wassign-enum'], '-Wassign-enum', ENUMS + 'void f(void)\n{\n    enum A a = 5;\n    a = 7;\n    (void)a;\n}\n'),
    (156, 'TAUTOLOGICAL_OUT_OF_RANGE_COMPARE', [], 'out-of-range-compare', 'int f(unsigned char c, signed char s)\n{\n    return (c > 300) + (s > 127) + (c == -1);\n}\n'),
    (158, 'INT_CONVERSION', ['-Wno-error=int-conversion'], '-Wint-conversion', 'int* f(long a)\n{\n    int* p = a;\n    p = a;\n    return p;\n}\n'),
    (159, 'INCOMPATIBLE_POINTER_TYPES', ['-Wno-error=incompatible-pointer-types'], '-Wincompatible-pointer-types', 'long* f(int* p)\n{\n    long* q = p;\n    q = p;\n    return q;\n}\n'),
    (160, 'INCOMPATIBLE_FUNCTION_POINTER_TYPES', ['-Wno-error=incompatible-function-pointer-types'], '-Wincompatible-function-pointer-types',
     'void g(int);\nvoid f(void)\n{\n    void (*q)(long) = g;\n    q = g;\n    q(1);\n}\n'),
    (161, 'RETURN_MISMATCH', ['-Wno-error=return-mismatch'], '-Wreturn-mismatch', 'void f(int a)\n{\n    if (a) return 1;\n}\n'),
    (163, 'ATOMIC_ACCESS', ['-Wno-error=atomic-access'], '-Watomic-access', 'struct S { int x; };\n_Atomic(struct S) a;\nint f(void)\n{\n    return a.x;\n}\n'),
]

SETS = (('own', []), ('wall', ['-Wall', '-Wextra']), ('everything', ['-Weverything', '-Wno-c++-compat']))
event = re.compile(r'^node-census: event id=(\d+) ', re.M)
unsound = re.compile(r'taken-there-and-refused-by-the-census=(\d+)')

def shadow(path, options):
    r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '3'] + options + [path], capture_output=True)
    text = (r.stdout + r.stderr).decode('utf-8', 'replace')
    ran = 'window rows expressions=' in text
    m = unsound.search(text)
    return r.returncode, ran, int(m.group(1)) if m else 0, set(int(x) for x in event.findall(text))

rows = []
written = {}
for trigger in TRIGGERS:
    number, name, options, expect, program = trigger[:5]
    # (A warning the code's generation raises is seen with -c: the sixth field.)
    check = trigger[5] if len(trigger) > 5 else ['-fsyntax-only']
    path = os.path.join(out, '%03d-%s.c' % (number, name.lower()))
    open(path, 'w').write(program)
    c = subprocess.run([compiler] + check + options + [path], capture_output=True)
    message = c.stderr.decode('utf-8', 'replace')
    warned = expect in message and c.returncode == 0
    runs = []
    for label, more in SETS:
        status, ran, takes, events = shadow(path, options + more)
        runs.append((label, status, ran, takes, number in events))
    rows.append((number, name, 'written', warned, runs, ' '.join(options)))
    written[number] = warned
    if not warned:
        first = [l for l in message.split('\n') if 'warning:' in l or 'error:' in l][:2]
        print('  %d %s does not warn as written: status %d; %s' % (number, name, c.returncode, ' | '.join(x[:150] for x in first)))

# The warnings seen in the piles: the first program of each.
seen = collections.OrderedDict()
for pile in piles:
    more = ['-Wall', '-Wextra'] if '-wall' in pile else ['-Weverything', '-Wno-c++-compat'] if '-everything' in pile else []
    for line in open(pile):
        f = line.rstrip('\n').split('\t')
        for e in filter(None, f[4].split(',')):
            number = int(e.split(':')[0])
            seen.setdefault(number, (f[0], more))

if len(sys.argv) > 3:
    import json
    ids = json.load(open(os.path.join(os.path.dirname(out.rstrip('/')), 'ids.json'))) if os.path.exists(os.path.join(os.path.dirname(out.rstrip('/')), 'ids.json')) else []
    for number, name, klass, _, _ in ids:
        if klass == 'TESTED' and number not in written and number in seen:
            path, more = seen[number]
            runs = []
            for label, extra in SETS:
                status, ran, takes, events = shadow(path, extra if label != 'own' else more)
                runs.append((label, status, ran, takes, number in events))
            rows.append((number, name, 'pile:' + os.path.basename(path), True, runs, ' '.join(more)))
        elif klass == 'TESTED' and number not in written:
            rows.append((number, name, 'none', False, [], ''))

rows.sort()
bad = 0
for number, name, source, warned, runs, options in rows:
    cells = ['%s:%s%s%s' % (label, status, '' if ran else '(rejected)', ' UNSOUND=%d' % takes if takes else '') + ('+event' if ev else '') for label, status, ran, takes, ev in runs]
    wrong = any(status != 0 and ran for _, status, ran, _, _ in runs) or any(takes for _, _, _, takes, _ in runs)
    bad += wrong
    print('%3d %-40s %-7s %-10s %s%s%s' % (number, name, 'warns' if warned else 'NO', source[:10], ' '.join(cells), '  [' + options + ']' if options else '', '  <== DIFFERS' if wrong else ''))
print('triggers: %d warnings; %d written, %d of them warn; %d from the piles; %d with none; %d with a run that differs' % (
    len(rows), sum(1 for r in rows if r[2] == 'written'), sum(1 for r in rows if r[2] == 'written' and r[3]), sum(1 for r in rows if r[2].startswith('pile')),
    sum(1 for r in rows if r[2] == 'none'), bad))
