# Method and reproduction

Compiler source: `buster14a/buster` commit `586c2ae2e40f117f27330307944a6d64566e0882`. The local executable is in the large-evidence release; its SHA-256 is `a24dbb99d0cc26bc609a0ef632b51d240d255845116a329538e25157d86eb116`. The build was `./build.sh` with default flags and debug information, through a four-core `cores` grant. The compiled-in host path was native Zen 4. `local/environment.json` has the toolchain, CPU, kernel and input hashes.

Obtain the frozen inputs through the source revision's `tools/ci/fetch-corpus.sh`; it verifies the archived corpus, manifests and each input. A clean checkout can be built with `./build.sh`, but a rebuilt binary has a new identity and must not silently be substituted into the saved perf samples. Set `compiler` and `corpus` to their absolute paths and use a fresh output directory. The commands that produced the local data were:

```sh
python3 scripts/campaign.py --compiler "$compiler" --corpus "$corpus" \
  --out "$out" --local-cores --repetitions 2 --stage-repetitions 7 --profile-runs 30
python3 scripts/recover-counters.py --compiler "$compiler" --corpus "$corpus" --out "$out"
python3 scripts/export.py "$out"
scripts/run-scaling.sh "$compiler" "$corpus" "$out"
scripts/local-profiles.sh "$compiler" "$corpus" "$out"
scripts/scalar-control.sh "$compiler" "$corpus" "$out"
scripts/ir-passes.sh "$compiler" "$out"
scripts/validate-sqlite.sh "$compiler" "$corpus" "$out"
python3 scripts/rss-parent-repro.py --compiler "$compiler" --corpus "$corpus" --out "$out"
python3 scripts/object-path-probe.py --compiler "$compiler" --corpus "$corpus" --out "$out"
clang -O3 -march=native -pthread -Wall -Wextra -Werror scripts/memory-floor.c -o /tmp/buster-memory-floor
scripts/memory-floor.sh /tmp/buster-memory-floor "$out"
```

Run each tool from the measurement directory. The `cores` allocator grants and releases cores for each individual measurement or independent multi-process batch; its two-core interactive reservation remains unchanged. `run-scaling.sh` creates outputs in `/dev/shm` and deletes them after recording their hashes. Its 1, 2, 4, and 6 worker cases run in rotated order, with four fresh processes per worker. A separate six-core cohort collects system-wide UMC and energy events, followed by a separate idle control. The latter are not per-process counters.

`campaign.py` inventories all named `cpu` PMU entries exposed by the host's perf JSON, probes each, and records four named events plus cycles and instructions in each execution. It retains raw output, event descriptions, runtime, status and scheduling percentage. `recover-counters.py` repeats any group below 99% duty one event at a time with the same two anchors. `export.py` admits a normalized event row only when both anchors and that event have at least 99% duty. Derived metrics are attempted separately and their failures are retained; they still must be checked for unavailable, nonfinite or semantically invalid mappings. Names and available PMUs can differ by host and perf version. Raw unit-mask combinations not exposed by the tool, PMUs requiring unavailable privileges, and unvalidated off-core aliases are not silently invented.

The original sampling captures cover 30 fresh object compilations each. `perf report` text and loss/order diagnostics accompany them; raw `.data.zst` and the measured local binary are in the release archive rather than Git. `perf` sampling can skid, IBS operation sampling is not time sampling, and reported memory-source samples exclude unclassified operations from that subpopulation. The streaming floor reports logical array bytes. The `perf stat -a` UMC and package-energy captures are system-wide and include normal background activity.

`scripts/sqlite-smoke.c` is adapted from the earlier `microarchitecture-9700x-2026-10-27/method/sqlite-smoke.c`; its RTree statements are omitted for this campaign's default SQLite configuration. `scripts/memory-floor.c` is adapted from that record's `method/memory-floor.c` to run one requested core count and store mode per process. They retain the performance repository's original contribution terms. The SQLite and header corpus is not redistributed in this record; its upstream notices remain in the verified corpus bundle. The release supplies Buster's source license and notices with the executable; dynamically linked system libraries are not redistributed.

The 9700X CI run and its separate workflow-only diagnostic are identified in the report. Runner job hooks hold the shared host lock for each job; do not nest `exclusive.sh` inside such a job. The CI binary is identified by its recorded hash, but was not retained. Its raw perf samples and symbolized text are saved; exact resymbolization requires that executable or a byte-identical rebuild.

The manual 9700X follow-up used the same source archive and corpus, but a different compiler executable: its `environment.txt` records Clang 23.1.1, build settings and SHA-256. That measured executable is in the 9700X release archive. The native source build used `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` under `exclusive.sh`. For a separate follow-up output directory, these commands reproduce the manual collection structure:

```sh
python3 scripts/zen5-grouped-counters.py --compiler "$compiler" --corpus "$corpus" \
  --event-probes zen5/current/event-probes.json --out "$out" --repetitions 2
scripts/zen5-scaling.sh "$compiler" "$corpus" "$out" scripts/scaling.py
scripts/zen5-profiles.sh "$compiler" "$corpus" "$out"
scripts/zen5-validate.sh "$compiler" "$corpus" "$out" scripts/sqlite-smoke.c
python3 scripts/zen5-uncore-metrics.py --compiler "$compiler" --corpus "$corpus" \
  --scaling scripts/scaling.py --names scripts/zen5-uncore-metric-names.json --out "$out"
python3 scripts/export-system-metrics.py "$out"
```

The original `zen5-isolated-counters.py` sweep was interrupted while waiting for the shared lock and continued with `zen5-grouped-counters.py`: groups of three named events plus cycles and instructions. The continuation resumes only records with a successful status and at least 99% duty for every recorded counter, records the entire grouped output separately, and retries any under-scheduled group one event at a time. It can also run from a fresh output directory, as shown above. The scripts do not claim that named aliases are necessarily distinct or correctly documented. Every build, workload, sample or counter run outside CI acquired `~/buster-fast-bench/exclusive.sh` separately; no lock covers a series of independent measurements. The scripts set the owner, title and link and pin single-core work to CPU 2. Published evidence omits lock-owner coordination messages, including two residual lines removed from the isolated sweep's stderr after collection; the perf counter fields are unchanged. See the source revision's `AGENTS.md` and `docs/profiling.md` for placement and after-scalar controls. Historical 9700X full-system data belong to their recorded source, flags and corpus, not this source revision.
