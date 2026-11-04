# The checker's rare tests and their layout (buster#1175)

This record holds exact taken-branch counts of the layouts of buster main and of buster#1225, which states the checker's
rare tests (`__builtin_expect`) and computes some without branches. It was made on 2026-11-03 in a cloud VM, not on the
Ryzen 7 9700X. The VM has no hardware PMU, so the counts are BOLT's instrumented edge counts, not hardware counters.

**Not covered: cycles.** buster#1175 keeps a change only when its taken branches and cycles fall over placements
(`time-runs --copies`, buster#509) on the 9700X. That measurement is still to be made, and nothing here stands in for
it. `scripts/campaign-9700x.sh` makes it in one command on the 9700X ("The 9700X measurement", below).

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
`check_input_expression_coded`'s, 3,584,773 to 3,565,835.

The final head's executable was first measured as `a6405c80`, an earlier, unpublished version of the same commit
(`logs/final-*`). `patches/a6405c80-to-d9d9d32f.diff` is the two commits' whole difference: two comment lines. The
published `d9d9d32f` was then built and measured itself (`logs/head-d9d9d32f-*`):

- **Code.** Its code is the same: `.text` (26,514,889 bytes), `.rodata` and `.data` are byte for byte the first
  executable's. Among the allocated sections, only `.note.gnu.build-id` differs.
- **`-fsyntax-only`.** Its counts are the same.
- **`-c`.** It is within that mode's run-to-run spread: 1 taken branch and 9 instructions fewer.

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

## The 9700X measurement

**What CI has.** buster#1225's own 9700X job measured its head `22b16e4e` alone
([job 125967206614](https://github.com/buster14a/buster/actions/runs/41649129901/job/125967206614)). Its compile-time
step ran `perf stat -r 11` of `-c sqlite3.c`, with that step's options (the host's headers, the default lanes), on CPU 2:

| `22b16e4e`, `-c sqlite3.c` | |
| --- | ---: |
| `cycles:u` | 525.72 M (±0.06%) |
| `instructions:u` | 1,186.34 M |
| `branch-misses:u` | 3.05 M |
| `measure-compile`'s median wall time of 11 | 110.91 ms |

Main's run at the base `8c9c5bf0` ([run 41644431545](https://github.com/buster14a/buster/actions/runs/41644431545))
skipped that step and the checker's timings, since that merge changed no checker or compile-time source. Main's later
push runs did the same where their merges didn't touch the checker, such as `48ac6d71`'s
([run 41735471087](https://github.com/buster14a/buster/actions/runs/41735471087)). So CI has no matched pair, and these
numbers compare with nothing.

**`scripts/campaign-9700x.sh`** makes buster#1175's measurement on the 9700X, from a buster clone that has both commits:

```sh
git -C ~/buster fetch origin 8c9c5bf02160a2784a637548362148872e471adb 22b16e4ee3dda030dd858b9c7381ea0d44e20013
EXCLUSIVE_TITLE="<session title>" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1225 \
    "$RECORD/scripts/campaign-9700x.sh" ~/buster main=8c9c5bf0 head=22b16e4e
```

`head` is `main` with buster#1225's diff alone: the pull request merged `8c9c5bf0` before its last code commit. The
script does the following:

- **Placements.** A shift of `.text` alone wouldn't move the code this change touches. Six of its seven files are the
  checker's own code, in `.text.buster_checker`, which starts each unit on a page (buster#502). So `./build.sh shifts`,
  of `main.c` as buster#880's record did or of the checker's unit as buster#509's example does, moves it only by whole
  pages. Its offsets in the page, which the caches and the op cache see, stay.

  The script therefore builds each commit (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`) four times. Each time,
  `main_unit_checker.c` gets a line of file-scope assembly for that build alone, `.skip SKIP, 0xcc` in that section.
  That starts the unit's checker code SKIP bytes into its page, ahead of every function, with bytes that never run.
  `./build.sh shifts DIR main.c SHIFT` moves the rest. The placements, SKIP:SHIFT, are 0:0 (the code as buster ships
  it), 688:256, 1376:512 and 2064:768, so the skips fall 0, 48, 32 and 16 bytes into a 64-byte line. The receipts give
  each executable's offsets of `check_input_resolve_range`, `check_graph_run` and `main` in their pages.
- **Objects.** Every object of `sqlite3.c` and of the 139 musl units (buster#182's list, in
  `pgo-port-880-2026-11-02/logs`), from every executable, must be the reference's at 0:0, byte for byte.
- **Counters.** At every placement, `perf stat` counts `instructions:u`, `cycles:u` and `ex_ret_brn_tkn:u` three times
  per list. The lists are `sqlite3.c`'s `-fsyntax-only` and `-c` and the musl units' `-c`, with the frozen corpus's
  headers and predefines. `counters.c` takes the least of each placement's runs and their mean over the placements. It
  gives each build's change against the first build's, and that change's range: each of the build's placements against
  each of the reference's. A placement of one tree isn't the same placement of the other, so as with `time-runs`
  (buster#509) the range pairs nothing.
- **Times.** `time-runs --runs 11 --warmups 1 --copies 2` times the same lists over the placements and the copies.

Every build, each placement's counts, each executable's objects and the `time-runs` take the lock for themselves alone.
Where `cores` is on PATH, the builds also go through it. A placement after the first rebuilds the checker's unit alone.
The logs land in `~/buster-fast-bench/claude-1175/logs`: `receipts.txt`, `counters.txt`, `counters-summary.txt` and
`time-runs.txt`.

**A dry run on this VM.** The whole script ran here on 2026-11-04, exiting 0, with these stand-ins:

- `env` for the lock and `native` for `znver5`, since the Xeon can't run some of `znver5`'s instructions;
- a stand-in `perf` that runs the command and prints made-up counts, since the VM has no PMU;
- one `time-runs` run, on CPU 0.

Every stage ran. Its counts and times mean nothing; only these checks of the script stand:

- **Placements.** At the four placements, `check_input_resolve_range` started 0x370, 0x620, 0x8d0 and 0xb80 into its
  page in main's executables, and 0xc40, 0xef0, 0x1a0 and 0x450 in head's: 0, 688, 1,376 and 2,064 bytes on. `main`
  started 0x150, 0x250, 0x350 and 0x450 into its page in both, 0, 256, 512 and 768 bytes on.
- **Objects.** All eight executables' 140 objects were main 0:0's, byte for byte.
- **Counts.** `counters.txt` had its 216 lines: 8 executables, 3 runs, 3 lists and 3 events. `time-runs` ended with no
  failed process.
- **Trees.** Both worktrees were left clean.

On this VM, a placement after the first rebuilt the checker's unit in about 90 seconds.

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
  - `probe-expect.c`;
  - `campaign-9700x.sh` and `counters.c`, the 9700X measurement still to make.
- **`patches/`:** the variants' diffs against main.
- **`logs/`:**
  - `receipts.txt` and `sites.txt`;
  - a directory per executable and mode, each with `totals.txt`, `dyno.txt`, `functions-taken.txt` and `lines.txt`.
    main's and head's also have `profile.fdata.gz` and `edges.txt.gz`;
  - `coverage-branches-main-fsyntax.txt.gz` and `probe-expect.s`.
