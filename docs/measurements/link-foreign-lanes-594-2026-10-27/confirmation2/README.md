# Completed #594 confirmation, October 28, 2026

This completes the redesigned confirmation left pending in source PR #644.
Two passes of `confirm594d.sh 2` ran on the shared locked Ryzen 7 9700X,
with the retained `lists594d.py`/`procbench.c` and unchanged inputs/toolchain.
Each pass releases the host lock between A and B. All four holds completed
with status zero; all 7,750 raw process invocations returned zero. Analysis
retains 6,560 samples after excluding warm-up rounds/commands. All 28 cases
have byte-identical outputs across their four, seven or eight variants.

## Identities and the final benchmark row

`builds594.sha256` identifies the unchanged executables. Every tracked
`src/` file and `build.sh` in the preserved v1 tree was checked against PR
head `f4f632ca405e3e83a060f1fe3c163e505ce42110`: all match except
`link_benchmark.c`, whose later revision adds the fourth placement row.
`pr644-head-code.sha256` retains the checked head manifest. These process
comparisons qualify that exact foreign-linker implementation; no executable
was replaced between passes.

The later benchmark row is qualified separately by successful PR-head
9700X [workflow 40577932661, job 122449332690](https://github.com/buster14a/buster/actions/runs/40577932661/job/122449332690),
which ran all four rows (default, forced eight, unpinned one, pinned one)
on small, 2,000-worker and 102,400-worker programs. Selected original lines
are in `current-head-ci-excerpt.log`; the linked job retains its full log.
The obsolete v1 benchmark was not rerun: after dispatching the confirmation,
only its outer chain shell was stopped, leaving both confirmation passes
to finish normally. `outputs594.sh` then verified the final output identities.

## Results and limits

Small-case default versus forced one at the same unpinned placement has
paired median changes -1.58% to +5.21%; every interquartile range spans zero.
Pinned default versus pinned one is -3.10% to +2.63%, again with every range
spanning zero. This does not establish exact neutrality, a universal
never-slower guarantee, or a small-link speedup. Forced eight versus the old
executable also has every small-case interquartile range spanning zero.

Placement remains material: unpinned default versus forced one on CPU 2 is
+23.34% to +45.36% for dynamic PIE/static PIE/shared cases and +23.53% / +23.34%
for static executables (paired medians). The added same-placement benchmark
row exposes this instead of attributing it to lane selection.

At 5,000 workers default versus unpinned one is -3.77% to +2.37%, with ranges
spanning zero. At 10,000 it improves 7.10% to 19.76%; at 20,000, 18.59% to
31.83%; at 40,000, 28.14% to 38.84%; at 102,400, 37.28% to 46.53%.
The large comparison has eight samples and separate one/eight lists. This
avoids the old fixed predecessor bias but is not a simultaneous A/A control.

The serial first-input opening is not free relative to forcing eight lanes:
at 40,000 workers paired default/forced-eight cost is +1.60% to +5.85%,
and at 102,400 it is -1.12% to +2.12% (shared-library IQR +0.94% to +3.11%).
These costs remain visible; the default still improves the old one-lane
policy substantially there. This supports the bounded adaptive default,
not an optimal count for every link.

`analysis594d-final.txt` retains every count, paired interval, time,
instruction/fault/RSS result and phase summary. Raw tables and command lists
are beside it; original phase reports are `time-reports.tar.xz`. Parent sweep
and confirmation1 evidence remain unchanged. No host settings changed.
The harnesses remain the original first-party material under the existing
project terms; no external implementation was imported by this continuation.
