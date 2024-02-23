#define SYS_STACK_SIZE 256
char sys_stack[SYS_STACK_SIZE];

int main()
{
	init_tcb();
	create_task(&sys_task(), sys_stack, SYS_STACK_SIZE);
	cur_task = &tcb_tbl[0];

	// system task start
	dispatch_entry(cur_task->sp);

	return 0;
}

int sys_task()
{
	usermain();

	sleep_task();

	while (1)
	{
	}

	return 0;
}
