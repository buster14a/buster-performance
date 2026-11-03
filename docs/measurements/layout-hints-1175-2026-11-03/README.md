# The checker's rare tests and their layout (buster#1175)

This record holds exact taken-branch counts of the layouts of buster main and of buster#1225, which states the checker's
rare tests (`__builtin_expect`) and computes some without branches. It was made on 2026-11-03 in a cloud VM, not on the
Ryzen 7 9700X. The VM has no hardware PMU, so the counts are BOLT's instrumented edge counts, not hardware counters.

**Not covered: cycles.** buster#1175 keeps a change only when its taken branches and cycles fall over placements
(`time-runs --copies`, buster#509) on the 9700X. That measurement is still to be made, and nothing here stands in for
it.

## Sources, host and inputs

`logs/receipts.txt` has every identity. In short:

- **Sources.**
  - main: buster `96b6cbcd`; after the merge, also `8c9c5bf0` (below).
  - head: buster#1225's `a84d9823`.
  - first commit: `5182ca1b`, the same without `check_control_children`'s hint.
  - variants: `patches/` holds the variants' diffs against main (`git apply`).
- **Host.** An Intel Xeon (KVM) with 4 CPUs and no PMU. Its event sources are only `breakpoint`, `msr`, `software`,
  `tracepoint` and `uprobe`.
- **Toolchain.** clang 23.1.5 and bolt-23 23.1.5, both apt.llvm.org's.
- **Input.** buster's frozen `sqlite3.c` (`tools/ci/fetch-corpus.sh`, sha256 `0a409f16…`), with buster#136's options
  (`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`). Each count is
  of one process:
  - `-fsyntax-only`;
  - `-c --lanes 1`, since znver5's `mwaitx` (`lane_wait`) can't run on an Intel host.
- **Repetitions.** BOLT's counts are exact, and each count is of one run.
  - `-fsyntax-only` repeated main's totals exactly.
  - `-c` differed between two runs of main by 6 taken branches and 54 instructions (78,058,623 and 1,174,397,079 in an
    earlier run).

## Method

These are the steps for each executable (`scripts/measure.sh`):

1. **Build.** `scripts/build.sh` builds it with `BUSTER_HOST_ARCH=znver5`, through a clang wrapper that adds
   `-Wl,--emit-relocs` to the link alone (`scripts/wrap-relocs`). That changes no code; BOLT's instrumentation needs the
   relocations.
2. **Count.** `llvm-bolt -instrument -strict` writes an instrumented copy, which compiles the input and writes every
   edge's count (`profile.fdata`).
3. **Totals.** `llvm-bolt -strict -data=profile.fdata -dyno-stats` gives the totals of the original executable's layout
   (`dyno.txt`).
4. **Attribution.** `scripts/attribute.sh` runs `scripts/taken.c`, which joins `profile.fdata` with `llvm-objdump`'s
   instruction boundaries. An edge whose target isn't the next instruction is a taken branch, and a jump to another
   function is a tail call's (`totals.txt`, `edges.txt`). `llvm-symbolizer --inlines` attributes each one to its
   branch's innermost source line (`lines.txt`: taken, then the conditional branches' fall-throughs) and to its compiled
   function (`functions-taken.txt`).
5. **Sites.** `scripts/site.sh` adds a source function's lines up, wherever they were inlined (`logs/sites.txt`).

The counts exclude calls, returns and glibc's code, which `ex_ret_brn_tkn` includes.

**Two definitions of the total, reconciled.** `taken.c`'s total (`totals.txt`) counts four kinds of taken branch: taken
conditionals, unconditional jumps, jump-table jumps and tail calls' jumps. BOLT's `taken branches` (`dyno.txt`) counts
only the first two. It reports jump-table jumps as `taken jump table branches` and counts tail calls among its calls.
For main's `-fsyntax-only`:

| | `taken.c` | BOLT |
| --- | ---: | ---: |
| taken conditionals | 49,065,277 | 49,065,280 |
| unconditional jumps | 10,950,885 | 10,950,885 |
| jump-table jumps | 1,241,108 | 1,241,108 |
| tail calls' jumps | 202,927 | (a call) |
| total | 61,460,197 | 60,016,165 |

Head's matches the same way (36,155,574 against 36,155,577 taken conditionals; the other kinds exactly). The 3 taken
conditionals are among the records `taken.c` can't place (`unmatched` in `totals.txt`):

- the C runtime's start-up and tear-down functions (`_init`, `register_tm_clones` and the like), whose symbols have no
  size: 6 events;
- calls through the PLT to glibc, whose targets have no symbol: all the rest, 248,513 events on `-fsyntax-only` and
  389,230 on `-c`. These are calls, not branches, and BOLT counts the same 248,513 as `PLT calls`.

