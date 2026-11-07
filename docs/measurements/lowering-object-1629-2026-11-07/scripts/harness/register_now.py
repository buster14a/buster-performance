#!/usr/bin/env python3
# #442: registers emit_ab_now.c's command, benchmark-emit-ab, in a Buster tree after #1057 (check_source_prepare): in the
# checker's unit, after c_lowering_source_benchmark.c, whose helpers it uses. Usage: register_now.py MAIN_C
import sys, re
path = sys.argv[1]
s = open(path).read()
include = '#include "buster/compiler/c_lowering_source_benchmark.c"\n'
assert s.count(include) == 1
s = s.replace(include, include + '#include "buster/compiler/emit_ab.c"\n')
m = re.search(r'( *)else if \(BUSTER_HOST_VECTOR && BUSTER_IN_UNIT\(BUSTER_UNIT_CHECKER\) && argc >= 2 && strcmp\(argv\[1\], "benchmark-lowering-source"\) == 0\)\n', s)
assert m
i = m.group(1)
s = s[:m.start()] + (f'{i}else if (BUSTER_HOST_VECTOR && BUSTER_IN_UNIT(BUSTER_UNIT_CHECKER) && argc >= 2 && strcmp(argv[1], "benchmark-emit-ab") == 0)\n'
                     f'{i}{{\n{i}    result = run_emit_ab_benchmark(argc - 2, argv + 2);\n{i}}}\n') + s[m.start():]
open(path, 'w').write(s)
