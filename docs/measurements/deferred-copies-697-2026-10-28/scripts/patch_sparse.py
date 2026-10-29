# The diagnostic of 3-diag9.sh, not a change of item 2: check_input_run's arena of rare columns (#572) in base pages
# throughout, rather than huge pages past its scope stacks.
import sys
p = sys.argv[1]
s = open(p).read()
a = "    Arena sparse = valid ? arena_reserve_small(sparse_bytes, sparse_small > BUSTER_ARENA_SMALL_BYTES ? sparse_small : BUSTER_ARENA_SMALL_BYTES) : (Arena){ 0 };"
b = "    Arena sparse = valid ? arena_reserve_small(sparse_bytes, sparse_bytes > BUSTER_ARENA_SMALL_BYTES ? ((sparse_bytes + BUSTER_ARENA_PAGE_BYTES - 1) & ~(BUSTER_ARENA_PAGE_BYTES - 1)) : BUSTER_ARENA_SMALL_BYTES) : (Arena){ 0 };"
assert s.count(a) == 1
open(p, 'w').write(s.replace(a, b))
