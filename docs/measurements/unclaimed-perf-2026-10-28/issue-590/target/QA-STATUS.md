# Completed target QA for #657, #590, #652

All campaigns and raw exports have completed; this child has no live remote
measurement session. Final reports are ../../evidence-657/target/README.md,
README.md, and ../../evidence-652/target/README.md.

Exact frozen source: #657 086c24b1, #590 8b815992, cleanup-only #652 24e9c1f8,
common baseline bc1b4861. Native final checker passes 392,578/0; native
startup/lanes passes 2,335/0 including 150/0 cold/reuse assertions. All 165
stage object pairs match. #590 default first runs retain 11 total major
faults rather than excluding them. Other stage campaigns have no major
faults. All isolated tiny controls completed successfully.

The mixed-list predecessor-order finding and original A/A are preserved
in #652 ORDER-METHOD.md. Accepted tiny cleanup results use isolated
one-input A/A, A/B, B/A. No shared profile code changed.

Current-main #657 compatibility was accepted separately in merge
a4be8afa86d2e3e6d69ef00024e5e25c06ae6b5e; its tests passed under the merge
owner. Frozen timings are not assigned to that integration.

Parent owns evidence commits, claims and future issue comments. No PR,
push, issue comment or host settings change was made by this child.
