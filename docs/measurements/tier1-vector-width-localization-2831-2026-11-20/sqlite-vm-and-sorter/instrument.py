from pathlib import Path
d=Path(__file__).resolve().parent;w=d.parents[1];p=w/'width-profile/src/buster/compiler/c_check_tier1.c';s=p.read_text()
at='            wide.function = outcome.stage == CHECK_TIER1_COMPILED && check.error == IR_OK ? moved.function : wide.function;'
new='''            if (getenv("BUSTER_2831_DUMP") && width_id == 1193 && moved.moved && check.error == IR_OK) {
                const IrFunction* views[2] = { &wide.function, &moved.function };
                for (unsigned side = 0; side < 2; ++side) {
                    const IrFunction* f = views[side];
                    for (unsigned b=0; b<f->block_count; ++b) for (unsigned i=f->block_offsets[b]; i<f->block_offsets[b+1]; ++i)
                        if (ir_vector_type(f->type[i]) || ir_mask_type(f->type[i]))
                            fprintf(stderr, "VMV\\t%u\\t%u\\t%u\\t%u\\t%s\\t%s\\t%u\\t%u\\t%u\\n",width_summary,side,b,i,ir_op_names[f->op[i]],ir_type_names[f->type[i]],f->a[i],f->b[i],f->c[i]);
                }
            }
            const bool keep = width_id == 1193 && getenv("BUSTER_2831_KEEP_VM_ORDER") != NULL;
            wide.function = outcome.stage == CHECK_TIER1_COMPILED && check.error == IR_OK && !keep ? moved.function : wide.function;'''
assert s.count(at)==1;s=s.replace(at,new)
at='        wide.function = stage == CHECK_TIER1_COMPILED && vectorized.changed ? vectorized.function : wide.function;'
new='''        if (getenv("BUSTER_2831_DUMP") && width_id == 1244 && vectorized.changed) {
            fprintf(stderr, "SORTER_IR_BEGIN %u\\n",width_summary);
            ir_print(&wide.function,scratch,stderr);
            fprintf(stderr, "SORTER_IR_AFTER %u\\n",width_summary);
            ir_print(&vectorized.function,scratch,stderr);
            fprintf(stderr, "SORTER_IR_END %u\\n",width_summary);
        }
'''+at
assert s.count(at)==1;s=s.replace(at,new)
at='        *counts = (CheckTier1Counts){';pos=s.index(at,s.index('Tier1EmitResult emitted ='));s=s[:pos]+'''        if (getenv("BUSTER_2831_DUMP") && width_id==1193)
            fprintf(stderr, "VM_EMIT\\t%u\\t%u\\t%u\\t%u\\t%u\\t%u\\t%u\\t%u\\t%u\\n",width_summary,selected->count,emitted.spill_stores,emitted.spill_loads,emitted.call_stores,emitted.call_loads,emitted.rematerializations,emitted.edge_moves,emitted.frame.maximum_stack_bytes);
'''+s[pos:]
p.write_text(s)
