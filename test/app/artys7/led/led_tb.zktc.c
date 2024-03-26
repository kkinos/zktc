#define USER_STACK_SIZE 256
#define LED_ADDR 0x8000

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];

int task1_id;
int task2_id;

int *led;

int usermain()
{
  led = LED_ADDR;

  task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);
  task2_id = zk_create_task(&task2(), stack2, USER_STACK_SIZE);

  return 0;
}

int task1()
{
  int c = 0;
  while (1)
  {
    if (c < 3)
    {
      c = c + 1;
      zk_switch();
    }
    else
    {
      *led = 10;
    }
  }
  return 0;
}

int task2()
{
  while (1)
  {
    zk_switch();
  }
  return 0;
}
