/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(DIVIDE_HANDLER   , T_DIVIDE )
	TRAPHANDLER_NOEC(DEBUG_HANDLER    , T_DEBUG  )
	TRAPHANDLER_NOEC(NMI_HANDLER      , T_NMI    )
	TRAPHANDLER_NOEC(BRKPT_HANDLER    , T_BRKPT  )
	TRAPHANDLER_NOEC(OFLOW_HANDLER    , T_OFLOW  )
	TRAPHANDLER_NOEC(BOUND_HANDLER    , T_BOUND  )
	TRAPHANDLER_NOEC(ILLOP_HANDLER    , T_ILLOP  )
	TRAPHANDLER_NOEC(DEVICE_HANDLER   , T_DEVICE )
	TRAPHANDLER(	 DBLFLT_HANDLER   , T_DBLFLT )
	TRAPHANDLER(	 TSS_HANDLER      , T_TSS	 )
	TRAPHANDLER(	 SEGNP_HANDLER    , T_SEGNP  )
	TRAPHANDLER(	 STACK_HANDLER    , T_STACK  )
	TRAPHANDLER(	 GPFLT_HANDLER    , T_GPFLT  )
	TRAPHANDLER(	 PGFLT_HANDLER    , T_PGFLT  )
	TRAPHANDLER_NOEC(FPERR_HANDLER 	  , T_FPERR  )
	TRAPHANDLER(	 ALIGN_HANDLER    , T_ALIGN  )
	TRAPHANDLER_NOEC(MCHK_HANDLER     , T_MCHK   )
	TRAPHANDLER_NOEC(SIMDERR_HANDLER  , T_SIMDERR)
	; TRAPHANDLER_NOEC(SYSCALL_HANDLER, T_SYSCALL) /* just test*/

/*
 * Lab 3: Your code here for _alltraps
 */

.globl _alltraps
_alltraps:
	pushw $0
	pushw %ds 
	pushw $0
	pushw %es 
	pushal

	movl $(GD_KD), %eax 
	movw %ax, %ds 
	movw %ax, %es 

	pushl %esp 
	call trap

.global sysenter_handler
sysenter_handler:
	pushl %esi 
	pushl %edi
	pushl %ebx
	pushl %ecx 
	pushl %edx
	pushl %eax
	call syscall
	movl %esi, %edx
	movl %ebp, %ecx 
	sysexit