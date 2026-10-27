#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 file-probe regression check' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/489
B=$HOME/buster-fast-bench
D=$B/codex-489-handoff
export XDG_CACHE_HOME=$D/campaign/probe-cache
mkdir -p "$D/campaign/probe-cache" "$D/campaign/logs"
cat > "$D/campaign/unwind.c" <<'C'
typedef int (*Callback)(void *, void *);
extern int _Unwind_Backtrace(Callback, void *);
static int callback(void *context, void *data) { return 5; }
int main(void) { _Unwind_Backtrace(callback, (void *)0); return 0; }
C
cd "$D"
"$B/exclusive.sh" ./build/compiler "$B/libgcc-s-489-hello.c" -o campaign/probe-hello > campaign/logs/probe-warm.log 2> campaign/logs/probe-warm.stderr
"$B/exclusive.sh" strace -o campaign/logs/probes-hello.trace -e trace=stat,newfstatat,statx ./build/compiler "$B/libgcc-s-489-hello.c" -o campaign/probe-hello > campaign/logs/probes-hello.log 2> campaign/logs/probes-hello.stderr
"$B/exclusive.sh" strace -o campaign/logs/probes-unwind.trace -e trace=stat,newfstatat,statx ./build/compiler campaign/unwind.c -o campaign/probe-unwind > campaign/logs/probes-unwind.log 2> campaign/logs/probes-unwind.stderr
if grep libgcc_s.so.1 campaign/logs/probes-hello.trace; then exit 1; fi
grep libgcc_s.so.1 campaign/logs/probes-unwind.trace
echo 'probe check done'
test "$(grep -c crtbeginS.o campaign/logs/probes-hello.trace)" -eq 1
echo 'begin object checked once'
cmp "$B/codex-489-final/campaign/probe-hello" "$D/campaign/probe-hello"
cmp "$B/codex-489-final/campaign/probe-unwind" "$D/campaign/probe-unwind"
echo 'writer outputs unchanged'
sha256sum "$B/libgcc-s-489-main/build/compiler" "$B/codex-489-base/build/compiler" "$D/build/compiler" /usr/lib64/libgcc_s.so.1 /usr/lib/gcc/x86_64-pc-linux-gnu/16/libgcc.a /usr/lib/libc.so.6 /usr/lib/ld-linux-x86-64.so.2
