#define XMODEM_SOH 0x01
#define XMODEM_STX 0x02
#define XMODEM_EOT 0x04
#define XMODEM_ACK 0x06
#define XMODEM_NAK 0x15
#define XMODEM_CAN 0x18
#define XMODEM_EOF 0x1A

#define XMODEM_BLOCK_SIZE 128

int xmodem_wait()
{
	int cnt1 = 0;
	int cnt2 = 0;

	while (!is_recv_enable())
	{
		cnt1 = cnt1 + 1;
		if (cnt1 > 30000)
		{
			cnt1 = 0;
			cnt2 = cnt2 + 1;
			if (cnt2 > 100)
			{
				cnt2 = 0;
				send_byte(XMODEM_NAK);
			}
		}
	}
	return 0;
}

int xmodem_read_block(char block_number, char *buf)
{
	char c;
	char block_num;
	char block_num_inv;
	char check_sum;
	int i;

	block_num = recv_byte();
	if (block_num != block_number)
	{
		return -1;
	}

	block_num_inv = recv_byte();
	if (block_num + block_num_inv != 0xFF)
	{
		return -1;
	}

	check_sum = 0;
	for (i = 0; i < XMODEM_BLOCK_SIZE; i = i + 1)
	{
		c = recv_byte();
		buf[i] = c;
		check_sum = check_sum + c;
	}

	c = recv_byte();
	if (c != check_sum)
	{
		return -1;
	}

	return i;
}

int xmodem_recv(char *buf)
{
	char block_number = 1;
	char c;
	int i;
	int receiving = 0;
	int size = 0;

	while (1)
	{
		if (!receiving)
		{
			xmodem_wait();
		}

		c = recv_byte();

		if (c == XMODEM_CAN)
		{
			return -1;
		}
		else if (c == XMODEM_EOT)
		{
			send_byte(XMODEM_ACK);
			break;
		}
		else if (c == XMODEM_SOH)
		{
			receiving = 1;
			i = xmodem_read_block(block_number, buf);
			if (i < 0)
			{
				send_byte(XMODEM_NAK);
			}
			else
			{
				send_byte(XMODEM_ACK);
				buf = buf + XMODEM_BLOCK_SIZE;
				block_number = block_number + 1;
				size = size + XMODEM_BLOCK_SIZE;
			}
		}
		else
		{
			if (receiving)
			{
				return -1;
			}
		}
	}

	return size;
}