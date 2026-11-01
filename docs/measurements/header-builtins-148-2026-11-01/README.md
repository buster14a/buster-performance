# x86 header builtins on the 9700X (buster #148, buster#1040)

buster#1040 compiles the x86 builtins that clang's headers declare (`_mm_sfence`, `_mm_getcsr`, `_m_prefetch` and
the others in `<x86intrin.h>`). A call of one stays the builtin under a declaration with external linkage, as clang
keeps it. This record measures what the declaration check costs units that call none of these builtins, and the fix
for the cost it first had.

## Trees

Each tree is a `git archive` of its commit, built with `BUSTER_DEBUG_INFO=0 ./build.sh`.

| tree | commit |
| --- | --- |
| base | `b823d1c` (main) |
| first head | `de4b645` |
| head | `f482e51` |

`scripts/hb.c` calls five header builtins. On the 9700X, `f482e51`'s build of it prints `1f80`, as clang -O0's does.
`b823d1c` refuses it: `_mm_sfence` is an undefined reference.

## Method

`scripts/measure.sh base head` is buster-performance#186's harness, each run one hold of the host's lock.

1. A drive of each tree, which compares the objects.
2. 8 rounds. In each, every tree compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`,
   pinned to CPU 2, with the order of the trees alternated by round.

The units are the frozen `sqlite3.c` with the 9700X job's options and stb_image with `-march=native`, both with `-c`.
`scripts/analyze.py runs/RUN/measure-UNIT.log base head` gives medians of the rounds' means. In both runs, all 48
runs per unit exited with status 0, and both trees wrote identical objects for both units.

## Results

| head | `sqlite3.c` instructions | `sqlite3.c` cycles | stb_image instructions | stb_image cycles |
| --- | ---: | ---: | ---: | ---: |
| `de4b645` | +1,563,713 (+0.111%) | +0.04% | +177,537 (+0.090%) | +0.02% |
| `f482e51` | +416,285 (+0.030%) | −0.14% | +58,577 (+0.030%) | −0.95% |

Instruction counts are deterministic here: the rounds' spreads are tens of instructions in `sqlite3.c` and about a
thousand in stb_image. The cycle and time differences stay within the rounds' own ranges.

### The bisect

`de4b645`'s increase was found by a bisect (`scripts/bis.sh`, `runs/bisect/status`). It used one `instructions:u`
count per tree, for both units:
- `vA`: `3dcb96b` with `c_check_input.c` and `c_check_intrinsic_input.c` reverted to `b823d1c`. It counts as base,
  within 5,000 instructions.
- `vB`: `3dcb96b` with the new names reverted (the supplementary scope, the helpers and the leaves). It counts as
  `3dcb96b`.

The cause was the pre-check. Before it, the reader looked up an operand's binding only when the unit had an intrinsic's
name (`reader->intrinsic_names`). The pre-check looked it up for every operand. `f482e51` restores the condition.

The remaining +0.03% is about one instruction per operand in the checker's reader. It is the same in both units. It
was not attributed further.

## Tests

`tests/f482e51.status` (`scripts/q.sh`) and `tests/de4b645.status` (`scripts/de4b645.sh`) hold the heads' tests on
the 9700X, each in a hold of its own:
- `test-checker --program-vectors`, which runs the header-builtin fixtures against clang -O0;
- `test-checker --seed 133`, `test-checker-deferred`, `test-checker-driver`;
- `test-check-builtins`, `test-builtin-intrinsic-catalog`, `test-x86-semantics --cross-check`;
- the call graph check.

Every one passed.

A third head, `3dcb96b`, was measured too, but its tree on the host held `b823d1c`'s sources apart from one test file.
That run, and its tests, are not part of this record.
