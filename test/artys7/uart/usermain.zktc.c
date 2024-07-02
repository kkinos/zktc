#define USER_STACK_SIZE 256
#define LED_ADDR 0x8000
#define UART_BASE_ADDR 0x8100

char stack1[USER_STACK_SIZE];

int task1_id;

int *led;

int *tx_status;
int *tx_start;
int *tx_data;
int *rx_data_valid;
int *rx_data;

int usermain()
{
  led = LED_ADDR;
  tx_status = UART_BASE_ADDR;
  tx_start = UART_BASE_ADDR + 2;
  tx_data = UART_BASE_ADDR + 4;

  rx_data_valid = UART_BASE_ADDR + 20;
  rx_data = UART_BASE_ADDR + 22;

  task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);

  return 0;
}

int task1()
{
  int data = 0x55;
  *tx_data = data;
  *tx_start = 1;

  while (1)
  {
    if (*tx_status == 1)
    {
      *tx_start = 0;
      break;
    }
  }

  while (1)
  {
    if (*rx_data_valid == 1)
    {
      break;
    }
  }

  if (*rx_data == data)
  {
    *led = 10;
  }
  else
  {
    *led = 5;
  }

  while (1)
  {
  }
  return 0;
}
