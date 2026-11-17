#!/bin/bash
# setup-ask.sh: this directory's harness for the include search's asks (#2873): piece 2's tools, scripts and A/B
# (2873-p2-claude), a clone of buster, and the specification's hello.c as the `hello` input.
set -u
cd "$(dirname "$0")"
p2=~/buster-fast-bench/2873-p2-claude
mkdir -p w/inputs w/results
[ -d src ] || git clone -q "$p2/src" src || exit 1
cp -r "$p2/tools" "$p2/scripts" . || exit 1
[ -e w/tools ] || ln -s ../tools w/tools
cp "$p2/w/ab.sh" "$p2/w/build-tree.sh" w/ || exit 1
cp "$p2/w/inputs/empty.c" "$p2/w/inputs/tiny.c" w/inputs/ || exit 1
cp hello.c w/inputs/hello.c || exit 1
cat > w/lock.sh <<'LOCK'
#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run, and writes the holder's line
# (the lock's own record of this hold) to holds.txt first.
export EXCLUSIVE_OWNER="claude-2873-files" EXCLUSIVE_TITLE="Issue 2850 and related: the files rows of the kernel row (#2873)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2873#issuecomment-6937495274"
cd "$(dirname "$0")"
exec ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> holds.txt; exec "$@"' lock "$@"
LOCK
chmod +x w/lock.sh w/ab.sh w/build-tree.sh
cp files-ask.patch job-ask.sh counts.sh w/ || exit 1
chmod +x w/job-ask.sh w/counts.sh
ls w
echo setup done
