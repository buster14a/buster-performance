# The executable writer's exact twins (#2924, linker group, piece 3)

The third piece of the linker and executable group
([claim](https://github.com/buster14a/buster/issues/2924#issuecomment-7113415815)): `ExecutableOptions.exact`, which
made the executable writer take each pass's exact twin (the symbols' classes one at a time, the stubs, the GOT, the
relocations, RELR and the unwind tables' count and entries by a walk, and the `.eh_frame_hdr` table's forced sort),
and which the checker's `--scalar`, the tests and `benchmark-executable --exact` selected. The owner's rule 2 applied:
the vector unwind-table count lost to the walk at a dozen FDEs, so it was made faster first. Base is main
`68cc356a4`. The experiments were applied as [`scripts/exe1.patch`](scripts/exe1.patch) and
[`scripts/exe2.patch`](scripts/exe2.patch) in `~/buster-fast-bench/2924-linker/exe` on the 9700X, against main with the
benchmark's repeats ([`scripts/exebench.patch`](scripts/exebench.patch), `exe-main/`); head is the branch
`claude/2924-linker-3` (`hexe/`). Release, every run under `exclusive.sh` ([`scripts/run.sh`](scripts/run.sh)), timings
on CPU 2.

## Classification

- `ExecutableOptions.exact` and `ExecutableShared.exact`, with every arm they chose, `executable_is_outside` and
  `executable_symbol_range`: twins. `c_checker_driver.c` set the option from the checker's `--scalar`.
- The unwind tables' walk stays: the vector count and entries fall back to it for an atom whose records they can't
  take in groups (data-selected, phase D), and `benchmark-executable` times it as that fallback.
- `foreign_driver.c`'s own exact symbol order (`foreign_driver_symbols_exact`) stays for piece 4, which deletes
  `FOREIGN_PATH_EXACT`: the driver keeps a `bool exact` of its own, from its path, until then.

## The gate: `benchmark-executable` at main

Both paths, 2 rounds each, at 1, 2, 8, 64, 2,000 and 180,000 workers
([`logs/gate-exe-small.log`](logs/gate-exe-small.log), [`logs/gate-exe-large.log`](logs/gate-exe-large.log),
[`scripts/gate-exe.sh`](scripts/gate-exe.sh)). Whole writes (every output kind, in place, to a new file and replacing
one): main's exact over vector 1.09 to 1.71, the vector path faster in all 108 rows. The unwind tables' count lost:
8.18 ns an FDE against the walk's 7.27 at 11 FDEs, and 7.50 against 6.67 at 12. At 18 FDEs the two were about even
(5.00 against 5.00 to 5.56), and from 74 the vector count won 1.9 to 3.1 times.

## What made the vector count faster

1. `8777382ef`: `executable_eh_frame_fdes` stored each candidate's 8-byte head to the stack and loaded a group's 16 as
   two vectors, which no store forwards to. The heads are now gathered from the candidates inside the atom.
2. `f66158ef0`: a group of 8 or fewer issues no second gather.
3. `f7c8e5811`: `benchmark-executable` repeats the unwind tables' passes to about 4,096 FDEs, past the clock's
   resolution, which at 11 FDEs had rounded both paths to a few values.

The count and entries against main's walk, with the repeats on both sides, medians of 5 rounds in alternating
processes ([`logs/ab-exe2.log`](logs/ab-exe2.log), [`scripts/ab-exe2.sh`](scripts/ab-exe2.sh); ns an FDE):

| FDEs | Count: main's walk | Main's vector | Head | Walk / head | Entries: walk / head |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 11 | 5.107 | 6.464 | 4.769 | 1.07 | 1.50 |
| 12 | 4.875 | 5.981 | 4.424 | 1.10 | 1.54 |
| 18 | 3.930 | 4.190 | 2.991 | 1.31 | 1.85 |
| 74 | 3.047 | 1.484 | 1.152 | 2.64 | 3.38 |
| 2,010 | 2.113 | 0.693 | 0.605 | 3.49 | 3.30 |

[`logs/ab-exe1.log`](logs/ab-exe1.log) is the first experiment, without the repeats.

## Head against main's exact path, whole writes

`benchmark-executable --only K` for each output kind K (the links' own set, the dynamic PIE with its TLS probes, the
static executable, the static PIE and the shared library), at 1, 2, 8, 64 and 2,000 workers: main's build with
`--exact` against head's in alternating processes, medians of 3 rounds ([`logs/ab-hexe-*.log`](logs/),
[`scripts/ab-hexe.sh`](scripts/ab-hexe.sh)). Main's exact time over head's:

