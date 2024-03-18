#define MAX_TASK_NUM 5

// Task status
#define NO_TASK 0
#define READY 1
#define SLEEP 2

// Message buffer
typedef struct
{
	int sender_id;
	int len;
	int *data;
} message;

// Task control block
typedef struct
{
	func *func;
	int *sp;
	int status;

	message msg;
	queue wait_queue;

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
		init_queue(&(tcb_tbl[i].wait_queue));
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

int zk_get_id()
{
	return cur_task_id;
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

int zk_switch()
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

int zk_wakeup(int task_id)
{
	tcb_tbl[task_id].status = READY;
	return 0;
}

// Message API

int zk_send(int task_id, message *msg)
{
	tcb *task = &tcb_tbl[task_id];

	if (task->status != SLEEP)
	{
		enqueue(&(task->wait_queue), cur_task_id);
		zk_sleep();
	}

	msg->sender_id = cur_task_id;
	memcpy(&(task->msg), msg, 6);
	zk_wakeup(task_id);

	return 0;
}

int zk_recv(message *msg)
{
	int wait = dequeue(&(cur_task->wait_queue));
	if (wait != -1)
	{
		zk_wakeup(wait);
	}
	zk_sleep();

	memcpy(msg, &(cur_task->msg), 6);
	return 0;
}