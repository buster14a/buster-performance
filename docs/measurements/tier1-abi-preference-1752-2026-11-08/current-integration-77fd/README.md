# SQLite integration identity on main 77fd0f22

This is a follow-up to the [pinned-pair record](../README.md), not a new dynamic capture or full performance qualification. It compares main `77fd0f225ab83f479bf60234a750205df5683dd7` (tree `4a4a7fb0ecbb609374ad9e9a3bc7b0bb55efb5a5`) with its conflict-free merge of #1752 head `b20f0cc19be240cde735c226c9028c0b63dd8c03` (result tree `6ac729430b3d062f6a330f8f411899acc208007c`). The merge tree was obtained using `git merge-tree --write-tree 77fd0f225ab83f479bf60234a750205df5683dd7 b20f0cc19be240cde735c226c9028c0b63dd8c03`. No PR branch was modified.

Four compiler builds were performed on Benchpress with the same optional measurement patch, host target and toolchain as the original record, each under its own lock. The complete SQLite ordinary and tagged ELFs are byte-identical within each side. Moreover, each ELF and its full tag stream are byte-identical to the corresponding executable and tags used in the earlier capture:

| Side | SQLite ELF SHA-256 | Tag stream SHA-256 |
| --- | --- | --- |
| Main | `bbe5a7e987bed4f2fd80f434daa1c362d765484e9a18ee7fd574d7e7496119df` | `ca723bce145da3030ceed878784962a5c419dd5230a0ef0dc60682f8cdc7827e` |
| Integrated #1752 | `ca7f7231508bf04457f4b8d48769c4107bddef826eda7468720115706aa74c8a` | `5eec3514a6b83331dbde206530a23bd8f5b287944b3b0e8e372950a03885d508` |

Each reports `sqlite3VdbeExec` compiled with zero fallback, and fresh `--verify` executions produce the same historical hash (`1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`) and byte-identical final database (`9803668aa9fcf728162aa22cec555134588385cb07c2836210d69bdc068499a7`). The source-input manifest was rechecked. Thus the previously captured SQLite code and tags are exactly those produced by this integration pair, and the observed earlier SQLite tagged-traffic increase is relevant to it. The dynamic counts are **reused**, not a repeat Callgrind experiment. The parent record's incomplete-tagging qualification continues to apply; no Lua dynamic, native paired-runtime or issue-acceptance result is claimed. A proposed single native warm-up was cancelled while queued and produced no timing result.

`current-receipts.tar.gz` contains build logs and compiler hashes, compiler invocations and reports, tag files, workload verification output, equivalence and input-hash checks, the patch and scripts. It excludes compiled programs and generated databases; their identities are recorded in the logs. The four source manifests are **post-hoc** comparisons of host source trees against Git archives with the same patch, excluding build output; they match by side but are not build-time source receipts. The original raw Callgrind captures and mapping audit remain in the parent record.