| Output | Rows | Lowest | Highest |
| --- | ---: | ---: | ---: |
| links | 90 | 1.085 | 1.776 |
| dynamic PIE, with the TLS probes | 50 | 1.205 | 1.771 |
| static executable | 10 | 1.184 | 1.364 |
| static PIE | 10 | 1.323 | 1.616 |
| shared library | 10 | 1.175 | 1.421 |

Head is faster than main's exact path in all 170 rows. The lowest is the smallest link written to a new file.

## Same output

Lua 5.4.8's interpreter (every `.c` but `luac.c`, `-O0`, `-lm`) linked by main and by head as a dynamic PIE, `-static`,
`-static-pie` and `-no-pie`, by default and with `--scalar` (which chose the exact twins at main): each executable is
the same bytes as main's, and each runs and prints `42 a,b` ([`logs/exes-compare.txt`](logs/exes-compare.txt), the
`exes-*.log` files; the script is piece 2's [`exes.sh`](../c-linker-bind/scripts/exes.sh)).

## Tests and mutation

The deletion removed the tests' comparisons of the exact twins' files with the vector path's, rather than leaving a
path compared with itself. What carries the semantics: each test's own reading of the files it writes (headers,
segments, dynamic section, relocations, RELR, symbols and unwind tables, against the test's rules), every lane count's
write reproducing the same bytes over poisoned scratch memory, `--cross-check`'s comparisons with GNU ld and lld, and
the executables the tests run. `static_test.c` keeps two more writes with 1 and 8 lanes, permuted names and poison,
against the first file.

11 mutants of the vector code in `executable_impl.c` ([`mutation/mutants.txt`](mutation/mutants.txt),
[`mutation/run.sh`](mutation/run.sh)), each built in Release and run against `test-executable`, `test-dynamic`,
`test-static`, `test-snapshot`, `test-debug` and `test-foreign` ([`mutation/results.txt`](mutation/results.txt)). 8 are
killed. 3 survive, each rebuilt and rerun one at a time on the branch's head with the same result
([`mutation/rerun.sh`](mutation/rerun.sh), [`mutation/rerun-results.txt`](mutation/rerun-results.txt)):

- 7 (no atom taken as dense for RELR) is equivalent in output: a dense atom is a fast path, and the general
  classification of its fixups gives the same words.
- 2 (a shared library's TPOFF class not excluding the linker's symbols) changes only a TLS symbol the linker defines,
  which the writer's symbol table refuses (`boundary_tls`) and no test links.
- 5 (symbol 1 never an IFUNC's IRELATIVE slot) changes only a link whose first symbol is an IFUNC with a GOT slot and
  no stub, which no test has.

The exact twins' comparisons ran the same inputs, so they could not see 2 or 5 either.

## Checks

- On the 9700X, the 9 blocks of `tools/ci/correctness.tests` that name `test-executable`, `test-dynamic`,
  `test-static`, `test-snapshot`, `test-debug`, `test-foreign`, `test-link` and `test-unwind` pass through `parallel` on
  head ([`logs/p3-tests.log`](logs/p3-tests.log): 9 passed, 0 failed).
- `test-executable`, `test-dynamic`, `test-static`, `test-snapshot` and `test-debug` pass under
  `BUSTER_SANITIZER=undefined`, `address` and `memory` builds.
- `./build.sh check-call-graph --config Release` finds 0 cycles.
