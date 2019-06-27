
#include <inc/lib.h>

void
exit(void)
{
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	close_all();
	sys_env_destroy(0);
}

