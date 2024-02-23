__naked__ int dispatch_entry()
{
	__asm__("wsp a0");
	__asm__("pop a0");
	__asm__("wppsr a0");
	__asm__("pop a0");
	__asm__("wppc a0");
	__asm__("pop t1");
	__asm__("pop t0");
	__asm__("pop a2");
	__asm__("pop a1");
	__asm__("pop a0");
	__asm__("pop fp");
	__asm__("pop ra");
	__asm__("rfi");
}

int dispatch()
{
	__asm__("trap");
	return 0;
}