# C12's gate: the front end's stages against their scalar paths (#2924)

[`run.sh`](run.sh) ran on the 9700X with one experiment executable: main `0c113feb1` plus
[`c12-areas-knob.patch`](c12-areas-knob.patch). The executable reads which stages take their scalar path from its own
file's name (`compiler-areasN`, `/proc/self/exe`), so eight same-bytes copies are the eight settings, and `time-runs`
orders them in its Williams design without wrappers or environment variables.

A stage's bit replaces the driver's `--scalar` where the driver hands the flag to that stage, so it reaches both the
`BUSTER_SCALAR_PATH` sites and the plain tests of the flag:

| Bit | Stage | Where the driver hands it the flag |
| --- | --- | --- |
| 1 | the preprocessor | `pp_initialize`'s `vectorized` |
| 2 | the parser, and the reader's parts that read the parser's flag | `ParseOptions.scalar` |
| 3 | the lazy planner (`-flazy-system-headers` only) | `check_lazy_eager`, `check_lazy_plan` |
| 4 | the checker (the reader, bindings, warnings, attested declarations) | `CheckOptions.scalar`, the rejected unit's common warnings |
| 5 | the static data | `check_data_prepare` |
| 6 | the program and its lowering | the program's options |
| 7 | selection, target features and aliases | `check_program_select_*`, the census, `check_driver_target_features`, `check_driver_aliases` |

Emission (Tier 0, Tier 1, the IR, encoding) keeps the command's flag: its twins are C7 to C10's.

Release, every run under the lock on CPU 2.

## Objects

`-c --lanes 1` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c` by every build: with each bit, 1,372 of
1,372 objects are byte-identical to no bit's ([`logs/status.txt`](logs/status.txt)). With `-flazy-system-headers`
(sqlite3.c and Lua), the lazy bit's 35 of 35 are too ([`logs/status-lazy.txt`](logs/status-lazy.txt)).

## Whole compiles

`ab`, three rounds, around `time-runs` of the eight builds (three runs each), one list at a time: sqlite3.c, Lua's units
and musl's units, `-c --lanes 1` ([`logs/time-*.log`](logs/)). User cycles with the stage's scalar path against none, by
round, and the instructions' median against none:

| Stage | sqlite3.c | Lua | musl | Instructions (sqlite3.c, Lua, musl) |
| --- | --- | --- | --- | --- |
| Preprocessor | +19.34, +19.40, +19.63% | +14.40, +14.19, +14.07% | +17.73, +17.13, +17.62% | +25.3, +24.6, +28.5% |
| Parser | +116.8, +117.7, +118.2% | +95.7, +95.8, +95.2% | +83.8, +83.7, +83.7% | +213, +160, +146% |
| Checker | +3.66, +3.76, +3.57% | +1.95, +1.71, +1.70% | +1.77, +1.51, +1.62% | +7.26, +3.04, +3.18% |
| Static data | −0.01, +0.17, +0.14% | +0.39, +0.22, +0.24% | +0.42, +0.32, +0.25% | +0.40, +0.29, +0.28% |
| Program and lowering | +3.97, +4.22, +5.20% | +2.73, +2.75, +2.40% | +3.10, +2.11, +2.48% | +7.38, +4.27, +3.67% |
| Selection | −0.48, −0.12, +0.30% | +0.14, +0.15, −0.24% | +0.28, +0.16, +0.25% | +0.10, +0.07, +0.06% |
| Lazy planner, not run (the control) | −0.01, −0.33, −0.07% | −0.12, +0.17, −0.17% | +0.02, +0.18, −0.04% | 0.000% |

Without `-flazy-system-headers` the lazy planner doesn't run, so its bit leaves every instruction as it was: that row is
the same code in both, a control for the others, and it reads within ±0.33%.

**The lazy planner, run** ([`lazy.sh`](lazy.sh), `-flazy-system-headers`, the same method with the two builds):

| Stage | sqlite3.c | Lua | Instructions (sqlite3.c, Lua) |
| --- | --- | --- | --- |
| Lazy planner | +0.11, +0.08, +0.14% | +0.49, +0.31, +0.38% | +0.75, +1.48% |

## Verdicts

- **The preprocessor, the parser, the checker, the program and its lowering, and the lazy planner:** the scalar path
  costs more in every round of every list.
- **The static data:** its scalar path retires 0.28% to 0.40% more instructions in every list and reads more cycles in
  eight rounds of nine (−0.01% to +0.42%). Most of those rounds are within the control's spread.
- **Selection:** at parity. Its rounds read −0.48% to +0.30%, within the control's spread; musl's three are positive,
  sqlite3.c's mixed. The scalar path retires 0.06% to 0.10% more instructions in every list.

These are stages, not functions: a stage's total can hide a sub-area whose own vector path loses, as the checker's
twins span some thirty files.
