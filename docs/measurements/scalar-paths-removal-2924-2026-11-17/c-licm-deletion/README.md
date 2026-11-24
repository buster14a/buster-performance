# C9, LICM: the twin and the whole-function oracle deleted (#2924, #2979)

The record of buster#3425, merged as `4b9901707`, which fixed #2979. It kept LICM's per-loop walk (#2980) as its one
implementation. Deleted:
- `IrLicmOptions.scalar`, `.whole` and `.sweep_limit`;
- `ir_licm_complete`, `ir_licm_sweep`, `ir_licm_worklist` and `ir_licm_keep_vectors`;
- `IrLicmResult.sweeps` and `.fallback`.

The walk's speed against both old paths is in [`../c-licm-2979/`](../c-licm-2979/). The gate's parity read for LICM is in
[`../c-ir-gate-again/`](../c-ir-gate-again/).

## The commits

| Commit | What |
| --- | --- |
| `66ac45350` (base) | Tests commit, both paths present: the frozen digest of every walk result in `test-ir-licm` (`0xfb593fcec3c4c344`), `ir_licm_classify`'s guard test, and `test-ir-source --passes`' check that LICM's result moves nothing more |
| `c506ebeb6` (head) | The deletion |
| `97d2a932c` | The fixture the fault round asked for: a splat of a sum computed in the loop |
| `b55f8ef8d` | Main merged in after #3421; its new LICM fixture now takes one run per fixture |

## The 9700X

