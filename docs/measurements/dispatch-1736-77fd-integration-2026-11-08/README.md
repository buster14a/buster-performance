# PR 1736: pinned 77fd integration, 2026-11-08

This is an isolated integration comparison of base `77fd0f225ab83f479bf60234a750205df5683dd7` against the original [PR 1736](https://github.com/buster14a/buster/pull/1736) experiment applied on that base. The integration commit is `2310da7f7` (tree `323a486df651c031506c222f6d91d5c4d7010a8d`); `current-experiment.patch.gz` decompresses to stable patch ID `02561f4b386eab6393397792dc9f4cdd92f746f3`, identical to the experiment's published delta. Its source archive SHA-256 is `d3dbcd00f5a661de74de3bfca2f43c07b83d8bec68d5222bc8260751fc80783b`. This integration is a measurement artifact, not the PR head and not current main: `95fb03f06` subsequently merged #1755's scale-selection change, which may change the generated workload.

## SQLite dynamic counts

| Observed edge-tagged instructions | Base | Integration | Change |
| --- | ---: | ---: | ---: |
| T: stores | 151,079,195 | 150,358,045 | -0.48% |
| U: reloads | 163,581,242 | 163,001,970 | -0.35% |
| e: register moves | 154,445,928 | 147,308,283 | -4.62% |
| Combined | 469,106,365 | 460,668,298 | -1.80% |
| Combined in `sqlite3VdbeExec` | 253,868,126 | 246,851,702 | -2.76% |

The observed tagged traffic does not establish the issue's ≥50% edge-traffic target on SQLite. It is not a runtime result and does not measure the five Lua scripts. No claim is made about 95fb or later main. The earlier frozen comparison and its detailed controls are in the [previous record](../dispatch-1736-frozen-2026-11-08/README.md).

Each side's separate SQLite verification passed hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`; the two verification runs and two Callgrind runs all produced logical database dump SHA-256 `3be217cd86db20ce5bd81e09c143e4b581061f1a3ac5bee7ee3e21a4ffd408d4`. Non-timing workload lines matched. Fresh tmpfs directories, identical speedtest1 options and individual Benchpress lock grants were used. A verification run is separate from its capture; matching logical dumps support but cannot prove identical behavior at every step.

Baseline ordinary/tagged ELF SHA-256 was `bbe5a7e987bed4f2fd80f434daa1c362d765484e9a18ee7fd574d7e7496119df`; candidate ordinary/tagged SHA-256 was `cc67398324468c6bd5e2ca0d1b08fd629accbbef6a98828c31c33ba009f6f140`. The baseline compiler and tagged executable were reused read-only from [PR 348](https://github.com/buster14a/buster-performance/pull/348), with an independently captured baseline under this record's tmpfs policy. The candidate used the same optional private tag sidecar (SHA-256 `141776fef464c4555a5e04387681109bd85f766ec480f1c95a8d1edcb22e58e7`). Each revision reported 2,709 compiled functions and no fallbacks, including `sqlite3VdbeExec`; each had 2,709 unique tag rows corresponding to reported outcomes. Static fits had no row-fit diagnostics. The included independent tag-class audit found every T/U/e instruction had the expected stack-store, stack-load or register-copy shape, but does not prove that every edge operation was tagged. Other vector/mask/rematerialization fixture limitations in the earlier record remain.

Callgrind 3.25.1 instruction addresses were independently mapped to each ELF with bias `0x4000000` using the corresponding `main` address and matching instruction lengths. There were zero unmatched sampled PCs inside either executable. Each capture also had 1,986 `???` costs at 36 PCs outside its executable interval, excluded from the totals; their origin is unconfirmed. Raw data and joins preserve these exclusions. `gap.c` from the earlier record reproduces the joins with the disassemblies retained here.

The source and input manifests, exact invocation records, outputs, raw captures, tag streams, source patch, and compiler build logs are retained here or in `raw.tar.gz` (SHA-256 `4033b797b7ca0e2f95ca560ac26ef85b8635407f01b183cfc1a567c63c525e99`). Generated executables and database dumps are excluded; their hashes are retained. Independent review matched the local Git source archive to its transferred archive and confirmed the patch ID. `current-inputs.sha256` is the baseline owner's source manifest; candidate compilation checked it before and after. This is a practical source/toolchain check, not complete environmental closure: system-library, metadata, failed path-probe, proc/sys and other environmental changes were not exhaustively bound across these current-integration compiles. This record does not establish wider correctness, Lua performance, compiler overhead or a native runtime benefit.

The included `perf349-local-source.sha256` and `perf349-host-source.sha256` independently compare the Git integration tree plus sidecar with the retained host source tree. They match, but were collected after the builds and do not prove source identity at build time.

The compressed disassemblies contain generated code from SQLite 3.53.2's public-domain amalgamation and `test/speedtest1.c`, plus the project's unity wrapper. Their source hashes and the amalgamation's copyright disclaimer and blessing are retained in the [frozen record](../dispatch-1736-frozen-2026-11-08/README.md); see also [SQLite's public-domain statement](https://sqlite.org/copyright.html).
