# Provenance and retained boundaries

The original reports, follow-up patch, timing helper and authored object probe
use the project default `Apache-2.0 WITH LLVM-exception` terms. The C helper
retains its SPDX/copyright header. Captured Buster source metadata and patches
refer to exact commits listed in `README.md`; component-specific notices remain
those of their source files and the repository's retained license inventory.
No third-party implementation was imported or adapted for this record.

Clang 23.1.4, GCC 16.2.1 (20260810), binutils 2.47, the Linux runtime and the
exclusive host lock are external runtime dependencies. Toolchain packages,
executables, compiled objects and cache contents are not incorporated. Their
observed identities and command paths remain in the raw method/queue receipts.

`native-7ae/native.sh` is the byte-preserved historical shell invocation record
used by the frozen experiment, not a newly introduced authoritative support
tool. `native_time.c` is the original C measurement implementation. No private
Python analysis or controller is included. Full-path count maps and the sample
table are transparent text derivations of the raw traces/C timing receipts by
the explicit method in `README.md`.

`negative-records/analysis-basename-only.json` is intentionally wrong historical
derived output, retained to document the corrected method error. It cannot
override the successful full executable paths. `local-5ac/policy-use-exec.txt`
only concatenates the original per-process traces with filename headers.

`MANIFEST.sha256` covers the curated files, excluding itself, and is an unsigned
integrity manifest. The evidence commit adds no human DCO certification; signed
source-commit messages retained as data are not trailers on this evidence commit.
