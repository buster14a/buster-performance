# C12b: the parser's twins deleted (#2924)

The parser keeps its vector path alone, with its fallbacks: the kernels' twins, the whole-unit scalar mode, the
handoff's twins, the scope numbers' scalar arm and the GNU records' scalar candidates are gone. The gate is
[`../c-parser-gate`](../c-parser-gate).

## Setup

[`run.sh`](run.sh): head `3c7e1f62b` (the deletion) against base `47470d099` (the tests commit, the twins present), both
on C12a's `5afd0cb8c`, Release, 9700X, every run under the lock, timings on CPU 2. Since then the tests commit gained a
snippet (from mutant m4 below) and both commits were rebased onto #3021's merge (`4d59a0ba7` and `132169aca`): the
compiler's code is the same. [`probe.sh`](probe.sh) and [`probe2.sh`](probe2.sh) look at two numbers below, and
[`probe3.sh`](probe3.sh) times the benchmarks again on the final deletion `eabcc8416` (head2), whose two benchmark fixes
leave the compiler's own code as it was. Everything is in [`logs.tar.gz`](logs.tar.gz) (`logs/`, `probe/`, `probe2/`,
`probe3/`); [`ab_parse.py`](ab_parse.py) summarizes `ab`'s rounds.

## Outputs

- **Objects:** byte-identical. `-c` (Tier 0) and `-c --tier1` of sqlite3.c, Lua's units, musl's units and buster's
  `main.c`: 1,372 of 1,372 each.
- **`parse -fsyntax-only`'s output** of sqlite3.c and of buster's `main.c` (complete driver): the same.

## Whole compiles

`ab`, three rounds, around `time-runs` (three runs of three copies) of base, head and base again. User cycles against base:

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| `parse -fsyntax-only` sqlite3.c | −0.02%, +0.05%, −0.28% | −0.04%, −0.01%, +0.16% | 0.156 M fewer |
| `parse -fsyntax-only` buster's `main.c` | +0.27%, −0.05%, +0.65% | +0.21%, −0.18%, +0.27% | 0.888 M fewer |
| `-fsyntax-only` Lua's units | +0.01%, −0.13%, +0.22% | +0.00%, −0.14%, −0.04% | 0.12 M fewer |
| `-fsyntax-only` musl's units | −0.08%, −0.21%, +0.14% | +0.22%, −0.06%, +0.05% | 1.15 M fewer |
| `-c` sqlite3.c | +0.82%, +0.59%, +0.66% | +0.24%, +0.10%, +0.12% | 0.166 M fewer |
| `-c` musl's units | +0.06%, +0.09%, +0.16% | +0.05%, −0.07%, +0.02% | 1.17 M fewer |

`-c` of sqlite3.c reads +0.4% to +0.6% against base again, though its parse alone reads the same. `perf stat` in an ABBA
order (`probe/perf-*.log`, ten runs each): head +0.4% cycles, 166 K fewer instructions, the same page faults and iTLB
misses, and 41 K more branch misses (+1.3%). By symbol (`probe2/`, five runs each at moving periods), the difference is
spread over the checker's functions, whose code this change leaves as it was: `check_lower_drain` +0.46 points of the
cycles and +0.65 of the branch misses, others moving either way by up to 0.3, and no parser function among them. It is
where this executable's code lies, not the parser's work.

**C12a and C12b together** ([`probe4.sh`](probe4.sh), `probe4/`): main before C12a (`a847fd0e6`) against the final
deletion, `ab`'s three rounds. `-c` of sqlite3.c: +0.51%, +0.52%, +0.60% (main again +0.09%, −0.21%, +0.14%), with
0.55 M fewer instructions; its parse alone: +0.45%, +0.10%, −0.49% (main again +0.00%, −0.12%, −0.61%), 0.47 M fewer.
Each step alone read +0.4% to +0.6% on `-c` of sqlite3.c; together they read the same, not the sum.

**The start section** (`logs/start-*.txt`): head has `parse_vector`, which the start order now names, and no longer
`parse_fallback` and `parse_convert_token`, both inlined into functions there now.

## The benchmarks

`benchmark-parser` on `3c7e1f62b` (`logs/bench-*`), cycles a token, three rounds each of base, head and base again:

| Row | `main.c` base | head | base again | sqlite3.c base | head | base again |
| --- | --- | --- | --- | --- | --- | --- |
| input | 2.46–2.47 | 2.33–2.34 | 2.41–2.47 | 0.72–0.79 | 0.65–0.78 | 0.71–0.85 |
| handoff | 3.67–3.68 | 3.52–3.56 | 3.65–3.66 | 1.05–1.14 | 0.99–1.07 | 1.06–1.16 |
| vector | 36.84–36.85 | 36.95–37.11 | 36.65–36.93 | 27.79–28.41 | 27.88–28.54 | 27.82–28.01 |

