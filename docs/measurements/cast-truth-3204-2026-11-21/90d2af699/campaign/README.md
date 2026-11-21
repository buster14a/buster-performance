# Compiler correctness campaign

The source SHA, compiler SHA-256, archived generator commit, OS and Clang version are recorded in provenance.txt. summary.txt records the eight checker and eight driver shards, tracked C fixtures, extracted inline fixtures, warning triggers, fixed probe suites and deterministic generator seeds. Each of the six sweeps retains the status of every input. The generator JSON records the binary digest, generator digest, seed options and completed result.

To rerun this campaign, build the recorded Buster commit in Develop configuration, set BUSTER_QA_TREE to the absolute path of that checkout and set BUSTER_QA_LLVM to the directory containing Clang 23.1.4. Set BUSTER_QA_PERF to an empty directory for the archived generator inputs and BUSTER_QA_OUT to a fresh results directory. From this directory run the following commands with Bash, Python 3 and the Buster `cores` scheduler on PATH.

```sh
python3 scripts/materialize-inputs.py /path/to/buster-performance "$BUSTER_QA_PERF"
bash scripts/regressions.sh
bash scripts/campaign.sh
python3 scripts/summarize.py "$BUSTER_QA_OUT"
```

The availability source exercises the Haiku availability attribute inside a statement expression on Linux. Warning 72 must raise an event under all three warning policies. Seed 62 pads the generated programs and selects several expressions, seed 63 uses pragmas, seed 64 enables Wall and Wextra, and seeds 65 and 66 include malformed inputs at the configured rate. Seed 66 also uses padding and multiple expressions.

Regression logs replace random temporary-directory suffixes with XXXXXX. The inline fixture table uses relative names rooted at inline/.
Superseded by adopted PR head 24c16e298bc7a5235711ff566fe652402d32173b before the combined warning-trigger and fixed-probe stages. All 16 checker/driver shards, the six three-policy fixture sweeps, and all six 15,000-program generator seeds finished on this predecessor. The adopted campaign runs all stages afresh, including the 93 warnings and the 8,009 fixed probes, with a distinct binary-verified cache.
