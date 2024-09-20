Z-kernel はマルチタスク、割り込みハンドラ、セマフォ、メモリ管理をサポートした ZKTC 用の小さなカーネルです。

- [使用方法](#使用方法)
- [機能](#機能)
  - [マルチタスク](#マルチタスク)
    - [タスク間通信](#タスク間通信)
  - [割り込みハンドラ](#割り込みハンドラ)
  - [セマフォ](#セマフォ)
  - [メモリ管理](#メモリ管理)

# 使用方法

アプリケーション用のファイルを作成し、アプリケーションと一緒にコンパイルしてください。ビルド方法は`program/app/sample`以下の Makefile を参考にしてください。アプリケーションには`usermain`という関数を実装してください。カーネルの初期化が終わると`usermain`が実行されます。カーネルの機能は API を用いて使用できます。API の詳細はそれぞれのファイルを参照してください。

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

# 機能

## マルチタスク

マルチタスクはノンプリエンプティブ方式で行われます。タスクは Task API である`zk_create_task`を用いて生成され、`usermain`関数が終了後、実行されます。タスクは`zk_switch`で自発的に他のタスクへの切り替えを行います。スケジューリングの詳細は`program/kernel/task.zktc.c`を参照してください。

以下はマルチタスクを利用したアプリケーションの例です。

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

### タスク間通信

タスクにはメッセージ用のバッファがあり、それを使用して同期的メッセージパッシングを行うことができます。

以下はタスク間通信を利用したアプリケーションの例です。

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

## 割り込みハンドラ

割り込みに対して割り込みハンドラを登録することができます。現状ではハードウェア割り込み（UART 受信）に対してのみ対応していますが、カーネル側を修正することで他の割り込みに対しても対応することが可能です。

以下は割り込みハンドラを使用したアプリケーションの例です。

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

## セマフォ

共有資源の排他制御を実現する機能としてセマフォを使用することができます。Semaphore API である`zk_get_sem`を使用して資源を獲得します。他のタスクがその資源を獲得済みの場合は返却されるまで待ち状態になります。

以下はセマフォ機能を使用したアプリケーションの例です。

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

## メモリ管理

アプリケーションは実行中に Memory API である`zk_malloc`を使用してメモリを確保することができます。開放はできません。

以下は動的にメモリを確保するアプリケーションの例です。

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
