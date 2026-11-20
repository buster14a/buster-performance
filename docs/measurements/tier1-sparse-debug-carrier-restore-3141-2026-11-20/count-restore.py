from pathlib import Path
w=Path(__file__).resolve().parents[1];f='src/buster/compiler/c_check_tier1_debug_values.c'
s=(w/'debug-carriers'/f).read_text()
mark='static void check_tier1_debug_value_start('
s=s.replace(mark,'''static uint64_t restore_metrics[2][8];
static bool restore_publish;
static void check_print_restore_metrics(void)
{
    for (uint32_t p=0; p<2; ++p)
    {
        fprintf(stderr, "restore\\t%u", p);
        for (uint32_t i=0;i<8;++i) fprintf(stderr, "\\t%llu",(unsigned long long)restore_metrics[p][i]);
        fprintf(stderr, "\\n");
    }
}

'''+mark)
s=s.replace('    *live = proof->live;', '''    restore_publish = publish;
    *live = proof->live;''')
mark='    for (uint32_t f = 0; f < count; f += 1)\n    {\n        const uint32_t place = facts[f].place;'
assert s.count(mark)==1
s=s.replace(mark,'''    uint64_t* totals = restore_metrics[restore_publish];
    totals[0]++; totals[1] += live->known_count; totals[2] += count;
'''+mark+'''
        const uint32_t old = proof->state[place];
        totals[3] += old == facts[f].value;
        totals[4] += old != BUSTER_IR_NONE && old != facts[f].value;
        totals[5] += old == BUSTER_IR_NONE;''')
s=s.replace('            const uint32_t displaced = live->known[f];','            totals[6]++;\n            const uint32_t displaced = live->known[f];')
s=s.replace('    while (live->known_count > count)','    totals[7] += live->known_count - count;\n    while (live->known_count > count)')
marker='    return valid;'; i=s.rindex(marker); s=s[:i]+'    check_print_restore_metrics();\n    memset(restore_metrics, 0, sizeof(restore_metrics));\n'+s[i:]
(w/'carrier-count'/f).write_text(s)
