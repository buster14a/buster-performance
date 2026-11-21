#!/bin/bash
# local-round.sh OUT LIST INDEX...: the faults in the cloud container's mutation tree (TREE, the code under test a
# commit of its own, checked out clean): each fault INDEX of LIST alone: applied, a Develop build, test-checker's part
# 5 of 8 (the node machine's tests), and for a fault named in ALL_PARTS every part; the sources restored after each. A
# line a fault in OUT/round.txt: caught (a part ran and fails), SURVIVED, not-built, or KILLED (a status that is no
# test's verdict: the container's memory or the time limit).
tree=${TREE:-/home/user/mut-sides}
out=$1; list=$2; shift 2
all_parts=${ALL_PARTS:-note-not-in-the-input}
mkdir -p "$out"
cd "$tree" || exit 1
[ -z "$(git status --short)" ] || { echo "the tree is not clean"; exit 1; }
restore() { git checkout -q -- src; }
for n in "$@"; do
    [ -e "$out/stop" ] && break
    restore
    fault=$(python3 "$list" "$tree" "$n") || { echo "not-applied $n" >> "$out/round.txt"; continue; }
    ./build.sh > "$out/build.log" 2>&1
    if [ $? != 0 ]; then echo "not-built $n $fault" >> "$out/round.txt"; cp "$out/build.log" "$out/not-built-$n.log"; continue; fi
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    parts="5"
    case " $all_parts " in *" $fault "*) parts="5 1 2 3 4 6 7 8" ;; esac
    verdict=SURVIVED; status=0; summary=""
    for part in $parts; do
        timeout 900 ./build/compiler test-checker --seed 133 --part $part/8 > "$out/part.out" 2> "$out/part.err"
        status=$?
        summary=$(grep 'test-checker:.*checks' "$out/part.out" | tail -1)
        if [ "$status" != 0 ]; then
            if [ -n "$summary" ]; then verdict=caught; else verdict=KILLED; fi
            cp "$out/part.err" "$out/caught-$n.err"
            break
        fi
    done
    echo "$verdict $n $fault part $part status $status; $summary" >> "$out/round.txt"
done
restore
echo "job finished" >> "$out/round.txt"
