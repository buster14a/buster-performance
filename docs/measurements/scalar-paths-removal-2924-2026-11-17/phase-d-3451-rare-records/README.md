# #3451 / #2924 phase D: the x86 effects' rare records

The gate record of buster14a/buster's `claude/2924-3451-rare-records` PR. Session: `session_01EgbxndFreFrJqAywiEGoue`.
The census of the route is `phase-d-3451-census/`.

`x86_instructions_effects` and its opmasks variant computed every record 8 lanes at a time. After the loop, every
record of a call with a rare one went through `x86_instruction_rare`, and each rare record through
`x86_instruction_resolve`, a scalar resolver, one record at a time. The rare records are:
- an x87 form's;
- vzeroupper's;
- RARE's operands: an `/is4` register, a VSIB index, an opmask pair;
- IMPLICIT_VECTORS' registers: Key Locker's.

The PR deletes both functions. The loop stays main's, and a call with a rare record is completed after it by
`x86_effects_rare_records`:
- **Detection:** each block's lanes' properties alone (two loads a lane) pass over blocks without a rare form.
- **Loading:** another block's lanes' effects records and operand bytes (`x86_effects_operands`, a new baked byte per
  record) are broadcast into registers under the lanes' masks.
- **Completion:** the rare lanes get their terms. The x87's and vzeroupper's sets come from a register lookup. The
  operand terms and Key Locker's vectors are added only where a block has a RARE or IMPLICIT_VECTORS record.

## The replay

- **`dump.diff`** (on main `aeb99a83e`, experiment only) appends every call's records to a file.
- **Calls:** dumped from `-c --tier1 --lanes 1` of buster's `main.c` at `-g` and `--verify` (`-march=znver5 -Isrc
  -fwrapv -funsigned-char -fno-strict-aliasing`), c-testsuite `5c727565`'s 220 `single-exec` files at `-g` and
  `--verify`, and Lua 5.4.8's `l*.c` at `-g`.
- **`gate.c` and `side.c`:** one executable with main's `x86_semantics.c` (old, with `x86_instruction_rare` to count
  rare records) and the branch's (new), each with its tree's encoder.
- **Check:** every call is first checked for identical reads, writes and opmask columns.
- **Timing:** rdtsc a call, by count bin, apart for calls with a rare record ("rare") and without ("plain"). 21 passes
  alternate which side goes first; each bin's median ticks a call.
- **`gate-debug.c`:** also compares 2^21 random records over every form number, with and without opmasks, and prints
  the first mismatches. Every version below read 0 there and 0 mismatches in every dump.

The runs were on the 9700X under `exclusive.sh`, CPU 2, built with the toolchain's clang 23.1.4 at `-march=znver5`.

## Four designs

| log | head | design | plain | rare |
| --- | --- | --- | --- | --- |
| `run.log` | 281b221ab | a rare branch in the block loop, its terms after the block's stores | 0.87-0.99 to 8 records, 1.02-1.05 from 9 | 1.08-1.26 at 1 record, 1.06-1.10 at 2, 0.44-0.92 from 3 |
| `run2.log` | fbc389044 | main's loop; a pass after it rescans every block in full | 0.976-1.023 | 0.35-0.98 to 64 records, 1.05-1.12 from 65 (main.c) |
| `run3.log` | 6b0668582 | the pass first tests each lane's properties | 0.981-1.019 | **0.41-0.98, every bin** |

Two earlier forms were measured only in the cloud container:
- **A block computed again with the rare terms after a call inside the loop.** Every ZMM register is caller-saved, so
  the loop gave up its constants.
- **The terms inline in the block.** The loop spilled ZMM registers (63 stack references against main's 18).

Both read plain calls 4 to 22% slower.

## run3, the PR

Ticks a call (TSC), new/old, by count:

| dump | plain | rare | every call |
| --- | --- | --- | --- |
| main.c `-g` | 0.981-1.007 | 0.77-0.98 (1: 0.81, 2: 0.92, 257+: 0.98) | 1.001 |
| main.c `--verify` | 0.997-1.014 | 0.77-0.97 | 1.004 |
| c-testsuite `-g` | 0.997-1.014 | 0.52-0.84 | 0.988 |
| c-testsuite `--verify` | 0.999-1.019 | 0.41-0.93 | 1.011 |
| Lua `-g` (no rare record) | 0.994-1.015 | - | 1.003 |

- **Plain calls** run main's loop, line for line (the loop's only change is the call after it). Their bins read 0.976
  to 1.023 across runs 2 and 3, on both sides of 1, by placement.
- **Calls with a rare record** are faster at every count in every dump.

**Objects:** `-c --tier1 -g` and `--verify` of `main.c` and `-g` of c-testsuite's 220 files are byte-identical between
main and the branch (222 objects).

## Tests and mutation

The tests needed no change. `test-x86-semantics` checks the effects with no second implementation:
- the processor's execution of every covered form;
- the resolved-operand fixtures (gathers, scatters, vpblendvb's `/is4`, vp2intersect's pair, the x87, vzeroupper);
- the columns' frozen digest (`0x700e64f6f8320e55`, from 2026-11-23, when the twins still agreed), each item alone
  against its batch, and every count to 100 ending at a `PROT_NONE` page.

The digest is unchanged by the PR.

`mutation/run.py` builds and runs `test-x86-semantics` for each mutant of `x86_effects_rare_records`. `round1.txt` has
16 mutants: 14 killed, 1 survived, and 1 that did not build (an unused variable).
- **Survivor, `accessed-address`:** dropping the address-only term of a VSIB operand's access. It is equivalent:
  `mutation/probe.c` finds 0 address-only forms among the 64 covered VSIB forms. The term stays, because it mirrors
  the common block's condition.
- **Not built, `vex-read`:** rewritten in `round2.txt` as `vex-read-2`, which keeps the variable in use. It is killed.
