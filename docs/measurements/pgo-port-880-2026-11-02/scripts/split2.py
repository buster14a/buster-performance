import re
recs=[r for r in open('pgo.proftext').read().split('\n\n') if r.strip()]
def name(r): return r.strip().split('\n',1)[0].split(':')[-1]
groups=[
 ('pa1', lambda n: n=='check_input_resolve_range'),
 ('pa2', lambda n: n in ('check_input_resolve_tests','check_input_resolve_next','check_input_scan_all','check_input_scan_nonzero_from')),
 ('pa3', lambda n: n.startswith('check_input_attribute')),
 ('pa4', lambda n: n.startswith(('check_input_specifier','check_input_declarator','check_input_declaration'))),
 ('pa5', lambda n: re.match(r'^(check_input_|check_literal_|c_bindings_|check_constant_)',n) is not None),
 ('pb1', lambda n: n in ('check_graph_has_arguments','check_graph_add','check_graph_pure','check_graph_reorderable','check_graph_record_nodes')),
 ('pb2', lambda n: n.startswith('check_control_')),
 ('pb3', lambda n: re.match(r'^(check_graph_|check_action_|check_stream_|check_region_|check_overload_|check_query_)',n) is not None),
]
out={g:[] for g,_ in groups}
for r in recs:
    n=name(r)
    for g,f in groups:
        if f(n): out[g].append(r); break
for g,rs in out.items():
    open(f'{g}.proftext','w').write('\n\n'.join(x.strip('\n') for x in rs)+'\n'); print(g,len(rs))
