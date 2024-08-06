#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];

int task1_id;

int usermain()
{
  gpio_init();

  task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);

  return 0;
}

int task1()
{

  set_gpio_dir(0, 1);
  set_gpio_dir(1, 0);

  while (1)
  {
    if (get_gpio_in(0) == 1)
    {
      set_gpio_out(1, 1);
    }
  }
}
