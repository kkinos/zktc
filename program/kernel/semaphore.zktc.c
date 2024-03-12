#define MAX_SEM_NUM 5

typedef struct
{
	int cnt;
	int wait_task;
} semcb;

semcb semcb_tbl[MAX_SEM_NUM];

int sem_num;

int init_sem()
{
	sem_num = 0;
	for (int i = 0; i < MAX_SEM_NUM; i = i + 1)
	{
		semcb_tbl[i].cnt = 1;
		semcb_tbl[i].wait_task = -1;
	}
	return 0;
}

// Semaphore API

int zk_create_sem()
{
	if (sem_num + 1 <= MAX_SEM_NUM)
	{
		int sem_id = sem_num;
		sem_num = sem_num + 1;
		return sem_id;
	}

	return -1;
}

int zk_get_sem(int sem_id)
{
	semcb *p = &semcb_tbl[sem_id];

	if (p->cnt == 0)
	{
		p->wait_task = cur_task_id;
		zk_sleep();
	}

	p->cnt = 0;
	return 0;
}

int zk_release_sem(int sem_id)
{
	semcb *p = &semcb_tbl[sem_id];
	p->cnt = 1;

	if (p->wait_task != -1)
	{
		tcb_tbl[p->wait_task].status = READY;
		p->wait_task = -1;
	}

	return 0;
}