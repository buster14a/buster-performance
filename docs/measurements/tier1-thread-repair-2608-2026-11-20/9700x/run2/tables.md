### Lua's scripts (medians of 5 rounds, each a mean of 3 runs)

| | base cycles:u | head cycles:u | head/base | base instructions:u | head instructions:u | head/base |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| arithmetic (n=5) | 155.1 M | 154.7 M | 0.9976 | 911.8 M | 870.8 M | 0.9550 |
| calls (n=5) | 108.8 M | 109.1 M | 1.0022 | 492.8 M | 492.8 M | 1.0000 |
| closures (n=5) | 285.4 M | 281.2 M | 0.9850 | 1,300.0 M | 1,302.3 M | 1.0018 |
| strings (n=5) | 232.8 M | 228.7 M | 0.9822 | 979.2 M | 979.0 M | 0.9998 |
| tables (n=5) | 194.9 M | 195.4 M | 1.0028 | 904.6 M | 904.7 M | 1.0001 |
| geometric mean |  |  | 0.9939 |  |  | 0.9912 |

### Compile cost (medians of 11 alternating runs)

| | base cycles:u | head cycles:u | head/base | base instructions:u | head instructions:u | head/base | base task-clock | head task-clock | head/base |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| lua (n=11) | 981.4 M | 982.3 M | 1.0009 | 2,271.9 M | 2,272.4 M | 1.0002 | 196.45 ms | 196.58 ms | 1.0007 |
| sqlite (n=11) | 3,296.3 M | 3,296.0 M | 0.9999 | 8,106.1 M | 8,116.9 M | 1.0013 | 612.42 ms | 612.25 ms | 0.9997 |
| geometric mean |  |  | 1.0004 |  |  | 1.0008 |  |  | 1.0002 |

