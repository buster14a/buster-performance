import sys
base=open('/tmp/claude-0/variants/cbase.c').read()
def rep(s,old,new):
    assert old in s, old[:100]
    return s.replace(old,new,1)
OLD='''                        nested_else |= level & (UINT64_C(0) - (uint64_t)(kw == FPP_KW_ELSE));
                    }
                }
            }
            // A splice's event'''
def tail(cond):
    return '''                        nested_else |= level & (UINT64_C(0) - (uint64_t)(kw == FPP_KW_ELSE));
                    }
                }
                else if (__builtin_expect(%s, 0))
                {
                    fast_check_commented_directive(pp, next, end);
                }
            }
            // A splice's event''' % cond
name=sys.argv[1]
s=base
if name=='F1':
    s=rep(s,OLD,tail("next + 1 < end && next[0] == '/' && next[1] == '*'"))
elif name=='F1b':
    s=rep(s,OLD,tail("next < end && *next == '/'"))
elif name=='F2':
    s=rep(s,"""                if (next < end && (fast_char_class[*next] & 2u) != 0)
                {
                    const uint32_t len = fast_scan_ident_len(next, end);
                    uint8_t kw = 0;""","""                if (next < end && (fast_char_class[*next] & 18u) != 0)
                {
                    const uint32_t len = fast_scan_ident_len(next, end);
                    if (__builtin_expect(len == 0, 0))
                    {
                        fast_check_commented_directive(pp, next, end);
                    }
                    uint8_t kw = 0;""")
    s=rep(s,"""['\\t'] = 8, ['\\v'] = 8, ['\\f'] = 8, ['\\r'] = 8, [' '] = 8,""","""['\\t'] = 8, ['\\v'] = 8, ['\\f'] = 8, ['\\r'] = 8, [' '] = 8, ['/'] = 16,""")
open('/tmp/claude-0/variants/'+name+'.c','w').write(s)
