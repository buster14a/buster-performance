#!/usr/bin/env python3
# usage: probe_recorded.py SOURCE_ROOT: patch src/buster/compiler/c_checker.c in place so that, with BUSTER_PROBE_RECORDED
# set, check_graph_run validates every graph as CheckOptions.verify does and compares the reader's recorded purity and
# counters with the validation's (check_graph_recorded_equal), printing "probe-recorded: nodes=N equal=0|1" to standard
# error. A mismatch fails the compile. (#1671: the flush's vector recording against an independent validation.)
import sys, pathlib
path = pathlib.Path(sys.argv[1]) / "src/buster/compiler/c_checker.c"
s = path.read_text()
a = """        if (recorded && !options->verify)"""
b = """        if (recorded && !options->verify && getenv("BUSTER_PROBE_RECORDED") == NULL)"""
assert s.count(a) == 1; s = s.replace(a, b)
a2 = """            if (result && recorded)
            {
                result = check_graph_recorded_equal(graph, &validation, pure, &stream->failed_node);
            }"""
b2 = """            if (result && recorded)
            {
                result = check_graph_recorded_equal(graph, &validation, pure, &stream->failed_node);
                if (getenv("BUSTER_PROBE_RECORDED") != NULL)
                {
                    fprintf(stderr, "probe-recorded: nodes=%u equal=%d\\n", count, (int)result);
                }
            }"""
assert s.count(a2) == 1; s = s.replace(a2, b2)
path.write_text(s)
print("patched", path)
