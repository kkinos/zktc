Z-kernel is a small kernel for ZKTC that supports multitasking, interrupt handlers, semaphores, and memory management.

- [Usage](#usage)
- [Features](#features)
  - [Multitasking](#multitasking)
    - [Inter-task Communication](#inter-task-communication)
  - [Interrupt Handler](#interrupt-handler)
  - [Semaphore](#semaphore)
  - [Memory Management](#memory-management)

# Usage

Create a file for the application and compile it together with the application. Refer to the Makefile under `program/app/sample` for the build method. Implement a function called `usermain` in the application. Once the kernel initialization is complete, `usermain` will be executed. The kernel functions can be used via the API. Refer to each file for API details.

```bash
kernel
		├── dispatch.zktc.c
		├── init.zktc.c
		├── interrupt_entry.zktc.c
		├── interrupt_handler.zktc.c // Interrupt handler API
		├── kernel.zktc.c
		├── memory.zktc.c // Memory API
		├── queue.zktc.c
		├── semaphore.zktc.c // Semaphore API
		└── task.zktc.c // Task API, Message API
```

# Features

## Multitasking

Multitasking is performed in a non-preemptive manner. Tasks are created using the Task API `zk_create_task` and executed after the `usermain` function finishes. Tasks voluntarily switch to other tasks using `zk_switch`. Refer to `program/kernel/task.zktc.c` for scheduling details.

Below is an example of an application using multitasking.

```c
#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];

int task1_id;
int task2_id;

int *led;

int usermain()
{
	led = 0x8000;

	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);
	task2_id = zk_create_task(&task2(), stack2, USER_STACK_SIZE);

	return 0;
}

int task1()
{
	int cnt = 0;
	while (1)
	{
		*led = 5;
		if (cnt < 30000)
		{
			cnt = cnt + 1;
		}
		else
		{
			cnt = 0;
			zk_switch();
		}
	}
	return 0;
}

int task2()
{
	int cnt = 0;
	while (1)
	{
		*led = 10;
		if (cnt < 30000)
		{
			cnt = cnt + 1;
		}
		else
		{
			cnt = 0;
			zk_switch();
		}
	}
	return 0;
}
```

### Inter-task Communication

Tasks have a buffer for messages, which can be used for synchronous message passing.

Below is an example of an application using inter-task communication.

```c
#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];

int task1_id;
int task2_id;

int usermain()
{
	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);
	task2_id = zk_create_task(&task2(), stack2, USER_STACK_SIZE);

	return 0;
}

int task1()
{
	message msg;
	msg.len = 1;
	msg.data = 42;

	zk_send(task2_id, &msg);

	zk_recv(&msg);
	// msg.data == 43

	return 0;
}

int task2()
{
	message msg;
	zk_recv(&msg);

	msg.data = 43;
	zk_send(task1_id, &msg);

	zk_exit();

	return 0;
}
```

## Interrupt Handler

You can register an interrupt handler for interrupts. Currently, it only supports hardware interrupts (UART reception), but it can be modified on the kernel side to support other interrupts.

Below is an example of an application using an interrupt handler.

```c
#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];

int task1_id;

char c;

int usermain()
{

	uart_init();
	uart_interrupt_enable();

	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);

	// interrupt_num of UART receive interrupt is 0
	zk_set_interrupt_handler(&uart_interrupt_handler(), 0);

	return 0;
}

// blink led
int task1()
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
	}
	return 0;
}

// echo back and set data to c
int uart_interrupt_handler()
{
	c = getc();
	return 0;
}
```

## Semaphore

You can use semaphores to achieve mutual exclusion control of shared resources. Use the Semaphore API `zk_get_sem` to acquire resources. If another task has already acquired the resource, it will wait until it is returned.

Below is an example of an application using the semaphore feature.

```c
#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];
char stack2[USER_STACK_SIZE];

int task1_id;
int task2_id;

int sem_id;

int resourse;

int usermain()
{
	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);
	task2_id = zk_create_task(&task2(), stack2, USER_STACK_SIZE);

	sem_id = zk_create_sem();

	return 0;
}

int task1()
{
	zk_get_sem(sem_id);

	resourse = 1;

	zk_switch();

	zk_release_sem(sem_id);

	return 0;
}

int task2()
{
	// task2 tries to acquire a resource, but task1 has already acquired it, so task2 is in SLEEP state
	zk_get_sem(sem_id);

	// After the resource is released, task2 starts execution.
	resourse = 2;

	zk_release_sem(sem_id);

	return 0;
}

```

## Memory Management

Applications can allocate memory during execution using the Memory API `zk_malloc`. Memory cannot be freed.

Below is an example of an application that dynamically allocates memory.

```c
#define USER_STACK_SIZE 256

char stack1[USER_STACK_SIZE];

int task1_id;

int usermain()
{
	task1_id = zk_create_task(&task1(), stack1, USER_STACK_SIZE);

	return 0;
}

int task1()
{
	// Allocate 8 bytes of memory
	char *ptr = zk_malloc(8);

	for (int i = 0; i < 8; i = i + 1)
	{
		ptr[i] = 0x41;
	}

	// ptr->0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41
	// 		0x41

	return 0;
}
```
