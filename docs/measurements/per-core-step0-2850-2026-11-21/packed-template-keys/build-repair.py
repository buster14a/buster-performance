from pathlib import Path
d=Path(__file__).resolve().parent
s=(d/'tools/single.c').read_text()
a=s.index('// Split X only at roots');b=s.index('// The second path over the whole unit',a)
s=s[:a]+'''// Restore distant expressions from their parsed edges and learned rules before X.
static void lanes_repair_far(Lanes* lanes, Unit* unit, uint32_t end_root){
    while(lanes->far_roots[lanes->far_next]<end_root){
        uint32_t r=lanes->far_roots[lanes->far_next++];
        uint32_t lo=unit->root_first[r], hi=unit->roots[r]+1;
        Work* work=lanes->far_work; const Tables* tables=lanes->far_tables;
        if(lanes->keep){
            memset(unit->facts+lo,0xa5,(hi-lo)*sizeof(*unit->facts));
            memset(unit->code+lo,0xa5,(hi-lo)*sizeof(*unit->code));
            memset(unit->context+lo,0xa5,hi-lo);
            memset(unit->target+lo,0xa5,(hi-lo)*sizeof(*unit->target));
            memset(work->missed+lo,0xa5,hi-lo);
        }
        types_range(unit,tables,work,lo,hi);
        contexts_range(unit,tables,work,lo,hi);
        for(uint32_t g=lo;g<hi;++g){
            lanes->marks[g]=(uint8_t)((lanes->marks[g]&LANES_MARK_ROOT)|(work->missed[g]?LANES_MARK_REFUSED:0));
            uint8_t facts[8]; memcpy(facts,unit->facts+g,8);
            facts[0]=lanes_dense_class(facts[0]);
            for(unsigned k=0;k<LANES_FACTS;++k) lanes->facts[k][g]=facts[k];
            lanes->typed[g]=0xff;
            lanes->context[g]=unit->context[g];
            lanes->context_dense[g]=lanes->dense_of_context[unit->context[g]];
            lanes->target_class[g]=lanes_dense_class((uint8_t)unit->target[g]);
            lanes->target_facts[g]=(uint8_t)(unit->target[g]>>8);
            lanes->store[g]=store_of(unit,unit->facts,g);
            uint8_t types[4]={0};
            if(unit->op[g]!=OP_VALUE){
                uint32_t bits=operand_types_of(unit,unit->facts,g);
                memcpy(types,&bits,4); types[0]=lanes_dense_class(types[0]); types[2]=lanes_dense_class(types[2]);
            }
            for(unsigned k=0;k<4;++k) lanes->types[k][g]=types[k];
        }
    }
}

'''+s[b:]
s=s.replace('            lanes_keys(lanes, first_block, end_block);','            if (__builtin_expect(lanes->far_roots[lanes->far_next]<end_root,0)) lanes_repair_far(lanes,unit,end_root);\n            lanes_keys(lanes, first_block, end_block);')
s=s.replace('out = lanes_expand_with_far(', 'out = lanes_expand(')
s=s.replace('lanes_run_records(const Lanes* lanes, uint32_t', 'lanes_run_records(const Lanes* lanes, const Unit* unit, uint32_t')
s=s.replace('lanes_run_records(lanes, record,','lanes_run_records(lanes, unit, record,')
a=s.index('    before[2] = distance1');b=s.index('\n}',a)
s=s[:b]+'''
    if (__builtin_expect((lanes->layout[record]&LANES_LAYOUT_FAR)!=0,0)){
        before[1]=unit->child0[record]!=unit->zero ? unit->child0[record]+1 : record;
        before[2]=unit->child1[record]!=unit->zero ? unit->child1[record]+1 : before[1];
    }'''+s[b:]
(d/'tools/repair.c').write_text(s)
s=s.replace('            lanes->marks[g]=(uint8_t)', '''            const uint8_t old_marks=lanes->marks[g];
            lanes->marks[g]=(uint8_t)''').replace('            uint8_t facts[8];','            if ((old_marks&LANES_MARK_LAYOUT)==0) continue;\n            uint8_t facts[8];')
(d/'tools/sparserepair.c').write_text(s)
