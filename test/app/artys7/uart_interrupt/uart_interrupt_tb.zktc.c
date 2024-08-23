#define USER_STACK_SIZE 256
#define LED_ADDR 0x8000

char stack1[USER_STACK_SIZE];

int task1_id;

int *led;

char recv_data;

int usermain()
{
  led = LED_ADDR;

  uart_init();
  uart_interrupt_enable();

  task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);
  zk_set_interrupt_handler(&uart_interrupt_handler(), 0);

  return 0;
}

int task1()
{

  char send_data = 0x51;
  send_byte(send_data);
  int cnt = 0;

  while (cnt < 100)
  {
    cnt = cnt + 1;
  }

  if (recv_data == send_data)
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

int uart_interrupt_handler()
{
  recv_data = 0;
  recv_data = recv_byte();

  return 0;
}