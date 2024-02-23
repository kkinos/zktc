#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];

int task1_id;
int task2_id;

int usermain()
{
	task1_id = create_task(&count_up1(), stack1, USER_STACK_SIZE);
	task2_id = create_task(&count_up2(), stack2, USER_STACK_SIZE);

	return 0;
}

int count_up1()
{
	sleep_task();
	int x = 0;
	for (int i = 0; i < 10; i = i + 1)
	{
		x = x + 1;
	}
	assert(11, x, 1);

	return 0;
}

int count_up2()
{

	int x = 0;
	for (int i = 0; i < 20; i = i + 1)
	{
		x = x + 1;
	}
	assert(21, x, 2);
	wakeup_task(task1_id);
	return 0;
}

// int fibonacci(int a)
// {
// 	if (a == 0)
// 	{
// 		return 0;
// 	}
// 	if (a == 1)
// 	{
// 		return 1;
// 	}

// 	return fibonacci(a - 1) + fibonacci(a - 2);
// }

int assert(int expect, int actual, int num)
{
	if (expect == actual)
	{
		return 0;
	}
	else
	{
		__asm__("mov a0, a2");
		__asm__(".word 0x0000");
	}
}