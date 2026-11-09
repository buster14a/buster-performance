# Bit-fields' access units in the psABI classifier (buster#1833, PR buster#1887)

`benchmark-calling-convention` on benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts,
clang 23.1.1), base against head:

| Tree | Revision | `build/compiler` SHA-256 (full in `host.txt`) |
| --- | --- | --- |
| base: main | `cb608c1f616f8fe26234bcaaa869caccc571de63` | `aa60dda9…` |
| merge: units merged, conflicts resolved | `3a9a28c3a27068b29de9dca2f07e7aab80e0f129` | `b6c5da4c…` |
| head: plus the run-limit probe skip | `3235d260ee94a0d6c8dff1ba5ae5fac2e8d0470e` | `eb384b19…` |

Each tree is built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`
(`setup.sh`). Each run is `taskset -c 2 ./build/compiler benchmark-calling-convention`
(seed 1, 32,768 types and calls, 21 interleaved passes' medians per item).

There are five rounds, interleaved base, merge, head:
- **Round 1:** `bench.sh`, one lock hold per run.
- **Rounds 2–5:** `ab.sh`, all twelve runs in one hold of 12 s. The hold was
  `exclusive.sh ./ab.sh`.
- `bench.sh`'s own round 2 never ran. Its `base.2.txt` held only the lock's
  waiting message, and `ab.sh` overwrote it.

`summary.txt` is `summarize.sh results`: each item's median over the five
rounds, in ns, cycles and instructions per type (per argument for assignment).

## Results

head against base, by medians over the five rounds:

| Item | Cycles | Instructions per type |
| --- | --- | --- |
| classify-all, scalar twin, 16/32/64-byte | +0.4% to +0.6% | +6.4 (+0.5%) |
| classify-all, vector, 16/32/64-byte | +0.1% to +0.6% | −1.8 to −4.2 |
| batches 1/4/16, scalar twin | +0.3% | +6.4 |
| batches 1/4/16, vector | −1.0% to −1.9% | −1.5 to −2.4 |
| assignment, both paths | unchanged | unchanged |

The 2–4% slowdown that the backup branch `claude/bit-field-units-137` was
reported to have against its older base doesn't reproduce against main
`cb608c1f`.

The probe skip (merge → head) makes no difference to instructions: the
benchmark's spans mostly end at a member that isn't a bit-field, whose probe
is one step. In cycles it is within noise:
- scalar items: −0.1% to −0.6%;
- vector items: −0.7% to +0.7%.

## Limitations

- These are synthetic batches: the benchmark's random records. There is no
  whole-compile measurement, since the units only change classification.
- One seed only.
- Round 1's runs each waited for the lock separately; rounds 2–5 ran
  back to back in one hold.
