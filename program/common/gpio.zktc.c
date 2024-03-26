#define GPIO_OUT_REG 0x8200
#define GPIO_IN_REG 0x8202
#define GPIO_DIR_REG 0x8204

int *gpio_out_reg;
int *gpio_in_reg;
int *gpio_dir_reg;

int gpio_out_data;
int gpio_dir_data;

int gpio_init()
{
	gpio_out_reg = GPIO_OUT_REG;
	gpio_in_reg = GPIO_IN_REG;
	gpio_dir_reg = GPIO_DIR_REG;

	gpio_out_data = 0;
	gpio_dir_data = 0;

	return 0;
}

int set_gpio_out(int port, int value)
{
	value = value & 0x1;

	if (value == 0)
	{
		gpio_out_data = gpio_out_data & ~(1 << port);
	}
	else
	{
		gpio_out_data = gpio_out_data | (1 << port);
	}

	*gpio_out_reg = gpio_out_data;

	return 0;
}

int get_gpio_in(int port)
{
	int value = *gpio_in_reg;

	value = (value >> port) & 0x1;

	return value;
}

int set_gpio_dir(int port, int value)
{
	value = value & 0x1;

	if (value == 0)
	{
		gpio_dir_data = gpio_dir_data & ~(1 << port);
	}
	else
	{
		gpio_dir_data = gpio_dir_data | (1 << port);
	}

	*gpio_dir_reg = gpio_dir_data;

	return 0;
}