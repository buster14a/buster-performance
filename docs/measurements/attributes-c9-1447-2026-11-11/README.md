# Attributes still refused by name (buster#1447, package C9): base-vs-head `-fsyntax-only`

Evidence for buster PR [#2133](https://github.com/buster14a/buster/pull/2133)
(`objc_bridge` and `objc_bridge_related`), which changes the parser's
custom-attribute name scan (`parse_flag_custom_attributes`: 8 names instead of
6, looked at only when the unit interns one of them) and adds a names-only
lookup of tags' attributes (`check_input_tag_names`).

- **Machine:** the 9700X (`benchpress`), under `~/buster-fast-bench/exclusive.sh`,
  pinned with `taskset -c 2` (see `host.txt` for the kernel, CPU and clang).
- **Revisions:** base `d43c37e5192d7e5d62df822aa2ce5c1f3facb5ca` (main),
  head `331e9d111a166cfe5368c9dfcef470c01e3ad5d3` (the PR's commit). Both built
  with `BUSTER_DEBUG_INFO=0 ./build.sh` (Release, native, `build-*.log`).
- **Inputs:** `sqlite3.c` (sha256 in `host.txt`) and Buster's own
  `src/buster/compiler/main.c` at base, with
  `-march=znver5 -I src -fwrapv -funsigned-char -fno-strict-aliasing`.
- **Command:** `measure.sh` (`compiler time-runs --runs 21 --warmups 3`),
  output in `times-pr2133.txt`; `setup.sh` made the trees.

| Input | Metric | Base median | Head median | Head vs base |
|---|---|---|---|---|
| sqlite3.c | wall | 96.343 ms | 96.485 ms | +0.15% |
| sqlite3.c | user cycles | 449.978 M | 451.251 M | +0.28% |
| sqlite3.c | instructions | 987,255,862 | 987,454,289 | +0.020% |
| main.c | wall | 583.666 ms | 580.646 ms | −0.52% |
| main.c | user cycles | 2916.187 M | 2908.018 M | −0.28% |
| main.c | instructions | 8,770,388,134 | 8,770,268,855 | −0.001% |

The wall and cycle differences are within the runs' spread (the ranges in
`times-pr2133.txt` overlap). Instructions move by 0.02% on sqlite3.c and not at
all on main.c: no cost on the hot path.

## The stack through `cfi_salt` (buster#2133, #2149, #2215 and the `cfi_salt` PR)

`setup2.sh checker/1447-cfi-salt cfi-salt` rebuilt head at
`82b741f52dbc2aadbf46ac97d6fe24a9a22edbaf` (`cfi_salt` as part of a prototype's
type, with every earlier C9 PR under it; head binary sha256
`513c43a75cae96cd44e09de25953599e58a03ff2682570da1e5e78c8e0169aab`) and ran
`measure.sh cfi-salt` against the same base (`times-cfi-salt.txt`).

| Input | Metric | Base median | Head median | Head vs base |
|---|---|---|---|---|
| sqlite3.c | wall | 97.070 ms | 96.966 ms | −0.11% |
| sqlite3.c | user cycles | 451.548 M | 450.619 M | −0.21% |
| sqlite3.c | instructions | 987,255,862 | 987,705,019 | +0.045% |
| main.c | wall | 584.205 ms | 583.181 ms | −0.18% |
| main.c | user cycles | 2924.198 M | 2916.628 M | −0.26% |
| main.c | instructions | 8,770,385,972 | 8,771,407,180 | +0.012% |

Within the runs' spread: no measurable cost.
