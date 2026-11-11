#!/bin/sh
# #1444: phases (phases.c) of homogeneous sequences, each build after itself (A and B the same executable), as a serial
# run of one build's compiles has them: base then head then base again, 400 processes each, the one-line -c and
# hello.c's. One hold.
#   phases2.sh TAG
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
cat > $d/phases2-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
for case in tiny hello; do
    case $case in
        tiny) set -- --time-stages -c tiny.c -o /dev/null ;;
        hello) set -- --time-stages -c hello.c -o /dev/null ;;
    esac
    for build in base head base; do
        echo "== $case, $build after itself: $*"
        $d/phases 200 $d/shifts-$build/compiler-0 $d/shifts-$build/compiler-0 -- "$@" | sed -n '1,6p'
    done
done
INNER
chmod +x $d/phases2-inner.sh
~/buster-fast-bench/exclusive.sh $d/phases2-inner.sh > $d/results/phases2-$tag.txt 2>&1
echo done > $d/results/phases2-$tag.done
