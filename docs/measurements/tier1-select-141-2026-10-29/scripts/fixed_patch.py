import sys
p = sys.argv[1]
t = open(p).read()
old = """        printf("synthetic IR; complete = plan + liveness + required locations + allocation + frame + fragments + branch sizing + encode; TSC ticks are not core cycles\\n");"""
new = """        const char* fixed = getenv("TIER1_FIXED");
        if (fixed != 0)
        {
            unsigned fixed_shape = 0, fixed_phase = 0, fixed_path = 0, fixed_repetitions = 0;
            sscanf(fixed, "%u,%u,%u,%u", &fixed_shape, &fixed_phase, &fixed_path, &fixed_repetitions);
            bench.instruction_count = 0;
            valid = valid && tier1_select_bench_corpus(&bench, &input, steps, fixed_shape);
            for (unsigned r = 0; valid && r < fixed_repetitions; r += 1)
            {
                valid = tier1_select_bench_run(&bench, fixed_path != 0, fixed_phase != 0, false);
            }
            printf("fixed %u,%u,%u,%u IR %llu valid %d\\n", fixed_shape, fixed_phase, fixed_path, fixed_repetitions, (unsigned long long)bench.instruction_count, valid);
            exit(valid ? 0 : 1);
        }
        printf("synthetic IR; complete = plan + liveness + required locations + allocation + frame + fragments + branch sizing + encode; TSC ticks are not core cycles\\n");"""
assert t.count(old) == 1
open(p, "w").write(t.replace(old, new))
