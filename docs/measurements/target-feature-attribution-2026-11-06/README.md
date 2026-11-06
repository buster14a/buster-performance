# PR #1313: SQLite instruction attribution and integration controls

This is an archival follow-up to [#279](https://github.com/buster14a/buster-performance/pull/279). Neither the diagnostic fixture-omission build nor either fixture-data prototype is proposed as a merge-ready change. **The literal zero-delta criterion has not been established.**

All measurements used the Ryzen 7 9700X and Clang Release, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, CPU 2, `instructions:u`, and the frozen SQLite source and options captured by the scripts and identities in `raw/`. Each build, link, debugger run and measured compiler process used a separate shared-lock grant. The scripts stop on failure and write a completion marker only after the listed runs; individual lock-owner receipts were not captured, so the record relies on those scripts and the retained process outputs rather than claiming separate positive holder receipts. All measured perf events ran 100%. The executable hashes and input hashes are retained. GDB changes execution and its counts are diagnostic, not performance qualification.

## Original-base attribution

The #279 comparison used base `a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6`, PR head `5929d0e2e2ab5a179313c082811b59a3ccdd0e0d`, and integrated tree `17c98f3e603bf4adb17cdd04bb2d2a0f0fd53555`. In `raw/hybrid`, a **disposable diagnostic** preserved the production PR change while omitting the added fixture source and registration. Three interleaved syntax-only medians were 1,363,327,256 base, 1,363,344,904 integrated, and 1,363,327,332 fixture-omitted. This associates the large change with the fixture-containing build; it does not justify removing tests. Its `.text` and `.bss` starts matched base.

In `raw/pad`, a 2 KiB read-only padding object was linked into the unmodified base as an isolated diagnostic. It shifted `.text` and `.bss` by the same 4 KiB as the integrated executable, but four padded-minus-base syntax-only pair deltas were −71, −98, −27 and −120. Thus this section-start shift alone did not reproduce the original increase. Padding was not a candidate fix.

In locked GDB runs, the resolved libc implementation was `__strlen_evex512`. Its short-string page-cross path performs two more user instructions than its fast path. Counting entries to that path over the original SQLite syntax-only runs gave **14,970 base and 23,879 integrated**, both with exit status zero. Eight early attribute-rule strings crossed onto the slow path, each encountered about 2,972 times; five later rule strings moved off it. The net **8,909 extra entries** predict about **17,818** instructions, close to #279's +17,810 whole-compile and +17,645.5 syntax-only medians. This supports a concrete layout-sensitive contributor, not an exact partition of all instruction differences. The relevant string-offset inspection and raw GDB counts are included.

## With #1530 integrated

On later main `e124528504f665fa33b6925146ecaa47b0cb1a9d`, compare #1530 head `e94fd0d2bcada50d237ac14206a32cf2b68dc1ff` integrated alone (tree `5124f1e1dfdffbb82586b630c99127f4c361b6a0`) with the same integration plus #1313 (tree `3e8f87826830dca29a688f373f28b3e7b7808342`). Five syntax-only pair deltas were +2,522, +2,522, +2,532, +2,557, +2,513 instructions. Five `-c` pair deltas were −12,725, −12,681, −12,638, −12,655, −12,718 (median −12,681). All ten objects had the same SHA-256. The tracked refs remained unchanged after collection. These are temporary integration trees, not PR heads or evidence for a later base.

The relevant rule-name strings were on the `strlen` fast path in both #1530-integrated builds. GDB counted **86 vs 103** page-cross entries over the syntax-only process; the net 17 entries cannot account for the +2.5k syntax-only residual at two instructions per entry. This record does not identify that residual or the cause of the whole-compile decrease.

## Fixture-data prototypes

Two isolated, unpushed prototypes preserve all 29 exact fixture records and keep the existing driver and standalone harnesses. They move the table to a separately linked test-data translation unit; the second stores names and source strings inline instead of as mergeable string literals. Both add the new source to the self-corpus's manual source list. The self-corpus also has a separately identified pre-existing missing source; it was not claimed passing here.

Against the same pinned e124 base, five `-c` deltas were **+960, +899, +961, +964, +912** for the pointer-record split (tree `8cff3f7e632699fa80566634fa631cd912ebdb9b`; median +960), and **+1,281, +1,193, +1,224, +1,210, +1,235** for inline records (tree `6f957e6fe07f7768485918db7b51bea6d9e3d803`; median +1,224). All objects matched their bases and refs remained unchanged. Neither meets the literal zero criterion, so neither is a proposed fix. Exact patches and raw results are included. Local Clang 23.1.4 builds, all four checker-driver parts, and the compatibility/mixed standalone harnesses passed for each variant; logs are included. The pointer-record driver runs preceded its source-list-only correction. These local checks do not replace hosted or 9700X qualification.

## Retention and limits

`raw/` contains individual counter outputs, diagnostics, hashes, worktree identities, build logs and completion markers; the scripts and diagnostic patches are alongside it. Sixteen unrelated lock-holder message stanzas are replaced with a redaction marker; the original records remain on Benchpress in `~/buster-fast-bench/1313-current-codex`, `~/buster-fast-bench/1313-1530-current-codex`, and `~/buster-fast-bench/1313-extract-current-codex`. Other users' lock-holder details are not necessary to assess the results. These runs are limited to one host and one input; no broader performance result or PR merge-readiness follows.

Collector and reviewer: OpenAI / GPT-6, Codex thread `01a1b0e0-d979-7e63-94ff-ff91f3213a51`; independent source and offset analysis: thread `01a1b17f-7ec3-76f2-8278-bf9e6685e71f`; parent session `01a1b0e0-a314-7252-9c29-d958f2e64d73` (no share URLs exposed).
