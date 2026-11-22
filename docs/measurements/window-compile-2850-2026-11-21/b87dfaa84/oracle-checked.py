from pathlib import Path
p=Path(__file__).resolve().parent.parent/'member-chain-lowering-proof/src/buster/compiler/c_checker.c';s=p.read_text()
needle='    arena_pop_to(scratch, scratch_start);\n    return result;\n}\n#endif\n#endif'
assert needle in s
s=s.replace(needle,'''    const char* capture = getenv("BUSTER_CHAIN_CHECKED_FILE");
    if (capture && result && graph->count)
    {
        FILE* o=fopen(capture,"ab");
        if(o==NULL || fwrite(&graph->count,4,1,o)!=1)abort();
        for(uint32_t n=0;n<graph->count;n+=1)
        {
            const CheckValue v=check_stream_value(stream,n);
            const uint32_t ar=graph->argument_counts!=NULL && check_graph_has_arguments(graph->ops[n])?graph->argument_counts[n]:0;
            const uint32_t meta[]={graph->ops[n],graph->tokens[n],graph->operand0[n],graph->operand1[n],graph->operand2[n],ar,
                v.type,v.category,v.flags,v.constant_kind,v.object,v.overload_head,v.bit_width,v.fault,
                v.fault_node<graph->count && v.fault!=CHECK_FAULT_NONE?graph->tokens[v.fault_node]:v.fault_node,
                v.object_bit_offset,stream->diagnostics[n],stream->diagnostic_operands[n],stream->warnings[n],
                stream->conversions[n].operands[0].type,stream->conversions[n].operands[0].flags,
                stream->conversions[n].operands[1].type,stream->conversions[n].operands[1].flags,
                stream->conversions[n].operands[2].type,stream->conversions[n].operands[2].flags,
                stream->conversions[n].store.type,stream->conversions[n].store.flags};
            const uint64_t payload[]={(uint64_t)v.integer,(uint64_t)(v.integer>>64),v.floating_storage[0],v.floating_storage[1]&65535,
                                      v.imaginary_storage[0],v.imaginary_storage[1]&65535,(uint64_t)v.offset,stream->member_offsets[n]};
            fwrite(meta,sizeof(meta),1,o);fwrite(payload,sizeof(payload),1,o);
            for(uint32_t i=0;i<ar;i+=1)
            {
                uint32_t e=graph->argument_offsets[n]+i;
                // Builtins with fixed entries, e.g. va_arg, store their descriptor rather than a slice of argument_nodes.
                uint32_t arg[3]={BUSTER_CHECK_NONE,0,0};
                if(e<graph->argument_count && graph->argument_nodes!=NULL && stream->argument_conversions!=NULL)
                {
                    arg[0]=graph->argument_nodes[e];arg[1]=stream->argument_conversions[e].type;arg[2]=stream->argument_conversions[e].flags;
                }
                fwrite(arg,sizeof(arg),1,o);
            }
        }
        fclose(o);
    }
'''+needle);p.write_text(s)
