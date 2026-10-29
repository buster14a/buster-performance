# Local labels and `__auto_type`, Buster #147

Compiler pull request: [buster14a/buster#840](https://github.com/buster14a/buster/pull/840), branch
`claude/solve-147-label-auto`, for [this claim on #147](https://github.com/buster14a/buster/issues/147#issuecomment-6478625460).

The pull request checks and lowers GNU C's local labels (`__label__`), a statement expression's value through the
labels on its last statement, and `__auto_type`. This record holds two pieces of evidence:

1. **The default path's cost**: `-c` of the frozen `sqlite3.c`, which uses none of them, by main and by the pull
   request, over the checker unit's code placements and fresh copies of each executable (#509's method), with an A/A
   control, and each build's instructions for `-fsyntax-only` and `-c`. Two campaigns: the final head against its
   main parent, and an earlier head against the main before its own.
2. **Mutation receipts** of the implementation and tests: a run on the earlier head's tree, and one on the final
   head's for the earlier run's survivors and the review's fixes.

## Sources

| Role | Commit | Tree |
|---|---|---|
| base | `da8424103bf67b1fc608acfbd37b1b3523f9c650` | main, the final head's merge parent |
| head | `623d0d18f7c4a017170bbc6e6529005128915462` | the pull request's final head |
| first base | `6a713e5b61691751a18b1224dcd1f6ffbeb6e3aa` | main one commit before the first head's merge parent |
| first head | `af2d9a9b1914fa4c26fa5c7d6f39c63ffbfdc0e6` | the pull request's commit `21c93116` merged with main `d11a91d2` |

The first campaign's base should have been `d11a91d2470784f627e9b69537f6b491ab8f2c5b`, the first head's merge parent.
The one commit between it and `6a713e5b` (main's merge of buster14a/buster#831) changes `snapshot.c` and
`snapshot_test.c`, which `-c` doesn't run. A campaign against `d11a91d2` was started, then stopped after one count of
each build, when the review changed the head (below); its counts are in `placements-first/stopped.txt`.

Between the first head and the final one: a comment's move (`358d98d6`), the review's fix for `_Alignas` with
`__auto_type` (`a833c164`), a merge of main `da842410` (`3d6f726c`), and the mutation run's fixes (`623d0d18`).

The trees on the 9700X are `git archive` of their commits. `sources/*.sha256` list each commit's files and their
SHA-256, and the trees there matched them file for file outside `build/` and the `COMMIT` file the author added
(compared as sets of lines, sorted by path, when this record was assembled).

## The default path's cost

### Host, builds and input

Author-reported host (`host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9; CPU 2's scaling
governor read `performance` when this record was assembled, after the runs. Every build and measurement took the
host's lock (`exclusive.sh`) for itself. The lock's waiting messages are left out: they name other jobs. Only the
lines the scripts and the compiler's tools print are kept (`placements*/run.log` keeps the scripts' own lines,
`placements*/ab.log` `ab`'s and `time-runs`' lines, the build logs `build.sh`'s), by allowlists of those lines'
shapes (`scripts/collect6.sh` for the final campaign, the same patterns for the first). The drive checks' logs held
nothing else and aren't kept.

Builds: `BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_checker.c 0 704 1408 2112 2816 3520` in each tree
(`scripts/shifts6.sh` for the final campaign, `scripts/shifts4.sh` for the first), six executables per tree, each with
that many bytes of padding in `.text` before the checker unit's code. Their SHA-256, the controllers' (each campaign's
head `build/compiler`, which ran `ab` and `time-runs`), the lock script's, the inputs' and the drive checks' objects'
are in `placements*/identities.sha256`.

Input: the frozen SQLite 3.53.2 amalgamation of the preprocessor corpora (`sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with `sqlite3.h` and `sqlite3ext.h` beside it).
The commands: `-c -I<its directory> -o <output> sqlite3.c` and `-fsyntax-only -I<its directory> sqlite3.c`, without
the 9700X job's `-D` options.

### Method

Each campaign starts with a drive check: each tree's placement-0 executable compiles the file once with `-c`, pinned to
CPU 2, and the two objects are the same bytes (`objects identical`; both campaigns' four objects and the stopped
campaign's have one SHA-256). Then each build's instructions: `perf stat -e instructions:u` of placement 0's
`-fsyntax-only` and `-c`, pinned to CPU 2, three runs each, the trees in turn, each run one hold of the lock. Their
exit statuses weren't logged. The scripts' raw logs hold no lines besides their own (`run.log`) and the lock's
messages, so the counted runs printed nothing, no diagnostic among it, and each build's three counts agree within 100
instructions.

Then `ab --rounds 3 --cpu 2 --lock exclusive.sh <controller> -- time-runs --runs 3 --copies 3 --directory <copies>
--build base <base's six> --build head <head's six> --build base-again <base's six> --list <-c command>`. Each round
is one `time-runs` process in one hold of the lock, pinned to CPU 2: every build's placements, each from three fresh
copies of its executable, three runs each, in a rotating order, 54 runs per build per round. `base-again` runs the
base's executables again: an A/A control in the same hold. Every run exits with status 0.

### The final head

Medians of each round's 54 runs per build (`placements/ab.log`):

| Round | User cycles (M), head | head against base | base-again against base | Wall, head against base | base-again against base |
|---:|---:|---:|---:|---:|---:|
| 1 | 591.644 | +0.14% (placements -0.27% to +0.53%) | +0.02% | +0.04% | -0.14% |
| 2 | 591.515 | +0.14% (placements -0.28% to +0.81%) | +0.02% | +0.12% | -0.01% |
| 3 | 591.935 | +0.06% (placements -0.74% to +0.34%) | -0.03% | -0.01% | -0.06% |

Each range over placements crosses zero. The head's user cycles are above the A/A control's by 0.12%, 0.12% and
0.09%, about what its instructions (below) cost at an unchanged IPC. Over placements and copies the head's ranges are
wider (cycles: -1.23% to +0.78%, -1.06% to +2.61%, -6.12% to +1.23%). In round 3, one of the base's copies
(placement 3's second) ran two of its three runs slow (697.4 and 624.8 M user cycles, against 589.6 for its third),
which widens head's and base-again's ranges over copies there (to -6.12% and -5.71% in cycles, -9.64% and -9.69% in
wall time) but not the medians.

Instructions per run, from `time-runs`' 162 runs per build: the base's median 1,297,623,775 (1,297,623,761 to
1,297,623,991), base-again's 1,297,623,774, the head's 1,299,755,310.5 (1,299,755,296 to 1,299,755,532): 2,131,536
more (+0.164%). `perf stat` gives the same difference for `-c` (`placements/perf6-*.txt`, medians of three:
1,297,624,379 and 1,299,755,915) and as many more for `-fsyntax-only` (999,193,283 and 1,001,324,904: 2,131,621 more,
+0.213%), so the extra instructions are the checker's, which `-fsyntax-only` runs too, not the lowering's.

### The first head

Medians of each round's 54 runs per build (`placements-first/ab.log`):

| Round | User cycles (M), head | head against base | base-again against base | Wall, head against base | base-again against base |
|---:|---:|---:|---:|---:|---:|
| 1 | 590.903 | -0.31% (placements -0.83% to +0.12%) | +0.00% | -0.26% | -0.08% |
| 2 | 591.929 | -0.05% (placements -0.41% to +0.35%) | +0.10% | -0.23% | +0.01% |
| 3 | 590.876 | -0.34% (placements -0.63% to +0.16%) | -0.20% | -0.33% | -0.15% |

Each range over placements crosses zero, and over placements and copies each round's head-against-base range is
wider (cycles: -1.62% to +0.98%, -1.00% to +1.54%, -1.01% to +0.57%). Instructions per run (`perf stat`, the median
of three, `placements-first/perf-*.txt`): `-c` 1,295,914,373 by the first base and 1,297,993,243 by the first head,
2,078,870 more (+0.160%); `-fsyntax-only` 998,991,220 and 1,001,069,769, 2,078,549 more (+0.208%). The stopped
campaign's base, `d11a91d2`, counted 1,295,891,255 for `-c` and 998,968,064 for `-fsyntax-only`, once each: the first
head ran 2,102,037 and 2,101,721 more than its own merge parent. Its drive check's object is the others' bytes.

### Reading it

At nearly the same instructions (+0.160% and +0.164% for `-c`), the first campaign put the first head 0.14% to 0.31%
below its A/A control in user cycles and the final campaign put the final head 0.09% to 0.12% above its own. The
difference in time is therefore within what these placements and campaigns resolve, about 0.3% either way, and the
instructions are the cost that repeats: 2.13M per compile of this file, all in the checker. The placements vary only
the checker unit's `.text` offset: the builds' other units, `.rodata` and data differ and aren't varied.

### Where the instructions went

On the author's laptop (AMD Ryzen 9 7940HS, Zen 4, Linux 7.3.0-5-cachyos, clang 23.1.4, perf 7.2.11, native builds
with `-g`), `-fsyntax-only` of the same file (the same SHA-256) by the first head's merge parent (`d11a91d2`) and the
first head (`af2d9a9b`), pinned to one CPU (`scripts/ibs.sh`): three `perf stat -e instructions:u` runs of each,
997,130,031 and 999,223,584 (2,093,553 more), then four `perf record -e ibs_op/cnt_ctl=1,swfilt=1/u -c 10000` runs of
each. `scripts/ibs-reports.sh` reports each run's samples by symbol, and by source line in `check_input_resolve_range`
and `check_input_specifiers`; `scripts/ibs-lines.py` compares them (`instructions/ibs-lines.txt`). A sample stands for
10,000 dispatched ops, not instructions.

- **By function:** the head has 115 more samples per run (127,154 against 127,269), within which
  `check_input_resolve_range` has 269 more and `check_input_specifiers` 106 more, and other functions fewer
  (`check_init_walk` 56 fewer, `check_control_children` 45, `check_control_drain` 37).
- **By line, in `c_check_input.c`:** the head has 184 more samples per run. The lines the branch added or changed hold
  73 of the head's. Of the lines it didn't change, the largest increase, 104 samples, is one line inlined into
  `check_input_resolve_range` (`check_input_resolve_tests`, the walk's test of a token's reasons), and the samples
  without a line (line 0) grow by 173.

So in the two functions whose samples grew most, a fifth of the growth (73 of 375 samples per run) is on the lines the
branch added or changed, the walk's and the specifiers' new tests, and the rest is on lines it didn't change or on
samples without a line: how clang's code for the reader's inlined loops moved with the edits, as in
`../transparent-unions-147-2026-10-29/`. IBS samples ops, and their totals (115 more samples per run, about 1.15M ops)
don't add up to the instruction count's difference; they place it, without measuring it exactly. A variant that put the
walk's choice between a `__label__` list and another declaration in a function of its own, not inlined, ran 186,343
more instructions than the head (the medians of three, 999,409,992 and 999,223,649, `instructions/laptop.csv`'s
`stat2` series) and wasn't kept; its source isn't published.

## Mutation receipts

Host: the author's laptop (above). Each mutant is one replacement in a copy of the tree, built at `-O1` (its
`build.sh`'s `-O3` replaced), with `ONLY_GNU` switches that run `test-checker`'s source fixtures, repairs, control
masks and the pull request's programs alone, and `test-checker-driver`'s local labels' and `__auto_type`'s test alone.
A mutant is killed when either exits with another status than 0. `mutants*/results.txt` are the runs' records,
`mutants*/<mutant>.log` both commands' output. Each run's base tree matches `git archive` of its commit file for
file, outside `build/` and the `COMMIT` file the author added to the first (`sources/head-af2d9a9b.sha256`,
`sources/head-623d0d18.sha256`, compared when this record was assembled).

### On the first head's tree

`scripts/mutate5.py` and `scripts/run5.sh`, on `af2d9a9b`'s tree, with its programs `local-labels` and `auto-type`.
The unchanged copy passes (`C00-unchanged`: 12,769 and 314 checks).

| Mutant | Change | Outcome |
|---|---|---|
| L01b | a block's `__label__` list pushes nothing | killed: 26 and 60 failures |
| L02 | a list's name its block doesn't define isn't reported | killed: 4 and 32 |
| L03 | a name declared twice is never ambiguous | killed: driver 8 |
| L04 | a goto takes the function's label, not the list's | killed: 18 |
| L05 | a definition takes the function's label | killed: 22 and 18 |
| L06 | the vector path's mask leaves out `__label__` | killed: 986 and 38 |
| L07 | the region's final statement isn't found through its labels | killed: 20 |
| L08b | the expression walk never finds a labeled terminator's region | killed: 20 |
| L09 | a labeled final statement is also written as a statement | killed: 2 |
| L10 | the cached evaluation's label gives void | killed: 10 |
| L11 | an undeclared label at a goto is reported at the goto | killed: driver 16 |
| L12 | the repair pass drops the new label messages | killed: 2 |
| L13 | a redefinition is reported at the colon | killed: driver 8 |
| L14 | the list isn't ignored by the other walks | killed: 24 and 48 |
| A01 | the deduced type isn't decayed | killed: 14 |
| A02 | the initializer's qualifiers are kept | killed: 4 |
| A03 | the specifiers' `const` and `volatile` are dropped | **survived** |
| A04 | no scan of the initializer for the variable itself | killed: driver 8 |
| A05 | the cached evaluator's binding takes the placeholder | **survived** |
| A06 | the handle's binding takes the placeholder | **survived** |
| A07 | the initialization's kind isn't set from the deduced type | **survived** |
| A08 | the linked type keeps the placeholder | killed: 4 |
| A09b | the declarator's checks take everything | killed: 22 and 44 |
| A10 | `__auto_type` taken in any specifiers, not only a declaration's own | killed: 8 and 16 |
| A11 | a clash is reported where the specifiers fail | killed: driver 4 |
| A12 | the cached evaluator takes no compound literal | killed: 10 |
| A13 | no finish event for the initializer | killed: 26 and 40 |
| A14 | a type name's error is reported twice | killed: 2 and 4 |
| A15 | `_Complex` with `__auto_type` is taken | killed: driver 4 |
| A16 | an incomplete deduced type is taken | killed: driver 4 |
| A17 | a self-reference is reported at the variable's name | killed: 2 and 8 |
| A18 | a bit-field's value is taken | killed: 4 and 12 |
| A19 | an initializer list is taken | killed: driver 4 |
| A20 | an array is taken | killed: 4 and 8 |
| A21 | a variable without an initializer is taken | killed: 4 and 12 |
| A22 | a typedef with `__auto_type` is taken | killed: driver 4 |
| A23 | a pointer declarator is taken | killed: 2 |
| A24 | a linked redeclaration is taken | killed: 2 |
| A25 | a second declarator is taken | killed: 2 |

Where a row gives one count it is `test-checker`'s, or the driver's where it says so; two counts are both commands'.
L01's, L08's and A09's first replacements didn't build (their `mutants5/*.build-error.txt`: each left a function
uncalled, which `-Wunused-function` refuses); L01b, L08b and A09b are their replacements. `results.txt` holds the
lines of several runs of `run5.sh`, each ending in `done`.

The four survivors led to the final head's fixes (`623d0d18`):

- **A03 and A07:** no test read the specifiers' qualifiers on the deduced type or the initialization's kind. The head
  adds a fixture that reads the qualifiers through `_Generic` of the variable's address, an assignment to a `const`
  one, and a program (`auto-type-static-structures`) whose structures, deduced from compound literals at file scope,
  in a static and in a block, initialize static data. A07's kind turned out to change nothing a program can see
  (A07b, below).
- **A05 and A06:** removing either of two refusals in the constant evaluators' bindings changed nothing that a test
  saw, and with them a use of the variable in its own initializer was left undeclared: the finish's scan, which
  reports such a use at the use with clang's message, didn't see it. The head removes the three refusals, and the
  driver's test checks the four self-references' places and clang's message.

### On the final head's tree

`scripts/mutate7.py` and `scripts/run7.sh`, on `623d0d18`'s tree, with its programs `local-labels`, `auto-type`,
`auto-type-alignment` and `auto-type-static-structures`: the earlier run's survivors again (A03b and A07b, the same
replacements on the new code), the three refusals the head removed, each put back (S01 to S03), and the review fix's
three `_Alignas` checks (G01 to G03). The unchanged copy passes (`C00-unchanged`: 13,058 and 405 checks).

| Mutant | Change | Outcome |
|---|---|---|
| A03b | the specifiers' `const` and `volatile` are dropped from the deduced type | killed: 8 and 8 |
| A07b | the initialization's kind isn't set from the deduced type | **survived**: equivalent (below) |
| S01 | the cached evaluator's binding refuses the placeholder again | killed: driver 4 |
| S02 | the handle's binding refuses it again | killed: driver 16 |
| S03 | the raw binding refuses it again | **survived**: out of reach (below) |
| G01 | the declarator's `_Alignas` check runs against the placeholder | killed: 12 and 4 |
| G02 | the specifiers' `_Alignas` check runs against the placeholder | killed: 10 |
| G03 | no check of `_Alignas` against the deduced type | killed: 8 and 16 |

**A07b** changes which path checks and lowers the initialization: `CHECK_OP_INITIALIZE`, the scalar one, where the
head takes the aggregate path every other declaration of a structure, union or vector type takes. `__auto_type` takes
only an expression initializer, never a list, and for one the two paths give the same code and diagnostics.
`mutants7/probes/probe.c` deduces structures, unions, vectors and extended vectors at file scope, in statics and in a
block, from calls, compound literals, a conditional, a statement expression and `volatile` and `const` declarations:
clang's build, the head's and the mutant's print the same, and the head's and the mutant's `-c` objects are the same
bytes. `d1.c` to `d6.c` initialize objects of static storage, structures, a union and a vector, with values that
aren't constant: the head and the mutant report each at clang's place (`mutants7/probes-A07b.txt`, from
`scripts/probes.sh`). The head keeps the line, so that the declaration's kind is what its type makes any other
declaration's.

**S03** puts back a refusal in `check_constant_raw_bind`, the binding of an evaluation the parser's tree doesn't
cover, which it takes where the region holds an operand of another kind than a number, a character, a string, an
identifier or `default` (a prototype's `...`, for one). Its refusal is out of reach of every shape tried:
`mutants7/probes/s1.c` to `s7.c` put self-references inside type queries, compound literals' bounds and variadic
function types, with C23's constants beside them, and the head and the mutant report each at clang's place with
clang's message (`mutants7/probes-S03.txt`). A copy of the head that logs each place where the refusal would act
(`P01-raw-reach` in `scripts/mutate7.py`, run by `scripts/reach.sh`) logged none over the probes and over
`test-checker`'s and `test-checker-driver`'s sections above (13,058 and 405 checks, the driver's compiles inheriting
the log's variable): no raw binding met the placeholder. The head leaves the three bindings alike, binding such a use
as any other, for the finish's scan to report it.

Limitations: the mutants ran on Zen 4 at `-O1`, in those sections alone, not the whole suite; each is one replacement
chosen by the author.
