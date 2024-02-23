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
int task_num;
tcb *cur_task;

int init_tcb()
{
	cur_task_id = 0;
	task_num = -1;
	for (int i = 0; i < MAX_TASK_NUM; i = i + 1)
	{
		tcb_tbl[i].status = NO_TASK;
	}
	return 0;
}

int create_task(func *func, char *stack, int stack_size)
{
	if (task_num + 1 >= MAX_TASK_NUM)
	{
		return -1;
	}

	task_num = task_num + 1;

	tcb_tbl[task_num].func = func;
	tcb_tbl[task_num].sp = &stack[stack_size];
	tcb_tbl[task_num].status = READY;

	tcb_tbl[task_num].sp = tcb_tbl[task_num].sp - 8;
	*(tcb_tbl[task_num].sp) = &start_task();
	tcb_tbl[task_num].sp = tcb_tbl[task_num].sp - 1;

	return task_num;
}

int schedule()
{
	while (1)
	{
		if ((cur_task_id + 1) == MAX_TASK_NUM)
		{
			cur_task_id = 0;
		}
		else
		{
			cur_task_id = cur_task_id + 1;
		}
		cur_task = &tcb_tbl[cur_task_id];

		if (cur_task->status == READY)
			break;
	}
	return 0;
}

int start_task()
{
	*(cur_task->func);
	exit_task();
	return 0;
}

int exit_task()
{
	cur_task->status = NO_TASK;
	dispatch();
	return 0;
}

int sleep_task()
{
	cur_task->status = SLEEP;
	dispatch();
	return 0;
}

int wakeup_task(int task_id)
{
	tcb_tbl[task_id].status = READY;
	dispatch();
	return 0;
}