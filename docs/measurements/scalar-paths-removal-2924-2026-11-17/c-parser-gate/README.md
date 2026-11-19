# C12b's gate: the parser's own scalar sites (#2924)

C12's gate ([`../c-front-end-gate`](../c-front-end-gate)) sent the whole parser to its scalar path. This gate sends each
of the parser's own scalar sites to its scalar arm alone, and times each kernel against its twin.

## Setup

**One experiment executable:** buster's C12a head `5afd0cb8c` plus [`c12b-areas-knob.patch`](c12b-areas-knob.patch)
(EXPERIMENT ONLY). It reads its sites' bits from its file's name (`compiler-areasN`), so `time-runs` compares copies of
one executable.

**The sites** (bit k, mask 1 << k):
- **20 whole:** the whole unit by `parse_scalar`, the "scalar parser alone" mode.
- **21 handoff:** the conversion's twin, `parse_tokens_from_output_scalar`.
- **22 scopes:** clang's scope numbers' scan (`parse_clang_scope_numbers`).
- **23 gnu:** the GNU records' candidates and collection (`gnu_syntax_build`). No compile builds the records
  (`ParseOptions.extension_metadata` is set only by `benchmark-gnu` and the fuzzer), so `benchmark-gnu` times them.
- **all** four (15728640), and a **control** bit that no site reads (1 << 24).

**The runs:** 9700X, Release, every run under the lock on CPU 2.
- [`run.sh`](run.sh): `-c` objects of sqlite3.c, Lua's units and musl's units by every build, byte by byte, and
  `benchmark-parser` (the stock paths and each kernel's twin) on sqlite3.c, buster's `main.c`, Lua's `lapi.c` and musl's
  `strlen.c`, three times each. Its timings (`logs/time-*.log`) are invalid: `time-runs --copies` renames the copies, and
  the knob reads the name.
- [`time2.sh`](time2.sh): the timings again without `--copies`: `ab`, three rounds, around `time-runs` of the seven
  builds (three runs each), one list at a time.
- [`gnu.sh`](gnu.sh): `benchmark-gnu` on the same four inputs, three times each.

Everything is in [`logs.tar.gz`](logs.tar.gz) (`logs/`, `logs2/`, `logs3/`).

## Results

**Objects:** every build gives the objects of no bit, 1,371 of 1,371 each.

**Whole compiles** (`logs2/`), user cycles of each site's scalar arm against no bit, three rounds:

| List | whole | handoff | scopes | gnu | control |
| --- | --- | --- | --- | --- | --- |
| `parse -fsyntax-only` sqlite3.c | +49.3%, +49.8%, +49.1% | +17.3%, +16.6%, +16.5% | +5.3%, +4.5%, +5.0% | −0.1%, −0.1%, −0.2% | −0.2%, −0.2%, +1.0% |
| `parse -fsyntax-only` buster's `main.c` | +36.7%, +37.3%, +36.7% | +14.6%, +14.6%, +14.1% | +3.7%, +4.1%, +4.0% | −0.2%, −0.3%, −0.4% | −0.1%, +0.1%, −0.2% |
| `-fsyntax-only` Lua's units | +8.1%, +8.3%, +8.2% | +2.6%, +2.7%, +2.6% | +0.7%, +0.9%, +0.8% | −0.1%, +0.1%, −0.0% | +0.2%, +0.1%, −0.0% |
| `-fsyntax-only` musl's units | +8.2%, +8.3%, +8.5% | +2.7%, +2.7%, +2.7% | +0.7%, +0.7%, +0.8% | +0.1%, +0.3%, −0.1% | +0.2%, +0.0%, −0.0% |
| `-c` sqlite3.c | +5.0%, +5.0%, +5.0% | +1.9%, +2.0%, +1.7% | +0.6%, +0.7%, +0.6% | +0.2%, +0.1%, +0.1% | −0.0%, −0.0%, −0.1% |
| `-c` musl's units | +7.4%, +6.8%, +7.5% | +2.2%, +1.9%, +2.7% | +0.6%, +0.0%, +0.6% | +0.1%, −0.2%, +0.3% | −0.1%, −0.3%, +0.0% |

The scalar arms retire more instructions in every list (the whole unit +14% to +113%, the handoff +2.7% to +21.5%, the
scopes +0.6% to +5.2%). The gnu bit and the control change no instruction: no compile reaches either.

**The GNU records** (`logs3/`), `benchmark-gnu` cycles a token, scalar candidates against vector, three runs:

| Input | collect | build |
| --- | --- | --- |
| sqlite3.c | 1.71–1.74 against 0.21–0.22 (7.9 to 8.3 times) | 3.04 against 0.39 (7.7 to 7.8 times) |
| buster's `main.c` | 1.71 against 0.27–0.44 (3.9 to 6.4 times) | 2.99–3.00 against 0.36–0.39 (7.8 to 8.4 times) |
| Lua's `lapi.c` | 1.62–1.65 against 0.30–0.31 (5.3 times) | 3.15–3.16 against 0.57 (5.6 times) |
| musl's `strlen.c` | 1.54 against 0.22 (7.1 times) | 3.07 against 0.43 (7.2 times) |

**Each kernel against its twin** (`logs/bench-*.log`), `benchmark-parser`'s median of three runs, cycles a token:

| Stage, cycles a token | sqlite3.c scalar | vector | buster main.c scalar | vector | Lua lapi.c scalar | vector | musl strlen.c scalar | vector |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| input | 13.76 | 1.73 | 11.90 | 3.10 | 12.00 | 0.64 | 7.61 | 1.59 |
| handoff | 22.90 | 1.00 | 18.10 | 3.62 | 20.13 | 0.92 | 8.40 | 1.64 |
| K1 | 6.79 | 2.46 | 5.22 | 2.54 | 7.66 | 2.43 | 2.92 | 2.64 |
| K3 | 8.80 | 2.43 | 7.96 | 2.79 | 7.39 | 3.12 | 2.95 | 1.32 |
| K2 | 33.33 | 3.96 | 30.44 | 5.60 | 31.09 | 5.02 | 24.49 | 3.72 |
| K1 second part | 13.44 | 0.80 | 11.54 | 2.40 | 13.33 | 0.81 | 6.08 | 0.63 |
| K4 | 27.23 | 4.55 | 24.72 | 7.34 | 24.18 | 11.69 | 15.09 | 4.23 |
| K5 | 19.93 | 1.85 | 16.61 | 1.63 | 16.66 | 1.12 | 11.56 | 0.45 |
| K6 | 56.79 | 9.62 | 54.40 | 10.15 | 54.81 | 10.04 | 48.18 | 7.93 |
| the whole path (the scalar parser against the vector path) | 74.12 | 28.65 | 68.96 | 36.66 | 72.99 | 36.64 | 61.99 | 22.15 |

The vector path wins at every site, on every input, at every size, from musl's 819-token `strlen.c` to `main.c`'s 5.7
million tokens. Every site passes the gate.

## What stays scalar

The vector path's own fallbacks, for phase D: K2's per-block loop for a block its rounds don't settle, K4 for nesting
past its 16-bit keys, K5's statement stack for a unit only it decides, K6's block range for a block its kernel can't
take, and the scalar parser, which takes the declarations K6 flags and a unit with an error.
