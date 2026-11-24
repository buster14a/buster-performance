M = [
 ("carry-dropped", "carried = __builtin_add_overflow(odd_starts, backslashes, &sum) ? 1 : 0;", "carried = __builtin_add_overflow(odd_starts, backslashes, &sum) ? 0 : 0;"),
 ("follows-no-carry", "const uint64_t follows = (backslashes << 1) | carried;", "const uint64_t follows = (backslashes << 1) | (carried >> 1);"),
 ("odd-starts-even", "const uint64_t odd_starts = backslashes & ~even & ~follows;", "const uint64_t odd_starts = backslashes & even & ~follows;"),
 ("escaped-start-kept", "_mm512_set1_epi8('\\\\')) & ~carried;", "_mm512_set1_epi8('\\\\')) & ~(carried >> 1);"),
 ("escaped-no-follows", "const uint64_t escaped = (even ^ (sum << 1)) & follows;", "const uint64_t escaped = (even ^ (sum << 1)) & (follows | 1);"),
 ("escaped-parity", "const uint64_t escaped = (even ^ (sum << 1)) & follows;", "const uint64_t escaped = (~even ^ (sum << 1)) & follows;"),
]
import sys
p = sys.argv[2]; s = open(p).read()
for n, a, b in M:
    if n == sys.argv[1]:
        assert s.count(a) == 1, (n, s.count(a)); open(p, "w").write(s.replace(a, b))
