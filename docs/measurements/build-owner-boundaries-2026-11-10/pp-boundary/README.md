# Preprocessor boundary evidence

Baseline: `39506e8609750fa31ef5a443dea12f0d545a27c6`. Compiler: Clang 23.1.4. Host configurations: ordinary Release, `BUSTER_DEBUG_INFO=0`, `x86-64` and `znver5`.

This packet isolates the preprocessor interface/body split. The parent packet's final integrated captures and native build comparisons cover the additional executable and source/backend boundaries. These receipts establish source, dependency and object preservation; they do not establish elapsed-time performance on the approved benchmark host.

## Selected receipts

| Files | Meaning |
|---|---|
| `final-root-definition-preservation.tsv`, `.log` | Rechecked against the final integrated root after the nonowner reference bridge fix: all 563 original functions and 27 original data definitions appear exactly once, byte-identical; 438 definitions moved; zero mismatches. The sole added definition is the unused semantic-reference bridge. |
| `x86-64-frontend.sha256`, `znver5-frontend.sha256` | Complete PP-only candidate FRONTEND objects have the same SHA256 as the corresponding baseline objects. |
| `*-frontend-functions.tsv`, `.log` | ELF function-level comparison: all 814 scalar and 682 vector emitted functions match in bytes, sizes and offsets, with no added or missing functions. |
| `*-flags.argv` | Exact common compiler flags, stored as NUL-separated arguments. Ordinary CMake object generation adds its output/dependency paths and source-prefix mapping. |
| `*-frontend-compile.log` | Successful owner-object compiler stderr, empty in both configurations. |
| `canonical-includes-preprocessing.log` | Full preprocessed FRONTEND hashes agree before and after spelling the moved includes with canonical `buster/compiler/` paths. |
| `scalar-inputs.log`, `vector-inputs.log` | Aggregate PP-only candidate preprocessing counts across all 43 build sources. |
| `scalar-dependencies.tsv`, `.log`; vector equivalents | Exact changed dependency owners across all 43 build sources. Scalar literal consumers fall from 11 to 1; vector consumers from 14 to 4. |
| `*-vector-syntax.log` | Successful isolated split syntax checks for FRONTEND, CHECKER, X86, standalone PP/files/parser benchmarks and default fuzz DRIVER/FRONTEND. These logs are empty on success. |
| `audit.c`, `split.c`, `elf-functions.c` | Small C proof tools. `split.c` supplies the source scanner used by `audit.c`; its historical extraction entry point is not a final-source regeneration recipe. |

The final integrated eleven-unit vector syntax check is recorded separately in `../validation/vector-syntax/`, including exit codes and the source hashes verified before and after the run. The subsequent explicit bridge references preserve warnings in FRONTEND, standalone inputs and fuzz DRIVER; no original definition changed.

## Definition and object proof reproduction

Build the proof tools with:

```sh
cc -O2 -Wall -Werror audit.c -lcrypto -o audit
cc -O2 -Wall -Werror elf-functions.c -o elf-functions
```

Extract baseline `src/buster/compiler/c_preprocessor.c` and `src/buster/compiler/c_preprocessor_history.c` from the pinned commit into a temporary directory. Pass that directory and the candidate compiler source directory to:

```sh
./audit BASELINE_PP_DIRECTORY CANDIDATE/src/buster/compiler > definitions.tsv 2> definitions.log
```

The candidate directory must contain both original interface files and both new implementation files. The audit compares complete definition byte spans, checks uniqueness and emits per-definition hashes. It includes the anonymous `pp_families` data table; earlier development inventories that omitted that table are intentionally excluded.

After ordinary scalar/vector Release builds of both revisions, compare each configuration's `CMakeFiles/buster_main_unit_frontend.dir/Release/src/buster/compiler/main_unit_frontend.c.o` with:

```sh
sha256sum BASELINE_FRONTEND_OBJECT CANDIDATE_FRONTEND_OBJECT
./elf-functions BASELINE_FRONTEND_OBJECT CANDIDATE_FRONTEND_OBJECT > functions.tsv 2> functions.log
```

## Structural work removed by the isolated split

| Measurement | Scalar | Vector |
|---|---:|---:|
| Baseline unity preprocessed bytes | 294,948,285 | 296,701,206 |
| PP-only candidate unity bytes | 288,303,070 | 289,946,761 |
| Reduction | 6,645,215 | 6,754,445 |
| PP-only candidate all-source bytes | 357,418,731 | 415,484,477 |

The complete 43-source captures are retained in the parent `input-captures.tar.gz`
under `inputs/isolated-pp-scalar` and `inputs/isolated-pp-vector`. The isolated
prototype is identified by `isolated.patch.gz` against the same baseline and
`isolated-source-inputs.sha256`. It predates the additional eight nonowner
semantic references needed when combined with source-consumer pruning. Those
references change no original definition or FRONTEND object; the final root
audit and the parent's final measurements cover their integration.

Large `.o` and `.i` files, helper executables, intermediate generated source copies,
stale extraction inventories, and the earlier failed development syntax log are
omitted. The parent's development-corrections note records the integrated
vector build failure that prompted the final bridge fix; it is not represented
as a passing check here.
