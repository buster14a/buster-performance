# check-input's per-token passes outside the walks, Buster #529

- **Compiler issue:** [#529](https://github.com/buster14a/buster/issues/529).
- **Compiler PR:** [#1563](https://github.com/buster14a/buster/pull/1563).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`, 706,237 tokens) with the CI's options:
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

Sources:

| label | revision | what |
| --- | --- | --- |
| main | `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b` | the base |
| pr1530 | `e94fd0d2bcada50d237ac14206a32cf2b68dc1ff` | #1530's head (#1489), profiled to see what is left after it; not part of #1563 |
| final | `bafa48bddc4609aeead329b09a3aac4d3a2b8bd3` | #1563's code (its later head `04a90560` changes documentation only) |

Executables' SHA-256 are in `raw/*/identity.txt` and `ab/inputs.sha`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, governor `performance`, THP `always`, clang 23.1.1, perf 7.2.9 (`host.txt`).
- **Builds.** Each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh` (debug information on), under the
  host's lock for the build alone (`scripts/prof.sh`).

**Profiles** (`scripts/prof.sh`, each step under its own hold of the lock):
- `measure-compile --runs 11`, giving `raw/*/measure.txt`.
- `perf record -F 20000` of five compiles, giving `raw/*/symbol.txt`, by symbol.
- `perf script -F ip,sym,symoff,dso` of the same data, giving `profile/*-samples.txt`.
- The samples mapped to their inlined frames and lines with `llvm-symbolizer --inlining`
  (`scripts/sym.py`, run off the host on the executables copied from it), giving `profile/*-breakdown.txt`.

**The A/B** (`scripts/ab.sh`):
- **Rounds.** Interleaved rounds of `perf stat -r 3` of each executable, the order alternating by round, then
  `measure-compile --runs 11` each way.
- **Lock receipts.** Every run takes the lock on its own and writes, inside the hold, a receipt
  (`ab/*.receipt`): the time, `BUSTER_9700X_HELD` and the owner file, then the run's status.

**The PR's own 9700X job** (`ci/job-128118533298.log`, run 42281737894) ran #1050's comparison: main and the PR
merged into it (`3f3fe0ac`), five runs each over four placements of the checker's unit and two copies of each
executable, with a second copy of main (`main-again`) as the control; `cmp` of the two objects; and
`measure-compile` of each.

## Results

### Where check-input went at main (`profile/main-ec5f0f6b-breakdown.txt`)

`check-input` took 59.508 ms of the 138.761 ms span. Shares of all of the five compiles' 12,994 samples:

| where | share |
| --- | ---: |
| `check_input_run`'s own (inlined passes) | 7.49% |
| · `check_input_deprecated_uses` (#1489's, #1530) | 5.68% |
| · `check_input_declaration_starts` | 0.83% |
| · `check_input_system_tokens` | 0.31% |
| · the enumeration lists (its lines at the end) | about 0.27% |
| `check_input_resolve_range` | 4.81% (no line above 0.35%) |
| `check_input_declarator_step`, `_declaration`, `_specifiers`, `_declarator` | 4.4% together |
| `check_input_asm_labels` (its two kernels) | 0.45% |
| `check_input_count_tokens` | 0.33% |

With #1530 (`raw/pr1530`), `check-input` took 50.493 ms. Its `check_input_run` was 3.03%, of which the
deprecated uses were 1.01% and the declaration starts 0.91% (`profile/pr1530-e94fd0d2-breakdown.txt`).

### The change, by the PR's 9700X job

| measure | main | change | difference |
| --- | ---: | ---: | ---: |
| wall time, 40 runs | 140.452 ms | 137.472 ms | −2.12% (−2.37% to −2.05% by placement) |
| user cycles | 679.854 M | 663.132 M | −2.46% |
| user instructions | 1,636.44 M | 1,606.84 M | −1.81% |
| minor faults | 6,619 | 6,093 | −526 |
| `check-input`, 11 stage runs | 59.862 ms | 57.201 ms | −2.66 ms |
| `check-input`'s minor faults | 3,905 | 3,379 | −526 |

The control (`main-again`) was within 0.09% of main's wall time and 0.15% of its cycles. The objects are the same
bytes (the step's `cmp`).

### The change, by this record's A/B (`ab/`)

These are the four rounds complete when the record was published. Rounds 5 to 8 and the two `measure-compile` runs
were still waiting for the lock then.

| round | task clock (ms) | user cycles | user instructions |
| --- | --- | ---: | ---: |
| 1 (main first) | 139.38 → 137.11 | −1.99% | −1.81% |
| 2 (change first) | 139.27 → 136.71 | −2.54% | −1.81% |
| 3 (main first) | 139.13 → 136.90 | −1.76% | −1.81% |
| 4 (change first) | 139.50 → 138.16 | −2.51% | −1.81% |

- **Medians of the four.** The task clock is 139.3 → 137.0 ms, the user cycles 677.56 → 662.29 M, and the
  user instructions 1,636.34 → 1,606.79 M.
- **The objects.** Main's and the change's are the same bytes (`ab/objects-so-far.sha`, and `raw/*/object.sha`
  from the profiles' compiles).

### The faults

The 526 fewer faults are the enumeration lists'. They read every token's tag (`tag_types`), a column of the rare
columns' arena in base pages that only tags' keywords write, so they mapped its every page. The change reads it only
at `enum` keywords. The other passes touch the pages they touched before.

## Limitations

- **One host, one workload.** The A/B ran at one placement each. The PR's job covers four placements.
- **The A/B was incomplete at publication.** Its remaining rounds may be added to this directory later.
- **The profiles' `measure-compile` runs aren't comparisons.** `raw/*/measure.txt` came from separate holds at
  different times.
- **No combined measurement with #1530.** The change was not measured on top of #1530.

---
Agent session: [private session](https://claude.ai/code/session_01NNmNQsNvZdHz21NdNAp8kc)
Model: Anthropic / claude-opus-5-5
