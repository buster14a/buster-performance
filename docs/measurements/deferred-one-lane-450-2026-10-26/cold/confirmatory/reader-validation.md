# Reproducing the complete corpus confirmation

The original C reader in ../../summary450.c is unchanged except for raising
MAX_ROWS from 4,096 to 8,192, sufficient for the 4,380 lane rows. MAX_ROUNDS remains 16;
five-pair validation, grouping, field parsing, medians and ranges are unchanged.

Build from the Buster performance record root:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror summary450.c -lm -o summary450
cd cold/confirmatory
../../summary450 summary raw/paired-*.log > summary.tsv
../../summary450 rows raw/paired-*.log > rows.tsv
```

The coordinator compiled this reader once through the actual local cores gate,
requesting two physical cores, a 200% quota and 8 GiB cap. It regenerated the
original 568-process summary byte-identically before reading the larger dataset.

Independent review used the original 4,096-row binary in two unit partitions,
then joined the summaries with one header. Its complete 439-line output is
byte-identical to this summary. Both compute SHA-256:

`16fe95265dd60d197e9f13ad4b013e3db8da6b432bcbfe9a8e25ea20df4d49d7`.

The summary has 438 rows (219 programs × two requested lane counts), each
containing five independent build pairs. rows.tsv has 4,380 observations.
Every process exits zero, all 226 identity digest rows agree before/after
and with the original cold-utility campaign, and group-all.log records an
actual 36-second shared-lock hold. The original one-pair screen and thirteen-case
five-pair dataset remain separate under ../raw/, ../rows.tsv and ../summary.tsv.
No original observation is replaced or normalized away.
