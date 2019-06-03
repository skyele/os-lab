// test user-level fault handler -- alloc pages to fix faults

#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
	cprintf("in %s\n", __FUNCTION__);//just test
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;
	int t = read_eflags();
	if (read_eflags() & FL_IOPL_3)
		cprintf("eflags wrong\n");
	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

	// cprintf("the read_eflags is 0x%x -- FL_IOPL_3: 0x%x\n", read_eflags(), FL_IOPL_3);
        cprintf("%s: made it here --- bug\n");
}
