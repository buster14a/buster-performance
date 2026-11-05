# Generic builtins of an instruction or two on the 9700X (buster #148)

The buster commit measured here adds fifteen of clang 23's generic builtins:
- eleven leaves (`__builtin_debugtrap`, `readcyclecounter`, `readsteadycounter`, `thread_pointer`, `stack_address`,
  `dwarf_sp_column`, `__builtin___clear_cache`, the two `assume_*`, `memcpy_inline` and `memset_inline`);
- four miscellaneous builtins of clang's own checks (`classify_type`, `eh_return_data_regno`, `dwarf_cfa` and
  `launder`).

The commit was measured as `0bb0d71`, on top of `f482e51`. The same change was then rebased twice without changes to
its diff: onto `aeac247`, and onto main after #1040 merged, as `b765801`.

## Method

`scripts/measure.sh base head` is buster-performance#186's harness, run in one hold of the host's lock.

1. A drive of each tree, which compares the objects (`runs/measure.log`).
2. 8 rounds. In each, every tree compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`,
   pinned to CPU 2, with the order of the trees alternated by round.

The units are the frozen `sqlite3.c` with the 9700X job's options and stb_image with `-march=native`, both with `-c`.
`scripts/analyze.py runs/measure-UNIT.log tf482e51 t0bb0d71` gives medians of the rounds' means. All 48 runs per unit
exited with status 0, and both trees wrote identical objects for both units.

Neither unit calls these builtins, so the numbers measure what the larger catalogue, scope and leaf tables cost code
that doesn't use them.

## Results

| unit | instructions | cycles (median of rounds' ratios, range) |
| --- | ---: | ---: |
| `sqlite3.c` | −3,298 (−0.0002%) | +0.56% (−0.33% to +0.94%) |
| stb_image | −1,316 (−0.0007%) | +0.28% (−0.53% to +3.18%) |

The objects and the instruction counts are unchanged. The cycle differences stay within the rounds' own ranges, and
are consistent with code placement rather than a cost of the change.

## Tests

`tests/0bb0d71.status` (`scripts/q.sh`) holds the head's tests on the 9700X, each in a hold of its own. Every one passed:
- `test-checker --program-align`, which runs the new source fixtures and native programs against clang -O0;
- `test-check-builtins-misc`, `test-builtin-intrinsic-catalog`, `test-check-builtins`;
- `test-checker --program-vectors`, `--seed 133`, `test-checker-deferred`, `test-checker-driver`;
- `test-preprocessor --clang`, `test-x86-semantics --cross-check`;
- the `-Wall -Werror` check of the compiler's own `main.c`, and the call graph check.

The `self-check` line's tail is another job's lock-owner note, printed by the lock while it waited; its status is 0.
