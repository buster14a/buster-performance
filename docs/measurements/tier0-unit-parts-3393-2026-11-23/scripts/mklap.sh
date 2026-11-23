#!/bin/bash
# mklap.sh REV MAP: the worktree at REV with laps over the stages' functions (MAP: the laps' sources), built znver5.
set -eu
S=/tmp/claude-0/-home-user-buster/e2ef93d9-0a28-5860-99ad-744c2baee624/scratchpad
cd /home/user/wt && git checkout -q -- src && git checkout -q --detach $1
E=src/buster/compiler; F=$S/tools/fn.sh
m=$(grep -n "        NameId name = 0;" $E/c_check_program_emit.c | head -1 | cut -d: -f1)
bl=$(grep -n "        const bool source_body = b < count;" $E/c_check_program_emit.c | head -1 | cut -d: -f1)
specs="$($F $E/c_check_program_emit.c check_program_emit_timed) $E/c_check_program_emit.c:$((m-4)):$((m+150)):8 $E/c_check_program_emit.c:$bl:$((bl+235)):8 $($F $E/c_check_program_emit.c check_program_object_access) $($F $E/c_check_program_emit.c check_program_attributed) $($F $E/c_check_tier1_inline.c check_tier1_inline_table) $($F $E/c_check_data.c check_data_emit) $($F $E/c_check_data.c check_data_plan_object) $($F $E/c_check_string_pool.c check_data_string_pool) $($F $E/c_check_program_emit.c check_program_sections) $($F $E/c_checker_driver.c check_driver_lower_report) $($F $E/object_writer.c object_build) $($F $E/object_writer.c object_build 8) $($F $E/link.c link_check) $($F $E/object_writer.c object_prepare) $($F $E/c_checker_driver.c check_driver_object_finish) $($F $E/c_checker_driver.c check_driver_object_finish 8) $($F $E/c_checker_driver.c check_driver_object_build) $($F $E/c_check_program_emit.c check_program_emit_window_keep) ${EXTRA:-}"
python3 -I $S/tools/xlap.py $2 $specs
git apply --include='src/buster/compiler/main.c' $S/xlap1.patch
python3 - <<'PY'
p='src/buster/compiler/c_checker_driver.c'
s=open(p).read()
a='''    *state = (CheckDriverCode){
        .output = arena_reserve(UINT64_C(1) << 34),'''
assert a in s
s=s.replace(a,'    BUSTER_XLAP(0);\n'+a,1)
i=s.index('    check_driver_object_release(state, lanes, scratch);\n', s.index('static bool check_driver_object_finish('))
s=s[:i]+'''    BUSTER_XLAP(999);
    if (getenv("BUSTER_XLAP") != NULL)
    {
        for (uint32_t i = 0; i < 1024; i += 1)
        {
            if (buster_xlap_hits[i] != 0)
            {
                fprintf(stderr, "xlap\\t%u\\t%llu\\t%llu\\n", i, (unsigned long long)buster_xlap_ticks[i], (unsigned long long)buster_xlap_hits[i]);
            }
        }
    }
'''+s[i:]
open(p,'w').write(s)
blk='''#ifndef BUSTER_XLAP
__attribute__((weak)) uint64_t buster_xlap_ticks[1024];
__attribute__((weak)) uint64_t buster_xlap_hits[1024];
__attribute__((weak)) uint64_t buster_xlap_last;
#define BUSTER_XLAP(n) do { const uint64_t xlap_now_ = __rdtsc(); buster_xlap_ticks[n] += xlap_now_ - buster_xlap_last; buster_xlap_hits[n] += 1; buster_xlap_last = xlap_now_; } while (0)
#endif
'''
for p in ['src/buster/compiler/object_writer.c','src/buster/compiler/link.c']:
    s=open(p).read()
    i=s.index('\nstatic ')
    s=s[:i]+'\n'+blk+s[i:]
    open(p,'w').write(s)
PY
BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $S/build-wt.log 2>&1 || { grep -m3 -A3 error: $S/build-wt.log; exit 1; }
N=$(basename $2 .map)
strip -o $S/z-$N.s build/cmake/znver5/Release/compiler && zstd -q -f -T4 -10 $S/z-$N.s -o $S/z-$N.zst
timeout 900 tailscale ssh david@benchpress "cat > ~/buster-fast-bench/3393-claude/bin/$N.zst" < $S/z-$N.zst
timeout 120 tailscale ssh david@benchpress "cd ~/buster-fast-bench/3393-claude && zstd -q -d -f bin/$N.zst && chmod +x bin/$N && (setsid nohup env EXCLUSIVE_OWNER=claude-3393 EXCLUSIVE_TITLE='buster #3393 unit parts' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3393 ~/buster-fast-bench/exclusive.sh timeout -k 5 300 scripts/xlap.sh \$PWD/bin/$N $N 7 > results/$N.log 2>&1 < /dev/null &); echo launched"
