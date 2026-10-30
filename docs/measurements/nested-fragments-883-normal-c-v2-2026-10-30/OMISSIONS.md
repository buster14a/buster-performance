# Omitted payloads and pending phases

The original producer manifests remain byte-exact identity records. Missing
payloads named below are intentional publication omissions, not a claim that
their original verification failed. `package.sha256` checks the included
regular files without requiring any external payload.

| Omitted class | Retained identity or disposition |
| --- | --- |
| Both complete Buster source trees and tar archives | Exact commits/trees, archive hashes, all 805/807 source hashes, Git blobs/path/mode inventories and archive listings |
| Private Git index binary files | `inspection/normal-omitted-files.sha256`; original masked-index diagnostics, standalone corrected statuses and empty final diffs retained |
| Unused prepared comparator/object-preflight source helpers | Original preparation hashes and `inspection/normal-omitted-files.sha256`; neither helper was run by these phases |
| Normal compiler executables and removed build objects | Complete compiler hashes, actual compile metadata, readelf/nm output and unchanged link recipe/order; raw final-link argv was never captured |
| Source-manifest transfer tar | Its hash is in `inspection/normal-omitted-files.sha256`; the contained manifests are independently retained under `raw/normal/manifests/` |
| Two full mixed host macro dumps | Equal original hashes plus selected first-party vector predicates; no third-party generated macro payload copied |
| C-v2 source transfer tar | Its hash is in `inspection/c-tool-omitted-files.sha256`; all 29 constituent source/control/provenance files are retained |
| Support/control executable binaries and object files | Support-tool final hash and original `COMPILED-CONTROL-IDENTITIES.txt`; v1/v2 frozen receipt bundles already omit compiled control bytes |
| Official toolchain/archive, header/runtime payloads and shared libraries | Original complete regular-file hashes, four symlink inventories, selected pins, versions and LLVM license; reused external private cache |
| Synthetic control symlinks | Existing `SYMLINK-TARGETS.txt` ledgers; no absolute/special link is copied or dereferenced |
| Frozen Python placement prototype, refresh code and bytecode | Existing README/manifests plus individual omitted-file hashes; development history only, never producer-used |
| Corpus/SQLite/Lua/system-header bytes, cache and temporary payloads | External inputs; available hashes/manifests remain, with no new corpus result inferred |
| First-failure compiled payloads | `failure-v1/` includes 257 of 304 payload files; 42 objects, three images and two full assembly streams are omitted with all 47 exact hashes |
| First-failure 286,013,440-byte raw tar | Original archive digest/member list retained; all 56 top-level named metadata receipts are copied separately |
| Live outputs, later correction and dependent phases | Excluded. Frozen first BASE failure is retained; candidate was unlaunched and compatibility/nonzero/target/semantic/timing gates remain blocked |

Only original regular receipt files are copied. Synthetic raw NUL fixtures,
constructed input data, deliberately malformed manifests, scripts and private
source snippets are retained as control evidence. They are not compiled
objects or real target executables. The original raw trees and omitted payloads
remain at their recorded task-owned locations; this archive does not promise
their availability to readers.
