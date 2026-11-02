import re,sys
recs=[r for r in open('pgo.proftext').read().split('\n\n') if r.strip()]
def name(r): return r.strip().split('\n',1)[0].split(':')[-1]
A=re.compile(r'^(check_input_|check_literal_|c_bindings_|check_constant_)')
B=re.compile(r'^(check_graph_|check_action_|check_stream_|check_control_|check_region_|check_overload_|check_query_)')
Cc=re.compile(r'^check_')
groups={'pa':[], 'pb':[], 'pc':[], 'pd':[]}
for r in recs:
    n=name(r)
    g='pa' if A.match(n) else 'pb' if B.match(n) else 'pc' if Cc.match(n) else 'pd'
    groups[g].append(r)
for g,rs in groups.items():
    open(f'{g}.proftext','w').write('\n\n'.join(x.strip('\n') for x in rs)+'\n')
    print(g,len(rs))
