int *local_named(void)
{
    struct __attribute__((packed)) Local { char c; int w; };
    static struct Local object;
    return &object.w;
}

int *local_anonymous(void)
{
    static struct __attribute__((packed)) { char c; int w; } object;
    return &object.w;
}

void *converted(void)
{
    static struct __attribute__((packed)) { char c; int w; } object;
    return &object.w;
}
