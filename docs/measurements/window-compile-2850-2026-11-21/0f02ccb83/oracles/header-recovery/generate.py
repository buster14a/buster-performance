"""Generate the minimum eligible one-MiB primary for the fragment-local header recovery case."""
from pathlib import Path
import sys

out = Path(sys.argv[1])
(out / "hdr").mkdir(parents=True, exist_ok=True)
(out / "hdr" / "*bar.h").write_text("#define EXPORT 8\n")
padding_line = b"/*0123456789abcdef*/\n"
def pad_through(source, size):
    return source + padding_line * max(0, (size - len(source) + len(padding_line) - 1) // len(padding_line))
source = b"#define A 1\n#define B 2\nint sentinel;\n"
source = pad_through(source, 65536) + b"#define BOUNDARY 1\n"
source = pad_through(source, len(source) + 65536)
source += b"#include <hdr/*bar.h>\nint value=EXPORT;\n"
source = pad_through(source, (1 << 20) - len(padding_line))
source += b" " * ((1 << 20) - len(source))
(out / "case.c").write_bytes(source)
