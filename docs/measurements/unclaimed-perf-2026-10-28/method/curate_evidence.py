# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original archival adapter: copy bounded text evidence and record every source identity.
from pathlib import Path
import argparse
import csv
import hashlib
import re
import shutil

ROOT = Path('/home/david/Documents/Codex/2026-10-28/solv')
DEST = ROOT / 'work/buster-performance/docs/measurements/unclaimed-perf-2026-10-28'
LIMIT = 5 * 1024 * 1024
ORIGINAL = ('590', '636', '641', '649', '652', '657', '658', '664', '674')
COLLECTIONS = {issue: ('evidence-' + issue, 'issue-' + issue) for issue in ORIGINAL}
COLLECTIONS.update({
    '451': ('evidence-451/review-package', 'issue-451'),
    '647': ('evidence-647', 'issue-647'),
    '653': ('evidence-653', 'issue-653'),
    '673': ('evidence-673', 'issue-673'),
    '673-spawn': ('evidence-673-spawn', 'issue-673-spawn'),
    '628': ('evidence-628', 'issue-628'),
    'pr678-controls': ('evidence-pr678-control', 'pr-678-controls'),
    'pr678-audit': ('audit-678', 'pr-678-audit'),
})
SCOPES = {
    '451': '''# Archive scope: issue 451 page-line fusion — rejected

[Negative report](README.md), [frozen reproduction method](REPRODUCE.md),
[native provenance](native/451-qa-provenance.txt),
[complete proposed patch](experiment-68e113ee.patch).
This collection covers only the page-line fusion follow-up in issue comment
6452207581, claimed by the coordinator in comment 6469199014. The original
parts retain their ownership and credit under merged PRs #462 and #486.
Do not count #451 as solved or integrate this experiment.

Preserved source is `68e113ee445af2a80296412a2b8791d3bf9098a6`, based on pure
main `4165454ebadf9b96c2b40ab99c55f4c0b28ba975`. Its native image is identical
to prototype `d6b3f5c37217cad5cb5c5ab3ef3aaa14f32c4f5d`; the final extra guard
delegates to the scalar-host lexer, whose broader runtime compatibility was
not qualified in this rejected experiment. All native correctness checks pass.
Preparation stays 10.000 to 10.000 ms, whole-process changes remain within A/A,
and real compilation adds 2,188 KiB peak RSS. It was never integrated.
Misrouted probes, failed starts, truncated-log negative controls and the
reverted restrict refinement remain explicitly fenced in the original report.

COLLECTION.tsv paths are relative to local `work/evidence-451/review-package/`.
Only bounded, byte-identical UTF-8 text is copied. The package's original
provenance archive remains local raw with its digest/disposition recorded;
the full experiment history and remnants outside this lean package remain
local and were not modified or imported. No new target work was performed.
''',
    '628': '''# Archive scope: issue 628 qualified parser memory slice

[Qualified report](PARSER-RESULTS.md), [local method](LOCAL-METHOD.md),
[native identities](target/evidence628/native-identities.sha256),
[186 exact timing-object comparisons](target/evidence628/parser-timing-objects.log).
Patch `050dbfcde5687c339a7a2ea33237e5667162d01e` is based on pure a62;
native head `1b98b195139a114c9b5da6cf7f82c083ce14c165` merges it with pure main
`4165454ebadf9b96c2b40ab99c55f4c0b28ba975`. The accepted scope is four
parser/benchmark/test/docs files, with about 6 MiB lower native RSS in both orders.
Wall and system-time improvement are unestablished. This does not complete #628.
Older bc1/3864 and a62 local screens do not establish current native acceptance;
local a62 proof is retained only with that label. Every uncommitted asm-ID slice,
its asm-column records and column_counts proposal accounting remain local raw,
with source identities in COLLECTION.tsv; none is accepted or copied here.
''',
    '647': '''# Archive scope: issue 647

Configuration/behavior qualification at exact source
`b1975e3135b72705ef2b12c9804c2df4ce7c4149`, based on main
`4165454ebadf9b96c2b40ab99c55f4c0b28ba975`. This is not a compiler-throughput
speedup claim. [Native report](target-README.md), [local report](README.md),
[mechanical rows](target-summary.tsv), [commands](target-commands.txt).
Unavailable rows and the negative baseline one-CPU configuration are preserved.
''',
    '653': '''# Archive scope: issue 653 — rejected

Every #653 production candidate is rejected from the accepted batch.
[Negative report](README.md), [bounded whole-process summary](target-bounded/SUMMARY.tsv),
[first/shared-cache observations](target-bounded/CACHE.tsv),
[earlier candidate summary](target-lazy/SUMMARY.json).
Original candidates, all raw archives and every manifest remain local; their
source paths, sizes, digests and dispositions are in COLLECTION.tsv. The compact
target-curated tree preserves raw receipts and comparison manifests. External
zlib inputs and redundant extraction trees are retained locally, not imported.
Removal source is `da22a8a11a0b37642e2e1310b857f0aff6290d27`; the final rejected
candidate is `d8a4b93663deac305e11d9a59c43610ef27f03ee`.
''',
    '673': '''# Archive scope: issue 673 raw controls

This folder preserves the original evidence directory separately from the
[clean-launch report](../issue-673-spawn/REPORT.md). `target/frozen-b768/` is the
rejected late-fork candidate `b7681dcf67a337ca8205bf2201ca85e91f03cf42`.
`target/clean-spawn-1d/` is frozen clean-launch implementation
`1d076d6736df9b7350610ec646dc1fe1ef39f7dc`. The mixed nine-list policy screen is
retained as a rejected method because predecessor workload confounded policy.
Accepted policy interpretation uses the separate balanced homogeneous workloads;
the matrix is characterization, without a baseline/head speedup claim.
''',
    '673-spawn': '''# Archive scope: issue 673 clean launch

[Final report](REPORT.md), [matrix rows](matrix-summary.tsv),
[balanced policy rows](balanced-summary.tsv), [interference audit](contamination-audit.txt).
Frozen implementation is `1d076d6736df9b7350610ec646dc1fe1ef39f7dc`; follow-up
`30658d647bfaba8ec33d1fee676a0c853a274f02` changes documentation only.
Raw controls remain separately under [issue-673](../issue-673/ARCHIVE-SCOPE.md).
Original reports' code-formatted `../evidence-673/` paths name their local source
directory; the equivalent archived raw records are under `../issue-673/`.
Ownership is qualified with workload tradeoffs: balanced uniform large files
improve 4.58% against free eight; the uneven mix costs 4.80%; tiny ranges overlap.
The mixed policy screen is fenced, local spare-token prototype timing predates
the final regression compile, and the matrix makes no baseline/head speedup claim.
No universal neutrality, latest-main/678 speedup or DRAM-traffic claim is made.
''',
    'pr678-controls': '''# Archive scope: exact PR 678 controls

[Attribution report](README.md). Old exact PR
`8af0904bfa103398af64f292d560cfbdc6fdc22d` reproduces retained complex-runtime and
union-cast failures. Latest examined exact PR
`ed1e848e1a57cda5ba410afabb320edecc1a65dc` fixes those reproductions, but its scalar
checker suite has 599 known walk-accounting assertion failures. Driver and lane
suites pass; focused family receipts account for all 599. This is not a passing
full checker or complete combined-branch compatibility claim. No expectation fix
was applied in these pristine controls. [Focused shim audit](../pr-678-audit/README.md)
is separate; final integrated qualification belongs to the parent campaign.
''',
    'pr678-audit': '''# Archive scope: PR 678 focused scalar-operation audit

[Audit report](README.md) records unsupported operations in old exact PR
`8af0904bfa103398af64f292d560cfbdc6fdc22d`, compared with retained source b8cd163c.
The three-file local shim fix is `b71c9cfa627c2fb6f0af3b9beda9f18403c45d85`.
Focused baseline/native compile probes and boundary/UBSan tests pass. This is
focused old-head audit evidence, not final latest-PR or integrated runtime acceptance.
The [old/latest pristine controls](../pr-678-controls/README.md) retain their
negative results separately.
''',
}


