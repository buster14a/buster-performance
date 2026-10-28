# Role and execution receipt

Added after qualification, reconstructed from the session's executed commands;
the original build/test logs capture output rather than echoing their argv.
Paths and effective arguments below are preserved; shell quoting and descriptive
lock titles are normalized. This is not a claim that an echoed raw command log
exists. The missing exploratory wrapper compilation argv remains a limitation.

## Exact source and binary roles

| Role | Buster source revision | Target directory below `/home/david/buster-fast-bench/` | Compiler SHA-256 |
| --- | --- | --- | --- |
| Baseline | `6c0428b145fa5e9043d663880e1a89a8c68b82e9` | `takeover-20261028-base660` | `bd142a41ad9658817208c2d966d1bb6002e9b98537b4e0d1ff2c3ea0577946e3` |
| Final | `0097ff1e116aa47a458172eceddc68b194db269f` | `takeover-20261028-pr627-v3` | `ba304f4e5a56daa8567ecf8b738f2d4d77a62b2de06b9006b06f56ebc93416e3` |
| Compact-only negative control | `92857a326f235c4e17bee5a4649d6bad91b1dadc` | `takeover-20261028-pr627-v2` | `17c5f6261aee8bef1a26fecb789c87453c9eccc5abc94f23ae8cd10cad5cb31e` |

These map the three otherwise repeated relative `build/compiler` entries in
`host-identities.txt`. `roles-live.sha256` is a subsequent read-only hash check
using absolute paths; all five mapped compiler/controller/wrapper hashes match
the original identity record. Full `source-{base,head,compact}.sha256` target
manifests match SHA-256 manifests produced from the respective Git source trees.
These directories are our own immutable qualification copies, not runner trees.

## Commands

Every target build, test and measured controller runs under
`/home/david/buster-fast-bench/exclusive.sh`, with
`EXCLUSIVE_OWNER=codex-takeover-pr627`, a descriptive `EXCLUSIVE_TITLE`, and
`EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/627`.
Builds execute in their role directories:

```sh
BUSTER_DEBUG_INFO=0 ./build.sh
```

Final correctness executes in `takeover-20261028-pr627-v3`:

```sh
./build/compiler test-checker --seed 627
./build.sh check-call-graph
```

The result logs are `logs/final/build-review.log`, `checker-review.log` and
`call-graph-review.log`. Build debug information is disabled for the measured
compiler; the call-graph tool emits its own analysis IR independently.

The original-controller build runs in final `record/`:

```sh
clang -O2 compare.c -o compare
```

Each A/B round uses a separate lock acquisition and CPU 2 pin, in that same
`record/` directory, with ROUND 0, 1, then 2:

```sh
taskset -c 2 ./compare \
  /home/david/buster-fast-bench/takeover-20261028-base660/build/compiler \
  /home/david/buster-fast-bench/takeover-20261028-pr627-v3/build/compiler \
  /home/david/buster-fast-bench/zero-aggregate-596/record/inputs \
  /home/david/buster-fast-bench/takeover-20261028-pr627-v3/record/objects \
  ROUND \
  /home/david/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c
```

A/A executes the same command for ROUND 0, 1, 2 within one locked/pinned shell,
passing the baseline compiler in both positions and `record/aa-objects` as its
separate output directory. No A/B objects are replaced. The native verification
runs `bash verify.sh` in final `record/` under a separate lock after A/B ends.

The common-output controller executes in final role directory, under the lock
and CPU 2 pin. IN denotes
`/home/david/buster-fast-bench/zero-aggregate-596/record/inputs`; BASE and FINAL
are the absolute compiler paths mapped above. Those three abbreviations expand
to the same effective argv as the recorded invocation:

```sh
./build/compiler time-runs --runs 7 --warmups 0 --copies 2 \
  --build base BASE --build review FINAL --build base-again BASE \
  --list --lanes 1 -c IN/dense-65536.c \
  --list --lanes 1 -c IN/dense-tail-zero-65536.c \
  --list --lanes 1 -c IN/zero-268435456.c \
  --list --lanes 1 -c IN/overwrite-268435456.c \
  --list --lanes 1 -c IN/const-1048576.c \
  --list --lanes 1 -c IN/reloc-1048576.c \
  --list --lanes 1 -c IN/negative-16.c \
  --list --lanes 1 -c IN/tls-268435456.c
```

`time-runs` makes the two fresh executable copies itself. No alternate object
output argument is passed, so all roles use the same default output pathname
for each input. The compact-only screen uses the same controller structure
with the compact-only compiler as its review role. Its argument set is retained
in its raw per-list summaries.

Helper timing executions use compact `review-kernels` on CPU 2: `all` in three
fresh normal processes, then `scan conditioned` and `sort conditioned`. Its
binary hash is `3d31ccfe10b0c8b8aa1e89bd976af9de36589f37eaba0a626bcbd0a0adacac9f`.
The compiler argv for that historical wrapper build was not captured and is
not reconstructed as fact; README supplies a distinct reproduction recipe.
