# Function-local native diagnostic and object qualification

The comparison starts at Buster `128bca66c`, which sends accepted source bodies, static initialization, wide values and jump tables through the function-local native producer. The independent ordinary Develop compiler was built at `fbef2d68d`. Every row compares fresh one-lane compiler processes with empty stdin. Successful compilations must match the complete ELF object, stdout, stderr and exit status. Failed compilations must also agree on whether an object exists. Whole-corpus runs enable the local producer with `BUSTER_CONTROL_SOURCE_NATIVE=1` and leave audit output disabled. The candidate checker unity is built with `-O0 -g1` and linked with ordinary Develop driver, frontend, backend and runtime units. These are functional receipts.

## Frozen source corpus

The 1,372 translation units comprise the SQLite amalgamation, the Buster compiler, 34 Lua sources and 1,336 musl sources. Each unit is compiled with the default warning policy, `-Wall -Wextra`, `-Wall -Wextra -Werror`, `-w` and `-Weverything`. The first four revisions use paired independent ordinary and source-native runs. Later revisions replay each fresh source-native process against all four independently retained ordinary dimensions on the same source paths. Strict and other expected failures are counted as matches if status and complete output agree. The ordinary compiler reports 863 failures over the 6,860 cases.

| Source revision | Complete ELF or absence, stdout, status | Stderr |
| --- | ---: | ---: |
| `128bca66c` | 6,860/6,860 | 6,859/6,860 |
| `8b11bd9a7` | 6,860/6,860 | 6,859/6,860 |
| `dfc34c6ed` | 6,860/6,860 | 6,860/6,860 |
| `4d6e3d6ce` | 6,860/6,860 | 6,860/6,860 |
| `31e6f5cd4` | 6,860/6,860 | 6,860/6,860 |
| `526a459eb` | 6,860/6,860 | 6,860/6,860 |

The difference in the first two rows was a second `-Wanon-enum-enum-conversion` at `x86_64_encoder.c:5389:44` while compiling Buster with `-Weverything`. The constant reader and source-body graph both claimed the operator after its graph retired. With a common source-token identity the warning appears once, with the same macro note. The ordinary and corrected Buster stderr contain 11,818 bytes. The corresponding complete object SHA-256 is `f6201b299a7bc6d7f7bc3945fa4fceb5be4835172503eb372375d01fabcc8a21`.

`corpora/` contains every case and compared digest for each frozen experiment, plus the previous Buster stderr and the independent reference. The `*.tsv.xz` files are XZ-compressed tab-separated records. The files under `f0d41668b/` name the source hashes and show the preceding mixed-control configuration with fewer admitted functions. `revisions.tsv` identifies the compiler source trees. `builds.tsv` records the actual locally linked executables.

## Directed controls

`implementation.patch` applies to `128bca66c` and reproduces `dfc34c6ed`. It carries local loop facts, mandatory conversion reports, quiet fallback, switch/atomic warnings, initialization warnings and notes, and the ordinary semantic warning graph into the accepted body. It bounds unevaluated-expression and generic scans to the source owner's range. The ordinary residual graph skips ranges whose source owner has already reported them, and each local graph borrows the unit's constant-expression warning keys.

| Directed group on `dfc34c6ed` | Exact pairs |
| --- | ---: |
| Prior control, unsequenced, flow, format, VLA and recovery fixtures | 385/385 |
| Upstream graph warnings for pointer/integer comparisons, null conversions and unevaluated operands | 205/205 |
| Enum switch, atomic record access and automatic repeated designators | 75/75 |

The 23 static-data, jump-table and wide-operation fixtures also matched 115/115 on the original `128bca66c`. The invalid-source matrix checks 45 policies and inputs across the fallback trace correction. `source-abi.patch` adds `4d6e3d6ce` on top of `dfc34c6ed`. An interrupt handler previously compiled as an ordinary function even when its graph had zero expression nodes. Other probes showed that `-w` hid mandatory unavailable-member and `diagnose_if` errors once their function became locally owned. The corrected compiler preserves the ordinary frame for special ABI definitions and their referenced entities, including attributes on previous declarations. It still admits other functions in the same unit. It publishes active mandatory semantic errors under warning suppression.

