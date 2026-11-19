# Default CIE reuse in the x86-64 assembler

When the initial CFI event list is empty, a procedure's default Common Information Entry (CIE) is completely determined by the frame section, the simple and signal flags, and the one-byte return column. The first occurrence still goes through Buster's byte interner. An earlier procedure with explicit initial instructions can already own the same bytes. Each subsequent occurrence of that default identity uses the original section offset.

## Work at the normal entry point

Each row is one invocation of `build/compiler assemble -o output.o input.s` for each compiler revision. The counter runs immediately after the candidate length is backpatched, before hashing or checking for a duplicate. Bytes include the length field and padding once. The writer also rewrites the four-byte length, so writer bytes including the backpatch equal the table's byte count plus four times the encoding count. These counts describe work inside the assembler. They do not measure elapsed time or Zen 5 throughput.

| Input | Base encodings | Head encodings | Base candidate bytes | Head candidate bytes |
| --- | ---: | ---: | ---: | ---: |
| 1 short function | 1 | 1 | 24 | 24 |
| 100 short functions | 100 | 1 | 2,400 | 24 |
| 1,000 short functions | 1,000 | 1 | 24,000 | 24 |
| GCC assembly for `tools/ci/rerun.c` | 17 | 1 | 408 | 24 |
| Clang assembly for `tools/ci/rerun.c` | 11 | 1 | 264 | 24 |
| 10 mixed procedures, both sections | 20 | 16 | 444 | 360 |
| All 1,024 default identities, then reverse order, both sections | 4,096 | 2,048 | 86,016 | 43,008 |

The 1,000-function object saves 999 encodings and 23,976 padded candidate bytes. All seven complete ELF objects compare byte-for-byte between base and head and between normal and instrumented builds. The per-section cache uses a 4,096-byte stack array for first offsets and a 128-byte presence bitmap. Only the bitmap needs initialization. A translation unit requesting both frame sections reuses the stack in consecutive calls.

## Correctness checks

- GCC and Clang generated assembly from the real repository source with `-O2 -march=x86-64 -fcf-protection=none -fasynchronous-unwind-tables -fno-ident -S`. Clang also used `-fno-integrated-as` to emit GNU assembler syntax. Both compilers' assembly and the three short-function inputs match GNU as in raw frame bytes, decoded frame records and relocation offset, type, target and addend.
- The 10-procedure mixed input covers a simple CIE with explicit instructions equivalent to the ordinary default, a distinct explicit initial rule, ordinary and signal CIEs, return column 31, body unwind instructions, repeated defaults and both sections. GNU as can choose a shorter CIE prefix and put the remaining initial instructions in the FDE. Comparing the 22 effective rows checks PC ranges, CFA, saved return address, return column and signal status across these different legal encodings. All 20 Buster FDEs reference the expected first CIE. The new in-tree regression uses another executable section and also checks exact GNU output under an order that gives the same record grouping.
- The all-identities input uses return columns 0 through 255 and all four flag combinations, then repeats them in reverse. `keys.c` independently decodes each complete frame section. It checks version, augmentation, return column, initial rules, alignment, padding and first-CIE references, plus all relocation offsets, types, targets and addends. Per object this accounts for 2,048 CIEs, 4,096 FDEs and 6,144 relocations. The raw check covers columns beyond those printed in the binutils 2.46 `readelf -wf` listing of this input.
- The complete clean `test-assembler --cross-check` includes the existing GNU object comparisons, execution and unwinding, and the 160-source GCC and Clang corpus. The exact base and head results and toolchain flags are in `receipt.txt`.

## Reproduction

Use a disposable clean Buster checkout on an ordinary Linux/x86-64 AVX-512 runner with GNU binutils 2.46 and GCC 15.2. The hosted run staged the repository-pinned Clang 23.1.4, CMake 4.4.3 and Ninja 1.13.2. Put this directory outside the Buster checkout. From the checkout root, with `evidence_dir` set to this directory's absolute path, run

```sh
git checkout --detach 6427879e1143026a12fb0388a20bdea1fe4b2bc5
export PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
export RUNNER_TEMP="$(mktemp -d)"
cc -march=x86-64-v4 -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni -mgfni -mvaes -maes tools/ci/vector-probe.c -o "$RUNNER_TEMP/vector-probe"
"$RUNNER_TEMP/vector-probe" && bash "$evidence_dir/measure.sh" 72c0872fa40d398c573b6419546531d226fb8697
```

The script selects vector Release, disables debug info and sanitizers, and uses the same compiler flags at both revisions. It writes the generated assembly, ELF objects, decoded records, relocations, counter traces, hashes and complete clean-head cross-check output under `$RUNNER_TEMP/cie-results`. The sole instrumentation is a temporary `fprintf` in the disposable checkout.

To repeat the separate clean-base cross-check in that checkout, run

```sh
git checkout --detach 6427879e1143026a12fb0388a20bdea1fe4b2bc5
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none
./build.sh --config Release && ./build/compiler test-assembler --cross-check
```

[Paired hosted run](https://github.com/buster14a/buster-performance/actions/runs/44608935056) · [Clean baseline cross-check](https://github.com/buster14a/buster-performance/actions/runs/44602398738/job/135836994217) · [Clean head cross-check](https://github.com/buster14a/buster-performance/actions/runs/44607877187/job/135860172643) · [Independent raw-object replay](https://github.com/buster14a/buster-performance/actions/runs/44608793204/job/135859514253)

---
Agent session: 6aff500e-2908-8191-a17d-9efc73505049 (OpenAI Codex session ID; no private session URL exposed)
Model: OpenAI / GPT-6 (Codex)
