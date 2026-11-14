#!/usr/bin/env bash
# mutants2.sh: the consumer's mutants against the final fixture, and the operand and result rules', each alone, as
# mutants.sh's.
set -u
cd /home/user/buster
C=$HOME/.cache/claude-2767
run() {
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
        timeout 600 "$@" > $C/mutant-$name.log 2>&1; rc=$?
        echo "$name: test exit $rc ($( [ $rc != 0 ] && echo killed || echo SURVIVED))"
    else
        echo "$name: build failed"
    fi
    cp $C/backup/mutant.orig $file
}
run no-sequences src/buster/compiler/tier1_emit_cfg.c '            .sequence_count = sequence_count,' '            .sequence_count = 0,' ./build/compiler test-tier1-emit
run consumer-saves-reader src/buster/compiler/tier1_emit_cfg.c 'owner != node && owner != reader &&' 'owner != node && (reader == BUSTER_IR_NONE || true) &&' ./build/compiler test-tier1-emit
run rows-ignore-reader src/buster/compiler/tier1_emit.c '(readers != 0 && readers[first] == node)' '(readers != 0 && readers[first] == node && false)' ./build/compiler test-tier1-emit
run no-operands src/buster/compiler/tier1_emit_cfg.c 'sequence_operands[sequence_count] = operand < count ? node_values[operand] : BUSTER_TIER1_CFG_NONE;' 'sequence_operands[sequence_count] = operand < count && false ? node_values[operand] : BUSTER_TIER1_CFG_NONE;' ./build/compiler test-tier1-emit
run no-results src/buster/compiler/tier1_emit_cfg.c 'sequence_results[sequence_count] = tier1_select_fixed_result(&plan->patterns[node]) ? node_values[node] : BUSTER_TIER1_CFG_NONE;' 'sequence_results[sequence_count] = tier1_select_fixed_result(&plan->patterns[node]) && false ? node_values[node] : BUSTER_TIER1_CFG_NONE;' ./build/compiler test-tier1-emit
run crossed-ignores-operands src/buster/compiler/tier1_cfg.c 'web_masks[operand != BUSTER_TIER1_CFG_NONE ? webs[operand] : input->value_count] |= input->sequence_registers[k];' 'web_masks[operand != BUSTER_TIER1_CFG_NONE && false ? webs[operand] : input->value_count] |= input->sequence_registers[k];' ./build/compiler test-tier1-cfg
run crossed-ignores-results src/buster/compiler/tier1_cfg.c 'web_masks[result != BUSTER_TIER1_CFG_NONE ? webs[result] : input->value_count] |= input->sequence_registers[k];' 'web_masks[result != BUSTER_TIER1_CFG_NONE && false ? webs[result] : input->value_count] |= input->sequence_registers[k];' ./build/compiler test-tier1-cfg
./build.sh > $C/mutant-build.log 2>&1; echo "restored build exit $?"
