# Issue #2658: local runtime validation

This is **historical experiment evidence**, not a performance claim for the final
PR head. Every candidate binary here contains the arena-policy experiment from
`4d1f2024095f233cba19e8f8135dd99b17b9e264`. That experiment, its 11 additional
run-mode checks and its documentation were deferred and removed in final head
`e8746a798795c8e5e6702442a56f6d6ccc7a5b5d` (tree
`191d46ae8381b89d8d9107ed5d0752d75fd6c06d`). The deferred patch and decision are
preserved in [../after-45788677912/deferred-arena-policy/](../after-45788677912/deferred-arena-policy/).

The historical candidate MSan run-mode check passed **79 checks with zero
failures**, including the arena-limit restoration controls. Its plain
`test-files` check passed, including all 48 deliberately memory-constrained
runs. The baseline/candidate/baseline driver sequence passed all **15,316 checks
on each run**, with identical execution counts and no sanitizer reports. Timing
drift across that sequence prevents attributing a stable speedup to the arena
experiment.

These runs use a cloud VM described in [host.txt](host.txt), with an Intel Xeon
Platinum 8370C, kernel 6.18.57, nine visible CPUs and 10,206,468 kB of memory. The
timed driver sequence is restricted to CPUs 0–3. It is one local diagnostic A/B/A sequence, not
a Zen 5 measurement, a full CI wall-time comparison, or a LeakSanitizer result.
No 9700X or benchpress machine is involved.

## Product and source provenance

All three products retain the ordinary vector `-O3` build settings. The MSan
products retain MemorySanitizer, origin tracking level 2, fatal sanitizer errors,
frame pointers and the ordinary PIE settings; the recorded flags are in
[candidate/msan-flags.txt](candidate/msan-flags.txt). Before replay, the baseline
and candidate MSan products' `identity/compile-flags`, `identity/configuration`
and `identity/sanitizer-flags` were compared byte for byte and matched.

