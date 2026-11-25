import sys
p = sys.argv[1] + '/src/buster/compiler/c_direct_lex.c'
s = open(p).read()
old = '''        const uint32_t limit = (uint32_t)_tzcnt_u64(special);'''
assert s.count(old) == 1
s = s.replace(old, '''        uint32_t limit = (uint32_t)_tzcnt_u64(special);
        __asm__("imul $1, %0, %0\\n\\timul $1, %0, %0\\n\\timul $1, %0, %0" : "+r"(limit));''')
open(p, 'w').write(s)
