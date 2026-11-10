# The driver suite in-process and through a clang server (buster#2071), 2026-11-10

These are the measurements behind buster PR #2072's generalization. Every buster run and every oracle-clang run that
`test-checker-driver`'s shared helpers make goes in-process (`--in-process`) and through `tools/clang-server`
(`--clang-server`). `--differential` runs each both ways and compares. This follows
`in-process-tests-2071-2026-11-10`, which covered the warning sweep alone. All runs were on an AMD Ryzen 9 7940HS laptop
(Zen 4) with the distribution's clang 23.1.4, each through the laptop's `cores` queue. The sanitizer runs used CI's
options with transparent huge pages disabled (`scripts/nothp.c`). `trees.txt` names the executables' sources and
hashes.

## Equivalence (`scripts/inproc-diff.sh`, `results/differential/`)

All 16 parts, `--sign-compare-only` and `--lazy-system-headers` ran with `--in-process --clang-server --differential`,
plain: about 54,900 in-process buster runs and 15,560 served clang runs, with 0 differences. The comparison is byte for
byte, except in `--time-stages` and `--lane-cpus` runs: those skip report lines with a numeric value (times, faults,
sizes, the lanes that worked) and compare the rest in any order. Part 14's 4 `asm placed` failures are this laptop's:
main's plain build has them too.

CI then found one gap these runs missed: the huge-pages check changes process-start inputs between runs. The skip of
`time-process` report lines had hidden it here, since `huge-pages off` against `system` is text, not a number. The fix
sends a run with different start inputs to a child and compares textual report lines.
`results/differential/verify-part4-after-start-inputs.log` is part 4 after it: 0 differences and 0 failures.

## Timing (`scripts/time16.sh`, `results/timing/`)

Each part ran as children and in-process plus server at the same time on two cores. The sums are of the parts' walls.

| | Children | In-process + server |
|---|---:|---:|
| Plain, all 16 parts | 333.4 s | 156.0 s |
| Plain, part 6 | 69.8 s | 29.1 s |
| `address`, all 16 parts | 3,189.5 s | 416.1 s |
| `address`, part 6 | 762.5 s | 85.0 s |
| `address`, part 15 | 489.4 s | 41.2 s |

In the `address` run, part 4 fails in both modes. Its child mode fails "--time-stages with the functions on two lanes",
a failure of this laptop's ASan build. Its fast mode also fails the huge-pages check, because that executable predates
the start-input fix.

## Limitations

- One laptop. On the hosted runners' official LLVM release the server can't hold a single copy of LLVM (no exported
  target initializers in `libclang-cpp`), so those rows run the oracle clang as children: their gain is buster's alone.
- The plain timing's executable predates the rebase and the start-input fix; the `address` one predates the fix.
