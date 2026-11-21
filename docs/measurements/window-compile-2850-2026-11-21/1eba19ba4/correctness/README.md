# Deferred spelling of enum switch diagnostics

The production patch is commit `1eba19ba4c93bf937116f708b026972e7db974ec` on `6e9c51b9d238734468dccc03ab1b6c715449804e`. The ordinary compiler computes the selector type, each checked case endpoint, enumeration membership and missing enumerators. Only the out-of-enum endpoint message prints the type. Before this patch the switch pass invoked the diagnostic type printer before testing case membership. That printer can construct name and type-spelling tables for the whole translation unit. The patch requests the printable type on the first endpoint which needs it and reuses it for subsequent invalid endpoints in that switch.

The ordinary diagnostic call stack observed with a debugger in the parent-source census binary is shown in `qa/original-stack.txt`. On clean Lua 5.4.8 lvm.c, the switch warning pass reached the type printer and its unit-wide name tables. A separate diagnostic compiler isolated lazy spelling behind a private environment switch, using the preceding production baseline f0a204a9c for that experiment. The same-image control ran default ordinary lvm.c compilations in alternating order. All five pairs retired fewer user instructions and cycles. The median differences on the local development machine were 52,438,108 fewer instructions, 18,458,283 fewer cycles and 690 fewer minor faults. Twelve code and warning control pairs matched the complete artifacts and diagnostics on Lua and a dedicated switch fixture. The locked hardware timings belong to the separate production comparison.

Run the production differential with built baseline and candidate compilers and a directory containing the frozen Lua 5.4.8 sources.

```sh
python3 compare.py /path/to/baseline/compiler /path/to/candidate/compiler /path/to/lua-5.4.8/src
```

The program checks reference and current-source outputs on 90 real driver pairs. Field, subscript, call and plain enumerated selectors cross exhaustive, missing, invalid and inverted range cases. Bare command-line policy, warnings enabled, promoted or suppressed, and a source diagnostic pragma are included. Each pair must agree on complete stdout and stderr, exit status, output presence and all file bytes. The local reproduction produced 77 full object pairs. The frozen Lua lvm.c source SHA-256 is `88b10a2f1f539cdfbefac818c64ceee59ac1b5f55038643637109a98834bb926`. Diagnostic hashes can depend on input path spelling.
