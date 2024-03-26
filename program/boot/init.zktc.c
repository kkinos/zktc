__naked__ int init()
{
	__asm__("lil t0, 0xffff@l");
	__asm__("lih t1, 0xffff@h");
	__asm__("or t0, t1");
	__asm__("wsp t0");
	__asm__("mov fp, t0");

	// if boot in emulator, jump to app
	__asm__("rpsr a0");
	__asm__("beq a0, zero, 10");
	__asm__("lil t0, jump_to_app@l");
	__asm__("lih t1, jump_to_app@h");
	__asm__("or t0, t1");
	__asm__("jalr zero, t0, 0");
}