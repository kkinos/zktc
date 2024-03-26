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
	//  task3_id = zk_create_task(&task3(), stack3, USER_STACK_SIZE);
	//  sem_id = zk_create_sem();
	return 0;
}

int task1()
{
	// zk_get_sem(sem_id);
	// int x = 0;
	// for (int i = 0; i < 10; i = i + 1)
	// {
	// 	x = x + 1;
	// 	zk_switch();
	// }
	// zk_release_sem(sem_id);

	// message msg;
	// msg.len = 11;
	// msg.data = 21;
	// zk_send(task3_id, &msg);
	// print(msg.data);
	// char *ptr = zk_malloc(8);
	// print(ptr);
	// char buf[12];
	// char *ptr = buf;
	// buf[0] = "d"[0];
	// buf[1] = "u"[0];
	// buf[2] = "m"[0];
	// buf[3] = "p"[0];
	// buf[4] = " "[0];
	// buf[5] = "d"[0];
	// buf[6] = "e"[0];
	// buf[7] = "a"[0];
	// buf[8] = "d"[0];
	// buf[9] = " "[0];
	// buf[10] = "a"[0];

	// char *ptr1 = strtok(buf, " ");
	// int n;
	// if (!strcmp(ptr1, "dump"))
	// {
	// 	ptr1 = strtok(0, " ");
	// 	n = hex2int(ptr1);
	// 	ptr1 = strtok(0, " ");
	// 	n = hex2int(ptr1);
	// 	print(n);
	// }
	// else
	// {
	// 	print(2);
	// }
	// while (ptr1 != 0)
	// {
	// 	ptr1 = strtok(0, " ");
	// 	i = i + 1;
	// 	// if (i == 1)
	// 	// 	print(*ptr1);
	// }
	// print(1);

	// char *ptr1 = strtok(buf, " ");

	// if (!strcmp(ptr1, "abc"))
	// {
	// 	print(1);
	// }
	// else
	// {
	// 	print(0);
	// }

	// char *ptr2 = strtok(0, " ");

	// if (!strcmp(ptr2, "de"))
	// {
	// 	print(1);
	// }
	// else
	// {
	// 	print(0);
	// }

	// char *ptr3 = strtok(0, " ");

	// if (!strcmp(ptr3, "f"))
	// {
	// 	print(1);
	// }
	// else
	// {
	// 	print(0);
	// }

	// char *ptr4 = strtok(0, " ");
	// print(ptr4);

	int c = 0;
	while (1)
	{
		*led = 3;
		if (c < 30000)
		{
			c = c + 1;
		}
		else
		{
			c = 0;
			zk_switch();
		}
	}

	return 0;
}

int task2()
{
	int c = 0;
	while (1)
	{
		*led = 12;
		if (c < 30000)
		{
			c = c + 1;
		}
		else
		{
			c = 0;
			zk_switch();
		}
	}
	return 0;
}

// int task2()
// {

// 	// zk_get_sem(sem_id);
// 	// int x = 0;
// 	// for (int i = 0; i < 20; i = i + 1)
// 	// {
// 	// 	x = x + 1;
// 	// }
// 	// zk_release_sem(sem_id);
// 	message msg;
// 	msg.len = 12;
// 	msg.data = 22;
// 	zk_send(task3_id, &msg);
// 	return 0;
// }

// int task3()
// {

// 	// zk_get_sem(sem_id);
// 	// int x = 0;
// 	// for (int i = 0; i < 15; i = i + 1)
// 	// {
// 	// 	x = x + 1;
// 	// }
// 	// print(zk_get_id());
// 	// zk_release_sem(sem_id);
// 	message msg;
// 	zk_recv(&msg);
// 	print(msg.data);
// 	zk_recv(&msg);
// 	return 0;
// }

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

// int assert(int expect, int actual, int num)
// {
// 	if (expect == actual)
// 	{
// 		return 0;
// 	}
// 	else
// 	{
// 		__asm__("mov a0, a2");
// 		__asm__(".word 0x0000");
// 	}
// }

int print(int num)
{

	__asm__(".word 0x0000");
}