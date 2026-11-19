#!/bin/bash
# TSan (vector host, Release) of C12a's head: test-files, whose lanes run the files' preparation.
cd /home/user/buster-c12a
L=~/.cache/claude-c7/c12a/san
export TMPDIR=$L/tmp
(BUSTER_SANITIZER=thread BUSTER_HOST_ARCH=vector nice -n 10 ./build.sh --config Release > $L/build-thread.log 2>&1); echo "build thread: $?" >> $L/summary-thread.txt
cp build/compiler $L/compiler-thread
( $L/compiler-thread test-files ) > $L/thread-files.log 2>&1; echo "thread files: $?" >> $L/summary-thread.txt
( $L/compiler-thread test-files --flat src ) > $L/thread-files-flat.log 2>&1; echo "thread files-flat: $?" >> $L/summary-thread.txt
echo done >> $L/summary-thread.txt
