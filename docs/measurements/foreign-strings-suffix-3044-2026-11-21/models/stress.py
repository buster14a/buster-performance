import sys, random
sys.path.insert(0, '.')
from model import *
# Alignment-heavy trials: padding empty strings, a small alphabet, alignments up to 2^6, several groups.
def trials(seed, count):
    rng = random.Random(seed)
    bad = 0
    tot = Stats()
    for trial in range(count):
        words = [bytes(rng.choice(b'ab') for _ in range(rng.randint(0, 9))) + b'\0' for _ in range(rng.randint(1, 6))]
        inputs = []
        for s in range(rng.randint(1, 10)):
            data = b''
            for w in range(rng.randint(0, 10)):
                data += rng.choice(words)
                if rng.random() < 0.4:
                    data += b'\0' * rng.randint(1, 7)
            inputs.append((data, rng.randint(0, 1), rng.randint(0, 6), 0))
        ents = entries_of(inputs)
        st = Stats()
        o1 = naive(ents)
        o3 = design(ents, st)
        if o1 != o3:
            bad += 1
            if bad < 4:
                print("MISMATCH", trial, inputs, o1, o3)
        for k, v in st.items():
            tot[k] += v
    print(f"stress seed {seed}: trials {count} mismatches {bad}")
    print("  " + " ".join(f"{k}={v}" for k, v in sorted(tot.items()) if 'max' not in k))
trials(int(sys.argv[1]), int(sys.argv[2]))
