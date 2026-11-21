# Ordinary compiler components and the direct-call option

On a Ryzen 9 7940HS, the witness-free physical call candidate increased retired user instructions even when the option was off. With the same SQLite source and arguments, seven paired clean Release runs at 6e9c51b9d and ff260ebac reproduced the locked-hardware instruction deltas: +0.654M in the default driver and +2.616M with `--node-window`. Actual cycle counts on this laptop vary with clocks and concurrent work on other cores.

A third compiler, 798f5b0de, contains the unchanged parent scanner, reference walker, emitter and ordinary no-decay graph loop as separately selectable alternatives. `BUSTER_CALL_COST_PRIOR` is a bit mask with values 1, 2, 4 and 8 respectively. Every measurement compiles an entire object on one reserved core, with one warmup and seven independently reordered rounds. All objects had SHA256 `2238999c41e256cc9c14ddbe21e379f0b3c09df25fb642b056e18b8a7ea773a0`.

Selecting the parent's no-decay graph traversal saved 1.593M retired instructions in the default driver and 1.613M with the regular window. The original reference walk saved 0.996M and 1.407M respectively. The original scanner saved 1.079M with regular windows. The additional lowering test accounted for about 9.7K window instructions. Source toggles change code layout and register allocation, so the component deltas describe this instrumented binary and do not add up to the separate executable delta.

`paired-instructions.tsv` gives all ranges, with individual results in `component-cost.tsv`. `true-stage.tsv` and `sampled-symbols.tsv.gz` contain the separate true-binary stage and retired-IP samples. Function-level samples fluctuate enough that the paired, same-binary component totals provide the more precise attribution.

Build the original Release and the ff260ebac candidate as `parent-release` and `clean-release` beside the scripts, and apply `observer.patch` to ff260ebac for the component instrument. Set `BUSTER_CORPUS_ROOT` as in `corpora.sh`. Run `python3 component-cost.py /path/to/component/compiler` and `python3 profile.py`.
