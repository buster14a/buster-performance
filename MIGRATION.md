# Initial measurement migration

- Source: `buster14a/buster`, GitHub repository ID `1421805693`.
- Source branch: `main` at `791145817483f12514dd479655f1601684a5fd1f`.
- Destination: `buster14a/buster-performance`, retaining `docs/measurements/`.
- Extracted history tip: `a00d16e47b6f1090b8a0424ab0dd8cb4e6016713`.
- Identical source/destination subtree object: `190d724fb6354a4410a45154e96a885638da8398`.
- Tracked paths: 1,028. Extracted commits: 211, including 172 merges.
- Migration date: October 24, 2026.
- Source removal and storage policy: [Buster PR #379](https://github.com/buster14a/buster/pull/379), tracking [issue #378](https://github.com/buster14a/buster/issues/378).

## History extraction

A separate local clone of source `main` was filtered with Git's `filter-branch`
index filter. For each source commit the index was emptied, then populated with
that commit's `docs/measurements` tree at the same path, when present.
`--prune-empty` removed empty single-parent commits; merge structure was retained.
The source repository and all its published history were left untouched.
Only the destination's `main` branch was published, without source backup refs,
unrelated branches or tags. Buster removes the current tree through a normal PR.

Filtering changes commit/tree and parent identities. Original authors,
committers, timestamps and messages are retained; historical signatures cannot
authenticate the rewritten objects and are not carried as new signatures.
Existing trailers are preserved, without adding or backdating sign-offs.
[`migration/commits.tsv`](migration/commits.tsv) maps each retained imported commit
to its original source commit. The map was verified against the complete commit
metadata and projected source subtree.

## Integrity and scope

[`migration/source-tree.txt`](migration/source-tree.txt) records original Git
file modes, object IDs and paths. The equal subtree object ID proves that all
current imported paths, modes and bytes match the source snapshot exactly.
[`migration/SHA256SUMS`](migration/SHA256SUMS) provides independent file digests;
run `sha256sum -c migration/SHA256SUMS` at this repository's root.
The original `.gitattributes` preserves byte-exact oracle output whitespace.

`LICENSE` and `LICENSES/` were copied without modification from the frozen source,
as were the complete licensing and provenance records in `provenance/buster/`.
The initial subtree remains unmodified by the metadata commit following import.

This snapshot covers the source default branch at the revision above. Open PRs
and other branches retain their own source history and are not silently treated
as merged evidence. In particular, Buster PRs #369 and #375 contained additional
measurement material at migration time. Their owners should publish that material
here and replace its links before merging; Buster's required storage check rejects
reintroducing the retired path.

## Buster integration

PR #379 merged normally on October 24, 2026 as
`a7741e836353642041aca0e3c653f38226153358`. Its first parent is the original source
snapshot; its second parent is the reviewed migration head
`f8d41c13d77229d8b3516aa7713bf41ed794d66b`. The merge tree equals the reviewed PR
tree, contains no `docs/measurements` path, and retains the original source
snapshot in its ancestry. Buster history was not rewritten.

The [PR's 9700X run](https://github.com/buster14a/buster/actions/runs/40087337637)
passed, including the external pinned harness checkout and the matched
branch-sizing qualification. The [PR storage check](https://github.com/buster14a/buster/actions/runs/40087337716)
and [main storage check](https://github.com/buster14a/buster/actions/runs/40087791922)
also passed. The [post-merge hardware run](https://github.com/buster14a/buster/actions/runs/40087791915)
reported success for all 59 executed steps (three conditional steps skipped),
including the tests and final benchmark, but GitHub marked the job cancelled at
its existing 10-minute execution limit. Its annotation reads: "The job has
exceeded the maximum execution time of 10m0s". This is not a green main workflow.
The [pre-migration main run](https://github.com/buster14a/buster/actions/runs/40082566008)
at the original source snapshot hit the same limit. The migration retains that
existing time budget; addressing the full main suite's duration is separate work.

Buster's active main ruleset `25225502` requires both `Measurement storage policy`
and `Build and execute on Ryzen 7 9700X`, from GitHub Actions app `15368`.
Only the storage context was appended; existing rules and bypass settings were
preserved. The storage workflow runs even for documentation-only PRs and rejects
all tracked paths at or under `docs/measurements`, including ignored files forced
into Git, a file replacing the directory, and a symlink. `.gitignore`, contributor
instructions and immutable evidence links reinforce the same boundary.
