#define USER_STACK_SIZE 256
#define LED_ADDR 0x8000

char stack1[USER_STACK_SIZE];

int task1_id;

int *led;

int usermain()
{
  led = LED_ADDR;

  uart_init();

  task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);

  return 0;
}

int task1()
{

  char send_data = 0x51;
  send_byte(send_data);

  char recv_data = 0;
  recv_data = recv_byte();

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
