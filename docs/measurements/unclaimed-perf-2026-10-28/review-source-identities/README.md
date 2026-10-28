# Independent frozen-source identity review

This review supplements the frozen #590, #674 and #658 records. It introduces
no target build, test, capture or measurement. The exact compiler commits are
fetchable from `buster14a/buster`; previously unavailable local Git objects
were fetched before these comparisons. Original target receipts remain intact.

| Record | Frozen compiler commit | Tracked Git blobs / archive files |
| --- | --- | ---: |
| #590 | `8b815992da557a33b91c5efee809723d4e7f2df6` | 662 |
| #674 | `7274e1bc47dfa60c80a584bc01f270af5a7d420b` | 661 |
| #658 | `e056a4297c98c7ee3ef3c5c113834f63acbf448b` | 663 |

`git-590.sha256`, `git-674.sha256` and `git-658.sha256` are complete SHA-256
inventories of these Git blobs, generated during this review. Their archive
member sets exactly equal their tracked-file sets. They are Git-derived
identities, **not newly captured target-tree or build manifests**. `proof.json`
records their own hashes and canonical Git tar archive hashes.

## Comparisons to the original record

- **#590:** the entire 662-file Git tar archive hashes to
  `0e33cf9286c8dc391d39265a0b3362f00cd11797fad417dae9c840c6f8ad14ae`,
  exactly matching `issue-590/target/source-archive.sha256` at evidence
  `4df43f7d7a685133b6beade655d9e9a306947081`.
- **#674:** all six archived `local-source-sha256.txt` rows match the actual
  frozen Git blobs. Those paths are exactly the complete changed-file set
  from base `bc1b486150850fe00bad1361a19f57d67706bb3b` to candidate
  `7274e1bc`: checker, source reader, driver, checker tests, graph tests and
  checker guide. `proof.json` retains every matched row. The historical
  six-row target/local manifest does not become a fresh 661-file target
  capture merely because the complete Git-derived inventory is now provided.
- **#658:** the central 276-line literal-table proof helper has identical Git
  blob `b3b378b4dd6a91ea05e38e2c01299bf08385c553` in measured `e056a429` and
  publication head `96a4ad102cb7882ba834374ddfcf38eac080b924`. Other source and
  publication-stack changes remain distinct; helper identity does not transfer
  a whole-process rate to the later head.

For example, in the compiler repository:

```sh
git fetch origin 8b815992da557a33b91c5efee809723d4e7f2df6
git archive --format=tar 8b815992da557a33b91c5efee809723d4e7f2df6 | sha256sum
git diff --name-only bc1b486150850fe00bad1361a19f57d67706bb3b 7274e1bc47dfa60c80a584bc01f270af5a7d420b
```

The full inventories can also be checked with `sha256sum -c` from separate
clean checkouts at their exact commits. No compiler execution is necessary.

## Review scope

Independent bounded numerical review reproduced the ten #590 stage cohorts,
246 TCC measured rows, the accepted #674 balanced medians and placement/copy/
predecessor controls, and its 11,022 successful child rows. Separately, all nine
42-row #658 timing logs and all 378 actual child tables reproduce the reported
ratios/RSS and successful compile status with zero major faults. These checks
support the existing scoped interpretations: no-body startup improvement;
pinned eight-worker SQLite improvement with unresolved single-worker gain;
and eligible large integer-table improvement with fallback/SQLite cost screens.

This source review does not independently rebuild the target binaries, prove
every historical compiler invocation from a new full-tree capture, qualify
current publication heads, or complete the separate audit of omitted bulk
artifacts. Existing failure histories, overlap audits and performance limits
remain applicable. This is a bounded review of these three records, not an
approval of every record in the parent evidence PR.
