# Buster

Each timed command compiled all 1 sources containing 2,433,922 preprocessed tokens. Across 30 filesystem checks the candidate and baseline emitted identical complete [ELF object manifests](objects.tsv). [Invocation results](checks.tsv), [order](order.tsv), [individual samples](samples.tsv), [paired means](paired.tsv), [summary](paired-summary.tsv) and [native PMU, warning and timing reports](reports.tar.xz) preserve the observations.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.866 s (pmu), 1.407 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
