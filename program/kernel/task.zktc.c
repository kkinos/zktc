#define MAX_TASK_NUM 5

// Task status
#define NO_TASK 0
#define READY 1
#define SLEEP 2

// Task control block
typedef struct
{
	func *func;
	int *sp;
	int status;
} tcb;

tcb tcb_tbl[MAX_TASK_NUM];

int cur_task_id;
tcb *cur_task;

int init_tcb()
{
	cur_task_id = 0;
	for (int i = 0; i < MAX_TASK_NUM; i = i + 1)
	{
		tcb_tbl[i].status = NO_TASK;
	}
	return 0;
}

int schedule()
{
	for (int i = 1; i <= MAX_TASK_NUM; i = i + 1)
	{
		int task_id = (cur_task_id + i) % MAX_TASK_NUM;
		tcb *task = &tcb_tbl[task_id];
		if ((task->status == READY) && (task_id != 0))
		{
			cur_task_id = task_id;
			cur_task = task;
			return 0;
		}
	}

	// sys task
	cur_task_id = 0;
	cur_task = &tcb_tbl[cur_task_id];

	return 0;
}

// Task API

int zk_create_task(func *func, char *stack, int stack_size)
{
	tcb *task = NULL;
	int i;
	for (i = 0; i < MAX_TASK_NUM; i = i + 1)
	{
		if (tcb_tbl[i].status == NO_TASK)
		{
			task = &tcb_tbl[i];
			break;
		}
	}
	if (task == NULL)
	{
		return -1;
	}

	task->func = func;
	task->sp = &stack[stack_size];
	task->status = READY;

	task->sp = task->sp - 8;
	*(task->sp) = &zk_start();
	task->sp = task->sp - 1;

	return i;
}

int zk_start()
{
	*(cur_task->func);
	zk_exit();
	return 0;
}

int zk_exit()
{
	cur_task->status = NO_TASK;
	dispatch();
	return 0;
}

int zk_wait()
{
	dispatch();
	return 0;
}

int zk_sleep()
{
	cur_task->status = SLEEP;
	dispatch();
	return 0;
}

int zk_wakeup_task(int task_id)
{
	tcb_tbl[task_id].status = READY;
	return 0;
}