import os, re
S=os.path.dirname(os.path.abspath(__file__))
names=[l.split()[1] for l in open(S+'/names.txt')]
nameset=set(names)
zero_forms={'XOR_RM32_R32','XOR_R32_RM32','XOR_R64_RM64','XOR_RM64_R64','SUB_R32_RM32','SUB_R64_RM64','SUB_RM32_R32','SUB_RM64_R64','XORPS_X_XM128','PXOR_X_XM128','VPXORD_X_X_XM128','VXORPS_X_X_XM128'}
cases=set()
def kind(form,k):
    if k=='reg': return 'REGISTER'
    if k=='zero?': return 'ZERO' if form in zero_forms else 'REGISTER'
    if k in ('mem','mem-rip'): return 'MEMORY'
    if k=='mem-index': return 'MEMORY_INDEX'
    if k in ('lea-b','lea-b+d','lea-rip'): return 'LEA_BASE'
    if k=='lea-b+i': return 'LEA_INDEX'
    if re.fullmatch(r'lea-b\+i\*\d',k): return 'LEA_SCALED'
    return 'LEA_THREE'
for line in open(S+'/cases.tsv'):
    f,k,n,src=line.rstrip('\n').split('\t')
    cases.add((f,kind(f,k)))
for f in zero_forms: cases.add((f,'REGISTER')); cases.add((f,'ZERO'))
# the condition families: which conditions a program emits depends on the program
conds=['O','NO','B','AE','E','NE','BE','A','S','NS','P','NP','L','GE','LE','G']
for c in conds:
    for w in ('REL8','REL32'): cases.add(('J%s_%s'%(c,w),'REGISTER'))
    cases.add(('SET%s_RM8'%c,'REGISTER')); cases.add(('SET%s_RM8'%c,'MEMORY'))
    for w in ('32','64'):
        for k in ('REGISTER','MEMORY'): cases.add(('CMOV%s_R%s_RM%s'%(c,w,w),k))
# the earlier model's cases (2026-10-22), all measured again
old="""ADD_RM32_R32 ADD_RM64_R64 ADD_R32_RM32 ADD_R64_RM64 SUB_RM32_R32 SUB_RM64_R64 AND_RM32_R32 AND_RM64_R64 OR_RM32_R32 OR_RM64_R64 XOR_RM32_R32 XOR_RM64_R64
ADD_RM32_IMM8 ADD_RM64_IMM8 ADD_RM32_IMM32 ADD_RM64_IMM32 SUB_RM32_IMM8 SUB_RM64_IMM8 AND_RM32_IMM8 AND_RM64_IMM8 OR_RM32_IMM8 OR_RM64_IMM8 XOR_RM32_IMM8 XOR_RM64_IMM8
INC_RM32 INC_RM64 DEC_RM32 DEC_RM64 NEG_RM32 NEG_RM64 NOT_RM32 NOT_RM64 SHL_RM32_1 SHL_RM64_1 SHR_RM32_1 SHR_RM64_1 SAR_RM32_1 SAR_RM64_1
SHL_RM32_IMM8 SHL_RM64_IMM8 SHR_RM32_IMM8 SHR_RM64_IMM8 SAR_RM32_IMM8 SAR_RM64_IMM8 IMUL_R32_RM32 IMUL_R64_RM64 IMUL_R32_RM32_IMM8 IMUL_R64_RM64_IMM8
MOV_R32_IMM32 MOV_R64_IMM64""".split()
for f in old: cases.add((f,'REGISTER'))
for f in ('LEA_R32_M','LEA_R64_M'):
    for k in ('LEA_BASE','LEA_INDEX','LEA_SCALED','LEA_THREE'): cases.add((f,k))
cases.add(('MOV_R64_RM64','MEMORY'))
missing=[c for c in cases if c[0] not in nameset]
assert not missing, missing
order=['REGISTER','ZERO','MEMORY','MEMORY_INDEX','LEA_BASE','LEA_INDEX','LEA_SCALED','LEA_THREE']
rows=sorted(cases,key=lambda c:(names.index(c[0]),order.index(c[1])))
print(len(rows))
with open(S+'/rows.txt','w') as o:
    for f,k in rows: o.write('%s %s\n'%(f,k))
