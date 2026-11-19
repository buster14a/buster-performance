union cell
{
    unsigned wide;
    unsigned short words[2];
    unsigned char bytes[4];
};

unsigned put_byte(union cell *p, unsigned char value)
{
    p->wide = value;
    return p->bytes[0];
}

unsigned put_word(union cell *p, unsigned short value)
{
    p->wide = value;
    return p->words[0];
}

unsigned other_byte(union cell *p, unsigned short value)
{
    p->wide = value;
    return p->bytes[1];
}

unsigned may_alias(union cell *p, unsigned char *q, unsigned short value)
{
    p->wide = value;
    *q = 0x5a;
    return p->words[0];
}
