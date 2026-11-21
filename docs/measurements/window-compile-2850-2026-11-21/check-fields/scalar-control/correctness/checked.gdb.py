import gdb,struct,hashlib,json
def val(expr):return int(gdb.parse_and_eval(expr))
def mem(addr,n):return memoryview(gdb.selected_inferior().read_memory(addr,n)).cast('B') if n else b''
def add(name,addr,n):
 data=mem(addr,n);out[name]=hashlib.sha256(data).hexdigest()
def col(name,owner,field,count):
 p=owner+'->'+field;addr=val(p)
 if addr: add(name,addr,count*val('sizeof(*('+p+'))'))
out={};n=val('$leaf_g->count');types=val('$leaf_t->types.count')
for k in ['ops','tokens','operand0','operand1','operand2','types','members','contexts','argument_offsets','argument_counts','leaf_slots']:
 col('graph.'+k,'$leaf_g',k,n)
for k in ['value_types','value_flags','value_objects','value_categories','value_constants','payload_rows','conversions','diagnostics','diagnostic_operands','member_offsets','warnings','warning_ignored','constant_evaluated']:
 col('stream.'+k,'$leaf_s',k,n)
for k in ['kind','code','flags','alignment_log2','base','index','extent','size','hash']:
 col('types.'+k,'$leaf_t','types.'+k,types)
args=val('$leaf_g->argument_count');col('graph.argument_nodes','$leaf_g','argument_nodes',args);col('stream.argument_conversions','$leaf_s','argument_conversions',args)
rows=val('$leaf_s->payload_count');sz=val('sizeof(*$leaf_s->payloads)');assert sz==96
b=bytearray(mem(val('$leaf_s->payloads'),rows*sz))
for off in range(0,len(b),sz):b[off+42:off+48]=b'\x00'*6;b[off+58:off+64]=b'\x00'*6
out['stream.payloads']=hashlib.sha256(b).hexdigest()
print('RECEIPT '+json.dumps(dict(nodes=n,types=types,payloads=rows,arguments=args,scalar=val('$leaf_s->statistics.scalar_nodes'),vector=val('$leaf_s->statistics.vector_nodes'),columns=out),sort_keys=True))
