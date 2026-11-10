# Provenance — production build ownership boundaries

This packet records structural build work and correctness checks for
[Buster](https://github.com/buster14a/buster), starting at
[`39506e8609750fa31ef5a443dea12f0d545a27c6`](https://github.com/buster14a/buster/tree/39506e8609750fa31ef5a443dea12f0d545a27c6).
The candidate was an uncommitted working-tree change when the measurements were
captured. [candidate.patch.gz](candidate.patch.gz), together with
[source-inputs.sha256](source-inputs.sha256), identifies its measured source
inputs. A later source commit is not implicitly the measured revision.

Original project reports, measurement helpers and new boundary/ownership code
use **Apache-2.0 WITH LLVM-exception** under the project's existing contribution
terms. Existing source portions, generated data and upstream notices keep their
recorded terms and attribution. This packet does not relabel the complete source
patch as first-party material. The source's
[LICENSING.md](https://github.com/buster14a/buster/blob/39506e8609750fa31ef5a443dea12f0d545a27c6/LICENSING.md)
and
[THIRD_PARTY_NOTICES.md](https://github.com/buster14a/buster/blob/39506e8609750fa31ef5a443dea12f0d545a27c6/THIRD_PARTY_NOTICES.md),
including the path updates in the candidate patch, remain authoritative for
identified components. The evidence repository retains the applicable
[LICENSE](../../../LICENSE), [LICENSES/](../../../LICENSES/) and
[third-party provenance](../../../THIRD_PARTY_NOTICES.md).

## Relocated source and new boundary code

| Material | Origin and treatment |
|---|---|
| `c_preprocessor_impl.c` | Definitions relocated from baseline `c_preprocessor.c`, including existing Clang-generated predefined-macro arrays; each original portion retains its attribution and terms |
| `c_preprocessor_history_impl.c` | Existing history writers and diagnostic-rendering definitions relocated from baseline `c_preprocessor_history.c`, with their recorded project provenance retained |
| `executable_impl.c` | Existing layout, patching and file-output definitions relocated from baseline `executable.c`, preserving the source's original component provenance |
| Shared interfaces and main include guards | Original project declarations, scoped include selection and semantic references; no newly imported upstream implementation |
| Ownership, selector and regression additions | Original project C checks and expectations for the new include graph |
| `candidate.patch.gz` | A record of those changes that includes both original project material and relocated existing portions; component notices continue to apply to its included source text |

The PP audit checks every original function/data definition against the pinned
baseline, including the anonymous `pp_families` table: 563 functions and 27 data
definitions, each exactly once and byte-identical. It identifies the new unused
semantic-reference bridge separately. The native-object receipts further
identify all 43 objects and the complete executable per configuration by
SHA256. These are provenance/preservation observations, not a new license grant
over the recorded source.

The reorganization introduces no new upstream implementation, generated input
or external fixture corpus. Existing lexer, Unicode, lane, generated metadata
and other component terms in the full compiler remain in force even where a
dependency or output hash mentions those components.

## Existing Clang-generated PP data

The `pp_predefines_base` and `pp_predefines_c23` arrays now in
`c_preprocessor_impl.c` were already present in baseline `c_preprocessor.c`.
They remain **LLVM-derived generated data** under the LLVM terms retained in
[LICENSES/LLVM.txt](../../../LICENSES/LLVM.txt). They are not newly authored
predefined-macro content, and moving them does not change their provenance.

The existing source notice records their generator as **Clang 23.1.3**, local
package `clang 23.1.3-2`, targeting `x86_64-pc-linux-gnu`. The base macros came
from `clang -dM -E -x c /dev/null` in GNU17 mode, omitting macros selected by
language mode/options; the C23 material came from the difference with
`-std=c23`. `__BUSTER__` is project-owned. The same notice and
`docs/c-preprocessor.md` record the retained generation procedure.

The shared `pp_features_*` tables remain in `c_preprocessor.c`. Their existing
LLVM-derived query provenance is unchanged: the recorded Clang's feature,
attribute, builtin and warning answers and the recorded name inventories are
retained under the same notice. Existing generator input descriptions cover
system/resource-header names, the named external projects and
`clang/include/clang/Basic/Features.def`; no new copies of those inputs were
introduced for this campaign.

**Clang 23.1.4 is the external compiler used to collect this packet.** That tool
version is distinct from the historical 23.1.3 generator of the retained PP
arrays. The native-build evidence does not claim those arrays were regenerated.

## Original measurement tools and receipts

The C collectors, dependency comparison reader, source-definition scanner and
auditor, ELF function comparer, Ninja edit-plan harness, ownership adapters and
custom fuzz probes in this packet are original project support code under the
project default terms. They read repository inputs and external tool outputs;
they do not incorporate an upstream compiler implementation. Their source and
the relevant recorded commands accompany the receipts.

The PP auditor uses scanner support from its accompanying `split.c`. That
file's historical extraction entry point helped develop the split; it is not a
recipe for regenerating the final hand-reviewed source, fuzz fallback, canonical
include spellings or provenance comments. The committed candidate patch and
source-input manifest identify the final measured inputs.

The reports and TSVs are original observations and comparisons. Dependency
files contain file names and include relationships; the NUL-separated argument
inventories record the source/flag selections. The input archive retains these
captures and preprocessing byte totals. SHA256 records identify omitted object
files and complete compiler executables without redistributing those binaries.
Expanded `.i` files and generated intermediate source copies are omitted from
the selected packet.

The incremental harness changes timestamps only and runs Ninja in dry-run mode.
Its journals retain source identities, hashes and before/restored atime/mtime;
ctime is expected to change. Both baseline and candidate executables were hashed
before/after each complete run. Full source names remain in the per-sample plan
receipts, including the standalone benchmark consumers.

## External tools and runtime inputs

| External component | Use and disposition |
|---|---|
| Clang/LLVM 23.1.4, lld and compiler resource headers | Native build, preprocessing, syntax and sanitizer/fuzz instrumentation tools and inputs; installed externally, with versions/identity recorded in `toolchain.txt`; toolchain implementation and archives are not vendored in this packet |
| CMake 4.4.3 and Ninja 1.13.2 | Build graph/configuration tools and actual incremental dry-run plans; external installations |
| System C compiler, Linux/POSIX facilities, libc/startup files and system headers | Build/run the original helper tools and provide native compilation/runtime inputs; retain their own external terms; dependency records do not vendor their contents |
| OpenSSL | External SHA256 library used by selected original C evidence tools; no OpenSSL implementation is copied into the source helpers or this report |
| Existing Buster tests and fixtures | Used under the pinned source tree's existing provenance; no new third-party corpus is imported by this ownership change |

The exact available toolchain and host identity belong to
[toolchain.txt](toolchain.txt). Header paths or tool names appearing in a capture
describe an external dependency, not ownership of that dependency's code.
Static Release compiler binaries were compared locally; their hashes do not
change the terms of any linked component, and the binaries are not redistributed
in this packet.

## Scope of the evidence

The cloud AMD EPYC 9V74 executor provides this campaign's correctness and
structural-work observations. It is not the project's approved Ryzen 7 9700X
timing host. No clean/incremental build-time speedup, runtime-performance
qualification or authorized-host benchmark result is claimed here.

Ordinary Release outputs, exact edit plans, dependency sets, expanded byte
counts, source preservation, ownership checks and syntax checks have their
documented receipt scope. Configured fuzz checks cover scalar/vector unity
syntax, a custom callback, native DRIVER compilation and dependency/ownership
access; they do **not** include a complete fuzz executable link or run. The final
Debug build/ownership, runtime commands and production call-graph receipts have
the scope listed in [README.md](README.md). The original source probe is project
fixture code and imports no external corpus. Metadata-only Debug database
recovery and the corrected parser command invocation are recorded explicitly.
