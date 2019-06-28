
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 c0 16 00       	mov    $0x16c000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl	%cr4, %eax
f010001d:	0f 20 e0             	mov    %cr4,%eax
	orl	$(CR4_PSE), %eax
f0100020:	83 c8 10             	or     $0x10,%eax
	movl	%eax, %cr4
f0100023:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl	%cr0, %eax
f0100026:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100029:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f010002e:	0f 22 c0             	mov    %eax,%cr0
	# Turn on page size extension.

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100031:	b8 38 00 10 f0       	mov    $0xf0100038,%eax
	jmp	*%eax
f0100036:	ff e0                	jmp    *%eax

f0100038 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f0100038:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f010003d:	bc 00 a0 12 f0       	mov    $0xf012a000,%esp

	# now to C code
	call	i386_init
f0100042:	e8 5e 00 00 00       	call   f01000a5 <i386_init>

f0100047 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f0100047:	eb fe                	jmp    f0100047 <spin>

f0100049 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100049:	55                   	push   %ebp
f010004a:	89 e5                	mov    %esp,%ebp
f010004c:	56                   	push   %esi
f010004d:	53                   	push   %ebx
f010004e:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100051:	83 3d 80 ed 5d f0 00 	cmpl   $0x0,0xf05ded80
f0100058:	74 0f                	je     f0100069 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010005a:	83 ec 0c             	sub    $0xc,%esp
f010005d:	6a 00                	push   $0x0
f010005f:	e8 66 0c 00 00       	call   f0100cca <monitor>
f0100064:	83 c4 10             	add    $0x10,%esp
f0100067:	eb f1                	jmp    f010005a <_panic+0x11>
	panicstr = fmt;
f0100069:	89 35 80 ed 5d f0    	mov    %esi,0xf05ded80
	asm volatile("cli; cld");
f010006f:	fa                   	cli    
f0100070:	fc                   	cld    
	va_start(ap, fmt);
f0100071:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100074:	e8 91 6e 00 00       	call   f0106f0a <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 20 80 10 f0       	push   $0xf0108020
f0100085:	e8 6c 41 00 00       	call   f01041f6 <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 3c 41 00 00       	call   f01041d0 <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 7b 95 10 f0 	movl   $0xf010957b,(%esp)
f010009b:	e8 56 41 00 00       	call   f01041f6 <cprintf>
f01000a0:	83 c4 10             	add    $0x10,%esp
f01000a3:	eb b5                	jmp    f010005a <_panic+0x11>

f01000a5 <i386_init>:
{
f01000a5:	55                   	push   %ebp
f01000a6:	89 e5                	mov    %esp,%ebp
f01000a8:	56                   	push   %esi
f01000a9:	53                   	push   %ebx
	cons_init();
f01000aa:	e8 37 06 00 00       	call   f01006e6 <cons_init>
	cprintf("in %s\n", __FUNCTION__);
f01000af:	83 ec 08             	sub    $0x8,%esp
f01000b2:	68 68 81 10 f0       	push   $0xf0108168
f01000b7:	68 bc 80 10 f0       	push   $0xf01080bc
f01000bc:	e8 35 41 00 00       	call   f01041f6 <cprintf>
	cprintf("pading space in the right to number 22: %-8d.\n", 22);
f01000c1:	83 c4 08             	add    $0x8,%esp
f01000c4:	6a 16                	push   $0x16
f01000c6:	68 44 80 10 f0       	push   $0xf0108044
f01000cb:	e8 26 41 00 00       	call   f01041f6 <cprintf>
	cprintf("%n", NULL);
f01000d0:	83 c4 08             	add    $0x8,%esp
f01000d3:	6a 00                	push   $0x0
f01000d5:	68 c3 80 10 f0       	push   $0xf01080c3
f01000da:	e8 17 41 00 00       	call   f01041f6 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000df:	83 c4 0c             	add    $0xc,%esp
f01000e2:	68 00 fc ff ff       	push   $0xfffffc00
f01000e7:	68 00 04 00 00       	push   $0x400
f01000ec:	68 c6 80 10 f0       	push   $0xf01080c6
f01000f1:	e8 00 41 00 00       	call   f01041f6 <cprintf>
	mem_init();
f01000f6:	e8 c0 16 00 00       	call   f01017bb <mem_init>
	cprintf("after mem_init()\n");
f01000fb:	c7 04 24 e2 80 10 f0 	movl   $0xf01080e2,(%esp)
f0100102:	e8 ef 40 00 00       	call   f01041f6 <cprintf>
	env_init();
f0100107:	e8 47 36 00 00       	call   f0103753 <env_init>
	cprintf("after env_init()\n");
f010010c:	c7 04 24 f4 80 10 f0 	movl   $0xf01080f4,(%esp)
f0100113:	e8 de 40 00 00       	call   f01041f6 <cprintf>
	trap_init();
f0100118:	e8 cf 41 00 00       	call   f01042ec <trap_init>

static inline uint32_t
read_esp(void)
{
	uint32_t esp;
	asm volatile("movl %%esp,%0" : "=r" (esp));
f010011d:	89 e3                	mov    %esp,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010011f:	89 ee                	mov    %ebp,%esi
	memmove((void*)(KSTACKTOP-KSTKSIZE), bootstack, KSTKSIZE);
f0100121:	83 c4 0c             	add    $0xc,%esp
f0100124:	68 00 80 00 00       	push   $0x8000
f0100129:	68 00 20 12 f0       	push   $0xf0122000
f010012e:	68 00 80 ff ef       	push   $0xefff8000
f0100133:	e8 14 68 00 00       	call   f010694c <memmove>
	uint32_t off = KSTACKTOP - KSTKSIZE - (uint32_t)bootstack;
f0100138:	b8 00 80 ff ef       	mov    $0xefff8000,%eax
f010013d:	2d 00 20 12 f0       	sub    $0xf0122000,%eax
	esp += off;
f0100142:	01 c3                	add    %eax,%ebx
	asm volatile("movl %0, %%esp"::"r"(esp):);
f0100144:	89 dc                	mov    %ebx,%esp
	ebp += off;
f0100146:	01 f0                	add    %esi,%eax
	asm volatile("movl %0, %%ebp"::"r"(ebp):);
f0100148:	89 c5                	mov    %eax,%ebp
	mp_init();
f010014a:	e8 c4 6a 00 00       	call   f0106c13 <mp_init>
	cprintf("after mp_init()\n");
f010014f:	c7 04 24 06 81 10 f0 	movl   $0xf0108106,(%esp)
f0100156:	e8 9b 40 00 00       	call   f01041f6 <cprintf>
	lapic_init();
f010015b:	e8 c0 6d 00 00       	call   f0106f20 <lapic_init>
	pic_init();
f0100160:	e8 96 3f 00 00       	call   f01040fb <pic_init>
	time_init();
f0100165:	e8 0a 7c 00 00       	call   f0107d74 <time_init>
	pci_init();
f010016a:	e8 e5 7b 00 00       	call   f0107d54 <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010016f:	c7 04 24 20 d3 16 f0 	movl   $0xf016d320,(%esp)
f0100176:	e8 18 70 00 00       	call   f0107193 <spin_lock>
	cprintf("in %s\n", __FUNCTION__);
f010017b:	83 c4 08             	add    $0x8,%esp
f010017e:	68 5c 81 10 f0       	push   $0xf010815c
f0100183:	68 bc 80 10 f0       	push   $0xf01080bc
f0100188:	e8 69 40 00 00       	call   f01041f6 <cprintf>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010018d:	83 c4 10             	add    $0x10,%esp
f0100190:	83 3d 88 ed 5d f0 07 	cmpl   $0x7,0xf05ded88
f0100197:	76 27                	jbe    f01001c0 <i386_init+0x11b>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100199:	83 ec 04             	sub    $0x4,%esp
f010019c:	b8 76 6b 10 f0       	mov    $0xf0106b76,%eax
f01001a1:	2d f4 6a 10 f0       	sub    $0xf0106af4,%eax
f01001a6:	50                   	push   %eax
f01001a7:	68 f4 6a 10 f0       	push   $0xf0106af4
f01001ac:	68 00 70 00 f0       	push   $0xf0007000
f01001b1:	e8 96 67 00 00       	call   f010694c <memmove>
f01001b6:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f01001b9:	bb 20 b0 16 f0       	mov    $0xf016b020,%ebx
f01001be:	eb 19                	jmp    f01001d9 <i386_init+0x134>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01001c0:	68 00 70 00 00       	push   $0x7000
f01001c5:	68 74 80 10 f0       	push   $0xf0108074
f01001ca:	6a 7f                	push   $0x7f
f01001cc:	68 17 81 10 f0       	push   $0xf0108117
f01001d1:	e8 73 fe ff ff       	call   f0100049 <_panic>
f01001d6:	83 c3 74             	add    $0x74,%ebx
f01001d9:	6b 05 98 ed 5d f0 74 	imul   $0x74,0xf05ded98,%eax
f01001e0:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01001e5:	39 c3                	cmp    %eax,%ebx
f01001e7:	73 4d                	jae    f0100236 <i386_init+0x191>
		if (c == cpus + cpunum())  // We've started already.
f01001e9:	e8 1c 6d 00 00       	call   f0106f0a <cpunum>
f01001ee:	6b c0 74             	imul   $0x74,%eax,%eax
f01001f1:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01001f6:	39 c3                	cmp    %eax,%ebx
f01001f8:	74 dc                	je     f01001d6 <i386_init+0x131>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f01001fa:	89 d8                	mov    %ebx,%eax
f01001fc:	2d 20 b0 16 f0       	sub    $0xf016b020,%eax
f0100201:	c1 f8 02             	sar    $0x2,%eax
f0100204:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010020a:	c1 e0 0f             	shl    $0xf,%eax
f010020d:	8d 80 00 30 13 f0    	lea    -0xfecd000(%eax),%eax
f0100213:	a3 84 ed 5d f0       	mov    %eax,0xf05ded84
		lapic_startap(c->cpu_id, PADDR(code));
f0100218:	83 ec 08             	sub    $0x8,%esp
f010021b:	68 00 70 00 00       	push   $0x7000
f0100220:	0f b6 03             	movzbl (%ebx),%eax
f0100223:	50                   	push   %eax
f0100224:	e8 62 6e 00 00       	call   f010708b <lapic_startap>
f0100229:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f010022c:	8b 43 04             	mov    0x4(%ebx),%eax
f010022f:	83 f8 01             	cmp    $0x1,%eax
f0100232:	75 f8                	jne    f010022c <i386_init+0x187>
f0100234:	eb a0                	jmp    f01001d6 <i386_init+0x131>
	ENV_CREATE(TEST, TEST_ENV_TYPE);
f0100236:	83 ec 08             	sub    $0x8,%esp
f0100239:	6a 01                	push   $0x1
f010023b:	68 58 40 5c f0       	push   $0xf05c4058
f0100240:	e8 60 39 00 00       	call   f0103ba5 <env_create>
	kbd_intr();
f0100245:	e8 47 04 00 00       	call   f0100691 <kbd_intr>
	sched_yield();
f010024a:	e8 5f 4e 00 00       	call   f01050ae <sched_yield>

f010024f <mp_main>:
{
f010024f:	55                   	push   %ebp
f0100250:	89 e5                	mov    %esp,%ebp
f0100252:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f0100255:	68 54 81 10 f0       	push   $0xf0108154
f010025a:	68 bc 80 10 f0       	push   $0xf01080bc
f010025f:	e8 92 3f 00 00       	call   f01041f6 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0100264:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0100269:	83 c4 10             	add    $0x10,%esp
f010026c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100271:	76 52                	jbe    f01002c5 <mp_main+0x76>
	return (physaddr_t)kva - KERNBASE;
f0100273:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100278:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f010027b:	e8 8a 6c 00 00       	call   f0106f0a <cpunum>
f0100280:	83 ec 08             	sub    $0x8,%esp
f0100283:	50                   	push   %eax
f0100284:	68 23 81 10 f0       	push   $0xf0108123
f0100289:	e8 68 3f 00 00       	call   f01041f6 <cprintf>
	lapic_init();
f010028e:	e8 8d 6c 00 00       	call   f0106f20 <lapic_init>
	env_init_percpu();
f0100293:	e8 8f 34 00 00       	call   f0103727 <env_init_percpu>
	trap_init_percpu();
f0100298:	e8 6d 3f 00 00       	call   f010420a <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f010029d:	e8 68 6c 00 00       	call   f0106f0a <cpunum>
f01002a2:	6b d0 74             	imul   $0x74,%eax,%edx
f01002a5:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01002a8:	b8 01 00 00 00       	mov    $0x1,%eax
f01002ad:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
f01002b4:	c7 04 24 20 d3 16 f0 	movl   $0xf016d320,(%esp)
f01002bb:	e8 d3 6e 00 00       	call   f0107193 <spin_lock>
	sched_yield();
f01002c0:	e8 e9 4d 00 00       	call   f01050ae <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01002c5:	50                   	push   %eax
f01002c6:	68 98 80 10 f0       	push   $0xf0108098
f01002cb:	68 97 00 00 00       	push   $0x97
f01002d0:	68 17 81 10 f0       	push   $0xf0108117
f01002d5:	e8 6f fd ff ff       	call   f0100049 <_panic>

f01002da <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002da:	55                   	push   %ebp
f01002db:	89 e5                	mov    %esp,%ebp
f01002dd:	53                   	push   %ebx
f01002de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01002e1:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002e4:	ff 75 0c             	pushl  0xc(%ebp)
f01002e7:	ff 75 08             	pushl  0x8(%ebp)
f01002ea:	68 39 81 10 f0       	push   $0xf0108139
f01002ef:	e8 02 3f 00 00       	call   f01041f6 <cprintf>
	vcprintf(fmt, ap);
f01002f4:	83 c4 08             	add    $0x8,%esp
f01002f7:	53                   	push   %ebx
f01002f8:	ff 75 10             	pushl  0x10(%ebp)
f01002fb:	e8 d0 3e 00 00       	call   f01041d0 <vcprintf>
	cprintf("\n");
f0100300:	c7 04 24 7b 95 10 f0 	movl   $0xf010957b,(%esp)
f0100307:	e8 ea 3e 00 00       	call   f01041f6 <cprintf>
	va_end(ap);
}
f010030c:	83 c4 10             	add    $0x10,%esp
f010030f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100312:	c9                   	leave  
f0100313:	c3                   	ret    

f0100314 <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100314:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100319:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010031a:	a8 01                	test   $0x1,%al
f010031c:	74 0a                	je     f0100328 <serial_proc_data+0x14>
f010031e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100323:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100324:	0f b6 c0             	movzbl %al,%eax
f0100327:	c3                   	ret    
		return -1;
f0100328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f010032d:	c3                   	ret    

f010032e <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010032e:	55                   	push   %ebp
f010032f:	89 e5                	mov    %esp,%ebp
f0100331:	53                   	push   %ebx
f0100332:	83 ec 04             	sub    $0x4,%esp
f0100335:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100337:	ff d3                	call   *%ebx
f0100339:	83 f8 ff             	cmp    $0xffffffff,%eax
f010033c:	74 29                	je     f0100367 <cons_intr+0x39>
		if (c == 0)
f010033e:	85 c0                	test   %eax,%eax
f0100340:	74 f5                	je     f0100337 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100342:	8b 0d 24 d9 5d f0    	mov    0xf05dd924,%ecx
f0100348:	8d 51 01             	lea    0x1(%ecx),%edx
f010034b:	88 81 20 d7 5d f0    	mov    %al,-0xfa228e0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100351:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f0100357:	b8 00 00 00 00       	mov    $0x0,%eax
f010035c:	0f 44 d0             	cmove  %eax,%edx
f010035f:	89 15 24 d9 5d f0    	mov    %edx,0xf05dd924
f0100365:	eb d0                	jmp    f0100337 <cons_intr+0x9>
	}
}
f0100367:	83 c4 04             	add    $0x4,%esp
f010036a:	5b                   	pop    %ebx
f010036b:	5d                   	pop    %ebp
f010036c:	c3                   	ret    

f010036d <kbd_proc_data>:
{
f010036d:	55                   	push   %ebp
f010036e:	89 e5                	mov    %esp,%ebp
f0100370:	53                   	push   %ebx
f0100371:	83 ec 04             	sub    $0x4,%esp
f0100374:	ba 64 00 00 00       	mov    $0x64,%edx
f0100379:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f010037a:	a8 01                	test   $0x1,%al
f010037c:	0f 84 f2 00 00 00    	je     f0100474 <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f0100382:	a8 20                	test   $0x20,%al
f0100384:	0f 85 f1 00 00 00    	jne    f010047b <kbd_proc_data+0x10e>
f010038a:	ba 60 00 00 00       	mov    $0x60,%edx
f010038f:	ec                   	in     (%dx),%al
f0100390:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100392:	3c e0                	cmp    $0xe0,%al
f0100394:	74 61                	je     f01003f7 <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f0100396:	84 c0                	test   %al,%al
f0100398:	78 70                	js     f010040a <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f010039a:	8b 0d 00 d7 5d f0    	mov    0xf05dd700,%ecx
f01003a0:	f6 c1 40             	test   $0x40,%cl
f01003a3:	74 0e                	je     f01003b3 <kbd_proc_data+0x46>
		data |= 0x80;
f01003a5:	83 c8 80             	or     $0xffffff80,%eax
f01003a8:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01003aa:	83 e1 bf             	and    $0xffffffbf,%ecx
f01003ad:	89 0d 00 d7 5d f0    	mov    %ecx,0xf05dd700
	shift |= shiftcode[data];
f01003b3:	0f b6 d2             	movzbl %dl,%edx
f01003b6:	0f b6 82 c0 82 10 f0 	movzbl -0xfef7d40(%edx),%eax
f01003bd:	0b 05 00 d7 5d f0    	or     0xf05dd700,%eax
	shift ^= togglecode[data];
f01003c3:	0f b6 8a c0 81 10 f0 	movzbl -0xfef7e40(%edx),%ecx
f01003ca:	31 c8                	xor    %ecx,%eax
f01003cc:	a3 00 d7 5d f0       	mov    %eax,0xf05dd700
	c = charcode[shift & (CTL | SHIFT)][data];
f01003d1:	89 c1                	mov    %eax,%ecx
f01003d3:	83 e1 03             	and    $0x3,%ecx
f01003d6:	8b 0c 8d a0 81 10 f0 	mov    -0xfef7e60(,%ecx,4),%ecx
f01003dd:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01003e1:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f01003e4:	a8 08                	test   $0x8,%al
f01003e6:	74 61                	je     f0100449 <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f01003e8:	89 da                	mov    %ebx,%edx
f01003ea:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f01003ed:	83 f9 19             	cmp    $0x19,%ecx
f01003f0:	77 4b                	ja     f010043d <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f01003f2:	83 eb 20             	sub    $0x20,%ebx
f01003f5:	eb 0c                	jmp    f0100403 <kbd_proc_data+0x96>
		shift |= E0ESC;
f01003f7:	83 0d 00 d7 5d f0 40 	orl    $0x40,0xf05dd700
		return 0;
f01003fe:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100403:	89 d8                	mov    %ebx,%eax
f0100405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100408:	c9                   	leave  
f0100409:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010040a:	8b 0d 00 d7 5d f0    	mov    0xf05dd700,%ecx
f0100410:	89 cb                	mov    %ecx,%ebx
f0100412:	83 e3 40             	and    $0x40,%ebx
f0100415:	83 e0 7f             	and    $0x7f,%eax
f0100418:	85 db                	test   %ebx,%ebx
f010041a:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010041d:	0f b6 d2             	movzbl %dl,%edx
f0100420:	0f b6 82 c0 82 10 f0 	movzbl -0xfef7d40(%edx),%eax
f0100427:	83 c8 40             	or     $0x40,%eax
f010042a:	0f b6 c0             	movzbl %al,%eax
f010042d:	f7 d0                	not    %eax
f010042f:	21 c8                	and    %ecx,%eax
f0100431:	a3 00 d7 5d f0       	mov    %eax,0xf05dd700
		return 0;
f0100436:	bb 00 00 00 00       	mov    $0x0,%ebx
f010043b:	eb c6                	jmp    f0100403 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f010043d:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100440:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100443:	83 fa 1a             	cmp    $0x1a,%edx
f0100446:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100449:	f7 d0                	not    %eax
f010044b:	a8 06                	test   $0x6,%al
f010044d:	75 b4                	jne    f0100403 <kbd_proc_data+0x96>
f010044f:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100455:	75 ac                	jne    f0100403 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f0100457:	83 ec 0c             	sub    $0xc,%esp
f010045a:	68 72 81 10 f0       	push   $0xf0108172
f010045f:	e8 92 3d 00 00       	call   f01041f6 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100464:	b8 03 00 00 00       	mov    $0x3,%eax
f0100469:	ba 92 00 00 00       	mov    $0x92,%edx
f010046e:	ee                   	out    %al,(%dx)
f010046f:	83 c4 10             	add    $0x10,%esp
f0100472:	eb 8f                	jmp    f0100403 <kbd_proc_data+0x96>
		return -1;
f0100474:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100479:	eb 88                	jmp    f0100403 <kbd_proc_data+0x96>
		return -1;
f010047b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100480:	eb 81                	jmp    f0100403 <kbd_proc_data+0x96>

f0100482 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100482:	55                   	push   %ebp
f0100483:	89 e5                	mov    %esp,%ebp
f0100485:	57                   	push   %edi
f0100486:	56                   	push   %esi
f0100487:	53                   	push   %ebx
f0100488:	83 ec 1c             	sub    $0x1c,%esp
f010048b:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f010048d:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100492:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100497:	bb 84 00 00 00       	mov    $0x84,%ebx
f010049c:	89 fa                	mov    %edi,%edx
f010049e:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f010049f:	a8 20                	test   $0x20,%al
f01004a1:	75 13                	jne    f01004b6 <cons_putc+0x34>
f01004a3:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01004a9:	7f 0b                	jg     f01004b6 <cons_putc+0x34>
f01004ab:	89 da                	mov    %ebx,%edx
f01004ad:	ec                   	in     (%dx),%al
f01004ae:	ec                   	in     (%dx),%al
f01004af:	ec                   	in     (%dx),%al
f01004b0:	ec                   	in     (%dx),%al
	     i++)
f01004b1:	83 c6 01             	add    $0x1,%esi
f01004b4:	eb e6                	jmp    f010049c <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f01004b6:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004be:	89 c8                	mov    %ecx,%eax
f01004c0:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004c1:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004c6:	bf 79 03 00 00       	mov    $0x379,%edi
f01004cb:	bb 84 00 00 00       	mov    $0x84,%ebx
f01004d0:	89 fa                	mov    %edi,%edx
f01004d2:	ec                   	in     (%dx),%al
f01004d3:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01004d9:	7f 0f                	jg     f01004ea <cons_putc+0x68>
f01004db:	84 c0                	test   %al,%al
f01004dd:	78 0b                	js     f01004ea <cons_putc+0x68>
f01004df:	89 da                	mov    %ebx,%edx
f01004e1:	ec                   	in     (%dx),%al
f01004e2:	ec                   	in     (%dx),%al
f01004e3:	ec                   	in     (%dx),%al
f01004e4:	ec                   	in     (%dx),%al
f01004e5:	83 c6 01             	add    $0x1,%esi
f01004e8:	eb e6                	jmp    f01004d0 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004ea:	ba 78 03 00 00       	mov    $0x378,%edx
f01004ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f01004f3:	ee                   	out    %al,(%dx)
f01004f4:	ba 7a 03 00 00       	mov    $0x37a,%edx
f01004f9:	b8 0d 00 00 00       	mov    $0xd,%eax
f01004fe:	ee                   	out    %al,(%dx)
f01004ff:	b8 08 00 00 00       	mov    $0x8,%eax
f0100504:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f0100505:	89 ca                	mov    %ecx,%edx
f0100507:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f010050d:	89 c8                	mov    %ecx,%eax
f010050f:	80 cc 07             	or     $0x7,%ah
f0100512:	85 d2                	test   %edx,%edx
f0100514:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f0100517:	0f b6 c1             	movzbl %cl,%eax
f010051a:	83 f8 09             	cmp    $0x9,%eax
f010051d:	0f 84 b0 00 00 00    	je     f01005d3 <cons_putc+0x151>
f0100523:	7e 73                	jle    f0100598 <cons_putc+0x116>
f0100525:	83 f8 0a             	cmp    $0xa,%eax
f0100528:	0f 84 98 00 00 00    	je     f01005c6 <cons_putc+0x144>
f010052e:	83 f8 0d             	cmp    $0xd,%eax
f0100531:	0f 85 d3 00 00 00    	jne    f010060a <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f0100537:	0f b7 05 28 d9 5d f0 	movzwl 0xf05dd928,%eax
f010053e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100544:	c1 e8 16             	shr    $0x16,%eax
f0100547:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010054a:	c1 e0 04             	shl    $0x4,%eax
f010054d:	66 a3 28 d9 5d f0    	mov    %ax,0xf05dd928
	if (crt_pos >= CRT_SIZE) {
f0100553:	66 81 3d 28 d9 5d f0 	cmpw   $0x7cf,0xf05dd928
f010055a:	cf 07 
f010055c:	0f 87 cb 00 00 00    	ja     f010062d <cons_putc+0x1ab>
	outb(addr_6845, 14);
f0100562:	8b 0d 30 d9 5d f0    	mov    0xf05dd930,%ecx
f0100568:	b8 0e 00 00 00       	mov    $0xe,%eax
f010056d:	89 ca                	mov    %ecx,%edx
f010056f:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100570:	0f b7 1d 28 d9 5d f0 	movzwl 0xf05dd928,%ebx
f0100577:	8d 71 01             	lea    0x1(%ecx),%esi
f010057a:	89 d8                	mov    %ebx,%eax
f010057c:	66 c1 e8 08          	shr    $0x8,%ax
f0100580:	89 f2                	mov    %esi,%edx
f0100582:	ee                   	out    %al,(%dx)
f0100583:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100588:	89 ca                	mov    %ecx,%edx
f010058a:	ee                   	out    %al,(%dx)
f010058b:	89 d8                	mov    %ebx,%eax
f010058d:	89 f2                	mov    %esi,%edx
f010058f:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100590:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100593:	5b                   	pop    %ebx
f0100594:	5e                   	pop    %esi
f0100595:	5f                   	pop    %edi
f0100596:	5d                   	pop    %ebp
f0100597:	c3                   	ret    
	switch (c & 0xff) {
f0100598:	83 f8 08             	cmp    $0x8,%eax
f010059b:	75 6d                	jne    f010060a <cons_putc+0x188>
		if (crt_pos > 0) {
f010059d:	0f b7 05 28 d9 5d f0 	movzwl 0xf05dd928,%eax
f01005a4:	66 85 c0             	test   %ax,%ax
f01005a7:	74 b9                	je     f0100562 <cons_putc+0xe0>
			crt_pos--;
f01005a9:	83 e8 01             	sub    $0x1,%eax
f01005ac:	66 a3 28 d9 5d f0    	mov    %ax,0xf05dd928
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01005b2:	0f b7 c0             	movzwl %ax,%eax
f01005b5:	b1 00                	mov    $0x0,%cl
f01005b7:	83 c9 20             	or     $0x20,%ecx
f01005ba:	8b 15 2c d9 5d f0    	mov    0xf05dd92c,%edx
f01005c0:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005c4:	eb 8d                	jmp    f0100553 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f01005c6:	66 83 05 28 d9 5d f0 	addw   $0x50,0xf05dd928
f01005cd:	50 
f01005ce:	e9 64 ff ff ff       	jmp    f0100537 <cons_putc+0xb5>
		cons_putc(' ');
f01005d3:	b8 20 00 00 00       	mov    $0x20,%eax
f01005d8:	e8 a5 fe ff ff       	call   f0100482 <cons_putc>
		cons_putc(' ');
f01005dd:	b8 20 00 00 00       	mov    $0x20,%eax
f01005e2:	e8 9b fe ff ff       	call   f0100482 <cons_putc>
		cons_putc(' ');
f01005e7:	b8 20 00 00 00       	mov    $0x20,%eax
f01005ec:	e8 91 fe ff ff       	call   f0100482 <cons_putc>
		cons_putc(' ');
f01005f1:	b8 20 00 00 00       	mov    $0x20,%eax
f01005f6:	e8 87 fe ff ff       	call   f0100482 <cons_putc>
		cons_putc(' ');
f01005fb:	b8 20 00 00 00       	mov    $0x20,%eax
f0100600:	e8 7d fe ff ff       	call   f0100482 <cons_putc>
f0100605:	e9 49 ff ff ff       	jmp    f0100553 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f010060a:	0f b7 05 28 d9 5d f0 	movzwl 0xf05dd928,%eax
f0100611:	8d 50 01             	lea    0x1(%eax),%edx
f0100614:	66 89 15 28 d9 5d f0 	mov    %dx,0xf05dd928
f010061b:	0f b7 c0             	movzwl %ax,%eax
f010061e:	8b 15 2c d9 5d f0    	mov    0xf05dd92c,%edx
f0100624:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f0100628:	e9 26 ff ff ff       	jmp    f0100553 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010062d:	a1 2c d9 5d f0       	mov    0xf05dd92c,%eax
f0100632:	83 ec 04             	sub    $0x4,%esp
f0100635:	68 00 0f 00 00       	push   $0xf00
f010063a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100640:	52                   	push   %edx
f0100641:	50                   	push   %eax
f0100642:	e8 05 63 00 00       	call   f010694c <memmove>
			crt_buf[i] = 0x0700 | ' ';
f0100647:	8b 15 2c d9 5d f0    	mov    0xf05dd92c,%edx
f010064d:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100653:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0100659:	83 c4 10             	add    $0x10,%esp
f010065c:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100661:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100664:	39 d0                	cmp    %edx,%eax
f0100666:	75 f4                	jne    f010065c <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f0100668:	66 83 2d 28 d9 5d f0 	subw   $0x50,0xf05dd928
f010066f:	50 
f0100670:	e9 ed fe ff ff       	jmp    f0100562 <cons_putc+0xe0>

f0100675 <serial_intr>:
	if (serial_exists)
f0100675:	80 3d 34 d9 5d f0 00 	cmpb   $0x0,0xf05dd934
f010067c:	75 01                	jne    f010067f <serial_intr+0xa>
f010067e:	c3                   	ret    
{
f010067f:	55                   	push   %ebp
f0100680:	89 e5                	mov    %esp,%ebp
f0100682:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100685:	b8 14 03 10 f0       	mov    $0xf0100314,%eax
f010068a:	e8 9f fc ff ff       	call   f010032e <cons_intr>
}
f010068f:	c9                   	leave  
f0100690:	c3                   	ret    

f0100691 <kbd_intr>:
{
f0100691:	55                   	push   %ebp
f0100692:	89 e5                	mov    %esp,%ebp
f0100694:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100697:	b8 6d 03 10 f0       	mov    $0xf010036d,%eax
f010069c:	e8 8d fc ff ff       	call   f010032e <cons_intr>
}
f01006a1:	c9                   	leave  
f01006a2:	c3                   	ret    

f01006a3 <cons_getc>:
{
f01006a3:	55                   	push   %ebp
f01006a4:	89 e5                	mov    %esp,%ebp
f01006a6:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01006a9:	e8 c7 ff ff ff       	call   f0100675 <serial_intr>
	kbd_intr();
f01006ae:	e8 de ff ff ff       	call   f0100691 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01006b3:	8b 15 20 d9 5d f0    	mov    0xf05dd920,%edx
	return 0;
f01006b9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f01006be:	3b 15 24 d9 5d f0    	cmp    0xf05dd924,%edx
f01006c4:	74 1e                	je     f01006e4 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f01006c6:	8d 4a 01             	lea    0x1(%edx),%ecx
f01006c9:	0f b6 82 20 d7 5d f0 	movzbl -0xfa228e0(%edx),%eax
			cons.rpos = 0;
f01006d0:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01006d6:	ba 00 00 00 00       	mov    $0x0,%edx
f01006db:	0f 44 ca             	cmove  %edx,%ecx
f01006de:	89 0d 20 d9 5d f0    	mov    %ecx,0xf05dd920
}
f01006e4:	c9                   	leave  
f01006e5:	c3                   	ret    

f01006e6 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01006e6:	55                   	push   %ebp
f01006e7:	89 e5                	mov    %esp,%ebp
f01006e9:	57                   	push   %edi
f01006ea:	56                   	push   %esi
f01006eb:	53                   	push   %ebx
f01006ec:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f01006ef:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006f6:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006fd:	5a a5 
	if (*cp != 0xA55A) {
f01006ff:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100706:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010070a:	0f 84 de 00 00 00    	je     f01007ee <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100710:	c7 05 30 d9 5d f0 b4 	movl   $0x3b4,0xf05dd930
f0100717:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010071a:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f010071f:	8b 3d 30 d9 5d f0    	mov    0xf05dd930,%edi
f0100725:	b8 0e 00 00 00       	mov    $0xe,%eax
f010072a:	89 fa                	mov    %edi,%edx
f010072c:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010072d:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100730:	89 ca                	mov    %ecx,%edx
f0100732:	ec                   	in     (%dx),%al
f0100733:	0f b6 c0             	movzbl %al,%eax
f0100736:	c1 e0 08             	shl    $0x8,%eax
f0100739:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010073b:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100740:	89 fa                	mov    %edi,%edx
f0100742:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100743:	89 ca                	mov    %ecx,%edx
f0100745:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f0100746:	89 35 2c d9 5d f0    	mov    %esi,0xf05dd92c
	pos |= inb(addr_6845 + 1);
f010074c:	0f b6 c0             	movzbl %al,%eax
f010074f:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f0100751:	66 a3 28 d9 5d f0    	mov    %ax,0xf05dd928
	kbd_intr();
f0100757:	e8 35 ff ff ff       	call   f0100691 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f010075c:	83 ec 0c             	sub    $0xc,%esp
f010075f:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f0100766:	25 fd ff 00 00       	and    $0xfffd,%eax
f010076b:	50                   	push   %eax
f010076c:	e8 0c 39 00 00       	call   f010407d <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100771:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100776:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f010077b:	89 d8                	mov    %ebx,%eax
f010077d:	89 ca                	mov    %ecx,%edx
f010077f:	ee                   	out    %al,(%dx)
f0100780:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100785:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010078a:	89 fa                	mov    %edi,%edx
f010078c:	ee                   	out    %al,(%dx)
f010078d:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100792:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100797:	ee                   	out    %al,(%dx)
f0100798:	be f9 03 00 00       	mov    $0x3f9,%esi
f010079d:	89 d8                	mov    %ebx,%eax
f010079f:	89 f2                	mov    %esi,%edx
f01007a1:	ee                   	out    %al,(%dx)
f01007a2:	b8 03 00 00 00       	mov    $0x3,%eax
f01007a7:	89 fa                	mov    %edi,%edx
f01007a9:	ee                   	out    %al,(%dx)
f01007aa:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01007af:	89 d8                	mov    %ebx,%eax
f01007b1:	ee                   	out    %al,(%dx)
f01007b2:	b8 01 00 00 00       	mov    $0x1,%eax
f01007b7:	89 f2                	mov    %esi,%edx
f01007b9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007ba:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01007bf:	ec                   	in     (%dx),%al
f01007c0:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01007c2:	83 c4 10             	add    $0x10,%esp
f01007c5:	3c ff                	cmp    $0xff,%al
f01007c7:	0f 95 05 34 d9 5d f0 	setne  0xf05dd934
f01007ce:	89 ca                	mov    %ecx,%edx
f01007d0:	ec                   	in     (%dx),%al
f01007d1:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01007d6:	ec                   	in     (%dx),%al
	if (serial_exists)
f01007d7:	80 fb ff             	cmp    $0xff,%bl
f01007da:	75 2d                	jne    f0100809 <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f01007dc:	83 ec 0c             	sub    $0xc,%esp
f01007df:	68 7e 81 10 f0       	push   $0xf010817e
f01007e4:	e8 0d 3a 00 00       	call   f01041f6 <cprintf>
f01007e9:	83 c4 10             	add    $0x10,%esp
}
f01007ec:	eb 3c                	jmp    f010082a <cons_init+0x144>
		*cp = was;
f01007ee:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01007f5:	c7 05 30 d9 5d f0 d4 	movl   $0x3d4,0xf05dd930
f01007fc:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01007ff:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100804:	e9 16 ff ff ff       	jmp    f010071f <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100809:	83 ec 0c             	sub    $0xc,%esp
f010080c:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f0100813:	25 ef ff 00 00       	and    $0xffef,%eax
f0100818:	50                   	push   %eax
f0100819:	e8 5f 38 00 00       	call   f010407d <irq_setmask_8259A>
	if (!serial_exists)
f010081e:	83 c4 10             	add    $0x10,%esp
f0100821:	80 3d 34 d9 5d f0 00 	cmpb   $0x0,0xf05dd934
f0100828:	74 b2                	je     f01007dc <cons_init+0xf6>
}
f010082a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010082d:	5b                   	pop    %ebx
f010082e:	5e                   	pop    %esi
f010082f:	5f                   	pop    %edi
f0100830:	5d                   	pop    %ebp
f0100831:	c3                   	ret    

f0100832 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100832:	55                   	push   %ebp
f0100833:	89 e5                	mov    %esp,%ebp
f0100835:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100838:	8b 45 08             	mov    0x8(%ebp),%eax
f010083b:	e8 42 fc ff ff       	call   f0100482 <cons_putc>
}
f0100840:	c9                   	leave  
f0100841:	c3                   	ret    

f0100842 <getchar>:

int
getchar(void)
{
f0100842:	55                   	push   %ebp
f0100843:	89 e5                	mov    %esp,%ebp
f0100845:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100848:	e8 56 fe ff ff       	call   f01006a3 <cons_getc>
f010084d:	85 c0                	test   %eax,%eax
f010084f:	74 f7                	je     f0100848 <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100851:	c9                   	leave  
f0100852:	c3                   	ret    

f0100853 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100853:	b8 01 00 00 00       	mov    $0x1,%eax
f0100858:	c3                   	ret    

f0100859 <mon_help>:
/***** Implementations of basic kernel monitor commands *****/
static long atol(const char *nptr);

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100859:	55                   	push   %ebp
f010085a:	89 e5                	mov    %esp,%ebp
f010085c:	53                   	push   %ebx
f010085d:	83 ec 04             	sub    $0x4,%esp
f0100860:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100865:	83 ec 04             	sub    $0x4,%esp
f0100868:	ff b3 24 88 10 f0    	pushl  -0xfef77dc(%ebx)
f010086e:	ff b3 20 88 10 f0    	pushl  -0xfef77e0(%ebx)
f0100874:	68 c0 83 10 f0       	push   $0xf01083c0
f0100879:	e8 78 39 00 00       	call   f01041f6 <cprintf>
f010087e:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100881:	83 c4 10             	add    $0x10,%esp
f0100884:	83 fb 3c             	cmp    $0x3c,%ebx
f0100887:	75 dc                	jne    f0100865 <mon_help+0xc>
	return 0;
}
f0100889:	b8 00 00 00 00       	mov    $0x0,%eax
f010088e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100891:	c9                   	leave  
f0100892:	c3                   	ret    

f0100893 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100893:	55                   	push   %ebp
f0100894:	89 e5                	mov    %esp,%ebp
f0100896:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100899:	68 c9 83 10 f0       	push   $0xf01083c9
f010089e:	e8 53 39 00 00       	call   f01041f6 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01008a3:	83 c4 08             	add    $0x8,%esp
f01008a6:	68 0c 00 10 00       	push   $0x10000c
f01008ab:	68 2c 85 10 f0       	push   $0xf010852c
f01008b0:	e8 41 39 00 00       	call   f01041f6 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008b5:	83 c4 0c             	add    $0xc,%esp
f01008b8:	68 0c 00 10 00       	push   $0x10000c
f01008bd:	68 0c 00 10 f0       	push   $0xf010000c
f01008c2:	68 54 85 10 f0       	push   $0xf0108554
f01008c7:	e8 2a 39 00 00       	call   f01041f6 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01008cc:	83 c4 0c             	add    $0xc,%esp
f01008cf:	68 0f 80 10 00       	push   $0x10800f
f01008d4:	68 0f 80 10 f0       	push   $0xf010800f
f01008d9:	68 78 85 10 f0       	push   $0xf0108578
f01008de:	e8 13 39 00 00       	call   f01041f6 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008e3:	83 c4 0c             	add    $0xc,%esp
f01008e6:	68 00 d7 5d 00       	push   $0x5dd700
f01008eb:	68 00 d7 5d f0       	push   $0xf05dd700
f01008f0:	68 9c 85 10 f0       	push   $0xf010859c
f01008f5:	e8 fc 38 00 00       	call   f01041f6 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008fa:	83 c4 0c             	add    $0xc,%esp
f01008fd:	68 c0 db 6b 00       	push   $0x6bdbc0
f0100902:	68 c0 db 6b f0       	push   $0xf06bdbc0
f0100907:	68 c0 85 10 f0       	push   $0xf01085c0
f010090c:	e8 e5 38 00 00       	call   f01041f6 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100911:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100914:	b8 c0 db 6b f0       	mov    $0xf06bdbc0,%eax
f0100919:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f010091e:	c1 f8 0a             	sar    $0xa,%eax
f0100921:	50                   	push   %eax
f0100922:	68 e4 85 10 f0       	push   $0xf01085e4
f0100927:	e8 ca 38 00 00       	call   f01041f6 <cprintf>
	return 0;
}
f010092c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100931:	c9                   	leave  
f0100932:	c3                   	ret    

f0100933 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100933:	55                   	push   %ebp
f0100934:	89 e5                	mov    %esp,%ebp
f0100936:	56                   	push   %esi
f0100937:	53                   	push   %ebx
f0100938:	83 ec 20             	sub    $0x20,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010093b:	89 eb                	mov    %ebp,%ebx
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
		debuginfo_eip(the_ebp[1], &info);
f010093d:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(the_ebp != NULL){
f0100940:	85 db                	test   %ebx,%ebx
f0100942:	0f 84 b3 00 00 00    	je     f01009fb <mon_backtrace+0xc8>
		cprintf("the ebp1 0x%x\n", the_ebp[1]);
f0100948:	83 ec 08             	sub    $0x8,%esp
f010094b:	ff 73 04             	pushl  0x4(%ebx)
f010094e:	68 e2 83 10 f0       	push   $0xf01083e2
f0100953:	e8 9e 38 00 00       	call   f01041f6 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f0100958:	83 c4 08             	add    $0x8,%esp
f010095b:	ff 73 08             	pushl  0x8(%ebx)
f010095e:	68 f1 83 10 f0       	push   $0xf01083f1
f0100963:	e8 8e 38 00 00       	call   f01041f6 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f0100968:	83 c4 08             	add    $0x8,%esp
f010096b:	ff 73 0c             	pushl  0xc(%ebx)
f010096e:	68 00 84 10 f0       	push   $0xf0108400
f0100973:	e8 7e 38 00 00       	call   f01041f6 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f0100978:	83 c4 08             	add    $0x8,%esp
f010097b:	ff 73 10             	pushl  0x10(%ebx)
f010097e:	68 0f 84 10 f0       	push   $0xf010840f
f0100983:	e8 6e 38 00 00       	call   f01041f6 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f0100988:	83 c4 08             	add    $0x8,%esp
f010098b:	ff 73 14             	pushl  0x14(%ebx)
f010098e:	68 1e 84 10 f0       	push   $0xf010841e
f0100993:	e8 5e 38 00 00       	call   f01041f6 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f0100998:	83 c4 08             	add    $0x8,%esp
f010099b:	ff 73 18             	pushl  0x18(%ebx)
f010099e:	68 2d 84 10 f0       	push   $0xf010842d
f01009a3:	e8 4e 38 00 00       	call   f01041f6 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f01009a8:	ff 73 18             	pushl  0x18(%ebx)
f01009ab:	ff 73 14             	pushl  0x14(%ebx)
f01009ae:	ff 73 10             	pushl  0x10(%ebx)
f01009b1:	ff 73 0c             	pushl  0xc(%ebx)
f01009b4:	ff 73 08             	pushl  0x8(%ebx)
f01009b7:	53                   	push   %ebx
f01009b8:	ff 73 04             	pushl  0x4(%ebx)
f01009bb:	68 10 86 10 f0       	push   $0xf0108610
f01009c0:	e8 31 38 00 00       	call   f01041f6 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f01009c5:	83 c4 28             	add    $0x28,%esp
f01009c8:	56                   	push   %esi
f01009c9:	ff 73 04             	pushl  0x4(%ebx)
f01009cc:	e8 cc 52 00 00       	call   f0105c9d <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f01009d1:	83 c4 08             	add    $0x8,%esp
f01009d4:	8b 43 04             	mov    0x4(%ebx),%eax
f01009d7:	2b 45 f0             	sub    -0x10(%ebp),%eax
f01009da:	50                   	push   %eax
f01009db:	ff 75 e8             	pushl  -0x18(%ebp)
f01009de:	ff 75 ec             	pushl  -0x14(%ebp)
f01009e1:	ff 75 e4             	pushl  -0x1c(%ebp)
f01009e4:	ff 75 e0             	pushl  -0x20(%ebp)
f01009e7:	68 3c 84 10 f0       	push   $0xf010843c
f01009ec:	e8 05 38 00 00       	call   f01041f6 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f01009f1:	8b 1b                	mov    (%ebx),%ebx
f01009f3:	83 c4 20             	add    $0x20,%esp
f01009f6:	e9 45 ff ff ff       	jmp    f0100940 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f01009fb:	83 ec 0c             	sub    $0xc,%esp
f01009fe:	68 52 84 10 f0       	push   $0xf0108452
f0100a03:	e8 ee 37 00 00       	call   f01041f6 <cprintf>
	return 0;
}
f0100a08:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a10:	5b                   	pop    %ebx
f0100a11:	5e                   	pop    %esi
f0100a12:	5d                   	pop    %ebp
f0100a13:	c3                   	ret    

f0100a14 <mon_showmappings>:
	cycles_t end = currentcycles();
	cprintf("%s cycles: %ul\n", fun_n, end - start);
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f0100a14:	55                   	push   %ebp
f0100a15:	89 e5                	mov    %esp,%ebp
f0100a17:	57                   	push   %edi
f0100a18:	56                   	push   %esi
f0100a19:	53                   	push   %ebx
f0100a1a:	83 ec 2c             	sub    $0x2c,%esp
	if(argc != 3){
f0100a1d:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100a21:	75 3f                	jne    f0100a62 <mon_showmappings+0x4e>
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
		return 0;
	}
	uint32_t low_va = 0, high_va = 0, old_va;
	if(argv[1][0]!='0'||argv[1][1]!='x'||argv[2][0]!='0'||argv[2][1]!='x'){
f0100a23:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a26:	8b 40 04             	mov    0x4(%eax),%eax
f0100a29:	80 38 30             	cmpb   $0x30,(%eax)
f0100a2c:	75 17                	jne    f0100a45 <mon_showmappings+0x31>
f0100a2e:	80 78 01 78          	cmpb   $0x78,0x1(%eax)
f0100a32:	75 11                	jne    f0100a45 <mon_showmappings+0x31>
f0100a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0100a37:	8b 51 08             	mov    0x8(%ecx),%edx
f0100a3a:	80 3a 30             	cmpb   $0x30,(%edx)
f0100a3d:	75 06                	jne    f0100a45 <mon_showmappings+0x31>
f0100a3f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0100a43:	74 34                	je     f0100a79 <mon_showmappings+0x65>
		cprintf("the virtual-address should be 16-base\n");
f0100a45:	83 ec 0c             	sub    $0xc,%esp
f0100a48:	68 80 86 10 f0       	push   $0xf0108680
f0100a4d:	e8 a4 37 00 00       	call   f01041f6 <cprintf>
		return 0;
f0100a52:	83 c4 10             	add    $0x10,%esp
		low_va += PTSIZE;
		if(low_va <= old_va)
			break;
    }
    return 0;
}
f0100a55:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a5d:	5b                   	pop    %ebx
f0100a5e:	5e                   	pop    %esi
f0100a5f:	5f                   	pop    %edi
f0100a60:	5d                   	pop    %ebp
f0100a61:	c3                   	ret    
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
f0100a62:	83 ec 08             	sub    $0x8,%esp
f0100a65:	68 00 88 10 f0       	push   $0xf0108800
f0100a6a:	68 44 86 10 f0       	push   $0xf0108644
f0100a6f:	e8 82 37 00 00       	call   f01041f6 <cprintf>
		return 0;
f0100a74:	83 c4 10             	add    $0x10,%esp
f0100a77:	eb dc                	jmp    f0100a55 <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f0100a79:	83 ec 04             	sub    $0x4,%esp
f0100a7c:	6a 10                	push   $0x10
f0100a7e:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f0100a81:	56                   	push   %esi
f0100a82:	50                   	push   %eax
f0100a83:	e8 92 5f 00 00       	call   f0106a1a <strtol>
f0100a88:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a8a:	83 c4 0c             	add    $0xc,%esp
f0100a8d:	6a 10                	push   $0x10
f0100a8f:	56                   	push   %esi
f0100a90:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a93:	ff 70 08             	pushl  0x8(%eax)
f0100a96:	e8 7f 5f 00 00       	call   f0106a1a <strtol>
	low_va = low_va/PGSIZE * PGSIZE;
f0100a9b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	high_va = high_va/PGSIZE * PGSIZE;
f0100aa1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100aa6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(low_va > high_va){
f0100aa9:	83 c4 10             	add    $0x10,%esp
f0100aac:	39 c3                	cmp    %eax,%ebx
f0100aae:	0f 86 1c 01 00 00    	jbe    f0100bd0 <mon_showmappings+0x1bc>
		cprintf("the start-va should < the end-va\n");
f0100ab4:	83 ec 0c             	sub    $0xc,%esp
f0100ab7:	68 a8 86 10 f0       	push   $0xf01086a8
f0100abc:	e8 35 37 00 00       	call   f01041f6 <cprintf>
		return 0;
f0100ac1:	83 c4 10             	add    $0x10,%esp
f0100ac4:	eb 8f                	jmp    f0100a55 <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100ac6:	83 ec 04             	sub    $0x4,%esp
f0100ac9:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100acf:	50                   	push   %eax
f0100ad0:	53                   	push   %ebx
f0100ad1:	68 65 84 10 f0       	push   $0xf0108465
f0100ad6:	e8 1b 37 00 00       	call   f01041f6 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100adb:	8b 06                	mov    (%esi),%eax
f0100add:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ae2:	83 c4 0c             	add    $0xc,%esp
f0100ae5:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100aeb:	52                   	push   %edx
f0100aec:	50                   	push   %eax
f0100aed:	68 74 84 10 f0       	push   $0xf0108474
f0100af2:	e8 ff 36 00 00       	call   f01041f6 <cprintf>
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100af7:	83 c4 0c             	add    $0xc,%esp
f0100afa:	89 f8                	mov    %edi,%eax
f0100afc:	83 e0 01             	and    $0x1,%eax
f0100aff:	50                   	push   %eax
					u_bit = pte[PTX(low_va)] & PTE_U;
f0100b00:	89 f8                	mov    %edi,%eax
f0100b02:	83 e0 04             	and    $0x4,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b05:	0f be c0             	movsbl %al,%eax
f0100b08:	50                   	push   %eax
					w_bit = pte[PTX(low_va)] & PTE_W;
f0100b09:	89 f8                	mov    %edi,%eax
f0100b0b:	83 e0 02             	and    $0x2,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b0e:	0f be c0             	movsbl %al,%eax
f0100b11:	50                   	push   %eax
					a_bit = pte[PTX(low_va)] & PTE_A;
f0100b12:	89 f8                	mov    %edi,%eax
f0100b14:	83 e0 20             	and    $0x20,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b17:	0f be c0             	movsbl %al,%eax
f0100b1a:	50                   	push   %eax
					d_bit = pte[PTX(low_va)] & PTE_D;
f0100b1b:	89 f8                	mov    %edi,%eax
f0100b1d:	83 e0 40             	and    $0x40,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b20:	0f be c0             	movsbl %al,%eax
f0100b23:	50                   	push   %eax
f0100b24:	6a 00                	push   $0x0
f0100b26:	68 83 84 10 f0       	push   $0xf0108483
f0100b2b:	e8 c6 36 00 00       	call   f01041f6 <cprintf>
f0100b30:	83 c4 20             	add    $0x20,%esp
f0100b33:	e9 dc 00 00 00       	jmp    f0100c14 <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100b38:	83 ec 04             	sub    $0x4,%esp
f0100b3b:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100b41:	50                   	push   %eax
f0100b42:	53                   	push   %ebx
f0100b43:	68 65 84 10 f0       	push   $0xf0108465
f0100b48:	e8 a9 36 00 00       	call   f01041f6 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100b4d:	8b 07                	mov    (%edi),%eax
f0100b4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b54:	83 c4 0c             	add    $0xc,%esp
f0100b57:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100b5d:	52                   	push   %edx
f0100b5e:	50                   	push   %eax
f0100b5f:	68 74 84 10 f0       	push   $0xf0108474
f0100b64:	e8 8d 36 00 00       	call   f01041f6 <cprintf>
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b69:	83 c4 0c             	add    $0xc,%esp
f0100b6c:	89 f0                	mov    %esi,%eax
f0100b6e:	83 e0 01             	and    $0x1,%eax
f0100b71:	50                   	push   %eax
				u_bit = *pde & PTE_U;
f0100b72:	89 f0                	mov    %esi,%eax
f0100b74:	83 e0 04             	and    $0x4,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b77:	0f be c0             	movsbl %al,%eax
f0100b7a:	50                   	push   %eax
				w_bit = *pde & PTE_W;
f0100b7b:	89 f0                	mov    %esi,%eax
f0100b7d:	83 e0 02             	and    $0x2,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b80:	0f be c0             	movsbl %al,%eax
f0100b83:	50                   	push   %eax
				a_bit = *pde & PTE_A;
f0100b84:	89 f0                	mov    %esi,%eax
f0100b86:	83 e0 20             	and    $0x20,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b89:	0f be c0             	movsbl %al,%eax
f0100b8c:	50                   	push   %eax
				d_bit = *pde & PTE_D;
f0100b8d:	89 f0                	mov    %esi,%eax
f0100b8f:	83 e0 40             	and    $0x40,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b92:	0f be c0             	movsbl %al,%eax
f0100b95:	50                   	push   %eax
f0100b96:	6a 00                	push   $0x0
f0100b98:	68 83 84 10 f0       	push   $0xf0108483
f0100b9d:	e8 54 36 00 00       	call   f01041f6 <cprintf>
				low_va += PTSIZE;
f0100ba2:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
				if(low_va <= old_va)
f0100ba8:	83 c4 20             	add    $0x20,%esp
f0100bab:	39 d8                	cmp    %ebx,%eax
f0100bad:	0f 86 a2 fe ff ff    	jbe    f0100a55 <mon_showmappings+0x41>
				low_va += PTSIZE;
f0100bb3:	89 c3                	mov    %eax,%ebx
f0100bb5:	eb 10                	jmp    f0100bc7 <mon_showmappings+0x1b3>
		low_va += PTSIZE;
f0100bb7:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
		if(low_va <= old_va)
f0100bbd:	39 d8                	cmp    %ebx,%eax
f0100bbf:	0f 86 90 fe ff ff    	jbe    f0100a55 <mon_showmappings+0x41>
		low_va += PTSIZE;
f0100bc5:	89 c3                	mov    %eax,%ebx
    while (low_va <= high_va) {
f0100bc7:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0100bca:	0f 87 85 fe ff ff    	ja     f0100a55 <mon_showmappings+0x41>
        pde_t *pde = &kern_pgdir[PDX(low_va)];
f0100bd0:	89 da                	mov    %ebx,%edx
f0100bd2:	c1 ea 16             	shr    $0x16,%edx
f0100bd5:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0100bda:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if (*pde) {
f0100bdd:	8b 37                	mov    (%edi),%esi
f0100bdf:	85 f6                	test   %esi,%esi
f0100be1:	74 d4                	je     f0100bb7 <mon_showmappings+0x1a3>
            if (low_va < (uint32_t)KERNBASE) {
f0100be3:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100be9:	0f 87 49 ff ff ff    	ja     f0100b38 <mon_showmappings+0x124>
                pte_t *pte = (pte_t*)(PTE_ADDR(*pde)+KERNBASE);
f0100bef:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
				if(pte[PTX(low_va)] & PTE_P){
f0100bf5:	89 d8                	mov    %ebx,%eax
f0100bf7:	c1 e8 0a             	shr    $0xa,%eax
f0100bfa:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100bff:	8d b4 06 00 00 00 f0 	lea    -0x10000000(%esi,%eax,1),%esi
f0100c06:	8b 3e                	mov    (%esi),%edi
f0100c08:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0100c0e:	0f 85 b2 fe ff ff    	jne    f0100ac6 <mon_showmappings+0xb2>
				low_va += PGSIZE;
f0100c14:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
				if(low_va <= old_va)
f0100c1a:	39 d8                	cmp    %ebx,%eax
f0100c1c:	0f 86 33 fe ff ff    	jbe    f0100a55 <mon_showmappings+0x41>
				low_va += PGSIZE;
f0100c22:	89 c3                	mov    %eax,%ebx
f0100c24:	eb a1                	jmp    f0100bc7 <mon_showmappings+0x1b3>

f0100c26 <mon_time>:
mon_time(int argc, char **argv, struct Trapframe *tf){
f0100c26:	55                   	push   %ebp
f0100c27:	89 e5                	mov    %esp,%ebp
f0100c29:	57                   	push   %edi
f0100c2a:	56                   	push   %esi
f0100c2b:	53                   	push   %ebx
f0100c2c:	83 ec 1c             	sub    $0x1c,%esp
f0100c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
	char *fun_n = argv[1];
f0100c32:	8b 78 04             	mov    0x4(%eax),%edi
	if(argc != 2)
f0100c35:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100c39:	0f 85 84 00 00 00    	jne    f0100cc3 <mon_time+0x9d>
	for(int i = 0; i < command_size; i++){
f0100c3f:	bb 00 00 00 00       	mov    $0x0,%ebx
	cycles_t start = 0;
f0100c44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0100c4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100c52:	83 c0 08             	add    $0x8,%eax
f0100c55:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100c58:	eb 20                	jmp    f0100c7a <mon_time+0x54>
	}
}

cycles_t currentcycles() {
    cycles_t result;
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c5a:	0f 31                	rdtsc  
f0100c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100c5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100c62:	83 ec 04             	sub    $0x4,%esp
f0100c65:	ff 75 10             	pushl  0x10(%ebp)
f0100c68:	ff 75 dc             	pushl  -0x24(%ebp)
f0100c6b:	6a 00                	push   $0x0
f0100c6d:	ff 14 b5 28 88 10 f0 	call   *-0xfef77d8(,%esi,4)
f0100c74:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100c77:	83 c3 01             	add    $0x1,%ebx
f0100c7a:	39 1d 00 d3 16 f0    	cmp    %ebx,0xf016d300
f0100c80:	7e 1c                	jle    f0100c9e <mon_time+0x78>
f0100c82:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c85:	83 ec 08             	sub    $0x8,%esp
f0100c88:	57                   	push   %edi
f0100c89:	ff 34 b5 20 88 10 f0 	pushl  -0xfef77e0(,%esi,4)
f0100c90:	e8 d4 5b 00 00       	call   f0106869 <strcmp>
f0100c95:	83 c4 10             	add    $0x10,%esp
f0100c98:	85 c0                	test   %eax,%eax
f0100c9a:	75 db                	jne    f0100c77 <mon_time+0x51>
f0100c9c:	eb bc                	jmp    f0100c5a <mon_time+0x34>
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c9e:	0f 31                	rdtsc  
	cprintf("%s cycles: %ul\n", fun_n, end - start);
f0100ca0:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100ca3:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
f0100ca6:	52                   	push   %edx
f0100ca7:	50                   	push   %eax
f0100ca8:	57                   	push   %edi
f0100ca9:	68 96 84 10 f0       	push   $0xf0108496
f0100cae:	e8 43 35 00 00       	call   f01041f6 <cprintf>
	return 0;
f0100cb3:	83 c4 10             	add    $0x10,%esp
f0100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100cbe:	5b                   	pop    %ebx
f0100cbf:	5e                   	pop    %esi
f0100cc0:	5f                   	pop    %edi
f0100cc1:	5d                   	pop    %ebp
f0100cc2:	c3                   	ret    
		return -1;
f0100cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100cc8:	eb f1                	jmp    f0100cbb <mon_time+0x95>

f0100cca <monitor>:
{
f0100cca:	55                   	push   %ebp
f0100ccb:	89 e5                	mov    %esp,%ebp
f0100ccd:	57                   	push   %edi
f0100cce:	56                   	push   %esi
f0100ccf:	53                   	push   %ebx
f0100cd0:	83 ec 58             	sub    $0x58,%esp
	cprintf("Welcome to the JOS kernel monitor!\n");
f0100cd3:	68 cc 86 10 f0       	push   $0xf01086cc
f0100cd8:	e8 19 35 00 00       	call   f01041f6 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100cdd:	c7 04 24 f0 86 10 f0 	movl   $0xf01086f0,(%esp)
f0100ce4:	e8 0d 35 00 00       	call   f01041f6 <cprintf>
	if (tf != NULL)
f0100ce9:	83 c4 10             	add    $0x10,%esp
f0100cec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100cf0:	0f 84 d9 00 00 00    	je     f0100dcf <monitor+0x105>
		print_trapframe(tf);
f0100cf6:	83 ec 0c             	sub    $0xc,%esp
f0100cf9:	ff 75 08             	pushl  0x8(%ebp)
f0100cfc:	e8 92 3c 00 00       	call   f0104993 <print_trapframe>
f0100d01:	83 c4 10             	add    $0x10,%esp
f0100d04:	e9 c6 00 00 00       	jmp    f0100dcf <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100d09:	83 ec 08             	sub    $0x8,%esp
f0100d0c:	0f be c0             	movsbl %al,%eax
f0100d0f:	50                   	push   %eax
f0100d10:	68 aa 84 10 f0       	push   $0xf01084aa
f0100d15:	e8 ad 5b 00 00       	call   f01068c7 <strchr>
f0100d1a:	83 c4 10             	add    $0x10,%esp
f0100d1d:	85 c0                	test   %eax,%eax
f0100d1f:	74 63                	je     f0100d84 <monitor+0xba>
			*buf++ = 0;
f0100d21:	c6 03 00             	movb   $0x0,(%ebx)
f0100d24:	89 f7                	mov    %esi,%edi
f0100d26:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100d29:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100d2b:	0f b6 03             	movzbl (%ebx),%eax
f0100d2e:	84 c0                	test   %al,%al
f0100d30:	75 d7                	jne    f0100d09 <monitor+0x3f>
	argv[argc] = 0;
f0100d32:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100d39:	00 
	if (argc == 0)
f0100d3a:	85 f6                	test   %esi,%esi
f0100d3c:	0f 84 8d 00 00 00    	je     f0100dcf <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100d42:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100d47:	83 ec 08             	sub    $0x8,%esp
f0100d4a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100d4d:	ff 34 85 20 88 10 f0 	pushl  -0xfef77e0(,%eax,4)
f0100d54:	ff 75 a8             	pushl  -0x58(%ebp)
f0100d57:	e8 0d 5b 00 00       	call   f0106869 <strcmp>
f0100d5c:	83 c4 10             	add    $0x10,%esp
f0100d5f:	85 c0                	test   %eax,%eax
f0100d61:	0f 84 8f 00 00 00    	je     f0100df6 <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100d67:	83 c3 01             	add    $0x1,%ebx
f0100d6a:	83 fb 05             	cmp    $0x5,%ebx
f0100d6d:	75 d8                	jne    f0100d47 <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100d6f:	83 ec 08             	sub    $0x8,%esp
f0100d72:	ff 75 a8             	pushl  -0x58(%ebp)
f0100d75:	68 cc 84 10 f0       	push   $0xf01084cc
f0100d7a:	e8 77 34 00 00       	call   f01041f6 <cprintf>
f0100d7f:	83 c4 10             	add    $0x10,%esp
f0100d82:	eb 4b                	jmp    f0100dcf <monitor+0x105>
		if (*buf == 0)
f0100d84:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100d87:	74 a9                	je     f0100d32 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100d89:	83 fe 0f             	cmp    $0xf,%esi
f0100d8c:	74 2f                	je     f0100dbd <monitor+0xf3>
		argv[argc++] = buf;
f0100d8e:	8d 7e 01             	lea    0x1(%esi),%edi
f0100d91:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100d95:	0f b6 03             	movzbl (%ebx),%eax
f0100d98:	84 c0                	test   %al,%al
f0100d9a:	74 8d                	je     f0100d29 <monitor+0x5f>
f0100d9c:	83 ec 08             	sub    $0x8,%esp
f0100d9f:	0f be c0             	movsbl %al,%eax
f0100da2:	50                   	push   %eax
f0100da3:	68 aa 84 10 f0       	push   $0xf01084aa
f0100da8:	e8 1a 5b 00 00       	call   f01068c7 <strchr>
f0100dad:	83 c4 10             	add    $0x10,%esp
f0100db0:	85 c0                	test   %eax,%eax
f0100db2:	0f 85 71 ff ff ff    	jne    f0100d29 <monitor+0x5f>
			buf++;
f0100db8:	83 c3 01             	add    $0x1,%ebx
f0100dbb:	eb d8                	jmp    f0100d95 <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100dbd:	83 ec 08             	sub    $0x8,%esp
f0100dc0:	6a 10                	push   $0x10
f0100dc2:	68 af 84 10 f0       	push   $0xf01084af
f0100dc7:	e8 2a 34 00 00       	call   f01041f6 <cprintf>
f0100dcc:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100dcf:	83 ec 0c             	sub    $0xc,%esp
f0100dd2:	68 a6 84 10 f0       	push   $0xf01084a6
f0100dd7:	e8 bb 58 00 00       	call   f0106697 <readline>
f0100ddc:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100dde:	83 c4 10             	add    $0x10,%esp
f0100de1:	85 c0                	test   %eax,%eax
f0100de3:	74 ea                	je     f0100dcf <monitor+0x105>
	argv[argc] = 0;
f0100de5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100dec:	be 00 00 00 00       	mov    $0x0,%esi
f0100df1:	e9 35 ff ff ff       	jmp    f0100d2b <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100df6:	83 ec 04             	sub    $0x4,%esp
f0100df9:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100dfc:	ff 75 08             	pushl  0x8(%ebp)
f0100dff:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100e02:	52                   	push   %edx
f0100e03:	56                   	push   %esi
f0100e04:	ff 14 85 28 88 10 f0 	call   *-0xfef77d8(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100e0b:	83 c4 10             	add    $0x10,%esp
f0100e0e:	85 c0                	test   %eax,%eax
f0100e10:	79 bd                	jns    f0100dcf <monitor+0x105>
}
f0100e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e15:	5b                   	pop    %ebx
f0100e16:	5e                   	pop    %esi
f0100e17:	5f                   	pop    %edi
f0100e18:	5d                   	pop    %ebp
f0100e19:	c3                   	ret    

f0100e1a <currentcycles>:
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100e1a:	0f 31                	rdtsc  
    return result;
}
f0100e1c:	c3                   	ret    

f0100e1d <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100e1d:	55                   	push   %ebp
f0100e1e:	89 e5                	mov    %esp,%ebp
f0100e20:	56                   	push   %esi
f0100e21:	53                   	push   %ebx
f0100e22:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100e24:	83 ec 0c             	sub    $0xc,%esp
f0100e27:	50                   	push   %eax
f0100e28:	e8 22 32 00 00       	call   f010404f <mc146818_read>
f0100e2d:	89 c3                	mov    %eax,%ebx
f0100e2f:	83 c6 01             	add    $0x1,%esi
f0100e32:	89 34 24             	mov    %esi,(%esp)
f0100e35:	e8 15 32 00 00       	call   f010404f <mc146818_read>
f0100e3a:	c1 e0 08             	shl    $0x8,%eax
f0100e3d:	09 d8                	or     %ebx,%eax
}
f0100e3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100e42:	5b                   	pop    %ebx
f0100e43:	5e                   	pop    %esi
f0100e44:	5d                   	pop    %ebp
f0100e45:	c3                   	ret    

f0100e46 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100e46:	89 d1                	mov    %edx,%ecx
f0100e48:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100e4b:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100e4e:	a8 01                	test   $0x1,%al
f0100e50:	74 52                	je     f0100ea4 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100e52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100e57:	89 c1                	mov    %eax,%ecx
f0100e59:	c1 e9 0c             	shr    $0xc,%ecx
f0100e5c:	3b 0d 88 ed 5d f0    	cmp    0xf05ded88,%ecx
f0100e62:	73 25                	jae    f0100e89 <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100e64:	c1 ea 0c             	shr    $0xc,%edx
f0100e67:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100e6d:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100e74:	89 c2                	mov    %eax,%edx
f0100e76:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100e79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e7e:	85 d2                	test   %edx,%edx
f0100e80:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100e85:	0f 44 c2             	cmove  %edx,%eax
f0100e88:	c3                   	ret    
{
f0100e89:	55                   	push   %ebp
f0100e8a:	89 e5                	mov    %esp,%ebp
f0100e8c:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e8f:	50                   	push   %eax
f0100e90:	68 74 80 10 f0       	push   $0xf0108074
f0100e95:	68 b0 03 00 00       	push   $0x3b0
f0100e9a:	68 65 92 10 f0       	push   $0xf0109265
f0100e9f:	e8 a5 f1 ff ff       	call   f0100049 <_panic>
		return ~0;
f0100ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100ea9:	c3                   	ret    

f0100eaa <boot_alloc>:
{
f0100eaa:	55                   	push   %ebp
f0100eab:	89 e5                	mov    %esp,%ebp
f0100ead:	53                   	push   %ebx
f0100eae:	83 ec 04             	sub    $0x4,%esp
	if (!nextfree) {
f0100eb1:	83 3d 38 d9 5d f0 00 	cmpl   $0x0,0xf05dd938
f0100eb8:	74 40                	je     f0100efa <boot_alloc+0x50>
	if(!n)
f0100eba:	85 c0                	test   %eax,%eax
f0100ebc:	74 65                	je     f0100f23 <boot_alloc+0x79>
f0100ebe:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100ec0:	a1 38 d9 5d f0       	mov    0xf05dd938,%eax
	if ((uint32_t)kva < KERNBASE)
f0100ec5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100eca:	76 5e                	jbe    f0100f2a <boot_alloc+0x80>
f0100ecc:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100ed3:	c1 e9 0c             	shr    $0xc,%ecx
f0100ed6:	83 c1 01             	add    $0x1,%ecx
f0100ed9:	3b 0d 88 ed 5d f0    	cmp    0xf05ded88,%ecx
f0100edf:	77 5b                	ja     f0100f3c <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100ee1:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100ee7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100eed:	01 c2                	add    %eax,%edx
f0100eef:	89 15 38 d9 5d f0    	mov    %edx,0xf05dd938
}
f0100ef5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ef8:	c9                   	leave  
f0100ef9:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100efa:	b9 c0 db 6b f0       	mov    $0xf06bdbc0,%ecx
f0100eff:	ba bf eb 6b f0       	mov    $0xf06bebbf,%edx
f0100f04:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100f0a:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100f10:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100f16:	85 c9                	test   %ecx,%ecx
f0100f18:	0f 44 d3             	cmove  %ebx,%edx
f0100f1b:	89 15 38 d9 5d f0    	mov    %edx,0xf05dd938
f0100f21:	eb 97                	jmp    f0100eba <boot_alloc+0x10>
		return nextfree;
f0100f23:	a1 38 d9 5d f0       	mov    0xf05dd938,%eax
f0100f28:	eb cb                	jmp    f0100ef5 <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100f2a:	50                   	push   %eax
f0100f2b:	68 98 80 10 f0       	push   $0xf0108098
f0100f30:	6a 73                	push   $0x73
f0100f32:	68 65 92 10 f0       	push   $0xf0109265
f0100f37:	e8 0d f1 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100f3c:	83 ec 04             	sub    $0x4,%esp
f0100f3f:	68 5c 88 10 f0       	push   $0xf010885c
f0100f44:	6a 74                	push   $0x74
f0100f46:	68 65 92 10 f0       	push   $0xf0109265
f0100f4b:	e8 f9 f0 ff ff       	call   f0100049 <_panic>

f0100f50 <check_page_free_list>:
{
f0100f50:	55                   	push   %ebp
f0100f51:	89 e5                	mov    %esp,%ebp
f0100f53:	57                   	push   %edi
f0100f54:	56                   	push   %esi
f0100f55:	53                   	push   %ebx
f0100f56:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f59:	84 c0                	test   %al,%al
f0100f5b:	0f 85 77 02 00 00    	jne    f01011d8 <check_page_free_list+0x288>
	if (!page_free_list)
f0100f61:	83 3d 40 d9 5d f0 00 	cmpl   $0x0,0xf05dd940
f0100f68:	74 0a                	je     f0100f74 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f6a:	be 00 04 00 00       	mov    $0x400,%esi
f0100f6f:	e9 bf 02 00 00       	jmp    f0101233 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100f74:	83 ec 04             	sub    $0x4,%esp
f0100f77:	68 94 88 10 f0       	push   $0xf0108894
f0100f7c:	68 e0 02 00 00       	push   $0x2e0
f0100f81:	68 65 92 10 f0       	push   $0xf0109265
f0100f86:	e8 be f0 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f8b:	50                   	push   %eax
f0100f8c:	68 74 80 10 f0       	push   $0xf0108074
f0100f91:	6a 58                	push   $0x58
f0100f93:	68 71 92 10 f0       	push   $0xf0109271
f0100f98:	e8 ac f0 ff ff       	call   f0100049 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0100f9d:	8b 1b                	mov    (%ebx),%ebx
f0100f9f:	85 db                	test   %ebx,%ebx
f0100fa1:	74 41                	je     f0100fe4 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100fa3:	89 d8                	mov    %ebx,%eax
f0100fa5:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0100fab:	c1 f8 03             	sar    $0x3,%eax
f0100fae:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100fb1:	89 c2                	mov    %eax,%edx
f0100fb3:	c1 ea 16             	shr    $0x16,%edx
f0100fb6:	39 f2                	cmp    %esi,%edx
f0100fb8:	73 e3                	jae    f0100f9d <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100fba:	89 c2                	mov    %eax,%edx
f0100fbc:	c1 ea 0c             	shr    $0xc,%edx
f0100fbf:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0100fc5:	73 c4                	jae    f0100f8b <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100fc7:	83 ec 04             	sub    $0x4,%esp
f0100fca:	68 80 00 00 00       	push   $0x80
f0100fcf:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100fd4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100fd9:	50                   	push   %eax
f0100fda:	e8 25 59 00 00       	call   f0106904 <memset>
f0100fdf:	83 c4 10             	add    $0x10,%esp
f0100fe2:	eb b9                	jmp    f0100f9d <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100fe4:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fe9:	e8 bc fe ff ff       	call   f0100eaa <boot_alloc>
f0100fee:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ff1:	8b 15 40 d9 5d f0    	mov    0xf05dd940,%edx
		assert(pp >= pages);
f0100ff7:	8b 0d 90 ed 5d f0    	mov    0xf05ded90,%ecx
		assert(pp < pages + npages);
f0100ffd:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f0101002:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101005:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0101008:	bf 00 00 00 00       	mov    $0x0,%edi
f010100d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101010:	e9 f9 00 00 00       	jmp    f010110e <check_page_free_list+0x1be>
		assert(pp >= pages);
f0101015:	68 7f 92 10 f0       	push   $0xf010927f
f010101a:	68 8b 92 10 f0       	push   $0xf010928b
f010101f:	68 f9 02 00 00       	push   $0x2f9
f0101024:	68 65 92 10 f0       	push   $0xf0109265
f0101029:	e8 1b f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f010102e:	68 a0 92 10 f0       	push   $0xf01092a0
f0101033:	68 8b 92 10 f0       	push   $0xf010928b
f0101038:	68 fa 02 00 00       	push   $0x2fa
f010103d:	68 65 92 10 f0       	push   $0xf0109265
f0101042:	e8 02 f0 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101047:	68 b8 88 10 f0       	push   $0xf01088b8
f010104c:	68 8b 92 10 f0       	push   $0xf010928b
f0101051:	68 fb 02 00 00       	push   $0x2fb
f0101056:	68 65 92 10 f0       	push   $0xf0109265
f010105b:	e8 e9 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0101060:	68 b4 92 10 f0       	push   $0xf01092b4
f0101065:	68 8b 92 10 f0       	push   $0xf010928b
f010106a:	68 fe 02 00 00       	push   $0x2fe
f010106f:	68 65 92 10 f0       	push   $0xf0109265
f0101074:	e8 d0 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101079:	68 c5 92 10 f0       	push   $0xf01092c5
f010107e:	68 8b 92 10 f0       	push   $0xf010928b
f0101083:	68 ff 02 00 00       	push   $0x2ff
f0101088:	68 65 92 10 f0       	push   $0xf0109265
f010108d:	e8 b7 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101092:	68 ec 88 10 f0       	push   $0xf01088ec
f0101097:	68 8b 92 10 f0       	push   $0xf010928b
f010109c:	68 00 03 00 00       	push   $0x300
f01010a1:	68 65 92 10 f0       	push   $0xf0109265
f01010a6:	e8 9e ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f01010ab:	68 de 92 10 f0       	push   $0xf01092de
f01010b0:	68 8b 92 10 f0       	push   $0xf010928b
f01010b5:	68 01 03 00 00       	push   $0x301
f01010ba:	68 65 92 10 f0       	push   $0xf0109265
f01010bf:	e8 85 ef ff ff       	call   f0100049 <_panic>
	if (PGNUM(pa) >= npages)
f01010c4:	89 c3                	mov    %eax,%ebx
f01010c6:	c1 eb 0c             	shr    $0xc,%ebx
f01010c9:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f01010cc:	76 0f                	jbe    f01010dd <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f01010ce:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01010d3:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01010d6:	77 17                	ja     f01010ef <check_page_free_list+0x19f>
			++nfree_extmem;
f01010d8:	83 c7 01             	add    $0x1,%edi
f01010db:	eb 2f                	jmp    f010110c <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010dd:	50                   	push   %eax
f01010de:	68 74 80 10 f0       	push   $0xf0108074
f01010e3:	6a 58                	push   $0x58
f01010e5:	68 71 92 10 f0       	push   $0xf0109271
f01010ea:	e8 5a ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01010ef:	68 10 89 10 f0       	push   $0xf0108910
f01010f4:	68 8b 92 10 f0       	push   $0xf010928b
f01010f9:	68 02 03 00 00       	push   $0x302
f01010fe:	68 65 92 10 f0       	push   $0xf0109265
f0101103:	e8 41 ef ff ff       	call   f0100049 <_panic>
			++nfree_basemem;
f0101108:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f010110c:	8b 12                	mov    (%edx),%edx
f010110e:	85 d2                	test   %edx,%edx
f0101110:	74 74                	je     f0101186 <check_page_free_list+0x236>
		assert(pp >= pages);
f0101112:	39 d1                	cmp    %edx,%ecx
f0101114:	0f 87 fb fe ff ff    	ja     f0101015 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f010111a:	39 d6                	cmp    %edx,%esi
f010111c:	0f 86 0c ff ff ff    	jbe    f010102e <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101122:	89 d0                	mov    %edx,%eax
f0101124:	29 c8                	sub    %ecx,%eax
f0101126:	a8 07                	test   $0x7,%al
f0101128:	0f 85 19 ff ff ff    	jne    f0101047 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f010112e:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0101131:	c1 e0 0c             	shl    $0xc,%eax
f0101134:	0f 84 26 ff ff ff    	je     f0101060 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f010113a:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f010113f:	0f 84 34 ff ff ff    	je     f0101079 <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101145:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f010114a:	0f 84 42 ff ff ff    	je     f0101092 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101150:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101155:	0f 84 50 ff ff ff    	je     f01010ab <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f010115b:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101160:	0f 87 5e ff ff ff    	ja     f01010c4 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101166:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010116b:	75 9b                	jne    f0101108 <check_page_free_list+0x1b8>
f010116d:	68 f8 92 10 f0       	push   $0xf01092f8
f0101172:	68 8b 92 10 f0       	push   $0xf010928b
f0101177:	68 04 03 00 00       	push   $0x304
f010117c:	68 65 92 10 f0       	push   $0xf0109265
f0101181:	e8 c3 ee ff ff       	call   f0100049 <_panic>
f0101186:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0101189:	85 db                	test   %ebx,%ebx
f010118b:	7e 19                	jle    f01011a6 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f010118d:	85 ff                	test   %edi,%edi
f010118f:	7e 2e                	jle    f01011bf <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0101191:	83 ec 0c             	sub    $0xc,%esp
f0101194:	68 58 89 10 f0       	push   $0xf0108958
f0101199:	e8 58 30 00 00       	call   f01041f6 <cprintf>
}
f010119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011a1:	5b                   	pop    %ebx
f01011a2:	5e                   	pop    %esi
f01011a3:	5f                   	pop    %edi
f01011a4:	5d                   	pop    %ebp
f01011a5:	c3                   	ret    
	assert(nfree_basemem > 0);
f01011a6:	68 15 93 10 f0       	push   $0xf0109315
f01011ab:	68 8b 92 10 f0       	push   $0xf010928b
f01011b0:	68 0b 03 00 00       	push   $0x30b
f01011b5:	68 65 92 10 f0       	push   $0xf0109265
f01011ba:	e8 8a ee ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f01011bf:	68 27 93 10 f0       	push   $0xf0109327
f01011c4:	68 8b 92 10 f0       	push   $0xf010928b
f01011c9:	68 0c 03 00 00       	push   $0x30c
f01011ce:	68 65 92 10 f0       	push   $0xf0109265
f01011d3:	e8 71 ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f01011d8:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f01011dd:	85 c0                	test   %eax,%eax
f01011df:	0f 84 8f fd ff ff    	je     f0100f74 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f01011e5:	8d 55 d8             	lea    -0x28(%ebp),%edx
f01011e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01011eb:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01011ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01011f1:	89 c2                	mov    %eax,%edx
f01011f3:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f01011f9:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f01011ff:	0f 95 c2             	setne  %dl
f0101202:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0101205:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0101209:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f010120b:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f010120f:	8b 00                	mov    (%eax),%eax
f0101211:	85 c0                	test   %eax,%eax
f0101213:	75 dc                	jne    f01011f1 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0101215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f010121e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101221:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101224:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0101226:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101229:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010122e:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0101233:	8b 1d 40 d9 5d f0    	mov    0xf05dd940,%ebx
f0101239:	e9 61 fd ff ff       	jmp    f0100f9f <check_page_free_list+0x4f>

f010123e <page_init>:
{
f010123e:	55                   	push   %ebp
f010123f:	89 e5                	mov    %esp,%ebp
f0101241:	53                   	push   %ebx
f0101242:	83 ec 04             	sub    $0x4,%esp
	for (size_t i = 0; i < npages; i++) {
f0101245:	bb 00 00 00 00       	mov    $0x0,%ebx
f010124a:	eb 4c                	jmp    f0101298 <page_init+0x5a>
		else if(i == MPENTRY_PADDR/PGSIZE){
f010124c:	83 fb 07             	cmp    $0x7,%ebx
f010124f:	74 32                	je     f0101283 <page_init+0x45>
		else if(i < IOPHYSMEM/PGSIZE){ //[PGSIZE, npages_basemem * PGSIZE)
f0101251:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f0101257:	77 62                	ja     f01012bb <page_init+0x7d>
f0101259:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f0101260:	89 c2                	mov    %eax,%edx
f0101262:	03 15 90 ed 5d f0    	add    0xf05ded90,%edx
f0101268:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f010126e:	8b 0d 40 d9 5d f0    	mov    0xf05dd940,%ecx
f0101274:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f0101276:	03 05 90 ed 5d f0    	add    0xf05ded90,%eax
f010127c:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
f0101281:	eb 12                	jmp    f0101295 <page_init+0x57>
			pages[i].pp_ref = 1;
f0101283:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f0101288:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f010128e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f0101295:	83 c3 01             	add    $0x1,%ebx
f0101298:	39 1d 88 ed 5d f0    	cmp    %ebx,0xf05ded88
f010129e:	0f 86 94 00 00 00    	jbe    f0101338 <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f01012a4:	85 db                	test   %ebx,%ebx
f01012a6:	75 a4                	jne    f010124c <page_init+0xe>
			pages[i].pp_ref = 1;
f01012a8:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f01012ad:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f01012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01012b9:	eb da                	jmp    f0101295 <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f01012bb:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01012c1:	77 16                	ja     f01012d9 <page_init+0x9b>
			pages[i].pp_ref = 1;
f01012c3:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f01012c8:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
f01012cb:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f01012d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01012d7:	eb bc                	jmp    f0101295 <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f01012d9:	b8 00 00 00 00       	mov    $0x0,%eax
f01012de:	e8 c7 fb ff ff       	call   f0100eaa <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f01012e3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01012e8:	76 39                	jbe    f0101323 <page_init+0xe5>
	return (physaddr_t)kva - KERNBASE;
f01012ea:	05 00 00 00 10       	add    $0x10000000,%eax
f01012ef:	c1 e8 0c             	shr    $0xc,%eax
f01012f2:	39 d8                	cmp    %ebx,%eax
f01012f4:	77 cd                	ja     f01012c3 <page_init+0x85>
f01012f6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f01012fd:	89 c2                	mov    %eax,%edx
f01012ff:	03 15 90 ed 5d f0    	add    0xf05ded90,%edx
f0101305:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f010130b:	8b 0d 40 d9 5d f0    	mov    0xf05dd940,%ecx
f0101311:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f0101313:	03 05 90 ed 5d f0    	add    0xf05ded90,%eax
f0101319:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
f010131e:	e9 72 ff ff ff       	jmp    f0101295 <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101323:	50                   	push   %eax
f0101324:	68 98 80 10 f0       	push   $0xf0108098
f0101329:	68 50 01 00 00       	push   $0x150
f010132e:	68 65 92 10 f0       	push   $0xf0109265
f0101333:	e8 11 ed ff ff       	call   f0100049 <_panic>
}
f0101338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010133b:	c9                   	leave  
f010133c:	c3                   	ret    

f010133d <page_alloc>:
{
f010133d:	55                   	push   %ebp
f010133e:	89 e5                	mov    %esp,%ebp
f0101340:	53                   	push   %ebx
f0101341:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list)
f0101344:	8b 1d 40 d9 5d f0    	mov    0xf05dd940,%ebx
f010134a:	85 db                	test   %ebx,%ebx
f010134c:	74 13                	je     f0101361 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f010134e:	8b 03                	mov    (%ebx),%eax
f0101350:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
	result->pp_link = NULL;
f0101355:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f010135b:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f010135f:	75 07                	jne    f0101368 <page_alloc+0x2b>
}
f0101361:	89 d8                	mov    %ebx,%eax
f0101363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101366:	c9                   	leave  
f0101367:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101368:	89 d8                	mov    %ebx,%eax
f010136a:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0101370:	c1 f8 03             	sar    $0x3,%eax
f0101373:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101376:	89 c2                	mov    %eax,%edx
f0101378:	c1 ea 0c             	shr    $0xc,%edx
f010137b:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0101381:	73 1a                	jae    f010139d <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f0101383:	83 ec 04             	sub    $0x4,%esp
f0101386:	68 00 10 00 00       	push   $0x1000
f010138b:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010138d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101392:	50                   	push   %eax
f0101393:	e8 6c 55 00 00       	call   f0106904 <memset>
f0101398:	83 c4 10             	add    $0x10,%esp
f010139b:	eb c4                	jmp    f0101361 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010139d:	50                   	push   %eax
f010139e:	68 74 80 10 f0       	push   $0xf0108074
f01013a3:	6a 58                	push   $0x58
f01013a5:	68 71 92 10 f0       	push   $0xf0109271
f01013aa:	e8 9a ec ff ff       	call   f0100049 <_panic>

f01013af <page_free>:
{
f01013af:	55                   	push   %ebp
f01013b0:	89 e5                	mov    %esp,%ebp
f01013b2:	83 ec 08             	sub    $0x8,%esp
f01013b5:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0 || pp->pp_link != NULL){
f01013b8:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01013bd:	75 14                	jne    f01013d3 <page_free+0x24>
f01013bf:	83 38 00             	cmpl   $0x0,(%eax)
f01013c2:	75 0f                	jne    f01013d3 <page_free+0x24>
	pp->pp_link = page_free_list;
f01013c4:	8b 15 40 d9 5d f0    	mov    0xf05dd940,%edx
f01013ca:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f01013cc:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
}
f01013d1:	c9                   	leave  
f01013d2:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f01013d3:	83 ec 04             	sub    $0x4,%esp
f01013d6:	68 7c 89 10 f0       	push   $0xf010897c
f01013db:	68 84 01 00 00       	push   $0x184
f01013e0:	68 65 92 10 f0       	push   $0xf0109265
f01013e5:	e8 5f ec ff ff       	call   f0100049 <_panic>

f01013ea <page_decref>:
{
f01013ea:	55                   	push   %ebp
f01013eb:	89 e5                	mov    %esp,%ebp
f01013ed:	83 ec 08             	sub    $0x8,%esp
f01013f0:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01013f3:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01013f7:	83 e8 01             	sub    $0x1,%eax
f01013fa:	66 89 42 04          	mov    %ax,0x4(%edx)
f01013fe:	66 85 c0             	test   %ax,%ax
f0101401:	74 02                	je     f0101405 <page_decref+0x1b>
}
f0101403:	c9                   	leave  
f0101404:	c3                   	ret    
		page_free(pp);
f0101405:	83 ec 0c             	sub    $0xc,%esp
f0101408:	52                   	push   %edx
f0101409:	e8 a1 ff ff ff       	call   f01013af <page_free>
f010140e:	83 c4 10             	add    $0x10,%esp
}
f0101411:	eb f0                	jmp    f0101403 <page_decref+0x19>

f0101413 <pgdir_walk>:
{
f0101413:	55                   	push   %ebp
f0101414:	89 e5                	mov    %esp,%ebp
f0101416:	56                   	push   %esi
f0101417:	53                   	push   %ebx
f0101418:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *fir_level = &pgdir[PDX(va)];
f010141b:	89 f3                	mov    %esi,%ebx
f010141d:	c1 eb 16             	shr    $0x16,%ebx
f0101420:	c1 e3 02             	shl    $0x2,%ebx
f0101423:	03 5d 08             	add    0x8(%ebp),%ebx
	if(*fir_level==0 && create == false){
f0101426:	8b 03                	mov    (%ebx),%eax
f0101428:	89 c1                	mov    %eax,%ecx
f010142a:	0b 4d 10             	or     0x10(%ebp),%ecx
f010142d:	0f 84 a8 00 00 00    	je     f01014db <pgdir_walk+0xc8>
	else if(*fir_level==0){
f0101433:	85 c0                	test   %eax,%eax
f0101435:	74 29                	je     f0101460 <pgdir_walk+0x4d>
		sec_level = (pte_t *)(KADDR(PTE_ADDR(*fir_level)));
f0101437:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010143c:	89 c2                	mov    %eax,%edx
f010143e:	c1 ea 0c             	shr    $0xc,%edx
f0101441:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0101447:	73 7d                	jae    f01014c6 <pgdir_walk+0xb3>
		return &sec_level[PTX(va)];
f0101449:	c1 ee 0a             	shr    $0xa,%esi
f010144c:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101452:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f0101459:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010145c:	5b                   	pop    %ebx
f010145d:	5e                   	pop    %esi
f010145e:	5d                   	pop    %ebp
f010145f:	c3                   	ret    
		struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
f0101460:	83 ec 0c             	sub    $0xc,%esp
f0101463:	6a 01                	push   $0x1
f0101465:	e8 d3 fe ff ff       	call   f010133d <page_alloc>
		if(new_page == NULL)
f010146a:	83 c4 10             	add    $0x10,%esp
f010146d:	85 c0                	test   %eax,%eax
f010146f:	74 e8                	je     f0101459 <pgdir_walk+0x46>
		new_page->pp_ref++;
f0101471:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101476:	89 c2                	mov    %eax,%edx
f0101478:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f010147e:	c1 fa 03             	sar    $0x3,%edx
f0101481:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f0101484:	83 ca 07             	or     $0x7,%edx
f0101487:	89 13                	mov    %edx,(%ebx)
f0101489:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010148f:	c1 f8 03             	sar    $0x3,%eax
f0101492:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101495:	89 c2                	mov    %eax,%edx
f0101497:	c1 ea 0c             	shr    $0xc,%edx
f010149a:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f01014a0:	73 12                	jae    f01014b4 <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f01014a2:	c1 ee 0a             	shr    $0xa,%esi
f01014a5:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01014ab:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f01014b2:	eb a5                	jmp    f0101459 <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01014b4:	50                   	push   %eax
f01014b5:	68 74 80 10 f0       	push   $0xf0108074
f01014ba:	6a 58                	push   $0x58
f01014bc:	68 71 92 10 f0       	push   $0xf0109271
f01014c1:	e8 83 eb ff ff       	call   f0100049 <_panic>
f01014c6:	50                   	push   %eax
f01014c7:	68 74 80 10 f0       	push   $0xf0108074
f01014cc:	68 be 01 00 00       	push   $0x1be
f01014d1:	68 65 92 10 f0       	push   $0xf0109265
f01014d6:	e8 6e eb ff ff       	call   f0100049 <_panic>
		return NULL;
f01014db:	b8 00 00 00 00       	mov    $0x0,%eax
f01014e0:	e9 74 ff ff ff       	jmp    f0101459 <pgdir_walk+0x46>

f01014e5 <boot_map_region>:
{
f01014e5:	55                   	push   %ebp
f01014e6:	89 e5                	mov    %esp,%ebp
f01014e8:	57                   	push   %edi
f01014e9:	56                   	push   %esi
f01014ea:	53                   	push   %ebx
f01014eb:	83 ec 1c             	sub    $0x1c,%esp
f01014ee:	89 c7                	mov    %eax,%edi
f01014f0:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(va%PGSIZE==0);
f01014f3:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01014f9:	75 4b                	jne    f0101546 <boot_map_region+0x61>
	assert(pa%PGSIZE==0);
f01014fb:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0101500:	75 5d                	jne    f010155f <boot_map_region+0x7a>
f0101502:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0101508:	01 c1                	add    %eax,%ecx
f010150a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f010150d:	89 c3                	mov    %eax,%ebx
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f010150f:	89 d6                	mov    %edx,%esi
f0101511:	29 c6                	sub    %eax,%esi
	for(int i = 0; i < size/PGSIZE; i++){
f0101513:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101516:	74 79                	je     f0101591 <boot_map_region+0xac>
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f0101518:	83 ec 04             	sub    $0x4,%esp
f010151b:	6a 01                	push   $0x1
f010151d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f0101520:	50                   	push   %eax
f0101521:	57                   	push   %edi
f0101522:	e8 ec fe ff ff       	call   f0101413 <pgdir_walk>
		if(the_pte==NULL)
f0101527:	83 c4 10             	add    $0x10,%esp
f010152a:	85 c0                	test   %eax,%eax
f010152c:	74 4a                	je     f0101578 <boot_map_region+0x93>
		*the_pte = PTE_ADDR(pa) | perm | PTE_P;
f010152e:	89 da                	mov    %ebx,%edx
f0101530:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101536:	0b 55 0c             	or     0xc(%ebp),%edx
f0101539:	83 ca 01             	or     $0x1,%edx
f010153c:	89 10                	mov    %edx,(%eax)
		pa+=PGSIZE;
f010153e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101544:	eb cd                	jmp    f0101513 <boot_map_region+0x2e>
	assert(va%PGSIZE==0);
f0101546:	68 38 93 10 f0       	push   $0xf0109338
f010154b:	68 8b 92 10 f0       	push   $0xf010928b
f0101550:	68 d3 01 00 00       	push   $0x1d3
f0101555:	68 65 92 10 f0       	push   $0xf0109265
f010155a:	e8 ea ea ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f010155f:	68 45 93 10 f0       	push   $0xf0109345
f0101564:	68 8b 92 10 f0       	push   $0xf010928b
f0101569:	68 d4 01 00 00       	push   $0x1d4
f010156e:	68 65 92 10 f0       	push   $0xf0109265
f0101573:	e8 d1 ea ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f0101578:	68 f8 95 10 f0       	push   $0xf01095f8
f010157d:	68 52 93 10 f0       	push   $0xf0109352
f0101582:	68 d8 01 00 00       	push   $0x1d8
f0101587:	68 65 92 10 f0       	push   $0xf0109265
f010158c:	e8 b8 ea ff ff       	call   f0100049 <_panic>
}
f0101591:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101594:	5b                   	pop    %ebx
f0101595:	5e                   	pop    %esi
f0101596:	5f                   	pop    %edi
f0101597:	5d                   	pop    %ebp
f0101598:	c3                   	ret    

f0101599 <page_lookup>:
{
f0101599:	55                   	push   %ebp
f010159a:	89 e5                	mov    %esp,%ebp
f010159c:	53                   	push   %ebx
f010159d:	83 ec 08             	sub    $0x8,%esp
f01015a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *look_mapping = pgdir_walk(pgdir, va, 0);
f01015a3:	6a 00                	push   $0x0
f01015a5:	ff 75 0c             	pushl  0xc(%ebp)
f01015a8:	ff 75 08             	pushl  0x8(%ebp)
f01015ab:	e8 63 fe ff ff       	call   f0101413 <pgdir_walk>
	if(look_mapping == NULL)
f01015b0:	83 c4 10             	add    $0x10,%esp
f01015b3:	85 c0                	test   %eax,%eax
f01015b5:	74 27                	je     f01015de <page_lookup+0x45>
	if(*look_mapping==0)
f01015b7:	8b 10                	mov    (%eax),%edx
f01015b9:	85 d2                	test   %edx,%edx
f01015bb:	74 3a                	je     f01015f7 <page_lookup+0x5e>
	if(pte_store!=NULL && (*look_mapping&PTE_P))
f01015bd:	85 db                	test   %ebx,%ebx
f01015bf:	74 07                	je     f01015c8 <page_lookup+0x2f>
f01015c1:	f6 c2 01             	test   $0x1,%dl
f01015c4:	74 02                	je     f01015c8 <page_lookup+0x2f>
		*pte_store = look_mapping;
f01015c6:	89 03                	mov    %eax,(%ebx)
f01015c8:	8b 00                	mov    (%eax),%eax
f01015ca:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01015cd:	39 05 88 ed 5d f0    	cmp    %eax,0xf05ded88
f01015d3:	76 0e                	jbe    f01015e3 <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01015d5:	8b 15 90 ed 5d f0    	mov    0xf05ded90,%edx
f01015db:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f01015de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01015e1:	c9                   	leave  
f01015e2:	c3                   	ret    
		panic("pa2page called with invalid pa");
f01015e3:	83 ec 04             	sub    $0x4,%esp
f01015e6:	68 b0 89 10 f0       	push   $0xf01089b0
f01015eb:	6a 51                	push   $0x51
f01015ed:	68 71 92 10 f0       	push   $0xf0109271
f01015f2:	e8 52 ea ff ff       	call   f0100049 <_panic>
		return NULL;
f01015f7:	b8 00 00 00 00       	mov    $0x0,%eax
f01015fc:	eb e0                	jmp    f01015de <page_lookup+0x45>

f01015fe <tlb_invalidate>:
{
f01015fe:	55                   	push   %ebp
f01015ff:	89 e5                	mov    %esp,%ebp
f0101601:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101604:	e8 01 59 00 00       	call   f0106f0a <cpunum>
f0101609:	6b c0 74             	imul   $0x74,%eax,%eax
f010160c:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0101613:	74 16                	je     f010162b <tlb_invalidate+0x2d>
f0101615:	e8 f0 58 00 00       	call   f0106f0a <cpunum>
f010161a:	6b c0 74             	imul   $0x74,%eax,%eax
f010161d:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0101623:	8b 55 08             	mov    0x8(%ebp),%edx
f0101626:	39 50 60             	cmp    %edx,0x60(%eax)
f0101629:	75 06                	jne    f0101631 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010162b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010162e:	0f 01 38             	invlpg (%eax)
}
f0101631:	c9                   	leave  
f0101632:	c3                   	ret    

f0101633 <page_remove>:
{
f0101633:	55                   	push   %ebp
f0101634:	89 e5                	mov    %esp,%ebp
f0101636:	56                   	push   %esi
f0101637:	53                   	push   %ebx
f0101638:	83 ec 14             	sub    $0x14,%esp
f010163b:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010163e:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *the_page = page_lookup(pgdir, va, &pg_store);
f0101641:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101644:	50                   	push   %eax
f0101645:	56                   	push   %esi
f0101646:	53                   	push   %ebx
f0101647:	e8 4d ff ff ff       	call   f0101599 <page_lookup>
	if(!the_page)
f010164c:	83 c4 10             	add    $0x10,%esp
f010164f:	85 c0                	test   %eax,%eax
f0101651:	74 1f                	je     f0101672 <page_remove+0x3f>
	page_decref(the_page);
f0101653:	83 ec 0c             	sub    $0xc,%esp
f0101656:	50                   	push   %eax
f0101657:	e8 8e fd ff ff       	call   f01013ea <page_decref>
	*pg_store = 0;
f010165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010165f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f0101665:	83 c4 08             	add    $0x8,%esp
f0101668:	56                   	push   %esi
f0101669:	53                   	push   %ebx
f010166a:	e8 8f ff ff ff       	call   f01015fe <tlb_invalidate>
f010166f:	83 c4 10             	add    $0x10,%esp
}
f0101672:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101675:	5b                   	pop    %ebx
f0101676:	5e                   	pop    %esi
f0101677:	5d                   	pop    %ebp
f0101678:	c3                   	ret    

f0101679 <page_insert>:
{
f0101679:	55                   	push   %ebp
f010167a:	89 e5                	mov    %esp,%ebp
f010167c:	57                   	push   %edi
f010167d:	56                   	push   %esi
f010167e:	53                   	push   %ebx
f010167f:	83 ec 10             	sub    $0x10,%esp
f0101682:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *the_pte = pgdir_walk(pgdir, va, 1);
f0101685:	6a 01                	push   $0x1
f0101687:	ff 75 10             	pushl  0x10(%ebp)
f010168a:	ff 75 08             	pushl  0x8(%ebp)
f010168d:	e8 81 fd ff ff       	call   f0101413 <pgdir_walk>
	if(the_pte == NULL){
f0101692:	83 c4 10             	add    $0x10,%esp
f0101695:	85 c0                	test   %eax,%eax
f0101697:	0f 84 b7 00 00 00    	je     f0101754 <page_insert+0xdb>
f010169d:	89 c6                	mov    %eax,%esi
		if(KADDR(PTE_ADDR(*the_pte)) == page2kva(pp)){
f010169f:	8b 10                	mov    (%eax),%edx
f01016a1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f01016a7:	8b 0d 88 ed 5d f0    	mov    0xf05ded88,%ecx
f01016ad:	89 d0                	mov    %edx,%eax
f01016af:	c1 e8 0c             	shr    $0xc,%eax
f01016b2:	39 c1                	cmp    %eax,%ecx
f01016b4:	76 5f                	jbe    f0101715 <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f01016b6:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f01016bc:	89 d8                	mov    %ebx,%eax
f01016be:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01016c4:	c1 f8 03             	sar    $0x3,%eax
f01016c7:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01016ca:	89 c7                	mov    %eax,%edi
f01016cc:	c1 ef 0c             	shr    $0xc,%edi
f01016cf:	39 f9                	cmp    %edi,%ecx
f01016d1:	76 57                	jbe    f010172a <page_insert+0xb1>
	return (void *)(pa + KERNBASE);
f01016d3:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01016d8:	39 c2                	cmp    %eax,%edx
f01016da:	74 60                	je     f010173c <page_insert+0xc3>
			page_remove(pgdir, va);
f01016dc:	83 ec 08             	sub    $0x8,%esp
f01016df:	ff 75 10             	pushl  0x10(%ebp)
f01016e2:	ff 75 08             	pushl  0x8(%ebp)
f01016e5:	e8 49 ff ff ff       	call   f0101633 <page_remove>
f01016ea:	83 c4 10             	add    $0x10,%esp
	return (pp - pages) << PGSHIFT;
f01016ed:	89 d8                	mov    %ebx,%eax
f01016ef:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01016f5:	c1 f8 03             	sar    $0x3,%eax
f01016f8:	c1 e0 0c             	shl    $0xc,%eax
	*the_pte = page2pa(pp) | perm | PTE_P;
f01016fb:	0b 45 14             	or     0x14(%ebp),%eax
f01016fe:	83 c8 01             	or     $0x1,%eax
f0101701:	89 06                	mov    %eax,(%esi)
	pp->pp_ref++;
f0101703:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	return 0;
f0101708:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010170d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101710:	5b                   	pop    %ebx
f0101711:	5e                   	pop    %esi
f0101712:	5f                   	pop    %edi
f0101713:	5d                   	pop    %ebp
f0101714:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101715:	52                   	push   %edx
f0101716:	68 74 80 10 f0       	push   $0xf0108074
f010171b:	68 1a 02 00 00       	push   $0x21a
f0101720:	68 65 92 10 f0       	push   $0xf0109265
f0101725:	e8 1f e9 ff ff       	call   f0100049 <_panic>
f010172a:	50                   	push   %eax
f010172b:	68 74 80 10 f0       	push   $0xf0108074
f0101730:	6a 58                	push   $0x58
f0101732:	68 71 92 10 f0       	push   $0xf0109271
f0101737:	e8 0d e9 ff ff       	call   f0100049 <_panic>
			tlb_invalidate(pgdir, va);
f010173c:	83 ec 08             	sub    $0x8,%esp
f010173f:	ff 75 10             	pushl  0x10(%ebp)
f0101742:	ff 75 08             	pushl  0x8(%ebp)
f0101745:	e8 b4 fe ff ff       	call   f01015fe <tlb_invalidate>
			pp->pp_ref--;
f010174a:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
f010174f:	83 c4 10             	add    $0x10,%esp
f0101752:	eb 99                	jmp    f01016ed <page_insert+0x74>
		return -E_NO_MEM;
f0101754:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101759:	eb b2                	jmp    f010170d <page_insert+0x94>

f010175b <mmio_map_region>:
{
f010175b:	55                   	push   %ebp
f010175c:	89 e5                	mov    %esp,%ebp
f010175e:	56                   	push   %esi
f010175f:	53                   	push   %ebx
	size = ROUNDUP(size, PGSIZE);
f0101760:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101763:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f0101769:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((base + size) > MMIOLIM){
f010176f:	8b 35 04 d3 16 f0    	mov    0xf016d304,%esi
f0101775:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f0101778:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f010177d:	77 25                	ja     f01017a4 <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f010177f:	83 ec 08             	sub    $0x8,%esp
f0101782:	6a 1a                	push   $0x1a
f0101784:	ff 75 08             	pushl  0x8(%ebp)
f0101787:	89 d9                	mov    %ebx,%ecx
f0101789:	89 f2                	mov    %esi,%edx
f010178b:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0101790:	e8 50 fd ff ff       	call   f01014e5 <boot_map_region>
	base += size;
f0101795:	01 1d 04 d3 16 f0    	add    %ebx,0xf016d304
}
f010179b:	89 f0                	mov    %esi,%eax
f010179d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01017a0:	5b                   	pop    %ebx
f01017a1:	5e                   	pop    %esi
f01017a2:	5d                   	pop    %ebp
f01017a3:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f01017a4:	83 ec 04             	sub    $0x4,%esp
f01017a7:	68 5c 93 10 f0       	push   $0xf010935c
f01017ac:	68 8b 02 00 00       	push   $0x28b
f01017b1:	68 65 92 10 f0       	push   $0xf0109265
f01017b6:	e8 8e e8 ff ff       	call   f0100049 <_panic>

f01017bb <mem_init>:
{
f01017bb:	55                   	push   %ebp
f01017bc:	89 e5                	mov    %esp,%ebp
f01017be:	57                   	push   %edi
f01017bf:	56                   	push   %esi
f01017c0:	53                   	push   %ebx
f01017c1:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01017c4:	b8 15 00 00 00       	mov    $0x15,%eax
f01017c9:	e8 4f f6 ff ff       	call   f0100e1d <nvram_read>
f01017ce:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01017d0:	b8 17 00 00 00       	mov    $0x17,%eax
f01017d5:	e8 43 f6 ff ff       	call   f0100e1d <nvram_read>
f01017da:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01017dc:	b8 34 00 00 00       	mov    $0x34,%eax
f01017e1:	e8 37 f6 ff ff       	call   f0100e1d <nvram_read>
	if (ext16mem)
f01017e6:	c1 e0 06             	shl    $0x6,%eax
f01017e9:	0f 84 e5 00 00 00    	je     f01018d4 <mem_init+0x119>
		totalmem = 16 * 1024 + ext16mem;
f01017ef:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01017f4:	89 c2                	mov    %eax,%edx
f01017f6:	c1 ea 02             	shr    $0x2,%edx
f01017f9:	89 15 88 ed 5d f0    	mov    %edx,0xf05ded88
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01017ff:	89 c2                	mov    %eax,%edx
f0101801:	29 da                	sub    %ebx,%edx
f0101803:	52                   	push   %edx
f0101804:	53                   	push   %ebx
f0101805:	50                   	push   %eax
f0101806:	68 d0 89 10 f0       	push   $0xf01089d0
f010180b:	e8 e6 29 00 00       	call   f01041f6 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101810:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101815:	e8 90 f6 ff ff       	call   f0100eaa <boot_alloc>
f010181a:	a3 8c ed 5d f0       	mov    %eax,0xf05ded8c
	memset(kern_pgdir, 0, PGSIZE);
f010181f:	83 c4 0c             	add    $0xc,%esp
f0101822:	68 00 10 00 00       	push   $0x1000
f0101827:	6a 00                	push   $0x0
f0101829:	50                   	push   %eax
f010182a:	e8 d5 50 00 00       	call   f0106904 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f010182f:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101834:	83 c4 10             	add    $0x10,%esp
f0101837:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010183c:	0f 86 a2 00 00 00    	jbe    f01018e4 <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f0101842:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101848:	83 ca 05             	or     $0x5,%edx
f010184b:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f0101851:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f0101856:	c1 e0 03             	shl    $0x3,%eax
f0101859:	e8 4c f6 ff ff       	call   f0100eaa <boot_alloc>
f010185e:	a3 90 ed 5d f0       	mov    %eax,0xf05ded90
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f0101863:	83 ec 04             	sub    $0x4,%esp
f0101866:	8b 15 88 ed 5d f0    	mov    0xf05ded88,%edx
f010186c:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0101873:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101879:	52                   	push   %edx
f010187a:	6a 00                	push   $0x0
f010187c:	50                   	push   %eax
f010187d:	e8 82 50 00 00       	call   f0106904 <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101882:	b8 00 10 02 00       	mov    $0x21000,%eax
f0101887:	e8 1e f6 ff ff       	call   f0100eaa <boot_alloc>
f010188c:	a3 44 d9 5d f0       	mov    %eax,0xf05dd944
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101891:	83 c4 0c             	add    $0xc,%esp
f0101894:	68 00 10 02 00       	push   $0x21000
f0101899:	6a 00                	push   $0x0
f010189b:	50                   	push   %eax
f010189c:	e8 63 50 00 00       	call   f0106904 <memset>
	page_init();
f01018a1:	e8 98 f9 ff ff       	call   f010123e <page_init>
	check_page_free_list(1);
f01018a6:	b8 01 00 00 00       	mov    $0x1,%eax
f01018ab:	e8 a0 f6 ff ff       	call   f0100f50 <check_page_free_list>
	if (!pages)
f01018b0:	83 c4 10             	add    $0x10,%esp
f01018b3:	83 3d 90 ed 5d f0 00 	cmpl   $0x0,0xf05ded90
f01018ba:	74 3d                	je     f01018f9 <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01018bc:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f01018c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f01018c8:	85 c0                	test   %eax,%eax
f01018ca:	74 44                	je     f0101910 <mem_init+0x155>
		++nfree;
f01018cc:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01018d0:	8b 00                	mov    (%eax),%eax
f01018d2:	eb f4                	jmp    f01018c8 <mem_init+0x10d>
		totalmem = 1 * 1024 + extmem;
f01018d4:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01018da:	85 f6                	test   %esi,%esi
f01018dc:	0f 44 c3             	cmove  %ebx,%eax
f01018df:	e9 10 ff ff ff       	jmp    f01017f4 <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01018e4:	50                   	push   %eax
f01018e5:	68 98 80 10 f0       	push   $0xf0108098
f01018ea:	68 9b 00 00 00       	push   $0x9b
f01018ef:	68 65 92 10 f0       	push   $0xf0109265
f01018f4:	e8 50 e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f01018f9:	83 ec 04             	sub    $0x4,%esp
f01018fc:	68 6e 93 10 f0       	push   $0xf010936e
f0101901:	68 1f 03 00 00       	push   $0x31f
f0101906:	68 65 92 10 f0       	push   $0xf0109265
f010190b:	e8 39 e7 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101910:	83 ec 0c             	sub    $0xc,%esp
f0101913:	6a 00                	push   $0x0
f0101915:	e8 23 fa ff ff       	call   f010133d <page_alloc>
f010191a:	89 c3                	mov    %eax,%ebx
f010191c:	83 c4 10             	add    $0x10,%esp
f010191f:	85 c0                	test   %eax,%eax
f0101921:	0f 84 00 02 00 00    	je     f0101b27 <mem_init+0x36c>
	assert((pp1 = page_alloc(0)));
f0101927:	83 ec 0c             	sub    $0xc,%esp
f010192a:	6a 00                	push   $0x0
f010192c:	e8 0c fa ff ff       	call   f010133d <page_alloc>
f0101931:	89 c6                	mov    %eax,%esi
f0101933:	83 c4 10             	add    $0x10,%esp
f0101936:	85 c0                	test   %eax,%eax
f0101938:	0f 84 02 02 00 00    	je     f0101b40 <mem_init+0x385>
	assert((pp2 = page_alloc(0)));
f010193e:	83 ec 0c             	sub    $0xc,%esp
f0101941:	6a 00                	push   $0x0
f0101943:	e8 f5 f9 ff ff       	call   f010133d <page_alloc>
f0101948:	89 c7                	mov    %eax,%edi
f010194a:	83 c4 10             	add    $0x10,%esp
f010194d:	85 c0                	test   %eax,%eax
f010194f:	0f 84 04 02 00 00    	je     f0101b59 <mem_init+0x39e>
	assert(pp1 && pp1 != pp0);
f0101955:	39 f3                	cmp    %esi,%ebx
f0101957:	0f 84 15 02 00 00    	je     f0101b72 <mem_init+0x3b7>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010195d:	39 c3                	cmp    %eax,%ebx
f010195f:	0f 84 26 02 00 00    	je     f0101b8b <mem_init+0x3d0>
f0101965:	39 c6                	cmp    %eax,%esi
f0101967:	0f 84 1e 02 00 00    	je     f0101b8b <mem_init+0x3d0>
	return (pp - pages) << PGSHIFT;
f010196d:	8b 0d 90 ed 5d f0    	mov    0xf05ded90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101973:	8b 15 88 ed 5d f0    	mov    0xf05ded88,%edx
f0101979:	c1 e2 0c             	shl    $0xc,%edx
f010197c:	89 d8                	mov    %ebx,%eax
f010197e:	29 c8                	sub    %ecx,%eax
f0101980:	c1 f8 03             	sar    $0x3,%eax
f0101983:	c1 e0 0c             	shl    $0xc,%eax
f0101986:	39 d0                	cmp    %edx,%eax
f0101988:	0f 83 16 02 00 00    	jae    f0101ba4 <mem_init+0x3e9>
f010198e:	89 f0                	mov    %esi,%eax
f0101990:	29 c8                	sub    %ecx,%eax
f0101992:	c1 f8 03             	sar    $0x3,%eax
f0101995:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101998:	39 c2                	cmp    %eax,%edx
f010199a:	0f 86 1d 02 00 00    	jbe    f0101bbd <mem_init+0x402>
f01019a0:	89 f8                	mov    %edi,%eax
f01019a2:	29 c8                	sub    %ecx,%eax
f01019a4:	c1 f8 03             	sar    $0x3,%eax
f01019a7:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f01019aa:	39 c2                	cmp    %eax,%edx
f01019ac:	0f 86 24 02 00 00    	jbe    f0101bd6 <mem_init+0x41b>
	fl = page_free_list;
f01019b2:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f01019b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01019ba:	c7 05 40 d9 5d f0 00 	movl   $0x0,0xf05dd940
f01019c1:	00 00 00 
	assert(!page_alloc(0));
f01019c4:	83 ec 0c             	sub    $0xc,%esp
f01019c7:	6a 00                	push   $0x0
f01019c9:	e8 6f f9 ff ff       	call   f010133d <page_alloc>
f01019ce:	83 c4 10             	add    $0x10,%esp
f01019d1:	85 c0                	test   %eax,%eax
f01019d3:	0f 85 16 02 00 00    	jne    f0101bef <mem_init+0x434>
	page_free(pp0);
f01019d9:	83 ec 0c             	sub    $0xc,%esp
f01019dc:	53                   	push   %ebx
f01019dd:	e8 cd f9 ff ff       	call   f01013af <page_free>
	page_free(pp1);
f01019e2:	89 34 24             	mov    %esi,(%esp)
f01019e5:	e8 c5 f9 ff ff       	call   f01013af <page_free>
	page_free(pp2);
f01019ea:	89 3c 24             	mov    %edi,(%esp)
f01019ed:	e8 bd f9 ff ff       	call   f01013af <page_free>
	assert((pp0 = page_alloc(0)));
f01019f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01019f9:	e8 3f f9 ff ff       	call   f010133d <page_alloc>
f01019fe:	89 c3                	mov    %eax,%ebx
f0101a00:	83 c4 10             	add    $0x10,%esp
f0101a03:	85 c0                	test   %eax,%eax
f0101a05:	0f 84 fd 01 00 00    	je     f0101c08 <mem_init+0x44d>
	assert((pp1 = page_alloc(0)));
f0101a0b:	83 ec 0c             	sub    $0xc,%esp
f0101a0e:	6a 00                	push   $0x0
f0101a10:	e8 28 f9 ff ff       	call   f010133d <page_alloc>
f0101a15:	89 c6                	mov    %eax,%esi
f0101a17:	83 c4 10             	add    $0x10,%esp
f0101a1a:	85 c0                	test   %eax,%eax
f0101a1c:	0f 84 ff 01 00 00    	je     f0101c21 <mem_init+0x466>
	assert((pp2 = page_alloc(0)));
f0101a22:	83 ec 0c             	sub    $0xc,%esp
f0101a25:	6a 00                	push   $0x0
f0101a27:	e8 11 f9 ff ff       	call   f010133d <page_alloc>
f0101a2c:	89 c7                	mov    %eax,%edi
f0101a2e:	83 c4 10             	add    $0x10,%esp
f0101a31:	85 c0                	test   %eax,%eax
f0101a33:	0f 84 01 02 00 00    	je     f0101c3a <mem_init+0x47f>
	assert(pp1 && pp1 != pp0);
f0101a39:	39 f3                	cmp    %esi,%ebx
f0101a3b:	0f 84 12 02 00 00    	je     f0101c53 <mem_init+0x498>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a41:	39 c6                	cmp    %eax,%esi
f0101a43:	0f 84 23 02 00 00    	je     f0101c6c <mem_init+0x4b1>
f0101a49:	39 c3                	cmp    %eax,%ebx
f0101a4b:	0f 84 1b 02 00 00    	je     f0101c6c <mem_init+0x4b1>
	assert(!page_alloc(0));
f0101a51:	83 ec 0c             	sub    $0xc,%esp
f0101a54:	6a 00                	push   $0x0
f0101a56:	e8 e2 f8 ff ff       	call   f010133d <page_alloc>
f0101a5b:	83 c4 10             	add    $0x10,%esp
f0101a5e:	85 c0                	test   %eax,%eax
f0101a60:	0f 85 1f 02 00 00    	jne    f0101c85 <mem_init+0x4ca>
f0101a66:	89 d8                	mov    %ebx,%eax
f0101a68:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0101a6e:	c1 f8 03             	sar    $0x3,%eax
f0101a71:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a74:	89 c2                	mov    %eax,%edx
f0101a76:	c1 ea 0c             	shr    $0xc,%edx
f0101a79:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0101a7f:	0f 83 19 02 00 00    	jae    f0101c9e <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a85:	83 ec 04             	sub    $0x4,%esp
f0101a88:	68 00 10 00 00       	push   $0x1000
f0101a8d:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101a8f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a94:	50                   	push   %eax
f0101a95:	e8 6a 4e 00 00       	call   f0106904 <memset>
	page_free(pp0);
f0101a9a:	89 1c 24             	mov    %ebx,(%esp)
f0101a9d:	e8 0d f9 ff ff       	call   f01013af <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101aa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101aa9:	e8 8f f8 ff ff       	call   f010133d <page_alloc>
f0101aae:	83 c4 10             	add    $0x10,%esp
f0101ab1:	85 c0                	test   %eax,%eax
f0101ab3:	0f 84 f7 01 00 00    	je     f0101cb0 <mem_init+0x4f5>
	assert(pp && pp0 == pp);
f0101ab9:	39 c3                	cmp    %eax,%ebx
f0101abb:	0f 85 08 02 00 00    	jne    f0101cc9 <mem_init+0x50e>
	return (pp - pages) << PGSHIFT;
f0101ac1:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0101ac7:	c1 f8 03             	sar    $0x3,%eax
f0101aca:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101acd:	89 c2                	mov    %eax,%edx
f0101acf:	c1 ea 0c             	shr    $0xc,%edx
f0101ad2:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0101ad8:	0f 83 04 02 00 00    	jae    f0101ce2 <mem_init+0x527>
	return (void *)(pa + KERNBASE);
f0101ade:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101ae4:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101ae9:	80 3a 00             	cmpb   $0x0,(%edx)
f0101aec:	0f 85 02 02 00 00    	jne    f0101cf4 <mem_init+0x539>
f0101af2:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101af5:	39 c2                	cmp    %eax,%edx
f0101af7:	75 f0                	jne    f0101ae9 <mem_init+0x32e>
	page_free_list = fl;
f0101af9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101afc:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
	page_free(pp0);
f0101b01:	83 ec 0c             	sub    $0xc,%esp
f0101b04:	53                   	push   %ebx
f0101b05:	e8 a5 f8 ff ff       	call   f01013af <page_free>
	page_free(pp1);
f0101b0a:	89 34 24             	mov    %esi,(%esp)
f0101b0d:	e8 9d f8 ff ff       	call   f01013af <page_free>
	page_free(pp2);
f0101b12:	89 3c 24             	mov    %edi,(%esp)
f0101b15:	e8 95 f8 ff ff       	call   f01013af <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101b1a:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f0101b1f:	83 c4 10             	add    $0x10,%esp
f0101b22:	e9 ec 01 00 00       	jmp    f0101d13 <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101b27:	68 89 93 10 f0       	push   $0xf0109389
f0101b2c:	68 8b 92 10 f0       	push   $0xf010928b
f0101b31:	68 27 03 00 00       	push   $0x327
f0101b36:	68 65 92 10 f0       	push   $0xf0109265
f0101b3b:	e8 09 e5 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101b40:	68 9f 93 10 f0       	push   $0xf010939f
f0101b45:	68 8b 92 10 f0       	push   $0xf010928b
f0101b4a:	68 28 03 00 00       	push   $0x328
f0101b4f:	68 65 92 10 f0       	push   $0xf0109265
f0101b54:	e8 f0 e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101b59:	68 b5 93 10 f0       	push   $0xf01093b5
f0101b5e:	68 8b 92 10 f0       	push   $0xf010928b
f0101b63:	68 29 03 00 00       	push   $0x329
f0101b68:	68 65 92 10 f0       	push   $0xf0109265
f0101b6d:	e8 d7 e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101b72:	68 cb 93 10 f0       	push   $0xf01093cb
f0101b77:	68 8b 92 10 f0       	push   $0xf010928b
f0101b7c:	68 2c 03 00 00       	push   $0x32c
f0101b81:	68 65 92 10 f0       	push   $0xf0109265
f0101b86:	e8 be e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b8b:	68 0c 8a 10 f0       	push   $0xf0108a0c
f0101b90:	68 8b 92 10 f0       	push   $0xf010928b
f0101b95:	68 2d 03 00 00       	push   $0x32d
f0101b9a:	68 65 92 10 f0       	push   $0xf0109265
f0101b9f:	e8 a5 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101ba4:	68 dd 93 10 f0       	push   $0xf01093dd
f0101ba9:	68 8b 92 10 f0       	push   $0xf010928b
f0101bae:	68 2e 03 00 00       	push   $0x32e
f0101bb3:	68 65 92 10 f0       	push   $0xf0109265
f0101bb8:	e8 8c e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101bbd:	68 fa 93 10 f0       	push   $0xf01093fa
f0101bc2:	68 8b 92 10 f0       	push   $0xf010928b
f0101bc7:	68 2f 03 00 00       	push   $0x32f
f0101bcc:	68 65 92 10 f0       	push   $0xf0109265
f0101bd1:	e8 73 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101bd6:	68 17 94 10 f0       	push   $0xf0109417
f0101bdb:	68 8b 92 10 f0       	push   $0xf010928b
f0101be0:	68 30 03 00 00       	push   $0x330
f0101be5:	68 65 92 10 f0       	push   $0xf0109265
f0101bea:	e8 5a e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101bef:	68 34 94 10 f0       	push   $0xf0109434
f0101bf4:	68 8b 92 10 f0       	push   $0xf010928b
f0101bf9:	68 37 03 00 00       	push   $0x337
f0101bfe:	68 65 92 10 f0       	push   $0xf0109265
f0101c03:	e8 41 e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101c08:	68 89 93 10 f0       	push   $0xf0109389
f0101c0d:	68 8b 92 10 f0       	push   $0xf010928b
f0101c12:	68 3e 03 00 00       	push   $0x33e
f0101c17:	68 65 92 10 f0       	push   $0xf0109265
f0101c1c:	e8 28 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101c21:	68 9f 93 10 f0       	push   $0xf010939f
f0101c26:	68 8b 92 10 f0       	push   $0xf010928b
f0101c2b:	68 3f 03 00 00       	push   $0x33f
f0101c30:	68 65 92 10 f0       	push   $0xf0109265
f0101c35:	e8 0f e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101c3a:	68 b5 93 10 f0       	push   $0xf01093b5
f0101c3f:	68 8b 92 10 f0       	push   $0xf010928b
f0101c44:	68 40 03 00 00       	push   $0x340
f0101c49:	68 65 92 10 f0       	push   $0xf0109265
f0101c4e:	e8 f6 e3 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101c53:	68 cb 93 10 f0       	push   $0xf01093cb
f0101c58:	68 8b 92 10 f0       	push   $0xf010928b
f0101c5d:	68 42 03 00 00       	push   $0x342
f0101c62:	68 65 92 10 f0       	push   $0xf0109265
f0101c67:	e8 dd e3 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c6c:	68 0c 8a 10 f0       	push   $0xf0108a0c
f0101c71:	68 8b 92 10 f0       	push   $0xf010928b
f0101c76:	68 43 03 00 00       	push   $0x343
f0101c7b:	68 65 92 10 f0       	push   $0xf0109265
f0101c80:	e8 c4 e3 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c85:	68 34 94 10 f0       	push   $0xf0109434
f0101c8a:	68 8b 92 10 f0       	push   $0xf010928b
f0101c8f:	68 44 03 00 00       	push   $0x344
f0101c94:	68 65 92 10 f0       	push   $0xf0109265
f0101c99:	e8 ab e3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c9e:	50                   	push   %eax
f0101c9f:	68 74 80 10 f0       	push   $0xf0108074
f0101ca4:	6a 58                	push   $0x58
f0101ca6:	68 71 92 10 f0       	push   $0xf0109271
f0101cab:	e8 99 e3 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101cb0:	68 43 94 10 f0       	push   $0xf0109443
f0101cb5:	68 8b 92 10 f0       	push   $0xf010928b
f0101cba:	68 49 03 00 00       	push   $0x349
f0101cbf:	68 65 92 10 f0       	push   $0xf0109265
f0101cc4:	e8 80 e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101cc9:	68 61 94 10 f0       	push   $0xf0109461
f0101cce:	68 8b 92 10 f0       	push   $0xf010928b
f0101cd3:	68 4a 03 00 00       	push   $0x34a
f0101cd8:	68 65 92 10 f0       	push   $0xf0109265
f0101cdd:	e8 67 e3 ff ff       	call   f0100049 <_panic>
f0101ce2:	50                   	push   %eax
f0101ce3:	68 74 80 10 f0       	push   $0xf0108074
f0101ce8:	6a 58                	push   $0x58
f0101cea:	68 71 92 10 f0       	push   $0xf0109271
f0101cef:	e8 55 e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101cf4:	68 71 94 10 f0       	push   $0xf0109471
f0101cf9:	68 8b 92 10 f0       	push   $0xf010928b
f0101cfe:	68 4d 03 00 00       	push   $0x34d
f0101d03:	68 65 92 10 f0       	push   $0xf0109265
f0101d08:	e8 3c e3 ff ff       	call   f0100049 <_panic>
		--nfree;
f0101d0d:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101d11:	8b 00                	mov    (%eax),%eax
f0101d13:	85 c0                	test   %eax,%eax
f0101d15:	75 f6                	jne    f0101d0d <mem_init+0x552>
	assert(nfree == 0);
f0101d17:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101d1b:	0f 85 65 09 00 00    	jne    f0102686 <mem_init+0xecb>
	cprintf("check_page_alloc() succeeded!\n");
f0101d21:	83 ec 0c             	sub    $0xc,%esp
f0101d24:	68 2c 8a 10 f0       	push   $0xf0108a2c
f0101d29:	e8 c8 24 00 00       	call   f01041f6 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101d2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101d35:	e8 03 f6 ff ff       	call   f010133d <page_alloc>
f0101d3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101d3d:	83 c4 10             	add    $0x10,%esp
f0101d40:	85 c0                	test   %eax,%eax
f0101d42:	0f 84 57 09 00 00    	je     f010269f <mem_init+0xee4>
	assert((pp1 = page_alloc(0)));
f0101d48:	83 ec 0c             	sub    $0xc,%esp
f0101d4b:	6a 00                	push   $0x0
f0101d4d:	e8 eb f5 ff ff       	call   f010133d <page_alloc>
f0101d52:	89 c7                	mov    %eax,%edi
f0101d54:	83 c4 10             	add    $0x10,%esp
f0101d57:	85 c0                	test   %eax,%eax
f0101d59:	0f 84 59 09 00 00    	je     f01026b8 <mem_init+0xefd>
	assert((pp2 = page_alloc(0)));
f0101d5f:	83 ec 0c             	sub    $0xc,%esp
f0101d62:	6a 00                	push   $0x0
f0101d64:	e8 d4 f5 ff ff       	call   f010133d <page_alloc>
f0101d69:	89 c3                	mov    %eax,%ebx
f0101d6b:	83 c4 10             	add    $0x10,%esp
f0101d6e:	85 c0                	test   %eax,%eax
f0101d70:	0f 84 5b 09 00 00    	je     f01026d1 <mem_init+0xf16>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101d76:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101d79:	0f 84 6b 09 00 00    	je     f01026ea <mem_init+0xf2f>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d7f:	39 c7                	cmp    %eax,%edi
f0101d81:	0f 84 7c 09 00 00    	je     f0102703 <mem_init+0xf48>
f0101d87:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101d8a:	0f 84 73 09 00 00    	je     f0102703 <mem_init+0xf48>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101d90:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f0101d95:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101d98:	c7 05 40 d9 5d f0 00 	movl   $0x0,0xf05dd940
f0101d9f:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101da2:	83 ec 0c             	sub    $0xc,%esp
f0101da5:	6a 00                	push   $0x0
f0101da7:	e8 91 f5 ff ff       	call   f010133d <page_alloc>
f0101dac:	83 c4 10             	add    $0x10,%esp
f0101daf:	85 c0                	test   %eax,%eax
f0101db1:	0f 85 65 09 00 00    	jne    f010271c <mem_init+0xf61>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101db7:	83 ec 04             	sub    $0x4,%esp
f0101dba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101dbd:	50                   	push   %eax
f0101dbe:	6a 00                	push   $0x0
f0101dc0:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101dc6:	e8 ce f7 ff ff       	call   f0101599 <page_lookup>
f0101dcb:	83 c4 10             	add    $0x10,%esp
f0101dce:	85 c0                	test   %eax,%eax
f0101dd0:	0f 85 5f 09 00 00    	jne    f0102735 <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101dd6:	6a 02                	push   $0x2
f0101dd8:	6a 00                	push   $0x0
f0101dda:	57                   	push   %edi
f0101ddb:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101de1:	e8 93 f8 ff ff       	call   f0101679 <page_insert>
f0101de6:	83 c4 10             	add    $0x10,%esp
f0101de9:	85 c0                	test   %eax,%eax
f0101deb:	0f 89 5d 09 00 00    	jns    f010274e <mem_init+0xf93>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101df1:	83 ec 0c             	sub    $0xc,%esp
f0101df4:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101df7:	e8 b3 f5 ff ff       	call   f01013af <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101dfc:	6a 02                	push   $0x2
f0101dfe:	6a 00                	push   $0x0
f0101e00:	57                   	push   %edi
f0101e01:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101e07:	e8 6d f8 ff ff       	call   f0101679 <page_insert>
f0101e0c:	83 c4 20             	add    $0x20,%esp
f0101e0f:	85 c0                	test   %eax,%eax
f0101e11:	0f 85 50 09 00 00    	jne    f0102767 <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101e17:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
	return (pp - pages) << PGSHIFT;
f0101e1d:	8b 0d 90 ed 5d f0    	mov    0xf05ded90,%ecx
f0101e23:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101e26:	8b 16                	mov    (%esi),%edx
f0101e28:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101e2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e31:	29 c8                	sub    %ecx,%eax
f0101e33:	c1 f8 03             	sar    $0x3,%eax
f0101e36:	c1 e0 0c             	shl    $0xc,%eax
f0101e39:	39 c2                	cmp    %eax,%edx
f0101e3b:	0f 85 3f 09 00 00    	jne    f0102780 <mem_init+0xfc5>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101e41:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e46:	89 f0                	mov    %esi,%eax
f0101e48:	e8 f9 ef ff ff       	call   f0100e46 <check_va2pa>
f0101e4d:	89 fa                	mov    %edi,%edx
f0101e4f:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101e52:	c1 fa 03             	sar    $0x3,%edx
f0101e55:	c1 e2 0c             	shl    $0xc,%edx
f0101e58:	39 d0                	cmp    %edx,%eax
f0101e5a:	0f 85 39 09 00 00    	jne    f0102799 <mem_init+0xfde>
	assert(pp1->pp_ref == 1);
f0101e60:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e65:	0f 85 47 09 00 00    	jne    f01027b2 <mem_init+0xff7>
	assert(pp0->pp_ref == 1);
f0101e6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e6e:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101e73:	0f 85 52 09 00 00    	jne    f01027cb <mem_init+0x1010>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e79:	6a 02                	push   $0x2
f0101e7b:	68 00 10 00 00       	push   $0x1000
f0101e80:	53                   	push   %ebx
f0101e81:	56                   	push   %esi
f0101e82:	e8 f2 f7 ff ff       	call   f0101679 <page_insert>
f0101e87:	83 c4 10             	add    $0x10,%esp
f0101e8a:	85 c0                	test   %eax,%eax
f0101e8c:	0f 85 52 09 00 00    	jne    f01027e4 <mem_init+0x1029>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e92:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e97:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0101e9c:	e8 a5 ef ff ff       	call   f0100e46 <check_va2pa>
f0101ea1:	89 da                	mov    %ebx,%edx
f0101ea3:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0101ea9:	c1 fa 03             	sar    $0x3,%edx
f0101eac:	c1 e2 0c             	shl    $0xc,%edx
f0101eaf:	39 d0                	cmp    %edx,%eax
f0101eb1:	0f 85 46 09 00 00    	jne    f01027fd <mem_init+0x1042>
	assert(pp2->pp_ref == 1);
f0101eb7:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101ebc:	0f 85 54 09 00 00    	jne    f0102816 <mem_init+0x105b>

	// should be no free memory
	assert(!page_alloc(0));
f0101ec2:	83 ec 0c             	sub    $0xc,%esp
f0101ec5:	6a 00                	push   $0x0
f0101ec7:	e8 71 f4 ff ff       	call   f010133d <page_alloc>
f0101ecc:	83 c4 10             	add    $0x10,%esp
f0101ecf:	85 c0                	test   %eax,%eax
f0101ed1:	0f 85 58 09 00 00    	jne    f010282f <mem_init+0x1074>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101ed7:	6a 02                	push   $0x2
f0101ed9:	68 00 10 00 00       	push   $0x1000
f0101ede:	53                   	push   %ebx
f0101edf:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101ee5:	e8 8f f7 ff ff       	call   f0101679 <page_insert>
f0101eea:	83 c4 10             	add    $0x10,%esp
f0101eed:	85 c0                	test   %eax,%eax
f0101eef:	0f 85 53 09 00 00    	jne    f0102848 <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ef5:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101efa:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0101eff:	e8 42 ef ff ff       	call   f0100e46 <check_va2pa>
f0101f04:	89 da                	mov    %ebx,%edx
f0101f06:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0101f0c:	c1 fa 03             	sar    $0x3,%edx
f0101f0f:	c1 e2 0c             	shl    $0xc,%edx
f0101f12:	39 d0                	cmp    %edx,%eax
f0101f14:	0f 85 47 09 00 00    	jne    f0102861 <mem_init+0x10a6>
	assert(pp2->pp_ref == 1);
f0101f1a:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101f1f:	0f 85 55 09 00 00    	jne    f010287a <mem_init+0x10bf>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101f25:	83 ec 0c             	sub    $0xc,%esp
f0101f28:	6a 00                	push   $0x0
f0101f2a:	e8 0e f4 ff ff       	call   f010133d <page_alloc>
f0101f2f:	83 c4 10             	add    $0x10,%esp
f0101f32:	85 c0                	test   %eax,%eax
f0101f34:	0f 85 59 09 00 00    	jne    f0102893 <mem_init+0x10d8>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101f3a:	8b 15 8c ed 5d f0    	mov    0xf05ded8c,%edx
f0101f40:	8b 02                	mov    (%edx),%eax
f0101f42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101f47:	89 c1                	mov    %eax,%ecx
f0101f49:	c1 e9 0c             	shr    $0xc,%ecx
f0101f4c:	3b 0d 88 ed 5d f0    	cmp    0xf05ded88,%ecx
f0101f52:	0f 83 54 09 00 00    	jae    f01028ac <mem_init+0x10f1>
	return (void *)(pa + KERNBASE);
f0101f58:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101f5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101f60:	83 ec 04             	sub    $0x4,%esp
f0101f63:	6a 00                	push   $0x0
f0101f65:	68 00 10 00 00       	push   $0x1000
f0101f6a:	52                   	push   %edx
f0101f6b:	e8 a3 f4 ff ff       	call   f0101413 <pgdir_walk>
f0101f70:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101f73:	8d 51 04             	lea    0x4(%ecx),%edx
f0101f76:	83 c4 10             	add    $0x10,%esp
f0101f79:	39 d0                	cmp    %edx,%eax
f0101f7b:	0f 85 40 09 00 00    	jne    f01028c1 <mem_init+0x1106>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101f81:	6a 06                	push   $0x6
f0101f83:	68 00 10 00 00       	push   $0x1000
f0101f88:	53                   	push   %ebx
f0101f89:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101f8f:	e8 e5 f6 ff ff       	call   f0101679 <page_insert>
f0101f94:	83 c4 10             	add    $0x10,%esp
f0101f97:	85 c0                	test   %eax,%eax
f0101f99:	0f 85 3b 09 00 00    	jne    f01028da <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f9f:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
f0101fa5:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101faa:	89 f0                	mov    %esi,%eax
f0101fac:	e8 95 ee ff ff       	call   f0100e46 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101fb1:	89 da                	mov    %ebx,%edx
f0101fb3:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0101fb9:	c1 fa 03             	sar    $0x3,%edx
f0101fbc:	c1 e2 0c             	shl    $0xc,%edx
f0101fbf:	39 d0                	cmp    %edx,%eax
f0101fc1:	0f 85 2c 09 00 00    	jne    f01028f3 <mem_init+0x1138>
	assert(pp2->pp_ref == 1);
f0101fc7:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101fcc:	0f 85 3a 09 00 00    	jne    f010290c <mem_init+0x1151>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101fd2:	83 ec 04             	sub    $0x4,%esp
f0101fd5:	6a 00                	push   $0x0
f0101fd7:	68 00 10 00 00       	push   $0x1000
f0101fdc:	56                   	push   %esi
f0101fdd:	e8 31 f4 ff ff       	call   f0101413 <pgdir_walk>
f0101fe2:	83 c4 10             	add    $0x10,%esp
f0101fe5:	f6 00 04             	testb  $0x4,(%eax)
f0101fe8:	0f 84 37 09 00 00    	je     f0102925 <mem_init+0x116a>
	assert(kern_pgdir[0] & PTE_U);
f0101fee:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0101ff3:	f6 00 04             	testb  $0x4,(%eax)
f0101ff6:	0f 84 42 09 00 00    	je     f010293e <mem_init+0x1183>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101ffc:	6a 02                	push   $0x2
f0101ffe:	68 00 10 00 00       	push   $0x1000
f0102003:	53                   	push   %ebx
f0102004:	50                   	push   %eax
f0102005:	e8 6f f6 ff ff       	call   f0101679 <page_insert>
f010200a:	83 c4 10             	add    $0x10,%esp
f010200d:	85 c0                	test   %eax,%eax
f010200f:	0f 85 42 09 00 00    	jne    f0102957 <mem_init+0x119c>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102015:	83 ec 04             	sub    $0x4,%esp
f0102018:	6a 00                	push   $0x0
f010201a:	68 00 10 00 00       	push   $0x1000
f010201f:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102025:	e8 e9 f3 ff ff       	call   f0101413 <pgdir_walk>
f010202a:	83 c4 10             	add    $0x10,%esp
f010202d:	f6 00 02             	testb  $0x2,(%eax)
f0102030:	0f 84 3a 09 00 00    	je     f0102970 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102036:	83 ec 04             	sub    $0x4,%esp
f0102039:	6a 00                	push   $0x0
f010203b:	68 00 10 00 00       	push   $0x1000
f0102040:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102046:	e8 c8 f3 ff ff       	call   f0101413 <pgdir_walk>
f010204b:	83 c4 10             	add    $0x10,%esp
f010204e:	f6 00 04             	testb  $0x4,(%eax)
f0102051:	0f 85 32 09 00 00    	jne    f0102989 <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102057:	6a 02                	push   $0x2
f0102059:	68 00 00 40 00       	push   $0x400000
f010205e:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102061:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102067:	e8 0d f6 ff ff       	call   f0101679 <page_insert>
f010206c:	83 c4 10             	add    $0x10,%esp
f010206f:	85 c0                	test   %eax,%eax
f0102071:	0f 89 2b 09 00 00    	jns    f01029a2 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102077:	6a 02                	push   $0x2
f0102079:	68 00 10 00 00       	push   $0x1000
f010207e:	57                   	push   %edi
f010207f:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102085:	e8 ef f5 ff ff       	call   f0101679 <page_insert>
f010208a:	83 c4 10             	add    $0x10,%esp
f010208d:	85 c0                	test   %eax,%eax
f010208f:	0f 85 26 09 00 00    	jne    f01029bb <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102095:	83 ec 04             	sub    $0x4,%esp
f0102098:	6a 00                	push   $0x0
f010209a:	68 00 10 00 00       	push   $0x1000
f010209f:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01020a5:	e8 69 f3 ff ff       	call   f0101413 <pgdir_walk>
f01020aa:	83 c4 10             	add    $0x10,%esp
f01020ad:	f6 00 04             	testb  $0x4,(%eax)
f01020b0:	0f 85 1e 09 00 00    	jne    f01029d4 <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01020b6:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01020bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01020be:	ba 00 00 00 00       	mov    $0x0,%edx
f01020c3:	e8 7e ed ff ff       	call   f0100e46 <check_va2pa>
f01020c8:	89 fe                	mov    %edi,%esi
f01020ca:	2b 35 90 ed 5d f0    	sub    0xf05ded90,%esi
f01020d0:	c1 fe 03             	sar    $0x3,%esi
f01020d3:	c1 e6 0c             	shl    $0xc,%esi
f01020d6:	39 f0                	cmp    %esi,%eax
f01020d8:	0f 85 0f 09 00 00    	jne    f01029ed <mem_init+0x1232>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01020de:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01020e6:	e8 5b ed ff ff       	call   f0100e46 <check_va2pa>
f01020eb:	39 c6                	cmp    %eax,%esi
f01020ed:	0f 85 13 09 00 00    	jne    f0102a06 <mem_init+0x124b>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01020f3:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f01020f8:	0f 85 21 09 00 00    	jne    f0102a1f <mem_init+0x1264>
	assert(pp2->pp_ref == 0);
f01020fe:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102103:	0f 85 2f 09 00 00    	jne    f0102a38 <mem_init+0x127d>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102109:	83 ec 0c             	sub    $0xc,%esp
f010210c:	6a 00                	push   $0x0
f010210e:	e8 2a f2 ff ff       	call   f010133d <page_alloc>
f0102113:	83 c4 10             	add    $0x10,%esp
f0102116:	39 c3                	cmp    %eax,%ebx
f0102118:	0f 85 33 09 00 00    	jne    f0102a51 <mem_init+0x1296>
f010211e:	85 c0                	test   %eax,%eax
f0102120:	0f 84 2b 09 00 00    	je     f0102a51 <mem_init+0x1296>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102126:	83 ec 08             	sub    $0x8,%esp
f0102129:	6a 00                	push   $0x0
f010212b:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102131:	e8 fd f4 ff ff       	call   f0101633 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102136:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
f010213c:	ba 00 00 00 00       	mov    $0x0,%edx
f0102141:	89 f0                	mov    %esi,%eax
f0102143:	e8 fe ec ff ff       	call   f0100e46 <check_va2pa>
f0102148:	83 c4 10             	add    $0x10,%esp
f010214b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010214e:	0f 85 16 09 00 00    	jne    f0102a6a <mem_init+0x12af>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102154:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102159:	89 f0                	mov    %esi,%eax
f010215b:	e8 e6 ec ff ff       	call   f0100e46 <check_va2pa>
f0102160:	89 fa                	mov    %edi,%edx
f0102162:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0102168:	c1 fa 03             	sar    $0x3,%edx
f010216b:	c1 e2 0c             	shl    $0xc,%edx
f010216e:	39 d0                	cmp    %edx,%eax
f0102170:	0f 85 0d 09 00 00    	jne    f0102a83 <mem_init+0x12c8>
	assert(pp1->pp_ref == 1);
f0102176:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010217b:	0f 85 1b 09 00 00    	jne    f0102a9c <mem_init+0x12e1>
	assert(pp2->pp_ref == 0);
f0102181:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102186:	0f 85 29 09 00 00    	jne    f0102ab5 <mem_init+0x12fa>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010218c:	6a 00                	push   $0x0
f010218e:	68 00 10 00 00       	push   $0x1000
f0102193:	57                   	push   %edi
f0102194:	56                   	push   %esi
f0102195:	e8 df f4 ff ff       	call   f0101679 <page_insert>
f010219a:	83 c4 10             	add    $0x10,%esp
f010219d:	85 c0                	test   %eax,%eax
f010219f:	0f 85 29 09 00 00    	jne    f0102ace <mem_init+0x1313>
	assert(pp1->pp_ref);
f01021a5:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01021aa:	0f 84 37 09 00 00    	je     f0102ae7 <mem_init+0x132c>
	assert(pp1->pp_link == NULL);
f01021b0:	83 3f 00             	cmpl   $0x0,(%edi)
f01021b3:	0f 85 47 09 00 00    	jne    f0102b00 <mem_init+0x1345>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01021b9:	83 ec 08             	sub    $0x8,%esp
f01021bc:	68 00 10 00 00       	push   $0x1000
f01021c1:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01021c7:	e8 67 f4 ff ff       	call   f0101633 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01021cc:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
f01021d2:	ba 00 00 00 00       	mov    $0x0,%edx
f01021d7:	89 f0                	mov    %esi,%eax
f01021d9:	e8 68 ec ff ff       	call   f0100e46 <check_va2pa>
f01021de:	83 c4 10             	add    $0x10,%esp
f01021e1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01021e4:	0f 85 2f 09 00 00    	jne    f0102b19 <mem_init+0x135e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01021ea:	ba 00 10 00 00       	mov    $0x1000,%edx
f01021ef:	89 f0                	mov    %esi,%eax
f01021f1:	e8 50 ec ff ff       	call   f0100e46 <check_va2pa>
f01021f6:	83 f8 ff             	cmp    $0xffffffff,%eax
f01021f9:	0f 85 33 09 00 00    	jne    f0102b32 <mem_init+0x1377>
	assert(pp1->pp_ref == 0);
f01021ff:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102204:	0f 85 41 09 00 00    	jne    f0102b4b <mem_init+0x1390>
	assert(pp2->pp_ref == 0);
f010220a:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010220f:	0f 85 4f 09 00 00    	jne    f0102b64 <mem_init+0x13a9>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102215:	83 ec 0c             	sub    $0xc,%esp
f0102218:	6a 00                	push   $0x0
f010221a:	e8 1e f1 ff ff       	call   f010133d <page_alloc>
f010221f:	83 c4 10             	add    $0x10,%esp
f0102222:	85 c0                	test   %eax,%eax
f0102224:	0f 84 53 09 00 00    	je     f0102b7d <mem_init+0x13c2>
f010222a:	39 c7                	cmp    %eax,%edi
f010222c:	0f 85 4b 09 00 00    	jne    f0102b7d <mem_init+0x13c2>

	// should be no free memory
	assert(!page_alloc(0));
f0102232:	83 ec 0c             	sub    $0xc,%esp
f0102235:	6a 00                	push   $0x0
f0102237:	e8 01 f1 ff ff       	call   f010133d <page_alloc>
f010223c:	83 c4 10             	add    $0x10,%esp
f010223f:	85 c0                	test   %eax,%eax
f0102241:	0f 85 4f 09 00 00    	jne    f0102b96 <mem_init+0x13db>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102247:	8b 0d 8c ed 5d f0    	mov    0xf05ded8c,%ecx
f010224d:	8b 11                	mov    (%ecx),%edx
f010224f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102255:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102258:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010225e:	c1 f8 03             	sar    $0x3,%eax
f0102261:	c1 e0 0c             	shl    $0xc,%eax
f0102264:	39 c2                	cmp    %eax,%edx
f0102266:	0f 85 43 09 00 00    	jne    f0102baf <mem_init+0x13f4>
	kern_pgdir[0] = 0;
f010226c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102272:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102275:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010227a:	0f 85 48 09 00 00    	jne    f0102bc8 <mem_init+0x140d>
	pp0->pp_ref = 0;
f0102280:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102283:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102289:	83 ec 0c             	sub    $0xc,%esp
f010228c:	50                   	push   %eax
f010228d:	e8 1d f1 ff ff       	call   f01013af <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102292:	83 c4 0c             	add    $0xc,%esp
f0102295:	6a 01                	push   $0x1
f0102297:	68 00 10 40 00       	push   $0x401000
f010229c:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01022a2:	e8 6c f1 ff ff       	call   f0101413 <pgdir_walk>
f01022a7:	89 c1                	mov    %eax,%ecx
f01022a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01022ac:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01022b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01022b4:	8b 40 04             	mov    0x4(%eax),%eax
f01022b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01022bc:	8b 35 88 ed 5d f0    	mov    0xf05ded88,%esi
f01022c2:	89 c2                	mov    %eax,%edx
f01022c4:	c1 ea 0c             	shr    $0xc,%edx
f01022c7:	83 c4 10             	add    $0x10,%esp
f01022ca:	39 f2                	cmp    %esi,%edx
f01022cc:	0f 83 0f 09 00 00    	jae    f0102be1 <mem_init+0x1426>
	assert(ptep == ptep1 + PTX(va));
f01022d2:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f01022d7:	39 c1                	cmp    %eax,%ecx
f01022d9:	0f 85 17 09 00 00    	jne    f0102bf6 <mem_init+0x143b>
	kern_pgdir[PDX(va)] = 0;
f01022df:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01022e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f01022e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01022ec:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01022f2:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01022f8:	c1 f8 03             	sar    $0x3,%eax
f01022fb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022fe:	89 c2                	mov    %eax,%edx
f0102300:	c1 ea 0c             	shr    $0xc,%edx
f0102303:	39 d6                	cmp    %edx,%esi
f0102305:	0f 86 04 09 00 00    	jbe    f0102c0f <mem_init+0x1454>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f010230b:	83 ec 04             	sub    $0x4,%esp
f010230e:	68 00 10 00 00       	push   $0x1000
f0102313:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0102318:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010231d:	50                   	push   %eax
f010231e:	e8 e1 45 00 00       	call   f0106904 <memset>
	page_free(pp0);
f0102323:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0102326:	89 34 24             	mov    %esi,(%esp)
f0102329:	e8 81 f0 ff ff       	call   f01013af <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f010232e:	83 c4 0c             	add    $0xc,%esp
f0102331:	6a 01                	push   $0x1
f0102333:	6a 00                	push   $0x0
f0102335:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010233b:	e8 d3 f0 ff ff       	call   f0101413 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0102340:	89 f0                	mov    %esi,%eax
f0102342:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0102348:	c1 f8 03             	sar    $0x3,%eax
f010234b:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010234e:	89 c2                	mov    %eax,%edx
f0102350:	c1 ea 0c             	shr    $0xc,%edx
f0102353:	83 c4 10             	add    $0x10,%esp
f0102356:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f010235c:	0f 83 bf 08 00 00    	jae    f0102c21 <mem_init+0x1466>
	return (void *)(pa + KERNBASE);
f0102362:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f0102368:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010236b:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102370:	f6 02 01             	testb  $0x1,(%edx)
f0102373:	0f 85 ba 08 00 00    	jne    f0102c33 <mem_init+0x1478>
f0102379:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f010237c:	39 c2                	cmp    %eax,%edx
f010237e:	75 f0                	jne    f0102370 <mem_init+0xbb5>
	kern_pgdir[0] = 0;
f0102380:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010238b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010238e:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102394:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102397:	89 0d 40 d9 5d f0    	mov    %ecx,0xf05dd940

	// free the pages we took
	page_free(pp0);
f010239d:	83 ec 0c             	sub    $0xc,%esp
f01023a0:	50                   	push   %eax
f01023a1:	e8 09 f0 ff ff       	call   f01013af <page_free>
	page_free(pp1);
f01023a6:	89 3c 24             	mov    %edi,(%esp)
f01023a9:	e8 01 f0 ff ff       	call   f01013af <page_free>
	page_free(pp2);
f01023ae:	89 1c 24             	mov    %ebx,(%esp)
f01023b1:	e8 f9 ef ff ff       	call   f01013af <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f01023b6:	83 c4 08             	add    $0x8,%esp
f01023b9:	68 01 10 00 00       	push   $0x1001
f01023be:	6a 00                	push   $0x0
f01023c0:	e8 96 f3 ff ff       	call   f010175b <mmio_map_region>
f01023c5:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f01023c7:	83 c4 08             	add    $0x8,%esp
f01023ca:	68 00 10 00 00       	push   $0x1000
f01023cf:	6a 00                	push   $0x0
f01023d1:	e8 85 f3 ff ff       	call   f010175b <mmio_map_region>
f01023d6:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01023d8:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f01023de:	83 c4 10             	add    $0x10,%esp
f01023e1:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01023e7:	0f 86 5f 08 00 00    	jbe    f0102c4c <mem_init+0x1491>
f01023ed:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01023f2:	0f 87 54 08 00 00    	ja     f0102c4c <mem_init+0x1491>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01023f8:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f01023fe:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102404:	0f 87 5b 08 00 00    	ja     f0102c65 <mem_init+0x14aa>
f010240a:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102410:	0f 86 4f 08 00 00    	jbe    f0102c65 <mem_init+0x14aa>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102416:	89 da                	mov    %ebx,%edx
f0102418:	09 f2                	or     %esi,%edx
f010241a:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102420:	0f 85 58 08 00 00    	jne    f0102c7e <mem_init+0x14c3>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0102426:	39 c6                	cmp    %eax,%esi
f0102428:	0f 82 69 08 00 00    	jb     f0102c97 <mem_init+0x14dc>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f010242e:	8b 3d 8c ed 5d f0    	mov    0xf05ded8c,%edi
f0102434:	89 da                	mov    %ebx,%edx
f0102436:	89 f8                	mov    %edi,%eax
f0102438:	e8 09 ea ff ff       	call   f0100e46 <check_va2pa>
f010243d:	85 c0                	test   %eax,%eax
f010243f:	0f 85 6b 08 00 00    	jne    f0102cb0 <mem_init+0x14f5>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102445:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f010244b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010244e:	89 c2                	mov    %eax,%edx
f0102450:	89 f8                	mov    %edi,%eax
f0102452:	e8 ef e9 ff ff       	call   f0100e46 <check_va2pa>
f0102457:	3d 00 10 00 00       	cmp    $0x1000,%eax
f010245c:	0f 85 67 08 00 00    	jne    f0102cc9 <mem_init+0x150e>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102462:	89 f2                	mov    %esi,%edx
f0102464:	89 f8                	mov    %edi,%eax
f0102466:	e8 db e9 ff ff       	call   f0100e46 <check_va2pa>
f010246b:	85 c0                	test   %eax,%eax
f010246d:	0f 85 6f 08 00 00    	jne    f0102ce2 <mem_init+0x1527>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102473:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102479:	89 f8                	mov    %edi,%eax
f010247b:	e8 c6 e9 ff ff       	call   f0100e46 <check_va2pa>
f0102480:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102483:	0f 85 72 08 00 00    	jne    f0102cfb <mem_init+0x1540>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102489:	83 ec 04             	sub    $0x4,%esp
f010248c:	6a 00                	push   $0x0
f010248e:	53                   	push   %ebx
f010248f:	57                   	push   %edi
f0102490:	e8 7e ef ff ff       	call   f0101413 <pgdir_walk>
f0102495:	83 c4 10             	add    $0x10,%esp
f0102498:	f6 00 1a             	testb  $0x1a,(%eax)
f010249b:	0f 84 73 08 00 00    	je     f0102d14 <mem_init+0x1559>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01024a1:	83 ec 04             	sub    $0x4,%esp
f01024a4:	6a 00                	push   $0x0
f01024a6:	53                   	push   %ebx
f01024a7:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01024ad:	e8 61 ef ff ff       	call   f0101413 <pgdir_walk>
f01024b2:	8b 00                	mov    (%eax),%eax
f01024b4:	83 c4 10             	add    $0x10,%esp
f01024b7:	83 e0 04             	and    $0x4,%eax
f01024ba:	89 c7                	mov    %eax,%edi
f01024bc:	0f 85 6b 08 00 00    	jne    f0102d2d <mem_init+0x1572>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f01024c2:	83 ec 04             	sub    $0x4,%esp
f01024c5:	6a 00                	push   $0x0
f01024c7:	53                   	push   %ebx
f01024c8:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01024ce:	e8 40 ef ff ff       	call   f0101413 <pgdir_walk>
f01024d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f01024d9:	83 c4 0c             	add    $0xc,%esp
f01024dc:	6a 00                	push   $0x0
f01024de:	ff 75 d4             	pushl  -0x2c(%ebp)
f01024e1:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01024e7:	e8 27 ef ff ff       	call   f0101413 <pgdir_walk>
f01024ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f01024f2:	83 c4 0c             	add    $0xc,%esp
f01024f5:	6a 00                	push   $0x0
f01024f7:	56                   	push   %esi
f01024f8:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01024fe:	e8 10 ef ff ff       	call   f0101413 <pgdir_walk>
f0102503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102509:	c7 04 24 64 95 10 f0 	movl   $0xf0109564,(%esp)
f0102510:	e8 e1 1c 00 00       	call   f01041f6 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102515:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
	if ((uint32_t)kva < KERNBASE)
f010251a:	83 c4 10             	add    $0x10,%esp
f010251d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102522:	0f 86 1e 08 00 00    	jbe    f0102d46 <mem_init+0x158b>
f0102528:	83 ec 08             	sub    $0x8,%esp
f010252b:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010252d:	05 00 00 00 10       	add    $0x10000000,%eax
f0102532:	50                   	push   %eax
f0102533:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102538:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f010253d:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102542:	e8 9e ef ff ff       	call   f01014e5 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f0102547:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
	if ((uint32_t)kva < KERNBASE)
f010254c:	83 c4 10             	add    $0x10,%esp
f010254f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102554:	0f 86 01 08 00 00    	jbe    f0102d5b <mem_init+0x15a0>
f010255a:	83 ec 08             	sub    $0x8,%esp
f010255d:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010255f:	05 00 00 00 10       	add    $0x10000000,%eax
f0102564:	50                   	push   %eax
f0102565:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010256a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f010256f:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102574:	e8 6c ef ff ff       	call   f01014e5 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102579:	83 c4 10             	add    $0x10,%esp
f010257c:	b8 00 20 12 f0       	mov    $0xf0122000,%eax
f0102581:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102586:	0f 86 e4 07 00 00    	jbe    f0102d70 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f010258c:	83 ec 08             	sub    $0x8,%esp
f010258f:	6a 02                	push   $0x2
f0102591:	68 00 20 12 00       	push   $0x122000
f0102596:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010259b:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01025a0:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01025a5:	e8 3b ef ff ff       	call   f01014e5 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f01025aa:	83 c4 08             	add    $0x8,%esp
f01025ad:	6a 02                	push   $0x2
f01025af:	6a 00                	push   $0x0
f01025b1:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f01025b6:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01025bb:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01025c0:	e8 20 ef ff ff       	call   f01014e5 <boot_map_region>
f01025c5:	c7 45 d0 00 b0 12 f0 	movl   $0xf012b000,-0x30(%ebp)
f01025cc:	83 c4 10             	add    $0x10,%esp
f01025cf:	bb 00 b0 12 f0       	mov    $0xf012b000,%ebx
f01025d4:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01025d9:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01025df:	0f 86 a0 07 00 00    	jbe    f0102d85 <mem_init+0x15ca>
		boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f01025e5:	83 ec 08             	sub    $0x8,%esp
f01025e8:	6a 02                	push   $0x2
f01025ea:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01025f0:	50                   	push   %eax
f01025f1:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01025f6:	89 f2                	mov    %esi,%edx
f01025f8:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01025fd:	e8 e3 ee ff ff       	call   f01014e5 <boot_map_region>
f0102602:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0102608:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f010260e:	83 c4 10             	add    $0x10,%esp
f0102611:	81 fb 00 b0 16 f0    	cmp    $0xf016b000,%ebx
f0102617:	75 c0                	jne    f01025d9 <mem_init+0xe1e>
	pgdir = kern_pgdir;
f0102619:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f010261e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102621:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f0102626:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102629:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102630:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102635:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102638:	8b 35 90 ed 5d f0    	mov    0xf05ded90,%esi
f010263e:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102641:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0102647:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f010264a:	89 fb                	mov    %edi,%ebx
f010264c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f010264f:	0f 86 73 07 00 00    	jbe    f0102dc8 <mem_init+0x160d>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102655:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f010265b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010265e:	e8 e3 e7 ff ff       	call   f0100e46 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102663:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f010266a:	0f 86 2a 07 00 00    	jbe    f0102d9a <mem_init+0x15df>
f0102670:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102673:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102676:	39 d0                	cmp    %edx,%eax
f0102678:	0f 85 31 07 00 00    	jne    f0102daf <mem_init+0x15f4>
	for (i = 0; i < n; i += PGSIZE)
f010267e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102684:	eb c6                	jmp    f010264c <mem_init+0xe91>
	assert(nfree == 0);
f0102686:	68 7b 94 10 f0       	push   $0xf010947b
f010268b:	68 8b 92 10 f0       	push   $0xf010928b
f0102690:	68 5a 03 00 00       	push   $0x35a
f0102695:	68 65 92 10 f0       	push   $0xf0109265
f010269a:	e8 aa d9 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f010269f:	68 89 93 10 f0       	push   $0xf0109389
f01026a4:	68 8b 92 10 f0       	push   $0xf010928b
f01026a9:	68 cd 03 00 00       	push   $0x3cd
f01026ae:	68 65 92 10 f0       	push   $0xf0109265
f01026b3:	e8 91 d9 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f01026b8:	68 9f 93 10 f0       	push   $0xf010939f
f01026bd:	68 8b 92 10 f0       	push   $0xf010928b
f01026c2:	68 ce 03 00 00       	push   $0x3ce
f01026c7:	68 65 92 10 f0       	push   $0xf0109265
f01026cc:	e8 78 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f01026d1:	68 b5 93 10 f0       	push   $0xf01093b5
f01026d6:	68 8b 92 10 f0       	push   $0xf010928b
f01026db:	68 cf 03 00 00       	push   $0x3cf
f01026e0:	68 65 92 10 f0       	push   $0xf0109265
f01026e5:	e8 5f d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f01026ea:	68 cb 93 10 f0       	push   $0xf01093cb
f01026ef:	68 8b 92 10 f0       	push   $0xf010928b
f01026f4:	68 d2 03 00 00       	push   $0x3d2
f01026f9:	68 65 92 10 f0       	push   $0xf0109265
f01026fe:	e8 46 d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102703:	68 0c 8a 10 f0       	push   $0xf0108a0c
f0102708:	68 8b 92 10 f0       	push   $0xf010928b
f010270d:	68 d3 03 00 00       	push   $0x3d3
f0102712:	68 65 92 10 f0       	push   $0xf0109265
f0102717:	e8 2d d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f010271c:	68 34 94 10 f0       	push   $0xf0109434
f0102721:	68 8b 92 10 f0       	push   $0xf010928b
f0102726:	68 da 03 00 00       	push   $0x3da
f010272b:	68 65 92 10 f0       	push   $0xf0109265
f0102730:	e8 14 d9 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102735:	68 4c 8a 10 f0       	push   $0xf0108a4c
f010273a:	68 8b 92 10 f0       	push   $0xf010928b
f010273f:	68 dd 03 00 00       	push   $0x3dd
f0102744:	68 65 92 10 f0       	push   $0xf0109265
f0102749:	e8 fb d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010274e:	68 84 8a 10 f0       	push   $0xf0108a84
f0102753:	68 8b 92 10 f0       	push   $0xf010928b
f0102758:	68 e0 03 00 00       	push   $0x3e0
f010275d:	68 65 92 10 f0       	push   $0xf0109265
f0102762:	e8 e2 d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102767:	68 b4 8a 10 f0       	push   $0xf0108ab4
f010276c:	68 8b 92 10 f0       	push   $0xf010928b
f0102771:	68 e4 03 00 00       	push   $0x3e4
f0102776:	68 65 92 10 f0       	push   $0xf0109265
f010277b:	e8 c9 d8 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102780:	68 e4 8a 10 f0       	push   $0xf0108ae4
f0102785:	68 8b 92 10 f0       	push   $0xf010928b
f010278a:	68 e5 03 00 00       	push   $0x3e5
f010278f:	68 65 92 10 f0       	push   $0xf0109265
f0102794:	e8 b0 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102799:	68 0c 8b 10 f0       	push   $0xf0108b0c
f010279e:	68 8b 92 10 f0       	push   $0xf010928b
f01027a3:	68 e6 03 00 00       	push   $0x3e6
f01027a8:	68 65 92 10 f0       	push   $0xf0109265
f01027ad:	e8 97 d8 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01027b2:	68 86 94 10 f0       	push   $0xf0109486
f01027b7:	68 8b 92 10 f0       	push   $0xf010928b
f01027bc:	68 e7 03 00 00       	push   $0x3e7
f01027c1:	68 65 92 10 f0       	push   $0xf0109265
f01027c6:	e8 7e d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f01027cb:	68 97 94 10 f0       	push   $0xf0109497
f01027d0:	68 8b 92 10 f0       	push   $0xf010928b
f01027d5:	68 e8 03 00 00       	push   $0x3e8
f01027da:	68 65 92 10 f0       	push   $0xf0109265
f01027df:	e8 65 d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027e4:	68 3c 8b 10 f0       	push   $0xf0108b3c
f01027e9:	68 8b 92 10 f0       	push   $0xf010928b
f01027ee:	68 eb 03 00 00       	push   $0x3eb
f01027f3:	68 65 92 10 f0       	push   $0xf0109265
f01027f8:	e8 4c d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027fd:	68 78 8b 10 f0       	push   $0xf0108b78
f0102802:	68 8b 92 10 f0       	push   $0xf010928b
f0102807:	68 ec 03 00 00       	push   $0x3ec
f010280c:	68 65 92 10 f0       	push   $0xf0109265
f0102811:	e8 33 d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102816:	68 a8 94 10 f0       	push   $0xf01094a8
f010281b:	68 8b 92 10 f0       	push   $0xf010928b
f0102820:	68 ed 03 00 00       	push   $0x3ed
f0102825:	68 65 92 10 f0       	push   $0xf0109265
f010282a:	e8 1a d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f010282f:	68 34 94 10 f0       	push   $0xf0109434
f0102834:	68 8b 92 10 f0       	push   $0xf010928b
f0102839:	68 f0 03 00 00       	push   $0x3f0
f010283e:	68 65 92 10 f0       	push   $0xf0109265
f0102843:	e8 01 d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102848:	68 3c 8b 10 f0       	push   $0xf0108b3c
f010284d:	68 8b 92 10 f0       	push   $0xf010928b
f0102852:	68 f3 03 00 00       	push   $0x3f3
f0102857:	68 65 92 10 f0       	push   $0xf0109265
f010285c:	e8 e8 d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102861:	68 78 8b 10 f0       	push   $0xf0108b78
f0102866:	68 8b 92 10 f0       	push   $0xf010928b
f010286b:	68 f4 03 00 00       	push   $0x3f4
f0102870:	68 65 92 10 f0       	push   $0xf0109265
f0102875:	e8 cf d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010287a:	68 a8 94 10 f0       	push   $0xf01094a8
f010287f:	68 8b 92 10 f0       	push   $0xf010928b
f0102884:	68 f5 03 00 00       	push   $0x3f5
f0102889:	68 65 92 10 f0       	push   $0xf0109265
f010288e:	e8 b6 d7 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102893:	68 34 94 10 f0       	push   $0xf0109434
f0102898:	68 8b 92 10 f0       	push   $0xf010928b
f010289d:	68 f9 03 00 00       	push   $0x3f9
f01028a2:	68 65 92 10 f0       	push   $0xf0109265
f01028a7:	e8 9d d7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01028ac:	50                   	push   %eax
f01028ad:	68 74 80 10 f0       	push   $0xf0108074
f01028b2:	68 fc 03 00 00       	push   $0x3fc
f01028b7:	68 65 92 10 f0       	push   $0xf0109265
f01028bc:	e8 88 d7 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01028c1:	68 a8 8b 10 f0       	push   $0xf0108ba8
f01028c6:	68 8b 92 10 f0       	push   $0xf010928b
f01028cb:	68 fd 03 00 00       	push   $0x3fd
f01028d0:	68 65 92 10 f0       	push   $0xf0109265
f01028d5:	e8 6f d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01028da:	68 e8 8b 10 f0       	push   $0xf0108be8
f01028df:	68 8b 92 10 f0       	push   $0xf010928b
f01028e4:	68 00 04 00 00       	push   $0x400
f01028e9:	68 65 92 10 f0       	push   $0xf0109265
f01028ee:	e8 56 d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01028f3:	68 78 8b 10 f0       	push   $0xf0108b78
f01028f8:	68 8b 92 10 f0       	push   $0xf010928b
f01028fd:	68 01 04 00 00       	push   $0x401
f0102902:	68 65 92 10 f0       	push   $0xf0109265
f0102907:	e8 3d d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010290c:	68 a8 94 10 f0       	push   $0xf01094a8
f0102911:	68 8b 92 10 f0       	push   $0xf010928b
f0102916:	68 02 04 00 00       	push   $0x402
f010291b:	68 65 92 10 f0       	push   $0xf0109265
f0102920:	e8 24 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102925:	68 28 8c 10 f0       	push   $0xf0108c28
f010292a:	68 8b 92 10 f0       	push   $0xf010928b
f010292f:	68 03 04 00 00       	push   $0x403
f0102934:	68 65 92 10 f0       	push   $0xf0109265
f0102939:	e8 0b d7 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f010293e:	68 b9 94 10 f0       	push   $0xf01094b9
f0102943:	68 8b 92 10 f0       	push   $0xf010928b
f0102948:	68 04 04 00 00       	push   $0x404
f010294d:	68 65 92 10 f0       	push   $0xf0109265
f0102952:	e8 f2 d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102957:	68 3c 8b 10 f0       	push   $0xf0108b3c
f010295c:	68 8b 92 10 f0       	push   $0xf010928b
f0102961:	68 07 04 00 00       	push   $0x407
f0102966:	68 65 92 10 f0       	push   $0xf0109265
f010296b:	e8 d9 d6 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102970:	68 5c 8c 10 f0       	push   $0xf0108c5c
f0102975:	68 8b 92 10 f0       	push   $0xf010928b
f010297a:	68 08 04 00 00       	push   $0x408
f010297f:	68 65 92 10 f0       	push   $0xf0109265
f0102984:	e8 c0 d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102989:	68 90 8c 10 f0       	push   $0xf0108c90
f010298e:	68 8b 92 10 f0       	push   $0xf010928b
f0102993:	68 09 04 00 00       	push   $0x409
f0102998:	68 65 92 10 f0       	push   $0xf0109265
f010299d:	e8 a7 d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01029a2:	68 c8 8c 10 f0       	push   $0xf0108cc8
f01029a7:	68 8b 92 10 f0       	push   $0xf010928b
f01029ac:	68 0c 04 00 00       	push   $0x40c
f01029b1:	68 65 92 10 f0       	push   $0xf0109265
f01029b6:	e8 8e d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01029bb:	68 00 8d 10 f0       	push   $0xf0108d00
f01029c0:	68 8b 92 10 f0       	push   $0xf010928b
f01029c5:	68 0f 04 00 00       	push   $0x40f
f01029ca:	68 65 92 10 f0       	push   $0xf0109265
f01029cf:	e8 75 d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01029d4:	68 90 8c 10 f0       	push   $0xf0108c90
f01029d9:	68 8b 92 10 f0       	push   $0xf010928b
f01029de:	68 10 04 00 00       	push   $0x410
f01029e3:	68 65 92 10 f0       	push   $0xf0109265
f01029e8:	e8 5c d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01029ed:	68 3c 8d 10 f0       	push   $0xf0108d3c
f01029f2:	68 8b 92 10 f0       	push   $0xf010928b
f01029f7:	68 13 04 00 00       	push   $0x413
f01029fc:	68 65 92 10 f0       	push   $0xf0109265
f0102a01:	e8 43 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a06:	68 68 8d 10 f0       	push   $0xf0108d68
f0102a0b:	68 8b 92 10 f0       	push   $0xf010928b
f0102a10:	68 14 04 00 00       	push   $0x414
f0102a15:	68 65 92 10 f0       	push   $0xf0109265
f0102a1a:	e8 2a d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f0102a1f:	68 cf 94 10 f0       	push   $0xf01094cf
f0102a24:	68 8b 92 10 f0       	push   $0xf010928b
f0102a29:	68 16 04 00 00       	push   $0x416
f0102a2e:	68 65 92 10 f0       	push   $0xf0109265
f0102a33:	e8 11 d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a38:	68 e0 94 10 f0       	push   $0xf01094e0
f0102a3d:	68 8b 92 10 f0       	push   $0xf010928b
f0102a42:	68 17 04 00 00       	push   $0x417
f0102a47:	68 65 92 10 f0       	push   $0xf0109265
f0102a4c:	e8 f8 d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102a51:	68 98 8d 10 f0       	push   $0xf0108d98
f0102a56:	68 8b 92 10 f0       	push   $0xf010928b
f0102a5b:	68 1a 04 00 00       	push   $0x41a
f0102a60:	68 65 92 10 f0       	push   $0xf0109265
f0102a65:	e8 df d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a6a:	68 bc 8d 10 f0       	push   $0xf0108dbc
f0102a6f:	68 8b 92 10 f0       	push   $0xf010928b
f0102a74:	68 1e 04 00 00       	push   $0x41e
f0102a79:	68 65 92 10 f0       	push   $0xf0109265
f0102a7e:	e8 c6 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a83:	68 68 8d 10 f0       	push   $0xf0108d68
f0102a88:	68 8b 92 10 f0       	push   $0xf010928b
f0102a8d:	68 1f 04 00 00       	push   $0x41f
f0102a92:	68 65 92 10 f0       	push   $0xf0109265
f0102a97:	e8 ad d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102a9c:	68 86 94 10 f0       	push   $0xf0109486
f0102aa1:	68 8b 92 10 f0       	push   $0xf010928b
f0102aa6:	68 20 04 00 00       	push   $0x420
f0102aab:	68 65 92 10 f0       	push   $0xf0109265
f0102ab0:	e8 94 d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102ab5:	68 e0 94 10 f0       	push   $0xf01094e0
f0102aba:	68 8b 92 10 f0       	push   $0xf010928b
f0102abf:	68 21 04 00 00       	push   $0x421
f0102ac4:	68 65 92 10 f0       	push   $0xf0109265
f0102ac9:	e8 7b d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102ace:	68 e0 8d 10 f0       	push   $0xf0108de0
f0102ad3:	68 8b 92 10 f0       	push   $0xf010928b
f0102ad8:	68 24 04 00 00       	push   $0x424
f0102add:	68 65 92 10 f0       	push   $0xf0109265
f0102ae2:	e8 62 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102ae7:	68 f1 94 10 f0       	push   $0xf01094f1
f0102aec:	68 8b 92 10 f0       	push   $0xf010928b
f0102af1:	68 25 04 00 00       	push   $0x425
f0102af6:	68 65 92 10 f0       	push   $0xf0109265
f0102afb:	e8 49 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102b00:	68 fd 94 10 f0       	push   $0xf01094fd
f0102b05:	68 8b 92 10 f0       	push   $0xf010928b
f0102b0a:	68 26 04 00 00       	push   $0x426
f0102b0f:	68 65 92 10 f0       	push   $0xf0109265
f0102b14:	e8 30 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102b19:	68 bc 8d 10 f0       	push   $0xf0108dbc
f0102b1e:	68 8b 92 10 f0       	push   $0xf010928b
f0102b23:	68 2a 04 00 00       	push   $0x42a
f0102b28:	68 65 92 10 f0       	push   $0xf0109265
f0102b2d:	e8 17 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102b32:	68 18 8e 10 f0       	push   $0xf0108e18
f0102b37:	68 8b 92 10 f0       	push   $0xf010928b
f0102b3c:	68 2b 04 00 00       	push   $0x42b
f0102b41:	68 65 92 10 f0       	push   $0xf0109265
f0102b46:	e8 fe d4 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102b4b:	68 12 95 10 f0       	push   $0xf0109512
f0102b50:	68 8b 92 10 f0       	push   $0xf010928b
f0102b55:	68 2c 04 00 00       	push   $0x42c
f0102b5a:	68 65 92 10 f0       	push   $0xf0109265
f0102b5f:	e8 e5 d4 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102b64:	68 e0 94 10 f0       	push   $0xf01094e0
f0102b69:	68 8b 92 10 f0       	push   $0xf010928b
f0102b6e:	68 2d 04 00 00       	push   $0x42d
f0102b73:	68 65 92 10 f0       	push   $0xf0109265
f0102b78:	e8 cc d4 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b7d:	68 40 8e 10 f0       	push   $0xf0108e40
f0102b82:	68 8b 92 10 f0       	push   $0xf010928b
f0102b87:	68 30 04 00 00       	push   $0x430
f0102b8c:	68 65 92 10 f0       	push   $0xf0109265
f0102b91:	e8 b3 d4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102b96:	68 34 94 10 f0       	push   $0xf0109434
f0102b9b:	68 8b 92 10 f0       	push   $0xf010928b
f0102ba0:	68 33 04 00 00       	push   $0x433
f0102ba5:	68 65 92 10 f0       	push   $0xf0109265
f0102baa:	e8 9a d4 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102baf:	68 e4 8a 10 f0       	push   $0xf0108ae4
f0102bb4:	68 8b 92 10 f0       	push   $0xf010928b
f0102bb9:	68 36 04 00 00       	push   $0x436
f0102bbe:	68 65 92 10 f0       	push   $0xf0109265
f0102bc3:	e8 81 d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102bc8:	68 97 94 10 f0       	push   $0xf0109497
f0102bcd:	68 8b 92 10 f0       	push   $0xf010928b
f0102bd2:	68 38 04 00 00       	push   $0x438
f0102bd7:	68 65 92 10 f0       	push   $0xf0109265
f0102bdc:	e8 68 d4 ff ff       	call   f0100049 <_panic>
f0102be1:	50                   	push   %eax
f0102be2:	68 74 80 10 f0       	push   $0xf0108074
f0102be7:	68 3f 04 00 00       	push   $0x43f
f0102bec:	68 65 92 10 f0       	push   $0xf0109265
f0102bf1:	e8 53 d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102bf6:	68 23 95 10 f0       	push   $0xf0109523
f0102bfb:	68 8b 92 10 f0       	push   $0xf010928b
f0102c00:	68 40 04 00 00       	push   $0x440
f0102c05:	68 65 92 10 f0       	push   $0xf0109265
f0102c0a:	e8 3a d4 ff ff       	call   f0100049 <_panic>
f0102c0f:	50                   	push   %eax
f0102c10:	68 74 80 10 f0       	push   $0xf0108074
f0102c15:	6a 58                	push   $0x58
f0102c17:	68 71 92 10 f0       	push   $0xf0109271
f0102c1c:	e8 28 d4 ff ff       	call   f0100049 <_panic>
f0102c21:	50                   	push   %eax
f0102c22:	68 74 80 10 f0       	push   $0xf0108074
f0102c27:	6a 58                	push   $0x58
f0102c29:	68 71 92 10 f0       	push   $0xf0109271
f0102c2e:	e8 16 d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102c33:	68 3b 95 10 f0       	push   $0xf010953b
f0102c38:	68 8b 92 10 f0       	push   $0xf010928b
f0102c3d:	68 4a 04 00 00       	push   $0x44a
f0102c42:	68 65 92 10 f0       	push   $0xf0109265
f0102c47:	e8 fd d3 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102c4c:	68 64 8e 10 f0       	push   $0xf0108e64
f0102c51:	68 8b 92 10 f0       	push   $0xf010928b
f0102c56:	68 5a 04 00 00       	push   $0x45a
f0102c5b:	68 65 92 10 f0       	push   $0xf0109265
f0102c60:	e8 e4 d3 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102c65:	68 8c 8e 10 f0       	push   $0xf0108e8c
f0102c6a:	68 8b 92 10 f0       	push   $0xf010928b
f0102c6f:	68 5b 04 00 00       	push   $0x45b
f0102c74:	68 65 92 10 f0       	push   $0xf0109265
f0102c79:	e8 cb d3 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c7e:	68 b4 8e 10 f0       	push   $0xf0108eb4
f0102c83:	68 8b 92 10 f0       	push   $0xf010928b
f0102c88:	68 5d 04 00 00       	push   $0x45d
f0102c8d:	68 65 92 10 f0       	push   $0xf0109265
f0102c92:	e8 b2 d3 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102c97:	68 52 95 10 f0       	push   $0xf0109552
f0102c9c:	68 8b 92 10 f0       	push   $0xf010928b
f0102ca1:	68 5f 04 00 00       	push   $0x45f
f0102ca6:	68 65 92 10 f0       	push   $0xf0109265
f0102cab:	e8 99 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102cb0:	68 dc 8e 10 f0       	push   $0xf0108edc
f0102cb5:	68 8b 92 10 f0       	push   $0xf010928b
f0102cba:	68 61 04 00 00       	push   $0x461
f0102cbf:	68 65 92 10 f0       	push   $0xf0109265
f0102cc4:	e8 80 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102cc9:	68 00 8f 10 f0       	push   $0xf0108f00
f0102cce:	68 8b 92 10 f0       	push   $0xf010928b
f0102cd3:	68 62 04 00 00       	push   $0x462
f0102cd8:	68 65 92 10 f0       	push   $0xf0109265
f0102cdd:	e8 67 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102ce2:	68 30 8f 10 f0       	push   $0xf0108f30
f0102ce7:	68 8b 92 10 f0       	push   $0xf010928b
f0102cec:	68 63 04 00 00       	push   $0x463
f0102cf1:	68 65 92 10 f0       	push   $0xf0109265
f0102cf6:	e8 4e d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102cfb:	68 54 8f 10 f0       	push   $0xf0108f54
f0102d00:	68 8b 92 10 f0       	push   $0xf010928b
f0102d05:	68 64 04 00 00       	push   $0x464
f0102d0a:	68 65 92 10 f0       	push   $0xf0109265
f0102d0f:	e8 35 d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102d14:	68 80 8f 10 f0       	push   $0xf0108f80
f0102d19:	68 8b 92 10 f0       	push   $0xf010928b
f0102d1e:	68 66 04 00 00       	push   $0x466
f0102d23:	68 65 92 10 f0       	push   $0xf0109265
f0102d28:	e8 1c d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102d2d:	68 c4 8f 10 f0       	push   $0xf0108fc4
f0102d32:	68 8b 92 10 f0       	push   $0xf010928b
f0102d37:	68 67 04 00 00       	push   $0x467
f0102d3c:	68 65 92 10 f0       	push   $0xf0109265
f0102d41:	e8 03 d3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d46:	50                   	push   %eax
f0102d47:	68 98 80 10 f0       	push   $0xf0108098
f0102d4c:	68 bf 00 00 00       	push   $0xbf
f0102d51:	68 65 92 10 f0       	push   $0xf0109265
f0102d56:	e8 ee d2 ff ff       	call   f0100049 <_panic>
f0102d5b:	50                   	push   %eax
f0102d5c:	68 98 80 10 f0       	push   $0xf0108098
f0102d61:	68 c7 00 00 00       	push   $0xc7
f0102d66:	68 65 92 10 f0       	push   $0xf0109265
f0102d6b:	e8 d9 d2 ff ff       	call   f0100049 <_panic>
f0102d70:	50                   	push   %eax
f0102d71:	68 98 80 10 f0       	push   $0xf0108098
f0102d76:	68 d3 00 00 00       	push   $0xd3
f0102d7b:	68 65 92 10 f0       	push   $0xf0109265
f0102d80:	e8 c4 d2 ff ff       	call   f0100049 <_panic>
f0102d85:	53                   	push   %ebx
f0102d86:	68 98 80 10 f0       	push   $0xf0108098
f0102d8b:	68 1a 01 00 00       	push   $0x11a
f0102d90:	68 65 92 10 f0       	push   $0xf0109265
f0102d95:	e8 af d2 ff ff       	call   f0100049 <_panic>
f0102d9a:	56                   	push   %esi
f0102d9b:	68 98 80 10 f0       	push   $0xf0108098
f0102da0:	68 71 03 00 00       	push   $0x371
f0102da5:	68 65 92 10 f0       	push   $0xf0109265
f0102daa:	e8 9a d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102daf:	68 f8 8f 10 f0       	push   $0xf0108ff8
f0102db4:	68 8b 92 10 f0       	push   $0xf010928b
f0102db9:	68 71 03 00 00       	push   $0x371
f0102dbe:	68 65 92 10 f0       	push   $0xf0109265
f0102dc3:	e8 81 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102dc8:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0102dcd:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102dd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102dd3:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102dd8:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102dde:	89 da                	mov    %ebx,%edx
f0102de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102de3:	e8 5e e0 ff ff       	call   f0100e46 <check_va2pa>
f0102de8:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102def:	76 45                	jbe    f0102e36 <mem_init+0x167b>
f0102df1:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102df4:	39 d0                	cmp    %edx,%eax
f0102df6:	75 55                	jne    f0102e4d <mem_init+0x1692>
f0102df8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102dfe:	81 fb 00 10 c2 ee    	cmp    $0xeec21000,%ebx
f0102e04:	75 d8                	jne    f0102dde <mem_init+0x1623>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102e06:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102e09:	8b 81 00 0f 00 00    	mov    0xf00(%ecx),%eax
f0102e0f:	89 c2                	mov    %eax,%edx
f0102e11:	81 e2 81 00 00 00    	and    $0x81,%edx
f0102e17:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f0102e1d:	0f 85 75 01 00 00    	jne    f0102f98 <mem_init+0x17dd>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f0102e23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102e28:	0f 85 6a 01 00 00    	jne    f0102f98 <mem_init+0x17dd>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102e2e:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102e31:	c1 e6 0c             	shl    $0xc,%esi
f0102e34:	eb 3f                	jmp    f0102e75 <mem_init+0x16ba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e36:	ff 75 c8             	pushl  -0x38(%ebp)
f0102e39:	68 98 80 10 f0       	push   $0xf0108098
f0102e3e:	68 76 03 00 00       	push   $0x376
f0102e43:	68 65 92 10 f0       	push   $0xf0109265
f0102e48:	e8 fc d1 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102e4d:	68 2c 90 10 f0       	push   $0xf010902c
f0102e52:	68 8b 92 10 f0       	push   $0xf010928b
f0102e57:	68 76 03 00 00       	push   $0x376
f0102e5c:	68 65 92 10 f0       	push   $0xf0109265
f0102e61:	e8 e3 d1 ff ff       	call   f0100049 <_panic>
	return PTE_ADDR(*pgdir);
f0102e66:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e6c:	39 d0                	cmp    %edx,%eax
f0102e6e:	75 25                	jne    f0102e95 <mem_init+0x16da>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102e70:	05 00 00 40 00       	add    $0x400000,%eax
f0102e75:	39 f0                	cmp    %esi,%eax
f0102e77:	73 35                	jae    f0102eae <mem_init+0x16f3>
	pgdir = &pgdir[PDX(va)];
f0102e79:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102e7f:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102e82:	8b 14 91             	mov    (%ecx,%edx,4),%edx
f0102e85:	89 d3                	mov    %edx,%ebx
f0102e87:	81 e3 81 00 00 00    	and    $0x81,%ebx
f0102e8d:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
f0102e93:	74 d1                	je     f0102e66 <mem_init+0x16ab>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e95:	68 60 90 10 f0       	push   $0xf0109060
f0102e9a:	68 8b 92 10 f0       	push   $0xf010928b
f0102e9f:	68 7b 03 00 00       	push   $0x37b
f0102ea4:	68 65 92 10 f0       	push   $0xf0109265
f0102ea9:	e8 9b d1 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102eae:	83 ec 0c             	sub    $0xc,%esp
f0102eb1:	68 7d 95 10 f0       	push   $0xf010957d
f0102eb6:	e8 3b 13 00 00       	call   f01041f6 <cprintf>
f0102ebb:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ebe:	b8 00 b0 12 f0       	mov    $0xf012b000,%eax
f0102ec3:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102ec8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102ecb:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102ecd:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102ed0:	89 f3                	mov    %esi,%ebx
f0102ed2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102ed5:	05 00 80 00 20       	add    $0x20008000,%eax
f0102eda:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102edd:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102ee3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102ee6:	89 da                	mov    %ebx,%edx
f0102ee8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102eeb:	e8 56 df ff ff       	call   f0100e46 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102ef0:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102ef6:	0f 86 a6 00 00 00    	jbe    f0102fa2 <mem_init+0x17e7>
f0102efc:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102eff:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102f02:	39 d0                	cmp    %edx,%eax
f0102f04:	0f 85 af 00 00 00    	jne    f0102fb9 <mem_init+0x17fe>
f0102f0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102f10:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0102f13:	75 d1                	jne    f0102ee6 <mem_init+0x172b>
f0102f15:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f1b:	89 da                	mov    %ebx,%edx
f0102f1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f20:	e8 21 df ff ff       	call   f0100e46 <check_va2pa>
f0102f25:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102f28:	0f 85 a4 00 00 00    	jne    f0102fd2 <mem_init+0x1817>
f0102f2e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102f34:	39 f3                	cmp    %esi,%ebx
f0102f36:	75 e3                	jne    f0102f1b <mem_init+0x1760>
f0102f38:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102f3e:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102f45:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f0102f4b:	81 ff 00 b0 16 f0    	cmp    $0xf016b000,%edi
f0102f51:	0f 85 76 ff ff ff    	jne    f0102ecd <mem_init+0x1712>
f0102f57:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0102f5a:	e9 c7 00 00 00       	jmp    f0103026 <mem_init+0x186b>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f5f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102f65:	39 f3                	cmp    %esi,%ebx
f0102f67:	0f 83 51 ff ff ff    	jae    f0102ebe <mem_init+0x1703>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102f6d:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102f73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f76:	e8 cb de ff ff       	call   f0100e46 <check_va2pa>
f0102f7b:	39 c3                	cmp    %eax,%ebx
f0102f7d:	74 e0                	je     f0102f5f <mem_init+0x17a4>
f0102f7f:	68 8c 90 10 f0       	push   $0xf010908c
f0102f84:	68 8b 92 10 f0       	push   $0xf010928b
f0102f89:	68 80 03 00 00       	push   $0x380
f0102f8e:	68 65 92 10 f0       	push   $0xf0109265
f0102f93:	e8 b1 d0 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f98:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f9b:	c1 e6 0c             	shl    $0xc,%esi
f0102f9e:	89 fb                	mov    %edi,%ebx
f0102fa0:	eb c3                	jmp    f0102f65 <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102fa2:	ff 75 c0             	pushl  -0x40(%ebp)
f0102fa5:	68 98 80 10 f0       	push   $0xf0108098
f0102faa:	68 88 03 00 00       	push   $0x388
f0102faf:	68 65 92 10 f0       	push   $0xf0109265
f0102fb4:	e8 90 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102fb9:	68 b4 90 10 f0       	push   $0xf01090b4
f0102fbe:	68 8b 92 10 f0       	push   $0xf010928b
f0102fc3:	68 88 03 00 00       	push   $0x388
f0102fc8:	68 65 92 10 f0       	push   $0xf0109265
f0102fcd:	e8 77 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102fd2:	68 fc 90 10 f0       	push   $0xf01090fc
f0102fd7:	68 8b 92 10 f0       	push   $0xf010928b
f0102fdc:	68 8a 03 00 00       	push   $0x38a
f0102fe1:	68 65 92 10 f0       	push   $0xf0109265
f0102fe6:	e8 5e d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0102feb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fee:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102ff2:	75 4e                	jne    f0103042 <mem_init+0x1887>
f0102ff4:	68 94 95 10 f0       	push   $0xf0109594
f0102ff9:	68 8b 92 10 f0       	push   $0xf010928b
f0102ffe:	68 95 03 00 00       	push   $0x395
f0103003:	68 65 92 10 f0       	push   $0xf0109265
f0103008:	e8 3c d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_P);
f010300d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103010:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0103013:	a8 01                	test   $0x1,%al
f0103015:	74 30                	je     f0103047 <mem_init+0x188c>
				assert(pgdir[i] & PTE_W);
f0103017:	a8 02                	test   $0x2,%al
f0103019:	74 45                	je     f0103060 <mem_init+0x18a5>
	for (i = 0; i < NPDENTRIES; i++) {
f010301b:	83 c7 01             	add    $0x1,%edi
f010301e:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0103024:	74 6c                	je     f0103092 <mem_init+0x18d7>
		switch (i) {
f0103026:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f010302c:	83 f8 04             	cmp    $0x4,%eax
f010302f:	76 ba                	jbe    f0102feb <mem_init+0x1830>
			if (i >= PDX(KERNBASE)) {
f0103031:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0103037:	77 d4                	ja     f010300d <mem_init+0x1852>
				assert(pgdir[i] == 0);
f0103039:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010303c:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0103040:	75 37                	jne    f0103079 <mem_init+0x18be>
	for (i = 0; i < NPDENTRIES; i++) {
f0103042:	83 c7 01             	add    $0x1,%edi
f0103045:	eb df                	jmp    f0103026 <mem_init+0x186b>
				assert(pgdir[i] & PTE_P);
f0103047:	68 94 95 10 f0       	push   $0xf0109594
f010304c:	68 8b 92 10 f0       	push   $0xf010928b
f0103051:	68 99 03 00 00       	push   $0x399
f0103056:	68 65 92 10 f0       	push   $0xf0109265
f010305b:	e8 e9 cf ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0103060:	68 a5 95 10 f0       	push   $0xf01095a5
f0103065:	68 8b 92 10 f0       	push   $0xf010928b
f010306a:	68 9a 03 00 00       	push   $0x39a
f010306f:	68 65 92 10 f0       	push   $0xf0109265
f0103074:	e8 d0 cf ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f0103079:	68 b6 95 10 f0       	push   $0xf01095b6
f010307e:	68 8b 92 10 f0       	push   $0xf010928b
f0103083:	68 9c 03 00 00       	push   $0x39c
f0103088:	68 65 92 10 f0       	push   $0xf0109265
f010308d:	e8 b7 cf ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103092:	83 ec 0c             	sub    $0xc,%esp
f0103095:	68 20 91 10 f0       	push   $0xf0109120
f010309a:	e8 57 11 00 00       	call   f01041f6 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f010309f:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f01030a2:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f01030a5:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f01030a8:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01030ad:	83 c4 10             	add    $0x10,%esp
f01030b0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01030b5:	0f 86 1f 02 00 00    	jbe    f01032da <mem_init+0x1b1f>
	return (physaddr_t)kva - KERNBASE;
f01030bb:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01030c0:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f01030c3:	b8 00 00 00 00       	mov    $0x0,%eax
f01030c8:	e8 83 de ff ff       	call   f0100f50 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f01030cd:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f01030d0:	83 e0 f3             	and    $0xfffffff3,%eax
f01030d3:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f01030d8:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01030db:	83 ec 0c             	sub    $0xc,%esp
f01030de:	6a 00                	push   $0x0
f01030e0:	e8 58 e2 ff ff       	call   f010133d <page_alloc>
f01030e5:	89 c6                	mov    %eax,%esi
f01030e7:	83 c4 10             	add    $0x10,%esp
f01030ea:	85 c0                	test   %eax,%eax
f01030ec:	0f 84 fd 01 00 00    	je     f01032ef <mem_init+0x1b34>
	assert((pp1 = page_alloc(0)));
f01030f2:	83 ec 0c             	sub    $0xc,%esp
f01030f5:	6a 00                	push   $0x0
f01030f7:	e8 41 e2 ff ff       	call   f010133d <page_alloc>
f01030fc:	89 c7                	mov    %eax,%edi
f01030fe:	83 c4 10             	add    $0x10,%esp
f0103101:	85 c0                	test   %eax,%eax
f0103103:	0f 84 ff 01 00 00    	je     f0103308 <mem_init+0x1b4d>
	assert((pp2 = page_alloc(0)));
f0103109:	83 ec 0c             	sub    $0xc,%esp
f010310c:	6a 00                	push   $0x0
f010310e:	e8 2a e2 ff ff       	call   f010133d <page_alloc>
f0103113:	89 c3                	mov    %eax,%ebx
f0103115:	83 c4 10             	add    $0x10,%esp
f0103118:	85 c0                	test   %eax,%eax
f010311a:	0f 84 01 02 00 00    	je     f0103321 <mem_init+0x1b66>
	page_free(pp0);
f0103120:	83 ec 0c             	sub    $0xc,%esp
f0103123:	56                   	push   %esi
f0103124:	e8 86 e2 ff ff       	call   f01013af <page_free>
	return (pp - pages) << PGSHIFT;
f0103129:	89 f8                	mov    %edi,%eax
f010312b:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103131:	c1 f8 03             	sar    $0x3,%eax
f0103134:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103137:	89 c2                	mov    %eax,%edx
f0103139:	c1 ea 0c             	shr    $0xc,%edx
f010313c:	83 c4 10             	add    $0x10,%esp
f010313f:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103145:	0f 83 ef 01 00 00    	jae    f010333a <mem_init+0x1b7f>
	memset(page2kva(pp1), 1, PGSIZE);
f010314b:	83 ec 04             	sub    $0x4,%esp
f010314e:	68 00 10 00 00       	push   $0x1000
f0103153:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0103155:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010315a:	50                   	push   %eax
f010315b:	e8 a4 37 00 00       	call   f0106904 <memset>
	return (pp - pages) << PGSHIFT;
f0103160:	89 d8                	mov    %ebx,%eax
f0103162:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103168:	c1 f8 03             	sar    $0x3,%eax
f010316b:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010316e:	89 c2                	mov    %eax,%edx
f0103170:	c1 ea 0c             	shr    $0xc,%edx
f0103173:	83 c4 10             	add    $0x10,%esp
f0103176:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f010317c:	0f 83 ca 01 00 00    	jae    f010334c <mem_init+0x1b91>
	memset(page2kva(pp2), 2, PGSIZE);
f0103182:	83 ec 04             	sub    $0x4,%esp
f0103185:	68 00 10 00 00       	push   $0x1000
f010318a:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f010318c:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103191:	50                   	push   %eax
f0103192:	e8 6d 37 00 00       	call   f0106904 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0103197:	6a 02                	push   $0x2
f0103199:	68 00 10 00 00       	push   $0x1000
f010319e:	57                   	push   %edi
f010319f:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01031a5:	e8 cf e4 ff ff       	call   f0101679 <page_insert>
	assert(pp1->pp_ref == 1);
f01031aa:	83 c4 20             	add    $0x20,%esp
f01031ad:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f01031b2:	0f 85 a6 01 00 00    	jne    f010335e <mem_init+0x1ba3>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01031b8:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01031bf:	01 01 01 
f01031c2:	0f 85 af 01 00 00    	jne    f0103377 <mem_init+0x1bbc>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f01031c8:	6a 02                	push   $0x2
f01031ca:	68 00 10 00 00       	push   $0x1000
f01031cf:	53                   	push   %ebx
f01031d0:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01031d6:	e8 9e e4 ff ff       	call   f0101679 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01031db:	83 c4 10             	add    $0x10,%esp
f01031de:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f01031e5:	02 02 02 
f01031e8:	0f 85 a2 01 00 00    	jne    f0103390 <mem_init+0x1bd5>
	assert(pp2->pp_ref == 1);
f01031ee:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01031f3:	0f 85 b0 01 00 00    	jne    f01033a9 <mem_init+0x1bee>
	assert(pp1->pp_ref == 0);
f01031f9:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01031fe:	0f 85 be 01 00 00    	jne    f01033c2 <mem_init+0x1c07>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103204:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f010320b:	03 03 03 
	return (pp - pages) << PGSHIFT;
f010320e:	89 d8                	mov    %ebx,%eax
f0103210:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103216:	c1 f8 03             	sar    $0x3,%eax
f0103219:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010321c:	89 c2                	mov    %eax,%edx
f010321e:	c1 ea 0c             	shr    $0xc,%edx
f0103221:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103227:	0f 83 ae 01 00 00    	jae    f01033db <mem_init+0x1c20>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010322d:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0103234:	03 03 03 
f0103237:	0f 85 b0 01 00 00    	jne    f01033ed <mem_init+0x1c32>
	page_remove(kern_pgdir, (void*) PGSIZE);
f010323d:	83 ec 08             	sub    $0x8,%esp
f0103240:	68 00 10 00 00       	push   $0x1000
f0103245:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010324b:	e8 e3 e3 ff ff       	call   f0101633 <page_remove>
	assert(pp2->pp_ref == 0);
f0103250:	83 c4 10             	add    $0x10,%esp
f0103253:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103258:	0f 85 a8 01 00 00    	jne    f0103406 <mem_init+0x1c4b>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010325e:	8b 0d 8c ed 5d f0    	mov    0xf05ded8c,%ecx
f0103264:	8b 11                	mov    (%ecx),%edx
f0103266:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f010326c:	89 f0                	mov    %esi,%eax
f010326e:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103274:	c1 f8 03             	sar    $0x3,%eax
f0103277:	c1 e0 0c             	shl    $0xc,%eax
f010327a:	39 c2                	cmp    %eax,%edx
f010327c:	0f 85 9d 01 00 00    	jne    f010341f <mem_init+0x1c64>
	kern_pgdir[0] = 0;
f0103282:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0103288:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010328d:	0f 85 a5 01 00 00    	jne    f0103438 <mem_init+0x1c7d>
	pp0->pp_ref = 0;
f0103293:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0103299:	83 ec 0c             	sub    $0xc,%esp
f010329c:	56                   	push   %esi
f010329d:	e8 0d e1 ff ff       	call   f01013af <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f01032a2:	c7 04 24 b4 91 10 f0 	movl   $0xf01091b4,(%esp)
f01032a9:	e8 48 0f 00 00       	call   f01041f6 <cprintf>
	cprintf("__USER_MAP_BEGIN__ = %08x\n", __USER_MAP_BEGIN__);
f01032ae:	83 c4 08             	add    $0x8,%esp
f01032b1:	68 00 10 12 f0       	push   $0xf0121000
f01032b6:	68 c4 95 10 f0       	push   $0xf01095c4
f01032bb:	e8 36 0f 00 00       	call   f01041f6 <cprintf>
	cprintf("__USER_MAP_END__ = %08x\n", __USER_MAP_END__);
f01032c0:	83 c4 08             	add    $0x8,%esp
f01032c3:	68 00 c0 16 f0       	push   $0xf016c000
f01032c8:	68 df 95 10 f0       	push   $0xf01095df
f01032cd:	e8 24 0f 00 00       	call   f01041f6 <cprintf>
}
f01032d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01032d5:	5b                   	pop    %ebx
f01032d6:	5e                   	pop    %esi
f01032d7:	5f                   	pop    %edi
f01032d8:	5d                   	pop    %ebp
f01032d9:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01032da:	50                   	push   %eax
f01032db:	68 98 80 10 f0       	push   $0xf0108098
f01032e0:	68 f0 00 00 00       	push   $0xf0
f01032e5:	68 65 92 10 f0       	push   $0xf0109265
f01032ea:	e8 5a cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f01032ef:	68 89 93 10 f0       	push   $0xf0109389
f01032f4:	68 8b 92 10 f0       	push   $0xf010928b
f01032f9:	68 7c 04 00 00       	push   $0x47c
f01032fe:	68 65 92 10 f0       	push   $0xf0109265
f0103303:	e8 41 cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0103308:	68 9f 93 10 f0       	push   $0xf010939f
f010330d:	68 8b 92 10 f0       	push   $0xf010928b
f0103312:	68 7d 04 00 00       	push   $0x47d
f0103317:	68 65 92 10 f0       	push   $0xf0109265
f010331c:	e8 28 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0103321:	68 b5 93 10 f0       	push   $0xf01093b5
f0103326:	68 8b 92 10 f0       	push   $0xf010928b
f010332b:	68 7e 04 00 00       	push   $0x47e
f0103330:	68 65 92 10 f0       	push   $0xf0109265
f0103335:	e8 0f cd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010333a:	50                   	push   %eax
f010333b:	68 74 80 10 f0       	push   $0xf0108074
f0103340:	6a 58                	push   $0x58
f0103342:	68 71 92 10 f0       	push   $0xf0109271
f0103347:	e8 fd cc ff ff       	call   f0100049 <_panic>
f010334c:	50                   	push   %eax
f010334d:	68 74 80 10 f0       	push   $0xf0108074
f0103352:	6a 58                	push   $0x58
f0103354:	68 71 92 10 f0       	push   $0xf0109271
f0103359:	e8 eb cc ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f010335e:	68 86 94 10 f0       	push   $0xf0109486
f0103363:	68 8b 92 10 f0       	push   $0xf010928b
f0103368:	68 83 04 00 00       	push   $0x483
f010336d:	68 65 92 10 f0       	push   $0xf0109265
f0103372:	e8 d2 cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103377:	68 40 91 10 f0       	push   $0xf0109140
f010337c:	68 8b 92 10 f0       	push   $0xf010928b
f0103381:	68 84 04 00 00       	push   $0x484
f0103386:	68 65 92 10 f0       	push   $0xf0109265
f010338b:	e8 b9 cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103390:	68 64 91 10 f0       	push   $0xf0109164
f0103395:	68 8b 92 10 f0       	push   $0xf010928b
f010339a:	68 86 04 00 00       	push   $0x486
f010339f:	68 65 92 10 f0       	push   $0xf0109265
f01033a4:	e8 a0 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01033a9:	68 a8 94 10 f0       	push   $0xf01094a8
f01033ae:	68 8b 92 10 f0       	push   $0xf010928b
f01033b3:	68 87 04 00 00       	push   $0x487
f01033b8:	68 65 92 10 f0       	push   $0xf0109265
f01033bd:	e8 87 cc ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f01033c2:	68 12 95 10 f0       	push   $0xf0109512
f01033c7:	68 8b 92 10 f0       	push   $0xf010928b
f01033cc:	68 88 04 00 00       	push   $0x488
f01033d1:	68 65 92 10 f0       	push   $0xf0109265
f01033d6:	e8 6e cc ff ff       	call   f0100049 <_panic>
f01033db:	50                   	push   %eax
f01033dc:	68 74 80 10 f0       	push   $0xf0108074
f01033e1:	6a 58                	push   $0x58
f01033e3:	68 71 92 10 f0       	push   $0xf0109271
f01033e8:	e8 5c cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01033ed:	68 88 91 10 f0       	push   $0xf0109188
f01033f2:	68 8b 92 10 f0       	push   $0xf010928b
f01033f7:	68 8a 04 00 00       	push   $0x48a
f01033fc:	68 65 92 10 f0       	push   $0xf0109265
f0103401:	e8 43 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103406:	68 e0 94 10 f0       	push   $0xf01094e0
f010340b:	68 8b 92 10 f0       	push   $0xf010928b
f0103410:	68 8c 04 00 00       	push   $0x48c
f0103415:	68 65 92 10 f0       	push   $0xf0109265
f010341a:	e8 2a cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010341f:	68 e4 8a 10 f0       	push   $0xf0108ae4
f0103424:	68 8b 92 10 f0       	push   $0xf010928b
f0103429:	68 8f 04 00 00       	push   $0x48f
f010342e:	68 65 92 10 f0       	push   $0xf0109265
f0103433:	e8 11 cc ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0103438:	68 97 94 10 f0       	push   $0xf0109497
f010343d:	68 8b 92 10 f0       	push   $0xf010928b
f0103442:	68 91 04 00 00       	push   $0x491
f0103447:	68 65 92 10 f0       	push   $0xf0109265
f010344c:	e8 f8 cb ff ff       	call   f0100049 <_panic>

f0103451 <user_mem_check>:
{
f0103451:	55                   	push   %ebp
f0103452:	89 e5                	mov    %esp,%ebp
f0103454:	57                   	push   %edi
f0103455:	56                   	push   %esi
f0103456:	53                   	push   %ebx
f0103457:	83 ec 1c             	sub    $0x1c,%esp
f010345a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	perm |= PTE_P;
f010345d:	8b 7d 14             	mov    0x14(%ebp),%edi
f0103460:	83 cf 01             	or     $0x1,%edi
	uint32_t i = (uint32_t)va; //buggy lab3 buggy
f0103463:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	uint32_t end = (uint32_t)va + len;
f0103466:	89 d8                	mov    %ebx,%eax
f0103468:	03 45 10             	add    0x10(%ebp),%eax
f010346b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010346e:	8b 75 08             	mov    0x8(%ebp),%esi
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f0103471:	eb 19                	jmp    f010348c <user_mem_check+0x3b>
			user_mem_check_addr = (uintptr_t)i;
f0103473:	89 1d 3c d9 5d f0    	mov    %ebx,0xf05dd93c
			return -E_FAULT;
f0103479:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010347e:	eb 6a                	jmp    f01034ea <user_mem_check+0x99>
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f0103480:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103486:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f010348c:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010348f:	73 61                	jae    f01034f2 <user_mem_check+0xa1>
		if((uint32_t)va >= ULIM){
f0103491:	81 7d e0 ff ff 7f ef 	cmpl   $0xef7fffff,-0x20(%ebp)
f0103498:	77 d9                	ja     f0103473 <user_mem_check+0x22>
		pte_t *the_pte = pgdir_walk(env->env_pgdir, (void *)i, 0);
f010349a:	83 ec 04             	sub    $0x4,%esp
f010349d:	6a 00                	push   $0x0
f010349f:	53                   	push   %ebx
f01034a0:	ff 76 60             	pushl  0x60(%esi)
f01034a3:	e8 6b df ff ff       	call   f0101413 <pgdir_walk>
		if(!the_pte || (*the_pte & perm) != perm){//lab4 bug
f01034a8:	83 c4 10             	add    $0x10,%esp
f01034ab:	85 c0                	test   %eax,%eax
f01034ad:	74 08                	je     f01034b7 <user_mem_check+0x66>
f01034af:	89 fa                	mov    %edi,%edx
f01034b1:	23 10                	and    (%eax),%edx
f01034b3:	39 d7                	cmp    %edx,%edi
f01034b5:	74 c9                	je     f0103480 <user_mem_check+0x2f>
f01034b7:	89 c6                	mov    %eax,%esi
			cprintf("PTE_P: 0x%x PTE_W: 0x%x PTE_U: 0x%x\n", PTE_P, PTE_W, PTE_U);
f01034b9:	6a 04                	push   $0x4
f01034bb:	6a 02                	push   $0x2
f01034bd:	6a 01                	push   $0x1
f01034bf:	68 e0 91 10 f0       	push   $0xf01091e0
f01034c4:	e8 2d 0d 00 00       	call   f01041f6 <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f01034c9:	83 c4 0c             	add    $0xc,%esp
f01034cc:	89 f8                	mov    %edi,%eax
f01034ce:	23 06                	and    (%esi),%eax
f01034d0:	50                   	push   %eax
f01034d1:	57                   	push   %edi
f01034d2:	68 08 92 10 f0       	push   $0xf0109208
f01034d7:	e8 1a 0d 00 00       	call   f01041f6 <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f01034dc:	89 1d 3c d9 5d f0    	mov    %ebx,0xf05dd93c
			return -E_FAULT;
f01034e2:	83 c4 10             	add    $0x10,%esp
f01034e5:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01034ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01034ed:	5b                   	pop    %ebx
f01034ee:	5e                   	pop    %esi
f01034ef:	5f                   	pop    %edi
f01034f0:	5d                   	pop    %ebp
f01034f1:	c3                   	ret    
	return 0;
f01034f2:	b8 00 00 00 00       	mov    $0x0,%eax
f01034f7:	eb f1                	jmp    f01034ea <user_mem_check+0x99>

f01034f9 <user_mem_assert>:
{
f01034f9:	55                   	push   %ebp
f01034fa:	89 e5                	mov    %esp,%ebp
f01034fc:	53                   	push   %ebx
f01034fd:	83 ec 04             	sub    $0x4,%esp
f0103500:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103503:	8b 45 14             	mov    0x14(%ebp),%eax
f0103506:	83 c8 04             	or     $0x4,%eax
f0103509:	50                   	push   %eax
f010350a:	ff 75 10             	pushl  0x10(%ebp)
f010350d:	ff 75 0c             	pushl  0xc(%ebp)
f0103510:	53                   	push   %ebx
f0103511:	e8 3b ff ff ff       	call   f0103451 <user_mem_check>
f0103516:	83 c4 10             	add    $0x10,%esp
f0103519:	85 c0                	test   %eax,%eax
f010351b:	78 05                	js     f0103522 <user_mem_assert+0x29>
}
f010351d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103520:	c9                   	leave  
f0103521:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103522:	83 ec 04             	sub    $0x4,%esp
f0103525:	ff 35 3c d9 5d f0    	pushl  0xf05dd93c
f010352b:	ff 73 48             	pushl  0x48(%ebx)
f010352e:	68 30 92 10 f0       	push   $0xf0109230
f0103533:	e8 be 0c 00 00       	call   f01041f6 <cprintf>
		env_destroy(env);	// may not return
f0103538:	89 1c 24             	mov    %ebx,(%esp)
f010353b:	e8 ae 0a 00 00       	call   f0103fee <env_destroy>
f0103540:	83 c4 10             	add    $0x10,%esp
}
f0103543:	eb d8                	jmp    f010351d <user_mem_assert+0x24>

f0103545 <check_user_map>:
	}
}

 static void
check_user_map(pde_t *pgdir, void *va, uint32_t len, const char *name)
{
f0103545:	55                   	push   %ebp
f0103546:	89 e5                	mov    %esp,%ebp
f0103548:	57                   	push   %edi
f0103549:	56                   	push   %esi
f010354a:	53                   	push   %ebx
f010354b:	83 ec 2c             	sub    $0x2c,%esp
f010354e:	89 c7                	mov    %eax,%edi
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f0103550:	89 d3                	mov    %edx,%ebx
f0103552:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0103558:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f010355f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103564:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		pte_t *pte;
		if (page_lookup(pgdir, (void *) _va, &pte) == NULL) {
f0103567:	8d 75 e4             	lea    -0x1c(%ebp),%esi
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f010356a:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f010356d:	73 35                	jae    f01035a4 <check_user_map+0x5f>
		if (page_lookup(pgdir, (void *) _va, &pte) == NULL) {
f010356f:	83 ec 04             	sub    $0x4,%esp
f0103572:	56                   	push   %esi
f0103573:	53                   	push   %ebx
f0103574:	57                   	push   %edi
f0103575:	e8 1f e0 ff ff       	call   f0101599 <page_lookup>
f010357a:	83 c4 10             	add    $0x10,%esp
f010357d:	85 c0                	test   %eax,%eax
f010357f:	74 10                	je     f0103591 <check_user_map+0x4c>
			cprintf("%s not mapped in env_pgdir\n", name);
			return;
		}
		if (*pte & PTE_U) {
f0103581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103584:	f6 00 04             	testb  $0x4,(%eax)
f0103587:	75 23                	jne    f01035ac <check_user_map+0x67>
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f0103589:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010358f:	eb d9                	jmp    f010356a <check_user_map+0x25>
			cprintf("%s not mapped in env_pgdir\n", name);
f0103591:	83 ec 08             	sub    $0x8,%esp
f0103594:	ff 75 08             	pushl  0x8(%ebp)
f0103597:	68 1f 96 10 f0       	push   $0xf010961f
f010359c:	e8 55 0c 00 00       	call   f01041f6 <cprintf>
			return;
f01035a1:	83 c4 10             	add    $0x10,%esp
			cprintf("%s wrong permission in env_pgdir\n", name);
			return;
		}
	}
}
f01035a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01035a7:	5b                   	pop    %ebx
f01035a8:	5e                   	pop    %esi
f01035a9:	5f                   	pop    %edi
f01035aa:	5d                   	pop    %ebp
f01035ab:	c3                   	ret    
			cprintf("%s wrong permission in env_pgdir\n", name);
f01035ac:	83 ec 08             	sub    $0x8,%esp
f01035af:	ff 75 08             	pushl  0x8(%ebp)
f01035b2:	68 60 97 10 f0       	push   $0xf0109760
f01035b7:	e8 3a 0c 00 00       	call   f01041f6 <cprintf>
			return;
f01035bc:	83 c4 10             	add    $0x10,%esp
f01035bf:	eb e3                	jmp    f01035a4 <check_user_map+0x5f>

f01035c1 <region_alloc>:
{
f01035c1:	55                   	push   %ebp
f01035c2:	89 e5                	mov    %esp,%ebp
f01035c4:	57                   	push   %edi
f01035c5:	56                   	push   %esi
f01035c6:	53                   	push   %ebx
f01035c7:	83 ec 0c             	sub    $0xc,%esp
f01035ca:	89 c7                	mov    %eax,%edi
	uint32_t i = ROUNDDOWN((uint32_t)va, PGSIZE);
f01035cc:	89 d3                	mov    %edx,%ebx
f01035ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end = ROUNDUP((uint32_t)va + len, PGSIZE);
f01035d4:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01035db:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01035e1:	39 f3                	cmp    %esi,%ebx
f01035e3:	73 5a                	jae    f010363f <region_alloc+0x7e>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01035e5:	83 ec 0c             	sub    $0xc,%esp
f01035e8:	6a 01                	push   $0x1
f01035ea:	e8 4e dd ff ff       	call   f010133d <page_alloc>
		if(!page)
f01035ef:	83 c4 10             	add    $0x10,%esp
f01035f2:	85 c0                	test   %eax,%eax
f01035f4:	74 1b                	je     f0103611 <region_alloc+0x50>
		int ret = page_insert(e->env_pgdir, page, (void*)(i), PTE_U | PTE_W);
f01035f6:	6a 06                	push   $0x6
f01035f8:	53                   	push   %ebx
f01035f9:	50                   	push   %eax
f01035fa:	ff 77 60             	pushl  0x60(%edi)
f01035fd:	e8 77 e0 ff ff       	call   f0101679 <page_insert>
		if(ret)
f0103602:	83 c4 10             	add    $0x10,%esp
f0103605:	85 c0                	test   %eax,%eax
f0103607:	75 1f                	jne    f0103628 <region_alloc+0x67>
	for(; i < end; i+=PGSIZE){
f0103609:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010360f:	eb d0                	jmp    f01035e1 <region_alloc+0x20>
			panic("there is no page\n");
f0103611:	83 ec 04             	sub    $0x4,%esp
f0103614:	68 3b 96 10 f0       	push   $0xf010963b
f0103619:	68 d3 00 00 00       	push   $0xd3
f010361e:	68 14 96 10 f0       	push   $0xf0109614
f0103623:	e8 21 ca ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f0103628:	83 ec 04             	sub    $0x4,%esp
f010362b:	68 4d 96 10 f0       	push   $0xf010964d
f0103630:	68 d6 00 00 00       	push   $0xd6
f0103635:	68 14 96 10 f0       	push   $0xf0109614
f010363a:	e8 0a ca ff ff       	call   f0100049 <_panic>
}
f010363f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103642:	5b                   	pop    %ebx
f0103643:	5e                   	pop    %esi
f0103644:	5f                   	pop    %edi
f0103645:	5d                   	pop    %ebp
f0103646:	c3                   	ret    

f0103647 <envid2env>:
{
f0103647:	55                   	push   %ebp
f0103648:	89 e5                	mov    %esp,%ebp
f010364a:	56                   	push   %esi
f010364b:	53                   	push   %ebx
f010364c:	8b 75 08             	mov    0x8(%ebp),%esi
f010364f:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103652:	85 f6                	test   %esi,%esi
f0103654:	74 34                	je     f010368a <envid2env+0x43>
	e = &envs[ENVX(envid)];
f0103656:	89 f3                	mov    %esi,%ebx
f0103658:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010365e:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
f0103664:	03 1d 44 d9 5d f0    	add    0xf05dd944,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010366a:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f010366e:	74 31                	je     f01036a1 <envid2env+0x5a>
f0103670:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103673:	75 2c                	jne    f01036a1 <envid2env+0x5a>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103675:	84 c0                	test   %al,%al
f0103677:	75 61                	jne    f01036da <envid2env+0x93>
	*env_store = e;
f0103679:	8b 45 0c             	mov    0xc(%ebp),%eax
f010367c:	89 18                	mov    %ebx,(%eax)
	return 0;
f010367e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103683:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103686:	5b                   	pop    %ebx
f0103687:	5e                   	pop    %esi
f0103688:	5d                   	pop    %ebp
f0103689:	c3                   	ret    
		*env_store = curenv;
f010368a:	e8 7b 38 00 00       	call   f0106f0a <cpunum>
f010368f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103692:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103698:	8b 55 0c             	mov    0xc(%ebp),%edx
f010369b:	89 02                	mov    %eax,(%edx)
		return 0;
f010369d:	89 f0                	mov    %esi,%eax
f010369f:	eb e2                	jmp    f0103683 <envid2env+0x3c>
		*env_store = 0;
f01036a1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		if(e->env_status == ENV_FREE)
f01036aa:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01036ae:	74 17                	je     f01036c7 <envid2env+0x80>
		cprintf("222222222222222222222\n");
f01036b0:	83 ec 0c             	sub    $0xc,%esp
f01036b3:	68 7d 96 10 f0       	push   $0xf010967d
f01036b8:	e8 39 0b 00 00       	call   f01041f6 <cprintf>
		return -E_BAD_ENV;
f01036bd:	83 c4 10             	add    $0x10,%esp
f01036c0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01036c5:	eb bc                	jmp    f0103683 <envid2env+0x3c>
			cprintf("ssssssssssssssssss %d\n", envid);
f01036c7:	83 ec 08             	sub    $0x8,%esp
f01036ca:	56                   	push   %esi
f01036cb:	68 66 96 10 f0       	push   $0xf0109666
f01036d0:	e8 21 0b 00 00       	call   f01041f6 <cprintf>
f01036d5:	83 c4 10             	add    $0x10,%esp
f01036d8:	eb d6                	jmp    f01036b0 <envid2env+0x69>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01036da:	e8 2b 38 00 00       	call   f0106f0a <cpunum>
f01036df:	6b c0 74             	imul   $0x74,%eax,%eax
f01036e2:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f01036e8:	74 8f                	je     f0103679 <envid2env+0x32>
f01036ea:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01036ed:	e8 18 38 00 00       	call   f0106f0a <cpunum>
f01036f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01036f5:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01036fb:	3b 70 48             	cmp    0x48(%eax),%esi
f01036fe:	0f 84 75 ff ff ff    	je     f0103679 <envid2env+0x32>
		*env_store = 0;
f0103704:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		cprintf("33333333333333333333333\n");
f010370d:	83 ec 0c             	sub    $0xc,%esp
f0103710:	68 94 96 10 f0       	push   $0xf0109694
f0103715:	e8 dc 0a 00 00       	call   f01041f6 <cprintf>
		return -E_BAD_ENV;
f010371a:	83 c4 10             	add    $0x10,%esp
f010371d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103722:	e9 5c ff ff ff       	jmp    f0103683 <envid2env+0x3c>

f0103727 <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f0103727:	b8 08 d3 16 f0       	mov    $0xf016d308,%eax
f010372c:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f010372f:	b8 23 00 00 00       	mov    $0x23,%eax
f0103734:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103736:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103738:	b8 10 00 00 00       	mov    $0x10,%eax
f010373d:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f010373f:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103741:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103743:	ea 4a 37 10 f0 08 00 	ljmp   $0x8,$0xf010374a
	asm volatile("lldt %0" : : "r" (sel));
f010374a:	b8 00 00 00 00       	mov    $0x0,%eax
f010374f:	0f 00 d0             	lldt   %ax
}
f0103752:	c3                   	ret    

f0103753 <env_init>:
{
f0103753:	55                   	push   %ebp
f0103754:	89 e5                	mov    %esp,%ebp
f0103756:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f0103759:	8b 15 44 d9 5d f0    	mov    0xf05dd944,%edx
f010375f:	8d 82 84 00 00 00    	lea    0x84(%edx),%eax
f0103765:	81 c2 00 10 02 00    	add    $0x21000,%edx
f010376b:	c7 40 c4 00 00 00 00 	movl   $0x0,-0x3c(%eax)
		envs[i].env_link = &envs[i+1];
f0103772:	89 40 c0             	mov    %eax,-0x40(%eax)
f0103775:	05 84 00 00 00       	add    $0x84,%eax
	for(int i = 0; i < NENV - 1; i++){
f010377a:	39 d0                	cmp    %edx,%eax
f010377c:	75 ed                	jne    f010376b <env_init+0x18>
	env_free_list = envs;
f010377e:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0103783:	a3 48 d9 5d f0       	mov    %eax,0xf05dd948
	env_init_percpu();
f0103788:	e8 9a ff ff ff       	call   f0103727 <env_init_percpu>
}
f010378d:	c9                   	leave  
f010378e:	c3                   	ret    

f010378f <env_alloc>:
{
f010378f:	55                   	push   %ebp
f0103790:	89 e5                	mov    %esp,%ebp
f0103792:	57                   	push   %edi
f0103793:	56                   	push   %esi
f0103794:	53                   	push   %ebx
f0103795:	83 ec 24             	sub    $0x24,%esp
	cprintf("in %s\n", __FUNCTION__);
f0103798:	68 38 98 10 f0       	push   $0xf0109838
f010379d:	68 bc 80 10 f0       	push   $0xf01080bc
f01037a2:	e8 4f 0a 00 00       	call   f01041f6 <cprintf>
	if (!(e = env_free_list))
f01037a7:	8b 1d 48 d9 5d f0    	mov    0xf05dd948,%ebx
f01037ad:	83 c4 10             	add    $0x10,%esp
f01037b0:	85 db                	test   %ebx,%ebx
f01037b2:	0f 84 df 03 00 00    	je     f0103b97 <env_alloc+0x408>
	cprintf("in %s\n", __FUNCTION__);
f01037b8:	83 ec 08             	sub    $0x8,%esp
f01037bb:	68 28 98 10 f0       	push   $0xf0109828
f01037c0:	68 bc 80 10 f0       	push   $0xf01080bc
f01037c5:	e8 2c 0a 00 00       	call   f01041f6 <cprintf>
	cprintf("the e is 0x%x\n", e);
f01037ca:	83 c4 08             	add    $0x8,%esp
f01037cd:	53                   	push   %ebx
f01037ce:	68 ad 96 10 f0       	push   $0xf01096ad
f01037d3:	e8 1e 0a 00 00       	call   f01041f6 <cprintf>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01037d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01037df:	e8 59 db ff ff       	call   f010133d <page_alloc>
f01037e4:	83 c4 10             	add    $0x10,%esp
f01037e7:	85 c0                	test   %eax,%eax
f01037e9:	0f 84 af 03 00 00    	je     f0103b9e <env_alloc+0x40f>
	p->pp_ref++;
f01037ef:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01037f4:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01037fa:	c1 f8 03             	sar    $0x3,%eax
f01037fd:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103800:	89 c2                	mov    %eax,%edx
f0103802:	c1 ea 0c             	shr    $0xc,%edx
f0103805:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f010380b:	0f 83 cd 00 00 00    	jae    f01038de <env_alloc+0x14f>
	return (void *)(pa + KERNBASE);
f0103811:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	e->env_pgdir = (pde_t *)page2kva(p);
f0103817:	89 53 60             	mov    %edx,0x60(%ebx)
	if ((uint32_t)kva < KERNBASE)
f010381a:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0103820:	0f 86 ca 00 00 00    	jbe    f01038f0 <env_alloc+0x161>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103826:	83 c8 05             	or     $0x5,%eax
f0103829:	89 82 f4 0e 00 00    	mov    %eax,0xef4(%edx)
	if (!(kern_p = page_alloc(ALLOC_ZERO)))
f010382f:	83 ec 0c             	sub    $0xc,%esp
f0103832:	6a 01                	push   $0x1
f0103834:	e8 04 db ff ff       	call   f010133d <page_alloc>
f0103839:	83 c4 10             	add    $0x10,%esp
f010383c:	85 c0                	test   %eax,%eax
f010383e:	0f 84 5a 03 00 00    	je     f0103b9e <env_alloc+0x40f>
	kern_p->pp_ref++;
f0103844:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103849:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010384f:	c1 f8 03             	sar    $0x3,%eax
f0103852:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103855:	89 c2                	mov    %eax,%edx
f0103857:	c1 ea 0c             	shr    $0xc,%edx
f010385a:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103860:	0f 83 9f 00 00 00    	jae    f0103905 <env_alloc+0x176>
	return (void *)(pa + KERNBASE);
f0103866:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_kern_pgdir = (pde_t *)page2kva(kern_p);
f010386b:	89 43 64             	mov    %eax,0x64(%ebx)
	memcpy((void *)e->env_kern_pgdir, (void *)kern_pgdir, PGSIZE);
f010386e:	83 ec 04             	sub    $0x4,%esp
f0103871:	68 00 10 00 00       	push   $0x1000
f0103876:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010387c:	50                   	push   %eax
f010387d:	e8 2c 31 00 00       	call   f01069ae <memcpy>
	e->env_kern_pgdir[PDX(UVPT)] = PADDR(e->env_kern_pgdir) | PTE_P | PTE_U;
f0103882:	8b 43 64             	mov    0x64(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103885:	83 c4 10             	add    $0x10,%esp
f0103888:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010388d:	0f 86 84 00 00 00    	jbe    f0103917 <env_alloc+0x188>
	return (physaddr_t)kva - KERNBASE;
f0103893:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103899:	83 ca 05             	or     $0x5,%edx
f010389c:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	cprintf("the __USER_MAP_BEGIN__ is 0x%x and the __USER_MAP_END__ is 0x%x\n", __USER_MAP_BEGIN__, __USER_MAP_END__);
f01038a2:	83 ec 04             	sub    $0x4,%esp
f01038a5:	68 00 c0 16 f0       	push   $0xf016c000
f01038aa:	68 00 10 12 f0       	push   $0xf0121000
f01038af:	68 84 97 10 f0       	push   $0xf0109784
f01038b4:	e8 3d 09 00 00       	call   f01041f6 <cprintf>
	memset(e->env_pgdir + PDX(ULIM), 0, sizeof(pde_t) * (NPDENTRIES - PDX(ULIM)));
f01038b9:	83 c4 0c             	add    $0xc,%esp
f01038bc:	68 08 01 00 00       	push   $0x108
f01038c1:	6a 00                	push   $0x0
f01038c3:	8b 43 60             	mov    0x60(%ebx),%eax
f01038c6:	05 f8 0e 00 00       	add    $0xef8,%eax
f01038cb:	50                   	push   %eax
f01038cc:	e8 33 30 00 00       	call   f0106904 <memset>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f01038d1:	be 00 10 12 f0       	mov    $0xf0121000,%esi
f01038d6:	83 c4 10             	add    $0x10,%esp
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void *)i, &pte_store);
f01038d9:	8d 7d e4             	lea    -0x1c(%ebp),%edi
f01038dc:	eb 5a                	jmp    f0103938 <env_alloc+0x1a9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01038de:	50                   	push   %eax
f01038df:	68 74 80 10 f0       	push   $0xf0108074
f01038e4:	6a 58                	push   $0x58
f01038e6:	68 71 92 10 f0       	push   $0xf0109271
f01038eb:	e8 59 c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038f0:	52                   	push   %edx
f01038f1:	68 98 80 10 f0       	push   $0xf0108098
f01038f6:	68 33 01 00 00       	push   $0x133
f01038fb:	68 14 96 10 f0       	push   $0xf0109614
f0103900:	e8 44 c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103905:	50                   	push   %eax
f0103906:	68 74 80 10 f0       	push   $0xf0108074
f010390b:	6a 58                	push   $0x58
f010390d:	68 71 92 10 f0       	push   $0xf0109271
f0103912:	e8 32 c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103917:	50                   	push   %eax
f0103918:	68 98 80 10 f0       	push   $0xf0108098
f010391d:	68 3d 01 00 00       	push   $0x13d
f0103922:	68 14 96 10 f0       	push   $0xf0109614
f0103927:	e8 1d c7 ff ff       	call   f0100049 <_panic>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f010392c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f0103932:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103938:	81 fe 00 c0 16 f0    	cmp    $0xf016c000,%esi
f010393e:	73 3f                	jae    f010397f <env_alloc+0x1f0>
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void *)i, &pte_store);
f0103940:	83 ec 04             	sub    $0x4,%esp
f0103943:	57                   	push   %edi
f0103944:	56                   	push   %esi
f0103945:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010394b:	e8 49 dc ff ff       	call   f0101599 <page_lookup>
		if(pageInfo == NULL)
f0103950:	83 c4 10             	add    $0x10,%esp
f0103953:	85 c0                	test   %eax,%eax
f0103955:	74 d5                	je     f010392c <env_alloc+0x19d>
		r = page_insert(e->env_pgdir, pageInfo, (void *)i, PTE_P);
f0103957:	6a 01                	push   $0x1
f0103959:	56                   	push   %esi
f010395a:	50                   	push   %eax
f010395b:	ff 73 60             	pushl  0x60(%ebx)
f010395e:	e8 16 dd ff ff       	call   f0101679 <page_insert>
		if(r < 0)
f0103963:	83 c4 10             	add    $0x10,%esp
f0103966:	85 c0                	test   %eax,%eax
f0103968:	79 c2                	jns    f010392c <env_alloc+0x19d>
			panic("test panic error %e\n", r);
f010396a:	50                   	push   %eax
f010396b:	68 bc 96 10 f0       	push   $0xf01096bc
f0103970:	68 e7 00 00 00       	push   $0xe7
f0103975:	68 14 96 10 f0       	push   $0xf0109614
f010397a:	e8 ca c6 ff ff       	call   f0100049 <_panic>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f010397f:	bf 00 00 00 f0       	mov    $0xf0000000,%edi
f0103984:	eb 58                	jmp    f01039de <env_alloc+0x24f>
f0103986:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for(uint32_t stackRange = 0; stackRange < KSTKSIZE; stackRange += PGSIZE){
f010398c:	39 f7                	cmp    %esi,%edi
f010398e:	74 40                	je     f01039d0 <env_alloc+0x241>
			struct PageInfo* pageInfo = page_lookup(kern_pgdir, va, NULL);
f0103990:	83 ec 04             	sub    $0x4,%esp
f0103993:	6a 00                	push   $0x0
f0103995:	56                   	push   %esi
f0103996:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010399c:	e8 f8 db ff ff       	call   f0101599 <page_lookup>
			if(pageInfo == NULL)
f01039a1:	83 c4 10             	add    $0x10,%esp
f01039a4:	85 c0                	test   %eax,%eax
f01039a6:	74 de                	je     f0103986 <env_alloc+0x1f7>
			r = page_insert(e->env_pgdir, pageInfo, va, PTE_P|PTE_W);
f01039a8:	6a 03                	push   $0x3
f01039aa:	56                   	push   %esi
f01039ab:	50                   	push   %eax
f01039ac:	ff 73 60             	pushl  0x60(%ebx)
f01039af:	e8 c5 dc ff ff       	call   f0101679 <page_insert>
			if(r < 0)
f01039b4:	83 c4 10             	add    $0x10,%esp
f01039b7:	85 c0                	test   %eax,%eax
f01039b9:	79 cb                	jns    f0103986 <env_alloc+0x1f7>
				panic("test panic error %e\n", r);
f01039bb:	50                   	push   %eax
f01039bc:	68 bc 96 10 f0       	push   $0xf01096bc
f01039c1:	68 f3 00 00 00       	push   $0xf3
f01039c6:	68 14 96 10 f0       	push   $0xf0109614
f01039cb:	e8 79 c6 ff ff       	call   f0100049 <_panic>
f01039d0:	81 ef 00 00 01 00    	sub    $0x10000,%edi
	for(int i = 0; i < NCPU; i++){
f01039d6:	81 ff 00 00 f8 ef    	cmp    $0xeff80000,%edi
f01039dc:	74 08                	je     f01039e6 <env_alloc+0x257>
f01039de:	8d b7 00 80 ff ff    	lea    -0x8000(%edi),%esi
f01039e4:	eb aa                	jmp    f0103990 <env_alloc+0x201>
	cprintf("set up envs : 0x%x\n", envs);
f01039e6:	83 ec 08             	sub    $0x8,%esp
f01039e9:	ff 35 44 d9 5d f0    	pushl  0xf05dd944
f01039ef:	68 d1 96 10 f0       	push   $0xf01096d1
f01039f4:	e8 fd 07 00 00       	call   f01041f6 <cprintf>
	for(uint32_t i = (uint32_t)envs; i < (uint32_t)(envs+NENV); i+=PGSIZE){
f01039f9:	8b 35 44 d9 5d f0    	mov    0xf05dd944,%esi
f01039ff:	83 c4 10             	add    $0x10,%esp
f0103a02:	eb 16                	jmp    f0103a1a <env_alloc+0x28b>
			cprintf("the page info is null\n");
f0103a04:	83 ec 0c             	sub    $0xc,%esp
f0103a07:	68 e5 96 10 f0       	push   $0xf01096e5
f0103a0c:	e8 e5 07 00 00       	call   f01041f6 <cprintf>
f0103a11:	83 c4 10             	add    $0x10,%esp
	for(uint32_t i = (uint32_t)envs; i < (uint32_t)(envs+NENV); i+=PGSIZE){
f0103a14:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103a1a:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0103a1f:	05 00 10 02 00       	add    $0x21000,%eax
f0103a24:	39 c6                	cmp    %eax,%esi
f0103a26:	73 40                	jae    f0103a68 <env_alloc+0x2d9>
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void*)i, NULL);
f0103a28:	83 ec 04             	sub    $0x4,%esp
f0103a2b:	6a 00                	push   $0x0
f0103a2d:	56                   	push   %esi
f0103a2e:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0103a34:	e8 60 db ff ff       	call   f0101599 <page_lookup>
		if(pageInfo == NULL){
f0103a39:	83 c4 10             	add    $0x10,%esp
f0103a3c:	85 c0                	test   %eax,%eax
f0103a3e:	74 c4                	je     f0103a04 <env_alloc+0x275>
		r = page_insert(e->env_pgdir, pageInfo, (void*)i, PTE_P);
f0103a40:	6a 01                	push   $0x1
f0103a42:	56                   	push   %esi
f0103a43:	50                   	push   %eax
f0103a44:	ff 73 60             	pushl  0x60(%ebx)
f0103a47:	e8 2d dc ff ff       	call   f0101679 <page_insert>
		if(r < 0)
f0103a4c:	83 c4 10             	add    $0x10,%esp
f0103a4f:	85 c0                	test   %eax,%eax
f0103a51:	79 c1                	jns    f0103a14 <env_alloc+0x285>
			panic("test panic error %e\n", r);
f0103a53:	50                   	push   %eax
f0103a54:	68 bc 96 10 f0       	push   $0xf01096bc
f0103a59:	68 01 01 00 00       	push   $0x101
f0103a5e:	68 14 96 10 f0       	push   $0xf0109614
f0103a63:	e8 e1 c5 ff ff       	call   f0100049 <_panic>
	memmove(e->env_kern_pgdir, e->env_pgdir, sizeof(pde_t) * (PDX(ULIM)));
f0103a68:	83 ec 04             	sub    $0x4,%esp
f0103a6b:	68 f8 0e 00 00       	push   $0xef8
f0103a70:	ff 73 60             	pushl  0x60(%ebx)
f0103a73:	ff 73 64             	pushl  0x64(%ebx)
f0103a76:	e8 d1 2e 00 00       	call   f010694c <memmove>
	e->env_kern_pgdir[PDX(UVPT)] = PADDR(e->env_kern_pgdir) | PTE_P | PTE_U;
f0103a7b:	8b 43 64             	mov    0x64(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103a7e:	83 c4 10             	add    $0x10,%esp
f0103a81:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a86:	0f 86 f6 00 00 00    	jbe    f0103b82 <env_alloc+0x3f3>
	return (physaddr_t)kva - KERNBASE;
f0103a8c:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103a92:	83 ca 05             	or     $0x5,%edx
f0103a95:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103a9b:	8b 43 48             	mov    0x48(%ebx),%eax
f0103a9e:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103aa3:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103aa8:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103aad:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103ab0:	89 da                	mov    %ebx,%edx
f0103ab2:	2b 15 44 d9 5d f0    	sub    0xf05dd944,%edx
f0103ab8:	c1 fa 02             	sar    $0x2,%edx
f0103abb:	69 d2 e1 83 0f 3e    	imul   $0x3e0f83e1,%edx,%edx
f0103ac1:	09 d0                	or     %edx,%eax
f0103ac3:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103ac9:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103acc:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103ad3:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103ada:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f0103ae1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
f0103ae8:	00 00 00 
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103aeb:	83 ec 04             	sub    $0x4,%esp
f0103aee:	6a 44                	push   $0x44
f0103af0:	6a 00                	push   $0x0
f0103af2:	53                   	push   %ebx
f0103af3:	e8 0c 2e 00 00       	call   f0106904 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103af8:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103afe:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103b04:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103b0a:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103b11:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103b17:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103b1e:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
	e->env_ipc_recving = 0;
f0103b25:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
	env_free_list = e->env_link;
f0103b29:	8b 43 44             	mov    0x44(%ebx),%eax
f0103b2c:	a3 48 d9 5d f0       	mov    %eax,0xf05dd948
	*newenv_store = e;
f0103b31:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b34:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103b36:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103b39:	e8 cc 33 00 00       	call   f0106f0a <cpunum>
f0103b3e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b41:	83 c4 10             	add    $0x10,%esp
f0103b44:	ba 00 00 00 00       	mov    $0x0,%edx
f0103b49:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0103b50:	74 11                	je     f0103b63 <env_alloc+0x3d4>
f0103b52:	e8 b3 33 00 00       	call   f0106f0a <cpunum>
f0103b57:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b5a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103b60:	8b 50 48             	mov    0x48(%eax),%edx
f0103b63:	83 ec 04             	sub    $0x4,%esp
f0103b66:	53                   	push   %ebx
f0103b67:	52                   	push   %edx
f0103b68:	68 fc 96 10 f0       	push   $0xf01096fc
f0103b6d:	e8 84 06 00 00       	call   f01041f6 <cprintf>
	return 0;
f0103b72:	83 c4 10             	add    $0x10,%esp
f0103b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103b7d:	5b                   	pop    %ebx
f0103b7e:	5e                   	pop    %esi
f0103b7f:	5f                   	pop    %edi
f0103b80:	5d                   	pop    %ebp
f0103b81:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103b82:	50                   	push   %eax
f0103b83:	68 98 80 10 f0       	push   $0xf0108098
f0103b88:	68 42 01 00 00       	push   $0x142
f0103b8d:	68 14 96 10 f0       	push   $0xf0109614
f0103b92:	e8 b2 c4 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f0103b97:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103b9c:	eb dc                	jmp    f0103b7a <env_alloc+0x3eb>
	return 0;
f0103b9e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103ba3:	eb d5                	jmp    f0103b7a <env_alloc+0x3eb>

f0103ba5 <env_create>:
{
f0103ba5:	55                   	push   %ebp
f0103ba6:	89 e5                	mov    %esp,%ebp
f0103ba8:	57                   	push   %edi
f0103ba9:	56                   	push   %esi
f0103baa:	53                   	push   %ebx
f0103bab:	83 ec 54             	sub    $0x54,%esp
f0103bae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0103bb1:	68 1c 98 10 f0       	push   $0xf010981c
f0103bb6:	68 bc 80 10 f0       	push   $0xf01080bc
f0103bbb:	e8 36 06 00 00       	call   f01041f6 <cprintf>
	int ret = env_alloc(&e, 0);
f0103bc0:	83 c4 08             	add    $0x8,%esp
f0103bc3:	6a 00                	push   $0x0
f0103bc5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103bc8:	50                   	push   %eax
f0103bc9:	e8 c1 fb ff ff       	call   f010378f <env_alloc>
f0103bce:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if(ret)
f0103bd1:	83 c4 10             	add    $0x10,%esp
f0103bd4:	85 c0                	test   %eax,%eax
f0103bd6:	75 40                	jne    f0103c18 <env_create+0x73>
	e->env_parent_id = 0;
f0103bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103bdb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103bde:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
	e->env_type = type;
f0103be5:	89 58 50             	mov    %ebx,0x50(%eax)
	if(type == ENV_TYPE_FS){
f0103be8:	83 fb 01             	cmp    $0x1,%ebx
f0103beb:	74 42                	je     f0103c2f <env_create+0x8a>
	if (elf->e_magic != ELF_MAGIC)
f0103bed:	8b 45 08             	mov    0x8(%ebp),%eax
f0103bf0:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f0103bf6:	75 40                	jne    f0103c38 <env_create+0x93>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103bf8:	8b 45 08             	mov    0x8(%ebp),%eax
f0103bfb:	89 c7                	mov    %eax,%edi
f0103bfd:	03 78 1c             	add    0x1c(%eax),%edi
	eph = ph + elf->e_phnum;
f0103c00:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103c04:	c1 e0 05             	shl    $0x5,%eax
f0103c07:	01 f8                	add    %edi,%eax
f0103c09:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	uint32_t elf_load_sz = 0;
f0103c0c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
f0103c13:	e9 69 01 00 00       	jmp    f0103d81 <env_create+0x1dc>
		panic("env_alloc failed\n");
f0103c18:	83 ec 04             	sub    $0x4,%esp
f0103c1b:	68 11 97 10 f0       	push   $0xf0109711
f0103c20:	68 05 02 00 00       	push   $0x205
f0103c25:	68 14 96 10 f0       	push   $0xf0109614
f0103c2a:	e8 1a c4 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103c2f:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f0103c36:	eb b5                	jmp    f0103bed <env_create+0x48>
		panic("is this a valid ELF");
f0103c38:	83 ec 04             	sub    $0x4,%esp
f0103c3b:	68 23 97 10 f0       	push   $0xf0109723
f0103c40:	68 db 01 00 00       	push   $0x1db
f0103c45:	68 14 96 10 f0       	push   $0xf0109614
f0103c4a:	e8 fa c3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103c4f:	50                   	push   %eax
f0103c50:	68 74 80 10 f0       	push   $0xf0108074
f0103c55:	6a 58                	push   $0x58
f0103c57:	68 71 92 10 f0       	push   $0xf0109271
f0103c5c:	e8 e8 c3 ff ff       	call   f0100049 <_panic>
		addr += size;
f0103c61:	01 75 c8             	add    %esi,-0x38(%ebp)
		len -= size;
f0103c64:	29 f3                	sub    %esi,%ebx
		off = 0;
f0103c66:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0103c69:	89 45 d0             	mov    %eax,-0x30(%ebp)
	while(len > 0){
f0103c6c:	85 db                	test   %ebx,%ebx
f0103c6e:	74 5c                	je     f0103ccc <env_create+0x127>
		int size = len > PGSIZE?PGSIZE - off:len;
f0103c70:	be 00 10 00 00       	mov    $0x1000,%esi
f0103c75:	2b 75 d0             	sub    -0x30(%ebp),%esi
f0103c78:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
f0103c7e:	0f 46 f3             	cmovbe %ebx,%esi
		struct PageInfo* page = page_lookup(pgdir, (void *)addr, NULL);
f0103c81:	83 ec 04             	sub    $0x4,%esp
f0103c84:	6a 00                	push   $0x0
f0103c86:	ff 75 c8             	pushl  -0x38(%ebp)
f0103c89:	ff 75 c4             	pushl  -0x3c(%ebp)
f0103c8c:	e8 08 d9 ff ff       	call   f0101599 <page_lookup>
		if(page)
f0103c91:	83 c4 10             	add    $0x10,%esp
f0103c94:	85 c0                	test   %eax,%eax
f0103c96:	74 c9                	je     f0103c61 <env_create+0xbc>
	return (pp - pages) << PGSHIFT;
f0103c98:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103c9e:	c1 f8 03             	sar    $0x3,%eax
f0103ca1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103ca4:	89 c2                	mov    %eax,%edx
f0103ca6:	c1 ea 0c             	shr    $0xc,%edx
f0103ca9:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103caf:	73 9e                	jae    f0103c4f <env_create+0xaa>
			memset(page2kva(page)+off, c, size);
f0103cb1:	83 ec 04             	sub    $0x4,%esp
f0103cb4:	56                   	push   %esi
f0103cb5:	6a 00                	push   $0x0
f0103cb7:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0103cba:	8d 84 02 00 00 00 f0 	lea    -0x10000000(%edx,%eax,1),%eax
f0103cc1:	50                   	push   %eax
f0103cc2:	e8 3d 2c 00 00       	call   f0106904 <memset>
f0103cc7:	83 c4 10             	add    $0x10,%esp
f0103cca:	eb 95                	jmp    f0103c61 <env_create+0xbc>
			user_memmove(e->env_pgdir,(void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f0103ccc:	8b 77 10             	mov    0x10(%edi),%esi
f0103ccf:	8b 47 08             	mov    0x8(%edi),%eax
f0103cd2:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103cd5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103cd8:	8b 51 60             	mov    0x60(%ecx),%edx
f0103cdb:	89 55 bc             	mov    %edx,-0x44(%ebp)
f0103cde:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103ce1:	03 4f 04             	add    0x4(%edi),%ecx
f0103ce4:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	int off = addr - ROUNDDOWN(addr, PGSIZE);
f0103ce7:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103cec:	89 45 d0             	mov    %eax,-0x30(%ebp)
		off = 0;
f0103cef:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103cf2:	89 45 b8             	mov    %eax,-0x48(%ebp)
f0103cf5:	eb 20                	jmp    f0103d17 <env_create+0x172>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103cf7:	50                   	push   %eax
f0103cf8:	68 74 80 10 f0       	push   $0xf0108074
f0103cfd:	6a 58                	push   $0x58
f0103cff:	68 71 92 10 f0       	push   $0xf0109271
f0103d04:	e8 40 c3 ff ff       	call   f0100049 <_panic>
		addr += size;
f0103d09:	01 5d c8             	add    %ebx,-0x38(%ebp)
		cur_src += size;
f0103d0c:	01 5d c4             	add    %ebx,-0x3c(%ebp)
		len -= size;
f0103d0f:	29 de                	sub    %ebx,%esi
		off = 0;
f0103d11:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0103d14:	89 45 d0             	mov    %eax,-0x30(%ebp)
	while(len > 0){
f0103d17:	85 f6                	test   %esi,%esi
f0103d19:	74 5d                	je     f0103d78 <env_create+0x1d3>
		int size = len > PGSIZE?PGSIZE - off:len;
f0103d1b:	bb 00 10 00 00       	mov    $0x1000,%ebx
f0103d20:	2b 5d d0             	sub    -0x30(%ebp),%ebx
f0103d23:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
f0103d29:	0f 46 de             	cmovbe %esi,%ebx
		struct PageInfo* page = page_lookup(pgdir, (void *)addr, NULL);
f0103d2c:	83 ec 04             	sub    $0x4,%esp
f0103d2f:	6a 00                	push   $0x0
f0103d31:	ff 75 c8             	pushl  -0x38(%ebp)
f0103d34:	ff 75 bc             	pushl  -0x44(%ebp)
f0103d37:	e8 5d d8 ff ff       	call   f0101599 <page_lookup>
		if(page)
f0103d3c:	83 c4 10             	add    $0x10,%esp
f0103d3f:	85 c0                	test   %eax,%eax
f0103d41:	74 c6                	je     f0103d09 <env_create+0x164>
	return (pp - pages) << PGSHIFT;
f0103d43:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103d49:	c1 f8 03             	sar    $0x3,%eax
f0103d4c:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103d4f:	89 c2                	mov    %eax,%edx
f0103d51:	c1 ea 0c             	shr    $0xc,%edx
f0103d54:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103d5a:	73 9b                	jae    f0103cf7 <env_create+0x152>
			memmove(page2kva(page)+off, (void *)cur_src, size);
f0103d5c:	83 ec 04             	sub    $0x4,%esp
f0103d5f:	53                   	push   %ebx
f0103d60:	ff 75 c4             	pushl  -0x3c(%ebp)
f0103d63:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0103d66:	8d 84 01 00 00 00 f0 	lea    -0x10000000(%ecx,%eax,1),%eax
f0103d6d:	50                   	push   %eax
f0103d6e:	e8 d9 2b 00 00       	call   f010694c <memmove>
f0103d73:	83 c4 10             	add    $0x10,%esp
f0103d76:	eb 91                	jmp    f0103d09 <env_create+0x164>
			elf_load_sz += ph->p_memsz;
f0103d78:	8b 57 14             	mov    0x14(%edi),%edx
f0103d7b:	01 55 c0             	add    %edx,-0x40(%ebp)
	for (; ph < eph; ph++){
f0103d7e:	83 c7 20             	add    $0x20,%edi
f0103d81:	39 7d b4             	cmp    %edi,-0x4c(%ebp)
f0103d84:	76 37                	jbe    f0103dbd <env_create+0x218>
		if(ph->p_type == ELF_PROG_LOAD){
f0103d86:	83 3f 01             	cmpl   $0x1,(%edi)
f0103d89:	75 f3                	jne    f0103d7e <env_create+0x1d9>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f0103d8b:	8b 4f 14             	mov    0x14(%edi),%ecx
f0103d8e:	8b 57 08             	mov    0x8(%edi),%edx
f0103d91:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0103d94:	89 f0                	mov    %esi,%eax
f0103d96:	e8 26 f8 ff ff       	call   f01035c1 <region_alloc>
			user_memset(e->env_pgdir, (void *)ph->p_va, 0, ph->p_memsz);
f0103d9b:	8b 5f 14             	mov    0x14(%edi),%ebx
f0103d9e:	8b 47 08             	mov    0x8(%edi),%eax
f0103da1:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103da4:	8b 4e 60             	mov    0x60(%esi),%ecx
f0103da7:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	int off = addr - ROUNDDOWN(addr, PGSIZE);
f0103daa:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103daf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		off = 0;
f0103db2:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103db5:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0103db8:	e9 af fe ff ff       	jmp    f0103c6c <env_create+0xc7>
	e->env_tf.tf_eip = elf->e_entry;
f0103dbd:	8b 45 08             	mov    0x8(%ebp),%eax
f0103dc0:	8b 40 18             	mov    0x18(%eax),%eax
f0103dc3:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0103dc6:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f0103dc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103dcc:	05 00 00 80 00       	add    $0x800000,%eax
f0103dd1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f0103dd7:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103ddc:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103de1:	89 f0                	mov    %esi,%eax
f0103de3:	e8 d9 f7 ff ff       	call   f01035c1 <region_alloc>
}
f0103de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103deb:	5b                   	pop    %ebx
f0103dec:	5e                   	pop    %esi
f0103ded:	5f                   	pop    %edi
f0103dee:	5d                   	pop    %ebp
f0103def:	c3                   	ret    

f0103df0 <env_free>:
{
f0103df0:	55                   	push   %ebp
f0103df1:	89 e5                	mov    %esp,%ebp
f0103df3:	57                   	push   %edi
f0103df4:	56                   	push   %esi
f0103df5:	53                   	push   %ebx
f0103df6:	83 ec 1c             	sub    $0x1c,%esp
f0103df9:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (e == curenv)
f0103dfc:	e8 09 31 00 00       	call   f0106f0a <cpunum>
f0103e01:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e04:	39 b8 28 b0 16 f0    	cmp    %edi,-0xfe94fd8(%eax)
f0103e0a:	74 48                	je     f0103e54 <env_free+0x64>
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103e0c:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103e0f:	e8 f6 30 00 00       	call   f0106f0a <cpunum>
f0103e14:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e17:	ba 00 00 00 00       	mov    $0x0,%edx
f0103e1c:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0103e23:	74 11                	je     f0103e36 <env_free+0x46>
f0103e25:	e8 e0 30 00 00       	call   f0106f0a <cpunum>
f0103e2a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e2d:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103e33:	8b 50 48             	mov    0x48(%eax),%edx
f0103e36:	83 ec 04             	sub    $0x4,%esp
f0103e39:	53                   	push   %ebx
f0103e3a:	52                   	push   %edx
f0103e3b:	68 37 97 10 f0       	push   $0xf0109737
f0103e40:	e8 b1 03 00 00       	call   f01041f6 <cprintf>
f0103e45:	83 c4 10             	add    $0x10,%esp
f0103e48:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103e4f:	e9 b3 00 00 00       	jmp    f0103f07 <env_free+0x117>
		lcr3(PADDR(kern_pgdir));
f0103e54:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103e59:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103e5e:	76 0a                	jbe    f0103e6a <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f0103e60:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103e65:	0f 22 d8             	mov    %eax,%cr3
f0103e68:	eb a2                	jmp    f0103e0c <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e6a:	50                   	push   %eax
f0103e6b:	68 98 80 10 f0       	push   $0xf0108098
f0103e70:	68 1c 02 00 00       	push   $0x21c
f0103e75:	68 14 96 10 f0       	push   $0xf0109614
f0103e7a:	e8 ca c1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103e7f:	56                   	push   %esi
f0103e80:	68 74 80 10 f0       	push   $0xf0108074
f0103e85:	68 2b 02 00 00       	push   $0x22b
f0103e8a:	68 14 96 10 f0       	push   $0xf0109614
f0103e8f:	e8 b5 c1 ff ff       	call   f0100049 <_panic>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103e94:	83 ec 08             	sub    $0x8,%esp
f0103e97:	89 d8                	mov    %ebx,%eax
f0103e99:	c1 e0 0c             	shl    $0xc,%eax
f0103e9c:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103e9f:	50                   	push   %eax
f0103ea0:	ff 77 60             	pushl  0x60(%edi)
f0103ea3:	e8 8b d7 ff ff       	call   f0101633 <page_remove>
f0103ea8:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103eab:	83 c3 01             	add    $0x1,%ebx
f0103eae:	83 c6 04             	add    $0x4,%esi
f0103eb1:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103eb7:	74 07                	je     f0103ec0 <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f0103eb9:	f6 06 01             	testb  $0x1,(%esi)
f0103ebc:	74 ed                	je     f0103eab <env_free+0xbb>
f0103ebe:	eb d4                	jmp    f0103e94 <env_free+0xa4>
		e->env_pgdir[pdeno] = 0;
f0103ec0:	8b 47 60             	mov    0x60(%edi),%eax
f0103ec3:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103ec6:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
		e->env_kern_pgdir[pdeno] = 0;
f0103ecd:	8b 47 64             	mov    0x64(%edi),%eax
f0103ed0:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103eda:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0103ee0:	73 69                	jae    f0103f4b <env_free+0x15b>
		page_decref(pa2page(pa));
f0103ee2:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103ee5:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f0103eea:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103eed:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103ef0:	50                   	push   %eax
f0103ef1:	e8 f4 d4 ff ff       	call   f01013ea <page_decref>
f0103ef6:	83 c4 10             	add    $0x10,%esp
f0103ef9:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103efd:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103f00:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103f05:	74 58                	je     f0103f5f <env_free+0x16f>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103f07:	8b 47 60             	mov    0x60(%edi),%eax
f0103f0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103f0d:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103f10:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103f16:	74 e1                	je     f0103ef9 <env_free+0x109>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103f18:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103f1e:	89 f0                	mov    %esi,%eax
f0103f20:	c1 e8 0c             	shr    $0xc,%eax
f0103f23:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103f26:	39 05 88 ed 5d f0    	cmp    %eax,0xf05ded88
f0103f2c:	0f 86 4d ff ff ff    	jbe    f0103e7f <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0103f32:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103f3b:	c1 e0 14             	shl    $0x14,%eax
f0103f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103f41:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103f46:	e9 6e ff ff ff       	jmp    f0103eb9 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f0103f4b:	83 ec 04             	sub    $0x4,%esp
f0103f4e:	68 b0 89 10 f0       	push   $0xf01089b0
f0103f53:	6a 51                	push   $0x51
f0103f55:	68 71 92 10 f0       	push   $0xf0109271
f0103f5a:	e8 ea c0 ff ff       	call   f0100049 <_panic>
	pa = PADDR(e->env_pgdir);
f0103f5f:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103f62:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103f67:	76 5c                	jbe    f0103fc5 <env_free+0x1d5>
	e->env_pgdir = 0;
f0103f69:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	e->env_kern_pgdir = 0;
f0103f70:	c7 47 64 00 00 00 00 	movl   $0x0,0x64(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103f77:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103f7c:	c1 e8 0c             	shr    $0xc,%eax
f0103f7f:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0103f85:	73 53                	jae    f0103fda <env_free+0x1ea>
	page_decref(pa2page(pa));
f0103f87:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103f8a:	8b 15 90 ed 5d f0    	mov    0xf05ded90,%edx
f0103f90:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103f93:	50                   	push   %eax
f0103f94:	e8 51 d4 ff ff       	call   f01013ea <page_decref>
	cprintf("in env_free we set the ENV_FREE\n");
f0103f99:	c7 04 24 c8 97 10 f0 	movl   $0xf01097c8,(%esp)
f0103fa0:	e8 51 02 00 00       	call   f01041f6 <cprintf>
	e->env_status = ENV_FREE;
f0103fa5:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103fac:	a1 48 d9 5d f0       	mov    0xf05dd948,%eax
f0103fb1:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103fb4:	89 3d 48 d9 5d f0    	mov    %edi,0xf05dd948
}
f0103fba:	83 c4 10             	add    $0x10,%esp
f0103fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103fc0:	5b                   	pop    %ebx
f0103fc1:	5e                   	pop    %esi
f0103fc2:	5f                   	pop    %edi
f0103fc3:	5d                   	pop    %ebp
f0103fc4:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103fc5:	50                   	push   %eax
f0103fc6:	68 98 80 10 f0       	push   $0xf0108098
f0103fcb:	68 3a 02 00 00       	push   $0x23a
f0103fd0:	68 14 96 10 f0       	push   $0xf0109614
f0103fd5:	e8 6f c0 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0103fda:	83 ec 04             	sub    $0x4,%esp
f0103fdd:	68 b0 89 10 f0       	push   $0xf01089b0
f0103fe2:	6a 51                	push   $0x51
f0103fe4:	68 71 92 10 f0       	push   $0xf0109271
f0103fe9:	e8 5b c0 ff ff       	call   f0100049 <_panic>

f0103fee <env_destroy>:
{
f0103fee:	55                   	push   %ebp
f0103fef:	89 e5                	mov    %esp,%ebp
f0103ff1:	53                   	push   %ebx
f0103ff2:	83 ec 04             	sub    $0x4,%esp
f0103ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103ff8:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103ffc:	74 21                	je     f010401f <env_destroy+0x31>
	env_free(e);
f0103ffe:	83 ec 0c             	sub    $0xc,%esp
f0104001:	53                   	push   %ebx
f0104002:	e8 e9 fd ff ff       	call   f0103df0 <env_free>
	if (curenv == e) {
f0104007:	e8 fe 2e 00 00       	call   f0106f0a <cpunum>
f010400c:	6b c0 74             	imul   $0x74,%eax,%eax
f010400f:	83 c4 10             	add    $0x10,%esp
f0104012:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f0104018:	74 1e                	je     f0104038 <env_destroy+0x4a>
}
f010401a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010401d:	c9                   	leave  
f010401e:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010401f:	e8 e6 2e 00 00       	call   f0106f0a <cpunum>
f0104024:	6b c0 74             	imul   $0x74,%eax,%eax
f0104027:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f010402d:	74 cf                	je     f0103ffe <env_destroy+0x10>
		e->env_status = ENV_DYING;
f010402f:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0104036:	eb e2                	jmp    f010401a <env_destroy+0x2c>
		curenv = NULL;
f0104038:	e8 cd 2e 00 00       	call   f0106f0a <cpunum>
f010403d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104040:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f0104047:	00 00 00 
		sched_yield();
f010404a:	e8 5f 10 00 00       	call   f01050ae <sched_yield>

f010404f <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010404f:	55                   	push   %ebp
f0104050:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104052:	8b 45 08             	mov    0x8(%ebp),%eax
f0104055:	ba 70 00 00 00       	mov    $0x70,%edx
f010405a:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010405b:	ba 71 00 00 00       	mov    $0x71,%edx
f0104060:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0104061:	0f b6 c0             	movzbl %al,%eax
}
f0104064:	5d                   	pop    %ebp
f0104065:	c3                   	ret    

f0104066 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0104066:	55                   	push   %ebp
f0104067:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104069:	8b 45 08             	mov    0x8(%ebp),%eax
f010406c:	ba 70 00 00 00       	mov    $0x70,%edx
f0104071:	ee                   	out    %al,(%dx)
f0104072:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104075:	ba 71 00 00 00       	mov    $0x71,%edx
f010407a:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f010407b:	5d                   	pop    %ebp
f010407c:	c3                   	ret    

f010407d <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f010407d:	55                   	push   %ebp
f010407e:	89 e5                	mov    %esp,%ebp
f0104080:	56                   	push   %esi
f0104081:	53                   	push   %ebx
f0104082:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0104085:	66 a3 0e d3 16 f0    	mov    %ax,0xf016d30e
	if (!didinit)
f010408b:	80 3d 4c d9 5d f0 00 	cmpb   $0x0,0xf05dd94c
f0104092:	75 07                	jne    f010409b <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0104094:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104097:	5b                   	pop    %ebx
f0104098:	5e                   	pop    %esi
f0104099:	5d                   	pop    %ebp
f010409a:	c3                   	ret    
f010409b:	89 c6                	mov    %eax,%esi
f010409d:	ba 21 00 00 00       	mov    $0x21,%edx
f01040a2:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01040a3:	66 c1 e8 08          	shr    $0x8,%ax
f01040a7:	ba a1 00 00 00       	mov    $0xa1,%edx
f01040ac:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01040ad:	83 ec 0c             	sub    $0xc,%esp
f01040b0:	68 42 98 10 f0       	push   $0xf0109842
f01040b5:	e8 3c 01 00 00       	call   f01041f6 <cprintf>
f01040ba:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01040bd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01040c2:	0f b7 f6             	movzwl %si,%esi
f01040c5:	f7 d6                	not    %esi
f01040c7:	eb 19                	jmp    f01040e2 <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f01040c9:	83 ec 08             	sub    $0x8,%esp
f01040cc:	53                   	push   %ebx
f01040cd:	68 df 9f 10 f0       	push   $0xf0109fdf
f01040d2:	e8 1f 01 00 00       	call   f01041f6 <cprintf>
f01040d7:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01040da:	83 c3 01             	add    $0x1,%ebx
f01040dd:	83 fb 10             	cmp    $0x10,%ebx
f01040e0:	74 07                	je     f01040e9 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f01040e2:	0f a3 de             	bt     %ebx,%esi
f01040e5:	73 f3                	jae    f01040da <irq_setmask_8259A+0x5d>
f01040e7:	eb e0                	jmp    f01040c9 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f01040e9:	83 ec 0c             	sub    $0xc,%esp
f01040ec:	68 7b 95 10 f0       	push   $0xf010957b
f01040f1:	e8 00 01 00 00       	call   f01041f6 <cprintf>
f01040f6:	83 c4 10             	add    $0x10,%esp
f01040f9:	eb 99                	jmp    f0104094 <irq_setmask_8259A+0x17>

f01040fb <pic_init>:
{
f01040fb:	55                   	push   %ebp
f01040fc:	89 e5                	mov    %esp,%ebp
f01040fe:	57                   	push   %edi
f01040ff:	56                   	push   %esi
f0104100:	53                   	push   %ebx
f0104101:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0104104:	c6 05 4c d9 5d f0 01 	movb   $0x1,0xf05dd94c
f010410b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104110:	bb 21 00 00 00       	mov    $0x21,%ebx
f0104115:	89 da                	mov    %ebx,%edx
f0104117:	ee                   	out    %al,(%dx)
f0104118:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010411d:	89 ca                	mov    %ecx,%edx
f010411f:	ee                   	out    %al,(%dx)
f0104120:	bf 11 00 00 00       	mov    $0x11,%edi
f0104125:	be 20 00 00 00       	mov    $0x20,%esi
f010412a:	89 f8                	mov    %edi,%eax
f010412c:	89 f2                	mov    %esi,%edx
f010412e:	ee                   	out    %al,(%dx)
f010412f:	b8 20 00 00 00       	mov    $0x20,%eax
f0104134:	89 da                	mov    %ebx,%edx
f0104136:	ee                   	out    %al,(%dx)
f0104137:	b8 04 00 00 00       	mov    $0x4,%eax
f010413c:	ee                   	out    %al,(%dx)
f010413d:	b8 03 00 00 00       	mov    $0x3,%eax
f0104142:	ee                   	out    %al,(%dx)
f0104143:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0104148:	89 f8                	mov    %edi,%eax
f010414a:	89 da                	mov    %ebx,%edx
f010414c:	ee                   	out    %al,(%dx)
f010414d:	b8 28 00 00 00       	mov    $0x28,%eax
f0104152:	89 ca                	mov    %ecx,%edx
f0104154:	ee                   	out    %al,(%dx)
f0104155:	b8 02 00 00 00       	mov    $0x2,%eax
f010415a:	ee                   	out    %al,(%dx)
f010415b:	b8 01 00 00 00       	mov    $0x1,%eax
f0104160:	ee                   	out    %al,(%dx)
f0104161:	bf 68 00 00 00       	mov    $0x68,%edi
f0104166:	89 f8                	mov    %edi,%eax
f0104168:	89 f2                	mov    %esi,%edx
f010416a:	ee                   	out    %al,(%dx)
f010416b:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0104170:	89 c8                	mov    %ecx,%eax
f0104172:	ee                   	out    %al,(%dx)
f0104173:	89 f8                	mov    %edi,%eax
f0104175:	89 da                	mov    %ebx,%edx
f0104177:	ee                   	out    %al,(%dx)
f0104178:	89 c8                	mov    %ecx,%eax
f010417a:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f010417b:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f0104182:	66 83 f8 ff          	cmp    $0xffff,%ax
f0104186:	75 08                	jne    f0104190 <pic_init+0x95>
}
f0104188:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010418b:	5b                   	pop    %ebx
f010418c:	5e                   	pop    %esi
f010418d:	5f                   	pop    %edi
f010418e:	5d                   	pop    %ebp
f010418f:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0104190:	83 ec 0c             	sub    $0xc,%esp
f0104193:	0f b7 c0             	movzwl %ax,%eax
f0104196:	50                   	push   %eax
f0104197:	e8 e1 fe ff ff       	call   f010407d <irq_setmask_8259A>
f010419c:	83 c4 10             	add    $0x10,%esp
}
f010419f:	eb e7                	jmp    f0104188 <pic_init+0x8d>

f01041a1 <irq_eoi>:
f01041a1:	b8 20 00 00 00       	mov    $0x20,%eax
f01041a6:	ba 20 00 00 00       	mov    $0x20,%edx
f01041ab:	ee                   	out    %al,(%dx)
f01041ac:	ba a0 00 00 00       	mov    $0xa0,%edx
f01041b1:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01041b2:	c3                   	ret    

f01041b3 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01041b3:	55                   	push   %ebp
f01041b4:	89 e5                	mov    %esp,%ebp
f01041b6:	53                   	push   %ebx
f01041b7:	83 ec 10             	sub    $0x10,%esp
f01041ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f01041bd:	ff 75 08             	pushl  0x8(%ebp)
f01041c0:	e8 6d c6 ff ff       	call   f0100832 <cputchar>
	(*cnt)++;
f01041c5:	83 03 01             	addl   $0x1,(%ebx)
}
f01041c8:	83 c4 10             	add    $0x10,%esp
f01041cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01041ce:	c9                   	leave  
f01041cf:	c3                   	ret    

f01041d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01041d0:	55                   	push   %ebp
f01041d1:	89 e5                	mov    %esp,%ebp
f01041d3:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01041d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01041dd:	ff 75 0c             	pushl  0xc(%ebp)
f01041e0:	ff 75 08             	pushl  0x8(%ebp)
f01041e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01041e6:	50                   	push   %eax
f01041e7:	68 b3 41 10 f0       	push   $0xf01041b3
f01041ec:	e8 ad 1e 00 00       	call   f010609e <vprintfmt>
	return cnt;
}
f01041f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01041f4:	c9                   	leave  
f01041f5:	c3                   	ret    

f01041f6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01041f6:	55                   	push   %ebp
f01041f7:	89 e5                	mov    %esp,%ebp
f01041f9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01041fc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01041ff:	50                   	push   %eax
f0104200:	ff 75 08             	pushl  0x8(%ebp)
f0104203:	e8 c8 ff ff ff       	call   f01041d0 <vcprintf>
	va_end(ap);
	return cnt;
}
f0104208:	c9                   	leave  
f0104209:	c3                   	ret    

f010420a <trap_init_percpu>:

// Initialize and load the per-CPU TSS and IDT
//mapped text lab7
 void
trap_init_percpu(void)
{
f010420a:	55                   	push   %ebp
f010420b:	89 e5                	mov    %esp,%ebp
f010420d:	57                   	push   %edi
f010420e:	56                   	push   %esi
f010420f:	53                   	push   %ebx
f0104210:	83 ec 24             	sub    $0x24,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	cprintf("in %s\n", __FUNCTION__);
f0104213:	68 20 9e 10 f0       	push   $0xf0109e20
f0104218:	68 bc 80 10 f0       	push   $0xf01080bc
f010421d:	e8 d4 ff ff ff       	call   f01041f6 <cprintf>
	int i = cpunum();
f0104222:	e8 e3 2c 00 00       	call   f0106f0a <cpunum>
f0104227:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0104229:	e8 dc 2c 00 00       	call   f0106f0a <cpunum>
f010422e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104231:	89 d9                	mov    %ebx,%ecx
f0104233:	c1 e1 10             	shl    $0x10,%ecx
f0104236:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f010423b:	29 ca                	sub    %ecx,%edx
f010423d:	89 90 30 b0 16 f0    	mov    %edx,-0xfe94fd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f0104243:	e8 c2 2c 00 00       	call   f0106f0a <cpunum>
f0104248:	6b c0 74             	imul   $0x74,%eax,%eax
f010424b:	66 c7 80 34 b0 16 f0 	movw   $0x10,-0xfe94fcc(%eax)
f0104252:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f0104254:	e8 b1 2c 00 00       	call   f0106f0a <cpunum>
f0104259:	6b c0 74             	imul   $0x74,%eax,%eax
f010425c:	66 c7 80 92 b0 16 f0 	movw   $0x68,-0xfe94f6e(%eax)
f0104263:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0104265:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f010426c:	89 fb                	mov    %edi,%ebx
f010426e:	c1 fb 03             	sar    $0x3,%ebx
f0104271:	e8 94 2c 00 00       	call   f0106f0a <cpunum>
f0104276:	89 c6                	mov    %eax,%esi
f0104278:	e8 8d 2c 00 00       	call   f0106f0a <cpunum>
f010427d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104280:	e8 85 2c 00 00       	call   f0106f0a <cpunum>
f0104285:	66 c7 04 dd 00 a0 12 	movw   $0x67,-0xfed6000(,%ebx,8)
f010428c:	f0 67 00 
f010428f:	6b f6 74             	imul   $0x74,%esi,%esi
f0104292:	81 c6 2c b0 16 f0    	add    $0xf016b02c,%esi
f0104298:	66 89 34 dd 02 a0 12 	mov    %si,-0xfed5ffe(,%ebx,8)
f010429f:	f0 
f01042a0:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f01042a4:	81 c2 2c b0 16 f0    	add    $0xf016b02c,%edx
f01042aa:	c1 ea 10             	shr    $0x10,%edx
f01042ad:	88 14 dd 04 a0 12 f0 	mov    %dl,-0xfed5ffc(,%ebx,8)
f01042b4:	c6 04 dd 06 a0 12 f0 	movb   $0x40,-0xfed5ffa(,%ebx,8)
f01042bb:	40 
f01042bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01042bf:	05 2c b0 16 f0       	add    $0xf016b02c,%eax
f01042c4:	c1 e8 18             	shr    $0x18,%eax
f01042c7:	88 04 dd 07 a0 12 f0 	mov    %al,-0xfed5ff9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f01042ce:	c6 04 dd 05 a0 12 f0 	movb   $0x89,-0xfed5ffb(,%ebx,8)
f01042d5:	89 
	asm volatile("ltr %0" : : "r" (sel));
f01042d6:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f01042d9:	b8 10 d3 16 f0       	mov    $0xf016d310,%eax
f01042de:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f01042e1:	83 c4 10             	add    $0x10,%esp
f01042e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01042e7:	5b                   	pop    %ebx
f01042e8:	5e                   	pop    %esi
f01042e9:	5f                   	pop    %edi
f01042ea:	5d                   	pop    %ebp
f01042eb:	c3                   	ret    

f01042ec <trap_init>:
{
f01042ec:	55                   	push   %ebp
f01042ed:	89 e5                	mov    %esp,%ebp
f01042ef:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f01042f2:	b8 38 13 12 f0       	mov    $0xf0121338,%eax
f01042f7:	66 a3 80 a0 12 f0    	mov    %ax,0xf012a080
f01042fd:	66 c7 05 82 a0 12 f0 	movw   $0x8,0xf012a082
f0104304:	08 00 
f0104306:	c6 05 84 a0 12 f0 00 	movb   $0x0,0xf012a084
f010430d:	c6 05 85 a0 12 f0 8e 	movb   $0x8e,0xf012a085
f0104314:	c1 e8 10             	shr    $0x10,%eax
f0104317:	66 a3 86 a0 12 f0    	mov    %ax,0xf012a086
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f010431d:	b8 42 13 12 f0       	mov    $0xf0121342,%eax
f0104322:	66 a3 88 a0 12 f0    	mov    %ax,0xf012a088
f0104328:	66 c7 05 8a a0 12 f0 	movw   $0x8,0xf012a08a
f010432f:	08 00 
f0104331:	c6 05 8c a0 12 f0 00 	movb   $0x0,0xf012a08c
f0104338:	c6 05 8d a0 12 f0 8e 	movb   $0x8e,0xf012a08d
f010433f:	c1 e8 10             	shr    $0x10,%eax
f0104342:	66 a3 8e a0 12 f0    	mov    %ax,0xf012a08e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0104348:	b8 4c 13 12 f0       	mov    $0xf012134c,%eax
f010434d:	66 a3 90 a0 12 f0    	mov    %ax,0xf012a090
f0104353:	66 c7 05 92 a0 12 f0 	movw   $0x8,0xf012a092
f010435a:	08 00 
f010435c:	c6 05 94 a0 12 f0 00 	movb   $0x0,0xf012a094
f0104363:	c6 05 95 a0 12 f0 8e 	movb   $0x8e,0xf012a095
f010436a:	c1 e8 10             	shr    $0x10,%eax
f010436d:	66 a3 96 a0 12 f0    	mov    %ax,0xf012a096
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f0104373:	b8 56 13 12 f0       	mov    $0xf0121356,%eax
f0104378:	66 a3 98 a0 12 f0    	mov    %ax,0xf012a098
f010437e:	66 c7 05 9a a0 12 f0 	movw   $0x8,0xf012a09a
f0104385:	08 00 
f0104387:	c6 05 9c a0 12 f0 00 	movb   $0x0,0xf012a09c
f010438e:	c6 05 9d a0 12 f0 ee 	movb   $0xee,0xf012a09d
f0104395:	c1 e8 10             	shr    $0x10,%eax
f0104398:	66 a3 9e a0 12 f0    	mov    %ax,0xf012a09e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f010439e:	b8 60 13 12 f0       	mov    $0xf0121360,%eax
f01043a3:	66 a3 a0 a0 12 f0    	mov    %ax,0xf012a0a0
f01043a9:	66 c7 05 a2 a0 12 f0 	movw   $0x8,0xf012a0a2
f01043b0:	08 00 
f01043b2:	c6 05 a4 a0 12 f0 00 	movb   $0x0,0xf012a0a4
f01043b9:	c6 05 a5 a0 12 f0 ee 	movb   $0xee,0xf012a0a5
f01043c0:	c1 e8 10             	shr    $0x10,%eax
f01043c3:	66 a3 a6 a0 12 f0    	mov    %ax,0xf012a0a6
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f01043c9:	b8 6a 13 12 f0       	mov    $0xf012136a,%eax
f01043ce:	66 a3 a8 a0 12 f0    	mov    %ax,0xf012a0a8
f01043d4:	66 c7 05 aa a0 12 f0 	movw   $0x8,0xf012a0aa
f01043db:	08 00 
f01043dd:	c6 05 ac a0 12 f0 00 	movb   $0x0,0xf012a0ac
f01043e4:	c6 05 ad a0 12 f0 ee 	movb   $0xee,0xf012a0ad
f01043eb:	c1 e8 10             	shr    $0x10,%eax
f01043ee:	66 a3 ae a0 12 f0    	mov    %ax,0xf012a0ae
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f01043f4:	b8 74 13 12 f0       	mov    $0xf0121374,%eax
f01043f9:	66 a3 b0 a0 12 f0    	mov    %ax,0xf012a0b0
f01043ff:	66 c7 05 b2 a0 12 f0 	movw   $0x8,0xf012a0b2
f0104406:	08 00 
f0104408:	c6 05 b4 a0 12 f0 00 	movb   $0x0,0xf012a0b4
f010440f:	c6 05 b5 a0 12 f0 8e 	movb   $0x8e,0xf012a0b5
f0104416:	c1 e8 10             	shr    $0x10,%eax
f0104419:	66 a3 b6 a0 12 f0    	mov    %ax,0xf012a0b6
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f010441f:	b8 7e 13 12 f0       	mov    $0xf012137e,%eax
f0104424:	66 a3 b8 a0 12 f0    	mov    %ax,0xf012a0b8
f010442a:	66 c7 05 ba a0 12 f0 	movw   $0x8,0xf012a0ba
f0104431:	08 00 
f0104433:	c6 05 bc a0 12 f0 00 	movb   $0x0,0xf012a0bc
f010443a:	c6 05 bd a0 12 f0 8e 	movb   $0x8e,0xf012a0bd
f0104441:	c1 e8 10             	shr    $0x10,%eax
f0104444:	66 a3 be a0 12 f0    	mov    %ax,0xf012a0be
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f010444a:	b8 88 13 12 f0       	mov    $0xf0121388,%eax
f010444f:	66 a3 c0 a0 12 f0    	mov    %ax,0xf012a0c0
f0104455:	66 c7 05 c2 a0 12 f0 	movw   $0x8,0xf012a0c2
f010445c:	08 00 
f010445e:	c6 05 c4 a0 12 f0 00 	movb   $0x0,0xf012a0c4
f0104465:	c6 05 c5 a0 12 f0 8e 	movb   $0x8e,0xf012a0c5
f010446c:	c1 e8 10             	shr    $0x10,%eax
f010446f:	66 a3 c6 a0 12 f0    	mov    %ax,0xf012a0c6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f0104475:	b8 90 13 12 f0       	mov    $0xf0121390,%eax
f010447a:	66 a3 d0 a0 12 f0    	mov    %ax,0xf012a0d0
f0104480:	66 c7 05 d2 a0 12 f0 	movw   $0x8,0xf012a0d2
f0104487:	08 00 
f0104489:	c6 05 d4 a0 12 f0 00 	movb   $0x0,0xf012a0d4
f0104490:	c6 05 d5 a0 12 f0 8e 	movb   $0x8e,0xf012a0d5
f0104497:	c1 e8 10             	shr    $0x10,%eax
f010449a:	66 a3 d6 a0 12 f0    	mov    %ax,0xf012a0d6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f01044a0:	b8 98 13 12 f0       	mov    $0xf0121398,%eax
f01044a5:	66 a3 d8 a0 12 f0    	mov    %ax,0xf012a0d8
f01044ab:	66 c7 05 da a0 12 f0 	movw   $0x8,0xf012a0da
f01044b2:	08 00 
f01044b4:	c6 05 dc a0 12 f0 00 	movb   $0x0,0xf012a0dc
f01044bb:	c6 05 dd a0 12 f0 8e 	movb   $0x8e,0xf012a0dd
f01044c2:	c1 e8 10             	shr    $0x10,%eax
f01044c5:	66 a3 de a0 12 f0    	mov    %ax,0xf012a0de
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f01044cb:	b8 a0 13 12 f0       	mov    $0xf01213a0,%eax
f01044d0:	66 a3 e0 a0 12 f0    	mov    %ax,0xf012a0e0
f01044d6:	66 c7 05 e2 a0 12 f0 	movw   $0x8,0xf012a0e2
f01044dd:	08 00 
f01044df:	c6 05 e4 a0 12 f0 00 	movb   $0x0,0xf012a0e4
f01044e6:	c6 05 e5 a0 12 f0 8e 	movb   $0x8e,0xf012a0e5
f01044ed:	c1 e8 10             	shr    $0x10,%eax
f01044f0:	66 a3 e6 a0 12 f0    	mov    %ax,0xf012a0e6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f01044f6:	b8 a8 13 12 f0       	mov    $0xf01213a8,%eax
f01044fb:	66 a3 e8 a0 12 f0    	mov    %ax,0xf012a0e8
f0104501:	66 c7 05 ea a0 12 f0 	movw   $0x8,0xf012a0ea
f0104508:	08 00 
f010450a:	c6 05 ec a0 12 f0 00 	movb   $0x0,0xf012a0ec
f0104511:	c6 05 ed a0 12 f0 8e 	movb   $0x8e,0xf012a0ed
f0104518:	c1 e8 10             	shr    $0x10,%eax
f010451b:	66 a3 ee a0 12 f0    	mov    %ax,0xf012a0ee
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f0104521:	b8 b0 13 12 f0       	mov    $0xf01213b0,%eax
f0104526:	66 a3 f0 a0 12 f0    	mov    %ax,0xf012a0f0
f010452c:	66 c7 05 f2 a0 12 f0 	movw   $0x8,0xf012a0f2
f0104533:	08 00 
f0104535:	c6 05 f4 a0 12 f0 00 	movb   $0x0,0xf012a0f4
f010453c:	c6 05 f5 a0 12 f0 8e 	movb   $0x8e,0xf012a0f5
f0104543:	c1 e8 10             	shr    $0x10,%eax
f0104546:	66 a3 f6 a0 12 f0    	mov    %ax,0xf012a0f6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f010454c:	b8 b8 13 12 f0       	mov    $0xf01213b8,%eax
f0104551:	66 a3 00 a1 12 f0    	mov    %ax,0xf012a100
f0104557:	66 c7 05 02 a1 12 f0 	movw   $0x8,0xf012a102
f010455e:	08 00 
f0104560:	c6 05 04 a1 12 f0 00 	movb   $0x0,0xf012a104
f0104567:	c6 05 05 a1 12 f0 8e 	movb   $0x8e,0xf012a105
f010456e:	c1 e8 10             	shr    $0x10,%eax
f0104571:	66 a3 06 a1 12 f0    	mov    %ax,0xf012a106
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f0104577:	b8 be 13 12 f0       	mov    $0xf01213be,%eax
f010457c:	66 a3 08 a1 12 f0    	mov    %ax,0xf012a108
f0104582:	66 c7 05 0a a1 12 f0 	movw   $0x8,0xf012a10a
f0104589:	08 00 
f010458b:	c6 05 0c a1 12 f0 00 	movb   $0x0,0xf012a10c
f0104592:	c6 05 0d a1 12 f0 8e 	movb   $0x8e,0xf012a10d
f0104599:	c1 e8 10             	shr    $0x10,%eax
f010459c:	66 a3 0e a1 12 f0    	mov    %ax,0xf012a10e
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f01045a2:	b8 c2 13 12 f0       	mov    $0xf01213c2,%eax
f01045a7:	66 a3 10 a1 12 f0    	mov    %ax,0xf012a110
f01045ad:	66 c7 05 12 a1 12 f0 	movw   $0x8,0xf012a112
f01045b4:	08 00 
f01045b6:	c6 05 14 a1 12 f0 00 	movb   $0x0,0xf012a114
f01045bd:	c6 05 15 a1 12 f0 8e 	movb   $0x8e,0xf012a115
f01045c4:	c1 e8 10             	shr    $0x10,%eax
f01045c7:	66 a3 16 a1 12 f0    	mov    %ax,0xf012a116
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f01045cd:	b8 c8 13 12 f0       	mov    $0xf01213c8,%eax
f01045d2:	66 a3 18 a1 12 f0    	mov    %ax,0xf012a118
f01045d8:	66 c7 05 1a a1 12 f0 	movw   $0x8,0xf012a11a
f01045df:	08 00 
f01045e1:	c6 05 1c a1 12 f0 00 	movb   $0x0,0xf012a11c
f01045e8:	c6 05 1d a1 12 f0 8e 	movb   $0x8e,0xf012a11d
f01045ef:	c1 e8 10             	shr    $0x10,%eax
f01045f2:	66 a3 1e a1 12 f0    	mov    %ax,0xf012a11e
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f01045f8:	b8 ce 13 12 f0       	mov    $0xf01213ce,%eax
f01045fd:	66 a3 00 a2 12 f0    	mov    %ax,0xf012a200
f0104603:	66 c7 05 02 a2 12 f0 	movw   $0x8,0xf012a202
f010460a:	08 00 
f010460c:	c6 05 04 a2 12 f0 00 	movb   $0x0,0xf012a204
f0104613:	c6 05 05 a2 12 f0 ee 	movb   $0xee,0xf012a205
f010461a:	c1 e8 10             	shr    $0x10,%eax
f010461d:	66 a3 06 a2 12 f0    	mov    %ax,0xf012a206
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f0104623:	b8 d4 13 12 f0       	mov    $0xf01213d4,%eax
f0104628:	66 a3 80 a1 12 f0    	mov    %ax,0xf012a180
f010462e:	66 c7 05 82 a1 12 f0 	movw   $0x8,0xf012a182
f0104635:	08 00 
f0104637:	c6 05 84 a1 12 f0 00 	movb   $0x0,0xf012a184
f010463e:	c6 05 85 a1 12 f0 8e 	movb   $0x8e,0xf012a185
f0104645:	c1 e8 10             	shr    $0x10,%eax
f0104648:	66 a3 86 a1 12 f0    	mov    %ax,0xf012a186
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f010464e:	b8 da 13 12 f0       	mov    $0xf01213da,%eax
f0104653:	66 a3 88 a1 12 f0    	mov    %ax,0xf012a188
f0104659:	66 c7 05 8a a1 12 f0 	movw   $0x8,0xf012a18a
f0104660:	08 00 
f0104662:	c6 05 8c a1 12 f0 00 	movb   $0x0,0xf012a18c
f0104669:	c6 05 8d a1 12 f0 8e 	movb   $0x8e,0xf012a18d
f0104670:	c1 e8 10             	shr    $0x10,%eax
f0104673:	66 a3 8e a1 12 f0    	mov    %ax,0xf012a18e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f0104679:	b8 e0 13 12 f0       	mov    $0xf01213e0,%eax
f010467e:	66 a3 90 a1 12 f0    	mov    %ax,0xf012a190
f0104684:	66 c7 05 92 a1 12 f0 	movw   $0x8,0xf012a192
f010468b:	08 00 
f010468d:	c6 05 94 a1 12 f0 00 	movb   $0x0,0xf012a194
f0104694:	c6 05 95 a1 12 f0 8e 	movb   $0x8e,0xf012a195
f010469b:	c1 e8 10             	shr    $0x10,%eax
f010469e:	66 a3 96 a1 12 f0    	mov    %ax,0xf012a196
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f01046a4:	b8 e6 13 12 f0       	mov    $0xf01213e6,%eax
f01046a9:	66 a3 98 a1 12 f0    	mov    %ax,0xf012a198
f01046af:	66 c7 05 9a a1 12 f0 	movw   $0x8,0xf012a19a
f01046b6:	08 00 
f01046b8:	c6 05 9c a1 12 f0 00 	movb   $0x0,0xf012a19c
f01046bf:	c6 05 9d a1 12 f0 8e 	movb   $0x8e,0xf012a19d
f01046c6:	c1 e8 10             	shr    $0x10,%eax
f01046c9:	66 a3 9e a1 12 f0    	mov    %ax,0xf012a19e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f01046cf:	b8 ec 13 12 f0       	mov    $0xf01213ec,%eax
f01046d4:	66 a3 a0 a1 12 f0    	mov    %ax,0xf012a1a0
f01046da:	66 c7 05 a2 a1 12 f0 	movw   $0x8,0xf012a1a2
f01046e1:	08 00 
f01046e3:	c6 05 a4 a1 12 f0 00 	movb   $0x0,0xf012a1a4
f01046ea:	c6 05 a5 a1 12 f0 8e 	movb   $0x8e,0xf012a1a5
f01046f1:	c1 e8 10             	shr    $0x10,%eax
f01046f4:	66 a3 a6 a1 12 f0    	mov    %ax,0xf012a1a6
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f01046fa:	b8 f2 13 12 f0       	mov    $0xf01213f2,%eax
f01046ff:	66 a3 a8 a1 12 f0    	mov    %ax,0xf012a1a8
f0104705:	66 c7 05 aa a1 12 f0 	movw   $0x8,0xf012a1aa
f010470c:	08 00 
f010470e:	c6 05 ac a1 12 f0 00 	movb   $0x0,0xf012a1ac
f0104715:	c6 05 ad a1 12 f0 8e 	movb   $0x8e,0xf012a1ad
f010471c:	c1 e8 10             	shr    $0x10,%eax
f010471f:	66 a3 ae a1 12 f0    	mov    %ax,0xf012a1ae
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f0104725:	b8 f8 13 12 f0       	mov    $0xf01213f8,%eax
f010472a:	66 a3 b0 a1 12 f0    	mov    %ax,0xf012a1b0
f0104730:	66 c7 05 b2 a1 12 f0 	movw   $0x8,0xf012a1b2
f0104737:	08 00 
f0104739:	c6 05 b4 a1 12 f0 00 	movb   $0x0,0xf012a1b4
f0104740:	c6 05 b5 a1 12 f0 8e 	movb   $0x8e,0xf012a1b5
f0104747:	c1 e8 10             	shr    $0x10,%eax
f010474a:	66 a3 b6 a1 12 f0    	mov    %ax,0xf012a1b6
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f0104750:	b8 fe 13 12 f0       	mov    $0xf01213fe,%eax
f0104755:	66 a3 b8 a1 12 f0    	mov    %ax,0xf012a1b8
f010475b:	66 c7 05 ba a1 12 f0 	movw   $0x8,0xf012a1ba
f0104762:	08 00 
f0104764:	c6 05 bc a1 12 f0 00 	movb   $0x0,0xf012a1bc
f010476b:	c6 05 bd a1 12 f0 8e 	movb   $0x8e,0xf012a1bd
f0104772:	c1 e8 10             	shr    $0x10,%eax
f0104775:	66 a3 be a1 12 f0    	mov    %ax,0xf012a1be
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f010477b:	b8 04 14 12 f0       	mov    $0xf0121404,%eax
f0104780:	66 a3 c0 a1 12 f0    	mov    %ax,0xf012a1c0
f0104786:	66 c7 05 c2 a1 12 f0 	movw   $0x8,0xf012a1c2
f010478d:	08 00 
f010478f:	c6 05 c4 a1 12 f0 00 	movb   $0x0,0xf012a1c4
f0104796:	c6 05 c5 a1 12 f0 8e 	movb   $0x8e,0xf012a1c5
f010479d:	c1 e8 10             	shr    $0x10,%eax
f01047a0:	66 a3 c6 a1 12 f0    	mov    %ax,0xf012a1c6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f01047a6:	b8 0a 14 12 f0       	mov    $0xf012140a,%eax
f01047ab:	66 a3 c8 a1 12 f0    	mov    %ax,0xf012a1c8
f01047b1:	66 c7 05 ca a1 12 f0 	movw   $0x8,0xf012a1ca
f01047b8:	08 00 
f01047ba:	c6 05 cc a1 12 f0 00 	movb   $0x0,0xf012a1cc
f01047c1:	c6 05 cd a1 12 f0 8e 	movb   $0x8e,0xf012a1cd
f01047c8:	c1 e8 10             	shr    $0x10,%eax
f01047cb:	66 a3 ce a1 12 f0    	mov    %ax,0xf012a1ce
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f01047d1:	b8 10 14 12 f0       	mov    $0xf0121410,%eax
f01047d6:	66 a3 d0 a1 12 f0    	mov    %ax,0xf012a1d0
f01047dc:	66 c7 05 d2 a1 12 f0 	movw   $0x8,0xf012a1d2
f01047e3:	08 00 
f01047e5:	c6 05 d4 a1 12 f0 00 	movb   $0x0,0xf012a1d4
f01047ec:	c6 05 d5 a1 12 f0 8e 	movb   $0x8e,0xf012a1d5
f01047f3:	c1 e8 10             	shr    $0x10,%eax
f01047f6:	66 a3 d6 a1 12 f0    	mov    %ax,0xf012a1d6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f01047fc:	b8 16 14 12 f0       	mov    $0xf0121416,%eax
f0104801:	66 a3 d8 a1 12 f0    	mov    %ax,0xf012a1d8
f0104807:	66 c7 05 da a1 12 f0 	movw   $0x8,0xf012a1da
f010480e:	08 00 
f0104810:	c6 05 dc a1 12 f0 00 	movb   $0x0,0xf012a1dc
f0104817:	c6 05 dd a1 12 f0 8e 	movb   $0x8e,0xf012a1dd
f010481e:	c1 e8 10             	shr    $0x10,%eax
f0104821:	66 a3 de a1 12 f0    	mov    %ax,0xf012a1de
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f0104827:	b8 1c 14 12 f0       	mov    $0xf012141c,%eax
f010482c:	66 a3 e0 a1 12 f0    	mov    %ax,0xf012a1e0
f0104832:	66 c7 05 e2 a1 12 f0 	movw   $0x8,0xf012a1e2
f0104839:	08 00 
f010483b:	c6 05 e4 a1 12 f0 00 	movb   $0x0,0xf012a1e4
f0104842:	c6 05 e5 a1 12 f0 8e 	movb   $0x8e,0xf012a1e5
f0104849:	c1 e8 10             	shr    $0x10,%eax
f010484c:	66 a3 e6 a1 12 f0    	mov    %ax,0xf012a1e6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f0104852:	b8 22 14 12 f0       	mov    $0xf0121422,%eax
f0104857:	66 a3 e8 a1 12 f0    	mov    %ax,0xf012a1e8
f010485d:	66 c7 05 ea a1 12 f0 	movw   $0x8,0xf012a1ea
f0104864:	08 00 
f0104866:	c6 05 ec a1 12 f0 00 	movb   $0x0,0xf012a1ec
f010486d:	c6 05 ed a1 12 f0 8e 	movb   $0x8e,0xf012a1ed
f0104874:	c1 e8 10             	shr    $0x10,%eax
f0104877:	66 a3 ee a1 12 f0    	mov    %ax,0xf012a1ee
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f010487d:	b8 28 14 12 f0       	mov    $0xf0121428,%eax
f0104882:	66 a3 f0 a1 12 f0    	mov    %ax,0xf012a1f0
f0104888:	66 c7 05 f2 a1 12 f0 	movw   $0x8,0xf012a1f2
f010488f:	08 00 
f0104891:	c6 05 f4 a1 12 f0 00 	movb   $0x0,0xf012a1f4
f0104898:	c6 05 f5 a1 12 f0 8e 	movb   $0x8e,0xf012a1f5
f010489f:	c1 e8 10             	shr    $0x10,%eax
f01048a2:	66 a3 f6 a1 12 f0    	mov    %ax,0xf012a1f6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f01048a8:	b8 2e 14 12 f0       	mov    $0xf012142e,%eax
f01048ad:	66 a3 f8 a1 12 f0    	mov    %ax,0xf012a1f8
f01048b3:	66 c7 05 fa a1 12 f0 	movw   $0x8,0xf012a1fa
f01048ba:	08 00 
f01048bc:	c6 05 fc a1 12 f0 00 	movb   $0x0,0xf012a1fc
f01048c3:	c6 05 fd a1 12 f0 8e 	movb   $0x8e,0xf012a1fd
f01048ca:	c1 e8 10             	shr    $0x10,%eax
f01048cd:	66 a3 fe a1 12 f0    	mov    %ax,0xf012a1fe
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f01048d3:	b8 34 14 12 f0       	mov    $0xf0121434,%eax
f01048d8:	66 a3 18 a2 12 f0    	mov    %ax,0xf012a218
f01048de:	66 c7 05 1a a2 12 f0 	movw   $0x8,0xf012a21a
f01048e5:	08 00 
f01048e7:	c6 05 1c a2 12 f0 00 	movb   $0x0,0xf012a21c
f01048ee:	c6 05 1d a2 12 f0 8e 	movb   $0x8e,0xf012a21d
f01048f5:	c1 e8 10             	shr    $0x10,%eax
f01048f8:	66 a3 1e a2 12 f0    	mov    %ax,0xf012a21e
	trap_init_percpu();
f01048fe:	e8 07 f9 ff ff       	call   f010420a <trap_init_percpu>
}
f0104903:	c9                   	leave  
f0104904:	c3                   	ret    

f0104905 <print_regs>:
}

//mapped text lab7
 void
print_regs(struct PushRegs *regs)
{
f0104905:	55                   	push   %ebp
f0104906:	89 e5                	mov    %esp,%ebp
f0104908:	53                   	push   %ebx
f0104909:	83 ec 0c             	sub    $0xc,%esp
f010490c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f010490f:	ff 33                	pushl  (%ebx)
f0104911:	68 56 98 10 f0       	push   $0xf0109856
f0104916:	e8 db f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010491b:	83 c4 08             	add    $0x8,%esp
f010491e:	ff 73 04             	pushl  0x4(%ebx)
f0104921:	68 65 98 10 f0       	push   $0xf0109865
f0104926:	e8 cb f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010492b:	83 c4 08             	add    $0x8,%esp
f010492e:	ff 73 08             	pushl  0x8(%ebx)
f0104931:	68 74 98 10 f0       	push   $0xf0109874
f0104936:	e8 bb f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010493b:	83 c4 08             	add    $0x8,%esp
f010493e:	ff 73 0c             	pushl  0xc(%ebx)
f0104941:	68 83 98 10 f0       	push   $0xf0109883
f0104946:	e8 ab f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f010494b:	83 c4 08             	add    $0x8,%esp
f010494e:	ff 73 10             	pushl  0x10(%ebx)
f0104951:	68 92 98 10 f0       	push   $0xf0109892
f0104956:	e8 9b f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f010495b:	83 c4 08             	add    $0x8,%esp
f010495e:	ff 73 14             	pushl  0x14(%ebx)
f0104961:	68 a1 98 10 f0       	push   $0xf01098a1
f0104966:	e8 8b f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010496b:	83 c4 08             	add    $0x8,%esp
f010496e:	ff 73 18             	pushl  0x18(%ebx)
f0104971:	68 b0 98 10 f0       	push   $0xf01098b0
f0104976:	e8 7b f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010497b:	83 c4 08             	add    $0x8,%esp
f010497e:	ff 73 1c             	pushl  0x1c(%ebx)
f0104981:	68 bf 98 10 f0       	push   $0xf01098bf
f0104986:	e8 6b f8 ff ff       	call   f01041f6 <cprintf>
}
f010498b:	83 c4 10             	add    $0x10,%esp
f010498e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104991:	c9                   	leave  
f0104992:	c3                   	ret    

f0104993 <print_trapframe>:
{
f0104993:	55                   	push   %ebp
f0104994:	89 e5                	mov    %esp,%ebp
f0104996:	56                   	push   %esi
f0104997:	53                   	push   %ebx
f0104998:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f010499b:	83 ec 08             	sub    $0x8,%esp
f010499e:	68 10 9e 10 f0       	push   $0xf0109e10
f01049a3:	68 bc 80 10 f0       	push   $0xf01080bc
f01049a8:	e8 49 f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01049ad:	e8 58 25 00 00       	call   f0106f0a <cpunum>
f01049b2:	83 c4 0c             	add    $0xc,%esp
f01049b5:	50                   	push   %eax
f01049b6:	53                   	push   %ebx
f01049b7:	68 23 99 10 f0       	push   $0xf0109923
f01049bc:	e8 35 f8 ff ff       	call   f01041f6 <cprintf>
	print_regs(&tf->tf_regs);
f01049c1:	89 1c 24             	mov    %ebx,(%esp)
f01049c4:	e8 3c ff ff ff       	call   f0104905 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01049c9:	83 c4 08             	add    $0x8,%esp
f01049cc:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01049d0:	50                   	push   %eax
f01049d1:	68 41 99 10 f0       	push   $0xf0109941
f01049d6:	e8 1b f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01049db:	83 c4 08             	add    $0x8,%esp
f01049de:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01049e2:	50                   	push   %eax
f01049e3:	68 54 99 10 f0       	push   $0xf0109954
f01049e8:	e8 09 f8 ff ff       	call   f01041f6 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01049ed:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f01049f0:	83 c4 10             	add    $0x10,%esp
f01049f3:	83 f8 13             	cmp    $0x13,%eax
f01049f6:	0f 86 e1 00 00 00    	jbe    f0104add <print_trapframe+0x14a>
		return "System call";
f01049fc:	ba ce 98 10 f0       	mov    $0xf01098ce,%edx
	if (trapno == T_SYSCALL)
f0104a01:	83 f8 30             	cmp    $0x30,%eax
f0104a04:	74 13                	je     f0104a19 <print_trapframe+0x86>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104a06:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104a09:	83 fa 0f             	cmp    $0xf,%edx
f0104a0c:	ba da 98 10 f0       	mov    $0xf01098da,%edx
f0104a11:	b9 e9 98 10 f0       	mov    $0xf01098e9,%ecx
f0104a16:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104a19:	83 ec 04             	sub    $0x4,%esp
f0104a1c:	52                   	push   %edx
f0104a1d:	50                   	push   %eax
f0104a1e:	68 67 99 10 f0       	push   $0xf0109967
f0104a23:	e8 ce f7 ff ff       	call   f01041f6 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104a28:	83 c4 10             	add    $0x10,%esp
f0104a2b:	39 1d 50 d9 5d f0    	cmp    %ebx,0xf05dd950
f0104a31:	0f 84 b2 00 00 00    	je     f0104ae9 <print_trapframe+0x156>
	cprintf("  err  0x%08x", tf->tf_err);
f0104a37:	83 ec 08             	sub    $0x8,%esp
f0104a3a:	ff 73 2c             	pushl  0x2c(%ebx)
f0104a3d:	68 88 99 10 f0       	push   $0xf0109988
f0104a42:	e8 af f7 ff ff       	call   f01041f6 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104a47:	83 c4 10             	add    $0x10,%esp
f0104a4a:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104a4e:	0f 85 b8 00 00 00    	jne    f0104b0c <print_trapframe+0x179>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104a54:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104a57:	89 c2                	mov    %eax,%edx
f0104a59:	83 e2 01             	and    $0x1,%edx
f0104a5c:	b9 fc 98 10 f0       	mov    $0xf01098fc,%ecx
f0104a61:	ba 07 99 10 f0       	mov    $0xf0109907,%edx
f0104a66:	0f 44 ca             	cmove  %edx,%ecx
f0104a69:	89 c2                	mov    %eax,%edx
f0104a6b:	83 e2 02             	and    $0x2,%edx
f0104a6e:	be 13 99 10 f0       	mov    $0xf0109913,%esi
f0104a73:	ba 19 99 10 f0       	mov    $0xf0109919,%edx
f0104a78:	0f 45 d6             	cmovne %esi,%edx
f0104a7b:	83 e0 04             	and    $0x4,%eax
f0104a7e:	b8 1e 99 10 f0       	mov    $0xf010991e,%eax
f0104a83:	be 6b 9b 10 f0       	mov    $0xf0109b6b,%esi
f0104a88:	0f 44 c6             	cmove  %esi,%eax
f0104a8b:	51                   	push   %ecx
f0104a8c:	52                   	push   %edx
f0104a8d:	50                   	push   %eax
f0104a8e:	68 96 99 10 f0       	push   $0xf0109996
f0104a93:	e8 5e f7 ff ff       	call   f01041f6 <cprintf>
f0104a98:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104a9b:	83 ec 08             	sub    $0x8,%esp
f0104a9e:	ff 73 30             	pushl  0x30(%ebx)
f0104aa1:	68 a5 99 10 f0       	push   $0xf01099a5
f0104aa6:	e8 4b f7 ff ff       	call   f01041f6 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104aab:	83 c4 08             	add    $0x8,%esp
f0104aae:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104ab2:	50                   	push   %eax
f0104ab3:	68 b4 99 10 f0       	push   $0xf01099b4
f0104ab8:	e8 39 f7 ff ff       	call   f01041f6 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104abd:	83 c4 08             	add    $0x8,%esp
f0104ac0:	ff 73 38             	pushl  0x38(%ebx)
f0104ac3:	68 c7 99 10 f0       	push   $0xf01099c7
f0104ac8:	e8 29 f7 ff ff       	call   f01041f6 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104acd:	83 c4 10             	add    $0x10,%esp
f0104ad0:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104ad4:	75 4b                	jne    f0104b21 <print_trapframe+0x18e>
}
f0104ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104ad9:	5b                   	pop    %ebx
f0104ada:	5e                   	pop    %esi
f0104adb:	5d                   	pop    %ebp
f0104adc:	c3                   	ret    
		return excnames[trapno];
f0104add:	8b 14 85 c0 9d 10 f0 	mov    -0xfef6240(,%eax,4),%edx
f0104ae4:	e9 30 ff ff ff       	jmp    f0104a19 <print_trapframe+0x86>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104ae9:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104aed:	0f 85 44 ff ff ff    	jne    f0104a37 <print_trapframe+0xa4>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104af3:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104af6:	83 ec 08             	sub    $0x8,%esp
f0104af9:	50                   	push   %eax
f0104afa:	68 79 99 10 f0       	push   $0xf0109979
f0104aff:	e8 f2 f6 ff ff       	call   f01041f6 <cprintf>
f0104b04:	83 c4 10             	add    $0x10,%esp
f0104b07:	e9 2b ff ff ff       	jmp    f0104a37 <print_trapframe+0xa4>
		cprintf("\n");
f0104b0c:	83 ec 0c             	sub    $0xc,%esp
f0104b0f:	68 7b 95 10 f0       	push   $0xf010957b
f0104b14:	e8 dd f6 ff ff       	call   f01041f6 <cprintf>
f0104b19:	83 c4 10             	add    $0x10,%esp
f0104b1c:	e9 7a ff ff ff       	jmp    f0104a9b <print_trapframe+0x108>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104b21:	83 ec 08             	sub    $0x8,%esp
f0104b24:	ff 73 3c             	pushl  0x3c(%ebx)
f0104b27:	68 d6 99 10 f0       	push   $0xf01099d6
f0104b2c:	e8 c5 f6 ff ff       	call   f01041f6 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104b31:	83 c4 08             	add    $0x8,%esp
f0104b34:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104b38:	50                   	push   %eax
f0104b39:	68 e5 99 10 f0       	push   $0xf01099e5
f0104b3e:	e8 b3 f6 ff ff       	call   f01041f6 <cprintf>
f0104b43:	83 c4 10             	add    $0x10,%esp
}
f0104b46:	eb 8e                	jmp    f0104ad6 <print_trapframe+0x143>

f0104b48 <page_fault_handler>:


//mapped text lab7
void
page_fault_handler(struct Trapframe *tf)
{
f0104b48:	55                   	push   %ebp
f0104b49:	89 e5                	mov    %esp,%ebp
f0104b4b:	57                   	push   %edi
f0104b4c:	56                   	push   %esi
f0104b4d:	53                   	push   %ebx
f0104b4e:	83 ec 0c             	sub    $0xc,%esp
f0104b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104b54:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f0104b57:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104b5b:	83 e0 03             	and    $0x3,%eax
f0104b5e:	66 83 f8 03          	cmp    $0x3,%ax
f0104b62:	75 5d                	jne    f0104bc1 <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f0104b64:	e8 a1 23 00 00       	call   f0106f0a <cpunum>
f0104b69:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b6c:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104b72:	83 78 68 00          	cmpl   $0x0,0x68(%eax)
f0104b76:	75 69                	jne    f0104be1 <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104b78:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f0104b7b:	e8 8a 23 00 00       	call   f0106f0a <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104b80:	57                   	push   %edi
f0104b81:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f0104b82:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104b85:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104b8b:	ff 70 48             	pushl  0x48(%eax)
f0104b8e:	68 b8 9c 10 f0       	push   $0xf0109cb8
f0104b93:	e8 5e f6 ff ff       	call   f01041f6 <cprintf>
	print_trapframe(tf);
f0104b98:	89 1c 24             	mov    %ebx,(%esp)
f0104b9b:	e8 f3 fd ff ff       	call   f0104993 <print_trapframe>
	env_destroy(curenv);
f0104ba0:	e8 65 23 00 00       	call   f0106f0a <cpunum>
f0104ba5:	83 c4 04             	add    $0x4,%esp
f0104ba8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bab:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104bb1:	e8 38 f4 ff ff       	call   f0103fee <env_destroy>
}
f0104bb6:	83 c4 10             	add    $0x10,%esp
f0104bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104bbc:	5b                   	pop    %ebx
f0104bbd:	5e                   	pop    %esi
f0104bbe:	5f                   	pop    %edi
f0104bbf:	5d                   	pop    %ebp
f0104bc0:	c3                   	ret    
		print_trapframe(tf);//just test
f0104bc1:	83 ec 0c             	sub    $0xc,%esp
f0104bc4:	53                   	push   %ebx
f0104bc5:	e8 c9 fd ff ff       	call   f0104993 <print_trapframe>
		panic("panic at kernel page_fault\n");
f0104bca:	83 c4 0c             	add    $0xc,%esp
f0104bcd:	68 f8 99 10 f0       	push   $0xf01099f8
f0104bd2:	68 d2 01 00 00       	push   $0x1d2
f0104bd7:	68 14 9a 10 f0       	push   $0xf0109a14
f0104bdc:	e8 68 b4 ff ff       	call   f0100049 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104be1:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0104be4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f0104be9:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));		
f0104beb:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104bf0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0104bf5:	77 05                	ja     f0104bfc <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f0104bf7:	8d 42 c8             	lea    -0x38(%edx),%eax
f0104bfa:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f0104bfc:	e8 09 23 00 00       	call   f0106f0a <cpunum>
f0104c01:	6a 02                	push   $0x2
f0104c03:	6a 34                	push   $0x34
f0104c05:	57                   	push   %edi
f0104c06:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c09:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104c0f:	e8 e5 e8 ff ff       	call   f01034f9 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0104c14:	89 fa                	mov    %edi,%edx
f0104c16:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f0104c18:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104c1b:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0104c1e:	8d 7f 08             	lea    0x8(%edi),%edi
f0104c21:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104c26:	89 de                	mov    %ebx,%esi
f0104c28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0104c2a:	8b 43 30             	mov    0x30(%ebx),%eax
f0104c2d:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0104c30:	8b 43 38             	mov    0x38(%ebx),%eax
f0104c33:	89 d7                	mov    %edx,%edi
f0104c35:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f0104c38:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104c3b:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0104c3e:	e8 c7 22 00 00       	call   f0106f0a <cpunum>
f0104c43:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c46:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104c4c:	8b 58 68             	mov    0x68(%eax),%ebx
f0104c4f:	e8 b6 22 00 00       	call   f0106f0a <cpunum>
f0104c54:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c57:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104c5d:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104c60:	e8 a5 22 00 00       	call   f0106f0a <cpunum>
f0104c65:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c68:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104c6e:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104c71:	e8 94 22 00 00       	call   f0106f0a <cpunum>
f0104c76:	83 c4 04             	add    $0x4,%esp
f0104c79:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c7c:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104c82:	e8 9d c3 01 00       	call   f0121024 <env_run>

f0104c87 <trap>:
{
f0104c87:	55                   	push   %ebp
f0104c88:	89 e5                	mov    %esp,%ebp
f0104c8a:	57                   	push   %edi
f0104c8b:	56                   	push   %esi
f0104c8c:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104c8f:	fc                   	cld    
	if (panicstr){
f0104c90:	83 3d 80 ed 5d f0 00 	cmpl   $0x0,0xf05ded80
f0104c97:	74 01                	je     f0104c9a <trap+0x13>
		asm volatile("hlt");
f0104c99:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104c9a:	e8 6b 22 00 00       	call   f0106f0a <cpunum>
f0104c9f:	6b d0 74             	imul   $0x74,%eax,%edx
f0104ca2:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104ca5:	b8 01 00 00 00       	mov    $0x1,%eax
f0104caa:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
f0104cb1:	83 f8 02             	cmp    $0x2,%eax
f0104cb4:	74 30                	je     f0104ce6 <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104cb6:	9c                   	pushf  
f0104cb7:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104cb8:	f6 c4 02             	test   $0x2,%ah
f0104cbb:	75 3b                	jne    f0104cf8 <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0104cbd:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104cc1:	83 e0 03             	and    $0x3,%eax
f0104cc4:	66 83 f8 03          	cmp    $0x3,%ax
f0104cc8:	74 47                	je     f0104d11 <trap+0x8a>
	last_tf = tf;
f0104cca:	89 35 50 d9 5d f0    	mov    %esi,0xf05dd950
	switch (tf->tf_trapno)
f0104cd0:	8b 46 28             	mov    0x28(%esi),%eax
f0104cd3:	83 e8 03             	sub    $0x3,%eax
f0104cd6:	83 f8 30             	cmp    $0x30,%eax
f0104cd9:	0f 87 92 02 00 00    	ja     f0104f71 <trap+0x2ea>
f0104cdf:	ff 24 85 e0 9c 10 f0 	jmp    *-0xfef6320(,%eax,4)
f0104ce6:	83 ec 0c             	sub    $0xc,%esp
f0104ce9:	68 20 d3 16 f0       	push   $0xf016d320
f0104cee:	e8 a0 24 00 00       	call   f0107193 <spin_lock>
f0104cf3:	83 c4 10             	add    $0x10,%esp
f0104cf6:	eb be                	jmp    f0104cb6 <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f0104cf8:	68 20 9a 10 f0       	push   $0xf0109a20
f0104cfd:	68 8b 92 10 f0       	push   $0xf010928b
f0104d02:	68 9c 01 00 00       	push   $0x19c
f0104d07:	68 14 9a 10 f0       	push   $0xf0109a14
f0104d0c:	e8 38 b3 ff ff       	call   f0100049 <_panic>
f0104d11:	83 ec 0c             	sub    $0xc,%esp
f0104d14:	68 20 d3 16 f0       	push   $0xf016d320
f0104d19:	e8 75 24 00 00       	call   f0107193 <spin_lock>
		assert(curenv);
f0104d1e:	e8 e7 21 00 00       	call   f0106f0a <cpunum>
f0104d23:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d26:	83 c4 10             	add    $0x10,%esp
f0104d29:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0104d30:	74 3e                	je     f0104d70 <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f0104d32:	e8 d3 21 00 00       	call   f0106f0a <cpunum>
f0104d37:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d3a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104d40:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104d44:	74 43                	je     f0104d89 <trap+0x102>
		curenv->env_tf = *tf;
f0104d46:	e8 bf 21 00 00       	call   f0106f0a <cpunum>
f0104d4b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d4e:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104d54:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104d59:	89 c7                	mov    %eax,%edi
f0104d5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104d5d:	e8 a8 21 00 00       	call   f0106f0a <cpunum>
f0104d62:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d65:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0104d6b:	e9 5a ff ff ff       	jmp    f0104cca <trap+0x43>
		assert(curenv);
f0104d70:	68 39 9a 10 f0       	push   $0xf0109a39
f0104d75:	68 8b 92 10 f0       	push   $0xf010928b
f0104d7a:	68 a3 01 00 00       	push   $0x1a3
f0104d7f:	68 14 9a 10 f0       	push   $0xf0109a14
f0104d84:	e8 c0 b2 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f0104d89:	e8 7c 21 00 00       	call   f0106f0a <cpunum>
f0104d8e:	83 ec 0c             	sub    $0xc,%esp
f0104d91:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d94:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104d9a:	e8 51 f0 ff ff       	call   f0103df0 <env_free>
			curenv = NULL;
f0104d9f:	e8 66 21 00 00       	call   f0106f0a <cpunum>
f0104da4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104da7:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f0104dae:	00 00 00 
			sched_yield();
f0104db1:	e8 f8 02 00 00       	call   f01050ae <sched_yield>
			page_fault_handler(tf);
f0104db6:	83 ec 0c             	sub    $0xc,%esp
f0104db9:	56                   	push   %esi
f0104dba:	e8 89 fd ff ff       	call   f0104b48 <page_fault_handler>
f0104dbf:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104dc2:	e8 43 21 00 00       	call   f0106f0a <cpunum>
f0104dc7:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dca:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0104dd1:	74 18                	je     f0104deb <trap+0x164>
f0104dd3:	e8 32 21 00 00       	call   f0106f0a <cpunum>
f0104dd8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ddb:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104de1:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104de5:	0f 84 ce 01 00 00    	je     f0104fb9 <trap+0x332>
		sched_yield();
f0104deb:	e8 be 02 00 00       	call   f01050ae <sched_yield>
			monitor(tf);
f0104df0:	83 ec 0c             	sub    $0xc,%esp
f0104df3:	56                   	push   %esi
f0104df4:	e8 d1 be ff ff       	call   f0100cca <monitor>
f0104df9:	83 c4 10             	add    $0x10,%esp
f0104dfc:	eb c4                	jmp    f0104dc2 <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0104dfe:	83 ec 08             	sub    $0x8,%esp
f0104e01:	ff 76 04             	pushl  0x4(%esi)
f0104e04:	ff 36                	pushl  (%esi)
f0104e06:	ff 76 10             	pushl  0x10(%esi)
f0104e09:	ff 76 18             	pushl  0x18(%esi)
f0104e0c:	ff 76 14             	pushl  0x14(%esi)
f0104e0f:	ff 76 1c             	pushl  0x1c(%esi)
f0104e12:	e8 eb 03 00 00       	call   f0105202 <syscall>
f0104e17:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104e1a:	83 c4 20             	add    $0x20,%esp
f0104e1d:	eb a3                	jmp    f0104dc2 <trap+0x13b>
			time_tick();
f0104e1f:	e8 5b 2f 00 00       	call   f0107d7f <time_tick>
			lapic_eoi();
f0104e24:	e8 41 22 00 00       	call   f010706a <lapic_eoi>
			sched_yield();
f0104e29:	e8 80 02 00 00       	call   f01050ae <sched_yield>
			kbd_intr();
f0104e2e:	e8 5e b8 ff ff       	call   f0100691 <kbd_intr>
f0104e33:	eb 8d                	jmp    f0104dc2 <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0104e35:	83 ec 0c             	sub    $0xc,%esp
f0104e38:	68 db 9a 10 f0       	push   $0xf0109adb
f0104e3d:	e8 b4 f3 ff ff       	call   f01041f6 <cprintf>
f0104e42:	83 c4 10             	add    $0x10,%esp
f0104e45:	e9 78 ff ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0104e4a:	83 ec 0c             	sub    $0xc,%esp
f0104e4d:	68 f2 9a 10 f0       	push   $0xf0109af2
f0104e52:	e8 9f f3 ff ff       	call   f01041f6 <cprintf>
f0104e57:	83 c4 10             	add    $0x10,%esp
f0104e5a:	e9 63 ff ff ff       	jmp    f0104dc2 <trap+0x13b>
			serial_intr();
f0104e5f:	e8 11 b8 ff ff       	call   f0100675 <serial_intr>
f0104e64:	e9 59 ff ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0104e69:	83 ec 0c             	sub    $0xc,%esp
f0104e6c:	68 25 9b 10 f0       	push   $0xf0109b25
f0104e71:	e8 80 f3 ff ff       	call   f01041f6 <cprintf>
f0104e76:	83 c4 10             	add    $0x10,%esp
f0104e79:	e9 44 ff ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0104e7e:	83 ec 0c             	sub    $0xc,%esp
f0104e81:	68 40 9a 10 f0       	push   $0xf0109a40
f0104e86:	e8 6b f3 ff ff       	call   f01041f6 <cprintf>
f0104e8b:	83 c4 10             	add    $0x10,%esp
f0104e8e:	e9 2f ff ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("in Spurious\n");
f0104e93:	83 ec 0c             	sub    $0xc,%esp
f0104e96:	68 56 9a 10 f0       	push   $0xf0109a56
f0104e9b:	e8 56 f3 ff ff       	call   f01041f6 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104ea0:	c7 04 24 63 9a 10 f0 	movl   $0xf0109a63,(%esp)
f0104ea7:	e8 4a f3 ff ff       	call   f01041f6 <cprintf>
f0104eac:	83 c4 10             	add    $0x10,%esp
f0104eaf:	e9 0e ff ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104eb4:	83 ec 0c             	sub    $0xc,%esp
f0104eb7:	68 80 9a 10 f0       	push   $0xf0109a80
f0104ebc:	e8 35 f3 ff ff       	call   f01041f6 <cprintf>
f0104ec1:	83 c4 10             	add    $0x10,%esp
f0104ec4:	e9 f9 fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104ec9:	83 ec 0c             	sub    $0xc,%esp
f0104ecc:	68 96 9a 10 f0       	push   $0xf0109a96
f0104ed1:	e8 20 f3 ff ff       	call   f01041f6 <cprintf>
f0104ed6:	83 c4 10             	add    $0x10,%esp
f0104ed9:	e9 e4 fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104ede:	83 ec 0c             	sub    $0xc,%esp
f0104ee1:	68 ac 9a 10 f0       	push   $0xf0109aac
f0104ee6:	e8 0b f3 ff ff       	call   f01041f6 <cprintf>
f0104eeb:	83 c4 10             	add    $0x10,%esp
f0104eee:	e9 cf fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104ef3:	83 ec 0c             	sub    $0xc,%esp
f0104ef6:	68 c3 9a 10 f0       	push   $0xf0109ac3
f0104efb:	e8 f6 f2 ff ff       	call   f01041f6 <cprintf>
f0104f00:	83 c4 10             	add    $0x10,%esp
f0104f03:	e9 ba fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104f08:	83 ec 0c             	sub    $0xc,%esp
f0104f0b:	68 da 9a 10 f0       	push   $0xf0109ada
f0104f10:	e8 e1 f2 ff ff       	call   f01041f6 <cprintf>
f0104f15:	83 c4 10             	add    $0x10,%esp
f0104f18:	e9 a5 fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104f1d:	83 ec 0c             	sub    $0xc,%esp
f0104f20:	68 f1 9a 10 f0       	push   $0xf0109af1
f0104f25:	e8 cc f2 ff ff       	call   f01041f6 <cprintf>
f0104f2a:	83 c4 10             	add    $0x10,%esp
f0104f2d:	e9 90 fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104f32:	83 ec 0c             	sub    $0xc,%esp
f0104f35:	68 08 9b 10 f0       	push   $0xf0109b08
f0104f3a:	e8 b7 f2 ff ff       	call   f01041f6 <cprintf>
f0104f3f:	83 c4 10             	add    $0x10,%esp
f0104f42:	e9 7b fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104f47:	83 ec 0c             	sub    $0xc,%esp
f0104f4a:	68 24 9b 10 f0       	push   $0xf0109b24
f0104f4f:	e8 a2 f2 ff ff       	call   f01041f6 <cprintf>
f0104f54:	83 c4 10             	add    $0x10,%esp
f0104f57:	e9 66 fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104f5c:	83 ec 0c             	sub    $0xc,%esp
f0104f5f:	68 3b 9b 10 f0       	push   $0xf0109b3b
f0104f64:	e8 8d f2 ff ff       	call   f01041f6 <cprintf>
f0104f69:	83 c4 10             	add    $0x10,%esp
f0104f6c:	e9 51 fe ff ff       	jmp    f0104dc2 <trap+0x13b>
			print_trapframe(tf);
f0104f71:	83 ec 0c             	sub    $0xc,%esp
f0104f74:	56                   	push   %esi
f0104f75:	e8 19 fa ff ff       	call   f0104993 <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104f7a:	83 c4 10             	add    $0x10,%esp
f0104f7d:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104f82:	74 1e                	je     f0104fa2 <trap+0x31b>
				env_destroy(curenv);
f0104f84:	e8 81 1f 00 00       	call   f0106f0a <cpunum>
f0104f89:	83 ec 0c             	sub    $0xc,%esp
f0104f8c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f8f:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104f95:	e8 54 f0 ff ff       	call   f0103fee <env_destroy>
f0104f9a:	83 c4 10             	add    $0x10,%esp
f0104f9d:	e9 20 fe ff ff       	jmp    f0104dc2 <trap+0x13b>
				panic("unhandled trap in kernel");
f0104fa2:	83 ec 04             	sub    $0x4,%esp
f0104fa5:	68 59 9b 10 f0       	push   $0xf0109b59
f0104faa:	68 7b 01 00 00       	push   $0x17b
f0104faf:	68 14 9a 10 f0       	push   $0xf0109a14
f0104fb4:	e8 90 b0 ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f0104fb9:	e8 4c 1f 00 00       	call   f0106f0a <cpunum>
f0104fbe:	83 ec 0c             	sub    $0xc,%esp
f0104fc1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fc4:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104fca:	e8 55 c0 01 00       	call   f0121024 <env_run>

f0104fcf <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104fcf:	55                   	push   %ebp
f0104fd0:	89 e5                	mov    %esp,%ebp
f0104fd2:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f0104fd5:	68 6c 9e 10 f0       	push   $0xf0109e6c
f0104fda:	68 bc 80 10 f0       	push   $0xf01080bc
f0104fdf:	e8 12 f2 ff ff       	call   f01041f6 <cprintf>
f0104fe4:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0104fe9:	8d 50 54             	lea    0x54(%eax),%edx
f0104fec:	83 c4 10             	add    $0x10,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104fef:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0104ff4:	8b 02                	mov    (%edx),%eax
f0104ff6:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104ff9:	83 f8 02             	cmp    $0x2,%eax
f0104ffc:	76 30                	jbe    f010502e <sched_halt+0x5f>
	for (i = 0; i < NENV; i++) {
f0104ffe:	83 c1 01             	add    $0x1,%ecx
f0105001:	81 c2 84 00 00 00    	add    $0x84,%edx
f0105007:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f010500d:	75 e5                	jne    f0104ff4 <sched_halt+0x25>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f010500f:	83 ec 0c             	sub    $0xc,%esp
f0105012:	68 40 9e 10 f0       	push   $0xf0109e40
f0105017:	e8 da f1 ff ff       	call   f01041f6 <cprintf>
f010501c:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f010501f:	83 ec 0c             	sub    $0xc,%esp
f0105022:	6a 00                	push   $0x0
f0105024:	e8 a1 bc ff ff       	call   f0100cca <monitor>
f0105029:	83 c4 10             	add    $0x10,%esp
f010502c:	eb f1                	jmp    f010501f <sched_halt+0x50>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010502e:	e8 d7 1e 00 00       	call   f0106f0a <cpunum>
f0105033:	6b c0 74             	imul   $0x74,%eax,%eax
f0105036:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f010503d:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0105040:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0105045:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010504a:	76 50                	jbe    f010509c <sched_halt+0xcd>
	return (physaddr_t)kva - KERNBASE;
f010504c:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0105051:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0105054:	e8 b1 1e 00 00       	call   f0106f0a <cpunum>
f0105059:	6b d0 74             	imul   $0x74,%eax,%edx
f010505c:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010505f:	b8 02 00 00 00       	mov    $0x2,%eax
f0105064:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010506b:	83 ec 0c             	sub    $0xc,%esp
f010506e:	68 20 d3 16 f0       	push   $0xf016d320
f0105073:	e8 b7 21 00 00       	call   f010722f <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0105078:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f010507a:	e8 8b 1e 00 00       	call   f0106f0a <cpunum>
f010507f:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0105082:	8b 80 30 b0 16 f0    	mov    -0xfe94fd0(%eax),%eax
f0105088:	bd 00 00 00 00       	mov    $0x0,%ebp
f010508d:	89 c4                	mov    %eax,%esp
f010508f:	6a 00                	push   $0x0
f0105091:	6a 00                	push   $0x0
f0105093:	fb                   	sti    
f0105094:	f4                   	hlt    
f0105095:	eb fd                	jmp    f0105094 <sched_halt+0xc5>
}
f0105097:	83 c4 10             	add    $0x10,%esp
f010509a:	c9                   	leave  
f010509b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010509c:	50                   	push   %eax
f010509d:	68 98 80 10 f0       	push   $0xf0108098
f01050a2:	6a 4d                	push   $0x4d
f01050a4:	68 31 9e 10 f0       	push   $0xf0109e31
f01050a9:	e8 9b af ff ff       	call   f0100049 <_panic>

f01050ae <sched_yield>:
{
f01050ae:	55                   	push   %ebp
f01050af:	89 e5                	mov    %esp,%ebp
f01050b1:	53                   	push   %ebx
f01050b2:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f01050b5:	e8 50 1e 00 00       	call   f0106f0a <cpunum>
f01050ba:	6b c0 74             	imul   $0x74,%eax,%eax
f01050bd:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f01050c4:	74 7e                	je     f0105144 <sched_yield+0x96>
		envid_t cur_tone = ENVX(curenv->env_id);
f01050c6:	e8 3f 1e 00 00       	call   f0106f0a <cpunum>
f01050cb:	6b c0 74             	imul   $0x74,%eax,%eax
f01050ce:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01050d4:	8b 48 48             	mov    0x48(%eax),%ecx
f01050d7:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f01050dd:	8d 41 01             	lea    0x1(%ecx),%eax
f01050e0:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f01050e5:	8b 1d 44 d9 5d f0    	mov    0xf05dd944,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f01050eb:	39 c8                	cmp    %ecx,%eax
f01050ed:	74 21                	je     f0105110 <sched_yield+0x62>
			if(envs[i].env_status == ENV_RUNNABLE){
f01050ef:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
f01050f5:	01 da                	add    %ebx,%edx
f01050f7:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f01050fb:	74 0a                	je     f0105107 <sched_yield+0x59>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f01050fd:	83 c0 01             	add    $0x1,%eax
f0105100:	25 ff 03 00 00       	and    $0x3ff,%eax
f0105105:	eb e4                	jmp    f01050eb <sched_yield+0x3d>
				env_run(&envs[i]);
f0105107:	83 ec 0c             	sub    $0xc,%esp
f010510a:	52                   	push   %edx
f010510b:	e8 14 bf 01 00       	call   f0121024 <env_run>
		if(curenv->env_status == ENV_RUNNING)
f0105110:	e8 f5 1d 00 00       	call   f0106f0a <cpunum>
f0105115:	6b c0 74             	imul   $0x74,%eax,%eax
f0105118:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010511e:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0105122:	74 0a                	je     f010512e <sched_yield+0x80>
	sched_halt();
f0105124:	e8 a6 fe ff ff       	call   f0104fcf <sched_halt>
}
f0105129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010512c:	c9                   	leave  
f010512d:	c3                   	ret    
			env_run(curenv);
f010512e:	e8 d7 1d 00 00       	call   f0106f0a <cpunum>
f0105133:	83 ec 0c             	sub    $0xc,%esp
f0105136:	6b c0 74             	imul   $0x74,%eax,%eax
f0105139:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010513f:	e8 e0 be 01 00       	call   f0121024 <env_run>
f0105144:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0105149:	8d 90 00 10 02 00    	lea    0x21000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f010514f:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0105153:	74 0b                	je     f0105160 <sched_yield+0xb2>
f0105155:	05 84 00 00 00       	add    $0x84,%eax
		for(i = 0 ; i < NENV; i++)
f010515a:	39 d0                	cmp    %edx,%eax
f010515c:	75 f1                	jne    f010514f <sched_yield+0xa1>
f010515e:	eb c4                	jmp    f0105124 <sched_yield+0x76>
		  		env_run(&envs[i]);
f0105160:	83 ec 0c             	sub    $0xc,%esp
f0105163:	50                   	push   %eax
f0105164:	e8 bb be 01 00       	call   f0121024 <env_run>

f0105169 <sys_net_send>:
	return time_msec();
}

int
sys_net_send(const void *buf, uint32_t len)
{
f0105169:	55                   	push   %ebp
f010516a:	89 e5                	mov    %esp,%ebp
f010516c:	57                   	push   %edi
f010516d:	56                   	push   %esi
f010516e:	53                   	push   %ebx
f010516f:	83 ec 0c             	sub    $0xc,%esp
f0105172:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105175:	8b 75 0c             	mov    0xc(%ebp),%esi
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_tx to send the packet
	// Hint: e1000_tx only accept kernel virtual address
	int r;
	if((r = user_mem_check(curenv, buf, len, PTE_W|PTE_U)) < 0){
f0105178:	e8 8d 1d 00 00       	call   f0106f0a <cpunum>
f010517d:	6a 06                	push   $0x6
f010517f:	56                   	push   %esi
f0105180:	53                   	push   %ebx
f0105181:	6b c0 74             	imul   $0x74,%eax,%eax
f0105184:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010518a:	e8 c2 e2 ff ff       	call   f0103451 <user_mem_check>
f010518f:	83 c4 10             	add    $0x10,%esp
f0105192:	85 c0                	test   %eax,%eax
f0105194:	78 19                	js     f01051af <sys_net_send+0x46>
		cprintf("address:%x\n", (uint32_t)buf);
		return r;
	}
	return e1000_tx(buf, len);
f0105196:	83 ec 08             	sub    $0x8,%esp
f0105199:	56                   	push   %esi
f010519a:	53                   	push   %ebx
f010519b:	e8 f3 24 00 00       	call   f0107693 <e1000_tx>
f01051a0:	89 c7                	mov    %eax,%edi
f01051a2:	83 c4 10             	add    $0x10,%esp

}
f01051a5:	89 f8                	mov    %edi,%eax
f01051a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01051aa:	5b                   	pop    %ebx
f01051ab:	5e                   	pop    %esi
f01051ac:	5f                   	pop    %edi
f01051ad:	5d                   	pop    %ebp
f01051ae:	c3                   	ret    
f01051af:	89 c7                	mov    %eax,%edi
		cprintf("address:%x\n", (uint32_t)buf);
f01051b1:	83 ec 08             	sub    $0x8,%esp
f01051b4:	53                   	push   %ebx
f01051b5:	68 77 9e 10 f0       	push   $0xf0109e77
f01051ba:	e8 37 f0 ff ff       	call   f01041f6 <cprintf>
		return r;
f01051bf:	83 c4 10             	add    $0x10,%esp
f01051c2:	eb e1                	jmp    f01051a5 <sys_net_send+0x3c>

f01051c4 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
f01051c4:	55                   	push   %ebp
f01051c5:	89 e5                	mov    %esp,%ebp
f01051c7:	53                   	push   %ebx
f01051c8:	83 ec 04             	sub    $0x4,%esp
f01051cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	user_mem_assert(curenv, ROUNDDOWN(buf, PGSIZE), PGSIZE, PTE_U | PTE_W);   // check permission
f01051ce:	e8 37 1d 00 00       	call   f0106f0a <cpunum>
f01051d3:	6a 06                	push   $0x6
f01051d5:	68 00 10 00 00       	push   $0x1000
f01051da:	89 da                	mov    %ebx,%edx
f01051dc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01051e2:	52                   	push   %edx
f01051e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01051e6:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01051ec:	e8 08 e3 ff ff       	call   f01034f9 <user_mem_assert>
  	return e1000_rx(buf,len);
f01051f1:	83 c4 08             	add    $0x8,%esp
f01051f4:	ff 75 0c             	pushl  0xc(%ebp)
f01051f7:	53                   	push   %ebx
f01051f8:	e8 be 25 00 00       	call   f01077bb <e1000_rx>
}
f01051fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105200:	c9                   	leave  
f0105201:	c3                   	ret    

f0105202 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0105202:	55                   	push   %ebp
f0105203:	89 e5                	mov    %esp,%ebp
f0105205:	57                   	push   %edi
f0105206:	56                   	push   %esi
f0105207:	53                   	push   %ebx
f0105208:	83 ec 2c             	sub    $0x2c,%esp
f010520b:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f010520e:	83 f8 15             	cmp    $0x15,%eax
f0105211:	0f 87 82 09 00 00    	ja     f0105b99 <syscall+0x997>
f0105217:	ff 24 85 60 9f 10 f0 	jmp    *-0xfef60a0(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f010521e:	e8 e7 1c 00 00       	call   f0106f0a <cpunum>
f0105223:	6a 04                	push   $0x4
f0105225:	ff 75 10             	pushl  0x10(%ebp)
f0105228:	ff 75 0c             	pushl  0xc(%ebp)
f010522b:	6b c0 74             	imul   $0x74,%eax,%eax
f010522e:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105234:	e8 c0 e2 ff ff       	call   f01034f9 <user_mem_assert>
	cprintf("%.*s", len, s);
f0105239:	83 c4 0c             	add    $0xc,%esp
f010523c:	ff 75 0c             	pushl  0xc(%ebp)
f010523f:	ff 75 10             	pushl  0x10(%ebp)
f0105242:	68 83 9e 10 f0       	push   $0xf0109e83
f0105247:	e8 aa ef ff ff       	call   f01041f6 <cprintf>
f010524c:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f010524f:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f0105254:	89 d8                	mov    %ebx,%eax
f0105256:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105259:	5b                   	pop    %ebx
f010525a:	5e                   	pop    %esi
f010525b:	5f                   	pop    %edi
f010525c:	5d                   	pop    %ebp
f010525d:	c3                   	ret    
	return cons_getc();
f010525e:	e8 40 b4 ff ff       	call   f01006a3 <cons_getc>
f0105263:	89 c3                	mov    %eax,%ebx
			break;
f0105265:	eb ed                	jmp    f0105254 <syscall+0x52>
	return curenv->env_id;
f0105267:	e8 9e 1c 00 00       	call   f0106f0a <cpunum>
f010526c:	6b c0 74             	imul   $0x74,%eax,%eax
f010526f:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105275:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0105278:	eb da                	jmp    f0105254 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f010527a:	83 ec 04             	sub    $0x4,%esp
f010527d:	6a 01                	push   $0x1
f010527f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105282:	50                   	push   %eax
f0105283:	ff 75 0c             	pushl  0xc(%ebp)
f0105286:	e8 bc e3 ff ff       	call   f0103647 <envid2env>
f010528b:	89 c3                	mov    %eax,%ebx
f010528d:	83 c4 10             	add    $0x10,%esp
f0105290:	85 c0                	test   %eax,%eax
f0105292:	78 c0                	js     f0105254 <syscall+0x52>
	if (e == curenv)
f0105294:	e8 71 1c 00 00       	call   f0106f0a <cpunum>
f0105299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010529c:	6b c0 74             	imul   $0x74,%eax,%eax
f010529f:	39 90 28 b0 16 f0    	cmp    %edx,-0xfe94fd8(%eax)
f01052a5:	74 3d                	je     f01052e4 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01052a7:	8b 5a 48             	mov    0x48(%edx),%ebx
f01052aa:	e8 5b 1c 00 00       	call   f0106f0a <cpunum>
f01052af:	83 ec 04             	sub    $0x4,%esp
f01052b2:	53                   	push   %ebx
f01052b3:	6b c0 74             	imul   $0x74,%eax,%eax
f01052b6:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01052bc:	ff 70 48             	pushl  0x48(%eax)
f01052bf:	68 a3 9e 10 f0       	push   $0xf0109ea3
f01052c4:	e8 2d ef ff ff       	call   f01041f6 <cprintf>
f01052c9:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f01052cc:	83 ec 0c             	sub    $0xc,%esp
f01052cf:	ff 75 e4             	pushl  -0x1c(%ebp)
f01052d2:	e8 17 ed ff ff       	call   f0103fee <env_destroy>
f01052d7:	83 c4 10             	add    $0x10,%esp
	return 0;
f01052da:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01052df:	e9 70 ff ff ff       	jmp    f0105254 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01052e4:	e8 21 1c 00 00       	call   f0106f0a <cpunum>
f01052e9:	83 ec 08             	sub    $0x8,%esp
f01052ec:	6b c0 74             	imul   $0x74,%eax,%eax
f01052ef:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01052f5:	ff 70 48             	pushl  0x48(%eax)
f01052f8:	68 88 9e 10 f0       	push   $0xf0109e88
f01052fd:	e8 f4 ee ff ff       	call   f01041f6 <cprintf>
f0105302:	83 c4 10             	add    $0x10,%esp
f0105305:	eb c5                	jmp    f01052cc <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f0105307:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f010530e:	0f 86 86 00 00 00    	jbe    f010539a <syscall+0x198>
	return (physaddr_t)kva - KERNBASE;
f0105314:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105317:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f010531c:	c1 e8 0c             	shr    $0xc,%eax
f010531f:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0105325:	0f 83 86 00 00 00    	jae    f01053b1 <syscall+0x1af>
	return &pages[PGNUM(pa)];
f010532b:	8b 15 90 ed 5d f0    	mov    0xf05ded90,%edx
f0105331:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f0105334:	85 db                	test   %ebx,%ebx
f0105336:	0f 84 67 08 00 00    	je     f0105ba3 <syscall+0x9a1>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f010533c:	e8 c9 1b 00 00       	call   f0106f0a <cpunum>
f0105341:	6a 06                	push   $0x6
f0105343:	ff 75 10             	pushl  0x10(%ebp)
f0105346:	53                   	push   %ebx
f0105347:	6b c0 74             	imul   $0x74,%eax,%eax
f010534a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105350:	ff 70 60             	pushl  0x60(%eax)
f0105353:	e8 21 c3 ff ff       	call   f0101679 <page_insert>
f0105358:	89 c3                	mov    %eax,%ebx
	if(r>=0)
f010535a:	83 c4 10             	add    $0x10,%esp
f010535d:	85 c0                	test   %eax,%eax
f010535f:	0f 88 ef fe ff ff    	js     f0105254 <syscall+0x52>
		curenv->env_kern_pgdir[PDX(va)] = curenv->env_pgdir[PDX(va)];
f0105365:	e8 a0 1b 00 00       	call   f0106f0a <cpunum>
f010536a:	8b 75 10             	mov    0x10(%ebp),%esi
f010536d:	c1 ee 16             	shr    $0x16,%esi
f0105370:	6b c0 74             	imul   $0x74,%eax,%eax
f0105373:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105379:	8b 40 60             	mov    0x60(%eax),%eax
f010537c:	8d 3c b0             	lea    (%eax,%esi,4),%edi
f010537f:	e8 86 1b 00 00       	call   f0106f0a <cpunum>
f0105384:	8b 17                	mov    (%edi),%edx
f0105386:	6b c0 74             	imul   $0x74,%eax,%eax
f0105389:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010538f:	8b 40 64             	mov    0x64(%eax),%eax
f0105392:	89 14 b0             	mov    %edx,(%eax,%esi,4)
f0105395:	e9 ba fe ff ff       	jmp    f0105254 <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010539a:	ff 75 0c             	pushl  0xc(%ebp)
f010539d:	68 98 80 10 f0       	push   $0xf0108098
f01053a2:	68 b2 01 00 00       	push   $0x1b2
f01053a7:	68 bb 9e 10 f0       	push   $0xf0109ebb
f01053ac:	e8 98 ac ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f01053b1:	83 ec 04             	sub    $0x4,%esp
f01053b4:	68 b0 89 10 f0       	push   $0xf01089b0
f01053b9:	6a 51                	push   $0x51
f01053bb:	68 71 92 10 f0       	push   $0xf0109271
f01053c0:	e8 84 ac ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f01053c5:	e8 40 1b 00 00       	call   f0106f0a <cpunum>
	if(inc < PGSIZE){
f01053ca:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f01053d1:	77 22                	ja     f01053f5 <syscall+0x1f3>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f01053d3:	6b c0 74             	imul   $0x74,%eax,%eax
f01053d6:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01053dc:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
f01053e2:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f01053e7:	03 45 0c             	add    0xc(%ebp),%eax
f01053ea:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f01053ef:	0f 86 b8 00 00 00    	jbe    f01054ad <syscall+0x2ab>
	uint32_t i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f01053f5:	e8 10 1b 00 00       	call   f0106f0a <cpunum>
f01053fa:	6b c0 74             	imul   $0x74,%eax,%eax
f01053fd:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105403:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f0105409:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f010540f:	e8 f6 1a 00 00       	call   f0106f0a <cpunum>
f0105414:	6b c0 74             	imul   $0x74,%eax,%eax
f0105417:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010541d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
f0105423:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105426:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f010542d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0105432:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for(; i < end; i+=PGSIZE){
f0105435:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0105438:	0f 86 cd 00 00 00    	jbe    f010550b <syscall+0x309>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f010543e:	83 ec 0c             	sub    $0xc,%esp
f0105441:	6a 01                	push   $0x1
f0105443:	e8 f5 be ff ff       	call   f010133d <page_alloc>
f0105448:	89 c6                	mov    %eax,%esi
		if(!page)
f010544a:	83 c4 10             	add    $0x10,%esp
f010544d:	85 c0                	test   %eax,%eax
f010544f:	0f 84 88 00 00 00    	je     f01054dd <syscall+0x2db>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f0105455:	e8 b0 1a 00 00       	call   f0106f0a <cpunum>
f010545a:	6a 06                	push   $0x6
f010545c:	53                   	push   %ebx
f010545d:	56                   	push   %esi
f010545e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105461:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105467:	ff 70 60             	pushl  0x60(%eax)
f010546a:	e8 0a c2 ff ff       	call   f0101679 <page_insert>
		if(ret)
f010546f:	83 c4 10             	add    $0x10,%esp
f0105472:	85 c0                	test   %eax,%eax
f0105474:	75 7e                	jne    f01054f4 <syscall+0x2f2>
		curenv->env_kern_pgdir[PDX(i)] = curenv->env_pgdir[PDX(i)];
f0105476:	e8 8f 1a 00 00       	call   f0106f0a <cpunum>
f010547b:	89 de                	mov    %ebx,%esi
f010547d:	c1 ee 16             	shr    $0x16,%esi
f0105480:	6b c0 74             	imul   $0x74,%eax,%eax
f0105483:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105489:	8b 40 60             	mov    0x60(%eax),%eax
f010548c:	8d 3c b0             	lea    (%eax,%esi,4),%edi
f010548f:	e8 76 1a 00 00       	call   f0106f0a <cpunum>
f0105494:	8b 17                	mov    (%edi),%edx
f0105496:	6b c0 74             	imul   $0x74,%eax,%eax
f0105499:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010549f:	8b 40 64             	mov    0x64(%eax),%eax
f01054a2:	89 14 b0             	mov    %edx,(%eax,%esi,4)
	for(; i < end; i+=PGSIZE){
f01054a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01054ab:	eb 88                	jmp    f0105435 <syscall+0x233>
			curenv->env_sbrk+=inc;
f01054ad:	e8 58 1a 00 00       	call   f0106f0a <cpunum>
f01054b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01054b5:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01054bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01054be:	01 88 80 00 00 00    	add    %ecx,0x80(%eax)
			return curenv->env_sbrk;
f01054c4:	e8 41 1a 00 00       	call   f0106f0a <cpunum>
f01054c9:	6b c0 74             	imul   $0x74,%eax,%eax
f01054cc:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01054d2:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f01054d8:	e9 77 fd ff ff       	jmp    f0105254 <syscall+0x52>
			panic("there is no page\n");
f01054dd:	83 ec 04             	sub    $0x4,%esp
f01054e0:	68 3b 96 10 f0       	push   $0xf010963b
f01054e5:	68 c9 01 00 00       	push   $0x1c9
f01054ea:	68 bb 9e 10 f0       	push   $0xf0109ebb
f01054ef:	e8 55 ab ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f01054f4:	83 ec 04             	sub    $0x4,%esp
f01054f7:	68 4d 96 10 f0       	push   $0xf010964d
f01054fc:	68 cc 01 00 00       	push   $0x1cc
f0105501:	68 bb 9e 10 f0       	push   $0xf0109ebb
f0105506:	e8 3e ab ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f010550b:	e8 fa 19 00 00       	call   f0106f0a <cpunum>
f0105510:	6b c0 74             	imul   $0x74,%eax,%eax
f0105513:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105519:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010551c:	01 88 80 00 00 00    	add    %ecx,0x80(%eax)
	return curenv->env_sbrk;
f0105522:	e8 e3 19 00 00       	call   f0106f0a <cpunum>
f0105527:	6b c0 74             	imul   $0x74,%eax,%eax
f010552a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105530:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f0105536:	e9 19 fd ff ff       	jmp    f0105254 <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f010553b:	83 ec 04             	sub    $0x4,%esp
f010553e:	68 cc 9e 10 f0       	push   $0xf0109ecc
f0105543:	68 2d 02 00 00       	push   $0x22d
f0105548:	68 bb 9e 10 f0       	push   $0xf0109ebb
f010554d:	e8 f7 aa ff ff       	call   f0100049 <_panic>
	sched_yield();
f0105552:	e8 57 fb ff ff       	call   f01050ae <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105557:	e8 ae 19 00 00       	call   f0106f0a <cpunum>
f010555c:	83 ec 08             	sub    $0x8,%esp
f010555f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105562:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105568:	ff 70 48             	pushl  0x48(%eax)
f010556b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010556e:	50                   	push   %eax
f010556f:	e8 1b e2 ff ff       	call   f010378f <env_alloc>
f0105574:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105576:	83 c4 10             	add    $0x10,%esp
f0105579:	85 c0                	test   %eax,%eax
f010557b:	0f 88 d3 fc ff ff    	js     f0105254 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f0105581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105584:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f010558b:	e8 7a 19 00 00       	call   f0106f0a <cpunum>
f0105590:	6b c0 74             	imul   $0x74,%eax,%eax
f0105593:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0105599:	b9 11 00 00 00       	mov    $0x11,%ecx
f010559e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01055a1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01055a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055a6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01055ad:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01055b0:	e9 9f fc ff ff       	jmp    f0105254 <syscall+0x52>
	switch (status)
f01055b5:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01055b9:	74 06                	je     f01055c1 <syscall+0x3bf>
f01055bb:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f01055bf:	75 54                	jne    f0105615 <syscall+0x413>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01055c1:	8b 45 10             	mov    0x10(%ebp),%eax
f01055c4:	83 e8 02             	sub    $0x2,%eax
f01055c7:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01055cc:	75 31                	jne    f01055ff <syscall+0x3fd>
	int ret = envid2env(envid, &e, 1);
f01055ce:	83 ec 04             	sub    $0x4,%esp
f01055d1:	6a 01                	push   $0x1
f01055d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01055d6:	50                   	push   %eax
f01055d7:	ff 75 0c             	pushl  0xc(%ebp)
f01055da:	e8 68 e0 ff ff       	call   f0103647 <envid2env>
f01055df:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01055e1:	83 c4 10             	add    $0x10,%esp
f01055e4:	85 c0                	test   %eax,%eax
f01055e6:	0f 88 68 fc ff ff    	js     f0105254 <syscall+0x52>
	e->env_status = status;
f01055ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01055f2:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f01055f5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01055fa:	e9 55 fc ff ff       	jmp    f0105254 <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01055ff:	68 f8 9e 10 f0       	push   $0xf0109ef8
f0105604:	68 8b 92 10 f0       	push   $0xf010928b
f0105609:	6a 7b                	push   $0x7b
f010560b:	68 bb 9e 10 f0       	push   $0xf0109ebb
f0105610:	e8 34 aa ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f0105615:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010561a:	e9 35 fc ff ff       	jmp    f0105254 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f010561f:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105626:	0f 87 e5 00 00 00    	ja     f0105711 <syscall+0x50f>
f010562c:	8b 45 10             	mov    0x10(%ebp),%eax
f010562f:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105634:	8b 55 14             	mov    0x14(%ebp),%edx
f0105637:	83 e2 05             	and    $0x5,%edx
f010563a:	83 fa 05             	cmp    $0x5,%edx
f010563d:	0f 85 d8 00 00 00    	jne    f010571b <syscall+0x519>
	if(perm & ~PTE_SYSCALL)
f0105643:	8b 75 14             	mov    0x14(%ebp),%esi
f0105646:	81 e6 f8 f1 ff ff    	and    $0xfffff1f8,%esi
f010564c:	09 c6                	or     %eax,%esi
f010564e:	0f 85 d1 00 00 00    	jne    f0105725 <syscall+0x523>
	int ret = envid2env(envid, &e, 1);
f0105654:	83 ec 04             	sub    $0x4,%esp
f0105657:	6a 01                	push   $0x1
f0105659:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010565c:	50                   	push   %eax
f010565d:	ff 75 0c             	pushl  0xc(%ebp)
f0105660:	e8 e2 df ff ff       	call   f0103647 <envid2env>
f0105665:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105667:	83 c4 10             	add    $0x10,%esp
f010566a:	85 c0                	test   %eax,%eax
f010566c:	0f 88 e2 fb ff ff    	js     f0105254 <syscall+0x52>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0105672:	83 ec 0c             	sub    $0xc,%esp
f0105675:	6a 01                	push   $0x1
f0105677:	e8 c1 bc ff ff       	call   f010133d <page_alloc>
f010567c:	89 c7                	mov    %eax,%edi
	if(page == NULL)
f010567e:	83 c4 10             	add    $0x10,%esp
f0105681:	85 c0                	test   %eax,%eax
f0105683:	0f 84 a6 00 00 00    	je     f010572f <syscall+0x52d>
	return (pp - pages) << PGSHIFT;
f0105689:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010568f:	c1 f8 03             	sar    $0x3,%eax
f0105692:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0105695:	89 c2                	mov    %eax,%edx
f0105697:	c1 ea 0c             	shr    $0xc,%edx
f010569a:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f01056a0:	73 4c                	jae    f01056ee <syscall+0x4ec>
	memset(page2kva(page), 0, PGSIZE);
f01056a2:	83 ec 04             	sub    $0x4,%esp
f01056a5:	68 00 10 00 00       	push   $0x1000
f01056aa:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01056ac:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01056b1:	50                   	push   %eax
f01056b2:	e8 4d 12 00 00       	call   f0106904 <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f01056b7:	ff 75 14             	pushl  0x14(%ebp)
f01056ba:	ff 75 10             	pushl  0x10(%ebp)
f01056bd:	57                   	push   %edi
f01056be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01056c1:	ff 70 60             	pushl  0x60(%eax)
f01056c4:	e8 b0 bf ff ff       	call   f0101679 <page_insert>
f01056c9:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f01056cb:	83 c4 20             	add    $0x20,%esp
f01056ce:	85 c0                	test   %eax,%eax
f01056d0:	78 2e                	js     f0105700 <syscall+0x4fe>
	e->env_kern_pgdir[PDX(va)] = e->env_pgdir[PDX(va)];
f01056d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01056d5:	8b 45 10             	mov    0x10(%ebp),%eax
f01056d8:	c1 e8 16             	shr    $0x16,%eax
f01056db:	8b 4a 60             	mov    0x60(%edx),%ecx
f01056de:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
f01056e1:	8b 52 64             	mov    0x64(%edx),%edx
f01056e4:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
	return 0;
f01056e7:	89 f3                	mov    %esi,%ebx
f01056e9:	e9 66 fb ff ff       	jmp    f0105254 <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01056ee:	50                   	push   %eax
f01056ef:	68 74 80 10 f0       	push   $0xf0108074
f01056f4:	6a 58                	push   $0x58
f01056f6:	68 71 92 10 f0       	push   $0xf0109271
f01056fb:	e8 49 a9 ff ff       	call   f0100049 <_panic>
		page_free(page);
f0105700:	83 ec 0c             	sub    $0xc,%esp
f0105703:	57                   	push   %edi
f0105704:	e8 a6 bc ff ff       	call   f01013af <page_free>
f0105709:	83 c4 10             	add    $0x10,%esp
f010570c:	e9 43 fb ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f0105711:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105716:	e9 39 fb ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f010571b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105720:	e9 2f fb ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f0105725:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010572a:	e9 25 fb ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_NO_MEM;
f010572f:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105734:	e9 1b fb ff ff       	jmp    f0105254 <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105739:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010573c:	83 e0 05             	and    $0x5,%eax
f010573f:	83 f8 05             	cmp    $0x5,%eax
f0105742:	0f 85 dd 00 00 00    	jne    f0105825 <syscall+0x623>
	if(perm & ~PTE_SYSCALL)
f0105748:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010574b:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f0105750:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105757:	0f 87 d2 00 00 00    	ja     f010582f <syscall+0x62d>
f010575d:	8b 55 10             	mov    0x10(%ebp),%edx
f0105760:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f0105766:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010576d:	0f 87 c6 00 00 00    	ja     f0105839 <syscall+0x637>
f0105773:	09 d0                	or     %edx,%eax
f0105775:	8b 55 18             	mov    0x18(%ebp),%edx
f0105778:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f010577e:	09 d0                	or     %edx,%eax
f0105780:	0f 85 bd 00 00 00    	jne    f0105843 <syscall+0x641>
	int ret = envid2env(srcenvid, &src_env, 1);
f0105786:	83 ec 04             	sub    $0x4,%esp
f0105789:	6a 01                	push   $0x1
f010578b:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010578e:	50                   	push   %eax
f010578f:	ff 75 0c             	pushl  0xc(%ebp)
f0105792:	e8 b0 de ff ff       	call   f0103647 <envid2env>
f0105797:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105799:	83 c4 10             	add    $0x10,%esp
f010579c:	85 c0                	test   %eax,%eax
f010579e:	0f 88 b0 fa ff ff    	js     f0105254 <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f01057a4:	83 ec 04             	sub    $0x4,%esp
f01057a7:	6a 01                	push   $0x1
f01057a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01057ac:	50                   	push   %eax
f01057ad:	ff 75 14             	pushl  0x14(%ebp)
f01057b0:	e8 92 de ff ff       	call   f0103647 <envid2env>
f01057b5:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01057b7:	83 c4 10             	add    $0x10,%esp
f01057ba:	85 c0                	test   %eax,%eax
f01057bc:	0f 88 92 fa ff ff    	js     f0105254 <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f01057c2:	83 ec 04             	sub    $0x4,%esp
f01057c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01057c8:	50                   	push   %eax
f01057c9:	ff 75 10             	pushl  0x10(%ebp)
f01057cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01057cf:	ff 70 60             	pushl  0x60(%eax)
f01057d2:	e8 c2 bd ff ff       	call   f0101599 <page_lookup>
	if(src_page == NULL)
f01057d7:	83 c4 10             	add    $0x10,%esp
f01057da:	85 c0                	test   %eax,%eax
f01057dc:	74 6f                	je     f010584d <syscall+0x64b>
	if(perm & PTE_W){
f01057de:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01057e2:	74 08                	je     f01057ec <syscall+0x5ea>
		if((*pte_store & PTE_W) == 0)
f01057e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01057e7:	f6 02 02             	testb  $0x2,(%edx)
f01057ea:	74 6b                	je     f0105857 <syscall+0x655>
	int r = page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f01057ec:	ff 75 1c             	pushl  0x1c(%ebp)
f01057ef:	ff 75 18             	pushl  0x18(%ebp)
f01057f2:	50                   	push   %eax
f01057f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057f6:	ff 70 60             	pushl  0x60(%eax)
f01057f9:	e8 7b be ff ff       	call   f0101679 <page_insert>
f01057fe:	89 c3                	mov    %eax,%ebx
	if(r >= 0)
f0105800:	83 c4 10             	add    $0x10,%esp
f0105803:	85 c0                	test   %eax,%eax
f0105805:	0f 88 49 fa ff ff    	js     f0105254 <syscall+0x52>
		dst_env->env_kern_pgdir[PDX(dstva)] = dst_env->env_pgdir[PDX(dstva)];
f010580b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010580e:	8b 45 18             	mov    0x18(%ebp),%eax
f0105811:	c1 e8 16             	shr    $0x16,%eax
f0105814:	8b 4a 60             	mov    0x60(%edx),%ecx
f0105817:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
f010581a:	8b 52 64             	mov    0x64(%edx),%edx
f010581d:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
f0105820:	e9 2f fa ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f0105825:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010582a:	e9 25 fa ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f010582f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105834:	e9 1b fa ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f0105839:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010583e:	e9 11 fa ff ff       	jmp    f0105254 <syscall+0x52>
f0105843:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105848:	e9 07 fa ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f010584d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105852:	e9 fd f9 ff ff       	jmp    f0105254 <syscall+0x52>
			return -E_INVAL;
f0105857:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010585c:	e9 f3 f9 ff ff       	jmp    f0105254 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105861:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105868:	77 45                	ja     f01058af <syscall+0x6ad>
f010586a:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105871:	75 46                	jne    f01058b9 <syscall+0x6b7>
	int ret = envid2env(envid, &env, 1);
f0105873:	83 ec 04             	sub    $0x4,%esp
f0105876:	6a 01                	push   $0x1
f0105878:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010587b:	50                   	push   %eax
f010587c:	ff 75 0c             	pushl  0xc(%ebp)
f010587f:	e8 c3 dd ff ff       	call   f0103647 <envid2env>
f0105884:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105886:	83 c4 10             	add    $0x10,%esp
f0105889:	85 c0                	test   %eax,%eax
f010588b:	0f 88 c3 f9 ff ff    	js     f0105254 <syscall+0x52>
	page_remove(env->env_pgdir, va);
f0105891:	83 ec 08             	sub    $0x8,%esp
f0105894:	ff 75 10             	pushl  0x10(%ebp)
f0105897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010589a:	ff 70 60             	pushl  0x60(%eax)
f010589d:	e8 91 bd ff ff       	call   f0101633 <page_remove>
f01058a2:	83 c4 10             	add    $0x10,%esp
	return 0;
f01058a5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01058aa:	e9 a5 f9 ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f01058af:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01058b4:	e9 9b f9 ff ff       	jmp    f0105254 <syscall+0x52>
f01058b9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01058be:	e9 91 f9 ff ff       	jmp    f0105254 <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f01058c3:	83 ec 04             	sub    $0x4,%esp
f01058c6:	6a 00                	push   $0x0
f01058c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01058cb:	50                   	push   %eax
f01058cc:	ff 75 0c             	pushl  0xc(%ebp)
f01058cf:	e8 73 dd ff ff       	call   f0103647 <envid2env>
f01058d4:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f01058d6:	83 c4 10             	add    $0x10,%esp
f01058d9:	85 c0                	test   %eax,%eax
f01058db:	0f 88 73 f9 ff ff    	js     f0105254 <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f01058e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058e4:	80 78 6c 00          	cmpb   $0x0,0x6c(%eax)
f01058e8:	0f 84 11 01 00 00    	je     f01059ff <syscall+0x7fd>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f01058ee:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01058f5:	77 78                	ja     f010596f <syscall+0x76d>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01058f7:	8b 45 18             	mov    0x18(%ebp),%eax
f01058fa:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f01058fd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105902:	83 f8 05             	cmp    $0x5,%eax
f0105905:	0f 85 49 f9 ff ff    	jne    f0105254 <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f010590b:	8b 55 14             	mov    0x14(%ebp),%edx
f010590e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f0105914:	8b 45 18             	mov    0x18(%ebp),%eax
f0105917:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f010591c:	09 c2                	or     %eax,%edx
f010591e:	0f 85 30 f9 ff ff    	jne    f0105254 <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105924:	e8 e1 15 00 00       	call   f0106f0a <cpunum>
f0105929:	83 ec 04             	sub    $0x4,%esp
f010592c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010592f:	52                   	push   %edx
f0105930:	ff 75 14             	pushl  0x14(%ebp)
f0105933:	6b c0 74             	imul   $0x74,%eax,%eax
f0105936:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010593c:	ff 70 60             	pushl  0x60(%eax)
f010593f:	e8 55 bc ff ff       	call   f0101599 <page_lookup>
		if(!page)
f0105944:	83 c4 10             	add    $0x10,%esp
f0105947:	85 c0                	test   %eax,%eax
f0105949:	0f 84 a6 00 00 00    	je     f01059f5 <syscall+0x7f3>
		if((perm & PTE_W) && !(*pte & PTE_W))
f010594f:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105953:	74 0c                	je     f0105961 <syscall+0x75f>
f0105955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105958:	f6 02 02             	testb  $0x2,(%edx)
f010595b:	0f 84 f3 f8 ff ff    	je     f0105254 <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105961:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105964:	8b 4a 70             	mov    0x70(%edx),%ecx
f0105967:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010596d:	76 52                	jbe    f01059c1 <syscall+0x7bf>
	dst_env->env_ipc_recving = 0;
f010596f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105972:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105976:	e8 8f 15 00 00       	call   f0106f0a <cpunum>
f010597b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010597e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105981:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105987:	8b 40 48             	mov    0x48(%eax),%eax
f010598a:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_ipc_value = value;
f010598d:	8b 45 10             	mov    0x10(%ebp),%eax
f0105990:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f0105993:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f010599a:	b8 00 00 00 00       	mov    $0x0,%eax
f010599f:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f01059a3:	89 45 18             	mov    %eax,0x18(%ebp)
f01059a6:	89 42 7c             	mov    %eax,0x7c(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f01059a9:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f01059b0:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f01059b7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01059bc:	e9 93 f8 ff ff       	jmp    f0105254 <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f01059c1:	ff 75 18             	pushl  0x18(%ebp)
f01059c4:	51                   	push   %ecx
f01059c5:	50                   	push   %eax
f01059c6:	ff 72 60             	pushl  0x60(%edx)
f01059c9:	e8 ab bc ff ff       	call   f0101679 <page_insert>
f01059ce:	89 c3                	mov    %eax,%ebx
			if(ret < 0)
f01059d0:	83 c4 10             	add    $0x10,%esp
f01059d3:	85 c0                	test   %eax,%eax
f01059d5:	0f 88 79 f8 ff ff    	js     f0105254 <syscall+0x52>
			dst_env->env_kern_pgdir[PDX(dst_env->env_ipc_dstva)] = dst_env->env_pgdir[PDX(dst_env->env_ipc_dstva)];
f01059db:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01059de:	8b 42 70             	mov    0x70(%edx),%eax
f01059e1:	c1 e8 16             	shr    $0x16,%eax
f01059e4:	8b 4a 60             	mov    0x60(%edx),%ecx
f01059e7:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
f01059ea:	8b 52 64             	mov    0x64(%edx),%edx
f01059ed:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
f01059f0:	e9 7a ff ff ff       	jmp    f010596f <syscall+0x76d>
			return -E_INVAL;		
f01059f5:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01059fa:	e9 55 f8 ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_IPC_NOT_RECV;
f01059ff:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f0105a04:	e9 4b f8 ff ff       	jmp    f0105254 <syscall+0x52>
	if(dstva < (void *)UTOP){
f0105a09:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105a10:	77 13                	ja     f0105a25 <syscall+0x823>
		if((uint32_t)dstva % PGSIZE != 0)
f0105a12:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0105a19:	74 0a                	je     f0105a25 <syscall+0x823>
			ret = sys_ipc_recv((void *)a1);
f0105a1b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f0105a20:	e9 2f f8 ff ff       	jmp    f0105254 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f0105a25:	e8 e0 14 00 00       	call   f0106f0a <cpunum>
f0105a2a:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a2d:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105a33:	c6 40 6c 01          	movb   $0x1,0x6c(%eax)
	curenv->env_ipc_dstva = dstva;
f0105a37:	e8 ce 14 00 00       	call   f0106f0a <cpunum>
f0105a3c:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a3f:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105a48:	89 48 70             	mov    %ecx,0x70(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105a4b:	e8 ba 14 00 00       	call   f0106f0a <cpunum>
f0105a50:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a53:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105a59:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105a60:	e8 49 f6 ff ff       	call   f01050ae <sched_yield>
	int ret = envid2env(envid, &e, 1);
f0105a65:	83 ec 04             	sub    $0x4,%esp
f0105a68:	6a 01                	push   $0x1
f0105a6a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a6d:	50                   	push   %eax
f0105a6e:	ff 75 0c             	pushl  0xc(%ebp)
f0105a71:	e8 d1 db ff ff       	call   f0103647 <envid2env>
f0105a76:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105a78:	83 c4 10             	add    $0x10,%esp
f0105a7b:	85 c0                	test   %eax,%eax
f0105a7d:	0f 88 d1 f7 ff ff    	js     f0105254 <syscall+0x52>
	e->env_pgfault_upcall = func;
f0105a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a86:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105a89:	89 48 68             	mov    %ecx,0x68(%eax)
	return 0;
f0105a8c:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105a91:	e9 be f7 ff ff       	jmp    f0105254 <syscall+0x52>
	r = envid2env(envid, &e, 0);
f0105a96:	83 ec 04             	sub    $0x4,%esp
f0105a99:	6a 00                	push   $0x0
f0105a9b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a9e:	50                   	push   %eax
f0105a9f:	ff 75 0c             	pushl  0xc(%ebp)
f0105aa2:	e8 a0 db ff ff       	call   f0103647 <envid2env>
f0105aa7:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f0105aa9:	83 c4 10             	add    $0x10,%esp
f0105aac:	85 c0                	test   %eax,%eax
f0105aae:	0f 88 a0 f7 ff ff    	js     f0105254 <syscall+0x52>
	e->env_tf = *tf;
f0105ab4:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105ab9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105abc:	8b 75 10             	mov    0x10(%ebp),%esi
f0105abf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f0105ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105ac4:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f0105ac9:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f0105ad0:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105ad5:	e9 7a f7 ff ff       	jmp    f0105254 <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f0105ada:	83 ec 04             	sub    $0x4,%esp
f0105add:	6a 00                	push   $0x0
f0105adf:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105ae2:	50                   	push   %eax
f0105ae3:	ff 75 0c             	pushl  0xc(%ebp)
f0105ae6:	e8 5c db ff ff       	call   f0103647 <envid2env>
f0105aeb:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105aed:	83 c4 10             	add    $0x10,%esp
f0105af0:	85 c0                	test   %eax,%eax
f0105af2:	0f 88 5c f7 ff ff    	js     f0105254 <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f0105af8:	83 ec 04             	sub    $0x4,%esp
f0105afb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105afe:	50                   	push   %eax
f0105aff:	ff 75 10             	pushl  0x10(%ebp)
f0105b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b05:	ff 70 60             	pushl  0x60(%eax)
f0105b08:	e8 8c ba ff ff       	call   f0101599 <page_lookup>
	if(page == NULL)
f0105b0d:	83 c4 10             	add    $0x10,%esp
f0105b10:	85 c0                	test   %eax,%eax
f0105b12:	74 16                	je     f0105b2a <syscall+0x928>
	*pte_store |= PTE_A;
f0105b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b17:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f0105b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b1d:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f0105b20:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105b25:	e9 2a f7 ff ff       	jmp    f0105254 <syscall+0x52>
		return -E_INVAL;
f0105b2a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105b2f:	e9 20 f7 ff ff       	jmp    f0105254 <syscall+0x52>
	return time_msec();
f0105b34:	e8 74 22 00 00       	call   f0107dad <time_msec>
f0105b39:	89 c3                	mov    %eax,%ebx
			break;
f0105b3b:	e9 14 f7 ff ff       	jmp    f0105254 <syscall+0x52>
			ret = sys_net_send((void *)a1, (uint32_t)a2);
f0105b40:	83 ec 08             	sub    $0x8,%esp
f0105b43:	ff 75 10             	pushl  0x10(%ebp)
f0105b46:	ff 75 0c             	pushl  0xc(%ebp)
f0105b49:	e8 1b f6 ff ff       	call   f0105169 <sys_net_send>
f0105b4e:	89 c3                	mov    %eax,%ebx
			break;
f0105b50:	83 c4 10             	add    $0x10,%esp
f0105b53:	e9 fc f6 ff ff       	jmp    f0105254 <syscall+0x52>
			ret = sys_net_recv((void *)a1, (uint32_t)a2);
f0105b58:	83 ec 08             	sub    $0x8,%esp
f0105b5b:	ff 75 10             	pushl  0x10(%ebp)
f0105b5e:	ff 75 0c             	pushl  0xc(%ebp)
f0105b61:	e8 5e f6 ff ff       	call   f01051c4 <sys_net_recv>
f0105b66:	89 c3                	mov    %eax,%ebx
			break;
f0105b68:	83 c4 10             	add    $0x10,%esp
f0105b6b:	e9 e4 f6 ff ff       	jmp    f0105254 <syscall+0x52>
	*mac_addr_store = read_eeprom_mac_addr();
f0105b70:	e8 c3 17 00 00       	call   f0107338 <read_eeprom_mac_addr>
f0105b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105b78:	89 01                	mov    %eax,(%ecx)
f0105b7a:	89 51 04             	mov    %edx,0x4(%ecx)
	cprintf("in sys_get_mac_addr the mac_addr is 0x%016lx\n", *mac_addr_store);
f0105b7d:	83 ec 04             	sub    $0x4,%esp
f0105b80:	52                   	push   %edx
f0105b81:	50                   	push   %eax
f0105b82:	68 30 9f 10 f0       	push   $0xf0109f30
f0105b87:	e8 6a e6 ff ff       	call   f01041f6 <cprintf>
f0105b8c:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f0105b8f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105b94:	e9 bb f6 ff ff       	jmp    f0105254 <syscall+0x52>
			ret = -E_INVAL;
f0105b99:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105b9e:	e9 b1 f6 ff ff       	jmp    f0105254 <syscall+0x52>
        return E_INVAL;
f0105ba3:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105ba8:	e9 a7 f6 ff ff       	jmp    f0105254 <syscall+0x52>

f0105bad <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105bad:	55                   	push   %ebp
f0105bae:	89 e5                	mov    %esp,%ebp
f0105bb0:	57                   	push   %edi
f0105bb1:	56                   	push   %esi
f0105bb2:	53                   	push   %ebx
f0105bb3:	83 ec 14             	sub    $0x14,%esp
f0105bb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105bb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105bbc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105bbf:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105bc2:	8b 1a                	mov    (%edx),%ebx
f0105bc4:	8b 01                	mov    (%ecx),%eax
f0105bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105bc9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105bd0:	eb 23                	jmp    f0105bf5 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105bd2:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105bd5:	eb 1e                	jmp    f0105bf5 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105bd7:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105bda:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105bdd:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105be1:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105be4:	73 41                	jae    f0105c27 <stab_binsearch+0x7a>
			*region_left = m;
f0105be6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105be9:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0105beb:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0105bee:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0105bf5:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0105bf8:	7f 5a                	jg     f0105c54 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0105bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105bfd:	01 d8                	add    %ebx,%eax
f0105bff:	89 c7                	mov    %eax,%edi
f0105c01:	c1 ef 1f             	shr    $0x1f,%edi
f0105c04:	01 c7                	add    %eax,%edi
f0105c06:	d1 ff                	sar    %edi
f0105c08:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105c0b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105c0e:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0105c12:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0105c14:	39 c3                	cmp    %eax,%ebx
f0105c16:	7f ba                	jg     f0105bd2 <stab_binsearch+0x25>
f0105c18:	0f b6 0a             	movzbl (%edx),%ecx
f0105c1b:	83 ea 0c             	sub    $0xc,%edx
f0105c1e:	39 f1                	cmp    %esi,%ecx
f0105c20:	74 b5                	je     f0105bd7 <stab_binsearch+0x2a>
			m--;
f0105c22:	83 e8 01             	sub    $0x1,%eax
f0105c25:	eb ed                	jmp    f0105c14 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0105c27:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105c2a:	76 14                	jbe    f0105c40 <stab_binsearch+0x93>
			*region_right = m - 1;
f0105c2c:	83 e8 01             	sub    $0x1,%eax
f0105c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105c32:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105c35:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0105c37:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105c3e:	eb b5                	jmp    f0105bf5 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105c40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105c43:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0105c45:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105c49:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0105c4b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105c52:	eb a1                	jmp    f0105bf5 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105c54:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105c58:	75 15                	jne    f0105c6f <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0105c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105c5d:	8b 00                	mov    (%eax),%eax
f0105c5f:	83 e8 01             	sub    $0x1,%eax
f0105c62:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105c65:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105c67:	83 c4 14             	add    $0x14,%esp
f0105c6a:	5b                   	pop    %ebx
f0105c6b:	5e                   	pop    %esi
f0105c6c:	5f                   	pop    %edi
f0105c6d:	5d                   	pop    %ebp
f0105c6e:	c3                   	ret    
		for (l = *region_right;
f0105c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105c72:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105c74:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105c77:	8b 0f                	mov    (%edi),%ecx
f0105c79:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105c7c:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0105c7f:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105c83:	eb 03                	jmp    f0105c88 <stab_binsearch+0xdb>
		     l--)
f0105c85:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105c88:	39 c1                	cmp    %eax,%ecx
f0105c8a:	7d 0a                	jge    f0105c96 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0105c8c:	0f b6 1a             	movzbl (%edx),%ebx
f0105c8f:	83 ea 0c             	sub    $0xc,%edx
f0105c92:	39 f3                	cmp    %esi,%ebx
f0105c94:	75 ef                	jne    f0105c85 <stab_binsearch+0xd8>
		*region_left = l;
f0105c96:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105c99:	89 06                	mov    %eax,(%esi)
}
f0105c9b:	eb ca                	jmp    f0105c67 <stab_binsearch+0xba>

f0105c9d <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105c9d:	55                   	push   %ebp
f0105c9e:	89 e5                	mov    %esp,%ebp
f0105ca0:	57                   	push   %edi
f0105ca1:	56                   	push   %esi
f0105ca2:	53                   	push   %ebx
f0105ca3:	83 ec 4c             	sub    $0x4c,%esp
f0105ca6:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105ca9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105cac:	c7 03 b8 9f 10 f0    	movl   $0xf0109fb8,(%ebx)
	info->eip_line = 0;
f0105cb2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105cb9:	c7 43 08 b8 9f 10 f0 	movl   $0xf0109fb8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105cc0:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105cc7:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105cca:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105cd1:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0105cd7:	0f 86 23 01 00 00    	jbe    f0105e00 <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105cdd:	c7 45 b8 0f 00 12 f0 	movl   $0xf012000f,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0105ce4:	c7 45 b4 49 b2 11 f0 	movl   $0xf011b249,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0105ceb:	be 48 b2 11 f0       	mov    $0xf011b248,%esi
		stabs = __STAB_BEGIN__;
f0105cf0:	c7 45 bc 8c a8 10 f0 	movl   $0xf010a88c,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105cf7:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105cfa:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f0105cfd:	0f 83 59 02 00 00    	jae    f0105f5c <debuginfo_eip+0x2bf>
f0105d03:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0105d07:	0f 85 56 02 00 00    	jne    f0105f63 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105d0d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105d14:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0105d17:	c1 fe 02             	sar    $0x2,%esi
f0105d1a:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0105d20:	83 e8 01             	sub    $0x1,%eax
f0105d23:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105d26:	83 ec 08             	sub    $0x8,%esp
f0105d29:	57                   	push   %edi
f0105d2a:	6a 64                	push   $0x64
f0105d2c:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0105d2f:	89 d1                	mov    %edx,%ecx
f0105d31:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105d34:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105d37:	89 f0                	mov    %esi,%eax
f0105d39:	e8 6f fe ff ff       	call   f0105bad <stab_binsearch>
	if (lfile == 0)
f0105d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105d41:	83 c4 10             	add    $0x10,%esp
f0105d44:	85 c0                	test   %eax,%eax
f0105d46:	0f 84 1e 02 00 00    	je     f0105f6a <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105d4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d52:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105d55:	83 ec 08             	sub    $0x8,%esp
f0105d58:	57                   	push   %edi
f0105d59:	6a 24                	push   $0x24
f0105d5b:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105d5e:	89 d1                	mov    %edx,%ecx
f0105d60:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105d63:	89 f0                	mov    %esi,%eax
f0105d65:	e8 43 fe ff ff       	call   f0105bad <stab_binsearch>

	if (lfun <= rfun) {
f0105d6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105d6d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105d70:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105d73:	83 c4 10             	add    $0x10,%esp
f0105d76:	39 c8                	cmp    %ecx,%eax
f0105d78:	0f 8f 26 01 00 00    	jg     f0105ea4 <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105d7e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105d81:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f0105d84:	8b 11                	mov    (%ecx),%edx
f0105d86:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0105d89:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105d8c:	39 f2                	cmp    %esi,%edx
f0105d8e:	73 06                	jae    f0105d96 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105d90:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105d93:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105d96:	8b 51 08             	mov    0x8(%ecx),%edx
f0105d99:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105d9c:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105d9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105da1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105da4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105da7:	83 ec 08             	sub    $0x8,%esp
f0105daa:	6a 3a                	push   $0x3a
f0105dac:	ff 73 08             	pushl  0x8(%ebx)
f0105daf:	e8 34 0b 00 00       	call   f01068e8 <strfind>
f0105db4:	2b 43 08             	sub    0x8(%ebx),%eax
f0105db7:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105dba:	83 c4 08             	add    $0x8,%esp
f0105dbd:	57                   	push   %edi
f0105dbe:	6a 44                	push   $0x44
f0105dc0:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105dc3:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105dc6:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105dc9:	89 f0                	mov    %esi,%eax
f0105dcb:	e8 dd fd ff ff       	call   f0105bad <stab_binsearch>
	if(lline <= rline){
f0105dd0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105dd3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105dd6:	83 c4 10             	add    $0x10,%esp
f0105dd9:	39 c2                	cmp    %eax,%edx
f0105ddb:	0f 8f 90 01 00 00    	jg     f0105f71 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f0105de1:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105de4:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105de8:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105deb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105dee:	89 d0                	mov    %edx,%eax
f0105df0:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105df3:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105df7:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0105dfb:	e9 c2 00 00 00       	jmp    f0105ec2 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f0105e00:	e8 05 11 00 00       	call   f0106f0a <cpunum>
f0105e05:	6a 06                	push   $0x6
f0105e07:	6a 10                	push   $0x10
f0105e09:	68 00 00 20 00       	push   $0x200000
f0105e0e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e11:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105e17:	e8 35 d6 ff ff       	call   f0103451 <user_mem_check>
f0105e1c:	83 c4 10             	add    $0x10,%esp
f0105e1f:	85 c0                	test   %eax,%eax
f0105e21:	0f 88 27 01 00 00    	js     f0105f4e <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f0105e27:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105e2d:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105e30:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105e36:	a1 08 00 20 00       	mov    0x200008,%eax
f0105e3b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105e3e:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105e44:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f0105e47:	e8 be 10 00 00       	call   f0106f0a <cpunum>
f0105e4c:	6a 06                	push   $0x6
f0105e4e:	89 f2                	mov    %esi,%edx
f0105e50:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105e53:	29 ca                	sub    %ecx,%edx
f0105e55:	52                   	push   %edx
f0105e56:	51                   	push   %ecx
f0105e57:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e5a:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105e60:	e8 ec d5 ff ff       	call   f0103451 <user_mem_check>
f0105e65:	83 c4 10             	add    $0x10,%esp
f0105e68:	85 c0                	test   %eax,%eax
f0105e6a:	0f 88 e5 00 00 00    	js     f0105f55 <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105e70:	e8 95 10 00 00       	call   f0106f0a <cpunum>
f0105e75:	6a 06                	push   $0x6
f0105e77:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105e7a:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105e7d:	29 ca                	sub    %ecx,%edx
f0105e7f:	52                   	push   %edx
f0105e80:	51                   	push   %ecx
f0105e81:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e84:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105e8a:	e8 c2 d5 ff ff       	call   f0103451 <user_mem_check>
f0105e8f:	83 c4 10             	add    $0x10,%esp
f0105e92:	85 c0                	test   %eax,%eax
f0105e94:	0f 89 5d fe ff ff    	jns    f0105cf7 <debuginfo_eip+0x5a>
			return -1;
f0105e9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e9f:	e9 d9 00 00 00       	jmp    f0105f7d <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105ea4:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105eaa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105ead:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105eb0:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105eb3:	e9 ef fe ff ff       	jmp    f0105da7 <debuginfo_eip+0x10a>
f0105eb8:	83 e8 01             	sub    $0x1,%eax
f0105ebb:	83 ea 0c             	sub    $0xc,%edx
f0105ebe:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105ec2:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105ec5:	39 c7                	cmp    %eax,%edi
f0105ec7:	7f 45                	jg     f0105f0e <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f0105ec9:	0f b6 0a             	movzbl (%edx),%ecx
f0105ecc:	80 f9 84             	cmp    $0x84,%cl
f0105ecf:	74 19                	je     f0105eea <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105ed1:	80 f9 64             	cmp    $0x64,%cl
f0105ed4:	75 e2                	jne    f0105eb8 <debuginfo_eip+0x21b>
f0105ed6:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105eda:	74 dc                	je     f0105eb8 <debuginfo_eip+0x21b>
f0105edc:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105ee0:	74 11                	je     f0105ef3 <debuginfo_eip+0x256>
f0105ee2:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105ee5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105ee8:	eb 09                	jmp    f0105ef3 <debuginfo_eip+0x256>
f0105eea:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105eee:	74 03                	je     f0105ef3 <debuginfo_eip+0x256>
f0105ef0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105ef3:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105ef6:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105ef9:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105efc:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105eff:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105f02:	29 f8                	sub    %edi,%eax
f0105f04:	39 c2                	cmp    %eax,%edx
f0105f06:	73 06                	jae    f0105f0e <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105f08:	89 f8                	mov    %edi,%eax
f0105f0a:	01 d0                	add    %edx,%eax
f0105f0c:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105f0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105f11:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f0105f14:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105f19:	39 f2                	cmp    %esi,%edx
f0105f1b:	7d 60                	jge    f0105f7d <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0105f1d:	83 c2 01             	add    $0x1,%edx
f0105f20:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105f23:	89 d0                	mov    %edx,%eax
f0105f25:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105f28:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105f2b:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105f2f:	eb 04                	jmp    f0105f35 <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f0105f31:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105f35:	39 c6                	cmp    %eax,%esi
f0105f37:	7e 3f                	jle    f0105f78 <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105f39:	0f b6 0a             	movzbl (%edx),%ecx
f0105f3c:	83 c0 01             	add    $0x1,%eax
f0105f3f:	83 c2 0c             	add    $0xc,%edx
f0105f42:	80 f9 a0             	cmp    $0xa0,%cl
f0105f45:	74 ea                	je     f0105f31 <debuginfo_eip+0x294>
	return 0;
f0105f47:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f4c:	eb 2f                	jmp    f0105f7d <debuginfo_eip+0x2e0>
			return -1;
f0105f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f53:	eb 28                	jmp    f0105f7d <debuginfo_eip+0x2e0>
			return -1;
f0105f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f5a:	eb 21                	jmp    f0105f7d <debuginfo_eip+0x2e0>
		return -1;
f0105f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f61:	eb 1a                	jmp    f0105f7d <debuginfo_eip+0x2e0>
f0105f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f68:	eb 13                	jmp    f0105f7d <debuginfo_eip+0x2e0>
		return -1;
f0105f6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f6f:	eb 0c                	jmp    f0105f7d <debuginfo_eip+0x2e0>
		return -1;
f0105f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f76:	eb 05                	jmp    f0105f7d <debuginfo_eip+0x2e0>
	return 0;
f0105f78:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105f80:	5b                   	pop    %ebx
f0105f81:	5e                   	pop    %esi
f0105f82:	5f                   	pop    %edi
f0105f83:	5d                   	pop    %ebp
f0105f84:	c3                   	ret    

f0105f85 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105f85:	55                   	push   %ebp
f0105f86:	89 e5                	mov    %esp,%ebp
f0105f88:	57                   	push   %edi
f0105f89:	56                   	push   %esi
f0105f8a:	53                   	push   %ebx
f0105f8b:	83 ec 1c             	sub    $0x1c,%esp
f0105f8e:	89 c6                	mov    %eax,%esi
f0105f90:	89 d7                	mov    %edx,%edi
f0105f92:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f95:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105f98:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105f9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105f9e:	8b 45 10             	mov    0x10(%ebp),%eax
f0105fa1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105fa4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105fa8:	74 2c                	je     f0105fd6 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f0105faa:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105fad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105fb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105fb7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105fba:	39 c2                	cmp    %eax,%edx
f0105fbc:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105fbf:	73 43                	jae    f0106004 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105fc1:	83 eb 01             	sub    $0x1,%ebx
f0105fc4:	85 db                	test   %ebx,%ebx
f0105fc6:	7e 6c                	jle    f0106034 <printnum+0xaf>
				putch(padc, putdat);
f0105fc8:	83 ec 08             	sub    $0x8,%esp
f0105fcb:	57                   	push   %edi
f0105fcc:	ff 75 18             	pushl  0x18(%ebp)
f0105fcf:	ff d6                	call   *%esi
f0105fd1:	83 c4 10             	add    $0x10,%esp
f0105fd4:	eb eb                	jmp    f0105fc1 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105fd6:	83 ec 0c             	sub    $0xc,%esp
f0105fd9:	6a 20                	push   $0x20
f0105fdb:	6a 00                	push   $0x0
f0105fdd:	50                   	push   %eax
f0105fde:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105fe1:	ff 75 e0             	pushl  -0x20(%ebp)
f0105fe4:	89 fa                	mov    %edi,%edx
f0105fe6:	89 f0                	mov    %esi,%eax
f0105fe8:	e8 98 ff ff ff       	call   f0105f85 <printnum>
		while (--width > 0)
f0105fed:	83 c4 20             	add    $0x20,%esp
f0105ff0:	83 eb 01             	sub    $0x1,%ebx
f0105ff3:	85 db                	test   %ebx,%ebx
f0105ff5:	7e 65                	jle    f010605c <printnum+0xd7>
			putch(padc, putdat);
f0105ff7:	83 ec 08             	sub    $0x8,%esp
f0105ffa:	57                   	push   %edi
f0105ffb:	6a 20                	push   $0x20
f0105ffd:	ff d6                	call   *%esi
f0105fff:	83 c4 10             	add    $0x10,%esp
f0106002:	eb ec                	jmp    f0105ff0 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f0106004:	83 ec 0c             	sub    $0xc,%esp
f0106007:	ff 75 18             	pushl  0x18(%ebp)
f010600a:	83 eb 01             	sub    $0x1,%ebx
f010600d:	53                   	push   %ebx
f010600e:	50                   	push   %eax
f010600f:	83 ec 08             	sub    $0x8,%esp
f0106012:	ff 75 dc             	pushl  -0x24(%ebp)
f0106015:	ff 75 d8             	pushl  -0x28(%ebp)
f0106018:	ff 75 e4             	pushl  -0x1c(%ebp)
f010601b:	ff 75 e0             	pushl  -0x20(%ebp)
f010601e:	e8 9d 1d 00 00       	call   f0107dc0 <__udivdi3>
f0106023:	83 c4 18             	add    $0x18,%esp
f0106026:	52                   	push   %edx
f0106027:	50                   	push   %eax
f0106028:	89 fa                	mov    %edi,%edx
f010602a:	89 f0                	mov    %esi,%eax
f010602c:	e8 54 ff ff ff       	call   f0105f85 <printnum>
f0106031:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f0106034:	83 ec 08             	sub    $0x8,%esp
f0106037:	57                   	push   %edi
f0106038:	83 ec 04             	sub    $0x4,%esp
f010603b:	ff 75 dc             	pushl  -0x24(%ebp)
f010603e:	ff 75 d8             	pushl  -0x28(%ebp)
f0106041:	ff 75 e4             	pushl  -0x1c(%ebp)
f0106044:	ff 75 e0             	pushl  -0x20(%ebp)
f0106047:	e8 84 1e 00 00       	call   f0107ed0 <__umoddi3>
f010604c:	83 c4 14             	add    $0x14,%esp
f010604f:	0f be 80 c2 9f 10 f0 	movsbl -0xfef603e(%eax),%eax
f0106056:	50                   	push   %eax
f0106057:	ff d6                	call   *%esi
f0106059:	83 c4 10             	add    $0x10,%esp
	}
}
f010605c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010605f:	5b                   	pop    %ebx
f0106060:	5e                   	pop    %esi
f0106061:	5f                   	pop    %edi
f0106062:	5d                   	pop    %ebp
f0106063:	c3                   	ret    

f0106064 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0106064:	55                   	push   %ebp
f0106065:	89 e5                	mov    %esp,%ebp
f0106067:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010606a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010606e:	8b 10                	mov    (%eax),%edx
f0106070:	3b 50 04             	cmp    0x4(%eax),%edx
f0106073:	73 0a                	jae    f010607f <sprintputch+0x1b>
		*b->buf++ = ch;
f0106075:	8d 4a 01             	lea    0x1(%edx),%ecx
f0106078:	89 08                	mov    %ecx,(%eax)
f010607a:	8b 45 08             	mov    0x8(%ebp),%eax
f010607d:	88 02                	mov    %al,(%edx)
}
f010607f:	5d                   	pop    %ebp
f0106080:	c3                   	ret    

f0106081 <printfmt>:
{
f0106081:	55                   	push   %ebp
f0106082:	89 e5                	mov    %esp,%ebp
f0106084:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0106087:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010608a:	50                   	push   %eax
f010608b:	ff 75 10             	pushl  0x10(%ebp)
f010608e:	ff 75 0c             	pushl  0xc(%ebp)
f0106091:	ff 75 08             	pushl  0x8(%ebp)
f0106094:	e8 05 00 00 00       	call   f010609e <vprintfmt>
}
f0106099:	83 c4 10             	add    $0x10,%esp
f010609c:	c9                   	leave  
f010609d:	c3                   	ret    

f010609e <vprintfmt>:
{
f010609e:	55                   	push   %ebp
f010609f:	89 e5                	mov    %esp,%ebp
f01060a1:	57                   	push   %edi
f01060a2:	56                   	push   %esi
f01060a3:	53                   	push   %ebx
f01060a4:	83 ec 3c             	sub    $0x3c,%esp
f01060a7:	8b 75 08             	mov    0x8(%ebp),%esi
f01060aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01060ad:	8b 7d 10             	mov    0x10(%ebp),%edi
f01060b0:	e9 32 04 00 00       	jmp    f01064e7 <vprintfmt+0x449>
		padc = ' ';
f01060b5:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f01060b9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f01060c0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f01060c7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f01060ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f01060d5:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f01060dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01060e1:	8d 47 01             	lea    0x1(%edi),%eax
f01060e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01060e7:	0f b6 17             	movzbl (%edi),%edx
f01060ea:	8d 42 dd             	lea    -0x23(%edx),%eax
f01060ed:	3c 55                	cmp    $0x55,%al
f01060ef:	0f 87 12 05 00 00    	ja     f0106607 <vprintfmt+0x569>
f01060f5:	0f b6 c0             	movzbl %al,%eax
f01060f8:	ff 24 85 a0 a1 10 f0 	jmp    *-0xfef5e60(,%eax,4)
f01060ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0106102:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0106106:	eb d9                	jmp    f01060e1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0106108:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f010610b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f010610f:	eb d0                	jmp    f01060e1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0106111:	0f b6 d2             	movzbl %dl,%edx
f0106114:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0106117:	b8 00 00 00 00       	mov    $0x0,%eax
f010611c:	89 75 08             	mov    %esi,0x8(%ebp)
f010611f:	eb 03                	jmp    f0106124 <vprintfmt+0x86>
f0106121:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0106124:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0106127:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f010612b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f010612e:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106131:	83 fe 09             	cmp    $0x9,%esi
f0106134:	76 eb                	jbe    f0106121 <vprintfmt+0x83>
f0106136:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106139:	8b 75 08             	mov    0x8(%ebp),%esi
f010613c:	eb 14                	jmp    f0106152 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f010613e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106141:	8b 00                	mov    (%eax),%eax
f0106143:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106146:	8b 45 14             	mov    0x14(%ebp),%eax
f0106149:	8d 40 04             	lea    0x4(%eax),%eax
f010614c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010614f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0106152:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0106156:	79 89                	jns    f01060e1 <vprintfmt+0x43>
				width = precision, precision = -1;
f0106158:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010615b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010615e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0106165:	e9 77 ff ff ff       	jmp    f01060e1 <vprintfmt+0x43>
f010616a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010616d:	85 c0                	test   %eax,%eax
f010616f:	0f 48 c1             	cmovs  %ecx,%eax
f0106172:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106175:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0106178:	e9 64 ff ff ff       	jmp    f01060e1 <vprintfmt+0x43>
f010617d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0106180:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0106187:	e9 55 ff ff ff       	jmp    f01060e1 <vprintfmt+0x43>
			lflag++;
f010618c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106190:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0106193:	e9 49 ff ff ff       	jmp    f01060e1 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0106198:	8b 45 14             	mov    0x14(%ebp),%eax
f010619b:	8d 78 04             	lea    0x4(%eax),%edi
f010619e:	83 ec 08             	sub    $0x8,%esp
f01061a1:	53                   	push   %ebx
f01061a2:	ff 30                	pushl  (%eax)
f01061a4:	ff d6                	call   *%esi
			break;
f01061a6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f01061a9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f01061ac:	e9 33 03 00 00       	jmp    f01064e4 <vprintfmt+0x446>
			err = va_arg(ap, int);
f01061b1:	8b 45 14             	mov    0x14(%ebp),%eax
f01061b4:	8d 78 04             	lea    0x4(%eax),%edi
f01061b7:	8b 00                	mov    (%eax),%eax
f01061b9:	99                   	cltd   
f01061ba:	31 d0                	xor    %edx,%eax
f01061bc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01061be:	83 f8 11             	cmp    $0x11,%eax
f01061c1:	7f 23                	jg     f01061e6 <vprintfmt+0x148>
f01061c3:	8b 14 85 00 a3 10 f0 	mov    -0xfef5d00(,%eax,4),%edx
f01061ca:	85 d2                	test   %edx,%edx
f01061cc:	74 18                	je     f01061e6 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f01061ce:	52                   	push   %edx
f01061cf:	68 9d 92 10 f0       	push   $0xf010929d
f01061d4:	53                   	push   %ebx
f01061d5:	56                   	push   %esi
f01061d6:	e8 a6 fe ff ff       	call   f0106081 <printfmt>
f01061db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01061de:	89 7d 14             	mov    %edi,0x14(%ebp)
f01061e1:	e9 fe 02 00 00       	jmp    f01064e4 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f01061e6:	50                   	push   %eax
f01061e7:	68 da 9f 10 f0       	push   $0xf0109fda
f01061ec:	53                   	push   %ebx
f01061ed:	56                   	push   %esi
f01061ee:	e8 8e fe ff ff       	call   f0106081 <printfmt>
f01061f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01061f6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01061f9:	e9 e6 02 00 00       	jmp    f01064e4 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f01061fe:	8b 45 14             	mov    0x14(%ebp),%eax
f0106201:	83 c0 04             	add    $0x4,%eax
f0106204:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0106207:	8b 45 14             	mov    0x14(%ebp),%eax
f010620a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f010620c:	85 c9                	test   %ecx,%ecx
f010620e:	b8 d3 9f 10 f0       	mov    $0xf0109fd3,%eax
f0106213:	0f 45 c1             	cmovne %ecx,%eax
f0106216:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0106219:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010621d:	7e 06                	jle    f0106225 <vprintfmt+0x187>
f010621f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0106223:	75 0d                	jne    f0106232 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0106225:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0106228:	89 c7                	mov    %eax,%edi
f010622a:	03 45 e0             	add    -0x20(%ebp),%eax
f010622d:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106230:	eb 53                	jmp    f0106285 <vprintfmt+0x1e7>
f0106232:	83 ec 08             	sub    $0x8,%esp
f0106235:	ff 75 d8             	pushl  -0x28(%ebp)
f0106238:	50                   	push   %eax
f0106239:	e8 5f 05 00 00       	call   f010679d <strnlen>
f010623e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106241:	29 c1                	sub    %eax,%ecx
f0106243:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0106246:	83 c4 10             	add    $0x10,%esp
f0106249:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f010624b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f010624f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0106252:	eb 0f                	jmp    f0106263 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0106254:	83 ec 08             	sub    $0x8,%esp
f0106257:	53                   	push   %ebx
f0106258:	ff 75 e0             	pushl  -0x20(%ebp)
f010625b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f010625d:	83 ef 01             	sub    $0x1,%edi
f0106260:	83 c4 10             	add    $0x10,%esp
f0106263:	85 ff                	test   %edi,%edi
f0106265:	7f ed                	jg     f0106254 <vprintfmt+0x1b6>
f0106267:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f010626a:	85 c9                	test   %ecx,%ecx
f010626c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106271:	0f 49 c1             	cmovns %ecx,%eax
f0106274:	29 c1                	sub    %eax,%ecx
f0106276:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0106279:	eb aa                	jmp    f0106225 <vprintfmt+0x187>
					putch(ch, putdat);
f010627b:	83 ec 08             	sub    $0x8,%esp
f010627e:	53                   	push   %ebx
f010627f:	52                   	push   %edx
f0106280:	ff d6                	call   *%esi
f0106282:	83 c4 10             	add    $0x10,%esp
f0106285:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106288:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010628a:	83 c7 01             	add    $0x1,%edi
f010628d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0106291:	0f be d0             	movsbl %al,%edx
f0106294:	85 d2                	test   %edx,%edx
f0106296:	74 4b                	je     f01062e3 <vprintfmt+0x245>
f0106298:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010629c:	78 06                	js     f01062a4 <vprintfmt+0x206>
f010629e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f01062a2:	78 1e                	js     f01062c2 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f01062a4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f01062a8:	74 d1                	je     f010627b <vprintfmt+0x1dd>
f01062aa:	0f be c0             	movsbl %al,%eax
f01062ad:	83 e8 20             	sub    $0x20,%eax
f01062b0:	83 f8 5e             	cmp    $0x5e,%eax
f01062b3:	76 c6                	jbe    f010627b <vprintfmt+0x1dd>
					putch('?', putdat);
f01062b5:	83 ec 08             	sub    $0x8,%esp
f01062b8:	53                   	push   %ebx
f01062b9:	6a 3f                	push   $0x3f
f01062bb:	ff d6                	call   *%esi
f01062bd:	83 c4 10             	add    $0x10,%esp
f01062c0:	eb c3                	jmp    f0106285 <vprintfmt+0x1e7>
f01062c2:	89 cf                	mov    %ecx,%edi
f01062c4:	eb 0e                	jmp    f01062d4 <vprintfmt+0x236>
				putch(' ', putdat);
f01062c6:	83 ec 08             	sub    $0x8,%esp
f01062c9:	53                   	push   %ebx
f01062ca:	6a 20                	push   $0x20
f01062cc:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01062ce:	83 ef 01             	sub    $0x1,%edi
f01062d1:	83 c4 10             	add    $0x10,%esp
f01062d4:	85 ff                	test   %edi,%edi
f01062d6:	7f ee                	jg     f01062c6 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f01062d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f01062db:	89 45 14             	mov    %eax,0x14(%ebp)
f01062de:	e9 01 02 00 00       	jmp    f01064e4 <vprintfmt+0x446>
f01062e3:	89 cf                	mov    %ecx,%edi
f01062e5:	eb ed                	jmp    f01062d4 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f01062e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f01062ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f01062f1:	e9 eb fd ff ff       	jmp    f01060e1 <vprintfmt+0x43>
	if (lflag >= 2)
f01062f6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01062fa:	7f 21                	jg     f010631d <vprintfmt+0x27f>
	else if (lflag)
f01062fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106300:	74 68                	je     f010636a <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f0106302:	8b 45 14             	mov    0x14(%ebp),%eax
f0106305:	8b 00                	mov    (%eax),%eax
f0106307:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010630a:	89 c1                	mov    %eax,%ecx
f010630c:	c1 f9 1f             	sar    $0x1f,%ecx
f010630f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0106312:	8b 45 14             	mov    0x14(%ebp),%eax
f0106315:	8d 40 04             	lea    0x4(%eax),%eax
f0106318:	89 45 14             	mov    %eax,0x14(%ebp)
f010631b:	eb 17                	jmp    f0106334 <vprintfmt+0x296>
		return va_arg(*ap, long long);
f010631d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106320:	8b 50 04             	mov    0x4(%eax),%edx
f0106323:	8b 00                	mov    (%eax),%eax
f0106325:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106328:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010632b:	8b 45 14             	mov    0x14(%ebp),%eax
f010632e:	8d 40 08             	lea    0x8(%eax),%eax
f0106331:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0106334:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106337:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010633a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010633d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f0106340:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106344:	78 3f                	js     f0106385 <vprintfmt+0x2e7>
			base = 10;
f0106346:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f010634b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f010634f:	0f 84 71 01 00 00    	je     f01064c6 <vprintfmt+0x428>
				putch('+', putdat);
f0106355:	83 ec 08             	sub    $0x8,%esp
f0106358:	53                   	push   %ebx
f0106359:	6a 2b                	push   $0x2b
f010635b:	ff d6                	call   *%esi
f010635d:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0106360:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106365:	e9 5c 01 00 00       	jmp    f01064c6 <vprintfmt+0x428>
		return va_arg(*ap, int);
f010636a:	8b 45 14             	mov    0x14(%ebp),%eax
f010636d:	8b 00                	mov    (%eax),%eax
f010636f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106372:	89 c1                	mov    %eax,%ecx
f0106374:	c1 f9 1f             	sar    $0x1f,%ecx
f0106377:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f010637a:	8b 45 14             	mov    0x14(%ebp),%eax
f010637d:	8d 40 04             	lea    0x4(%eax),%eax
f0106380:	89 45 14             	mov    %eax,0x14(%ebp)
f0106383:	eb af                	jmp    f0106334 <vprintfmt+0x296>
				putch('-', putdat);
f0106385:	83 ec 08             	sub    $0x8,%esp
f0106388:	53                   	push   %ebx
f0106389:	6a 2d                	push   $0x2d
f010638b:	ff d6                	call   *%esi
				num = -(long long) num;
f010638d:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106390:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106393:	f7 d8                	neg    %eax
f0106395:	83 d2 00             	adc    $0x0,%edx
f0106398:	f7 da                	neg    %edx
f010639a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010639d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01063a0:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01063a3:	b8 0a 00 00 00       	mov    $0xa,%eax
f01063a8:	e9 19 01 00 00       	jmp    f01064c6 <vprintfmt+0x428>
	if (lflag >= 2)
f01063ad:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01063b1:	7f 29                	jg     f01063dc <vprintfmt+0x33e>
	else if (lflag)
f01063b3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01063b7:	74 44                	je     f01063fd <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f01063b9:	8b 45 14             	mov    0x14(%ebp),%eax
f01063bc:	8b 00                	mov    (%eax),%eax
f01063be:	ba 00 00 00 00       	mov    $0x0,%edx
f01063c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01063c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01063c9:	8b 45 14             	mov    0x14(%ebp),%eax
f01063cc:	8d 40 04             	lea    0x4(%eax),%eax
f01063cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01063d2:	b8 0a 00 00 00       	mov    $0xa,%eax
f01063d7:	e9 ea 00 00 00       	jmp    f01064c6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01063dc:	8b 45 14             	mov    0x14(%ebp),%eax
f01063df:	8b 50 04             	mov    0x4(%eax),%edx
f01063e2:	8b 00                	mov    (%eax),%eax
f01063e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01063e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01063ea:	8b 45 14             	mov    0x14(%ebp),%eax
f01063ed:	8d 40 08             	lea    0x8(%eax),%eax
f01063f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01063f3:	b8 0a 00 00 00       	mov    $0xa,%eax
f01063f8:	e9 c9 00 00 00       	jmp    f01064c6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f01063fd:	8b 45 14             	mov    0x14(%ebp),%eax
f0106400:	8b 00                	mov    (%eax),%eax
f0106402:	ba 00 00 00 00       	mov    $0x0,%edx
f0106407:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010640a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010640d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106410:	8d 40 04             	lea    0x4(%eax),%eax
f0106413:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106416:	b8 0a 00 00 00       	mov    $0xa,%eax
f010641b:	e9 a6 00 00 00       	jmp    f01064c6 <vprintfmt+0x428>
			putch('0', putdat);
f0106420:	83 ec 08             	sub    $0x8,%esp
f0106423:	53                   	push   %ebx
f0106424:	6a 30                	push   $0x30
f0106426:	ff d6                	call   *%esi
	if (lflag >= 2)
f0106428:	83 c4 10             	add    $0x10,%esp
f010642b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f010642f:	7f 26                	jg     f0106457 <vprintfmt+0x3b9>
	else if (lflag)
f0106431:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106435:	74 3e                	je     f0106475 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f0106437:	8b 45 14             	mov    0x14(%ebp),%eax
f010643a:	8b 00                	mov    (%eax),%eax
f010643c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106441:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106444:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106447:	8b 45 14             	mov    0x14(%ebp),%eax
f010644a:	8d 40 04             	lea    0x4(%eax),%eax
f010644d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106450:	b8 08 00 00 00       	mov    $0x8,%eax
f0106455:	eb 6f                	jmp    f01064c6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106457:	8b 45 14             	mov    0x14(%ebp),%eax
f010645a:	8b 50 04             	mov    0x4(%eax),%edx
f010645d:	8b 00                	mov    (%eax),%eax
f010645f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106462:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106465:	8b 45 14             	mov    0x14(%ebp),%eax
f0106468:	8d 40 08             	lea    0x8(%eax),%eax
f010646b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010646e:	b8 08 00 00 00       	mov    $0x8,%eax
f0106473:	eb 51                	jmp    f01064c6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106475:	8b 45 14             	mov    0x14(%ebp),%eax
f0106478:	8b 00                	mov    (%eax),%eax
f010647a:	ba 00 00 00 00       	mov    $0x0,%edx
f010647f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106482:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106485:	8b 45 14             	mov    0x14(%ebp),%eax
f0106488:	8d 40 04             	lea    0x4(%eax),%eax
f010648b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010648e:	b8 08 00 00 00       	mov    $0x8,%eax
f0106493:	eb 31                	jmp    f01064c6 <vprintfmt+0x428>
			putch('0', putdat);
f0106495:	83 ec 08             	sub    $0x8,%esp
f0106498:	53                   	push   %ebx
f0106499:	6a 30                	push   $0x30
f010649b:	ff d6                	call   *%esi
			putch('x', putdat);
f010649d:	83 c4 08             	add    $0x8,%esp
f01064a0:	53                   	push   %ebx
f01064a1:	6a 78                	push   $0x78
f01064a3:	ff d6                	call   *%esi
			num = (unsigned long long)
f01064a5:	8b 45 14             	mov    0x14(%ebp),%eax
f01064a8:	8b 00                	mov    (%eax),%eax
f01064aa:	ba 00 00 00 00       	mov    $0x0,%edx
f01064af:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01064b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f01064b5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01064b8:	8b 45 14             	mov    0x14(%ebp),%eax
f01064bb:	8d 40 04             	lea    0x4(%eax),%eax
f01064be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01064c1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01064c6:	83 ec 0c             	sub    $0xc,%esp
f01064c9:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f01064cd:	52                   	push   %edx
f01064ce:	ff 75 e0             	pushl  -0x20(%ebp)
f01064d1:	50                   	push   %eax
f01064d2:	ff 75 dc             	pushl  -0x24(%ebp)
f01064d5:	ff 75 d8             	pushl  -0x28(%ebp)
f01064d8:	89 da                	mov    %ebx,%edx
f01064da:	89 f0                	mov    %esi,%eax
f01064dc:	e8 a4 fa ff ff       	call   f0105f85 <printnum>
			break;
f01064e1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01064e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01064e7:	83 c7 01             	add    $0x1,%edi
f01064ea:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01064ee:	83 f8 25             	cmp    $0x25,%eax
f01064f1:	0f 84 be fb ff ff    	je     f01060b5 <vprintfmt+0x17>
			if (ch == '\0')
f01064f7:	85 c0                	test   %eax,%eax
f01064f9:	0f 84 28 01 00 00    	je     f0106627 <vprintfmt+0x589>
			putch(ch, putdat);
f01064ff:	83 ec 08             	sub    $0x8,%esp
f0106502:	53                   	push   %ebx
f0106503:	50                   	push   %eax
f0106504:	ff d6                	call   *%esi
f0106506:	83 c4 10             	add    $0x10,%esp
f0106509:	eb dc                	jmp    f01064e7 <vprintfmt+0x449>
	if (lflag >= 2)
f010650b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f010650f:	7f 26                	jg     f0106537 <vprintfmt+0x499>
	else if (lflag)
f0106511:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106515:	74 41                	je     f0106558 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f0106517:	8b 45 14             	mov    0x14(%ebp),%eax
f010651a:	8b 00                	mov    (%eax),%eax
f010651c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106521:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106524:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106527:	8b 45 14             	mov    0x14(%ebp),%eax
f010652a:	8d 40 04             	lea    0x4(%eax),%eax
f010652d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106530:	b8 10 00 00 00       	mov    $0x10,%eax
f0106535:	eb 8f                	jmp    f01064c6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106537:	8b 45 14             	mov    0x14(%ebp),%eax
f010653a:	8b 50 04             	mov    0x4(%eax),%edx
f010653d:	8b 00                	mov    (%eax),%eax
f010653f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106542:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106545:	8b 45 14             	mov    0x14(%ebp),%eax
f0106548:	8d 40 08             	lea    0x8(%eax),%eax
f010654b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010654e:	b8 10 00 00 00       	mov    $0x10,%eax
f0106553:	e9 6e ff ff ff       	jmp    f01064c6 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106558:	8b 45 14             	mov    0x14(%ebp),%eax
f010655b:	8b 00                	mov    (%eax),%eax
f010655d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106562:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106565:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106568:	8b 45 14             	mov    0x14(%ebp),%eax
f010656b:	8d 40 04             	lea    0x4(%eax),%eax
f010656e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106571:	b8 10 00 00 00       	mov    $0x10,%eax
f0106576:	e9 4b ff ff ff       	jmp    f01064c6 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f010657b:	8b 45 14             	mov    0x14(%ebp),%eax
f010657e:	83 c0 04             	add    $0x4,%eax
f0106581:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106584:	8b 45 14             	mov    0x14(%ebp),%eax
f0106587:	8b 00                	mov    (%eax),%eax
f0106589:	85 c0                	test   %eax,%eax
f010658b:	74 14                	je     f01065a1 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f010658d:	8b 13                	mov    (%ebx),%edx
f010658f:	83 fa 7f             	cmp    $0x7f,%edx
f0106592:	7f 37                	jg     f01065cb <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f0106594:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f0106596:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106599:	89 45 14             	mov    %eax,0x14(%ebp)
f010659c:	e9 43 ff ff ff       	jmp    f01064e4 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f01065a1:	b8 0a 00 00 00       	mov    $0xa,%eax
f01065a6:	bf f9 a0 10 f0       	mov    $0xf010a0f9,%edi
							putch(ch, putdat);
f01065ab:	83 ec 08             	sub    $0x8,%esp
f01065ae:	53                   	push   %ebx
f01065af:	50                   	push   %eax
f01065b0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f01065b2:	83 c7 01             	add    $0x1,%edi
f01065b5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f01065b9:	83 c4 10             	add    $0x10,%esp
f01065bc:	85 c0                	test   %eax,%eax
f01065be:	75 eb                	jne    f01065ab <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f01065c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01065c3:	89 45 14             	mov    %eax,0x14(%ebp)
f01065c6:	e9 19 ff ff ff       	jmp    f01064e4 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f01065cb:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f01065cd:	b8 0a 00 00 00       	mov    $0xa,%eax
f01065d2:	bf 31 a1 10 f0       	mov    $0xf010a131,%edi
							putch(ch, putdat);
f01065d7:	83 ec 08             	sub    $0x8,%esp
f01065da:	53                   	push   %ebx
f01065db:	50                   	push   %eax
f01065dc:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f01065de:	83 c7 01             	add    $0x1,%edi
f01065e1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f01065e5:	83 c4 10             	add    $0x10,%esp
f01065e8:	85 c0                	test   %eax,%eax
f01065ea:	75 eb                	jne    f01065d7 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f01065ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01065ef:	89 45 14             	mov    %eax,0x14(%ebp)
f01065f2:	e9 ed fe ff ff       	jmp    f01064e4 <vprintfmt+0x446>
			putch(ch, putdat);
f01065f7:	83 ec 08             	sub    $0x8,%esp
f01065fa:	53                   	push   %ebx
f01065fb:	6a 25                	push   $0x25
f01065fd:	ff d6                	call   *%esi
			break;
f01065ff:	83 c4 10             	add    $0x10,%esp
f0106602:	e9 dd fe ff ff       	jmp    f01064e4 <vprintfmt+0x446>
			putch('%', putdat);
f0106607:	83 ec 08             	sub    $0x8,%esp
f010660a:	53                   	push   %ebx
f010660b:	6a 25                	push   $0x25
f010660d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f010660f:	83 c4 10             	add    $0x10,%esp
f0106612:	89 f8                	mov    %edi,%eax
f0106614:	eb 03                	jmp    f0106619 <vprintfmt+0x57b>
f0106616:	83 e8 01             	sub    $0x1,%eax
f0106619:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010661d:	75 f7                	jne    f0106616 <vprintfmt+0x578>
f010661f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106622:	e9 bd fe ff ff       	jmp    f01064e4 <vprintfmt+0x446>
}
f0106627:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010662a:	5b                   	pop    %ebx
f010662b:	5e                   	pop    %esi
f010662c:	5f                   	pop    %edi
f010662d:	5d                   	pop    %ebp
f010662e:	c3                   	ret    

f010662f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010662f:	55                   	push   %ebp
f0106630:	89 e5                	mov    %esp,%ebp
f0106632:	83 ec 18             	sub    $0x18,%esp
f0106635:	8b 45 08             	mov    0x8(%ebp),%eax
f0106638:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f010663b:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010663e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106642:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0106645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010664c:	85 c0                	test   %eax,%eax
f010664e:	74 26                	je     f0106676 <vsnprintf+0x47>
f0106650:	85 d2                	test   %edx,%edx
f0106652:	7e 22                	jle    f0106676 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106654:	ff 75 14             	pushl  0x14(%ebp)
f0106657:	ff 75 10             	pushl  0x10(%ebp)
f010665a:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010665d:	50                   	push   %eax
f010665e:	68 64 60 10 f0       	push   $0xf0106064
f0106663:	e8 36 fa ff ff       	call   f010609e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106668:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010666b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010666e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106671:	83 c4 10             	add    $0x10,%esp
}
f0106674:	c9                   	leave  
f0106675:	c3                   	ret    
		return -E_INVAL;
f0106676:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010667b:	eb f7                	jmp    f0106674 <vsnprintf+0x45>

f010667d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010667d:	55                   	push   %ebp
f010667e:	89 e5                	mov    %esp,%ebp
f0106680:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106683:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106686:	50                   	push   %eax
f0106687:	ff 75 10             	pushl  0x10(%ebp)
f010668a:	ff 75 0c             	pushl  0xc(%ebp)
f010668d:	ff 75 08             	pushl  0x8(%ebp)
f0106690:	e8 9a ff ff ff       	call   f010662f <vsnprintf>
	va_end(ap);

	return rc;
}
f0106695:	c9                   	leave  
f0106696:	c3                   	ret    

f0106697 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106697:	55                   	push   %ebp
f0106698:	89 e5                	mov    %esp,%ebp
f010669a:	57                   	push   %edi
f010669b:	56                   	push   %esi
f010669c:	53                   	push   %ebx
f010669d:	83 ec 0c             	sub    $0xc,%esp
f01066a0:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f01066a3:	85 c0                	test   %eax,%eax
f01066a5:	74 11                	je     f01066b8 <readline+0x21>
		cprintf("%s", prompt);
f01066a7:	83 ec 08             	sub    $0x8,%esp
f01066aa:	50                   	push   %eax
f01066ab:	68 9d 92 10 f0       	push   $0xf010929d
f01066b0:	e8 41 db ff ff       	call   f01041f6 <cprintf>
f01066b5:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f01066b8:	83 ec 0c             	sub    $0xc,%esp
f01066bb:	6a 00                	push   $0x0
f01066bd:	e8 91 a1 ff ff       	call   f0100853 <iscons>
f01066c2:	89 c7                	mov    %eax,%edi
f01066c4:	83 c4 10             	add    $0x10,%esp
	i = 0;
f01066c7:	be 00 00 00 00       	mov    $0x0,%esi
f01066cc:	eb 57                	jmp    f0106725 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f01066ce:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f01066d3:	83 fb f8             	cmp    $0xfffffff8,%ebx
f01066d6:	75 08                	jne    f01066e0 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01066d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01066db:	5b                   	pop    %ebx
f01066dc:	5e                   	pop    %esi
f01066dd:	5f                   	pop    %edi
f01066de:	5d                   	pop    %ebp
f01066df:	c3                   	ret    
				cprintf("read error: %e\n", c);
f01066e0:	83 ec 08             	sub    $0x8,%esp
f01066e3:	53                   	push   %ebx
f01066e4:	68 48 a3 10 f0       	push   $0xf010a348
f01066e9:	e8 08 db ff ff       	call   f01041f6 <cprintf>
f01066ee:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01066f1:	b8 00 00 00 00       	mov    $0x0,%eax
f01066f6:	eb e0                	jmp    f01066d8 <readline+0x41>
			if (echoing)
f01066f8:	85 ff                	test   %edi,%edi
f01066fa:	75 05                	jne    f0106701 <readline+0x6a>
			i--;
f01066fc:	83 ee 01             	sub    $0x1,%esi
f01066ff:	eb 24                	jmp    f0106725 <readline+0x8e>
				cputchar('\b');
f0106701:	83 ec 0c             	sub    $0xc,%esp
f0106704:	6a 08                	push   $0x8
f0106706:	e8 27 a1 ff ff       	call   f0100832 <cputchar>
f010670b:	83 c4 10             	add    $0x10,%esp
f010670e:	eb ec                	jmp    f01066fc <readline+0x65>
				cputchar(c);
f0106710:	83 ec 0c             	sub    $0xc,%esp
f0106713:	53                   	push   %ebx
f0106714:	e8 19 a1 ff ff       	call   f0100832 <cputchar>
f0106719:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f010671c:	88 9e 60 d9 5d f0    	mov    %bl,-0xfa226a0(%esi)
f0106722:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f0106725:	e8 18 a1 ff ff       	call   f0100842 <getchar>
f010672a:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010672c:	85 c0                	test   %eax,%eax
f010672e:	78 9e                	js     f01066ce <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0106730:	83 f8 08             	cmp    $0x8,%eax
f0106733:	0f 94 c2             	sete   %dl
f0106736:	83 f8 7f             	cmp    $0x7f,%eax
f0106739:	0f 94 c0             	sete   %al
f010673c:	08 c2                	or     %al,%dl
f010673e:	74 04                	je     f0106744 <readline+0xad>
f0106740:	85 f6                	test   %esi,%esi
f0106742:	7f b4                	jg     f01066f8 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106744:	83 fb 1f             	cmp    $0x1f,%ebx
f0106747:	7e 0e                	jle    f0106757 <readline+0xc0>
f0106749:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f010674f:	7f 06                	jg     f0106757 <readline+0xc0>
			if (echoing)
f0106751:	85 ff                	test   %edi,%edi
f0106753:	74 c7                	je     f010671c <readline+0x85>
f0106755:	eb b9                	jmp    f0106710 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f0106757:	83 fb 0a             	cmp    $0xa,%ebx
f010675a:	74 05                	je     f0106761 <readline+0xca>
f010675c:	83 fb 0d             	cmp    $0xd,%ebx
f010675f:	75 c4                	jne    f0106725 <readline+0x8e>
			if (echoing)
f0106761:	85 ff                	test   %edi,%edi
f0106763:	75 11                	jne    f0106776 <readline+0xdf>
			buf[i] = 0;
f0106765:	c6 86 60 d9 5d f0 00 	movb   $0x0,-0xfa226a0(%esi)
			return buf;
f010676c:	b8 60 d9 5d f0       	mov    $0xf05dd960,%eax
f0106771:	e9 62 ff ff ff       	jmp    f01066d8 <readline+0x41>
				cputchar('\n');
f0106776:	83 ec 0c             	sub    $0xc,%esp
f0106779:	6a 0a                	push   $0xa
f010677b:	e8 b2 a0 ff ff       	call   f0100832 <cputchar>
f0106780:	83 c4 10             	add    $0x10,%esp
f0106783:	eb e0                	jmp    f0106765 <readline+0xce>

f0106785 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106785:	55                   	push   %ebp
f0106786:	89 e5                	mov    %esp,%ebp
f0106788:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010678b:	b8 00 00 00 00       	mov    $0x0,%eax
f0106790:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106794:	74 05                	je     f010679b <strlen+0x16>
		n++;
f0106796:	83 c0 01             	add    $0x1,%eax
f0106799:	eb f5                	jmp    f0106790 <strlen+0xb>
	return n;
}
f010679b:	5d                   	pop    %ebp
f010679c:	c3                   	ret    

f010679d <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010679d:	55                   	push   %ebp
f010679e:	89 e5                	mov    %esp,%ebp
f01067a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01067a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01067a6:	ba 00 00 00 00       	mov    $0x0,%edx
f01067ab:	39 c2                	cmp    %eax,%edx
f01067ad:	74 0d                	je     f01067bc <strnlen+0x1f>
f01067af:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f01067b3:	74 05                	je     f01067ba <strnlen+0x1d>
		n++;
f01067b5:	83 c2 01             	add    $0x1,%edx
f01067b8:	eb f1                	jmp    f01067ab <strnlen+0xe>
f01067ba:	89 d0                	mov    %edx,%eax
	return n;
}
f01067bc:	5d                   	pop    %ebp
f01067bd:	c3                   	ret    

f01067be <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01067be:	55                   	push   %ebp
f01067bf:	89 e5                	mov    %esp,%ebp
f01067c1:	53                   	push   %ebx
f01067c2:	8b 45 08             	mov    0x8(%ebp),%eax
f01067c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01067c8:	ba 00 00 00 00       	mov    $0x0,%edx
f01067cd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f01067d1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f01067d4:	83 c2 01             	add    $0x1,%edx
f01067d7:	84 c9                	test   %cl,%cl
f01067d9:	75 f2                	jne    f01067cd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f01067db:	5b                   	pop    %ebx
f01067dc:	5d                   	pop    %ebp
f01067dd:	c3                   	ret    

f01067de <strcat>:

char *
strcat(char *dst, const char *src)
{
f01067de:	55                   	push   %ebp
f01067df:	89 e5                	mov    %esp,%ebp
f01067e1:	53                   	push   %ebx
f01067e2:	83 ec 10             	sub    $0x10,%esp
f01067e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01067e8:	53                   	push   %ebx
f01067e9:	e8 97 ff ff ff       	call   f0106785 <strlen>
f01067ee:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01067f1:	ff 75 0c             	pushl  0xc(%ebp)
f01067f4:	01 d8                	add    %ebx,%eax
f01067f6:	50                   	push   %eax
f01067f7:	e8 c2 ff ff ff       	call   f01067be <strcpy>
	return dst;
}
f01067fc:	89 d8                	mov    %ebx,%eax
f01067fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106801:	c9                   	leave  
f0106802:	c3                   	ret    

f0106803 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106803:	55                   	push   %ebp
f0106804:	89 e5                	mov    %esp,%ebp
f0106806:	56                   	push   %esi
f0106807:	53                   	push   %ebx
f0106808:	8b 45 08             	mov    0x8(%ebp),%eax
f010680b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010680e:	89 c6                	mov    %eax,%esi
f0106810:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106813:	89 c2                	mov    %eax,%edx
f0106815:	39 f2                	cmp    %esi,%edx
f0106817:	74 11                	je     f010682a <strncpy+0x27>
		*dst++ = *src;
f0106819:	83 c2 01             	add    $0x1,%edx
f010681c:	0f b6 19             	movzbl (%ecx),%ebx
f010681f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0106822:	80 fb 01             	cmp    $0x1,%bl
f0106825:	83 d9 ff             	sbb    $0xffffffff,%ecx
f0106828:	eb eb                	jmp    f0106815 <strncpy+0x12>
	}
	return ret;
}
f010682a:	5b                   	pop    %ebx
f010682b:	5e                   	pop    %esi
f010682c:	5d                   	pop    %ebp
f010682d:	c3                   	ret    

f010682e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f010682e:	55                   	push   %ebp
f010682f:	89 e5                	mov    %esp,%ebp
f0106831:	56                   	push   %esi
f0106832:	53                   	push   %ebx
f0106833:	8b 75 08             	mov    0x8(%ebp),%esi
f0106836:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106839:	8b 55 10             	mov    0x10(%ebp),%edx
f010683c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f010683e:	85 d2                	test   %edx,%edx
f0106840:	74 21                	je     f0106863 <strlcpy+0x35>
f0106842:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0106846:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0106848:	39 c2                	cmp    %eax,%edx
f010684a:	74 14                	je     f0106860 <strlcpy+0x32>
f010684c:	0f b6 19             	movzbl (%ecx),%ebx
f010684f:	84 db                	test   %bl,%bl
f0106851:	74 0b                	je     f010685e <strlcpy+0x30>
			*dst++ = *src++;
f0106853:	83 c1 01             	add    $0x1,%ecx
f0106856:	83 c2 01             	add    $0x1,%edx
f0106859:	88 5a ff             	mov    %bl,-0x1(%edx)
f010685c:	eb ea                	jmp    f0106848 <strlcpy+0x1a>
f010685e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0106860:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106863:	29 f0                	sub    %esi,%eax
}
f0106865:	5b                   	pop    %ebx
f0106866:	5e                   	pop    %esi
f0106867:	5d                   	pop    %ebp
f0106868:	c3                   	ret    

f0106869 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0106869:	55                   	push   %ebp
f010686a:	89 e5                	mov    %esp,%ebp
f010686c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010686f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106872:	0f b6 01             	movzbl (%ecx),%eax
f0106875:	84 c0                	test   %al,%al
f0106877:	74 0c                	je     f0106885 <strcmp+0x1c>
f0106879:	3a 02                	cmp    (%edx),%al
f010687b:	75 08                	jne    f0106885 <strcmp+0x1c>
		p++, q++;
f010687d:	83 c1 01             	add    $0x1,%ecx
f0106880:	83 c2 01             	add    $0x1,%edx
f0106883:	eb ed                	jmp    f0106872 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106885:	0f b6 c0             	movzbl %al,%eax
f0106888:	0f b6 12             	movzbl (%edx),%edx
f010688b:	29 d0                	sub    %edx,%eax
}
f010688d:	5d                   	pop    %ebp
f010688e:	c3                   	ret    

f010688f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010688f:	55                   	push   %ebp
f0106890:	89 e5                	mov    %esp,%ebp
f0106892:	53                   	push   %ebx
f0106893:	8b 45 08             	mov    0x8(%ebp),%eax
f0106896:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106899:	89 c3                	mov    %eax,%ebx
f010689b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010689e:	eb 06                	jmp    f01068a6 <strncmp+0x17>
		n--, p++, q++;
f01068a0:	83 c0 01             	add    $0x1,%eax
f01068a3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f01068a6:	39 d8                	cmp    %ebx,%eax
f01068a8:	74 16                	je     f01068c0 <strncmp+0x31>
f01068aa:	0f b6 08             	movzbl (%eax),%ecx
f01068ad:	84 c9                	test   %cl,%cl
f01068af:	74 04                	je     f01068b5 <strncmp+0x26>
f01068b1:	3a 0a                	cmp    (%edx),%cl
f01068b3:	74 eb                	je     f01068a0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01068b5:	0f b6 00             	movzbl (%eax),%eax
f01068b8:	0f b6 12             	movzbl (%edx),%edx
f01068bb:	29 d0                	sub    %edx,%eax
}
f01068bd:	5b                   	pop    %ebx
f01068be:	5d                   	pop    %ebp
f01068bf:	c3                   	ret    
		return 0;
f01068c0:	b8 00 00 00 00       	mov    $0x0,%eax
f01068c5:	eb f6                	jmp    f01068bd <strncmp+0x2e>

f01068c7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01068c7:	55                   	push   %ebp
f01068c8:	89 e5                	mov    %esp,%ebp
f01068ca:	8b 45 08             	mov    0x8(%ebp),%eax
f01068cd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01068d1:	0f b6 10             	movzbl (%eax),%edx
f01068d4:	84 d2                	test   %dl,%dl
f01068d6:	74 09                	je     f01068e1 <strchr+0x1a>
		if (*s == c)
f01068d8:	38 ca                	cmp    %cl,%dl
f01068da:	74 0a                	je     f01068e6 <strchr+0x1f>
	for (; *s; s++)
f01068dc:	83 c0 01             	add    $0x1,%eax
f01068df:	eb f0                	jmp    f01068d1 <strchr+0xa>
			return (char *) s;
	return 0;
f01068e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01068e6:	5d                   	pop    %ebp
f01068e7:	c3                   	ret    

f01068e8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01068e8:	55                   	push   %ebp
f01068e9:	89 e5                	mov    %esp,%ebp
f01068eb:	8b 45 08             	mov    0x8(%ebp),%eax
f01068ee:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01068f2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01068f5:	38 ca                	cmp    %cl,%dl
f01068f7:	74 09                	je     f0106902 <strfind+0x1a>
f01068f9:	84 d2                	test   %dl,%dl
f01068fb:	74 05                	je     f0106902 <strfind+0x1a>
	for (; *s; s++)
f01068fd:	83 c0 01             	add    $0x1,%eax
f0106900:	eb f0                	jmp    f01068f2 <strfind+0xa>
			break;
	return (char *) s;
}
f0106902:	5d                   	pop    %ebp
f0106903:	c3                   	ret    

f0106904 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106904:	55                   	push   %ebp
f0106905:	89 e5                	mov    %esp,%ebp
f0106907:	57                   	push   %edi
f0106908:	56                   	push   %esi
f0106909:	53                   	push   %ebx
f010690a:	8b 7d 08             	mov    0x8(%ebp),%edi
f010690d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0106910:	85 c9                	test   %ecx,%ecx
f0106912:	74 31                	je     f0106945 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0106914:	89 f8                	mov    %edi,%eax
f0106916:	09 c8                	or     %ecx,%eax
f0106918:	a8 03                	test   $0x3,%al
f010691a:	75 23                	jne    f010693f <memset+0x3b>
		c &= 0xFF;
f010691c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0106920:	89 d3                	mov    %edx,%ebx
f0106922:	c1 e3 08             	shl    $0x8,%ebx
f0106925:	89 d0                	mov    %edx,%eax
f0106927:	c1 e0 18             	shl    $0x18,%eax
f010692a:	89 d6                	mov    %edx,%esi
f010692c:	c1 e6 10             	shl    $0x10,%esi
f010692f:	09 f0                	or     %esi,%eax
f0106931:	09 c2                	or     %eax,%edx
f0106933:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0106935:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0106938:	89 d0                	mov    %edx,%eax
f010693a:	fc                   	cld    
f010693b:	f3 ab                	rep stos %eax,%es:(%edi)
f010693d:	eb 06                	jmp    f0106945 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010693f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106942:	fc                   	cld    
f0106943:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0106945:	89 f8                	mov    %edi,%eax
f0106947:	5b                   	pop    %ebx
f0106948:	5e                   	pop    %esi
f0106949:	5f                   	pop    %edi
f010694a:	5d                   	pop    %ebp
f010694b:	c3                   	ret    

f010694c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010694c:	55                   	push   %ebp
f010694d:	89 e5                	mov    %esp,%ebp
f010694f:	57                   	push   %edi
f0106950:	56                   	push   %esi
f0106951:	8b 45 08             	mov    0x8(%ebp),%eax
f0106954:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106957:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010695a:	39 c6                	cmp    %eax,%esi
f010695c:	73 32                	jae    f0106990 <memmove+0x44>
f010695e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106961:	39 c2                	cmp    %eax,%edx
f0106963:	76 2b                	jbe    f0106990 <memmove+0x44>
		s += n;
		d += n;
f0106965:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106968:	89 fe                	mov    %edi,%esi
f010696a:	09 ce                	or     %ecx,%esi
f010696c:	09 d6                	or     %edx,%esi
f010696e:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106974:	75 0e                	jne    f0106984 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106976:	83 ef 04             	sub    $0x4,%edi
f0106979:	8d 72 fc             	lea    -0x4(%edx),%esi
f010697c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010697f:	fd                   	std    
f0106980:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106982:	eb 09                	jmp    f010698d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106984:	83 ef 01             	sub    $0x1,%edi
f0106987:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010698a:	fd                   	std    
f010698b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010698d:	fc                   	cld    
f010698e:	eb 1a                	jmp    f01069aa <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106990:	89 c2                	mov    %eax,%edx
f0106992:	09 ca                	or     %ecx,%edx
f0106994:	09 f2                	or     %esi,%edx
f0106996:	f6 c2 03             	test   $0x3,%dl
f0106999:	75 0a                	jne    f01069a5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010699b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010699e:	89 c7                	mov    %eax,%edi
f01069a0:	fc                   	cld    
f01069a1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01069a3:	eb 05                	jmp    f01069aa <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f01069a5:	89 c7                	mov    %eax,%edi
f01069a7:	fc                   	cld    
f01069a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f01069aa:	5e                   	pop    %esi
f01069ab:	5f                   	pop    %edi
f01069ac:	5d                   	pop    %ebp
f01069ad:	c3                   	ret    

f01069ae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01069ae:	55                   	push   %ebp
f01069af:	89 e5                	mov    %esp,%ebp
f01069b1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f01069b4:	ff 75 10             	pushl  0x10(%ebp)
f01069b7:	ff 75 0c             	pushl  0xc(%ebp)
f01069ba:	ff 75 08             	pushl  0x8(%ebp)
f01069bd:	e8 8a ff ff ff       	call   f010694c <memmove>
}
f01069c2:	c9                   	leave  
f01069c3:	c3                   	ret    

f01069c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01069c4:	55                   	push   %ebp
f01069c5:	89 e5                	mov    %esp,%ebp
f01069c7:	56                   	push   %esi
f01069c8:	53                   	push   %ebx
f01069c9:	8b 45 08             	mov    0x8(%ebp),%eax
f01069cc:	8b 55 0c             	mov    0xc(%ebp),%edx
f01069cf:	89 c6                	mov    %eax,%esi
f01069d1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01069d4:	39 f0                	cmp    %esi,%eax
f01069d6:	74 1c                	je     f01069f4 <memcmp+0x30>
		if (*s1 != *s2)
f01069d8:	0f b6 08             	movzbl (%eax),%ecx
f01069db:	0f b6 1a             	movzbl (%edx),%ebx
f01069de:	38 d9                	cmp    %bl,%cl
f01069e0:	75 08                	jne    f01069ea <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01069e2:	83 c0 01             	add    $0x1,%eax
f01069e5:	83 c2 01             	add    $0x1,%edx
f01069e8:	eb ea                	jmp    f01069d4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01069ea:	0f b6 c1             	movzbl %cl,%eax
f01069ed:	0f b6 db             	movzbl %bl,%ebx
f01069f0:	29 d8                	sub    %ebx,%eax
f01069f2:	eb 05                	jmp    f01069f9 <memcmp+0x35>
	}

	return 0;
f01069f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01069f9:	5b                   	pop    %ebx
f01069fa:	5e                   	pop    %esi
f01069fb:	5d                   	pop    %ebp
f01069fc:	c3                   	ret    

f01069fd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01069fd:	55                   	push   %ebp
f01069fe:	89 e5                	mov    %esp,%ebp
f0106a00:	8b 45 08             	mov    0x8(%ebp),%eax
f0106a03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0106a06:	89 c2                	mov    %eax,%edx
f0106a08:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0106a0b:	39 d0                	cmp    %edx,%eax
f0106a0d:	73 09                	jae    f0106a18 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106a0f:	38 08                	cmp    %cl,(%eax)
f0106a11:	74 05                	je     f0106a18 <memfind+0x1b>
	for (; s < ends; s++)
f0106a13:	83 c0 01             	add    $0x1,%eax
f0106a16:	eb f3                	jmp    f0106a0b <memfind+0xe>
			break;
	return (void *) s;
}
f0106a18:	5d                   	pop    %ebp
f0106a19:	c3                   	ret    

f0106a1a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106a1a:	55                   	push   %ebp
f0106a1b:	89 e5                	mov    %esp,%ebp
f0106a1d:	57                   	push   %edi
f0106a1e:	56                   	push   %esi
f0106a1f:	53                   	push   %ebx
f0106a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106a23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106a26:	eb 03                	jmp    f0106a2b <strtol+0x11>
		s++;
f0106a28:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0106a2b:	0f b6 01             	movzbl (%ecx),%eax
f0106a2e:	3c 20                	cmp    $0x20,%al
f0106a30:	74 f6                	je     f0106a28 <strtol+0xe>
f0106a32:	3c 09                	cmp    $0x9,%al
f0106a34:	74 f2                	je     f0106a28 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0106a36:	3c 2b                	cmp    $0x2b,%al
f0106a38:	74 2a                	je     f0106a64 <strtol+0x4a>
	int neg = 0;
f0106a3a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0106a3f:	3c 2d                	cmp    $0x2d,%al
f0106a41:	74 2b                	je     f0106a6e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106a43:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0106a49:	75 0f                	jne    f0106a5a <strtol+0x40>
f0106a4b:	80 39 30             	cmpb   $0x30,(%ecx)
f0106a4e:	74 28                	je     f0106a78 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106a50:	85 db                	test   %ebx,%ebx
f0106a52:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106a57:	0f 44 d8             	cmove  %eax,%ebx
f0106a5a:	b8 00 00 00 00       	mov    $0x0,%eax
f0106a5f:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106a62:	eb 50                	jmp    f0106ab4 <strtol+0x9a>
		s++;
f0106a64:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0106a67:	bf 00 00 00 00       	mov    $0x0,%edi
f0106a6c:	eb d5                	jmp    f0106a43 <strtol+0x29>
		s++, neg = 1;
f0106a6e:	83 c1 01             	add    $0x1,%ecx
f0106a71:	bf 01 00 00 00       	mov    $0x1,%edi
f0106a76:	eb cb                	jmp    f0106a43 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106a78:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0106a7c:	74 0e                	je     f0106a8c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0106a7e:	85 db                	test   %ebx,%ebx
f0106a80:	75 d8                	jne    f0106a5a <strtol+0x40>
		s++, base = 8;
f0106a82:	83 c1 01             	add    $0x1,%ecx
f0106a85:	bb 08 00 00 00       	mov    $0x8,%ebx
f0106a8a:	eb ce                	jmp    f0106a5a <strtol+0x40>
		s += 2, base = 16;
f0106a8c:	83 c1 02             	add    $0x2,%ecx
f0106a8f:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106a94:	eb c4                	jmp    f0106a5a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106a96:	8d 72 9f             	lea    -0x61(%edx),%esi
f0106a99:	89 f3                	mov    %esi,%ebx
f0106a9b:	80 fb 19             	cmp    $0x19,%bl
f0106a9e:	77 29                	ja     f0106ac9 <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106aa0:	0f be d2             	movsbl %dl,%edx
f0106aa3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106aa6:	3b 55 10             	cmp    0x10(%ebp),%edx
f0106aa9:	7d 30                	jge    f0106adb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0106aab:	83 c1 01             	add    $0x1,%ecx
f0106aae:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106ab2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106ab4:	0f b6 11             	movzbl (%ecx),%edx
f0106ab7:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106aba:	89 f3                	mov    %esi,%ebx
f0106abc:	80 fb 09             	cmp    $0x9,%bl
f0106abf:	77 d5                	ja     f0106a96 <strtol+0x7c>
			dig = *s - '0';
f0106ac1:	0f be d2             	movsbl %dl,%edx
f0106ac4:	83 ea 30             	sub    $0x30,%edx
f0106ac7:	eb dd                	jmp    f0106aa6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f0106ac9:	8d 72 bf             	lea    -0x41(%edx),%esi
f0106acc:	89 f3                	mov    %esi,%ebx
f0106ace:	80 fb 19             	cmp    $0x19,%bl
f0106ad1:	77 08                	ja     f0106adb <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106ad3:	0f be d2             	movsbl %dl,%edx
f0106ad6:	83 ea 37             	sub    $0x37,%edx
f0106ad9:	eb cb                	jmp    f0106aa6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f0106adb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106adf:	74 05                	je     f0106ae6 <strtol+0xcc>
		*endptr = (char *) s;
f0106ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106ae4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0106ae6:	89 c2                	mov    %eax,%edx
f0106ae8:	f7 da                	neg    %edx
f0106aea:	85 ff                	test   %edi,%edi
f0106aec:	0f 45 c2             	cmovne %edx,%eax
}
f0106aef:	5b                   	pop    %ebx
f0106af0:	5e                   	pop    %esi
f0106af1:	5f                   	pop    %edi
f0106af2:	5d                   	pop    %ebp
f0106af3:	c3                   	ret    

f0106af4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106af4:	fa                   	cli    

	xorw    %ax, %ax
f0106af5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0106af7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106af9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106afb:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106afd:	0f 01 16             	lgdtl  (%esi)
f0106b00:	7c 70                	jl     f0106b72 <gdtdesc+0x2>
	movl    %cr0, %eax
f0106b02:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106b05:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106b09:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106b0c:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0106b12:	08 00                	or     %al,(%eax)

f0106b14 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0106b14:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106b18:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106b1a:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106b1c:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106b1e:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0106b22:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106b24:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0106b26:	b8 00 c0 16 00       	mov    $0x16c000,%eax
	movl    %eax, %cr3
f0106b2b:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f0106b2e:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f0106b31:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f0106b34:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f0106b37:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106b3a:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0106b3f:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106b42:	8b 25 84 ed 5d f0    	mov    0xf05ded84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106b48:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106b4d:	b8 4f 02 10 f0       	mov    $0xf010024f,%eax
	call    *%eax
f0106b52:	ff d0                	call   *%eax

f0106b54 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106b54:	eb fe                	jmp    f0106b54 <spin>
f0106b56:	66 90                	xchg   %ax,%ax

f0106b58 <gdt>:
	...
f0106b60:	ff                   	(bad)  
f0106b61:	ff 00                	incl   (%eax)
f0106b63:	00 00                	add    %al,(%eax)
f0106b65:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0106b6c:	00                   	.byte 0x0
f0106b6d:	92                   	xchg   %eax,%edx
f0106b6e:	cf                   	iret   
	...

f0106b70 <gdtdesc>:
f0106b70:	17                   	pop    %ss
f0106b71:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0106b76 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106b76:	90                   	nop

f0106b77 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106b77:	55                   	push   %ebp
f0106b78:	89 e5                	mov    %esp,%ebp
f0106b7a:	57                   	push   %edi
f0106b7b:	56                   	push   %esi
f0106b7c:	53                   	push   %ebx
f0106b7d:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106b80:	8b 0d 88 ed 5d f0    	mov    0xf05ded88,%ecx
f0106b86:	89 c3                	mov    %eax,%ebx
f0106b88:	c1 eb 0c             	shr    $0xc,%ebx
f0106b8b:	39 cb                	cmp    %ecx,%ebx
f0106b8d:	73 1a                	jae    f0106ba9 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0106b8f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106b95:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106b98:	89 f8                	mov    %edi,%eax
f0106b9a:	c1 e8 0c             	shr    $0xc,%eax
f0106b9d:	39 c8                	cmp    %ecx,%eax
f0106b9f:	73 1a                	jae    f0106bbb <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106ba1:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106ba7:	eb 27                	jmp    f0106bd0 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106ba9:	50                   	push   %eax
f0106baa:	68 74 80 10 f0       	push   $0xf0108074
f0106baf:	6a 58                	push   $0x58
f0106bb1:	68 e5 a4 10 f0       	push   $0xf010a4e5
f0106bb6:	e8 8e 94 ff ff       	call   f0100049 <_panic>
f0106bbb:	57                   	push   %edi
f0106bbc:	68 74 80 10 f0       	push   $0xf0108074
f0106bc1:	6a 58                	push   $0x58
f0106bc3:	68 e5 a4 10 f0       	push   $0xf010a4e5
f0106bc8:	e8 7c 94 ff ff       	call   f0100049 <_panic>
f0106bcd:	83 c3 10             	add    $0x10,%ebx
f0106bd0:	39 fb                	cmp    %edi,%ebx
f0106bd2:	73 30                	jae    f0106c04 <mpsearch1+0x8d>
f0106bd4:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106bd6:	83 ec 04             	sub    $0x4,%esp
f0106bd9:	6a 04                	push   $0x4
f0106bdb:	68 f5 a4 10 f0       	push   $0xf010a4f5
f0106be0:	53                   	push   %ebx
f0106be1:	e8 de fd ff ff       	call   f01069c4 <memcmp>
f0106be6:	83 c4 10             	add    $0x10,%esp
f0106be9:	85 c0                	test   %eax,%eax
f0106beb:	75 e0                	jne    f0106bcd <mpsearch1+0x56>
f0106bed:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0106bef:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0106bf2:	0f b6 0a             	movzbl (%edx),%ecx
f0106bf5:	01 c8                	add    %ecx,%eax
f0106bf7:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0106bfa:	39 f2                	cmp    %esi,%edx
f0106bfc:	75 f4                	jne    f0106bf2 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106bfe:	84 c0                	test   %al,%al
f0106c00:	75 cb                	jne    f0106bcd <mpsearch1+0x56>
f0106c02:	eb 05                	jmp    f0106c09 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0106c04:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0106c09:	89 d8                	mov    %ebx,%eax
f0106c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106c0e:	5b                   	pop    %ebx
f0106c0f:	5e                   	pop    %esi
f0106c10:	5f                   	pop    %edi
f0106c11:	5d                   	pop    %ebp
f0106c12:	c3                   	ret    

f0106c13 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106c13:	55                   	push   %ebp
f0106c14:	89 e5                	mov    %esp,%ebp
f0106c16:	57                   	push   %edi
f0106c17:	56                   	push   %esi
f0106c18:	53                   	push   %ebx
f0106c19:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106c1c:	c7 05 00 b0 16 f0 20 	movl   $0xf016b020,0xf016b000
f0106c23:	b0 16 f0 
	if (PGNUM(pa) >= npages)
f0106c26:	83 3d 88 ed 5d f0 00 	cmpl   $0x0,0xf05ded88
f0106c2d:	0f 84 a3 00 00 00    	je     f0106cd6 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106c33:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0106c3a:	85 c0                	test   %eax,%eax
f0106c3c:	0f 84 aa 00 00 00    	je     f0106cec <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f0106c42:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106c45:	ba 00 04 00 00       	mov    $0x400,%edx
f0106c4a:	e8 28 ff ff ff       	call   f0106b77 <mpsearch1>
f0106c4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106c52:	85 c0                	test   %eax,%eax
f0106c54:	75 1a                	jne    f0106c70 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0106c56:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c5b:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106c60:	e8 12 ff ff ff       	call   f0106b77 <mpsearch1>
f0106c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0106c68:	85 c0                	test   %eax,%eax
f0106c6a:	0f 84 31 02 00 00    	je     f0106ea1 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106c73:	8b 58 04             	mov    0x4(%eax),%ebx
f0106c76:	85 db                	test   %ebx,%ebx
f0106c78:	0f 84 97 00 00 00    	je     f0106d15 <mp_init+0x102>
f0106c7e:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106c82:	0f 85 8d 00 00 00    	jne    f0106d15 <mp_init+0x102>
f0106c88:	89 d8                	mov    %ebx,%eax
f0106c8a:	c1 e8 0c             	shr    $0xc,%eax
f0106c8d:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0106c93:	0f 83 91 00 00 00    	jae    f0106d2a <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106c99:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0106c9f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106ca1:	83 ec 04             	sub    $0x4,%esp
f0106ca4:	6a 04                	push   $0x4
f0106ca6:	68 fa a4 10 f0       	push   $0xf010a4fa
f0106cab:	53                   	push   %ebx
f0106cac:	e8 13 fd ff ff       	call   f01069c4 <memcmp>
f0106cb1:	83 c4 10             	add    $0x10,%esp
f0106cb4:	85 c0                	test   %eax,%eax
f0106cb6:	0f 85 83 00 00 00    	jne    f0106d3f <mp_init+0x12c>
f0106cbc:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106cc0:	01 df                	add    %ebx,%edi
	sum = 0;
f0106cc2:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106cc4:	39 fb                	cmp    %edi,%ebx
f0106cc6:	0f 84 88 00 00 00    	je     f0106d54 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f0106ccc:	0f b6 0b             	movzbl (%ebx),%ecx
f0106ccf:	01 ca                	add    %ecx,%edx
f0106cd1:	83 c3 01             	add    $0x1,%ebx
f0106cd4:	eb ee                	jmp    f0106cc4 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106cd6:	68 00 04 00 00       	push   $0x400
f0106cdb:	68 74 80 10 f0       	push   $0xf0108074
f0106ce0:	6a 70                	push   $0x70
f0106ce2:	68 e5 a4 10 f0       	push   $0xf010a4e5
f0106ce7:	e8 5d 93 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0106cec:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0106cf3:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0106cf6:	2d 00 04 00 00       	sub    $0x400,%eax
f0106cfb:	ba 00 04 00 00       	mov    $0x400,%edx
f0106d00:	e8 72 fe ff ff       	call   f0106b77 <mpsearch1>
f0106d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106d08:	85 c0                	test   %eax,%eax
f0106d0a:	0f 85 60 ff ff ff    	jne    f0106c70 <mp_init+0x5d>
f0106d10:	e9 41 ff ff ff       	jmp    f0106c56 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f0106d15:	83 ec 0c             	sub    $0xc,%esp
f0106d18:	68 58 a3 10 f0       	push   $0xf010a358
f0106d1d:	e8 d4 d4 ff ff       	call   f01041f6 <cprintf>
f0106d22:	83 c4 10             	add    $0x10,%esp
f0106d25:	e9 77 01 00 00       	jmp    f0106ea1 <mp_init+0x28e>
f0106d2a:	53                   	push   %ebx
f0106d2b:	68 74 80 10 f0       	push   $0xf0108074
f0106d30:	68 91 00 00 00       	push   $0x91
f0106d35:	68 e5 a4 10 f0       	push   $0xf010a4e5
f0106d3a:	e8 0a 93 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106d3f:	83 ec 0c             	sub    $0xc,%esp
f0106d42:	68 88 a3 10 f0       	push   $0xf010a388
f0106d47:	e8 aa d4 ff ff       	call   f01041f6 <cprintf>
f0106d4c:	83 c4 10             	add    $0x10,%esp
f0106d4f:	e9 4d 01 00 00       	jmp    f0106ea1 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0106d54:	84 d2                	test   %dl,%dl
f0106d56:	75 16                	jne    f0106d6e <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0106d58:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0106d5c:	80 fa 01             	cmp    $0x1,%dl
f0106d5f:	74 05                	je     f0106d66 <mp_init+0x153>
f0106d61:	80 fa 04             	cmp    $0x4,%dl
f0106d64:	75 1d                	jne    f0106d83 <mp_init+0x170>
f0106d66:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0106d6a:	01 d9                	add    %ebx,%ecx
f0106d6c:	eb 36                	jmp    f0106da4 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106d6e:	83 ec 0c             	sub    $0xc,%esp
f0106d71:	68 bc a3 10 f0       	push   $0xf010a3bc
f0106d76:	e8 7b d4 ff ff       	call   f01041f6 <cprintf>
f0106d7b:	83 c4 10             	add    $0x10,%esp
f0106d7e:	e9 1e 01 00 00       	jmp    f0106ea1 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106d83:	83 ec 08             	sub    $0x8,%esp
f0106d86:	0f b6 d2             	movzbl %dl,%edx
f0106d89:	52                   	push   %edx
f0106d8a:	68 e0 a3 10 f0       	push   $0xf010a3e0
f0106d8f:	e8 62 d4 ff ff       	call   f01041f6 <cprintf>
f0106d94:	83 c4 10             	add    $0x10,%esp
f0106d97:	e9 05 01 00 00       	jmp    f0106ea1 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106d9c:	0f b6 13             	movzbl (%ebx),%edx
f0106d9f:	01 d0                	add    %edx,%eax
f0106da1:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106da4:	39 d9                	cmp    %ebx,%ecx
f0106da6:	75 f4                	jne    f0106d9c <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106da8:	02 46 2a             	add    0x2a(%esi),%al
f0106dab:	75 1c                	jne    f0106dc9 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106dad:	c7 05 94 ed 5d f0 01 	movl   $0x1,0xf05ded94
f0106db4:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106db7:	8b 46 24             	mov    0x24(%esi),%eax
f0106dba:	a3 9c ed 5d f0       	mov    %eax,0xf05ded9c

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106dbf:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106dc7:	eb 4d                	jmp    f0106e16 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106dc9:	83 ec 0c             	sub    $0xc,%esp
f0106dcc:	68 00 a4 10 f0       	push   $0xf010a400
f0106dd1:	e8 20 d4 ff ff       	call   f01041f6 <cprintf>
f0106dd6:	83 c4 10             	add    $0x10,%esp
f0106dd9:	e9 c3 00 00 00       	jmp    f0106ea1 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106dde:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106de2:	74 11                	je     f0106df5 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106de4:	6b 05 98 ed 5d f0 74 	imul   $0x74,0xf05ded98,%eax
f0106deb:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f0106df0:	a3 00 b0 16 f0       	mov    %eax,0xf016b000
			if (ncpu < NCPU) {
f0106df5:	a1 98 ed 5d f0       	mov    0xf05ded98,%eax
f0106dfa:	83 f8 07             	cmp    $0x7,%eax
f0106dfd:	7f 2f                	jg     f0106e2e <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0106dff:	6b d0 74             	imul   $0x74,%eax,%edx
f0106e02:	88 82 20 b0 16 f0    	mov    %al,-0xfe94fe0(%edx)
				ncpu++;
f0106e08:	83 c0 01             	add    $0x1,%eax
f0106e0b:	a3 98 ed 5d f0       	mov    %eax,0xf05ded98
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106e10:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106e13:	83 c3 01             	add    $0x1,%ebx
f0106e16:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0106e1a:	39 d8                	cmp    %ebx,%eax
f0106e1c:	76 4b                	jbe    f0106e69 <mp_init+0x256>
		switch (*p) {
f0106e1e:	0f b6 07             	movzbl (%edi),%eax
f0106e21:	84 c0                	test   %al,%al
f0106e23:	74 b9                	je     f0106dde <mp_init+0x1cb>
f0106e25:	3c 04                	cmp    $0x4,%al
f0106e27:	77 1c                	ja     f0106e45 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106e29:	83 c7 08             	add    $0x8,%edi
			continue;
f0106e2c:	eb e5                	jmp    f0106e13 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106e2e:	83 ec 08             	sub    $0x8,%esp
f0106e31:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106e35:	50                   	push   %eax
f0106e36:	68 30 a4 10 f0       	push   $0xf010a430
f0106e3b:	e8 b6 d3 ff ff       	call   f01041f6 <cprintf>
f0106e40:	83 c4 10             	add    $0x10,%esp
f0106e43:	eb cb                	jmp    f0106e10 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106e45:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106e48:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106e4b:	50                   	push   %eax
f0106e4c:	68 58 a4 10 f0       	push   $0xf010a458
f0106e51:	e8 a0 d3 ff ff       	call   f01041f6 <cprintf>
			ismp = 0;
f0106e56:	c7 05 94 ed 5d f0 00 	movl   $0x0,0xf05ded94
f0106e5d:	00 00 00 
			i = conf->entry;
f0106e60:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106e64:	83 c4 10             	add    $0x10,%esp
f0106e67:	eb aa                	jmp    f0106e13 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106e69:	a1 00 b0 16 f0       	mov    0xf016b000,%eax
f0106e6e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106e75:	83 3d 94 ed 5d f0 00 	cmpl   $0x0,0xf05ded94
f0106e7c:	74 2b                	je     f0106ea9 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106e7e:	83 ec 04             	sub    $0x4,%esp
f0106e81:	ff 35 98 ed 5d f0    	pushl  0xf05ded98
f0106e87:	0f b6 00             	movzbl (%eax),%eax
f0106e8a:	50                   	push   %eax
f0106e8b:	68 ff a4 10 f0       	push   $0xf010a4ff
f0106e90:	e8 61 d3 ff ff       	call   f01041f6 <cprintf>

	if (mp->imcrp) {
f0106e95:	83 c4 10             	add    $0x10,%esp
f0106e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106e9b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106e9f:	75 2e                	jne    f0106ecf <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106ea4:	5b                   	pop    %ebx
f0106ea5:	5e                   	pop    %esi
f0106ea6:	5f                   	pop    %edi
f0106ea7:	5d                   	pop    %ebp
f0106ea8:	c3                   	ret    
		ncpu = 1;
f0106ea9:	c7 05 98 ed 5d f0 01 	movl   $0x1,0xf05ded98
f0106eb0:	00 00 00 
		lapicaddr = 0;
f0106eb3:	c7 05 9c ed 5d f0 00 	movl   $0x0,0xf05ded9c
f0106eba:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106ebd:	83 ec 0c             	sub    $0xc,%esp
f0106ec0:	68 78 a4 10 f0       	push   $0xf010a478
f0106ec5:	e8 2c d3 ff ff       	call   f01041f6 <cprintf>
		return;
f0106eca:	83 c4 10             	add    $0x10,%esp
f0106ecd:	eb d2                	jmp    f0106ea1 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106ecf:	83 ec 0c             	sub    $0xc,%esp
f0106ed2:	68 a4 a4 10 f0       	push   $0xf010a4a4
f0106ed7:	e8 1a d3 ff ff       	call   f01041f6 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106edc:	b8 70 00 00 00       	mov    $0x70,%eax
f0106ee1:	ba 22 00 00 00       	mov    $0x22,%edx
f0106ee6:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106ee7:	ba 23 00 00 00       	mov    $0x23,%edx
f0106eec:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106eed:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106ef0:	ee                   	out    %al,(%dx)
f0106ef1:	83 c4 10             	add    $0x10,%esp
f0106ef4:	eb ab                	jmp    f0106ea1 <mp_init+0x28e>

f0106ef6 <lapicw>:
volatile uint32_t *lapic __user_mapped_data;	//lab7 bug mapped data

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106ef6:	8b 0d c0 b3 16 f0    	mov    0xf016b3c0,%ecx
f0106efc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106eff:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106f01:	a1 c0 b3 16 f0       	mov    0xf016b3c0,%eax
f0106f06:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106f09:	c3                   	ret    

f0106f0a <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f0106f0a:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f0106f10:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f0106f15:	85 d2                	test   %edx,%edx
f0106f17:	74 06                	je     f0106f1f <cpunum+0x15>
		return lapic[ID] >> 24;
f0106f19:	8b 42 20             	mov    0x20(%edx),%eax
f0106f1c:	c1 e8 18             	shr    $0x18,%eax
}
f0106f1f:	c3                   	ret    

f0106f20 <lapic_init>:
{
f0106f20:	55                   	push   %ebp
f0106f21:	89 e5                	mov    %esp,%ebp
f0106f23:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f0106f26:	68 2c a5 10 f0       	push   $0xf010a52c
f0106f2b:	68 bc 80 10 f0       	push   $0xf01080bc
f0106f30:	e8 c1 d2 ff ff       	call   f01041f6 <cprintf>
	if (!lapicaddr)
f0106f35:	a1 9c ed 5d f0       	mov    0xf05ded9c,%eax
f0106f3a:	83 c4 10             	add    $0x10,%esp
f0106f3d:	85 c0                	test   %eax,%eax
f0106f3f:	75 02                	jne    f0106f43 <lapic_init+0x23>
}
f0106f41:	c9                   	leave  
f0106f42:	c3                   	ret    
	lapic = mmio_map_region(lapicaddr, 4096);
f0106f43:	83 ec 08             	sub    $0x8,%esp
f0106f46:	68 00 10 00 00       	push   $0x1000
f0106f4b:	50                   	push   %eax
f0106f4c:	e8 0a a8 ff ff       	call   f010175b <mmio_map_region>
f0106f51:	a3 c0 b3 16 f0       	mov    %eax,0xf016b3c0
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106f56:	ba 27 01 00 00       	mov    $0x127,%edx
f0106f5b:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106f60:	e8 91 ff ff ff       	call   f0106ef6 <lapicw>
	lapicw(TDCR, X1);
f0106f65:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106f6a:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106f6f:	e8 82 ff ff ff       	call   f0106ef6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106f74:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106f79:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106f7e:	e8 73 ff ff ff       	call   f0106ef6 <lapicw>
	lapicw(TICR, 10000000); 
f0106f83:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106f88:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106f8d:	e8 64 ff ff ff       	call   f0106ef6 <lapicw>
	if (thiscpu != bootcpu)
f0106f92:	e8 73 ff ff ff       	call   f0106f0a <cpunum>
f0106f97:	6b c0 74             	imul   $0x74,%eax,%eax
f0106f9a:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f0106f9f:	83 c4 10             	add    $0x10,%esp
f0106fa2:	39 05 00 b0 16 f0    	cmp    %eax,0xf016b000
f0106fa8:	74 0f                	je     f0106fb9 <lapic_init+0x99>
		lapicw(LINT0, MASKED);
f0106faa:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106faf:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106fb4:	e8 3d ff ff ff       	call   f0106ef6 <lapicw>
	lapicw(LINT1, MASKED);
f0106fb9:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106fbe:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106fc3:	e8 2e ff ff ff       	call   f0106ef6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106fc8:	a1 c0 b3 16 f0       	mov    0xf016b3c0,%eax
f0106fcd:	8b 40 30             	mov    0x30(%eax),%eax
f0106fd0:	c1 e8 10             	shr    $0x10,%eax
f0106fd3:	a8 fc                	test   $0xfc,%al
f0106fd5:	75 7f                	jne    f0107056 <lapic_init+0x136>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106fd7:	ba 33 00 00 00       	mov    $0x33,%edx
f0106fdc:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106fe1:	e8 10 ff ff ff       	call   f0106ef6 <lapicw>
	lapicw(ESR, 0);
f0106fe6:	ba 00 00 00 00       	mov    $0x0,%edx
f0106feb:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106ff0:	e8 01 ff ff ff       	call   f0106ef6 <lapicw>
	lapicw(ESR, 0);
f0106ff5:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ffa:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106fff:	e8 f2 fe ff ff       	call   f0106ef6 <lapicw>
	lapicw(EOI, 0);
f0107004:	ba 00 00 00 00       	mov    $0x0,%edx
f0107009:	b8 2c 00 00 00       	mov    $0x2c,%eax
f010700e:	e8 e3 fe ff ff       	call   f0106ef6 <lapicw>
	lapicw(ICRHI, 0);
f0107013:	ba 00 00 00 00       	mov    $0x0,%edx
f0107018:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010701d:	e8 d4 fe ff ff       	call   f0106ef6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0107022:	ba 00 85 08 00       	mov    $0x88500,%edx
f0107027:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010702c:	e8 c5 fe ff ff       	call   f0106ef6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0107031:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
f0107037:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010703d:	f6 c4 10             	test   $0x10,%ah
f0107040:	75 f5                	jne    f0107037 <lapic_init+0x117>
	lapicw(TPR, 0);
f0107042:	ba 00 00 00 00       	mov    $0x0,%edx
f0107047:	b8 20 00 00 00       	mov    $0x20,%eax
f010704c:	e8 a5 fe ff ff       	call   f0106ef6 <lapicw>
f0107051:	e9 eb fe ff ff       	jmp    f0106f41 <lapic_init+0x21>
		lapicw(PCINT, MASKED);
f0107056:	ba 00 00 01 00       	mov    $0x10000,%edx
f010705b:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0107060:	e8 91 fe ff ff       	call   f0106ef6 <lapicw>
f0107065:	e9 6d ff ff ff       	jmp    f0106fd7 <lapic_init+0xb7>

f010706a <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f010706a:	83 3d c0 b3 16 f0 00 	cmpl   $0x0,0xf016b3c0
f0107071:	74 17                	je     f010708a <lapic_eoi+0x20>
{
f0107073:	55                   	push   %ebp
f0107074:	89 e5                	mov    %esp,%ebp
f0107076:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0107079:	ba 00 00 00 00       	mov    $0x0,%edx
f010707e:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0107083:	e8 6e fe ff ff       	call   f0106ef6 <lapicw>
}
f0107088:	c9                   	leave  
f0107089:	c3                   	ret    
f010708a:	c3                   	ret    

f010708b <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f010708b:	55                   	push   %ebp
f010708c:	89 e5                	mov    %esp,%ebp
f010708e:	56                   	push   %esi
f010708f:	53                   	push   %ebx
f0107090:	8b 75 08             	mov    0x8(%ebp),%esi
f0107093:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0107096:	b8 0f 00 00 00       	mov    $0xf,%eax
f010709b:	ba 70 00 00 00       	mov    $0x70,%edx
f01070a0:	ee                   	out    %al,(%dx)
f01070a1:	b8 0a 00 00 00       	mov    $0xa,%eax
f01070a6:	ba 71 00 00 00       	mov    $0x71,%edx
f01070ab:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f01070ac:	83 3d 88 ed 5d f0 00 	cmpl   $0x0,0xf05ded88
f01070b3:	74 7e                	je     f0107133 <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f01070b5:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f01070bc:	00 00 
	wrv[1] = addr >> 4;
f01070be:	89 d8                	mov    %ebx,%eax
f01070c0:	c1 e8 04             	shr    $0x4,%eax
f01070c3:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f01070c9:	c1 e6 18             	shl    $0x18,%esi
f01070cc:	89 f2                	mov    %esi,%edx
f01070ce:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01070d3:	e8 1e fe ff ff       	call   f0106ef6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f01070d8:	ba 00 c5 00 00       	mov    $0xc500,%edx
f01070dd:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01070e2:	e8 0f fe ff ff       	call   f0106ef6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f01070e7:	ba 00 85 00 00       	mov    $0x8500,%edx
f01070ec:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01070f1:	e8 00 fe ff ff       	call   f0106ef6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01070f6:	c1 eb 0c             	shr    $0xc,%ebx
f01070f9:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f01070fc:	89 f2                	mov    %esi,%edx
f01070fe:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107103:	e8 ee fd ff ff       	call   f0106ef6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107108:	89 da                	mov    %ebx,%edx
f010710a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010710f:	e8 e2 fd ff ff       	call   f0106ef6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0107114:	89 f2                	mov    %esi,%edx
f0107116:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010711b:	e8 d6 fd ff ff       	call   f0106ef6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107120:	89 da                	mov    %ebx,%edx
f0107122:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107127:	e8 ca fd ff ff       	call   f0106ef6 <lapicw>
		microdelay(200);
	}
}
f010712c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010712f:	5b                   	pop    %ebx
f0107130:	5e                   	pop    %esi
f0107131:	5d                   	pop    %ebp
f0107132:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107133:	68 67 04 00 00       	push   $0x467
f0107138:	68 74 80 10 f0       	push   $0xf0108074
f010713d:	68 9e 00 00 00       	push   $0x9e
f0107142:	68 1c a5 10 f0       	push   $0xf010a51c
f0107147:	e8 fd 8e ff ff       	call   f0100049 <_panic>

f010714c <lapic_ipi>:

void
lapic_ipi(int vector)
{
f010714c:	55                   	push   %ebp
f010714d:	89 e5                	mov    %esp,%ebp
f010714f:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0107152:	8b 55 08             	mov    0x8(%ebp),%edx
f0107155:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010715b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107160:	e8 91 fd ff ff       	call   f0106ef6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0107165:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
f010716b:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0107171:	f6 c4 10             	test   $0x10,%ah
f0107174:	75 f5                	jne    f010716b <lapic_ipi+0x1f>
		;
}
f0107176:	c9                   	leave  
f0107177:	c3                   	ret    

f0107178 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0107178:	55                   	push   %ebp
f0107179:	89 e5                	mov    %esp,%ebp
f010717b:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010717e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0107184:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107187:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010718a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0107191:	5d                   	pop    %ebp
f0107192:	c3                   	ret    

f0107193 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0107193:	55                   	push   %ebp
f0107194:	89 e5                	mov    %esp,%ebp
f0107196:	56                   	push   %esi
f0107197:	53                   	push   %ebx
f0107198:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010719b:	83 3b 00             	cmpl   $0x0,(%ebx)
f010719e:	75 12                	jne    f01071b2 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f01071a0:	ba 01 00 00 00       	mov    $0x1,%edx
f01071a5:	89 d0                	mov    %edx,%eax
f01071a7:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f01071aa:	85 c0                	test   %eax,%eax
f01071ac:	74 36                	je     f01071e4 <spin_lock+0x51>
		asm volatile ("pause");
f01071ae:	f3 90                	pause  
f01071b0:	eb f3                	jmp    f01071a5 <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f01071b2:	8b 73 08             	mov    0x8(%ebx),%esi
f01071b5:	e8 50 fd ff ff       	call   f0106f0a <cpunum>
f01071ba:	6b c0 74             	imul   $0x74,%eax,%eax
f01071bd:	05 20 b0 16 f0       	add    $0xf016b020,%eax
	if (holding(lk))
f01071c2:	39 c6                	cmp    %eax,%esi
f01071c4:	75 da                	jne    f01071a0 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f01071c6:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01071c9:	e8 3c fd ff ff       	call   f0106f0a <cpunum>
f01071ce:	83 ec 0c             	sub    $0xc,%esp
f01071d1:	53                   	push   %ebx
f01071d2:	50                   	push   %eax
f01071d3:	68 38 a5 10 f0       	push   $0xf010a538
f01071d8:	6a 41                	push   $0x41
f01071da:	68 9a a5 10 f0       	push   $0xf010a59a
f01071df:	e8 65 8e ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01071e4:	e8 21 fd ff ff       	call   f0106f0a <cpunum>
f01071e9:	6b c0 74             	imul   $0x74,%eax,%eax
f01071ec:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01071f1:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01071f4:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01071f6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01071fb:	83 f8 09             	cmp    $0x9,%eax
f01071fe:	7f 16                	jg     f0107216 <spin_lock+0x83>
f0107200:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0107206:	76 0e                	jbe    f0107216 <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0107208:	8b 4a 04             	mov    0x4(%edx),%ecx
f010720b:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f010720f:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0107211:	83 c0 01             	add    $0x1,%eax
f0107214:	eb e5                	jmp    f01071fb <spin_lock+0x68>
	for (; i < 10; i++)
f0107216:	83 f8 09             	cmp    $0x9,%eax
f0107219:	7f 0d                	jg     f0107228 <spin_lock+0x95>
		pcs[i] = 0;
f010721b:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0107222:	00 
	for (; i < 10; i++)
f0107223:	83 c0 01             	add    $0x1,%eax
f0107226:	eb ee                	jmp    f0107216 <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0107228:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010722b:	5b                   	pop    %ebx
f010722c:	5e                   	pop    %esi
f010722d:	5d                   	pop    %ebp
f010722e:	c3                   	ret    

f010722f <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f010722f:	55                   	push   %ebp
f0107230:	89 e5                	mov    %esp,%ebp
f0107232:	57                   	push   %edi
f0107233:	56                   	push   %esi
f0107234:	53                   	push   %ebx
f0107235:	83 ec 4c             	sub    $0x4c,%esp
f0107238:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f010723b:	83 3e 00             	cmpl   $0x0,(%esi)
f010723e:	75 35                	jne    f0107275 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0107240:	83 ec 04             	sub    $0x4,%esp
f0107243:	6a 28                	push   $0x28
f0107245:	8d 46 0c             	lea    0xc(%esi),%eax
f0107248:	50                   	push   %eax
f0107249:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f010724c:	53                   	push   %ebx
f010724d:	e8 fa f6 ff ff       	call   f010694c <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0107252:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0107255:	0f b6 38             	movzbl (%eax),%edi
f0107258:	8b 76 04             	mov    0x4(%esi),%esi
f010725b:	e8 aa fc ff ff       	call   f0106f0a <cpunum>
f0107260:	57                   	push   %edi
f0107261:	56                   	push   %esi
f0107262:	50                   	push   %eax
f0107263:	68 64 a5 10 f0       	push   $0xf010a564
f0107268:	e8 89 cf ff ff       	call   f01041f6 <cprintf>
f010726d:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0107270:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0107273:	eb 4e                	jmp    f01072c3 <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0107275:	8b 5e 08             	mov    0x8(%esi),%ebx
f0107278:	e8 8d fc ff ff       	call   f0106f0a <cpunum>
f010727d:	6b c0 74             	imul   $0x74,%eax,%eax
f0107280:	05 20 b0 16 f0       	add    $0xf016b020,%eax
	if (!holding(lk)) {
f0107285:	39 c3                	cmp    %eax,%ebx
f0107287:	75 b7                	jne    f0107240 <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0107289:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0107290:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0107297:	b8 00 00 00 00       	mov    $0x0,%eax
f010729c:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f010729f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01072a2:	5b                   	pop    %ebx
f01072a3:	5e                   	pop    %esi
f01072a4:	5f                   	pop    %edi
f01072a5:	5d                   	pop    %ebp
f01072a6:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f01072a7:	83 ec 08             	sub    $0x8,%esp
f01072aa:	ff 36                	pushl  (%esi)
f01072ac:	68 c1 a5 10 f0       	push   $0xf010a5c1
f01072b1:	e8 40 cf ff ff       	call   f01041f6 <cprintf>
f01072b6:	83 c4 10             	add    $0x10,%esp
f01072b9:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f01072bc:	8d 45 e8             	lea    -0x18(%ebp),%eax
f01072bf:	39 c3                	cmp    %eax,%ebx
f01072c1:	74 40                	je     f0107303 <spin_unlock+0xd4>
f01072c3:	89 de                	mov    %ebx,%esi
f01072c5:	8b 03                	mov    (%ebx),%eax
f01072c7:	85 c0                	test   %eax,%eax
f01072c9:	74 38                	je     f0107303 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01072cb:	83 ec 08             	sub    $0x8,%esp
f01072ce:	57                   	push   %edi
f01072cf:	50                   	push   %eax
f01072d0:	e8 c8 e9 ff ff       	call   f0105c9d <debuginfo_eip>
f01072d5:	83 c4 10             	add    $0x10,%esp
f01072d8:	85 c0                	test   %eax,%eax
f01072da:	78 cb                	js     f01072a7 <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f01072dc:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01072de:	83 ec 04             	sub    $0x4,%esp
f01072e1:	89 c2                	mov    %eax,%edx
f01072e3:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01072e6:	52                   	push   %edx
f01072e7:	ff 75 b0             	pushl  -0x50(%ebp)
f01072ea:	ff 75 b4             	pushl  -0x4c(%ebp)
f01072ed:	ff 75 ac             	pushl  -0x54(%ebp)
f01072f0:	ff 75 a8             	pushl  -0x58(%ebp)
f01072f3:	50                   	push   %eax
f01072f4:	68 aa a5 10 f0       	push   $0xf010a5aa
f01072f9:	e8 f8 ce ff ff       	call   f01041f6 <cprintf>
f01072fe:	83 c4 20             	add    $0x20,%esp
f0107301:	eb b6                	jmp    f01072b9 <spin_unlock+0x8a>
		panic("spin_unlock");
f0107303:	83 ec 04             	sub    $0x4,%esp
f0107306:	68 c9 a5 10 f0       	push   $0xf010a5c9
f010730b:	6a 67                	push   $0x67
f010730d:	68 9a a5 10 f0       	push   $0xf010a59a
f0107312:	e8 32 8d ff ff       	call   f0100049 <_panic>

f0107317 <read_eeprom>:
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_buffer[N_TXDESC][TX_PKT_SIZE];
uint64_t mac_address = 0;

uint16_t read_eeprom(uint32_t addr)
{
f0107317:	55                   	push   %ebp
f0107318:	89 e5                	mov    %esp,%ebp
    base->EERD = E1000_EEPROM_RD_START | addr;
f010731a:	8b 15 68 dd 5d f0    	mov    0xf05ddd68,%edx
f0107320:	8b 45 08             	mov    0x8(%ebp),%eax
f0107323:	83 c8 01             	or     $0x1,%eax
f0107326:	89 42 14             	mov    %eax,0x14(%edx)
	while ((base->EERD & E1000_EEPROM_RD_START) == 1); // Continually poll until we have a response
f0107329:	8b 42 14             	mov    0x14(%edx),%eax
f010732c:	a8 01                	test   $0x1,%al
f010732e:	75 f9                	jne    f0107329 <read_eeprom+0x12>
	return base->EERD >> 16;
f0107330:	8b 42 14             	mov    0x14(%edx),%eax
f0107333:	c1 e8 10             	shr    $0x10,%eax
}
f0107336:	5d                   	pop    %ebp
f0107337:	c3                   	ret    

f0107338 <read_eeprom_mac_addr>:

uint64_t read_eeprom_mac_addr(){
f0107338:	55                   	push   %ebp
f0107339:	89 e5                	mov    %esp,%ebp
f010733b:	57                   	push   %edi
f010733c:	56                   	push   %esi
f010733d:	53                   	push   %ebx
f010733e:	83 ec 0c             	sub    $0xc,%esp
	if (mac_address > 0)
f0107341:	a1 60 dd 5d f0       	mov    0xf05ddd60,%eax
f0107346:	8b 15 64 dd 5d f0    	mov    0xf05ddd64,%edx
f010734c:	89 d7                	mov    %edx,%edi
f010734e:	09 c7                	or     %eax,%edi
f0107350:	74 08                	je     f010735a <read_eeprom_mac_addr+0x22>
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
    uint64_t word2 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD2);
    uint64_t word3 = (uint64_t)0x8000;
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
    return mac_address;
}
f0107352:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107355:	5b                   	pop    %ebx
f0107356:	5e                   	pop    %esi
f0107357:	5f                   	pop    %edi
f0107358:	5d                   	pop    %ebp
f0107359:	c3                   	ret    
    uint64_t word0 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD0);
f010735a:	83 ec 0c             	sub    $0xc,%esp
f010735d:	6a 00                	push   $0x0
f010735f:	e8 b3 ff ff ff       	call   f0107317 <read_eeprom>
f0107364:	89 c3                	mov    %eax,%ebx
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
f0107366:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
f010736d:	e8 a5 ff ff ff       	call   f0107317 <read_eeprom>
f0107372:	89 c6                	mov    %eax,%esi
    uint64_t word2 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD2);
f0107374:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
f010737b:	e8 97 ff ff ff       	call   f0107317 <read_eeprom>
f0107380:	0f b7 d0             	movzwl %ax,%edx
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
f0107383:	0f b7 f6             	movzwl %si,%esi
f0107386:	bf 00 00 00 00       	mov    $0x0,%edi
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
f010738b:	0f a4 f7 10          	shld   $0x10,%esi,%edi
f010738f:	c1 e6 10             	shl    $0x10,%esi
f0107392:	09 fa                	or     %edi,%edx
    uint64_t word0 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD0);
f0107394:	0f b7 db             	movzwl %bx,%ebx
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
f0107397:	09 f3                	or     %esi,%ebx
f0107399:	89 d8                	mov    %ebx,%eax
f010739b:	81 ca 00 00 00 80    	or     $0x80000000,%edx
f01073a1:	89 1d 60 dd 5d f0    	mov    %ebx,0xf05ddd60
f01073a7:	89 15 64 dd 5d f0    	mov    %edx,0xf05ddd64
    return mac_address;
f01073ad:	83 c4 10             	add    $0x10,%esp
f01073b0:	eb a0                	jmp    f0107352 <read_eeprom_mac_addr+0x1a>

f01073b2 <e1000_tx_init>:

int
e1000_tx_init()
{
f01073b2:	55                   	push   %ebp
f01073b3:	89 e5                	mov    %esp,%ebp
f01073b5:	57                   	push   %edi
f01073b6:	56                   	push   %esi
f01073b7:	53                   	push   %ebx
f01073b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01073bb:	6a 01                	push   $0x1
f01073bd:	e8 7b 9f ff ff       	call   f010133d <page_alloc>
	return (pp - pages) << PGSHIFT;
f01073c2:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01073c8:	c1 f8 03             	sar    $0x3,%eax
f01073cb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01073ce:	89 c2                	mov    %eax,%edx
f01073d0:	c1 ea 0c             	shr    $0xc,%edx
f01073d3:	83 c4 10             	add    $0x10,%esp
f01073d6:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f01073dc:	0f 83 e5 00 00 00    	jae    f01074c7 <e1000_tx_init+0x115>
	return (void *)(pa + KERNBASE);
f01073e2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01073e7:	a3 a0 ed 5d f0       	mov    %eax,0xf05deda0
f01073ec:	ba c0 ed 65 f0       	mov    $0xf065edc0,%edx
f01073f1:	b8 c0 ed 65 00       	mov    $0x65edc0,%eax
f01073f6:	89 c6                	mov    %eax,%esi
f01073f8:	bf 00 00 00 00       	mov    $0x0,%edi
	tx_descs = (struct tx_desc *)page2kva(page);
f01073fd:	b9 00 00 00 00       	mov    $0x0,%ecx
	if ((uint32_t)kva < KERNBASE)
f0107402:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0107408:	0f 86 cb 00 00 00    	jbe    f01074d9 <e1000_tx_init+0x127>
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(tx_buffer[i]);
f010740e:	a1 a0 ed 5d f0       	mov    0xf05deda0,%eax
f0107413:	89 34 08             	mov    %esi,(%eax,%ecx,1)
f0107416:	89 7c 08 04          	mov    %edi,0x4(%eax,%ecx,1)
		tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f010741a:	8b 1d a0 ed 5d f0    	mov    0xf05deda0,%ebx
f0107420:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
f0107423:	80 48 0b 05          	orb    $0x5,0xb(%eax)
		tx_descs[i].status |= E1000_TX_STATUS_DD;
f0107427:	80 48 0c 01          	orb    $0x1,0xc(%eax)
		tx_descs[i].length = 0;
f010742b:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		tx_descs[i].cso = 0;
f0107431:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
		tx_descs[i].css = 0;
f0107435:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
		tx_descs[i].special = 0;
f0107439:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
f010743f:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f0107445:	83 c1 10             	add    $0x10,%ecx
f0107448:	81 c6 ee 05 00 00    	add    $0x5ee,%esi
f010744e:	83 d7 00             	adc    $0x0,%edi
	for(int i = 0; i < N_TXDESC; i++){
f0107451:	81 fa c0 db 6b f0    	cmp    $0xf06bdbc0,%edx
f0107457:	75 a9                	jne    f0107402 <e1000_tx_init+0x50>
	}
	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->TDBAL = (uint32_t)PADDR(tx_descs);
f0107459:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f010745e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0107464:	0f 86 81 00 00 00    	jbe    f01074eb <e1000_tx_init+0x139>
	return (physaddr_t)kva - KERNBASE;
f010746a:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f0107470:	89 98 00 38 00 00    	mov    %ebx,0x3800(%eax)
	base->TDBAH = (uint32_t)0;
f0107476:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f010747d:	00 00 00 
	// base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc);
f0107480:	c7 80 08 38 00 00 00 	movl   $0x1000,0x3808(%eax)
f0107487:	10 00 00 

	base->TDH = 0;
f010748a:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f0107491:	00 00 00 
	base->TDT = 0;
f0107494:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f010749b:	00 00 00 

	base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
f010749e:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f01074a4:	81 ca 0a 01 04 00    	or     $0x4010a,%edx
f01074aa:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	base->TIPG = E1000_TIPG_DEFAULT;
f01074b0:	c7 80 10 04 00 00 0a 	movl   $0x60100a,0x410(%eax)
f01074b7:	10 60 00 
	return 0;
}
f01074ba:	b8 00 00 00 00       	mov    $0x0,%eax
f01074bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01074c2:	5b                   	pop    %ebx
f01074c3:	5e                   	pop    %esi
f01074c4:	5f                   	pop    %edi
f01074c5:	5d                   	pop    %ebp
f01074c6:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01074c7:	50                   	push   %eax
f01074c8:	68 74 80 10 f0       	push   $0xf0108074
f01074cd:	6a 58                	push   $0x58
f01074cf:	68 71 92 10 f0       	push   $0xf0109271
f01074d4:	e8 70 8b ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01074d9:	52                   	push   %edx
f01074da:	68 98 80 10 f0       	push   $0xf0108098
f01074df:	6a 29                	push   $0x29
f01074e1:	68 e1 a5 10 f0       	push   $0xf010a5e1
f01074e6:	e8 5e 8b ff ff       	call   f0100049 <_panic>
f01074eb:	53                   	push   %ebx
f01074ec:	68 98 80 10 f0       	push   $0xf0108098
f01074f1:	6a 34                	push   $0x34
f01074f3:	68 e1 a5 10 f0       	push   $0xf010a5e1
f01074f8:	e8 4c 8b ff ff       	call   f0100049 <_panic>

f01074fd <e1000_rx_init>:
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_buffer[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx_init()
{
f01074fd:	55                   	push   %ebp
f01074fe:	89 e5                	mov    %esp,%ebp
f0107500:	57                   	push   %edi
f0107501:	56                   	push   %esi
f0107502:	53                   	push   %ebx
f0107503:	83 ec 18             	sub    $0x18,%esp
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0107506:	6a 01                	push   $0x1
f0107508:	e8 30 9e ff ff       	call   f010133d <page_alloc>
	if(page == NULL)
f010750d:	83 c4 10             	add    $0x10,%esp
f0107510:	85 c0                	test   %eax,%eax
f0107512:	0f 84 e9 00 00 00    	je     f0107601 <e1000_rx_init+0x104>
	return (pp - pages) << PGSHIFT;
f0107518:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010751e:	c1 f8 03             	sar    $0x3,%eax
f0107521:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0107524:	89 c2                	mov    %eax,%edx
f0107526:	c1 ea 0c             	shr    $0xc,%edx
f0107529:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f010752f:	0f 83 e0 00 00 00    	jae    f0107615 <e1000_rx_init+0x118>
	return (void *)(pa + KERNBASE);
f0107535:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010753a:	a3 a4 ed 5d f0       	mov    %eax,0xf05deda4
f010753f:	b8 c0 ed 5d f0       	mov    $0xf05dedc0,%eax
f0107544:	b9 c0 ed 5d 00       	mov    $0x5dedc0,%ecx
f0107549:	bb 00 00 00 00       	mov    $0x0,%ebx
f010754e:	be c0 ed 65 f0       	mov    $0xf065edc0,%esi
			panic("page_alloc panic\n");
	rx_descs = (struct rx_desc *)page2kva(page);
f0107553:	ba 00 00 00 00       	mov    $0x0,%edx
	if ((uint32_t)kva < KERNBASE)
f0107558:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010755d:	0f 86 c4 00 00 00    	jbe    f0107627 <e1000_rx_init+0x12a>
	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for(int i = 0; i < N_RXDESC; i++){
		rx_descs[i].addr = PADDR(rx_buffer[i]);
f0107563:	8b 3d a4 ed 5d f0    	mov    0xf05deda4,%edi
f0107569:	89 0c 17             	mov    %ecx,(%edi,%edx,1)
f010756c:	89 5c 17 04          	mov    %ebx,0x4(%edi,%edx,1)
f0107570:	05 00 08 00 00       	add    $0x800,%eax
f0107575:	83 c2 10             	add    $0x10,%edx
f0107578:	81 c1 00 08 00 00    	add    $0x800,%ecx
f010757e:	83 d3 00             	adc    $0x0,%ebx
	for(int i = 0; i < N_RXDESC; i++){
f0107581:	39 f0                	cmp    %esi,%eax
f0107583:	75 d3                	jne    f0107558 <e1000_rx_init+0x5b>
	}

	uint64_t macaddr_local = read_eeprom_mac_addr();
f0107585:	e8 ae fd ff ff       	call   f0107338 <read_eeprom_mac_addr>

	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->RCTL |= E1000_RCTL_EN|E1000_RCTL_BSIZE_2048|E1000_RCTL_SECRC;
f010758a:	8b 0d 68 dd 5d f0    	mov    0xf05ddd68,%ecx
f0107590:	8b 99 00 01 00 00    	mov    0x100(%ecx),%ebx
f0107596:	81 cb 02 00 00 04    	or     $0x4000002,%ebx
f010759c:	89 99 00 01 00 00    	mov    %ebx,0x100(%ecx)
	base->RDBAL = PADDR(rx_descs);
f01075a2:	8b 1d a4 ed 5d f0    	mov    0xf05deda4,%ebx
f01075a8:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01075ae:	0f 86 85 00 00 00    	jbe    f0107639 <e1000_rx_init+0x13c>
	return (physaddr_t)kva - KERNBASE;
f01075b4:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f01075ba:	89 99 00 28 00 00    	mov    %ebx,0x2800(%ecx)
	base->RDBAH = (uint32_t)0;
f01075c0:	c7 81 04 28 00 00 00 	movl   $0x0,0x2804(%ecx)
f01075c7:	00 00 00 
	base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
f01075ca:	c7 81 08 28 00 00 00 	movl   $0x1000,0x2808(%ecx)
f01075d1:	10 00 00 
	base->RDH = 0;
f01075d4:	c7 81 10 28 00 00 00 	movl   $0x0,0x2810(%ecx)
f01075db:	00 00 00 
	base->RDT = N_RXDESC-1;
f01075de:	c7 81 18 28 00 00 ff 	movl   $0xff,0x2818(%ecx)
f01075e5:	00 00 00 
	// base->RAL = QEMU_MAC_LOW;
	// base->RAH = QEMU_MAC_HIGH;

	base->RAL = (uint32_t)(macaddr_local & 0xffffffff);
f01075e8:	89 81 1c 3a 00 00    	mov    %eax,0x3a1c(%ecx)
	base->RAH = (uint32_t)(macaddr_local>>32);
f01075ee:	89 91 20 3a 00 00    	mov    %edx,0x3a20(%ecx)

	return 0;
}
f01075f4:	b8 00 00 00 00       	mov    $0x0,%eax
f01075f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01075fc:	5b                   	pop    %ebx
f01075fd:	5e                   	pop    %esi
f01075fe:	5f                   	pop    %edi
f01075ff:	5d                   	pop    %ebp
f0107600:	c3                   	ret    
			panic("page_alloc panic\n");
f0107601:	83 ec 04             	sub    $0x4,%esp
f0107604:	68 ee a5 10 f0       	push   $0xf010a5ee
f0107609:	6a 4c                	push   $0x4c
f010760b:	68 e1 a5 10 f0       	push   $0xf010a5e1
f0107610:	e8 34 8a ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107615:	50                   	push   %eax
f0107616:	68 74 80 10 f0       	push   $0xf0108074
f010761b:	6a 58                	push   $0x58
f010761d:	68 71 92 10 f0       	push   $0xf0109271
f0107622:	e8 22 8a ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107627:	50                   	push   %eax
f0107628:	68 98 80 10 f0       	push   $0xf0108098
f010762d:	6a 51                	push   $0x51
f010762f:	68 e1 a5 10 f0       	push   $0xf010a5e1
f0107634:	e8 10 8a ff ff       	call   f0100049 <_panic>
f0107639:	53                   	push   %ebx
f010763a:	68 98 80 10 f0       	push   $0xf0108098
f010763f:	6a 5a                	push   $0x5a
f0107641:	68 e1 a5 10 f0       	push   $0xf010a5e1
f0107646:	e8 fe 89 ff ff       	call   f0100049 <_panic>

f010764b <pci_e1000_attach>:

int
pci_e1000_attach(struct pci_func *pcif)
{
f010764b:	55                   	push   %ebp
f010764c:	89 e5                	mov    %esp,%ebp
f010764e:	53                   	push   %ebx
f010764f:	83 ec 0c             	sub    $0xc,%esp
f0107652:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0107655:	68 20 a6 10 f0       	push   $0xf010a620
f010765a:	68 bc 80 10 f0       	push   $0xf01080bc
f010765f:	e8 92 cb ff ff       	call   f01041f6 <cprintf>
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
f0107664:	89 1c 24             	mov    %ebx,(%esp)
f0107667:	e8 a8 05 00 00       	call   f0107c14 <pci_func_enable>
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f010766c:	83 c4 08             	add    $0x8,%esp
f010766f:	ff 73 2c             	pushl  0x2c(%ebx)
f0107672:	ff 73 14             	pushl  0x14(%ebx)
f0107675:	e8 e1 a0 ff ff       	call   f010175b <mmio_map_region>
f010767a:	a3 68 dd 5d f0       	mov    %eax,0xf05ddd68
	e1000_tx_init();
f010767f:	e8 2e fd ff ff       	call   f01073b2 <e1000_tx_init>
	e1000_rx_init();
f0107684:	e8 74 fe ff ff       	call   f01074fd <e1000_rx_init>

	return 0;
}
f0107689:	b8 00 00 00 00       	mov    $0x0,%eax
f010768e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107691:	c9                   	leave  
f0107692:	c3                   	ret    

f0107693 <e1000_tx>:

int
e1000_tx(const void *buf, uint32_t len)
{
f0107693:	55                   	push   %ebp
f0107694:	89 e5                	mov    %esp,%ebp
f0107696:	53                   	push   %ebx
f0107697:	83 ec 0c             	sub    $0xc,%esp
f010769a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address
	cprintf("in %s\n", __FUNCTION__);
f010769d:	68 14 a6 10 f0       	push   $0xf010a614
f01076a2:	68 bc 80 10 f0       	push   $0xf01080bc
f01076a7:	e8 4a cb ff ff       	call   f01041f6 <cprintf>
	if(tx_descs[base->TDT].status & E1000_TX_STATUS_DD){
f01076ac:	a1 a0 ed 5d f0       	mov    0xf05deda0,%eax
f01076b1:	8b 0d 68 dd 5d f0    	mov    0xf05ddd68,%ecx
f01076b7:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01076bd:	c1 e2 04             	shl    $0x4,%edx
f01076c0:	83 c4 10             	add    $0x10,%esp
f01076c3:	f6 44 10 0c 01       	testb  $0x1,0xc(%eax,%edx,1)
f01076c8:	0f 84 e6 00 00 00    	je     f01077b4 <e1000_tx+0x121>
		tx_descs[base->TDT].status ^= E1000_TX_STATUS_DD;
f01076ce:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01076d4:	c1 e2 04             	shl    $0x4,%edx
f01076d7:	80 74 10 0c 01       	xorb   $0x1,0xc(%eax,%edx,1)
		memset(KADDR(tx_descs[base->TDT].addr), 0 , TX_PKT_SIZE);
f01076dc:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01076e2:	c1 e2 04             	shl    $0x4,%edx
f01076e5:	8b 04 10             	mov    (%eax,%edx,1),%eax
	if (PGNUM(pa) >= npages)
f01076e8:	89 c2                	mov    %eax,%edx
f01076ea:	c1 ea 0c             	shr    $0xc,%edx
f01076ed:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f01076f3:	0f 83 94 00 00 00    	jae    f010778d <e1000_tx+0xfa>
f01076f9:	83 ec 04             	sub    $0x4,%esp
f01076fc:	68 ee 05 00 00       	push   $0x5ee
f0107701:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0107703:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107708:	50                   	push   %eax
f0107709:	e8 f6 f1 ff ff       	call   f0106904 <memset>
		memcpy(KADDR(tx_descs[base->TDT].addr), buf, len);
f010770e:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f0107713:	8b 80 18 38 00 00    	mov    0x3818(%eax),%eax
f0107719:	c1 e0 04             	shl    $0x4,%eax
f010771c:	03 05 a0 ed 5d f0    	add    0xf05deda0,%eax
f0107722:	8b 00                	mov    (%eax),%eax
	if (PGNUM(pa) >= npages)
f0107724:	89 c2                	mov    %eax,%edx
f0107726:	c1 ea 0c             	shr    $0xc,%edx
f0107729:	83 c4 10             	add    $0x10,%esp
f010772c:	39 15 88 ed 5d f0    	cmp    %edx,0xf05ded88
f0107732:	76 6b                	jbe    f010779f <e1000_tx+0x10c>
f0107734:	83 ec 04             	sub    $0x4,%esp
f0107737:	53                   	push   %ebx
f0107738:	ff 75 08             	pushl  0x8(%ebp)
	return (void *)(pa + KERNBASE);
f010773b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107740:	50                   	push   %eax
f0107741:	e8 68 f2 ff ff       	call   f01069ae <memcpy>
		tx_descs[base->TDT].length = len;
f0107746:	8b 0d a0 ed 5d f0    	mov    0xf05deda0,%ecx
f010774c:	8b 15 68 dd 5d f0    	mov    0xf05ddd68,%edx
f0107752:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f0107758:	c1 e0 04             	shl    $0x4,%eax
f010775b:	66 89 5c 01 08       	mov    %bx,0x8(%ecx,%eax,1)
		tx_descs[base->TDT].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0107760:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f0107766:	c1 e0 04             	shl    $0x4,%eax
f0107769:	80 4c 01 0b 05       	orb    $0x5,0xb(%ecx,%eax,1)

		base->TDT = (base->TDT + 1)%N_TXDESC;
f010776e:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f0107774:	83 c0 01             	add    $0x1,%eax
f0107777:	0f b6 c0             	movzbl %al,%eax
f010777a:	89 82 18 38 00 00    	mov    %eax,0x3818(%edx)
	}
	else{
		return -E_TX_FULL;
	}
	return 0;
f0107780:	83 c4 10             	add    $0x10,%esp
f0107783:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0107788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010778b:	c9                   	leave  
f010778c:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010778d:	50                   	push   %eax
f010778e:	68 74 80 10 f0       	push   $0xf0108074
f0107793:	6a 7f                	push   $0x7f
f0107795:	68 e1 a5 10 f0       	push   $0xf010a5e1
f010779a:	e8 aa 88 ff ff       	call   f0100049 <_panic>
f010779f:	50                   	push   %eax
f01077a0:	68 74 80 10 f0       	push   $0xf0108074
f01077a5:	68 80 00 00 00       	push   $0x80
f01077aa:	68 e1 a5 10 f0       	push   $0xf010a5e1
f01077af:	e8 95 88 ff ff       	call   f0100049 <_panic>
		return -E_TX_FULL;
f01077b4:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
f01077b9:	eb cd                	jmp    f0107788 <e1000_tx+0xf5>

f01077bb <e1000_rx>:

// char rx_bufs[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx(void *buf, uint32_t len)
{
f01077bb:	55                   	push   %ebp
f01077bc:	89 e5                	mov    %esp,%ebp
f01077be:	57                   	push   %edi
f01077bf:	56                   	push   %esi
f01077c0:	53                   	push   %ebx
f01077c1:	83 ec 0c             	sub    $0xc,%esp
	// 	assert(len > rx_descs[base->RDH].length);
	// 	memcpy(buf, KADDR(rx_descs[base->RDH].addr), len);
	// 	memset(KADDR(rx_descs[base->RDH].addr), 0, PKT_SIZE);
	// 	base->RDT = base->RDH;
	// }
	uint32_t rdt = (base->RDT + 1) % N_RXDESC;
f01077c4:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f01077c9:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
f01077cf:	83 c3 01             	add    $0x1,%ebx
f01077d2:	0f b6 db             	movzbl %bl,%ebx
  	if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD)){
f01077d5:	89 de                	mov    %ebx,%esi
f01077d7:	c1 e6 04             	shl    $0x4,%esi
f01077da:	89 f0                	mov    %esi,%eax
f01077dc:	03 05 a4 ed 5d f0    	add    0xf05deda4,%eax
f01077e2:	f6 40 0c 01          	testb  $0x1,0xc(%eax)
f01077e6:	74 5a                	je     f0107842 <e1000_rx+0x87>
		return -E_AGAIN;
	}

	if(rx_descs[rdt].error) {
f01077e8:	80 78 0d 00          	cmpb   $0x0,0xd(%eax)
f01077ec:	75 3d                	jne    f010782b <e1000_rx+0x70>
		cprintf("[rx]error occours\n");
		return -E_UNSPECIFIED;
	}
	len = rx_descs[rdt].length;
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f01077ee:	83 ec 04             	sub    $0x4,%esp
	len = rx_descs[rdt].length;
f01077f1:	0f b7 78 08          	movzwl 0x8(%eax),%edi
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f01077f5:	57                   	push   %edi
f01077f6:	89 d8                	mov    %ebx,%eax
f01077f8:	c1 e0 0b             	shl    $0xb,%eax
f01077fb:	05 c0 ed 5d f0       	add    $0xf05dedc0,%eax
f0107800:	50                   	push   %eax
f0107801:	ff 75 08             	pushl  0x8(%ebp)
f0107804:	e8 a5 f1 ff ff       	call   f01069ae <memcpy>
  	rx_descs[rdt].status ^= E1000_RX_STATUS_DD;//lab6 bug?
f0107809:	03 35 a4 ed 5d f0    	add    0xf05deda4,%esi
f010780f:	80 76 0c 01          	xorb   $0x1,0xc(%esi)

  	base->RDT = rdt;
f0107813:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f0107818:	89 98 18 28 00 00    	mov    %ebx,0x2818(%eax)
	return len;
f010781e:	89 f8                	mov    %edi,%eax
f0107820:	83 c4 10             	add    $0x10,%esp
}
f0107823:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107826:	5b                   	pop    %ebx
f0107827:	5e                   	pop    %esi
f0107828:	5f                   	pop    %edi
f0107829:	5d                   	pop    %ebp
f010782a:	c3                   	ret    
		cprintf("[rx]error occours\n");
f010782b:	83 ec 0c             	sub    $0xc,%esp
f010782e:	68 00 a6 10 f0       	push   $0xf010a600
f0107833:	e8 be c9 ff ff       	call   f01041f6 <cprintf>
		return -E_UNSPECIFIED;
f0107838:	83 c4 10             	add    $0x10,%esp
f010783b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0107840:	eb e1                	jmp    f0107823 <e1000_rx+0x68>
		return -E_AGAIN;
f0107842:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f0107847:	eb da                	jmp    f0107823 <e1000_rx+0x68>

f0107849 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0107849:	55                   	push   %ebp
f010784a:	89 e5                	mov    %esp,%ebp
f010784c:	57                   	push   %edi
f010784d:	56                   	push   %esi
f010784e:	53                   	push   %ebx
f010784f:	83 ec 0c             	sub    $0xc,%esp
f0107852:	8b 7d 08             	mov    0x8(%ebp),%edi
f0107855:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107858:	eb 03                	jmp    f010785d <pci_attach_match+0x14>
f010785a:	83 c3 0c             	add    $0xc,%ebx
f010785d:	89 de                	mov    %ebx,%esi
f010785f:	8b 43 08             	mov    0x8(%ebx),%eax
f0107862:	85 c0                	test   %eax,%eax
f0107864:	74 37                	je     f010789d <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0107866:	39 3b                	cmp    %edi,(%ebx)
f0107868:	75 f0                	jne    f010785a <pci_attach_match+0x11>
f010786a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010786d:	39 56 04             	cmp    %edx,0x4(%esi)
f0107870:	75 e8                	jne    f010785a <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f0107872:	83 ec 0c             	sub    $0xc,%esp
f0107875:	ff 75 14             	pushl  0x14(%ebp)
f0107878:	ff d0                	call   *%eax
			if (r > 0)
f010787a:	83 c4 10             	add    $0x10,%esp
f010787d:	85 c0                	test   %eax,%eax
f010787f:	7f 1c                	jg     f010789d <pci_attach_match+0x54>
				return r;
			if (r < 0)
f0107881:	79 d7                	jns    f010785a <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f0107883:	83 ec 0c             	sub    $0xc,%esp
f0107886:	50                   	push   %eax
f0107887:	ff 76 08             	pushl  0x8(%esi)
f010788a:	ff 75 0c             	pushl  0xc(%ebp)
f010788d:	57                   	push   %edi
f010788e:	68 34 a6 10 f0       	push   $0xf010a634
f0107893:	e8 5e c9 ff ff       	call   f01041f6 <cprintf>
f0107898:	83 c4 20             	add    $0x20,%esp
f010789b:	eb bd                	jmp    f010785a <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f010789d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01078a0:	5b                   	pop    %ebx
f01078a1:	5e                   	pop    %esi
f01078a2:	5f                   	pop    %edi
f01078a3:	5d                   	pop    %ebp
f01078a4:	c3                   	ret    

f01078a5 <pci_conf1_set_addr>:
{
f01078a5:	55                   	push   %ebp
f01078a6:	89 e5                	mov    %esp,%ebp
f01078a8:	53                   	push   %ebx
f01078a9:	83 ec 04             	sub    $0x4,%esp
f01078ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01078af:	3d ff 00 00 00       	cmp    $0xff,%eax
f01078b4:	77 36                	ja     f01078ec <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f01078b6:	83 fa 1f             	cmp    $0x1f,%edx
f01078b9:	77 47                	ja     f0107902 <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f01078bb:	83 f9 07             	cmp    $0x7,%ecx
f01078be:	77 58                	ja     f0107918 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f01078c0:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01078c6:	77 66                	ja     f010792e <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f01078c8:	f6 c3 03             	test   $0x3,%bl
f01078cb:	75 77                	jne    f0107944 <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f01078cd:	c1 e0 10             	shl    $0x10,%eax
f01078d0:	09 d8                	or     %ebx,%eax
f01078d2:	c1 e1 08             	shl    $0x8,%ecx
f01078d5:	09 c8                	or     %ecx,%eax
f01078d7:	c1 e2 0b             	shl    $0xb,%edx
f01078da:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f01078dc:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01078e1:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f01078e6:	ef                   	out    %eax,(%dx)
}
f01078e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01078ea:	c9                   	leave  
f01078eb:	c3                   	ret    
	assert(bus < 256);
f01078ec:	68 8c a7 10 f0       	push   $0xf010a78c
f01078f1:	68 8b 92 10 f0       	push   $0xf010928b
f01078f6:	6a 2c                	push   $0x2c
f01078f8:	68 96 a7 10 f0       	push   $0xf010a796
f01078fd:	e8 47 87 ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f0107902:	68 a1 a7 10 f0       	push   $0xf010a7a1
f0107907:	68 8b 92 10 f0       	push   $0xf010928b
f010790c:	6a 2d                	push   $0x2d
f010790e:	68 96 a7 10 f0       	push   $0xf010a796
f0107913:	e8 31 87 ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f0107918:	68 aa a7 10 f0       	push   $0xf010a7aa
f010791d:	68 8b 92 10 f0       	push   $0xf010928b
f0107922:	6a 2e                	push   $0x2e
f0107924:	68 96 a7 10 f0       	push   $0xf010a796
f0107929:	e8 1b 87 ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f010792e:	68 b3 a7 10 f0       	push   $0xf010a7b3
f0107933:	68 8b 92 10 f0       	push   $0xf010928b
f0107938:	6a 2f                	push   $0x2f
f010793a:	68 96 a7 10 f0       	push   $0xf010a796
f010793f:	e8 05 87 ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f0107944:	68 c0 a7 10 f0       	push   $0xf010a7c0
f0107949:	68 8b 92 10 f0       	push   $0xf010928b
f010794e:	6a 30                	push   $0x30
f0107950:	68 96 a7 10 f0       	push   $0xf010a796
f0107955:	e8 ef 86 ff ff       	call   f0100049 <_panic>

f010795a <pci_conf_read>:
{
f010795a:	55                   	push   %ebp
f010795b:	89 e5                	mov    %esp,%ebp
f010795d:	53                   	push   %ebx
f010795e:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107961:	8b 48 08             	mov    0x8(%eax),%ecx
f0107964:	8b 58 04             	mov    0x4(%eax),%ebx
f0107967:	8b 00                	mov    (%eax),%eax
f0107969:	8b 40 04             	mov    0x4(%eax),%eax
f010796c:	52                   	push   %edx
f010796d:	89 da                	mov    %ebx,%edx
f010796f:	e8 31 ff ff ff       	call   f01078a5 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0107974:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107979:	ed                   	in     (%dx),%eax
}
f010797a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010797d:	c9                   	leave  
f010797e:	c3                   	ret    

f010797f <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f010797f:	55                   	push   %ebp
f0107980:	89 e5                	mov    %esp,%ebp
f0107982:	57                   	push   %edi
f0107983:	56                   	push   %esi
f0107984:	53                   	push   %ebx
f0107985:	81 ec 00 01 00 00    	sub    $0x100,%esp
f010798b:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f010798d:	6a 48                	push   $0x48
f010798f:	6a 00                	push   $0x0
f0107991:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107994:	50                   	push   %eax
f0107995:	e8 6a ef ff ff       	call   f0106904 <memset>
	df.bus = bus;
f010799a:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f010799d:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01079a4:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f01079a7:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f01079ae:	00 00 00 
f01079b1:	e9 25 01 00 00       	jmp    f0107adb <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01079b6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01079bc:	83 ec 08             	sub    $0x8,%esp
f01079bf:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f01079c3:	57                   	push   %edi
f01079c4:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f01079c5:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01079c8:	0f b6 c0             	movzbl %al,%eax
f01079cb:	50                   	push   %eax
f01079cc:	51                   	push   %ecx
f01079cd:	89 d0                	mov    %edx,%eax
f01079cf:	c1 e8 10             	shr    $0x10,%eax
f01079d2:	50                   	push   %eax
f01079d3:	0f b7 d2             	movzwl %dx,%edx
f01079d6:	52                   	push   %edx
f01079d7:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f01079dd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f01079e3:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f01079e9:	ff 70 04             	pushl  0x4(%eax)
f01079ec:	68 60 a6 10 f0       	push   $0xf010a660
f01079f1:	e8 00 c8 ff ff       	call   f01041f6 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f01079f6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f01079fc:	83 c4 30             	add    $0x30,%esp
f01079ff:	53                   	push   %ebx
f0107a00:	68 6c d3 16 f0       	push   $0xf016d36c
				 PCI_SUBCLASS(f->dev_class),
f0107a05:	89 c2                	mov    %eax,%edx
f0107a07:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107a0a:	0f b6 d2             	movzbl %dl,%edx
f0107a0d:	52                   	push   %edx
f0107a0e:	c1 e8 18             	shr    $0x18,%eax
f0107a11:	50                   	push   %eax
f0107a12:	e8 32 fe ff ff       	call   f0107849 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0107a17:	83 c4 10             	add    $0x10,%esp
f0107a1a:	85 c0                	test   %eax,%eax
f0107a1c:	0f 84 88 00 00 00    	je     f0107aaa <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107a22:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107a29:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0107a2f:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f0107a35:	0f 83 92 00 00 00    	jae    f0107acd <pci_scan_bus+0x14e>
			struct pci_func af = f;
f0107a3b:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f0107a41:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107a47:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107a4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0107a4e:	ba 00 00 00 00       	mov    $0x0,%edx
f0107a53:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107a59:	e8 fc fe ff ff       	call   f010795a <pci_conf_read>
f0107a5e:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107a64:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107a68:	74 b8                	je     f0107a22 <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107a6a:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107a6f:	89 d8                	mov    %ebx,%eax
f0107a71:	e8 e4 fe ff ff       	call   f010795a <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107a76:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107a79:	ba 08 00 00 00       	mov    $0x8,%edx
f0107a7e:	89 d8                	mov    %ebx,%eax
f0107a80:	e8 d5 fe ff ff       	call   f010795a <pci_conf_read>
f0107a85:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107a8b:	89 c1                	mov    %eax,%ecx
f0107a8d:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0107a90:	be d4 a7 10 f0       	mov    $0xf010a7d4,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107a95:	83 f9 06             	cmp    $0x6,%ecx
f0107a98:	0f 87 18 ff ff ff    	ja     f01079b6 <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107a9e:	8b 34 8d 48 a8 10 f0 	mov    -0xfef57b8(,%ecx,4),%esi
f0107aa5:	e9 0c ff ff ff       	jmp    f01079b6 <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0107aaa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107ab0:	53                   	push   %ebx
f0107ab1:	68 54 d3 16 f0       	push   $0xf016d354
f0107ab6:	89 c2                	mov    %eax,%edx
f0107ab8:	c1 ea 10             	shr    $0x10,%edx
f0107abb:	52                   	push   %edx
f0107abc:	0f b7 c0             	movzwl %ax,%eax
f0107abf:	50                   	push   %eax
f0107ac0:	e8 84 fd ff ff       	call   f0107849 <pci_attach_match>
f0107ac5:	83 c4 10             	add    $0x10,%esp
f0107ac8:	e9 55 ff ff ff       	jmp    f0107a22 <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107acd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107ad0:	83 c0 01             	add    $0x1,%eax
f0107ad3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107ad6:	83 f8 1f             	cmp    $0x1f,%eax
f0107ad9:	77 59                	ja     f0107b34 <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107adb:	ba 0c 00 00 00       	mov    $0xc,%edx
f0107ae0:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107ae3:	e8 72 fe ff ff       	call   f010795a <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107ae8:	89 c2                	mov    %eax,%edx
f0107aea:	c1 ea 10             	shr    $0x10,%edx
f0107aed:	f6 c2 7e             	test   $0x7e,%dl
f0107af0:	75 db                	jne    f0107acd <pci_scan_bus+0x14e>
		totaldev++;
f0107af2:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0107af9:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107aff:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107b02:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107b07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107b09:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107b10:	00 00 00 
f0107b13:	25 00 00 80 00       	and    $0x800000,%eax
f0107b18:	83 f8 01             	cmp    $0x1,%eax
f0107b1b:	19 c0                	sbb    %eax,%eax
f0107b1d:	83 e0 f9             	and    $0xfffffff9,%eax
f0107b20:	83 c0 08             	add    $0x8,%eax
f0107b23:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107b29:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107b2f:	e9 f5 fe ff ff       	jmp    f0107a29 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107b34:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107b3d:	5b                   	pop    %ebx
f0107b3e:	5e                   	pop    %esi
f0107b3f:	5f                   	pop    %edi
f0107b40:	5d                   	pop    %ebp
f0107b41:	c3                   	ret    

f0107b42 <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0107b42:	55                   	push   %ebp
f0107b43:	89 e5                	mov    %esp,%ebp
f0107b45:	57                   	push   %edi
f0107b46:	56                   	push   %esi
f0107b47:	53                   	push   %ebx
f0107b48:	83 ec 1c             	sub    $0x1c,%esp
f0107b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0107b4e:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0107b53:	89 d8                	mov    %ebx,%eax
f0107b55:	e8 00 fe ff ff       	call   f010795a <pci_conf_read>
f0107b5a:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107b5c:	ba 18 00 00 00       	mov    $0x18,%edx
f0107b61:	89 d8                	mov    %ebx,%eax
f0107b63:	e8 f2 fd ff ff       	call   f010795a <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107b68:	83 e7 0f             	and    $0xf,%edi
f0107b6b:	83 ff 01             	cmp    $0x1,%edi
f0107b6e:	74 56                	je     f0107bc6 <pci_bridge_attach+0x84>
f0107b70:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0107b72:	83 ec 04             	sub    $0x4,%esp
f0107b75:	6a 08                	push   $0x8
f0107b77:	6a 00                	push   $0x0
f0107b79:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107b7c:	57                   	push   %edi
f0107b7d:	e8 82 ed ff ff       	call   f0106904 <memset>
	nbus.parent_bridge = pcif;
f0107b82:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0107b85:	89 f0                	mov    %esi,%eax
f0107b87:	0f b6 c4             	movzbl %ah,%eax
f0107b8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107b8d:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0107b90:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107b93:	89 f1                	mov    %esi,%ecx
f0107b95:	0f b6 f1             	movzbl %cl,%esi
f0107b98:	56                   	push   %esi
f0107b99:	50                   	push   %eax
f0107b9a:	ff 73 08             	pushl  0x8(%ebx)
f0107b9d:	ff 73 04             	pushl  0x4(%ebx)
f0107ba0:	8b 03                	mov    (%ebx),%eax
f0107ba2:	ff 70 04             	pushl  0x4(%eax)
f0107ba5:	68 d0 a6 10 f0       	push   $0xf010a6d0
f0107baa:	e8 47 c6 ff ff       	call   f01041f6 <cprintf>

	pci_scan_bus(&nbus);
f0107baf:	83 c4 20             	add    $0x20,%esp
f0107bb2:	89 f8                	mov    %edi,%eax
f0107bb4:	e8 c6 fd ff ff       	call   f010797f <pci_scan_bus>
	return 1;
f0107bb9:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107bc1:	5b                   	pop    %ebx
f0107bc2:	5e                   	pop    %esi
f0107bc3:	5f                   	pop    %edi
f0107bc4:	5d                   	pop    %ebp
f0107bc5:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107bc6:	ff 73 08             	pushl  0x8(%ebx)
f0107bc9:	ff 73 04             	pushl  0x4(%ebx)
f0107bcc:	8b 03                	mov    (%ebx),%eax
f0107bce:	ff 70 04             	pushl  0x4(%eax)
f0107bd1:	68 9c a6 10 f0       	push   $0xf010a69c
f0107bd6:	e8 1b c6 ff ff       	call   f01041f6 <cprintf>
		return 0;
f0107bdb:	83 c4 10             	add    $0x10,%esp
f0107bde:	b8 00 00 00 00       	mov    $0x0,%eax
f0107be3:	eb d9                	jmp    f0107bbe <pci_bridge_attach+0x7c>

f0107be5 <pci_conf_write>:
{
f0107be5:	55                   	push   %ebp
f0107be6:	89 e5                	mov    %esp,%ebp
f0107be8:	56                   	push   %esi
f0107be9:	53                   	push   %ebx
f0107bea:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107bec:	8b 48 08             	mov    0x8(%eax),%ecx
f0107bef:	8b 70 04             	mov    0x4(%eax),%esi
f0107bf2:	8b 00                	mov    (%eax),%eax
f0107bf4:	8b 40 04             	mov    0x4(%eax),%eax
f0107bf7:	83 ec 0c             	sub    $0xc,%esp
f0107bfa:	52                   	push   %edx
f0107bfb:	89 f2                	mov    %esi,%edx
f0107bfd:	e8 a3 fc ff ff       	call   f01078a5 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107c02:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107c07:	89 d8                	mov    %ebx,%eax
f0107c09:	ef                   	out    %eax,(%dx)
}
f0107c0a:	83 c4 10             	add    $0x10,%esp
f0107c0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107c10:	5b                   	pop    %ebx
f0107c11:	5e                   	pop    %esi
f0107c12:	5d                   	pop    %ebp
f0107c13:	c3                   	ret    

f0107c14 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107c14:	55                   	push   %ebp
f0107c15:	89 e5                	mov    %esp,%ebp
f0107c17:	57                   	push   %edi
f0107c18:	56                   	push   %esi
f0107c19:	53                   	push   %ebx
f0107c1a:	83 ec 2c             	sub    $0x2c,%esp
f0107c1d:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107c20:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107c25:	ba 04 00 00 00       	mov    $0x4,%edx
f0107c2a:	89 f8                	mov    %edi,%eax
f0107c2c:	e8 b4 ff ff ff       	call   f0107be5 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107c31:	be 10 00 00 00       	mov    $0x10,%esi
f0107c36:	eb 27                	jmp    f0107c5f <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107c38:	89 c3                	mov    %eax,%ebx
f0107c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
f0107c3d:	f7 db                	neg    %ebx
f0107c3f:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107c44:	83 e0 fc             	and    $0xfffffffc,%eax
f0107c47:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f0107c4a:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f0107c51:	eb 74                	jmp    f0107cc7 <pci_func_enable+0xb3>
	     bar += bar_width)
f0107c53:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107c56:	83 fe 27             	cmp    $0x27,%esi
f0107c59:	0f 87 c5 00 00 00    	ja     f0107d24 <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f0107c5f:	89 f2                	mov    %esi,%edx
f0107c61:	89 f8                	mov    %edi,%eax
f0107c63:	e8 f2 fc ff ff       	call   f010795a <pci_conf_read>
f0107c68:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0107c6b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0107c70:	89 f2                	mov    %esi,%edx
f0107c72:	89 f8                	mov    %edi,%eax
f0107c74:	e8 6c ff ff ff       	call   f0107be5 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0107c79:	89 f2                	mov    %esi,%edx
f0107c7b:	89 f8                	mov    %edi,%eax
f0107c7d:	e8 d8 fc ff ff       	call   f010795a <pci_conf_read>
		bar_width = 4;
f0107c82:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0107c89:	85 c0                	test   %eax,%eax
f0107c8b:	74 c6                	je     f0107c53 <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0107c8d:	8d 4e f0             	lea    -0x10(%esi),%ecx
f0107c90:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0107c93:	c1 e9 02             	shr    $0x2,%ecx
f0107c96:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107c99:	a8 01                	test   $0x1,%al
f0107c9b:	75 9b                	jne    f0107c38 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107c9d:	89 c2                	mov    %eax,%edx
f0107c9f:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f0107ca2:	83 fa 04             	cmp    $0x4,%edx
f0107ca5:	0f 94 c1             	sete   %cl
f0107ca8:	0f b6 c9             	movzbl %cl,%ecx
f0107cab:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f0107cb2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f0107cb5:	89 c3                	mov    %eax,%ebx
f0107cb7:	83 e3 f0             	and    $0xfffffff0,%ebx
f0107cba:	f7 db                	neg    %ebx
f0107cbc:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107cbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107cc1:	83 e0 f0             	and    $0xfffffff0,%eax
f0107cc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107cc7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0107cca:	89 f2                	mov    %esi,%edx
f0107ccc:	89 f8                	mov    %edi,%eax
f0107cce:	e8 12 ff ff ff       	call   f0107be5 <pci_conf_write>
f0107cd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0107cd6:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0107cd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107cdb:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0107cde:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f0107ce1:	85 db                	test   %ebx,%ebx
f0107ce3:	0f 84 6a ff ff ff    	je     f0107c53 <pci_func_enable+0x3f>
f0107ce9:	85 d2                	test   %edx,%edx
f0107ceb:	0f 85 62 ff ff ff    	jne    f0107c53 <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107cf1:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0107cf4:	83 ec 0c             	sub    $0xc,%esp
f0107cf7:	53                   	push   %ebx
f0107cf8:	6a 00                	push   $0x0
f0107cfa:	ff 75 d4             	pushl  -0x2c(%ebp)
f0107cfd:	89 c2                	mov    %eax,%edx
f0107cff:	c1 ea 10             	shr    $0x10,%edx
f0107d02:	52                   	push   %edx
f0107d03:	0f b7 c0             	movzwl %ax,%eax
f0107d06:	50                   	push   %eax
f0107d07:	ff 77 08             	pushl  0x8(%edi)
f0107d0a:	ff 77 04             	pushl  0x4(%edi)
f0107d0d:	8b 07                	mov    (%edi),%eax
f0107d0f:	ff 70 04             	pushl  0x4(%eax)
f0107d12:	68 00 a7 10 f0       	push   $0xf010a700
f0107d17:	e8 da c4 ff ff       	call   f01041f6 <cprintf>
f0107d1c:	83 c4 30             	add    $0x30,%esp
f0107d1f:	e9 2f ff ff ff       	jmp    f0107c53 <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107d24:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107d27:	83 ec 08             	sub    $0x8,%esp
f0107d2a:	89 c2                	mov    %eax,%edx
f0107d2c:	c1 ea 10             	shr    $0x10,%edx
f0107d2f:	52                   	push   %edx
f0107d30:	0f b7 c0             	movzwl %ax,%eax
f0107d33:	50                   	push   %eax
f0107d34:	ff 77 08             	pushl  0x8(%edi)
f0107d37:	ff 77 04             	pushl  0x4(%edi)
f0107d3a:	8b 07                	mov    (%edi),%eax
f0107d3c:	ff 70 04             	pushl  0x4(%eax)
f0107d3f:	68 5c a7 10 f0       	push   $0xf010a75c
f0107d44:	e8 ad c4 ff ff       	call   f01041f6 <cprintf>
}
f0107d49:	83 c4 20             	add    $0x20,%esp
f0107d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107d4f:	5b                   	pop    %ebx
f0107d50:	5e                   	pop    %esi
f0107d51:	5f                   	pop    %edi
f0107d52:	5d                   	pop    %ebp
f0107d53:	c3                   	ret    

f0107d54 <pci_init>:

int
pci_init(void)
{
f0107d54:	55                   	push   %ebp
f0107d55:	89 e5                	mov    %esp,%ebp
f0107d57:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107d5a:	6a 08                	push   $0x8
f0107d5c:	6a 00                	push   $0x0
f0107d5e:	68 6c dd 5d f0       	push   $0xf05ddd6c
f0107d63:	e8 9c eb ff ff       	call   f0106904 <memset>

	return pci_scan_bus(&root_bus);
f0107d68:	b8 6c dd 5d f0       	mov    $0xf05ddd6c,%eax
f0107d6d:	e8 0d fc ff ff       	call   f010797f <pci_scan_bus>
}
f0107d72:	c9                   	leave  
f0107d73:	c3                   	ret    

f0107d74 <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f0107d74:	c7 05 74 dd 5d f0 00 	movl   $0x0,0xf05ddd74
f0107d7b:	00 00 00 
}
f0107d7e:	c3                   	ret    

f0107d7f <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f0107d7f:	a1 74 dd 5d f0       	mov    0xf05ddd74,%eax
f0107d84:	83 c0 01             	add    $0x1,%eax
f0107d87:	a3 74 dd 5d f0       	mov    %eax,0xf05ddd74
	if (ticks * 10 < ticks)
f0107d8c:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107d8f:	01 d2                	add    %edx,%edx
f0107d91:	39 d0                	cmp    %edx,%eax
f0107d93:	77 01                	ja     f0107d96 <time_tick+0x17>
f0107d95:	c3                   	ret    
{
f0107d96:	55                   	push   %ebp
f0107d97:	89 e5                	mov    %esp,%ebp
f0107d99:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0107d9c:	68 64 a8 10 f0       	push   $0xf010a864
f0107da1:	6a 13                	push   $0x13
f0107da3:	68 7f a8 10 f0       	push   $0xf010a87f
f0107da8:	e8 9c 82 ff ff       	call   f0100049 <_panic>

f0107dad <time_msec>:
f0107dad:	a1 74 dd 5d f0       	mov    0xf05ddd74,%eax
f0107db2:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0107db5:	01 c0                	add    %eax,%eax
f0107db7:	c3                   	ret    
f0107db8:	66 90                	xchg   %ax,%ax
f0107dba:	66 90                	xchg   %ax,%ax
f0107dbc:	66 90                	xchg   %ax,%ax
f0107dbe:	66 90                	xchg   %ax,%ax

f0107dc0 <__udivdi3>:
f0107dc0:	55                   	push   %ebp
f0107dc1:	57                   	push   %edi
f0107dc2:	56                   	push   %esi
f0107dc3:	53                   	push   %ebx
f0107dc4:	83 ec 1c             	sub    $0x1c,%esp
f0107dc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0107dcb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0107dcf:	8b 74 24 34          	mov    0x34(%esp),%esi
f0107dd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0107dd7:	85 d2                	test   %edx,%edx
f0107dd9:	75 4d                	jne    f0107e28 <__udivdi3+0x68>
f0107ddb:	39 f3                	cmp    %esi,%ebx
f0107ddd:	76 19                	jbe    f0107df8 <__udivdi3+0x38>
f0107ddf:	31 ff                	xor    %edi,%edi
f0107de1:	89 e8                	mov    %ebp,%eax
f0107de3:	89 f2                	mov    %esi,%edx
f0107de5:	f7 f3                	div    %ebx
f0107de7:	89 fa                	mov    %edi,%edx
f0107de9:	83 c4 1c             	add    $0x1c,%esp
f0107dec:	5b                   	pop    %ebx
f0107ded:	5e                   	pop    %esi
f0107dee:	5f                   	pop    %edi
f0107def:	5d                   	pop    %ebp
f0107df0:	c3                   	ret    
f0107df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107df8:	89 d9                	mov    %ebx,%ecx
f0107dfa:	85 db                	test   %ebx,%ebx
f0107dfc:	75 0b                	jne    f0107e09 <__udivdi3+0x49>
f0107dfe:	b8 01 00 00 00       	mov    $0x1,%eax
f0107e03:	31 d2                	xor    %edx,%edx
f0107e05:	f7 f3                	div    %ebx
f0107e07:	89 c1                	mov    %eax,%ecx
f0107e09:	31 d2                	xor    %edx,%edx
f0107e0b:	89 f0                	mov    %esi,%eax
f0107e0d:	f7 f1                	div    %ecx
f0107e0f:	89 c6                	mov    %eax,%esi
f0107e11:	89 e8                	mov    %ebp,%eax
f0107e13:	89 f7                	mov    %esi,%edi
f0107e15:	f7 f1                	div    %ecx
f0107e17:	89 fa                	mov    %edi,%edx
f0107e19:	83 c4 1c             	add    $0x1c,%esp
f0107e1c:	5b                   	pop    %ebx
f0107e1d:	5e                   	pop    %esi
f0107e1e:	5f                   	pop    %edi
f0107e1f:	5d                   	pop    %ebp
f0107e20:	c3                   	ret    
f0107e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107e28:	39 f2                	cmp    %esi,%edx
f0107e2a:	77 1c                	ja     f0107e48 <__udivdi3+0x88>
f0107e2c:	0f bd fa             	bsr    %edx,%edi
f0107e2f:	83 f7 1f             	xor    $0x1f,%edi
f0107e32:	75 2c                	jne    f0107e60 <__udivdi3+0xa0>
f0107e34:	39 f2                	cmp    %esi,%edx
f0107e36:	72 06                	jb     f0107e3e <__udivdi3+0x7e>
f0107e38:	31 c0                	xor    %eax,%eax
f0107e3a:	39 eb                	cmp    %ebp,%ebx
f0107e3c:	77 a9                	ja     f0107de7 <__udivdi3+0x27>
f0107e3e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107e43:	eb a2                	jmp    f0107de7 <__udivdi3+0x27>
f0107e45:	8d 76 00             	lea    0x0(%esi),%esi
f0107e48:	31 ff                	xor    %edi,%edi
f0107e4a:	31 c0                	xor    %eax,%eax
f0107e4c:	89 fa                	mov    %edi,%edx
f0107e4e:	83 c4 1c             	add    $0x1c,%esp
f0107e51:	5b                   	pop    %ebx
f0107e52:	5e                   	pop    %esi
f0107e53:	5f                   	pop    %edi
f0107e54:	5d                   	pop    %ebp
f0107e55:	c3                   	ret    
f0107e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107e5d:	8d 76 00             	lea    0x0(%esi),%esi
f0107e60:	89 f9                	mov    %edi,%ecx
f0107e62:	b8 20 00 00 00       	mov    $0x20,%eax
f0107e67:	29 f8                	sub    %edi,%eax
f0107e69:	d3 e2                	shl    %cl,%edx
f0107e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
f0107e6f:	89 c1                	mov    %eax,%ecx
f0107e71:	89 da                	mov    %ebx,%edx
f0107e73:	d3 ea                	shr    %cl,%edx
f0107e75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107e79:	09 d1                	or     %edx,%ecx
f0107e7b:	89 f2                	mov    %esi,%edx
f0107e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107e81:	89 f9                	mov    %edi,%ecx
f0107e83:	d3 e3                	shl    %cl,%ebx
f0107e85:	89 c1                	mov    %eax,%ecx
f0107e87:	d3 ea                	shr    %cl,%edx
f0107e89:	89 f9                	mov    %edi,%ecx
f0107e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107e8f:	89 eb                	mov    %ebp,%ebx
f0107e91:	d3 e6                	shl    %cl,%esi
f0107e93:	89 c1                	mov    %eax,%ecx
f0107e95:	d3 eb                	shr    %cl,%ebx
f0107e97:	09 de                	or     %ebx,%esi
f0107e99:	89 f0                	mov    %esi,%eax
f0107e9b:	f7 74 24 08          	divl   0x8(%esp)
f0107e9f:	89 d6                	mov    %edx,%esi
f0107ea1:	89 c3                	mov    %eax,%ebx
f0107ea3:	f7 64 24 0c          	mull   0xc(%esp)
f0107ea7:	39 d6                	cmp    %edx,%esi
f0107ea9:	72 15                	jb     f0107ec0 <__udivdi3+0x100>
f0107eab:	89 f9                	mov    %edi,%ecx
f0107ead:	d3 e5                	shl    %cl,%ebp
f0107eaf:	39 c5                	cmp    %eax,%ebp
f0107eb1:	73 04                	jae    f0107eb7 <__udivdi3+0xf7>
f0107eb3:	39 d6                	cmp    %edx,%esi
f0107eb5:	74 09                	je     f0107ec0 <__udivdi3+0x100>
f0107eb7:	89 d8                	mov    %ebx,%eax
f0107eb9:	31 ff                	xor    %edi,%edi
f0107ebb:	e9 27 ff ff ff       	jmp    f0107de7 <__udivdi3+0x27>
f0107ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107ec3:	31 ff                	xor    %edi,%edi
f0107ec5:	e9 1d ff ff ff       	jmp    f0107de7 <__udivdi3+0x27>
f0107eca:	66 90                	xchg   %ax,%ax
f0107ecc:	66 90                	xchg   %ax,%ax
f0107ece:	66 90                	xchg   %ax,%ax

f0107ed0 <__umoddi3>:
f0107ed0:	55                   	push   %ebp
f0107ed1:	57                   	push   %edi
f0107ed2:	56                   	push   %esi
f0107ed3:	53                   	push   %ebx
f0107ed4:	83 ec 1c             	sub    $0x1c,%esp
f0107ed7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0107edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0107edf:	8b 74 24 30          	mov    0x30(%esp),%esi
f0107ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107ee7:	89 da                	mov    %ebx,%edx
f0107ee9:	85 c0                	test   %eax,%eax
f0107eeb:	75 43                	jne    f0107f30 <__umoddi3+0x60>
f0107eed:	39 df                	cmp    %ebx,%edi
f0107eef:	76 17                	jbe    f0107f08 <__umoddi3+0x38>
f0107ef1:	89 f0                	mov    %esi,%eax
f0107ef3:	f7 f7                	div    %edi
f0107ef5:	89 d0                	mov    %edx,%eax
f0107ef7:	31 d2                	xor    %edx,%edx
f0107ef9:	83 c4 1c             	add    $0x1c,%esp
f0107efc:	5b                   	pop    %ebx
f0107efd:	5e                   	pop    %esi
f0107efe:	5f                   	pop    %edi
f0107eff:	5d                   	pop    %ebp
f0107f00:	c3                   	ret    
f0107f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107f08:	89 fd                	mov    %edi,%ebp
f0107f0a:	85 ff                	test   %edi,%edi
f0107f0c:	75 0b                	jne    f0107f19 <__umoddi3+0x49>
f0107f0e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107f13:	31 d2                	xor    %edx,%edx
f0107f15:	f7 f7                	div    %edi
f0107f17:	89 c5                	mov    %eax,%ebp
f0107f19:	89 d8                	mov    %ebx,%eax
f0107f1b:	31 d2                	xor    %edx,%edx
f0107f1d:	f7 f5                	div    %ebp
f0107f1f:	89 f0                	mov    %esi,%eax
f0107f21:	f7 f5                	div    %ebp
f0107f23:	89 d0                	mov    %edx,%eax
f0107f25:	eb d0                	jmp    f0107ef7 <__umoddi3+0x27>
f0107f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107f2e:	66 90                	xchg   %ax,%ax
f0107f30:	89 f1                	mov    %esi,%ecx
f0107f32:	39 d8                	cmp    %ebx,%eax
f0107f34:	76 0a                	jbe    f0107f40 <__umoddi3+0x70>
f0107f36:	89 f0                	mov    %esi,%eax
f0107f38:	83 c4 1c             	add    $0x1c,%esp
f0107f3b:	5b                   	pop    %ebx
f0107f3c:	5e                   	pop    %esi
f0107f3d:	5f                   	pop    %edi
f0107f3e:	5d                   	pop    %ebp
f0107f3f:	c3                   	ret    
f0107f40:	0f bd e8             	bsr    %eax,%ebp
f0107f43:	83 f5 1f             	xor    $0x1f,%ebp
f0107f46:	75 20                	jne    f0107f68 <__umoddi3+0x98>
f0107f48:	39 d8                	cmp    %ebx,%eax
f0107f4a:	0f 82 b0 00 00 00    	jb     f0108000 <__umoddi3+0x130>
f0107f50:	39 f7                	cmp    %esi,%edi
f0107f52:	0f 86 a8 00 00 00    	jbe    f0108000 <__umoddi3+0x130>
f0107f58:	89 c8                	mov    %ecx,%eax
f0107f5a:	83 c4 1c             	add    $0x1c,%esp
f0107f5d:	5b                   	pop    %ebx
f0107f5e:	5e                   	pop    %esi
f0107f5f:	5f                   	pop    %edi
f0107f60:	5d                   	pop    %ebp
f0107f61:	c3                   	ret    
f0107f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107f68:	89 e9                	mov    %ebp,%ecx
f0107f6a:	ba 20 00 00 00       	mov    $0x20,%edx
f0107f6f:	29 ea                	sub    %ebp,%edx
f0107f71:	d3 e0                	shl    %cl,%eax
f0107f73:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107f77:	89 d1                	mov    %edx,%ecx
f0107f79:	89 f8                	mov    %edi,%eax
f0107f7b:	d3 e8                	shr    %cl,%eax
f0107f7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107f81:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107f85:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107f89:	09 c1                	or     %eax,%ecx
f0107f8b:	89 d8                	mov    %ebx,%eax
f0107f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107f91:	89 e9                	mov    %ebp,%ecx
f0107f93:	d3 e7                	shl    %cl,%edi
f0107f95:	89 d1                	mov    %edx,%ecx
f0107f97:	d3 e8                	shr    %cl,%eax
f0107f99:	89 e9                	mov    %ebp,%ecx
f0107f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0107f9f:	d3 e3                	shl    %cl,%ebx
f0107fa1:	89 c7                	mov    %eax,%edi
f0107fa3:	89 d1                	mov    %edx,%ecx
f0107fa5:	89 f0                	mov    %esi,%eax
f0107fa7:	d3 e8                	shr    %cl,%eax
f0107fa9:	89 e9                	mov    %ebp,%ecx
f0107fab:	89 fa                	mov    %edi,%edx
f0107fad:	d3 e6                	shl    %cl,%esi
f0107faf:	09 d8                	or     %ebx,%eax
f0107fb1:	f7 74 24 08          	divl   0x8(%esp)
f0107fb5:	89 d1                	mov    %edx,%ecx
f0107fb7:	89 f3                	mov    %esi,%ebx
f0107fb9:	f7 64 24 0c          	mull   0xc(%esp)
f0107fbd:	89 c6                	mov    %eax,%esi
f0107fbf:	89 d7                	mov    %edx,%edi
f0107fc1:	39 d1                	cmp    %edx,%ecx
f0107fc3:	72 06                	jb     f0107fcb <__umoddi3+0xfb>
f0107fc5:	75 10                	jne    f0107fd7 <__umoddi3+0x107>
f0107fc7:	39 c3                	cmp    %eax,%ebx
f0107fc9:	73 0c                	jae    f0107fd7 <__umoddi3+0x107>
f0107fcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
f0107fcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0107fd3:	89 d7                	mov    %edx,%edi
f0107fd5:	89 c6                	mov    %eax,%esi
f0107fd7:	89 ca                	mov    %ecx,%edx
f0107fd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107fde:	29 f3                	sub    %esi,%ebx
f0107fe0:	19 fa                	sbb    %edi,%edx
f0107fe2:	89 d0                	mov    %edx,%eax
f0107fe4:	d3 e0                	shl    %cl,%eax
f0107fe6:	89 e9                	mov    %ebp,%ecx
f0107fe8:	d3 eb                	shr    %cl,%ebx
f0107fea:	d3 ea                	shr    %cl,%edx
f0107fec:	09 d8                	or     %ebx,%eax
f0107fee:	83 c4 1c             	add    $0x1c,%esp
f0107ff1:	5b                   	pop    %ebx
f0107ff2:	5e                   	pop    %esi
f0107ff3:	5f                   	pop    %edi
f0107ff4:	5d                   	pop    %ebp
f0107ff5:	c3                   	ret    
f0107ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107ffd:	8d 76 00             	lea    0x0(%esi),%esi
f0108000:	89 da                	mov    %ebx,%edx
f0108002:	29 fe                	sub    %edi,%esi
f0108004:	19 c2                	sbb    %eax,%edx
f0108006:	89 f1                	mov    %esi,%ecx
f0108008:	89 c8                	mov    %ecx,%eax
f010800a:	e9 4b ff ff ff       	jmp    f0107f5a <__umoddi3+0x8a>

Disassembly of section .user_mapped:

f0121000 <env_pop_tf>:
// This function does not return.
//
//mapped text lab7
__user_mapped_text void
env_pop_tf(struct Trapframe *tf)
{
f0121000:	55                   	push   %ebp
f0121001:	89 e5                	mov    %esp,%ebp
f0121003:	83 ec 0c             	sub    $0xc,%esp
	asm volatile(
f0121006:	8b 65 08             	mov    0x8(%ebp),%esp
f0121009:	61                   	popa   
f012100a:	07                   	pop    %es
f012100b:	1f                   	pop    %ds
f012100c:	83 c4 08             	add    $0x8,%esp
f012100f:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0121010:	68 08 96 10 f0       	push   $0xf0109608
f0121015:	68 a7 02 00 00       	push   $0x2a7
f012101a:	68 14 96 10 f0       	push   $0xf0109614
f012101f:	e8 25 f0 fd ff       	call   f0100049 <_panic>

f0121024 <env_run>:
//
// This function does not return.
//
__user_mapped_text void
env_run(struct Env *e)
{
f0121024:	55                   	push   %ebp
f0121025:	89 e5                	mov    %esp,%ebp
f0121027:	57                   	push   %edi
f0121028:	56                   	push   %esi
f0121029:	53                   	push   %ebx
f012102a:	83 ec 6c             	sub    $0x6c,%esp
	pde_t *pgdir = e->env_pgdir;
f012102d:	8b 45 08             	mov    0x8(%ebp),%eax
f0121030:	8b 78 60             	mov    0x60(%eax),%edi
		if ((uintptr_t) envs <= va && va < (uintptr_t) (envs + NENV))
f0121033:	8b 1d 44 d9 5d f0    	mov    0xf05dd944,%ebx
f0121039:	8d b3 00 10 02 00    	lea    0x21000(%ebx),%esi
	if (PGNUM(pa) >= npages)
f012103f:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f0121044:	89 45 94             	mov    %eax,-0x6c(%ebp)
	for (uintptr_t va = ULIM; va; va += PGSIZE) {
f0121047:	b8 00 00 80 ef       	mov    $0xef800000,%eax
f012104c:	eb 3e                	jmp    f012108c <env_run+0x68>
		if (pgdir[PDX(va)] & PTE_P) {
f012104e:	89 c2                	mov    %eax,%edx
f0121050:	c1 ea 16             	shr    $0x16,%edx
f0121053:	8b 14 97             	mov    (%edi,%edx,4),%edx
f0121056:	f6 c2 01             	test   $0x1,%dl
f0121059:	74 2a                	je     f0121085 <env_run+0x61>
			if (pgdir[PDX(va)] & PTE_PS)
f012105b:	f6 c2 80             	test   $0x80,%dl
f012105e:	75 52                	jne    f01210b2 <env_run+0x8e>
				pte_t *pte = KADDR(PTE_ADDR(pgdir[PDX(va)]));
f0121060:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0121066:	89 d1                	mov    %edx,%ecx
f0121068:	c1 e9 0c             	shr    $0xc,%ecx
f012106b:	3b 4d 94             	cmp    -0x6c(%ebp),%ecx
f012106e:	73 57                	jae    f01210c7 <env_run+0xa3>
				if (pte[PTX(va)] & PTE_P)
f0121070:	89 c1                	mov    %eax,%ecx
f0121072:	c1 e9 0c             	shr    $0xc,%ecx
f0121075:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f012107b:	f6 84 8a 00 00 00 f0 	testb  $0x1,-0x10000000(%edx,%ecx,4)
f0121082:	01 
f0121083:	75 57                	jne    f01210dc <env_run+0xb8>
	for (uintptr_t va = ULIM; va; va += PGSIZE) {
f0121085:	05 00 10 00 00       	add    $0x1000,%eax
f012108a:	74 65                	je     f01210f1 <env_run+0xcd>
		if ((uintptr_t) __USER_MAP_BEGIN__ <= va && va < (uintptr_t) __USER_MAP_END__)
f012108c:	3d 00 10 12 f0       	cmp    $0xf0121000,%eax
f0121091:	72 07                	jb     f012109a <env_run+0x76>
f0121093:	3d 00 c0 16 f0       	cmp    $0xf016c000,%eax
f0121098:	72 eb                	jb     f0121085 <env_run+0x61>
		if (KSTACKTOP - (KSTKSIZE + KSTKGAP) * NCPU <= va && va < KSTACKTOP)
f012109a:	8d 90 00 00 08 10    	lea    0x10080000(%eax),%edx
f01210a0:	81 fa ff ff 07 00    	cmp    $0x7ffff,%edx
f01210a6:	76 dd                	jbe    f0121085 <env_run+0x61>
		if ((uintptr_t) envs <= va && va < (uintptr_t) (envs + NENV))
f01210a8:	39 c3                	cmp    %eax,%ebx
f01210aa:	77 a2                	ja     f012104e <env_run+0x2a>
f01210ac:	39 c6                	cmp    %eax,%esi
f01210ae:	76 9e                	jbe    f012104e <env_run+0x2a>
f01210b0:	eb d3                	jmp    f0121085 <env_run+0x61>
				panic("User page table has kernel address %08x mapped", va);
f01210b2:	50                   	push   %eax
f01210b3:	68 ec 97 10 f0       	push   $0xf01097ec
f01210b8:	68 7e 02 00 00       	push   $0x27e
f01210bd:	68 14 96 10 f0       	push   $0xf0109614
f01210c2:	e8 82 ef fd ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01210c7:	52                   	push   %edx
f01210c8:	68 74 80 10 f0       	push   $0xf0108074
f01210cd:	68 80 02 00 00       	push   $0x280
f01210d2:	68 14 96 10 f0       	push   $0xf0109614
f01210d7:	e8 6d ef fd ff       	call   f0100049 <_panic>
					panic("User page table has kernel address %08x mapped", va);
f01210dc:	50                   	push   %eax
f01210dd:	68 ec 97 10 f0       	push   $0xf01097ec
f01210e2:	68 82 02 00 00       	push   $0x282
f01210e7:	68 14 96 10 f0       	push   $0xf0109614
f01210ec:	e8 58 ef fd ff       	call   f0100049 <_panic>
	check_user_map(pgdir, gdt, sizeof(gdt), "GDT");
f01210f1:	83 ec 0c             	sub    $0xc,%esp
f01210f4:	68 4d 97 10 f0       	push   $0xf010974d
f01210f9:	b9 68 00 00 00       	mov    $0x68,%ecx
f01210fe:	ba 00 a0 12 f0       	mov    $0xf012a000,%edx
f0121103:	89 f8                	mov    %edi,%eax
f0121105:	e8 3b 24 fe ff       	call   f0103545 <check_user_map>
	check_user_map(pgdir, (void *) idt_pd.pd_base, idt_pd.pd_lim, "IDT");
f012110a:	0f b7 0d 10 d3 16 f0 	movzwl 0xf016d310,%ecx
f0121111:	c7 04 24 51 97 10 f0 	movl   $0xf0109751,(%esp)
f0121118:	8b 15 12 d3 16 f0    	mov    0xf016d312,%edx
f012111e:	89 f8                	mov    %edi,%eax
f0121120:	e8 20 24 fe ff       	call   f0103545 <check_user_map>
f0121125:	83 c4 10             	add    $0x10,%esp
f0121128:	bb 05 00 00 00       	mov    $0x5,%ebx
		check_user_map(pgdir, (void *) SEG_BASE(gdt[(GD_TSS0 >> 3) + i]), SEG_LIM(gdt[(GD_TSS0 >> 3) + i]), name);
f012112d:	be 00 a0 12 f0       	mov    $0xf012a000,%esi
		char name[] = "TSS0";
f0121132:	c7 45 9c 54 53 53 30 	movl   $0x30535354,-0x64(%ebp)
f0121139:	c6 45 a0 00          	movb   $0x0,-0x60(%ebp)
		name[3] = '0' + i;
f012113d:	8d 43 2b             	lea    0x2b(%ebx),%eax
f0121140:	88 45 9f             	mov    %al,-0x61(%ebp)
		check_user_map(pgdir, (void *) SEG_BASE(gdt[(GD_TSS0 >> 3) + i]), SEG_LIM(gdt[(GD_TSS0 >> 3) + i]), name);
f0121143:	0f b6 4c de 06       	movzbl 0x6(%esi,%ebx,8),%ecx
f0121148:	83 e1 0f             	and    $0xf,%ecx
f012114b:	c1 e1 10             	shl    $0x10,%ecx
f012114e:	0f b7 04 de          	movzwl (%esi,%ebx,8),%eax
f0121152:	09 c1                	or     %eax,%ecx
f0121154:	0f b6 54 de 04       	movzbl 0x4(%esi,%ebx,8),%edx
f0121159:	c1 e2 10             	shl    $0x10,%edx
f012115c:	0f b6 44 de 07       	movzbl 0x7(%esi,%ebx,8),%eax
f0121161:	c1 e0 18             	shl    $0x18,%eax
f0121164:	09 c2                	or     %eax,%edx
f0121166:	0f b7 44 de 02       	movzwl 0x2(%esi,%ebx,8),%eax
f012116b:	09 c2                	or     %eax,%edx
f012116d:	83 ec 0c             	sub    $0xc,%esp
f0121170:	8d 45 9c             	lea    -0x64(%ebp),%eax
f0121173:	50                   	push   %eax
f0121174:	89 f8                	mov    %edi,%eax
f0121176:	e8 ca 23 fe ff       	call   f0103545 <check_user_map>
f012117b:	83 c3 01             	add    $0x1,%ebx
	for (int i = 0; i < NCPU; i++) {
f012117e:	83 c4 10             	add    $0x10,%esp
f0121181:	83 fb 0d             	cmp    $0xd,%ebx
f0121184:	75 ac                	jne    f0121132 <env_run+0x10e>
f0121186:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f012118b:	bb 30 00 00 00       	mov    $0x30,%ebx
		char name[] = "kstack0";
f0121190:	c7 45 9c 6b 73 74 61 	movl   $0x6174736b,-0x64(%ebp)
f0121197:	c7 45 a0 63 6b 30 00 	movl   $0x306b63,-0x60(%ebp)
		name[6] = '0' + i;
f012119e:	88 5d a2             	mov    %bl,-0x5e(%ebp)
		check_user_map(pgdir, (void *) KSTACKTOP - (KSTKSIZE + KSTKGAP) * i - KSTKSIZE, KSTKSIZE, name);
f01211a1:	83 ec 0c             	sub    $0xc,%esp
f01211a4:	8d 45 9c             	lea    -0x64(%ebp),%eax
f01211a7:	50                   	push   %eax
f01211a8:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01211ad:	89 f2                	mov    %esi,%edx
f01211af:	89 f8                	mov    %edi,%eax
f01211b1:	e8 8f 23 fe ff       	call   f0103545 <check_user_map>
f01211b6:	83 c3 01             	add    $0x1,%ebx
f01211b9:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (int i = 0; i < NCPU; i++) {
f01211bf:	83 c4 10             	add    $0x10,%esp
f01211c2:	80 fb 38             	cmp    $0x38,%bl
f01211c5:	75 c9                	jne    f0121190 <env_run+0x16c>
	check_user_map(pgdir, env_pop_tf, sizeof(env_pop_tf), "env_pop_tf");
f01211c7:	83 ec 0c             	sub    $0xc,%esp
f01211ca:	68 55 97 10 f0       	push   $0xf0109755
f01211cf:	b9 01 00 00 00       	mov    $0x1,%ecx
f01211d4:	ba 00 10 12 f0       	mov    $0xf0121000,%edx
f01211d9:	89 f8                	mov    %edi,%eax
f01211db:	e8 65 23 fe ff       	call   f0103545 <check_user_map>
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f01211e0:	e8 25 5d fe ff       	call   f0106f0a <cpunum>
f01211e5:	6b c0 74             	imul   $0x74,%eax,%eax
f01211e8:	83 c4 10             	add    $0x10,%esp
f01211eb:	8b 75 08             	mov    0x8(%ebp),%esi
f01211ee:	39 b0 28 b0 16 f0    	cmp    %esi,-0xfe94fd8(%eax)
f01211f4:	74 61                	je     f0121257 <env_run+0x233>
		if(curenv && curenv->env_status == ENV_RUNNING)
f01211f6:	e8 0f 5d fe ff       	call   f0106f0a <cpunum>
f01211fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01211fe:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0121205:	74 18                	je     f012121f <env_run+0x1fb>
f0121207:	e8 fe 5c fe ff       	call   f0106f0a <cpunum>
f012120c:	6b c0 74             	imul   $0x74,%eax,%eax
f012120f:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121215:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0121219:	0f 84 8e 00 00 00    	je     f01212ad <env_run+0x289>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f012121f:	e8 e6 5c fe ff       	call   f0106f0a <cpunum>
f0121224:	6b c0 74             	imul   $0x74,%eax,%eax
f0121227:	8b 75 08             	mov    0x8(%ebp),%esi
f012122a:	89 b0 28 b0 16 f0    	mov    %esi,-0xfe94fd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0121230:	e8 d5 5c fe ff       	call   f0106f0a <cpunum>
f0121235:	6b c0 74             	imul   $0x74,%eax,%eax
f0121238:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f012123e:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0121245:	e8 c0 5c fe ff       	call   f0106f0a <cpunum>
f012124a:	6b c0 74             	imul   $0x74,%eax,%eax
f012124d:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121253:	83 40 58 01          	addl   $0x1,0x58(%eax)
		// lcr3(PADDR(curenv->env_pgdir));
	}
	// lcr3(PADDR(curenv->env_pgdir));
	trapframe = curenv->env_tf;
f0121257:	e8 ae 5c fe ff       	call   f0106f0a <cpunum>
f012125c:	6b c0 74             	imul   $0x74,%eax,%eax
f012125f:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0121265:	8d 7d a4             	lea    -0x5c(%ebp),%edi
f0121268:	b9 11 00 00 00       	mov    $0x11,%ecx
f012126d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	spin_unlock(&kernel_lock);
f012126f:	83 ec 0c             	sub    $0xc,%esp
f0121272:	68 20 d3 16 f0       	push   $0xf016d320
f0121277:	e8 b3 5f fe ff       	call   f010722f <spin_unlock>
	asm volatile("pause");
f012127c:	f3 90                	pause  
	unlock_kernel(); //lab4 bug?
	lcr3(PADDR(curenv->env_pgdir));
f012127e:	e8 87 5c fe ff       	call   f0106f0a <cpunum>
f0121283:	6b c0 74             	imul   $0x74,%eax,%eax
f0121286:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f012128c:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f012128f:	83 c4 10             	add    $0x10,%esp
f0121292:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0121297:	76 2e                	jbe    f01212c7 <env_run+0x2a3>
	return (physaddr_t)kva - KERNBASE;
f0121299:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f012129e:	0f 22 d8             	mov    %eax,%cr3
	env_pop_tf(&trapframe);
f01212a1:	83 ec 0c             	sub    $0xc,%esp
f01212a4:	8d 45 a4             	lea    -0x5c(%ebp),%eax
f01212a7:	50                   	push   %eax
f01212a8:	e8 53 fd ff ff       	call   f0121000 <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f01212ad:	e8 58 5c fe ff       	call   f0106f0a <cpunum>
f01212b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01212b5:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01212bb:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f01212c2:	e9 58 ff ff ff       	jmp    f012121f <env_run+0x1fb>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01212c7:	50                   	push   %eax
f01212c8:	68 98 80 10 f0       	push   $0xf0108098
f01212cd:	68 e0 02 00 00       	push   $0x2e0
f01212d2:	68 14 96 10 f0       	push   $0xf0109614
f01212d7:	e8 6d ed fd ff       	call   f0100049 <_panic>

f01212dc <switch_and_trap>:

__user_mapped_text void
switch_and_trap(struct Trapframe *frame)
{
f01212dc:	55                   	push   %ebp
f01212dd:	89 e5                	mov    %esp,%ebp
f01212df:	83 ec 08             	sub    $0x8,%esp
f01212e2:	8b 55 08             	mov    0x8(%ebp),%edx
	// LAB7: Your code here
	if ((frame->tf_cs & 3) == 3) {
f01212e5:	0f b7 42 34          	movzwl 0x34(%edx),%eax
f01212e9:	83 e0 03             	and    $0x3,%eax
f01212ec:	66 83 f8 03          	cmp    $0x3,%ax
f01212f0:	75 27                	jne    f0121319 <switch_and_trap+0x3d>
	asm volatile("movl %%esp,%0" : "=r" (esp));
f01212f2:	89 e1                	mov    %esp,%ecx
		// Calculate the current CPU core number
		uint32_t esp = read_esp();
		int cpunum = (KSTACKTOP - esp) / (KSTKSIZE + KSTKGAP);
f01212f4:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
f01212f9:	29 c8                	sub    %ecx,%eax
f01212fb:	c1 e8 10             	shr    $0x10,%eax
		// Load the physical address of kernel page table
		// Switch to the kernel page table
		lcr3(PADDR((&cpus[cpunum])->cpu_env->env_kern_pgdir));
f01212fe:	6b c0 74             	imul   $0x74,%eax,%eax
f0121301:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121307:	8b 40 64             	mov    0x64(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f012130a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f012130f:	76 11                	jbe    f0121322 <switch_and_trap+0x46>
	return (physaddr_t)kva - KERNBASE;
f0121311:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0121316:	0f 22 d8             	mov    %eax,%cr3
	}
	trap(frame);
f0121319:	83 ec 0c             	sub    $0xc,%esp
f012131c:	52                   	push   %edx
f012131d:	e8 65 39 fe ff       	call   f0104c87 <trap>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0121322:	50                   	push   %eax
f0121323:	68 98 80 10 f0       	push   $0xf0108098
f0121328:	68 19 02 00 00       	push   $0x219
f012132d:	68 14 9a 10 f0       	push   $0xf0109a14
f0121332:	e8 12 ed fd ff       	call   f0100049 <_panic>
f0121337:	90                   	nop

f0121338 <DIVIDE_HANDLER>:
f0121338:	6a 00                	push   $0x0
f012133a:	6a 00                	push   $0x0
f012133c:	e9 f9 00 00 00       	jmp    f012143a <_alltraps>
	...

f0121342 <DEBUG_HANDLER>:
f0121342:	6a 00                	push   $0x0
f0121344:	6a 01                	push   $0x1
f0121346:	e9 ef 00 00 00       	jmp    f012143a <_alltraps>
	...

f012134c <NMI_HANDLER>:
f012134c:	6a 00                	push   $0x0
f012134e:	6a 02                	push   $0x2
f0121350:	e9 e5 00 00 00       	jmp    f012143a <_alltraps>
	...

f0121356 <BRKPT_HANDLER>:
f0121356:	6a 00                	push   $0x0
f0121358:	6a 03                	push   $0x3
f012135a:	e9 db 00 00 00       	jmp    f012143a <_alltraps>
	...

f0121360 <OFLOW_HANDLER>:
f0121360:	6a 00                	push   $0x0
f0121362:	6a 04                	push   $0x4
f0121364:	e9 d1 00 00 00       	jmp    f012143a <_alltraps>
	...

f012136a <BOUND_HANDLER>:
f012136a:	6a 00                	push   $0x0
f012136c:	6a 05                	push   $0x5
f012136e:	e9 c7 00 00 00       	jmp    f012143a <_alltraps>
	...

f0121374 <ILLOP_HANDLER>:
f0121374:	6a 00                	push   $0x0
f0121376:	6a 06                	push   $0x6
f0121378:	e9 bd 00 00 00       	jmp    f012143a <_alltraps>
	...

f012137e <DEVICE_HANDLER>:
f012137e:	6a 00                	push   $0x0
f0121380:	6a 07                	push   $0x7
f0121382:	e9 b3 00 00 00       	jmp    f012143a <_alltraps>
	...

f0121388 <DBLFLT_HANDLER>:
f0121388:	6a 08                	push   $0x8
f012138a:	e9 ab 00 00 00       	jmp    f012143a <_alltraps>
	...

f0121390 <TSS_HANDLER>:
f0121390:	6a 0a                	push   $0xa
f0121392:	e9 a3 00 00 00       	jmp    f012143a <_alltraps>
	...

f0121398 <SEGNP_HANDLER>:
f0121398:	6a 0b                	push   $0xb
f012139a:	e9 9b 00 00 00       	jmp    f012143a <_alltraps>
	...

f01213a0 <STACK_HANDLER>:
f01213a0:	6a 0c                	push   $0xc
f01213a2:	e9 93 00 00 00       	jmp    f012143a <_alltraps>
	...

f01213a8 <GPFLT_HANDLER>:
f01213a8:	6a 0d                	push   $0xd
f01213aa:	e9 8b 00 00 00       	jmp    f012143a <_alltraps>
	...

f01213b0 <PGFLT_HANDLER>:
f01213b0:	6a 0e                	push   $0xe
f01213b2:	e9 83 00 00 00       	jmp    f012143a <_alltraps>
	...

f01213b8 <FPERR_HANDLER>:
f01213b8:	6a 00                	push   $0x0
f01213ba:	6a 10                	push   $0x10
f01213bc:	eb 7c                	jmp    f012143a <_alltraps>

f01213be <ALIGN_HANDLER>:
f01213be:	6a 11                	push   $0x11
f01213c0:	eb 78                	jmp    f012143a <_alltraps>

f01213c2 <MCHK_HANDLER>:
f01213c2:	6a 00                	push   $0x0
f01213c4:	6a 12                	push   $0x12
f01213c6:	eb 72                	jmp    f012143a <_alltraps>

f01213c8 <SIMDERR_HANDLER>:
f01213c8:	6a 00                	push   $0x0
f01213ca:	6a 13                	push   $0x13
f01213cc:	eb 6c                	jmp    f012143a <_alltraps>

f01213ce <SYSCALL_HANDLER>:
f01213ce:	6a 00                	push   $0x0
f01213d0:	6a 30                	push   $0x30
f01213d2:	eb 66                	jmp    f012143a <_alltraps>

f01213d4 <TIMER_HANDLER>:
f01213d4:	6a 00                	push   $0x0
f01213d6:	6a 20                	push   $0x20
f01213d8:	eb 60                	jmp    f012143a <_alltraps>

f01213da <KBD_HANDLER>:
f01213da:	6a 00                	push   $0x0
f01213dc:	6a 21                	push   $0x21
f01213de:	eb 5a                	jmp    f012143a <_alltraps>

f01213e0 <SECOND_HANDLER>:
f01213e0:	6a 00                	push   $0x0
f01213e2:	6a 22                	push   $0x22
f01213e4:	eb 54                	jmp    f012143a <_alltraps>

f01213e6 <THIRD_HANDLER>:
f01213e6:	6a 00                	push   $0x0
f01213e8:	6a 23                	push   $0x23
f01213ea:	eb 4e                	jmp    f012143a <_alltraps>

f01213ec <SERIAL_HANDLER>:
f01213ec:	6a 00                	push   $0x0
f01213ee:	6a 24                	push   $0x24
f01213f0:	eb 48                	jmp    f012143a <_alltraps>

f01213f2 <FIFTH_HANDLER>:
f01213f2:	6a 00                	push   $0x0
f01213f4:	6a 25                	push   $0x25
f01213f6:	eb 42                	jmp    f012143a <_alltraps>

f01213f8 <SIXTH_HANDLER>:
f01213f8:	6a 00                	push   $0x0
f01213fa:	6a 26                	push   $0x26
f01213fc:	eb 3c                	jmp    f012143a <_alltraps>

f01213fe <SPURIOUS_HANDLER>:
f01213fe:	6a 00                	push   $0x0
f0121400:	6a 27                	push   $0x27
f0121402:	eb 36                	jmp    f012143a <_alltraps>

f0121404 <EIGHTH_HANDLER>:
f0121404:	6a 00                	push   $0x0
f0121406:	6a 28                	push   $0x28
f0121408:	eb 30                	jmp    f012143a <_alltraps>

f012140a <NINTH_HANDLER>:
f012140a:	6a 00                	push   $0x0
f012140c:	6a 29                	push   $0x29
f012140e:	eb 2a                	jmp    f012143a <_alltraps>

f0121410 <TENTH_HANDLER>:
f0121410:	6a 00                	push   $0x0
f0121412:	6a 2a                	push   $0x2a
f0121414:	eb 24                	jmp    f012143a <_alltraps>

f0121416 <ELEVEN_HANDLER>:
f0121416:	6a 00                	push   $0x0
f0121418:	6a 2b                	push   $0x2b
f012141a:	eb 1e                	jmp    f012143a <_alltraps>

f012141c <TWELVE_HANDLER>:
f012141c:	6a 00                	push   $0x0
f012141e:	6a 2c                	push   $0x2c
f0121420:	eb 18                	jmp    f012143a <_alltraps>

f0121422 <THIRTEEN_HANDLER>:
f0121422:	6a 00                	push   $0x0
f0121424:	6a 2d                	push   $0x2d
f0121426:	eb 12                	jmp    f012143a <_alltraps>

f0121428 <IDE_HANDLER>:
f0121428:	6a 00                	push   $0x0
f012142a:	6a 2e                	push   $0x2e
f012142c:	eb 0c                	jmp    f012143a <_alltraps>

f012142e <FIFTEEN_HANDLER>:
f012142e:	6a 00                	push   $0x0
f0121430:	6a 2f                	push   $0x2f
f0121432:	eb 06                	jmp    f012143a <_alltraps>

f0121434 <ERROR_HANDLER>:
f0121434:	6a 00                	push   $0x0
f0121436:	6a 33                	push   $0x33
f0121438:	eb 00                	jmp    f012143a <_alltraps>

f012143a <_alltraps>:
f012143a:	66 6a 00             	pushw  $0x0
f012143d:	66 1e                	pushw  %ds
f012143f:	66 6a 00             	pushw  $0x0
f0121442:	66 06                	pushw  %es
f0121444:	60                   	pusha  
f0121445:	b8 10 00 00 00       	mov    $0x10,%eax
f012144a:	8e d8                	mov    %eax,%ds
f012144c:	8e c0                	mov    %eax,%es
f012144e:	54                   	push   %esp
f012144f:	e8 88 fe ff ff       	call   f01212dc <switch_and_trap>

f0121454 <sysenter_handler>:
f0121454:	56                   	push   %esi
f0121455:	57                   	push   %edi
f0121456:	53                   	push   %ebx
f0121457:	51                   	push   %ecx
f0121458:	52                   	push   %edx
f0121459:	50                   	push   %eax
f012145a:	e8 a3 3d fe ff       	call   f0105202 <syscall>
f012145f:	89 f2                	mov    %esi,%edx
f0121461:	89 e9                	mov    %ebp,%ecx
f0121463:	0f 35                	sysexit 
f0121465:	66 90                	xchg   %ax,%ax
f0121467:	66 90                	xchg   %ax,%ax
f0121469:	66 90                	xchg   %ax,%ax
f012146b:	66 90                	xchg   %ax,%ax
f012146d:	66 90                	xchg   %ax,%ax
f012146f:	66 90                	xchg   %ax,%ax
f0121471:	66 90                	xchg   %ax,%ax
f0121473:	66 90                	xchg   %ax,%ax
f0121475:	66 90                	xchg   %ax,%ax
f0121477:	66 90                	xchg   %ax,%ax
f0121479:	66 90                	xchg   %ax,%ax
f012147b:	66 90                	xchg   %ax,%ax
f012147d:	66 90                	xchg   %ax,%ax
f012147f:	66 90                	xchg   %ax,%ax
f0121481:	66 90                	xchg   %ax,%ax
f0121483:	66 90                	xchg   %ax,%ax
f0121485:	66 90                	xchg   %ax,%ax
f0121487:	66 90                	xchg   %ax,%ax
f0121489:	66 90                	xchg   %ax,%ax
f012148b:	66 90                	xchg   %ax,%ax
f012148d:	66 90                	xchg   %ax,%ax
f012148f:	66 90                	xchg   %ax,%ax
f0121491:	66 90                	xchg   %ax,%ax
f0121493:	66 90                	xchg   %ax,%ax
f0121495:	66 90                	xchg   %ax,%ax
f0121497:	66 90                	xchg   %ax,%ax
f0121499:	66 90                	xchg   %ax,%ax
f012149b:	66 90                	xchg   %ax,%ax
f012149d:	66 90                	xchg   %ax,%ax
f012149f:	66 90                	xchg   %ax,%ax
f01214a1:	66 90                	xchg   %ax,%ax
f01214a3:	66 90                	xchg   %ax,%ax
f01214a5:	66 90                	xchg   %ax,%ax
f01214a7:	66 90                	xchg   %ax,%ax
f01214a9:	66 90                	xchg   %ax,%ax
f01214ab:	66 90                	xchg   %ax,%ax
f01214ad:	66 90                	xchg   %ax,%ax
f01214af:	66 90                	xchg   %ax,%ax
f01214b1:	66 90                	xchg   %ax,%ax
f01214b3:	66 90                	xchg   %ax,%ax
f01214b5:	66 90                	xchg   %ax,%ax
f01214b7:	66 90                	xchg   %ax,%ax
f01214b9:	66 90                	xchg   %ax,%ax
f01214bb:	66 90                	xchg   %ax,%ax
f01214bd:	66 90                	xchg   %ax,%ax
f01214bf:	66 90                	xchg   %ax,%ax
f01214c1:	66 90                	xchg   %ax,%ax
f01214c3:	66 90                	xchg   %ax,%ax
f01214c5:	66 90                	xchg   %ax,%ax
f01214c7:	66 90                	xchg   %ax,%ax
f01214c9:	66 90                	xchg   %ax,%ax
f01214cb:	66 90                	xchg   %ax,%ax
f01214cd:	66 90                	xchg   %ax,%ax
f01214cf:	66 90                	xchg   %ax,%ax
f01214d1:	66 90                	xchg   %ax,%ax
f01214d3:	66 90                	xchg   %ax,%ax
f01214d5:	66 90                	xchg   %ax,%ax
f01214d7:	66 90                	xchg   %ax,%ax
f01214d9:	66 90                	xchg   %ax,%ax
f01214db:	66 90                	xchg   %ax,%ax
f01214dd:	66 90                	xchg   %ax,%ax
f01214df:	66 90                	xchg   %ax,%ax
f01214e1:	66 90                	xchg   %ax,%ax
f01214e3:	66 90                	xchg   %ax,%ax
f01214e5:	66 90                	xchg   %ax,%ax
f01214e7:	66 90                	xchg   %ax,%ax
f01214e9:	66 90                	xchg   %ax,%ax
f01214eb:	66 90                	xchg   %ax,%ax
f01214ed:	66 90                	xchg   %ax,%ax
f01214ef:	66 90                	xchg   %ax,%ax
f01214f1:	66 90                	xchg   %ax,%ax
f01214f3:	66 90                	xchg   %ax,%ax
f01214f5:	66 90                	xchg   %ax,%ax
f01214f7:	66 90                	xchg   %ax,%ax
f01214f9:	66 90                	xchg   %ax,%ax
f01214fb:	66 90                	xchg   %ax,%ax
f01214fd:	66 90                	xchg   %ax,%ax
f01214ff:	66 90                	xchg   %ax,%ax
f0121501:	66 90                	xchg   %ax,%ax
f0121503:	66 90                	xchg   %ax,%ax
f0121505:	66 90                	xchg   %ax,%ax
f0121507:	66 90                	xchg   %ax,%ax
f0121509:	66 90                	xchg   %ax,%ax
f012150b:	66 90                	xchg   %ax,%ax
f012150d:	66 90                	xchg   %ax,%ax
f012150f:	66 90                	xchg   %ax,%ax
f0121511:	66 90                	xchg   %ax,%ax
f0121513:	66 90                	xchg   %ax,%ax
f0121515:	66 90                	xchg   %ax,%ax
f0121517:	66 90                	xchg   %ax,%ax
f0121519:	66 90                	xchg   %ax,%ax
f012151b:	66 90                	xchg   %ax,%ax
f012151d:	66 90                	xchg   %ax,%ax
f012151f:	66 90                	xchg   %ax,%ax
f0121521:	66 90                	xchg   %ax,%ax
f0121523:	66 90                	xchg   %ax,%ax
f0121525:	66 90                	xchg   %ax,%ax
f0121527:	66 90                	xchg   %ax,%ax
f0121529:	66 90                	xchg   %ax,%ax
f012152b:	66 90                	xchg   %ax,%ax
f012152d:	66 90                	xchg   %ax,%ax
f012152f:	66 90                	xchg   %ax,%ax
f0121531:	66 90                	xchg   %ax,%ax
f0121533:	66 90                	xchg   %ax,%ax
f0121535:	66 90                	xchg   %ax,%ax
f0121537:	66 90                	xchg   %ax,%ax
f0121539:	66 90                	xchg   %ax,%ax
f012153b:	66 90                	xchg   %ax,%ax
f012153d:	66 90                	xchg   %ax,%ax
f012153f:	66 90                	xchg   %ax,%ax
f0121541:	66 90                	xchg   %ax,%ax
f0121543:	66 90                	xchg   %ax,%ax
f0121545:	66 90                	xchg   %ax,%ax
f0121547:	66 90                	xchg   %ax,%ax
f0121549:	66 90                	xchg   %ax,%ax
f012154b:	66 90                	xchg   %ax,%ax
f012154d:	66 90                	xchg   %ax,%ax
f012154f:	66 90                	xchg   %ax,%ax
f0121551:	66 90                	xchg   %ax,%ax
f0121553:	66 90                	xchg   %ax,%ax
f0121555:	66 90                	xchg   %ax,%ax
f0121557:	66 90                	xchg   %ax,%ax
f0121559:	66 90                	xchg   %ax,%ax
f012155b:	66 90                	xchg   %ax,%ax
f012155d:	66 90                	xchg   %ax,%ax
f012155f:	66 90                	xchg   %ax,%ax
f0121561:	66 90                	xchg   %ax,%ax
f0121563:	66 90                	xchg   %ax,%ax
f0121565:	66 90                	xchg   %ax,%ax
f0121567:	66 90                	xchg   %ax,%ax
f0121569:	66 90                	xchg   %ax,%ax
f012156b:	66 90                	xchg   %ax,%ax
f012156d:	66 90                	xchg   %ax,%ax
f012156f:	66 90                	xchg   %ax,%ax
f0121571:	66 90                	xchg   %ax,%ax
f0121573:	66 90                	xchg   %ax,%ax
f0121575:	66 90                	xchg   %ax,%ax
f0121577:	66 90                	xchg   %ax,%ax
f0121579:	66 90                	xchg   %ax,%ax
f012157b:	66 90                	xchg   %ax,%ax
f012157d:	66 90                	xchg   %ax,%ax
f012157f:	66 90                	xchg   %ax,%ax
f0121581:	66 90                	xchg   %ax,%ax
f0121583:	66 90                	xchg   %ax,%ax
f0121585:	66 90                	xchg   %ax,%ax
f0121587:	66 90                	xchg   %ax,%ax
f0121589:	66 90                	xchg   %ax,%ax
f012158b:	66 90                	xchg   %ax,%ax
f012158d:	66 90                	xchg   %ax,%ax
f012158f:	66 90                	xchg   %ax,%ax
f0121591:	66 90                	xchg   %ax,%ax
f0121593:	66 90                	xchg   %ax,%ax
f0121595:	66 90                	xchg   %ax,%ax
f0121597:	66 90                	xchg   %ax,%ax
f0121599:	66 90                	xchg   %ax,%ax
f012159b:	66 90                	xchg   %ax,%ax
f012159d:	66 90                	xchg   %ax,%ax
f012159f:	66 90                	xchg   %ax,%ax
f01215a1:	66 90                	xchg   %ax,%ax
f01215a3:	66 90                	xchg   %ax,%ax
f01215a5:	66 90                	xchg   %ax,%ax
f01215a7:	66 90                	xchg   %ax,%ax
f01215a9:	66 90                	xchg   %ax,%ax
f01215ab:	66 90                	xchg   %ax,%ax
f01215ad:	66 90                	xchg   %ax,%ax
f01215af:	66 90                	xchg   %ax,%ax
f01215b1:	66 90                	xchg   %ax,%ax
f01215b3:	66 90                	xchg   %ax,%ax
f01215b5:	66 90                	xchg   %ax,%ax
f01215b7:	66 90                	xchg   %ax,%ax
f01215b9:	66 90                	xchg   %ax,%ax
f01215bb:	66 90                	xchg   %ax,%ax
f01215bd:	66 90                	xchg   %ax,%ax
f01215bf:	66 90                	xchg   %ax,%ax
f01215c1:	66 90                	xchg   %ax,%ax
f01215c3:	66 90                	xchg   %ax,%ax
f01215c5:	66 90                	xchg   %ax,%ax
f01215c7:	66 90                	xchg   %ax,%ax
f01215c9:	66 90                	xchg   %ax,%ax
f01215cb:	66 90                	xchg   %ax,%ax
f01215cd:	66 90                	xchg   %ax,%ax
f01215cf:	66 90                	xchg   %ax,%ax
f01215d1:	66 90                	xchg   %ax,%ax
f01215d3:	66 90                	xchg   %ax,%ax
f01215d5:	66 90                	xchg   %ax,%ax
f01215d7:	66 90                	xchg   %ax,%ax
f01215d9:	66 90                	xchg   %ax,%ax
f01215db:	66 90                	xchg   %ax,%ax
f01215dd:	66 90                	xchg   %ax,%ax
f01215df:	66 90                	xchg   %ax,%ax
f01215e1:	66 90                	xchg   %ax,%ax
f01215e3:	66 90                	xchg   %ax,%ax
f01215e5:	66 90                	xchg   %ax,%ax
f01215e7:	66 90                	xchg   %ax,%ax
f01215e9:	66 90                	xchg   %ax,%ax
f01215eb:	66 90                	xchg   %ax,%ax
f01215ed:	66 90                	xchg   %ax,%ax
f01215ef:	66 90                	xchg   %ax,%ax
f01215f1:	66 90                	xchg   %ax,%ax
f01215f3:	66 90                	xchg   %ax,%ax
f01215f5:	66 90                	xchg   %ax,%ax
f01215f7:	66 90                	xchg   %ax,%ax
f01215f9:	66 90                	xchg   %ax,%ax
f01215fb:	66 90                	xchg   %ax,%ax
f01215fd:	66 90                	xchg   %ax,%ax
f01215ff:	66 90                	xchg   %ax,%ax
f0121601:	66 90                	xchg   %ax,%ax
f0121603:	66 90                	xchg   %ax,%ax
f0121605:	66 90                	xchg   %ax,%ax
f0121607:	66 90                	xchg   %ax,%ax
f0121609:	66 90                	xchg   %ax,%ax
f012160b:	66 90                	xchg   %ax,%ax
f012160d:	66 90                	xchg   %ax,%ax
f012160f:	66 90                	xchg   %ax,%ax
f0121611:	66 90                	xchg   %ax,%ax
f0121613:	66 90                	xchg   %ax,%ax
f0121615:	66 90                	xchg   %ax,%ax
f0121617:	66 90                	xchg   %ax,%ax
f0121619:	66 90                	xchg   %ax,%ax
f012161b:	66 90                	xchg   %ax,%ax
f012161d:	66 90                	xchg   %ax,%ax
f012161f:	66 90                	xchg   %ax,%ax
f0121621:	66 90                	xchg   %ax,%ax
f0121623:	66 90                	xchg   %ax,%ax
f0121625:	66 90                	xchg   %ax,%ax
f0121627:	66 90                	xchg   %ax,%ax
f0121629:	66 90                	xchg   %ax,%ax
f012162b:	66 90                	xchg   %ax,%ax
f012162d:	66 90                	xchg   %ax,%ax
f012162f:	66 90                	xchg   %ax,%ax
f0121631:	66 90                	xchg   %ax,%ax
f0121633:	66 90                	xchg   %ax,%ax
f0121635:	66 90                	xchg   %ax,%ax
f0121637:	66 90                	xchg   %ax,%ax
f0121639:	66 90                	xchg   %ax,%ax
f012163b:	66 90                	xchg   %ax,%ax
f012163d:	66 90                	xchg   %ax,%ax
f012163f:	66 90                	xchg   %ax,%ax
f0121641:	66 90                	xchg   %ax,%ax
f0121643:	66 90                	xchg   %ax,%ax
f0121645:	66 90                	xchg   %ax,%ax
f0121647:	66 90                	xchg   %ax,%ax
f0121649:	66 90                	xchg   %ax,%ax
f012164b:	66 90                	xchg   %ax,%ax
f012164d:	66 90                	xchg   %ax,%ax
f012164f:	66 90                	xchg   %ax,%ax
f0121651:	66 90                	xchg   %ax,%ax
f0121653:	66 90                	xchg   %ax,%ax
f0121655:	66 90                	xchg   %ax,%ax
f0121657:	66 90                	xchg   %ax,%ax
f0121659:	66 90                	xchg   %ax,%ax
f012165b:	66 90                	xchg   %ax,%ax
f012165d:	66 90                	xchg   %ax,%ax
f012165f:	66 90                	xchg   %ax,%ax
f0121661:	66 90                	xchg   %ax,%ax
f0121663:	66 90                	xchg   %ax,%ax
f0121665:	66 90                	xchg   %ax,%ax
f0121667:	66 90                	xchg   %ax,%ax
f0121669:	66 90                	xchg   %ax,%ax
f012166b:	66 90                	xchg   %ax,%ax
f012166d:	66 90                	xchg   %ax,%ax
f012166f:	66 90                	xchg   %ax,%ax
f0121671:	66 90                	xchg   %ax,%ax
f0121673:	66 90                	xchg   %ax,%ax
f0121675:	66 90                	xchg   %ax,%ax
f0121677:	66 90                	xchg   %ax,%ax
f0121679:	66 90                	xchg   %ax,%ax
f012167b:	66 90                	xchg   %ax,%ax
f012167d:	66 90                	xchg   %ax,%ax
f012167f:	66 90                	xchg   %ax,%ax
f0121681:	66 90                	xchg   %ax,%ax
f0121683:	66 90                	xchg   %ax,%ax
f0121685:	66 90                	xchg   %ax,%ax
f0121687:	66 90                	xchg   %ax,%ax
f0121689:	66 90                	xchg   %ax,%ax
f012168b:	66 90                	xchg   %ax,%ax
f012168d:	66 90                	xchg   %ax,%ax
f012168f:	66 90                	xchg   %ax,%ax
f0121691:	66 90                	xchg   %ax,%ax
f0121693:	66 90                	xchg   %ax,%ax
f0121695:	66 90                	xchg   %ax,%ax
f0121697:	66 90                	xchg   %ax,%ax
f0121699:	66 90                	xchg   %ax,%ax
f012169b:	66 90                	xchg   %ax,%ax
f012169d:	66 90                	xchg   %ax,%ax
f012169f:	66 90                	xchg   %ax,%ax
f01216a1:	66 90                	xchg   %ax,%ax
f01216a3:	66 90                	xchg   %ax,%ax
f01216a5:	66 90                	xchg   %ax,%ax
f01216a7:	66 90                	xchg   %ax,%ax
f01216a9:	66 90                	xchg   %ax,%ax
f01216ab:	66 90                	xchg   %ax,%ax
f01216ad:	66 90                	xchg   %ax,%ax
f01216af:	66 90                	xchg   %ax,%ax
f01216b1:	66 90                	xchg   %ax,%ax
f01216b3:	66 90                	xchg   %ax,%ax
f01216b5:	66 90                	xchg   %ax,%ax
f01216b7:	66 90                	xchg   %ax,%ax
f01216b9:	66 90                	xchg   %ax,%ax
f01216bb:	66 90                	xchg   %ax,%ax
f01216bd:	66 90                	xchg   %ax,%ax
f01216bf:	66 90                	xchg   %ax,%ax
f01216c1:	66 90                	xchg   %ax,%ax
f01216c3:	66 90                	xchg   %ax,%ax
f01216c5:	66 90                	xchg   %ax,%ax
f01216c7:	66 90                	xchg   %ax,%ax
f01216c9:	66 90                	xchg   %ax,%ax
f01216cb:	66 90                	xchg   %ax,%ax
f01216cd:	66 90                	xchg   %ax,%ax
f01216cf:	66 90                	xchg   %ax,%ax
f01216d1:	66 90                	xchg   %ax,%ax
f01216d3:	66 90                	xchg   %ax,%ax
f01216d5:	66 90                	xchg   %ax,%ax
f01216d7:	66 90                	xchg   %ax,%ax
f01216d9:	66 90                	xchg   %ax,%ax
f01216db:	66 90                	xchg   %ax,%ax
f01216dd:	66 90                	xchg   %ax,%ax
f01216df:	66 90                	xchg   %ax,%ax
f01216e1:	66 90                	xchg   %ax,%ax
f01216e3:	66 90                	xchg   %ax,%ax
f01216e5:	66 90                	xchg   %ax,%ax
f01216e7:	66 90                	xchg   %ax,%ax
f01216e9:	66 90                	xchg   %ax,%ax
f01216eb:	66 90                	xchg   %ax,%ax
f01216ed:	66 90                	xchg   %ax,%ax
f01216ef:	66 90                	xchg   %ax,%ax
f01216f1:	66 90                	xchg   %ax,%ax
f01216f3:	66 90                	xchg   %ax,%ax
f01216f5:	66 90                	xchg   %ax,%ax
f01216f7:	66 90                	xchg   %ax,%ax
f01216f9:	66 90                	xchg   %ax,%ax
f01216fb:	66 90                	xchg   %ax,%ax
f01216fd:	66 90                	xchg   %ax,%ax
f01216ff:	66 90                	xchg   %ax,%ax
f0121701:	66 90                	xchg   %ax,%ax
f0121703:	66 90                	xchg   %ax,%ax
f0121705:	66 90                	xchg   %ax,%ax
f0121707:	66 90                	xchg   %ax,%ax
f0121709:	66 90                	xchg   %ax,%ax
f012170b:	66 90                	xchg   %ax,%ax
f012170d:	66 90                	xchg   %ax,%ax
f012170f:	66 90                	xchg   %ax,%ax
f0121711:	66 90                	xchg   %ax,%ax
f0121713:	66 90                	xchg   %ax,%ax
f0121715:	66 90                	xchg   %ax,%ax
f0121717:	66 90                	xchg   %ax,%ax
f0121719:	66 90                	xchg   %ax,%ax
f012171b:	66 90                	xchg   %ax,%ax
f012171d:	66 90                	xchg   %ax,%ax
f012171f:	66 90                	xchg   %ax,%ax
f0121721:	66 90                	xchg   %ax,%ax
f0121723:	66 90                	xchg   %ax,%ax
f0121725:	66 90                	xchg   %ax,%ax
f0121727:	66 90                	xchg   %ax,%ax
f0121729:	66 90                	xchg   %ax,%ax
f012172b:	66 90                	xchg   %ax,%ax
f012172d:	66 90                	xchg   %ax,%ax
f012172f:	66 90                	xchg   %ax,%ax
f0121731:	66 90                	xchg   %ax,%ax
f0121733:	66 90                	xchg   %ax,%ax
f0121735:	66 90                	xchg   %ax,%ax
f0121737:	66 90                	xchg   %ax,%ax
f0121739:	66 90                	xchg   %ax,%ax
f012173b:	66 90                	xchg   %ax,%ax
f012173d:	66 90                	xchg   %ax,%ax
f012173f:	66 90                	xchg   %ax,%ax
f0121741:	66 90                	xchg   %ax,%ax
f0121743:	66 90                	xchg   %ax,%ax
f0121745:	66 90                	xchg   %ax,%ax
f0121747:	66 90                	xchg   %ax,%ax
f0121749:	66 90                	xchg   %ax,%ax
f012174b:	66 90                	xchg   %ax,%ax
f012174d:	66 90                	xchg   %ax,%ax
f012174f:	66 90                	xchg   %ax,%ax
f0121751:	66 90                	xchg   %ax,%ax
f0121753:	66 90                	xchg   %ax,%ax
f0121755:	66 90                	xchg   %ax,%ax
f0121757:	66 90                	xchg   %ax,%ax
f0121759:	66 90                	xchg   %ax,%ax
f012175b:	66 90                	xchg   %ax,%ax
f012175d:	66 90                	xchg   %ax,%ax
f012175f:	66 90                	xchg   %ax,%ax
f0121761:	66 90                	xchg   %ax,%ax
f0121763:	66 90                	xchg   %ax,%ax
f0121765:	66 90                	xchg   %ax,%ax
f0121767:	66 90                	xchg   %ax,%ax
f0121769:	66 90                	xchg   %ax,%ax
f012176b:	66 90                	xchg   %ax,%ax
f012176d:	66 90                	xchg   %ax,%ax
f012176f:	66 90                	xchg   %ax,%ax
f0121771:	66 90                	xchg   %ax,%ax
f0121773:	66 90                	xchg   %ax,%ax
f0121775:	66 90                	xchg   %ax,%ax
f0121777:	66 90                	xchg   %ax,%ax
f0121779:	66 90                	xchg   %ax,%ax
f012177b:	66 90                	xchg   %ax,%ax
f012177d:	66 90                	xchg   %ax,%ax
f012177f:	66 90                	xchg   %ax,%ax
f0121781:	66 90                	xchg   %ax,%ax
f0121783:	66 90                	xchg   %ax,%ax
f0121785:	66 90                	xchg   %ax,%ax
f0121787:	66 90                	xchg   %ax,%ax
f0121789:	66 90                	xchg   %ax,%ax
f012178b:	66 90                	xchg   %ax,%ax
f012178d:	66 90                	xchg   %ax,%ax
f012178f:	66 90                	xchg   %ax,%ax
f0121791:	66 90                	xchg   %ax,%ax
f0121793:	66 90                	xchg   %ax,%ax
f0121795:	66 90                	xchg   %ax,%ax
f0121797:	66 90                	xchg   %ax,%ax
f0121799:	66 90                	xchg   %ax,%ax
f012179b:	66 90                	xchg   %ax,%ax
f012179d:	66 90                	xchg   %ax,%ax
f012179f:	66 90                	xchg   %ax,%ax
f01217a1:	66 90                	xchg   %ax,%ax
f01217a3:	66 90                	xchg   %ax,%ax
f01217a5:	66 90                	xchg   %ax,%ax
f01217a7:	66 90                	xchg   %ax,%ax
f01217a9:	66 90                	xchg   %ax,%ax
f01217ab:	66 90                	xchg   %ax,%ax
f01217ad:	66 90                	xchg   %ax,%ax
f01217af:	66 90                	xchg   %ax,%ax
f01217b1:	66 90                	xchg   %ax,%ax
f01217b3:	66 90                	xchg   %ax,%ax
f01217b5:	66 90                	xchg   %ax,%ax
f01217b7:	66 90                	xchg   %ax,%ax
f01217b9:	66 90                	xchg   %ax,%ax
f01217bb:	66 90                	xchg   %ax,%ax
f01217bd:	66 90                	xchg   %ax,%ax
f01217bf:	66 90                	xchg   %ax,%ax
f01217c1:	66 90                	xchg   %ax,%ax
f01217c3:	66 90                	xchg   %ax,%ax
f01217c5:	66 90                	xchg   %ax,%ax
f01217c7:	66 90                	xchg   %ax,%ax
f01217c9:	66 90                	xchg   %ax,%ax
f01217cb:	66 90                	xchg   %ax,%ax
f01217cd:	66 90                	xchg   %ax,%ax
f01217cf:	66 90                	xchg   %ax,%ax
f01217d1:	66 90                	xchg   %ax,%ax
f01217d3:	66 90                	xchg   %ax,%ax
f01217d5:	66 90                	xchg   %ax,%ax
f01217d7:	66 90                	xchg   %ax,%ax
f01217d9:	66 90                	xchg   %ax,%ax
f01217db:	66 90                	xchg   %ax,%ax
f01217dd:	66 90                	xchg   %ax,%ax
f01217df:	66 90                	xchg   %ax,%ax
f01217e1:	66 90                	xchg   %ax,%ax
f01217e3:	66 90                	xchg   %ax,%ax
f01217e5:	66 90                	xchg   %ax,%ax
f01217e7:	66 90                	xchg   %ax,%ax
f01217e9:	66 90                	xchg   %ax,%ax
f01217eb:	66 90                	xchg   %ax,%ax
f01217ed:	66 90                	xchg   %ax,%ax
f01217ef:	66 90                	xchg   %ax,%ax
f01217f1:	66 90                	xchg   %ax,%ax
f01217f3:	66 90                	xchg   %ax,%ax
f01217f5:	66 90                	xchg   %ax,%ax
f01217f7:	66 90                	xchg   %ax,%ax
f01217f9:	66 90                	xchg   %ax,%ax
f01217fb:	66 90                	xchg   %ax,%ax
f01217fd:	66 90                	xchg   %ax,%ax
f01217ff:	66 90                	xchg   %ax,%ax
f0121801:	66 90                	xchg   %ax,%ax
f0121803:	66 90                	xchg   %ax,%ax
f0121805:	66 90                	xchg   %ax,%ax
f0121807:	66 90                	xchg   %ax,%ax
f0121809:	66 90                	xchg   %ax,%ax
f012180b:	66 90                	xchg   %ax,%ax
f012180d:	66 90                	xchg   %ax,%ax
f012180f:	66 90                	xchg   %ax,%ax
f0121811:	66 90                	xchg   %ax,%ax
f0121813:	66 90                	xchg   %ax,%ax
f0121815:	66 90                	xchg   %ax,%ax
f0121817:	66 90                	xchg   %ax,%ax
f0121819:	66 90                	xchg   %ax,%ax
f012181b:	66 90                	xchg   %ax,%ax
f012181d:	66 90                	xchg   %ax,%ax
f012181f:	66 90                	xchg   %ax,%ax
f0121821:	66 90                	xchg   %ax,%ax
f0121823:	66 90                	xchg   %ax,%ax
f0121825:	66 90                	xchg   %ax,%ax
f0121827:	66 90                	xchg   %ax,%ax
f0121829:	66 90                	xchg   %ax,%ax
f012182b:	66 90                	xchg   %ax,%ax
f012182d:	66 90                	xchg   %ax,%ax
f012182f:	66 90                	xchg   %ax,%ax
f0121831:	66 90                	xchg   %ax,%ax
f0121833:	66 90                	xchg   %ax,%ax
f0121835:	66 90                	xchg   %ax,%ax
f0121837:	66 90                	xchg   %ax,%ax
f0121839:	66 90                	xchg   %ax,%ax
f012183b:	66 90                	xchg   %ax,%ax
f012183d:	66 90                	xchg   %ax,%ax
f012183f:	66 90                	xchg   %ax,%ax
f0121841:	66 90                	xchg   %ax,%ax
f0121843:	66 90                	xchg   %ax,%ax
f0121845:	66 90                	xchg   %ax,%ax
f0121847:	66 90                	xchg   %ax,%ax
f0121849:	66 90                	xchg   %ax,%ax
f012184b:	66 90                	xchg   %ax,%ax
f012184d:	66 90                	xchg   %ax,%ax
f012184f:	66 90                	xchg   %ax,%ax
f0121851:	66 90                	xchg   %ax,%ax
f0121853:	66 90                	xchg   %ax,%ax
f0121855:	66 90                	xchg   %ax,%ax
f0121857:	66 90                	xchg   %ax,%ax
f0121859:	66 90                	xchg   %ax,%ax
f012185b:	66 90                	xchg   %ax,%ax
f012185d:	66 90                	xchg   %ax,%ax
f012185f:	66 90                	xchg   %ax,%ax
f0121861:	66 90                	xchg   %ax,%ax
f0121863:	66 90                	xchg   %ax,%ax
f0121865:	66 90                	xchg   %ax,%ax
f0121867:	66 90                	xchg   %ax,%ax
f0121869:	66 90                	xchg   %ax,%ax
f012186b:	66 90                	xchg   %ax,%ax
f012186d:	66 90                	xchg   %ax,%ax
f012186f:	66 90                	xchg   %ax,%ax
f0121871:	66 90                	xchg   %ax,%ax
f0121873:	66 90                	xchg   %ax,%ax
f0121875:	66 90                	xchg   %ax,%ax
f0121877:	66 90                	xchg   %ax,%ax
f0121879:	66 90                	xchg   %ax,%ax
f012187b:	66 90                	xchg   %ax,%ax
f012187d:	66 90                	xchg   %ax,%ax
f012187f:	66 90                	xchg   %ax,%ax
f0121881:	66 90                	xchg   %ax,%ax
f0121883:	66 90                	xchg   %ax,%ax
f0121885:	66 90                	xchg   %ax,%ax
f0121887:	66 90                	xchg   %ax,%ax
f0121889:	66 90                	xchg   %ax,%ax
f012188b:	66 90                	xchg   %ax,%ax
f012188d:	66 90                	xchg   %ax,%ax
f012188f:	66 90                	xchg   %ax,%ax
f0121891:	66 90                	xchg   %ax,%ax
f0121893:	66 90                	xchg   %ax,%ax
f0121895:	66 90                	xchg   %ax,%ax
f0121897:	66 90                	xchg   %ax,%ax
f0121899:	66 90                	xchg   %ax,%ax
f012189b:	66 90                	xchg   %ax,%ax
f012189d:	66 90                	xchg   %ax,%ax
f012189f:	66 90                	xchg   %ax,%ax
f01218a1:	66 90                	xchg   %ax,%ax
f01218a3:	66 90                	xchg   %ax,%ax
f01218a5:	66 90                	xchg   %ax,%ax
f01218a7:	66 90                	xchg   %ax,%ax
f01218a9:	66 90                	xchg   %ax,%ax
f01218ab:	66 90                	xchg   %ax,%ax
f01218ad:	66 90                	xchg   %ax,%ax
f01218af:	66 90                	xchg   %ax,%ax
f01218b1:	66 90                	xchg   %ax,%ax
f01218b3:	66 90                	xchg   %ax,%ax
f01218b5:	66 90                	xchg   %ax,%ax
f01218b7:	66 90                	xchg   %ax,%ax
f01218b9:	66 90                	xchg   %ax,%ax
f01218bb:	66 90                	xchg   %ax,%ax
f01218bd:	66 90                	xchg   %ax,%ax
f01218bf:	66 90                	xchg   %ax,%ax
f01218c1:	66 90                	xchg   %ax,%ax
f01218c3:	66 90                	xchg   %ax,%ax
f01218c5:	66 90                	xchg   %ax,%ax
f01218c7:	66 90                	xchg   %ax,%ax
f01218c9:	66 90                	xchg   %ax,%ax
f01218cb:	66 90                	xchg   %ax,%ax
f01218cd:	66 90                	xchg   %ax,%ax
f01218cf:	66 90                	xchg   %ax,%ax
f01218d1:	66 90                	xchg   %ax,%ax
f01218d3:	66 90                	xchg   %ax,%ax
f01218d5:	66 90                	xchg   %ax,%ax
f01218d7:	66 90                	xchg   %ax,%ax
f01218d9:	66 90                	xchg   %ax,%ax
f01218db:	66 90                	xchg   %ax,%ax
f01218dd:	66 90                	xchg   %ax,%ax
f01218df:	66 90                	xchg   %ax,%ax
f01218e1:	66 90                	xchg   %ax,%ax
f01218e3:	66 90                	xchg   %ax,%ax
f01218e5:	66 90                	xchg   %ax,%ax
f01218e7:	66 90                	xchg   %ax,%ax
f01218e9:	66 90                	xchg   %ax,%ax
f01218eb:	66 90                	xchg   %ax,%ax
f01218ed:	66 90                	xchg   %ax,%ax
f01218ef:	66 90                	xchg   %ax,%ax
f01218f1:	66 90                	xchg   %ax,%ax
f01218f3:	66 90                	xchg   %ax,%ax
f01218f5:	66 90                	xchg   %ax,%ax
f01218f7:	66 90                	xchg   %ax,%ax
f01218f9:	66 90                	xchg   %ax,%ax
f01218fb:	66 90                	xchg   %ax,%ax
f01218fd:	66 90                	xchg   %ax,%ax
f01218ff:	66 90                	xchg   %ax,%ax
f0121901:	66 90                	xchg   %ax,%ax
f0121903:	66 90                	xchg   %ax,%ax
f0121905:	66 90                	xchg   %ax,%ax
f0121907:	66 90                	xchg   %ax,%ax
f0121909:	66 90                	xchg   %ax,%ax
f012190b:	66 90                	xchg   %ax,%ax
f012190d:	66 90                	xchg   %ax,%ax
f012190f:	66 90                	xchg   %ax,%ax
f0121911:	66 90                	xchg   %ax,%ax
f0121913:	66 90                	xchg   %ax,%ax
f0121915:	66 90                	xchg   %ax,%ax
f0121917:	66 90                	xchg   %ax,%ax
f0121919:	66 90                	xchg   %ax,%ax
f012191b:	66 90                	xchg   %ax,%ax
f012191d:	66 90                	xchg   %ax,%ax
f012191f:	66 90                	xchg   %ax,%ax
f0121921:	66 90                	xchg   %ax,%ax
f0121923:	66 90                	xchg   %ax,%ax
f0121925:	66 90                	xchg   %ax,%ax
f0121927:	66 90                	xchg   %ax,%ax
f0121929:	66 90                	xchg   %ax,%ax
f012192b:	66 90                	xchg   %ax,%ax
f012192d:	66 90                	xchg   %ax,%ax
f012192f:	66 90                	xchg   %ax,%ax
f0121931:	66 90                	xchg   %ax,%ax
f0121933:	66 90                	xchg   %ax,%ax
f0121935:	66 90                	xchg   %ax,%ax
f0121937:	66 90                	xchg   %ax,%ax
f0121939:	66 90                	xchg   %ax,%ax
f012193b:	66 90                	xchg   %ax,%ax
f012193d:	66 90                	xchg   %ax,%ax
f012193f:	66 90                	xchg   %ax,%ax
f0121941:	66 90                	xchg   %ax,%ax
f0121943:	66 90                	xchg   %ax,%ax
f0121945:	66 90                	xchg   %ax,%ax
f0121947:	66 90                	xchg   %ax,%ax
f0121949:	66 90                	xchg   %ax,%ax
f012194b:	66 90                	xchg   %ax,%ax
f012194d:	66 90                	xchg   %ax,%ax
f012194f:	66 90                	xchg   %ax,%ax
f0121951:	66 90                	xchg   %ax,%ax
f0121953:	66 90                	xchg   %ax,%ax
f0121955:	66 90                	xchg   %ax,%ax
f0121957:	66 90                	xchg   %ax,%ax
f0121959:	66 90                	xchg   %ax,%ax
f012195b:	66 90                	xchg   %ax,%ax
f012195d:	66 90                	xchg   %ax,%ax
f012195f:	66 90                	xchg   %ax,%ax
f0121961:	66 90                	xchg   %ax,%ax
f0121963:	66 90                	xchg   %ax,%ax
f0121965:	66 90                	xchg   %ax,%ax
f0121967:	66 90                	xchg   %ax,%ax
f0121969:	66 90                	xchg   %ax,%ax
f012196b:	66 90                	xchg   %ax,%ax
f012196d:	66 90                	xchg   %ax,%ax
f012196f:	66 90                	xchg   %ax,%ax
f0121971:	66 90                	xchg   %ax,%ax
f0121973:	66 90                	xchg   %ax,%ax
f0121975:	66 90                	xchg   %ax,%ax
f0121977:	66 90                	xchg   %ax,%ax
f0121979:	66 90                	xchg   %ax,%ax
f012197b:	66 90                	xchg   %ax,%ax
f012197d:	66 90                	xchg   %ax,%ax
f012197f:	66 90                	xchg   %ax,%ax
f0121981:	66 90                	xchg   %ax,%ax
f0121983:	66 90                	xchg   %ax,%ax
f0121985:	66 90                	xchg   %ax,%ax
f0121987:	66 90                	xchg   %ax,%ax
f0121989:	66 90                	xchg   %ax,%ax
f012198b:	66 90                	xchg   %ax,%ax
f012198d:	66 90                	xchg   %ax,%ax
f012198f:	66 90                	xchg   %ax,%ax
f0121991:	66 90                	xchg   %ax,%ax
f0121993:	66 90                	xchg   %ax,%ax
f0121995:	66 90                	xchg   %ax,%ax
f0121997:	66 90                	xchg   %ax,%ax
f0121999:	66 90                	xchg   %ax,%ax
f012199b:	66 90                	xchg   %ax,%ax
f012199d:	66 90                	xchg   %ax,%ax
f012199f:	66 90                	xchg   %ax,%ax
f01219a1:	66 90                	xchg   %ax,%ax
f01219a3:	66 90                	xchg   %ax,%ax
f01219a5:	66 90                	xchg   %ax,%ax
f01219a7:	66 90                	xchg   %ax,%ax
f01219a9:	66 90                	xchg   %ax,%ax
f01219ab:	66 90                	xchg   %ax,%ax
f01219ad:	66 90                	xchg   %ax,%ax
f01219af:	66 90                	xchg   %ax,%ax
f01219b1:	66 90                	xchg   %ax,%ax
f01219b3:	66 90                	xchg   %ax,%ax
f01219b5:	66 90                	xchg   %ax,%ax
f01219b7:	66 90                	xchg   %ax,%ax
f01219b9:	66 90                	xchg   %ax,%ax
f01219bb:	66 90                	xchg   %ax,%ax
f01219bd:	66 90                	xchg   %ax,%ax
f01219bf:	66 90                	xchg   %ax,%ax
f01219c1:	66 90                	xchg   %ax,%ax
f01219c3:	66 90                	xchg   %ax,%ax
f01219c5:	66 90                	xchg   %ax,%ax
f01219c7:	66 90                	xchg   %ax,%ax
f01219c9:	66 90                	xchg   %ax,%ax
f01219cb:	66 90                	xchg   %ax,%ax
f01219cd:	66 90                	xchg   %ax,%ax
f01219cf:	66 90                	xchg   %ax,%ax
f01219d1:	66 90                	xchg   %ax,%ax
f01219d3:	66 90                	xchg   %ax,%ax
f01219d5:	66 90                	xchg   %ax,%ax
f01219d7:	66 90                	xchg   %ax,%ax
f01219d9:	66 90                	xchg   %ax,%ax
f01219db:	66 90                	xchg   %ax,%ax
f01219dd:	66 90                	xchg   %ax,%ax
f01219df:	66 90                	xchg   %ax,%ax
f01219e1:	66 90                	xchg   %ax,%ax
f01219e3:	66 90                	xchg   %ax,%ax
f01219e5:	66 90                	xchg   %ax,%ax
f01219e7:	66 90                	xchg   %ax,%ax
f01219e9:	66 90                	xchg   %ax,%ax
f01219eb:	66 90                	xchg   %ax,%ax
f01219ed:	66 90                	xchg   %ax,%ax
f01219ef:	66 90                	xchg   %ax,%ax
f01219f1:	66 90                	xchg   %ax,%ax
f01219f3:	66 90                	xchg   %ax,%ax
f01219f5:	66 90                	xchg   %ax,%ax
f01219f7:	66 90                	xchg   %ax,%ax
f01219f9:	66 90                	xchg   %ax,%ax
f01219fb:	66 90                	xchg   %ax,%ax
f01219fd:	66 90                	xchg   %ax,%ax
f01219ff:	66 90                	xchg   %ax,%ax
f0121a01:	66 90                	xchg   %ax,%ax
f0121a03:	66 90                	xchg   %ax,%ax
f0121a05:	66 90                	xchg   %ax,%ax
f0121a07:	66 90                	xchg   %ax,%ax
f0121a09:	66 90                	xchg   %ax,%ax
f0121a0b:	66 90                	xchg   %ax,%ax
f0121a0d:	66 90                	xchg   %ax,%ax
f0121a0f:	66 90                	xchg   %ax,%ax
f0121a11:	66 90                	xchg   %ax,%ax
f0121a13:	66 90                	xchg   %ax,%ax
f0121a15:	66 90                	xchg   %ax,%ax
f0121a17:	66 90                	xchg   %ax,%ax
f0121a19:	66 90                	xchg   %ax,%ax
f0121a1b:	66 90                	xchg   %ax,%ax
f0121a1d:	66 90                	xchg   %ax,%ax
f0121a1f:	66 90                	xchg   %ax,%ax
f0121a21:	66 90                	xchg   %ax,%ax
f0121a23:	66 90                	xchg   %ax,%ax
f0121a25:	66 90                	xchg   %ax,%ax
f0121a27:	66 90                	xchg   %ax,%ax
f0121a29:	66 90                	xchg   %ax,%ax
f0121a2b:	66 90                	xchg   %ax,%ax
f0121a2d:	66 90                	xchg   %ax,%ax
f0121a2f:	66 90                	xchg   %ax,%ax
f0121a31:	66 90                	xchg   %ax,%ax
f0121a33:	66 90                	xchg   %ax,%ax
f0121a35:	66 90                	xchg   %ax,%ax
f0121a37:	66 90                	xchg   %ax,%ax
f0121a39:	66 90                	xchg   %ax,%ax
f0121a3b:	66 90                	xchg   %ax,%ax
f0121a3d:	66 90                	xchg   %ax,%ax
f0121a3f:	66 90                	xchg   %ax,%ax
f0121a41:	66 90                	xchg   %ax,%ax
f0121a43:	66 90                	xchg   %ax,%ax
f0121a45:	66 90                	xchg   %ax,%ax
f0121a47:	66 90                	xchg   %ax,%ax
f0121a49:	66 90                	xchg   %ax,%ax
f0121a4b:	66 90                	xchg   %ax,%ax
f0121a4d:	66 90                	xchg   %ax,%ax
f0121a4f:	66 90                	xchg   %ax,%ax
f0121a51:	66 90                	xchg   %ax,%ax
f0121a53:	66 90                	xchg   %ax,%ax
f0121a55:	66 90                	xchg   %ax,%ax
f0121a57:	66 90                	xchg   %ax,%ax
f0121a59:	66 90                	xchg   %ax,%ax
f0121a5b:	66 90                	xchg   %ax,%ax
f0121a5d:	66 90                	xchg   %ax,%ax
f0121a5f:	66 90                	xchg   %ax,%ax
f0121a61:	66 90                	xchg   %ax,%ax
f0121a63:	66 90                	xchg   %ax,%ax
f0121a65:	66 90                	xchg   %ax,%ax
f0121a67:	66 90                	xchg   %ax,%ax
f0121a69:	66 90                	xchg   %ax,%ax
f0121a6b:	66 90                	xchg   %ax,%ax
f0121a6d:	66 90                	xchg   %ax,%ax
f0121a6f:	66 90                	xchg   %ax,%ax
f0121a71:	66 90                	xchg   %ax,%ax
f0121a73:	66 90                	xchg   %ax,%ax
f0121a75:	66 90                	xchg   %ax,%ax
f0121a77:	66 90                	xchg   %ax,%ax
f0121a79:	66 90                	xchg   %ax,%ax
f0121a7b:	66 90                	xchg   %ax,%ax
f0121a7d:	66 90                	xchg   %ax,%ax
f0121a7f:	66 90                	xchg   %ax,%ax
f0121a81:	66 90                	xchg   %ax,%ax
f0121a83:	66 90                	xchg   %ax,%ax
f0121a85:	66 90                	xchg   %ax,%ax
f0121a87:	66 90                	xchg   %ax,%ax
f0121a89:	66 90                	xchg   %ax,%ax
f0121a8b:	66 90                	xchg   %ax,%ax
f0121a8d:	66 90                	xchg   %ax,%ax
f0121a8f:	66 90                	xchg   %ax,%ax
f0121a91:	66 90                	xchg   %ax,%ax
f0121a93:	66 90                	xchg   %ax,%ax
f0121a95:	66 90                	xchg   %ax,%ax
f0121a97:	66 90                	xchg   %ax,%ax
f0121a99:	66 90                	xchg   %ax,%ax
f0121a9b:	66 90                	xchg   %ax,%ax
f0121a9d:	66 90                	xchg   %ax,%ax
f0121a9f:	66 90                	xchg   %ax,%ax
f0121aa1:	66 90                	xchg   %ax,%ax
f0121aa3:	66 90                	xchg   %ax,%ax
f0121aa5:	66 90                	xchg   %ax,%ax
f0121aa7:	66 90                	xchg   %ax,%ax
f0121aa9:	66 90                	xchg   %ax,%ax
f0121aab:	66 90                	xchg   %ax,%ax
f0121aad:	66 90                	xchg   %ax,%ax
f0121aaf:	66 90                	xchg   %ax,%ax
f0121ab1:	66 90                	xchg   %ax,%ax
f0121ab3:	66 90                	xchg   %ax,%ax
f0121ab5:	66 90                	xchg   %ax,%ax
f0121ab7:	66 90                	xchg   %ax,%ax
f0121ab9:	66 90                	xchg   %ax,%ax
f0121abb:	66 90                	xchg   %ax,%ax
f0121abd:	66 90                	xchg   %ax,%ax
f0121abf:	66 90                	xchg   %ax,%ax
f0121ac1:	66 90                	xchg   %ax,%ax
f0121ac3:	66 90                	xchg   %ax,%ax
f0121ac5:	66 90                	xchg   %ax,%ax
f0121ac7:	66 90                	xchg   %ax,%ax
f0121ac9:	66 90                	xchg   %ax,%ax
f0121acb:	66 90                	xchg   %ax,%ax
f0121acd:	66 90                	xchg   %ax,%ax
f0121acf:	66 90                	xchg   %ax,%ax
f0121ad1:	66 90                	xchg   %ax,%ax
f0121ad3:	66 90                	xchg   %ax,%ax
f0121ad5:	66 90                	xchg   %ax,%ax
f0121ad7:	66 90                	xchg   %ax,%ax
f0121ad9:	66 90                	xchg   %ax,%ax
f0121adb:	66 90                	xchg   %ax,%ax
f0121add:	66 90                	xchg   %ax,%ax
f0121adf:	66 90                	xchg   %ax,%ax
f0121ae1:	66 90                	xchg   %ax,%ax
f0121ae3:	66 90                	xchg   %ax,%ax
f0121ae5:	66 90                	xchg   %ax,%ax
f0121ae7:	66 90                	xchg   %ax,%ax
f0121ae9:	66 90                	xchg   %ax,%ax
f0121aeb:	66 90                	xchg   %ax,%ax
f0121aed:	66 90                	xchg   %ax,%ax
f0121aef:	66 90                	xchg   %ax,%ax
f0121af1:	66 90                	xchg   %ax,%ax
f0121af3:	66 90                	xchg   %ax,%ax
f0121af5:	66 90                	xchg   %ax,%ax
f0121af7:	66 90                	xchg   %ax,%ax
f0121af9:	66 90                	xchg   %ax,%ax
f0121afb:	66 90                	xchg   %ax,%ax
f0121afd:	66 90                	xchg   %ax,%ax
f0121aff:	66 90                	xchg   %ax,%ax
f0121b01:	66 90                	xchg   %ax,%ax
f0121b03:	66 90                	xchg   %ax,%ax
f0121b05:	66 90                	xchg   %ax,%ax
f0121b07:	66 90                	xchg   %ax,%ax
f0121b09:	66 90                	xchg   %ax,%ax
f0121b0b:	66 90                	xchg   %ax,%ax
f0121b0d:	66 90                	xchg   %ax,%ax
f0121b0f:	66 90                	xchg   %ax,%ax
f0121b11:	66 90                	xchg   %ax,%ax
f0121b13:	66 90                	xchg   %ax,%ax
f0121b15:	66 90                	xchg   %ax,%ax
f0121b17:	66 90                	xchg   %ax,%ax
f0121b19:	66 90                	xchg   %ax,%ax
f0121b1b:	66 90                	xchg   %ax,%ax
f0121b1d:	66 90                	xchg   %ax,%ax
f0121b1f:	66 90                	xchg   %ax,%ax
f0121b21:	66 90                	xchg   %ax,%ax
f0121b23:	66 90                	xchg   %ax,%ax
f0121b25:	66 90                	xchg   %ax,%ax
f0121b27:	66 90                	xchg   %ax,%ax
f0121b29:	66 90                	xchg   %ax,%ax
f0121b2b:	66 90                	xchg   %ax,%ax
f0121b2d:	66 90                	xchg   %ax,%ax
f0121b2f:	66 90                	xchg   %ax,%ax
f0121b31:	66 90                	xchg   %ax,%ax
f0121b33:	66 90                	xchg   %ax,%ax
f0121b35:	66 90                	xchg   %ax,%ax
f0121b37:	66 90                	xchg   %ax,%ax
f0121b39:	66 90                	xchg   %ax,%ax
f0121b3b:	66 90                	xchg   %ax,%ax
f0121b3d:	66 90                	xchg   %ax,%ax
f0121b3f:	66 90                	xchg   %ax,%ax
f0121b41:	66 90                	xchg   %ax,%ax
f0121b43:	66 90                	xchg   %ax,%ax
f0121b45:	66 90                	xchg   %ax,%ax
f0121b47:	66 90                	xchg   %ax,%ax
f0121b49:	66 90                	xchg   %ax,%ax
f0121b4b:	66 90                	xchg   %ax,%ax
f0121b4d:	66 90                	xchg   %ax,%ax
f0121b4f:	66 90                	xchg   %ax,%ax
f0121b51:	66 90                	xchg   %ax,%ax
f0121b53:	66 90                	xchg   %ax,%ax
f0121b55:	66 90                	xchg   %ax,%ax
f0121b57:	66 90                	xchg   %ax,%ax
f0121b59:	66 90                	xchg   %ax,%ax
f0121b5b:	66 90                	xchg   %ax,%ax
f0121b5d:	66 90                	xchg   %ax,%ax
f0121b5f:	66 90                	xchg   %ax,%ax
f0121b61:	66 90                	xchg   %ax,%ax
f0121b63:	66 90                	xchg   %ax,%ax
f0121b65:	66 90                	xchg   %ax,%ax
f0121b67:	66 90                	xchg   %ax,%ax
f0121b69:	66 90                	xchg   %ax,%ax
f0121b6b:	66 90                	xchg   %ax,%ax
f0121b6d:	66 90                	xchg   %ax,%ax
f0121b6f:	66 90                	xchg   %ax,%ax
f0121b71:	66 90                	xchg   %ax,%ax
f0121b73:	66 90                	xchg   %ax,%ax
f0121b75:	66 90                	xchg   %ax,%ax
f0121b77:	66 90                	xchg   %ax,%ax
f0121b79:	66 90                	xchg   %ax,%ax
f0121b7b:	66 90                	xchg   %ax,%ax
f0121b7d:	66 90                	xchg   %ax,%ax
f0121b7f:	66 90                	xchg   %ax,%ax
f0121b81:	66 90                	xchg   %ax,%ax
f0121b83:	66 90                	xchg   %ax,%ax
f0121b85:	66 90                	xchg   %ax,%ax
f0121b87:	66 90                	xchg   %ax,%ax
f0121b89:	66 90                	xchg   %ax,%ax
f0121b8b:	66 90                	xchg   %ax,%ax
f0121b8d:	66 90                	xchg   %ax,%ax
f0121b8f:	66 90                	xchg   %ax,%ax
f0121b91:	66 90                	xchg   %ax,%ax
f0121b93:	66 90                	xchg   %ax,%ax
f0121b95:	66 90                	xchg   %ax,%ax
f0121b97:	66 90                	xchg   %ax,%ax
f0121b99:	66 90                	xchg   %ax,%ax
f0121b9b:	66 90                	xchg   %ax,%ax
f0121b9d:	66 90                	xchg   %ax,%ax
f0121b9f:	66 90                	xchg   %ax,%ax
f0121ba1:	66 90                	xchg   %ax,%ax
f0121ba3:	66 90                	xchg   %ax,%ax
f0121ba5:	66 90                	xchg   %ax,%ax
f0121ba7:	66 90                	xchg   %ax,%ax
f0121ba9:	66 90                	xchg   %ax,%ax
f0121bab:	66 90                	xchg   %ax,%ax
f0121bad:	66 90                	xchg   %ax,%ax
f0121baf:	66 90                	xchg   %ax,%ax
f0121bb1:	66 90                	xchg   %ax,%ax
f0121bb3:	66 90                	xchg   %ax,%ax
f0121bb5:	66 90                	xchg   %ax,%ax
f0121bb7:	66 90                	xchg   %ax,%ax
f0121bb9:	66 90                	xchg   %ax,%ax
f0121bbb:	66 90                	xchg   %ax,%ax
f0121bbd:	66 90                	xchg   %ax,%ax
f0121bbf:	66 90                	xchg   %ax,%ax
f0121bc1:	66 90                	xchg   %ax,%ax
f0121bc3:	66 90                	xchg   %ax,%ax
f0121bc5:	66 90                	xchg   %ax,%ax
f0121bc7:	66 90                	xchg   %ax,%ax
f0121bc9:	66 90                	xchg   %ax,%ax
f0121bcb:	66 90                	xchg   %ax,%ax
f0121bcd:	66 90                	xchg   %ax,%ax
f0121bcf:	66 90                	xchg   %ax,%ax
f0121bd1:	66 90                	xchg   %ax,%ax
f0121bd3:	66 90                	xchg   %ax,%ax
f0121bd5:	66 90                	xchg   %ax,%ax
f0121bd7:	66 90                	xchg   %ax,%ax
f0121bd9:	66 90                	xchg   %ax,%ax
f0121bdb:	66 90                	xchg   %ax,%ax
f0121bdd:	66 90                	xchg   %ax,%ax
f0121bdf:	66 90                	xchg   %ax,%ax
f0121be1:	66 90                	xchg   %ax,%ax
f0121be3:	66 90                	xchg   %ax,%ax
f0121be5:	66 90                	xchg   %ax,%ax
f0121be7:	66 90                	xchg   %ax,%ax
f0121be9:	66 90                	xchg   %ax,%ax
f0121beb:	66 90                	xchg   %ax,%ax
f0121bed:	66 90                	xchg   %ax,%ax
f0121bef:	66 90                	xchg   %ax,%ax
f0121bf1:	66 90                	xchg   %ax,%ax
f0121bf3:	66 90                	xchg   %ax,%ax
f0121bf5:	66 90                	xchg   %ax,%ax
f0121bf7:	66 90                	xchg   %ax,%ax
f0121bf9:	66 90                	xchg   %ax,%ax
f0121bfb:	66 90                	xchg   %ax,%ax
f0121bfd:	66 90                	xchg   %ax,%ax
f0121bff:	66 90                	xchg   %ax,%ax
f0121c01:	66 90                	xchg   %ax,%ax
f0121c03:	66 90                	xchg   %ax,%ax
f0121c05:	66 90                	xchg   %ax,%ax
f0121c07:	66 90                	xchg   %ax,%ax
f0121c09:	66 90                	xchg   %ax,%ax
f0121c0b:	66 90                	xchg   %ax,%ax
f0121c0d:	66 90                	xchg   %ax,%ax
f0121c0f:	66 90                	xchg   %ax,%ax
f0121c11:	66 90                	xchg   %ax,%ax
f0121c13:	66 90                	xchg   %ax,%ax
f0121c15:	66 90                	xchg   %ax,%ax
f0121c17:	66 90                	xchg   %ax,%ax
f0121c19:	66 90                	xchg   %ax,%ax
f0121c1b:	66 90                	xchg   %ax,%ax
f0121c1d:	66 90                	xchg   %ax,%ax
f0121c1f:	66 90                	xchg   %ax,%ax
f0121c21:	66 90                	xchg   %ax,%ax
f0121c23:	66 90                	xchg   %ax,%ax
f0121c25:	66 90                	xchg   %ax,%ax
f0121c27:	66 90                	xchg   %ax,%ax
f0121c29:	66 90                	xchg   %ax,%ax
f0121c2b:	66 90                	xchg   %ax,%ax
f0121c2d:	66 90                	xchg   %ax,%ax
f0121c2f:	66 90                	xchg   %ax,%ax
f0121c31:	66 90                	xchg   %ax,%ax
f0121c33:	66 90                	xchg   %ax,%ax
f0121c35:	66 90                	xchg   %ax,%ax
f0121c37:	66 90                	xchg   %ax,%ax
f0121c39:	66 90                	xchg   %ax,%ax
f0121c3b:	66 90                	xchg   %ax,%ax
f0121c3d:	66 90                	xchg   %ax,%ax
f0121c3f:	66 90                	xchg   %ax,%ax
f0121c41:	66 90                	xchg   %ax,%ax
f0121c43:	66 90                	xchg   %ax,%ax
f0121c45:	66 90                	xchg   %ax,%ax
f0121c47:	66 90                	xchg   %ax,%ax
f0121c49:	66 90                	xchg   %ax,%ax
f0121c4b:	66 90                	xchg   %ax,%ax
f0121c4d:	66 90                	xchg   %ax,%ax
f0121c4f:	66 90                	xchg   %ax,%ax
f0121c51:	66 90                	xchg   %ax,%ax
f0121c53:	66 90                	xchg   %ax,%ax
f0121c55:	66 90                	xchg   %ax,%ax
f0121c57:	66 90                	xchg   %ax,%ax
f0121c59:	66 90                	xchg   %ax,%ax
f0121c5b:	66 90                	xchg   %ax,%ax
f0121c5d:	66 90                	xchg   %ax,%ax
f0121c5f:	66 90                	xchg   %ax,%ax
f0121c61:	66 90                	xchg   %ax,%ax
f0121c63:	66 90                	xchg   %ax,%ax
f0121c65:	66 90                	xchg   %ax,%ax
f0121c67:	66 90                	xchg   %ax,%ax
f0121c69:	66 90                	xchg   %ax,%ax
f0121c6b:	66 90                	xchg   %ax,%ax
f0121c6d:	66 90                	xchg   %ax,%ax
f0121c6f:	66 90                	xchg   %ax,%ax
f0121c71:	66 90                	xchg   %ax,%ax
f0121c73:	66 90                	xchg   %ax,%ax
f0121c75:	66 90                	xchg   %ax,%ax
f0121c77:	66 90                	xchg   %ax,%ax
f0121c79:	66 90                	xchg   %ax,%ax
f0121c7b:	66 90                	xchg   %ax,%ax
f0121c7d:	66 90                	xchg   %ax,%ax
f0121c7f:	66 90                	xchg   %ax,%ax
f0121c81:	66 90                	xchg   %ax,%ax
f0121c83:	66 90                	xchg   %ax,%ax
f0121c85:	66 90                	xchg   %ax,%ax
f0121c87:	66 90                	xchg   %ax,%ax
f0121c89:	66 90                	xchg   %ax,%ax
f0121c8b:	66 90                	xchg   %ax,%ax
f0121c8d:	66 90                	xchg   %ax,%ax
f0121c8f:	66 90                	xchg   %ax,%ax
f0121c91:	66 90                	xchg   %ax,%ax
f0121c93:	66 90                	xchg   %ax,%ax
f0121c95:	66 90                	xchg   %ax,%ax
f0121c97:	66 90                	xchg   %ax,%ax
f0121c99:	66 90                	xchg   %ax,%ax
f0121c9b:	66 90                	xchg   %ax,%ax
f0121c9d:	66 90                	xchg   %ax,%ax
f0121c9f:	66 90                	xchg   %ax,%ax
f0121ca1:	66 90                	xchg   %ax,%ax
f0121ca3:	66 90                	xchg   %ax,%ax
f0121ca5:	66 90                	xchg   %ax,%ax
f0121ca7:	66 90                	xchg   %ax,%ax
f0121ca9:	66 90                	xchg   %ax,%ax
f0121cab:	66 90                	xchg   %ax,%ax
f0121cad:	66 90                	xchg   %ax,%ax
f0121caf:	66 90                	xchg   %ax,%ax
f0121cb1:	66 90                	xchg   %ax,%ax
f0121cb3:	66 90                	xchg   %ax,%ax
f0121cb5:	66 90                	xchg   %ax,%ax
f0121cb7:	66 90                	xchg   %ax,%ax
f0121cb9:	66 90                	xchg   %ax,%ax
f0121cbb:	66 90                	xchg   %ax,%ax
f0121cbd:	66 90                	xchg   %ax,%ax
f0121cbf:	66 90                	xchg   %ax,%ax
f0121cc1:	66 90                	xchg   %ax,%ax
f0121cc3:	66 90                	xchg   %ax,%ax
f0121cc5:	66 90                	xchg   %ax,%ax
f0121cc7:	66 90                	xchg   %ax,%ax
f0121cc9:	66 90                	xchg   %ax,%ax
f0121ccb:	66 90                	xchg   %ax,%ax
f0121ccd:	66 90                	xchg   %ax,%ax
f0121ccf:	66 90                	xchg   %ax,%ax
f0121cd1:	66 90                	xchg   %ax,%ax
f0121cd3:	66 90                	xchg   %ax,%ax
f0121cd5:	66 90                	xchg   %ax,%ax
f0121cd7:	66 90                	xchg   %ax,%ax
f0121cd9:	66 90                	xchg   %ax,%ax
f0121cdb:	66 90                	xchg   %ax,%ax
f0121cdd:	66 90                	xchg   %ax,%ax
f0121cdf:	66 90                	xchg   %ax,%ax
f0121ce1:	66 90                	xchg   %ax,%ax
f0121ce3:	66 90                	xchg   %ax,%ax
f0121ce5:	66 90                	xchg   %ax,%ax
f0121ce7:	66 90                	xchg   %ax,%ax
f0121ce9:	66 90                	xchg   %ax,%ax
f0121ceb:	66 90                	xchg   %ax,%ax
f0121ced:	66 90                	xchg   %ax,%ax
f0121cef:	66 90                	xchg   %ax,%ax
f0121cf1:	66 90                	xchg   %ax,%ax
f0121cf3:	66 90                	xchg   %ax,%ax
f0121cf5:	66 90                	xchg   %ax,%ax
f0121cf7:	66 90                	xchg   %ax,%ax
f0121cf9:	66 90                	xchg   %ax,%ax
f0121cfb:	66 90                	xchg   %ax,%ax
f0121cfd:	66 90                	xchg   %ax,%ax
f0121cff:	66 90                	xchg   %ax,%ax
f0121d01:	66 90                	xchg   %ax,%ax
f0121d03:	66 90                	xchg   %ax,%ax
f0121d05:	66 90                	xchg   %ax,%ax
f0121d07:	66 90                	xchg   %ax,%ax
f0121d09:	66 90                	xchg   %ax,%ax
f0121d0b:	66 90                	xchg   %ax,%ax
f0121d0d:	66 90                	xchg   %ax,%ax
f0121d0f:	66 90                	xchg   %ax,%ax
f0121d11:	66 90                	xchg   %ax,%ax
f0121d13:	66 90                	xchg   %ax,%ax
f0121d15:	66 90                	xchg   %ax,%ax
f0121d17:	66 90                	xchg   %ax,%ax
f0121d19:	66 90                	xchg   %ax,%ax
f0121d1b:	66 90                	xchg   %ax,%ax
f0121d1d:	66 90                	xchg   %ax,%ax
f0121d1f:	66 90                	xchg   %ax,%ax
f0121d21:	66 90                	xchg   %ax,%ax
f0121d23:	66 90                	xchg   %ax,%ax
f0121d25:	66 90                	xchg   %ax,%ax
f0121d27:	66 90                	xchg   %ax,%ax
f0121d29:	66 90                	xchg   %ax,%ax
f0121d2b:	66 90                	xchg   %ax,%ax
f0121d2d:	66 90                	xchg   %ax,%ax
f0121d2f:	66 90                	xchg   %ax,%ax
f0121d31:	66 90                	xchg   %ax,%ax
f0121d33:	66 90                	xchg   %ax,%ax
f0121d35:	66 90                	xchg   %ax,%ax
f0121d37:	66 90                	xchg   %ax,%ax
f0121d39:	66 90                	xchg   %ax,%ax
f0121d3b:	66 90                	xchg   %ax,%ax
f0121d3d:	66 90                	xchg   %ax,%ax
f0121d3f:	66 90                	xchg   %ax,%ax
f0121d41:	66 90                	xchg   %ax,%ax
f0121d43:	66 90                	xchg   %ax,%ax
f0121d45:	66 90                	xchg   %ax,%ax
f0121d47:	66 90                	xchg   %ax,%ax
f0121d49:	66 90                	xchg   %ax,%ax
f0121d4b:	66 90                	xchg   %ax,%ax
f0121d4d:	66 90                	xchg   %ax,%ax
f0121d4f:	66 90                	xchg   %ax,%ax
f0121d51:	66 90                	xchg   %ax,%ax
f0121d53:	66 90                	xchg   %ax,%ax
f0121d55:	66 90                	xchg   %ax,%ax
f0121d57:	66 90                	xchg   %ax,%ax
f0121d59:	66 90                	xchg   %ax,%ax
f0121d5b:	66 90                	xchg   %ax,%ax
f0121d5d:	66 90                	xchg   %ax,%ax
f0121d5f:	66 90                	xchg   %ax,%ax
f0121d61:	66 90                	xchg   %ax,%ax
f0121d63:	66 90                	xchg   %ax,%ax
f0121d65:	66 90                	xchg   %ax,%ax
f0121d67:	66 90                	xchg   %ax,%ax
f0121d69:	66 90                	xchg   %ax,%ax
f0121d6b:	66 90                	xchg   %ax,%ax
f0121d6d:	66 90                	xchg   %ax,%ax
f0121d6f:	66 90                	xchg   %ax,%ax
f0121d71:	66 90                	xchg   %ax,%ax
f0121d73:	66 90                	xchg   %ax,%ax
f0121d75:	66 90                	xchg   %ax,%ax
f0121d77:	66 90                	xchg   %ax,%ax
f0121d79:	66 90                	xchg   %ax,%ax
f0121d7b:	66 90                	xchg   %ax,%ax
f0121d7d:	66 90                	xchg   %ax,%ax
f0121d7f:	66 90                	xchg   %ax,%ax
f0121d81:	66 90                	xchg   %ax,%ax
f0121d83:	66 90                	xchg   %ax,%ax
f0121d85:	66 90                	xchg   %ax,%ax
f0121d87:	66 90                	xchg   %ax,%ax
f0121d89:	66 90                	xchg   %ax,%ax
f0121d8b:	66 90                	xchg   %ax,%ax
f0121d8d:	66 90                	xchg   %ax,%ax
f0121d8f:	66 90                	xchg   %ax,%ax
f0121d91:	66 90                	xchg   %ax,%ax
f0121d93:	66 90                	xchg   %ax,%ax
f0121d95:	66 90                	xchg   %ax,%ax
f0121d97:	66 90                	xchg   %ax,%ax
f0121d99:	66 90                	xchg   %ax,%ax
f0121d9b:	66 90                	xchg   %ax,%ax
f0121d9d:	66 90                	xchg   %ax,%ax
f0121d9f:	66 90                	xchg   %ax,%ax
f0121da1:	66 90                	xchg   %ax,%ax
f0121da3:	66 90                	xchg   %ax,%ax
f0121da5:	66 90                	xchg   %ax,%ax
f0121da7:	66 90                	xchg   %ax,%ax
f0121da9:	66 90                	xchg   %ax,%ax
f0121dab:	66 90                	xchg   %ax,%ax
f0121dad:	66 90                	xchg   %ax,%ax
f0121daf:	66 90                	xchg   %ax,%ax
f0121db1:	66 90                	xchg   %ax,%ax
f0121db3:	66 90                	xchg   %ax,%ax
f0121db5:	66 90                	xchg   %ax,%ax
f0121db7:	66 90                	xchg   %ax,%ax
f0121db9:	66 90                	xchg   %ax,%ax
f0121dbb:	66 90                	xchg   %ax,%ax
f0121dbd:	66 90                	xchg   %ax,%ax
f0121dbf:	66 90                	xchg   %ax,%ax
f0121dc1:	66 90                	xchg   %ax,%ax
f0121dc3:	66 90                	xchg   %ax,%ax
f0121dc5:	66 90                	xchg   %ax,%ax
f0121dc7:	66 90                	xchg   %ax,%ax
f0121dc9:	66 90                	xchg   %ax,%ax
f0121dcb:	66 90                	xchg   %ax,%ax
f0121dcd:	66 90                	xchg   %ax,%ax
f0121dcf:	66 90                	xchg   %ax,%ax
f0121dd1:	66 90                	xchg   %ax,%ax
f0121dd3:	66 90                	xchg   %ax,%ax
f0121dd5:	66 90                	xchg   %ax,%ax
f0121dd7:	66 90                	xchg   %ax,%ax
f0121dd9:	66 90                	xchg   %ax,%ax
f0121ddb:	66 90                	xchg   %ax,%ax
f0121ddd:	66 90                	xchg   %ax,%ax
f0121ddf:	66 90                	xchg   %ax,%ax
f0121de1:	66 90                	xchg   %ax,%ax
f0121de3:	66 90                	xchg   %ax,%ax
f0121de5:	66 90                	xchg   %ax,%ax
f0121de7:	66 90                	xchg   %ax,%ax
f0121de9:	66 90                	xchg   %ax,%ax
f0121deb:	66 90                	xchg   %ax,%ax
f0121ded:	66 90                	xchg   %ax,%ax
f0121def:	66 90                	xchg   %ax,%ax
f0121df1:	66 90                	xchg   %ax,%ax
f0121df3:	66 90                	xchg   %ax,%ax
f0121df5:	66 90                	xchg   %ax,%ax
f0121df7:	66 90                	xchg   %ax,%ax
f0121df9:	66 90                	xchg   %ax,%ax
f0121dfb:	66 90                	xchg   %ax,%ax
f0121dfd:	66 90                	xchg   %ax,%ax
f0121dff:	66 90                	xchg   %ax,%ax
f0121e01:	66 90                	xchg   %ax,%ax
f0121e03:	66 90                	xchg   %ax,%ax
f0121e05:	66 90                	xchg   %ax,%ax
f0121e07:	66 90                	xchg   %ax,%ax
f0121e09:	66 90                	xchg   %ax,%ax
f0121e0b:	66 90                	xchg   %ax,%ax
f0121e0d:	66 90                	xchg   %ax,%ax
f0121e0f:	66 90                	xchg   %ax,%ax
f0121e11:	66 90                	xchg   %ax,%ax
f0121e13:	66 90                	xchg   %ax,%ax
f0121e15:	66 90                	xchg   %ax,%ax
f0121e17:	66 90                	xchg   %ax,%ax
f0121e19:	66 90                	xchg   %ax,%ax
f0121e1b:	66 90                	xchg   %ax,%ax
f0121e1d:	66 90                	xchg   %ax,%ax
f0121e1f:	66 90                	xchg   %ax,%ax
f0121e21:	66 90                	xchg   %ax,%ax
f0121e23:	66 90                	xchg   %ax,%ax
f0121e25:	66 90                	xchg   %ax,%ax
f0121e27:	66 90                	xchg   %ax,%ax
f0121e29:	66 90                	xchg   %ax,%ax
f0121e2b:	66 90                	xchg   %ax,%ax
f0121e2d:	66 90                	xchg   %ax,%ax
f0121e2f:	66 90                	xchg   %ax,%ax
f0121e31:	66 90                	xchg   %ax,%ax
f0121e33:	66 90                	xchg   %ax,%ax
f0121e35:	66 90                	xchg   %ax,%ax
f0121e37:	66 90                	xchg   %ax,%ax
f0121e39:	66 90                	xchg   %ax,%ax
f0121e3b:	66 90                	xchg   %ax,%ax
f0121e3d:	66 90                	xchg   %ax,%ax
f0121e3f:	66 90                	xchg   %ax,%ax
f0121e41:	66 90                	xchg   %ax,%ax
f0121e43:	66 90                	xchg   %ax,%ax
f0121e45:	66 90                	xchg   %ax,%ax
f0121e47:	66 90                	xchg   %ax,%ax
f0121e49:	66 90                	xchg   %ax,%ax
f0121e4b:	66 90                	xchg   %ax,%ax
f0121e4d:	66 90                	xchg   %ax,%ax
f0121e4f:	66 90                	xchg   %ax,%ax
f0121e51:	66 90                	xchg   %ax,%ax
f0121e53:	66 90                	xchg   %ax,%ax
f0121e55:	66 90                	xchg   %ax,%ax
f0121e57:	66 90                	xchg   %ax,%ax
f0121e59:	66 90                	xchg   %ax,%ax
f0121e5b:	66 90                	xchg   %ax,%ax
f0121e5d:	66 90                	xchg   %ax,%ax
f0121e5f:	66 90                	xchg   %ax,%ax
f0121e61:	66 90                	xchg   %ax,%ax
f0121e63:	66 90                	xchg   %ax,%ax
f0121e65:	66 90                	xchg   %ax,%ax
f0121e67:	66 90                	xchg   %ax,%ax
f0121e69:	66 90                	xchg   %ax,%ax
f0121e6b:	66 90                	xchg   %ax,%ax
f0121e6d:	66 90                	xchg   %ax,%ax
f0121e6f:	66 90                	xchg   %ax,%ax
f0121e71:	66 90                	xchg   %ax,%ax
f0121e73:	66 90                	xchg   %ax,%ax
f0121e75:	66 90                	xchg   %ax,%ax
f0121e77:	66 90                	xchg   %ax,%ax
f0121e79:	66 90                	xchg   %ax,%ax
f0121e7b:	66 90                	xchg   %ax,%ax
f0121e7d:	66 90                	xchg   %ax,%ax
f0121e7f:	66 90                	xchg   %ax,%ax
f0121e81:	66 90                	xchg   %ax,%ax
f0121e83:	66 90                	xchg   %ax,%ax
f0121e85:	66 90                	xchg   %ax,%ax
f0121e87:	66 90                	xchg   %ax,%ax
f0121e89:	66 90                	xchg   %ax,%ax
f0121e8b:	66 90                	xchg   %ax,%ax
f0121e8d:	66 90                	xchg   %ax,%ax
f0121e8f:	66 90                	xchg   %ax,%ax
f0121e91:	66 90                	xchg   %ax,%ax
f0121e93:	66 90                	xchg   %ax,%ax
f0121e95:	66 90                	xchg   %ax,%ax
f0121e97:	66 90                	xchg   %ax,%ax
f0121e99:	66 90                	xchg   %ax,%ax
f0121e9b:	66 90                	xchg   %ax,%ax
f0121e9d:	66 90                	xchg   %ax,%ax
f0121e9f:	66 90                	xchg   %ax,%ax
f0121ea1:	66 90                	xchg   %ax,%ax
f0121ea3:	66 90                	xchg   %ax,%ax
f0121ea5:	66 90                	xchg   %ax,%ax
f0121ea7:	66 90                	xchg   %ax,%ax
f0121ea9:	66 90                	xchg   %ax,%ax
f0121eab:	66 90                	xchg   %ax,%ax
f0121ead:	66 90                	xchg   %ax,%ax
f0121eaf:	66 90                	xchg   %ax,%ax
f0121eb1:	66 90                	xchg   %ax,%ax
f0121eb3:	66 90                	xchg   %ax,%ax
f0121eb5:	66 90                	xchg   %ax,%ax
f0121eb7:	66 90                	xchg   %ax,%ax
f0121eb9:	66 90                	xchg   %ax,%ax
f0121ebb:	66 90                	xchg   %ax,%ax
f0121ebd:	66 90                	xchg   %ax,%ax
f0121ebf:	66 90                	xchg   %ax,%ax
f0121ec1:	66 90                	xchg   %ax,%ax
f0121ec3:	66 90                	xchg   %ax,%ax
f0121ec5:	66 90                	xchg   %ax,%ax
f0121ec7:	66 90                	xchg   %ax,%ax
f0121ec9:	66 90                	xchg   %ax,%ax
f0121ecb:	66 90                	xchg   %ax,%ax
f0121ecd:	66 90                	xchg   %ax,%ax
f0121ecf:	66 90                	xchg   %ax,%ax
f0121ed1:	66 90                	xchg   %ax,%ax
f0121ed3:	66 90                	xchg   %ax,%ax
f0121ed5:	66 90                	xchg   %ax,%ax
f0121ed7:	66 90                	xchg   %ax,%ax
f0121ed9:	66 90                	xchg   %ax,%ax
f0121edb:	66 90                	xchg   %ax,%ax
f0121edd:	66 90                	xchg   %ax,%ax
f0121edf:	66 90                	xchg   %ax,%ax
f0121ee1:	66 90                	xchg   %ax,%ax
f0121ee3:	66 90                	xchg   %ax,%ax
f0121ee5:	66 90                	xchg   %ax,%ax
f0121ee7:	66 90                	xchg   %ax,%ax
f0121ee9:	66 90                	xchg   %ax,%ax
f0121eeb:	66 90                	xchg   %ax,%ax
f0121eed:	66 90                	xchg   %ax,%ax
f0121eef:	66 90                	xchg   %ax,%ax
f0121ef1:	66 90                	xchg   %ax,%ax
f0121ef3:	66 90                	xchg   %ax,%ax
f0121ef5:	66 90                	xchg   %ax,%ax
f0121ef7:	66 90                	xchg   %ax,%ax
f0121ef9:	66 90                	xchg   %ax,%ax
f0121efb:	66 90                	xchg   %ax,%ax
f0121efd:	66 90                	xchg   %ax,%ax
f0121eff:	66 90                	xchg   %ax,%ax
f0121f01:	66 90                	xchg   %ax,%ax
f0121f03:	66 90                	xchg   %ax,%ax
f0121f05:	66 90                	xchg   %ax,%ax
f0121f07:	66 90                	xchg   %ax,%ax
f0121f09:	66 90                	xchg   %ax,%ax
f0121f0b:	66 90                	xchg   %ax,%ax
f0121f0d:	66 90                	xchg   %ax,%ax
f0121f0f:	66 90                	xchg   %ax,%ax
f0121f11:	66 90                	xchg   %ax,%ax
f0121f13:	66 90                	xchg   %ax,%ax
f0121f15:	66 90                	xchg   %ax,%ax
f0121f17:	66 90                	xchg   %ax,%ax
f0121f19:	66 90                	xchg   %ax,%ax
f0121f1b:	66 90                	xchg   %ax,%ax
f0121f1d:	66 90                	xchg   %ax,%ax
f0121f1f:	66 90                	xchg   %ax,%ax
f0121f21:	66 90                	xchg   %ax,%ax
f0121f23:	66 90                	xchg   %ax,%ax
f0121f25:	66 90                	xchg   %ax,%ax
f0121f27:	66 90                	xchg   %ax,%ax
f0121f29:	66 90                	xchg   %ax,%ax
f0121f2b:	66 90                	xchg   %ax,%ax
f0121f2d:	66 90                	xchg   %ax,%ax
f0121f2f:	66 90                	xchg   %ax,%ax
f0121f31:	66 90                	xchg   %ax,%ax
f0121f33:	66 90                	xchg   %ax,%ax
f0121f35:	66 90                	xchg   %ax,%ax
f0121f37:	66 90                	xchg   %ax,%ax
f0121f39:	66 90                	xchg   %ax,%ax
f0121f3b:	66 90                	xchg   %ax,%ax
f0121f3d:	66 90                	xchg   %ax,%ax
f0121f3f:	66 90                	xchg   %ax,%ax
f0121f41:	66 90                	xchg   %ax,%ax
f0121f43:	66 90                	xchg   %ax,%ax
f0121f45:	66 90                	xchg   %ax,%ax
f0121f47:	66 90                	xchg   %ax,%ax
f0121f49:	66 90                	xchg   %ax,%ax
f0121f4b:	66 90                	xchg   %ax,%ax
f0121f4d:	66 90                	xchg   %ax,%ax
f0121f4f:	66 90                	xchg   %ax,%ax
f0121f51:	66 90                	xchg   %ax,%ax
f0121f53:	66 90                	xchg   %ax,%ax
f0121f55:	66 90                	xchg   %ax,%ax
f0121f57:	66 90                	xchg   %ax,%ax
f0121f59:	66 90                	xchg   %ax,%ax
f0121f5b:	66 90                	xchg   %ax,%ax
f0121f5d:	66 90                	xchg   %ax,%ax
f0121f5f:	66 90                	xchg   %ax,%ax
f0121f61:	66 90                	xchg   %ax,%ax
f0121f63:	66 90                	xchg   %ax,%ax
f0121f65:	66 90                	xchg   %ax,%ax
f0121f67:	66 90                	xchg   %ax,%ax
f0121f69:	66 90                	xchg   %ax,%ax
f0121f6b:	66 90                	xchg   %ax,%ax
f0121f6d:	66 90                	xchg   %ax,%ax
f0121f6f:	66 90                	xchg   %ax,%ax
f0121f71:	66 90                	xchg   %ax,%ax
f0121f73:	66 90                	xchg   %ax,%ax
f0121f75:	66 90                	xchg   %ax,%ax
f0121f77:	66 90                	xchg   %ax,%ax
f0121f79:	66 90                	xchg   %ax,%ax
f0121f7b:	66 90                	xchg   %ax,%ax
f0121f7d:	66 90                	xchg   %ax,%ax
f0121f7f:	66 90                	xchg   %ax,%ax
f0121f81:	66 90                	xchg   %ax,%ax
f0121f83:	66 90                	xchg   %ax,%ax
f0121f85:	66 90                	xchg   %ax,%ax
f0121f87:	66 90                	xchg   %ax,%ax
f0121f89:	66 90                	xchg   %ax,%ax
f0121f8b:	66 90                	xchg   %ax,%ax
f0121f8d:	66 90                	xchg   %ax,%ax
f0121f8f:	66 90                	xchg   %ax,%ax
f0121f91:	66 90                	xchg   %ax,%ax
f0121f93:	66 90                	xchg   %ax,%ax
f0121f95:	66 90                	xchg   %ax,%ax
f0121f97:	66 90                	xchg   %ax,%ax
f0121f99:	66 90                	xchg   %ax,%ax
f0121f9b:	66 90                	xchg   %ax,%ax
f0121f9d:	66 90                	xchg   %ax,%ax
f0121f9f:	66 90                	xchg   %ax,%ax
f0121fa1:	66 90                	xchg   %ax,%ax
f0121fa3:	66 90                	xchg   %ax,%ax
f0121fa5:	66 90                	xchg   %ax,%ax
f0121fa7:	66 90                	xchg   %ax,%ax
f0121fa9:	66 90                	xchg   %ax,%ax
f0121fab:	66 90                	xchg   %ax,%ax
f0121fad:	66 90                	xchg   %ax,%ax
f0121faf:	66 90                	xchg   %ax,%ax
f0121fb1:	66 90                	xchg   %ax,%ax
f0121fb3:	66 90                	xchg   %ax,%ax
f0121fb5:	66 90                	xchg   %ax,%ax
f0121fb7:	66 90                	xchg   %ax,%ax
f0121fb9:	66 90                	xchg   %ax,%ax
f0121fbb:	66 90                	xchg   %ax,%ax
f0121fbd:	66 90                	xchg   %ax,%ax
f0121fbf:	66 90                	xchg   %ax,%ax
f0121fc1:	66 90                	xchg   %ax,%ax
f0121fc3:	66 90                	xchg   %ax,%ax
f0121fc5:	66 90                	xchg   %ax,%ax
f0121fc7:	66 90                	xchg   %ax,%ax
f0121fc9:	66 90                	xchg   %ax,%ax
f0121fcb:	66 90                	xchg   %ax,%ax
f0121fcd:	66 90                	xchg   %ax,%ax
f0121fcf:	66 90                	xchg   %ax,%ax
f0121fd1:	66 90                	xchg   %ax,%ax
f0121fd3:	66 90                	xchg   %ax,%ax
f0121fd5:	66 90                	xchg   %ax,%ax
f0121fd7:	66 90                	xchg   %ax,%ax
f0121fd9:	66 90                	xchg   %ax,%ax
f0121fdb:	66 90                	xchg   %ax,%ax
f0121fdd:	66 90                	xchg   %ax,%ax
f0121fdf:	66 90                	xchg   %ax,%ax
f0121fe1:	66 90                	xchg   %ax,%ax
f0121fe3:	66 90                	xchg   %ax,%ax
f0121fe5:	66 90                	xchg   %ax,%ax
f0121fe7:	66 90                	xchg   %ax,%ax
f0121fe9:	66 90                	xchg   %ax,%ax
f0121feb:	66 90                	xchg   %ax,%ax
f0121fed:	66 90                	xchg   %ax,%ax
f0121fef:	66 90                	xchg   %ax,%ax
f0121ff1:	66 90                	xchg   %ax,%ax
f0121ff3:	66 90                	xchg   %ax,%ax
f0121ff5:	66 90                	xchg   %ax,%ax
f0121ff7:	66 90                	xchg   %ax,%ax
f0121ff9:	66 90                	xchg   %ax,%ax
f0121ffb:	66 90                	xchg   %ax,%ax
f0121ffd:	66 90                	xchg   %ax,%ax
f0121fff:	90                   	nop

f0122000 <bootstack>:
	...

f012a000 <gdt>:
	...
f012a008:	ff ff 00 00 00 9a cf 00 ff ff 00 00 00 92 cf 00     ................
f012a018:	ff ff 00 00 00 fa cf 00 ff ff 00 00 00 f2 cf 00     ................
	...
f012a068:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a078:	66 90 66 90 66 90 66 90                             f.f.f.f.

f012a080 <idt>:
	...
f012a880:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a890:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a8a0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a8b0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a8c0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a8d0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a8e0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a8f0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a900:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a910:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a920:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a930:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a940:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a950:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a960:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a970:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a980:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a990:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a9a0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a9b0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a9c0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a9d0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a9e0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012a9f0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa00:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa10:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa20:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa30:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa40:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa50:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa60:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa70:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa80:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aa90:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aaa0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aab0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aac0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aad0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aae0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aaf0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab00:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab10:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab20:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab30:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab40:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab50:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab60:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab70:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab80:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ab90:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aba0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012abb0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012abc0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012abd0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012abe0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012abf0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac00:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac10:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac20:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac30:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac40:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac50:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac60:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac70:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac80:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ac90:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aca0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012acb0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012acc0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012acd0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ace0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012acf0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad00:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad10:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad20:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad30:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad40:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad50:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad60:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad70:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad80:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ad90:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ada0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012adb0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012adc0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012add0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ade0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012adf0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae00:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae10:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae20:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae30:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae40:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae50:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae60:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae70:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae80:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012ae90:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aea0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aeb0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aec0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aed0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aee0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aef0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af00:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af10:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af20:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af30:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af40:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af50:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af60:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af70:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af80:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012af90:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012afa0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012afb0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012afc0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012afd0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012afe0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.
f012aff0:	66 90 66 90 66 90 66 90 66 90 66 90 66 90 66 90     f.f.f.f.f.f.f.f.

f012b000 <percpu_kstacks>:
	...

f016b000 <bootcpu>:
	...

f016b020 <cpus>:
	...

f016b3c0 <lapic>:
f016b3c0:	00 00 00 00                                         ....
