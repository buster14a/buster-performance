# PR695 lossless token-return adoption

Audit started2026-10-28 at15:41UTC. Live695 was still draft/open, head
35d22324a5407e653dcb46b9a59f6953f1daabc0, with successful original exact-head
CI and a blocking source review. The guardian's single nonblocking return
write retried EINTR but exited after EAGAIN, retaining/discarding63 opaque
credits from a full fragmented Linux pipe. Original186 checks did not exercise
that case. Published negative reproduction uses a single real make4.4.1
recipe at-j65537:65,536 initial explicit credits become65,473 after release,
and make exits2. A one-page synthetic opaque multiset gives the same loss.
The green original CI does not close that independent protocol finding.

While the audit ran, correction author published commit
b1b3e490cde7639e2030619c7b0054f352327679 on the separate branch
codex/695-lossless-jobserver-return, direct child of35d. Public evidence and
source-clearance scope:
https://github.com/buster14a/buster/pull/695#issuecomment-6473483036 .
Only worker_budget.c, worker_budget_test.c and docs/function-lanes.md change.
The original signed commit and proposal branch are preserved; adopting it
requires no rewritten commit or signature. Module SHA256:
29f3e52bcca1d9855c96dce3f264ba621985dd226c78a34ffdd7454bb95692e4.

The correction reserves a pipe-capacity recovery buffer and faults its pages
before borrowing any token. A fragmented EAGAIN return drains available bytes
into remaining buffer space and restores the combined multiset, retaining
every partial-write suffix. EINTR or transient IO failure cannot acknowledge
and discard credits. No work is performed using additional recovery bytes.
Under GNU make's unchanged pipe-capacity/credit-conservation contract, all
pending plus available explicit credits fit that storage, allowing the pipe
pages to be compacted without another recipe. Valid private endpoints stay
open until ownership is cleared. Independent regions657 read-only review
found no concrete defect in this invariant or guardian lifetime.

Own focused exact-module checks use a real-reexec adapter with production
guardian dispatch first, not fork emulation: optimized native204/0 and
ASan+UBSan x86-64204/0, with no recovery. Original186 checks remain and18 new
assertions exercise full-pipe normal/negative ACK/reuse/SIGTERM/SIGKILL cases.
Disassembly confirms mmap then memset before the first borrowing read, so
the prefault remains in optimized code. An initial copied adapter resolved an
obsolete relative issue-673 path and passed181 old fork checks; both receipts
are preserved as protocol-rejected-old-source-*.log and excluded. Corrected
headers resolve through the exact adoption checkout and include real dispatch.

The public exact-source proposal additionally reports41-unit build,
3,244 lane/21,648 driver checks, callgraph0bad, both real make pipe/FIFO
65,536-token return controls,1,050 guardian leases plus1,536 conventional
contention iterations across three capacities, and allocation/transient-error
injection. Those are credited as the proposal's independent evidence, not
relabelled as our new runs; they were not unnecessarily repeated.

Bounded private composition freezes at
b66527e33d2fac90c6eca9c62a75926f6bd60118, combining main
241fcb3e9a5a55d8ccc3dfffc7d9d0efd56bdda7 (including683/#113), exactly
678head4b2a8a6f51cf8dee5a5833a8f32138d865d780b8,687head
a08583d3ef27672309a9f3ee42f1212ba4cab69d and b1. Both native/generic builds
pass41 units. Guardian dispatch is before MAKEFLAGS dry-run/unit routing;
budget capture is before ordinary IO; final worker_budget_close is outside
both optional mapping-release guards. The default production driver still
reads source order; new113 deferred scheduling is explicit and its full
reader-reuse matrix belongs to root's separate twelve-head batch.

Native binary11e786a55ee20577de75b521f02a4ff85eb9b797191d3c06bfc57751ed832d7f;
generic112a9abd824d18d33ba9b79afd4472d59f9f33c63c7d8e69128b7618c354eef5.
Each build/test uses a separate local two-core grant. Generic build uses the
pinned private baseline runtime and separate output directory. No new remote
or performance campaign is attributed to this correction; the added
capacity-buffer setup cost is unmeasured. Historical673 timings remain scoped
to their original source. Root owns full-batch validation and PR metadata.

Actual compiler lane/protocol smoke on that exact bounded composition passes
native2,682/0 and generic2,716/0 (`--programs2 --seed172`), including the
expanded204-check protocol in both command homes, termination and output-byte
comparisons. No broad checker/full-batch suite was launched here.

Evidence PR64 was externally merged15:38:53UTC: its head is942170fffc4c8e533fe6b7a00a73fce067e79bd4,
actual merge commit4cb1f6aea8d8b69fe8a4dfeb77ce20caaee9fed9. Its publication
review addendum preserves the original defect; it does not certify old695.

Root follow-up at16:03UTC: another coordinator composed the public695 branch
with678 and687 atce8be68972d192ccbabb989dc8c819b39f50f19b. The b1 correction
remains an ancestor; worker_budget.c retains SHA29f3e52...592e4. Git diff of
the complete publicce8 tree against our tested privateb665 tree is empty.
Both tree IDs arec7627b0d586819ee942ada2e1b28cb8c8d9af854, recorded in
composed-tree-identity.txt. Thus the bounded local source checks apply to the
same tree; independent hosted native/baseline checks are still in progress.
Their fresh run40721763988 supersedes b1-onlyrun40721330765. No owner branch
was overwritten and no new timings are inferred from tree equivalence.

Adoption completed2026-10-28 at15:58:22UTC. Immediately before the push,
live codex/pub-673 was still35d and the adoption checkout was clean atb1,
which has35d as its direct parent. A normal fast-forward push updated only
codex/pub-673 to b1b3e490cde7639e2030619c7b0054f352327679. No proposal
branch, original actor checkout, other PR, metadata or comment was modified;
no force push or GitHub merge occurred. Remote/API checks confirm b1.

Fresh exact-b1 CI started as9700X workflow40721330765 (initial change job
122932729878) and measurement-policy workflow40721330773. Both were
in-progress when handed to root; this report does not call them passed or
reuse old35d greenCI as correction qualification. Root owns fresh CI status,
PR metadata and the separate twelve-head main241 integration matrix.
