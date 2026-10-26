#!/usr/bin/env python3
# #442: registers emit_ab.c's command, benchmark-emit-ab, in a Buster tree's main.c (in the checker's unit, after
# c_check_source_benchmark.c, whose helpers it uses). EMIT_AB_EMIT_TAIL is the tree's check_program_emit arguments
# after `scratch`: "NULL, false" before #395's rows (main and #418's merge), "NULL, NULL, false" after.
import sys, re
path, tail = sys.argv[1], sys.argv[2]
s = open(path).read()
include = '#include "buster/compiler/c_check_source_benchmark.c"\n'
assert s.count(include) == 1
s = s.replace(include, include + '#define EMIT_AB_EMIT_TAIL ' + tail + '\n#include "buster/compiler/emit_ab.c"\n')
m = re.search(r'( *)else if \(BUSTER_IN_UNIT\(BUSTER_UNIT_CHECKER\) && argc >= 2 && strcmp\(argv\[1\], "benchmark-checker-source"\) == 0\)\n', s)
assert m
i = m.group(1)
s = s[:m.start()] + (f'{i}else if (BUSTER_IN_UNIT(BUSTER_UNIT_CHECKER) && argc >= 2 && strcmp(argv[1], "benchmark-emit-ab") == 0)\n'
                     f'{i}{{\n{i}    result = run_emit_ab_benchmark(argc - 2, argv + 2);\n{i}}}\n') + s[m.start():]
open(path, 'w').write(s)
