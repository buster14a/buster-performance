# A sanitizer build's parts planned for its longest part (#2639): 9700X, 2026-11-14

Clean native sanitizer builds of [buster](https://github.com/buster14a/buster) (`BUSTER_SANITIZER=memory|address|thread`,
`BUSTER_SANITIZER_OPTIMIZATION=3`, `--config Release`, `build.sh`'s 8 jobs, CI's toolchain: LLVM 23.1.4) at main `2ebfe68`
and with buster#2801, which plans a sanitizer build's checker and backend parts for the longest one; the per-function
code-generation traces the plan's cost was fit to; the splitter's A/B; and the checks that the code and Release are
unchanged. The design is in buster's `docs/commands/build.md`, "The plan of a sanitizer build's parts".

## Trees

| Directory on benchpress | Commit | Builds |
|---|---|---|
| `~/buster-fast-bench/2639-claude/src` | main `2ebfe68` | `main-*`, `main2-*`, `release2-g0-main`, the traces `trace2-*` |
| `~/buster-fast-bench/2639-claude/split` | buster#2801 at `357dd0c6` (the first cost) | `branch-*`, `branch2-*`, `release2-g0-branch`, `identity2-*` |
| the same worktree | buster#2801 at `1812c11b` (the cost fit to all three sanitizers) | `branch3-1-*`, `branch3-2-*`, `identity3-memory` |

`357dd0c6` is the branch's first two commits as `git am` applied them (`c1774d7`, `497c60f` on GitHub, with a comment
reworded); `1812c11b` adds the refit cost.

## Method

- Every run is one hold of the host lock through `~/buster-fast-bench/exclusive.sh`, by the scripts in `scripts/`
  (`queue-a.sh`, `queue-f.sh`, `queue-g.sh`, `queue-h.sh`, `queue-i.sh` ran them one after another, a hold each). Each
  run's directory has the lock's receipt (`exclusive.stderr`: the holder it waited for and the exit; no busy process
  was listed in any of them).
- **Clean builds** (`build-clean2.sh`): `rm -rf build/cmake/native-SANITIZER-O3`, then `BUSTER_HOST_ARCH=native
  BUSTER_SANITIZER=SANITIZER BUSTER_SANITIZER_OPTIMIZATION=3 ./build.sh --config Release`. `time.txt` is bash's `time`,
  `ninja_log` Ninja's, `summary.txt` each build's checker chain (`steps.sh`): its bitcode compile, the split, the eight
  code parts' times and when the joined object was done.
