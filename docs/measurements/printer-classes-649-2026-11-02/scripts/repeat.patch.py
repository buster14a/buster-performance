# Applies the local repeat harness (not for the branch) to a tree's c_preprocessor_benchmark.c.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_preprocessor_benchmark.c'
s = open(p).read()
old = """        sample->print_nanoseconds += pp_benchmark_nanoseconds() - printing;
"""
new = """        sample->print_nanoseconds += pp_benchmark_nanoseconds() - printing;
        {
            static int repeat = -1;
            if (repeat < 0)
            {
                const char* text = getenv("BUSTER_PP_PRINT_REPEAT");
                repeat = text != 0 ? atoi(text) : 0;
            }
            for (int n = 0; result && n < repeat; n += 1)
            {
                const uint64_t t = pp_benchmark_nanoseconds();
                const uint64_t cy = pp_benchmark_read_counter(cycles_fd);
                const uint64_t in = pp_benchmark_read_counter(instructions_fd);
                result = pp_print(&pp, null_stream, markers);
                const uint64_t in2 = pp_benchmark_read_counter(instructions_fd);
                const uint64_t cy2 = pp_benchmark_read_counter(cycles_fd);
                fprintf(stderr, "repeat %.3f ms %.2f cycles/token %.2f instructions/token\\n", (pp_benchmark_nanoseconds() - t) / 1e6,
                        (double)(cy2 - cy) / pp.output.count, (double)(in2 - in) / pp.output.count);
            }
        }
"""
assert s.count(old) == 1
s = s.replace(old, new)
open(p, 'w').write(s)
