# Inverting the cast result-kind test

This supplementary mutation changes only the cast result predicate from equality with CHECK_CONSTANT_NONE to inequality. The operand must still denote an address. On the untouched GNU17 and C23 driver source the control matches Clang 23.1.4. With the inverted predicate, ten independent functions have different diagnostics in each language mode. The result is separate from deleting the same predicate, which had no discriminator in the sampled source corpus.

Start from a scratch checkout of 24c16e298bc7a5235711ff566fe652402d32173b and set BUSTER_QA_CLANG to Clang 23.1.4.

```sh
python3 prepare-faults.py "$TREE" 24c16e298bc7a5235711ff566fe652402d32173b "$OUT/manifest.json" --invert-result-kind
(cd "$TREE" && ./build.sh --config Develop)
python3 check-faults.py "$TREE" "$TREE/build/compiler" "$OUT/cases" --manifest "$OUT/manifest.json"
```
