# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original incremental publication archival adapter; it never modifies frozen collections.
from pathlib import Path
import argparse
import importlib.util

spec = importlib.util.spec_from_file_location('archive_core', Path(__file__).with_name('curate_evidence.py'))
core = importlib.util.module_from_spec(spec)
spec.loader.exec_module(core)
core.COLLECTIONS = {
    'publication-636': ('evidence-publish-636', 'publication-636'),
    'publication-649': ('evidence-publish-649', 'publication-649'),
    'publication-647': ('evidence-publish-647', 'publication-647'),
    'publication-664-674': ('publication-evidence', 'publication-664-674'),
    'publication-590-652-657': ('publication', 'publication-590-652-657'),
    'publication-628': ('evidence-628/pub-628-321', 'publication-628'),
    'publication-641': ('evidence/pub-641', 'publication-641'),
    'publication-658': ('evidence-658/pub-658-321', 'publication-658'),
    'publication-673': ('evidence-publish-673', 'publication-673'),
    'next-main-d3-local': ('evidence-next-main', 'next-main-d3-local'),
    'next-main-d3-target': ('campaign/receipts', 'next-main-d3-target'),
    'publication-method': ('campaign', 'publication-method'),
}
common = '''
These are frozen publication/correctness receipts, not new performance results.
Original reports and CI JSON preserve their handoff status, not live PR state.
Historical timings remain attributed to their original source revisions.
See [publication method and supersession note](../publication-method/ARCHIVE-SCOPE.md).
'''
core.SCOPES = {
    'publication-636': '''# Publication scope: issue 636

[Authoritative report](README.md), [source identity](source-identity.txt),
[published body snapshot](PR-BODY.md). Main321 base, publication head
600262cbfac4a0917eea751d9b5c2ee9c14ee3b0, built code
43b92c1298ff0acac02e2688f49661976c79599c; later changes are documentation only.
The 41-unit build, preprocessor/Clang, driver and selector checks pass. Diagnostic
source matches the qualified frozen slice; no new-head speedup is inferred.
''' + common,
    'publication-649': '''# Publication scope: issue 649

[Authoritative report](README.md), [source identity](source-identity.txt),
[published body snapshot](PR-BODY.md). Main321 base, publication head
927c46e15cea9b95a5e2cb6c9119aaa04ce40d31, built code
09f4cd183092a13a5fdaaec34c7c612322775502; later changes are documentation only.
Build, protected prefix/pragma/rollover and Clang fuzz checks, plus selector pass.
Frozen printer measurements qualify only the prefix-offset slice and -E -P.
The report's pending scalar-shim statement is historical; later PR692 status is
recorded in the common supersession note without claiming new full-suite tests.
''' + common,
    'publication-647': '''# Publication scope: issue 647

[Authoritative report](README.md), [corrected selector](selector-corrected.log),
[initial negative selector](selector.log), [workflow](workflow-step.sh).
Main321 publication head b645da36951e15d7e4fbad6c5b800618e5e164d4, built production
merge b9e061467bff4df6810ce0b62f1d5e1f7c7021f8. Later changes are docs and two
workflow condition lines. Build, streaming/runtime/bytes, one-CPU skip behavior,
ISA selection and call graph pass. Six initial selector failures were corrected
in workflow gates; the final selector has 1,133 checks and zero failures.
This is benchmark configuration qualification, not compiler throughput evidence.
''' + common,
    'publication-664-674': '''# Publication scope: issues 664 and 674

[Authoritative report](README.md), [664 published body](664/pr-body.md),
[674 published body](674/pr-body.md), [binary identities](binary-identities.sha256).
Both refresh on main 321. Issue 664 head 1eaf52025dd45c500e316fe6dc1a6dcaa28cd208
keeps qualified tier0 code byte-identical; build/syntax, 95,965 Tier0 checks and
ISA selection pass. Issue 674 head 40ea0a058513ca2933232cfc7d30f7c046576fbe passes
build/syntax, 6,411 sanitizer checks, driver and verified scalar/vector object
comparisons. Its full checker has four known local fpclassify disagreements,
not a full pass. Only the frozen eight-worker effect is qualified; one-worker
gain remains unresolved. No refreshed-main throughput gain is inferred.
''' + common,
    'publication-590-652-657': '''# Publication scope: issues 590, 652 and 657

[Authoritative status snapshot](regions-publication-status.md),
[652 qualification](652/QUALIFICATION.md), [657 identity](657/source.txt),
[590 identity](590/source.txt). All use main321. Publication heads are
657 ed73205fa8298dffafdd8e4552a31e9a764fbc59,
590 d1a9070b300ed95f517d3373b6b70b6abc00fef7 and
652 a08583d3ef27672309a9f3ee42f1212ba4cab69d. Each 41-unit build passes.
657 region/driver, 590 startup/lane/driver and 652 reuse/cleanup/driver/parser
and call-graph checks pass at their recorded code identities. Later doc-only
heads remain distinct from built identities. 590/652 address bounded slices;
their broader setup work remains open. Frozen performance is not remeasured.
The 657 publication uses reader->subtree_sizes as validated d3; the older
parser->sizes source is historical. Region fixtures cover normal/tree_only
and scalar/vector modes. For652, isolated A/A, A/B and reversal controls
supersede the contextual mixed-role method; SQLite remains neutral. For590,
THP-disabled means per-process policy, not madvise, and tcc remains faster.
''' + common,
    'publication-628': '''# Publication scope: issue 628 on main321

[Built source](SOURCE_COMMIT), [compiler hash](compiler.sha256),
[object controls](objects.log), [full checker](checker.log).
Built head 722ecc1b95817ec15b6c2f95fd137f411d7e0905 refreshes the qualified parser
and nullable-ASM slices on pure321. Published a70bca0106d0ea01bb7a2562f222b23064118cdb
adds only six documentation lines; production code is unchanged. Build, parser,
ASM, driver, deferred, call graph and object controls pass. The full local
checker retains four known oracle disagreements (464,841 checks), not a full
pass. Frozen416 measurements establish bounded RSS only, without wall/system
gain. Bulk-NONE/output-fill and issue-628-fill remain entirely excluded.
''' + common,
    'publication-641': '''# Publication scope: issue 641 focused stack refresh

[Authoritative report](README.md), [guarded oracles](guarded-oracles.log),
[corrected controls](controls.log), [rejected harness attempt](controls-rejected-filename.log).
Head 725fe7fd178b9bcac7819cfc74b395f1bf58e6ad ports retained code 9b319dd3 onto
focused 628/a70bca01 on main 321; final merge completes doc-link ancestry only.
Syntax/build and recorded driver/deferred/lanes/ASM/corpus, sanitizer and byte
controls pass. Checker 463,928 has four known shared local oracle disagreements,
not a full pass. Independent review found no concrete retained-scope defect.
Larger selection metadata, 674/658/673, rejected 653 and PR 678 are not this delta.
The issue remains partially addressed; historical RSS/representation evidence
does not establish robust whole-compile or refreshed-main speedup.
''' + common,
    'publication-658': '''# Publication scope: issue 658 focused stack refresh

[Authoritative report](PUBLICATION.md), [source](SOURCE_COMMIT),
[identities](identities.sha256), [independent object/runtime controls](object-runtime.log).
Head 96a4ad102cb7882ba834374ddfcf38eac080b924 ports the qualified eight-file literal
slice atop focused 641/725fe7fd and 628 on main 321. Build, ASM, deferred, driver,
2,869 sanitizer checks, pinned220 corpus, call graph, nine full object/diagnostic
comparisons, 9,225 native value checks and SQLite byte controls pass. Full checker
466,880 retains four known local oracle disagreements, not a full pass.
The first standalone sanitizer link failure and correction remain preserved.
One-round SQLite output equality is correctness, not new timing qualification.
''' + common,
    'publication-673': '''# Publication scope: issue 673 on main321

[Authoritative report](README.md). Source 35d22324a5407e653dcb46b9a59f6953f1daabc0
refreshes frozen worker ownership on main321. The 41-unit local build, lanes
3,200/0 including protocol186/0, driver21,648/0, call graph and selector pass.
Worker protocol and tests byte-match frozen 1d076d67; main/driver integration is
refreshed. The historical ownership matrix and balanced controls retain the
real uneven-tail cost. No old measured gain is transferred to this head.
''' + common,
    'next-main-d3-local': '''# Frozen next-main d3 local qualification

[Authoritative local report](README.md), [exact identities](IDENTITY.txt),
[commands](commands.txt), [corresponding native receipts](../next-main-d3-target/ARCHIVE-SCOPE.md).
Source d3c1d45d087f5b9ac1e54e2ba66248efa623f3d8 uses old pure416 ancestry,
removes rejected 653 and adds the qualified parser and 647 configuration. Built
0665883645b633d199cd89f6ef45180249c3dbc9 differs only in the later 673 doc delta.
Its bounded local suites and object controls pass, while the full checker has
four oracle disagreements also present in pure416. At this frozen stage ASM
was still excluded; later dc15 qualification does not alter this record.
This is not current321 or pinned-a11 compatibility acceptance and not timing.
''' + common,
    'next-main-d3-target': '''# Frozen next-main d3 native target receipts

[Native tests](next-d3-tests.log), [separate parser](next-d3-parser.log),
[build](next-d3-build.log), [image identity](next-d3-identity.log),
[source verification](next-d3-source-check.log),
[local source identities](../next-main-d3-local/IDENTITY.txt).
Exact d3c1d45d087f5b9ac1e54e2ba66248efa623f3d8 is the old416-based integration,
not main 321. Native build 41 passes; ten bounded groups pass, parser passes
separately, tracked source checksums match, and 673 implementation/test source
matches its qualified source. Native image is
c9c49e755ec9b7f6c7cc853f7ad7d7f9db5239e18af37c61a3418424f125cae0.
These receipts establish frozen functional/source identity, not new speedup or
latest-main/9794 compatibility. They remain separate from d74's 321+a11 union.
''' + common,
    'publication-method': '''# Publication archival method and revision boundaries

[Incremental collector](curate_publication.py) reuses [bounded archival core](curate_evidence.py).
Every copied file is byte-identical UTF-8 without NUL, at most 5 MiB. Each folder's
COLLECTION.tsv records original path/bytes/SHA256 and copied-text versus
retained-local-raw. Generated ARCHIVE-SCOPE.md is the sole added interpretation.
Binaries, objects and large raw payloads remain local. Reports' PR/CI statuses
are snapshots, not fresh live-state checks. No target work or new timing was
performed by this curation; no bulk-fill or issue49 result is accepted.

The local 89eb PR 692 checks are historical. The final reviewed head
9794f6a4221c85ca3e8bc2b041003b17ad30a56a was externally reviewed and merged into
the 678 feature branch on 2026-10-28 at 15:00 UTC via
ece866b0f3b6c065f3145d2efbef28f9e5f572fe, target prior head
620f318e8ae26ab908d81a09f66eb676575a2dd9. This publication-status fact was supplied
by the coordinator; it is not a local final9794 full-suite pass. Three helper/
edge files byte-match89eb; the capture fixture now tests both requested modes
using pp.options.scalar, and the window-test delta was removed because upstream
restored the requested protocol. Do not transfer historical whole-suite results
to 9794. Frozen d74 compatibility remains valid only at its own main 321+a11 pin.

Collections are append-only snapshots. Existing root README, SOURCE-REFS.md,
COMMANDS and frozen issue/compatibility records are not overwritten.
''',
}


def inventoried(collection, relative):
    if collection == 'next-main-d3-target':
        return len(relative.parts) == 1 and relative.name.startswith('next-d3-')
    if collection == 'publication-method':
        return len(relative.parts) == 1 and relative.name in {'curate_evidence.py', 'curate_publication.py'}
    return not any(part.startswith('output-fill-') or part in {'issue-628-fill', 'target-fill'}
                   for part in relative.parts)


core.inventoried = inventoried
core.admitted = lambda collection, relative: inventoried(collection, relative)
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--verify', action='store_true')
parser.add_argument('collections', nargs='*')
args = parser.parse_args()
selected = args.collections or tuple(core.COLLECTIONS)
if any(name not in core.COLLECTIONS for name in selected):
    parser.error('unknown publication collection')
for name in selected:
    (core.verify if args.verify else core.collect)(name)
