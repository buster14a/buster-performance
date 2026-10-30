<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Completed standalone 9700X campaign

This is the completed root packet from
`/home/david/buster-fast-bench/codex-rescue-126/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/`.
The private source checkout is `source/`, receipts `evidence/`, and the executed
tools `harness/`. The five source tools match this record's `../harnesses/`
byte for byte. All measurements use the hardware compiler hash in `compiler.sha256`,
not the distinct local qualification executable.

Every gate status file is 0 (`check`, `selected`, `all`, `symbols`); the campaign
and final-integrity status files are also 0. `postcheck/status.tsv` records all
11 process exits and 21 passes per process. The command, NUL argv, raw process
logs, before/after compiler hashes and exact summary remain unchanged. Input
and source manifests were verified before/after; the final integrity command
also returned 0. Empty successful capture/integrity logs do not replace their
explicit root-recorded statuses. Each hardware invocation held the shared host
lock separately; every timed process was pinned to CPU 2. The actual build was
pinned to CPUs 0–3 under that lock; benchpress has no `cores` command. Local
`cores` grants in `../local/` describe the separate local host only.

The source-only timing and 58-function eligibility audits are in
`../METHOD.md` and `../INLINE-POLICY.md`. Optional emission verification and
unwind generation are disabled in the timed benchmark. They are enabled in the
separate CLI object gates. `.eh_frame` is visible in the retained section reports.

`main-selected.symbols.gz` and `main-all.symbols.gz` are lossless `gzip -n -9`
representations of the root's readelf text reports; `symbol-texts.sha256` retains
the original text hashes. No `.o`, compiler binary or preprocessed-source payload
is copied here. `private-payloads.sha256` / `.sizes` are unchanged root receipts;
`private-artifacts.tsv` resolves their source-root-relative paths to explicit
private host locations. The source tar is reproducible from the public Git SHA;
no public binary release is required or implied.

The final 378 external header identities exactly match the prior mechanically
audited header inventory and license notices. `curation.json` records that
comparison and the byte-identical offline summary reproduction. Local complete
checker/corpus results and exact-source hosted/native CI remain separate evidence;
this manual hardware packet is not another full-checker rerun.
