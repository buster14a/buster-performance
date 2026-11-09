# Undeclared names in the constant walk, Buster #1447: error-free -fsyntax-only, base vs head

Compiler issue: [#1447](https://github.com/buster14a/buster/issues/1447). Compiler PRs, stacked in this order:
[#1864](https://github.com/buster14a/buster/pull/1864), [#1885](https://github.com/buster14a/buster/pull/1885),
[#1900](https://github.com/buster14a/buster/pull/1900) and [#1914](https://github.com/buster14a/buster/pull/1914).

- **Base:** main `4842317c1` (the stack's merge base at the time).
- **Head:** `996da335` (the stack's tip, #1914's head then: all four PRs on that main, with #1884 merged in).
  Later heads add merges of main and a diagnostic's location fix, which code the measured units don't run.

The change reports and recovers undeclared names in declarators' constants (enumerator values, bit-field widths, array
bounds, `typeof` operands, `_BitInt` widths, designators). An error-free unit runs only a few more stores and branches
per constant reading, and `check_input_record_names`' one kind test per unnamed member.

## Host and method

- **Host:** the Ryzen 7 9700X (`benchpress`), CPU 2 (governor `performance`), THP `always`, kernel 6.18.50-2-lts
  (`host.txt`, whose clang is the host's own, unused here).
- **Binaries:** both built in a cloud container with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`
  (clang 23.1.6), then copied to the host, at the coordinator's request to keep builds off the 9700X. Their SHA-256s
  are in `host.txt`.
- **Run:** one lock hold (`time.sh`, `exclusive.sh` around one `time-runs` process, pinned with `taskset -c 2`), at
  the coordinator's direction to keep each session to a single short hold.
  - 2 warm-ups, then 15 runs per build and input, in `time-runs`' Williams order.
  - Inputs: `-fsyntax-only` of sqlite3.c (amalgamation, SHA-256 in `host.txt`), and of the base's
    `src/buster/compiler/main.c` with the self-compile flags, both builds compiling the same file.
- **Raw output:** `time.txt`, every run's wall time, rusage, user cycles and instructions.

## Results

| Input | Base median wall | Head median wall | Δ wall | Δ user cycles | Δ instructions |
|---|---|---|---|---|---|
| sqlite3.c | 95.167 ms | 94.944 ms | -0.23% | -0.42% | +0.05% |
| main.c | 2961.155 ms | 2947.291 ms | -0.47% | -0.38% | +0.03% |

One base run of main.c (run 8, 3445 ms, with 990k minor faults against the others' 75k) is an outlier the medians
leave aside. The wall-time differences are within the runs' spread (sqlite3.c: base 94.347–96.330 ms, head 94.475–97.358 ms;
main.c: head 2935.3–2958.3 ms). Instructions grow by 0.03–0.05%, which is the added per-reading work. No regression
is measurable on these inputs.

This is a single-layout measurement of each binary, not a multi-layout comparison.
