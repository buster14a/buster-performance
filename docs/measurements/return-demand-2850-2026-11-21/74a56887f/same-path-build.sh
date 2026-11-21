#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
test ! -e results/returnprodv1-fde
test ! -e trees/returnprodv1-fde
test ! -e results/returnprodv2
test ! -e trees/returnprodv2
until test -s results/sixbd7/compiler.sha256 && test -s results/sixbasef0a/compiler.sha256; do sleep 3; done
git -C src worktree move "$PWD/trees/returnprodv1" "$PWD/trees/returnprodv1-fde"
mv results/returnprodv1 results/returnprodv1-fde
restore() {
 if [[ -e trees/returnprodv1 ]]; then git -C src worktree move "$PWD/trees/returnprodv1" "$PWD/trees/returnprodv2"; fi
 if [[ -d results/returnprodv1 ]]; then mv results/returnprodv1 results/returnprodv2; fi
 git -C src worktree move "$PWD/trees/returnprodv1-fde" "$PWD/trees/returnprodv1"
 mv results/returnprodv1-fde results/returnprodv1
}
trap restore EXIT
./build-label.sh returnprodv1 875c08e9dd85c4c67bbe24a00e54bbe33f0890b5 return-prod-v2.patch
sha256sum results/returnprodv1-fde/compiler results/returnprodv1/compiler
if cmp -s results/returnprodv1-fde/compiler results/returnprodv1/compiler; then echo IDENTICAL; else echo DIFFERENT; fi
