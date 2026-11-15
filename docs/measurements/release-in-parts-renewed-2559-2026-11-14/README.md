# Release in parts, renewed: step 5's gate (2026-11-14)

Step 5 of buster's `docs/stage1-build-design.md` ([buster#2559](https://github.com/buster14a/buster/issues/2559)),
measured again after the splitter was taken further ([buster#2624](https://github.com/buster14a/buster/issues/2624)),
in [buster#2715](https://github.com/buster14a/buster/pull/2715) (branch `claude/dazzling-albattani-nwbrr2`). The first
attempt is `release-in-parts-2559-2026-11-13` (buster-performance#482), whose `k5` splitter this starts from. Its gate:
the 9700X job's whole measure, every benchmark over its placements, inside its floor.

TODO-RESULT

## 1. What the splitter does now

Release builds every `main.c` unit in parts before the optimizer, as Develop does, with
`presplit --import 200 --simplified-size --constant-arguments --promote-arguments --copy-limit 40 --anchor 24 --cohere
150000 --spread 2 --keep-statics --benchmark-bodies` (and `--strip-debug` without debug information), and the join
drops what no part's live code refers to (`tools/codegen/unreferenced.c`). Each change was found by comparing the whole unit's
inlining remarks with its parts' (clang's `-Rpass=inline -Rpass-missed=inline`, every `main.c` unit; `scripts/local/`),
then the 9700X's instructions by function (`scripts/9700x/profile2.sh`):

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

**What the split can't reproduce.** The checker's unit compiles to 11.35 MB of code whole, 12.09 MB at ph4 and
11.49 MB now; the executable's `.text` is 48.54, 50.26 and 49.13 MB. What remains comes from interprocedural decisions
the whole unit makes after inlining, which no part can see: dead return values removed once every caller inlined or
dropped them, `fastcc` for local functions, the last-call bonus where the other caller dies after inlining
(`tier1_cfg_location_mode`), inline costs 25 higher for one more call left by attributes the whole unit inferred, the
cold call sites' threshold of 45 under another part's block frequencies (`dominators_scalar`), and 186 small functions
copied in several parts (193 KB). Instructions by function on the 9700X (`raw/9700x/results/profile/*.ph8.ins.all.txt`)
put `tier1-code-certificate`'s +0.70%, `sqlite-c-tier1`'s +0.48% and `ir-source`'s +0.34% there.

## 2. The 9700X

TODO-MEASURE

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
  pipeline).
- `scripts/9700x/`: the harness, run from `~/buster-fast-bench/2559-step5b-claude`: `build.sh`, `triage.sh`,
  `triage-queue.sh`, `bench.sh`, `plan.sh`, `analyze.sh`, `profile2.sh`, `annotate.sh`, `timed.sh`, `outputs.sh`,
  `envpad.sh`, `queue.sh`, `after.sh`, `lock.sh`, `env.sh`.
- `raw/local/inlining/`: the comparisons' summaries and pairs.
- `raw/9700x/results/`: builds, triages, profiles, annotations, A/B reports, timed builds, outputs, the queue's log.
