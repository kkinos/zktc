#define TX_STATUS_REG 0x8100
#define TX_ENABLE_REG 0x8102
#define TX_DATA_REG 0x8104
#define RX_STATUS_REG 0x8110
#define RX_INTERRUPT_ENABLE_REG 0x8112
#define RX_DATA_VALID_REG 0x8114
#define RX_DATA_REG 0x8116

int *tx_status_reg;
int *tx_enable_reg;
int *tx_data_reg;
int *rx_status_reg;
int *rx_interrupt_enable_reg;
int *rx_data_valid_reg;
int *rx_data_reg;

int uart_init()
{
	tx_status_reg = TX_STATUS_REG;
	tx_enable_reg = TX_ENABLE_REG;
	tx_data_reg = TX_DATA_REG;
	rx_status_reg = RX_STATUS_REG;
	rx_interrupt_enable_reg = RX_INTERRUPT_ENABLE_REG;
	rx_data_valid_reg = RX_DATA_VALID_REG;
	rx_data_reg = RX_DATA_REG;

	return 0;
}

int uart_interrupt_enable()
{
	*rx_interrupt_enable_reg = 1;
	return 0;
}

int is_send_enable()
{
	if (*tx_status_reg == 1)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

int send_byte(char c)
{
	while (!is_send_enable())
	{
	}

	*tx_data_reg = c;
	*tx_enable_reg = 1;
	*tx_enable_reg = 0;

	return 0;
}

int is_recv_enable()
{
	if (*rx_data_valid_reg == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

char recv_byte()
{
	char c;
	while (!is_recv_enable())
	{
	}
	c = *rx_data_reg;
	return c;
}

int putc(char c)
{
	if (c == "\n"[0])
	{
		send_byte("\r"[0]);
	}
	send_byte(c);
	return 0;
}

char getc()
{
	char c;
	c = recv_byte();
	if (c == "\r"[0])
	{
		c = "\n"[0];
	}
	putc(c); // echo back
	return c;
}

int puts(char *s)
{
	while (*s != 0)
	{
		putc(*s);
		s = s + 1;
	}
	return 0;
}

int gets(char *buf)
{
	int i = 0;
	char c;
	while (1)
	{
		c = getc();

		if (c == "\n"[0])
			c = "\0"[0];

		buf[i] = c;
		i = i + 1;

		if (c == "\0"[0])
			break;
	}
	return i - 1;
}

int putxval(int value, int column)
{
	char buf[9];
	char *p;

	p = buf + sizeof(buf);
	p = p - 1;

	*p = "\0"[0];
	p = p - 1;

	if (!value && !column)
	{
		column = column + 1;
	}

	while (value || column)
	{
		*p = "0123456789abcdef"[value & 0xF];
		value = value >> 4;
		p = p - 1;
		if (column != 0)
		{
			column = column - 1;
		}
	}

	puts(p + 1);

	return 0;
}
