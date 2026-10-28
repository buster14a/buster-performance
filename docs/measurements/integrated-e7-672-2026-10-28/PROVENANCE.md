# Provenance and terms

New collection prose, the C throughput validator/fixtures and C collection
audit are original project work under **Apache-2.0 WITH LLVM-exception**.
This performance repository's existing LICENSE/notices remain applicable.
No compiler-only human certification trailer is added or claimed.

## Reused project code

The method files are **byte-identical** reuse from
`buster14a/buster-performance` commit
[`e2377fd2d3d01e8c89efc8b68e7b2acc3444e7bd`](https://github.com/buster14a/buster-performance/tree/e2377fd2d3d01e8c89efc8b68e7b2acc3444e7bd/docs/measurements/microarchitecture-9700x-2026-10-27/method).
They are original first-party measurement helpers under the existing project
default; no external compiler implementation is incorporated.

| File | SHA-256 |
| --- | --- |
| `method/microarch.c` | `da3ef80d712a511c6c4738ce4bb532963a1cebcad57af21a28d3237f4ab3d68e` |
| `method/sqlite-smoke.c` | `29832500df6fb2aa71846ec0aa07bdcf680dcf1e7e34e8d794733aa0447e90b2` |

`analysis/vendor/perf_core.c` and `perf_json.c` are unchanged copies of
`tools/performance/core.c` and `json.c` from compiler source
`e7f89091648f68940b595aadd648841c1ffc3ec5`, retaining their original notices:

| File | SHA-256 |
| --- | --- |
| `perf_core.c` | `afdfcea784035fcc10a879cdd258f6b0da8e4ddd8847daa82e21fd4b14830691` |
| `perf_json.c` | `bcc2620858535830c078fc6d47eb8001270517a946259bbb80020be2b2f7b0c1` |

These C/POSIX support files add no dependency. The parser preserves exact
numeric slices, rejects duplicate JSON keys/malformed Unicode and uses bounded
flat storage. The collector reuses only the original bounded-buffer/hash code;
the validator also reuses the original JSON parser. Original analysis commands
and 34/0 optimized and 34/0 ASan/UBSan fixture receipts remain included.

## External runtime inputs and tools

- **SQLite 3.53.2**, 9,507,037-byte amalgamation, source SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
  The actual `SQLITE_VERSION`/`SQLITE_VERSION_NUMBER` facts are **3.53.2 /
  3053002**, rather than an inherited 3.53.4 prose label. The source is an
  external runtime input; its implementation is not vendored into this folder.
- Frozen GNU17 predefines SHA-256
  `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`
  and all **781** header-file identities remain exactly those of the original
  frozen corpus. No header or macro-dump implementation is copied here.
- **Official Clang 23.1.4**, build/oracle, LLVM revision
  `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`; exact executable hash and installed
  path are in `target/official-tool.sha256` and `bootstrap-clang.txt`. It runs
  externally. Its recorded license SHA-256
  `8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee`
  is byte-identical to this repository's existing `LICENSES/LLVM.txt`.
- GCC, the host C/POSIX runtime, `readelf` and the system linker are external
  QA/build consumers. No implementation from them is imported. Original tool
  paths, kernel, CPU/affinity, source/header/tool hashes and raw QA diagnostics
  are retained rather than rewritten into a synthetic clean transcript.

Original patches, scripts and raw logs keep their notices, whitespace and path
context. This collection makes no new license grant over external tools or
inputs. It does not incorporate their binaries or change the repository's
licensing policy.
