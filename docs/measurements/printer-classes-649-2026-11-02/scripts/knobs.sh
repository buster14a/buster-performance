#!/bin/bash
# usage: knobs.sh OUT ROUNDS TREE "ENV1" "ENV2" ...  (on benchpress): per round one lock hold, main.c -P and -E with each
# environment setting in turn (order reversed every other round). Files CONFIG.N.ROUND.txt, N the setting's index.
out=~/buster-fast-bench/649-claude/out/"$1"; rounds="$2"; tree="$3"; shift 3
mkdir -p "$out"
printf '%s\n' "$@" > "$out/settings.txt"
cat > "$out/round.sh" <<'ROUND'
#!/bin/bash
out="$1"; round="$2"; tree="$3"; shift 3
unset CPATH C_INCLUDE_PATH
src=~/buster-fast-bench/649-claude/base/src
args="-target x86_64-pc-linux-gnu -march=native -I$src -fwrapv -funsigned-char $src/buster/compiler/main.c"
cd ~/buster-fast-bench/649-claude/"$tree" || exit 1
for config in mainP mainE; do
    markers=""; [[ $config == *E ]] && markers="--markers"
    for index in "$@"; do
        setting=$(sed -n "$((index + 1))p" "$out/settings.txt")
        env $setting taskset -c 2 ./build/compiler benchmark-preprocessor --only vectorized $markers $args > "$out/$config.$index.$round.txt" 2>&1
    done
done
ROUND
chmod +x "$out/round.sh"
count=$#
for round in $(seq 1 "$rounds"); do
    order=(); for (( i=0; i<count; i++ )); do order+=($i); done
    if (( round % 2 == 0 )); then order=(); for (( i=count-1; i>=0; i-- )); do order+=($i); done; fi
    EXCLUSIVE_OWNER=claude-649 EXCLUSIVE_TITLE="solve 649 knob round" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/649" \
        ~/buster-fast-bench/exclusive.sh "$out/round.sh" "$out" "$round" "$tree" "${order[@]}" > "$out/lock.$round.txt" 2>&1
done
echo done > "$out/done"
