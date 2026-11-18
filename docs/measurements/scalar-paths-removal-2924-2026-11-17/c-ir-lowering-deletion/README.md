# The IR lowering: the twin deleted (#2924, C9b)

The base is `733037ea0`: the tests commit, with both paths still there, on C9a's `9183e0b7b`. The head is
`741669458`, which deletes the lowering's scalar twin:
- `ir_lower_typed_scalar` and `ir_lower_typed_target_scalar`;
- `ir_lower_typed_path` and the flag the lowering took;
- the scalar arms of the classification (`ir_typed_classify`) and of the ignored arguments' scan
  (`ir_typed_ignored_arguments`).

The gate is in [`../c-ir-gate/`](../c-ir-gate/): the lowering's area took 1.11 to 1.26 times as long on the twin in
every size bin, with byte-identical objects.

The tests commit freezes test-ir-lowering's digest of every function it lowers, taken where both lowerings agreed. Its
first version also folded the long double programs' functions, whose calls of C functions go through the host's
addresses: on the deletion's build 5 of 2,602 functions' constants differed (`0x2af3690` against `0x2af1ab0`), so those
functions are lowered and checked outside the digest (`ir_lower_test_lower_unfolded`), and the digest
(`0xfa8a6114710fa332`) holds on both builds.

## The 9700X, base against head ([`run.sh`](run.sh), [`logs/`](logs/))

Release, every run under the lock, timings on CPU 2, every benchmark process from a fresh copy of its executable.

- **Objects:** `--tier1` and `--tier1 --tier1-passes=+all` objects of sqlite3.c, Lua, musl and buster's `main.c`,
  every compile in one directory: 1,372 of 1,372 byte-identical in each mode.
- **`benchmark-ir-lowering`** (base `--only vector`, head its one path), ns a typed entry, three processes each:

  | Case | Base | Head |
  | --- | --- | --- |
  | small mixed | 34.90 to 37.20 | 34.54 to 34.98 |
  | larger mixed | 63.72 to 64.33 | 63.56 to 63.98 |
  | larger object | 48.08 to 48.85 | 47.97 to 48.14 |
  | larger dynamic stack | 55.87 to 56.58 | 55.73 to 55.86 |
  | alloca isolated | 11.50 to 11.59 | 11.45 to 11.64 |
  | stack-save isolated | 7.83 to 7.90 | 7.76 to 7.89 |
  | stack-restore isolated | 9.28 to 9.37 | 9.08 to 9.23 |

- **`benchmark-ir-source --only lower`** on the frozen sqlite3.c: base 41.55 to 41.76 ns a typed entry (546.31
  instructions), head 41.46 to 41.55 (546.26).
- **Whole compiles** ([`logs/time.log`](logs/time.log)): `ab`, three rounds, around `time-runs` (3 runs, 3 copies)
  of base, head and base again, `-c --lanes 1`. User cycles against base, round by round:

  | Compile | Head | Base again | User instructions, head against base |
  | --- | --- | --- | --- |
  | sqlite3.c, `--tier1` | +0.07%, +0.15%, +0.06% | −0.00%, +0.05%, −0.04% | 0.02 M fewer |
  | Lua's units, `--tier1` | +0.09%, +0.21%, +0.02% | −0.03%, +0.19%, −0.03% | 0.05 M more |
  | sqlite3.c, `--tier1 --tier1-passes=+all` | +0.15%, +0.21%, +0.05% | +0.03%, +0.02%, −0.06% | 0.04 M fewer |

  Head retires the same instructions (within 0.002%) and reads 0.02% to 0.21% more user cycles, 0.02 to 0.16 points
  above base again in each round. A compile ran the vector lowering in base too, so the deletion removes no work from
  it. The lowering's own benchmarks read the same or faster, and no function left `.text.buster_start` (578 in each),
  none is new and one is gone (`ir_lower_benchmark_sample`, inlined). The cycles' difference, with no instruction
  difference, is where the code after the smaller lowering lands.

## Mutants ([`mutation/`](mutation/))

[`mutants.py`](mutation/mutants.py) breaks the lowering's vector code that stays: the classification's full batch's
last lane, its signed and floating choices, its types' table and its signed classes' mask; the ignored arguments'
scan's tail lane, IGNORE's kind byte and r10's static chain. [`run.py`](mutation/run.py) runs `test-ir-lowering`,
`test-ir-source` with and without `--passes` on c-testsuite's first 30 programs, and `test-ssa-ir`.

**Round `final`**, on the deletion's tree `741669458` ([`mutation/final.results`](mutation/final.results)): 8 of 8
killed. The scan's three die on test-ir-lowering's check of the scan against its definition (and r10's on the static
chain's records too), the classification's on the digest and on the programs' native and IR results.