There the vector row retired 0.68 more instructions a token on head (64.41 against 63.73 on sqlite3.c). `probe/stages-*`:
it was K6 (+0.63), in the benchmark's own copy of the parser, where the compiler inlined K6's block fallback
(`parse_check_range`) into K6's block loop once `parse_check_scalar` no longer called it; the compiler's own copy kept it
out of line. And `benchmark-gnu` timed the vector collection right after the parser-with-gnu path's parse, whose arrays
leave the reference's cold, where base had timed it right after the scalar collection, which warmed them: head's
collection read 0.68 to 0.70 cycles a token on sqlite3.c against base's 0.21.

The final deletion makes `parse_check_range` `noinline` and runs the collection and the build once untimed before timing
each. `probe3/`, three rounds of base, head2 and base again:

- **The vector row:** head2 retires 63.83 instructions a token on `main.c` and 63.78 on sqlite3.c, against base's 63.78
  and 63.73. Cycles a token: `main.c` 37.09, 37.31, 37.35 against base's 36.90, 36.78, 36.67 and base again's 36.66 three
  times (+1.1%); sqlite3.c 28.03, 27.93, 27.79 against 29.02, 27.85, 27.95 and 27.77, 27.84, 27.83.
- **The stages on `main.c`**, median cycles a token (instructions): K6 10.13 (16.26) against base's 10.11 (16.26); K1
  2.39 against 2.55, K4 7.23 against 7.43; the fallback 1.46 against 1.26; the tree's columns and the postorder
  12.49 and 14.09 against 12.06 and 13.66 (base again 12.16 and 13.96). The whole parse of `main.c` above reads within
  base again's spread.
- **`benchmark-gnu`,** cycles a token: sqlite3.c's collection 0.189 to 0.192 against base's 0.207 to 0.213, its build
  0.326 to 0.329 against 0.376 to 0.381; `main.c`'s collection 0.167 to 0.364 and build 0.275 to 0.320, against base's
  0.182 to 0.427 and 0.311 to 0.363 (and base again's 0.202 to 0.448 and 0.352 to 0.426).

## Tests on head (9700X)

All pass: `test-parser` (and `--clang`, and `--clang` on `main.c`), `test-gnu --clang`, `test-files` three ways,
`test-lexer`, `test-call-graph`, `check-call-graph`, the complete driver's `parse`, `-fsyntax-only -Wall -Werror`,
`--verify -c` and `--scalar --verify --lower-all -c` of `main.c`, and the ownership check.

## Sanitizers

[`sanitizers/`](sanitizers): MSan and ASan (vector host, Release) of the rebased deletion before the benchmark fixes,
all clean: `test-parser`, `test-gnu`, the complete driver's `parse` of `main.c`, `test-files` and `test-files --flat
src`. TSan, clean: `test-files` and `test-files --flat src`, whose lanes parse.

## Mutants

[`mutation/`](mutation): each mutant built in an archived copy of the tree and checked against `test-parser` (from the
tree's root, for its digests) and `test-gnu`.

- **Killed (13):** K1's last open opener of a block (m1); K1's deep-block walk's enclosing openers (m13, on the final
  deletion); K3's lane 63 (m2); K2's per-block loop's typed state (m3); the
  after-colons pass at a later block's first lane (m4, once the tests commit's new snippet put a `{` there; it survived
  the first round); K4's deep fallback's right-side resolution at equal thresholds (m6b); K5's carried class (m7); K5's
  statement stack at a do's `;` (m8); K6's block fallback's frames (m9); the function roles' lane 63 (m10); the
  handoff's `::` (m11); the GNU records' asm labels (m12); and K4's 16-bit parts left unsplit (m5c, by a crash).
- **Equivalent (2):** m5, a 16-bit part of 2 tokens taken whole (two tokens span at most one depth, which always fits:
  an opener raises a token's node depth by one, a closer lowers it by one, `:` included, and a chain of ternaries in
  else position stays at one depth, as `test-parser --print-tree` shows);
  m6, K4's deep fallback popping equal keys (a later token pops two equal keys together or neither, so no parent can
  differ).
- **Survived (1):** m5b, a 16-bit part of 8 tokens taken whole. Eight tokens span at most 7 depths, and a byte holds
  their keys (7 × 32 + 31) but for a right threshold one past the highest level: only such a role at the part's top
  depth would show it, and no input has one.

## Open PRs

[`open-prs/`](open-prs): each open PR that touches the parser's files (#2923, #2920, #2915, #2908, #2989) merged onto
the final deletion (`git merge-tree`) and run through `test-parser`. #2923 passes every check but changes the
alignments batch's digest (its recovery's diagnostics); #2920, #2915 and #2989 give all three digests; #2908 conflicts
with main in the node census files and doesn't build merged.
