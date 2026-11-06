#!/bin/bash
# gate.sh: head vs gate (vector and --scalar) on the pragma fixtures and flag sets; clang's warning count beside.
cd /home/david/.cache/droid-1340/gate || exit 2
B=/home/david/.cache/droid-1340/bin
flagsets=("" "-Wall" "-Wextra" "-Wall -Wextra" "-Wsign-compare" "-Wextra -Wno-sign-compare" "-Werror=uninitialized" "-Weverything"
          "-w" "-Wall -Wno-uninitialized" "-Wunused-but-set-parameter" "-Wself-assign" "-Werror" "-Wall -Werror" "-Wno-everything -Wuninitialized"
          "-Wmost" "-W" "-Wno-error=sign-compare -Wextra -Werror")
diff_count=0
total=0
for file in *.c; do
    for flags in "${flagsets[@]}"; do
        for scalar in "" "--scalar"; do
            # shellcheck disable=SC2086
            "$B/compiler-head" -fsyntax-only -std=gnu17 $flags $scalar "$file" > out.head 2>&1; sh=$?
            # shellcheck disable=SC2086
            "$B/compiler-gate" -fsyntax-only -std=gnu17 $flags $scalar "$file" > out.gate 2>&1; sg=$?
            total=$((total + 1))
            if [[ $sh != "$sg" ]] || ! cmp -s out.head out.gate; then
                diff_count=$((diff_count + 1))
                echo "DIFF $file [$flags] $scalar status $sh/$sg"
                diff out.head out.gate | head -10
            fi
        done
        # shellcheck disable=SC2086
        clang -fsyntax-only -std=gnu17 $flags "$file" > out.clang 2>&1
        printf '%-14s %-36s buster %2d clang %2d\n' "$file" "[$flags]" "$(grep -c 'warning:\|error:' out.gate)" "$(grep -c 'warning:\|error:' out.clang)"
    done
done
echo "runs $total differences $diff_count"
