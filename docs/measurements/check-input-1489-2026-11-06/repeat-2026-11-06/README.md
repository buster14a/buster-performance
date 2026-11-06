# Separately locked repeat of the historical #1489 comparison

This repeat fixes the shared-lock granularity of the earlier exploratory record:
each compiler or `perf stat` invocation acquired its own Benchpress lock grant.
It uses the **same historical executables**, not newly built current-head or
repaired-main executables. It is not current-base performance qualification.

The measured Buster revisions are `aca9e53aa981bb3f61d21cdd5a408ce5167a06f8`
(`pre1049`), `6b3a7ebd150ab6b064eee79d9de42922f4f560c0` (`rbase`) and
`f9d76cdccffe720bc75343bb1a229e876f4110ab` (`rhead`). At the time of this
record, [#1530](https://github.com/buster14a/buster/pull/1530) head
`e94fd0d2bcada50d237ac14206a32cf2b68dc1ff` differed from `f9d76cdc` only in
`docs/compile-time.md`; the executable actually measured was still the
`f9d76cdc` build. The comparison does not establish the result for a later
rebased or repaired main, an unbuilt current-head executable, or compiler
correctness. Its three reused compiler hashes match the previous record before
and after the repeat.

## Method and results

The Ryzen 7 9700X ran the frozen SQLite source on CPU 2, with `-c --lanes 1`
and `--time-stages`: 11 rounds of the three builds in deterministic rotated
order. Fifteen additional single-invocation `perf stat` runs used five rotated
rounds of the same builds. Six further single-invocation runs measured the
same preprocessed compiler `main.c` with `-fsyntax-only`: three alternating
rounds of `rbase` and `rhead`. In total, 33 + 15 + 6 = **54 individual
shared-lock grants**, each with a zero exit status and a retained holder
receipt. The `perf` events all report 100% running. These are not randomized
placement experiments and their displayed differences are differences of
separately calculated medians or means, not paired-effect estimates.

The following are **internal stage-clock medians**, in milliseconds. The
`total` row is the internal stage total, not fork-to-reap wall time; ranges
are the minimum and maximum of 11 samples per build.

| SQLite stage | `pre1049` | `rbase` | `rhead` |
| --- | ---: | ---: | ---: |
| check-input | 45.025 (44.804–46.255) | 59.600 (59.165–60.115) | 50.546 (50.338–50.980) |
| check-program | 10.325 (10.268–10.553) | 26.571 (26.385–26.644) | 26.786 (26.635–27.162) |
| total | 106.097 (105.775–109.145) | 139.350 (138.889–139.781) | 130.293 (129.479–131.340) |

The separate **five-run perf means** are:

| Counter | `pre1049` | `rbase` | `rhead` |
| --- | ---: | ---: | ---: |
| cycles:u | 502.0 M | 675.2 M | 625.5 M |
| instructions:u | 1,155.7 M | 1,636.8 M | 1,393.1 M |
| task-clock | 106.274 ms | 138.948 ms | 130.006 ms |

For the preprocessed `main.c` workload, the three-run `check-input` medians
were 1,186.204 ms (`rbase`) and 1,111.341 ms (`rhead`); internal total medians
were 1,952.490 and 1,883.847 ms. All rows, means, medians and ranges are in
[`summary.tsv`](summary.tsv). These two inputs and the one recorded machine do
not establish a corpus-wide or layout-independent performance claim.

All 48 SQLite object SHA-256s (33 stage and 15 perf runs) match
`61eb96dd33188557f23a27c24dcf347a8b704d8f8ec15c3656c4e447de3856f2`.
The objects and direct byte-comparison receipts are not retained. After stage
and counter lines are removed, every repeated diagnostic stream within each
build has one hash; `rbase` and `rhead` match each other for each workload.
`pre1049`'s SQLite diagnostics differ, as in the original record.

## Provenance and limits

[`raw-evidence.tar.gz`](raw-evidence.tar.gz) retains all 54 status rows, holder
receipts, stdout/stderr files, per-run perf CSVs, object hashes, pre/post binary
and selected-input hashes, the host snapshot, the runner script and the exact
hashed `workloads.sh` it sourced. The raw objects and external corpus are not
included. The script uses absolute paths from the original host and requires an
isolated output directory and corresponding pinned inputs to reproduce.

Binary hashes were checked against the original record before and after, and
five listed source/predefine/workload-script hashes matched before and after.
The record does **not** independently hash every included header before and
after. CPU 2's performance governor/EPP and host settings were observed in a
single pre-run snapshot, not verified during each grant. One lock-wait message
contained another session's holder details; the published copy replaces only
that message with a generic wait marker. Unmodified originals remain in the
local and Benchpress task directories.

To verify and regenerate the summary after extracting the archive:

```sh
sha256sum -c SHA256SUMS
mkdir extracted
tar -xzf raw-evidence.tar.gz -C extracted
python3 summarize.py extracted > regenerated.tsv
cmp summary.tsv regenerated.tsv
```

The validator checks the rotated order, 54 individual statuses and owner files,
binary/input identity receipts, all 48 object hashes, event coverage and raw
stage/counter rows before writing the summary. It is a check of retained
receipts, not a rerun or independent proof of the binaries' source provenance.

---
Collection agent session: 01a1b0e0-a314-7252-9c29-d958f2e64d73 (Codex session ID; agent thread 01a1b0e0-d979-7e63-94ff-ff91f3213a51; no private session URL is exposed)
Model: OpenAI / GPT-6

---
Record and independent verification agent session: 01a1b0e0-a314-7252-9c29-d958f2e64d73 (Codex session ID; agent thread 01a1b0e1-da73-7731-9bcf-4312e3561034; no private session URL is exposed)
Model: OpenAI / GPT-6
