#define NULL 0

int memset(int *addr, int data, int len)
{
	char *p = addr;
	for (; len > 0; len = len - 1)
	{
		*p = data;
		p = p + 1;
	}
	return addr;
}

int memcpy(int *dst, int *src, int len)
{
	char *d = dst;
	char *s = src;
	for (; len > 0; len = len - 1)
	{
		*d = *s;
		d = d + 1;
		s = s + 1;
	}
	return dst;
}

int memcmp(char *addr1, char *addr2, int len)
{
	char *p1 = addr1;
	char *p2 = addr2;
	for (; len > 0; len = len - 1)
	{
		if (*p1 != *p2)
		{
			if (*p1 > *p2)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
		p1 = p1 + 1;
		p2 = p2 + 1;
	}
	return 0;
}

int strlen(char *s)
{
	int len;
	for (len = 0; *s > 0; s = s + 1)
	{
		len = len + 1;
	}
	return len;
}

char *strcpy(char *dst, char *src)
{
	char *d = dst;
	char *s = src;
	for (;;)
	{
		*d = *s;
		if (!*s)
			break;
		d = d + 1;
		s = s + 1;
	}
	return dst;
}

int strcmp(char *s1, char *s2)
{
	while (*s1 || *s2)
	{
		if (*s1 != *s2)
		{
			if (*s1 > *s2)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
		s1 = s1 + 1;
		s2 = s2 + 1;
	}
	return 0;
}

int strncmp(char *s1, char *s2, int len)
{
	while ((*s1 || *s2) && (len > 0))
	{
		if (*s1 != *s2)
		{
			if (*s1 > *s2)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
		s1 = s1 + 1;
		s2 = s2 + 1;
		len = len - 1;
	}
	return 0;
}

// int2string
// string2int
