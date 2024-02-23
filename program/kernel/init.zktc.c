__naked__ int init()
{
	__asm__("push ra");
	__asm__("push fp");
	__asm__("push a0");
	__asm__("push a1");
	__asm__("push a2");
	__asm__("push t0");
	__asm__("push t1");
	__asm__("rppc a0");
	__asm__("push a0");
	__asm__("rppsr a0");
	__asm__("push a0");
	__asm__("rpsr a0");
	__asm__("rsp a1");
	__asm__("lil t0, 0xffff@l");
	__asm__("lih t1, 0xffff@h");
	__asm__("or t0, t1");
	__asm__("wsp t0");
	__asm__("mov fp, t0");
	__asm__("lil t0, handle_interrupt@l");
	__asm__("lih t1, handle_interrupt@h");
	__asm__("or t0, t1");
	__asm__("jalr ra, t0, 0");
}

