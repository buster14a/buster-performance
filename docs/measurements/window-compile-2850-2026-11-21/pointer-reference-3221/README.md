# Static pointer equality and node summaries

The pre-fix measurement used the Develop binary of #3217 at 05dbff5f9, and the fixed one used #3221 at 2fa119e2a. The generated sources contain no switch statements. builds.txt records the binary hashes. The source fixture tests/checker/sources/pointer-constant-equality.c on the pre-fix code reported three reader references at the conditional initializer and two from the ordinary program. The candidate sends that initializer to the ordinary checker. Its shadow reports zero differences.

matrix.py generates 560 sources with the product of five declaration/use contexts, sixteen pointer and numeric conditions, and seven expression shapes. Each table records the normal compiler status, the number of T expressions and takes, and the summary comparison and difference counts. Under every warning policy, 32 file-scope and 32 function-static cases with a pre-fix reference difference match on the candidate. The same 60 inputs are rejected. All 336 automatic, runtime-return and aggregate cases retain the same admissions.

```sh
python3 matrix.py /path/to/compiler default.tsv
python3 matrix.py /path/to/compiler wall.tsv -- -Wall -Wextra
python3 matrix.py /path/to/compiler everything.tsv -- -Weverything -Wno-c++-compat
```

The default tracked-source table records all 1,249 C files at the target revision (418 clean, 831 rejected, zero unsound takes). Its rows are from the archived tests-holes-2850 sweep.py at buster-performance c00fc41627b5585208f02f7edf667583e8a14f08. shards.txt records all eight checker shards at seed 133 with Clang 23.1.4.
