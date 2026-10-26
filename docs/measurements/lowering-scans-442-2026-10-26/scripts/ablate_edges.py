#!/usr/bin/env python3
# #442: removes #418's edges from a body to its block-scope statics, and their room, from #418's merge's
# c_check_program_select.c (the pr_select ablation; it lowers 00208's unreferenced static no more, as main did).
import sys
p = sys.argv[1]; s = open(p).read()
old = 'const uint64_t references64 = (uint64_t)full->reference_count + data->reference_count + data->count;'
assert s.count(old) == 1
s = s.replace(old, 'const uint64_t references64 = (uint64_t)full->reference_count + data->reference_count;')
i = s.index('            // A block-scope static (declared in a body, without linkage, not a compound literal), from its body.')
j = s.index('        const CLoweringInput graph')
s = s[:i] + '        }\n' + s[j:]
open(p, 'w').write(s)
