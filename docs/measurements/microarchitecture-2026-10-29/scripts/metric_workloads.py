"""The frozen #875 SQLite workloads, shared by the campaign and its controls.

The commands, options and corpus identities are the original capture's. A
control that times or counts a different workload cannot qualify the metric
records, so both entry points build their commands here.
"""
from pathlib import Path
import shlex


def workload_commands(compiler, corpus, object_file):
    compiler = str(Path(compiler).resolve())
    corpus = Path(corpus).resolve()
    base = ['--predefines', str(corpus / 'provenance/gnu17-pinned-predefines.txt'),
            '--clang-features', '-march=znver5', '-std=gnu17', '-nostdinc',
            '-isystem', str(corpus / 'headers/usr/lib/clang/23/include'),
            '-isystem', str(corpus / 'headers/usr/local/include'),
            '-isystem', str(corpus / 'headers/usr/include'), '-I' + str(corpus / 'sqlite')]
    source = str(corpus / 'sqlite/sqlite3.c')
    return {
        'preprocess': [compiler, '-E', '-P', *base, '-o', '/dev/null', source],
        'syntax': [compiler, '-fsyntax-only', *base, source],
        'compile': [compiler, '-c', *base, '-o', str(object_file), source],
    }


def describe_workloads(commands, compiler, corpus, scratch):
    return {name: shlex.join(argv).replace(str(Path(compiler).resolve()), '<COMPILER>')
            .replace(str(Path(corpus).resolve()), '<CORPUS>')
            .replace(str(Path(scratch).resolve()), '<SCRATCH>')
            for name, argv in commands.items()}