- **Traces** (`part-trace.sh`): the eight code parts of main's split of the checker unit, generated at once, part N on
  CPU N, by the build's own command for the part (`commands.txt`, from `ninja -f build-Release.ninja -t commands`) with
  `-ftime-trace -ftime-trace-granularity=0`. `functions.tsv` is every `OptFunction` event (part, function, µs; the code
  generator's pass managers give each function two), `features.tsv` each part's function definitions (`tools/features.c`:
  instructions, blocks and more; the last column is optnone), `align.tsv` the whole module's definitions in order with
  their alignment, size attributes and section (`tools/align.c`). The traces are `part*.json.xz`. The per-part wall time
  files are empty (`bc` isn't installed); each trace's `ExecuteCompiler` event has it.
- **The fit** (`fit2.py`, `grid3.py` to `grid6.py`, `rulecheck.py`, `parts.py`): a candidate cost plans the parts exactly as split.c
  does (`tools/plan.c`, split_cover and split_boundaries, with or without the alignment rule), and the plan's parts are
  scored by the measured times: each part's functions' code-generation time, plus its other time, fit per sanitizer
  from the traces as a fixed part and an amount per definition. `grid6.out` is the last grid, on the three sanitizers'
  9700X traces; `grid5.out` the one before, with MSan's container traces (`local/`).
- **The splitter's A/B** (`split-ab.sh`, `split-ab2-memory/`): main's splitter and the branch's, each as its build made
  it, on main's MSan checker bitcode, alternating in three holds, and the branch's with a sanitizer build's options.
- **Identity** (`identity.sh`, as the 2026-11-13 record's): each sanitizer's branch executable against main's: function
  symbols (address, size, name), sections, and the `.text` instructions without addresses and RIP-relative
  displacements. `functions-delta.py` of that record reads `a.functions.xz` and `b.functions.xz`.
- **Release** (`release-build2.sh`): `BUSTER_DEBUG_INFO=0 ./build.sh --config Release` on each tree, whose executable is
  reproducible across checkouts: `compiler.sha256`.
- **Local** (`local/`, a 4-CPU cloud container, Intel Xeon at 2.1 GHz, Ubuntu's clang 23.1.6 with
  `--target=x86_64-unknown-linux-gnu -march=znver5`): the first fit, on MSan's checker parts traced four at a time
  (`run-parts.sh`), and the compiles of the first cost's plans (`run-plans.sh`). `tools/split-timed.patch` is the
  phase timing that measured the split locally (its parse 18.1 s of 38.1 s).

## Results

### Clean builds on the 9700X

| Build | main `2ebfe68` | buster#2801 `1812c11b` | Longest checker part, main | buster#2801 |
| --- | ---: | ---: | ---: | ---: |
| native MSan | 151.3, 149.3 s | **143.8, 143.5 s** | 37.3, 36.2 s | **30.8, 30.8 s** |
| native ASan | 162.9, 161.7 s | **157.0, 157.5 s** | 20.0, 19.8 s | **17.5, 17.7 s** |
| native TSan | 65.3, 65.3 s | **64.4 s** | 8.2, 8.2 s | **7.7 s** |

The first cost (`357dd0c6`) built MSan in 147.9 and 143.4 s, ASan in 160.9 and 160.9 s, TSan in 64.5 and 64.3 s: its
ASan plan left the part with the 1,524 optnone tests at 19.4 s. The bitcode compiles of the refit's ASan builds took
127.4 and 127.7 s against 129.1 to 130.4 s in the others, the same command: 2 s of the ASan difference is that.
`summary.txt` has every build's chain.

User time is the same within 1% (MSan 828 to 839 s, ASan 653 to 662 s, TSan 288 to 290 s): the parts hold the same
functions, so a build bound by its work, as a hosted runner's 4 CPUs are, gains little.

### Where the parts' time goes (`trace2-*`, main's parts)

| Sanitizer | ms per instruction, 300 to 1,000 | over 30,000 | optnone's, against the others' | other time per definition |
| --- | ---: | ---: | ---: | ---: |
| MSan | 0.013 | 0.036 | 13% | 1.22 ms |
| ASan | 0.011 | 0.031 | 22% | 0.99 ms |
| TSan | 0.015 | 0.034 | 18% | 0.40 ms |

Each cost's plan, scored by the measured times: the longest part's time (its functions' code generation plus its other
time), against an even eighth of the eight parts' (`rulecheck.py`):

| Plan | MSan | ASan | TSan |
| --- | ---: | ---: | ---: |
| instruction count, the alignment rule (main's) | 35.7 s | 19.5 s | 8.7 s |
| instruction count, `--padded-starts` | 36.5 s | 18.6 s | 8.0 s |
| first cost (instructions, 2 a block, their square / 50,000, 30), `--padded-starts` | 30.3 s | 18.7 s | 7.5 s |
| refit (instructions, their square / 50,000, 60), the alignment rule | 33.1 s | 17.3 s | 8.4 s |
| refit, `--padded-starts` (buster#2801) | **29.6 s** | **15.8 s** | **7.4 s** |
| the measured times themselves, `--padded-starts` | 28.1 s | 14.9 s | 7.0 s |
| an even share | 27.8 s | 14.7 s | 7.0 s |

### The alignment rule

Release's plan starts each part at a function of the greatest alignment it holds, so that the relocatable link adds no
padding. MSan's checker module holds fifteen `aligned(64)` functions, all within definitions 2445 to 2508 (`align.tsv`):
the part holding any of them had to start at the first, so main's plan put a boundary there and left part 4 with 45
definitions, a sixth of the others' cost (`split-memory-checker/report.txt`). Planned by the measured times themselves,
the rule costs the longest part 30.3 s against 28.1 s (MSan), 17.0 against 14.9 s (ASan) and 7.6 against 7.0 s
(TSan); the refit cost's plans lose 3.5, 1.5 and 1.0 s to it.

### The splitter (`split-ab2-memory/`)

| Splitter | Wall | User | System |
| --- | ---: | ---: | ---: |
| main's | 11.06, 10.40, 10.36 s | 29.2, 28.4, 28.5 s | 8.3, 7.4, 7.4 s |
| the branch's (`split_delete_blocks`) | 10.71, 10.16, 10.21 s | 27.2, 26.3, 26.3 s | 7.7, 7.6, 7.7 s |
| the branch's, `--codegen-costs --padded-starts` | 10.43, 10.49, 10.79 s | 26.6, 26.8, 26.4 s | 8.0, 7.8, 8.0 s |

Main's and the branch's parts are the same bytes in every round (`compare-*.txt`). Half the split's wall time is parsing
the module (locally 18.1 of 38.1 s), which the parts' children need whole: the module's use-list order, which the code
generator follows, is only read with every function.

### Identity (`identity2-*`, `identity3-memory`)

Each branch executable has main's functions in main's order. With the first cost (`identity2-*`) every one is the same
size but `check_lower_switch_tables` in MSan's (12,430 bytes against 12,414), whose blocks aligned beyond its
function's alignment padded differently after its part's start moved; with the refit (`identity3-memory`) every MSan
function is the same size. The `.text` instructions are the same but for padding (`int3` between parts, `nop`s) and,
in ASan's fixed-address executable, the moved data's addresses. Functions moved by 0 to 256 bytes, by part.

### Release (`release2-g0-*`)

Main's and the branch's Release executables without debug information are the same bytes (SHA-256
`445711f3a3b882b0…`), built in 59.3 and 59.2 s.
