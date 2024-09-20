#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];

int task1_id;

int usermain()
{
	gpio_init();

	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);

	return 0;
}

int task1()
{

	set_gpio_dir(6, 1);
	set_gpio_dir(7, 0);

	int res;
	while (1)
	{
		if (get_gpio_in(6) == 1)
		{
			res = set_gpio_out(7, 0);
		}
		else
		{
			res = set_gpio_out(7, 1);
		}
	}
}
