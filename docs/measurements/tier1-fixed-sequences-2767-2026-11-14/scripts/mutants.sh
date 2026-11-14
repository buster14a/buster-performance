#!/usr/bin/env bash
# mutants.sh: each mutation applied alone to a pristine copy of its file, the compiler built, its test run; prints
# whether the test failed (it must).
set -u
cd /home/user/buster
C=$HOME/.cache/claude-2767
run() { # name file python-old python-new test...
    name=$1; file=$2; old=$3; new=$4; shift 4
    cp $file $C/backup/mutant.orig
    python3 - "$file" "$old" "$new" <<'PY'
import sys
p,old,new=sys.argv[1:4]
s=open(p).read()
assert s.count(old)==1, (old, s.count(old))
open(p,'w').write(s.replace(old,new))
PY
    if ./build.sh > $C/mutant-build.log 2>&1; then
        "$@" > $C/mutant-$name.log 2>&1; rc=$?
        echo "$name: test exit $rc ($( [ $rc != 0 ] && echo killed || echo SURVIVED))"
    else
        echo "$name: build failed"
    fi
    cp $C/backup/mutant.orig $file
}
run no-sequences src/buster/compiler/tier1_emit_cfg.c '            .sequence_count = sequence_count,' '            .sequence_count = 0,' ./build/compiler test-tier1-emit
run consumer-saves-reader src/buster/compiler/tier1_emit_cfg.c 'owner != node && owner != reader &&' 'owner != node && (reader == BUSTER_IR_NONE || true) &&' ./build/compiler test-tier1-emit
run rows-ignore-reader src/buster/compiler/tier1_emit.c '(readers != 0 && readers[first] == node)' '(readers != 0 && readers[first] == node && false)' ./build/compiler test-tier1-emit
run no-reader-exemption src/buster/compiler/tier1_cfg.c 'uint32_t first = general && readers != 0 ? reader_offsets[values[i]] : 0;' 'uint32_t first = general && readers != 0 ? reader_offsets[values[i] + 1] : 0;' ./build/compiler test-tier1-cfg
run no-webs src/buster/compiler/tier1_cfg.c '            if (b != BUSTER_TIER1_CFG_NONE && b != a)
            {
                webs[b] = a;' '            if (b != BUSTER_TIER1_CFG_NONE && b != a && false)
            {
                webs[b] = a;' ./build/compiler test-tier1-cfg
run start-inclusive src/buster/compiler/tier1_cfg.c 'low = input->sequences[middle] <= starts[i] ? middle + 1 : low;' 'low = input->sequences[middle] < starts[i] ? middle + 1 : low;' ./build/compiler test-tier1-cfg
run no-preference src/buster/compiler/tier1_allocate.c '    return kept != 0 ? kept : pool;' '    return kept != 0 && false ? kept : pool;' ./build/compiler test-tier1-allocation
run colored src/buster/compiler/tier1_allocate.c 'regular &= allowed[i] == columns.registers[class] && (columns.avoided_registers == 0 || (columns.avoided_registers[i] & allowed[i]) == 0);' 'regular &= allowed[i] == columns.registers[class];' ./build/compiler test-tier1-allocation
./build.sh > $C/mutant-build.log 2>&1; echo "restored build exit $?"
git diff --stat | tail -1
