import sys
p = sys.argv[1] + '/src/buster/compiler/c_direct_lex.c'
d = sys.argv[2]
s = open(p).read()
old = '''        const uint64_t block_off = off;
'''
assert s.count(old) == 1
s = s.replace(old, old + '''        _mm_prefetch((const char*)(base + off + %su), _MM_HINT_T0);
''' % d)
open(p, 'w').write(s)
