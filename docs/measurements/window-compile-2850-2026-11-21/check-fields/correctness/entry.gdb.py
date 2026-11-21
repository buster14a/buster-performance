import gdb,struct,collections,json
def val(expr):return int(gdb.parse_and_eval(expr))
def get(expr,n):return memoryview(gdb.selected_inferior().read_memory(val(expr),n))
n=val('graph->count');l=val('graph->leaf_count');types=val('types->types.count')
ops=get('graph->ops',n*4).cast('I');rows=get('graph->leaf_records',l*32);kinds=get('types->types.kind',types).cast('B');rec=struct.Struct('<IIIIQIBBH')
s=0;t=collections.Counter()
for i in range(n):
 if ops[i]!=0:continue
 ty,flags,obj,over,integer,row,cat,kind,_=rec.unpack_from(rows,s*32);s+=1
 valid=0<ty>>3<types and kinds[ty>>3]!=0
 t['without_payload_record']+=row==0;t['integer_zero']+=integer==0;t['valid_at_entry']+=valid;t['overload']+=over!=0
 t['simple_in_full_blocks']+=valid and row==integer==over==0 and i<n-(n%16)
 t['simple_all']+=valid and row==integer==over==0
assert s==l
print('OBS '+json.dumps(dict(t,count=n,leaves=l,types_at_entry=types,fresh=val('stream->zero_columns'))))
