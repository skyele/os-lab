// test user-level fault handler -- alloc pages to fix faults
// doesn't work because we sys_cputs instead of cprintf (exercise: why?)

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
	cprintf("in faultallocbadddddddddddddddddddddd %s\n", __FUNCTION__);
	int r;
	void *addr = (void*)utf->utf_fault_va;

	cprintf("fault %x\n", addr);
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
}

void
umain(int argc, char **argv)
{
	cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
	cprintf("before set_pgfault_handler() in %s\n", __FUNCTION__);
	set_pgfault_handler(handler);
	cprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
	cprintf("before sys_cputs() in %s\n", __FUNCTION__);
	sys_cputs((char*)0xDEADBEEF, 4);
}
