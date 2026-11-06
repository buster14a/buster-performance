import random, sys
n = int(sys.argv[1])
random.seed(1)
vals=[random.randrange(-100000,100000) for _ in range(n)]
with open('rows4.c','w') as f:
    f.write("int table[][4] = {\n")
    for i in range(0,n,4):
        f.write("  { "+", ".join(map(str,vals[i:i+4]))+" },\n")
    f.write("};\n")
with open('flat.c','w') as f:
    f.write("int table[] = {\n")
    for i in range(0,n,8):
        f.write("  "+", ".join(map(str,vals[i:i+8]))+",\n")
    f.write("};\n")
b=[random.randrange(256) for _ in range(n)]
with open('bytes16.c','w') as f:
    f.write("const unsigned char table[%d][16] = {\n" % (n//16))
    for i in range(0,n,16):
        f.write("  {"+", ".join("0x%02x"%x for x in b[i:i+16])+"},\n")
    f.write("};\n")
m=n-n%3
with open('double3.c','w') as f:
    f.write("const double table[][3] = {\n")
    for i in range(0,m,3):
        f.write("  { "+", ".join("%d.%03d"%(vals[j]//1000, abs(vals[j])%1000) for j in range(i,i+3))+" },\n")
    f.write("};\n")
