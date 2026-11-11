#!/bin/sh
# #1444's exit helper: phases (phases.c) of each build after itself (A and B the same executable), as a serial run of one
# build's compiles has them, the parent spinning: base, lanes, head, then base again, 400 processes each, for the
# one-line -c and hello.c's. One hold.
#   phases.sh TAG
. ~/buster-fast-bench/1444-claude-exit/env.sh
cd $d/inputs
tag=$1
clang -O2 -Wall -Wextra -o $d/phases $d/phases.c
cat > $d/phases-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-exit
for case in tiny hello; do
    case $case in
        tiny) set -- --time-stages -c tiny.c -o /dev/null ;;
        hello) set -- --time-stages -c hello.c -o /dev/null ;;
    esac
    for build in base lanes head base; do
        echo "== $case, $build after itself: $*"
        $d/phases 200 $d/shifts-$build/compiler-0 $d/shifts-$build/compiler-0 -- "$@" | sed -n '1,6p'
    done
done
INNER
chmod +x $d/phases-inner.sh
mkdir -p $d/results
~/buster-fast-bench/exclusive.sh $d/phases-inner.sh > $d/results/phases-$tag.txt 2>&1
echo done > $d/results/phases-$tag.done
