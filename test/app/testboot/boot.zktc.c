int main()
{
	__asm__("lil t0, 0x0000@l");
	__asm__("lih t1, 0x0000@h");
	__asm__("or t0, t1");
	__asm__("jalr zero, t0, 0");

	return 0;
}