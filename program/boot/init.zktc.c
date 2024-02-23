__naked__ int init()
{
	__asm__("lil t0, 0xffff@l");
	__asm__("lih t1, 0xffff@h");
	__asm__("or t0, t1");
	__asm__("wsp t0");
	__asm__("mov fp, t0");
}