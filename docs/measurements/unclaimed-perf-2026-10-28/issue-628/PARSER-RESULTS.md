# #628 parser workspace: qualified bounded memory slice

Source patch `050dbfcde5687c339a7a2ea33237e5667162d01e` is based on pure main
`a62c2df766da50910c9ba8d9735f3bb6b801deba`. The native qualification head
`1b98b195139a114c9b5da6cf7f82c083ce14c165` merges that patch with pure main
`4165454ebadf9b96c2b40ab99c55f4c0b28ba975`; only upstream AGENTS/main test
optimization pragmas are added by that merge. The production parser change is
identical. It removes nine benchmark-only traversal buffers (36 bytes/token)
and an obsolete candidate stack (6 bytes/token) from production scratch.
The benchmark explicitly reserves its traversal buffers, including tree links
and optional sizes. Final reader-owned traversal and string columns are intact.

The patch changes only `c_parser.c`, `c_parser_benchmark.c`,
`c_parser_test.c`, and the memory discussion in `docs/compile-time.md`.
The later uncommitted asm-ID output-column slice is excluded from these results.

Native frozen pure416 compiler SHA-256:
`46bec1e120ca54b1ae99502136988cea0890e96f4af8eb704cdcd2b6cef748ed`.
Native frozen parser candidate SHA-256:
`5995d7ee9e1a7489d429aa6b1a0c9e92869b932f351ceb94756bd1c3a15bdfb0`.
Both built all 41 units with Clang 23.1.1, `BUSTER_DEBUG_INFO=0`, and the
fixed `build.sh` native/O3 flags. Native checker: 464,841 checks, zero failures.
Native parser plus Clang: passed, including dirty borrowed scratch, scalar and
vector trees, guards, allocation/mapping failures and optional traversal modes.
The focused local ASan/UBSan workspace/borrowed-arena checks also passed.

The frozen pinned SQLite input is SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
with the flags in `LOCAL-METHOD.md` (target paths use `corpus/`). Its parser has
716,157 tokens. Each native comparison uses 31 rotated pairs, one fresh process
and one lane on CPU 2, normal full object output, and the shared target lock.
All rounds and outliers remain. No host setting changed.

| Native campaign | Role 0 median wall / peak RSS | Role 1 median wall / peak RSS |
| --- | --- | --- |
| Equal-binary A/A (base / base) | 130.011 ms / 393,280 KiB | 129.981 ms / 393,300 KiB |
| A/B (base / parser) | 129.930 ms / 393,332 KiB | 129.724 ms / 387,196 KiB |
| Reverse (parser / base) | 129.860 ms / 387,196 KiB | 129.936 ms / 393,304 KiB |

The resident-memory reduction is about 6 MiB in both orders. The much larger
virtual workspace reduction is not a physical RSS claim. Wall differences are
within the A/A control's noise; no speedup is established. System-time medians
are mixed: A/A 20.058/23.127 ms, A/B 19.876/16.594 ms, reverse parser/base
23.209/23.129 ms. No system-time reduction is established from these samples.
This is a bounded memory improvement, not completion of all #628 work or its
RSS-and-system-time acceptance goal.

Every one of the 186 timing objects matched its complete baseline object.
Both five-round stage diagnostics also passed their default/instrumented
object checks. All native cohorts had zero failures and zero major faults.
Raw records and outputs are in `target/evidence628/`: `parser-{aa,ab,reverse}-31.log`,
their cohort directories, `parser-stages-{head,base}.log`, native test logs,
`parser-timing-objects.log`, and `parser-all-objects.sha256`.
Target source staging, builds, tests, timings, validation, hashing and evidence
compression all took the shared lock for separate bounded runs.

Local a62 proof is retained as `current-parser-*`, `current-checker.log`,
`current-benchmark-stages.log`, `current-asan*` and `parser-a62-binaries.sha256`.
It measured 399,888 to 393,352 KiB median peak RSS on the development machine;
its timing/system results were mixed and are not native acceptance evidence.
Older `3864c59f`/bc1 logs and the old 7-buffer layout are superseded historical
experiments, retained separately. They do not establish the current 9-buffer
production contract. No unmerged #678 source was adopted in these candidates.

No PR, push or external status comment was made by this agent.
