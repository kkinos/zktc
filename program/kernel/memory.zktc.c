char *free;

int init_mem()
{
	__asm__("lil a0, heap@l");
	__asm__("lih a1, heap@h");
	__asm__("or a0, a1");
	__asm__("lil t0, free@l");
	__asm__("lih t1, free@h");
	__asm__("or t0, t1");
	__asm__("sw a0, t0, 0");

	return 0;
}

int zk_malloc(int size)
{
	char *p = free;
	free = free + size;
	return p;
}