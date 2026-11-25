#!/usr/bin/env python3
# emul-overlays.py CORPUS OUT: writes the emulation's overlay headers from the frozen corpus's musl (Zig 0.14.1's vendored
# musl 1.2.5, MIT, its COPYRIGHT file in the corpus) instead of keeping modified copies here:
#   OUT/overlay-alias/features.h    weak_alias(old, new) as `extern int buster_emulated_alias_##new`, a plain declaration
#   OUT/overlay-asm/syscall_arch.h  each __syscallN a call of buster_emulated_syscall, no inline assembly
#   OUT/overlay-asm/pthread_arch.h  __get_tp a call of buster_emulated_tp
# Put an overlay's directory first in the include path: the units then compile as they would if the direct path took
# those constructs, which is what emul.sh times (the stubs' calls aside).
import os, re, sys
corpus, out = sys.argv[1], sys.argv[2]
musl = os.path.join(corpus, 'libc', 'musl')
os.makedirs(os.path.join(out, 'overlay-alias'), exist_ok=True)
os.makedirs(os.path.join(out, 'overlay-asm'), exist_ok=True)
s = open(os.path.join(musl, 'src', 'include', 'features.h')).read()
i = s.index('#define weak_alias(old, new)')
j = s.index('\n', i)
while s[j - 1] == '\\':
    j = s.index('\n', j + 1)
open(os.path.join(out, 'overlay-alias', 'features.h'), 'w').write(s[:i] + '#define weak_alias(old, new) extern int buster_emulated_alias_##new' + s[j:])
s = open(os.path.join(musl, 'arch', 'x86_64', 'syscall_arch.h')).read()
def call(m):
    names = [p.split()[-1] for p in m.group(3).split(',')]
    return m.group(1) + '\n{\n\treturn buster_emulated_syscall(' + ', '.join(names + ['0'] * (7 - len(names))) + ');\n}'
s = re.sub(r'(static __inline long __syscall(\d)\(([^)]*)\))\s*\{.*?\n\}', call, s, flags=re.S)
open(os.path.join(out, 'overlay-asm', 'syscall_arch.h'), 'w').write('long buster_emulated_syscall(long, long, long, long, long, long, long);\n' + s)
s = open(os.path.join(musl, 'arch', 'x86_64', 'pthread_arch.h')).read()
s = re.sub(r'static inline uintptr_t __get_tp\(\)\s*\{.*?\n\}', 'uintptr_t buster_emulated_tp(void);\nstatic inline uintptr_t __get_tp()\n{\n\treturn buster_emulated_tp();\n}', s, flags=re.S)
open(os.path.join(out, 'overlay-asm', 'pthread_arch.h'), 'w').write(s)