A first version of `taken.c` named a function's copies in the symbol table's order. BOLT numbers a function's local
copies by address and leaves a global symbol's name plain, so 147,684 events of five functions were dropped as
unmatched: `c_tokenize_scalar_range`, `arena_push`, `parse_translation_unit`, `pp_parse_options` and `c_tokenize`. Those
are the lexer's, the arena's, the parser's and the driver's, so no checker site moved. The fix raised main's and head's
totals by the same 35,653; the logs here are the fixed version's.

**Why `-fno-pie`.** BOLT can't follow `check_input_run`'s PIC jump tables in the PIE code buster's build compiles: two
are based on a register loaded outside the block (`failed to post-process indirect branches`). Without `-strict`,
BOLT marks the function non-simple; with it, BOLT still leaves the function uninstrumented. So the record's builds use
`scripts/wrap-nopie`, which compiles `-fno-pie`, whose jump tables are absolute.

On main, the PIE build (`logs/main-pie-fsyntax`) and the `-fno-pie` build (`logs/main-fsyntax`) counted the same
taken branches in every function both instrumented. Most were exact; `check_graph_region_postorder` was -1.3% and
`pp_run_contexts` -1.0%. `check_input_run` adds 6.25 M in the `-fno-pie` build alone.

**Cross-check.** The counts agree with buster#880's LBR samples on the 9700X (`pgo-port-880-2026-11-02`), which were
of `3ce71ec3`'s source:

| function | this record | #880's samples |
| --- | ---: | ---: |
| `check_input_resolve_range` | 8.34 M | 8.4 M |
| `check_graph_run` | 7.98 M | 8.6 M |
| `check_input_run` | 6.25 M | 6.5 M |
| `check_graph_region_postorder` | 2.35 M | 2.5 M |

**Bias.** Each test's bias came from clang source coverage of main's `-fsyntax-only`
(`logs/coverage-branches-main-fsyntax.txt.gz`). The build used `scripts/wrap-coverage` with `BUSTER_BAKE=0`; its
`-mno-sse4a` avoids an `insertq` this host lacks. A file included by several units has a line per instantiation, which
sum.

**The hint probe.** `scripts/probe-expect.c` (`logs/probe-expect.s`: `clang -O3 -march=znver5 -S`) shows the rule the
changes follow. A `__builtin_expect` around a chain of `&&` leaves the chain's first test's branch taken on the common
path (function `a`); a hint on that first test makes it fall through (`b`, `c`).

## Results

| sqlite3.c | | main | head | change |
| --- | --- | ---: | ---: | ---: |
| `-fsyntax-only` | taken branches (`taken.c`, `totals.txt`) | 61,460,197 | 46,499,018 | -24.3% |
| | BOLT's taken branches (`dyno.txt`) | 60,016,165 | 45,062,722 | -24.9% |
| | instructions (`dyno.txt`) | 888,462,803 | 876,767,990 | -1.32% |
| `-c --lanes 1` | taken branches (`taken.c`) | 80,007,535 | 63,737,767 | -20.3% |
| | BOLT's taken branches | 78,058,629 | 61,796,597 | -20.8% |
| | instructions | 1,174,397,133 | 1,162,192,207 | -1.04% |

- **Objects.** `-c`'s objects of `sqlite3.c` and of buster's `main.c` are byte for byte main's (`logs/receipts.txt`).
- **Sites.** `logs/sites.txt` has each site. For example:
  - `check_input_resolve_range`'s own lines: 6.62 M to 1.19 M;
  - `check_graph_node_action`: 1.26 M to 0.17 M;
  - `check_input_expression_values`: unchanged (below).

**The first commit,** `5182ca1b` (`logs/first-commit-*`), left out `check_control_children`'s hint:

| | first commit | head |
| --- | ---: | ---: |
| `-fsyntax-only` instructions | 879,530,939 | 876,767,990 |
| `-c` instructions | 1,164,955,147 | 1,162,192,207 |
| `-fsyntax-only` taken branches | 45,067,748 | 45,062,722 |

The hint's 2.76 M fewer instructions are the same in both modes, with the same taken branches. The loop's back edge
takes the jump its test took, and the iteration runs fewer instructions. So head keeps it.

**The variants** of `check_input_expression_values`. Its children have values 57% of the time, and 29% of those
follow another's.

- **v2** (`patches/v2-selects.patch`): selects. Clang made a branch of them again, since their arms were loads, and
  split the link's test in two. The function's own lines took 1,166,936 taken branches, against main's 1,013,291
  (`logs/v2-selects-fsyntax/lines.txt`, lines 74, 79 and 84 of that source).
- **v3** (`patches/v3-link-pointer.patch`): a pointer to where the next chain's first value goes. Clang made the
  conditional store a branch again: its own lines took 1,013,291 taken branches, main's exactly.
