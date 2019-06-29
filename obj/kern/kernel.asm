
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
f0100051:	83 3d 40 cd 5d f0 00 	cmpl   $0x0,0xf05dcd40
f0100058:	74 0f                	je     f0100069 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010005a:	83 ec 0c             	sub    $0xc,%esp
f010005d:	6a 00                	push   $0x0
f010005f:	e8 18 0c 00 00       	call   f0100c7c <monitor>
f0100064:	83 c4 10             	add    $0x10,%esp
f0100067:	eb f1                	jmp    f010005a <_panic+0x11>
	panicstr = fmt;
f0100069:	89 35 40 cd 5d f0    	mov    %esi,0xf05dcd40
	asm volatile("cli; cld");
f010006f:	fa                   	cli    
f0100070:	fc                   	cld    
	va_start(ap, fmt);
f0100071:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100074:	e8 9d 72 00 00       	call   f0107316 <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 e0 83 10 f0       	push   $0xf01083e0
f0100085:	e8 77 45 00 00       	call   f0104601 <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 47 45 00 00       	call   f01045db <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 fb 98 10 f0 	movl   $0xf01098fb,(%esp)
f010009b:	e8 61 45 00 00       	call   f0104601 <cprintf>
f01000a0:	83 c4 10             	add    $0x10,%esp
f01000a3:	eb b5                	jmp    f010005a <_panic+0x11>

f01000a5 <i386_init>:
{
f01000a5:	55                   	push   %ebp
f01000a6:	89 e5                	mov    %esp,%ebp
f01000a8:	56                   	push   %esi
f01000a9:	53                   	push   %ebx
	cons_init();
f01000aa:	e8 e9 05 00 00       	call   f0100698 <cons_init>
	cprintf("pading space in the right to number 22: %-8d.\n", 22);
f01000af:	83 ec 08             	sub    $0x8,%esp
f01000b2:	6a 16                	push   $0x16
f01000b4:	68 04 84 10 f0       	push   $0xf0108404
f01000b9:	e8 43 45 00 00       	call   f0104601 <cprintf>
	cprintf("%n", NULL);
f01000be:	83 c4 08             	add    $0x8,%esp
f01000c1:	6a 00                	push   $0x0
f01000c3:	68 7c 84 10 f0       	push   $0xf010847c
f01000c8:	e8 34 45 00 00       	call   f0104601 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000cd:	83 c4 0c             	add    $0xc,%esp
f01000d0:	68 00 fc ff ff       	push   $0xfffffc00
f01000d5:	68 00 04 00 00       	push   $0x400
f01000da:	68 7f 84 10 f0       	push   $0xf010847f
f01000df:	e8 1d 45 00 00       	call   f0104601 <cprintf>
	mem_init();
f01000e4:	e8 84 16 00 00       	call   f010176d <mem_init>
	env_init();
f01000e9:	e8 fa 35 00 00       	call   f01036e8 <env_init>
	trap_init();
f01000ee:	e8 04 46 00 00       	call   f01046f7 <trap_init>

static inline uint32_t
read_esp(void)
{
	uint32_t esp;
	asm volatile("movl %%esp,%0" : "=r" (esp));
f01000f3:	89 e3                	mov    %esp,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01000f5:	89 ee                	mov    %ebp,%esi
	memmove((void*)(KSTACKTOP-KSTKSIZE), bootstack, KSTKSIZE);
f01000f7:	83 c4 0c             	add    $0xc,%esp
f01000fa:	68 00 80 00 00       	push   $0x8000
f01000ff:	68 00 20 12 f0       	push   $0xf0122000
f0100104:	68 00 80 ff ef       	push   $0xefff8000
f0100109:	e8 49 6c 00 00       	call   f0106d57 <memmove>
	uint32_t off = KSTACKTOP - KSTKSIZE - (uint32_t)bootstack;
f010010e:	b8 00 80 ff ef       	mov    $0xefff8000,%eax
f0100113:	2d 00 20 12 f0       	sub    $0xf0122000,%eax
	esp += off;
f0100118:	01 c3                	add    %eax,%ebx
	asm volatile("movl %0, %%esp"::"r"(esp):);
f010011a:	89 dc                	mov    %ebx,%esp
	ebp += off;
f010011c:	01 f0                	add    %esi,%eax
	asm volatile("movl %0, %%ebp"::"r"(ebp):);
f010011e:	89 c5                	mov    %eax,%ebp
	mp_init();
f0100120:	e8 fa 6e 00 00       	call   f010701f <mp_init>
	cprintf("after mp_init()\n");
f0100125:	c7 04 24 9b 84 10 f0 	movl   $0xf010849b,(%esp)
f010012c:	e8 d0 44 00 00       	call   f0104601 <cprintf>
	lapic_init();
f0100131:	e8 f6 71 00 00       	call   f010732c <lapic_init>
	pic_init();
f0100136:	e8 cb 43 00 00       	call   f0104506 <pic_init>
	time_init();
f010013b:	e8 01 80 00 00       	call   f0108141 <time_init>
	pci_init();
f0100140:	e8 dc 7f 00 00       	call   f0108121 <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100145:	c7 04 24 20 d3 16 f0 	movl   $0xf016d320,(%esp)
f010014c:	e8 35 74 00 00       	call   f0107586 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100151:	83 c4 10             	add    $0x10,%esp
f0100154:	83 3d 48 cd 5d f0 07 	cmpl   $0x7,0xf05dcd48
f010015b:	76 27                	jbe    f0100184 <i386_init+0xdf>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f010015d:	83 ec 04             	sub    $0x4,%esp
f0100160:	b8 82 6f 10 f0       	mov    $0xf0106f82,%eax
f0100165:	2d 00 6f 10 f0       	sub    $0xf0106f00,%eax
f010016a:	50                   	push   %eax
f010016b:	68 00 6f 10 f0       	push   $0xf0106f00
f0100170:	68 00 70 00 f0       	push   $0xf0007000
f0100175:	e8 dd 6b 00 00       	call   f0106d57 <memmove>
f010017a:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f010017d:	bb 20 b0 16 f0       	mov    $0xf016b020,%ebx
f0100182:	eb 19                	jmp    f010019d <i386_init+0xf8>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100184:	68 00 70 00 00       	push   $0x7000
f0100189:	68 34 84 10 f0       	push   $0xf0108434
f010018e:	6a 7c                	push   $0x7c
f0100190:	68 ac 84 10 f0       	push   $0xf01084ac
f0100195:	e8 af fe ff ff       	call   f0100049 <_panic>
f010019a:	83 c3 74             	add    $0x74,%ebx
f010019d:	6b 05 58 cd 5d f0 74 	imul   $0x74,0xf05dcd58,%eax
f01001a4:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01001a9:	39 c3                	cmp    %eax,%ebx
f01001ab:	73 4d                	jae    f01001fa <i386_init+0x155>
		if (c == cpus + cpunum())  // We've started already.
f01001ad:	e8 64 71 00 00       	call   f0107316 <cpunum>
f01001b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01001b5:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01001ba:	39 c3                	cmp    %eax,%ebx
f01001bc:	74 dc                	je     f010019a <i386_init+0xf5>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f01001be:	89 d8                	mov    %ebx,%eax
f01001c0:	2d 20 b0 16 f0       	sub    $0xf016b020,%eax
f01001c5:	c1 f8 02             	sar    $0x2,%eax
f01001c8:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f01001ce:	c1 e0 0f             	shl    $0xf,%eax
f01001d1:	8d 80 00 30 13 f0    	lea    -0xfecd000(%eax),%eax
f01001d7:	a3 44 cd 5d f0       	mov    %eax,0xf05dcd44
		lapic_startap(c->cpu_id, PADDR(code));
f01001dc:	83 ec 08             	sub    $0x8,%esp
f01001df:	68 00 70 00 00       	push   $0x7000
f01001e4:	0f b6 03             	movzbl (%ebx),%eax
f01001e7:	50                   	push   %eax
f01001e8:	e8 91 72 00 00       	call   f010747e <lapic_startap>
f01001ed:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f01001f0:	8b 43 04             	mov    0x4(%ebx),%eax
f01001f3:	83 f8 01             	cmp    $0x1,%eax
f01001f6:	75 f8                	jne    f01001f0 <i386_init+0x14b>
f01001f8:	eb a0                	jmp    f010019a <i386_init+0xf5>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001fa:	83 ec 08             	sub    $0x8,%esp
f01001fd:	6a 00                	push   $0x0
f01001ff:	68 00 63 5c f0       	push   $0xf05c6300
f0100204:	e8 5b 39 00 00       	call   f0103b64 <env_create>
	kbd_intr();
f0100209:	e8 35 04 00 00       	call   f0100643 <kbd_intr>
	sched_yield();
f010020e:	e8 a6 52 00 00       	call   f01054b9 <sched_yield>

f0100213 <mp_main>:
{
f0100213:	55                   	push   %ebp
f0100214:	89 e5                	mov    %esp,%ebp
f0100216:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f0100219:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
	if ((uint32_t)kva < KERNBASE)
f010021e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100223:	76 52                	jbe    f0100277 <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f0100225:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010022a:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f010022d:	e8 e4 70 00 00       	call   f0107316 <cpunum>
f0100232:	83 ec 08             	sub    $0x8,%esp
f0100235:	50                   	push   %eax
f0100236:	68 b8 84 10 f0       	push   $0xf01084b8
f010023b:	e8 c1 43 00 00       	call   f0104601 <cprintf>
	lapic_init();
f0100240:	e8 e7 70 00 00       	call   f010732c <lapic_init>
	env_init_percpu();
f0100245:	e8 72 34 00 00       	call   f01036bc <env_init_percpu>
	trap_init_percpu();
f010024a:	e8 c6 43 00 00       	call   f0104615 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f010024f:	e8 c2 70 00 00       	call   f0107316 <cpunum>
f0100254:	6b d0 74             	imul   $0x74,%eax,%edx
f0100257:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f010025a:	b8 01 00 00 00       	mov    $0x1,%eax
f010025f:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
f0100266:	c7 04 24 20 d3 16 f0 	movl   $0xf016d320,(%esp)
f010026d:	e8 14 73 00 00       	call   f0107586 <spin_lock>
	sched_yield();
f0100272:	e8 42 52 00 00       	call   f01054b9 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100277:	50                   	push   %eax
f0100278:	68 58 84 10 f0       	push   $0xf0108458
f010027d:	68 93 00 00 00       	push   $0x93
f0100282:	68 ac 84 10 f0       	push   $0xf01084ac
f0100287:	e8 bd fd ff ff       	call   f0100049 <_panic>

f010028c <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010028c:	55                   	push   %ebp
f010028d:	89 e5                	mov    %esp,%ebp
f010028f:	53                   	push   %ebx
f0100290:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100293:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100296:	ff 75 0c             	pushl  0xc(%ebp)
f0100299:	ff 75 08             	pushl  0x8(%ebp)
f010029c:	68 ce 84 10 f0       	push   $0xf01084ce
f01002a1:	e8 5b 43 00 00       	call   f0104601 <cprintf>
	vcprintf(fmt, ap);
f01002a6:	83 c4 08             	add    $0x8,%esp
f01002a9:	53                   	push   %ebx
f01002aa:	ff 75 10             	pushl  0x10(%ebp)
f01002ad:	e8 29 43 00 00       	call   f01045db <vcprintf>
	cprintf("\n");
f01002b2:	c7 04 24 fb 98 10 f0 	movl   $0xf01098fb,(%esp)
f01002b9:	e8 43 43 00 00       	call   f0104601 <cprintf>
	va_end(ap);
}
f01002be:	83 c4 10             	add    $0x10,%esp
f01002c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002c4:	c9                   	leave  
f01002c5:	c3                   	ret    

f01002c6 <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002c6:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002cb:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002cc:	a8 01                	test   $0x1,%al
f01002ce:	74 0a                	je     f01002da <serial_proc_data+0x14>
f01002d0:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002d5:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01002d6:	0f b6 c0             	movzbl %al,%eax
f01002d9:	c3                   	ret    
		return -1;
f01002da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01002df:	c3                   	ret    

f01002e0 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01002e0:	55                   	push   %ebp
f01002e1:	89 e5                	mov    %esp,%ebp
f01002e3:	53                   	push   %ebx
f01002e4:	83 ec 04             	sub    $0x4,%esp
f01002e7:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002e9:	ff d3                	call   *%ebx
f01002eb:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002ee:	74 29                	je     f0100319 <cons_intr+0x39>
		if (c == 0)
f01002f0:	85 c0                	test   %eax,%eax
f01002f2:	74 f5                	je     f01002e9 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002f4:	8b 0d e4 b8 5d f0    	mov    0xf05db8e4,%ecx
f01002fa:	8d 51 01             	lea    0x1(%ecx),%edx
f01002fd:	88 81 e0 b6 5d f0    	mov    %al,-0xfa24920(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100303:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f0100309:	b8 00 00 00 00       	mov    $0x0,%eax
f010030e:	0f 44 d0             	cmove  %eax,%edx
f0100311:	89 15 e4 b8 5d f0    	mov    %edx,0xf05db8e4
f0100317:	eb d0                	jmp    f01002e9 <cons_intr+0x9>
	}
}
f0100319:	83 c4 04             	add    $0x4,%esp
f010031c:	5b                   	pop    %ebx
f010031d:	5d                   	pop    %ebp
f010031e:	c3                   	ret    

f010031f <kbd_proc_data>:
{
f010031f:	55                   	push   %ebp
f0100320:	89 e5                	mov    %esp,%ebp
f0100322:	53                   	push   %ebx
f0100323:	83 ec 04             	sub    $0x4,%esp
f0100326:	ba 64 00 00 00       	mov    $0x64,%edx
f010032b:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f010032c:	a8 01                	test   $0x1,%al
f010032e:	0f 84 f2 00 00 00    	je     f0100426 <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f0100334:	a8 20                	test   $0x20,%al
f0100336:	0f 85 f1 00 00 00    	jne    f010042d <kbd_proc_data+0x10e>
f010033c:	ba 60 00 00 00       	mov    $0x60,%edx
f0100341:	ec                   	in     (%dx),%al
f0100342:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100344:	3c e0                	cmp    $0xe0,%al
f0100346:	74 61                	je     f01003a9 <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f0100348:	84 c0                	test   %al,%al
f010034a:	78 70                	js     f01003bc <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f010034c:	8b 0d c0 b6 5d f0    	mov    0xf05db6c0,%ecx
f0100352:	f6 c1 40             	test   $0x40,%cl
f0100355:	74 0e                	je     f0100365 <kbd_proc_data+0x46>
		data |= 0x80;
f0100357:	83 c8 80             	or     $0xffffff80,%eax
f010035a:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010035c:	83 e1 bf             	and    $0xffffffbf,%ecx
f010035f:	89 0d c0 b6 5d f0    	mov    %ecx,0xf05db6c0
	shift |= shiftcode[data];
f0100365:	0f b6 d2             	movzbl %dl,%edx
f0100368:	0f b6 82 40 86 10 f0 	movzbl -0xfef79c0(%edx),%eax
f010036f:	0b 05 c0 b6 5d f0    	or     0xf05db6c0,%eax
	shift ^= togglecode[data];
f0100375:	0f b6 8a 40 85 10 f0 	movzbl -0xfef7ac0(%edx),%ecx
f010037c:	31 c8                	xor    %ecx,%eax
f010037e:	a3 c0 b6 5d f0       	mov    %eax,0xf05db6c0
	c = charcode[shift & (CTL | SHIFT)][data];
f0100383:	89 c1                	mov    %eax,%ecx
f0100385:	83 e1 03             	and    $0x3,%ecx
f0100388:	8b 0c 8d 20 85 10 f0 	mov    -0xfef7ae0(,%ecx,4),%ecx
f010038f:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100393:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100396:	a8 08                	test   $0x8,%al
f0100398:	74 61                	je     f01003fb <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f010039a:	89 da                	mov    %ebx,%edx
f010039c:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f010039f:	83 f9 19             	cmp    $0x19,%ecx
f01003a2:	77 4b                	ja     f01003ef <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f01003a4:	83 eb 20             	sub    $0x20,%ebx
f01003a7:	eb 0c                	jmp    f01003b5 <kbd_proc_data+0x96>
		shift |= E0ESC;
f01003a9:	83 0d c0 b6 5d f0 40 	orl    $0x40,0xf05db6c0
		return 0;
f01003b0:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01003b5:	89 d8                	mov    %ebx,%eax
f01003b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01003ba:	c9                   	leave  
f01003bb:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003bc:	8b 0d c0 b6 5d f0    	mov    0xf05db6c0,%ecx
f01003c2:	89 cb                	mov    %ecx,%ebx
f01003c4:	83 e3 40             	and    $0x40,%ebx
f01003c7:	83 e0 7f             	and    $0x7f,%eax
f01003ca:	85 db                	test   %ebx,%ebx
f01003cc:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003cf:	0f b6 d2             	movzbl %dl,%edx
f01003d2:	0f b6 82 40 86 10 f0 	movzbl -0xfef79c0(%edx),%eax
f01003d9:	83 c8 40             	or     $0x40,%eax
f01003dc:	0f b6 c0             	movzbl %al,%eax
f01003df:	f7 d0                	not    %eax
f01003e1:	21 c8                	and    %ecx,%eax
f01003e3:	a3 c0 b6 5d f0       	mov    %eax,0xf05db6c0
		return 0;
f01003e8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003ed:	eb c6                	jmp    f01003b5 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f01003ef:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003f2:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003f5:	83 fa 1a             	cmp    $0x1a,%edx
f01003f8:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003fb:	f7 d0                	not    %eax
f01003fd:	a8 06                	test   $0x6,%al
f01003ff:	75 b4                	jne    f01003b5 <kbd_proc_data+0x96>
f0100401:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100407:	75 ac                	jne    f01003b5 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f0100409:	83 ec 0c             	sub    $0xc,%esp
f010040c:	68 e8 84 10 f0       	push   $0xf01084e8
f0100411:	e8 eb 41 00 00       	call   f0104601 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100416:	b8 03 00 00 00       	mov    $0x3,%eax
f010041b:	ba 92 00 00 00       	mov    $0x92,%edx
f0100420:	ee                   	out    %al,(%dx)
f0100421:	83 c4 10             	add    $0x10,%esp
f0100424:	eb 8f                	jmp    f01003b5 <kbd_proc_data+0x96>
		return -1;
f0100426:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010042b:	eb 88                	jmp    f01003b5 <kbd_proc_data+0x96>
		return -1;
f010042d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100432:	eb 81                	jmp    f01003b5 <kbd_proc_data+0x96>

f0100434 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100434:	55                   	push   %ebp
f0100435:	89 e5                	mov    %esp,%ebp
f0100437:	57                   	push   %edi
f0100438:	56                   	push   %esi
f0100439:	53                   	push   %ebx
f010043a:	83 ec 1c             	sub    $0x1c,%esp
f010043d:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f010043f:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100444:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100449:	bb 84 00 00 00       	mov    $0x84,%ebx
f010044e:	89 fa                	mov    %edi,%edx
f0100450:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100451:	a8 20                	test   $0x20,%al
f0100453:	75 13                	jne    f0100468 <cons_putc+0x34>
f0100455:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010045b:	7f 0b                	jg     f0100468 <cons_putc+0x34>
f010045d:	89 da                	mov    %ebx,%edx
f010045f:	ec                   	in     (%dx),%al
f0100460:	ec                   	in     (%dx),%al
f0100461:	ec                   	in     (%dx),%al
f0100462:	ec                   	in     (%dx),%al
	     i++)
f0100463:	83 c6 01             	add    $0x1,%esi
f0100466:	eb e6                	jmp    f010044e <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f0100468:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010046b:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100470:	89 c8                	mov    %ecx,%eax
f0100472:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100473:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100478:	bf 79 03 00 00       	mov    $0x379,%edi
f010047d:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100482:	89 fa                	mov    %edi,%edx
f0100484:	ec                   	in     (%dx),%al
f0100485:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010048b:	7f 0f                	jg     f010049c <cons_putc+0x68>
f010048d:	84 c0                	test   %al,%al
f010048f:	78 0b                	js     f010049c <cons_putc+0x68>
f0100491:	89 da                	mov    %ebx,%edx
f0100493:	ec                   	in     (%dx),%al
f0100494:	ec                   	in     (%dx),%al
f0100495:	ec                   	in     (%dx),%al
f0100496:	ec                   	in     (%dx),%al
f0100497:	83 c6 01             	add    $0x1,%esi
f010049a:	eb e6                	jmp    f0100482 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010049c:	ba 78 03 00 00       	mov    $0x378,%edx
f01004a1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f01004a5:	ee                   	out    %al,(%dx)
f01004a6:	ba 7a 03 00 00       	mov    $0x37a,%edx
f01004ab:	b8 0d 00 00 00       	mov    $0xd,%eax
f01004b0:	ee                   	out    %al,(%dx)
f01004b1:	b8 08 00 00 00       	mov    $0x8,%eax
f01004b6:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f01004b7:	89 ca                	mov    %ecx,%edx
f01004b9:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f01004bf:	89 c8                	mov    %ecx,%eax
f01004c1:	80 cc 07             	or     $0x7,%ah
f01004c4:	85 d2                	test   %edx,%edx
f01004c6:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f01004c9:	0f b6 c1             	movzbl %cl,%eax
f01004cc:	83 f8 09             	cmp    $0x9,%eax
f01004cf:	0f 84 b0 00 00 00    	je     f0100585 <cons_putc+0x151>
f01004d5:	7e 73                	jle    f010054a <cons_putc+0x116>
f01004d7:	83 f8 0a             	cmp    $0xa,%eax
f01004da:	0f 84 98 00 00 00    	je     f0100578 <cons_putc+0x144>
f01004e0:	83 f8 0d             	cmp    $0xd,%eax
f01004e3:	0f 85 d3 00 00 00    	jne    f01005bc <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f01004e9:	0f b7 05 e8 b8 5d f0 	movzwl 0xf05db8e8,%eax
f01004f0:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004f6:	c1 e8 16             	shr    $0x16,%eax
f01004f9:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004fc:	c1 e0 04             	shl    $0x4,%eax
f01004ff:	66 a3 e8 b8 5d f0    	mov    %ax,0xf05db8e8
	if (crt_pos >= CRT_SIZE) {
f0100505:	66 81 3d e8 b8 5d f0 	cmpw   $0x7cf,0xf05db8e8
f010050c:	cf 07 
f010050e:	0f 87 cb 00 00 00    	ja     f01005df <cons_putc+0x1ab>
	outb(addr_6845, 14);
f0100514:	8b 0d f0 b8 5d f0    	mov    0xf05db8f0,%ecx
f010051a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010051f:	89 ca                	mov    %ecx,%edx
f0100521:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100522:	0f b7 1d e8 b8 5d f0 	movzwl 0xf05db8e8,%ebx
f0100529:	8d 71 01             	lea    0x1(%ecx),%esi
f010052c:	89 d8                	mov    %ebx,%eax
f010052e:	66 c1 e8 08          	shr    $0x8,%ax
f0100532:	89 f2                	mov    %esi,%edx
f0100534:	ee                   	out    %al,(%dx)
f0100535:	b8 0f 00 00 00       	mov    $0xf,%eax
f010053a:	89 ca                	mov    %ecx,%edx
f010053c:	ee                   	out    %al,(%dx)
f010053d:	89 d8                	mov    %ebx,%eax
f010053f:	89 f2                	mov    %esi,%edx
f0100541:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100542:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100545:	5b                   	pop    %ebx
f0100546:	5e                   	pop    %esi
f0100547:	5f                   	pop    %edi
f0100548:	5d                   	pop    %ebp
f0100549:	c3                   	ret    
	switch (c & 0xff) {
f010054a:	83 f8 08             	cmp    $0x8,%eax
f010054d:	75 6d                	jne    f01005bc <cons_putc+0x188>
		if (crt_pos > 0) {
f010054f:	0f b7 05 e8 b8 5d f0 	movzwl 0xf05db8e8,%eax
f0100556:	66 85 c0             	test   %ax,%ax
f0100559:	74 b9                	je     f0100514 <cons_putc+0xe0>
			crt_pos--;
f010055b:	83 e8 01             	sub    $0x1,%eax
f010055e:	66 a3 e8 b8 5d f0    	mov    %ax,0xf05db8e8
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100564:	0f b7 c0             	movzwl %ax,%eax
f0100567:	b1 00                	mov    $0x0,%cl
f0100569:	83 c9 20             	or     $0x20,%ecx
f010056c:	8b 15 ec b8 5d f0    	mov    0xf05db8ec,%edx
f0100572:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f0100576:	eb 8d                	jmp    f0100505 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f0100578:	66 83 05 e8 b8 5d f0 	addw   $0x50,0xf05db8e8
f010057f:	50 
f0100580:	e9 64 ff ff ff       	jmp    f01004e9 <cons_putc+0xb5>
		cons_putc(' ');
f0100585:	b8 20 00 00 00       	mov    $0x20,%eax
f010058a:	e8 a5 fe ff ff       	call   f0100434 <cons_putc>
		cons_putc(' ');
f010058f:	b8 20 00 00 00       	mov    $0x20,%eax
f0100594:	e8 9b fe ff ff       	call   f0100434 <cons_putc>
		cons_putc(' ');
f0100599:	b8 20 00 00 00       	mov    $0x20,%eax
f010059e:	e8 91 fe ff ff       	call   f0100434 <cons_putc>
		cons_putc(' ');
f01005a3:	b8 20 00 00 00       	mov    $0x20,%eax
f01005a8:	e8 87 fe ff ff       	call   f0100434 <cons_putc>
		cons_putc(' ');
f01005ad:	b8 20 00 00 00       	mov    $0x20,%eax
f01005b2:	e8 7d fe ff ff       	call   f0100434 <cons_putc>
f01005b7:	e9 49 ff ff ff       	jmp    f0100505 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f01005bc:	0f b7 05 e8 b8 5d f0 	movzwl 0xf05db8e8,%eax
f01005c3:	8d 50 01             	lea    0x1(%eax),%edx
f01005c6:	66 89 15 e8 b8 5d f0 	mov    %dx,0xf05db8e8
f01005cd:	0f b7 c0             	movzwl %ax,%eax
f01005d0:	8b 15 ec b8 5d f0    	mov    0xf05db8ec,%edx
f01005d6:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005da:	e9 26 ff ff ff       	jmp    f0100505 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005df:	a1 ec b8 5d f0       	mov    0xf05db8ec,%eax
f01005e4:	83 ec 04             	sub    $0x4,%esp
f01005e7:	68 00 0f 00 00       	push   $0xf00
f01005ec:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005f2:	52                   	push   %edx
f01005f3:	50                   	push   %eax
f01005f4:	e8 5e 67 00 00       	call   f0106d57 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005f9:	8b 15 ec b8 5d f0    	mov    0xf05db8ec,%edx
f01005ff:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100605:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f010060b:	83 c4 10             	add    $0x10,%esp
f010060e:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100613:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100616:	39 d0                	cmp    %edx,%eax
f0100618:	75 f4                	jne    f010060e <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f010061a:	66 83 2d e8 b8 5d f0 	subw   $0x50,0xf05db8e8
f0100621:	50 
f0100622:	e9 ed fe ff ff       	jmp    f0100514 <cons_putc+0xe0>

f0100627 <serial_intr>:
	if (serial_exists)
f0100627:	80 3d f4 b8 5d f0 00 	cmpb   $0x0,0xf05db8f4
f010062e:	75 01                	jne    f0100631 <serial_intr+0xa>
f0100630:	c3                   	ret    
{
f0100631:	55                   	push   %ebp
f0100632:	89 e5                	mov    %esp,%ebp
f0100634:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100637:	b8 c6 02 10 f0       	mov    $0xf01002c6,%eax
f010063c:	e8 9f fc ff ff       	call   f01002e0 <cons_intr>
}
f0100641:	c9                   	leave  
f0100642:	c3                   	ret    

f0100643 <kbd_intr>:
{
f0100643:	55                   	push   %ebp
f0100644:	89 e5                	mov    %esp,%ebp
f0100646:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100649:	b8 1f 03 10 f0       	mov    $0xf010031f,%eax
f010064e:	e8 8d fc ff ff       	call   f01002e0 <cons_intr>
}
f0100653:	c9                   	leave  
f0100654:	c3                   	ret    

f0100655 <cons_getc>:
{
f0100655:	55                   	push   %ebp
f0100656:	89 e5                	mov    %esp,%ebp
f0100658:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010065b:	e8 c7 ff ff ff       	call   f0100627 <serial_intr>
	kbd_intr();
f0100660:	e8 de ff ff ff       	call   f0100643 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100665:	8b 15 e0 b8 5d f0    	mov    0xf05db8e0,%edx
	return 0;
f010066b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100670:	3b 15 e4 b8 5d f0    	cmp    0xf05db8e4,%edx
f0100676:	74 1e                	je     f0100696 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f0100678:	8d 4a 01             	lea    0x1(%edx),%ecx
f010067b:	0f b6 82 e0 b6 5d f0 	movzbl -0xfa24920(%edx),%eax
			cons.rpos = 0;
f0100682:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100688:	ba 00 00 00 00       	mov    $0x0,%edx
f010068d:	0f 44 ca             	cmove  %edx,%ecx
f0100690:	89 0d e0 b8 5d f0    	mov    %ecx,0xf05db8e0
}
f0100696:	c9                   	leave  
f0100697:	c3                   	ret    

f0100698 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100698:	55                   	push   %ebp
f0100699:	89 e5                	mov    %esp,%ebp
f010069b:	57                   	push   %edi
f010069c:	56                   	push   %esi
f010069d:	53                   	push   %ebx
f010069e:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f01006a1:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006a8:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006af:	5a a5 
	if (*cp != 0xA55A) {
f01006b1:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01006b8:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006bc:	0f 84 de 00 00 00    	je     f01007a0 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f01006c2:	c7 05 f0 b8 5d f0 b4 	movl   $0x3b4,0xf05db8f0
f01006c9:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006cc:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006d1:	8b 3d f0 b8 5d f0    	mov    0xf05db8f0,%edi
f01006d7:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006dc:	89 fa                	mov    %edi,%edx
f01006de:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006df:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006e2:	89 ca                	mov    %ecx,%edx
f01006e4:	ec                   	in     (%dx),%al
f01006e5:	0f b6 c0             	movzbl %al,%eax
f01006e8:	c1 e0 08             	shl    $0x8,%eax
f01006eb:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006ed:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006f2:	89 fa                	mov    %edi,%edx
f01006f4:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006f5:	89 ca                	mov    %ecx,%edx
f01006f7:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006f8:	89 35 ec b8 5d f0    	mov    %esi,0xf05db8ec
	pos |= inb(addr_6845 + 1);
f01006fe:	0f b6 c0             	movzbl %al,%eax
f0100701:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f0100703:	66 a3 e8 b8 5d f0    	mov    %ax,0xf05db8e8
	kbd_intr();
f0100709:	e8 35 ff ff ff       	call   f0100643 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f010070e:	83 ec 0c             	sub    $0xc,%esp
f0100711:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f0100718:	25 fd ff 00 00       	and    $0xfffd,%eax
f010071d:	50                   	push   %eax
f010071e:	e8 65 3d 00 00       	call   f0104488 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100723:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100728:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f010072d:	89 d8                	mov    %ebx,%eax
f010072f:	89 ca                	mov    %ecx,%edx
f0100731:	ee                   	out    %al,(%dx)
f0100732:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100737:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010073c:	89 fa                	mov    %edi,%edx
f010073e:	ee                   	out    %al,(%dx)
f010073f:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100744:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100749:	ee                   	out    %al,(%dx)
f010074a:	be f9 03 00 00       	mov    $0x3f9,%esi
f010074f:	89 d8                	mov    %ebx,%eax
f0100751:	89 f2                	mov    %esi,%edx
f0100753:	ee                   	out    %al,(%dx)
f0100754:	b8 03 00 00 00       	mov    $0x3,%eax
f0100759:	89 fa                	mov    %edi,%edx
f010075b:	ee                   	out    %al,(%dx)
f010075c:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100761:	89 d8                	mov    %ebx,%eax
f0100763:	ee                   	out    %al,(%dx)
f0100764:	b8 01 00 00 00       	mov    $0x1,%eax
f0100769:	89 f2                	mov    %esi,%edx
f010076b:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010076c:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100771:	ec                   	in     (%dx),%al
f0100772:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100774:	83 c4 10             	add    $0x10,%esp
f0100777:	3c ff                	cmp    $0xff,%al
f0100779:	0f 95 05 f4 b8 5d f0 	setne  0xf05db8f4
f0100780:	89 ca                	mov    %ecx,%edx
f0100782:	ec                   	in     (%dx),%al
f0100783:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100788:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100789:	80 fb ff             	cmp    $0xff,%bl
f010078c:	75 2d                	jne    f01007bb <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f010078e:	83 ec 0c             	sub    $0xc,%esp
f0100791:	68 f4 84 10 f0       	push   $0xf01084f4
f0100796:	e8 66 3e 00 00       	call   f0104601 <cprintf>
f010079b:	83 c4 10             	add    $0x10,%esp
}
f010079e:	eb 3c                	jmp    f01007dc <cons_init+0x144>
		*cp = was;
f01007a0:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01007a7:	c7 05 f0 b8 5d f0 d4 	movl   $0x3d4,0xf05db8f0
f01007ae:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01007b1:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f01007b6:	e9 16 ff ff ff       	jmp    f01006d1 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f01007bb:	83 ec 0c             	sub    $0xc,%esp
f01007be:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f01007c5:	25 ef ff 00 00       	and    $0xffef,%eax
f01007ca:	50                   	push   %eax
f01007cb:	e8 b8 3c 00 00       	call   f0104488 <irq_setmask_8259A>
	if (!serial_exists)
f01007d0:	83 c4 10             	add    $0x10,%esp
f01007d3:	80 3d f4 b8 5d f0 00 	cmpb   $0x0,0xf05db8f4
f01007da:	74 b2                	je     f010078e <cons_init+0xf6>
}
f01007dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007df:	5b                   	pop    %ebx
f01007e0:	5e                   	pop    %esi
f01007e1:	5f                   	pop    %edi
f01007e2:	5d                   	pop    %ebp
f01007e3:	c3                   	ret    

f01007e4 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007e4:	55                   	push   %ebp
f01007e5:	89 e5                	mov    %esp,%ebp
f01007e7:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007ea:	8b 45 08             	mov    0x8(%ebp),%eax
f01007ed:	e8 42 fc ff ff       	call   f0100434 <cons_putc>
}
f01007f2:	c9                   	leave  
f01007f3:	c3                   	ret    

f01007f4 <getchar>:

int
getchar(void)
{
f01007f4:	55                   	push   %ebp
f01007f5:	89 e5                	mov    %esp,%ebp
f01007f7:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007fa:	e8 56 fe ff ff       	call   f0100655 <cons_getc>
f01007ff:	85 c0                	test   %eax,%eax
f0100801:	74 f7                	je     f01007fa <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100803:	c9                   	leave  
f0100804:	c3                   	ret    

f0100805 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100805:	b8 01 00 00 00       	mov    $0x1,%eax
f010080a:	c3                   	ret    

f010080b <mon_help>:
/***** Implementations of basic kernel monitor commands *****/
static long atol(const char *nptr);

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f010080b:	55                   	push   %ebp
f010080c:	89 e5                	mov    %esp,%ebp
f010080e:	53                   	push   %ebx
f010080f:	83 ec 04             	sub    $0x4,%esp
f0100812:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100817:	83 ec 04             	sub    $0x4,%esp
f010081a:	ff b3 a4 8b 10 f0    	pushl  -0xfef745c(%ebx)
f0100820:	ff b3 a0 8b 10 f0    	pushl  -0xfef7460(%ebx)
f0100826:	68 40 87 10 f0       	push   $0xf0108740
f010082b:	e8 d1 3d 00 00       	call   f0104601 <cprintf>
f0100830:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100833:	83 c4 10             	add    $0x10,%esp
f0100836:	83 fb 3c             	cmp    $0x3c,%ebx
f0100839:	75 dc                	jne    f0100817 <mon_help+0xc>
	return 0;
}
f010083b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100843:	c9                   	leave  
f0100844:	c3                   	ret    

f0100845 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100845:	55                   	push   %ebp
f0100846:	89 e5                	mov    %esp,%ebp
f0100848:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010084b:	68 49 87 10 f0       	push   $0xf0108749
f0100850:	e8 ac 3d 00 00       	call   f0104601 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100855:	83 c4 08             	add    $0x8,%esp
f0100858:	68 0c 00 10 00       	push   $0x10000c
f010085d:	68 ac 88 10 f0       	push   $0xf01088ac
f0100862:	e8 9a 3d 00 00       	call   f0104601 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100867:	83 c4 0c             	add    $0xc,%esp
f010086a:	68 0c 00 10 00       	push   $0x10000c
f010086f:	68 0c 00 10 f0       	push   $0xf010000c
f0100874:	68 d4 88 10 f0       	push   $0xf01088d4
f0100879:	e8 83 3d 00 00       	call   f0104601 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010087e:	83 c4 0c             	add    $0xc,%esp
f0100881:	68 df 83 10 00       	push   $0x1083df
f0100886:	68 df 83 10 f0       	push   $0xf01083df
f010088b:	68 f8 88 10 f0       	push   $0xf01088f8
f0100890:	e8 6c 3d 00 00       	call   f0104601 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100895:	83 c4 0c             	add    $0xc,%esp
f0100898:	68 c0 b6 5d 00       	push   $0x5db6c0
f010089d:	68 c0 b6 5d f0       	push   $0xf05db6c0
f01008a2:	68 1c 89 10 f0       	push   $0xf010891c
f01008a7:	e8 55 3d 00 00       	call   f0104601 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008ac:	83 c4 0c             	add    $0xc,%esp
f01008af:	68 80 bb 6b 00       	push   $0x6bbb80
f01008b4:	68 80 bb 6b f0       	push   $0xf06bbb80
f01008b9:	68 40 89 10 f0       	push   $0xf0108940
f01008be:	e8 3e 3d 00 00       	call   f0104601 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008c3:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008c6:	b8 80 bb 6b f0       	mov    $0xf06bbb80,%eax
f01008cb:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008d0:	c1 f8 0a             	sar    $0xa,%eax
f01008d3:	50                   	push   %eax
f01008d4:	68 64 89 10 f0       	push   $0xf0108964
f01008d9:	e8 23 3d 00 00       	call   f0104601 <cprintf>
	return 0;
}
f01008de:	b8 00 00 00 00       	mov    $0x0,%eax
f01008e3:	c9                   	leave  
f01008e4:	c3                   	ret    

f01008e5 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008e5:	55                   	push   %ebp
f01008e6:	89 e5                	mov    %esp,%ebp
f01008e8:	56                   	push   %esi
f01008e9:	53                   	push   %ebx
f01008ea:	83 ec 20             	sub    $0x20,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008ed:	89 eb                	mov    %ebp,%ebx
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
		debuginfo_eip(the_ebp[1], &info);
f01008ef:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(the_ebp != NULL){
f01008f2:	85 db                	test   %ebx,%ebx
f01008f4:	0f 84 b3 00 00 00    	je     f01009ad <mon_backtrace+0xc8>
		cprintf("the ebp1 0x%x\n", the_ebp[1]);
f01008fa:	83 ec 08             	sub    $0x8,%esp
f01008fd:	ff 73 04             	pushl  0x4(%ebx)
f0100900:	68 62 87 10 f0       	push   $0xf0108762
f0100905:	e8 f7 3c 00 00       	call   f0104601 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f010090a:	83 c4 08             	add    $0x8,%esp
f010090d:	ff 73 08             	pushl  0x8(%ebx)
f0100910:	68 71 87 10 f0       	push   $0xf0108771
f0100915:	e8 e7 3c 00 00       	call   f0104601 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f010091a:	83 c4 08             	add    $0x8,%esp
f010091d:	ff 73 0c             	pushl  0xc(%ebx)
f0100920:	68 80 87 10 f0       	push   $0xf0108780
f0100925:	e8 d7 3c 00 00       	call   f0104601 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f010092a:	83 c4 08             	add    $0x8,%esp
f010092d:	ff 73 10             	pushl  0x10(%ebx)
f0100930:	68 8f 87 10 f0       	push   $0xf010878f
f0100935:	e8 c7 3c 00 00       	call   f0104601 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f010093a:	83 c4 08             	add    $0x8,%esp
f010093d:	ff 73 14             	pushl  0x14(%ebx)
f0100940:	68 9e 87 10 f0       	push   $0xf010879e
f0100945:	e8 b7 3c 00 00       	call   f0104601 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f010094a:	83 c4 08             	add    $0x8,%esp
f010094d:	ff 73 18             	pushl  0x18(%ebx)
f0100950:	68 ad 87 10 f0       	push   $0xf01087ad
f0100955:	e8 a7 3c 00 00       	call   f0104601 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f010095a:	ff 73 18             	pushl  0x18(%ebx)
f010095d:	ff 73 14             	pushl  0x14(%ebx)
f0100960:	ff 73 10             	pushl  0x10(%ebx)
f0100963:	ff 73 0c             	pushl  0xc(%ebx)
f0100966:	ff 73 08             	pushl  0x8(%ebx)
f0100969:	53                   	push   %ebx
f010096a:	ff 73 04             	pushl  0x4(%ebx)
f010096d:	68 90 89 10 f0       	push   $0xf0108990
f0100972:	e8 8a 3c 00 00       	call   f0104601 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f0100977:	83 c4 28             	add    $0x28,%esp
f010097a:	56                   	push   %esi
f010097b:	ff 73 04             	pushl  0x4(%ebx)
f010097e:	e8 25 57 00 00       	call   f01060a8 <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f0100983:	83 c4 08             	add    $0x8,%esp
f0100986:	8b 43 04             	mov    0x4(%ebx),%eax
f0100989:	2b 45 f0             	sub    -0x10(%ebp),%eax
f010098c:	50                   	push   %eax
f010098d:	ff 75 e8             	pushl  -0x18(%ebp)
f0100990:	ff 75 ec             	pushl  -0x14(%ebp)
f0100993:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100996:	ff 75 e0             	pushl  -0x20(%ebp)
f0100999:	68 bc 87 10 f0       	push   $0xf01087bc
f010099e:	e8 5e 3c 00 00       	call   f0104601 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f01009a3:	8b 1b                	mov    (%ebx),%ebx
f01009a5:	83 c4 20             	add    $0x20,%esp
f01009a8:	e9 45 ff ff ff       	jmp    f01008f2 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f01009ad:	83 ec 0c             	sub    $0xc,%esp
f01009b0:	68 d2 87 10 f0       	push   $0xf01087d2
f01009b5:	e8 47 3c 00 00       	call   f0104601 <cprintf>
	return 0;
}
f01009ba:	b8 00 00 00 00       	mov    $0x0,%eax
f01009bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01009c2:	5b                   	pop    %ebx
f01009c3:	5e                   	pop    %esi
f01009c4:	5d                   	pop    %ebp
f01009c5:	c3                   	ret    

f01009c6 <mon_showmappings>:
	cycles_t end = currentcycles();
	cprintf("%s cycles: %ul\n", fun_n, end - start);
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f01009c6:	55                   	push   %ebp
f01009c7:	89 e5                	mov    %esp,%ebp
f01009c9:	57                   	push   %edi
f01009ca:	56                   	push   %esi
f01009cb:	53                   	push   %ebx
f01009cc:	83 ec 2c             	sub    $0x2c,%esp
	if(argc != 3){
f01009cf:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f01009d3:	75 3f                	jne    f0100a14 <mon_showmappings+0x4e>
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
		return 0;
	}
	uint32_t low_va = 0, high_va = 0, old_va;
	if(argv[1][0]!='0'||argv[1][1]!='x'||argv[2][0]!='0'||argv[2][1]!='x'){
f01009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01009d8:	8b 40 04             	mov    0x4(%eax),%eax
f01009db:	80 38 30             	cmpb   $0x30,(%eax)
f01009de:	75 17                	jne    f01009f7 <mon_showmappings+0x31>
f01009e0:	80 78 01 78          	cmpb   $0x78,0x1(%eax)
f01009e4:	75 11                	jne    f01009f7 <mon_showmappings+0x31>
f01009e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01009e9:	8b 51 08             	mov    0x8(%ecx),%edx
f01009ec:	80 3a 30             	cmpb   $0x30,(%edx)
f01009ef:	75 06                	jne    f01009f7 <mon_showmappings+0x31>
f01009f1:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01009f5:	74 34                	je     f0100a2b <mon_showmappings+0x65>
		cprintf("the virtual-address should be 16-base\n");
f01009f7:	83 ec 0c             	sub    $0xc,%esp
f01009fa:	68 00 8a 10 f0       	push   $0xf0108a00
f01009ff:	e8 fd 3b 00 00       	call   f0104601 <cprintf>
		return 0;
f0100a04:	83 c4 10             	add    $0x10,%esp
		low_va += PTSIZE;
		if(low_va <= old_va)
			break;
    }
    return 0;
}
f0100a07:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a0f:	5b                   	pop    %ebx
f0100a10:	5e                   	pop    %esi
f0100a11:	5f                   	pop    %edi
f0100a12:	5d                   	pop    %ebp
f0100a13:	c3                   	ret    
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
f0100a14:	83 ec 08             	sub    $0x8,%esp
f0100a17:	68 80 8b 10 f0       	push   $0xf0108b80
f0100a1c:	68 c4 89 10 f0       	push   $0xf01089c4
f0100a21:	e8 db 3b 00 00       	call   f0104601 <cprintf>
		return 0;
f0100a26:	83 c4 10             	add    $0x10,%esp
f0100a29:	eb dc                	jmp    f0100a07 <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f0100a2b:	83 ec 04             	sub    $0x4,%esp
f0100a2e:	6a 10                	push   $0x10
f0100a30:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f0100a33:	56                   	push   %esi
f0100a34:	50                   	push   %eax
f0100a35:	e8 eb 63 00 00       	call   f0106e25 <strtol>
f0100a3a:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a3c:	83 c4 0c             	add    $0xc,%esp
f0100a3f:	6a 10                	push   $0x10
f0100a41:	56                   	push   %esi
f0100a42:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a45:	ff 70 08             	pushl  0x8(%eax)
f0100a48:	e8 d8 63 00 00       	call   f0106e25 <strtol>
	low_va = low_va/PGSIZE * PGSIZE;
f0100a4d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	high_va = high_va/PGSIZE * PGSIZE;
f0100a53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(low_va > high_va){
f0100a5b:	83 c4 10             	add    $0x10,%esp
f0100a5e:	39 c3                	cmp    %eax,%ebx
f0100a60:	0f 86 1c 01 00 00    	jbe    f0100b82 <mon_showmappings+0x1bc>
		cprintf("the start-va should < the end-va\n");
f0100a66:	83 ec 0c             	sub    $0xc,%esp
f0100a69:	68 28 8a 10 f0       	push   $0xf0108a28
f0100a6e:	e8 8e 3b 00 00       	call   f0104601 <cprintf>
		return 0;
f0100a73:	83 c4 10             	add    $0x10,%esp
f0100a76:	eb 8f                	jmp    f0100a07 <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100a78:	83 ec 04             	sub    $0x4,%esp
f0100a7b:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100a81:	50                   	push   %eax
f0100a82:	53                   	push   %ebx
f0100a83:	68 e5 87 10 f0       	push   $0xf01087e5
f0100a88:	e8 74 3b 00 00       	call   f0104601 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100a8d:	8b 06                	mov    (%esi),%eax
f0100a8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a94:	83 c4 0c             	add    $0xc,%esp
f0100a97:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100a9d:	52                   	push   %edx
f0100a9e:	50                   	push   %eax
f0100a9f:	68 f4 87 10 f0       	push   $0xf01087f4
f0100aa4:	e8 58 3b 00 00       	call   f0104601 <cprintf>
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100aa9:	83 c4 0c             	add    $0xc,%esp
f0100aac:	89 f8                	mov    %edi,%eax
f0100aae:	83 e0 01             	and    $0x1,%eax
f0100ab1:	50                   	push   %eax
					u_bit = pte[PTX(low_va)] & PTE_U;
f0100ab2:	89 f8                	mov    %edi,%eax
f0100ab4:	83 e0 04             	and    $0x4,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ab7:	0f be c0             	movsbl %al,%eax
f0100aba:	50                   	push   %eax
					w_bit = pte[PTX(low_va)] & PTE_W;
f0100abb:	89 f8                	mov    %edi,%eax
f0100abd:	83 e0 02             	and    $0x2,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ac0:	0f be c0             	movsbl %al,%eax
f0100ac3:	50                   	push   %eax
					a_bit = pte[PTX(low_va)] & PTE_A;
f0100ac4:	89 f8                	mov    %edi,%eax
f0100ac6:	83 e0 20             	and    $0x20,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ac9:	0f be c0             	movsbl %al,%eax
f0100acc:	50                   	push   %eax
					d_bit = pte[PTX(low_va)] & PTE_D;
f0100acd:	89 f8                	mov    %edi,%eax
f0100acf:	83 e0 40             	and    $0x40,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ad2:	0f be c0             	movsbl %al,%eax
f0100ad5:	50                   	push   %eax
f0100ad6:	6a 00                	push   $0x0
f0100ad8:	68 03 88 10 f0       	push   $0xf0108803
f0100add:	e8 1f 3b 00 00       	call   f0104601 <cprintf>
f0100ae2:	83 c4 20             	add    $0x20,%esp
f0100ae5:	e9 dc 00 00 00       	jmp    f0100bc6 <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100aea:	83 ec 04             	sub    $0x4,%esp
f0100aed:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100af3:	50                   	push   %eax
f0100af4:	53                   	push   %ebx
f0100af5:	68 e5 87 10 f0       	push   $0xf01087e5
f0100afa:	e8 02 3b 00 00       	call   f0104601 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100aff:	8b 07                	mov    (%edi),%eax
f0100b01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b06:	83 c4 0c             	add    $0xc,%esp
f0100b09:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100b0f:	52                   	push   %edx
f0100b10:	50                   	push   %eax
f0100b11:	68 f4 87 10 f0       	push   $0xf01087f4
f0100b16:	e8 e6 3a 00 00       	call   f0104601 <cprintf>
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b1b:	83 c4 0c             	add    $0xc,%esp
f0100b1e:	89 f0                	mov    %esi,%eax
f0100b20:	83 e0 01             	and    $0x1,%eax
f0100b23:	50                   	push   %eax
				u_bit = *pde & PTE_U;
f0100b24:	89 f0                	mov    %esi,%eax
f0100b26:	83 e0 04             	and    $0x4,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b29:	0f be c0             	movsbl %al,%eax
f0100b2c:	50                   	push   %eax
				w_bit = *pde & PTE_W;
f0100b2d:	89 f0                	mov    %esi,%eax
f0100b2f:	83 e0 02             	and    $0x2,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b32:	0f be c0             	movsbl %al,%eax
f0100b35:	50                   	push   %eax
				a_bit = *pde & PTE_A;
f0100b36:	89 f0                	mov    %esi,%eax
f0100b38:	83 e0 20             	and    $0x20,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b3b:	0f be c0             	movsbl %al,%eax
f0100b3e:	50                   	push   %eax
				d_bit = *pde & PTE_D;
f0100b3f:	89 f0                	mov    %esi,%eax
f0100b41:	83 e0 40             	and    $0x40,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b44:	0f be c0             	movsbl %al,%eax
f0100b47:	50                   	push   %eax
f0100b48:	6a 00                	push   $0x0
f0100b4a:	68 03 88 10 f0       	push   $0xf0108803
f0100b4f:	e8 ad 3a 00 00       	call   f0104601 <cprintf>
				low_va += PTSIZE;
f0100b54:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
				if(low_va <= old_va)
f0100b5a:	83 c4 20             	add    $0x20,%esp
f0100b5d:	39 d8                	cmp    %ebx,%eax
f0100b5f:	0f 86 a2 fe ff ff    	jbe    f0100a07 <mon_showmappings+0x41>
				low_va += PTSIZE;
f0100b65:	89 c3                	mov    %eax,%ebx
f0100b67:	eb 10                	jmp    f0100b79 <mon_showmappings+0x1b3>
		low_va += PTSIZE;
f0100b69:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
		if(low_va <= old_va)
f0100b6f:	39 d8                	cmp    %ebx,%eax
f0100b71:	0f 86 90 fe ff ff    	jbe    f0100a07 <mon_showmappings+0x41>
		low_va += PTSIZE;
f0100b77:	89 c3                	mov    %eax,%ebx
    while (low_va <= high_va) {
f0100b79:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0100b7c:	0f 87 85 fe ff ff    	ja     f0100a07 <mon_showmappings+0x41>
        pde_t *pde = &kern_pgdir[PDX(low_va)];
f0100b82:	89 da                	mov    %ebx,%edx
f0100b84:	c1 ea 16             	shr    $0x16,%edx
f0100b87:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0100b8c:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if (*pde) {
f0100b8f:	8b 37                	mov    (%edi),%esi
f0100b91:	85 f6                	test   %esi,%esi
f0100b93:	74 d4                	je     f0100b69 <mon_showmappings+0x1a3>
            if (low_va < (uint32_t)KERNBASE) {
f0100b95:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100b9b:	0f 87 49 ff ff ff    	ja     f0100aea <mon_showmappings+0x124>
                pte_t *pte = (pte_t*)(PTE_ADDR(*pde)+KERNBASE);
f0100ba1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
				if(pte[PTX(low_va)] & PTE_P){
f0100ba7:	89 d8                	mov    %ebx,%eax
f0100ba9:	c1 e8 0a             	shr    $0xa,%eax
f0100bac:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100bb1:	8d b4 06 00 00 00 f0 	lea    -0x10000000(%esi,%eax,1),%esi
f0100bb8:	8b 3e                	mov    (%esi),%edi
f0100bba:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0100bc0:	0f 85 b2 fe ff ff    	jne    f0100a78 <mon_showmappings+0xb2>
				low_va += PGSIZE;
f0100bc6:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
				if(low_va <= old_va)
f0100bcc:	39 d8                	cmp    %ebx,%eax
f0100bce:	0f 86 33 fe ff ff    	jbe    f0100a07 <mon_showmappings+0x41>
				low_va += PGSIZE;
f0100bd4:	89 c3                	mov    %eax,%ebx
f0100bd6:	eb a1                	jmp    f0100b79 <mon_showmappings+0x1b3>

f0100bd8 <mon_time>:
mon_time(int argc, char **argv, struct Trapframe *tf){
f0100bd8:	55                   	push   %ebp
f0100bd9:	89 e5                	mov    %esp,%ebp
f0100bdb:	57                   	push   %edi
f0100bdc:	56                   	push   %esi
f0100bdd:	53                   	push   %ebx
f0100bde:	83 ec 1c             	sub    $0x1c,%esp
f0100be1:	8b 45 0c             	mov    0xc(%ebp),%eax
	char *fun_n = argv[1];
f0100be4:	8b 78 04             	mov    0x4(%eax),%edi
	if(argc != 2)
f0100be7:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100beb:	0f 85 84 00 00 00    	jne    f0100c75 <mon_time+0x9d>
	for(int i = 0; i < command_size; i++){
f0100bf1:	bb 00 00 00 00       	mov    $0x0,%ebx
	cycles_t start = 0;
f0100bf6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0100bfd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100c04:	83 c0 08             	add    $0x8,%eax
f0100c07:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100c0a:	eb 20                	jmp    f0100c2c <mon_time+0x54>
	}
}

cycles_t currentcycles() {
    cycles_t result;
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c0c:	0f 31                	rdtsc  
f0100c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100c11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100c14:	83 ec 04             	sub    $0x4,%esp
f0100c17:	ff 75 10             	pushl  0x10(%ebp)
f0100c1a:	ff 75 dc             	pushl  -0x24(%ebp)
f0100c1d:	6a 00                	push   $0x0
f0100c1f:	ff 14 b5 a8 8b 10 f0 	call   *-0xfef7458(,%esi,4)
f0100c26:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100c29:	83 c3 01             	add    $0x1,%ebx
f0100c2c:	39 1d 00 d3 16 f0    	cmp    %ebx,0xf016d300
f0100c32:	7e 1c                	jle    f0100c50 <mon_time+0x78>
f0100c34:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c37:	83 ec 08             	sub    $0x8,%esp
f0100c3a:	57                   	push   %edi
f0100c3b:	ff 34 b5 a0 8b 10 f0 	pushl  -0xfef7460(,%esi,4)
f0100c42:	e8 2d 60 00 00       	call   f0106c74 <strcmp>
f0100c47:	83 c4 10             	add    $0x10,%esp
f0100c4a:	85 c0                	test   %eax,%eax
f0100c4c:	75 db                	jne    f0100c29 <mon_time+0x51>
f0100c4e:	eb bc                	jmp    f0100c0c <mon_time+0x34>
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c50:	0f 31                	rdtsc  
	cprintf("%s cycles: %ul\n", fun_n, end - start);
f0100c52:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100c55:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
f0100c58:	52                   	push   %edx
f0100c59:	50                   	push   %eax
f0100c5a:	57                   	push   %edi
f0100c5b:	68 16 88 10 f0       	push   $0xf0108816
f0100c60:	e8 9c 39 00 00       	call   f0104601 <cprintf>
	return 0;
f0100c65:	83 c4 10             	add    $0x10,%esp
f0100c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c70:	5b                   	pop    %ebx
f0100c71:	5e                   	pop    %esi
f0100c72:	5f                   	pop    %edi
f0100c73:	5d                   	pop    %ebp
f0100c74:	c3                   	ret    
		return -1;
f0100c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c7a:	eb f1                	jmp    f0100c6d <mon_time+0x95>

f0100c7c <monitor>:
{
f0100c7c:	55                   	push   %ebp
f0100c7d:	89 e5                	mov    %esp,%ebp
f0100c7f:	57                   	push   %edi
f0100c80:	56                   	push   %esi
f0100c81:	53                   	push   %ebx
f0100c82:	83 ec 58             	sub    $0x58,%esp
	cprintf("Welcome to the JOS kernel monitor!\n");
f0100c85:	68 4c 8a 10 f0       	push   $0xf0108a4c
f0100c8a:	e8 72 39 00 00       	call   f0104601 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c8f:	c7 04 24 70 8a 10 f0 	movl   $0xf0108a70,(%esp)
f0100c96:	e8 66 39 00 00       	call   f0104601 <cprintf>
	if (tf != NULL)
f0100c9b:	83 c4 10             	add    $0x10,%esp
f0100c9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100ca2:	0f 84 d9 00 00 00    	je     f0100d81 <monitor+0x105>
		print_trapframe(tf);
f0100ca8:	83 ec 0c             	sub    $0xc,%esp
f0100cab:	ff 75 08             	pushl  0x8(%ebp)
f0100cae:	e8 eb 40 00 00       	call   f0104d9e <print_trapframe>
f0100cb3:	83 c4 10             	add    $0x10,%esp
f0100cb6:	e9 c6 00 00 00       	jmp    f0100d81 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100cbb:	83 ec 08             	sub    $0x8,%esp
f0100cbe:	0f be c0             	movsbl %al,%eax
f0100cc1:	50                   	push   %eax
f0100cc2:	68 2a 88 10 f0       	push   $0xf010882a
f0100cc7:	e8 06 60 00 00       	call   f0106cd2 <strchr>
f0100ccc:	83 c4 10             	add    $0x10,%esp
f0100ccf:	85 c0                	test   %eax,%eax
f0100cd1:	74 63                	je     f0100d36 <monitor+0xba>
			*buf++ = 0;
f0100cd3:	c6 03 00             	movb   $0x0,(%ebx)
f0100cd6:	89 f7                	mov    %esi,%edi
f0100cd8:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100cdb:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100cdd:	0f b6 03             	movzbl (%ebx),%eax
f0100ce0:	84 c0                	test   %al,%al
f0100ce2:	75 d7                	jne    f0100cbb <monitor+0x3f>
	argv[argc] = 0;
f0100ce4:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100ceb:	00 
	if (argc == 0)
f0100cec:	85 f6                	test   %esi,%esi
f0100cee:	0f 84 8d 00 00 00    	je     f0100d81 <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100cf9:	83 ec 08             	sub    $0x8,%esp
f0100cfc:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100cff:	ff 34 85 a0 8b 10 f0 	pushl  -0xfef7460(,%eax,4)
f0100d06:	ff 75 a8             	pushl  -0x58(%ebp)
f0100d09:	e8 66 5f 00 00       	call   f0106c74 <strcmp>
f0100d0e:	83 c4 10             	add    $0x10,%esp
f0100d11:	85 c0                	test   %eax,%eax
f0100d13:	0f 84 8f 00 00 00    	je     f0100da8 <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100d19:	83 c3 01             	add    $0x1,%ebx
f0100d1c:	83 fb 05             	cmp    $0x5,%ebx
f0100d1f:	75 d8                	jne    f0100cf9 <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100d21:	83 ec 08             	sub    $0x8,%esp
f0100d24:	ff 75 a8             	pushl  -0x58(%ebp)
f0100d27:	68 4c 88 10 f0       	push   $0xf010884c
f0100d2c:	e8 d0 38 00 00       	call   f0104601 <cprintf>
f0100d31:	83 c4 10             	add    $0x10,%esp
f0100d34:	eb 4b                	jmp    f0100d81 <monitor+0x105>
		if (*buf == 0)
f0100d36:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100d39:	74 a9                	je     f0100ce4 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100d3b:	83 fe 0f             	cmp    $0xf,%esi
f0100d3e:	74 2f                	je     f0100d6f <monitor+0xf3>
		argv[argc++] = buf;
f0100d40:	8d 7e 01             	lea    0x1(%esi),%edi
f0100d43:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100d47:	0f b6 03             	movzbl (%ebx),%eax
f0100d4a:	84 c0                	test   %al,%al
f0100d4c:	74 8d                	je     f0100cdb <monitor+0x5f>
f0100d4e:	83 ec 08             	sub    $0x8,%esp
f0100d51:	0f be c0             	movsbl %al,%eax
f0100d54:	50                   	push   %eax
f0100d55:	68 2a 88 10 f0       	push   $0xf010882a
f0100d5a:	e8 73 5f 00 00       	call   f0106cd2 <strchr>
f0100d5f:	83 c4 10             	add    $0x10,%esp
f0100d62:	85 c0                	test   %eax,%eax
f0100d64:	0f 85 71 ff ff ff    	jne    f0100cdb <monitor+0x5f>
			buf++;
f0100d6a:	83 c3 01             	add    $0x1,%ebx
f0100d6d:	eb d8                	jmp    f0100d47 <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d6f:	83 ec 08             	sub    $0x8,%esp
f0100d72:	6a 10                	push   $0x10
f0100d74:	68 2f 88 10 f0       	push   $0xf010882f
f0100d79:	e8 83 38 00 00       	call   f0104601 <cprintf>
f0100d7e:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100d81:	83 ec 0c             	sub    $0xc,%esp
f0100d84:	68 26 88 10 f0       	push   $0xf0108826
f0100d89:	e8 14 5d 00 00       	call   f0106aa2 <readline>
f0100d8e:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100d90:	83 c4 10             	add    $0x10,%esp
f0100d93:	85 c0                	test   %eax,%eax
f0100d95:	74 ea                	je     f0100d81 <monitor+0x105>
	argv[argc] = 0;
f0100d97:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100d9e:	be 00 00 00 00       	mov    $0x0,%esi
f0100da3:	e9 35 ff ff ff       	jmp    f0100cdd <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100da8:	83 ec 04             	sub    $0x4,%esp
f0100dab:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100dae:	ff 75 08             	pushl  0x8(%ebp)
f0100db1:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100db4:	52                   	push   %edx
f0100db5:	56                   	push   %esi
f0100db6:	ff 14 85 a8 8b 10 f0 	call   *-0xfef7458(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100dbd:	83 c4 10             	add    $0x10,%esp
f0100dc0:	85 c0                	test   %eax,%eax
f0100dc2:	79 bd                	jns    f0100d81 <monitor+0x105>
}
f0100dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100dc7:	5b                   	pop    %ebx
f0100dc8:	5e                   	pop    %esi
f0100dc9:	5f                   	pop    %edi
f0100dca:	5d                   	pop    %ebp
f0100dcb:	c3                   	ret    

f0100dcc <currentcycles>:
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100dcc:	0f 31                	rdtsc  
    return result;
}
f0100dce:	c3                   	ret    

f0100dcf <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100dcf:	55                   	push   %ebp
f0100dd0:	89 e5                	mov    %esp,%ebp
f0100dd2:	56                   	push   %esi
f0100dd3:	53                   	push   %ebx
f0100dd4:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100dd6:	83 ec 0c             	sub    $0xc,%esp
f0100dd9:	50                   	push   %eax
f0100dda:	e8 7b 36 00 00       	call   f010445a <mc146818_read>
f0100ddf:	89 c3                	mov    %eax,%ebx
f0100de1:	83 c6 01             	add    $0x1,%esi
f0100de4:	89 34 24             	mov    %esi,(%esp)
f0100de7:	e8 6e 36 00 00       	call   f010445a <mc146818_read>
f0100dec:	c1 e0 08             	shl    $0x8,%eax
f0100def:	09 d8                	or     %ebx,%eax
}
f0100df1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100df4:	5b                   	pop    %ebx
f0100df5:	5e                   	pop    %esi
f0100df6:	5d                   	pop    %ebp
f0100df7:	c3                   	ret    

f0100df8 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100df8:	89 d1                	mov    %edx,%ecx
f0100dfa:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100dfd:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100e00:	a8 01                	test   $0x1,%al
f0100e02:	74 52                	je     f0100e56 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100e04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100e09:	89 c1                	mov    %eax,%ecx
f0100e0b:	c1 e9 0c             	shr    $0xc,%ecx
f0100e0e:	3b 0d 48 cd 5d f0    	cmp    0xf05dcd48,%ecx
f0100e14:	73 25                	jae    f0100e3b <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100e16:	c1 ea 0c             	shr    $0xc,%edx
f0100e19:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100e1f:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100e26:	89 c2                	mov    %eax,%edx
f0100e28:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100e2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e30:	85 d2                	test   %edx,%edx
f0100e32:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100e37:	0f 44 c2             	cmove  %edx,%eax
f0100e3a:	c3                   	ret    
{
f0100e3b:	55                   	push   %ebp
f0100e3c:	89 e5                	mov    %esp,%ebp
f0100e3e:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e41:	50                   	push   %eax
f0100e42:	68 34 84 10 f0       	push   $0xf0108434
f0100e47:	68 b1 03 00 00       	push   $0x3b1
f0100e4c:	68 e5 95 10 f0       	push   $0xf01095e5
f0100e51:	e8 f3 f1 ff ff       	call   f0100049 <_panic>
		return ~0;
f0100e56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100e5b:	c3                   	ret    

f0100e5c <boot_alloc>:
{
f0100e5c:	55                   	push   %ebp
f0100e5d:	89 e5                	mov    %esp,%ebp
f0100e5f:	53                   	push   %ebx
f0100e60:	83 ec 04             	sub    $0x4,%esp
	if (!nextfree) {
f0100e63:	83 3d f8 b8 5d f0 00 	cmpl   $0x0,0xf05db8f8
f0100e6a:	74 40                	je     f0100eac <boot_alloc+0x50>
	if(!n)
f0100e6c:	85 c0                	test   %eax,%eax
f0100e6e:	74 65                	je     f0100ed5 <boot_alloc+0x79>
f0100e70:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100e72:	a1 f8 b8 5d f0       	mov    0xf05db8f8,%eax
	if ((uint32_t)kva < KERNBASE)
f0100e77:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e7c:	76 5e                	jbe    f0100edc <boot_alloc+0x80>
f0100e7e:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100e85:	c1 e9 0c             	shr    $0xc,%ecx
f0100e88:	83 c1 01             	add    $0x1,%ecx
f0100e8b:	3b 0d 48 cd 5d f0    	cmp    0xf05dcd48,%ecx
f0100e91:	77 5b                	ja     f0100eee <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100e93:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e99:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e9f:	01 c2                	add    %eax,%edx
f0100ea1:	89 15 f8 b8 5d f0    	mov    %edx,0xf05db8f8
}
f0100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100eaa:	c9                   	leave  
f0100eab:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100eac:	b9 80 bb 6b f0       	mov    $0xf06bbb80,%ecx
f0100eb1:	ba 7f cb 6b f0       	mov    $0xf06bcb7f,%edx
f0100eb6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100ebc:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100ec2:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100ec8:	85 c9                	test   %ecx,%ecx
f0100eca:	0f 44 d3             	cmove  %ebx,%edx
f0100ecd:	89 15 f8 b8 5d f0    	mov    %edx,0xf05db8f8
f0100ed3:	eb 97                	jmp    f0100e6c <boot_alloc+0x10>
		return nextfree;
f0100ed5:	a1 f8 b8 5d f0       	mov    0xf05db8f8,%eax
f0100eda:	eb cb                	jmp    f0100ea7 <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100edc:	50                   	push   %eax
f0100edd:	68 58 84 10 f0       	push   $0xf0108458
f0100ee2:	6a 73                	push   $0x73
f0100ee4:	68 e5 95 10 f0       	push   $0xf01095e5
f0100ee9:	e8 5b f1 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100eee:	83 ec 04             	sub    $0x4,%esp
f0100ef1:	68 dc 8b 10 f0       	push   $0xf0108bdc
f0100ef6:	6a 74                	push   $0x74
f0100ef8:	68 e5 95 10 f0       	push   $0xf01095e5
f0100efd:	e8 47 f1 ff ff       	call   f0100049 <_panic>

f0100f02 <check_page_free_list>:
{
f0100f02:	55                   	push   %ebp
f0100f03:	89 e5                	mov    %esp,%ebp
f0100f05:	57                   	push   %edi
f0100f06:	56                   	push   %esi
f0100f07:	53                   	push   %ebx
f0100f08:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f0b:	84 c0                	test   %al,%al
f0100f0d:	0f 85 77 02 00 00    	jne    f010118a <check_page_free_list+0x288>
	if (!page_free_list)
f0100f13:	83 3d 00 b9 5d f0 00 	cmpl   $0x0,0xf05db900
f0100f1a:	74 0a                	je     f0100f26 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f1c:	be 00 04 00 00       	mov    $0x400,%esi
f0100f21:	e9 bf 02 00 00       	jmp    f01011e5 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100f26:	83 ec 04             	sub    $0x4,%esp
f0100f29:	68 14 8c 10 f0       	push   $0xf0108c14
f0100f2e:	68 e1 02 00 00       	push   $0x2e1
f0100f33:	68 e5 95 10 f0       	push   $0xf01095e5
f0100f38:	e8 0c f1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f3d:	50                   	push   %eax
f0100f3e:	68 34 84 10 f0       	push   $0xf0108434
f0100f43:	6a 58                	push   $0x58
f0100f45:	68 f1 95 10 f0       	push   $0xf01095f1
f0100f4a:	e8 fa f0 ff ff       	call   f0100049 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0100f4f:	8b 1b                	mov    (%ebx),%ebx
f0100f51:	85 db                	test   %ebx,%ebx
f0100f53:	74 41                	je     f0100f96 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100f55:	89 d8                	mov    %ebx,%eax
f0100f57:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0100f5d:	c1 f8 03             	sar    $0x3,%eax
f0100f60:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100f63:	89 c2                	mov    %eax,%edx
f0100f65:	c1 ea 16             	shr    $0x16,%edx
f0100f68:	39 f2                	cmp    %esi,%edx
f0100f6a:	73 e3                	jae    f0100f4f <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100f6c:	89 c2                	mov    %eax,%edx
f0100f6e:	c1 ea 0c             	shr    $0xc,%edx
f0100f71:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0100f77:	73 c4                	jae    f0100f3d <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100f79:	83 ec 04             	sub    $0x4,%esp
f0100f7c:	68 80 00 00 00       	push   $0x80
f0100f81:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100f86:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f8b:	50                   	push   %eax
f0100f8c:	e8 7e 5d 00 00       	call   f0106d0f <memset>
f0100f91:	83 c4 10             	add    $0x10,%esp
f0100f94:	eb b9                	jmp    f0100f4f <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100f96:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f9b:	e8 bc fe ff ff       	call   f0100e5c <boot_alloc>
f0100fa0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100fa3:	8b 15 00 b9 5d f0    	mov    0xf05db900,%edx
		assert(pp >= pages);
f0100fa9:	8b 0d 50 cd 5d f0    	mov    0xf05dcd50,%ecx
		assert(pp < pages + npages);
f0100faf:	a1 48 cd 5d f0       	mov    0xf05dcd48,%eax
f0100fb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100fb7:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100fba:	bf 00 00 00 00       	mov    $0x0,%edi
f0100fbf:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100fc2:	e9 f9 00 00 00       	jmp    f01010c0 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100fc7:	68 ff 95 10 f0       	push   $0xf01095ff
f0100fcc:	68 0b 96 10 f0       	push   $0xf010960b
f0100fd1:	68 fa 02 00 00       	push   $0x2fa
f0100fd6:	68 e5 95 10 f0       	push   $0xf01095e5
f0100fdb:	e8 69 f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0100fe0:	68 20 96 10 f0       	push   $0xf0109620
f0100fe5:	68 0b 96 10 f0       	push   $0xf010960b
f0100fea:	68 fb 02 00 00       	push   $0x2fb
f0100fef:	68 e5 95 10 f0       	push   $0xf01095e5
f0100ff4:	e8 50 f0 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100ff9:	68 38 8c 10 f0       	push   $0xf0108c38
f0100ffe:	68 0b 96 10 f0       	push   $0xf010960b
f0101003:	68 fc 02 00 00       	push   $0x2fc
f0101008:	68 e5 95 10 f0       	push   $0xf01095e5
f010100d:	e8 37 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0101012:	68 34 96 10 f0       	push   $0xf0109634
f0101017:	68 0b 96 10 f0       	push   $0xf010960b
f010101c:	68 ff 02 00 00       	push   $0x2ff
f0101021:	68 e5 95 10 f0       	push   $0xf01095e5
f0101026:	e8 1e f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f010102b:	68 45 96 10 f0       	push   $0xf0109645
f0101030:	68 0b 96 10 f0       	push   $0xf010960b
f0101035:	68 00 03 00 00       	push   $0x300
f010103a:	68 e5 95 10 f0       	push   $0xf01095e5
f010103f:	e8 05 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101044:	68 6c 8c 10 f0       	push   $0xf0108c6c
f0101049:	68 0b 96 10 f0       	push   $0xf010960b
f010104e:	68 01 03 00 00       	push   $0x301
f0101053:	68 e5 95 10 f0       	push   $0xf01095e5
f0101058:	e8 ec ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f010105d:	68 5e 96 10 f0       	push   $0xf010965e
f0101062:	68 0b 96 10 f0       	push   $0xf010960b
f0101067:	68 02 03 00 00       	push   $0x302
f010106c:	68 e5 95 10 f0       	push   $0xf01095e5
f0101071:	e8 d3 ef ff ff       	call   f0100049 <_panic>
	if (PGNUM(pa) >= npages)
f0101076:	89 c3                	mov    %eax,%ebx
f0101078:	c1 eb 0c             	shr    $0xc,%ebx
f010107b:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f010107e:	76 0f                	jbe    f010108f <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0101080:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101085:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0101088:	77 17                	ja     f01010a1 <check_page_free_list+0x19f>
			++nfree_extmem;
f010108a:	83 c7 01             	add    $0x1,%edi
f010108d:	eb 2f                	jmp    f01010be <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010108f:	50                   	push   %eax
f0101090:	68 34 84 10 f0       	push   $0xf0108434
f0101095:	6a 58                	push   $0x58
f0101097:	68 f1 95 10 f0       	push   $0xf01095f1
f010109c:	e8 a8 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01010a1:	68 90 8c 10 f0       	push   $0xf0108c90
f01010a6:	68 0b 96 10 f0       	push   $0xf010960b
f01010ab:	68 03 03 00 00       	push   $0x303
f01010b0:	68 e5 95 10 f0       	push   $0xf01095e5
f01010b5:	e8 8f ef ff ff       	call   f0100049 <_panic>
			++nfree_basemem;
f01010ba:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010be:	8b 12                	mov    (%edx),%edx
f01010c0:	85 d2                	test   %edx,%edx
f01010c2:	74 74                	je     f0101138 <check_page_free_list+0x236>
		assert(pp >= pages);
f01010c4:	39 d1                	cmp    %edx,%ecx
f01010c6:	0f 87 fb fe ff ff    	ja     f0100fc7 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f01010cc:	39 d6                	cmp    %edx,%esi
f01010ce:	0f 86 0c ff ff ff    	jbe    f0100fe0 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01010d4:	89 d0                	mov    %edx,%eax
f01010d6:	29 c8                	sub    %ecx,%eax
f01010d8:	a8 07                	test   $0x7,%al
f01010da:	0f 85 19 ff ff ff    	jne    f0100ff9 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f01010e0:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f01010e3:	c1 e0 0c             	shl    $0xc,%eax
f01010e6:	0f 84 26 ff ff ff    	je     f0101012 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f01010ec:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f01010f1:	0f 84 34 ff ff ff    	je     f010102b <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f01010f7:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01010fc:	0f 84 42 ff ff ff    	je     f0101044 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101102:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101107:	0f 84 50 ff ff ff    	je     f010105d <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f010110d:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101112:	0f 87 5e ff ff ff    	ja     f0101076 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101118:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010111d:	75 9b                	jne    f01010ba <check_page_free_list+0x1b8>
f010111f:	68 78 96 10 f0       	push   $0xf0109678
f0101124:	68 0b 96 10 f0       	push   $0xf010960b
f0101129:	68 05 03 00 00       	push   $0x305
f010112e:	68 e5 95 10 f0       	push   $0xf01095e5
f0101133:	e8 11 ef ff ff       	call   f0100049 <_panic>
f0101138:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f010113b:	85 db                	test   %ebx,%ebx
f010113d:	7e 19                	jle    f0101158 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f010113f:	85 ff                	test   %edi,%edi
f0101141:	7e 2e                	jle    f0101171 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0101143:	83 ec 0c             	sub    $0xc,%esp
f0101146:	68 d8 8c 10 f0       	push   $0xf0108cd8
f010114b:	e8 b1 34 00 00       	call   f0104601 <cprintf>
}
f0101150:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101153:	5b                   	pop    %ebx
f0101154:	5e                   	pop    %esi
f0101155:	5f                   	pop    %edi
f0101156:	5d                   	pop    %ebp
f0101157:	c3                   	ret    
	assert(nfree_basemem > 0);
f0101158:	68 95 96 10 f0       	push   $0xf0109695
f010115d:	68 0b 96 10 f0       	push   $0xf010960b
f0101162:	68 0c 03 00 00       	push   $0x30c
f0101167:	68 e5 95 10 f0       	push   $0xf01095e5
f010116c:	e8 d8 ee ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f0101171:	68 a7 96 10 f0       	push   $0xf01096a7
f0101176:	68 0b 96 10 f0       	push   $0xf010960b
f010117b:	68 0d 03 00 00       	push   $0x30d
f0101180:	68 e5 95 10 f0       	push   $0xf01095e5
f0101185:	e8 bf ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f010118a:	a1 00 b9 5d f0       	mov    0xf05db900,%eax
f010118f:	85 c0                	test   %eax,%eax
f0101191:	0f 84 8f fd ff ff    	je     f0100f26 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0101197:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010119a:	89 55 e0             	mov    %edx,-0x20(%ebp)
f010119d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01011a0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01011a3:	89 c2                	mov    %eax,%edx
f01011a5:	2b 15 50 cd 5d f0    	sub    0xf05dcd50,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f01011ab:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f01011b1:	0f 95 c2             	setne  %dl
f01011b4:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f01011b7:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f01011bb:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f01011bd:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f01011c1:	8b 00                	mov    (%eax),%eax
f01011c3:	85 c0                	test   %eax,%eax
f01011c5:	75 dc                	jne    f01011a3 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f01011c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01011ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f01011d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01011d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01011d6:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f01011d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01011db:	a3 00 b9 5d f0       	mov    %eax,0xf05db900
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01011e0:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f01011e5:	8b 1d 00 b9 5d f0    	mov    0xf05db900,%ebx
f01011eb:	e9 61 fd ff ff       	jmp    f0100f51 <check_page_free_list+0x4f>

f01011f0 <page_init>:
{
f01011f0:	55                   	push   %ebp
f01011f1:	89 e5                	mov    %esp,%ebp
f01011f3:	53                   	push   %ebx
f01011f4:	83 ec 04             	sub    $0x4,%esp
	for (size_t i = 0; i < npages; i++) {
f01011f7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01011fc:	eb 4c                	jmp    f010124a <page_init+0x5a>
		else if(i == MPENTRY_PADDR/PGSIZE){
f01011fe:	83 fb 07             	cmp    $0x7,%ebx
f0101201:	74 32                	je     f0101235 <page_init+0x45>
		else if(i < IOPHYSMEM/PGSIZE){ //[PGSIZE, npages_basemem * PGSIZE)
f0101203:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f0101209:	77 62                	ja     f010126d <page_init+0x7d>
f010120b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f0101212:	89 c2                	mov    %eax,%edx
f0101214:	03 15 50 cd 5d f0    	add    0xf05dcd50,%edx
f010121a:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101220:	8b 0d 00 b9 5d f0    	mov    0xf05db900,%ecx
f0101226:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f0101228:	03 05 50 cd 5d f0    	add    0xf05dcd50,%eax
f010122e:	a3 00 b9 5d f0       	mov    %eax,0xf05db900
f0101233:	eb 12                	jmp    f0101247 <page_init+0x57>
			pages[i].pp_ref = 1;
f0101235:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f010123a:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f0101240:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f0101247:	83 c3 01             	add    $0x1,%ebx
f010124a:	39 1d 48 cd 5d f0    	cmp    %ebx,0xf05dcd48
f0101250:	0f 86 94 00 00 00    	jbe    f01012ea <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f0101256:	85 db                	test   %ebx,%ebx
f0101258:	75 a4                	jne    f01011fe <page_init+0xe>
			pages[i].pp_ref = 1;
f010125a:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f010125f:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010126b:	eb da                	jmp    f0101247 <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f010126d:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0101273:	77 16                	ja     f010128b <page_init+0x9b>
			pages[i].pp_ref = 1;
f0101275:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f010127a:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
f010127d:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101289:	eb bc                	jmp    f0101247 <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f010128b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101290:	e8 c7 fb ff ff       	call   f0100e5c <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0101295:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010129a:	76 39                	jbe    f01012d5 <page_init+0xe5>
	return (physaddr_t)kva - KERNBASE;
f010129c:	05 00 00 00 10       	add    $0x10000000,%eax
f01012a1:	c1 e8 0c             	shr    $0xc,%eax
f01012a4:	39 d8                	cmp    %ebx,%eax
f01012a6:	77 cd                	ja     f0101275 <page_init+0x85>
f01012a8:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f01012af:	89 c2                	mov    %eax,%edx
f01012b1:	03 15 50 cd 5d f0    	add    0xf05dcd50,%edx
f01012b7:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f01012bd:	8b 0d 00 b9 5d f0    	mov    0xf05db900,%ecx
f01012c3:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f01012c5:	03 05 50 cd 5d f0    	add    0xf05dcd50,%eax
f01012cb:	a3 00 b9 5d f0       	mov    %eax,0xf05db900
f01012d0:	e9 72 ff ff ff       	jmp    f0101247 <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01012d5:	50                   	push   %eax
f01012d6:	68 58 84 10 f0       	push   $0xf0108458
f01012db:	68 50 01 00 00       	push   $0x150
f01012e0:	68 e5 95 10 f0       	push   $0xf01095e5
f01012e5:	e8 5f ed ff ff       	call   f0100049 <_panic>
}
f01012ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012ed:	c9                   	leave  
f01012ee:	c3                   	ret    

f01012ef <page_alloc>:
{
f01012ef:	55                   	push   %ebp
f01012f0:	89 e5                	mov    %esp,%ebp
f01012f2:	53                   	push   %ebx
f01012f3:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list)
f01012f6:	8b 1d 00 b9 5d f0    	mov    0xf05db900,%ebx
f01012fc:	85 db                	test   %ebx,%ebx
f01012fe:	74 13                	je     f0101313 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f0101300:	8b 03                	mov    (%ebx),%eax
f0101302:	a3 00 b9 5d f0       	mov    %eax,0xf05db900
	result->pp_link = NULL;
f0101307:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f010130d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101311:	75 07                	jne    f010131a <page_alloc+0x2b>
}
f0101313:	89 d8                	mov    %ebx,%eax
f0101315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101318:	c9                   	leave  
f0101319:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f010131a:	89 d8                	mov    %ebx,%eax
f010131c:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0101322:	c1 f8 03             	sar    $0x3,%eax
f0101325:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101328:	89 c2                	mov    %eax,%edx
f010132a:	c1 ea 0c             	shr    $0xc,%edx
f010132d:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0101333:	73 1a                	jae    f010134f <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f0101335:	83 ec 04             	sub    $0x4,%esp
f0101338:	68 00 10 00 00       	push   $0x1000
f010133d:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010133f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101344:	50                   	push   %eax
f0101345:	e8 c5 59 00 00       	call   f0106d0f <memset>
f010134a:	83 c4 10             	add    $0x10,%esp
f010134d:	eb c4                	jmp    f0101313 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010134f:	50                   	push   %eax
f0101350:	68 34 84 10 f0       	push   $0xf0108434
f0101355:	6a 58                	push   $0x58
f0101357:	68 f1 95 10 f0       	push   $0xf01095f1
f010135c:	e8 e8 ec ff ff       	call   f0100049 <_panic>

f0101361 <page_free>:
{
f0101361:	55                   	push   %ebp
f0101362:	89 e5                	mov    %esp,%ebp
f0101364:	83 ec 08             	sub    $0x8,%esp
f0101367:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0 || pp->pp_link != NULL){
f010136a:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010136f:	75 14                	jne    f0101385 <page_free+0x24>
f0101371:	83 38 00             	cmpl   $0x0,(%eax)
f0101374:	75 0f                	jne    f0101385 <page_free+0x24>
	pp->pp_link = page_free_list;
f0101376:	8b 15 00 b9 5d f0    	mov    0xf05db900,%edx
f010137c:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f010137e:	a3 00 b9 5d f0       	mov    %eax,0xf05db900
}
f0101383:	c9                   	leave  
f0101384:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f0101385:	83 ec 04             	sub    $0x4,%esp
f0101388:	68 fc 8c 10 f0       	push   $0xf0108cfc
f010138d:	68 84 01 00 00       	push   $0x184
f0101392:	68 e5 95 10 f0       	push   $0xf01095e5
f0101397:	e8 ad ec ff ff       	call   f0100049 <_panic>

f010139c <page_decref>:
{
f010139c:	55                   	push   %ebp
f010139d:	89 e5                	mov    %esp,%ebp
f010139f:	83 ec 08             	sub    $0x8,%esp
f01013a2:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01013a5:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01013a9:	83 e8 01             	sub    $0x1,%eax
f01013ac:	66 89 42 04          	mov    %ax,0x4(%edx)
f01013b0:	66 85 c0             	test   %ax,%ax
f01013b3:	74 02                	je     f01013b7 <page_decref+0x1b>
}
f01013b5:	c9                   	leave  
f01013b6:	c3                   	ret    
		page_free(pp);
f01013b7:	83 ec 0c             	sub    $0xc,%esp
f01013ba:	52                   	push   %edx
f01013bb:	e8 a1 ff ff ff       	call   f0101361 <page_free>
f01013c0:	83 c4 10             	add    $0x10,%esp
}
f01013c3:	eb f0                	jmp    f01013b5 <page_decref+0x19>

f01013c5 <pgdir_walk>:
{
f01013c5:	55                   	push   %ebp
f01013c6:	89 e5                	mov    %esp,%ebp
f01013c8:	56                   	push   %esi
f01013c9:	53                   	push   %ebx
f01013ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *fir_level = &pgdir[PDX(va)];
f01013cd:	89 f3                	mov    %esi,%ebx
f01013cf:	c1 eb 16             	shr    $0x16,%ebx
f01013d2:	c1 e3 02             	shl    $0x2,%ebx
f01013d5:	03 5d 08             	add    0x8(%ebp),%ebx
	if(*fir_level==0 && create == false){
f01013d8:	8b 03                	mov    (%ebx),%eax
f01013da:	89 c1                	mov    %eax,%ecx
f01013dc:	0b 4d 10             	or     0x10(%ebp),%ecx
f01013df:	0f 84 a8 00 00 00    	je     f010148d <pgdir_walk+0xc8>
	else if(*fir_level==0){
f01013e5:	85 c0                	test   %eax,%eax
f01013e7:	74 29                	je     f0101412 <pgdir_walk+0x4d>
		sec_level = (pte_t *)(KADDR(PTE_ADDR(*fir_level)));
f01013e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01013ee:	89 c2                	mov    %eax,%edx
f01013f0:	c1 ea 0c             	shr    $0xc,%edx
f01013f3:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f01013f9:	73 7d                	jae    f0101478 <pgdir_walk+0xb3>
		return &sec_level[PTX(va)];
f01013fb:	c1 ee 0a             	shr    $0xa,%esi
f01013fe:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101404:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f010140b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010140e:	5b                   	pop    %ebx
f010140f:	5e                   	pop    %esi
f0101410:	5d                   	pop    %ebp
f0101411:	c3                   	ret    
		struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
f0101412:	83 ec 0c             	sub    $0xc,%esp
f0101415:	6a 01                	push   $0x1
f0101417:	e8 d3 fe ff ff       	call   f01012ef <page_alloc>
		if(new_page == NULL)
f010141c:	83 c4 10             	add    $0x10,%esp
f010141f:	85 c0                	test   %eax,%eax
f0101421:	74 e8                	je     f010140b <pgdir_walk+0x46>
		new_page->pp_ref++;
f0101423:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101428:	89 c2                	mov    %eax,%edx
f010142a:	2b 15 50 cd 5d f0    	sub    0xf05dcd50,%edx
f0101430:	c1 fa 03             	sar    $0x3,%edx
f0101433:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f0101436:	83 ca 07             	or     $0x7,%edx
f0101439:	89 13                	mov    %edx,(%ebx)
f010143b:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0101441:	c1 f8 03             	sar    $0x3,%eax
f0101444:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101447:	89 c2                	mov    %eax,%edx
f0101449:	c1 ea 0c             	shr    $0xc,%edx
f010144c:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0101452:	73 12                	jae    f0101466 <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f0101454:	c1 ee 0a             	shr    $0xa,%esi
f0101457:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f010145d:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0101464:	eb a5                	jmp    f010140b <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101466:	50                   	push   %eax
f0101467:	68 34 84 10 f0       	push   $0xf0108434
f010146c:	6a 58                	push   $0x58
f010146e:	68 f1 95 10 f0       	push   $0xf01095f1
f0101473:	e8 d1 eb ff ff       	call   f0100049 <_panic>
f0101478:	50                   	push   %eax
f0101479:	68 34 84 10 f0       	push   $0xf0108434
f010147e:	68 be 01 00 00       	push   $0x1be
f0101483:	68 e5 95 10 f0       	push   $0xf01095e5
f0101488:	e8 bc eb ff ff       	call   f0100049 <_panic>
		return NULL;
f010148d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101492:	e9 74 ff ff ff       	jmp    f010140b <pgdir_walk+0x46>

f0101497 <boot_map_region>:
{
f0101497:	55                   	push   %ebp
f0101498:	89 e5                	mov    %esp,%ebp
f010149a:	57                   	push   %edi
f010149b:	56                   	push   %esi
f010149c:	53                   	push   %ebx
f010149d:	83 ec 1c             	sub    $0x1c,%esp
f01014a0:	89 c7                	mov    %eax,%edi
f01014a2:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(va%PGSIZE==0);
f01014a5:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01014ab:	75 4b                	jne    f01014f8 <boot_map_region+0x61>
	assert(pa%PGSIZE==0);
f01014ad:	a9 ff 0f 00 00       	test   $0xfff,%eax
f01014b2:	75 5d                	jne    f0101511 <boot_map_region+0x7a>
f01014b4:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01014ba:	01 c1                	add    %eax,%ecx
f01014bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f01014bf:	89 c3                	mov    %eax,%ebx
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f01014c1:	89 d6                	mov    %edx,%esi
f01014c3:	29 c6                	sub    %eax,%esi
	for(int i = 0; i < size/PGSIZE; i++){
f01014c5:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01014c8:	74 79                	je     f0101543 <boot_map_region+0xac>
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f01014ca:	83 ec 04             	sub    $0x4,%esp
f01014cd:	6a 01                	push   $0x1
f01014cf:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01014d2:	50                   	push   %eax
f01014d3:	57                   	push   %edi
f01014d4:	e8 ec fe ff ff       	call   f01013c5 <pgdir_walk>
		if(the_pte==NULL)
f01014d9:	83 c4 10             	add    $0x10,%esp
f01014dc:	85 c0                	test   %eax,%eax
f01014de:	74 4a                	je     f010152a <boot_map_region+0x93>
		*the_pte = PTE_ADDR(pa) | perm | PTE_P;
f01014e0:	89 da                	mov    %ebx,%edx
f01014e2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01014e8:	0b 55 0c             	or     0xc(%ebp),%edx
f01014eb:	83 ca 01             	or     $0x1,%edx
f01014ee:	89 10                	mov    %edx,(%eax)
		pa+=PGSIZE;
f01014f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01014f6:	eb cd                	jmp    f01014c5 <boot_map_region+0x2e>
	assert(va%PGSIZE==0);
f01014f8:	68 b8 96 10 f0       	push   $0xf01096b8
f01014fd:	68 0b 96 10 f0       	push   $0xf010960b
f0101502:	68 d3 01 00 00       	push   $0x1d3
f0101507:	68 e5 95 10 f0       	push   $0xf01095e5
f010150c:	e8 38 eb ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f0101511:	68 c5 96 10 f0       	push   $0xf01096c5
f0101516:	68 0b 96 10 f0       	push   $0xf010960b
f010151b:	68 d4 01 00 00       	push   $0x1d4
f0101520:	68 e5 95 10 f0       	push   $0xf01095e5
f0101525:	e8 1f eb ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f010152a:	68 88 99 10 f0       	push   $0xf0109988
f010152f:	68 d2 96 10 f0       	push   $0xf01096d2
f0101534:	68 d8 01 00 00       	push   $0x1d8
f0101539:	68 e5 95 10 f0       	push   $0xf01095e5
f010153e:	e8 06 eb ff ff       	call   f0100049 <_panic>
}
f0101543:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101546:	5b                   	pop    %ebx
f0101547:	5e                   	pop    %esi
f0101548:	5f                   	pop    %edi
f0101549:	5d                   	pop    %ebp
f010154a:	c3                   	ret    

f010154b <page_lookup>:
{
f010154b:	55                   	push   %ebp
f010154c:	89 e5                	mov    %esp,%ebp
f010154e:	53                   	push   %ebx
f010154f:	83 ec 08             	sub    $0x8,%esp
f0101552:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *look_mapping = pgdir_walk(pgdir, va, 0);
f0101555:	6a 00                	push   $0x0
f0101557:	ff 75 0c             	pushl  0xc(%ebp)
f010155a:	ff 75 08             	pushl  0x8(%ebp)
f010155d:	e8 63 fe ff ff       	call   f01013c5 <pgdir_walk>
	if(look_mapping == NULL)
f0101562:	83 c4 10             	add    $0x10,%esp
f0101565:	85 c0                	test   %eax,%eax
f0101567:	74 27                	je     f0101590 <page_lookup+0x45>
	if(*look_mapping==0)
f0101569:	8b 10                	mov    (%eax),%edx
f010156b:	85 d2                	test   %edx,%edx
f010156d:	74 3a                	je     f01015a9 <page_lookup+0x5e>
	if(pte_store!=NULL && (*look_mapping&PTE_P))
f010156f:	85 db                	test   %ebx,%ebx
f0101571:	74 07                	je     f010157a <page_lookup+0x2f>
f0101573:	f6 c2 01             	test   $0x1,%dl
f0101576:	74 02                	je     f010157a <page_lookup+0x2f>
		*pte_store = look_mapping;
f0101578:	89 03                	mov    %eax,(%ebx)
f010157a:	8b 00                	mov    (%eax),%eax
f010157c:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010157f:	39 05 48 cd 5d f0    	cmp    %eax,0xf05dcd48
f0101585:	76 0e                	jbe    f0101595 <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101587:	8b 15 50 cd 5d f0    	mov    0xf05dcd50,%edx
f010158d:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101593:	c9                   	leave  
f0101594:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101595:	83 ec 04             	sub    $0x4,%esp
f0101598:	68 30 8d 10 f0       	push   $0xf0108d30
f010159d:	6a 51                	push   $0x51
f010159f:	68 f1 95 10 f0       	push   $0xf01095f1
f01015a4:	e8 a0 ea ff ff       	call   f0100049 <_panic>
		return NULL;
f01015a9:	b8 00 00 00 00       	mov    $0x0,%eax
f01015ae:	eb e0                	jmp    f0101590 <page_lookup+0x45>

f01015b0 <tlb_invalidate>:
{
f01015b0:	55                   	push   %ebp
f01015b1:	89 e5                	mov    %esp,%ebp
f01015b3:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01015b6:	e8 5b 5d 00 00       	call   f0107316 <cpunum>
f01015bb:	6b c0 74             	imul   $0x74,%eax,%eax
f01015be:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f01015c5:	74 16                	je     f01015dd <tlb_invalidate+0x2d>
f01015c7:	e8 4a 5d 00 00       	call   f0107316 <cpunum>
f01015cc:	6b c0 74             	imul   $0x74,%eax,%eax
f01015cf:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01015d5:	8b 55 08             	mov    0x8(%ebp),%edx
f01015d8:	39 50 60             	cmp    %edx,0x60(%eax)
f01015db:	75 06                	jne    f01015e3 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01015dd:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015e0:	0f 01 38             	invlpg (%eax)
}
f01015e3:	c9                   	leave  
f01015e4:	c3                   	ret    

f01015e5 <page_remove>:
{
f01015e5:	55                   	push   %ebp
f01015e6:	89 e5                	mov    %esp,%ebp
f01015e8:	56                   	push   %esi
f01015e9:	53                   	push   %ebx
f01015ea:	83 ec 14             	sub    $0x14,%esp
f01015ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01015f0:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *the_page = page_lookup(pgdir, va, &pg_store);
f01015f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01015f6:	50                   	push   %eax
f01015f7:	56                   	push   %esi
f01015f8:	53                   	push   %ebx
f01015f9:	e8 4d ff ff ff       	call   f010154b <page_lookup>
	if(!the_page)
f01015fe:	83 c4 10             	add    $0x10,%esp
f0101601:	85 c0                	test   %eax,%eax
f0101603:	74 1f                	je     f0101624 <page_remove+0x3f>
	page_decref(the_page);
f0101605:	83 ec 0c             	sub    $0xc,%esp
f0101608:	50                   	push   %eax
f0101609:	e8 8e fd ff ff       	call   f010139c <page_decref>
	*pg_store = 0;
f010160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f0101617:	83 c4 08             	add    $0x8,%esp
f010161a:	56                   	push   %esi
f010161b:	53                   	push   %ebx
f010161c:	e8 8f ff ff ff       	call   f01015b0 <tlb_invalidate>
f0101621:	83 c4 10             	add    $0x10,%esp
}
f0101624:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101627:	5b                   	pop    %ebx
f0101628:	5e                   	pop    %esi
f0101629:	5d                   	pop    %ebp
f010162a:	c3                   	ret    

f010162b <page_insert>:
{
f010162b:	55                   	push   %ebp
f010162c:	89 e5                	mov    %esp,%ebp
f010162e:	57                   	push   %edi
f010162f:	56                   	push   %esi
f0101630:	53                   	push   %ebx
f0101631:	83 ec 10             	sub    $0x10,%esp
f0101634:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *the_pte = pgdir_walk(pgdir, va, 1);
f0101637:	6a 01                	push   $0x1
f0101639:	ff 75 10             	pushl  0x10(%ebp)
f010163c:	ff 75 08             	pushl  0x8(%ebp)
f010163f:	e8 81 fd ff ff       	call   f01013c5 <pgdir_walk>
	if(the_pte == NULL){
f0101644:	83 c4 10             	add    $0x10,%esp
f0101647:	85 c0                	test   %eax,%eax
f0101649:	0f 84 b7 00 00 00    	je     f0101706 <page_insert+0xdb>
f010164f:	89 c6                	mov    %eax,%esi
		if(KADDR(PTE_ADDR(*the_pte)) == page2kva(pp)){
f0101651:	8b 10                	mov    (%eax),%edx
f0101653:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101659:	8b 0d 48 cd 5d f0    	mov    0xf05dcd48,%ecx
f010165f:	89 d0                	mov    %edx,%eax
f0101661:	c1 e8 0c             	shr    $0xc,%eax
f0101664:	39 c1                	cmp    %eax,%ecx
f0101666:	76 5f                	jbe    f01016c7 <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f0101668:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f010166e:	89 d8                	mov    %ebx,%eax
f0101670:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0101676:	c1 f8 03             	sar    $0x3,%eax
f0101679:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010167c:	89 c7                	mov    %eax,%edi
f010167e:	c1 ef 0c             	shr    $0xc,%edi
f0101681:	39 f9                	cmp    %edi,%ecx
f0101683:	76 57                	jbe    f01016dc <page_insert+0xb1>
	return (void *)(pa + KERNBASE);
f0101685:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010168a:	39 c2                	cmp    %eax,%edx
f010168c:	74 60                	je     f01016ee <page_insert+0xc3>
			page_remove(pgdir, va);
f010168e:	83 ec 08             	sub    $0x8,%esp
f0101691:	ff 75 10             	pushl  0x10(%ebp)
f0101694:	ff 75 08             	pushl  0x8(%ebp)
f0101697:	e8 49 ff ff ff       	call   f01015e5 <page_remove>
f010169c:	83 c4 10             	add    $0x10,%esp
	return (pp - pages) << PGSHIFT;
f010169f:	89 d8                	mov    %ebx,%eax
f01016a1:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f01016a7:	c1 f8 03             	sar    $0x3,%eax
f01016aa:	c1 e0 0c             	shl    $0xc,%eax
	*the_pte = page2pa(pp) | perm | PTE_P;
f01016ad:	0b 45 14             	or     0x14(%ebp),%eax
f01016b0:	83 c8 01             	or     $0x1,%eax
f01016b3:	89 06                	mov    %eax,(%esi)
	pp->pp_ref++;
f01016b5:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	return 0;
f01016ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01016bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01016c2:	5b                   	pop    %ebx
f01016c3:	5e                   	pop    %esi
f01016c4:	5f                   	pop    %edi
f01016c5:	5d                   	pop    %ebp
f01016c6:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01016c7:	52                   	push   %edx
f01016c8:	68 34 84 10 f0       	push   $0xf0108434
f01016cd:	68 1a 02 00 00       	push   $0x21a
f01016d2:	68 e5 95 10 f0       	push   $0xf01095e5
f01016d7:	e8 6d e9 ff ff       	call   f0100049 <_panic>
f01016dc:	50                   	push   %eax
f01016dd:	68 34 84 10 f0       	push   $0xf0108434
f01016e2:	6a 58                	push   $0x58
f01016e4:	68 f1 95 10 f0       	push   $0xf01095f1
f01016e9:	e8 5b e9 ff ff       	call   f0100049 <_panic>
			tlb_invalidate(pgdir, va);
f01016ee:	83 ec 08             	sub    $0x8,%esp
f01016f1:	ff 75 10             	pushl  0x10(%ebp)
f01016f4:	ff 75 08             	pushl  0x8(%ebp)
f01016f7:	e8 b4 fe ff ff       	call   f01015b0 <tlb_invalidate>
			pp->pp_ref--;
f01016fc:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
f0101701:	83 c4 10             	add    $0x10,%esp
f0101704:	eb 99                	jmp    f010169f <page_insert+0x74>
		return -E_NO_MEM;
f0101706:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010170b:	eb b2                	jmp    f01016bf <page_insert+0x94>

f010170d <mmio_map_region>:
{
f010170d:	55                   	push   %ebp
f010170e:	89 e5                	mov    %esp,%ebp
f0101710:	56                   	push   %esi
f0101711:	53                   	push   %ebx
	size = ROUNDUP(size, PGSIZE);
f0101712:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101715:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f010171b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((base + size) > MMIOLIM){
f0101721:	8b 35 04 d3 16 f0    	mov    0xf016d304,%esi
f0101727:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f010172a:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f010172f:	77 25                	ja     f0101756 <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101731:	83 ec 08             	sub    $0x8,%esp
f0101734:	6a 1a                	push   $0x1a
f0101736:	ff 75 08             	pushl  0x8(%ebp)
f0101739:	89 d9                	mov    %ebx,%ecx
f010173b:	89 f2                	mov    %esi,%edx
f010173d:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0101742:	e8 50 fd ff ff       	call   f0101497 <boot_map_region>
	base += size;
f0101747:	01 1d 04 d3 16 f0    	add    %ebx,0xf016d304
}
f010174d:	89 f0                	mov    %esi,%eax
f010174f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101752:	5b                   	pop    %ebx
f0101753:	5e                   	pop    %esi
f0101754:	5d                   	pop    %ebp
f0101755:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f0101756:	83 ec 04             	sub    $0x4,%esp
f0101759:	68 dc 96 10 f0       	push   $0xf01096dc
f010175e:	68 8b 02 00 00       	push   $0x28b
f0101763:	68 e5 95 10 f0       	push   $0xf01095e5
f0101768:	e8 dc e8 ff ff       	call   f0100049 <_panic>

f010176d <mem_init>:
{
f010176d:	55                   	push   %ebp
f010176e:	89 e5                	mov    %esp,%ebp
f0101770:	57                   	push   %edi
f0101771:	56                   	push   %esi
f0101772:	53                   	push   %ebx
f0101773:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f0101776:	b8 15 00 00 00       	mov    $0x15,%eax
f010177b:	e8 4f f6 ff ff       	call   f0100dcf <nvram_read>
f0101780:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101782:	b8 17 00 00 00       	mov    $0x17,%eax
f0101787:	e8 43 f6 ff ff       	call   f0100dcf <nvram_read>
f010178c:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f010178e:	b8 34 00 00 00       	mov    $0x34,%eax
f0101793:	e8 37 f6 ff ff       	call   f0100dcf <nvram_read>
	if (ext16mem)
f0101798:	c1 e0 06             	shl    $0x6,%eax
f010179b:	0f 84 e5 00 00 00    	je     f0101886 <mem_init+0x119>
		totalmem = 16 * 1024 + ext16mem;
f01017a1:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01017a6:	89 c2                	mov    %eax,%edx
f01017a8:	c1 ea 02             	shr    $0x2,%edx
f01017ab:	89 15 48 cd 5d f0    	mov    %edx,0xf05dcd48
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01017b1:	89 c2                	mov    %eax,%edx
f01017b3:	29 da                	sub    %ebx,%edx
f01017b5:	52                   	push   %edx
f01017b6:	53                   	push   %ebx
f01017b7:	50                   	push   %eax
f01017b8:	68 50 8d 10 f0       	push   $0xf0108d50
f01017bd:	e8 3f 2e 00 00       	call   f0104601 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01017c2:	b8 00 10 00 00       	mov    $0x1000,%eax
f01017c7:	e8 90 f6 ff ff       	call   f0100e5c <boot_alloc>
f01017cc:	a3 4c cd 5d f0       	mov    %eax,0xf05dcd4c
	memset(kern_pgdir, 0, PGSIZE);
f01017d1:	83 c4 0c             	add    $0xc,%esp
f01017d4:	68 00 10 00 00       	push   $0x1000
f01017d9:	6a 00                	push   $0x0
f01017db:	50                   	push   %eax
f01017dc:	e8 2e 55 00 00       	call   f0106d0f <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01017e1:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
	if ((uint32_t)kva < KERNBASE)
f01017e6:	83 c4 10             	add    $0x10,%esp
f01017e9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017ee:	0f 86 a2 00 00 00    	jbe    f0101896 <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f01017f4:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017fa:	83 ca 05             	or     $0x5,%edx
f01017fd:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f0101803:	a1 48 cd 5d f0       	mov    0xf05dcd48,%eax
f0101808:	c1 e0 03             	shl    $0x3,%eax
f010180b:	e8 4c f6 ff ff       	call   f0100e5c <boot_alloc>
f0101810:	a3 50 cd 5d f0       	mov    %eax,0xf05dcd50
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f0101815:	83 ec 04             	sub    $0x4,%esp
f0101818:	8b 15 48 cd 5d f0    	mov    0xf05dcd48,%edx
f010181e:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0101825:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010182b:	52                   	push   %edx
f010182c:	6a 00                	push   $0x0
f010182e:	50                   	push   %eax
f010182f:	e8 db 54 00 00       	call   f0106d0f <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101834:	b8 00 10 02 00       	mov    $0x21000,%eax
f0101839:	e8 1e f6 ff ff       	call   f0100e5c <boot_alloc>
f010183e:	a3 68 a0 12 f0       	mov    %eax,0xf012a068
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101843:	83 c4 0c             	add    $0xc,%esp
f0101846:	68 00 10 02 00       	push   $0x21000
f010184b:	6a 00                	push   $0x0
f010184d:	50                   	push   %eax
f010184e:	e8 bc 54 00 00       	call   f0106d0f <memset>
	page_init();
f0101853:	e8 98 f9 ff ff       	call   f01011f0 <page_init>
	check_page_free_list(1);
f0101858:	b8 01 00 00 00       	mov    $0x1,%eax
f010185d:	e8 a0 f6 ff ff       	call   f0100f02 <check_page_free_list>
	if (!pages)
f0101862:	83 c4 10             	add    $0x10,%esp
f0101865:	83 3d 50 cd 5d f0 00 	cmpl   $0x0,0xf05dcd50
f010186c:	74 3d                	je     f01018ab <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010186e:	a1 00 b9 5d f0       	mov    0xf05db900,%eax
f0101873:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010187a:	85 c0                	test   %eax,%eax
f010187c:	74 44                	je     f01018c2 <mem_init+0x155>
		++nfree;
f010187e:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101882:	8b 00                	mov    (%eax),%eax
f0101884:	eb f4                	jmp    f010187a <mem_init+0x10d>
		totalmem = 1 * 1024 + extmem;
f0101886:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010188c:	85 f6                	test   %esi,%esi
f010188e:	0f 44 c3             	cmove  %ebx,%eax
f0101891:	e9 10 ff ff ff       	jmp    f01017a6 <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101896:	50                   	push   %eax
f0101897:	68 58 84 10 f0       	push   $0xf0108458
f010189c:	68 9b 00 00 00       	push   $0x9b
f01018a1:	68 e5 95 10 f0       	push   $0xf01095e5
f01018a6:	e8 9e e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f01018ab:	83 ec 04             	sub    $0x4,%esp
f01018ae:	68 ee 96 10 f0       	push   $0xf01096ee
f01018b3:	68 20 03 00 00       	push   $0x320
f01018b8:	68 e5 95 10 f0       	push   $0xf01095e5
f01018bd:	e8 87 e7 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f01018c2:	83 ec 0c             	sub    $0xc,%esp
f01018c5:	6a 00                	push   $0x0
f01018c7:	e8 23 fa ff ff       	call   f01012ef <page_alloc>
f01018cc:	89 c3                	mov    %eax,%ebx
f01018ce:	83 c4 10             	add    $0x10,%esp
f01018d1:	85 c0                	test   %eax,%eax
f01018d3:	0f 84 00 02 00 00    	je     f0101ad9 <mem_init+0x36c>
	assert((pp1 = page_alloc(0)));
f01018d9:	83 ec 0c             	sub    $0xc,%esp
f01018dc:	6a 00                	push   $0x0
f01018de:	e8 0c fa ff ff       	call   f01012ef <page_alloc>
f01018e3:	89 c6                	mov    %eax,%esi
f01018e5:	83 c4 10             	add    $0x10,%esp
f01018e8:	85 c0                	test   %eax,%eax
f01018ea:	0f 84 02 02 00 00    	je     f0101af2 <mem_init+0x385>
	assert((pp2 = page_alloc(0)));
f01018f0:	83 ec 0c             	sub    $0xc,%esp
f01018f3:	6a 00                	push   $0x0
f01018f5:	e8 f5 f9 ff ff       	call   f01012ef <page_alloc>
f01018fa:	89 c7                	mov    %eax,%edi
f01018fc:	83 c4 10             	add    $0x10,%esp
f01018ff:	85 c0                	test   %eax,%eax
f0101901:	0f 84 04 02 00 00    	je     f0101b0b <mem_init+0x39e>
	assert(pp1 && pp1 != pp0);
f0101907:	39 f3                	cmp    %esi,%ebx
f0101909:	0f 84 15 02 00 00    	je     f0101b24 <mem_init+0x3b7>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010190f:	39 c3                	cmp    %eax,%ebx
f0101911:	0f 84 26 02 00 00    	je     f0101b3d <mem_init+0x3d0>
f0101917:	39 c6                	cmp    %eax,%esi
f0101919:	0f 84 1e 02 00 00    	je     f0101b3d <mem_init+0x3d0>
	return (pp - pages) << PGSHIFT;
f010191f:	8b 0d 50 cd 5d f0    	mov    0xf05dcd50,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101925:	8b 15 48 cd 5d f0    	mov    0xf05dcd48,%edx
f010192b:	c1 e2 0c             	shl    $0xc,%edx
f010192e:	89 d8                	mov    %ebx,%eax
f0101930:	29 c8                	sub    %ecx,%eax
f0101932:	c1 f8 03             	sar    $0x3,%eax
f0101935:	c1 e0 0c             	shl    $0xc,%eax
f0101938:	39 d0                	cmp    %edx,%eax
f010193a:	0f 83 16 02 00 00    	jae    f0101b56 <mem_init+0x3e9>
f0101940:	89 f0                	mov    %esi,%eax
f0101942:	29 c8                	sub    %ecx,%eax
f0101944:	c1 f8 03             	sar    $0x3,%eax
f0101947:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f010194a:	39 c2                	cmp    %eax,%edx
f010194c:	0f 86 1d 02 00 00    	jbe    f0101b6f <mem_init+0x402>
f0101952:	89 f8                	mov    %edi,%eax
f0101954:	29 c8                	sub    %ecx,%eax
f0101956:	c1 f8 03             	sar    $0x3,%eax
f0101959:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f010195c:	39 c2                	cmp    %eax,%edx
f010195e:	0f 86 24 02 00 00    	jbe    f0101b88 <mem_init+0x41b>
	fl = page_free_list;
f0101964:	a1 00 b9 5d f0       	mov    0xf05db900,%eax
f0101969:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f010196c:	c7 05 00 b9 5d f0 00 	movl   $0x0,0xf05db900
f0101973:	00 00 00 
	assert(!page_alloc(0));
f0101976:	83 ec 0c             	sub    $0xc,%esp
f0101979:	6a 00                	push   $0x0
f010197b:	e8 6f f9 ff ff       	call   f01012ef <page_alloc>
f0101980:	83 c4 10             	add    $0x10,%esp
f0101983:	85 c0                	test   %eax,%eax
f0101985:	0f 85 16 02 00 00    	jne    f0101ba1 <mem_init+0x434>
	page_free(pp0);
f010198b:	83 ec 0c             	sub    $0xc,%esp
f010198e:	53                   	push   %ebx
f010198f:	e8 cd f9 ff ff       	call   f0101361 <page_free>
	page_free(pp1);
f0101994:	89 34 24             	mov    %esi,(%esp)
f0101997:	e8 c5 f9 ff ff       	call   f0101361 <page_free>
	page_free(pp2);
f010199c:	89 3c 24             	mov    %edi,(%esp)
f010199f:	e8 bd f9 ff ff       	call   f0101361 <page_free>
	assert((pp0 = page_alloc(0)));
f01019a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01019ab:	e8 3f f9 ff ff       	call   f01012ef <page_alloc>
f01019b0:	89 c3                	mov    %eax,%ebx
f01019b2:	83 c4 10             	add    $0x10,%esp
f01019b5:	85 c0                	test   %eax,%eax
f01019b7:	0f 84 fd 01 00 00    	je     f0101bba <mem_init+0x44d>
	assert((pp1 = page_alloc(0)));
f01019bd:	83 ec 0c             	sub    $0xc,%esp
f01019c0:	6a 00                	push   $0x0
f01019c2:	e8 28 f9 ff ff       	call   f01012ef <page_alloc>
f01019c7:	89 c6                	mov    %eax,%esi
f01019c9:	83 c4 10             	add    $0x10,%esp
f01019cc:	85 c0                	test   %eax,%eax
f01019ce:	0f 84 ff 01 00 00    	je     f0101bd3 <mem_init+0x466>
	assert((pp2 = page_alloc(0)));
f01019d4:	83 ec 0c             	sub    $0xc,%esp
f01019d7:	6a 00                	push   $0x0
f01019d9:	e8 11 f9 ff ff       	call   f01012ef <page_alloc>
f01019de:	89 c7                	mov    %eax,%edi
f01019e0:	83 c4 10             	add    $0x10,%esp
f01019e3:	85 c0                	test   %eax,%eax
f01019e5:	0f 84 01 02 00 00    	je     f0101bec <mem_init+0x47f>
	assert(pp1 && pp1 != pp0);
f01019eb:	39 f3                	cmp    %esi,%ebx
f01019ed:	0f 84 12 02 00 00    	je     f0101c05 <mem_init+0x498>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019f3:	39 c6                	cmp    %eax,%esi
f01019f5:	0f 84 23 02 00 00    	je     f0101c1e <mem_init+0x4b1>
f01019fb:	39 c3                	cmp    %eax,%ebx
f01019fd:	0f 84 1b 02 00 00    	je     f0101c1e <mem_init+0x4b1>
	assert(!page_alloc(0));
f0101a03:	83 ec 0c             	sub    $0xc,%esp
f0101a06:	6a 00                	push   $0x0
f0101a08:	e8 e2 f8 ff ff       	call   f01012ef <page_alloc>
f0101a0d:	83 c4 10             	add    $0x10,%esp
f0101a10:	85 c0                	test   %eax,%eax
f0101a12:	0f 85 1f 02 00 00    	jne    f0101c37 <mem_init+0x4ca>
f0101a18:	89 d8                	mov    %ebx,%eax
f0101a1a:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0101a20:	c1 f8 03             	sar    $0x3,%eax
f0101a23:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a26:	89 c2                	mov    %eax,%edx
f0101a28:	c1 ea 0c             	shr    $0xc,%edx
f0101a2b:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0101a31:	0f 83 19 02 00 00    	jae    f0101c50 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a37:	83 ec 04             	sub    $0x4,%esp
f0101a3a:	68 00 10 00 00       	push   $0x1000
f0101a3f:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101a41:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a46:	50                   	push   %eax
f0101a47:	e8 c3 52 00 00       	call   f0106d0f <memset>
	page_free(pp0);
f0101a4c:	89 1c 24             	mov    %ebx,(%esp)
f0101a4f:	e8 0d f9 ff ff       	call   f0101361 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101a54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101a5b:	e8 8f f8 ff ff       	call   f01012ef <page_alloc>
f0101a60:	83 c4 10             	add    $0x10,%esp
f0101a63:	85 c0                	test   %eax,%eax
f0101a65:	0f 84 f7 01 00 00    	je     f0101c62 <mem_init+0x4f5>
	assert(pp && pp0 == pp);
f0101a6b:	39 c3                	cmp    %eax,%ebx
f0101a6d:	0f 85 08 02 00 00    	jne    f0101c7b <mem_init+0x50e>
	return (pp - pages) << PGSHIFT;
f0101a73:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0101a79:	c1 f8 03             	sar    $0x3,%eax
f0101a7c:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a7f:	89 c2                	mov    %eax,%edx
f0101a81:	c1 ea 0c             	shr    $0xc,%edx
f0101a84:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0101a8a:	0f 83 04 02 00 00    	jae    f0101c94 <mem_init+0x527>
	return (void *)(pa + KERNBASE);
f0101a90:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101a96:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101a9b:	80 3a 00             	cmpb   $0x0,(%edx)
f0101a9e:	0f 85 02 02 00 00    	jne    f0101ca6 <mem_init+0x539>
f0101aa4:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101aa7:	39 c2                	cmp    %eax,%edx
f0101aa9:	75 f0                	jne    f0101a9b <mem_init+0x32e>
	page_free_list = fl;
f0101aab:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101aae:	a3 00 b9 5d f0       	mov    %eax,0xf05db900
	page_free(pp0);
f0101ab3:	83 ec 0c             	sub    $0xc,%esp
f0101ab6:	53                   	push   %ebx
f0101ab7:	e8 a5 f8 ff ff       	call   f0101361 <page_free>
	page_free(pp1);
f0101abc:	89 34 24             	mov    %esi,(%esp)
f0101abf:	e8 9d f8 ff ff       	call   f0101361 <page_free>
	page_free(pp2);
f0101ac4:	89 3c 24             	mov    %edi,(%esp)
f0101ac7:	e8 95 f8 ff ff       	call   f0101361 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101acc:	a1 00 b9 5d f0       	mov    0xf05db900,%eax
f0101ad1:	83 c4 10             	add    $0x10,%esp
f0101ad4:	e9 ec 01 00 00       	jmp    f0101cc5 <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101ad9:	68 09 97 10 f0       	push   $0xf0109709
f0101ade:	68 0b 96 10 f0       	push   $0xf010960b
f0101ae3:	68 28 03 00 00       	push   $0x328
f0101ae8:	68 e5 95 10 f0       	push   $0xf01095e5
f0101aed:	e8 57 e5 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101af2:	68 1f 97 10 f0       	push   $0xf010971f
f0101af7:	68 0b 96 10 f0       	push   $0xf010960b
f0101afc:	68 29 03 00 00       	push   $0x329
f0101b01:	68 e5 95 10 f0       	push   $0xf01095e5
f0101b06:	e8 3e e5 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101b0b:	68 35 97 10 f0       	push   $0xf0109735
f0101b10:	68 0b 96 10 f0       	push   $0xf010960b
f0101b15:	68 2a 03 00 00       	push   $0x32a
f0101b1a:	68 e5 95 10 f0       	push   $0xf01095e5
f0101b1f:	e8 25 e5 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101b24:	68 4b 97 10 f0       	push   $0xf010974b
f0101b29:	68 0b 96 10 f0       	push   $0xf010960b
f0101b2e:	68 2d 03 00 00       	push   $0x32d
f0101b33:	68 e5 95 10 f0       	push   $0xf01095e5
f0101b38:	e8 0c e5 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b3d:	68 8c 8d 10 f0       	push   $0xf0108d8c
f0101b42:	68 0b 96 10 f0       	push   $0xf010960b
f0101b47:	68 2e 03 00 00       	push   $0x32e
f0101b4c:	68 e5 95 10 f0       	push   $0xf01095e5
f0101b51:	e8 f3 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b56:	68 5d 97 10 f0       	push   $0xf010975d
f0101b5b:	68 0b 96 10 f0       	push   $0xf010960b
f0101b60:	68 2f 03 00 00       	push   $0x32f
f0101b65:	68 e5 95 10 f0       	push   $0xf01095e5
f0101b6a:	e8 da e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b6f:	68 7a 97 10 f0       	push   $0xf010977a
f0101b74:	68 0b 96 10 f0       	push   $0xf010960b
f0101b79:	68 30 03 00 00       	push   $0x330
f0101b7e:	68 e5 95 10 f0       	push   $0xf01095e5
f0101b83:	e8 c1 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b88:	68 97 97 10 f0       	push   $0xf0109797
f0101b8d:	68 0b 96 10 f0       	push   $0xf010960b
f0101b92:	68 31 03 00 00       	push   $0x331
f0101b97:	68 e5 95 10 f0       	push   $0xf01095e5
f0101b9c:	e8 a8 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101ba1:	68 b4 97 10 f0       	push   $0xf01097b4
f0101ba6:	68 0b 96 10 f0       	push   $0xf010960b
f0101bab:	68 38 03 00 00       	push   $0x338
f0101bb0:	68 e5 95 10 f0       	push   $0xf01095e5
f0101bb5:	e8 8f e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101bba:	68 09 97 10 f0       	push   $0xf0109709
f0101bbf:	68 0b 96 10 f0       	push   $0xf010960b
f0101bc4:	68 3f 03 00 00       	push   $0x33f
f0101bc9:	68 e5 95 10 f0       	push   $0xf01095e5
f0101bce:	e8 76 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101bd3:	68 1f 97 10 f0       	push   $0xf010971f
f0101bd8:	68 0b 96 10 f0       	push   $0xf010960b
f0101bdd:	68 40 03 00 00       	push   $0x340
f0101be2:	68 e5 95 10 f0       	push   $0xf01095e5
f0101be7:	e8 5d e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101bec:	68 35 97 10 f0       	push   $0xf0109735
f0101bf1:	68 0b 96 10 f0       	push   $0xf010960b
f0101bf6:	68 41 03 00 00       	push   $0x341
f0101bfb:	68 e5 95 10 f0       	push   $0xf01095e5
f0101c00:	e8 44 e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101c05:	68 4b 97 10 f0       	push   $0xf010974b
f0101c0a:	68 0b 96 10 f0       	push   $0xf010960b
f0101c0f:	68 43 03 00 00       	push   $0x343
f0101c14:	68 e5 95 10 f0       	push   $0xf01095e5
f0101c19:	e8 2b e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c1e:	68 8c 8d 10 f0       	push   $0xf0108d8c
f0101c23:	68 0b 96 10 f0       	push   $0xf010960b
f0101c28:	68 44 03 00 00       	push   $0x344
f0101c2d:	68 e5 95 10 f0       	push   $0xf01095e5
f0101c32:	e8 12 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c37:	68 b4 97 10 f0       	push   $0xf01097b4
f0101c3c:	68 0b 96 10 f0       	push   $0xf010960b
f0101c41:	68 45 03 00 00       	push   $0x345
f0101c46:	68 e5 95 10 f0       	push   $0xf01095e5
f0101c4b:	e8 f9 e3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c50:	50                   	push   %eax
f0101c51:	68 34 84 10 f0       	push   $0xf0108434
f0101c56:	6a 58                	push   $0x58
f0101c58:	68 f1 95 10 f0       	push   $0xf01095f1
f0101c5d:	e8 e7 e3 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101c62:	68 c3 97 10 f0       	push   $0xf01097c3
f0101c67:	68 0b 96 10 f0       	push   $0xf010960b
f0101c6c:	68 4a 03 00 00       	push   $0x34a
f0101c71:	68 e5 95 10 f0       	push   $0xf01095e5
f0101c76:	e8 ce e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101c7b:	68 e1 97 10 f0       	push   $0xf01097e1
f0101c80:	68 0b 96 10 f0       	push   $0xf010960b
f0101c85:	68 4b 03 00 00       	push   $0x34b
f0101c8a:	68 e5 95 10 f0       	push   $0xf01095e5
f0101c8f:	e8 b5 e3 ff ff       	call   f0100049 <_panic>
f0101c94:	50                   	push   %eax
f0101c95:	68 34 84 10 f0       	push   $0xf0108434
f0101c9a:	6a 58                	push   $0x58
f0101c9c:	68 f1 95 10 f0       	push   $0xf01095f1
f0101ca1:	e8 a3 e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101ca6:	68 f1 97 10 f0       	push   $0xf01097f1
f0101cab:	68 0b 96 10 f0       	push   $0xf010960b
f0101cb0:	68 4e 03 00 00       	push   $0x34e
f0101cb5:	68 e5 95 10 f0       	push   $0xf01095e5
f0101cba:	e8 8a e3 ff ff       	call   f0100049 <_panic>
		--nfree;
f0101cbf:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101cc3:	8b 00                	mov    (%eax),%eax
f0101cc5:	85 c0                	test   %eax,%eax
f0101cc7:	75 f6                	jne    f0101cbf <mem_init+0x552>
	assert(nfree == 0);
f0101cc9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101ccd:	0f 85 65 09 00 00    	jne    f0102638 <mem_init+0xecb>
	cprintf("check_page_alloc() succeeded!\n");
f0101cd3:	83 ec 0c             	sub    $0xc,%esp
f0101cd6:	68 ac 8d 10 f0       	push   $0xf0108dac
f0101cdb:	e8 21 29 00 00       	call   f0104601 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101ce0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ce7:	e8 03 f6 ff ff       	call   f01012ef <page_alloc>
f0101cec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101cef:	83 c4 10             	add    $0x10,%esp
f0101cf2:	85 c0                	test   %eax,%eax
f0101cf4:	0f 84 57 09 00 00    	je     f0102651 <mem_init+0xee4>
	assert((pp1 = page_alloc(0)));
f0101cfa:	83 ec 0c             	sub    $0xc,%esp
f0101cfd:	6a 00                	push   $0x0
f0101cff:	e8 eb f5 ff ff       	call   f01012ef <page_alloc>
f0101d04:	89 c7                	mov    %eax,%edi
f0101d06:	83 c4 10             	add    $0x10,%esp
f0101d09:	85 c0                	test   %eax,%eax
f0101d0b:	0f 84 59 09 00 00    	je     f010266a <mem_init+0xefd>
	assert((pp2 = page_alloc(0)));
f0101d11:	83 ec 0c             	sub    $0xc,%esp
f0101d14:	6a 00                	push   $0x0
f0101d16:	e8 d4 f5 ff ff       	call   f01012ef <page_alloc>
f0101d1b:	89 c3                	mov    %eax,%ebx
f0101d1d:	83 c4 10             	add    $0x10,%esp
f0101d20:	85 c0                	test   %eax,%eax
f0101d22:	0f 84 5b 09 00 00    	je     f0102683 <mem_init+0xf16>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101d28:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101d2b:	0f 84 6b 09 00 00    	je     f010269c <mem_init+0xf2f>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d31:	39 c7                	cmp    %eax,%edi
f0101d33:	0f 84 7c 09 00 00    	je     f01026b5 <mem_init+0xf48>
f0101d39:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101d3c:	0f 84 73 09 00 00    	je     f01026b5 <mem_init+0xf48>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101d42:	a1 00 b9 5d f0       	mov    0xf05db900,%eax
f0101d47:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101d4a:	c7 05 00 b9 5d f0 00 	movl   $0x0,0xf05db900
f0101d51:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101d54:	83 ec 0c             	sub    $0xc,%esp
f0101d57:	6a 00                	push   $0x0
f0101d59:	e8 91 f5 ff ff       	call   f01012ef <page_alloc>
f0101d5e:	83 c4 10             	add    $0x10,%esp
f0101d61:	85 c0                	test   %eax,%eax
f0101d63:	0f 85 65 09 00 00    	jne    f01026ce <mem_init+0xf61>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101d69:	83 ec 04             	sub    $0x4,%esp
f0101d6c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d6f:	50                   	push   %eax
f0101d70:	6a 00                	push   $0x0
f0101d72:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0101d78:	e8 ce f7 ff ff       	call   f010154b <page_lookup>
f0101d7d:	83 c4 10             	add    $0x10,%esp
f0101d80:	85 c0                	test   %eax,%eax
f0101d82:	0f 85 5f 09 00 00    	jne    f01026e7 <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101d88:	6a 02                	push   $0x2
f0101d8a:	6a 00                	push   $0x0
f0101d8c:	57                   	push   %edi
f0101d8d:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0101d93:	e8 93 f8 ff ff       	call   f010162b <page_insert>
f0101d98:	83 c4 10             	add    $0x10,%esp
f0101d9b:	85 c0                	test   %eax,%eax
f0101d9d:	0f 89 5d 09 00 00    	jns    f0102700 <mem_init+0xf93>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101da3:	83 ec 0c             	sub    $0xc,%esp
f0101da6:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101da9:	e8 b3 f5 ff ff       	call   f0101361 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101dae:	6a 02                	push   $0x2
f0101db0:	6a 00                	push   $0x0
f0101db2:	57                   	push   %edi
f0101db3:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0101db9:	e8 6d f8 ff ff       	call   f010162b <page_insert>
f0101dbe:	83 c4 20             	add    $0x20,%esp
f0101dc1:	85 c0                	test   %eax,%eax
f0101dc3:	0f 85 50 09 00 00    	jne    f0102719 <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101dc9:	8b 35 4c cd 5d f0    	mov    0xf05dcd4c,%esi
	return (pp - pages) << PGSHIFT;
f0101dcf:	8b 0d 50 cd 5d f0    	mov    0xf05dcd50,%ecx
f0101dd5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101dd8:	8b 16                	mov    (%esi),%edx
f0101dda:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101de3:	29 c8                	sub    %ecx,%eax
f0101de5:	c1 f8 03             	sar    $0x3,%eax
f0101de8:	c1 e0 0c             	shl    $0xc,%eax
f0101deb:	39 c2                	cmp    %eax,%edx
f0101ded:	0f 85 3f 09 00 00    	jne    f0102732 <mem_init+0xfc5>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101df3:	ba 00 00 00 00       	mov    $0x0,%edx
f0101df8:	89 f0                	mov    %esi,%eax
f0101dfa:	e8 f9 ef ff ff       	call   f0100df8 <check_va2pa>
f0101dff:	89 fa                	mov    %edi,%edx
f0101e01:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101e04:	c1 fa 03             	sar    $0x3,%edx
f0101e07:	c1 e2 0c             	shl    $0xc,%edx
f0101e0a:	39 d0                	cmp    %edx,%eax
f0101e0c:	0f 85 39 09 00 00    	jne    f010274b <mem_init+0xfde>
	assert(pp1->pp_ref == 1);
f0101e12:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e17:	0f 85 47 09 00 00    	jne    f0102764 <mem_init+0xff7>
	assert(pp0->pp_ref == 1);
f0101e1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e20:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101e25:	0f 85 52 09 00 00    	jne    f010277d <mem_init+0x1010>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e2b:	6a 02                	push   $0x2
f0101e2d:	68 00 10 00 00       	push   $0x1000
f0101e32:	53                   	push   %ebx
f0101e33:	56                   	push   %esi
f0101e34:	e8 f2 f7 ff ff       	call   f010162b <page_insert>
f0101e39:	83 c4 10             	add    $0x10,%esp
f0101e3c:	85 c0                	test   %eax,%eax
f0101e3e:	0f 85 52 09 00 00    	jne    f0102796 <mem_init+0x1029>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e44:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e49:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0101e4e:	e8 a5 ef ff ff       	call   f0100df8 <check_va2pa>
f0101e53:	89 da                	mov    %ebx,%edx
f0101e55:	2b 15 50 cd 5d f0    	sub    0xf05dcd50,%edx
f0101e5b:	c1 fa 03             	sar    $0x3,%edx
f0101e5e:	c1 e2 0c             	shl    $0xc,%edx
f0101e61:	39 d0                	cmp    %edx,%eax
f0101e63:	0f 85 46 09 00 00    	jne    f01027af <mem_init+0x1042>
	assert(pp2->pp_ref == 1);
f0101e69:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101e6e:	0f 85 54 09 00 00    	jne    f01027c8 <mem_init+0x105b>

	// should be no free memory
	assert(!page_alloc(0));
f0101e74:	83 ec 0c             	sub    $0xc,%esp
f0101e77:	6a 00                	push   $0x0
f0101e79:	e8 71 f4 ff ff       	call   f01012ef <page_alloc>
f0101e7e:	83 c4 10             	add    $0x10,%esp
f0101e81:	85 c0                	test   %eax,%eax
f0101e83:	0f 85 58 09 00 00    	jne    f01027e1 <mem_init+0x1074>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e89:	6a 02                	push   $0x2
f0101e8b:	68 00 10 00 00       	push   $0x1000
f0101e90:	53                   	push   %ebx
f0101e91:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0101e97:	e8 8f f7 ff ff       	call   f010162b <page_insert>
f0101e9c:	83 c4 10             	add    $0x10,%esp
f0101e9f:	85 c0                	test   %eax,%eax
f0101ea1:	0f 85 53 09 00 00    	jne    f01027fa <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ea7:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101eac:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0101eb1:	e8 42 ef ff ff       	call   f0100df8 <check_va2pa>
f0101eb6:	89 da                	mov    %ebx,%edx
f0101eb8:	2b 15 50 cd 5d f0    	sub    0xf05dcd50,%edx
f0101ebe:	c1 fa 03             	sar    $0x3,%edx
f0101ec1:	c1 e2 0c             	shl    $0xc,%edx
f0101ec4:	39 d0                	cmp    %edx,%eax
f0101ec6:	0f 85 47 09 00 00    	jne    f0102813 <mem_init+0x10a6>
	assert(pp2->pp_ref == 1);
f0101ecc:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101ed1:	0f 85 55 09 00 00    	jne    f010282c <mem_init+0x10bf>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101ed7:	83 ec 0c             	sub    $0xc,%esp
f0101eda:	6a 00                	push   $0x0
f0101edc:	e8 0e f4 ff ff       	call   f01012ef <page_alloc>
f0101ee1:	83 c4 10             	add    $0x10,%esp
f0101ee4:	85 c0                	test   %eax,%eax
f0101ee6:	0f 85 59 09 00 00    	jne    f0102845 <mem_init+0x10d8>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101eec:	8b 15 4c cd 5d f0    	mov    0xf05dcd4c,%edx
f0101ef2:	8b 02                	mov    (%edx),%eax
f0101ef4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101ef9:	89 c1                	mov    %eax,%ecx
f0101efb:	c1 e9 0c             	shr    $0xc,%ecx
f0101efe:	3b 0d 48 cd 5d f0    	cmp    0xf05dcd48,%ecx
f0101f04:	0f 83 54 09 00 00    	jae    f010285e <mem_init+0x10f1>
	return (void *)(pa + KERNBASE);
f0101f0a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101f12:	83 ec 04             	sub    $0x4,%esp
f0101f15:	6a 00                	push   $0x0
f0101f17:	68 00 10 00 00       	push   $0x1000
f0101f1c:	52                   	push   %edx
f0101f1d:	e8 a3 f4 ff ff       	call   f01013c5 <pgdir_walk>
f0101f22:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101f25:	8d 51 04             	lea    0x4(%ecx),%edx
f0101f28:	83 c4 10             	add    $0x10,%esp
f0101f2b:	39 d0                	cmp    %edx,%eax
f0101f2d:	0f 85 40 09 00 00    	jne    f0102873 <mem_init+0x1106>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101f33:	6a 06                	push   $0x6
f0101f35:	68 00 10 00 00       	push   $0x1000
f0101f3a:	53                   	push   %ebx
f0101f3b:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0101f41:	e8 e5 f6 ff ff       	call   f010162b <page_insert>
f0101f46:	83 c4 10             	add    $0x10,%esp
f0101f49:	85 c0                	test   %eax,%eax
f0101f4b:	0f 85 3b 09 00 00    	jne    f010288c <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f51:	8b 35 4c cd 5d f0    	mov    0xf05dcd4c,%esi
f0101f57:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f5c:	89 f0                	mov    %esi,%eax
f0101f5e:	e8 95 ee ff ff       	call   f0100df8 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101f63:	89 da                	mov    %ebx,%edx
f0101f65:	2b 15 50 cd 5d f0    	sub    0xf05dcd50,%edx
f0101f6b:	c1 fa 03             	sar    $0x3,%edx
f0101f6e:	c1 e2 0c             	shl    $0xc,%edx
f0101f71:	39 d0                	cmp    %edx,%eax
f0101f73:	0f 85 2c 09 00 00    	jne    f01028a5 <mem_init+0x1138>
	assert(pp2->pp_ref == 1);
f0101f79:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101f7e:	0f 85 3a 09 00 00    	jne    f01028be <mem_init+0x1151>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101f84:	83 ec 04             	sub    $0x4,%esp
f0101f87:	6a 00                	push   $0x0
f0101f89:	68 00 10 00 00       	push   $0x1000
f0101f8e:	56                   	push   %esi
f0101f8f:	e8 31 f4 ff ff       	call   f01013c5 <pgdir_walk>
f0101f94:	83 c4 10             	add    $0x10,%esp
f0101f97:	f6 00 04             	testb  $0x4,(%eax)
f0101f9a:	0f 84 37 09 00 00    	je     f01028d7 <mem_init+0x116a>
	assert(kern_pgdir[0] & PTE_U);
f0101fa0:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0101fa5:	f6 00 04             	testb  $0x4,(%eax)
f0101fa8:	0f 84 42 09 00 00    	je     f01028f0 <mem_init+0x1183>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101fae:	6a 02                	push   $0x2
f0101fb0:	68 00 10 00 00       	push   $0x1000
f0101fb5:	53                   	push   %ebx
f0101fb6:	50                   	push   %eax
f0101fb7:	e8 6f f6 ff ff       	call   f010162b <page_insert>
f0101fbc:	83 c4 10             	add    $0x10,%esp
f0101fbf:	85 c0                	test   %eax,%eax
f0101fc1:	0f 85 42 09 00 00    	jne    f0102909 <mem_init+0x119c>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101fc7:	83 ec 04             	sub    $0x4,%esp
f0101fca:	6a 00                	push   $0x0
f0101fcc:	68 00 10 00 00       	push   $0x1000
f0101fd1:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0101fd7:	e8 e9 f3 ff ff       	call   f01013c5 <pgdir_walk>
f0101fdc:	83 c4 10             	add    $0x10,%esp
f0101fdf:	f6 00 02             	testb  $0x2,(%eax)
f0101fe2:	0f 84 3a 09 00 00    	je     f0102922 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101fe8:	83 ec 04             	sub    $0x4,%esp
f0101feb:	6a 00                	push   $0x0
f0101fed:	68 00 10 00 00       	push   $0x1000
f0101ff2:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0101ff8:	e8 c8 f3 ff ff       	call   f01013c5 <pgdir_walk>
f0101ffd:	83 c4 10             	add    $0x10,%esp
f0102000:	f6 00 04             	testb  $0x4,(%eax)
f0102003:	0f 85 32 09 00 00    	jne    f010293b <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102009:	6a 02                	push   $0x2
f010200b:	68 00 00 40 00       	push   $0x400000
f0102010:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102013:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0102019:	e8 0d f6 ff ff       	call   f010162b <page_insert>
f010201e:	83 c4 10             	add    $0x10,%esp
f0102021:	85 c0                	test   %eax,%eax
f0102023:	0f 89 2b 09 00 00    	jns    f0102954 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102029:	6a 02                	push   $0x2
f010202b:	68 00 10 00 00       	push   $0x1000
f0102030:	57                   	push   %edi
f0102031:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0102037:	e8 ef f5 ff ff       	call   f010162b <page_insert>
f010203c:	83 c4 10             	add    $0x10,%esp
f010203f:	85 c0                	test   %eax,%eax
f0102041:	0f 85 26 09 00 00    	jne    f010296d <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102047:	83 ec 04             	sub    $0x4,%esp
f010204a:	6a 00                	push   $0x0
f010204c:	68 00 10 00 00       	push   $0x1000
f0102051:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0102057:	e8 69 f3 ff ff       	call   f01013c5 <pgdir_walk>
f010205c:	83 c4 10             	add    $0x10,%esp
f010205f:	f6 00 04             	testb  $0x4,(%eax)
f0102062:	0f 85 1e 09 00 00    	jne    f0102986 <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102068:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f010206d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102070:	ba 00 00 00 00       	mov    $0x0,%edx
f0102075:	e8 7e ed ff ff       	call   f0100df8 <check_va2pa>
f010207a:	89 fe                	mov    %edi,%esi
f010207c:	2b 35 50 cd 5d f0    	sub    0xf05dcd50,%esi
f0102082:	c1 fe 03             	sar    $0x3,%esi
f0102085:	c1 e6 0c             	shl    $0xc,%esi
f0102088:	39 f0                	cmp    %esi,%eax
f010208a:	0f 85 0f 09 00 00    	jne    f010299f <mem_init+0x1232>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102090:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102095:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102098:	e8 5b ed ff ff       	call   f0100df8 <check_va2pa>
f010209d:	39 c6                	cmp    %eax,%esi
f010209f:	0f 85 13 09 00 00    	jne    f01029b8 <mem_init+0x124b>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01020a5:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f01020aa:	0f 85 21 09 00 00    	jne    f01029d1 <mem_init+0x1264>
	assert(pp2->pp_ref == 0);
f01020b0:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01020b5:	0f 85 2f 09 00 00    	jne    f01029ea <mem_init+0x127d>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f01020bb:	83 ec 0c             	sub    $0xc,%esp
f01020be:	6a 00                	push   $0x0
f01020c0:	e8 2a f2 ff ff       	call   f01012ef <page_alloc>
f01020c5:	83 c4 10             	add    $0x10,%esp
f01020c8:	39 c3                	cmp    %eax,%ebx
f01020ca:	0f 85 33 09 00 00    	jne    f0102a03 <mem_init+0x1296>
f01020d0:	85 c0                	test   %eax,%eax
f01020d2:	0f 84 2b 09 00 00    	je     f0102a03 <mem_init+0x1296>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f01020d8:	83 ec 08             	sub    $0x8,%esp
f01020db:	6a 00                	push   $0x0
f01020dd:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f01020e3:	e8 fd f4 ff ff       	call   f01015e5 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01020e8:	8b 35 4c cd 5d f0    	mov    0xf05dcd4c,%esi
f01020ee:	ba 00 00 00 00       	mov    $0x0,%edx
f01020f3:	89 f0                	mov    %esi,%eax
f01020f5:	e8 fe ec ff ff       	call   f0100df8 <check_va2pa>
f01020fa:	83 c4 10             	add    $0x10,%esp
f01020fd:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102100:	0f 85 16 09 00 00    	jne    f0102a1c <mem_init+0x12af>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102106:	ba 00 10 00 00       	mov    $0x1000,%edx
f010210b:	89 f0                	mov    %esi,%eax
f010210d:	e8 e6 ec ff ff       	call   f0100df8 <check_va2pa>
f0102112:	89 fa                	mov    %edi,%edx
f0102114:	2b 15 50 cd 5d f0    	sub    0xf05dcd50,%edx
f010211a:	c1 fa 03             	sar    $0x3,%edx
f010211d:	c1 e2 0c             	shl    $0xc,%edx
f0102120:	39 d0                	cmp    %edx,%eax
f0102122:	0f 85 0d 09 00 00    	jne    f0102a35 <mem_init+0x12c8>
	assert(pp1->pp_ref == 1);
f0102128:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010212d:	0f 85 1b 09 00 00    	jne    f0102a4e <mem_init+0x12e1>
	assert(pp2->pp_ref == 0);
f0102133:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102138:	0f 85 29 09 00 00    	jne    f0102a67 <mem_init+0x12fa>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010213e:	6a 00                	push   $0x0
f0102140:	68 00 10 00 00       	push   $0x1000
f0102145:	57                   	push   %edi
f0102146:	56                   	push   %esi
f0102147:	e8 df f4 ff ff       	call   f010162b <page_insert>
f010214c:	83 c4 10             	add    $0x10,%esp
f010214f:	85 c0                	test   %eax,%eax
f0102151:	0f 85 29 09 00 00    	jne    f0102a80 <mem_init+0x1313>
	assert(pp1->pp_ref);
f0102157:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010215c:	0f 84 37 09 00 00    	je     f0102a99 <mem_init+0x132c>
	assert(pp1->pp_link == NULL);
f0102162:	83 3f 00             	cmpl   $0x0,(%edi)
f0102165:	0f 85 47 09 00 00    	jne    f0102ab2 <mem_init+0x1345>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f010216b:	83 ec 08             	sub    $0x8,%esp
f010216e:	68 00 10 00 00       	push   $0x1000
f0102173:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0102179:	e8 67 f4 ff ff       	call   f01015e5 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010217e:	8b 35 4c cd 5d f0    	mov    0xf05dcd4c,%esi
f0102184:	ba 00 00 00 00       	mov    $0x0,%edx
f0102189:	89 f0                	mov    %esi,%eax
f010218b:	e8 68 ec ff ff       	call   f0100df8 <check_va2pa>
f0102190:	83 c4 10             	add    $0x10,%esp
f0102193:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102196:	0f 85 2f 09 00 00    	jne    f0102acb <mem_init+0x135e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010219c:	ba 00 10 00 00       	mov    $0x1000,%edx
f01021a1:	89 f0                	mov    %esi,%eax
f01021a3:	e8 50 ec ff ff       	call   f0100df8 <check_va2pa>
f01021a8:	83 f8 ff             	cmp    $0xffffffff,%eax
f01021ab:	0f 85 33 09 00 00    	jne    f0102ae4 <mem_init+0x1377>
	assert(pp1->pp_ref == 0);
f01021b1:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01021b6:	0f 85 41 09 00 00    	jne    f0102afd <mem_init+0x1390>
	assert(pp2->pp_ref == 0);
f01021bc:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01021c1:	0f 85 4f 09 00 00    	jne    f0102b16 <mem_init+0x13a9>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f01021c7:	83 ec 0c             	sub    $0xc,%esp
f01021ca:	6a 00                	push   $0x0
f01021cc:	e8 1e f1 ff ff       	call   f01012ef <page_alloc>
f01021d1:	83 c4 10             	add    $0x10,%esp
f01021d4:	85 c0                	test   %eax,%eax
f01021d6:	0f 84 53 09 00 00    	je     f0102b2f <mem_init+0x13c2>
f01021dc:	39 c7                	cmp    %eax,%edi
f01021de:	0f 85 4b 09 00 00    	jne    f0102b2f <mem_init+0x13c2>

	// should be no free memory
	assert(!page_alloc(0));
f01021e4:	83 ec 0c             	sub    $0xc,%esp
f01021e7:	6a 00                	push   $0x0
f01021e9:	e8 01 f1 ff ff       	call   f01012ef <page_alloc>
f01021ee:	83 c4 10             	add    $0x10,%esp
f01021f1:	85 c0                	test   %eax,%eax
f01021f3:	0f 85 4f 09 00 00    	jne    f0102b48 <mem_init+0x13db>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01021f9:	8b 0d 4c cd 5d f0    	mov    0xf05dcd4c,%ecx
f01021ff:	8b 11                	mov    (%ecx),%edx
f0102201:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010220a:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0102210:	c1 f8 03             	sar    $0x3,%eax
f0102213:	c1 e0 0c             	shl    $0xc,%eax
f0102216:	39 c2                	cmp    %eax,%edx
f0102218:	0f 85 43 09 00 00    	jne    f0102b61 <mem_init+0x13f4>
	kern_pgdir[0] = 0;
f010221e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102224:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102227:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010222c:	0f 85 48 09 00 00    	jne    f0102b7a <mem_init+0x140d>
	pp0->pp_ref = 0;
f0102232:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102235:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f010223b:	83 ec 0c             	sub    $0xc,%esp
f010223e:	50                   	push   %eax
f010223f:	e8 1d f1 ff ff       	call   f0101361 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102244:	83 c4 0c             	add    $0xc,%esp
f0102247:	6a 01                	push   $0x1
f0102249:	68 00 10 40 00       	push   $0x401000
f010224e:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0102254:	e8 6c f1 ff ff       	call   f01013c5 <pgdir_walk>
f0102259:	89 c1                	mov    %eax,%ecx
f010225b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010225e:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0102263:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102266:	8b 40 04             	mov    0x4(%eax),%eax
f0102269:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010226e:	8b 35 48 cd 5d f0    	mov    0xf05dcd48,%esi
f0102274:	89 c2                	mov    %eax,%edx
f0102276:	c1 ea 0c             	shr    $0xc,%edx
f0102279:	83 c4 10             	add    $0x10,%esp
f010227c:	39 f2                	cmp    %esi,%edx
f010227e:	0f 83 0f 09 00 00    	jae    f0102b93 <mem_init+0x1426>
	assert(ptep == ptep1 + PTX(va));
f0102284:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f0102289:	39 c1                	cmp    %eax,%ecx
f010228b:	0f 85 17 09 00 00    	jne    f0102ba8 <mem_init+0x143b>
	kern_pgdir[PDX(va)] = 0;
f0102291:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102294:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f010229b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010229e:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01022a4:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f01022aa:	c1 f8 03             	sar    $0x3,%eax
f01022ad:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022b0:	89 c2                	mov    %eax,%edx
f01022b2:	c1 ea 0c             	shr    $0xc,%edx
f01022b5:	39 d6                	cmp    %edx,%esi
f01022b7:	0f 86 04 09 00 00    	jbe    f0102bc1 <mem_init+0x1454>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01022bd:	83 ec 04             	sub    $0x4,%esp
f01022c0:	68 00 10 00 00       	push   $0x1000
f01022c5:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01022ca:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01022cf:	50                   	push   %eax
f01022d0:	e8 3a 4a 00 00       	call   f0106d0f <memset>
	page_free(pp0);
f01022d5:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01022d8:	89 34 24             	mov    %esi,(%esp)
f01022db:	e8 81 f0 ff ff       	call   f0101361 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01022e0:	83 c4 0c             	add    $0xc,%esp
f01022e3:	6a 01                	push   $0x1
f01022e5:	6a 00                	push   $0x0
f01022e7:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f01022ed:	e8 d3 f0 ff ff       	call   f01013c5 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01022f2:	89 f0                	mov    %esi,%eax
f01022f4:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f01022fa:	c1 f8 03             	sar    $0x3,%eax
f01022fd:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102300:	89 c2                	mov    %eax,%edx
f0102302:	c1 ea 0c             	shr    $0xc,%edx
f0102305:	83 c4 10             	add    $0x10,%esp
f0102308:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f010230e:	0f 83 bf 08 00 00    	jae    f0102bd3 <mem_init+0x1466>
	return (void *)(pa + KERNBASE);
f0102314:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f010231a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010231d:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102322:	f6 02 01             	testb  $0x1,(%edx)
f0102325:	0f 85 ba 08 00 00    	jne    f0102be5 <mem_init+0x1478>
f010232b:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f010232e:	39 c2                	cmp    %eax,%edx
f0102330:	75 f0                	jne    f0102322 <mem_init+0xbb5>
	kern_pgdir[0] = 0;
f0102332:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0102337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010233d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102340:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102346:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102349:	89 0d 00 b9 5d f0    	mov    %ecx,0xf05db900

	// free the pages we took
	page_free(pp0);
f010234f:	83 ec 0c             	sub    $0xc,%esp
f0102352:	50                   	push   %eax
f0102353:	e8 09 f0 ff ff       	call   f0101361 <page_free>
	page_free(pp1);
f0102358:	89 3c 24             	mov    %edi,(%esp)
f010235b:	e8 01 f0 ff ff       	call   f0101361 <page_free>
	page_free(pp2);
f0102360:	89 1c 24             	mov    %ebx,(%esp)
f0102363:	e8 f9 ef ff ff       	call   f0101361 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102368:	83 c4 08             	add    $0x8,%esp
f010236b:	68 01 10 00 00       	push   $0x1001
f0102370:	6a 00                	push   $0x0
f0102372:	e8 96 f3 ff ff       	call   f010170d <mmio_map_region>
f0102377:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102379:	83 c4 08             	add    $0x8,%esp
f010237c:	68 00 10 00 00       	push   $0x1000
f0102381:	6a 00                	push   $0x0
f0102383:	e8 85 f3 ff ff       	call   f010170d <mmio_map_region>
f0102388:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010238a:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102390:	83 c4 10             	add    $0x10,%esp
f0102393:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102399:	0f 86 5f 08 00 00    	jbe    f0102bfe <mem_init+0x1491>
f010239f:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01023a4:	0f 87 54 08 00 00    	ja     f0102bfe <mem_init+0x1491>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01023aa:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f01023b0:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f01023b6:	0f 87 5b 08 00 00    	ja     f0102c17 <mem_init+0x14aa>
f01023bc:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01023c2:	0f 86 4f 08 00 00    	jbe    f0102c17 <mem_init+0x14aa>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01023c8:	89 da                	mov    %ebx,%edx
f01023ca:	09 f2                	or     %esi,%edx
f01023cc:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01023d2:	0f 85 58 08 00 00    	jne    f0102c30 <mem_init+0x14c3>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f01023d8:	39 c6                	cmp    %eax,%esi
f01023da:	0f 82 69 08 00 00    	jb     f0102c49 <mem_init+0x14dc>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01023e0:	8b 3d 4c cd 5d f0    	mov    0xf05dcd4c,%edi
f01023e6:	89 da                	mov    %ebx,%edx
f01023e8:	89 f8                	mov    %edi,%eax
f01023ea:	e8 09 ea ff ff       	call   f0100df8 <check_va2pa>
f01023ef:	85 c0                	test   %eax,%eax
f01023f1:	0f 85 6b 08 00 00    	jne    f0102c62 <mem_init+0x14f5>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01023f7:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01023fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102400:	89 c2                	mov    %eax,%edx
f0102402:	89 f8                	mov    %edi,%eax
f0102404:	e8 ef e9 ff ff       	call   f0100df8 <check_va2pa>
f0102409:	3d 00 10 00 00       	cmp    $0x1000,%eax
f010240e:	0f 85 67 08 00 00    	jne    f0102c7b <mem_init+0x150e>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102414:	89 f2                	mov    %esi,%edx
f0102416:	89 f8                	mov    %edi,%eax
f0102418:	e8 db e9 ff ff       	call   f0100df8 <check_va2pa>
f010241d:	85 c0                	test   %eax,%eax
f010241f:	0f 85 6f 08 00 00    	jne    f0102c94 <mem_init+0x1527>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102425:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f010242b:	89 f8                	mov    %edi,%eax
f010242d:	e8 c6 e9 ff ff       	call   f0100df8 <check_va2pa>
f0102432:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102435:	0f 85 72 08 00 00    	jne    f0102cad <mem_init+0x1540>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f010243b:	83 ec 04             	sub    $0x4,%esp
f010243e:	6a 00                	push   $0x0
f0102440:	53                   	push   %ebx
f0102441:	57                   	push   %edi
f0102442:	e8 7e ef ff ff       	call   f01013c5 <pgdir_walk>
f0102447:	83 c4 10             	add    $0x10,%esp
f010244a:	f6 00 1a             	testb  $0x1a,(%eax)
f010244d:	0f 84 73 08 00 00    	je     f0102cc6 <mem_init+0x1559>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102453:	83 ec 04             	sub    $0x4,%esp
f0102456:	6a 00                	push   $0x0
f0102458:	53                   	push   %ebx
f0102459:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f010245f:	e8 61 ef ff ff       	call   f01013c5 <pgdir_walk>
f0102464:	8b 00                	mov    (%eax),%eax
f0102466:	83 c4 10             	add    $0x10,%esp
f0102469:	83 e0 04             	and    $0x4,%eax
f010246c:	89 c7                	mov    %eax,%edi
f010246e:	0f 85 6b 08 00 00    	jne    f0102cdf <mem_init+0x1572>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102474:	83 ec 04             	sub    $0x4,%esp
f0102477:	6a 00                	push   $0x0
f0102479:	53                   	push   %ebx
f010247a:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0102480:	e8 40 ef ff ff       	call   f01013c5 <pgdir_walk>
f0102485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f010248b:	83 c4 0c             	add    $0xc,%esp
f010248e:	6a 00                	push   $0x0
f0102490:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102493:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0102499:	e8 27 ef ff ff       	call   f01013c5 <pgdir_walk>
f010249e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f01024a4:	83 c4 0c             	add    $0xc,%esp
f01024a7:	6a 00                	push   $0x0
f01024a9:	56                   	push   %esi
f01024aa:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f01024b0:	e8 10 ef ff ff       	call   f01013c5 <pgdir_walk>
f01024b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f01024bb:	c7 04 24 e4 98 10 f0 	movl   $0xf01098e4,(%esp)
f01024c2:	e8 3a 21 00 00       	call   f0104601 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01024c7:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
	if ((uint32_t)kva < KERNBASE)
f01024cc:	83 c4 10             	add    $0x10,%esp
f01024cf:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01024d4:	0f 86 1e 08 00 00    	jbe    f0102cf8 <mem_init+0x158b>
f01024da:	83 ec 08             	sub    $0x8,%esp
f01024dd:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01024df:	05 00 00 00 10       	add    $0x10000000,%eax
f01024e4:	50                   	push   %eax
f01024e5:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01024ea:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01024ef:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f01024f4:	e8 9e ef ff ff       	call   f0101497 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01024f9:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
	if ((uint32_t)kva < KERNBASE)
f01024fe:	83 c4 10             	add    $0x10,%esp
f0102501:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102506:	0f 86 01 08 00 00    	jbe    f0102d0d <mem_init+0x15a0>
f010250c:	83 ec 08             	sub    $0x8,%esp
f010250f:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102511:	05 00 00 00 10       	add    $0x10000000,%eax
f0102516:	50                   	push   %eax
f0102517:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010251c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102521:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0102526:	e8 6c ef ff ff       	call   f0101497 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010252b:	83 c4 10             	add    $0x10,%esp
f010252e:	b8 00 20 12 f0       	mov    $0xf0122000,%eax
f0102533:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102538:	0f 86 e4 07 00 00    	jbe    f0102d22 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f010253e:	83 ec 08             	sub    $0x8,%esp
f0102541:	6a 02                	push   $0x2
f0102543:	68 00 20 12 00       	push   $0x122000
f0102548:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010254d:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102552:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0102557:	e8 3b ef ff ff       	call   f0101497 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f010255c:	83 c4 08             	add    $0x8,%esp
f010255f:	6a 02                	push   $0x2
f0102561:	6a 00                	push   $0x0
f0102563:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102568:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f010256d:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f0102572:	e8 20 ef ff ff       	call   f0101497 <boot_map_region>
f0102577:	c7 45 d0 00 b0 12 f0 	movl   $0xf012b000,-0x30(%ebp)
f010257e:	83 c4 10             	add    $0x10,%esp
f0102581:	bb 00 b0 12 f0       	mov    $0xf012b000,%ebx
f0102586:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f010258b:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102591:	0f 86 a0 07 00 00    	jbe    f0102d37 <mem_init+0x15ca>
		boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f0102597:	83 ec 08             	sub    $0x8,%esp
f010259a:	6a 02                	push   $0x2
f010259c:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01025a2:	50                   	push   %eax
f01025a3:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01025a8:	89 f2                	mov    %esi,%edx
f01025aa:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f01025af:	e8 e3 ee ff ff       	call   f0101497 <boot_map_region>
f01025b4:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f01025ba:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f01025c0:	83 c4 10             	add    $0x10,%esp
f01025c3:	81 fb 00 b0 16 f0    	cmp    $0xf016b000,%ebx
f01025c9:	75 c0                	jne    f010258b <mem_init+0xe1e>
	pgdir = kern_pgdir;
f01025cb:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f01025d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01025d3:	a1 48 cd 5d f0       	mov    0xf05dcd48,%eax
f01025d8:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01025db:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01025e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025ea:	8b 35 50 cd 5d f0    	mov    0xf05dcd50,%esi
f01025f0:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01025f3:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01025f9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01025fc:	89 fb                	mov    %edi,%ebx
f01025fe:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0102601:	0f 86 73 07 00 00    	jbe    f0102d7a <mem_init+0x160d>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102607:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f010260d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102610:	e8 e3 e7 ff ff       	call   f0100df8 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102615:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f010261c:	0f 86 2a 07 00 00    	jbe    f0102d4c <mem_init+0x15df>
f0102622:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102625:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102628:	39 d0                	cmp    %edx,%eax
f010262a:	0f 85 31 07 00 00    	jne    f0102d61 <mem_init+0x15f4>
	for (i = 0; i < n; i += PGSIZE)
f0102630:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102636:	eb c6                	jmp    f01025fe <mem_init+0xe91>
	assert(nfree == 0);
f0102638:	68 fb 97 10 f0       	push   $0xf01097fb
f010263d:	68 0b 96 10 f0       	push   $0xf010960b
f0102642:	68 5b 03 00 00       	push   $0x35b
f0102647:	68 e5 95 10 f0       	push   $0xf01095e5
f010264c:	e8 f8 d9 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0102651:	68 09 97 10 f0       	push   $0xf0109709
f0102656:	68 0b 96 10 f0       	push   $0xf010960b
f010265b:	68 ce 03 00 00       	push   $0x3ce
f0102660:	68 e5 95 10 f0       	push   $0xf01095e5
f0102665:	e8 df d9 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010266a:	68 1f 97 10 f0       	push   $0xf010971f
f010266f:	68 0b 96 10 f0       	push   $0xf010960b
f0102674:	68 cf 03 00 00       	push   $0x3cf
f0102679:	68 e5 95 10 f0       	push   $0xf01095e5
f010267e:	e8 c6 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0102683:	68 35 97 10 f0       	push   $0xf0109735
f0102688:	68 0b 96 10 f0       	push   $0xf010960b
f010268d:	68 d0 03 00 00       	push   $0x3d0
f0102692:	68 e5 95 10 f0       	push   $0xf01095e5
f0102697:	e8 ad d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f010269c:	68 4b 97 10 f0       	push   $0xf010974b
f01026a1:	68 0b 96 10 f0       	push   $0xf010960b
f01026a6:	68 d3 03 00 00       	push   $0x3d3
f01026ab:	68 e5 95 10 f0       	push   $0xf01095e5
f01026b0:	e8 94 d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01026b5:	68 8c 8d 10 f0       	push   $0xf0108d8c
f01026ba:	68 0b 96 10 f0       	push   $0xf010960b
f01026bf:	68 d4 03 00 00       	push   $0x3d4
f01026c4:	68 e5 95 10 f0       	push   $0xf01095e5
f01026c9:	e8 7b d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01026ce:	68 b4 97 10 f0       	push   $0xf01097b4
f01026d3:	68 0b 96 10 f0       	push   $0xf010960b
f01026d8:	68 db 03 00 00       	push   $0x3db
f01026dd:	68 e5 95 10 f0       	push   $0xf01095e5
f01026e2:	e8 62 d9 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01026e7:	68 cc 8d 10 f0       	push   $0xf0108dcc
f01026ec:	68 0b 96 10 f0       	push   $0xf010960b
f01026f1:	68 de 03 00 00       	push   $0x3de
f01026f6:	68 e5 95 10 f0       	push   $0xf01095e5
f01026fb:	e8 49 d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102700:	68 04 8e 10 f0       	push   $0xf0108e04
f0102705:	68 0b 96 10 f0       	push   $0xf010960b
f010270a:	68 e1 03 00 00       	push   $0x3e1
f010270f:	68 e5 95 10 f0       	push   $0xf01095e5
f0102714:	e8 30 d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102719:	68 34 8e 10 f0       	push   $0xf0108e34
f010271e:	68 0b 96 10 f0       	push   $0xf010960b
f0102723:	68 e5 03 00 00       	push   $0x3e5
f0102728:	68 e5 95 10 f0       	push   $0xf01095e5
f010272d:	e8 17 d9 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102732:	68 64 8e 10 f0       	push   $0xf0108e64
f0102737:	68 0b 96 10 f0       	push   $0xf010960b
f010273c:	68 e6 03 00 00       	push   $0x3e6
f0102741:	68 e5 95 10 f0       	push   $0xf01095e5
f0102746:	e8 fe d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010274b:	68 8c 8e 10 f0       	push   $0xf0108e8c
f0102750:	68 0b 96 10 f0       	push   $0xf010960b
f0102755:	68 e7 03 00 00       	push   $0x3e7
f010275a:	68 e5 95 10 f0       	push   $0xf01095e5
f010275f:	e8 e5 d8 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102764:	68 06 98 10 f0       	push   $0xf0109806
f0102769:	68 0b 96 10 f0       	push   $0xf010960b
f010276e:	68 e8 03 00 00       	push   $0x3e8
f0102773:	68 e5 95 10 f0       	push   $0xf01095e5
f0102778:	e8 cc d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f010277d:	68 17 98 10 f0       	push   $0xf0109817
f0102782:	68 0b 96 10 f0       	push   $0xf010960b
f0102787:	68 e9 03 00 00       	push   $0x3e9
f010278c:	68 e5 95 10 f0       	push   $0xf01095e5
f0102791:	e8 b3 d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102796:	68 bc 8e 10 f0       	push   $0xf0108ebc
f010279b:	68 0b 96 10 f0       	push   $0xf010960b
f01027a0:	68 ec 03 00 00       	push   $0x3ec
f01027a5:	68 e5 95 10 f0       	push   $0xf01095e5
f01027aa:	e8 9a d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027af:	68 f8 8e 10 f0       	push   $0xf0108ef8
f01027b4:	68 0b 96 10 f0       	push   $0xf010960b
f01027b9:	68 ed 03 00 00       	push   $0x3ed
f01027be:	68 e5 95 10 f0       	push   $0xf01095e5
f01027c3:	e8 81 d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01027c8:	68 28 98 10 f0       	push   $0xf0109828
f01027cd:	68 0b 96 10 f0       	push   $0xf010960b
f01027d2:	68 ee 03 00 00       	push   $0x3ee
f01027d7:	68 e5 95 10 f0       	push   $0xf01095e5
f01027dc:	e8 68 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01027e1:	68 b4 97 10 f0       	push   $0xf01097b4
f01027e6:	68 0b 96 10 f0       	push   $0xf010960b
f01027eb:	68 f1 03 00 00       	push   $0x3f1
f01027f0:	68 e5 95 10 f0       	push   $0xf01095e5
f01027f5:	e8 4f d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027fa:	68 bc 8e 10 f0       	push   $0xf0108ebc
f01027ff:	68 0b 96 10 f0       	push   $0xf010960b
f0102804:	68 f4 03 00 00       	push   $0x3f4
f0102809:	68 e5 95 10 f0       	push   $0xf01095e5
f010280e:	e8 36 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102813:	68 f8 8e 10 f0       	push   $0xf0108ef8
f0102818:	68 0b 96 10 f0       	push   $0xf010960b
f010281d:	68 f5 03 00 00       	push   $0x3f5
f0102822:	68 e5 95 10 f0       	push   $0xf01095e5
f0102827:	e8 1d d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010282c:	68 28 98 10 f0       	push   $0xf0109828
f0102831:	68 0b 96 10 f0       	push   $0xf010960b
f0102836:	68 f6 03 00 00       	push   $0x3f6
f010283b:	68 e5 95 10 f0       	push   $0xf01095e5
f0102840:	e8 04 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102845:	68 b4 97 10 f0       	push   $0xf01097b4
f010284a:	68 0b 96 10 f0       	push   $0xf010960b
f010284f:	68 fa 03 00 00       	push   $0x3fa
f0102854:	68 e5 95 10 f0       	push   $0xf01095e5
f0102859:	e8 eb d7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010285e:	50                   	push   %eax
f010285f:	68 34 84 10 f0       	push   $0xf0108434
f0102864:	68 fd 03 00 00       	push   $0x3fd
f0102869:	68 e5 95 10 f0       	push   $0xf01095e5
f010286e:	e8 d6 d7 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102873:	68 28 8f 10 f0       	push   $0xf0108f28
f0102878:	68 0b 96 10 f0       	push   $0xf010960b
f010287d:	68 fe 03 00 00       	push   $0x3fe
f0102882:	68 e5 95 10 f0       	push   $0xf01095e5
f0102887:	e8 bd d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010288c:	68 68 8f 10 f0       	push   $0xf0108f68
f0102891:	68 0b 96 10 f0       	push   $0xf010960b
f0102896:	68 01 04 00 00       	push   $0x401
f010289b:	68 e5 95 10 f0       	push   $0xf01095e5
f01028a0:	e8 a4 d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01028a5:	68 f8 8e 10 f0       	push   $0xf0108ef8
f01028aa:	68 0b 96 10 f0       	push   $0xf010960b
f01028af:	68 02 04 00 00       	push   $0x402
f01028b4:	68 e5 95 10 f0       	push   $0xf01095e5
f01028b9:	e8 8b d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01028be:	68 28 98 10 f0       	push   $0xf0109828
f01028c3:	68 0b 96 10 f0       	push   $0xf010960b
f01028c8:	68 03 04 00 00       	push   $0x403
f01028cd:	68 e5 95 10 f0       	push   $0xf01095e5
f01028d2:	e8 72 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01028d7:	68 a8 8f 10 f0       	push   $0xf0108fa8
f01028dc:	68 0b 96 10 f0       	push   $0xf010960b
f01028e1:	68 04 04 00 00       	push   $0x404
f01028e6:	68 e5 95 10 f0       	push   $0xf01095e5
f01028eb:	e8 59 d7 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01028f0:	68 39 98 10 f0       	push   $0xf0109839
f01028f5:	68 0b 96 10 f0       	push   $0xf010960b
f01028fa:	68 05 04 00 00       	push   $0x405
f01028ff:	68 e5 95 10 f0       	push   $0xf01095e5
f0102904:	e8 40 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102909:	68 bc 8e 10 f0       	push   $0xf0108ebc
f010290e:	68 0b 96 10 f0       	push   $0xf010960b
f0102913:	68 08 04 00 00       	push   $0x408
f0102918:	68 e5 95 10 f0       	push   $0xf01095e5
f010291d:	e8 27 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102922:	68 dc 8f 10 f0       	push   $0xf0108fdc
f0102927:	68 0b 96 10 f0       	push   $0xf010960b
f010292c:	68 09 04 00 00       	push   $0x409
f0102931:	68 e5 95 10 f0       	push   $0xf01095e5
f0102936:	e8 0e d7 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010293b:	68 10 90 10 f0       	push   $0xf0109010
f0102940:	68 0b 96 10 f0       	push   $0xf010960b
f0102945:	68 0a 04 00 00       	push   $0x40a
f010294a:	68 e5 95 10 f0       	push   $0xf01095e5
f010294f:	e8 f5 d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102954:	68 48 90 10 f0       	push   $0xf0109048
f0102959:	68 0b 96 10 f0       	push   $0xf010960b
f010295e:	68 0d 04 00 00       	push   $0x40d
f0102963:	68 e5 95 10 f0       	push   $0xf01095e5
f0102968:	e8 dc d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010296d:	68 80 90 10 f0       	push   $0xf0109080
f0102972:	68 0b 96 10 f0       	push   $0xf010960b
f0102977:	68 10 04 00 00       	push   $0x410
f010297c:	68 e5 95 10 f0       	push   $0xf01095e5
f0102981:	e8 c3 d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102986:	68 10 90 10 f0       	push   $0xf0109010
f010298b:	68 0b 96 10 f0       	push   $0xf010960b
f0102990:	68 11 04 00 00       	push   $0x411
f0102995:	68 e5 95 10 f0       	push   $0xf01095e5
f010299a:	e8 aa d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010299f:	68 bc 90 10 f0       	push   $0xf01090bc
f01029a4:	68 0b 96 10 f0       	push   $0xf010960b
f01029a9:	68 14 04 00 00       	push   $0x414
f01029ae:	68 e5 95 10 f0       	push   $0xf01095e5
f01029b3:	e8 91 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01029b8:	68 e8 90 10 f0       	push   $0xf01090e8
f01029bd:	68 0b 96 10 f0       	push   $0xf010960b
f01029c2:	68 15 04 00 00       	push   $0x415
f01029c7:	68 e5 95 10 f0       	push   $0xf01095e5
f01029cc:	e8 78 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f01029d1:	68 4f 98 10 f0       	push   $0xf010984f
f01029d6:	68 0b 96 10 f0       	push   $0xf010960b
f01029db:	68 17 04 00 00       	push   $0x417
f01029e0:	68 e5 95 10 f0       	push   $0xf01095e5
f01029e5:	e8 5f d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01029ea:	68 60 98 10 f0       	push   $0xf0109860
f01029ef:	68 0b 96 10 f0       	push   $0xf010960b
f01029f4:	68 18 04 00 00       	push   $0x418
f01029f9:	68 e5 95 10 f0       	push   $0xf01095e5
f01029fe:	e8 46 d6 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102a03:	68 18 91 10 f0       	push   $0xf0109118
f0102a08:	68 0b 96 10 f0       	push   $0xf010960b
f0102a0d:	68 1b 04 00 00       	push   $0x41b
f0102a12:	68 e5 95 10 f0       	push   $0xf01095e5
f0102a17:	e8 2d d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a1c:	68 3c 91 10 f0       	push   $0xf010913c
f0102a21:	68 0b 96 10 f0       	push   $0xf010960b
f0102a26:	68 1f 04 00 00       	push   $0x41f
f0102a2b:	68 e5 95 10 f0       	push   $0xf01095e5
f0102a30:	e8 14 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a35:	68 e8 90 10 f0       	push   $0xf01090e8
f0102a3a:	68 0b 96 10 f0       	push   $0xf010960b
f0102a3f:	68 20 04 00 00       	push   $0x420
f0102a44:	68 e5 95 10 f0       	push   $0xf01095e5
f0102a49:	e8 fb d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102a4e:	68 06 98 10 f0       	push   $0xf0109806
f0102a53:	68 0b 96 10 f0       	push   $0xf010960b
f0102a58:	68 21 04 00 00       	push   $0x421
f0102a5d:	68 e5 95 10 f0       	push   $0xf01095e5
f0102a62:	e8 e2 d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a67:	68 60 98 10 f0       	push   $0xf0109860
f0102a6c:	68 0b 96 10 f0       	push   $0xf010960b
f0102a71:	68 22 04 00 00       	push   $0x422
f0102a76:	68 e5 95 10 f0       	push   $0xf01095e5
f0102a7b:	e8 c9 d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102a80:	68 60 91 10 f0       	push   $0xf0109160
f0102a85:	68 0b 96 10 f0       	push   $0xf010960b
f0102a8a:	68 25 04 00 00       	push   $0x425
f0102a8f:	68 e5 95 10 f0       	push   $0xf01095e5
f0102a94:	e8 b0 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102a99:	68 71 98 10 f0       	push   $0xf0109871
f0102a9e:	68 0b 96 10 f0       	push   $0xf010960b
f0102aa3:	68 26 04 00 00       	push   $0x426
f0102aa8:	68 e5 95 10 f0       	push   $0xf01095e5
f0102aad:	e8 97 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102ab2:	68 7d 98 10 f0       	push   $0xf010987d
f0102ab7:	68 0b 96 10 f0       	push   $0xf010960b
f0102abc:	68 27 04 00 00       	push   $0x427
f0102ac1:	68 e5 95 10 f0       	push   $0xf01095e5
f0102ac6:	e8 7e d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102acb:	68 3c 91 10 f0       	push   $0xf010913c
f0102ad0:	68 0b 96 10 f0       	push   $0xf010960b
f0102ad5:	68 2b 04 00 00       	push   $0x42b
f0102ada:	68 e5 95 10 f0       	push   $0xf01095e5
f0102adf:	e8 65 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102ae4:	68 98 91 10 f0       	push   $0xf0109198
f0102ae9:	68 0b 96 10 f0       	push   $0xf010960b
f0102aee:	68 2c 04 00 00       	push   $0x42c
f0102af3:	68 e5 95 10 f0       	push   $0xf01095e5
f0102af8:	e8 4c d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102afd:	68 92 98 10 f0       	push   $0xf0109892
f0102b02:	68 0b 96 10 f0       	push   $0xf010960b
f0102b07:	68 2d 04 00 00       	push   $0x42d
f0102b0c:	68 e5 95 10 f0       	push   $0xf01095e5
f0102b11:	e8 33 d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102b16:	68 60 98 10 f0       	push   $0xf0109860
f0102b1b:	68 0b 96 10 f0       	push   $0xf010960b
f0102b20:	68 2e 04 00 00       	push   $0x42e
f0102b25:	68 e5 95 10 f0       	push   $0xf01095e5
f0102b2a:	e8 1a d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b2f:	68 c0 91 10 f0       	push   $0xf01091c0
f0102b34:	68 0b 96 10 f0       	push   $0xf010960b
f0102b39:	68 31 04 00 00       	push   $0x431
f0102b3e:	68 e5 95 10 f0       	push   $0xf01095e5
f0102b43:	e8 01 d5 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102b48:	68 b4 97 10 f0       	push   $0xf01097b4
f0102b4d:	68 0b 96 10 f0       	push   $0xf010960b
f0102b52:	68 34 04 00 00       	push   $0x434
f0102b57:	68 e5 95 10 f0       	push   $0xf01095e5
f0102b5c:	e8 e8 d4 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b61:	68 64 8e 10 f0       	push   $0xf0108e64
f0102b66:	68 0b 96 10 f0       	push   $0xf010960b
f0102b6b:	68 37 04 00 00       	push   $0x437
f0102b70:	68 e5 95 10 f0       	push   $0xf01095e5
f0102b75:	e8 cf d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102b7a:	68 17 98 10 f0       	push   $0xf0109817
f0102b7f:	68 0b 96 10 f0       	push   $0xf010960b
f0102b84:	68 39 04 00 00       	push   $0x439
f0102b89:	68 e5 95 10 f0       	push   $0xf01095e5
f0102b8e:	e8 b6 d4 ff ff       	call   f0100049 <_panic>
f0102b93:	50                   	push   %eax
f0102b94:	68 34 84 10 f0       	push   $0xf0108434
f0102b99:	68 40 04 00 00       	push   $0x440
f0102b9e:	68 e5 95 10 f0       	push   $0xf01095e5
f0102ba3:	e8 a1 d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102ba8:	68 a3 98 10 f0       	push   $0xf01098a3
f0102bad:	68 0b 96 10 f0       	push   $0xf010960b
f0102bb2:	68 41 04 00 00       	push   $0x441
f0102bb7:	68 e5 95 10 f0       	push   $0xf01095e5
f0102bbc:	e8 88 d4 ff ff       	call   f0100049 <_panic>
f0102bc1:	50                   	push   %eax
f0102bc2:	68 34 84 10 f0       	push   $0xf0108434
f0102bc7:	6a 58                	push   $0x58
f0102bc9:	68 f1 95 10 f0       	push   $0xf01095f1
f0102bce:	e8 76 d4 ff ff       	call   f0100049 <_panic>
f0102bd3:	50                   	push   %eax
f0102bd4:	68 34 84 10 f0       	push   $0xf0108434
f0102bd9:	6a 58                	push   $0x58
f0102bdb:	68 f1 95 10 f0       	push   $0xf01095f1
f0102be0:	e8 64 d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102be5:	68 bb 98 10 f0       	push   $0xf01098bb
f0102bea:	68 0b 96 10 f0       	push   $0xf010960b
f0102bef:	68 4b 04 00 00       	push   $0x44b
f0102bf4:	68 e5 95 10 f0       	push   $0xf01095e5
f0102bf9:	e8 4b d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102bfe:	68 e4 91 10 f0       	push   $0xf01091e4
f0102c03:	68 0b 96 10 f0       	push   $0xf010960b
f0102c08:	68 5b 04 00 00       	push   $0x45b
f0102c0d:	68 e5 95 10 f0       	push   $0xf01095e5
f0102c12:	e8 32 d4 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102c17:	68 0c 92 10 f0       	push   $0xf010920c
f0102c1c:	68 0b 96 10 f0       	push   $0xf010960b
f0102c21:	68 5c 04 00 00       	push   $0x45c
f0102c26:	68 e5 95 10 f0       	push   $0xf01095e5
f0102c2b:	e8 19 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c30:	68 34 92 10 f0       	push   $0xf0109234
f0102c35:	68 0b 96 10 f0       	push   $0xf010960b
f0102c3a:	68 5e 04 00 00       	push   $0x45e
f0102c3f:	68 e5 95 10 f0       	push   $0xf01095e5
f0102c44:	e8 00 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102c49:	68 d2 98 10 f0       	push   $0xf01098d2
f0102c4e:	68 0b 96 10 f0       	push   $0xf010960b
f0102c53:	68 60 04 00 00       	push   $0x460
f0102c58:	68 e5 95 10 f0       	push   $0xf01095e5
f0102c5d:	e8 e7 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c62:	68 5c 92 10 f0       	push   $0xf010925c
f0102c67:	68 0b 96 10 f0       	push   $0xf010960b
f0102c6c:	68 62 04 00 00       	push   $0x462
f0102c71:	68 e5 95 10 f0       	push   $0xf01095e5
f0102c76:	e8 ce d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c7b:	68 80 92 10 f0       	push   $0xf0109280
f0102c80:	68 0b 96 10 f0       	push   $0xf010960b
f0102c85:	68 63 04 00 00       	push   $0x463
f0102c8a:	68 e5 95 10 f0       	push   $0xf01095e5
f0102c8f:	e8 b5 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c94:	68 b0 92 10 f0       	push   $0xf01092b0
f0102c99:	68 0b 96 10 f0       	push   $0xf010960b
f0102c9e:	68 64 04 00 00       	push   $0x464
f0102ca3:	68 e5 95 10 f0       	push   $0xf01095e5
f0102ca8:	e8 9c d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102cad:	68 d4 92 10 f0       	push   $0xf01092d4
f0102cb2:	68 0b 96 10 f0       	push   $0xf010960b
f0102cb7:	68 65 04 00 00       	push   $0x465
f0102cbc:	68 e5 95 10 f0       	push   $0xf01095e5
f0102cc1:	e8 83 d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102cc6:	68 00 93 10 f0       	push   $0xf0109300
f0102ccb:	68 0b 96 10 f0       	push   $0xf010960b
f0102cd0:	68 67 04 00 00       	push   $0x467
f0102cd5:	68 e5 95 10 f0       	push   $0xf01095e5
f0102cda:	e8 6a d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102cdf:	68 44 93 10 f0       	push   $0xf0109344
f0102ce4:	68 0b 96 10 f0       	push   $0xf010960b
f0102ce9:	68 68 04 00 00       	push   $0x468
f0102cee:	68 e5 95 10 f0       	push   $0xf01095e5
f0102cf3:	e8 51 d3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102cf8:	50                   	push   %eax
f0102cf9:	68 58 84 10 f0       	push   $0xf0108458
f0102cfe:	68 bf 00 00 00       	push   $0xbf
f0102d03:	68 e5 95 10 f0       	push   $0xf01095e5
f0102d08:	e8 3c d3 ff ff       	call   f0100049 <_panic>
f0102d0d:	50                   	push   %eax
f0102d0e:	68 58 84 10 f0       	push   $0xf0108458
f0102d13:	68 c7 00 00 00       	push   $0xc7
f0102d18:	68 e5 95 10 f0       	push   $0xf01095e5
f0102d1d:	e8 27 d3 ff ff       	call   f0100049 <_panic>
f0102d22:	50                   	push   %eax
f0102d23:	68 58 84 10 f0       	push   $0xf0108458
f0102d28:	68 d3 00 00 00       	push   $0xd3
f0102d2d:	68 e5 95 10 f0       	push   $0xf01095e5
f0102d32:	e8 12 d3 ff ff       	call   f0100049 <_panic>
f0102d37:	53                   	push   %ebx
f0102d38:	68 58 84 10 f0       	push   $0xf0108458
f0102d3d:	68 1a 01 00 00       	push   $0x11a
f0102d42:	68 e5 95 10 f0       	push   $0xf01095e5
f0102d47:	e8 fd d2 ff ff       	call   f0100049 <_panic>
f0102d4c:	56                   	push   %esi
f0102d4d:	68 58 84 10 f0       	push   $0xf0108458
f0102d52:	68 72 03 00 00       	push   $0x372
f0102d57:	68 e5 95 10 f0       	push   $0xf01095e5
f0102d5c:	e8 e8 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d61:	68 78 93 10 f0       	push   $0xf0109378
f0102d66:	68 0b 96 10 f0       	push   $0xf010960b
f0102d6b:	68 72 03 00 00       	push   $0x372
f0102d70:	68 e5 95 10 f0       	push   $0xf01095e5
f0102d75:	e8 cf d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102d7a:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
f0102d7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102d82:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102d85:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102d8a:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102d90:	89 da                	mov    %ebx,%edx
f0102d92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d95:	e8 5e e0 ff ff       	call   f0100df8 <check_va2pa>
f0102d9a:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102da1:	76 45                	jbe    f0102de8 <mem_init+0x167b>
f0102da3:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102da6:	39 d0                	cmp    %edx,%eax
f0102da8:	75 55                	jne    f0102dff <mem_init+0x1692>
f0102daa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102db0:	81 fb 00 10 c2 ee    	cmp    $0xeec21000,%ebx
f0102db6:	75 d8                	jne    f0102d90 <mem_init+0x1623>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102db8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102dbb:	8b 81 00 0f 00 00    	mov    0xf00(%ecx),%eax
f0102dc1:	89 c2                	mov    %eax,%edx
f0102dc3:	81 e2 81 00 00 00    	and    $0x81,%edx
f0102dc9:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f0102dcf:	0f 85 75 01 00 00    	jne    f0102f4a <mem_init+0x17dd>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f0102dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102dda:	0f 85 6a 01 00 00    	jne    f0102f4a <mem_init+0x17dd>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102de0:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102de3:	c1 e6 0c             	shl    $0xc,%esi
f0102de6:	eb 3f                	jmp    f0102e27 <mem_init+0x16ba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102de8:	ff 75 c8             	pushl  -0x38(%ebp)
f0102deb:	68 58 84 10 f0       	push   $0xf0108458
f0102df0:	68 77 03 00 00       	push   $0x377
f0102df5:	68 e5 95 10 f0       	push   $0xf01095e5
f0102dfa:	e8 4a d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102dff:	68 ac 93 10 f0       	push   $0xf01093ac
f0102e04:	68 0b 96 10 f0       	push   $0xf010960b
f0102e09:	68 77 03 00 00       	push   $0x377
f0102e0e:	68 e5 95 10 f0       	push   $0xf01095e5
f0102e13:	e8 31 d2 ff ff       	call   f0100049 <_panic>
	return PTE_ADDR(*pgdir);
f0102e18:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e1e:	39 d0                	cmp    %edx,%eax
f0102e20:	75 25                	jne    f0102e47 <mem_init+0x16da>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102e22:	05 00 00 40 00       	add    $0x400000,%eax
f0102e27:	39 f0                	cmp    %esi,%eax
f0102e29:	73 35                	jae    f0102e60 <mem_init+0x16f3>
	pgdir = &pgdir[PDX(va)];
f0102e2b:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102e31:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102e34:	8b 14 91             	mov    (%ecx,%edx,4),%edx
f0102e37:	89 d3                	mov    %edx,%ebx
f0102e39:	81 e3 81 00 00 00    	and    $0x81,%ebx
f0102e3f:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
f0102e45:	74 d1                	je     f0102e18 <mem_init+0x16ab>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e47:	68 e0 93 10 f0       	push   $0xf01093e0
f0102e4c:	68 0b 96 10 f0       	push   $0xf010960b
f0102e51:	68 7c 03 00 00       	push   $0x37c
f0102e56:	68 e5 95 10 f0       	push   $0xf01095e5
f0102e5b:	e8 e9 d1 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102e60:	83 ec 0c             	sub    $0xc,%esp
f0102e63:	68 fd 98 10 f0       	push   $0xf01098fd
f0102e68:	e8 94 17 00 00       	call   f0104601 <cprintf>
f0102e6d:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e70:	b8 00 b0 12 f0       	mov    $0xf012b000,%eax
f0102e75:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102e7a:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102e7d:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e7f:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102e82:	89 f3                	mov    %esi,%ebx
f0102e84:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e87:	05 00 80 00 20       	add    $0x20008000,%eax
f0102e8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102e8f:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102e95:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e98:	89 da                	mov    %ebx,%edx
f0102e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e9d:	e8 56 df ff ff       	call   f0100df8 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102ea2:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102ea8:	0f 86 a6 00 00 00    	jbe    f0102f54 <mem_init+0x17e7>
f0102eae:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102eb1:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102eb4:	39 d0                	cmp    %edx,%eax
f0102eb6:	0f 85 af 00 00 00    	jne    f0102f6b <mem_init+0x17fe>
f0102ebc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102ec2:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0102ec5:	75 d1                	jne    f0102e98 <mem_init+0x172b>
f0102ec7:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102ecd:	89 da                	mov    %ebx,%edx
f0102ecf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ed2:	e8 21 df ff ff       	call   f0100df8 <check_va2pa>
f0102ed7:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102eda:	0f 85 a4 00 00 00    	jne    f0102f84 <mem_init+0x1817>
f0102ee0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102ee6:	39 f3                	cmp    %esi,%ebx
f0102ee8:	75 e3                	jne    f0102ecd <mem_init+0x1760>
f0102eea:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102ef0:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102ef7:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f0102efd:	81 ff 00 b0 16 f0    	cmp    $0xf016b000,%edi
f0102f03:	0f 85 76 ff ff ff    	jne    f0102e7f <mem_init+0x1712>
f0102f09:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0102f0c:	e9 c7 00 00 00       	jmp    f0102fd8 <mem_init+0x186b>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102f17:	39 f3                	cmp    %esi,%ebx
f0102f19:	0f 83 51 ff ff ff    	jae    f0102e70 <mem_init+0x1703>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102f1f:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102f25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f28:	e8 cb de ff ff       	call   f0100df8 <check_va2pa>
f0102f2d:	39 c3                	cmp    %eax,%ebx
f0102f2f:	74 e0                	je     f0102f11 <mem_init+0x17a4>
f0102f31:	68 0c 94 10 f0       	push   $0xf010940c
f0102f36:	68 0b 96 10 f0       	push   $0xf010960b
f0102f3b:	68 81 03 00 00       	push   $0x381
f0102f40:	68 e5 95 10 f0       	push   $0xf01095e5
f0102f45:	e8 ff d0 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f4a:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f4d:	c1 e6 0c             	shl    $0xc,%esi
f0102f50:	89 fb                	mov    %edi,%ebx
f0102f52:	eb c3                	jmp    f0102f17 <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f54:	ff 75 c0             	pushl  -0x40(%ebp)
f0102f57:	68 58 84 10 f0       	push   $0xf0108458
f0102f5c:	68 89 03 00 00       	push   $0x389
f0102f61:	68 e5 95 10 f0       	push   $0xf01095e5
f0102f66:	e8 de d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102f6b:	68 34 94 10 f0       	push   $0xf0109434
f0102f70:	68 0b 96 10 f0       	push   $0xf010960b
f0102f75:	68 89 03 00 00       	push   $0x389
f0102f7a:	68 e5 95 10 f0       	push   $0xf01095e5
f0102f7f:	e8 c5 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f84:	68 7c 94 10 f0       	push   $0xf010947c
f0102f89:	68 0b 96 10 f0       	push   $0xf010960b
f0102f8e:	68 8b 03 00 00       	push   $0x38b
f0102f93:	68 e5 95 10 f0       	push   $0xf01095e5
f0102f98:	e8 ac d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0102f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fa0:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102fa4:	75 4e                	jne    f0102ff4 <mem_init+0x1887>
f0102fa6:	68 14 99 10 f0       	push   $0xf0109914
f0102fab:	68 0b 96 10 f0       	push   $0xf010960b
f0102fb0:	68 96 03 00 00       	push   $0x396
f0102fb5:	68 e5 95 10 f0       	push   $0xf01095e5
f0102fba:	e8 8a d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_P);
f0102fbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fc2:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102fc5:	a8 01                	test   $0x1,%al
f0102fc7:	74 30                	je     f0102ff9 <mem_init+0x188c>
				assert(pgdir[i] & PTE_W);
f0102fc9:	a8 02                	test   $0x2,%al
f0102fcb:	74 45                	je     f0103012 <mem_init+0x18a5>
	for (i = 0; i < NPDENTRIES; i++) {
f0102fcd:	83 c7 01             	add    $0x1,%edi
f0102fd0:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102fd6:	74 6c                	je     f0103044 <mem_init+0x18d7>
		switch (i) {
f0102fd8:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102fde:	83 f8 04             	cmp    $0x4,%eax
f0102fe1:	76 ba                	jbe    f0102f9d <mem_init+0x1830>
			if (i >= PDX(KERNBASE)) {
f0102fe3:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102fe9:	77 d4                	ja     f0102fbf <mem_init+0x1852>
				assert(pgdir[i] == 0);
f0102feb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fee:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102ff2:	75 37                	jne    f010302b <mem_init+0x18be>
	for (i = 0; i < NPDENTRIES; i++) {
f0102ff4:	83 c7 01             	add    $0x1,%edi
f0102ff7:	eb df                	jmp    f0102fd8 <mem_init+0x186b>
				assert(pgdir[i] & PTE_P);
f0102ff9:	68 14 99 10 f0       	push   $0xf0109914
f0102ffe:	68 0b 96 10 f0       	push   $0xf010960b
f0103003:	68 9a 03 00 00       	push   $0x39a
f0103008:	68 e5 95 10 f0       	push   $0xf01095e5
f010300d:	e8 37 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0103012:	68 25 99 10 f0       	push   $0xf0109925
f0103017:	68 0b 96 10 f0       	push   $0xf010960b
f010301c:	68 9b 03 00 00       	push   $0x39b
f0103021:	68 e5 95 10 f0       	push   $0xf01095e5
f0103026:	e8 1e d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f010302b:	68 36 99 10 f0       	push   $0xf0109936
f0103030:	68 0b 96 10 f0       	push   $0xf010960b
f0103035:	68 9d 03 00 00       	push   $0x39d
f010303a:	68 e5 95 10 f0       	push   $0xf01095e5
f010303f:	e8 05 d0 ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103044:	83 ec 0c             	sub    $0xc,%esp
f0103047:	68 a0 94 10 f0       	push   $0xf01094a0
f010304c:	e8 b0 15 00 00       	call   f0104601 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f0103051:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f0103054:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f0103057:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f010305a:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
	if ((uint32_t)kva < KERNBASE)
f010305f:	83 c4 10             	add    $0x10,%esp
f0103062:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103067:	0f 86 1f 02 00 00    	jbe    f010328c <mem_init+0x1b1f>
	return (physaddr_t)kva - KERNBASE;
f010306d:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103072:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0103075:	b8 00 00 00 00       	mov    $0x0,%eax
f010307a:	e8 83 de ff ff       	call   f0100f02 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f010307f:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103082:	83 e0 f3             	and    $0xfffffff3,%eax
f0103085:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f010308a:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f010308d:	83 ec 0c             	sub    $0xc,%esp
f0103090:	6a 00                	push   $0x0
f0103092:	e8 58 e2 ff ff       	call   f01012ef <page_alloc>
f0103097:	89 c6                	mov    %eax,%esi
f0103099:	83 c4 10             	add    $0x10,%esp
f010309c:	85 c0                	test   %eax,%eax
f010309e:	0f 84 fd 01 00 00    	je     f01032a1 <mem_init+0x1b34>
	assert((pp1 = page_alloc(0)));
f01030a4:	83 ec 0c             	sub    $0xc,%esp
f01030a7:	6a 00                	push   $0x0
f01030a9:	e8 41 e2 ff ff       	call   f01012ef <page_alloc>
f01030ae:	89 c7                	mov    %eax,%edi
f01030b0:	83 c4 10             	add    $0x10,%esp
f01030b3:	85 c0                	test   %eax,%eax
f01030b5:	0f 84 ff 01 00 00    	je     f01032ba <mem_init+0x1b4d>
	assert((pp2 = page_alloc(0)));
f01030bb:	83 ec 0c             	sub    $0xc,%esp
f01030be:	6a 00                	push   $0x0
f01030c0:	e8 2a e2 ff ff       	call   f01012ef <page_alloc>
f01030c5:	89 c3                	mov    %eax,%ebx
f01030c7:	83 c4 10             	add    $0x10,%esp
f01030ca:	85 c0                	test   %eax,%eax
f01030cc:	0f 84 01 02 00 00    	je     f01032d3 <mem_init+0x1b66>
	page_free(pp0);
f01030d2:	83 ec 0c             	sub    $0xc,%esp
f01030d5:	56                   	push   %esi
f01030d6:	e8 86 e2 ff ff       	call   f0101361 <page_free>
	return (pp - pages) << PGSHIFT;
f01030db:	89 f8                	mov    %edi,%eax
f01030dd:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f01030e3:	c1 f8 03             	sar    $0x3,%eax
f01030e6:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030e9:	89 c2                	mov    %eax,%edx
f01030eb:	c1 ea 0c             	shr    $0xc,%edx
f01030ee:	83 c4 10             	add    $0x10,%esp
f01030f1:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f01030f7:	0f 83 ef 01 00 00    	jae    f01032ec <mem_init+0x1b7f>
	memset(page2kva(pp1), 1, PGSIZE);
f01030fd:	83 ec 04             	sub    $0x4,%esp
f0103100:	68 00 10 00 00       	push   $0x1000
f0103105:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0103107:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010310c:	50                   	push   %eax
f010310d:	e8 fd 3b 00 00       	call   f0106d0f <memset>
	return (pp - pages) << PGSHIFT;
f0103112:	89 d8                	mov    %ebx,%eax
f0103114:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f010311a:	c1 f8 03             	sar    $0x3,%eax
f010311d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103120:	89 c2                	mov    %eax,%edx
f0103122:	c1 ea 0c             	shr    $0xc,%edx
f0103125:	83 c4 10             	add    $0x10,%esp
f0103128:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f010312e:	0f 83 ca 01 00 00    	jae    f01032fe <mem_init+0x1b91>
	memset(page2kva(pp2), 2, PGSIZE);
f0103134:	83 ec 04             	sub    $0x4,%esp
f0103137:	68 00 10 00 00       	push   $0x1000
f010313c:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f010313e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103143:	50                   	push   %eax
f0103144:	e8 c6 3b 00 00       	call   f0106d0f <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0103149:	6a 02                	push   $0x2
f010314b:	68 00 10 00 00       	push   $0x1000
f0103150:	57                   	push   %edi
f0103151:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0103157:	e8 cf e4 ff ff       	call   f010162b <page_insert>
	assert(pp1->pp_ref == 1);
f010315c:	83 c4 20             	add    $0x20,%esp
f010315f:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103164:	0f 85 a6 01 00 00    	jne    f0103310 <mem_init+0x1ba3>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f010316a:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0103171:	01 01 01 
f0103174:	0f 85 af 01 00 00    	jne    f0103329 <mem_init+0x1bbc>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f010317a:	6a 02                	push   $0x2
f010317c:	68 00 10 00 00       	push   $0x1000
f0103181:	53                   	push   %ebx
f0103182:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0103188:	e8 9e e4 ff ff       	call   f010162b <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f010318d:	83 c4 10             	add    $0x10,%esp
f0103190:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103197:	02 02 02 
f010319a:	0f 85 a2 01 00 00    	jne    f0103342 <mem_init+0x1bd5>
	assert(pp2->pp_ref == 1);
f01031a0:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01031a5:	0f 85 b0 01 00 00    	jne    f010335b <mem_init+0x1bee>
	assert(pp1->pp_ref == 0);
f01031ab:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01031b0:	0f 85 be 01 00 00    	jne    f0103374 <mem_init+0x1c07>
	*(uint32_t *)PGSIZE = 0x03030303U;
f01031b6:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f01031bd:	03 03 03 
	return (pp - pages) << PGSHIFT;
f01031c0:	89 d8                	mov    %ebx,%eax
f01031c2:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f01031c8:	c1 f8 03             	sar    $0x3,%eax
f01031cb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01031ce:	89 c2                	mov    %eax,%edx
f01031d0:	c1 ea 0c             	shr    $0xc,%edx
f01031d3:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f01031d9:	0f 83 ae 01 00 00    	jae    f010338d <mem_init+0x1c20>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01031df:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01031e6:	03 03 03 
f01031e9:	0f 85 b0 01 00 00    	jne    f010339f <mem_init+0x1c32>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01031ef:	83 ec 08             	sub    $0x8,%esp
f01031f2:	68 00 10 00 00       	push   $0x1000
f01031f7:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f01031fd:	e8 e3 e3 ff ff       	call   f01015e5 <page_remove>
	assert(pp2->pp_ref == 0);
f0103202:	83 c4 10             	add    $0x10,%esp
f0103205:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010320a:	0f 85 a8 01 00 00    	jne    f01033b8 <mem_init+0x1c4b>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103210:	8b 0d 4c cd 5d f0    	mov    0xf05dcd4c,%ecx
f0103216:	8b 11                	mov    (%ecx),%edx
f0103218:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f010321e:	89 f0                	mov    %esi,%eax
f0103220:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0103226:	c1 f8 03             	sar    $0x3,%eax
f0103229:	c1 e0 0c             	shl    $0xc,%eax
f010322c:	39 c2                	cmp    %eax,%edx
f010322e:	0f 85 9d 01 00 00    	jne    f01033d1 <mem_init+0x1c64>
	kern_pgdir[0] = 0;
f0103234:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f010323a:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010323f:	0f 85 a5 01 00 00    	jne    f01033ea <mem_init+0x1c7d>
	pp0->pp_ref = 0;
f0103245:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f010324b:	83 ec 0c             	sub    $0xc,%esp
f010324e:	56                   	push   %esi
f010324f:	e8 0d e1 ff ff       	call   f0101361 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103254:	c7 04 24 34 95 10 f0 	movl   $0xf0109534,(%esp)
f010325b:	e8 a1 13 00 00       	call   f0104601 <cprintf>
	cprintf("__USER_MAP_BEGIN__ = %08x\n", __USER_MAP_BEGIN__);
f0103260:	83 c4 08             	add    $0x8,%esp
f0103263:	68 00 10 12 f0       	push   $0xf0121000
f0103268:	68 44 99 10 f0       	push   $0xf0109944
f010326d:	e8 8f 13 00 00       	call   f0104601 <cprintf>
	cprintf("__USER_MAP_END__ = %08x\n", __USER_MAP_END__);
f0103272:	83 c4 08             	add    $0x8,%esp
f0103275:	68 00 c0 16 f0       	push   $0xf016c000
f010327a:	68 5f 99 10 f0       	push   $0xf010995f
f010327f:	e8 7d 13 00 00       	call   f0104601 <cprintf>
}
f0103284:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103287:	5b                   	pop    %ebx
f0103288:	5e                   	pop    %esi
f0103289:	5f                   	pop    %edi
f010328a:	5d                   	pop    %ebp
f010328b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010328c:	50                   	push   %eax
f010328d:	68 58 84 10 f0       	push   $0xf0108458
f0103292:	68 f0 00 00 00       	push   $0xf0
f0103297:	68 e5 95 10 f0       	push   $0xf01095e5
f010329c:	e8 a8 cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f01032a1:	68 09 97 10 f0       	push   $0xf0109709
f01032a6:	68 0b 96 10 f0       	push   $0xf010960b
f01032ab:	68 7d 04 00 00       	push   $0x47d
f01032b0:	68 e5 95 10 f0       	push   $0xf01095e5
f01032b5:	e8 8f cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f01032ba:	68 1f 97 10 f0       	push   $0xf010971f
f01032bf:	68 0b 96 10 f0       	push   $0xf010960b
f01032c4:	68 7e 04 00 00       	push   $0x47e
f01032c9:	68 e5 95 10 f0       	push   $0xf01095e5
f01032ce:	e8 76 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f01032d3:	68 35 97 10 f0       	push   $0xf0109735
f01032d8:	68 0b 96 10 f0       	push   $0xf010960b
f01032dd:	68 7f 04 00 00       	push   $0x47f
f01032e2:	68 e5 95 10 f0       	push   $0xf01095e5
f01032e7:	e8 5d cd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01032ec:	50                   	push   %eax
f01032ed:	68 34 84 10 f0       	push   $0xf0108434
f01032f2:	6a 58                	push   $0x58
f01032f4:	68 f1 95 10 f0       	push   $0xf01095f1
f01032f9:	e8 4b cd ff ff       	call   f0100049 <_panic>
f01032fe:	50                   	push   %eax
f01032ff:	68 34 84 10 f0       	push   $0xf0108434
f0103304:	6a 58                	push   $0x58
f0103306:	68 f1 95 10 f0       	push   $0xf01095f1
f010330b:	e8 39 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0103310:	68 06 98 10 f0       	push   $0xf0109806
f0103315:	68 0b 96 10 f0       	push   $0xf010960b
f010331a:	68 84 04 00 00       	push   $0x484
f010331f:	68 e5 95 10 f0       	push   $0xf01095e5
f0103324:	e8 20 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103329:	68 c0 94 10 f0       	push   $0xf01094c0
f010332e:	68 0b 96 10 f0       	push   $0xf010960b
f0103333:	68 85 04 00 00       	push   $0x485
f0103338:	68 e5 95 10 f0       	push   $0xf01095e5
f010333d:	e8 07 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103342:	68 e4 94 10 f0       	push   $0xf01094e4
f0103347:	68 0b 96 10 f0       	push   $0xf010960b
f010334c:	68 87 04 00 00       	push   $0x487
f0103351:	68 e5 95 10 f0       	push   $0xf01095e5
f0103356:	e8 ee cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010335b:	68 28 98 10 f0       	push   $0xf0109828
f0103360:	68 0b 96 10 f0       	push   $0xf010960b
f0103365:	68 88 04 00 00       	push   $0x488
f010336a:	68 e5 95 10 f0       	push   $0xf01095e5
f010336f:	e8 d5 cc ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0103374:	68 92 98 10 f0       	push   $0xf0109892
f0103379:	68 0b 96 10 f0       	push   $0xf010960b
f010337e:	68 89 04 00 00       	push   $0x489
f0103383:	68 e5 95 10 f0       	push   $0xf01095e5
f0103388:	e8 bc cc ff ff       	call   f0100049 <_panic>
f010338d:	50                   	push   %eax
f010338e:	68 34 84 10 f0       	push   $0xf0108434
f0103393:	6a 58                	push   $0x58
f0103395:	68 f1 95 10 f0       	push   $0xf01095f1
f010339a:	e8 aa cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010339f:	68 08 95 10 f0       	push   $0xf0109508
f01033a4:	68 0b 96 10 f0       	push   $0xf010960b
f01033a9:	68 8b 04 00 00       	push   $0x48b
f01033ae:	68 e5 95 10 f0       	push   $0xf01095e5
f01033b3:	e8 91 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01033b8:	68 60 98 10 f0       	push   $0xf0109860
f01033bd:	68 0b 96 10 f0       	push   $0xf010960b
f01033c2:	68 8d 04 00 00       	push   $0x48d
f01033c7:	68 e5 95 10 f0       	push   $0xf01095e5
f01033cc:	e8 78 cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01033d1:	68 64 8e 10 f0       	push   $0xf0108e64
f01033d6:	68 0b 96 10 f0       	push   $0xf010960b
f01033db:	68 90 04 00 00       	push   $0x490
f01033e0:	68 e5 95 10 f0       	push   $0xf01095e5
f01033e5:	e8 5f cc ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f01033ea:	68 17 98 10 f0       	push   $0xf0109817
f01033ef:	68 0b 96 10 f0       	push   $0xf010960b
f01033f4:	68 92 04 00 00       	push   $0x492
f01033f9:	68 e5 95 10 f0       	push   $0xf01095e5
f01033fe:	e8 46 cc ff ff       	call   f0100049 <_panic>

f0103403 <user_mem_check>:
{
f0103403:	55                   	push   %ebp
f0103404:	89 e5                	mov    %esp,%ebp
f0103406:	57                   	push   %edi
f0103407:	56                   	push   %esi
f0103408:	53                   	push   %ebx
f0103409:	83 ec 1c             	sub    $0x1c,%esp
f010340c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	perm |= PTE_P;
f010340f:	8b 7d 14             	mov    0x14(%ebp),%edi
f0103412:	83 cf 01             	or     $0x1,%edi
	uint32_t i = (uint32_t)va; //buggy lab3 buggy
f0103415:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	uint32_t end = (uint32_t)va + len;
f0103418:	89 d8                	mov    %ebx,%eax
f010341a:	03 45 10             	add    0x10(%ebp),%eax
f010341d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103420:	8b 75 08             	mov    0x8(%ebp),%esi
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f0103423:	eb 19                	jmp    f010343e <user_mem_check+0x3b>
			user_mem_check_addr = (uintptr_t)i;
f0103425:	89 1d fc b8 5d f0    	mov    %ebx,0xf05db8fc
			return -E_FAULT;
f010342b:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103430:	eb 7f                	jmp    f01034b1 <user_mem_check+0xae>
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f0103432:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103438:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f010343e:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103441:	73 76                	jae    f01034b9 <user_mem_check+0xb6>
		if((uint32_t)va >= ULIM){
f0103443:	81 7d e0 ff ff 7f ef 	cmpl   $0xef7fffff,-0x20(%ebp)
f010344a:	77 d9                	ja     f0103425 <user_mem_check+0x22>
		pte_t *the_pte = pgdir_walk(env->env_pgdir, (void *)i, 0);
f010344c:	83 ec 04             	sub    $0x4,%esp
f010344f:	6a 00                	push   $0x0
f0103451:	53                   	push   %ebx
f0103452:	ff 76 60             	pushl  0x60(%esi)
f0103455:	e8 6b df ff ff       	call   f01013c5 <pgdir_walk>
		if(!the_pte || (*the_pte & perm) != perm){//lab4 bug
f010345a:	83 c4 10             	add    $0x10,%esp
f010345d:	85 c0                	test   %eax,%eax
f010345f:	74 08                	je     f0103469 <user_mem_check+0x66>
f0103461:	89 fa                	mov    %edi,%edx
f0103463:	23 10                	and    (%eax),%edx
f0103465:	39 d7                	cmp    %edx,%edi
f0103467:	74 c9                	je     f0103432 <user_mem_check+0x2f>
f0103469:	89 c6                	mov    %eax,%esi
			cprintf("PTE_P: 0x%x PTE_W: 0x%x PTE_U: 0x%x\n", PTE_P, PTE_W, PTE_U);
f010346b:	6a 04                	push   $0x4
f010346d:	6a 02                	push   $0x2
f010346f:	6a 01                	push   $0x1
f0103471:	68 60 95 10 f0       	push   $0xf0109560
f0103476:	e8 86 11 00 00       	call   f0104601 <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f010347b:	83 c4 0c             	add    $0xc,%esp
f010347e:	89 f8                	mov    %edi,%eax
f0103480:	23 06                	and    (%esi),%eax
f0103482:	50                   	push   %eax
f0103483:	57                   	push   %edi
f0103484:	68 88 95 10 f0       	push   $0xf0109588
f0103489:	e8 73 11 00 00       	call   f0104601 <cprintf>
			cprintf("the pte: 0x%x\n", PGOFF(*the_pte));
f010348e:	83 c4 08             	add    $0x8,%esp
f0103491:	8b 06                	mov    (%esi),%eax
f0103493:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103498:	50                   	push   %eax
f0103499:	68 78 99 10 f0       	push   $0xf0109978
f010349e:	e8 5e 11 00 00       	call   f0104601 <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f01034a3:	89 1d fc b8 5d f0    	mov    %ebx,0xf05db8fc
			return -E_FAULT;
f01034a9:	83 c4 10             	add    $0x10,%esp
f01034ac:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01034b4:	5b                   	pop    %ebx
f01034b5:	5e                   	pop    %esi
f01034b6:	5f                   	pop    %edi
f01034b7:	5d                   	pop    %ebp
f01034b8:	c3                   	ret    
	return 0;
f01034b9:	b8 00 00 00 00       	mov    $0x0,%eax
f01034be:	eb f1                	jmp    f01034b1 <user_mem_check+0xae>

f01034c0 <user_mem_assert>:
{
f01034c0:	55                   	push   %ebp
f01034c1:	89 e5                	mov    %esp,%ebp
f01034c3:	53                   	push   %ebx
f01034c4:	83 ec 04             	sub    $0x4,%esp
f01034c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f01034ca:	8b 45 14             	mov    0x14(%ebp),%eax
f01034cd:	83 c8 04             	or     $0x4,%eax
f01034d0:	50                   	push   %eax
f01034d1:	ff 75 10             	pushl  0x10(%ebp)
f01034d4:	ff 75 0c             	pushl  0xc(%ebp)
f01034d7:	53                   	push   %ebx
f01034d8:	e8 26 ff ff ff       	call   f0103403 <user_mem_check>
f01034dd:	83 c4 10             	add    $0x10,%esp
f01034e0:	85 c0                	test   %eax,%eax
f01034e2:	78 05                	js     f01034e9 <user_mem_assert+0x29>
}
f01034e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01034e7:	c9                   	leave  
f01034e8:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f01034e9:	83 ec 04             	sub    $0x4,%esp
f01034ec:	ff 35 fc b8 5d f0    	pushl  0xf05db8fc
f01034f2:	ff 73 48             	pushl  0x48(%ebx)
f01034f5:	68 b0 95 10 f0       	push   $0xf01095b0
f01034fa:	e8 02 11 00 00       	call   f0104601 <cprintf>
		env_destroy(env);	// may not return
f01034ff:	89 1c 24             	mov    %ebx,(%esp)
f0103502:	e8 e5 0e 00 00       	call   f01043ec <env_destroy>
f0103507:	83 c4 10             	add    $0x10,%esp
}
f010350a:	eb d8                	jmp    f01034e4 <user_mem_assert+0x24>

f010350c <check_user_map>:
	}
}

 static void
check_user_map(pde_t *pgdir, void *va, uint32_t len, const char *name)
{
f010350c:	55                   	push   %ebp
f010350d:	89 e5                	mov    %esp,%ebp
f010350f:	57                   	push   %edi
f0103510:	56                   	push   %esi
f0103511:	53                   	push   %ebx
f0103512:	83 ec 2c             	sub    $0x2c,%esp
f0103515:	89 c7                	mov    %eax,%edi
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f0103517:	89 d3                	mov    %edx,%ebx
f0103519:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f010351f:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0103526:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010352b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		pte_t *pte;
		if (page_lookup(pgdir, (void *) _va, &pte) == NULL) {
f010352e:	8d 75 e4             	lea    -0x1c(%ebp),%esi
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f0103531:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0103534:	73 35                	jae    f010356b <check_user_map+0x5f>
		if (page_lookup(pgdir, (void *) _va, &pte) == NULL) {
f0103536:	83 ec 04             	sub    $0x4,%esp
f0103539:	56                   	push   %esi
f010353a:	53                   	push   %ebx
f010353b:	57                   	push   %edi
f010353c:	e8 0a e0 ff ff       	call   f010154b <page_lookup>
f0103541:	83 c4 10             	add    $0x10,%esp
f0103544:	85 c0                	test   %eax,%eax
f0103546:	74 10                	je     f0103558 <check_user_map+0x4c>
			cprintf("%s not mapped in env_pgdir\n", name);
			return;
		}
		if (*pte & PTE_U) {
f0103548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010354b:	f6 00 04             	testb  $0x4,(%eax)
f010354e:	75 23                	jne    f0103573 <check_user_map+0x67>
	for (uintptr_t _va = ROUNDDOWN((uintptr_t) va, PGSIZE); _va < ROUNDUP((uintptr_t) va + len, PGSIZE); _va += PGSIZE) {
f0103550:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103556:	eb d9                	jmp    f0103531 <check_user_map+0x25>
			cprintf("%s not mapped in env_pgdir\n", name);
f0103558:	83 ec 08             	sub    $0x8,%esp
f010355b:	ff 75 08             	pushl  0x8(%ebp)
f010355e:	68 af 99 10 f0       	push   $0xf01099af
f0103563:	e8 99 10 00 00       	call   f0104601 <cprintf>
			return;
f0103568:	83 c4 10             	add    $0x10,%esp
			cprintf("%s wrong permission in env_pgdir\n", name);
			return;
		}
	}
}
f010356b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010356e:	5b                   	pop    %ebx
f010356f:	5e                   	pop    %esi
f0103570:	5f                   	pop    %edi
f0103571:	5d                   	pop    %ebp
f0103572:	c3                   	ret    
			cprintf("%s wrong permission in env_pgdir\n", name);
f0103573:	83 ec 08             	sub    $0x8,%esp
f0103576:	ff 75 08             	pushl  0x8(%ebp)
f0103579:	68 ac 9a 10 f0       	push   $0xf0109aac
f010357e:	e8 7e 10 00 00       	call   f0104601 <cprintf>
			return;
f0103583:	83 c4 10             	add    $0x10,%esp
f0103586:	eb e3                	jmp    f010356b <check_user_map+0x5f>

f0103588 <region_alloc>:
{
f0103588:	55                   	push   %ebp
f0103589:	89 e5                	mov    %esp,%ebp
f010358b:	57                   	push   %edi
f010358c:	56                   	push   %esi
f010358d:	53                   	push   %ebx
f010358e:	83 ec 0c             	sub    $0xc,%esp
f0103591:	89 c6                	mov    %eax,%esi
	uint32_t i = ROUNDDOWN((uint32_t)va, PGSIZE);
f0103593:	89 d3                	mov    %edx,%ebx
f0103595:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end = ROUNDUP((uint32_t)va + len, PGSIZE);
f010359b:	8d bc 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%edi
f01035a2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for(; i < end; i+=PGSIZE){
f01035a8:	39 fb                	cmp    %edi,%ebx
f01035aa:	73 6b                	jae    f0103617 <region_alloc+0x8f>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01035ac:	83 ec 0c             	sub    $0xc,%esp
f01035af:	6a 01                	push   $0x1
f01035b1:	e8 39 dd ff ff       	call   f01012ef <page_alloc>
		if(!page)
f01035b6:	83 c4 10             	add    $0x10,%esp
f01035b9:	85 c0                	test   %eax,%eax
f01035bb:	74 2c                	je     f01035e9 <region_alloc+0x61>
		int ret = page_insert(e->env_pgdir, page, (void*)(i), PTE_U | PTE_W);
f01035bd:	6a 06                	push   $0x6
f01035bf:	53                   	push   %ebx
f01035c0:	50                   	push   %eax
f01035c1:	ff 76 60             	pushl  0x60(%esi)
f01035c4:	e8 62 e0 ff ff       	call   f010162b <page_insert>
		if(ret)
f01035c9:	83 c4 10             	add    $0x10,%esp
f01035cc:	85 c0                	test   %eax,%eax
f01035ce:	75 30                	jne    f0103600 <region_alloc+0x78>
		e->env_kern_pgdir[PDX(i)] = e->env_pgdir[PDX(i)];
f01035d0:	89 d8                	mov    %ebx,%eax
f01035d2:	c1 e8 16             	shr    $0x16,%eax
f01035d5:	8b 56 60             	mov    0x60(%esi),%edx
f01035d8:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
f01035db:	8b 56 64             	mov    0x64(%esi),%edx
f01035de:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
	for(; i < end; i+=PGSIZE){
f01035e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01035e7:	eb bf                	jmp    f01035a8 <region_alloc+0x20>
			panic("there is no page\n");
f01035e9:	83 ec 04             	sub    $0x4,%esp
f01035ec:	68 cb 99 10 f0       	push   $0xf01099cb
f01035f1:	68 cf 00 00 00       	push   $0xcf
f01035f6:	68 a4 99 10 f0       	push   $0xf01099a4
f01035fb:	e8 49 ca ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f0103600:	83 ec 04             	sub    $0x4,%esp
f0103603:	68 dd 99 10 f0       	push   $0xf01099dd
f0103608:	68 d2 00 00 00       	push   $0xd2
f010360d:	68 a4 99 10 f0       	push   $0xf01099a4
f0103612:	e8 32 ca ff ff       	call   f0100049 <_panic>
}
f0103617:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010361a:	5b                   	pop    %ebx
f010361b:	5e                   	pop    %esi
f010361c:	5f                   	pop    %edi
f010361d:	5d                   	pop    %ebp
f010361e:	c3                   	ret    

f010361f <envid2env>:
{
f010361f:	55                   	push   %ebp
f0103620:	89 e5                	mov    %esp,%ebp
f0103622:	56                   	push   %esi
f0103623:	53                   	push   %ebx
f0103624:	8b 75 08             	mov    0x8(%ebp),%esi
f0103627:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f010362a:	85 f6                	test   %esi,%esi
f010362c:	74 31                	je     f010365f <envid2env+0x40>
	e = &envs[ENVX(envid)];
f010362e:	89 f3                	mov    %esi,%ebx
f0103630:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103636:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
f010363c:	03 1d 68 a0 12 f0    	add    0xf012a068,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103642:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103646:	74 2e                	je     f0103676 <envid2env+0x57>
f0103648:	39 73 48             	cmp    %esi,0x48(%ebx)
f010364b:	75 29                	jne    f0103676 <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010364d:	84 c0                	test   %al,%al
f010364f:	75 35                	jne    f0103686 <envid2env+0x67>
	*env_store = e;
f0103651:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103654:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103656:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010365b:	5b                   	pop    %ebx
f010365c:	5e                   	pop    %esi
f010365d:	5d                   	pop    %ebp
f010365e:	c3                   	ret    
		*env_store = curenv;
f010365f:	e8 b2 3c 00 00       	call   f0107316 <cpunum>
f0103664:	6b c0 74             	imul   $0x74,%eax,%eax
f0103667:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010366d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103670:	89 02                	mov    %eax,(%edx)
		return 0;
f0103672:	89 f0                	mov    %esi,%eax
f0103674:	eb e5                	jmp    f010365b <envid2env+0x3c>
		*env_store = 0;
f0103676:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010367f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103684:	eb d5                	jmp    f010365b <envid2env+0x3c>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103686:	e8 8b 3c 00 00       	call   f0107316 <cpunum>
f010368b:	6b c0 74             	imul   $0x74,%eax,%eax
f010368e:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f0103694:	74 bb                	je     f0103651 <envid2env+0x32>
f0103696:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103699:	e8 78 3c 00 00       	call   f0107316 <cpunum>
f010369e:	6b c0 74             	imul   $0x74,%eax,%eax
f01036a1:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01036a7:	3b 70 48             	cmp    0x48(%eax),%esi
f01036aa:	74 a5                	je     f0103651 <envid2env+0x32>
		*env_store = 0;
f01036ac:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01036b5:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01036ba:	eb 9f                	jmp    f010365b <envid2env+0x3c>

f01036bc <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f01036bc:	b8 08 d3 16 f0       	mov    $0xf016d308,%eax
f01036c1:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01036c4:	b8 23 00 00 00       	mov    $0x23,%eax
f01036c9:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01036cb:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01036cd:	b8 10 00 00 00       	mov    $0x10,%eax
f01036d2:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01036d4:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01036d6:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01036d8:	ea df 36 10 f0 08 00 	ljmp   $0x8,$0xf01036df
	asm volatile("lldt %0" : : "r" (sel));
f01036df:	b8 00 00 00 00       	mov    $0x0,%eax
f01036e4:	0f 00 d0             	lldt   %ax
}
f01036e7:	c3                   	ret    

f01036e8 <env_init>:
{
f01036e8:	55                   	push   %ebp
f01036e9:	89 e5                	mov    %esp,%ebp
f01036eb:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f01036ee:	8b 15 68 a0 12 f0    	mov    0xf012a068,%edx
f01036f4:	8d 82 84 00 00 00    	lea    0x84(%edx),%eax
f01036fa:	81 c2 00 10 02 00    	add    $0x21000,%edx
f0103700:	c7 40 c4 00 00 00 00 	movl   $0x0,-0x3c(%eax)
		envs[i].env_link = &envs[i+1];
f0103707:	89 40 c0             	mov    %eax,-0x40(%eax)
f010370a:	05 84 00 00 00       	add    $0x84,%eax
	for(int i = 0; i < NENV - 1; i++){
f010370f:	39 d0                	cmp    %edx,%eax
f0103711:	75 ed                	jne    f0103700 <env_init+0x18>
	env_free_list = envs;
f0103713:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
f0103718:	a3 04 b9 5d f0       	mov    %eax,0xf05db904
	env_init_percpu();
f010371d:	e8 9a ff ff ff       	call   f01036bc <env_init_percpu>
}
f0103722:	c9                   	leave  
f0103723:	c3                   	ret    

f0103724 <env_alloc>:
{
f0103724:	55                   	push   %ebp
f0103725:	89 e5                	mov    %esp,%ebp
f0103727:	57                   	push   %edi
f0103728:	56                   	push   %esi
f0103729:	53                   	push   %ebx
f010372a:	83 ec 1c             	sub    $0x1c,%esp
	if (!(e = env_free_list))
f010372d:	8b 1d 04 b9 5d f0    	mov    0xf05db904,%ebx
f0103733:	85 db                	test   %ebx,%ebx
f0103735:	0f 84 1b 04 00 00    	je     f0103b56 <env_alloc+0x432>
	if (!(p = page_alloc(ALLOC_ZERO)))
f010373b:	83 ec 0c             	sub    $0xc,%esp
f010373e:	6a 01                	push   $0x1
f0103740:	e8 aa db ff ff       	call   f01012ef <page_alloc>
f0103745:	83 c4 10             	add    $0x10,%esp
f0103748:	85 c0                	test   %eax,%eax
f010374a:	0f 84 0d 04 00 00    	je     f0103b5d <env_alloc+0x439>
	p->pp_ref++;
f0103750:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103755:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f010375b:	c1 f8 03             	sar    $0x3,%eax
f010375e:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103761:	89 c2                	mov    %eax,%edx
f0103763:	c1 ea 0c             	shr    $0xc,%edx
f0103766:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f010376c:	0f 83 2b 01 00 00    	jae    f010389d <env_alloc+0x179>
	return (void *)(pa + KERNBASE);
f0103772:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	e->env_pgdir = (pde_t *)page2kva(p);
f0103778:	89 53 60             	mov    %edx,0x60(%ebx)
	memmove(e->env_pgdir+PDX(UTOP), kern_pgdir+PDX(UTOP), sizeof(pde_t)*(NPDENTRIES-PDX(UTOP)));
f010377b:	83 ec 04             	sub    $0x4,%esp
f010377e:	68 14 01 00 00       	push   $0x114
f0103783:	8b 0d 4c cd 5d f0    	mov    0xf05dcd4c,%ecx
f0103789:	8d 91 ec 0e 00 00    	lea    0xeec(%ecx),%edx
f010378f:	52                   	push   %edx
f0103790:	2d 14 f1 ff 0f       	sub    $0xffff114,%eax
f0103795:	50                   	push   %eax
f0103796:	e8 bc 35 00 00       	call   f0106d57 <memmove>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010379b:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010379e:	83 c4 10             	add    $0x10,%esp
f01037a1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01037a6:	0f 86 03 01 00 00    	jbe    f01038af <env_alloc+0x18b>
	return (physaddr_t)kva - KERNBASE;
f01037ac:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01037b2:	83 ca 05             	or     $0x5,%edx
f01037b5:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	if (!(kern_p = page_alloc(ALLOC_ZERO)))
f01037bb:	83 ec 0c             	sub    $0xc,%esp
f01037be:	6a 01                	push   $0x1
f01037c0:	e8 2a db ff ff       	call   f01012ef <page_alloc>
f01037c5:	83 c4 10             	add    $0x10,%esp
f01037c8:	85 c0                	test   %eax,%eax
f01037ca:	0f 84 8d 03 00 00    	je     f0103b5d <env_alloc+0x439>
	kern_p->pp_ref++;
f01037d0:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01037d5:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f01037db:	c1 f8 03             	sar    $0x3,%eax
f01037de:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01037e1:	89 c2                	mov    %eax,%edx
f01037e3:	c1 ea 0c             	shr    $0xc,%edx
f01037e6:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f01037ec:	0f 83 d2 00 00 00    	jae    f01038c4 <env_alloc+0x1a0>
	return (void *)(pa + KERNBASE);
f01037f2:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_kern_pgdir = (pde_t *)page2kva(kern_p);
f01037f7:	89 43 64             	mov    %eax,0x64(%ebx)
	memcpy((void *)e->env_kern_pgdir, (void *)kern_pgdir, PGSIZE);
f01037fa:	83 ec 04             	sub    $0x4,%esp
f01037fd:	68 00 10 00 00       	push   $0x1000
f0103802:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f0103808:	50                   	push   %eax
f0103809:	e8 ab 35 00 00       	call   f0106db9 <memcpy>
	memmove(e->env_kern_pgdir+PDX(UTOP), kern_pgdir+PDX(UTOP), sizeof(pde_t)*(NPDENTRIES-PDX(UTOP)));
f010380e:	83 c4 0c             	add    $0xc,%esp
f0103811:	68 14 01 00 00       	push   $0x114
f0103816:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
f010381b:	05 ec 0e 00 00       	add    $0xeec,%eax
f0103820:	50                   	push   %eax
f0103821:	8b 43 64             	mov    0x64(%ebx),%eax
f0103824:	05 ec 0e 00 00       	add    $0xeec,%eax
f0103829:	50                   	push   %eax
f010382a:	e8 28 35 00 00       	call   f0106d57 <memmove>
	e->env_kern_pgdir[PDX(UVPT)] = PADDR(e->env_kern_pgdir) | PTE_P | PTE_U;
f010382f:	8b 43 64             	mov    0x64(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103832:	83 c4 10             	add    $0x10,%esp
f0103835:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010383a:	0f 86 96 00 00 00    	jbe    f01038d6 <env_alloc+0x1b2>
	return (physaddr_t)kva - KERNBASE;
f0103840:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103846:	83 ca 05             	or     $0x5,%edx
f0103849:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	cprintf("the __USER_MAP_BEGIN__ is 0x%x and the __USER_MAP_END__ is 0x%x\n", __USER_MAP_BEGIN__, __USER_MAP_END__);
f010384f:	83 ec 04             	sub    $0x4,%esp
f0103852:	68 00 c0 16 f0       	push   $0xf016c000
f0103857:	68 00 10 12 f0       	push   $0xf0121000
f010385c:	68 d0 9a 10 f0       	push   $0xf0109ad0
f0103861:	e8 9b 0d 00 00       	call   f0104601 <cprintf>
	cprintf("the UTOP is 0x%x\n", UTOP);
f0103866:	83 c4 08             	add    $0x8,%esp
f0103869:	68 00 00 c0 ee       	push   $0xeec00000
f010386e:	68 f6 99 10 f0       	push   $0xf01099f6
f0103873:	e8 89 0d 00 00       	call   f0104601 <cprintf>
	memset(e->env_pgdir + PDX(ULIM), 0, sizeof(pde_t) * (NPDENTRIES - PDX(ULIM)));
f0103878:	83 c4 0c             	add    $0xc,%esp
f010387b:	68 08 01 00 00       	push   $0x108
f0103880:	6a 00                	push   $0x0
f0103882:	8b 43 60             	mov    0x60(%ebx),%eax
f0103885:	05 f8 0e 00 00       	add    $0xef8,%eax
f010388a:	50                   	push   %eax
f010388b:	e8 7f 34 00 00       	call   f0106d0f <memset>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f0103890:	be 00 10 12 f0       	mov    $0xf0121000,%esi
f0103895:	83 c4 10             	add    $0x10,%esp
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void *)i, &pte_store);
f0103898:	8d 7d e4             	lea    -0x1c(%ebp),%edi
f010389b:	eb 5a                	jmp    f01038f7 <env_alloc+0x1d3>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010389d:	50                   	push   %eax
f010389e:	68 34 84 10 f0       	push   $0xf0108434
f01038a3:	6a 58                	push   $0x58
f01038a5:	68 f1 95 10 f0       	push   $0xf01095f1
f01038aa:	e8 9a c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038af:	50                   	push   %eax
f01038b0:	68 58 84 10 f0       	push   $0xf0108458
f01038b5:	68 2f 01 00 00       	push   $0x12f
f01038ba:	68 a4 99 10 f0       	push   $0xf01099a4
f01038bf:	e8 85 c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01038c4:	50                   	push   %eax
f01038c5:	68 34 84 10 f0       	push   $0xf0108434
f01038ca:	6a 58                	push   $0x58
f01038cc:	68 f1 95 10 f0       	push   $0xf01095f1
f01038d1:	e8 73 c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038d6:	50                   	push   %eax
f01038d7:	68 58 84 10 f0       	push   $0xf0108458
f01038dc:	68 3c 01 00 00       	push   $0x13c
f01038e1:	68 a4 99 10 f0       	push   $0xf01099a4
f01038e6:	e8 5e c7 ff ff       	call   f0100049 <_panic>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f01038eb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01038f1:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01038f7:	81 fe 00 c0 16 f0    	cmp    $0xf016c000,%esi
f01038fd:	73 3f                	jae    f010393e <env_alloc+0x21a>
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void *)i, &pte_store);
f01038ff:	83 ec 04             	sub    $0x4,%esp
f0103902:	57                   	push   %edi
f0103903:	56                   	push   %esi
f0103904:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f010390a:	e8 3c dc ff ff       	call   f010154b <page_lookup>
		if(pageInfo == NULL)
f010390f:	83 c4 10             	add    $0x10,%esp
f0103912:	85 c0                	test   %eax,%eax
f0103914:	74 d5                	je     f01038eb <env_alloc+0x1c7>
		r = page_insert(e->env_pgdir, pageInfo, (void *)i, PTE_P);
f0103916:	6a 01                	push   $0x1
f0103918:	56                   	push   %esi
f0103919:	50                   	push   %eax
f010391a:	ff 73 60             	pushl  0x60(%ebx)
f010391d:	e8 09 dd ff ff       	call   f010162b <page_insert>
		if(r < 0)
f0103922:	83 c4 10             	add    $0x10,%esp
f0103925:	85 c0                	test   %eax,%eax
f0103927:	79 c2                	jns    f01038eb <env_alloc+0x1c7>
			panic("test panic error %e\n", r);
f0103929:	50                   	push   %eax
f010392a:	68 08 9a 10 f0       	push   $0xf0109a08
f010392f:	68 e4 00 00 00       	push   $0xe4
f0103934:	68 a4 99 10 f0       	push   $0xf01099a4
f0103939:	e8 0b c7 ff ff       	call   f0100049 <_panic>
	for(uint32_t i = (uint32_t)__USER_MAP_BEGIN__; i < (uint32_t)__USER_MAP_END__; i = ROUNDDOWN(i, PGSIZE) + PGSIZE){
f010393e:	bf 00 00 00 f0       	mov    $0xf0000000,%edi
f0103943:	eb 58                	jmp    f010399d <env_alloc+0x279>
f0103945:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for(uint32_t stackRange = 0; stackRange < KSTKSIZE; stackRange += PGSIZE){
f010394b:	39 f7                	cmp    %esi,%edi
f010394d:	74 40                	je     f010398f <env_alloc+0x26b>
			struct PageInfo* pageInfo = page_lookup(kern_pgdir, va, NULL);
f010394f:	83 ec 04             	sub    $0x4,%esp
f0103952:	6a 00                	push   $0x0
f0103954:	56                   	push   %esi
f0103955:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f010395b:	e8 eb db ff ff       	call   f010154b <page_lookup>
			if(pageInfo == NULL)
f0103960:	83 c4 10             	add    $0x10,%esp
f0103963:	85 c0                	test   %eax,%eax
f0103965:	74 de                	je     f0103945 <env_alloc+0x221>
			r = page_insert(e->env_pgdir, pageInfo, va, PTE_P|PTE_W);
f0103967:	6a 03                	push   $0x3
f0103969:	56                   	push   %esi
f010396a:	50                   	push   %eax
f010396b:	ff 73 60             	pushl  0x60(%ebx)
f010396e:	e8 b8 dc ff ff       	call   f010162b <page_insert>
			if(r < 0)
f0103973:	83 c4 10             	add    $0x10,%esp
f0103976:	85 c0                	test   %eax,%eax
f0103978:	79 cb                	jns    f0103945 <env_alloc+0x221>
				panic("test panic error %e\n", r);
f010397a:	50                   	push   %eax
f010397b:	68 08 9a 10 f0       	push   $0xf0109a08
f0103980:	68 f1 00 00 00       	push   $0xf1
f0103985:	68 a4 99 10 f0       	push   $0xf01099a4
f010398a:	e8 ba c6 ff ff       	call   f0100049 <_panic>
f010398f:	81 ef 00 00 01 00    	sub    $0x10000,%edi
	for(int i = 0; i < NCPU; i++){
f0103995:	81 ff 00 00 f8 ef    	cmp    $0xeff80000,%edi
f010399b:	74 08                	je     f01039a5 <env_alloc+0x281>
f010399d:	8d b7 00 80 ff ff    	lea    -0x8000(%edi),%esi
f01039a3:	eb aa                	jmp    f010394f <env_alloc+0x22b>
	cprintf("set up envs : 0x%x\n", envs);
f01039a5:	83 ec 08             	sub    $0x8,%esp
f01039a8:	ff 35 68 a0 12 f0    	pushl  0xf012a068
f01039ae:	68 1d 9a 10 f0       	push   $0xf0109a1d
f01039b3:	e8 49 0c 00 00       	call   f0104601 <cprintf>
	for(uint32_t i = (uint32_t)envs; i < (uint32_t)(envs+NENV); i+=PGSIZE){
f01039b8:	8b 35 68 a0 12 f0    	mov    0xf012a068,%esi
f01039be:	83 c4 10             	add    $0x10,%esp
f01039c1:	eb 16                	jmp    f01039d9 <env_alloc+0x2b5>
			cprintf("the page info is null\n");
f01039c3:	83 ec 0c             	sub    $0xc,%esp
f01039c6:	68 31 9a 10 f0       	push   $0xf0109a31
f01039cb:	e8 31 0c 00 00       	call   f0104601 <cprintf>
f01039d0:	83 c4 10             	add    $0x10,%esp
	for(uint32_t i = (uint32_t)envs; i < (uint32_t)(envs+NENV); i+=PGSIZE){
f01039d3:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01039d9:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
f01039de:	05 00 10 02 00       	add    $0x21000,%eax
f01039e3:	39 c6                	cmp    %eax,%esi
f01039e5:	73 40                	jae    f0103a27 <env_alloc+0x303>
		struct PageInfo* pageInfo = page_lookup(kern_pgdir, (void*)i, NULL);
f01039e7:	83 ec 04             	sub    $0x4,%esp
f01039ea:	6a 00                	push   $0x0
f01039ec:	56                   	push   %esi
f01039ed:	ff 35 4c cd 5d f0    	pushl  0xf05dcd4c
f01039f3:	e8 53 db ff ff       	call   f010154b <page_lookup>
		if(pageInfo == NULL){
f01039f8:	83 c4 10             	add    $0x10,%esp
f01039fb:	85 c0                	test   %eax,%eax
f01039fd:	74 c4                	je     f01039c3 <env_alloc+0x29f>
		r = page_insert(e->env_pgdir, pageInfo, (void*)i, PTE_P);
f01039ff:	6a 01                	push   $0x1
f0103a01:	56                   	push   %esi
f0103a02:	50                   	push   %eax
f0103a03:	ff 73 60             	pushl  0x60(%ebx)
f0103a06:	e8 20 dc ff ff       	call   f010162b <page_insert>
		if(r < 0)
f0103a0b:	83 c4 10             	add    $0x10,%esp
f0103a0e:	85 c0                	test   %eax,%eax
f0103a10:	79 c1                	jns    f01039d3 <env_alloc+0x2af>
			panic("test panic error %e\n", r);
f0103a12:	50                   	push   %eax
f0103a13:	68 08 9a 10 f0       	push   $0xf0109a08
f0103a18:	68 00 01 00 00       	push   $0x100
f0103a1d:	68 a4 99 10 f0       	push   $0xf01099a4
f0103a22:	e8 22 c6 ff ff       	call   f0100049 <_panic>
	memmove(e->env_kern_pgdir, e->env_pgdir, sizeof(pde_t) * (PDX(ULIM)));
f0103a27:	83 ec 04             	sub    $0x4,%esp
f0103a2a:	68 f8 0e 00 00       	push   $0xef8
f0103a2f:	ff 73 60             	pushl  0x60(%ebx)
f0103a32:	ff 73 64             	pushl  0x64(%ebx)
f0103a35:	e8 1d 33 00 00       	call   f0106d57 <memmove>
	e->env_kern_pgdir[PDX(UVPT)] = PADDR(e->env_kern_pgdir) | PTE_P | PTE_U;
f0103a3a:	8b 43 64             	mov    0x64(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103a3d:	83 c4 10             	add    $0x10,%esp
f0103a40:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a45:	0f 86 f6 00 00 00    	jbe    f0103b41 <env_alloc+0x41d>
	return (physaddr_t)kva - KERNBASE;
f0103a4b:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103a51:	83 ca 05             	or     $0x5,%edx
f0103a54:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103a5a:	8b 43 48             	mov    0x48(%ebx),%eax
f0103a5d:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103a62:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103a67:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103a6c:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103a6f:	89 da                	mov    %ebx,%edx
f0103a71:	2b 15 68 a0 12 f0    	sub    0xf012a068,%edx
f0103a77:	c1 fa 02             	sar    $0x2,%edx
f0103a7a:	69 d2 e1 83 0f 3e    	imul   $0x3e0f83e1,%edx,%edx
f0103a80:	09 d0                	or     %edx,%eax
f0103a82:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103a85:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103a88:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103a8b:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103a92:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103a99:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f0103aa0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
f0103aa7:	00 00 00 
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103aaa:	83 ec 04             	sub    $0x4,%esp
f0103aad:	6a 44                	push   $0x44
f0103aaf:	6a 00                	push   $0x0
f0103ab1:	53                   	push   %ebx
f0103ab2:	e8 58 32 00 00       	call   f0106d0f <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103ab7:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103abd:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103ac3:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103ac9:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103ad0:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103ad6:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103add:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
	e->env_ipc_recving = 0;
f0103ae4:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
	env_free_list = e->env_link;
f0103ae8:	8b 43 44             	mov    0x44(%ebx),%eax
f0103aeb:	a3 04 b9 5d f0       	mov    %eax,0xf05db904
	*newenv_store = e;
f0103af0:	8b 45 08             	mov    0x8(%ebp),%eax
f0103af3:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103af5:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103af8:	e8 19 38 00 00       	call   f0107316 <cpunum>
f0103afd:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b00:	83 c4 10             	add    $0x10,%esp
f0103b03:	ba 00 00 00 00       	mov    $0x0,%edx
f0103b08:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0103b0f:	74 11                	je     f0103b22 <env_alloc+0x3fe>
f0103b11:	e8 00 38 00 00       	call   f0107316 <cpunum>
f0103b16:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b19:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103b1f:	8b 50 48             	mov    0x48(%eax),%edx
f0103b22:	83 ec 04             	sub    $0x4,%esp
f0103b25:	53                   	push   %ebx
f0103b26:	52                   	push   %edx
f0103b27:	68 48 9a 10 f0       	push   $0xf0109a48
f0103b2c:	e8 d0 0a 00 00       	call   f0104601 <cprintf>
	return 0;
f0103b31:	83 c4 10             	add    $0x10,%esp
f0103b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103b3c:	5b                   	pop    %ebx
f0103b3d:	5e                   	pop    %esi
f0103b3e:	5f                   	pop    %edi
f0103b3f:	5d                   	pop    %ebp
f0103b40:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103b41:	50                   	push   %eax
f0103b42:	68 58 84 10 f0       	push   $0xf0108458
f0103b47:	68 41 01 00 00       	push   $0x141
f0103b4c:	68 a4 99 10 f0       	push   $0xf01099a4
f0103b51:	e8 f3 c4 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f0103b56:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103b5b:	eb dc                	jmp    f0103b39 <env_alloc+0x415>
	return 0;
f0103b5d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103b62:	eb d5                	jmp    f0103b39 <env_alloc+0x415>

f0103b64 <env_create>:
{
f0103b64:	55                   	push   %ebp
f0103b65:	89 e5                	mov    %esp,%ebp
f0103b67:	57                   	push   %edi
f0103b68:	56                   	push   %esi
f0103b69:	53                   	push   %ebx
f0103b6a:	83 ec 54             	sub    $0x54,%esp
f0103b6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int ret = env_alloc(&e, 0);
f0103b70:	6a 00                	push   $0x0
f0103b72:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103b75:	50                   	push   %eax
f0103b76:	e8 a9 fb ff ff       	call   f0103724 <env_alloc>
f0103b7b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if(ret)
f0103b7e:	83 c4 10             	add    $0x10,%esp
f0103b81:	85 c0                	test   %eax,%eax
f0103b83:	75 40                	jne    f0103bc5 <env_create+0x61>
	e->env_parent_id = 0;
f0103b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103b88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103b8b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
	e->env_type = type;
f0103b92:	89 58 50             	mov    %ebx,0x50(%eax)
	if(type == ENV_TYPE_FS){
f0103b95:	83 fb 01             	cmp    $0x1,%ebx
f0103b98:	74 42                	je     f0103bdc <env_create+0x78>
	if (elf->e_magic != ELF_MAGIC)
f0103b9a:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b9d:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f0103ba3:	75 40                	jne    f0103be5 <env_create+0x81>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103ba5:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ba8:	89 c7                	mov    %eax,%edi
f0103baa:	03 78 1c             	add    0x1c(%eax),%edi
	eph = ph + elf->e_phnum;
f0103bad:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103bb1:	c1 e0 05             	shl    $0x5,%eax
f0103bb4:	01 f8                	add    %edi,%eax
f0103bb6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	uint32_t elf_load_sz = 0;
f0103bb9:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
f0103bc0:	e9 69 01 00 00       	jmp    f0103d2e <env_create+0x1ca>
		panic("env_alloc failed\n");
f0103bc5:	83 ec 04             	sub    $0x4,%esp
f0103bc8:	68 5d 9a 10 f0       	push   $0xf0109a5d
f0103bcd:	68 04 02 00 00       	push   $0x204
f0103bd2:	68 a4 99 10 f0       	push   $0xf01099a4
f0103bd7:	e8 6d c4 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103bdc:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f0103be3:	eb b5                	jmp    f0103b9a <env_create+0x36>
		panic("is this a valid ELF");
f0103be5:	83 ec 04             	sub    $0x4,%esp
f0103be8:	68 6f 9a 10 f0       	push   $0xf0109a6f
f0103bed:	68 db 01 00 00       	push   $0x1db
f0103bf2:	68 a4 99 10 f0       	push   $0xf01099a4
f0103bf7:	e8 4d c4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103bfc:	50                   	push   %eax
f0103bfd:	68 34 84 10 f0       	push   $0xf0108434
f0103c02:	6a 58                	push   $0x58
f0103c04:	68 f1 95 10 f0       	push   $0xf01095f1
f0103c09:	e8 3b c4 ff ff       	call   f0100049 <_panic>
		addr += size;
f0103c0e:	01 75 c8             	add    %esi,-0x38(%ebp)
		len -= size;
f0103c11:	29 f3                	sub    %esi,%ebx
		off = 0;
f0103c13:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0103c16:	89 45 d0             	mov    %eax,-0x30(%ebp)
	while(len > 0){
f0103c19:	85 db                	test   %ebx,%ebx
f0103c1b:	74 5c                	je     f0103c79 <env_create+0x115>
		int size = len > PGSIZE?PGSIZE - off:len;
f0103c1d:	be 00 10 00 00       	mov    $0x1000,%esi
f0103c22:	2b 75 d0             	sub    -0x30(%ebp),%esi
f0103c25:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
f0103c2b:	0f 46 f3             	cmovbe %ebx,%esi
		struct PageInfo* page = page_lookup(pgdir, (void *)addr, NULL);
f0103c2e:	83 ec 04             	sub    $0x4,%esp
f0103c31:	6a 00                	push   $0x0
f0103c33:	ff 75 c8             	pushl  -0x38(%ebp)
f0103c36:	ff 75 c4             	pushl  -0x3c(%ebp)
f0103c39:	e8 0d d9 ff ff       	call   f010154b <page_lookup>
		if(page)
f0103c3e:	83 c4 10             	add    $0x10,%esp
f0103c41:	85 c0                	test   %eax,%eax
f0103c43:	74 c9                	je     f0103c0e <env_create+0xaa>
	return (pp - pages) << PGSHIFT;
f0103c45:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0103c4b:	c1 f8 03             	sar    $0x3,%eax
f0103c4e:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103c51:	89 c2                	mov    %eax,%edx
f0103c53:	c1 ea 0c             	shr    $0xc,%edx
f0103c56:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0103c5c:	73 9e                	jae    f0103bfc <env_create+0x98>
			memset(page2kva(page)+off, c, size);
f0103c5e:	83 ec 04             	sub    $0x4,%esp
f0103c61:	56                   	push   %esi
f0103c62:	6a 00                	push   $0x0
f0103c64:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0103c67:	8d 84 02 00 00 00 f0 	lea    -0x10000000(%edx,%eax,1),%eax
f0103c6e:	50                   	push   %eax
f0103c6f:	e8 9b 30 00 00       	call   f0106d0f <memset>
f0103c74:	83 c4 10             	add    $0x10,%esp
f0103c77:	eb 95                	jmp    f0103c0e <env_create+0xaa>
			user_memmove(e->env_pgdir,(void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f0103c79:	8b 77 10             	mov    0x10(%edi),%esi
f0103c7c:	8b 47 08             	mov    0x8(%edi),%eax
f0103c7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103c82:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103c85:	8b 51 60             	mov    0x60(%ecx),%edx
f0103c88:	89 55 bc             	mov    %edx,-0x44(%ebp)
f0103c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103c8e:	03 4f 04             	add    0x4(%edi),%ecx
f0103c91:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	int off = addr - ROUNDDOWN(addr, PGSIZE);
f0103c94:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103c99:	89 45 d0             	mov    %eax,-0x30(%ebp)
		off = 0;
f0103c9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103c9f:	89 45 b8             	mov    %eax,-0x48(%ebp)
f0103ca2:	eb 20                	jmp    f0103cc4 <env_create+0x160>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103ca4:	50                   	push   %eax
f0103ca5:	68 34 84 10 f0       	push   $0xf0108434
f0103caa:	6a 58                	push   $0x58
f0103cac:	68 f1 95 10 f0       	push   $0xf01095f1
f0103cb1:	e8 93 c3 ff ff       	call   f0100049 <_panic>
		addr += size;
f0103cb6:	01 5d c8             	add    %ebx,-0x38(%ebp)
		cur_src += size;
f0103cb9:	01 5d c4             	add    %ebx,-0x3c(%ebp)
		len -= size;
f0103cbc:	29 de                	sub    %ebx,%esi
		off = 0;
f0103cbe:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0103cc1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	while(len > 0){
f0103cc4:	85 f6                	test   %esi,%esi
f0103cc6:	74 5d                	je     f0103d25 <env_create+0x1c1>
		int size = len > PGSIZE?PGSIZE - off:len;
f0103cc8:	bb 00 10 00 00       	mov    $0x1000,%ebx
f0103ccd:	2b 5d d0             	sub    -0x30(%ebp),%ebx
f0103cd0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
f0103cd6:	0f 46 de             	cmovbe %esi,%ebx
		struct PageInfo* page = page_lookup(pgdir, (void *)addr, NULL);
f0103cd9:	83 ec 04             	sub    $0x4,%esp
f0103cdc:	6a 00                	push   $0x0
f0103cde:	ff 75 c8             	pushl  -0x38(%ebp)
f0103ce1:	ff 75 bc             	pushl  -0x44(%ebp)
f0103ce4:	e8 62 d8 ff ff       	call   f010154b <page_lookup>
		if(page)
f0103ce9:	83 c4 10             	add    $0x10,%esp
f0103cec:	85 c0                	test   %eax,%eax
f0103cee:	74 c6                	je     f0103cb6 <env_create+0x152>
	return (pp - pages) << PGSHIFT;
f0103cf0:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0103cf6:	c1 f8 03             	sar    $0x3,%eax
f0103cf9:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103cfc:	89 c2                	mov    %eax,%edx
f0103cfe:	c1 ea 0c             	shr    $0xc,%edx
f0103d01:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0103d07:	73 9b                	jae    f0103ca4 <env_create+0x140>
			memmove(page2kva(page)+off, (void *)cur_src, size);
f0103d09:	83 ec 04             	sub    $0x4,%esp
f0103d0c:	53                   	push   %ebx
f0103d0d:	ff 75 c4             	pushl  -0x3c(%ebp)
f0103d10:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0103d13:	8d 84 01 00 00 00 f0 	lea    -0x10000000(%ecx,%eax,1),%eax
f0103d1a:	50                   	push   %eax
f0103d1b:	e8 37 30 00 00       	call   f0106d57 <memmove>
f0103d20:	83 c4 10             	add    $0x10,%esp
f0103d23:	eb 91                	jmp    f0103cb6 <env_create+0x152>
			elf_load_sz += ph->p_memsz;
f0103d25:	8b 57 14             	mov    0x14(%edi),%edx
f0103d28:	01 55 c0             	add    %edx,-0x40(%ebp)
	for (; ph < eph; ph++){
f0103d2b:	83 c7 20             	add    $0x20,%edi
f0103d2e:	39 7d b4             	cmp    %edi,-0x4c(%ebp)
f0103d31:	76 37                	jbe    f0103d6a <env_create+0x206>
		if(ph->p_type == ELF_PROG_LOAD){
f0103d33:	83 3f 01             	cmpl   $0x1,(%edi)
f0103d36:	75 f3                	jne    f0103d2b <env_create+0x1c7>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f0103d38:	8b 4f 14             	mov    0x14(%edi),%ecx
f0103d3b:	8b 57 08             	mov    0x8(%edi),%edx
f0103d3e:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0103d41:	89 f0                	mov    %esi,%eax
f0103d43:	e8 40 f8 ff ff       	call   f0103588 <region_alloc>
			user_memset(e->env_pgdir, (void *)ph->p_va, 0, ph->p_memsz);
f0103d48:	8b 5f 14             	mov    0x14(%edi),%ebx
f0103d4b:	8b 47 08             	mov    0x8(%edi),%eax
f0103d4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0103d51:	8b 4e 60             	mov    0x60(%esi),%ecx
f0103d54:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	int off = addr - ROUNDDOWN(addr, PGSIZE);
f0103d57:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103d5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		off = 0;
f0103d5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103d62:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0103d65:	e9 af fe ff ff       	jmp    f0103c19 <env_create+0xb5>
	e->env_tf.tf_eip = elf->e_entry;
f0103d6a:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d6d:	8b 40 18             	mov    0x18(%eax),%eax
f0103d70:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0103d73:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f0103d76:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103d79:	05 00 00 80 00       	add    $0x800000,%eax
f0103d7e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f0103d84:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103d89:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103d8e:	89 f0                	mov    %esi,%eax
f0103d90:	e8 f3 f7 ff ff       	call   f0103588 <region_alloc>
}
f0103d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103d98:	5b                   	pop    %ebx
f0103d99:	5e                   	pop    %esi
f0103d9a:	5f                   	pop    %edi
f0103d9b:	5d                   	pop    %ebp
f0103d9c:	c3                   	ret    

f0103d9d <env_free>:
{
f0103d9d:	55                   	push   %ebp
f0103d9e:	89 e5                	mov    %esp,%ebp
f0103da0:	57                   	push   %edi
f0103da1:	56                   	push   %esi
f0103da2:	53                   	push   %ebx
f0103da3:	83 ec 2c             	sub    $0x2c,%esp
f0103da6:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (e == curenv)
f0103da9:	e8 68 35 00 00       	call   f0107316 <cpunum>
f0103dae:	6b c0 74             	imul   $0x74,%eax,%eax
f0103db1:	39 b8 28 b0 16 f0    	cmp    %edi,-0xfe94fd8(%eax)
f0103db7:	74 48                	je     f0103e01 <env_free+0x64>
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103db9:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103dbc:	e8 55 35 00 00       	call   f0107316 <cpunum>
f0103dc1:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dc4:	ba 00 00 00 00       	mov    $0x0,%edx
f0103dc9:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0103dd0:	74 11                	je     f0103de3 <env_free+0x46>
f0103dd2:	e8 3f 35 00 00       	call   f0107316 <cpunum>
f0103dd7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dda:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0103de0:	8b 50 48             	mov    0x48(%eax),%edx
f0103de3:	83 ec 04             	sub    $0x4,%esp
f0103de6:	53                   	push   %ebx
f0103de7:	52                   	push   %edx
f0103de8:	68 83 9a 10 f0       	push   $0xf0109a83
f0103ded:	e8 0f 08 00 00       	call   f0104601 <cprintf>
f0103df2:	83 c4 10             	add    $0x10,%esp
f0103df5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103dfc:	e9 b3 00 00 00       	jmp    f0103eb4 <env_free+0x117>
		lcr3(PADDR(kern_pgdir));
f0103e01:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103e06:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103e0b:	76 0a                	jbe    f0103e17 <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f0103e0d:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103e12:	0f 22 d8             	mov    %eax,%cr3
f0103e15:	eb a2                	jmp    f0103db9 <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e17:	50                   	push   %eax
f0103e18:	68 58 84 10 f0       	push   $0xf0108458
f0103e1d:	68 1d 02 00 00       	push   $0x21d
f0103e22:	68 a4 99 10 f0       	push   $0xf01099a4
f0103e27:	e8 1d c2 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103e2c:	56                   	push   %esi
f0103e2d:	68 34 84 10 f0       	push   $0xf0108434
f0103e32:	68 2c 02 00 00       	push   $0x22c
f0103e37:	68 a4 99 10 f0       	push   $0xf01099a4
f0103e3c:	e8 08 c2 ff ff       	call   f0100049 <_panic>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103e41:	83 ec 08             	sub    $0x8,%esp
f0103e44:	89 d8                	mov    %ebx,%eax
f0103e46:	c1 e0 0c             	shl    $0xc,%eax
f0103e49:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103e4c:	50                   	push   %eax
f0103e4d:	ff 77 60             	pushl  0x60(%edi)
f0103e50:	e8 90 d7 ff ff       	call   f01015e5 <page_remove>
f0103e55:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103e58:	83 c3 01             	add    $0x1,%ebx
f0103e5b:	83 c6 04             	add    $0x4,%esi
f0103e5e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103e64:	74 07                	je     f0103e6d <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f0103e66:	f6 06 01             	testb  $0x1,(%esi)
f0103e69:	74 ed                	je     f0103e58 <env_free+0xbb>
f0103e6b:	eb d4                	jmp    f0103e41 <env_free+0xa4>
		e->env_pgdir[pdeno] = 0;
f0103e6d:	8b 47 60             	mov    0x60(%edi),%eax
f0103e70:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103e73:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
		e->env_kern_pgdir[pdeno] = 0;
f0103e7a:	8b 47 64             	mov    0x64(%edi),%eax
f0103e7d:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	if (PGNUM(pa) >= npages)
f0103e84:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103e87:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f0103e8d:	73 69                	jae    f0103ef8 <env_free+0x15b>
		page_decref(pa2page(pa));
f0103e8f:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103e92:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f0103e97:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103e9a:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
f0103e9d:	50                   	push   %eax
f0103e9e:	e8 f9 d4 ff ff       	call   f010139c <page_decref>
f0103ea3:	83 c4 10             	add    $0x10,%esp
f0103ea6:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103eaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103ead:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103eb2:	74 58                	je     f0103f0c <env_free+0x16f>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103eb4:	8b 47 60             	mov    0x60(%edi),%eax
f0103eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103eba:	8b 34 08             	mov    (%eax,%ecx,1),%esi
f0103ebd:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103ec3:	74 e1                	je     f0103ea6 <env_free+0x109>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103ec5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103ecb:	89 f0                	mov    %esi,%eax
f0103ecd:	c1 e8 0c             	shr    $0xc,%eax
f0103ed0:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103ed3:	39 05 48 cd 5d f0    	cmp    %eax,0xf05dcd48
f0103ed9:	0f 86 4d ff ff ff    	jbe    f0103e2c <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0103edf:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103ee8:	c1 e0 14             	shl    $0x14,%eax
f0103eeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103eee:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103ef3:	e9 6e ff ff ff       	jmp    f0103e66 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f0103ef8:	83 ec 04             	sub    $0x4,%esp
f0103efb:	68 30 8d 10 f0       	push   $0xf0108d30
f0103f00:	6a 51                	push   $0x51
f0103f02:	68 f1 95 10 f0       	push   $0xf01095f1
f0103f07:	e8 3d c1 ff ff       	call   f0100049 <_panic>
	for (pdeno = PDX(__USER_MAP_BEGIN__); pdeno <= PDX(__USER_MAP_END__); pdeno++) {
f0103f0c:	b8 00 10 12 f0       	mov    $0xf0121000,%eax
f0103f11:	c1 e8 16             	shr    $0x16,%eax
f0103f14:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103f17:	b8 00 c0 16 f0       	mov    $0xf016c000,%eax
f0103f1c:	c1 e8 16             	shr    $0x16,%eax
f0103f1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103f22:	e9 bd 00 00 00       	jmp    f0103fe4 <env_free+0x247>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103f27:	53                   	push   %ebx
f0103f28:	68 34 84 10 f0       	push   $0xf0108434
f0103f2d:	68 40 02 00 00       	push   $0x240
f0103f32:	68 a4 99 10 f0       	push   $0xf01099a4
f0103f37:	e8 0d c1 ff ff       	call   f0100049 <_panic>
f0103f3c:	50                   	push   %eax
f0103f3d:	68 34 84 10 f0       	push   $0xf0108434
f0103f42:	68 47 02 00 00       	push   $0x247
f0103f47:	68 a4 99 10 f0       	push   $0xf01099a4
f0103f4c:	e8 f8 c0 ff ff       	call   f0100049 <_panic>
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103f51:	83 c6 01             	add    $0x1,%esi
f0103f54:	83 c3 04             	add    $0x4,%ebx
f0103f57:	81 fe 00 04 00 00    	cmp    $0x400,%esi
f0103f5d:	74 48                	je     f0103fa7 <env_free+0x20a>
			if (pt[pteno] & PTE_P) {
f0103f5f:	8b 03                	mov    (%ebx),%eax
f0103f61:	a8 01                	test   $0x1,%al
f0103f63:	74 ec                	je     f0103f51 <env_free+0x1b4>
				if ((uintptr_t)KADDR(PTE_ADDR(pt[pteno])) >= begin && (uintptr_t)KADDR(PTE_ADDR(pt[pteno])) < end) {
f0103f65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0103f6a:	89 c2                	mov    %eax,%edx
f0103f6c:	c1 ea 0c             	shr    $0xc,%edx
f0103f6f:	39 15 48 cd 5d f0    	cmp    %edx,0xf05dcd48
f0103f75:	76 c5                	jbe    f0103f3c <env_free+0x19f>
	return (void *)(pa + KERNBASE);
f0103f77:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103f7c:	b9 00 10 12 f0       	mov    $0xf0121000,%ecx
f0103f81:	39 c1                	cmp    %eax,%ecx
f0103f83:	77 cc                	ja     f0103f51 <env_free+0x1b4>
f0103f85:	b9 00 c0 16 f0       	mov    $0xf016c000,%ecx
f0103f8a:	39 c1                	cmp    %eax,%ecx
f0103f8c:	76 c3                	jbe    f0103f51 <env_free+0x1b4>
					page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103f8e:	83 ec 08             	sub    $0x8,%esp
f0103f91:	89 f0                	mov    %esi,%eax
f0103f93:	c1 e0 0c             	shl    $0xc,%eax
f0103f96:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103f99:	50                   	push   %eax
f0103f9a:	ff 77 60             	pushl  0x60(%edi)
f0103f9d:	e8 43 d6 ff ff       	call   f01015e5 <page_remove>
f0103fa2:	83 c4 10             	add    $0x10,%esp
f0103fa5:	eb aa                	jmp    f0103f51 <env_free+0x1b4>
		e->env_pgdir[pdeno] = 0;
f0103fa7:	8b 47 60             	mov    0x60(%edi),%eax
f0103faa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0103fad:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
		e->env_kern_pgdir[pdeno] = 0;
f0103fb4:	8b 47 64             	mov    0x64(%edi),%eax
f0103fb7:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	if (PGNUM(pa) >= npages)
f0103fbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103fc1:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f0103fc7:	73 6e                	jae    f0104037 <env_free+0x29a>
		page_decref(pa2page(pa));
f0103fc9:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103fcc:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f0103fd1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103fd4:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
f0103fd7:	50                   	push   %eax
f0103fd8:	e8 bf d3 ff ff       	call   f010139c <page_decref>
f0103fdd:	83 c4 10             	add    $0x10,%esp
	for (pdeno = PDX(__USER_MAP_BEGIN__); pdeno <= PDX(__USER_MAP_END__); pdeno++) {
f0103fe0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103fe4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103fe7:	39 4d d8             	cmp    %ecx,-0x28(%ebp)
f0103fea:	72 5f                	jb     f010404b <env_free+0x2ae>
f0103fec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103fef:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
f0103ff6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103ff9:	8b 47 60             	mov    0x60(%edi),%eax
f0103ffc:	8b 1c 88             	mov    (%eax,%ecx,4),%ebx
f0103fff:	f6 c3 01             	test   $0x1,%bl
f0104002:	74 dc                	je     f0103fe0 <env_free+0x243>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0104004:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (PGNUM(pa) >= npages)
f010400a:	89 d8                	mov    %ebx,%eax
f010400c:	c1 e8 0c             	shr    $0xc,%eax
f010400f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104012:	39 05 48 cd 5d f0    	cmp    %eax,0xf05dcd48
f0104018:	0f 86 09 ff ff ff    	jbe    f0103f27 <env_free+0x18a>
	return (void *)(pa + KERNBASE);
f010401e:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0104024:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104027:	c1 e0 16             	shl    $0x16,%eax
f010402a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010402d:	be 00 00 00 00       	mov    $0x0,%esi
f0104032:	e9 28 ff ff ff       	jmp    f0103f5f <env_free+0x1c2>
		panic("pa2page called with invalid pa");
f0104037:	83 ec 04             	sub    $0x4,%esp
f010403a:	68 30 8d 10 f0       	push   $0xf0108d30
f010403f:	6a 51                	push   $0x51
f0104041:	68 f1 95 10 f0       	push   $0xf01095f1
f0104046:	e8 fe bf ff ff       	call   f0100049 <_panic>
f010404b:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
f0104050:	c7 45 e4 00 80 ff ef 	movl   $0xefff8000,-0x1c(%ebp)
f0104057:	89 7d 08             	mov    %edi,0x8(%ebp)
f010405a:	89 c7                	mov    %eax,%edi
f010405c:	e9 3e 01 00 00       	jmp    f010419f <env_free+0x402>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0104061:	53                   	push   %ebx
f0104062:	68 34 84 10 f0       	push   $0xf0108434
f0104067:	68 5d 02 00 00       	push   $0x25d
f010406c:	68 a4 99 10 f0       	push   $0xf01099a4
f0104071:	e8 d3 bf ff ff       	call   f0100049 <_panic>
f0104076:	50                   	push   %eax
f0104077:	68 34 84 10 f0       	push   $0xf0108434
f010407c:	68 64 02 00 00       	push   $0x264
f0104081:	68 a4 99 10 f0       	push   $0xf01099a4
f0104086:	e8 be bf ff ff       	call   f0100049 <_panic>
			for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010408b:	83 c6 01             	add    $0x1,%esi
f010408e:	83 c3 04             	add    $0x4,%ebx
f0104091:	81 fe 00 04 00 00    	cmp    $0x400,%esi
f0104097:	74 42                	je     f01040db <env_free+0x33e>
				if (pt[pteno] & PTE_P) {
f0104099:	8b 03                	mov    (%ebx),%eax
f010409b:	a8 01                	test   $0x1,%al
f010409d:	74 ec                	je     f010408b <env_free+0x2ee>
					if ((uintptr_t)KADDR(PTE_ADDR(pt[pteno])) >= begin && (uintptr_t)KADDR(PTE_ADDR(pt[pteno])) < end) {
f010409f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01040a4:	89 c2                	mov    %eax,%edx
f01040a6:	c1 ea 0c             	shr    $0xc,%edx
f01040a9:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f01040af:	73 c5                	jae    f0104076 <env_free+0x2d9>
	return (void *)(pa + KERNBASE);
f01040b1:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01040b6:	39 f8                	cmp    %edi,%eax
f01040b8:	73 d1                	jae    f010408b <env_free+0x2ee>
f01040ba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f01040bd:	72 cc                	jb     f010408b <env_free+0x2ee>
						page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01040bf:	83 ec 08             	sub    $0x8,%esp
f01040c2:	89 f0                	mov    %esi,%eax
f01040c4:	c1 e0 0c             	shl    $0xc,%eax
f01040c7:	0b 45 e0             	or     -0x20(%ebp),%eax
f01040ca:	50                   	push   %eax
f01040cb:	8b 45 08             	mov    0x8(%ebp),%eax
f01040ce:	ff 70 60             	pushl  0x60(%eax)
f01040d1:	e8 0f d5 ff ff       	call   f01015e5 <page_remove>
f01040d6:	83 c4 10             	add    $0x10,%esp
f01040d9:	eb b0                	jmp    f010408b <env_free+0x2ee>
			e->env_pgdir[pdeno] = 0;
f01040db:	8b 45 08             	mov    0x8(%ebp),%eax
f01040de:	8b 40 60             	mov    0x60(%eax),%eax
f01040e1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01040e4:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
			e->env_kern_pgdir[pdeno] = 0;
f01040eb:	8b 45 08             	mov    0x8(%ebp),%eax
f01040ee:	8b 40 64             	mov    0x64(%eax),%eax
f01040f1:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	if (PGNUM(pa) >= npages)
f01040f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01040fb:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f0104101:	73 71                	jae    f0104174 <env_free+0x3d7>
			page_decref(pa2page(pa));
f0104103:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0104106:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f010410b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010410e:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
f0104111:	50                   	push   %eax
f0104112:	e8 85 d2 ff ff       	call   f010139c <page_decref>
f0104117:	83 c4 10             	add    $0x10,%esp
		for (pdeno = PDX(KSTACKTOP - (i+1) * KSTKSIZE - i * KSTKGAP); pdeno <= PDX(KSTACKTOP - (i+1) * KSTKSIZE - i * KSTKGAP+KSTKSIZE); pdeno++) {
f010411a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
f010411e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0104121:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
f0104124:	72 62                	jb     f0104188 <env_free+0x3eb>
f0104126:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0104129:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
f0104130:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (!(e->env_pgdir[pdeno] & PTE_P))
f0104133:	8b 45 08             	mov    0x8(%ebp),%eax
f0104136:	8b 40 60             	mov    0x60(%eax),%eax
f0104139:	8b 1c 88             	mov    (%eax,%ecx,4),%ebx
f010413c:	f6 c3 01             	test   $0x1,%bl
f010413f:	74 d9                	je     f010411a <env_free+0x37d>
			pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0104141:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (PGNUM(pa) >= npages)
f0104147:	89 d8                	mov    %ebx,%eax
f0104149:	c1 e8 0c             	shr    $0xc,%eax
f010414c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010414f:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f0104155:	0f 83 06 ff ff ff    	jae    f0104061 <env_free+0x2c4>
	return (void *)(pa + KERNBASE);
f010415b:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0104161:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104164:	c1 e0 16             	shl    $0x16,%eax
f0104167:	89 45 e0             	mov    %eax,-0x20(%ebp)
			for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010416a:	be 00 00 00 00       	mov    $0x0,%esi
f010416f:	e9 25 ff ff ff       	jmp    f0104099 <env_free+0x2fc>
		panic("pa2page called with invalid pa");
f0104174:	83 ec 04             	sub    $0x4,%esp
f0104177:	68 30 8d 10 f0       	push   $0xf0108d30
f010417c:	6a 51                	push   $0x51
f010417e:	68 f1 95 10 f0       	push   $0xf01095f1
f0104183:	e8 c1 be ff ff       	call   f0100049 <_panic>
f0104188:	81 6d e4 00 00 01 00 	subl   $0x10000,-0x1c(%ebp)
f010418f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104192:	81 ef 00 00 01 00    	sub    $0x10000,%edi
	for(int i = 0; i < NCPU; i++){
f0104198:	3d 00 80 f7 ef       	cmp    $0xeff78000,%eax
f010419d:	74 16                	je     f01041b5 <env_free+0x418>
		for (pdeno = PDX(KSTACKTOP - (i+1) * KSTKSIZE - i * KSTKGAP); pdeno <= PDX(KSTACKTOP - (i+1) * KSTKSIZE - i * KSTKGAP+KSTKSIZE); pdeno++) {
f010419f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01041a2:	c1 e8 16             	shr    $0x16,%eax
f01041a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01041a8:	89 f8                	mov    %edi,%eax
f01041aa:	c1 e8 16             	shr    $0x16,%eax
f01041ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01041b0:	e9 69 ff ff ff       	jmp    f010411e <env_free+0x381>
	for (pdeno = PDX(envs); pdeno <= PDX(envs+NENV); pdeno++) {
f01041b5:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
f01041ba:	c1 e8 16             	shr    $0x16,%eax
f01041bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01041c0:	e9 c1 00 00 00       	jmp    f0104286 <env_free+0x4e9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01041c5:	53                   	push   %ebx
f01041c6:	68 34 84 10 f0       	push   $0xf0108434
f01041cb:	68 7a 02 00 00       	push   $0x27a
f01041d0:	68 a4 99 10 f0       	push   $0xf01099a4
f01041d5:	e8 6f be ff ff       	call   f0100049 <_panic>
f01041da:	50                   	push   %eax
f01041db:	68 34 84 10 f0       	push   $0xf0108434
f01041e0:	68 81 02 00 00       	push   $0x281
f01041e5:	68 a4 99 10 f0       	push   $0xf01099a4
f01041ea:	e8 5a be ff ff       	call   f0100049 <_panic>
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01041ef:	83 c6 01             	add    $0x1,%esi
f01041f2:	83 c3 04             	add    $0x4,%ebx
f01041f5:	81 fe 00 04 00 00    	cmp    $0x400,%esi
f01041fb:	74 42                	je     f010423f <env_free+0x4a2>
			if (pt[pteno] & PTE_P) {
f01041fd:	8b 03                	mov    (%ebx),%eax
f01041ff:	a8 01                	test   $0x1,%al
f0104201:	74 ec                	je     f01041ef <env_free+0x452>
				if ((uintptr_t)KADDR(PTE_ADDR(pt[pteno])) >= begin && (uintptr_t)KADDR(PTE_ADDR(pt[pteno])) < end) {
f0104203:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0104208:	89 c2                	mov    %eax,%edx
f010420a:	c1 ea 0c             	shr    $0xc,%edx
f010420d:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0104213:	73 c5                	jae    f01041da <env_free+0x43d>
	return (void *)(pa + KERNBASE);
f0104215:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010421a:	39 c7                	cmp    %eax,%edi
f010421c:	77 d1                	ja     f01041ef <env_free+0x452>
f010421e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0104221:	76 cc                	jbe    f01041ef <env_free+0x452>
					page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0104223:	83 ec 08             	sub    $0x8,%esp
f0104226:	89 f0                	mov    %esi,%eax
f0104228:	c1 e0 0c             	shl    $0xc,%eax
f010422b:	0b 45 e0             	or     -0x20(%ebp),%eax
f010422e:	50                   	push   %eax
f010422f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104232:	ff 70 60             	pushl  0x60(%eax)
f0104235:	e8 ab d3 ff ff       	call   f01015e5 <page_remove>
f010423a:	83 c4 10             	add    $0x10,%esp
f010423d:	eb b0                	jmp    f01041ef <env_free+0x452>
		e->env_pgdir[pdeno] = 0;
f010423f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104242:	8b 40 60             	mov    0x60(%eax),%eax
f0104245:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104248:	c7 04 38 00 00 00 00 	movl   $0x0,(%eax,%edi,1)
		e->env_kern_pgdir[pdeno] = 0;
f010424f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104252:	8b 40 64             	mov    0x64(%eax),%eax
f0104255:	c7 04 38 00 00 00 00 	movl   $0x0,(%eax,%edi,1)
	if (PGNUM(pa) >= npages)
f010425c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010425f:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f0104265:	0f 83 86 00 00 00    	jae    f01042f1 <env_free+0x554>
		page_decref(pa2page(pa));
f010426b:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010426e:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f0104273:	8b 7d d8             	mov    -0x28(%ebp),%edi
f0104276:	8d 04 f8             	lea    (%eax,%edi,8),%eax
f0104279:	50                   	push   %eax
f010427a:	e8 1d d1 ff ff       	call   f010139c <page_decref>
f010427f:	83 c4 10             	add    $0x10,%esp
	for (pdeno = PDX(envs); pdeno <= PDX(envs+NENV); pdeno++) {
f0104282:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
f0104286:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
f010428b:	8d 90 00 10 02 00    	lea    0x21000(%eax),%edx
f0104291:	c1 ea 16             	shr    $0x16,%edx
f0104294:	3b 55 dc             	cmp    -0x24(%ebp),%edx
f0104297:	72 6c                	jb     f0104305 <env_free+0x568>
f0104299:	8b 7d dc             	mov    -0x24(%ebp),%edi
f010429c:	8d 0c bd 00 00 00 00 	lea    0x0(,%edi,4),%ecx
f01042a3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (!(e->env_pgdir[pdeno] & PTE_P))
f01042a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01042a9:	8b 51 60             	mov    0x60(%ecx),%edx
f01042ac:	8b 1c ba             	mov    (%edx,%edi,4),%ebx
f01042af:	f6 c3 01             	test   $0x1,%bl
f01042b2:	74 ce                	je     f0104282 <env_free+0x4e5>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01042b4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (PGNUM(pa) >= npages)
f01042ba:	89 df                	mov    %ebx,%edi
f01042bc:	c1 ef 0c             	shr    $0xc,%edi
f01042bf:	89 7d d8             	mov    %edi,-0x28(%ebp)
f01042c2:	3b 3d 48 cd 5d f0    	cmp    0xf05dcd48,%edi
f01042c8:	0f 83 f7 fe ff ff    	jae    f01041c5 <env_free+0x428>
	return (void *)(pa + KERNBASE);
f01042ce:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
		uintptr_t begin = (uint32_t)envs, end = (uint32_t)envs+NENV;
f01042d4:	89 c7                	mov    %eax,%edi
f01042d6:	05 00 04 00 00       	add    $0x400,%eax
f01042db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01042de:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01042e1:	c1 e0 16             	shl    $0x16,%eax
f01042e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01042e7:	be 00 00 00 00       	mov    $0x0,%esi
f01042ec:	e9 0c ff ff ff       	jmp    f01041fd <env_free+0x460>
		panic("pa2page called with invalid pa");
f01042f1:	83 ec 04             	sub    $0x4,%esp
f01042f4:	68 30 8d 10 f0       	push   $0xf0108d30
f01042f9:	6a 51                	push   $0x51
f01042fb:	68 f1 95 10 f0       	push   $0xf01095f1
f0104300:	e8 44 bd ff ff       	call   f0100049 <_panic>
f0104305:	8b 7d 08             	mov    0x8(%ebp),%edi
	pa = PADDR(e->env_pgdir);
f0104308:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f010430b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104310:	0f 86 84 00 00 00    	jbe    f010439a <env_free+0x5fd>
	return (physaddr_t)kva - KERNBASE;
f0104316:	05 00 00 00 10       	add    $0x10000000,%eax
	pak = PADDR(e->env_kern_pgdir);
f010431b:	8b 5f 64             	mov    0x64(%edi),%ebx
	if ((uint32_t)kva < KERNBASE)
f010431e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0104324:	0f 86 85 00 00 00    	jbe    f01043af <env_free+0x612>
	return (physaddr_t)kva - KERNBASE;
f010432a:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
	e->env_pgdir = 0;
f0104330:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	e->env_kern_pgdir = 0;
f0104337:	c7 47 64 00 00 00 00 	movl   $0x0,0x64(%edi)
	if (PGNUM(pa) >= npages)
f010433e:	c1 e8 0c             	shr    $0xc,%eax
f0104341:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f0104347:	73 7b                	jae    f01043c4 <env_free+0x627>
	page_decref(pa2page(pa));
f0104349:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010434c:	8b 15 50 cd 5d f0    	mov    0xf05dcd50,%edx
f0104352:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0104355:	50                   	push   %eax
f0104356:	e8 41 d0 ff ff       	call   f010139c <page_decref>
	if (PGNUM(pa) >= npages)
f010435b:	c1 eb 0c             	shr    $0xc,%ebx
f010435e:	83 c4 10             	add    $0x10,%esp
f0104361:	3b 1d 48 cd 5d f0    	cmp    0xf05dcd48,%ebx
f0104367:	73 6f                	jae    f01043d8 <env_free+0x63b>
	page_decref(pa2page(pak));
f0104369:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010436c:	a1 50 cd 5d f0       	mov    0xf05dcd50,%eax
f0104371:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
f0104374:	50                   	push   %eax
f0104375:	e8 22 d0 ff ff       	call   f010139c <page_decref>
	e->env_status = ENV_FREE;
f010437a:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0104381:	a1 04 b9 5d f0       	mov    0xf05db904,%eax
f0104386:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0104389:	89 3d 04 b9 5d f0    	mov    %edi,0xf05db904
}
f010438f:	83 c4 10             	add    $0x10,%esp
f0104392:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104395:	5b                   	pop    %ebx
f0104396:	5e                   	pop    %esi
f0104397:	5f                   	pop    %edi
f0104398:	5d                   	pop    %ebp
f0104399:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010439a:	50                   	push   %eax
f010439b:	68 58 84 10 f0       	push   $0xf0108458
f01043a0:	68 93 02 00 00       	push   $0x293
f01043a5:	68 a4 99 10 f0       	push   $0xf01099a4
f01043aa:	e8 9a bc ff ff       	call   f0100049 <_panic>
f01043af:	53                   	push   %ebx
f01043b0:	68 58 84 10 f0       	push   $0xf0108458
f01043b5:	68 94 02 00 00       	push   $0x294
f01043ba:	68 a4 99 10 f0       	push   $0xf01099a4
f01043bf:	e8 85 bc ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f01043c4:	83 ec 04             	sub    $0x4,%esp
f01043c7:	68 30 8d 10 f0       	push   $0xf0108d30
f01043cc:	6a 51                	push   $0x51
f01043ce:	68 f1 95 10 f0       	push   $0xf01095f1
f01043d3:	e8 71 bc ff ff       	call   f0100049 <_panic>
f01043d8:	83 ec 04             	sub    $0x4,%esp
f01043db:	68 30 8d 10 f0       	push   $0xf0108d30
f01043e0:	6a 51                	push   $0x51
f01043e2:	68 f1 95 10 f0       	push   $0xf01095f1
f01043e7:	e8 5d bc ff ff       	call   f0100049 <_panic>

f01043ec <env_destroy>:
{
f01043ec:	55                   	push   %ebp
f01043ed:	89 e5                	mov    %esp,%ebp
f01043ef:	53                   	push   %ebx
f01043f0:	83 ec 04             	sub    $0x4,%esp
f01043f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (e->env_status == ENV_RUNNING && curenv != e) {
f01043f6:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f01043fa:	74 21                	je     f010441d <env_destroy+0x31>
	env_free(e);
f01043fc:	83 ec 0c             	sub    $0xc,%esp
f01043ff:	53                   	push   %ebx
f0104400:	e8 98 f9 ff ff       	call   f0103d9d <env_free>
	if (curenv == e) {
f0104405:	e8 0c 2f 00 00       	call   f0107316 <cpunum>
f010440a:	6b c0 74             	imul   $0x74,%eax,%eax
f010440d:	83 c4 10             	add    $0x10,%esp
f0104410:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f0104416:	74 1e                	je     f0104436 <env_destroy+0x4a>
}
f0104418:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010441b:	c9                   	leave  
f010441c:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010441d:	e8 f4 2e 00 00       	call   f0107316 <cpunum>
f0104422:	6b c0 74             	imul   $0x74,%eax,%eax
f0104425:	39 98 28 b0 16 f0    	cmp    %ebx,-0xfe94fd8(%eax)
f010442b:	74 cf                	je     f01043fc <env_destroy+0x10>
		e->env_status = ENV_DYING;
f010442d:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0104434:	eb e2                	jmp    f0104418 <env_destroy+0x2c>
		curenv = NULL;
f0104436:	e8 db 2e 00 00       	call   f0107316 <cpunum>
f010443b:	6b c0 74             	imul   $0x74,%eax,%eax
f010443e:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f0104445:	00 00 00 
		cprintf("after env_free to sched_yield\n");
f0104448:	83 ec 0c             	sub    $0xc,%esp
f010444b:	68 14 9b 10 f0       	push   $0xf0109b14
f0104450:	e8 ac 01 00 00       	call   f0104601 <cprintf>
		sched_yield();
f0104455:	e8 5f 10 00 00       	call   f01054b9 <sched_yield>

f010445a <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010445a:	55                   	push   %ebp
f010445b:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010445d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104460:	ba 70 00 00 00       	mov    $0x70,%edx
f0104465:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0104466:	ba 71 00 00 00       	mov    $0x71,%edx
f010446b:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010446c:	0f b6 c0             	movzbl %al,%eax
}
f010446f:	5d                   	pop    %ebp
f0104470:	c3                   	ret    

f0104471 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0104471:	55                   	push   %ebp
f0104472:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104474:	8b 45 08             	mov    0x8(%ebp),%eax
f0104477:	ba 70 00 00 00       	mov    $0x70,%edx
f010447c:	ee                   	out    %al,(%dx)
f010447d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104480:	ba 71 00 00 00       	mov    $0x71,%edx
f0104485:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0104486:	5d                   	pop    %ebp
f0104487:	c3                   	ret    

f0104488 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0104488:	55                   	push   %ebp
f0104489:	89 e5                	mov    %esp,%ebp
f010448b:	56                   	push   %esi
f010448c:	53                   	push   %ebx
f010448d:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0104490:	66 a3 0e d3 16 f0    	mov    %ax,0xf016d30e
	if (!didinit)
f0104496:	80 3d 08 b9 5d f0 00 	cmpb   $0x0,0xf05db908
f010449d:	75 07                	jne    f01044a6 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f010449f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01044a2:	5b                   	pop    %ebx
f01044a3:	5e                   	pop    %esi
f01044a4:	5d                   	pop    %ebp
f01044a5:	c3                   	ret    
f01044a6:	89 c6                	mov    %eax,%esi
f01044a8:	ba 21 00 00 00       	mov    $0x21,%edx
f01044ad:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01044ae:	66 c1 e8 08          	shr    $0x8,%ax
f01044b2:	ba a1 00 00 00       	mov    $0xa1,%edx
f01044b7:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01044b8:	83 ec 0c             	sub    $0xc,%esp
f01044bb:	68 63 9b 10 f0       	push   $0xf0109b63
f01044c0:	e8 3c 01 00 00       	call   f0104601 <cprintf>
f01044c5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01044c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01044cd:	0f b7 f6             	movzwl %si,%esi
f01044d0:	f7 d6                	not    %esi
f01044d2:	eb 19                	jmp    f01044ed <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f01044d4:	83 ec 08             	sub    $0x8,%esp
f01044d7:	53                   	push   %ebx
f01044d8:	68 1f a3 10 f0       	push   $0xf010a31f
f01044dd:	e8 1f 01 00 00       	call   f0104601 <cprintf>
f01044e2:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01044e5:	83 c3 01             	add    $0x1,%ebx
f01044e8:	83 fb 10             	cmp    $0x10,%ebx
f01044eb:	74 07                	je     f01044f4 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f01044ed:	0f a3 de             	bt     %ebx,%esi
f01044f0:	73 f3                	jae    f01044e5 <irq_setmask_8259A+0x5d>
f01044f2:	eb e0                	jmp    f01044d4 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f01044f4:	83 ec 0c             	sub    $0xc,%esp
f01044f7:	68 fb 98 10 f0       	push   $0xf01098fb
f01044fc:	e8 00 01 00 00       	call   f0104601 <cprintf>
f0104501:	83 c4 10             	add    $0x10,%esp
f0104504:	eb 99                	jmp    f010449f <irq_setmask_8259A+0x17>

f0104506 <pic_init>:
{
f0104506:	55                   	push   %ebp
f0104507:	89 e5                	mov    %esp,%ebp
f0104509:	57                   	push   %edi
f010450a:	56                   	push   %esi
f010450b:	53                   	push   %ebx
f010450c:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f010450f:	c6 05 08 b9 5d f0 01 	movb   $0x1,0xf05db908
f0104516:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010451b:	bb 21 00 00 00       	mov    $0x21,%ebx
f0104520:	89 da                	mov    %ebx,%edx
f0104522:	ee                   	out    %al,(%dx)
f0104523:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0104528:	89 ca                	mov    %ecx,%edx
f010452a:	ee                   	out    %al,(%dx)
f010452b:	bf 11 00 00 00       	mov    $0x11,%edi
f0104530:	be 20 00 00 00       	mov    $0x20,%esi
f0104535:	89 f8                	mov    %edi,%eax
f0104537:	89 f2                	mov    %esi,%edx
f0104539:	ee                   	out    %al,(%dx)
f010453a:	b8 20 00 00 00       	mov    $0x20,%eax
f010453f:	89 da                	mov    %ebx,%edx
f0104541:	ee                   	out    %al,(%dx)
f0104542:	b8 04 00 00 00       	mov    $0x4,%eax
f0104547:	ee                   	out    %al,(%dx)
f0104548:	b8 03 00 00 00       	mov    $0x3,%eax
f010454d:	ee                   	out    %al,(%dx)
f010454e:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0104553:	89 f8                	mov    %edi,%eax
f0104555:	89 da                	mov    %ebx,%edx
f0104557:	ee                   	out    %al,(%dx)
f0104558:	b8 28 00 00 00       	mov    $0x28,%eax
f010455d:	89 ca                	mov    %ecx,%edx
f010455f:	ee                   	out    %al,(%dx)
f0104560:	b8 02 00 00 00       	mov    $0x2,%eax
f0104565:	ee                   	out    %al,(%dx)
f0104566:	b8 01 00 00 00       	mov    $0x1,%eax
f010456b:	ee                   	out    %al,(%dx)
f010456c:	bf 68 00 00 00       	mov    $0x68,%edi
f0104571:	89 f8                	mov    %edi,%eax
f0104573:	89 f2                	mov    %esi,%edx
f0104575:	ee                   	out    %al,(%dx)
f0104576:	b9 0a 00 00 00       	mov    $0xa,%ecx
f010457b:	89 c8                	mov    %ecx,%eax
f010457d:	ee                   	out    %al,(%dx)
f010457e:	89 f8                	mov    %edi,%eax
f0104580:	89 da                	mov    %ebx,%edx
f0104582:	ee                   	out    %al,(%dx)
f0104583:	89 c8                	mov    %ecx,%eax
f0104585:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0104586:	0f b7 05 0e d3 16 f0 	movzwl 0xf016d30e,%eax
f010458d:	66 83 f8 ff          	cmp    $0xffff,%ax
f0104591:	75 08                	jne    f010459b <pic_init+0x95>
}
f0104593:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104596:	5b                   	pop    %ebx
f0104597:	5e                   	pop    %esi
f0104598:	5f                   	pop    %edi
f0104599:	5d                   	pop    %ebp
f010459a:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f010459b:	83 ec 0c             	sub    $0xc,%esp
f010459e:	0f b7 c0             	movzwl %ax,%eax
f01045a1:	50                   	push   %eax
f01045a2:	e8 e1 fe ff ff       	call   f0104488 <irq_setmask_8259A>
f01045a7:	83 c4 10             	add    $0x10,%esp
}
f01045aa:	eb e7                	jmp    f0104593 <pic_init+0x8d>

f01045ac <irq_eoi>:
f01045ac:	b8 20 00 00 00       	mov    $0x20,%eax
f01045b1:	ba 20 00 00 00       	mov    $0x20,%edx
f01045b6:	ee                   	out    %al,(%dx)
f01045b7:	ba a0 00 00 00       	mov    $0xa0,%edx
f01045bc:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01045bd:	c3                   	ret    

f01045be <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01045be:	55                   	push   %ebp
f01045bf:	89 e5                	mov    %esp,%ebp
f01045c1:	53                   	push   %ebx
f01045c2:	83 ec 10             	sub    $0x10,%esp
f01045c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f01045c8:	ff 75 08             	pushl  0x8(%ebp)
f01045cb:	e8 14 c2 ff ff       	call   f01007e4 <cputchar>
	(*cnt)++;
f01045d0:	83 03 01             	addl   $0x1,(%ebx)
}
f01045d3:	83 c4 10             	add    $0x10,%esp
f01045d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01045d9:	c9                   	leave  
f01045da:	c3                   	ret    

f01045db <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01045db:	55                   	push   %ebp
f01045dc:	89 e5                	mov    %esp,%ebp
f01045de:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01045e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01045e8:	ff 75 0c             	pushl  0xc(%ebp)
f01045eb:	ff 75 08             	pushl  0x8(%ebp)
f01045ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01045f1:	50                   	push   %eax
f01045f2:	68 be 45 10 f0       	push   $0xf01045be
f01045f7:	e8 ad 1e 00 00       	call   f01064a9 <vprintfmt>
	return cnt;
}
f01045fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01045ff:	c9                   	leave  
f0104600:	c3                   	ret    

f0104601 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0104601:	55                   	push   %ebp
f0104602:	89 e5                	mov    %esp,%ebp
f0104604:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0104607:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010460a:	50                   	push   %eax
f010460b:	ff 75 08             	pushl  0x8(%ebp)
f010460e:	e8 c8 ff ff ff       	call   f01045db <vcprintf>
	va_end(ap);
	return cnt;
}
f0104613:	c9                   	leave  
f0104614:	c3                   	ret    

f0104615 <trap_init_percpu>:

// Initialize and load the per-CPU TSS and IDT
//mapped text lab7
 void
trap_init_percpu(void)
{
f0104615:	55                   	push   %ebp
f0104616:	89 e5                	mov    %esp,%ebp
f0104618:	57                   	push   %edi
f0104619:	56                   	push   %esi
f010461a:	53                   	push   %ebx
f010461b:	83 ec 24             	sub    $0x24,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	cprintf("in %s\n", __FUNCTION__);
f010461e:	68 60 a1 10 f0       	push   $0xf010a160
f0104623:	68 77 9b 10 f0       	push   $0xf0109b77
f0104628:	e8 d4 ff ff ff       	call   f0104601 <cprintf>
	int i = cpunum();
f010462d:	e8 e4 2c 00 00       	call   f0107316 <cpunum>
f0104632:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0104634:	e8 dd 2c 00 00       	call   f0107316 <cpunum>
f0104639:	6b c0 74             	imul   $0x74,%eax,%eax
f010463c:	89 d9                	mov    %ebx,%ecx
f010463e:	c1 e1 10             	shl    $0x10,%ecx
f0104641:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0104646:	29 ca                	sub    %ecx,%edx
f0104648:	89 90 30 b0 16 f0    	mov    %edx,-0xfe94fd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f010464e:	e8 c3 2c 00 00       	call   f0107316 <cpunum>
f0104653:	6b c0 74             	imul   $0x74,%eax,%eax
f0104656:	66 c7 80 34 b0 16 f0 	movw   $0x10,-0xfe94fcc(%eax)
f010465d:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f010465f:	e8 b2 2c 00 00       	call   f0107316 <cpunum>
f0104664:	6b c0 74             	imul   $0x74,%eax,%eax
f0104667:	66 c7 80 92 b0 16 f0 	movw   $0x68,-0xfe94f6e(%eax)
f010466e:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0104670:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0104677:	89 fb                	mov    %edi,%ebx
f0104679:	c1 fb 03             	sar    $0x3,%ebx
f010467c:	e8 95 2c 00 00       	call   f0107316 <cpunum>
f0104681:	89 c6                	mov    %eax,%esi
f0104683:	e8 8e 2c 00 00       	call   f0107316 <cpunum>
f0104688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010468b:	e8 86 2c 00 00       	call   f0107316 <cpunum>
f0104690:	66 c7 04 dd 00 a0 12 	movw   $0x67,-0xfed6000(,%ebx,8)
f0104697:	f0 67 00 
f010469a:	6b f6 74             	imul   $0x74,%esi,%esi
f010469d:	81 c6 2c b0 16 f0    	add    $0xf016b02c,%esi
f01046a3:	66 89 34 dd 02 a0 12 	mov    %si,-0xfed5ffe(,%ebx,8)
f01046aa:	f0 
f01046ab:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f01046af:	81 c2 2c b0 16 f0    	add    $0xf016b02c,%edx
f01046b5:	c1 ea 10             	shr    $0x10,%edx
f01046b8:	88 14 dd 04 a0 12 f0 	mov    %dl,-0xfed5ffc(,%ebx,8)
f01046bf:	c6 04 dd 06 a0 12 f0 	movb   $0x40,-0xfed5ffa(,%ebx,8)
f01046c6:	40 
f01046c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01046ca:	05 2c b0 16 f0       	add    $0xf016b02c,%eax
f01046cf:	c1 e8 18             	shr    $0x18,%eax
f01046d2:	88 04 dd 07 a0 12 f0 	mov    %al,-0xfed5ff9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f01046d9:	c6 04 dd 05 a0 12 f0 	movb   $0x89,-0xfed5ffb(,%ebx,8)
f01046e0:	89 
	asm volatile("ltr %0" : : "r" (sel));
f01046e1:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f01046e4:	b8 10 d3 16 f0       	mov    $0xf016d310,%eax
f01046e9:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f01046ec:	83 c4 10             	add    $0x10,%esp
f01046ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01046f2:	5b                   	pop    %ebx
f01046f3:	5e                   	pop    %esi
f01046f4:	5f                   	pop    %edi
f01046f5:	5d                   	pop    %ebp
f01046f6:	c3                   	ret    

f01046f7 <trap_init>:
{
f01046f7:	55                   	push   %ebp
f01046f8:	89 e5                	mov    %esp,%ebp
f01046fa:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f01046fd:	b8 38 13 12 f0       	mov    $0xf0121338,%eax
f0104702:	66 a3 80 a0 12 f0    	mov    %ax,0xf012a080
f0104708:	66 c7 05 82 a0 12 f0 	movw   $0x8,0xf012a082
f010470f:	08 00 
f0104711:	c6 05 84 a0 12 f0 00 	movb   $0x0,0xf012a084
f0104718:	c6 05 85 a0 12 f0 8e 	movb   $0x8e,0xf012a085
f010471f:	c1 e8 10             	shr    $0x10,%eax
f0104722:	66 a3 86 a0 12 f0    	mov    %ax,0xf012a086
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f0104728:	b8 42 13 12 f0       	mov    $0xf0121342,%eax
f010472d:	66 a3 88 a0 12 f0    	mov    %ax,0xf012a088
f0104733:	66 c7 05 8a a0 12 f0 	movw   $0x8,0xf012a08a
f010473a:	08 00 
f010473c:	c6 05 8c a0 12 f0 00 	movb   $0x0,0xf012a08c
f0104743:	c6 05 8d a0 12 f0 8e 	movb   $0x8e,0xf012a08d
f010474a:	c1 e8 10             	shr    $0x10,%eax
f010474d:	66 a3 8e a0 12 f0    	mov    %ax,0xf012a08e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0104753:	b8 4c 13 12 f0       	mov    $0xf012134c,%eax
f0104758:	66 a3 90 a0 12 f0    	mov    %ax,0xf012a090
f010475e:	66 c7 05 92 a0 12 f0 	movw   $0x8,0xf012a092
f0104765:	08 00 
f0104767:	c6 05 94 a0 12 f0 00 	movb   $0x0,0xf012a094
f010476e:	c6 05 95 a0 12 f0 8e 	movb   $0x8e,0xf012a095
f0104775:	c1 e8 10             	shr    $0x10,%eax
f0104778:	66 a3 96 a0 12 f0    	mov    %ax,0xf012a096
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f010477e:	b8 56 13 12 f0       	mov    $0xf0121356,%eax
f0104783:	66 a3 98 a0 12 f0    	mov    %ax,0xf012a098
f0104789:	66 c7 05 9a a0 12 f0 	movw   $0x8,0xf012a09a
f0104790:	08 00 
f0104792:	c6 05 9c a0 12 f0 00 	movb   $0x0,0xf012a09c
f0104799:	c6 05 9d a0 12 f0 ee 	movb   $0xee,0xf012a09d
f01047a0:	c1 e8 10             	shr    $0x10,%eax
f01047a3:	66 a3 9e a0 12 f0    	mov    %ax,0xf012a09e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f01047a9:	b8 60 13 12 f0       	mov    $0xf0121360,%eax
f01047ae:	66 a3 a0 a0 12 f0    	mov    %ax,0xf012a0a0
f01047b4:	66 c7 05 a2 a0 12 f0 	movw   $0x8,0xf012a0a2
f01047bb:	08 00 
f01047bd:	c6 05 a4 a0 12 f0 00 	movb   $0x0,0xf012a0a4
f01047c4:	c6 05 a5 a0 12 f0 ee 	movb   $0xee,0xf012a0a5
f01047cb:	c1 e8 10             	shr    $0x10,%eax
f01047ce:	66 a3 a6 a0 12 f0    	mov    %ax,0xf012a0a6
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f01047d4:	b8 6a 13 12 f0       	mov    $0xf012136a,%eax
f01047d9:	66 a3 a8 a0 12 f0    	mov    %ax,0xf012a0a8
f01047df:	66 c7 05 aa a0 12 f0 	movw   $0x8,0xf012a0aa
f01047e6:	08 00 
f01047e8:	c6 05 ac a0 12 f0 00 	movb   $0x0,0xf012a0ac
f01047ef:	c6 05 ad a0 12 f0 ee 	movb   $0xee,0xf012a0ad
f01047f6:	c1 e8 10             	shr    $0x10,%eax
f01047f9:	66 a3 ae a0 12 f0    	mov    %ax,0xf012a0ae
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f01047ff:	b8 74 13 12 f0       	mov    $0xf0121374,%eax
f0104804:	66 a3 b0 a0 12 f0    	mov    %ax,0xf012a0b0
f010480a:	66 c7 05 b2 a0 12 f0 	movw   $0x8,0xf012a0b2
f0104811:	08 00 
f0104813:	c6 05 b4 a0 12 f0 00 	movb   $0x0,0xf012a0b4
f010481a:	c6 05 b5 a0 12 f0 8e 	movb   $0x8e,0xf012a0b5
f0104821:	c1 e8 10             	shr    $0x10,%eax
f0104824:	66 a3 b6 a0 12 f0    	mov    %ax,0xf012a0b6
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f010482a:	b8 7e 13 12 f0       	mov    $0xf012137e,%eax
f010482f:	66 a3 b8 a0 12 f0    	mov    %ax,0xf012a0b8
f0104835:	66 c7 05 ba a0 12 f0 	movw   $0x8,0xf012a0ba
f010483c:	08 00 
f010483e:	c6 05 bc a0 12 f0 00 	movb   $0x0,0xf012a0bc
f0104845:	c6 05 bd a0 12 f0 8e 	movb   $0x8e,0xf012a0bd
f010484c:	c1 e8 10             	shr    $0x10,%eax
f010484f:	66 a3 be a0 12 f0    	mov    %ax,0xf012a0be
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f0104855:	b8 88 13 12 f0       	mov    $0xf0121388,%eax
f010485a:	66 a3 c0 a0 12 f0    	mov    %ax,0xf012a0c0
f0104860:	66 c7 05 c2 a0 12 f0 	movw   $0x8,0xf012a0c2
f0104867:	08 00 
f0104869:	c6 05 c4 a0 12 f0 00 	movb   $0x0,0xf012a0c4
f0104870:	c6 05 c5 a0 12 f0 8e 	movb   $0x8e,0xf012a0c5
f0104877:	c1 e8 10             	shr    $0x10,%eax
f010487a:	66 a3 c6 a0 12 f0    	mov    %ax,0xf012a0c6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f0104880:	b8 90 13 12 f0       	mov    $0xf0121390,%eax
f0104885:	66 a3 d0 a0 12 f0    	mov    %ax,0xf012a0d0
f010488b:	66 c7 05 d2 a0 12 f0 	movw   $0x8,0xf012a0d2
f0104892:	08 00 
f0104894:	c6 05 d4 a0 12 f0 00 	movb   $0x0,0xf012a0d4
f010489b:	c6 05 d5 a0 12 f0 8e 	movb   $0x8e,0xf012a0d5
f01048a2:	c1 e8 10             	shr    $0x10,%eax
f01048a5:	66 a3 d6 a0 12 f0    	mov    %ax,0xf012a0d6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f01048ab:	b8 98 13 12 f0       	mov    $0xf0121398,%eax
f01048b0:	66 a3 d8 a0 12 f0    	mov    %ax,0xf012a0d8
f01048b6:	66 c7 05 da a0 12 f0 	movw   $0x8,0xf012a0da
f01048bd:	08 00 
f01048bf:	c6 05 dc a0 12 f0 00 	movb   $0x0,0xf012a0dc
f01048c6:	c6 05 dd a0 12 f0 8e 	movb   $0x8e,0xf012a0dd
f01048cd:	c1 e8 10             	shr    $0x10,%eax
f01048d0:	66 a3 de a0 12 f0    	mov    %ax,0xf012a0de
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f01048d6:	b8 a0 13 12 f0       	mov    $0xf01213a0,%eax
f01048db:	66 a3 e0 a0 12 f0    	mov    %ax,0xf012a0e0
f01048e1:	66 c7 05 e2 a0 12 f0 	movw   $0x8,0xf012a0e2
f01048e8:	08 00 
f01048ea:	c6 05 e4 a0 12 f0 00 	movb   $0x0,0xf012a0e4
f01048f1:	c6 05 e5 a0 12 f0 8e 	movb   $0x8e,0xf012a0e5
f01048f8:	c1 e8 10             	shr    $0x10,%eax
f01048fb:	66 a3 e6 a0 12 f0    	mov    %ax,0xf012a0e6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f0104901:	b8 a8 13 12 f0       	mov    $0xf01213a8,%eax
f0104906:	66 a3 e8 a0 12 f0    	mov    %ax,0xf012a0e8
f010490c:	66 c7 05 ea a0 12 f0 	movw   $0x8,0xf012a0ea
f0104913:	08 00 
f0104915:	c6 05 ec a0 12 f0 00 	movb   $0x0,0xf012a0ec
f010491c:	c6 05 ed a0 12 f0 8e 	movb   $0x8e,0xf012a0ed
f0104923:	c1 e8 10             	shr    $0x10,%eax
f0104926:	66 a3 ee a0 12 f0    	mov    %ax,0xf012a0ee
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f010492c:	b8 b0 13 12 f0       	mov    $0xf01213b0,%eax
f0104931:	66 a3 f0 a0 12 f0    	mov    %ax,0xf012a0f0
f0104937:	66 c7 05 f2 a0 12 f0 	movw   $0x8,0xf012a0f2
f010493e:	08 00 
f0104940:	c6 05 f4 a0 12 f0 00 	movb   $0x0,0xf012a0f4
f0104947:	c6 05 f5 a0 12 f0 8e 	movb   $0x8e,0xf012a0f5
f010494e:	c1 e8 10             	shr    $0x10,%eax
f0104951:	66 a3 f6 a0 12 f0    	mov    %ax,0xf012a0f6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f0104957:	b8 b8 13 12 f0       	mov    $0xf01213b8,%eax
f010495c:	66 a3 00 a1 12 f0    	mov    %ax,0xf012a100
f0104962:	66 c7 05 02 a1 12 f0 	movw   $0x8,0xf012a102
f0104969:	08 00 
f010496b:	c6 05 04 a1 12 f0 00 	movb   $0x0,0xf012a104
f0104972:	c6 05 05 a1 12 f0 8e 	movb   $0x8e,0xf012a105
f0104979:	c1 e8 10             	shr    $0x10,%eax
f010497c:	66 a3 06 a1 12 f0    	mov    %ax,0xf012a106
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f0104982:	b8 be 13 12 f0       	mov    $0xf01213be,%eax
f0104987:	66 a3 08 a1 12 f0    	mov    %ax,0xf012a108
f010498d:	66 c7 05 0a a1 12 f0 	movw   $0x8,0xf012a10a
f0104994:	08 00 
f0104996:	c6 05 0c a1 12 f0 00 	movb   $0x0,0xf012a10c
f010499d:	c6 05 0d a1 12 f0 8e 	movb   $0x8e,0xf012a10d
f01049a4:	c1 e8 10             	shr    $0x10,%eax
f01049a7:	66 a3 0e a1 12 f0    	mov    %ax,0xf012a10e
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f01049ad:	b8 c2 13 12 f0       	mov    $0xf01213c2,%eax
f01049b2:	66 a3 10 a1 12 f0    	mov    %ax,0xf012a110
f01049b8:	66 c7 05 12 a1 12 f0 	movw   $0x8,0xf012a112
f01049bf:	08 00 
f01049c1:	c6 05 14 a1 12 f0 00 	movb   $0x0,0xf012a114
f01049c8:	c6 05 15 a1 12 f0 8e 	movb   $0x8e,0xf012a115
f01049cf:	c1 e8 10             	shr    $0x10,%eax
f01049d2:	66 a3 16 a1 12 f0    	mov    %ax,0xf012a116
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f01049d8:	b8 c8 13 12 f0       	mov    $0xf01213c8,%eax
f01049dd:	66 a3 18 a1 12 f0    	mov    %ax,0xf012a118
f01049e3:	66 c7 05 1a a1 12 f0 	movw   $0x8,0xf012a11a
f01049ea:	08 00 
f01049ec:	c6 05 1c a1 12 f0 00 	movb   $0x0,0xf012a11c
f01049f3:	c6 05 1d a1 12 f0 8e 	movb   $0x8e,0xf012a11d
f01049fa:	c1 e8 10             	shr    $0x10,%eax
f01049fd:	66 a3 1e a1 12 f0    	mov    %ax,0xf012a11e
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f0104a03:	b8 ce 13 12 f0       	mov    $0xf01213ce,%eax
f0104a08:	66 a3 00 a2 12 f0    	mov    %ax,0xf012a200
f0104a0e:	66 c7 05 02 a2 12 f0 	movw   $0x8,0xf012a202
f0104a15:	08 00 
f0104a17:	c6 05 04 a2 12 f0 00 	movb   $0x0,0xf012a204
f0104a1e:	c6 05 05 a2 12 f0 ee 	movb   $0xee,0xf012a205
f0104a25:	c1 e8 10             	shr    $0x10,%eax
f0104a28:	66 a3 06 a2 12 f0    	mov    %ax,0xf012a206
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f0104a2e:	b8 d4 13 12 f0       	mov    $0xf01213d4,%eax
f0104a33:	66 a3 80 a1 12 f0    	mov    %ax,0xf012a180
f0104a39:	66 c7 05 82 a1 12 f0 	movw   $0x8,0xf012a182
f0104a40:	08 00 
f0104a42:	c6 05 84 a1 12 f0 00 	movb   $0x0,0xf012a184
f0104a49:	c6 05 85 a1 12 f0 8e 	movb   $0x8e,0xf012a185
f0104a50:	c1 e8 10             	shr    $0x10,%eax
f0104a53:	66 a3 86 a1 12 f0    	mov    %ax,0xf012a186
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f0104a59:	b8 da 13 12 f0       	mov    $0xf01213da,%eax
f0104a5e:	66 a3 88 a1 12 f0    	mov    %ax,0xf012a188
f0104a64:	66 c7 05 8a a1 12 f0 	movw   $0x8,0xf012a18a
f0104a6b:	08 00 
f0104a6d:	c6 05 8c a1 12 f0 00 	movb   $0x0,0xf012a18c
f0104a74:	c6 05 8d a1 12 f0 8e 	movb   $0x8e,0xf012a18d
f0104a7b:	c1 e8 10             	shr    $0x10,%eax
f0104a7e:	66 a3 8e a1 12 f0    	mov    %ax,0xf012a18e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f0104a84:	b8 e0 13 12 f0       	mov    $0xf01213e0,%eax
f0104a89:	66 a3 90 a1 12 f0    	mov    %ax,0xf012a190
f0104a8f:	66 c7 05 92 a1 12 f0 	movw   $0x8,0xf012a192
f0104a96:	08 00 
f0104a98:	c6 05 94 a1 12 f0 00 	movb   $0x0,0xf012a194
f0104a9f:	c6 05 95 a1 12 f0 8e 	movb   $0x8e,0xf012a195
f0104aa6:	c1 e8 10             	shr    $0x10,%eax
f0104aa9:	66 a3 96 a1 12 f0    	mov    %ax,0xf012a196
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f0104aaf:	b8 e6 13 12 f0       	mov    $0xf01213e6,%eax
f0104ab4:	66 a3 98 a1 12 f0    	mov    %ax,0xf012a198
f0104aba:	66 c7 05 9a a1 12 f0 	movw   $0x8,0xf012a19a
f0104ac1:	08 00 
f0104ac3:	c6 05 9c a1 12 f0 00 	movb   $0x0,0xf012a19c
f0104aca:	c6 05 9d a1 12 f0 8e 	movb   $0x8e,0xf012a19d
f0104ad1:	c1 e8 10             	shr    $0x10,%eax
f0104ad4:	66 a3 9e a1 12 f0    	mov    %ax,0xf012a19e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f0104ada:	b8 ec 13 12 f0       	mov    $0xf01213ec,%eax
f0104adf:	66 a3 a0 a1 12 f0    	mov    %ax,0xf012a1a0
f0104ae5:	66 c7 05 a2 a1 12 f0 	movw   $0x8,0xf012a1a2
f0104aec:	08 00 
f0104aee:	c6 05 a4 a1 12 f0 00 	movb   $0x0,0xf012a1a4
f0104af5:	c6 05 a5 a1 12 f0 8e 	movb   $0x8e,0xf012a1a5
f0104afc:	c1 e8 10             	shr    $0x10,%eax
f0104aff:	66 a3 a6 a1 12 f0    	mov    %ax,0xf012a1a6
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f0104b05:	b8 f2 13 12 f0       	mov    $0xf01213f2,%eax
f0104b0a:	66 a3 a8 a1 12 f0    	mov    %ax,0xf012a1a8
f0104b10:	66 c7 05 aa a1 12 f0 	movw   $0x8,0xf012a1aa
f0104b17:	08 00 
f0104b19:	c6 05 ac a1 12 f0 00 	movb   $0x0,0xf012a1ac
f0104b20:	c6 05 ad a1 12 f0 8e 	movb   $0x8e,0xf012a1ad
f0104b27:	c1 e8 10             	shr    $0x10,%eax
f0104b2a:	66 a3 ae a1 12 f0    	mov    %ax,0xf012a1ae
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f0104b30:	b8 f8 13 12 f0       	mov    $0xf01213f8,%eax
f0104b35:	66 a3 b0 a1 12 f0    	mov    %ax,0xf012a1b0
f0104b3b:	66 c7 05 b2 a1 12 f0 	movw   $0x8,0xf012a1b2
f0104b42:	08 00 
f0104b44:	c6 05 b4 a1 12 f0 00 	movb   $0x0,0xf012a1b4
f0104b4b:	c6 05 b5 a1 12 f0 8e 	movb   $0x8e,0xf012a1b5
f0104b52:	c1 e8 10             	shr    $0x10,%eax
f0104b55:	66 a3 b6 a1 12 f0    	mov    %ax,0xf012a1b6
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f0104b5b:	b8 fe 13 12 f0       	mov    $0xf01213fe,%eax
f0104b60:	66 a3 b8 a1 12 f0    	mov    %ax,0xf012a1b8
f0104b66:	66 c7 05 ba a1 12 f0 	movw   $0x8,0xf012a1ba
f0104b6d:	08 00 
f0104b6f:	c6 05 bc a1 12 f0 00 	movb   $0x0,0xf012a1bc
f0104b76:	c6 05 bd a1 12 f0 8e 	movb   $0x8e,0xf012a1bd
f0104b7d:	c1 e8 10             	shr    $0x10,%eax
f0104b80:	66 a3 be a1 12 f0    	mov    %ax,0xf012a1be
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f0104b86:	b8 04 14 12 f0       	mov    $0xf0121404,%eax
f0104b8b:	66 a3 c0 a1 12 f0    	mov    %ax,0xf012a1c0
f0104b91:	66 c7 05 c2 a1 12 f0 	movw   $0x8,0xf012a1c2
f0104b98:	08 00 
f0104b9a:	c6 05 c4 a1 12 f0 00 	movb   $0x0,0xf012a1c4
f0104ba1:	c6 05 c5 a1 12 f0 8e 	movb   $0x8e,0xf012a1c5
f0104ba8:	c1 e8 10             	shr    $0x10,%eax
f0104bab:	66 a3 c6 a1 12 f0    	mov    %ax,0xf012a1c6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f0104bb1:	b8 0a 14 12 f0       	mov    $0xf012140a,%eax
f0104bb6:	66 a3 c8 a1 12 f0    	mov    %ax,0xf012a1c8
f0104bbc:	66 c7 05 ca a1 12 f0 	movw   $0x8,0xf012a1ca
f0104bc3:	08 00 
f0104bc5:	c6 05 cc a1 12 f0 00 	movb   $0x0,0xf012a1cc
f0104bcc:	c6 05 cd a1 12 f0 8e 	movb   $0x8e,0xf012a1cd
f0104bd3:	c1 e8 10             	shr    $0x10,%eax
f0104bd6:	66 a3 ce a1 12 f0    	mov    %ax,0xf012a1ce
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f0104bdc:	b8 10 14 12 f0       	mov    $0xf0121410,%eax
f0104be1:	66 a3 d0 a1 12 f0    	mov    %ax,0xf012a1d0
f0104be7:	66 c7 05 d2 a1 12 f0 	movw   $0x8,0xf012a1d2
f0104bee:	08 00 
f0104bf0:	c6 05 d4 a1 12 f0 00 	movb   $0x0,0xf012a1d4
f0104bf7:	c6 05 d5 a1 12 f0 8e 	movb   $0x8e,0xf012a1d5
f0104bfe:	c1 e8 10             	shr    $0x10,%eax
f0104c01:	66 a3 d6 a1 12 f0    	mov    %ax,0xf012a1d6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f0104c07:	b8 16 14 12 f0       	mov    $0xf0121416,%eax
f0104c0c:	66 a3 d8 a1 12 f0    	mov    %ax,0xf012a1d8
f0104c12:	66 c7 05 da a1 12 f0 	movw   $0x8,0xf012a1da
f0104c19:	08 00 
f0104c1b:	c6 05 dc a1 12 f0 00 	movb   $0x0,0xf012a1dc
f0104c22:	c6 05 dd a1 12 f0 8e 	movb   $0x8e,0xf012a1dd
f0104c29:	c1 e8 10             	shr    $0x10,%eax
f0104c2c:	66 a3 de a1 12 f0    	mov    %ax,0xf012a1de
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f0104c32:	b8 1c 14 12 f0       	mov    $0xf012141c,%eax
f0104c37:	66 a3 e0 a1 12 f0    	mov    %ax,0xf012a1e0
f0104c3d:	66 c7 05 e2 a1 12 f0 	movw   $0x8,0xf012a1e2
f0104c44:	08 00 
f0104c46:	c6 05 e4 a1 12 f0 00 	movb   $0x0,0xf012a1e4
f0104c4d:	c6 05 e5 a1 12 f0 8e 	movb   $0x8e,0xf012a1e5
f0104c54:	c1 e8 10             	shr    $0x10,%eax
f0104c57:	66 a3 e6 a1 12 f0    	mov    %ax,0xf012a1e6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f0104c5d:	b8 22 14 12 f0       	mov    $0xf0121422,%eax
f0104c62:	66 a3 e8 a1 12 f0    	mov    %ax,0xf012a1e8
f0104c68:	66 c7 05 ea a1 12 f0 	movw   $0x8,0xf012a1ea
f0104c6f:	08 00 
f0104c71:	c6 05 ec a1 12 f0 00 	movb   $0x0,0xf012a1ec
f0104c78:	c6 05 ed a1 12 f0 8e 	movb   $0x8e,0xf012a1ed
f0104c7f:	c1 e8 10             	shr    $0x10,%eax
f0104c82:	66 a3 ee a1 12 f0    	mov    %ax,0xf012a1ee
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f0104c88:	b8 28 14 12 f0       	mov    $0xf0121428,%eax
f0104c8d:	66 a3 f0 a1 12 f0    	mov    %ax,0xf012a1f0
f0104c93:	66 c7 05 f2 a1 12 f0 	movw   $0x8,0xf012a1f2
f0104c9a:	08 00 
f0104c9c:	c6 05 f4 a1 12 f0 00 	movb   $0x0,0xf012a1f4
f0104ca3:	c6 05 f5 a1 12 f0 8e 	movb   $0x8e,0xf012a1f5
f0104caa:	c1 e8 10             	shr    $0x10,%eax
f0104cad:	66 a3 f6 a1 12 f0    	mov    %ax,0xf012a1f6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f0104cb3:	b8 2e 14 12 f0       	mov    $0xf012142e,%eax
f0104cb8:	66 a3 f8 a1 12 f0    	mov    %ax,0xf012a1f8
f0104cbe:	66 c7 05 fa a1 12 f0 	movw   $0x8,0xf012a1fa
f0104cc5:	08 00 
f0104cc7:	c6 05 fc a1 12 f0 00 	movb   $0x0,0xf012a1fc
f0104cce:	c6 05 fd a1 12 f0 8e 	movb   $0x8e,0xf012a1fd
f0104cd5:	c1 e8 10             	shr    $0x10,%eax
f0104cd8:	66 a3 fe a1 12 f0    	mov    %ax,0xf012a1fe
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f0104cde:	b8 34 14 12 f0       	mov    $0xf0121434,%eax
f0104ce3:	66 a3 18 a2 12 f0    	mov    %ax,0xf012a218
f0104ce9:	66 c7 05 1a a2 12 f0 	movw   $0x8,0xf012a21a
f0104cf0:	08 00 
f0104cf2:	c6 05 1c a2 12 f0 00 	movb   $0x0,0xf012a21c
f0104cf9:	c6 05 1d a2 12 f0 8e 	movb   $0x8e,0xf012a21d
f0104d00:	c1 e8 10             	shr    $0x10,%eax
f0104d03:	66 a3 1e a2 12 f0    	mov    %ax,0xf012a21e
	trap_init_percpu();
f0104d09:	e8 07 f9 ff ff       	call   f0104615 <trap_init_percpu>
}
f0104d0e:	c9                   	leave  
f0104d0f:	c3                   	ret    

f0104d10 <print_regs>:
}

//mapped text lab7
 void
print_regs(struct PushRegs *regs)
{
f0104d10:	55                   	push   %ebp
f0104d11:	89 e5                	mov    %esp,%ebp
f0104d13:	53                   	push   %ebx
f0104d14:	83 ec 0c             	sub    $0xc,%esp
f0104d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104d1a:	ff 33                	pushl  (%ebx)
f0104d1c:	68 7e 9b 10 f0       	push   $0xf0109b7e
f0104d21:	e8 db f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104d26:	83 c4 08             	add    $0x8,%esp
f0104d29:	ff 73 04             	pushl  0x4(%ebx)
f0104d2c:	68 8d 9b 10 f0       	push   $0xf0109b8d
f0104d31:	e8 cb f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104d36:	83 c4 08             	add    $0x8,%esp
f0104d39:	ff 73 08             	pushl  0x8(%ebx)
f0104d3c:	68 9c 9b 10 f0       	push   $0xf0109b9c
f0104d41:	e8 bb f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104d46:	83 c4 08             	add    $0x8,%esp
f0104d49:	ff 73 0c             	pushl  0xc(%ebx)
f0104d4c:	68 ab 9b 10 f0       	push   $0xf0109bab
f0104d51:	e8 ab f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104d56:	83 c4 08             	add    $0x8,%esp
f0104d59:	ff 73 10             	pushl  0x10(%ebx)
f0104d5c:	68 ba 9b 10 f0       	push   $0xf0109bba
f0104d61:	e8 9b f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104d66:	83 c4 08             	add    $0x8,%esp
f0104d69:	ff 73 14             	pushl  0x14(%ebx)
f0104d6c:	68 c9 9b 10 f0       	push   $0xf0109bc9
f0104d71:	e8 8b f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104d76:	83 c4 08             	add    $0x8,%esp
f0104d79:	ff 73 18             	pushl  0x18(%ebx)
f0104d7c:	68 d8 9b 10 f0       	push   $0xf0109bd8
f0104d81:	e8 7b f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104d86:	83 c4 08             	add    $0x8,%esp
f0104d89:	ff 73 1c             	pushl  0x1c(%ebx)
f0104d8c:	68 e7 9b 10 f0       	push   $0xf0109be7
f0104d91:	e8 6b f8 ff ff       	call   f0104601 <cprintf>
}
f0104d96:	83 c4 10             	add    $0x10,%esp
f0104d99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104d9c:	c9                   	leave  
f0104d9d:	c3                   	ret    

f0104d9e <print_trapframe>:
{
f0104d9e:	55                   	push   %ebp
f0104d9f:	89 e5                	mov    %esp,%ebp
f0104da1:	56                   	push   %esi
f0104da2:	53                   	push   %ebx
f0104da3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0104da6:	83 ec 08             	sub    $0x8,%esp
f0104da9:	68 50 a1 10 f0       	push   $0xf010a150
f0104dae:	68 77 9b 10 f0       	push   $0xf0109b77
f0104db3:	e8 49 f8 ff ff       	call   f0104601 <cprintf>
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104db8:	e8 59 25 00 00       	call   f0107316 <cpunum>
f0104dbd:	83 c4 0c             	add    $0xc,%esp
f0104dc0:	50                   	push   %eax
f0104dc1:	53                   	push   %ebx
f0104dc2:	68 4b 9c 10 f0       	push   $0xf0109c4b
f0104dc7:	e8 35 f8 ff ff       	call   f0104601 <cprintf>
	print_regs(&tf->tf_regs);
f0104dcc:	89 1c 24             	mov    %ebx,(%esp)
f0104dcf:	e8 3c ff ff ff       	call   f0104d10 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104dd4:	83 c4 08             	add    $0x8,%esp
f0104dd7:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104ddb:	50                   	push   %eax
f0104ddc:	68 69 9c 10 f0       	push   $0xf0109c69
f0104de1:	e8 1b f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104de6:	83 c4 08             	add    $0x8,%esp
f0104de9:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104ded:	50                   	push   %eax
f0104dee:	68 7c 9c 10 f0       	push   $0xf0109c7c
f0104df3:	e8 09 f8 ff ff       	call   f0104601 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104df8:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104dfb:	83 c4 10             	add    $0x10,%esp
f0104dfe:	83 f8 13             	cmp    $0x13,%eax
f0104e01:	0f 86 e1 00 00 00    	jbe    f0104ee8 <print_trapframe+0x14a>
		return "System call";
f0104e07:	ba f6 9b 10 f0       	mov    $0xf0109bf6,%edx
	if (trapno == T_SYSCALL)
f0104e0c:	83 f8 30             	cmp    $0x30,%eax
f0104e0f:	74 13                	je     f0104e24 <print_trapframe+0x86>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104e11:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104e14:	83 fa 0f             	cmp    $0xf,%edx
f0104e17:	ba 02 9c 10 f0       	mov    $0xf0109c02,%edx
f0104e1c:	b9 11 9c 10 f0       	mov    $0xf0109c11,%ecx
f0104e21:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104e24:	83 ec 04             	sub    $0x4,%esp
f0104e27:	52                   	push   %edx
f0104e28:	50                   	push   %eax
f0104e29:	68 8f 9c 10 f0       	push   $0xf0109c8f
f0104e2e:	e8 ce f7 ff ff       	call   f0104601 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104e33:	83 c4 10             	add    $0x10,%esp
f0104e36:	39 1d 0c b9 5d f0    	cmp    %ebx,0xf05db90c
f0104e3c:	0f 84 b2 00 00 00    	je     f0104ef4 <print_trapframe+0x156>
	cprintf("  err  0x%08x", tf->tf_err);
f0104e42:	83 ec 08             	sub    $0x8,%esp
f0104e45:	ff 73 2c             	pushl  0x2c(%ebx)
f0104e48:	68 b0 9c 10 f0       	push   $0xf0109cb0
f0104e4d:	e8 af f7 ff ff       	call   f0104601 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104e52:	83 c4 10             	add    $0x10,%esp
f0104e55:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104e59:	0f 85 b8 00 00 00    	jne    f0104f17 <print_trapframe+0x179>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104e5f:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104e62:	89 c2                	mov    %eax,%edx
f0104e64:	83 e2 01             	and    $0x1,%edx
f0104e67:	b9 24 9c 10 f0       	mov    $0xf0109c24,%ecx
f0104e6c:	ba 2f 9c 10 f0       	mov    $0xf0109c2f,%edx
f0104e71:	0f 44 ca             	cmove  %edx,%ecx
f0104e74:	89 c2                	mov    %eax,%edx
f0104e76:	83 e2 02             	and    $0x2,%edx
f0104e79:	be 3b 9c 10 f0       	mov    $0xf0109c3b,%esi
f0104e7e:	ba 41 9c 10 f0       	mov    $0xf0109c41,%edx
f0104e83:	0f 45 d6             	cmovne %esi,%edx
f0104e86:	83 e0 04             	and    $0x4,%eax
f0104e89:	b8 46 9c 10 f0       	mov    $0xf0109c46,%eax
f0104e8e:	be 93 9e 10 f0       	mov    $0xf0109e93,%esi
f0104e93:	0f 44 c6             	cmove  %esi,%eax
f0104e96:	51                   	push   %ecx
f0104e97:	52                   	push   %edx
f0104e98:	50                   	push   %eax
f0104e99:	68 be 9c 10 f0       	push   $0xf0109cbe
f0104e9e:	e8 5e f7 ff ff       	call   f0104601 <cprintf>
f0104ea3:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104ea6:	83 ec 08             	sub    $0x8,%esp
f0104ea9:	ff 73 30             	pushl  0x30(%ebx)
f0104eac:	68 cd 9c 10 f0       	push   $0xf0109ccd
f0104eb1:	e8 4b f7 ff ff       	call   f0104601 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104eb6:	83 c4 08             	add    $0x8,%esp
f0104eb9:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104ebd:	50                   	push   %eax
f0104ebe:	68 dc 9c 10 f0       	push   $0xf0109cdc
f0104ec3:	e8 39 f7 ff ff       	call   f0104601 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104ec8:	83 c4 08             	add    $0x8,%esp
f0104ecb:	ff 73 38             	pushl  0x38(%ebx)
f0104ece:	68 ef 9c 10 f0       	push   $0xf0109cef
f0104ed3:	e8 29 f7 ff ff       	call   f0104601 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104ed8:	83 c4 10             	add    $0x10,%esp
f0104edb:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104edf:	75 4b                	jne    f0104f2c <print_trapframe+0x18e>
}
f0104ee1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104ee4:	5b                   	pop    %ebx
f0104ee5:	5e                   	pop    %esi
f0104ee6:	5d                   	pop    %ebp
f0104ee7:	c3                   	ret    
		return excnames[trapno];
f0104ee8:	8b 14 85 00 a1 10 f0 	mov    -0xfef5f00(,%eax,4),%edx
f0104eef:	e9 30 ff ff ff       	jmp    f0104e24 <print_trapframe+0x86>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104ef4:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104ef8:	0f 85 44 ff ff ff    	jne    f0104e42 <print_trapframe+0xa4>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104efe:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104f01:	83 ec 08             	sub    $0x8,%esp
f0104f04:	50                   	push   %eax
f0104f05:	68 a1 9c 10 f0       	push   $0xf0109ca1
f0104f0a:	e8 f2 f6 ff ff       	call   f0104601 <cprintf>
f0104f0f:	83 c4 10             	add    $0x10,%esp
f0104f12:	e9 2b ff ff ff       	jmp    f0104e42 <print_trapframe+0xa4>
		cprintf("\n");
f0104f17:	83 ec 0c             	sub    $0xc,%esp
f0104f1a:	68 fb 98 10 f0       	push   $0xf01098fb
f0104f1f:	e8 dd f6 ff ff       	call   f0104601 <cprintf>
f0104f24:	83 c4 10             	add    $0x10,%esp
f0104f27:	e9 7a ff ff ff       	jmp    f0104ea6 <print_trapframe+0x108>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104f2c:	83 ec 08             	sub    $0x8,%esp
f0104f2f:	ff 73 3c             	pushl  0x3c(%ebx)
f0104f32:	68 fe 9c 10 f0       	push   $0xf0109cfe
f0104f37:	e8 c5 f6 ff ff       	call   f0104601 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104f3c:	83 c4 08             	add    $0x8,%esp
f0104f3f:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104f43:	50                   	push   %eax
f0104f44:	68 0d 9d 10 f0       	push   $0xf0109d0d
f0104f49:	e8 b3 f6 ff ff       	call   f0104601 <cprintf>
f0104f4e:	83 c4 10             	add    $0x10,%esp
}
f0104f51:	eb 8e                	jmp    f0104ee1 <print_trapframe+0x143>

f0104f53 <page_fault_handler>:


//mapped text lab7
void
page_fault_handler(struct Trapframe *tf)
{
f0104f53:	55                   	push   %ebp
f0104f54:	89 e5                	mov    %esp,%ebp
f0104f56:	57                   	push   %edi
f0104f57:	56                   	push   %esi
f0104f58:	53                   	push   %ebx
f0104f59:	83 ec 0c             	sub    $0xc,%esp
f0104f5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104f5f:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f0104f62:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104f66:	83 e0 03             	and    $0x3,%eax
f0104f69:	66 83 f8 03          	cmp    $0x3,%ax
f0104f6d:	75 5d                	jne    f0104fcc <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f0104f6f:	e8 a2 23 00 00       	call   f0107316 <cpunum>
f0104f74:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f77:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104f7d:	83 78 68 00          	cmpl   $0x0,0x68(%eax)
f0104f81:	75 69                	jne    f0104fec <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104f83:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f0104f86:	e8 8b 23 00 00       	call   f0107316 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104f8b:	57                   	push   %edi
f0104f8c:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f0104f8d:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104f90:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0104f96:	ff 70 48             	pushl  0x48(%eax)
f0104f99:	68 e0 9f 10 f0       	push   $0xf0109fe0
f0104f9e:	e8 5e f6 ff ff       	call   f0104601 <cprintf>
	print_trapframe(tf);
f0104fa3:	89 1c 24             	mov    %ebx,(%esp)
f0104fa6:	e8 f3 fd ff ff       	call   f0104d9e <print_trapframe>
	env_destroy(curenv);
f0104fab:	e8 66 23 00 00       	call   f0107316 <cpunum>
f0104fb0:	83 c4 04             	add    $0x4,%esp
f0104fb3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fb6:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0104fbc:	e8 2b f4 ff ff       	call   f01043ec <env_destroy>
}
f0104fc1:	83 c4 10             	add    $0x10,%esp
f0104fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104fc7:	5b                   	pop    %ebx
f0104fc8:	5e                   	pop    %esi
f0104fc9:	5f                   	pop    %edi
f0104fca:	5d                   	pop    %ebp
f0104fcb:	c3                   	ret    
		print_trapframe(tf);//just test
f0104fcc:	83 ec 0c             	sub    $0xc,%esp
f0104fcf:	53                   	push   %ebx
f0104fd0:	e8 c9 fd ff ff       	call   f0104d9e <print_trapframe>
		panic("panic at kernel page_fault\n");
f0104fd5:	83 c4 0c             	add    $0xc,%esp
f0104fd8:	68 20 9d 10 f0       	push   $0xf0109d20
f0104fdd:	68 d2 01 00 00       	push   $0x1d2
f0104fe2:	68 3c 9d 10 f0       	push   $0xf0109d3c
f0104fe7:	e8 5d b0 ff ff       	call   f0100049 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104fec:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0104fef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f0104ff4:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
f0104ff6:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104ffb:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0105000:	77 05                	ja     f0105007 <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f0105002:	8d 42 c8             	lea    -0x38(%edx),%eax
f0105005:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f0105007:	e8 0a 23 00 00       	call   f0107316 <cpunum>
f010500c:	6a 02                	push   $0x2
f010500e:	6a 34                	push   $0x34
f0105010:	57                   	push   %edi
f0105011:	6b c0 74             	imul   $0x74,%eax,%eax
f0105014:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010501a:	e8 a1 e4 ff ff       	call   f01034c0 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f010501f:	89 fa                	mov    %edi,%edx
f0105021:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f0105023:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0105026:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0105029:	8d 7f 08             	lea    0x8(%edi),%edi
f010502c:	b9 08 00 00 00       	mov    $0x8,%ecx
f0105031:	89 de                	mov    %ebx,%esi
f0105033:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0105035:	8b 43 30             	mov    0x30(%ebx),%eax
f0105038:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f010503b:	8b 43 38             	mov    0x38(%ebx),%eax
f010503e:	89 d7                	mov    %edx,%edi
f0105040:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f0105043:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0105046:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0105049:	e8 c8 22 00 00       	call   f0107316 <cpunum>
f010504e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105051:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105057:	8b 58 68             	mov    0x68(%eax),%ebx
f010505a:	e8 b7 22 00 00       	call   f0107316 <cpunum>
f010505f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105062:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105068:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f010506b:	e8 a6 22 00 00       	call   f0107316 <cpunum>
f0105070:	6b c0 74             	imul   $0x74,%eax,%eax
f0105073:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105079:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f010507c:	e8 95 22 00 00       	call   f0107316 <cpunum>
f0105081:	83 c4 04             	add    $0x4,%esp
f0105084:	6b c0 74             	imul   $0x74,%eax,%eax
f0105087:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010508d:	e8 92 bf 01 00       	call   f0121024 <env_run>

f0105092 <trap>:
{
f0105092:	55                   	push   %ebp
f0105093:	89 e5                	mov    %esp,%ebp
f0105095:	57                   	push   %edi
f0105096:	56                   	push   %esi
f0105097:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f010509a:	fc                   	cld    
	if (panicstr){
f010509b:	83 3d 40 cd 5d f0 00 	cmpl   $0x0,0xf05dcd40
f01050a2:	74 01                	je     f01050a5 <trap+0x13>
		asm volatile("hlt");
f01050a4:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01050a5:	e8 6c 22 00 00       	call   f0107316 <cpunum>
f01050aa:	6b d0 74             	imul   $0x74,%eax,%edx
f01050ad:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01050b0:	b8 01 00 00 00       	mov    $0x1,%eax
f01050b5:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
f01050bc:	83 f8 02             	cmp    $0x2,%eax
f01050bf:	74 30                	je     f01050f1 <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01050c1:	9c                   	pushf  
f01050c2:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f01050c3:	f6 c4 02             	test   $0x2,%ah
f01050c6:	75 3b                	jne    f0105103 <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f01050c8:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01050cc:	83 e0 03             	and    $0x3,%eax
f01050cf:	66 83 f8 03          	cmp    $0x3,%ax
f01050d3:	74 47                	je     f010511c <trap+0x8a>
	last_tf = tf;
f01050d5:	89 35 0c b9 5d f0    	mov    %esi,0xf05db90c
	switch (tf->tf_trapno)
f01050db:	8b 46 28             	mov    0x28(%esi),%eax
f01050de:	83 e8 03             	sub    $0x3,%eax
f01050e1:	83 f8 30             	cmp    $0x30,%eax
f01050e4:	0f 87 92 02 00 00    	ja     f010537c <trap+0x2ea>
f01050ea:	ff 24 85 20 a0 10 f0 	jmp    *-0xfef5fe0(,%eax,4)
f01050f1:	83 ec 0c             	sub    $0xc,%esp
f01050f4:	68 20 d3 16 f0       	push   $0xf016d320
f01050f9:	e8 88 24 00 00       	call   f0107586 <spin_lock>
f01050fe:	83 c4 10             	add    $0x10,%esp
f0105101:	eb be                	jmp    f01050c1 <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f0105103:	68 48 9d 10 f0       	push   $0xf0109d48
f0105108:	68 0b 96 10 f0       	push   $0xf010960b
f010510d:	68 9c 01 00 00       	push   $0x19c
f0105112:	68 3c 9d 10 f0       	push   $0xf0109d3c
f0105117:	e8 2d af ff ff       	call   f0100049 <_panic>
f010511c:	83 ec 0c             	sub    $0xc,%esp
f010511f:	68 20 d3 16 f0       	push   $0xf016d320
f0105124:	e8 5d 24 00 00       	call   f0107586 <spin_lock>
		assert(curenv);
f0105129:	e8 e8 21 00 00       	call   f0107316 <cpunum>
f010512e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105131:	83 c4 10             	add    $0x10,%esp
f0105134:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f010513b:	74 3e                	je     f010517b <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f010513d:	e8 d4 21 00 00       	call   f0107316 <cpunum>
f0105142:	6b c0 74             	imul   $0x74,%eax,%eax
f0105145:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010514b:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010514f:	74 43                	je     f0105194 <trap+0x102>
		curenv->env_tf = *tf;
f0105151:	e8 c0 21 00 00       	call   f0107316 <cpunum>
f0105156:	6b c0 74             	imul   $0x74,%eax,%eax
f0105159:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010515f:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105164:	89 c7                	mov    %eax,%edi
f0105166:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0105168:	e8 a9 21 00 00       	call   f0107316 <cpunum>
f010516d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105170:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0105176:	e9 5a ff ff ff       	jmp    f01050d5 <trap+0x43>
		assert(curenv);
f010517b:	68 61 9d 10 f0       	push   $0xf0109d61
f0105180:	68 0b 96 10 f0       	push   $0xf010960b
f0105185:	68 a3 01 00 00       	push   $0x1a3
f010518a:	68 3c 9d 10 f0       	push   $0xf0109d3c
f010518f:	e8 b5 ae ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f0105194:	e8 7d 21 00 00       	call   f0107316 <cpunum>
f0105199:	83 ec 0c             	sub    $0xc,%esp
f010519c:	6b c0 74             	imul   $0x74,%eax,%eax
f010519f:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01051a5:	e8 f3 eb ff ff       	call   f0103d9d <env_free>
			curenv = NULL;
f01051aa:	e8 67 21 00 00       	call   f0107316 <cpunum>
f01051af:	6b c0 74             	imul   $0x74,%eax,%eax
f01051b2:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f01051b9:	00 00 00 
			sched_yield();
f01051bc:	e8 f8 02 00 00       	call   f01054b9 <sched_yield>
			page_fault_handler(tf);
f01051c1:	83 ec 0c             	sub    $0xc,%esp
f01051c4:	56                   	push   %esi
f01051c5:	e8 89 fd ff ff       	call   f0104f53 <page_fault_handler>
f01051ca:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f01051cd:	e8 44 21 00 00       	call   f0107316 <cpunum>
f01051d2:	6b c0 74             	imul   $0x74,%eax,%eax
f01051d5:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f01051dc:	74 18                	je     f01051f6 <trap+0x164>
f01051de:	e8 33 21 00 00       	call   f0107316 <cpunum>
f01051e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01051e6:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01051ec:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01051f0:	0f 84 ce 01 00 00    	je     f01053c4 <trap+0x332>
		sched_yield();
f01051f6:	e8 be 02 00 00       	call   f01054b9 <sched_yield>
			monitor(tf);
f01051fb:	83 ec 0c             	sub    $0xc,%esp
f01051fe:	56                   	push   %esi
f01051ff:	e8 78 ba ff ff       	call   f0100c7c <monitor>
f0105204:	83 c4 10             	add    $0x10,%esp
f0105207:	eb c4                	jmp    f01051cd <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0105209:	83 ec 08             	sub    $0x8,%esp
f010520c:	ff 76 04             	pushl  0x4(%esi)
f010520f:	ff 36                	pushl  (%esi)
f0105211:	ff 76 10             	pushl  0x10(%esi)
f0105214:	ff 76 18             	pushl  0x18(%esi)
f0105217:	ff 76 14             	pushl  0x14(%esi)
f010521a:	ff 76 1c             	pushl  0x1c(%esi)
f010521d:	e8 eb 03 00 00       	call   f010560d <syscall>
f0105222:	89 46 1c             	mov    %eax,0x1c(%esi)
f0105225:	83 c4 20             	add    $0x20,%esp
f0105228:	eb a3                	jmp    f01051cd <trap+0x13b>
			time_tick();
f010522a:	e8 1d 2f 00 00       	call   f010814c <time_tick>
			lapic_eoi();
f010522f:	e8 29 22 00 00       	call   f010745d <lapic_eoi>
			sched_yield();
f0105234:	e8 80 02 00 00       	call   f01054b9 <sched_yield>
			kbd_intr();
f0105239:	e8 05 b4 ff ff       	call   f0100643 <kbd_intr>
f010523e:	eb 8d                	jmp    f01051cd <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0105240:	83 ec 0c             	sub    $0xc,%esp
f0105243:	68 03 9e 10 f0       	push   $0xf0109e03
f0105248:	e8 b4 f3 ff ff       	call   f0104601 <cprintf>
f010524d:	83 c4 10             	add    $0x10,%esp
f0105250:	e9 78 ff ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0105255:	83 ec 0c             	sub    $0xc,%esp
f0105258:	68 1a 9e 10 f0       	push   $0xf0109e1a
f010525d:	e8 9f f3 ff ff       	call   f0104601 <cprintf>
f0105262:	83 c4 10             	add    $0x10,%esp
f0105265:	e9 63 ff ff ff       	jmp    f01051cd <trap+0x13b>
			serial_intr();
f010526a:	e8 b8 b3 ff ff       	call   f0100627 <serial_intr>
f010526f:	e9 59 ff ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0105274:	83 ec 0c             	sub    $0xc,%esp
f0105277:	68 4d 9e 10 f0       	push   $0xf0109e4d
f010527c:	e8 80 f3 ff ff       	call   f0104601 <cprintf>
f0105281:	83 c4 10             	add    $0x10,%esp
f0105284:	e9 44 ff ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0105289:	83 ec 0c             	sub    $0xc,%esp
f010528c:	68 68 9d 10 f0       	push   $0xf0109d68
f0105291:	e8 6b f3 ff ff       	call   f0104601 <cprintf>
f0105296:	83 c4 10             	add    $0x10,%esp
f0105299:	e9 2f ff ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("in Spurious\n");
f010529e:	83 ec 0c             	sub    $0xc,%esp
f01052a1:	68 7e 9d 10 f0       	push   $0xf0109d7e
f01052a6:	e8 56 f3 ff ff       	call   f0104601 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f01052ab:	c7 04 24 8b 9d 10 f0 	movl   $0xf0109d8b,(%esp)
f01052b2:	e8 4a f3 ff ff       	call   f0104601 <cprintf>
f01052b7:	83 c4 10             	add    $0x10,%esp
f01052ba:	e9 0e ff ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f01052bf:	83 ec 0c             	sub    $0xc,%esp
f01052c2:	68 a8 9d 10 f0       	push   $0xf0109da8
f01052c7:	e8 35 f3 ff ff       	call   f0104601 <cprintf>
f01052cc:	83 c4 10             	add    $0x10,%esp
f01052cf:	e9 f9 fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f01052d4:	83 ec 0c             	sub    $0xc,%esp
f01052d7:	68 be 9d 10 f0       	push   $0xf0109dbe
f01052dc:	e8 20 f3 ff ff       	call   f0104601 <cprintf>
f01052e1:	83 c4 10             	add    $0x10,%esp
f01052e4:	e9 e4 fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f01052e9:	83 ec 0c             	sub    $0xc,%esp
f01052ec:	68 d4 9d 10 f0       	push   $0xf0109dd4
f01052f1:	e8 0b f3 ff ff       	call   f0104601 <cprintf>
f01052f6:	83 c4 10             	add    $0x10,%esp
f01052f9:	e9 cf fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f01052fe:	83 ec 0c             	sub    $0xc,%esp
f0105301:	68 eb 9d 10 f0       	push   $0xf0109deb
f0105306:	e8 f6 f2 ff ff       	call   f0104601 <cprintf>
f010530b:	83 c4 10             	add    $0x10,%esp
f010530e:	e9 ba fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0105313:	83 ec 0c             	sub    $0xc,%esp
f0105316:	68 02 9e 10 f0       	push   $0xf0109e02
f010531b:	e8 e1 f2 ff ff       	call   f0104601 <cprintf>
f0105320:	83 c4 10             	add    $0x10,%esp
f0105323:	e9 a5 fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0105328:	83 ec 0c             	sub    $0xc,%esp
f010532b:	68 19 9e 10 f0       	push   $0xf0109e19
f0105330:	e8 cc f2 ff ff       	call   f0104601 <cprintf>
f0105335:	83 c4 10             	add    $0x10,%esp
f0105338:	e9 90 fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f010533d:	83 ec 0c             	sub    $0xc,%esp
f0105340:	68 30 9e 10 f0       	push   $0xf0109e30
f0105345:	e8 b7 f2 ff ff       	call   f0104601 <cprintf>
f010534a:	83 c4 10             	add    $0x10,%esp
f010534d:	e9 7b fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0105352:	83 ec 0c             	sub    $0xc,%esp
f0105355:	68 4c 9e 10 f0       	push   $0xf0109e4c
f010535a:	e8 a2 f2 ff ff       	call   f0104601 <cprintf>
f010535f:	83 c4 10             	add    $0x10,%esp
f0105362:	e9 66 fe ff ff       	jmp    f01051cd <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0105367:	83 ec 0c             	sub    $0xc,%esp
f010536a:	68 63 9e 10 f0       	push   $0xf0109e63
f010536f:	e8 8d f2 ff ff       	call   f0104601 <cprintf>
f0105374:	83 c4 10             	add    $0x10,%esp
f0105377:	e9 51 fe ff ff       	jmp    f01051cd <trap+0x13b>
			print_trapframe(tf);
f010537c:	83 ec 0c             	sub    $0xc,%esp
f010537f:	56                   	push   %esi
f0105380:	e8 19 fa ff ff       	call   f0104d9e <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0105385:	83 c4 10             	add    $0x10,%esp
f0105388:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f010538d:	74 1e                	je     f01053ad <trap+0x31b>
				env_destroy(curenv);
f010538f:	e8 82 1f 00 00       	call   f0107316 <cpunum>
f0105394:	83 ec 0c             	sub    $0xc,%esp
f0105397:	6b c0 74             	imul   $0x74,%eax,%eax
f010539a:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01053a0:	e8 47 f0 ff ff       	call   f01043ec <env_destroy>
f01053a5:	83 c4 10             	add    $0x10,%esp
f01053a8:	e9 20 fe ff ff       	jmp    f01051cd <trap+0x13b>
				panic("unhandled trap in kernel");
f01053ad:	83 ec 04             	sub    $0x4,%esp
f01053b0:	68 81 9e 10 f0       	push   $0xf0109e81
f01053b5:	68 7b 01 00 00       	push   $0x17b
f01053ba:	68 3c 9d 10 f0       	push   $0xf0109d3c
f01053bf:	e8 85 ac ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f01053c4:	e8 4d 1f 00 00       	call   f0107316 <cpunum>
f01053c9:	83 ec 0c             	sub    $0xc,%esp
f01053cc:	6b c0 74             	imul   $0x74,%eax,%eax
f01053cf:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01053d5:	e8 4a bc 01 00       	call   f0121024 <env_run>

f01053da <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01053da:	55                   	push   %ebp
f01053db:	89 e5                	mov    %esp,%ebp
f01053dd:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f01053e0:	68 ac a1 10 f0       	push   $0xf010a1ac
f01053e5:	68 77 9b 10 f0       	push   $0xf0109b77
f01053ea:	e8 12 f2 ff ff       	call   f0104601 <cprintf>
f01053ef:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
f01053f4:	8d 50 54             	lea    0x54(%eax),%edx
f01053f7:	83 c4 10             	add    $0x10,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01053fa:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01053ff:	8b 02                	mov    (%edx),%eax
f0105401:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0105404:	83 f8 02             	cmp    $0x2,%eax
f0105407:	76 30                	jbe    f0105439 <sched_halt+0x5f>
	for (i = 0; i < NENV; i++) {
f0105409:	83 c1 01             	add    $0x1,%ecx
f010540c:	81 c2 84 00 00 00    	add    $0x84,%edx
f0105412:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0105418:	75 e5                	jne    f01053ff <sched_halt+0x25>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f010541a:	83 ec 0c             	sub    $0xc,%esp
f010541d:	68 80 a1 10 f0       	push   $0xf010a180
f0105422:	e8 da f1 ff ff       	call   f0104601 <cprintf>
f0105427:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f010542a:	83 ec 0c             	sub    $0xc,%esp
f010542d:	6a 00                	push   $0x0
f010542f:	e8 48 b8 ff ff       	call   f0100c7c <monitor>
f0105434:	83 c4 10             	add    $0x10,%esp
f0105437:	eb f1                	jmp    f010542a <sched_halt+0x50>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0105439:	e8 d8 1e 00 00       	call   f0107316 <cpunum>
f010543e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105441:	c7 80 28 b0 16 f0 00 	movl   $0x0,-0xfe94fd8(%eax)
f0105448:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f010544b:	a1 4c cd 5d f0       	mov    0xf05dcd4c,%eax
	if ((uint32_t)kva < KERNBASE)
f0105450:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0105455:	76 50                	jbe    f01054a7 <sched_halt+0xcd>
	return (physaddr_t)kva - KERNBASE;
f0105457:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010545c:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f010545f:	e8 b2 1e 00 00       	call   f0107316 <cpunum>
f0105464:	6b d0 74             	imul   $0x74,%eax,%edx
f0105467:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010546a:	b8 02 00 00 00       	mov    $0x2,%eax
f010546f:	f0 87 82 20 b0 16 f0 	lock xchg %eax,-0xfe94fe0(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0105476:	83 ec 0c             	sub    $0xc,%esp
f0105479:	68 20 d3 16 f0       	push   $0xf016d320
f010547e:	e8 9f 21 00 00       	call   f0107622 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0105483:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0105485:	e8 8c 1e 00 00       	call   f0107316 <cpunum>
f010548a:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f010548d:	8b 80 30 b0 16 f0    	mov    -0xfe94fd0(%eax),%eax
f0105493:	bd 00 00 00 00       	mov    $0x0,%ebp
f0105498:	89 c4                	mov    %eax,%esp
f010549a:	6a 00                	push   $0x0
f010549c:	6a 00                	push   $0x0
f010549e:	fb                   	sti    
f010549f:	f4                   	hlt    
f01054a0:	eb fd                	jmp    f010549f <sched_halt+0xc5>
}
f01054a2:	83 c4 10             	add    $0x10,%esp
f01054a5:	c9                   	leave  
f01054a6:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01054a7:	50                   	push   %eax
f01054a8:	68 58 84 10 f0       	push   $0xf0108458
f01054ad:	6a 4d                	push   $0x4d
f01054af:	68 71 a1 10 f0       	push   $0xf010a171
f01054b4:	e8 90 ab ff ff       	call   f0100049 <_panic>

f01054b9 <sched_yield>:
{
f01054b9:	55                   	push   %ebp
f01054ba:	89 e5                	mov    %esp,%ebp
f01054bc:	53                   	push   %ebx
f01054bd:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f01054c0:	e8 51 1e 00 00       	call   f0107316 <cpunum>
f01054c5:	6b c0 74             	imul   $0x74,%eax,%eax
f01054c8:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f01054cf:	74 7e                	je     f010554f <sched_yield+0x96>
		envid_t cur_tone = ENVX(curenv->env_id);
f01054d1:	e8 40 1e 00 00       	call   f0107316 <cpunum>
f01054d6:	6b c0 74             	imul   $0x74,%eax,%eax
f01054d9:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01054df:	8b 48 48             	mov    0x48(%eax),%ecx
f01054e2:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f01054e8:	8d 41 01             	lea    0x1(%ecx),%eax
f01054eb:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f01054f0:	8b 1d 68 a0 12 f0    	mov    0xf012a068,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f01054f6:	39 c8                	cmp    %ecx,%eax
f01054f8:	74 21                	je     f010551b <sched_yield+0x62>
			if(envs[i].env_status == ENV_RUNNABLE){
f01054fa:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
f0105500:	01 da                	add    %ebx,%edx
f0105502:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0105506:	74 0a                	je     f0105512 <sched_yield+0x59>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0105508:	83 c0 01             	add    $0x1,%eax
f010550b:	25 ff 03 00 00       	and    $0x3ff,%eax
f0105510:	eb e4                	jmp    f01054f6 <sched_yield+0x3d>
				env_run(&envs[i]);
f0105512:	83 ec 0c             	sub    $0xc,%esp
f0105515:	52                   	push   %edx
f0105516:	e8 09 bb 01 00       	call   f0121024 <env_run>
		if(curenv->env_status == ENV_RUNNING)
f010551b:	e8 f6 1d 00 00       	call   f0107316 <cpunum>
f0105520:	6b c0 74             	imul   $0x74,%eax,%eax
f0105523:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105529:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010552d:	74 0a                	je     f0105539 <sched_yield+0x80>
	sched_halt();
f010552f:	e8 a6 fe ff ff       	call   f01053da <sched_halt>
}
f0105534:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105537:	c9                   	leave  
f0105538:	c3                   	ret    
			env_run(curenv);
f0105539:	e8 d8 1d 00 00       	call   f0107316 <cpunum>
f010553e:	83 ec 0c             	sub    $0xc,%esp
f0105541:	6b c0 74             	imul   $0x74,%eax,%eax
f0105544:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010554a:	e8 d5 ba 01 00       	call   f0121024 <env_run>
f010554f:	a1 68 a0 12 f0       	mov    0xf012a068,%eax
f0105554:	8d 90 00 10 02 00    	lea    0x21000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f010555a:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f010555e:	74 0b                	je     f010556b <sched_yield+0xb2>
f0105560:	05 84 00 00 00       	add    $0x84,%eax
		for(i = 0 ; i < NENV; i++)
f0105565:	39 d0                	cmp    %edx,%eax
f0105567:	75 f1                	jne    f010555a <sched_yield+0xa1>
f0105569:	eb c4                	jmp    f010552f <sched_yield+0x76>
		  		env_run(&envs[i]);
f010556b:	83 ec 0c             	sub    $0xc,%esp
f010556e:	50                   	push   %eax
f010556f:	e8 b0 ba 01 00       	call   f0121024 <env_run>

f0105574 <sys_net_send>:
	return time_msec();
}

int
sys_net_send(const void *buf, uint32_t len)
{
f0105574:	55                   	push   %ebp
f0105575:	89 e5                	mov    %esp,%ebp
f0105577:	57                   	push   %edi
f0105578:	56                   	push   %esi
f0105579:	53                   	push   %ebx
f010557a:	83 ec 0c             	sub    $0xc,%esp
f010557d:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105580:	8b 75 0c             	mov    0xc(%ebp),%esi
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_tx to send the packet
	// Hint: e1000_tx only accept kernel virtual address
	int r;
	if((r = user_mem_check(curenv, buf, len, PTE_W|PTE_U)) < 0){
f0105583:	e8 8e 1d 00 00       	call   f0107316 <cpunum>
f0105588:	6a 06                	push   $0x6
f010558a:	56                   	push   %esi
f010558b:	53                   	push   %ebx
f010558c:	6b c0 74             	imul   $0x74,%eax,%eax
f010558f:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0105595:	e8 69 de ff ff       	call   f0103403 <user_mem_check>
f010559a:	83 c4 10             	add    $0x10,%esp
f010559d:	85 c0                	test   %eax,%eax
f010559f:	78 19                	js     f01055ba <sys_net_send+0x46>
		cprintf("address:%x\n", (uint32_t)buf);
		return r;
	}
	return e1000_tx(buf, len);
f01055a1:	83 ec 08             	sub    $0x8,%esp
f01055a4:	56                   	push   %esi
f01055a5:	53                   	push   %ebx
f01055a6:	e8 ca 24 00 00       	call   f0107a75 <e1000_tx>
f01055ab:	89 c7                	mov    %eax,%edi
f01055ad:	83 c4 10             	add    $0x10,%esp

}
f01055b0:	89 f8                	mov    %edi,%eax
f01055b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01055b5:	5b                   	pop    %ebx
f01055b6:	5e                   	pop    %esi
f01055b7:	5f                   	pop    %edi
f01055b8:	5d                   	pop    %ebp
f01055b9:	c3                   	ret    
f01055ba:	89 c7                	mov    %eax,%edi
		cprintf("address:%x\n", (uint32_t)buf);
f01055bc:	83 ec 08             	sub    $0x8,%esp
f01055bf:	53                   	push   %ebx
f01055c0:	68 b7 a1 10 f0       	push   $0xf010a1b7
f01055c5:	e8 37 f0 ff ff       	call   f0104601 <cprintf>
		return r;
f01055ca:	83 c4 10             	add    $0x10,%esp
f01055cd:	eb e1                	jmp    f01055b0 <sys_net_send+0x3c>

f01055cf <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
f01055cf:	55                   	push   %ebp
f01055d0:	89 e5                	mov    %esp,%ebp
f01055d2:	53                   	push   %ebx
f01055d3:	83 ec 04             	sub    $0x4,%esp
f01055d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	user_mem_assert(curenv, ROUNDDOWN(buf, PGSIZE), PGSIZE, PTE_U | PTE_W);   // check permission
f01055d9:	e8 38 1d 00 00       	call   f0107316 <cpunum>
f01055de:	6a 06                	push   $0x6
f01055e0:	68 00 10 00 00       	push   $0x1000
f01055e5:	89 da                	mov    %ebx,%edx
f01055e7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01055ed:	52                   	push   %edx
f01055ee:	6b c0 74             	imul   $0x74,%eax,%eax
f01055f1:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f01055f7:	e8 c4 de ff ff       	call   f01034c0 <user_mem_assert>
  	return e1000_rx(buf,len);
f01055fc:	83 c4 08             	add    $0x8,%esp
f01055ff:	ff 75 0c             	pushl  0xc(%ebp)
f0105602:	53                   	push   %ebx
f0105603:	e8 80 25 00 00       	call   f0107b88 <e1000_rx>
}
f0105608:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010560b:	c9                   	leave  
f010560c:	c3                   	ret    

f010560d <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f010560d:	55                   	push   %ebp
f010560e:	89 e5                	mov    %esp,%ebp
f0105610:	57                   	push   %edi
f0105611:	56                   	push   %esi
f0105612:	53                   	push   %ebx
f0105613:	83 ec 2c             	sub    $0x2c,%esp
f0105616:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f0105619:	83 f8 15             	cmp    $0x15,%eax
f010561c:	0f 87 82 09 00 00    	ja     f0105fa4 <syscall+0x997>
f0105622:	ff 24 85 a0 a2 10 f0 	jmp    *-0xfef5d60(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f0105629:	e8 e8 1c 00 00       	call   f0107316 <cpunum>
f010562e:	6a 04                	push   $0x4
f0105630:	ff 75 10             	pushl  0x10(%ebp)
f0105633:	ff 75 0c             	pushl  0xc(%ebp)
f0105636:	6b c0 74             	imul   $0x74,%eax,%eax
f0105639:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010563f:	e8 7c de ff ff       	call   f01034c0 <user_mem_assert>
	cprintf("%.*s", len, s);
f0105644:	83 c4 0c             	add    $0xc,%esp
f0105647:	ff 75 0c             	pushl  0xc(%ebp)
f010564a:	ff 75 10             	pushl  0x10(%ebp)
f010564d:	68 c3 a1 10 f0       	push   $0xf010a1c3
f0105652:	e8 aa ef ff ff       	call   f0104601 <cprintf>
f0105657:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f010565a:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f010565f:	89 d8                	mov    %ebx,%eax
f0105661:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105664:	5b                   	pop    %ebx
f0105665:	5e                   	pop    %esi
f0105666:	5f                   	pop    %edi
f0105667:	5d                   	pop    %ebp
f0105668:	c3                   	ret    
	return cons_getc();
f0105669:	e8 e7 af ff ff       	call   f0100655 <cons_getc>
f010566e:	89 c3                	mov    %eax,%ebx
			break;
f0105670:	eb ed                	jmp    f010565f <syscall+0x52>
	return curenv->env_id;
f0105672:	e8 9f 1c 00 00       	call   f0107316 <cpunum>
f0105677:	6b c0 74             	imul   $0x74,%eax,%eax
f010567a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105680:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0105683:	eb da                	jmp    f010565f <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0105685:	83 ec 04             	sub    $0x4,%esp
f0105688:	6a 01                	push   $0x1
f010568a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010568d:	50                   	push   %eax
f010568e:	ff 75 0c             	pushl  0xc(%ebp)
f0105691:	e8 89 df ff ff       	call   f010361f <envid2env>
f0105696:	89 c3                	mov    %eax,%ebx
f0105698:	83 c4 10             	add    $0x10,%esp
f010569b:	85 c0                	test   %eax,%eax
f010569d:	78 c0                	js     f010565f <syscall+0x52>
	if (e == curenv)
f010569f:	e8 72 1c 00 00       	call   f0107316 <cpunum>
f01056a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01056a7:	6b c0 74             	imul   $0x74,%eax,%eax
f01056aa:	39 90 28 b0 16 f0    	cmp    %edx,-0xfe94fd8(%eax)
f01056b0:	74 3d                	je     f01056ef <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01056b2:	8b 5a 48             	mov    0x48(%edx),%ebx
f01056b5:	e8 5c 1c 00 00       	call   f0107316 <cpunum>
f01056ba:	83 ec 04             	sub    $0x4,%esp
f01056bd:	53                   	push   %ebx
f01056be:	6b c0 74             	imul   $0x74,%eax,%eax
f01056c1:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01056c7:	ff 70 48             	pushl  0x48(%eax)
f01056ca:	68 e3 a1 10 f0       	push   $0xf010a1e3
f01056cf:	e8 2d ef ff ff       	call   f0104601 <cprintf>
f01056d4:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f01056d7:	83 ec 0c             	sub    $0xc,%esp
f01056da:	ff 75 e4             	pushl  -0x1c(%ebp)
f01056dd:	e8 0a ed ff ff       	call   f01043ec <env_destroy>
f01056e2:	83 c4 10             	add    $0x10,%esp
	return 0;
f01056e5:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01056ea:	e9 70 ff ff ff       	jmp    f010565f <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01056ef:	e8 22 1c 00 00       	call   f0107316 <cpunum>
f01056f4:	83 ec 08             	sub    $0x8,%esp
f01056f7:	6b c0 74             	imul   $0x74,%eax,%eax
f01056fa:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105700:	ff 70 48             	pushl  0x48(%eax)
f0105703:	68 c8 a1 10 f0       	push   $0xf010a1c8
f0105708:	e8 f4 ee ff ff       	call   f0104601 <cprintf>
f010570d:	83 c4 10             	add    $0x10,%esp
f0105710:	eb c5                	jmp    f01056d7 <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f0105712:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f0105719:	0f 86 86 00 00 00    	jbe    f01057a5 <syscall+0x198>
	return (physaddr_t)kva - KERNBASE;
f010571f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105722:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0105727:	c1 e8 0c             	shr    $0xc,%eax
f010572a:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f0105730:	0f 83 86 00 00 00    	jae    f01057bc <syscall+0x1af>
	return &pages[PGNUM(pa)];
f0105736:	8b 15 50 cd 5d f0    	mov    0xf05dcd50,%edx
f010573c:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f010573f:	85 db                	test   %ebx,%ebx
f0105741:	0f 84 67 08 00 00    	je     f0105fae <syscall+0x9a1>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f0105747:	e8 ca 1b 00 00       	call   f0107316 <cpunum>
f010574c:	6a 06                	push   $0x6
f010574e:	ff 75 10             	pushl  0x10(%ebp)
f0105751:	53                   	push   %ebx
f0105752:	6b c0 74             	imul   $0x74,%eax,%eax
f0105755:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010575b:	ff 70 60             	pushl  0x60(%eax)
f010575e:	e8 c8 be ff ff       	call   f010162b <page_insert>
f0105763:	89 c3                	mov    %eax,%ebx
	if(r>=0)
f0105765:	83 c4 10             	add    $0x10,%esp
f0105768:	85 c0                	test   %eax,%eax
f010576a:	0f 88 ef fe ff ff    	js     f010565f <syscall+0x52>
		curenv->env_kern_pgdir[PDX(va)] = curenv->env_pgdir[PDX(va)];
f0105770:	e8 a1 1b 00 00       	call   f0107316 <cpunum>
f0105775:	8b 75 10             	mov    0x10(%ebp),%esi
f0105778:	c1 ee 16             	shr    $0x16,%esi
f010577b:	6b c0 74             	imul   $0x74,%eax,%eax
f010577e:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105784:	8b 40 60             	mov    0x60(%eax),%eax
f0105787:	8d 3c b0             	lea    (%eax,%esi,4),%edi
f010578a:	e8 87 1b 00 00       	call   f0107316 <cpunum>
f010578f:	8b 17                	mov    (%edi),%edx
f0105791:	6b c0 74             	imul   $0x74,%eax,%eax
f0105794:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010579a:	8b 40 64             	mov    0x64(%eax),%eax
f010579d:	89 14 b0             	mov    %edx,(%eax,%esi,4)
f01057a0:	e9 ba fe ff ff       	jmp    f010565f <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01057a5:	ff 75 0c             	pushl  0xc(%ebp)
f01057a8:	68 58 84 10 f0       	push   $0xf0108458
f01057ad:	68 b2 01 00 00       	push   $0x1b2
f01057b2:	68 fb a1 10 f0       	push   $0xf010a1fb
f01057b7:	e8 8d a8 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f01057bc:	83 ec 04             	sub    $0x4,%esp
f01057bf:	68 30 8d 10 f0       	push   $0xf0108d30
f01057c4:	6a 51                	push   $0x51
f01057c6:	68 f1 95 10 f0       	push   $0xf01095f1
f01057cb:	e8 79 a8 ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f01057d0:	e8 41 1b 00 00       	call   f0107316 <cpunum>
	if(inc < PGSIZE){
f01057d5:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f01057dc:	77 22                	ja     f0105800 <syscall+0x1f3>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f01057de:	6b c0 74             	imul   $0x74,%eax,%eax
f01057e1:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01057e7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
f01057ed:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f01057f2:	03 45 0c             	add    0xc(%ebp),%eax
f01057f5:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f01057fa:	0f 86 b8 00 00 00    	jbe    f01058b8 <syscall+0x2ab>
	uint32_t i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f0105800:	e8 11 1b 00 00       	call   f0107316 <cpunum>
f0105805:	6b c0 74             	imul   $0x74,%eax,%eax
f0105808:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010580e:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f0105814:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f010581a:	e8 f7 1a 00 00       	call   f0107316 <cpunum>
f010581f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105822:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105828:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
f010582e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105831:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f0105838:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010583d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for(; i < end; i+=PGSIZE){
f0105840:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0105843:	0f 86 cd 00 00 00    	jbe    f0105916 <syscall+0x309>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f0105849:	83 ec 0c             	sub    $0xc,%esp
f010584c:	6a 01                	push   $0x1
f010584e:	e8 9c ba ff ff       	call   f01012ef <page_alloc>
f0105853:	89 c6                	mov    %eax,%esi
		if(!page)
f0105855:	83 c4 10             	add    $0x10,%esp
f0105858:	85 c0                	test   %eax,%eax
f010585a:	0f 84 88 00 00 00    	je     f01058e8 <syscall+0x2db>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f0105860:	e8 b1 1a 00 00       	call   f0107316 <cpunum>
f0105865:	6a 06                	push   $0x6
f0105867:	53                   	push   %ebx
f0105868:	56                   	push   %esi
f0105869:	6b c0 74             	imul   $0x74,%eax,%eax
f010586c:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105872:	ff 70 60             	pushl  0x60(%eax)
f0105875:	e8 b1 bd ff ff       	call   f010162b <page_insert>
		if(ret)
f010587a:	83 c4 10             	add    $0x10,%esp
f010587d:	85 c0                	test   %eax,%eax
f010587f:	75 7e                	jne    f01058ff <syscall+0x2f2>
		curenv->env_kern_pgdir[PDX(i)] = curenv->env_pgdir[PDX(i)];
f0105881:	e8 90 1a 00 00       	call   f0107316 <cpunum>
f0105886:	89 de                	mov    %ebx,%esi
f0105888:	c1 ee 16             	shr    $0x16,%esi
f010588b:	6b c0 74             	imul   $0x74,%eax,%eax
f010588e:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105894:	8b 40 60             	mov    0x60(%eax),%eax
f0105897:	8d 3c b0             	lea    (%eax,%esi,4),%edi
f010589a:	e8 77 1a 00 00       	call   f0107316 <cpunum>
f010589f:	8b 17                	mov    (%edi),%edx
f01058a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01058a4:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01058aa:	8b 40 64             	mov    0x64(%eax),%eax
f01058ad:	89 14 b0             	mov    %edx,(%eax,%esi,4)
	for(; i < end; i+=PGSIZE){
f01058b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01058b6:	eb 88                	jmp    f0105840 <syscall+0x233>
			curenv->env_sbrk+=inc;
f01058b8:	e8 59 1a 00 00       	call   f0107316 <cpunum>
f01058bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01058c0:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01058c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01058c9:	01 88 80 00 00 00    	add    %ecx,0x80(%eax)
			return curenv->env_sbrk;
f01058cf:	e8 42 1a 00 00       	call   f0107316 <cpunum>
f01058d4:	6b c0 74             	imul   $0x74,%eax,%eax
f01058d7:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01058dd:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f01058e3:	e9 77 fd ff ff       	jmp    f010565f <syscall+0x52>
			panic("there is no page\n");
f01058e8:	83 ec 04             	sub    $0x4,%esp
f01058eb:	68 cb 99 10 f0       	push   $0xf01099cb
f01058f0:	68 c9 01 00 00       	push   $0x1c9
f01058f5:	68 fb a1 10 f0       	push   $0xf010a1fb
f01058fa:	e8 4a a7 ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f01058ff:	83 ec 04             	sub    $0x4,%esp
f0105902:	68 dd 99 10 f0       	push   $0xf01099dd
f0105907:	68 cc 01 00 00       	push   $0x1cc
f010590c:	68 fb a1 10 f0       	push   $0xf010a1fb
f0105911:	e8 33 a7 ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f0105916:	e8 fb 19 00 00       	call   f0107316 <cpunum>
f010591b:	6b c0 74             	imul   $0x74,%eax,%eax
f010591e:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105924:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105927:	01 88 80 00 00 00    	add    %ecx,0x80(%eax)
	return curenv->env_sbrk;
f010592d:	e8 e4 19 00 00       	call   f0107316 <cpunum>
f0105932:	6b c0 74             	imul   $0x74,%eax,%eax
f0105935:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f010593b:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
f0105941:	e9 19 fd ff ff       	jmp    f010565f <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f0105946:	83 ec 04             	sub    $0x4,%esp
f0105949:	68 0c a2 10 f0       	push   $0xf010a20c
f010594e:	68 2d 02 00 00       	push   $0x22d
f0105953:	68 fb a1 10 f0       	push   $0xf010a1fb
f0105958:	e8 ec a6 ff ff       	call   f0100049 <_panic>
	sched_yield();
f010595d:	e8 57 fb ff ff       	call   f01054b9 <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105962:	e8 af 19 00 00       	call   f0107316 <cpunum>
f0105967:	83 ec 08             	sub    $0x8,%esp
f010596a:	6b c0 74             	imul   $0x74,%eax,%eax
f010596d:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105973:	ff 70 48             	pushl  0x48(%eax)
f0105976:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105979:	50                   	push   %eax
f010597a:	e8 a5 dd ff ff       	call   f0103724 <env_alloc>
f010597f:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105981:	83 c4 10             	add    $0x10,%esp
f0105984:	85 c0                	test   %eax,%eax
f0105986:	0f 88 d3 fc ff ff    	js     f010565f <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f010598c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010598f:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f0105996:	e8 7b 19 00 00       	call   f0107316 <cpunum>
f010599b:	6b c0 74             	imul   $0x74,%eax,%eax
f010599e:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f01059a4:	b9 11 00 00 00       	mov    $0x11,%ecx
f01059a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01059ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01059ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01059b1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01059b8:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01059bb:	e9 9f fc ff ff       	jmp    f010565f <syscall+0x52>
	switch (status)
f01059c0:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01059c4:	74 06                	je     f01059cc <syscall+0x3bf>
f01059c6:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f01059ca:	75 54                	jne    f0105a20 <syscall+0x413>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01059cc:	8b 45 10             	mov    0x10(%ebp),%eax
f01059cf:	83 e8 02             	sub    $0x2,%eax
f01059d2:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01059d7:	75 31                	jne    f0105a0a <syscall+0x3fd>
	int ret = envid2env(envid, &e, 1);
f01059d9:	83 ec 04             	sub    $0x4,%esp
f01059dc:	6a 01                	push   $0x1
f01059de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01059e1:	50                   	push   %eax
f01059e2:	ff 75 0c             	pushl  0xc(%ebp)
f01059e5:	e8 35 dc ff ff       	call   f010361f <envid2env>
f01059ea:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01059ec:	83 c4 10             	add    $0x10,%esp
f01059ef:	85 c0                	test   %eax,%eax
f01059f1:	0f 88 68 fc ff ff    	js     f010565f <syscall+0x52>
	e->env_status = status;
f01059f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01059fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01059fd:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0105a00:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105a05:	e9 55 fc ff ff       	jmp    f010565f <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f0105a0a:	68 38 a2 10 f0       	push   $0xf010a238
f0105a0f:	68 0b 96 10 f0       	push   $0xf010960b
f0105a14:	6a 7b                	push   $0x7b
f0105a16:	68 fb a1 10 f0       	push   $0xf010a1fb
f0105a1b:	e8 29 a6 ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f0105a20:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105a25:	e9 35 fc ff ff       	jmp    f010565f <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105a2a:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105a31:	0f 87 e5 00 00 00    	ja     f0105b1c <syscall+0x50f>
f0105a37:	8b 45 10             	mov    0x10(%ebp),%eax
f0105a3a:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105a3f:	8b 55 14             	mov    0x14(%ebp),%edx
f0105a42:	83 e2 05             	and    $0x5,%edx
f0105a45:	83 fa 05             	cmp    $0x5,%edx
f0105a48:	0f 85 d8 00 00 00    	jne    f0105b26 <syscall+0x519>
	if(perm & ~PTE_SYSCALL)
f0105a4e:	8b 75 14             	mov    0x14(%ebp),%esi
f0105a51:	81 e6 f8 f1 ff ff    	and    $0xfffff1f8,%esi
f0105a57:	09 c6                	or     %eax,%esi
f0105a59:	0f 85 d1 00 00 00    	jne    f0105b30 <syscall+0x523>
	int ret = envid2env(envid, &e, 1);
f0105a5f:	83 ec 04             	sub    $0x4,%esp
f0105a62:	6a 01                	push   $0x1
f0105a64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a67:	50                   	push   %eax
f0105a68:	ff 75 0c             	pushl  0xc(%ebp)
f0105a6b:	e8 af db ff ff       	call   f010361f <envid2env>
f0105a70:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105a72:	83 c4 10             	add    $0x10,%esp
f0105a75:	85 c0                	test   %eax,%eax
f0105a77:	0f 88 e2 fb ff ff    	js     f010565f <syscall+0x52>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0105a7d:	83 ec 0c             	sub    $0xc,%esp
f0105a80:	6a 01                	push   $0x1
f0105a82:	e8 68 b8 ff ff       	call   f01012ef <page_alloc>
f0105a87:	89 c7                	mov    %eax,%edi
	if(page == NULL)
f0105a89:	83 c4 10             	add    $0x10,%esp
f0105a8c:	85 c0                	test   %eax,%eax
f0105a8e:	0f 84 a6 00 00 00    	je     f0105b3a <syscall+0x52d>
	return (pp - pages) << PGSHIFT;
f0105a94:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0105a9a:	c1 f8 03             	sar    $0x3,%eax
f0105a9d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0105aa0:	89 c2                	mov    %eax,%edx
f0105aa2:	c1 ea 0c             	shr    $0xc,%edx
f0105aa5:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0105aab:	73 4c                	jae    f0105af9 <syscall+0x4ec>
	memset(page2kva(page), 0, PGSIZE);
f0105aad:	83 ec 04             	sub    $0x4,%esp
f0105ab0:	68 00 10 00 00       	push   $0x1000
f0105ab5:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0105ab7:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0105abc:	50                   	push   %eax
f0105abd:	e8 4d 12 00 00       	call   f0106d0f <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f0105ac2:	ff 75 14             	pushl  0x14(%ebp)
f0105ac5:	ff 75 10             	pushl  0x10(%ebp)
f0105ac8:	57                   	push   %edi
f0105ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105acc:	ff 70 60             	pushl  0x60(%eax)
f0105acf:	e8 57 bb ff ff       	call   f010162b <page_insert>
f0105ad4:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105ad6:	83 c4 20             	add    $0x20,%esp
f0105ad9:	85 c0                	test   %eax,%eax
f0105adb:	78 2e                	js     f0105b0b <syscall+0x4fe>
	e->env_kern_pgdir[PDX(va)] = e->env_pgdir[PDX(va)];
f0105add:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105ae0:	8b 45 10             	mov    0x10(%ebp),%eax
f0105ae3:	c1 e8 16             	shr    $0x16,%eax
f0105ae6:	8b 4a 60             	mov    0x60(%edx),%ecx
f0105ae9:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
f0105aec:	8b 52 64             	mov    0x64(%edx),%edx
f0105aef:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
	return 0;
f0105af2:	89 f3                	mov    %esi,%ebx
f0105af4:	e9 66 fb ff ff       	jmp    f010565f <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105af9:	50                   	push   %eax
f0105afa:	68 34 84 10 f0       	push   $0xf0108434
f0105aff:	6a 58                	push   $0x58
f0105b01:	68 f1 95 10 f0       	push   $0xf01095f1
f0105b06:	e8 3e a5 ff ff       	call   f0100049 <_panic>
		page_free(page);
f0105b0b:	83 ec 0c             	sub    $0xc,%esp
f0105b0e:	57                   	push   %edi
f0105b0f:	e8 4d b8 ff ff       	call   f0101361 <page_free>
f0105b14:	83 c4 10             	add    $0x10,%esp
f0105b17:	e9 43 fb ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105b1c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105b21:	e9 39 fb ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105b26:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105b2b:	e9 2f fb ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105b30:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105b35:	e9 25 fb ff ff       	jmp    f010565f <syscall+0x52>
		return -E_NO_MEM;
f0105b3a:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105b3f:	e9 1b fb ff ff       	jmp    f010565f <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105b44:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105b47:	83 e0 05             	and    $0x5,%eax
f0105b4a:	83 f8 05             	cmp    $0x5,%eax
f0105b4d:	0f 85 dd 00 00 00    	jne    f0105c30 <syscall+0x623>
	if(perm & ~PTE_SYSCALL)
f0105b53:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105b56:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f0105b5b:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105b62:	0f 87 d2 00 00 00    	ja     f0105c3a <syscall+0x62d>
f0105b68:	8b 55 10             	mov    0x10(%ebp),%edx
f0105b6b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f0105b71:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105b78:	0f 87 c6 00 00 00    	ja     f0105c44 <syscall+0x637>
f0105b7e:	09 d0                	or     %edx,%eax
f0105b80:	8b 55 18             	mov    0x18(%ebp),%edx
f0105b83:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f0105b89:	09 d0                	or     %edx,%eax
f0105b8b:	0f 85 bd 00 00 00    	jne    f0105c4e <syscall+0x641>
	int ret = envid2env(srcenvid, &src_env, 1);
f0105b91:	83 ec 04             	sub    $0x4,%esp
f0105b94:	6a 01                	push   $0x1
f0105b96:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105b99:	50                   	push   %eax
f0105b9a:	ff 75 0c             	pushl  0xc(%ebp)
f0105b9d:	e8 7d da ff ff       	call   f010361f <envid2env>
f0105ba2:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105ba4:	83 c4 10             	add    $0x10,%esp
f0105ba7:	85 c0                	test   %eax,%eax
f0105ba9:	0f 88 b0 fa ff ff    	js     f010565f <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f0105baf:	83 ec 04             	sub    $0x4,%esp
f0105bb2:	6a 01                	push   $0x1
f0105bb4:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105bb7:	50                   	push   %eax
f0105bb8:	ff 75 14             	pushl  0x14(%ebp)
f0105bbb:	e8 5f da ff ff       	call   f010361f <envid2env>
f0105bc0:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105bc2:	83 c4 10             	add    $0x10,%esp
f0105bc5:	85 c0                	test   %eax,%eax
f0105bc7:	0f 88 92 fa ff ff    	js     f010565f <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f0105bcd:	83 ec 04             	sub    $0x4,%esp
f0105bd0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105bd3:	50                   	push   %eax
f0105bd4:	ff 75 10             	pushl  0x10(%ebp)
f0105bd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105bda:	ff 70 60             	pushl  0x60(%eax)
f0105bdd:	e8 69 b9 ff ff       	call   f010154b <page_lookup>
	if(src_page == NULL)
f0105be2:	83 c4 10             	add    $0x10,%esp
f0105be5:	85 c0                	test   %eax,%eax
f0105be7:	74 6f                	je     f0105c58 <syscall+0x64b>
	if(perm & PTE_W){
f0105be9:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0105bed:	74 08                	je     f0105bf7 <syscall+0x5ea>
		if((*pte_store & PTE_W) == 0)
f0105bef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105bf2:	f6 02 02             	testb  $0x2,(%edx)
f0105bf5:	74 6b                	je     f0105c62 <syscall+0x655>
	int r = page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f0105bf7:	ff 75 1c             	pushl  0x1c(%ebp)
f0105bfa:	ff 75 18             	pushl  0x18(%ebp)
f0105bfd:	50                   	push   %eax
f0105bfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105c01:	ff 70 60             	pushl  0x60(%eax)
f0105c04:	e8 22 ba ff ff       	call   f010162b <page_insert>
f0105c09:	89 c3                	mov    %eax,%ebx
	if(r >= 0)
f0105c0b:	83 c4 10             	add    $0x10,%esp
f0105c0e:	85 c0                	test   %eax,%eax
f0105c10:	0f 88 49 fa ff ff    	js     f010565f <syscall+0x52>
		dst_env->env_kern_pgdir[PDX(dstva)] = dst_env->env_pgdir[PDX(dstva)];
f0105c16:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105c19:	8b 45 18             	mov    0x18(%ebp),%eax
f0105c1c:	c1 e8 16             	shr    $0x16,%eax
f0105c1f:	8b 4a 60             	mov    0x60(%edx),%ecx
f0105c22:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
f0105c25:	8b 52 64             	mov    0x64(%edx),%edx
f0105c28:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
f0105c2b:	e9 2f fa ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105c30:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c35:	e9 25 fa ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105c3a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c3f:	e9 1b fa ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105c44:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c49:	e9 11 fa ff ff       	jmp    f010565f <syscall+0x52>
f0105c4e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c53:	e9 07 fa ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105c58:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c5d:	e9 fd f9 ff ff       	jmp    f010565f <syscall+0x52>
			return -E_INVAL;
f0105c62:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105c67:	e9 f3 f9 ff ff       	jmp    f010565f <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105c6c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105c73:	77 45                	ja     f0105cba <syscall+0x6ad>
f0105c75:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105c7c:	75 46                	jne    f0105cc4 <syscall+0x6b7>
	int ret = envid2env(envid, &env, 1);
f0105c7e:	83 ec 04             	sub    $0x4,%esp
f0105c81:	6a 01                	push   $0x1
f0105c83:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105c86:	50                   	push   %eax
f0105c87:	ff 75 0c             	pushl  0xc(%ebp)
f0105c8a:	e8 90 d9 ff ff       	call   f010361f <envid2env>
f0105c8f:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105c91:	83 c4 10             	add    $0x10,%esp
f0105c94:	85 c0                	test   %eax,%eax
f0105c96:	0f 88 c3 f9 ff ff    	js     f010565f <syscall+0x52>
	page_remove(env->env_pgdir, va);
f0105c9c:	83 ec 08             	sub    $0x8,%esp
f0105c9f:	ff 75 10             	pushl  0x10(%ebp)
f0105ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105ca5:	ff 70 60             	pushl  0x60(%eax)
f0105ca8:	e8 38 b9 ff ff       	call   f01015e5 <page_remove>
f0105cad:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105cb0:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105cb5:	e9 a5 f9 ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105cba:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105cbf:	e9 9b f9 ff ff       	jmp    f010565f <syscall+0x52>
f0105cc4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105cc9:	e9 91 f9 ff ff       	jmp    f010565f <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f0105cce:	83 ec 04             	sub    $0x4,%esp
f0105cd1:	6a 00                	push   $0x0
f0105cd3:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105cd6:	50                   	push   %eax
f0105cd7:	ff 75 0c             	pushl  0xc(%ebp)
f0105cda:	e8 40 d9 ff ff       	call   f010361f <envid2env>
f0105cdf:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105ce1:	83 c4 10             	add    $0x10,%esp
f0105ce4:	85 c0                	test   %eax,%eax
f0105ce6:	0f 88 73 f9 ff ff    	js     f010565f <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f0105cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105cef:	80 78 6c 00          	cmpb   $0x0,0x6c(%eax)
f0105cf3:	0f 84 11 01 00 00    	je     f0105e0a <syscall+0x7fd>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f0105cf9:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0105d00:	77 78                	ja     f0105d7a <syscall+0x76d>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105d02:	8b 45 18             	mov    0x18(%ebp),%eax
f0105d05:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f0105d08:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105d0d:	83 f8 05             	cmp    $0x5,%eax
f0105d10:	0f 85 49 f9 ff ff    	jne    f010565f <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f0105d16:	8b 55 14             	mov    0x14(%ebp),%edx
f0105d19:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f0105d1f:	8b 45 18             	mov    0x18(%ebp),%eax
f0105d22:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f0105d27:	09 c2                	or     %eax,%edx
f0105d29:	0f 85 30 f9 ff ff    	jne    f010565f <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105d2f:	e8 e2 15 00 00       	call   f0107316 <cpunum>
f0105d34:	83 ec 04             	sub    $0x4,%esp
f0105d37:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105d3a:	52                   	push   %edx
f0105d3b:	ff 75 14             	pushl  0x14(%ebp)
f0105d3e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105d41:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105d47:	ff 70 60             	pushl  0x60(%eax)
f0105d4a:	e8 fc b7 ff ff       	call   f010154b <page_lookup>
		if(!page)
f0105d4f:	83 c4 10             	add    $0x10,%esp
f0105d52:	85 c0                	test   %eax,%eax
f0105d54:	0f 84 a6 00 00 00    	je     f0105e00 <syscall+0x7f3>
		if((perm & PTE_W) && !(*pte & PTE_W))
f0105d5a:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105d5e:	74 0c                	je     f0105d6c <syscall+0x75f>
f0105d60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105d63:	f6 02 02             	testb  $0x2,(%edx)
f0105d66:	0f 84 f3 f8 ff ff    	je     f010565f <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105d6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105d6f:	8b 4a 70             	mov    0x70(%edx),%ecx
f0105d72:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0105d78:	76 52                	jbe    f0105dcc <syscall+0x7bf>
	dst_env->env_ipc_recving = 0;
f0105d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d7d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105d81:	e8 90 15 00 00       	call   f0107316 <cpunum>
f0105d86:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105d89:	6b c0 74             	imul   $0x74,%eax,%eax
f0105d8c:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105d92:	8b 40 48             	mov    0x48(%eax),%eax
f0105d95:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_ipc_value = value;
f0105d98:	8b 45 10             	mov    0x10(%ebp),%eax
f0105d9b:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f0105d9e:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f0105da5:	b8 00 00 00 00       	mov    $0x0,%eax
f0105daa:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f0105dae:	89 45 18             	mov    %eax,0x18(%ebp)
f0105db1:	89 42 7c             	mov    %eax,0x7c(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f0105db4:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f0105dbb:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f0105dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105dc7:	e9 93 f8 ff ff       	jmp    f010565f <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f0105dcc:	ff 75 18             	pushl  0x18(%ebp)
f0105dcf:	51                   	push   %ecx
f0105dd0:	50                   	push   %eax
f0105dd1:	ff 72 60             	pushl  0x60(%edx)
f0105dd4:	e8 52 b8 ff ff       	call   f010162b <page_insert>
f0105dd9:	89 c3                	mov    %eax,%ebx
			if(ret < 0)
f0105ddb:	83 c4 10             	add    $0x10,%esp
f0105dde:	85 c0                	test   %eax,%eax
f0105de0:	0f 88 79 f8 ff ff    	js     f010565f <syscall+0x52>
			dst_env->env_kern_pgdir[PDX(dst_env->env_ipc_dstva)] = dst_env->env_pgdir[PDX(dst_env->env_ipc_dstva)];
f0105de6:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105de9:	8b 42 70             	mov    0x70(%edx),%eax
f0105dec:	c1 e8 16             	shr    $0x16,%eax
f0105def:	8b 4a 60             	mov    0x60(%edx),%ecx
f0105df2:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
f0105df5:	8b 52 64             	mov    0x64(%edx),%edx
f0105df8:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
f0105dfb:	e9 7a ff ff ff       	jmp    f0105d7a <syscall+0x76d>
			return -E_INVAL;		
f0105e00:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105e05:	e9 55 f8 ff ff       	jmp    f010565f <syscall+0x52>
		return -E_IPC_NOT_RECV;
f0105e0a:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f0105e0f:	e9 4b f8 ff ff       	jmp    f010565f <syscall+0x52>
	if(dstva < (void *)UTOP){
f0105e14:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105e1b:	77 13                	ja     f0105e30 <syscall+0x823>
		if((uint32_t)dstva % PGSIZE != 0)
f0105e1d:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0105e24:	74 0a                	je     f0105e30 <syscall+0x823>
			ret = sys_ipc_recv((void *)a1);
f0105e26:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f0105e2b:	e9 2f f8 ff ff       	jmp    f010565f <syscall+0x52>
	curenv->env_ipc_recving = 1;
f0105e30:	e8 e1 14 00 00       	call   f0107316 <cpunum>
f0105e35:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e38:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105e3e:	c6 40 6c 01          	movb   $0x1,0x6c(%eax)
	curenv->env_ipc_dstva = dstva;
f0105e42:	e8 cf 14 00 00       	call   f0107316 <cpunum>
f0105e47:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e4a:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105e50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105e53:	89 48 70             	mov    %ecx,0x70(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105e56:	e8 bb 14 00 00       	call   f0107316 <cpunum>
f0105e5b:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e5e:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0105e64:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105e6b:	e8 49 f6 ff ff       	call   f01054b9 <sched_yield>
	int ret = envid2env(envid, &e, 1);
f0105e70:	83 ec 04             	sub    $0x4,%esp
f0105e73:	6a 01                	push   $0x1
f0105e75:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105e78:	50                   	push   %eax
f0105e79:	ff 75 0c             	pushl  0xc(%ebp)
f0105e7c:	e8 9e d7 ff ff       	call   f010361f <envid2env>
f0105e81:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105e83:	83 c4 10             	add    $0x10,%esp
f0105e86:	85 c0                	test   %eax,%eax
f0105e88:	0f 88 d1 f7 ff ff    	js     f010565f <syscall+0x52>
	e->env_pgfault_upcall = func;
f0105e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e91:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105e94:	89 48 68             	mov    %ecx,0x68(%eax)
	return 0;
f0105e97:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105e9c:	e9 be f7 ff ff       	jmp    f010565f <syscall+0x52>
	r = envid2env(envid, &e, 0);
f0105ea1:	83 ec 04             	sub    $0x4,%esp
f0105ea4:	6a 00                	push   $0x0
f0105ea6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105ea9:	50                   	push   %eax
f0105eaa:	ff 75 0c             	pushl  0xc(%ebp)
f0105ead:	e8 6d d7 ff ff       	call   f010361f <envid2env>
f0105eb2:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f0105eb4:	83 c4 10             	add    $0x10,%esp
f0105eb7:	85 c0                	test   %eax,%eax
f0105eb9:	0f 88 a0 f7 ff ff    	js     f010565f <syscall+0x52>
	e->env_tf = *tf;
f0105ebf:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105ec4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105ec7:	8b 75 10             	mov    0x10(%ebp),%esi
f0105eca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f0105ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105ecf:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f0105ed4:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f0105edb:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105ee0:	e9 7a f7 ff ff       	jmp    f010565f <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f0105ee5:	83 ec 04             	sub    $0x4,%esp
f0105ee8:	6a 00                	push   $0x0
f0105eea:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105eed:	50                   	push   %eax
f0105eee:	ff 75 0c             	pushl  0xc(%ebp)
f0105ef1:	e8 29 d7 ff ff       	call   f010361f <envid2env>
f0105ef6:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105ef8:	83 c4 10             	add    $0x10,%esp
f0105efb:	85 c0                	test   %eax,%eax
f0105efd:	0f 88 5c f7 ff ff    	js     f010565f <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f0105f03:	83 ec 04             	sub    $0x4,%esp
f0105f06:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105f09:	50                   	push   %eax
f0105f0a:	ff 75 10             	pushl  0x10(%ebp)
f0105f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105f10:	ff 70 60             	pushl  0x60(%eax)
f0105f13:	e8 33 b6 ff ff       	call   f010154b <page_lookup>
	if(page == NULL)
f0105f18:	83 c4 10             	add    $0x10,%esp
f0105f1b:	85 c0                	test   %eax,%eax
f0105f1d:	74 16                	je     f0105f35 <syscall+0x928>
	*pte_store |= PTE_A;
f0105f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f22:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f0105f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f28:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f0105f2b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105f30:	e9 2a f7 ff ff       	jmp    f010565f <syscall+0x52>
		return -E_INVAL;
f0105f35:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105f3a:	e9 20 f7 ff ff       	jmp    f010565f <syscall+0x52>
	return time_msec();
f0105f3f:	e8 36 22 00 00       	call   f010817a <time_msec>
f0105f44:	89 c3                	mov    %eax,%ebx
			break;
f0105f46:	e9 14 f7 ff ff       	jmp    f010565f <syscall+0x52>
			ret = sys_net_send((void *)a1, (uint32_t)a2);
f0105f4b:	83 ec 08             	sub    $0x8,%esp
f0105f4e:	ff 75 10             	pushl  0x10(%ebp)
f0105f51:	ff 75 0c             	pushl  0xc(%ebp)
f0105f54:	e8 1b f6 ff ff       	call   f0105574 <sys_net_send>
f0105f59:	89 c3                	mov    %eax,%ebx
			break;
f0105f5b:	83 c4 10             	add    $0x10,%esp
f0105f5e:	e9 fc f6 ff ff       	jmp    f010565f <syscall+0x52>
			ret = sys_net_recv((void *)a1, (uint32_t)a2);
f0105f63:	83 ec 08             	sub    $0x8,%esp
f0105f66:	ff 75 10             	pushl  0x10(%ebp)
f0105f69:	ff 75 0c             	pushl  0xc(%ebp)
f0105f6c:	e8 5e f6 ff ff       	call   f01055cf <sys_net_recv>
f0105f71:	89 c3                	mov    %eax,%ebx
			break;
f0105f73:	83 c4 10             	add    $0x10,%esp
f0105f76:	e9 e4 f6 ff ff       	jmp    f010565f <syscall+0x52>
	*mac_addr_store = read_eeprom_mac_addr();
f0105f7b:	e8 ab 17 00 00       	call   f010772b <read_eeprom_mac_addr>
f0105f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105f83:	89 01                	mov    %eax,(%ecx)
f0105f85:	89 51 04             	mov    %edx,0x4(%ecx)
	cprintf("in sys_get_mac_addr the mac_addr is 0x%016lx\n", *mac_addr_store);
f0105f88:	83 ec 04             	sub    $0x4,%esp
f0105f8b:	52                   	push   %edx
f0105f8c:	50                   	push   %eax
f0105f8d:	68 70 a2 10 f0       	push   $0xf010a270
f0105f92:	e8 6a e6 ff ff       	call   f0104601 <cprintf>
f0105f97:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f0105f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105f9f:	e9 bb f6 ff ff       	jmp    f010565f <syscall+0x52>
			ret = -E_INVAL;
f0105fa4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105fa9:	e9 b1 f6 ff ff       	jmp    f010565f <syscall+0x52>
        return E_INVAL;
f0105fae:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105fb3:	e9 a7 f6 ff ff       	jmp    f010565f <syscall+0x52>

f0105fb8 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105fb8:	55                   	push   %ebp
f0105fb9:	89 e5                	mov    %esp,%ebp
f0105fbb:	57                   	push   %edi
f0105fbc:	56                   	push   %esi
f0105fbd:	53                   	push   %ebx
f0105fbe:	83 ec 14             	sub    $0x14,%esp
f0105fc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105fc4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105fc7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105fca:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105fcd:	8b 1a                	mov    (%edx),%ebx
f0105fcf:	8b 01                	mov    (%ecx),%eax
f0105fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105fd4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105fdb:	eb 23                	jmp    f0106000 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105fdd:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105fe0:	eb 1e                	jmp    f0106000 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105fe2:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105fe5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105fe8:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105fec:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105fef:	73 41                	jae    f0106032 <stab_binsearch+0x7a>
			*region_left = m;
f0105ff1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105ff4:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0105ff6:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0105ff9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0106000:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0106003:	7f 5a                	jg     f010605f <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0106005:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106008:	01 d8                	add    %ebx,%eax
f010600a:	89 c7                	mov    %eax,%edi
f010600c:	c1 ef 1f             	shr    $0x1f,%edi
f010600f:	01 c7                	add    %eax,%edi
f0106011:	d1 ff                	sar    %edi
f0106013:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0106016:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0106019:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f010601d:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f010601f:	39 c3                	cmp    %eax,%ebx
f0106021:	7f ba                	jg     f0105fdd <stab_binsearch+0x25>
f0106023:	0f b6 0a             	movzbl (%edx),%ecx
f0106026:	83 ea 0c             	sub    $0xc,%edx
f0106029:	39 f1                	cmp    %esi,%ecx
f010602b:	74 b5                	je     f0105fe2 <stab_binsearch+0x2a>
			m--;
f010602d:	83 e8 01             	sub    $0x1,%eax
f0106030:	eb ed                	jmp    f010601f <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0106032:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0106035:	76 14                	jbe    f010604b <stab_binsearch+0x93>
			*region_right = m - 1;
f0106037:	83 e8 01             	sub    $0x1,%eax
f010603a:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010603d:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0106040:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0106042:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0106049:	eb b5                	jmp    f0106000 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f010604b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010604e:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0106050:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0106054:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0106056:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010605d:	eb a1                	jmp    f0106000 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f010605f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0106063:	75 15                	jne    f010607a <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0106065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106068:	8b 00                	mov    (%eax),%eax
f010606a:	83 e8 01             	sub    $0x1,%eax
f010606d:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0106070:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0106072:	83 c4 14             	add    $0x14,%esp
f0106075:	5b                   	pop    %ebx
f0106076:	5e                   	pop    %esi
f0106077:	5f                   	pop    %edi
f0106078:	5d                   	pop    %ebp
f0106079:	c3                   	ret    
		for (l = *region_right;
f010607a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010607d:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f010607f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0106082:	8b 0f                	mov    (%edi),%ecx
f0106084:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0106087:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010608a:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f010608e:	eb 03                	jmp    f0106093 <stab_binsearch+0xdb>
		     l--)
f0106090:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0106093:	39 c1                	cmp    %eax,%ecx
f0106095:	7d 0a                	jge    f01060a1 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0106097:	0f b6 1a             	movzbl (%edx),%ebx
f010609a:	83 ea 0c             	sub    $0xc,%edx
f010609d:	39 f3                	cmp    %esi,%ebx
f010609f:	75 ef                	jne    f0106090 <stab_binsearch+0xd8>
		*region_left = l;
f01060a1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01060a4:	89 06                	mov    %eax,(%esi)
}
f01060a6:	eb ca                	jmp    f0106072 <stab_binsearch+0xba>

f01060a8 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f01060a8:	55                   	push   %ebp
f01060a9:	89 e5                	mov    %esp,%ebp
f01060ab:	57                   	push   %edi
f01060ac:	56                   	push   %esi
f01060ad:	53                   	push   %ebx
f01060ae:	83 ec 4c             	sub    $0x4c,%esp
f01060b1:	8b 7d 08             	mov    0x8(%ebp),%edi
f01060b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01060b7:	c7 03 f8 a2 10 f0    	movl   $0xf010a2f8,(%ebx)
	info->eip_line = 0;
f01060bd:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f01060c4:	c7 43 08 f8 a2 10 f0 	movl   $0xf010a2f8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f01060cb:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f01060d2:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f01060d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01060dc:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f01060e2:	0f 86 23 01 00 00    	jbe    f010620b <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01060e8:	c7 45 b8 3c 07 12 f0 	movl   $0xf012073c,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f01060ef:	c7 45 b4 45 bb 11 f0 	movl   $0xf011bb45,-0x4c(%ebp)
		stab_end = __STAB_END__;
f01060f6:	be 44 bb 11 f0       	mov    $0xf011bb44,%esi
		stabs = __STAB_BEGIN__;
f01060fb:	c7 45 bc a0 ab 10 f0 	movl   $0xf010aba0,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0106102:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0106105:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f0106108:	0f 83 59 02 00 00    	jae    f0106367 <debuginfo_eip+0x2bf>
f010610e:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0106112:	0f 85 56 02 00 00    	jne    f010636e <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0106118:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f010611f:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0106122:	c1 fe 02             	sar    $0x2,%esi
f0106125:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f010612b:	83 e8 01             	sub    $0x1,%eax
f010612e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0106131:	83 ec 08             	sub    $0x8,%esp
f0106134:	57                   	push   %edi
f0106135:	6a 64                	push   $0x64
f0106137:	8d 55 e0             	lea    -0x20(%ebp),%edx
f010613a:	89 d1                	mov    %edx,%ecx
f010613c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010613f:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0106142:	89 f0                	mov    %esi,%eax
f0106144:	e8 6f fe ff ff       	call   f0105fb8 <stab_binsearch>
	if (lfile == 0)
f0106149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010614c:	83 c4 10             	add    $0x10,%esp
f010614f:	85 c0                	test   %eax,%eax
f0106151:	0f 84 1e 02 00 00    	je     f0106375 <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0106157:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f010615a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010615d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0106160:	83 ec 08             	sub    $0x8,%esp
f0106163:	57                   	push   %edi
f0106164:	6a 24                	push   $0x24
f0106166:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0106169:	89 d1                	mov    %edx,%ecx
f010616b:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010616e:	89 f0                	mov    %esi,%eax
f0106170:	e8 43 fe ff ff       	call   f0105fb8 <stab_binsearch>

	if (lfun <= rfun) {
f0106175:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0106178:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f010617b:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f010617e:	83 c4 10             	add    $0x10,%esp
f0106181:	39 c8                	cmp    %ecx,%eax
f0106183:	0f 8f 26 01 00 00    	jg     f01062af <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0106189:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010618c:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f010618f:	8b 11                	mov    (%ecx),%edx
f0106191:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0106194:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0106197:	39 f2                	cmp    %esi,%edx
f0106199:	73 06                	jae    f01061a1 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010619b:	03 55 b4             	add    -0x4c(%ebp),%edx
f010619e:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f01061a1:	8b 51 08             	mov    0x8(%ecx),%edx
f01061a4:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f01061a7:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f01061a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f01061ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f01061af:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01061b2:	83 ec 08             	sub    $0x8,%esp
f01061b5:	6a 3a                	push   $0x3a
f01061b7:	ff 73 08             	pushl  0x8(%ebx)
f01061ba:	e8 34 0b 00 00       	call   f0106cf3 <strfind>
f01061bf:	2b 43 08             	sub    0x8(%ebx),%eax
f01061c2:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f01061c5:	83 c4 08             	add    $0x8,%esp
f01061c8:	57                   	push   %edi
f01061c9:	6a 44                	push   $0x44
f01061cb:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f01061ce:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f01061d1:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01061d4:	89 f0                	mov    %esi,%eax
f01061d6:	e8 dd fd ff ff       	call   f0105fb8 <stab_binsearch>
	if(lline <= rline){
f01061db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01061de:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01061e1:	83 c4 10             	add    $0x10,%esp
f01061e4:	39 c2                	cmp    %eax,%edx
f01061e6:	0f 8f 90 01 00 00    	jg     f010637c <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f01061ec:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01061ef:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f01061f3:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01061f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01061f9:	89 d0                	mov    %edx,%eax
f01061fb:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01061fe:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0106202:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0106206:	e9 c2 00 00 00       	jmp    f01062cd <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f010620b:	e8 06 11 00 00       	call   f0107316 <cpunum>
f0106210:	6a 06                	push   $0x6
f0106212:	6a 10                	push   $0x10
f0106214:	68 00 00 20 00       	push   $0x200000
f0106219:	6b c0 74             	imul   $0x74,%eax,%eax
f010621c:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0106222:	e8 dc d1 ff ff       	call   f0103403 <user_mem_check>
f0106227:	83 c4 10             	add    $0x10,%esp
f010622a:	85 c0                	test   %eax,%eax
f010622c:	0f 88 27 01 00 00    	js     f0106359 <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f0106232:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0106238:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f010623b:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0106241:	a1 08 00 20 00       	mov    0x200008,%eax
f0106246:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0106249:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f010624f:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f0106252:	e8 bf 10 00 00       	call   f0107316 <cpunum>
f0106257:	6a 06                	push   $0x6
f0106259:	89 f2                	mov    %esi,%edx
f010625b:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f010625e:	29 ca                	sub    %ecx,%edx
f0106260:	52                   	push   %edx
f0106261:	51                   	push   %ecx
f0106262:	6b c0 74             	imul   $0x74,%eax,%eax
f0106265:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f010626b:	e8 93 d1 ff ff       	call   f0103403 <user_mem_check>
f0106270:	83 c4 10             	add    $0x10,%esp
f0106273:	85 c0                	test   %eax,%eax
f0106275:	0f 88 e5 00 00 00    	js     f0106360 <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f010627b:	e8 96 10 00 00       	call   f0107316 <cpunum>
f0106280:	6a 06                	push   $0x6
f0106282:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0106285:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0106288:	29 ca                	sub    %ecx,%edx
f010628a:	52                   	push   %edx
f010628b:	51                   	push   %ecx
f010628c:	6b c0 74             	imul   $0x74,%eax,%eax
f010628f:	ff b0 28 b0 16 f0    	pushl  -0xfe94fd8(%eax)
f0106295:	e8 69 d1 ff ff       	call   f0103403 <user_mem_check>
f010629a:	83 c4 10             	add    $0x10,%esp
f010629d:	85 c0                	test   %eax,%eax
f010629f:	0f 89 5d fe ff ff    	jns    f0106102 <debuginfo_eip+0x5a>
			return -1;
f01062a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01062aa:	e9 d9 00 00 00       	jmp    f0106388 <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f01062af:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f01062b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01062b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01062b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01062bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01062be:	e9 ef fe ff ff       	jmp    f01061b2 <debuginfo_eip+0x10a>
f01062c3:	83 e8 01             	sub    $0x1,%eax
f01062c6:	83 ea 0c             	sub    $0xc,%edx
f01062c9:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f01062cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f01062d0:	39 c7                	cmp    %eax,%edi
f01062d2:	7f 45                	jg     f0106319 <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f01062d4:	0f b6 0a             	movzbl (%edx),%ecx
f01062d7:	80 f9 84             	cmp    $0x84,%cl
f01062da:	74 19                	je     f01062f5 <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01062dc:	80 f9 64             	cmp    $0x64,%cl
f01062df:	75 e2                	jne    f01062c3 <debuginfo_eip+0x21b>
f01062e1:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f01062e5:	74 dc                	je     f01062c3 <debuginfo_eip+0x21b>
f01062e7:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01062eb:	74 11                	je     f01062fe <debuginfo_eip+0x256>
f01062ed:	8b 7d c0             	mov    -0x40(%ebp),%edi
f01062f0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01062f3:	eb 09                	jmp    f01062fe <debuginfo_eip+0x256>
f01062f5:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01062f9:	74 03                	je     f01062fe <debuginfo_eip+0x256>
f01062fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01062fe:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0106301:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0106304:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0106307:	8b 45 b8             	mov    -0x48(%ebp),%eax
f010630a:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f010630d:	29 f8                	sub    %edi,%eax
f010630f:	39 c2                	cmp    %eax,%edx
f0106311:	73 06                	jae    f0106319 <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0106313:	89 f8                	mov    %edi,%eax
f0106315:	01 d0                	add    %edx,%eax
f0106317:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0106319:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010631c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f010631f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0106324:	39 f2                	cmp    %esi,%edx
f0106326:	7d 60                	jge    f0106388 <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0106328:	83 c2 01             	add    $0x1,%edx
f010632b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010632e:	89 d0                	mov    %edx,%eax
f0106330:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0106333:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0106336:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f010633a:	eb 04                	jmp    f0106340 <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f010633c:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0106340:	39 c6                	cmp    %eax,%esi
f0106342:	7e 3f                	jle    f0106383 <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0106344:	0f b6 0a             	movzbl (%edx),%ecx
f0106347:	83 c0 01             	add    $0x1,%eax
f010634a:	83 c2 0c             	add    $0xc,%edx
f010634d:	80 f9 a0             	cmp    $0xa0,%cl
f0106350:	74 ea                	je     f010633c <debuginfo_eip+0x294>
	return 0;
f0106352:	b8 00 00 00 00       	mov    $0x0,%eax
f0106357:	eb 2f                	jmp    f0106388 <debuginfo_eip+0x2e0>
			return -1;
f0106359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010635e:	eb 28                	jmp    f0106388 <debuginfo_eip+0x2e0>
			return -1;
f0106360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0106365:	eb 21                	jmp    f0106388 <debuginfo_eip+0x2e0>
		return -1;
f0106367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010636c:	eb 1a                	jmp    f0106388 <debuginfo_eip+0x2e0>
f010636e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0106373:	eb 13                	jmp    f0106388 <debuginfo_eip+0x2e0>
		return -1;
f0106375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010637a:	eb 0c                	jmp    f0106388 <debuginfo_eip+0x2e0>
		return -1;
f010637c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0106381:	eb 05                	jmp    f0106388 <debuginfo_eip+0x2e0>
	return 0;
f0106383:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106388:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010638b:	5b                   	pop    %ebx
f010638c:	5e                   	pop    %esi
f010638d:	5f                   	pop    %edi
f010638e:	5d                   	pop    %ebp
f010638f:	c3                   	ret    

f0106390 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0106390:	55                   	push   %ebp
f0106391:	89 e5                	mov    %esp,%ebp
f0106393:	57                   	push   %edi
f0106394:	56                   	push   %esi
f0106395:	53                   	push   %ebx
f0106396:	83 ec 1c             	sub    $0x1c,%esp
f0106399:	89 c6                	mov    %eax,%esi
f010639b:	89 d7                	mov    %edx,%edi
f010639d:	8b 45 08             	mov    0x8(%ebp),%eax
f01063a0:	8b 55 0c             	mov    0xc(%ebp),%edx
f01063a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01063a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01063a9:	8b 45 10             	mov    0x10(%ebp),%eax
f01063ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f01063af:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f01063b3:	74 2c                	je     f01063e1 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f01063b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01063b8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f01063bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01063c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01063c5:	39 c2                	cmp    %eax,%edx
f01063c7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f01063ca:	73 43                	jae    f010640f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f01063cc:	83 eb 01             	sub    $0x1,%ebx
f01063cf:	85 db                	test   %ebx,%ebx
f01063d1:	7e 6c                	jle    f010643f <printnum+0xaf>
				putch(padc, putdat);
f01063d3:	83 ec 08             	sub    $0x8,%esp
f01063d6:	57                   	push   %edi
f01063d7:	ff 75 18             	pushl  0x18(%ebp)
f01063da:	ff d6                	call   *%esi
f01063dc:	83 c4 10             	add    $0x10,%esp
f01063df:	eb eb                	jmp    f01063cc <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f01063e1:	83 ec 0c             	sub    $0xc,%esp
f01063e4:	6a 20                	push   $0x20
f01063e6:	6a 00                	push   $0x0
f01063e8:	50                   	push   %eax
f01063e9:	ff 75 e4             	pushl  -0x1c(%ebp)
f01063ec:	ff 75 e0             	pushl  -0x20(%ebp)
f01063ef:	89 fa                	mov    %edi,%edx
f01063f1:	89 f0                	mov    %esi,%eax
f01063f3:	e8 98 ff ff ff       	call   f0106390 <printnum>
		while (--width > 0)
f01063f8:	83 c4 20             	add    $0x20,%esp
f01063fb:	83 eb 01             	sub    $0x1,%ebx
f01063fe:	85 db                	test   %ebx,%ebx
f0106400:	7e 65                	jle    f0106467 <printnum+0xd7>
			putch(padc, putdat);
f0106402:	83 ec 08             	sub    $0x8,%esp
f0106405:	57                   	push   %edi
f0106406:	6a 20                	push   $0x20
f0106408:	ff d6                	call   *%esi
f010640a:	83 c4 10             	add    $0x10,%esp
f010640d:	eb ec                	jmp    f01063fb <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f010640f:	83 ec 0c             	sub    $0xc,%esp
f0106412:	ff 75 18             	pushl  0x18(%ebp)
f0106415:	83 eb 01             	sub    $0x1,%ebx
f0106418:	53                   	push   %ebx
f0106419:	50                   	push   %eax
f010641a:	83 ec 08             	sub    $0x8,%esp
f010641d:	ff 75 dc             	pushl  -0x24(%ebp)
f0106420:	ff 75 d8             	pushl  -0x28(%ebp)
f0106423:	ff 75 e4             	pushl  -0x1c(%ebp)
f0106426:	ff 75 e0             	pushl  -0x20(%ebp)
f0106429:	e8 62 1d 00 00       	call   f0108190 <__udivdi3>
f010642e:	83 c4 18             	add    $0x18,%esp
f0106431:	52                   	push   %edx
f0106432:	50                   	push   %eax
f0106433:	89 fa                	mov    %edi,%edx
f0106435:	89 f0                	mov    %esi,%eax
f0106437:	e8 54 ff ff ff       	call   f0106390 <printnum>
f010643c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f010643f:	83 ec 08             	sub    $0x8,%esp
f0106442:	57                   	push   %edi
f0106443:	83 ec 04             	sub    $0x4,%esp
f0106446:	ff 75 dc             	pushl  -0x24(%ebp)
f0106449:	ff 75 d8             	pushl  -0x28(%ebp)
f010644c:	ff 75 e4             	pushl  -0x1c(%ebp)
f010644f:	ff 75 e0             	pushl  -0x20(%ebp)
f0106452:	e8 49 1e 00 00       	call   f01082a0 <__umoddi3>
f0106457:	83 c4 14             	add    $0x14,%esp
f010645a:	0f be 80 02 a3 10 f0 	movsbl -0xfef5cfe(%eax),%eax
f0106461:	50                   	push   %eax
f0106462:	ff d6                	call   *%esi
f0106464:	83 c4 10             	add    $0x10,%esp
	}
}
f0106467:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010646a:	5b                   	pop    %ebx
f010646b:	5e                   	pop    %esi
f010646c:	5f                   	pop    %edi
f010646d:	5d                   	pop    %ebp
f010646e:	c3                   	ret    

f010646f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010646f:	55                   	push   %ebp
f0106470:	89 e5                	mov    %esp,%ebp
f0106472:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0106475:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0106479:	8b 10                	mov    (%eax),%edx
f010647b:	3b 50 04             	cmp    0x4(%eax),%edx
f010647e:	73 0a                	jae    f010648a <sprintputch+0x1b>
		*b->buf++ = ch;
f0106480:	8d 4a 01             	lea    0x1(%edx),%ecx
f0106483:	89 08                	mov    %ecx,(%eax)
f0106485:	8b 45 08             	mov    0x8(%ebp),%eax
f0106488:	88 02                	mov    %al,(%edx)
}
f010648a:	5d                   	pop    %ebp
f010648b:	c3                   	ret    

f010648c <printfmt>:
{
f010648c:	55                   	push   %ebp
f010648d:	89 e5                	mov    %esp,%ebp
f010648f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0106492:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0106495:	50                   	push   %eax
f0106496:	ff 75 10             	pushl  0x10(%ebp)
f0106499:	ff 75 0c             	pushl  0xc(%ebp)
f010649c:	ff 75 08             	pushl  0x8(%ebp)
f010649f:	e8 05 00 00 00       	call   f01064a9 <vprintfmt>
}
f01064a4:	83 c4 10             	add    $0x10,%esp
f01064a7:	c9                   	leave  
f01064a8:	c3                   	ret    

f01064a9 <vprintfmt>:
{
f01064a9:	55                   	push   %ebp
f01064aa:	89 e5                	mov    %esp,%ebp
f01064ac:	57                   	push   %edi
f01064ad:	56                   	push   %esi
f01064ae:	53                   	push   %ebx
f01064af:	83 ec 3c             	sub    $0x3c,%esp
f01064b2:	8b 75 08             	mov    0x8(%ebp),%esi
f01064b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01064b8:	8b 7d 10             	mov    0x10(%ebp),%edi
f01064bb:	e9 32 04 00 00       	jmp    f01068f2 <vprintfmt+0x449>
		padc = ' ';
f01064c0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f01064c4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f01064cb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f01064d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f01064d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f01064e0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f01064e7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01064ec:	8d 47 01             	lea    0x1(%edi),%eax
f01064ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01064f2:	0f b6 17             	movzbl (%edi),%edx
f01064f5:	8d 42 dd             	lea    -0x23(%edx),%eax
f01064f8:	3c 55                	cmp    $0x55,%al
f01064fa:	0f 87 12 05 00 00    	ja     f0106a12 <vprintfmt+0x569>
f0106500:	0f b6 c0             	movzbl %al,%eax
f0106503:	ff 24 85 e0 a4 10 f0 	jmp    *-0xfef5b20(,%eax,4)
f010650a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f010650d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0106511:	eb d9                	jmp    f01064ec <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0106513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0106516:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f010651a:	eb d0                	jmp    f01064ec <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f010651c:	0f b6 d2             	movzbl %dl,%edx
f010651f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0106522:	b8 00 00 00 00       	mov    $0x0,%eax
f0106527:	89 75 08             	mov    %esi,0x8(%ebp)
f010652a:	eb 03                	jmp    f010652f <vprintfmt+0x86>
f010652c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f010652f:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0106532:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0106536:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0106539:	8d 72 d0             	lea    -0x30(%edx),%esi
f010653c:	83 fe 09             	cmp    $0x9,%esi
f010653f:	76 eb                	jbe    f010652c <vprintfmt+0x83>
f0106541:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106544:	8b 75 08             	mov    0x8(%ebp),%esi
f0106547:	eb 14                	jmp    f010655d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0106549:	8b 45 14             	mov    0x14(%ebp),%eax
f010654c:	8b 00                	mov    (%eax),%eax
f010654e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106551:	8b 45 14             	mov    0x14(%ebp),%eax
f0106554:	8d 40 04             	lea    0x4(%eax),%eax
f0106557:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010655a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f010655d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0106561:	79 89                	jns    f01064ec <vprintfmt+0x43>
				width = precision, precision = -1;
f0106563:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106566:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106569:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0106570:	e9 77 ff ff ff       	jmp    f01064ec <vprintfmt+0x43>
f0106575:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106578:	85 c0                	test   %eax,%eax
f010657a:	0f 48 c1             	cmovs  %ecx,%eax
f010657d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0106583:	e9 64 ff ff ff       	jmp    f01064ec <vprintfmt+0x43>
f0106588:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f010658b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0106592:	e9 55 ff ff ff       	jmp    f01064ec <vprintfmt+0x43>
			lflag++;
f0106597:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010659b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f010659e:	e9 49 ff ff ff       	jmp    f01064ec <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f01065a3:	8b 45 14             	mov    0x14(%ebp),%eax
f01065a6:	8d 78 04             	lea    0x4(%eax),%edi
f01065a9:	83 ec 08             	sub    $0x8,%esp
f01065ac:	53                   	push   %ebx
f01065ad:	ff 30                	pushl  (%eax)
f01065af:	ff d6                	call   *%esi
			break;
f01065b1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f01065b4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f01065b7:	e9 33 03 00 00       	jmp    f01068ef <vprintfmt+0x446>
			err = va_arg(ap, int);
f01065bc:	8b 45 14             	mov    0x14(%ebp),%eax
f01065bf:	8d 78 04             	lea    0x4(%eax),%edi
f01065c2:	8b 00                	mov    (%eax),%eax
f01065c4:	99                   	cltd   
f01065c5:	31 d0                	xor    %edx,%eax
f01065c7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01065c9:	83 f8 11             	cmp    $0x11,%eax
f01065cc:	7f 23                	jg     f01065f1 <vprintfmt+0x148>
f01065ce:	8b 14 85 40 a6 10 f0 	mov    -0xfef59c0(,%eax,4),%edx
f01065d5:	85 d2                	test   %edx,%edx
f01065d7:	74 18                	je     f01065f1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f01065d9:	52                   	push   %edx
f01065da:	68 1d 96 10 f0       	push   $0xf010961d
f01065df:	53                   	push   %ebx
f01065e0:	56                   	push   %esi
f01065e1:	e8 a6 fe ff ff       	call   f010648c <printfmt>
f01065e6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01065e9:	89 7d 14             	mov    %edi,0x14(%ebp)
f01065ec:	e9 fe 02 00 00       	jmp    f01068ef <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f01065f1:	50                   	push   %eax
f01065f2:	68 1a a3 10 f0       	push   $0xf010a31a
f01065f7:	53                   	push   %ebx
f01065f8:	56                   	push   %esi
f01065f9:	e8 8e fe ff ff       	call   f010648c <printfmt>
f01065fe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0106601:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0106604:	e9 e6 02 00 00       	jmp    f01068ef <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f0106609:	8b 45 14             	mov    0x14(%ebp),%eax
f010660c:	83 c0 04             	add    $0x4,%eax
f010660f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0106612:	8b 45 14             	mov    0x14(%ebp),%eax
f0106615:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f0106617:	85 c9                	test   %ecx,%ecx
f0106619:	b8 13 a3 10 f0       	mov    $0xf010a313,%eax
f010661e:	0f 45 c1             	cmovne %ecx,%eax
f0106621:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0106624:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0106628:	7e 06                	jle    f0106630 <vprintfmt+0x187>
f010662a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f010662e:	75 0d                	jne    f010663d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0106630:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0106633:	89 c7                	mov    %eax,%edi
f0106635:	03 45 e0             	add    -0x20(%ebp),%eax
f0106638:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010663b:	eb 53                	jmp    f0106690 <vprintfmt+0x1e7>
f010663d:	83 ec 08             	sub    $0x8,%esp
f0106640:	ff 75 d8             	pushl  -0x28(%ebp)
f0106643:	50                   	push   %eax
f0106644:	e8 5f 05 00 00       	call   f0106ba8 <strnlen>
f0106649:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010664c:	29 c1                	sub    %eax,%ecx
f010664e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0106651:	83 c4 10             	add    $0x10,%esp
f0106654:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0106656:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f010665a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f010665d:	eb 0f                	jmp    f010666e <vprintfmt+0x1c5>
					putch(padc, putdat);
f010665f:	83 ec 08             	sub    $0x8,%esp
f0106662:	53                   	push   %ebx
f0106663:	ff 75 e0             	pushl  -0x20(%ebp)
f0106666:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0106668:	83 ef 01             	sub    $0x1,%edi
f010666b:	83 c4 10             	add    $0x10,%esp
f010666e:	85 ff                	test   %edi,%edi
f0106670:	7f ed                	jg     f010665f <vprintfmt+0x1b6>
f0106672:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0106675:	85 c9                	test   %ecx,%ecx
f0106677:	b8 00 00 00 00       	mov    $0x0,%eax
f010667c:	0f 49 c1             	cmovns %ecx,%eax
f010667f:	29 c1                	sub    %eax,%ecx
f0106681:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0106684:	eb aa                	jmp    f0106630 <vprintfmt+0x187>
					putch(ch, putdat);
f0106686:	83 ec 08             	sub    $0x8,%esp
f0106689:	53                   	push   %ebx
f010668a:	52                   	push   %edx
f010668b:	ff d6                	call   *%esi
f010668d:	83 c4 10             	add    $0x10,%esp
f0106690:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106693:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0106695:	83 c7 01             	add    $0x1,%edi
f0106698:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010669c:	0f be d0             	movsbl %al,%edx
f010669f:	85 d2                	test   %edx,%edx
f01066a1:	74 4b                	je     f01066ee <vprintfmt+0x245>
f01066a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01066a7:	78 06                	js     f01066af <vprintfmt+0x206>
f01066a9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f01066ad:	78 1e                	js     f01066cd <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f01066af:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f01066b3:	74 d1                	je     f0106686 <vprintfmt+0x1dd>
f01066b5:	0f be c0             	movsbl %al,%eax
f01066b8:	83 e8 20             	sub    $0x20,%eax
f01066bb:	83 f8 5e             	cmp    $0x5e,%eax
f01066be:	76 c6                	jbe    f0106686 <vprintfmt+0x1dd>
					putch('?', putdat);
f01066c0:	83 ec 08             	sub    $0x8,%esp
f01066c3:	53                   	push   %ebx
f01066c4:	6a 3f                	push   $0x3f
f01066c6:	ff d6                	call   *%esi
f01066c8:	83 c4 10             	add    $0x10,%esp
f01066cb:	eb c3                	jmp    f0106690 <vprintfmt+0x1e7>
f01066cd:	89 cf                	mov    %ecx,%edi
f01066cf:	eb 0e                	jmp    f01066df <vprintfmt+0x236>
				putch(' ', putdat);
f01066d1:	83 ec 08             	sub    $0x8,%esp
f01066d4:	53                   	push   %ebx
f01066d5:	6a 20                	push   $0x20
f01066d7:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01066d9:	83 ef 01             	sub    $0x1,%edi
f01066dc:	83 c4 10             	add    $0x10,%esp
f01066df:	85 ff                	test   %edi,%edi
f01066e1:	7f ee                	jg     f01066d1 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f01066e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f01066e6:	89 45 14             	mov    %eax,0x14(%ebp)
f01066e9:	e9 01 02 00 00       	jmp    f01068ef <vprintfmt+0x446>
f01066ee:	89 cf                	mov    %ecx,%edi
f01066f0:	eb ed                	jmp    f01066df <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f01066f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f01066f5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f01066fc:	e9 eb fd ff ff       	jmp    f01064ec <vprintfmt+0x43>
	if (lflag >= 2)
f0106701:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0106705:	7f 21                	jg     f0106728 <vprintfmt+0x27f>
	else if (lflag)
f0106707:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f010670b:	74 68                	je     f0106775 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f010670d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106710:	8b 00                	mov    (%eax),%eax
f0106712:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106715:	89 c1                	mov    %eax,%ecx
f0106717:	c1 f9 1f             	sar    $0x1f,%ecx
f010671a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f010671d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106720:	8d 40 04             	lea    0x4(%eax),%eax
f0106723:	89 45 14             	mov    %eax,0x14(%ebp)
f0106726:	eb 17                	jmp    f010673f <vprintfmt+0x296>
		return va_arg(*ap, long long);
f0106728:	8b 45 14             	mov    0x14(%ebp),%eax
f010672b:	8b 50 04             	mov    0x4(%eax),%edx
f010672e:	8b 00                	mov    (%eax),%eax
f0106730:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106733:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0106736:	8b 45 14             	mov    0x14(%ebp),%eax
f0106739:	8d 40 08             	lea    0x8(%eax),%eax
f010673c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f010673f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106742:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106745:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106748:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f010674b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010674f:	78 3f                	js     f0106790 <vprintfmt+0x2e7>
			base = 10;
f0106751:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f0106756:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f010675a:	0f 84 71 01 00 00    	je     f01068d1 <vprintfmt+0x428>
				putch('+', putdat);
f0106760:	83 ec 08             	sub    $0x8,%esp
f0106763:	53                   	push   %ebx
f0106764:	6a 2b                	push   $0x2b
f0106766:	ff d6                	call   *%esi
f0106768:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010676b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106770:	e9 5c 01 00 00       	jmp    f01068d1 <vprintfmt+0x428>
		return va_arg(*ap, int);
f0106775:	8b 45 14             	mov    0x14(%ebp),%eax
f0106778:	8b 00                	mov    (%eax),%eax
f010677a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010677d:	89 c1                	mov    %eax,%ecx
f010677f:	c1 f9 1f             	sar    $0x1f,%ecx
f0106782:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0106785:	8b 45 14             	mov    0x14(%ebp),%eax
f0106788:	8d 40 04             	lea    0x4(%eax),%eax
f010678b:	89 45 14             	mov    %eax,0x14(%ebp)
f010678e:	eb af                	jmp    f010673f <vprintfmt+0x296>
				putch('-', putdat);
f0106790:	83 ec 08             	sub    $0x8,%esp
f0106793:	53                   	push   %ebx
f0106794:	6a 2d                	push   $0x2d
f0106796:	ff d6                	call   *%esi
				num = -(long long) num;
f0106798:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010679b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010679e:	f7 d8                	neg    %eax
f01067a0:	83 d2 00             	adc    $0x0,%edx
f01067a3:	f7 da                	neg    %edx
f01067a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01067a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01067ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01067ae:	b8 0a 00 00 00       	mov    $0xa,%eax
f01067b3:	e9 19 01 00 00       	jmp    f01068d1 <vprintfmt+0x428>
	if (lflag >= 2)
f01067b8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01067bc:	7f 29                	jg     f01067e7 <vprintfmt+0x33e>
	else if (lflag)
f01067be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01067c2:	74 44                	je     f0106808 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f01067c4:	8b 45 14             	mov    0x14(%ebp),%eax
f01067c7:	8b 00                	mov    (%eax),%eax
f01067c9:	ba 00 00 00 00       	mov    $0x0,%edx
f01067ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01067d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01067d4:	8b 45 14             	mov    0x14(%ebp),%eax
f01067d7:	8d 40 04             	lea    0x4(%eax),%eax
f01067da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01067dd:	b8 0a 00 00 00       	mov    $0xa,%eax
f01067e2:	e9 ea 00 00 00       	jmp    f01068d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01067e7:	8b 45 14             	mov    0x14(%ebp),%eax
f01067ea:	8b 50 04             	mov    0x4(%eax),%edx
f01067ed:	8b 00                	mov    (%eax),%eax
f01067ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01067f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01067f5:	8b 45 14             	mov    0x14(%ebp),%eax
f01067f8:	8d 40 08             	lea    0x8(%eax),%eax
f01067fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01067fe:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106803:	e9 c9 00 00 00       	jmp    f01068d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106808:	8b 45 14             	mov    0x14(%ebp),%eax
f010680b:	8b 00                	mov    (%eax),%eax
f010680d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106812:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106815:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106818:	8b 45 14             	mov    0x14(%ebp),%eax
f010681b:	8d 40 04             	lea    0x4(%eax),%eax
f010681e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106821:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106826:	e9 a6 00 00 00       	jmp    f01068d1 <vprintfmt+0x428>
			putch('0', putdat);
f010682b:	83 ec 08             	sub    $0x8,%esp
f010682e:	53                   	push   %ebx
f010682f:	6a 30                	push   $0x30
f0106831:	ff d6                	call   *%esi
	if (lflag >= 2)
f0106833:	83 c4 10             	add    $0x10,%esp
f0106836:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f010683a:	7f 26                	jg     f0106862 <vprintfmt+0x3b9>
	else if (lflag)
f010683c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106840:	74 3e                	je     f0106880 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f0106842:	8b 45 14             	mov    0x14(%ebp),%eax
f0106845:	8b 00                	mov    (%eax),%eax
f0106847:	ba 00 00 00 00       	mov    $0x0,%edx
f010684c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010684f:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106852:	8b 45 14             	mov    0x14(%ebp),%eax
f0106855:	8d 40 04             	lea    0x4(%eax),%eax
f0106858:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010685b:	b8 08 00 00 00       	mov    $0x8,%eax
f0106860:	eb 6f                	jmp    f01068d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106862:	8b 45 14             	mov    0x14(%ebp),%eax
f0106865:	8b 50 04             	mov    0x4(%eax),%edx
f0106868:	8b 00                	mov    (%eax),%eax
f010686a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010686d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106870:	8b 45 14             	mov    0x14(%ebp),%eax
f0106873:	8d 40 08             	lea    0x8(%eax),%eax
f0106876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106879:	b8 08 00 00 00       	mov    $0x8,%eax
f010687e:	eb 51                	jmp    f01068d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106880:	8b 45 14             	mov    0x14(%ebp),%eax
f0106883:	8b 00                	mov    (%eax),%eax
f0106885:	ba 00 00 00 00       	mov    $0x0,%edx
f010688a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010688d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106890:	8b 45 14             	mov    0x14(%ebp),%eax
f0106893:	8d 40 04             	lea    0x4(%eax),%eax
f0106896:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106899:	b8 08 00 00 00       	mov    $0x8,%eax
f010689e:	eb 31                	jmp    f01068d1 <vprintfmt+0x428>
			putch('0', putdat);
f01068a0:	83 ec 08             	sub    $0x8,%esp
f01068a3:	53                   	push   %ebx
f01068a4:	6a 30                	push   $0x30
f01068a6:	ff d6                	call   *%esi
			putch('x', putdat);
f01068a8:	83 c4 08             	add    $0x8,%esp
f01068ab:	53                   	push   %ebx
f01068ac:	6a 78                	push   $0x78
f01068ae:	ff d6                	call   *%esi
			num = (unsigned long long)
f01068b0:	8b 45 14             	mov    0x14(%ebp),%eax
f01068b3:	8b 00                	mov    (%eax),%eax
f01068b5:	ba 00 00 00 00       	mov    $0x0,%edx
f01068ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01068bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f01068c0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01068c3:	8b 45 14             	mov    0x14(%ebp),%eax
f01068c6:	8d 40 04             	lea    0x4(%eax),%eax
f01068c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01068cc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01068d1:	83 ec 0c             	sub    $0xc,%esp
f01068d4:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f01068d8:	52                   	push   %edx
f01068d9:	ff 75 e0             	pushl  -0x20(%ebp)
f01068dc:	50                   	push   %eax
f01068dd:	ff 75 dc             	pushl  -0x24(%ebp)
f01068e0:	ff 75 d8             	pushl  -0x28(%ebp)
f01068e3:	89 da                	mov    %ebx,%edx
f01068e5:	89 f0                	mov    %esi,%eax
f01068e7:	e8 a4 fa ff ff       	call   f0106390 <printnum>
			break;
f01068ec:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01068ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01068f2:	83 c7 01             	add    $0x1,%edi
f01068f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01068f9:	83 f8 25             	cmp    $0x25,%eax
f01068fc:	0f 84 be fb ff ff    	je     f01064c0 <vprintfmt+0x17>
			if (ch == '\0')
f0106902:	85 c0                	test   %eax,%eax
f0106904:	0f 84 28 01 00 00    	je     f0106a32 <vprintfmt+0x589>
			putch(ch, putdat);
f010690a:	83 ec 08             	sub    $0x8,%esp
f010690d:	53                   	push   %ebx
f010690e:	50                   	push   %eax
f010690f:	ff d6                	call   *%esi
f0106911:	83 c4 10             	add    $0x10,%esp
f0106914:	eb dc                	jmp    f01068f2 <vprintfmt+0x449>
	if (lflag >= 2)
f0106916:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f010691a:	7f 26                	jg     f0106942 <vprintfmt+0x499>
	else if (lflag)
f010691c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106920:	74 41                	je     f0106963 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f0106922:	8b 45 14             	mov    0x14(%ebp),%eax
f0106925:	8b 00                	mov    (%eax),%eax
f0106927:	ba 00 00 00 00       	mov    $0x0,%edx
f010692c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010692f:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106932:	8b 45 14             	mov    0x14(%ebp),%eax
f0106935:	8d 40 04             	lea    0x4(%eax),%eax
f0106938:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010693b:	b8 10 00 00 00       	mov    $0x10,%eax
f0106940:	eb 8f                	jmp    f01068d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106942:	8b 45 14             	mov    0x14(%ebp),%eax
f0106945:	8b 50 04             	mov    0x4(%eax),%edx
f0106948:	8b 00                	mov    (%eax),%eax
f010694a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010694d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106950:	8b 45 14             	mov    0x14(%ebp),%eax
f0106953:	8d 40 08             	lea    0x8(%eax),%eax
f0106956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106959:	b8 10 00 00 00       	mov    $0x10,%eax
f010695e:	e9 6e ff ff ff       	jmp    f01068d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106963:	8b 45 14             	mov    0x14(%ebp),%eax
f0106966:	8b 00                	mov    (%eax),%eax
f0106968:	ba 00 00 00 00       	mov    $0x0,%edx
f010696d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106970:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106973:	8b 45 14             	mov    0x14(%ebp),%eax
f0106976:	8d 40 04             	lea    0x4(%eax),%eax
f0106979:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010697c:	b8 10 00 00 00       	mov    $0x10,%eax
f0106981:	e9 4b ff ff ff       	jmp    f01068d1 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f0106986:	8b 45 14             	mov    0x14(%ebp),%eax
f0106989:	83 c0 04             	add    $0x4,%eax
f010698c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010698f:	8b 45 14             	mov    0x14(%ebp),%eax
f0106992:	8b 00                	mov    (%eax),%eax
f0106994:	85 c0                	test   %eax,%eax
f0106996:	74 14                	je     f01069ac <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f0106998:	8b 13                	mov    (%ebx),%edx
f010699a:	83 fa 7f             	cmp    $0x7f,%edx
f010699d:	7f 37                	jg     f01069d6 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f010699f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f01069a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01069a4:	89 45 14             	mov    %eax,0x14(%ebp)
f01069a7:	e9 43 ff ff ff       	jmp    f01068ef <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f01069ac:	b8 0a 00 00 00       	mov    $0xa,%eax
f01069b1:	bf 39 a4 10 f0       	mov    $0xf010a439,%edi
							putch(ch, putdat);
f01069b6:	83 ec 08             	sub    $0x8,%esp
f01069b9:	53                   	push   %ebx
f01069ba:	50                   	push   %eax
f01069bb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f01069bd:	83 c7 01             	add    $0x1,%edi
f01069c0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f01069c4:	83 c4 10             	add    $0x10,%esp
f01069c7:	85 c0                	test   %eax,%eax
f01069c9:	75 eb                	jne    f01069b6 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f01069cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01069ce:	89 45 14             	mov    %eax,0x14(%ebp)
f01069d1:	e9 19 ff ff ff       	jmp    f01068ef <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f01069d6:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f01069d8:	b8 0a 00 00 00       	mov    $0xa,%eax
f01069dd:	bf 71 a4 10 f0       	mov    $0xf010a471,%edi
							putch(ch, putdat);
f01069e2:	83 ec 08             	sub    $0x8,%esp
f01069e5:	53                   	push   %ebx
f01069e6:	50                   	push   %eax
f01069e7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f01069e9:	83 c7 01             	add    $0x1,%edi
f01069ec:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f01069f0:	83 c4 10             	add    $0x10,%esp
f01069f3:	85 c0                	test   %eax,%eax
f01069f5:	75 eb                	jne    f01069e2 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f01069f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01069fa:	89 45 14             	mov    %eax,0x14(%ebp)
f01069fd:	e9 ed fe ff ff       	jmp    f01068ef <vprintfmt+0x446>
			putch(ch, putdat);
f0106a02:	83 ec 08             	sub    $0x8,%esp
f0106a05:	53                   	push   %ebx
f0106a06:	6a 25                	push   $0x25
f0106a08:	ff d6                	call   *%esi
			break;
f0106a0a:	83 c4 10             	add    $0x10,%esp
f0106a0d:	e9 dd fe ff ff       	jmp    f01068ef <vprintfmt+0x446>
			putch('%', putdat);
f0106a12:	83 ec 08             	sub    $0x8,%esp
f0106a15:	53                   	push   %ebx
f0106a16:	6a 25                	push   $0x25
f0106a18:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0106a1a:	83 c4 10             	add    $0x10,%esp
f0106a1d:	89 f8                	mov    %edi,%eax
f0106a1f:	eb 03                	jmp    f0106a24 <vprintfmt+0x57b>
f0106a21:	83 e8 01             	sub    $0x1,%eax
f0106a24:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0106a28:	75 f7                	jne    f0106a21 <vprintfmt+0x578>
f0106a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106a2d:	e9 bd fe ff ff       	jmp    f01068ef <vprintfmt+0x446>
}
f0106a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106a35:	5b                   	pop    %ebx
f0106a36:	5e                   	pop    %esi
f0106a37:	5f                   	pop    %edi
f0106a38:	5d                   	pop    %ebp
f0106a39:	c3                   	ret    

f0106a3a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0106a3a:	55                   	push   %ebp
f0106a3b:	89 e5                	mov    %esp,%ebp
f0106a3d:	83 ec 18             	sub    $0x18,%esp
f0106a40:	8b 45 08             	mov    0x8(%ebp),%eax
f0106a43:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0106a46:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0106a49:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106a4d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0106a50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0106a57:	85 c0                	test   %eax,%eax
f0106a59:	74 26                	je     f0106a81 <vsnprintf+0x47>
f0106a5b:	85 d2                	test   %edx,%edx
f0106a5d:	7e 22                	jle    f0106a81 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106a5f:	ff 75 14             	pushl  0x14(%ebp)
f0106a62:	ff 75 10             	pushl  0x10(%ebp)
f0106a65:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0106a68:	50                   	push   %eax
f0106a69:	68 6f 64 10 f0       	push   $0xf010646f
f0106a6e:	e8 36 fa ff ff       	call   f01064a9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106a76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0106a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106a7c:	83 c4 10             	add    $0x10,%esp
}
f0106a7f:	c9                   	leave  
f0106a80:	c3                   	ret    
		return -E_INVAL;
f0106a81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0106a86:	eb f7                	jmp    f0106a7f <vsnprintf+0x45>

f0106a88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0106a88:	55                   	push   %ebp
f0106a89:	89 e5                	mov    %esp,%ebp
f0106a8b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106a8e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106a91:	50                   	push   %eax
f0106a92:	ff 75 10             	pushl  0x10(%ebp)
f0106a95:	ff 75 0c             	pushl  0xc(%ebp)
f0106a98:	ff 75 08             	pushl  0x8(%ebp)
f0106a9b:	e8 9a ff ff ff       	call   f0106a3a <vsnprintf>
	va_end(ap);

	return rc;
}
f0106aa0:	c9                   	leave  
f0106aa1:	c3                   	ret    

f0106aa2 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106aa2:	55                   	push   %ebp
f0106aa3:	89 e5                	mov    %esp,%ebp
f0106aa5:	57                   	push   %edi
f0106aa6:	56                   	push   %esi
f0106aa7:	53                   	push   %ebx
f0106aa8:	83 ec 0c             	sub    $0xc,%esp
f0106aab:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106aae:	85 c0                	test   %eax,%eax
f0106ab0:	74 11                	je     f0106ac3 <readline+0x21>
		cprintf("%s", prompt);
f0106ab2:	83 ec 08             	sub    $0x8,%esp
f0106ab5:	50                   	push   %eax
f0106ab6:	68 1d 96 10 f0       	push   $0xf010961d
f0106abb:	e8 41 db ff ff       	call   f0104601 <cprintf>
f0106ac0:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106ac3:	83 ec 0c             	sub    $0xc,%esp
f0106ac6:	6a 00                	push   $0x0
f0106ac8:	e8 38 9d ff ff       	call   f0100805 <iscons>
f0106acd:	89 c7                	mov    %eax,%edi
f0106acf:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0106ad2:	be 00 00 00 00       	mov    $0x0,%esi
f0106ad7:	eb 57                	jmp    f0106b30 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0106ad9:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106ade:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106ae1:	75 08                	jne    f0106aeb <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0106ae3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106ae6:	5b                   	pop    %ebx
f0106ae7:	5e                   	pop    %esi
f0106ae8:	5f                   	pop    %edi
f0106ae9:	5d                   	pop    %ebp
f0106aea:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0106aeb:	83 ec 08             	sub    $0x8,%esp
f0106aee:	53                   	push   %ebx
f0106aef:	68 88 a6 10 f0       	push   $0xf010a688
f0106af4:	e8 08 db ff ff       	call   f0104601 <cprintf>
f0106af9:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0106afc:	b8 00 00 00 00       	mov    $0x0,%eax
f0106b01:	eb e0                	jmp    f0106ae3 <readline+0x41>
			if (echoing)
f0106b03:	85 ff                	test   %edi,%edi
f0106b05:	75 05                	jne    f0106b0c <readline+0x6a>
			i--;
f0106b07:	83 ee 01             	sub    $0x1,%esi
f0106b0a:	eb 24                	jmp    f0106b30 <readline+0x8e>
				cputchar('\b');
f0106b0c:	83 ec 0c             	sub    $0xc,%esp
f0106b0f:	6a 08                	push   $0x8
f0106b11:	e8 ce 9c ff ff       	call   f01007e4 <cputchar>
f0106b16:	83 c4 10             	add    $0x10,%esp
f0106b19:	eb ec                	jmp    f0106b07 <readline+0x65>
				cputchar(c);
f0106b1b:	83 ec 0c             	sub    $0xc,%esp
f0106b1e:	53                   	push   %ebx
f0106b1f:	e8 c0 9c ff ff       	call   f01007e4 <cputchar>
f0106b24:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0106b27:	88 9e 20 b9 5d f0    	mov    %bl,-0xfa246e0(%esi)
f0106b2d:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f0106b30:	e8 bf 9c ff ff       	call   f01007f4 <getchar>
f0106b35:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0106b37:	85 c0                	test   %eax,%eax
f0106b39:	78 9e                	js     f0106ad9 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0106b3b:	83 f8 08             	cmp    $0x8,%eax
f0106b3e:	0f 94 c2             	sete   %dl
f0106b41:	83 f8 7f             	cmp    $0x7f,%eax
f0106b44:	0f 94 c0             	sete   %al
f0106b47:	08 c2                	or     %al,%dl
f0106b49:	74 04                	je     f0106b4f <readline+0xad>
f0106b4b:	85 f6                	test   %esi,%esi
f0106b4d:	7f b4                	jg     f0106b03 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106b4f:	83 fb 1f             	cmp    $0x1f,%ebx
f0106b52:	7e 0e                	jle    f0106b62 <readline+0xc0>
f0106b54:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0106b5a:	7f 06                	jg     f0106b62 <readline+0xc0>
			if (echoing)
f0106b5c:	85 ff                	test   %edi,%edi
f0106b5e:	74 c7                	je     f0106b27 <readline+0x85>
f0106b60:	eb b9                	jmp    f0106b1b <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f0106b62:	83 fb 0a             	cmp    $0xa,%ebx
f0106b65:	74 05                	je     f0106b6c <readline+0xca>
f0106b67:	83 fb 0d             	cmp    $0xd,%ebx
f0106b6a:	75 c4                	jne    f0106b30 <readline+0x8e>
			if (echoing)
f0106b6c:	85 ff                	test   %edi,%edi
f0106b6e:	75 11                	jne    f0106b81 <readline+0xdf>
			buf[i] = 0;
f0106b70:	c6 86 20 b9 5d f0 00 	movb   $0x0,-0xfa246e0(%esi)
			return buf;
f0106b77:	b8 20 b9 5d f0       	mov    $0xf05db920,%eax
f0106b7c:	e9 62 ff ff ff       	jmp    f0106ae3 <readline+0x41>
				cputchar('\n');
f0106b81:	83 ec 0c             	sub    $0xc,%esp
f0106b84:	6a 0a                	push   $0xa
f0106b86:	e8 59 9c ff ff       	call   f01007e4 <cputchar>
f0106b8b:	83 c4 10             	add    $0x10,%esp
f0106b8e:	eb e0                	jmp    f0106b70 <readline+0xce>

f0106b90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106b90:	55                   	push   %ebp
f0106b91:	89 e5                	mov    %esp,%ebp
f0106b93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106b96:	b8 00 00 00 00       	mov    $0x0,%eax
f0106b9b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106b9f:	74 05                	je     f0106ba6 <strlen+0x16>
		n++;
f0106ba1:	83 c0 01             	add    $0x1,%eax
f0106ba4:	eb f5                	jmp    f0106b9b <strlen+0xb>
	return n;
}
f0106ba6:	5d                   	pop    %ebp
f0106ba7:	c3                   	ret    

f0106ba8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106ba8:	55                   	push   %ebp
f0106ba9:	89 e5                	mov    %esp,%ebp
f0106bab:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106bae:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106bb1:	ba 00 00 00 00       	mov    $0x0,%edx
f0106bb6:	39 c2                	cmp    %eax,%edx
f0106bb8:	74 0d                	je     f0106bc7 <strnlen+0x1f>
f0106bba:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106bbe:	74 05                	je     f0106bc5 <strnlen+0x1d>
		n++;
f0106bc0:	83 c2 01             	add    $0x1,%edx
f0106bc3:	eb f1                	jmp    f0106bb6 <strnlen+0xe>
f0106bc5:	89 d0                	mov    %edx,%eax
	return n;
}
f0106bc7:	5d                   	pop    %ebp
f0106bc8:	c3                   	ret    

f0106bc9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106bc9:	55                   	push   %ebp
f0106bca:	89 e5                	mov    %esp,%ebp
f0106bcc:	53                   	push   %ebx
f0106bcd:	8b 45 08             	mov    0x8(%ebp),%eax
f0106bd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106bd3:	ba 00 00 00 00       	mov    $0x0,%edx
f0106bd8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106bdc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0106bdf:	83 c2 01             	add    $0x1,%edx
f0106be2:	84 c9                	test   %cl,%cl
f0106be4:	75 f2                	jne    f0106bd8 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0106be6:	5b                   	pop    %ebx
f0106be7:	5d                   	pop    %ebp
f0106be8:	c3                   	ret    

f0106be9 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106be9:	55                   	push   %ebp
f0106bea:	89 e5                	mov    %esp,%ebp
f0106bec:	53                   	push   %ebx
f0106bed:	83 ec 10             	sub    $0x10,%esp
f0106bf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106bf3:	53                   	push   %ebx
f0106bf4:	e8 97 ff ff ff       	call   f0106b90 <strlen>
f0106bf9:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0106bfc:	ff 75 0c             	pushl  0xc(%ebp)
f0106bff:	01 d8                	add    %ebx,%eax
f0106c01:	50                   	push   %eax
f0106c02:	e8 c2 ff ff ff       	call   f0106bc9 <strcpy>
	return dst;
}
f0106c07:	89 d8                	mov    %ebx,%eax
f0106c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106c0c:	c9                   	leave  
f0106c0d:	c3                   	ret    

f0106c0e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106c0e:	55                   	push   %ebp
f0106c0f:	89 e5                	mov    %esp,%ebp
f0106c11:	56                   	push   %esi
f0106c12:	53                   	push   %ebx
f0106c13:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106c19:	89 c6                	mov    %eax,%esi
f0106c1b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106c1e:	89 c2                	mov    %eax,%edx
f0106c20:	39 f2                	cmp    %esi,%edx
f0106c22:	74 11                	je     f0106c35 <strncpy+0x27>
		*dst++ = *src;
f0106c24:	83 c2 01             	add    $0x1,%edx
f0106c27:	0f b6 19             	movzbl (%ecx),%ebx
f0106c2a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0106c2d:	80 fb 01             	cmp    $0x1,%bl
f0106c30:	83 d9 ff             	sbb    $0xffffffff,%ecx
f0106c33:	eb eb                	jmp    f0106c20 <strncpy+0x12>
	}
	return ret;
}
f0106c35:	5b                   	pop    %ebx
f0106c36:	5e                   	pop    %esi
f0106c37:	5d                   	pop    %ebp
f0106c38:	c3                   	ret    

f0106c39 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0106c39:	55                   	push   %ebp
f0106c3a:	89 e5                	mov    %esp,%ebp
f0106c3c:	56                   	push   %esi
f0106c3d:	53                   	push   %ebx
f0106c3e:	8b 75 08             	mov    0x8(%ebp),%esi
f0106c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106c44:	8b 55 10             	mov    0x10(%ebp),%edx
f0106c47:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0106c49:	85 d2                	test   %edx,%edx
f0106c4b:	74 21                	je     f0106c6e <strlcpy+0x35>
f0106c4d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0106c51:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0106c53:	39 c2                	cmp    %eax,%edx
f0106c55:	74 14                	je     f0106c6b <strlcpy+0x32>
f0106c57:	0f b6 19             	movzbl (%ecx),%ebx
f0106c5a:	84 db                	test   %bl,%bl
f0106c5c:	74 0b                	je     f0106c69 <strlcpy+0x30>
			*dst++ = *src++;
f0106c5e:	83 c1 01             	add    $0x1,%ecx
f0106c61:	83 c2 01             	add    $0x1,%edx
f0106c64:	88 5a ff             	mov    %bl,-0x1(%edx)
f0106c67:	eb ea                	jmp    f0106c53 <strlcpy+0x1a>
f0106c69:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0106c6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106c6e:	29 f0                	sub    %esi,%eax
}
f0106c70:	5b                   	pop    %ebx
f0106c71:	5e                   	pop    %esi
f0106c72:	5d                   	pop    %ebp
f0106c73:	c3                   	ret    

f0106c74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0106c74:	55                   	push   %ebp
f0106c75:	89 e5                	mov    %esp,%ebp
f0106c77:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106c7d:	0f b6 01             	movzbl (%ecx),%eax
f0106c80:	84 c0                	test   %al,%al
f0106c82:	74 0c                	je     f0106c90 <strcmp+0x1c>
f0106c84:	3a 02                	cmp    (%edx),%al
f0106c86:	75 08                	jne    f0106c90 <strcmp+0x1c>
		p++, q++;
f0106c88:	83 c1 01             	add    $0x1,%ecx
f0106c8b:	83 c2 01             	add    $0x1,%edx
f0106c8e:	eb ed                	jmp    f0106c7d <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106c90:	0f b6 c0             	movzbl %al,%eax
f0106c93:	0f b6 12             	movzbl (%edx),%edx
f0106c96:	29 d0                	sub    %edx,%eax
}
f0106c98:	5d                   	pop    %ebp
f0106c99:	c3                   	ret    

f0106c9a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106c9a:	55                   	push   %ebp
f0106c9b:	89 e5                	mov    %esp,%ebp
f0106c9d:	53                   	push   %ebx
f0106c9e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106ca4:	89 c3                	mov    %eax,%ebx
f0106ca6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106ca9:	eb 06                	jmp    f0106cb1 <strncmp+0x17>
		n--, p++, q++;
f0106cab:	83 c0 01             	add    $0x1,%eax
f0106cae:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0106cb1:	39 d8                	cmp    %ebx,%eax
f0106cb3:	74 16                	je     f0106ccb <strncmp+0x31>
f0106cb5:	0f b6 08             	movzbl (%eax),%ecx
f0106cb8:	84 c9                	test   %cl,%cl
f0106cba:	74 04                	je     f0106cc0 <strncmp+0x26>
f0106cbc:	3a 0a                	cmp    (%edx),%cl
f0106cbe:	74 eb                	je     f0106cab <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106cc0:	0f b6 00             	movzbl (%eax),%eax
f0106cc3:	0f b6 12             	movzbl (%edx),%edx
f0106cc6:	29 d0                	sub    %edx,%eax
}
f0106cc8:	5b                   	pop    %ebx
f0106cc9:	5d                   	pop    %ebp
f0106cca:	c3                   	ret    
		return 0;
f0106ccb:	b8 00 00 00 00       	mov    $0x0,%eax
f0106cd0:	eb f6                	jmp    f0106cc8 <strncmp+0x2e>

f0106cd2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106cd2:	55                   	push   %ebp
f0106cd3:	89 e5                	mov    %esp,%ebp
f0106cd5:	8b 45 08             	mov    0x8(%ebp),%eax
f0106cd8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106cdc:	0f b6 10             	movzbl (%eax),%edx
f0106cdf:	84 d2                	test   %dl,%dl
f0106ce1:	74 09                	je     f0106cec <strchr+0x1a>
		if (*s == c)
f0106ce3:	38 ca                	cmp    %cl,%dl
f0106ce5:	74 0a                	je     f0106cf1 <strchr+0x1f>
	for (; *s; s++)
f0106ce7:	83 c0 01             	add    $0x1,%eax
f0106cea:	eb f0                	jmp    f0106cdc <strchr+0xa>
			return (char *) s;
	return 0;
f0106cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106cf1:	5d                   	pop    %ebp
f0106cf2:	c3                   	ret    

f0106cf3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0106cf3:	55                   	push   %ebp
f0106cf4:	89 e5                	mov    %esp,%ebp
f0106cf6:	8b 45 08             	mov    0x8(%ebp),%eax
f0106cf9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106cfd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0106d00:	38 ca                	cmp    %cl,%dl
f0106d02:	74 09                	je     f0106d0d <strfind+0x1a>
f0106d04:	84 d2                	test   %dl,%dl
f0106d06:	74 05                	je     f0106d0d <strfind+0x1a>
	for (; *s; s++)
f0106d08:	83 c0 01             	add    $0x1,%eax
f0106d0b:	eb f0                	jmp    f0106cfd <strfind+0xa>
			break;
	return (char *) s;
}
f0106d0d:	5d                   	pop    %ebp
f0106d0e:	c3                   	ret    

f0106d0f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106d0f:	55                   	push   %ebp
f0106d10:	89 e5                	mov    %esp,%ebp
f0106d12:	57                   	push   %edi
f0106d13:	56                   	push   %esi
f0106d14:	53                   	push   %ebx
f0106d15:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106d18:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0106d1b:	85 c9                	test   %ecx,%ecx
f0106d1d:	74 31                	je     f0106d50 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0106d1f:	89 f8                	mov    %edi,%eax
f0106d21:	09 c8                	or     %ecx,%eax
f0106d23:	a8 03                	test   $0x3,%al
f0106d25:	75 23                	jne    f0106d4a <memset+0x3b>
		c &= 0xFF;
f0106d27:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0106d2b:	89 d3                	mov    %edx,%ebx
f0106d2d:	c1 e3 08             	shl    $0x8,%ebx
f0106d30:	89 d0                	mov    %edx,%eax
f0106d32:	c1 e0 18             	shl    $0x18,%eax
f0106d35:	89 d6                	mov    %edx,%esi
f0106d37:	c1 e6 10             	shl    $0x10,%esi
f0106d3a:	09 f0                	or     %esi,%eax
f0106d3c:	09 c2                	or     %eax,%edx
f0106d3e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0106d40:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0106d43:	89 d0                	mov    %edx,%eax
f0106d45:	fc                   	cld    
f0106d46:	f3 ab                	rep stos %eax,%es:(%edi)
f0106d48:	eb 06                	jmp    f0106d50 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0106d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106d4d:	fc                   	cld    
f0106d4e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0106d50:	89 f8                	mov    %edi,%eax
f0106d52:	5b                   	pop    %ebx
f0106d53:	5e                   	pop    %esi
f0106d54:	5f                   	pop    %edi
f0106d55:	5d                   	pop    %ebp
f0106d56:	c3                   	ret    

f0106d57 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106d57:	55                   	push   %ebp
f0106d58:	89 e5                	mov    %esp,%ebp
f0106d5a:	57                   	push   %edi
f0106d5b:	56                   	push   %esi
f0106d5c:	8b 45 08             	mov    0x8(%ebp),%eax
f0106d5f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106d62:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106d65:	39 c6                	cmp    %eax,%esi
f0106d67:	73 32                	jae    f0106d9b <memmove+0x44>
f0106d69:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106d6c:	39 c2                	cmp    %eax,%edx
f0106d6e:	76 2b                	jbe    f0106d9b <memmove+0x44>
		s += n;
		d += n;
f0106d70:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106d73:	89 fe                	mov    %edi,%esi
f0106d75:	09 ce                	or     %ecx,%esi
f0106d77:	09 d6                	or     %edx,%esi
f0106d79:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106d7f:	75 0e                	jne    f0106d8f <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106d81:	83 ef 04             	sub    $0x4,%edi
f0106d84:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106d87:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0106d8a:	fd                   	std    
f0106d8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106d8d:	eb 09                	jmp    f0106d98 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106d8f:	83 ef 01             	sub    $0x1,%edi
f0106d92:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0106d95:	fd                   	std    
f0106d96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106d98:	fc                   	cld    
f0106d99:	eb 1a                	jmp    f0106db5 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106d9b:	89 c2                	mov    %eax,%edx
f0106d9d:	09 ca                	or     %ecx,%edx
f0106d9f:	09 f2                	or     %esi,%edx
f0106da1:	f6 c2 03             	test   $0x3,%dl
f0106da4:	75 0a                	jne    f0106db0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106da6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0106da9:	89 c7                	mov    %eax,%edi
f0106dab:	fc                   	cld    
f0106dac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106dae:	eb 05                	jmp    f0106db5 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0106db0:	89 c7                	mov    %eax,%edi
f0106db2:	fc                   	cld    
f0106db3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106db5:	5e                   	pop    %esi
f0106db6:	5f                   	pop    %edi
f0106db7:	5d                   	pop    %ebp
f0106db8:	c3                   	ret    

f0106db9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106db9:	55                   	push   %ebp
f0106dba:	89 e5                	mov    %esp,%ebp
f0106dbc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106dbf:	ff 75 10             	pushl  0x10(%ebp)
f0106dc2:	ff 75 0c             	pushl  0xc(%ebp)
f0106dc5:	ff 75 08             	pushl  0x8(%ebp)
f0106dc8:	e8 8a ff ff ff       	call   f0106d57 <memmove>
}
f0106dcd:	c9                   	leave  
f0106dce:	c3                   	ret    

f0106dcf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106dcf:	55                   	push   %ebp
f0106dd0:	89 e5                	mov    %esp,%ebp
f0106dd2:	56                   	push   %esi
f0106dd3:	53                   	push   %ebx
f0106dd4:	8b 45 08             	mov    0x8(%ebp),%eax
f0106dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106dda:	89 c6                	mov    %eax,%esi
f0106ddc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106ddf:	39 f0                	cmp    %esi,%eax
f0106de1:	74 1c                	je     f0106dff <memcmp+0x30>
		if (*s1 != *s2)
f0106de3:	0f b6 08             	movzbl (%eax),%ecx
f0106de6:	0f b6 1a             	movzbl (%edx),%ebx
f0106de9:	38 d9                	cmp    %bl,%cl
f0106deb:	75 08                	jne    f0106df5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0106ded:	83 c0 01             	add    $0x1,%eax
f0106df0:	83 c2 01             	add    $0x1,%edx
f0106df3:	eb ea                	jmp    f0106ddf <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0106df5:	0f b6 c1             	movzbl %cl,%eax
f0106df8:	0f b6 db             	movzbl %bl,%ebx
f0106dfb:	29 d8                	sub    %ebx,%eax
f0106dfd:	eb 05                	jmp    f0106e04 <memcmp+0x35>
	}

	return 0;
f0106dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106e04:	5b                   	pop    %ebx
f0106e05:	5e                   	pop    %esi
f0106e06:	5d                   	pop    %ebp
f0106e07:	c3                   	ret    

f0106e08 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0106e08:	55                   	push   %ebp
f0106e09:	89 e5                	mov    %esp,%ebp
f0106e0b:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0106e11:	89 c2                	mov    %eax,%edx
f0106e13:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0106e16:	39 d0                	cmp    %edx,%eax
f0106e18:	73 09                	jae    f0106e23 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106e1a:	38 08                	cmp    %cl,(%eax)
f0106e1c:	74 05                	je     f0106e23 <memfind+0x1b>
	for (; s < ends; s++)
f0106e1e:	83 c0 01             	add    $0x1,%eax
f0106e21:	eb f3                	jmp    f0106e16 <memfind+0xe>
			break;
	return (void *) s;
}
f0106e23:	5d                   	pop    %ebp
f0106e24:	c3                   	ret    

f0106e25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106e25:	55                   	push   %ebp
f0106e26:	89 e5                	mov    %esp,%ebp
f0106e28:	57                   	push   %edi
f0106e29:	56                   	push   %esi
f0106e2a:	53                   	push   %ebx
f0106e2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106e2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106e31:	eb 03                	jmp    f0106e36 <strtol+0x11>
		s++;
f0106e33:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0106e36:	0f b6 01             	movzbl (%ecx),%eax
f0106e39:	3c 20                	cmp    $0x20,%al
f0106e3b:	74 f6                	je     f0106e33 <strtol+0xe>
f0106e3d:	3c 09                	cmp    $0x9,%al
f0106e3f:	74 f2                	je     f0106e33 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0106e41:	3c 2b                	cmp    $0x2b,%al
f0106e43:	74 2a                	je     f0106e6f <strtol+0x4a>
	int neg = 0;
f0106e45:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0106e4a:	3c 2d                	cmp    $0x2d,%al
f0106e4c:	74 2b                	je     f0106e79 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106e4e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0106e54:	75 0f                	jne    f0106e65 <strtol+0x40>
f0106e56:	80 39 30             	cmpb   $0x30,(%ecx)
f0106e59:	74 28                	je     f0106e83 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106e5b:	85 db                	test   %ebx,%ebx
f0106e5d:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106e62:	0f 44 d8             	cmove  %eax,%ebx
f0106e65:	b8 00 00 00 00       	mov    $0x0,%eax
f0106e6a:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106e6d:	eb 50                	jmp    f0106ebf <strtol+0x9a>
		s++;
f0106e6f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0106e72:	bf 00 00 00 00       	mov    $0x0,%edi
f0106e77:	eb d5                	jmp    f0106e4e <strtol+0x29>
		s++, neg = 1;
f0106e79:	83 c1 01             	add    $0x1,%ecx
f0106e7c:	bf 01 00 00 00       	mov    $0x1,%edi
f0106e81:	eb cb                	jmp    f0106e4e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106e83:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0106e87:	74 0e                	je     f0106e97 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0106e89:	85 db                	test   %ebx,%ebx
f0106e8b:	75 d8                	jne    f0106e65 <strtol+0x40>
		s++, base = 8;
f0106e8d:	83 c1 01             	add    $0x1,%ecx
f0106e90:	bb 08 00 00 00       	mov    $0x8,%ebx
f0106e95:	eb ce                	jmp    f0106e65 <strtol+0x40>
		s += 2, base = 16;
f0106e97:	83 c1 02             	add    $0x2,%ecx
f0106e9a:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106e9f:	eb c4                	jmp    f0106e65 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106ea1:	8d 72 9f             	lea    -0x61(%edx),%esi
f0106ea4:	89 f3                	mov    %esi,%ebx
f0106ea6:	80 fb 19             	cmp    $0x19,%bl
f0106ea9:	77 29                	ja     f0106ed4 <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106eab:	0f be d2             	movsbl %dl,%edx
f0106eae:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106eb1:	3b 55 10             	cmp    0x10(%ebp),%edx
f0106eb4:	7d 30                	jge    f0106ee6 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0106eb6:	83 c1 01             	add    $0x1,%ecx
f0106eb9:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106ebd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106ebf:	0f b6 11             	movzbl (%ecx),%edx
f0106ec2:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106ec5:	89 f3                	mov    %esi,%ebx
f0106ec7:	80 fb 09             	cmp    $0x9,%bl
f0106eca:	77 d5                	ja     f0106ea1 <strtol+0x7c>
			dig = *s - '0';
f0106ecc:	0f be d2             	movsbl %dl,%edx
f0106ecf:	83 ea 30             	sub    $0x30,%edx
f0106ed2:	eb dd                	jmp    f0106eb1 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f0106ed4:	8d 72 bf             	lea    -0x41(%edx),%esi
f0106ed7:	89 f3                	mov    %esi,%ebx
f0106ed9:	80 fb 19             	cmp    $0x19,%bl
f0106edc:	77 08                	ja     f0106ee6 <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106ede:	0f be d2             	movsbl %dl,%edx
f0106ee1:	83 ea 37             	sub    $0x37,%edx
f0106ee4:	eb cb                	jmp    f0106eb1 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f0106ee6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106eea:	74 05                	je     f0106ef1 <strtol+0xcc>
		*endptr = (char *) s;
f0106eec:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106eef:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0106ef1:	89 c2                	mov    %eax,%edx
f0106ef3:	f7 da                	neg    %edx
f0106ef5:	85 ff                	test   %edi,%edi
f0106ef7:	0f 45 c2             	cmovne %edx,%eax
}
f0106efa:	5b                   	pop    %ebx
f0106efb:	5e                   	pop    %esi
f0106efc:	5f                   	pop    %edi
f0106efd:	5d                   	pop    %ebp
f0106efe:	c3                   	ret    
f0106eff:	90                   	nop

f0106f00 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106f00:	fa                   	cli    

	xorw    %ax, %ax
f0106f01:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0106f03:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106f05:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106f07:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106f09:	0f 01 16             	lgdtl  (%esi)
f0106f0c:	7c 70                	jl     f0106f7e <gdtdesc+0x2>
	movl    %cr0, %eax
f0106f0e:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106f11:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106f15:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106f18:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0106f1e:	08 00                	or     %al,(%eax)

f0106f20 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0106f20:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106f24:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106f26:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106f28:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106f2a:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0106f2e:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106f30:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0106f32:	b8 00 c0 16 00       	mov    $0x16c000,%eax
	movl    %eax, %cr3
f0106f37:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f0106f3a:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f0106f3d:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f0106f40:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f0106f43:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106f46:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0106f4b:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106f4e:	8b 25 44 cd 5d f0    	mov    0xf05dcd44,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106f54:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106f59:	b8 13 02 10 f0       	mov    $0xf0100213,%eax
	call    *%eax
f0106f5e:	ff d0                	call   *%eax

f0106f60 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106f60:	eb fe                	jmp    f0106f60 <spin>
f0106f62:	66 90                	xchg   %ax,%ax

f0106f64 <gdt>:
	...
f0106f6c:	ff                   	(bad)  
f0106f6d:	ff 00                	incl   (%eax)
f0106f6f:	00 00                	add    %al,(%eax)
f0106f71:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0106f78:	00                   	.byte 0x0
f0106f79:	92                   	xchg   %eax,%edx
f0106f7a:	cf                   	iret   
	...

f0106f7c <gdtdesc>:
f0106f7c:	17                   	pop    %ss
f0106f7d:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0106f82 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106f82:	90                   	nop

f0106f83 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106f83:	55                   	push   %ebp
f0106f84:	89 e5                	mov    %esp,%ebp
f0106f86:	57                   	push   %edi
f0106f87:	56                   	push   %esi
f0106f88:	53                   	push   %ebx
f0106f89:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106f8c:	8b 0d 48 cd 5d f0    	mov    0xf05dcd48,%ecx
f0106f92:	89 c3                	mov    %eax,%ebx
f0106f94:	c1 eb 0c             	shr    $0xc,%ebx
f0106f97:	39 cb                	cmp    %ecx,%ebx
f0106f99:	73 1a                	jae    f0106fb5 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0106f9b:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106fa1:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106fa4:	89 f8                	mov    %edi,%eax
f0106fa6:	c1 e8 0c             	shr    $0xc,%eax
f0106fa9:	39 c8                	cmp    %ecx,%eax
f0106fab:	73 1a                	jae    f0106fc7 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106fad:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106fb3:	eb 27                	jmp    f0106fdc <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106fb5:	50                   	push   %eax
f0106fb6:	68 34 84 10 f0       	push   $0xf0108434
f0106fbb:	6a 58                	push   $0x58
f0106fbd:	68 25 a8 10 f0       	push   $0xf010a825
f0106fc2:	e8 82 90 ff ff       	call   f0100049 <_panic>
f0106fc7:	57                   	push   %edi
f0106fc8:	68 34 84 10 f0       	push   $0xf0108434
f0106fcd:	6a 58                	push   $0x58
f0106fcf:	68 25 a8 10 f0       	push   $0xf010a825
f0106fd4:	e8 70 90 ff ff       	call   f0100049 <_panic>
f0106fd9:	83 c3 10             	add    $0x10,%ebx
f0106fdc:	39 fb                	cmp    %edi,%ebx
f0106fde:	73 30                	jae    f0107010 <mpsearch1+0x8d>
f0106fe0:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106fe2:	83 ec 04             	sub    $0x4,%esp
f0106fe5:	6a 04                	push   $0x4
f0106fe7:	68 35 a8 10 f0       	push   $0xf010a835
f0106fec:	53                   	push   %ebx
f0106fed:	e8 dd fd ff ff       	call   f0106dcf <memcmp>
f0106ff2:	83 c4 10             	add    $0x10,%esp
f0106ff5:	85 c0                	test   %eax,%eax
f0106ff7:	75 e0                	jne    f0106fd9 <mpsearch1+0x56>
f0106ff9:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0106ffb:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0106ffe:	0f b6 0a             	movzbl (%edx),%ecx
f0107001:	01 c8                	add    %ecx,%eax
f0107003:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0107006:	39 f2                	cmp    %esi,%edx
f0107008:	75 f4                	jne    f0106ffe <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010700a:	84 c0                	test   %al,%al
f010700c:	75 cb                	jne    f0106fd9 <mpsearch1+0x56>
f010700e:	eb 05                	jmp    f0107015 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0107010:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0107015:	89 d8                	mov    %ebx,%eax
f0107017:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010701a:	5b                   	pop    %ebx
f010701b:	5e                   	pop    %esi
f010701c:	5f                   	pop    %edi
f010701d:	5d                   	pop    %ebp
f010701e:	c3                   	ret    

f010701f <mp_init>:
	return conf;
}

void
mp_init(void)
{
f010701f:	55                   	push   %ebp
f0107020:	89 e5                	mov    %esp,%ebp
f0107022:	57                   	push   %edi
f0107023:	56                   	push   %esi
f0107024:	53                   	push   %ebx
f0107025:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0107028:	c7 05 00 b0 16 f0 20 	movl   $0xf016b020,0xf016b000
f010702f:	b0 16 f0 
	if (PGNUM(pa) >= npages)
f0107032:	83 3d 48 cd 5d f0 00 	cmpl   $0x0,0xf05dcd48
f0107039:	0f 84 a3 00 00 00    	je     f01070e2 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f010703f:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0107046:	85 c0                	test   %eax,%eax
f0107048:	0f 84 aa 00 00 00    	je     f01070f8 <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f010704e:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0107051:	ba 00 04 00 00       	mov    $0x400,%edx
f0107056:	e8 28 ff ff ff       	call   f0106f83 <mpsearch1>
f010705b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010705e:	85 c0                	test   %eax,%eax
f0107060:	75 1a                	jne    f010707c <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0107062:	ba 00 00 01 00       	mov    $0x10000,%edx
f0107067:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f010706c:	e8 12 ff ff ff       	call   f0106f83 <mpsearch1>
f0107071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0107074:	85 c0                	test   %eax,%eax
f0107076:	0f 84 31 02 00 00    	je     f01072ad <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f010707c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010707f:	8b 58 04             	mov    0x4(%eax),%ebx
f0107082:	85 db                	test   %ebx,%ebx
f0107084:	0f 84 97 00 00 00    	je     f0107121 <mp_init+0x102>
f010708a:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f010708e:	0f 85 8d 00 00 00    	jne    f0107121 <mp_init+0x102>
f0107094:	89 d8                	mov    %ebx,%eax
f0107096:	c1 e8 0c             	shr    $0xc,%eax
f0107099:	3b 05 48 cd 5d f0    	cmp    0xf05dcd48,%eax
f010709f:	0f 83 91 00 00 00    	jae    f0107136 <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f01070a5:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f01070ab:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f01070ad:	83 ec 04             	sub    $0x4,%esp
f01070b0:	6a 04                	push   $0x4
f01070b2:	68 3a a8 10 f0       	push   $0xf010a83a
f01070b7:	53                   	push   %ebx
f01070b8:	e8 12 fd ff ff       	call   f0106dcf <memcmp>
f01070bd:	83 c4 10             	add    $0x10,%esp
f01070c0:	85 c0                	test   %eax,%eax
f01070c2:	0f 85 83 00 00 00    	jne    f010714b <mp_init+0x12c>
f01070c8:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f01070cc:	01 df                	add    %ebx,%edi
	sum = 0;
f01070ce:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f01070d0:	39 fb                	cmp    %edi,%ebx
f01070d2:	0f 84 88 00 00 00    	je     f0107160 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f01070d8:	0f b6 0b             	movzbl (%ebx),%ecx
f01070db:	01 ca                	add    %ecx,%edx
f01070dd:	83 c3 01             	add    $0x1,%ebx
f01070e0:	eb ee                	jmp    f01070d0 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01070e2:	68 00 04 00 00       	push   $0x400
f01070e7:	68 34 84 10 f0       	push   $0xf0108434
f01070ec:	6a 70                	push   $0x70
f01070ee:	68 25 a8 10 f0       	push   $0xf010a825
f01070f3:	e8 51 8f ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f01070f8:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01070ff:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0107102:	2d 00 04 00 00       	sub    $0x400,%eax
f0107107:	ba 00 04 00 00       	mov    $0x400,%edx
f010710c:	e8 72 fe ff ff       	call   f0106f83 <mpsearch1>
f0107111:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0107114:	85 c0                	test   %eax,%eax
f0107116:	0f 85 60 ff ff ff    	jne    f010707c <mp_init+0x5d>
f010711c:	e9 41 ff ff ff       	jmp    f0107062 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f0107121:	83 ec 0c             	sub    $0xc,%esp
f0107124:	68 98 a6 10 f0       	push   $0xf010a698
f0107129:	e8 d3 d4 ff ff       	call   f0104601 <cprintf>
f010712e:	83 c4 10             	add    $0x10,%esp
f0107131:	e9 77 01 00 00       	jmp    f01072ad <mp_init+0x28e>
f0107136:	53                   	push   %ebx
f0107137:	68 34 84 10 f0       	push   $0xf0108434
f010713c:	68 91 00 00 00       	push   $0x91
f0107141:	68 25 a8 10 f0       	push   $0xf010a825
f0107146:	e8 fe 8e ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f010714b:	83 ec 0c             	sub    $0xc,%esp
f010714e:	68 c8 a6 10 f0       	push   $0xf010a6c8
f0107153:	e8 a9 d4 ff ff       	call   f0104601 <cprintf>
f0107158:	83 c4 10             	add    $0x10,%esp
f010715b:	e9 4d 01 00 00       	jmp    f01072ad <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0107160:	84 d2                	test   %dl,%dl
f0107162:	75 16                	jne    f010717a <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0107164:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0107168:	80 fa 01             	cmp    $0x1,%dl
f010716b:	74 05                	je     f0107172 <mp_init+0x153>
f010716d:	80 fa 04             	cmp    $0x4,%dl
f0107170:	75 1d                	jne    f010718f <mp_init+0x170>
f0107172:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0107176:	01 d9                	add    %ebx,%ecx
f0107178:	eb 36                	jmp    f01071b0 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f010717a:	83 ec 0c             	sub    $0xc,%esp
f010717d:	68 fc a6 10 f0       	push   $0xf010a6fc
f0107182:	e8 7a d4 ff ff       	call   f0104601 <cprintf>
f0107187:	83 c4 10             	add    $0x10,%esp
f010718a:	e9 1e 01 00 00       	jmp    f01072ad <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f010718f:	83 ec 08             	sub    $0x8,%esp
f0107192:	0f b6 d2             	movzbl %dl,%edx
f0107195:	52                   	push   %edx
f0107196:	68 20 a7 10 f0       	push   $0xf010a720
f010719b:	e8 61 d4 ff ff       	call   f0104601 <cprintf>
f01071a0:	83 c4 10             	add    $0x10,%esp
f01071a3:	e9 05 01 00 00       	jmp    f01072ad <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f01071a8:	0f b6 13             	movzbl (%ebx),%edx
f01071ab:	01 d0                	add    %edx,%eax
f01071ad:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f01071b0:	39 d9                	cmp    %ebx,%ecx
f01071b2:	75 f4                	jne    f01071a8 <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f01071b4:	02 46 2a             	add    0x2a(%esi),%al
f01071b7:	75 1c                	jne    f01071d5 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f01071b9:	c7 05 54 cd 5d f0 01 	movl   $0x1,0xf05dcd54
f01071c0:	00 00 00 
	lapicaddr = conf->lapicaddr;
f01071c3:	8b 46 24             	mov    0x24(%esi),%eax
f01071c6:	a3 5c cd 5d f0       	mov    %eax,0xf05dcd5c

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01071cb:	8d 7e 2c             	lea    0x2c(%esi),%edi
f01071ce:	bb 00 00 00 00       	mov    $0x0,%ebx
f01071d3:	eb 4d                	jmp    f0107222 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f01071d5:	83 ec 0c             	sub    $0xc,%esp
f01071d8:	68 40 a7 10 f0       	push   $0xf010a740
f01071dd:	e8 1f d4 ff ff       	call   f0104601 <cprintf>
f01071e2:	83 c4 10             	add    $0x10,%esp
f01071e5:	e9 c3 00 00 00       	jmp    f01072ad <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f01071ea:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f01071ee:	74 11                	je     f0107201 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f01071f0:	6b 05 58 cd 5d f0 74 	imul   $0x74,0xf05dcd58,%eax
f01071f7:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01071fc:	a3 00 b0 16 f0       	mov    %eax,0xf016b000
			if (ncpu < NCPU) {
f0107201:	a1 58 cd 5d f0       	mov    0xf05dcd58,%eax
f0107206:	83 f8 07             	cmp    $0x7,%eax
f0107209:	7f 2f                	jg     f010723a <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f010720b:	6b d0 74             	imul   $0x74,%eax,%edx
f010720e:	88 82 20 b0 16 f0    	mov    %al,-0xfe94fe0(%edx)
				ncpu++;
f0107214:	83 c0 01             	add    $0x1,%eax
f0107217:	a3 58 cd 5d f0       	mov    %eax,0xf05dcd58
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f010721c:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f010721f:	83 c3 01             	add    $0x1,%ebx
f0107222:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0107226:	39 d8                	cmp    %ebx,%eax
f0107228:	76 4b                	jbe    f0107275 <mp_init+0x256>
		switch (*p) {
f010722a:	0f b6 07             	movzbl (%edi),%eax
f010722d:	84 c0                	test   %al,%al
f010722f:	74 b9                	je     f01071ea <mp_init+0x1cb>
f0107231:	3c 04                	cmp    $0x4,%al
f0107233:	77 1c                	ja     f0107251 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0107235:	83 c7 08             	add    $0x8,%edi
			continue;
f0107238:	eb e5                	jmp    f010721f <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f010723a:	83 ec 08             	sub    $0x8,%esp
f010723d:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0107241:	50                   	push   %eax
f0107242:	68 70 a7 10 f0       	push   $0xf010a770
f0107247:	e8 b5 d3 ff ff       	call   f0104601 <cprintf>
f010724c:	83 c4 10             	add    $0x10,%esp
f010724f:	eb cb                	jmp    f010721c <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0107251:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0107254:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0107257:	50                   	push   %eax
f0107258:	68 98 a7 10 f0       	push   $0xf010a798
f010725d:	e8 9f d3 ff ff       	call   f0104601 <cprintf>
			ismp = 0;
f0107262:	c7 05 54 cd 5d f0 00 	movl   $0x0,0xf05dcd54
f0107269:	00 00 00 
			i = conf->entry;
f010726c:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0107270:	83 c4 10             	add    $0x10,%esp
f0107273:	eb aa                	jmp    f010721f <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0107275:	a1 00 b0 16 f0       	mov    0xf016b000,%eax
f010727a:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0107281:	83 3d 54 cd 5d f0 00 	cmpl   $0x0,0xf05dcd54
f0107288:	74 2b                	je     f01072b5 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f010728a:	83 ec 04             	sub    $0x4,%esp
f010728d:	ff 35 58 cd 5d f0    	pushl  0xf05dcd58
f0107293:	0f b6 00             	movzbl (%eax),%eax
f0107296:	50                   	push   %eax
f0107297:	68 3f a8 10 f0       	push   $0xf010a83f
f010729c:	e8 60 d3 ff ff       	call   f0104601 <cprintf>

	if (mp->imcrp) {
f01072a1:	83 c4 10             	add    $0x10,%esp
f01072a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01072a7:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f01072ab:	75 2e                	jne    f01072db <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f01072ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01072b0:	5b                   	pop    %ebx
f01072b1:	5e                   	pop    %esi
f01072b2:	5f                   	pop    %edi
f01072b3:	5d                   	pop    %ebp
f01072b4:	c3                   	ret    
		ncpu = 1;
f01072b5:	c7 05 58 cd 5d f0 01 	movl   $0x1,0xf05dcd58
f01072bc:	00 00 00 
		lapicaddr = 0;
f01072bf:	c7 05 5c cd 5d f0 00 	movl   $0x0,0xf05dcd5c
f01072c6:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f01072c9:	83 ec 0c             	sub    $0xc,%esp
f01072cc:	68 b8 a7 10 f0       	push   $0xf010a7b8
f01072d1:	e8 2b d3 ff ff       	call   f0104601 <cprintf>
		return;
f01072d6:	83 c4 10             	add    $0x10,%esp
f01072d9:	eb d2                	jmp    f01072ad <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f01072db:	83 ec 0c             	sub    $0xc,%esp
f01072de:	68 e4 a7 10 f0       	push   $0xf010a7e4
f01072e3:	e8 19 d3 ff ff       	call   f0104601 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01072e8:	b8 70 00 00 00       	mov    $0x70,%eax
f01072ed:	ba 22 00 00 00       	mov    $0x22,%edx
f01072f2:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01072f3:	ba 23 00 00 00       	mov    $0x23,%edx
f01072f8:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f01072f9:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01072fc:	ee                   	out    %al,(%dx)
f01072fd:	83 c4 10             	add    $0x10,%esp
f0107300:	eb ab                	jmp    f01072ad <mp_init+0x28e>

f0107302 <lapicw>:
volatile uint32_t *lapic __user_mapped_data;	//lab7 bug mapped data

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0107302:	8b 0d c0 b3 16 f0    	mov    0xf016b3c0,%ecx
f0107308:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f010730b:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f010730d:	a1 c0 b3 16 f0       	mov    0xf016b3c0,%eax
f0107312:	8b 40 20             	mov    0x20(%eax),%eax
}
f0107315:	c3                   	ret    

f0107316 <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f0107316:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f010731c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f0107321:	85 d2                	test   %edx,%edx
f0107323:	74 06                	je     f010732b <cpunum+0x15>
		return lapic[ID] >> 24;
f0107325:	8b 42 20             	mov    0x20(%edx),%eax
f0107328:	c1 e8 18             	shr    $0x18,%eax
}
f010732b:	c3                   	ret    

f010732c <lapic_init>:
	if (!lapicaddr)
f010732c:	a1 5c cd 5d f0       	mov    0xf05dcd5c,%eax
f0107331:	85 c0                	test   %eax,%eax
f0107333:	75 01                	jne    f0107336 <lapic_init+0xa>
f0107335:	c3                   	ret    
{
f0107336:	55                   	push   %ebp
f0107337:	89 e5                	mov    %esp,%ebp
f0107339:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f010733c:	68 00 10 00 00       	push   $0x1000
f0107341:	50                   	push   %eax
f0107342:	e8 c6 a3 ff ff       	call   f010170d <mmio_map_region>
f0107347:	a3 c0 b3 16 f0       	mov    %eax,0xf016b3c0
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f010734c:	ba 27 01 00 00       	mov    $0x127,%edx
f0107351:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0107356:	e8 a7 ff ff ff       	call   f0107302 <lapicw>
	lapicw(TDCR, X1);
f010735b:	ba 0b 00 00 00       	mov    $0xb,%edx
f0107360:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0107365:	e8 98 ff ff ff       	call   f0107302 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f010736a:	ba 20 00 02 00       	mov    $0x20020,%edx
f010736f:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0107374:	e8 89 ff ff ff       	call   f0107302 <lapicw>
	lapicw(TICR, 10000000); 
f0107379:	ba 80 96 98 00       	mov    $0x989680,%edx
f010737e:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0107383:	e8 7a ff ff ff       	call   f0107302 <lapicw>
	if (thiscpu != bootcpu)
f0107388:	e8 89 ff ff ff       	call   f0107316 <cpunum>
f010738d:	6b c0 74             	imul   $0x74,%eax,%eax
f0107390:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f0107395:	83 c4 10             	add    $0x10,%esp
f0107398:	39 05 00 b0 16 f0    	cmp    %eax,0xf016b000
f010739e:	74 0f                	je     f01073af <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f01073a0:	ba 00 00 01 00       	mov    $0x10000,%edx
f01073a5:	b8 d4 00 00 00       	mov    $0xd4,%eax
f01073aa:	e8 53 ff ff ff       	call   f0107302 <lapicw>
	lapicw(LINT1, MASKED);
f01073af:	ba 00 00 01 00       	mov    $0x10000,%edx
f01073b4:	b8 d8 00 00 00       	mov    $0xd8,%eax
f01073b9:	e8 44 ff ff ff       	call   f0107302 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f01073be:	a1 c0 b3 16 f0       	mov    0xf016b3c0,%eax
f01073c3:	8b 40 30             	mov    0x30(%eax),%eax
f01073c6:	c1 e8 10             	shr    $0x10,%eax
f01073c9:	a8 fc                	test   $0xfc,%al
f01073cb:	75 7c                	jne    f0107449 <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f01073cd:	ba 33 00 00 00       	mov    $0x33,%edx
f01073d2:	b8 dc 00 00 00       	mov    $0xdc,%eax
f01073d7:	e8 26 ff ff ff       	call   f0107302 <lapicw>
	lapicw(ESR, 0);
f01073dc:	ba 00 00 00 00       	mov    $0x0,%edx
f01073e1:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01073e6:	e8 17 ff ff ff       	call   f0107302 <lapicw>
	lapicw(ESR, 0);
f01073eb:	ba 00 00 00 00       	mov    $0x0,%edx
f01073f0:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01073f5:	e8 08 ff ff ff       	call   f0107302 <lapicw>
	lapicw(EOI, 0);
f01073fa:	ba 00 00 00 00       	mov    $0x0,%edx
f01073ff:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0107404:	e8 f9 fe ff ff       	call   f0107302 <lapicw>
	lapicw(ICRHI, 0);
f0107409:	ba 00 00 00 00       	mov    $0x0,%edx
f010740e:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107413:	e8 ea fe ff ff       	call   f0107302 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0107418:	ba 00 85 08 00       	mov    $0x88500,%edx
f010741d:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107422:	e8 db fe ff ff       	call   f0107302 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0107427:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
f010742d:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0107433:	f6 c4 10             	test   $0x10,%ah
f0107436:	75 f5                	jne    f010742d <lapic_init+0x101>
	lapicw(TPR, 0);
f0107438:	ba 00 00 00 00       	mov    $0x0,%edx
f010743d:	b8 20 00 00 00       	mov    $0x20,%eax
f0107442:	e8 bb fe ff ff       	call   f0107302 <lapicw>
}
f0107447:	c9                   	leave  
f0107448:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0107449:	ba 00 00 01 00       	mov    $0x10000,%edx
f010744e:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0107453:	e8 aa fe ff ff       	call   f0107302 <lapicw>
f0107458:	e9 70 ff ff ff       	jmp    f01073cd <lapic_init+0xa1>

f010745d <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f010745d:	83 3d c0 b3 16 f0 00 	cmpl   $0x0,0xf016b3c0
f0107464:	74 17                	je     f010747d <lapic_eoi+0x20>
{
f0107466:	55                   	push   %ebp
f0107467:	89 e5                	mov    %esp,%ebp
f0107469:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f010746c:	ba 00 00 00 00       	mov    $0x0,%edx
f0107471:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0107476:	e8 87 fe ff ff       	call   f0107302 <lapicw>
}
f010747b:	c9                   	leave  
f010747c:	c3                   	ret    
f010747d:	c3                   	ret    

f010747e <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f010747e:	55                   	push   %ebp
f010747f:	89 e5                	mov    %esp,%ebp
f0107481:	56                   	push   %esi
f0107482:	53                   	push   %ebx
f0107483:	8b 75 08             	mov    0x8(%ebp),%esi
f0107486:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0107489:	b8 0f 00 00 00       	mov    $0xf,%eax
f010748e:	ba 70 00 00 00       	mov    $0x70,%edx
f0107493:	ee                   	out    %al,(%dx)
f0107494:	b8 0a 00 00 00       	mov    $0xa,%eax
f0107499:	ba 71 00 00 00       	mov    $0x71,%edx
f010749e:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f010749f:	83 3d 48 cd 5d f0 00 	cmpl   $0x0,0xf05dcd48
f01074a6:	74 7e                	je     f0107526 <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f01074a8:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f01074af:	00 00 
	wrv[1] = addr >> 4;
f01074b1:	89 d8                	mov    %ebx,%eax
f01074b3:	c1 e8 04             	shr    $0x4,%eax
f01074b6:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f01074bc:	c1 e6 18             	shl    $0x18,%esi
f01074bf:	89 f2                	mov    %esi,%edx
f01074c1:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01074c6:	e8 37 fe ff ff       	call   f0107302 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f01074cb:	ba 00 c5 00 00       	mov    $0xc500,%edx
f01074d0:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01074d5:	e8 28 fe ff ff       	call   f0107302 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f01074da:	ba 00 85 00 00       	mov    $0x8500,%edx
f01074df:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01074e4:	e8 19 fe ff ff       	call   f0107302 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01074e9:	c1 eb 0c             	shr    $0xc,%ebx
f01074ec:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f01074ef:	89 f2                	mov    %esi,%edx
f01074f1:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01074f6:	e8 07 fe ff ff       	call   f0107302 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01074fb:	89 da                	mov    %ebx,%edx
f01074fd:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107502:	e8 fb fd ff ff       	call   f0107302 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0107507:	89 f2                	mov    %esi,%edx
f0107509:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010750e:	e8 ef fd ff ff       	call   f0107302 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107513:	89 da                	mov    %ebx,%edx
f0107515:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010751a:	e8 e3 fd ff ff       	call   f0107302 <lapicw>
		microdelay(200);
	}
}
f010751f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107522:	5b                   	pop    %ebx
f0107523:	5e                   	pop    %esi
f0107524:	5d                   	pop    %ebp
f0107525:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107526:	68 67 04 00 00       	push   $0x467
f010752b:	68 34 84 10 f0       	push   $0xf0108434
f0107530:	68 9d 00 00 00       	push   $0x9d
f0107535:	68 5c a8 10 f0       	push   $0xf010a85c
f010753a:	e8 0a 8b ff ff       	call   f0100049 <_panic>

f010753f <lapic_ipi>:

void
lapic_ipi(int vector)
{
f010753f:	55                   	push   %ebp
f0107540:	89 e5                	mov    %esp,%ebp
f0107542:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0107545:	8b 55 08             	mov    0x8(%ebp),%edx
f0107548:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010754e:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107553:	e8 aa fd ff ff       	call   f0107302 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0107558:	8b 15 c0 b3 16 f0    	mov    0xf016b3c0,%edx
f010755e:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0107564:	f6 c4 10             	test   $0x10,%ah
f0107567:	75 f5                	jne    f010755e <lapic_ipi+0x1f>
		;
}
f0107569:	c9                   	leave  
f010756a:	c3                   	ret    

f010756b <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f010756b:	55                   	push   %ebp
f010756c:	89 e5                	mov    %esp,%ebp
f010756e:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0107571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0107577:	8b 55 0c             	mov    0xc(%ebp),%edx
f010757a:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010757d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0107584:	5d                   	pop    %ebp
f0107585:	c3                   	ret    

f0107586 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0107586:	55                   	push   %ebp
f0107587:	89 e5                	mov    %esp,%ebp
f0107589:	56                   	push   %esi
f010758a:	53                   	push   %ebx
f010758b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010758e:	83 3b 00             	cmpl   $0x0,(%ebx)
f0107591:	75 12                	jne    f01075a5 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0107593:	ba 01 00 00 00       	mov    $0x1,%edx
f0107598:	89 d0                	mov    %edx,%eax
f010759a:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f010759d:	85 c0                	test   %eax,%eax
f010759f:	74 36                	je     f01075d7 <spin_lock+0x51>
		asm volatile ("pause");
f01075a1:	f3 90                	pause  
f01075a3:	eb f3                	jmp    f0107598 <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f01075a5:	8b 73 08             	mov    0x8(%ebx),%esi
f01075a8:	e8 69 fd ff ff       	call   f0107316 <cpunum>
f01075ad:	6b c0 74             	imul   $0x74,%eax,%eax
f01075b0:	05 20 b0 16 f0       	add    $0xf016b020,%eax
	if (holding(lk))
f01075b5:	39 c6                	cmp    %eax,%esi
f01075b7:	75 da                	jne    f0107593 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f01075b9:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01075bc:	e8 55 fd ff ff       	call   f0107316 <cpunum>
f01075c1:	83 ec 0c             	sub    $0xc,%esp
f01075c4:	53                   	push   %ebx
f01075c5:	50                   	push   %eax
f01075c6:	68 6c a8 10 f0       	push   $0xf010a86c
f01075cb:	6a 41                	push   $0x41
f01075cd:	68 ce a8 10 f0       	push   $0xf010a8ce
f01075d2:	e8 72 8a ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01075d7:	e8 3a fd ff ff       	call   f0107316 <cpunum>
f01075dc:	6b c0 74             	imul   $0x74,%eax,%eax
f01075df:	05 20 b0 16 f0       	add    $0xf016b020,%eax
f01075e4:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01075e7:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01075e9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01075ee:	83 f8 09             	cmp    $0x9,%eax
f01075f1:	7f 16                	jg     f0107609 <spin_lock+0x83>
f01075f3:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01075f9:	76 0e                	jbe    f0107609 <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f01075fb:	8b 4a 04             	mov    0x4(%edx),%ecx
f01075fe:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0107602:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0107604:	83 c0 01             	add    $0x1,%eax
f0107607:	eb e5                	jmp    f01075ee <spin_lock+0x68>
	for (; i < 10; i++)
f0107609:	83 f8 09             	cmp    $0x9,%eax
f010760c:	7f 0d                	jg     f010761b <spin_lock+0x95>
		pcs[i] = 0;
f010760e:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0107615:	00 
	for (; i < 10; i++)
f0107616:	83 c0 01             	add    $0x1,%eax
f0107619:	eb ee                	jmp    f0107609 <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f010761b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010761e:	5b                   	pop    %ebx
f010761f:	5e                   	pop    %esi
f0107620:	5d                   	pop    %ebp
f0107621:	c3                   	ret    

f0107622 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0107622:	55                   	push   %ebp
f0107623:	89 e5                	mov    %esp,%ebp
f0107625:	57                   	push   %edi
f0107626:	56                   	push   %esi
f0107627:	53                   	push   %ebx
f0107628:	83 ec 4c             	sub    $0x4c,%esp
f010762b:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f010762e:	83 3e 00             	cmpl   $0x0,(%esi)
f0107631:	75 35                	jne    f0107668 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0107633:	83 ec 04             	sub    $0x4,%esp
f0107636:	6a 28                	push   $0x28
f0107638:	8d 46 0c             	lea    0xc(%esi),%eax
f010763b:	50                   	push   %eax
f010763c:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f010763f:	53                   	push   %ebx
f0107640:	e8 12 f7 ff ff       	call   f0106d57 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0107645:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0107648:	0f b6 38             	movzbl (%eax),%edi
f010764b:	8b 76 04             	mov    0x4(%esi),%esi
f010764e:	e8 c3 fc ff ff       	call   f0107316 <cpunum>
f0107653:	57                   	push   %edi
f0107654:	56                   	push   %esi
f0107655:	50                   	push   %eax
f0107656:	68 98 a8 10 f0       	push   $0xf010a898
f010765b:	e8 a1 cf ff ff       	call   f0104601 <cprintf>
f0107660:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0107663:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0107666:	eb 4e                	jmp    f01076b6 <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0107668:	8b 5e 08             	mov    0x8(%esi),%ebx
f010766b:	e8 a6 fc ff ff       	call   f0107316 <cpunum>
f0107670:	6b c0 74             	imul   $0x74,%eax,%eax
f0107673:	05 20 b0 16 f0       	add    $0xf016b020,%eax
	if (!holding(lk)) {
f0107678:	39 c3                	cmp    %eax,%ebx
f010767a:	75 b7                	jne    f0107633 <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f010767c:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0107683:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f010768a:	b8 00 00 00 00       	mov    $0x0,%eax
f010768f:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0107692:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107695:	5b                   	pop    %ebx
f0107696:	5e                   	pop    %esi
f0107697:	5f                   	pop    %edi
f0107698:	5d                   	pop    %ebp
f0107699:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f010769a:	83 ec 08             	sub    $0x8,%esp
f010769d:	ff 36                	pushl  (%esi)
f010769f:	68 f5 a8 10 f0       	push   $0xf010a8f5
f01076a4:	e8 58 cf ff ff       	call   f0104601 <cprintf>
f01076a9:	83 c4 10             	add    $0x10,%esp
f01076ac:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f01076af:	8d 45 e8             	lea    -0x18(%ebp),%eax
f01076b2:	39 c3                	cmp    %eax,%ebx
f01076b4:	74 40                	je     f01076f6 <spin_unlock+0xd4>
f01076b6:	89 de                	mov    %ebx,%esi
f01076b8:	8b 03                	mov    (%ebx),%eax
f01076ba:	85 c0                	test   %eax,%eax
f01076bc:	74 38                	je     f01076f6 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01076be:	83 ec 08             	sub    $0x8,%esp
f01076c1:	57                   	push   %edi
f01076c2:	50                   	push   %eax
f01076c3:	e8 e0 e9 ff ff       	call   f01060a8 <debuginfo_eip>
f01076c8:	83 c4 10             	add    $0x10,%esp
f01076cb:	85 c0                	test   %eax,%eax
f01076cd:	78 cb                	js     f010769a <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f01076cf:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01076d1:	83 ec 04             	sub    $0x4,%esp
f01076d4:	89 c2                	mov    %eax,%edx
f01076d6:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01076d9:	52                   	push   %edx
f01076da:	ff 75 b0             	pushl  -0x50(%ebp)
f01076dd:	ff 75 b4             	pushl  -0x4c(%ebp)
f01076e0:	ff 75 ac             	pushl  -0x54(%ebp)
f01076e3:	ff 75 a8             	pushl  -0x58(%ebp)
f01076e6:	50                   	push   %eax
f01076e7:	68 de a8 10 f0       	push   $0xf010a8de
f01076ec:	e8 10 cf ff ff       	call   f0104601 <cprintf>
f01076f1:	83 c4 20             	add    $0x20,%esp
f01076f4:	eb b6                	jmp    f01076ac <spin_unlock+0x8a>
		panic("spin_unlock");
f01076f6:	83 ec 04             	sub    $0x4,%esp
f01076f9:	68 fd a8 10 f0       	push   $0xf010a8fd
f01076fe:	6a 67                	push   $0x67
f0107700:	68 ce a8 10 f0       	push   $0xf010a8ce
f0107705:	e8 3f 89 ff ff       	call   f0100049 <_panic>

f010770a <read_eeprom>:
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_buffer[N_TXDESC][TX_PKT_SIZE];
uint64_t mac_address = 0;

uint16_t read_eeprom(uint32_t addr)
{
f010770a:	55                   	push   %ebp
f010770b:	89 e5                	mov    %esp,%ebp
    base->EERD = E1000_EEPROM_RD_START | addr;
f010770d:	8b 15 28 bd 5d f0    	mov    0xf05dbd28,%edx
f0107713:	8b 45 08             	mov    0x8(%ebp),%eax
f0107716:	83 c8 01             	or     $0x1,%eax
f0107719:	89 42 14             	mov    %eax,0x14(%edx)
	while ((base->EERD & E1000_EEPROM_RD_START) == 1); // Continually poll until we have a response
f010771c:	8b 42 14             	mov    0x14(%edx),%eax
f010771f:	a8 01                	test   $0x1,%al
f0107721:	75 f9                	jne    f010771c <read_eeprom+0x12>
	return base->EERD >> 16;
f0107723:	8b 42 14             	mov    0x14(%edx),%eax
f0107726:	c1 e8 10             	shr    $0x10,%eax
}
f0107729:	5d                   	pop    %ebp
f010772a:	c3                   	ret    

f010772b <read_eeprom_mac_addr>:

uint64_t read_eeprom_mac_addr(){
f010772b:	55                   	push   %ebp
f010772c:	89 e5                	mov    %esp,%ebp
f010772e:	57                   	push   %edi
f010772f:	56                   	push   %esi
f0107730:	53                   	push   %ebx
f0107731:	83 ec 0c             	sub    $0xc,%esp
	if (mac_address > 0)
f0107734:	a1 20 bd 5d f0       	mov    0xf05dbd20,%eax
f0107739:	8b 15 24 bd 5d f0    	mov    0xf05dbd24,%edx
f010773f:	89 d7                	mov    %edx,%edi
f0107741:	09 c7                	or     %eax,%edi
f0107743:	74 08                	je     f010774d <read_eeprom_mac_addr+0x22>
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
    uint64_t word2 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD2);
    uint64_t word3 = (uint64_t)0x8000;
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
    return mac_address;
}
f0107745:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107748:	5b                   	pop    %ebx
f0107749:	5e                   	pop    %esi
f010774a:	5f                   	pop    %edi
f010774b:	5d                   	pop    %ebp
f010774c:	c3                   	ret    
    uint64_t word0 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD0);
f010774d:	83 ec 0c             	sub    $0xc,%esp
f0107750:	6a 00                	push   $0x0
f0107752:	e8 b3 ff ff ff       	call   f010770a <read_eeprom>
f0107757:	89 c3                	mov    %eax,%ebx
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
f0107759:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
f0107760:	e8 a5 ff ff ff       	call   f010770a <read_eeprom>
f0107765:	89 c6                	mov    %eax,%esi
    uint64_t word2 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD2);
f0107767:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
f010776e:	e8 97 ff ff ff       	call   f010770a <read_eeprom>
f0107773:	0f b7 d0             	movzwl %ax,%edx
    uint64_t word1 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD1);
f0107776:	0f b7 f6             	movzwl %si,%esi
f0107779:	bf 00 00 00 00       	mov    $0x0,%edi
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
f010777e:	0f a4 f7 10          	shld   $0x10,%esi,%edi
f0107782:	c1 e6 10             	shl    $0x10,%esi
f0107785:	09 fa                	or     %edi,%edx
    uint64_t word0 = read_eeprom(E1000_EEPROM_RD_MAC_ADDR_WD0);
f0107787:	0f b7 db             	movzwl %bx,%ebx
    mac_address = word3<<48 | word2<<32 | word1<<16 | word0;
f010778a:	09 f3                	or     %esi,%ebx
f010778c:	89 d8                	mov    %ebx,%eax
f010778e:	81 ca 00 00 00 80    	or     $0x80000000,%edx
f0107794:	89 1d 20 bd 5d f0    	mov    %ebx,0xf05dbd20
f010779a:	89 15 24 bd 5d f0    	mov    %edx,0xf05dbd24
    return mac_address;
f01077a0:	83 c4 10             	add    $0x10,%esp
f01077a3:	eb a0                	jmp    f0107745 <read_eeprom_mac_addr+0x1a>

f01077a5 <e1000_tx_init>:

int
e1000_tx_init()
{
f01077a5:	55                   	push   %ebp
f01077a6:	89 e5                	mov    %esp,%ebp
f01077a8:	57                   	push   %edi
f01077a9:	56                   	push   %esi
f01077aa:	53                   	push   %ebx
f01077ab:	83 ec 18             	sub    $0x18,%esp
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01077ae:	6a 01                	push   $0x1
f01077b0:	e8 3a 9b ff ff       	call   f01012ef <page_alloc>
	return (pp - pages) << PGSHIFT;
f01077b5:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f01077bb:	c1 f8 03             	sar    $0x3,%eax
f01077be:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01077c1:	89 c2                	mov    %eax,%edx
f01077c3:	c1 ea 0c             	shr    $0xc,%edx
f01077c6:	83 c4 10             	add    $0x10,%esp
f01077c9:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f01077cf:	0f 83 e5 00 00 00    	jae    f01078ba <e1000_tx_init+0x115>
	return (void *)(pa + KERNBASE);
f01077d5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01077da:	a3 60 cd 5d f0       	mov    %eax,0xf05dcd60
f01077df:	ba 80 cd 65 f0       	mov    $0xf065cd80,%edx
f01077e4:	b8 80 cd 65 00       	mov    $0x65cd80,%eax
f01077e9:	89 c6                	mov    %eax,%esi
f01077eb:	bf 00 00 00 00       	mov    $0x0,%edi
	tx_descs = (struct tx_desc *)page2kva(page);
f01077f0:	b9 00 00 00 00       	mov    $0x0,%ecx
	if ((uint32_t)kva < KERNBASE)
f01077f5:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01077fb:	0f 86 cb 00 00 00    	jbe    f01078cc <e1000_tx_init+0x127>
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(tx_buffer[i]);
f0107801:	a1 60 cd 5d f0       	mov    0xf05dcd60,%eax
f0107806:	89 34 08             	mov    %esi,(%eax,%ecx,1)
f0107809:	89 7c 08 04          	mov    %edi,0x4(%eax,%ecx,1)
		tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f010780d:	8b 1d 60 cd 5d f0    	mov    0xf05dcd60,%ebx
f0107813:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
f0107816:	80 48 0b 05          	orb    $0x5,0xb(%eax)
		tx_descs[i].status |= E1000_TX_STATUS_DD;
f010781a:	80 48 0c 01          	orb    $0x1,0xc(%eax)
		tx_descs[i].length = 0;
f010781e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		tx_descs[i].cso = 0;
f0107824:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
		tx_descs[i].css = 0;
f0107828:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
		tx_descs[i].special = 0;
f010782c:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
f0107832:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f0107838:	83 c1 10             	add    $0x10,%ecx
f010783b:	81 c6 ee 05 00 00    	add    $0x5ee,%esi
f0107841:	83 d7 00             	adc    $0x0,%edi
	for(int i = 0; i < N_TXDESC; i++){
f0107844:	81 fa 80 bb 6b f0    	cmp    $0xf06bbb80,%edx
f010784a:	75 a9                	jne    f01077f5 <e1000_tx_init+0x50>
	}
	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->TDBAL = (uint32_t)PADDR(tx_descs);
f010784c:	a1 28 bd 5d f0       	mov    0xf05dbd28,%eax
f0107851:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0107857:	0f 86 81 00 00 00    	jbe    f01078de <e1000_tx_init+0x139>
	return (physaddr_t)kva - KERNBASE;
f010785d:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f0107863:	89 98 00 38 00 00    	mov    %ebx,0x3800(%eax)
	base->TDBAH = (uint32_t)0;
f0107869:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f0107870:	00 00 00 
	// base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc);
f0107873:	c7 80 08 38 00 00 00 	movl   $0x1000,0x3808(%eax)
f010787a:	10 00 00 

	base->TDH = 0;
f010787d:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f0107884:	00 00 00 
	base->TDT = 0;
f0107887:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f010788e:	00 00 00 

	base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
f0107891:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0107897:	81 ca 0a 01 04 00    	or     $0x4010a,%edx
f010789d:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	base->TIPG = E1000_TIPG_DEFAULT;
f01078a3:	c7 80 10 04 00 00 0a 	movl   $0x60100a,0x410(%eax)
f01078aa:	10 60 00 
	return 0;
}
f01078ad:	b8 00 00 00 00       	mov    $0x0,%eax
f01078b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01078b5:	5b                   	pop    %ebx
f01078b6:	5e                   	pop    %esi
f01078b7:	5f                   	pop    %edi
f01078b8:	5d                   	pop    %ebp
f01078b9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01078ba:	50                   	push   %eax
f01078bb:	68 34 84 10 f0       	push   $0xf0108434
f01078c0:	6a 58                	push   $0x58
f01078c2:	68 f1 95 10 f0       	push   $0xf01095f1
f01078c7:	e8 7d 87 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01078cc:	52                   	push   %edx
f01078cd:	68 58 84 10 f0       	push   $0xf0108458
f01078d2:	6a 29                	push   $0x29
f01078d4:	68 15 a9 10 f0       	push   $0xf010a915
f01078d9:	e8 6b 87 ff ff       	call   f0100049 <_panic>
f01078de:	53                   	push   %ebx
f01078df:	68 58 84 10 f0       	push   $0xf0108458
f01078e4:	6a 34                	push   $0x34
f01078e6:	68 15 a9 10 f0       	push   $0xf010a915
f01078eb:	e8 59 87 ff ff       	call   f0100049 <_panic>

f01078f0 <e1000_rx_init>:
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_buffer[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx_init()
{
f01078f0:	55                   	push   %ebp
f01078f1:	89 e5                	mov    %esp,%ebp
f01078f3:	57                   	push   %edi
f01078f4:	56                   	push   %esi
f01078f5:	53                   	push   %ebx
f01078f6:	83 ec 18             	sub    $0x18,%esp
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01078f9:	6a 01                	push   $0x1
f01078fb:	e8 ef 99 ff ff       	call   f01012ef <page_alloc>
	if(page == NULL)
f0107900:	83 c4 10             	add    $0x10,%esp
f0107903:	85 c0                	test   %eax,%eax
f0107905:	0f 84 e9 00 00 00    	je     f01079f4 <e1000_rx_init+0x104>
	return (pp - pages) << PGSHIFT;
f010790b:	2b 05 50 cd 5d f0    	sub    0xf05dcd50,%eax
f0107911:	c1 f8 03             	sar    $0x3,%eax
f0107914:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0107917:	89 c2                	mov    %eax,%edx
f0107919:	c1 ea 0c             	shr    $0xc,%edx
f010791c:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0107922:	0f 83 e0 00 00 00    	jae    f0107a08 <e1000_rx_init+0x118>
	return (void *)(pa + KERNBASE);
f0107928:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010792d:	a3 64 cd 5d f0       	mov    %eax,0xf05dcd64
f0107932:	b8 80 cd 5d f0       	mov    $0xf05dcd80,%eax
f0107937:	b9 80 cd 5d 00       	mov    $0x5dcd80,%ecx
f010793c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0107941:	be 80 cd 65 f0       	mov    $0xf065cd80,%esi
			panic("page_alloc panic\n");
	rx_descs = (struct rx_desc *)page2kva(page);
f0107946:	ba 00 00 00 00       	mov    $0x0,%edx
	if ((uint32_t)kva < KERNBASE)
f010794b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0107950:	0f 86 c4 00 00 00    	jbe    f0107a1a <e1000_rx_init+0x12a>
	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for(int i = 0; i < N_RXDESC; i++){
		rx_descs[i].addr = PADDR(rx_buffer[i]);
f0107956:	8b 3d 64 cd 5d f0    	mov    0xf05dcd64,%edi
f010795c:	89 0c 17             	mov    %ecx,(%edi,%edx,1)
f010795f:	89 5c 17 04          	mov    %ebx,0x4(%edi,%edx,1)
f0107963:	05 00 08 00 00       	add    $0x800,%eax
f0107968:	83 c2 10             	add    $0x10,%edx
f010796b:	81 c1 00 08 00 00    	add    $0x800,%ecx
f0107971:	83 d3 00             	adc    $0x0,%ebx
	for(int i = 0; i < N_RXDESC; i++){
f0107974:	39 f0                	cmp    %esi,%eax
f0107976:	75 d3                	jne    f010794b <e1000_rx_init+0x5b>
	}

	uint64_t macaddr_local = read_eeprom_mac_addr();
f0107978:	e8 ae fd ff ff       	call   f010772b <read_eeprom_mac_addr>

	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->RCTL |= E1000_RCTL_EN|E1000_RCTL_BSIZE_2048|E1000_RCTL_SECRC;
f010797d:	8b 0d 28 bd 5d f0    	mov    0xf05dbd28,%ecx
f0107983:	8b 99 00 01 00 00    	mov    0x100(%ecx),%ebx
f0107989:	81 cb 02 00 00 04    	or     $0x4000002,%ebx
f010798f:	89 99 00 01 00 00    	mov    %ebx,0x100(%ecx)
	base->RDBAL = PADDR(rx_descs);
f0107995:	8b 1d 64 cd 5d f0    	mov    0xf05dcd64,%ebx
f010799b:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01079a1:	0f 86 85 00 00 00    	jbe    f0107a2c <e1000_rx_init+0x13c>
	return (physaddr_t)kva - KERNBASE;
f01079a7:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f01079ad:	89 99 00 28 00 00    	mov    %ebx,0x2800(%ecx)
	base->RDBAH = (uint32_t)0;
f01079b3:	c7 81 04 28 00 00 00 	movl   $0x0,0x2804(%ecx)
f01079ba:	00 00 00 
	base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
f01079bd:	c7 81 08 28 00 00 00 	movl   $0x1000,0x2808(%ecx)
f01079c4:	10 00 00 
	base->RDH = 0;
f01079c7:	c7 81 10 28 00 00 00 	movl   $0x0,0x2810(%ecx)
f01079ce:	00 00 00 
	base->RDT = N_RXDESC-1;
f01079d1:	c7 81 18 28 00 00 ff 	movl   $0xff,0x2818(%ecx)
f01079d8:	00 00 00 
	// base->RAL = QEMU_MAC_LOW;
	// base->RAH = QEMU_MAC_HIGH;

	base->RAL = (uint32_t)(macaddr_local & 0xffffffff);
f01079db:	89 81 1c 3a 00 00    	mov    %eax,0x3a1c(%ecx)
	base->RAH = (uint32_t)(macaddr_local>>32);
f01079e1:	89 91 20 3a 00 00    	mov    %edx,0x3a20(%ecx)

	return 0;
}
f01079e7:	b8 00 00 00 00       	mov    $0x0,%eax
f01079ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01079ef:	5b                   	pop    %ebx
f01079f0:	5e                   	pop    %esi
f01079f1:	5f                   	pop    %edi
f01079f2:	5d                   	pop    %ebp
f01079f3:	c3                   	ret    
			panic("page_alloc panic\n");
f01079f4:	83 ec 04             	sub    $0x4,%esp
f01079f7:	68 22 a9 10 f0       	push   $0xf010a922
f01079fc:	6a 4c                	push   $0x4c
f01079fe:	68 15 a9 10 f0       	push   $0xf010a915
f0107a03:	e8 41 86 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107a08:	50                   	push   %eax
f0107a09:	68 34 84 10 f0       	push   $0xf0108434
f0107a0e:	6a 58                	push   $0x58
f0107a10:	68 f1 95 10 f0       	push   $0xf01095f1
f0107a15:	e8 2f 86 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107a1a:	50                   	push   %eax
f0107a1b:	68 58 84 10 f0       	push   $0xf0108458
f0107a20:	6a 51                	push   $0x51
f0107a22:	68 15 a9 10 f0       	push   $0xf010a915
f0107a27:	e8 1d 86 ff ff       	call   f0100049 <_panic>
f0107a2c:	53                   	push   %ebx
f0107a2d:	68 58 84 10 f0       	push   $0xf0108458
f0107a32:	6a 5a                	push   $0x5a
f0107a34:	68 15 a9 10 f0       	push   $0xf010a915
f0107a39:	e8 0b 86 ff ff       	call   f0100049 <_panic>

f0107a3e <pci_e1000_attach>:

int
pci_e1000_attach(struct pci_func *pcif)
{
f0107a3e:	55                   	push   %ebp
f0107a3f:	89 e5                	mov    %esp,%ebp
f0107a41:	53                   	push   %ebx
f0107a42:	83 ec 10             	sub    $0x10,%esp
f0107a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
f0107a48:	53                   	push   %ebx
f0107a49:	e8 93 05 00 00       	call   f0107fe1 <pci_func_enable>
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f0107a4e:	83 c4 08             	add    $0x8,%esp
f0107a51:	ff 73 2c             	pushl  0x2c(%ebx)
f0107a54:	ff 73 14             	pushl  0x14(%ebx)
f0107a57:	e8 b1 9c ff ff       	call   f010170d <mmio_map_region>
f0107a5c:	a3 28 bd 5d f0       	mov    %eax,0xf05dbd28
	e1000_tx_init();
f0107a61:	e8 3f fd ff ff       	call   f01077a5 <e1000_tx_init>
	e1000_rx_init();
f0107a66:	e8 85 fe ff ff       	call   f01078f0 <e1000_rx_init>

	return 0;
}
f0107a6b:	b8 00 00 00 00       	mov    $0x0,%eax
f0107a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107a73:	c9                   	leave  
f0107a74:	c3                   	ret    

f0107a75 <e1000_tx>:

int
e1000_tx(const void *buf, uint32_t len)
{
f0107a75:	55                   	push   %ebp
f0107a76:	89 e5                	mov    %esp,%ebp
f0107a78:	53                   	push   %ebx
f0107a79:	83 ec 04             	sub    $0x4,%esp
f0107a7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address
	if(tx_descs[base->TDT].status & E1000_TX_STATUS_DD){
f0107a7f:	a1 60 cd 5d f0       	mov    0xf05dcd60,%eax
f0107a84:	8b 0d 28 bd 5d f0    	mov    0xf05dbd28,%ecx
f0107a8a:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f0107a90:	c1 e2 04             	shl    $0x4,%edx
f0107a93:	f6 44 10 0c 01       	testb  $0x1,0xc(%eax,%edx,1)
f0107a98:	0f 84 e3 00 00 00    	je     f0107b81 <e1000_tx+0x10c>
		tx_descs[base->TDT].status ^= E1000_TX_STATUS_DD;
f0107a9e:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f0107aa4:	c1 e2 04             	shl    $0x4,%edx
f0107aa7:	80 74 10 0c 01       	xorb   $0x1,0xc(%eax,%edx,1)
		memset(KADDR(tx_descs[base->TDT].addr), 0 , TX_PKT_SIZE);
f0107aac:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f0107ab2:	c1 e2 04             	shl    $0x4,%edx
f0107ab5:	8b 04 10             	mov    (%eax,%edx,1),%eax
	if (PGNUM(pa) >= npages)
f0107ab8:	89 c2                	mov    %eax,%edx
f0107aba:	c1 ea 0c             	shr    $0xc,%edx
f0107abd:	3b 15 48 cd 5d f0    	cmp    0xf05dcd48,%edx
f0107ac3:	0f 83 94 00 00 00    	jae    f0107b5d <e1000_tx+0xe8>
f0107ac9:	83 ec 04             	sub    $0x4,%esp
f0107acc:	68 ee 05 00 00       	push   $0x5ee
f0107ad1:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0107ad3:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107ad8:	50                   	push   %eax
f0107ad9:	e8 31 f2 ff ff       	call   f0106d0f <memset>
		memcpy(KADDR(tx_descs[base->TDT].addr), buf, len);
f0107ade:	a1 28 bd 5d f0       	mov    0xf05dbd28,%eax
f0107ae3:	8b 80 18 38 00 00    	mov    0x3818(%eax),%eax
f0107ae9:	c1 e0 04             	shl    $0x4,%eax
f0107aec:	03 05 60 cd 5d f0    	add    0xf05dcd60,%eax
f0107af2:	8b 00                	mov    (%eax),%eax
	if (PGNUM(pa) >= npages)
f0107af4:	89 c2                	mov    %eax,%edx
f0107af6:	c1 ea 0c             	shr    $0xc,%edx
f0107af9:	83 c4 10             	add    $0x10,%esp
f0107afc:	39 15 48 cd 5d f0    	cmp    %edx,0xf05dcd48
f0107b02:	76 6b                	jbe    f0107b6f <e1000_tx+0xfa>
f0107b04:	83 ec 04             	sub    $0x4,%esp
f0107b07:	53                   	push   %ebx
f0107b08:	ff 75 08             	pushl  0x8(%ebp)
	return (void *)(pa + KERNBASE);
f0107b0b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107b10:	50                   	push   %eax
f0107b11:	e8 a3 f2 ff ff       	call   f0106db9 <memcpy>
		tx_descs[base->TDT].length = len;
f0107b16:	8b 0d 60 cd 5d f0    	mov    0xf05dcd60,%ecx
f0107b1c:	8b 15 28 bd 5d f0    	mov    0xf05dbd28,%edx
f0107b22:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f0107b28:	c1 e0 04             	shl    $0x4,%eax
f0107b2b:	66 89 5c 01 08       	mov    %bx,0x8(%ecx,%eax,1)
		tx_descs[base->TDT].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0107b30:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f0107b36:	c1 e0 04             	shl    $0x4,%eax
f0107b39:	80 4c 01 0b 05       	orb    $0x5,0xb(%ecx,%eax,1)

		base->TDT = (base->TDT + 1)%N_TXDESC;
f0107b3e:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f0107b44:	83 c0 01             	add    $0x1,%eax
f0107b47:	0f b6 c0             	movzbl %al,%eax
f0107b4a:	89 82 18 38 00 00    	mov    %eax,0x3818(%edx)
	}
	else{
		return -E_TX_FULL;
	}
	return 0;
f0107b50:	83 c4 10             	add    $0x10,%esp
f0107b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0107b58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107b5b:	c9                   	leave  
f0107b5c:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107b5d:	50                   	push   %eax
f0107b5e:	68 34 84 10 f0       	push   $0xf0108434
f0107b63:	6a 7d                	push   $0x7d
f0107b65:	68 15 a9 10 f0       	push   $0xf010a915
f0107b6a:	e8 da 84 ff ff       	call   f0100049 <_panic>
f0107b6f:	50                   	push   %eax
f0107b70:	68 34 84 10 f0       	push   $0xf0108434
f0107b75:	6a 7e                	push   $0x7e
f0107b77:	68 15 a9 10 f0       	push   $0xf010a915
f0107b7c:	e8 c8 84 ff ff       	call   f0100049 <_panic>
		return -E_TX_FULL;
f0107b81:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
f0107b86:	eb d0                	jmp    f0107b58 <e1000_tx+0xe3>

f0107b88 <e1000_rx>:

// char rx_bufs[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx(void *buf, uint32_t len)
{
f0107b88:	55                   	push   %ebp
f0107b89:	89 e5                	mov    %esp,%ebp
f0107b8b:	57                   	push   %edi
f0107b8c:	56                   	push   %esi
f0107b8d:	53                   	push   %ebx
f0107b8e:	83 ec 0c             	sub    $0xc,%esp
	// 	assert(len > rx_descs[base->RDH].length);
	// 	memcpy(buf, KADDR(rx_descs[base->RDH].addr), len);
	// 	memset(KADDR(rx_descs[base->RDH].addr), 0, PKT_SIZE);
	// 	base->RDT = base->RDH;
	// }
	uint32_t rdt = (base->RDT + 1) % N_RXDESC;
f0107b91:	a1 28 bd 5d f0       	mov    0xf05dbd28,%eax
f0107b96:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
f0107b9c:	83 c3 01             	add    $0x1,%ebx
f0107b9f:	0f b6 db             	movzbl %bl,%ebx
  	if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD)){
f0107ba2:	89 de                	mov    %ebx,%esi
f0107ba4:	c1 e6 04             	shl    $0x4,%esi
f0107ba7:	89 f0                	mov    %esi,%eax
f0107ba9:	03 05 64 cd 5d f0    	add    0xf05dcd64,%eax
f0107baf:	f6 40 0c 01          	testb  $0x1,0xc(%eax)
f0107bb3:	74 5a                	je     f0107c0f <e1000_rx+0x87>
		return -E_AGAIN;
	}

	if(rx_descs[rdt].error) {
f0107bb5:	80 78 0d 00          	cmpb   $0x0,0xd(%eax)
f0107bb9:	75 3d                	jne    f0107bf8 <e1000_rx+0x70>
		cprintf("[rx]error occours\n");
		return -E_UNSPECIFIED;
	}
	len = rx_descs[rdt].length;
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f0107bbb:	83 ec 04             	sub    $0x4,%esp
	len = rx_descs[rdt].length;
f0107bbe:	0f b7 78 08          	movzwl 0x8(%eax),%edi
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f0107bc2:	57                   	push   %edi
f0107bc3:	89 d8                	mov    %ebx,%eax
f0107bc5:	c1 e0 0b             	shl    $0xb,%eax
f0107bc8:	05 80 cd 5d f0       	add    $0xf05dcd80,%eax
f0107bcd:	50                   	push   %eax
f0107bce:	ff 75 08             	pushl  0x8(%ebp)
f0107bd1:	e8 e3 f1 ff ff       	call   f0106db9 <memcpy>
  	rx_descs[rdt].status ^= E1000_RX_STATUS_DD;//lab6 bug?
f0107bd6:	03 35 64 cd 5d f0    	add    0xf05dcd64,%esi
f0107bdc:	80 76 0c 01          	xorb   $0x1,0xc(%esi)

  	base->RDT = rdt;
f0107be0:	a1 28 bd 5d f0       	mov    0xf05dbd28,%eax
f0107be5:	89 98 18 28 00 00    	mov    %ebx,0x2818(%eax)
	return len;
f0107beb:	89 f8                	mov    %edi,%eax
f0107bed:	83 c4 10             	add    $0x10,%esp
}
f0107bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107bf3:	5b                   	pop    %ebx
f0107bf4:	5e                   	pop    %esi
f0107bf5:	5f                   	pop    %edi
f0107bf6:	5d                   	pop    %ebp
f0107bf7:	c3                   	ret    
		cprintf("[rx]error occours\n");
f0107bf8:	83 ec 0c             	sub    $0xc,%esp
f0107bfb:	68 34 a9 10 f0       	push   $0xf010a934
f0107c00:	e8 fc c9 ff ff       	call   f0104601 <cprintf>
		return -E_UNSPECIFIED;
f0107c05:	83 c4 10             	add    $0x10,%esp
f0107c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0107c0d:	eb e1                	jmp    f0107bf0 <e1000_rx+0x68>
		return -E_AGAIN;
f0107c0f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f0107c14:	eb da                	jmp    f0107bf0 <e1000_rx+0x68>

f0107c16 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0107c16:	55                   	push   %ebp
f0107c17:	89 e5                	mov    %esp,%ebp
f0107c19:	57                   	push   %edi
f0107c1a:	56                   	push   %esi
f0107c1b:	53                   	push   %ebx
f0107c1c:	83 ec 0c             	sub    $0xc,%esp
f0107c1f:	8b 7d 08             	mov    0x8(%ebp),%edi
f0107c22:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107c25:	eb 03                	jmp    f0107c2a <pci_attach_match+0x14>
f0107c27:	83 c3 0c             	add    $0xc,%ebx
f0107c2a:	89 de                	mov    %ebx,%esi
f0107c2c:	8b 43 08             	mov    0x8(%ebx),%eax
f0107c2f:	85 c0                	test   %eax,%eax
f0107c31:	74 37                	je     f0107c6a <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0107c33:	39 3b                	cmp    %edi,(%ebx)
f0107c35:	75 f0                	jne    f0107c27 <pci_attach_match+0x11>
f0107c37:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107c3a:	39 56 04             	cmp    %edx,0x4(%esi)
f0107c3d:	75 e8                	jne    f0107c27 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f0107c3f:	83 ec 0c             	sub    $0xc,%esp
f0107c42:	ff 75 14             	pushl  0x14(%ebp)
f0107c45:	ff d0                	call   *%eax
			if (r > 0)
f0107c47:	83 c4 10             	add    $0x10,%esp
f0107c4a:	85 c0                	test   %eax,%eax
f0107c4c:	7f 1c                	jg     f0107c6a <pci_attach_match+0x54>
				return r;
			if (r < 0)
f0107c4e:	79 d7                	jns    f0107c27 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f0107c50:	83 ec 0c             	sub    $0xc,%esp
f0107c53:	50                   	push   %eax
f0107c54:	ff 76 08             	pushl  0x8(%esi)
f0107c57:	ff 75 0c             	pushl  0xc(%ebp)
f0107c5a:	57                   	push   %edi
f0107c5b:	68 48 a9 10 f0       	push   $0xf010a948
f0107c60:	e8 9c c9 ff ff       	call   f0104601 <cprintf>
f0107c65:	83 c4 20             	add    $0x20,%esp
f0107c68:	eb bd                	jmp    f0107c27 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0107c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107c6d:	5b                   	pop    %ebx
f0107c6e:	5e                   	pop    %esi
f0107c6f:	5f                   	pop    %edi
f0107c70:	5d                   	pop    %ebp
f0107c71:	c3                   	ret    

f0107c72 <pci_conf1_set_addr>:
{
f0107c72:	55                   	push   %ebp
f0107c73:	89 e5                	mov    %esp,%ebp
f0107c75:	53                   	push   %ebx
f0107c76:	83 ec 04             	sub    $0x4,%esp
f0107c79:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0107c7c:	3d ff 00 00 00       	cmp    $0xff,%eax
f0107c81:	77 36                	ja     f0107cb9 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f0107c83:	83 fa 1f             	cmp    $0x1f,%edx
f0107c86:	77 47                	ja     f0107ccf <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f0107c88:	83 f9 07             	cmp    $0x7,%ecx
f0107c8b:	77 58                	ja     f0107ce5 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f0107c8d:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0107c93:	77 66                	ja     f0107cfb <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f0107c95:	f6 c3 03             	test   $0x3,%bl
f0107c98:	75 77                	jne    f0107d11 <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0107c9a:	c1 e0 10             	shl    $0x10,%eax
f0107c9d:	09 d8                	or     %ebx,%eax
f0107c9f:	c1 e1 08             	shl    $0x8,%ecx
f0107ca2:	09 c8                	or     %ecx,%eax
f0107ca4:	c1 e2 0b             	shl    $0xb,%edx
f0107ca7:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f0107ca9:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107cae:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0107cb3:	ef                   	out    %eax,(%dx)
}
f0107cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107cb7:	c9                   	leave  
f0107cb8:	c3                   	ret    
	assert(bus < 256);
f0107cb9:	68 a0 aa 10 f0       	push   $0xf010aaa0
f0107cbe:	68 0b 96 10 f0       	push   $0xf010960b
f0107cc3:	6a 2c                	push   $0x2c
f0107cc5:	68 aa aa 10 f0       	push   $0xf010aaaa
f0107cca:	e8 7a 83 ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f0107ccf:	68 b5 aa 10 f0       	push   $0xf010aab5
f0107cd4:	68 0b 96 10 f0       	push   $0xf010960b
f0107cd9:	6a 2d                	push   $0x2d
f0107cdb:	68 aa aa 10 f0       	push   $0xf010aaaa
f0107ce0:	e8 64 83 ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f0107ce5:	68 be aa 10 f0       	push   $0xf010aabe
f0107cea:	68 0b 96 10 f0       	push   $0xf010960b
f0107cef:	6a 2e                	push   $0x2e
f0107cf1:	68 aa aa 10 f0       	push   $0xf010aaaa
f0107cf6:	e8 4e 83 ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f0107cfb:	68 c7 aa 10 f0       	push   $0xf010aac7
f0107d00:	68 0b 96 10 f0       	push   $0xf010960b
f0107d05:	6a 2f                	push   $0x2f
f0107d07:	68 aa aa 10 f0       	push   $0xf010aaaa
f0107d0c:	e8 38 83 ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f0107d11:	68 d4 aa 10 f0       	push   $0xf010aad4
f0107d16:	68 0b 96 10 f0       	push   $0xf010960b
f0107d1b:	6a 30                	push   $0x30
f0107d1d:	68 aa aa 10 f0       	push   $0xf010aaaa
f0107d22:	e8 22 83 ff ff       	call   f0100049 <_panic>

f0107d27 <pci_conf_read>:
{
f0107d27:	55                   	push   %ebp
f0107d28:	89 e5                	mov    %esp,%ebp
f0107d2a:	53                   	push   %ebx
f0107d2b:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107d2e:	8b 48 08             	mov    0x8(%eax),%ecx
f0107d31:	8b 58 04             	mov    0x4(%eax),%ebx
f0107d34:	8b 00                	mov    (%eax),%eax
f0107d36:	8b 40 04             	mov    0x4(%eax),%eax
f0107d39:	52                   	push   %edx
f0107d3a:	89 da                	mov    %ebx,%edx
f0107d3c:	e8 31 ff ff ff       	call   f0107c72 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0107d41:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107d46:	ed                   	in     (%dx),%eax
}
f0107d47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107d4a:	c9                   	leave  
f0107d4b:	c3                   	ret    

f0107d4c <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0107d4c:	55                   	push   %ebp
f0107d4d:	89 e5                	mov    %esp,%ebp
f0107d4f:	57                   	push   %edi
f0107d50:	56                   	push   %esi
f0107d51:	53                   	push   %ebx
f0107d52:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0107d58:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107d5a:	6a 48                	push   $0x48
f0107d5c:	6a 00                	push   $0x0
f0107d5e:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107d61:	50                   	push   %eax
f0107d62:	e8 a8 ef ff ff       	call   f0106d0f <memset>
	df.bus = bus;
f0107d67:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107d6a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f0107d71:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f0107d74:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0107d7b:	00 00 00 
f0107d7e:	e9 25 01 00 00       	jmp    f0107ea8 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107d83:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107d89:	83 ec 08             	sub    $0x8,%esp
f0107d8c:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0107d90:	57                   	push   %edi
f0107d91:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f0107d92:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107d95:	0f b6 c0             	movzbl %al,%eax
f0107d98:	50                   	push   %eax
f0107d99:	51                   	push   %ecx
f0107d9a:	89 d0                	mov    %edx,%eax
f0107d9c:	c1 e8 10             	shr    $0x10,%eax
f0107d9f:	50                   	push   %eax
f0107da0:	0f b7 d2             	movzwl %dx,%edx
f0107da3:	52                   	push   %edx
f0107da4:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0107daa:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f0107db0:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107db6:	ff 70 04             	pushl  0x4(%eax)
f0107db9:	68 74 a9 10 f0       	push   $0xf010a974
f0107dbe:	e8 3e c8 ff ff       	call   f0104601 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f0107dc3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107dc9:	83 c4 30             	add    $0x30,%esp
f0107dcc:	53                   	push   %ebx
f0107dcd:	68 6c d3 16 f0       	push   $0xf016d36c
				 PCI_SUBCLASS(f->dev_class),
f0107dd2:	89 c2                	mov    %eax,%edx
f0107dd4:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107dd7:	0f b6 d2             	movzbl %dl,%edx
f0107dda:	52                   	push   %edx
f0107ddb:	c1 e8 18             	shr    $0x18,%eax
f0107dde:	50                   	push   %eax
f0107ddf:	e8 32 fe ff ff       	call   f0107c16 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0107de4:	83 c4 10             	add    $0x10,%esp
f0107de7:	85 c0                	test   %eax,%eax
f0107de9:	0f 84 88 00 00 00    	je     f0107e77 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107def:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107df6:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0107dfc:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f0107e02:	0f 83 92 00 00 00    	jae    f0107e9a <pci_scan_bus+0x14e>
			struct pci_func af = f;
f0107e08:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f0107e0e:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107e14:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107e19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0107e1b:	ba 00 00 00 00       	mov    $0x0,%edx
f0107e20:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107e26:	e8 fc fe ff ff       	call   f0107d27 <pci_conf_read>
f0107e2b:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107e31:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107e35:	74 b8                	je     f0107def <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107e37:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107e3c:	89 d8                	mov    %ebx,%eax
f0107e3e:	e8 e4 fe ff ff       	call   f0107d27 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107e43:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107e46:	ba 08 00 00 00       	mov    $0x8,%edx
f0107e4b:	89 d8                	mov    %ebx,%eax
f0107e4d:	e8 d5 fe ff ff       	call   f0107d27 <pci_conf_read>
f0107e52:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107e58:	89 c1                	mov    %eax,%ecx
f0107e5a:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0107e5d:	be e8 aa 10 f0       	mov    $0xf010aae8,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107e62:	83 f9 06             	cmp    $0x6,%ecx
f0107e65:	0f 87 18 ff ff ff    	ja     f0107d83 <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107e6b:	8b 34 8d 5c ab 10 f0 	mov    -0xfef54a4(,%ecx,4),%esi
f0107e72:	e9 0c ff ff ff       	jmp    f0107d83 <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0107e77:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107e7d:	53                   	push   %ebx
f0107e7e:	68 54 d3 16 f0       	push   $0xf016d354
f0107e83:	89 c2                	mov    %eax,%edx
f0107e85:	c1 ea 10             	shr    $0x10,%edx
f0107e88:	52                   	push   %edx
f0107e89:	0f b7 c0             	movzwl %ax,%eax
f0107e8c:	50                   	push   %eax
f0107e8d:	e8 84 fd ff ff       	call   f0107c16 <pci_attach_match>
f0107e92:	83 c4 10             	add    $0x10,%esp
f0107e95:	e9 55 ff ff ff       	jmp    f0107def <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107e9a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107e9d:	83 c0 01             	add    $0x1,%eax
f0107ea0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107ea3:	83 f8 1f             	cmp    $0x1f,%eax
f0107ea6:	77 59                	ja     f0107f01 <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107ea8:	ba 0c 00 00 00       	mov    $0xc,%edx
f0107ead:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107eb0:	e8 72 fe ff ff       	call   f0107d27 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107eb5:	89 c2                	mov    %eax,%edx
f0107eb7:	c1 ea 10             	shr    $0x10,%edx
f0107eba:	f6 c2 7e             	test   $0x7e,%dl
f0107ebd:	75 db                	jne    f0107e9a <pci_scan_bus+0x14e>
		totaldev++;
f0107ebf:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0107ec6:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107ecc:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107ecf:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107ed4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107ed6:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107edd:	00 00 00 
f0107ee0:	25 00 00 80 00       	and    $0x800000,%eax
f0107ee5:	83 f8 01             	cmp    $0x1,%eax
f0107ee8:	19 c0                	sbb    %eax,%eax
f0107eea:	83 e0 f9             	and    $0xfffffff9,%eax
f0107eed:	83 c0 08             	add    $0x8,%eax
f0107ef0:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107ef6:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107efc:	e9 f5 fe ff ff       	jmp    f0107df6 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107f01:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107f0a:	5b                   	pop    %ebx
f0107f0b:	5e                   	pop    %esi
f0107f0c:	5f                   	pop    %edi
f0107f0d:	5d                   	pop    %ebp
f0107f0e:	c3                   	ret    

f0107f0f <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0107f0f:	55                   	push   %ebp
f0107f10:	89 e5                	mov    %esp,%ebp
f0107f12:	57                   	push   %edi
f0107f13:	56                   	push   %esi
f0107f14:	53                   	push   %ebx
f0107f15:	83 ec 1c             	sub    $0x1c,%esp
f0107f18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0107f1b:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0107f20:	89 d8                	mov    %ebx,%eax
f0107f22:	e8 00 fe ff ff       	call   f0107d27 <pci_conf_read>
f0107f27:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107f29:	ba 18 00 00 00       	mov    $0x18,%edx
f0107f2e:	89 d8                	mov    %ebx,%eax
f0107f30:	e8 f2 fd ff ff       	call   f0107d27 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107f35:	83 e7 0f             	and    $0xf,%edi
f0107f38:	83 ff 01             	cmp    $0x1,%edi
f0107f3b:	74 56                	je     f0107f93 <pci_bridge_attach+0x84>
f0107f3d:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0107f3f:	83 ec 04             	sub    $0x4,%esp
f0107f42:	6a 08                	push   $0x8
f0107f44:	6a 00                	push   $0x0
f0107f46:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107f49:	57                   	push   %edi
f0107f4a:	e8 c0 ed ff ff       	call   f0106d0f <memset>
	nbus.parent_bridge = pcif;
f0107f4f:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0107f52:	89 f0                	mov    %esi,%eax
f0107f54:	0f b6 c4             	movzbl %ah,%eax
f0107f57:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107f5a:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0107f5d:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107f60:	89 f1                	mov    %esi,%ecx
f0107f62:	0f b6 f1             	movzbl %cl,%esi
f0107f65:	56                   	push   %esi
f0107f66:	50                   	push   %eax
f0107f67:	ff 73 08             	pushl  0x8(%ebx)
f0107f6a:	ff 73 04             	pushl  0x4(%ebx)
f0107f6d:	8b 03                	mov    (%ebx),%eax
f0107f6f:	ff 70 04             	pushl  0x4(%eax)
f0107f72:	68 e4 a9 10 f0       	push   $0xf010a9e4
f0107f77:	e8 85 c6 ff ff       	call   f0104601 <cprintf>

	pci_scan_bus(&nbus);
f0107f7c:	83 c4 20             	add    $0x20,%esp
f0107f7f:	89 f8                	mov    %edi,%eax
f0107f81:	e8 c6 fd ff ff       	call   f0107d4c <pci_scan_bus>
	return 1;
f0107f86:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107f8e:	5b                   	pop    %ebx
f0107f8f:	5e                   	pop    %esi
f0107f90:	5f                   	pop    %edi
f0107f91:	5d                   	pop    %ebp
f0107f92:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107f93:	ff 73 08             	pushl  0x8(%ebx)
f0107f96:	ff 73 04             	pushl  0x4(%ebx)
f0107f99:	8b 03                	mov    (%ebx),%eax
f0107f9b:	ff 70 04             	pushl  0x4(%eax)
f0107f9e:	68 b0 a9 10 f0       	push   $0xf010a9b0
f0107fa3:	e8 59 c6 ff ff       	call   f0104601 <cprintf>
		return 0;
f0107fa8:	83 c4 10             	add    $0x10,%esp
f0107fab:	b8 00 00 00 00       	mov    $0x0,%eax
f0107fb0:	eb d9                	jmp    f0107f8b <pci_bridge_attach+0x7c>

f0107fb2 <pci_conf_write>:
{
f0107fb2:	55                   	push   %ebp
f0107fb3:	89 e5                	mov    %esp,%ebp
f0107fb5:	56                   	push   %esi
f0107fb6:	53                   	push   %ebx
f0107fb7:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107fb9:	8b 48 08             	mov    0x8(%eax),%ecx
f0107fbc:	8b 70 04             	mov    0x4(%eax),%esi
f0107fbf:	8b 00                	mov    (%eax),%eax
f0107fc1:	8b 40 04             	mov    0x4(%eax),%eax
f0107fc4:	83 ec 0c             	sub    $0xc,%esp
f0107fc7:	52                   	push   %edx
f0107fc8:	89 f2                	mov    %esi,%edx
f0107fca:	e8 a3 fc ff ff       	call   f0107c72 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107fcf:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107fd4:	89 d8                	mov    %ebx,%eax
f0107fd6:	ef                   	out    %eax,(%dx)
}
f0107fd7:	83 c4 10             	add    $0x10,%esp
f0107fda:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107fdd:	5b                   	pop    %ebx
f0107fde:	5e                   	pop    %esi
f0107fdf:	5d                   	pop    %ebp
f0107fe0:	c3                   	ret    

f0107fe1 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107fe1:	55                   	push   %ebp
f0107fe2:	89 e5                	mov    %esp,%ebp
f0107fe4:	57                   	push   %edi
f0107fe5:	56                   	push   %esi
f0107fe6:	53                   	push   %ebx
f0107fe7:	83 ec 2c             	sub    $0x2c,%esp
f0107fea:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107fed:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107ff2:	ba 04 00 00 00       	mov    $0x4,%edx
f0107ff7:	89 f8                	mov    %edi,%eax
f0107ff9:	e8 b4 ff ff ff       	call   f0107fb2 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107ffe:	be 10 00 00 00       	mov    $0x10,%esi
f0108003:	eb 27                	jmp    f010802c <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0108005:	89 c3                	mov    %eax,%ebx
f0108007:	83 e3 fc             	and    $0xfffffffc,%ebx
f010800a:	f7 db                	neg    %ebx
f010800c:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f010800e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0108011:	83 e0 fc             	and    $0xfffffffc,%eax
f0108014:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f0108017:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f010801e:	eb 74                	jmp    f0108094 <pci_func_enable+0xb3>
	     bar += bar_width)
f0108020:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0108023:	83 fe 27             	cmp    $0x27,%esi
f0108026:	0f 87 c5 00 00 00    	ja     f01080f1 <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f010802c:	89 f2                	mov    %esi,%edx
f010802e:	89 f8                	mov    %edi,%eax
f0108030:	e8 f2 fc ff ff       	call   f0107d27 <pci_conf_read>
f0108035:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0108038:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f010803d:	89 f2                	mov    %esi,%edx
f010803f:	89 f8                	mov    %edi,%eax
f0108041:	e8 6c ff ff ff       	call   f0107fb2 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0108046:	89 f2                	mov    %esi,%edx
f0108048:	89 f8                	mov    %edi,%eax
f010804a:	e8 d8 fc ff ff       	call   f0107d27 <pci_conf_read>
		bar_width = 4;
f010804f:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0108056:	85 c0                	test   %eax,%eax
f0108058:	74 c6                	je     f0108020 <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f010805a:	8d 4e f0             	lea    -0x10(%esi),%ecx
f010805d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0108060:	c1 e9 02             	shr    $0x2,%ecx
f0108063:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0108066:	a8 01                	test   $0x1,%al
f0108068:	75 9b                	jne    f0108005 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f010806a:	89 c2                	mov    %eax,%edx
f010806c:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f010806f:	83 fa 04             	cmp    $0x4,%edx
f0108072:	0f 94 c1             	sete   %cl
f0108075:	0f b6 c9             	movzbl %cl,%ecx
f0108078:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f010807f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f0108082:	89 c3                	mov    %eax,%ebx
f0108084:	83 e3 f0             	and    $0xfffffff0,%ebx
f0108087:	f7 db                	neg    %ebx
f0108089:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f010808b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010808e:	83 e0 f0             	and    $0xfffffff0,%eax
f0108091:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0108094:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0108097:	89 f2                	mov    %esi,%edx
f0108099:	89 f8                	mov    %edi,%eax
f010809b:	e8 12 ff ff ff       	call   f0107fb2 <pci_conf_write>
f01080a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01080a3:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f01080a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01080a8:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f01080ab:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f01080ae:	85 db                	test   %ebx,%ebx
f01080b0:	0f 84 6a ff ff ff    	je     f0108020 <pci_func_enable+0x3f>
f01080b6:	85 d2                	test   %edx,%edx
f01080b8:	0f 85 62 ff ff ff    	jne    f0108020 <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01080be:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f01080c1:	83 ec 0c             	sub    $0xc,%esp
f01080c4:	53                   	push   %ebx
f01080c5:	6a 00                	push   $0x0
f01080c7:	ff 75 d4             	pushl  -0x2c(%ebp)
f01080ca:	89 c2                	mov    %eax,%edx
f01080cc:	c1 ea 10             	shr    $0x10,%edx
f01080cf:	52                   	push   %edx
f01080d0:	0f b7 c0             	movzwl %ax,%eax
f01080d3:	50                   	push   %eax
f01080d4:	ff 77 08             	pushl  0x8(%edi)
f01080d7:	ff 77 04             	pushl  0x4(%edi)
f01080da:	8b 07                	mov    (%edi),%eax
f01080dc:	ff 70 04             	pushl  0x4(%eax)
f01080df:	68 14 aa 10 f0       	push   $0xf010aa14
f01080e4:	e8 18 c5 ff ff       	call   f0104601 <cprintf>
f01080e9:	83 c4 30             	add    $0x30,%esp
f01080ec:	e9 2f ff ff ff       	jmp    f0108020 <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f01080f1:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f01080f4:	83 ec 08             	sub    $0x8,%esp
f01080f7:	89 c2                	mov    %eax,%edx
f01080f9:	c1 ea 10             	shr    $0x10,%edx
f01080fc:	52                   	push   %edx
f01080fd:	0f b7 c0             	movzwl %ax,%eax
f0108100:	50                   	push   %eax
f0108101:	ff 77 08             	pushl  0x8(%edi)
f0108104:	ff 77 04             	pushl  0x4(%edi)
f0108107:	8b 07                	mov    (%edi),%eax
f0108109:	ff 70 04             	pushl  0x4(%eax)
f010810c:	68 70 aa 10 f0       	push   $0xf010aa70
f0108111:	e8 eb c4 ff ff       	call   f0104601 <cprintf>
}
f0108116:	83 c4 20             	add    $0x20,%esp
f0108119:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010811c:	5b                   	pop    %ebx
f010811d:	5e                   	pop    %esi
f010811e:	5f                   	pop    %edi
f010811f:	5d                   	pop    %ebp
f0108120:	c3                   	ret    

f0108121 <pci_init>:

int
pci_init(void)
{
f0108121:	55                   	push   %ebp
f0108122:	89 e5                	mov    %esp,%ebp
f0108124:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0108127:	6a 08                	push   $0x8
f0108129:	6a 00                	push   $0x0
f010812b:	68 2c bd 5d f0       	push   $0xf05dbd2c
f0108130:	e8 da eb ff ff       	call   f0106d0f <memset>

	return pci_scan_bus(&root_bus);
f0108135:	b8 2c bd 5d f0       	mov    $0xf05dbd2c,%eax
f010813a:	e8 0d fc ff ff       	call   f0107d4c <pci_scan_bus>
}
f010813f:	c9                   	leave  
f0108140:	c3                   	ret    

f0108141 <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f0108141:	c7 05 34 bd 5d f0 00 	movl   $0x0,0xf05dbd34
f0108148:	00 00 00 
}
f010814b:	c3                   	ret    

f010814c <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f010814c:	a1 34 bd 5d f0       	mov    0xf05dbd34,%eax
f0108151:	83 c0 01             	add    $0x1,%eax
f0108154:	a3 34 bd 5d f0       	mov    %eax,0xf05dbd34
	if (ticks * 10 < ticks)
f0108159:	8d 14 80             	lea    (%eax,%eax,4),%edx
f010815c:	01 d2                	add    %edx,%edx
f010815e:	39 d0                	cmp    %edx,%eax
f0108160:	77 01                	ja     f0108163 <time_tick+0x17>
f0108162:	c3                   	ret    
{
f0108163:	55                   	push   %ebp
f0108164:	89 e5                	mov    %esp,%ebp
f0108166:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0108169:	68 78 ab 10 f0       	push   $0xf010ab78
f010816e:	6a 13                	push   $0x13
f0108170:	68 93 ab 10 f0       	push   $0xf010ab93
f0108175:	e8 cf 7e ff ff       	call   f0100049 <_panic>

f010817a <time_msec>:
f010817a:	a1 34 bd 5d f0       	mov    0xf05dbd34,%eax
f010817f:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0108182:	01 c0                	add    %eax,%eax
f0108184:	c3                   	ret    
f0108185:	66 90                	xchg   %ax,%ax
f0108187:	66 90                	xchg   %ax,%ax
f0108189:	66 90                	xchg   %ax,%ax
f010818b:	66 90                	xchg   %ax,%ax
f010818d:	66 90                	xchg   %ax,%ax
f010818f:	90                   	nop

f0108190 <__udivdi3>:
f0108190:	55                   	push   %ebp
f0108191:	57                   	push   %edi
f0108192:	56                   	push   %esi
f0108193:	53                   	push   %ebx
f0108194:	83 ec 1c             	sub    $0x1c,%esp
f0108197:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010819b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010819f:	8b 74 24 34          	mov    0x34(%esp),%esi
f01081a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01081a7:	85 d2                	test   %edx,%edx
f01081a9:	75 4d                	jne    f01081f8 <__udivdi3+0x68>
f01081ab:	39 f3                	cmp    %esi,%ebx
f01081ad:	76 19                	jbe    f01081c8 <__udivdi3+0x38>
f01081af:	31 ff                	xor    %edi,%edi
f01081b1:	89 e8                	mov    %ebp,%eax
f01081b3:	89 f2                	mov    %esi,%edx
f01081b5:	f7 f3                	div    %ebx
f01081b7:	89 fa                	mov    %edi,%edx
f01081b9:	83 c4 1c             	add    $0x1c,%esp
f01081bc:	5b                   	pop    %ebx
f01081bd:	5e                   	pop    %esi
f01081be:	5f                   	pop    %edi
f01081bf:	5d                   	pop    %ebp
f01081c0:	c3                   	ret    
f01081c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01081c8:	89 d9                	mov    %ebx,%ecx
f01081ca:	85 db                	test   %ebx,%ebx
f01081cc:	75 0b                	jne    f01081d9 <__udivdi3+0x49>
f01081ce:	b8 01 00 00 00       	mov    $0x1,%eax
f01081d3:	31 d2                	xor    %edx,%edx
f01081d5:	f7 f3                	div    %ebx
f01081d7:	89 c1                	mov    %eax,%ecx
f01081d9:	31 d2                	xor    %edx,%edx
f01081db:	89 f0                	mov    %esi,%eax
f01081dd:	f7 f1                	div    %ecx
f01081df:	89 c6                	mov    %eax,%esi
f01081e1:	89 e8                	mov    %ebp,%eax
f01081e3:	89 f7                	mov    %esi,%edi
f01081e5:	f7 f1                	div    %ecx
f01081e7:	89 fa                	mov    %edi,%edx
f01081e9:	83 c4 1c             	add    $0x1c,%esp
f01081ec:	5b                   	pop    %ebx
f01081ed:	5e                   	pop    %esi
f01081ee:	5f                   	pop    %edi
f01081ef:	5d                   	pop    %ebp
f01081f0:	c3                   	ret    
f01081f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01081f8:	39 f2                	cmp    %esi,%edx
f01081fa:	77 1c                	ja     f0108218 <__udivdi3+0x88>
f01081fc:	0f bd fa             	bsr    %edx,%edi
f01081ff:	83 f7 1f             	xor    $0x1f,%edi
f0108202:	75 2c                	jne    f0108230 <__udivdi3+0xa0>
f0108204:	39 f2                	cmp    %esi,%edx
f0108206:	72 06                	jb     f010820e <__udivdi3+0x7e>
f0108208:	31 c0                	xor    %eax,%eax
f010820a:	39 eb                	cmp    %ebp,%ebx
f010820c:	77 a9                	ja     f01081b7 <__udivdi3+0x27>
f010820e:	b8 01 00 00 00       	mov    $0x1,%eax
f0108213:	eb a2                	jmp    f01081b7 <__udivdi3+0x27>
f0108215:	8d 76 00             	lea    0x0(%esi),%esi
f0108218:	31 ff                	xor    %edi,%edi
f010821a:	31 c0                	xor    %eax,%eax
f010821c:	89 fa                	mov    %edi,%edx
f010821e:	83 c4 1c             	add    $0x1c,%esp
f0108221:	5b                   	pop    %ebx
f0108222:	5e                   	pop    %esi
f0108223:	5f                   	pop    %edi
f0108224:	5d                   	pop    %ebp
f0108225:	c3                   	ret    
f0108226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010822d:	8d 76 00             	lea    0x0(%esi),%esi
f0108230:	89 f9                	mov    %edi,%ecx
f0108232:	b8 20 00 00 00       	mov    $0x20,%eax
f0108237:	29 f8                	sub    %edi,%eax
f0108239:	d3 e2                	shl    %cl,%edx
f010823b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010823f:	89 c1                	mov    %eax,%ecx
f0108241:	89 da                	mov    %ebx,%edx
f0108243:	d3 ea                	shr    %cl,%edx
f0108245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0108249:	09 d1                	or     %edx,%ecx
f010824b:	89 f2                	mov    %esi,%edx
f010824d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0108251:	89 f9                	mov    %edi,%ecx
f0108253:	d3 e3                	shl    %cl,%ebx
f0108255:	89 c1                	mov    %eax,%ecx
f0108257:	d3 ea                	shr    %cl,%edx
f0108259:	89 f9                	mov    %edi,%ecx
f010825b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010825f:	89 eb                	mov    %ebp,%ebx
f0108261:	d3 e6                	shl    %cl,%esi
f0108263:	89 c1                	mov    %eax,%ecx
f0108265:	d3 eb                	shr    %cl,%ebx
f0108267:	09 de                	or     %ebx,%esi
f0108269:	89 f0                	mov    %esi,%eax
f010826b:	f7 74 24 08          	divl   0x8(%esp)
f010826f:	89 d6                	mov    %edx,%esi
f0108271:	89 c3                	mov    %eax,%ebx
f0108273:	f7 64 24 0c          	mull   0xc(%esp)
f0108277:	39 d6                	cmp    %edx,%esi
f0108279:	72 15                	jb     f0108290 <__udivdi3+0x100>
f010827b:	89 f9                	mov    %edi,%ecx
f010827d:	d3 e5                	shl    %cl,%ebp
f010827f:	39 c5                	cmp    %eax,%ebp
f0108281:	73 04                	jae    f0108287 <__udivdi3+0xf7>
f0108283:	39 d6                	cmp    %edx,%esi
f0108285:	74 09                	je     f0108290 <__udivdi3+0x100>
f0108287:	89 d8                	mov    %ebx,%eax
f0108289:	31 ff                	xor    %edi,%edi
f010828b:	e9 27 ff ff ff       	jmp    f01081b7 <__udivdi3+0x27>
f0108290:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0108293:	31 ff                	xor    %edi,%edi
f0108295:	e9 1d ff ff ff       	jmp    f01081b7 <__udivdi3+0x27>
f010829a:	66 90                	xchg   %ax,%ax
f010829c:	66 90                	xchg   %ax,%ax
f010829e:	66 90                	xchg   %ax,%ax

f01082a0 <__umoddi3>:
f01082a0:	55                   	push   %ebp
f01082a1:	57                   	push   %edi
f01082a2:	56                   	push   %esi
f01082a3:	53                   	push   %ebx
f01082a4:	83 ec 1c             	sub    $0x1c,%esp
f01082a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01082ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01082af:	8b 74 24 30          	mov    0x30(%esp),%esi
f01082b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01082b7:	89 da                	mov    %ebx,%edx
f01082b9:	85 c0                	test   %eax,%eax
f01082bb:	75 43                	jne    f0108300 <__umoddi3+0x60>
f01082bd:	39 df                	cmp    %ebx,%edi
f01082bf:	76 17                	jbe    f01082d8 <__umoddi3+0x38>
f01082c1:	89 f0                	mov    %esi,%eax
f01082c3:	f7 f7                	div    %edi
f01082c5:	89 d0                	mov    %edx,%eax
f01082c7:	31 d2                	xor    %edx,%edx
f01082c9:	83 c4 1c             	add    $0x1c,%esp
f01082cc:	5b                   	pop    %ebx
f01082cd:	5e                   	pop    %esi
f01082ce:	5f                   	pop    %edi
f01082cf:	5d                   	pop    %ebp
f01082d0:	c3                   	ret    
f01082d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01082d8:	89 fd                	mov    %edi,%ebp
f01082da:	85 ff                	test   %edi,%edi
f01082dc:	75 0b                	jne    f01082e9 <__umoddi3+0x49>
f01082de:	b8 01 00 00 00       	mov    $0x1,%eax
f01082e3:	31 d2                	xor    %edx,%edx
f01082e5:	f7 f7                	div    %edi
f01082e7:	89 c5                	mov    %eax,%ebp
f01082e9:	89 d8                	mov    %ebx,%eax
f01082eb:	31 d2                	xor    %edx,%edx
f01082ed:	f7 f5                	div    %ebp
f01082ef:	89 f0                	mov    %esi,%eax
f01082f1:	f7 f5                	div    %ebp
f01082f3:	89 d0                	mov    %edx,%eax
f01082f5:	eb d0                	jmp    f01082c7 <__umoddi3+0x27>
f01082f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01082fe:	66 90                	xchg   %ax,%ax
f0108300:	89 f1                	mov    %esi,%ecx
f0108302:	39 d8                	cmp    %ebx,%eax
f0108304:	76 0a                	jbe    f0108310 <__umoddi3+0x70>
f0108306:	89 f0                	mov    %esi,%eax
f0108308:	83 c4 1c             	add    $0x1c,%esp
f010830b:	5b                   	pop    %ebx
f010830c:	5e                   	pop    %esi
f010830d:	5f                   	pop    %edi
f010830e:	5d                   	pop    %ebp
f010830f:	c3                   	ret    
f0108310:	0f bd e8             	bsr    %eax,%ebp
f0108313:	83 f5 1f             	xor    $0x1f,%ebp
f0108316:	75 20                	jne    f0108338 <__umoddi3+0x98>
f0108318:	39 d8                	cmp    %ebx,%eax
f010831a:	0f 82 b0 00 00 00    	jb     f01083d0 <__umoddi3+0x130>
f0108320:	39 f7                	cmp    %esi,%edi
f0108322:	0f 86 a8 00 00 00    	jbe    f01083d0 <__umoddi3+0x130>
f0108328:	89 c8                	mov    %ecx,%eax
f010832a:	83 c4 1c             	add    $0x1c,%esp
f010832d:	5b                   	pop    %ebx
f010832e:	5e                   	pop    %esi
f010832f:	5f                   	pop    %edi
f0108330:	5d                   	pop    %ebp
f0108331:	c3                   	ret    
f0108332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0108338:	89 e9                	mov    %ebp,%ecx
f010833a:	ba 20 00 00 00       	mov    $0x20,%edx
f010833f:	29 ea                	sub    %ebp,%edx
f0108341:	d3 e0                	shl    %cl,%eax
f0108343:	89 44 24 08          	mov    %eax,0x8(%esp)
f0108347:	89 d1                	mov    %edx,%ecx
f0108349:	89 f8                	mov    %edi,%eax
f010834b:	d3 e8                	shr    %cl,%eax
f010834d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0108351:	89 54 24 04          	mov    %edx,0x4(%esp)
f0108355:	8b 54 24 04          	mov    0x4(%esp),%edx
f0108359:	09 c1                	or     %eax,%ecx
f010835b:	89 d8                	mov    %ebx,%eax
f010835d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0108361:	89 e9                	mov    %ebp,%ecx
f0108363:	d3 e7                	shl    %cl,%edi
f0108365:	89 d1                	mov    %edx,%ecx
f0108367:	d3 e8                	shr    %cl,%eax
f0108369:	89 e9                	mov    %ebp,%ecx
f010836b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010836f:	d3 e3                	shl    %cl,%ebx
f0108371:	89 c7                	mov    %eax,%edi
f0108373:	89 d1                	mov    %edx,%ecx
f0108375:	89 f0                	mov    %esi,%eax
f0108377:	d3 e8                	shr    %cl,%eax
f0108379:	89 e9                	mov    %ebp,%ecx
f010837b:	89 fa                	mov    %edi,%edx
f010837d:	d3 e6                	shl    %cl,%esi
f010837f:	09 d8                	or     %ebx,%eax
f0108381:	f7 74 24 08          	divl   0x8(%esp)
f0108385:	89 d1                	mov    %edx,%ecx
f0108387:	89 f3                	mov    %esi,%ebx
f0108389:	f7 64 24 0c          	mull   0xc(%esp)
f010838d:	89 c6                	mov    %eax,%esi
f010838f:	89 d7                	mov    %edx,%edi
f0108391:	39 d1                	cmp    %edx,%ecx
f0108393:	72 06                	jb     f010839b <__umoddi3+0xfb>
f0108395:	75 10                	jne    f01083a7 <__umoddi3+0x107>
f0108397:	39 c3                	cmp    %eax,%ebx
f0108399:	73 0c                	jae    f01083a7 <__umoddi3+0x107>
f010839b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010839f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01083a3:	89 d7                	mov    %edx,%edi
f01083a5:	89 c6                	mov    %eax,%esi
f01083a7:	89 ca                	mov    %ecx,%edx
f01083a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01083ae:	29 f3                	sub    %esi,%ebx
f01083b0:	19 fa                	sbb    %edi,%edx
f01083b2:	89 d0                	mov    %edx,%eax
f01083b4:	d3 e0                	shl    %cl,%eax
f01083b6:	89 e9                	mov    %ebp,%ecx
f01083b8:	d3 eb                	shr    %cl,%ebx
f01083ba:	d3 ea                	shr    %cl,%edx
f01083bc:	09 d8                	or     %ebx,%eax
f01083be:	83 c4 1c             	add    $0x1c,%esp
f01083c1:	5b                   	pop    %ebx
f01083c2:	5e                   	pop    %esi
f01083c3:	5f                   	pop    %edi
f01083c4:	5d                   	pop    %ebp
f01083c5:	c3                   	ret    
f01083c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01083cd:	8d 76 00             	lea    0x0(%esi),%esi
f01083d0:	89 da                	mov    %ebx,%edx
f01083d2:	29 fe                	sub    %edi,%esi
f01083d4:	19 c2                	sbb    %eax,%edx
f01083d6:	89 f1                	mov    %esi,%ecx
f01083d8:	89 c8                	mov    %ecx,%eax
f01083da:	e9 4b ff ff ff       	jmp    f010832a <__umoddi3+0x8a>

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
f0121010:	68 98 99 10 f0       	push   $0xf0109998
f0121015:	68 03 03 00 00       	push   $0x303
f012101a:	68 a4 99 10 f0       	push   $0xf01099a4
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
f0121033:	8b 1d 68 a0 12 f0    	mov    0xf012a068,%ebx
f0121039:	8d b3 00 10 02 00    	lea    0x21000(%ebx),%esi
	if (PGNUM(pa) >= npages)
f012103f:	a1 48 cd 5d f0       	mov    0xf05dcd48,%eax
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
f01210b3:	68 34 9b 10 f0       	push   $0xf0109b34
f01210b8:	68 d9 02 00 00       	push   $0x2d9
f01210bd:	68 a4 99 10 f0       	push   $0xf01099a4
f01210c2:	e8 82 ef fd ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01210c7:	52                   	push   %edx
f01210c8:	68 34 84 10 f0       	push   $0xf0108434
f01210cd:	68 db 02 00 00       	push   $0x2db
f01210d2:	68 a4 99 10 f0       	push   $0xf01099a4
f01210d7:	e8 6d ef fd ff       	call   f0100049 <_panic>
					panic("User page table has kernel address %08x mapped", va);
f01210dc:	50                   	push   %eax
f01210dd:	68 34 9b 10 f0       	push   $0xf0109b34
f01210e2:	68 dd 02 00 00       	push   $0x2dd
f01210e7:	68 a4 99 10 f0       	push   $0xf01099a4
f01210ec:	e8 58 ef fd ff       	call   f0100049 <_panic>
	check_user_map(pgdir, gdt, sizeof(gdt), "GDT");
f01210f1:	83 ec 0c             	sub    $0xc,%esp
f01210f4:	68 99 9a 10 f0       	push   $0xf0109a99
f01210f9:	b9 68 00 00 00       	mov    $0x68,%ecx
f01210fe:	ba 00 a0 12 f0       	mov    $0xf012a000,%edx
f0121103:	89 f8                	mov    %edi,%eax
f0121105:	e8 02 24 fe ff       	call   f010350c <check_user_map>
	check_user_map(pgdir, (void *) idt_pd.pd_base, idt_pd.pd_lim, "IDT");
f012110a:	0f b7 0d 10 d3 16 f0 	movzwl 0xf016d310,%ecx
f0121111:	c7 04 24 9d 9a 10 f0 	movl   $0xf0109a9d,(%esp)
f0121118:	8b 15 12 d3 16 f0    	mov    0xf016d312,%edx
f012111e:	89 f8                	mov    %edi,%eax
f0121120:	e8 e7 23 fe ff       	call   f010350c <check_user_map>
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
f0121176:	e8 91 23 fe ff       	call   f010350c <check_user_map>
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
f01211b1:	e8 56 23 fe ff       	call   f010350c <check_user_map>
f01211b6:	83 c3 01             	add    $0x1,%ebx
f01211b9:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (int i = 0; i < NCPU; i++) {
f01211bf:	83 c4 10             	add    $0x10,%esp
f01211c2:	80 fb 38             	cmp    $0x38,%bl
f01211c5:	75 c9                	jne    f0121190 <env_run+0x16c>
	check_user_map(pgdir, env_pop_tf, sizeof(env_pop_tf), "env_pop_tf");
f01211c7:	83 ec 0c             	sub    $0xc,%esp
f01211ca:	68 a1 9a 10 f0       	push   $0xf0109aa1
f01211cf:	b9 01 00 00 00       	mov    $0x1,%ecx
f01211d4:	ba 00 10 12 f0       	mov    $0xf0121000,%edx
f01211d9:	89 f8                	mov    %edi,%eax
f01211db:	e8 2c 23 fe ff       	call   f010350c <check_user_map>
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f01211e0:	e8 31 61 fe ff       	call   f0107316 <cpunum>
f01211e5:	6b c0 74             	imul   $0x74,%eax,%eax
f01211e8:	83 c4 10             	add    $0x10,%esp
f01211eb:	8b 75 08             	mov    0x8(%ebp),%esi
f01211ee:	39 b0 28 b0 16 f0    	cmp    %esi,-0xfe94fd8(%eax)
f01211f4:	74 61                	je     f0121257 <env_run+0x233>
		if(curenv && curenv->env_status == ENV_RUNNING)
f01211f6:	e8 1b 61 fe ff       	call   f0107316 <cpunum>
f01211fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01211fe:	83 b8 28 b0 16 f0 00 	cmpl   $0x0,-0xfe94fd8(%eax)
f0121205:	74 18                	je     f012121f <env_run+0x1fb>
f0121207:	e8 0a 61 fe ff       	call   f0107316 <cpunum>
f012120c:	6b c0 74             	imul   $0x74,%eax,%eax
f012120f:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121215:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0121219:	0f 84 8e 00 00 00    	je     f01212ad <env_run+0x289>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f012121f:	e8 f2 60 fe ff       	call   f0107316 <cpunum>
f0121224:	6b c0 74             	imul   $0x74,%eax,%eax
f0121227:	8b 75 08             	mov    0x8(%ebp),%esi
f012122a:	89 b0 28 b0 16 f0    	mov    %esi,-0xfe94fd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0121230:	e8 e1 60 fe ff       	call   f0107316 <cpunum>
f0121235:	6b c0 74             	imul   $0x74,%eax,%eax
f0121238:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f012123e:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0121245:	e8 cc 60 fe ff       	call   f0107316 <cpunum>
f012124a:	6b c0 74             	imul   $0x74,%eax,%eax
f012124d:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f0121253:	83 40 58 01          	addl   $0x1,0x58(%eax)
		// lcr3(PADDR(curenv->env_pgdir));
	}
	// lcr3(PADDR(curenv->env_pgdir));
	// cprintf("the env to run is %d\n", curenv->env_id);
	trapframe = curenv->env_tf;
f0121257:	e8 ba 60 fe ff       	call   f0107316 <cpunum>
f012125c:	6b c0 74             	imul   $0x74,%eax,%eax
f012125f:	8b b0 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%esi
f0121265:	8d 7d a4             	lea    -0x5c(%ebp),%edi
f0121268:	b9 11 00 00 00       	mov    $0x11,%ecx
f012126d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	spin_unlock(&kernel_lock);
f012126f:	83 ec 0c             	sub    $0xc,%esp
f0121272:	68 20 d3 16 f0       	push   $0xf016d320
f0121277:	e8 a6 63 fe ff       	call   f0107622 <spin_unlock>
	asm volatile("pause");
f012127c:	f3 90                	pause  

	unlock_kernel(); //lab4 bug?
	lcr3(PADDR(curenv->env_pgdir));
f012127e:	e8 93 60 fe ff       	call   f0107316 <cpunum>
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
f01212ad:	e8 64 60 fe ff       	call   f0107316 <cpunum>
f01212b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01212b5:	8b 80 28 b0 16 f0    	mov    -0xfe94fd8(%eax),%eax
f01212bb:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f01212c2:	e9 58 ff ff ff       	jmp    f012121f <env_run+0x1fb>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01212c7:	50                   	push   %eax
f01212c8:	68 58 84 10 f0       	push   $0xf0108458
f01212cd:	68 3d 03 00 00       	push   $0x33d
f01212d2:	68 a4 99 10 f0       	push   $0xf01099a4
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
f012131d:	e8 70 3d fe ff       	call   f0105092 <trap>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0121322:	50                   	push   %eax
f0121323:	68 58 84 10 f0       	push   $0xf0108458
f0121328:	68 19 02 00 00       	push   $0x219
f012132d:	68 3c 9d 10 f0       	push   $0xf0109d3c
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
f012145a:	e8 ae 41 fe ff       	call   f010560d <syscall>
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

f012a068 <envs>:
f012a068:	00 00 00 00 66 90 66 90 66 90 66 90 66 90 66 90     ....f.f.f.f.f.f.
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
