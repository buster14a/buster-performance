# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original bounded functional-evidence collector. Readiness is an explicit owner gate.
from pathlib import Path
import argparse
import importlib.util

spec = importlib.util.spec_from_file_location('archive_core', Path(__file__).with_name('curate_evidence.py'))
core = importlib.util.module_from_spec(spec)
spec.loader.exec_module(core)
core.DEST = core.ROOT / 'work/bperf-final241/docs/measurements/final241-functional-proof-2026-10-28'
core.COLLECTIONS = {
    '695-adoption': ('evidence/695-lossless-adoption', '695-adoption'),
    'batch241': ('evidence-final-batch-241', 'batch241'),
    'focused702': ('evidence-628-fill-stack/compat-678-4b2', 'focused702'),
    'method': ('final241-evidence-method', 'method'),
}
READY = {
    '695-adoption': True,
    'batch241': True,
    'focused702': True,
    'method': True,
}
core.SCOPES = {
    'focused702': '''# Scope: separate focused702 plus pinned678 compatibility

[Authoritative report](README.md), [exact command recipe](COMMANDS.md),
[source inputs](source-identities.sha256), [complete local manifest](SHA256SUMS).
Private26364e88d61f34b3df635e24d85bed46a3333052 combines published702
0e6967fd9cbc146ca4bc4f073ceb80f8aeed82c4 with pinned678
4b2a8a6f51cf8dee5a5833a8f32138d865d780b8. Its tree is
dab50e916b9ddd9bcd0403955fef651cfd4512ed. All three host headers exactly match678.
Four resolved surrounding source files are retained for reproducing this private
composition; this focused adapter does not qualify their full program/emission
contracts or build a whole compiler image.

Actual native host-vector1 and actual -march=x86-64 host-vector0 ASan/UBSan
adapters each pass214/0:206 permanent dirty/guard/copied-arena assertions and
eight actual-reader policy/value checks. Empty and three-token units preserve
the explicit parser scalar request. Explicit scalar records zero bulk fills;
default records one bounded call per each of thirteen columns, with equal
values and sentinels. Actual header selection is asserted, never redefined.
The two unsuccessful generic warning-flag invocations are preserved separately
from final builds/runs; no production source or published head was changed.
No full4349-suite, latest-head CI, timing or performance result is inferred.
No additional native-host variants are qualified. This remains separate from
the all-twelve-slice composition.
''',
    'batch241': '''# Scope: frozen all-twelve-source functional composition

[Authoritative results](RESULTS.md), [pins and method](README.md),
[bounded source review](INTEGRATION-REVIEW.md), [source identity](source-identity.txt),
[one-predicate patch](asm-parser-mode-fix.patch),
[corrected-source identity](asm-corrected-source-identity.txt).
Original source 4349d8fd1a8b5be358669b89b08e80e38a68b7bc composes main241,
exact678/4b2, all twelve original publication slices and b1 guardian recovery.
Both 41-unit builds pass. The nine originally planned broad commands pass on
both exact binaries. Dedicated extra ASM passes native1010/0 but fails generic
1010/2 at that same freeze. Those original negative logs/statuses and original
source/binary identities are retained; this is not an unconditional all-suite pass.

Separate private test-only a07682fe6c31cdf5329a7601d2074f907e407341 changes just
the storage-presence predicate to parser.options.scalar. Production source is
unchanged. Actual-production focused adapters print six requested/actual-mode
cases, reproduce two old generic predicates and pass both corrected predicates;
the complete ASM suite passes1010/0 in native and generic adapters. The nine
broad suites were not rerun on a076, and no new whole-compiler builds are claimed.

The coordinator published4349 at codex/experiment-20261028-asm-control and
a076 at codex/qualification-20261028-final241. Separate draft test companion
https://github.com/buster14a/buster/pull/708 uses
c27e2d8067b9aed1b822be312e79545ab1451d3b on the702 base; its entire ASM-test
blob equals a076 and one-line patch ID is7950ed0494128bf5ce9e9a2d6a7daecd310cc542.
That draft was closed UNMERGED at16:32:36UTC as superseded: a parallel coordinator
already published the identical assertion on693 at
31413e36b71d4ce8115a53645ada22c9166288b3. Its entire ASM-test blob and stable patch
ID match a076/c27. Root verified that equivalence and closed redundant708; root
did not alter693 or merge708. Independent public review's425/0 two-host result
is external evidence, not one of our runs. Blob/patch equality does not claim
a fresh whole314 full-suite pass or production change. Publication states are
coordinator snapshots, not live-state qualification.
The4349 batch excludes665 and historical628 bulk-fill95be46e6; separate702
focused checks do not become part of this batch's qualification. These are
local functional/source-contract checks, with no new performance claim.
''',
    '695-adoption': '''# Scope: completed lossless-token-return adoption

[Original report](README.md), [same-tree hashes](composed-tree-identity.txt),
[corrected native protocol](protocol-native.log), [corrected sanitizer protocol](protocol-asan.log).
The original 35d guardian's EAGAIN/63-credit-loss finding is retained despite
green original CI. Original 186 checks did not exercise that case. Correction
b1b3e490cde7639e2030619c7b0054f352327679 adds lossless opaque-byte recovery.
Real-reexec local native and ASan/UBSan checks pass 204/0. The old-source adapter
receipts passing 181 checks are rejected and remain separately named.

Bounded composition b66527e33d2fac90c6eca9c62a75926f6bd60118 builds 41 units on
native/generic and passes lane smoke 2,682/0 and 2,716/0, including protocol204.
No broad checker/full-batch suite was run in this bounded adoption record.
Public ce8be68972d192ccbabb989dc8c819b39f50f19b and tested private b665 have
identical tree c7627b0d586819ee942ada2e1b28cb8c8d9af854 (two identical hashes in
the original identity file). This permits same-tree functional attribution;
it is not a new build or performance measurement.

The proposal's real-make stress, contention, driver and full-build results are
externally credited, not relabeled as our reruns. Recovery-buffer setup cost
is unmeasured, and old 673 timing does not transfer. The coordinator's later
ce8 hosted native/baseline PASS plus queued benchmark is a status snapshot;
it supersedes the original report's in-progress handoff text without rewriting
it and makes no general current-head or benchmark-pass claim.
''',
    'method': '''# Functional archival method

[Collector](curate_final241.py) imports [byte-exact archival core](curate_evidence.py).
The core is copied unchanged from evidence commit
9f50a7ba6dbcdc88f9b6237b92d9f9c8a5e835e6 at
docs/measurements/unclaimed-perf-2026-10-28/publication-method/curate_evidence.py.
Its SHA256 is bfdeac4d147a2b9fa37f85ee8f6a7014c90e74fcc1b8b388d9be14e57692a43c.
COLLECTION.tsv records every regular source file's path, bytes, SHA256 and
copied-text versus retained-local-raw disposition. Copied bytes are unchanged
UTF-8, without NUL, and at most 5 MiB per file. Objects, executables and binary
archives remain local. Generated scope/readme interpretation is distinct from
original raw receipts. No active owner folder is collected before explicit
completion, and no target/performance run is performed by this collector.
The method inventory contains exactly the two named scripts; Python caches
and the collector's own changing scratch output are not method source inputs.
''',
}
core.inventoried = lambda collection, relative: collection != 'method' or (
    len(relative.parts) == 1 and relative.name in {'curate_evidence.py', 'curate_final241.py'})
core.admitted = lambda collection, relative: core.inventoried(collection, relative) and (
    relative.suffix.lower() not in {'.o', '.a', '.so', '.gz', '.xz', '.bz2', '.zst', '.zip', '.tar', '.tgz', '.pyc'})
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--verify', action='store_true')
parser.add_argument('collections', nargs='+')
args = parser.parse_args()
for name in args.collections:
    if name not in core.COLLECTIONS or not READY[name]:
        parser.error('unknown or not owner-completed: ' + name)
for name in args.collections:
    (core.verify if args.verify else core.collect)(name)
