#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];

int task1_id;

int usermain()
{
	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);

	return 0;
}

int task1()
{
	// Allocate 8 bytes of memory
	char *ptr = zk_malloc(8);

	for (int i = 0; i < 8; i = i + 1)
	{
		ptr[i] = 0x41;
	}

	// ptr->0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41

	return 0;
}

int print(int num)
{

	__asm__(".word 0x0000");
}