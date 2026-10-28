# Collection and payload dispositions

The original local root is
`/home/david/Documents/Codex/2026-10-28/solv/work/evidence-672`.
This is a bounded **text-only evidence record**, assembled without target
access. Original files were read, copied and hash-compared; source files were
not changed. No compiler/object/helper executable, source tar or full native
archive is included in the proposed Git content.

## Complete local inventory

[`COLLECTION.tsv`](COLLECTION.tsv) accounts for **all 1,179 source files**:
**740 byte-identical text copies** and **439 hashed exclusions**. It records
the original relative path, byte size, SHA-256, disposition and destination.
[`EXCLUDED-PAYLOADS.tsv`](EXCLUDED-PAYLOADS.tsv) repeats only the excluded set.
The original top-level working README/plan are preserved as
`setup/README-original.md` and `setup/PLAN-original.md`; their intermediate
status prose is superseded by this record's README and raw final records.
The original analysis snapshots also retain their collection-time status;
current publication readiness and measurement-boundary clarifications are in
the top-level README and REVIEW_HANDOFF. Raw copies remain unchanged.

[`collection-validation.log`](collection-validation.log) confirms all
**600 throughput child diagnostic logs**, **25 children.tsv receipts**,
**25 ELF-header texts** and **25 SQLite smoke outputs** were copied. The
additional `qa-first-compile` child receipt/log is retained separately.
Every empty successful diagnostic log remains a named, hashed file.
Original whitespace and external paths in raw records are not rewritten.

Four supplemental local-baseline invocation/build/test logs from
`work/campaign/receipts/base-e7f8-*.log` are byte-identical copies in
`setup/local-receipts/`, with their original source hashes in
`SOURCE-IDENTITIES.sha256`. They preserve the wrong-working-directory build
and incorrect parallel-list invocation alongside their corrected local runs.
Those local receipts are not the measured native debug-enabled image.

`SHA256SUMS` verifies the proposed public files, including all collection and
disposition records. The other original `*.sha256` files describe their
recorded source/target contexts: some intentionally name payloads absent from
Git. Do not interpret those external hashes as a promise that the binaries or
corpus contents have been published.

## Large and executable payloads

| Payload | Exact disposition |
| --- | --- |
| `evidence-native.tar.zst` | Local archive retained, **33,446,045 compressed bytes**, excluded from Git. SHA-256 `8757d17b9e1b094d59b60c2d20dcc2f9550d4f0d2381a9347265212f83f805f1`; the root's packaging receipt supplies **105,697,280 decoded bytes**. No public download is claimed. |
| Measured native `compiler-native` | **Target-only**, SHA-256 `06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`, as recorded by `target/build-inputs.sha256`. Not in the local text extraction or Git; byte size not collected in this record. |
| 25 retained throughput `output-000.o` files and their 25 linked smoke executables | Local/target payloads remain retained; every original byte size and hash is in the excluded manifest. Git keeps their ELF-header/smoke/hash evidence, not executable bytes. |
| QA `output-000.o` | Retained local/target payload; size/hash in the excluded manifest. Git keeps its child receipt, official QA result and smoke digest. |
| `source-e7f89091.tar` | Local source archive, 32,133,120 bytes; SHA-256 `c9808a824b40665553a59dc35c989166efe39ef34fa5c9117c9721833027d08e`; excluded from Git. Source pin and original build method are retained. |
| `stage-e7f89091.tar` | Local staging archive, 32,174,080 bytes; SHA-256 `eac24f75b22480a17156d7715118735f79778a70e92408ea87ff66bbe377efa1`; excluded. |
| `native-qa-stage.tar` | Local QA staging archive, 10,240 bytes; SHA-256 `6a836acd81258d13fd2acc06eff05319cdd41f0eb8d4a7cc03521488ad865229`; excluded. |
| Compiled method/analysis helpers | Local binaries are excluded, with original hashes/sizes in the excluded manifest and original helper manifests. C sources and build/test commands remain included. The temporary collection executable was hash-recorded and removed from this checkout after collection. |
| Synthetic `analysis/fixtures-672-*` payloads | All **380 generated files** remain local, with exact original hashes/sizes/dispositions in the excluded manifest. Four bounded successful test logs, generator/test source and commands remain included. Temporary directory names are intentionally variable; byte identity of a newly generated path-bearing report is not claimed. |
| Frozen source input, predefines, 781 headers and official Clang executable | External runtime inputs/tools are not imported as C implementation or binaries. Source/predefine/tool/license hashes and the full 781-header hash manifest are retained. External identities not present as local collection inputs are listed in `EXTERNAL-IDENTITIES.tsv`. |

The archive's decoded objects/executables and the separately retained compiler
are not silently replaced by a claim of public availability. This record
deliberately publishes only the bounded text/method record; subsequent payload
publication, if requested, needs its own explicit artifact and identity.

## Setup and negative dispositions

| Record | Disposition |
| --- | --- |
| `receipts/stage-native-build.log`, `unlocked-attempt-identities.txt` | Initial remote quoting/continuation failure led to the **unlocked** 18:39:38–18:40:26 UTC build. Its `76ef91da…` image is quarantined and never used for the final throughput grid. The recorded overlap with CI #714 is preserved, not erased by a successful later run; this does not establish a correctness failure or a causal measurement effect in another run. |
| `receipts/stage-native-build-quoted.log` | Correctly quoted overwrite guard refused the existing directory. No replacement of the quarantined image. |
| `receipts/stage-native-build-locked-fresh.log`, `native-qa.log`, `native-qa-full.log` | Earlier locked image using host Clang **23.1.1**, `93e2e068…`; checker **497,025 checks / four fpclassify failures**, full 4-command QA **3 passed / 1 failed**. Retained separately; no throughput campaign is attributed to it. |
| `receipts/stage-native-build-clang2314.log` | Guessed private tool-cache path was absent. Failed setup, not a successful qualified build. |
| `receipts/stage-official-clang2314.log`, `build-native-official2314.log` | Correct official tool setup and final build. Its identity is `06132c96…`, native ISA, debug enabled. The reused setup pins archive/license identities. |
| `target/native-qa.log`, `receipts/official-native-qa.log` | Corrected official **Clang 23.1.4**, **4/4 commands in 22.0 seconds**, checker **497,021/0**. This is the QA control for the measured image. |
| `receipts/official-throughput.log`, `native-validate-package.log` | Final locked measurement and validation/packaging receipts. Raw cohort data, child statuses and nonzero faults remain unfiltered. |
| `setup/local-receipts/` | Local wrong-cwd and wrong-list invocation failures plus corrected local baseline runs, preserved without converting them into native throughput evidence. |

No synthetic or setup/negative record enters the 25-cohort throughput table.
The original receipt labels and tool versions take precedence over intermediate
working prose when they differ.

## Reproduce the collection check

From this folder, with the original local evidence root still available:

```sh
clang -std=gnu17 -O2 -Wall -Wextra -Werror -Wno-unused-function \
  analysis/collect_evidence.c -o /tmp/collect-evidence-672
/tmp/collect-evidence-672 /PATH/TO/evidence-672 /PATH/TO/NEW-TEXT-COPY
```

The first-party C collector never follows symlinks, hashes with bounded blocks,
classifies every file, rejects unsupported file types/count/depth exhaustion,
copies only text, verifies every copied hash and enforces the 600/25/25/25
cohort artifact counts. It does not contact the target. Use a new destination
when reproducing; its copy operation deliberately writes destination files.
