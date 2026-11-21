from random import Random
rng = Random(193)
full=(1<<512)-1
lane=(1<<64)-1
checked=0
for occupancy in range(256):
    for skip in range(3):
        for active in range(2):
            for pattern in range(18):
                words=[(rng.getrandbits(64)|(1<<((pattern*7+skip)&63))) if occupancy>>i&1 else 0 for i in range(8)]
                original=sum(v<<(64*i) for i,v in enumerate(words))
                cursor=(1<<skip) if active else 0
                old_end=(original & ~(original-(cursor&~original))) | (cursor&original)
                old_region=((old_end-active)|active|old_end)&full
                words[0]&=~((1<<skip)-1)
                empty=sum((v==0)<<i for i,v in enumerate(words))
                through=(empty^(empty+1)) & (255 if active else 0)
                region=sum((((v^(v-1))&lane) if through>>i&1 else 0)<<(64*i) for i,v in enumerate(words))
                end=sum(v<<(64*i) for i,v in enumerate(words))&region
                assert old_end==end and old_region==region
                checked+=1
print(checked, 'equal first ends and full comment regions')
