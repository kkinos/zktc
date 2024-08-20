#define ILL_INST_INTERRUPT 0x0002
#define SOFT_INTERRUPT 0x0004
#define HARD_INTERRUPT 0x0008

int handle_interrupt(int psr, int *sp)

{
	if (psr & ILL_INST_INTERRUPT)
	{
		puts("Illegal instruction\n");
		while (1)
		{
		}
	}
	else if (psr & SOFT_INTERRUPT)
	{

		cur_task->sp = sp;

		schedule();

		// a0 = cur_task->sp
		dispatch_entry(cur_task->sp);
	}
	else if (psr & HARD_INTERRUPT)
	{
		// TODO
	}
	else
	{
		// start kernel
		main();
	}
}