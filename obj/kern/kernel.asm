
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
f0100042:	e8 73 00 00 00       	call   f01000ba <i386_init>

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
	cprintf("in %s\n", __FUNCTION__);
f0100051:	83 ec 08             	sub    $0x8,%esp
f0100054:	68 54 81 10 f0       	push   $0xf0108154
f0100059:	68 20 80 10 f0       	push   $0xf0108020
f010005e:	e8 02 42 00 00       	call   f0104265 <cprintf>
	va_list ap;

	if (panicstr)
f0100063:	83 c4 10             	add    $0x10,%esp
f0100066:	83 3d 80 ed 5d f0 00 	cmpl   $0x0,0xf05ded80
f010006d:	74 0f                	je     f010007e <_panic+0x35>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010006f:	83 ec 0c             	sub    $0xc,%esp
f0100072:	6a 00                	push   $0x0
f0100074:	e8 66 0c 00 00       	call   f0100cdf <monitor>
f0100079:	83 c4 10             	add    $0x10,%esp
f010007c:	eb f1                	jmp    f010006f <_panic+0x26>
	panicstr = fmt;
f010007e:	89 35 80 ed 5d f0    	mov    %esi,0xf05ded80
	asm volatile("cli; cld");
f0100084:	fa                   	cli    
f0100085:	fc                   	cld    
	va_start(ap, fmt);
f0100086:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100089:	e8 89 14 02 00       	call   f0121517 <cpunum>
f010008e:	ff 75 0c             	pushl  0xc(%ebp)
f0100091:	ff 75 08             	pushl  0x8(%ebp)
f0100094:	50                   	push   %eax
f0100095:	68 b8 80 10 f0       	push   $0xf01080b8
f010009a:	e8 c6 41 00 00       	call   f0104265 <cprintf>
	vcprintf(fmt, ap);
f010009f:	83 c4 08             	add    $0x8,%esp
f01000a2:	53                   	push   %ebx
f01000a3:	56                   	push   %esi
f01000a4:	e8 96 41 00 00       	call   f010423f <vcprintf>
	cprintf("\n");
f01000a9:	c7 04 24 9b 95 10 f0 	movl   $0xf010959b,(%esp)
f01000b0:	e8 b0 41 00 00       	call   f0104265 <cprintf>
f01000b5:	83 c4 10             	add    $0x10,%esp
f01000b8:	eb b5                	jmp    f010006f <_panic+0x26>

f01000ba <i386_init>:
{
f01000ba:	55                   	push   %ebp
f01000bb:	89 e5                	mov    %esp,%ebp
f01000bd:	56                   	push   %esi
f01000be:	53                   	push   %ebx
	cons_init();
f01000bf:	e8 37 06 00 00       	call   f01006fb <cons_init>
	cprintf("in %s\n", __FUNCTION__);
f01000c4:	83 ec 08             	sub    $0x8,%esp
f01000c7:	68 70 81 10 f0       	push   $0xf0108170
f01000cc:	68 20 80 10 f0       	push   $0xf0108020
f01000d1:	e8 8f 41 00 00       	call   f0104265 <cprintf>
	cprintf("pading space in the right to number 22: %-8d.\n", 22);
f01000d6:	83 c4 08             	add    $0x8,%esp
f01000d9:	6a 16                	push   $0x16
f01000db:	68 dc 80 10 f0       	push   $0xf01080dc
f01000e0:	e8 80 41 00 00       	call   f0104265 <cprintf>
	cprintf("%n", NULL);
f01000e5:	83 c4 08             	add    $0x8,%esp
f01000e8:	6a 00                	push   $0x0
f01000ea:	68 27 80 10 f0       	push   $0xf0108027
f01000ef:	e8 71 41 00 00       	call   f0104265 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000f4:	83 c4 0c             	add    $0xc,%esp
f01000f7:	68 00 fc ff ff       	push   $0xfffffc00
f01000fc:	68 00 04 00 00       	push   $0x400
f0100101:	68 2a 80 10 f0       	push   $0xf010802a
f0100106:	e8 5a 41 00 00       	call   f0104265 <cprintf>
	mem_init();
f010010b:	e8 c0 16 00 00       	call   f01017d0 <mem_init>
	cprintf("after mem_init()\n");
f0100110:	c7 04 24 46 80 10 f0 	movl   $0xf0108046,(%esp)
f0100117:	e8 49 41 00 00       	call   f0104265 <cprintf>
	env_init();
f010011c:	e8 47 36 00 00       	call   f0103768 <env_init>
	cprintf("after env_init()\n");
f0100121:	c7 04 24 58 80 10 f0 	movl   $0xf0108058,(%esp)
f0100128:	e8 38 41 00 00       	call   f0104265 <cprintf>
	trap_init();
f010012d:	e8 29 42 00 00       	call   f010435b <trap_init>

static inline uint32_t
read_esp(void)
{
	uint32_t esp;
	asm volatile("movl %%esp,%0" : "=r" (esp));
f0100132:	89 e3                	mov    %esp,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100134:	89 ee                	mov    %ebp,%esi
	memmove((void*)(KSTACKTOP-KSTKSIZE), bootstack, KSTKSIZE);
f0100136:	83 c4 0c             	add    $0xc,%esp
f0100139:	68 00 80 00 00       	push   $0x8000
f010013e:	68 00 20 12 f0       	push   $0xf0122000
f0100143:	68 00 80 ff ef       	push   $0xefff8000
f0100148:	e8 c2 67 00 00       	call   f010690f <memmove>
	uint32_t off = KSTACKTOP - KSTKSIZE - (uint32_t)bootstack;
f010014d:	b8 00 80 ff ef       	mov    $0xefff8000,%eax
f0100152:	2d 00 20 12 f0       	sub    $0xf0122000,%eax
	esp += off;
f0100157:	01 c3                	add    %eax,%ebx
	asm volatile("movl %0, %%esp"::"r"(esp):);
f0100159:	89 dc                	mov    %ebx,%esp
	ebp += off;
f010015b:	01 f0                	add    %esi,%eax
	asm volatile("movl %0, %%ebp"::"r"(ebp):);
f010015d:	89 c5                	mov    %eax,%ebp
	mp_init();
f010015f:	e8 73 6a 00 00       	call   f0106bd7 <mp_init>
	cprintf("after mp_init()\n");
f0100164:	c7 04 24 6a 80 10 f0 	movl   $0xf010806a,(%esp)
f010016b:	e8 f5 40 00 00       	call   f0104265 <cprintf>
	lapic_init();
f0100170:	e8 59 6d 00 00       	call   f0106ece <lapic_init>
	pic_init();
f0100175:	e8 f0 3f 00 00       	call   f010416a <pic_init>
	time_init();
f010017a:	e8 ee 7b 00 00       	call   f0107d6d <time_init>
	pci_init();
f010017f:	e8 c9 7b 00 00       	call   f0107d4d <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100184:	c7 04 24 20 d3 16 f0 	movl   $0xf016d320,(%esp)
f010018b:	e8 b1 6f 00 00       	call   f0107141 <spin_lock>
	cprintf("in %s\n", __FUNCTION__);
f0100190:	83 c4 08             	add    $0x8,%esp
f0100193:	68 64 81 10 f0       	push   $0xf0108164
f0100198:	68 20 80 10 f0       	push   $0xf0108020
f010019d:	e8 c3 40 00 00       	call   f0104265 <cprintf>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01001a2:	83 c4 10             	add    $0x10,%esp
f01001a5:	83 3d 88 ed 5d f0 07 	cmpl   $0x7,0xf05ded88
f01001ac:	76 27                	jbe    f01001d5 <i386_init+0x11b>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01001ae:	83 ec 04             	sub    $0x4,%esp
f01001b1:	b8 3a 6b 10 f0       	mov    $0xf0106b3a,%eax
f01001b6:	2d b8 6a 10 f0       	sub    $0xf0106ab8,%eax
f01001bb:	50                   	push   %eax
f01001bc:	68 b8 6a 10 f0       	push   $0xf0106ab8
f01001c1:	68 00 70 00 f0       	push   $0xf0007000
f01001c6:	e8 44 67 00 00       	call   f010690f <memmove>
f01001cb:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f01001ce:	bb 20 b0 16 f0       	mov    $0xf016b020,%ebx
f01001d3:	eb 19                	jmp    f01001ee <i386_init+0x134>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01001d5:	68 00 70 00 00       	push   $0x7000
f01001da:	68 0c 81 10 f0       	push   $0xf010810c
f01001df:	6a 7f                	push   $0x7f
f01001e1:	68 7b 80 10 f0       	push   $0xf010807b
f01001e6:	e8 5e fe ff ff       	call   f0100049 <_panic>
f01001eb:	83 c3 74             	add    $0x74,%ebx
f01001ee:	6b 05 98 ed 5d f0 74 	imul   $0x74,0xf05ded98,%eax
f01001f5:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01001fa:	39 c3                	cmp    %eax,%ebx
f01001fc:	73 4d                	jae    f010024b <i386_init+0x191>
		if (c == cpus + cpunum())  // We've started already.
f01001fe:	e8 14 13 02 00       	call   f0121517 <cpunum>
f0100203:	6b c0 74             	imul   $0x74,%eax,%eax
f0100206:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f010020b:	39 c3                	cmp    %eax,%ebx
f010020d:	74 dc                	je     f01001eb <i386_init+0x131>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010020f:	89 d8                	mov    %ebx,%eax
f0100211:	2d 20 b0 16 f0       	sub    $0xf016b020,%eax
f0100216:	c1 f8 02             	sar    $0x2,%eax
f0100219:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010021f:	c1 e0 0f             	shl    $0xf,%eax
f0100222:	8d 80 00 30 13 f0    	lea    -0xfecd000(%eax),%eax
f0100228:	a3 84 ed 5d f0       	mov    %eax,0xf05ded84
		lapic_startap(c->cpu_id, PADDR(code));
f010022d:	83 ec 08             	sub    $0x8,%esp
f0100230:	68 00 70 00 00       	push   $0x7000
f0100235:	0f b6 03             	movzbl (%ebx),%eax
f0100238:	50                   	push   %eax
f0100239:	e8 fb 6d 00 00       	call   f0107039 <lapic_startap>
f010023e:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f0100241:	8b 43 04             	mov    0x4(%ebx),%eax
f0100244:	83 f8 01             	cmp    $0x1,%eax
f0100247:	75 f8                	jne    f0100241 <i386_init+0x187>
f0100249:	eb a0                	jmp    f01001eb <i386_init+0x131>
	ENV_CREATE(user_icode, ENV_TYPE_USER);//lab5 bug just test
f010024b:	83 ec 08             	sub    $0x8,%esp
f010024e:	6a 00                	push   $0x0
f0100250:	68 60 20 42 f0       	push   $0xf0422060
f0100255:	e8 cb 39 00 00       	call   f0103c25 <env_create>
	kbd_intr();
f010025a:	e8 47 04 00 00       	call   f01006a6 <kbd_intr>
	sched_yield();
f010025f:	e8 b9 4e 00 00       	call   f010511d <sched_yield>

f0100264 <mp_main>:
{
f0100264:	55                   	push   %ebp
f0100265:	89 e5                	mov    %esp,%ebp
f0100267:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f010026a:	68 5c 81 10 f0       	push   $0xf010815c
f010026f:	68 20 80 10 f0       	push   $0xf0108020
f0100274:	e8 ec 3f 00 00       	call   f0104265 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0100279:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010027e:	83 c4 10             	add    $0x10,%esp
f0100281:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100286:	76 52                	jbe    f01002da <mp_main+0x76>
	return (physaddr_t)kva - KERNBASE;
f0100288:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010028d:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100290:	e8 82 12 02 00       	call   f0121517 <cpunum>
f0100295:	83 ec 08             	sub    $0x8,%esp
f0100298:	50                   	push   %eax
f0100299:	68 87 80 10 f0       	push   $0xf0108087
f010029e:	e8 c2 3f 00 00       	call   f0104265 <cprintf>
	lapic_init();
f01002a3:	e8 26 6c 00 00       	call   f0106ece <lapic_init>
	env_init_percpu();
f01002a8:	e8 8f 34 00 00       	call   f010373c <env_init_percpu>
	trap_init_percpu();
f01002ad:	e8 c7 3f 00 00       	call   f0104279 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01002b2:	e8 60 12 02 00       	call   f0121517 <cpunum>
f01002b7:	6b d0 74             	imul   $0x74,%eax,%edx
f01002ba:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01002bd:	b8 01 00 00 00       	mov    $0x1,%eax
f01002c2:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
f01002c9:	c7 04 24 20 d3 16 f0 	movl   $0xf016d320,(%esp)
f01002d0:	e8 6c 6e 00 00       	call   f0107141 <spin_lock>
	sched_yield();
f01002d5:	e8 43 4e 00 00       	call   f010511d <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01002da:	50                   	push   %eax
f01002db:	68 30 81 10 f0       	push   $0xf0108130
f01002e0:	68 97 00 00 00       	push   $0x97
f01002e5:	68 7b 80 10 f0       	push   $0xf010807b
f01002ea:	e8 5a fd ff ff       	call   f0100049 <_panic>

f01002ef <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002ef:	55                   	push   %ebp
f01002f0:	89 e5                	mov    %esp,%ebp
f01002f2:	53                   	push   %ebx
f01002f3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01002f6:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002f9:	ff 75 0c             	pushl  0xc(%ebp)
f01002fc:	ff 75 08             	pushl  0x8(%ebp)
f01002ff:	68 9d 80 10 f0       	push   $0xf010809d
f0100304:	e8 5c 3f 00 00       	call   f0104265 <cprintf>
	vcprintf(fmt, ap);
f0100309:	83 c4 08             	add    $0x8,%esp
f010030c:	53                   	push   %ebx
f010030d:	ff 75 10             	pushl  0x10(%ebp)
f0100310:	e8 2a 3f 00 00       	call   f010423f <vcprintf>
	cprintf("\n");
f0100315:	c7 04 24 9b 95 10 f0 	movl   $0xf010959b,(%esp)
f010031c:	e8 44 3f 00 00       	call   f0104265 <cprintf>
	va_end(ap);
}
f0100321:	83 c4 10             	add    $0x10,%esp
f0100324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100327:	c9                   	leave  
f0100328:	c3                   	ret    

f0100329 <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100329:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010032e:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010032f:	a8 01                	test   $0x1,%al
f0100331:	74 0a                	je     f010033d <serial_proc_data+0x14>
f0100333:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100338:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100339:	0f b6 c0             	movzbl %al,%eax
f010033c:	c3                   	ret    
		return -1;
f010033d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100342:	c3                   	ret    

f0100343 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100343:	55                   	push   %ebp
f0100344:	89 e5                	mov    %esp,%ebp
f0100346:	53                   	push   %ebx
f0100347:	83 ec 04             	sub    $0x4,%esp
f010034a:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010034c:	ff d3                	call   *%ebx
f010034e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100351:	74 29                	je     f010037c <cons_intr+0x39>
		if (c == 0)
f0100353:	85 c0                	test   %eax,%eax
f0100355:	74 f5                	je     f010034c <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100357:	8b 0d 24 d9 5d f0    	mov    0xf05dd924,%ecx
f010035d:	8d 51 01             	lea    0x1(%ecx),%edx
f0100360:	88 81 20 d7 5d f0    	mov    %al,-0xfa228e0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100366:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f010036c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100371:	0f 44 d0             	cmove  %eax,%edx
f0100374:	89 15 24 d9 5d f0    	mov    %edx,0xf05dd924
f010037a:	eb d0                	jmp    f010034c <cons_intr+0x9>
	}
}
f010037c:	83 c4 04             	add    $0x4,%esp
f010037f:	5b                   	pop    %ebx
f0100380:	5d                   	pop    %ebp
f0100381:	c3                   	ret    

f0100382 <kbd_proc_data>:
{
f0100382:	55                   	push   %ebp
f0100383:	89 e5                	mov    %esp,%ebp
f0100385:	53                   	push   %ebx
f0100386:	83 ec 04             	sub    $0x4,%esp
f0100389:	ba 64 00 00 00       	mov    $0x64,%edx
f010038e:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f010038f:	a8 01                	test   $0x1,%al
f0100391:	0f 84 f2 00 00 00    	je     f0100489 <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f0100397:	a8 20                	test   $0x20,%al
f0100399:	0f 85 f1 00 00 00    	jne    f0100490 <kbd_proc_data+0x10e>
f010039f:	ba 60 00 00 00       	mov    $0x60,%edx
f01003a4:	ec                   	in     (%dx),%al
f01003a5:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01003a7:	3c e0                	cmp    $0xe0,%al
f01003a9:	74 61                	je     f010040c <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f01003ab:	84 c0                	test   %al,%al
f01003ad:	78 70                	js     f010041f <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f01003af:	8b 0d 00 d7 5d f0    	mov    0xf05dd700,%ecx
f01003b5:	f6 c1 40             	test   $0x40,%cl
f01003b8:	74 0e                	je     f01003c8 <kbd_proc_data+0x46>
		data |= 0x80;
f01003ba:	83 c8 80             	or     $0xffffff80,%eax
f01003bd:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01003bf:	83 e1 bf             	and    $0xffffffbf,%ecx
f01003c2:	89 0d 00 d7 5d f0    	mov    %ecx,0xf05dd700
	shift |= shiftcode[data];
f01003c8:	0f b6 d2             	movzbl %dl,%edx
f01003cb:	0f b6 82 e0 82 10 f0 	movzbl -0xfef7d20(%edx),%eax
f01003d2:	0b 05 00 d7 5d f0    	or     0xf05dd700,%eax
	shift ^= togglecode[data];
f01003d8:	0f b6 8a e0 81 10 f0 	movzbl -0xfef7e20(%edx),%ecx
f01003df:	31 c8                	xor    %ecx,%eax
f01003e1:	a3 00 d7 5d f0       	mov    %eax,0xf05dd700
	c = charcode[shift & (CTL | SHIFT)][data];
f01003e6:	89 c1                	mov    %eax,%ecx
f01003e8:	83 e1 03             	and    $0x3,%ecx
f01003eb:	8b 0c 8d c0 81 10 f0 	mov    -0xfef7e40(,%ecx,4),%ecx
f01003f2:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01003f6:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f01003f9:	a8 08                	test   $0x8,%al
f01003fb:	74 61                	je     f010045e <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f01003fd:	89 da                	mov    %ebx,%edx
f01003ff:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100402:	83 f9 19             	cmp    $0x19,%ecx
f0100405:	77 4b                	ja     f0100452 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f0100407:	83 eb 20             	sub    $0x20,%ebx
f010040a:	eb 0c                	jmp    f0100418 <kbd_proc_data+0x96>
		shift |= E0ESC;
f010040c:	83 0d 00 d7 5d f0 40 	orl    $0x40,0xf05dd700
		return 0;
f0100413:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100418:	89 d8                	mov    %ebx,%eax
f010041a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010041d:	c9                   	leave  
f010041e:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010041f:	8b 0d 00 d7 5d f0    	mov    0xf05dd700,%ecx
f0100425:	89 cb                	mov    %ecx,%ebx
f0100427:	83 e3 40             	and    $0x40,%ebx
f010042a:	83 e0 7f             	and    $0x7f,%eax
f010042d:	85 db                	test   %ebx,%ebx
f010042f:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100432:	0f b6 d2             	movzbl %dl,%edx
f0100435:	0f b6 82 e0 82 10 f0 	movzbl -0xfef7d20(%edx),%eax
f010043c:	83 c8 40             	or     $0x40,%eax
f010043f:	0f b6 c0             	movzbl %al,%eax
f0100442:	f7 d0                	not    %eax
f0100444:	21 c8                	and    %ecx,%eax
f0100446:	a3 00 d7 5d f0       	mov    %eax,0xf05dd700
		return 0;
f010044b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100450:	eb c6                	jmp    f0100418 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f0100452:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100455:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100458:	83 fa 1a             	cmp    $0x1a,%edx
f010045b:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010045e:	f7 d0                	not    %eax
f0100460:	a8 06                	test   $0x6,%al
f0100462:	75 b4                	jne    f0100418 <kbd_proc_data+0x96>
f0100464:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010046a:	75 ac                	jne    f0100418 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f010046c:	83 ec 0c             	sub    $0xc,%esp
f010046f:	68 7a 81 10 f0       	push   $0xf010817a
f0100474:	e8 ec 3d 00 00       	call   f0104265 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100479:	b8 03 00 00 00       	mov    $0x3,%eax
f010047e:	ba 92 00 00 00       	mov    $0x92,%edx
f0100483:	ee                   	out    %al,(%dx)
f0100484:	83 c4 10             	add    $0x10,%esp
f0100487:	eb 8f                	jmp    f0100418 <kbd_proc_data+0x96>
		return -1;
f0100489:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010048e:	eb 88                	jmp    f0100418 <kbd_proc_data+0x96>
		return -1;
f0100490:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100495:	eb 81                	jmp    f0100418 <kbd_proc_data+0x96>

f0100497 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100497:	55                   	push   %ebp
f0100498:	89 e5                	mov    %esp,%ebp
f010049a:	57                   	push   %edi
f010049b:	56                   	push   %esi
f010049c:	53                   	push   %ebx
f010049d:	83 ec 1c             	sub    $0x1c,%esp
f01004a0:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f01004a2:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004a7:	bf fd 03 00 00       	mov    $0x3fd,%edi
f01004ac:	bb 84 00 00 00       	mov    $0x84,%ebx
f01004b1:	89 fa                	mov    %edi,%edx
f01004b3:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01004b4:	a8 20                	test   $0x20,%al
f01004b6:	75 13                	jne    f01004cb <cons_putc+0x34>
f01004b8:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01004be:	7f 0b                	jg     f01004cb <cons_putc+0x34>
f01004c0:	89 da                	mov    %ebx,%edx
f01004c2:	ec                   	in     (%dx),%al
f01004c3:	ec                   	in     (%dx),%al
f01004c4:	ec                   	in     (%dx),%al
f01004c5:	ec                   	in     (%dx),%al
	     i++)
f01004c6:	83 c6 01             	add    $0x1,%esi
f01004c9:	eb e6                	jmp    f01004b1 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f01004cb:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004ce:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004d3:	89 c8                	mov    %ecx,%eax
f01004d5:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004d6:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004db:	bf 79 03 00 00       	mov    $0x379,%edi
f01004e0:	bb 84 00 00 00       	mov    $0x84,%ebx
f01004e5:	89 fa                	mov    %edi,%edx
f01004e7:	ec                   	in     (%dx),%al
f01004e8:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01004ee:	7f 0f                	jg     f01004ff <cons_putc+0x68>
f01004f0:	84 c0                	test   %al,%al
f01004f2:	78 0b                	js     f01004ff <cons_putc+0x68>
f01004f4:	89 da                	mov    %ebx,%edx
f01004f6:	ec                   	in     (%dx),%al
f01004f7:	ec                   	in     (%dx),%al
f01004f8:	ec                   	in     (%dx),%al
f01004f9:	ec                   	in     (%dx),%al
f01004fa:	83 c6 01             	add    $0x1,%esi
f01004fd:	eb e6                	jmp    f01004e5 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004ff:	ba 78 03 00 00       	mov    $0x378,%edx
f0100504:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100508:	ee                   	out    %al,(%dx)
f0100509:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010050e:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100513:	ee                   	out    %al,(%dx)
f0100514:	b8 08 00 00 00       	mov    $0x8,%eax
f0100519:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010051a:	89 ca                	mov    %ecx,%edx
f010051c:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100522:	89 c8                	mov    %ecx,%eax
f0100524:	80 cc 07             	or     $0x7,%ah
f0100527:	85 d2                	test   %edx,%edx
f0100529:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f010052c:	0f b6 c1             	movzbl %cl,%eax
f010052f:	83 f8 09             	cmp    $0x9,%eax
f0100532:	0f 84 b0 00 00 00    	je     f01005e8 <cons_putc+0x151>
f0100538:	7e 73                	jle    f01005ad <cons_putc+0x116>
f010053a:	83 f8 0a             	cmp    $0xa,%eax
f010053d:	0f 84 98 00 00 00    	je     f01005db <cons_putc+0x144>
f0100543:	83 f8 0d             	cmp    $0xd,%eax
f0100546:	0f 85 d3 00 00 00    	jne    f010061f <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f010054c:	0f b7 05 28 d9 5d f0 	movzwl 0xf05dd928,%eax
f0100553:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100559:	c1 e8 16             	shr    $0x16,%eax
f010055c:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010055f:	c1 e0 04             	shl    $0x4,%eax
f0100562:	66 a3 28 d9 5d f0    	mov    %ax,0xf05dd928
	if (crt_pos >= CRT_SIZE) {
f0100568:	66 81 3d 28 d9 5d f0 	cmpw   $0x7cf,0xf05dd928
f010056f:	cf 07 
f0100571:	0f 87 cb 00 00 00    	ja     f0100642 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f0100577:	8b 0d 30 d9 5d f0    	mov    0xf05dd930,%ecx
f010057d:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100582:	89 ca                	mov    %ecx,%edx
f0100584:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100585:	0f b7 1d 28 d9 5d f0 	movzwl 0xf05dd928,%ebx
f010058c:	8d 71 01             	lea    0x1(%ecx),%esi
f010058f:	89 d8                	mov    %ebx,%eax
f0100591:	66 c1 e8 08          	shr    $0x8,%ax
f0100595:	89 f2                	mov    %esi,%edx
f0100597:	ee                   	out    %al,(%dx)
f0100598:	b8 0f 00 00 00       	mov    $0xf,%eax
f010059d:	89 ca                	mov    %ecx,%edx
f010059f:	ee                   	out    %al,(%dx)
f01005a0:	89 d8                	mov    %ebx,%eax
f01005a2:	89 f2                	mov    %esi,%edx
f01005a4:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01005a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01005a8:	5b                   	pop    %ebx
f01005a9:	5e                   	pop    %esi
f01005aa:	5f                   	pop    %edi
f01005ab:	5d                   	pop    %ebp
f01005ac:	c3                   	ret    
	switch (c & 0xff) {
f01005ad:	83 f8 08             	cmp    $0x8,%eax
f01005b0:	75 6d                	jne    f010061f <cons_putc+0x188>
		if (crt_pos > 0) {
f01005b2:	0f b7 05 28 d9 5d f0 	movzwl 0xf05dd928,%eax
f01005b9:	66 85 c0             	test   %ax,%ax
f01005bc:	74 b9                	je     f0100577 <cons_putc+0xe0>
			crt_pos--;
f01005be:	83 e8 01             	sub    $0x1,%eax
f01005c1:	66 a3 28 d9 5d f0    	mov    %ax,0xf05dd928
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01005c7:	0f b7 c0             	movzwl %ax,%eax
f01005ca:	b1 00                	mov    $0x0,%cl
f01005cc:	83 c9 20             	or     $0x20,%ecx
f01005cf:	8b 15 2c d9 5d f0    	mov    0xf05dd92c,%edx
f01005d5:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005d9:	eb 8d                	jmp    f0100568 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f01005db:	66 83 05 28 d9 5d f0 	addw   $0x50,0xf05dd928
f01005e2:	50 
f01005e3:	e9 64 ff ff ff       	jmp    f010054c <cons_putc+0xb5>
		cons_putc(' ');
f01005e8:	b8 20 00 00 00       	mov    $0x20,%eax
f01005ed:	e8 a5 fe ff ff       	call   f0100497 <cons_putc>
		cons_putc(' ');
f01005f2:	b8 20 00 00 00       	mov    $0x20,%eax
f01005f7:	e8 9b fe ff ff       	call   f0100497 <cons_putc>
		cons_putc(' ');
f01005fc:	b8 20 00 00 00       	mov    $0x20,%eax
f0100601:	e8 91 fe ff ff       	call   f0100497 <cons_putc>
		cons_putc(' ');
f0100606:	b8 20 00 00 00       	mov    $0x20,%eax
f010060b:	e8 87 fe ff ff       	call   f0100497 <cons_putc>
		cons_putc(' ');
f0100610:	b8 20 00 00 00       	mov    $0x20,%eax
f0100615:	e8 7d fe ff ff       	call   f0100497 <cons_putc>
f010061a:	e9 49 ff ff ff       	jmp    f0100568 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f010061f:	0f b7 05 28 d9 5d f0 	movzwl 0xf05dd928,%eax
f0100626:	8d 50 01             	lea    0x1(%eax),%edx
f0100629:	66 89 15 28 d9 5d f0 	mov    %dx,0xf05dd928
f0100630:	0f b7 c0             	movzwl %ax,%eax
f0100633:	8b 15 2c d9 5d f0    	mov    0xf05dd92c,%edx
f0100639:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010063d:	e9 26 ff ff ff       	jmp    f0100568 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100642:	a1 2c d9 5d f0       	mov    0xf05dd92c,%eax
f0100647:	83 ec 04             	sub    $0x4,%esp
f010064a:	68 00 0f 00 00       	push   $0xf00
f010064f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100655:	52                   	push   %edx
f0100656:	50                   	push   %eax
f0100657:	e8 b3 62 00 00       	call   f010690f <memmove>
			crt_buf[i] = 0x0700 | ' ';
f010065c:	8b 15 2c d9 5d f0    	mov    0xf05dd92c,%edx
f0100662:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100668:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f010066e:	83 c4 10             	add    $0x10,%esp
f0100671:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100676:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100679:	39 d0                	cmp    %edx,%eax
f010067b:	75 f4                	jne    f0100671 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f010067d:	66 83 2d 28 d9 5d f0 	subw   $0x50,0xf05dd928
f0100684:	50 
f0100685:	e9 ed fe ff ff       	jmp    f0100577 <cons_putc+0xe0>

f010068a <serial_intr>:
	if (serial_exists)
f010068a:	80 3d 34 d9 5d f0 00 	cmpb   $0x0,0xf05dd934
f0100691:	75 01                	jne    f0100694 <serial_intr+0xa>
f0100693:	c3                   	ret    
{
f0100694:	55                   	push   %ebp
f0100695:	89 e5                	mov    %esp,%ebp
f0100697:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010069a:	b8 29 03 10 f0       	mov    $0xf0100329,%eax
f010069f:	e8 9f fc ff ff       	call   f0100343 <cons_intr>
}
f01006a4:	c9                   	leave  
f01006a5:	c3                   	ret    

f01006a6 <kbd_intr>:
{
f01006a6:	55                   	push   %ebp
f01006a7:	89 e5                	mov    %esp,%ebp
f01006a9:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01006ac:	b8 82 03 10 f0       	mov    $0xf0100382,%eax
f01006b1:	e8 8d fc ff ff       	call   f0100343 <cons_intr>
}
f01006b6:	c9                   	leave  
f01006b7:	c3                   	ret    

f01006b8 <cons_getc>:
{
f01006b8:	55                   	push   %ebp
f01006b9:	89 e5                	mov    %esp,%ebp
f01006bb:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01006be:	e8 c7 ff ff ff       	call   f010068a <serial_intr>
	kbd_intr();
f01006c3:	e8 de ff ff ff       	call   f01006a6 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01006c8:	8b 15 20 d9 5d f0    	mov    0xf05dd920,%edx
	return 0;
f01006ce:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f01006d3:	3b 15 24 d9 5d f0    	cmp    0xf05dd924,%edx
f01006d9:	74 1e                	je     f01006f9 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f01006db:	8d 4a 01             	lea    0x1(%edx),%ecx
f01006de:	0f b6 82 20 d7 5d f0 	movzbl -0xfa228e0(%edx),%eax
			cons.rpos = 0;
f01006e5:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01006eb:	ba 00 00 00 00       	mov    $0x0,%edx
f01006f0:	0f 44 ca             	cmove  %edx,%ecx
f01006f3:	89 0d 20 d9 5d f0    	mov    %ecx,0xf05dd920
}
f01006f9:	c9                   	leave  
f01006fa:	c3                   	ret    

f01006fb <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01006fb:	55                   	push   %ebp
f01006fc:	89 e5                	mov    %esp,%ebp
f01006fe:	57                   	push   %edi
f01006ff:	56                   	push   %esi
f0100700:	53                   	push   %ebx
f0100701:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100704:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010070b:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100712:	5a a5 
	if (*cp != 0xA55A) {
f0100714:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010071b:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010071f:	0f 84 de 00 00 00    	je     f0100803 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100725:	c7 05 30 d9 5d f0 b4 	movl   $0x3b4,0xf05dd930
f010072c:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010072f:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f0100734:	8b 3d 30 d9 5d f0    	mov    0xf05dd930,%edi
f010073a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010073f:	89 fa                	mov    %edi,%edx
f0100741:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100742:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100745:	89 ca                	mov    %ecx,%edx
f0100747:	ec                   	in     (%dx),%al
f0100748:	0f b6 c0             	movzbl %al,%eax
f010074b:	c1 e0 08             	shl    $0x8,%eax
f010074e:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100750:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100755:	89 fa                	mov    %edi,%edx
f0100757:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100758:	89 ca                	mov    %ecx,%edx
f010075a:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f010075b:	89 35 2c d9 5d f0    	mov    %esi,0xf05dd92c
	pos |= inb(addr_6845 + 1);
f0100761:	0f b6 c0             	movzbl %al,%eax
f0100764:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f0100766:	66 a3 28 d9 5d f0    	mov    %ax,0xf05dd928
	kbd_intr();
f010076c:	e8 35 ff ff ff       	call   f01006a6 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f0100771:	83 ec 0c             	sub    $0xc,%esp
f0100774:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f010077b:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100780:	50                   	push   %eax
f0100781:	e8 66 39 00 00       	call   f01040ec <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100786:	bb 00 00 00 00       	mov    $0x0,%ebx
f010078b:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f0100790:	89 d8                	mov    %ebx,%eax
f0100792:	89 ca                	mov    %ecx,%edx
f0100794:	ee                   	out    %al,(%dx)
f0100795:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010079a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010079f:	89 fa                	mov    %edi,%edx
f01007a1:	ee                   	out    %al,(%dx)
f01007a2:	b8 0c 00 00 00       	mov    $0xc,%eax
f01007a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01007ac:	ee                   	out    %al,(%dx)
f01007ad:	be f9 03 00 00       	mov    $0x3f9,%esi
f01007b2:	89 d8                	mov    %ebx,%eax
f01007b4:	89 f2                	mov    %esi,%edx
f01007b6:	ee                   	out    %al,(%dx)
f01007b7:	b8 03 00 00 00       	mov    $0x3,%eax
f01007bc:	89 fa                	mov    %edi,%edx
f01007be:	ee                   	out    %al,(%dx)
f01007bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01007c4:	89 d8                	mov    %ebx,%eax
f01007c6:	ee                   	out    %al,(%dx)
f01007c7:	b8 01 00 00 00       	mov    $0x1,%eax
f01007cc:	89 f2                	mov    %esi,%edx
f01007ce:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01007d4:	ec                   	in     (%dx),%al
f01007d5:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01007d7:	83 c4 10             	add    $0x10,%esp
f01007da:	3c ff                	cmp    $0xff,%al
f01007dc:	0f 95 05 34 d9 5d f0 	setne  0xf05dd934
f01007e3:	89 ca                	mov    %ecx,%edx
f01007e5:	ec                   	in     (%dx),%al
f01007e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01007eb:	ec                   	in     (%dx),%al
	if (serial_exists)
f01007ec:	80 fb ff             	cmp    $0xff,%bl
f01007ef:	75 2d                	jne    f010081e <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f01007f1:	83 ec 0c             	sub    $0xc,%esp
f01007f4:	68 86 81 10 f0       	push   $0xf0108186
f01007f9:	e8 67 3a 00 00       	call   f0104265 <cprintf>
f01007fe:	83 c4 10             	add    $0x10,%esp
}
f0100801:	eb 3c                	jmp    f010083f <cons_init+0x144>
		*cp = was;
f0100803:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010080a:	c7 05 30 d9 5d f0 d4 	movl   $0x3d4,0xf05dd930
f0100811:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100814:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100819:	e9 16 ff ff ff       	jmp    f0100734 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010081e:	83 ec 0c             	sub    $0xc,%esp
f0100821:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f0100828:	25 ef ff 00 00       	and    $0xffef,%eax
f010082d:	50                   	push   %eax
f010082e:	e8 b9 38 00 00       	call   f01040ec <irq_setmask_8259A>
	if (!serial_exists)
f0100833:	83 c4 10             	add    $0x10,%esp
f0100836:	80 3d 34 d9 5d f0 00 	cmpb   $0x0,0xf05dd934
f010083d:	74 b2                	je     f01007f1 <cons_init+0xf6>
}
f010083f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100842:	5b                   	pop    %ebx
f0100843:	5e                   	pop    %esi
f0100844:	5f                   	pop    %edi
f0100845:	5d                   	pop    %ebp
f0100846:	c3                   	ret    

f0100847 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100847:	55                   	push   %ebp
f0100848:	89 e5                	mov    %esp,%ebp
f010084a:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010084d:	8b 45 08             	mov    0x8(%ebp),%eax
f0100850:	e8 42 fc ff ff       	call   f0100497 <cons_putc>
}
f0100855:	c9                   	leave  
f0100856:	c3                   	ret    

f0100857 <getchar>:

int
getchar(void)
{
f0100857:	55                   	push   %ebp
f0100858:	89 e5                	mov    %esp,%ebp
f010085a:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010085d:	e8 56 fe ff ff       	call   f01006b8 <cons_getc>
f0100862:	85 c0                	test   %eax,%eax
f0100864:	74 f7                	je     f010085d <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100866:	c9                   	leave  
f0100867:	c3                   	ret    

f0100868 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100868:	b8 01 00 00 00       	mov    $0x1,%eax
f010086d:	c3                   	ret    

f010086e <mon_help>:
/***** Implementations of basic kernel monitor commands *****/
static long atol(const char *nptr);

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f010086e:	55                   	push   %ebp
f010086f:	89 e5                	mov    %esp,%ebp
f0100871:	53                   	push   %ebx
f0100872:	83 ec 04             	sub    $0x4,%esp
f0100875:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010087a:	83 ec 04             	sub    $0x4,%esp
f010087d:	ff b3 44 88 10 f0    	pushl  -0xfef77bc(%ebx)
f0100883:	ff b3 40 88 10 f0    	pushl  -0xfef77c0(%ebx)
f0100889:	68 e0 83 10 f0       	push   $0xf01083e0
f010088e:	e8 d2 39 00 00       	call   f0104265 <cprintf>
f0100893:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100896:	83 c4 10             	add    $0x10,%esp
f0100899:	83 fb 3c             	cmp    $0x3c,%ebx
f010089c:	75 dc                	jne    f010087a <mon_help+0xc>
	return 0;
}
f010089e:	b8 00 00 00 00       	mov    $0x0,%eax
f01008a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01008a6:	c9                   	leave  
f01008a7:	c3                   	ret    

f01008a8 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01008a8:	55                   	push   %ebp
f01008a9:	89 e5                	mov    %esp,%ebp
f01008ab:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01008ae:	68 e9 83 10 f0       	push   $0xf01083e9
f01008b3:	e8 ad 39 00 00       	call   f0104265 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01008b8:	83 c4 08             	add    $0x8,%esp
f01008bb:	68 0c 00 10 00       	push   $0x10000c
f01008c0:	68 4c 85 10 f0       	push   $0xf010854c
f01008c5:	e8 9b 39 00 00       	call   f0104265 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008ca:	83 c4 0c             	add    $0xc,%esp
f01008cd:	68 0c 00 10 00       	push   $0x10000c
f01008d2:	68 0c 00 10 f0       	push   $0xf010000c
f01008d7:	68 74 85 10 f0       	push   $0xf0108574
f01008dc:	e8 84 39 00 00       	call   f0104265 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01008e1:	83 c4 0c             	add    $0xc,%esp
f01008e4:	68 0f 80 10 00       	push   $0x10800f
f01008e9:	68 0f 80 10 f0       	push   $0xf010800f
f01008ee:	68 98 85 10 f0       	push   $0xf0108598
f01008f3:	e8 6d 39 00 00       	call   f0104265 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008f8:	83 c4 0c             	add    $0xc,%esp
f01008fb:	68 00 d7 5d 00       	push   $0x5dd700
f0100900:	68 00 d7 5d f0       	push   $0xf05dd700
f0100905:	68 bc 85 10 f0       	push   $0xf01085bc
f010090a:	e8 56 39 00 00       	call   f0104265 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010090f:	83 c4 0c             	add    $0xc,%esp
f0100912:	68 c0 db 6b 00       	push   $0x6bdbc0
f0100917:	68 c0 db 6b f0       	push   $0xf06bdbc0
f010091c:	68 e0 85 10 f0       	push   $0xf01085e0
f0100921:	e8 3f 39 00 00       	call   f0104265 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100926:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100929:	b8 c0 db 6b f0       	mov    $0xf06bdbc0,%eax
f010092e:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100933:	c1 f8 0a             	sar    $0xa,%eax
f0100936:	50                   	push   %eax
f0100937:	68 04 86 10 f0       	push   $0xf0108604
f010093c:	e8 24 39 00 00       	call   f0104265 <cprintf>
	return 0;
}
f0100941:	b8 00 00 00 00       	mov    $0x0,%eax
f0100946:	c9                   	leave  
f0100947:	c3                   	ret    

f0100948 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100948:	55                   	push   %ebp
f0100949:	89 e5                	mov    %esp,%ebp
f010094b:	56                   	push   %esi
f010094c:	53                   	push   %ebx
f010094d:	83 ec 20             	sub    $0x20,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100950:	89 eb                	mov    %ebp,%ebx
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
		debuginfo_eip(the_ebp[1], &info);
f0100952:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(the_ebp != NULL){
f0100955:	85 db                	test   %ebx,%ebx
f0100957:	0f 84 b3 00 00 00    	je     f0100a10 <mon_backtrace+0xc8>
		cprintf("the ebp1 0x%x\n", the_ebp[1]);
f010095d:	83 ec 08             	sub    $0x8,%esp
f0100960:	ff 73 04             	pushl  0x4(%ebx)
f0100963:	68 02 84 10 f0       	push   $0xf0108402
f0100968:	e8 f8 38 00 00       	call   f0104265 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f010096d:	83 c4 08             	add    $0x8,%esp
f0100970:	ff 73 08             	pushl  0x8(%ebx)
f0100973:	68 11 84 10 f0       	push   $0xf0108411
f0100978:	e8 e8 38 00 00       	call   f0104265 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f010097d:	83 c4 08             	add    $0x8,%esp
f0100980:	ff 73 0c             	pushl  0xc(%ebx)
f0100983:	68 20 84 10 f0       	push   $0xf0108420
f0100988:	e8 d8 38 00 00       	call   f0104265 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f010098d:	83 c4 08             	add    $0x8,%esp
f0100990:	ff 73 10             	pushl  0x10(%ebx)
f0100993:	68 2f 84 10 f0       	push   $0xf010842f
f0100998:	e8 c8 38 00 00       	call   f0104265 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f010099d:	83 c4 08             	add    $0x8,%esp
f01009a0:	ff 73 14             	pushl  0x14(%ebx)
f01009a3:	68 3e 84 10 f0       	push   $0xf010843e
f01009a8:	e8 b8 38 00 00       	call   f0104265 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f01009ad:	83 c4 08             	add    $0x8,%esp
f01009b0:	ff 73 18             	pushl  0x18(%ebx)
f01009b3:	68 4d 84 10 f0       	push   $0xf010844d
f01009b8:	e8 a8 38 00 00       	call   f0104265 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f01009bd:	ff 73 18             	pushl  0x18(%ebx)
f01009c0:	ff 73 14             	pushl  0x14(%ebx)
f01009c3:	ff 73 10             	pushl  0x10(%ebx)
f01009c6:	ff 73 0c             	pushl  0xc(%ebx)
f01009c9:	ff 73 08             	pushl  0x8(%ebx)
f01009cc:	53                   	push   %ebx
f01009cd:	ff 73 04             	pushl  0x4(%ebx)
f01009d0:	68 30 86 10 f0       	push   $0xf0108630
f01009d5:	e8 8b 38 00 00       	call   f0104265 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f01009da:	83 c4 28             	add    $0x28,%esp
f01009dd:	56                   	push   %esi
f01009de:	ff 73 04             	pushl  0x4(%ebx)
f01009e1:	e8 7a 52 00 00       	call   f0105c60 <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f01009e6:	83 c4 08             	add    $0x8,%esp
f01009e9:	8b 43 04             	mov    0x4(%ebx),%eax
f01009ec:	2b 45 f0             	sub    -0x10(%ebp),%eax
f01009ef:	50                   	push   %eax
f01009f0:	ff 75 e8             	pushl  -0x18(%ebp)
f01009f3:	ff 75 ec             	pushl  -0x14(%ebp)
f01009f6:	ff 75 e4             	pushl  -0x1c(%ebp)
f01009f9:	ff 75 e0             	pushl  -0x20(%ebp)
f01009fc:	68 5c 84 10 f0       	push   $0xf010845c
f0100a01:	e8 5f 38 00 00       	call   f0104265 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f0100a06:	8b 1b                	mov    (%ebx),%ebx
f0100a08:	83 c4 20             	add    $0x20,%esp
f0100a0b:	e9 45 ff ff ff       	jmp    f0100955 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f0100a10:	83 ec 0c             	sub    $0xc,%esp
f0100a13:	68 72 84 10 f0       	push   $0xf0108472
f0100a18:	e8 48 38 00 00       	call   f0104265 <cprintf>
	return 0;
}
f0100a1d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a25:	5b                   	pop    %ebx
f0100a26:	5e                   	pop    %esi
f0100a27:	5d                   	pop    %ebp
f0100a28:	c3                   	ret    

f0100a29 <mon_showmappings>:
	cycles_t end = currentcycles();
	cprintf("%s cycles: %ul\n", fun_n, end - start);
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f0100a29:	55                   	push   %ebp
f0100a2a:	89 e5                	mov    %esp,%ebp
f0100a2c:	57                   	push   %edi
f0100a2d:	56                   	push   %esi
f0100a2e:	53                   	push   %ebx
f0100a2f:	83 ec 2c             	sub    $0x2c,%esp
	if(argc != 3){
f0100a32:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100a36:	75 3f                	jne    f0100a77 <mon_showmappings+0x4e>
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
		return 0;
	}
	uint32_t low_va = 0, high_va = 0, old_va;
	if(argv[1][0]!='0'||argv[1][1]!='x'||argv[2][0]!='0'||argv[2][1]!='x'){
f0100a38:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a3b:	8b 40 04             	mov    0x4(%eax),%eax
f0100a3e:	80 38 30             	cmpb   $0x30,(%eax)
f0100a41:	75 17                	jne    f0100a5a <mon_showmappings+0x31>
f0100a43:	80 78 01 78          	cmpb   $0x78,0x1(%eax)
f0100a47:	75 11                	jne    f0100a5a <mon_showmappings+0x31>
f0100a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0100a4c:	8b 51 08             	mov    0x8(%ecx),%edx
f0100a4f:	80 3a 30             	cmpb   $0x30,(%edx)
f0100a52:	75 06                	jne    f0100a5a <mon_showmappings+0x31>
f0100a54:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0100a58:	74 34                	je     f0100a8e <mon_showmappings+0x65>
		cprintf("the virtual-address should be 16-base\n");
f0100a5a:	83 ec 0c             	sub    $0xc,%esp
f0100a5d:	68 a0 86 10 f0       	push   $0xf01086a0
f0100a62:	e8 fe 37 00 00       	call   f0104265 <cprintf>
		return 0;
f0100a67:	83 c4 10             	add    $0x10,%esp
		low_va += PTSIZE;
		if(low_va <= old_va)
			break;
    }
    return 0;
}
f0100a6a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a72:	5b                   	pop    %ebx
f0100a73:	5e                   	pop    %esi
f0100a74:	5f                   	pop    %edi
f0100a75:	5d                   	pop    %ebp
f0100a76:	c3                   	ret    
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
f0100a77:	83 ec 08             	sub    $0x8,%esp
f0100a7a:	68 20 88 10 f0       	push   $0xf0108820
f0100a7f:	68 64 86 10 f0       	push   $0xf0108664
f0100a84:	e8 dc 37 00 00       	call   f0104265 <cprintf>
		return 0;
f0100a89:	83 c4 10             	add    $0x10,%esp
f0100a8c:	eb dc                	jmp    f0100a6a <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f0100a8e:	83 ec 04             	sub    $0x4,%esp
f0100a91:	6a 10                	push   $0x10
f0100a93:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f0100a96:	56                   	push   %esi
f0100a97:	50                   	push   %eax
f0100a98:	e8 40 5f 00 00       	call   f01069dd <strtol>
f0100a9d:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a9f:	83 c4 0c             	add    $0xc,%esp
f0100aa2:	6a 10                	push   $0x10
f0100aa4:	56                   	push   %esi
f0100aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100aa8:	ff 70 08             	pushl  0x8(%eax)
f0100aab:	e8 2d 5f 00 00       	call   f01069dd <strtol>
	low_va = low_va/PGSIZE * PGSIZE;
f0100ab0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	high_va = high_va/PGSIZE * PGSIZE;
f0100ab6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100abb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(low_va > high_va){
f0100abe:	83 c4 10             	add    $0x10,%esp
f0100ac1:	39 c3                	cmp    %eax,%ebx
f0100ac3:	0f 86 1c 01 00 00    	jbe    f0100be5 <mon_showmappings+0x1bc>
		cprintf("the start-va should < the end-va\n");
f0100ac9:	83 ec 0c             	sub    $0xc,%esp
f0100acc:	68 c8 86 10 f0       	push   $0xf01086c8
f0100ad1:	e8 8f 37 00 00       	call   f0104265 <cprintf>
		return 0;
f0100ad6:	83 c4 10             	add    $0x10,%esp
f0100ad9:	eb 8f                	jmp    f0100a6a <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100adb:	83 ec 04             	sub    $0x4,%esp
f0100ade:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100ae4:	50                   	push   %eax
f0100ae5:	53                   	push   %ebx
f0100ae6:	68 85 84 10 f0       	push   $0xf0108485
f0100aeb:	e8 75 37 00 00       	call   f0104265 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100af0:	8b 06                	mov    (%esi),%eax
f0100af2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100af7:	83 c4 0c             	add    $0xc,%esp
f0100afa:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100b00:	52                   	push   %edx
f0100b01:	50                   	push   %eax
f0100b02:	68 94 84 10 f0       	push   $0xf0108494
f0100b07:	e8 59 37 00 00       	call   f0104265 <cprintf>
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b0c:	83 c4 0c             	add    $0xc,%esp
f0100b0f:	89 f8                	mov    %edi,%eax
f0100b11:	83 e0 01             	and    $0x1,%eax
f0100b14:	50                   	push   %eax
					u_bit = pte[PTX(low_va)] & PTE_U;
f0100b15:	89 f8                	mov    %edi,%eax
f0100b17:	83 e0 04             	and    $0x4,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b1a:	0f be c0             	movsbl %al,%eax
f0100b1d:	50                   	push   %eax
					w_bit = pte[PTX(low_va)] & PTE_W;
f0100b1e:	89 f8                	mov    %edi,%eax
f0100b20:	83 e0 02             	and    $0x2,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b23:	0f be c0             	movsbl %al,%eax
f0100b26:	50                   	push   %eax
					a_bit = pte[PTX(low_va)] & PTE_A;
f0100b27:	89 f8                	mov    %edi,%eax
f0100b29:	83 e0 20             	and    $0x20,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b2c:	0f be c0             	movsbl %al,%eax
f0100b2f:	50                   	push   %eax
					d_bit = pte[PTX(low_va)] & PTE_D;
f0100b30:	89 f8                	mov    %edi,%eax
f0100b32:	83 e0 40             	and    $0x40,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b35:	0f be c0             	movsbl %al,%eax
f0100b38:	50                   	push   %eax
f0100b39:	6a 00                	push   $0x0
f0100b3b:	68 a3 84 10 f0       	push   $0xf01084a3
f0100b40:	e8 20 37 00 00       	call   f0104265 <cprintf>
f0100b45:	83 c4 20             	add    $0x20,%esp
f0100b48:	e9 dc 00 00 00       	jmp    f0100c29 <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100b4d:	83 ec 04             	sub    $0x4,%esp
f0100b50:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100b56:	50                   	push   %eax
f0100b57:	53                   	push   %ebx
f0100b58:	68 85 84 10 f0       	push   $0xf0108485
f0100b5d:	e8 03 37 00 00       	call   f0104265 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100b62:	8b 07                	mov    (%edi),%eax
f0100b64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b69:	83 c4 0c             	add    $0xc,%esp
f0100b6c:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100b72:	52                   	push   %edx
f0100b73:	50                   	push   %eax
f0100b74:	68 94 84 10 f0       	push   $0xf0108494
f0100b79:	e8 e7 36 00 00       	call   f0104265 <cprintf>
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b7e:	83 c4 0c             	add    $0xc,%esp
f0100b81:	89 f0                	mov    %esi,%eax
f0100b83:	83 e0 01             	and    $0x1,%eax
f0100b86:	50                   	push   %eax
				u_bit = *pde & PTE_U;
f0100b87:	89 f0                	mov    %esi,%eax
f0100b89:	83 e0 04             	and    $0x4,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b8c:	0f be c0             	movsbl %al,%eax
f0100b8f:	50                   	push   %eax
				w_bit = *pde & PTE_W;
f0100b90:	89 f0                	mov    %esi,%eax
f0100b92:	83 e0 02             	and    $0x2,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b95:	0f be c0             	movsbl %al,%eax
f0100b98:	50                   	push   %eax
				a_bit = *pde & PTE_A;
f0100b99:	89 f0                	mov    %esi,%eax
f0100b9b:	83 e0 20             	and    $0x20,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b9e:	0f be c0             	movsbl %al,%eax
f0100ba1:	50                   	push   %eax
				d_bit = *pde & PTE_D;
f0100ba2:	89 f0                	mov    %esi,%eax
f0100ba4:	83 e0 40             	and    $0x40,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ba7:	0f be c0             	movsbl %al,%eax
f0100baa:	50                   	push   %eax
f0100bab:	6a 00                	push   $0x0
f0100bad:	68 a3 84 10 f0       	push   $0xf01084a3
f0100bb2:	e8 ae 36 00 00       	call   f0104265 <cprintf>
				low_va += PTSIZE;
f0100bb7:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
				if(low_va <= old_va)
f0100bbd:	83 c4 20             	add    $0x20,%esp
f0100bc0:	39 d8                	cmp    %ebx,%eax
f0100bc2:	0f 86 a2 fe ff ff    	jbe    f0100a6a <mon_showmappings+0x41>
				low_va += PTSIZE;
f0100bc8:	89 c3                	mov    %eax,%ebx
f0100bca:	eb 10                	jmp    f0100bdc <mon_showmappings+0x1b3>
		low_va += PTSIZE;
f0100bcc:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
		if(low_va <= old_va)
f0100bd2:	39 d8                	cmp    %ebx,%eax
f0100bd4:	0f 86 90 fe ff ff    	jbe    f0100a6a <mon_showmappings+0x41>
		low_va += PTSIZE;
f0100bda:	89 c3                	mov    %eax,%ebx
    while (low_va <= high_va) {
f0100bdc:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0100bdf:	0f 87 85 fe ff ff    	ja     f0100a6a <mon_showmappings+0x41>
        pde_t *pde = &kern_pgdir[PDX(low_va)];
f0100be5:	89 da                	mov    %ebx,%edx
f0100be7:	c1 ea 16             	shr    $0x16,%edx
f0100bea:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0100bef:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if (*pde) {
f0100bf2:	8b 37                	mov    (%edi),%esi
f0100bf4:	85 f6                	test   %esi,%esi
f0100bf6:	74 d4                	je     f0100bcc <mon_showmappings+0x1a3>
            if (low_va < (uint32_t)KERNBASE) {
f0100bf8:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100bfe:	0f 87 49 ff ff ff    	ja     f0100b4d <mon_showmappings+0x124>
                pte_t *pte = (pte_t*)(PTE_ADDR(*pde)+KERNBASE);
f0100c04:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
				if(pte[PTX(low_va)] & PTE_P){
f0100c0a:	89 d8                	mov    %ebx,%eax
f0100c0c:	c1 e8 0a             	shr    $0xa,%eax
f0100c0f:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100c14:	8d b4 06 00 00 00 f0 	lea    -0x10000000(%esi,%eax,1),%esi
f0100c1b:	8b 3e                	mov    (%esi),%edi
f0100c1d:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0100c23:	0f 85 b2 fe ff ff    	jne    f0100adb <mon_showmappings+0xb2>
				low_va += PGSIZE;
f0100c29:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
				if(low_va <= old_va)
f0100c2f:	39 d8                	cmp    %ebx,%eax
f0100c31:	0f 86 33 fe ff ff    	jbe    f0100a6a <mon_showmappings+0x41>
				low_va += PGSIZE;
f0100c37:	89 c3                	mov    %eax,%ebx
f0100c39:	eb a1                	jmp    f0100bdc <mon_showmappings+0x1b3>

f0100c3b <mon_time>:
mon_time(int argc, char **argv, struct Trapframe *tf){
f0100c3b:	55                   	push   %ebp
f0100c3c:	89 e5                	mov    %esp,%ebp
f0100c3e:	57                   	push   %edi
f0100c3f:	56                   	push   %esi
f0100c40:	53                   	push   %ebx
f0100c41:	83 ec 1c             	sub    $0x1c,%esp
f0100c44:	8b 45 0c             	mov    0xc(%ebp),%eax
	char *fun_n = argv[1];
f0100c47:	8b 78 04             	mov    0x4(%eax),%edi
	if(argc != 2)
f0100c4a:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100c4e:	0f 85 84 00 00 00    	jne    f0100cd8 <mon_time+0x9d>
	for(int i = 0; i < command_size; i++){
f0100c54:	bb 00 00 00 00       	mov    $0x0,%ebx
	cycles_t start = 0;
f0100c59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0100c60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100c67:	83 c0 08             	add    $0x8,%eax
f0100c6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100c6d:	eb 20                	jmp    f0100c8f <mon_time+0x54>
	}
}

cycles_t currentcycles() {
    cycles_t result;
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c6f:	0f 31                	rdtsc  
f0100c71:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100c74:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100c77:	83 ec 04             	sub    $0x4,%esp
f0100c7a:	ff 75 10             	pushl  0x10(%ebp)
f0100c7d:	ff 75 dc             	pushl  -0x24(%ebp)
f0100c80:	6a 00                	push   $0x0
f0100c82:	ff 14 b5 48 88 10 f0 	call   *-0xfef77b8(,%esi,4)
f0100c89:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100c8c:	83 c3 01             	add    $0x1,%ebx
f0100c8f:	39 1d 00 d3 16 f0    	cmp    %ebx,0xf016d300
f0100c95:	7e 1c                	jle    f0100cb3 <mon_time+0x78>
f0100c97:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c9a:	83 ec 08             	sub    $0x8,%esp
f0100c9d:	57                   	push   %edi
f0100c9e:	ff 34 b5 40 88 10 f0 	pushl  -0xfef77c0(,%esi,4)
f0100ca5:	e8 82 5b 00 00       	call   f010682c <strcmp>
f0100caa:	83 c4 10             	add    $0x10,%esp
f0100cad:	85 c0                	test   %eax,%eax
f0100caf:	75 db                	jne    f0100c8c <mon_time+0x51>
f0100cb1:	eb bc                	jmp    f0100c6f <mon_time+0x34>
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100cb3:	0f 31                	rdtsc  
	cprintf("%s cycles: %ul\n", fun_n, end - start);
f0100cb5:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100cb8:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
f0100cbb:	52                   	push   %edx
f0100cbc:	50                   	push   %eax
f0100cbd:	57                   	push   %edi
f0100cbe:	68 b6 84 10 f0       	push   $0xf01084b6
f0100cc3:	e8 9d 35 00 00       	call   f0104265 <cprintf>
	return 0;
f0100cc8:	83 c4 10             	add    $0x10,%esp
f0100ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100cd3:	5b                   	pop    %ebx
f0100cd4:	5e                   	pop    %esi
f0100cd5:	5f                   	pop    %edi
f0100cd6:	5d                   	pop    %ebp
f0100cd7:	c3                   	ret    
		return -1;
f0100cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100cdd:	eb f1                	jmp    f0100cd0 <mon_time+0x95>

f0100cdf <monitor>:
{
f0100cdf:	55                   	push   %ebp
f0100ce0:	89 e5                	mov    %esp,%ebp
f0100ce2:	57                   	push   %edi
f0100ce3:	56                   	push   %esi
f0100ce4:	53                   	push   %ebx
f0100ce5:	83 ec 58             	sub    $0x58,%esp
	cprintf("Welcome to the JOS kernel monitor!\n");
f0100ce8:	68 ec 86 10 f0       	push   $0xf01086ec
f0100ced:	e8 73 35 00 00       	call   f0104265 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100cf2:	c7 04 24 10 87 10 f0 	movl   $0xf0108710,(%esp)
f0100cf9:	e8 67 35 00 00       	call   f0104265 <cprintf>
	if (tf != NULL)
f0100cfe:	83 c4 10             	add    $0x10,%esp
f0100d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100d05:	0f 84 d9 00 00 00    	je     f0100de4 <monitor+0x105>
		print_trapframe(tf);
f0100d0b:	83 ec 0c             	sub    $0xc,%esp
f0100d0e:	ff 75 08             	pushl  0x8(%ebp)
f0100d11:	e8 ec 3c 00 00       	call   f0104a02 <print_trapframe>
f0100d16:	83 c4 10             	add    $0x10,%esp
f0100d19:	e9 c6 00 00 00       	jmp    f0100de4 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100d1e:	83 ec 08             	sub    $0x8,%esp
f0100d21:	0f be c0             	movsbl %al,%eax
f0100d24:	50                   	push   %eax
f0100d25:	68 ca 84 10 f0       	push   $0xf01084ca
f0100d2a:	e8 5b 5b 00 00       	call   f010688a <strchr>
f0100d2f:	83 c4 10             	add    $0x10,%esp
f0100d32:	85 c0                	test   %eax,%eax
f0100d34:	74 63                	je     f0100d99 <monitor+0xba>
			*buf++ = 0;
f0100d36:	c6 03 00             	movb   $0x0,(%ebx)
f0100d39:	89 f7                	mov    %esi,%edi
f0100d3b:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100d3e:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100d40:	0f b6 03             	movzbl (%ebx),%eax
f0100d43:	84 c0                	test   %al,%al
f0100d45:	75 d7                	jne    f0100d1e <monitor+0x3f>
	argv[argc] = 0;
f0100d47:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100d4e:	00 
	if (argc == 0)
f0100d4f:	85 f6                	test   %esi,%esi
f0100d51:	0f 84 8d 00 00 00    	je     f0100de4 <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100d57:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100d5c:	83 ec 08             	sub    $0x8,%esp
f0100d5f:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100d62:	ff 34 85 40 88 10 f0 	pushl  -0xfef77c0(,%eax,4)
f0100d69:	ff 75 a8             	pushl  -0x58(%ebp)
f0100d6c:	e8 bb 5a 00 00       	call   f010682c <strcmp>
f0100d71:	83 c4 10             	add    $0x10,%esp
f0100d74:	85 c0                	test   %eax,%eax
f0100d76:	0f 84 8f 00 00 00    	je     f0100e0b <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100d7c:	83 c3 01             	add    $0x1,%ebx
f0100d7f:	83 fb 05             	cmp    $0x5,%ebx
f0100d82:	75 d8                	jne    f0100d5c <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100d84:	83 ec 08             	sub    $0x8,%esp
f0100d87:	ff 75 a8             	pushl  -0x58(%ebp)
f0100d8a:	68 ec 84 10 f0       	push   $0xf01084ec
f0100d8f:	e8 d1 34 00 00       	call   f0104265 <cprintf>
f0100d94:	83 c4 10             	add    $0x10,%esp
f0100d97:	eb 4b                	jmp    f0100de4 <monitor+0x105>
		if (*buf == 0)
f0100d99:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100d9c:	74 a9                	je     f0100d47 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100d9e:	83 fe 0f             	cmp    $0xf,%esi
f0100da1:	74 2f                	je     f0100dd2 <monitor+0xf3>
		argv[argc++] = buf;
f0100da3:	8d 7e 01             	lea    0x1(%esi),%edi
f0100da6:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100daa:	0f b6 03             	movzbl (%ebx),%eax
f0100dad:	84 c0                	test   %al,%al
f0100daf:	74 8d                	je     f0100d3e <monitor+0x5f>
f0100db1:	83 ec 08             	sub    $0x8,%esp
f0100db4:	0f be c0             	movsbl %al,%eax
f0100db7:	50                   	push   %eax
f0100db8:	68 ca 84 10 f0       	push   $0xf01084ca
f0100dbd:	e8 c8 5a 00 00       	call   f010688a <strchr>
f0100dc2:	83 c4 10             	add    $0x10,%esp
f0100dc5:	85 c0                	test   %eax,%eax
f0100dc7:	0f 85 71 ff ff ff    	jne    f0100d3e <monitor+0x5f>
			buf++;
f0100dcd:	83 c3 01             	add    $0x1,%ebx
f0100dd0:	eb d8                	jmp    f0100daa <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100dd2:	83 ec 08             	sub    $0x8,%esp
f0100dd5:	6a 10                	push   $0x10
f0100dd7:	68 cf 84 10 f0       	push   $0xf01084cf
f0100ddc:	e8 84 34 00 00       	call   f0104265 <cprintf>
f0100de1:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100de4:	83 ec 0c             	sub    $0xc,%esp
f0100de7:	68 c6 84 10 f0       	push   $0xf01084c6
f0100dec:	e8 69 58 00 00       	call   f010665a <readline>
f0100df1:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100df3:	83 c4 10             	add    $0x10,%esp
f0100df6:	85 c0                	test   %eax,%eax
f0100df8:	74 ea                	je     f0100de4 <monitor+0x105>
	argv[argc] = 0;
f0100dfa:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100e01:	be 00 00 00 00       	mov    $0x0,%esi
f0100e06:	e9 35 ff ff ff       	jmp    f0100d40 <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100e0b:	83 ec 04             	sub    $0x4,%esp
f0100e0e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100e11:	ff 75 08             	pushl  0x8(%ebp)
f0100e14:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100e17:	52                   	push   %edx
f0100e18:	56                   	push   %esi
f0100e19:	ff 14 85 48 88 10 f0 	call   *-0xfef77b8(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100e20:	83 c4 10             	add    $0x10,%esp
f0100e23:	85 c0                	test   %eax,%eax
f0100e25:	79 bd                	jns    f0100de4 <monitor+0x105>
}
f0100e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e2a:	5b                   	pop    %ebx
f0100e2b:	5e                   	pop    %esi
f0100e2c:	5f                   	pop    %edi
f0100e2d:	5d                   	pop    %ebp
f0100e2e:	c3                   	ret    

f0100e2f <currentcycles>:
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100e2f:	0f 31                	rdtsc  
    return result;
}
f0100e31:	c3                   	ret    

f0100e32 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100e32:	55                   	push   %ebp
f0100e33:	89 e5                	mov    %esp,%ebp
f0100e35:	56                   	push   %esi
f0100e36:	53                   	push   %ebx
f0100e37:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100e39:	83 ec 0c             	sub    $0xc,%esp
f0100e3c:	50                   	push   %eax
f0100e3d:	e8 7c 32 00 00       	call   f01040be <mc146818_read>
f0100e42:	89 c3                	mov    %eax,%ebx
f0100e44:	83 c6 01             	add    $0x1,%esi
f0100e47:	89 34 24             	mov    %esi,(%esp)
f0100e4a:	e8 6f 32 00 00       	call   f01040be <mc146818_read>
f0100e4f:	c1 e0 08             	shl    $0x8,%eax
f0100e52:	09 d8                	or     %ebx,%eax
}
f0100e54:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100e57:	5b                   	pop    %ebx
f0100e58:	5e                   	pop    %esi
f0100e59:	5d                   	pop    %ebp
f0100e5a:	c3                   	ret    

f0100e5b <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100e5b:	89 d1                	mov    %edx,%ecx
f0100e5d:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100e60:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100e63:	a8 01                	test   $0x1,%al
f0100e65:	74 52                	je     f0100eb9 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100e67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100e6c:	89 c1                	mov    %eax,%ecx
f0100e6e:	c1 e9 0c             	shr    $0xc,%ecx
f0100e71:	3b 0d 88 ed 5d f0    	cmp    0xf05ded88,%ecx
f0100e77:	73 25                	jae    f0100e9e <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100e79:	c1 ea 0c             	shr    $0xc,%edx
f0100e7c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100e82:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100e89:	89 c2                	mov    %eax,%edx
f0100e8b:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100e8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e93:	85 d2                	test   %edx,%edx
f0100e95:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100e9a:	0f 44 c2             	cmove  %edx,%eax
f0100e9d:	c3                   	ret    
{
f0100e9e:	55                   	push   %ebp
f0100e9f:	89 e5                	mov    %esp,%ebp
f0100ea1:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ea4:	50                   	push   %eax
f0100ea5:	68 0c 81 10 f0       	push   $0xf010810c
f0100eaa:	68 b0 03 00 00       	push   $0x3b0
f0100eaf:	68 85 92 10 f0       	push   $0xf0109285
f0100eb4:	e8 90 f1 ff ff       	call   f0100049 <_panic>
		return ~0;
f0100eb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100ebe:	c3                   	ret    

f0100ebf <boot_alloc>:
{
f0100ebf:	55                   	push   %ebp
f0100ec0:	89 e5                	mov    %esp,%ebp
f0100ec2:	53                   	push   %ebx
f0100ec3:	83 ec 04             	sub    $0x4,%esp
	if (!nextfree) {
f0100ec6:	83 3d 38 d9 5d f0 00 	cmpl   $0x0,0xf05dd938
f0100ecd:	74 40                	je     f0100f0f <boot_alloc+0x50>
	if(!n)
f0100ecf:	85 c0                	test   %eax,%eax
f0100ed1:	74 65                	je     f0100f38 <boot_alloc+0x79>
f0100ed3:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100ed5:	a1 38 d9 5d f0       	mov    0xf05dd938,%eax
	if ((uint32_t)kva < KERNBASE)
f0100eda:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100edf:	76 5e                	jbe    f0100f3f <boot_alloc+0x80>
f0100ee1:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100ee8:	c1 e9 0c             	shr    $0xc,%ecx
f0100eeb:	83 c1 01             	add    $0x1,%ecx
f0100eee:	3b 0d 88 ed 5d f0    	cmp    0xf05ded88,%ecx
f0100ef4:	77 5b                	ja     f0100f51 <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100ef6:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100efc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100f02:	01 c2                	add    %eax,%edx
f0100f04:	89 15 38 d9 5d f0    	mov    %edx,0xf05dd938
}
f0100f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100f0d:	c9                   	leave  
f0100f0e:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100f0f:	b9 c0 db 6b f0       	mov    $0xf06bdbc0,%ecx
f0100f14:	ba bf eb 6b f0       	mov    $0xf06bebbf,%edx
f0100f19:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100f1f:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100f25:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100f2b:	85 c9                	test   %ecx,%ecx
f0100f2d:	0f 44 d3             	cmove  %ebx,%edx
f0100f30:	89 15 38 d9 5d f0    	mov    %edx,0xf05dd938
f0100f36:	eb 97                	jmp    f0100ecf <boot_alloc+0x10>
		return nextfree;
f0100f38:	a1 38 d9 5d f0       	mov    0xf05dd938,%eax
f0100f3d:	eb cb                	jmp    f0100f0a <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100f3f:	50                   	push   %eax
f0100f40:	68 30 81 10 f0       	push   $0xf0108130
f0100f45:	6a 73                	push   $0x73
f0100f47:	68 85 92 10 f0       	push   $0xf0109285
f0100f4c:	e8 f8 f0 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100f51:	83 ec 04             	sub    $0x4,%esp
f0100f54:	68 7c 88 10 f0       	push   $0xf010887c
f0100f59:	6a 74                	push   $0x74
f0100f5b:	68 85 92 10 f0       	push   $0xf0109285
f0100f60:	e8 e4 f0 ff ff       	call   f0100049 <_panic>

f0100f65 <check_page_free_list>:
{
f0100f65:	55                   	push   %ebp
f0100f66:	89 e5                	mov    %esp,%ebp
f0100f68:	57                   	push   %edi
f0100f69:	56                   	push   %esi
f0100f6a:	53                   	push   %ebx
f0100f6b:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f6e:	84 c0                	test   %al,%al
f0100f70:	0f 85 77 02 00 00    	jne    f01011ed <check_page_free_list+0x288>
	if (!page_free_list)
f0100f76:	83 3d 40 d9 5d f0 00 	cmpl   $0x0,0xf05dd940
f0100f7d:	74 0a                	je     f0100f89 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f7f:	be 00 04 00 00       	mov    $0x400,%esi
f0100f84:	e9 bf 02 00 00       	jmp    f0101248 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100f89:	83 ec 04             	sub    $0x4,%esp
f0100f8c:	68 b4 88 10 f0       	push   $0xf01088b4
f0100f91:	68 e0 02 00 00       	push   $0x2e0
f0100f96:	68 85 92 10 f0       	push   $0xf0109285
f0100f9b:	e8 a9 f0 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100fa0:	50                   	push   %eax
f0100fa1:	68 0c 81 10 f0       	push   $0xf010810c
f0100fa6:	6a 58                	push   $0x58
f0100fa8:	68 91 92 10 f0       	push   $0xf0109291
f0100fad:	e8 97 f0 ff ff       	call   f0100049 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0100fb2:	8b 1b                	mov    (%ebx),%ebx
f0100fb4:	85 db                	test   %ebx,%ebx
f0100fb6:	74 41                	je     f0100ff9 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100fb8:	89 d8                	mov    %ebx,%eax
f0100fba:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0100fc0:	c1 f8 03             	sar    $0x3,%eax
f0100fc3:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100fc6:	89 c2                	mov    %eax,%edx
f0100fc8:	c1 ea 16             	shr    $0x16,%edx
f0100fcb:	39 f2                	cmp    %esi,%edx
f0100fcd:	73 e3                	jae    f0100fb2 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100fcf:	89 c2                	mov    %eax,%edx
f0100fd1:	c1 ea 0c             	shr    $0xc,%edx
f0100fd4:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0100fda:	73 c4                	jae    f0100fa0 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100fdc:	83 ec 04             	sub    $0x4,%esp
f0100fdf:	68 80 00 00 00       	push   $0x80
f0100fe4:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100fe9:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100fee:	50                   	push   %eax
f0100fef:	e8 d3 58 00 00       	call   f01068c7 <memset>
f0100ff4:	83 c4 10             	add    $0x10,%esp
f0100ff7:	eb b9                	jmp    f0100fb2 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100ff9:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ffe:	e8 bc fe ff ff       	call   f0100ebf <boot_alloc>
f0101003:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101006:	8b 15 40 d9 5d f0    	mov    0xf05dd940,%edx
		assert(pp >= pages);
f010100c:	8b 0d 90 ed 5d f0    	mov    0xf05ded90,%ecx
		assert(pp < pages + npages);
f0101012:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f0101017:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010101a:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f010101d:	bf 00 00 00 00       	mov    $0x0,%edi
f0101022:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101025:	e9 f9 00 00 00       	jmp    f0101123 <check_page_free_list+0x1be>
		assert(pp >= pages);
f010102a:	68 9f 92 10 f0       	push   $0xf010929f
f010102f:	68 ab 92 10 f0       	push   $0xf01092ab
f0101034:	68 f9 02 00 00       	push   $0x2f9
f0101039:	68 85 92 10 f0       	push   $0xf0109285
f010103e:	e8 06 f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0101043:	68 c0 92 10 f0       	push   $0xf01092c0
f0101048:	68 ab 92 10 f0       	push   $0xf01092ab
f010104d:	68 fa 02 00 00       	push   $0x2fa
f0101052:	68 85 92 10 f0       	push   $0xf0109285
f0101057:	e8 ed ef ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010105c:	68 d8 88 10 f0       	push   $0xf01088d8
f0101061:	68 ab 92 10 f0       	push   $0xf01092ab
f0101066:	68 fb 02 00 00       	push   $0x2fb
f010106b:	68 85 92 10 f0       	push   $0xf0109285
f0101070:	e8 d4 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0101075:	68 d4 92 10 f0       	push   $0xf01092d4
f010107a:	68 ab 92 10 f0       	push   $0xf01092ab
f010107f:	68 fe 02 00 00       	push   $0x2fe
f0101084:	68 85 92 10 f0       	push   $0xf0109285
f0101089:	e8 bb ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f010108e:	68 e5 92 10 f0       	push   $0xf01092e5
f0101093:	68 ab 92 10 f0       	push   $0xf01092ab
f0101098:	68 ff 02 00 00       	push   $0x2ff
f010109d:	68 85 92 10 f0       	push   $0xf0109285
f01010a2:	e8 a2 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f01010a7:	68 0c 89 10 f0       	push   $0xf010890c
f01010ac:	68 ab 92 10 f0       	push   $0xf01092ab
f01010b1:	68 00 03 00 00       	push   $0x300
f01010b6:	68 85 92 10 f0       	push   $0xf0109285
f01010bb:	e8 89 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f01010c0:	68 fe 92 10 f0       	push   $0xf01092fe
f01010c5:	68 ab 92 10 f0       	push   $0xf01092ab
f01010ca:	68 01 03 00 00       	push   $0x301
f01010cf:	68 85 92 10 f0       	push   $0xf0109285
f01010d4:	e8 70 ef ff ff       	call   f0100049 <_panic>
	if (PGNUM(pa) >= npages)
f01010d9:	89 c3                	mov    %eax,%ebx
f01010db:	c1 eb 0c             	shr    $0xc,%ebx
f01010de:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f01010e1:	76 0f                	jbe    f01010f2 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f01010e3:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01010e8:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01010eb:	77 17                	ja     f0101104 <check_page_free_list+0x19f>
			++nfree_extmem;
f01010ed:	83 c7 01             	add    $0x1,%edi
f01010f0:	eb 2f                	jmp    f0101121 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010f2:	50                   	push   %eax
f01010f3:	68 0c 81 10 f0       	push   $0xf010810c
f01010f8:	6a 58                	push   $0x58
f01010fa:	68 91 92 10 f0       	push   $0xf0109291
f01010ff:	e8 45 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101104:	68 30 89 10 f0       	push   $0xf0108930
f0101109:	68 ab 92 10 f0       	push   $0xf01092ab
f010110e:	68 02 03 00 00       	push   $0x302
f0101113:	68 85 92 10 f0       	push   $0xf0109285
f0101118:	e8 2c ef ff ff       	call   f0100049 <_panic>
			++nfree_basemem;
f010111d:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101121:	8b 12                	mov    (%edx),%edx
f0101123:	85 d2                	test   %edx,%edx
f0101125:	74 74                	je     f010119b <check_page_free_list+0x236>
		assert(pp >= pages);
f0101127:	39 d1                	cmp    %edx,%ecx
f0101129:	0f 87 fb fe ff ff    	ja     f010102a <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f010112f:	39 d6                	cmp    %edx,%esi
f0101131:	0f 86 0c ff ff ff    	jbe    f0101043 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101137:	89 d0                	mov    %edx,%eax
f0101139:	29 c8                	sub    %ecx,%eax
f010113b:	a8 07                	test   $0x7,%al
f010113d:	0f 85 19 ff ff ff    	jne    f010105c <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0101143:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0101146:	c1 e0 0c             	shl    $0xc,%eax
f0101149:	0f 84 26 ff ff ff    	je     f0101075 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f010114f:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101154:	0f 84 34 ff ff ff    	je     f010108e <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f010115a:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f010115f:	0f 84 42 ff ff ff    	je     f01010a7 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101165:	3d 00 00 10 00       	cmp    $0x100000,%eax
f010116a:	0f 84 50 ff ff ff    	je     f01010c0 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101170:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101175:	0f 87 5e ff ff ff    	ja     f01010d9 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f010117b:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0101180:	75 9b                	jne    f010111d <check_page_free_list+0x1b8>
f0101182:	68 18 93 10 f0       	push   $0xf0109318
f0101187:	68 ab 92 10 f0       	push   $0xf01092ab
f010118c:	68 04 03 00 00       	push   $0x304
f0101191:	68 85 92 10 f0       	push   $0xf0109285
f0101196:	e8 ae ee ff ff       	call   f0100049 <_panic>
f010119b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f010119e:	85 db                	test   %ebx,%ebx
f01011a0:	7e 19                	jle    f01011bb <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f01011a2:	85 ff                	test   %edi,%edi
f01011a4:	7e 2e                	jle    f01011d4 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f01011a6:	83 ec 0c             	sub    $0xc,%esp
f01011a9:	68 78 89 10 f0       	push   $0xf0108978
f01011ae:	e8 b2 30 00 00       	call   f0104265 <cprintf>
}
f01011b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01011b6:	5b                   	pop    %ebx
f01011b7:	5e                   	pop    %esi
f01011b8:	5f                   	pop    %edi
f01011b9:	5d                   	pop    %ebp
f01011ba:	c3                   	ret    
	assert(nfree_basemem > 0);
f01011bb:	68 35 93 10 f0       	push   $0xf0109335
f01011c0:	68 ab 92 10 f0       	push   $0xf01092ab
f01011c5:	68 0b 03 00 00       	push   $0x30b
f01011ca:	68 85 92 10 f0       	push   $0xf0109285
f01011cf:	e8 75 ee ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f01011d4:	68 47 93 10 f0       	push   $0xf0109347
f01011d9:	68 ab 92 10 f0       	push   $0xf01092ab
f01011de:	68 0c 03 00 00       	push   $0x30c
f01011e3:	68 85 92 10 f0       	push   $0xf0109285
f01011e8:	e8 5c ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f01011ed:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f01011f2:	85 c0                	test   %eax,%eax
f01011f4:	0f 84 8f fd ff ff    	je     f0100f89 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f01011fa:	8d 55 d8             	lea    -0x28(%ebp),%edx
f01011fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101200:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101203:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101206:	89 c2                	mov    %eax,%edx
f0101208:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f010120e:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0101214:	0f 95 c2             	setne  %dl
f0101217:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f010121a:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f010121e:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0101220:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101224:	8b 00                	mov    (%eax),%eax
f0101226:	85 c0                	test   %eax,%eax
f0101228:	75 dc                	jne    f0101206 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f010122a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101233:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101236:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101239:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f010123b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010123e:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101243:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0101248:	8b 1d 40 d9 5d f0    	mov    0xf05dd940,%ebx
f010124e:	e9 61 fd ff ff       	jmp    f0100fb4 <check_page_free_list+0x4f>

f0101253 <page_init>:
{
f0101253:	55                   	push   %ebp
f0101254:	89 e5                	mov    %esp,%ebp
f0101256:	53                   	push   %ebx
f0101257:	83 ec 04             	sub    $0x4,%esp
	for (size_t i = 0; i < npages; i++) {
f010125a:	bb 00 00 00 00       	mov    $0x0,%ebx
f010125f:	eb 4c                	jmp    f01012ad <page_init+0x5a>
		else if(i == MPENTRY_PADDR/PGSIZE){
f0101261:	83 fb 07             	cmp    $0x7,%ebx
f0101264:	74 32                	je     f0101298 <page_init+0x45>
		else if(i < IOPHYSMEM/PGSIZE){ //[PGSIZE, npages_basemem * PGSIZE)
f0101266:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f010126c:	77 62                	ja     f01012d0 <page_init+0x7d>
f010126e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f0101275:	89 c2                	mov    %eax,%edx
f0101277:	03 15 90 ed 5d f0    	add    0xf05ded90,%edx
f010127d:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101283:	8b 0d 40 d9 5d f0    	mov    0xf05dd940,%ecx
f0101289:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f010128b:	03 05 90 ed 5d f0    	add    0xf05ded90,%eax
f0101291:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
f0101296:	eb 12                	jmp    f01012aa <page_init+0x57>
			pages[i].pp_ref = 1;
f0101298:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f010129d:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f01012a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f01012aa:	83 c3 01             	add    $0x1,%ebx
f01012ad:	39 1d 88 ed 5d f0    	cmp    %ebx,0xf05ded88
f01012b3:	0f 86 94 00 00 00    	jbe    f010134d <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f01012b9:	85 db                	test   %ebx,%ebx
f01012bb:	75 a4                	jne    f0101261 <page_init+0xe>
			pages[i].pp_ref = 1;
f01012bd:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f01012c2:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f01012c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01012ce:	eb da                	jmp    f01012aa <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f01012d0:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01012d6:	77 16                	ja     f01012ee <page_init+0x9b>
			pages[i].pp_ref = 1;
f01012d8:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f01012dd:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
f01012e0:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f01012e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01012ec:	eb bc                	jmp    f01012aa <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f01012ee:	b8 00 00 00 00       	mov    $0x0,%eax
f01012f3:	e8 c7 fb ff ff       	call   f0100ebf <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f01012f8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01012fd:	76 39                	jbe    f0101338 <page_init+0xe5>
	return (physaddr_t)kva - KERNBASE;
f01012ff:	05 00 00 00 10       	add    $0x10000000,%eax
f0101304:	c1 e8 0c             	shr    $0xc,%eax
f0101307:	39 d8                	cmp    %ebx,%eax
f0101309:	77 cd                	ja     f01012d8 <page_init+0x85>
f010130b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f0101312:	89 c2                	mov    %eax,%edx
f0101314:	03 15 90 ed 5d f0    	add    0xf05ded90,%edx
f010131a:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101320:	8b 0d 40 d9 5d f0    	mov    0xf05dd940,%ecx
f0101326:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f0101328:	03 05 90 ed 5d f0    	add    0xf05ded90,%eax
f010132e:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
f0101333:	e9 72 ff ff ff       	jmp    f01012aa <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101338:	50                   	push   %eax
f0101339:	68 30 81 10 f0       	push   $0xf0108130
f010133e:	68 50 01 00 00       	push   $0x150
f0101343:	68 85 92 10 f0       	push   $0xf0109285
f0101348:	e8 fc ec ff ff       	call   f0100049 <_panic>
}
f010134d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101350:	c9                   	leave  
f0101351:	c3                   	ret    

f0101352 <page_alloc>:
{
f0101352:	55                   	push   %ebp
f0101353:	89 e5                	mov    %esp,%ebp
f0101355:	53                   	push   %ebx
f0101356:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list)
f0101359:	8b 1d 40 d9 5d f0    	mov    0xf05dd940,%ebx
f010135f:	85 db                	test   %ebx,%ebx
f0101361:	74 13                	je     f0101376 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f0101363:	8b 03                	mov    (%ebx),%eax
f0101365:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
	result->pp_link = NULL;
f010136a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f0101370:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101374:	75 07                	jne    f010137d <page_alloc+0x2b>
}
f0101376:	89 d8                	mov    %ebx,%eax
f0101378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010137b:	c9                   	leave  
f010137c:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f010137d:	89 d8                	mov    %ebx,%eax
f010137f:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0101385:	c1 f8 03             	sar    $0x3,%eax
f0101388:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010138b:	89 c2                	mov    %eax,%edx
f010138d:	c1 ea 0c             	shr    $0xc,%edx
f0101390:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0101396:	73 1a                	jae    f01013b2 <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f0101398:	83 ec 04             	sub    $0x4,%esp
f010139b:	68 00 10 00 00       	push   $0x1000
f01013a0:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01013a2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01013a7:	50                   	push   %eax
f01013a8:	e8 1a 55 00 00       	call   f01068c7 <memset>
f01013ad:	83 c4 10             	add    $0x10,%esp
f01013b0:	eb c4                	jmp    f0101376 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01013b2:	50                   	push   %eax
f01013b3:	68 0c 81 10 f0       	push   $0xf010810c
f01013b8:	6a 58                	push   $0x58
f01013ba:	68 91 92 10 f0       	push   $0xf0109291
f01013bf:	e8 85 ec ff ff       	call   f0100049 <_panic>

f01013c4 <page_free>:
{
f01013c4:	55                   	push   %ebp
f01013c5:	89 e5                	mov    %esp,%ebp
f01013c7:	83 ec 08             	sub    $0x8,%esp
f01013ca:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0 || pp->pp_link != NULL){
f01013cd:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01013d2:	75 14                	jne    f01013e8 <page_free+0x24>
f01013d4:	83 38 00             	cmpl   $0x0,(%eax)
f01013d7:	75 0f                	jne    f01013e8 <page_free+0x24>
	pp->pp_link = page_free_list;
f01013d9:	8b 15 40 d9 5d f0    	mov    0xf05dd940,%edx
f01013df:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f01013e1:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
}
f01013e6:	c9                   	leave  
f01013e7:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f01013e8:	83 ec 04             	sub    $0x4,%esp
f01013eb:	68 9c 89 10 f0       	push   $0xf010899c
f01013f0:	68 84 01 00 00       	push   $0x184
f01013f5:	68 85 92 10 f0       	push   $0xf0109285
f01013fa:	e8 4a ec ff ff       	call   f0100049 <_panic>

f01013ff <page_decref>:
{
f01013ff:	55                   	push   %ebp
f0101400:	89 e5                	mov    %esp,%ebp
f0101402:	83 ec 08             	sub    $0x8,%esp
f0101405:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101408:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010140c:	83 e8 01             	sub    $0x1,%eax
f010140f:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101413:	66 85 c0             	test   %ax,%ax
f0101416:	74 02                	je     f010141a <page_decref+0x1b>
}
f0101418:	c9                   	leave  
f0101419:	c3                   	ret    
		page_free(pp);
f010141a:	83 ec 0c             	sub    $0xc,%esp
f010141d:	52                   	push   %edx
f010141e:	e8 a1 ff ff ff       	call   f01013c4 <page_free>
f0101423:	83 c4 10             	add    $0x10,%esp
}
f0101426:	eb f0                	jmp    f0101418 <page_decref+0x19>

f0101428 <pgdir_walk>:
{
f0101428:	55                   	push   %ebp
f0101429:	89 e5                	mov    %esp,%ebp
f010142b:	56                   	push   %esi
f010142c:	53                   	push   %ebx
f010142d:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *fir_level = &pgdir[PDX(va)];
f0101430:	89 f3                	mov    %esi,%ebx
f0101432:	c1 eb 16             	shr    $0x16,%ebx
f0101435:	c1 e3 02             	shl    $0x2,%ebx
f0101438:	03 5d 08             	add    0x8(%ebp),%ebx
	if(*fir_level==0 && create == false){
f010143b:	8b 03                	mov    (%ebx),%eax
f010143d:	89 c1                	mov    %eax,%ecx
f010143f:	0b 4d 10             	or     0x10(%ebp),%ecx
f0101442:	0f 84 a8 00 00 00    	je     f01014f0 <pgdir_walk+0xc8>
	else if(*fir_level==0){
f0101448:	85 c0                	test   %eax,%eax
f010144a:	74 29                	je     f0101475 <pgdir_walk+0x4d>
		sec_level = (pte_t *)(KADDR(PTE_ADDR(*fir_level)));
f010144c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101451:	89 c2                	mov    %eax,%edx
f0101453:	c1 ea 0c             	shr    $0xc,%edx
f0101456:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f010145c:	73 7d                	jae    f01014db <pgdir_walk+0xb3>
		return &sec_level[PTX(va)];
f010145e:	c1 ee 0a             	shr    $0xa,%esi
f0101461:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101467:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f010146e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101471:	5b                   	pop    %ebx
f0101472:	5e                   	pop    %esi
f0101473:	5d                   	pop    %ebp
f0101474:	c3                   	ret    
		struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
f0101475:	83 ec 0c             	sub    $0xc,%esp
f0101478:	6a 01                	push   $0x1
f010147a:	e8 d3 fe ff ff       	call   f0101352 <page_alloc>
		if(new_page == NULL)
f010147f:	83 c4 10             	add    $0x10,%esp
f0101482:	85 c0                	test   %eax,%eax
f0101484:	74 e8                	je     f010146e <pgdir_walk+0x46>
		new_page->pp_ref++;
f0101486:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010148b:	89 c2                	mov    %eax,%edx
f010148d:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0101493:	c1 fa 03             	sar    $0x3,%edx
f0101496:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f0101499:	83 ca 07             	or     $0x7,%edx
f010149c:	89 13                	mov    %edx,(%ebx)
f010149e:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01014a4:	c1 f8 03             	sar    $0x3,%eax
f01014a7:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01014aa:	89 c2                	mov    %eax,%edx
f01014ac:	c1 ea 0c             	shr    $0xc,%edx
f01014af:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f01014b5:	73 12                	jae    f01014c9 <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f01014b7:	c1 ee 0a             	shr    $0xa,%esi
f01014ba:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01014c0:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f01014c7:	eb a5                	jmp    f010146e <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01014c9:	50                   	push   %eax
f01014ca:	68 0c 81 10 f0       	push   $0xf010810c
f01014cf:	6a 58                	push   $0x58
f01014d1:	68 91 92 10 f0       	push   $0xf0109291
f01014d6:	e8 6e eb ff ff       	call   f0100049 <_panic>
f01014db:	50                   	push   %eax
f01014dc:	68 0c 81 10 f0       	push   $0xf010810c
f01014e1:	68 be 01 00 00       	push   $0x1be
f01014e6:	68 85 92 10 f0       	push   $0xf0109285
f01014eb:	e8 59 eb ff ff       	call   f0100049 <_panic>
		return NULL;
f01014f0:	b8 00 00 00 00       	mov    $0x0,%eax
f01014f5:	e9 74 ff ff ff       	jmp    f010146e <pgdir_walk+0x46>

f01014fa <boot_map_region>:
{
f01014fa:	55                   	push   %ebp
f01014fb:	89 e5                	mov    %esp,%ebp
f01014fd:	57                   	push   %edi
f01014fe:	56                   	push   %esi
f01014ff:	53                   	push   %ebx
f0101500:	83 ec 1c             	sub    $0x1c,%esp
f0101503:	89 c7                	mov    %eax,%edi
f0101505:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(va%PGSIZE==0);
f0101508:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010150e:	75 4b                	jne    f010155b <boot_map_region+0x61>
	assert(pa%PGSIZE==0);
f0101510:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0101515:	75 5d                	jne    f0101574 <boot_map_region+0x7a>
f0101517:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010151d:	01 c1                	add    %eax,%ecx
f010151f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0101522:	89 c3                	mov    %eax,%ebx
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f0101524:	89 d6                	mov    %edx,%esi
f0101526:	29 c6                	sub    %eax,%esi
	for(int i = 0; i < size/PGSIZE; i++){
f0101528:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010152b:	74 79                	je     f01015a6 <boot_map_region+0xac>
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f010152d:	83 ec 04             	sub    $0x4,%esp
f0101530:	6a 01                	push   $0x1
f0101532:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f0101535:	50                   	push   %eax
f0101536:	57                   	push   %edi
f0101537:	e8 ec fe ff ff       	call   f0101428 <pgdir_walk>
		if(the_pte==NULL)
f010153c:	83 c4 10             	add    $0x10,%esp
f010153f:	85 c0                	test   %eax,%eax
f0101541:	74 4a                	je     f010158d <boot_map_region+0x93>
		*the_pte = PTE_ADDR(pa) | perm | PTE_P;
f0101543:	89 da                	mov    %ebx,%edx
f0101545:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010154b:	0b 55 0c             	or     0xc(%ebp),%edx
f010154e:	83 ca 01             	or     $0x1,%edx
f0101551:	89 10                	mov    %edx,(%eax)
		pa+=PGSIZE;
f0101553:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101559:	eb cd                	jmp    f0101528 <boot_map_region+0x2e>
	assert(va%PGSIZE==0);
f010155b:	68 58 93 10 f0       	push   $0xf0109358
f0101560:	68 ab 92 10 f0       	push   $0xf01092ab
f0101565:	68 d3 01 00 00       	push   $0x1d3
f010156a:	68 85 92 10 f0       	push   $0xf0109285
f010156f:	e8 d5 ea ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f0101574:	68 65 93 10 f0       	push   $0xf0109365
f0101579:	68 ab 92 10 f0       	push   $0xf01092ab
f010157e:	68 d4 01 00 00       	push   $0x1d4
f0101583:	68 85 92 10 f0       	push   $0xf0109285
f0101588:	e8 bc ea ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f010158d:	68 18 96 10 f0       	push   $0xf0109618
f0101592:	68 72 93 10 f0       	push   $0xf0109372
f0101597:	68 d8 01 00 00       	push   $0x1d8
f010159c:	68 85 92 10 f0       	push   $0xf0109285
f01015a1:	e8 a3 ea ff ff       	call   f0100049 <_panic>
}
f01015a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01015a9:	5b                   	pop    %ebx
f01015aa:	5e                   	pop    %esi
f01015ab:	5f                   	pop    %edi
f01015ac:	5d                   	pop    %ebp
f01015ad:	c3                   	ret    

f01015ae <page_lookup>:
{
f01015ae:	55                   	push   %ebp
f01015af:	89 e5                	mov    %esp,%ebp
f01015b1:	53                   	push   %ebx
f01015b2:	83 ec 08             	sub    $0x8,%esp
f01015b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *look_mapping = pgdir_walk(pgdir, va, 0);
f01015b8:	6a 00                	push   $0x0
f01015ba:	ff 75 0c             	pushl  0xc(%ebp)
f01015bd:	ff 75 08             	pushl  0x8(%ebp)
f01015c0:	e8 63 fe ff ff       	call   f0101428 <pgdir_walk>
	if(look_mapping == NULL)
f01015c5:	83 c4 10             	add    $0x10,%esp
f01015c8:	85 c0                	test   %eax,%eax
f01015ca:	74 27                	je     f01015f3 <page_lookup+0x45>
	if(*look_mapping==0)
f01015cc:	8b 10                	mov    (%eax),%edx
f01015ce:	85 d2                	test   %edx,%edx
f01015d0:	74 3a                	je     f010160c <page_lookup+0x5e>
	if(pte_store!=NULL && (*look_mapping&PTE_P))
f01015d2:	85 db                	test   %ebx,%ebx
f01015d4:	74 07                	je     f01015dd <page_lookup+0x2f>
f01015d6:	f6 c2 01             	test   $0x1,%dl
f01015d9:	74 02                	je     f01015dd <page_lookup+0x2f>
		*pte_store = look_mapping;
f01015db:	89 03                	mov    %eax,(%ebx)
f01015dd:	8b 00                	mov    (%eax),%eax
f01015df:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01015e2:	39 05 88 ed 5d f0    	cmp    %eax,0xf05ded88
f01015e8:	76 0e                	jbe    f01015f8 <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01015ea:	8b 15 90 ed 5d f0    	mov    0xf05ded90,%edx
f01015f0:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f01015f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01015f6:	c9                   	leave  
f01015f7:	c3                   	ret    
		panic("pa2page called with invalid pa");
f01015f8:	83 ec 04             	sub    $0x4,%esp
f01015fb:	68 d0 89 10 f0       	push   $0xf01089d0
f0101600:	6a 51                	push   $0x51
f0101602:	68 91 92 10 f0       	push   $0xf0109291
f0101607:	e8 3d ea ff ff       	call   f0100049 <_panic>
		return NULL;
f010160c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101611:	eb e0                	jmp    f01015f3 <page_lookup+0x45>

f0101613 <tlb_invalidate>:
{
f0101613:	55                   	push   %ebp
f0101614:	89 e5                	mov    %esp,%ebp
f0101616:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101619:	e8 f9 fe 01 00       	call   f0121517 <cpunum>
f010161e:	6b c0 74             	imul   $0x74,%eax,%eax
f0101621:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0101628:	74 16                	je     f0101640 <tlb_invalidate+0x2d>
f010162a:	e8 e8 fe 01 00       	call   f0121517 <cpunum>
f010162f:	6b c0 74             	imul   $0x74,%eax,%eax
f0101632:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0101638:	8b 55 08             	mov    0x8(%ebp),%edx
f010163b:	39 50 60             	cmp    %edx,0x60(%eax)
f010163e:	75 06                	jne    f0101646 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101640:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101643:	0f 01 38             	invlpg (%eax)
}
f0101646:	c9                   	leave  
f0101647:	c3                   	ret    

f0101648 <page_remove>:
{
f0101648:	55                   	push   %ebp
f0101649:	89 e5                	mov    %esp,%ebp
f010164b:	56                   	push   %esi
f010164c:	53                   	push   %ebx
f010164d:	83 ec 14             	sub    $0x14,%esp
f0101650:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101653:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *the_page = page_lookup(pgdir, va, &pg_store);
f0101656:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101659:	50                   	push   %eax
f010165a:	56                   	push   %esi
f010165b:	53                   	push   %ebx
f010165c:	e8 4d ff ff ff       	call   f01015ae <page_lookup>
	if(!the_page)
f0101661:	83 c4 10             	add    $0x10,%esp
f0101664:	85 c0                	test   %eax,%eax
f0101666:	74 1f                	je     f0101687 <page_remove+0x3f>
	page_decref(the_page);
f0101668:	83 ec 0c             	sub    $0xc,%esp
f010166b:	50                   	push   %eax
f010166c:	e8 8e fd ff ff       	call   f01013ff <page_decref>
	*pg_store = 0;
f0101671:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f010167a:	83 c4 08             	add    $0x8,%esp
f010167d:	56                   	push   %esi
f010167e:	53                   	push   %ebx
f010167f:	e8 8f ff ff ff       	call   f0101613 <tlb_invalidate>
f0101684:	83 c4 10             	add    $0x10,%esp
}
f0101687:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010168a:	5b                   	pop    %ebx
f010168b:	5e                   	pop    %esi
f010168c:	5d                   	pop    %ebp
f010168d:	c3                   	ret    

f010168e <page_insert>:
{
f010168e:	55                   	push   %ebp
f010168f:	89 e5                	mov    %esp,%ebp
f0101691:	57                   	push   %edi
f0101692:	56                   	push   %esi
f0101693:	53                   	push   %ebx
f0101694:	83 ec 10             	sub    $0x10,%esp
f0101697:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *the_pte = pgdir_walk(pgdir, va, 1);
f010169a:	6a 01                	push   $0x1
f010169c:	ff 75 10             	pushl  0x10(%ebp)
f010169f:	ff 75 08             	pushl  0x8(%ebp)
f01016a2:	e8 81 fd ff ff       	call   f0101428 <pgdir_walk>
	if(the_pte == NULL){
f01016a7:	83 c4 10             	add    $0x10,%esp
f01016aa:	85 c0                	test   %eax,%eax
f01016ac:	0f 84 b7 00 00 00    	je     f0101769 <page_insert+0xdb>
f01016b2:	89 c6                	mov    %eax,%esi
		if(KADDR(PTE_ADDR(*the_pte)) == page2kva(pp)){
f01016b4:	8b 10                	mov    (%eax),%edx
f01016b6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f01016bc:	8b 0d 88 ed 5d f0    	mov    0xf05ded88,%ecx
f01016c2:	89 d0                	mov    %edx,%eax
f01016c4:	c1 e8 0c             	shr    $0xc,%eax
f01016c7:	39 c1                	cmp    %eax,%ecx
f01016c9:	76 5f                	jbe    f010172a <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f01016cb:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f01016d1:	89 d8                	mov    %ebx,%eax
f01016d3:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01016d9:	c1 f8 03             	sar    $0x3,%eax
f01016dc:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01016df:	89 c7                	mov    %eax,%edi
f01016e1:	c1 ef 0c             	shr    $0xc,%edi
f01016e4:	39 f9                	cmp    %edi,%ecx
f01016e6:	76 57                	jbe    f010173f <page_insert+0xb1>
	return (void *)(pa + KERNBASE);
f01016e8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01016ed:	39 c2                	cmp    %eax,%edx
f01016ef:	74 60                	je     f0101751 <page_insert+0xc3>
			page_remove(pgdir, va);
f01016f1:	83 ec 08             	sub    $0x8,%esp
f01016f4:	ff 75 10             	pushl  0x10(%ebp)
f01016f7:	ff 75 08             	pushl  0x8(%ebp)
f01016fa:	e8 49 ff ff ff       	call   f0101648 <page_remove>
f01016ff:	83 c4 10             	add    $0x10,%esp
	return (pp - pages) << PGSHIFT;
f0101702:	89 d8                	mov    %ebx,%eax
f0101704:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010170a:	c1 f8 03             	sar    $0x3,%eax
f010170d:	c1 e0 0c             	shl    $0xc,%eax
	*the_pte = page2pa(pp) | perm | PTE_P;
f0101710:	0b 45 14             	or     0x14(%ebp),%eax
f0101713:	83 c8 01             	or     $0x1,%eax
f0101716:	89 06                	mov    %eax,(%esi)
	pp->pp_ref++;
f0101718:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	return 0;
f010171d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101722:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101725:	5b                   	pop    %ebx
f0101726:	5e                   	pop    %esi
f0101727:	5f                   	pop    %edi
f0101728:	5d                   	pop    %ebp
f0101729:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010172a:	52                   	push   %edx
f010172b:	68 0c 81 10 f0       	push   $0xf010810c
f0101730:	68 1a 02 00 00       	push   $0x21a
f0101735:	68 85 92 10 f0       	push   $0xf0109285
f010173a:	e8 0a e9 ff ff       	call   f0100049 <_panic>
f010173f:	50                   	push   %eax
f0101740:	68 0c 81 10 f0       	push   $0xf010810c
f0101745:	6a 58                	push   $0x58
f0101747:	68 91 92 10 f0       	push   $0xf0109291
f010174c:	e8 f8 e8 ff ff       	call   f0100049 <_panic>
			tlb_invalidate(pgdir, va);
f0101751:	83 ec 08             	sub    $0x8,%esp
f0101754:	ff 75 10             	pushl  0x10(%ebp)
f0101757:	ff 75 08             	pushl  0x8(%ebp)
f010175a:	e8 b4 fe ff ff       	call   f0101613 <tlb_invalidate>
			pp->pp_ref--;
f010175f:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
f0101764:	83 c4 10             	add    $0x10,%esp
f0101767:	eb 99                	jmp    f0101702 <page_insert+0x74>
		return -E_NO_MEM;
f0101769:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010176e:	eb b2                	jmp    f0101722 <page_insert+0x94>

f0101770 <mmio_map_region>:
{
f0101770:	55                   	push   %ebp
f0101771:	89 e5                	mov    %esp,%ebp
f0101773:	56                   	push   %esi
f0101774:	53                   	push   %ebx
	size = ROUNDUP(size, PGSIZE);
f0101775:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101778:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f010177e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((base + size) > MMIOLIM){
f0101784:	8b 35 04 d3 16 f0    	mov    0xf016d304,%esi
f010178a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f010178d:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101792:	77 25                	ja     f01017b9 <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101794:	83 ec 08             	sub    $0x8,%esp
f0101797:	6a 1a                	push   $0x1a
f0101799:	ff 75 08             	pushl  0x8(%ebp)
f010179c:	89 d9                	mov    %ebx,%ecx
f010179e:	89 f2                	mov    %esi,%edx
f01017a0:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01017a5:	e8 50 fd ff ff       	call   f01014fa <boot_map_region>
	base += size;
f01017aa:	01 1d 04 d3 16 f0    	add    %ebx,0xf016d304
}
f01017b0:	89 f0                	mov    %esi,%eax
f01017b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01017b5:	5b                   	pop    %ebx
f01017b6:	5e                   	pop    %esi
f01017b7:	5d                   	pop    %ebp
f01017b8:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f01017b9:	83 ec 04             	sub    $0x4,%esp
f01017bc:	68 7c 93 10 f0       	push   $0xf010937c
f01017c1:	68 8b 02 00 00       	push   $0x28b
f01017c6:	68 85 92 10 f0       	push   $0xf0109285
f01017cb:	e8 79 e8 ff ff       	call   f0100049 <_panic>

f01017d0 <mem_init>:
{
f01017d0:	55                   	push   %ebp
f01017d1:	89 e5                	mov    %esp,%ebp
f01017d3:	57                   	push   %edi
f01017d4:	56                   	push   %esi
f01017d5:	53                   	push   %ebx
f01017d6:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01017d9:	b8 15 00 00 00       	mov    $0x15,%eax
f01017de:	e8 4f f6 ff ff       	call   f0100e32 <nvram_read>
f01017e3:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01017e5:	b8 17 00 00 00       	mov    $0x17,%eax
f01017ea:	e8 43 f6 ff ff       	call   f0100e32 <nvram_read>
f01017ef:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01017f1:	b8 34 00 00 00       	mov    $0x34,%eax
f01017f6:	e8 37 f6 ff ff       	call   f0100e32 <nvram_read>
	if (ext16mem)
f01017fb:	c1 e0 06             	shl    $0x6,%eax
f01017fe:	0f 84 e5 00 00 00    	je     f01018e9 <mem_init+0x119>
		totalmem = 16 * 1024 + ext16mem;
f0101804:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f0101809:	89 c2                	mov    %eax,%edx
f010180b:	c1 ea 02             	shr    $0x2,%edx
f010180e:	89 15 88 ed 5d f0    	mov    %edx,0xf05ded88
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101814:	89 c2                	mov    %eax,%edx
f0101816:	29 da                	sub    %ebx,%edx
f0101818:	52                   	push   %edx
f0101819:	53                   	push   %ebx
f010181a:	50                   	push   %eax
f010181b:	68 f0 89 10 f0       	push   $0xf01089f0
f0101820:	e8 40 2a 00 00       	call   f0104265 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101825:	b8 00 10 00 00       	mov    $0x1000,%eax
f010182a:	e8 90 f6 ff ff       	call   f0100ebf <boot_alloc>
f010182f:	a3 8c ed 5d f0       	mov    %eax,0xf05ded8c
	memset(kern_pgdir, 0, PGSIZE);
f0101834:	83 c4 0c             	add    $0xc,%esp
f0101837:	68 00 10 00 00       	push   $0x1000
f010183c:	6a 00                	push   $0x0
f010183e:	50                   	push   %eax
f010183f:	e8 83 50 00 00       	call   f01068c7 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101844:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101849:	83 c4 10             	add    $0x10,%esp
f010184c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101851:	0f 86 a2 00 00 00    	jbe    f01018f9 <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f0101857:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010185d:	83 ca 05             	or     $0x5,%edx
f0101860:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f0101866:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f010186b:	c1 e0 03             	shl    $0x3,%eax
f010186e:	e8 4c f6 ff ff       	call   f0100ebf <boot_alloc>
f0101873:	a3 90 ed 5d f0       	mov    %eax,0xf05ded90
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f0101878:	83 ec 04             	sub    $0x4,%esp
f010187b:	8b 15 88 ed 5d f0    	mov    0xf05ded88,%edx
f0101881:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0101888:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010188e:	52                   	push   %edx
f010188f:	6a 00                	push   $0x0
f0101891:	50                   	push   %eax
f0101892:	e8 30 50 00 00       	call   f01068c7 <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101897:	b8 00 10 02 00       	mov    $0x21000,%eax
f010189c:	e8 1e f6 ff ff       	call   f0100ebf <boot_alloc>
f01018a1:	a3 44 d9 5d f0       	mov    %eax,0xf05dd944
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f01018a6:	83 c4 0c             	add    $0xc,%esp
f01018a9:	68 00 10 02 00       	push   $0x21000
f01018ae:	6a 00                	push   $0x0
f01018b0:	50                   	push   %eax
f01018b1:	e8 11 50 00 00       	call   f01068c7 <memset>
	page_init();
f01018b6:	e8 98 f9 ff ff       	call   f0101253 <page_init>
	check_page_free_list(1);
f01018bb:	b8 01 00 00 00       	mov    $0x1,%eax
f01018c0:	e8 a0 f6 ff ff       	call   f0100f65 <check_page_free_list>
	if (!pages)
f01018c5:	83 c4 10             	add    $0x10,%esp
f01018c8:	83 3d 90 ed 5d f0 00 	cmpl   $0x0,0xf05ded90
f01018cf:	74 3d                	je     f010190e <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01018d1:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f01018d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f01018dd:	85 c0                	test   %eax,%eax
f01018df:	74 44                	je     f0101925 <mem_init+0x155>
		++nfree;
f01018e1:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01018e5:	8b 00                	mov    (%eax),%eax
f01018e7:	eb f4                	jmp    f01018dd <mem_init+0x10d>
		totalmem = 1 * 1024 + extmem;
f01018e9:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01018ef:	85 f6                	test   %esi,%esi
f01018f1:	0f 44 c3             	cmove  %ebx,%eax
f01018f4:	e9 10 ff ff ff       	jmp    f0101809 <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01018f9:	50                   	push   %eax
f01018fa:	68 30 81 10 f0       	push   $0xf0108130
f01018ff:	68 9b 00 00 00       	push   $0x9b
f0101904:	68 85 92 10 f0       	push   $0xf0109285
f0101909:	e8 3b e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f010190e:	83 ec 04             	sub    $0x4,%esp
f0101911:	68 8e 93 10 f0       	push   $0xf010938e
f0101916:	68 1f 03 00 00       	push   $0x31f
f010191b:	68 85 92 10 f0       	push   $0xf0109285
f0101920:	e8 24 e7 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101925:	83 ec 0c             	sub    $0xc,%esp
f0101928:	6a 00                	push   $0x0
f010192a:	e8 23 fa ff ff       	call   f0101352 <page_alloc>
f010192f:	89 c3                	mov    %eax,%ebx
f0101931:	83 c4 10             	add    $0x10,%esp
f0101934:	85 c0                	test   %eax,%eax
f0101936:	0f 84 00 02 00 00    	je     f0101b3c <mem_init+0x36c>
	assert((pp1 = page_alloc(0)));
f010193c:	83 ec 0c             	sub    $0xc,%esp
f010193f:	6a 00                	push   $0x0
f0101941:	e8 0c fa ff ff       	call   f0101352 <page_alloc>
f0101946:	89 c6                	mov    %eax,%esi
f0101948:	83 c4 10             	add    $0x10,%esp
f010194b:	85 c0                	test   %eax,%eax
f010194d:	0f 84 02 02 00 00    	je     f0101b55 <mem_init+0x385>
	assert((pp2 = page_alloc(0)));
f0101953:	83 ec 0c             	sub    $0xc,%esp
f0101956:	6a 00                	push   $0x0
f0101958:	e8 f5 f9 ff ff       	call   f0101352 <page_alloc>
f010195d:	89 c7                	mov    %eax,%edi
f010195f:	83 c4 10             	add    $0x10,%esp
f0101962:	85 c0                	test   %eax,%eax
f0101964:	0f 84 04 02 00 00    	je     f0101b6e <mem_init+0x39e>
	assert(pp1 && pp1 != pp0);
f010196a:	39 f3                	cmp    %esi,%ebx
f010196c:	0f 84 15 02 00 00    	je     f0101b87 <mem_init+0x3b7>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101972:	39 c3                	cmp    %eax,%ebx
f0101974:	0f 84 26 02 00 00    	je     f0101ba0 <mem_init+0x3d0>
f010197a:	39 c6                	cmp    %eax,%esi
f010197c:	0f 84 1e 02 00 00    	je     f0101ba0 <mem_init+0x3d0>
	return (pp - pages) << PGSHIFT;
f0101982:	8b 0d 90 ed 5d f0    	mov    0xf05ded90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101988:	8b 15 88 ed 5d f0    	mov    0xf05ded88,%edx
f010198e:	c1 e2 0c             	shl    $0xc,%edx
f0101991:	89 d8                	mov    %ebx,%eax
f0101993:	29 c8                	sub    %ecx,%eax
f0101995:	c1 f8 03             	sar    $0x3,%eax
f0101998:	c1 e0 0c             	shl    $0xc,%eax
f010199b:	39 d0                	cmp    %edx,%eax
f010199d:	0f 83 16 02 00 00    	jae    f0101bb9 <mem_init+0x3e9>
f01019a3:	89 f0                	mov    %esi,%eax
f01019a5:	29 c8                	sub    %ecx,%eax
f01019a7:	c1 f8 03             	sar    $0x3,%eax
f01019aa:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f01019ad:	39 c2                	cmp    %eax,%edx
f01019af:	0f 86 1d 02 00 00    	jbe    f0101bd2 <mem_init+0x402>
f01019b5:	89 f8                	mov    %edi,%eax
f01019b7:	29 c8                	sub    %ecx,%eax
f01019b9:	c1 f8 03             	sar    $0x3,%eax
f01019bc:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f01019bf:	39 c2                	cmp    %eax,%edx
f01019c1:	0f 86 24 02 00 00    	jbe    f0101beb <mem_init+0x41b>
	fl = page_free_list;
f01019c7:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f01019cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01019cf:	c7 05 40 d9 5d f0 00 	movl   $0x0,0xf05dd940
f01019d6:	00 00 00 
	assert(!page_alloc(0));
f01019d9:	83 ec 0c             	sub    $0xc,%esp
f01019dc:	6a 00                	push   $0x0
f01019de:	e8 6f f9 ff ff       	call   f0101352 <page_alloc>
f01019e3:	83 c4 10             	add    $0x10,%esp
f01019e6:	85 c0                	test   %eax,%eax
f01019e8:	0f 85 16 02 00 00    	jne    f0101c04 <mem_init+0x434>
	page_free(pp0);
f01019ee:	83 ec 0c             	sub    $0xc,%esp
f01019f1:	53                   	push   %ebx
f01019f2:	e8 cd f9 ff ff       	call   f01013c4 <page_free>
	page_free(pp1);
f01019f7:	89 34 24             	mov    %esi,(%esp)
f01019fa:	e8 c5 f9 ff ff       	call   f01013c4 <page_free>
	page_free(pp2);
f01019ff:	89 3c 24             	mov    %edi,(%esp)
f0101a02:	e8 bd f9 ff ff       	call   f01013c4 <page_free>
	assert((pp0 = page_alloc(0)));
f0101a07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a0e:	e8 3f f9 ff ff       	call   f0101352 <page_alloc>
f0101a13:	89 c3                	mov    %eax,%ebx
f0101a15:	83 c4 10             	add    $0x10,%esp
f0101a18:	85 c0                	test   %eax,%eax
f0101a1a:	0f 84 fd 01 00 00    	je     f0101c1d <mem_init+0x44d>
	assert((pp1 = page_alloc(0)));
f0101a20:	83 ec 0c             	sub    $0xc,%esp
f0101a23:	6a 00                	push   $0x0
f0101a25:	e8 28 f9 ff ff       	call   f0101352 <page_alloc>
f0101a2a:	89 c6                	mov    %eax,%esi
f0101a2c:	83 c4 10             	add    $0x10,%esp
f0101a2f:	85 c0                	test   %eax,%eax
f0101a31:	0f 84 ff 01 00 00    	je     f0101c36 <mem_init+0x466>
	assert((pp2 = page_alloc(0)));
f0101a37:	83 ec 0c             	sub    $0xc,%esp
f0101a3a:	6a 00                	push   $0x0
f0101a3c:	e8 11 f9 ff ff       	call   f0101352 <page_alloc>
f0101a41:	89 c7                	mov    %eax,%edi
f0101a43:	83 c4 10             	add    $0x10,%esp
f0101a46:	85 c0                	test   %eax,%eax
f0101a48:	0f 84 01 02 00 00    	je     f0101c4f <mem_init+0x47f>
	assert(pp1 && pp1 != pp0);
f0101a4e:	39 f3                	cmp    %esi,%ebx
f0101a50:	0f 84 12 02 00 00    	je     f0101c68 <mem_init+0x498>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a56:	39 c6                	cmp    %eax,%esi
f0101a58:	0f 84 23 02 00 00    	je     f0101c81 <mem_init+0x4b1>
f0101a5e:	39 c3                	cmp    %eax,%ebx
f0101a60:	0f 84 1b 02 00 00    	je     f0101c81 <mem_init+0x4b1>
	assert(!page_alloc(0));
f0101a66:	83 ec 0c             	sub    $0xc,%esp
f0101a69:	6a 00                	push   $0x0
f0101a6b:	e8 e2 f8 ff ff       	call   f0101352 <page_alloc>
f0101a70:	83 c4 10             	add    $0x10,%esp
f0101a73:	85 c0                	test   %eax,%eax
f0101a75:	0f 85 1f 02 00 00    	jne    f0101c9a <mem_init+0x4ca>
f0101a7b:	89 d8                	mov    %ebx,%eax
f0101a7d:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0101a83:	c1 f8 03             	sar    $0x3,%eax
f0101a86:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a89:	89 c2                	mov    %eax,%edx
f0101a8b:	c1 ea 0c             	shr    $0xc,%edx
f0101a8e:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0101a94:	0f 83 19 02 00 00    	jae    f0101cb3 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a9a:	83 ec 04             	sub    $0x4,%esp
f0101a9d:	68 00 10 00 00       	push   $0x1000
f0101aa2:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101aa4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101aa9:	50                   	push   %eax
f0101aaa:	e8 18 4e 00 00       	call   f01068c7 <memset>
	page_free(pp0);
f0101aaf:	89 1c 24             	mov    %ebx,(%esp)
f0101ab2:	e8 0d f9 ff ff       	call   f01013c4 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101ab7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101abe:	e8 8f f8 ff ff       	call   f0101352 <page_alloc>
f0101ac3:	83 c4 10             	add    $0x10,%esp
f0101ac6:	85 c0                	test   %eax,%eax
f0101ac8:	0f 84 f7 01 00 00    	je     f0101cc5 <mem_init+0x4f5>
	assert(pp && pp0 == pp);
f0101ace:	39 c3                	cmp    %eax,%ebx
f0101ad0:	0f 85 08 02 00 00    	jne    f0101cde <mem_init+0x50e>
	return (pp - pages) << PGSHIFT;
f0101ad6:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0101adc:	c1 f8 03             	sar    $0x3,%eax
f0101adf:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101ae2:	89 c2                	mov    %eax,%edx
f0101ae4:	c1 ea 0c             	shr    $0xc,%edx
f0101ae7:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0101aed:	0f 83 04 02 00 00    	jae    f0101cf7 <mem_init+0x527>
	return (void *)(pa + KERNBASE);
f0101af3:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101af9:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101afe:	80 3a 00             	cmpb   $0x0,(%edx)
f0101b01:	0f 85 02 02 00 00    	jne    f0101d09 <mem_init+0x539>
f0101b07:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101b0a:	39 c2                	cmp    %eax,%edx
f0101b0c:	75 f0                	jne    f0101afe <mem_init+0x32e>
	page_free_list = fl;
f0101b0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101b11:	a3 40 d9 5d f0       	mov    %eax,0xf05dd940
	page_free(pp0);
f0101b16:	83 ec 0c             	sub    $0xc,%esp
f0101b19:	53                   	push   %ebx
f0101b1a:	e8 a5 f8 ff ff       	call   f01013c4 <page_free>
	page_free(pp1);
f0101b1f:	89 34 24             	mov    %esi,(%esp)
f0101b22:	e8 9d f8 ff ff       	call   f01013c4 <page_free>
	page_free(pp2);
f0101b27:	89 3c 24             	mov    %edi,(%esp)
f0101b2a:	e8 95 f8 ff ff       	call   f01013c4 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101b2f:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f0101b34:	83 c4 10             	add    $0x10,%esp
f0101b37:	e9 ec 01 00 00       	jmp    f0101d28 <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101b3c:	68 a9 93 10 f0       	push   $0xf01093a9
f0101b41:	68 ab 92 10 f0       	push   $0xf01092ab
f0101b46:	68 27 03 00 00       	push   $0x327
f0101b4b:	68 85 92 10 f0       	push   $0xf0109285
f0101b50:	e8 f4 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101b55:	68 bf 93 10 f0       	push   $0xf01093bf
f0101b5a:	68 ab 92 10 f0       	push   $0xf01092ab
f0101b5f:	68 28 03 00 00       	push   $0x328
f0101b64:	68 85 92 10 f0       	push   $0xf0109285
f0101b69:	e8 db e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101b6e:	68 d5 93 10 f0       	push   $0xf01093d5
f0101b73:	68 ab 92 10 f0       	push   $0xf01092ab
f0101b78:	68 29 03 00 00       	push   $0x329
f0101b7d:	68 85 92 10 f0       	push   $0xf0109285
f0101b82:	e8 c2 e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101b87:	68 eb 93 10 f0       	push   $0xf01093eb
f0101b8c:	68 ab 92 10 f0       	push   $0xf01092ab
f0101b91:	68 2c 03 00 00       	push   $0x32c
f0101b96:	68 85 92 10 f0       	push   $0xf0109285
f0101b9b:	e8 a9 e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101ba0:	68 2c 8a 10 f0       	push   $0xf0108a2c
f0101ba5:	68 ab 92 10 f0       	push   $0xf01092ab
f0101baa:	68 2d 03 00 00       	push   $0x32d
f0101baf:	68 85 92 10 f0       	push   $0xf0109285
f0101bb4:	e8 90 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101bb9:	68 fd 93 10 f0       	push   $0xf01093fd
f0101bbe:	68 ab 92 10 f0       	push   $0xf01092ab
f0101bc3:	68 2e 03 00 00       	push   $0x32e
f0101bc8:	68 85 92 10 f0       	push   $0xf0109285
f0101bcd:	e8 77 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101bd2:	68 1a 94 10 f0       	push   $0xf010941a
f0101bd7:	68 ab 92 10 f0       	push   $0xf01092ab
f0101bdc:	68 2f 03 00 00       	push   $0x32f
f0101be1:	68 85 92 10 f0       	push   $0xf0109285
f0101be6:	e8 5e e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101beb:	68 37 94 10 f0       	push   $0xf0109437
f0101bf0:	68 ab 92 10 f0       	push   $0xf01092ab
f0101bf5:	68 30 03 00 00       	push   $0x330
f0101bfa:	68 85 92 10 f0       	push   $0xf0109285
f0101bff:	e8 45 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c04:	68 54 94 10 f0       	push   $0xf0109454
f0101c09:	68 ab 92 10 f0       	push   $0xf01092ab
f0101c0e:	68 37 03 00 00       	push   $0x337
f0101c13:	68 85 92 10 f0       	push   $0xf0109285
f0101c18:	e8 2c e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101c1d:	68 a9 93 10 f0       	push   $0xf01093a9
f0101c22:	68 ab 92 10 f0       	push   $0xf01092ab
f0101c27:	68 3e 03 00 00       	push   $0x33e
f0101c2c:	68 85 92 10 f0       	push   $0xf0109285
f0101c31:	e8 13 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101c36:	68 bf 93 10 f0       	push   $0xf01093bf
f0101c3b:	68 ab 92 10 f0       	push   $0xf01092ab
f0101c40:	68 3f 03 00 00       	push   $0x33f
f0101c45:	68 85 92 10 f0       	push   $0xf0109285
f0101c4a:	e8 fa e3 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101c4f:	68 d5 93 10 f0       	push   $0xf01093d5
f0101c54:	68 ab 92 10 f0       	push   $0xf01092ab
f0101c59:	68 40 03 00 00       	push   $0x340
f0101c5e:	68 85 92 10 f0       	push   $0xf0109285
f0101c63:	e8 e1 e3 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101c68:	68 eb 93 10 f0       	push   $0xf01093eb
f0101c6d:	68 ab 92 10 f0       	push   $0xf01092ab
f0101c72:	68 42 03 00 00       	push   $0x342
f0101c77:	68 85 92 10 f0       	push   $0xf0109285
f0101c7c:	e8 c8 e3 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c81:	68 2c 8a 10 f0       	push   $0xf0108a2c
f0101c86:	68 ab 92 10 f0       	push   $0xf01092ab
f0101c8b:	68 43 03 00 00       	push   $0x343
f0101c90:	68 85 92 10 f0       	push   $0xf0109285
f0101c95:	e8 af e3 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c9a:	68 54 94 10 f0       	push   $0xf0109454
f0101c9f:	68 ab 92 10 f0       	push   $0xf01092ab
f0101ca4:	68 44 03 00 00       	push   $0x344
f0101ca9:	68 85 92 10 f0       	push   $0xf0109285
f0101cae:	e8 96 e3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101cb3:	50                   	push   %eax
f0101cb4:	68 0c 81 10 f0       	push   $0xf010810c
f0101cb9:	6a 58                	push   $0x58
f0101cbb:	68 91 92 10 f0       	push   $0xf0109291
f0101cc0:	e8 84 e3 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101cc5:	68 63 94 10 f0       	push   $0xf0109463
f0101cca:	68 ab 92 10 f0       	push   $0xf01092ab
f0101ccf:	68 49 03 00 00       	push   $0x349
f0101cd4:	68 85 92 10 f0       	push   $0xf0109285
f0101cd9:	e8 6b e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101cde:	68 81 94 10 f0       	push   $0xf0109481
f0101ce3:	68 ab 92 10 f0       	push   $0xf01092ab
f0101ce8:	68 4a 03 00 00       	push   $0x34a
f0101ced:	68 85 92 10 f0       	push   $0xf0109285
f0101cf2:	e8 52 e3 ff ff       	call   f0100049 <_panic>
f0101cf7:	50                   	push   %eax
f0101cf8:	68 0c 81 10 f0       	push   $0xf010810c
f0101cfd:	6a 58                	push   $0x58
f0101cff:	68 91 92 10 f0       	push   $0xf0109291
f0101d04:	e8 40 e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101d09:	68 91 94 10 f0       	push   $0xf0109491
f0101d0e:	68 ab 92 10 f0       	push   $0xf01092ab
f0101d13:	68 4d 03 00 00       	push   $0x34d
f0101d18:	68 85 92 10 f0       	push   $0xf0109285
f0101d1d:	e8 27 e3 ff ff       	call   f0100049 <_panic>
		--nfree;
f0101d22:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101d26:	8b 00                	mov    (%eax),%eax
f0101d28:	85 c0                	test   %eax,%eax
f0101d2a:	75 f6                	jne    f0101d22 <mem_init+0x552>
	assert(nfree == 0);
f0101d2c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101d30:	0f 85 65 09 00 00    	jne    f010269b <mem_init+0xecb>
	cprintf("check_page_alloc() succeeded!\n");
f0101d36:	83 ec 0c             	sub    $0xc,%esp
f0101d39:	68 4c 8a 10 f0       	push   $0xf0108a4c
f0101d3e:	e8 22 25 00 00       	call   f0104265 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101d43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101d4a:	e8 03 f6 ff ff       	call   f0101352 <page_alloc>
f0101d4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101d52:	83 c4 10             	add    $0x10,%esp
f0101d55:	85 c0                	test   %eax,%eax
f0101d57:	0f 84 57 09 00 00    	je     f01026b4 <mem_init+0xee4>
	assert((pp1 = page_alloc(0)));
f0101d5d:	83 ec 0c             	sub    $0xc,%esp
f0101d60:	6a 00                	push   $0x0
f0101d62:	e8 eb f5 ff ff       	call   f0101352 <page_alloc>
f0101d67:	89 c7                	mov    %eax,%edi
f0101d69:	83 c4 10             	add    $0x10,%esp
f0101d6c:	85 c0                	test   %eax,%eax
f0101d6e:	0f 84 59 09 00 00    	je     f01026cd <mem_init+0xefd>
	assert((pp2 = page_alloc(0)));
f0101d74:	83 ec 0c             	sub    $0xc,%esp
f0101d77:	6a 00                	push   $0x0
f0101d79:	e8 d4 f5 ff ff       	call   f0101352 <page_alloc>
f0101d7e:	89 c3                	mov    %eax,%ebx
f0101d80:	83 c4 10             	add    $0x10,%esp
f0101d83:	85 c0                	test   %eax,%eax
f0101d85:	0f 84 5b 09 00 00    	je     f01026e6 <mem_init+0xf16>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101d8b:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101d8e:	0f 84 6b 09 00 00    	je     f01026ff <mem_init+0xf2f>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d94:	39 c7                	cmp    %eax,%edi
f0101d96:	0f 84 7c 09 00 00    	je     f0102718 <mem_init+0xf48>
f0101d9c:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101d9f:	0f 84 73 09 00 00    	je     f0102718 <mem_init+0xf48>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101da5:	a1 40 d9 5d f0       	mov    0xf05dd940,%eax
f0101daa:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101dad:	c7 05 40 d9 5d f0 00 	movl   $0x0,0xf05dd940
f0101db4:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101db7:	83 ec 0c             	sub    $0xc,%esp
f0101dba:	6a 00                	push   $0x0
f0101dbc:	e8 91 f5 ff ff       	call   f0101352 <page_alloc>
f0101dc1:	83 c4 10             	add    $0x10,%esp
f0101dc4:	85 c0                	test   %eax,%eax
f0101dc6:	0f 85 65 09 00 00    	jne    f0102731 <mem_init+0xf61>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101dcc:	83 ec 04             	sub    $0x4,%esp
f0101dcf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101dd2:	50                   	push   %eax
f0101dd3:	6a 00                	push   $0x0
f0101dd5:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101ddb:	e8 ce f7 ff ff       	call   f01015ae <page_lookup>
f0101de0:	83 c4 10             	add    $0x10,%esp
f0101de3:	85 c0                	test   %eax,%eax
f0101de5:	0f 85 5f 09 00 00    	jne    f010274a <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101deb:	6a 02                	push   $0x2
f0101ded:	6a 00                	push   $0x0
f0101def:	57                   	push   %edi
f0101df0:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101df6:	e8 93 f8 ff ff       	call   f010168e <page_insert>
f0101dfb:	83 c4 10             	add    $0x10,%esp
f0101dfe:	85 c0                	test   %eax,%eax
f0101e00:	0f 89 5d 09 00 00    	jns    f0102763 <mem_init+0xf93>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101e06:	83 ec 0c             	sub    $0xc,%esp
f0101e09:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101e0c:	e8 b3 f5 ff ff       	call   f01013c4 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101e11:	6a 02                	push   $0x2
f0101e13:	6a 00                	push   $0x0
f0101e15:	57                   	push   %edi
f0101e16:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101e1c:	e8 6d f8 ff ff       	call   f010168e <page_insert>
f0101e21:	83 c4 20             	add    $0x20,%esp
f0101e24:	85 c0                	test   %eax,%eax
f0101e26:	0f 85 50 09 00 00    	jne    f010277c <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101e2c:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
	return (pp - pages) << PGSHIFT;
f0101e32:	8b 0d 90 ed 5d f0    	mov    0xf05ded90,%ecx
f0101e38:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101e3b:	8b 16                	mov    (%esi),%edx
f0101e3d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101e43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e46:	29 c8                	sub    %ecx,%eax
f0101e48:	c1 f8 03             	sar    $0x3,%eax
f0101e4b:	c1 e0 0c             	shl    $0xc,%eax
f0101e4e:	39 c2                	cmp    %eax,%edx
f0101e50:	0f 85 3f 09 00 00    	jne    f0102795 <mem_init+0xfc5>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101e56:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e5b:	89 f0                	mov    %esi,%eax
f0101e5d:	e8 f9 ef ff ff       	call   f0100e5b <check_va2pa>
f0101e62:	89 fa                	mov    %edi,%edx
f0101e64:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101e67:	c1 fa 03             	sar    $0x3,%edx
f0101e6a:	c1 e2 0c             	shl    $0xc,%edx
f0101e6d:	39 d0                	cmp    %edx,%eax
f0101e6f:	0f 85 39 09 00 00    	jne    f01027ae <mem_init+0xfde>
	assert(pp1->pp_ref == 1);
f0101e75:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e7a:	0f 85 47 09 00 00    	jne    f01027c7 <mem_init+0xff7>
	assert(pp0->pp_ref == 1);
f0101e80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e83:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101e88:	0f 85 52 09 00 00    	jne    f01027e0 <mem_init+0x1010>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e8e:	6a 02                	push   $0x2
f0101e90:	68 00 10 00 00       	push   $0x1000
f0101e95:	53                   	push   %ebx
f0101e96:	56                   	push   %esi
f0101e97:	e8 f2 f7 ff ff       	call   f010168e <page_insert>
f0101e9c:	83 c4 10             	add    $0x10,%esp
f0101e9f:	85 c0                	test   %eax,%eax
f0101ea1:	0f 85 52 09 00 00    	jne    f01027f9 <mem_init+0x1029>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ea7:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101eac:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0101eb1:	e8 a5 ef ff ff       	call   f0100e5b <check_va2pa>
f0101eb6:	89 da                	mov    %ebx,%edx
f0101eb8:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0101ebe:	c1 fa 03             	sar    $0x3,%edx
f0101ec1:	c1 e2 0c             	shl    $0xc,%edx
f0101ec4:	39 d0                	cmp    %edx,%eax
f0101ec6:	0f 85 46 09 00 00    	jne    f0102812 <mem_init+0x1042>
	assert(pp2->pp_ref == 1);
f0101ecc:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101ed1:	0f 85 54 09 00 00    	jne    f010282b <mem_init+0x105b>

	// should be no free memory
	assert(!page_alloc(0));
f0101ed7:	83 ec 0c             	sub    $0xc,%esp
f0101eda:	6a 00                	push   $0x0
f0101edc:	e8 71 f4 ff ff       	call   f0101352 <page_alloc>
f0101ee1:	83 c4 10             	add    $0x10,%esp
f0101ee4:	85 c0                	test   %eax,%eax
f0101ee6:	0f 85 58 09 00 00    	jne    f0102844 <mem_init+0x1074>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101eec:	6a 02                	push   $0x2
f0101eee:	68 00 10 00 00       	push   $0x1000
f0101ef3:	53                   	push   %ebx
f0101ef4:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101efa:	e8 8f f7 ff ff       	call   f010168e <page_insert>
f0101eff:	83 c4 10             	add    $0x10,%esp
f0101f02:	85 c0                	test   %eax,%eax
f0101f04:	0f 85 53 09 00 00    	jne    f010285d <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f0a:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f0f:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0101f14:	e8 42 ef ff ff       	call   f0100e5b <check_va2pa>
f0101f19:	89 da                	mov    %ebx,%edx
f0101f1b:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0101f21:	c1 fa 03             	sar    $0x3,%edx
f0101f24:	c1 e2 0c             	shl    $0xc,%edx
f0101f27:	39 d0                	cmp    %edx,%eax
f0101f29:	0f 85 47 09 00 00    	jne    f0102876 <mem_init+0x10a6>
	assert(pp2->pp_ref == 1);
f0101f2f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101f34:	0f 85 55 09 00 00    	jne    f010288f <mem_init+0x10bf>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101f3a:	83 ec 0c             	sub    $0xc,%esp
f0101f3d:	6a 00                	push   $0x0
f0101f3f:	e8 0e f4 ff ff       	call   f0101352 <page_alloc>
f0101f44:	83 c4 10             	add    $0x10,%esp
f0101f47:	85 c0                	test   %eax,%eax
f0101f49:	0f 85 59 09 00 00    	jne    f01028a8 <mem_init+0x10d8>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101f4f:	8b 15 8c ed 5d f0    	mov    0xf05ded8c,%edx
f0101f55:	8b 02                	mov    (%edx),%eax
f0101f57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101f5c:	89 c1                	mov    %eax,%ecx
f0101f5e:	c1 e9 0c             	shr    $0xc,%ecx
f0101f61:	3b 0d 88 ed 5d f0    	cmp    0xf05ded88,%ecx
f0101f67:	0f 83 54 09 00 00    	jae    f01028c1 <mem_init+0x10f1>
	return (void *)(pa + KERNBASE);
f0101f6d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101f75:	83 ec 04             	sub    $0x4,%esp
f0101f78:	6a 00                	push   $0x0
f0101f7a:	68 00 10 00 00       	push   $0x1000
f0101f7f:	52                   	push   %edx
f0101f80:	e8 a3 f4 ff ff       	call   f0101428 <pgdir_walk>
f0101f85:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101f88:	8d 51 04             	lea    0x4(%ecx),%edx
f0101f8b:	83 c4 10             	add    $0x10,%esp
f0101f8e:	39 d0                	cmp    %edx,%eax
f0101f90:	0f 85 40 09 00 00    	jne    f01028d6 <mem_init+0x1106>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101f96:	6a 06                	push   $0x6
f0101f98:	68 00 10 00 00       	push   $0x1000
f0101f9d:	53                   	push   %ebx
f0101f9e:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0101fa4:	e8 e5 f6 ff ff       	call   f010168e <page_insert>
f0101fa9:	83 c4 10             	add    $0x10,%esp
f0101fac:	85 c0                	test   %eax,%eax
f0101fae:	0f 85 3b 09 00 00    	jne    f01028ef <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101fb4:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
f0101fba:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101fbf:	89 f0                	mov    %esi,%eax
f0101fc1:	e8 95 ee ff ff       	call   f0100e5b <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101fc6:	89 da                	mov    %ebx,%edx
f0101fc8:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f0101fce:	c1 fa 03             	sar    $0x3,%edx
f0101fd1:	c1 e2 0c             	shl    $0xc,%edx
f0101fd4:	39 d0                	cmp    %edx,%eax
f0101fd6:	0f 85 2c 09 00 00    	jne    f0102908 <mem_init+0x1138>
	assert(pp2->pp_ref == 1);
f0101fdc:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101fe1:	0f 85 3a 09 00 00    	jne    f0102921 <mem_init+0x1151>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101fe7:	83 ec 04             	sub    $0x4,%esp
f0101fea:	6a 00                	push   $0x0
f0101fec:	68 00 10 00 00       	push   $0x1000
f0101ff1:	56                   	push   %esi
f0101ff2:	e8 31 f4 ff ff       	call   f0101428 <pgdir_walk>
f0101ff7:	83 c4 10             	add    $0x10,%esp
f0101ffa:	f6 00 04             	testb  $0x4,(%eax)
f0101ffd:	0f 84 37 09 00 00    	je     f010293a <mem_init+0x116a>
	assert(kern_pgdir[0] & PTE_U);
f0102003:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102008:	f6 00 04             	testb  $0x4,(%eax)
f010200b:	0f 84 42 09 00 00    	je     f0102953 <mem_init+0x1183>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102011:	6a 02                	push   $0x2
f0102013:	68 00 10 00 00       	push   $0x1000
f0102018:	53                   	push   %ebx
f0102019:	50                   	push   %eax
f010201a:	e8 6f f6 ff ff       	call   f010168e <page_insert>
f010201f:	83 c4 10             	add    $0x10,%esp
f0102022:	85 c0                	test   %eax,%eax
f0102024:	0f 85 42 09 00 00    	jne    f010296c <mem_init+0x119c>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f010202a:	83 ec 04             	sub    $0x4,%esp
f010202d:	6a 00                	push   $0x0
f010202f:	68 00 10 00 00       	push   $0x1000
f0102034:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010203a:	e8 e9 f3 ff ff       	call   f0101428 <pgdir_walk>
f010203f:	83 c4 10             	add    $0x10,%esp
f0102042:	f6 00 02             	testb  $0x2,(%eax)
f0102045:	0f 84 3a 09 00 00    	je     f0102985 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010204b:	83 ec 04             	sub    $0x4,%esp
f010204e:	6a 00                	push   $0x0
f0102050:	68 00 10 00 00       	push   $0x1000
f0102055:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010205b:	e8 c8 f3 ff ff       	call   f0101428 <pgdir_walk>
f0102060:	83 c4 10             	add    $0x10,%esp
f0102063:	f6 00 04             	testb  $0x4,(%eax)
f0102066:	0f 85 32 09 00 00    	jne    f010299e <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f010206c:	6a 02                	push   $0x2
f010206e:	68 00 00 40 00       	push   $0x400000
f0102073:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102076:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010207c:	e8 0d f6 ff ff       	call   f010168e <page_insert>
f0102081:	83 c4 10             	add    $0x10,%esp
f0102084:	85 c0                	test   %eax,%eax
f0102086:	0f 89 2b 09 00 00    	jns    f01029b7 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010208c:	6a 02                	push   $0x2
f010208e:	68 00 10 00 00       	push   $0x1000
f0102093:	57                   	push   %edi
f0102094:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f010209a:	e8 ef f5 ff ff       	call   f010168e <page_insert>
f010209f:	83 c4 10             	add    $0x10,%esp
f01020a2:	85 c0                	test   %eax,%eax
f01020a4:	0f 85 26 09 00 00    	jne    f01029d0 <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01020aa:	83 ec 04             	sub    $0x4,%esp
f01020ad:	6a 00                	push   $0x0
f01020af:	68 00 10 00 00       	push   $0x1000
f01020b4:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01020ba:	e8 69 f3 ff ff       	call   f0101428 <pgdir_walk>
f01020bf:	83 c4 10             	add    $0x10,%esp
f01020c2:	f6 00 04             	testb  $0x4,(%eax)
f01020c5:	0f 85 1e 09 00 00    	jne    f01029e9 <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01020cb:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01020d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01020d3:	ba 00 00 00 00       	mov    $0x0,%edx
f01020d8:	e8 7e ed ff ff       	call   f0100e5b <check_va2pa>
f01020dd:	89 fe                	mov    %edi,%esi
f01020df:	2b 35 90 ed 5d f0    	sub    0xf05ded90,%esi
f01020e5:	c1 fe 03             	sar    $0x3,%esi
f01020e8:	c1 e6 0c             	shl    $0xc,%esi
f01020eb:	39 f0                	cmp    %esi,%eax
f01020ed:	0f 85 0f 09 00 00    	jne    f0102a02 <mem_init+0x1232>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01020f3:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01020fb:	e8 5b ed ff ff       	call   f0100e5b <check_va2pa>
f0102100:	39 c6                	cmp    %eax,%esi
f0102102:	0f 85 13 09 00 00    	jne    f0102a1b <mem_init+0x124b>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0102108:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f010210d:	0f 85 21 09 00 00    	jne    f0102a34 <mem_init+0x1264>
	assert(pp2->pp_ref == 0);
f0102113:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102118:	0f 85 2f 09 00 00    	jne    f0102a4d <mem_init+0x127d>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f010211e:	83 ec 0c             	sub    $0xc,%esp
f0102121:	6a 00                	push   $0x0
f0102123:	e8 2a f2 ff ff       	call   f0101352 <page_alloc>
f0102128:	83 c4 10             	add    $0x10,%esp
f010212b:	39 c3                	cmp    %eax,%ebx
f010212d:	0f 85 33 09 00 00    	jne    f0102a66 <mem_init+0x1296>
f0102133:	85 c0                	test   %eax,%eax
f0102135:	0f 84 2b 09 00 00    	je     f0102a66 <mem_init+0x1296>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f010213b:	83 ec 08             	sub    $0x8,%esp
f010213e:	6a 00                	push   $0x0
f0102140:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102146:	e8 fd f4 ff ff       	call   f0101648 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010214b:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
f0102151:	ba 00 00 00 00       	mov    $0x0,%edx
f0102156:	89 f0                	mov    %esi,%eax
f0102158:	e8 fe ec ff ff       	call   f0100e5b <check_va2pa>
f010215d:	83 c4 10             	add    $0x10,%esp
f0102160:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102163:	0f 85 16 09 00 00    	jne    f0102a7f <mem_init+0x12af>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102169:	ba 00 10 00 00       	mov    $0x1000,%edx
f010216e:	89 f0                	mov    %esi,%eax
f0102170:	e8 e6 ec ff ff       	call   f0100e5b <check_va2pa>
f0102175:	89 fa                	mov    %edi,%edx
f0102177:	2b 15 90 ed 5d f0    	sub    0xf05ded90,%edx
f010217d:	c1 fa 03             	sar    $0x3,%edx
f0102180:	c1 e2 0c             	shl    $0xc,%edx
f0102183:	39 d0                	cmp    %edx,%eax
f0102185:	0f 85 0d 09 00 00    	jne    f0102a98 <mem_init+0x12c8>
	assert(pp1->pp_ref == 1);
f010218b:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102190:	0f 85 1b 09 00 00    	jne    f0102ab1 <mem_init+0x12e1>
	assert(pp2->pp_ref == 0);
f0102196:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010219b:	0f 85 29 09 00 00    	jne    f0102aca <mem_init+0x12fa>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01021a1:	6a 00                	push   $0x0
f01021a3:	68 00 10 00 00       	push   $0x1000
f01021a8:	57                   	push   %edi
f01021a9:	56                   	push   %esi
f01021aa:	e8 df f4 ff ff       	call   f010168e <page_insert>
f01021af:	83 c4 10             	add    $0x10,%esp
f01021b2:	85 c0                	test   %eax,%eax
f01021b4:	0f 85 29 09 00 00    	jne    f0102ae3 <mem_init+0x1313>
	assert(pp1->pp_ref);
f01021ba:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01021bf:	0f 84 37 09 00 00    	je     f0102afc <mem_init+0x132c>
	assert(pp1->pp_link == NULL);
f01021c5:	83 3f 00             	cmpl   $0x0,(%edi)
f01021c8:	0f 85 47 09 00 00    	jne    f0102b15 <mem_init+0x1345>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01021ce:	83 ec 08             	sub    $0x8,%esp
f01021d1:	68 00 10 00 00       	push   $0x1000
f01021d6:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01021dc:	e8 67 f4 ff ff       	call   f0101648 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01021e1:	8b 35 8c ed 5d f0    	mov    0xf05ded8c,%esi
f01021e7:	ba 00 00 00 00       	mov    $0x0,%edx
f01021ec:	89 f0                	mov    %esi,%eax
f01021ee:	e8 68 ec ff ff       	call   f0100e5b <check_va2pa>
f01021f3:	83 c4 10             	add    $0x10,%esp
f01021f6:	83 f8 ff             	cmp    $0xffffffff,%eax
f01021f9:	0f 85 2f 09 00 00    	jne    f0102b2e <mem_init+0x135e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01021ff:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102204:	89 f0                	mov    %esi,%eax
f0102206:	e8 50 ec ff ff       	call   f0100e5b <check_va2pa>
f010220b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010220e:	0f 85 33 09 00 00    	jne    f0102b47 <mem_init+0x1377>
	assert(pp1->pp_ref == 0);
f0102214:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102219:	0f 85 41 09 00 00    	jne    f0102b60 <mem_init+0x1390>
	assert(pp2->pp_ref == 0);
f010221f:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102224:	0f 85 4f 09 00 00    	jne    f0102b79 <mem_init+0x13a9>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f010222a:	83 ec 0c             	sub    $0xc,%esp
f010222d:	6a 00                	push   $0x0
f010222f:	e8 1e f1 ff ff       	call   f0101352 <page_alloc>
f0102234:	83 c4 10             	add    $0x10,%esp
f0102237:	85 c0                	test   %eax,%eax
f0102239:	0f 84 53 09 00 00    	je     f0102b92 <mem_init+0x13c2>
f010223f:	39 c7                	cmp    %eax,%edi
f0102241:	0f 85 4b 09 00 00    	jne    f0102b92 <mem_init+0x13c2>

	// should be no free memory
	assert(!page_alloc(0));
f0102247:	83 ec 0c             	sub    $0xc,%esp
f010224a:	6a 00                	push   $0x0
f010224c:	e8 01 f1 ff ff       	call   f0101352 <page_alloc>
f0102251:	83 c4 10             	add    $0x10,%esp
f0102254:	85 c0                	test   %eax,%eax
f0102256:	0f 85 4f 09 00 00    	jne    f0102bab <mem_init+0x13db>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010225c:	8b 0d 8c ed 5d f0    	mov    0xf05ded8c,%ecx
f0102262:	8b 11                	mov    (%ecx),%edx
f0102264:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010226a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010226d:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0102273:	c1 f8 03             	sar    $0x3,%eax
f0102276:	c1 e0 0c             	shl    $0xc,%eax
f0102279:	39 c2                	cmp    %eax,%edx
f010227b:	0f 85 43 09 00 00    	jne    f0102bc4 <mem_init+0x13f4>
	kern_pgdir[0] = 0;
f0102281:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102287:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010228a:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010228f:	0f 85 48 09 00 00    	jne    f0102bdd <mem_init+0x140d>
	pp0->pp_ref = 0;
f0102295:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102298:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f010229e:	83 ec 0c             	sub    $0xc,%esp
f01022a1:	50                   	push   %eax
f01022a2:	e8 1d f1 ff ff       	call   f01013c4 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01022a7:	83 c4 0c             	add    $0xc,%esp
f01022aa:	6a 01                	push   $0x1
f01022ac:	68 00 10 40 00       	push   $0x401000
f01022b1:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01022b7:	e8 6c f1 ff ff       	call   f0101428 <pgdir_walk>
f01022bc:	89 c1                	mov    %eax,%ecx
f01022be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01022c1:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01022c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01022c9:	8b 40 04             	mov    0x4(%eax),%eax
f01022cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01022d1:	8b 35 88 ed 5d f0    	mov    0xf05ded88,%esi
f01022d7:	89 c2                	mov    %eax,%edx
f01022d9:	c1 ea 0c             	shr    $0xc,%edx
f01022dc:	83 c4 10             	add    $0x10,%esp
f01022df:	39 f2                	cmp    %esi,%edx
f01022e1:	0f 83 0f 09 00 00    	jae    f0102bf6 <mem_init+0x1426>
	assert(ptep == ptep1 + PTX(va));
f01022e7:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f01022ec:	39 c1                	cmp    %eax,%ecx
f01022ee:	0f 85 17 09 00 00    	jne    f0102c0b <mem_init+0x143b>
	kern_pgdir[PDX(va)] = 0;
f01022f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01022f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f01022fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102301:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0102307:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010230d:	c1 f8 03             	sar    $0x3,%eax
f0102310:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102313:	89 c2                	mov    %eax,%edx
f0102315:	c1 ea 0c             	shr    $0xc,%edx
f0102318:	39 d6                	cmp    %edx,%esi
f010231a:	0f 86 04 09 00 00    	jbe    f0102c24 <mem_init+0x1454>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102320:	83 ec 04             	sub    $0x4,%esp
f0102323:	68 00 10 00 00       	push   $0x1000
f0102328:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f010232d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102332:	50                   	push   %eax
f0102333:	e8 8f 45 00 00       	call   f01068c7 <memset>
	page_free(pp0);
f0102338:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f010233b:	89 34 24             	mov    %esi,(%esp)
f010233e:	e8 81 f0 ff ff       	call   f01013c4 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102343:	83 c4 0c             	add    $0xc,%esp
f0102346:	6a 01                	push   $0x1
f0102348:	6a 00                	push   $0x0
f010234a:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102350:	e8 d3 f0 ff ff       	call   f0101428 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0102355:	89 f0                	mov    %esi,%eax
f0102357:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010235d:	c1 f8 03             	sar    $0x3,%eax
f0102360:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102363:	89 c2                	mov    %eax,%edx
f0102365:	c1 ea 0c             	shr    $0xc,%edx
f0102368:	83 c4 10             	add    $0x10,%esp
f010236b:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0102371:	0f 83 bf 08 00 00    	jae    f0102c36 <mem_init+0x1466>
	return (void *)(pa + KERNBASE);
f0102377:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f010237d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0102380:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102385:	f6 02 01             	testb  $0x1,(%edx)
f0102388:	0f 85 ba 08 00 00    	jne    f0102c48 <mem_init+0x1478>
f010238e:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f0102391:	39 c2                	cmp    %eax,%edx
f0102393:	75 f0                	jne    f0102385 <mem_init+0xbb5>
	kern_pgdir[0] = 0;
f0102395:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f010239a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01023a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01023a3:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f01023a9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01023ac:	89 0d 40 d9 5d f0    	mov    %ecx,0xf05dd940

	// free the pages we took
	page_free(pp0);
f01023b2:	83 ec 0c             	sub    $0xc,%esp
f01023b5:	50                   	push   %eax
f01023b6:	e8 09 f0 ff ff       	call   f01013c4 <page_free>
	page_free(pp1);
f01023bb:	89 3c 24             	mov    %edi,(%esp)
f01023be:	e8 01 f0 ff ff       	call   f01013c4 <page_free>
	page_free(pp2);
f01023c3:	89 1c 24             	mov    %ebx,(%esp)
f01023c6:	e8 f9 ef ff ff       	call   f01013c4 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f01023cb:	83 c4 08             	add    $0x8,%esp
f01023ce:	68 01 10 00 00       	push   $0x1001
f01023d3:	6a 00                	push   $0x0
f01023d5:	e8 96 f3 ff ff       	call   f0101770 <mmio_map_region>
f01023da:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f01023dc:	83 c4 08             	add    $0x8,%esp
f01023df:	68 00 10 00 00       	push   $0x1000
f01023e4:	6a 00                	push   $0x0
f01023e6:	e8 85 f3 ff ff       	call   f0101770 <mmio_map_region>
f01023eb:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01023ed:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f01023f3:	83 c4 10             	add    $0x10,%esp
f01023f6:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01023fc:	0f 86 5f 08 00 00    	jbe    f0102c61 <mem_init+0x1491>
f0102402:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102407:	0f 87 54 08 00 00    	ja     f0102c61 <mem_init+0x1491>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010240d:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102413:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102419:	0f 87 5b 08 00 00    	ja     f0102c7a <mem_init+0x14aa>
f010241f:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102425:	0f 86 4f 08 00 00    	jbe    f0102c7a <mem_init+0x14aa>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010242b:	89 da                	mov    %ebx,%edx
f010242d:	09 f2                	or     %esi,%edx
f010242f:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102435:	0f 85 58 08 00 00    	jne    f0102c93 <mem_init+0x14c3>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f010243b:	39 c6                	cmp    %eax,%esi
f010243d:	0f 82 69 08 00 00    	jb     f0102cac <mem_init+0x14dc>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102443:	8b 3d 8c ed 5d f0    	mov    0xf05ded8c,%edi
f0102449:	89 da                	mov    %ebx,%edx
f010244b:	89 f8                	mov    %edi,%eax
f010244d:	e8 09 ea ff ff       	call   f0100e5b <check_va2pa>
f0102452:	85 c0                	test   %eax,%eax
f0102454:	0f 85 6b 08 00 00    	jne    f0102cc5 <mem_init+0x14f5>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010245a:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102460:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102463:	89 c2                	mov    %eax,%edx
f0102465:	89 f8                	mov    %edi,%eax
f0102467:	e8 ef e9 ff ff       	call   f0100e5b <check_va2pa>
f010246c:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102471:	0f 85 67 08 00 00    	jne    f0102cde <mem_init+0x150e>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102477:	89 f2                	mov    %esi,%edx
f0102479:	89 f8                	mov    %edi,%eax
f010247b:	e8 db e9 ff ff       	call   f0100e5b <check_va2pa>
f0102480:	85 c0                	test   %eax,%eax
f0102482:	0f 85 6f 08 00 00    	jne    f0102cf7 <mem_init+0x1527>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102488:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f010248e:	89 f8                	mov    %edi,%eax
f0102490:	e8 c6 e9 ff ff       	call   f0100e5b <check_va2pa>
f0102495:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102498:	0f 85 72 08 00 00    	jne    f0102d10 <mem_init+0x1540>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f010249e:	83 ec 04             	sub    $0x4,%esp
f01024a1:	6a 00                	push   $0x0
f01024a3:	53                   	push   %ebx
f01024a4:	57                   	push   %edi
f01024a5:	e8 7e ef ff ff       	call   f0101428 <pgdir_walk>
f01024aa:	83 c4 10             	add    $0x10,%esp
f01024ad:	f6 00 1a             	testb  $0x1a,(%eax)
f01024b0:	0f 84 73 08 00 00    	je     f0102d29 <mem_init+0x1559>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01024b6:	83 ec 04             	sub    $0x4,%esp
f01024b9:	6a 00                	push   $0x0
f01024bb:	53                   	push   %ebx
f01024bc:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01024c2:	e8 61 ef ff ff       	call   f0101428 <pgdir_walk>
f01024c7:	8b 00                	mov    (%eax),%eax
f01024c9:	83 c4 10             	add    $0x10,%esp
f01024cc:	83 e0 04             	and    $0x4,%eax
f01024cf:	89 c7                	mov    %eax,%edi
f01024d1:	0f 85 6b 08 00 00    	jne    f0102d42 <mem_init+0x1572>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f01024d7:	83 ec 04             	sub    $0x4,%esp
f01024da:	6a 00                	push   $0x0
f01024dc:	53                   	push   %ebx
f01024dd:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01024e3:	e8 40 ef ff ff       	call   f0101428 <pgdir_walk>
f01024e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f01024ee:	83 c4 0c             	add    $0xc,%esp
f01024f1:	6a 00                	push   $0x0
f01024f3:	ff 75 d4             	pushl  -0x2c(%ebp)
f01024f6:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01024fc:	e8 27 ef ff ff       	call   f0101428 <pgdir_walk>
f0102501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102507:	83 c4 0c             	add    $0xc,%esp
f010250a:	6a 00                	push   $0x0
f010250c:	56                   	push   %esi
f010250d:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0102513:	e8 10 ef ff ff       	call   f0101428 <pgdir_walk>
f0102518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f010251e:	c7 04 24 84 95 10 f0 	movl   $0xf0109584,(%esp)
f0102525:	e8 3b 1d 00 00       	call   f0104265 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010252a:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
	if ((uint32_t)kva < KERNBASE)
f010252f:	83 c4 10             	add    $0x10,%esp
f0102532:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102537:	0f 86 1e 08 00 00    	jbe    f0102d5b <mem_init+0x158b>
f010253d:	83 ec 08             	sub    $0x8,%esp
f0102540:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102542:	05 00 00 00 10       	add    $0x10000000,%eax
f0102547:	50                   	push   %eax
f0102548:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010254d:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102552:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102557:	e8 9e ef ff ff       	call   f01014fa <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f010255c:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
	if ((uint32_t)kva < KERNBASE)
f0102561:	83 c4 10             	add    $0x10,%esp
f0102564:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102569:	0f 86 01 08 00 00    	jbe    f0102d70 <mem_init+0x15a0>
f010256f:	83 ec 08             	sub    $0x8,%esp
f0102572:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102574:	05 00 00 00 10       	add    $0x10000000,%eax
f0102579:	50                   	push   %eax
f010257a:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010257f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102584:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102589:	e8 6c ef ff ff       	call   f01014fa <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010258e:	83 c4 10             	add    $0x10,%esp
f0102591:	b8 00 20 12 f0       	mov    $0xf0122000,%eax
f0102596:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010259b:	0f 86 e4 07 00 00    	jbe    f0102d85 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f01025a1:	83 ec 08             	sub    $0x8,%esp
f01025a4:	6a 02                	push   $0x2
f01025a6:	68 00 20 12 00       	push   $0x122000
f01025ab:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01025b0:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01025b5:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01025ba:	e8 3b ef ff ff       	call   f01014fa <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f01025bf:	83 c4 08             	add    $0x8,%esp
f01025c2:	6a 02                	push   $0x2
f01025c4:	6a 00                	push   $0x0
f01025c6:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f01025cb:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01025d0:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f01025d5:	e8 20 ef ff ff       	call   f01014fa <boot_map_region>
f01025da:	c7 45 d0 00 b0 12 f0 	movl   $0xf012b000,-0x30(%ebp)
f01025e1:	83 c4 10             	add    $0x10,%esp
f01025e4:	bb 00 b0 12 f0       	mov    $0xf012b000,%ebx
f01025e9:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01025ee:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01025f4:	0f 86 a0 07 00 00    	jbe    f0102d9a <mem_init+0x15ca>
		boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f01025fa:	83 ec 08             	sub    $0x8,%esp
f01025fd:	6a 02                	push   $0x2
f01025ff:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102605:	50                   	push   %eax
f0102606:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010260b:	89 f2                	mov    %esi,%edx
f010260d:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102612:	e8 e3 ee ff ff       	call   f01014fa <boot_map_region>
f0102617:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010261d:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f0102623:	83 c4 10             	add    $0x10,%esp
f0102626:	81 fb 00 b0 16 f0    	cmp    $0xf016b000,%ebx
f010262c:	75 c0                	jne    f01025ee <mem_init+0xe1e>
	pgdir = kern_pgdir;
f010262e:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
f0102633:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102636:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f010263b:	89 45 c0             	mov    %eax,-0x40(%ebp)
f010263e:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102645:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010264a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010264d:	8b 35 90 ed 5d f0    	mov    0xf05ded90,%esi
f0102653:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102656:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f010265c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f010265f:	89 fb                	mov    %edi,%ebx
f0102661:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0102664:	0f 86 73 07 00 00    	jbe    f0102ddd <mem_init+0x160d>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010266a:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102670:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102673:	e8 e3 e7 ff ff       	call   f0100e5b <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102678:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f010267f:	0f 86 2a 07 00 00    	jbe    f0102daf <mem_init+0x15df>
f0102685:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102688:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f010268b:	39 d0                	cmp    %edx,%eax
f010268d:	0f 85 31 07 00 00    	jne    f0102dc4 <mem_init+0x15f4>
	for (i = 0; i < n; i += PGSIZE)
f0102693:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102699:	eb c6                	jmp    f0102661 <mem_init+0xe91>
	assert(nfree == 0);
f010269b:	68 9b 94 10 f0       	push   $0xf010949b
f01026a0:	68 ab 92 10 f0       	push   $0xf01092ab
f01026a5:	68 5a 03 00 00       	push   $0x35a
f01026aa:	68 85 92 10 f0       	push   $0xf0109285
f01026af:	e8 95 d9 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f01026b4:	68 a9 93 10 f0       	push   $0xf01093a9
f01026b9:	68 ab 92 10 f0       	push   $0xf01092ab
f01026be:	68 cd 03 00 00       	push   $0x3cd
f01026c3:	68 85 92 10 f0       	push   $0xf0109285
f01026c8:	e8 7c d9 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f01026cd:	68 bf 93 10 f0       	push   $0xf01093bf
f01026d2:	68 ab 92 10 f0       	push   $0xf01092ab
f01026d7:	68 ce 03 00 00       	push   $0x3ce
f01026dc:	68 85 92 10 f0       	push   $0xf0109285
f01026e1:	e8 63 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f01026e6:	68 d5 93 10 f0       	push   $0xf01093d5
f01026eb:	68 ab 92 10 f0       	push   $0xf01092ab
f01026f0:	68 cf 03 00 00       	push   $0x3cf
f01026f5:	68 85 92 10 f0       	push   $0xf0109285
f01026fa:	e8 4a d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f01026ff:	68 eb 93 10 f0       	push   $0xf01093eb
f0102704:	68 ab 92 10 f0       	push   $0xf01092ab
f0102709:	68 d2 03 00 00       	push   $0x3d2
f010270e:	68 85 92 10 f0       	push   $0xf0109285
f0102713:	e8 31 d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102718:	68 2c 8a 10 f0       	push   $0xf0108a2c
f010271d:	68 ab 92 10 f0       	push   $0xf01092ab
f0102722:	68 d3 03 00 00       	push   $0x3d3
f0102727:	68 85 92 10 f0       	push   $0xf0109285
f010272c:	e8 18 d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102731:	68 54 94 10 f0       	push   $0xf0109454
f0102736:	68 ab 92 10 f0       	push   $0xf01092ab
f010273b:	68 da 03 00 00       	push   $0x3da
f0102740:	68 85 92 10 f0       	push   $0xf0109285
f0102745:	e8 ff d8 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010274a:	68 6c 8a 10 f0       	push   $0xf0108a6c
f010274f:	68 ab 92 10 f0       	push   $0xf01092ab
f0102754:	68 dd 03 00 00       	push   $0x3dd
f0102759:	68 85 92 10 f0       	push   $0xf0109285
f010275e:	e8 e6 d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102763:	68 a4 8a 10 f0       	push   $0xf0108aa4
f0102768:	68 ab 92 10 f0       	push   $0xf01092ab
f010276d:	68 e0 03 00 00       	push   $0x3e0
f0102772:	68 85 92 10 f0       	push   $0xf0109285
f0102777:	e8 cd d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010277c:	68 d4 8a 10 f0       	push   $0xf0108ad4
f0102781:	68 ab 92 10 f0       	push   $0xf01092ab
f0102786:	68 e4 03 00 00       	push   $0x3e4
f010278b:	68 85 92 10 f0       	push   $0xf0109285
f0102790:	e8 b4 d8 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102795:	68 04 8b 10 f0       	push   $0xf0108b04
f010279a:	68 ab 92 10 f0       	push   $0xf01092ab
f010279f:	68 e5 03 00 00       	push   $0x3e5
f01027a4:	68 85 92 10 f0       	push   $0xf0109285
f01027a9:	e8 9b d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01027ae:	68 2c 8b 10 f0       	push   $0xf0108b2c
f01027b3:	68 ab 92 10 f0       	push   $0xf01092ab
f01027b8:	68 e6 03 00 00       	push   $0x3e6
f01027bd:	68 85 92 10 f0       	push   $0xf0109285
f01027c2:	e8 82 d8 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01027c7:	68 a6 94 10 f0       	push   $0xf01094a6
f01027cc:	68 ab 92 10 f0       	push   $0xf01092ab
f01027d1:	68 e7 03 00 00       	push   $0x3e7
f01027d6:	68 85 92 10 f0       	push   $0xf0109285
f01027db:	e8 69 d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f01027e0:	68 b7 94 10 f0       	push   $0xf01094b7
f01027e5:	68 ab 92 10 f0       	push   $0xf01092ab
f01027ea:	68 e8 03 00 00       	push   $0x3e8
f01027ef:	68 85 92 10 f0       	push   $0xf0109285
f01027f4:	e8 50 d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027f9:	68 5c 8b 10 f0       	push   $0xf0108b5c
f01027fe:	68 ab 92 10 f0       	push   $0xf01092ab
f0102803:	68 eb 03 00 00       	push   $0x3eb
f0102808:	68 85 92 10 f0       	push   $0xf0109285
f010280d:	e8 37 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102812:	68 98 8b 10 f0       	push   $0xf0108b98
f0102817:	68 ab 92 10 f0       	push   $0xf01092ab
f010281c:	68 ec 03 00 00       	push   $0x3ec
f0102821:	68 85 92 10 f0       	push   $0xf0109285
f0102826:	e8 1e d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010282b:	68 c8 94 10 f0       	push   $0xf01094c8
f0102830:	68 ab 92 10 f0       	push   $0xf01092ab
f0102835:	68 ed 03 00 00       	push   $0x3ed
f010283a:	68 85 92 10 f0       	push   $0xf0109285
f010283f:	e8 05 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102844:	68 54 94 10 f0       	push   $0xf0109454
f0102849:	68 ab 92 10 f0       	push   $0xf01092ab
f010284e:	68 f0 03 00 00       	push   $0x3f0
f0102853:	68 85 92 10 f0       	push   $0xf0109285
f0102858:	e8 ec d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010285d:	68 5c 8b 10 f0       	push   $0xf0108b5c
f0102862:	68 ab 92 10 f0       	push   $0xf01092ab
f0102867:	68 f3 03 00 00       	push   $0x3f3
f010286c:	68 85 92 10 f0       	push   $0xf0109285
f0102871:	e8 d3 d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102876:	68 98 8b 10 f0       	push   $0xf0108b98
f010287b:	68 ab 92 10 f0       	push   $0xf01092ab
f0102880:	68 f4 03 00 00       	push   $0x3f4
f0102885:	68 85 92 10 f0       	push   $0xf0109285
f010288a:	e8 ba d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010288f:	68 c8 94 10 f0       	push   $0xf01094c8
f0102894:	68 ab 92 10 f0       	push   $0xf01092ab
f0102899:	68 f5 03 00 00       	push   $0x3f5
f010289e:	68 85 92 10 f0       	push   $0xf0109285
f01028a3:	e8 a1 d7 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01028a8:	68 54 94 10 f0       	push   $0xf0109454
f01028ad:	68 ab 92 10 f0       	push   $0xf01092ab
f01028b2:	68 f9 03 00 00       	push   $0x3f9
f01028b7:	68 85 92 10 f0       	push   $0xf0109285
f01028bc:	e8 88 d7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01028c1:	50                   	push   %eax
f01028c2:	68 0c 81 10 f0       	push   $0xf010810c
f01028c7:	68 fc 03 00 00       	push   $0x3fc
f01028cc:	68 85 92 10 f0       	push   $0xf0109285
f01028d1:	e8 73 d7 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01028d6:	68 c8 8b 10 f0       	push   $0xf0108bc8
f01028db:	68 ab 92 10 f0       	push   $0xf01092ab
f01028e0:	68 fd 03 00 00       	push   $0x3fd
f01028e5:	68 85 92 10 f0       	push   $0xf0109285
f01028ea:	e8 5a d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01028ef:	68 08 8c 10 f0       	push   $0xf0108c08
f01028f4:	68 ab 92 10 f0       	push   $0xf01092ab
f01028f9:	68 00 04 00 00       	push   $0x400
f01028fe:	68 85 92 10 f0       	push   $0xf0109285
f0102903:	e8 41 d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102908:	68 98 8b 10 f0       	push   $0xf0108b98
f010290d:	68 ab 92 10 f0       	push   $0xf01092ab
f0102912:	68 01 04 00 00       	push   $0x401
f0102917:	68 85 92 10 f0       	push   $0xf0109285
f010291c:	e8 28 d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102921:	68 c8 94 10 f0       	push   $0xf01094c8
f0102926:	68 ab 92 10 f0       	push   $0xf01092ab
f010292b:	68 02 04 00 00       	push   $0x402
f0102930:	68 85 92 10 f0       	push   $0xf0109285
f0102935:	e8 0f d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010293a:	68 48 8c 10 f0       	push   $0xf0108c48
f010293f:	68 ab 92 10 f0       	push   $0xf01092ab
f0102944:	68 03 04 00 00       	push   $0x403
f0102949:	68 85 92 10 f0       	push   $0xf0109285
f010294e:	e8 f6 d6 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102953:	68 d9 94 10 f0       	push   $0xf01094d9
f0102958:	68 ab 92 10 f0       	push   $0xf01092ab
f010295d:	68 04 04 00 00       	push   $0x404
f0102962:	68 85 92 10 f0       	push   $0xf0109285
f0102967:	e8 dd d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010296c:	68 5c 8b 10 f0       	push   $0xf0108b5c
f0102971:	68 ab 92 10 f0       	push   $0xf01092ab
f0102976:	68 07 04 00 00       	push   $0x407
f010297b:	68 85 92 10 f0       	push   $0xf0109285
f0102980:	e8 c4 d6 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102985:	68 7c 8c 10 f0       	push   $0xf0108c7c
f010298a:	68 ab 92 10 f0       	push   $0xf01092ab
f010298f:	68 08 04 00 00       	push   $0x408
f0102994:	68 85 92 10 f0       	push   $0xf0109285
f0102999:	e8 ab d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010299e:	68 b0 8c 10 f0       	push   $0xf0108cb0
f01029a3:	68 ab 92 10 f0       	push   $0xf01092ab
f01029a8:	68 09 04 00 00       	push   $0x409
f01029ad:	68 85 92 10 f0       	push   $0xf0109285
f01029b2:	e8 92 d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01029b7:	68 e8 8c 10 f0       	push   $0xf0108ce8
f01029bc:	68 ab 92 10 f0       	push   $0xf01092ab
f01029c1:	68 0c 04 00 00       	push   $0x40c
f01029c6:	68 85 92 10 f0       	push   $0xf0109285
f01029cb:	e8 79 d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01029d0:	68 20 8d 10 f0       	push   $0xf0108d20
f01029d5:	68 ab 92 10 f0       	push   $0xf01092ab
f01029da:	68 0f 04 00 00       	push   $0x40f
f01029df:	68 85 92 10 f0       	push   $0xf0109285
f01029e4:	e8 60 d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01029e9:	68 b0 8c 10 f0       	push   $0xf0108cb0
f01029ee:	68 ab 92 10 f0       	push   $0xf01092ab
f01029f3:	68 10 04 00 00       	push   $0x410
f01029f8:	68 85 92 10 f0       	push   $0xf0109285
f01029fd:	e8 47 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102a02:	68 5c 8d 10 f0       	push   $0xf0108d5c
f0102a07:	68 ab 92 10 f0       	push   $0xf01092ab
f0102a0c:	68 13 04 00 00       	push   $0x413
f0102a11:	68 85 92 10 f0       	push   $0xf0109285
f0102a16:	e8 2e d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a1b:	68 88 8d 10 f0       	push   $0xf0108d88
f0102a20:	68 ab 92 10 f0       	push   $0xf01092ab
f0102a25:	68 14 04 00 00       	push   $0x414
f0102a2a:	68 85 92 10 f0       	push   $0xf0109285
f0102a2f:	e8 15 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f0102a34:	68 ef 94 10 f0       	push   $0xf01094ef
f0102a39:	68 ab 92 10 f0       	push   $0xf01092ab
f0102a3e:	68 16 04 00 00       	push   $0x416
f0102a43:	68 85 92 10 f0       	push   $0xf0109285
f0102a48:	e8 fc d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a4d:	68 00 95 10 f0       	push   $0xf0109500
f0102a52:	68 ab 92 10 f0       	push   $0xf01092ab
f0102a57:	68 17 04 00 00       	push   $0x417
f0102a5c:	68 85 92 10 f0       	push   $0xf0109285
f0102a61:	e8 e3 d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102a66:	68 b8 8d 10 f0       	push   $0xf0108db8
f0102a6b:	68 ab 92 10 f0       	push   $0xf01092ab
f0102a70:	68 1a 04 00 00       	push   $0x41a
f0102a75:	68 85 92 10 f0       	push   $0xf0109285
f0102a7a:	e8 ca d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a7f:	68 dc 8d 10 f0       	push   $0xf0108ddc
f0102a84:	68 ab 92 10 f0       	push   $0xf01092ab
f0102a89:	68 1e 04 00 00       	push   $0x41e
f0102a8e:	68 85 92 10 f0       	push   $0xf0109285
f0102a93:	e8 b1 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a98:	68 88 8d 10 f0       	push   $0xf0108d88
f0102a9d:	68 ab 92 10 f0       	push   $0xf01092ab
f0102aa2:	68 1f 04 00 00       	push   $0x41f
f0102aa7:	68 85 92 10 f0       	push   $0xf0109285
f0102aac:	e8 98 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102ab1:	68 a6 94 10 f0       	push   $0xf01094a6
f0102ab6:	68 ab 92 10 f0       	push   $0xf01092ab
f0102abb:	68 20 04 00 00       	push   $0x420
f0102ac0:	68 85 92 10 f0       	push   $0xf0109285
f0102ac5:	e8 7f d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102aca:	68 00 95 10 f0       	push   $0xf0109500
f0102acf:	68 ab 92 10 f0       	push   $0xf01092ab
f0102ad4:	68 21 04 00 00       	push   $0x421
f0102ad9:	68 85 92 10 f0       	push   $0xf0109285
f0102ade:	e8 66 d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102ae3:	68 00 8e 10 f0       	push   $0xf0108e00
f0102ae8:	68 ab 92 10 f0       	push   $0xf01092ab
f0102aed:	68 24 04 00 00       	push   $0x424
f0102af2:	68 85 92 10 f0       	push   $0xf0109285
f0102af7:	e8 4d d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102afc:	68 11 95 10 f0       	push   $0xf0109511
f0102b01:	68 ab 92 10 f0       	push   $0xf01092ab
f0102b06:	68 25 04 00 00       	push   $0x425
f0102b0b:	68 85 92 10 f0       	push   $0xf0109285
f0102b10:	e8 34 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102b15:	68 1d 95 10 f0       	push   $0xf010951d
f0102b1a:	68 ab 92 10 f0       	push   $0xf01092ab
f0102b1f:	68 26 04 00 00       	push   $0x426
f0102b24:	68 85 92 10 f0       	push   $0xf0109285
f0102b29:	e8 1b d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102b2e:	68 dc 8d 10 f0       	push   $0xf0108ddc
f0102b33:	68 ab 92 10 f0       	push   $0xf01092ab
f0102b38:	68 2a 04 00 00       	push   $0x42a
f0102b3d:	68 85 92 10 f0       	push   $0xf0109285
f0102b42:	e8 02 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102b47:	68 38 8e 10 f0       	push   $0xf0108e38
f0102b4c:	68 ab 92 10 f0       	push   $0xf01092ab
f0102b51:	68 2b 04 00 00       	push   $0x42b
f0102b56:	68 85 92 10 f0       	push   $0xf0109285
f0102b5b:	e8 e9 d4 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102b60:	68 32 95 10 f0       	push   $0xf0109532
f0102b65:	68 ab 92 10 f0       	push   $0xf01092ab
f0102b6a:	68 2c 04 00 00       	push   $0x42c
f0102b6f:	68 85 92 10 f0       	push   $0xf0109285
f0102b74:	e8 d0 d4 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102b79:	68 00 95 10 f0       	push   $0xf0109500
f0102b7e:	68 ab 92 10 f0       	push   $0xf01092ab
f0102b83:	68 2d 04 00 00       	push   $0x42d
f0102b88:	68 85 92 10 f0       	push   $0xf0109285
f0102b8d:	e8 b7 d4 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b92:	68 60 8e 10 f0       	push   $0xf0108e60
f0102b97:	68 ab 92 10 f0       	push   $0xf01092ab
f0102b9c:	68 30 04 00 00       	push   $0x430
f0102ba1:	68 85 92 10 f0       	push   $0xf0109285
f0102ba6:	e8 9e d4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102bab:	68 54 94 10 f0       	push   $0xf0109454
f0102bb0:	68 ab 92 10 f0       	push   $0xf01092ab
f0102bb5:	68 33 04 00 00       	push   $0x433
f0102bba:	68 85 92 10 f0       	push   $0xf0109285
f0102bbf:	e8 85 d4 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102bc4:	68 04 8b 10 f0       	push   $0xf0108b04
f0102bc9:	68 ab 92 10 f0       	push   $0xf01092ab
f0102bce:	68 36 04 00 00       	push   $0x436
f0102bd3:	68 85 92 10 f0       	push   $0xf0109285
f0102bd8:	e8 6c d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102bdd:	68 b7 94 10 f0       	push   $0xf01094b7
f0102be2:	68 ab 92 10 f0       	push   $0xf01092ab
f0102be7:	68 38 04 00 00       	push   $0x438
f0102bec:	68 85 92 10 f0       	push   $0xf0109285
f0102bf1:	e8 53 d4 ff ff       	call   f0100049 <_panic>
f0102bf6:	50                   	push   %eax
f0102bf7:	68 0c 81 10 f0       	push   $0xf010810c
f0102bfc:	68 3f 04 00 00       	push   $0x43f
f0102c01:	68 85 92 10 f0       	push   $0xf0109285
f0102c06:	e8 3e d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102c0b:	68 43 95 10 f0       	push   $0xf0109543
f0102c10:	68 ab 92 10 f0       	push   $0xf01092ab
f0102c15:	68 40 04 00 00       	push   $0x440
f0102c1a:	68 85 92 10 f0       	push   $0xf0109285
f0102c1f:	e8 25 d4 ff ff       	call   f0100049 <_panic>
f0102c24:	50                   	push   %eax
f0102c25:	68 0c 81 10 f0       	push   $0xf010810c
f0102c2a:	6a 58                	push   $0x58
f0102c2c:	68 91 92 10 f0       	push   $0xf0109291
f0102c31:	e8 13 d4 ff ff       	call   f0100049 <_panic>
f0102c36:	50                   	push   %eax
f0102c37:	68 0c 81 10 f0       	push   $0xf010810c
f0102c3c:	6a 58                	push   $0x58
f0102c3e:	68 91 92 10 f0       	push   $0xf0109291
f0102c43:	e8 01 d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102c48:	68 5b 95 10 f0       	push   $0xf010955b
f0102c4d:	68 ab 92 10 f0       	push   $0xf01092ab
f0102c52:	68 4a 04 00 00       	push   $0x44a
f0102c57:	68 85 92 10 f0       	push   $0xf0109285
f0102c5c:	e8 e8 d3 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102c61:	68 84 8e 10 f0       	push   $0xf0108e84
f0102c66:	68 ab 92 10 f0       	push   $0xf01092ab
f0102c6b:	68 5a 04 00 00       	push   $0x45a
f0102c70:	68 85 92 10 f0       	push   $0xf0109285
f0102c75:	e8 cf d3 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102c7a:	68 ac 8e 10 f0       	push   $0xf0108eac
f0102c7f:	68 ab 92 10 f0       	push   $0xf01092ab
f0102c84:	68 5b 04 00 00       	push   $0x45b
f0102c89:	68 85 92 10 f0       	push   $0xf0109285
f0102c8e:	e8 b6 d3 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c93:	68 d4 8e 10 f0       	push   $0xf0108ed4
f0102c98:	68 ab 92 10 f0       	push   $0xf01092ab
f0102c9d:	68 5d 04 00 00       	push   $0x45d
f0102ca2:	68 85 92 10 f0       	push   $0xf0109285
f0102ca7:	e8 9d d3 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102cac:	68 72 95 10 f0       	push   $0xf0109572
f0102cb1:	68 ab 92 10 f0       	push   $0xf01092ab
f0102cb6:	68 5f 04 00 00       	push   $0x45f
f0102cbb:	68 85 92 10 f0       	push   $0xf0109285
f0102cc0:	e8 84 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102cc5:	68 fc 8e 10 f0       	push   $0xf0108efc
f0102cca:	68 ab 92 10 f0       	push   $0xf01092ab
f0102ccf:	68 61 04 00 00       	push   $0x461
f0102cd4:	68 85 92 10 f0       	push   $0xf0109285
f0102cd9:	e8 6b d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102cde:	68 20 8f 10 f0       	push   $0xf0108f20
f0102ce3:	68 ab 92 10 f0       	push   $0xf01092ab
f0102ce8:	68 62 04 00 00       	push   $0x462
f0102ced:	68 85 92 10 f0       	push   $0xf0109285
f0102cf2:	e8 52 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102cf7:	68 50 8f 10 f0       	push   $0xf0108f50
f0102cfc:	68 ab 92 10 f0       	push   $0xf01092ab
f0102d01:	68 63 04 00 00       	push   $0x463
f0102d06:	68 85 92 10 f0       	push   $0xf0109285
f0102d0b:	e8 39 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102d10:	68 74 8f 10 f0       	push   $0xf0108f74
f0102d15:	68 ab 92 10 f0       	push   $0xf01092ab
f0102d1a:	68 64 04 00 00       	push   $0x464
f0102d1f:	68 85 92 10 f0       	push   $0xf0109285
f0102d24:	e8 20 d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102d29:	68 a0 8f 10 f0       	push   $0xf0108fa0
f0102d2e:	68 ab 92 10 f0       	push   $0xf01092ab
f0102d33:	68 66 04 00 00       	push   $0x466
f0102d38:	68 85 92 10 f0       	push   $0xf0109285
f0102d3d:	e8 07 d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102d42:	68 e4 8f 10 f0       	push   $0xf0108fe4
f0102d47:	68 ab 92 10 f0       	push   $0xf01092ab
f0102d4c:	68 67 04 00 00       	push   $0x467
f0102d51:	68 85 92 10 f0       	push   $0xf0109285
f0102d56:	e8 ee d2 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d5b:	50                   	push   %eax
f0102d5c:	68 30 81 10 f0       	push   $0xf0108130
f0102d61:	68 bf 00 00 00       	push   $0xbf
f0102d66:	68 85 92 10 f0       	push   $0xf0109285
f0102d6b:	e8 d9 d2 ff ff       	call   f0100049 <_panic>
f0102d70:	50                   	push   %eax
f0102d71:	68 30 81 10 f0       	push   $0xf0108130
f0102d76:	68 c7 00 00 00       	push   $0xc7
f0102d7b:	68 85 92 10 f0       	push   $0xf0109285
f0102d80:	e8 c4 d2 ff ff       	call   f0100049 <_panic>
f0102d85:	50                   	push   %eax
f0102d86:	68 30 81 10 f0       	push   $0xf0108130
f0102d8b:	68 d3 00 00 00       	push   $0xd3
f0102d90:	68 85 92 10 f0       	push   $0xf0109285
f0102d95:	e8 af d2 ff ff       	call   f0100049 <_panic>
f0102d9a:	53                   	push   %ebx
f0102d9b:	68 30 81 10 f0       	push   $0xf0108130
f0102da0:	68 1a 01 00 00       	push   $0x11a
f0102da5:	68 85 92 10 f0       	push   $0xf0109285
f0102daa:	e8 9a d2 ff ff       	call   f0100049 <_panic>
f0102daf:	56                   	push   %esi
f0102db0:	68 30 81 10 f0       	push   $0xf0108130
f0102db5:	68 71 03 00 00       	push   $0x371
f0102dba:	68 85 92 10 f0       	push   $0xf0109285
f0102dbf:	e8 85 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102dc4:	68 18 90 10 f0       	push   $0xf0109018
f0102dc9:	68 ab 92 10 f0       	push   $0xf01092ab
f0102dce:	68 71 03 00 00       	push   $0x371
f0102dd3:	68 85 92 10 f0       	push   $0xf0109285
f0102dd8:	e8 6c d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102ddd:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0102de2:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102de5:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102de8:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102ded:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102df3:	89 da                	mov    %ebx,%edx
f0102df5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102df8:	e8 5e e0 ff ff       	call   f0100e5b <check_va2pa>
f0102dfd:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102e04:	76 45                	jbe    f0102e4b <mem_init+0x167b>
f0102e06:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102e09:	39 d0                	cmp    %edx,%eax
f0102e0b:	75 55                	jne    f0102e62 <mem_init+0x1692>
f0102e0d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102e13:	81 fb 00 10 c2 ee    	cmp    $0xeec21000,%ebx
f0102e19:	75 d8                	jne    f0102df3 <mem_init+0x1623>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102e1b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102e1e:	8b 81 00 0f 00 00    	mov    0xf00(%ecx),%eax
f0102e24:	89 c2                	mov    %eax,%edx
f0102e26:	81 e2 81 00 00 00    	and    $0x81,%edx
f0102e2c:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f0102e32:	0f 85 75 01 00 00    	jne    f0102fad <mem_init+0x17dd>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f0102e38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102e3d:	0f 85 6a 01 00 00    	jne    f0102fad <mem_init+0x17dd>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102e43:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102e46:	c1 e6 0c             	shl    $0xc,%esi
f0102e49:	eb 3f                	jmp    f0102e8a <mem_init+0x16ba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e4b:	ff 75 c8             	pushl  -0x38(%ebp)
f0102e4e:	68 30 81 10 f0       	push   $0xf0108130
f0102e53:	68 76 03 00 00       	push   $0x376
f0102e58:	68 85 92 10 f0       	push   $0xf0109285
f0102e5d:	e8 e7 d1 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102e62:	68 4c 90 10 f0       	push   $0xf010904c
f0102e67:	68 ab 92 10 f0       	push   $0xf01092ab
f0102e6c:	68 76 03 00 00       	push   $0x376
f0102e71:	68 85 92 10 f0       	push   $0xf0109285
f0102e76:	e8 ce d1 ff ff       	call   f0100049 <_panic>
	return PTE_ADDR(*pgdir);
f0102e7b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e81:	39 d0                	cmp    %edx,%eax
f0102e83:	75 25                	jne    f0102eaa <mem_init+0x16da>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102e85:	05 00 00 40 00       	add    $0x400000,%eax
f0102e8a:	39 f0                	cmp    %esi,%eax
f0102e8c:	73 35                	jae    f0102ec3 <mem_init+0x16f3>
	pgdir = &pgdir[PDX(va)];
f0102e8e:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102e94:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102e97:	8b 14 91             	mov    (%ecx,%edx,4),%edx
f0102e9a:	89 d3                	mov    %edx,%ebx
f0102e9c:	81 e3 81 00 00 00    	and    $0x81,%ebx
f0102ea2:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
f0102ea8:	74 d1                	je     f0102e7b <mem_init+0x16ab>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102eaa:	68 80 90 10 f0       	push   $0xf0109080
f0102eaf:	68 ab 92 10 f0       	push   $0xf01092ab
f0102eb4:	68 7b 03 00 00       	push   $0x37b
f0102eb9:	68 85 92 10 f0       	push   $0xf0109285
f0102ebe:	e8 86 d1 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102ec3:	83 ec 0c             	sub    $0xc,%esp
f0102ec6:	68 9d 95 10 f0       	push   $0xf010959d
f0102ecb:	e8 95 13 00 00       	call   f0104265 <cprintf>
f0102ed0:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ed3:	b8 00 b0 12 f0       	mov    $0xf012b000,%eax
f0102ed8:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102edd:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102ee0:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102ee2:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102ee5:	89 f3                	mov    %esi,%ebx
f0102ee7:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102eea:	05 00 80 00 20       	add    $0x20008000,%eax
f0102eef:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102ef2:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102ef8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102efb:	89 da                	mov    %ebx,%edx
f0102efd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f00:	e8 56 df ff ff       	call   f0100e5b <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102f05:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102f0b:	0f 86 a6 00 00 00    	jbe    f0102fb7 <mem_init+0x17e7>
f0102f11:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102f14:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102f17:	39 d0                	cmp    %edx,%eax
f0102f19:	0f 85 af 00 00 00    	jne    f0102fce <mem_init+0x17fe>
f0102f1f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102f25:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0102f28:	75 d1                	jne    f0102efb <mem_init+0x172b>
f0102f2a:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f30:	89 da                	mov    %ebx,%edx
f0102f32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f35:	e8 21 df ff ff       	call   f0100e5b <check_va2pa>
f0102f3a:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102f3d:	0f 85 a4 00 00 00    	jne    f0102fe7 <mem_init+0x1817>
f0102f43:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102f49:	39 f3                	cmp    %esi,%ebx
f0102f4b:	75 e3                	jne    f0102f30 <mem_init+0x1760>
f0102f4d:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102f53:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102f5a:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f0102f60:	81 ff 00 b0 16 f0    	cmp    $0xf016b000,%edi
f0102f66:	0f 85 76 ff ff ff    	jne    f0102ee2 <mem_init+0x1712>
f0102f6c:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0102f6f:	e9 c7 00 00 00       	jmp    f010303b <mem_init+0x186b>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102f7a:	39 f3                	cmp    %esi,%ebx
f0102f7c:	0f 83 51 ff ff ff    	jae    f0102ed3 <mem_init+0x1703>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102f82:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102f88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f8b:	e8 cb de ff ff       	call   f0100e5b <check_va2pa>
f0102f90:	39 c3                	cmp    %eax,%ebx
f0102f92:	74 e0                	je     f0102f74 <mem_init+0x17a4>
f0102f94:	68 ac 90 10 f0       	push   $0xf01090ac
f0102f99:	68 ab 92 10 f0       	push   $0xf01092ab
f0102f9e:	68 80 03 00 00       	push   $0x380
f0102fa3:	68 85 92 10 f0       	push   $0xf0109285
f0102fa8:	e8 9c d0 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102fad:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102fb0:	c1 e6 0c             	shl    $0xc,%esi
f0102fb3:	89 fb                	mov    %edi,%ebx
f0102fb5:	eb c3                	jmp    f0102f7a <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102fb7:	ff 75 c0             	pushl  -0x40(%ebp)
f0102fba:	68 30 81 10 f0       	push   $0xf0108130
f0102fbf:	68 88 03 00 00       	push   $0x388
f0102fc4:	68 85 92 10 f0       	push   $0xf0109285
f0102fc9:	e8 7b d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102fce:	68 d4 90 10 f0       	push   $0xf01090d4
f0102fd3:	68 ab 92 10 f0       	push   $0xf01092ab
f0102fd8:	68 88 03 00 00       	push   $0x388
f0102fdd:	68 85 92 10 f0       	push   $0xf0109285
f0102fe2:	e8 62 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102fe7:	68 1c 91 10 f0       	push   $0xf010911c
f0102fec:	68 ab 92 10 f0       	push   $0xf01092ab
f0102ff1:	68 8a 03 00 00       	push   $0x38a
f0102ff6:	68 85 92 10 f0       	push   $0xf0109285
f0102ffb:	e8 49 d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0103000:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103003:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0103007:	75 4e                	jne    f0103057 <mem_init+0x1887>
f0103009:	68 b4 95 10 f0       	push   $0xf01095b4
f010300e:	68 ab 92 10 f0       	push   $0xf01092ab
f0103013:	68 95 03 00 00       	push   $0x395
f0103018:	68 85 92 10 f0       	push   $0xf0109285
f010301d:	e8 27 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_P);
f0103022:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103025:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0103028:	a8 01                	test   $0x1,%al
f010302a:	74 30                	je     f010305c <mem_init+0x188c>
				assert(pgdir[i] & PTE_W);
f010302c:	a8 02                	test   $0x2,%al
f010302e:	74 45                	je     f0103075 <mem_init+0x18a5>
	for (i = 0; i < NPDENTRIES; i++) {
f0103030:	83 c7 01             	add    $0x1,%edi
f0103033:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0103039:	74 6c                	je     f01030a7 <mem_init+0x18d7>
		switch (i) {
f010303b:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0103041:	83 f8 04             	cmp    $0x4,%eax
f0103044:	76 ba                	jbe    f0103000 <mem_init+0x1830>
			if (i >= PDX(KERNBASE)) {
f0103046:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f010304c:	77 d4                	ja     f0103022 <mem_init+0x1852>
				assert(pgdir[i] == 0);
f010304e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103051:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0103055:	75 37                	jne    f010308e <mem_init+0x18be>
	for (i = 0; i < NPDENTRIES; i++) {
f0103057:	83 c7 01             	add    $0x1,%edi
f010305a:	eb df                	jmp    f010303b <mem_init+0x186b>
				assert(pgdir[i] & PTE_P);
f010305c:	68 b4 95 10 f0       	push   $0xf01095b4
f0103061:	68 ab 92 10 f0       	push   $0xf01092ab
f0103066:	68 99 03 00 00       	push   $0x399
f010306b:	68 85 92 10 f0       	push   $0xf0109285
f0103070:	e8 d4 cf ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0103075:	68 c5 95 10 f0       	push   $0xf01095c5
f010307a:	68 ab 92 10 f0       	push   $0xf01092ab
f010307f:	68 9a 03 00 00       	push   $0x39a
f0103084:	68 85 92 10 f0       	push   $0xf0109285
f0103089:	e8 bb cf ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f010308e:	68 d6 95 10 f0       	push   $0xf01095d6
f0103093:	68 ab 92 10 f0       	push   $0xf01092ab
f0103098:	68 9c 03 00 00       	push   $0x39c
f010309d:	68 85 92 10 f0       	push   $0xf0109285
f01030a2:	e8 a2 cf ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f01030a7:	83 ec 0c             	sub    $0xc,%esp
f01030aa:	68 40 91 10 f0       	push   $0xf0109140
f01030af:	e8 b1 11 00 00       	call   f0104265 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f01030b4:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f01030b7:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f01030ba:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f01030bd:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01030c2:	83 c4 10             	add    $0x10,%esp
f01030c5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01030ca:	0f 86 1f 02 00 00    	jbe    f01032ef <mem_init+0x1b1f>
	return (physaddr_t)kva - KERNBASE;
f01030d0:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01030d5:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f01030d8:	b8 00 00 00 00       	mov    $0x0,%eax
f01030dd:	e8 83 de ff ff       	call   f0100f65 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f01030e2:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f01030e5:	83 e0 f3             	and    $0xfffffff3,%eax
f01030e8:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f01030ed:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01030f0:	83 ec 0c             	sub    $0xc,%esp
f01030f3:	6a 00                	push   $0x0
f01030f5:	e8 58 e2 ff ff       	call   f0101352 <page_alloc>
f01030fa:	89 c6                	mov    %eax,%esi
f01030fc:	83 c4 10             	add    $0x10,%esp
f01030ff:	85 c0                	test   %eax,%eax
f0103101:	0f 84 fd 01 00 00    	je     f0103304 <mem_init+0x1b34>
	assert((pp1 = page_alloc(0)));
f0103107:	83 ec 0c             	sub    $0xc,%esp
f010310a:	6a 00                	push   $0x0
f010310c:	e8 41 e2 ff ff       	call   f0101352 <page_alloc>
f0103111:	89 c7                	mov    %eax,%edi
f0103113:	83 c4 10             	add    $0x10,%esp
f0103116:	85 c0                	test   %eax,%eax
f0103118:	0f 84 ff 01 00 00    	je     f010331d <mem_init+0x1b4d>
	assert((pp2 = page_alloc(0)));
f010311e:	83 ec 0c             	sub    $0xc,%esp
f0103121:	6a 00                	push   $0x0
f0103123:	e8 2a e2 ff ff       	call   f0101352 <page_alloc>
f0103128:	89 c3                	mov    %eax,%ebx
f010312a:	83 c4 10             	add    $0x10,%esp
f010312d:	85 c0                	test   %eax,%eax
f010312f:	0f 84 01 02 00 00    	je     f0103336 <mem_init+0x1b66>
	page_free(pp0);
f0103135:	83 ec 0c             	sub    $0xc,%esp
f0103138:	56                   	push   %esi
f0103139:	e8 86 e2 ff ff       	call   f01013c4 <page_free>
	return (pp - pages) << PGSHIFT;
f010313e:	89 f8                	mov    %edi,%eax
f0103140:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103146:	c1 f8 03             	sar    $0x3,%eax
f0103149:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010314c:	89 c2                	mov    %eax,%edx
f010314e:	c1 ea 0c             	shr    $0xc,%edx
f0103151:	83 c4 10             	add    $0x10,%esp
f0103154:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f010315a:	0f 83 ef 01 00 00    	jae    f010334f <mem_init+0x1b7f>
	memset(page2kva(pp1), 1, PGSIZE);
f0103160:	83 ec 04             	sub    $0x4,%esp
f0103163:	68 00 10 00 00       	push   $0x1000
f0103168:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f010316a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010316f:	50                   	push   %eax
f0103170:	e8 52 37 00 00       	call   f01068c7 <memset>
	return (pp - pages) << PGSHIFT;
f0103175:	89 d8                	mov    %ebx,%eax
f0103177:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010317d:	c1 f8 03             	sar    $0x3,%eax
f0103180:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103183:	89 c2                	mov    %eax,%edx
f0103185:	c1 ea 0c             	shr    $0xc,%edx
f0103188:	83 c4 10             	add    $0x10,%esp
f010318b:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103191:	0f 83 ca 01 00 00    	jae    f0103361 <mem_init+0x1b91>
	memset(page2kva(pp2), 2, PGSIZE);
f0103197:	83 ec 04             	sub    $0x4,%esp
f010319a:	68 00 10 00 00       	push   $0x1000
f010319f:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f01031a1:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01031a6:	50                   	push   %eax
f01031a7:	e8 1b 37 00 00       	call   f01068c7 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f01031ac:	6a 02                	push   $0x2
f01031ae:	68 00 10 00 00       	push   $0x1000
f01031b3:	57                   	push   %edi
f01031b4:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01031ba:	e8 cf e4 ff ff       	call   f010168e <page_insert>
	assert(pp1->pp_ref == 1);
f01031bf:	83 c4 20             	add    $0x20,%esp
f01031c2:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f01031c7:	0f 85 a6 01 00 00    	jne    f0103373 <mem_init+0x1ba3>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01031cd:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01031d4:	01 01 01 
f01031d7:	0f 85 af 01 00 00    	jne    f010338c <mem_init+0x1bbc>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f01031dd:	6a 02                	push   $0x2
f01031df:	68 00 10 00 00       	push   $0x1000
f01031e4:	53                   	push   %ebx
f01031e5:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f01031eb:	e8 9e e4 ff ff       	call   f010168e <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01031f0:	83 c4 10             	add    $0x10,%esp
f01031f3:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f01031fa:	02 02 02 
f01031fd:	0f 85 a2 01 00 00    	jne    f01033a5 <mem_init+0x1bd5>
	assert(pp2->pp_ref == 1);
f0103203:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103208:	0f 85 b0 01 00 00    	jne    f01033be <mem_init+0x1bee>
	assert(pp1->pp_ref == 0);
f010320e:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103213:	0f 85 be 01 00 00    	jne    f01033d7 <mem_init+0x1c07>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103219:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103220:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0103223:	89 d8                	mov    %ebx,%eax
f0103225:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010322b:	c1 f8 03             	sar    $0x3,%eax
f010322e:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103231:	89 c2                	mov    %eax,%edx
f0103233:	c1 ea 0c             	shr    $0xc,%edx
f0103236:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f010323c:	0f 83 ae 01 00 00    	jae    f01033f0 <mem_init+0x1c20>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103242:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0103249:	03 03 03 
f010324c:	0f 85 b0 01 00 00    	jne    f0103402 <mem_init+0x1c32>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0103252:	83 ec 08             	sub    $0x8,%esp
f0103255:	68 00 10 00 00       	push   $0x1000
f010325a:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0103260:	e8 e3 e3 ff ff       	call   f0101648 <page_remove>
	assert(pp2->pp_ref == 0);
f0103265:	83 c4 10             	add    $0x10,%esp
f0103268:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010326d:	0f 85 a8 01 00 00    	jne    f010341b <mem_init+0x1c4b>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103273:	8b 0d 8c ed 5d f0    	mov    0xf05ded8c,%ecx
f0103279:	8b 11                	mov    (%ecx),%edx
f010327b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0103281:	89 f0                	mov    %esi,%eax
f0103283:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103289:	c1 f8 03             	sar    $0x3,%eax
f010328c:	c1 e0 0c             	shl    $0xc,%eax
f010328f:	39 c2                	cmp    %eax,%edx
f0103291:	0f 85 9d 01 00 00    	jne    f0103434 <mem_init+0x1c64>
	kern_pgdir[0] = 0;
f0103297:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f010329d:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01032a2:	0f 85 a5 01 00 00    	jne    f010344d <mem_init+0x1c7d>
	pp0->pp_ref = 0;
f01032a8:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f01032ae:	83 ec 0c             	sub    $0xc,%esp
f01032b1:	56                   	push   %esi
f01032b2:	e8 0d e1 ff ff       	call   f01013c4 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f01032b7:	c7 04 24 d4 91 10 f0 	movl   $0xf01091d4,(%esp)
f01032be:	e8 a2 0f 00 00       	call   f0104265 <cprintf>
	cprintf("__USER_MAP_BEGIN__ = %08x\n", __USER_MAP_BEGIN__);
f01032c3:	83 c4 08             	add    $0x8,%esp
f01032c6:	68 00 10 12 f0       	push   $0xf0121000
f01032cb:	68 e4 95 10 f0       	push   $0xf01095e4
f01032d0:	e8 90 0f 00 00       	call   f0104265 <cprintf>
	cprintf("__USER_MAP_END__ = %08x\n", __USER_MAP_END__);
f01032d5:	83 c4 08             	add    $0x8,%esp
f01032d8:	68 00 c0 16 f0       	push   $0xf016c000
f01032dd:	68 ff 95 10 f0       	push   $0xf01095ff
f01032e2:	e8 7e 0f 00 00       	call   f0104265 <cprintf>
}
f01032e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01032ea:	5b                   	pop    %ebx
f01032eb:	5e                   	pop    %esi
f01032ec:	5f                   	pop    %edi
f01032ed:	5d                   	pop    %ebp
f01032ee:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01032ef:	50                   	push   %eax
f01032f0:	68 30 81 10 f0       	push   $0xf0108130
f01032f5:	68 f0 00 00 00       	push   $0xf0
f01032fa:	68 85 92 10 f0       	push   $0xf0109285
f01032ff:	e8 45 cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0103304:	68 a9 93 10 f0       	push   $0xf01093a9
f0103309:	68 ab 92 10 f0       	push   $0xf01092ab
f010330e:	68 7c 04 00 00       	push   $0x47c
f0103313:	68 85 92 10 f0       	push   $0xf0109285
f0103318:	e8 2c cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010331d:	68 bf 93 10 f0       	push   $0xf01093bf
f0103322:	68 ab 92 10 f0       	push   $0xf01092ab
f0103327:	68 7d 04 00 00       	push   $0x47d
f010332c:	68 85 92 10 f0       	push   $0xf0109285
f0103331:	e8 13 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0103336:	68 d5 93 10 f0       	push   $0xf01093d5
f010333b:	68 ab 92 10 f0       	push   $0xf01092ab
f0103340:	68 7e 04 00 00       	push   $0x47e
f0103345:	68 85 92 10 f0       	push   $0xf0109285
f010334a:	e8 fa cc ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010334f:	50                   	push   %eax
f0103350:	68 0c 81 10 f0       	push   $0xf010810c
f0103355:	6a 58                	push   $0x58
f0103357:	68 91 92 10 f0       	push   $0xf0109291
f010335c:	e8 e8 cc ff ff       	call   f0100049 <_panic>
f0103361:	50                   	push   %eax
f0103362:	68 0c 81 10 f0       	push   $0xf010810c
f0103367:	6a 58                	push   $0x58
f0103369:	68 91 92 10 f0       	push   $0xf0109291
f010336e:	e8 d6 cc ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0103373:	68 a6 94 10 f0       	push   $0xf01094a6
f0103378:	68 ab 92 10 f0       	push   $0xf01092ab
f010337d:	68 83 04 00 00       	push   $0x483
f0103382:	68 85 92 10 f0       	push   $0xf0109285
f0103387:	e8 bd cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f010338c:	68 60 91 10 f0       	push   $0xf0109160
f0103391:	68 ab 92 10 f0       	push   $0xf01092ab
f0103396:	68 84 04 00 00       	push   $0x484
f010339b:	68 85 92 10 f0       	push   $0xf0109285
f01033a0:	e8 a4 cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01033a5:	68 84 91 10 f0       	push   $0xf0109184
f01033aa:	68 ab 92 10 f0       	push   $0xf01092ab
f01033af:	68 86 04 00 00       	push   $0x486
f01033b4:	68 85 92 10 f0       	push   $0xf0109285
f01033b9:	e8 8b cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01033be:	68 c8 94 10 f0       	push   $0xf01094c8
f01033c3:	68 ab 92 10 f0       	push   $0xf01092ab
f01033c8:	68 87 04 00 00       	push   $0x487
f01033cd:	68 85 92 10 f0       	push   $0xf0109285
f01033d2:	e8 72 cc ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f01033d7:	68 32 95 10 f0       	push   $0xf0109532
f01033dc:	68 ab 92 10 f0       	push   $0xf01092ab
f01033e1:	68 88 04 00 00       	push   $0x488
f01033e6:	68 85 92 10 f0       	push   $0xf0109285
f01033eb:	e8 59 cc ff ff       	call   f0100049 <_panic>
f01033f0:	50                   	push   %eax
f01033f1:	68 0c 81 10 f0       	push   $0xf010810c
f01033f6:	6a 58                	push   $0x58
f01033f8:	68 91 92 10 f0       	push   $0xf0109291
f01033fd:	e8 47 cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103402:	68 a8 91 10 f0       	push   $0xf01091a8
f0103407:	68 ab 92 10 f0       	push   $0xf01092ab
f010340c:	68 8a 04 00 00       	push   $0x48a
f0103411:	68 85 92 10 f0       	push   $0xf0109285
f0103416:	e8 2e cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f010341b:	68 00 95 10 f0       	push   $0xf0109500
f0103420:	68 ab 92 10 f0       	push   $0xf01092ab
f0103425:	68 8c 04 00 00       	push   $0x48c
f010342a:	68 85 92 10 f0       	push   $0xf0109285
f010342f:	e8 15 cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103434:	68 04 8b 10 f0       	push   $0xf0108b04
f0103439:	68 ab 92 10 f0       	push   $0xf01092ab
f010343e:	68 8f 04 00 00       	push   $0x48f
f0103443:	68 85 92 10 f0       	push   $0xf0109285
f0103448:	e8 fc cb ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f010344d:	68 b7 94 10 f0       	push   $0xf01094b7
f0103452:	68 ab 92 10 f0       	push   $0xf01092ab
f0103457:	68 91 04 00 00       	push   $0x491
f010345c:	68 85 92 10 f0       	push   $0xf0109285
f0103461:	e8 e3 cb ff ff       	call   f0100049 <_panic>

f0103466 <user_mem_check>:
{
f0103466:	55                   	push   %ebp
f0103467:	89 e5                	mov    %esp,%ebp
f0103469:	57                   	push   %edi
f010346a:	56                   	push   %esi
f010346b:	53                   	push   %ebx
f010346c:	83 ec 1c             	sub    $0x1c,%esp
f010346f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	perm |= PTE_P;
f0103472:	8b 7d 14             	mov    0x14(%ebp),%edi
f0103475:	83 cf 01             	or     $0x1,%edi
	uint32_t i = (uint32_t)va; //buggy lab3 buggy
f0103478:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	uint32_t end = (uint32_t)va + len;
f010347b:	89 d8                	mov    %ebx,%eax
f010347d:	03 45 10             	add    0x10(%ebp),%eax
f0103480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103483:	8b 75 08             	mov    0x8(%ebp),%esi
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f0103486:	eb 19                	jmp    f01034a1 <user_mem_check+0x3b>
			user_mem_check_addr = (uintptr_t)i;
f0103488:	89 1d 3c d9 5d f0    	mov    %ebx,0xf05dd93c
			return -E_FAULT;
f010348e:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103493:	eb 6a                	jmp    f01034ff <user_mem_check+0x99>
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f0103495:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010349b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01034a1:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01034a4:	73 61                	jae    f0103507 <user_mem_check+0xa1>
		if((uint32_t)va >= ULIM){
f01034a6:	81 7d e0 ff ff 7f ef 	cmpl   $0xef7fffff,-0x20(%ebp)
f01034ad:	77 d9                	ja     f0103488 <user_mem_check+0x22>
		pte_t *the_pte = pgdir_walk(env->env_pgdir, (void *)i, 0);
f01034af:	83 ec 04             	sub    $0x4,%esp
f01034b2:	6a 00                	push   $0x0
f01034b4:	53                   	push   %ebx
f01034b5:	ff 76 60             	pushl  0x60(%esi)
f01034b8:	e8 6b df ff ff       	call   f0101428 <pgdir_walk>
		if(!the_pte || (*the_pte & perm) != perm){//lab4 bug
f01034bd:	83 c4 10             	add    $0x10,%esp
f01034c0:	85 c0                	test   %eax,%eax
f01034c2:	74 08                	je     f01034cc <user_mem_check+0x66>
f01034c4:	89 fa                	mov    %edi,%edx
f01034c6:	23 10                	and    (%eax),%edx
f01034c8:	39 d7                	cmp    %edx,%edi
f01034ca:	74 c9                	je     f0103495 <user_mem_check+0x2f>
f01034cc:	89 c6                	mov    %eax,%esi
			cprintf("PTE_P: 0x%x PTE_W: 0x%x PTE_U: 0x%x\n", PTE_P, PTE_W, PTE_U);
f01034ce:	6a 04                	push   $0x4
f01034d0:	6a 02                	push   $0x2
f01034d2:	6a 01                	push   $0x1
f01034d4:	68 00 92 10 f0       	push   $0xf0109200
f01034d9:	e8 87 0d 00 00       	call   f0104265 <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f01034de:	83 c4 0c             	add    $0xc,%esp
f01034e1:	89 f8                	mov    %edi,%eax
f01034e3:	23 06                	and    (%esi),%eax
f01034e5:	50                   	push   %eax
f01034e6:	57                   	push   %edi
f01034e7:	68 28 92 10 f0       	push   $0xf0109228
f01034ec:	e8 74 0d 00 00       	call   f0104265 <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f01034f1:	89 1d 3c d9 5d f0    	mov    %ebx,0xf05dd93c
			return -E_FAULT;
f01034f7:	83 c4 10             	add    $0x10,%esp
f01034fa:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01034ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103502:	5b                   	pop    %ebx
f0103503:	5e                   	pop    %esi
f0103504:	5f                   	pop    %edi
f0103505:	5d                   	pop    %ebp
f0103506:	c3                   	ret    
	return 0;
f0103507:	b8 00 00 00 00       	mov    $0x0,%eax
f010350c:	eb f1                	jmp    f01034ff <user_mem_check+0x99>

f010350e <user_mem_assert>:
{
f010350e:	55                   	push   %ebp
f010350f:	89 e5                	mov    %esp,%ebp
f0103511:	53                   	push   %ebx
f0103512:	83 ec 04             	sub    $0x4,%esp
f0103515:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103518:	8b 45 14             	mov    0x14(%ebp),%eax
f010351b:	83 c8 04             	or     $0x4,%eax
f010351e:	50                   	push   %eax
f010351f:	ff 75 10             	pushl  0x10(%ebp)
f0103522:	ff 75 0c             	pushl  0xc(%ebp)
f0103525:	53                   	push   %ebx
f0103526:	e8 3b ff ff ff       	call   f0103466 <user_mem_check>
f010352b:	83 c4 10             	add    $0x10,%esp
f010352e:	85 c0                	test   %eax,%eax
f0103530:	78 05                	js     f0103537 <user_mem_assert+0x29>
}
f0103532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103535:	c9                   	leave  
f0103536:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103537:	83 ec 04             	sub    $0x4,%esp
f010353a:	ff 35 3c d9 5d f0    	pushl  0xf05dd93c
f0103540:	ff 73 48             	pushl  0x48(%ebx)
f0103543:	68 50 92 10 f0       	push   $0xf0109250
f0103548:	e8 18 0d 00 00       	call   f0104265 <cprintf>
		env_destroy(env);	// may not return
f010354d:	89 1c 24             	mov    %ebx,(%esp)
f0103550:	e8 08 0b 00 00       	call   f010405d <env_destroy>
f0103555:	83 c4 10             	add    $0x10,%esp
}
f0103558:	eb d8                	jmp    f0103532 <user_mem_assert+0x24>

f010355a <check_user_map>:
	}
}

 static void
check_user_map(pde_t *pgdir, void *va, uint32_t len, const char *name)
{
f010355a:	55                   	push   %ebp
f010355b:	89 e5                	mov    %esp,%ebp
f010355d:	57                   	push   %edi
f010355e:	56                   	push   %esi
f010355f:	53                   	push   %ebx
f0103560:	83 ec 2c             	sub    $0x2c,%esp
f0103563:	89 c7                	mov    %eax,%edi
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f0103565:	89 d3                	mov    %edx,%ebx
f0103567:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f010356d:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0103574:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103579:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		pte_t *pte;
		if (page_lookup(pgdir, (void *) _va, &pte) == NULL) {
f010357c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f010357f:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0103582:	73 35                	jae    f01035b9 <check_user_map+0x5f>
		if (page_lookup(pgdir, (void *) _va, &pte) == NULL) {
f0103584:	83 ec 04             	sub    $0x4,%esp
f0103587:	56                   	push   %esi
f0103588:	53                   	push   %ebx
f0103589:	57                   	push   %edi
f010358a:	e8 1f e0 ff ff       	call   f01015ae <page_lookup>
f010358f:	83 c4 10             	add    $0x10,%esp
f0103592:	85 c0                	test   %eax,%eax
f0103594:	74 10                	je     f01035a6 <check_user_map+0x4c>
			cprintf("%s not mapped in env_pgdir\n", name);
			return;
		}
		if (*pte & PTE_U) {
f0103596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103599:	f6 00 04             	testb  $0x4,(%eax)
f010359c:	75 23                	jne    f01035c1 <check_user_map+0x67>
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f010359e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01035a4:	eb d9                	jmp    f010357f <check_user_map+0x25>
			cprintf("%s not mapped in env_pgdir\n", name);
f01035a6:	83 ec 08             	sub    $0x8,%esp
f01035a9:	ff 75 08             	pushl  0x8(%ebp)
f01035ac:	68 28 96 10 f0       	push   $0xf0109628
f01035b1:	e8 af 0c 00 00       	call   f0104265 <cprintf>
			return;
f01035b6:	83 c4 10             	add    $0x10,%esp
			cprintf("%s wrong permission in env_pgdir\n", name);
			return;
		}
	}
}
f01035b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01035bc:	5b                   	pop    %ebx
f01035bd:	5e                   	pop    %esi
f01035be:	5f                   	pop    %edi
f01035bf:	5d                   	pop    %ebp
f01035c0:	c3                   	ret    
			cprintf("%s wrong permission in env_pgdir\n", name);
f01035c1:	83 ec 08             	sub    $0x8,%esp
f01035c4:	ff 75 08             	pushl  0x8(%ebp)
f01035c7:	68 d4 97 10 f0       	push   $0xf01097d4
f01035cc:	e8 94 0c 00 00       	call   f0104265 <cprintf>
			return;
f01035d1:	83 c4 10             	add    $0x10,%esp
f01035d4:	eb e3                	jmp    f01035b9 <check_user_map+0x5f>

f01035d6 <region_alloc>:
{
f01035d6:	55                   	push   %ebp
f01035d7:	89 e5                	mov    %esp,%ebp
f01035d9:	57                   	push   %edi
f01035da:	56                   	push   %esi
f01035db:	53                   	push   %ebx
f01035dc:	83 ec 0c             	sub    $0xc,%esp
f01035df:	89 c7                	mov    %eax,%edi
	int i = ROUNDDOWN((uint32_t)va, PGSIZE);
f01035e1:	89 d3                	mov    %edx,%ebx
f01035e3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)va + len, PGSIZE);
f01035e9:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01035f0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01035f6:	39 f3                	cmp    %esi,%ebx
f01035f8:	7d 5a                	jge    f0103654 <region_alloc+0x7e>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01035fa:	83 ec 0c             	sub    $0xc,%esp
f01035fd:	6a 01                	push   $0x1
f01035ff:	e8 4e dd ff ff       	call   f0101352 <page_alloc>
		if(!page)
f0103604:	83 c4 10             	add    $0x10,%esp
f0103607:	85 c0                	test   %eax,%eax
f0103609:	74 1b                	je     f0103626 <region_alloc+0x50>
		int ret = page_insert(e->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f010360b:	6a 06                	push   $0x6
f010360d:	53                   	push   %ebx
f010360e:	50                   	push   %eax
f010360f:	ff 77 60             	pushl  0x60(%edi)
f0103612:	e8 77 e0 ff ff       	call   f010168e <page_insert>
		if(ret)
f0103617:	83 c4 10             	add    $0x10,%esp
f010361a:	85 c0                	test   %eax,%eax
f010361c:	75 1f                	jne    f010363d <region_alloc+0x67>
	for(; i < end; i+=PGSIZE){
f010361e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103624:	eb d0                	jmp    f01035f6 <region_alloc+0x20>
			panic("there is no page\n");
f0103626:	83 ec 04             	sub    $0x4,%esp
f0103629:	68 44 96 10 f0       	push   $0xf0109644
f010362e:	68 d3 00 00 00       	push   $0xd3
f0103633:	68 56 96 10 f0       	push   $0xf0109656
f0103638:	e8 0c ca ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f010363d:	83 ec 04             	sub    $0x4,%esp
f0103640:	68 61 96 10 f0       	push   $0xf0109661
f0103645:	68 d6 00 00 00       	push   $0xd6
f010364a:	68 56 96 10 f0       	push   $0xf0109656
f010364f:	e8 f5 c9 ff ff       	call   f0100049 <_panic>
}
f0103654:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103657:	5b                   	pop    %ebx
f0103658:	5e                   	pop    %esi
f0103659:	5f                   	pop    %edi
f010365a:	5d                   	pop    %ebp
f010365b:	c3                   	ret    

f010365c <envid2env>:
{
f010365c:	55                   	push   %ebp
f010365d:	89 e5                	mov    %esp,%ebp
f010365f:	56                   	push   %esi
f0103660:	53                   	push   %ebx
f0103661:	8b 75 08             	mov    0x8(%ebp),%esi
f0103664:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103667:	85 f6                	test   %esi,%esi
f0103669:	74 34                	je     f010369f <envid2env+0x43>
	e = &envs[ENVX(envid)];
f010366b:	89 f3                	mov    %esi,%ebx
f010366d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103673:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
f0103679:	03 1d 44 d9 5d f0    	add    0xf05dd944,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010367f:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103683:	74 31                	je     f01036b6 <envid2env+0x5a>
f0103685:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103688:	75 2c                	jne    f01036b6 <envid2env+0x5a>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010368a:	84 c0                	test   %al,%al
f010368c:	75 61                	jne    f01036ef <envid2env+0x93>
	*env_store = e;
f010368e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103691:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103693:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103698:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010369b:	5b                   	pop    %ebx
f010369c:	5e                   	pop    %esi
f010369d:	5d                   	pop    %ebp
f010369e:	c3                   	ret    
		*env_store = curenv;
f010369f:	e8 73 de 01 00       	call   f0121517 <cpunum>
f01036a4:	6b c0 74             	imul   $0x74,%eax,%eax
f01036a7:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01036ad:	8b 55 0c             	mov    0xc(%ebp),%edx
f01036b0:	89 02                	mov    %eax,(%edx)
		return 0;
f01036b2:	89 f0                	mov    %esi,%eax
f01036b4:	eb e2                	jmp    f0103698 <envid2env+0x3c>
		*env_store = 0;
f01036b6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		if(e->env_status == ENV_FREE)
f01036bf:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01036c3:	74 17                	je     f01036dc <envid2env+0x80>
		cprintf("222222222222222222222\n");
f01036c5:	83 ec 0c             	sub    $0xc,%esp
f01036c8:	68 9d 96 10 f0       	push   $0xf010969d
f01036cd:	e8 93 0b 00 00       	call   f0104265 <cprintf>
		return -E_BAD_ENV;
f01036d2:	83 c4 10             	add    $0x10,%esp
f01036d5:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01036da:	eb bc                	jmp    f0103698 <envid2env+0x3c>
			cprintf("ssssssssssssssssss %d\n", envid);
f01036dc:	83 ec 08             	sub    $0x8,%esp
f01036df:	56                   	push   %esi
f01036e0:	68 86 96 10 f0       	push   $0xf0109686
f01036e5:	e8 7b 0b 00 00       	call   f0104265 <cprintf>
f01036ea:	83 c4 10             	add    $0x10,%esp
f01036ed:	eb d6                	jmp    f01036c5 <envid2env+0x69>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01036ef:	e8 23 de 01 00       	call   f0121517 <cpunum>
f01036f4:	6b c0 74             	imul   $0x74,%eax,%eax
f01036f7:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f01036fd:	74 8f                	je     f010368e <envid2env+0x32>
f01036ff:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103702:	e8 10 de 01 00       	call   f0121517 <cpunum>
f0103707:	6b c0 74             	imul   $0x74,%eax,%eax
f010370a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103710:	3b 70 48             	cmp    0x48(%eax),%esi
f0103713:	0f 84 75 ff ff ff    	je     f010368e <envid2env+0x32>
		*env_store = 0;
f0103719:	8b 45 0c             	mov    0xc(%ebp),%eax
f010371c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		cprintf("33333333333333333333333\n");
f0103722:	83 ec 0c             	sub    $0xc,%esp
f0103725:	68 b4 96 10 f0       	push   $0xf01096b4
f010372a:	e8 36 0b 00 00       	call   f0104265 <cprintf>
		return -E_BAD_ENV;
f010372f:	83 c4 10             	add    $0x10,%esp
f0103732:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103737:	e9 5c ff ff ff       	jmp    f0103698 <envid2env+0x3c>

f010373c <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f010373c:	b8 08 d3 16 f0       	mov    $0xf016d308,%eax
f0103741:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103744:	b8 23 00 00 00       	mov    $0x23,%eax
f0103749:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f010374b:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f010374d:	b8 10 00 00 00       	mov    $0x10,%eax
f0103752:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103754:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103756:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103758:	ea 5f 37 10 f0 08 00 	ljmp   $0x8,$0xf010375f
	asm volatile("lldt %0" : : "r" (sel));
f010375f:	b8 00 00 00 00       	mov    $0x0,%eax
f0103764:	0f 00 d0             	lldt   %ax
}
f0103767:	c3                   	ret    

f0103768 <env_init>:
{
f0103768:	55                   	push   %ebp
f0103769:	89 e5                	mov    %esp,%ebp
f010376b:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f010376e:	8b 15 44 d9 5d f0    	mov    0xf05dd944,%edx
f0103774:	8d 82 84 00 00 00    	lea    0x84(%edx),%eax
f010377a:	81 c2 00 10 02 00    	add    $0x21000,%edx
f0103780:	c7 40 c4 00 00 00 00 	movl   $0x0,-0x3c(%eax)
		envs[i].env_link = &envs[i+1];
f0103787:	89 40 c0             	mov    %eax,-0x40(%eax)
f010378a:	05 84 00 00 00       	add    $0x84,%eax
	for(int i = 0; i < NENV - 1; i++){
f010378f:	39 d0                	cmp    %edx,%eax
f0103791:	75 ed                	jne    f0103780 <env_init+0x18>
	env_free_list = envs;
f0103793:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0103798:	a3 48 d9 5d f0       	mov    %eax,0xf05dd948
	env_init_percpu();
f010379d:	e8 9a ff ff ff       	call   f010373c <env_init_percpu>
}
f01037a2:	c9                   	leave  
f01037a3:	c3                   	ret    

f01037a4 <env_alloc>:
{
f01037a4:	55                   	push   %ebp
f01037a5:	89 e5                	mov    %esp,%ebp
f01037a7:	57                   	push   %edi
f01037a8:	56                   	push   %esi
f01037a9:	53                   	push   %ebx
f01037aa:	83 ec 34             	sub    $0x34,%esp
	cprintf("in %s\n", __FUNCTION__);
f01037ad:	68 a0 99 10 f0       	push   $0xf01099a0
f01037b2:	68 20 80 10 f0       	push   $0xf0108020
f01037b7:	e8 a9 0a 00 00       	call   f0104265 <cprintf>
	if (!(e = env_free_list))
f01037bc:	8b 1d 48 d9 5d f0    	mov    0xf05dd948,%ebx
f01037c2:	83 c4 10             	add    $0x10,%esp
f01037c5:	85 db                	test   %ebx,%ebx
f01037c7:	0f 84 4a 04 00 00    	je     f0103c17 <env_alloc+0x473>
	cprintf("in %s\n", __FUNCTION__);
f01037cd:	83 ec 08             	sub    $0x8,%esp
f01037d0:	68 90 99 10 f0       	push   $0xf0109990
f01037d5:	68 20 80 10 f0       	push   $0xf0108020
f01037da:	e8 86 0a 00 00       	call   f0104265 <cprintf>
	cprintf("the e is 0x%x\n", e);
f01037df:	83 c4 08             	add    $0x8,%esp
f01037e2:	53                   	push   %ebx
f01037e3:	68 cd 96 10 f0       	push   $0xf01096cd
f01037e8:	e8 78 0a 00 00       	call   f0104265 <cprintf>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01037ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01037f4:	e8 59 db ff ff       	call   f0101352 <page_alloc>
f01037f9:	83 c4 10             	add    $0x10,%esp
f01037fc:	85 c0                	test   %eax,%eax
f01037fe:	0f 84 1a 04 00 00    	je     f0103c1e <env_alloc+0x47a>
	p->pp_ref++;
f0103804:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103809:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f010380f:	c1 f8 03             	sar    $0x3,%eax
f0103812:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103815:	89 c2                	mov    %eax,%edx
f0103817:	c1 ea 0c             	shr    $0xc,%edx
f010381a:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103820:	73 2c                	jae    f010384e <env_alloc+0xaa>
	return (void *)(pa + KERNBASE);
f0103822:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103827:	89 43 60             	mov    %eax,0x60(%ebx)
	cprintf("the __USER_MAP_BEGIN__ is 0x%x and the __USER_MAP_END__ is 0x%x\n", __USER_MAP_BEGIN__, __USER_MAP_END__);
f010382a:	83 ec 04             	sub    $0x4,%esp
f010382d:	68 00 c0 16 f0       	push   $0xf016c000
f0103832:	68 00 10 12 f0       	push   $0xf0121000
f0103837:	68 f8 97 10 f0       	push   $0xf01097f8
f010383c:	e8 24 0a 00 00       	call   f0104265 <cprintf>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f0103841:	be 00 10 12 f0       	mov    $0xf0121000,%esi
f0103846:	83 c4 10             	add    $0x10,%esp
f0103849:	e9 95 00 00 00       	jmp    f01038e3 <env_alloc+0x13f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010384e:	50                   	push   %eax
f010384f:	68 0c 81 10 f0       	push   $0xf010810c
f0103854:	6a 58                	push   $0x58
f0103856:	68 91 92 10 f0       	push   $0xf0109291
f010385b:	e8 e9 c7 ff ff       	call   f0100049 <_panic>
			cprintf("jesus!\n");
f0103860:	83 ec 0c             	sub    $0xc,%esp
f0103863:	68 dc 96 10 f0       	push   $0xf01096dc
f0103868:	e8 f8 09 00 00       	call   f0104265 <cprintf>
			cprintf("+PGSIZE: 0x%x\n", i + PGSIZE);
f010386d:	83 c4 08             	add    $0x8,%esp
f0103870:	68 00 20 12 f0       	push   $0xf0122000
f0103875:	68 e4 96 10 f0       	push   $0xf01096e4
f010387a:	e8 e6 09 00 00       	call   f0104265 <cprintf>
			if(pageInfo == NULL)
f010387f:	83 c4 10             	add    $0x10,%esp
f0103882:	85 ff                	test   %edi,%edi
f0103884:	74 2d                	je     f01038b3 <env_alloc+0x10f>
			cprintf("the pageInfo is 0x%x\n", pageInfo);
f0103886:	83 ec 08             	sub    $0x8,%esp
f0103889:	57                   	push   %edi
f010388a:	68 fa 96 10 f0       	push   $0xf01096fa
f010388f:	e8 d1 09 00 00       	call   f0104265 <cprintf>
			cprintf("the pte_store perm is 0x%x and PTE_P is 0x%x\n", PGOFF(*pte_store), PTE_P);
f0103894:	83 c4 0c             	add    $0xc,%esp
f0103897:	6a 01                	push   $0x1
f0103899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010389c:	8b 00                	mov    (%eax),%eax
f010389e:	25 ff 0f 00 00       	and    $0xfff,%eax
f01038a3:	50                   	push   %eax
f01038a4:	68 3c 98 10 f0       	push   $0xf010983c
f01038a9:	e8 b7 09 00 00       	call   f0104265 <cprintf>
f01038ae:	83 c4 10             	add    $0x10,%esp
f01038b1:	eb 63                	jmp    f0103916 <env_alloc+0x172>
				cprintf("cnm??\n");
f01038b3:	83 ec 0c             	sub    $0xc,%esp
f01038b6:	68 f3 96 10 f0       	push   $0xf01096f3
f01038bb:	e8 a5 09 00 00       	call   f0104265 <cprintf>
f01038c0:	83 c4 10             	add    $0x10,%esp
f01038c3:	eb c1                	jmp    f0103886 <env_alloc+0xe2>
			cprintf("the addr: %s pageInfo is null continue\n", pageInfo);
f01038c5:	83 ec 08             	sub    $0x8,%esp
f01038c8:	6a 00                	push   $0x0
f01038ca:	68 6c 98 10 f0       	push   $0xf010986c
f01038cf:	e8 91 09 00 00       	call   f0104265 <cprintf>
			continue;
f01038d4:	83 c4 10             	add    $0x10,%esp
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f01038d7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01038dd:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01038e3:	81 fe 00 c0 16 f0    	cmp    $0xf016c000,%esi
f01038e9:	0f 83 8c 00 00 00    	jae    f010397b <env_alloc+0x1d7>
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void *)i, &pte_store);
f01038ef:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f01038f2:	83 ec 04             	sub    $0x4,%esp
f01038f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01038f8:	50                   	push   %eax
f01038f9:	56                   	push   %esi
f01038fa:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0103900:	e8 a9 dc ff ff       	call   f01015ae <page_lookup>
f0103905:	89 c7                	mov    %eax,%edi
		if(i == 0xf0121000){
f0103907:	83 c4 10             	add    $0x10,%esp
f010390a:	81 fe 00 10 12 f0    	cmp    $0xf0121000,%esi
f0103910:	0f 84 4a ff ff ff    	je     f0103860 <env_alloc+0xbc>
		if(pageInfo == NULL){
f0103916:	85 ff                	test   %edi,%edi
f0103918:	74 ab                	je     f01038c5 <env_alloc+0x121>
		r = page_insert(e->env_pgdir, pageInfo, (void *)i, PTE_P);
f010391a:	6a 01                	push   $0x1
f010391c:	ff 75 d4             	pushl  -0x2c(%ebp)
f010391f:	57                   	push   %edi
f0103920:	ff 73 60             	pushl  0x60(%ebx)
f0103923:	e8 66 dd ff ff       	call   f010168e <page_insert>
		if(r < 0)
f0103928:	83 c4 10             	add    $0x10,%esp
f010392b:	85 c0                	test   %eax,%eax
f010392d:	78 37                	js     f0103966 <env_alloc+0x1c2>
		if(i == 0xf0121000){
f010392f:	81 fe 00 10 12 f0    	cmp    $0xf0121000,%esi
f0103935:	75 a0                	jne    f01038d7 <env_alloc+0x133>
			pageInfo = page_lookup(e->env_pgdir, (void *)i, &pte_store);
f0103937:	83 ec 04             	sub    $0x4,%esp
f010393a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010393d:	50                   	push   %eax
f010393e:	68 00 10 12 f0       	push   $0xf0121000
f0103943:	ff 73 60             	pushl  0x60(%ebx)
f0103946:	e8 63 dc ff ff       	call   f01015ae <page_lookup>
			cprintf("after insert we check pageInfo: 0x%x and perm : 0x%x\n", pageInfo, *pte_store);
f010394b:	83 c4 0c             	add    $0xc,%esp
f010394e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103951:	ff 32                	pushl  (%edx)
f0103953:	50                   	push   %eax
f0103954:	68 94 98 10 f0       	push   $0xf0109894
f0103959:	e8 07 09 00 00       	call   f0104265 <cprintf>
f010395e:	83 c4 10             	add    $0x10,%esp
f0103961:	e9 71 ff ff ff       	jmp    f01038d7 <env_alloc+0x133>
			panic("test panic error %e\n", r);
f0103966:	50                   	push   %eax
f0103967:	68 10 97 10 f0       	push   $0xf0109710
f010396c:	68 ef 00 00 00       	push   $0xef
f0103971:	68 56 96 10 f0       	push   $0xf0109656
f0103976:	e8 ce c6 ff ff       	call   f0100049 <_panic>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f010397b:	bf 00 00 00 f0       	mov    $0xf0000000,%edi
f0103980:	eb 58                	jmp    f01039da <env_alloc+0x236>
f0103982:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for(uint32_t stackRange = 0; stackRange < KSTKSIZE; stackRange += PGSIZE){
f0103988:	39 fe                	cmp    %edi,%esi
f010398a:	74 40                	je     f01039cc <env_alloc+0x228>
			struct PageInfo* pageInfo = page_lookup(kern_pgdir, va, NULL);
f010398c:	83 ec 04             	sub    $0x4,%esp
f010398f:	6a 00                	push   $0x0
f0103991:	56                   	push   %esi
f0103992:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0103998:	e8 11 dc ff ff       	call   f01015ae <page_lookup>
			if(pageInfo == NULL)
f010399d:	83 c4 10             	add    $0x10,%esp
f01039a0:	85 c0                	test   %eax,%eax
f01039a2:	74 de                	je     f0103982 <env_alloc+0x1de>
			r = page_insert(e->env_pgdir, pageInfo, va, PTE_P|PTE_W);
f01039a4:	6a 03                	push   $0x3
f01039a6:	56                   	push   %esi
f01039a7:	50                   	push   %eax
f01039a8:	ff 73 60             	pushl  0x60(%ebx)
f01039ab:	e8 de dc ff ff       	call   f010168e <page_insert>
			if(r < 0)
f01039b0:	83 c4 10             	add    $0x10,%esp
f01039b3:	85 c0                	test   %eax,%eax
f01039b5:	79 cb                	jns    f0103982 <env_alloc+0x1de>
			panic("test panic error %e\n", r);
f01039b7:	50                   	push   %eax
f01039b8:	68 10 97 10 f0       	push   $0xf0109710
f01039bd:	68 fe 00 00 00       	push   $0xfe
f01039c2:	68 56 96 10 f0       	push   $0xf0109656
f01039c7:	e8 7d c6 ff ff       	call   f0100049 <_panic>
f01039cc:	81 ef 00 00 01 00    	sub    $0x10000,%edi
	for(int i = 0; i < NCPU; i++){
f01039d2:	81 ff 00 00 f8 ef    	cmp    $0xeff80000,%edi
f01039d8:	74 08                	je     f01039e2 <env_alloc+0x23e>
f01039da:	8d b7 00 80 ff ff    	lea    -0x8000(%edi),%esi
f01039e0:	eb aa                	jmp    f010398c <env_alloc+0x1e8>
	cprintf("set up envs : 0x%x\n", envs);
f01039e2:	83 ec 08             	sub    $0x8,%esp
f01039e5:	ff 35 44 d9 5d f0    	pushl  0xf05dd944
f01039eb:	68 25 97 10 f0       	push   $0xf0109725
f01039f0:	e8 70 08 00 00       	call   f0104265 <cprintf>
	for(uint32_t i = (uint32_t)envs; i < (uint32_t)(envs+NENV); i+=PGSIZE){
f01039f5:	8b 35 44 d9 5d f0    	mov    0xf05dd944,%esi
f01039fb:	83 c4 10             	add    $0x10,%esp
f01039fe:	eb 16                	jmp    f0103a16 <env_alloc+0x272>
			cprintf("the page info is null\n");
f0103a00:	83 ec 0c             	sub    $0xc,%esp
f0103a03:	68 39 97 10 f0       	push   $0xf0109739
f0103a08:	e8 58 08 00 00       	call   f0104265 <cprintf>
f0103a0d:	83 c4 10             	add    $0x10,%esp
	for(uint32_t i = (uint32_t)envs; i < (uint32_t)(envs+NENV); i+=PGSIZE){
f0103a10:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103a16:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0103a1b:	05 00 10 02 00       	add    $0x21000,%eax
f0103a20:	39 c6                	cmp    %eax,%esi
f0103a22:	73 40                	jae    f0103a64 <env_alloc+0x2c0>
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void*)i, NULL);
f0103a24:	83 ec 04             	sub    $0x4,%esp
f0103a27:	6a 00                	push   $0x0
f0103a29:	56                   	push   %esi
f0103a2a:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0103a30:	e8 79 db ff ff       	call   f01015ae <page_lookup>
		if(pageInfo == NULL){
f0103a35:	83 c4 10             	add    $0x10,%esp
f0103a38:	85 c0                	test   %eax,%eax
f0103a3a:	74 c4                	je     f0103a00 <env_alloc+0x25c>
		r = page_insert(e->env_pgdir, pageInfo, (void*)i, PTE_P);
f0103a3c:	6a 01                	push   $0x1
f0103a3e:	56                   	push   %esi
f0103a3f:	50                   	push   %eax
f0103a40:	ff 73 60             	pushl  0x60(%ebx)
f0103a43:	e8 46 dc ff ff       	call   f010168e <page_insert>
		if(r < 0)
f0103a48:	83 c4 10             	add    $0x10,%esp
f0103a4b:	85 c0                	test   %eax,%eax
f0103a4d:	79 c1                	jns    f0103a10 <env_alloc+0x26c>
			panic("test panic error %e\n", r);
f0103a4f:	50                   	push   %eax
f0103a50:	68 10 97 10 f0       	push   $0xf0109710
f0103a55:	68 0b 01 00 00       	push   $0x10b
f0103a5a:	68 56 96 10 f0       	push   $0xf0109656
f0103a5f:	e8 e5 c5 ff ff       	call   f0100049 <_panic>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103a64:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103a67:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a6c:	0f 86 69 01 00 00    	jbe    f0103bdb <env_alloc+0x437>
	return (physaddr_t)kva - KERNBASE;
f0103a72:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103a78:	83 ca 05             	or     $0x5,%edx
f0103a7b:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	if (!(kern_p = page_alloc(ALLOC_ZERO)))
f0103a81:	83 ec 0c             	sub    $0xc,%esp
f0103a84:	6a 01                	push   $0x1
f0103a86:	e8 c7 d8 ff ff       	call   f0101352 <page_alloc>
f0103a8b:	83 c4 10             	add    $0x10,%esp
f0103a8e:	85 c0                	test   %eax,%eax
f0103a90:	0f 84 88 01 00 00    	je     f0103c1e <env_alloc+0x47a>
	kern_p->pp_ref++;
f0103a96:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103a9b:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103aa1:	c1 f8 03             	sar    $0x3,%eax
f0103aa4:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103aa7:	89 c2                	mov    %eax,%edx
f0103aa9:	c1 ea 0c             	shr    $0xc,%edx
f0103aac:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103ab2:	0f 83 38 01 00 00    	jae    f0103bf0 <env_alloc+0x44c>
	return (void *)(pa + KERNBASE);
f0103ab8:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_kern_pgdir = (pde_t *)page2kva(kern_p);
f0103abd:	89 43 64             	mov    %eax,0x64(%ebx)
	memcpy((void *)e->env_kern_pgdir, (void *)kern_pgdir, PGSIZE);
f0103ac0:	83 ec 04             	sub    $0x4,%esp
f0103ac3:	68 00 10 00 00       	push   $0x1000
f0103ac8:	ff 35 8c ed 5d f0    	pushl  0xf05ded8c
f0103ace:	50                   	push   %eax
f0103acf:	e8 9d 2e 00 00       	call   f0106971 <memcpy>
	e->env_kern_pgdir[PDX(UVPT)] = PADDR(e->env_kern_pgdir) | PTE_P | PTE_U;
f0103ad4:	8b 43 64             	mov    0x64(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103ad7:	83 c4 10             	add    $0x10,%esp
f0103ada:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103adf:	0f 86 1d 01 00 00    	jbe    f0103c02 <env_alloc+0x45e>
	return (physaddr_t)kva - KERNBASE;
f0103ae5:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103aeb:	83 ca 05             	or     $0x5,%edx
f0103aee:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103af4:	8b 43 48             	mov    0x48(%ebx),%eax
f0103af7:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103afc:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103b01:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103b06:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103b09:	89 da                	mov    %ebx,%edx
f0103b0b:	2b 15 44 d9 5d f0    	sub    0xf05dd944,%edx
f0103b11:	c1 fa 02             	sar    $0x2,%edx
f0103b14:	69 d2 e1 83 0f 3e    	imul   $0x3e0f83e1,%edx,%edx
f0103b1a:	09 d0                	or     %edx,%eax
f0103b1c:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b22:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103b25:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103b2c:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103b33:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f0103b3a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
f0103b41:	00 00 00 
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103b44:	83 ec 04             	sub    $0x4,%esp
f0103b47:	6a 44                	push   $0x44
f0103b49:	6a 00                	push   $0x0
f0103b4b:	53                   	push   %ebx
f0103b4c:	e8 76 2d 00 00       	call   f01068c7 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103b51:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103b57:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103b5d:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103b63:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103b6a:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103b70:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103b77:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
	e->env_ipc_recving = 0;
f0103b7e:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
	env_free_list = e->env_link;
f0103b82:	8b 43 44             	mov    0x44(%ebx),%eax
f0103b85:	a3 48 d9 5d f0       	mov    %eax,0xf05dd948
	*newenv_store = e;
f0103b8a:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b8d:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103b8f:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103b92:	e8 80 d9 01 00       	call   f0121517 <cpunum>
f0103b97:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b9a:	83 c4 10             	add    $0x10,%esp
f0103b9d:	ba 00 00 00 00       	mov    $0x0,%edx
f0103ba2:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0103ba9:	74 11                	je     f0103bbc <env_alloc+0x418>
f0103bab:	e8 67 d9 01 00       	call   f0121517 <cpunum>
f0103bb0:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bb3:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103bb9:	8b 50 48             	mov    0x48(%eax),%edx
f0103bbc:	83 ec 04             	sub    $0x4,%esp
f0103bbf:	53                   	push   %ebx
f0103bc0:	52                   	push   %edx
f0103bc1:	68 50 97 10 f0       	push   $0xf0109750
f0103bc6:	e8 9a 06 00 00       	call   f0104265 <cprintf>
	return 0;
f0103bcb:	83 c4 10             	add    $0x10,%esp
f0103bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103bd6:	5b                   	pop    %ebx
f0103bd7:	5e                   	pop    %esi
f0103bd8:	5f                   	pop    %edi
f0103bd9:	5d                   	pop    %ebp
f0103bda:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bdb:	50                   	push   %eax
f0103bdc:	68 30 81 10 f0       	push   $0xf0108130
f0103be1:	68 42 01 00 00       	push   $0x142
f0103be6:	68 56 96 10 f0       	push   $0xf0109656
f0103beb:	e8 59 c4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103bf0:	50                   	push   %eax
f0103bf1:	68 0c 81 10 f0       	push   $0xf010810c
f0103bf6:	6a 58                	push   $0x58
f0103bf8:	68 91 92 10 f0       	push   $0xf0109291
f0103bfd:	e8 47 c4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103c02:	50                   	push   %eax
f0103c03:	68 30 81 10 f0       	push   $0xf0108130
f0103c08:	68 4c 01 00 00       	push   $0x14c
f0103c0d:	68 56 96 10 f0       	push   $0xf0109656
f0103c12:	e8 32 c4 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f0103c17:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103c1c:	eb b5                	jmp    f0103bd3 <env_alloc+0x42f>
	return 0;
f0103c1e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103c23:	eb ae                	jmp    f0103bd3 <env_alloc+0x42f>

f0103c25 <env_create>:
{
f0103c25:	55                   	push   %ebp
f0103c26:	89 e5                	mov    %esp,%ebp
f0103c28:	57                   	push   %edi
f0103c29:	56                   	push   %esi
f0103c2a:	53                   	push   %ebx
f0103c2b:	83 ec 54             	sub    $0x54,%esp
f0103c2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0103c31:	68 84 99 10 f0       	push   $0xf0109984
f0103c36:	68 20 80 10 f0       	push   $0xf0108020
f0103c3b:	e8 25 06 00 00       	call   f0104265 <cprintf>
	int ret = env_alloc(&e, 0);
f0103c40:	83 c4 08             	add    $0x8,%esp
f0103c43:	6a 00                	push   $0x0
f0103c45:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103c48:	50                   	push   %eax
f0103c49:	e8 56 fb ff ff       	call   f01037a4 <env_alloc>
f0103c4e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if(ret)
f0103c51:	83 c4 10             	add    $0x10,%esp
f0103c54:	85 c0                	test   %eax,%eax
f0103c56:	75 40                	jne    f0103c98 <env_create+0x73>
	e->env_parent_id = 0;
f0103c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103c5b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103c5e:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
	e->env_type = type;
f0103c65:	89 58 50             	mov    %ebx,0x50(%eax)
	if(type == ENV_TYPE_FS){
f0103c68:	83 fb 01             	cmp    $0x1,%ebx
f0103c6b:	74 42                	je     f0103caf <env_create+0x8a>
	if (elf->e_magic != ELF_MAGIC)
f0103c6d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c70:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f0103c76:	75 40                	jne    f0103cb8 <env_create+0x93>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103c78:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c7b:	89 c7                	mov    %eax,%edi
f0103c7d:	03 78 1c             	add    0x1c(%eax),%edi
	eph = ph + elf->e_phnum;
f0103c80:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103c84:	c1 e0 05             	shl    $0x5,%eax
f0103c87:	01 f8                	add    %edi,%eax
f0103c89:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	uint32_t elf_load_sz = 0;
f0103c8c:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
f0103c93:	e9 69 01 00 00       	jmp    f0103e01 <env_create+0x1dc>
		panic("env_alloc failed\n");
f0103c98:	83 ec 04             	sub    $0x4,%esp
f0103c9b:	68 65 97 10 f0       	push   $0xf0109765
f0103ca0:	68 08 02 00 00       	push   $0x208
f0103ca5:	68 56 96 10 f0       	push   $0xf0109656
f0103caa:	e8 9a c3 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103caf:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f0103cb6:	eb b5                	jmp    f0103c6d <env_create+0x48>
		panic("is this a valid ELF");
f0103cb8:	83 ec 04             	sub    $0x4,%esp
f0103cbb:	68 77 97 10 f0       	push   $0xf0109777
f0103cc0:	68 de 01 00 00       	push   $0x1de
f0103cc5:	68 56 96 10 f0       	push   $0xf0109656
f0103cca:	e8 7a c3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103ccf:	50                   	push   %eax
f0103cd0:	68 0c 81 10 f0       	push   $0xf010810c
f0103cd5:	6a 58                	push   $0x58
f0103cd7:	68 91 92 10 f0       	push   $0xf0109291
f0103cdc:	e8 68 c3 ff ff       	call   f0100049 <_panic>
		addr += size;
f0103ce1:	01 75 c8             	add    %esi,-0x38(%ebp)
		len -= size;
f0103ce4:	29 f3                	sub    %esi,%ebx
		off = 0;
f0103ce6:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0103ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	while(len > 0){
f0103cec:	85 db                	test   %ebx,%ebx
f0103cee:	74 5c                	je     f0103d4c <env_create+0x127>
		int size = len > PGSIZE?PGSIZE - off:len;
f0103cf0:	be 00 10 00 00       	mov    $0x1000,%esi
f0103cf5:	2b 75 d0             	sub    -0x30(%ebp),%esi
f0103cf8:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
f0103cfe:	0f 46 f3             	cmovbe %ebx,%esi
		struct PageInfo* page = page_lookup(pgdir, (void *)addr, NULL);
f0103d01:	83 ec 04             	sub    $0x4,%esp
f0103d04:	6a 00                	push   $0x0
f0103d06:	ff 75 c8             	pushl  -0x38(%ebp)
f0103d09:	ff 75 c4             	pushl  -0x3c(%ebp)
f0103d0c:	e8 9d d8 ff ff       	call   f01015ae <page_lookup>
		if(page)
f0103d11:	83 c4 10             	add    $0x10,%esp
f0103d14:	85 c0                	test   %eax,%eax
f0103d16:	74 c9                	je     f0103ce1 <env_create+0xbc>
	return (pp - pages) << PGSHIFT;
f0103d18:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103d1e:	c1 f8 03             	sar    $0x3,%eax
f0103d21:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103d24:	89 c2                	mov    %eax,%edx
f0103d26:	c1 ea 0c             	shr    $0xc,%edx
f0103d29:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103d2f:	73 9e                	jae    f0103ccf <env_create+0xaa>
			memset(page2kva(page)+off, c, size);
f0103d31:	83 ec 04             	sub    $0x4,%esp
f0103d34:	56                   	push   %esi
f0103d35:	6a 00                	push   $0x0
f0103d37:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0103d3a:	8d 84 02 00 00 00 f0 	lea    -0x10000000(%edx,%eax,1),%eax
f0103d41:	50                   	push   %eax
f0103d42:	e8 80 2b 00 00       	call   f01068c7 <memset>
f0103d47:	83 c4 10             	add    $0x10,%esp
f0103d4a:	eb 95                	jmp    f0103ce1 <env_create+0xbc>
			user_memmove(e->env_pgdir,(void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f0103d4c:	8b 77 10             	mov    0x10(%edi),%esi
f0103d4f:	8b 47 08             	mov    0x8(%edi),%eax
f0103d52:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103d55:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103d58:	8b 51 60             	mov    0x60(%ecx),%edx
f0103d5b:	89 55 bc             	mov    %edx,-0x44(%ebp)
f0103d5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103d61:	03 4f 04             	add    0x4(%edi),%ecx
f0103d64:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	int off = addr - ROUNDDOWN(addr, PGSIZE);
f0103d67:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103d6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		off = 0;
f0103d6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103d72:	89 45 b8             	mov    %eax,-0x48(%ebp)
f0103d75:	eb 20                	jmp    f0103d97 <env_create+0x172>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103d77:	50                   	push   %eax
f0103d78:	68 0c 81 10 f0       	push   $0xf010810c
f0103d7d:	6a 58                	push   $0x58
f0103d7f:	68 91 92 10 f0       	push   $0xf0109291
f0103d84:	e8 c0 c2 ff ff       	call   f0100049 <_panic>
		addr += size;
f0103d89:	01 5d c8             	add    %ebx,-0x38(%ebp)
		cur_src += size;
f0103d8c:	01 5d c4             	add    %ebx,-0x3c(%ebp)
		len -= size;
f0103d8f:	29 de                	sub    %ebx,%esi
		off = 0;
f0103d91:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0103d94:	89 45 d0             	mov    %eax,-0x30(%ebp)
	while(len > 0){
f0103d97:	85 f6                	test   %esi,%esi
f0103d99:	74 5d                	je     f0103df8 <env_create+0x1d3>
		int size = len > PGSIZE?PGSIZE - off:len;
f0103d9b:	bb 00 10 00 00       	mov    $0x1000,%ebx
f0103da0:	2b 5d d0             	sub    -0x30(%ebp),%ebx
f0103da3:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
f0103da9:	0f 46 de             	cmovbe %esi,%ebx
		struct PageInfo* page = page_lookup(pgdir, (void *)addr, NULL);
f0103dac:	83 ec 04             	sub    $0x4,%esp
f0103daf:	6a 00                	push   $0x0
f0103db1:	ff 75 c8             	pushl  -0x38(%ebp)
f0103db4:	ff 75 bc             	pushl  -0x44(%ebp)
f0103db7:	e8 f2 d7 ff ff       	call   f01015ae <page_lookup>
		if(page)
f0103dbc:	83 c4 10             	add    $0x10,%esp
f0103dbf:	85 c0                	test   %eax,%eax
f0103dc1:	74 c6                	je     f0103d89 <env_create+0x164>
	return (pp - pages) << PGSHIFT;
f0103dc3:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0103dc9:	c1 f8 03             	sar    $0x3,%eax
f0103dcc:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103dcf:	89 c2                	mov    %eax,%edx
f0103dd1:	c1 ea 0c             	shr    $0xc,%edx
f0103dd4:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0103dda:	73 9b                	jae    f0103d77 <env_create+0x152>
			memmove(page2kva(page)+off, (void *)cur_src, size);
f0103ddc:	83 ec 04             	sub    $0x4,%esp
f0103ddf:	53                   	push   %ebx
f0103de0:	ff 75 c4             	pushl  -0x3c(%ebp)
f0103de3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0103de6:	8d 84 01 00 00 00 f0 	lea    -0x10000000(%ecx,%eax,1),%eax
f0103ded:	50                   	push   %eax
f0103dee:	e8 1c 2b 00 00       	call   f010690f <memmove>
f0103df3:	83 c4 10             	add    $0x10,%esp
f0103df6:	eb 91                	jmp    f0103d89 <env_create+0x164>
			elf_load_sz += ph->p_memsz;
f0103df8:	8b 57 14             	mov    0x14(%edi),%edx
f0103dfb:	01 55 c0             	add    %edx,-0x40(%ebp)
	for (; ph < eph; ph++){
f0103dfe:	83 c7 20             	add    $0x20,%edi
f0103e01:	39 7d b4             	cmp    %edi,-0x4c(%ebp)
f0103e04:	76 37                	jbe    f0103e3d <env_create+0x218>
		if(ph->p_type == ELF_PROG_LOAD){
f0103e06:	83 3f 01             	cmpl   $0x1,(%edi)
f0103e09:	75 f3                	jne    f0103dfe <env_create+0x1d9>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f0103e0b:	8b 4f 14             	mov    0x14(%edi),%ecx
f0103e0e:	8b 57 08             	mov    0x8(%edi),%edx
f0103e11:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0103e14:	89 f0                	mov    %esi,%eax
f0103e16:	e8 bb f7 ff ff       	call   f01035d6 <region_alloc>
			user_memset(e->env_pgdir, (void *)ph->p_va, 0, ph->p_memsz);
f0103e1b:	8b 5f 14             	mov    0x14(%edi),%ebx
f0103e1e:	8b 47 08             	mov    0x8(%edi),%eax
f0103e21:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103e24:	8b 4e 60             	mov    0x60(%esi),%ecx
f0103e27:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	int off = addr - ROUNDDOWN(addr, PGSIZE);
f0103e2a:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103e2f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		off = 0;
f0103e32:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103e35:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0103e38:	e9 af fe ff ff       	jmp    f0103cec <env_create+0xc7>
	e->env_tf.tf_eip = elf->e_entry;
f0103e3d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103e40:	8b 40 18             	mov    0x18(%eax),%eax
f0103e43:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0103e46:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f0103e49:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103e4c:	05 00 00 80 00       	add    $0x800000,%eax
f0103e51:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f0103e57:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103e5c:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103e61:	89 f0                	mov    %esi,%eax
f0103e63:	e8 6e f7 ff ff       	call   f01035d6 <region_alloc>
}
f0103e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103e6b:	5b                   	pop    %ebx
f0103e6c:	5e                   	pop    %esi
f0103e6d:	5f                   	pop    %edi
f0103e6e:	5d                   	pop    %ebp
f0103e6f:	c3                   	ret    

f0103e70 <env_free>:
{
f0103e70:	55                   	push   %ebp
f0103e71:	89 e5                	mov    %esp,%ebp
f0103e73:	57                   	push   %edi
f0103e74:	56                   	push   %esi
f0103e75:	53                   	push   %ebx
f0103e76:	83 ec 1c             	sub    $0x1c,%esp
f0103e79:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (e == curenv)
f0103e7c:	e8 96 d6 01 00       	call   f0121517 <cpunum>
f0103e81:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e84:	39 b8 28 b0 16 f0    	cmp    %edi,-0xfe94fd8(%eax)
f0103e8a:	74 48                	je     f0103ed4 <env_free+0x64>
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103e8c:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103e8f:	e8 83 d6 01 00       	call   f0121517 <cpunum>
f0103e94:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e97:	ba 00 00 00 00       	mov    $0x0,%edx
f0103e9c:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0103ea3:	74 11                	je     f0103eb6 <env_free+0x46>
f0103ea5:	e8 6d d6 01 00       	call   f0121517 <cpunum>
f0103eaa:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ead:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103eb3:	8b 50 48             	mov    0x48(%eax),%edx
f0103eb6:	83 ec 04             	sub    $0x4,%esp
f0103eb9:	53                   	push   %ebx
f0103eba:	52                   	push   %edx
f0103ebb:	68 8b 97 10 f0       	push   $0xf010978b
f0103ec0:	e8 a0 03 00 00       	call   f0104265 <cprintf>
f0103ec5:	83 c4 10             	add    $0x10,%esp
f0103ec8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103ecf:	e9 a9 00 00 00       	jmp    f0103f7d <env_free+0x10d>
		lcr3(PADDR(kern_pgdir));
f0103ed4:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103ed9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ede:	76 0a                	jbe    f0103eea <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f0103ee0:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103ee5:	0f 22 d8             	mov    %eax,%cr3
f0103ee8:	eb a2                	jmp    f0103e8c <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103eea:	50                   	push   %eax
f0103eeb:	68 30 81 10 f0       	push   $0xf0108130
f0103ef0:	68 1f 02 00 00       	push   $0x21f
f0103ef5:	68 56 96 10 f0       	push   $0xf0109656
f0103efa:	e8 4a c1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103eff:	56                   	push   %esi
f0103f00:	68 0c 81 10 f0       	push   $0xf010810c
f0103f05:	68 2e 02 00 00       	push   $0x22e
f0103f0a:	68 56 96 10 f0       	push   $0xf0109656
f0103f0f:	e8 35 c1 ff ff       	call   f0100049 <_panic>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103f14:	83 ec 08             	sub    $0x8,%esp
f0103f17:	89 d8                	mov    %ebx,%eax
f0103f19:	c1 e0 0c             	shl    $0xc,%eax
f0103f1c:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103f1f:	50                   	push   %eax
f0103f20:	ff 77 60             	pushl  0x60(%edi)
f0103f23:	e8 20 d7 ff ff       	call   f0101648 <page_remove>
f0103f28:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103f2b:	83 c3 01             	add    $0x1,%ebx
f0103f2e:	83 c6 04             	add    $0x4,%esi
f0103f31:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103f37:	74 07                	je     f0103f40 <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f0103f39:	f6 06 01             	testb  $0x1,(%esi)
f0103f3c:	74 ed                	je     f0103f2b <env_free+0xbb>
f0103f3e:	eb d4                	jmp    f0103f14 <env_free+0xa4>
		e->env_pgdir[pdeno] = 0;
f0103f40:	8b 47 60             	mov    0x60(%edi),%eax
f0103f43:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103f46:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103f4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f50:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0103f56:	73 69                	jae    f0103fc1 <env_free+0x151>
		page_decref(pa2page(pa));
f0103f58:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103f5b:	a1 90 ed 5d f0       	mov    0xf05ded90,%eax
f0103f60:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103f63:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103f66:	50                   	push   %eax
f0103f67:	e8 93 d4 ff ff       	call   f01013ff <page_decref>
f0103f6c:	83 c4 10             	add    $0x10,%esp
f0103f6f:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103f73:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103f76:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103f7b:	74 58                	je     f0103fd5 <env_free+0x165>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103f7d:	8b 47 60             	mov    0x60(%edi),%eax
f0103f80:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103f83:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103f86:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103f8c:	74 e1                	je     f0103f6f <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103f8e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103f94:	89 f0                	mov    %esi,%eax
f0103f96:	c1 e8 0c             	shr    $0xc,%eax
f0103f99:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103f9c:	39 05 88 ed 5d f0    	cmp    %eax,0xf05ded88
f0103fa2:	0f 86 57 ff ff ff    	jbe    f0103eff <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0103fa8:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103fb1:	c1 e0 14             	shl    $0x14,%eax
f0103fb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103fb7:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103fbc:	e9 78 ff ff ff       	jmp    f0103f39 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f0103fc1:	83 ec 04             	sub    $0x4,%esp
f0103fc4:	68 d0 89 10 f0       	push   $0xf01089d0
f0103fc9:	6a 51                	push   $0x51
f0103fcb:	68 91 92 10 f0       	push   $0xf0109291
f0103fd0:	e8 74 c0 ff ff       	call   f0100049 <_panic>
	pa = PADDR(e->env_pgdir);
f0103fd5:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103fd8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103fdd:	76 55                	jbe    f0104034 <env_free+0x1c4>
	e->env_pgdir = 0;
f0103fdf:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103fe6:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103feb:	c1 e8 0c             	shr    $0xc,%eax
f0103fee:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0103ff4:	73 53                	jae    f0104049 <env_free+0x1d9>
	page_decref(pa2page(pa));
f0103ff6:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103ff9:	8b 15 90 ed 5d f0    	mov    0xf05ded90,%edx
f0103fff:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0104002:	50                   	push   %eax
f0104003:	e8 f7 d3 ff ff       	call   f01013ff <page_decref>
	cprintf("in env_free we set the ENV_FREE\n");
f0104008:	c7 04 24 cc 98 10 f0 	movl   $0xf01098cc,(%esp)
f010400f:	e8 51 02 00 00       	call   f0104265 <cprintf>
	e->env_status = ENV_FREE;
f0104014:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f010401b:	a1 48 d9 5d f0       	mov    0xf05dd948,%eax
f0104020:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0104023:	89 3d 48 d9 5d f0    	mov    %edi,0xf05dd948
}
f0104029:	83 c4 10             	add    $0x10,%esp
f010402c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010402f:	5b                   	pop    %ebx
f0104030:	5e                   	pop    %esi
f0104031:	5f                   	pop    %edi
f0104032:	5d                   	pop    %ebp
f0104033:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104034:	50                   	push   %eax
f0104035:	68 30 81 10 f0       	push   $0xf0108130
f010403a:	68 3c 02 00 00       	push   $0x23c
f010403f:	68 56 96 10 f0       	push   $0xf0109656
f0104044:	e8 00 c0 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0104049:	83 ec 04             	sub    $0x4,%esp
f010404c:	68 d0 89 10 f0       	push   $0xf01089d0
f0104051:	6a 51                	push   $0x51
f0104053:	68 91 92 10 f0       	push   $0xf0109291
f0104058:	e8 ec bf ff ff       	call   f0100049 <_panic>

f010405d <env_destroy>:
{
f010405d:	55                   	push   %ebp
f010405e:	89 e5                	mov    %esp,%ebp
f0104060:	53                   	push   %ebx
f0104061:	83 ec 04             	sub    $0x4,%esp
f0104064:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0104067:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010406b:	74 21                	je     f010408e <env_destroy+0x31>
	env_free(e);
f010406d:	83 ec 0c             	sub    $0xc,%esp
f0104070:	53                   	push   %ebx
f0104071:	e8 fa fd ff ff       	call   f0103e70 <env_free>
	if (curenv == e) {
f0104076:	e8 9c d4 01 00       	call   f0121517 <cpunum>
f010407b:	6b c0 74             	imul   $0x74,%eax,%eax
f010407e:	83 c4 10             	add    $0x10,%esp
f0104081:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f0104087:	74 1e                	je     f01040a7 <env_destroy+0x4a>
}
f0104089:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010408c:	c9                   	leave  
f010408d:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010408e:	e8 84 d4 01 00       	call   f0121517 <cpunum>
f0104093:	6b c0 74             	imul   $0x74,%eax,%eax
f0104096:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f010409c:	74 cf                	je     f010406d <env_destroy+0x10>
		e->env_status = ENV_DYING;
f010409e:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f01040a5:	eb e2                	jmp    f0104089 <env_destroy+0x2c>
		curenv = NULL;
f01040a7:	e8 6b d4 01 00       	call   f0121517 <cpunum>
f01040ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01040af:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f01040b6:	00 00 00 
		sched_yield();
f01040b9:	e8 5f 10 00 00       	call   f010511d <sched_yield>

f01040be <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01040be:	55                   	push   %ebp
f01040bf:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01040c1:	8b 45 08             	mov    0x8(%ebp),%eax
f01040c4:	ba 70 00 00 00       	mov    $0x70,%edx
f01040c9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01040ca:	ba 71 00 00 00       	mov    $0x71,%edx
f01040cf:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01040d0:	0f b6 c0             	movzbl %al,%eax
}
f01040d3:	5d                   	pop    %ebp
f01040d4:	c3                   	ret    

f01040d5 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01040d5:	55                   	push   %ebp
f01040d6:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01040d8:	8b 45 08             	mov    0x8(%ebp),%eax
f01040db:	ba 70 00 00 00       	mov    $0x70,%edx
f01040e0:	ee                   	out    %al,(%dx)
f01040e1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01040e4:	ba 71 00 00 00       	mov    $0x71,%edx
f01040e9:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01040ea:	5d                   	pop    %ebp
f01040eb:	c3                   	ret    

f01040ec <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01040ec:	55                   	push   %ebp
f01040ed:	89 e5                	mov    %esp,%ebp
f01040ef:	56                   	push   %esi
f01040f0:	53                   	push   %ebx
f01040f1:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01040f4:	66 a3 0e d3 16 f0    	mov    %ax,0xf016d30e
	if (!didinit)
f01040fa:	80 3d 4c d9 5d f0 00 	cmpb   $0x0,0xf05dd94c
f0104101:	75 07                	jne    f010410a <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0104103:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104106:	5b                   	pop    %ebx
f0104107:	5e                   	pop    %esi
f0104108:	5d                   	pop    %ebp
f0104109:	c3                   	ret    
f010410a:	89 c6                	mov    %eax,%esi
f010410c:	ba 21 00 00 00       	mov    $0x21,%edx
f0104111:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0104112:	66 c1 e8 08          	shr    $0x8,%ax
f0104116:	ba a1 00 00 00       	mov    $0xa1,%edx
f010411b:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f010411c:	83 ec 0c             	sub    $0xc,%esp
f010411f:	68 aa 99 10 f0       	push   $0xf01099aa
f0104124:	e8 3c 01 00 00       	call   f0104265 <cprintf>
f0104129:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f010412c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0104131:	0f b7 f6             	movzwl %si,%esi
f0104134:	f7 d6                	not    %esi
f0104136:	eb 19                	jmp    f0104151 <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f0104138:	83 ec 08             	sub    $0x8,%esp
f010413b:	53                   	push   %ebx
f010413c:	68 73 a1 10 f0       	push   $0xf010a173
f0104141:	e8 1f 01 00 00       	call   f0104265 <cprintf>
f0104146:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0104149:	83 c3 01             	add    $0x1,%ebx
f010414c:	83 fb 10             	cmp    $0x10,%ebx
f010414f:	74 07                	je     f0104158 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0104151:	0f a3 de             	bt     %ebx,%esi
f0104154:	73 f3                	jae    f0104149 <irq_setmask_8259A+0x5d>
f0104156:	eb e0                	jmp    f0104138 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0104158:	83 ec 0c             	sub    $0xc,%esp
f010415b:	68 9b 95 10 f0       	push   $0xf010959b
f0104160:	e8 00 01 00 00       	call   f0104265 <cprintf>
f0104165:	83 c4 10             	add    $0x10,%esp
f0104168:	eb 99                	jmp    f0104103 <irq_setmask_8259A+0x17>

f010416a <pic_init>:
{
f010416a:	55                   	push   %ebp
f010416b:	89 e5                	mov    %esp,%ebp
f010416d:	57                   	push   %edi
f010416e:	56                   	push   %esi
f010416f:	53                   	push   %ebx
f0104170:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0104173:	c6 05 4c d9 5d f0 01 	movb   $0x1,0xf05dd94c
f010417a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010417f:	bb 21 00 00 00       	mov    $0x21,%ebx
f0104184:	89 da                	mov    %ebx,%edx
f0104186:	ee                   	out    %al,(%dx)
f0104187:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010418c:	89 ca                	mov    %ecx,%edx
f010418e:	ee                   	out    %al,(%dx)
f010418f:	bf 11 00 00 00       	mov    $0x11,%edi
f0104194:	be 20 00 00 00       	mov    $0x20,%esi
f0104199:	89 f8                	mov    %edi,%eax
f010419b:	89 f2                	mov    %esi,%edx
f010419d:	ee                   	out    %al,(%dx)
f010419e:	b8 20 00 00 00       	mov    $0x20,%eax
f01041a3:	89 da                	mov    %ebx,%edx
f01041a5:	ee                   	out    %al,(%dx)
f01041a6:	b8 04 00 00 00       	mov    $0x4,%eax
f01041ab:	ee                   	out    %al,(%dx)
f01041ac:	b8 03 00 00 00       	mov    $0x3,%eax
f01041b1:	ee                   	out    %al,(%dx)
f01041b2:	bb a0 00 00 00       	mov    $0xa0,%ebx
f01041b7:	89 f8                	mov    %edi,%eax
f01041b9:	89 da                	mov    %ebx,%edx
f01041bb:	ee                   	out    %al,(%dx)
f01041bc:	b8 28 00 00 00       	mov    $0x28,%eax
f01041c1:	89 ca                	mov    %ecx,%edx
f01041c3:	ee                   	out    %al,(%dx)
f01041c4:	b8 02 00 00 00       	mov    $0x2,%eax
f01041c9:	ee                   	out    %al,(%dx)
f01041ca:	b8 01 00 00 00       	mov    $0x1,%eax
f01041cf:	ee                   	out    %al,(%dx)
f01041d0:	bf 68 00 00 00       	mov    $0x68,%edi
f01041d5:	89 f8                	mov    %edi,%eax
f01041d7:	89 f2                	mov    %esi,%edx
f01041d9:	ee                   	out    %al,(%dx)
f01041da:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01041df:	89 c8                	mov    %ecx,%eax
f01041e1:	ee                   	out    %al,(%dx)
f01041e2:	89 f8                	mov    %edi,%eax
f01041e4:	89 da                	mov    %ebx,%edx
f01041e6:	ee                   	out    %al,(%dx)
f01041e7:	89 c8                	mov    %ecx,%eax
f01041e9:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01041ea:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f01041f1:	66 83 f8 ff          	cmp    $0xffff,%ax
f01041f5:	75 08                	jne    f01041ff <pic_init+0x95>
}
f01041f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01041fa:	5b                   	pop    %ebx
f01041fb:	5e                   	pop    %esi
f01041fc:	5f                   	pop    %edi
f01041fd:	5d                   	pop    %ebp
f01041fe:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f01041ff:	83 ec 0c             	sub    $0xc,%esp
f0104202:	0f b7 c0             	movzwl %ax,%eax
f0104205:	50                   	push   %eax
f0104206:	e8 e1 fe ff ff       	call   f01040ec <irq_setmask_8259A>
f010420b:	83 c4 10             	add    $0x10,%esp
}
f010420e:	eb e7                	jmp    f01041f7 <pic_init+0x8d>

f0104210 <irq_eoi>:
f0104210:	b8 20 00 00 00       	mov    $0x20,%eax
f0104215:	ba 20 00 00 00       	mov    $0x20,%edx
f010421a:	ee                   	out    %al,(%dx)
f010421b:	ba a0 00 00 00       	mov    $0xa0,%edx
f0104220:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0104221:	c3                   	ret    

f0104222 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0104222:	55                   	push   %ebp
f0104223:	89 e5                	mov    %esp,%ebp
f0104225:	53                   	push   %ebx
f0104226:	83 ec 10             	sub    $0x10,%esp
f0104229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f010422c:	ff 75 08             	pushl  0x8(%ebp)
f010422f:	e8 13 c6 ff ff       	call   f0100847 <cputchar>
	(*cnt)++;
f0104234:	83 03 01             	addl   $0x1,(%ebx)
}
f0104237:	83 c4 10             	add    $0x10,%esp
f010423a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010423d:	c9                   	leave  
f010423e:	c3                   	ret    

f010423f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010423f:	55                   	push   %ebp
f0104240:	89 e5                	mov    %esp,%ebp
f0104242:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0104245:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f010424c:	ff 75 0c             	pushl  0xc(%ebp)
f010424f:	ff 75 08             	pushl  0x8(%ebp)
f0104252:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104255:	50                   	push   %eax
f0104256:	68 22 42 10 f0       	push   $0xf0104222
f010425b:	e8 01 1e 00 00       	call   f0106061 <vprintfmt>
	return cnt;
}
f0104260:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104263:	c9                   	leave  
f0104264:	c3                   	ret    

f0104265 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0104265:	55                   	push   %ebp
f0104266:	89 e5                	mov    %esp,%ebp
f0104268:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f010426b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010426e:	50                   	push   %eax
f010426f:	ff 75 08             	pushl  0x8(%ebp)
f0104272:	e8 c8 ff ff ff       	call   f010423f <vcprintf>
	va_end(ap);
	return cnt;
}
f0104277:	c9                   	leave  
f0104278:	c3                   	ret    

f0104279 <trap_init_percpu>:

// Initialize and load the per-CPU TSS and IDT
//mapped text lab7
 void
trap_init_percpu(void)
{
f0104279:	55                   	push   %ebp
f010427a:	89 e5                	mov    %esp,%ebp
f010427c:	57                   	push   %edi
f010427d:	56                   	push   %esi
f010427e:	53                   	push   %ebx
f010427f:	83 ec 24             	sub    $0x24,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	cprintf("in %s\n", __FUNCTION__);
f0104282:	68 a0 9f 10 f0       	push   $0xf0109fa0
f0104287:	68 20 80 10 f0       	push   $0xf0108020
f010428c:	e8 d4 ff ff ff       	call   f0104265 <cprintf>
	int i = cpunum();
f0104291:	e8 81 d2 01 00       	call   f0121517 <cpunum>
f0104296:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0104298:	e8 7a d2 01 00       	call   f0121517 <cpunum>
f010429d:	6b c0 74             	imul   $0x74,%eax,%eax
f01042a0:	89 d9                	mov    %ebx,%ecx
f01042a2:	c1 e1 10             	shl    $0x10,%ecx
f01042a5:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01042aa:	29 ca                	sub    %ecx,%edx
f01042ac:	89 90 30 b0 16 f0    	mov    %edx,-0xfe94fd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f01042b2:	e8 60 d2 01 00       	call   f0121517 <cpunum>
f01042b7:	6b c0 74             	imul   $0x74,%eax,%eax
f01042ba:	66 c7 80 34 b0 16 f0 	movw   $0x10,-0xfe94fcc(%eax)
f01042c1:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f01042c3:	e8 4f d2 01 00       	call   f0121517 <cpunum>
f01042c8:	6b c0 74             	imul   $0x74,%eax,%eax
f01042cb:	66 c7 80 92 b0 16 f0 	movw   $0x68,-0xfe94f6e(%eax)
f01042d2:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f01042d4:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f01042db:	89 fb                	mov    %edi,%ebx
f01042dd:	c1 fb 03             	sar    $0x3,%ebx
f01042e0:	e8 32 d2 01 00       	call   f0121517 <cpunum>
f01042e5:	89 c6                	mov    %eax,%esi
f01042e7:	e8 2b d2 01 00       	call   f0121517 <cpunum>
f01042ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01042ef:	e8 23 d2 01 00       	call   f0121517 <cpunum>
f01042f4:	66 c7 04 dd 00 a0 12 	movw   $0x67,-0xfed6000(,%ebx,8)
f01042fb:	f0 67 00 
f01042fe:	6b f6 74             	imul   $0x74,%esi,%esi
f0104301:	81 c6 2c b0 16 f0    	add    $0xf016b02c,%esi
f0104307:	66 89 34 dd 02 a0 12 	mov    %si,-0xfed5ffe(,%ebx,8)
f010430e:	f0 
f010430f:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0104313:	81 c2 2c b0 16 f0    	add    $0xf016b02c,%edx
f0104319:	c1 ea 10             	shr    $0x10,%edx
f010431c:	88 14 dd 04 a0 12 f0 	mov    %dl,-0xfed5ffc(,%ebx,8)
f0104323:	c6 04 dd 06 a0 12 f0 	movb   $0x40,-0xfed5ffa(,%ebx,8)
f010432a:	40 
f010432b:	6b c0 74             	imul   $0x74,%eax,%eax
f010432e:	05 2c b0 16 f0       	add    $0xf016b02c,%eax
f0104333:	c1 e8 18             	shr    $0x18,%eax
f0104336:	88 04 dd 07 a0 12 f0 	mov    %al,-0xfed5ff9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f010433d:	c6 04 dd 05 a0 12 f0 	movb   $0x89,-0xfed5ffb(,%ebx,8)
f0104344:	89 
	asm volatile("ltr %0" : : "r" (sel));
f0104345:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f0104348:	b8 10 d3 16 f0       	mov    $0xf016d310,%eax
f010434d:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f0104350:	83 c4 10             	add    $0x10,%esp
f0104353:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104356:	5b                   	pop    %ebx
f0104357:	5e                   	pop    %esi
f0104358:	5f                   	pop    %edi
f0104359:	5d                   	pop    %ebp
f010435a:	c3                   	ret    

f010435b <trap_init>:
{
f010435b:	55                   	push   %ebp
f010435c:	89 e5                	mov    %esp,%ebp
f010435e:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f0104361:	b8 ea 13 12 f0       	mov    $0xf01213ea,%eax
f0104366:	66 a3 80 a0 12 f0    	mov    %ax,0xf012a080
f010436c:	66 c7 05 82 a0 12 f0 	movw   $0x8,0xf012a082
f0104373:	08 00 
f0104375:	c6 05 84 a0 12 f0 00 	movb   $0x0,0xf012a084
f010437c:	c6 05 85 a0 12 f0 8e 	movb   $0x8e,0xf012a085
f0104383:	c1 e8 10             	shr    $0x10,%eax
f0104386:	66 a3 86 a0 12 f0    	mov    %ax,0xf012a086
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f010438c:	b8 f4 13 12 f0       	mov    $0xf01213f4,%eax
f0104391:	66 a3 88 a0 12 f0    	mov    %ax,0xf012a088
f0104397:	66 c7 05 8a a0 12 f0 	movw   $0x8,0xf012a08a
f010439e:	08 00 
f01043a0:	c6 05 8c a0 12 f0 00 	movb   $0x0,0xf012a08c
f01043a7:	c6 05 8d a0 12 f0 8e 	movb   $0x8e,0xf012a08d
f01043ae:	c1 e8 10             	shr    $0x10,%eax
f01043b1:	66 a3 8e a0 12 f0    	mov    %ax,0xf012a08e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f01043b7:	b8 fe 13 12 f0       	mov    $0xf01213fe,%eax
f01043bc:	66 a3 90 a0 12 f0    	mov    %ax,0xf012a090
f01043c2:	66 c7 05 92 a0 12 f0 	movw   $0x8,0xf012a092
f01043c9:	08 00 
f01043cb:	c6 05 94 a0 12 f0 00 	movb   $0x0,0xf012a094
f01043d2:	c6 05 95 a0 12 f0 8e 	movb   $0x8e,0xf012a095
f01043d9:	c1 e8 10             	shr    $0x10,%eax
f01043dc:	66 a3 96 a0 12 f0    	mov    %ax,0xf012a096
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f01043e2:	b8 08 14 12 f0       	mov    $0xf0121408,%eax
f01043e7:	66 a3 98 a0 12 f0    	mov    %ax,0xf012a098
f01043ed:	66 c7 05 9a a0 12 f0 	movw   $0x8,0xf012a09a
f01043f4:	08 00 
f01043f6:	c6 05 9c a0 12 f0 00 	movb   $0x0,0xf012a09c
f01043fd:	c6 05 9d a0 12 f0 ee 	movb   $0xee,0xf012a09d
f0104404:	c1 e8 10             	shr    $0x10,%eax
f0104407:	66 a3 9e a0 12 f0    	mov    %ax,0xf012a09e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f010440d:	b8 12 14 12 f0       	mov    $0xf0121412,%eax
f0104412:	66 a3 a0 a0 12 f0    	mov    %ax,0xf012a0a0
f0104418:	66 c7 05 a2 a0 12 f0 	movw   $0x8,0xf012a0a2
f010441f:	08 00 
f0104421:	c6 05 a4 a0 12 f0 00 	movb   $0x0,0xf012a0a4
f0104428:	c6 05 a5 a0 12 f0 ee 	movb   $0xee,0xf012a0a5
f010442f:	c1 e8 10             	shr    $0x10,%eax
f0104432:	66 a3 a6 a0 12 f0    	mov    %ax,0xf012a0a6
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f0104438:	b8 1c 14 12 f0       	mov    $0xf012141c,%eax
f010443d:	66 a3 a8 a0 12 f0    	mov    %ax,0xf012a0a8
f0104443:	66 c7 05 aa a0 12 f0 	movw   $0x8,0xf012a0aa
f010444a:	08 00 
f010444c:	c6 05 ac a0 12 f0 00 	movb   $0x0,0xf012a0ac
f0104453:	c6 05 ad a0 12 f0 ee 	movb   $0xee,0xf012a0ad
f010445a:	c1 e8 10             	shr    $0x10,%eax
f010445d:	66 a3 ae a0 12 f0    	mov    %ax,0xf012a0ae
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f0104463:	b8 26 14 12 f0       	mov    $0xf0121426,%eax
f0104468:	66 a3 b0 a0 12 f0    	mov    %ax,0xf012a0b0
f010446e:	66 c7 05 b2 a0 12 f0 	movw   $0x8,0xf012a0b2
f0104475:	08 00 
f0104477:	c6 05 b4 a0 12 f0 00 	movb   $0x0,0xf012a0b4
f010447e:	c6 05 b5 a0 12 f0 8e 	movb   $0x8e,0xf012a0b5
f0104485:	c1 e8 10             	shr    $0x10,%eax
f0104488:	66 a3 b6 a0 12 f0    	mov    %ax,0xf012a0b6
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f010448e:	b8 30 14 12 f0       	mov    $0xf0121430,%eax
f0104493:	66 a3 b8 a0 12 f0    	mov    %ax,0xf012a0b8
f0104499:	66 c7 05 ba a0 12 f0 	movw   $0x8,0xf012a0ba
f01044a0:	08 00 
f01044a2:	c6 05 bc a0 12 f0 00 	movb   $0x0,0xf012a0bc
f01044a9:	c6 05 bd a0 12 f0 8e 	movb   $0x8e,0xf012a0bd
f01044b0:	c1 e8 10             	shr    $0x10,%eax
f01044b3:	66 a3 be a0 12 f0    	mov    %ax,0xf012a0be
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f01044b9:	b8 3a 14 12 f0       	mov    $0xf012143a,%eax
f01044be:	66 a3 c0 a0 12 f0    	mov    %ax,0xf012a0c0
f01044c4:	66 c7 05 c2 a0 12 f0 	movw   $0x8,0xf012a0c2
f01044cb:	08 00 
f01044cd:	c6 05 c4 a0 12 f0 00 	movb   $0x0,0xf012a0c4
f01044d4:	c6 05 c5 a0 12 f0 8e 	movb   $0x8e,0xf012a0c5
f01044db:	c1 e8 10             	shr    $0x10,%eax
f01044de:	66 a3 c6 a0 12 f0    	mov    %ax,0xf012a0c6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f01044e4:	b8 42 14 12 f0       	mov    $0xf0121442,%eax
f01044e9:	66 a3 d0 a0 12 f0    	mov    %ax,0xf012a0d0
f01044ef:	66 c7 05 d2 a0 12 f0 	movw   $0x8,0xf012a0d2
f01044f6:	08 00 
f01044f8:	c6 05 d4 a0 12 f0 00 	movb   $0x0,0xf012a0d4
f01044ff:	c6 05 d5 a0 12 f0 8e 	movb   $0x8e,0xf012a0d5
f0104506:	c1 e8 10             	shr    $0x10,%eax
f0104509:	66 a3 d6 a0 12 f0    	mov    %ax,0xf012a0d6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f010450f:	b8 4a 14 12 f0       	mov    $0xf012144a,%eax
f0104514:	66 a3 d8 a0 12 f0    	mov    %ax,0xf012a0d8
f010451a:	66 c7 05 da a0 12 f0 	movw   $0x8,0xf012a0da
f0104521:	08 00 
f0104523:	c6 05 dc a0 12 f0 00 	movb   $0x0,0xf012a0dc
f010452a:	c6 05 dd a0 12 f0 8e 	movb   $0x8e,0xf012a0dd
f0104531:	c1 e8 10             	shr    $0x10,%eax
f0104534:	66 a3 de a0 12 f0    	mov    %ax,0xf012a0de
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f010453a:	b8 52 14 12 f0       	mov    $0xf0121452,%eax
f010453f:	66 a3 e0 a0 12 f0    	mov    %ax,0xf012a0e0
f0104545:	66 c7 05 e2 a0 12 f0 	movw   $0x8,0xf012a0e2
f010454c:	08 00 
f010454e:	c6 05 e4 a0 12 f0 00 	movb   $0x0,0xf012a0e4
f0104555:	c6 05 e5 a0 12 f0 8e 	movb   $0x8e,0xf012a0e5
f010455c:	c1 e8 10             	shr    $0x10,%eax
f010455f:	66 a3 e6 a0 12 f0    	mov    %ax,0xf012a0e6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f0104565:	b8 5a 14 12 f0       	mov    $0xf012145a,%eax
f010456a:	66 a3 e8 a0 12 f0    	mov    %ax,0xf012a0e8
f0104570:	66 c7 05 ea a0 12 f0 	movw   $0x8,0xf012a0ea
f0104577:	08 00 
f0104579:	c6 05 ec a0 12 f0 00 	movb   $0x0,0xf012a0ec
f0104580:	c6 05 ed a0 12 f0 8e 	movb   $0x8e,0xf012a0ed
f0104587:	c1 e8 10             	shr    $0x10,%eax
f010458a:	66 a3 ee a0 12 f0    	mov    %ax,0xf012a0ee
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f0104590:	b8 62 14 12 f0       	mov    $0xf0121462,%eax
f0104595:	66 a3 f0 a0 12 f0    	mov    %ax,0xf012a0f0
f010459b:	66 c7 05 f2 a0 12 f0 	movw   $0x8,0xf012a0f2
f01045a2:	08 00 
f01045a4:	c6 05 f4 a0 12 f0 00 	movb   $0x0,0xf012a0f4
f01045ab:	c6 05 f5 a0 12 f0 8e 	movb   $0x8e,0xf012a0f5
f01045b2:	c1 e8 10             	shr    $0x10,%eax
f01045b5:	66 a3 f6 a0 12 f0    	mov    %ax,0xf012a0f6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f01045bb:	b8 6a 14 12 f0       	mov    $0xf012146a,%eax
f01045c0:	66 a3 00 a1 12 f0    	mov    %ax,0xf012a100
f01045c6:	66 c7 05 02 a1 12 f0 	movw   $0x8,0xf012a102
f01045cd:	08 00 
f01045cf:	c6 05 04 a1 12 f0 00 	movb   $0x0,0xf012a104
f01045d6:	c6 05 05 a1 12 f0 8e 	movb   $0x8e,0xf012a105
f01045dd:	c1 e8 10             	shr    $0x10,%eax
f01045e0:	66 a3 06 a1 12 f0    	mov    %ax,0xf012a106
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f01045e6:	b8 70 14 12 f0       	mov    $0xf0121470,%eax
f01045eb:	66 a3 08 a1 12 f0    	mov    %ax,0xf012a108
f01045f1:	66 c7 05 0a a1 12 f0 	movw   $0x8,0xf012a10a
f01045f8:	08 00 
f01045fa:	c6 05 0c a1 12 f0 00 	movb   $0x0,0xf012a10c
f0104601:	c6 05 0d a1 12 f0 8e 	movb   $0x8e,0xf012a10d
f0104608:	c1 e8 10             	shr    $0x10,%eax
f010460b:	66 a3 0e a1 12 f0    	mov    %ax,0xf012a10e
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f0104611:	b8 74 14 12 f0       	mov    $0xf0121474,%eax
f0104616:	66 a3 10 a1 12 f0    	mov    %ax,0xf012a110
f010461c:	66 c7 05 12 a1 12 f0 	movw   $0x8,0xf012a112
f0104623:	08 00 
f0104625:	c6 05 14 a1 12 f0 00 	movb   $0x0,0xf012a114
f010462c:	c6 05 15 a1 12 f0 8e 	movb   $0x8e,0xf012a115
f0104633:	c1 e8 10             	shr    $0x10,%eax
f0104636:	66 a3 16 a1 12 f0    	mov    %ax,0xf012a116
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f010463c:	b8 7a 14 12 f0       	mov    $0xf012147a,%eax
f0104641:	66 a3 18 a1 12 f0    	mov    %ax,0xf012a118
f0104647:	66 c7 05 1a a1 12 f0 	movw   $0x8,0xf012a11a
f010464e:	08 00 
f0104650:	c6 05 1c a1 12 f0 00 	movb   $0x0,0xf012a11c
f0104657:	c6 05 1d a1 12 f0 8e 	movb   $0x8e,0xf012a11d
f010465e:	c1 e8 10             	shr    $0x10,%eax
f0104661:	66 a3 1e a1 12 f0    	mov    %ax,0xf012a11e
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f0104667:	b8 80 14 12 f0       	mov    $0xf0121480,%eax
f010466c:	66 a3 00 a2 12 f0    	mov    %ax,0xf012a200
f0104672:	66 c7 05 02 a2 12 f0 	movw   $0x8,0xf012a202
f0104679:	08 00 
f010467b:	c6 05 04 a2 12 f0 00 	movb   $0x0,0xf012a204
f0104682:	c6 05 05 a2 12 f0 ee 	movb   $0xee,0xf012a205
f0104689:	c1 e8 10             	shr    $0x10,%eax
f010468c:	66 a3 06 a2 12 f0    	mov    %ax,0xf012a206
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f0104692:	b8 86 14 12 f0       	mov    $0xf0121486,%eax
f0104697:	66 a3 80 a1 12 f0    	mov    %ax,0xf012a180
f010469d:	66 c7 05 82 a1 12 f0 	movw   $0x8,0xf012a182
f01046a4:	08 00 
f01046a6:	c6 05 84 a1 12 f0 00 	movb   $0x0,0xf012a184
f01046ad:	c6 05 85 a1 12 f0 8e 	movb   $0x8e,0xf012a185
f01046b4:	c1 e8 10             	shr    $0x10,%eax
f01046b7:	66 a3 86 a1 12 f0    	mov    %ax,0xf012a186
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f01046bd:	b8 8c 14 12 f0       	mov    $0xf012148c,%eax
f01046c2:	66 a3 88 a1 12 f0    	mov    %ax,0xf012a188
f01046c8:	66 c7 05 8a a1 12 f0 	movw   $0x8,0xf012a18a
f01046cf:	08 00 
f01046d1:	c6 05 8c a1 12 f0 00 	movb   $0x0,0xf012a18c
f01046d8:	c6 05 8d a1 12 f0 8e 	movb   $0x8e,0xf012a18d
f01046df:	c1 e8 10             	shr    $0x10,%eax
f01046e2:	66 a3 8e a1 12 f0    	mov    %ax,0xf012a18e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f01046e8:	b8 92 14 12 f0       	mov    $0xf0121492,%eax
f01046ed:	66 a3 90 a1 12 f0    	mov    %ax,0xf012a190
f01046f3:	66 c7 05 92 a1 12 f0 	movw   $0x8,0xf012a192
f01046fa:	08 00 
f01046fc:	c6 05 94 a1 12 f0 00 	movb   $0x0,0xf012a194
f0104703:	c6 05 95 a1 12 f0 8e 	movb   $0x8e,0xf012a195
f010470a:	c1 e8 10             	shr    $0x10,%eax
f010470d:	66 a3 96 a1 12 f0    	mov    %ax,0xf012a196
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f0104713:	b8 98 14 12 f0       	mov    $0xf0121498,%eax
f0104718:	66 a3 98 a1 12 f0    	mov    %ax,0xf012a198
f010471e:	66 c7 05 9a a1 12 f0 	movw   $0x8,0xf012a19a
f0104725:	08 00 
f0104727:	c6 05 9c a1 12 f0 00 	movb   $0x0,0xf012a19c
f010472e:	c6 05 9d a1 12 f0 8e 	movb   $0x8e,0xf012a19d
f0104735:	c1 e8 10             	shr    $0x10,%eax
f0104738:	66 a3 9e a1 12 f0    	mov    %ax,0xf012a19e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f010473e:	b8 9e 14 12 f0       	mov    $0xf012149e,%eax
f0104743:	66 a3 a0 a1 12 f0    	mov    %ax,0xf012a1a0
f0104749:	66 c7 05 a2 a1 12 f0 	movw   $0x8,0xf012a1a2
f0104750:	08 00 
f0104752:	c6 05 a4 a1 12 f0 00 	movb   $0x0,0xf012a1a4
f0104759:	c6 05 a5 a1 12 f0 8e 	movb   $0x8e,0xf012a1a5
f0104760:	c1 e8 10             	shr    $0x10,%eax
f0104763:	66 a3 a6 a1 12 f0    	mov    %ax,0xf012a1a6
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f0104769:	b8 a4 14 12 f0       	mov    $0xf01214a4,%eax
f010476e:	66 a3 a8 a1 12 f0    	mov    %ax,0xf012a1a8
f0104774:	66 c7 05 aa a1 12 f0 	movw   $0x8,0xf012a1aa
f010477b:	08 00 
f010477d:	c6 05 ac a1 12 f0 00 	movb   $0x0,0xf012a1ac
f0104784:	c6 05 ad a1 12 f0 8e 	movb   $0x8e,0xf012a1ad
f010478b:	c1 e8 10             	shr    $0x10,%eax
f010478e:	66 a3 ae a1 12 f0    	mov    %ax,0xf012a1ae
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f0104794:	b8 aa 14 12 f0       	mov    $0xf01214aa,%eax
f0104799:	66 a3 b0 a1 12 f0    	mov    %ax,0xf012a1b0
f010479f:	66 c7 05 b2 a1 12 f0 	movw   $0x8,0xf012a1b2
f01047a6:	08 00 
f01047a8:	c6 05 b4 a1 12 f0 00 	movb   $0x0,0xf012a1b4
f01047af:	c6 05 b5 a1 12 f0 8e 	movb   $0x8e,0xf012a1b5
f01047b6:	c1 e8 10             	shr    $0x10,%eax
f01047b9:	66 a3 b6 a1 12 f0    	mov    %ax,0xf012a1b6
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f01047bf:	b8 b0 14 12 f0       	mov    $0xf01214b0,%eax
f01047c4:	66 a3 b8 a1 12 f0    	mov    %ax,0xf012a1b8
f01047ca:	66 c7 05 ba a1 12 f0 	movw   $0x8,0xf012a1ba
f01047d1:	08 00 
f01047d3:	c6 05 bc a1 12 f0 00 	movb   $0x0,0xf012a1bc
f01047da:	c6 05 bd a1 12 f0 8e 	movb   $0x8e,0xf012a1bd
f01047e1:	c1 e8 10             	shr    $0x10,%eax
f01047e4:	66 a3 be a1 12 f0    	mov    %ax,0xf012a1be
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f01047ea:	b8 b6 14 12 f0       	mov    $0xf01214b6,%eax
f01047ef:	66 a3 c0 a1 12 f0    	mov    %ax,0xf012a1c0
f01047f5:	66 c7 05 c2 a1 12 f0 	movw   $0x8,0xf012a1c2
f01047fc:	08 00 
f01047fe:	c6 05 c4 a1 12 f0 00 	movb   $0x0,0xf012a1c4
f0104805:	c6 05 c5 a1 12 f0 8e 	movb   $0x8e,0xf012a1c5
f010480c:	c1 e8 10             	shr    $0x10,%eax
f010480f:	66 a3 c6 a1 12 f0    	mov    %ax,0xf012a1c6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f0104815:	b8 bc 14 12 f0       	mov    $0xf01214bc,%eax
f010481a:	66 a3 c8 a1 12 f0    	mov    %ax,0xf012a1c8
f0104820:	66 c7 05 ca a1 12 f0 	movw   $0x8,0xf012a1ca
f0104827:	08 00 
f0104829:	c6 05 cc a1 12 f0 00 	movb   $0x0,0xf012a1cc
f0104830:	c6 05 cd a1 12 f0 8e 	movb   $0x8e,0xf012a1cd
f0104837:	c1 e8 10             	shr    $0x10,%eax
f010483a:	66 a3 ce a1 12 f0    	mov    %ax,0xf012a1ce
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f0104840:	b8 c2 14 12 f0       	mov    $0xf01214c2,%eax
f0104845:	66 a3 d0 a1 12 f0    	mov    %ax,0xf012a1d0
f010484b:	66 c7 05 d2 a1 12 f0 	movw   $0x8,0xf012a1d2
f0104852:	08 00 
f0104854:	c6 05 d4 a1 12 f0 00 	movb   $0x0,0xf012a1d4
f010485b:	c6 05 d5 a1 12 f0 8e 	movb   $0x8e,0xf012a1d5
f0104862:	c1 e8 10             	shr    $0x10,%eax
f0104865:	66 a3 d6 a1 12 f0    	mov    %ax,0xf012a1d6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f010486b:	b8 c8 14 12 f0       	mov    $0xf01214c8,%eax
f0104870:	66 a3 d8 a1 12 f0    	mov    %ax,0xf012a1d8
f0104876:	66 c7 05 da a1 12 f0 	movw   $0x8,0xf012a1da
f010487d:	08 00 
f010487f:	c6 05 dc a1 12 f0 00 	movb   $0x0,0xf012a1dc
f0104886:	c6 05 dd a1 12 f0 8e 	movb   $0x8e,0xf012a1dd
f010488d:	c1 e8 10             	shr    $0x10,%eax
f0104890:	66 a3 de a1 12 f0    	mov    %ax,0xf012a1de
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f0104896:	b8 ce 14 12 f0       	mov    $0xf01214ce,%eax
f010489b:	66 a3 e0 a1 12 f0    	mov    %ax,0xf012a1e0
f01048a1:	66 c7 05 e2 a1 12 f0 	movw   $0x8,0xf012a1e2
f01048a8:	08 00 
f01048aa:	c6 05 e4 a1 12 f0 00 	movb   $0x0,0xf012a1e4
f01048b1:	c6 05 e5 a1 12 f0 8e 	movb   $0x8e,0xf012a1e5
f01048b8:	c1 e8 10             	shr    $0x10,%eax
f01048bb:	66 a3 e6 a1 12 f0    	mov    %ax,0xf012a1e6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f01048c1:	b8 d4 14 12 f0       	mov    $0xf01214d4,%eax
f01048c6:	66 a3 e8 a1 12 f0    	mov    %ax,0xf012a1e8
f01048cc:	66 c7 05 ea a1 12 f0 	movw   $0x8,0xf012a1ea
f01048d3:	08 00 
f01048d5:	c6 05 ec a1 12 f0 00 	movb   $0x0,0xf012a1ec
f01048dc:	c6 05 ed a1 12 f0 8e 	movb   $0x8e,0xf012a1ed
f01048e3:	c1 e8 10             	shr    $0x10,%eax
f01048e6:	66 a3 ee a1 12 f0    	mov    %ax,0xf012a1ee
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f01048ec:	b8 da 14 12 f0       	mov    $0xf01214da,%eax
f01048f1:	66 a3 f0 a1 12 f0    	mov    %ax,0xf012a1f0
f01048f7:	66 c7 05 f2 a1 12 f0 	movw   $0x8,0xf012a1f2
f01048fe:	08 00 
f0104900:	c6 05 f4 a1 12 f0 00 	movb   $0x0,0xf012a1f4
f0104907:	c6 05 f5 a1 12 f0 8e 	movb   $0x8e,0xf012a1f5
f010490e:	c1 e8 10             	shr    $0x10,%eax
f0104911:	66 a3 f6 a1 12 f0    	mov    %ax,0xf012a1f6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f0104917:	b8 e0 14 12 f0       	mov    $0xf01214e0,%eax
f010491c:	66 a3 f8 a1 12 f0    	mov    %ax,0xf012a1f8
f0104922:	66 c7 05 fa a1 12 f0 	movw   $0x8,0xf012a1fa
f0104929:	08 00 
f010492b:	c6 05 fc a1 12 f0 00 	movb   $0x0,0xf012a1fc
f0104932:	c6 05 fd a1 12 f0 8e 	movb   $0x8e,0xf012a1fd
f0104939:	c1 e8 10             	shr    $0x10,%eax
f010493c:	66 a3 fe a1 12 f0    	mov    %ax,0xf012a1fe
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f0104942:	b8 e6 14 12 f0       	mov    $0xf01214e6,%eax
f0104947:	66 a3 18 a2 12 f0    	mov    %ax,0xf012a218
f010494d:	66 c7 05 1a a2 12 f0 	movw   $0x8,0xf012a21a
f0104954:	08 00 
f0104956:	c6 05 1c a2 12 f0 00 	movb   $0x0,0xf012a21c
f010495d:	c6 05 1d a2 12 f0 8e 	movb   $0x8e,0xf012a21d
f0104964:	c1 e8 10             	shr    $0x10,%eax
f0104967:	66 a3 1e a2 12 f0    	mov    %ax,0xf012a21e
	trap_init_percpu();
f010496d:	e8 07 f9 ff ff       	call   f0104279 <trap_init_percpu>
}
f0104972:	c9                   	leave  
f0104973:	c3                   	ret    

f0104974 <print_regs>:
}

//mapped text lab7
 void
print_regs(struct PushRegs *regs)
{
f0104974:	55                   	push   %ebp
f0104975:	89 e5                	mov    %esp,%ebp
f0104977:	53                   	push   %ebx
f0104978:	83 ec 0c             	sub    $0xc,%esp
f010497b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f010497e:	ff 33                	pushl  (%ebx)
f0104980:	68 be 99 10 f0       	push   $0xf01099be
f0104985:	e8 db f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010498a:	83 c4 08             	add    $0x8,%esp
f010498d:	ff 73 04             	pushl  0x4(%ebx)
f0104990:	68 cd 99 10 f0       	push   $0xf01099cd
f0104995:	e8 cb f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010499a:	83 c4 08             	add    $0x8,%esp
f010499d:	ff 73 08             	pushl  0x8(%ebx)
f01049a0:	68 dc 99 10 f0       	push   $0xf01099dc
f01049a5:	e8 bb f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01049aa:	83 c4 08             	add    $0x8,%esp
f01049ad:	ff 73 0c             	pushl  0xc(%ebx)
f01049b0:	68 eb 99 10 f0       	push   $0xf01099eb
f01049b5:	e8 ab f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01049ba:	83 c4 08             	add    $0x8,%esp
f01049bd:	ff 73 10             	pushl  0x10(%ebx)
f01049c0:	68 fa 99 10 f0       	push   $0xf01099fa
f01049c5:	e8 9b f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01049ca:	83 c4 08             	add    $0x8,%esp
f01049cd:	ff 73 14             	pushl  0x14(%ebx)
f01049d0:	68 09 9a 10 f0       	push   $0xf0109a09
f01049d5:	e8 8b f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01049da:	83 c4 08             	add    $0x8,%esp
f01049dd:	ff 73 18             	pushl  0x18(%ebx)
f01049e0:	68 18 9a 10 f0       	push   $0xf0109a18
f01049e5:	e8 7b f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01049ea:	83 c4 08             	add    $0x8,%esp
f01049ed:	ff 73 1c             	pushl  0x1c(%ebx)
f01049f0:	68 27 9a 10 f0       	push   $0xf0109a27
f01049f5:	e8 6b f8 ff ff       	call   f0104265 <cprintf>
}
f01049fa:	83 c4 10             	add    $0x10,%esp
f01049fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104a00:	c9                   	leave  
f0104a01:	c3                   	ret    

f0104a02 <print_trapframe>:
{
f0104a02:	55                   	push   %ebp
f0104a03:	89 e5                	mov    %esp,%ebp
f0104a05:	56                   	push   %esi
f0104a06:	53                   	push   %ebx
f0104a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0104a0a:	83 ec 08             	sub    $0x8,%esp
f0104a0d:	68 90 9f 10 f0       	push   $0xf0109f90
f0104a12:	68 20 80 10 f0       	push   $0xf0108020
f0104a17:	e8 49 f8 ff ff       	call   f0104265 <cprintf>
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104a1c:	e8 f6 ca 01 00       	call   f0121517 <cpunum>
f0104a21:	83 c4 0c             	add    $0xc,%esp
f0104a24:	50                   	push   %eax
f0104a25:	53                   	push   %ebx
f0104a26:	68 8b 9a 10 f0       	push   $0xf0109a8b
f0104a2b:	e8 35 f8 ff ff       	call   f0104265 <cprintf>
	print_regs(&tf->tf_regs);
f0104a30:	89 1c 24             	mov    %ebx,(%esp)
f0104a33:	e8 3c ff ff ff       	call   f0104974 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104a38:	83 c4 08             	add    $0x8,%esp
f0104a3b:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104a3f:	50                   	push   %eax
f0104a40:	68 a9 9a 10 f0       	push   $0xf0109aa9
f0104a45:	e8 1b f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104a4a:	83 c4 08             	add    $0x8,%esp
f0104a4d:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104a51:	50                   	push   %eax
f0104a52:	68 bc 9a 10 f0       	push   $0xf0109abc
f0104a57:	e8 09 f8 ff ff       	call   f0104265 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104a5c:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104a5f:	83 c4 10             	add    $0x10,%esp
f0104a62:	83 f8 13             	cmp    $0x13,%eax
f0104a65:	0f 86 e1 00 00 00    	jbe    f0104b4c <print_trapframe+0x14a>
		return "System call";
f0104a6b:	ba 36 9a 10 f0       	mov    $0xf0109a36,%edx
	if (trapno == T_SYSCALL)
f0104a70:	83 f8 30             	cmp    $0x30,%eax
f0104a73:	74 13                	je     f0104a88 <print_trapframe+0x86>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104a75:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104a78:	83 fa 0f             	cmp    $0xf,%edx
f0104a7b:	ba 42 9a 10 f0       	mov    $0xf0109a42,%edx
f0104a80:	b9 51 9a 10 f0       	mov    $0xf0109a51,%ecx
f0104a85:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104a88:	83 ec 04             	sub    $0x4,%esp
f0104a8b:	52                   	push   %edx
f0104a8c:	50                   	push   %eax
f0104a8d:	68 cf 9a 10 f0       	push   $0xf0109acf
f0104a92:	e8 ce f7 ff ff       	call   f0104265 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104a97:	83 c4 10             	add    $0x10,%esp
f0104a9a:	39 1d 50 d9 5d f0    	cmp    %ebx,0xf05dd950
f0104aa0:	0f 84 b2 00 00 00    	je     f0104b58 <print_trapframe+0x156>
	cprintf("  err  0x%08x", tf->tf_err);
f0104aa6:	83 ec 08             	sub    $0x8,%esp
f0104aa9:	ff 73 2c             	pushl  0x2c(%ebx)
f0104aac:	68 f0 9a 10 f0       	push   $0xf0109af0
f0104ab1:	e8 af f7 ff ff       	call   f0104265 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104ab6:	83 c4 10             	add    $0x10,%esp
f0104ab9:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104abd:	0f 85 b8 00 00 00    	jne    f0104b7b <print_trapframe+0x179>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104ac3:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104ac6:	89 c2                	mov    %eax,%edx
f0104ac8:	83 e2 01             	and    $0x1,%edx
f0104acb:	b9 64 9a 10 f0       	mov    $0xf0109a64,%ecx
f0104ad0:	ba 6f 9a 10 f0       	mov    $0xf0109a6f,%edx
f0104ad5:	0f 44 ca             	cmove  %edx,%ecx
f0104ad8:	89 c2                	mov    %eax,%edx
f0104ada:	83 e2 02             	and    $0x2,%edx
f0104add:	be 7b 9a 10 f0       	mov    $0xf0109a7b,%esi
f0104ae2:	ba 81 9a 10 f0       	mov    $0xf0109a81,%edx
f0104ae7:	0f 45 d6             	cmovne %esi,%edx
f0104aea:	83 e0 04             	and    $0x4,%eax
f0104aed:	b8 86 9a 10 f0       	mov    $0xf0109a86,%eax
f0104af2:	be d3 9c 10 f0       	mov    $0xf0109cd3,%esi
f0104af7:	0f 44 c6             	cmove  %esi,%eax
f0104afa:	51                   	push   %ecx
f0104afb:	52                   	push   %edx
f0104afc:	50                   	push   %eax
f0104afd:	68 fe 9a 10 f0       	push   $0xf0109afe
f0104b02:	e8 5e f7 ff ff       	call   f0104265 <cprintf>
f0104b07:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104b0a:	83 ec 08             	sub    $0x8,%esp
f0104b0d:	ff 73 30             	pushl  0x30(%ebx)
f0104b10:	68 0d 9b 10 f0       	push   $0xf0109b0d
f0104b15:	e8 4b f7 ff ff       	call   f0104265 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104b1a:	83 c4 08             	add    $0x8,%esp
f0104b1d:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104b21:	50                   	push   %eax
f0104b22:	68 1c 9b 10 f0       	push   $0xf0109b1c
f0104b27:	e8 39 f7 ff ff       	call   f0104265 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104b2c:	83 c4 08             	add    $0x8,%esp
f0104b2f:	ff 73 38             	pushl  0x38(%ebx)
f0104b32:	68 2f 9b 10 f0       	push   $0xf0109b2f
f0104b37:	e8 29 f7 ff ff       	call   f0104265 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104b3c:	83 c4 10             	add    $0x10,%esp
f0104b3f:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104b43:	75 4b                	jne    f0104b90 <print_trapframe+0x18e>
}
f0104b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104b48:	5b                   	pop    %ebx
f0104b49:	5e                   	pop    %esi
f0104b4a:	5d                   	pop    %ebp
f0104b4b:	c3                   	ret    
		return excnames[trapno];
f0104b4c:	8b 14 85 40 9f 10 f0 	mov    -0xfef60c0(,%eax,4),%edx
f0104b53:	e9 30 ff ff ff       	jmp    f0104a88 <print_trapframe+0x86>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104b58:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104b5c:	0f 85 44 ff ff ff    	jne    f0104aa6 <print_trapframe+0xa4>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104b62:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104b65:	83 ec 08             	sub    $0x8,%esp
f0104b68:	50                   	push   %eax
f0104b69:	68 e1 9a 10 f0       	push   $0xf0109ae1
f0104b6e:	e8 f2 f6 ff ff       	call   f0104265 <cprintf>
f0104b73:	83 c4 10             	add    $0x10,%esp
f0104b76:	e9 2b ff ff ff       	jmp    f0104aa6 <print_trapframe+0xa4>
		cprintf("\n");
f0104b7b:	83 ec 0c             	sub    $0xc,%esp
f0104b7e:	68 9b 95 10 f0       	push   $0xf010959b
f0104b83:	e8 dd f6 ff ff       	call   f0104265 <cprintf>
f0104b88:	83 c4 10             	add    $0x10,%esp
f0104b8b:	e9 7a ff ff ff       	jmp    f0104b0a <print_trapframe+0x108>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104b90:	83 ec 08             	sub    $0x8,%esp
f0104b93:	ff 73 3c             	pushl  0x3c(%ebx)
f0104b96:	68 3e 9b 10 f0       	push   $0xf0109b3e
f0104b9b:	e8 c5 f6 ff ff       	call   f0104265 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104ba0:	83 c4 08             	add    $0x8,%esp
f0104ba3:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104ba7:	50                   	push   %eax
f0104ba8:	68 4d 9b 10 f0       	push   $0xf0109b4d
f0104bad:	e8 b3 f6 ff ff       	call   f0104265 <cprintf>
f0104bb2:	83 c4 10             	add    $0x10,%esp
}
f0104bb5:	eb 8e                	jmp    f0104b45 <print_trapframe+0x143>

f0104bb7 <page_fault_handler>:


//mapped text lab7
void
page_fault_handler(struct Trapframe *tf)
{
f0104bb7:	55                   	push   %ebp
f0104bb8:	89 e5                	mov    %esp,%ebp
f0104bba:	57                   	push   %edi
f0104bbb:	56                   	push   %esi
f0104bbc:	53                   	push   %ebx
f0104bbd:	83 ec 0c             	sub    $0xc,%esp
f0104bc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104bc3:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f0104bc6:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104bca:	83 e0 03             	and    $0x3,%eax
f0104bcd:	66 83 f8 03          	cmp    $0x3,%ax
f0104bd1:	75 5d                	jne    f0104c30 <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f0104bd3:	e8 3f c9 01 00       	call   f0121517 <cpunum>
f0104bd8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bdb:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104be1:	83 78 68 00          	cmpl   $0x0,0x68(%eax)
f0104be5:	75 69                	jne    f0104c50 <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104be7:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f0104bea:	e8 28 c9 01 00       	call   f0121517 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104bef:	57                   	push   %edi
f0104bf0:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f0104bf1:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104bf4:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104bfa:	ff 70 48             	pushl  0x48(%eax)
f0104bfd:	68 20 9e 10 f0       	push   $0xf0109e20
f0104c02:	e8 5e f6 ff ff       	call   f0104265 <cprintf>
	print_trapframe(tf);
f0104c07:	89 1c 24             	mov    %ebx,(%esp)
f0104c0a:	e8 f3 fd ff ff       	call   f0104a02 <print_trapframe>
	env_destroy(curenv);
f0104c0f:	e8 03 c9 01 00       	call   f0121517 <cpunum>
f0104c14:	83 c4 04             	add    $0x4,%esp
f0104c17:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c1a:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104c20:	e8 38 f4 ff ff       	call   f010405d <env_destroy>
}
f0104c25:	83 c4 10             	add    $0x10,%esp
f0104c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104c2b:	5b                   	pop    %ebx
f0104c2c:	5e                   	pop    %esi
f0104c2d:	5f                   	pop    %edi
f0104c2e:	5d                   	pop    %ebp
f0104c2f:	c3                   	ret    
		print_trapframe(tf);//just test
f0104c30:	83 ec 0c             	sub    $0xc,%esp
f0104c33:	53                   	push   %ebx
f0104c34:	e8 c9 fd ff ff       	call   f0104a02 <print_trapframe>
		panic("panic at kernel page_fault\n");
f0104c39:	83 c4 0c             	add    $0xc,%esp
f0104c3c:	68 60 9b 10 f0       	push   $0xf0109b60
f0104c41:	68 d2 01 00 00       	push   $0x1d2
f0104c46:	68 7c 9b 10 f0       	push   $0xf0109b7c
f0104c4b:	e8 f9 b3 ff ff       	call   f0100049 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104c50:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0104c53:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f0104c58:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));		
f0104c5a:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104c5f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0104c64:	77 05                	ja     f0104c6b <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f0104c66:	8d 42 c8             	lea    -0x38(%edx),%eax
f0104c69:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f0104c6b:	e8 a7 c8 01 00       	call   f0121517 <cpunum>
f0104c70:	6a 02                	push   $0x2
f0104c72:	6a 34                	push   $0x34
f0104c74:	57                   	push   %edi
f0104c75:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c78:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104c7e:	e8 8b e8 ff ff       	call   f010350e <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0104c83:	89 fa                	mov    %edi,%edx
f0104c85:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f0104c87:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104c8a:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0104c8d:	8d 7f 08             	lea    0x8(%edi),%edi
f0104c90:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104c95:	89 de                	mov    %ebx,%esi
f0104c97:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0104c99:	8b 43 30             	mov    0x30(%ebx),%eax
f0104c9c:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0104c9f:	8b 43 38             	mov    0x38(%ebx),%eax
f0104ca2:	89 d7                	mov    %edx,%edi
f0104ca4:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f0104ca7:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104caa:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0104cad:	e8 65 c8 01 00       	call   f0121517 <cpunum>
f0104cb2:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cb5:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104cbb:	8b 58 68             	mov    0x68(%eax),%ebx
f0104cbe:	e8 54 c8 01 00       	call   f0121517 <cpunum>
f0104cc3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cc6:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104ccc:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104ccf:	e8 43 c8 01 00       	call   f0121517 <cpunum>
f0104cd4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cd7:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104cdd:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104ce0:	e8 32 c8 01 00       	call   f0121517 <cpunum>
f0104ce5:	83 c4 04             	add    $0x4,%esp
f0104ce8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ceb:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104cf1:	e8 2e c3 01 00       	call   f0121024 <env_run>

f0104cf6 <trap>:
{
f0104cf6:	55                   	push   %ebp
f0104cf7:	89 e5                	mov    %esp,%ebp
f0104cf9:	57                   	push   %edi
f0104cfa:	56                   	push   %esi
f0104cfb:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104cfe:	fc                   	cld    
	if (panicstr){
f0104cff:	83 3d 80 ed 5d f0 00 	cmpl   $0x0,0xf05ded80
f0104d06:	74 01                	je     f0104d09 <trap+0x13>
		asm volatile("hlt");
f0104d08:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104d09:	e8 09 c8 01 00       	call   f0121517 <cpunum>
f0104d0e:	6b d0 74             	imul   $0x74,%eax,%edx
f0104d11:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104d14:	b8 01 00 00 00       	mov    $0x1,%eax
f0104d19:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
f0104d20:	83 f8 02             	cmp    $0x2,%eax
f0104d23:	74 30                	je     f0104d55 <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104d25:	9c                   	pushf  
f0104d26:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104d27:	f6 c4 02             	test   $0x2,%ah
f0104d2a:	75 3b                	jne    f0104d67 <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0104d2c:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104d30:	83 e0 03             	and    $0x3,%eax
f0104d33:	66 83 f8 03          	cmp    $0x3,%ax
f0104d37:	74 47                	je     f0104d80 <trap+0x8a>
	last_tf = tf;
f0104d39:	89 35 50 d9 5d f0    	mov    %esi,0xf05dd950
	switch (tf->tf_trapno)
f0104d3f:	8b 46 28             	mov    0x28(%esi),%eax
f0104d42:	83 e8 03             	sub    $0x3,%eax
f0104d45:	83 f8 30             	cmp    $0x30,%eax
f0104d48:	0f 87 92 02 00 00    	ja     f0104fe0 <trap+0x2ea>
f0104d4e:	ff 24 85 60 9e 10 f0 	jmp    *-0xfef61a0(,%eax,4)
f0104d55:	83 ec 0c             	sub    $0xc,%esp
f0104d58:	68 20 d3 16 f0       	push   $0xf016d320
f0104d5d:	e8 df 23 00 00       	call   f0107141 <spin_lock>
f0104d62:	83 c4 10             	add    $0x10,%esp
f0104d65:	eb be                	jmp    f0104d25 <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f0104d67:	68 88 9b 10 f0       	push   $0xf0109b88
f0104d6c:	68 ab 92 10 f0       	push   $0xf01092ab
f0104d71:	68 9c 01 00 00       	push   $0x19c
f0104d76:	68 7c 9b 10 f0       	push   $0xf0109b7c
f0104d7b:	e8 c9 b2 ff ff       	call   f0100049 <_panic>
f0104d80:	83 ec 0c             	sub    $0xc,%esp
f0104d83:	68 20 d3 16 f0       	push   $0xf016d320
f0104d88:	e8 b4 23 00 00       	call   f0107141 <spin_lock>
		assert(curenv);
f0104d8d:	e8 85 c7 01 00       	call   f0121517 <cpunum>
f0104d92:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d95:	83 c4 10             	add    $0x10,%esp
f0104d98:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0104d9f:	74 3e                	je     f0104ddf <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f0104da1:	e8 71 c7 01 00       	call   f0121517 <cpunum>
f0104da6:	6b c0 74             	imul   $0x74,%eax,%eax
f0104da9:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104daf:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104db3:	74 43                	je     f0104df8 <trap+0x102>
		curenv->env_tf = *tf;
f0104db5:	e8 5d c7 01 00       	call   f0121517 <cpunum>
f0104dba:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dbd:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104dc3:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104dc8:	89 c7                	mov    %eax,%edi
f0104dca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104dcc:	e8 46 c7 01 00       	call   f0121517 <cpunum>
f0104dd1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dd4:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0104dda:	e9 5a ff ff ff       	jmp    f0104d39 <trap+0x43>
		assert(curenv);
f0104ddf:	68 a1 9b 10 f0       	push   $0xf0109ba1
f0104de4:	68 ab 92 10 f0       	push   $0xf01092ab
f0104de9:	68 a3 01 00 00       	push   $0x1a3
f0104dee:	68 7c 9b 10 f0       	push   $0xf0109b7c
f0104df3:	e8 51 b2 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f0104df8:	e8 1a c7 01 00       	call   f0121517 <cpunum>
f0104dfd:	83 ec 0c             	sub    $0xc,%esp
f0104e00:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e03:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104e09:	e8 62 f0 ff ff       	call   f0103e70 <env_free>
			curenv = NULL;
f0104e0e:	e8 04 c7 01 00       	call   f0121517 <cpunum>
f0104e13:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e16:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f0104e1d:	00 00 00 
			sched_yield();
f0104e20:	e8 f8 02 00 00       	call   f010511d <sched_yield>
			page_fault_handler(tf);
f0104e25:	83 ec 0c             	sub    $0xc,%esp
f0104e28:	56                   	push   %esi
f0104e29:	e8 89 fd ff ff       	call   f0104bb7 <page_fault_handler>
f0104e2e:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104e31:	e8 e1 c6 01 00       	call   f0121517 <cpunum>
f0104e36:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e39:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0104e40:	74 18                	je     f0104e5a <trap+0x164>
f0104e42:	e8 d0 c6 01 00       	call   f0121517 <cpunum>
f0104e47:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e4a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104e50:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104e54:	0f 84 ce 01 00 00    	je     f0105028 <trap+0x332>
		sched_yield();
f0104e5a:	e8 be 02 00 00       	call   f010511d <sched_yield>
			monitor(tf);
f0104e5f:	83 ec 0c             	sub    $0xc,%esp
f0104e62:	56                   	push   %esi
f0104e63:	e8 77 be ff ff       	call   f0100cdf <monitor>
f0104e68:	83 c4 10             	add    $0x10,%esp
f0104e6b:	eb c4                	jmp    f0104e31 <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0104e6d:	83 ec 08             	sub    $0x8,%esp
f0104e70:	ff 76 04             	pushl  0x4(%esi)
f0104e73:	ff 36                	pushl  (%esi)
f0104e75:	ff 76 10             	pushl  0x10(%esi)
f0104e78:	ff 76 18             	pushl  0x18(%esi)
f0104e7b:	ff 76 14             	pushl  0x14(%esi)
f0104e7e:	ff 76 1c             	pushl  0x1c(%esi)
f0104e81:	e8 eb 03 00 00       	call   f0105271 <syscall>
f0104e86:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104e89:	83 c4 20             	add    $0x20,%esp
f0104e8c:	eb a3                	jmp    f0104e31 <trap+0x13b>
			time_tick();
f0104e8e:	e8 e5 2e 00 00       	call   f0107d78 <time_tick>
			lapic_eoi();
f0104e93:	e8 80 21 00 00       	call   f0107018 <lapic_eoi>
			sched_yield();
f0104e98:	e8 80 02 00 00       	call   f010511d <sched_yield>
			kbd_intr();
f0104e9d:	e8 04 b8 ff ff       	call   f01006a6 <kbd_intr>
f0104ea2:	eb 8d                	jmp    f0104e31 <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0104ea4:	83 ec 0c             	sub    $0xc,%esp
f0104ea7:	68 43 9c 10 f0       	push   $0xf0109c43
f0104eac:	e8 b4 f3 ff ff       	call   f0104265 <cprintf>
f0104eb1:	83 c4 10             	add    $0x10,%esp
f0104eb4:	e9 78 ff ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0104eb9:	83 ec 0c             	sub    $0xc,%esp
f0104ebc:	68 5a 9c 10 f0       	push   $0xf0109c5a
f0104ec1:	e8 9f f3 ff ff       	call   f0104265 <cprintf>
f0104ec6:	83 c4 10             	add    $0x10,%esp
f0104ec9:	e9 63 ff ff ff       	jmp    f0104e31 <trap+0x13b>
			serial_intr();
f0104ece:	e8 b7 b7 ff ff       	call   f010068a <serial_intr>
f0104ed3:	e9 59 ff ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0104ed8:	83 ec 0c             	sub    $0xc,%esp
f0104edb:	68 8d 9c 10 f0       	push   $0xf0109c8d
f0104ee0:	e8 80 f3 ff ff       	call   f0104265 <cprintf>
f0104ee5:	83 c4 10             	add    $0x10,%esp
f0104ee8:	e9 44 ff ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0104eed:	83 ec 0c             	sub    $0xc,%esp
f0104ef0:	68 a8 9b 10 f0       	push   $0xf0109ba8
f0104ef5:	e8 6b f3 ff ff       	call   f0104265 <cprintf>
f0104efa:	83 c4 10             	add    $0x10,%esp
f0104efd:	e9 2f ff ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("in Spurious\n");
f0104f02:	83 ec 0c             	sub    $0xc,%esp
f0104f05:	68 be 9b 10 f0       	push   $0xf0109bbe
f0104f0a:	e8 56 f3 ff ff       	call   f0104265 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104f0f:	c7 04 24 cb 9b 10 f0 	movl   $0xf0109bcb,(%esp)
f0104f16:	e8 4a f3 ff ff       	call   f0104265 <cprintf>
f0104f1b:	83 c4 10             	add    $0x10,%esp
f0104f1e:	e9 0e ff ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104f23:	83 ec 0c             	sub    $0xc,%esp
f0104f26:	68 e8 9b 10 f0       	push   $0xf0109be8
f0104f2b:	e8 35 f3 ff ff       	call   f0104265 <cprintf>
f0104f30:	83 c4 10             	add    $0x10,%esp
f0104f33:	e9 f9 fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104f38:	83 ec 0c             	sub    $0xc,%esp
f0104f3b:	68 fe 9b 10 f0       	push   $0xf0109bfe
f0104f40:	e8 20 f3 ff ff       	call   f0104265 <cprintf>
f0104f45:	83 c4 10             	add    $0x10,%esp
f0104f48:	e9 e4 fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104f4d:	83 ec 0c             	sub    $0xc,%esp
f0104f50:	68 14 9c 10 f0       	push   $0xf0109c14
f0104f55:	e8 0b f3 ff ff       	call   f0104265 <cprintf>
f0104f5a:	83 c4 10             	add    $0x10,%esp
f0104f5d:	e9 cf fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104f62:	83 ec 0c             	sub    $0xc,%esp
f0104f65:	68 2b 9c 10 f0       	push   $0xf0109c2b
f0104f6a:	e8 f6 f2 ff ff       	call   f0104265 <cprintf>
f0104f6f:	83 c4 10             	add    $0x10,%esp
f0104f72:	e9 ba fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104f77:	83 ec 0c             	sub    $0xc,%esp
f0104f7a:	68 42 9c 10 f0       	push   $0xf0109c42
f0104f7f:	e8 e1 f2 ff ff       	call   f0104265 <cprintf>
f0104f84:	83 c4 10             	add    $0x10,%esp
f0104f87:	e9 a5 fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104f8c:	83 ec 0c             	sub    $0xc,%esp
f0104f8f:	68 59 9c 10 f0       	push   $0xf0109c59
f0104f94:	e8 cc f2 ff ff       	call   f0104265 <cprintf>
f0104f99:	83 c4 10             	add    $0x10,%esp
f0104f9c:	e9 90 fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104fa1:	83 ec 0c             	sub    $0xc,%esp
f0104fa4:	68 70 9c 10 f0       	push   $0xf0109c70
f0104fa9:	e8 b7 f2 ff ff       	call   f0104265 <cprintf>
f0104fae:	83 c4 10             	add    $0x10,%esp
f0104fb1:	e9 7b fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104fb6:	83 ec 0c             	sub    $0xc,%esp
f0104fb9:	68 8c 9c 10 f0       	push   $0xf0109c8c
f0104fbe:	e8 a2 f2 ff ff       	call   f0104265 <cprintf>
f0104fc3:	83 c4 10             	add    $0x10,%esp
f0104fc6:	e9 66 fe ff ff       	jmp    f0104e31 <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104fcb:	83 ec 0c             	sub    $0xc,%esp
f0104fce:	68 a3 9c 10 f0       	push   $0xf0109ca3
f0104fd3:	e8 8d f2 ff ff       	call   f0104265 <cprintf>
f0104fd8:	83 c4 10             	add    $0x10,%esp
f0104fdb:	e9 51 fe ff ff       	jmp    f0104e31 <trap+0x13b>
			print_trapframe(tf);
f0104fe0:	83 ec 0c             	sub    $0xc,%esp
f0104fe3:	56                   	push   %esi
f0104fe4:	e8 19 fa ff ff       	call   f0104a02 <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104fe9:	83 c4 10             	add    $0x10,%esp
f0104fec:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104ff1:	74 1e                	je     f0105011 <trap+0x31b>
				env_destroy(curenv);
f0104ff3:	e8 1f c5 01 00       	call   f0121517 <cpunum>
f0104ff8:	83 ec 0c             	sub    $0xc,%esp
f0104ffb:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ffe:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105004:	e8 54 f0 ff ff       	call   f010405d <env_destroy>
f0105009:	83 c4 10             	add    $0x10,%esp
f010500c:	e9 20 fe ff ff       	jmp    f0104e31 <trap+0x13b>
				panic("unhandled trap in kernel");
f0105011:	83 ec 04             	sub    $0x4,%esp
f0105014:	68 c1 9c 10 f0       	push   $0xf0109cc1
f0105019:	68 7b 01 00 00       	push   $0x17b
f010501e:	68 7c 9b 10 f0       	push   $0xf0109b7c
f0105023:	e8 21 b0 ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f0105028:	e8 ea c4 01 00       	call   f0121517 <cpunum>
f010502d:	83 ec 0c             	sub    $0xc,%esp
f0105030:	6b c0 74             	imul   $0x74,%eax,%eax
f0105033:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105039:	e8 e6 bf 01 00       	call   f0121024 <env_run>

f010503e <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f010503e:	55                   	push   %ebp
f010503f:	89 e5                	mov    %esp,%ebp
f0105041:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f0105044:	68 ec 9f 10 f0       	push   $0xf0109fec
f0105049:	68 20 80 10 f0       	push   $0xf0108020
f010504e:	e8 12 f2 ff ff       	call   f0104265 <cprintf>
f0105053:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f0105058:	8d 50 54             	lea    0x54(%eax),%edx
f010505b:	83 c4 10             	add    $0x10,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f010505e:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0105063:	8b 02                	mov    (%edx),%eax
f0105065:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0105068:	83 f8 02             	cmp    $0x2,%eax
f010506b:	76 30                	jbe    f010509d <sched_halt+0x5f>
	for (i = 0; i < NENV; i++) {
f010506d:	83 c1 01             	add    $0x1,%ecx
f0105070:	81 c2 84 00 00 00    	add    $0x84,%edx
f0105076:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f010507c:	75 e5                	jne    f0105063 <sched_halt+0x25>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f010507e:	83 ec 0c             	sub    $0xc,%esp
f0105081:	68 c0 9f 10 f0       	push   $0xf0109fc0
f0105086:	e8 da f1 ff ff       	call   f0104265 <cprintf>
f010508b:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f010508e:	83 ec 0c             	sub    $0xc,%esp
f0105091:	6a 00                	push   $0x0
f0105093:	e8 47 bc ff ff       	call   f0100cdf <monitor>
f0105098:	83 c4 10             	add    $0x10,%esp
f010509b:	eb f1                	jmp    f010508e <sched_halt+0x50>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010509d:	e8 75 c4 01 00       	call   f0121517 <cpunum>
f01050a2:	6b c0 74             	imul   $0x74,%eax,%eax
f01050a5:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f01050ac:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01050af:	a1 8c ed 5d f0       	mov    0xf05ded8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01050b4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01050b9:	76 50                	jbe    f010510b <sched_halt+0xcd>
	return (physaddr_t)kva - KERNBASE;
f01050bb:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01050c0:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01050c3:	e8 4f c4 01 00       	call   f0121517 <cpunum>
f01050c8:	6b d0 74             	imul   $0x74,%eax,%edx
f01050cb:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01050ce:	b8 02 00 00 00       	mov    $0x2,%eax
f01050d3:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01050da:	83 ec 0c             	sub    $0xc,%esp
f01050dd:	68 20 d3 16 f0       	push   $0xf016d320
f01050e2:	e8 1d 21 00 00       	call   f0107204 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01050e7:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f01050e9:	e8 29 c4 01 00       	call   f0121517 <cpunum>
f01050ee:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f01050f1:	8b 80 30 b0 16 f0    	mov    -0xfe94fd0(%eax),%eax
f01050f7:	bd 00 00 00 00       	mov    $0x0,%ebp
f01050fc:	89 c4                	mov    %eax,%esp
f01050fe:	6a 00                	push   $0x0
f0105100:	6a 00                	push   $0x0
f0105102:	fb                   	sti    
f0105103:	f4                   	hlt    
f0105104:	eb fd                	jmp    f0105103 <sched_halt+0xc5>
}
f0105106:	83 c4 10             	add    $0x10,%esp
f0105109:	c9                   	leave  
f010510a:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010510b:	50                   	push   %eax
f010510c:	68 30 81 10 f0       	push   $0xf0108130
f0105111:	6a 4d                	push   $0x4d
f0105113:	68 b1 9f 10 f0       	push   $0xf0109fb1
f0105118:	e8 2c af ff ff       	call   f0100049 <_panic>

f010511d <sched_yield>:
{
f010511d:	55                   	push   %ebp
f010511e:	89 e5                	mov    %esp,%ebp
f0105120:	53                   	push   %ebx
f0105121:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f0105124:	e8 ee c3 01 00       	call   f0121517 <cpunum>
f0105129:	6b c0 74             	imul   $0x74,%eax,%eax
f010512c:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0105133:	74 7e                	je     f01051b3 <sched_yield+0x96>
		envid_t cur_tone = ENVX(curenv->env_id);
f0105135:	e8 dd c3 01 00       	call   f0121517 <cpunum>
f010513a:	6b c0 74             	imul   $0x74,%eax,%eax
f010513d:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105143:	8b 48 48             	mov    0x48(%eax),%ecx
f0105146:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f010514c:	8d 41 01             	lea    0x1(%ecx),%eax
f010514f:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0105154:	8b 1d 44 d9 5d f0    	mov    0xf05dd944,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f010515a:	39 c8                	cmp    %ecx,%eax
f010515c:	74 21                	je     f010517f <sched_yield+0x62>
			if(envs[i].env_status == ENV_RUNNABLE){
f010515e:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
f0105164:	01 da                	add    %ebx,%edx
f0105166:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f010516a:	74 0a                	je     f0105176 <sched_yield+0x59>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f010516c:	83 c0 01             	add    $0x1,%eax
f010516f:	25 ff 03 00 00       	and    $0x3ff,%eax
f0105174:	eb e4                	jmp    f010515a <sched_yield+0x3d>
				env_run(&envs[i]);
f0105176:	83 ec 0c             	sub    $0xc,%esp
f0105179:	52                   	push   %edx
f010517a:	e8 a5 be 01 00       	call   f0121024 <env_run>
		if(curenv->env_status == ENV_RUNNING)
f010517f:	e8 93 c3 01 00       	call   f0121517 <cpunum>
f0105184:	6b c0 74             	imul   $0x74,%eax,%eax
f0105187:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010518d:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0105191:	74 0a                	je     f010519d <sched_yield+0x80>
	sched_halt();
f0105193:	e8 a6 fe ff ff       	call   f010503e <sched_halt>
}
f0105198:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010519b:	c9                   	leave  
f010519c:	c3                   	ret    
			env_run(curenv);
f010519d:	e8 75 c3 01 00       	call   f0121517 <cpunum>
f01051a2:	83 ec 0c             	sub    $0xc,%esp
f01051a5:	6b c0 74             	imul   $0x74,%eax,%eax
f01051a8:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01051ae:	e8 71 be 01 00       	call   f0121024 <env_run>
f01051b3:	a1 44 d9 5d f0       	mov    0xf05dd944,%eax
f01051b8:	8d 90 00 10 02 00    	lea    0x21000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f01051be:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01051c2:	74 0b                	je     f01051cf <sched_yield+0xb2>
f01051c4:	05 84 00 00 00       	add    $0x84,%eax
		for(i = 0 ; i < NENV; i++)
f01051c9:	39 d0                	cmp    %edx,%eax
f01051cb:	75 f1                	jne    f01051be <sched_yield+0xa1>
f01051cd:	eb c4                	jmp    f0105193 <sched_yield+0x76>
		  		env_run(&envs[i]);
f01051cf:	83 ec 0c             	sub    $0xc,%esp
f01051d2:	50                   	push   %eax
f01051d3:	e8 4c be 01 00       	call   f0121024 <env_run>

f01051d8 <sys_net_send>:
	return time_msec();
}

int
sys_net_send(const void *buf, uint32_t len)
{
f01051d8:	55                   	push   %ebp
f01051d9:	89 e5                	mov    %esp,%ebp
f01051db:	57                   	push   %edi
f01051dc:	56                   	push   %esi
f01051dd:	53                   	push   %ebx
f01051de:	83 ec 0c             	sub    $0xc,%esp
f01051e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01051e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_tx to send the packet
	// Hint: e1000_tx only accept kernel virtual address
	int r;
	if((r = user_mem_check(curenv, buf, len, PTE_W|PTE_U)) < 0){
f01051e7:	e8 2b c3 01 00       	call   f0121517 <cpunum>
f01051ec:	6a 06                	push   $0x6
f01051ee:	56                   	push   %esi
f01051ef:	53                   	push   %ebx
f01051f0:	6b c0 74             	imul   $0x74,%eax,%eax
f01051f3:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01051f9:	e8 68 e2 ff ff       	call   f0103466 <user_mem_check>
f01051fe:	83 c4 10             	add    $0x10,%esp
f0105201:	85 c0                	test   %eax,%eax
f0105203:	78 19                	js     f010521e <sys_net_send+0x46>
		cprintf("address:%x\n", (uint32_t)buf);
		return r;
	}
	return e1000_tx(buf, len);
f0105205:	83 ec 08             	sub    $0x8,%esp
f0105208:	56                   	push   %esi
f0105209:	53                   	push   %ebx
f010520a:	e8 7d 24 00 00       	call   f010768c <e1000_tx>
f010520f:	89 c7                	mov    %eax,%edi
f0105211:	83 c4 10             	add    $0x10,%esp

}
f0105214:	89 f8                	mov    %edi,%eax
f0105216:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105219:	5b                   	pop    %ebx
f010521a:	5e                   	pop    %esi
f010521b:	5f                   	pop    %edi
f010521c:	5d                   	pop    %ebp
f010521d:	c3                   	ret    
f010521e:	89 c7                	mov    %eax,%edi
		cprintf("address:%x\n", (uint32_t)buf);
f0105220:	83 ec 08             	sub    $0x8,%esp
f0105223:	53                   	push   %ebx
f0105224:	68 f7 9f 10 f0       	push   $0xf0109ff7
f0105229:	e8 37 f0 ff ff       	call   f0104265 <cprintf>
		return r;
f010522e:	83 c4 10             	add    $0x10,%esp
f0105231:	eb e1                	jmp    f0105214 <sys_net_send+0x3c>

f0105233 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
f0105233:	55                   	push   %ebp
f0105234:	89 e5                	mov    %esp,%ebp
f0105236:	53                   	push   %ebx
f0105237:	83 ec 04             	sub    $0x4,%esp
f010523a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	user_mem_assert(curenv, ROUNDDOWN(buf, PGSIZE), PGSIZE, PTE_U | PTE_W);   // check permission
f010523d:	e8 d5 c2 01 00       	call   f0121517 <cpunum>
f0105242:	6a 06                	push   $0x6
f0105244:	68 00 10 00 00       	push   $0x1000
f0105249:	89 da                	mov    %ebx,%edx
f010524b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0105251:	52                   	push   %edx
f0105252:	6b c0 74             	imul   $0x74,%eax,%eax
f0105255:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010525b:	e8 ae e2 ff ff       	call   f010350e <user_mem_assert>
  	return e1000_rx(buf,len);
f0105260:	83 c4 08             	add    $0x8,%esp
f0105263:	ff 75 0c             	pushl  0xc(%ebp)
f0105266:	53                   	push   %ebx
f0105267:	e8 48 25 00 00       	call   f01077b4 <e1000_rx>
}
f010526c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010526f:	c9                   	leave  
f0105270:	c3                   	ret    

f0105271 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0105271:	55                   	push   %ebp
f0105272:	89 e5                	mov    %esp,%ebp
f0105274:	57                   	push   %edi
f0105275:	56                   	push   %esi
f0105276:	53                   	push   %ebx
f0105277:	83 ec 1c             	sub    $0x1c,%esp
f010527a:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f010527d:	83 f8 15             	cmp    $0x15,%eax
f0105280:	0f 87 d6 08 00 00    	ja     f0105b5c <syscall+0x8eb>
f0105286:	ff 24 85 f4 a0 10 f0 	jmp    *-0xfef5f0c(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f010528d:	e8 85 c2 01 00       	call   f0121517 <cpunum>
f0105292:	6a 04                	push   $0x4
f0105294:	ff 75 10             	pushl  0x10(%ebp)
f0105297:	ff 75 0c             	pushl  0xc(%ebp)
f010529a:	6b c0 74             	imul   $0x74,%eax,%eax
f010529d:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01052a3:	e8 66 e2 ff ff       	call   f010350e <user_mem_assert>
	cprintf("%.*s", len, s);
f01052a8:	83 c4 0c             	add    $0xc,%esp
f01052ab:	ff 75 0c             	pushl  0xc(%ebp)
f01052ae:	ff 75 10             	pushl  0x10(%ebp)
f01052b1:	68 03 a0 10 f0       	push   $0xf010a003
f01052b6:	e8 aa ef ff ff       	call   f0104265 <cprintf>
f01052bb:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f01052be:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f01052c3:	89 d8                	mov    %ebx,%eax
f01052c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01052c8:	5b                   	pop    %ebx
f01052c9:	5e                   	pop    %esi
f01052ca:	5f                   	pop    %edi
f01052cb:	5d                   	pop    %ebp
f01052cc:	c3                   	ret    
	return cons_getc();
f01052cd:	e8 e6 b3 ff ff       	call   f01006b8 <cons_getc>
f01052d2:	89 c3                	mov    %eax,%ebx
			break;
f01052d4:	eb ed                	jmp    f01052c3 <syscall+0x52>
	return curenv->env_id;
f01052d6:	e8 3c c2 01 00       	call   f0121517 <cpunum>
f01052db:	6b c0 74             	imul   $0x74,%eax,%eax
f01052de:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01052e4:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01052e7:	eb da                	jmp    f01052c3 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01052e9:	83 ec 04             	sub    $0x4,%esp
f01052ec:	6a 01                	push   $0x1
f01052ee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01052f1:	50                   	push   %eax
f01052f2:	ff 75 0c             	pushl  0xc(%ebp)
f01052f5:	e8 62 e3 ff ff       	call   f010365c <envid2env>
f01052fa:	89 c3                	mov    %eax,%ebx
f01052fc:	83 c4 10             	add    $0x10,%esp
f01052ff:	85 c0                	test   %eax,%eax
f0105301:	78 c0                	js     f01052c3 <syscall+0x52>
	if (e == curenv)
f0105303:	e8 0f c2 01 00       	call   f0121517 <cpunum>
f0105308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010530b:	6b c0 74             	imul   $0x74,%eax,%eax
f010530e:	39 90 28 b0 16 f0    	cmp    %edx,-0xfe94fd8(%eax)
f0105314:	74 3d                	je     f0105353 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0105316:	8b 5a 48             	mov    0x48(%edx),%ebx
f0105319:	e8 f9 c1 01 00       	call   f0121517 <cpunum>
f010531e:	83 ec 04             	sub    $0x4,%esp
f0105321:	53                   	push   %ebx
f0105322:	6b c0 74             	imul   $0x74,%eax,%eax
f0105325:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010532b:	ff 70 48             	pushl  0x48(%eax)
f010532e:	68 23 a0 10 f0       	push   $0xf010a023
f0105333:	e8 2d ef ff ff       	call   f0104265 <cprintf>
f0105338:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f010533b:	83 ec 0c             	sub    $0xc,%esp
f010533e:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105341:	e8 17 ed ff ff       	call   f010405d <env_destroy>
f0105346:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105349:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f010534e:	e9 70 ff ff ff       	jmp    f01052c3 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0105353:	e8 bf c1 01 00       	call   f0121517 <cpunum>
f0105358:	83 ec 08             	sub    $0x8,%esp
f010535b:	6b c0 74             	imul   $0x74,%eax,%eax
f010535e:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105364:	ff 70 48             	pushl  0x48(%eax)
f0105367:	68 08 a0 10 f0       	push   $0xf010a008
f010536c:	e8 f4 ee ff ff       	call   f0104265 <cprintf>
f0105371:	83 c4 10             	add    $0x10,%esp
f0105374:	eb c5                	jmp    f010533b <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f0105376:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f010537d:	76 4a                	jbe    f01053c9 <syscall+0x158>
	return (physaddr_t)kva - KERNBASE;
f010537f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105382:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0105387:	c1 e8 0c             	shr    $0xc,%eax
f010538a:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0105390:	73 4e                	jae    f01053e0 <syscall+0x16f>
	return &pages[PGNUM(pa)];
f0105392:	8b 15 90 ed 5d f0    	mov    0xf05ded90,%edx
f0105398:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f010539b:	85 db                	test   %ebx,%ebx
f010539d:	0f 84 c3 07 00 00    	je     f0105b66 <syscall+0x8f5>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f01053a3:	e8 6f c1 01 00       	call   f0121517 <cpunum>
f01053a8:	6a 06                	push   $0x6
f01053aa:	ff 75 10             	pushl  0x10(%ebp)
f01053ad:	53                   	push   %ebx
f01053ae:	6b c0 74             	imul   $0x74,%eax,%eax
f01053b1:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01053b7:	ff 70 60             	pushl  0x60(%eax)
f01053ba:	e8 cf c2 ff ff       	call   f010168e <page_insert>
f01053bf:	89 c3                	mov    %eax,%ebx
f01053c1:	83 c4 10             	add    $0x10,%esp
f01053c4:	e9 fa fe ff ff       	jmp    f01052c3 <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01053c9:	ff 75 0c             	pushl  0xc(%ebp)
f01053cc:	68 30 81 10 f0       	push   $0xf0108130
f01053d1:	68 af 01 00 00       	push   $0x1af
f01053d6:	68 3b a0 10 f0       	push   $0xf010a03b
f01053db:	e8 69 ac ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f01053e0:	83 ec 04             	sub    $0x4,%esp
f01053e3:	68 d0 89 10 f0       	push   $0xf01089d0
f01053e8:	6a 51                	push   $0x51
f01053ea:	68 91 92 10 f0       	push   $0xf0109291
f01053ef:	e8 55 ac ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f01053f4:	e8 1e c1 01 00       	call   f0121517 <cpunum>
	if(inc < PGSIZE){
f01053f9:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f0105400:	77 22                	ja     f0105424 <syscall+0x1b3>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105402:	6b c0 74             	imul   $0x74,%eax,%eax
f0105405:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010540b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
f0105411:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f0105416:	03 45 0c             	add    0xc(%ebp),%eax
f0105419:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f010541e:	0f 86 82 00 00 00    	jbe    f01054a6 <syscall+0x235>
	int i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f0105424:	e8 ee c0 01 00       	call   f0121517 <cpunum>
f0105429:	6b c0 74             	imul   $0x74,%eax,%eax
f010542c:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105432:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f0105438:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f010543e:	e8 d4 c0 01 00       	call   f0121517 <cpunum>
f0105443:	6b c0 74             	imul   $0x74,%eax,%eax
f0105446:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010544c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
f0105452:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105455:	8d b4 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%esi
f010545c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f0105462:	39 de                	cmp    %ebx,%esi
f0105464:	0f 8e 9a 00 00 00    	jle    f0105504 <syscall+0x293>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f010546a:	83 ec 0c             	sub    $0xc,%esp
f010546d:	6a 01                	push   $0x1
f010546f:	e8 de be ff ff       	call   f0101352 <page_alloc>
f0105474:	89 c7                	mov    %eax,%edi
		if(!page)
f0105476:	83 c4 10             	add    $0x10,%esp
f0105479:	85 c0                	test   %eax,%eax
f010547b:	74 59                	je     f01054d6 <syscall+0x265>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f010547d:	e8 95 c0 01 00       	call   f0121517 <cpunum>
f0105482:	6a 06                	push   $0x6
f0105484:	53                   	push   %ebx
f0105485:	57                   	push   %edi
f0105486:	6b c0 74             	imul   $0x74,%eax,%eax
f0105489:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010548f:	ff 70 60             	pushl  0x60(%eax)
f0105492:	e8 f7 c1 ff ff       	call   f010168e <page_insert>
		if(ret)
f0105497:	83 c4 10             	add    $0x10,%esp
f010549a:	85 c0                	test   %eax,%eax
f010549c:	75 4f                	jne    f01054ed <syscall+0x27c>
	for(; i < end; i+=PGSIZE){
f010549e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01054a4:	eb bc                	jmp    f0105462 <syscall+0x1f1>
			curenv->env_sbrk+=inc;
f01054a6:	e8 6c c0 01 00       	call   f0121517 <cpunum>
f01054ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01054ae:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01054b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01054b7:	01 88 80 00 00 00    	add    %ecx,0x80(%eax)
			return curenv->env_sbrk;
f01054bd:	e8 55 c0 01 00       	call   f0121517 <cpunum>
f01054c2:	6b c0 74             	imul   $0x74,%eax,%eax
f01054c5:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01054cb:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f01054d1:	e9 ed fd ff ff       	jmp    f01052c3 <syscall+0x52>
			panic("there is no page\n");
f01054d6:	83 ec 04             	sub    $0x4,%esp
f01054d9:	68 44 96 10 f0       	push   $0xf0109644
f01054de:	68 c4 01 00 00       	push   $0x1c4
f01054e3:	68 3b a0 10 f0       	push   $0xf010a03b
f01054e8:	e8 5c ab ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f01054ed:	83 ec 04             	sub    $0x4,%esp
f01054f0:	68 61 96 10 f0       	push   $0xf0109661
f01054f5:	68 c7 01 00 00       	push   $0x1c7
f01054fa:	68 3b a0 10 f0       	push   $0xf010a03b
f01054ff:	e8 45 ab ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f0105504:	e8 0e c0 01 00       	call   f0121517 <cpunum>
f0105509:	6b c0 74             	imul   $0x74,%eax,%eax
f010550c:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105512:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105515:	01 88 80 00 00 00    	add    %ecx,0x80(%eax)
	return curenv->env_sbrk;
f010551b:	e8 f7 bf 01 00       	call   f0121517 <cpunum>
f0105520:	6b c0 74             	imul   $0x74,%eax,%eax
f0105523:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105529:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f010552f:	e9 8f fd ff ff       	jmp    f01052c3 <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f0105534:	83 ec 04             	sub    $0x4,%esp
f0105537:	68 60 a0 10 f0       	push   $0xf010a060
f010553c:	68 27 02 00 00       	push   $0x227
f0105541:	68 3b a0 10 f0       	push   $0xf010a03b
f0105546:	e8 fe aa ff ff       	call   f0100049 <_panic>
	sched_yield();
f010554b:	e8 cd fb ff ff       	call   f010511d <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105550:	e8 c2 bf 01 00       	call   f0121517 <cpunum>
f0105555:	83 ec 08             	sub    $0x8,%esp
f0105558:	6b c0 74             	imul   $0x74,%eax,%eax
f010555b:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105561:	ff 70 48             	pushl  0x48(%eax)
f0105564:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105567:	50                   	push   %eax
f0105568:	e8 37 e2 ff ff       	call   f01037a4 <env_alloc>
f010556d:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f010556f:	83 c4 10             	add    $0x10,%esp
f0105572:	85 c0                	test   %eax,%eax
f0105574:	0f 88 49 fd ff ff    	js     f01052c3 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f010557a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010557d:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f0105584:	e8 8e bf 01 00       	call   f0121517 <cpunum>
f0105589:	6b c0 74             	imul   $0x74,%eax,%eax
f010558c:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0105592:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105597:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010559a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f010559c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010559f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01055a6:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01055a9:	e9 15 fd ff ff       	jmp    f01052c3 <syscall+0x52>
	switch (status)
f01055ae:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01055b2:	74 06                	je     f01055ba <syscall+0x349>
f01055b4:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f01055b8:	75 54                	jne    f010560e <syscall+0x39d>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01055ba:	8b 45 10             	mov    0x10(%ebp),%eax
f01055bd:	83 e8 02             	sub    $0x2,%eax
f01055c0:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01055c5:	75 31                	jne    f01055f8 <syscall+0x387>
	int ret = envid2env(envid, &e, 1);
f01055c7:	83 ec 04             	sub    $0x4,%esp
f01055ca:	6a 01                	push   $0x1
f01055cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01055cf:	50                   	push   %eax
f01055d0:	ff 75 0c             	pushl  0xc(%ebp)
f01055d3:	e8 84 e0 ff ff       	call   f010365c <envid2env>
f01055d8:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01055da:	83 c4 10             	add    $0x10,%esp
f01055dd:	85 c0                	test   %eax,%eax
f01055df:	0f 88 de fc ff ff    	js     f01052c3 <syscall+0x52>
	e->env_status = status;
f01055e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01055eb:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f01055ee:	bb 00 00 00 00       	mov    $0x0,%ebx
f01055f3:	e9 cb fc ff ff       	jmp    f01052c3 <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01055f8:	68 8c a0 10 f0       	push   $0xf010a08c
f01055fd:	68 ab 92 10 f0       	push   $0xf01092ab
f0105602:	6a 7b                	push   $0x7b
f0105604:	68 3b a0 10 f0       	push   $0xf010a03b
f0105609:	e8 3b aa ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f010560e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105613:	e9 ab fc ff ff       	jmp    f01052c3 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105618:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010561f:	0f 87 cd 00 00 00    	ja     f01056f2 <syscall+0x481>
f0105625:	8b 45 10             	mov    0x10(%ebp),%eax
f0105628:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f010562d:	8b 55 14             	mov    0x14(%ebp),%edx
f0105630:	83 e2 05             	and    $0x5,%edx
f0105633:	83 fa 05             	cmp    $0x5,%edx
f0105636:	0f 85 c0 00 00 00    	jne    f01056fc <syscall+0x48b>
	if(perm & ~PTE_SYSCALL)
f010563c:	8b 5d 14             	mov    0x14(%ebp),%ebx
f010563f:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0105645:	09 c3                	or     %eax,%ebx
f0105647:	0f 85 b9 00 00 00    	jne    f0105706 <syscall+0x495>
	int ret = envid2env(envid, &e, 1);
f010564d:	83 ec 04             	sub    $0x4,%esp
f0105650:	6a 01                	push   $0x1
f0105652:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105655:	50                   	push   %eax
f0105656:	ff 75 0c             	pushl  0xc(%ebp)
f0105659:	e8 fe df ff ff       	call   f010365c <envid2env>
	if(ret < 0)
f010565e:	83 c4 10             	add    $0x10,%esp
f0105661:	85 c0                	test   %eax,%eax
f0105663:	0f 88 a7 00 00 00    	js     f0105710 <syscall+0x49f>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0105669:	83 ec 0c             	sub    $0xc,%esp
f010566c:	6a 01                	push   $0x1
f010566e:	e8 df bc ff ff       	call   f0101352 <page_alloc>
f0105673:	89 c6                	mov    %eax,%esi
	if(page == NULL)
f0105675:	83 c4 10             	add    $0x10,%esp
f0105678:	85 c0                	test   %eax,%eax
f010567a:	0f 84 97 00 00 00    	je     f0105717 <syscall+0x4a6>
	return (pp - pages) << PGSHIFT;
f0105680:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0105686:	c1 f8 03             	sar    $0x3,%eax
f0105689:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010568c:	89 c2                	mov    %eax,%edx
f010568e:	c1 ea 0c             	shr    $0xc,%edx
f0105691:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0105697:	73 47                	jae    f01056e0 <syscall+0x46f>
	memset(page2kva(page), 0, PGSIZE);
f0105699:	83 ec 04             	sub    $0x4,%esp
f010569c:	68 00 10 00 00       	push   $0x1000
f01056a1:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01056a3:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01056a8:	50                   	push   %eax
f01056a9:	e8 19 12 00 00       	call   f01068c7 <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f01056ae:	ff 75 14             	pushl  0x14(%ebp)
f01056b1:	ff 75 10             	pushl  0x10(%ebp)
f01056b4:	56                   	push   %esi
f01056b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01056b8:	ff 70 60             	pushl  0x60(%eax)
f01056bb:	e8 ce bf ff ff       	call   f010168e <page_insert>
f01056c0:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f01056c2:	83 c4 20             	add    $0x20,%esp
f01056c5:	85 c0                	test   %eax,%eax
f01056c7:	0f 89 f6 fb ff ff    	jns    f01052c3 <syscall+0x52>
		page_free(page);
f01056cd:	83 ec 0c             	sub    $0xc,%esp
f01056d0:	56                   	push   %esi
f01056d1:	e8 ee bc ff ff       	call   f01013c4 <page_free>
f01056d6:	83 c4 10             	add    $0x10,%esp
		return ret;
f01056d9:	89 fb                	mov    %edi,%ebx
f01056db:	e9 e3 fb ff ff       	jmp    f01052c3 <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01056e0:	50                   	push   %eax
f01056e1:	68 0c 81 10 f0       	push   $0xf010810c
f01056e6:	6a 58                	push   $0x58
f01056e8:	68 91 92 10 f0       	push   $0xf0109291
f01056ed:	e8 57 a9 ff ff       	call   f0100049 <_panic>
		return -E_INVAL;
f01056f2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01056f7:	e9 c7 fb ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f01056fc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105701:	e9 bd fb ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f0105706:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010570b:	e9 b3 fb ff ff       	jmp    f01052c3 <syscall+0x52>
		return ret;
f0105710:	89 c3                	mov    %eax,%ebx
f0105712:	e9 ac fb ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_NO_MEM;
f0105717:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f010571c:	e9 a2 fb ff ff       	jmp    f01052c3 <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105721:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105724:	83 e0 05             	and    $0x5,%eax
f0105727:	83 f8 05             	cmp    $0x5,%eax
f010572a:	0f 85 c0 00 00 00    	jne    f01057f0 <syscall+0x57f>
	if(perm & ~PTE_SYSCALL)
f0105730:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105733:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f0105738:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010573f:	0f 87 b5 00 00 00    	ja     f01057fa <syscall+0x589>
f0105745:	8b 55 10             	mov    0x10(%ebp),%edx
f0105748:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f010574e:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105755:	0f 87 a9 00 00 00    	ja     f0105804 <syscall+0x593>
f010575b:	09 d0                	or     %edx,%eax
f010575d:	8b 55 18             	mov    0x18(%ebp),%edx
f0105760:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f0105766:	09 d0                	or     %edx,%eax
f0105768:	0f 85 a0 00 00 00    	jne    f010580e <syscall+0x59d>
	int ret = envid2env(srcenvid, &src_env, 1);
f010576e:	83 ec 04             	sub    $0x4,%esp
f0105771:	6a 01                	push   $0x1
f0105773:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105776:	50                   	push   %eax
f0105777:	ff 75 0c             	pushl  0xc(%ebp)
f010577a:	e8 dd de ff ff       	call   f010365c <envid2env>
f010577f:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105781:	83 c4 10             	add    $0x10,%esp
f0105784:	85 c0                	test   %eax,%eax
f0105786:	0f 88 37 fb ff ff    	js     f01052c3 <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f010578c:	83 ec 04             	sub    $0x4,%esp
f010578f:	6a 01                	push   $0x1
f0105791:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105794:	50                   	push   %eax
f0105795:	ff 75 14             	pushl  0x14(%ebp)
f0105798:	e8 bf de ff ff       	call   f010365c <envid2env>
f010579d:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f010579f:	83 c4 10             	add    $0x10,%esp
f01057a2:	85 c0                	test   %eax,%eax
f01057a4:	0f 88 19 fb ff ff    	js     f01052c3 <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f01057aa:	83 ec 04             	sub    $0x4,%esp
f01057ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01057b0:	50                   	push   %eax
f01057b1:	ff 75 10             	pushl  0x10(%ebp)
f01057b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01057b7:	ff 70 60             	pushl  0x60(%eax)
f01057ba:	e8 ef bd ff ff       	call   f01015ae <page_lookup>
	if(src_page == NULL)
f01057bf:	83 c4 10             	add    $0x10,%esp
f01057c2:	85 c0                	test   %eax,%eax
f01057c4:	74 52                	je     f0105818 <syscall+0x5a7>
	if(perm & PTE_W){
f01057c6:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01057ca:	74 08                	je     f01057d4 <syscall+0x563>
		if((*pte_store & PTE_W) == 0)
f01057cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01057cf:	f6 02 02             	testb  $0x2,(%edx)
f01057d2:	74 4e                	je     f0105822 <syscall+0x5b1>
	return page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f01057d4:	ff 75 1c             	pushl  0x1c(%ebp)
f01057d7:	ff 75 18             	pushl  0x18(%ebp)
f01057da:	50                   	push   %eax
f01057db:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057de:	ff 70 60             	pushl  0x60(%eax)
f01057e1:	e8 a8 be ff ff       	call   f010168e <page_insert>
f01057e6:	89 c3                	mov    %eax,%ebx
f01057e8:	83 c4 10             	add    $0x10,%esp
f01057eb:	e9 d3 fa ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f01057f0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01057f5:	e9 c9 fa ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f01057fa:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01057ff:	e9 bf fa ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f0105804:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105809:	e9 b5 fa ff ff       	jmp    f01052c3 <syscall+0x52>
f010580e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105813:	e9 ab fa ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f0105818:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010581d:	e9 a1 fa ff ff       	jmp    f01052c3 <syscall+0x52>
			return -E_INVAL;
f0105822:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105827:	e9 97 fa ff ff       	jmp    f01052c3 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f010582c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105833:	77 45                	ja     f010587a <syscall+0x609>
f0105835:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010583c:	75 46                	jne    f0105884 <syscall+0x613>
	int ret = envid2env(envid, &env, 1);
f010583e:	83 ec 04             	sub    $0x4,%esp
f0105841:	6a 01                	push   $0x1
f0105843:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105846:	50                   	push   %eax
f0105847:	ff 75 0c             	pushl  0xc(%ebp)
f010584a:	e8 0d de ff ff       	call   f010365c <envid2env>
f010584f:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105851:	83 c4 10             	add    $0x10,%esp
f0105854:	85 c0                	test   %eax,%eax
f0105856:	0f 88 67 fa ff ff    	js     f01052c3 <syscall+0x52>
	page_remove(env->env_pgdir, va);
f010585c:	83 ec 08             	sub    $0x8,%esp
f010585f:	ff 75 10             	pushl  0x10(%ebp)
f0105862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105865:	ff 70 60             	pushl  0x60(%eax)
f0105868:	e8 db bd ff ff       	call   f0101648 <page_remove>
f010586d:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105870:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105875:	e9 49 fa ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f010587a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010587f:	e9 3f fa ff ff       	jmp    f01052c3 <syscall+0x52>
f0105884:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105889:	e9 35 fa ff ff       	jmp    f01052c3 <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f010588e:	83 ec 04             	sub    $0x4,%esp
f0105891:	6a 00                	push   $0x0
f0105893:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105896:	50                   	push   %eax
f0105897:	ff 75 0c             	pushl  0xc(%ebp)
f010589a:	e8 bd dd ff ff       	call   f010365c <envid2env>
f010589f:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f01058a1:	83 c4 10             	add    $0x10,%esp
f01058a4:	85 c0                	test   %eax,%eax
f01058a6:	0f 88 17 fa ff ff    	js     f01052c3 <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f01058ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058af:	80 78 6c 00          	cmpb   $0x0,0x6c(%eax)
f01058b3:	0f 84 09 01 00 00    	je     f01059c2 <syscall+0x751>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f01058b9:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01058c0:	77 78                	ja     f010593a <syscall+0x6c9>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01058c2:	8b 45 18             	mov    0x18(%ebp),%eax
f01058c5:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f01058c8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01058cd:	83 f8 05             	cmp    $0x5,%eax
f01058d0:	0f 85 ed f9 ff ff    	jne    f01052c3 <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f01058d6:	8b 55 14             	mov    0x14(%ebp),%edx
f01058d9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f01058df:	8b 45 18             	mov    0x18(%ebp),%eax
f01058e2:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f01058e7:	09 c2                	or     %eax,%edx
f01058e9:	0f 85 d4 f9 ff ff    	jne    f01052c3 <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f01058ef:	e8 23 bc 01 00       	call   f0121517 <cpunum>
f01058f4:	83 ec 04             	sub    $0x4,%esp
f01058f7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01058fa:	52                   	push   %edx
f01058fb:	ff 75 14             	pushl  0x14(%ebp)
f01058fe:	6b c0 74             	imul   $0x74,%eax,%eax
f0105901:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105907:	ff 70 60             	pushl  0x60(%eax)
f010590a:	e8 9f bc ff ff       	call   f01015ae <page_lookup>
		if(!page)
f010590f:	83 c4 10             	add    $0x10,%esp
f0105912:	85 c0                	test   %eax,%eax
f0105914:	0f 84 9e 00 00 00    	je     f01059b8 <syscall+0x747>
		if((perm & PTE_W) && !(*pte & PTE_W))
f010591a:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f010591e:	74 0c                	je     f010592c <syscall+0x6bb>
f0105920:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105923:	f6 02 02             	testb  $0x2,(%edx)
f0105926:	0f 84 97 f9 ff ff    	je     f01052c3 <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f010592c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010592f:	8b 4a 70             	mov    0x70(%edx),%ecx
f0105932:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0105938:	76 52                	jbe    f010598c <syscall+0x71b>
	dst_env->env_ipc_recving = 0;
f010593a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010593d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105941:	e8 d1 bb 01 00       	call   f0121517 <cpunum>
f0105946:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105949:	6b c0 74             	imul   $0x74,%eax,%eax
f010594c:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105952:	8b 40 48             	mov    0x48(%eax),%eax
f0105955:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_ipc_value = value;
f0105958:	8b 45 10             	mov    0x10(%ebp),%eax
f010595b:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f010595e:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f0105965:	b8 00 00 00 00       	mov    $0x0,%eax
f010596a:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f010596e:	89 45 18             	mov    %eax,0x18(%ebp)
f0105971:	89 42 7c             	mov    %eax,0x7c(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f0105974:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f010597b:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f0105982:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105987:	e9 37 f9 ff ff       	jmp    f01052c3 <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f010598c:	ff 75 18             	pushl  0x18(%ebp)
f010598f:	51                   	push   %ecx
f0105990:	50                   	push   %eax
f0105991:	ff 72 60             	pushl  0x60(%edx)
f0105994:	e8 f5 bc ff ff       	call   f010168e <page_insert>
f0105999:	89 c3                	mov    %eax,%ebx
			if(ret < 0){
f010599b:	83 c4 10             	add    $0x10,%esp
f010599e:	85 c0                	test   %eax,%eax
f01059a0:	79 98                	jns    f010593a <syscall+0x6c9>
				cprintf("2the ret in rece %d\n", ret);
f01059a2:	83 ec 08             	sub    $0x8,%esp
f01059a5:	50                   	push   %eax
f01059a6:	68 4a a0 10 f0       	push   $0xf010a04a
f01059ab:	e8 b5 e8 ff ff       	call   f0104265 <cprintf>
f01059b0:	83 c4 10             	add    $0x10,%esp
f01059b3:	e9 0b f9 ff ff       	jmp    f01052c3 <syscall+0x52>
			return -E_INVAL;		
f01059b8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01059bd:	e9 01 f9 ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_IPC_NOT_RECV;
f01059c2:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f01059c7:	e9 f7 f8 ff ff       	jmp    f01052c3 <syscall+0x52>
	if(dstva < (void *)UTOP){
f01059cc:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f01059d3:	77 13                	ja     f01059e8 <syscall+0x777>
		if((uint32_t)dstva % PGSIZE != 0)
f01059d5:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f01059dc:	74 0a                	je     f01059e8 <syscall+0x777>
			ret = sys_ipc_recv((void *)a1);
f01059de:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f01059e3:	e9 db f8 ff ff       	jmp    f01052c3 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f01059e8:	e8 2a bb 01 00       	call   f0121517 <cpunum>
f01059ed:	6b c0 74             	imul   $0x74,%eax,%eax
f01059f0:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01059f6:	c6 40 6c 01          	movb   $0x1,0x6c(%eax)
	curenv->env_ipc_dstva = dstva;
f01059fa:	e8 18 bb 01 00       	call   f0121517 <cpunum>
f01059ff:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a02:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105a08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105a0b:	89 48 70             	mov    %ecx,0x70(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105a0e:	e8 04 bb 01 00       	call   f0121517 <cpunum>
f0105a13:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a16:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105a1c:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105a23:	e8 f5 f6 ff ff       	call   f010511d <sched_yield>
	int ret = envid2env(envid, &e, 1);
f0105a28:	83 ec 04             	sub    $0x4,%esp
f0105a2b:	6a 01                	push   $0x1
f0105a2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a30:	50                   	push   %eax
f0105a31:	ff 75 0c             	pushl  0xc(%ebp)
f0105a34:	e8 23 dc ff ff       	call   f010365c <envid2env>
f0105a39:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105a3b:	83 c4 10             	add    $0x10,%esp
f0105a3e:	85 c0                	test   %eax,%eax
f0105a40:	0f 88 7d f8 ff ff    	js     f01052c3 <syscall+0x52>
	e->env_pgfault_upcall = func;
f0105a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105a4c:	89 48 68             	mov    %ecx,0x68(%eax)
	return 0;
f0105a4f:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105a54:	e9 6a f8 ff ff       	jmp    f01052c3 <syscall+0x52>
	r = envid2env(envid, &e, 0);
f0105a59:	83 ec 04             	sub    $0x4,%esp
f0105a5c:	6a 00                	push   $0x0
f0105a5e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a61:	50                   	push   %eax
f0105a62:	ff 75 0c             	pushl  0xc(%ebp)
f0105a65:	e8 f2 db ff ff       	call   f010365c <envid2env>
f0105a6a:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f0105a6c:	83 c4 10             	add    $0x10,%esp
f0105a6f:	85 c0                	test   %eax,%eax
f0105a71:	0f 88 4c f8 ff ff    	js     f01052c3 <syscall+0x52>
	e->env_tf = *tf;
f0105a77:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105a7c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105a7f:	8b 75 10             	mov    0x10(%ebp),%esi
f0105a82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f0105a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a87:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f0105a8c:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f0105a93:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105a98:	e9 26 f8 ff ff       	jmp    f01052c3 <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f0105a9d:	83 ec 04             	sub    $0x4,%esp
f0105aa0:	6a 00                	push   $0x0
f0105aa2:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105aa5:	50                   	push   %eax
f0105aa6:	ff 75 0c             	pushl  0xc(%ebp)
f0105aa9:	e8 ae db ff ff       	call   f010365c <envid2env>
f0105aae:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105ab0:	83 c4 10             	add    $0x10,%esp
f0105ab3:	85 c0                	test   %eax,%eax
f0105ab5:	0f 88 08 f8 ff ff    	js     f01052c3 <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f0105abb:	83 ec 04             	sub    $0x4,%esp
f0105abe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105ac1:	50                   	push   %eax
f0105ac2:	ff 75 10             	pushl  0x10(%ebp)
f0105ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105ac8:	ff 70 60             	pushl  0x60(%eax)
f0105acb:	e8 de ba ff ff       	call   f01015ae <page_lookup>
	if(page == NULL)
f0105ad0:	83 c4 10             	add    $0x10,%esp
f0105ad3:	85 c0                	test   %eax,%eax
f0105ad5:	74 16                	je     f0105aed <syscall+0x87c>
	*pte_store |= PTE_A;
f0105ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105ada:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f0105add:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105ae0:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f0105ae3:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105ae8:	e9 d6 f7 ff ff       	jmp    f01052c3 <syscall+0x52>
		return -E_INVAL;
f0105aed:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105af2:	e9 cc f7 ff ff       	jmp    f01052c3 <syscall+0x52>
	return time_msec();
f0105af7:	e8 aa 22 00 00       	call   f0107da6 <time_msec>
f0105afc:	89 c3                	mov    %eax,%ebx
			break;
f0105afe:	e9 c0 f7 ff ff       	jmp    f01052c3 <syscall+0x52>
			ret = sys_net_send((void *)a1, (uint32_t)a2);
f0105b03:	83 ec 08             	sub    $0x8,%esp
f0105b06:	ff 75 10             	pushl  0x10(%ebp)
f0105b09:	ff 75 0c             	pushl  0xc(%ebp)
f0105b0c:	e8 c7 f6 ff ff       	call   f01051d8 <sys_net_send>
f0105b11:	89 c3                	mov    %eax,%ebx
			break;
f0105b13:	83 c4 10             	add    $0x10,%esp
f0105b16:	e9 a8 f7 ff ff       	jmp    f01052c3 <syscall+0x52>
			ret = sys_net_recv((void *)a1, (uint32_t)a2);
f0105b1b:	83 ec 08             	sub    $0x8,%esp
f0105b1e:	ff 75 10             	pushl  0x10(%ebp)
f0105b21:	ff 75 0c             	pushl  0xc(%ebp)
f0105b24:	e8 0a f7 ff ff       	call   f0105233 <sys_net_recv>
f0105b29:	89 c3                	mov    %eax,%ebx
			break;
f0105b2b:	83 c4 10             	add    $0x10,%esp
f0105b2e:	e9 90 f7 ff ff       	jmp    f01052c3 <syscall+0x52>
	*mac_addr_store = read_eeprom_mac_addr();
f0105b33:	e8 f9 17 00 00       	call   f0107331 <read_eeprom_mac_addr>
f0105b38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105b3b:	89 01                	mov    %eax,(%ecx)
f0105b3d:	89 51 04             	mov    %edx,0x4(%ecx)
	cprintf("in sys_get_mac_addr the mac_addr is 0x%016lx\n", *mac_addr_store);
f0105b40:	83 ec 04             	sub    $0x4,%esp
f0105b43:	52                   	push   %edx
f0105b44:	50                   	push   %eax
f0105b45:	68 c4 a0 10 f0       	push   $0xf010a0c4
f0105b4a:	e8 16 e7 ff ff       	call   f0104265 <cprintf>
f0105b4f:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f0105b52:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105b57:	e9 67 f7 ff ff       	jmp    f01052c3 <syscall+0x52>
			ret = -E_INVAL;
f0105b5c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105b61:	e9 5d f7 ff ff       	jmp    f01052c3 <syscall+0x52>
        return E_INVAL;
f0105b66:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105b6b:	e9 53 f7 ff ff       	jmp    f01052c3 <syscall+0x52>

f0105b70 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105b70:	55                   	push   %ebp
f0105b71:	89 e5                	mov    %esp,%ebp
f0105b73:	57                   	push   %edi
f0105b74:	56                   	push   %esi
f0105b75:	53                   	push   %ebx
f0105b76:	83 ec 14             	sub    $0x14,%esp
f0105b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105b7c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105b7f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105b82:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105b85:	8b 1a                	mov    (%edx),%ebx
f0105b87:	8b 01                	mov    (%ecx),%eax
f0105b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105b8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105b93:	eb 23                	jmp    f0105bb8 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105b95:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105b98:	eb 1e                	jmp    f0105bb8 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105b9a:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105b9d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105ba0:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105ba4:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105ba7:	73 41                	jae    f0105bea <stab_binsearch+0x7a>
			*region_left = m;
f0105ba9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105bac:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0105bae:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0105bb1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0105bb8:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0105bbb:	7f 5a                	jg     f0105c17 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0105bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105bc0:	01 d8                	add    %ebx,%eax
f0105bc2:	89 c7                	mov    %eax,%edi
f0105bc4:	c1 ef 1f             	shr    $0x1f,%edi
f0105bc7:	01 c7                	add    %eax,%edi
f0105bc9:	d1 ff                	sar    %edi
f0105bcb:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105bce:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105bd1:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0105bd5:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0105bd7:	39 c3                	cmp    %eax,%ebx
f0105bd9:	7f ba                	jg     f0105b95 <stab_binsearch+0x25>
f0105bdb:	0f b6 0a             	movzbl (%edx),%ecx
f0105bde:	83 ea 0c             	sub    $0xc,%edx
f0105be1:	39 f1                	cmp    %esi,%ecx
f0105be3:	74 b5                	je     f0105b9a <stab_binsearch+0x2a>
			m--;
f0105be5:	83 e8 01             	sub    $0x1,%eax
f0105be8:	eb ed                	jmp    f0105bd7 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0105bea:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105bed:	76 14                	jbe    f0105c03 <stab_binsearch+0x93>
			*region_right = m - 1;
f0105bef:	83 e8 01             	sub    $0x1,%eax
f0105bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105bf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105bf8:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0105bfa:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105c01:	eb b5                	jmp    f0105bb8 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105c03:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105c06:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0105c08:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105c0c:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0105c0e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105c15:	eb a1                	jmp    f0105bb8 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105c17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105c1b:	75 15                	jne    f0105c32 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0105c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105c20:	8b 00                	mov    (%eax),%eax
f0105c22:	83 e8 01             	sub    $0x1,%eax
f0105c25:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105c28:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105c2a:	83 c4 14             	add    $0x14,%esp
f0105c2d:	5b                   	pop    %ebx
f0105c2e:	5e                   	pop    %esi
f0105c2f:	5f                   	pop    %edi
f0105c30:	5d                   	pop    %ebp
f0105c31:	c3                   	ret    
		for (l = *region_right;
f0105c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105c35:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105c37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105c3a:	8b 0f                	mov    (%edi),%ecx
f0105c3c:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105c3f:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0105c42:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105c46:	eb 03                	jmp    f0105c4b <stab_binsearch+0xdb>
		     l--)
f0105c48:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105c4b:	39 c1                	cmp    %eax,%ecx
f0105c4d:	7d 0a                	jge    f0105c59 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0105c4f:	0f b6 1a             	movzbl (%edx),%ebx
f0105c52:	83 ea 0c             	sub    $0xc,%edx
f0105c55:	39 f3                	cmp    %esi,%ebx
f0105c57:	75 ef                	jne    f0105c48 <stab_binsearch+0xd8>
		*region_left = l;
f0105c59:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105c5c:	89 06                	mov    %eax,(%esi)
}
f0105c5e:	eb ca                	jmp    f0105c2a <stab_binsearch+0xba>

f0105c60 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105c60:	55                   	push   %ebp
f0105c61:	89 e5                	mov    %esp,%ebp
f0105c63:	57                   	push   %edi
f0105c64:	56                   	push   %esi
f0105c65:	53                   	push   %ebx
f0105c66:	83 ec 4c             	sub    $0x4c,%esp
f0105c69:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105c6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105c6f:	c7 03 4c a1 10 f0    	movl   $0xf010a14c,(%ebx)
	info->eip_line = 0;
f0105c75:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105c7c:	c7 43 08 4c a1 10 f0 	movl   $0xf010a14c,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105c83:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105c8a:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105c8d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105c94:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0105c9a:	0f 86 23 01 00 00    	jbe    f0105dc3 <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105ca0:	c7 45 b8 82 03 12 f0 	movl   $0xf0120382,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0105ca7:	c7 45 b4 b9 b4 11 f0 	movl   $0xf011b4b9,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0105cae:	be b8 b4 11 f0       	mov    $0xf011b4b8,%esi
		stabs = __STAB_BEGIN__;
f0105cb3:	c7 45 bc 54 aa 10 f0 	movl   $0xf010aa54,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105cba:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105cbd:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f0105cc0:	0f 83 59 02 00 00    	jae    f0105f1f <debuginfo_eip+0x2bf>
f0105cc6:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0105cca:	0f 85 56 02 00 00    	jne    f0105f26 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105cd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105cd7:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0105cda:	c1 fe 02             	sar    $0x2,%esi
f0105cdd:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0105ce3:	83 e8 01             	sub    $0x1,%eax
f0105ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105ce9:	83 ec 08             	sub    $0x8,%esp
f0105cec:	57                   	push   %edi
f0105ced:	6a 64                	push   $0x64
f0105cef:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0105cf2:	89 d1                	mov    %edx,%ecx
f0105cf4:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105cf7:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105cfa:	89 f0                	mov    %esi,%eax
f0105cfc:	e8 6f fe ff ff       	call   f0105b70 <stab_binsearch>
	if (lfile == 0)
f0105d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105d04:	83 c4 10             	add    $0x10,%esp
f0105d07:	85 c0                	test   %eax,%eax
f0105d09:	0f 84 1e 02 00 00    	je     f0105f2d <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105d0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d15:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105d18:	83 ec 08             	sub    $0x8,%esp
f0105d1b:	57                   	push   %edi
f0105d1c:	6a 24                	push   $0x24
f0105d1e:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105d21:	89 d1                	mov    %edx,%ecx
f0105d23:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105d26:	89 f0                	mov    %esi,%eax
f0105d28:	e8 43 fe ff ff       	call   f0105b70 <stab_binsearch>

	if (lfun <= rfun) {
f0105d2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105d30:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105d33:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105d36:	83 c4 10             	add    $0x10,%esp
f0105d39:	39 c8                	cmp    %ecx,%eax
f0105d3b:	0f 8f 26 01 00 00    	jg     f0105e67 <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105d41:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105d44:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f0105d47:	8b 11                	mov    (%ecx),%edx
f0105d49:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0105d4c:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105d4f:	39 f2                	cmp    %esi,%edx
f0105d51:	73 06                	jae    f0105d59 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105d53:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105d56:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105d59:	8b 51 08             	mov    0x8(%ecx),%edx
f0105d5c:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105d5f:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105d61:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105d64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105d67:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105d6a:	83 ec 08             	sub    $0x8,%esp
f0105d6d:	6a 3a                	push   $0x3a
f0105d6f:	ff 73 08             	pushl  0x8(%ebx)
f0105d72:	e8 34 0b 00 00       	call   f01068ab <strfind>
f0105d77:	2b 43 08             	sub    0x8(%ebx),%eax
f0105d7a:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105d7d:	83 c4 08             	add    $0x8,%esp
f0105d80:	57                   	push   %edi
f0105d81:	6a 44                	push   $0x44
f0105d83:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105d86:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105d89:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105d8c:	89 f0                	mov    %esi,%eax
f0105d8e:	e8 dd fd ff ff       	call   f0105b70 <stab_binsearch>
	if(lline <= rline){
f0105d93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105d96:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105d99:	83 c4 10             	add    $0x10,%esp
f0105d9c:	39 c2                	cmp    %eax,%edx
f0105d9e:	0f 8f 90 01 00 00    	jg     f0105f34 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f0105da4:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105da7:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105dab:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105dae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105db1:	89 d0                	mov    %edx,%eax
f0105db3:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105db6:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105dba:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0105dbe:	e9 c2 00 00 00       	jmp    f0105e85 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f0105dc3:	e8 4f b7 01 00       	call   f0121517 <cpunum>
f0105dc8:	6a 06                	push   $0x6
f0105dca:	6a 10                	push   $0x10
f0105dcc:	68 00 00 20 00       	push   $0x200000
f0105dd1:	6b c0 74             	imul   $0x74,%eax,%eax
f0105dd4:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105dda:	e8 87 d6 ff ff       	call   f0103466 <user_mem_check>
f0105ddf:	83 c4 10             	add    $0x10,%esp
f0105de2:	85 c0                	test   %eax,%eax
f0105de4:	0f 88 27 01 00 00    	js     f0105f11 <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f0105dea:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105df0:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105df3:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105df9:	a1 08 00 20 00       	mov    0x200008,%eax
f0105dfe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105e01:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105e07:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f0105e0a:	e8 08 b7 01 00       	call   f0121517 <cpunum>
f0105e0f:	6a 06                	push   $0x6
f0105e11:	89 f2                	mov    %esi,%edx
f0105e13:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105e16:	29 ca                	sub    %ecx,%edx
f0105e18:	52                   	push   %edx
f0105e19:	51                   	push   %ecx
f0105e1a:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e1d:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105e23:	e8 3e d6 ff ff       	call   f0103466 <user_mem_check>
f0105e28:	83 c4 10             	add    $0x10,%esp
f0105e2b:	85 c0                	test   %eax,%eax
f0105e2d:	0f 88 e5 00 00 00    	js     f0105f18 <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105e33:	e8 df b6 01 00       	call   f0121517 <cpunum>
f0105e38:	6a 06                	push   $0x6
f0105e3a:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105e3d:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105e40:	29 ca                	sub    %ecx,%edx
f0105e42:	52                   	push   %edx
f0105e43:	51                   	push   %ecx
f0105e44:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e47:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105e4d:	e8 14 d6 ff ff       	call   f0103466 <user_mem_check>
f0105e52:	83 c4 10             	add    $0x10,%esp
f0105e55:	85 c0                	test   %eax,%eax
f0105e57:	0f 89 5d fe ff ff    	jns    f0105cba <debuginfo_eip+0x5a>
			return -1;
f0105e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e62:	e9 d9 00 00 00       	jmp    f0105f40 <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105e67:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e73:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105e76:	e9 ef fe ff ff       	jmp    f0105d6a <debuginfo_eip+0x10a>
f0105e7b:	83 e8 01             	sub    $0x1,%eax
f0105e7e:	83 ea 0c             	sub    $0xc,%edx
f0105e81:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105e85:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105e88:	39 c7                	cmp    %eax,%edi
f0105e8a:	7f 45                	jg     f0105ed1 <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f0105e8c:	0f b6 0a             	movzbl (%edx),%ecx
f0105e8f:	80 f9 84             	cmp    $0x84,%cl
f0105e92:	74 19                	je     f0105ead <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105e94:	80 f9 64             	cmp    $0x64,%cl
f0105e97:	75 e2                	jne    f0105e7b <debuginfo_eip+0x21b>
f0105e99:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105e9d:	74 dc                	je     f0105e7b <debuginfo_eip+0x21b>
f0105e9f:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105ea3:	74 11                	je     f0105eb6 <debuginfo_eip+0x256>
f0105ea5:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105ea8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105eab:	eb 09                	jmp    f0105eb6 <debuginfo_eip+0x256>
f0105ead:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105eb1:	74 03                	je     f0105eb6 <debuginfo_eip+0x256>
f0105eb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105eb6:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105eb9:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105ebc:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105ebf:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105ec2:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105ec5:	29 f8                	sub    %edi,%eax
f0105ec7:	39 c2                	cmp    %eax,%edx
f0105ec9:	73 06                	jae    f0105ed1 <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105ecb:	89 f8                	mov    %edi,%eax
f0105ecd:	01 d0                	add    %edx,%eax
f0105ecf:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105ed1:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105ed4:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f0105ed7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105edc:	39 f2                	cmp    %esi,%edx
f0105ede:	7d 60                	jge    f0105f40 <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0105ee0:	83 c2 01             	add    $0x1,%edx
f0105ee3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105ee6:	89 d0                	mov    %edx,%eax
f0105ee8:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105eeb:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105eee:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105ef2:	eb 04                	jmp    f0105ef8 <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f0105ef4:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105ef8:	39 c6                	cmp    %eax,%esi
f0105efa:	7e 3f                	jle    f0105f3b <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105efc:	0f b6 0a             	movzbl (%edx),%ecx
f0105eff:	83 c0 01             	add    $0x1,%eax
f0105f02:	83 c2 0c             	add    $0xc,%edx
f0105f05:	80 f9 a0             	cmp    $0xa0,%cl
f0105f08:	74 ea                	je     f0105ef4 <debuginfo_eip+0x294>
	return 0;
f0105f0a:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f0f:	eb 2f                	jmp    f0105f40 <debuginfo_eip+0x2e0>
			return -1;
f0105f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f16:	eb 28                	jmp    f0105f40 <debuginfo_eip+0x2e0>
			return -1;
f0105f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f1d:	eb 21                	jmp    f0105f40 <debuginfo_eip+0x2e0>
		return -1;
f0105f1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f24:	eb 1a                	jmp    f0105f40 <debuginfo_eip+0x2e0>
f0105f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f2b:	eb 13                	jmp    f0105f40 <debuginfo_eip+0x2e0>
		return -1;
f0105f2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f32:	eb 0c                	jmp    f0105f40 <debuginfo_eip+0x2e0>
		return -1;
f0105f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f39:	eb 05                	jmp    f0105f40 <debuginfo_eip+0x2e0>
	return 0;
f0105f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105f43:	5b                   	pop    %ebx
f0105f44:	5e                   	pop    %esi
f0105f45:	5f                   	pop    %edi
f0105f46:	5d                   	pop    %ebp
f0105f47:	c3                   	ret    

f0105f48 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105f48:	55                   	push   %ebp
f0105f49:	89 e5                	mov    %esp,%ebp
f0105f4b:	57                   	push   %edi
f0105f4c:	56                   	push   %esi
f0105f4d:	53                   	push   %ebx
f0105f4e:	83 ec 1c             	sub    $0x1c,%esp
f0105f51:	89 c6                	mov    %eax,%esi
f0105f53:	89 d7                	mov    %edx,%edi
f0105f55:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f58:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105f5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105f5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105f61:	8b 45 10             	mov    0x10(%ebp),%eax
f0105f64:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105f67:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105f6b:	74 2c                	je     f0105f99 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f0105f6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f70:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105f77:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105f7a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105f7d:	39 c2                	cmp    %eax,%edx
f0105f7f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105f82:	73 43                	jae    f0105fc7 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105f84:	83 eb 01             	sub    $0x1,%ebx
f0105f87:	85 db                	test   %ebx,%ebx
f0105f89:	7e 6c                	jle    f0105ff7 <printnum+0xaf>
				putch(padc, putdat);
f0105f8b:	83 ec 08             	sub    $0x8,%esp
f0105f8e:	57                   	push   %edi
f0105f8f:	ff 75 18             	pushl  0x18(%ebp)
f0105f92:	ff d6                	call   *%esi
f0105f94:	83 c4 10             	add    $0x10,%esp
f0105f97:	eb eb                	jmp    f0105f84 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105f99:	83 ec 0c             	sub    $0xc,%esp
f0105f9c:	6a 20                	push   $0x20
f0105f9e:	6a 00                	push   $0x0
f0105fa0:	50                   	push   %eax
f0105fa1:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105fa4:	ff 75 e0             	pushl  -0x20(%ebp)
f0105fa7:	89 fa                	mov    %edi,%edx
f0105fa9:	89 f0                	mov    %esi,%eax
f0105fab:	e8 98 ff ff ff       	call   f0105f48 <printnum>
		while (--width > 0)
f0105fb0:	83 c4 20             	add    $0x20,%esp
f0105fb3:	83 eb 01             	sub    $0x1,%ebx
f0105fb6:	85 db                	test   %ebx,%ebx
f0105fb8:	7e 65                	jle    f010601f <printnum+0xd7>
			putch(padc, putdat);
f0105fba:	83 ec 08             	sub    $0x8,%esp
f0105fbd:	57                   	push   %edi
f0105fbe:	6a 20                	push   $0x20
f0105fc0:	ff d6                	call   *%esi
f0105fc2:	83 c4 10             	add    $0x10,%esp
f0105fc5:	eb ec                	jmp    f0105fb3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f0105fc7:	83 ec 0c             	sub    $0xc,%esp
f0105fca:	ff 75 18             	pushl  0x18(%ebp)
f0105fcd:	83 eb 01             	sub    $0x1,%ebx
f0105fd0:	53                   	push   %ebx
f0105fd1:	50                   	push   %eax
f0105fd2:	83 ec 08             	sub    $0x8,%esp
f0105fd5:	ff 75 dc             	pushl  -0x24(%ebp)
f0105fd8:	ff 75 d8             	pushl  -0x28(%ebp)
f0105fdb:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105fde:	ff 75 e0             	pushl  -0x20(%ebp)
f0105fe1:	e8 da 1d 00 00       	call   f0107dc0 <__udivdi3>
f0105fe6:	83 c4 18             	add    $0x18,%esp
f0105fe9:	52                   	push   %edx
f0105fea:	50                   	push   %eax
f0105feb:	89 fa                	mov    %edi,%edx
f0105fed:	89 f0                	mov    %esi,%eax
f0105fef:	e8 54 ff ff ff       	call   f0105f48 <printnum>
f0105ff4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f0105ff7:	83 ec 08             	sub    $0x8,%esp
f0105ffa:	57                   	push   %edi
f0105ffb:	83 ec 04             	sub    $0x4,%esp
f0105ffe:	ff 75 dc             	pushl  -0x24(%ebp)
f0106001:	ff 75 d8             	pushl  -0x28(%ebp)
f0106004:	ff 75 e4             	pushl  -0x1c(%ebp)
f0106007:	ff 75 e0             	pushl  -0x20(%ebp)
f010600a:	e8 c1 1e 00 00       	call   f0107ed0 <__umoddi3>
f010600f:	83 c4 14             	add    $0x14,%esp
f0106012:	0f be 80 56 a1 10 f0 	movsbl -0xfef5eaa(%eax),%eax
f0106019:	50                   	push   %eax
f010601a:	ff d6                	call   *%esi
f010601c:	83 c4 10             	add    $0x10,%esp
	}
}
f010601f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106022:	5b                   	pop    %ebx
f0106023:	5e                   	pop    %esi
f0106024:	5f                   	pop    %edi
f0106025:	5d                   	pop    %ebp
f0106026:	c3                   	ret    

f0106027 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0106027:	55                   	push   %ebp
f0106028:	89 e5                	mov    %esp,%ebp
f010602a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010602d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0106031:	8b 10                	mov    (%eax),%edx
f0106033:	3b 50 04             	cmp    0x4(%eax),%edx
f0106036:	73 0a                	jae    f0106042 <sprintputch+0x1b>
		*b->buf++ = ch;
f0106038:	8d 4a 01             	lea    0x1(%edx),%ecx
f010603b:	89 08                	mov    %ecx,(%eax)
f010603d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106040:	88 02                	mov    %al,(%edx)
}
f0106042:	5d                   	pop    %ebp
f0106043:	c3                   	ret    

f0106044 <printfmt>:
{
f0106044:	55                   	push   %ebp
f0106045:	89 e5                	mov    %esp,%ebp
f0106047:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f010604a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010604d:	50                   	push   %eax
f010604e:	ff 75 10             	pushl  0x10(%ebp)
f0106051:	ff 75 0c             	pushl  0xc(%ebp)
f0106054:	ff 75 08             	pushl  0x8(%ebp)
f0106057:	e8 05 00 00 00       	call   f0106061 <vprintfmt>
}
f010605c:	83 c4 10             	add    $0x10,%esp
f010605f:	c9                   	leave  
f0106060:	c3                   	ret    

f0106061 <vprintfmt>:
{
f0106061:	55                   	push   %ebp
f0106062:	89 e5                	mov    %esp,%ebp
f0106064:	57                   	push   %edi
f0106065:	56                   	push   %esi
f0106066:	53                   	push   %ebx
f0106067:	83 ec 3c             	sub    $0x3c,%esp
f010606a:	8b 75 08             	mov    0x8(%ebp),%esi
f010606d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106070:	8b 7d 10             	mov    0x10(%ebp),%edi
f0106073:	e9 32 04 00 00       	jmp    f01064aa <vprintfmt+0x449>
		padc = ' ';
f0106078:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f010607c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f0106083:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f010608a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0106091:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0106098:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f010609f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01060a4:	8d 47 01             	lea    0x1(%edi),%eax
f01060a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01060aa:	0f b6 17             	movzbl (%edi),%edx
f01060ad:	8d 42 dd             	lea    -0x23(%edx),%eax
f01060b0:	3c 55                	cmp    $0x55,%al
f01060b2:	0f 87 12 05 00 00    	ja     f01065ca <vprintfmt+0x569>
f01060b8:	0f b6 c0             	movzbl %al,%eax
f01060bb:	ff 24 85 40 a3 10 f0 	jmp    *-0xfef5cc0(,%eax,4)
f01060c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01060c5:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f01060c9:	eb d9                	jmp    f01060a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f01060cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f01060ce:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f01060d2:	eb d0                	jmp    f01060a4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f01060d4:	0f b6 d2             	movzbl %dl,%edx
f01060d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01060da:	b8 00 00 00 00       	mov    $0x0,%eax
f01060df:	89 75 08             	mov    %esi,0x8(%ebp)
f01060e2:	eb 03                	jmp    f01060e7 <vprintfmt+0x86>
f01060e4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01060e7:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01060ea:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01060ee:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01060f1:	8d 72 d0             	lea    -0x30(%edx),%esi
f01060f4:	83 fe 09             	cmp    $0x9,%esi
f01060f7:	76 eb                	jbe    f01060e4 <vprintfmt+0x83>
f01060f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060fc:	8b 75 08             	mov    0x8(%ebp),%esi
f01060ff:	eb 14                	jmp    f0106115 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0106101:	8b 45 14             	mov    0x14(%ebp),%eax
f0106104:	8b 00                	mov    (%eax),%eax
f0106106:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106109:	8b 45 14             	mov    0x14(%ebp),%eax
f010610c:	8d 40 04             	lea    0x4(%eax),%eax
f010610f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106112:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0106115:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0106119:	79 89                	jns    f01060a4 <vprintfmt+0x43>
				width = precision, precision = -1;
f010611b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010611e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106121:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0106128:	e9 77 ff ff ff       	jmp    f01060a4 <vprintfmt+0x43>
f010612d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106130:	85 c0                	test   %eax,%eax
f0106132:	0f 48 c1             	cmovs  %ecx,%eax
f0106135:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106138:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010613b:	e9 64 ff ff ff       	jmp    f01060a4 <vprintfmt+0x43>
f0106140:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0106143:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f010614a:	e9 55 ff ff ff       	jmp    f01060a4 <vprintfmt+0x43>
			lflag++;
f010614f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106153:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0106156:	e9 49 ff ff ff       	jmp    f01060a4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f010615b:	8b 45 14             	mov    0x14(%ebp),%eax
f010615e:	8d 78 04             	lea    0x4(%eax),%edi
f0106161:	83 ec 08             	sub    $0x8,%esp
f0106164:	53                   	push   %ebx
f0106165:	ff 30                	pushl  (%eax)
f0106167:	ff d6                	call   *%esi
			break;
f0106169:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010616c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f010616f:	e9 33 03 00 00       	jmp    f01064a7 <vprintfmt+0x446>
			err = va_arg(ap, int);
f0106174:	8b 45 14             	mov    0x14(%ebp),%eax
f0106177:	8d 78 04             	lea    0x4(%eax),%edi
f010617a:	8b 00                	mov    (%eax),%eax
f010617c:	99                   	cltd   
f010617d:	31 d0                	xor    %edx,%eax
f010617f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0106181:	83 f8 11             	cmp    $0x11,%eax
f0106184:	7f 23                	jg     f01061a9 <vprintfmt+0x148>
f0106186:	8b 14 85 a0 a4 10 f0 	mov    -0xfef5b60(,%eax,4),%edx
f010618d:	85 d2                	test   %edx,%edx
f010618f:	74 18                	je     f01061a9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f0106191:	52                   	push   %edx
f0106192:	68 bd 92 10 f0       	push   $0xf01092bd
f0106197:	53                   	push   %ebx
f0106198:	56                   	push   %esi
f0106199:	e8 a6 fe ff ff       	call   f0106044 <printfmt>
f010619e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01061a1:	89 7d 14             	mov    %edi,0x14(%ebp)
f01061a4:	e9 fe 02 00 00       	jmp    f01064a7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f01061a9:	50                   	push   %eax
f01061aa:	68 6e a1 10 f0       	push   $0xf010a16e
f01061af:	53                   	push   %ebx
f01061b0:	56                   	push   %esi
f01061b1:	e8 8e fe ff ff       	call   f0106044 <printfmt>
f01061b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01061b9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01061bc:	e9 e6 02 00 00       	jmp    f01064a7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f01061c1:	8b 45 14             	mov    0x14(%ebp),%eax
f01061c4:	83 c0 04             	add    $0x4,%eax
f01061c7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01061ca:	8b 45 14             	mov    0x14(%ebp),%eax
f01061cd:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f01061cf:	85 c9                	test   %ecx,%ecx
f01061d1:	b8 67 a1 10 f0       	mov    $0xf010a167,%eax
f01061d6:	0f 45 c1             	cmovne %ecx,%eax
f01061d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f01061dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01061e0:	7e 06                	jle    f01061e8 <vprintfmt+0x187>
f01061e2:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f01061e6:	75 0d                	jne    f01061f5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f01061e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01061eb:	89 c7                	mov    %eax,%edi
f01061ed:	03 45 e0             	add    -0x20(%ebp),%eax
f01061f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01061f3:	eb 53                	jmp    f0106248 <vprintfmt+0x1e7>
f01061f5:	83 ec 08             	sub    $0x8,%esp
f01061f8:	ff 75 d8             	pushl  -0x28(%ebp)
f01061fb:	50                   	push   %eax
f01061fc:	e8 5f 05 00 00       	call   f0106760 <strnlen>
f0106201:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106204:	29 c1                	sub    %eax,%ecx
f0106206:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0106209:	83 c4 10             	add    $0x10,%esp
f010620c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f010620e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0106212:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0106215:	eb 0f                	jmp    f0106226 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0106217:	83 ec 08             	sub    $0x8,%esp
f010621a:	53                   	push   %ebx
f010621b:	ff 75 e0             	pushl  -0x20(%ebp)
f010621e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0106220:	83 ef 01             	sub    $0x1,%edi
f0106223:	83 c4 10             	add    $0x10,%esp
f0106226:	85 ff                	test   %edi,%edi
f0106228:	7f ed                	jg     f0106217 <vprintfmt+0x1b6>
f010622a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f010622d:	85 c9                	test   %ecx,%ecx
f010622f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106234:	0f 49 c1             	cmovns %ecx,%eax
f0106237:	29 c1                	sub    %eax,%ecx
f0106239:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f010623c:	eb aa                	jmp    f01061e8 <vprintfmt+0x187>
					putch(ch, putdat);
f010623e:	83 ec 08             	sub    $0x8,%esp
f0106241:	53                   	push   %ebx
f0106242:	52                   	push   %edx
f0106243:	ff d6                	call   *%esi
f0106245:	83 c4 10             	add    $0x10,%esp
f0106248:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010624b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010624d:	83 c7 01             	add    $0x1,%edi
f0106250:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0106254:	0f be d0             	movsbl %al,%edx
f0106257:	85 d2                	test   %edx,%edx
f0106259:	74 4b                	je     f01062a6 <vprintfmt+0x245>
f010625b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010625f:	78 06                	js     f0106267 <vprintfmt+0x206>
f0106261:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0106265:	78 1e                	js     f0106285 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f0106267:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f010626b:	74 d1                	je     f010623e <vprintfmt+0x1dd>
f010626d:	0f be c0             	movsbl %al,%eax
f0106270:	83 e8 20             	sub    $0x20,%eax
f0106273:	83 f8 5e             	cmp    $0x5e,%eax
f0106276:	76 c6                	jbe    f010623e <vprintfmt+0x1dd>
					putch('?', putdat);
f0106278:	83 ec 08             	sub    $0x8,%esp
f010627b:	53                   	push   %ebx
f010627c:	6a 3f                	push   $0x3f
f010627e:	ff d6                	call   *%esi
f0106280:	83 c4 10             	add    $0x10,%esp
f0106283:	eb c3                	jmp    f0106248 <vprintfmt+0x1e7>
f0106285:	89 cf                	mov    %ecx,%edi
f0106287:	eb 0e                	jmp    f0106297 <vprintfmt+0x236>
				putch(' ', putdat);
f0106289:	83 ec 08             	sub    $0x8,%esp
f010628c:	53                   	push   %ebx
f010628d:	6a 20                	push   $0x20
f010628f:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0106291:	83 ef 01             	sub    $0x1,%edi
f0106294:	83 c4 10             	add    $0x10,%esp
f0106297:	85 ff                	test   %edi,%edi
f0106299:	7f ee                	jg     f0106289 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f010629b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f010629e:	89 45 14             	mov    %eax,0x14(%ebp)
f01062a1:	e9 01 02 00 00       	jmp    f01064a7 <vprintfmt+0x446>
f01062a6:	89 cf                	mov    %ecx,%edi
f01062a8:	eb ed                	jmp    f0106297 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f01062aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f01062ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f01062b4:	e9 eb fd ff ff       	jmp    f01060a4 <vprintfmt+0x43>
	if (lflag >= 2)
f01062b9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01062bd:	7f 21                	jg     f01062e0 <vprintfmt+0x27f>
	else if (lflag)
f01062bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01062c3:	74 68                	je     f010632d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f01062c5:	8b 45 14             	mov    0x14(%ebp),%eax
f01062c8:	8b 00                	mov    (%eax),%eax
f01062ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01062cd:	89 c1                	mov    %eax,%ecx
f01062cf:	c1 f9 1f             	sar    $0x1f,%ecx
f01062d2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f01062d5:	8b 45 14             	mov    0x14(%ebp),%eax
f01062d8:	8d 40 04             	lea    0x4(%eax),%eax
f01062db:	89 45 14             	mov    %eax,0x14(%ebp)
f01062de:	eb 17                	jmp    f01062f7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
f01062e0:	8b 45 14             	mov    0x14(%ebp),%eax
f01062e3:	8b 50 04             	mov    0x4(%eax),%edx
f01062e6:	8b 00                	mov    (%eax),%eax
f01062e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01062eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f01062ee:	8b 45 14             	mov    0x14(%ebp),%eax
f01062f1:	8d 40 08             	lea    0x8(%eax),%eax
f01062f4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f01062f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01062fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01062fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106300:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f0106303:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106307:	78 3f                	js     f0106348 <vprintfmt+0x2e7>
			base = 10;
f0106309:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f010630e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f0106312:	0f 84 71 01 00 00    	je     f0106489 <vprintfmt+0x428>
				putch('+', putdat);
f0106318:	83 ec 08             	sub    $0x8,%esp
f010631b:	53                   	push   %ebx
f010631c:	6a 2b                	push   $0x2b
f010631e:	ff d6                	call   *%esi
f0106320:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0106323:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106328:	e9 5c 01 00 00       	jmp    f0106489 <vprintfmt+0x428>
		return va_arg(*ap, int);
f010632d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106330:	8b 00                	mov    (%eax),%eax
f0106332:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106335:	89 c1                	mov    %eax,%ecx
f0106337:	c1 f9 1f             	sar    $0x1f,%ecx
f010633a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f010633d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106340:	8d 40 04             	lea    0x4(%eax),%eax
f0106343:	89 45 14             	mov    %eax,0x14(%ebp)
f0106346:	eb af                	jmp    f01062f7 <vprintfmt+0x296>
				putch('-', putdat);
f0106348:	83 ec 08             	sub    $0x8,%esp
f010634b:	53                   	push   %ebx
f010634c:	6a 2d                	push   $0x2d
f010634e:	ff d6                	call   *%esi
				num = -(long long) num;
f0106350:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106353:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106356:	f7 d8                	neg    %eax
f0106358:	83 d2 00             	adc    $0x0,%edx
f010635b:	f7 da                	neg    %edx
f010635d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106360:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106363:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0106366:	b8 0a 00 00 00       	mov    $0xa,%eax
f010636b:	e9 19 01 00 00       	jmp    f0106489 <vprintfmt+0x428>
	if (lflag >= 2)
f0106370:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0106374:	7f 29                	jg     f010639f <vprintfmt+0x33e>
	else if (lflag)
f0106376:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f010637a:	74 44                	je     f01063c0 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f010637c:	8b 45 14             	mov    0x14(%ebp),%eax
f010637f:	8b 00                	mov    (%eax),%eax
f0106381:	ba 00 00 00 00       	mov    $0x0,%edx
f0106386:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106389:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010638c:	8b 45 14             	mov    0x14(%ebp),%eax
f010638f:	8d 40 04             	lea    0x4(%eax),%eax
f0106392:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106395:	b8 0a 00 00 00       	mov    $0xa,%eax
f010639a:	e9 ea 00 00 00       	jmp    f0106489 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f010639f:	8b 45 14             	mov    0x14(%ebp),%eax
f01063a2:	8b 50 04             	mov    0x4(%eax),%edx
f01063a5:	8b 00                	mov    (%eax),%eax
f01063a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01063aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01063ad:	8b 45 14             	mov    0x14(%ebp),%eax
f01063b0:	8d 40 08             	lea    0x8(%eax),%eax
f01063b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01063b6:	b8 0a 00 00 00       	mov    $0xa,%eax
f01063bb:	e9 c9 00 00 00       	jmp    f0106489 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f01063c0:	8b 45 14             	mov    0x14(%ebp),%eax
f01063c3:	8b 00                	mov    (%eax),%eax
f01063c5:	ba 00 00 00 00       	mov    $0x0,%edx
f01063ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01063cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01063d0:	8b 45 14             	mov    0x14(%ebp),%eax
f01063d3:	8d 40 04             	lea    0x4(%eax),%eax
f01063d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01063d9:	b8 0a 00 00 00       	mov    $0xa,%eax
f01063de:	e9 a6 00 00 00       	jmp    f0106489 <vprintfmt+0x428>
			putch('0', putdat);
f01063e3:	83 ec 08             	sub    $0x8,%esp
f01063e6:	53                   	push   %ebx
f01063e7:	6a 30                	push   $0x30
f01063e9:	ff d6                	call   *%esi
	if (lflag >= 2)
f01063eb:	83 c4 10             	add    $0x10,%esp
f01063ee:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01063f2:	7f 26                	jg     f010641a <vprintfmt+0x3b9>
	else if (lflag)
f01063f4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01063f8:	74 3e                	je     f0106438 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f01063fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01063fd:	8b 00                	mov    (%eax),%eax
f01063ff:	ba 00 00 00 00       	mov    $0x0,%edx
f0106404:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106407:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010640a:	8b 45 14             	mov    0x14(%ebp),%eax
f010640d:	8d 40 04             	lea    0x4(%eax),%eax
f0106410:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106413:	b8 08 00 00 00       	mov    $0x8,%eax
f0106418:	eb 6f                	jmp    f0106489 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f010641a:	8b 45 14             	mov    0x14(%ebp),%eax
f010641d:	8b 50 04             	mov    0x4(%eax),%edx
f0106420:	8b 00                	mov    (%eax),%eax
f0106422:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106425:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106428:	8b 45 14             	mov    0x14(%ebp),%eax
f010642b:	8d 40 08             	lea    0x8(%eax),%eax
f010642e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106431:	b8 08 00 00 00       	mov    $0x8,%eax
f0106436:	eb 51                	jmp    f0106489 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106438:	8b 45 14             	mov    0x14(%ebp),%eax
f010643b:	8b 00                	mov    (%eax),%eax
f010643d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106442:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106445:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106448:	8b 45 14             	mov    0x14(%ebp),%eax
f010644b:	8d 40 04             	lea    0x4(%eax),%eax
f010644e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106451:	b8 08 00 00 00       	mov    $0x8,%eax
f0106456:	eb 31                	jmp    f0106489 <vprintfmt+0x428>
			putch('0', putdat);
f0106458:	83 ec 08             	sub    $0x8,%esp
f010645b:	53                   	push   %ebx
f010645c:	6a 30                	push   $0x30
f010645e:	ff d6                	call   *%esi
			putch('x', putdat);
f0106460:	83 c4 08             	add    $0x8,%esp
f0106463:	53                   	push   %ebx
f0106464:	6a 78                	push   $0x78
f0106466:	ff d6                	call   *%esi
			num = (unsigned long long)
f0106468:	8b 45 14             	mov    0x14(%ebp),%eax
f010646b:	8b 00                	mov    (%eax),%eax
f010646d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106472:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106475:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f0106478:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f010647b:	8b 45 14             	mov    0x14(%ebp),%eax
f010647e:	8d 40 04             	lea    0x4(%eax),%eax
f0106481:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106484:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0106489:	83 ec 0c             	sub    $0xc,%esp
f010648c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f0106490:	52                   	push   %edx
f0106491:	ff 75 e0             	pushl  -0x20(%ebp)
f0106494:	50                   	push   %eax
f0106495:	ff 75 dc             	pushl  -0x24(%ebp)
f0106498:	ff 75 d8             	pushl  -0x28(%ebp)
f010649b:	89 da                	mov    %ebx,%edx
f010649d:	89 f0                	mov    %esi,%eax
f010649f:	e8 a4 fa ff ff       	call   f0105f48 <printnum>
			break;
f01064a4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01064a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01064aa:	83 c7 01             	add    $0x1,%edi
f01064ad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01064b1:	83 f8 25             	cmp    $0x25,%eax
f01064b4:	0f 84 be fb ff ff    	je     f0106078 <vprintfmt+0x17>
			if (ch == '\0')
f01064ba:	85 c0                	test   %eax,%eax
f01064bc:	0f 84 28 01 00 00    	je     f01065ea <vprintfmt+0x589>
			putch(ch, putdat);
f01064c2:	83 ec 08             	sub    $0x8,%esp
f01064c5:	53                   	push   %ebx
f01064c6:	50                   	push   %eax
f01064c7:	ff d6                	call   *%esi
f01064c9:	83 c4 10             	add    $0x10,%esp
f01064cc:	eb dc                	jmp    f01064aa <vprintfmt+0x449>
	if (lflag >= 2)
f01064ce:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01064d2:	7f 26                	jg     f01064fa <vprintfmt+0x499>
	else if (lflag)
f01064d4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01064d8:	74 41                	je     f010651b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f01064da:	8b 45 14             	mov    0x14(%ebp),%eax
f01064dd:	8b 00                	mov    (%eax),%eax
f01064df:	ba 00 00 00 00       	mov    $0x0,%edx
f01064e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01064e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01064ea:	8b 45 14             	mov    0x14(%ebp),%eax
f01064ed:	8d 40 04             	lea    0x4(%eax),%eax
f01064f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01064f3:	b8 10 00 00 00       	mov    $0x10,%eax
f01064f8:	eb 8f                	jmp    f0106489 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01064fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01064fd:	8b 50 04             	mov    0x4(%eax),%edx
f0106500:	8b 00                	mov    (%eax),%eax
f0106502:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106505:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106508:	8b 45 14             	mov    0x14(%ebp),%eax
f010650b:	8d 40 08             	lea    0x8(%eax),%eax
f010650e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106511:	b8 10 00 00 00       	mov    $0x10,%eax
f0106516:	e9 6e ff ff ff       	jmp    f0106489 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f010651b:	8b 45 14             	mov    0x14(%ebp),%eax
f010651e:	8b 00                	mov    (%eax),%eax
f0106520:	ba 00 00 00 00       	mov    $0x0,%edx
f0106525:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106528:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010652b:	8b 45 14             	mov    0x14(%ebp),%eax
f010652e:	8d 40 04             	lea    0x4(%eax),%eax
f0106531:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106534:	b8 10 00 00 00       	mov    $0x10,%eax
f0106539:	e9 4b ff ff ff       	jmp    f0106489 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f010653e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106541:	83 c0 04             	add    $0x4,%eax
f0106544:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106547:	8b 45 14             	mov    0x14(%ebp),%eax
f010654a:	8b 00                	mov    (%eax),%eax
f010654c:	85 c0                	test   %eax,%eax
f010654e:	74 14                	je     f0106564 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f0106550:	8b 13                	mov    (%ebx),%edx
f0106552:	83 fa 7f             	cmp    $0x7f,%edx
f0106555:	7f 37                	jg     f010658e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f0106557:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f0106559:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010655c:	89 45 14             	mov    %eax,0x14(%ebp)
f010655f:	e9 43 ff ff ff       	jmp    f01064a7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f0106564:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106569:	bf 8d a2 10 f0       	mov    $0xf010a28d,%edi
							putch(ch, putdat);
f010656e:	83 ec 08             	sub    $0x8,%esp
f0106571:	53                   	push   %ebx
f0106572:	50                   	push   %eax
f0106573:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0106575:	83 c7 01             	add    $0x1,%edi
f0106578:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f010657c:	83 c4 10             	add    $0x10,%esp
f010657f:	85 c0                	test   %eax,%eax
f0106581:	75 eb                	jne    f010656e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f0106583:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106586:	89 45 14             	mov    %eax,0x14(%ebp)
f0106589:	e9 19 ff ff ff       	jmp    f01064a7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f010658e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f0106590:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106595:	bf c5 a2 10 f0       	mov    $0xf010a2c5,%edi
							putch(ch, putdat);
f010659a:	83 ec 08             	sub    $0x8,%esp
f010659d:	53                   	push   %ebx
f010659e:	50                   	push   %eax
f010659f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f01065a1:	83 c7 01             	add    $0x1,%edi
f01065a4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f01065a8:	83 c4 10             	add    $0x10,%esp
f01065ab:	85 c0                	test   %eax,%eax
f01065ad:	75 eb                	jne    f010659a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f01065af:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01065b2:	89 45 14             	mov    %eax,0x14(%ebp)
f01065b5:	e9 ed fe ff ff       	jmp    f01064a7 <vprintfmt+0x446>
			putch(ch, putdat);
f01065ba:	83 ec 08             	sub    $0x8,%esp
f01065bd:	53                   	push   %ebx
f01065be:	6a 25                	push   $0x25
f01065c0:	ff d6                	call   *%esi
			break;
f01065c2:	83 c4 10             	add    $0x10,%esp
f01065c5:	e9 dd fe ff ff       	jmp    f01064a7 <vprintfmt+0x446>
			putch('%', putdat);
f01065ca:	83 ec 08             	sub    $0x8,%esp
f01065cd:	53                   	push   %ebx
f01065ce:	6a 25                	push   $0x25
f01065d0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01065d2:	83 c4 10             	add    $0x10,%esp
f01065d5:	89 f8                	mov    %edi,%eax
f01065d7:	eb 03                	jmp    f01065dc <vprintfmt+0x57b>
f01065d9:	83 e8 01             	sub    $0x1,%eax
f01065dc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01065e0:	75 f7                	jne    f01065d9 <vprintfmt+0x578>
f01065e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01065e5:	e9 bd fe ff ff       	jmp    f01064a7 <vprintfmt+0x446>
}
f01065ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01065ed:	5b                   	pop    %ebx
f01065ee:	5e                   	pop    %esi
f01065ef:	5f                   	pop    %edi
f01065f0:	5d                   	pop    %ebp
f01065f1:	c3                   	ret    

f01065f2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01065f2:	55                   	push   %ebp
f01065f3:	89 e5                	mov    %esp,%ebp
f01065f5:	83 ec 18             	sub    $0x18,%esp
f01065f8:	8b 45 08             	mov    0x8(%ebp),%eax
f01065fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01065fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0106601:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106605:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0106608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010660f:	85 c0                	test   %eax,%eax
f0106611:	74 26                	je     f0106639 <vsnprintf+0x47>
f0106613:	85 d2                	test   %edx,%edx
f0106615:	7e 22                	jle    f0106639 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106617:	ff 75 14             	pushl  0x14(%ebp)
f010661a:	ff 75 10             	pushl  0x10(%ebp)
f010661d:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0106620:	50                   	push   %eax
f0106621:	68 27 60 10 f0       	push   $0xf0106027
f0106626:	e8 36 fa ff ff       	call   f0106061 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010662b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010662e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0106631:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106634:	83 c4 10             	add    $0x10,%esp
}
f0106637:	c9                   	leave  
f0106638:	c3                   	ret    
		return -E_INVAL;
f0106639:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010663e:	eb f7                	jmp    f0106637 <vsnprintf+0x45>

f0106640 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0106640:	55                   	push   %ebp
f0106641:	89 e5                	mov    %esp,%ebp
f0106643:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106646:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106649:	50                   	push   %eax
f010664a:	ff 75 10             	pushl  0x10(%ebp)
f010664d:	ff 75 0c             	pushl  0xc(%ebp)
f0106650:	ff 75 08             	pushl  0x8(%ebp)
f0106653:	e8 9a ff ff ff       	call   f01065f2 <vsnprintf>
	va_end(ap);

	return rc;
}
f0106658:	c9                   	leave  
f0106659:	c3                   	ret    

f010665a <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010665a:	55                   	push   %ebp
f010665b:	89 e5                	mov    %esp,%ebp
f010665d:	57                   	push   %edi
f010665e:	56                   	push   %esi
f010665f:	53                   	push   %ebx
f0106660:	83 ec 0c             	sub    $0xc,%esp
f0106663:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106666:	85 c0                	test   %eax,%eax
f0106668:	74 11                	je     f010667b <readline+0x21>
		cprintf("%s", prompt);
f010666a:	83 ec 08             	sub    $0x8,%esp
f010666d:	50                   	push   %eax
f010666e:	68 bd 92 10 f0       	push   $0xf01092bd
f0106673:	e8 ed db ff ff       	call   f0104265 <cprintf>
f0106678:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010667b:	83 ec 0c             	sub    $0xc,%esp
f010667e:	6a 00                	push   $0x0
f0106680:	e8 e3 a1 ff ff       	call   f0100868 <iscons>
f0106685:	89 c7                	mov    %eax,%edi
f0106687:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010668a:	be 00 00 00 00       	mov    $0x0,%esi
f010668f:	eb 57                	jmp    f01066e8 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0106691:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106696:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106699:	75 08                	jne    f01066a3 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010669b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010669e:	5b                   	pop    %ebx
f010669f:	5e                   	pop    %esi
f01066a0:	5f                   	pop    %edi
f01066a1:	5d                   	pop    %ebp
f01066a2:	c3                   	ret    
				cprintf("read error: %e\n", c);
f01066a3:	83 ec 08             	sub    $0x8,%esp
f01066a6:	53                   	push   %ebx
f01066a7:	68 e8 a4 10 f0       	push   $0xf010a4e8
f01066ac:	e8 b4 db ff ff       	call   f0104265 <cprintf>
f01066b1:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01066b4:	b8 00 00 00 00       	mov    $0x0,%eax
f01066b9:	eb e0                	jmp    f010669b <readline+0x41>
			if (echoing)
f01066bb:	85 ff                	test   %edi,%edi
f01066bd:	75 05                	jne    f01066c4 <readline+0x6a>
			i--;
f01066bf:	83 ee 01             	sub    $0x1,%esi
f01066c2:	eb 24                	jmp    f01066e8 <readline+0x8e>
				cputchar('\b');
f01066c4:	83 ec 0c             	sub    $0xc,%esp
f01066c7:	6a 08                	push   $0x8
f01066c9:	e8 79 a1 ff ff       	call   f0100847 <cputchar>
f01066ce:	83 c4 10             	add    $0x10,%esp
f01066d1:	eb ec                	jmp    f01066bf <readline+0x65>
				cputchar(c);
f01066d3:	83 ec 0c             	sub    $0xc,%esp
f01066d6:	53                   	push   %ebx
f01066d7:	e8 6b a1 ff ff       	call   f0100847 <cputchar>
f01066dc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01066df:	88 9e 60 d9 5d f0    	mov    %bl,-0xfa226a0(%esi)
f01066e5:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01066e8:	e8 6a a1 ff ff       	call   f0100857 <getchar>
f01066ed:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01066ef:	85 c0                	test   %eax,%eax
f01066f1:	78 9e                	js     f0106691 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01066f3:	83 f8 08             	cmp    $0x8,%eax
f01066f6:	0f 94 c2             	sete   %dl
f01066f9:	83 f8 7f             	cmp    $0x7f,%eax
f01066fc:	0f 94 c0             	sete   %al
f01066ff:	08 c2                	or     %al,%dl
f0106701:	74 04                	je     f0106707 <readline+0xad>
f0106703:	85 f6                	test   %esi,%esi
f0106705:	7f b4                	jg     f01066bb <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106707:	83 fb 1f             	cmp    $0x1f,%ebx
f010670a:	7e 0e                	jle    f010671a <readline+0xc0>
f010670c:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0106712:	7f 06                	jg     f010671a <readline+0xc0>
			if (echoing)
f0106714:	85 ff                	test   %edi,%edi
f0106716:	74 c7                	je     f01066df <readline+0x85>
f0106718:	eb b9                	jmp    f01066d3 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f010671a:	83 fb 0a             	cmp    $0xa,%ebx
f010671d:	74 05                	je     f0106724 <readline+0xca>
f010671f:	83 fb 0d             	cmp    $0xd,%ebx
f0106722:	75 c4                	jne    f01066e8 <readline+0x8e>
			if (echoing)
f0106724:	85 ff                	test   %edi,%edi
f0106726:	75 11                	jne    f0106739 <readline+0xdf>
			buf[i] = 0;
f0106728:	c6 86 60 d9 5d f0 00 	movb   $0x0,-0xfa226a0(%esi)
			return buf;
f010672f:	b8 60 d9 5d f0       	mov    $0xf05dd960,%eax
f0106734:	e9 62 ff ff ff       	jmp    f010669b <readline+0x41>
				cputchar('\n');
f0106739:	83 ec 0c             	sub    $0xc,%esp
f010673c:	6a 0a                	push   $0xa
f010673e:	e8 04 a1 ff ff       	call   f0100847 <cputchar>
f0106743:	83 c4 10             	add    $0x10,%esp
f0106746:	eb e0                	jmp    f0106728 <readline+0xce>

f0106748 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106748:	55                   	push   %ebp
f0106749:	89 e5                	mov    %esp,%ebp
f010674b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010674e:	b8 00 00 00 00       	mov    $0x0,%eax
f0106753:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106757:	74 05                	je     f010675e <strlen+0x16>
		n++;
f0106759:	83 c0 01             	add    $0x1,%eax
f010675c:	eb f5                	jmp    f0106753 <strlen+0xb>
	return n;
}
f010675e:	5d                   	pop    %ebp
f010675f:	c3                   	ret    

f0106760 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106760:	55                   	push   %ebp
f0106761:	89 e5                	mov    %esp,%ebp
f0106763:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106766:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106769:	ba 00 00 00 00       	mov    $0x0,%edx
f010676e:	39 c2                	cmp    %eax,%edx
f0106770:	74 0d                	je     f010677f <strnlen+0x1f>
f0106772:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106776:	74 05                	je     f010677d <strnlen+0x1d>
		n++;
f0106778:	83 c2 01             	add    $0x1,%edx
f010677b:	eb f1                	jmp    f010676e <strnlen+0xe>
f010677d:	89 d0                	mov    %edx,%eax
	return n;
}
f010677f:	5d                   	pop    %ebp
f0106780:	c3                   	ret    

f0106781 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106781:	55                   	push   %ebp
f0106782:	89 e5                	mov    %esp,%ebp
f0106784:	53                   	push   %ebx
f0106785:	8b 45 08             	mov    0x8(%ebp),%eax
f0106788:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010678b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106790:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106794:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0106797:	83 c2 01             	add    $0x1,%edx
f010679a:	84 c9                	test   %cl,%cl
f010679c:	75 f2                	jne    f0106790 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f010679e:	5b                   	pop    %ebx
f010679f:	5d                   	pop    %ebp
f01067a0:	c3                   	ret    

f01067a1 <strcat>:

char *
strcat(char *dst, const char *src)
{
f01067a1:	55                   	push   %ebp
f01067a2:	89 e5                	mov    %esp,%ebp
f01067a4:	53                   	push   %ebx
f01067a5:	83 ec 10             	sub    $0x10,%esp
f01067a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01067ab:	53                   	push   %ebx
f01067ac:	e8 97 ff ff ff       	call   f0106748 <strlen>
f01067b1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01067b4:	ff 75 0c             	pushl  0xc(%ebp)
f01067b7:	01 d8                	add    %ebx,%eax
f01067b9:	50                   	push   %eax
f01067ba:	e8 c2 ff ff ff       	call   f0106781 <strcpy>
	return dst;
}
f01067bf:	89 d8                	mov    %ebx,%eax
f01067c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01067c4:	c9                   	leave  
f01067c5:	c3                   	ret    

f01067c6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01067c6:	55                   	push   %ebp
f01067c7:	89 e5                	mov    %esp,%ebp
f01067c9:	56                   	push   %esi
f01067ca:	53                   	push   %ebx
f01067cb:	8b 45 08             	mov    0x8(%ebp),%eax
f01067ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01067d1:	89 c6                	mov    %eax,%esi
f01067d3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01067d6:	89 c2                	mov    %eax,%edx
f01067d8:	39 f2                	cmp    %esi,%edx
f01067da:	74 11                	je     f01067ed <strncpy+0x27>
		*dst++ = *src;
f01067dc:	83 c2 01             	add    $0x1,%edx
f01067df:	0f b6 19             	movzbl (%ecx),%ebx
f01067e2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01067e5:	80 fb 01             	cmp    $0x1,%bl
f01067e8:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01067eb:	eb eb                	jmp    f01067d8 <strncpy+0x12>
	}
	return ret;
}
f01067ed:	5b                   	pop    %ebx
f01067ee:	5e                   	pop    %esi
f01067ef:	5d                   	pop    %ebp
f01067f0:	c3                   	ret    

f01067f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01067f1:	55                   	push   %ebp
f01067f2:	89 e5                	mov    %esp,%ebp
f01067f4:	56                   	push   %esi
f01067f5:	53                   	push   %ebx
f01067f6:	8b 75 08             	mov    0x8(%ebp),%esi
f01067f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01067fc:	8b 55 10             	mov    0x10(%ebp),%edx
f01067ff:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0106801:	85 d2                	test   %edx,%edx
f0106803:	74 21                	je     f0106826 <strlcpy+0x35>
f0106805:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0106809:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f010680b:	39 c2                	cmp    %eax,%edx
f010680d:	74 14                	je     f0106823 <strlcpy+0x32>
f010680f:	0f b6 19             	movzbl (%ecx),%ebx
f0106812:	84 db                	test   %bl,%bl
f0106814:	74 0b                	je     f0106821 <strlcpy+0x30>
			*dst++ = *src++;
f0106816:	83 c1 01             	add    $0x1,%ecx
f0106819:	83 c2 01             	add    $0x1,%edx
f010681c:	88 5a ff             	mov    %bl,-0x1(%edx)
f010681f:	eb ea                	jmp    f010680b <strlcpy+0x1a>
f0106821:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0106823:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106826:	29 f0                	sub    %esi,%eax
}
f0106828:	5b                   	pop    %ebx
f0106829:	5e                   	pop    %esi
f010682a:	5d                   	pop    %ebp
f010682b:	c3                   	ret    

f010682c <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010682c:	55                   	push   %ebp
f010682d:	89 e5                	mov    %esp,%ebp
f010682f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106832:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106835:	0f b6 01             	movzbl (%ecx),%eax
f0106838:	84 c0                	test   %al,%al
f010683a:	74 0c                	je     f0106848 <strcmp+0x1c>
f010683c:	3a 02                	cmp    (%edx),%al
f010683e:	75 08                	jne    f0106848 <strcmp+0x1c>
		p++, q++;
f0106840:	83 c1 01             	add    $0x1,%ecx
f0106843:	83 c2 01             	add    $0x1,%edx
f0106846:	eb ed                	jmp    f0106835 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106848:	0f b6 c0             	movzbl %al,%eax
f010684b:	0f b6 12             	movzbl (%edx),%edx
f010684e:	29 d0                	sub    %edx,%eax
}
f0106850:	5d                   	pop    %ebp
f0106851:	c3                   	ret    

f0106852 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106852:	55                   	push   %ebp
f0106853:	89 e5                	mov    %esp,%ebp
f0106855:	53                   	push   %ebx
f0106856:	8b 45 08             	mov    0x8(%ebp),%eax
f0106859:	8b 55 0c             	mov    0xc(%ebp),%edx
f010685c:	89 c3                	mov    %eax,%ebx
f010685e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106861:	eb 06                	jmp    f0106869 <strncmp+0x17>
		n--, p++, q++;
f0106863:	83 c0 01             	add    $0x1,%eax
f0106866:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0106869:	39 d8                	cmp    %ebx,%eax
f010686b:	74 16                	je     f0106883 <strncmp+0x31>
f010686d:	0f b6 08             	movzbl (%eax),%ecx
f0106870:	84 c9                	test   %cl,%cl
f0106872:	74 04                	je     f0106878 <strncmp+0x26>
f0106874:	3a 0a                	cmp    (%edx),%cl
f0106876:	74 eb                	je     f0106863 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106878:	0f b6 00             	movzbl (%eax),%eax
f010687b:	0f b6 12             	movzbl (%edx),%edx
f010687e:	29 d0                	sub    %edx,%eax
}
f0106880:	5b                   	pop    %ebx
f0106881:	5d                   	pop    %ebp
f0106882:	c3                   	ret    
		return 0;
f0106883:	b8 00 00 00 00       	mov    $0x0,%eax
f0106888:	eb f6                	jmp    f0106880 <strncmp+0x2e>

f010688a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010688a:	55                   	push   %ebp
f010688b:	89 e5                	mov    %esp,%ebp
f010688d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106890:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106894:	0f b6 10             	movzbl (%eax),%edx
f0106897:	84 d2                	test   %dl,%dl
f0106899:	74 09                	je     f01068a4 <strchr+0x1a>
		if (*s == c)
f010689b:	38 ca                	cmp    %cl,%dl
f010689d:	74 0a                	je     f01068a9 <strchr+0x1f>
	for (; *s; s++)
f010689f:	83 c0 01             	add    $0x1,%eax
f01068a2:	eb f0                	jmp    f0106894 <strchr+0xa>
			return (char *) s;
	return 0;
f01068a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01068a9:	5d                   	pop    %ebp
f01068aa:	c3                   	ret    

f01068ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01068ab:	55                   	push   %ebp
f01068ac:	89 e5                	mov    %esp,%ebp
f01068ae:	8b 45 08             	mov    0x8(%ebp),%eax
f01068b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01068b5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01068b8:	38 ca                	cmp    %cl,%dl
f01068ba:	74 09                	je     f01068c5 <strfind+0x1a>
f01068bc:	84 d2                	test   %dl,%dl
f01068be:	74 05                	je     f01068c5 <strfind+0x1a>
	for (; *s; s++)
f01068c0:	83 c0 01             	add    $0x1,%eax
f01068c3:	eb f0                	jmp    f01068b5 <strfind+0xa>
			break;
	return (char *) s;
}
f01068c5:	5d                   	pop    %ebp
f01068c6:	c3                   	ret    

f01068c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01068c7:	55                   	push   %ebp
f01068c8:	89 e5                	mov    %esp,%ebp
f01068ca:	57                   	push   %edi
f01068cb:	56                   	push   %esi
f01068cc:	53                   	push   %ebx
f01068cd:	8b 7d 08             	mov    0x8(%ebp),%edi
f01068d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01068d3:	85 c9                	test   %ecx,%ecx
f01068d5:	74 31                	je     f0106908 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01068d7:	89 f8                	mov    %edi,%eax
f01068d9:	09 c8                	or     %ecx,%eax
f01068db:	a8 03                	test   $0x3,%al
f01068dd:	75 23                	jne    f0106902 <memset+0x3b>
		c &= 0xFF;
f01068df:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01068e3:	89 d3                	mov    %edx,%ebx
f01068e5:	c1 e3 08             	shl    $0x8,%ebx
f01068e8:	89 d0                	mov    %edx,%eax
f01068ea:	c1 e0 18             	shl    $0x18,%eax
f01068ed:	89 d6                	mov    %edx,%esi
f01068ef:	c1 e6 10             	shl    $0x10,%esi
f01068f2:	09 f0                	or     %esi,%eax
f01068f4:	09 c2                	or     %eax,%edx
f01068f6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01068f8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01068fb:	89 d0                	mov    %edx,%eax
f01068fd:	fc                   	cld    
f01068fe:	f3 ab                	rep stos %eax,%es:(%edi)
f0106900:	eb 06                	jmp    f0106908 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0106902:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106905:	fc                   	cld    
f0106906:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0106908:	89 f8                	mov    %edi,%eax
f010690a:	5b                   	pop    %ebx
f010690b:	5e                   	pop    %esi
f010690c:	5f                   	pop    %edi
f010690d:	5d                   	pop    %ebp
f010690e:	c3                   	ret    

f010690f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010690f:	55                   	push   %ebp
f0106910:	89 e5                	mov    %esp,%ebp
f0106912:	57                   	push   %edi
f0106913:	56                   	push   %esi
f0106914:	8b 45 08             	mov    0x8(%ebp),%eax
f0106917:	8b 75 0c             	mov    0xc(%ebp),%esi
f010691a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010691d:	39 c6                	cmp    %eax,%esi
f010691f:	73 32                	jae    f0106953 <memmove+0x44>
f0106921:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106924:	39 c2                	cmp    %eax,%edx
f0106926:	76 2b                	jbe    f0106953 <memmove+0x44>
		s += n;
		d += n;
f0106928:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010692b:	89 fe                	mov    %edi,%esi
f010692d:	09 ce                	or     %ecx,%esi
f010692f:	09 d6                	or     %edx,%esi
f0106931:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106937:	75 0e                	jne    f0106947 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106939:	83 ef 04             	sub    $0x4,%edi
f010693c:	8d 72 fc             	lea    -0x4(%edx),%esi
f010693f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0106942:	fd                   	std    
f0106943:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106945:	eb 09                	jmp    f0106950 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106947:	83 ef 01             	sub    $0x1,%edi
f010694a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010694d:	fd                   	std    
f010694e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106950:	fc                   	cld    
f0106951:	eb 1a                	jmp    f010696d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106953:	89 c2                	mov    %eax,%edx
f0106955:	09 ca                	or     %ecx,%edx
f0106957:	09 f2                	or     %esi,%edx
f0106959:	f6 c2 03             	test   $0x3,%dl
f010695c:	75 0a                	jne    f0106968 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010695e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0106961:	89 c7                	mov    %eax,%edi
f0106963:	fc                   	cld    
f0106964:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106966:	eb 05                	jmp    f010696d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0106968:	89 c7                	mov    %eax,%edi
f010696a:	fc                   	cld    
f010696b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010696d:	5e                   	pop    %esi
f010696e:	5f                   	pop    %edi
f010696f:	5d                   	pop    %ebp
f0106970:	c3                   	ret    

f0106971 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106971:	55                   	push   %ebp
f0106972:	89 e5                	mov    %esp,%ebp
f0106974:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106977:	ff 75 10             	pushl  0x10(%ebp)
f010697a:	ff 75 0c             	pushl  0xc(%ebp)
f010697d:	ff 75 08             	pushl  0x8(%ebp)
f0106980:	e8 8a ff ff ff       	call   f010690f <memmove>
}
f0106985:	c9                   	leave  
f0106986:	c3                   	ret    

f0106987 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106987:	55                   	push   %ebp
f0106988:	89 e5                	mov    %esp,%ebp
f010698a:	56                   	push   %esi
f010698b:	53                   	push   %ebx
f010698c:	8b 45 08             	mov    0x8(%ebp),%eax
f010698f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106992:	89 c6                	mov    %eax,%esi
f0106994:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106997:	39 f0                	cmp    %esi,%eax
f0106999:	74 1c                	je     f01069b7 <memcmp+0x30>
		if (*s1 != *s2)
f010699b:	0f b6 08             	movzbl (%eax),%ecx
f010699e:	0f b6 1a             	movzbl (%edx),%ebx
f01069a1:	38 d9                	cmp    %bl,%cl
f01069a3:	75 08                	jne    f01069ad <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01069a5:	83 c0 01             	add    $0x1,%eax
f01069a8:	83 c2 01             	add    $0x1,%edx
f01069ab:	eb ea                	jmp    f0106997 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01069ad:	0f b6 c1             	movzbl %cl,%eax
f01069b0:	0f b6 db             	movzbl %bl,%ebx
f01069b3:	29 d8                	sub    %ebx,%eax
f01069b5:	eb 05                	jmp    f01069bc <memcmp+0x35>
	}

	return 0;
f01069b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01069bc:	5b                   	pop    %ebx
f01069bd:	5e                   	pop    %esi
f01069be:	5d                   	pop    %ebp
f01069bf:	c3                   	ret    

f01069c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01069c0:	55                   	push   %ebp
f01069c1:	89 e5                	mov    %esp,%ebp
f01069c3:	8b 45 08             	mov    0x8(%ebp),%eax
f01069c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01069c9:	89 c2                	mov    %eax,%edx
f01069cb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01069ce:	39 d0                	cmp    %edx,%eax
f01069d0:	73 09                	jae    f01069db <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01069d2:	38 08                	cmp    %cl,(%eax)
f01069d4:	74 05                	je     f01069db <memfind+0x1b>
	for (; s < ends; s++)
f01069d6:	83 c0 01             	add    $0x1,%eax
f01069d9:	eb f3                	jmp    f01069ce <memfind+0xe>
			break;
	return (void *) s;
}
f01069db:	5d                   	pop    %ebp
f01069dc:	c3                   	ret    

f01069dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01069dd:	55                   	push   %ebp
f01069de:	89 e5                	mov    %esp,%ebp
f01069e0:	57                   	push   %edi
f01069e1:	56                   	push   %esi
f01069e2:	53                   	push   %ebx
f01069e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01069e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01069e9:	eb 03                	jmp    f01069ee <strtol+0x11>
		s++;
f01069eb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01069ee:	0f b6 01             	movzbl (%ecx),%eax
f01069f1:	3c 20                	cmp    $0x20,%al
f01069f3:	74 f6                	je     f01069eb <strtol+0xe>
f01069f5:	3c 09                	cmp    $0x9,%al
f01069f7:	74 f2                	je     f01069eb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01069f9:	3c 2b                	cmp    $0x2b,%al
f01069fb:	74 2a                	je     f0106a27 <strtol+0x4a>
	int neg = 0;
f01069fd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0106a02:	3c 2d                	cmp    $0x2d,%al
f0106a04:	74 2b                	je     f0106a31 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106a06:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0106a0c:	75 0f                	jne    f0106a1d <strtol+0x40>
f0106a0e:	80 39 30             	cmpb   $0x30,(%ecx)
f0106a11:	74 28                	je     f0106a3b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106a13:	85 db                	test   %ebx,%ebx
f0106a15:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106a1a:	0f 44 d8             	cmove  %eax,%ebx
f0106a1d:	b8 00 00 00 00       	mov    $0x0,%eax
f0106a22:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106a25:	eb 50                	jmp    f0106a77 <strtol+0x9a>
		s++;
f0106a27:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0106a2a:	bf 00 00 00 00       	mov    $0x0,%edi
f0106a2f:	eb d5                	jmp    f0106a06 <strtol+0x29>
		s++, neg = 1;
f0106a31:	83 c1 01             	add    $0x1,%ecx
f0106a34:	bf 01 00 00 00       	mov    $0x1,%edi
f0106a39:	eb cb                	jmp    f0106a06 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106a3b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0106a3f:	74 0e                	je     f0106a4f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0106a41:	85 db                	test   %ebx,%ebx
f0106a43:	75 d8                	jne    f0106a1d <strtol+0x40>
		s++, base = 8;
f0106a45:	83 c1 01             	add    $0x1,%ecx
f0106a48:	bb 08 00 00 00       	mov    $0x8,%ebx
f0106a4d:	eb ce                	jmp    f0106a1d <strtol+0x40>
		s += 2, base = 16;
f0106a4f:	83 c1 02             	add    $0x2,%ecx
f0106a52:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106a57:	eb c4                	jmp    f0106a1d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106a59:	8d 72 9f             	lea    -0x61(%edx),%esi
f0106a5c:	89 f3                	mov    %esi,%ebx
f0106a5e:	80 fb 19             	cmp    $0x19,%bl
f0106a61:	77 29                	ja     f0106a8c <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106a63:	0f be d2             	movsbl %dl,%edx
f0106a66:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106a69:	3b 55 10             	cmp    0x10(%ebp),%edx
f0106a6c:	7d 30                	jge    f0106a9e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0106a6e:	83 c1 01             	add    $0x1,%ecx
f0106a71:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106a75:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106a77:	0f b6 11             	movzbl (%ecx),%edx
f0106a7a:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106a7d:	89 f3                	mov    %esi,%ebx
f0106a7f:	80 fb 09             	cmp    $0x9,%bl
f0106a82:	77 d5                	ja     f0106a59 <strtol+0x7c>
			dig = *s - '0';
f0106a84:	0f be d2             	movsbl %dl,%edx
f0106a87:	83 ea 30             	sub    $0x30,%edx
f0106a8a:	eb dd                	jmp    f0106a69 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f0106a8c:	8d 72 bf             	lea    -0x41(%edx),%esi
f0106a8f:	89 f3                	mov    %esi,%ebx
f0106a91:	80 fb 19             	cmp    $0x19,%bl
f0106a94:	77 08                	ja     f0106a9e <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106a96:	0f be d2             	movsbl %dl,%edx
f0106a99:	83 ea 37             	sub    $0x37,%edx
f0106a9c:	eb cb                	jmp    f0106a69 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f0106a9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106aa2:	74 05                	je     f0106aa9 <strtol+0xcc>
		*endptr = (char *) s;
f0106aa4:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106aa7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0106aa9:	89 c2                	mov    %eax,%edx
f0106aab:	f7 da                	neg    %edx
f0106aad:	85 ff                	test   %edi,%edi
f0106aaf:	0f 45 c2             	cmovne %edx,%eax
}
f0106ab2:	5b                   	pop    %ebx
f0106ab3:	5e                   	pop    %esi
f0106ab4:	5f                   	pop    %edi
f0106ab5:	5d                   	pop    %ebp
f0106ab6:	c3                   	ret    
f0106ab7:	90                   	nop

f0106ab8 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106ab8:	fa                   	cli    

	xorw    %ax, %ax
f0106ab9:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0106abb:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106abd:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106abf:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106ac1:	0f 01 16             	lgdtl  (%esi)
f0106ac4:	7c 70                	jl     f0106b36 <gdtdesc+0x2>
	movl    %cr0, %eax
f0106ac6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106ac9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106acd:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106ad0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0106ad6:	08 00                	or     %al,(%eax)

f0106ad8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0106ad8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106adc:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106ade:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106ae0:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106ae2:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0106ae6:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106ae8:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0106aea:	b8 00 c0 16 00       	mov    $0x16c000,%eax
	movl    %eax, %cr3
f0106aef:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f0106af2:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f0106af5:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f0106af8:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f0106afb:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106afe:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0106b03:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106b06:	8b 25 84 ed 5d f0    	mov    0xf05ded84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106b0c:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106b11:	b8 64 02 10 f0       	mov    $0xf0100264,%eax
	call    *%eax
f0106b16:	ff d0                	call   *%eax

f0106b18 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106b18:	eb fe                	jmp    f0106b18 <spin>
f0106b1a:	66 90                	xchg   %ax,%ax

f0106b1c <gdt>:
	...
f0106b24:	ff                   	(bad)  
f0106b25:	ff 00                	incl   (%eax)
f0106b27:	00 00                	add    %al,(%eax)
f0106b29:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0106b30:	00                   	.byte 0x0
f0106b31:	92                   	xchg   %eax,%edx
f0106b32:	cf                   	iret   
	...

f0106b34 <gdtdesc>:
f0106b34:	17                   	pop    %ss
f0106b35:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0106b3a <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106b3a:	90                   	nop

f0106b3b <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106b3b:	55                   	push   %ebp
f0106b3c:	89 e5                	mov    %esp,%ebp
f0106b3e:	57                   	push   %edi
f0106b3f:	56                   	push   %esi
f0106b40:	53                   	push   %ebx
f0106b41:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106b44:	8b 0d 88 ed 5d f0    	mov    0xf05ded88,%ecx
f0106b4a:	89 c3                	mov    %eax,%ebx
f0106b4c:	c1 eb 0c             	shr    $0xc,%ebx
f0106b4f:	39 cb                	cmp    %ecx,%ebx
f0106b51:	73 1a                	jae    f0106b6d <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0106b53:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106b59:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106b5c:	89 f8                	mov    %edi,%eax
f0106b5e:	c1 e8 0c             	shr    $0xc,%eax
f0106b61:	39 c8                	cmp    %ecx,%eax
f0106b63:	73 1a                	jae    f0106b7f <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106b65:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106b6b:	eb 27                	jmp    f0106b94 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106b6d:	50                   	push   %eax
f0106b6e:	68 0c 81 10 f0       	push   $0xf010810c
f0106b73:	6a 58                	push   $0x58
f0106b75:	68 85 a6 10 f0       	push   $0xf010a685
f0106b7a:	e8 ca 94 ff ff       	call   f0100049 <_panic>
f0106b7f:	57                   	push   %edi
f0106b80:	68 0c 81 10 f0       	push   $0xf010810c
f0106b85:	6a 58                	push   $0x58
f0106b87:	68 85 a6 10 f0       	push   $0xf010a685
f0106b8c:	e8 b8 94 ff ff       	call   f0100049 <_panic>
f0106b91:	83 c3 10             	add    $0x10,%ebx
f0106b94:	39 fb                	cmp    %edi,%ebx
f0106b96:	73 30                	jae    f0106bc8 <mpsearch1+0x8d>
f0106b98:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106b9a:	83 ec 04             	sub    $0x4,%esp
f0106b9d:	6a 04                	push   $0x4
f0106b9f:	68 95 a6 10 f0       	push   $0xf010a695
f0106ba4:	53                   	push   %ebx
f0106ba5:	e8 dd fd ff ff       	call   f0106987 <memcmp>
f0106baa:	83 c4 10             	add    $0x10,%esp
f0106bad:	85 c0                	test   %eax,%eax
f0106baf:	75 e0                	jne    f0106b91 <mpsearch1+0x56>
f0106bb1:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0106bb3:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0106bb6:	0f b6 0a             	movzbl (%edx),%ecx
f0106bb9:	01 c8                	add    %ecx,%eax
f0106bbb:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0106bbe:	39 f2                	cmp    %esi,%edx
f0106bc0:	75 f4                	jne    f0106bb6 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106bc2:	84 c0                	test   %al,%al
f0106bc4:	75 cb                	jne    f0106b91 <mpsearch1+0x56>
f0106bc6:	eb 05                	jmp    f0106bcd <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0106bc8:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0106bcd:	89 d8                	mov    %ebx,%eax
f0106bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106bd2:	5b                   	pop    %ebx
f0106bd3:	5e                   	pop    %esi
f0106bd4:	5f                   	pop    %edi
f0106bd5:	5d                   	pop    %ebp
f0106bd6:	c3                   	ret    

f0106bd7 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106bd7:	55                   	push   %ebp
f0106bd8:	89 e5                	mov    %esp,%ebp
f0106bda:	57                   	push   %edi
f0106bdb:	56                   	push   %esi
f0106bdc:	53                   	push   %ebx
f0106bdd:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106be0:	c7 05 00 b0 16 f0 20 	movl   $0xf016b020,0xf016b000
f0106be7:	b0 16 f0 
	if (PGNUM(pa) >= npages)
f0106bea:	83 3d 88 ed 5d f0 00 	cmpl   $0x0,0xf05ded88
f0106bf1:	0f 84 a3 00 00 00    	je     f0106c9a <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106bf7:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0106bfe:	85 c0                	test   %eax,%eax
f0106c00:	0f 84 aa 00 00 00    	je     f0106cb0 <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f0106c06:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106c09:	ba 00 04 00 00       	mov    $0x400,%edx
f0106c0e:	e8 28 ff ff ff       	call   f0106b3b <mpsearch1>
f0106c13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106c16:	85 c0                	test   %eax,%eax
f0106c18:	75 1a                	jne    f0106c34 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0106c1a:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c1f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106c24:	e8 12 ff ff ff       	call   f0106b3b <mpsearch1>
f0106c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0106c2c:	85 c0                	test   %eax,%eax
f0106c2e:	0f 84 31 02 00 00    	je     f0106e65 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106c37:	8b 58 04             	mov    0x4(%eax),%ebx
f0106c3a:	85 db                	test   %ebx,%ebx
f0106c3c:	0f 84 97 00 00 00    	je     f0106cd9 <mp_init+0x102>
f0106c42:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106c46:	0f 85 8d 00 00 00    	jne    f0106cd9 <mp_init+0x102>
f0106c4c:	89 d8                	mov    %ebx,%eax
f0106c4e:	c1 e8 0c             	shr    $0xc,%eax
f0106c51:	3b 05 88 ed 5d f0    	cmp    0xf05ded88,%eax
f0106c57:	0f 83 91 00 00 00    	jae    f0106cee <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106c5d:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0106c63:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106c65:	83 ec 04             	sub    $0x4,%esp
f0106c68:	6a 04                	push   $0x4
f0106c6a:	68 9a a6 10 f0       	push   $0xf010a69a
f0106c6f:	53                   	push   %ebx
f0106c70:	e8 12 fd ff ff       	call   f0106987 <memcmp>
f0106c75:	83 c4 10             	add    $0x10,%esp
f0106c78:	85 c0                	test   %eax,%eax
f0106c7a:	0f 85 83 00 00 00    	jne    f0106d03 <mp_init+0x12c>
f0106c80:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106c84:	01 df                	add    %ebx,%edi
	sum = 0;
f0106c86:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106c88:	39 fb                	cmp    %edi,%ebx
f0106c8a:	0f 84 88 00 00 00    	je     f0106d18 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f0106c90:	0f b6 0b             	movzbl (%ebx),%ecx
f0106c93:	01 ca                	add    %ecx,%edx
f0106c95:	83 c3 01             	add    $0x1,%ebx
f0106c98:	eb ee                	jmp    f0106c88 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106c9a:	68 00 04 00 00       	push   $0x400
f0106c9f:	68 0c 81 10 f0       	push   $0xf010810c
f0106ca4:	6a 70                	push   $0x70
f0106ca6:	68 85 a6 10 f0       	push   $0xf010a685
f0106cab:	e8 99 93 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0106cb0:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0106cb7:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0106cba:	2d 00 04 00 00       	sub    $0x400,%eax
f0106cbf:	ba 00 04 00 00       	mov    $0x400,%edx
f0106cc4:	e8 72 fe ff ff       	call   f0106b3b <mpsearch1>
f0106cc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106ccc:	85 c0                	test   %eax,%eax
f0106cce:	0f 85 60 ff ff ff    	jne    f0106c34 <mp_init+0x5d>
f0106cd4:	e9 41 ff ff ff       	jmp    f0106c1a <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f0106cd9:	83 ec 0c             	sub    $0xc,%esp
f0106cdc:	68 f8 a4 10 f0       	push   $0xf010a4f8
f0106ce1:	e8 7f d5 ff ff       	call   f0104265 <cprintf>
f0106ce6:	83 c4 10             	add    $0x10,%esp
f0106ce9:	e9 77 01 00 00       	jmp    f0106e65 <mp_init+0x28e>
f0106cee:	53                   	push   %ebx
f0106cef:	68 0c 81 10 f0       	push   $0xf010810c
f0106cf4:	68 91 00 00 00       	push   $0x91
f0106cf9:	68 85 a6 10 f0       	push   $0xf010a685
f0106cfe:	e8 46 93 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106d03:	83 ec 0c             	sub    $0xc,%esp
f0106d06:	68 28 a5 10 f0       	push   $0xf010a528
f0106d0b:	e8 55 d5 ff ff       	call   f0104265 <cprintf>
f0106d10:	83 c4 10             	add    $0x10,%esp
f0106d13:	e9 4d 01 00 00       	jmp    f0106e65 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0106d18:	84 d2                	test   %dl,%dl
f0106d1a:	75 16                	jne    f0106d32 <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0106d1c:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0106d20:	80 fa 01             	cmp    $0x1,%dl
f0106d23:	74 05                	je     f0106d2a <mp_init+0x153>
f0106d25:	80 fa 04             	cmp    $0x4,%dl
f0106d28:	75 1d                	jne    f0106d47 <mp_init+0x170>
f0106d2a:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0106d2e:	01 d9                	add    %ebx,%ecx
f0106d30:	eb 36                	jmp    f0106d68 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106d32:	83 ec 0c             	sub    $0xc,%esp
f0106d35:	68 5c a5 10 f0       	push   $0xf010a55c
f0106d3a:	e8 26 d5 ff ff       	call   f0104265 <cprintf>
f0106d3f:	83 c4 10             	add    $0x10,%esp
f0106d42:	e9 1e 01 00 00       	jmp    f0106e65 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106d47:	83 ec 08             	sub    $0x8,%esp
f0106d4a:	0f b6 d2             	movzbl %dl,%edx
f0106d4d:	52                   	push   %edx
f0106d4e:	68 80 a5 10 f0       	push   $0xf010a580
f0106d53:	e8 0d d5 ff ff       	call   f0104265 <cprintf>
f0106d58:	83 c4 10             	add    $0x10,%esp
f0106d5b:	e9 05 01 00 00       	jmp    f0106e65 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106d60:	0f b6 13             	movzbl (%ebx),%edx
f0106d63:	01 d0                	add    %edx,%eax
f0106d65:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106d68:	39 d9                	cmp    %ebx,%ecx
f0106d6a:	75 f4                	jne    f0106d60 <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106d6c:	02 46 2a             	add    0x2a(%esi),%al
f0106d6f:	75 1c                	jne    f0106d8d <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106d71:	c7 05 94 ed 5d f0 01 	movl   $0x1,0xf05ded94
f0106d78:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106d7b:	8b 46 24             	mov    0x24(%esi),%eax
f0106d7e:	a3 9c ed 5d f0       	mov    %eax,0xf05ded9c

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106d83:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106d86:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106d8b:	eb 4d                	jmp    f0106dda <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106d8d:	83 ec 0c             	sub    $0xc,%esp
f0106d90:	68 a0 a5 10 f0       	push   $0xf010a5a0
f0106d95:	e8 cb d4 ff ff       	call   f0104265 <cprintf>
f0106d9a:	83 c4 10             	add    $0x10,%esp
f0106d9d:	e9 c3 00 00 00       	jmp    f0106e65 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106da2:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106da6:	74 11                	je     f0106db9 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106da8:	6b 05 98 ed 5d f0 74 	imul   $0x74,0xf05ded98,%eax
f0106daf:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f0106db4:	a3 00 b0 16 f0       	mov    %eax,0xf016b000
			if (ncpu < NCPU) {
f0106db9:	a1 98 ed 5d f0       	mov    0xf05ded98,%eax
f0106dbe:	83 f8 07             	cmp    $0x7,%eax
f0106dc1:	7f 2f                	jg     f0106df2 <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0106dc3:	6b d0 74             	imul   $0x74,%eax,%edx
f0106dc6:	88 82 20 b0 16 f0    	mov    %al,-0xfe94fe0(%edx)
				ncpu++;
f0106dcc:	83 c0 01             	add    $0x1,%eax
f0106dcf:	a3 98 ed 5d f0       	mov    %eax,0xf05ded98
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106dd4:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106dd7:	83 c3 01             	add    $0x1,%ebx
f0106dda:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0106dde:	39 d8                	cmp    %ebx,%eax
f0106de0:	76 4b                	jbe    f0106e2d <mp_init+0x256>
		switch (*p) {
f0106de2:	0f b6 07             	movzbl (%edi),%eax
f0106de5:	84 c0                	test   %al,%al
f0106de7:	74 b9                	je     f0106da2 <mp_init+0x1cb>
f0106de9:	3c 04                	cmp    $0x4,%al
f0106deb:	77 1c                	ja     f0106e09 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106ded:	83 c7 08             	add    $0x8,%edi
			continue;
f0106df0:	eb e5                	jmp    f0106dd7 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106df2:	83 ec 08             	sub    $0x8,%esp
f0106df5:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106df9:	50                   	push   %eax
f0106dfa:	68 d0 a5 10 f0       	push   $0xf010a5d0
f0106dff:	e8 61 d4 ff ff       	call   f0104265 <cprintf>
f0106e04:	83 c4 10             	add    $0x10,%esp
f0106e07:	eb cb                	jmp    f0106dd4 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106e09:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106e0c:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106e0f:	50                   	push   %eax
f0106e10:	68 f8 a5 10 f0       	push   $0xf010a5f8
f0106e15:	e8 4b d4 ff ff       	call   f0104265 <cprintf>
			ismp = 0;
f0106e1a:	c7 05 94 ed 5d f0 00 	movl   $0x0,0xf05ded94
f0106e21:	00 00 00 
			i = conf->entry;
f0106e24:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106e28:	83 c4 10             	add    $0x10,%esp
f0106e2b:	eb aa                	jmp    f0106dd7 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106e2d:	a1 00 b0 16 f0       	mov    0xf016b000,%eax
f0106e32:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106e39:	83 3d 94 ed 5d f0 00 	cmpl   $0x0,0xf05ded94
f0106e40:	74 2b                	je     f0106e6d <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106e42:	83 ec 04             	sub    $0x4,%esp
f0106e45:	ff 35 98 ed 5d f0    	pushl  0xf05ded98
f0106e4b:	0f b6 00             	movzbl (%eax),%eax
f0106e4e:	50                   	push   %eax
f0106e4f:	68 9f a6 10 f0       	push   $0xf010a69f
f0106e54:	e8 0c d4 ff ff       	call   f0104265 <cprintf>

	if (mp->imcrp) {
f0106e59:	83 c4 10             	add    $0x10,%esp
f0106e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106e5f:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106e63:	75 2e                	jne    f0106e93 <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106e68:	5b                   	pop    %ebx
f0106e69:	5e                   	pop    %esi
f0106e6a:	5f                   	pop    %edi
f0106e6b:	5d                   	pop    %ebp
f0106e6c:	c3                   	ret    
		ncpu = 1;
f0106e6d:	c7 05 98 ed 5d f0 01 	movl   $0x1,0xf05ded98
f0106e74:	00 00 00 
		lapicaddr = 0;
f0106e77:	c7 05 9c ed 5d f0 00 	movl   $0x0,0xf05ded9c
f0106e7e:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106e81:	83 ec 0c             	sub    $0xc,%esp
f0106e84:	68 18 a6 10 f0       	push   $0xf010a618
f0106e89:	e8 d7 d3 ff ff       	call   f0104265 <cprintf>
		return;
f0106e8e:	83 c4 10             	add    $0x10,%esp
f0106e91:	eb d2                	jmp    f0106e65 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106e93:	83 ec 0c             	sub    $0xc,%esp
f0106e96:	68 44 a6 10 f0       	push   $0xf010a644
f0106e9b:	e8 c5 d3 ff ff       	call   f0104265 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106ea0:	b8 70 00 00 00       	mov    $0x70,%eax
f0106ea5:	ba 22 00 00 00       	mov    $0x22,%edx
f0106eaa:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106eab:	ba 23 00 00 00       	mov    $0x23,%edx
f0106eb0:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106eb1:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106eb4:	ee                   	out    %al,(%dx)
f0106eb5:	83 c4 10             	add    $0x10,%esp
f0106eb8:	eb ab                	jmp    f0106e65 <mp_init+0x28e>

f0106eba <lapicw>:
volatile uint32_t *lapic __user_mapped_data;	//lab7 bug mapped data

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106eba:	8b 0d c0 b3 16 f0    	mov    0xf016b3c0,%ecx
f0106ec0:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106ec3:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106ec5:	a1 c0 b3 16 f0       	mov    0xf016b3c0,%eax
f0106eca:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106ecd:	c3                   	ret    

f0106ece <lapic_init>:

void
lapic_init(void)
{
f0106ece:	55                   	push   %ebp
f0106ecf:	89 e5                	mov    %esp,%ebp
f0106ed1:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f0106ed4:	68 d4 a6 10 f0       	push   $0xf010a6d4
f0106ed9:	68 20 80 10 f0       	push   $0xf0108020
f0106ede:	e8 82 d3 ff ff       	call   f0104265 <cprintf>
	if (!lapicaddr)
f0106ee3:	a1 9c ed 5d f0       	mov    0xf05ded9c,%eax
f0106ee8:	83 c4 10             	add    $0x10,%esp
f0106eeb:	85 c0                	test   %eax,%eax
f0106eed:	75 02                	jne    f0106ef1 <lapic_init+0x23>
	while(lapic[ICRLO] & DELIVS)
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
}
f0106eef:	c9                   	leave  
f0106ef0:	c3                   	ret    
	lapic = mmio_map_region(lapicaddr, 4096);
f0106ef1:	83 ec 08             	sub    $0x8,%esp
f0106ef4:	68 00 10 00 00       	push   $0x1000
f0106ef9:	50                   	push   %eax
f0106efa:	e8 71 a8 ff ff       	call   f0101770 <mmio_map_region>
f0106eff:	a3 c0 b3 16 f0       	mov    %eax,0xf016b3c0
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106f04:	ba 27 01 00 00       	mov    $0x127,%edx
f0106f09:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106f0e:	e8 a7 ff ff ff       	call   f0106eba <lapicw>
	lapicw(TDCR, X1);
f0106f13:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106f18:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106f1d:	e8 98 ff ff ff       	call   f0106eba <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106f22:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106f27:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106f2c:	e8 89 ff ff ff       	call   f0106eba <lapicw>
	lapicw(TICR, 10000000); 
f0106f31:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106f36:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106f3b:	e8 7a ff ff ff       	call   f0106eba <lapicw>
	if (thiscpu != bootcpu)
f0106f40:	e8 d2 a5 01 00       	call   f0121517 <cpunum>
f0106f45:	6b c0 74             	imul   $0x74,%eax,%eax
f0106f48:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f0106f4d:	83 c4 10             	add    $0x10,%esp
f0106f50:	39 05 00 b0 16 f0    	cmp    %eax,0xf016b000
f0106f56:	74 0f                	je     f0106f67 <lapic_init+0x99>
		lapicw(LINT0, MASKED);
f0106f58:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106f5d:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106f62:	e8 53 ff ff ff       	call   f0106eba <lapicw>
	lapicw(LINT1, MASKED);
f0106f67:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106f6c:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106f71:	e8 44 ff ff ff       	call   f0106eba <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106f76:	a1 c0 b3 16 f0       	mov    0xf016b3c0,%eax
f0106f7b:	8b 40 30             	mov    0x30(%eax),%eax
f0106f7e:	c1 e8 10             	shr    $0x10,%eax
f0106f81:	a8 fc                	test   $0xfc,%al
f0106f83:	75 7f                	jne    f0107004 <lapic_init+0x136>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106f85:	ba 33 00 00 00       	mov    $0x33,%edx
f0106f8a:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106f8f:	e8 26 ff ff ff       	call   f0106eba <lapicw>
	lapicw(ESR, 0);
f0106f94:	ba 00 00 00 00       	mov    $0x0,%edx
f0106f99:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106f9e:	e8 17 ff ff ff       	call   f0106eba <lapicw>
	lapicw(ESR, 0);
f0106fa3:	ba 00 00 00 00       	mov    $0x0,%edx
f0106fa8:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106fad:	e8 08 ff ff ff       	call   f0106eba <lapicw>
	lapicw(EOI, 0);
f0106fb2:	ba 00 00 00 00       	mov    $0x0,%edx
f0106fb7:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106fbc:	e8 f9 fe ff ff       	call   f0106eba <lapicw>
	lapicw(ICRHI, 0);
f0106fc1:	ba 00 00 00 00       	mov    $0x0,%edx
f0106fc6:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106fcb:	e8 ea fe ff ff       	call   f0106eba <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106fd0:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106fd5:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106fda:	e8 db fe ff ff       	call   f0106eba <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106fdf:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
f0106fe5:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106feb:	f6 c4 10             	test   $0x10,%ah
f0106fee:	75 f5                	jne    f0106fe5 <lapic_init+0x117>
	lapicw(TPR, 0);
f0106ff0:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ff5:	b8 20 00 00 00       	mov    $0x20,%eax
f0106ffa:	e8 bb fe ff ff       	call   f0106eba <lapicw>
f0106fff:	e9 eb fe ff ff       	jmp    f0106eef <lapic_init+0x21>
		lapicw(PCINT, MASKED);
f0107004:	ba 00 00 01 00       	mov    $0x10000,%edx
f0107009:	b8 d0 00 00 00       	mov    $0xd0,%eax
f010700e:	e8 a7 fe ff ff       	call   f0106eba <lapicw>
f0107013:	e9 6d ff ff ff       	jmp    f0106f85 <lapic_init+0xb7>

f0107018 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0107018:	83 3d c0 b3 16 f0 00 	cmpl   $0x0,0xf016b3c0
f010701f:	74 17                	je     f0107038 <lapic_eoi+0x20>
{
f0107021:	55                   	push   %ebp
f0107022:	89 e5                	mov    %esp,%ebp
f0107024:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0107027:	ba 00 00 00 00       	mov    $0x0,%edx
f010702c:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0107031:	e8 84 fe ff ff       	call   f0106eba <lapicw>
}
f0107036:	c9                   	leave  
f0107037:	c3                   	ret    
f0107038:	c3                   	ret    

f0107039 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0107039:	55                   	push   %ebp
f010703a:	89 e5                	mov    %esp,%ebp
f010703c:	56                   	push   %esi
f010703d:	53                   	push   %ebx
f010703e:	8b 75 08             	mov    0x8(%ebp),%esi
f0107041:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0107044:	b8 0f 00 00 00       	mov    $0xf,%eax
f0107049:	ba 70 00 00 00       	mov    $0x70,%edx
f010704e:	ee                   	out    %al,(%dx)
f010704f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0107054:	ba 71 00 00 00       	mov    $0x71,%edx
f0107059:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f010705a:	83 3d 88 ed 5d f0 00 	cmpl   $0x0,0xf05ded88
f0107061:	74 7e                	je     f01070e1 <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0107063:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f010706a:	00 00 
	wrv[1] = addr >> 4;
f010706c:	89 d8                	mov    %ebx,%eax
f010706e:	c1 e8 04             	shr    $0x4,%eax
f0107071:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0107077:	c1 e6 18             	shl    $0x18,%esi
f010707a:	89 f2                	mov    %esi,%edx
f010707c:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107081:	e8 34 fe ff ff       	call   f0106eba <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0107086:	ba 00 c5 00 00       	mov    $0xc500,%edx
f010708b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107090:	e8 25 fe ff ff       	call   f0106eba <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0107095:	ba 00 85 00 00       	mov    $0x8500,%edx
f010709a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010709f:	e8 16 fe ff ff       	call   f0106eba <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01070a4:	c1 eb 0c             	shr    $0xc,%ebx
f01070a7:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f01070aa:	89 f2                	mov    %esi,%edx
f01070ac:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01070b1:	e8 04 fe ff ff       	call   f0106eba <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01070b6:	89 da                	mov    %ebx,%edx
f01070b8:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01070bd:	e8 f8 fd ff ff       	call   f0106eba <lapicw>
		lapicw(ICRHI, apicid << 24);
f01070c2:	89 f2                	mov    %esi,%edx
f01070c4:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01070c9:	e8 ec fd ff ff       	call   f0106eba <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01070ce:	89 da                	mov    %ebx,%edx
f01070d0:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01070d5:	e8 e0 fd ff ff       	call   f0106eba <lapicw>
		microdelay(200);
	}
}
f01070da:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01070dd:	5b                   	pop    %ebx
f01070de:	5e                   	pop    %esi
f01070df:	5d                   	pop    %ebp
f01070e0:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01070e1:	68 67 04 00 00       	push   $0x467
f01070e6:	68 0c 81 10 f0       	push   $0xf010810c
f01070eb:	68 9f 00 00 00       	push   $0x9f
f01070f0:	68 bc a6 10 f0       	push   $0xf010a6bc
f01070f5:	e8 4f 8f ff ff       	call   f0100049 <_panic>

f01070fa <lapic_ipi>:

void
lapic_ipi(int vector)
{
f01070fa:	55                   	push   %ebp
f01070fb:	89 e5                	mov    %esp,%ebp
f01070fd:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0107100:	8b 55 08             	mov    0x8(%ebp),%edx
f0107103:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0107109:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010710e:	e8 a7 fd ff ff       	call   f0106eba <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0107113:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
f0107119:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010711f:	f6 c4 10             	test   $0x10,%ah
f0107122:	75 f5                	jne    f0107119 <lapic_ipi+0x1f>
		;
}
f0107124:	c9                   	leave  
f0107125:	c3                   	ret    

f0107126 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0107126:	55                   	push   %ebp
f0107127:	89 e5                	mov    %esp,%ebp
f0107129:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010712c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0107132:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107135:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0107138:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f010713f:	5d                   	pop    %ebp
f0107140:	c3                   	ret    

f0107141 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0107141:	55                   	push   %ebp
f0107142:	89 e5                	mov    %esp,%ebp
f0107144:	56                   	push   %esi
f0107145:	53                   	push   %ebx
f0107146:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0107149:	83 ec 08             	sub    $0x8,%esp
f010714c:	68 a0 a7 10 f0       	push   $0xf010a7a0
f0107151:	68 20 80 10 f0       	push   $0xf0108020
f0107156:	e8 0a d1 ff ff       	call   f0104265 <cprintf>
	cprintf("in %s\n", __FUNCTION__);
f010715b:	83 c4 08             	add    $0x8,%esp
f010715e:	68 98 a7 10 f0       	push   $0xf010a798
f0107163:	68 20 80 10 f0       	push   $0xf0108020
f0107168:	e8 f8 d0 ff ff       	call   f0104265 <cprintf>
	return lock->locked && lock->cpu == thiscpu;
f010716d:	83 c4 10             	add    $0x10,%esp
f0107170:	83 3b 00             	cmpl   $0x0,(%ebx)
f0107173:	75 12                	jne    f0107187 <spin_lock+0x46>
	asm volatile("lock; xchgl %0, %1"
f0107175:	ba 01 00 00 00       	mov    $0x1,%edx
f010717a:	89 d0                	mov    %edx,%eax
f010717c:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f010717f:	85 c0                	test   %eax,%eax
f0107181:	74 36                	je     f01071b9 <spin_lock+0x78>
		asm volatile ("pause");
f0107183:	f3 90                	pause  
f0107185:	eb f3                	jmp    f010717a <spin_lock+0x39>
	return lock->locked && lock->cpu == thiscpu;
f0107187:	8b 73 08             	mov    0x8(%ebx),%esi
f010718a:	e8 88 a3 01 00       	call   f0121517 <cpunum>
f010718f:	6b c0 74             	imul   $0x74,%eax,%eax
f0107192:	05 20 b0 16 f0       	add    $0xf016b020,%eax
	if (holding(lk))
f0107197:	39 c6                	cmp    %eax,%esi
f0107199:	75 da                	jne    f0107175 <spin_lock+0x34>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010719b:	8b 5b 04             	mov    0x4(%ebx),%ebx
f010719e:	e8 74 a3 01 00       	call   f0121517 <cpunum>
f01071a3:	83 ec 0c             	sub    $0xc,%esp
f01071a6:	53                   	push   %ebx
f01071a7:	50                   	push   %eax
f01071a8:	68 28 a7 10 f0       	push   $0xf010a728
f01071ad:	6a 43                	push   $0x43
f01071af:	68 df a6 10 f0       	push   $0xf010a6df
f01071b4:	e8 90 8e ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01071b9:	e8 59 a3 01 00       	call   f0121517 <cpunum>
f01071be:	6b c0 74             	imul   $0x74,%eax,%eax
f01071c1:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01071c6:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01071c9:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01071cb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01071d0:	83 f8 09             	cmp    $0x9,%eax
f01071d3:	7f 16                	jg     f01071eb <spin_lock+0xaa>
f01071d5:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01071db:	76 0e                	jbe    f01071eb <spin_lock+0xaa>
		pcs[i] = ebp[1];          // saved %eip
f01071dd:	8b 4a 04             	mov    0x4(%edx),%ecx
f01071e0:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01071e4:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f01071e6:	83 c0 01             	add    $0x1,%eax
f01071e9:	eb e5                	jmp    f01071d0 <spin_lock+0x8f>
	for (; i < 10; i++)
f01071eb:	83 f8 09             	cmp    $0x9,%eax
f01071ee:	7f 0d                	jg     f01071fd <spin_lock+0xbc>
		pcs[i] = 0;
f01071f0:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f01071f7:	00 
	for (; i < 10; i++)
f01071f8:	83 c0 01             	add    $0x1,%eax
f01071fb:	eb ee                	jmp    f01071eb <spin_lock+0xaa>
	get_caller_pcs(lk->pcs);
#endif
}
f01071fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107200:	5b                   	pop    %ebx
f0107201:	5e                   	pop    %esi
f0107202:	5d                   	pop    %ebp
f0107203:	c3                   	ret    

f0107204 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0107204:	55                   	push   %ebp
f0107205:	89 e5                	mov    %esp,%ebp
f0107207:	57                   	push   %edi
f0107208:	56                   	push   %esi
f0107209:	53                   	push   %ebx
f010720a:	83 ec 54             	sub    $0x54,%esp
f010720d:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("in %s\n", __FUNCTION__);
f0107210:	68 8c a7 10 f0       	push   $0xf010a78c
f0107215:	68 20 80 10 f0       	push   $0xf0108020
f010721a:	e8 46 d0 ff ff       	call   f0104265 <cprintf>
	cprintf("in %s\n", __FUNCTION__);
f010721f:	83 c4 08             	add    $0x8,%esp
f0107222:	68 98 a7 10 f0       	push   $0xf010a798
f0107227:	68 20 80 10 f0       	push   $0xf0108020
f010722c:	e8 34 d0 ff ff       	call   f0104265 <cprintf>
	return lock->locked && lock->cpu == thiscpu;
f0107231:	83 c4 10             	add    $0x10,%esp
f0107234:	83 3e 00             	cmpl   $0x0,(%esi)
f0107237:	75 35                	jne    f010726e <spin_unlock+0x6a>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0107239:	83 ec 04             	sub    $0x4,%esp
f010723c:	6a 28                	push   $0x28
f010723e:	8d 46 0c             	lea    0xc(%esi),%eax
f0107241:	50                   	push   %eax
f0107242:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0107245:	53                   	push   %ebx
f0107246:	e8 c4 f6 ff ff       	call   f010690f <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f010724b:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f010724e:	0f b6 38             	movzbl (%eax),%edi
f0107251:	8b 76 04             	mov    0x4(%esi),%esi
f0107254:	e8 be a2 01 00       	call   f0121517 <cpunum>
f0107259:	57                   	push   %edi
f010725a:	56                   	push   %esi
f010725b:	50                   	push   %eax
f010725c:	68 54 a7 10 f0       	push   $0xf010a754
f0107261:	e8 ff cf ff ff       	call   f0104265 <cprintf>
f0107266:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0107269:	8d 7d a8             	lea    -0x58(%ebp),%edi
f010726c:	eb 4e                	jmp    f01072bc <spin_unlock+0xb8>
	return lock->locked && lock->cpu == thiscpu;
f010726e:	8b 5e 08             	mov    0x8(%esi),%ebx
f0107271:	e8 a1 a2 01 00       	call   f0121517 <cpunum>
f0107276:	6b c0 74             	imul   $0x74,%eax,%eax
f0107279:	05 20 b0 16 f0       	add    $0xf016b020,%eax
	if (!holding(lk)) {
f010727e:	39 c3                	cmp    %eax,%ebx
f0107280:	75 b7                	jne    f0107239 <spin_unlock+0x35>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0107282:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0107289:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0107290:	b8 00 00 00 00       	mov    $0x0,%eax
f0107295:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0107298:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010729b:	5b                   	pop    %ebx
f010729c:	5e                   	pop    %esi
f010729d:	5f                   	pop    %edi
f010729e:	5d                   	pop    %ebp
f010729f:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f01072a0:	83 ec 08             	sub    $0x8,%esp
f01072a3:	ff 36                	pushl  (%esi)
f01072a5:	68 06 a7 10 f0       	push   $0xf010a706
f01072aa:	e8 b6 cf ff ff       	call   f0104265 <cprintf>
f01072af:	83 c4 10             	add    $0x10,%esp
f01072b2:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f01072b5:	8d 45 e8             	lea    -0x18(%ebp),%eax
f01072b8:	39 c3                	cmp    %eax,%ebx
f01072ba:	74 40                	je     f01072fc <spin_unlock+0xf8>
f01072bc:	89 de                	mov    %ebx,%esi
f01072be:	8b 03                	mov    (%ebx),%eax
f01072c0:	85 c0                	test   %eax,%eax
f01072c2:	74 38                	je     f01072fc <spin_unlock+0xf8>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01072c4:	83 ec 08             	sub    $0x8,%esp
f01072c7:	57                   	push   %edi
f01072c8:	50                   	push   %eax
f01072c9:	e8 92 e9 ff ff       	call   f0105c60 <debuginfo_eip>
f01072ce:	83 c4 10             	add    $0x10,%esp
f01072d1:	85 c0                	test   %eax,%eax
f01072d3:	78 cb                	js     f01072a0 <spin_unlock+0x9c>
					pcs[i] - info.eip_fn_addr);
f01072d5:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01072d7:	83 ec 04             	sub    $0x4,%esp
f01072da:	89 c2                	mov    %eax,%edx
f01072dc:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01072df:	52                   	push   %edx
f01072e0:	ff 75 b0             	pushl  -0x50(%ebp)
f01072e3:	ff 75 b4             	pushl  -0x4c(%ebp)
f01072e6:	ff 75 ac             	pushl  -0x54(%ebp)
f01072e9:	ff 75 a8             	pushl  -0x58(%ebp)
f01072ec:	50                   	push   %eax
f01072ed:	68 ef a6 10 f0       	push   $0xf010a6ef
f01072f2:	e8 6e cf ff ff       	call   f0104265 <cprintf>
f01072f7:	83 c4 20             	add    $0x20,%esp
f01072fa:	eb b6                	jmp    f01072b2 <spin_unlock+0xae>
		panic("spin_unlock");
f01072fc:	83 ec 04             	sub    $0x4,%esp
f01072ff:	68 0e a7 10 f0       	push   $0xf010a70e
f0107304:	6a 6a                	push   $0x6a
f0107306:	68 df a6 10 f0       	push   $0xf010a6df
f010730b:	e8 39 8d ff ff       	call   f0100049 <_panic>

f0107310 <read_eeprom>:
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_buffer[N_TXDESC][TX_PKT_SIZE];
uint64_t mac_address = 0;

uint16_t read_eeprom(uint32_t addr)
{
f0107310:	55                   	push   %ebp
f0107311:	89 e5                	mov    %esp,%ebp
    base->EERD = E1000_EEPROM_RD_START | addr;
f0107313:	8b 15 68 dd 5d f0    	mov    0xf05ddd68,%edx
f0107319:	8b 45 08             	mov    0x8(%ebp),%eax
f010731c:	83 c8 01             	or     $0x1,%eax
f010731f:	89 42 14             	mov    %eax,0x14(%edx)
	while ((base->EERD & E1000_EEPROM_RD_START) == 1); // Continually poll until we have a response
f0107322:	8b 42 14             	mov    0x14(%edx),%eax
f0107325:	a8 01                	test   $0x1,%al
f0107327:	75 f9                	jne    f0107322 <read_eeprom+0x12>
	return base->EERD >> 16;
f0107329:	8b 42 14             	mov    0x14(%edx),%eax
f010732c:	c1 e8 10             	shr    $0x10,%eax
}
f010732f:	5d                   	pop    %ebp
f0107330:	c3                   	ret    

f0107331 <read_eeprom_mac_addr>:

uint64_t read_eeprom_mac_addr(){
f0107331:	55                   	push   %ebp
f0107332:	89 e5                	mov    %esp,%ebp
f0107334:	57                   	push   %edi
f0107335:	56                   	push   %esi
f0107336:	53                   	push   %ebx
f0107337:	83 ec 0c             	sub    $0xc,%esp
	if (mac_address > 0)
f010733a:	a1 60 dd 5d f0       	mov    0xf05ddd60,%eax
f010733f:	8b 15 64 dd 5d f0    	mov    0xf05ddd64,%edx
f0107345:	89 d7                	mov    %edx,%edi
f0107347:	09 c7                	or     %eax,%edi
f0107349:	74 08                	je     f0107353 <read_eeprom_mac_addr+0x22>
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
    uint64_t word2 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD2);
    uint64_t word3 = (uint64_t)0x8000;
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
    return mac_address;
}
f010734b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010734e:	5b                   	pop    %ebx
f010734f:	5e                   	pop    %esi
f0107350:	5f                   	pop    %edi
f0107351:	5d                   	pop    %ebp
f0107352:	c3                   	ret    
    uint64_t word0 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD0);
f0107353:	83 ec 0c             	sub    $0xc,%esp
f0107356:	6a 00                	push   $0x0
f0107358:	e8 b3 ff ff ff       	call   f0107310 <read_eeprom>
f010735d:	89 c3                	mov    %eax,%ebx
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
f010735f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
f0107366:	e8 a5 ff ff ff       	call   f0107310 <read_eeprom>
f010736b:	89 c6                	mov    %eax,%esi
    uint64_t word2 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD2);
f010736d:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
f0107374:	e8 97 ff ff ff       	call   f0107310 <read_eeprom>
f0107379:	0f b7 d0             	movzwl %ax,%edx
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
f010737c:	0f b7 f6             	movzwl %si,%esi
f010737f:	bf 00 00 00 00       	mov    $0x0,%edi
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
f0107384:	0f a4 f7 10          	shld   $0x10,%esi,%edi
f0107388:	c1 e6 10             	shl    $0x10,%esi
f010738b:	09 fa                	or     %edi,%edx
    uint64_t word0 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD0);
f010738d:	0f b7 db             	movzwl %bx,%ebx
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
f0107390:	09 f3                	or     %esi,%ebx
f0107392:	89 d8                	mov    %ebx,%eax
f0107394:	81 ca 00 00 00 80    	or     $0x80000000,%edx
f010739a:	89 1d 60 dd 5d f0    	mov    %ebx,0xf05ddd60
f01073a0:	89 15 64 dd 5d f0    	mov    %edx,0xf05ddd64
    return mac_address;
f01073a6:	83 c4 10             	add    $0x10,%esp
f01073a9:	eb a0                	jmp    f010734b <read_eeprom_mac_addr+0x1a>

f01073ab <e1000_tx_init>:

int
e1000_tx_init()
{
f01073ab:	55                   	push   %ebp
f01073ac:	89 e5                	mov    %esp,%ebp
f01073ae:	57                   	push   %edi
f01073af:	56                   	push   %esi
f01073b0:	53                   	push   %ebx
f01073b1:	83 ec 18             	sub    $0x18,%esp
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01073b4:	6a 01                	push   $0x1
f01073b6:	e8 97 9f ff ff       	call   f0101352 <page_alloc>
	return (pp - pages) << PGSHIFT;
f01073bb:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f01073c1:	c1 f8 03             	sar    $0x3,%eax
f01073c4:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01073c7:	89 c2                	mov    %eax,%edx
f01073c9:	c1 ea 0c             	shr    $0xc,%edx
f01073cc:	83 c4 10             	add    $0x10,%esp
f01073cf:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f01073d5:	0f 83 e5 00 00 00    	jae    f01074c0 <e1000_tx_init+0x115>
	return (void *)(pa + KERNBASE);
f01073db:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01073e0:	a3 a0 ed 5d f0       	mov    %eax,0xf05deda0
f01073e5:	ba c0 ed 65 f0       	mov    $0xf065edc0,%edx
f01073ea:	b8 c0 ed 65 00       	mov    $0x65edc0,%eax
f01073ef:	89 c6                	mov    %eax,%esi
f01073f1:	bf 00 00 00 00       	mov    $0x0,%edi
	tx_descs = (struct tx_desc *)page2kva(page);
f01073f6:	b9 00 00 00 00       	mov    $0x0,%ecx
	if ((uint32_t)kva < KERNBASE)
f01073fb:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0107401:	0f 86 cb 00 00 00    	jbe    f01074d2 <e1000_tx_init+0x127>
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(tx_buffer[i]);
f0107407:	a1 a0 ed 5d f0       	mov    0xf05deda0,%eax
f010740c:	89 34 08             	mov    %esi,(%eax,%ecx,1)
f010740f:	89 7c 08 04          	mov    %edi,0x4(%eax,%ecx,1)
		tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0107413:	8b 1d a0 ed 5d f0    	mov    0xf05deda0,%ebx
f0107419:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
f010741c:	80 48 0b 05          	orb    $0x5,0xb(%eax)
		tx_descs[i].status |= E1000_TX_STATUS_DD;
f0107420:	80 48 0c 01          	orb    $0x1,0xc(%eax)
		tx_descs[i].length = 0;
f0107424:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		tx_descs[i].cso = 0;
f010742a:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
		tx_descs[i].css = 0;
f010742e:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
		tx_descs[i].special = 0;
f0107432:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
f0107438:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f010743e:	83 c1 10             	add    $0x10,%ecx
f0107441:	81 c6 ee 05 00 00    	add    $0x5ee,%esi
f0107447:	83 d7 00             	adc    $0x0,%edi
	for(int i = 0; i < N_TXDESC; i++){
f010744a:	81 fa c0 db 6b f0    	cmp    $0xf06bdbc0,%edx
f0107450:	75 a9                	jne    f01073fb <e1000_tx_init+0x50>
	}
	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->TDBAL = (uint32_t)PADDR(tx_descs);
f0107452:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f0107457:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f010745d:	0f 86 81 00 00 00    	jbe    f01074e4 <e1000_tx_init+0x139>
	return (physaddr_t)kva - KERNBASE;
f0107463:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f0107469:	89 98 00 38 00 00    	mov    %ebx,0x3800(%eax)
	base->TDBAH = (uint32_t)0;
f010746f:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f0107476:	00 00 00 
	// base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc);
f0107479:	c7 80 08 38 00 00 00 	movl   $0x1000,0x3808(%eax)
f0107480:	10 00 00 

	base->TDH = 0;
f0107483:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f010748a:	00 00 00 
	base->TDT = 0;
f010748d:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f0107494:	00 00 00 

	base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
f0107497:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f010749d:	81 ca 0a 01 04 00    	or     $0x4010a,%edx
f01074a3:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	base->TIPG = E1000_TIPG_DEFAULT;
f01074a9:	c7 80 10 04 00 00 0a 	movl   $0x60100a,0x410(%eax)
f01074b0:	10 60 00 
	return 0;
}
f01074b3:	b8 00 00 00 00       	mov    $0x0,%eax
f01074b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01074bb:	5b                   	pop    %ebx
f01074bc:	5e                   	pop    %esi
f01074bd:	5f                   	pop    %edi
f01074be:	5d                   	pop    %ebp
f01074bf:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01074c0:	50                   	push   %eax
f01074c1:	68 0c 81 10 f0       	push   $0xf010810c
f01074c6:	6a 58                	push   $0x58
f01074c8:	68 91 92 10 f0       	push   $0xf0109291
f01074cd:	e8 77 8b ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01074d2:	52                   	push   %edx
f01074d3:	68 30 81 10 f0       	push   $0xf0108130
f01074d8:	6a 29                	push   $0x29
f01074da:	68 aa a7 10 f0       	push   $0xf010a7aa
f01074df:	e8 65 8b ff ff       	call   f0100049 <_panic>
f01074e4:	53                   	push   %ebx
f01074e5:	68 30 81 10 f0       	push   $0xf0108130
f01074ea:	6a 34                	push   $0x34
f01074ec:	68 aa a7 10 f0       	push   $0xf010a7aa
f01074f1:	e8 53 8b ff ff       	call   f0100049 <_panic>

f01074f6 <e1000_rx_init>:
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_buffer[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx_init()
{
f01074f6:	55                   	push   %ebp
f01074f7:	89 e5                	mov    %esp,%ebp
f01074f9:	57                   	push   %edi
f01074fa:	56                   	push   %esi
f01074fb:	53                   	push   %ebx
f01074fc:	83 ec 18             	sub    $0x18,%esp
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01074ff:	6a 01                	push   $0x1
f0107501:	e8 4c 9e ff ff       	call   f0101352 <page_alloc>
	if(page == NULL)
f0107506:	83 c4 10             	add    $0x10,%esp
f0107509:	85 c0                	test   %eax,%eax
f010750b:	0f 84 e9 00 00 00    	je     f01075fa <e1000_rx_init+0x104>
	return (pp - pages) << PGSHIFT;
f0107511:	2b 05 90 ed 5d f0    	sub    0xf05ded90,%eax
f0107517:	c1 f8 03             	sar    $0x3,%eax
f010751a:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010751d:	89 c2                	mov    %eax,%edx
f010751f:	c1 ea 0c             	shr    $0xc,%edx
f0107522:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f0107528:	0f 83 e0 00 00 00    	jae    f010760e <e1000_rx_init+0x118>
	return (void *)(pa + KERNBASE);
f010752e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107533:	a3 a4 ed 5d f0       	mov    %eax,0xf05deda4
f0107538:	b8 c0 ed 5d f0       	mov    $0xf05dedc0,%eax
f010753d:	b9 c0 ed 5d 00       	mov    $0x5dedc0,%ecx
f0107542:	bb 00 00 00 00       	mov    $0x0,%ebx
f0107547:	be c0 ed 65 f0       	mov    $0xf065edc0,%esi
			panic("page_alloc panic\n");
	rx_descs = (struct rx_desc *)page2kva(page);
f010754c:	ba 00 00 00 00       	mov    $0x0,%edx
	if ((uint32_t)kva < KERNBASE)
f0107551:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0107556:	0f 86 c4 00 00 00    	jbe    f0107620 <e1000_rx_init+0x12a>
	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for(int i = 0; i < N_RXDESC; i++){
		rx_descs[i].addr = PADDR(rx_buffer[i]);
f010755c:	8b 3d a4 ed 5d f0    	mov    0xf05deda4,%edi
f0107562:	89 0c 17             	mov    %ecx,(%edi,%edx,1)
f0107565:	89 5c 17 04          	mov    %ebx,0x4(%edi,%edx,1)
f0107569:	05 00 08 00 00       	add    $0x800,%eax
f010756e:	83 c2 10             	add    $0x10,%edx
f0107571:	81 c1 00 08 00 00    	add    $0x800,%ecx
f0107577:	83 d3 00             	adc    $0x0,%ebx
	for(int i = 0; i < N_RXDESC; i++){
f010757a:	39 f0                	cmp    %esi,%eax
f010757c:	75 d3                	jne    f0107551 <e1000_rx_init+0x5b>
	}

	uint64_t macaddr_local = read_eeprom_mac_addr();
f010757e:	e8 ae fd ff ff       	call   f0107331 <read_eeprom_mac_addr>

	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->RCTL |= E1000_RCTL_EN|E1000_RCTL_BSIZE_2048|E1000_RCTL_SECRC;
f0107583:	8b 0d 68 dd 5d f0    	mov    0xf05ddd68,%ecx
f0107589:	8b 99 00 01 00 00    	mov    0x100(%ecx),%ebx
f010758f:	81 cb 02 00 00 04    	or     $0x4000002,%ebx
f0107595:	89 99 00 01 00 00    	mov    %ebx,0x100(%ecx)
	base->RDBAL = PADDR(rx_descs);
f010759b:	8b 1d a4 ed 5d f0    	mov    0xf05deda4,%ebx
f01075a1:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01075a7:	0f 86 85 00 00 00    	jbe    f0107632 <e1000_rx_init+0x13c>
	return (physaddr_t)kva - KERNBASE;
f01075ad:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f01075b3:	89 99 00 28 00 00    	mov    %ebx,0x2800(%ecx)
	base->RDBAH = (uint32_t)0;
f01075b9:	c7 81 04 28 00 00 00 	movl   $0x0,0x2804(%ecx)
f01075c0:	00 00 00 
	base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
f01075c3:	c7 81 08 28 00 00 00 	movl   $0x1000,0x2808(%ecx)
f01075ca:	10 00 00 
	base->RDH = 0;
f01075cd:	c7 81 10 28 00 00 00 	movl   $0x0,0x2810(%ecx)
f01075d4:	00 00 00 
	base->RDT = N_RXDESC-1;
f01075d7:	c7 81 18 28 00 00 ff 	movl   $0xff,0x2818(%ecx)
f01075de:	00 00 00 
	// base->RAL = QEMU_MAC_LOW;
	// base->RAH = QEMU_MAC_HIGH;

	base->RAL = (uint32_t)(macaddr_local & 0xffffffff);
f01075e1:	89 81 1c 3a 00 00    	mov    %eax,0x3a1c(%ecx)
	base->RAH = (uint32_t)(macaddr_local>>32);
f01075e7:	89 91 20 3a 00 00    	mov    %edx,0x3a20(%ecx)

	return 0;
}
f01075ed:	b8 00 00 00 00       	mov    $0x0,%eax
f01075f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01075f5:	5b                   	pop    %ebx
f01075f6:	5e                   	pop    %esi
f01075f7:	5f                   	pop    %edi
f01075f8:	5d                   	pop    %ebp
f01075f9:	c3                   	ret    
			panic("page_alloc panic\n");
f01075fa:	83 ec 04             	sub    $0x4,%esp
f01075fd:	68 b7 a7 10 f0       	push   $0xf010a7b7
f0107602:	6a 4c                	push   $0x4c
f0107604:	68 aa a7 10 f0       	push   $0xf010a7aa
f0107609:	e8 3b 8a ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010760e:	50                   	push   %eax
f010760f:	68 0c 81 10 f0       	push   $0xf010810c
f0107614:	6a 58                	push   $0x58
f0107616:	68 91 92 10 f0       	push   $0xf0109291
f010761b:	e8 29 8a ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107620:	50                   	push   %eax
f0107621:	68 30 81 10 f0       	push   $0xf0108130
f0107626:	6a 51                	push   $0x51
f0107628:	68 aa a7 10 f0       	push   $0xf010a7aa
f010762d:	e8 17 8a ff ff       	call   f0100049 <_panic>
f0107632:	53                   	push   %ebx
f0107633:	68 30 81 10 f0       	push   $0xf0108130
f0107638:	6a 5a                	push   $0x5a
f010763a:	68 aa a7 10 f0       	push   $0xf010a7aa
f010763f:	e8 05 8a ff ff       	call   f0100049 <_panic>

f0107644 <pci_e1000_attach>:

int
pci_e1000_attach(struct pci_func *pcif)
{
f0107644:	55                   	push   %ebp
f0107645:	89 e5                	mov    %esp,%ebp
f0107647:	53                   	push   %ebx
f0107648:	83 ec 0c             	sub    $0xc,%esp
f010764b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f010764e:	68 e8 a7 10 f0       	push   $0xf010a7e8
f0107653:	68 20 80 10 f0       	push   $0xf0108020
f0107658:	e8 08 cc ff ff       	call   f0104265 <cprintf>
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
f010765d:	89 1c 24             	mov    %ebx,(%esp)
f0107660:	e8 a8 05 00 00       	call   f0107c0d <pci_func_enable>
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f0107665:	83 c4 08             	add    $0x8,%esp
f0107668:	ff 73 2c             	pushl  0x2c(%ebx)
f010766b:	ff 73 14             	pushl  0x14(%ebx)
f010766e:	e8 fd a0 ff ff       	call   f0101770 <mmio_map_region>
f0107673:	a3 68 dd 5d f0       	mov    %eax,0xf05ddd68
	e1000_tx_init();
f0107678:	e8 2e fd ff ff       	call   f01073ab <e1000_tx_init>
	e1000_rx_init();
f010767d:	e8 74 fe ff ff       	call   f01074f6 <e1000_rx_init>

	return 0;
}
f0107682:	b8 00 00 00 00       	mov    $0x0,%eax
f0107687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010768a:	c9                   	leave  
f010768b:	c3                   	ret    

f010768c <e1000_tx>:

int
e1000_tx(const void *buf, uint32_t len)
{
f010768c:	55                   	push   %ebp
f010768d:	89 e5                	mov    %esp,%ebp
f010768f:	53                   	push   %ebx
f0107690:	83 ec 0c             	sub    $0xc,%esp
f0107693:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address
	cprintf("in %s\n", __FUNCTION__);
f0107696:	68 dc a7 10 f0       	push   $0xf010a7dc
f010769b:	68 20 80 10 f0       	push   $0xf0108020
f01076a0:	e8 c0 cb ff ff       	call   f0104265 <cprintf>
	if(tx_descs[base->TDT].status & E1000_TX_STATUS_DD){
f01076a5:	a1 a0 ed 5d f0       	mov    0xf05deda0,%eax
f01076aa:	8b 0d 68 dd 5d f0    	mov    0xf05ddd68,%ecx
f01076b0:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01076b6:	c1 e2 04             	shl    $0x4,%edx
f01076b9:	83 c4 10             	add    $0x10,%esp
f01076bc:	f6 44 10 0c 01       	testb  $0x1,0xc(%eax,%edx,1)
f01076c1:	0f 84 e6 00 00 00    	je     f01077ad <e1000_tx+0x121>
		tx_descs[base->TDT].status ^= E1000_TX_STATUS_DD;
f01076c7:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01076cd:	c1 e2 04             	shl    $0x4,%edx
f01076d0:	80 74 10 0c 01       	xorb   $0x1,0xc(%eax,%edx,1)
		memset(KADDR(tx_descs[base->TDT].addr), 0 , TX_PKT_SIZE);
f01076d5:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01076db:	c1 e2 04             	shl    $0x4,%edx
f01076de:	8b 04 10             	mov    (%eax,%edx,1),%eax
	if (PGNUM(pa) >= npages)
f01076e1:	89 c2                	mov    %eax,%edx
f01076e3:	c1 ea 0c             	shr    $0xc,%edx
f01076e6:	3b 15 88 ed 5d f0    	cmp    0xf05ded88,%edx
f01076ec:	0f 83 94 00 00 00    	jae    f0107786 <e1000_tx+0xfa>
f01076f2:	83 ec 04             	sub    $0x4,%esp
f01076f5:	68 ee 05 00 00       	push   $0x5ee
f01076fa:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01076fc:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107701:	50                   	push   %eax
f0107702:	e8 c0 f1 ff ff       	call   f01068c7 <memset>
		memcpy(KADDR(tx_descs[base->TDT].addr), buf, len);
f0107707:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f010770c:	8b 80 18 38 00 00    	mov    0x3818(%eax),%eax
f0107712:	c1 e0 04             	shl    $0x4,%eax
f0107715:	03 05 a0 ed 5d f0    	add    0xf05deda0,%eax
f010771b:	8b 00                	mov    (%eax),%eax
	if (PGNUM(pa) >= npages)
f010771d:	89 c2                	mov    %eax,%edx
f010771f:	c1 ea 0c             	shr    $0xc,%edx
f0107722:	83 c4 10             	add    $0x10,%esp
f0107725:	39 15 88 ed 5d f0    	cmp    %edx,0xf05ded88
f010772b:	76 6b                	jbe    f0107798 <e1000_tx+0x10c>
f010772d:	83 ec 04             	sub    $0x4,%esp
f0107730:	53                   	push   %ebx
f0107731:	ff 75 08             	pushl  0x8(%ebp)
	return (void *)(pa + KERNBASE);
f0107734:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107739:	50                   	push   %eax
f010773a:	e8 32 f2 ff ff       	call   f0106971 <memcpy>
		tx_descs[base->TDT].length = len;
f010773f:	8b 0d a0 ed 5d f0    	mov    0xf05deda0,%ecx
f0107745:	8b 15 68 dd 5d f0    	mov    0xf05ddd68,%edx
f010774b:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f0107751:	c1 e0 04             	shl    $0x4,%eax
f0107754:	66 89 5c 01 08       	mov    %bx,0x8(%ecx,%eax,1)
		tx_descs[base->TDT].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0107759:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f010775f:	c1 e0 04             	shl    $0x4,%eax
f0107762:	80 4c 01 0b 05       	orb    $0x5,0xb(%ecx,%eax,1)

		base->TDT = (base->TDT + 1)%N_TXDESC;
f0107767:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f010776d:	83 c0 01             	add    $0x1,%eax
f0107770:	0f b6 c0             	movzbl %al,%eax
f0107773:	89 82 18 38 00 00    	mov    %eax,0x3818(%edx)
	}
	else{
		return -E_TX_FULL;
	}
	return 0;
f0107779:	83 c4 10             	add    $0x10,%esp
f010777c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0107781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107784:	c9                   	leave  
f0107785:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107786:	50                   	push   %eax
f0107787:	68 0c 81 10 f0       	push   $0xf010810c
f010778c:	6a 7f                	push   $0x7f
f010778e:	68 aa a7 10 f0       	push   $0xf010a7aa
f0107793:	e8 b1 88 ff ff       	call   f0100049 <_panic>
f0107798:	50                   	push   %eax
f0107799:	68 0c 81 10 f0       	push   $0xf010810c
f010779e:	68 80 00 00 00       	push   $0x80
f01077a3:	68 aa a7 10 f0       	push   $0xf010a7aa
f01077a8:	e8 9c 88 ff ff       	call   f0100049 <_panic>
		return -E_TX_FULL;
f01077ad:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
f01077b2:	eb cd                	jmp    f0107781 <e1000_tx+0xf5>

f01077b4 <e1000_rx>:

// char rx_bufs[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx(void *buf, uint32_t len)
{
f01077b4:	55                   	push   %ebp
f01077b5:	89 e5                	mov    %esp,%ebp
f01077b7:	57                   	push   %edi
f01077b8:	56                   	push   %esi
f01077b9:	53                   	push   %ebx
f01077ba:	83 ec 0c             	sub    $0xc,%esp
	// 	assert(len > rx_descs[base->RDH].length);
	// 	memcpy(buf, KADDR(rx_descs[base->RDH].addr), len);
	// 	memset(KADDR(rx_descs[base->RDH].addr), 0, PKT_SIZE);
	// 	base->RDT = base->RDH;
	// }
	uint32_t rdt = (base->RDT + 1) % N_RXDESC;
f01077bd:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f01077c2:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
f01077c8:	83 c3 01             	add    $0x1,%ebx
f01077cb:	0f b6 db             	movzbl %bl,%ebx
  	if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD)){
f01077ce:	89 de                	mov    %ebx,%esi
f01077d0:	c1 e6 04             	shl    $0x4,%esi
f01077d3:	89 f0                	mov    %esi,%eax
f01077d5:	03 05 a4 ed 5d f0    	add    0xf05deda4,%eax
f01077db:	f6 40 0c 01          	testb  $0x1,0xc(%eax)
f01077df:	74 5a                	je     f010783b <e1000_rx+0x87>
		return -E_AGAIN;
	}

	if(rx_descs[rdt].error) {
f01077e1:	80 78 0d 00          	cmpb   $0x0,0xd(%eax)
f01077e5:	75 3d                	jne    f0107824 <e1000_rx+0x70>
		cprintf("[rx]error occours\n");
		return -E_UNSPECIFIED;
	}
	len = rx_descs[rdt].length;
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f01077e7:	83 ec 04             	sub    $0x4,%esp
	len = rx_descs[rdt].length;
f01077ea:	0f b7 78 08          	movzwl 0x8(%eax),%edi
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f01077ee:	57                   	push   %edi
f01077ef:	89 d8                	mov    %ebx,%eax
f01077f1:	c1 e0 0b             	shl    $0xb,%eax
f01077f4:	05 c0 ed 5d f0       	add    $0xf05dedc0,%eax
f01077f9:	50                   	push   %eax
f01077fa:	ff 75 08             	pushl  0x8(%ebp)
f01077fd:	e8 6f f1 ff ff       	call   f0106971 <memcpy>
  	rx_descs[rdt].status ^= E1000_RX_STATUS_DD;//lab6 bug?
f0107802:	03 35 a4 ed 5d f0    	add    0xf05deda4,%esi
f0107808:	80 76 0c 01          	xorb   $0x1,0xc(%esi)

  	base->RDT = rdt;
f010780c:	a1 68 dd 5d f0       	mov    0xf05ddd68,%eax
f0107811:	89 98 18 28 00 00    	mov    %ebx,0x2818(%eax)
	return len;
f0107817:	89 f8                	mov    %edi,%eax
f0107819:	83 c4 10             	add    $0x10,%esp
}
f010781c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010781f:	5b                   	pop    %ebx
f0107820:	5e                   	pop    %esi
f0107821:	5f                   	pop    %edi
f0107822:	5d                   	pop    %ebp
f0107823:	c3                   	ret    
		cprintf("[rx]error occours\n");
f0107824:	83 ec 0c             	sub    $0xc,%esp
f0107827:	68 c9 a7 10 f0       	push   $0xf010a7c9
f010782c:	e8 34 ca ff ff       	call   f0104265 <cprintf>
		return -E_UNSPECIFIED;
f0107831:	83 c4 10             	add    $0x10,%esp
f0107834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0107839:	eb e1                	jmp    f010781c <e1000_rx+0x68>
		return -E_AGAIN;
f010783b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f0107840:	eb da                	jmp    f010781c <e1000_rx+0x68>

f0107842 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0107842:	55                   	push   %ebp
f0107843:	89 e5                	mov    %esp,%ebp
f0107845:	57                   	push   %edi
f0107846:	56                   	push   %esi
f0107847:	53                   	push   %ebx
f0107848:	83 ec 0c             	sub    $0xc,%esp
f010784b:	8b 7d 08             	mov    0x8(%ebp),%edi
f010784e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107851:	eb 03                	jmp    f0107856 <pci_attach_match+0x14>
f0107853:	83 c3 0c             	add    $0xc,%ebx
f0107856:	89 de                	mov    %ebx,%esi
f0107858:	8b 43 08             	mov    0x8(%ebx),%eax
f010785b:	85 c0                	test   %eax,%eax
f010785d:	74 37                	je     f0107896 <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f010785f:	39 3b                	cmp    %edi,(%ebx)
f0107861:	75 f0                	jne    f0107853 <pci_attach_match+0x11>
f0107863:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107866:	39 56 04             	cmp    %edx,0x4(%esi)
f0107869:	75 e8                	jne    f0107853 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f010786b:	83 ec 0c             	sub    $0xc,%esp
f010786e:	ff 75 14             	pushl  0x14(%ebp)
f0107871:	ff d0                	call   *%eax
			if (r > 0)
f0107873:	83 c4 10             	add    $0x10,%esp
f0107876:	85 c0                	test   %eax,%eax
f0107878:	7f 1c                	jg     f0107896 <pci_attach_match+0x54>
				return r;
			if (r < 0)
f010787a:	79 d7                	jns    f0107853 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f010787c:	83 ec 0c             	sub    $0xc,%esp
f010787f:	50                   	push   %eax
f0107880:	ff 76 08             	pushl  0x8(%esi)
f0107883:	ff 75 0c             	pushl  0xc(%ebp)
f0107886:	57                   	push   %edi
f0107887:	68 fc a7 10 f0       	push   $0xf010a7fc
f010788c:	e8 d4 c9 ff ff       	call   f0104265 <cprintf>
f0107891:	83 c4 20             	add    $0x20,%esp
f0107894:	eb bd                	jmp    f0107853 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0107896:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107899:	5b                   	pop    %ebx
f010789a:	5e                   	pop    %esi
f010789b:	5f                   	pop    %edi
f010789c:	5d                   	pop    %ebp
f010789d:	c3                   	ret    

f010789e <pci_conf1_set_addr>:
{
f010789e:	55                   	push   %ebp
f010789f:	89 e5                	mov    %esp,%ebp
f01078a1:	53                   	push   %ebx
f01078a2:	83 ec 04             	sub    $0x4,%esp
f01078a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01078a8:	3d ff 00 00 00       	cmp    $0xff,%eax
f01078ad:	77 36                	ja     f01078e5 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f01078af:	83 fa 1f             	cmp    $0x1f,%edx
f01078b2:	77 47                	ja     f01078fb <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f01078b4:	83 f9 07             	cmp    $0x7,%ecx
f01078b7:	77 58                	ja     f0107911 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f01078b9:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01078bf:	77 66                	ja     f0107927 <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f01078c1:	f6 c3 03             	test   $0x3,%bl
f01078c4:	75 77                	jne    f010793d <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f01078c6:	c1 e0 10             	shl    $0x10,%eax
f01078c9:	09 d8                	or     %ebx,%eax
f01078cb:	c1 e1 08             	shl    $0x8,%ecx
f01078ce:	09 c8                	or     %ecx,%eax
f01078d0:	c1 e2 0b             	shl    $0xb,%edx
f01078d3:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f01078d5:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01078da:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f01078df:	ef                   	out    %eax,(%dx)
}
f01078e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01078e3:	c9                   	leave  
f01078e4:	c3                   	ret    
	assert(bus < 256);
f01078e5:	68 54 a9 10 f0       	push   $0xf010a954
f01078ea:	68 ab 92 10 f0       	push   $0xf01092ab
f01078ef:	6a 2c                	push   $0x2c
f01078f1:	68 5e a9 10 f0       	push   $0xf010a95e
f01078f6:	e8 4e 87 ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f01078fb:	68 69 a9 10 f0       	push   $0xf010a969
f0107900:	68 ab 92 10 f0       	push   $0xf01092ab
f0107905:	6a 2d                	push   $0x2d
f0107907:	68 5e a9 10 f0       	push   $0xf010a95e
f010790c:	e8 38 87 ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f0107911:	68 72 a9 10 f0       	push   $0xf010a972
f0107916:	68 ab 92 10 f0       	push   $0xf01092ab
f010791b:	6a 2e                	push   $0x2e
f010791d:	68 5e a9 10 f0       	push   $0xf010a95e
f0107922:	e8 22 87 ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f0107927:	68 7b a9 10 f0       	push   $0xf010a97b
f010792c:	68 ab 92 10 f0       	push   $0xf01092ab
f0107931:	6a 2f                	push   $0x2f
f0107933:	68 5e a9 10 f0       	push   $0xf010a95e
f0107938:	e8 0c 87 ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f010793d:	68 88 a9 10 f0       	push   $0xf010a988
f0107942:	68 ab 92 10 f0       	push   $0xf01092ab
f0107947:	6a 30                	push   $0x30
f0107949:	68 5e a9 10 f0       	push   $0xf010a95e
f010794e:	e8 f6 86 ff ff       	call   f0100049 <_panic>

f0107953 <pci_conf_read>:
{
f0107953:	55                   	push   %ebp
f0107954:	89 e5                	mov    %esp,%ebp
f0107956:	53                   	push   %ebx
f0107957:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010795a:	8b 48 08             	mov    0x8(%eax),%ecx
f010795d:	8b 58 04             	mov    0x4(%eax),%ebx
f0107960:	8b 00                	mov    (%eax),%eax
f0107962:	8b 40 04             	mov    0x4(%eax),%eax
f0107965:	52                   	push   %edx
f0107966:	89 da                	mov    %ebx,%edx
f0107968:	e8 31 ff ff ff       	call   f010789e <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f010796d:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107972:	ed                   	in     (%dx),%eax
}
f0107973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107976:	c9                   	leave  
f0107977:	c3                   	ret    

f0107978 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0107978:	55                   	push   %ebp
f0107979:	89 e5                	mov    %esp,%ebp
f010797b:	57                   	push   %edi
f010797c:	56                   	push   %esi
f010797d:	53                   	push   %ebx
f010797e:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0107984:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107986:	6a 48                	push   $0x48
f0107988:	6a 00                	push   $0x0
f010798a:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010798d:	50                   	push   %eax
f010798e:	e8 34 ef ff ff       	call   f01068c7 <memset>
	df.bus = bus;
f0107993:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107996:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f010799d:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f01079a0:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f01079a7:	00 00 00 
f01079aa:	e9 25 01 00 00       	jmp    f0107ad4 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01079af:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01079b5:	83 ec 08             	sub    $0x8,%esp
f01079b8:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f01079bc:	57                   	push   %edi
f01079bd:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f01079be:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01079c1:	0f b6 c0             	movzbl %al,%eax
f01079c4:	50                   	push   %eax
f01079c5:	51                   	push   %ecx
f01079c6:	89 d0                	mov    %edx,%eax
f01079c8:	c1 e8 10             	shr    $0x10,%eax
f01079cb:	50                   	push   %eax
f01079cc:	0f b7 d2             	movzwl %dx,%edx
f01079cf:	52                   	push   %edx
f01079d0:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f01079d6:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f01079dc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f01079e2:	ff 70 04             	pushl  0x4(%eax)
f01079e5:	68 28 a8 10 f0       	push   $0xf010a828
f01079ea:	e8 76 c8 ff ff       	call   f0104265 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f01079ef:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f01079f5:	83 c4 30             	add    $0x30,%esp
f01079f8:	53                   	push   %ebx
f01079f9:	68 6c d3 16 f0       	push   $0xf016d36c
				 PCI_SUBCLASS(f->dev_class),
f01079fe:	89 c2                	mov    %eax,%edx
f0107a00:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107a03:	0f b6 d2             	movzbl %dl,%edx
f0107a06:	52                   	push   %edx
f0107a07:	c1 e8 18             	shr    $0x18,%eax
f0107a0a:	50                   	push   %eax
f0107a0b:	e8 32 fe ff ff       	call   f0107842 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0107a10:	83 c4 10             	add    $0x10,%esp
f0107a13:	85 c0                	test   %eax,%eax
f0107a15:	0f 84 88 00 00 00    	je     f0107aa3 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107a1b:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107a22:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0107a28:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f0107a2e:	0f 83 92 00 00 00    	jae    f0107ac6 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f0107a34:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f0107a3a:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107a40:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107a45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0107a47:	ba 00 00 00 00       	mov    $0x0,%edx
f0107a4c:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107a52:	e8 fc fe ff ff       	call   f0107953 <pci_conf_read>
f0107a57:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107a5d:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107a61:	74 b8                	je     f0107a1b <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107a63:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107a68:	89 d8                	mov    %ebx,%eax
f0107a6a:	e8 e4 fe ff ff       	call   f0107953 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107a6f:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107a72:	ba 08 00 00 00       	mov    $0x8,%edx
f0107a77:	89 d8                	mov    %ebx,%eax
f0107a79:	e8 d5 fe ff ff       	call   f0107953 <pci_conf_read>
f0107a7e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107a84:	89 c1                	mov    %eax,%ecx
f0107a86:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0107a89:	be 9c a9 10 f0       	mov    $0xf010a99c,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107a8e:	83 f9 06             	cmp    $0x6,%ecx
f0107a91:	0f 87 18 ff ff ff    	ja     f01079af <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107a97:	8b 34 8d 10 aa 10 f0 	mov    -0xfef55f0(,%ecx,4),%esi
f0107a9e:	e9 0c ff ff ff       	jmp    f01079af <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0107aa3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107aa9:	53                   	push   %ebx
f0107aaa:	68 54 d3 16 f0       	push   $0xf016d354
f0107aaf:	89 c2                	mov    %eax,%edx
f0107ab1:	c1 ea 10             	shr    $0x10,%edx
f0107ab4:	52                   	push   %edx
f0107ab5:	0f b7 c0             	movzwl %ax,%eax
f0107ab8:	50                   	push   %eax
f0107ab9:	e8 84 fd ff ff       	call   f0107842 <pci_attach_match>
f0107abe:	83 c4 10             	add    $0x10,%esp
f0107ac1:	e9 55 ff ff ff       	jmp    f0107a1b <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107ac6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107ac9:	83 c0 01             	add    $0x1,%eax
f0107acc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107acf:	83 f8 1f             	cmp    $0x1f,%eax
f0107ad2:	77 59                	ja     f0107b2d <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107ad4:	ba 0c 00 00 00       	mov    $0xc,%edx
f0107ad9:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107adc:	e8 72 fe ff ff       	call   f0107953 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107ae1:	89 c2                	mov    %eax,%edx
f0107ae3:	c1 ea 10             	shr    $0x10,%edx
f0107ae6:	f6 c2 7e             	test   $0x7e,%dl
f0107ae9:	75 db                	jne    f0107ac6 <pci_scan_bus+0x14e>
		totaldev++;
f0107aeb:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0107af2:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107af8:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107afb:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107b00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107b02:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107b09:	00 00 00 
f0107b0c:	25 00 00 80 00       	and    $0x800000,%eax
f0107b11:	83 f8 01             	cmp    $0x1,%eax
f0107b14:	19 c0                	sbb    %eax,%eax
f0107b16:	83 e0 f9             	and    $0xfffffff9,%eax
f0107b19:	83 c0 08             	add    $0x8,%eax
f0107b1c:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107b22:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107b28:	e9 f5 fe ff ff       	jmp    f0107a22 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107b2d:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107b36:	5b                   	pop    %ebx
f0107b37:	5e                   	pop    %esi
f0107b38:	5f                   	pop    %edi
f0107b39:	5d                   	pop    %ebp
f0107b3a:	c3                   	ret    

f0107b3b <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0107b3b:	55                   	push   %ebp
f0107b3c:	89 e5                	mov    %esp,%ebp
f0107b3e:	57                   	push   %edi
f0107b3f:	56                   	push   %esi
f0107b40:	53                   	push   %ebx
f0107b41:	83 ec 1c             	sub    $0x1c,%esp
f0107b44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0107b47:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0107b4c:	89 d8                	mov    %ebx,%eax
f0107b4e:	e8 00 fe ff ff       	call   f0107953 <pci_conf_read>
f0107b53:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107b55:	ba 18 00 00 00       	mov    $0x18,%edx
f0107b5a:	89 d8                	mov    %ebx,%eax
f0107b5c:	e8 f2 fd ff ff       	call   f0107953 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107b61:	83 e7 0f             	and    $0xf,%edi
f0107b64:	83 ff 01             	cmp    $0x1,%edi
f0107b67:	74 56                	je     f0107bbf <pci_bridge_attach+0x84>
f0107b69:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0107b6b:	83 ec 04             	sub    $0x4,%esp
f0107b6e:	6a 08                	push   $0x8
f0107b70:	6a 00                	push   $0x0
f0107b72:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107b75:	57                   	push   %edi
f0107b76:	e8 4c ed ff ff       	call   f01068c7 <memset>
	nbus.parent_bridge = pcif;
f0107b7b:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0107b7e:	89 f0                	mov    %esi,%eax
f0107b80:	0f b6 c4             	movzbl %ah,%eax
f0107b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107b86:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0107b89:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107b8c:	89 f1                	mov    %esi,%ecx
f0107b8e:	0f b6 f1             	movzbl %cl,%esi
f0107b91:	56                   	push   %esi
f0107b92:	50                   	push   %eax
f0107b93:	ff 73 08             	pushl  0x8(%ebx)
f0107b96:	ff 73 04             	pushl  0x4(%ebx)
f0107b99:	8b 03                	mov    (%ebx),%eax
f0107b9b:	ff 70 04             	pushl  0x4(%eax)
f0107b9e:	68 98 a8 10 f0       	push   $0xf010a898
f0107ba3:	e8 bd c6 ff ff       	call   f0104265 <cprintf>

	pci_scan_bus(&nbus);
f0107ba8:	83 c4 20             	add    $0x20,%esp
f0107bab:	89 f8                	mov    %edi,%eax
f0107bad:	e8 c6 fd ff ff       	call   f0107978 <pci_scan_bus>
	return 1;
f0107bb2:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107bba:	5b                   	pop    %ebx
f0107bbb:	5e                   	pop    %esi
f0107bbc:	5f                   	pop    %edi
f0107bbd:	5d                   	pop    %ebp
f0107bbe:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107bbf:	ff 73 08             	pushl  0x8(%ebx)
f0107bc2:	ff 73 04             	pushl  0x4(%ebx)
f0107bc5:	8b 03                	mov    (%ebx),%eax
f0107bc7:	ff 70 04             	pushl  0x4(%eax)
f0107bca:	68 64 a8 10 f0       	push   $0xf010a864
f0107bcf:	e8 91 c6 ff ff       	call   f0104265 <cprintf>
		return 0;
f0107bd4:	83 c4 10             	add    $0x10,%esp
f0107bd7:	b8 00 00 00 00       	mov    $0x0,%eax
f0107bdc:	eb d9                	jmp    f0107bb7 <pci_bridge_attach+0x7c>

f0107bde <pci_conf_write>:
{
f0107bde:	55                   	push   %ebp
f0107bdf:	89 e5                	mov    %esp,%ebp
f0107be1:	56                   	push   %esi
f0107be2:	53                   	push   %ebx
f0107be3:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107be5:	8b 48 08             	mov    0x8(%eax),%ecx
f0107be8:	8b 70 04             	mov    0x4(%eax),%esi
f0107beb:	8b 00                	mov    (%eax),%eax
f0107bed:	8b 40 04             	mov    0x4(%eax),%eax
f0107bf0:	83 ec 0c             	sub    $0xc,%esp
f0107bf3:	52                   	push   %edx
f0107bf4:	89 f2                	mov    %esi,%edx
f0107bf6:	e8 a3 fc ff ff       	call   f010789e <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107bfb:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107c00:	89 d8                	mov    %ebx,%eax
f0107c02:	ef                   	out    %eax,(%dx)
}
f0107c03:	83 c4 10             	add    $0x10,%esp
f0107c06:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107c09:	5b                   	pop    %ebx
f0107c0a:	5e                   	pop    %esi
f0107c0b:	5d                   	pop    %ebp
f0107c0c:	c3                   	ret    

f0107c0d <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107c0d:	55                   	push   %ebp
f0107c0e:	89 e5                	mov    %esp,%ebp
f0107c10:	57                   	push   %edi
f0107c11:	56                   	push   %esi
f0107c12:	53                   	push   %ebx
f0107c13:	83 ec 2c             	sub    $0x2c,%esp
f0107c16:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107c19:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107c1e:	ba 04 00 00 00       	mov    $0x4,%edx
f0107c23:	89 f8                	mov    %edi,%eax
f0107c25:	e8 b4 ff ff ff       	call   f0107bde <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107c2a:	be 10 00 00 00       	mov    $0x10,%esi
f0107c2f:	eb 27                	jmp    f0107c58 <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107c31:	89 c3                	mov    %eax,%ebx
f0107c33:	83 e3 fc             	and    $0xfffffffc,%ebx
f0107c36:	f7 db                	neg    %ebx
f0107c38:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107c3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107c3d:	83 e0 fc             	and    $0xfffffffc,%eax
f0107c40:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f0107c43:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f0107c4a:	eb 74                	jmp    f0107cc0 <pci_func_enable+0xb3>
	     bar += bar_width)
f0107c4c:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107c4f:	83 fe 27             	cmp    $0x27,%esi
f0107c52:	0f 87 c5 00 00 00    	ja     f0107d1d <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f0107c58:	89 f2                	mov    %esi,%edx
f0107c5a:	89 f8                	mov    %edi,%eax
f0107c5c:	e8 f2 fc ff ff       	call   f0107953 <pci_conf_read>
f0107c61:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0107c64:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0107c69:	89 f2                	mov    %esi,%edx
f0107c6b:	89 f8                	mov    %edi,%eax
f0107c6d:	e8 6c ff ff ff       	call   f0107bde <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0107c72:	89 f2                	mov    %esi,%edx
f0107c74:	89 f8                	mov    %edi,%eax
f0107c76:	e8 d8 fc ff ff       	call   f0107953 <pci_conf_read>
		bar_width = 4;
f0107c7b:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0107c82:	85 c0                	test   %eax,%eax
f0107c84:	74 c6                	je     f0107c4c <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0107c86:	8d 4e f0             	lea    -0x10(%esi),%ecx
f0107c89:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0107c8c:	c1 e9 02             	shr    $0x2,%ecx
f0107c8f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107c92:	a8 01                	test   $0x1,%al
f0107c94:	75 9b                	jne    f0107c31 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107c96:	89 c2                	mov    %eax,%edx
f0107c98:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f0107c9b:	83 fa 04             	cmp    $0x4,%edx
f0107c9e:	0f 94 c1             	sete   %cl
f0107ca1:	0f b6 c9             	movzbl %cl,%ecx
f0107ca4:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f0107cab:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f0107cae:	89 c3                	mov    %eax,%ebx
f0107cb0:	83 e3 f0             	and    $0xfffffff0,%ebx
f0107cb3:	f7 db                	neg    %ebx
f0107cb5:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107cba:	83 e0 f0             	and    $0xfffffff0,%eax
f0107cbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107cc0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0107cc3:	89 f2                	mov    %esi,%edx
f0107cc5:	89 f8                	mov    %edi,%eax
f0107cc7:	e8 12 ff ff ff       	call   f0107bde <pci_conf_write>
f0107ccc:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0107ccf:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0107cd1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107cd4:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0107cd7:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f0107cda:	85 db                	test   %ebx,%ebx
f0107cdc:	0f 84 6a ff ff ff    	je     f0107c4c <pci_func_enable+0x3f>
f0107ce2:	85 d2                	test   %edx,%edx
f0107ce4:	0f 85 62 ff ff ff    	jne    f0107c4c <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107cea:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0107ced:	83 ec 0c             	sub    $0xc,%esp
f0107cf0:	53                   	push   %ebx
f0107cf1:	6a 00                	push   $0x0
f0107cf3:	ff 75 d4             	pushl  -0x2c(%ebp)
f0107cf6:	89 c2                	mov    %eax,%edx
f0107cf8:	c1 ea 10             	shr    $0x10,%edx
f0107cfb:	52                   	push   %edx
f0107cfc:	0f b7 c0             	movzwl %ax,%eax
f0107cff:	50                   	push   %eax
f0107d00:	ff 77 08             	pushl  0x8(%edi)
f0107d03:	ff 77 04             	pushl  0x4(%edi)
f0107d06:	8b 07                	mov    (%edi),%eax
f0107d08:	ff 70 04             	pushl  0x4(%eax)
f0107d0b:	68 c8 a8 10 f0       	push   $0xf010a8c8
f0107d10:	e8 50 c5 ff ff       	call   f0104265 <cprintf>
f0107d15:	83 c4 30             	add    $0x30,%esp
f0107d18:	e9 2f ff ff ff       	jmp    f0107c4c <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107d1d:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107d20:	83 ec 08             	sub    $0x8,%esp
f0107d23:	89 c2                	mov    %eax,%edx
f0107d25:	c1 ea 10             	shr    $0x10,%edx
f0107d28:	52                   	push   %edx
f0107d29:	0f b7 c0             	movzwl %ax,%eax
f0107d2c:	50                   	push   %eax
f0107d2d:	ff 77 08             	pushl  0x8(%edi)
f0107d30:	ff 77 04             	pushl  0x4(%edi)
f0107d33:	8b 07                	mov    (%edi),%eax
f0107d35:	ff 70 04             	pushl  0x4(%eax)
f0107d38:	68 24 a9 10 f0       	push   $0xf010a924
f0107d3d:	e8 23 c5 ff ff       	call   f0104265 <cprintf>
}
f0107d42:	83 c4 20             	add    $0x20,%esp
f0107d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107d48:	5b                   	pop    %ebx
f0107d49:	5e                   	pop    %esi
f0107d4a:	5f                   	pop    %edi
f0107d4b:	5d                   	pop    %ebp
f0107d4c:	c3                   	ret    

f0107d4d <pci_init>:

int
pci_init(void)
{
f0107d4d:	55                   	push   %ebp
f0107d4e:	89 e5                	mov    %esp,%ebp
f0107d50:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107d53:	6a 08                	push   $0x8
f0107d55:	6a 00                	push   $0x0
f0107d57:	68 6c dd 5d f0       	push   $0xf05ddd6c
f0107d5c:	e8 66 eb ff ff       	call   f01068c7 <memset>

	return pci_scan_bus(&root_bus);
f0107d61:	b8 6c dd 5d f0       	mov    $0xf05ddd6c,%eax
f0107d66:	e8 0d fc ff ff       	call   f0107978 <pci_scan_bus>
}
f0107d6b:	c9                   	leave  
f0107d6c:	c3                   	ret    

f0107d6d <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f0107d6d:	c7 05 74 dd 5d f0 00 	movl   $0x0,0xf05ddd74
f0107d74:	00 00 00 
}
f0107d77:	c3                   	ret    

f0107d78 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f0107d78:	a1 74 dd 5d f0       	mov    0xf05ddd74,%eax
f0107d7d:	83 c0 01             	add    $0x1,%eax
f0107d80:	a3 74 dd 5d f0       	mov    %eax,0xf05ddd74
	if (ticks * 10 < ticks)
f0107d85:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107d88:	01 d2                	add    %edx,%edx
f0107d8a:	39 d0                	cmp    %edx,%eax
f0107d8c:	77 01                	ja     f0107d8f <time_tick+0x17>
f0107d8e:	c3                   	ret    
{
f0107d8f:	55                   	push   %ebp
f0107d90:	89 e5                	mov    %esp,%ebp
f0107d92:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0107d95:	68 2c aa 10 f0       	push   $0xf010aa2c
f0107d9a:	6a 13                	push   $0x13
f0107d9c:	68 47 aa 10 f0       	push   $0xf010aa47
f0107da1:	e8 a3 82 ff ff       	call   f0100049 <_panic>

f0107da6 <time_msec>:
f0107da6:	a1 74 dd 5d f0       	mov    0xf05ddd74,%eax
f0107dab:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0107dae:	01 c0                	add    %eax,%eax
f0107db0:	c3                   	ret    
f0107db1:	66 90                	xchg   %ax,%ax
f0107db3:	66 90                	xchg   %ax,%ax
f0107db5:	66 90                	xchg   %ax,%ax
f0107db7:	66 90                	xchg   %ax,%ax
f0107db9:	66 90                	xchg   %ax,%ax
f0107dbb:	66 90                	xchg   %ax,%ax
f0107dbd:	66 90                	xchg   %ax,%ax
f0107dbf:	90                   	nop

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
f0121010:	68 7a 96 10 f0       	push   $0xf010967a
f0121015:	68 aa 02 00 00       	push   $0x2aa
f012101a:	68 56 96 10 f0       	push   $0xf0109656
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
f012102a:	83 ec 74             	sub    $0x74,%esp
	cprintf("in %s\n", __FUNCTION__);
f012102d:	68 74 99 10 f0       	push   $0xf0109974
f0121032:	68 20 80 10 f0       	push   $0xf0108020
f0121037:	e8 29 32 fe ff       	call   f0104265 <cprintf>
	pde_t *pgdir = e->env_pgdir;
f012103c:	8b 45 08             	mov    0x8(%ebp),%eax
f012103f:	8b 78 60             	mov    0x60(%eax),%edi
		if ((uintptr_t) envs <= va && va < (uintptr_t) (envs + NENV))
f0121042:	8b 1d 44 d9 5d f0    	mov    0xf05dd944,%ebx
f0121048:	8d b3 00 10 02 00    	lea    0x21000(%ebx),%esi
	if (PGNUM(pa) >= npages)
f012104e:	a1 88 ed 5d f0       	mov    0xf05ded88,%eax
f0121053:	89 45 94             	mov    %eax,-0x6c(%ebp)
f0121056:	83 c4 10             	add    $0x10,%esp
	for (uintptr_t va = ULIM; va; va += PGSIZE) {
f0121059:	b8 00 00 80 ef       	mov    $0xef800000,%eax
f012105e:	eb 3e                	jmp    f012109e <env_run+0x7a>
		if (pgdir[PDX(va)] & PTE_P) {
f0121060:	89 c2                	mov    %eax,%edx
f0121062:	c1 ea 16             	shr    $0x16,%edx
f0121065:	8b 14 97             	mov    (%edi,%edx,4),%edx
f0121068:	f6 c2 01             	test   $0x1,%dl
f012106b:	74 2a                	je     f0121097 <env_run+0x73>
			if (pgdir[PDX(va)] & PTE_PS)
f012106d:	f6 c2 80             	test   $0x80,%dl
f0121070:	75 52                	jne    f01210c4 <env_run+0xa0>
				pte_t *pte = KADDR(PTE_ADDR(pgdir[PDX(va)]));
f0121072:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0121078:	89 d1                	mov    %edx,%ecx
f012107a:	c1 e9 0c             	shr    $0xc,%ecx
f012107d:	3b 4d 94             	cmp    -0x6c(%ebp),%ecx
f0121080:	73 57                	jae    f01210d9 <env_run+0xb5>
				if (pte[PTX(va)] & PTE_P)
f0121082:	89 c1                	mov    %eax,%ecx
f0121084:	c1 e9 0c             	shr    $0xc,%ecx
f0121087:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f012108d:	f6 84 8a 00 00 00 f0 	testb  $0x1,-0x10000000(%edx,%ecx,4)
f0121094:	01 
f0121095:	75 57                	jne    f01210ee <env_run+0xca>
	for (uintptr_t va = ULIM; va; va += PGSIZE) {
f0121097:	05 00 10 00 00       	add    $0x1000,%eax
f012109c:	74 65                	je     f0121103 <env_run+0xdf>
		if ((uintptr_t) __USER_MAP_BEGIN__ <= va && va < (uintptr_t) __USER_MAP_END__)
f012109e:	3d 00 10 12 f0       	cmp    $0xf0121000,%eax
f01210a3:	72 07                	jb     f01210ac <env_run+0x88>
f01210a5:	3d 00 c0 16 f0       	cmp    $0xf016c000,%eax
f01210aa:	72 eb                	jb     f0121097 <env_run+0x73>
		if (KSTACKTOP - (KSTKSIZE + KSTKGAP) * NCPU <= va && va < KSTACKTOP)
f01210ac:	8d 90 00 00 08 10    	lea    0x10080000(%eax),%edx
f01210b2:	81 fa ff ff 07 00    	cmp    $0x7ffff,%edx
f01210b8:	76 dd                	jbe    f0121097 <env_run+0x73>
		if ((uintptr_t) envs <= va && va < (uintptr_t) (envs + NENV))
f01210ba:	39 c3                	cmp    %eax,%ebx
f01210bc:	77 a2                	ja     f0121060 <env_run+0x3c>
f01210be:	39 c6                	cmp    %eax,%esi
f01210c0:	76 9e                	jbe    f0121060 <env_run+0x3c>
f01210c2:	eb d3                	jmp    f0121097 <env_run+0x73>
				panic("User page table has kernel address %08x mapped", va);
f01210c4:	50                   	push   %eax
f01210c5:	68 f0 98 10 f0       	push   $0xf01098f0
f01210ca:	68 80 02 00 00       	push   $0x280
f01210cf:	68 56 96 10 f0       	push   $0xf0109656
f01210d4:	e8 70 ef fd ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01210d9:	52                   	push   %edx
f01210da:	68 0c 81 10 f0       	push   $0xf010810c
f01210df:	68 82 02 00 00       	push   $0x282
f01210e4:	68 56 96 10 f0       	push   $0xf0109656
f01210e9:	e8 5b ef fd ff       	call   f0100049 <_panic>
					panic("User page table has kernel address %08x mapped", va);
f01210ee:	50                   	push   %eax
f01210ef:	68 f0 98 10 f0       	push   $0xf01098f0
f01210f4:	68 84 02 00 00       	push   $0x284
f01210f9:	68 56 96 10 f0       	push   $0xf0109656
f01210fe:	e8 46 ef fd ff       	call   f0100049 <_panic>
	check_user_map(pgdir, gdt, sizeof(gdt), "GDT");
f0121103:	83 ec 0c             	sub    $0xc,%esp
f0121106:	68 a1 97 10 f0       	push   $0xf01097a1
f012110b:	b9 68 00 00 00       	mov    $0x68,%ecx
f0121110:	ba 00 a0 12 f0       	mov    $0xf012a000,%edx
f0121115:	89 f8                	mov    %edi,%eax
f0121117:	e8 3e 24 fe ff       	call   f010355a <check_user_map>
	check_user_map(pgdir, (void *) idt_pd.pd_base, idt_pd.pd_lim, "IDT");
f012111c:	0f b7 0d 10 d3 16 f0 	movzwl 0xf016d310,%ecx
f0121123:	c7 04 24 a5 97 10 f0 	movl   $0xf01097a5,(%esp)
f012112a:	8b 15 12 d3 16 f0    	mov    0xf016d312,%edx
f0121130:	89 f8                	mov    %edi,%eax
f0121132:	e8 23 24 fe ff       	call   f010355a <check_user_map>
f0121137:	83 c4 10             	add    $0x10,%esp
f012113a:	bb 05 00 00 00       	mov    $0x5,%ebx
		check_user_map(pgdir, (void *) SEG_BASE(gdt[(GD_TSS0 >> 3) + i]), SEG_LIM(gdt[(GD_TSS0 >> 3) + i]), name);
f012113f:	be 00 a0 12 f0       	mov    $0xf012a000,%esi
		char name[] = "TSS0";
f0121144:	c7 45 98 54 53 53 30 	movl   $0x30535354,-0x68(%ebp)
f012114b:	c6 45 9c 00          	movb   $0x0,-0x64(%ebp)
		name[3] = '0' + i;
f012114f:	8d 43 2b             	lea    0x2b(%ebx),%eax
f0121152:	88 45 9b             	mov    %al,-0x65(%ebp)
		check_user_map(pgdir, (void *) SEG_BASE(gdt[(GD_TSS0 >> 3) + i]), SEG_LIM(gdt[(GD_TSS0 >> 3) + i]), name);
f0121155:	0f b6 4c de 06       	movzbl 0x6(%esi,%ebx,8),%ecx
f012115a:	83 e1 0f             	and    $0xf,%ecx
f012115d:	c1 e1 10             	shl    $0x10,%ecx
f0121160:	0f b7 04 de          	movzwl (%esi,%ebx,8),%eax
f0121164:	09 c1                	or     %eax,%ecx
f0121166:	0f b6 54 de 04       	movzbl 0x4(%esi,%ebx,8),%edx
f012116b:	c1 e2 10             	shl    $0x10,%edx
f012116e:	0f b6 44 de 07       	movzbl 0x7(%esi,%ebx,8),%eax
f0121173:	c1 e0 18             	shl    $0x18,%eax
f0121176:	09 c2                	or     %eax,%edx
f0121178:	0f b7 44 de 02       	movzwl 0x2(%esi,%ebx,8),%eax
f012117d:	09 c2                	or     %eax,%edx
f012117f:	83 ec 0c             	sub    $0xc,%esp
f0121182:	8d 45 98             	lea    -0x68(%ebp),%eax
f0121185:	50                   	push   %eax
f0121186:	89 f8                	mov    %edi,%eax
f0121188:	e8 cd 23 fe ff       	call   f010355a <check_user_map>
f012118d:	83 c3 01             	add    $0x1,%ebx
	for (int i = 0; i < NCPU; i++) {
f0121190:	83 c4 10             	add    $0x10,%esp
f0121193:	83 fb 0d             	cmp    $0xd,%ebx
f0121196:	75 ac                	jne    f0121144 <env_run+0x120>
f0121198:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f012119d:	bb 30 00 00 00       	mov    $0x30,%ebx
		char name[] = "kstack0";
f01211a2:	c7 45 98 6b 73 74 61 	movl   $0x6174736b,-0x68(%ebp)
f01211a9:	c7 45 9c 63 6b 30 00 	movl   $0x306b63,-0x64(%ebp)
		name[6] = '0' + i;
f01211b0:	88 5d 9e             	mov    %bl,-0x62(%ebp)
		check_user_map(pgdir, (void *) KSTACKTOP - (KSTKSIZE + KSTKGAP) * i - KSTKSIZE, KSTKSIZE, name);
f01211b3:	83 ec 0c             	sub    $0xc,%esp
f01211b6:	8d 45 98             	lea    -0x68(%ebp),%eax
f01211b9:	50                   	push   %eax
f01211ba:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01211bf:	89 f2                	mov    %esi,%edx
f01211c1:	89 f8                	mov    %edi,%eax
f01211c3:	e8 92 23 fe ff       	call   f010355a <check_user_map>
f01211c8:	83 c3 01             	add    $0x1,%ebx
f01211cb:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (int i = 0; i < NCPU; i++) {
f01211d1:	83 c4 10             	add    $0x10,%esp
f01211d4:	80 fb 38             	cmp    $0x38,%bl
f01211d7:	75 c9                	jne    f01211a2 <env_run+0x17e>
	check_user_map(pgdir, env_pop_tf, sizeof(env_pop_tf), "env_pop_tf");
f01211d9:	83 ec 0c             	sub    $0xc,%esp
f01211dc:	68 a9 97 10 f0       	push   $0xf01097a9
f01211e1:	b9 01 00 00 00       	mov    $0x1,%ecx
f01211e6:	ba 00 10 12 f0       	mov    $0xf0121000,%edx
f01211eb:	89 f8                	mov    %edi,%eax
f01211ed:	e8 68 23 fe ff       	call   f010355a <check_user_map>
	cprintf("after %s\n", __FUNCTION__);
f01211f2:	83 c4 08             	add    $0x8,%esp
f01211f5:	68 74 99 10 f0       	push   $0xf0109974
f01211fa:	68 b4 97 10 f0       	push   $0xf01097b4
f01211ff:	e8 61 30 fe ff       	call   f0104265 <cprintf>
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f0121204:	e8 0e 03 00 00       	call   f0121517 <cpunum>
f0121209:	6b c0 74             	imul   $0x74,%eax,%eax
f012120c:	83 c4 10             	add    $0x10,%esp
f012120f:	8b 7d 08             	mov    0x8(%ebp),%edi
f0121212:	39 b8 28 b0 16 f0    	cmp    %edi,-0xfe94fd8(%eax)
f0121218:	74 61                	je     f012127b <env_run+0x257>
		if(curenv && curenv->env_status == ENV_RUNNING)
f012121a:	e8 f8 02 00 00       	call   f0121517 <cpunum>
f012121f:	6b c0 74             	imul   $0x74,%eax,%eax
f0121222:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0121229:	74 18                	je     f0121243 <env_run+0x21f>
f012122b:	e8 e7 02 00 00       	call   f0121517 <cpunum>
f0121230:	6b c0 74             	imul   $0x74,%eax,%eax
f0121233:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121239:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f012123d:	0f 84 1d 01 00 00    	je     f0121360 <env_run+0x33c>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f0121243:	e8 cf 02 00 00       	call   f0121517 <cpunum>
f0121248:	6b c0 74             	imul   $0x74,%eax,%eax
f012124b:	8b 75 08             	mov    0x8(%ebp),%esi
f012124e:	89 b0 28 b0 16 f0    	mov    %esi,-0xfe94fd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0121254:	e8 be 02 00 00       	call   f0121517 <cpunum>
f0121259:	6b c0 74             	imul   $0x74,%eax,%eax
f012125c:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121262:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0121269:	e8 a9 02 00 00       	call   f0121517 <cpunum>
f012126e:	6b c0 74             	imul   $0x74,%eax,%eax
f0121271:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121277:	83 40 58 01          	addl   $0x1,0x58(%eax)
		// lcr3(PADDR(curenv->env_pgdir));
	}
	// lcr3(PADDR(curenv->env_pgdir));
	trapframe = curenv->env_tf;
f012127b:	e8 97 02 00 00       	call   f0121517 <cpunum>
f0121280:	6b c0 74             	imul   $0x74,%eax,%eax
f0121283:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0121289:	8d 7d a4             	lea    -0x5c(%ebp),%edi
f012128c:	b9 11 00 00 00       	mov    $0x11,%ecx
f0121291:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	pte_t* pte_store;
	struct PageInfo* pageinfo = page_lookup(curenv->env_pgdir, (void *)0xf012131f, &pte_store);
f0121293:	e8 7f 02 00 00       	call   f0121517 <cpunum>
f0121298:	83 ec 04             	sub    $0x4,%esp
f012129b:	8d 55 a0             	lea    -0x60(%ebp),%edx
f012129e:	52                   	push   %edx
f012129f:	68 1f 13 12 f0       	push   $0xf012131f
f01212a4:	6b c0 74             	imul   $0x74,%eax,%eax
f01212a7:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01212ad:	ff 70 60             	pushl  0x60(%eax)
f01212b0:	e8 f9 02 fe ff       	call   f01015ae <page_lookup>
f01212b5:	89 c3                	mov    %eax,%ebx
	struct PageInfo* pageinfo1 = page_lookup(curenv->env_pgdir, (void *)envs, NULL);
f01212b7:	8b 35 44 d9 5d f0    	mov    0xf05dd944,%esi
f01212bd:	e8 55 02 00 00       	call   f0121517 <cpunum>
f01212c2:	83 c4 0c             	add    $0xc,%esp
f01212c5:	6a 00                	push   $0x0
f01212c7:	56                   	push   %esi
f01212c8:	6b c0 74             	imul   $0x74,%eax,%eax
f01212cb:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01212d1:	ff 70 60             	pushl  0x60(%eax)
f01212d4:	e8 d5 02 fe ff       	call   f01015ae <page_lookup>
f01212d9:	89 c6                	mov    %eax,%esi
	cprintf("the curenv is 0x%x\n", curenv);
f01212db:	e8 37 02 00 00       	call   f0121517 <cpunum>
f01212e0:	83 c4 08             	add    $0x8,%esp
f01212e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01212e6:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01212ec:	68 be 97 10 f0       	push   $0xf01097be
f01212f1:	e8 6f 2f fe ff       	call   f0104265 <cprintf>
	cprintf("the envs 0x%x and pageinfo1 : 0x%0x\n", envs, pageinfo1);
f01212f6:	83 c4 0c             	add    $0xc,%esp
f01212f9:	56                   	push   %esi
f01212fa:	ff 35 44 d9 5d f0    	pushl  0xf05dd944
f0121300:	68 20 99 10 f0       	push   $0xf0109920
f0121305:	e8 5b 2f fe ff       	call   f0104265 <cprintf>
	cprintf("the pageInfo: 0x%x and permission: 0x%x\n", pageinfo, PGOFF(*pte_store));
f012130a:	83 c4 0c             	add    $0xc,%esp
f012130d:	8b 45 a0             	mov    -0x60(%ebp),%eax
f0121310:	8b 00                	mov    (%eax),%eax
f0121312:	25 ff 0f 00 00       	and    $0xfff,%eax
f0121317:	50                   	push   %eax
f0121318:	53                   	push   %ebx
f0121319:	68 48 99 10 f0       	push   $0xf0109948
f012131e:	e8 42 2f fe ff       	call   f0104265 <cprintf>
	spin_unlock(&kernel_lock);
f0121323:	c7 04 24 20 d3 16 f0 	movl   $0xf016d320,(%esp)
f012132a:	e8 d5 5e fe ff       	call   f0107204 <spin_unlock>
	asm volatile("pause");
f012132f:	f3 90                	pause  

	unlock_kernel(); //lab4 bug?
	lcr3(PADDR(curenv->env_pgdir));
f0121331:	e8 e1 01 00 00       	call   f0121517 <cpunum>
f0121336:	6b c0 74             	imul   $0x74,%eax,%eax
f0121339:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f012133f:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0121342:	83 c4 10             	add    $0x10,%esp
f0121345:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f012134a:	76 2e                	jbe    f012137a <env_run+0x356>
	return (physaddr_t)kva - KERNBASE;
f012134c:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0121351:	0f 22 d8             	mov    %eax,%cr3
	env_pop_tf(&trapframe);
f0121354:	83 ec 0c             	sub    $0xc,%esp
f0121357:	8d 45 a4             	lea    -0x5c(%ebp),%eax
f012135a:	50                   	push   %eax
f012135b:	e8 a0 fc ff ff       	call   f0121000 <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0121360:	e8 b2 01 00 00       	call   f0121517 <cpunum>
f0121365:	6b c0 74             	imul   $0x74,%eax,%eax
f0121368:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f012136e:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0121375:	e9 c9 fe ff ff       	jmp    f0121243 <env_run+0x21f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f012137a:	50                   	push   %eax
f012137b:	68 30 81 10 f0       	push   $0xf0108130
f0121380:	68 ea 02 00 00       	push   $0x2ea
f0121385:	68 56 96 10 f0       	push   $0xf0109656
f012138a:	e8 ba ec fd ff       	call   f0100049 <_panic>

f012138f <switch_and_trap>:

__user_mapped_text void
switch_and_trap(struct Trapframe *frame)
{
f012138f:	55                   	push   %ebp
f0121390:	89 e5                	mov    %esp,%ebp
f0121392:	83 ec 08             	sub    $0x8,%esp
f0121395:	8b 55 08             	mov    0x8(%ebp),%edx
	// LAB7: Your code here
	if ((frame->tf_cs & 3) == 3) {
f0121398:	0f b7 42 34          	movzwl 0x34(%edx),%eax
f012139c:	83 e0 03             	and    $0x3,%eax
f012139f:	66 83 f8 03          	cmp    $0x3,%ax
f01213a3:	75 27                	jne    f01213cc <switch_and_trap+0x3d>
	asm volatile("movl %%esp,%0" : "=r" (esp));
f01213a5:	89 e1                	mov    %esp,%ecx
		// Calculate the current CPU core number
		uint32_t esp = read_esp();
		int cpunum = (KSTACKTOP - esp) / (KSTKSIZE + KSTKGAP);
f01213a7:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
f01213ac:	29 c8                	sub    %ecx,%eax
f01213ae:	c1 e8 10             	shr    $0x10,%eax
		// Load the physical address of kernel page table
		// Switch to the kernel page table
		lcr3(PADDR((&cpus[cpunum])->cpu_env->env_kern_pgdir));
f01213b1:	6b c0 74             	imul   $0x74,%eax,%eax
f01213b4:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01213ba:	8b 40 64             	mov    0x64(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01213bd:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01213c2:	76 11                	jbe    f01213d5 <switch_and_trap+0x46>
	return (physaddr_t)kva - KERNBASE;
f01213c4:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01213c9:	0f 22 d8             	mov    %eax,%cr3
	}
	trap(frame);
f01213cc:	83 ec 0c             	sub    $0xc,%esp
f01213cf:	52                   	push   %edx
f01213d0:	e8 21 39 fe ff       	call   f0104cf6 <trap>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01213d5:	50                   	push   %eax
f01213d6:	68 30 81 10 f0       	push   $0xf0108130
f01213db:	68 19 02 00 00       	push   $0x219
f01213e0:	68 7c 9b 10 f0       	push   $0xf0109b7c
f01213e5:	e8 5f ec fd ff       	call   f0100049 <_panic>

f01213ea <DIVIDE_HANDLER>:
f01213ea:	6a 00                	push   $0x0
f01213ec:	6a 00                	push   $0x0
f01213ee:	e9 f9 00 00 00       	jmp    f01214ec <_alltraps>
	...

f01213f4 <DEBUG_HANDLER>:
f01213f4:	6a 00                	push   $0x0
f01213f6:	6a 01                	push   $0x1
f01213f8:	e9 ef 00 00 00       	jmp    f01214ec <_alltraps>
	...

f01213fe <NMI_HANDLER>:
f01213fe:	6a 00                	push   $0x0
f0121400:	6a 02                	push   $0x2
f0121402:	e9 e5 00 00 00       	jmp    f01214ec <_alltraps>
	...

f0121408 <BRKPT_HANDLER>:
f0121408:	6a 00                	push   $0x0
f012140a:	6a 03                	push   $0x3
f012140c:	e9 db 00 00 00       	jmp    f01214ec <_alltraps>
	...

f0121412 <OFLOW_HANDLER>:
f0121412:	6a 00                	push   $0x0
f0121414:	6a 04                	push   $0x4
f0121416:	e9 d1 00 00 00       	jmp    f01214ec <_alltraps>
	...

f012141c <BOUND_HANDLER>:
f012141c:	6a 00                	push   $0x0
f012141e:	6a 05                	push   $0x5
f0121420:	e9 c7 00 00 00       	jmp    f01214ec <_alltraps>
	...

f0121426 <ILLOP_HANDLER>:
f0121426:	6a 00                	push   $0x0
f0121428:	6a 06                	push   $0x6
f012142a:	e9 bd 00 00 00       	jmp    f01214ec <_alltraps>
	...

f0121430 <DEVICE_HANDLER>:
f0121430:	6a 00                	push   $0x0
f0121432:	6a 07                	push   $0x7
f0121434:	e9 b3 00 00 00       	jmp    f01214ec <_alltraps>
	...

f012143a <DBLFLT_HANDLER>:
f012143a:	6a 08                	push   $0x8
f012143c:	e9 ab 00 00 00       	jmp    f01214ec <_alltraps>
	...

f0121442 <TSS_HANDLER>:
f0121442:	6a 0a                	push   $0xa
f0121444:	e9 a3 00 00 00       	jmp    f01214ec <_alltraps>
	...

f012144a <SEGNP_HANDLER>:
f012144a:	6a 0b                	push   $0xb
f012144c:	e9 9b 00 00 00       	jmp    f01214ec <_alltraps>
	...

f0121452 <STACK_HANDLER>:
f0121452:	6a 0c                	push   $0xc
f0121454:	e9 93 00 00 00       	jmp    f01214ec <_alltraps>
	...

f012145a <GPFLT_HANDLER>:
f012145a:	6a 0d                	push   $0xd
f012145c:	e9 8b 00 00 00       	jmp    f01214ec <_alltraps>
	...

f0121462 <PGFLT_HANDLER>:
f0121462:	6a 0e                	push   $0xe
f0121464:	e9 83 00 00 00       	jmp    f01214ec <_alltraps>
	...

f012146a <FPERR_HANDLER>:
f012146a:	6a 00                	push   $0x0
f012146c:	6a 10                	push   $0x10
f012146e:	eb 7c                	jmp    f01214ec <_alltraps>

f0121470 <ALIGN_HANDLER>:
f0121470:	6a 11                	push   $0x11
f0121472:	eb 78                	jmp    f01214ec <_alltraps>

f0121474 <MCHK_HANDLER>:
f0121474:	6a 00                	push   $0x0
f0121476:	6a 12                	push   $0x12
f0121478:	eb 72                	jmp    f01214ec <_alltraps>

f012147a <SIMDERR_HANDLER>:
f012147a:	6a 00                	push   $0x0
f012147c:	6a 13                	push   $0x13
f012147e:	eb 6c                	jmp    f01214ec <_alltraps>

f0121480 <SYSCALL_HANDLER>:
f0121480:	6a 00                	push   $0x0
f0121482:	6a 30                	push   $0x30
f0121484:	eb 66                	jmp    f01214ec <_alltraps>

f0121486 <TIMER_HANDLER>:
f0121486:	6a 00                	push   $0x0
f0121488:	6a 20                	push   $0x20
f012148a:	eb 60                	jmp    f01214ec <_alltraps>

f012148c <KBD_HANDLER>:
f012148c:	6a 00                	push   $0x0
f012148e:	6a 21                	push   $0x21
f0121490:	eb 5a                	jmp    f01214ec <_alltraps>

f0121492 <SECOND_HANDLER>:
f0121492:	6a 00                	push   $0x0
f0121494:	6a 22                	push   $0x22
f0121496:	eb 54                	jmp    f01214ec <_alltraps>

f0121498 <THIRD_HANDLER>:
f0121498:	6a 00                	push   $0x0
f012149a:	6a 23                	push   $0x23
f012149c:	eb 4e                	jmp    f01214ec <_alltraps>

f012149e <SERIAL_HANDLER>:
f012149e:	6a 00                	push   $0x0
f01214a0:	6a 24                	push   $0x24
f01214a2:	eb 48                	jmp    f01214ec <_alltraps>

f01214a4 <FIFTH_HANDLER>:
f01214a4:	6a 00                	push   $0x0
f01214a6:	6a 25                	push   $0x25
f01214a8:	eb 42                	jmp    f01214ec <_alltraps>

f01214aa <SIXTH_HANDLER>:
f01214aa:	6a 00                	push   $0x0
f01214ac:	6a 26                	push   $0x26
f01214ae:	eb 3c                	jmp    f01214ec <_alltraps>

f01214b0 <SPURIOUS_HANDLER>:
f01214b0:	6a 00                	push   $0x0
f01214b2:	6a 27                	push   $0x27
f01214b4:	eb 36                	jmp    f01214ec <_alltraps>

f01214b6 <EIGHTH_HANDLER>:
f01214b6:	6a 00                	push   $0x0
f01214b8:	6a 28                	push   $0x28
f01214ba:	eb 30                	jmp    f01214ec <_alltraps>

f01214bc <NINTH_HANDLER>:
f01214bc:	6a 00                	push   $0x0
f01214be:	6a 29                	push   $0x29
f01214c0:	eb 2a                	jmp    f01214ec <_alltraps>

f01214c2 <TENTH_HANDLER>:
f01214c2:	6a 00                	push   $0x0
f01214c4:	6a 2a                	push   $0x2a
f01214c6:	eb 24                	jmp    f01214ec <_alltraps>

f01214c8 <ELEVEN_HANDLER>:
f01214c8:	6a 00                	push   $0x0
f01214ca:	6a 2b                	push   $0x2b
f01214cc:	eb 1e                	jmp    f01214ec <_alltraps>

f01214ce <TWELVE_HANDLER>:
f01214ce:	6a 00                	push   $0x0
f01214d0:	6a 2c                	push   $0x2c
f01214d2:	eb 18                	jmp    f01214ec <_alltraps>

f01214d4 <THIRTEEN_HANDLER>:
f01214d4:	6a 00                	push   $0x0
f01214d6:	6a 2d                	push   $0x2d
f01214d8:	eb 12                	jmp    f01214ec <_alltraps>

f01214da <IDE_HANDLER>:
f01214da:	6a 00                	push   $0x0
f01214dc:	6a 2e                	push   $0x2e
f01214de:	eb 0c                	jmp    f01214ec <_alltraps>

f01214e0 <FIFTEEN_HANDLER>:
f01214e0:	6a 00                	push   $0x0
f01214e2:	6a 2f                	push   $0x2f
f01214e4:	eb 06                	jmp    f01214ec <_alltraps>

f01214e6 <ERROR_HANDLER>:
f01214e6:	6a 00                	push   $0x0
f01214e8:	6a 33                	push   $0x33
f01214ea:	eb 00                	jmp    f01214ec <_alltraps>

f01214ec <_alltraps>:
f01214ec:	66 6a 00             	pushw  $0x0
f01214ef:	66 1e                	pushw  %ds
f01214f1:	66 6a 00             	pushw  $0x0
f01214f4:	66 06                	pushw  %es
f01214f6:	60                   	pusha  
f01214f7:	b8 10 00 00 00       	mov    $0x10,%eax
f01214fc:	8e d8                	mov    %eax,%ds
f01214fe:	8e c0                	mov    %eax,%es
f0121500:	54                   	push   %esp
f0121501:	e8 89 fe ff ff       	call   f012138f <switch_and_trap>

f0121506 <sysenter_handler>:
f0121506:	56                   	push   %esi
f0121507:	57                   	push   %edi
f0121508:	53                   	push   %ebx
f0121509:	51                   	push   %ecx
f012150a:	52                   	push   %edx
f012150b:	50                   	push   %eax
f012150c:	e8 60 3d fe ff       	call   f0105271 <syscall>
f0121511:	89 f2                	mov    %esi,%edx
f0121513:	89 e9                	mov    %ebp,%ecx
f0121515:	0f 35                	sysexit 

f0121517 <cpunum>:
{
f0121517:	55                   	push   %ebp
f0121518:	89 e5                	mov    %esp,%ebp
f012151a:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f012151d:	68 cc a6 10 f0       	push   $0xf010a6cc
f0121522:	68 20 80 10 f0       	push   $0xf0108020
f0121527:	e8 39 2d fe ff       	call   f0104265 <cprintf>
	if (lapic){
f012152c:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
f0121532:	83 c4 10             	add    $0x10,%esp
	return 0;
f0121535:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f012153a:	85 d2                	test   %edx,%edx
f012153c:	74 06                	je     f0121544 <cpunum+0x2d>
		return lapic[ID] >> 24;
f012153e:	8b 42 20             	mov    0x20(%edx),%eax
f0121541:	c1 e8 18             	shr    $0x18,%eax
}
f0121544:	c9                   	leave  
f0121545:	c3                   	ret    
f0121546:	66 90                	xchg   %ax,%ax
f0121548:	66 90                	xchg   %ax,%ax
f012154a:	66 90                	xchg   %ax,%ax
f012154c:	66 90                	xchg   %ax,%ax
f012154e:	66 90                	xchg   %ax,%ax
f0121550:	66 90                	xchg   %ax,%ax
f0121552:	66 90                	xchg   %ax,%ax
f0121554:	66 90                	xchg   %ax,%ax
f0121556:	66 90                	xchg   %ax,%ax
f0121558:	66 90                	xchg   %ax,%ax
f012155a:	66 90                	xchg   %ax,%ax
f012155c:	66 90                	xchg   %ax,%ax
f012155e:	66 90                	xchg   %ax,%ax
f0121560:	66 90                	xchg   %ax,%ax
f0121562:	66 90                	xchg   %ax,%ax
f0121564:	66 90                	xchg   %ax,%ax
f0121566:	66 90                	xchg   %ax,%ax
f0121568:	66 90                	xchg   %ax,%ax
f012156a:	66 90                	xchg   %ax,%ax
f012156c:	66 90                	xchg   %ax,%ax
f012156e:	66 90                	xchg   %ax,%ax
f0121570:	66 90                	xchg   %ax,%ax
f0121572:	66 90                	xchg   %ax,%ax
f0121574:	66 90                	xchg   %ax,%ax
f0121576:	66 90                	xchg   %ax,%ax
f0121578:	66 90                	xchg   %ax,%ax
f012157a:	66 90                	xchg   %ax,%ax
f012157c:	66 90                	xchg   %ax,%ax
f012157e:	66 90                	xchg   %ax,%ax
f0121580:	66 90                	xchg   %ax,%ax
f0121582:	66 90                	xchg   %ax,%ax
f0121584:	66 90                	xchg   %ax,%ax
f0121586:	66 90                	xchg   %ax,%ax
f0121588:	66 90                	xchg   %ax,%ax
f012158a:	66 90                	xchg   %ax,%ax
f012158c:	66 90                	xchg   %ax,%ax
f012158e:	66 90                	xchg   %ax,%ax
f0121590:	66 90                	xchg   %ax,%ax
f0121592:	66 90                	xchg   %ax,%ax
f0121594:	66 90                	xchg   %ax,%ax
f0121596:	66 90                	xchg   %ax,%ax
f0121598:	66 90                	xchg   %ax,%ax
f012159a:	66 90                	xchg   %ax,%ax
f012159c:	66 90                	xchg   %ax,%ax
f012159e:	66 90                	xchg   %ax,%ax
f01215a0:	66 90                	xchg   %ax,%ax
f01215a2:	66 90                	xchg   %ax,%ax
f01215a4:	66 90                	xchg   %ax,%ax
f01215a6:	66 90                	xchg   %ax,%ax
f01215a8:	66 90                	xchg   %ax,%ax
f01215aa:	66 90                	xchg   %ax,%ax
f01215ac:	66 90                	xchg   %ax,%ax
f01215ae:	66 90                	xchg   %ax,%ax
f01215b0:	66 90                	xchg   %ax,%ax
f01215b2:	66 90                	xchg   %ax,%ax
f01215b4:	66 90                	xchg   %ax,%ax
f01215b6:	66 90                	xchg   %ax,%ax
f01215b8:	66 90                	xchg   %ax,%ax
f01215ba:	66 90                	xchg   %ax,%ax
f01215bc:	66 90                	xchg   %ax,%ax
f01215be:	66 90                	xchg   %ax,%ax
f01215c0:	66 90                	xchg   %ax,%ax
f01215c2:	66 90                	xchg   %ax,%ax
f01215c4:	66 90                	xchg   %ax,%ax
f01215c6:	66 90                	xchg   %ax,%ax
f01215c8:	66 90                	xchg   %ax,%ax
f01215ca:	66 90                	xchg   %ax,%ax
f01215cc:	66 90                	xchg   %ax,%ax
f01215ce:	66 90                	xchg   %ax,%ax
f01215d0:	66 90                	xchg   %ax,%ax
f01215d2:	66 90                	xchg   %ax,%ax
f01215d4:	66 90                	xchg   %ax,%ax
f01215d6:	66 90                	xchg   %ax,%ax
f01215d8:	66 90                	xchg   %ax,%ax
f01215da:	66 90                	xchg   %ax,%ax
f01215dc:	66 90                	xchg   %ax,%ax
f01215de:	66 90                	xchg   %ax,%ax
f01215e0:	66 90                	xchg   %ax,%ax
f01215e2:	66 90                	xchg   %ax,%ax
f01215e4:	66 90                	xchg   %ax,%ax
f01215e6:	66 90                	xchg   %ax,%ax
f01215e8:	66 90                	xchg   %ax,%ax
f01215ea:	66 90                	xchg   %ax,%ax
f01215ec:	66 90                	xchg   %ax,%ax
f01215ee:	66 90                	xchg   %ax,%ax
f01215f0:	66 90                	xchg   %ax,%ax
f01215f2:	66 90                	xchg   %ax,%ax
f01215f4:	66 90                	xchg   %ax,%ax
f01215f6:	66 90                	xchg   %ax,%ax
f01215f8:	66 90                	xchg   %ax,%ax
f01215fa:	66 90                	xchg   %ax,%ax
f01215fc:	66 90                	xchg   %ax,%ax
f01215fe:	66 90                	xchg   %ax,%ax
f0121600:	66 90                	xchg   %ax,%ax
f0121602:	66 90                	xchg   %ax,%ax
f0121604:	66 90                	xchg   %ax,%ax
f0121606:	66 90                	xchg   %ax,%ax
f0121608:	66 90                	xchg   %ax,%ax
f012160a:	66 90                	xchg   %ax,%ax
f012160c:	66 90                	xchg   %ax,%ax
f012160e:	66 90                	xchg   %ax,%ax
f0121610:	66 90                	xchg   %ax,%ax
f0121612:	66 90                	xchg   %ax,%ax
f0121614:	66 90                	xchg   %ax,%ax
f0121616:	66 90                	xchg   %ax,%ax
f0121618:	66 90                	xchg   %ax,%ax
f012161a:	66 90                	xchg   %ax,%ax
f012161c:	66 90                	xchg   %ax,%ax
f012161e:	66 90                	xchg   %ax,%ax
f0121620:	66 90                	xchg   %ax,%ax
f0121622:	66 90                	xchg   %ax,%ax
f0121624:	66 90                	xchg   %ax,%ax
f0121626:	66 90                	xchg   %ax,%ax
f0121628:	66 90                	xchg   %ax,%ax
f012162a:	66 90                	xchg   %ax,%ax
f012162c:	66 90                	xchg   %ax,%ax
f012162e:	66 90                	xchg   %ax,%ax
f0121630:	66 90                	xchg   %ax,%ax
f0121632:	66 90                	xchg   %ax,%ax
f0121634:	66 90                	xchg   %ax,%ax
f0121636:	66 90                	xchg   %ax,%ax
f0121638:	66 90                	xchg   %ax,%ax
f012163a:	66 90                	xchg   %ax,%ax
f012163c:	66 90                	xchg   %ax,%ax
f012163e:	66 90                	xchg   %ax,%ax
f0121640:	66 90                	xchg   %ax,%ax
f0121642:	66 90                	xchg   %ax,%ax
f0121644:	66 90                	xchg   %ax,%ax
f0121646:	66 90                	xchg   %ax,%ax
f0121648:	66 90                	xchg   %ax,%ax
f012164a:	66 90                	xchg   %ax,%ax
f012164c:	66 90                	xchg   %ax,%ax
f012164e:	66 90                	xchg   %ax,%ax
f0121650:	66 90                	xchg   %ax,%ax
f0121652:	66 90                	xchg   %ax,%ax
f0121654:	66 90                	xchg   %ax,%ax
f0121656:	66 90                	xchg   %ax,%ax
f0121658:	66 90                	xchg   %ax,%ax
f012165a:	66 90                	xchg   %ax,%ax
f012165c:	66 90                	xchg   %ax,%ax
f012165e:	66 90                	xchg   %ax,%ax
f0121660:	66 90                	xchg   %ax,%ax
f0121662:	66 90                	xchg   %ax,%ax
f0121664:	66 90                	xchg   %ax,%ax
f0121666:	66 90                	xchg   %ax,%ax
f0121668:	66 90                	xchg   %ax,%ax
f012166a:	66 90                	xchg   %ax,%ax
f012166c:	66 90                	xchg   %ax,%ax
f012166e:	66 90                	xchg   %ax,%ax
f0121670:	66 90                	xchg   %ax,%ax
f0121672:	66 90                	xchg   %ax,%ax
f0121674:	66 90                	xchg   %ax,%ax
f0121676:	66 90                	xchg   %ax,%ax
f0121678:	66 90                	xchg   %ax,%ax
f012167a:	66 90                	xchg   %ax,%ax
f012167c:	66 90                	xchg   %ax,%ax
f012167e:	66 90                	xchg   %ax,%ax
f0121680:	66 90                	xchg   %ax,%ax
f0121682:	66 90                	xchg   %ax,%ax
f0121684:	66 90                	xchg   %ax,%ax
f0121686:	66 90                	xchg   %ax,%ax
f0121688:	66 90                	xchg   %ax,%ax
f012168a:	66 90                	xchg   %ax,%ax
f012168c:	66 90                	xchg   %ax,%ax
f012168e:	66 90                	xchg   %ax,%ax
f0121690:	66 90                	xchg   %ax,%ax
f0121692:	66 90                	xchg   %ax,%ax
f0121694:	66 90                	xchg   %ax,%ax
f0121696:	66 90                	xchg   %ax,%ax
f0121698:	66 90                	xchg   %ax,%ax
f012169a:	66 90                	xchg   %ax,%ax
f012169c:	66 90                	xchg   %ax,%ax
f012169e:	66 90                	xchg   %ax,%ax
f01216a0:	66 90                	xchg   %ax,%ax
f01216a2:	66 90                	xchg   %ax,%ax
f01216a4:	66 90                	xchg   %ax,%ax
f01216a6:	66 90                	xchg   %ax,%ax
f01216a8:	66 90                	xchg   %ax,%ax
f01216aa:	66 90                	xchg   %ax,%ax
f01216ac:	66 90                	xchg   %ax,%ax
f01216ae:	66 90                	xchg   %ax,%ax
f01216b0:	66 90                	xchg   %ax,%ax
f01216b2:	66 90                	xchg   %ax,%ax
f01216b4:	66 90                	xchg   %ax,%ax
f01216b6:	66 90                	xchg   %ax,%ax
f01216b8:	66 90                	xchg   %ax,%ax
f01216ba:	66 90                	xchg   %ax,%ax
f01216bc:	66 90                	xchg   %ax,%ax
f01216be:	66 90                	xchg   %ax,%ax
f01216c0:	66 90                	xchg   %ax,%ax
f01216c2:	66 90                	xchg   %ax,%ax
f01216c4:	66 90                	xchg   %ax,%ax
f01216c6:	66 90                	xchg   %ax,%ax
f01216c8:	66 90                	xchg   %ax,%ax
f01216ca:	66 90                	xchg   %ax,%ax
f01216cc:	66 90                	xchg   %ax,%ax
f01216ce:	66 90                	xchg   %ax,%ax
f01216d0:	66 90                	xchg   %ax,%ax
f01216d2:	66 90                	xchg   %ax,%ax
f01216d4:	66 90                	xchg   %ax,%ax
f01216d6:	66 90                	xchg   %ax,%ax
f01216d8:	66 90                	xchg   %ax,%ax
f01216da:	66 90                	xchg   %ax,%ax
f01216dc:	66 90                	xchg   %ax,%ax
f01216de:	66 90                	xchg   %ax,%ax
f01216e0:	66 90                	xchg   %ax,%ax
f01216e2:	66 90                	xchg   %ax,%ax
f01216e4:	66 90                	xchg   %ax,%ax
f01216e6:	66 90                	xchg   %ax,%ax
f01216e8:	66 90                	xchg   %ax,%ax
f01216ea:	66 90                	xchg   %ax,%ax
f01216ec:	66 90                	xchg   %ax,%ax
f01216ee:	66 90                	xchg   %ax,%ax
f01216f0:	66 90                	xchg   %ax,%ax
f01216f2:	66 90                	xchg   %ax,%ax
f01216f4:	66 90                	xchg   %ax,%ax
f01216f6:	66 90                	xchg   %ax,%ax
f01216f8:	66 90                	xchg   %ax,%ax
f01216fa:	66 90                	xchg   %ax,%ax
f01216fc:	66 90                	xchg   %ax,%ax
f01216fe:	66 90                	xchg   %ax,%ax
f0121700:	66 90                	xchg   %ax,%ax
f0121702:	66 90                	xchg   %ax,%ax
f0121704:	66 90                	xchg   %ax,%ax
f0121706:	66 90                	xchg   %ax,%ax
f0121708:	66 90                	xchg   %ax,%ax
f012170a:	66 90                	xchg   %ax,%ax
f012170c:	66 90                	xchg   %ax,%ax
f012170e:	66 90                	xchg   %ax,%ax
f0121710:	66 90                	xchg   %ax,%ax
f0121712:	66 90                	xchg   %ax,%ax
f0121714:	66 90                	xchg   %ax,%ax
f0121716:	66 90                	xchg   %ax,%ax
f0121718:	66 90                	xchg   %ax,%ax
f012171a:	66 90                	xchg   %ax,%ax
f012171c:	66 90                	xchg   %ax,%ax
f012171e:	66 90                	xchg   %ax,%ax
f0121720:	66 90                	xchg   %ax,%ax
f0121722:	66 90                	xchg   %ax,%ax
f0121724:	66 90                	xchg   %ax,%ax
f0121726:	66 90                	xchg   %ax,%ax
f0121728:	66 90                	xchg   %ax,%ax
f012172a:	66 90                	xchg   %ax,%ax
f012172c:	66 90                	xchg   %ax,%ax
f012172e:	66 90                	xchg   %ax,%ax
f0121730:	66 90                	xchg   %ax,%ax
f0121732:	66 90                	xchg   %ax,%ax
f0121734:	66 90                	xchg   %ax,%ax
f0121736:	66 90                	xchg   %ax,%ax
f0121738:	66 90                	xchg   %ax,%ax
f012173a:	66 90                	xchg   %ax,%ax
f012173c:	66 90                	xchg   %ax,%ax
f012173e:	66 90                	xchg   %ax,%ax
f0121740:	66 90                	xchg   %ax,%ax
f0121742:	66 90                	xchg   %ax,%ax
f0121744:	66 90                	xchg   %ax,%ax
f0121746:	66 90                	xchg   %ax,%ax
f0121748:	66 90                	xchg   %ax,%ax
f012174a:	66 90                	xchg   %ax,%ax
f012174c:	66 90                	xchg   %ax,%ax
f012174e:	66 90                	xchg   %ax,%ax
f0121750:	66 90                	xchg   %ax,%ax
f0121752:	66 90                	xchg   %ax,%ax
f0121754:	66 90                	xchg   %ax,%ax
f0121756:	66 90                	xchg   %ax,%ax
f0121758:	66 90                	xchg   %ax,%ax
f012175a:	66 90                	xchg   %ax,%ax
f012175c:	66 90                	xchg   %ax,%ax
f012175e:	66 90                	xchg   %ax,%ax
f0121760:	66 90                	xchg   %ax,%ax
f0121762:	66 90                	xchg   %ax,%ax
f0121764:	66 90                	xchg   %ax,%ax
f0121766:	66 90                	xchg   %ax,%ax
f0121768:	66 90                	xchg   %ax,%ax
f012176a:	66 90                	xchg   %ax,%ax
f012176c:	66 90                	xchg   %ax,%ax
f012176e:	66 90                	xchg   %ax,%ax
f0121770:	66 90                	xchg   %ax,%ax
f0121772:	66 90                	xchg   %ax,%ax
f0121774:	66 90                	xchg   %ax,%ax
f0121776:	66 90                	xchg   %ax,%ax
f0121778:	66 90                	xchg   %ax,%ax
f012177a:	66 90                	xchg   %ax,%ax
f012177c:	66 90                	xchg   %ax,%ax
f012177e:	66 90                	xchg   %ax,%ax
f0121780:	66 90                	xchg   %ax,%ax
f0121782:	66 90                	xchg   %ax,%ax
f0121784:	66 90                	xchg   %ax,%ax
f0121786:	66 90                	xchg   %ax,%ax
f0121788:	66 90                	xchg   %ax,%ax
f012178a:	66 90                	xchg   %ax,%ax
f012178c:	66 90                	xchg   %ax,%ax
f012178e:	66 90                	xchg   %ax,%ax
f0121790:	66 90                	xchg   %ax,%ax
f0121792:	66 90                	xchg   %ax,%ax
f0121794:	66 90                	xchg   %ax,%ax
f0121796:	66 90                	xchg   %ax,%ax
f0121798:	66 90                	xchg   %ax,%ax
f012179a:	66 90                	xchg   %ax,%ax
f012179c:	66 90                	xchg   %ax,%ax
f012179e:	66 90                	xchg   %ax,%ax
f01217a0:	66 90                	xchg   %ax,%ax
f01217a2:	66 90                	xchg   %ax,%ax
f01217a4:	66 90                	xchg   %ax,%ax
f01217a6:	66 90                	xchg   %ax,%ax
f01217a8:	66 90                	xchg   %ax,%ax
f01217aa:	66 90                	xchg   %ax,%ax
f01217ac:	66 90                	xchg   %ax,%ax
f01217ae:	66 90                	xchg   %ax,%ax
f01217b0:	66 90                	xchg   %ax,%ax
f01217b2:	66 90                	xchg   %ax,%ax
f01217b4:	66 90                	xchg   %ax,%ax
f01217b6:	66 90                	xchg   %ax,%ax
f01217b8:	66 90                	xchg   %ax,%ax
f01217ba:	66 90                	xchg   %ax,%ax
f01217bc:	66 90                	xchg   %ax,%ax
f01217be:	66 90                	xchg   %ax,%ax
f01217c0:	66 90                	xchg   %ax,%ax
f01217c2:	66 90                	xchg   %ax,%ax
f01217c4:	66 90                	xchg   %ax,%ax
f01217c6:	66 90                	xchg   %ax,%ax
f01217c8:	66 90                	xchg   %ax,%ax
f01217ca:	66 90                	xchg   %ax,%ax
f01217cc:	66 90                	xchg   %ax,%ax
f01217ce:	66 90                	xchg   %ax,%ax
f01217d0:	66 90                	xchg   %ax,%ax
f01217d2:	66 90                	xchg   %ax,%ax
f01217d4:	66 90                	xchg   %ax,%ax
f01217d6:	66 90                	xchg   %ax,%ax
f01217d8:	66 90                	xchg   %ax,%ax
f01217da:	66 90                	xchg   %ax,%ax
f01217dc:	66 90                	xchg   %ax,%ax
f01217de:	66 90                	xchg   %ax,%ax
f01217e0:	66 90                	xchg   %ax,%ax
f01217e2:	66 90                	xchg   %ax,%ax
f01217e4:	66 90                	xchg   %ax,%ax
f01217e6:	66 90                	xchg   %ax,%ax
f01217e8:	66 90                	xchg   %ax,%ax
f01217ea:	66 90                	xchg   %ax,%ax
f01217ec:	66 90                	xchg   %ax,%ax
f01217ee:	66 90                	xchg   %ax,%ax
f01217f0:	66 90                	xchg   %ax,%ax
f01217f2:	66 90                	xchg   %ax,%ax
f01217f4:	66 90                	xchg   %ax,%ax
f01217f6:	66 90                	xchg   %ax,%ax
f01217f8:	66 90                	xchg   %ax,%ax
f01217fa:	66 90                	xchg   %ax,%ax
f01217fc:	66 90                	xchg   %ax,%ax
f01217fe:	66 90                	xchg   %ax,%ax
f0121800:	66 90                	xchg   %ax,%ax
f0121802:	66 90                	xchg   %ax,%ax
f0121804:	66 90                	xchg   %ax,%ax
f0121806:	66 90                	xchg   %ax,%ax
f0121808:	66 90                	xchg   %ax,%ax
f012180a:	66 90                	xchg   %ax,%ax
f012180c:	66 90                	xchg   %ax,%ax
f012180e:	66 90                	xchg   %ax,%ax
f0121810:	66 90                	xchg   %ax,%ax
f0121812:	66 90                	xchg   %ax,%ax
f0121814:	66 90                	xchg   %ax,%ax
f0121816:	66 90                	xchg   %ax,%ax
f0121818:	66 90                	xchg   %ax,%ax
f012181a:	66 90                	xchg   %ax,%ax
f012181c:	66 90                	xchg   %ax,%ax
f012181e:	66 90                	xchg   %ax,%ax
f0121820:	66 90                	xchg   %ax,%ax
f0121822:	66 90                	xchg   %ax,%ax
f0121824:	66 90                	xchg   %ax,%ax
f0121826:	66 90                	xchg   %ax,%ax
f0121828:	66 90                	xchg   %ax,%ax
f012182a:	66 90                	xchg   %ax,%ax
f012182c:	66 90                	xchg   %ax,%ax
f012182e:	66 90                	xchg   %ax,%ax
f0121830:	66 90                	xchg   %ax,%ax
f0121832:	66 90                	xchg   %ax,%ax
f0121834:	66 90                	xchg   %ax,%ax
f0121836:	66 90                	xchg   %ax,%ax
f0121838:	66 90                	xchg   %ax,%ax
f012183a:	66 90                	xchg   %ax,%ax
f012183c:	66 90                	xchg   %ax,%ax
f012183e:	66 90                	xchg   %ax,%ax
f0121840:	66 90                	xchg   %ax,%ax
f0121842:	66 90                	xchg   %ax,%ax
f0121844:	66 90                	xchg   %ax,%ax
f0121846:	66 90                	xchg   %ax,%ax
f0121848:	66 90                	xchg   %ax,%ax
f012184a:	66 90                	xchg   %ax,%ax
f012184c:	66 90                	xchg   %ax,%ax
f012184e:	66 90                	xchg   %ax,%ax
f0121850:	66 90                	xchg   %ax,%ax
f0121852:	66 90                	xchg   %ax,%ax
f0121854:	66 90                	xchg   %ax,%ax
f0121856:	66 90                	xchg   %ax,%ax
f0121858:	66 90                	xchg   %ax,%ax
f012185a:	66 90                	xchg   %ax,%ax
f012185c:	66 90                	xchg   %ax,%ax
f012185e:	66 90                	xchg   %ax,%ax
f0121860:	66 90                	xchg   %ax,%ax
f0121862:	66 90                	xchg   %ax,%ax
f0121864:	66 90                	xchg   %ax,%ax
f0121866:	66 90                	xchg   %ax,%ax
f0121868:	66 90                	xchg   %ax,%ax
f012186a:	66 90                	xchg   %ax,%ax
f012186c:	66 90                	xchg   %ax,%ax
f012186e:	66 90                	xchg   %ax,%ax
f0121870:	66 90                	xchg   %ax,%ax
f0121872:	66 90                	xchg   %ax,%ax
f0121874:	66 90                	xchg   %ax,%ax
f0121876:	66 90                	xchg   %ax,%ax
f0121878:	66 90                	xchg   %ax,%ax
f012187a:	66 90                	xchg   %ax,%ax
f012187c:	66 90                	xchg   %ax,%ax
f012187e:	66 90                	xchg   %ax,%ax
f0121880:	66 90                	xchg   %ax,%ax
f0121882:	66 90                	xchg   %ax,%ax
f0121884:	66 90                	xchg   %ax,%ax
f0121886:	66 90                	xchg   %ax,%ax
f0121888:	66 90                	xchg   %ax,%ax
f012188a:	66 90                	xchg   %ax,%ax
f012188c:	66 90                	xchg   %ax,%ax
f012188e:	66 90                	xchg   %ax,%ax
f0121890:	66 90                	xchg   %ax,%ax
f0121892:	66 90                	xchg   %ax,%ax
f0121894:	66 90                	xchg   %ax,%ax
f0121896:	66 90                	xchg   %ax,%ax
f0121898:	66 90                	xchg   %ax,%ax
f012189a:	66 90                	xchg   %ax,%ax
f012189c:	66 90                	xchg   %ax,%ax
f012189e:	66 90                	xchg   %ax,%ax
f01218a0:	66 90                	xchg   %ax,%ax
f01218a2:	66 90                	xchg   %ax,%ax
f01218a4:	66 90                	xchg   %ax,%ax
f01218a6:	66 90                	xchg   %ax,%ax
f01218a8:	66 90                	xchg   %ax,%ax
f01218aa:	66 90                	xchg   %ax,%ax
f01218ac:	66 90                	xchg   %ax,%ax
f01218ae:	66 90                	xchg   %ax,%ax
f01218b0:	66 90                	xchg   %ax,%ax
f01218b2:	66 90                	xchg   %ax,%ax
f01218b4:	66 90                	xchg   %ax,%ax
f01218b6:	66 90                	xchg   %ax,%ax
f01218b8:	66 90                	xchg   %ax,%ax
f01218ba:	66 90                	xchg   %ax,%ax
f01218bc:	66 90                	xchg   %ax,%ax
f01218be:	66 90                	xchg   %ax,%ax
f01218c0:	66 90                	xchg   %ax,%ax
f01218c2:	66 90                	xchg   %ax,%ax
f01218c4:	66 90                	xchg   %ax,%ax
f01218c6:	66 90                	xchg   %ax,%ax
f01218c8:	66 90                	xchg   %ax,%ax
f01218ca:	66 90                	xchg   %ax,%ax
f01218cc:	66 90                	xchg   %ax,%ax
f01218ce:	66 90                	xchg   %ax,%ax
f01218d0:	66 90                	xchg   %ax,%ax
f01218d2:	66 90                	xchg   %ax,%ax
f01218d4:	66 90                	xchg   %ax,%ax
f01218d6:	66 90                	xchg   %ax,%ax
f01218d8:	66 90                	xchg   %ax,%ax
f01218da:	66 90                	xchg   %ax,%ax
f01218dc:	66 90                	xchg   %ax,%ax
f01218de:	66 90                	xchg   %ax,%ax
f01218e0:	66 90                	xchg   %ax,%ax
f01218e2:	66 90                	xchg   %ax,%ax
f01218e4:	66 90                	xchg   %ax,%ax
f01218e6:	66 90                	xchg   %ax,%ax
f01218e8:	66 90                	xchg   %ax,%ax
f01218ea:	66 90                	xchg   %ax,%ax
f01218ec:	66 90                	xchg   %ax,%ax
f01218ee:	66 90                	xchg   %ax,%ax
f01218f0:	66 90                	xchg   %ax,%ax
f01218f2:	66 90                	xchg   %ax,%ax
f01218f4:	66 90                	xchg   %ax,%ax
f01218f6:	66 90                	xchg   %ax,%ax
f01218f8:	66 90                	xchg   %ax,%ax
f01218fa:	66 90                	xchg   %ax,%ax
f01218fc:	66 90                	xchg   %ax,%ax
f01218fe:	66 90                	xchg   %ax,%ax
f0121900:	66 90                	xchg   %ax,%ax
f0121902:	66 90                	xchg   %ax,%ax
f0121904:	66 90                	xchg   %ax,%ax
f0121906:	66 90                	xchg   %ax,%ax
f0121908:	66 90                	xchg   %ax,%ax
f012190a:	66 90                	xchg   %ax,%ax
f012190c:	66 90                	xchg   %ax,%ax
f012190e:	66 90                	xchg   %ax,%ax
f0121910:	66 90                	xchg   %ax,%ax
f0121912:	66 90                	xchg   %ax,%ax
f0121914:	66 90                	xchg   %ax,%ax
f0121916:	66 90                	xchg   %ax,%ax
f0121918:	66 90                	xchg   %ax,%ax
f012191a:	66 90                	xchg   %ax,%ax
f012191c:	66 90                	xchg   %ax,%ax
f012191e:	66 90                	xchg   %ax,%ax
f0121920:	66 90                	xchg   %ax,%ax
f0121922:	66 90                	xchg   %ax,%ax
f0121924:	66 90                	xchg   %ax,%ax
f0121926:	66 90                	xchg   %ax,%ax
f0121928:	66 90                	xchg   %ax,%ax
f012192a:	66 90                	xchg   %ax,%ax
f012192c:	66 90                	xchg   %ax,%ax
f012192e:	66 90                	xchg   %ax,%ax
f0121930:	66 90                	xchg   %ax,%ax
f0121932:	66 90                	xchg   %ax,%ax
f0121934:	66 90                	xchg   %ax,%ax
f0121936:	66 90                	xchg   %ax,%ax
f0121938:	66 90                	xchg   %ax,%ax
f012193a:	66 90                	xchg   %ax,%ax
f012193c:	66 90                	xchg   %ax,%ax
f012193e:	66 90                	xchg   %ax,%ax
f0121940:	66 90                	xchg   %ax,%ax
f0121942:	66 90                	xchg   %ax,%ax
f0121944:	66 90                	xchg   %ax,%ax
f0121946:	66 90                	xchg   %ax,%ax
f0121948:	66 90                	xchg   %ax,%ax
f012194a:	66 90                	xchg   %ax,%ax
f012194c:	66 90                	xchg   %ax,%ax
f012194e:	66 90                	xchg   %ax,%ax
f0121950:	66 90                	xchg   %ax,%ax
f0121952:	66 90                	xchg   %ax,%ax
f0121954:	66 90                	xchg   %ax,%ax
f0121956:	66 90                	xchg   %ax,%ax
f0121958:	66 90                	xchg   %ax,%ax
f012195a:	66 90                	xchg   %ax,%ax
f012195c:	66 90                	xchg   %ax,%ax
f012195e:	66 90                	xchg   %ax,%ax
f0121960:	66 90                	xchg   %ax,%ax
f0121962:	66 90                	xchg   %ax,%ax
f0121964:	66 90                	xchg   %ax,%ax
f0121966:	66 90                	xchg   %ax,%ax
f0121968:	66 90                	xchg   %ax,%ax
f012196a:	66 90                	xchg   %ax,%ax
f012196c:	66 90                	xchg   %ax,%ax
f012196e:	66 90                	xchg   %ax,%ax
f0121970:	66 90                	xchg   %ax,%ax
f0121972:	66 90                	xchg   %ax,%ax
f0121974:	66 90                	xchg   %ax,%ax
f0121976:	66 90                	xchg   %ax,%ax
f0121978:	66 90                	xchg   %ax,%ax
f012197a:	66 90                	xchg   %ax,%ax
f012197c:	66 90                	xchg   %ax,%ax
f012197e:	66 90                	xchg   %ax,%ax
f0121980:	66 90                	xchg   %ax,%ax
f0121982:	66 90                	xchg   %ax,%ax
f0121984:	66 90                	xchg   %ax,%ax
f0121986:	66 90                	xchg   %ax,%ax
f0121988:	66 90                	xchg   %ax,%ax
f012198a:	66 90                	xchg   %ax,%ax
f012198c:	66 90                	xchg   %ax,%ax
f012198e:	66 90                	xchg   %ax,%ax
f0121990:	66 90                	xchg   %ax,%ax
f0121992:	66 90                	xchg   %ax,%ax
f0121994:	66 90                	xchg   %ax,%ax
f0121996:	66 90                	xchg   %ax,%ax
f0121998:	66 90                	xchg   %ax,%ax
f012199a:	66 90                	xchg   %ax,%ax
f012199c:	66 90                	xchg   %ax,%ax
f012199e:	66 90                	xchg   %ax,%ax
f01219a0:	66 90                	xchg   %ax,%ax
f01219a2:	66 90                	xchg   %ax,%ax
f01219a4:	66 90                	xchg   %ax,%ax
f01219a6:	66 90                	xchg   %ax,%ax
f01219a8:	66 90                	xchg   %ax,%ax
f01219aa:	66 90                	xchg   %ax,%ax
f01219ac:	66 90                	xchg   %ax,%ax
f01219ae:	66 90                	xchg   %ax,%ax
f01219b0:	66 90                	xchg   %ax,%ax
f01219b2:	66 90                	xchg   %ax,%ax
f01219b4:	66 90                	xchg   %ax,%ax
f01219b6:	66 90                	xchg   %ax,%ax
f01219b8:	66 90                	xchg   %ax,%ax
f01219ba:	66 90                	xchg   %ax,%ax
f01219bc:	66 90                	xchg   %ax,%ax
f01219be:	66 90                	xchg   %ax,%ax
f01219c0:	66 90                	xchg   %ax,%ax
f01219c2:	66 90                	xchg   %ax,%ax
f01219c4:	66 90                	xchg   %ax,%ax
f01219c6:	66 90                	xchg   %ax,%ax
f01219c8:	66 90                	xchg   %ax,%ax
f01219ca:	66 90                	xchg   %ax,%ax
f01219cc:	66 90                	xchg   %ax,%ax
f01219ce:	66 90                	xchg   %ax,%ax
f01219d0:	66 90                	xchg   %ax,%ax
f01219d2:	66 90                	xchg   %ax,%ax
f01219d4:	66 90                	xchg   %ax,%ax
f01219d6:	66 90                	xchg   %ax,%ax
f01219d8:	66 90                	xchg   %ax,%ax
f01219da:	66 90                	xchg   %ax,%ax
f01219dc:	66 90                	xchg   %ax,%ax
f01219de:	66 90                	xchg   %ax,%ax
f01219e0:	66 90                	xchg   %ax,%ax
f01219e2:	66 90                	xchg   %ax,%ax
f01219e4:	66 90                	xchg   %ax,%ax
f01219e6:	66 90                	xchg   %ax,%ax
f01219e8:	66 90                	xchg   %ax,%ax
f01219ea:	66 90                	xchg   %ax,%ax
f01219ec:	66 90                	xchg   %ax,%ax
f01219ee:	66 90                	xchg   %ax,%ax
f01219f0:	66 90                	xchg   %ax,%ax
f01219f2:	66 90                	xchg   %ax,%ax
f01219f4:	66 90                	xchg   %ax,%ax
f01219f6:	66 90                	xchg   %ax,%ax
f01219f8:	66 90                	xchg   %ax,%ax
f01219fa:	66 90                	xchg   %ax,%ax
f01219fc:	66 90                	xchg   %ax,%ax
f01219fe:	66 90                	xchg   %ax,%ax
f0121a00:	66 90                	xchg   %ax,%ax
f0121a02:	66 90                	xchg   %ax,%ax
f0121a04:	66 90                	xchg   %ax,%ax
f0121a06:	66 90                	xchg   %ax,%ax
f0121a08:	66 90                	xchg   %ax,%ax
f0121a0a:	66 90                	xchg   %ax,%ax
f0121a0c:	66 90                	xchg   %ax,%ax
f0121a0e:	66 90                	xchg   %ax,%ax
f0121a10:	66 90                	xchg   %ax,%ax
f0121a12:	66 90                	xchg   %ax,%ax
f0121a14:	66 90                	xchg   %ax,%ax
f0121a16:	66 90                	xchg   %ax,%ax
f0121a18:	66 90                	xchg   %ax,%ax
f0121a1a:	66 90                	xchg   %ax,%ax
f0121a1c:	66 90                	xchg   %ax,%ax
f0121a1e:	66 90                	xchg   %ax,%ax
f0121a20:	66 90                	xchg   %ax,%ax
f0121a22:	66 90                	xchg   %ax,%ax
f0121a24:	66 90                	xchg   %ax,%ax
f0121a26:	66 90                	xchg   %ax,%ax
f0121a28:	66 90                	xchg   %ax,%ax
f0121a2a:	66 90                	xchg   %ax,%ax
f0121a2c:	66 90                	xchg   %ax,%ax
f0121a2e:	66 90                	xchg   %ax,%ax
f0121a30:	66 90                	xchg   %ax,%ax
f0121a32:	66 90                	xchg   %ax,%ax
f0121a34:	66 90                	xchg   %ax,%ax
f0121a36:	66 90                	xchg   %ax,%ax
f0121a38:	66 90                	xchg   %ax,%ax
f0121a3a:	66 90                	xchg   %ax,%ax
f0121a3c:	66 90                	xchg   %ax,%ax
f0121a3e:	66 90                	xchg   %ax,%ax
f0121a40:	66 90                	xchg   %ax,%ax
f0121a42:	66 90                	xchg   %ax,%ax
f0121a44:	66 90                	xchg   %ax,%ax
f0121a46:	66 90                	xchg   %ax,%ax
f0121a48:	66 90                	xchg   %ax,%ax
f0121a4a:	66 90                	xchg   %ax,%ax
f0121a4c:	66 90                	xchg   %ax,%ax
f0121a4e:	66 90                	xchg   %ax,%ax
f0121a50:	66 90                	xchg   %ax,%ax
f0121a52:	66 90                	xchg   %ax,%ax
f0121a54:	66 90                	xchg   %ax,%ax
f0121a56:	66 90                	xchg   %ax,%ax
f0121a58:	66 90                	xchg   %ax,%ax
f0121a5a:	66 90                	xchg   %ax,%ax
f0121a5c:	66 90                	xchg   %ax,%ax
f0121a5e:	66 90                	xchg   %ax,%ax
f0121a60:	66 90                	xchg   %ax,%ax
f0121a62:	66 90                	xchg   %ax,%ax
f0121a64:	66 90                	xchg   %ax,%ax
f0121a66:	66 90                	xchg   %ax,%ax
f0121a68:	66 90                	xchg   %ax,%ax
f0121a6a:	66 90                	xchg   %ax,%ax
f0121a6c:	66 90                	xchg   %ax,%ax
f0121a6e:	66 90                	xchg   %ax,%ax
f0121a70:	66 90                	xchg   %ax,%ax
f0121a72:	66 90                	xchg   %ax,%ax
f0121a74:	66 90                	xchg   %ax,%ax
f0121a76:	66 90                	xchg   %ax,%ax
f0121a78:	66 90                	xchg   %ax,%ax
f0121a7a:	66 90                	xchg   %ax,%ax
f0121a7c:	66 90                	xchg   %ax,%ax
f0121a7e:	66 90                	xchg   %ax,%ax
f0121a80:	66 90                	xchg   %ax,%ax
f0121a82:	66 90                	xchg   %ax,%ax
f0121a84:	66 90                	xchg   %ax,%ax
f0121a86:	66 90                	xchg   %ax,%ax
f0121a88:	66 90                	xchg   %ax,%ax
f0121a8a:	66 90                	xchg   %ax,%ax
f0121a8c:	66 90                	xchg   %ax,%ax
f0121a8e:	66 90                	xchg   %ax,%ax
f0121a90:	66 90                	xchg   %ax,%ax
f0121a92:	66 90                	xchg   %ax,%ax
f0121a94:	66 90                	xchg   %ax,%ax
f0121a96:	66 90                	xchg   %ax,%ax
f0121a98:	66 90                	xchg   %ax,%ax
f0121a9a:	66 90                	xchg   %ax,%ax
f0121a9c:	66 90                	xchg   %ax,%ax
f0121a9e:	66 90                	xchg   %ax,%ax
f0121aa0:	66 90                	xchg   %ax,%ax
f0121aa2:	66 90                	xchg   %ax,%ax
f0121aa4:	66 90                	xchg   %ax,%ax
f0121aa6:	66 90                	xchg   %ax,%ax
f0121aa8:	66 90                	xchg   %ax,%ax
f0121aaa:	66 90                	xchg   %ax,%ax
f0121aac:	66 90                	xchg   %ax,%ax
f0121aae:	66 90                	xchg   %ax,%ax
f0121ab0:	66 90                	xchg   %ax,%ax
f0121ab2:	66 90                	xchg   %ax,%ax
f0121ab4:	66 90                	xchg   %ax,%ax
f0121ab6:	66 90                	xchg   %ax,%ax
f0121ab8:	66 90                	xchg   %ax,%ax
f0121aba:	66 90                	xchg   %ax,%ax
f0121abc:	66 90                	xchg   %ax,%ax
f0121abe:	66 90                	xchg   %ax,%ax
f0121ac0:	66 90                	xchg   %ax,%ax
f0121ac2:	66 90                	xchg   %ax,%ax
f0121ac4:	66 90                	xchg   %ax,%ax
f0121ac6:	66 90                	xchg   %ax,%ax
f0121ac8:	66 90                	xchg   %ax,%ax
f0121aca:	66 90                	xchg   %ax,%ax
f0121acc:	66 90                	xchg   %ax,%ax
f0121ace:	66 90                	xchg   %ax,%ax
f0121ad0:	66 90                	xchg   %ax,%ax
f0121ad2:	66 90                	xchg   %ax,%ax
f0121ad4:	66 90                	xchg   %ax,%ax
f0121ad6:	66 90                	xchg   %ax,%ax
f0121ad8:	66 90                	xchg   %ax,%ax
f0121ada:	66 90                	xchg   %ax,%ax
f0121adc:	66 90                	xchg   %ax,%ax
f0121ade:	66 90                	xchg   %ax,%ax
f0121ae0:	66 90                	xchg   %ax,%ax
f0121ae2:	66 90                	xchg   %ax,%ax
f0121ae4:	66 90                	xchg   %ax,%ax
f0121ae6:	66 90                	xchg   %ax,%ax
f0121ae8:	66 90                	xchg   %ax,%ax
f0121aea:	66 90                	xchg   %ax,%ax
f0121aec:	66 90                	xchg   %ax,%ax
f0121aee:	66 90                	xchg   %ax,%ax
f0121af0:	66 90                	xchg   %ax,%ax
f0121af2:	66 90                	xchg   %ax,%ax
f0121af4:	66 90                	xchg   %ax,%ax
f0121af6:	66 90                	xchg   %ax,%ax
f0121af8:	66 90                	xchg   %ax,%ax
f0121afa:	66 90                	xchg   %ax,%ax
f0121afc:	66 90                	xchg   %ax,%ax
f0121afe:	66 90                	xchg   %ax,%ax
f0121b00:	66 90                	xchg   %ax,%ax
f0121b02:	66 90                	xchg   %ax,%ax
f0121b04:	66 90                	xchg   %ax,%ax
f0121b06:	66 90                	xchg   %ax,%ax
f0121b08:	66 90                	xchg   %ax,%ax
f0121b0a:	66 90                	xchg   %ax,%ax
f0121b0c:	66 90                	xchg   %ax,%ax
f0121b0e:	66 90                	xchg   %ax,%ax
f0121b10:	66 90                	xchg   %ax,%ax
f0121b12:	66 90                	xchg   %ax,%ax
f0121b14:	66 90                	xchg   %ax,%ax
f0121b16:	66 90                	xchg   %ax,%ax
f0121b18:	66 90                	xchg   %ax,%ax
f0121b1a:	66 90                	xchg   %ax,%ax
f0121b1c:	66 90                	xchg   %ax,%ax
f0121b1e:	66 90                	xchg   %ax,%ax
f0121b20:	66 90                	xchg   %ax,%ax
f0121b22:	66 90                	xchg   %ax,%ax
f0121b24:	66 90                	xchg   %ax,%ax
f0121b26:	66 90                	xchg   %ax,%ax
f0121b28:	66 90                	xchg   %ax,%ax
f0121b2a:	66 90                	xchg   %ax,%ax
f0121b2c:	66 90                	xchg   %ax,%ax
f0121b2e:	66 90                	xchg   %ax,%ax
f0121b30:	66 90                	xchg   %ax,%ax
f0121b32:	66 90                	xchg   %ax,%ax
f0121b34:	66 90                	xchg   %ax,%ax
f0121b36:	66 90                	xchg   %ax,%ax
f0121b38:	66 90                	xchg   %ax,%ax
f0121b3a:	66 90                	xchg   %ax,%ax
f0121b3c:	66 90                	xchg   %ax,%ax
f0121b3e:	66 90                	xchg   %ax,%ax
f0121b40:	66 90                	xchg   %ax,%ax
f0121b42:	66 90                	xchg   %ax,%ax
f0121b44:	66 90                	xchg   %ax,%ax
f0121b46:	66 90                	xchg   %ax,%ax
f0121b48:	66 90                	xchg   %ax,%ax
f0121b4a:	66 90                	xchg   %ax,%ax
f0121b4c:	66 90                	xchg   %ax,%ax
f0121b4e:	66 90                	xchg   %ax,%ax
f0121b50:	66 90                	xchg   %ax,%ax
f0121b52:	66 90                	xchg   %ax,%ax
f0121b54:	66 90                	xchg   %ax,%ax
f0121b56:	66 90                	xchg   %ax,%ax
f0121b58:	66 90                	xchg   %ax,%ax
f0121b5a:	66 90                	xchg   %ax,%ax
f0121b5c:	66 90                	xchg   %ax,%ax
f0121b5e:	66 90                	xchg   %ax,%ax
f0121b60:	66 90                	xchg   %ax,%ax
f0121b62:	66 90                	xchg   %ax,%ax
f0121b64:	66 90                	xchg   %ax,%ax
f0121b66:	66 90                	xchg   %ax,%ax
f0121b68:	66 90                	xchg   %ax,%ax
f0121b6a:	66 90                	xchg   %ax,%ax
f0121b6c:	66 90                	xchg   %ax,%ax
f0121b6e:	66 90                	xchg   %ax,%ax
f0121b70:	66 90                	xchg   %ax,%ax
f0121b72:	66 90                	xchg   %ax,%ax
f0121b74:	66 90                	xchg   %ax,%ax
f0121b76:	66 90                	xchg   %ax,%ax
f0121b78:	66 90                	xchg   %ax,%ax
f0121b7a:	66 90                	xchg   %ax,%ax
f0121b7c:	66 90                	xchg   %ax,%ax
f0121b7e:	66 90                	xchg   %ax,%ax
f0121b80:	66 90                	xchg   %ax,%ax
f0121b82:	66 90                	xchg   %ax,%ax
f0121b84:	66 90                	xchg   %ax,%ax
f0121b86:	66 90                	xchg   %ax,%ax
f0121b88:	66 90                	xchg   %ax,%ax
f0121b8a:	66 90                	xchg   %ax,%ax
f0121b8c:	66 90                	xchg   %ax,%ax
f0121b8e:	66 90                	xchg   %ax,%ax
f0121b90:	66 90                	xchg   %ax,%ax
f0121b92:	66 90                	xchg   %ax,%ax
f0121b94:	66 90                	xchg   %ax,%ax
f0121b96:	66 90                	xchg   %ax,%ax
f0121b98:	66 90                	xchg   %ax,%ax
f0121b9a:	66 90                	xchg   %ax,%ax
f0121b9c:	66 90                	xchg   %ax,%ax
f0121b9e:	66 90                	xchg   %ax,%ax
f0121ba0:	66 90                	xchg   %ax,%ax
f0121ba2:	66 90                	xchg   %ax,%ax
f0121ba4:	66 90                	xchg   %ax,%ax
f0121ba6:	66 90                	xchg   %ax,%ax
f0121ba8:	66 90                	xchg   %ax,%ax
f0121baa:	66 90                	xchg   %ax,%ax
f0121bac:	66 90                	xchg   %ax,%ax
f0121bae:	66 90                	xchg   %ax,%ax
f0121bb0:	66 90                	xchg   %ax,%ax
f0121bb2:	66 90                	xchg   %ax,%ax
f0121bb4:	66 90                	xchg   %ax,%ax
f0121bb6:	66 90                	xchg   %ax,%ax
f0121bb8:	66 90                	xchg   %ax,%ax
f0121bba:	66 90                	xchg   %ax,%ax
f0121bbc:	66 90                	xchg   %ax,%ax
f0121bbe:	66 90                	xchg   %ax,%ax
f0121bc0:	66 90                	xchg   %ax,%ax
f0121bc2:	66 90                	xchg   %ax,%ax
f0121bc4:	66 90                	xchg   %ax,%ax
f0121bc6:	66 90                	xchg   %ax,%ax
f0121bc8:	66 90                	xchg   %ax,%ax
f0121bca:	66 90                	xchg   %ax,%ax
f0121bcc:	66 90                	xchg   %ax,%ax
f0121bce:	66 90                	xchg   %ax,%ax
f0121bd0:	66 90                	xchg   %ax,%ax
f0121bd2:	66 90                	xchg   %ax,%ax
f0121bd4:	66 90                	xchg   %ax,%ax
f0121bd6:	66 90                	xchg   %ax,%ax
f0121bd8:	66 90                	xchg   %ax,%ax
f0121bda:	66 90                	xchg   %ax,%ax
f0121bdc:	66 90                	xchg   %ax,%ax
f0121bde:	66 90                	xchg   %ax,%ax
f0121be0:	66 90                	xchg   %ax,%ax
f0121be2:	66 90                	xchg   %ax,%ax
f0121be4:	66 90                	xchg   %ax,%ax
f0121be6:	66 90                	xchg   %ax,%ax
f0121be8:	66 90                	xchg   %ax,%ax
f0121bea:	66 90                	xchg   %ax,%ax
f0121bec:	66 90                	xchg   %ax,%ax
f0121bee:	66 90                	xchg   %ax,%ax
f0121bf0:	66 90                	xchg   %ax,%ax
f0121bf2:	66 90                	xchg   %ax,%ax
f0121bf4:	66 90                	xchg   %ax,%ax
f0121bf6:	66 90                	xchg   %ax,%ax
f0121bf8:	66 90                	xchg   %ax,%ax
f0121bfa:	66 90                	xchg   %ax,%ax
f0121bfc:	66 90                	xchg   %ax,%ax
f0121bfe:	66 90                	xchg   %ax,%ax
f0121c00:	66 90                	xchg   %ax,%ax
f0121c02:	66 90                	xchg   %ax,%ax
f0121c04:	66 90                	xchg   %ax,%ax
f0121c06:	66 90                	xchg   %ax,%ax
f0121c08:	66 90                	xchg   %ax,%ax
f0121c0a:	66 90                	xchg   %ax,%ax
f0121c0c:	66 90                	xchg   %ax,%ax
f0121c0e:	66 90                	xchg   %ax,%ax
f0121c10:	66 90                	xchg   %ax,%ax
f0121c12:	66 90                	xchg   %ax,%ax
f0121c14:	66 90                	xchg   %ax,%ax
f0121c16:	66 90                	xchg   %ax,%ax
f0121c18:	66 90                	xchg   %ax,%ax
f0121c1a:	66 90                	xchg   %ax,%ax
f0121c1c:	66 90                	xchg   %ax,%ax
f0121c1e:	66 90                	xchg   %ax,%ax
f0121c20:	66 90                	xchg   %ax,%ax
f0121c22:	66 90                	xchg   %ax,%ax
f0121c24:	66 90                	xchg   %ax,%ax
f0121c26:	66 90                	xchg   %ax,%ax
f0121c28:	66 90                	xchg   %ax,%ax
f0121c2a:	66 90                	xchg   %ax,%ax
f0121c2c:	66 90                	xchg   %ax,%ax
f0121c2e:	66 90                	xchg   %ax,%ax
f0121c30:	66 90                	xchg   %ax,%ax
f0121c32:	66 90                	xchg   %ax,%ax
f0121c34:	66 90                	xchg   %ax,%ax
f0121c36:	66 90                	xchg   %ax,%ax
f0121c38:	66 90                	xchg   %ax,%ax
f0121c3a:	66 90                	xchg   %ax,%ax
f0121c3c:	66 90                	xchg   %ax,%ax
f0121c3e:	66 90                	xchg   %ax,%ax
f0121c40:	66 90                	xchg   %ax,%ax
f0121c42:	66 90                	xchg   %ax,%ax
f0121c44:	66 90                	xchg   %ax,%ax
f0121c46:	66 90                	xchg   %ax,%ax
f0121c48:	66 90                	xchg   %ax,%ax
f0121c4a:	66 90                	xchg   %ax,%ax
f0121c4c:	66 90                	xchg   %ax,%ax
f0121c4e:	66 90                	xchg   %ax,%ax
f0121c50:	66 90                	xchg   %ax,%ax
f0121c52:	66 90                	xchg   %ax,%ax
f0121c54:	66 90                	xchg   %ax,%ax
f0121c56:	66 90                	xchg   %ax,%ax
f0121c58:	66 90                	xchg   %ax,%ax
f0121c5a:	66 90                	xchg   %ax,%ax
f0121c5c:	66 90                	xchg   %ax,%ax
f0121c5e:	66 90                	xchg   %ax,%ax
f0121c60:	66 90                	xchg   %ax,%ax
f0121c62:	66 90                	xchg   %ax,%ax
f0121c64:	66 90                	xchg   %ax,%ax
f0121c66:	66 90                	xchg   %ax,%ax
f0121c68:	66 90                	xchg   %ax,%ax
f0121c6a:	66 90                	xchg   %ax,%ax
f0121c6c:	66 90                	xchg   %ax,%ax
f0121c6e:	66 90                	xchg   %ax,%ax
f0121c70:	66 90                	xchg   %ax,%ax
f0121c72:	66 90                	xchg   %ax,%ax
f0121c74:	66 90                	xchg   %ax,%ax
f0121c76:	66 90                	xchg   %ax,%ax
f0121c78:	66 90                	xchg   %ax,%ax
f0121c7a:	66 90                	xchg   %ax,%ax
f0121c7c:	66 90                	xchg   %ax,%ax
f0121c7e:	66 90                	xchg   %ax,%ax
f0121c80:	66 90                	xchg   %ax,%ax
f0121c82:	66 90                	xchg   %ax,%ax
f0121c84:	66 90                	xchg   %ax,%ax
f0121c86:	66 90                	xchg   %ax,%ax
f0121c88:	66 90                	xchg   %ax,%ax
f0121c8a:	66 90                	xchg   %ax,%ax
f0121c8c:	66 90                	xchg   %ax,%ax
f0121c8e:	66 90                	xchg   %ax,%ax
f0121c90:	66 90                	xchg   %ax,%ax
f0121c92:	66 90                	xchg   %ax,%ax
f0121c94:	66 90                	xchg   %ax,%ax
f0121c96:	66 90                	xchg   %ax,%ax
f0121c98:	66 90                	xchg   %ax,%ax
f0121c9a:	66 90                	xchg   %ax,%ax
f0121c9c:	66 90                	xchg   %ax,%ax
f0121c9e:	66 90                	xchg   %ax,%ax
f0121ca0:	66 90                	xchg   %ax,%ax
f0121ca2:	66 90                	xchg   %ax,%ax
f0121ca4:	66 90                	xchg   %ax,%ax
f0121ca6:	66 90                	xchg   %ax,%ax
f0121ca8:	66 90                	xchg   %ax,%ax
f0121caa:	66 90                	xchg   %ax,%ax
f0121cac:	66 90                	xchg   %ax,%ax
f0121cae:	66 90                	xchg   %ax,%ax
f0121cb0:	66 90                	xchg   %ax,%ax
f0121cb2:	66 90                	xchg   %ax,%ax
f0121cb4:	66 90                	xchg   %ax,%ax
f0121cb6:	66 90                	xchg   %ax,%ax
f0121cb8:	66 90                	xchg   %ax,%ax
f0121cba:	66 90                	xchg   %ax,%ax
f0121cbc:	66 90                	xchg   %ax,%ax
f0121cbe:	66 90                	xchg   %ax,%ax
f0121cc0:	66 90                	xchg   %ax,%ax
f0121cc2:	66 90                	xchg   %ax,%ax
f0121cc4:	66 90                	xchg   %ax,%ax
f0121cc6:	66 90                	xchg   %ax,%ax
f0121cc8:	66 90                	xchg   %ax,%ax
f0121cca:	66 90                	xchg   %ax,%ax
f0121ccc:	66 90                	xchg   %ax,%ax
f0121cce:	66 90                	xchg   %ax,%ax
f0121cd0:	66 90                	xchg   %ax,%ax
f0121cd2:	66 90                	xchg   %ax,%ax
f0121cd4:	66 90                	xchg   %ax,%ax
f0121cd6:	66 90                	xchg   %ax,%ax
f0121cd8:	66 90                	xchg   %ax,%ax
f0121cda:	66 90                	xchg   %ax,%ax
f0121cdc:	66 90                	xchg   %ax,%ax
f0121cde:	66 90                	xchg   %ax,%ax
f0121ce0:	66 90                	xchg   %ax,%ax
f0121ce2:	66 90                	xchg   %ax,%ax
f0121ce4:	66 90                	xchg   %ax,%ax
f0121ce6:	66 90                	xchg   %ax,%ax
f0121ce8:	66 90                	xchg   %ax,%ax
f0121cea:	66 90                	xchg   %ax,%ax
f0121cec:	66 90                	xchg   %ax,%ax
f0121cee:	66 90                	xchg   %ax,%ax
f0121cf0:	66 90                	xchg   %ax,%ax
f0121cf2:	66 90                	xchg   %ax,%ax
f0121cf4:	66 90                	xchg   %ax,%ax
f0121cf6:	66 90                	xchg   %ax,%ax
f0121cf8:	66 90                	xchg   %ax,%ax
f0121cfa:	66 90                	xchg   %ax,%ax
f0121cfc:	66 90                	xchg   %ax,%ax
f0121cfe:	66 90                	xchg   %ax,%ax
f0121d00:	66 90                	xchg   %ax,%ax
f0121d02:	66 90                	xchg   %ax,%ax
f0121d04:	66 90                	xchg   %ax,%ax
f0121d06:	66 90                	xchg   %ax,%ax
f0121d08:	66 90                	xchg   %ax,%ax
f0121d0a:	66 90                	xchg   %ax,%ax
f0121d0c:	66 90                	xchg   %ax,%ax
f0121d0e:	66 90                	xchg   %ax,%ax
f0121d10:	66 90                	xchg   %ax,%ax
f0121d12:	66 90                	xchg   %ax,%ax
f0121d14:	66 90                	xchg   %ax,%ax
f0121d16:	66 90                	xchg   %ax,%ax
f0121d18:	66 90                	xchg   %ax,%ax
f0121d1a:	66 90                	xchg   %ax,%ax
f0121d1c:	66 90                	xchg   %ax,%ax
f0121d1e:	66 90                	xchg   %ax,%ax
f0121d20:	66 90                	xchg   %ax,%ax
f0121d22:	66 90                	xchg   %ax,%ax
f0121d24:	66 90                	xchg   %ax,%ax
f0121d26:	66 90                	xchg   %ax,%ax
f0121d28:	66 90                	xchg   %ax,%ax
f0121d2a:	66 90                	xchg   %ax,%ax
f0121d2c:	66 90                	xchg   %ax,%ax
f0121d2e:	66 90                	xchg   %ax,%ax
f0121d30:	66 90                	xchg   %ax,%ax
f0121d32:	66 90                	xchg   %ax,%ax
f0121d34:	66 90                	xchg   %ax,%ax
f0121d36:	66 90                	xchg   %ax,%ax
f0121d38:	66 90                	xchg   %ax,%ax
f0121d3a:	66 90                	xchg   %ax,%ax
f0121d3c:	66 90                	xchg   %ax,%ax
f0121d3e:	66 90                	xchg   %ax,%ax
f0121d40:	66 90                	xchg   %ax,%ax
f0121d42:	66 90                	xchg   %ax,%ax
f0121d44:	66 90                	xchg   %ax,%ax
f0121d46:	66 90                	xchg   %ax,%ax
f0121d48:	66 90                	xchg   %ax,%ax
f0121d4a:	66 90                	xchg   %ax,%ax
f0121d4c:	66 90                	xchg   %ax,%ax
f0121d4e:	66 90                	xchg   %ax,%ax
f0121d50:	66 90                	xchg   %ax,%ax
f0121d52:	66 90                	xchg   %ax,%ax
f0121d54:	66 90                	xchg   %ax,%ax
f0121d56:	66 90                	xchg   %ax,%ax
f0121d58:	66 90                	xchg   %ax,%ax
f0121d5a:	66 90                	xchg   %ax,%ax
f0121d5c:	66 90                	xchg   %ax,%ax
f0121d5e:	66 90                	xchg   %ax,%ax
f0121d60:	66 90                	xchg   %ax,%ax
f0121d62:	66 90                	xchg   %ax,%ax
f0121d64:	66 90                	xchg   %ax,%ax
f0121d66:	66 90                	xchg   %ax,%ax
f0121d68:	66 90                	xchg   %ax,%ax
f0121d6a:	66 90                	xchg   %ax,%ax
f0121d6c:	66 90                	xchg   %ax,%ax
f0121d6e:	66 90                	xchg   %ax,%ax
f0121d70:	66 90                	xchg   %ax,%ax
f0121d72:	66 90                	xchg   %ax,%ax
f0121d74:	66 90                	xchg   %ax,%ax
f0121d76:	66 90                	xchg   %ax,%ax
f0121d78:	66 90                	xchg   %ax,%ax
f0121d7a:	66 90                	xchg   %ax,%ax
f0121d7c:	66 90                	xchg   %ax,%ax
f0121d7e:	66 90                	xchg   %ax,%ax
f0121d80:	66 90                	xchg   %ax,%ax
f0121d82:	66 90                	xchg   %ax,%ax
f0121d84:	66 90                	xchg   %ax,%ax
f0121d86:	66 90                	xchg   %ax,%ax
f0121d88:	66 90                	xchg   %ax,%ax
f0121d8a:	66 90                	xchg   %ax,%ax
f0121d8c:	66 90                	xchg   %ax,%ax
f0121d8e:	66 90                	xchg   %ax,%ax
f0121d90:	66 90                	xchg   %ax,%ax
f0121d92:	66 90                	xchg   %ax,%ax
f0121d94:	66 90                	xchg   %ax,%ax
f0121d96:	66 90                	xchg   %ax,%ax
f0121d98:	66 90                	xchg   %ax,%ax
f0121d9a:	66 90                	xchg   %ax,%ax
f0121d9c:	66 90                	xchg   %ax,%ax
f0121d9e:	66 90                	xchg   %ax,%ax
f0121da0:	66 90                	xchg   %ax,%ax
f0121da2:	66 90                	xchg   %ax,%ax
f0121da4:	66 90                	xchg   %ax,%ax
f0121da6:	66 90                	xchg   %ax,%ax
f0121da8:	66 90                	xchg   %ax,%ax
f0121daa:	66 90                	xchg   %ax,%ax
f0121dac:	66 90                	xchg   %ax,%ax
f0121dae:	66 90                	xchg   %ax,%ax
f0121db0:	66 90                	xchg   %ax,%ax
f0121db2:	66 90                	xchg   %ax,%ax
f0121db4:	66 90                	xchg   %ax,%ax
f0121db6:	66 90                	xchg   %ax,%ax
f0121db8:	66 90                	xchg   %ax,%ax
f0121dba:	66 90                	xchg   %ax,%ax
f0121dbc:	66 90                	xchg   %ax,%ax
f0121dbe:	66 90                	xchg   %ax,%ax
f0121dc0:	66 90                	xchg   %ax,%ax
f0121dc2:	66 90                	xchg   %ax,%ax
f0121dc4:	66 90                	xchg   %ax,%ax
f0121dc6:	66 90                	xchg   %ax,%ax
f0121dc8:	66 90                	xchg   %ax,%ax
f0121dca:	66 90                	xchg   %ax,%ax
f0121dcc:	66 90                	xchg   %ax,%ax
f0121dce:	66 90                	xchg   %ax,%ax
f0121dd0:	66 90                	xchg   %ax,%ax
f0121dd2:	66 90                	xchg   %ax,%ax
f0121dd4:	66 90                	xchg   %ax,%ax
f0121dd6:	66 90                	xchg   %ax,%ax
f0121dd8:	66 90                	xchg   %ax,%ax
f0121dda:	66 90                	xchg   %ax,%ax
f0121ddc:	66 90                	xchg   %ax,%ax
f0121dde:	66 90                	xchg   %ax,%ax
f0121de0:	66 90                	xchg   %ax,%ax
f0121de2:	66 90                	xchg   %ax,%ax
f0121de4:	66 90                	xchg   %ax,%ax
f0121de6:	66 90                	xchg   %ax,%ax
f0121de8:	66 90                	xchg   %ax,%ax
f0121dea:	66 90                	xchg   %ax,%ax
f0121dec:	66 90                	xchg   %ax,%ax
f0121dee:	66 90                	xchg   %ax,%ax
f0121df0:	66 90                	xchg   %ax,%ax
f0121df2:	66 90                	xchg   %ax,%ax
f0121df4:	66 90                	xchg   %ax,%ax
f0121df6:	66 90                	xchg   %ax,%ax
f0121df8:	66 90                	xchg   %ax,%ax
f0121dfa:	66 90                	xchg   %ax,%ax
f0121dfc:	66 90                	xchg   %ax,%ax
f0121dfe:	66 90                	xchg   %ax,%ax
f0121e00:	66 90                	xchg   %ax,%ax
f0121e02:	66 90                	xchg   %ax,%ax
f0121e04:	66 90                	xchg   %ax,%ax
f0121e06:	66 90                	xchg   %ax,%ax
f0121e08:	66 90                	xchg   %ax,%ax
f0121e0a:	66 90                	xchg   %ax,%ax
f0121e0c:	66 90                	xchg   %ax,%ax
f0121e0e:	66 90                	xchg   %ax,%ax
f0121e10:	66 90                	xchg   %ax,%ax
f0121e12:	66 90                	xchg   %ax,%ax
f0121e14:	66 90                	xchg   %ax,%ax
f0121e16:	66 90                	xchg   %ax,%ax
f0121e18:	66 90                	xchg   %ax,%ax
f0121e1a:	66 90                	xchg   %ax,%ax
f0121e1c:	66 90                	xchg   %ax,%ax
f0121e1e:	66 90                	xchg   %ax,%ax
f0121e20:	66 90                	xchg   %ax,%ax
f0121e22:	66 90                	xchg   %ax,%ax
f0121e24:	66 90                	xchg   %ax,%ax
f0121e26:	66 90                	xchg   %ax,%ax
f0121e28:	66 90                	xchg   %ax,%ax
f0121e2a:	66 90                	xchg   %ax,%ax
f0121e2c:	66 90                	xchg   %ax,%ax
f0121e2e:	66 90                	xchg   %ax,%ax
f0121e30:	66 90                	xchg   %ax,%ax
f0121e32:	66 90                	xchg   %ax,%ax
f0121e34:	66 90                	xchg   %ax,%ax
f0121e36:	66 90                	xchg   %ax,%ax
f0121e38:	66 90                	xchg   %ax,%ax
f0121e3a:	66 90                	xchg   %ax,%ax
f0121e3c:	66 90                	xchg   %ax,%ax
f0121e3e:	66 90                	xchg   %ax,%ax
f0121e40:	66 90                	xchg   %ax,%ax
f0121e42:	66 90                	xchg   %ax,%ax
f0121e44:	66 90                	xchg   %ax,%ax
f0121e46:	66 90                	xchg   %ax,%ax
f0121e48:	66 90                	xchg   %ax,%ax
f0121e4a:	66 90                	xchg   %ax,%ax
f0121e4c:	66 90                	xchg   %ax,%ax
f0121e4e:	66 90                	xchg   %ax,%ax
f0121e50:	66 90                	xchg   %ax,%ax
f0121e52:	66 90                	xchg   %ax,%ax
f0121e54:	66 90                	xchg   %ax,%ax
f0121e56:	66 90                	xchg   %ax,%ax
f0121e58:	66 90                	xchg   %ax,%ax
f0121e5a:	66 90                	xchg   %ax,%ax
f0121e5c:	66 90                	xchg   %ax,%ax
f0121e5e:	66 90                	xchg   %ax,%ax
f0121e60:	66 90                	xchg   %ax,%ax
f0121e62:	66 90                	xchg   %ax,%ax
f0121e64:	66 90                	xchg   %ax,%ax
f0121e66:	66 90                	xchg   %ax,%ax
f0121e68:	66 90                	xchg   %ax,%ax
f0121e6a:	66 90                	xchg   %ax,%ax
f0121e6c:	66 90                	xchg   %ax,%ax
f0121e6e:	66 90                	xchg   %ax,%ax
f0121e70:	66 90                	xchg   %ax,%ax
f0121e72:	66 90                	xchg   %ax,%ax
f0121e74:	66 90                	xchg   %ax,%ax
f0121e76:	66 90                	xchg   %ax,%ax
f0121e78:	66 90                	xchg   %ax,%ax
f0121e7a:	66 90                	xchg   %ax,%ax
f0121e7c:	66 90                	xchg   %ax,%ax
f0121e7e:	66 90                	xchg   %ax,%ax
f0121e80:	66 90                	xchg   %ax,%ax
f0121e82:	66 90                	xchg   %ax,%ax
f0121e84:	66 90                	xchg   %ax,%ax
f0121e86:	66 90                	xchg   %ax,%ax
f0121e88:	66 90                	xchg   %ax,%ax
f0121e8a:	66 90                	xchg   %ax,%ax
f0121e8c:	66 90                	xchg   %ax,%ax
f0121e8e:	66 90                	xchg   %ax,%ax
f0121e90:	66 90                	xchg   %ax,%ax
f0121e92:	66 90                	xchg   %ax,%ax
f0121e94:	66 90                	xchg   %ax,%ax
f0121e96:	66 90                	xchg   %ax,%ax
f0121e98:	66 90                	xchg   %ax,%ax
f0121e9a:	66 90                	xchg   %ax,%ax
f0121e9c:	66 90                	xchg   %ax,%ax
f0121e9e:	66 90                	xchg   %ax,%ax
f0121ea0:	66 90                	xchg   %ax,%ax
f0121ea2:	66 90                	xchg   %ax,%ax
f0121ea4:	66 90                	xchg   %ax,%ax
f0121ea6:	66 90                	xchg   %ax,%ax
f0121ea8:	66 90                	xchg   %ax,%ax
f0121eaa:	66 90                	xchg   %ax,%ax
f0121eac:	66 90                	xchg   %ax,%ax
f0121eae:	66 90                	xchg   %ax,%ax
f0121eb0:	66 90                	xchg   %ax,%ax
f0121eb2:	66 90                	xchg   %ax,%ax
f0121eb4:	66 90                	xchg   %ax,%ax
f0121eb6:	66 90                	xchg   %ax,%ax
f0121eb8:	66 90                	xchg   %ax,%ax
f0121eba:	66 90                	xchg   %ax,%ax
f0121ebc:	66 90                	xchg   %ax,%ax
f0121ebe:	66 90                	xchg   %ax,%ax
f0121ec0:	66 90                	xchg   %ax,%ax
f0121ec2:	66 90                	xchg   %ax,%ax
f0121ec4:	66 90                	xchg   %ax,%ax
f0121ec6:	66 90                	xchg   %ax,%ax
f0121ec8:	66 90                	xchg   %ax,%ax
f0121eca:	66 90                	xchg   %ax,%ax
f0121ecc:	66 90                	xchg   %ax,%ax
f0121ece:	66 90                	xchg   %ax,%ax
f0121ed0:	66 90                	xchg   %ax,%ax
f0121ed2:	66 90                	xchg   %ax,%ax
f0121ed4:	66 90                	xchg   %ax,%ax
f0121ed6:	66 90                	xchg   %ax,%ax
f0121ed8:	66 90                	xchg   %ax,%ax
f0121eda:	66 90                	xchg   %ax,%ax
f0121edc:	66 90                	xchg   %ax,%ax
f0121ede:	66 90                	xchg   %ax,%ax
f0121ee0:	66 90                	xchg   %ax,%ax
f0121ee2:	66 90                	xchg   %ax,%ax
f0121ee4:	66 90                	xchg   %ax,%ax
f0121ee6:	66 90                	xchg   %ax,%ax
f0121ee8:	66 90                	xchg   %ax,%ax
f0121eea:	66 90                	xchg   %ax,%ax
f0121eec:	66 90                	xchg   %ax,%ax
f0121eee:	66 90                	xchg   %ax,%ax
f0121ef0:	66 90                	xchg   %ax,%ax
f0121ef2:	66 90                	xchg   %ax,%ax
f0121ef4:	66 90                	xchg   %ax,%ax
f0121ef6:	66 90                	xchg   %ax,%ax
f0121ef8:	66 90                	xchg   %ax,%ax
f0121efa:	66 90                	xchg   %ax,%ax
f0121efc:	66 90                	xchg   %ax,%ax
f0121efe:	66 90                	xchg   %ax,%ax
f0121f00:	66 90                	xchg   %ax,%ax
f0121f02:	66 90                	xchg   %ax,%ax
f0121f04:	66 90                	xchg   %ax,%ax
f0121f06:	66 90                	xchg   %ax,%ax
f0121f08:	66 90                	xchg   %ax,%ax
f0121f0a:	66 90                	xchg   %ax,%ax
f0121f0c:	66 90                	xchg   %ax,%ax
f0121f0e:	66 90                	xchg   %ax,%ax
f0121f10:	66 90                	xchg   %ax,%ax
f0121f12:	66 90                	xchg   %ax,%ax
f0121f14:	66 90                	xchg   %ax,%ax
f0121f16:	66 90                	xchg   %ax,%ax
f0121f18:	66 90                	xchg   %ax,%ax
f0121f1a:	66 90                	xchg   %ax,%ax
f0121f1c:	66 90                	xchg   %ax,%ax
f0121f1e:	66 90                	xchg   %ax,%ax
f0121f20:	66 90                	xchg   %ax,%ax
f0121f22:	66 90                	xchg   %ax,%ax
f0121f24:	66 90                	xchg   %ax,%ax
f0121f26:	66 90                	xchg   %ax,%ax
f0121f28:	66 90                	xchg   %ax,%ax
f0121f2a:	66 90                	xchg   %ax,%ax
f0121f2c:	66 90                	xchg   %ax,%ax
f0121f2e:	66 90                	xchg   %ax,%ax
f0121f30:	66 90                	xchg   %ax,%ax
f0121f32:	66 90                	xchg   %ax,%ax
f0121f34:	66 90                	xchg   %ax,%ax
f0121f36:	66 90                	xchg   %ax,%ax
f0121f38:	66 90                	xchg   %ax,%ax
f0121f3a:	66 90                	xchg   %ax,%ax
f0121f3c:	66 90                	xchg   %ax,%ax
f0121f3e:	66 90                	xchg   %ax,%ax
f0121f40:	66 90                	xchg   %ax,%ax
f0121f42:	66 90                	xchg   %ax,%ax
f0121f44:	66 90                	xchg   %ax,%ax
f0121f46:	66 90                	xchg   %ax,%ax
f0121f48:	66 90                	xchg   %ax,%ax
f0121f4a:	66 90                	xchg   %ax,%ax
f0121f4c:	66 90                	xchg   %ax,%ax
f0121f4e:	66 90                	xchg   %ax,%ax
f0121f50:	66 90                	xchg   %ax,%ax
f0121f52:	66 90                	xchg   %ax,%ax
f0121f54:	66 90                	xchg   %ax,%ax
f0121f56:	66 90                	xchg   %ax,%ax
f0121f58:	66 90                	xchg   %ax,%ax
f0121f5a:	66 90                	xchg   %ax,%ax
f0121f5c:	66 90                	xchg   %ax,%ax
f0121f5e:	66 90                	xchg   %ax,%ax
f0121f60:	66 90                	xchg   %ax,%ax
f0121f62:	66 90                	xchg   %ax,%ax
f0121f64:	66 90                	xchg   %ax,%ax
f0121f66:	66 90                	xchg   %ax,%ax
f0121f68:	66 90                	xchg   %ax,%ax
f0121f6a:	66 90                	xchg   %ax,%ax
f0121f6c:	66 90                	xchg   %ax,%ax
f0121f6e:	66 90                	xchg   %ax,%ax
f0121f70:	66 90                	xchg   %ax,%ax
f0121f72:	66 90                	xchg   %ax,%ax
f0121f74:	66 90                	xchg   %ax,%ax
f0121f76:	66 90                	xchg   %ax,%ax
f0121f78:	66 90                	xchg   %ax,%ax
f0121f7a:	66 90                	xchg   %ax,%ax
f0121f7c:	66 90                	xchg   %ax,%ax
f0121f7e:	66 90                	xchg   %ax,%ax
f0121f80:	66 90                	xchg   %ax,%ax
f0121f82:	66 90                	xchg   %ax,%ax
f0121f84:	66 90                	xchg   %ax,%ax
f0121f86:	66 90                	xchg   %ax,%ax
f0121f88:	66 90                	xchg   %ax,%ax
f0121f8a:	66 90                	xchg   %ax,%ax
f0121f8c:	66 90                	xchg   %ax,%ax
f0121f8e:	66 90                	xchg   %ax,%ax
f0121f90:	66 90                	xchg   %ax,%ax
f0121f92:	66 90                	xchg   %ax,%ax
f0121f94:	66 90                	xchg   %ax,%ax
f0121f96:	66 90                	xchg   %ax,%ax
f0121f98:	66 90                	xchg   %ax,%ax
f0121f9a:	66 90                	xchg   %ax,%ax
f0121f9c:	66 90                	xchg   %ax,%ax
f0121f9e:	66 90                	xchg   %ax,%ax
f0121fa0:	66 90                	xchg   %ax,%ax
f0121fa2:	66 90                	xchg   %ax,%ax
f0121fa4:	66 90                	xchg   %ax,%ax
f0121fa6:	66 90                	xchg   %ax,%ax
f0121fa8:	66 90                	xchg   %ax,%ax
f0121faa:	66 90                	xchg   %ax,%ax
f0121fac:	66 90                	xchg   %ax,%ax
f0121fae:	66 90                	xchg   %ax,%ax
f0121fb0:	66 90                	xchg   %ax,%ax
f0121fb2:	66 90                	xchg   %ax,%ax
f0121fb4:	66 90                	xchg   %ax,%ax
f0121fb6:	66 90                	xchg   %ax,%ax
f0121fb8:	66 90                	xchg   %ax,%ax
f0121fba:	66 90                	xchg   %ax,%ax
f0121fbc:	66 90                	xchg   %ax,%ax
f0121fbe:	66 90                	xchg   %ax,%ax
f0121fc0:	66 90                	xchg   %ax,%ax
f0121fc2:	66 90                	xchg   %ax,%ax
f0121fc4:	66 90                	xchg   %ax,%ax
f0121fc6:	66 90                	xchg   %ax,%ax
f0121fc8:	66 90                	xchg   %ax,%ax
f0121fca:	66 90                	xchg   %ax,%ax
f0121fcc:	66 90                	xchg   %ax,%ax
f0121fce:	66 90                	xchg   %ax,%ax
f0121fd0:	66 90                	xchg   %ax,%ax
f0121fd2:	66 90                	xchg   %ax,%ax
f0121fd4:	66 90                	xchg   %ax,%ax
f0121fd6:	66 90                	xchg   %ax,%ax
f0121fd8:	66 90                	xchg   %ax,%ax
f0121fda:	66 90                	xchg   %ax,%ax
f0121fdc:	66 90                	xchg   %ax,%ax
f0121fde:	66 90                	xchg   %ax,%ax
f0121fe0:	66 90                	xchg   %ax,%ax
f0121fe2:	66 90                	xchg   %ax,%ax
f0121fe4:	66 90                	xchg   %ax,%ax
f0121fe6:	66 90                	xchg   %ax,%ax
f0121fe8:	66 90                	xchg   %ax,%ax
f0121fea:	66 90                	xchg   %ax,%ax
f0121fec:	66 90                	xchg   %ax,%ax
f0121fee:	66 90                	xchg   %ax,%ax
f0121ff0:	66 90                	xchg   %ax,%ax
f0121ff2:	66 90                	xchg   %ax,%ax
f0121ff4:	66 90                	xchg   %ax,%ax
f0121ff6:	66 90                	xchg   %ax,%ax
f0121ff8:	66 90                	xchg   %ax,%ax
f0121ffa:	66 90                	xchg   %ax,%ax
f0121ffc:	66 90                	xchg   %ax,%ax
f0121ffe:	66 90                	xchg   %ax,%ax

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
