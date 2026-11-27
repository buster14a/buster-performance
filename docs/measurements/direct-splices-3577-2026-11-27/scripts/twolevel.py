import sys
s=open(sys.argv[1]).read()
def rep(old,new):
    global s
    assert old in s, old[:80]
    s=s.replace(old,new,1)
rep('''        const __mmask64 nl = _mm512_cmpeq_epi8_mask(v, v_nl);''','''        nl = _mm512_cmpeq_epi8_mask(v, v_nl);''')
rep('''        const __mmask64 first = (starts | lead_sum) & ~blank;''','''        first = (starts | lead_sum) & ~blank;''')
rep('''        const __mmask64 tainted = passes & ~taint_sum;''','''        tainted = passes & ~taint_sum;''')
rep('''        const __mmask64 directives = hash & first;''','''        directives = hash & first;''')
rep('''        __mmask64 ucns = 0;\n''','''        ucns = 0;\n''')
rep('''        __mmask64 raws = 0;\n''','''        raws = 0;\n''')
rep('''        const __mmask64 events = (directives | opens | raws | ucns) & valid;''','''        events = (directives | opens | raws | ucns) & valid;''')
rep('''            r_in = r_out;
            p += avail;
        }
        else
        {''','''            r_in = r_out;
            p += avail;
        }
        }
        if (events != 0)
        {''')
rep('''    while (p < end && !done)
    {
        uint32_t avail = 0;''','''    while (p < end && !done)
    {
        __mmask64 events = 0;
        __mmask64 nl = 0;
        __mmask64 first = 0;
        __mmask64 tainted = 0;
        __mmask64 directives = 0;
        __mmask64 ucns = 0;
        __mmask64 raws = 0;
        while (events == 0 && p < end)
        {
        uint32_t avail = 0;''')
open(sys.argv[2],'w').write(s)
