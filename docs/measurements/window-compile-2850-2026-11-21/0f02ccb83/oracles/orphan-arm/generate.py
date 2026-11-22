"""Keep the opening #if in the first primary fragment and its skipped #else in the final one."""
from pathlib import Path
import sys
p = Path(sys.argv[1])
start = b"#if 1\nint active;\n"
tail = b"\n#else\n#error wrong arm\n#endif\nint after;\n"
p.write_bytes(start + b" " * ((1 << 20) - len(start) - len(tail)) + tail)
