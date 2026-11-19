# C12a's gate: the preprocessor's twins, area by area (#2924)

C12's gate ([`../c-front-end-gate`](../c-front-end-gate)) sent the whole preprocessor to its scalar path: +14% to +20% of
a compile. A stage's total can hide a part whose vector path loses, so this gate sends each area of the preprocessor to
its scalar arms alone.

## Setup

**One experiment executable:** buster's C11a head `22f3d4625` plus [`c12a-areas-knob.patch`](c12a-areas-knob.patch)
(EXPERIMENT ONLY). It reads its areas' bits from its file's name (`compiler-areasN`), so `time-runs` compares copies of
one executable.

**The areas:** every path switch in `c_preprocessor.c`, `c_preprocessor_impl.c`, `c_preprocessor_history_impl.c` and
`c_files.c` takes one area's bit beside its flag (`BUSTER_VECTOR_AREA`, `BUSTER_SCALAR_AREA`):
- **10 preparation:** splices, the directive table and its pairing, raw candidates, named UCNs, `files_prepare`.
- **11 lexing:** `pp_lex_for_mode`, and the tokenizer's dollar handling.
- **12** diagnostic lines.
- **13 macros:** definitions, parameter indexes and `pp_is_macro`.
- **14 expansion:** substitution, pasting, arguments, object expansion, direct conditions and line copies.
- **15 stepping:** file and buffer runs, keywords and templates.
- **16** history.
- **17** printing and `#embed`'s text.
- **18** windowed preparation.
- **20** a control bit that no site reads.

The roots, `pp_prepare_options` and `pp_parameter_index_begin`, keep their flags.

**The run** ([`run.sh`](run.sh), [`logs.tar.gz`](logs.tar.gz)): 9700X, Release, every run under the lock on CPU 2.
- **Outputs:** `-E` of sqlite3.c, Lua's units and musl's units by every build, byte by byte. All are the same as no bit's.
- **Timings:** `ab`, three rounds, around `time-runs` of the twelve builds (three runs each), one list at a time.

## User cycles, each area's scalar arms against none

By round:

| Area | sqlite3.c | Lua's units | musl's units |
| --- | --- | --- | --- |
| preparation | 1.103, 1.099, 1.101 | 1.824, 1.829, 1.830 | 1.780, 1.785, 1.787 |
| lexing | 1.064, 1.058, 1.061 | 1.033, 1.034, 1.041 | 1.047, 1.051, 1.047 |
| diagnostic lines | 1.004, 1.003, 1.005 | 1.001, 1.001, 0.997 | 1.001, 1.004, 1.003 |
| **macros** | 1.002, 0.999, 1.001 | 1.005, 1.006, 1.004 | **0.992, 0.996, 0.992** |
| expansion | 1.130, 1.125, 1.129 | 1.114, 1.125, 1.122 | 1.062, 1.065, 1.065 |
| stepping | 1.193, 1.182, 1.189 | 1.040, 1.045, 1.043 | 1.024, 1.029, 1.032 |
| history | 1.005, 0.999, 1.009 | 0.997, 0.999, 1.000 | 1.001, 1.004, 1.008 |
| printing | 1.955, 1.951, 1.950 | 1.328, 1.336, 1.333 | 1.344, 1.341, 1.344 |
| windows | 1.049, 1.050, 1.048 | 0.996, 0.999, 1.005 | 1.000, 1.004, 1.003 |
| all of them | 3.647, 3.635, 3.644 | 2.331, 2.346, 2.344 | 2.272, 2.274, 2.274 |
| control | 1.003, 0.996, 1.004 | 0.998, 1.000, 1.000 | 1.000, 1.006, 1.001 |

- **The vector arms win clearly in seven areas.**
- **Diagnostic lines and history are at parity,** within the control's spread.
- **Macros' vector arms lose on musl's units,** below the control in every round.

## The macros' area, split

[`macros.sh`](macros.sh), [`c12a-macros-knob.patch`](c12a-macros-knob.patch), [`macros-logs.tar.gz`](macros-logs.tar.gz).
The area becomes three:
- 19 `pp_is_macro` (the name bitset or the macro table);
- 20 the parameter indexes;
- 21 `pp_define`'s body scan (`pp_scan_body_vector` or `_scalar`), which finds `##`, `#` and `__VA_OPT__` in a definition's
  replacement list.

| Sub-area | musl's units | Lua's units | Instructions, scalar against vector |
| --- | --- | --- | --- |
| all three | 0.989, 0.991, 0.995 | 1.005, 1.005, 1.004 | musl 57.5 M fewer |
| `pp_is_macro` | 0.998, 1.003, 1.005 | 0.999, 1.000, 0.997 | musl 5.7 M fewer |
| parameter indexes | 0.995, 1.001, 1.002 | 1.000, 0.997, 0.999 | musl 0.5 M more |
| **the body scan** | **0.985, 0.992, 0.993** | 1.001, 1.002, 1.000 | musl **52.2 M fewer**, Lua 1.0 M fewer |
| control | 1.000, 1.001, 1.008 | 1.003, 1.002, 1.000 | |

**`pp_is_macro` and the parameter indexes are at parity.**

**The body scan's vector arm loses on musl's units:** it retires 52 M more instructions over them.
- The scalar loop's cost grows with a body's tokens. The vector scan pays a fixed setup for each definition: a 64-token
  pass and its value loads' quarters. That setup dominates on short bodies.
- musl's headers define mostly constants. I haven't counted their bodies' lengths.

## A branch-free body scan doesn't fix it

[`scan.sh`](scan.sh), [`c12a-scan-knob.patch`](c12a-scan-knob.patch), [`scan-logs.tar.gz`](scan-logs.tar.gz).
- **The change:** the vector scan loads all four quarters' values, each masked to its identifiers, with no branch on the
  body.
- **Outputs:** the same.
- **musl's units:** the scalar scan still reads 0.991, 0.994 and 0.989 of the new vector scan's cycles, with the control
  at 1.008, 1.004 and 1.004. The new scan retires 21 M more instructions than the first.
- **Elsewhere:** the vector scan wins on Lua's units and sqlite3.c, where the scalar one reads 1.005 to 1.008 and 1.002
  to 1.005.

## Where it goes

Every area but the body scan has a vector path at least as fast as its scalar one. Under #2924's census rule, the body
scan's loss goes to the owner, with three options:
- **A per-file bitset** of `#`, `##` and `__VA_OPT__` tokens, made once by preparation's vectorized pass, so each
  definition's check is a test of a few bits. This is the design the data-parallel rule asks for.
- **Keep the scalar scan** as the one code, as with SEMI-NCA. It reads 0.2% to 0.8% slower on Lua's units and
  sqlite3.c.
- **Keep the vector scan alone,** with musl's `-E` about 1% slower.
