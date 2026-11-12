# The node machine's census: step 0 of buster#2524 (2026-11-12)

[buster#2524](https://github.com/buster14a/buster/issues/2524)'s design (`docs/node-machine.md` in buster) builds a
machine that takes a full expression from the parser's tree to Tier 0's typed entries in one visit per node, and takes
an expression only when it has proved that the pipeline would report nothing for it. Its step 0 is a census: the
machine's set and its silence tests evaluated on the pipeline as it is, for every full expression, with no machine. Its
gate: the set takes expressions holding at least 85% of `sqlite3.c`'s evaluated nodes and 75% of Lua's and musl's, and
the silence tests refuse under 3% of the nodes. This record is that census's run on the 9700X. It counts; it times
nothing.

- **Source:** buster `eb62e20f18233702c405596b464847b832162717` (branch `claude/clever-fermat-yjq9wz`, the census's pull request), built on the host by
  `./build.sh` (Release, the host's native target, znver5). `results/build.log` has the build and the executable's
  SHA-256. `results-da354120/` is the same run at the branch's first commit `da354120`, before the census counted a
  system header's macro apart (below); its counts are the same but for that line. `results-c1435396/` is the same run
  at the pull request's final commit `c1435396` (main merged in, every warning classified, tests for main's two new
  warnings): its counts are `results/`'s, with an `unmodeled-warning` row that refuses nothing.
- **Host:** the Ryzen 7 9700X (`benchpress`), each script's command in one hold of the machine's lock
  (`scripts/lock.sh`), pinned to CPU 2. `results/holder.txt` is the lock's own line for the census's hold.
- **The command:** `measure-node-machine --list 40` (buster's `c_check_node_census.c`, documented in
  `docs/commands/lowering.md`, "Node machine census (#2524)").
- **Workloads** (`scripts/census.sh`; `results/inputs.txt` has every input's hash):
  - the frozen corpus's `sqlite3.c` with the 9700X job's `compile_time` options (`-DSQLITE_OMIT_LOAD_EXTENSION
    -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, the system's headers);
  - Lua 5.4.8's 34 sources (`lua.c` and `luac.c` among them), the release's `src/`, the system's headers;
  - musl: the frozen corpus's first source of each base name, 1,336 units, with the options of the one-core record's
    `musl.sh` (`-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700` and musl's include directories).

## Results

`results/sqlite3.txt`, `results/lua.txt`, `results/musl.txt`. A full expression is a tree of the lowering's tasks' pops
under a root a statement's control pushed; its evaluated nodes are its pops (#1048's inventory's count).

| on the 9700X | `sqlite3.c` | Lua 5.4.8, 34 files | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| bodies lowered; full expressions; evaluated nodes in them | 2,668; 52,368; 266,707 | 1,096; 11,562; 67,358 | 2,756; 26,502; 131,092 |
| nodes in expressions the set takes (gate: 85%, 75%, 75%) | 260,139 (97.54%) | 61,223 (90.89%) | 121,957 (93.03%) |
| nodes the silence tests then refuse (gate: under 3%) | 0 (0.00%) | 16 (0.02%) | 1,625 (1.24%) |
| nodes taken | 260,139 (97.54%) | 61,207 (90.87%) | 120,332 (91.79%) |
| bodies taken whole, and their nodes | 2,338 (87.63%), 60.17% | 863 (78.74%), 55.36% | 1,675 (60.78%), 49.49% |
| nodes taken, by root: statements, conditions, returns, initializers | 98.40%, 95.57%, 98.18%, 97.74% | 92.89%, 83.13%, 98.12%, 98.45% | 93.89%, 95.94%, 87.25%, 93.44% |
| nodes of expressions with a system header's macro (counted apart) | 17,859 (6.70%) | 5,500 (8.17%) | 0 |

**The gate holds on all three.** The set's refusals, by the share of the nodes in the expressions each refuses (a test's
"any" count; an expression can have several):

- **`sqlite3.c`:** bit-fields 1.54%; callees with semantics of their own 0.38% (the library folds `strcmp`, `strlen`,
  `memcmp`, the printf family); builtins and `va_arg` 0.30%; struct copies 0.21%; brace initializers 0.04%; `register`
  variables 0.02%.
- **Lua:** builtins 4.51%, three quarters of those expressions `__builtin_expect`'s (`l_likely`, `l_unlikely`,
  `luaL_argcheck`) and the rest `va_start`, `va_end` and `va_arg`; the library folds 2.70%; other controls 1.05%; struct
  copies 0.85%.
- **musl:** values popped twice (compound literals') 3.23%; controls 1.89% (brace initializers, statement expressions'
  statements); complex values 1.62%; builtins 0.99%; struct copies 0.58%; callees 0.52%; flagged declarations 0.11%;
  bit-fields 0.06%.

The silence tests' refusals:

- **`sqlite3.c`:** none. It reports no warning, and no test refuses one of its clean expressions.
- **Lua:** one expression of 16 nodes, a comparison of a `size_t` with `MAX_SIZET/(e)` at its bound in
  `luaM_checksize`, which the conservative bound test refuses.
- **musl:** a floating-point pragma's bodies 0.84% (`fma.c` and its kin, by design); parentheses 0.43%, warnings the
  compiler reports (`if (map = __map_file(name, &map_size))`, `s[e]+0U<<24`, `nz.m>>64-d`); sizeof's and alignof's
  operands with an effect 0.09% (`isinf(creal(z))`'s `sizeof`, conservative: a `const` builtin's call has none);
  string plus int 0.05%, reported (`"["+!pid`); a discarded value 0.03%; comparisons at a type's bound 0.02%
  (`gid < 0` of an unsigned, `pos > LONG_MAX`, conservative).

## What the census found besides the counts

- **The design's system-macro test is dropped.** The design refused an expression whose tokens come from a system
  header's macro where its root's don't. Measured, that test refuses 6.5% of `sqlite3.c`'s nodes, more than the silence
  tests' whole budget (Lua's 7.7%): nearly all `assert`, whose expansion under `NDEBUG` is `<assert.h>`'s `((void)0)`. It isn't
  needed: in a system header's macro the pipeline only suppresses diagnostics, so an expression the other tests take is
  as silent there. The census counts such expressions apart (the reports' `system-macro (not a refusal)` line), and the
  design says so. `results-da354120/` predates that, and its census never saw such a token: the graph's per-token marks
  aren't kept on that path, and the census now reads the preprocessor's level at the token, as the common warnings do.
- **The silence tests are checked against the warnings they stand for.** buster's `test-checker` runs the census on a
  fixture with one warning a line (each reported by the compiler with `-Wall -Wextra`), which it must refuse by the test
  that stands for it; on clean idioms it must take; on the set's refusals; on warnings off by default (refusing nothing);
  and on a system header's macros. Disabling one test fails it.
- **The first tests were coarser than the warnings.** Before they were tightened, they refused 1.75% of `sqlite3.c`'s
  nodes, none of them a warning: discarded calls of `memset` and `memcpy` (only `const` and `pure` builtins warn),
  unsigned 64-bit constants, a conditional's two arms (never both evaluated), two fields of one struct written in one
  expression, `&a[N]`, same-width sign changes, comparisons with a constant outside the common type's range. musl's
  remaining parentheses and string-plus-int refusals are warnings the compiler reports there (`if (map =
  __map_file(...))`, `s[e]+0U<<24`, `"["+!pid`).

## Limits

- **Counts, not times.** Nothing here measures what the machine or its tests would cost; step 1 does.
- **The tests are the census's, not the machine's.** They read the finished graph, stream and parser's tree; the machine
  will make them from its records and the parser's tree before the graph exists. Rare warnings (a literal's escape, a
  deprecated use) are stood for by the reader's and graph's own warning events at the expression's tokens, which the
  machine replaces with tests of its own.
- **The set is the census's reading of the design's step 2** (calls, `&&`, `||` and `?:` in; builtins, bit-fields and
  the other exceptions out); the baked tables don't exist yet, so every combination of an operator and kinds that the
  corpora show is assumed to have its row.
- One host, one revision; the system headers are the host's (`sqlite3.c` and Lua include them).

## Files

- `scripts/`: `lock.sh` (the hold), `build.sh` and `census.sh`.
- `results/`: the build's log and the census's reports at `eb62e20f`; `results-da354120/` and `results-c1435396/` the
  same at `da354120` and `c1435396`. The lock's waiting messages, which name other sessions, are left out of the build
  logs.
