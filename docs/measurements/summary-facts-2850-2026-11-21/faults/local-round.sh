#!/bin/bash
# local-round.sh OUT LIST INDEX...: the faults in the cloud container's mutation tree (TREE, the frozen
# code a commit of its own): each fault INDEX of LIST alone: applied, a Develop build, test-checker's part 5 of 8; the
# four files restored after each. A line a fault in OUT/round.txt: caught (the part ran and fails), SURVIVED, not-built,
# or KILLED (a status that is no test's verdict: the container's memory or the time limit).
tree=${TREE:-/home/user/mutv}
out=$1; list=$2; shift 2
files="src/buster/compiler/c_check_node_machine_rows.c src/buster/compiler/c_check_node_machine_facts.c src/buster/compiler/c_check_node_machine_window.c src/buster/compiler/c_check_node_census.c"
mkdir -p "$out/pristine"
cd "$tree" || exit 1
[ -z "$(git status --short)" ] || { echo "the tree is not clean"; exit 1; }
for f in $files; do cp "$f" "$out/pristine/$(basename $f)"; done
restore() { for f in $files; do cp "$out/pristine/$(basename $f)" "$f"; done; }
for n in "$@"; do
    [ -e "$out/stop" ] && break
    restore
    fault=$(python3 "$list" "$tree" "$n") || { echo "not-applied $n" >> "$out/round.txt"; continue; }
    ./build.sh > "$out/build.log" 2>&1
    if [ $? != 0 ]; then echo "not-built $n $fault" >> "$out/round.txt"; cp "$out/build.log" "$out/not-built-$n.log"; continue; fi
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    timeout 900 ./build/compiler test-checker --seed 133 --part 5/8 > "$out/part5.out" 2> "$out/part5.err"
    status=$?
    summary=$(grep 'test-checker:.*checks' "$out/part5.out" | tail -1)
    case "$status" in
        0) verdict=SURVIVED ;;
        *) if [ -n "$summary" ]; then verdict=caught; else verdict=KILLED; fi ;;
    esac
    echo "$verdict $n $fault status $status; $summary" >> "$out/round.txt"
done
restore
echo "job finished" >> "$out/round.txt"
