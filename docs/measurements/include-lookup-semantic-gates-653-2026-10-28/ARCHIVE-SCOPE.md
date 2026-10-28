# Archive scope: #653 remains unresolved

[Negative results](RESULTS.md), [original C reproduction](lookup_semantics.c),
[exact commands](REPRODUCE.txt), [source and baseline identities](identities.txt).
This is an evidence-only record of two rejected mechanisms, not a compiler fix.
Stat-first can suppress open's EMFILE priority; a pinned-directory lookup can
read an old header after an ancestor replacement even though self-stat identity
and timestamps are unchanged. The original helper exits zero only when those
counterexamples are reproduced, not when either shortcut is equivalent.

The warm local operation-cost screens are eligibility observations on Ryzen 9
7940HS / Linux 7.3 / Clang 23.1.4. They establish no native/compiler/9700X performance
qualification, first-hit or whole-process neutrality. No compiler patch, target
campaign or fix count follows. The existing [directory-snapshot negative record](../unclaimed-perf-2026-10-28/issue-653/README.md)
remains separate and unchanged. Ownership remains with the coordinated residual
investigation in [claim comment 6477119332](https://github.com/buster14a/buster/issues/653#issuecomment-6477119332);
publication does not release that claim.

All twelve original local package files are identified in COLLECTION.tsv.
Ten bounded UTF-8 text files are copied byte for byte. The two compiled helpers
remain local raw, with their exact identities preserved. SHA256SUMS is the
unchanged complete LOCAL package manifest, including those omitted executables;
its own SHA256 is 432072777ac64dfb158f0624e8e85ab95405a7fcddf08f335aaa59d21b12633f.
Use COLLECTION.tsv to distinguish publicly copied files from local-only files.
The copied RESULTS.md's no-PR/comment wording records its pre-publication state;
this evidence PR and the authorized claim update occur afterward, without any
compiler PR or performance claim. Original raw receipts are not rewritten.

The C probes and their marker fixtures are original; no external implementation
or corpus is imported. Linux manuals are interface references. Existing source
SPDX notices and [repository provenance/terms](../../../THIRD_PARTY_NOTICES.md)
are retained; this collection introduces no additional or blanket license terms.
ARCHIVE-SCOPE.md and COLLECTION.tsv are generated archival interpretation/index,
separate from the original byte-exact payload. No human DCO trailer is claimed.
Collection reused the existing archival core from evidence commit 9f50a7ba6,
SHA256 bfdeac4d147a2b9fa37f85ee8f6a7014c90e74fcc1b8b388d9be14e57692a43c.
