#!/bin/bash
# #2922's trees on the 9700X: a clone of buster, a worktree a tree (each with its COMMIT), the `always` tree the head's
# with always.patch (every select of a floating == or != fuses, as ef79b5b's did), each built Release by ./build.sh
# under the lock, one hold per build. setup.sh BRANCH NAME=SHA...
set -u
cd ~/buster-fast-bench/2922-claude
export EXCLUSIVE_OWNER=claude-2922 EXCLUSIVE_TITLE="#2922 Tier 1: a select of a floating == or != by two cmovs where its values don't recur" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2922
branch=$1
shift
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main "$branch"
for pair in "$@"; do
    name=${pair%%=*}
    sha=${pair#*=}
    [ -d $name ] || git -C repo worktree add -q --detach ../$name $sha
    if [ $name = always ]; then
        git -C $name apply ../scripts/always.patch && echo "$sha + scripts/always.patch" > $name/COMMIT
    else
        echo $sha > $name/COMMIT
    fi
    (cd $name && ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./build.sh --config Release > build.log 2>&1; echo "build exit $?" >> build.log)
    test -x $name/build/compiler && echo "$name built" || echo "$name FAILED"
done
echo done > setup.done
