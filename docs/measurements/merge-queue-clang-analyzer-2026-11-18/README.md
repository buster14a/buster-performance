# Clang Static Analyzer in buster's merge queue

A single hosted analyzer job fits within the existing merge queue's critical path in this sample. Start it alongside hosted correctness and fuzzing after preparation. The strict job fails on any analyzer finding. The measured compiler revision reported 46 findings, so the queue gate remains disabled pending triage.

## Hosted probe

The probe ran on three independent GitHub-hosted `ubuntu-26.04` VMs with four vCPUs each. All three restored the repository's pinned toolchain cache and ran official Clang 23.1.4. Each analyzed the same 43 translation units from `build.sh print-sources`, including the unity units and the build's test and benchmark units. Each used the vector target and the Release flags from `build.sh print-compile-flags`, with debug information disabled. The invocation added `--analyze -Wno-error -fno-color-diagnostics -Xanalyzer -analyzer-output=text` and ran four Clang processes at a time. The Release build's optional preprocessor branches, such as its libFuzzer entry, require their own configurations. The analyzer runs without linking or executing buster. The EPYC 7763 result also demonstrates that an AVX-512 runner draw is unnecessary.

Compiler revision `6eaf73cfd889f866015cdcaaf08f86cfc702ce66` was main at the start of the investigation. The probe revision `03b2657c8fa92453396029008698e9ced47b6be1` adds only the branch-scoped workflow. The [timed run](https://github.com/buster14a/buster/actions/runs/44255205378) has the original logs. The [initial setup attempt](https://github.com/buster14a/buster/actions/runs/44255155052) stopped before analysis because the shallow checkout omitted the parent used to label the run.

| Replica | Runner CPU | Analyzer sweep | Whole job |
| --- | --- | ---: | ---: |
| 1 | EPYC 9V45 | 58.06 s | 90 s |
| 2 | EPYC 7763 | 114.76 s | 151 s |
| 3 | EPYC 9V45 | 59.01 s | 91 s |

Whole-job time starts at runner assignment and includes checkout, cache restore, tool staging and upload. Each job waited two seconds for assignment. The peak Clang RSS measured in any single process was 486 MiB. All 129 Clang invocations returned zero. The three replicas each produced the same 46 unique warning lines, including 34 dead-store warnings and 12 diagnostics from other checkers. The diagnostics are untriaged. Logs for individual units include path notes in the run artifacts, and the warning lines are also in the job logs.

## Failure behavior

The strict run kept the Release build’s `-Werror` and used `-Xclang -analyzer-werror -ferror-limit=0`. Clang elevated the same 46 unique findings to errors. The sweep checked every unit. Clang exited 1 on 29 units and 0 on 14. The job failed after 87 s, including a 54.87 s sweep, and uploaded its diagnostic artifact. With Clang’s default error limit, the checker unity unit dropped one report after 20 errors, so the strict run removed that limit. [Strict run](https://github.com/buster14a/buster/actions/runs/44256855027)

## Queue comparison

The latest 20 successful candidates from main's merge queue at the sampled revision were verified against main's first-parent history. From workflow creation to the successful `Integration qualification` check, they took **23 min 17 s to 29 min 43 s**, with a median of **26 min 10 s**. The [candidate for the measured revision](https://github.com/buster14a/buster/actions/runs/44245102433) took 25 min. Its pinned-tool preparation completed 74 s after workflow creation. Combining that start offset with the slowest analyzer job and its runner wait puts the analyzer at about **3 min 47 s** from workflow creation. This gives more than 19 minutes of headroom against the fastest sampled candidate.

One analyzer adds roughly 1.5 to 2.5 runner-minutes and one concurrent runner per candidate. The reference candidate used about 376 hosted runner-minutes, so the slowest replica would add about 0.7% to that run's hosted runner time. At four simultaneous candidates the analyzer could occupy four runners. The probe and historical runs provide a critical-path estimate. A saturated queue and toolchain cache misses were outside the sample.

## Evidence

- [Probe workflow](probe-workflow.yml), [Release arguments](build-flags.txt), [replica timings](replicas.tsv), and [per-unit timings](units.tsv)
- [Deduplicated diagnostics](warnings.txt), [strict workflow](strict-probe-workflow.yml), [strict job timing](strict-run.tsv), and [strict per-unit exits](strict-units.tsv)
- [Queue check timings](queue-timings.tsv) and [reference candidate job timings](reference-queue-jobs.tsv)
