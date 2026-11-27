from pathlib import Path
p=Path('src/buster/compiler/ir_optimize_gvn.c');s=p.read_text();a=s.index('static __attribute__((unused)) IrCheck ir_optimize_gvn(');s=s[:a]+s[a:].replace('    const uint64_t output_mark', '''    const char* gvn_path = getenv("BUSTER_EXPERIMENT_GVN_PATH");
    const bool measure_gvn = gvn_path != NULL;
    if (measure_gvn) options.scalar = gvn_path[0] == 's';
    const uint64_t gvn_start = measure_gvn ? __rdtsc() : 0;
    const uint64_t output_mark''',1).replace('    return check;','''    if (measure_gvn)
    {
        const uint64_t elapsed = __rdtsc() - gvn_start;
        fprintf(stderr, "gvn-ticks %u %u %u %u %u %u %lu\\n", function->instruction_count, function->block_count, (unsigned)options.vectors, (unsigned)options.pressure, (unsigned)check.error, check.error == IR_OK ? result->removed : 0, elapsed);
    }
    return check;''',1); p.write_text(s)
