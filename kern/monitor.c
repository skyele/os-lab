// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line

struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display a listing of function call frames for debugging", mon_backtrace },
	{ "time", "Display the execution time of a function", mon_time },
	{ "showmappings", "Display the physical page mappings that apply to a range of virtual address", mon_showmappings}
};

int command_size = 4;
/***** Implementations of basic kernel monitor commands *****/
static long atol(const char *nptr);

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	uint32_t *the_ebp = (uint32_t *)read_ebp();
	while(the_ebp != NULL){
		struct Eipdebuginfo info;
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
		debuginfo_eip(the_ebp[1], &info);
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
		the_ebp = (uint32_t *)*the_ebp;
	}
    cprintf("Backtrace success\n");
	return 0;
}

int 
mon_time(int argc, char **argv, struct Trapframe *tf){
	cycles_t start = 0;
	char *fun_n = argv[1];

	if(argc != 2)
		return -1;
	for(int i = 0; i < command_size; i++){
		if(strcmp(commands[i].name, fun_n) == 0){
			start = currentcycles();
			commands[i].func(argc-2, argv + 2, tf);
		}		
	}
	cycles_t end = currentcycles();
	cprintf("%s cycles: %ul\n", fun_n, end - start);
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
	if(argc != 3){
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
		return 0;
	}
	uint32_t low_va = 0, high_va = 0, old_va;
	if(argv[1][0]!='0'||argv[1][1]!='x'||argv[2][0]!='0'||argv[2][1]!='x'){
		cprintf("the virtual-address should be 16-base\n");
		return 0;
	}

	char *tmp;
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
	low_va = low_va/PGSIZE * PGSIZE;
	high_va = high_va/PGSIZE * PGSIZE;
	if(low_va > high_va){
		cprintf("the start-va should < the end-va\n");
		return 0;
	}
    while (low_va <= high_va) {
        pde_t *pde = &kern_pgdir[PDX(low_va)];
        if (*pde) {
			char p_bit,u_bit,w_bit,a_bit,d_bit,g_bit;
            if (low_va < (uint32_t)KERNBASE) {
                pte_t *pte = (pte_t*)(PTE_ADDR(*pde)+KERNBASE);
				if(pte[PTX(low_va)] & PTE_P){
					p_bit = pte[PTX(low_va)] & PTE_P;
					u_bit = pte[PTX(low_va)] & PTE_U;
					w_bit = pte[PTX(low_va)] & PTE_W;
					a_bit = pte[PTX(low_va)] & PTE_A;
					d_bit = pte[PTX(low_va)] & PTE_D;
					g_bit = pte[PTX(low_va)] & PTE_G;

					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
				}
				old_va = low_va;
				low_va += PGSIZE;
				if(low_va <= old_va)
					break;
                continue;
            }
			else{
				p_bit = *pde & PTE_P;
				u_bit = *pde & PTE_U;
				w_bit = *pde & PTE_W;
				a_bit = *pde & PTE_A;
				d_bit = *pde & PTE_D;
				g_bit = *pde & PTE_G;

				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
				old_va = low_va;
				low_va += PTSIZE;
				if(low_va <= old_va)
					break;
				continue;
			}
        }
        old_va = low_va;
		low_va += PTSIZE;
		if(low_va <= old_va)
			break;
    }
    return 0;
}

/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}

cycles_t currentcycles() {
    cycles_t result;
    __asm__ __volatile__("rdtsc" : "=A" (result));
    return result;
}

static long atol(const char *nptr)  
{  
        int c;              /* current char */  
        long total;         /* current total */  
        int sign;           /* if '-', then negative, otherwise positive */  
  
        /* skip whitespace */  
        while ( (char)*nptr == ' ' || (char)*nptr == '\n' || (char)*nptr == '\t'|| (char)*nptr == '\f'|| (char)*nptr == '\b')  
            ++nptr;  
  
        c = (int)(unsigned char)*nptr++;  
        sign = c;           /* save sign indication */  
        if (c == '-' || c == '+')  
            c = (int)(unsigned char)*nptr++;    /* skip sign */  
  
        total = 0;  
  
        while ((c-'0')>=0 &&(c-'0')<=9) {  
            total = 10 * total + (c - '0');     /* accumulate digit */  
            c = (int)(unsigned char)*nptr++;    /* get next char */  
        }  
  
        if (sign == '-')  
            return -total;  
        else  
            return total;   /* return result, negated if necessary */  
}  