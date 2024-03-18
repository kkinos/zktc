#define QUEUE_SIZE 5

typedef struct
{
	int head;
	int tail;
	int data[QUEUE_SIZE];
} queue;

int init_queue(queue *q)
{
	q->head = 0;
	q->tail = -1;
	return 0;
}

int enqueue(queue *q, int x)
{
	if (((q->tail + 2) % QUEUE_SIZE) == q->head)
	{
		return -1;
	}

	q->data[(q->tail + 1) % QUEUE_SIZE] = x;
	q->tail = (q->tail + 1) % QUEUE_SIZE;

	return 0;
}

int dequeue(queue *q)
{
	if ((q->tail + 1) % QUEUE_SIZE == q->head)
	{
		return -1;
	}

	int r = q->data[q->head];
	q->head = (q->head + 1) % QUEUE_SIZE;

	return r;
}