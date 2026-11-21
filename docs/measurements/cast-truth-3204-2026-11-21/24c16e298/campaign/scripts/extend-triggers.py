"""Run the archived trigger campaign plus the expression that exercises ID 72 on Linux."""
from pathlib import Path
import sys

original = Path(sys.argv.pop(1))
program = Path(__file__).with_name('availability.c').read_text()
source = original.read_text()
anchor = '\nSETS = '
assert source.count(anchor) == 1
row = (72, 'AVAILABILITY', [], '-Wavailability', program)
source = source.replace(anchor, f'\nTRIGGERS.append({row!r})\n' + anchor)
exec(compile(source, str(original), 'exec'), {'__name__': '__main__', '__file__': str(original)})
