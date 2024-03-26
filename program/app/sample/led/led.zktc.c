#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];

int task1_id;
int task2_id;

int *led;

int usermain()
{
	led = 0x8000;

	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);
	task2_id = zk_create_task(&task2(), stack2, USER_STACK_SIZE);

	return 0;
}

int task1()
{
	int cnt = 0;
	int res = 0;
	while (1)
	{
		*led = 5;
		if (cnt < 30000)
		{
			cnt = cnt + 1;
		}
		else
		{
			cnt = 0;
			res = zk_switch();
		}
	}
	return 0;
}

int task2()
{
	int cnt = 0;
	int res = 0;
	while (1)
	{
		*led = 10;
		if (cnt < 30000)
		{
			cnt = cnt + 1;
		}
		else
		{
			cnt = 0;
			res = zk_switch();
		}
	}
	return 0;
}
