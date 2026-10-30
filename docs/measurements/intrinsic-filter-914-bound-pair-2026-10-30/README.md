# Prospectively bound intrinsic-filter pair (#914), 2026-10-30

This is a **new**, prospectively input-bound pair for [Buster #914](https://github.com/buster14a/buster/pull/914) and the remaining narrow [#893](https://github.com/buster14a/buster/issues/893) sampled-work criterion. It compares the original unfiltered source `d12fd5831f9c73bb7b30505da2ce9616e915143e` with filtered source `58b1191558fbef0b542cbe92b1e2da329f16d7b6` on the approved Ryzen 7 9700X. It does not modify, retrospectively bind or replace performance #146, its captures, assets, failures, tag or [recorded input-binding limitation](../../measurement-review-notes/pr146-recorded-workload-binding-2026-10-30.md).

The actual new pair's collection and offline protocol gates passed primary and independent review. These observations concern the original two binary placements, with the limitations below. This packet performs no source approval, readiness change, issue closure or merge.

## Exact new execution binding

The original compilers are unchanged: BASE SHA256 `e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf`, HEAD `67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75`. The new controller source is performance commit `c6b5391bff3a23d082dd28ef2598b7ea76e53300`, source SHA256 `5f7e12028829fbed3bd5ac92fdb80e0d003376a25f69ae1a08b41de008c1ea17`; actual ELF `5ea2ab425351468c58b6f135098ca7d1cda1881331fa6be6d0e8e6b3c06da7a0`. [Ordinary hosted build 41110005938](https://github.com/buster14a/buster-performance/actions/runs/41110005938), job 124249668470, compiled only this controller. The original artifact ZIP, source/argv/input/runtime/status receipts and ELF ABI were authenticated; no Buster compiler was rebuilt.

Both arms used one newly staged private root, independent archive-derived headers and SQLite, explicit pinned predefines and `-nostdinc`. The complete 781-header/four-SQLite manifested snapshot, archive/manifests/predefines and actual command-bound paths were verified before **and** after each arm; readonly modes/no-link checks and compiler/tool/runtime hashes also pass. This binds the new consumed workload to a preserved private verified snapshot rather than a later hash of an old shared path. The pinned public input archive is `preprocessor-391e729af658-ci.tar.zst`, SHA256 `ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2`; per-file receipts are in [raw/input-stage](raw/input-stage/).

BASE ran once at 19:32:31Z; HEAD once at 19:45:13Z. Each has 30 distinct fresh compiler PID/TID pairs/status 0, compiler CPU 2, recorder CPU 3, `cycles:u` period 250003, DWARF 4096 and 1 MiB writer buffer. Each measured process had exactly HOME/PATH/LC_ALL/LANG with the recorded safe values. Separate fair host-lock holds bounded each arm at 470 seconds plus 5 seconds termination grace. No retry or replacement occurred. Both final objects are byte-identical, SHA256 `8fb4adbd900d6e19c3bf5857852a8f5dfaf0f30de74b5cf2796c8a01973940c6`; only the final reused output per arm was retained.

## Observations and coverage

Every sample has reported period 250003. Both denominators include all 30 successful compiles, including processes without a sampled memcmp event.

| Target estimate, reported periods per compile | BASE | HEAD | HEAD change |
|---|---:|---:|---:|
| Direct initialization/outlined-lookup family | 4,683,389.533 | 3,550,042.600 | −24.1993% |
| Caller-proven libc memcmp | 1,016,678.867 | 216,669.267 | −78.6885% |
| Optional disjoint sum, **not inclusive cost** | 5,700,068.400 | 3,766,711.867 | −33.9181% |

Direct-family events are 562→426; proven memcmp 122→26. All 30 PIDs have direct events; memcmp is sampled in 30/30 BASE and 19/30 HEAD processes. The 11 HEAD zeros remain in `/30`; unsampled does not mean unexecuted. Compiler samples 74,872/74,474 join raw and complete primary/CFI streams by exact ordinal/PID/TID/IP/period/CPU. One noncompiler sample per raw capture is excluded from the compiler denominator.

Both audits report zero LOST/LOST_SAMPLES/THROTTLE/UNTHROTTLE. Empty chains, empty user chains, leaf mismatches, short libc chains and complex libc-family chains are zero. Other immediate libc-from-family events 17→26 and nonuser/skid 167→163 remain explicit. Primary unknown-symbol counts are 3,343→3,303, mostly libc/private symbols; unknown-DSO counts 167→163. No global/private IFUNC symbol-name guess is used. All 701/478 compact target proofs bind actual sampled saved return bytes and original ELF machine calls; memcmp requires E8→PLT→GOT and the relocation naming memcmp.

This is one sequential BASE→HEAD pair at one original placement: no independent A/A, placement replication, causal speedup or confidence interval is established. These are period-weighted sampled estimates, not exact function counters, complete inclusive initialization, universal neutrality or later-main throughput. Raw read_format 20 lacks enabled/running-time fields; zero loss is not an independent counter-duty measurement. The separately bound 220-unit corpus remains in its original scope and is not rerun or mixed into these sample counts.

## Material and reproduction

- [REPRODUCE.md](REPRODUCE.md) gives exact roles, original contexts and stop gates. [plans/offline-plan.json](plans/offline-plan.json) retains all eight exact argv/environment/resource commands. Archival plans are preserved unchanged and are not new execution authorization.
- [analysis](analysis/) contains both audits, proof CSVs/coverage/summaries, the primary/independent reductions and review records. All eight actual commands ran once/status 0 with empty **child** stderr; legitimate queue streams are separate. Offline decoding ran on minipc under eight separate one-core grants; it was not another 9700X measurement.
- [release-assets.sha256](release-assets.sha256) is an explicit **three-new-asset** whitelist: two exact new captures and one inert compiler/decoder/controller/stream bundle. [release-asset-preparation.json](release-asset-preparation.json) records their actual local preparation hashes, sizes and safe members before upload; its `uploaded:false` is a historical preparation receipt, not a later remote-state assertion. Intended tag: `intrinsic-filter-914-bound-pair-2026-10-30-c6b5391b`. Remote availability/IDs require separate verification; a prepared manifest alone is not upload proof.
- The bundle contains exact original compiler ELF bytes and source-specific licenses/build arguments, original reader/adapter with source/license, the new hosted controller artifact ZIP, final objects and full new primary/chain streams. It contains no old 146 release asset/capture and no external runtime ELF. Acquire external runtimes separately and verify their recorded hashes; never substitute local libc for target CFI data.
- [PROVENANCE.md](PROVENANCE.md), copied-file origins and packet hashes distinguish actual capture-host tools from offline tools and preserve all component notices. No sign-off or historical certification is fabricated. All original raw files, TARs, artifacts, modes and history remain intact.