| Product | GitHub Actions run | Artifact ID | Built revision |
| --- | --- | --- | --- |
| Baseline vector/MSan/O3 | [45779319802](https://github.com/buster14a/buster/actions/runs/45779319802) | `15098445611` | `8e4d32879e17b7d9548cad54257a2f8461328366` |
| Candidate vector/MSan/O3 | [45788677912](https://github.com/buster14a/buster/actions/runs/45788677912) | `15102531999` | `1145a859668a030945878fc7361c2e767fc97166` |
| Candidate vector/plain/O3 | [45788632775](https://github.com/buster14a/buster/actions/runs/45788632775) | `15101373817` | `1d15129d9035b343ae04a82e21ab5d4e202c9b2d` |

The historical candidate implementation commit is
`4d1f2024095f233cba19e8f8135dd99b17b9e264`, tree
`442ca4bfa8125782b97d5017aa17323f296f1d89`. The candidate plain PR-merge product
has that same tree. The candidate MSan product was built from a separate
validation branch: [validation-source.json](validation-source.json) records that
it is exactly one commit ahead of the implementation commit, changing only the
addition of `.github/workflows/2658-hosted-validation.yml` (64 lines). The source,
tests, build settings and existing workflows are otherwise identical. The
temporary caller is preserved as [hosted-validation.yml](hosted-validation.yml);
it calls the existing hosted-tools and hosted-correctness workflows, with no
hardware job. The candidate product identities are preserved in
[candidate/identity-msan.txt](candidate/identity-msan.txt) and
[candidate/identity-plain.txt](candidate/identity-plain.txt).

| Executable | SHA-256 |
| --- | --- |
| Baseline MSan compiler | `4d2c7b420a67d62aa28f2a16e32d6efe165eceba8d1167fce22fc2a7cbc90851` |
| Candidate MSan compiler | `6e554b6abbf3980893ebfc086340182a111761f9880d4b9ab7bd7e1a7b23b65c` |
| Candidate plain compiler | `6930f0a738f9ab8de7c7b6e42a6e04cfb0b12f56ebcd1422aac4c64ed4bcbfe6` |
| Shared local Clang server | `f87c223ae4803512030278d5a57402273d8b05935e793f7847e0602d02ee89a1` |

The checksum source files are [baseline-binaries.sha256](baseline-binaries.sha256),
[candidate/compiler-msan.sha256](candidate/compiler-msan.sha256) and
[candidate/compiler-plain.sha256](candidate/compiler-plain.sha256). The matched
sequence's `.meta` files also record the compiler, server, sanitizer-audit script and
`tests/driver/run_modes.c` hashes.

## Results

| Check | Result | Timing use |
| --- | --- | --- |
| Baseline MSan `--run-modes-only` | 68 checks, zero failures, exit 0 | Correctness smoke only; 10.036 s wall, 1.155 s user, 1.846 s system |
| Candidate MSan `--run-modes-only` | 79 checks, zero failures, exit 0; fatal MSan reporting enabled and report audit clean | Correctness smoke only; 3.209 s wall, 0.622 s user, 1.404 s system |
| Candidate plain built-in `test-files` | Passed, exit 0; all 48 memory-constrained runs retained, with 38 expected allocation failures | Correctness smoke only; 22.885 s wall, 6.966 s user, 4.822 s system |
| Baseline MSan driver `13/16`, valid setup | 15,316 checks, zero failures or differences; exit 0 and report audit clean | 386.245 s wall, 171.795 s user, 119.687 s system |
| Candidate MSan driver `13/16`, same setup | 15,316 checks, zero failures or differences; exit 0 and report audit clean | 216.814 s wall, 123.169 s user, 90.455 s system |
| Reverse-order baseline MSan driver `13/16` repeat | 15,316 checks, zero failures or differences; exit 0 and report audit clean | 187.586 s wall, 101.895 s user, 83.680 s system |

The run-mode smoke checks are not a matched performance pair. The baseline
predated the fixed replay settings and had no explicit cache or sanitizer-option
override. The candidate smoke used `--run-modes-only --in-process --differential`,
CPUs 0–3, an explicit Clang resource directory and fatal MSan reporting, without a
Clang-server or cache override. Both completed successfully; their timing
difference is not evidence of a speedup. The intentional timeout message in
those logs exercises server fallback and is followed by a passing summary.

The historical candidate MSan binary exercises the guarded `!BUSTER_ARENA_REGIONS` code.
Its extra run-mode controls cover fixed and unfixed stale arena-limit snapshots,
current resource limits, success and rejection against a fresh child, restoration
of the original snapshot, and response-file fallback. The plain `test-files`
check separately covers the retained warm reference comparison, unused-record
accounting, opaque identifier remapping, diagnostics and the memory-failure runs.

The raw smoke outputs are in `baseline/run-modes-msan.{log,time}`,
`candidate/run-modes-msan.{log,time}` and
`candidate/files-built-in.{log,time}`. The 38 failures mentioned by `test-files`
are expected outcomes within its fault-injection test, not 38 failed assertions.
The candidate focused MSan check's explicit audit is preserved in
[candidate/run-modes-msan.audit.log](candidate/run-modes-msan.audit.log).

All three valid driver runs exercised 305 of 5,438 dealt units, with 7,973
in-process Buster commands, 1,792 Clang-server requests and 16 fallback children.
Their [baseline status](baseline/driver13-msan-valid.status) and
[candidate status](candidate/driver13-msan-valid.status), and
[baseline-repeat status](baseline/driver13-msan-repeat.status) record both exits
as zero. The [baseline audit](baseline/driver13-msan-valid.audit.log),
[candidate audit](candidate/driver13-msan-valid.audit.log), and
[baseline-repeat audit](baseline/driver13-msan-repeat.audit.log) found no
sanitizer reports.

| Ordered driver replay | Wall | User + system CPU | Clang-server wall | Other oracle-child wall |
| --- | ---: | ---: | ---: | ---: |
| A: baseline | 386.245 s | 291.482 s | 27.943 s | 20.811 s |
| B: historical candidate | 216.814 s | 213.624 s | 17.758 s | 8.987 s |
| A: baseline repeat | 187.586 s | 185.575 s | 14.970 s | 9.958 s |

The apparent 44% elapsed-time reduction against the first baseline reverses when
the unchanged baseline is repeated: the candidate is 15.6% slower in elapsed
time and uses 15.1% more combined user/system CPU than that repeat. The unchanged
Clang server's time also moves substantially, so these observations establish
neither a stable gain nor an isolated source regression. Small tooling builds
also overlapped the candidate run. The complete sequence is retained; selecting
only the first pair would overstate the evidence. No further repetitions or
syscall-tracing measurements were performed.

## Reproducing the historical MSan driver sequence

Use Linux with the vector product's required CPU features and CPUs 0–3 available.
The helper requires Bash, Git, GNU coreutils and util-linux `taskset`, plus the
verified official Clang/LLVM **23.1.4** toolchain. Extract the two MSan products
above without rebuilding or changing their optimizer or sanitizer settings.
Use the recorded historical implementation checkout for all runs so that the
fixtures and audit script are identical. Run the sequence without competing builds or
other test processes.

Build the Clang server once, outside the timed sequence, using the repository's
ordinary builder and the same Clang release used for both replays:

```bash
toolchain=/absolute/path/to/llvm-23.1.4
checkout=/absolute/path/to/buster
server=/absolute/path/to/local-clang-server
evidence=/absolute/path/to/ci-evidence/runtime
baseline_product=/absolute/path/to/extracted-baseline/product
candidate_product=/absolute/path/to/extracted-candidate/product

export PATH="$toolchain/bin:$PATH"
unset MAKEFLAGS MFLAGS SOURCE_DATE_EPOCH
bash "$checkout/tools/clang-server/build.sh" "$server" \
    > "$evidence/clang-server-build.log" 2>&1
```

The recorded local build used the staged official 23.1.4 libraries and
`LIBRARY_PATH` pointing to the host's development-library links for libxml2.
That adjustment was only for linking the local server. The builder checks its
version and compares a warning-producing request with an ordinary spawned
Clang request; [clang-server-build.log](clang-server-build.log) records a passing
comparison. Use this same server executable for both sides. The server resolves
the request's `clang` through `PATH`, so leave the selected toolchain first.

Check the three MSan metadata files before running:

```bash
for part in compile-flags configuration sanitizer-flags; do
    cmp "$baseline_product/identity/$part" "$candidate_product/identity/$part"
done
```

Then run [run-msan.sh](run-msan.sh) in the recorded A/B/A order:

```bash
bash "$evidence/run-msan.sh" "$checkout" "$baseline_product/bin/compiler" \
    "$server" "$evidence/baseline" driver13-msan-valid driver13
bash "$evidence/run-msan.sh" "$checkout" "$candidate_product/bin/compiler" \
    "$server" "$evidence/candidate" driver13-msan-valid driver13
bash "$evidence/run-msan.sh" "$checkout" "$baseline_product/bin/compiler" \
    "$server" "$evidence/baseline" driver13-msan-repeat driver13
```

Choose a new label for each repetition. The helper refuses to overwrite existing
output, and recorded invocations use unique labels with `MAKEFLAGS` and `MFLAGS`
unset. To repeat the focused run-mode correctness check with the helper's fixed
environment, use a fresh label and replace the last argument with `run-modes`.
That is a new check, not the same invocation as the earlier smoke checks.

For each run the helper verifies the Clang and server versions, derives
`BUSTER_CLANG_RESOURCE_DIR` from `clang -print-resource-dir`, and requires
`include/stddef.h` to exist. It clears `CPATH` and `C_INCLUDE_PATH`, allocates a
fresh `XDG_CACHE_HOME`, and sets `BUSTER_ORACLE_CACHE=check`. It retains fatal MSan
options (`halt_on_error=1`, `exitcode=86`, symbolization through the staged
`llvm-symbolizer`, and a unique per-run report path). The timed command is:

```text
taskset -c 0-3 COMPILER test-checker-driver --executable COMPILER \
  --part 13/16 --in-process --clang-server SERVER
```

Only that command is timed. Bash `TIMEFORMAT` records wall, user and system
seconds; resource checks, server construction and sanitizer-report auditing are
outside the interval. A fresh cache prevents one product from inheriting the
other product's oracle results. The helper removes its temporary cache on exit.

Each label produces `.log`, `.time`, `.meta`, `.audit.log` and `.status` files,
plus a unique `LABEL-reports/` directory. `.meta` records the exact shell-quoted
command, checkout revision, binary and fixture hashes, Clang resource directory,
CPU affinity and sanitizer options. The existing `tools/ci/sanitizers.sh audit`
checks all reports, including reports from child processes. `.status` says
`eligible yes` only if the test command and report audit both exit zero. Retain
unsuccessful runs as exclusions, without substituting their elapsed times into
the sequence.

## Excluded setup attempts

| Retained files | Reason for exclusion |
| --- | --- |
| `baseline/driver13-msan-unavailable-server.{log,time}` | The hosted server could not load `libxml2.so.16` on this VM. The attempt was stopped and did not validate the intended server path. |
| `baseline/driver13-msan-missing-resources.{log,time}` | With the local server working, Buster could not locate Clang's `stddef.h` because `BUSTER_CLANG_RESOURCE_DIR` had not been set. The run exited 1 after 220.426 s wall (72.803 s user, 75.402 s system). |

The final helper addresses both prerequisites before starting the timed command:
the supplied server must execute and report 23.1.4, and the selected Clang's
resource headers must exist. Buster's resource-directory lookup does not infer
that directory from `PATH`; the explicit export is required on this host.

## Interpretation limits

The successful A/B/A sequence establishes that these exact historical binaries
complete this partition with the shared oracle setup and no MSan reports. It
does not establish a stable performance gain or measure the full CI critical
path or all runner minutes. Keep its wall, user and system times separate from
the hosted workflow cost evidence. The focused controls passed, but their
resource-policy experiment was deferred: correctness passing does not establish
the benefit of broader commit increments. These binaries do not validate the
subsequent final PR head. This directory makes no claim about LeakSanitizer,
other detector configurations, or Zen 5 hardware.
