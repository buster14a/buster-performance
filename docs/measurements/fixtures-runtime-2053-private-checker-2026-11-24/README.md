# Private checker catalogs for Buster #2053

Clang 23.1.4 verified all 458 ordered records against the initializers in `b6eb10860`. They include 445 raw sources (53,976 bytes), 13 bound C-generated or specially modeled cases, and 20 function-name goldens. The correct comparison for the wide bit builtin cases uses GNU23 in Buster and the existing GNU17 Clang command. The final candidate is `78207a6f2`.

All eight vector Release checker shards passed with seed 133 (833,553 checks). The bit-builtin focus ran 2,138 checks before and 2,142 after. A new source and row added 31 checks with the same executable. The wrong acceptance flag, a dialect outside the suite's contract and removing the bound full-width probe each failed. All data changes and restoration scheduled zero host commands. Touching the private runner scheduled the checker object, link and bake.

Host C shrank by a net 104,382 bytes. The checker object changed from 30,507,888 to 30,318,512 bytes and the executable from 74,097,600 to 74,052,608 bytes.

Compile the two dumpers and compare the working files with `python verify-private.py BUSTER_SOURCE_ROOT .`. The first shard-7 run failed twice in a native program comparison while two large builds were running. Its isolated retry used the same executable and fixture snapshot. The logs for both are included. Timing and size observations are from the four-vCPU cloud quota.
