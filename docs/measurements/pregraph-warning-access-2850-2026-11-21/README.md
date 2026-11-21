# Warning effects retained from full source expressions

Across the four default corpora, the reader's source-only plan matched the ordinary warning pass on all 54,358 selected expressions and 269,725 records. Each affected record preserved its parser token, declaration object and local-access events. A direct replay at the function's first statement worked on 929 expressions without consulting the CFG. The remaining expressions carry their runtime events until the enclosing control's reach is available. [Buster #2850](https://github.com/buster14a/buster/issues/2850)

| Default corpus | Admitted roots | Records | Records with local-analysis events | Reached reads | Syntactic outside uses | Possible loop-change identifiers | Comparison candidates | Direct entry roots |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 26,370 | 137,236 | 39,745 | 29,472 | 29,235 | 9,648 | 186 | 152 |
| Lua | 3,996 | 20,860 | 5,771 | 4,585 | 4,480 | 1,025 | 39 | 53 |
| musl | 14,434 | 55,549 | 21,653 | 17,091 | 15,214 | 5,041 | 37 | 583 |
| Buster compiler | 9,558 | 56,080 | 20,409 | 16,456 | 15,097 | 4,603 | 502 | 141 |

The source pass runs on independently typed window values before graph indices exist. It records syntactic uses, writes and statement writes, plus evaluated reads, addresses and first writes. Read-modify-write places the write after the read. An enclosing loop can also consume the identifier for an array, address, direct member or assignment target. The graph's comparison reach consumes a comparison marker when sign-comparison checking is enabled. The returned-stack projection checks the subject of the ordinary address-of or array-decay candidate. No corpus or fixture admission had a positive returned-stack subject. The source window refuses the focused returned automatic-object examples. The comparison result covers the sign-comparison indexing decision. Separate comparison diagnostics and out-of-range tests remain the full-expression selector's responsibility.

The post-check oracle reruns the ordinary uninitialized-variable fact builder on the completed input with access-site instrumentation and records the actual effects. Syntactic flags are unconditional. For the runtime flags the comparison supplies the outer root's evaluated status after the ordinary region adjustment. A separate check classifies a branch-free expression immediately following its function body's opening brace from the parser and declaration metadata. Its runtime events replay as live without an oracle input. Every operand of each such expression was reached. Fifty-nine selected corpus expressions were unreachable. One hundred and one had internal conditional or logical operators. Their operands had the same reach as the root in this corpus. A production splice without an internal reach proof can fall back on those operators.

The cross.c fixture distinguishes two calls in the body of a for loop. Passing the loop variable's address suppresses the unmodified-loop-variable warning. Passing its value leaves the warning at the condition. A discarded postfix update also suppresses it. Both Buster and Clang emit exactly one loop warning. The reach.c fixture distinguishes a runtime read from a syntactic use after a return and a dead assignment from a reached write. Both compilers emit three uninitialized warnings and one set-but-unused parameter warning under Wall/Wextra. The read-implies-use mutation fails on two selected records in controls.c. An eagerly reached read changes the expected mask on the dead return. Removing the extra projections loses the loop-change and comparison witnesses. The controls and counts are in fixture-probes.txt.

All 1,230 tracked sources and 13,879 extracted programs ran under default, Wall/Wextra and Weverything/Wno-c++-compat (45,327 invocations). Each policy produced the original 409 clean / 821 rejected tracked programs and 6,633 clean / 7,246 rejected extracted programs. Every observed local-access, loop, sign-comparison and entry-reach result agreed. The 924 generated functions additionally cover constant and dynamic branch conditions, reads, stores and updates. A rejected translation unit and a completed source with zero selected expressions supply no access equality on those expressions.

The per-corpus manifests and per-record events were written before graph construction, keyed by translation unit and parser token. The root's file and byte offset locate its spelling. Macro expansions can share a spelling. See manifest-readme.txt for the columns. The corpus aggregates and individual observations are in corpora.txt and corpus-raw.txt.gz. A graph-deleting compiler must preserve token and object identity, relative read/write order, reach and final diagnostics when it consumes these rows. This measurement kept the ordinary graph and did not time compilation.

## Reproduction

Check out Buster 84a7d3d76891d6c393497e62e6aff38f2b162fc2 and apply the typed-window and warning-selection patches from the admission record. Apply access-entry.patch.gz third and build Develop. The reported compiler SHA-256 is bd51fdf26e93a511f5c0d69259532ba72bc505f2644a044519a0a6a2964da683. The earlier record supplies the frozen corpus arguments, source hashes, compiler-self source revision and fixture extractor. [Warning admission and corpus inputs](https://github.com/buster14a/buster-performance/tree/d1ed9acdefd5ab27a1be307281f80e13dff1d486/docs/measurements/pregraph-warning-admission-2850-2026-11-21)

~~~sh
gzip -dc "$admission/typed-window-probe.patch.gz" | git apply -
gzip -dc "$admission/warning-selection.patch.gz" | git apply -
gzip -dc "$record/access-entry.patch.gz" | git apply -
./build.sh
export NODE_PROOF_POINTERS=1 NODE_PROOF_NO_FP=1 NODE_PROOF_CALLS=1
build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "$record/controls.c"
NODE_PROBE_EVENT_READ_IS_USE=1 build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 "$record/controls.c"
NODE_PROBE_EAGER_ACCESS=1 build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 -Wall -Wextra "$record/reach.c"
NODE_PROBE_OMIT_EXTRAS=1 build/compiler measure-node-machine --shadow --window-rows --front-first --passes 0 -Wfor-loop-analysis -Wno-return-stack-address "$record/cross.c"
~~~

Set NODE_PROBE_EVENT_MANIFEST=1 when collecting source rows. For the fixture sweeps, place the executable at $out/probe-compiler and use the 24c16e298 fixture checkout and extracted file lists from the admission record. Each invocation records its exit status, counts and any mismatching token/object in the output JSONL.

~~~sh
python3 "$record/sweep.py" "$out" "$fixtures" "$admission/tracked.list" tests
python3 "$record/sweep.py" "$out" "$fixtures" "$scratch/inline.list" inline
python3 "$record/sweep-report.py" "$out/tests.jsonl" "$out/inline.jsonl"
~~~
