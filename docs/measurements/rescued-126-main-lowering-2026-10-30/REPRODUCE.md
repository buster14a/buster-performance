<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Reproduction route for the frozen 20e01ceb campaign

Run these tools from a dedicated immutable Buster source checkout. Do not run
them from the performance repository. `record` is this directory's absolute
path; `evidence` is a new absolute output directory. Verify the final source
archive/inventory and toolchain identities before using the staged binary.
The scripts' host/toolchain defaults describe the existing approved route;
`BUSTER_TOOLCHAIN_ROOT` may select a separately verified matching installation.

```bash
record=/absolute/buster-performance/docs/measurements/rescued-126-main-lowering-2026-10-30
evidence=/absolute/new-final-evidence
lock=/home/david/buster-fast-bench/exclusive.sh
source "$record/harnesses/hardware-env.sh"
```

Every build, compiler probe, correctness run and benchmark process on benchpress
takes the shared lock separately. The actual hardware build used `taskset -c 0-3`
under that lock; `cores` is not installed on benchpress. Never hold the lock around the whole campaign or source
mutation. Pin timed processes to CPU 2. Read the current host README and owner
file; leave CPU/OS settings unchanged.

Before capture, create `evidence`, materialize the exact final commit and place
its relative tracked-file `source.sha256` inventory there. Retain its archive,
archive hash, commit receipt and original license/notice bundle. Build under one
lock and retain the full build log. The immutable source SHA is
`20e01cebc77a0142260f3e0a6b3e9c66228ef3bf`; completed receipts are under `hardware/`.

```bash
mkdir -p "$evidence"
"$lock" taskset -c 0-3 ./build.sh > "$evidence/build.log" 2>&1

# From the frozen source root, one lock acquisition for capture.
"$lock" bash "$record/harnesses/capture-inputs.sh" "$evidence" > "$evidence/capture.log" 2>&1
```

Capture reads expanded NUL-delimited build argv and source paths, records host
and toolchain, and creates `main.d`, sorted input/hash inventories, compiler hash
and `main.preprocessed.c.gz`. The snapshot is Clang `-E -CC` output of the actual
main.c/build flags, retaining comments; it incorporates Buster, Clang and system
header material. It is an auditable external preprocessor snapshot, not a claim
that Buster consumed an identical byte stream. Preserve any Buster/Clang token
comparison evidence separately. The dependency simplification assumes paths
contain no spaces; retain original `main.d` as authoritative.
The snapshot remains **PRIVATE on the measurement host**. Record both its
uncompressed digest (`main.preprocessed.sha256`) and compressed-file SHA-256,
plus its exact retained host path and size. Publish those receipts/inventories
and copied applicable notices; do not upload `main.preprocessed.c.gz`.

Actual object and symbol acceptance runs each acquire the lock independently:

```bash
for mode in check selected all symbols; do
    status=0
    "$lock" bash "$record/harnesses/main-gate.sh" "$mode" \
        "$evidence/compile-flags.argv0" "$evidence" > "$evidence/main-$mode.log" 2>&1 || status=$?
    printf '%s\t%s\n' "$mode" "$status" >> "$evidence/main-status.tsv"
    test "$status" = 0 || break
done
```

All four must succeed on the same source/binary/input. Record hashes and ELF
section/symbol inventories of `main-selected.o` and `main-all.o`, and retain the
nonzero compared-file count in `main-symbols.tsv`.
The selected/all object modes include strict `--verify` of generated records
and unwind shapes. Corpus, fixture, call-graph and
CI gates use the final source's existing exact inventory/commands. Do not turn
an unchanged failure or zero successful symbol comparisons into a pass. The
guide's old SQLite refusal and adjacent 348-file musl comment are historical;
the current minimum musl gate is 354.

Only after final qualification, run the paired comparison from outside an
already-held lock. Each internal pass belongs to one benchmark process; release
the host before the next process. `ROUNDS` and `PASSES` may be set explicitly.

```bash
bash "$record/harnesses/lowering-runs.sh" "$PWD" "$PWD/build/compiler" \
    "$evidence/compile-flags.argv0" "$evidence/source.sha256" "$evidence/postcheck"

# Build the offline reader separately; use the host lock if compiling on benchpress.
"$lock" clang -std=c17 -O2 -Wall -Wextra -Werror "$record/harnesses/summarize.c" -o "$evidence/summarize"
"$evidence/summarize" "$evidence"/postcheck/process-*.log > "$evidence/postcheck/summary.tsv"
```

The root session separately checked the reader with seven synthetic valid rounds
and count-mismatch/failed-measurement controls. Those checks test parsing and
acceptance logic. Their fixture logs and sample numeric results are deliberately
excluded from this evidence record. The completed 11-process/21-pass campaign
and exact summary are retained under `hardware/postcheck/`. A process's saving
is its all-mode 21-pass median minus its referenced-mode 21-pass median; the
individual inner paired deltas are unavailable. Outer/per-file reservations and
warm-up are outside timing; internal emitter allocations/releases remain timed.
Unwind generation, optional emitter verification and file writing are excluded.

Finally verify tracked source, binary and external input hashes again. Preserve
exact source and measured-binary archives, all raw logs/statuses, toolchain/header
inventories, private-snapshot hashes/location, licenses and any immutable release
asset receipts. Exclude the private snapshot from copied/public archives.
Record hashes relative to the evidence directory for relocated copies, retaining
original host-path manifests as provenance. Fill the report from these artifacts,
then publish only a coherent final-source packet. Do not mix `ba2d8a33`'s discarded
qualification attempt or synthetic controls into the final sample set.
