#!/bin/bash
# evict.sh LABEL: the front with the window on sqlite3.c (--front-window) from the build's own file: twice as it is,
# once through a hard link (the same inode and pages), then twice after its pages are dropped from the page cache
# (posix_fadvise DONTNEED) and read back. Each run its own hold of the lock, CPU 2.
cd "$(dirname "$0")"
. ./corpora.sh
label=$1
out=$PWD/results/$label
run() { ./lock.sh bash -c "taskset -c 2 $1 measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments" 2>&1 | grep -o 'the front with the window: ticks=[0-9]*' | grep -o '[0-9]*$'; }
echo "$label as it is: $(run $out/compiler) $(run $out/compiler)"
ln -f "$out/compiler" "$out/compiler-link"
echo "$label through a hard link: $(run $out/compiler-link)"
rm -f "$out/compiler-link"
python3 - "$out/compiler" <<'PY'
import os, sys
fd = os.open(sys.argv[1], os.O_RDONLY)
os.fsync(fd)
os.posix_fadvise(fd, 0, 0, os.POSIX_FADV_DONTNEED)
os.close(fd)
PY
echo "$label after its pages were dropped: $(run $out/compiler) $(run $out/compiler)"
echo evict done
