from pathlib import Path
import struct, subprocess, sys, tempfile
root=Path(sys.argv[1]).resolve()
records=Path(sys.argv[2]).resolve()
suites={'constant-expressions':190,'enum-sources':41,'vla-sources':51,'const-objects':63,'stdc-bit-builtins':10,'bit-builtins':30,'typeof-compound':20,'function-name-semantics':10,'integer-extension-sources':13,'context-selections':8,'atomic-vector-constraints':2}
def score(data):
    global raw,offset
    raw,offset=data,0
def word():
    global offset
    value=struct.unpack_from('<I',raw,offset)[0];offset+=4
    return value
def field():
    global offset
    length=word();end=offset+length
    assert end<=len(raw)
    row=raw[offset:end];offset=end
    return row
def table(d):
    lines=(d/'catalog.tsv').read_text().splitlines()
    assert lines[0]=='buster-fixtures v1 checker-sources'
    return [row.split('\t') for row in lines[1:] if not row.startswith('#')]
def dump(f,folder):
    binary=Path(folder)/'dump'
    subprocess.run(['clang',str(records/f),'-std=gnu17','-o',str(binary)],check=True)
    return subprocess.check_output([str(binary)])
total=ordinary=bound=nbytes=0
with tempfile.TemporaryDirectory() as scratch:
    score(dump('private.c',scratch))
    for suite,count in suites.items():
        d=root/'tests/checker'/suite
        rows=table(d);assert len(rows)==count
        for i,(identifier,source,flags,label) in enumerate(rows,1):
            assert identifier==f'{i:04}' and field()==label.encode()
            value=field()
            if source.startswith('@'):
                assert value==source.encode();bound+=1
            else:
                assert (d/source).read_bytes()==value;ordinary+=1;nbytes+=len(value)
            rejected,unsupported,ext,standard,char_unsigned,undecided,overload=[word() for k in range(7)]
            expected={flag for flag,on in [('rejected',rejected),('unsupported',unsupported),('extension',ext),('gnu23',standard==2023),('unsigned-char',char_unsigned),('undecided',undecided),('overload-none',overload==2),('overload-tables',overload==1)] if on}
            assert expected==(set() if flags=='-' else set(flags.split(',')))
        total+=len(rows)
    assert offset==len(raw)
    score(dump('function-names.c',scratch))
    d=root/'tests/checker/function-name-objects'
    for i,(identifier,source,flags,label) in enumerate(table(d),1):
        assert flags=='-' and identifier==f'{i:04}' and field()==label.encode()
        value=field();assert (d/source).read_bytes()==value;nbytes+=len(value)
        assert (d/(source+'.expected')).read_bytes()==field()+b'\n'+field()+b'\n'
        ordinary+=1;total+=1
    assert offset==len(raw)
print(f'{total} ordered records matched. {ordinary} raw source files ({nbytes} bytes), {bound} named bindings and 20 independent function-name goldens.')
