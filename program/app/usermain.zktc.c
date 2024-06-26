#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];
char stack3[USER_STACK_SIZE];

int task1_id;
int task2_id;
int task3_id;

int sem_id;

int usermain()
{
	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);
	// task2_id = zk_create_task(&task2(), stack2, USER_STACK_SIZE);
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
	char *ptr = zk_malloc(8);
	print(ptr);
	return 0;
}

int task2()
{

	// zk_get_sem(sem_id);
	// int x = 0;
	// for (int i = 0; i < 20; i = i + 1)
	// {
	// 	x = x + 1;
	// }
	// zk_release_sem(sem_id);
	message msg;
	msg.len = 12;
	msg.data = 22;
	zk_send(task3_id, &msg);
	return 0;
}

int task3()
{

	// zk_get_sem(sem_id);
	// int x = 0;
	// for (int i = 0; i < 15; i = i + 1)
	// {
	// 	x = x + 1;
	// }
	// print(zk_get_id());
	// zk_release_sem(sem_id);
	message msg;
	zk_recv(&msg);
	print(msg.data);
	zk_recv(&msg);
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

int print(int num)
{

	__asm__(".word 0x0000");
}