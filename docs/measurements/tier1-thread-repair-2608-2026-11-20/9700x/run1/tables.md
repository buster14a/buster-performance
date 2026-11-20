### Lua's scripts (medians of 5 rounds, each a mean of 3 runs)

| | base cycles:u | head cycles:u | head/base | base instructions:u | head instructions:u | head/base |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| arithmetic (n=5) | 157.0 M | 155.9 M | 0.9928 | 911.8 M | 870.8 M | 0.9550 |
| calls (n=5) | 109.4 M | 111.4 M | 1.0187 | 494.7 M | 494.7 M | 1.0000 |
| closures (n=5) | 280.1 M | 280.9 M | 1.0031 | 1,303.9 M | 1,297.3 M | 0.9949 |
| strings (n=5) | 233.1 M | 232.8 M | 0.9989 | 980.4 M | 980.7 M | 1.0004 |
| tables (n=5) | 193.5 M | 195.1 M | 1.0083 | 906.3 M | 903.1 M | 0.9965 |
| geometric mean |  |  | 1.0043 |  |  | 0.9892 |

### Compile cost (medians of 11 alternating runs)

| | base cycles:u | head cycles:u | head/base | base instructions:u | head instructions:u | head/base | base task-clock | head task-clock | head/base |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| lua (n=11) | 984.7 M | 991.1 M | 1.0065 | 2,265.8 M | 2,272.6 M | 1.0030 | 197.08 ms | 198.36 ms | 1.0065 |
| sqlite (n=11) | 3,290.8 M | 3,384.3 M | 1.0284 | 8,072.1 M | 8,197.5 M | 1.0155 | 611.91 ms | 628.76 ms | 1.0275 |
| geometric mean |  |  | 1.0174 |  |  | 1.0093 |  |  | 1.0170 |

