# Buster performance

Performance measurements and benchmark evidence for [Buster](https://github.com/buster14a/buster).

The evidence lives in [`docs/measurements/`](docs/measurements/). Add new raw logs,
captures, campaign receipts, measurements and their reproduction harnesses there.
Keep compiler design summaries in Buster and link them to this repository.

The initial import preserves all 1,028 tracked paths, modes and bytes from
Buster commit [`791145817483f12514dd479655f1601684a5fd1f`](https://github.com/buster14a/buster/tree/791145817483f12514dd479655f1601684a5fd1f/docs/measurements).
Its subtree history retains 211 commits, including merge structure, authors,
committers, dates and messages. [The migration record](MIGRATION.md) contains
the source/imported commit map and verification manifests.

## Reading and reproducing evidence

Imported reports and commands are historical evidence, preserved byte for byte.
Interpret source-relative paths and commands against the Buster revision named
by each report; the migration snapshot above supplies its original surrounding
source tree. Relative links that leave the evidence tree likewise refer to that
source checkout. The [frozen source contributor guide](https://github.com/buster14a/buster/blob/791145817483f12514dd479655f1601684a5fd1f/AGENTS.md)
documents the shared 9700X lock and host boundaries. A recorded result is evidence
for its recorded source, workload, toolchain and machine only.

Clone Buster and this repository separately. Run archived harnesses from the
intended Buster checkout using their path in this repository and the report's
include/build flags. Do not copy raw evidence back into Buster. CI consumers
must use an exact reviewed commit here, rather than a moving branch; Buster's
branch-sizing workflow is the first such consumer.

## Licenses and provenance

The import retains its existing licenses and notices. Original Buster material
uses Apache-2.0 WITH LLVM-exception; identified third-party portions retain their
component terms. See [LICENSE](LICENSE), [LICENSES/](LICENSES/), and
[the retained provenance](THIRD_PARTY_NOTICES.md). The migration neither
relicenses historical material nor adds historical DCO certifications.

For new evidence, record source revisions, exact commands, input and binary
identities, CPU/toolchain, repetitions and limitations. Retain third-party notices
and distinguish external runtime inputs from incorporated material.
