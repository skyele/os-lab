// test user-level fault handler -- just exit when we fault

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
	cprintf("in faultdie %s\n", __FUNCTION__);
	void *addr = (void*)utf->utf_fault_va;
	cprintf("1ha?\n");
	uint32_t err = utf->utf_err;
	cprintf("2ha?\n");
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
	sys_env_destroy(sys_getenvid());
}

void
umain(int argc, char **argv)
{
	set_pgfault_handler(handler);
	*(int*)0xDeadBeef = 0;
}
