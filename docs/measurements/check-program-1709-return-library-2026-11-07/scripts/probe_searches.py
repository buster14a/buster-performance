# probe_searches.py SOURCE: patches c_check_return_flow.c (at #1709's head; not committed anywhere) so that
# check_program_return_facts prints, after it ends, how many calls reached the library-builtin test, how many of them
# searched the catalogue, and the identifier ids the memo covers. Built with BUSTER_DEBUG_INFO=0 ./build.sh and run
# off the 9700X on the frozen corpus's sqlite3.c -c and on sqlite 3.50.4's -c -g -Wall -Wextra; counts, not timings.
import sys
p = sys.argv[1]
s = open(p).read()
s = s.replace("static uint8_t check_program_return_library(", "static uint64_t probe_calls, probe_searches;\nstatic uint8_t check_program_return_library(", 1)
s = s.replace("    if (cached == 0)\n    {\n", "    probe_calls += 1;\n    if (cached == 0)\n    {\n        probe_searches += 1;\n", 1)
s = s.replace("    return facts;\n}", "    fprintf(stderr, \"probe return-library calls %lu searches %lu names %u\\n\", probe_calls, probe_searches, name_count);\n    return facts;\n}", 1)
open(p, 'w').write(s)
