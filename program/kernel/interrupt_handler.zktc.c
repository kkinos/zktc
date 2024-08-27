#define MAX_HANDLER_NUM 5

// Handler status
#define NO_HANDLER 0
#define READY 1

// Handler
typedef struct
{
	func *func;
	int status;

} handler;

handler handlers[MAX_HANDLER_NUM];

int switch_interrupt_handler(int interrupt_num)
{
	if (interrupt_num >= MAX_HANDLER_NUM)
	{
		return 0;
	}

	handler *h = &handlers[interrupt_num];
	if ((h->status == READY))
	{
		*(h->func);
	}

	return 0;
}

// Interrupt handler API

int zk_set_interrupt_handler(func *func, int interrupt_num)
{
	if (interrupt_num >= MAX_HANDLER_NUM)
	{
		return -1;
	}

	handler *h = &handlers[interrupt_num];

	h->func = func;
	h->status = READY;

	return 0;
}