[`run.sh`](run.sh) ran base against head on Release builds (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`), every run
under the lock and timings on CPU 2 ([`logs/status.txt`](logs/status.txt), [`logs/commits.txt`](logs/commits.txt)).
The logs have the lock's wait messages taken out.

### Objects

Inputs: sqlite3.c, Lua 5.4.8's units, musl's units and buster's `main.c`, each compiled with `-c --lanes 1`. 1,372 of
1,372 objects are byte-identical between base and head in every mode:

| Mode | What LICM does there | Objects |
| --- | --- | --- |
| `--tier1` | the vector-only policy, the default | 1,372 of 1,372 identical |
| `--tier1 --tier1-passes=+licm` | the unrestricted walk | 1,372 of 1,372 identical |
| `--tier1 --tier1-passes=+hoist` | the pressure policy | 1,372 of 1,372 identical |
| `--scalar --tier1 --tier1-passes=+licm` | the flag LICM no longer reads | 1,372 of 1,372 identical |

`run.sh`'s byte comparison of the stderr streams read "different" in every mode. The cause was the lock: `exclusive.sh`
writes its wait messages into the command's stderr, and some holders' commands span several lines.
[`logs/stderr-compare.txt`](logs/stderr-compare.txt) drops those messages and diffs again. What is left in `--tier1`
and `+licm` is another session's multi-line command. The compiler's own stderr has the same hash, `9851f5fe168dce62`,
in every mode, base and head.

### Whole compiles

`ab --rounds 3 --cpu 2` around `time-runs --runs 3 --copies 3`, of base, head and base again
([`logs/time.log`](logs/time.log)). User cycles against base:

| Compile | Head | Base again |
| --- | --- | --- |
| sqlite3.c, `--tier1` | −0.26%, −0.15%, −0.28% | −0.12%, +0.08%, +0.01% |
| Lua's units, `--tier1` | +0.02%, +0.07%, −0.04% | +0.01%, +0.04%, −0.03% |
| sqlite3.c, `--tier1 --tier1-passes=+licm` | −0.27%, −0.38%, −0.39% | −0.04%, −0.01%, −0.01% |

Median instructions, head against base:

| Compile | Difference |
| --- | --- |
| sqlite3.c, `--tier1` | 26,587 more (+0.0003%) |
| Lua's units, `--tier1` | 12,454 more (+0.0006%) |
| sqlite3.c, `+licm` | 1.10 M more (+0.008%) |

The sqlite3.c compiles read 0.15% to 0.39% fewer cycles with head. Lua's are flat.

The compiles' LICM was already the walk in base, so the deletion changes no path they run. What changed is only which
code is in the executable. The cycles and instructions differences are therefore the build's: placement and inlining.
This run doesn't show where the extra instructions under `+licm` go.

### Tests

On head, all 22 tests of `run.sh` passed ([`logs/t1.log`](logs/t1.log) to [`logs/t22.log`](logs/t22.log)):
- the IR, SSA and Tier 1 tests;
- `test-ir-licm`, with the frozen digest matched;
- the source tests on c-testsuite's 220-program subset, among them `test-ir-source --passes`, where LICM given its own
  result moves nothing on every function;
- `-fsyntax-only -Wall -Werror`, and `--verify -c`, of `main.c`'s complete driver.

`run.sh`'s `check-call-graph` and ownership check failed because they looked in the wrong build trees: `native/Release`,
which wasn't built, and `znver5/Release`, which is not the `znver5-g0` tree `BUSTER_DEBUG_INFO=0` builds. Both are
recorded in `status.txt` and the first logs. [`rerun-checks.sh`](rerun-checks.sh) ran them again on the right tree, and
both passed:
- [`logs/check-call-graph-2.log`](logs/check-call-graph-2.log): 43,721 functions, 0 cycles;
- [`logs/ownership-2.log`](logs/ownership-2.log).

## The cloud container

[`local/`](local/) holds the session's own checks on a 4-CPU cloud container, before the 9700X run finished.

**Objects** ([`local/objects.sh`](local/objects.sh), [`local/objects.txt`](local/objects.txt)), on Develop builds of base
and head:
- inputs: buster's `main.c` with the complete driver, and c-testsuite's 220 programs;
- in each of the four modes above, 221 of 221 objects are identical, with identical stderr.

**Sanitizers** ([`local/sanitizer-tests.txt`](local/sanitizer-tests.txt)), on `BUSTER_SANITIZER=address`, which brings
UBSan and bounds:
- `test-ir-licm`, 3,763 checks, 0 failures;
- `test-ir-source --passes` on c-testsuite's subset;
- `test-ir-optimize` and `test-ir-metamorphic`;
- every one passed without a report.

## The fault round

[`mutation/`](mutation/): [`run.sh`](mutation/run.sh) applied eight faults ([`mutants.py`](mutation/mutants.py)) to
LICM's code after the deletion, one at a time, on a Develop build. Each build ran `test-ir-licm`, `test-ir-optimize`,
and `test-ir-source --passes` on c-testsuite's subset ([`mutation/results.txt`](mutation/results.txt), and the logs).

| Mutant | Result |
| --- | --- |
| m3: each block walked backwards | killed by all three runners, including the fixed-point check (36 functions) |
| m5: taint ignored | killed by the digest |
| m9: the discriminator load unmasked | killed (SIGSEGV on the guard page) |
| m10: the free-kind store unmasked | killed (SIGSEGV on the guard page) |
| m1: no dominance check of an operand from outside the loop | equivalent |
| m2: no epoch check of an operand from inside the loop | equivalent |
| m6: larger loops first | equivalent for the unrestricted and vector-only policies |
| m7: the vector-only policy leaves a vector's in-loop operands behind | survived; killed after the new fixture |

**Why m1, m2 and m6 are equivalent:**
- **m1:** in verified SSA, an operand from outside the loop dominates its use inside, so it dominates the loop's header,
  and so the dedicated preheader too.
- **m2:** a non-phi's operands inside the loop come before it in reverse postorder, so this walk has always stamped
  them.
- **m6:** an outer loop's walk covers its inner loops' blocks, so a value that is invariant in both reaches the same
  preheader in either order.

These three checks were in the walk before this PR (#2980). The removed oracle couldn't have told them apart either:
an equivalent mutant gives the same output.

**m7 was a missing fixture:** no fixture had a vector value whose operand is an invariant scalar of the same loop, and
the oracle's comparisons had none either. `97d2a932c` adds one: a splat of a sum computed in the loop moves to the
preheader with its sum. Run again with that fixture, m7 is killed ([`mutation/logs/m7-again.licm`](mutation/logs/m7-again.licm)).
The fixture doesn't fold into the frozen digest.
