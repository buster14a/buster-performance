from pathlib import Path
import sys
base=Path(sys.argv[1]);out=Path(sys.argv[2]);out.mkdir(parents=True,exist_ok=True)
s=(base/'c_preprocessor_impl.c').read_text()
start=s.index('static bool pp_collect_arguments(')
s=s[:start]+'''// Census only. A file-path attempt can be consumed once by an actual ordinary collection.
static struct {
    const uint8_t* kinds;
    uint32_t open,limit,parameters;
    bool variadic;
    PPScan answer;
    uint64_t file_scans,collector,collector_file,matched,matched_tokens,matched_separators,matched_none;
    uint64_t direct_ticks,repeat_ticks;
} scan_census;

'''+s[start:]
old='    pp_scan_arguments(kinds, open, limit, variadic, parameter_count, &scan);'
i=s.index(old,start)
s=s[:i]+'''    const bool matched=file && scan_census.kinds==kinds && scan_census.open==open
        && scan_census.limit==limit && scan_census.parameters==parameter_count && scan_census.variadic==variadic;
    scan_census.collector++;scan_census.collector_file+=file;
    uint64_t begin_scan=__rdtsc();
'''+s[i:]
i=s.index(old,start)+len(old)
s=s[:i]+'''
    if(matched) {
        scan_census.repeat_ticks+=__rdtsc()-begin_scan;
        scan_census.matched++;
        if (scan.close!=scan_census.answer.close || scan.separator_count!=scan_census.answer.separator_count ||
            memcmp(scan.separators,scan_census.answer.separators,scan.separator_count*sizeof(*scan.separators)))abort();
        scan_census.matched_none+=scan.close==BUSTER_PP_NONE;
        scan_census.matched_tokens+=scan.close==BUSTER_PP_NONE?0:scan.close-open+1;
        scan_census.matched_separators+=scan.separator_count;
    }
    scan_census.kinds=NULL;
'''+s[i:]
old='        pp_scan_arguments(data->kinds, open, limit, (macro->flags & BUSTER_PP_MACRO_VARIADIC) != 0, macro->parameter_count, &scan);'
i=s.index(old);s=s[:i]+'''        uint64_t begin_scan=__rdtsc();
'''+s[i:]
i=s.index(old)+len(old)
s=s[:i]+'''
        scan_census.direct_ticks+=__rdtsc()-begin_scan;
        scan_census.file_scans++;
        scan_census.kinds=data->kinds;scan_census.open=open;scan_census.limit=limit;
        scan_census.parameters=macro->parameter_count;scan_census.variadic=(macro->flags&BUSTER_PP_MACRO_VARIADIC)!=0;
        scan_census.answer.close=scan.close;scan_census.answer.separator_count=scan.separator_count;
        memcpy(scan_census.answer.separators,scan.separators,scan.separator_count*sizeof(*scan.separators));
'''+s[i:]
(out/'c_preprocessor_impl.c').write_text(s)
(out/'c_preprocessor.c').write_text((base/'c_preprocessor.c').read_text().replace('"buster/compiler/c_preprocessor_impl.c"','"c_preprocessor_impl.c"'))
