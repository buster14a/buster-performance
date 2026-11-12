# Attested declarations' census: step 0 of buster#2531 (2026-11-12)

[buster#2531](https://github.com/buster14a/buster/issues/2531)'s design (`docs/attested-declarations.md` in buster)
skips the reading of a file-scope declaration that an earlier unit of the same command read silently and purely, and
that nothing of the unit reaches by name. Its step 0 is a census: the pipeline as it is, with the design's passes (the
lists, the own hashes, the chain with a memo over the command's units, the reach and the marks) computed beside every
unit, and after each declaration's reading a record of what the reading did, by the reader's own events. No compile
changes. Its gate:

1. no reading declares an unlisted name on the corpora;
2. the reader's own test makes at least 75% of musl's and of the glibc units' file-scope declaration tokens skippable
   (the design's emulation: 87% and more);
3. the passes cost at most 25 cycles a token in the compile.

This record is the census's run on the 9700X, with a plain compile of the same commands as the baseline and as the
census's object and diagnostic comparison.

- **Source:** buster `ee5b39b90f01d4a8ad6449f5c5b66d3c0ba55c8e` (branch `claude/sharp-rubin-9yvg63`, the census's
  pull request; its base is main's `0af27a30`), built on the host by `scripts/build.sh` (`./build.sh`, Release, the
  host's native target, `BUSTER_DEBUG_INFO=0`); `results/build.log` is that build. `results/tree.sha256` is every
  file of the host's tree outside `build/`, and is line for line the SHA-256 of `git archive ee5b39b9` (1,569 files).
  `results/env.txt` has the executable's SHA-256. The branch's later commits are a merge of main and documentation:
  the census's code is unchanged after `ee5b39b9`.
- **Host:** the Ryzen 7 9700X (`benchpress`), `results/env.txt` (kernel, governor and EPP of CPU 2, THP, clang, perf).
  `scripts/queue.sh` ran each step of `scripts/final.sh` in its own hold of the machine's lock (`exclusive.sh`);
  `results/holds.txt` is the lock's own holder line for each hold, and `results/queue-and-diagnostics.txt` each
  step's exit status. Every timed command is pinned to CPU 2 with the address space's randomization off
  (`setarch -R`): musl's command has two page states, and this keeps every round in one (the page faults of the three
  rounds are 343,028, 343,029 and 343,029).
- **Workloads** (`scripts/common.sh`):
  - musl: the frozen corpus's first source of each base name, 1,336 units (`results/musl-units.txt`, SHA-256
    `1f317509…`), with the one-core record's options (`-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700` and
    musl's include directories), `-c`, one command, `--lanes 1`;
  - the 512 generated units over the host's glibc headers of
    [the design's record](../file-scope-design-672-2026-11-12/) (section 8, `gen_units.py`; the same files: the
    concatenation's SHA-256 is `bdbee80a…` in both records), `-c`, one command, `--lanes 1`.
- **The commands:** `compiler --lanes 1 -c …` under `perf stat` (three rounds of musl, one of glibc), and
  `compiler measure-attested --list 20 --passes 3 --twins -c …` (buster's `c_check_attested.c`, documented in
  `docs/commands/translation-units.md`, "Attested declarations' census (#2531)"). The census runs the same compile
  with the reader's environment published, so each object and the diagnostics are compared with the plain run's.

## Results

`results/musl-census.txt` and `results/glibc-census.txt` (the `--list 20` lines first: up to 20 declarations of each
outcome but `skipped`, by unit, file and line). "Outside definitions" is the units' tokens less the function
definitions' (bodies and heads).

| on the 9700X | musl, 1,336 units | 512 units over glibc's headers |
| --- | ---: | ---: |
| file-scope declarations; their tokens; outside definitions | 297,004; 5,039,561; 3,378,428 | 298,334; 5,371,375; 5,170,118 |
| **skipped: attested and not reached (gate: 75%)** | 233,466; 2,679,590 tokens, **79.31%** | 260,305; 4,498,013 tokens, **87.00%** |
| reached by a spelled name | 14,794; 226,031 (6.69%) | 20,014; 388,823 (7.52%) |
| reached only by the lowering's runtime names | 26,394; 216,403 (6.41%) | 11,934; 224,854 (4.35%) |
| learned: the memo's first readings | 2,995; 45,205 (1.34%) | 2,555; 58,428 (1.13%) |
| impure: defines, tentative, internal, alias | 374, 90, 20, 287; 211,199 (6.25%) | none |
| function definitions (roots) | 18,584; 1,661,133 | 3,526; 201,257 |
| a diagnostic's, an error unit's, a pragma's | none | none |
| **file-scope declaring events not in the declaration's list (gate: 0)** | **0** of 303,705; tags completed unlisted 0 | **0** of 386,867; 0 |
| uses not in the list (definitions' included) | 0 of 199,551 | 0 of 25,705 |
| memo hits whose reading here was not silent and pure (contradictions) | 0 of 274,654 | 0 of 292,253 |
| diagnostics, and those no declaration's token holds | 321 warnings, 0 | none |
| objects against the plain compile's | 1,336 the same bytes | 512 the same bytes |
| diagnostics against the plain compile's | the same bytes | the same (none) |
| the twins: units whose vector and scalar lists, hashes or literals differ | 0 | 0 |

Gates 1 and 2 hold. Every musl warning falls in a function definition; no file-scope declaration's reading reported
anything.

### The passes' cost

Each pass is timed by the thread's user-mode counters read with `rdpmc` around it: the first run is the one inside the
compile, right before the unit's reader; the census then runs the passes twice more on the same unit and keeps each
pass's least (`--passes 3`). Per token of all the units' tokens:

| pass | musl: first run | least of 3 | branch misses a token, first / least | the glibc units: first run | least of 3 |
| --- | ---: | ---: | ---: | ---: | ---: |
| lists | 11.04 | 6.68 | 0.171 / 0.035 | 13.14 | 9.35 |
| own hashes | 5.23 | 5.05 | 0.002 / 0.001 | 5.11 | 5.02 |
| literals | 5.53 | 3.81 | 0.060 / 0.011 | 3.91 | 2.34 |
| chain | 7.04 | 3.00 | 0.089 / 0.009 | 7.34 | 3.32 |
| reach | 5.45 | 2.53 | 0.097 / 0.020 | 1.92 | 0.92 |
| marks | 1.06 | 0.47 | 0.021 / 0.005 | 1.07 | 0.53 |
| **all (gate: 25)** | **35.35** | **21.54** | 0.440 / 0.081 | **32.48** | **21.49** |

**Gate 3 does not hold as measured:** 35.35 and 32.48 cycles a token in the compile. The same passes repeated on the
same unit take 21.5. Of the first run's 13.8 extra cycles a token on musl, its 0.36 more branch misses a token are 4 to
5 at 12 to 15 cycles a misprediction; the L1D read misses are nearly the same count (0.893 against 0.825 a token), and where
they are served from and the instruction side's misses were not counted. The literals' pass reads 309,003 literal
spellings a run of musl's (6.1% of its tokens) and 159,855 of the glibc units' (3.0%), about 90 and 131 cycles each in
the first run.

### The baseline and what it means for step 2

`results/stat-*.csv`: the plain compile, every declaration read.

| | musl, round 1 | round 2 | round 3 | the glibc units |
| --- | ---: | ---: | ---: | ---: |
| user cycles (M) | 4,826.6 | 4,802.4 | 4,800.6 | 4,059.2 |
| kernel cycles (M) | 1,165.1 | 1,175.8 | 1,171.0 | 511.8 |
| task clock (ms) | 1,081.80 | 1,079.21 | 1,077.91 | 824.70 |
| page faults | 343,028 | 343,029 | 343,029 | 171,159 |
| user instructions (M) | 12,804.1 | 12,804.1 | 12,804.1 | 11,181.0 |

A projection, not a measurement: the design's record measured the reader's skip at main's `ecaf57b5` (musl 5,547 M
cycles to 4,448 M for 2,954,264 skipped tokens, 372 cycles each; the glibc units 4,297 M to 2,594 M for 4,737,766, 359
each). At those savings a token, the census's skipped tokens save 997 M cycles of musl's 5,980 M and 1,617 M of the
glibc units' 4,571 M. With the passes at their first-run cost (178 M and 175 M), step 2 would be **1.16** times on
musl and **1.46** on the glibc units (step 2's gate: 1.15 and 1.4; the design expected 1.23 and 1.62); with the
passes at 25 cycles a token, 1.17 and 1.48; without them, 1.20 and 1.55. Main has since baked #2532's asm index
(musl's command 991.4 ms where `0af27a30` took 1,064.2, buster's `docs/attested-declarations.md`); on that baseline the
same saving is 1.17 with the passes as measured.

**Where the census's skip falls short of the emulation's** (87.4% of musl's tokens outside definitions, 88.2% of the
glibc units'): 274,674 and 239,753 tokens, of which the runtime names' rule is 216,403 and 224,854. The lowering looks
up its runtime functions by name (`memcpy`, `memset`, the libgcc helpers, the elementwise builtins' libm) in every unit
with a body, and a runtime call's symbol comes from the name's first declaration, so the census reaches those
declarations in every such unit; the emulation had no such rule.

## The driver's hook: the census's base against its commit

`scripts/ab.sh`, `results/ab/`: the plain compile of musl's command (`-c`, one lane, CPU 2, `setarch -R`) by main's
`0af27a30`, the census branch's base (`results/ab/tree-main.sha256` is the host's tree, line for line its
`git archive`, 1,567 files; built as `ee5b39b9` was, `results/ab/main-build.log`), and by `ee5b39b9`, three rounds
each, interleaved, each in its own hold (`results/ab/holds.txt`, `results/ab/queue-ab.log`). Every other command
tests the census's pointer, null, at its reader's call and its unit's end, and runs nothing of it.

| | `0af27a30`, rounds 1, 2, 3 | `ee5b39b9`, rounds 1, 2, 3 |
| --- | ---: | ---: |
| user cycles (M) | 4,919.6, 4,848.1, 4,845.8 | 4,793.2, 4,811.5, 4,799.6 |
| kernel cycles (M) | 1,211.2, 1,167.9, 1,170.7 | 1,173.0, 1,177.4, 1,172.2 |
| task clock (ms) | 1,111.81, 1,086.31, 1,086.42 | 1,077.21, 1,081.37, 1,078.18 |
| user instructions (M) | 12,789.6 each | 12,804.1 each |
| page faults | 343,030, 343,031, 343,031 | 343,029 each |

The objects are the same bytes (1,336) and so are the diagnostics (`results/ab/compare.txt`). `ee5b39b9` takes 0.11%
more user instructions and 1.0% fewer user cycles than the base's last two rounds (its first, the first run after its
build, is the slowest). The instructions are the checker unit's code moving as the new file joins it, not new work: by
`perf record -e instructions:u -c 200003` (`scripts/abp.sh`, `results/ab/report-*.txt`, each command's top 400
functions), `check_input_declarator_step` gains 73 M where `check_input_specifiers` loses 54 M and
`check_input_capture_names` 18 M, the rest within the sampling's noise, and no function of the census's appears.

## Limitations

- The census runs the passes beside the reader; it skips nothing. Its gates are the design's step 0; the compile with
  the skip is step 2's.
- One lane (`--lanes 1`; the census refuses its lanes' options and `--deferred-bodies`), no `-g`. Step 1, the shadow,
  is where those are checked.
- The design's risk "an input of a reading that the hash doesn't cover" names a test at step 0: every field of the
  reader's state listed by class, failing on a field without one. The census doesn't have it; its zero contradictions
  over 566,907 hits are the evidence here instead.
- One census run of each command. No count depends on a time, and the twins agree; the pass timings are each unit's
  first run and least of three, summed over the units.
- The baseline is a separate process from the census's run: the census's own process times are not a baseline (the
  passes run three times and the twins once more).
</content>
</invoke>
