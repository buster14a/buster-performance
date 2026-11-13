# The merge queue's critical path, and the semantic driver's parts (#2030, #1430)

The record behind [buster14a/buster#2030](https://github.com/buster14a/buster/issues/2030)'s decision on further
partitioning: whether the semantic driver's sanitizer command still bounds the critical path of a full hosted run. It
uses the first merge-queue candidate that passed the full contract on `main`.

## Source

- Run [43454674045](https://github.com/buster14a/buster/actions/runs/43454674045): `9700x.yml`, event `merge_group`.
  - Candidate `a6ba875e9d5a6723f9c21dc50cee5cef03e5ab10` (#2631 on main `26f0bb0e`); main was fast-forwarded to it.
  - Created 2026-11-13T15:38:43Z, completed 16:14:08Z: 35.4 min.
- Hosted runners `ubuntu-26.04`, as drawn; native rows run on whatever CPU each job drew.
- Everything was read through the Actions API after the run: job timestamps, and the parallel runner's
  `##[group]NAME: passed in WALL s, CPU s of CPU` lines from each sanitizer shard's log.

## Files

- `jobs.tsv`: every job of the run. Columns: id, name, status, conclusion, created, started, completed, runner.
- `commands.tsv`: each inventory command's wall and CPU seconds, for every sanitizer shard (x86-64 and native;
  address, thread and memory). The vector pool's items and the plain rows are not included.

## Results

- **The run** had 102 jobs and took 889 runner-minutes over 35.4 min. That is inside #1430's 30–40 minute target.
  Jobs waited 2 s (median) and 3 s at most from creation to start: the runner pool was not saturated.
- **The longest shard's test step** (the parallel runner's span) was 22.4 min, native TSan shard 2 of 4. Next came
  native TSan 4/4 at 22.1 min and x86-64 MSan 6/6 at 19.3 min.
- **The longest commands:**

| Wall | Row, shard | Command |
| ---: | --- | --- |
| 1,050.6 s | x86-64 thread 5/6 | semantic driver, part 3 of 4 |
| 917.1 s | native thread 4/4 | semantic driver, part 4 of 4 |
| 808.6 s | x86-64 memory 6/6 | the C lexer as C++ |
| 740.2 s | x86-64 thread 5/6 | semantic driver, part 1 of 4 |
| 715.7 s | x86-64 thread 4/6 | semantic driver, part 2 of 4 |
| 699.3 s | x86-64 memory 6/6 | the parser on the repository's units |

- **The `address` row**, whose driver part 1 took 3,563–3,978 s in run 42714027068 (#2030's problem), has no
  command among the longest since #2067 and #2072 (in-process tests). Its longest shard's test step is
  12.8 min (x86-64 address 3/4).

## Conclusion

The semantic driver's longest part, 17.5 min, is shorter than the longest shard's test step, 22.4 min. Shards pack
commands by cost (`tools/ci/costs`), so splitting the driver further would not shorten the critical path. The run
already meets the target. What remains of the critical path is:
- the shards' packed load;
- each native shard building its own compiler (#2032);
- the sanitizer build's serial checker unit (#2639, #2647);
- the setup jobs.

## Limitations

- One run. Native rows' times depend on the CPU each job drew.
- The candidate's base was `main` at `26f0bb0e`. Later inventory changes shift the deal.
