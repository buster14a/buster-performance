# Publication archival method and revision boundaries

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
