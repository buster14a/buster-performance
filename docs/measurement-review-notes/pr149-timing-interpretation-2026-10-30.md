# Interpretation correction for PR149's retained SSA measurements

This additive note corrects the interpretation of the original
[SSA source record](../measurements/ssa-source-134-2026-10-30/README.md),
following [review 5715861412](https://github.com/buster14a/buster-performance/pull/149#pullrequestreview-5715861412).
The original 59-file packet, including its README, raw logs, scripts and identity
manifests, is retained without changing any path, mode or byte. This note adds no
measurement and does not replace a historical receipt.

## Timing interpretation

The retained six-process medians report `promote` changing from 141.10 to
141.32 ns per typed entry, **+0.16%**, and `promote-scalar` from 141.49 to
141.04, **−0.32%**, at the displayed precision. The original ranges, cycle and
instruction counts, phi counts and after-scalar observations remain recorded
values. In particular, the observed +0.16% is not removed or explained away.

The original README infers that the small lowering/verifier differences bound
placement effects in the changed promotion code by about ±0.5%. That inference
is not established. These are unchanged-control observations at one layout per
build; the packet contains no A/A or placement/copy experiment that supplies
such a bound. The small timing changes remain **unattributed**. Layout, ordinary
variation and costs of changed code are possible explanations, not demonstrated
unique causes. The assertion that the changes fall within a rounds'-spread or
noise bound must not replace the retained medians and ranges.

This is a correction to the interpretation, not a request for another campaign.
It does not assert a universal performance threshold or an end-to-end compile
speedup. `benchmark-ir-source` measures its stated IR pass, not the whole compile;
the after-scalar mode remains a separately conditioned observation.

## Identities and preservation

The original evidence commit is
`6a910d75bee362782f2edc77ab9066b48fd92b6c`, whose repository tree is
`01e1d1bc4ab55a7f7cc39f0d6b7401f58efd17f6`. Its packet directory
`docs/measurements/ssa-source-134-2026-10-30` has Git tree
`c5cf4a573955176478ae93ec85a3419cd0214064`. These identities pin all 59
original paths, modes and blobs; the note is outside that directory.

The following are SHA-256 identities of original files in that packet:

| Original packet path | SHA-256 |
| --- | --- |
| `README.md` | `1fa3e04e243fe9b6a44189cda9c82a69d1afed10ef521b5020901db19aae4b7b` |
| `logs/9700x/manifest-main-caef4ea2.sha256` | `9130681db011d37fd56ac52375e87357f4a8c42ab29034f2472904fa5b0ba67d` |
| `logs/9700x/manifest-head-12bf987a.sha256` | `dde9af1ff9eef80fc3daef823afadb9f2ac79e9e52607feb03d4ecd257cfc350` |
| `logs/9700x/inputs.sha256` | `99f75db0224479fd9a5b6ffe36c52dd63d2613c15ace522a3f5b2ccfc0079581` |
| `logs/9700x/executables.sha256` | `f89b39f11eedca367e20d6e5b2da24e3c311ecfc3e6eeef2421fdb4a970225ba` |

The measured sources remain baseline
`caef4ea2cd1f47311842b2c1a4f87e55f14c29ea` and candidate
`12bf987ae3514fe2dcdc4170e937590b8b62b949`, using the recorded 9700X and
Clang 23.1.1 configuration. Published source
`34d79f72eb1e6904d4ffe539686bfcab93886ed0` changes documentation only
versus that measured candidate. This note does not qualify later source or an
unmeasured integration with a later main.

## Limits retained from review

- The legacy PMU reader records values without enabled/running times. Reported
  cycles and instructions do not establish full counter coverage; this does not
  allege actual multiplexing or a counter failure.
- The retained process summaries permit checking their reported medians and
  rounded rows, not reconstructing the absent inner 21-pass samples. Equal
  instruction and phi counts do not independently prove byte-identical IR.
- The laptop Lua, generated-program and mutant logs are historical precommit
  development observations without retained exact local source/mutant snapshots
  and executable digests. They do not independently qualify the measured or
  published source head.
- Evidence publication does not resolve source925's separate
  [timeout false-pass finding](https://github.com/buster14a/buster/pull/925#pullrequestreview-5715762579),
  certify a source contribution or close #134's conditional Tier1 acceptance.
  Source fixes, resulting-head review, applicable CI and normal merge gates
  remain separate.
