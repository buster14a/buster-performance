from pathlib import Path
p=Path(__file__).resolve().parent/'lane-owners.c'
units=[]
for i in range(512):
 lines=['{',f'    int a=x+{i};', '    int v[]={a, a+1};', '    const int z=(const int){2};', '    return v[0]+v[1]+z;', '}']
 units.append(f'int f{i}(int x)\n'+'\n'.join(lines))
units.append('int main(void) { return (f0(2)!=7) || (f511(1)!=1027); }')
p.write_text('\n'.join(units)+'\n')