`sources.json` contains the full sources for the new directed groups. The `*-final.tsv.xz` matrices preserve the selected-body and unit-node counts where the native compiler produced an audit record. For those matrices the collector removes its native ownership summaries before comparing. `portable-combined-final.tsv.xz` repeats the same sources without audit enabled. All 560 combined new source-policy pairs pass on the no-audit runner at `4d6e3d6ce`, alongside 385/385 earlier fixtures. The 165 ABI and attribute pairs cover interrupt frames, direct interrupt calls, no-caller-saved registers, target redeclarations, force-aligned stacks, patchable entry, returns-twice, preserve-most/all, Microsoft ABI, mandatory and warning-only attributes.

A final 20-source extension checks multiple errors in one expression alongside weak symbols, aliases, assembler labels, IFUNCs, sections, inline and noreturn definitions. At `4d6e3d6ce`, three functions produced a capacity error whenever more than one unavailable-member or attribute-conditioned call error was live. The other 85 pairs matched. `multiple-reports.patch` produces `09938caf9`; its local report space grows with the number of active graph nodes and attribute conditions and is capped by the ordinary unit's limit. The same 100 pairs now match, including all original notes. `abi-extra.tsv.xz` and `abi-extra-report.tsv.xz` preserve the case-level before and after comparisons.

The repository's Clang checker sweep exercises x86 intrinsic immediates. Its fourth shard exposed 236 failed assertions when range warnings lost their final CFG disposition during graph retirement. The pre-fix log includes default errors and pragma promotion, demotion, suppression and deferred source locations. `x86-range.patch` produces `31e6f5cd4`. It keeps an actual range event with the ordinary whole-program disposition pass, while the local selector still accepts valid immediate operations. `x86-range-policy.tsv.xz` records the 45 initial exact focused comparisons at `-march=znver5`. `portable-660.tsv.xz` retains the preceding complete attribute-source oracle on `09938caf9`.

The source token remains available after its graph retires, but several source warnings need the checked type. `typed-common-warnings.patch` produces `10d8c7acd`; it reads the original type for `sizeof(a+i)`, tests whether the left-hand side of a discarded comparison could take an assignment when adding its fix-it note, and compares an attributed call against its expected type tag. A separate array, comparison and tagged-call corpus went from 44/80 to 80/80 exact. The complete no-audit directed run at this revision matched 785/785 new pairs and 385/385 earlier pairs.

The complete checker suite also exercises interfaces outside normal object emission. The synthetic sparse-switch lowerer allows a program without checker input. `sparse-program.patch` restores that calling convention. `debug-recovery.patch` builds `526a459eb`; debug line generation and explicitly requested node windows keep their ordinary graph coordinates, and already-invalid units retain their diagnostic recovery graph. The debug and recovery matrix separately compares 15 complete objects or expected failures across default, `-g` and `-g --node-window`. One six-function unit has 3,958 bytes of ordinary error and warning output. All 15 pairs match. The final no-audit source matrices also match 785/785 plus 385/385 pairs. The original sparse switch unit test, called directly in the corrected binary, passed all 22 assertions.

Further invalid-unit testing compares the original order of CFG warnings around preprocessor errors, rejected control statements, global conflicts, static assertions, wrong call arity and promoted warnings. A recovered checker report can be present even after it has been moved out of the active report array. `error-order.patch` produces `2d1b9eeb4` and preserves the ordinary unit's reachability after such an error. The 12 sources, compiled under C17 and C23, with both syntax and object entry points and five policies, now match 240/240. They had matched 148/240 at `526a459eb`.

## Reproduce

With the candidate and independent ordinary reference executables built, run the new directed sources from the repository root.

```sh
python3 docs/measurements/window-compile-2850-2026-11-21/dfc34c6ed/compare-fixtures.py \
  --compiler /path/to/candidate --reference /path/to/ordinary --output /tmp/native-fixtures
```

The adjacent `f0d41668b/compare.py` replays the earlier 385 directed pairs with the same named arguments. The full corpus uses its frozen ordinary source flags and working directory. Pass the candidate, ordinary executable, output directory, corpus name, original common compilation options and C source paths to `compare-corpus.py`. The script runs the five policies for each source and writes each object hash, diagnostic hash and exit code.