def admitted(collection, relative):
    """Scope filtering never deletes source data; excluded files stay in COLLECTION."""
    parts = relative.parts
    if collection == '653':
        if parts[0] == 'inputs':
            return False
        if parts[0] == 'target-curated':
            return True
        if parts[0] == 'target-lazy':
            return len(parts) == 2 and parts[1] in {
                'SUMMARY.json', 'cohort-times.tsv', 'contamination-overlaps.json'}
        if parts[0] == 'target-bounded':
            return len(parts) == 2 and parts[1] in {'SUMMARY.tsv', 'CACHE.tsv'}
        return len(parts) == 1
    if collection == '628':
        if parts[0] == 'target':
            if len(parts) >= 3 and parts[1] == 'evidence628':
                return True
            return len(parts) == 3 and parts[1] in {
                'base-4165454e', 'issue628-parser416'} and parts[2] in {
                    'native-build.log', 'SOURCE_COMMIT'}
        if len(parts) == 1:
            return parts[0] in {
                'PARSER-RESULTS.md', 'LOCAL-METHOD.md', 'current_parser_checks.c',
                'current-main-standalone.c', 'current-checker.log',
                'current-benchmark-stages.log', 'parser-a62-binaries.sha256',
                'current-clang-version.txt', 'current-local-uname.txt'} or parts[0].startswith((
                    'current-parser-', 'current-asan', 'current-base-', 'main416-base-'))
        return False
    return True


