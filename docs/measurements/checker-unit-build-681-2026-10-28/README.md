# Checker-unit test optimization: frozen #681 / #682 evidence

This post-merge companion preserves the existing observations behind
[Buster #682](https://github.com/buster14a/buster/pull/682), which wraps twelve
checker test includes in Clang optimization-off regions while retaining
optimized production definitions, corpus code and benchmark implementations.
It introduces **no new target build, test or measurement**.

The measured baseline is `716c980dca3bf5f8aad9c58db712a0ed6b7d12b2`; measured
candidate is `4ce693adbb960ee46e43628033598d6ee65c4c4b`. The reviewed source
head `d8750a208f6b560ec47ec2cabdbe4ac236425499` subsequently updates comments
and documentation. Merge `4165454ebadf9b96c2b40ab99c55f4c0b28ba975` and the
two later heads' correctness CI are distinct from the measured binaries.
There are no exact-head d875 or merged-main timing claims here.

## Observed target results

`original/measure-681.log` is the original author's unmodified record. Four
`sources compiled` summaries, in fixed alternating main/head order, report:

| Round | Role | Compile-phase seconds | Checker unit seconds | Backend unit seconds |
| ---: | --- | ---: | ---: | ---: |
| 1 | main | 33.8 | 33.8 | 25.9 |
| 1 | head | 28.5 | 27.4 | 26.0 |
| 2 | main | 33.6 | 33.6 | 26.1 |
| 2 | head | 28.5 | 27.3 | 26.0 |

The two-observation compilation-phase means are 33.7 → 28.5 seconds (−5.2
seconds, −15.43%); checker-unit means are 33.7 → 27.35 seconds. `build.sh`
measures these phase durations around `each_source`, prints the summary, then
writes command metadata and invokes the final linker. Final link time and
remaining script overhead are excluded. No end-to-end build duration was
retained, so this does not establish a whole-build percentage gain. The
observed compile-schedule improvement is not a guarantee for every host,
compiler version or checkout composition.

One locked CPU-2 `time-runs` hold measures the ordinary compile of the frozen
SQLite input with #518's four defines, 21 runs per role, three requested warmups
per role, rotating execution order. Independently recomputed measured medians:

| Quantity | Main | Candidate | Candidate change |
| --- | ---: | ---: | ---: |
| Wall milliseconds | 131.022 | 131.155 | +0.10151% |
| Wall range, milliseconds | 130.266–132.292 | 130.269–133.009 | — |
| User cycles | 619,563,980 | 619,830,865 | +266,885 / +0.04308% |
| User instructions | 1,379,783,999 | 1,379,832,703 | **+48,704 / +0.0035298%** |
| Peak RSS, KiB | 382,996 | 383,376 | +380 KiB / +0.09922% |
| Minor page faults | 2,068 | 2,077 | +9 |

All 42 printed measured processes have status zero and no major faults.
`analysis/sqlite-measured.csv` is a transcription of every measured row, not
another experiment. The six script-requested warmups have no individual rows
in this record. Main instructions range 1,379,783,991–1,379,784,009; candidate
instructions range 1,379,832,695–1,379,832,721. The instruction increase is
persistent and is not rounded away as timing noise.

The timings show a small ordinary-input difference within overlapping ranges;
they do not establish universal neutrality or a general compile speedup.
There is one input, one physical executable placement per role and one paired
measurement hold, with no same-binary A/A or placement sweep. Compilation timing has
only two samples per role in one fixed alternation.

## Added startup work and unresolved attribution

Both measured executables request `DT_BIND_NOW` / `DF_1_NOW`. The candidate adds
dynamic `cos`, `pow`, `sin` and `sqrt` references: three weak imports and one
strong import (`pow`). `identities/dynsym-{main,head}.txt` and
`relocations-{main,head}.txt` retain the actual tables; dynamic relocation size
also increases by four 24-byte `R_X86_64_GLOB_DAT` entries. These symbols require eager
dynamic resolution at startup, alongside code/layout changes from the smaller
unoptimized test bodies. `time-runs` user counters cover process startup too.

The record does not isolate the exact contribution of dynamic binding, layout
or other execution effects to the +48,704 instructions. It must not be assigned
solely to placement. No new attribution campaign was run. The original PR
body's stronger wording is retained only as historical source material in
`original/pr682-body-before-evidence-follow-up.md`, and is superseded by this
scoped interpretation.

## Source, binary, input and host identities

The measured role mapping is explicit:

| Role | Target snapshot | SHA-256 |
| --- | --- | --- |
| main / 716c980d | `ci-681-claude/compiler-main` | `aba9d0f3d5586b202280e18bedbe97e8df37a572c1caa0b2e7f36e0234510b06` |
| head / 4ce693ad | `ci-681-claude/compiler-head` | `3286392f67f88778dafad09410ad4bf51d5e07b0083be0d27aa8cb56b9bf833b` |

These snapshot hashes match the binaries in each respective target source
tree's `build/compiler`. Target checkouts are clean at the exact revisions;
both complete 662-file tracked-source SHA-256 manifests match independently
extracted Git archives byte for byte. `identities/source-{base,head}.sha256`
preserves the full inventories. This ties the current frozen copies to their
source trees; it is not retroactive proof of every historical link exit status.

The original controller/log hashes are
`7ccb64c52b05a7dd47acb6fd21774d56600140e018e1d53a59bc995a54156c90` and
`baa178580dfd844eee75ffd62f08dfd3c37150fd98a8fbb9daa238dc3b0fb12e`.
They are copied byte for byte from
`/home/david/buster-fast-bench/ci-681-claude`.

Executable `.comment` records Clang 23.1.1, GCC runtime components 16.2.1 and
Wild 0.10.0. A retrospective read-only host capture identifies Ryzen 7 9700X,
Linux 6.18.50-2-lts, the same compiler/linker versions and available CPU topology.
The capture time is in `host-binary-input-identities.txt`; it is not claimed
as contemporaneous telemetry for each historical sample. The original script
sets `BUSTER_DEBUG_INFO=0`, pins each build to CPUs 0–7 and uses the shared
exclusive lock for each build separately, then one CPU-2 hold for SQLite.

The external SQLite source is
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`,
9,507,037 bytes, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
It is an external runtime input and is not copied here. The recorded arguments
are `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<sqlite-directory> sqlite3.c
-o <one-common-output>`. No base/head object-byte comparison was retained by
this campaign; none is claimed by the archive.

## Correctness scope and retained receipts

Independent frozen-source review found three balanced optimization-off/on
pairs and exactly twelve direct test includes. Core production definitions
precede the regions; corpus and benchmark definitions remain optimized.
Debug benchmark test generators/setup precede sampling, and source/binding
comparison helpers are outside timed windows. Protected-page fixtures and
native source-program oracles remain. A few direct always-inline helper copies
inside optnone test callers lose that caller optimization context, while their
optimized production consumers remain covered. No source defect was identified.

The PR native check attached to d875, job
[122806361055](https://github.com/buster14a/buster/actions/runs/40685238348/job/122806361055),
passed. Its checkout receipt identifies GitHub's synthetic merge
`feb35815426e16be7b4eabe435cc330474d58865` (d875 into a62c2df7), rather than
the standalone branch tree. The bounded diagnostic tail supplies retained
summary lines: checker 464,879 / 0; checker asm 992 / 0; deferred 72 fixtures /
1,147 checks / 708 merges / 6,552 bodies / 0; c-testsuite 220 / 220; and the
listed corpus acceptance, symbol and mutation comparisons. Oracle cache use is
explicit in those lines. `correctness/ci-d875-test-summaries.log` contains only
selected relevant summaries from a 120,000-character truncated diagnostic
tail, **not a complete CI log or complete command inventory**. Its metadata
records that limitation and exact source/job identity.

`correctness/ci-merge-metadata.json` separately records successful native,
selector and storage checks for merge 4165454e, including the
[merged-main native job](https://github.com/buster14a/buster/actions/runs/40687273123/job/122812853904).
These later correctness results do not become measurements of their heads.

The author's PR reports local paired correctness/timing checks, checker 392,187
with the same four known local Clang 23.1.4 fpclassify differences on both
builds, and exploratory local unit/IR reach analysis. Raw laptop receipts for
those reports were not supplied to this archive at publication. They remain
author-reported historical context, preserved as such in the original PR body;
they are not silently represented as independently retained all-green runs.

## Original controller limitations and corrected reproduction

`original/measure-681.sh` is unchanged. It derives a baseline from the moving
candidate branch's parent (and has a best-effort ignored fetch); it should not
be rerun blindly after branch history advances. Its actual log and frozen
source copies identify the observed 716c / 4ce pair. It also pipes `build.sh`
through `grep` without pipefail. The archive therefore retains only observed
compile summaries, not full historical compiler/linker output or explicit
per-build exit statuses. A link failure after a summary could have been hidden.
The frozen final binaries/source identities and later successful CI are useful
separate receipts; they do not retroactively repair that missing status record.

`tools/reproduce-681.c` is a separate original C controller for a future
reproduction, **not the controller used to obtain the archived samples**. It
checks clean trees and literal full revisions; records full unfiltered logs and
child statuses; refuses to copy or measure after any failed build; and uses
the same alternating schedule, lock, CPU pins, workload, 21 runs and 3 warmups.
It never derives either source from a moving branch. Prepare separate clean
checkouts at the two pinned revisions and use the recorded host/toolchain:

```sh
cc -std=c11 -O2 -Wall -Wextra -Werror tools/reproduce-681.c -o reproduce-681
./reproduce-681 /ABS/BASE_TREE /ABS/HEAD_TREE /ABS/SQLITE_DIRECTORY \
  /ABS/NEW_OUTPUT_DIRECTORY /home/david/buster-fast-bench/exclusive.sh \
  > /ABS/NEW_OUTPUT_DIRECTORY.controller.log 2>&1
```

The output directory must not exist. All five arguments are absolute paths.
The sibling controller log retains its explicit per-build exit-status rows.
No new target reproduction was performed for this archive. The controller was
compiled locally and only its local self-test ran: a fake child prints a
successful compile summary and exits 7; the controller preserves status 7
and refuses success (`tools/reproduction-self-test.log`). The self-test invokes
no target compiler, lock or benchmark. This validates fail propagation, not the
reported build-time gain.

## Provenance

The original controller/log are preserved project campaign material under the
existing submission terms, without editing their contents or adding notices to
the raw bytes. New report and corrected controller are original project work
under Apache-2.0 WITH LLVM-exception. Source fingerprints refer to the compiler's
existing licensing and third-party notices; no third-party implementation,
external corpus, executable or unrelated target file is imported. Retrospective
dynsym tables and the historical PR-text transcription have trailing whitespace
normalized; original campaign controller/log bytes are unchanged. CI excerpts
are diagnostic receipts with checkout credentials/configuration lines excluded.
This evidence repository does not inherit the compiler-only human DCO standing
certification; new companion commits contain no human certification trailer.
