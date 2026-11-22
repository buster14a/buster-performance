"""Use each native compiler's clang ABI to collect its ordinary checker output just after check_graph_run."""
import json, re, shlex, subprocess, sys
from pathlib import Path
d=Path(__file__).resolve().parent; w=d.parent
schema={
 'graph':('CheckGraph',{'count': ('scalar','count leaf_count leaf_payload_count argument_count vector_member_count overload_candidate_count fp_contract_default'), 'nodes':('array','ops tokens operand0 operand1 operand2 types members contexts argument_offsets argument_counts leaf_slots fp_environments warning_suppressed source_positions'), 'args':('array','argument_nodes argument_tokens'), 'leaves':('array','leaf_records'), 'leafpayload':('array','leaf_payloads')}),
 'types':('TypeColumns',{'count':('scalar','count'),'types':('array','kind code flags alignment_log2 base index extent size hash')}),
 'stream':('CheckStream',{'count':('scalar','count report_count effect_count varargs_count misc_count floating_count query_count atomic_count vector_count x86_count bit_cast_count overload_count overload_address_count status failed_node payload_count warning_count warnings_prepared enum_operands'), 'nodes':('array','value_types value_flags value_objects value_categories value_constants payload_rows conversions diagnostics diagnostic_operands member_offsets warnings warning_ignored constant_evaluated'), 'args':('array','argument_conversions'),'payloads':('array','payloads')}),
 'stats':('CheckStatistics',{'count':('scalar','nodes levels batches scalar_nodes vector_nodes query_proof_nodes query_replay_nodes output_bytes scratch_bytes')}),
}
for name,tree in [('base','main-fbef-clean'),('candidate','struct-member-facts')]:
 src=w/tree
 unit=next(x for x in json.loads((src/'build/compile_commands.json').read_text()) if x['file'].endswith('main_unit_checker.c'))
 args=shlex.split(unit['command']);args=args[:args.index('-Xclang')];args=[a for a in args if not a.startswith('-DCMAKE_INTDIR')]
 fields={};qs={}
 def take(expr):
    qs.setdefault(expr,'FieldOracle'+str(len(qs)))
    return expr
 for group,(typ,items) in schema.items():
    for num,(kind,cols) in items.items():
        for f in cols.split():
            fields[group+'.'+f]=[group,num,kind,take(f'__builtin_offsetof({typ},{f})'),take(f'sizeof('+('*' if kind=='array' else '')+f'(({typ}*)0)->{f})')]
 for label,expr in [('type_offset','__builtin_offsetof(TypeTable,types)'),('stats_offset','__builtin_offsetof(CheckStream,statistics)')]:
    fields[label]=take(expr)
 lay=d/(name+'-abi.c')
 lay.write_text('#include '+json.dumps(unit['file'])+'\n'+'\n'.join(f'struct {tag} {{char size[1+({expr})];}}; _Static_assert(sizeof(struct {tag})>0,"");' for expr,tag in qs.items()))
 text=subprocess.check_output([*args,'-Xclang','-fdump-record-layouts','-fsyntax-only',str(lay)],cwd=unit['directory'],stderr=subprocess.PIPE,text=True)
 vals={tag:int(size)-1 for tag,size in re.findall(r'\| struct (FieldOracle\d+)\n.*?\[sizeof=(\d+)',text,re.S)}
 spec={k:([*v[:3],*[vals[qs[l]] for l in v[3:]]] if isinstance(v,list) else vals[qs[v]]) for k,v in fields.items()}
 (d/(name+'-abi.json')).write_text(json.dumps(spec,sort_keys=True,indent=2)+'\n')
 script='''set debuginfod enabled off
set confirm off
set pagination off
python
import gdb, json, hashlib
schema=SCHEMA
def data(addr,n):
    return gdb.selected_inferior().read_memory(addr,n).tobytes() if n else b''
def get(addr,n): return int.from_bytes(data(addr,n),'little')
def word(r): return int(gdb.parse_and_eval('$'+r))
class Finished(gdb.FinishBreakpoint):
    def __init__(self,g,s,t):
        super().__init__(gdb.newest_frame(),internal=True)
        self.holders={'graph':g,'stream':s,'types':t+schema['type_offset'],'stats':s+schema['stats_offset']}
    def stop(self):
        result={}
        groups={}
        for label,item in schema.items():
            if not isinstance(item,list):continue
            group,size,kind,offs,width=item
            if kind=='scalar': result[label]=get(self.holders[group]+offs,width)
        groups.update(nodes=result['graph.count'],args=result['graph.argument_count'],leaves=result['graph.leaf_count'],leafpayload=result['graph.leaf_payload_count'],types=result['types.count'],payloads=result['stream.payload_count'])
        assert (groups['nodes']==result['stream.count'] and groups['nodes']>0),(groups,result)
        for label,item in schema.items():
            if not isinstance(item,list):continue
            group,size,kind,offs,width=item
            if kind!='array': continue
            addr=get(self.holders[group]+offs,8)
            if addr==0:
                result[label]=None
                continue
            n=groups[size]
            blob=data(addr,n*width)
            if size in ('leafpayload','payloads'):
                assert width==96
                blob=bytearray(blob)
                for off in range(0,len(blob),width):
                    blob[off+42:off+48]=bytes(6)
                    blob[off+58:off+64]=bytes(6)
            result[label]=hashlib.sha256(blob).hexdigest()
        print('RECEIPT '+json.dumps(result,sort_keys=True))
        return False
class Start(gdb.Breakpoint):
    def stop(self):
        Finished(word('rsi'),word('r9'),word('rdi'))
        return False
Start('*check_graph_run')
HITPROBE
end
run
'''
 hit = """class Hits(gdb.Breakpoint):
    def stop(self):
        self.total += 1
        return False
hits=Hits('c_checker.c:3367',internal=True)
hits.total=0
def report_hits(event): print('MEMBER_HITS '+str(hits.total))
gdb.events.exited.connect(report_hits)
""" if name == 'candidate' else ''
 (d/(name+'-columns.gdb')).write_text(script.replace('SCHEMA',repr(spec)).replace('HITPROBE', hit))
assert (d/'base-abi.json').read_bytes()==(d/'candidate-abi.json').read_bytes()
