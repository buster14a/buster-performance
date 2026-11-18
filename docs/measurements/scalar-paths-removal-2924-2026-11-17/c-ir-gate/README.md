# The IR's gate (#2924, C9): main `45f3f8561`

**Superseded (2026-11-18):** several regions here held the verifier's scalar twin, which each of them took with its
area's flag:
- the lowering;
- the inliner;
- value numbering;
- promotion, which also held the vector-values scan's twin;
- SROA;
- LICM;
- the loop vectorizer;
- the verified optimizer.

Their ratios below are those twins' as much as the areas'. The splits, threading, the unroller and the sink held no
verifier, and read the same again. [`c-ir-gate-again/`](../c-ir-gate-again/) measures each area alone on C9b's tree,
where the verifier has one path.

This gate measures the twins of the IR, SSA and the IR optimizer, as Tier 1's pipeline selects them, area by area. It
uses one Release executable built from main plus [`knob.patch`](knob.patch), which is for the experiment only:
- `BUSTER_IR_SCALAR_AREAS` is a bitmask of the areas whose twin runs. In `c_check_tier1.c` and
  `c_check_tier1_inline.c` it turns over the `scalar` flag each IR stage takes:
  - bit 0, the lowering (`ir_lower_typed_target_pieces`);
  - bit 1, the inliner's own scans and expansion;
  - bit 2, SROA;
  - bit 3, value numbering;
  - bit 4, promotion (with the scan for vector values);
  - bit 5, the wide and vector splits;
  - bit 6, truth simplification, threading and if-conversion;
  - bit 7, LICM;
  - bit 8, the loop vectorizer;
  - bit 9, the unroller;
  - bit 10, the operand sink;
  - bit 11, the verified optimizer (SCCP, dead code, CFG cleanup, merges, identities, memory, and its verification).
- `BUSTER_IR_AREA_TICKS` names a file that gets one line per compiled function: its stage, its Tier 0 entries and its
  TSC ticks in each area's region. The inliner's region holds the summaries it builds, and their stages' ticks go to
  their own regions too.

[`run.sh`](run.sh) runs on the 9700X, under the lock on CPU 2, using [`objects.sh`](objects.sh): `--tier1 -c` of
sqlite3.c, Lua 5.4.8 and musl's units on one lane. It uses two configurations:
- the default passes, which run value numbering and LICM on vector and mask values alone;
- `--tier1-passes=+all`, which adds SROA, unrestricted value numbering and LICM, the loop vectorizer, the unroller and
  memory.

It does two things:
1. **Objects:** builds them with each area's bit set alone and with all twelve, and compares each against the objects
   with no bit set.
2. **Ticks:** takes every area on vector (`0`) and every area on its twin (`0xfff`), three rounds in turn.

[`alone.sh`](alone.sh) then takes LICM's bit (`0x80`) under `+all`, and value numbering's (`0x8`) and promotion's
(`0x10`) in both configurations, each alone against no bit, five rounds in turn. [`compare.py`](compare.py) and
[`compare-alone.py`](compare-alone.py) take each function's median per area over the rounds and sum by the function's
Tier 0 entries ([`logs/compare/`](logs/compare/), [`logs/alone/`](logs/alone/)). The tick files are in
[`ticks.tar.xz`](ticks.tar.xz) and [`ticks-alone.tar.xz`](ticks-alone.tar.xz).

## Verdict: every area passes but LICM's unrestricted pass on the largest functions

**Objects:** in both configurations, with each area's bit set alone and with all twelve, 1,371 of 1,371 objects are
byte-identical to the all-vector objects ([`logs/status.txt`](logs/status.txt)).

The ratios below are the twin's ticks over the vector path's. The default passes cover 5,693 functions with IR, and
`+all` covers 6,518. SROA, the loop vectorizer and the unroller run only with `+all`. The rows marked "alone" are from
[`alone.sh`](alone.sh); the others are all twelve twins at once.

| Area | Configuration | Vector, M ticks | Total | By entries (0-15, 16-63, 64-255, 256-1,023, 1,024+) | Rounds |
| --- | --- | ---: | ---: | --- | --- |
| Lowering | default | 165.6 | 1.219 | 1.11, 1.18, 1.23, 1.26, 1.26 | 1.215 to 1.229 |
| Inliner | default | 77.5 | 1.194 | 1.09, 1.14, 1.18, 1.20, 1.20 | 1.193 to 1.195 |
| Value numbering (vectors), alone | default | 25.5 | 1.111 | 1.15, 1.21, 1.23, 1.17, 1.09 | 1.107 to 1.116 |
| Promotion, alone | default | 549.6 | 1.111 | 1.06, 1.09, 1.14, 1.14, 1.07 | 1.109 to 1.112 |
| Splits | default | 2.2 | 2.566 | 1.47, 1.83, 2.37, 4.25, 8.50 | 2.48 to 2.59 |
| Threading and if-conversion | default | 135.7 | 1.113 | 1.23, 1.15, 1.13, 1.11, 1.08 | 1.112 to 1.113 |
| LICM (vectors) | default | 8.3 | 1.254 | 1.27, 1.21, 1.32, 1.34, 1.24 | 1.252 to 1.268 |
| Sink | default | 15.3 | 2.388 | 2.20, 2.43, 2.52, 2.53, 2.11 | 2.387 to 2.393 |
| Verified optimizer | default | 558.0 | 1.147 | 1.09, 1.12, 1.15, 1.16, 1.15 | 1.145 to 1.149 |
| SROA | `+all` | 597.7 | 1.200 | 1.15, 1.20, 1.23, 1.22, 1.14 | 1.200 to 1.202 |
| Value numbering, alone | `+all` | 524.8 | 1.197 | 1.25, 1.26, 1.23, 1.18, 1.10 | 1.191 to 1.201 |
| Promotion, alone | `+all` | 702.6 | 1.099 | 1.08, 1.09, 1.12, 1.12, 1.06 | 1.098 to 1.101 |
| **LICM, alone** | `+all` | 936.3 | **0.960** | 1.27, 1.27, 1.23, 1.08, **0.620** | 0.959 to 0.963 |
| Loop vectorizer | `+all` | 20.1 | 1.141 | 1.14, 1.09, 1.11, 1.15, 1.24 | 1.137 to 1.143 |
| Unroller | `+all` | 43.9 | 1.075 | 1.11, 1.08, 1.07, 1.08, 1.06 | 1.072 to 1.084 |

The lowering, inliner, splits, threading, sink and optimizer rows under `+all` read as under the default passes:
1.11 to 5.4 in every bin ([`logs/compare/all-0xfff.txt`](logs/compare/all-0xfff.txt)).

**Value numbering and promotion** read 1.006 and 1.015 at 0 to 15 entries with all twelve twins at once. Each alone,
they read 1.06 to 1.25 at those sizes: the all-at-once reading was the other twins' effect on the caches, as in C8. The
same-code controls read 1.0058 (LICM's region under value numbering's bit) and 1.0036 (value numbering's region under
LICM's bit).

**LICM under `--tier1-passes=+licm`** (the unrestricted pass, not the default) loses on the 54 functions of 1,024 entries
and more: 229 M ticks for the twin against 370 M for the vector path, the same in all five rounds. The worst are a
function of 18,144 entries (49.4 M against 95.6 M) and functions of 4,000 to 8,500 entries at 0.42 to 0.62. Its
vector path (`ir_licm_complete`) sweeps the whole function to the availability fixed point, up to `sweep_limit` (64)
times while each sweep makes at least one value in 16 available, and finishes with the worklist if a sweep still
changed something. The twin runs the worklist alone.
