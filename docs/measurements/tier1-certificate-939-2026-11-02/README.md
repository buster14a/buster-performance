# Tier 1 allocation certificates: cost and size — #939, 2026-11-02

Source: [buster#1142](https://github.com/buster14a/buster/pull/1142), for
[buster#939](https://github.com/buster14a/buster/issues/939), whose third
"Done when" item asks for the certificate checker's cost per instruction on
the 9700X, reported with the certificates' sizes.

The candidate is `fee05dd6568bc32a23fe306f0cd7b97d349a00a0` (tree
`683b20b912006ee99d25f904918a7e646af805b1`), one commit on main `df007cd5`.
It adds `tier1_certificate_cfg.c`, which publishes a certificate for each
allocation `tier1_cfg.c` makes over a CFG, and `benchmark-tier1-certificate`,
which times it. This is one measurement of one revision. It is not an A/B
comparison and makes no claim against another revision.

## Run

- [Workflow run 41461001966](https://github.com/buster14a/buster/actions/runs/41461001966),
  Benchpress job `125338063833` on the approved Ryzen 7 9700X. The job ran
  native correctness first, then the benchmarks its `MEASURE` list selects;
  `tier1-certificate` was among them.
- Host build: `BUSTER_HOST_ARCH=znver5`, the job's standard Benchpress build.
  The job's oracle line reports `clang version 23.1.4 (https://github.com/llvm/llvm-project 7a941dfb2877a0b8cf30323fefa85ad019e0b0f5)`.
- Workload: the frozen `preprocessor-391e729af658/sqlite/sqlite3.c`, with its
  pinned predefines and headers. The exact options are in the step's script in
  `benchmark-fee05dd6.txt`.
- Command: `taskset -c "$cpu" ./build/compiler benchmark-tier1-certificate ...`,
  pinned to the job's first allowed CPU.

`benchmark-fee05dd6.txt` is the step's script, environment and complete
output, with timestamps and colour escapes removed. `correctness-fee05dd6.txt`
holds the same job's native correctness lines that report certificates.

## Method

`benchmark-tier1-certificate` at `fee05dd6`:

- It builds `benchmark-tier1-cfg-source`'s corpus: every function `-c` compiles
  of the file, lowered, promoted and adapted to `tier1_cfg.c`'s input.
- It keeps each function's vector-path allocation. Every allocation must pass
  `tier1_cfg_verify`.
- Each certificate is published and proved once outside the timing. A refusal
  would fail the benchmark.
- Five variants then run over every function in 21 passes after a warm-up, the
  order rotating by pass:
  - `allocate`: `tier1_cfg_allocate`, the allocation being certified;
  - `publish`: `tier1_certificate_cfg`, which builds the certificate from the
    preallocation input and the allocation;
  - `check`: `tier1_certificate_check` alone, on programs published before the
    timing;
  - `certify`: both, as `Tier1EmitOptions.certify` runs them;
  - `verify`: `tier1_cfg_verify`, the existing structural checker, for
    comparison.
- Each variant is reported as a median per IR instruction: time, core cycles,
  instructions and IPC. It is also reported in cycles per certificate item,
  where the items are the checker's linear work: source operands, edits, facts
  and renames, 1,395,400 in all.

## Results

Of the file's 2,602 functions, 2,600 joined the corpus; Tier 1's CFG adapter
leaves out the other 2 as unsupported. The corpus has 486,651 IR instructions,
423,461 values, 44,729 blocks (none unreachable) and 56,959 edges.

Medians of 21 passes:

| Variant | ns/instr | cycles/instr | instr/instr | IPC | cycles/item | ms for the corpus | vs `allocate` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `allocate` | 143.51 | 795.27 | 2,162.94 | 2.72 | 277.35 | 69.84 | 1.00 |
| `publish` | 89.50 | 496.04 | 1,413.57 | 2.85 | 173.00 | 43.56 | 0.62 |
| `check` | 86.56 | 479.72 | 2,202.17 | 4.59 | 167.30 | 42.12 | 0.60 |
| `certify` | 171.17 | 948.68 | 3,616.08 | 3.81 | 330.86 | 83.30 | 1.19 |
| `verify` | 125.49 | 695.38 | 2,181.41 | 3.14 | 242.52 | 61.07 | 0.87 |

Certifying an allocation costs 1.19 times the allocation itself: 171 ns per IR
instruction, about half of it to publish the certificate and half to check
it. It costs 1.36 times the structural verifier. The checker alone runs at
4.59 IPC, 167 cycles per item.

### Certificate sizes

Totals over the corpus:

| Quantity | Total | Per IR instruction |
| --- | ---: | ---: |
| source positions | 763,201 | |
| source records | 777,904 | |
| source operands | 878,457 | 1.805 |
| edits | 76,066: 3,946 transitions, 45 split moves, 72,075 edge moves | 0.156 |
| facts | 418,332, of which 95,413 are recipe facts | 0.860 |
| phi renames | 22,545 | |
| storage | 52,453 locations over 450,400 units | |
| program bytes | 229,132,604; the largest function's 12,402,668 | 470.8 |
| checker scratch | 21,244,233 bytes; the largest 563,661 | |
| checker unit reads and writes | 10,739,031 and 17,670,936 | |

The program bytes are the published records' bytes. At `fee05dd6` on x86-64,
the record sizes reproduce the total exactly:

| Record | Size | Count | Bytes | Share |
| --- | ---: | ---: | ---: | ---: |
| `Tier1CertSource` | 192 | 777,904 | 149,357,568 | 65.2% |
| `Tier1CertInstruction` | 72 | 853,970 | 61,485,840 | 26.8% |
| `Tier1CertValue` | 24 | 423,461 | 10,163,064 | 4.4% |
| `Tier1CertFact` | 8 | 418,332 | 3,346,656 | 1.5% |
| `Tier1CertBlock` | 48 | 44,729 | 2,146,992 | 0.9% |
| `Tier1CertEdge` | 32 | 56,959 | 1,822,688 | 0.8% |
| `Tier1CertLocation` | 12 | 52,453 | 629,436 | 0.3% |
| `Tier1CertRename` | 8 | 22,545 | 180,360 | 0.1% |

The instruction count is the stream: the 777,904 source records plus the
76,066 edits.

92% of the bytes are fixed-width records. A source record reserves eight
operand slots and eight clobber slots before and after, and a stream
instruction eight locations. Yet the records average 1.13 operands, and only
7.1% of the source records' bytes are operands in use. A packed layout would
shrink the certificate several times over. This is an observation; nothing
here measures such a layout.

### Correctness in the same job

The job's native correctness certified every allocation its tests made, on
both paths:

| Suite | Certified (vector / scalar) | Refused |
| --- | ---: | ---: |
| `test-tier1-cfg-source`, c-testsuite subset | 422 / 422 | 0 |
| `test-tier1-cfg-source --simd` fixtures | 7 / 7 | 0 |
| `test-tier1-cfg-source`, frozen `sqlite3.c` | 2,600 / 2,600 | 0 |
| `test-tier1-cfg-source`, frozen musl units | 2,660 / 2,660 | 0 |

- `test-tier1-cfg` proved 3,632 allocations; the oracle proved 230 of them too.
  The certificate refused every order, definition and split-destination
  mutant. No mutant was refused by the certificate alone. 34 were refused by
  `tier1_cfg_verify` alone; these break a structural rule without changing any
  value read.
- `test-tier1-allocation` checked 51,425 straight-line allocations.
  `test-tier1-certificate` ran 2,087 checks and `-interval` 17.
- `test-tier1-pipeline` made 72 certified emissions, with 292 facts.

## Limitations

- **One run.** This is one process in one Benchpress job: 21 passes, medians
  only. The benchmark prints no spread, and the clock and thermal state weren't
  recorded.
- **No vector path.** The checker is scalar, so no after-scalar state applies.
- **The parts don't add up exactly.** `certify` runs `publish` and `check` in
  one pass. The separate medians (89.50 + 86.56 ns) come to more than its
  171.17 ns; treat the split as approximate.
- **Certificates prove allocations, not code.** A certificate proves the
  allocation, not the emitter's native records. The bridge that decodes those
  records is still outstanding (buster's `docs/tier1-certificate.md`, "What the
  certificate proves").
- **Scope of the evidence.** Generated-code quality and whole-compile time are
  outside this measurement. The raw workflow log is linked above; only the
  lines in the two text files are retained here.