- **v4** (`patches/v4-candidate.patch`): head's code with main's version of the function.

A third form, a sink slot past the nodes, was dropped without a build: lanes share `value_next`, so they would race on
the slot.

## After merging main: against `8c9c5bf0`

buster#1225 then merged main `8c9c5bf0`, whose compiler changes include the coded walk's (its counters and clock
moved into the visit's branch). The comparison was measured again, with the same method:

- **main:** `8c9c5bf0`;
- **merge:** `cdfef9a2`, the merge as it came;
- **final:** `d9d9d32f`, the PR's head.

The final head drops the coded walk's visit hint. With main's counters in that branch, the hint cost 18,938 taken
branches: the merge took 45,063,783 and the final head 45,044,845. All of the difference is
`check_input_expression_coded`'s, 3,584,773 to 3,565,835. The executable measured was `a6405c80`; `d9d9d32f` changes
only the words of a comment, on the same lines.

| sqlite3.c | | main `8c9c5bf0` | final | change |
| --- | --- | ---: | ---: | ---: |
| `-fsyntax-only` | taken branches (`taken.c`) | 59,986,187 | 45,044,845 | -24.9% |
| | BOLT's taken branches | 58,558,159 | 43,624,553 | -25.5% |
| | instructions | 883,968,951 | 871,504,997 | -1.41% |
| `-c --lanes 1` | taken branches (`taken.c`) | 78,533,500 | 62,277,031 | -20.7% |
| | BOLT's taken branches | 76,600,598 | 60,351,865 | -21.2% |
| | instructions | 1,169,605,088 | 1,156,770,046 | -1.10% |

`-c`'s objects of `sqlite3.c` and `main.c` are byte for byte main's. The logs are in `logs/main-8c9c5bf0-*`,
`logs/merge-cdfef9a2-fsyntax` and `logs/final-*`, and the receipts at the end of `logs/receipts.txt`.

**Sites.** `logs/sites-8c9c5bf0.txt` has each site's own lines. Most sites are unchanged from main `96b6cbcd`'s
numbers, since main's changes didn't touch them.

`check_input_expression_coded`'s own lines are the exception: 1,031,540 on main, 1,129,397 on the final head. Its
visit's test takes 98 thousand more jumps, because the layout around it changed. But the compiled function, with what
it inlines (`check_input_add_node`'s hinted tests among them), falls 18%: 4,356,918 to 3,565,835
(`functions-taken.txt`).

## Limitations

- **No cycles, no 9700X.** These are counts of the layout's taken branches and of instructions. Nothing here measures
  time, mispredictions or the front end's stalls, and nothing here comes from the 9700X.
- **`-fno-pie` code.** The counts are of `-fno-pie` code, which matched the PIE build's per function on main, as above,
  but isn't the code buster ships.
- **One input.** The input is `sqlite3.c` alone, and `-c` ran on one lane.
- **The host's clang.** Clang is 23.1.5, where buster's CI pins 23.1.4.

## Reproducing

From a buster checkout at the source to measure, with `WORK` holding `corpus/` (`tools/ci/fetch-corpus.sh WORK/corpus`)
and `RECORD` naming this directory:

```sh
cc -O2 -o "$RECORD/scripts/taken" "$RECORD/scripts/taken.c"
"$RECORD/scripts/build.sh" . "$WORK/compiler" "$RECORD/scripts/wrap-nopie"
WORK="$WORK" "$RECORD/scripts/measure.sh" "$WORK/compiler" head
WORK="$WORK" "$RECORD/scripts/measure.sh" "$WORK/compiler" head-c c
WORK="$WORK" "$RECORD/scripts/site.sh" head . c_check_input.c check_input_resolve_range
```

The wrappers call `/usr/lib/llvm-23/bin/clang`, and `measure.sh` takes LLVM's tools from `$LLVM` (default
`/usr/lib/llvm-23/bin`). The executables aren't kept here, being about 160 MB each with debug information. Their
sha256 sums are in `logs/receipts.txt`.

## Files

- **`scripts/`:**
  - `taken.c`, `measure.sh`, `attribute.sh`, `site.sh` and `branches.sh` (the coverage counts' extraction);
  - `build.sh` and the three clang wrappers;
  - `probe-expect.c`.
- **`patches/`:** the variants' diffs against main.
- **`logs/`:**
  - `receipts.txt` and `sites.txt`;
  - a directory per executable and mode, each with `totals.txt`, `dyno.txt`, `functions-taken.txt` and `lines.txt`.
    main's and head's also have `profile.fdata.gz` and `edges.txt.gz`;
  - `coverage-branches-main-fsyntax.txt.gz` and `probe-expect.s`.