def collect(collection):
    source_name, target_name = COLLECTIONS[collection]
    source = ROOT / 'work' / source_name
    target = DEST / target_name
    if not source.is_dir():
        raise FileNotFoundError(source)
    target.mkdir(parents=True, exist_ok=True)
    manifest = []
    for file in sorted(source.rglob('*')):
        if not file.is_file() or file.is_symlink():
            continue
        relative = file.relative_to(source)
        size = file.stat().st_size
        digest = hashlib.sha256()
        with file.open('rb') as stream:
            for chunk in iter(lambda: stream.read(1024 * 1024), b''):
                digest.update(chunk)
        selected = admitted(collection, relative) and size <= LIMIT
        if selected:
            data = file.read_bytes()
            if len(data) != size or hashlib.sha256(data).hexdigest() != digest.hexdigest():
                raise RuntimeError(f'source changed during collection: {file}')
            try:
                data.decode('utf-8')
                selected = b'\0' not in data
            except UnicodeDecodeError:
                selected = False
        if selected:
            output = target / relative
            output.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(file, output)
        manifest.append((relative.as_posix(), size, digest.hexdigest(),
                         'copied-text' if selected else 'retained-local-raw'))
    with (target / 'COLLECTION.tsv').open('w', newline='') as stream:
        writer = csv.writer(stream, delimiter='\t', lineterminator='\n')
        writer.writerow(('source_path', 'bytes', 'sha256', 'disposition'))
        writer.writerows(manifest)
    if collection in SCOPES:
        (target / 'ARCHIVE-SCOPE.md').write_text(SCOPES[collection], encoding='utf-8')
    print(collection, len(manifest), sum(row[1] for row in manifest if row[3] == 'copied-text'))


def verify(collection):
    source_name, target_name = COLLECTIONS[collection]
    source = ROOT / 'work' / source_name
    target = DEST / target_name
    with (target / 'COLLECTION.tsv').open(newline='') as stream:
        rows = list(csv.DictReader(stream, delimiter='\t'))
    expected = {'COLLECTION.tsv'}
    if collection in SCOPES:
        expected.add('ARCHIVE-SCOPE.md')
        scope = target / 'ARCHIVE-SCOPE.md'
        assert scope.read_text(encoding='utf-8') == SCOPES[collection], scope
        for link in re.findall(r'\[[^\]]+\]\(([^)]+)\)', SCOPES[collection]):
            if '://' not in link:
                assert (target / link.split('#', 1)[0]).exists(), (scope, link)
    source_paths = set()
    copied = 0
    for row in rows:
        relative = Path(row['source_path'])
        assert not relative.is_absolute() and '..' not in relative.parts, relative
        assert row['source_path'] not in source_paths, relative
        source_paths.add(row['source_path'])
        original = source / relative
        assert original.is_file() and not original.is_symlink(), original
        assert original.stat().st_size == int(row['bytes']), original
        digest = hashlib.sha256()
        with original.open('rb') as stream:
            for chunk in iter(lambda: stream.read(1024 * 1024), b''):
                digest.update(chunk)
        assert digest.hexdigest() == row['sha256'], original
        output = target / relative
        if row['disposition'] == 'copied-text':
            assert admitted(collection, relative), relative
            data = output.read_bytes()
            assert len(data) == int(row['bytes']) and len(data) <= LIMIT, output
            assert b'\0' not in data and hashlib.sha256(data).hexdigest() == row['sha256'], output
            data.decode('utf-8')
            expected.add(relative.as_posix())
            copied += 1
        else:
            assert row['disposition'] == 'retained-local-raw' and not output.exists(), output
    actual_sources = {file.relative_to(source).as_posix() for file in source.rglob('*')
                      if file.is_file() and not file.is_symlink()}
    assert source_paths == actual_sources, (collection, 'source inventory changed')
    actual_outputs = {file.relative_to(target).as_posix() for file in target.rglob('*') if file.is_file()}
    assert expected == actual_outputs, (collection, 'unexpected or missing output')
    print(collection, len(rows), copied, 'verified source digests, dispositions, text bounds and scope links')


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--verify', action='store_true', help='verify existing copies without modifying evidence')
parser.add_argument('collections', nargs='*', metavar='COLLECTION')
args = parser.parse_args()
unknown = [name for name in args.collections if name not in COLLECTIONS]
if unknown:
    parser.error('unknown collections: ' + ', '.join(unknown))
for collection in args.collections or ORIGINAL:
    (verify if args.verify else collect)(collection)
if not args.verify:
    shutil.copy2(ROOT / 'work/campaign/curate_evidence.py', DEST / 'method/curate_evidence.py')
