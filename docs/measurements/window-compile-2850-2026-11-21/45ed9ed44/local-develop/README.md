# Local Develop compile with zero persistent SQLite expression nodes

On a Ryzen 9 7940HS core the five fresh paired SQLite process rounds were all slower. The median elapsed difference was +42.639 ms, with 2,776 fewer minor faults and 20,742 KiB higher peak RSS. On the Buster self source the median paired elapsed difference was +134.243 ms, with 19,489 fewer minor faults and 41,706 KiB lower peak RSS. Both modes emitted the same complete target object in each workload. [Paired results](paired.tsv), [all samples](samples.tsv), [raw timings, profiles and commands](raw.tar.gz).
