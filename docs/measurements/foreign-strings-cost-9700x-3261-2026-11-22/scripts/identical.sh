#!/bin/bash
# identical.sh: each input linked by main's and the fixed branch's Release executables with --merge-strings (and the
# branch as it was), the outputs compared byte for byte and run (#3261; run under the 9700X's lock).
D=~/buster-fast-bench/3044-claude
mkdir -p $D/out/identical
cd $D/inputs
while read -r input args; do
    for t in main old fix; do
        taskset -c 2 $D/$t/build/compiler link-foreign --merge-strings --lanes 1 -o $D/out/identical/$input-$t $args > /dev/null 2>&1 || echo "$input $t link failed"
    done
    run=""
    if [ "$input" != br ]; then
        "$D/out/identical/$input-fix" > /dev/null 2>&1; run="fix-exit $?"
    fi
    echo "$input fix-vs-main $(cmp -s $D/out/identical/$input-main $D/out/identical/$input-fix && echo identical || echo differs) old-vs-main $(cmp -s $D/out/identical/$input-main $D/out/identical/$input-old && echo identical || echo differs) $run sha256-fix $(sha256sum < $D/out/identical/$input-fix | cut -c1-16)"
done < $D/inputs.txt
