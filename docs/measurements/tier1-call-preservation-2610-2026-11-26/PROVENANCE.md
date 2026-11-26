# Sources, tools and external inputs

## Buster source and compiler identities

| Role | Source commit | Tree | Hosted run | Artifact |
| --- | --- | --- | ---: | ---: |
| Baseline | `8e4d32879e17b7d9548cad54257a2f8461328366` | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` | 45779319802 | 15097652285 |
| Recipe candidate used for corpus | `96fd0284f8f8173fd191b21c5365ad46ae4b917d` | `47a3dd3b6760ad08b859443f726046113d897d2c` | 45787430606 | 15100804197 |
| Recipe candidate with corrected fixture | `4e89739c94b77a76ccedf3c064f2ac4fbc455910` | `45105152b2c893459ddf39f446dee47a61630bdd` | 45789038744 | Not used for corpus builds |
| Original measurement compiler | `d3889cbc8db8d1b86d3f472afcf56f8fb40a3164` | `6de749285ba89c1c8e61a454164c433809c8f96b` | 45790080564 | 15103315276 |
| Guarded measurement compiler, actual merge | `5b0ebc02873b4ceaa9b40f7633c3c93010fd2786` | `351bd31f9825acf7945a960f09e312c2b2e4333d` | 45795326234 | 15105430135 |

Recipe and original measurement product revisions are GitHub pull-request merges `043fadbaf1f76577f4ba47ce75ebe57f164a2fb8`
and `fd3af5a633acd67ab5bf228fa7b70304a5da9ecd`; their product trees match the named source commits exactly.
The original product identity/configuration/provenance files and external-file manifests are preserved in `compilers/`.

The guarded compiler's requested branch was `6fdee2d8fd056d1ed809e7825256320aeeac23b4`, tree
`81dfea9c54653c31237370da1f2d0724e2f1f140`. GitHub merged it into newer main
`5ce76f08c3ce7ed298009437d699bbc9c90471a4`. The actual product therefore has the different merge/tree listed above.
The branch-to-merge diff adds PR3596 direct-compiler work and PR3621 pointer-conversion diagnostic work, tests and
documentation; no Tier 1 allocator/emitter file differs. The complete comparison and parent identities are archived.
Controls 0/2 have exact whole-ELF and origin-sidecar parity with the earlier baseline/soft-only programs. This
establishes corpus comparability despite the source difference; it is not an exact branch-tree identity claim.

All four products are row `vector none O3`, toolchain identity
`eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259`.
Host flags are `-march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni`.
Clang is 23.1.4, LLVM commit `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`; CMake 4.4.3 and Ninja 1.13.2.

Compiler SHA256 values:

```text
baseline     c090b5d35a9d031afe6a37771445dff87b9541d3521175c45001352164a2b2ff
recipe       1f5a2f93097c5ea915b76865140f5629852351d172663754216dfd17faa11fda
measurement  6c7b35ae36b09373ffef24c4d14dfdea50ac40ed1917fdd8fdbbf2ee07a9214d
guarded      f0f952159a819cc3ebbecdd168a7ac1bbfaf11480ad0123fb554fe26cf8bab7e
```

## Frozen workload inputs

SQLite's two amalgamation files are from the frozen corpus used by Buster's `tools/ci/fetch-corpus.sh`:

```text
https://github.com/buster14a/buster-performance/releases/download/ci-corpora-preprocessor-391e729af658/preprocessor-391e729af658-ci.tar.zst
archive SHA256 ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2
MANIFESTS.sha256 SHA256 391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd
sqlite/sqlite3.c 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d
sqlite/sqlite3.h 9e69a1353a4288450b0d5239ede11fc7f1f4c8e5eb07491fc8317eacb5b7de7e
```

The actual session reused already-available copies and verified those exact two file hashes. The amalgamation
identifies SQLite 3.53.2 and Fossil check-in `d6e03d8c777cfa2d35e3b60d8ec3e0187f3e`. The matching SQLite Git source
is pinned by Buster's fetch script to `ccc132c5be20ab5c755c97a08d06b1b592fef330`.

```text
https://raw.githubusercontent.com/sqlite/sqlite/ccc132c5be20ab5c755c97a08d06b1b592fef330/test/speedtest1.c
SHA256 b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675
https://www.lua.org/ftp/lua-5.4.8.tar.gz
SHA256 4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae
```

Lua scripts: buster-performance commit `818cfbbc0be238da287c16d8e2a91fd7275cf228`, directory
`docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua`, scripts calls/tables/strings/arithmetic/closures.
The historical directory name does not indicate execution on that machine in this experiment.
Their individual hashes and all Lua compilation source/header hashes are in `inputs/SHA256SUMS`, relative to
the original input-root layout.

## Instrumentation and helper provenance

The tag source is buster-performance commit `ddb5213da1fce7ac9325afbf6364a797bbc63b5b`,
`docs/measurements/tier1-dominator-places-2553-2026-11-12/scripts/kinds-2553.patch`, SHA256
`6ed946aae925ad3cd2982f87c367075c44468faf1c64facfbf374602f1aae9d3`.

```text
kinds-2610.patch          19026879280bb58421079448f8d82036672a70de85860ee3880d09c0aa89ae68
kinds-2610-variants.patch 2890d906c126e1cb26f814aca8a0b69c048af48b61d7c0f58e1fadea03d1335f
kinds-2610-guarded.patch  153e134f7a9e39948c4f009141c4974691cc86b2b1a16acc4c8604dff9e8e0a6
```

The existing `check_test_tier1_frame_source` declaration is copied from
`src/buster/compiler/c_check_tier1_driver_test.c` into `inputs/frame-source.inc`; a small C writer emits
`inputs/frame.c` without source transformations. The compiler's `--verify` validates allocation order and
the emitted-code certificate before that fixture runs. Its six function counts and native outputs are retained.

Valgrind 3.24.0 was installed in user-local scratch by extracting the official Debian package:
`https://deb.debian.org/debian/pool/main/v/valgrind/valgrind_3.24.0-3_amd64.deb`.
The package hash is in `local/baseline/valgrind.sha256`; no system package installation was required.
The program host is Linux 6.18.57, Intel Xeon Platinum 8370C, Debian glibc 2.41-12+deb13u5.
Hosted compiler build images report Ubuntu 26.04 image `20261116.202.1`, glibc 2.43; those build-host receipts
are separate from the program execution host.

Raw Callgrind and complete disassembly accounting are maintained separately. The final merged packet should
retain the exact executable-load-range join, foreign-object audit, stable-path controls and their helper hashes.
This initial packet does not substitute local wall times for runtime or compiler timing evidence.
