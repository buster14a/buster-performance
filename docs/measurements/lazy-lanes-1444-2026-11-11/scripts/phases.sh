#!/bin/sh
# #1444: phases (phases.c) on base's and head's placement-0 executables, 400 processes of each per input, alternated,
# the parent spinning. One hold.
#   phases.sh TAG
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
clang -O2 -Wall -Wextra -o $d/phases $d/phases.c
cat > $d/phases-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
for case in empty tiny hello; do
    case $case in
        empty) set -- --time-stages -fsyntax-only empty.c ;;
        tiny) set -- --time-stages -c tiny.c -o /dev/null ;;
        hello) set -- --time-stages -c hello.c -o /dev/null ;;
    esac
    echo "== $case: $*"
    $d/phases 200 $d/shifts-base/compiler-0 $d/shifts-head/compiler-0 -- "$@"
done
INNER
chmod +x $d/phases-inner.sh
~/buster-fast-bench/exclusive.sh $d/phases-inner.sh > $d/results/phases-$tag.txt 2>&1
echo done > $d/results/phases-$tag.done
