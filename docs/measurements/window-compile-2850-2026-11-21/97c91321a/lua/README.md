# Lua lparser.c ordinary compilation with program preparation changes

This Lua 5.4.8 lparser.c sensitivity measurement runs three ordinary compilers, 232da75f9 pristine, 97c91321a with lazy initializer and opening preparation, and a4e5b1935 with both that change and direct control roots. Each independent fresh process compiles one representative translation unit.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,455.0958 | 58,041,073.0 | 6.1115 |
| openings | 1,466.3219 | 58,002,328.0 | 6.1300 |
| combined | 1,469.8219 | 57,962,820.0 | 6.1150 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| openings minus baseline | +10.5251 [−17.5588, +26.8641] | −38,733.0 | +0.0095 [−0.0680, +0.0185] |
| combined minus baseline | +4.5012 [−13.2695, +17.1596] | −78,253.0 | +0.0035 [−0.0265, +0.0115] |
| combined minus openings | +4.2893 [−22.3629, +6.6345] | −39,535.0 | −0.0150 [−0.0360, +0.0795] |

PMU fault counts ranged from 1,166 to 1,170. The independent wall series recorded 1,190 to 1,192 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 24,078 preprocessed tokens in the Lua parser. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 51,568-byte object with SHA-256 `66995b0d9a26977b07b3a83cb1cdd08ea9f9057a6f416b3493e7813599dabd8a`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 0 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| openings | `97c91321a563a06b75dda5eaf022b9f0d2e9bfe7` | `e8141d485e3b855afa512643cca6e024833560ab74521785932bca9d160f3f29` |
| combined | `a4e5b1935526e0af6ca66daafb12b775f1427055` | `3c73edc66c2f4e54b749e591e428153f1966f42d518a0b9b1b41d00aac6c2e0f` |

The [paired-driver method](../../paired-driver/README.md), [mode selectors](openings-sample-config.sh), [command and object checks](openings-sample-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
