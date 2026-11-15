# Release in parts, renewed: step 5's gate (2026-11-14)

Step 5 of buster's `docs/stage1-build-design.md` ([buster#2559](https://github.com/buster14a/buster/issues/2559)),
measured again after the splitter was taken further ([buster#2624](https://github.com/buster14a/buster/issues/2624)),
in [buster#2715](https://github.com/buster14a/buster/pull/2715) (branch `claude/dazzling-albattani-nwbrr2`). The first
attempt is `release-in-parts-2559-2026-11-13` (buster-performance#482), whose `k5` splitter this starts from. Its gate:
the 9700X job's whole measure, every benchmark over its placements, inside its floor.

**Result: the gate still fails, by less.** With the splitter of buster#2715's head `0d32b96` (`ph8`), 11 of 69
benchmarks ran more user cycles than the whole units' Release outside their floors (ph4, the start of this round:
12), 8 ran fewer, and the 69 commands' outputs were the same. Four of the 11 run more instructions
(`tier1-code-certificate` +0.70%, `sqlite-c-tier1` +0.48%, `ir-source` +0.34%, `sqlite-c` +0.17%), and `ir-lowering`
runs as many in other code: interprocedural decisions the whole unit makes after inlining, which a part can't see
(section 1's last paragraph). The other six are layout, a 1 ms process's counters, or noise. Release in parts rebuilds
the checker's unit after an edit in 33.1 s against 63.6 s with debug information, 18.2 s against 50.6 s without, and
builds clean in 68.1 s against 73.7 s (53.4 against 57.3).

## 1. What the splitter does now

Release builds every `main.c` unit in parts before the optimizer, as Develop does, with `presplit --import 200
--simplified-size --constant-arguments --promote-arguments --copy-limit 40 --anchor 24 --cohere 150000 --spread 2
--keep-statics --benchmark-bodies` (and `--strip-debug` without debug information), and the join drops what no part's
live code refers to (`tools/codegen/unreferenced.c`). Each change was found by comparing the whole unit's inlining
remarks with its parts' (clang's `-Rpass=inline -Rpass-missed=inline`, every `main.c` unit; `scripts/local/`), then the
9700X's instructions by function (`scripts/9700x/profile2.sh`):

| Change | Why (whole unit against parts) |
| --- | --- |
| `k5`'s local copies, readable tables' constants, keep-statics, benchmark bodies | buster-performance#482 |
| Phantom callers | A copy had fewer uses than the whole module's function: `arena_reserve_small` went into `scratch_begin` (cost 60 → 1,350) and `arena_reserve` (5 → 970) as their last call, which then stayed outlined in the assembler |
| Phantoms pass their own parameters, ignore the result | Poison arguments let IPSCCP specialize a copy (`tier1_select_induction_bounds`); a used result blocked dead argument elimination |
| keep-statics only for callees the whole module calls once | `type_derive`'s many callers had kept `type_pointer` (8 instructions) out of every part but its own |
| Kept bodies also kept from benchmark reads | `foreign_gc_link`'s five single-call phases |
| The input's `available_externally` bodies in every code part | `pthread_equal`, `bsearch`; `printf("\n")` becomes `putchar('\n')`, whose body was missing |
| `--simplified-size` | `arena_release` (79 inlined sites) was one instruction over the raw limit; `asm_word_registers_vector` (721 raw, 337 after SROA) inlines at a threshold of 1,574 (LLVM's vector bonus) |
| `--constant-arguments` | An alias hides a static function's callers from IPSCCP: the whole unit folded `instruction_is_valid`'s flags into `mode_register_is_valid` (cost 195 against the parts' 265 to 290) |
| `--promote-arguments` | The whole unit passed `check_action_operand_value`'s 96-byte operand in `zmm0` and `ymm1`; the parts, calling it through its alias, passed a pointer, whose wide loads missed store forwarding (`check-units` +0.72%, `checker-source-musl` +1.85% user cycles). A forked child inlines the always-inline calls and runs argument promotion; the parent promotes the functions it reports. Copying them into their callers' parts instead (`--copy-promoted`, ph2) gave `check_action_operand_value` 20 copies and cost `backend-source` 1.1% |
| `--copy-limit 40` | Local copies grew the checker's unit by 1.21 MB, 1.19 of it the same function copied in several parts; past one part, only bodies of up to 40 instructions or with one call are copied (0.31 MB) |
| always_inline bodies always copied, and the limit weighs a body with them | An always_inline function past the limit stayed in its owner part, alive through its alias though every call was inlined (342 KB); `tier1_allocate_impl` weighed 22 KB once its always_inline callees were inlined, in three parts |
| The join's unreferenced sections (`unreferenced.c`) | An owner part keeps a local function alive through its alias even where every part inlined or folded its calls: relocations from every other allocated section reach what is live, and the rest (170 sections, 115 KB) goes in the `-r` link's `/DISCARD/` |
| Start-order names `.text.NAME.buster_split` | A part's optimizer folds a function into its alias: 368 of the start list's 511 functions had only the alias's section, so the start region held 197 KB of functions against the whole build's 787 (ph8: 874) |

`raw/local/inlining/summary.txt` has each unit's pairs the whole unit inlines and no part does (`missing`, and those
outside tests) and the reverse (`extra`), for the versions p5, p7 and p8 (`*.log` for p1, p2, p10). With `k5` the
assembler's unit missed 51 pairs; with p7 7, all in tests.

**What didn't work: `--simplify-first`** (head3, `506f2943`) ran the `-O3` pipeline's simplification before the
inliner on the whole unit before the split. It fixed the assembler, but the parts then simplified the module a second
time, which reshaped other code: `benchmark-environments` +2.65% user cycles (+2.43% to +2.90% over the placements,
floor ±0.26%) and 1,450 lines of `run_c_environment_benchmark`'s IR before the inliner differed from the whole unit's
(62 without it). `--constant-arguments` takes from a forked child's SROA and IPSCCP only the arguments every call passes
as one constant (310 in the checker's unit, 5.9 s locally against 12.2 s for a cloned module).

**Also didn't pay:** copies only for functions one part calls (their `available_externally` reads lose argument
promotion: 121 more missing pairs); `--copy-limit 1000` (25% more code); running `function-attrs`, or `ipsccp` with
`globaldce`, on the whole unit before the split (missing pairs 425 → 738; 22 functions); `ld.lld -r --gc-sections`
for the join (a relocatable link keeps every global symbol as a root, the aliases among them).

**What the split can't reproduce.** The checker's unit compiles to 11.35 MB of code whole, 12.09 MB at ph4 and 11.49 MB
now; the executable's code (its `.text` sections) is 36.92, 38.43 and 37.38 MB. What remains comes from interprocedural
decisions the whole unit makes after inlining, which no part can see: dead return values removed once every caller
inlined or dropped them, `fastcc` for local functions, the last-call bonus where the other caller dies after inlining
(`tier1_cfg_location_mode`), inline costs 25 higher for one more call left by attributes the whole unit inferred, the
cold call sites' threshold of 45 under another part's block frequencies (`dominators_scalar`), and 186 small functions
copied in several parts (193 KB). Instructions by function on the 9700X (`raw/9700x/results/profile/*.ph8.ins.all.txt`)
put `tier1-code-certificate`'s +0.70%, `sqlite-c-tier1`'s +0.48% and `ir-source`'s +0.34% there.

## 2. The 9700X

Every run under the 9700X's lock, BASE `p` (main with buster#2733, the units whole: `scripts/9700x/build.sh`) against
CANDIDATE `ph8` (the same tree, `154efaed`, with `0d32b96`'s `tools/codegen/presplit.c`, `unreferenced.c` and
`cmake/BusterCodegen*.cmake`, `BusterStartOrder.cmake`), each at the job's four placements; `bench.sh` runs base, head
and base again in each hold, `analyze.sh` gives each build's median over runs and placements and the head's range over
the placements against the base's, with base-again's as the floor (`raw/9700x/results/ab-ph8.txt`; queues `q38`,
`q42`). `analyze.sh` divides by zero where a benchmark's user cycles read 0 or it ran one placement a hold; those four
are computed from `bench/` by hand below. `triage-ph8.txt` has each benchmark's user instructions and cycles, one
process at placement 0.

Slower, outside the floor:

| Benchmark | User cycles | Over the placements | Base again | Instructions | Why |
| --- | --- | --- | --- | --- | --- |
| `tier1-code-certificate` | +1.39% | +1.18% .. +1.69% | -0.15% | +0.70% | `tier1_certificate_emitted_debug` and `_check` +2%; `tier1_cfg_location_mode`, `tier1_cfg_edge_stage`, `dominators_scalar` outlined (the whole unit inlines them after another caller dies, or at its cold threshold) |
| `ir-lowering` | +1.00% | +0.76% .. +1.42% | +0.02% | -0.01% | Same calls, other code: `ir_lower_typed_target_path` is `internal fastcc` with two `nonnull` arguments whole, `hidden` and C-convention in its part; the benchmark's own ns per entry are 0.3% to 1.5% slower in every variant (`scratch/irlow-out.txt`) |
| `sqlite-c-tier1` | +0.77% | +0.55% .. +0.89% | -0.04% | +0.48% | `ssa_prepare_path`, `dominators_scalar` outlined; `tier1_cfg_finish` |
| `lowering-source` | +0.72% | -0.55% .. +1.76% | +0.10% | -0.11% | Fewer instructions; the range holds 0 |
| `ir-source` | +0.55% | +0.15% .. +1.08% | -0.19% | +0.34% | `ir_gvn_compare` (cost 430) the whole unit inlines into `ir_optimize_gvn` at one call site's threshold of 525: too big to import |
| `sqlite-c` | +0.51% | +0.33% .. +0.97% | +0.03% | +0.17% | As `sqlite-c-tier1`'s, smaller |
| `environments` | +1.31% | +0.81% .. +1.98% | -0.18% | +0.00% | Layout: `run_c_environment_benchmark`'s loop is the same code 32 bytes later in its lines (a call site whose callee the whole unit had dropped two arguments of, and a lookup table it made relative: `scratch/env-*.s`); section 3 |
| `parser-pragma` | +4.81% | +4.27% .. +5.63% | +0.06% | -0.45% | A 1.1 ms process: `perf stat -r 40` counts 3.18 M cycles against main's 3.19 M, with 18% fewer instruction cache misses (`scratch/parser-pragma-perf-stat.txt`); only under the benchmark's own counters does it run slower |
| `foreign` | +0.39% | +0.06% .. +0.68% | +0.37% | -0.00% | The base itself moved +0.37%; the profiles agree within 0.2% |
| `checker-wide` | +0.25% | +0.09% .. +0.72% | -0.02% | -0.00% | Same instructions |
| `checker-bindings-small` | +0.05% | +0.02% .. +0.12% | -0.00% | +0.01% | |

Faster, outside the floor: `debug` -5.65%, `lexer` -3.95%, `check-debug` -1.16%, `assembler` -0.88% (3.07% fewer
instructions), `x86-zen5` -0.38% wall (it sizes its own run), `foreign-strings` -0.37%, `ssa` -0.35%, `lowering`
-0.17%. By hand: `parser-main` -0.20% .. +0.40% user time (base again to -0.42%), `calling-convention` -1.55% ..
+0.93%, `dominators` -1.11% .. +4.62% (base again -0.80% .. +2.32%): inside. `x86-zen5`, `ir-lowering`'s other runs,
`ir`, `dominators-cfg` and `types` size their repetitions by time, so their instruction totals aren't comparable
between builds; `ir-lowering` ran the same repetitions in the gate.

The previous rounds' gates, same harness and base: `ab-ph.txt` (`154efaed`, the first merge), `ab-ph2.txt`
(`--copy-promoted`), `ab-ph4.txt` (12 slower outside: `debug` +9.4%, `parser-pragma` +5.8%, `tier1-code-certificate`
+1.3%, `parser-bindings-sqlite` +1.2%, `sqlite-c-tier1` +1.0%, `lowering-source` +0.9%, `ir-lowering` +0.9%,
`ir-source` +0.7%, `foreign-strings` +0.5%, `sqlite-c` +0.4% wall, `checker-deferred` +0.3% wall, `check-units`
+0.3% wall). `debug` +9.4% at ph4 and -5.65% at ph8 with the same instructions both times is layout: its
`debug_line` loop was 32 bytes into its line at ph4, at 0 in main; the job's placements, multiples of 64, never move it
within a line.

Builds (`timed.sh`, the host's clang as the design's records, eight jobs; `results/timed.txt`, trees `tp` and `tph8`):

| Release | Main, whole units | In parts (`ph8`) |
| --- | --- | --- |
| Clean, `-g` | 73.7 s (436 s user) | 68.1 s (503 s) |
| `c_check_input.c` edited, `-g` | 63.6 s (9 jobs) | 33.1 s (47 parts) |
| Clean, without debug information | 57.3 s (306 s) | 53.4 s (398 s) |
| `c_check_input.c` edited, without | 50.6 s | 18.2 s (1 part) |

A no-op build takes 0.04 s either way, and undoing the edit gives the clean build's executable byte for byte (SHA-256 in
`timed.txt`). The executable's code is 37.38 MB in parts against 36.92 MB whole (with read-only data, 49.13 against
48.54).

## 3. Layout, and the placements

Head4 (`0c0374ca`) ran `benchmark-environments` +1.71% and `benchmark-unwind` +2.57% user cycles, outside their floors,
with the same instructions as main: their hot loops were the same code at another offset within their 64-byte lines.
The 9700X job's placements moved none of `.text`'s code (buster#2728, fixed by buster#2733; the record
`start-order-placements-2728-2026-11-14`), and multiples of 64 can't move code within a line anyway. Main itself,
with a dead function of 16 to 48 bytes moving `run_c_environment_benchmark` within its line, ran `benchmark-environments`
up to +1.72% and `benchmark-unwind` up to +4.79%. The gate below compares #2733 against #2733 with #2715, so that both
sides' placements move `.text`.

## Files

- `scripts/local/`: `inline_diff.sh` and `all_units.sh` (the remarks' comparison), `whole.sh`, `build-presplit.sh`,
  `sizes.py` and `sizes_cmp.py` (functions' sizes whole and in parts), `presimplify.txt` (`--simplify-first`'s
  pipeline), `eval.sh` (a unit's parts, the join's unreferenced sections and the joined code against the whole unit's),
  `runpasses.c` (a pipeline of LLVM's on a bitcode file, against the toolchain's LLVM), `oracle_attrs.py`,
  `attr_cmp.py`, `attr_pre.py`, `fn_size.py`, `fn_calls.py` (the attributes' experiment).
- `scripts/9700x/`: the harness, run from `~/buster-fast-bench/2559-step5b-claude`: `build.sh`, `build-pad.sh`,
  `triage.sh`, `triage-queue.sh`, `bench.sh`, `plan.sh`, `analyze.sh`, `profile*.sh`, `annotate.sh`, `fe.sh`,
  `timed.sh`, `outputs.sh`, `envpad.sh`, `padbench.sh`, `padsummary.sh`, `queue.sh`, `after.sh`, `lock.sh`, `env.sh`,
  and the queues `q*.txt` (`q38.txt` and `q42.txt` are ph8's gate).
- `raw/local/inlining/`: the comparisons' summaries and pairs.
- `raw/local/attributes/summary.txt`: the parts' inferred function attributes against the whole unit's (below).
- `raw/9700x/results/`: builds, triages, profiles, annotations, A/B reports (`ab-*.txt`, `bench/`), timed builds,
  outputs, pads (`pad/`), the queue's log.
- `raw/9700x/scratch/`: `ir-lowering`'s own output by both builds, `run_c_environment_benchmark`'s code by both,
  `parser-pragma` under `perf stat`.

## Attributes across parts

A part reads another part's function as a declaration, or as an `available_externally` body, which LLVM's attribute
inference treats as inexact: what the whole unit infers for them (`memory(...)`, `nofree`, `nosync`) a part doesn't,
nor for its own functions that call them. In the backend's unit 145 of the parts' 1,586 definitions ended with weaker
attributes than the whole unit's. The whole unit's own attributes on the parts' imports left 5; inferring them before
the split (SROA, EarlyCSE, InstCombine, SimplifyCFG and the attribute passes on the whole module, 4.1 s) left 23. But
the hot functions of the slower benchmarks above compiled the same either way (`raw/local/attributes/summary.txt`), so
the splitter doesn't do it.
