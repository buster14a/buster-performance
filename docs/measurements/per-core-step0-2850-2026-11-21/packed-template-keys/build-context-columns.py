from pathlib import Path
d=Path(__file__).resolve().parent;s=(d/'tools/dynamic.c').read_text()
a='            _mm512_mask_storeu_epi8(lanes->context + base, taken, _mm512_permutexvar_epi8(dense, context_of_dense));'
s=s.replace(a,'')
s=s.replace('const bool context_differs = lanes.context[g] != unit.context_truth[g]', 'const bool context_differs = lanes.context_of_dense[lanes.context_dense[g]] != unit.context_truth[g]')
s=s.replace('v[0] = _mm512_load_si512(lanes->context + base);','v[0] = _mm512_permutexvar_epi8(_mm512_load_si512(lanes->context_dense+base),_mm512_load_si512(lanes->context_of_dense));')
(d/'tools/contextcolumn.c').write_text(s)
s=s.replace('key[0] = unit->context_truth[g];','key[0] = lanes->dense_of_context[unit->context_truth[g]];').replace('v[0] = _mm512_permutexvar_epi8(_mm512_load_si512(lanes->context_dense+base),_mm512_load_si512(lanes->context_of_dense));','v[0] = _mm512_load_si512(lanes->context_dense+base);')
for field,value in [('context_dense','dense'),('target_class','values[1]'),('target_facts','values[2]')]:
 s=s.replace(f'_mm512_mask_storeu_epi8(lanes->{field} + base, taken, {value});', f'_mm512_store_si512(lanes->{field} + base,{value});')
(d/'tools/contextindex.c').write_text(s)
