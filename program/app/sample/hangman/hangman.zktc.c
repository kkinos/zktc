#define USER_STACK_SIZE 256

#define WORD_SIZE 5
#define MAX_ERROR 6
#define WORD_KIND 10

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];

int hangman_task_id;
int blink_led_task_id;

int *led;
char c;
char *ans_arr[WORD_KIND];

int usermain()
{
	led = 0x8000;

	uart_init();
	uart_interrupt_enable();

	hangman_task_id = zk_create_task(&hangman(), stack1, USER_STACK_SIZE);
	blink_led_task_id = zk_create_task(&blink_led(), stack2, USER_STACK_SIZE);
	zk_set_interrupt_handler(&uart_interrupt_handler(), 0);

	ans_arr[0] = "alarm";
	ans_arr[1] = "apple";
	ans_arr[2] = "blood";
	ans_arr[3] = "chair";
	ans_arr[4] = "clock";
	ans_arr[5] = "cloud";
	ans_arr[6] = "earth";
	ans_arr[7] = "glass";
	ans_arr[8] = "heart";
	ans_arr[9] = "music";

	return 0;
}

int hangman()
{
	int random_num = rand(WORD_KIND);
	char *ans = ans_arr[random_num];
	int open[WORD_SIZE];
	int open_cnt = 0;
	char guess[20];
	int hit = 0;
	int guess_cnt = 0;
	int already_guessed = 0;
	int error_cnt = 0;

	int res;
	int i = 0;

	for (i = 0; i < WORD_SIZE; i = i + 1)
	{
		open[i] = 0;
	}
	for (i = 0; i < 20; i = i + 1)
	{
		guess[i] = 0;
	}

	res = puts("Start Hangman Game!\n");

	while (error_cnt < MAX_ERROR)
	{
		res = puts("================================\n");
		res = puts("Word: ");
		open_cnt = 0;
		for (i = 0; i < WORD_SIZE; i = i + 1)
		{
			if (open[i] == 1)
			{
				res = putc(ans[i]);
				open_cnt = open_cnt + 1;
			}
			else
			{
				res = putc("_"[0]);
			}
			res = putc(" "[0]);
		}

		res = puts("\n");

		if (open_cnt == WORD_SIZE)
		{
			res = puts("You win!\n");
			break;
		}

		res = puts("Wrong count: ");
		res = putxval(error_cnt, 0);
		res = puts("/");
		res = putxval(MAX_ERROR, 0);
		res = puts("\n");

		res = puts("Guess: ");
		for (i = 0; i < guess_cnt; i = i + 1)
		{
			res = putc(guess[i]);
			res = putc(" "[0]);
		}
		res = puts("\n");

		res = puts("Enter a character: ");
		// wait for interrupt from uart
		res = zk_sleep();

		already_guessed = 0;
		for (i = 0; i < guess_cnt; i = i + 1)
		{
			if (guess[i] == c)
			{
				res = puts("You already guessed this character!\n");
				already_guessed = 1;
				break;
			}
		}
		if (already_guessed == 0)
		{
			guess[guess_cnt] = c;
			guess_cnt = guess_cnt + 1;

			hit = 0;
			i = 0;
			while (i < WORD_SIZE)
			{
				if (c == ans[i])
				{
					open[i] = 1;
					open_cnt = open_cnt + 1;
					hit = 1;
				}
				i = i + 1;
			}

			if (hit == 1)
			{
				res = puts("Correct!\n");
			}
			else
			{
				error_cnt = error_cnt + 1;
				res = puts("Wrong!\n");
			}
		}
	}

	if (error_cnt == 6)
	{
		res = puts("You lose!\n");
		res = puts("The answer is: ");
		res = puts(ans);
		res = puts("\n");
	}

	res = puts("Finish Hangman Game!\n");
	return 0;
}

int blink_led()
{
	int cnt = 0;
	int res;
	while (1)
	{
		if (cnt < 5000)
		{
			*led = 5;
			cnt = cnt + 1;
		}
		else if (cnt < 10000)
		{
			*led = 10;
			cnt = cnt + 1;
		}
		else
		{
			cnt = 0;
		}
		res = zk_switch();
	}
	return 0;
}

int uart_interrupt_handler()
{
	c = getc();
	puts("\n");
	zk_wakeup(hangman_task_id);
	return 0;
}