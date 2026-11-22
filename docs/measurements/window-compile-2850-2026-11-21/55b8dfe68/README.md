# Early native publication on the frozen C inputs

The source reader and checker lower one accepted function while its graph is live. Tier 0 selects and sizes the instructions immediately. The function publishes its bytes, unwind frame, label offsets and byte-positioned symbolic relocations. The ordinary unit selects functions in its usual order and binds those references to the final symbols. The source-owned CFG supplies the return-flow result and object references before releasing its statement rows. The full unit keeps ordinary checking and emission for functions that require it.

## Revisions and qualification

`units.tsv` gives the object hashes, source-owned function counts, final native-fragment counts and typed-row lifetimes at each revision. `06869ae95` unmapped the typed arena after every retired function. `55b8dfe68` reproduces those complete images with a final SQLite CheckProgram of zero populated control records, one reserved control slot and 11,162 object references. The five-function fixture holds zero persistent graph nodes, zero final control records and zero typed functions, and its Clang and Buster executables returned the same result. `*.final-controls.log` and `fixture.final.log` contain the actual compiler counters.

`edges.tsv` covers the 130 paired options, attributes, atomics/ABI and control probes against the same source producer with late native emission. `pair-counts.tsv` summarizes the wider 6,860 process, object and diagnostic pairs on `4c158d75d` across the five warning policies. Each workload has a per-input table. Frozen SQLite and Buster were also compared to an independently built ordinary compiler at each listed revision.

## Local elapsed measurements

`develop.tsv` contains seven mirrored, single-core local rounds for each of four arms, using the same 15-unit Develop executable from `4c158d75d`. `develop-binary.sha` identifies that executable. Every timed invocation generated the expected 2,061,200-byte SQLite object. `develop-summary.tsv` reports median process wall time, CPU times, peak RSS, minor faults and the median within-round wall-time difference from the source-plus-late-Tier-0 arm. The host was the local Ryzen 9 7940HS. The frozen-9700X acceptance workload uses separate measurements.

The ordinary arm has no experiment variables. The source arm sets `BUSTER_CONTROL_SOURCE_NATIVE=1`. The early arm also sets `BUSTER_CONTROL_EARLY_NATIVE=1`. The release arm additionally sets `BUSTER_CONTROL_EARLY_RELEASE=1`. The diagnostic lifetime witness adds `BUSTER_CONTROL_EARLY_POISON=1`, `BUSTER_CONTROL_EARLY_AUDIT=1` and `BUSTER_CONTROL_FINAL_AUDIT=1`. The separately recorded `*.stages.log` files include the ordinary output-writing stages. Early selection, sizing and encoding take place inside the input pass, so the late stage counters alone cannot establish a wall-time improvement.
