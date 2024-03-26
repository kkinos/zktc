int main()
{

	uart_init();

	puts("ZKTC boot loader started.\n");
	puts("ZKTC project is a hobby project by kkinos.\n");
	puts("For more details, https://github.com/kkinos/zktc \n");

	char cmd_buf[16];
	char *load_buf = 0;
	int load_size = 0;
	int thr = 0;
	int tlr = 0;

	while (1)
	{
		puts("> ");
		gets(cmd_buf);

		if (!strcmp(cmd_buf, "hello"))
		{
			puts("Hello, world!\n");
		}
		else if (!strcmp(cmd_buf, "dump"))
		{
			puts("address times\n");
			puts("> ");
			gets(cmd_buf);
			char *dump_addr_str = strtok(cmd_buf, " ");
			if (dump_addr_str != 0)
			{
				int *dump_addr = hex2int(dump_addr_str);
				int times = hex2int(strtok(0, " "));
				for (int i = 0; i < times; i = i + 1)
				{
					puts("0x");
					putxval(dump_addr, 4);
					puts(": ");
					putxval(*dump_addr, 4);
					puts("\n");
					dump_addr = dump_addr + 1;
				}
				puts("\n");
			}
			else
			{
				puts("Invalid command.\n");
			}
		}
		else if (!strcmp(cmd_buf, "memwrite"))
		{
			puts("address data\n");
			puts("> ");
			gets(cmd_buf);
			char *write_addr_str = strtok(cmd_buf, " ");
			if (write_addr_str != 0)
			{
				int *write_addr = hex2int(write_addr_str);
				int write_data = hex2int(strtok(0, " "));
				*write_addr = write_data;
				putxval(write_addr, 4);
				puts(": ");
				putxval(write_data, 4);
				puts("\n");
				puts("Finished writing to memory.\n");
			}
			else
			{
				puts("Invalid command.\n");
			}
		}
		else if (!strcmp(cmd_buf, "load"))
		{
			load_size = xmodem_recv(load_buf);
			wait();
			if (load_size < 0)
			{
				puts("Failed to load.\n");
			}
			else
			{
				puts("Loaded successfully.\n");
			}
		}
		else if (!strcmp(cmd_buf, "filesize"))
		{
			puts("File size: 0x");
			putxval(load_size, 4);
			puts(" bytes\n");
		}
		else if (!strcmp(cmd_buf, "run"))
		{
			if (load_size > 0)
			{
				jump_to_app();
			}
			else
			{
				puts("No program loaded.\n");
			}
		}
		else if (!strcmp(cmd_buf, "timer"))
		{
			__asm__("rtr");
			thr = read_thr();
			tlr = read_tlr();
			puts("Timer: 0x");
			putxval(thr, 4);
			putxval(tlr, 4);
			puts("\n");
		}
		else
		{
			puts("Unknown command.\n");
		}
	}

	while (1)
	{
	}

	return 0;
}

int jump_to_app()
{
	__asm__("lil t0, 0x0000@l");
	__asm__("lih t1, 0x0000@h");
	__asm__("or t0, t1");
	__asm__("jalr zero, t0, 0");
}

int wait()
{
	for (int i = 0; i < 30000; i = i + 1)
	{
	}
	return 0;
}

__naked__ int read_thr()
{
	__asm__("rthr a0");
	__asm__("jalr zero, ra, 0");
}

__naked__ int read_tlr()
{
	__asm__("rtlr a0");
	__asm__("jalr zero, ra, 0");
}