# #653 residual investigation: two new mechanisms rejected at semantic gates

No compiler change is qualified, and #653 remains unresolved. This work does
not restore or retune the earlier directory-enumeration policies. The original
negative campaign under `../evidence-653/` is untouched. No target campaign,
compiler-fix commit, PR or issue comment was made by this worker.

Root reclaimed the residual scope in issue comment 6477119332. The private
compiler worktree is `work/next-653`, branch `codex/perf-653-residual`. It started
at `296e5b056e13ae51d908a4efd78aa4311ae8a15d` and moved forward, before any
edits, to `e7f89091648f68940b595aadd648841c1ffc3ec5`. Production
`c_preprocessor.c` is byte-identical at those revisions, SHA256
`e197cd76c98ba60eb38acb2f2dc1737f258d0f45189b3511c52739cd05d3cf33`.
The compiler working tree remains clean.

## Concrete alternatives

1. A prediction could select `fstatat` for likely missing include candidates.
   Only an actual kernel ENOENT would answer a miss; every other result would
   fall back to unchanged open/fstat/read logic. There is no directory listing,
   name set or pinned directory, and every candidate is freshly checked. This
   is different from the rejected namespace snapshots, but its failure priority
   is not equivalent to ordinary open.
2. Cached directory descriptors plus `openat` could reduce repeated pathname
   traversal while retaining a kernel lookup per header. This does not enumerate
   names, but it pins directory identity and can miss a replacement ancestor.
   Checking only that pinned directory's identity/timestamps is insufficient.

The original standalone C probe reproduces both failures on an ordinary local
filesystem. This is a design rejection, not a regression introduced into Buster.

| Gate | Ordinary operation | Proposed shortcut | Observation |
| --- | --- | --- | --- |
| Missing header, child descriptor table exhausted | `open` returns -1 / EMFILE (24) | `fstatat` returns -1 / ENOENT (2) | Stat-first suppresses the resource failure that an active include must preserve. |
| Header after replacing a directory ancestor | Full path reads new marker B | Pinned-directory `openat` reads old marker A | Pinned directory dev/inode/mtime/ctime are all unchanged. |

The namespace fixture does not modify either header's payload. It moves the
old parent, creates a new parent/leaf and new header, then compares a first
header lookup through the full path with one through the saved descriptor.
Thus a self-stat or guessed directory epoch cannot fix the ancestry problem.
The resource limit is changed only in a forked child; the parent is unaffected.

An extra allocation/probe to reconstruct open's resource priority pays back
the work the stat shortcut hoped to avoid. Revalidating the complete directory
pathname recreates the original traversal before adding descriptor bookkeeping.
No such fallback is claimed as an optimization. No guessed FD/global-filesystem
epoch, watcher-based shortcut or relaxed namespace contract was introduced.

## Local operation-cost screen, not compiler performance

The first probe uses 21 alternating pairs, 4,000 operations per sample, on
missing and present fixture paths. The present path includes open, fstat and
close; stat-first adds its preflight. All individual status checks succeed.
The OS page cache is unforced. Local clock timings are eligibility observations,
without a compiler binary comparison, A/A qualification or target claim.

| Median operation cost, first screen | Ordinary open path | Stat-first path |
| --- | ---: | ---: |
| Missing path | 1,567.499 ns | 1,207.585 ns |
| Present path | 1,899.427 ns | 2,706.904 ns |

That screen saves 359.914 ns per miss but adds 807.477 ns per hit: a synthetic
break-even miss fraction of about 69.2%. It cannot justify implementation,
because the independent resource-error gate fails. It does not establish
first-hit, live-header, small-file or whole-compilation neutrality. No compiler
patch reached those later performance gates.

The separate final-helper rerun again observes both semantic counterexamples.
Its missing-path medians are 1,744.883 / 1,337.634 ns, present-path medians
1,997.960 / 2,800.713 ns, and synthetic break-even fraction 66.3%. Both screens
are retained; neither is selected as performance acceptance. Their variation
does not affect the independent semantic rejection.

`lookup_semantics_first.c`, `lookup-build.log` and `lookup-semantics.log` are the
exact first screen. `lookup_semantics.c` adds zero initialization for uncommon
fixture-setup failure paths; the successful tested mechanisms are unchanged.
Its separate `lookup-build-final.log` and `lookup-semantics-final.log` preserve
the final rerun, including all samples rather than selecting a favorable one.
Each build uses a local two-core grant and each single-threaded execution a
one-core grant. No process or system setting is changed outside the child.
The helper exits zero only when both counterexamples are observed and the
ordinary operation checks are valid: zero here confirms the design rejection,
not equivalence of either shortcut.

Local host: Ryzen 9 7940HS, Linux `7.3.0-5-cachyos`, Clang 23.1.4. This is not
the 9700X target. The C helper is original plain C and includes no compiler or
external implementation. Linux interface facts were checked against
[open(2)](https://man7.org/linux/man-pages/man2/open.2.html) and
[stat(2)](https://man7.org/linux/man-pages/man2/stat.2.html); the observed error
priority and namespace counterexample come from the retained executable probe.

## Remaining scope and prerequisites

Current source still opens each uncached include candidate. Its exact-path cache
already retains known positive and negative paths across the shared run. A learned
header location alone cannot prove that earlier directories lack an overriding
header, nor preserve include_next. It therefore cannot skip those probes safely.

A future mechanism must preserve ordinary open's resource/failure behavior and
live path resolution, or supply an independently proved fallback whose cost is
below the saved work. No bounded mechanism meeting those conditions was found
here. That is not a claim of general impossibility. New kernel/search interfaces
or stronger explicit caller contracts would be separate design work, not an
unqualified performance fix. Root should keep the remaining problem open and
must not count these rejected alternatives or lower syscall counts as a fix.

The pure local baseline images were identified, not used for a candidate compiler
timing comparison: 296 SHA256
`cd2fd425cdc265acc7c16b3f98ab86af03dd7e2fdfb0d8033d1067355a3fc763`, e7 SHA256
`523ceb8df0435c089e10ba78dbc8e08be8062d7a2f10d96f4c3bbd734006865a`.
No earlier quarantined target staging artifact was used. Any future accepted
proposal still needs first-hit/live/tiny/whole-process controls before root
reviews a target plan.
