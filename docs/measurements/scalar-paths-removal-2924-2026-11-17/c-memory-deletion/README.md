# C9f: value numbering with memory's twins deleted (#2924)

Base `a5485642c` is the tests commit, with the twins present; it sits on C9e's head (`5720a4acc`, PR #3007). Head
`d5756a673` is the deletion. [`run.sh`](run.sh) ran on the 9700X: Release, every run under the lock, timings on CPU 2.
The gate is [`../c-ir-gate-again/`](../c-ir-gate-again/), "The verified optimizer's passes": under
`--tier1-passes=+all`, the optimizer's ticks with the pass's vector phases were 0.95 to 0.96 of those with its twins, in
every size bin.

What C9f deletes: the caller's request for the pass's scalar twins (classification, the slots' derivation and escapes,
the event lists and the hashes), which followed the optimizer's `path`. The scalar versions stay for a function whose
value spaces a signed dword gather can't index (2^30 instructions or address rows), a fallback for phase D. The
optimizer's other passes keep their twins: their fate is a question on #2924.

## Objects

`--tier1` and `--tier1 --tier1-passes=+all` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c`: 1,372 of 1,372
objects byte-identical in each mode ([`logs/status.txt`](logs/status.txt)).

## Whole compiles

`ab`, three rounds, around `time-runs` of base, head and base again; `-c --lanes 1`
([`logs/time.log`](logs/time.log)). The figures are user cycles against base.

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| sqlite3.c, `--tier1` | −0.06%, −0.08%, −0.19% | +0.07%, +0.02%, −0.08% | 0.008 M fewer |
| Lua's units, `--tier1` | −0.14%, −0.28%, −0.17% | −0.09%, −0.11%, −0.04% | 0.002 M fewer |
| sqlite3.c, `--tier1 --tier1-passes=+all` | −0.22%, −0.13%, −0.16% | −0.11%, +0.03%, +0.03% | 0.094 M fewer (−0.0006%) |

Head retires the same instructions, within 0.0006%, and reads 0.05 to 0.19 points fewer cycles than base again in every
round. The pass runs only under `+all`.

The two executables, function by function (`nm -S`): `.text.buster_start` is the same size in both, and the only
functions whose sizes differ are the ones the deletion touches (`ir_optimize_memory` 416 bytes smaller,
`ir_optimize_verified` 86, `ir_optimize` 70, `check_tier1_sink_optimize` 32) and two tests'.

## Tests

On head, all 58 lines of [`logs/status.txt`](logs/status.txt) pass:
- the IR, SSA and Tier 1 tests. `test-ir-optimize` gives the frozen digest in Release ([`logs/t12.log`](logs/t12.log)).
- the source tests on c-testsuite's 220-program subset. `test-ir-source --passes` runs the `memory` row on 430
  functions (38 changed, 71 loads forwarded) and `tier1-memory` on 430 (76 forwarded), by both of the optimizer's paths.
- `test-call-graph`, `check-call-graph` and the unity ownership check;
- the complete driver's checks of `main.c`.

## Mutants

[`mutation/`](mutation/) holds the runner, the mutants and their logs: 14 mutants of the pass's vector phases, each run
against `test-ir-optimize`.

**First round** ([`mutation/first/`](mutation/first/)), on the deletion before the new fixtures (`86518bac9`, on
`9ad48c884`): 10 of 14 killed. Survivors:
- an addition whose constant comes first not followed;
- one round of pointer jumping in the slots' derivation;
- the escapes' last lane;
- a slot's last address taken where its first is. This one is equivalent: the representative only names the slot for
  an equality test. It is replaced by the slot addresses' last lane.

**The fixes**, in the tests commit: four fixtures that the generated programs miss.
- an address added to a constant that comes first, which must forward;
- a slot whose address reaches a call three steps down, which escapes it;
- one whose address escapes from a batch's last lane;
- two slots whose only addresses are in a batch's last lane, which must stay apart (the interpreter runs it).

**Final round** ([`final.results`](mutation/final.results)): on head, all 14 are killed.
- **Classification:** SCCP's constants, observable accesses as writes, the last lane's info, an addition's constant
  first, inttoptr's source type.
- **Derivation:** one round of pointer jumping, the last lane's slot.
- **Escapes:** the last lane.
- **Events:** a volatile slot's accesses, lifetime markers, the undo bound, the slot addresses' last lane.
- **Hashes:** a store's key type, the last lane.
