# Local correctness checks

Develop build `d745f1f9f62439f41d64d180f112cf19468ec024` passed 19,103,566 Tier 0 checks at seed 2850, including native comparisons with Clang 23.1.4. The source-identical control compiler, `fbef2d68dfc952c269d7a2fd008220341428e727`, differs from the measured base `0e1d5b825801135bf50e79da9d546bc95209ab30` only in `docs/one-core-path.md`.

All 4,116 per-source comparisons matched exit status, object bytes, stdout and stderr across the default policy, `-Wall -Wextra` and `-Weverything -Wno-c++-compat`. The separate default SQLite `-c` run emitted 2,061,200 bytes with SHA-256 `2238999c41e256cc9c14ddbe21e379f0b3c09df25fb642b056e18b8a7ea773a0`. The local native Develop binaries had SHA-256 `84560ff9c5b6a9aa09116d694393a43743d6fb81e0cc0526e524af3633cc94ad` for the control and `91c7ca03a23140d302a427dfa979df99160a8fe123bf23608e1ca18b457c4143` for the candidate.

[Per-corpus counts](corpus-summary.tsv) · [Tier 0 oracle](test-tier0.log) · [All raw differential receipts and scripts](local-checks.tar.xz)
