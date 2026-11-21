# Live macro membership in the file-text vector

The preprocessor's low-128-ID bank removed 34,265 of 219,475 scalar name visits on the frozen SQLite compile. Replaying the exact file blocks and their live macro tables cost 34.227 → 46.814 TSC ticks per visited block, +37.082% (+36.317% to +38.813%). The scalar bitset lookup stays in the production compiler. [Scope](https://github.com/buster14a/buster/issues/2850#issuecomment-7065778497) · [Original macro-name experiment](https://github.com/buster14a/buster/blob/ec320d42bbe10f34fc62bf6d0072ba8898da2df0/docs/c-preprocessor.md#L2388)

The ordinary preprocessor checks every raw identifier's live `is_macro` bit and stops at the first expansion its file-text pass must hand off. For a complete 64-token block the experiment compresses the existing 32-bit IDs to saturated unsigned bytes and looks up IDs 0–127 in two vector registers holding the current macro-name bits. Positive results and all higher IDs retain their scalar checks. Partial blocks retain the ordinary scalar membership test. There is no persistent index or source prepass. Poisoned names, builtins and keyword macro names use the same current bits set by the canonical macro table. [Implementation against ec320d42b](patches/pp-macro-bank.patch)

## How many lookups actually went away

The independent counting build charges only visited lanes up to and including the first stopping macro in each block. It checks every omitted candidate directly against `macro_of[id]`. The last two columns count identifier occurrences over all input files; main uses the frozen compiler input. [Per-file counts and full token oracle](raw/native.tar.xz)

| Corpus | Files | Complete blocks | Partial blocks | Scalar identifier visits | Visits removed |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | 1 | 14,064 | 6,927 | 219,475 | 34,265 (15.61%) |
| lua | 34 | 10,433 | 15,750 | 180,217 | 27,309 (15.15%) |
| musl | 1,336 | 67,170 | 85,022 | 1,794,511 | 635,942 (35.44%) |
| main | 1 | 38,009 | 4,167 | 492,644 | 68,218 (13.85%) |

For consumption alone the capture takes the actual file blocks, each visited prefix and its live macro bitset. A growing intern table refreshes the snapshot even before a later set or unset changes its epoch. The uninstrumented replay compares each final 64-bit set and a rolling hash for all blocks, alternating two modes inside each repetition. We exclude the first warmup and retain all 13 subsequent within-process paired passes. The capture's extra 256-byte token rows, snapshots and instrumentation are outside these kernel times and outside the independently measured production process. [Capture patch](patches/pp-macro-bank-capture.patch) · [Exact-snapshot replay](scripts/pp-macro-kernel-safe.c)

## Real source and full compilation

All arms used ec320d42b as source parent on locked Ryzen 7 9700X CPU 2, with the untouched parent and one candidate executable off/on. Six permutations rotated CPU position. Each sample includes separately measured raw PP, fresh huge-page-allowed staged compiler PMU, and two ordinary complete compile children after one warmup. The raw PP process counts setup, actual preprocessing, release and exit. Lua lvm and musl vfprintf are the timing representatives. All measured objects matched in every round. [Full absolute data, controls and paired ranges](raw/paired.tsv)

| Same-binary off → bank | Raw PP user+kernel cycles/token | Paired raw cycles | External wall, ms | Paired wall | Staged user instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | 91.369 → 91.209 | -0.687% (-4.100% to +1.545%) | 117.066 → 117.306 | +0.281% (-0.151% to +0.639%) | -0.005% |
| lua | 323.389 → 327.248 | +0.671% (-3.258% to +2.507%) | 10.918 → 10.916 | -0.188% (-0.706% to +1.143%) | +0.008% |
| musl | 447.345 → 444.843 | +0.120% (-2.124% to +2.020%) | 4.041 → 4.037 | -0.238% (-2.579% to +7.696%) | -0.069% |
| main | 106.526 → 106.883 | +0.212% (-0.972% to +2.410%) | 680.594 → 678.580 | -0.332% (-1.177% to +0.639%) | +0.002% |

The untouched-parent control is included in the table of all sampled metrics. The measured raw front remains above the 35-cycle/token Step 3 target.

## Exact outputs

An independent token, expansion-history, grammar and traversal witness compared every initialized byte and manifest for all 1,372 frozen sources. The original and candidate complete object manifests, stdout and stderr matched on every source under default and `-Wall -Wextra`. One hundred fifty thousand independent 64-lane batches with protected edges matched the scalar predicate, including 63/64, 127/128, 255/256 and UINT32_MAX. The distinct textual suite compared 560 marker, no-marker, default and debug/warning commands on keyword macro definitions, redefinition, self-recursion, push/pop, includes, using poisoned names, pasting and malformed grammar at 14 boundary offsets. [Source, witnesses and drivers](scripts) · [Exact native build, hashes, guard output, case transcripts, manifests and time series](raw/native.tar.xz)
