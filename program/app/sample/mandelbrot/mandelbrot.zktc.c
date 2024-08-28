#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];

int mandelbrot_task_id;

int usermain()
{
	uart_init();

	mandelbrot_task_id = zk_create_task(&mandlbrot(), stack1, USER_STACK_SIZE);

	return 0;
}

int mandlbrot()
{
	int res;

	int X = 64;
	int Y = 48;
	int N = 15;

	for (int y = 0; y < Y; y = y + 1)
	{
		for (int x = 0; x < X; x = x + 1)
		{
			int c_a = (-2 << 10) + 0x40 * x; // from -2 to 2 step 0.0625
			int c_b = (3 << 9) - 0x40 * y;	 // from -1.5 to 1.5 step 0.0625
			int x_n = 0;
			int y_n = 0;
			int max = (5 << 10) | 0x200; // overflow check
			int min = (-6 << 10) | 0x200;

			int i = 0;
			for (i = 0; i <= N; i = i + 1)
			{
				if (x_n < min || x_n > max || y_n < min || y_n > max)
				{
					break;
				}

				// pre-shift for multiplication
				int x_n_2 = (x_n >>> 5) * (x_n >>> 5);
				int y_n_2 = (y_n >>> 5) * (y_n >>> 5);
				if ((x_n_2 + y_n_2) > (4 << 10))
				{
					break;
				}

				int x_n_tmp = x_n_2 - y_n_2 + c_a;
				y_n = 2 * ((x_n >>> 5) * (y_n >>> 5)) + c_b;
				x_n = x_n_tmp;
			}

			if (i > N)
			{
				res = puts(" ");
			}
			else
			{
				res = putxval(i, 0);
			}
		}
		res = puts("\n");
	}
	res = puts("mandelbrot done.\n");

	return 0;
}
