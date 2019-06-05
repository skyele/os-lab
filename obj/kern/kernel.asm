
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
f0100015:	b8 00 60 12 00       	mov    $0x126000,%eax
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
f010003d:	bc 00 60 12 f0       	mov    $0xf0126000,%esp

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
f0100051:	83 3d a0 be 57 f0 00 	cmpl   $0x0,0xf057bea0
f0100058:	74 0f                	je     f0100069 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010005a:	83 ec 0c             	sub    $0xc,%esp
f010005d:	6a 00                	push   $0x0
f010005f:	e8 fc 0b 00 00       	call   f0100c60 <monitor>
f0100064:	83 c4 10             	add    $0x10,%esp
f0100067:	eb f1                	jmp    f010005a <_panic+0x11>
	panicstr = fmt;
f0100069:	89 35 a0 be 57 f0    	mov    %esi,0xf057bea0
	asm volatile("cli; cld");
f010006f:	fa                   	cli    
f0100070:	fc                   	cld    
	va_start(ap, fmt);
f0100071:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100074:	e8 41 6a 00 00       	call   f0106aba <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 60 78 10 f0       	push   $0xf0107860
f0100085:	e8 e5 3d 00 00       	call   f0103e6f <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 b5 3d 00 00       	call   f0103e49 <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 5b 8d 10 f0 	movl   $0xf0108d5b,(%esp)
f010009b:	e8 cf 3d 00 00       	call   f0103e6f <cprintf>
f01000a0:	83 c4 10             	add    $0x10,%esp
f01000a3:	eb b5                	jmp    f010005a <_panic+0x11>

f01000a5 <i386_init>:
{
f01000a5:	55                   	push   %ebp
f01000a6:	89 e5                	mov    %esp,%ebp
f01000a8:	53                   	push   %ebx
f01000a9:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000ac:	e8 cb 05 00 00       	call   f010067c <cons_init>
	cprintf("pading space in the right to number 22: %-8d.\n", 22);
f01000b1:	83 ec 08             	sub    $0x8,%esp
f01000b4:	6a 16                	push   $0x16
f01000b6:	68 84 78 10 f0       	push   $0xf0107884
f01000bb:	e8 af 3d 00 00       	call   f0103e6f <cprintf>
	cprintf("%n", NULL);
f01000c0:	83 c4 08             	add    $0x8,%esp
f01000c3:	6a 00                	push   $0x0
f01000c5:	68 fc 78 10 f0       	push   $0xf01078fc
f01000ca:	e8 a0 3d 00 00       	call   f0103e6f <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000cf:	83 c4 0c             	add    $0xc,%esp
f01000d2:	68 00 fc ff ff       	push   $0xfffffc00
f01000d7:	68 00 04 00 00       	push   $0x400
f01000dc:	68 ff 78 10 f0       	push   $0xf01078ff
f01000e1:	e8 89 3d 00 00       	call   f0103e6f <cprintf>
	mem_init();
f01000e6:	e8 66 16 00 00       	call   f0101751 <mem_init>
	env_init();
f01000eb:	e8 13 35 00 00       	call   f0103603 <env_init>
	trap_init();
f01000f0:	e8 5e 3e 00 00       	call   f0103f53 <trap_init>
	mp_init();
f01000f5:	e8 c9 66 00 00       	call   f01067c3 <mp_init>
	lapic_init();
f01000fa:	e8 d1 69 00 00       	call   f0106ad0 <lapic_init>
	pic_init();
f01000ff:	e8 70 3c 00 00       	call   f0103d74 <pic_init>
	time_init();
f0100104:	e8 c3 74 00 00       	call   f01075cc <time_init>
	pci_init();
f0100109:	e8 9e 74 00 00       	call   f01075ac <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010010e:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f0100115:	e8 10 6c 00 00       	call   f0106d2a <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010011a:	83 c4 10             	add    $0x10,%esp
f010011d:	83 3d a8 be 57 f0 07 	cmpl   $0x7,0xf057bea8
f0100124:	76 27                	jbe    f010014d <i386_init+0xa8>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100126:	83 ec 04             	sub    $0x4,%esp
f0100129:	b8 26 67 10 f0       	mov    $0xf0106726,%eax
f010012e:	2d a4 66 10 f0       	sub    $0xf01066a4,%eax
f0100133:	50                   	push   %eax
f0100134:	68 a4 66 10 f0       	push   $0xf01066a4
f0100139:	68 00 70 00 f0       	push   $0xf0007000
f010013e:	e8 b8 63 00 00       	call   f01064fb <memmove>
f0100143:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100146:	bb 20 c0 57 f0       	mov    $0xf057c020,%ebx
f010014b:	eb 19                	jmp    f0100166 <i386_init+0xc1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010014d:	68 00 70 00 00       	push   $0x7000
f0100152:	68 b4 78 10 f0       	push   $0xf01078b4
f0100157:	6a 66                	push   $0x66
f0100159:	68 1b 79 10 f0       	push   $0xf010791b
f010015e:	e8 e6 fe ff ff       	call   f0100049 <_panic>
f0100163:	83 c3 74             	add    $0x74,%ebx
f0100166:	6b 05 c4 c3 57 f0 74 	imul   $0x74,0xf057c3c4,%eax
f010016d:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0100172:	39 c3                	cmp    %eax,%ebx
f0100174:	73 4d                	jae    f01001c3 <i386_init+0x11e>
		if (c == cpus + cpunum())  // We've started already.
f0100176:	e8 3f 69 00 00       	call   f0106aba <cpunum>
f010017b:	6b c0 74             	imul   $0x74,%eax,%eax
f010017e:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0100183:	39 c3                	cmp    %eax,%ebx
f0100185:	74 dc                	je     f0100163 <i386_init+0xbe>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100187:	89 d8                	mov    %ebx,%eax
f0100189:	2d 20 c0 57 f0       	sub    $0xf057c020,%eax
f010018e:	c1 f8 02             	sar    $0x2,%eax
f0100191:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100197:	c1 e0 0f             	shl    $0xf,%eax
f010019a:	8d 80 00 50 58 f0    	lea    -0xfa7b000(%eax),%eax
f01001a0:	a3 a4 be 57 f0       	mov    %eax,0xf057bea4
		lapic_startap(c->cpu_id, PADDR(code));
f01001a5:	83 ec 08             	sub    $0x8,%esp
f01001a8:	68 00 70 00 00       	push   $0x7000
f01001ad:	0f b6 03             	movzbl (%ebx),%eax
f01001b0:	50                   	push   %eax
f01001b1:	e8 6c 6a 00 00       	call   f0106c22 <lapic_startap>
f01001b6:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f01001b9:	8b 43 04             	mov    0x4(%ebx),%eax
f01001bc:	83 f8 01             	cmp    $0x1,%eax
f01001bf:	75 f8                	jne    f01001b9 <i386_init+0x114>
f01001c1:	eb a0                	jmp    f0100163 <i386_init+0xbe>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001c3:	83 ec 08             	sub    $0x8,%esp
f01001c6:	6a 01                	push   $0x1
f01001c8:	68 14 ea 3e f0       	push   $0xf03eea14
f01001cd:	e8 03 36 00 00       	call   f01037d5 <env_create>
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f01001d2:	83 c4 08             	add    $0x8,%esp
f01001d5:	6a 02                	push   $0x2
f01001d7:	68 84 57 48 f0       	push   $0xf0485784
f01001dc:	e8 f4 35 00 00       	call   f01037d5 <env_create>
	ENV_CREATE(user_icode, ENV_TYPE_USER);//lab5 bug just test
f01001e1:	83 c4 08             	add    $0x8,%esp
f01001e4:	6a 00                	push   $0x0
f01001e6:	68 64 a7 3d f0       	push   $0xf03da764
f01001eb:	e8 e5 35 00 00       	call   f01037d5 <env_create>
	kbd_intr();
f01001f0:	e8 32 04 00 00       	call   f0100627 <kbd_intr>
	sched_yield();
f01001f5:	e8 22 4c 00 00       	call   f0104e1c <sched_yield>

f01001fa <mp_main>:
{
f01001fa:	55                   	push   %ebp
f01001fb:	89 e5                	mov    %esp,%ebp
f01001fd:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f0100200:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f0100205:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010020a:	76 52                	jbe    f010025e <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f010020c:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100211:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100214:	e8 a1 68 00 00       	call   f0106aba <cpunum>
f0100219:	83 ec 08             	sub    $0x8,%esp
f010021c:	50                   	push   %eax
f010021d:	68 27 79 10 f0       	push   $0xf0107927
f0100222:	e8 48 3c 00 00       	call   f0103e6f <cprintf>
	lapic_init();
f0100227:	e8 a4 68 00 00       	call   f0106ad0 <lapic_init>
	env_init_percpu();
f010022c:	e8 a6 33 00 00       	call   f01035d7 <env_init_percpu>
	trap_init_percpu();
f0100231:	e8 4d 3c 00 00       	call   f0103e83 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100236:	e8 7f 68 00 00       	call   f0106aba <cpunum>
f010023b:	6b d0 74             	imul   $0x74,%eax,%edx
f010023e:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100241:	b8 01 00 00 00       	mov    $0x1,%eax
f0100246:	f0 87 82 20 c0 57 f0 	lock xchg %eax,-0xfa83fe0(%edx)
f010024d:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f0100254:	e8 d1 6a 00 00       	call   f0106d2a <spin_lock>
	sched_yield();
f0100259:	e8 be 4b 00 00       	call   f0104e1c <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010025e:	50                   	push   %eax
f010025f:	68 d8 78 10 f0       	push   $0xf01078d8
f0100264:	6a 7e                	push   $0x7e
f0100266:	68 1b 79 10 f0       	push   $0xf010791b
f010026b:	e8 d9 fd ff ff       	call   f0100049 <_panic>

f0100270 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100270:	55                   	push   %ebp
f0100271:	89 e5                	mov    %esp,%ebp
f0100273:	53                   	push   %ebx
f0100274:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100277:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010027a:	ff 75 0c             	pushl  0xc(%ebp)
f010027d:	ff 75 08             	pushl  0x8(%ebp)
f0100280:	68 3d 79 10 f0       	push   $0xf010793d
f0100285:	e8 e5 3b 00 00       	call   f0103e6f <cprintf>
	vcprintf(fmt, ap);
f010028a:	83 c4 08             	add    $0x8,%esp
f010028d:	53                   	push   %ebx
f010028e:	ff 75 10             	pushl  0x10(%ebp)
f0100291:	e8 b3 3b 00 00       	call   f0103e49 <vcprintf>
	cprintf("\n");
f0100296:	c7 04 24 5b 8d 10 f0 	movl   $0xf0108d5b,(%esp)
f010029d:	e8 cd 3b 00 00       	call   f0103e6f <cprintf>
	va_end(ap);
}
f01002a2:	83 c4 10             	add    $0x10,%esp
f01002a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002a8:	c9                   	leave  
f01002a9:	c3                   	ret    

f01002aa <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002aa:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002af:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002b0:	a8 01                	test   $0x1,%al
f01002b2:	74 0a                	je     f01002be <serial_proc_data+0x14>
f01002b4:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002b9:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01002ba:	0f b6 c0             	movzbl %al,%eax
f01002bd:	c3                   	ret    
		return -1;
f01002be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01002c3:	c3                   	ret    

f01002c4 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01002c4:	55                   	push   %ebp
f01002c5:	89 e5                	mov    %esp,%ebp
f01002c7:	53                   	push   %ebx
f01002c8:	83 ec 04             	sub    $0x4,%esp
f01002cb:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002cd:	ff d3                	call   *%ebx
f01002cf:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002d2:	74 29                	je     f01002fd <cons_intr+0x39>
		if (c == 0)
f01002d4:	85 c0                	test   %eax,%eax
f01002d6:	74 f5                	je     f01002cd <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002d8:	8b 0d 24 a2 57 f0    	mov    0xf057a224,%ecx
f01002de:	8d 51 01             	lea    0x1(%ecx),%edx
f01002e1:	88 81 20 a0 57 f0    	mov    %al,-0xfa85fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002e7:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002ed:	b8 00 00 00 00       	mov    $0x0,%eax
f01002f2:	0f 44 d0             	cmove  %eax,%edx
f01002f5:	89 15 24 a2 57 f0    	mov    %edx,0xf057a224
f01002fb:	eb d0                	jmp    f01002cd <cons_intr+0x9>
	}
}
f01002fd:	83 c4 04             	add    $0x4,%esp
f0100300:	5b                   	pop    %ebx
f0100301:	5d                   	pop    %ebp
f0100302:	c3                   	ret    

f0100303 <kbd_proc_data>:
{
f0100303:	55                   	push   %ebp
f0100304:	89 e5                	mov    %esp,%ebp
f0100306:	53                   	push   %ebx
f0100307:	83 ec 04             	sub    $0x4,%esp
f010030a:	ba 64 00 00 00       	mov    $0x64,%edx
f010030f:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f0100310:	a8 01                	test   $0x1,%al
f0100312:	0f 84 f2 00 00 00    	je     f010040a <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f0100318:	a8 20                	test   $0x20,%al
f010031a:	0f 85 f1 00 00 00    	jne    f0100411 <kbd_proc_data+0x10e>
f0100320:	ba 60 00 00 00       	mov    $0x60,%edx
f0100325:	ec                   	in     (%dx),%al
f0100326:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100328:	3c e0                	cmp    $0xe0,%al
f010032a:	74 61                	je     f010038d <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f010032c:	84 c0                	test   %al,%al
f010032e:	78 70                	js     f01003a0 <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f0100330:	8b 0d 00 a0 57 f0    	mov    0xf057a000,%ecx
f0100336:	f6 c1 40             	test   $0x40,%cl
f0100339:	74 0e                	je     f0100349 <kbd_proc_data+0x46>
		data |= 0x80;
f010033b:	83 c8 80             	or     $0xffffff80,%eax
f010033e:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100340:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100343:	89 0d 00 a0 57 f0    	mov    %ecx,0xf057a000
	shift |= shiftcode[data];
f0100349:	0f b6 d2             	movzbl %dl,%edx
f010034c:	0f b6 82 a0 7a 10 f0 	movzbl -0xfef8560(%edx),%eax
f0100353:	0b 05 00 a0 57 f0    	or     0xf057a000,%eax
	shift ^= togglecode[data];
f0100359:	0f b6 8a a0 79 10 f0 	movzbl -0xfef8660(%edx),%ecx
f0100360:	31 c8                	xor    %ecx,%eax
f0100362:	a3 00 a0 57 f0       	mov    %eax,0xf057a000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100367:	89 c1                	mov    %eax,%ecx
f0100369:	83 e1 03             	and    $0x3,%ecx
f010036c:	8b 0c 8d 80 79 10 f0 	mov    -0xfef8680(,%ecx,4),%ecx
f0100373:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100377:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010037a:	a8 08                	test   $0x8,%al
f010037c:	74 61                	je     f01003df <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f010037e:	89 da                	mov    %ebx,%edx
f0100380:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100383:	83 f9 19             	cmp    $0x19,%ecx
f0100386:	77 4b                	ja     f01003d3 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f0100388:	83 eb 20             	sub    $0x20,%ebx
f010038b:	eb 0c                	jmp    f0100399 <kbd_proc_data+0x96>
		shift |= E0ESC;
f010038d:	83 0d 00 a0 57 f0 40 	orl    $0x40,0xf057a000
		return 0;
f0100394:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100399:	89 d8                	mov    %ebx,%eax
f010039b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010039e:	c9                   	leave  
f010039f:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003a0:	8b 0d 00 a0 57 f0    	mov    0xf057a000,%ecx
f01003a6:	89 cb                	mov    %ecx,%ebx
f01003a8:	83 e3 40             	and    $0x40,%ebx
f01003ab:	83 e0 7f             	and    $0x7f,%eax
f01003ae:	85 db                	test   %ebx,%ebx
f01003b0:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003b3:	0f b6 d2             	movzbl %dl,%edx
f01003b6:	0f b6 82 a0 7a 10 f0 	movzbl -0xfef8560(%edx),%eax
f01003bd:	83 c8 40             	or     $0x40,%eax
f01003c0:	0f b6 c0             	movzbl %al,%eax
f01003c3:	f7 d0                	not    %eax
f01003c5:	21 c8                	and    %ecx,%eax
f01003c7:	a3 00 a0 57 f0       	mov    %eax,0xf057a000
		return 0;
f01003cc:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003d1:	eb c6                	jmp    f0100399 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f01003d3:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003d6:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003d9:	83 fa 1a             	cmp    $0x1a,%edx
f01003dc:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003df:	f7 d0                	not    %eax
f01003e1:	a8 06                	test   $0x6,%al
f01003e3:	75 b4                	jne    f0100399 <kbd_proc_data+0x96>
f01003e5:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003eb:	75 ac                	jne    f0100399 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f01003ed:	83 ec 0c             	sub    $0xc,%esp
f01003f0:	68 57 79 10 f0       	push   $0xf0107957
f01003f5:	e8 75 3a 00 00       	call   f0103e6f <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003fa:	b8 03 00 00 00       	mov    $0x3,%eax
f01003ff:	ba 92 00 00 00       	mov    $0x92,%edx
f0100404:	ee                   	out    %al,(%dx)
f0100405:	83 c4 10             	add    $0x10,%esp
f0100408:	eb 8f                	jmp    f0100399 <kbd_proc_data+0x96>
		return -1;
f010040a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010040f:	eb 88                	jmp    f0100399 <kbd_proc_data+0x96>
		return -1;
f0100411:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100416:	eb 81                	jmp    f0100399 <kbd_proc_data+0x96>

f0100418 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100418:	55                   	push   %ebp
f0100419:	89 e5                	mov    %esp,%ebp
f010041b:	57                   	push   %edi
f010041c:	56                   	push   %esi
f010041d:	53                   	push   %ebx
f010041e:	83 ec 1c             	sub    $0x1c,%esp
f0100421:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f0100423:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100428:	bf fd 03 00 00       	mov    $0x3fd,%edi
f010042d:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100432:	89 fa                	mov    %edi,%edx
f0100434:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100435:	a8 20                	test   $0x20,%al
f0100437:	75 13                	jne    f010044c <cons_putc+0x34>
f0100439:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010043f:	7f 0b                	jg     f010044c <cons_putc+0x34>
f0100441:	89 da                	mov    %ebx,%edx
f0100443:	ec                   	in     (%dx),%al
f0100444:	ec                   	in     (%dx),%al
f0100445:	ec                   	in     (%dx),%al
f0100446:	ec                   	in     (%dx),%al
	     i++)
f0100447:	83 c6 01             	add    $0x1,%esi
f010044a:	eb e6                	jmp    f0100432 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f010044c:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010044f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100454:	89 c8                	mov    %ecx,%eax
f0100456:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100457:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010045c:	bf 79 03 00 00       	mov    $0x379,%edi
f0100461:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100466:	89 fa                	mov    %edi,%edx
f0100468:	ec                   	in     (%dx),%al
f0100469:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010046f:	7f 0f                	jg     f0100480 <cons_putc+0x68>
f0100471:	84 c0                	test   %al,%al
f0100473:	78 0b                	js     f0100480 <cons_putc+0x68>
f0100475:	89 da                	mov    %ebx,%edx
f0100477:	ec                   	in     (%dx),%al
f0100478:	ec                   	in     (%dx),%al
f0100479:	ec                   	in     (%dx),%al
f010047a:	ec                   	in     (%dx),%al
f010047b:	83 c6 01             	add    $0x1,%esi
f010047e:	eb e6                	jmp    f0100466 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100480:	ba 78 03 00 00       	mov    $0x378,%edx
f0100485:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100489:	ee                   	out    %al,(%dx)
f010048a:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010048f:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100494:	ee                   	out    %al,(%dx)
f0100495:	b8 08 00 00 00       	mov    $0x8,%eax
f010049a:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010049b:	89 ca                	mov    %ecx,%edx
f010049d:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f01004a3:	89 c8                	mov    %ecx,%eax
f01004a5:	80 cc 07             	or     $0x7,%ah
f01004a8:	85 d2                	test   %edx,%edx
f01004aa:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f01004ad:	0f b6 c1             	movzbl %cl,%eax
f01004b0:	83 f8 09             	cmp    $0x9,%eax
f01004b3:	0f 84 b0 00 00 00    	je     f0100569 <cons_putc+0x151>
f01004b9:	7e 73                	jle    f010052e <cons_putc+0x116>
f01004bb:	83 f8 0a             	cmp    $0xa,%eax
f01004be:	0f 84 98 00 00 00    	je     f010055c <cons_putc+0x144>
f01004c4:	83 f8 0d             	cmp    $0xd,%eax
f01004c7:	0f 85 d3 00 00 00    	jne    f01005a0 <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f01004cd:	0f b7 05 28 a2 57 f0 	movzwl 0xf057a228,%eax
f01004d4:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004da:	c1 e8 16             	shr    $0x16,%eax
f01004dd:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004e0:	c1 e0 04             	shl    $0x4,%eax
f01004e3:	66 a3 28 a2 57 f0    	mov    %ax,0xf057a228
	if (crt_pos >= CRT_SIZE) {
f01004e9:	66 81 3d 28 a2 57 f0 	cmpw   $0x7cf,0xf057a228
f01004f0:	cf 07 
f01004f2:	0f 87 cb 00 00 00    	ja     f01005c3 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004f8:	8b 0d 30 a2 57 f0    	mov    0xf057a230,%ecx
f01004fe:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100503:	89 ca                	mov    %ecx,%edx
f0100505:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100506:	0f b7 1d 28 a2 57 f0 	movzwl 0xf057a228,%ebx
f010050d:	8d 71 01             	lea    0x1(%ecx),%esi
f0100510:	89 d8                	mov    %ebx,%eax
f0100512:	66 c1 e8 08          	shr    $0x8,%ax
f0100516:	89 f2                	mov    %esi,%edx
f0100518:	ee                   	out    %al,(%dx)
f0100519:	b8 0f 00 00 00       	mov    $0xf,%eax
f010051e:	89 ca                	mov    %ecx,%edx
f0100520:	ee                   	out    %al,(%dx)
f0100521:	89 d8                	mov    %ebx,%eax
f0100523:	89 f2                	mov    %esi,%edx
f0100525:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100526:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100529:	5b                   	pop    %ebx
f010052a:	5e                   	pop    %esi
f010052b:	5f                   	pop    %edi
f010052c:	5d                   	pop    %ebp
f010052d:	c3                   	ret    
	switch (c & 0xff) {
f010052e:	83 f8 08             	cmp    $0x8,%eax
f0100531:	75 6d                	jne    f01005a0 <cons_putc+0x188>
		if (crt_pos > 0) {
f0100533:	0f b7 05 28 a2 57 f0 	movzwl 0xf057a228,%eax
f010053a:	66 85 c0             	test   %ax,%ax
f010053d:	74 b9                	je     f01004f8 <cons_putc+0xe0>
			crt_pos--;
f010053f:	83 e8 01             	sub    $0x1,%eax
f0100542:	66 a3 28 a2 57 f0    	mov    %ax,0xf057a228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100548:	0f b7 c0             	movzwl %ax,%eax
f010054b:	b1 00                	mov    $0x0,%cl
f010054d:	83 c9 20             	or     $0x20,%ecx
f0100550:	8b 15 2c a2 57 f0    	mov    0xf057a22c,%edx
f0100556:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010055a:	eb 8d                	jmp    f01004e9 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f010055c:	66 83 05 28 a2 57 f0 	addw   $0x50,0xf057a228
f0100563:	50 
f0100564:	e9 64 ff ff ff       	jmp    f01004cd <cons_putc+0xb5>
		cons_putc(' ');
f0100569:	b8 20 00 00 00       	mov    $0x20,%eax
f010056e:	e8 a5 fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f0100573:	b8 20 00 00 00       	mov    $0x20,%eax
f0100578:	e8 9b fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f010057d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100582:	e8 91 fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f0100587:	b8 20 00 00 00       	mov    $0x20,%eax
f010058c:	e8 87 fe ff ff       	call   f0100418 <cons_putc>
		cons_putc(' ');
f0100591:	b8 20 00 00 00       	mov    $0x20,%eax
f0100596:	e8 7d fe ff ff       	call   f0100418 <cons_putc>
f010059b:	e9 49 ff ff ff       	jmp    f01004e9 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f01005a0:	0f b7 05 28 a2 57 f0 	movzwl 0xf057a228,%eax
f01005a7:	8d 50 01             	lea    0x1(%eax),%edx
f01005aa:	66 89 15 28 a2 57 f0 	mov    %dx,0xf057a228
f01005b1:	0f b7 c0             	movzwl %ax,%eax
f01005b4:	8b 15 2c a2 57 f0    	mov    0xf057a22c,%edx
f01005ba:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005be:	e9 26 ff ff ff       	jmp    f01004e9 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005c3:	a1 2c a2 57 f0       	mov    0xf057a22c,%eax
f01005c8:	83 ec 04             	sub    $0x4,%esp
f01005cb:	68 00 0f 00 00       	push   $0xf00
f01005d0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005d6:	52                   	push   %edx
f01005d7:	50                   	push   %eax
f01005d8:	e8 1e 5f 00 00       	call   f01064fb <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005dd:	8b 15 2c a2 57 f0    	mov    0xf057a22c,%edx
f01005e3:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005e9:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005ef:	83 c4 10             	add    $0x10,%esp
f01005f2:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005f7:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005fa:	39 d0                	cmp    %edx,%eax
f01005fc:	75 f4                	jne    f01005f2 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005fe:	66 83 2d 28 a2 57 f0 	subw   $0x50,0xf057a228
f0100605:	50 
f0100606:	e9 ed fe ff ff       	jmp    f01004f8 <cons_putc+0xe0>

f010060b <serial_intr>:
	if (serial_exists)
f010060b:	80 3d 34 a2 57 f0 00 	cmpb   $0x0,0xf057a234
f0100612:	75 01                	jne    f0100615 <serial_intr+0xa>
f0100614:	c3                   	ret    
{
f0100615:	55                   	push   %ebp
f0100616:	89 e5                	mov    %esp,%ebp
f0100618:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010061b:	b8 aa 02 10 f0       	mov    $0xf01002aa,%eax
f0100620:	e8 9f fc ff ff       	call   f01002c4 <cons_intr>
}
f0100625:	c9                   	leave  
f0100626:	c3                   	ret    

f0100627 <kbd_intr>:
{
f0100627:	55                   	push   %ebp
f0100628:	89 e5                	mov    %esp,%ebp
f010062a:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f010062d:	b8 03 03 10 f0       	mov    $0xf0100303,%eax
f0100632:	e8 8d fc ff ff       	call   f01002c4 <cons_intr>
}
f0100637:	c9                   	leave  
f0100638:	c3                   	ret    

f0100639 <cons_getc>:
{
f0100639:	55                   	push   %ebp
f010063a:	89 e5                	mov    %esp,%ebp
f010063c:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010063f:	e8 c7 ff ff ff       	call   f010060b <serial_intr>
	kbd_intr();
f0100644:	e8 de ff ff ff       	call   f0100627 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100649:	8b 15 20 a2 57 f0    	mov    0xf057a220,%edx
	return 0;
f010064f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100654:	3b 15 24 a2 57 f0    	cmp    0xf057a224,%edx
f010065a:	74 1e                	je     f010067a <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010065c:	8d 4a 01             	lea    0x1(%edx),%ecx
f010065f:	0f b6 82 20 a0 57 f0 	movzbl -0xfa85fe0(%edx),%eax
			cons.rpos = 0;
f0100666:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010066c:	ba 00 00 00 00       	mov    $0x0,%edx
f0100671:	0f 44 ca             	cmove  %edx,%ecx
f0100674:	89 0d 20 a2 57 f0    	mov    %ecx,0xf057a220
}
f010067a:	c9                   	leave  
f010067b:	c3                   	ret    

f010067c <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010067c:	55                   	push   %ebp
f010067d:	89 e5                	mov    %esp,%ebp
f010067f:	57                   	push   %edi
f0100680:	56                   	push   %esi
f0100681:	53                   	push   %ebx
f0100682:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100685:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010068c:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100693:	5a a5 
	if (*cp != 0xA55A) {
f0100695:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010069c:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006a0:	0f 84 de 00 00 00    	je     f0100784 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f01006a6:	c7 05 30 a2 57 f0 b4 	movl   $0x3b4,0xf057a230
f01006ad:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006b0:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006b5:	8b 3d 30 a2 57 f0    	mov    0xf057a230,%edi
f01006bb:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006c0:	89 fa                	mov    %edi,%edx
f01006c2:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006c3:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006c6:	89 ca                	mov    %ecx,%edx
f01006c8:	ec                   	in     (%dx),%al
f01006c9:	0f b6 c0             	movzbl %al,%eax
f01006cc:	c1 e0 08             	shl    $0x8,%eax
f01006cf:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006d1:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006d6:	89 fa                	mov    %edi,%edx
f01006d8:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006d9:	89 ca                	mov    %ecx,%edx
f01006db:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006dc:	89 35 2c a2 57 f0    	mov    %esi,0xf057a22c
	pos |= inb(addr_6845 + 1);
f01006e2:	0f b6 c0             	movzbl %al,%eax
f01006e5:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006e7:	66 a3 28 a2 57 f0    	mov    %ax,0xf057a228
	kbd_intr();
f01006ed:	e8 35 ff ff ff       	call   f0100627 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006f2:	83 ec 0c             	sub    $0xc,%esp
f01006f5:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f01006fc:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100701:	50                   	push   %eax
f0100702:	e8 ef 35 00 00       	call   f0103cf6 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100707:	bb 00 00 00 00       	mov    $0x0,%ebx
f010070c:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f0100711:	89 d8                	mov    %ebx,%eax
f0100713:	89 ca                	mov    %ecx,%edx
f0100715:	ee                   	out    %al,(%dx)
f0100716:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010071b:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100720:	89 fa                	mov    %edi,%edx
f0100722:	ee                   	out    %al,(%dx)
f0100723:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100728:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010072d:	ee                   	out    %al,(%dx)
f010072e:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100733:	89 d8                	mov    %ebx,%eax
f0100735:	89 f2                	mov    %esi,%edx
f0100737:	ee                   	out    %al,(%dx)
f0100738:	b8 03 00 00 00       	mov    $0x3,%eax
f010073d:	89 fa                	mov    %edi,%edx
f010073f:	ee                   	out    %al,(%dx)
f0100740:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100745:	89 d8                	mov    %ebx,%eax
f0100747:	ee                   	out    %al,(%dx)
f0100748:	b8 01 00 00 00       	mov    $0x1,%eax
f010074d:	89 f2                	mov    %esi,%edx
f010074f:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100750:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100755:	ec                   	in     (%dx),%al
f0100756:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100758:	83 c4 10             	add    $0x10,%esp
f010075b:	3c ff                	cmp    $0xff,%al
f010075d:	0f 95 05 34 a2 57 f0 	setne  0xf057a234
f0100764:	89 ca                	mov    %ecx,%edx
f0100766:	ec                   	in     (%dx),%al
f0100767:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010076c:	ec                   	in     (%dx),%al
	if (serial_exists)
f010076d:	80 fb ff             	cmp    $0xff,%bl
f0100770:	75 2d                	jne    f010079f <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100772:	83 ec 0c             	sub    $0xc,%esp
f0100775:	68 63 79 10 f0       	push   $0xf0107963
f010077a:	e8 f0 36 00 00       	call   f0103e6f <cprintf>
f010077f:	83 c4 10             	add    $0x10,%esp
}
f0100782:	eb 3c                	jmp    f01007c0 <cons_init+0x144>
		*cp = was;
f0100784:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010078b:	c7 05 30 a2 57 f0 d4 	movl   $0x3d4,0xf057a230
f0100792:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100795:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010079a:	e9 16 ff ff ff       	jmp    f01006b5 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010079f:	83 ec 0c             	sub    $0xc,%esp
f01007a2:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f01007a9:	25 ef ff 00 00       	and    $0xffef,%eax
f01007ae:	50                   	push   %eax
f01007af:	e8 42 35 00 00       	call   f0103cf6 <irq_setmask_8259A>
	if (!serial_exists)
f01007b4:	83 c4 10             	add    $0x10,%esp
f01007b7:	80 3d 34 a2 57 f0 00 	cmpb   $0x0,0xf057a234
f01007be:	74 b2                	je     f0100772 <cons_init+0xf6>
}
f01007c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007c3:	5b                   	pop    %ebx
f01007c4:	5e                   	pop    %esi
f01007c5:	5f                   	pop    %edi
f01007c6:	5d                   	pop    %ebp
f01007c7:	c3                   	ret    

f01007c8 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007c8:	55                   	push   %ebp
f01007c9:	89 e5                	mov    %esp,%ebp
f01007cb:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007ce:	8b 45 08             	mov    0x8(%ebp),%eax
f01007d1:	e8 42 fc ff ff       	call   f0100418 <cons_putc>
}
f01007d6:	c9                   	leave  
f01007d7:	c3                   	ret    

f01007d8 <getchar>:

int
getchar(void)
{
f01007d8:	55                   	push   %ebp
f01007d9:	89 e5                	mov    %esp,%ebp
f01007db:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007de:	e8 56 fe ff ff       	call   f0100639 <cons_getc>
f01007e3:	85 c0                	test   %eax,%eax
f01007e5:	74 f7                	je     f01007de <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007e7:	c9                   	leave  
f01007e8:	c3                   	ret    

f01007e9 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f01007e9:	b8 01 00 00 00       	mov    $0x1,%eax
f01007ee:	c3                   	ret    

f01007ef <mon_help>:
/***** Implementations of basic kernel monitor commands *****/
static long atol(const char *nptr);

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007ef:	55                   	push   %ebp
f01007f0:	89 e5                	mov    %esp,%ebp
f01007f2:	53                   	push   %ebx
f01007f3:	83 ec 04             	sub    $0x4,%esp
f01007f6:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007fb:	83 ec 04             	sub    $0x4,%esp
f01007fe:	ff b3 04 80 10 f0    	pushl  -0xfef7ffc(%ebx)
f0100804:	ff b3 00 80 10 f0    	pushl  -0xfef8000(%ebx)
f010080a:	68 a0 7b 10 f0       	push   $0xf0107ba0
f010080f:	e8 5b 36 00 00       	call   f0103e6f <cprintf>
f0100814:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100817:	83 c4 10             	add    $0x10,%esp
f010081a:	83 fb 3c             	cmp    $0x3c,%ebx
f010081d:	75 dc                	jne    f01007fb <mon_help+0xc>
	return 0;
}
f010081f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100827:	c9                   	leave  
f0100828:	c3                   	ret    

f0100829 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100829:	55                   	push   %ebp
f010082a:	89 e5                	mov    %esp,%ebp
f010082c:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010082f:	68 a9 7b 10 f0       	push   $0xf0107ba9
f0100834:	e8 36 36 00 00       	call   f0103e6f <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100839:	83 c4 08             	add    $0x8,%esp
f010083c:	68 0c 00 10 00       	push   $0x10000c
f0100841:	68 0c 7d 10 f0       	push   $0xf0107d0c
f0100846:	e8 24 36 00 00       	call   f0103e6f <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010084b:	83 c4 0c             	add    $0xc,%esp
f010084e:	68 0c 00 10 00       	push   $0x10000c
f0100853:	68 0c 00 10 f0       	push   $0xf010000c
f0100858:	68 34 7d 10 f0       	push   $0xf0107d34
f010085d:	e8 0d 36 00 00       	call   f0103e6f <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100862:	83 c4 0c             	add    $0xc,%esp
f0100865:	68 5f 78 10 00       	push   $0x10785f
f010086a:	68 5f 78 10 f0       	push   $0xf010785f
f010086f:	68 58 7d 10 f0       	push   $0xf0107d58
f0100874:	e8 f6 35 00 00       	call   f0103e6f <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100879:	83 c4 0c             	add    $0xc,%esp
f010087c:	68 00 a0 57 00       	push   $0x57a000
f0100881:	68 00 a0 57 f0       	push   $0xf057a000
f0100886:	68 7c 7d 10 f0       	push   $0xf0107d7c
f010088b:	e8 df 35 00 00       	call   f0103e6f <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100890:	83 c4 0c             	add    $0xc,%esp
f0100893:	68 40 ac 67 00       	push   $0x67ac40
f0100898:	68 40 ac 67 f0       	push   $0xf067ac40
f010089d:	68 a0 7d 10 f0       	push   $0xf0107da0
f01008a2:	e8 c8 35 00 00       	call   f0103e6f <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a7:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008aa:	b8 40 ac 67 f0       	mov    $0xf067ac40,%eax
f01008af:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008b4:	c1 f8 0a             	sar    $0xa,%eax
f01008b7:	50                   	push   %eax
f01008b8:	68 c4 7d 10 f0       	push   $0xf0107dc4
f01008bd:	e8 ad 35 00 00       	call   f0103e6f <cprintf>
	return 0;
}
f01008c2:	b8 00 00 00 00       	mov    $0x0,%eax
f01008c7:	c9                   	leave  
f01008c8:	c3                   	ret    

f01008c9 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008c9:	55                   	push   %ebp
f01008ca:	89 e5                	mov    %esp,%ebp
f01008cc:	56                   	push   %esi
f01008cd:	53                   	push   %ebx
f01008ce:	83 ec 20             	sub    $0x20,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008d1:	89 eb                	mov    %ebp,%ebx
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
		debuginfo_eip(the_ebp[1], &info);
f01008d3:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(the_ebp != NULL){
f01008d6:	85 db                	test   %ebx,%ebx
f01008d8:	0f 84 b3 00 00 00    	je     f0100991 <mon_backtrace+0xc8>
		cprintf("the ebp1 0x%x\n", the_ebp[1]);
f01008de:	83 ec 08             	sub    $0x8,%esp
f01008e1:	ff 73 04             	pushl  0x4(%ebx)
f01008e4:	68 c2 7b 10 f0       	push   $0xf0107bc2
f01008e9:	e8 81 35 00 00       	call   f0103e6f <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f01008ee:	83 c4 08             	add    $0x8,%esp
f01008f1:	ff 73 08             	pushl  0x8(%ebx)
f01008f4:	68 d1 7b 10 f0       	push   $0xf0107bd1
f01008f9:	e8 71 35 00 00       	call   f0103e6f <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f01008fe:	83 c4 08             	add    $0x8,%esp
f0100901:	ff 73 0c             	pushl  0xc(%ebx)
f0100904:	68 e0 7b 10 f0       	push   $0xf0107be0
f0100909:	e8 61 35 00 00       	call   f0103e6f <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f010090e:	83 c4 08             	add    $0x8,%esp
f0100911:	ff 73 10             	pushl  0x10(%ebx)
f0100914:	68 ef 7b 10 f0       	push   $0xf0107bef
f0100919:	e8 51 35 00 00       	call   f0103e6f <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f010091e:	83 c4 08             	add    $0x8,%esp
f0100921:	ff 73 14             	pushl  0x14(%ebx)
f0100924:	68 fe 7b 10 f0       	push   $0xf0107bfe
f0100929:	e8 41 35 00 00       	call   f0103e6f <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f010092e:	83 c4 08             	add    $0x8,%esp
f0100931:	ff 73 18             	pushl  0x18(%ebx)
f0100934:	68 0d 7c 10 f0       	push   $0xf0107c0d
f0100939:	e8 31 35 00 00       	call   f0103e6f <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f010093e:	ff 73 18             	pushl  0x18(%ebx)
f0100941:	ff 73 14             	pushl  0x14(%ebx)
f0100944:	ff 73 10             	pushl  0x10(%ebx)
f0100947:	ff 73 0c             	pushl  0xc(%ebx)
f010094a:	ff 73 08             	pushl  0x8(%ebx)
f010094d:	53                   	push   %ebx
f010094e:	ff 73 04             	pushl  0x4(%ebx)
f0100951:	68 f0 7d 10 f0       	push   $0xf0107df0
f0100956:	e8 14 35 00 00       	call   f0103e6f <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f010095b:	83 c4 28             	add    $0x28,%esp
f010095e:	56                   	push   %esi
f010095f:	ff 73 04             	pushl  0x4(%ebx)
f0100962:	e8 e5 4e 00 00       	call   f010584c <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f0100967:	83 c4 08             	add    $0x8,%esp
f010096a:	8b 43 04             	mov    0x4(%ebx),%eax
f010096d:	2b 45 f0             	sub    -0x10(%ebp),%eax
f0100970:	50                   	push   %eax
f0100971:	ff 75 e8             	pushl  -0x18(%ebp)
f0100974:	ff 75 ec             	pushl  -0x14(%ebp)
f0100977:	ff 75 e4             	pushl  -0x1c(%ebp)
f010097a:	ff 75 e0             	pushl  -0x20(%ebp)
f010097d:	68 1c 7c 10 f0       	push   $0xf0107c1c
f0100982:	e8 e8 34 00 00       	call   f0103e6f <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f0100987:	8b 1b                	mov    (%ebx),%ebx
f0100989:	83 c4 20             	add    $0x20,%esp
f010098c:	e9 45 ff ff ff       	jmp    f01008d6 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f0100991:	83 ec 0c             	sub    $0xc,%esp
f0100994:	68 32 7c 10 f0       	push   $0xf0107c32
f0100999:	e8 d1 34 00 00       	call   f0103e6f <cprintf>
	return 0;
}
f010099e:	b8 00 00 00 00       	mov    $0x0,%eax
f01009a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01009a6:	5b                   	pop    %ebx
f01009a7:	5e                   	pop    %esi
f01009a8:	5d                   	pop    %ebp
f01009a9:	c3                   	ret    

f01009aa <mon_showmappings>:
	cycles_t end = currentcycles();
	cprintf("%s cycles: %ul\n", fun_n, end - start);
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f01009aa:	55                   	push   %ebp
f01009ab:	89 e5                	mov    %esp,%ebp
f01009ad:	57                   	push   %edi
f01009ae:	56                   	push   %esi
f01009af:	53                   	push   %ebx
f01009b0:	83 ec 2c             	sub    $0x2c,%esp
	if(argc != 3){
f01009b3:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f01009b7:	75 3f                	jne    f01009f8 <mon_showmappings+0x4e>
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
		return 0;
	}
	uint32_t low_va = 0, high_va = 0, old_va;
	if(argv[1][0]!='0'||argv[1][1]!='x'||argv[2][0]!='0'||argv[2][1]!='x'){
f01009b9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01009bc:	8b 40 04             	mov    0x4(%eax),%eax
f01009bf:	80 38 30             	cmpb   $0x30,(%eax)
f01009c2:	75 17                	jne    f01009db <mon_showmappings+0x31>
f01009c4:	80 78 01 78          	cmpb   $0x78,0x1(%eax)
f01009c8:	75 11                	jne    f01009db <mon_showmappings+0x31>
f01009ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01009cd:	8b 51 08             	mov    0x8(%ecx),%edx
f01009d0:	80 3a 30             	cmpb   $0x30,(%edx)
f01009d3:	75 06                	jne    f01009db <mon_showmappings+0x31>
f01009d5:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01009d9:	74 34                	je     f0100a0f <mon_showmappings+0x65>
		cprintf("the virtual-address should be 16-base\n");
f01009db:	83 ec 0c             	sub    $0xc,%esp
f01009de:	68 60 7e 10 f0       	push   $0xf0107e60
f01009e3:	e8 87 34 00 00       	call   f0103e6f <cprintf>
		return 0;
f01009e8:	83 c4 10             	add    $0x10,%esp
		low_va += PTSIZE;
		if(low_va <= old_va)
			break;
    }
    return 0;
}
f01009eb:	b8 00 00 00 00       	mov    $0x0,%eax
f01009f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01009f3:	5b                   	pop    %ebx
f01009f4:	5e                   	pop    %esi
f01009f5:	5f                   	pop    %edi
f01009f6:	5d                   	pop    %ebp
f01009f7:	c3                   	ret    
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
f01009f8:	83 ec 08             	sub    $0x8,%esp
f01009fb:	68 e0 7f 10 f0       	push   $0xf0107fe0
f0100a00:	68 24 7e 10 f0       	push   $0xf0107e24
f0100a05:	e8 65 34 00 00       	call   f0103e6f <cprintf>
		return 0;
f0100a0a:	83 c4 10             	add    $0x10,%esp
f0100a0d:	eb dc                	jmp    f01009eb <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f0100a0f:	83 ec 04             	sub    $0x4,%esp
f0100a12:	6a 10                	push   $0x10
f0100a14:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f0100a17:	56                   	push   %esi
f0100a18:	50                   	push   %eax
f0100a19:	e8 ab 5b 00 00       	call   f01065c9 <strtol>
f0100a1e:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a20:	83 c4 0c             	add    $0xc,%esp
f0100a23:	6a 10                	push   $0x10
f0100a25:	56                   	push   %esi
f0100a26:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a29:	ff 70 08             	pushl  0x8(%eax)
f0100a2c:	e8 98 5b 00 00       	call   f01065c9 <strtol>
	low_va = low_va/PGSIZE * PGSIZE;
f0100a31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	high_va = high_va/PGSIZE * PGSIZE;
f0100a37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a3c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(low_va > high_va){
f0100a3f:	83 c4 10             	add    $0x10,%esp
f0100a42:	39 c3                	cmp    %eax,%ebx
f0100a44:	0f 86 1c 01 00 00    	jbe    f0100b66 <mon_showmappings+0x1bc>
		cprintf("the start-va should < the end-va\n");
f0100a4a:	83 ec 0c             	sub    $0xc,%esp
f0100a4d:	68 88 7e 10 f0       	push   $0xf0107e88
f0100a52:	e8 18 34 00 00       	call   f0103e6f <cprintf>
		return 0;
f0100a57:	83 c4 10             	add    $0x10,%esp
f0100a5a:	eb 8f                	jmp    f01009eb <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100a5c:	83 ec 04             	sub    $0x4,%esp
f0100a5f:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100a65:	50                   	push   %eax
f0100a66:	53                   	push   %ebx
f0100a67:	68 45 7c 10 f0       	push   $0xf0107c45
f0100a6c:	e8 fe 33 00 00       	call   f0103e6f <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100a71:	8b 06                	mov    (%esi),%eax
f0100a73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a78:	83 c4 0c             	add    $0xc,%esp
f0100a7b:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100a81:	52                   	push   %edx
f0100a82:	50                   	push   %eax
f0100a83:	68 54 7c 10 f0       	push   $0xf0107c54
f0100a88:	e8 e2 33 00 00       	call   f0103e6f <cprintf>
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a8d:	83 c4 0c             	add    $0xc,%esp
f0100a90:	89 f8                	mov    %edi,%eax
f0100a92:	83 e0 01             	and    $0x1,%eax
f0100a95:	50                   	push   %eax
					u_bit = pte[PTX(low_va)] & PTE_U;
f0100a96:	89 f8                	mov    %edi,%eax
f0100a98:	83 e0 04             	and    $0x4,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a9b:	0f be c0             	movsbl %al,%eax
f0100a9e:	50                   	push   %eax
					w_bit = pte[PTX(low_va)] & PTE_W;
f0100a9f:	89 f8                	mov    %edi,%eax
f0100aa1:	83 e0 02             	and    $0x2,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100aa4:	0f be c0             	movsbl %al,%eax
f0100aa7:	50                   	push   %eax
					a_bit = pte[PTX(low_va)] & PTE_A;
f0100aa8:	89 f8                	mov    %edi,%eax
f0100aaa:	83 e0 20             	and    $0x20,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100aad:	0f be c0             	movsbl %al,%eax
f0100ab0:	50                   	push   %eax
					d_bit = pte[PTX(low_va)] & PTE_D;
f0100ab1:	89 f8                	mov    %edi,%eax
f0100ab3:	83 e0 40             	and    $0x40,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ab6:	0f be c0             	movsbl %al,%eax
f0100ab9:	50                   	push   %eax
f0100aba:	6a 00                	push   $0x0
f0100abc:	68 63 7c 10 f0       	push   $0xf0107c63
f0100ac1:	e8 a9 33 00 00       	call   f0103e6f <cprintf>
f0100ac6:	83 c4 20             	add    $0x20,%esp
f0100ac9:	e9 dc 00 00 00       	jmp    f0100baa <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100ace:	83 ec 04             	sub    $0x4,%esp
f0100ad1:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100ad7:	50                   	push   %eax
f0100ad8:	53                   	push   %ebx
f0100ad9:	68 45 7c 10 f0       	push   $0xf0107c45
f0100ade:	e8 8c 33 00 00       	call   f0103e6f <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100ae3:	8b 07                	mov    (%edi),%eax
f0100ae5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100aea:	83 c4 0c             	add    $0xc,%esp
f0100aed:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100af3:	52                   	push   %edx
f0100af4:	50                   	push   %eax
f0100af5:	68 54 7c 10 f0       	push   $0xf0107c54
f0100afa:	e8 70 33 00 00       	call   f0103e6f <cprintf>
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100aff:	83 c4 0c             	add    $0xc,%esp
f0100b02:	89 f0                	mov    %esi,%eax
f0100b04:	83 e0 01             	and    $0x1,%eax
f0100b07:	50                   	push   %eax
				u_bit = *pde & PTE_U;
f0100b08:	89 f0                	mov    %esi,%eax
f0100b0a:	83 e0 04             	and    $0x4,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b0d:	0f be c0             	movsbl %al,%eax
f0100b10:	50                   	push   %eax
				w_bit = *pde & PTE_W;
f0100b11:	89 f0                	mov    %esi,%eax
f0100b13:	83 e0 02             	and    $0x2,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b16:	0f be c0             	movsbl %al,%eax
f0100b19:	50                   	push   %eax
				a_bit = *pde & PTE_A;
f0100b1a:	89 f0                	mov    %esi,%eax
f0100b1c:	83 e0 20             	and    $0x20,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b1f:	0f be c0             	movsbl %al,%eax
f0100b22:	50                   	push   %eax
				d_bit = *pde & PTE_D;
f0100b23:	89 f0                	mov    %esi,%eax
f0100b25:	83 e0 40             	and    $0x40,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b28:	0f be c0             	movsbl %al,%eax
f0100b2b:	50                   	push   %eax
f0100b2c:	6a 00                	push   $0x0
f0100b2e:	68 63 7c 10 f0       	push   $0xf0107c63
f0100b33:	e8 37 33 00 00       	call   f0103e6f <cprintf>
				low_va += PTSIZE;
f0100b38:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
				if(low_va <= old_va)
f0100b3e:	83 c4 20             	add    $0x20,%esp
f0100b41:	39 d8                	cmp    %ebx,%eax
f0100b43:	0f 86 a2 fe ff ff    	jbe    f01009eb <mon_showmappings+0x41>
				low_va += PTSIZE;
f0100b49:	89 c3                	mov    %eax,%ebx
f0100b4b:	eb 10                	jmp    f0100b5d <mon_showmappings+0x1b3>
		low_va += PTSIZE;
f0100b4d:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
		if(low_va <= old_va)
f0100b53:	39 d8                	cmp    %ebx,%eax
f0100b55:	0f 86 90 fe ff ff    	jbe    f01009eb <mon_showmappings+0x41>
		low_va += PTSIZE;
f0100b5b:	89 c3                	mov    %eax,%ebx
    while (low_va <= high_va) {
f0100b5d:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0100b60:	0f 87 85 fe ff ff    	ja     f01009eb <mon_showmappings+0x41>
        pde_t *pde = &kern_pgdir[PDX(low_va)];
f0100b66:	89 da                	mov    %ebx,%edx
f0100b68:	c1 ea 16             	shr    $0x16,%edx
f0100b6b:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0100b70:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if (*pde) {
f0100b73:	8b 37                	mov    (%edi),%esi
f0100b75:	85 f6                	test   %esi,%esi
f0100b77:	74 d4                	je     f0100b4d <mon_showmappings+0x1a3>
            if (low_va < (uint32_t)KERNBASE) {
f0100b79:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100b7f:	0f 87 49 ff ff ff    	ja     f0100ace <mon_showmappings+0x124>
                pte_t *pte = (pte_t*)(PTE_ADDR(*pde)+KERNBASE);
f0100b85:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
				if(pte[PTX(low_va)] & PTE_P){
f0100b8b:	89 d8                	mov    %ebx,%eax
f0100b8d:	c1 e8 0a             	shr    $0xa,%eax
f0100b90:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100b95:	8d b4 06 00 00 00 f0 	lea    -0x10000000(%esi,%eax,1),%esi
f0100b9c:	8b 3e                	mov    (%esi),%edi
f0100b9e:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0100ba4:	0f 85 b2 fe ff ff    	jne    f0100a5c <mon_showmappings+0xb2>
				low_va += PGSIZE;
f0100baa:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
				if(low_va <= old_va)
f0100bb0:	39 d8                	cmp    %ebx,%eax
f0100bb2:	0f 86 33 fe ff ff    	jbe    f01009eb <mon_showmappings+0x41>
				low_va += PGSIZE;
f0100bb8:	89 c3                	mov    %eax,%ebx
f0100bba:	eb a1                	jmp    f0100b5d <mon_showmappings+0x1b3>

f0100bbc <mon_time>:
mon_time(int argc, char **argv, struct Trapframe *tf){
f0100bbc:	55                   	push   %ebp
f0100bbd:	89 e5                	mov    %esp,%ebp
f0100bbf:	57                   	push   %edi
f0100bc0:	56                   	push   %esi
f0100bc1:	53                   	push   %ebx
f0100bc2:	83 ec 1c             	sub    $0x1c,%esp
f0100bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
	char *fun_n = argv[1];
f0100bc8:	8b 78 04             	mov    0x4(%eax),%edi
	if(argc != 2)
f0100bcb:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100bcf:	0f 85 84 00 00 00    	jne    f0100c59 <mon_time+0x9d>
	for(int i = 0; i < command_size; i++){
f0100bd5:	bb 00 00 00 00       	mov    $0x0,%ebx
	cycles_t start = 0;
f0100bda:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0100be1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100be8:	83 c0 08             	add    $0x8,%eax
f0100beb:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100bee:	eb 20                	jmp    f0100c10 <mon_time+0x54>
	}
}

cycles_t currentcycles() {
    cycles_t result;
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100bf0:	0f 31                	rdtsc  
f0100bf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100bf5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100bf8:	83 ec 04             	sub    $0x4,%esp
f0100bfb:	ff 75 10             	pushl  0x10(%ebp)
f0100bfe:	ff 75 dc             	pushl  -0x24(%ebp)
f0100c01:	6a 00                	push   $0x0
f0100c03:	ff 14 b5 08 80 10 f0 	call   *-0xfef7ff8(,%esi,4)
f0100c0a:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100c0d:	83 c3 01             	add    $0x1,%ebx
f0100c10:	39 1d 00 73 12 f0    	cmp    %ebx,0xf0127300
f0100c16:	7e 1c                	jle    f0100c34 <mon_time+0x78>
f0100c18:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c1b:	83 ec 08             	sub    $0x8,%esp
f0100c1e:	57                   	push   %edi
f0100c1f:	ff 34 b5 00 80 10 f0 	pushl  -0xfef8000(,%esi,4)
f0100c26:	e8 ed 57 00 00       	call   f0106418 <strcmp>
f0100c2b:	83 c4 10             	add    $0x10,%esp
f0100c2e:	85 c0                	test   %eax,%eax
f0100c30:	75 db                	jne    f0100c0d <mon_time+0x51>
f0100c32:	eb bc                	jmp    f0100bf0 <mon_time+0x34>
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c34:	0f 31                	rdtsc  
	cprintf("%s cycles: %ul\n", fun_n, end - start);
f0100c36:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100c39:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
f0100c3c:	52                   	push   %edx
f0100c3d:	50                   	push   %eax
f0100c3e:	57                   	push   %edi
f0100c3f:	68 76 7c 10 f0       	push   $0xf0107c76
f0100c44:	e8 26 32 00 00       	call   f0103e6f <cprintf>
	return 0;
f0100c49:	83 c4 10             	add    $0x10,%esp
f0100c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c54:	5b                   	pop    %ebx
f0100c55:	5e                   	pop    %esi
f0100c56:	5f                   	pop    %edi
f0100c57:	5d                   	pop    %ebp
f0100c58:	c3                   	ret    
		return -1;
f0100c59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c5e:	eb f1                	jmp    f0100c51 <mon_time+0x95>

f0100c60 <monitor>:
{
f0100c60:	55                   	push   %ebp
f0100c61:	89 e5                	mov    %esp,%ebp
f0100c63:	57                   	push   %edi
f0100c64:	56                   	push   %esi
f0100c65:	53                   	push   %ebx
f0100c66:	83 ec 58             	sub    $0x58,%esp
	cprintf("Welcome to the JOS kernel monitor!\n");
f0100c69:	68 ac 7e 10 f0       	push   $0xf0107eac
f0100c6e:	e8 fc 31 00 00       	call   f0103e6f <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c73:	c7 04 24 d0 7e 10 f0 	movl   $0xf0107ed0,(%esp)
f0100c7a:	e8 f0 31 00 00       	call   f0103e6f <cprintf>
	if (tf != NULL)
f0100c7f:	83 c4 10             	add    $0x10,%esp
f0100c82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100c86:	0f 84 d9 00 00 00    	je     f0100d65 <monitor+0x105>
		print_trapframe(tf);
f0100c8c:	83 ec 0c             	sub    $0xc,%esp
f0100c8f:	ff 75 08             	pushl  0x8(%ebp)
f0100c92:	e8 63 39 00 00       	call   f01045fa <print_trapframe>
f0100c97:	83 c4 10             	add    $0x10,%esp
f0100c9a:	e9 c6 00 00 00       	jmp    f0100d65 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100c9f:	83 ec 08             	sub    $0x8,%esp
f0100ca2:	0f be c0             	movsbl %al,%eax
f0100ca5:	50                   	push   %eax
f0100ca6:	68 8a 7c 10 f0       	push   $0xf0107c8a
f0100cab:	e8 c6 57 00 00       	call   f0106476 <strchr>
f0100cb0:	83 c4 10             	add    $0x10,%esp
f0100cb3:	85 c0                	test   %eax,%eax
f0100cb5:	74 63                	je     f0100d1a <monitor+0xba>
			*buf++ = 0;
f0100cb7:	c6 03 00             	movb   $0x0,(%ebx)
f0100cba:	89 f7                	mov    %esi,%edi
f0100cbc:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100cbf:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100cc1:	0f b6 03             	movzbl (%ebx),%eax
f0100cc4:	84 c0                	test   %al,%al
f0100cc6:	75 d7                	jne    f0100c9f <monitor+0x3f>
	argv[argc] = 0;
f0100cc8:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100ccf:	00 
	if (argc == 0)
f0100cd0:	85 f6                	test   %esi,%esi
f0100cd2:	0f 84 8d 00 00 00    	je     f0100d65 <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100cdd:	83 ec 08             	sub    $0x8,%esp
f0100ce0:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100ce3:	ff 34 85 00 80 10 f0 	pushl  -0xfef8000(,%eax,4)
f0100cea:	ff 75 a8             	pushl  -0x58(%ebp)
f0100ced:	e8 26 57 00 00       	call   f0106418 <strcmp>
f0100cf2:	83 c4 10             	add    $0x10,%esp
f0100cf5:	85 c0                	test   %eax,%eax
f0100cf7:	0f 84 8f 00 00 00    	je     f0100d8c <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100cfd:	83 c3 01             	add    $0x1,%ebx
f0100d00:	83 fb 05             	cmp    $0x5,%ebx
f0100d03:	75 d8                	jne    f0100cdd <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100d05:	83 ec 08             	sub    $0x8,%esp
f0100d08:	ff 75 a8             	pushl  -0x58(%ebp)
f0100d0b:	68 ac 7c 10 f0       	push   $0xf0107cac
f0100d10:	e8 5a 31 00 00       	call   f0103e6f <cprintf>
f0100d15:	83 c4 10             	add    $0x10,%esp
f0100d18:	eb 4b                	jmp    f0100d65 <monitor+0x105>
		if (*buf == 0)
f0100d1a:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100d1d:	74 a9                	je     f0100cc8 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100d1f:	83 fe 0f             	cmp    $0xf,%esi
f0100d22:	74 2f                	je     f0100d53 <monitor+0xf3>
		argv[argc++] = buf;
f0100d24:	8d 7e 01             	lea    0x1(%esi),%edi
f0100d27:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100d2b:	0f b6 03             	movzbl (%ebx),%eax
f0100d2e:	84 c0                	test   %al,%al
f0100d30:	74 8d                	je     f0100cbf <monitor+0x5f>
f0100d32:	83 ec 08             	sub    $0x8,%esp
f0100d35:	0f be c0             	movsbl %al,%eax
f0100d38:	50                   	push   %eax
f0100d39:	68 8a 7c 10 f0       	push   $0xf0107c8a
f0100d3e:	e8 33 57 00 00       	call   f0106476 <strchr>
f0100d43:	83 c4 10             	add    $0x10,%esp
f0100d46:	85 c0                	test   %eax,%eax
f0100d48:	0f 85 71 ff ff ff    	jne    f0100cbf <monitor+0x5f>
			buf++;
f0100d4e:	83 c3 01             	add    $0x1,%ebx
f0100d51:	eb d8                	jmp    f0100d2b <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d53:	83 ec 08             	sub    $0x8,%esp
f0100d56:	6a 10                	push   $0x10
f0100d58:	68 8f 7c 10 f0       	push   $0xf0107c8f
f0100d5d:	e8 0d 31 00 00       	call   f0103e6f <cprintf>
f0100d62:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100d65:	83 ec 0c             	sub    $0xc,%esp
f0100d68:	68 86 7c 10 f0       	push   $0xf0107c86
f0100d6d:	e8 d4 54 00 00       	call   f0106246 <readline>
f0100d72:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100d74:	83 c4 10             	add    $0x10,%esp
f0100d77:	85 c0                	test   %eax,%eax
f0100d79:	74 ea                	je     f0100d65 <monitor+0x105>
	argv[argc] = 0;
f0100d7b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100d82:	be 00 00 00 00       	mov    $0x0,%esi
f0100d87:	e9 35 ff ff ff       	jmp    f0100cc1 <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100d8c:	83 ec 04             	sub    $0x4,%esp
f0100d8f:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100d92:	ff 75 08             	pushl  0x8(%ebp)
f0100d95:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100d98:	52                   	push   %edx
f0100d99:	56                   	push   %esi
f0100d9a:	ff 14 85 08 80 10 f0 	call   *-0xfef7ff8(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100da1:	83 c4 10             	add    $0x10,%esp
f0100da4:	85 c0                	test   %eax,%eax
f0100da6:	79 bd                	jns    f0100d65 <monitor+0x105>
}
f0100da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100dab:	5b                   	pop    %ebx
f0100dac:	5e                   	pop    %esi
f0100dad:	5f                   	pop    %edi
f0100dae:	5d                   	pop    %ebp
f0100daf:	c3                   	ret    

f0100db0 <currentcycles>:
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100db0:	0f 31                	rdtsc  
    return result;
}
f0100db2:	c3                   	ret    

f0100db3 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100db3:	55                   	push   %ebp
f0100db4:	89 e5                	mov    %esp,%ebp
f0100db6:	56                   	push   %esi
f0100db7:	53                   	push   %ebx
f0100db8:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100dba:	83 ec 0c             	sub    $0xc,%esp
f0100dbd:	50                   	push   %eax
f0100dbe:	e8 05 2f 00 00       	call   f0103cc8 <mc146818_read>
f0100dc3:	89 c3                	mov    %eax,%ebx
f0100dc5:	83 c6 01             	add    $0x1,%esi
f0100dc8:	89 34 24             	mov    %esi,(%esp)
f0100dcb:	e8 f8 2e 00 00       	call   f0103cc8 <mc146818_read>
f0100dd0:	c1 e0 08             	shl    $0x8,%eax
f0100dd3:	09 d8                	or     %ebx,%eax
}
f0100dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100dd8:	5b                   	pop    %ebx
f0100dd9:	5e                   	pop    %esi
f0100dda:	5d                   	pop    %ebp
f0100ddb:	c3                   	ret    

f0100ddc <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100ddc:	89 d1                	mov    %edx,%ecx
f0100dde:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100de1:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100de4:	a8 01                	test   $0x1,%al
f0100de6:	74 52                	je     f0100e3a <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100de8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100ded:	89 c1                	mov    %eax,%ecx
f0100def:	c1 e9 0c             	shr    $0xc,%ecx
f0100df2:	3b 0d a8 be 57 f0    	cmp    0xf057bea8,%ecx
f0100df8:	73 25                	jae    f0100e1f <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100dfa:	c1 ea 0c             	shr    $0xc,%edx
f0100dfd:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100e03:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100e0a:	89 c2                	mov    %eax,%edx
f0100e0c:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100e0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e14:	85 d2                	test   %edx,%edx
f0100e16:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100e1b:	0f 44 c2             	cmove  %edx,%eax
f0100e1e:	c3                   	ret    
{
f0100e1f:	55                   	push   %ebp
f0100e20:	89 e5                	mov    %esp,%ebp
f0100e22:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e25:	50                   	push   %eax
f0100e26:	68 b4 78 10 f0       	push   $0xf01078b4
f0100e2b:	68 ad 03 00 00       	push   $0x3ad
f0100e30:	68 45 8a 10 f0       	push   $0xf0108a45
f0100e35:	e8 0f f2 ff ff       	call   f0100049 <_panic>
		return ~0;
f0100e3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100e3f:	c3                   	ret    

f0100e40 <boot_alloc>:
{
f0100e40:	55                   	push   %ebp
f0100e41:	89 e5                	mov    %esp,%ebp
f0100e43:	53                   	push   %ebx
f0100e44:	83 ec 04             	sub    $0x4,%esp
	if (!nextfree) {
f0100e47:	83 3d 38 a2 57 f0 00 	cmpl   $0x0,0xf057a238
f0100e4e:	74 40                	je     f0100e90 <boot_alloc+0x50>
	if(!n)
f0100e50:	85 c0                	test   %eax,%eax
f0100e52:	74 65                	je     f0100eb9 <boot_alloc+0x79>
f0100e54:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100e56:	a1 38 a2 57 f0       	mov    0xf057a238,%eax
	if ((uint32_t)kva < KERNBASE)
f0100e5b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e60:	76 5e                	jbe    f0100ec0 <boot_alloc+0x80>
f0100e62:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100e69:	c1 e9 0c             	shr    $0xc,%ecx
f0100e6c:	83 c1 01             	add    $0x1,%ecx
f0100e6f:	3b 0d a8 be 57 f0    	cmp    0xf057bea8,%ecx
f0100e75:	77 5b                	ja     f0100ed2 <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100e77:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e7d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e83:	01 c2                	add    %eax,%edx
f0100e85:	89 15 38 a2 57 f0    	mov    %edx,0xf057a238
}
f0100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100e8e:	c9                   	leave  
f0100e8f:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e90:	b9 40 ac 67 f0       	mov    $0xf067ac40,%ecx
f0100e95:	ba 3f bc 67 f0       	mov    $0xf067bc3f,%edx
f0100e9a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100ea0:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100ea6:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100eac:	85 c9                	test   %ecx,%ecx
f0100eae:	0f 44 d3             	cmove  %ebx,%edx
f0100eb1:	89 15 38 a2 57 f0    	mov    %edx,0xf057a238
f0100eb7:	eb 97                	jmp    f0100e50 <boot_alloc+0x10>
		return nextfree;
f0100eb9:	a1 38 a2 57 f0       	mov    0xf057a238,%eax
f0100ebe:	eb cb                	jmp    f0100e8b <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100ec0:	50                   	push   %eax
f0100ec1:	68 d8 78 10 f0       	push   $0xf01078d8
f0100ec6:	6a 72                	push   $0x72
f0100ec8:	68 45 8a 10 f0       	push   $0xf0108a45
f0100ecd:	e8 77 f1 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100ed2:	83 ec 04             	sub    $0x4,%esp
f0100ed5:	68 3c 80 10 f0       	push   $0xf010803c
f0100eda:	6a 73                	push   $0x73
f0100edc:	68 45 8a 10 f0       	push   $0xf0108a45
f0100ee1:	e8 63 f1 ff ff       	call   f0100049 <_panic>

f0100ee6 <check_page_free_list>:
{
f0100ee6:	55                   	push   %ebp
f0100ee7:	89 e5                	mov    %esp,%ebp
f0100ee9:	57                   	push   %edi
f0100eea:	56                   	push   %esi
f0100eeb:	53                   	push   %ebx
f0100eec:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100eef:	84 c0                	test   %al,%al
f0100ef1:	0f 85 77 02 00 00    	jne    f010116e <check_page_free_list+0x288>
	if (!page_free_list)
f0100ef7:	83 3d 40 a2 57 f0 00 	cmpl   $0x0,0xf057a240
f0100efe:	74 0a                	je     f0100f0a <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f00:	be 00 04 00 00       	mov    $0x400,%esi
f0100f05:	e9 bf 02 00 00       	jmp    f01011c9 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100f0a:	83 ec 04             	sub    $0x4,%esp
f0100f0d:	68 74 80 10 f0       	push   $0xf0108074
f0100f12:	68 dd 02 00 00       	push   $0x2dd
f0100f17:	68 45 8a 10 f0       	push   $0xf0108a45
f0100f1c:	e8 28 f1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f21:	50                   	push   %eax
f0100f22:	68 b4 78 10 f0       	push   $0xf01078b4
f0100f27:	6a 58                	push   $0x58
f0100f29:	68 51 8a 10 f0       	push   $0xf0108a51
f0100f2e:	e8 16 f1 ff ff       	call   f0100049 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0100f33:	8b 1b                	mov    (%ebx),%ebx
f0100f35:	85 db                	test   %ebx,%ebx
f0100f37:	74 41                	je     f0100f7a <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100f39:	89 d8                	mov    %ebx,%eax
f0100f3b:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0100f41:	c1 f8 03             	sar    $0x3,%eax
f0100f44:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100f47:	89 c2                	mov    %eax,%edx
f0100f49:	c1 ea 16             	shr    $0x16,%edx
f0100f4c:	39 f2                	cmp    %esi,%edx
f0100f4e:	73 e3                	jae    f0100f33 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100f50:	89 c2                	mov    %eax,%edx
f0100f52:	c1 ea 0c             	shr    $0xc,%edx
f0100f55:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0100f5b:	73 c4                	jae    f0100f21 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100f5d:	83 ec 04             	sub    $0x4,%esp
f0100f60:	68 80 00 00 00       	push   $0x80
f0100f65:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100f6a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f6f:	50                   	push   %eax
f0100f70:	e8 3e 55 00 00       	call   f01064b3 <memset>
f0100f75:	83 c4 10             	add    $0x10,%esp
f0100f78:	eb b9                	jmp    f0100f33 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100f7a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f7f:	e8 bc fe ff ff       	call   f0100e40 <boot_alloc>
f0100f84:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f87:	8b 15 40 a2 57 f0    	mov    0xf057a240,%edx
		assert(pp >= pages);
f0100f8d:	8b 0d b0 be 57 f0    	mov    0xf057beb0,%ecx
		assert(pp < pages + npages);
f0100f93:	a1 a8 be 57 f0       	mov    0xf057bea8,%eax
f0100f98:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f9b:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100f9e:	bf 00 00 00 00       	mov    $0x0,%edi
f0100fa3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100fa6:	e9 f9 00 00 00       	jmp    f01010a4 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100fab:	68 5f 8a 10 f0       	push   $0xf0108a5f
f0100fb0:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0100fb5:	68 f6 02 00 00       	push   $0x2f6
f0100fba:	68 45 8a 10 f0       	push   $0xf0108a45
f0100fbf:	e8 85 f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0100fc4:	68 80 8a 10 f0       	push   $0xf0108a80
f0100fc9:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0100fce:	68 f7 02 00 00       	push   $0x2f7
f0100fd3:	68 45 8a 10 f0       	push   $0xf0108a45
f0100fd8:	e8 6c f0 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100fdd:	68 98 80 10 f0       	push   $0xf0108098
f0100fe2:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0100fe7:	68 f8 02 00 00       	push   $0x2f8
f0100fec:	68 45 8a 10 f0       	push   $0xf0108a45
f0100ff1:	e8 53 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0100ff6:	68 94 8a 10 f0       	push   $0xf0108a94
f0100ffb:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101000:	68 fb 02 00 00       	push   $0x2fb
f0101005:	68 45 8a 10 f0       	push   $0xf0108a45
f010100a:	e8 3a f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f010100f:	68 a5 8a 10 f0       	push   $0xf0108aa5
f0101014:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101019:	68 fc 02 00 00       	push   $0x2fc
f010101e:	68 45 8a 10 f0       	push   $0xf0108a45
f0101023:	e8 21 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101028:	68 cc 80 10 f0       	push   $0xf01080cc
f010102d:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101032:	68 fd 02 00 00       	push   $0x2fd
f0101037:	68 45 8a 10 f0       	push   $0xf0108a45
f010103c:	e8 08 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101041:	68 be 8a 10 f0       	push   $0xf0108abe
f0101046:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010104b:	68 fe 02 00 00       	push   $0x2fe
f0101050:	68 45 8a 10 f0       	push   $0xf0108a45
f0101055:	e8 ef ef ff ff       	call   f0100049 <_panic>
	if (PGNUM(pa) >= npages)
f010105a:	89 c3                	mov    %eax,%ebx
f010105c:	c1 eb 0c             	shr    $0xc,%ebx
f010105f:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0101062:	76 0f                	jbe    f0101073 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0101064:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101069:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f010106c:	77 17                	ja     f0101085 <check_page_free_list+0x19f>
			++nfree_extmem;
f010106e:	83 c7 01             	add    $0x1,%edi
f0101071:	eb 2f                	jmp    f01010a2 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101073:	50                   	push   %eax
f0101074:	68 b4 78 10 f0       	push   $0xf01078b4
f0101079:	6a 58                	push   $0x58
f010107b:	68 51 8a 10 f0       	push   $0xf0108a51
f0101080:	e8 c4 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101085:	68 f0 80 10 f0       	push   $0xf01080f0
f010108a:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010108f:	68 ff 02 00 00       	push   $0x2ff
f0101094:	68 45 8a 10 f0       	push   $0xf0108a45
f0101099:	e8 ab ef ff ff       	call   f0100049 <_panic>
			++nfree_basemem;
f010109e:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010a2:	8b 12                	mov    (%edx),%edx
f01010a4:	85 d2                	test   %edx,%edx
f01010a6:	74 74                	je     f010111c <check_page_free_list+0x236>
		assert(pp >= pages);
f01010a8:	39 d1                	cmp    %edx,%ecx
f01010aa:	0f 87 fb fe ff ff    	ja     f0100fab <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f01010b0:	39 d6                	cmp    %edx,%esi
f01010b2:	0f 86 0c ff ff ff    	jbe    f0100fc4 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01010b8:	89 d0                	mov    %edx,%eax
f01010ba:	29 c8                	sub    %ecx,%eax
f01010bc:	a8 07                	test   $0x7,%al
f01010be:	0f 85 19 ff ff ff    	jne    f0100fdd <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f01010c4:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f01010c7:	c1 e0 0c             	shl    $0xc,%eax
f01010ca:	0f 84 26 ff ff ff    	je     f0100ff6 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f01010d0:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f01010d5:	0f 84 34 ff ff ff    	je     f010100f <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f01010db:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01010e0:	0f 84 42 ff ff ff    	je     f0101028 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f01010e6:	3d 00 00 10 00       	cmp    $0x100000,%eax
f01010eb:	0f 84 50 ff ff ff    	je     f0101041 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01010f1:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01010f6:	0f 87 5e ff ff ff    	ja     f010105a <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f01010fc:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0101101:	75 9b                	jne    f010109e <check_page_free_list+0x1b8>
f0101103:	68 d8 8a 10 f0       	push   $0xf0108ad8
f0101108:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010110d:	68 01 03 00 00       	push   $0x301
f0101112:	68 45 8a 10 f0       	push   $0xf0108a45
f0101117:	e8 2d ef ff ff       	call   f0100049 <_panic>
f010111c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f010111f:	85 db                	test   %ebx,%ebx
f0101121:	7e 19                	jle    f010113c <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0101123:	85 ff                	test   %edi,%edi
f0101125:	7e 2e                	jle    f0101155 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0101127:	83 ec 0c             	sub    $0xc,%esp
f010112a:	68 38 81 10 f0       	push   $0xf0108138
f010112f:	e8 3b 2d 00 00       	call   f0103e6f <cprintf>
}
f0101134:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101137:	5b                   	pop    %ebx
f0101138:	5e                   	pop    %esi
f0101139:	5f                   	pop    %edi
f010113a:	5d                   	pop    %ebp
f010113b:	c3                   	ret    
	assert(nfree_basemem > 0);
f010113c:	68 f5 8a 10 f0       	push   $0xf0108af5
f0101141:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101146:	68 08 03 00 00       	push   $0x308
f010114b:	68 45 8a 10 f0       	push   $0xf0108a45
f0101150:	e8 f4 ee ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f0101155:	68 07 8b 10 f0       	push   $0xf0108b07
f010115a:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010115f:	68 09 03 00 00       	push   $0x309
f0101164:	68 45 8a 10 f0       	push   $0xf0108a45
f0101169:	e8 db ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f010116e:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f0101173:	85 c0                	test   %eax,%eax
f0101175:	0f 84 8f fd ff ff    	je     f0100f0a <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010117b:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010117e:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101181:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101184:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101187:	89 c2                	mov    %eax,%edx
f0101189:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f010118f:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0101195:	0f 95 c2             	setne  %dl
f0101198:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f010119b:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f010119f:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f01011a1:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f01011a5:	8b 00                	mov    (%eax),%eax
f01011a7:	85 c0                	test   %eax,%eax
f01011a9:	75 dc                	jne    f0101187 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f01011ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01011ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f01011b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01011b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01011ba:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f01011bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01011bf:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01011c4:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f01011c9:	8b 1d 40 a2 57 f0    	mov    0xf057a240,%ebx
f01011cf:	e9 61 fd ff ff       	jmp    f0100f35 <check_page_free_list+0x4f>

f01011d4 <page_init>:
{
f01011d4:	55                   	push   %ebp
f01011d5:	89 e5                	mov    %esp,%ebp
f01011d7:	53                   	push   %ebx
f01011d8:	83 ec 04             	sub    $0x4,%esp
	for (size_t i = 0; i < npages; i++) {
f01011db:	bb 00 00 00 00       	mov    $0x0,%ebx
f01011e0:	eb 4c                	jmp    f010122e <page_init+0x5a>
		else if(i == MPENTRY_PADDR/PGSIZE){
f01011e2:	83 fb 07             	cmp    $0x7,%ebx
f01011e5:	74 32                	je     f0101219 <page_init+0x45>
		else if(i < IOPHYSMEM/PGSIZE){ //[PGSIZE, npages_basemem * PGSIZE)
f01011e7:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f01011ed:	77 62                	ja     f0101251 <page_init+0x7d>
f01011ef:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f01011f6:	89 c2                	mov    %eax,%edx
f01011f8:	03 15 b0 be 57 f0    	add    0xf057beb0,%edx
f01011fe:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101204:	8b 0d 40 a2 57 f0    	mov    0xf057a240,%ecx
f010120a:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f010120c:	03 05 b0 be 57 f0    	add    0xf057beb0,%eax
f0101212:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
f0101217:	eb 12                	jmp    f010122b <page_init+0x57>
			pages[i].pp_ref = 1;
f0101219:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
f010121e:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f0101224:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f010122b:	83 c3 01             	add    $0x1,%ebx
f010122e:	39 1d a8 be 57 f0    	cmp    %ebx,0xf057bea8
f0101234:	0f 86 94 00 00 00    	jbe    f01012ce <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f010123a:	85 db                	test   %ebx,%ebx
f010123c:	75 a4                	jne    f01011e2 <page_init+0xe>
			pages[i].pp_ref = 1;
f010123e:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
f0101243:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010124f:	eb da                	jmp    f010122b <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f0101251:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0101257:	77 16                	ja     f010126f <page_init+0x9b>
			pages[i].pp_ref = 1;
f0101259:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
f010125e:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
f0101261:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101267:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010126d:	eb bc                	jmp    f010122b <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f010126f:	b8 00 00 00 00       	mov    $0x0,%eax
f0101274:	e8 c7 fb ff ff       	call   f0100e40 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0101279:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010127e:	76 39                	jbe    f01012b9 <page_init+0xe5>
	return (physaddr_t)kva - KERNBASE;
f0101280:	05 00 00 00 10       	add    $0x10000000,%eax
f0101285:	c1 e8 0c             	shr    $0xc,%eax
f0101288:	39 d8                	cmp    %ebx,%eax
f010128a:	77 cd                	ja     f0101259 <page_init+0x85>
f010128c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f0101293:	89 c2                	mov    %eax,%edx
f0101295:	03 15 b0 be 57 f0    	add    0xf057beb0,%edx
f010129b:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f01012a1:	8b 0d 40 a2 57 f0    	mov    0xf057a240,%ecx
f01012a7:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f01012a9:	03 05 b0 be 57 f0    	add    0xf057beb0,%eax
f01012af:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
f01012b4:	e9 72 ff ff ff       	jmp    f010122b <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01012b9:	50                   	push   %eax
f01012ba:	68 d8 78 10 f0       	push   $0xf01078d8
f01012bf:	68 4d 01 00 00       	push   $0x14d
f01012c4:	68 45 8a 10 f0       	push   $0xf0108a45
f01012c9:	e8 7b ed ff ff       	call   f0100049 <_panic>
}
f01012ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012d1:	c9                   	leave  
f01012d2:	c3                   	ret    

f01012d3 <page_alloc>:
{
f01012d3:	55                   	push   %ebp
f01012d4:	89 e5                	mov    %esp,%ebp
f01012d6:	53                   	push   %ebx
f01012d7:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list)
f01012da:	8b 1d 40 a2 57 f0    	mov    0xf057a240,%ebx
f01012e0:	85 db                	test   %ebx,%ebx
f01012e2:	74 13                	je     f01012f7 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f01012e4:	8b 03                	mov    (%ebx),%eax
f01012e6:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
	result->pp_link = NULL;
f01012eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f01012f1:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01012f5:	75 07                	jne    f01012fe <page_alloc+0x2b>
}
f01012f7:	89 d8                	mov    %ebx,%eax
f01012f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012fc:	c9                   	leave  
f01012fd:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f01012fe:	89 d8                	mov    %ebx,%eax
f0101300:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0101306:	c1 f8 03             	sar    $0x3,%eax
f0101309:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010130c:	89 c2                	mov    %eax,%edx
f010130e:	c1 ea 0c             	shr    $0xc,%edx
f0101311:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0101317:	73 1a                	jae    f0101333 <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f0101319:	83 ec 04             	sub    $0x4,%esp
f010131c:	68 00 10 00 00       	push   $0x1000
f0101321:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101323:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101328:	50                   	push   %eax
f0101329:	e8 85 51 00 00       	call   f01064b3 <memset>
f010132e:	83 c4 10             	add    $0x10,%esp
f0101331:	eb c4                	jmp    f01012f7 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101333:	50                   	push   %eax
f0101334:	68 b4 78 10 f0       	push   $0xf01078b4
f0101339:	6a 58                	push   $0x58
f010133b:	68 51 8a 10 f0       	push   $0xf0108a51
f0101340:	e8 04 ed ff ff       	call   f0100049 <_panic>

f0101345 <page_free>:
{
f0101345:	55                   	push   %ebp
f0101346:	89 e5                	mov    %esp,%ebp
f0101348:	83 ec 08             	sub    $0x8,%esp
f010134b:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0 || pp->pp_link != NULL){
f010134e:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101353:	75 14                	jne    f0101369 <page_free+0x24>
f0101355:	83 38 00             	cmpl   $0x0,(%eax)
f0101358:	75 0f                	jne    f0101369 <page_free+0x24>
	pp->pp_link = page_free_list;
f010135a:	8b 15 40 a2 57 f0    	mov    0xf057a240,%edx
f0101360:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101362:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
}
f0101367:	c9                   	leave  
f0101368:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f0101369:	83 ec 04             	sub    $0x4,%esp
f010136c:	68 5c 81 10 f0       	push   $0xf010815c
f0101371:	68 81 01 00 00       	push   $0x181
f0101376:	68 45 8a 10 f0       	push   $0xf0108a45
f010137b:	e8 c9 ec ff ff       	call   f0100049 <_panic>

f0101380 <page_decref>:
{
f0101380:	55                   	push   %ebp
f0101381:	89 e5                	mov    %esp,%ebp
f0101383:	83 ec 08             	sub    $0x8,%esp
f0101386:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101389:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010138d:	83 e8 01             	sub    $0x1,%eax
f0101390:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101394:	66 85 c0             	test   %ax,%ax
f0101397:	74 02                	je     f010139b <page_decref+0x1b>
}
f0101399:	c9                   	leave  
f010139a:	c3                   	ret    
		page_free(pp);
f010139b:	83 ec 0c             	sub    $0xc,%esp
f010139e:	52                   	push   %edx
f010139f:	e8 a1 ff ff ff       	call   f0101345 <page_free>
f01013a4:	83 c4 10             	add    $0x10,%esp
}
f01013a7:	eb f0                	jmp    f0101399 <page_decref+0x19>

f01013a9 <pgdir_walk>:
{
f01013a9:	55                   	push   %ebp
f01013aa:	89 e5                	mov    %esp,%ebp
f01013ac:	56                   	push   %esi
f01013ad:	53                   	push   %ebx
f01013ae:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *fir_level = &pgdir[PDX(va)];
f01013b1:	89 f3                	mov    %esi,%ebx
f01013b3:	c1 eb 16             	shr    $0x16,%ebx
f01013b6:	c1 e3 02             	shl    $0x2,%ebx
f01013b9:	03 5d 08             	add    0x8(%ebp),%ebx
	if(*fir_level==0 && create == false){
f01013bc:	8b 03                	mov    (%ebx),%eax
f01013be:	89 c1                	mov    %eax,%ecx
f01013c0:	0b 4d 10             	or     0x10(%ebp),%ecx
f01013c3:	0f 84 a8 00 00 00    	je     f0101471 <pgdir_walk+0xc8>
	else if(*fir_level==0){
f01013c9:	85 c0                	test   %eax,%eax
f01013cb:	74 29                	je     f01013f6 <pgdir_walk+0x4d>
		sec_level = (pte_t *)(KADDR(PTE_ADDR(*fir_level)));
f01013cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01013d2:	89 c2                	mov    %eax,%edx
f01013d4:	c1 ea 0c             	shr    $0xc,%edx
f01013d7:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01013dd:	73 7d                	jae    f010145c <pgdir_walk+0xb3>
		return &sec_level[PTX(va)];
f01013df:	c1 ee 0a             	shr    $0xa,%esi
f01013e2:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01013e8:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f01013ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01013f2:	5b                   	pop    %ebx
f01013f3:	5e                   	pop    %esi
f01013f4:	5d                   	pop    %ebp
f01013f5:	c3                   	ret    
		struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
f01013f6:	83 ec 0c             	sub    $0xc,%esp
f01013f9:	6a 01                	push   $0x1
f01013fb:	e8 d3 fe ff ff       	call   f01012d3 <page_alloc>
		if(new_page == NULL)
f0101400:	83 c4 10             	add    $0x10,%esp
f0101403:	85 c0                	test   %eax,%eax
f0101405:	74 e8                	je     f01013ef <pgdir_walk+0x46>
		new_page->pp_ref++;
f0101407:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010140c:	89 c2                	mov    %eax,%edx
f010140e:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
f0101414:	c1 fa 03             	sar    $0x3,%edx
f0101417:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f010141a:	83 ca 07             	or     $0x7,%edx
f010141d:	89 13                	mov    %edx,(%ebx)
f010141f:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0101425:	c1 f8 03             	sar    $0x3,%eax
f0101428:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010142b:	89 c2                	mov    %eax,%edx
f010142d:	c1 ea 0c             	shr    $0xc,%edx
f0101430:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0101436:	73 12                	jae    f010144a <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f0101438:	c1 ee 0a             	shr    $0xa,%esi
f010143b:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101441:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0101448:	eb a5                	jmp    f01013ef <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010144a:	50                   	push   %eax
f010144b:	68 b4 78 10 f0       	push   $0xf01078b4
f0101450:	6a 58                	push   $0x58
f0101452:	68 51 8a 10 f0       	push   $0xf0108a51
f0101457:	e8 ed eb ff ff       	call   f0100049 <_panic>
f010145c:	50                   	push   %eax
f010145d:	68 b4 78 10 f0       	push   $0xf01078b4
f0101462:	68 bb 01 00 00       	push   $0x1bb
f0101467:	68 45 8a 10 f0       	push   $0xf0108a45
f010146c:	e8 d8 eb ff ff       	call   f0100049 <_panic>
		return NULL;
f0101471:	b8 00 00 00 00       	mov    $0x0,%eax
f0101476:	e9 74 ff ff ff       	jmp    f01013ef <pgdir_walk+0x46>

f010147b <boot_map_region>:
{
f010147b:	55                   	push   %ebp
f010147c:	89 e5                	mov    %esp,%ebp
f010147e:	57                   	push   %edi
f010147f:	56                   	push   %esi
f0101480:	53                   	push   %ebx
f0101481:	83 ec 1c             	sub    $0x1c,%esp
f0101484:	89 c7                	mov    %eax,%edi
f0101486:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(va%PGSIZE==0);
f0101489:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010148f:	75 4b                	jne    f01014dc <boot_map_region+0x61>
	assert(pa%PGSIZE==0);
f0101491:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0101496:	75 5d                	jne    f01014f5 <boot_map_region+0x7a>
f0101498:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010149e:	01 c1                	add    %eax,%ecx
f01014a0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f01014a3:	89 c3                	mov    %eax,%ebx
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f01014a5:	89 d6                	mov    %edx,%esi
f01014a7:	29 c6                	sub    %eax,%esi
	for(int i = 0; i < size/PGSIZE; i++){
f01014a9:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01014ac:	74 79                	je     f0101527 <boot_map_region+0xac>
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f01014ae:	83 ec 04             	sub    $0x4,%esp
f01014b1:	6a 01                	push   $0x1
f01014b3:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01014b6:	50                   	push   %eax
f01014b7:	57                   	push   %edi
f01014b8:	e8 ec fe ff ff       	call   f01013a9 <pgdir_walk>
		if(the_pte==NULL)
f01014bd:	83 c4 10             	add    $0x10,%esp
f01014c0:	85 c0                	test   %eax,%eax
f01014c2:	74 4a                	je     f010150e <boot_map_region+0x93>
		*the_pte = PTE_ADDR(pa) | perm | PTE_P;
f01014c4:	89 da                	mov    %ebx,%edx
f01014c6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01014cc:	0b 55 0c             	or     0xc(%ebp),%edx
f01014cf:	83 ca 01             	or     $0x1,%edx
f01014d2:	89 10                	mov    %edx,(%eax)
		pa+=PGSIZE;
f01014d4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01014da:	eb cd                	jmp    f01014a9 <boot_map_region+0x2e>
	assert(va%PGSIZE==0);
f01014dc:	68 18 8b 10 f0       	push   $0xf0108b18
f01014e1:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01014e6:	68 d0 01 00 00       	push   $0x1d0
f01014eb:	68 45 8a 10 f0       	push   $0xf0108a45
f01014f0:	e8 54 eb ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f01014f5:	68 25 8b 10 f0       	push   $0xf0108b25
f01014fa:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01014ff:	68 d1 01 00 00       	push   $0x1d1
f0101504:	68 45 8a 10 f0       	push   $0xf0108a45
f0101509:	e8 3b eb ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f010150e:	68 a4 8d 10 f0       	push   $0xf0108da4
f0101513:	68 32 8b 10 f0       	push   $0xf0108b32
f0101518:	68 d5 01 00 00       	push   $0x1d5
f010151d:	68 45 8a 10 f0       	push   $0xf0108a45
f0101522:	e8 22 eb ff ff       	call   f0100049 <_panic>
}
f0101527:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010152a:	5b                   	pop    %ebx
f010152b:	5e                   	pop    %esi
f010152c:	5f                   	pop    %edi
f010152d:	5d                   	pop    %ebp
f010152e:	c3                   	ret    

f010152f <page_lookup>:
{
f010152f:	55                   	push   %ebp
f0101530:	89 e5                	mov    %esp,%ebp
f0101532:	53                   	push   %ebx
f0101533:	83 ec 08             	sub    $0x8,%esp
f0101536:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *look_mapping = pgdir_walk(pgdir, va, 0);
f0101539:	6a 00                	push   $0x0
f010153b:	ff 75 0c             	pushl  0xc(%ebp)
f010153e:	ff 75 08             	pushl  0x8(%ebp)
f0101541:	e8 63 fe ff ff       	call   f01013a9 <pgdir_walk>
	if(look_mapping == NULL)
f0101546:	83 c4 10             	add    $0x10,%esp
f0101549:	85 c0                	test   %eax,%eax
f010154b:	74 27                	je     f0101574 <page_lookup+0x45>
	if(*look_mapping==0)
f010154d:	8b 10                	mov    (%eax),%edx
f010154f:	85 d2                	test   %edx,%edx
f0101551:	74 3a                	je     f010158d <page_lookup+0x5e>
	if(pte_store!=NULL && (*look_mapping&PTE_P))
f0101553:	85 db                	test   %ebx,%ebx
f0101555:	74 07                	je     f010155e <page_lookup+0x2f>
f0101557:	f6 c2 01             	test   $0x1,%dl
f010155a:	74 02                	je     f010155e <page_lookup+0x2f>
		*pte_store = look_mapping;
f010155c:	89 03                	mov    %eax,(%ebx)
f010155e:	8b 00                	mov    (%eax),%eax
f0101560:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101563:	39 05 a8 be 57 f0    	cmp    %eax,0xf057bea8
f0101569:	76 0e                	jbe    f0101579 <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010156b:	8b 15 b0 be 57 f0    	mov    0xf057beb0,%edx
f0101571:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101577:	c9                   	leave  
f0101578:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101579:	83 ec 04             	sub    $0x4,%esp
f010157c:	68 90 81 10 f0       	push   $0xf0108190
f0101581:	6a 51                	push   $0x51
f0101583:	68 51 8a 10 f0       	push   $0xf0108a51
f0101588:	e8 bc ea ff ff       	call   f0100049 <_panic>
		return NULL;
f010158d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101592:	eb e0                	jmp    f0101574 <page_lookup+0x45>

f0101594 <tlb_invalidate>:
{
f0101594:	55                   	push   %ebp
f0101595:	89 e5                	mov    %esp,%ebp
f0101597:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f010159a:	e8 1b 55 00 00       	call   f0106aba <cpunum>
f010159f:	6b c0 74             	imul   $0x74,%eax,%eax
f01015a2:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f01015a9:	74 16                	je     f01015c1 <tlb_invalidate+0x2d>
f01015ab:	e8 0a 55 00 00       	call   f0106aba <cpunum>
f01015b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01015b3:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01015b9:	8b 55 08             	mov    0x8(%ebp),%edx
f01015bc:	39 50 60             	cmp    %edx,0x60(%eax)
f01015bf:	75 06                	jne    f01015c7 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015c4:	0f 01 38             	invlpg (%eax)
}
f01015c7:	c9                   	leave  
f01015c8:	c3                   	ret    

f01015c9 <page_remove>:
{
f01015c9:	55                   	push   %ebp
f01015ca:	89 e5                	mov    %esp,%ebp
f01015cc:	56                   	push   %esi
f01015cd:	53                   	push   %ebx
f01015ce:	83 ec 14             	sub    $0x14,%esp
f01015d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01015d4:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *the_page = page_lookup(pgdir, va, &pg_store);
f01015d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01015da:	50                   	push   %eax
f01015db:	56                   	push   %esi
f01015dc:	53                   	push   %ebx
f01015dd:	e8 4d ff ff ff       	call   f010152f <page_lookup>
	if(!the_page)
f01015e2:	83 c4 10             	add    $0x10,%esp
f01015e5:	85 c0                	test   %eax,%eax
f01015e7:	74 1f                	je     f0101608 <page_remove+0x3f>
	page_decref(the_page);
f01015e9:	83 ec 0c             	sub    $0xc,%esp
f01015ec:	50                   	push   %eax
f01015ed:	e8 8e fd ff ff       	call   f0101380 <page_decref>
	*pg_store = 0;
f01015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01015f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f01015fb:	83 c4 08             	add    $0x8,%esp
f01015fe:	56                   	push   %esi
f01015ff:	53                   	push   %ebx
f0101600:	e8 8f ff ff ff       	call   f0101594 <tlb_invalidate>
f0101605:	83 c4 10             	add    $0x10,%esp
}
f0101608:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010160b:	5b                   	pop    %ebx
f010160c:	5e                   	pop    %esi
f010160d:	5d                   	pop    %ebp
f010160e:	c3                   	ret    

f010160f <page_insert>:
{
f010160f:	55                   	push   %ebp
f0101610:	89 e5                	mov    %esp,%ebp
f0101612:	57                   	push   %edi
f0101613:	56                   	push   %esi
f0101614:	53                   	push   %ebx
f0101615:	83 ec 10             	sub    $0x10,%esp
f0101618:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *the_pte = pgdir_walk(pgdir, va, 1);
f010161b:	6a 01                	push   $0x1
f010161d:	ff 75 10             	pushl  0x10(%ebp)
f0101620:	ff 75 08             	pushl  0x8(%ebp)
f0101623:	e8 81 fd ff ff       	call   f01013a9 <pgdir_walk>
	if(the_pte == NULL){
f0101628:	83 c4 10             	add    $0x10,%esp
f010162b:	85 c0                	test   %eax,%eax
f010162d:	0f 84 b7 00 00 00    	je     f01016ea <page_insert+0xdb>
f0101633:	89 c6                	mov    %eax,%esi
		if(KADDR(PTE_ADDR(*the_pte)) == page2kva(pp)){
f0101635:	8b 10                	mov    (%eax),%edx
f0101637:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f010163d:	8b 0d a8 be 57 f0    	mov    0xf057bea8,%ecx
f0101643:	89 d0                	mov    %edx,%eax
f0101645:	c1 e8 0c             	shr    $0xc,%eax
f0101648:	39 c1                	cmp    %eax,%ecx
f010164a:	76 5f                	jbe    f01016ab <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f010164c:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f0101652:	89 d8                	mov    %ebx,%eax
f0101654:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f010165a:	c1 f8 03             	sar    $0x3,%eax
f010165d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101660:	89 c7                	mov    %eax,%edi
f0101662:	c1 ef 0c             	shr    $0xc,%edi
f0101665:	39 f9                	cmp    %edi,%ecx
f0101667:	76 57                	jbe    f01016c0 <page_insert+0xb1>
	return (void *)(pa + KERNBASE);
f0101669:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010166e:	39 c2                	cmp    %eax,%edx
f0101670:	74 60                	je     f01016d2 <page_insert+0xc3>
			page_remove(pgdir, va);
f0101672:	83 ec 08             	sub    $0x8,%esp
f0101675:	ff 75 10             	pushl  0x10(%ebp)
f0101678:	ff 75 08             	pushl  0x8(%ebp)
f010167b:	e8 49 ff ff ff       	call   f01015c9 <page_remove>
f0101680:	83 c4 10             	add    $0x10,%esp
	return (pp - pages) << PGSHIFT;
f0101683:	89 d8                	mov    %ebx,%eax
f0101685:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f010168b:	c1 f8 03             	sar    $0x3,%eax
f010168e:	c1 e0 0c             	shl    $0xc,%eax
	*the_pte = page2pa(pp) | perm | PTE_P;
f0101691:	0b 45 14             	or     0x14(%ebp),%eax
f0101694:	83 c8 01             	or     $0x1,%eax
f0101697:	89 06                	mov    %eax,(%esi)
	pp->pp_ref++;
f0101699:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	return 0;
f010169e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01016a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01016a6:	5b                   	pop    %ebx
f01016a7:	5e                   	pop    %esi
f01016a8:	5f                   	pop    %edi
f01016a9:	5d                   	pop    %ebp
f01016aa:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01016ab:	52                   	push   %edx
f01016ac:	68 b4 78 10 f0       	push   $0xf01078b4
f01016b1:	68 17 02 00 00       	push   $0x217
f01016b6:	68 45 8a 10 f0       	push   $0xf0108a45
f01016bb:	e8 89 e9 ff ff       	call   f0100049 <_panic>
f01016c0:	50                   	push   %eax
f01016c1:	68 b4 78 10 f0       	push   $0xf01078b4
f01016c6:	6a 58                	push   $0x58
f01016c8:	68 51 8a 10 f0       	push   $0xf0108a51
f01016cd:	e8 77 e9 ff ff       	call   f0100049 <_panic>
			tlb_invalidate(pgdir, va);
f01016d2:	83 ec 08             	sub    $0x8,%esp
f01016d5:	ff 75 10             	pushl  0x10(%ebp)
f01016d8:	ff 75 08             	pushl  0x8(%ebp)
f01016db:	e8 b4 fe ff ff       	call   f0101594 <tlb_invalidate>
			pp->pp_ref--;
f01016e0:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
f01016e5:	83 c4 10             	add    $0x10,%esp
f01016e8:	eb 99                	jmp    f0101683 <page_insert+0x74>
		return -E_NO_MEM;
f01016ea:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01016ef:	eb b2                	jmp    f01016a3 <page_insert+0x94>

f01016f1 <mmio_map_region>:
{
f01016f1:	55                   	push   %ebp
f01016f2:	89 e5                	mov    %esp,%ebp
f01016f4:	56                   	push   %esi
f01016f5:	53                   	push   %ebx
	size = ROUNDUP(size, PGSIZE);
f01016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016f9:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f01016ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((base + size) > MMIOLIM){
f0101705:	8b 35 04 73 12 f0    	mov    0xf0127304,%esi
f010170b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f010170e:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101713:	77 25                	ja     f010173a <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101715:	83 ec 08             	sub    $0x8,%esp
f0101718:	6a 1a                	push   $0x1a
f010171a:	ff 75 08             	pushl  0x8(%ebp)
f010171d:	89 d9                	mov    %ebx,%ecx
f010171f:	89 f2                	mov    %esi,%edx
f0101721:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0101726:	e8 50 fd ff ff       	call   f010147b <boot_map_region>
	base += size;
f010172b:	01 1d 04 73 12 f0    	add    %ebx,0xf0127304
}
f0101731:	89 f0                	mov    %esi,%eax
f0101733:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101736:	5b                   	pop    %ebx
f0101737:	5e                   	pop    %esi
f0101738:	5d                   	pop    %ebp
f0101739:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f010173a:	83 ec 04             	sub    $0x4,%esp
f010173d:	68 3c 8b 10 f0       	push   $0xf0108b3c
f0101742:	68 88 02 00 00       	push   $0x288
f0101747:	68 45 8a 10 f0       	push   $0xf0108a45
f010174c:	e8 f8 e8 ff ff       	call   f0100049 <_panic>

f0101751 <mem_init>:
{
f0101751:	55                   	push   %ebp
f0101752:	89 e5                	mov    %esp,%ebp
f0101754:	57                   	push   %edi
f0101755:	56                   	push   %esi
f0101756:	53                   	push   %ebx
f0101757:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f010175a:	b8 15 00 00 00       	mov    $0x15,%eax
f010175f:	e8 4f f6 ff ff       	call   f0100db3 <nvram_read>
f0101764:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101766:	b8 17 00 00 00       	mov    $0x17,%eax
f010176b:	e8 43 f6 ff ff       	call   f0100db3 <nvram_read>
f0101770:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101772:	b8 34 00 00 00       	mov    $0x34,%eax
f0101777:	e8 37 f6 ff ff       	call   f0100db3 <nvram_read>
	if (ext16mem)
f010177c:	c1 e0 06             	shl    $0x6,%eax
f010177f:	0f 84 e5 00 00 00    	je     f010186a <mem_init+0x119>
		totalmem = 16 * 1024 + ext16mem;
f0101785:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010178a:	89 c2                	mov    %eax,%edx
f010178c:	c1 ea 02             	shr    $0x2,%edx
f010178f:	89 15 a8 be 57 f0    	mov    %edx,0xf057bea8
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101795:	89 c2                	mov    %eax,%edx
f0101797:	29 da                	sub    %ebx,%edx
f0101799:	52                   	push   %edx
f010179a:	53                   	push   %ebx
f010179b:	50                   	push   %eax
f010179c:	68 b0 81 10 f0       	push   $0xf01081b0
f01017a1:	e8 c9 26 00 00       	call   f0103e6f <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01017a6:	b8 00 10 00 00       	mov    $0x1000,%eax
f01017ab:	e8 90 f6 ff ff       	call   f0100e40 <boot_alloc>
f01017b0:	a3 ac be 57 f0       	mov    %eax,0xf057beac
	memset(kern_pgdir, 0, PGSIZE);
f01017b5:	83 c4 0c             	add    $0xc,%esp
f01017b8:	68 00 10 00 00       	push   $0x1000
f01017bd:	6a 00                	push   $0x0
f01017bf:	50                   	push   %eax
f01017c0:	e8 ee 4c 00 00       	call   f01064b3 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01017c5:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f01017ca:	83 c4 10             	add    $0x10,%esp
f01017cd:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017d2:	0f 86 a2 00 00 00    	jbe    f010187a <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f01017d8:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017de:	83 ca 05             	or     $0x5,%edx
f01017e1:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f01017e7:	a1 a8 be 57 f0       	mov    0xf057bea8,%eax
f01017ec:	c1 e0 03             	shl    $0x3,%eax
f01017ef:	e8 4c f6 ff ff       	call   f0100e40 <boot_alloc>
f01017f4:	a3 b0 be 57 f0       	mov    %eax,0xf057beb0
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01017f9:	83 ec 04             	sub    $0x4,%esp
f01017fc:	8b 15 a8 be 57 f0    	mov    0xf057bea8,%edx
f0101802:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0101809:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010180f:	52                   	push   %edx
f0101810:	6a 00                	push   $0x0
f0101812:	50                   	push   %eax
f0101813:	e8 9b 4c 00 00       	call   f01064b3 <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101818:	b8 00 00 02 00       	mov    $0x20000,%eax
f010181d:	e8 1e f6 ff ff       	call   f0100e40 <boot_alloc>
f0101822:	a3 44 a2 57 f0       	mov    %eax,0xf057a244
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101827:	83 c4 0c             	add    $0xc,%esp
f010182a:	68 00 00 02 00       	push   $0x20000
f010182f:	6a 00                	push   $0x0
f0101831:	50                   	push   %eax
f0101832:	e8 7c 4c 00 00       	call   f01064b3 <memset>
	page_init();
f0101837:	e8 98 f9 ff ff       	call   f01011d4 <page_init>
	check_page_free_list(1);
f010183c:	b8 01 00 00 00       	mov    $0x1,%eax
f0101841:	e8 a0 f6 ff ff       	call   f0100ee6 <check_page_free_list>
	if (!pages)
f0101846:	83 c4 10             	add    $0x10,%esp
f0101849:	83 3d b0 be 57 f0 00 	cmpl   $0x0,0xf057beb0
f0101850:	74 3d                	je     f010188f <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101852:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f0101857:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010185e:	85 c0                	test   %eax,%eax
f0101860:	74 44                	je     f01018a6 <mem_init+0x155>
		++nfree;
f0101862:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101866:	8b 00                	mov    (%eax),%eax
f0101868:	eb f4                	jmp    f010185e <mem_init+0x10d>
		totalmem = 1 * 1024 + extmem;
f010186a:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101870:	85 f6                	test   %esi,%esi
f0101872:	0f 44 c3             	cmove  %ebx,%eax
f0101875:	e9 10 ff ff ff       	jmp    f010178a <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010187a:	50                   	push   %eax
f010187b:	68 d8 78 10 f0       	push   $0xf01078d8
f0101880:	68 9a 00 00 00       	push   $0x9a
f0101885:	68 45 8a 10 f0       	push   $0xf0108a45
f010188a:	e8 ba e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f010188f:	83 ec 04             	sub    $0x4,%esp
f0101892:	68 4e 8b 10 f0       	push   $0xf0108b4e
f0101897:	68 1c 03 00 00       	push   $0x31c
f010189c:	68 45 8a 10 f0       	push   $0xf0108a45
f01018a1:	e8 a3 e7 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f01018a6:	83 ec 0c             	sub    $0xc,%esp
f01018a9:	6a 00                	push   $0x0
f01018ab:	e8 23 fa ff ff       	call   f01012d3 <page_alloc>
f01018b0:	89 c3                	mov    %eax,%ebx
f01018b2:	83 c4 10             	add    $0x10,%esp
f01018b5:	85 c0                	test   %eax,%eax
f01018b7:	0f 84 00 02 00 00    	je     f0101abd <mem_init+0x36c>
	assert((pp1 = page_alloc(0)));
f01018bd:	83 ec 0c             	sub    $0xc,%esp
f01018c0:	6a 00                	push   $0x0
f01018c2:	e8 0c fa ff ff       	call   f01012d3 <page_alloc>
f01018c7:	89 c6                	mov    %eax,%esi
f01018c9:	83 c4 10             	add    $0x10,%esp
f01018cc:	85 c0                	test   %eax,%eax
f01018ce:	0f 84 02 02 00 00    	je     f0101ad6 <mem_init+0x385>
	assert((pp2 = page_alloc(0)));
f01018d4:	83 ec 0c             	sub    $0xc,%esp
f01018d7:	6a 00                	push   $0x0
f01018d9:	e8 f5 f9 ff ff       	call   f01012d3 <page_alloc>
f01018de:	89 c7                	mov    %eax,%edi
f01018e0:	83 c4 10             	add    $0x10,%esp
f01018e3:	85 c0                	test   %eax,%eax
f01018e5:	0f 84 04 02 00 00    	je     f0101aef <mem_init+0x39e>
	assert(pp1 && pp1 != pp0);
f01018eb:	39 f3                	cmp    %esi,%ebx
f01018ed:	0f 84 15 02 00 00    	je     f0101b08 <mem_init+0x3b7>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018f3:	39 c3                	cmp    %eax,%ebx
f01018f5:	0f 84 26 02 00 00    	je     f0101b21 <mem_init+0x3d0>
f01018fb:	39 c6                	cmp    %eax,%esi
f01018fd:	0f 84 1e 02 00 00    	je     f0101b21 <mem_init+0x3d0>
	return (pp - pages) << PGSHIFT;
f0101903:	8b 0d b0 be 57 f0    	mov    0xf057beb0,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101909:	8b 15 a8 be 57 f0    	mov    0xf057bea8,%edx
f010190f:	c1 e2 0c             	shl    $0xc,%edx
f0101912:	89 d8                	mov    %ebx,%eax
f0101914:	29 c8                	sub    %ecx,%eax
f0101916:	c1 f8 03             	sar    $0x3,%eax
f0101919:	c1 e0 0c             	shl    $0xc,%eax
f010191c:	39 d0                	cmp    %edx,%eax
f010191e:	0f 83 16 02 00 00    	jae    f0101b3a <mem_init+0x3e9>
f0101924:	89 f0                	mov    %esi,%eax
f0101926:	29 c8                	sub    %ecx,%eax
f0101928:	c1 f8 03             	sar    $0x3,%eax
f010192b:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f010192e:	39 c2                	cmp    %eax,%edx
f0101930:	0f 86 1d 02 00 00    	jbe    f0101b53 <mem_init+0x402>
f0101936:	89 f8                	mov    %edi,%eax
f0101938:	29 c8                	sub    %ecx,%eax
f010193a:	c1 f8 03             	sar    $0x3,%eax
f010193d:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101940:	39 c2                	cmp    %eax,%edx
f0101942:	0f 86 24 02 00 00    	jbe    f0101b6c <mem_init+0x41b>
	fl = page_free_list;
f0101948:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f010194d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101950:	c7 05 40 a2 57 f0 00 	movl   $0x0,0xf057a240
f0101957:	00 00 00 
	assert(!page_alloc(0));
f010195a:	83 ec 0c             	sub    $0xc,%esp
f010195d:	6a 00                	push   $0x0
f010195f:	e8 6f f9 ff ff       	call   f01012d3 <page_alloc>
f0101964:	83 c4 10             	add    $0x10,%esp
f0101967:	85 c0                	test   %eax,%eax
f0101969:	0f 85 16 02 00 00    	jne    f0101b85 <mem_init+0x434>
	page_free(pp0);
f010196f:	83 ec 0c             	sub    $0xc,%esp
f0101972:	53                   	push   %ebx
f0101973:	e8 cd f9 ff ff       	call   f0101345 <page_free>
	page_free(pp1);
f0101978:	89 34 24             	mov    %esi,(%esp)
f010197b:	e8 c5 f9 ff ff       	call   f0101345 <page_free>
	page_free(pp2);
f0101980:	89 3c 24             	mov    %edi,(%esp)
f0101983:	e8 bd f9 ff ff       	call   f0101345 <page_free>
	assert((pp0 = page_alloc(0)));
f0101988:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010198f:	e8 3f f9 ff ff       	call   f01012d3 <page_alloc>
f0101994:	89 c3                	mov    %eax,%ebx
f0101996:	83 c4 10             	add    $0x10,%esp
f0101999:	85 c0                	test   %eax,%eax
f010199b:	0f 84 fd 01 00 00    	je     f0101b9e <mem_init+0x44d>
	assert((pp1 = page_alloc(0)));
f01019a1:	83 ec 0c             	sub    $0xc,%esp
f01019a4:	6a 00                	push   $0x0
f01019a6:	e8 28 f9 ff ff       	call   f01012d3 <page_alloc>
f01019ab:	89 c6                	mov    %eax,%esi
f01019ad:	83 c4 10             	add    $0x10,%esp
f01019b0:	85 c0                	test   %eax,%eax
f01019b2:	0f 84 ff 01 00 00    	je     f0101bb7 <mem_init+0x466>
	assert((pp2 = page_alloc(0)));
f01019b8:	83 ec 0c             	sub    $0xc,%esp
f01019bb:	6a 00                	push   $0x0
f01019bd:	e8 11 f9 ff ff       	call   f01012d3 <page_alloc>
f01019c2:	89 c7                	mov    %eax,%edi
f01019c4:	83 c4 10             	add    $0x10,%esp
f01019c7:	85 c0                	test   %eax,%eax
f01019c9:	0f 84 01 02 00 00    	je     f0101bd0 <mem_init+0x47f>
	assert(pp1 && pp1 != pp0);
f01019cf:	39 f3                	cmp    %esi,%ebx
f01019d1:	0f 84 12 02 00 00    	je     f0101be9 <mem_init+0x498>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019d7:	39 c6                	cmp    %eax,%esi
f01019d9:	0f 84 23 02 00 00    	je     f0101c02 <mem_init+0x4b1>
f01019df:	39 c3                	cmp    %eax,%ebx
f01019e1:	0f 84 1b 02 00 00    	je     f0101c02 <mem_init+0x4b1>
	assert(!page_alloc(0));
f01019e7:	83 ec 0c             	sub    $0xc,%esp
f01019ea:	6a 00                	push   $0x0
f01019ec:	e8 e2 f8 ff ff       	call   f01012d3 <page_alloc>
f01019f1:	83 c4 10             	add    $0x10,%esp
f01019f4:	85 c0                	test   %eax,%eax
f01019f6:	0f 85 1f 02 00 00    	jne    f0101c1b <mem_init+0x4ca>
f01019fc:	89 d8                	mov    %ebx,%eax
f01019fe:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0101a04:	c1 f8 03             	sar    $0x3,%eax
f0101a07:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a0a:	89 c2                	mov    %eax,%edx
f0101a0c:	c1 ea 0c             	shr    $0xc,%edx
f0101a0f:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0101a15:	0f 83 19 02 00 00    	jae    f0101c34 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a1b:	83 ec 04             	sub    $0x4,%esp
f0101a1e:	68 00 10 00 00       	push   $0x1000
f0101a23:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101a25:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a2a:	50                   	push   %eax
f0101a2b:	e8 83 4a 00 00       	call   f01064b3 <memset>
	page_free(pp0);
f0101a30:	89 1c 24             	mov    %ebx,(%esp)
f0101a33:	e8 0d f9 ff ff       	call   f0101345 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101a38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101a3f:	e8 8f f8 ff ff       	call   f01012d3 <page_alloc>
f0101a44:	83 c4 10             	add    $0x10,%esp
f0101a47:	85 c0                	test   %eax,%eax
f0101a49:	0f 84 f7 01 00 00    	je     f0101c46 <mem_init+0x4f5>
	assert(pp && pp0 == pp);
f0101a4f:	39 c3                	cmp    %eax,%ebx
f0101a51:	0f 85 08 02 00 00    	jne    f0101c5f <mem_init+0x50e>
	return (pp - pages) << PGSHIFT;
f0101a57:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0101a5d:	c1 f8 03             	sar    $0x3,%eax
f0101a60:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a63:	89 c2                	mov    %eax,%edx
f0101a65:	c1 ea 0c             	shr    $0xc,%edx
f0101a68:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0101a6e:	0f 83 04 02 00 00    	jae    f0101c78 <mem_init+0x527>
	return (void *)(pa + KERNBASE);
f0101a74:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101a7a:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101a7f:	80 3a 00             	cmpb   $0x0,(%edx)
f0101a82:	0f 85 02 02 00 00    	jne    f0101c8a <mem_init+0x539>
f0101a88:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101a8b:	39 c2                	cmp    %eax,%edx
f0101a8d:	75 f0                	jne    f0101a7f <mem_init+0x32e>
	page_free_list = fl;
f0101a8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101a92:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
	page_free(pp0);
f0101a97:	83 ec 0c             	sub    $0xc,%esp
f0101a9a:	53                   	push   %ebx
f0101a9b:	e8 a5 f8 ff ff       	call   f0101345 <page_free>
	page_free(pp1);
f0101aa0:	89 34 24             	mov    %esi,(%esp)
f0101aa3:	e8 9d f8 ff ff       	call   f0101345 <page_free>
	page_free(pp2);
f0101aa8:	89 3c 24             	mov    %edi,(%esp)
f0101aab:	e8 95 f8 ff ff       	call   f0101345 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101ab0:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f0101ab5:	83 c4 10             	add    $0x10,%esp
f0101ab8:	e9 ec 01 00 00       	jmp    f0101ca9 <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101abd:	68 69 8b 10 f0       	push   $0xf0108b69
f0101ac2:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101ac7:	68 24 03 00 00       	push   $0x324
f0101acc:	68 45 8a 10 f0       	push   $0xf0108a45
f0101ad1:	e8 73 e5 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ad6:	68 7f 8b 10 f0       	push   $0xf0108b7f
f0101adb:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101ae0:	68 25 03 00 00       	push   $0x325
f0101ae5:	68 45 8a 10 f0       	push   $0xf0108a45
f0101aea:	e8 5a e5 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101aef:	68 95 8b 10 f0       	push   $0xf0108b95
f0101af4:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101af9:	68 26 03 00 00       	push   $0x326
f0101afe:	68 45 8a 10 f0       	push   $0xf0108a45
f0101b03:	e8 41 e5 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101b08:	68 ab 8b 10 f0       	push   $0xf0108bab
f0101b0d:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101b12:	68 29 03 00 00       	push   $0x329
f0101b17:	68 45 8a 10 f0       	push   $0xf0108a45
f0101b1c:	e8 28 e5 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b21:	68 ec 81 10 f0       	push   $0xf01081ec
f0101b26:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101b2b:	68 2a 03 00 00       	push   $0x32a
f0101b30:	68 45 8a 10 f0       	push   $0xf0108a45
f0101b35:	e8 0f e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b3a:	68 bd 8b 10 f0       	push   $0xf0108bbd
f0101b3f:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101b44:	68 2b 03 00 00       	push   $0x32b
f0101b49:	68 45 8a 10 f0       	push   $0xf0108a45
f0101b4e:	e8 f6 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b53:	68 da 8b 10 f0       	push   $0xf0108bda
f0101b58:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101b5d:	68 2c 03 00 00       	push   $0x32c
f0101b62:	68 45 8a 10 f0       	push   $0xf0108a45
f0101b67:	e8 dd e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b6c:	68 f7 8b 10 f0       	push   $0xf0108bf7
f0101b71:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101b76:	68 2d 03 00 00       	push   $0x32d
f0101b7b:	68 45 8a 10 f0       	push   $0xf0108a45
f0101b80:	e8 c4 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101b85:	68 14 8c 10 f0       	push   $0xf0108c14
f0101b8a:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101b8f:	68 34 03 00 00       	push   $0x334
f0101b94:	68 45 8a 10 f0       	push   $0xf0108a45
f0101b99:	e8 ab e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101b9e:	68 69 8b 10 f0       	push   $0xf0108b69
f0101ba3:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101ba8:	68 3b 03 00 00       	push   $0x33b
f0101bad:	68 45 8a 10 f0       	push   $0xf0108a45
f0101bb2:	e8 92 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101bb7:	68 7f 8b 10 f0       	push   $0xf0108b7f
f0101bbc:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101bc1:	68 3c 03 00 00       	push   $0x33c
f0101bc6:	68 45 8a 10 f0       	push   $0xf0108a45
f0101bcb:	e8 79 e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101bd0:	68 95 8b 10 f0       	push   $0xf0108b95
f0101bd5:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101bda:	68 3d 03 00 00       	push   $0x33d
f0101bdf:	68 45 8a 10 f0       	push   $0xf0108a45
f0101be4:	e8 60 e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101be9:	68 ab 8b 10 f0       	push   $0xf0108bab
f0101bee:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101bf3:	68 3f 03 00 00       	push   $0x33f
f0101bf8:	68 45 8a 10 f0       	push   $0xf0108a45
f0101bfd:	e8 47 e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c02:	68 ec 81 10 f0       	push   $0xf01081ec
f0101c07:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101c0c:	68 40 03 00 00       	push   $0x340
f0101c11:	68 45 8a 10 f0       	push   $0xf0108a45
f0101c16:	e8 2e e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c1b:	68 14 8c 10 f0       	push   $0xf0108c14
f0101c20:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101c25:	68 41 03 00 00       	push   $0x341
f0101c2a:	68 45 8a 10 f0       	push   $0xf0108a45
f0101c2f:	e8 15 e4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c34:	50                   	push   %eax
f0101c35:	68 b4 78 10 f0       	push   $0xf01078b4
f0101c3a:	6a 58                	push   $0x58
f0101c3c:	68 51 8a 10 f0       	push   $0xf0108a51
f0101c41:	e8 03 e4 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101c46:	68 23 8c 10 f0       	push   $0xf0108c23
f0101c4b:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101c50:	68 46 03 00 00       	push   $0x346
f0101c55:	68 45 8a 10 f0       	push   $0xf0108a45
f0101c5a:	e8 ea e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101c5f:	68 41 8c 10 f0       	push   $0xf0108c41
f0101c64:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101c69:	68 47 03 00 00       	push   $0x347
f0101c6e:	68 45 8a 10 f0       	push   $0xf0108a45
f0101c73:	e8 d1 e3 ff ff       	call   f0100049 <_panic>
f0101c78:	50                   	push   %eax
f0101c79:	68 b4 78 10 f0       	push   $0xf01078b4
f0101c7e:	6a 58                	push   $0x58
f0101c80:	68 51 8a 10 f0       	push   $0xf0108a51
f0101c85:	e8 bf e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101c8a:	68 51 8c 10 f0       	push   $0xf0108c51
f0101c8f:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0101c94:	68 4a 03 00 00       	push   $0x34a
f0101c99:	68 45 8a 10 f0       	push   $0xf0108a45
f0101c9e:	e8 a6 e3 ff ff       	call   f0100049 <_panic>
		--nfree;
f0101ca3:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101ca7:	8b 00                	mov    (%eax),%eax
f0101ca9:	85 c0                	test   %eax,%eax
f0101cab:	75 f6                	jne    f0101ca3 <mem_init+0x552>
	assert(nfree == 0);
f0101cad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101cb1:	0f 85 65 09 00 00    	jne    f010261c <mem_init+0xecb>
	cprintf("check_page_alloc() succeeded!\n");
f0101cb7:	83 ec 0c             	sub    $0xc,%esp
f0101cba:	68 0c 82 10 f0       	push   $0xf010820c
f0101cbf:	e8 ab 21 00 00       	call   f0103e6f <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101cc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ccb:	e8 03 f6 ff ff       	call   f01012d3 <page_alloc>
f0101cd0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101cd3:	83 c4 10             	add    $0x10,%esp
f0101cd6:	85 c0                	test   %eax,%eax
f0101cd8:	0f 84 57 09 00 00    	je     f0102635 <mem_init+0xee4>
	assert((pp1 = page_alloc(0)));
f0101cde:	83 ec 0c             	sub    $0xc,%esp
f0101ce1:	6a 00                	push   $0x0
f0101ce3:	e8 eb f5 ff ff       	call   f01012d3 <page_alloc>
f0101ce8:	89 c7                	mov    %eax,%edi
f0101cea:	83 c4 10             	add    $0x10,%esp
f0101ced:	85 c0                	test   %eax,%eax
f0101cef:	0f 84 59 09 00 00    	je     f010264e <mem_init+0xefd>
	assert((pp2 = page_alloc(0)));
f0101cf5:	83 ec 0c             	sub    $0xc,%esp
f0101cf8:	6a 00                	push   $0x0
f0101cfa:	e8 d4 f5 ff ff       	call   f01012d3 <page_alloc>
f0101cff:	89 c3                	mov    %eax,%ebx
f0101d01:	83 c4 10             	add    $0x10,%esp
f0101d04:	85 c0                	test   %eax,%eax
f0101d06:	0f 84 5b 09 00 00    	je     f0102667 <mem_init+0xf16>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101d0c:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101d0f:	0f 84 6b 09 00 00    	je     f0102680 <mem_init+0xf2f>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d15:	39 c7                	cmp    %eax,%edi
f0101d17:	0f 84 7c 09 00 00    	je     f0102699 <mem_init+0xf48>
f0101d1d:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101d20:	0f 84 73 09 00 00    	je     f0102699 <mem_init+0xf48>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101d26:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f0101d2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101d2e:	c7 05 40 a2 57 f0 00 	movl   $0x0,0xf057a240
f0101d35:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101d38:	83 ec 0c             	sub    $0xc,%esp
f0101d3b:	6a 00                	push   $0x0
f0101d3d:	e8 91 f5 ff ff       	call   f01012d3 <page_alloc>
f0101d42:	83 c4 10             	add    $0x10,%esp
f0101d45:	85 c0                	test   %eax,%eax
f0101d47:	0f 85 65 09 00 00    	jne    f01026b2 <mem_init+0xf61>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101d4d:	83 ec 04             	sub    $0x4,%esp
f0101d50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d53:	50                   	push   %eax
f0101d54:	6a 00                	push   $0x0
f0101d56:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101d5c:	e8 ce f7 ff ff       	call   f010152f <page_lookup>
f0101d61:	83 c4 10             	add    $0x10,%esp
f0101d64:	85 c0                	test   %eax,%eax
f0101d66:	0f 85 5f 09 00 00    	jne    f01026cb <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101d6c:	6a 02                	push   $0x2
f0101d6e:	6a 00                	push   $0x0
f0101d70:	57                   	push   %edi
f0101d71:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101d77:	e8 93 f8 ff ff       	call   f010160f <page_insert>
f0101d7c:	83 c4 10             	add    $0x10,%esp
f0101d7f:	85 c0                	test   %eax,%eax
f0101d81:	0f 89 5d 09 00 00    	jns    f01026e4 <mem_init+0xf93>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101d87:	83 ec 0c             	sub    $0xc,%esp
f0101d8a:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101d8d:	e8 b3 f5 ff ff       	call   f0101345 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101d92:	6a 02                	push   $0x2
f0101d94:	6a 00                	push   $0x0
f0101d96:	57                   	push   %edi
f0101d97:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101d9d:	e8 6d f8 ff ff       	call   f010160f <page_insert>
f0101da2:	83 c4 20             	add    $0x20,%esp
f0101da5:	85 c0                	test   %eax,%eax
f0101da7:	0f 85 50 09 00 00    	jne    f01026fd <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101dad:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
	return (pp - pages) << PGSHIFT;
f0101db3:	8b 0d b0 be 57 f0    	mov    0xf057beb0,%ecx
f0101db9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101dbc:	8b 16                	mov    (%esi),%edx
f0101dbe:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101dc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dc7:	29 c8                	sub    %ecx,%eax
f0101dc9:	c1 f8 03             	sar    $0x3,%eax
f0101dcc:	c1 e0 0c             	shl    $0xc,%eax
f0101dcf:	39 c2                	cmp    %eax,%edx
f0101dd1:	0f 85 3f 09 00 00    	jne    f0102716 <mem_init+0xfc5>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101dd7:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ddc:	89 f0                	mov    %esi,%eax
f0101dde:	e8 f9 ef ff ff       	call   f0100ddc <check_va2pa>
f0101de3:	89 fa                	mov    %edi,%edx
f0101de5:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101de8:	c1 fa 03             	sar    $0x3,%edx
f0101deb:	c1 e2 0c             	shl    $0xc,%edx
f0101dee:	39 d0                	cmp    %edx,%eax
f0101df0:	0f 85 39 09 00 00    	jne    f010272f <mem_init+0xfde>
	assert(pp1->pp_ref == 1);
f0101df6:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101dfb:	0f 85 47 09 00 00    	jne    f0102748 <mem_init+0xff7>
	assert(pp0->pp_ref == 1);
f0101e01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e04:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101e09:	0f 85 52 09 00 00    	jne    f0102761 <mem_init+0x1010>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e0f:	6a 02                	push   $0x2
f0101e11:	68 00 10 00 00       	push   $0x1000
f0101e16:	53                   	push   %ebx
f0101e17:	56                   	push   %esi
f0101e18:	e8 f2 f7 ff ff       	call   f010160f <page_insert>
f0101e1d:	83 c4 10             	add    $0x10,%esp
f0101e20:	85 c0                	test   %eax,%eax
f0101e22:	0f 85 52 09 00 00    	jne    f010277a <mem_init+0x1029>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e28:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e2d:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0101e32:	e8 a5 ef ff ff       	call   f0100ddc <check_va2pa>
f0101e37:	89 da                	mov    %ebx,%edx
f0101e39:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
f0101e3f:	c1 fa 03             	sar    $0x3,%edx
f0101e42:	c1 e2 0c             	shl    $0xc,%edx
f0101e45:	39 d0                	cmp    %edx,%eax
f0101e47:	0f 85 46 09 00 00    	jne    f0102793 <mem_init+0x1042>
	assert(pp2->pp_ref == 1);
f0101e4d:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101e52:	0f 85 54 09 00 00    	jne    f01027ac <mem_init+0x105b>

	// should be no free memory
	assert(!page_alloc(0));
f0101e58:	83 ec 0c             	sub    $0xc,%esp
f0101e5b:	6a 00                	push   $0x0
f0101e5d:	e8 71 f4 ff ff       	call   f01012d3 <page_alloc>
f0101e62:	83 c4 10             	add    $0x10,%esp
f0101e65:	85 c0                	test   %eax,%eax
f0101e67:	0f 85 58 09 00 00    	jne    f01027c5 <mem_init+0x1074>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e6d:	6a 02                	push   $0x2
f0101e6f:	68 00 10 00 00       	push   $0x1000
f0101e74:	53                   	push   %ebx
f0101e75:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101e7b:	e8 8f f7 ff ff       	call   f010160f <page_insert>
f0101e80:	83 c4 10             	add    $0x10,%esp
f0101e83:	85 c0                	test   %eax,%eax
f0101e85:	0f 85 53 09 00 00    	jne    f01027de <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e8b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e90:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0101e95:	e8 42 ef ff ff       	call   f0100ddc <check_va2pa>
f0101e9a:	89 da                	mov    %ebx,%edx
f0101e9c:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
f0101ea2:	c1 fa 03             	sar    $0x3,%edx
f0101ea5:	c1 e2 0c             	shl    $0xc,%edx
f0101ea8:	39 d0                	cmp    %edx,%eax
f0101eaa:	0f 85 47 09 00 00    	jne    f01027f7 <mem_init+0x10a6>
	assert(pp2->pp_ref == 1);
f0101eb0:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101eb5:	0f 85 55 09 00 00    	jne    f0102810 <mem_init+0x10bf>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101ebb:	83 ec 0c             	sub    $0xc,%esp
f0101ebe:	6a 00                	push   $0x0
f0101ec0:	e8 0e f4 ff ff       	call   f01012d3 <page_alloc>
f0101ec5:	83 c4 10             	add    $0x10,%esp
f0101ec8:	85 c0                	test   %eax,%eax
f0101eca:	0f 85 59 09 00 00    	jne    f0102829 <mem_init+0x10d8>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101ed0:	8b 15 ac be 57 f0    	mov    0xf057beac,%edx
f0101ed6:	8b 02                	mov    (%edx),%eax
f0101ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101edd:	89 c1                	mov    %eax,%ecx
f0101edf:	c1 e9 0c             	shr    $0xc,%ecx
f0101ee2:	3b 0d a8 be 57 f0    	cmp    0xf057bea8,%ecx
f0101ee8:	0f 83 54 09 00 00    	jae    f0102842 <mem_init+0x10f1>
	return (void *)(pa + KERNBASE);
f0101eee:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101ef6:	83 ec 04             	sub    $0x4,%esp
f0101ef9:	6a 00                	push   $0x0
f0101efb:	68 00 10 00 00       	push   $0x1000
f0101f00:	52                   	push   %edx
f0101f01:	e8 a3 f4 ff ff       	call   f01013a9 <pgdir_walk>
f0101f06:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101f09:	8d 51 04             	lea    0x4(%ecx),%edx
f0101f0c:	83 c4 10             	add    $0x10,%esp
f0101f0f:	39 d0                	cmp    %edx,%eax
f0101f11:	0f 85 40 09 00 00    	jne    f0102857 <mem_init+0x1106>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101f17:	6a 06                	push   $0x6
f0101f19:	68 00 10 00 00       	push   $0x1000
f0101f1e:	53                   	push   %ebx
f0101f1f:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101f25:	e8 e5 f6 ff ff       	call   f010160f <page_insert>
f0101f2a:	83 c4 10             	add    $0x10,%esp
f0101f2d:	85 c0                	test   %eax,%eax
f0101f2f:	0f 85 3b 09 00 00    	jne    f0102870 <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f35:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
f0101f3b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f40:	89 f0                	mov    %esi,%eax
f0101f42:	e8 95 ee ff ff       	call   f0100ddc <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101f47:	89 da                	mov    %ebx,%edx
f0101f49:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
f0101f4f:	c1 fa 03             	sar    $0x3,%edx
f0101f52:	c1 e2 0c             	shl    $0xc,%edx
f0101f55:	39 d0                	cmp    %edx,%eax
f0101f57:	0f 85 2c 09 00 00    	jne    f0102889 <mem_init+0x1138>
	assert(pp2->pp_ref == 1);
f0101f5d:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101f62:	0f 85 3a 09 00 00    	jne    f01028a2 <mem_init+0x1151>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101f68:	83 ec 04             	sub    $0x4,%esp
f0101f6b:	6a 00                	push   $0x0
f0101f6d:	68 00 10 00 00       	push   $0x1000
f0101f72:	56                   	push   %esi
f0101f73:	e8 31 f4 ff ff       	call   f01013a9 <pgdir_walk>
f0101f78:	83 c4 10             	add    $0x10,%esp
f0101f7b:	f6 00 04             	testb  $0x4,(%eax)
f0101f7e:	0f 84 37 09 00 00    	je     f01028bb <mem_init+0x116a>
	assert(kern_pgdir[0] & PTE_U);
f0101f84:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0101f89:	f6 00 04             	testb  $0x4,(%eax)
f0101f8c:	0f 84 42 09 00 00    	je     f01028d4 <mem_init+0x1183>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101f92:	6a 02                	push   $0x2
f0101f94:	68 00 10 00 00       	push   $0x1000
f0101f99:	53                   	push   %ebx
f0101f9a:	50                   	push   %eax
f0101f9b:	e8 6f f6 ff ff       	call   f010160f <page_insert>
f0101fa0:	83 c4 10             	add    $0x10,%esp
f0101fa3:	85 c0                	test   %eax,%eax
f0101fa5:	0f 85 42 09 00 00    	jne    f01028ed <mem_init+0x119c>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101fab:	83 ec 04             	sub    $0x4,%esp
f0101fae:	6a 00                	push   $0x0
f0101fb0:	68 00 10 00 00       	push   $0x1000
f0101fb5:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101fbb:	e8 e9 f3 ff ff       	call   f01013a9 <pgdir_walk>
f0101fc0:	83 c4 10             	add    $0x10,%esp
f0101fc3:	f6 00 02             	testb  $0x2,(%eax)
f0101fc6:	0f 84 3a 09 00 00    	je     f0102906 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101fcc:	83 ec 04             	sub    $0x4,%esp
f0101fcf:	6a 00                	push   $0x0
f0101fd1:	68 00 10 00 00       	push   $0x1000
f0101fd6:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101fdc:	e8 c8 f3 ff ff       	call   f01013a9 <pgdir_walk>
f0101fe1:	83 c4 10             	add    $0x10,%esp
f0101fe4:	f6 00 04             	testb  $0x4,(%eax)
f0101fe7:	0f 85 32 09 00 00    	jne    f010291f <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101fed:	6a 02                	push   $0x2
f0101fef:	68 00 00 40 00       	push   $0x400000
f0101ff4:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101ff7:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101ffd:	e8 0d f6 ff ff       	call   f010160f <page_insert>
f0102002:	83 c4 10             	add    $0x10,%esp
f0102005:	85 c0                	test   %eax,%eax
f0102007:	0f 89 2b 09 00 00    	jns    f0102938 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010200d:	6a 02                	push   $0x2
f010200f:	68 00 10 00 00       	push   $0x1000
f0102014:	57                   	push   %edi
f0102015:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010201b:	e8 ef f5 ff ff       	call   f010160f <page_insert>
f0102020:	83 c4 10             	add    $0x10,%esp
f0102023:	85 c0                	test   %eax,%eax
f0102025:	0f 85 26 09 00 00    	jne    f0102951 <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010202b:	83 ec 04             	sub    $0x4,%esp
f010202e:	6a 00                	push   $0x0
f0102030:	68 00 10 00 00       	push   $0x1000
f0102035:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010203b:	e8 69 f3 ff ff       	call   f01013a9 <pgdir_walk>
f0102040:	83 c4 10             	add    $0x10,%esp
f0102043:	f6 00 04             	testb  $0x4,(%eax)
f0102046:	0f 85 1e 09 00 00    	jne    f010296a <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010204c:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102051:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102054:	ba 00 00 00 00       	mov    $0x0,%edx
f0102059:	e8 7e ed ff ff       	call   f0100ddc <check_va2pa>
f010205e:	89 fe                	mov    %edi,%esi
f0102060:	2b 35 b0 be 57 f0    	sub    0xf057beb0,%esi
f0102066:	c1 fe 03             	sar    $0x3,%esi
f0102069:	c1 e6 0c             	shl    $0xc,%esi
f010206c:	39 f0                	cmp    %esi,%eax
f010206e:	0f 85 0f 09 00 00    	jne    f0102983 <mem_init+0x1232>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102074:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102079:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010207c:	e8 5b ed ff ff       	call   f0100ddc <check_va2pa>
f0102081:	39 c6                	cmp    %eax,%esi
f0102083:	0f 85 13 09 00 00    	jne    f010299c <mem_init+0x124b>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0102089:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f010208e:	0f 85 21 09 00 00    	jne    f01029b5 <mem_init+0x1264>
	assert(pp2->pp_ref == 0);
f0102094:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102099:	0f 85 2f 09 00 00    	jne    f01029ce <mem_init+0x127d>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f010209f:	83 ec 0c             	sub    $0xc,%esp
f01020a2:	6a 00                	push   $0x0
f01020a4:	e8 2a f2 ff ff       	call   f01012d3 <page_alloc>
f01020a9:	83 c4 10             	add    $0x10,%esp
f01020ac:	39 c3                	cmp    %eax,%ebx
f01020ae:	0f 85 33 09 00 00    	jne    f01029e7 <mem_init+0x1296>
f01020b4:	85 c0                	test   %eax,%eax
f01020b6:	0f 84 2b 09 00 00    	je     f01029e7 <mem_init+0x1296>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f01020bc:	83 ec 08             	sub    $0x8,%esp
f01020bf:	6a 00                	push   $0x0
f01020c1:	ff 35 ac be 57 f0    	pushl  0xf057beac
f01020c7:	e8 fd f4 ff ff       	call   f01015c9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01020cc:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
f01020d2:	ba 00 00 00 00       	mov    $0x0,%edx
f01020d7:	89 f0                	mov    %esi,%eax
f01020d9:	e8 fe ec ff ff       	call   f0100ddc <check_va2pa>
f01020de:	83 c4 10             	add    $0x10,%esp
f01020e1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020e4:	0f 85 16 09 00 00    	jne    f0102a00 <mem_init+0x12af>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01020ea:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020ef:	89 f0                	mov    %esi,%eax
f01020f1:	e8 e6 ec ff ff       	call   f0100ddc <check_va2pa>
f01020f6:	89 fa                	mov    %edi,%edx
f01020f8:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
f01020fe:	c1 fa 03             	sar    $0x3,%edx
f0102101:	c1 e2 0c             	shl    $0xc,%edx
f0102104:	39 d0                	cmp    %edx,%eax
f0102106:	0f 85 0d 09 00 00    	jne    f0102a19 <mem_init+0x12c8>
	assert(pp1->pp_ref == 1);
f010210c:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102111:	0f 85 1b 09 00 00    	jne    f0102a32 <mem_init+0x12e1>
	assert(pp2->pp_ref == 0);
f0102117:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010211c:	0f 85 29 09 00 00    	jne    f0102a4b <mem_init+0x12fa>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102122:	6a 00                	push   $0x0
f0102124:	68 00 10 00 00       	push   $0x1000
f0102129:	57                   	push   %edi
f010212a:	56                   	push   %esi
f010212b:	e8 df f4 ff ff       	call   f010160f <page_insert>
f0102130:	83 c4 10             	add    $0x10,%esp
f0102133:	85 c0                	test   %eax,%eax
f0102135:	0f 85 29 09 00 00    	jne    f0102a64 <mem_init+0x1313>
	assert(pp1->pp_ref);
f010213b:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102140:	0f 84 37 09 00 00    	je     f0102a7d <mem_init+0x132c>
	assert(pp1->pp_link == NULL);
f0102146:	83 3f 00             	cmpl   $0x0,(%edi)
f0102149:	0f 85 47 09 00 00    	jne    f0102a96 <mem_init+0x1345>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f010214f:	83 ec 08             	sub    $0x8,%esp
f0102152:	68 00 10 00 00       	push   $0x1000
f0102157:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010215d:	e8 67 f4 ff ff       	call   f01015c9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102162:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
f0102168:	ba 00 00 00 00       	mov    $0x0,%edx
f010216d:	89 f0                	mov    %esi,%eax
f010216f:	e8 68 ec ff ff       	call   f0100ddc <check_va2pa>
f0102174:	83 c4 10             	add    $0x10,%esp
f0102177:	83 f8 ff             	cmp    $0xffffffff,%eax
f010217a:	0f 85 2f 09 00 00    	jne    f0102aaf <mem_init+0x135e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102180:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102185:	89 f0                	mov    %esi,%eax
f0102187:	e8 50 ec ff ff       	call   f0100ddc <check_va2pa>
f010218c:	83 f8 ff             	cmp    $0xffffffff,%eax
f010218f:	0f 85 33 09 00 00    	jne    f0102ac8 <mem_init+0x1377>
	assert(pp1->pp_ref == 0);
f0102195:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010219a:	0f 85 41 09 00 00    	jne    f0102ae1 <mem_init+0x1390>
	assert(pp2->pp_ref == 0);
f01021a0:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01021a5:	0f 85 4f 09 00 00    	jne    f0102afa <mem_init+0x13a9>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f01021ab:	83 ec 0c             	sub    $0xc,%esp
f01021ae:	6a 00                	push   $0x0
f01021b0:	e8 1e f1 ff ff       	call   f01012d3 <page_alloc>
f01021b5:	83 c4 10             	add    $0x10,%esp
f01021b8:	85 c0                	test   %eax,%eax
f01021ba:	0f 84 53 09 00 00    	je     f0102b13 <mem_init+0x13c2>
f01021c0:	39 c7                	cmp    %eax,%edi
f01021c2:	0f 85 4b 09 00 00    	jne    f0102b13 <mem_init+0x13c2>

	// should be no free memory
	assert(!page_alloc(0));
f01021c8:	83 ec 0c             	sub    $0xc,%esp
f01021cb:	6a 00                	push   $0x0
f01021cd:	e8 01 f1 ff ff       	call   f01012d3 <page_alloc>
f01021d2:	83 c4 10             	add    $0x10,%esp
f01021d5:	85 c0                	test   %eax,%eax
f01021d7:	0f 85 4f 09 00 00    	jne    f0102b2c <mem_init+0x13db>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01021dd:	8b 0d ac be 57 f0    	mov    0xf057beac,%ecx
f01021e3:	8b 11                	mov    (%ecx),%edx
f01021e5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01021eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021ee:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01021f4:	c1 f8 03             	sar    $0x3,%eax
f01021f7:	c1 e0 0c             	shl    $0xc,%eax
f01021fa:	39 c2                	cmp    %eax,%edx
f01021fc:	0f 85 43 09 00 00    	jne    f0102b45 <mem_init+0x13f4>
	kern_pgdir[0] = 0;
f0102202:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010220b:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102210:	0f 85 48 09 00 00    	jne    f0102b5e <mem_init+0x140d>
	pp0->pp_ref = 0;
f0102216:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102219:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f010221f:	83 ec 0c             	sub    $0xc,%esp
f0102222:	50                   	push   %eax
f0102223:	e8 1d f1 ff ff       	call   f0101345 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102228:	83 c4 0c             	add    $0xc,%esp
f010222b:	6a 01                	push   $0x1
f010222d:	68 00 10 40 00       	push   $0x401000
f0102232:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0102238:	e8 6c f1 ff ff       	call   f01013a9 <pgdir_walk>
f010223d:	89 c1                	mov    %eax,%ecx
f010223f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102242:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102247:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010224a:	8b 40 04             	mov    0x4(%eax),%eax
f010224d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102252:	8b 35 a8 be 57 f0    	mov    0xf057bea8,%esi
f0102258:	89 c2                	mov    %eax,%edx
f010225a:	c1 ea 0c             	shr    $0xc,%edx
f010225d:	83 c4 10             	add    $0x10,%esp
f0102260:	39 f2                	cmp    %esi,%edx
f0102262:	0f 83 0f 09 00 00    	jae    f0102b77 <mem_init+0x1426>
	assert(ptep == ptep1 + PTX(va));
f0102268:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f010226d:	39 c1                	cmp    %eax,%ecx
f010226f:	0f 85 17 09 00 00    	jne    f0102b8c <mem_init+0x143b>
	kern_pgdir[PDX(va)] = 0;
f0102275:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102278:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f010227f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102282:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0102288:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f010228e:	c1 f8 03             	sar    $0x3,%eax
f0102291:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102294:	89 c2                	mov    %eax,%edx
f0102296:	c1 ea 0c             	shr    $0xc,%edx
f0102299:	39 d6                	cmp    %edx,%esi
f010229b:	0f 86 04 09 00 00    	jbe    f0102ba5 <mem_init+0x1454>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01022a1:	83 ec 04             	sub    $0x4,%esp
f01022a4:	68 00 10 00 00       	push   $0x1000
f01022a9:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01022ae:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01022b3:	50                   	push   %eax
f01022b4:	e8 fa 41 00 00       	call   f01064b3 <memset>
	page_free(pp0);
f01022b9:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01022bc:	89 34 24             	mov    %esi,(%esp)
f01022bf:	e8 81 f0 ff ff       	call   f0101345 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01022c4:	83 c4 0c             	add    $0xc,%esp
f01022c7:	6a 01                	push   $0x1
f01022c9:	6a 00                	push   $0x0
f01022cb:	ff 35 ac be 57 f0    	pushl  0xf057beac
f01022d1:	e8 d3 f0 ff ff       	call   f01013a9 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01022d6:	89 f0                	mov    %esi,%eax
f01022d8:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01022de:	c1 f8 03             	sar    $0x3,%eax
f01022e1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022e4:	89 c2                	mov    %eax,%edx
f01022e6:	c1 ea 0c             	shr    $0xc,%edx
f01022e9:	83 c4 10             	add    $0x10,%esp
f01022ec:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01022f2:	0f 83 bf 08 00 00    	jae    f0102bb7 <mem_init+0x1466>
	return (void *)(pa + KERNBASE);
f01022f8:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f01022fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0102301:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102306:	f6 02 01             	testb  $0x1,(%edx)
f0102309:	0f 85 ba 08 00 00    	jne    f0102bc9 <mem_init+0x1478>
f010230f:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f0102312:	39 c2                	cmp    %eax,%edx
f0102314:	75 f0                	jne    f0102306 <mem_init+0xbb5>
	kern_pgdir[0] = 0;
f0102316:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f010231b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102321:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102324:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f010232a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010232d:	89 0d 40 a2 57 f0    	mov    %ecx,0xf057a240

	// free the pages we took
	page_free(pp0);
f0102333:	83 ec 0c             	sub    $0xc,%esp
f0102336:	50                   	push   %eax
f0102337:	e8 09 f0 ff ff       	call   f0101345 <page_free>
	page_free(pp1);
f010233c:	89 3c 24             	mov    %edi,(%esp)
f010233f:	e8 01 f0 ff ff       	call   f0101345 <page_free>
	page_free(pp2);
f0102344:	89 1c 24             	mov    %ebx,(%esp)
f0102347:	e8 f9 ef ff ff       	call   f0101345 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f010234c:	83 c4 08             	add    $0x8,%esp
f010234f:	68 01 10 00 00       	push   $0x1001
f0102354:	6a 00                	push   $0x0
f0102356:	e8 96 f3 ff ff       	call   f01016f1 <mmio_map_region>
f010235b:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f010235d:	83 c4 08             	add    $0x8,%esp
f0102360:	68 00 10 00 00       	push   $0x1000
f0102365:	6a 00                	push   $0x0
f0102367:	e8 85 f3 ff ff       	call   f01016f1 <mmio_map_region>
f010236c:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010236e:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102374:	83 c4 10             	add    $0x10,%esp
f0102377:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010237d:	0f 86 5f 08 00 00    	jbe    f0102be2 <mem_init+0x1491>
f0102383:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102388:	0f 87 54 08 00 00    	ja     f0102be2 <mem_init+0x1491>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010238e:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102394:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f010239a:	0f 87 5b 08 00 00    	ja     f0102bfb <mem_init+0x14aa>
f01023a0:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01023a6:	0f 86 4f 08 00 00    	jbe    f0102bfb <mem_init+0x14aa>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01023ac:	89 da                	mov    %ebx,%edx
f01023ae:	09 f2                	or     %esi,%edx
f01023b0:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01023b6:	0f 85 58 08 00 00    	jne    f0102c14 <mem_init+0x14c3>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f01023bc:	39 c6                	cmp    %eax,%esi
f01023be:	0f 82 69 08 00 00    	jb     f0102c2d <mem_init+0x14dc>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01023c4:	8b 3d ac be 57 f0    	mov    0xf057beac,%edi
f01023ca:	89 da                	mov    %ebx,%edx
f01023cc:	89 f8                	mov    %edi,%eax
f01023ce:	e8 09 ea ff ff       	call   f0100ddc <check_va2pa>
f01023d3:	85 c0                	test   %eax,%eax
f01023d5:	0f 85 6b 08 00 00    	jne    f0102c46 <mem_init+0x14f5>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01023db:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01023e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01023e4:	89 c2                	mov    %eax,%edx
f01023e6:	89 f8                	mov    %edi,%eax
f01023e8:	e8 ef e9 ff ff       	call   f0100ddc <check_va2pa>
f01023ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01023f2:	0f 85 67 08 00 00    	jne    f0102c5f <mem_init+0x150e>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01023f8:	89 f2                	mov    %esi,%edx
f01023fa:	89 f8                	mov    %edi,%eax
f01023fc:	e8 db e9 ff ff       	call   f0100ddc <check_va2pa>
f0102401:	85 c0                	test   %eax,%eax
f0102403:	0f 85 6f 08 00 00    	jne    f0102c78 <mem_init+0x1527>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102409:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f010240f:	89 f8                	mov    %edi,%eax
f0102411:	e8 c6 e9 ff ff       	call   f0100ddc <check_va2pa>
f0102416:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102419:	0f 85 72 08 00 00    	jne    f0102c91 <mem_init+0x1540>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f010241f:	83 ec 04             	sub    $0x4,%esp
f0102422:	6a 00                	push   $0x0
f0102424:	53                   	push   %ebx
f0102425:	57                   	push   %edi
f0102426:	e8 7e ef ff ff       	call   f01013a9 <pgdir_walk>
f010242b:	83 c4 10             	add    $0x10,%esp
f010242e:	f6 00 1a             	testb  $0x1a,(%eax)
f0102431:	0f 84 73 08 00 00    	je     f0102caa <mem_init+0x1559>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102437:	83 ec 04             	sub    $0x4,%esp
f010243a:	6a 00                	push   $0x0
f010243c:	53                   	push   %ebx
f010243d:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0102443:	e8 61 ef ff ff       	call   f01013a9 <pgdir_walk>
f0102448:	8b 00                	mov    (%eax),%eax
f010244a:	83 c4 10             	add    $0x10,%esp
f010244d:	83 e0 04             	and    $0x4,%eax
f0102450:	89 c7                	mov    %eax,%edi
f0102452:	0f 85 6b 08 00 00    	jne    f0102cc3 <mem_init+0x1572>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102458:	83 ec 04             	sub    $0x4,%esp
f010245b:	6a 00                	push   $0x0
f010245d:	53                   	push   %ebx
f010245e:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0102464:	e8 40 ef ff ff       	call   f01013a9 <pgdir_walk>
f0102469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f010246f:	83 c4 0c             	add    $0xc,%esp
f0102472:	6a 00                	push   $0x0
f0102474:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102477:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010247d:	e8 27 ef ff ff       	call   f01013a9 <pgdir_walk>
f0102482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102488:	83 c4 0c             	add    $0xc,%esp
f010248b:	6a 00                	push   $0x0
f010248d:	56                   	push   %esi
f010248e:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0102494:	e8 10 ef ff ff       	call   f01013a9 <pgdir_walk>
f0102499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f010249f:	c7 04 24 44 8d 10 f0 	movl   $0xf0108d44,(%esp)
f01024a6:	e8 c4 19 00 00       	call   f0103e6f <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01024ab:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
	if ((uint32_t)kva < KERNBASE)
f01024b0:	83 c4 10             	add    $0x10,%esp
f01024b3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01024b8:	0f 86 1e 08 00 00    	jbe    f0102cdc <mem_init+0x158b>
f01024be:	83 ec 08             	sub    $0x8,%esp
f01024c1:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01024c3:	05 00 00 00 10       	add    $0x10000000,%eax
f01024c8:	50                   	push   %eax
f01024c9:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01024ce:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01024d3:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f01024d8:	e8 9e ef ff ff       	call   f010147b <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01024dd:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
	if ((uint32_t)kva < KERNBASE)
f01024e2:	83 c4 10             	add    $0x10,%esp
f01024e5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01024ea:	0f 86 01 08 00 00    	jbe    f0102cf1 <mem_init+0x15a0>
f01024f0:	83 ec 08             	sub    $0x8,%esp
f01024f3:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01024f5:	05 00 00 00 10       	add    $0x10000000,%eax
f01024fa:	50                   	push   %eax
f01024fb:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102500:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102505:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f010250a:	e8 6c ef ff ff       	call   f010147b <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010250f:	83 c4 10             	add    $0x10,%esp
f0102512:	b8 00 e0 11 f0       	mov    $0xf011e000,%eax
f0102517:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010251c:	0f 86 e4 07 00 00    	jbe    f0102d06 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102522:	83 ec 08             	sub    $0x8,%esp
f0102525:	6a 02                	push   $0x2
f0102527:	68 00 e0 11 00       	push   $0x11e000
f010252c:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102531:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102536:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f010253b:	e8 3b ef ff ff       	call   f010147b <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f0102540:	83 c4 08             	add    $0x8,%esp
f0102543:	6a 02                	push   $0x2
f0102545:	6a 00                	push   $0x0
f0102547:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010254c:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102551:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102556:	e8 20 ef ff ff       	call   f010147b <boot_map_region>
f010255b:	c7 45 d0 00 d0 57 f0 	movl   $0xf057d000,-0x30(%ebp)
f0102562:	83 c4 10             	add    $0x10,%esp
f0102565:	bb 00 d0 57 f0       	mov    $0xf057d000,%ebx
f010256a:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f010256f:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102575:	0f 86 a0 07 00 00    	jbe    f0102d1b <mem_init+0x15ca>
		boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f010257b:	83 ec 08             	sub    $0x8,%esp
f010257e:	6a 02                	push   $0x2
f0102580:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102586:	50                   	push   %eax
f0102587:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010258c:	89 f2                	mov    %esi,%edx
f010258e:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102593:	e8 e3 ee ff ff       	call   f010147b <boot_map_region>
f0102598:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010259e:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f01025a4:	83 c4 10             	add    $0x10,%esp
f01025a7:	81 fb 00 d0 5b f0    	cmp    $0xf05bd000,%ebx
f01025ad:	75 c0                	jne    f010256f <mem_init+0xe1e>
	pgdir = kern_pgdir;
f01025af:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f01025b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01025b7:	a1 a8 be 57 f0       	mov    0xf057bea8,%eax
f01025bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01025bf:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01025c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025ce:	8b 35 b0 be 57 f0    	mov    0xf057beb0,%esi
f01025d4:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01025d7:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01025dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01025e0:	89 fb                	mov    %edi,%ebx
f01025e2:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f01025e5:	0f 86 73 07 00 00    	jbe    f0102d5e <mem_init+0x160d>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025eb:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01025f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01025f4:	e8 e3 e7 ff ff       	call   f0100ddc <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01025f9:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0102600:	0f 86 2a 07 00 00    	jbe    f0102d30 <mem_init+0x15df>
f0102606:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102609:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f010260c:	39 d0                	cmp    %edx,%eax
f010260e:	0f 85 31 07 00 00    	jne    f0102d45 <mem_init+0x15f4>
	for (i = 0; i < n; i += PGSIZE)
f0102614:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010261a:	eb c6                	jmp    f01025e2 <mem_init+0xe91>
	assert(nfree == 0);
f010261c:	68 5b 8c 10 f0       	push   $0xf0108c5b
f0102621:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102626:	68 57 03 00 00       	push   $0x357
f010262b:	68 45 8a 10 f0       	push   $0xf0108a45
f0102630:	e8 14 da ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0102635:	68 69 8b 10 f0       	push   $0xf0108b69
f010263a:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010263f:	68 ca 03 00 00       	push   $0x3ca
f0102644:	68 45 8a 10 f0       	push   $0xf0108a45
f0102649:	e8 fb d9 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010264e:	68 7f 8b 10 f0       	push   $0xf0108b7f
f0102653:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102658:	68 cb 03 00 00       	push   $0x3cb
f010265d:	68 45 8a 10 f0       	push   $0xf0108a45
f0102662:	e8 e2 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0102667:	68 95 8b 10 f0       	push   $0xf0108b95
f010266c:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102671:	68 cc 03 00 00       	push   $0x3cc
f0102676:	68 45 8a 10 f0       	push   $0xf0108a45
f010267b:	e8 c9 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0102680:	68 ab 8b 10 f0       	push   $0xf0108bab
f0102685:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010268a:	68 cf 03 00 00       	push   $0x3cf
f010268f:	68 45 8a 10 f0       	push   $0xf0108a45
f0102694:	e8 b0 d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102699:	68 ec 81 10 f0       	push   $0xf01081ec
f010269e:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01026a3:	68 d0 03 00 00       	push   $0x3d0
f01026a8:	68 45 8a 10 f0       	push   $0xf0108a45
f01026ad:	e8 97 d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01026b2:	68 14 8c 10 f0       	push   $0xf0108c14
f01026b7:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01026bc:	68 d7 03 00 00       	push   $0x3d7
f01026c1:	68 45 8a 10 f0       	push   $0xf0108a45
f01026c6:	e8 7e d9 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01026cb:	68 2c 82 10 f0       	push   $0xf010822c
f01026d0:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01026d5:	68 da 03 00 00       	push   $0x3da
f01026da:	68 45 8a 10 f0       	push   $0xf0108a45
f01026df:	e8 65 d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01026e4:	68 64 82 10 f0       	push   $0xf0108264
f01026e9:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01026ee:	68 dd 03 00 00       	push   $0x3dd
f01026f3:	68 45 8a 10 f0       	push   $0xf0108a45
f01026f8:	e8 4c d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01026fd:	68 94 82 10 f0       	push   $0xf0108294
f0102702:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102707:	68 e1 03 00 00       	push   $0x3e1
f010270c:	68 45 8a 10 f0       	push   $0xf0108a45
f0102711:	e8 33 d9 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102716:	68 c4 82 10 f0       	push   $0xf01082c4
f010271b:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102720:	68 e2 03 00 00       	push   $0x3e2
f0102725:	68 45 8a 10 f0       	push   $0xf0108a45
f010272a:	e8 1a d9 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010272f:	68 ec 82 10 f0       	push   $0xf01082ec
f0102734:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102739:	68 e3 03 00 00       	push   $0x3e3
f010273e:	68 45 8a 10 f0       	push   $0xf0108a45
f0102743:	e8 01 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102748:	68 66 8c 10 f0       	push   $0xf0108c66
f010274d:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102752:	68 e4 03 00 00       	push   $0x3e4
f0102757:	68 45 8a 10 f0       	push   $0xf0108a45
f010275c:	e8 e8 d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102761:	68 77 8c 10 f0       	push   $0xf0108c77
f0102766:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010276b:	68 e5 03 00 00       	push   $0x3e5
f0102770:	68 45 8a 10 f0       	push   $0xf0108a45
f0102775:	e8 cf d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010277a:	68 1c 83 10 f0       	push   $0xf010831c
f010277f:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102784:	68 e8 03 00 00       	push   $0x3e8
f0102789:	68 45 8a 10 f0       	push   $0xf0108a45
f010278e:	e8 b6 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102793:	68 58 83 10 f0       	push   $0xf0108358
f0102798:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010279d:	68 e9 03 00 00       	push   $0x3e9
f01027a2:	68 45 8a 10 f0       	push   $0xf0108a45
f01027a7:	e8 9d d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01027ac:	68 88 8c 10 f0       	push   $0xf0108c88
f01027b1:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01027b6:	68 ea 03 00 00       	push   $0x3ea
f01027bb:	68 45 8a 10 f0       	push   $0xf0108a45
f01027c0:	e8 84 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01027c5:	68 14 8c 10 f0       	push   $0xf0108c14
f01027ca:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01027cf:	68 ed 03 00 00       	push   $0x3ed
f01027d4:	68 45 8a 10 f0       	push   $0xf0108a45
f01027d9:	e8 6b d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027de:	68 1c 83 10 f0       	push   $0xf010831c
f01027e3:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01027e8:	68 f0 03 00 00       	push   $0x3f0
f01027ed:	68 45 8a 10 f0       	push   $0xf0108a45
f01027f2:	e8 52 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027f7:	68 58 83 10 f0       	push   $0xf0108358
f01027fc:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102801:	68 f1 03 00 00       	push   $0x3f1
f0102806:	68 45 8a 10 f0       	push   $0xf0108a45
f010280b:	e8 39 d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102810:	68 88 8c 10 f0       	push   $0xf0108c88
f0102815:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010281a:	68 f2 03 00 00       	push   $0x3f2
f010281f:	68 45 8a 10 f0       	push   $0xf0108a45
f0102824:	e8 20 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102829:	68 14 8c 10 f0       	push   $0xf0108c14
f010282e:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102833:	68 f6 03 00 00       	push   $0x3f6
f0102838:	68 45 8a 10 f0       	push   $0xf0108a45
f010283d:	e8 07 d8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102842:	50                   	push   %eax
f0102843:	68 b4 78 10 f0       	push   $0xf01078b4
f0102848:	68 f9 03 00 00       	push   $0x3f9
f010284d:	68 45 8a 10 f0       	push   $0xf0108a45
f0102852:	e8 f2 d7 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102857:	68 88 83 10 f0       	push   $0xf0108388
f010285c:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102861:	68 fa 03 00 00       	push   $0x3fa
f0102866:	68 45 8a 10 f0       	push   $0xf0108a45
f010286b:	e8 d9 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102870:	68 c8 83 10 f0       	push   $0xf01083c8
f0102875:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010287a:	68 fd 03 00 00       	push   $0x3fd
f010287f:	68 45 8a 10 f0       	push   $0xf0108a45
f0102884:	e8 c0 d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102889:	68 58 83 10 f0       	push   $0xf0108358
f010288e:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102893:	68 fe 03 00 00       	push   $0x3fe
f0102898:	68 45 8a 10 f0       	push   $0xf0108a45
f010289d:	e8 a7 d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01028a2:	68 88 8c 10 f0       	push   $0xf0108c88
f01028a7:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01028ac:	68 ff 03 00 00       	push   $0x3ff
f01028b1:	68 45 8a 10 f0       	push   $0xf0108a45
f01028b6:	e8 8e d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01028bb:	68 08 84 10 f0       	push   $0xf0108408
f01028c0:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01028c5:	68 00 04 00 00       	push   $0x400
f01028ca:	68 45 8a 10 f0       	push   $0xf0108a45
f01028cf:	e8 75 d7 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01028d4:	68 99 8c 10 f0       	push   $0xf0108c99
f01028d9:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01028de:	68 01 04 00 00       	push   $0x401
f01028e3:	68 45 8a 10 f0       	push   $0xf0108a45
f01028e8:	e8 5c d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01028ed:	68 1c 83 10 f0       	push   $0xf010831c
f01028f2:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01028f7:	68 04 04 00 00       	push   $0x404
f01028fc:	68 45 8a 10 f0       	push   $0xf0108a45
f0102901:	e8 43 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102906:	68 3c 84 10 f0       	push   $0xf010843c
f010290b:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102910:	68 05 04 00 00       	push   $0x405
f0102915:	68 45 8a 10 f0       	push   $0xf0108a45
f010291a:	e8 2a d7 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010291f:	68 70 84 10 f0       	push   $0xf0108470
f0102924:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102929:	68 06 04 00 00       	push   $0x406
f010292e:	68 45 8a 10 f0       	push   $0xf0108a45
f0102933:	e8 11 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102938:	68 a8 84 10 f0       	push   $0xf01084a8
f010293d:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102942:	68 09 04 00 00       	push   $0x409
f0102947:	68 45 8a 10 f0       	push   $0xf0108a45
f010294c:	e8 f8 d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102951:	68 e0 84 10 f0       	push   $0xf01084e0
f0102956:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010295b:	68 0c 04 00 00       	push   $0x40c
f0102960:	68 45 8a 10 f0       	push   $0xf0108a45
f0102965:	e8 df d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010296a:	68 70 84 10 f0       	push   $0xf0108470
f010296f:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102974:	68 0d 04 00 00       	push   $0x40d
f0102979:	68 45 8a 10 f0       	push   $0xf0108a45
f010297e:	e8 c6 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102983:	68 1c 85 10 f0       	push   $0xf010851c
f0102988:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010298d:	68 10 04 00 00       	push   $0x410
f0102992:	68 45 8a 10 f0       	push   $0xf0108a45
f0102997:	e8 ad d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010299c:	68 48 85 10 f0       	push   $0xf0108548
f01029a1:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01029a6:	68 11 04 00 00       	push   $0x411
f01029ab:	68 45 8a 10 f0       	push   $0xf0108a45
f01029b0:	e8 94 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f01029b5:	68 af 8c 10 f0       	push   $0xf0108caf
f01029ba:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01029bf:	68 13 04 00 00       	push   $0x413
f01029c4:	68 45 8a 10 f0       	push   $0xf0108a45
f01029c9:	e8 7b d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01029ce:	68 c0 8c 10 f0       	push   $0xf0108cc0
f01029d3:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01029d8:	68 14 04 00 00       	push   $0x414
f01029dd:	68 45 8a 10 f0       	push   $0xf0108a45
f01029e2:	e8 62 d6 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01029e7:	68 78 85 10 f0       	push   $0xf0108578
f01029ec:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01029f1:	68 17 04 00 00       	push   $0x417
f01029f6:	68 45 8a 10 f0       	push   $0xf0108a45
f01029fb:	e8 49 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a00:	68 9c 85 10 f0       	push   $0xf010859c
f0102a05:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102a0a:	68 1b 04 00 00       	push   $0x41b
f0102a0f:	68 45 8a 10 f0       	push   $0xf0108a45
f0102a14:	e8 30 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a19:	68 48 85 10 f0       	push   $0xf0108548
f0102a1e:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102a23:	68 1c 04 00 00       	push   $0x41c
f0102a28:	68 45 8a 10 f0       	push   $0xf0108a45
f0102a2d:	e8 17 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102a32:	68 66 8c 10 f0       	push   $0xf0108c66
f0102a37:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102a3c:	68 1d 04 00 00       	push   $0x41d
f0102a41:	68 45 8a 10 f0       	push   $0xf0108a45
f0102a46:	e8 fe d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a4b:	68 c0 8c 10 f0       	push   $0xf0108cc0
f0102a50:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102a55:	68 1e 04 00 00       	push   $0x41e
f0102a5a:	68 45 8a 10 f0       	push   $0xf0108a45
f0102a5f:	e8 e5 d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102a64:	68 c0 85 10 f0       	push   $0xf01085c0
f0102a69:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102a6e:	68 21 04 00 00       	push   $0x421
f0102a73:	68 45 8a 10 f0       	push   $0xf0108a45
f0102a78:	e8 cc d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102a7d:	68 d1 8c 10 f0       	push   $0xf0108cd1
f0102a82:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102a87:	68 22 04 00 00       	push   $0x422
f0102a8c:	68 45 8a 10 f0       	push   $0xf0108a45
f0102a91:	e8 b3 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102a96:	68 dd 8c 10 f0       	push   $0xf0108cdd
f0102a9b:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102aa0:	68 23 04 00 00       	push   $0x423
f0102aa5:	68 45 8a 10 f0       	push   $0xf0108a45
f0102aaa:	e8 9a d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102aaf:	68 9c 85 10 f0       	push   $0xf010859c
f0102ab4:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102ab9:	68 27 04 00 00       	push   $0x427
f0102abe:	68 45 8a 10 f0       	push   $0xf0108a45
f0102ac3:	e8 81 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102ac8:	68 f8 85 10 f0       	push   $0xf01085f8
f0102acd:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102ad2:	68 28 04 00 00       	push   $0x428
f0102ad7:	68 45 8a 10 f0       	push   $0xf0108a45
f0102adc:	e8 68 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102ae1:	68 f2 8c 10 f0       	push   $0xf0108cf2
f0102ae6:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102aeb:	68 29 04 00 00       	push   $0x429
f0102af0:	68 45 8a 10 f0       	push   $0xf0108a45
f0102af5:	e8 4f d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102afa:	68 c0 8c 10 f0       	push   $0xf0108cc0
f0102aff:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102b04:	68 2a 04 00 00       	push   $0x42a
f0102b09:	68 45 8a 10 f0       	push   $0xf0108a45
f0102b0e:	e8 36 d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b13:	68 20 86 10 f0       	push   $0xf0108620
f0102b18:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102b1d:	68 2d 04 00 00       	push   $0x42d
f0102b22:	68 45 8a 10 f0       	push   $0xf0108a45
f0102b27:	e8 1d d5 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102b2c:	68 14 8c 10 f0       	push   $0xf0108c14
f0102b31:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102b36:	68 30 04 00 00       	push   $0x430
f0102b3b:	68 45 8a 10 f0       	push   $0xf0108a45
f0102b40:	e8 04 d5 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b45:	68 c4 82 10 f0       	push   $0xf01082c4
f0102b4a:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102b4f:	68 33 04 00 00       	push   $0x433
f0102b54:	68 45 8a 10 f0       	push   $0xf0108a45
f0102b59:	e8 eb d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102b5e:	68 77 8c 10 f0       	push   $0xf0108c77
f0102b63:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102b68:	68 35 04 00 00       	push   $0x435
f0102b6d:	68 45 8a 10 f0       	push   $0xf0108a45
f0102b72:	e8 d2 d4 ff ff       	call   f0100049 <_panic>
f0102b77:	50                   	push   %eax
f0102b78:	68 b4 78 10 f0       	push   $0xf01078b4
f0102b7d:	68 3c 04 00 00       	push   $0x43c
f0102b82:	68 45 8a 10 f0       	push   $0xf0108a45
f0102b87:	e8 bd d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102b8c:	68 03 8d 10 f0       	push   $0xf0108d03
f0102b91:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102b96:	68 3d 04 00 00       	push   $0x43d
f0102b9b:	68 45 8a 10 f0       	push   $0xf0108a45
f0102ba0:	e8 a4 d4 ff ff       	call   f0100049 <_panic>
f0102ba5:	50                   	push   %eax
f0102ba6:	68 b4 78 10 f0       	push   $0xf01078b4
f0102bab:	6a 58                	push   $0x58
f0102bad:	68 51 8a 10 f0       	push   $0xf0108a51
f0102bb2:	e8 92 d4 ff ff       	call   f0100049 <_panic>
f0102bb7:	50                   	push   %eax
f0102bb8:	68 b4 78 10 f0       	push   $0xf01078b4
f0102bbd:	6a 58                	push   $0x58
f0102bbf:	68 51 8a 10 f0       	push   $0xf0108a51
f0102bc4:	e8 80 d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102bc9:	68 1b 8d 10 f0       	push   $0xf0108d1b
f0102bce:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102bd3:	68 47 04 00 00       	push   $0x447
f0102bd8:	68 45 8a 10 f0       	push   $0xf0108a45
f0102bdd:	e8 67 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102be2:	68 44 86 10 f0       	push   $0xf0108644
f0102be7:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102bec:	68 57 04 00 00       	push   $0x457
f0102bf1:	68 45 8a 10 f0       	push   $0xf0108a45
f0102bf6:	e8 4e d4 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102bfb:	68 6c 86 10 f0       	push   $0xf010866c
f0102c00:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102c05:	68 58 04 00 00       	push   $0x458
f0102c0a:	68 45 8a 10 f0       	push   $0xf0108a45
f0102c0f:	e8 35 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c14:	68 94 86 10 f0       	push   $0xf0108694
f0102c19:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102c1e:	68 5a 04 00 00       	push   $0x45a
f0102c23:	68 45 8a 10 f0       	push   $0xf0108a45
f0102c28:	e8 1c d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102c2d:	68 32 8d 10 f0       	push   $0xf0108d32
f0102c32:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102c37:	68 5c 04 00 00       	push   $0x45c
f0102c3c:	68 45 8a 10 f0       	push   $0xf0108a45
f0102c41:	e8 03 d4 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c46:	68 bc 86 10 f0       	push   $0xf01086bc
f0102c4b:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102c50:	68 5e 04 00 00       	push   $0x45e
f0102c55:	68 45 8a 10 f0       	push   $0xf0108a45
f0102c5a:	e8 ea d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c5f:	68 e0 86 10 f0       	push   $0xf01086e0
f0102c64:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102c69:	68 5f 04 00 00       	push   $0x45f
f0102c6e:	68 45 8a 10 f0       	push   $0xf0108a45
f0102c73:	e8 d1 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c78:	68 10 87 10 f0       	push   $0xf0108710
f0102c7d:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102c82:	68 60 04 00 00       	push   $0x460
f0102c87:	68 45 8a 10 f0       	push   $0xf0108a45
f0102c8c:	e8 b8 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102c91:	68 34 87 10 f0       	push   $0xf0108734
f0102c96:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102c9b:	68 61 04 00 00       	push   $0x461
f0102ca0:	68 45 8a 10 f0       	push   $0xf0108a45
f0102ca5:	e8 9f d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102caa:	68 60 87 10 f0       	push   $0xf0108760
f0102caf:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102cb4:	68 63 04 00 00       	push   $0x463
f0102cb9:	68 45 8a 10 f0       	push   $0xf0108a45
f0102cbe:	e8 86 d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102cc3:	68 a4 87 10 f0       	push   $0xf01087a4
f0102cc8:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102ccd:	68 64 04 00 00       	push   $0x464
f0102cd2:	68 45 8a 10 f0       	push   $0xf0108a45
f0102cd7:	e8 6d d3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102cdc:	50                   	push   %eax
f0102cdd:	68 d8 78 10 f0       	push   $0xf01078d8
f0102ce2:	68 be 00 00 00       	push   $0xbe
f0102ce7:	68 45 8a 10 f0       	push   $0xf0108a45
f0102cec:	e8 58 d3 ff ff       	call   f0100049 <_panic>
f0102cf1:	50                   	push   %eax
f0102cf2:	68 d8 78 10 f0       	push   $0xf01078d8
f0102cf7:	68 c6 00 00 00       	push   $0xc6
f0102cfc:	68 45 8a 10 f0       	push   $0xf0108a45
f0102d01:	e8 43 d3 ff ff       	call   f0100049 <_panic>
f0102d06:	50                   	push   %eax
f0102d07:	68 d8 78 10 f0       	push   $0xf01078d8
f0102d0c:	68 d2 00 00 00       	push   $0xd2
f0102d11:	68 45 8a 10 f0       	push   $0xf0108a45
f0102d16:	e8 2e d3 ff ff       	call   f0100049 <_panic>
f0102d1b:	53                   	push   %ebx
f0102d1c:	68 d8 78 10 f0       	push   $0xf01078d8
f0102d21:	68 17 01 00 00       	push   $0x117
f0102d26:	68 45 8a 10 f0       	push   $0xf0108a45
f0102d2b:	e8 19 d3 ff ff       	call   f0100049 <_panic>
f0102d30:	56                   	push   %esi
f0102d31:	68 d8 78 10 f0       	push   $0xf01078d8
f0102d36:	68 6e 03 00 00       	push   $0x36e
f0102d3b:	68 45 8a 10 f0       	push   $0xf0108a45
f0102d40:	e8 04 d3 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d45:	68 d8 87 10 f0       	push   $0xf01087d8
f0102d4a:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102d4f:	68 6e 03 00 00       	push   $0x36e
f0102d54:	68 45 8a 10 f0       	push   $0xf0108a45
f0102d59:	e8 eb d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102d5e:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
f0102d63:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102d66:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102d69:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102d6e:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102d74:	89 da                	mov    %ebx,%edx
f0102d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d79:	e8 5e e0 ff ff       	call   f0100ddc <check_va2pa>
f0102d7e:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102d85:	76 45                	jbe    f0102dcc <mem_init+0x167b>
f0102d87:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102d8a:	39 d0                	cmp    %edx,%eax
f0102d8c:	75 55                	jne    f0102de3 <mem_init+0x1692>
f0102d8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102d94:	81 fb 00 00 c2 ee    	cmp    $0xeec20000,%ebx
f0102d9a:	75 d8                	jne    f0102d74 <mem_init+0x1623>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102d9c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102d9f:	8b 81 00 0f 00 00    	mov    0xf00(%ecx),%eax
f0102da5:	89 c2                	mov    %eax,%edx
f0102da7:	81 e2 81 00 00 00    	and    $0x81,%edx
f0102dad:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f0102db3:	0f 85 75 01 00 00    	jne    f0102f2e <mem_init+0x17dd>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f0102db9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102dbe:	0f 85 6a 01 00 00    	jne    f0102f2e <mem_init+0x17dd>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102dc4:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102dc7:	c1 e6 0c             	shl    $0xc,%esi
f0102dca:	eb 3f                	jmp    f0102e0b <mem_init+0x16ba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102dcc:	ff 75 c8             	pushl  -0x38(%ebp)
f0102dcf:	68 d8 78 10 f0       	push   $0xf01078d8
f0102dd4:	68 73 03 00 00       	push   $0x373
f0102dd9:	68 45 8a 10 f0       	push   $0xf0108a45
f0102dde:	e8 66 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102de3:	68 0c 88 10 f0       	push   $0xf010880c
f0102de8:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102ded:	68 73 03 00 00       	push   $0x373
f0102df2:	68 45 8a 10 f0       	push   $0xf0108a45
f0102df7:	e8 4d d2 ff ff       	call   f0100049 <_panic>
	return PTE_ADDR(*pgdir);
f0102dfc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e02:	39 d0                	cmp    %edx,%eax
f0102e04:	75 25                	jne    f0102e2b <mem_init+0x16da>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102e06:	05 00 00 40 00       	add    $0x400000,%eax
f0102e0b:	39 f0                	cmp    %esi,%eax
f0102e0d:	73 35                	jae    f0102e44 <mem_init+0x16f3>
	pgdir = &pgdir[PDX(va)];
f0102e0f:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102e15:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102e18:	8b 14 91             	mov    (%ecx,%edx,4),%edx
f0102e1b:	89 d3                	mov    %edx,%ebx
f0102e1d:	81 e3 81 00 00 00    	and    $0x81,%ebx
f0102e23:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
f0102e29:	74 d1                	je     f0102dfc <mem_init+0x16ab>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e2b:	68 40 88 10 f0       	push   $0xf0108840
f0102e30:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102e35:	68 78 03 00 00       	push   $0x378
f0102e3a:	68 45 8a 10 f0       	push   $0xf0108a45
f0102e3f:	e8 05 d2 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102e44:	83 ec 0c             	sub    $0xc,%esp
f0102e47:	68 5d 8d 10 f0       	push   $0xf0108d5d
f0102e4c:	e8 1e 10 00 00       	call   f0103e6f <cprintf>
f0102e51:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e54:	b8 00 d0 57 f0       	mov    $0xf057d000,%eax
f0102e59:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102e5e:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102e61:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e63:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102e66:	89 f3                	mov    %esi,%ebx
f0102e68:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e6b:	05 00 80 00 20       	add    $0x20008000,%eax
f0102e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102e73:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102e79:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e7c:	89 da                	mov    %ebx,%edx
f0102e7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e81:	e8 56 df ff ff       	call   f0100ddc <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102e86:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102e8c:	0f 86 a6 00 00 00    	jbe    f0102f38 <mem_init+0x17e7>
f0102e92:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102e95:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102e98:	39 d0                	cmp    %edx,%eax
f0102e9a:	0f 85 af 00 00 00    	jne    f0102f4f <mem_init+0x17fe>
f0102ea0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102ea6:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0102ea9:	75 d1                	jne    f0102e7c <mem_init+0x172b>
f0102eab:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102eb1:	89 da                	mov    %ebx,%edx
f0102eb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102eb6:	e8 21 df ff ff       	call   f0100ddc <check_va2pa>
f0102ebb:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102ebe:	0f 85 a4 00 00 00    	jne    f0102f68 <mem_init+0x1817>
f0102ec4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102eca:	39 f3                	cmp    %esi,%ebx
f0102ecc:	75 e3                	jne    f0102eb1 <mem_init+0x1760>
f0102ece:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102ed4:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102edb:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f0102ee1:	81 ff 00 d0 5b f0    	cmp    $0xf05bd000,%edi
f0102ee7:	0f 85 76 ff ff ff    	jne    f0102e63 <mem_init+0x1712>
f0102eed:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0102ef0:	e9 c7 00 00 00       	jmp    f0102fbc <mem_init+0x186b>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ef5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102efb:	39 f3                	cmp    %esi,%ebx
f0102efd:	0f 83 51 ff ff ff    	jae    f0102e54 <mem_init+0x1703>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102f03:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102f09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f0c:	e8 cb de ff ff       	call   f0100ddc <check_va2pa>
f0102f11:	39 c3                	cmp    %eax,%ebx
f0102f13:	74 e0                	je     f0102ef5 <mem_init+0x17a4>
f0102f15:	68 6c 88 10 f0       	push   $0xf010886c
f0102f1a:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102f1f:	68 7d 03 00 00       	push   $0x37d
f0102f24:	68 45 8a 10 f0       	push   $0xf0108a45
f0102f29:	e8 1b d1 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f2e:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f31:	c1 e6 0c             	shl    $0xc,%esi
f0102f34:	89 fb                	mov    %edi,%ebx
f0102f36:	eb c3                	jmp    f0102efb <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f38:	ff 75 c0             	pushl  -0x40(%ebp)
f0102f3b:	68 d8 78 10 f0       	push   $0xf01078d8
f0102f40:	68 85 03 00 00       	push   $0x385
f0102f45:	68 45 8a 10 f0       	push   $0xf0108a45
f0102f4a:	e8 fa d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102f4f:	68 94 88 10 f0       	push   $0xf0108894
f0102f54:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102f59:	68 85 03 00 00       	push   $0x385
f0102f5e:	68 45 8a 10 f0       	push   $0xf0108a45
f0102f63:	e8 e1 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f68:	68 dc 88 10 f0       	push   $0xf01088dc
f0102f6d:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102f72:	68 87 03 00 00       	push   $0x387
f0102f77:	68 45 8a 10 f0       	push   $0xf0108a45
f0102f7c:	e8 c8 d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0102f81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f84:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102f88:	75 4e                	jne    f0102fd8 <mem_init+0x1887>
f0102f8a:	68 74 8d 10 f0       	push   $0xf0108d74
f0102f8f:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102f94:	68 92 03 00 00       	push   $0x392
f0102f99:	68 45 8a 10 f0       	push   $0xf0108a45
f0102f9e:	e8 a6 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_P);
f0102fa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fa6:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102fa9:	a8 01                	test   $0x1,%al
f0102fab:	74 30                	je     f0102fdd <mem_init+0x188c>
				assert(pgdir[i] & PTE_W);
f0102fad:	a8 02                	test   $0x2,%al
f0102faf:	74 45                	je     f0102ff6 <mem_init+0x18a5>
	for (i = 0; i < NPDENTRIES; i++) {
f0102fb1:	83 c7 01             	add    $0x1,%edi
f0102fb4:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102fba:	74 6c                	je     f0103028 <mem_init+0x18d7>
		switch (i) {
f0102fbc:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102fc2:	83 f8 04             	cmp    $0x4,%eax
f0102fc5:	76 ba                	jbe    f0102f81 <mem_init+0x1830>
			if (i >= PDX(KERNBASE)) {
f0102fc7:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102fcd:	77 d4                	ja     f0102fa3 <mem_init+0x1852>
				assert(pgdir[i] == 0);
f0102fcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fd2:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102fd6:	75 37                	jne    f010300f <mem_init+0x18be>
	for (i = 0; i < NPDENTRIES; i++) {
f0102fd8:	83 c7 01             	add    $0x1,%edi
f0102fdb:	eb df                	jmp    f0102fbc <mem_init+0x186b>
				assert(pgdir[i] & PTE_P);
f0102fdd:	68 74 8d 10 f0       	push   $0xf0108d74
f0102fe2:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0102fe7:	68 96 03 00 00       	push   $0x396
f0102fec:	68 45 8a 10 f0       	push   $0xf0108a45
f0102ff1:	e8 53 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0102ff6:	68 85 8d 10 f0       	push   $0xf0108d85
f0102ffb:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0103000:	68 97 03 00 00       	push   $0x397
f0103005:	68 45 8a 10 f0       	push   $0xf0108a45
f010300a:	e8 3a d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f010300f:	68 96 8d 10 f0       	push   $0xf0108d96
f0103014:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0103019:	68 99 03 00 00       	push   $0x399
f010301e:	68 45 8a 10 f0       	push   $0xf0108a45
f0103023:	e8 21 d0 ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103028:	83 ec 0c             	sub    $0xc,%esp
f010302b:	68 00 89 10 f0       	push   $0xf0108900
f0103030:	e8 3a 0e 00 00       	call   f0103e6f <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f0103035:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f0103038:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f010303b:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f010303e:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f0103043:	83 c4 10             	add    $0x10,%esp
f0103046:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010304b:	0f 86 fb 01 00 00    	jbe    f010324c <mem_init+0x1afb>
	return (physaddr_t)kva - KERNBASE;
f0103051:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103056:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0103059:	b8 00 00 00 00       	mov    $0x0,%eax
f010305e:	e8 83 de ff ff       	call   f0100ee6 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0103063:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103066:	83 e0 f3             	and    $0xfffffff3,%eax
f0103069:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f010306e:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103071:	83 ec 0c             	sub    $0xc,%esp
f0103074:	6a 00                	push   $0x0
f0103076:	e8 58 e2 ff ff       	call   f01012d3 <page_alloc>
f010307b:	89 c6                	mov    %eax,%esi
f010307d:	83 c4 10             	add    $0x10,%esp
f0103080:	85 c0                	test   %eax,%eax
f0103082:	0f 84 d9 01 00 00    	je     f0103261 <mem_init+0x1b10>
	assert((pp1 = page_alloc(0)));
f0103088:	83 ec 0c             	sub    $0xc,%esp
f010308b:	6a 00                	push   $0x0
f010308d:	e8 41 e2 ff ff       	call   f01012d3 <page_alloc>
f0103092:	89 c7                	mov    %eax,%edi
f0103094:	83 c4 10             	add    $0x10,%esp
f0103097:	85 c0                	test   %eax,%eax
f0103099:	0f 84 db 01 00 00    	je     f010327a <mem_init+0x1b29>
	assert((pp2 = page_alloc(0)));
f010309f:	83 ec 0c             	sub    $0xc,%esp
f01030a2:	6a 00                	push   $0x0
f01030a4:	e8 2a e2 ff ff       	call   f01012d3 <page_alloc>
f01030a9:	89 c3                	mov    %eax,%ebx
f01030ab:	83 c4 10             	add    $0x10,%esp
f01030ae:	85 c0                	test   %eax,%eax
f01030b0:	0f 84 dd 01 00 00    	je     f0103293 <mem_init+0x1b42>
	page_free(pp0);
f01030b6:	83 ec 0c             	sub    $0xc,%esp
f01030b9:	56                   	push   %esi
f01030ba:	e8 86 e2 ff ff       	call   f0101345 <page_free>
	return (pp - pages) << PGSHIFT;
f01030bf:	89 f8                	mov    %edi,%eax
f01030c1:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01030c7:	c1 f8 03             	sar    $0x3,%eax
f01030ca:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030cd:	89 c2                	mov    %eax,%edx
f01030cf:	c1 ea 0c             	shr    $0xc,%edx
f01030d2:	83 c4 10             	add    $0x10,%esp
f01030d5:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01030db:	0f 83 cb 01 00 00    	jae    f01032ac <mem_init+0x1b5b>
	memset(page2kva(pp1), 1, PGSIZE);
f01030e1:	83 ec 04             	sub    $0x4,%esp
f01030e4:	68 00 10 00 00       	push   $0x1000
f01030e9:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01030eb:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01030f0:	50                   	push   %eax
f01030f1:	e8 bd 33 00 00       	call   f01064b3 <memset>
	return (pp - pages) << PGSHIFT;
f01030f6:	89 d8                	mov    %ebx,%eax
f01030f8:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01030fe:	c1 f8 03             	sar    $0x3,%eax
f0103101:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103104:	89 c2                	mov    %eax,%edx
f0103106:	c1 ea 0c             	shr    $0xc,%edx
f0103109:	83 c4 10             	add    $0x10,%esp
f010310c:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0103112:	0f 83 a6 01 00 00    	jae    f01032be <mem_init+0x1b6d>
	memset(page2kva(pp2), 2, PGSIZE);
f0103118:	83 ec 04             	sub    $0x4,%esp
f010311b:	68 00 10 00 00       	push   $0x1000
f0103120:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0103122:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103127:	50                   	push   %eax
f0103128:	e8 86 33 00 00       	call   f01064b3 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f010312d:	6a 02                	push   $0x2
f010312f:	68 00 10 00 00       	push   $0x1000
f0103134:	57                   	push   %edi
f0103135:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010313b:	e8 cf e4 ff ff       	call   f010160f <page_insert>
	assert(pp1->pp_ref == 1);
f0103140:	83 c4 20             	add    $0x20,%esp
f0103143:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103148:	0f 85 82 01 00 00    	jne    f01032d0 <mem_init+0x1b7f>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f010314e:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0103155:	01 01 01 
f0103158:	0f 85 8b 01 00 00    	jne    f01032e9 <mem_init+0x1b98>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f010315e:	6a 02                	push   $0x2
f0103160:	68 00 10 00 00       	push   $0x1000
f0103165:	53                   	push   %ebx
f0103166:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010316c:	e8 9e e4 ff ff       	call   f010160f <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103171:	83 c4 10             	add    $0x10,%esp
f0103174:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f010317b:	02 02 02 
f010317e:	0f 85 7e 01 00 00    	jne    f0103302 <mem_init+0x1bb1>
	assert(pp2->pp_ref == 1);
f0103184:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103189:	0f 85 8c 01 00 00    	jne    f010331b <mem_init+0x1bca>
	assert(pp1->pp_ref == 0);
f010318f:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103194:	0f 85 9a 01 00 00    	jne    f0103334 <mem_init+0x1be3>
	*(uint32_t *)PGSIZE = 0x03030303U;
f010319a:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f01031a1:	03 03 03 
	return (pp - pages) << PGSHIFT;
f01031a4:	89 d8                	mov    %ebx,%eax
f01031a6:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01031ac:	c1 f8 03             	sar    $0x3,%eax
f01031af:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01031b2:	89 c2                	mov    %eax,%edx
f01031b4:	c1 ea 0c             	shr    $0xc,%edx
f01031b7:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01031bd:	0f 83 8a 01 00 00    	jae    f010334d <mem_init+0x1bfc>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01031c3:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01031ca:	03 03 03 
f01031cd:	0f 85 8c 01 00 00    	jne    f010335f <mem_init+0x1c0e>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01031d3:	83 ec 08             	sub    $0x8,%esp
f01031d6:	68 00 10 00 00       	push   $0x1000
f01031db:	ff 35 ac be 57 f0    	pushl  0xf057beac
f01031e1:	e8 e3 e3 ff ff       	call   f01015c9 <page_remove>
	assert(pp2->pp_ref == 0);
f01031e6:	83 c4 10             	add    $0x10,%esp
f01031e9:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01031ee:	0f 85 84 01 00 00    	jne    f0103378 <mem_init+0x1c27>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01031f4:	8b 0d ac be 57 f0    	mov    0xf057beac,%ecx
f01031fa:	8b 11                	mov    (%ecx),%edx
f01031fc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0103202:	89 f0                	mov    %esi,%eax
f0103204:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f010320a:	c1 f8 03             	sar    $0x3,%eax
f010320d:	c1 e0 0c             	shl    $0xc,%eax
f0103210:	39 c2                	cmp    %eax,%edx
f0103212:	0f 85 79 01 00 00    	jne    f0103391 <mem_init+0x1c40>
	kern_pgdir[0] = 0;
f0103218:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f010321e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103223:	0f 85 81 01 00 00    	jne    f01033aa <mem_init+0x1c59>
	pp0->pp_ref = 0;
f0103229:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f010322f:	83 ec 0c             	sub    $0xc,%esp
f0103232:	56                   	push   %esi
f0103233:	e8 0d e1 ff ff       	call   f0101345 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103238:	c7 04 24 94 89 10 f0 	movl   $0xf0108994,(%esp)
f010323f:	e8 2b 0c 00 00       	call   f0103e6f <cprintf>
}
f0103244:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103247:	5b                   	pop    %ebx
f0103248:	5e                   	pop    %esi
f0103249:	5f                   	pop    %edi
f010324a:	5d                   	pop    %ebp
f010324b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010324c:	50                   	push   %eax
f010324d:	68 d8 78 10 f0       	push   $0xf01078d8
f0103252:	68 ef 00 00 00       	push   $0xef
f0103257:	68 45 8a 10 f0       	push   $0xf0108a45
f010325c:	e8 e8 cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0103261:	68 69 8b 10 f0       	push   $0xf0108b69
f0103266:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010326b:	68 79 04 00 00       	push   $0x479
f0103270:	68 45 8a 10 f0       	push   $0xf0108a45
f0103275:	e8 cf cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010327a:	68 7f 8b 10 f0       	push   $0xf0108b7f
f010327f:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0103284:	68 7a 04 00 00       	push   $0x47a
f0103289:	68 45 8a 10 f0       	push   $0xf0108a45
f010328e:	e8 b6 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0103293:	68 95 8b 10 f0       	push   $0xf0108b95
f0103298:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010329d:	68 7b 04 00 00       	push   $0x47b
f01032a2:	68 45 8a 10 f0       	push   $0xf0108a45
f01032a7:	e8 9d cd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01032ac:	50                   	push   %eax
f01032ad:	68 b4 78 10 f0       	push   $0xf01078b4
f01032b2:	6a 58                	push   $0x58
f01032b4:	68 51 8a 10 f0       	push   $0xf0108a51
f01032b9:	e8 8b cd ff ff       	call   f0100049 <_panic>
f01032be:	50                   	push   %eax
f01032bf:	68 b4 78 10 f0       	push   $0xf01078b4
f01032c4:	6a 58                	push   $0x58
f01032c6:	68 51 8a 10 f0       	push   $0xf0108a51
f01032cb:	e8 79 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01032d0:	68 66 8c 10 f0       	push   $0xf0108c66
f01032d5:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01032da:	68 80 04 00 00       	push   $0x480
f01032df:	68 45 8a 10 f0       	push   $0xf0108a45
f01032e4:	e8 60 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032e9:	68 20 89 10 f0       	push   $0xf0108920
f01032ee:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01032f3:	68 81 04 00 00       	push   $0x481
f01032f8:	68 45 8a 10 f0       	push   $0xf0108a45
f01032fd:	e8 47 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103302:	68 44 89 10 f0       	push   $0xf0108944
f0103307:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010330c:	68 83 04 00 00       	push   $0x483
f0103311:	68 45 8a 10 f0       	push   $0xf0108a45
f0103316:	e8 2e cd ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010331b:	68 88 8c 10 f0       	push   $0xf0108c88
f0103320:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0103325:	68 84 04 00 00       	push   $0x484
f010332a:	68 45 8a 10 f0       	push   $0xf0108a45
f010332f:	e8 15 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0103334:	68 f2 8c 10 f0       	push   $0xf0108cf2
f0103339:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010333e:	68 85 04 00 00       	push   $0x485
f0103343:	68 45 8a 10 f0       	push   $0xf0108a45
f0103348:	e8 fc cc ff ff       	call   f0100049 <_panic>
f010334d:	50                   	push   %eax
f010334e:	68 b4 78 10 f0       	push   $0xf01078b4
f0103353:	6a 58                	push   $0x58
f0103355:	68 51 8a 10 f0       	push   $0xf0108a51
f010335a:	e8 ea cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010335f:	68 68 89 10 f0       	push   $0xf0108968
f0103364:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0103369:	68 87 04 00 00       	push   $0x487
f010336e:	68 45 8a 10 f0       	push   $0xf0108a45
f0103373:	e8 d1 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103378:	68 c0 8c 10 f0       	push   $0xf0108cc0
f010337d:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0103382:	68 89 04 00 00       	push   $0x489
f0103387:	68 45 8a 10 f0       	push   $0xf0108a45
f010338c:	e8 b8 cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103391:	68 c4 82 10 f0       	push   $0xf01082c4
f0103396:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010339b:	68 8c 04 00 00       	push   $0x48c
f01033a0:	68 45 8a 10 f0       	push   $0xf0108a45
f01033a5:	e8 9f cc ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f01033aa:	68 77 8c 10 f0       	push   $0xf0108c77
f01033af:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01033b4:	68 8e 04 00 00       	push   $0x48e
f01033b9:	68 45 8a 10 f0       	push   $0xf0108a45
f01033be:	e8 86 cc ff ff       	call   f0100049 <_panic>

f01033c3 <user_mem_check>:
{
f01033c3:	55                   	push   %ebp
f01033c4:	89 e5                	mov    %esp,%ebp
f01033c6:	57                   	push   %edi
f01033c7:	56                   	push   %esi
f01033c8:	53                   	push   %ebx
f01033c9:	83 ec 1c             	sub    $0x1c,%esp
f01033cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	perm |= PTE_P;
f01033cf:	8b 7d 14             	mov    0x14(%ebp),%edi
f01033d2:	83 cf 01             	or     $0x1,%edi
	uint32_t i = (uint32_t)va; //buggy lab3 buggy
f01033d5:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	uint32_t end = (uint32_t)va + len;
f01033d8:	89 d8                	mov    %ebx,%eax
f01033da:	03 45 10             	add    0x10(%ebp),%eax
f01033dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01033e0:	8b 75 08             	mov    0x8(%ebp),%esi
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f01033e3:	eb 19                	jmp    f01033fe <user_mem_check+0x3b>
			user_mem_check_addr = (uintptr_t)i;
f01033e5:	89 1d 3c a2 57 f0    	mov    %ebx,0xf057a23c
			return -E_FAULT;
f01033eb:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01033f0:	eb 6a                	jmp    f010345c <user_mem_check+0x99>
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f01033f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01033f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01033fe:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103401:	73 61                	jae    f0103464 <user_mem_check+0xa1>
		if((uint32_t)va >= ULIM){
f0103403:	81 7d e0 ff ff 7f ef 	cmpl   $0xef7fffff,-0x20(%ebp)
f010340a:	77 d9                	ja     f01033e5 <user_mem_check+0x22>
		pte_t *the_pte = pgdir_walk(env->env_pgdir, (void *)i, 0);
f010340c:	83 ec 04             	sub    $0x4,%esp
f010340f:	6a 00                	push   $0x0
f0103411:	53                   	push   %ebx
f0103412:	ff 76 60             	pushl  0x60(%esi)
f0103415:	e8 8f df ff ff       	call   f01013a9 <pgdir_walk>
		if(!the_pte || (*the_pte & perm) != perm){//lab4 bug
f010341a:	83 c4 10             	add    $0x10,%esp
f010341d:	85 c0                	test   %eax,%eax
f010341f:	74 08                	je     f0103429 <user_mem_check+0x66>
f0103421:	89 fa                	mov    %edi,%edx
f0103423:	23 10                	and    (%eax),%edx
f0103425:	39 d7                	cmp    %edx,%edi
f0103427:	74 c9                	je     f01033f2 <user_mem_check+0x2f>
f0103429:	89 c6                	mov    %eax,%esi
			cprintf("PTE_P: 0x%x PTE_W: 0x%x PTE_U: 0x%x\n", PTE_P, PTE_W, PTE_U);
f010342b:	6a 04                	push   $0x4
f010342d:	6a 02                	push   $0x2
f010342f:	6a 01                	push   $0x1
f0103431:	68 c0 89 10 f0       	push   $0xf01089c0
f0103436:	e8 34 0a 00 00       	call   f0103e6f <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f010343b:	83 c4 0c             	add    $0xc,%esp
f010343e:	89 f8                	mov    %edi,%eax
f0103440:	23 06                	and    (%esi),%eax
f0103442:	50                   	push   %eax
f0103443:	57                   	push   %edi
f0103444:	68 e8 89 10 f0       	push   $0xf01089e8
f0103449:	e8 21 0a 00 00       	call   f0103e6f <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f010344e:	89 1d 3c a2 57 f0    	mov    %ebx,0xf057a23c
			return -E_FAULT;
f0103454:	83 c4 10             	add    $0x10,%esp
f0103457:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f010345c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010345f:	5b                   	pop    %ebx
f0103460:	5e                   	pop    %esi
f0103461:	5f                   	pop    %edi
f0103462:	5d                   	pop    %ebp
f0103463:	c3                   	ret    
	return 0;
f0103464:	b8 00 00 00 00       	mov    $0x0,%eax
f0103469:	eb f1                	jmp    f010345c <user_mem_check+0x99>

f010346b <user_mem_assert>:
{
f010346b:	55                   	push   %ebp
f010346c:	89 e5                	mov    %esp,%ebp
f010346e:	53                   	push   %ebx
f010346f:	83 ec 04             	sub    $0x4,%esp
f0103472:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103475:	8b 45 14             	mov    0x14(%ebp),%eax
f0103478:	83 c8 04             	or     $0x4,%eax
f010347b:	50                   	push   %eax
f010347c:	ff 75 10             	pushl  0x10(%ebp)
f010347f:	ff 75 0c             	pushl  0xc(%ebp)
f0103482:	53                   	push   %ebx
f0103483:	e8 3b ff ff ff       	call   f01033c3 <user_mem_check>
f0103488:	83 c4 10             	add    $0x10,%esp
f010348b:	85 c0                	test   %eax,%eax
f010348d:	78 05                	js     f0103494 <user_mem_assert+0x29>
}
f010348f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103492:	c9                   	leave  
f0103493:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103494:	83 ec 04             	sub    $0x4,%esp
f0103497:	ff 35 3c a2 57 f0    	pushl  0xf057a23c
f010349d:	ff 73 48             	pushl  0x48(%ebx)
f01034a0:	68 10 8a 10 f0       	push   $0xf0108a10
f01034a5:	e8 c5 09 00 00       	call   f0103e6f <cprintf>
		env_destroy(env);	// may not return
f01034aa:	89 1c 24             	mov    %ebx,(%esp)
f01034ad:	e8 56 06 00 00       	call   f0103b08 <env_destroy>
f01034b2:	83 c4 10             	add    $0x10,%esp
}
f01034b5:	eb d8                	jmp    f010348f <user_mem_assert+0x24>

f01034b7 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f01034b7:	55                   	push   %ebp
f01034b8:	89 e5                	mov    %esp,%ebp
f01034ba:	57                   	push   %edi
f01034bb:	56                   	push   %esi
f01034bc:	53                   	push   %ebx
f01034bd:	83 ec 0c             	sub    $0xc,%esp
f01034c0:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	int i = ROUNDDOWN((uint32_t)va, PGSIZE);
f01034c2:	89 d3                	mov    %edx,%ebx
f01034c4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)va + len, PGSIZE);
f01034ca:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01034d1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01034d7:	39 f3                	cmp    %esi,%ebx
f01034d9:	7d 5a                	jge    f0103535 <region_alloc+0x7e>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01034db:	83 ec 0c             	sub    $0xc,%esp
f01034de:	6a 01                	push   $0x1
f01034e0:	e8 ee dd ff ff       	call   f01012d3 <page_alloc>
		if(!page)
f01034e5:	83 c4 10             	add    $0x10,%esp
f01034e8:	85 c0                	test   %eax,%eax
f01034ea:	74 1b                	je     f0103507 <region_alloc+0x50>
			panic("there is no page\n");
		int ret = page_insert(e->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f01034ec:	6a 06                	push   $0x6
f01034ee:	53                   	push   %ebx
f01034ef:	50                   	push   %eax
f01034f0:	ff 77 60             	pushl  0x60(%edi)
f01034f3:	e8 17 e1 ff ff       	call   f010160f <page_insert>
		if(ret)
f01034f8:	83 c4 10             	add    $0x10,%esp
f01034fb:	85 c0                	test   %eax,%eax
f01034fd:	75 1f                	jne    f010351e <region_alloc+0x67>
	for(; i < end; i+=PGSIZE){
f01034ff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103505:	eb d0                	jmp    f01034d7 <region_alloc+0x20>
			panic("there is no page\n");
f0103507:	83 ec 04             	sub    $0x4,%esp
f010350a:	68 b4 8d 10 f0       	push   $0xf0108db4
f010350f:	68 26 01 00 00       	push   $0x126
f0103514:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103519:	e8 2b cb ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f010351e:	83 ec 04             	sub    $0x4,%esp
f0103521:	68 d1 8d 10 f0       	push   $0xf0108dd1
f0103526:	68 29 01 00 00       	push   $0x129
f010352b:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103530:	e8 14 cb ff ff       	call   f0100049 <_panic>
	}
}
f0103535:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103538:	5b                   	pop    %ebx
f0103539:	5e                   	pop    %esi
f010353a:	5f                   	pop    %edi
f010353b:	5d                   	pop    %ebp
f010353c:	c3                   	ret    

f010353d <envid2env>:
{
f010353d:	55                   	push   %ebp
f010353e:	89 e5                	mov    %esp,%ebp
f0103540:	56                   	push   %esi
f0103541:	53                   	push   %ebx
f0103542:	8b 75 08             	mov    0x8(%ebp),%esi
f0103545:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103548:	85 f6                	test   %esi,%esi
f010354a:	74 2e                	je     f010357a <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f010354c:	89 f3                	mov    %esi,%ebx
f010354e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103554:	c1 e3 07             	shl    $0x7,%ebx
f0103557:	03 1d 44 a2 57 f0    	add    0xf057a244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010355d:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103561:	74 2e                	je     f0103591 <envid2env+0x54>
f0103563:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103566:	75 29                	jne    f0103591 <envid2env+0x54>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103568:	84 c0                	test   %al,%al
f010356a:	75 35                	jne    f01035a1 <envid2env+0x64>
	*env_store = e;
f010356c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010356f:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103571:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103576:	5b                   	pop    %ebx
f0103577:	5e                   	pop    %esi
f0103578:	5d                   	pop    %ebp
f0103579:	c3                   	ret    
		*env_store = curenv;
f010357a:	e8 3b 35 00 00       	call   f0106aba <cpunum>
f010357f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103582:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103588:	8b 55 0c             	mov    0xc(%ebp),%edx
f010358b:	89 02                	mov    %eax,(%edx)
		return 0;
f010358d:	89 f0                	mov    %esi,%eax
f010358f:	eb e5                	jmp    f0103576 <envid2env+0x39>
		*env_store = 0;
f0103591:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010359a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010359f:	eb d5                	jmp    f0103576 <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01035a1:	e8 14 35 00 00       	call   f0106aba <cpunum>
f01035a6:	6b c0 74             	imul   $0x74,%eax,%eax
f01035a9:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f01035af:	74 bb                	je     f010356c <envid2env+0x2f>
f01035b1:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01035b4:	e8 01 35 00 00       	call   f0106aba <cpunum>
f01035b9:	6b c0 74             	imul   $0x74,%eax,%eax
f01035bc:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01035c2:	3b 70 48             	cmp    0x48(%eax),%esi
f01035c5:	74 a5                	je     f010356c <envid2env+0x2f>
		*env_store = 0;
f01035c7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01035d0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01035d5:	eb 9f                	jmp    f0103576 <envid2env+0x39>

f01035d7 <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f01035d7:	b8 20 73 12 f0       	mov    $0xf0127320,%eax
f01035dc:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01035df:	b8 23 00 00 00       	mov    $0x23,%eax
f01035e4:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01035e6:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01035e8:	b8 10 00 00 00       	mov    $0x10,%eax
f01035ed:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01035ef:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01035f1:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01035f3:	ea fa 35 10 f0 08 00 	ljmp   $0x8,$0xf01035fa
	asm volatile("lldt %0" : : "r" (sel));
f01035fa:	b8 00 00 00 00       	mov    $0x0,%eax
f01035ff:	0f 00 d0             	lldt   %ax
}
f0103602:	c3                   	ret    

f0103603 <env_init>:
{
f0103603:	55                   	push   %ebp
f0103604:	89 e5                	mov    %esp,%ebp
f0103606:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f0103609:	8b 15 44 a2 57 f0    	mov    0xf057a244,%edx
f010360f:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
f0103615:	81 c2 00 00 02 00    	add    $0x20000,%edx
f010361b:	c7 40 c8 00 00 00 00 	movl   $0x0,-0x38(%eax)
		envs[i].env_link = &envs[i+1];
f0103622:	89 40 c4             	mov    %eax,-0x3c(%eax)
f0103625:	83 e8 80             	sub    $0xffffff80,%eax
	for(int i = 0; i < NENV - 1; i++){
f0103628:	39 d0                	cmp    %edx,%eax
f010362a:	75 ef                	jne    f010361b <env_init+0x18>
	env_free_list = envs;
f010362c:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
f0103631:	a3 48 a2 57 f0       	mov    %eax,0xf057a248
	env_init_percpu();
f0103636:	e8 9c ff ff ff       	call   f01035d7 <env_init_percpu>
}
f010363b:	c9                   	leave  
f010363c:	c3                   	ret    

f010363d <env_alloc>:
{
f010363d:	55                   	push   %ebp
f010363e:	89 e5                	mov    %esp,%ebp
f0103640:	53                   	push   %ebx
f0103641:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103644:	8b 1d 48 a2 57 f0    	mov    0xf057a248,%ebx
f010364a:	85 db                	test   %ebx,%ebx
f010364c:	0f 84 75 01 00 00    	je     f01037c7 <env_alloc+0x18a>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103652:	83 ec 0c             	sub    $0xc,%esp
f0103655:	6a 01                	push   $0x1
f0103657:	e8 77 dc ff ff       	call   f01012d3 <page_alloc>
f010365c:	83 c4 10             	add    $0x10,%esp
f010365f:	85 c0                	test   %eax,%eax
f0103661:	0f 84 67 01 00 00    	je     f01037ce <env_alloc+0x191>
	p->pp_ref++;
f0103667:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010366c:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0103672:	c1 f8 03             	sar    $0x3,%eax
f0103675:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103678:	89 c2                	mov    %eax,%edx
f010367a:	c1 ea 0c             	shr    $0xc,%edx
f010367d:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0103683:	0f 83 17 01 00 00    	jae    f01037a0 <env_alloc+0x163>
	return (void *)(pa + KERNBASE);
f0103689:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f010368e:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy((void *)e->env_pgdir, (void *)kern_pgdir, PGSIZE);
f0103691:	83 ec 04             	sub    $0x4,%esp
f0103694:	68 00 10 00 00       	push   $0x1000
f0103699:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010369f:	50                   	push   %eax
f01036a0:	e8 b8 2e 00 00       	call   f010655d <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01036a5:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01036a8:	83 c4 10             	add    $0x10,%esp
f01036ab:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036b0:	0f 86 fc 00 00 00    	jbe    f01037b2 <env_alloc+0x175>
	return (physaddr_t)kva - KERNBASE;
f01036b6:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01036bc:	83 ca 05             	or     $0x5,%edx
f01036bf:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01036c5:	8b 43 48             	mov    0x48(%ebx),%eax
f01036c8:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f01036cd:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f01036d2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01036d7:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01036da:	89 da                	mov    %ebx,%edx
f01036dc:	2b 15 44 a2 57 f0    	sub    0xf057a244,%edx
f01036e2:	c1 fa 07             	sar    $0x7,%edx
f01036e5:	09 d0                	or     %edx,%eax
f01036e7:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01036ea:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036ed:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01036f0:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01036f7:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01036fe:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f0103705:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f010370c:	83 ec 04             	sub    $0x4,%esp
f010370f:	6a 44                	push   $0x44
f0103711:	6a 00                	push   $0x0
f0103713:	53                   	push   %ebx
f0103714:	e8 9a 2d 00 00       	call   f01064b3 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103719:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f010371f:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103725:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010372b:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103732:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103738:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f010373f:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103746:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f010374a:	8b 43 44             	mov    0x44(%ebx),%eax
f010374d:	a3 48 a2 57 f0       	mov    %eax,0xf057a248
	*newenv_store = e;
f0103752:	8b 45 08             	mov    0x8(%ebp),%eax
f0103755:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103757:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010375a:	e8 5b 33 00 00       	call   f0106aba <cpunum>
f010375f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103762:	83 c4 10             	add    $0x10,%esp
f0103765:	ba 00 00 00 00       	mov    $0x0,%edx
f010376a:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0103771:	74 11                	je     f0103784 <env_alloc+0x147>
f0103773:	e8 42 33 00 00       	call   f0106aba <cpunum>
f0103778:	6b c0 74             	imul   $0x74,%eax,%eax
f010377b:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103781:	8b 50 48             	mov    0x48(%eax),%edx
f0103784:	83 ec 04             	sub    $0x4,%esp
f0103787:	53                   	push   %ebx
f0103788:	52                   	push   %edx
f0103789:	68 ea 8d 10 f0       	push   $0xf0108dea
f010378e:	e8 dc 06 00 00       	call   f0103e6f <cprintf>
	return 0;
f0103793:	83 c4 10             	add    $0x10,%esp
f0103796:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010379b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010379e:	c9                   	leave  
f010379f:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01037a0:	50                   	push   %eax
f01037a1:	68 b4 78 10 f0       	push   $0xf01078b4
f01037a6:	6a 58                	push   $0x58
f01037a8:	68 51 8a 10 f0       	push   $0xf0108a51
f01037ad:	e8 97 c8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037b2:	50                   	push   %eax
f01037b3:	68 d8 78 10 f0       	push   $0xf01078d8
f01037b8:	68 c2 00 00 00       	push   $0xc2
f01037bd:	68 c6 8d 10 f0       	push   $0xf0108dc6
f01037c2:	e8 82 c8 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f01037c7:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01037cc:	eb cd                	jmp    f010379b <env_alloc+0x15e>
		return -E_NO_MEM;
f01037ce:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01037d3:	eb c6                	jmp    f010379b <env_alloc+0x15e>

f01037d5 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f01037d5:	55                   	push   %ebp
f01037d6:	89 e5                	mov    %esp,%ebp
f01037d8:	57                   	push   %edi
f01037d9:	56                   	push   %esi
f01037da:	53                   	push   %ebx
f01037db:	83 ec 34             	sub    $0x34,%esp
f01037de:	8b 7d 08             	mov    0x8(%ebp),%edi
f01037e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	struct Env *e;
	int ret = env_alloc(&e, 0);
f01037e4:	6a 00                	push   $0x0
f01037e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01037e9:	50                   	push   %eax
f01037ea:	e8 4e fe ff ff       	call   f010363d <env_alloc>
	if(ret)
f01037ef:	83 c4 10             	add    $0x10,%esp
f01037f2:	85 c0                	test   %eax,%eax
f01037f4:	75 49                	jne    f010383f <env_create+0x6a>
		panic("env_alloc failed\n");
	e->env_parent_id = 0;
f01037f6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01037f9:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
	e->env_type = type;
f0103800:	89 5e 50             	mov    %ebx,0x50(%esi)
	if(type == ENV_TYPE_FS){
f0103803:	83 fb 01             	cmp    $0x1,%ebx
f0103806:	74 4e                	je     f0103856 <env_create+0x81>
	if (elf->e_magic != ELF_MAGIC)
f0103808:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f010380e:	75 4f                	jne    f010385f <env_create+0x8a>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103810:	89 fb                	mov    %edi,%ebx
f0103812:	03 5f 1c             	add    0x1c(%edi),%ebx
	eph = ph + elf->e_phnum;
f0103815:	0f b7 47 2c          	movzwl 0x2c(%edi),%eax
f0103819:	c1 e0 05             	shl    $0x5,%eax
f010381c:	01 d8                	add    %ebx,%eax
f010381e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	lcr3(PADDR(e->env_pgdir));
f0103821:	8b 46 60             	mov    0x60(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103824:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103829:	76 4b                	jbe    f0103876 <env_create+0xa1>
	return (physaddr_t)kva - KERNBASE;
f010382b:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103830:	0f 22 d8             	mov    %eax,%cr3
	uint32_t elf_load_sz = 0;
f0103833:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010383a:	e9 89 00 00 00       	jmp    f01038c8 <env_create+0xf3>
		panic("env_alloc failed\n");
f010383f:	83 ec 04             	sub    $0x4,%esp
f0103842:	68 ff 8d 10 f0       	push   $0xf0108dff
f0103847:	68 99 01 00 00       	push   $0x199
f010384c:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103851:	e8 f3 c7 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103856:	81 4e 38 00 30 00 00 	orl    $0x3000,0x38(%esi)
f010385d:	eb a9                	jmp    f0103808 <env_create+0x33>
		panic("is this a valid ELF");
f010385f:	83 ec 04             	sub    $0x4,%esp
f0103862:	68 11 8e 10 f0       	push   $0xf0108e11
f0103867:	68 70 01 00 00       	push   $0x170
f010386c:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103871:	e8 d3 c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103876:	50                   	push   %eax
f0103877:	68 d8 78 10 f0       	push   $0xf01078d8
f010387c:	68 75 01 00 00       	push   $0x175
f0103881:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103886:	e8 be c7 ff ff       	call   f0100049 <_panic>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f010388b:	8b 4b 14             	mov    0x14(%ebx),%ecx
f010388e:	8b 53 08             	mov    0x8(%ebx),%edx
f0103891:	89 f0                	mov    %esi,%eax
f0103893:	e8 1f fc ff ff       	call   f01034b7 <region_alloc>
			memset((void *)ph->p_va, 0, ph->p_memsz);
f0103898:	83 ec 04             	sub    $0x4,%esp
f010389b:	ff 73 14             	pushl  0x14(%ebx)
f010389e:	6a 00                	push   $0x0
f01038a0:	ff 73 08             	pushl  0x8(%ebx)
f01038a3:	e8 0b 2c 00 00       	call   f01064b3 <memset>
			memcpy((void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f01038a8:	83 c4 0c             	add    $0xc,%esp
f01038ab:	ff 73 10             	pushl  0x10(%ebx)
f01038ae:	89 f8                	mov    %edi,%eax
f01038b0:	03 43 04             	add    0x4(%ebx),%eax
f01038b3:	50                   	push   %eax
f01038b4:	ff 73 08             	pushl  0x8(%ebx)
f01038b7:	e8 a1 2c 00 00       	call   f010655d <memcpy>
			elf_load_sz += ph->p_memsz;
f01038bc:	8b 53 14             	mov    0x14(%ebx),%edx
f01038bf:	01 55 d4             	add    %edx,-0x2c(%ebp)
f01038c2:	83 c4 10             	add    $0x10,%esp
	for (; ph < eph; ph++){
f01038c5:	83 c3 20             	add    $0x20,%ebx
f01038c8:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f01038cb:	76 07                	jbe    f01038d4 <env_create+0xff>
		if(ph->p_type == ELF_PROG_LOAD){
f01038cd:	83 3b 01             	cmpl   $0x1,(%ebx)
f01038d0:	75 f3                	jne    f01038c5 <env_create+0xf0>
f01038d2:	eb b7                	jmp    f010388b <env_create+0xb6>
	e->env_tf.tf_eip = elf->e_entry;
f01038d4:	8b 47 18             	mov    0x18(%edi),%eax
f01038d7:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f01038da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01038dd:	05 00 00 80 00       	add    $0x800000,%eax
f01038e2:	89 46 7c             	mov    %eax,0x7c(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f01038e5:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01038ea:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01038ef:	89 f0                	mov    %esi,%eax
f01038f1:	e8 c1 fb ff ff       	call   f01034b7 <region_alloc>
	lcr3(PADDR(kern_pgdir));
f01038f6:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f01038fb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103900:	76 10                	jbe    f0103912 <env_create+0x13d>
	return (physaddr_t)kva - KERNBASE;
f0103902:	05 00 00 00 10       	add    $0x10000000,%eax
f0103907:	0f 22 d8             	mov    %eax,%cr3
	}
	load_icode(e, binary);
}
f010390a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010390d:	5b                   	pop    %ebx
f010390e:	5e                   	pop    %esi
f010390f:	5f                   	pop    %edi
f0103910:	5d                   	pop    %ebp
f0103911:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103912:	50                   	push   %eax
f0103913:	68 d8 78 10 f0       	push   $0xf01078d8
f0103918:	68 85 01 00 00       	push   $0x185
f010391d:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103922:	e8 22 c7 ff ff       	call   f0100049 <_panic>

f0103927 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103927:	55                   	push   %ebp
f0103928:	89 e5                	mov    %esp,%ebp
f010392a:	57                   	push   %edi
f010392b:	56                   	push   %esi
f010392c:	53                   	push   %ebx
f010392d:	83 ec 1c             	sub    $0x1c,%esp
f0103930:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103933:	e8 82 31 00 00       	call   f0106aba <cpunum>
f0103938:	6b c0 74             	imul   $0x74,%eax,%eax
f010393b:	39 b8 28 c0 57 f0    	cmp    %edi,-0xfa83fd8(%eax)
f0103941:	74 48                	je     f010398b <env_free+0x64>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103943:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103946:	e8 6f 31 00 00       	call   f0106aba <cpunum>
f010394b:	6b c0 74             	imul   $0x74,%eax,%eax
f010394e:	ba 00 00 00 00       	mov    $0x0,%edx
f0103953:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f010395a:	74 11                	je     f010396d <env_free+0x46>
f010395c:	e8 59 31 00 00       	call   f0106aba <cpunum>
f0103961:	6b c0 74             	imul   $0x74,%eax,%eax
f0103964:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010396a:	8b 50 48             	mov    0x48(%eax),%edx
f010396d:	83 ec 04             	sub    $0x4,%esp
f0103970:	53                   	push   %ebx
f0103971:	52                   	push   %edx
f0103972:	68 25 8e 10 f0       	push   $0xf0108e25
f0103977:	e8 f3 04 00 00       	call   f0103e6f <cprintf>
f010397c:	83 c4 10             	add    $0x10,%esp
f010397f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103986:	e9 a9 00 00 00       	jmp    f0103a34 <env_free+0x10d>
		lcr3(PADDR(kern_pgdir));
f010398b:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f0103990:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103995:	76 0a                	jbe    f01039a1 <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f0103997:	05 00 00 00 10       	add    $0x10000000,%eax
f010399c:	0f 22 d8             	mov    %eax,%cr3
f010399f:	eb a2                	jmp    f0103943 <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01039a1:	50                   	push   %eax
f01039a2:	68 d8 78 10 f0       	push   $0xf01078d8
f01039a7:	68 b0 01 00 00       	push   $0x1b0
f01039ac:	68 c6 8d 10 f0       	push   $0xf0108dc6
f01039b1:	e8 93 c6 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01039b6:	56                   	push   %esi
f01039b7:	68 b4 78 10 f0       	push   $0xf01078b4
f01039bc:	68 bf 01 00 00       	push   $0x1bf
f01039c1:	68 c6 8d 10 f0       	push   $0xf0108dc6
f01039c6:	e8 7e c6 ff ff       	call   f0100049 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01039cb:	83 ec 08             	sub    $0x8,%esp
f01039ce:	89 d8                	mov    %ebx,%eax
f01039d0:	c1 e0 0c             	shl    $0xc,%eax
f01039d3:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01039d6:	50                   	push   %eax
f01039d7:	ff 77 60             	pushl  0x60(%edi)
f01039da:	e8 ea db ff ff       	call   f01015c9 <page_remove>
f01039df:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01039e2:	83 c3 01             	add    $0x1,%ebx
f01039e5:	83 c6 04             	add    $0x4,%esi
f01039e8:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f01039ee:	74 07                	je     f01039f7 <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f01039f0:	f6 06 01             	testb  $0x1,(%esi)
f01039f3:	74 ed                	je     f01039e2 <env_free+0xbb>
f01039f5:	eb d4                	jmp    f01039cb <env_free+0xa4>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f01039f7:	8b 47 60             	mov    0x60(%edi),%eax
f01039fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01039fd:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103a07:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f0103a0d:	73 69                	jae    f0103a78 <env_free+0x151>
		page_decref(pa2page(pa));
f0103a0f:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103a12:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
f0103a17:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103a1a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103a1d:	50                   	push   %eax
f0103a1e:	e8 5d d9 ff ff       	call   f0101380 <page_decref>
f0103a23:	83 c4 10             	add    $0x10,%esp
f0103a26:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103a2d:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103a32:	74 58                	je     f0103a8c <env_free+0x165>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103a34:	8b 47 60             	mov    0x60(%edi),%eax
f0103a37:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a3a:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103a3d:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103a43:	74 e1                	je     f0103a26 <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103a45:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103a4b:	89 f0                	mov    %esi,%eax
f0103a4d:	c1 e8 0c             	shr    $0xc,%eax
f0103a50:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103a53:	39 05 a8 be 57 f0    	cmp    %eax,0xf057bea8
f0103a59:	0f 86 57 ff ff ff    	jbe    f01039b6 <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0103a5f:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103a68:	c1 e0 14             	shl    $0x14,%eax
f0103a6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103a6e:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103a73:	e9 78 ff ff ff       	jmp    f01039f0 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f0103a78:	83 ec 04             	sub    $0x4,%esp
f0103a7b:	68 90 81 10 f0       	push   $0xf0108190
f0103a80:	6a 51                	push   $0x51
f0103a82:	68 51 8a 10 f0       	push   $0xf0108a51
f0103a87:	e8 bd c5 ff ff       	call   f0100049 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103a8c:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103a8f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a94:	76 49                	jbe    f0103adf <env_free+0x1b8>
	e->env_pgdir = 0;
f0103a96:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103a9d:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103aa2:	c1 e8 0c             	shr    $0xc,%eax
f0103aa5:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f0103aab:	73 47                	jae    f0103af4 <env_free+0x1cd>
	page_decref(pa2page(pa));
f0103aad:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103ab0:	8b 15 b0 be 57 f0    	mov    0xf057beb0,%edx
f0103ab6:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103ab9:	50                   	push   %eax
f0103aba:	e8 c1 d8 ff ff       	call   f0101380 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103abf:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103ac6:	a1 48 a2 57 f0       	mov    0xf057a248,%eax
f0103acb:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103ace:	89 3d 48 a2 57 f0    	mov    %edi,0xf057a248
}
f0103ad4:	83 c4 10             	add    $0x10,%esp
f0103ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103ada:	5b                   	pop    %ebx
f0103adb:	5e                   	pop    %esi
f0103adc:	5f                   	pop    %edi
f0103add:	5d                   	pop    %ebp
f0103ade:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103adf:	50                   	push   %eax
f0103ae0:	68 d8 78 10 f0       	push   $0xf01078d8
f0103ae5:	68 cd 01 00 00       	push   $0x1cd
f0103aea:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103aef:	e8 55 c5 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0103af4:	83 ec 04             	sub    $0x4,%esp
f0103af7:	68 90 81 10 f0       	push   $0xf0108190
f0103afc:	6a 51                	push   $0x51
f0103afe:	68 51 8a 10 f0       	push   $0xf0108a51
f0103b03:	e8 41 c5 ff ff       	call   f0100049 <_panic>

f0103b08 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103b08:	55                   	push   %ebp
f0103b09:	89 e5                	mov    %esp,%ebp
f0103b0b:	53                   	push   %ebx
f0103b0c:	83 ec 04             	sub    $0x4,%esp
f0103b0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b12:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103b16:	74 21                	je     f0103b39 <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103b18:	83 ec 0c             	sub    $0xc,%esp
f0103b1b:	53                   	push   %ebx
f0103b1c:	e8 06 fe ff ff       	call   f0103927 <env_free>

	if (curenv == e) {
f0103b21:	e8 94 2f 00 00       	call   f0106aba <cpunum>
f0103b26:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b29:	83 c4 10             	add    $0x10,%esp
f0103b2c:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f0103b32:	74 1e                	je     f0103b52 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b37:	c9                   	leave  
f0103b38:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b39:	e8 7c 2f 00 00       	call   f0106aba <cpunum>
f0103b3e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b41:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f0103b47:	74 cf                	je     f0103b18 <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103b49:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103b50:	eb e2                	jmp    f0103b34 <env_destroy+0x2c>
		curenv = NULL;
f0103b52:	e8 63 2f 00 00       	call   f0106aba <cpunum>
f0103b57:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b5a:	c7 80 28 c0 57 f0 00 	movl   $0x0,-0xfa83fd8(%eax)
f0103b61:	00 00 00 
		sched_yield();
f0103b64:	e8 b3 12 00 00       	call   f0104e1c <sched_yield>

f0103b69 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103b69:	55                   	push   %ebp
f0103b6a:	89 e5                	mov    %esp,%ebp
f0103b6c:	53                   	push   %ebx
f0103b6d:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103b70:	e8 45 2f 00 00       	call   f0106aba <cpunum>
f0103b75:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b78:	8b 98 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%ebx
f0103b7e:	e8 37 2f 00 00       	call   f0106aba <cpunum>
f0103b83:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f0103b86:	8b 65 08             	mov    0x8(%ebp),%esp
f0103b89:	61                   	popa   
f0103b8a:	07                   	pop    %es
f0103b8b:	1f                   	pop    %ds
f0103b8c:	83 c4 08             	add    $0x8,%esp
f0103b8f:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103b90:	83 ec 04             	sub    $0x4,%esp
f0103b93:	68 3b 8e 10 f0       	push   $0xf0108e3b
f0103b98:	68 04 02 00 00       	push   $0x204
f0103b9d:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103ba2:	e8 a2 c4 ff ff       	call   f0100049 <_panic>

f0103ba7 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103ba7:	55                   	push   %ebp
f0103ba8:	89 e5                	mov    %esp,%ebp
f0103baa:	53                   	push   %ebx
f0103bab:	83 ec 04             	sub    $0x4,%esp
f0103bae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f0103bb1:	e8 04 2f 00 00       	call   f0106aba <cpunum>
f0103bb6:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bb9:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f0103bbf:	74 7e                	je     f0103c3f <env_run+0x98>
		if(curenv && curenv->env_status == ENV_RUNNING)
f0103bc1:	e8 f4 2e 00 00       	call   f0106aba <cpunum>
f0103bc6:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bc9:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0103bd0:	74 18                	je     f0103bea <env_run+0x43>
f0103bd2:	e8 e3 2e 00 00       	call   f0106aba <cpunum>
f0103bd7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bda:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103be0:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103be4:	0f 84 9a 00 00 00    	je     f0103c84 <env_run+0xdd>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f0103bea:	e8 cb 2e 00 00       	call   f0106aba <cpunum>
f0103bef:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bf2:	89 98 28 c0 57 f0    	mov    %ebx,-0xfa83fd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0103bf8:	e8 bd 2e 00 00       	call   f0106aba <cpunum>
f0103bfd:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c00:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c06:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0103c0d:	e8 a8 2e 00 00       	call   f0106aba <cpunum>
f0103c12:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c15:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c1b:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f0103c1f:	e8 96 2e 00 00       	call   f0106aba <cpunum>
f0103c24:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c27:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c2d:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103c30:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c35:	76 67                	jbe    f0103c9e <env_run+0xf7>
	return (physaddr_t)kva - KERNBASE;
f0103c37:	05 00 00 00 10       	add    $0x10000000,%eax
f0103c3c:	0f 22 d8             	mov    %eax,%cr3
	}
	lcr3(PADDR(curenv->env_pgdir));
f0103c3f:	e8 76 2e 00 00       	call   f0106aba <cpunum>
f0103c44:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c47:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c4d:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103c50:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c55:	76 5c                	jbe    f0103cb3 <env_run+0x10c>
	return (physaddr_t)kva - KERNBASE;
f0103c57:	05 00 00 00 10       	add    $0x10000000,%eax
f0103c5c:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103c5f:	83 ec 0c             	sub    $0xc,%esp
f0103c62:	68 c0 73 12 f0       	push   $0xf01273c0
f0103c67:	e8 5a 31 00 00       	call   f0106dc6 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103c6c:	f3 90                	pause  
	unlock_kernel(); //lab4 bug?
	env_pop_tf(&curenv->env_tf);
f0103c6e:	e8 47 2e 00 00       	call   f0106aba <cpunum>
f0103c73:	83 c4 04             	add    $0x4,%esp
f0103c76:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c79:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0103c7f:	e8 e5 fe ff ff       	call   f0103b69 <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0103c84:	e8 31 2e 00 00       	call   f0106aba <cpunum>
f0103c89:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c8c:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c92:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103c99:	e9 4c ff ff ff       	jmp    f0103bea <env_run+0x43>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103c9e:	50                   	push   %eax
f0103c9f:	68 d8 78 10 f0       	push   $0xf01078d8
f0103ca4:	68 28 02 00 00       	push   $0x228
f0103ca9:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103cae:	e8 96 c3 ff ff       	call   f0100049 <_panic>
f0103cb3:	50                   	push   %eax
f0103cb4:	68 d8 78 10 f0       	push   $0xf01078d8
f0103cb9:	68 2a 02 00 00       	push   $0x22a
f0103cbe:	68 c6 8d 10 f0       	push   $0xf0108dc6
f0103cc3:	e8 81 c3 ff ff       	call   f0100049 <_panic>

f0103cc8 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103cc8:	55                   	push   %ebp
f0103cc9:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103ccb:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cce:	ba 70 00 00 00       	mov    $0x70,%edx
f0103cd3:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103cd4:	ba 71 00 00 00       	mov    $0x71,%edx
f0103cd9:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103cda:	0f b6 c0             	movzbl %al,%eax
}
f0103cdd:	5d                   	pop    %ebp
f0103cde:	c3                   	ret    

f0103cdf <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103cdf:	55                   	push   %ebp
f0103ce0:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103ce2:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ce5:	ba 70 00 00 00       	mov    $0x70,%edx
f0103cea:	ee                   	out    %al,(%dx)
f0103ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103cee:	ba 71 00 00 00       	mov    $0x71,%edx
f0103cf3:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103cf4:	5d                   	pop    %ebp
f0103cf5:	c3                   	ret    

f0103cf6 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103cf6:	55                   	push   %ebp
f0103cf7:	89 e5                	mov    %esp,%ebp
f0103cf9:	56                   	push   %esi
f0103cfa:	53                   	push   %ebx
f0103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103cfe:	66 a3 a8 73 12 f0    	mov    %ax,0xf01273a8
	if (!didinit)
f0103d04:	80 3d 4c a2 57 f0 00 	cmpb   $0x0,0xf057a24c
f0103d0b:	75 07                	jne    f0103d14 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103d0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103d10:	5b                   	pop    %ebx
f0103d11:	5e                   	pop    %esi
f0103d12:	5d                   	pop    %ebp
f0103d13:	c3                   	ret    
f0103d14:	89 c6                	mov    %eax,%esi
f0103d16:	ba 21 00 00 00       	mov    $0x21,%edx
f0103d1b:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103d1c:	66 c1 e8 08          	shr    $0x8,%ax
f0103d20:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103d25:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103d26:	83 ec 0c             	sub    $0xc,%esp
f0103d29:	68 47 8e 10 f0       	push   $0xf0108e47
f0103d2e:	e8 3c 01 00 00       	call   f0103e6f <cprintf>
f0103d33:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103d36:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103d3b:	0f b7 f6             	movzwl %si,%esi
f0103d3e:	f7 d6                	not    %esi
f0103d40:	eb 19                	jmp    f0103d5b <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f0103d42:	83 ec 08             	sub    $0x8,%esp
f0103d45:	53                   	push   %ebx
f0103d46:	68 6f 95 10 f0       	push   $0xf010956f
f0103d4b:	e8 1f 01 00 00       	call   f0103e6f <cprintf>
f0103d50:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103d53:	83 c3 01             	add    $0x1,%ebx
f0103d56:	83 fb 10             	cmp    $0x10,%ebx
f0103d59:	74 07                	je     f0103d62 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103d5b:	0f a3 de             	bt     %ebx,%esi
f0103d5e:	73 f3                	jae    f0103d53 <irq_setmask_8259A+0x5d>
f0103d60:	eb e0                	jmp    f0103d42 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103d62:	83 ec 0c             	sub    $0xc,%esp
f0103d65:	68 5b 8d 10 f0       	push   $0xf0108d5b
f0103d6a:	e8 00 01 00 00       	call   f0103e6f <cprintf>
f0103d6f:	83 c4 10             	add    $0x10,%esp
f0103d72:	eb 99                	jmp    f0103d0d <irq_setmask_8259A+0x17>

f0103d74 <pic_init>:
{
f0103d74:	55                   	push   %ebp
f0103d75:	89 e5                	mov    %esp,%ebp
f0103d77:	57                   	push   %edi
f0103d78:	56                   	push   %esi
f0103d79:	53                   	push   %ebx
f0103d7a:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103d7d:	c6 05 4c a2 57 f0 01 	movb   $0x1,0xf057a24c
f0103d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103d89:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103d8e:	89 da                	mov    %ebx,%edx
f0103d90:	ee                   	out    %al,(%dx)
f0103d91:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103d96:	89 ca                	mov    %ecx,%edx
f0103d98:	ee                   	out    %al,(%dx)
f0103d99:	bf 11 00 00 00       	mov    $0x11,%edi
f0103d9e:	be 20 00 00 00       	mov    $0x20,%esi
f0103da3:	89 f8                	mov    %edi,%eax
f0103da5:	89 f2                	mov    %esi,%edx
f0103da7:	ee                   	out    %al,(%dx)
f0103da8:	b8 20 00 00 00       	mov    $0x20,%eax
f0103dad:	89 da                	mov    %ebx,%edx
f0103daf:	ee                   	out    %al,(%dx)
f0103db0:	b8 04 00 00 00       	mov    $0x4,%eax
f0103db5:	ee                   	out    %al,(%dx)
f0103db6:	b8 03 00 00 00       	mov    $0x3,%eax
f0103dbb:	ee                   	out    %al,(%dx)
f0103dbc:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103dc1:	89 f8                	mov    %edi,%eax
f0103dc3:	89 da                	mov    %ebx,%edx
f0103dc5:	ee                   	out    %al,(%dx)
f0103dc6:	b8 28 00 00 00       	mov    $0x28,%eax
f0103dcb:	89 ca                	mov    %ecx,%edx
f0103dcd:	ee                   	out    %al,(%dx)
f0103dce:	b8 02 00 00 00       	mov    $0x2,%eax
f0103dd3:	ee                   	out    %al,(%dx)
f0103dd4:	b8 01 00 00 00       	mov    $0x1,%eax
f0103dd9:	ee                   	out    %al,(%dx)
f0103dda:	bf 68 00 00 00       	mov    $0x68,%edi
f0103ddf:	89 f8                	mov    %edi,%eax
f0103de1:	89 f2                	mov    %esi,%edx
f0103de3:	ee                   	out    %al,(%dx)
f0103de4:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103de9:	89 c8                	mov    %ecx,%eax
f0103deb:	ee                   	out    %al,(%dx)
f0103dec:	89 f8                	mov    %edi,%eax
f0103dee:	89 da                	mov    %ebx,%edx
f0103df0:	ee                   	out    %al,(%dx)
f0103df1:	89 c8                	mov    %ecx,%eax
f0103df3:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103df4:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f0103dfb:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103dff:	75 08                	jne    f0103e09 <pic_init+0x95>
}
f0103e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103e04:	5b                   	pop    %ebx
f0103e05:	5e                   	pop    %esi
f0103e06:	5f                   	pop    %edi
f0103e07:	5d                   	pop    %ebp
f0103e08:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103e09:	83 ec 0c             	sub    $0xc,%esp
f0103e0c:	0f b7 c0             	movzwl %ax,%eax
f0103e0f:	50                   	push   %eax
f0103e10:	e8 e1 fe ff ff       	call   f0103cf6 <irq_setmask_8259A>
f0103e15:	83 c4 10             	add    $0x10,%esp
}
f0103e18:	eb e7                	jmp    f0103e01 <pic_init+0x8d>

f0103e1a <irq_eoi>:
f0103e1a:	b8 20 00 00 00       	mov    $0x20,%eax
f0103e1f:	ba 20 00 00 00       	mov    $0x20,%edx
f0103e24:	ee                   	out    %al,(%dx)
f0103e25:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103e2a:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103e2b:	c3                   	ret    

f0103e2c <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103e2c:	55                   	push   %ebp
f0103e2d:	89 e5                	mov    %esp,%ebp
f0103e2f:	53                   	push   %ebx
f0103e30:	83 ec 10             	sub    $0x10,%esp
f0103e33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0103e36:	ff 75 08             	pushl  0x8(%ebp)
f0103e39:	e8 8a c9 ff ff       	call   f01007c8 <cputchar>
	(*cnt)++;
f0103e3e:	83 03 01             	addl   $0x1,(%ebx)
}
f0103e41:	83 c4 10             	add    $0x10,%esp
f0103e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103e47:	c9                   	leave  
f0103e48:	c3                   	ret    

f0103e49 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103e49:	55                   	push   %ebp
f0103e4a:	89 e5                	mov    %esp,%ebp
f0103e4c:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103e4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103e56:	ff 75 0c             	pushl  0xc(%ebp)
f0103e59:	ff 75 08             	pushl  0x8(%ebp)
f0103e5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103e5f:	50                   	push   %eax
f0103e60:	68 2c 3e 10 f0       	push   $0xf0103e2c
f0103e65:	e8 e3 1d 00 00       	call   f0105c4d <vprintfmt>
	return cnt;
}
f0103e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103e6d:	c9                   	leave  
f0103e6e:	c3                   	ret    

f0103e6f <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103e6f:	55                   	push   %ebp
f0103e70:	89 e5                	mov    %esp,%ebp
f0103e72:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103e75:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103e78:	50                   	push   %eax
f0103e79:	ff 75 08             	pushl  0x8(%ebp)
f0103e7c:	e8 c8 ff ff ff       	call   f0103e49 <vcprintf>
	va_end(ap);
	return cnt;
}
f0103e81:	c9                   	leave  
f0103e82:	c3                   	ret    

f0103e83 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103e83:	55                   	push   %ebp
f0103e84:	89 e5                	mov    %esp,%ebp
f0103e86:	57                   	push   %edi
f0103e87:	56                   	push   %esi
f0103e88:	53                   	push   %ebx
f0103e89:	83 ec 1c             	sub    $0x1c,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int i = cpunum();
f0103e8c:	e8 29 2c 00 00       	call   f0106aba <cpunum>
f0103e91:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0103e93:	e8 22 2c 00 00       	call   f0106aba <cpunum>
f0103e98:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e9b:	89 d9                	mov    %ebx,%ecx
f0103e9d:	c1 e1 10             	shl    $0x10,%ecx
f0103ea0:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103ea5:	29 ca                	sub    %ecx,%edx
f0103ea7:	89 90 30 c0 57 f0    	mov    %edx,-0xfa83fd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f0103ead:	e8 08 2c 00 00       	call   f0106aba <cpunum>
f0103eb2:	6b c0 74             	imul   $0x74,%eax,%eax
f0103eb5:	66 c7 80 34 c0 57 f0 	movw   $0x10,-0xfa83fcc(%eax)
f0103ebc:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f0103ebe:	e8 f7 2b 00 00       	call   f0106aba <cpunum>
f0103ec3:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ec6:	66 c7 80 92 c0 57 f0 	movw   $0x68,-0xfa83f6e(%eax)
f0103ecd:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0103ecf:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103ed6:	89 fb                	mov    %edi,%ebx
f0103ed8:	c1 fb 03             	sar    $0x3,%ebx
f0103edb:	e8 da 2b 00 00       	call   f0106aba <cpunum>
f0103ee0:	89 c6                	mov    %eax,%esi
f0103ee2:	e8 d3 2b 00 00       	call   f0106aba <cpunum>
f0103ee7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103eea:	e8 cb 2b 00 00       	call   f0106aba <cpunum>
f0103eef:	66 c7 04 dd 40 73 12 	movw   $0x67,-0xfed8cc0(,%ebx,8)
f0103ef6:	f0 67 00 
f0103ef9:	6b f6 74             	imul   $0x74,%esi,%esi
f0103efc:	81 c6 2c c0 57 f0    	add    $0xf057c02c,%esi
f0103f02:	66 89 34 dd 42 73 12 	mov    %si,-0xfed8cbe(,%ebx,8)
f0103f09:	f0 
f0103f0a:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103f0e:	81 c2 2c c0 57 f0    	add    $0xf057c02c,%edx
f0103f14:	c1 ea 10             	shr    $0x10,%edx
f0103f17:	88 14 dd 44 73 12 f0 	mov    %dl,-0xfed8cbc(,%ebx,8)
f0103f1e:	c6 04 dd 46 73 12 f0 	movb   $0x40,-0xfed8cba(,%ebx,8)
f0103f25:	40 
f0103f26:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f29:	05 2c c0 57 f0       	add    $0xf057c02c,%eax
f0103f2e:	c1 e8 18             	shr    $0x18,%eax
f0103f31:	88 04 dd 47 73 12 f0 	mov    %al,-0xfed8cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f0103f38:	c6 04 dd 45 73 12 f0 	movb   $0x89,-0xfed8cbb(,%ebx,8)
f0103f3f:	89 
	asm volatile("ltr %0" : : "r" (sel));
f0103f40:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f0103f43:	b8 ac 73 12 f0       	mov    $0xf01273ac,%eax
f0103f48:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f0103f4b:	83 c4 1c             	add    $0x1c,%esp
f0103f4e:	5b                   	pop    %ebx
f0103f4f:	5e                   	pop    %esi
f0103f50:	5f                   	pop    %edi
f0103f51:	5d                   	pop    %ebp
f0103f52:	c3                   	ret    

f0103f53 <trap_init>:
{
f0103f53:	55                   	push   %ebp
f0103f54:	89 e5                	mov    %esp,%ebp
f0103f56:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f0103f59:	b8 24 4c 10 f0       	mov    $0xf0104c24,%eax
f0103f5e:	66 a3 60 a2 57 f0    	mov    %ax,0xf057a260
f0103f64:	66 c7 05 62 a2 57 f0 	movw   $0x8,0xf057a262
f0103f6b:	08 00 
f0103f6d:	c6 05 64 a2 57 f0 00 	movb   $0x0,0xf057a264
f0103f74:	c6 05 65 a2 57 f0 8e 	movb   $0x8e,0xf057a265
f0103f7b:	c1 e8 10             	shr    $0x10,%eax
f0103f7e:	66 a3 66 a2 57 f0    	mov    %ax,0xf057a266
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f0103f84:	b8 2e 4c 10 f0       	mov    $0xf0104c2e,%eax
f0103f89:	66 a3 68 a2 57 f0    	mov    %ax,0xf057a268
f0103f8f:	66 c7 05 6a a2 57 f0 	movw   $0x8,0xf057a26a
f0103f96:	08 00 
f0103f98:	c6 05 6c a2 57 f0 00 	movb   $0x0,0xf057a26c
f0103f9f:	c6 05 6d a2 57 f0 8e 	movb   $0x8e,0xf057a26d
f0103fa6:	c1 e8 10             	shr    $0x10,%eax
f0103fa9:	66 a3 6e a2 57 f0    	mov    %ax,0xf057a26e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0103faf:	b8 38 4c 10 f0       	mov    $0xf0104c38,%eax
f0103fb4:	66 a3 70 a2 57 f0    	mov    %ax,0xf057a270
f0103fba:	66 c7 05 72 a2 57 f0 	movw   $0x8,0xf057a272
f0103fc1:	08 00 
f0103fc3:	c6 05 74 a2 57 f0 00 	movb   $0x0,0xf057a274
f0103fca:	c6 05 75 a2 57 f0 8e 	movb   $0x8e,0xf057a275
f0103fd1:	c1 e8 10             	shr    $0x10,%eax
f0103fd4:	66 a3 76 a2 57 f0    	mov    %ax,0xf057a276
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f0103fda:	b8 42 4c 10 f0       	mov    $0xf0104c42,%eax
f0103fdf:	66 a3 78 a2 57 f0    	mov    %ax,0xf057a278
f0103fe5:	66 c7 05 7a a2 57 f0 	movw   $0x8,0xf057a27a
f0103fec:	08 00 
f0103fee:	c6 05 7c a2 57 f0 00 	movb   $0x0,0xf057a27c
f0103ff5:	c6 05 7d a2 57 f0 ee 	movb   $0xee,0xf057a27d
f0103ffc:	c1 e8 10             	shr    $0x10,%eax
f0103fff:	66 a3 7e a2 57 f0    	mov    %ax,0xf057a27e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f0104005:	b8 4c 4c 10 f0       	mov    $0xf0104c4c,%eax
f010400a:	66 a3 80 a2 57 f0    	mov    %ax,0xf057a280
f0104010:	66 c7 05 82 a2 57 f0 	movw   $0x8,0xf057a282
f0104017:	08 00 
f0104019:	c6 05 84 a2 57 f0 00 	movb   $0x0,0xf057a284
f0104020:	c6 05 85 a2 57 f0 ee 	movb   $0xee,0xf057a285
f0104027:	c1 e8 10             	shr    $0x10,%eax
f010402a:	66 a3 86 a2 57 f0    	mov    %ax,0xf057a286
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f0104030:	b8 56 4c 10 f0       	mov    $0xf0104c56,%eax
f0104035:	66 a3 88 a2 57 f0    	mov    %ax,0xf057a288
f010403b:	66 c7 05 8a a2 57 f0 	movw   $0x8,0xf057a28a
f0104042:	08 00 
f0104044:	c6 05 8c a2 57 f0 00 	movb   $0x0,0xf057a28c
f010404b:	c6 05 8d a2 57 f0 ee 	movb   $0xee,0xf057a28d
f0104052:	c1 e8 10             	shr    $0x10,%eax
f0104055:	66 a3 8e a2 57 f0    	mov    %ax,0xf057a28e
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f010405b:	b8 60 4c 10 f0       	mov    $0xf0104c60,%eax
f0104060:	66 a3 90 a2 57 f0    	mov    %ax,0xf057a290
f0104066:	66 c7 05 92 a2 57 f0 	movw   $0x8,0xf057a292
f010406d:	08 00 
f010406f:	c6 05 94 a2 57 f0 00 	movb   $0x0,0xf057a294
f0104076:	c6 05 95 a2 57 f0 8e 	movb   $0x8e,0xf057a295
f010407d:	c1 e8 10             	shr    $0x10,%eax
f0104080:	66 a3 96 a2 57 f0    	mov    %ax,0xf057a296
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f0104086:	b8 6a 4c 10 f0       	mov    $0xf0104c6a,%eax
f010408b:	66 a3 98 a2 57 f0    	mov    %ax,0xf057a298
f0104091:	66 c7 05 9a a2 57 f0 	movw   $0x8,0xf057a29a
f0104098:	08 00 
f010409a:	c6 05 9c a2 57 f0 00 	movb   $0x0,0xf057a29c
f01040a1:	c6 05 9d a2 57 f0 8e 	movb   $0x8e,0xf057a29d
f01040a8:	c1 e8 10             	shr    $0x10,%eax
f01040ab:	66 a3 9e a2 57 f0    	mov    %ax,0xf057a29e
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f01040b1:	b8 74 4c 10 f0       	mov    $0xf0104c74,%eax
f01040b6:	66 a3 a0 a2 57 f0    	mov    %ax,0xf057a2a0
f01040bc:	66 c7 05 a2 a2 57 f0 	movw   $0x8,0xf057a2a2
f01040c3:	08 00 
f01040c5:	c6 05 a4 a2 57 f0 00 	movb   $0x0,0xf057a2a4
f01040cc:	c6 05 a5 a2 57 f0 8e 	movb   $0x8e,0xf057a2a5
f01040d3:	c1 e8 10             	shr    $0x10,%eax
f01040d6:	66 a3 a6 a2 57 f0    	mov    %ax,0xf057a2a6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f01040dc:	b8 7c 4c 10 f0       	mov    $0xf0104c7c,%eax
f01040e1:	66 a3 b0 a2 57 f0    	mov    %ax,0xf057a2b0
f01040e7:	66 c7 05 b2 a2 57 f0 	movw   $0x8,0xf057a2b2
f01040ee:	08 00 
f01040f0:	c6 05 b4 a2 57 f0 00 	movb   $0x0,0xf057a2b4
f01040f7:	c6 05 b5 a2 57 f0 8e 	movb   $0x8e,0xf057a2b5
f01040fe:	c1 e8 10             	shr    $0x10,%eax
f0104101:	66 a3 b6 a2 57 f0    	mov    %ax,0xf057a2b6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f0104107:	b8 84 4c 10 f0       	mov    $0xf0104c84,%eax
f010410c:	66 a3 b8 a2 57 f0    	mov    %ax,0xf057a2b8
f0104112:	66 c7 05 ba a2 57 f0 	movw   $0x8,0xf057a2ba
f0104119:	08 00 
f010411b:	c6 05 bc a2 57 f0 00 	movb   $0x0,0xf057a2bc
f0104122:	c6 05 bd a2 57 f0 8e 	movb   $0x8e,0xf057a2bd
f0104129:	c1 e8 10             	shr    $0x10,%eax
f010412c:	66 a3 be a2 57 f0    	mov    %ax,0xf057a2be
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f0104132:	b8 8c 4c 10 f0       	mov    $0xf0104c8c,%eax
f0104137:	66 a3 c0 a2 57 f0    	mov    %ax,0xf057a2c0
f010413d:	66 c7 05 c2 a2 57 f0 	movw   $0x8,0xf057a2c2
f0104144:	08 00 
f0104146:	c6 05 c4 a2 57 f0 00 	movb   $0x0,0xf057a2c4
f010414d:	c6 05 c5 a2 57 f0 8e 	movb   $0x8e,0xf057a2c5
f0104154:	c1 e8 10             	shr    $0x10,%eax
f0104157:	66 a3 c6 a2 57 f0    	mov    %ax,0xf057a2c6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f010415d:	b8 94 4c 10 f0       	mov    $0xf0104c94,%eax
f0104162:	66 a3 c8 a2 57 f0    	mov    %ax,0xf057a2c8
f0104168:	66 c7 05 ca a2 57 f0 	movw   $0x8,0xf057a2ca
f010416f:	08 00 
f0104171:	c6 05 cc a2 57 f0 00 	movb   $0x0,0xf057a2cc
f0104178:	c6 05 cd a2 57 f0 8e 	movb   $0x8e,0xf057a2cd
f010417f:	c1 e8 10             	shr    $0x10,%eax
f0104182:	66 a3 ce a2 57 f0    	mov    %ax,0xf057a2ce
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f0104188:	b8 9c 4c 10 f0       	mov    $0xf0104c9c,%eax
f010418d:	66 a3 d0 a2 57 f0    	mov    %ax,0xf057a2d0
f0104193:	66 c7 05 d2 a2 57 f0 	movw   $0x8,0xf057a2d2
f010419a:	08 00 
f010419c:	c6 05 d4 a2 57 f0 00 	movb   $0x0,0xf057a2d4
f01041a3:	c6 05 d5 a2 57 f0 8e 	movb   $0x8e,0xf057a2d5
f01041aa:	c1 e8 10             	shr    $0x10,%eax
f01041ad:	66 a3 d6 a2 57 f0    	mov    %ax,0xf057a2d6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f01041b3:	b8 a4 4c 10 f0       	mov    $0xf0104ca4,%eax
f01041b8:	66 a3 e0 a2 57 f0    	mov    %ax,0xf057a2e0
f01041be:	66 c7 05 e2 a2 57 f0 	movw   $0x8,0xf057a2e2
f01041c5:	08 00 
f01041c7:	c6 05 e4 a2 57 f0 00 	movb   $0x0,0xf057a2e4
f01041ce:	c6 05 e5 a2 57 f0 8e 	movb   $0x8e,0xf057a2e5
f01041d5:	c1 e8 10             	shr    $0x10,%eax
f01041d8:	66 a3 e6 a2 57 f0    	mov    %ax,0xf057a2e6
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f01041de:	b8 aa 4c 10 f0       	mov    $0xf0104caa,%eax
f01041e3:	66 a3 e8 a2 57 f0    	mov    %ax,0xf057a2e8
f01041e9:	66 c7 05 ea a2 57 f0 	movw   $0x8,0xf057a2ea
f01041f0:	08 00 
f01041f2:	c6 05 ec a2 57 f0 00 	movb   $0x0,0xf057a2ec
f01041f9:	c6 05 ed a2 57 f0 8e 	movb   $0x8e,0xf057a2ed
f0104200:	c1 e8 10             	shr    $0x10,%eax
f0104203:	66 a3 ee a2 57 f0    	mov    %ax,0xf057a2ee
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f0104209:	b8 ae 4c 10 f0       	mov    $0xf0104cae,%eax
f010420e:	66 a3 f0 a2 57 f0    	mov    %ax,0xf057a2f0
f0104214:	66 c7 05 f2 a2 57 f0 	movw   $0x8,0xf057a2f2
f010421b:	08 00 
f010421d:	c6 05 f4 a2 57 f0 00 	movb   $0x0,0xf057a2f4
f0104224:	c6 05 f5 a2 57 f0 8e 	movb   $0x8e,0xf057a2f5
f010422b:	c1 e8 10             	shr    $0x10,%eax
f010422e:	66 a3 f6 a2 57 f0    	mov    %ax,0xf057a2f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f0104234:	b8 b4 4c 10 f0       	mov    $0xf0104cb4,%eax
f0104239:	66 a3 f8 a2 57 f0    	mov    %ax,0xf057a2f8
f010423f:	66 c7 05 fa a2 57 f0 	movw   $0x8,0xf057a2fa
f0104246:	08 00 
f0104248:	c6 05 fc a2 57 f0 00 	movb   $0x0,0xf057a2fc
f010424f:	c6 05 fd a2 57 f0 8e 	movb   $0x8e,0xf057a2fd
f0104256:	c1 e8 10             	shr    $0x10,%eax
f0104259:	66 a3 fe a2 57 f0    	mov    %ax,0xf057a2fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f010425f:	b8 ba 4c 10 f0       	mov    $0xf0104cba,%eax
f0104264:	66 a3 e0 a3 57 f0    	mov    %ax,0xf057a3e0
f010426a:	66 c7 05 e2 a3 57 f0 	movw   $0x8,0xf057a3e2
f0104271:	08 00 
f0104273:	c6 05 e4 a3 57 f0 00 	movb   $0x0,0xf057a3e4
f010427a:	c6 05 e5 a3 57 f0 ee 	movb   $0xee,0xf057a3e5
f0104281:	c1 e8 10             	shr    $0x10,%eax
f0104284:	66 a3 e6 a3 57 f0    	mov    %ax,0xf057a3e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f010428a:	b8 c0 4c 10 f0       	mov    $0xf0104cc0,%eax
f010428f:	66 a3 60 a3 57 f0    	mov    %ax,0xf057a360
f0104295:	66 c7 05 62 a3 57 f0 	movw   $0x8,0xf057a362
f010429c:	08 00 
f010429e:	c6 05 64 a3 57 f0 00 	movb   $0x0,0xf057a364
f01042a5:	c6 05 65 a3 57 f0 8e 	movb   $0x8e,0xf057a365
f01042ac:	c1 e8 10             	shr    $0x10,%eax
f01042af:	66 a3 66 a3 57 f0    	mov    %ax,0xf057a366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f01042b5:	b8 c6 4c 10 f0       	mov    $0xf0104cc6,%eax
f01042ba:	66 a3 68 a3 57 f0    	mov    %ax,0xf057a368
f01042c0:	66 c7 05 6a a3 57 f0 	movw   $0x8,0xf057a36a
f01042c7:	08 00 
f01042c9:	c6 05 6c a3 57 f0 00 	movb   $0x0,0xf057a36c
f01042d0:	c6 05 6d a3 57 f0 8e 	movb   $0x8e,0xf057a36d
f01042d7:	c1 e8 10             	shr    $0x10,%eax
f01042da:	66 a3 6e a3 57 f0    	mov    %ax,0xf057a36e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f01042e0:	b8 cc 4c 10 f0       	mov    $0xf0104ccc,%eax
f01042e5:	66 a3 70 a3 57 f0    	mov    %ax,0xf057a370
f01042eb:	66 c7 05 72 a3 57 f0 	movw   $0x8,0xf057a372
f01042f2:	08 00 
f01042f4:	c6 05 74 a3 57 f0 00 	movb   $0x0,0xf057a374
f01042fb:	c6 05 75 a3 57 f0 8e 	movb   $0x8e,0xf057a375
f0104302:	c1 e8 10             	shr    $0x10,%eax
f0104305:	66 a3 76 a3 57 f0    	mov    %ax,0xf057a376
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f010430b:	b8 d2 4c 10 f0       	mov    $0xf0104cd2,%eax
f0104310:	66 a3 78 a3 57 f0    	mov    %ax,0xf057a378
f0104316:	66 c7 05 7a a3 57 f0 	movw   $0x8,0xf057a37a
f010431d:	08 00 
f010431f:	c6 05 7c a3 57 f0 00 	movb   $0x0,0xf057a37c
f0104326:	c6 05 7d a3 57 f0 8e 	movb   $0x8e,0xf057a37d
f010432d:	c1 e8 10             	shr    $0x10,%eax
f0104330:	66 a3 7e a3 57 f0    	mov    %ax,0xf057a37e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f0104336:	b8 d8 4c 10 f0       	mov    $0xf0104cd8,%eax
f010433b:	66 a3 80 a3 57 f0    	mov    %ax,0xf057a380
f0104341:	66 c7 05 82 a3 57 f0 	movw   $0x8,0xf057a382
f0104348:	08 00 
f010434a:	c6 05 84 a3 57 f0 00 	movb   $0x0,0xf057a384
f0104351:	c6 05 85 a3 57 f0 8e 	movb   $0x8e,0xf057a385
f0104358:	c1 e8 10             	shr    $0x10,%eax
f010435b:	66 a3 86 a3 57 f0    	mov    %ax,0xf057a386
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f0104361:	b8 de 4c 10 f0       	mov    $0xf0104cde,%eax
f0104366:	66 a3 88 a3 57 f0    	mov    %ax,0xf057a388
f010436c:	66 c7 05 8a a3 57 f0 	movw   $0x8,0xf057a38a
f0104373:	08 00 
f0104375:	c6 05 8c a3 57 f0 00 	movb   $0x0,0xf057a38c
f010437c:	c6 05 8d a3 57 f0 8e 	movb   $0x8e,0xf057a38d
f0104383:	c1 e8 10             	shr    $0x10,%eax
f0104386:	66 a3 8e a3 57 f0    	mov    %ax,0xf057a38e
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f010438c:	b8 e4 4c 10 f0       	mov    $0xf0104ce4,%eax
f0104391:	66 a3 90 a3 57 f0    	mov    %ax,0xf057a390
f0104397:	66 c7 05 92 a3 57 f0 	movw   $0x8,0xf057a392
f010439e:	08 00 
f01043a0:	c6 05 94 a3 57 f0 00 	movb   $0x0,0xf057a394
f01043a7:	c6 05 95 a3 57 f0 8e 	movb   $0x8e,0xf057a395
f01043ae:	c1 e8 10             	shr    $0x10,%eax
f01043b1:	66 a3 96 a3 57 f0    	mov    %ax,0xf057a396
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f01043b7:	b8 ea 4c 10 f0       	mov    $0xf0104cea,%eax
f01043bc:	66 a3 98 a3 57 f0    	mov    %ax,0xf057a398
f01043c2:	66 c7 05 9a a3 57 f0 	movw   $0x8,0xf057a39a
f01043c9:	08 00 
f01043cb:	c6 05 9c a3 57 f0 00 	movb   $0x0,0xf057a39c
f01043d2:	c6 05 9d a3 57 f0 8e 	movb   $0x8e,0xf057a39d
f01043d9:	c1 e8 10             	shr    $0x10,%eax
f01043dc:	66 a3 9e a3 57 f0    	mov    %ax,0xf057a39e
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f01043e2:	b8 f0 4c 10 f0       	mov    $0xf0104cf0,%eax
f01043e7:	66 a3 a0 a3 57 f0    	mov    %ax,0xf057a3a0
f01043ed:	66 c7 05 a2 a3 57 f0 	movw   $0x8,0xf057a3a2
f01043f4:	08 00 
f01043f6:	c6 05 a4 a3 57 f0 00 	movb   $0x0,0xf057a3a4
f01043fd:	c6 05 a5 a3 57 f0 8e 	movb   $0x8e,0xf057a3a5
f0104404:	c1 e8 10             	shr    $0x10,%eax
f0104407:	66 a3 a6 a3 57 f0    	mov    %ax,0xf057a3a6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f010440d:	b8 f6 4c 10 f0       	mov    $0xf0104cf6,%eax
f0104412:	66 a3 a8 a3 57 f0    	mov    %ax,0xf057a3a8
f0104418:	66 c7 05 aa a3 57 f0 	movw   $0x8,0xf057a3aa
f010441f:	08 00 
f0104421:	c6 05 ac a3 57 f0 00 	movb   $0x0,0xf057a3ac
f0104428:	c6 05 ad a3 57 f0 8e 	movb   $0x8e,0xf057a3ad
f010442f:	c1 e8 10             	shr    $0x10,%eax
f0104432:	66 a3 ae a3 57 f0    	mov    %ax,0xf057a3ae
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f0104438:	b8 fc 4c 10 f0       	mov    $0xf0104cfc,%eax
f010443d:	66 a3 b0 a3 57 f0    	mov    %ax,0xf057a3b0
f0104443:	66 c7 05 b2 a3 57 f0 	movw   $0x8,0xf057a3b2
f010444a:	08 00 
f010444c:	c6 05 b4 a3 57 f0 00 	movb   $0x0,0xf057a3b4
f0104453:	c6 05 b5 a3 57 f0 8e 	movb   $0x8e,0xf057a3b5
f010445a:	c1 e8 10             	shr    $0x10,%eax
f010445d:	66 a3 b6 a3 57 f0    	mov    %ax,0xf057a3b6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f0104463:	b8 02 4d 10 f0       	mov    $0xf0104d02,%eax
f0104468:	66 a3 b8 a3 57 f0    	mov    %ax,0xf057a3b8
f010446e:	66 c7 05 ba a3 57 f0 	movw   $0x8,0xf057a3ba
f0104475:	08 00 
f0104477:	c6 05 bc a3 57 f0 00 	movb   $0x0,0xf057a3bc
f010447e:	c6 05 bd a3 57 f0 8e 	movb   $0x8e,0xf057a3bd
f0104485:	c1 e8 10             	shr    $0x10,%eax
f0104488:	66 a3 be a3 57 f0    	mov    %ax,0xf057a3be
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f010448e:	b8 08 4d 10 f0       	mov    $0xf0104d08,%eax
f0104493:	66 a3 c0 a3 57 f0    	mov    %ax,0xf057a3c0
f0104499:	66 c7 05 c2 a3 57 f0 	movw   $0x8,0xf057a3c2
f01044a0:	08 00 
f01044a2:	c6 05 c4 a3 57 f0 00 	movb   $0x0,0xf057a3c4
f01044a9:	c6 05 c5 a3 57 f0 8e 	movb   $0x8e,0xf057a3c5
f01044b0:	c1 e8 10             	shr    $0x10,%eax
f01044b3:	66 a3 c6 a3 57 f0    	mov    %ax,0xf057a3c6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f01044b9:	b8 0e 4d 10 f0       	mov    $0xf0104d0e,%eax
f01044be:	66 a3 c8 a3 57 f0    	mov    %ax,0xf057a3c8
f01044c4:	66 c7 05 ca a3 57 f0 	movw   $0x8,0xf057a3ca
f01044cb:	08 00 
f01044cd:	c6 05 cc a3 57 f0 00 	movb   $0x0,0xf057a3cc
f01044d4:	c6 05 cd a3 57 f0 8e 	movb   $0x8e,0xf057a3cd
f01044db:	c1 e8 10             	shr    $0x10,%eax
f01044de:	66 a3 ce a3 57 f0    	mov    %ax,0xf057a3ce
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f01044e4:	b8 14 4d 10 f0       	mov    $0xf0104d14,%eax
f01044e9:	66 a3 d0 a3 57 f0    	mov    %ax,0xf057a3d0
f01044ef:	66 c7 05 d2 a3 57 f0 	movw   $0x8,0xf057a3d2
f01044f6:	08 00 
f01044f8:	c6 05 d4 a3 57 f0 00 	movb   $0x0,0xf057a3d4
f01044ff:	c6 05 d5 a3 57 f0 8e 	movb   $0x8e,0xf057a3d5
f0104506:	c1 e8 10             	shr    $0x10,%eax
f0104509:	66 a3 d6 a3 57 f0    	mov    %ax,0xf057a3d6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f010450f:	b8 1a 4d 10 f0       	mov    $0xf0104d1a,%eax
f0104514:	66 a3 d8 a3 57 f0    	mov    %ax,0xf057a3d8
f010451a:	66 c7 05 da a3 57 f0 	movw   $0x8,0xf057a3da
f0104521:	08 00 
f0104523:	c6 05 dc a3 57 f0 00 	movb   $0x0,0xf057a3dc
f010452a:	c6 05 dd a3 57 f0 8e 	movb   $0x8e,0xf057a3dd
f0104531:	c1 e8 10             	shr    $0x10,%eax
f0104534:	66 a3 de a3 57 f0    	mov    %ax,0xf057a3de
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f010453a:	b8 20 4d 10 f0       	mov    $0xf0104d20,%eax
f010453f:	66 a3 f8 a3 57 f0    	mov    %ax,0xf057a3f8
f0104545:	66 c7 05 fa a3 57 f0 	movw   $0x8,0xf057a3fa
f010454c:	08 00 
f010454e:	c6 05 fc a3 57 f0 00 	movb   $0x0,0xf057a3fc
f0104555:	c6 05 fd a3 57 f0 8e 	movb   $0x8e,0xf057a3fd
f010455c:	c1 e8 10             	shr    $0x10,%eax
f010455f:	66 a3 fe a3 57 f0    	mov    %ax,0xf057a3fe
	trap_init_percpu();
f0104565:	e8 19 f9 ff ff       	call   f0103e83 <trap_init_percpu>
}
f010456a:	c9                   	leave  
f010456b:	c3                   	ret    

f010456c <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f010456c:	55                   	push   %ebp
f010456d:	89 e5                	mov    %esp,%ebp
f010456f:	53                   	push   %ebx
f0104570:	83 ec 0c             	sub    $0xc,%esp
f0104573:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104576:	ff 33                	pushl  (%ebx)
f0104578:	68 5b 8e 10 f0       	push   $0xf0108e5b
f010457d:	e8 ed f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104582:	83 c4 08             	add    $0x8,%esp
f0104585:	ff 73 04             	pushl  0x4(%ebx)
f0104588:	68 6a 8e 10 f0       	push   $0xf0108e6a
f010458d:	e8 dd f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104592:	83 c4 08             	add    $0x8,%esp
f0104595:	ff 73 08             	pushl  0x8(%ebx)
f0104598:	68 79 8e 10 f0       	push   $0xf0108e79
f010459d:	e8 cd f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01045a2:	83 c4 08             	add    $0x8,%esp
f01045a5:	ff 73 0c             	pushl  0xc(%ebx)
f01045a8:	68 88 8e 10 f0       	push   $0xf0108e88
f01045ad:	e8 bd f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01045b2:	83 c4 08             	add    $0x8,%esp
f01045b5:	ff 73 10             	pushl  0x10(%ebx)
f01045b8:	68 97 8e 10 f0       	push   $0xf0108e97
f01045bd:	e8 ad f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01045c2:	83 c4 08             	add    $0x8,%esp
f01045c5:	ff 73 14             	pushl  0x14(%ebx)
f01045c8:	68 a6 8e 10 f0       	push   $0xf0108ea6
f01045cd:	e8 9d f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01045d2:	83 c4 08             	add    $0x8,%esp
f01045d5:	ff 73 18             	pushl  0x18(%ebx)
f01045d8:	68 b5 8e 10 f0       	push   $0xf0108eb5
f01045dd:	e8 8d f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01045e2:	83 c4 08             	add    $0x8,%esp
f01045e5:	ff 73 1c             	pushl  0x1c(%ebx)
f01045e8:	68 c4 8e 10 f0       	push   $0xf0108ec4
f01045ed:	e8 7d f8 ff ff       	call   f0103e6f <cprintf>
}
f01045f2:	83 c4 10             	add    $0x10,%esp
f01045f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01045f8:	c9                   	leave  
f01045f9:	c3                   	ret    

f01045fa <print_trapframe>:
{
f01045fa:	55                   	push   %ebp
f01045fb:	89 e5                	mov    %esp,%ebp
f01045fd:	56                   	push   %esi
f01045fe:	53                   	push   %ebx
f01045ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104602:	e8 b3 24 00 00       	call   f0106aba <cpunum>
f0104607:	83 ec 04             	sub    $0x4,%esp
f010460a:	50                   	push   %eax
f010460b:	53                   	push   %ebx
f010460c:	68 28 8f 10 f0       	push   $0xf0108f28
f0104611:	e8 59 f8 ff ff       	call   f0103e6f <cprintf>
	print_regs(&tf->tf_regs);
f0104616:	89 1c 24             	mov    %ebx,(%esp)
f0104619:	e8 4e ff ff ff       	call   f010456c <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f010461e:	83 c4 08             	add    $0x8,%esp
f0104621:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104625:	50                   	push   %eax
f0104626:	68 46 8f 10 f0       	push   $0xf0108f46
f010462b:	e8 3f f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104630:	83 c4 08             	add    $0x8,%esp
f0104633:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104637:	50                   	push   %eax
f0104638:	68 59 8f 10 f0       	push   $0xf0108f59
f010463d:	e8 2d f8 ff ff       	call   f0103e6f <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104642:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104645:	83 c4 10             	add    $0x10,%esp
f0104648:	83 f8 13             	cmp    $0x13,%eax
f010464b:	0f 86 e1 00 00 00    	jbe    f0104732 <print_trapframe+0x138>
		return "System call";
f0104651:	ba d3 8e 10 f0       	mov    $0xf0108ed3,%edx
	if (trapno == T_SYSCALL)
f0104656:	83 f8 30             	cmp    $0x30,%eax
f0104659:	74 13                	je     f010466e <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f010465b:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f010465e:	83 fa 0f             	cmp    $0xf,%edx
f0104661:	ba df 8e 10 f0       	mov    $0xf0108edf,%edx
f0104666:	b9 ee 8e 10 f0       	mov    $0xf0108eee,%ecx
f010466b:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010466e:	83 ec 04             	sub    $0x4,%esp
f0104671:	52                   	push   %edx
f0104672:	50                   	push   %eax
f0104673:	68 6c 8f 10 f0       	push   $0xf0108f6c
f0104678:	e8 f2 f7 ff ff       	call   f0103e6f <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010467d:	83 c4 10             	add    $0x10,%esp
f0104680:	39 1d 60 aa 57 f0    	cmp    %ebx,0xf057aa60
f0104686:	0f 84 b2 00 00 00    	je     f010473e <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f010468c:	83 ec 08             	sub    $0x8,%esp
f010468f:	ff 73 2c             	pushl  0x2c(%ebx)
f0104692:	68 8d 8f 10 f0       	push   $0xf0108f8d
f0104697:	e8 d3 f7 ff ff       	call   f0103e6f <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f010469c:	83 c4 10             	add    $0x10,%esp
f010469f:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01046a3:	0f 85 b8 00 00 00    	jne    f0104761 <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f01046a9:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f01046ac:	89 c2                	mov    %eax,%edx
f01046ae:	83 e2 01             	and    $0x1,%edx
f01046b1:	b9 01 8f 10 f0       	mov    $0xf0108f01,%ecx
f01046b6:	ba 0c 8f 10 f0       	mov    $0xf0108f0c,%edx
f01046bb:	0f 44 ca             	cmove  %edx,%ecx
f01046be:	89 c2                	mov    %eax,%edx
f01046c0:	83 e2 02             	and    $0x2,%edx
f01046c3:	be 18 8f 10 f0       	mov    $0xf0108f18,%esi
f01046c8:	ba 1e 8f 10 f0       	mov    $0xf0108f1e,%edx
f01046cd:	0f 45 d6             	cmovne %esi,%edx
f01046d0:	83 e0 04             	and    $0x4,%eax
f01046d3:	b8 23 8f 10 f0       	mov    $0xf0108f23,%eax
f01046d8:	be 70 91 10 f0       	mov    $0xf0109170,%esi
f01046dd:	0f 44 c6             	cmove  %esi,%eax
f01046e0:	51                   	push   %ecx
f01046e1:	52                   	push   %edx
f01046e2:	50                   	push   %eax
f01046e3:	68 9b 8f 10 f0       	push   $0xf0108f9b
f01046e8:	e8 82 f7 ff ff       	call   f0103e6f <cprintf>
f01046ed:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01046f0:	83 ec 08             	sub    $0x8,%esp
f01046f3:	ff 73 30             	pushl  0x30(%ebx)
f01046f6:	68 aa 8f 10 f0       	push   $0xf0108faa
f01046fb:	e8 6f f7 ff ff       	call   f0103e6f <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104700:	83 c4 08             	add    $0x8,%esp
f0104703:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104707:	50                   	push   %eax
f0104708:	68 b9 8f 10 f0       	push   $0xf0108fb9
f010470d:	e8 5d f7 ff ff       	call   f0103e6f <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104712:	83 c4 08             	add    $0x8,%esp
f0104715:	ff 73 38             	pushl  0x38(%ebx)
f0104718:	68 cc 8f 10 f0       	push   $0xf0108fcc
f010471d:	e8 4d f7 ff ff       	call   f0103e6f <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104722:	83 c4 10             	add    $0x10,%esp
f0104725:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104729:	75 4b                	jne    f0104776 <print_trapframe+0x17c>
}
f010472b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010472e:	5b                   	pop    %ebx
f010472f:	5e                   	pop    %esi
f0104730:	5d                   	pop    %ebp
f0104731:	c3                   	ret    
		return excnames[trapno];
f0104732:	8b 14 85 c0 93 10 f0 	mov    -0xfef6c40(,%eax,4),%edx
f0104739:	e9 30 ff ff ff       	jmp    f010466e <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010473e:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104742:	0f 85 44 ff ff ff    	jne    f010468c <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104748:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010474b:	83 ec 08             	sub    $0x8,%esp
f010474e:	50                   	push   %eax
f010474f:	68 7e 8f 10 f0       	push   $0xf0108f7e
f0104754:	e8 16 f7 ff ff       	call   f0103e6f <cprintf>
f0104759:	83 c4 10             	add    $0x10,%esp
f010475c:	e9 2b ff ff ff       	jmp    f010468c <print_trapframe+0x92>
		cprintf("\n");
f0104761:	83 ec 0c             	sub    $0xc,%esp
f0104764:	68 5b 8d 10 f0       	push   $0xf0108d5b
f0104769:	e8 01 f7 ff ff       	call   f0103e6f <cprintf>
f010476e:	83 c4 10             	add    $0x10,%esp
f0104771:	e9 7a ff ff ff       	jmp    f01046f0 <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104776:	83 ec 08             	sub    $0x8,%esp
f0104779:	ff 73 3c             	pushl  0x3c(%ebx)
f010477c:	68 db 8f 10 f0       	push   $0xf0108fdb
f0104781:	e8 e9 f6 ff ff       	call   f0103e6f <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104786:	83 c4 08             	add    $0x8,%esp
f0104789:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f010478d:	50                   	push   %eax
f010478e:	68 ea 8f 10 f0       	push   $0xf0108fea
f0104793:	e8 d7 f6 ff ff       	call   f0103e6f <cprintf>
f0104798:	83 c4 10             	add    $0x10,%esp
}
f010479b:	eb 8e                	jmp    f010472b <print_trapframe+0x131>

f010479d <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f010479d:	55                   	push   %ebp
f010479e:	89 e5                	mov    %esp,%ebp
f01047a0:	57                   	push   %edi
f01047a1:	56                   	push   %esi
f01047a2:	53                   	push   %ebx
f01047a3:	83 ec 0c             	sub    $0xc,%esp
f01047a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01047a9:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f01047ac:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01047b0:	83 e0 03             	and    $0x3,%eax
f01047b3:	66 83 f8 03          	cmp    $0x3,%ax
f01047b7:	75 5d                	jne    f0104816 <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f01047b9:	e8 fc 22 00 00       	call   f0106aba <cpunum>
f01047be:	6b c0 74             	imul   $0x74,%eax,%eax
f01047c1:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01047c7:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f01047cb:	75 69                	jne    f0104836 <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01047cd:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f01047d0:	e8 e5 22 00 00       	call   f0106aba <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01047d5:	57                   	push   %edi
f01047d6:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f01047d7:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01047da:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01047e0:	ff 70 48             	pushl  0x48(%eax)
f01047e3:	68 bc 92 10 f0       	push   $0xf01092bc
f01047e8:	e8 82 f6 ff ff       	call   f0103e6f <cprintf>
	print_trapframe(tf);
f01047ed:	89 1c 24             	mov    %ebx,(%esp)
f01047f0:	e8 05 fe ff ff       	call   f01045fa <print_trapframe>
	env_destroy(curenv);
f01047f5:	e8 c0 22 00 00       	call   f0106aba <cpunum>
f01047fa:	83 c4 04             	add    $0x4,%esp
f01047fd:	6b c0 74             	imul   $0x74,%eax,%eax
f0104800:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104806:	e8 fd f2 ff ff       	call   f0103b08 <env_destroy>
}
f010480b:	83 c4 10             	add    $0x10,%esp
f010480e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104811:	5b                   	pop    %ebx
f0104812:	5e                   	pop    %esi
f0104813:	5f                   	pop    %edi
f0104814:	5d                   	pop    %ebp
f0104815:	c3                   	ret    
		print_trapframe(tf);//just test
f0104816:	83 ec 0c             	sub    $0xc,%esp
f0104819:	53                   	push   %ebx
f010481a:	e8 db fd ff ff       	call   f01045fa <print_trapframe>
		panic("panic at kernel page_fault\n");
f010481f:	83 c4 0c             	add    $0xc,%esp
f0104822:	68 fd 8f 10 f0       	push   $0xf0108ffd
f0104827:	68 c1 01 00 00       	push   $0x1c1
f010482c:	68 19 90 10 f0       	push   $0xf0109019
f0104831:	e8 13 b8 ff ff       	call   f0100049 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104836:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0104839:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f010483e:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));		
f0104840:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104845:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f010484a:	77 05                	ja     f0104851 <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f010484c:	8d 42 c8             	lea    -0x38(%edx),%eax
f010484f:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f0104851:	e8 64 22 00 00       	call   f0106aba <cpunum>
f0104856:	6a 02                	push   $0x2
f0104858:	6a 34                	push   $0x34
f010485a:	57                   	push   %edi
f010485b:	6b c0 74             	imul   $0x74,%eax,%eax
f010485e:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104864:	e8 02 ec ff ff       	call   f010346b <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0104869:	89 fa                	mov    %edi,%edx
f010486b:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f010486d:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104870:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0104873:	8d 7f 08             	lea    0x8(%edi),%edi
f0104876:	b9 08 00 00 00       	mov    $0x8,%ecx
f010487b:	89 de                	mov    %ebx,%esi
f010487d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f010487f:	8b 43 30             	mov    0x30(%ebx),%eax
f0104882:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0104885:	8b 43 38             	mov    0x38(%ebx),%eax
f0104888:	89 d7                	mov    %edx,%edi
f010488a:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f010488d:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104890:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0104893:	e8 22 22 00 00       	call   f0106aba <cpunum>
f0104898:	6b c0 74             	imul   $0x74,%eax,%eax
f010489b:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01048a1:	8b 58 64             	mov    0x64(%eax),%ebx
f01048a4:	e8 11 22 00 00       	call   f0106aba <cpunum>
f01048a9:	6b c0 74             	imul   $0x74,%eax,%eax
f01048ac:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01048b2:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f01048b5:	e8 00 22 00 00       	call   f0106aba <cpunum>
f01048ba:	6b c0 74             	imul   $0x74,%eax,%eax
f01048bd:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01048c3:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f01048c6:	e8 ef 21 00 00       	call   f0106aba <cpunum>
f01048cb:	83 c4 04             	add    $0x4,%esp
f01048ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01048d1:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f01048d7:	e8 cb f2 ff ff       	call   f0103ba7 <env_run>

f01048dc <trap>:
{
f01048dc:	55                   	push   %ebp
f01048dd:	89 e5                	mov    %esp,%ebp
f01048df:	57                   	push   %edi
f01048e0:	56                   	push   %esi
f01048e1:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f01048e4:	fc                   	cld    
	if (panicstr)
f01048e5:	83 3d a0 be 57 f0 00 	cmpl   $0x0,0xf057bea0
f01048ec:	74 01                	je     f01048ef <trap+0x13>
		asm volatile("hlt");
f01048ee:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01048ef:	e8 c6 21 00 00       	call   f0106aba <cpunum>
f01048f4:	6b d0 74             	imul   $0x74,%eax,%edx
f01048f7:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01048fa:	b8 01 00 00 00       	mov    $0x1,%eax
f01048ff:	f0 87 82 20 c0 57 f0 	lock xchg %eax,-0xfa83fe0(%edx)
f0104906:	83 f8 02             	cmp    $0x2,%eax
f0104909:	74 30                	je     f010493b <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010490b:	9c                   	pushf  
f010490c:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f010490d:	f6 c4 02             	test   $0x2,%ah
f0104910:	75 3b                	jne    f010494d <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0104912:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104916:	83 e0 03             	and    $0x3,%eax
f0104919:	66 83 f8 03          	cmp    $0x3,%ax
f010491d:	74 47                	je     f0104966 <trap+0x8a>
	last_tf = tf;
f010491f:	89 35 60 aa 57 f0    	mov    %esi,0xf057aa60
	switch (tf->tf_trapno)
f0104925:	8b 46 28             	mov    0x28(%esi),%eax
f0104928:	83 e8 03             	sub    $0x3,%eax
f010492b:	83 f8 30             	cmp    $0x30,%eax
f010492e:	0f 87 92 02 00 00    	ja     f0104bc6 <trap+0x2ea>
f0104934:	ff 24 85 e0 92 10 f0 	jmp    *-0xfef6d20(,%eax,4)
	spin_lock(&kernel_lock);
f010493b:	83 ec 0c             	sub    $0xc,%esp
f010493e:	68 c0 73 12 f0       	push   $0xf01273c0
f0104943:	e8 e2 23 00 00       	call   f0106d2a <spin_lock>
f0104948:	83 c4 10             	add    $0x10,%esp
f010494b:	eb be                	jmp    f010490b <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f010494d:	68 25 90 10 f0       	push   $0xf0109025
f0104952:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0104957:	68 8c 01 00 00       	push   $0x18c
f010495c:	68 19 90 10 f0       	push   $0xf0109019
f0104961:	e8 e3 b6 ff ff       	call   f0100049 <_panic>
f0104966:	83 ec 0c             	sub    $0xc,%esp
f0104969:	68 c0 73 12 f0       	push   $0xf01273c0
f010496e:	e8 b7 23 00 00       	call   f0106d2a <spin_lock>
		assert(curenv);
f0104973:	e8 42 21 00 00       	call   f0106aba <cpunum>
f0104978:	6b c0 74             	imul   $0x74,%eax,%eax
f010497b:	83 c4 10             	add    $0x10,%esp
f010497e:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0104985:	74 3e                	je     f01049c5 <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f0104987:	e8 2e 21 00 00       	call   f0106aba <cpunum>
f010498c:	6b c0 74             	imul   $0x74,%eax,%eax
f010498f:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104995:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104999:	74 43                	je     f01049de <trap+0x102>
		curenv->env_tf = *tf;
f010499b:	e8 1a 21 00 00       	call   f0106aba <cpunum>
f01049a0:	6b c0 74             	imul   $0x74,%eax,%eax
f01049a3:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01049a9:	b9 11 00 00 00       	mov    $0x11,%ecx
f01049ae:	89 c7                	mov    %eax,%edi
f01049b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01049b2:	e8 03 21 00 00       	call   f0106aba <cpunum>
f01049b7:	6b c0 74             	imul   $0x74,%eax,%eax
f01049ba:	8b b0 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%esi
f01049c0:	e9 5a ff ff ff       	jmp    f010491f <trap+0x43>
		assert(curenv);
f01049c5:	68 3e 90 10 f0       	push   $0xf010903e
f01049ca:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01049cf:	68 93 01 00 00       	push   $0x193
f01049d4:	68 19 90 10 f0       	push   $0xf0109019
f01049d9:	e8 6b b6 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f01049de:	e8 d7 20 00 00       	call   f0106aba <cpunum>
f01049e3:	83 ec 0c             	sub    $0xc,%esp
f01049e6:	6b c0 74             	imul   $0x74,%eax,%eax
f01049e9:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f01049ef:	e8 33 ef ff ff       	call   f0103927 <env_free>
			curenv = NULL;
f01049f4:	e8 c1 20 00 00       	call   f0106aba <cpunum>
f01049f9:	6b c0 74             	imul   $0x74,%eax,%eax
f01049fc:	c7 80 28 c0 57 f0 00 	movl   $0x0,-0xfa83fd8(%eax)
f0104a03:	00 00 00 
			sched_yield();
f0104a06:	e8 11 04 00 00       	call   f0104e1c <sched_yield>
			page_fault_handler(tf);
f0104a0b:	83 ec 0c             	sub    $0xc,%esp
f0104a0e:	56                   	push   %esi
f0104a0f:	e8 89 fd ff ff       	call   f010479d <page_fault_handler>
f0104a14:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104a17:	e8 9e 20 00 00       	call   f0106aba <cpunum>
f0104a1c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a1f:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0104a26:	74 18                	je     f0104a40 <trap+0x164>
f0104a28:	e8 8d 20 00 00       	call   f0106aba <cpunum>
f0104a2d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a30:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104a36:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104a3a:	0f 84 ce 01 00 00    	je     f0104c0e <trap+0x332>
		sched_yield();
f0104a40:	e8 d7 03 00 00       	call   f0104e1c <sched_yield>
			monitor(tf);
f0104a45:	83 ec 0c             	sub    $0xc,%esp
f0104a48:	56                   	push   %esi
f0104a49:	e8 12 c2 ff ff       	call   f0100c60 <monitor>
f0104a4e:	83 c4 10             	add    $0x10,%esp
f0104a51:	eb c4                	jmp    f0104a17 <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0104a53:	83 ec 08             	sub    $0x8,%esp
f0104a56:	ff 76 04             	pushl  0x4(%esi)
f0104a59:	ff 36                	pushl  (%esi)
f0104a5b:	ff 76 10             	pushl  0x10(%esi)
f0104a5e:	ff 76 18             	pushl  0x18(%esi)
f0104a61:	ff 76 14             	pushl  0x14(%esi)
f0104a64:	ff 76 1c             	pushl  0x1c(%esi)
f0104a67:	e8 74 04 00 00       	call   f0104ee0 <syscall>
f0104a6c:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104a6f:	83 c4 20             	add    $0x20,%esp
f0104a72:	eb a3                	jmp    f0104a17 <trap+0x13b>
			time_tick();
f0104a74:	e8 5e 2b 00 00       	call   f01075d7 <time_tick>
			lapic_eoi();
f0104a79:	e8 83 21 00 00       	call   f0106c01 <lapic_eoi>
			sched_yield();
f0104a7e:	e8 99 03 00 00       	call   f0104e1c <sched_yield>
			kbd_intr();
f0104a83:	e8 9f bb ff ff       	call   f0100627 <kbd_intr>
f0104a88:	eb 8d                	jmp    f0104a17 <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0104a8a:	83 ec 0c             	sub    $0xc,%esp
f0104a8d:	68 e0 90 10 f0       	push   $0xf01090e0
f0104a92:	e8 d8 f3 ff ff       	call   f0103e6f <cprintf>
f0104a97:	83 c4 10             	add    $0x10,%esp
f0104a9a:	e9 78 ff ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0104a9f:	83 ec 0c             	sub    $0xc,%esp
f0104aa2:	68 f7 90 10 f0       	push   $0xf01090f7
f0104aa7:	e8 c3 f3 ff ff       	call   f0103e6f <cprintf>
f0104aac:	83 c4 10             	add    $0x10,%esp
f0104aaf:	e9 63 ff ff ff       	jmp    f0104a17 <trap+0x13b>
			serial_intr();
f0104ab4:	e8 52 bb ff ff       	call   f010060b <serial_intr>
f0104ab9:	e9 59 ff ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0104abe:	83 ec 0c             	sub    $0xc,%esp
f0104ac1:	68 2a 91 10 f0       	push   $0xf010912a
f0104ac6:	e8 a4 f3 ff ff       	call   f0103e6f <cprintf>
f0104acb:	83 c4 10             	add    $0x10,%esp
f0104ace:	e9 44 ff ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0104ad3:	83 ec 0c             	sub    $0xc,%esp
f0104ad6:	68 45 90 10 f0       	push   $0xf0109045
f0104adb:	e8 8f f3 ff ff       	call   f0103e6f <cprintf>
f0104ae0:	83 c4 10             	add    $0x10,%esp
f0104ae3:	e9 2f ff ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("in Spurious\n");
f0104ae8:	83 ec 0c             	sub    $0xc,%esp
f0104aeb:	68 5b 90 10 f0       	push   $0xf010905b
f0104af0:	e8 7a f3 ff ff       	call   f0103e6f <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104af5:	c7 04 24 68 90 10 f0 	movl   $0xf0109068,(%esp)
f0104afc:	e8 6e f3 ff ff       	call   f0103e6f <cprintf>
f0104b01:	83 c4 10             	add    $0x10,%esp
f0104b04:	e9 0e ff ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104b09:	83 ec 0c             	sub    $0xc,%esp
f0104b0c:	68 85 90 10 f0       	push   $0xf0109085
f0104b11:	e8 59 f3 ff ff       	call   f0103e6f <cprintf>
f0104b16:	83 c4 10             	add    $0x10,%esp
f0104b19:	e9 f9 fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104b1e:	83 ec 0c             	sub    $0xc,%esp
f0104b21:	68 9b 90 10 f0       	push   $0xf010909b
f0104b26:	e8 44 f3 ff ff       	call   f0103e6f <cprintf>
f0104b2b:	83 c4 10             	add    $0x10,%esp
f0104b2e:	e9 e4 fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104b33:	83 ec 0c             	sub    $0xc,%esp
f0104b36:	68 b1 90 10 f0       	push   $0xf01090b1
f0104b3b:	e8 2f f3 ff ff       	call   f0103e6f <cprintf>
f0104b40:	83 c4 10             	add    $0x10,%esp
f0104b43:	e9 cf fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104b48:	83 ec 0c             	sub    $0xc,%esp
f0104b4b:	68 c8 90 10 f0       	push   $0xf01090c8
f0104b50:	e8 1a f3 ff ff       	call   f0103e6f <cprintf>
f0104b55:	83 c4 10             	add    $0x10,%esp
f0104b58:	e9 ba fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104b5d:	83 ec 0c             	sub    $0xc,%esp
f0104b60:	68 df 90 10 f0       	push   $0xf01090df
f0104b65:	e8 05 f3 ff ff       	call   f0103e6f <cprintf>
f0104b6a:	83 c4 10             	add    $0x10,%esp
f0104b6d:	e9 a5 fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104b72:	83 ec 0c             	sub    $0xc,%esp
f0104b75:	68 f6 90 10 f0       	push   $0xf01090f6
f0104b7a:	e8 f0 f2 ff ff       	call   f0103e6f <cprintf>
f0104b7f:	83 c4 10             	add    $0x10,%esp
f0104b82:	e9 90 fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104b87:	83 ec 0c             	sub    $0xc,%esp
f0104b8a:	68 0d 91 10 f0       	push   $0xf010910d
f0104b8f:	e8 db f2 ff ff       	call   f0103e6f <cprintf>
f0104b94:	83 c4 10             	add    $0x10,%esp
f0104b97:	e9 7b fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104b9c:	83 ec 0c             	sub    $0xc,%esp
f0104b9f:	68 29 91 10 f0       	push   $0xf0109129
f0104ba4:	e8 c6 f2 ff ff       	call   f0103e6f <cprintf>
f0104ba9:	83 c4 10             	add    $0x10,%esp
f0104bac:	e9 66 fe ff ff       	jmp    f0104a17 <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104bb1:	83 ec 0c             	sub    $0xc,%esp
f0104bb4:	68 40 91 10 f0       	push   $0xf0109140
f0104bb9:	e8 b1 f2 ff ff       	call   f0103e6f <cprintf>
f0104bbe:	83 c4 10             	add    $0x10,%esp
f0104bc1:	e9 51 fe ff ff       	jmp    f0104a17 <trap+0x13b>
			print_trapframe(tf);
f0104bc6:	83 ec 0c             	sub    $0xc,%esp
f0104bc9:	56                   	push   %esi
f0104bca:	e8 2b fa ff ff       	call   f01045fa <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104bcf:	83 c4 10             	add    $0x10,%esp
f0104bd2:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104bd7:	74 1e                	je     f0104bf7 <trap+0x31b>
				env_destroy(curenv);
f0104bd9:	e8 dc 1e 00 00       	call   f0106aba <cpunum>
f0104bde:	83 ec 0c             	sub    $0xc,%esp
f0104be1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104be4:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104bea:	e8 19 ef ff ff       	call   f0103b08 <env_destroy>
f0104bef:	83 c4 10             	add    $0x10,%esp
f0104bf2:	e9 20 fe ff ff       	jmp    f0104a17 <trap+0x13b>
				panic("unhandled trap in kernel");
f0104bf7:	83 ec 04             	sub    $0x4,%esp
f0104bfa:	68 5e 91 10 f0       	push   $0xf010915e
f0104bff:	68 6f 01 00 00       	push   $0x16f
f0104c04:	68 19 90 10 f0       	push   $0xf0109019
f0104c09:	e8 3b b4 ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f0104c0e:	e8 a7 1e 00 00       	call   f0106aba <cpunum>
f0104c13:	83 ec 0c             	sub    $0xc,%esp
f0104c16:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c19:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104c1f:	e8 83 ef ff ff       	call   f0103ba7 <env_run>

f0104c24 <DIVIDE_HANDLER>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(DIVIDE_HANDLER   , T_DIVIDE )
f0104c24:	6a 00                	push   $0x0
f0104c26:	6a 00                	push   $0x0
f0104c28:	e9 f9 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c2d:	90                   	nop

f0104c2e <DEBUG_HANDLER>:
	TRAPHANDLER_NOEC(DEBUG_HANDLER    , T_DEBUG  )
f0104c2e:	6a 00                	push   $0x0
f0104c30:	6a 01                	push   $0x1
f0104c32:	e9 ef 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c37:	90                   	nop

f0104c38 <NMI_HANDLER>:
	TRAPHANDLER_NOEC(NMI_HANDLER      , T_NMI    )
f0104c38:	6a 00                	push   $0x0
f0104c3a:	6a 02                	push   $0x2
f0104c3c:	e9 e5 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c41:	90                   	nop

f0104c42 <BRKPT_HANDLER>:
	TRAPHANDLER_NOEC(BRKPT_HANDLER    , T_BRKPT  )
f0104c42:	6a 00                	push   $0x0
f0104c44:	6a 03                	push   $0x3
f0104c46:	e9 db 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c4b:	90                   	nop

f0104c4c <OFLOW_HANDLER>:
	TRAPHANDLER_NOEC(OFLOW_HANDLER    , T_OFLOW  )
f0104c4c:	6a 00                	push   $0x0
f0104c4e:	6a 04                	push   $0x4
f0104c50:	e9 d1 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c55:	90                   	nop

f0104c56 <BOUND_HANDLER>:
	TRAPHANDLER_NOEC(BOUND_HANDLER    , T_BOUND  )
f0104c56:	6a 00                	push   $0x0
f0104c58:	6a 05                	push   $0x5
f0104c5a:	e9 c7 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c5f:	90                   	nop

f0104c60 <ILLOP_HANDLER>:
	TRAPHANDLER_NOEC(ILLOP_HANDLER    , T_ILLOP  )
f0104c60:	6a 00                	push   $0x0
f0104c62:	6a 06                	push   $0x6
f0104c64:	e9 bd 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c69:	90                   	nop

f0104c6a <DEVICE_HANDLER>:
	TRAPHANDLER_NOEC(DEVICE_HANDLER   , T_DEVICE )
f0104c6a:	6a 00                	push   $0x0
f0104c6c:	6a 07                	push   $0x7
f0104c6e:	e9 b3 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c73:	90                   	nop

f0104c74 <DBLFLT_HANDLER>:
	TRAPHANDLER(	 DBLFLT_HANDLER   , T_DBLFLT )
f0104c74:	6a 08                	push   $0x8
f0104c76:	e9 ab 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c7b:	90                   	nop

f0104c7c <TSS_HANDLER>:
	TRAPHANDLER(	 TSS_HANDLER      , T_TSS	 )
f0104c7c:	6a 0a                	push   $0xa
f0104c7e:	e9 a3 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c83:	90                   	nop

f0104c84 <SEGNP_HANDLER>:
	TRAPHANDLER(	 SEGNP_HANDLER    , T_SEGNP  )
f0104c84:	6a 0b                	push   $0xb
f0104c86:	e9 9b 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c8b:	90                   	nop

f0104c8c <STACK_HANDLER>:
	TRAPHANDLER(	 STACK_HANDLER    , T_STACK  )
f0104c8c:	6a 0c                	push   $0xc
f0104c8e:	e9 93 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c93:	90                   	nop

f0104c94 <GPFLT_HANDLER>:
	TRAPHANDLER(	 GPFLT_HANDLER    , T_GPFLT  )
f0104c94:	6a 0d                	push   $0xd
f0104c96:	e9 8b 00 00 00       	jmp    f0104d26 <_alltraps>
f0104c9b:	90                   	nop

f0104c9c <PGFLT_HANDLER>:
	TRAPHANDLER(	 PGFLT_HANDLER    , T_PGFLT  )
f0104c9c:	6a 0e                	push   $0xe
f0104c9e:	e9 83 00 00 00       	jmp    f0104d26 <_alltraps>
f0104ca3:	90                   	nop

f0104ca4 <FPERR_HANDLER>:
	TRAPHANDLER_NOEC(FPERR_HANDLER 	  , T_FPERR  )
f0104ca4:	6a 00                	push   $0x0
f0104ca6:	6a 10                	push   $0x10
f0104ca8:	eb 7c                	jmp    f0104d26 <_alltraps>

f0104caa <ALIGN_HANDLER>:
	TRAPHANDLER(	 ALIGN_HANDLER    , T_ALIGN  )
f0104caa:	6a 11                	push   $0x11
f0104cac:	eb 78                	jmp    f0104d26 <_alltraps>

f0104cae <MCHK_HANDLER>:
	TRAPHANDLER_NOEC(MCHK_HANDLER     , T_MCHK   )
f0104cae:	6a 00                	push   $0x0
f0104cb0:	6a 12                	push   $0x12
f0104cb2:	eb 72                	jmp    f0104d26 <_alltraps>

f0104cb4 <SIMDERR_HANDLER>:
	TRAPHANDLER_NOEC(SIMDERR_HANDLER  , T_SIMDERR)
f0104cb4:	6a 00                	push   $0x0
f0104cb6:	6a 13                	push   $0x13
f0104cb8:	eb 6c                	jmp    f0104d26 <_alltraps>

f0104cba <SYSCALL_HANDLER>:
	TRAPHANDLER_NOEC(SYSCALL_HANDLER  , T_SYSCALL) /* just test*/
f0104cba:	6a 00                	push   $0x0
f0104cbc:	6a 30                	push   $0x30
f0104cbe:	eb 66                	jmp    f0104d26 <_alltraps>

f0104cc0 <TIMER_HANDLER>:

	TRAPHANDLER_NOEC(TIMER_HANDLER	  , IRQ_OFFSET + IRQ_TIMER)
f0104cc0:	6a 00                	push   $0x0
f0104cc2:	6a 20                	push   $0x20
f0104cc4:	eb 60                	jmp    f0104d26 <_alltraps>

f0104cc6 <KBD_HANDLER>:
	TRAPHANDLER_NOEC(KBD_HANDLER	  , IRQ_OFFSET + IRQ_KBD)
f0104cc6:	6a 00                	push   $0x0
f0104cc8:	6a 21                	push   $0x21
f0104cca:	eb 5a                	jmp    f0104d26 <_alltraps>

f0104ccc <SECOND_HANDLER>:
	TRAPHANDLER_NOEC(SECOND_HANDLER	  , IRQ_OFFSET + 2)
f0104ccc:	6a 00                	push   $0x0
f0104cce:	6a 22                	push   $0x22
f0104cd0:	eb 54                	jmp    f0104d26 <_alltraps>

f0104cd2 <THIRD_HANDLER>:
	TRAPHANDLER_NOEC(THIRD_HANDLER	  , IRQ_OFFSET + 3)
f0104cd2:	6a 00                	push   $0x0
f0104cd4:	6a 23                	push   $0x23
f0104cd6:	eb 4e                	jmp    f0104d26 <_alltraps>

f0104cd8 <SERIAL_HANDLER>:
	TRAPHANDLER_NOEC(SERIAL_HANDLER	  , IRQ_OFFSET + IRQ_SERIAL)
f0104cd8:	6a 00                	push   $0x0
f0104cda:	6a 24                	push   $0x24
f0104cdc:	eb 48                	jmp    f0104d26 <_alltraps>

f0104cde <FIFTH_HANDLER>:
	TRAPHANDLER_NOEC(FIFTH_HANDLER	  , IRQ_OFFSET + 5)
f0104cde:	6a 00                	push   $0x0
f0104ce0:	6a 25                	push   $0x25
f0104ce2:	eb 42                	jmp    f0104d26 <_alltraps>

f0104ce4 <SIXTH_HANDLER>:
	TRAPHANDLER_NOEC(SIXTH_HANDLER	  , IRQ_OFFSET + 6)
f0104ce4:	6a 00                	push   $0x0
f0104ce6:	6a 26                	push   $0x26
f0104ce8:	eb 3c                	jmp    f0104d26 <_alltraps>

f0104cea <SPURIOUS_HANDLER>:
	TRAPHANDLER_NOEC(SPURIOUS_HANDLER , IRQ_OFFSET + IRQ_SPURIOUS)
f0104cea:	6a 00                	push   $0x0
f0104cec:	6a 27                	push   $0x27
f0104cee:	eb 36                	jmp    f0104d26 <_alltraps>

f0104cf0 <EIGHTH_HANDLER>:
	TRAPHANDLER_NOEC(EIGHTH_HANDLER	  , IRQ_OFFSET + 8)
f0104cf0:	6a 00                	push   $0x0
f0104cf2:	6a 28                	push   $0x28
f0104cf4:	eb 30                	jmp    f0104d26 <_alltraps>

f0104cf6 <NINTH_HANDLER>:
	TRAPHANDLER_NOEC(NINTH_HANDLER	  , IRQ_OFFSET + 9)
f0104cf6:	6a 00                	push   $0x0
f0104cf8:	6a 29                	push   $0x29
f0104cfa:	eb 2a                	jmp    f0104d26 <_alltraps>

f0104cfc <TENTH_HANDLER>:
	TRAPHANDLER_NOEC(TENTH_HANDLER	  , IRQ_OFFSET + 10)
f0104cfc:	6a 00                	push   $0x0
f0104cfe:	6a 2a                	push   $0x2a
f0104d00:	eb 24                	jmp    f0104d26 <_alltraps>

f0104d02 <ELEVEN_HANDLER>:
	TRAPHANDLER_NOEC(ELEVEN_HANDLER	  , IRQ_OFFSET + 11)
f0104d02:	6a 00                	push   $0x0
f0104d04:	6a 2b                	push   $0x2b
f0104d06:	eb 1e                	jmp    f0104d26 <_alltraps>

f0104d08 <TWELVE_HANDLER>:
	TRAPHANDLER_NOEC(TWELVE_HANDLER	  , IRQ_OFFSET + 12)
f0104d08:	6a 00                	push   $0x0
f0104d0a:	6a 2c                	push   $0x2c
f0104d0c:	eb 18                	jmp    f0104d26 <_alltraps>

f0104d0e <THIRTEEN_HANDLER>:
	TRAPHANDLER_NOEC(THIRTEEN_HANDLER , IRQ_OFFSET + 13)
f0104d0e:	6a 00                	push   $0x0
f0104d10:	6a 2d                	push   $0x2d
f0104d12:	eb 12                	jmp    f0104d26 <_alltraps>

f0104d14 <IDE_HANDLER>:
	TRAPHANDLER_NOEC(IDE_HANDLER	  , IRQ_OFFSET + IRQ_IDE)
f0104d14:	6a 00                	push   $0x0
f0104d16:	6a 2e                	push   $0x2e
f0104d18:	eb 0c                	jmp    f0104d26 <_alltraps>

f0104d1a <FIFTEEN_HANDLER>:
	TRAPHANDLER_NOEC(FIFTEEN_HANDLER  , IRQ_OFFSET + 15)
f0104d1a:	6a 00                	push   $0x0
f0104d1c:	6a 2f                	push   $0x2f
f0104d1e:	eb 06                	jmp    f0104d26 <_alltraps>

f0104d20 <ERROR_HANDLER>:
	TRAPHANDLER_NOEC(ERROR_HANDLER	  , IRQ_OFFSET + IRQ_ERROR)
f0104d20:	6a 00                	push   $0x0
f0104d22:	6a 33                	push   $0x33
f0104d24:	eb 00                	jmp    f0104d26 <_alltraps>

f0104d26 <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */

.globl _alltraps
_alltraps:
	pushw $0
f0104d26:	66 6a 00             	pushw  $0x0
	pushw %ds 
f0104d29:	66 1e                	pushw  %ds
	pushw $0
f0104d2b:	66 6a 00             	pushw  $0x0
	pushw %es 
f0104d2e:	66 06                	pushw  %es
	pushal
f0104d30:	60                   	pusha  

	movl $(GD_KD), %eax 
f0104d31:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds 
f0104d36:	8e d8                	mov    %eax,%ds
	movw %ax, %es 
f0104d38:	8e c0                	mov    %eax,%es

	pushl %esp 
f0104d3a:	54                   	push   %esp
	call trap
f0104d3b:	e8 9c fb ff ff       	call   f01048dc <trap>

f0104d40 <sysenter_handler>:

; .global sysenter_handler
; sysenter_handler:
; 	pushl %esi 
f0104d40:	56                   	push   %esi
; 	pushl %edi
f0104d41:	57                   	push   %edi
; 	pushl %ebx
f0104d42:	53                   	push   %ebx
; 	pushl %ecx 
f0104d43:	51                   	push   %ecx
; 	pushl %edx
f0104d44:	52                   	push   %edx
; 	pushl %eax
f0104d45:	50                   	push   %eax
; 	call syscall
f0104d46:	e8 95 01 00 00       	call   f0104ee0 <syscall>
; 	movl %esi, %edx
f0104d4b:	89 f2                	mov    %esi,%edx
; 	movl %ebp, %ecx 
f0104d4d:	89 e9                	mov    %ebp,%ecx
f0104d4f:	0f 35                	sysexit 

f0104d51 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104d51:	55                   	push   %ebp
f0104d52:	89 e5                	mov    %esp,%ebp
f0104d54:	83 ec 08             	sub    $0x8,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104d57:	8b 0d 44 a2 57 f0    	mov    0xf057a244,%ecx
	for (i = 0; i < NENV; i++) {
f0104d5d:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104d62:	89 c2                	mov    %eax,%edx
f0104d64:	c1 e2 07             	shl    $0x7,%edx
		     envs[i].env_status == ENV_RUNNING ||
f0104d67:	8b 54 11 54          	mov    0x54(%ecx,%edx,1),%edx
f0104d6b:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104d6e:	83 fa 02             	cmp    $0x2,%edx
f0104d71:	76 29                	jbe    f0104d9c <sched_halt+0x4b>
	for (i = 0; i < NENV; i++) {
f0104d73:	83 c0 01             	add    $0x1,%eax
f0104d76:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104d7b:	75 e5                	jne    f0104d62 <sched_halt+0x11>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104d7d:	83 ec 0c             	sub    $0xc,%esp
f0104d80:	68 10 94 10 f0       	push   $0xf0109410
f0104d85:	e8 e5 f0 ff ff       	call   f0103e6f <cprintf>
f0104d8a:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104d8d:	83 ec 0c             	sub    $0xc,%esp
f0104d90:	6a 00                	push   $0x0
f0104d92:	e8 c9 be ff ff       	call   f0100c60 <monitor>
f0104d97:	83 c4 10             	add    $0x10,%esp
f0104d9a:	eb f1                	jmp    f0104d8d <sched_halt+0x3c>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104d9c:	e8 19 1d 00 00       	call   f0106aba <cpunum>
f0104da1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104da4:	c7 80 28 c0 57 f0 00 	movl   $0x0,-0xfa83fd8(%eax)
f0104dab:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104dae:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f0104db3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104db8:	76 50                	jbe    f0104e0a <sched_halt+0xb9>
	return (physaddr_t)kva - KERNBASE;
f0104dba:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104dbf:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104dc2:	e8 f3 1c 00 00       	call   f0106aba <cpunum>
f0104dc7:	6b d0 74             	imul   $0x74,%eax,%edx
f0104dca:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104dcd:	b8 02 00 00 00       	mov    $0x2,%eax
f0104dd2:	f0 87 82 20 c0 57 f0 	lock xchg %eax,-0xfa83fe0(%edx)
	spin_unlock(&kernel_lock);
f0104dd9:	83 ec 0c             	sub    $0xc,%esp
f0104ddc:	68 c0 73 12 f0       	push   $0xf01273c0
f0104de1:	e8 e0 1f 00 00       	call   f0106dc6 <spin_unlock>
	asm volatile("pause");
f0104de6:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104de8:	e8 cd 1c 00 00       	call   f0106aba <cpunum>
f0104ded:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104df0:	8b 80 30 c0 57 f0    	mov    -0xfa83fd0(%eax),%eax
f0104df6:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104dfb:	89 c4                	mov    %eax,%esp
f0104dfd:	6a 00                	push   $0x0
f0104dff:	6a 00                	push   $0x0
f0104e01:	fb                   	sti    
f0104e02:	f4                   	hlt    
f0104e03:	eb fd                	jmp    f0104e02 <sched_halt+0xb1>
}
f0104e05:	83 c4 10             	add    $0x10,%esp
f0104e08:	c9                   	leave  
f0104e09:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104e0a:	50                   	push   %eax
f0104e0b:	68 d8 78 10 f0       	push   $0xf01078d8
f0104e10:	6a 4c                	push   $0x4c
f0104e12:	68 39 94 10 f0       	push   $0xf0109439
f0104e17:	e8 2d b2 ff ff       	call   f0100049 <_panic>

f0104e1c <sched_yield>:
{
f0104e1c:	55                   	push   %ebp
f0104e1d:	89 e5                	mov    %esp,%ebp
f0104e1f:	53                   	push   %ebx
f0104e20:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f0104e23:	e8 92 1c 00 00       	call   f0106aba <cpunum>
f0104e28:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e2b:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0104e32:	74 7d                	je     f0104eb1 <sched_yield+0x95>
		envid_t cur_tone = ENVX(curenv->env_id);
f0104e34:	e8 81 1c 00 00       	call   f0106aba <cpunum>
f0104e39:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e3c:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104e42:	8b 48 48             	mov    0x48(%eax),%ecx
f0104e45:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e4b:	8d 41 01             	lea    0x1(%ecx),%eax
f0104e4e:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104e53:	8b 1d 44 a2 57 f0    	mov    0xf057a244,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e59:	39 c8                	cmp    %ecx,%eax
f0104e5b:	74 20                	je     f0104e7d <sched_yield+0x61>
			if(envs[i].env_status == ENV_RUNNABLE){
f0104e5d:	89 c2                	mov    %eax,%edx
f0104e5f:	c1 e2 07             	shl    $0x7,%edx
f0104e62:	01 da                	add    %ebx,%edx
f0104e64:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0104e68:	74 0a                	je     f0104e74 <sched_yield+0x58>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e6a:	83 c0 01             	add    $0x1,%eax
f0104e6d:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104e72:	eb e5                	jmp    f0104e59 <sched_yield+0x3d>
				env_run(&envs[i]);
f0104e74:	83 ec 0c             	sub    $0xc,%esp
f0104e77:	52                   	push   %edx
f0104e78:	e8 2a ed ff ff       	call   f0103ba7 <env_run>
		if(curenv->env_status == ENV_RUNNING)
f0104e7d:	e8 38 1c 00 00       	call   f0106aba <cpunum>
f0104e82:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e85:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104e8b:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104e8f:	74 0a                	je     f0104e9b <sched_yield+0x7f>
	sched_halt();
f0104e91:	e8 bb fe ff ff       	call   f0104d51 <sched_halt>
}
f0104e96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104e99:	c9                   	leave  
f0104e9a:	c3                   	ret    
			env_run(curenv);
f0104e9b:	e8 1a 1c 00 00       	call   f0106aba <cpunum>
f0104ea0:	83 ec 0c             	sub    $0xc,%esp
f0104ea3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ea6:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104eac:	e8 f6 ec ff ff       	call   f0103ba7 <env_run>
f0104eb1:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
f0104eb6:	8d 90 00 00 02 00    	lea    0x20000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f0104ebc:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104ec0:	74 09                	je     f0104ecb <sched_yield+0xaf>
f0104ec2:	83 e8 80             	sub    $0xffffff80,%eax
		for(i = 0 ; i < NENV; i++)
f0104ec5:	39 d0                	cmp    %edx,%eax
f0104ec7:	75 f3                	jne    f0104ebc <sched_yield+0xa0>
f0104ec9:	eb c6                	jmp    f0104e91 <sched_yield+0x75>
		  		env_run(&envs[i]);
f0104ecb:	83 ec 0c             	sub    $0xc,%esp
f0104ece:	50                   	push   %eax
f0104ecf:	e8 d3 ec ff ff       	call   f0103ba7 <env_run>

f0104ed4 <sys_net_send>:
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_tx to send the packet
	// Hint: e1000_tx only accept kernel virtual address
	return -1;
}
f0104ed4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104ed9:	c3                   	ret    

f0104eda <sys_net_recv>:
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	return -1;
}
f0104eda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104edf:	c3                   	ret    

f0104ee0 <syscall>:
	return 0;
}
// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104ee0:	55                   	push   %ebp
f0104ee1:	89 e5                	mov    %esp,%ebp
f0104ee3:	57                   	push   %edi
f0104ee4:	56                   	push   %esi
f0104ee5:	53                   	push   %ebx
f0104ee6:	83 ec 1c             	sub    $0x1c,%esp
f0104ee9:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f0104eec:	83 f8 14             	cmp    $0x14,%eax
f0104eef:	0f 87 53 08 00 00    	ja     f0105748 <syscall+0x868>
f0104ef5:	ff 24 85 f4 94 10 f0 	jmp    *-0xfef6b0c(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f0104efc:	e8 b9 1b 00 00       	call   f0106aba <cpunum>
f0104f01:	6a 04                	push   $0x4
f0104f03:	ff 75 10             	pushl  0x10(%ebp)
f0104f06:	ff 75 0c             	pushl  0xc(%ebp)
f0104f09:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f0c:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104f12:	e8 54 e5 ff ff       	call   f010346b <user_mem_assert>
	cprintf("%.*s", len, s);
f0104f17:	83 c4 0c             	add    $0xc,%esp
f0104f1a:	ff 75 0c             	pushl  0xc(%ebp)
f0104f1d:	ff 75 10             	pushl  0x10(%ebp)
f0104f20:	68 46 94 10 f0       	push   $0xf0109446
f0104f25:	e8 45 ef ff ff       	call   f0103e6f <cprintf>
f0104f2a:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f0104f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f0104f32:	89 d8                	mov    %ebx,%eax
f0104f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104f37:	5b                   	pop    %ebx
f0104f38:	5e                   	pop    %esi
f0104f39:	5f                   	pop    %edi
f0104f3a:	5d                   	pop    %ebp
f0104f3b:	c3                   	ret    
	return cons_getc();
f0104f3c:	e8 f8 b6 ff ff       	call   f0100639 <cons_getc>
f0104f41:	89 c3                	mov    %eax,%ebx
			break;
f0104f43:	eb ed                	jmp    f0104f32 <syscall+0x52>
	return curenv->env_id;
f0104f45:	e8 70 1b 00 00       	call   f0106aba <cpunum>
f0104f4a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f4d:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104f53:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0104f56:	eb da                	jmp    f0104f32 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104f58:	83 ec 04             	sub    $0x4,%esp
f0104f5b:	6a 01                	push   $0x1
f0104f5d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104f60:	50                   	push   %eax
f0104f61:	ff 75 0c             	pushl  0xc(%ebp)
f0104f64:	e8 d4 e5 ff ff       	call   f010353d <envid2env>
f0104f69:	89 c3                	mov    %eax,%ebx
f0104f6b:	83 c4 10             	add    $0x10,%esp
f0104f6e:	85 c0                	test   %eax,%eax
f0104f70:	78 c0                	js     f0104f32 <syscall+0x52>
	if (e == curenv)
f0104f72:	e8 43 1b 00 00       	call   f0106aba <cpunum>
f0104f77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104f7a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f7d:	39 90 28 c0 57 f0    	cmp    %edx,-0xfa83fd8(%eax)
f0104f83:	74 3d                	je     f0104fc2 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0104f85:	8b 5a 48             	mov    0x48(%edx),%ebx
f0104f88:	e8 2d 1b 00 00       	call   f0106aba <cpunum>
f0104f8d:	83 ec 04             	sub    $0x4,%esp
f0104f90:	53                   	push   %ebx
f0104f91:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f94:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104f9a:	ff 70 48             	pushl  0x48(%eax)
f0104f9d:	68 66 94 10 f0       	push   $0xf0109466
f0104fa2:	e8 c8 ee ff ff       	call   f0103e6f <cprintf>
f0104fa7:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0104faa:	83 ec 0c             	sub    $0xc,%esp
f0104fad:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104fb0:	e8 53 eb ff ff       	call   f0103b08 <env_destroy>
f0104fb5:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104fb8:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0104fbd:	e9 70 ff ff ff       	jmp    f0104f32 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104fc2:	e8 f3 1a 00 00       	call   f0106aba <cpunum>
f0104fc7:	83 ec 08             	sub    $0x8,%esp
f0104fca:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fcd:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104fd3:	ff 70 48             	pushl  0x48(%eax)
f0104fd6:	68 4b 94 10 f0       	push   $0xf010944b
f0104fdb:	e8 8f ee ff ff       	call   f0103e6f <cprintf>
f0104fe0:	83 c4 10             	add    $0x10,%esp
f0104fe3:	eb c5                	jmp    f0104faa <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f0104fe5:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f0104fec:	76 4a                	jbe    f0105038 <syscall+0x158>
	return (physaddr_t)kva - KERNBASE;
f0104fee:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104ff1:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0104ff6:	c1 e8 0c             	shr    $0xc,%eax
f0104ff9:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f0104fff:	73 4e                	jae    f010504f <syscall+0x16f>
	return &pages[PGNUM(pa)];
f0105001:	8b 15 b0 be 57 f0    	mov    0xf057beb0,%edx
f0105007:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f010500a:	85 db                	test   %ebx,%ebx
f010500c:	0f 84 40 07 00 00    	je     f0105752 <syscall+0x872>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f0105012:	e8 a3 1a 00 00       	call   f0106aba <cpunum>
f0105017:	6a 06                	push   $0x6
f0105019:	ff 75 10             	pushl  0x10(%ebp)
f010501c:	53                   	push   %ebx
f010501d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105020:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105026:	ff 70 60             	pushl  0x60(%eax)
f0105029:	e8 e1 c5 ff ff       	call   f010160f <page_insert>
f010502e:	89 c3                	mov    %eax,%ebx
f0105030:	83 c4 10             	add    $0x10,%esp
f0105033:	e9 fa fe ff ff       	jmp    f0104f32 <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0105038:	ff 75 0c             	pushl  0xc(%ebp)
f010503b:	68 d8 78 10 f0       	push   $0xf01078d8
f0105040:	68 ad 01 00 00       	push   $0x1ad
f0105045:	68 7e 94 10 f0       	push   $0xf010947e
f010504a:	e8 fa af ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f010504f:	83 ec 04             	sub    $0x4,%esp
f0105052:	68 90 81 10 f0       	push   $0xf0108190
f0105057:	6a 51                	push   $0x51
f0105059:	68 51 8a 10 f0       	push   $0xf0108a51
f010505e:	e8 e6 af ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105063:	e8 52 1a 00 00       	call   f0106aba <cpunum>
	if(inc < PGSIZE){
f0105068:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f010506f:	77 1b                	ja     f010508c <syscall+0x1ac>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105071:	6b c0 74             	imul   $0x74,%eax,%eax
f0105074:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010507a:	8b 40 7c             	mov    0x7c(%eax),%eax
f010507d:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f0105082:	03 45 0c             	add    0xc(%ebp),%eax
f0105085:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f010508a:	76 7c                	jbe    f0105108 <syscall+0x228>
	int i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f010508c:	e8 29 1a 00 00       	call   f0106aba <cpunum>
f0105091:	6b c0 74             	imul   $0x74,%eax,%eax
f0105094:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010509a:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010509d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f01050a3:	e8 12 1a 00 00       	call   f0106aba <cpunum>
f01050a8:	6b c0 74             	imul   $0x74,%eax,%eax
f01050ab:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01050b1:	8b 40 7c             	mov    0x7c(%eax),%eax
f01050b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01050b7:	8d b4 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%esi
f01050be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01050c4:	39 de                	cmp    %ebx,%esi
f01050c6:	0f 8e 94 00 00 00    	jle    f0105160 <syscall+0x280>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01050cc:	83 ec 0c             	sub    $0xc,%esp
f01050cf:	6a 01                	push   $0x1
f01050d1:	e8 fd c1 ff ff       	call   f01012d3 <page_alloc>
f01050d6:	89 c7                	mov    %eax,%edi
		if(!page)
f01050d8:	83 c4 10             	add    $0x10,%esp
f01050db:	85 c0                	test   %eax,%eax
f01050dd:	74 53                	je     f0105132 <syscall+0x252>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f01050df:	e8 d6 19 00 00       	call   f0106aba <cpunum>
f01050e4:	6a 06                	push   $0x6
f01050e6:	53                   	push   %ebx
f01050e7:	57                   	push   %edi
f01050e8:	6b c0 74             	imul   $0x74,%eax,%eax
f01050eb:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01050f1:	ff 70 60             	pushl  0x60(%eax)
f01050f4:	e8 16 c5 ff ff       	call   f010160f <page_insert>
		if(ret)
f01050f9:	83 c4 10             	add    $0x10,%esp
f01050fc:	85 c0                	test   %eax,%eax
f01050fe:	75 49                	jne    f0105149 <syscall+0x269>
	for(; i < end; i+=PGSIZE){
f0105100:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0105106:	eb bc                	jmp    f01050c4 <syscall+0x1e4>
			curenv->env_sbrk+=inc;
f0105108:	e8 ad 19 00 00       	call   f0106aba <cpunum>
f010510d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105110:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105119:	01 48 7c             	add    %ecx,0x7c(%eax)
			return curenv->env_sbrk;
f010511c:	e8 99 19 00 00       	call   f0106aba <cpunum>
f0105121:	6b c0 74             	imul   $0x74,%eax,%eax
f0105124:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010512a:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010512d:	e9 00 fe ff ff       	jmp    f0104f32 <syscall+0x52>
			panic("there is no page\n");
f0105132:	83 ec 04             	sub    $0x4,%esp
f0105135:	68 b4 8d 10 f0       	push   $0xf0108db4
f010513a:	68 c2 01 00 00       	push   $0x1c2
f010513f:	68 7e 94 10 f0       	push   $0xf010947e
f0105144:	e8 00 af ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f0105149:	83 ec 04             	sub    $0x4,%esp
f010514c:	68 d1 8d 10 f0       	push   $0xf0108dd1
f0105151:	68 c5 01 00 00       	push   $0x1c5
f0105156:	68 7e 94 10 f0       	push   $0xf010947e
f010515b:	e8 e9 ae ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f0105160:	e8 55 19 00 00       	call   f0106aba <cpunum>
f0105165:	6b c0 74             	imul   $0x74,%eax,%eax
f0105168:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010516e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105171:	01 48 7c             	add    %ecx,0x7c(%eax)
	return curenv->env_sbrk;
f0105174:	e8 41 19 00 00       	call   f0106aba <cpunum>
f0105179:	6b c0 74             	imul   $0x74,%eax,%eax
f010517c:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105182:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0105185:	e9 a8 fd ff ff       	jmp    f0104f32 <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f010518a:	83 ec 04             	sub    $0x4,%esp
f010518d:	68 90 94 10 f0       	push   $0xf0109490
f0105192:	68 17 02 00 00       	push   $0x217
f0105197:	68 7e 94 10 f0       	push   $0xf010947e
f010519c:	e8 a8 ae ff ff       	call   f0100049 <_panic>
	sched_yield();
f01051a1:	e8 76 fc ff ff       	call   f0104e1c <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f01051a6:	e8 0f 19 00 00       	call   f0106aba <cpunum>
f01051ab:	83 ec 08             	sub    $0x8,%esp
f01051ae:	6b c0 74             	imul   $0x74,%eax,%eax
f01051b1:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01051b7:	ff 70 48             	pushl  0x48(%eax)
f01051ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01051bd:	50                   	push   %eax
f01051be:	e8 7a e4 ff ff       	call   f010363d <env_alloc>
f01051c3:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01051c5:	83 c4 10             	add    $0x10,%esp
f01051c8:	85 c0                	test   %eax,%eax
f01051ca:	0f 88 62 fd ff ff    	js     f0104f32 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f01051d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051d3:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f01051da:	e8 db 18 00 00       	call   f0106aba <cpunum>
f01051df:	6b c0 74             	imul   $0x74,%eax,%eax
f01051e2:	8b b0 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%esi
f01051e8:	b9 11 00 00 00       	mov    $0x11,%ecx
f01051ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01051f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01051f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051f5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01051fc:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01051ff:	e9 2e fd ff ff       	jmp    f0104f32 <syscall+0x52>
	switch (status)
f0105204:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f0105208:	74 06                	je     f0105210 <syscall+0x330>
f010520a:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f010520e:	75 54                	jne    f0105264 <syscall+0x384>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f0105210:	8b 45 10             	mov    0x10(%ebp),%eax
f0105213:	83 e8 02             	sub    $0x2,%eax
f0105216:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f010521b:	75 31                	jne    f010524e <syscall+0x36e>
	int ret = envid2env(envid, &e, 1);
f010521d:	83 ec 04             	sub    $0x4,%esp
f0105220:	6a 01                	push   $0x1
f0105222:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105225:	50                   	push   %eax
f0105226:	ff 75 0c             	pushl  0xc(%ebp)
f0105229:	e8 0f e3 ff ff       	call   f010353d <envid2env>
f010522e:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105230:	83 c4 10             	add    $0x10,%esp
f0105233:	85 c0                	test   %eax,%eax
f0105235:	0f 88 f7 fc ff ff    	js     f0104f32 <syscall+0x52>
	e->env_status = status;
f010523b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010523e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105241:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0105244:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105249:	e9 e4 fc ff ff       	jmp    f0104f32 <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f010524e:	68 bc 94 10 f0       	push   $0xf01094bc
f0105253:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0105258:	6a 7b                	push   $0x7b
f010525a:	68 7e 94 10 f0       	push   $0xf010947e
f010525f:	e8 e5 ad ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f0105264:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105269:	e9 c4 fc ff ff       	jmp    f0104f32 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f010526e:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105275:	0f 87 cd 00 00 00    	ja     f0105348 <syscall+0x468>
f010527b:	8b 45 10             	mov    0x10(%ebp),%eax
f010527e:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105283:	8b 55 14             	mov    0x14(%ebp),%edx
f0105286:	83 e2 05             	and    $0x5,%edx
f0105289:	83 fa 05             	cmp    $0x5,%edx
f010528c:	0f 85 c0 00 00 00    	jne    f0105352 <syscall+0x472>
	if(perm & ~PTE_SYSCALL)
f0105292:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105295:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f010529b:	09 c3                	or     %eax,%ebx
f010529d:	0f 85 b9 00 00 00    	jne    f010535c <syscall+0x47c>
	int ret = envid2env(envid, &e, 1);
f01052a3:	83 ec 04             	sub    $0x4,%esp
f01052a6:	6a 01                	push   $0x1
f01052a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01052ab:	50                   	push   %eax
f01052ac:	ff 75 0c             	pushl  0xc(%ebp)
f01052af:	e8 89 e2 ff ff       	call   f010353d <envid2env>
	if(ret < 0)
f01052b4:	83 c4 10             	add    $0x10,%esp
f01052b7:	85 c0                	test   %eax,%eax
f01052b9:	0f 88 a7 00 00 00    	js     f0105366 <syscall+0x486>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01052bf:	83 ec 0c             	sub    $0xc,%esp
f01052c2:	6a 01                	push   $0x1
f01052c4:	e8 0a c0 ff ff       	call   f01012d3 <page_alloc>
f01052c9:	89 c6                	mov    %eax,%esi
	if(page == NULL)
f01052cb:	83 c4 10             	add    $0x10,%esp
f01052ce:	85 c0                	test   %eax,%eax
f01052d0:	0f 84 97 00 00 00    	je     f010536d <syscall+0x48d>
	return (pp - pages) << PGSHIFT;
f01052d6:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01052dc:	c1 f8 03             	sar    $0x3,%eax
f01052df:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01052e2:	89 c2                	mov    %eax,%edx
f01052e4:	c1 ea 0c             	shr    $0xc,%edx
f01052e7:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01052ed:	73 47                	jae    f0105336 <syscall+0x456>
	memset(page2kva(page), 0, PGSIZE);
f01052ef:	83 ec 04             	sub    $0x4,%esp
f01052f2:	68 00 10 00 00       	push   $0x1000
f01052f7:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01052f9:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01052fe:	50                   	push   %eax
f01052ff:	e8 af 11 00 00       	call   f01064b3 <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f0105304:	ff 75 14             	pushl  0x14(%ebp)
f0105307:	ff 75 10             	pushl  0x10(%ebp)
f010530a:	56                   	push   %esi
f010530b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010530e:	ff 70 60             	pushl  0x60(%eax)
f0105311:	e8 f9 c2 ff ff       	call   f010160f <page_insert>
f0105316:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f0105318:	83 c4 20             	add    $0x20,%esp
f010531b:	85 c0                	test   %eax,%eax
f010531d:	0f 89 0f fc ff ff    	jns    f0104f32 <syscall+0x52>
		page_free(page);
f0105323:	83 ec 0c             	sub    $0xc,%esp
f0105326:	56                   	push   %esi
f0105327:	e8 19 c0 ff ff       	call   f0101345 <page_free>
f010532c:	83 c4 10             	add    $0x10,%esp
		return ret;
f010532f:	89 fb                	mov    %edi,%ebx
f0105331:	e9 fc fb ff ff       	jmp    f0104f32 <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105336:	50                   	push   %eax
f0105337:	68 b4 78 10 f0       	push   $0xf01078b4
f010533c:	6a 58                	push   $0x58
f010533e:	68 51 8a 10 f0       	push   $0xf0108a51
f0105343:	e8 01 ad ff ff       	call   f0100049 <_panic>
		return -E_INVAL;
f0105348:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010534d:	e9 e0 fb ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f0105352:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105357:	e9 d6 fb ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f010535c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105361:	e9 cc fb ff ff       	jmp    f0104f32 <syscall+0x52>
		return ret;
f0105366:	89 c3                	mov    %eax,%ebx
f0105368:	e9 c5 fb ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_NO_MEM;
f010536d:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105372:	e9 bb fb ff ff       	jmp    f0104f32 <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105377:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010537a:	83 e0 05             	and    $0x5,%eax
f010537d:	83 f8 05             	cmp    $0x5,%eax
f0105380:	0f 85 c0 00 00 00    	jne    f0105446 <syscall+0x566>
	if(perm & ~PTE_SYSCALL)
f0105386:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105389:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f010538e:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105395:	0f 87 b5 00 00 00    	ja     f0105450 <syscall+0x570>
f010539b:	8b 55 10             	mov    0x10(%ebp),%edx
f010539e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f01053a4:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f01053ab:	0f 87 a9 00 00 00    	ja     f010545a <syscall+0x57a>
f01053b1:	09 d0                	or     %edx,%eax
f01053b3:	8b 55 18             	mov    0x18(%ebp),%edx
f01053b6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f01053bc:	09 d0                	or     %edx,%eax
f01053be:	0f 85 a0 00 00 00    	jne    f0105464 <syscall+0x584>
	int ret = envid2env(srcenvid, &src_env, 1);
f01053c4:	83 ec 04             	sub    $0x4,%esp
f01053c7:	6a 01                	push   $0x1
f01053c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01053cc:	50                   	push   %eax
f01053cd:	ff 75 0c             	pushl  0xc(%ebp)
f01053d0:	e8 68 e1 ff ff       	call   f010353d <envid2env>
f01053d5:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01053d7:	83 c4 10             	add    $0x10,%esp
f01053da:	85 c0                	test   %eax,%eax
f01053dc:	0f 88 50 fb ff ff    	js     f0104f32 <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f01053e2:	83 ec 04             	sub    $0x4,%esp
f01053e5:	6a 01                	push   $0x1
f01053e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01053ea:	50                   	push   %eax
f01053eb:	ff 75 14             	pushl  0x14(%ebp)
f01053ee:	e8 4a e1 ff ff       	call   f010353d <envid2env>
f01053f3:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01053f5:	83 c4 10             	add    $0x10,%esp
f01053f8:	85 c0                	test   %eax,%eax
f01053fa:	0f 88 32 fb ff ff    	js     f0104f32 <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f0105400:	83 ec 04             	sub    $0x4,%esp
f0105403:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105406:	50                   	push   %eax
f0105407:	ff 75 10             	pushl  0x10(%ebp)
f010540a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010540d:	ff 70 60             	pushl  0x60(%eax)
f0105410:	e8 1a c1 ff ff       	call   f010152f <page_lookup>
	if(src_page == NULL)
f0105415:	83 c4 10             	add    $0x10,%esp
f0105418:	85 c0                	test   %eax,%eax
f010541a:	74 52                	je     f010546e <syscall+0x58e>
	if(perm & PTE_W){
f010541c:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0105420:	74 08                	je     f010542a <syscall+0x54a>
		if((*pte_store & PTE_W) == 0)
f0105422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105425:	f6 02 02             	testb  $0x2,(%edx)
f0105428:	74 4e                	je     f0105478 <syscall+0x598>
	return page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f010542a:	ff 75 1c             	pushl  0x1c(%ebp)
f010542d:	ff 75 18             	pushl  0x18(%ebp)
f0105430:	50                   	push   %eax
f0105431:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105434:	ff 70 60             	pushl  0x60(%eax)
f0105437:	e8 d3 c1 ff ff       	call   f010160f <page_insert>
f010543c:	89 c3                	mov    %eax,%ebx
f010543e:	83 c4 10             	add    $0x10,%esp
f0105441:	e9 ec fa ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f0105446:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010544b:	e9 e2 fa ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f0105450:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105455:	e9 d8 fa ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f010545a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010545f:	e9 ce fa ff ff       	jmp    f0104f32 <syscall+0x52>
f0105464:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105469:	e9 c4 fa ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f010546e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105473:	e9 ba fa ff ff       	jmp    f0104f32 <syscall+0x52>
			return -E_INVAL;
f0105478:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010547d:	e9 b0 fa ff ff       	jmp    f0104f32 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105482:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105489:	77 45                	ja     f01054d0 <syscall+0x5f0>
f010548b:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105492:	75 46                	jne    f01054da <syscall+0x5fa>
	int ret = envid2env(envid, &env, 1);
f0105494:	83 ec 04             	sub    $0x4,%esp
f0105497:	6a 01                	push   $0x1
f0105499:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010549c:	50                   	push   %eax
f010549d:	ff 75 0c             	pushl  0xc(%ebp)
f01054a0:	e8 98 e0 ff ff       	call   f010353d <envid2env>
f01054a5:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01054a7:	83 c4 10             	add    $0x10,%esp
f01054aa:	85 c0                	test   %eax,%eax
f01054ac:	0f 88 80 fa ff ff    	js     f0104f32 <syscall+0x52>
	page_remove(env->env_pgdir, va);
f01054b2:	83 ec 08             	sub    $0x8,%esp
f01054b5:	ff 75 10             	pushl  0x10(%ebp)
f01054b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01054bb:	ff 70 60             	pushl  0x60(%eax)
f01054be:	e8 06 c1 ff ff       	call   f01015c9 <page_remove>
f01054c3:	83 c4 10             	add    $0x10,%esp
	return 0;
f01054c6:	bb 00 00 00 00       	mov    $0x0,%ebx
f01054cb:	e9 62 fa ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f01054d0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01054d5:	e9 58 fa ff ff       	jmp    f0104f32 <syscall+0x52>
f01054da:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01054df:	e9 4e fa ff ff       	jmp    f0104f32 <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f01054e4:	83 ec 04             	sub    $0x4,%esp
f01054e7:	6a 00                	push   $0x0
f01054e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01054ec:	50                   	push   %eax
f01054ed:	ff 75 0c             	pushl  0xc(%ebp)
f01054f0:	e8 48 e0 ff ff       	call   f010353d <envid2env>
f01054f5:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01054f7:	83 c4 10             	add    $0x10,%esp
f01054fa:	85 c0                	test   %eax,%eax
f01054fc:	0f 88 30 fa ff ff    	js     f0104f32 <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f0105502:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105505:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0105509:	0f 84 f8 00 00 00    	je     f0105607 <syscall+0x727>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f010550f:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0105516:	77 78                	ja     f0105590 <syscall+0x6b0>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105518:	8b 45 18             	mov    0x18(%ebp),%eax
f010551b:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f010551e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105523:	83 f8 05             	cmp    $0x5,%eax
f0105526:	0f 85 06 fa ff ff    	jne    f0104f32 <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f010552c:	8b 55 14             	mov    0x14(%ebp),%edx
f010552f:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f0105535:	8b 45 18             	mov    0x18(%ebp),%eax
f0105538:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f010553d:	09 c2                	or     %eax,%edx
f010553f:	0f 85 ed f9 ff ff    	jne    f0104f32 <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105545:	e8 70 15 00 00       	call   f0106aba <cpunum>
f010554a:	83 ec 04             	sub    $0x4,%esp
f010554d:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105550:	52                   	push   %edx
f0105551:	ff 75 14             	pushl  0x14(%ebp)
f0105554:	6b c0 74             	imul   $0x74,%eax,%eax
f0105557:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010555d:	ff 70 60             	pushl  0x60(%eax)
f0105560:	e8 ca bf ff ff       	call   f010152f <page_lookup>
		if(!page)
f0105565:	83 c4 10             	add    $0x10,%esp
f0105568:	85 c0                	test   %eax,%eax
f010556a:	0f 84 8d 00 00 00    	je     f01055fd <syscall+0x71d>
		if((perm & PTE_W) && !(*pte & PTE_W))
f0105570:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105574:	74 0c                	je     f0105582 <syscall+0x6a2>
f0105576:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105579:	f6 02 02             	testb  $0x2,(%edx)
f010557c:	0f 84 b0 f9 ff ff    	je     f0104f32 <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105582:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105585:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105588:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010558e:	76 52                	jbe    f01055e2 <syscall+0x702>
	dst_env->env_ipc_recving = 0;
f0105590:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105593:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105597:	e8 1e 15 00 00       	call   f0106aba <cpunum>
f010559c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010559f:	6b c0 74             	imul   $0x74,%eax,%eax
f01055a2:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01055a8:	8b 40 48             	mov    0x48(%eax),%eax
f01055ab:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_value = value;
f01055ae:	8b 45 10             	mov    0x10(%ebp),%eax
f01055b1:	89 42 70             	mov    %eax,0x70(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f01055b4:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f01055bb:	b8 00 00 00 00       	mov    $0x0,%eax
f01055c0:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f01055c4:	89 45 18             	mov    %eax,0x18(%ebp)
f01055c7:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f01055ca:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f01055d1:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f01055d8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01055dd:	e9 50 f9 ff ff       	jmp    f0104f32 <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f01055e2:	ff 75 18             	pushl  0x18(%ebp)
f01055e5:	51                   	push   %ecx
f01055e6:	50                   	push   %eax
f01055e7:	ff 72 60             	pushl  0x60(%edx)
f01055ea:	e8 20 c0 ff ff       	call   f010160f <page_insert>
f01055ef:	89 c3                	mov    %eax,%ebx
			if(ret < 0)
f01055f1:	83 c4 10             	add    $0x10,%esp
f01055f4:	85 c0                	test   %eax,%eax
f01055f6:	79 98                	jns    f0105590 <syscall+0x6b0>
f01055f8:	e9 35 f9 ff ff       	jmp    f0104f32 <syscall+0x52>
			return -E_INVAL;		
f01055fd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105602:	e9 2b f9 ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_IPC_NOT_RECV;
f0105607:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f010560c:	e9 21 f9 ff ff       	jmp    f0104f32 <syscall+0x52>
	if(dstva < (void *)UTOP){
f0105611:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105618:	77 13                	ja     f010562d <syscall+0x74d>
		if((uint32_t)dstva % PGSIZE != 0)
f010561a:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0105621:	74 0a                	je     f010562d <syscall+0x74d>
			ret = sys_ipc_recv((void *)a1);
f0105623:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f0105628:	e9 05 f9 ff ff       	jmp    f0104f32 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f010562d:	e8 88 14 00 00       	call   f0106aba <cpunum>
f0105632:	6b c0 74             	imul   $0x74,%eax,%eax
f0105635:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010563b:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f010563f:	e8 76 14 00 00       	call   f0106aba <cpunum>
f0105644:	6b c0 74             	imul   $0x74,%eax,%eax
f0105647:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010564d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105650:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105653:	e8 62 14 00 00       	call   f0106aba <cpunum>
f0105658:	6b c0 74             	imul   $0x74,%eax,%eax
f010565b:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105661:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105668:	e8 af f7 ff ff       	call   f0104e1c <sched_yield>
	int ret = envid2env(envid, &e, 1);
f010566d:	83 ec 04             	sub    $0x4,%esp
f0105670:	6a 01                	push   $0x1
f0105672:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105675:	50                   	push   %eax
f0105676:	ff 75 0c             	pushl  0xc(%ebp)
f0105679:	e8 bf de ff ff       	call   f010353d <envid2env>
f010567e:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105680:	83 c4 10             	add    $0x10,%esp
f0105683:	85 c0                	test   %eax,%eax
f0105685:	0f 88 a7 f8 ff ff    	js     f0104f32 <syscall+0x52>
	e->env_pgfault_upcall = func;
f010568b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010568e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105691:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0105694:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105699:	e9 94 f8 ff ff       	jmp    f0104f32 <syscall+0x52>
	r = envid2env(envid, &e, 0);
f010569e:	83 ec 04             	sub    $0x4,%esp
f01056a1:	6a 00                	push   $0x0
f01056a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01056a6:	50                   	push   %eax
f01056a7:	ff 75 0c             	pushl  0xc(%ebp)
f01056aa:	e8 8e de ff ff       	call   f010353d <envid2env>
f01056af:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f01056b1:	83 c4 10             	add    $0x10,%esp
f01056b4:	85 c0                	test   %eax,%eax
f01056b6:	0f 88 76 f8 ff ff    	js     f0104f32 <syscall+0x52>
	e->env_tf = *tf;
f01056bc:	b9 11 00 00 00       	mov    $0x11,%ecx
f01056c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01056c4:	8b 75 10             	mov    0x10(%ebp),%esi
f01056c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f01056c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01056cc:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f01056d1:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f01056d8:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01056dd:	e9 50 f8 ff ff       	jmp    f0104f32 <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f01056e2:	83 ec 04             	sub    $0x4,%esp
f01056e5:	6a 00                	push   $0x0
f01056e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01056ea:	50                   	push   %eax
f01056eb:	ff 75 0c             	pushl  0xc(%ebp)
f01056ee:	e8 4a de ff ff       	call   f010353d <envid2env>
f01056f3:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01056f5:	83 c4 10             	add    $0x10,%esp
f01056f8:	85 c0                	test   %eax,%eax
f01056fa:	0f 88 32 f8 ff ff    	js     f0104f32 <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f0105700:	83 ec 04             	sub    $0x4,%esp
f0105703:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105706:	50                   	push   %eax
f0105707:	ff 75 10             	pushl  0x10(%ebp)
f010570a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010570d:	ff 70 60             	pushl  0x60(%eax)
f0105710:	e8 1a be ff ff       	call   f010152f <page_lookup>
	if(page == NULL)
f0105715:	83 c4 10             	add    $0x10,%esp
f0105718:	85 c0                	test   %eax,%eax
f010571a:	74 16                	je     f0105732 <syscall+0x852>
	*pte_store |= PTE_A;
f010571c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010571f:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f0105722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105725:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f0105728:	bb 00 00 00 00       	mov    $0x0,%ebx
f010572d:	e9 00 f8 ff ff       	jmp    f0104f32 <syscall+0x52>
		return -E_INVAL;
f0105732:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105737:	e9 f6 f7 ff ff       	jmp    f0104f32 <syscall+0x52>
	return time_msec();
f010573c:	e8 c4 1e 00 00       	call   f0107605 <time_msec>
f0105741:	89 c3                	mov    %eax,%ebx
			break;
f0105743:	e9 ea f7 ff ff       	jmp    f0104f32 <syscall+0x52>
			ret = -E_INVAL;
f0105748:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010574d:	e9 e0 f7 ff ff       	jmp    f0104f32 <syscall+0x52>
        return E_INVAL;
f0105752:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105757:	e9 d6 f7 ff ff       	jmp    f0104f32 <syscall+0x52>

f010575c <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010575c:	55                   	push   %ebp
f010575d:	89 e5                	mov    %esp,%ebp
f010575f:	57                   	push   %edi
f0105760:	56                   	push   %esi
f0105761:	53                   	push   %ebx
f0105762:	83 ec 14             	sub    $0x14,%esp
f0105765:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105768:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010576b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f010576e:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105771:	8b 1a                	mov    (%edx),%ebx
f0105773:	8b 01                	mov    (%ecx),%eax
f0105775:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105778:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f010577f:	eb 23                	jmp    f01057a4 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105781:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105784:	eb 1e                	jmp    f01057a4 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105786:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105789:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010578c:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105790:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105793:	73 41                	jae    f01057d6 <stab_binsearch+0x7a>
			*region_left = m;
f0105795:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105798:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f010579a:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f010579d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01057a4:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01057a7:	7f 5a                	jg     f0105803 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f01057a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01057ac:	01 d8                	add    %ebx,%eax
f01057ae:	89 c7                	mov    %eax,%edi
f01057b0:	c1 ef 1f             	shr    $0x1f,%edi
f01057b3:	01 c7                	add    %eax,%edi
f01057b5:	d1 ff                	sar    %edi
f01057b7:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f01057ba:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01057bd:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01057c1:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f01057c3:	39 c3                	cmp    %eax,%ebx
f01057c5:	7f ba                	jg     f0105781 <stab_binsearch+0x25>
f01057c7:	0f b6 0a             	movzbl (%edx),%ecx
f01057ca:	83 ea 0c             	sub    $0xc,%edx
f01057cd:	39 f1                	cmp    %esi,%ecx
f01057cf:	74 b5                	je     f0105786 <stab_binsearch+0x2a>
			m--;
f01057d1:	83 e8 01             	sub    $0x1,%eax
f01057d4:	eb ed                	jmp    f01057c3 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f01057d6:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01057d9:	76 14                	jbe    f01057ef <stab_binsearch+0x93>
			*region_right = m - 1;
f01057db:	83 e8 01             	sub    $0x1,%eax
f01057de:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01057e1:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01057e4:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f01057e6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01057ed:	eb b5                	jmp    f01057a4 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01057ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01057f2:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f01057f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01057f8:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f01057fa:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105801:	eb a1                	jmp    f01057a4 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105803:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105807:	75 15                	jne    f010581e <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0105809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010580c:	8b 00                	mov    (%eax),%eax
f010580e:	83 e8 01             	sub    $0x1,%eax
f0105811:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105814:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105816:	83 c4 14             	add    $0x14,%esp
f0105819:	5b                   	pop    %ebx
f010581a:	5e                   	pop    %esi
f010581b:	5f                   	pop    %edi
f010581c:	5d                   	pop    %ebp
f010581d:	c3                   	ret    
		for (l = *region_right;
f010581e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105821:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105823:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105826:	8b 0f                	mov    (%edi),%ecx
f0105828:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010582b:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010582e:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105832:	eb 03                	jmp    f0105837 <stab_binsearch+0xdb>
		     l--)
f0105834:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105837:	39 c1                	cmp    %eax,%ecx
f0105839:	7d 0a                	jge    f0105845 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f010583b:	0f b6 1a             	movzbl (%edx),%ebx
f010583e:	83 ea 0c             	sub    $0xc,%edx
f0105841:	39 f3                	cmp    %esi,%ebx
f0105843:	75 ef                	jne    f0105834 <stab_binsearch+0xd8>
		*region_left = l;
f0105845:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105848:	89 06                	mov    %eax,(%esi)
}
f010584a:	eb ca                	jmp    f0105816 <stab_binsearch+0xba>

f010584c <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010584c:	55                   	push   %ebp
f010584d:	89 e5                	mov    %esp,%ebp
f010584f:	57                   	push   %edi
f0105850:	56                   	push   %esi
f0105851:	53                   	push   %ebx
f0105852:	83 ec 4c             	sub    $0x4c,%esp
f0105855:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105858:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f010585b:	c7 03 48 95 10 f0    	movl   $0xf0109548,(%ebx)
	info->eip_line = 0;
f0105861:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105868:	c7 43 08 48 95 10 f0 	movl   $0xf0109548,0x8(%ebx)
	info->eip_fn_namelen = 9;
f010586f:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105876:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105879:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105880:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0105886:	0f 86 23 01 00 00    	jbe    f01059af <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f010588c:	c7 45 b8 a6 db 11 f0 	movl   $0xf011dba6,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0105893:	c7 45 b4 15 92 11 f0 	movl   $0xf0119215,-0x4c(%ebp)
		stab_end = __STAB_END__;
f010589a:	be 14 92 11 f0       	mov    $0xf0119214,%esi
		stabs = __STAB_BEGIN__;
f010589f:	c7 45 bc 24 9e 10 f0 	movl   $0xf0109e24,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01058a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
f01058a9:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f01058ac:	0f 83 59 02 00 00    	jae    f0105b0b <debuginfo_eip+0x2bf>
f01058b2:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01058b6:	0f 85 56 02 00 00    	jne    f0105b12 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01058bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01058c3:	2b 75 bc             	sub    -0x44(%ebp),%esi
f01058c6:	c1 fe 02             	sar    $0x2,%esi
f01058c9:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f01058cf:	83 e8 01             	sub    $0x1,%eax
f01058d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01058d5:	83 ec 08             	sub    $0x8,%esp
f01058d8:	57                   	push   %edi
f01058d9:	6a 64                	push   $0x64
f01058db:	8d 55 e0             	lea    -0x20(%ebp),%edx
f01058de:	89 d1                	mov    %edx,%ecx
f01058e0:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01058e3:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01058e6:	89 f0                	mov    %esi,%eax
f01058e8:	e8 6f fe ff ff       	call   f010575c <stab_binsearch>
	if (lfile == 0)
f01058ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058f0:	83 c4 10             	add    $0x10,%esp
f01058f3:	85 c0                	test   %eax,%eax
f01058f5:	0f 84 1e 02 00 00    	je     f0105b19 <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01058fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f01058fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105901:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105904:	83 ec 08             	sub    $0x8,%esp
f0105907:	57                   	push   %edi
f0105908:	6a 24                	push   $0x24
f010590a:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010590d:	89 d1                	mov    %edx,%ecx
f010590f:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105912:	89 f0                	mov    %esi,%eax
f0105914:	e8 43 fe ff ff       	call   f010575c <stab_binsearch>

	if (lfun <= rfun) {
f0105919:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010591c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f010591f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105922:	83 c4 10             	add    $0x10,%esp
f0105925:	39 c8                	cmp    %ecx,%eax
f0105927:	0f 8f 26 01 00 00    	jg     f0105a53 <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f010592d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105930:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f0105933:	8b 11                	mov    (%ecx),%edx
f0105935:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0105938:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f010593b:	39 f2                	cmp    %esi,%edx
f010593d:	73 06                	jae    f0105945 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010593f:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105942:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105945:	8b 51 08             	mov    0x8(%ecx),%edx
f0105948:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f010594b:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f010594d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105950:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105953:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105956:	83 ec 08             	sub    $0x8,%esp
f0105959:	6a 3a                	push   $0x3a
f010595b:	ff 73 08             	pushl  0x8(%ebx)
f010595e:	e8 34 0b 00 00       	call   f0106497 <strfind>
f0105963:	2b 43 08             	sub    0x8(%ebx),%eax
f0105966:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105969:	83 c4 08             	add    $0x8,%esp
f010596c:	57                   	push   %edi
f010596d:	6a 44                	push   $0x44
f010596f:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105972:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105975:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105978:	89 f0                	mov    %esi,%eax
f010597a:	e8 dd fd ff ff       	call   f010575c <stab_binsearch>
	if(lline <= rline){
f010597f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105982:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105985:	83 c4 10             	add    $0x10,%esp
f0105988:	39 c2                	cmp    %eax,%edx
f010598a:	0f 8f 90 01 00 00    	jg     f0105b20 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f0105990:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105993:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105997:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010599a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010599d:	89 d0                	mov    %edx,%eax
f010599f:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01059a2:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f01059a6:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f01059aa:	e9 c2 00 00 00       	jmp    f0105a71 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f01059af:	e8 06 11 00 00       	call   f0106aba <cpunum>
f01059b4:	6a 06                	push   $0x6
f01059b6:	6a 10                	push   $0x10
f01059b8:	68 00 00 20 00       	push   $0x200000
f01059bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01059c0:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f01059c6:	e8 f8 d9 ff ff       	call   f01033c3 <user_mem_check>
f01059cb:	83 c4 10             	add    $0x10,%esp
f01059ce:	85 c0                	test   %eax,%eax
f01059d0:	0f 88 27 01 00 00    	js     f0105afd <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f01059d6:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f01059dc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f01059df:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f01059e5:	a1 08 00 20 00       	mov    0x200008,%eax
f01059ea:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f01059ed:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f01059f3:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f01059f6:	e8 bf 10 00 00       	call   f0106aba <cpunum>
f01059fb:	6a 06                	push   $0x6
f01059fd:	89 f2                	mov    %esi,%edx
f01059ff:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105a02:	29 ca                	sub    %ecx,%edx
f0105a04:	52                   	push   %edx
f0105a05:	51                   	push   %ecx
f0105a06:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a09:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0105a0f:	e8 af d9 ff ff       	call   f01033c3 <user_mem_check>
f0105a14:	83 c4 10             	add    $0x10,%esp
f0105a17:	85 c0                	test   %eax,%eax
f0105a19:	0f 88 e5 00 00 00    	js     f0105b04 <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105a1f:	e8 96 10 00 00       	call   f0106aba <cpunum>
f0105a24:	6a 06                	push   $0x6
f0105a26:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105a29:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105a2c:	29 ca                	sub    %ecx,%edx
f0105a2e:	52                   	push   %edx
f0105a2f:	51                   	push   %ecx
f0105a30:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a33:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0105a39:	e8 85 d9 ff ff       	call   f01033c3 <user_mem_check>
f0105a3e:	83 c4 10             	add    $0x10,%esp
f0105a41:	85 c0                	test   %eax,%eax
f0105a43:	0f 89 5d fe ff ff    	jns    f01058a6 <debuginfo_eip+0x5a>
			return -1;
f0105a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105a4e:	e9 d9 00 00 00       	jmp    f0105b2c <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105a53:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a59:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105a5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a5f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105a62:	e9 ef fe ff ff       	jmp    f0105956 <debuginfo_eip+0x10a>
f0105a67:	83 e8 01             	sub    $0x1,%eax
f0105a6a:	83 ea 0c             	sub    $0xc,%edx
f0105a6d:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105a71:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105a74:	39 c7                	cmp    %eax,%edi
f0105a76:	7f 45                	jg     f0105abd <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f0105a78:	0f b6 0a             	movzbl (%edx),%ecx
f0105a7b:	80 f9 84             	cmp    $0x84,%cl
f0105a7e:	74 19                	je     f0105a99 <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105a80:	80 f9 64             	cmp    $0x64,%cl
f0105a83:	75 e2                	jne    f0105a67 <debuginfo_eip+0x21b>
f0105a85:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105a89:	74 dc                	je     f0105a67 <debuginfo_eip+0x21b>
f0105a8b:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105a8f:	74 11                	je     f0105aa2 <debuginfo_eip+0x256>
f0105a91:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105a94:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105a97:	eb 09                	jmp    f0105aa2 <debuginfo_eip+0x256>
f0105a99:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105a9d:	74 03                	je     f0105aa2 <debuginfo_eip+0x256>
f0105a9f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105aa2:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105aa5:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105aa8:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105aab:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105aae:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105ab1:	29 f8                	sub    %edi,%eax
f0105ab3:	39 c2                	cmp    %eax,%edx
f0105ab5:	73 06                	jae    f0105abd <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105ab7:	89 f8                	mov    %edi,%eax
f0105ab9:	01 d0                	add    %edx,%eax
f0105abb:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105abd:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105ac0:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f0105ac3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105ac8:	39 f2                	cmp    %esi,%edx
f0105aca:	7d 60                	jge    f0105b2c <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0105acc:	83 c2 01             	add    $0x1,%edx
f0105acf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105ad2:	89 d0                	mov    %edx,%eax
f0105ad4:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105ad7:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105ada:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105ade:	eb 04                	jmp    f0105ae4 <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f0105ae0:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105ae4:	39 c6                	cmp    %eax,%esi
f0105ae6:	7e 3f                	jle    f0105b27 <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105ae8:	0f b6 0a             	movzbl (%edx),%ecx
f0105aeb:	83 c0 01             	add    $0x1,%eax
f0105aee:	83 c2 0c             	add    $0xc,%edx
f0105af1:	80 f9 a0             	cmp    $0xa0,%cl
f0105af4:	74 ea                	je     f0105ae0 <debuginfo_eip+0x294>
	return 0;
f0105af6:	b8 00 00 00 00       	mov    $0x0,%eax
f0105afb:	eb 2f                	jmp    f0105b2c <debuginfo_eip+0x2e0>
			return -1;
f0105afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b02:	eb 28                	jmp    f0105b2c <debuginfo_eip+0x2e0>
			return -1;
f0105b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b09:	eb 21                	jmp    f0105b2c <debuginfo_eip+0x2e0>
		return -1;
f0105b0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b10:	eb 1a                	jmp    f0105b2c <debuginfo_eip+0x2e0>
f0105b12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b17:	eb 13                	jmp    f0105b2c <debuginfo_eip+0x2e0>
		return -1;
f0105b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b1e:	eb 0c                	jmp    f0105b2c <debuginfo_eip+0x2e0>
		return -1;
f0105b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b25:	eb 05                	jmp    f0105b2c <debuginfo_eip+0x2e0>
	return 0;
f0105b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b2f:	5b                   	pop    %ebx
f0105b30:	5e                   	pop    %esi
f0105b31:	5f                   	pop    %edi
f0105b32:	5d                   	pop    %ebp
f0105b33:	c3                   	ret    

f0105b34 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105b34:	55                   	push   %ebp
f0105b35:	89 e5                	mov    %esp,%ebp
f0105b37:	57                   	push   %edi
f0105b38:	56                   	push   %esi
f0105b39:	53                   	push   %ebx
f0105b3a:	83 ec 1c             	sub    $0x1c,%esp
f0105b3d:	89 c6                	mov    %eax,%esi
f0105b3f:	89 d7                	mov    %edx,%edi
f0105b41:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b44:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105b47:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105b4a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105b4d:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b50:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105b53:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105b57:	74 2c                	je     f0105b85 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f0105b59:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105b5c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105b63:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105b66:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105b69:	39 c2                	cmp    %eax,%edx
f0105b6b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105b6e:	73 43                	jae    f0105bb3 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105b70:	83 eb 01             	sub    $0x1,%ebx
f0105b73:	85 db                	test   %ebx,%ebx
f0105b75:	7e 6c                	jle    f0105be3 <printnum+0xaf>
				putch(padc, putdat);
f0105b77:	83 ec 08             	sub    $0x8,%esp
f0105b7a:	57                   	push   %edi
f0105b7b:	ff 75 18             	pushl  0x18(%ebp)
f0105b7e:	ff d6                	call   *%esi
f0105b80:	83 c4 10             	add    $0x10,%esp
f0105b83:	eb eb                	jmp    f0105b70 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105b85:	83 ec 0c             	sub    $0xc,%esp
f0105b88:	6a 20                	push   $0x20
f0105b8a:	6a 00                	push   $0x0
f0105b8c:	50                   	push   %eax
f0105b8d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105b90:	ff 75 e0             	pushl  -0x20(%ebp)
f0105b93:	89 fa                	mov    %edi,%edx
f0105b95:	89 f0                	mov    %esi,%eax
f0105b97:	e8 98 ff ff ff       	call   f0105b34 <printnum>
		while (--width > 0)
f0105b9c:	83 c4 20             	add    $0x20,%esp
f0105b9f:	83 eb 01             	sub    $0x1,%ebx
f0105ba2:	85 db                	test   %ebx,%ebx
f0105ba4:	7e 65                	jle    f0105c0b <printnum+0xd7>
			putch(padc, putdat);
f0105ba6:	83 ec 08             	sub    $0x8,%esp
f0105ba9:	57                   	push   %edi
f0105baa:	6a 20                	push   $0x20
f0105bac:	ff d6                	call   *%esi
f0105bae:	83 c4 10             	add    $0x10,%esp
f0105bb1:	eb ec                	jmp    f0105b9f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f0105bb3:	83 ec 0c             	sub    $0xc,%esp
f0105bb6:	ff 75 18             	pushl  0x18(%ebp)
f0105bb9:	83 eb 01             	sub    $0x1,%ebx
f0105bbc:	53                   	push   %ebx
f0105bbd:	50                   	push   %eax
f0105bbe:	83 ec 08             	sub    $0x8,%esp
f0105bc1:	ff 75 dc             	pushl  -0x24(%ebp)
f0105bc4:	ff 75 d8             	pushl  -0x28(%ebp)
f0105bc7:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105bca:	ff 75 e0             	pushl  -0x20(%ebp)
f0105bcd:	e8 3e 1a 00 00       	call   f0107610 <__udivdi3>
f0105bd2:	83 c4 18             	add    $0x18,%esp
f0105bd5:	52                   	push   %edx
f0105bd6:	50                   	push   %eax
f0105bd7:	89 fa                	mov    %edi,%edx
f0105bd9:	89 f0                	mov    %esi,%eax
f0105bdb:	e8 54 ff ff ff       	call   f0105b34 <printnum>
f0105be0:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f0105be3:	83 ec 08             	sub    $0x8,%esp
f0105be6:	57                   	push   %edi
f0105be7:	83 ec 04             	sub    $0x4,%esp
f0105bea:	ff 75 dc             	pushl  -0x24(%ebp)
f0105bed:	ff 75 d8             	pushl  -0x28(%ebp)
f0105bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105bf3:	ff 75 e0             	pushl  -0x20(%ebp)
f0105bf6:	e8 25 1b 00 00       	call   f0107720 <__umoddi3>
f0105bfb:	83 c4 14             	add    $0x14,%esp
f0105bfe:	0f be 80 52 95 10 f0 	movsbl -0xfef6aae(%eax),%eax
f0105c05:	50                   	push   %eax
f0105c06:	ff d6                	call   *%esi
f0105c08:	83 c4 10             	add    $0x10,%esp
	}
}
f0105c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105c0e:	5b                   	pop    %ebx
f0105c0f:	5e                   	pop    %esi
f0105c10:	5f                   	pop    %edi
f0105c11:	5d                   	pop    %ebp
f0105c12:	c3                   	ret    

f0105c13 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105c13:	55                   	push   %ebp
f0105c14:	89 e5                	mov    %esp,%ebp
f0105c16:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105c19:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105c1d:	8b 10                	mov    (%eax),%edx
f0105c1f:	3b 50 04             	cmp    0x4(%eax),%edx
f0105c22:	73 0a                	jae    f0105c2e <sprintputch+0x1b>
		*b->buf++ = ch;
f0105c24:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105c27:	89 08                	mov    %ecx,(%eax)
f0105c29:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c2c:	88 02                	mov    %al,(%edx)
}
f0105c2e:	5d                   	pop    %ebp
f0105c2f:	c3                   	ret    

f0105c30 <printfmt>:
{
f0105c30:	55                   	push   %ebp
f0105c31:	89 e5                	mov    %esp,%ebp
f0105c33:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105c36:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105c39:	50                   	push   %eax
f0105c3a:	ff 75 10             	pushl  0x10(%ebp)
f0105c3d:	ff 75 0c             	pushl  0xc(%ebp)
f0105c40:	ff 75 08             	pushl  0x8(%ebp)
f0105c43:	e8 05 00 00 00       	call   f0105c4d <vprintfmt>
}
f0105c48:	83 c4 10             	add    $0x10,%esp
f0105c4b:	c9                   	leave  
f0105c4c:	c3                   	ret    

f0105c4d <vprintfmt>:
{
f0105c4d:	55                   	push   %ebp
f0105c4e:	89 e5                	mov    %esp,%ebp
f0105c50:	57                   	push   %edi
f0105c51:	56                   	push   %esi
f0105c52:	53                   	push   %ebx
f0105c53:	83 ec 3c             	sub    $0x3c,%esp
f0105c56:	8b 75 08             	mov    0x8(%ebp),%esi
f0105c59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105c5c:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105c5f:	e9 32 04 00 00       	jmp    f0106096 <vprintfmt+0x449>
		padc = ' ';
f0105c64:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f0105c68:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f0105c6f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0105c76:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105c7d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105c84:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0105c8b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105c90:	8d 47 01             	lea    0x1(%edi),%eax
f0105c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105c96:	0f b6 17             	movzbl (%edi),%edx
f0105c99:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105c9c:	3c 55                	cmp    $0x55,%al
f0105c9e:	0f 87 12 05 00 00    	ja     f01061b6 <vprintfmt+0x569>
f0105ca4:	0f b6 c0             	movzbl %al,%eax
f0105ca7:	ff 24 85 40 97 10 f0 	jmp    *-0xfef68c0(,%eax,4)
f0105cae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105cb1:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0105cb5:	eb d9                	jmp    f0105c90 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105cba:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0105cbe:	eb d0                	jmp    f0105c90 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105cc0:	0f b6 d2             	movzbl %dl,%edx
f0105cc3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105cc6:	b8 00 00 00 00       	mov    $0x0,%eax
f0105ccb:	89 75 08             	mov    %esi,0x8(%ebp)
f0105cce:	eb 03                	jmp    f0105cd3 <vprintfmt+0x86>
f0105cd0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105cd3:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105cd6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0105cda:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105cdd:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105ce0:	83 fe 09             	cmp    $0x9,%esi
f0105ce3:	76 eb                	jbe    f0105cd0 <vprintfmt+0x83>
f0105ce5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105ce8:	8b 75 08             	mov    0x8(%ebp),%esi
f0105ceb:	eb 14                	jmp    f0105d01 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0105ced:	8b 45 14             	mov    0x14(%ebp),%eax
f0105cf0:	8b 00                	mov    (%eax),%eax
f0105cf2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105cf5:	8b 45 14             	mov    0x14(%ebp),%eax
f0105cf8:	8d 40 04             	lea    0x4(%eax),%eax
f0105cfb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105cfe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105d01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105d05:	79 89                	jns    f0105c90 <vprintfmt+0x43>
				width = precision, precision = -1;
f0105d07:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105d0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105d0d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105d14:	e9 77 ff ff ff       	jmp    f0105c90 <vprintfmt+0x43>
f0105d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d1c:	85 c0                	test   %eax,%eax
f0105d1e:	0f 48 c1             	cmovs  %ecx,%eax
f0105d21:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105d24:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105d27:	e9 64 ff ff ff       	jmp    f0105c90 <vprintfmt+0x43>
f0105d2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105d2f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0105d36:	e9 55 ff ff ff       	jmp    f0105c90 <vprintfmt+0x43>
			lflag++;
f0105d3b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105d3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105d42:	e9 49 ff ff ff       	jmp    f0105c90 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0105d47:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d4a:	8d 78 04             	lea    0x4(%eax),%edi
f0105d4d:	83 ec 08             	sub    $0x8,%esp
f0105d50:	53                   	push   %ebx
f0105d51:	ff 30                	pushl  (%eax)
f0105d53:	ff d6                	call   *%esi
			break;
f0105d55:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105d58:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105d5b:	e9 33 03 00 00       	jmp    f0106093 <vprintfmt+0x446>
			err = va_arg(ap, int);
f0105d60:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d63:	8d 78 04             	lea    0x4(%eax),%edi
f0105d66:	8b 00                	mov    (%eax),%eax
f0105d68:	99                   	cltd   
f0105d69:	31 d0                	xor    %edx,%eax
f0105d6b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105d6d:	83 f8 10             	cmp    $0x10,%eax
f0105d70:	7f 23                	jg     f0105d95 <vprintfmt+0x148>
f0105d72:	8b 14 85 a0 98 10 f0 	mov    -0xfef6760(,%eax,4),%edx
f0105d79:	85 d2                	test   %edx,%edx
f0105d7b:	74 18                	je     f0105d95 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f0105d7d:	52                   	push   %edx
f0105d7e:	68 7d 8a 10 f0       	push   $0xf0108a7d
f0105d83:	53                   	push   %ebx
f0105d84:	56                   	push   %esi
f0105d85:	e8 a6 fe ff ff       	call   f0105c30 <printfmt>
f0105d8a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105d8d:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105d90:	e9 fe 02 00 00       	jmp    f0106093 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f0105d95:	50                   	push   %eax
f0105d96:	68 6a 95 10 f0       	push   $0xf010956a
f0105d9b:	53                   	push   %ebx
f0105d9c:	56                   	push   %esi
f0105d9d:	e8 8e fe ff ff       	call   f0105c30 <printfmt>
f0105da2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105da5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105da8:	e9 e6 02 00 00       	jmp    f0106093 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f0105dad:	8b 45 14             	mov    0x14(%ebp),%eax
f0105db0:	83 c0 04             	add    $0x4,%eax
f0105db3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105db6:	8b 45 14             	mov    0x14(%ebp),%eax
f0105db9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f0105dbb:	85 c9                	test   %ecx,%ecx
f0105dbd:	b8 63 95 10 f0       	mov    $0xf0109563,%eax
f0105dc2:	0f 45 c1             	cmovne %ecx,%eax
f0105dc5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0105dc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105dcc:	7e 06                	jle    f0105dd4 <vprintfmt+0x187>
f0105dce:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0105dd2:	75 0d                	jne    f0105de1 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105dd4:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105dd7:	89 c7                	mov    %eax,%edi
f0105dd9:	03 45 e0             	add    -0x20(%ebp),%eax
f0105ddc:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105ddf:	eb 53                	jmp    f0105e34 <vprintfmt+0x1e7>
f0105de1:	83 ec 08             	sub    $0x8,%esp
f0105de4:	ff 75 d8             	pushl  -0x28(%ebp)
f0105de7:	50                   	push   %eax
f0105de8:	e8 5f 05 00 00       	call   f010634c <strnlen>
f0105ded:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105df0:	29 c1                	sub    %eax,%ecx
f0105df2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0105df5:	83 c4 10             	add    $0x10,%esp
f0105df8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0105dfa:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0105dfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105e01:	eb 0f                	jmp    f0105e12 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0105e03:	83 ec 08             	sub    $0x8,%esp
f0105e06:	53                   	push   %ebx
f0105e07:	ff 75 e0             	pushl  -0x20(%ebp)
f0105e0a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105e0c:	83 ef 01             	sub    $0x1,%edi
f0105e0f:	83 c4 10             	add    $0x10,%esp
f0105e12:	85 ff                	test   %edi,%edi
f0105e14:	7f ed                	jg     f0105e03 <vprintfmt+0x1b6>
f0105e16:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105e19:	85 c9                	test   %ecx,%ecx
f0105e1b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e20:	0f 49 c1             	cmovns %ecx,%eax
f0105e23:	29 c1                	sub    %eax,%ecx
f0105e25:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105e28:	eb aa                	jmp    f0105dd4 <vprintfmt+0x187>
					putch(ch, putdat);
f0105e2a:	83 ec 08             	sub    $0x8,%esp
f0105e2d:	53                   	push   %ebx
f0105e2e:	52                   	push   %edx
f0105e2f:	ff d6                	call   *%esi
f0105e31:	83 c4 10             	add    $0x10,%esp
f0105e34:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105e37:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105e39:	83 c7 01             	add    $0x1,%edi
f0105e3c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105e40:	0f be d0             	movsbl %al,%edx
f0105e43:	85 d2                	test   %edx,%edx
f0105e45:	74 4b                	je     f0105e92 <vprintfmt+0x245>
f0105e47:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105e4b:	78 06                	js     f0105e53 <vprintfmt+0x206>
f0105e4d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105e51:	78 1e                	js     f0105e71 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f0105e53:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0105e57:	74 d1                	je     f0105e2a <vprintfmt+0x1dd>
f0105e59:	0f be c0             	movsbl %al,%eax
f0105e5c:	83 e8 20             	sub    $0x20,%eax
f0105e5f:	83 f8 5e             	cmp    $0x5e,%eax
f0105e62:	76 c6                	jbe    f0105e2a <vprintfmt+0x1dd>
					putch('?', putdat);
f0105e64:	83 ec 08             	sub    $0x8,%esp
f0105e67:	53                   	push   %ebx
f0105e68:	6a 3f                	push   $0x3f
f0105e6a:	ff d6                	call   *%esi
f0105e6c:	83 c4 10             	add    $0x10,%esp
f0105e6f:	eb c3                	jmp    f0105e34 <vprintfmt+0x1e7>
f0105e71:	89 cf                	mov    %ecx,%edi
f0105e73:	eb 0e                	jmp    f0105e83 <vprintfmt+0x236>
				putch(' ', putdat);
f0105e75:	83 ec 08             	sub    $0x8,%esp
f0105e78:	53                   	push   %ebx
f0105e79:	6a 20                	push   $0x20
f0105e7b:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105e7d:	83 ef 01             	sub    $0x1,%edi
f0105e80:	83 c4 10             	add    $0x10,%esp
f0105e83:	85 ff                	test   %edi,%edi
f0105e85:	7f ee                	jg     f0105e75 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f0105e87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105e8a:	89 45 14             	mov    %eax,0x14(%ebp)
f0105e8d:	e9 01 02 00 00       	jmp    f0106093 <vprintfmt+0x446>
f0105e92:	89 cf                	mov    %ecx,%edi
f0105e94:	eb ed                	jmp    f0105e83 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f0105e96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f0105e99:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f0105ea0:	e9 eb fd ff ff       	jmp    f0105c90 <vprintfmt+0x43>
	if (lflag >= 2)
f0105ea5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105ea9:	7f 21                	jg     f0105ecc <vprintfmt+0x27f>
	else if (lflag)
f0105eab:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105eaf:	74 68                	je     f0105f19 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f0105eb1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105eb4:	8b 00                	mov    (%eax),%eax
f0105eb6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105eb9:	89 c1                	mov    %eax,%ecx
f0105ebb:	c1 f9 1f             	sar    $0x1f,%ecx
f0105ebe:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105ec1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ec4:	8d 40 04             	lea    0x4(%eax),%eax
f0105ec7:	89 45 14             	mov    %eax,0x14(%ebp)
f0105eca:	eb 17                	jmp    f0105ee3 <vprintfmt+0x296>
		return va_arg(*ap, long long);
f0105ecc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ecf:	8b 50 04             	mov    0x4(%eax),%edx
f0105ed2:	8b 00                	mov    (%eax),%eax
f0105ed4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105ed7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105eda:	8b 45 14             	mov    0x14(%ebp),%eax
f0105edd:	8d 40 08             	lea    0x8(%eax),%eax
f0105ee0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0105ee3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105ee6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105ee9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105eec:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f0105eef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105ef3:	78 3f                	js     f0105f34 <vprintfmt+0x2e7>
			base = 10;
f0105ef5:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f0105efa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f0105efe:	0f 84 71 01 00 00    	je     f0106075 <vprintfmt+0x428>
				putch('+', putdat);
f0105f04:	83 ec 08             	sub    $0x8,%esp
f0105f07:	53                   	push   %ebx
f0105f08:	6a 2b                	push   $0x2b
f0105f0a:	ff d6                	call   *%esi
f0105f0c:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105f0f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f14:	e9 5c 01 00 00       	jmp    f0106075 <vprintfmt+0x428>
		return va_arg(*ap, int);
f0105f19:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f1c:	8b 00                	mov    (%eax),%eax
f0105f1e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105f21:	89 c1                	mov    %eax,%ecx
f0105f23:	c1 f9 1f             	sar    $0x1f,%ecx
f0105f26:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105f29:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f2c:	8d 40 04             	lea    0x4(%eax),%eax
f0105f2f:	89 45 14             	mov    %eax,0x14(%ebp)
f0105f32:	eb af                	jmp    f0105ee3 <vprintfmt+0x296>
				putch('-', putdat);
f0105f34:	83 ec 08             	sub    $0x8,%esp
f0105f37:	53                   	push   %ebx
f0105f38:	6a 2d                	push   $0x2d
f0105f3a:	ff d6                	call   *%esi
				num = -(long long) num;
f0105f3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105f3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105f42:	f7 d8                	neg    %eax
f0105f44:	83 d2 00             	adc    $0x0,%edx
f0105f47:	f7 da                	neg    %edx
f0105f49:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f4c:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f4f:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105f52:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f57:	e9 19 01 00 00       	jmp    f0106075 <vprintfmt+0x428>
	if (lflag >= 2)
f0105f5c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105f60:	7f 29                	jg     f0105f8b <vprintfmt+0x33e>
	else if (lflag)
f0105f62:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105f66:	74 44                	je     f0105fac <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f0105f68:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f6b:	8b 00                	mov    (%eax),%eax
f0105f6d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f72:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f75:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f78:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f7b:	8d 40 04             	lea    0x4(%eax),%eax
f0105f7e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105f81:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f86:	e9 ea 00 00 00       	jmp    f0106075 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0105f8b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f8e:	8b 50 04             	mov    0x4(%eax),%edx
f0105f91:	8b 00                	mov    (%eax),%eax
f0105f93:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f96:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f99:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f9c:	8d 40 08             	lea    0x8(%eax),%eax
f0105f9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105fa2:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105fa7:	e9 c9 00 00 00       	jmp    f0106075 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0105fac:	8b 45 14             	mov    0x14(%ebp),%eax
f0105faf:	8b 00                	mov    (%eax),%eax
f0105fb1:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105fb9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105fbc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fbf:	8d 40 04             	lea    0x4(%eax),%eax
f0105fc2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105fc5:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105fca:	e9 a6 00 00 00       	jmp    f0106075 <vprintfmt+0x428>
			putch('0', putdat);
f0105fcf:	83 ec 08             	sub    $0x8,%esp
f0105fd2:	53                   	push   %ebx
f0105fd3:	6a 30                	push   $0x30
f0105fd5:	ff d6                	call   *%esi
	if (lflag >= 2)
f0105fd7:	83 c4 10             	add    $0x10,%esp
f0105fda:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105fde:	7f 26                	jg     f0106006 <vprintfmt+0x3b9>
	else if (lflag)
f0105fe0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105fe4:	74 3e                	je     f0106024 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f0105fe6:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fe9:	8b 00                	mov    (%eax),%eax
f0105feb:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ff0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105ff3:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105ff6:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ff9:	8d 40 04             	lea    0x4(%eax),%eax
f0105ffc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105fff:	b8 08 00 00 00       	mov    $0x8,%eax
f0106004:	eb 6f                	jmp    f0106075 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106006:	8b 45 14             	mov    0x14(%ebp),%eax
f0106009:	8b 50 04             	mov    0x4(%eax),%edx
f010600c:	8b 00                	mov    (%eax),%eax
f010600e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106011:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106014:	8b 45 14             	mov    0x14(%ebp),%eax
f0106017:	8d 40 08             	lea    0x8(%eax),%eax
f010601a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010601d:	b8 08 00 00 00       	mov    $0x8,%eax
f0106022:	eb 51                	jmp    f0106075 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106024:	8b 45 14             	mov    0x14(%ebp),%eax
f0106027:	8b 00                	mov    (%eax),%eax
f0106029:	ba 00 00 00 00       	mov    $0x0,%edx
f010602e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106031:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106034:	8b 45 14             	mov    0x14(%ebp),%eax
f0106037:	8d 40 04             	lea    0x4(%eax),%eax
f010603a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010603d:	b8 08 00 00 00       	mov    $0x8,%eax
f0106042:	eb 31                	jmp    f0106075 <vprintfmt+0x428>
			putch('0', putdat);
f0106044:	83 ec 08             	sub    $0x8,%esp
f0106047:	53                   	push   %ebx
f0106048:	6a 30                	push   $0x30
f010604a:	ff d6                	call   *%esi
			putch('x', putdat);
f010604c:	83 c4 08             	add    $0x8,%esp
f010604f:	53                   	push   %ebx
f0106050:	6a 78                	push   $0x78
f0106052:	ff d6                	call   *%esi
			num = (unsigned long long)
f0106054:	8b 45 14             	mov    0x14(%ebp),%eax
f0106057:	8b 00                	mov    (%eax),%eax
f0106059:	ba 00 00 00 00       	mov    $0x0,%edx
f010605e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106061:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f0106064:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0106067:	8b 45 14             	mov    0x14(%ebp),%eax
f010606a:	8d 40 04             	lea    0x4(%eax),%eax
f010606d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106070:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0106075:	83 ec 0c             	sub    $0xc,%esp
f0106078:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f010607c:	52                   	push   %edx
f010607d:	ff 75 e0             	pushl  -0x20(%ebp)
f0106080:	50                   	push   %eax
f0106081:	ff 75 dc             	pushl  -0x24(%ebp)
f0106084:	ff 75 d8             	pushl  -0x28(%ebp)
f0106087:	89 da                	mov    %ebx,%edx
f0106089:	89 f0                	mov    %esi,%eax
f010608b:	e8 a4 fa ff ff       	call   f0105b34 <printnum>
			break;
f0106090:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f0106093:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106096:	83 c7 01             	add    $0x1,%edi
f0106099:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010609d:	83 f8 25             	cmp    $0x25,%eax
f01060a0:	0f 84 be fb ff ff    	je     f0105c64 <vprintfmt+0x17>
			if (ch == '\0')
f01060a6:	85 c0                	test   %eax,%eax
f01060a8:	0f 84 28 01 00 00    	je     f01061d6 <vprintfmt+0x589>
			putch(ch, putdat);
f01060ae:	83 ec 08             	sub    $0x8,%esp
f01060b1:	53                   	push   %ebx
f01060b2:	50                   	push   %eax
f01060b3:	ff d6                	call   *%esi
f01060b5:	83 c4 10             	add    $0x10,%esp
f01060b8:	eb dc                	jmp    f0106096 <vprintfmt+0x449>
	if (lflag >= 2)
f01060ba:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01060be:	7f 26                	jg     f01060e6 <vprintfmt+0x499>
	else if (lflag)
f01060c0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01060c4:	74 41                	je     f0106107 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f01060c6:	8b 45 14             	mov    0x14(%ebp),%eax
f01060c9:	8b 00                	mov    (%eax),%eax
f01060cb:	ba 00 00 00 00       	mov    $0x0,%edx
f01060d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01060d9:	8d 40 04             	lea    0x4(%eax),%eax
f01060dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01060df:	b8 10 00 00 00       	mov    $0x10,%eax
f01060e4:	eb 8f                	jmp    f0106075 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01060e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01060e9:	8b 50 04             	mov    0x4(%eax),%edx
f01060ec:	8b 00                	mov    (%eax),%eax
f01060ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060f4:	8b 45 14             	mov    0x14(%ebp),%eax
f01060f7:	8d 40 08             	lea    0x8(%eax),%eax
f01060fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01060fd:	b8 10 00 00 00       	mov    $0x10,%eax
f0106102:	e9 6e ff ff ff       	jmp    f0106075 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106107:	8b 45 14             	mov    0x14(%ebp),%eax
f010610a:	8b 00                	mov    (%eax),%eax
f010610c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106111:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106114:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106117:	8b 45 14             	mov    0x14(%ebp),%eax
f010611a:	8d 40 04             	lea    0x4(%eax),%eax
f010611d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106120:	b8 10 00 00 00       	mov    $0x10,%eax
f0106125:	e9 4b ff ff ff       	jmp    f0106075 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f010612a:	8b 45 14             	mov    0x14(%ebp),%eax
f010612d:	83 c0 04             	add    $0x4,%eax
f0106130:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106133:	8b 45 14             	mov    0x14(%ebp),%eax
f0106136:	8b 00                	mov    (%eax),%eax
f0106138:	85 c0                	test   %eax,%eax
f010613a:	74 14                	je     f0106150 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f010613c:	8b 13                	mov    (%ebx),%edx
f010613e:	83 fa 7f             	cmp    $0x7f,%edx
f0106141:	7f 37                	jg     f010617a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f0106143:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f0106145:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106148:	89 45 14             	mov    %eax,0x14(%ebp)
f010614b:	e9 43 ff ff ff       	jmp    f0106093 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f0106150:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106155:	bf 89 96 10 f0       	mov    $0xf0109689,%edi
							putch(ch, putdat);
f010615a:	83 ec 08             	sub    $0x8,%esp
f010615d:	53                   	push   %ebx
f010615e:	50                   	push   %eax
f010615f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0106161:	83 c7 01             	add    $0x1,%edi
f0106164:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f0106168:	83 c4 10             	add    $0x10,%esp
f010616b:	85 c0                	test   %eax,%eax
f010616d:	75 eb                	jne    f010615a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f010616f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106172:	89 45 14             	mov    %eax,0x14(%ebp)
f0106175:	e9 19 ff ff ff       	jmp    f0106093 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f010617a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f010617c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106181:	bf c1 96 10 f0       	mov    $0xf01096c1,%edi
							putch(ch, putdat);
f0106186:	83 ec 08             	sub    $0x8,%esp
f0106189:	53                   	push   %ebx
f010618a:	50                   	push   %eax
f010618b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f010618d:	83 c7 01             	add    $0x1,%edi
f0106190:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f0106194:	83 c4 10             	add    $0x10,%esp
f0106197:	85 c0                	test   %eax,%eax
f0106199:	75 eb                	jne    f0106186 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f010619b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010619e:	89 45 14             	mov    %eax,0x14(%ebp)
f01061a1:	e9 ed fe ff ff       	jmp    f0106093 <vprintfmt+0x446>
			putch(ch, putdat);
f01061a6:	83 ec 08             	sub    $0x8,%esp
f01061a9:	53                   	push   %ebx
f01061aa:	6a 25                	push   $0x25
f01061ac:	ff d6                	call   *%esi
			break;
f01061ae:	83 c4 10             	add    $0x10,%esp
f01061b1:	e9 dd fe ff ff       	jmp    f0106093 <vprintfmt+0x446>
			putch('%', putdat);
f01061b6:	83 ec 08             	sub    $0x8,%esp
f01061b9:	53                   	push   %ebx
f01061ba:	6a 25                	push   $0x25
f01061bc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01061be:	83 c4 10             	add    $0x10,%esp
f01061c1:	89 f8                	mov    %edi,%eax
f01061c3:	eb 03                	jmp    f01061c8 <vprintfmt+0x57b>
f01061c5:	83 e8 01             	sub    $0x1,%eax
f01061c8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01061cc:	75 f7                	jne    f01061c5 <vprintfmt+0x578>
f01061ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01061d1:	e9 bd fe ff ff       	jmp    f0106093 <vprintfmt+0x446>
}
f01061d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01061d9:	5b                   	pop    %ebx
f01061da:	5e                   	pop    %esi
f01061db:	5f                   	pop    %edi
f01061dc:	5d                   	pop    %ebp
f01061dd:	c3                   	ret    

f01061de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01061de:	55                   	push   %ebp
f01061df:	89 e5                	mov    %esp,%ebp
f01061e1:	83 ec 18             	sub    $0x18,%esp
f01061e4:	8b 45 08             	mov    0x8(%ebp),%eax
f01061e7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01061ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01061ed:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01061f1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01061f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01061fb:	85 c0                	test   %eax,%eax
f01061fd:	74 26                	je     f0106225 <vsnprintf+0x47>
f01061ff:	85 d2                	test   %edx,%edx
f0106201:	7e 22                	jle    f0106225 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106203:	ff 75 14             	pushl  0x14(%ebp)
f0106206:	ff 75 10             	pushl  0x10(%ebp)
f0106209:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010620c:	50                   	push   %eax
f010620d:	68 13 5c 10 f0       	push   $0xf0105c13
f0106212:	e8 36 fa ff ff       	call   f0105c4d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106217:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010621a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010621d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106220:	83 c4 10             	add    $0x10,%esp
}
f0106223:	c9                   	leave  
f0106224:	c3                   	ret    
		return -E_INVAL;
f0106225:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010622a:	eb f7                	jmp    f0106223 <vsnprintf+0x45>

f010622c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010622c:	55                   	push   %ebp
f010622d:	89 e5                	mov    %esp,%ebp
f010622f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106232:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106235:	50                   	push   %eax
f0106236:	ff 75 10             	pushl  0x10(%ebp)
f0106239:	ff 75 0c             	pushl  0xc(%ebp)
f010623c:	ff 75 08             	pushl  0x8(%ebp)
f010623f:	e8 9a ff ff ff       	call   f01061de <vsnprintf>
	va_end(ap);

	return rc;
}
f0106244:	c9                   	leave  
f0106245:	c3                   	ret    

f0106246 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106246:	55                   	push   %ebp
f0106247:	89 e5                	mov    %esp,%ebp
f0106249:	57                   	push   %edi
f010624a:	56                   	push   %esi
f010624b:	53                   	push   %ebx
f010624c:	83 ec 0c             	sub    $0xc,%esp
f010624f:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106252:	85 c0                	test   %eax,%eax
f0106254:	74 11                	je     f0106267 <readline+0x21>
		cprintf("%s", prompt);
f0106256:	83 ec 08             	sub    $0x8,%esp
f0106259:	50                   	push   %eax
f010625a:	68 7d 8a 10 f0       	push   $0xf0108a7d
f010625f:	e8 0b dc ff ff       	call   f0103e6f <cprintf>
f0106264:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106267:	83 ec 0c             	sub    $0xc,%esp
f010626a:	6a 00                	push   $0x0
f010626c:	e8 78 a5 ff ff       	call   f01007e9 <iscons>
f0106271:	89 c7                	mov    %eax,%edi
f0106273:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0106276:	be 00 00 00 00       	mov    $0x0,%esi
f010627b:	eb 57                	jmp    f01062d4 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f010627d:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106282:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106285:	75 08                	jne    f010628f <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0106287:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010628a:	5b                   	pop    %ebx
f010628b:	5e                   	pop    %esi
f010628c:	5f                   	pop    %edi
f010628d:	5d                   	pop    %ebp
f010628e:	c3                   	ret    
				cprintf("read error: %e\n", c);
f010628f:	83 ec 08             	sub    $0x8,%esp
f0106292:	53                   	push   %ebx
f0106293:	68 e4 98 10 f0       	push   $0xf01098e4
f0106298:	e8 d2 db ff ff       	call   f0103e6f <cprintf>
f010629d:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01062a0:	b8 00 00 00 00       	mov    $0x0,%eax
f01062a5:	eb e0                	jmp    f0106287 <readline+0x41>
			if (echoing)
f01062a7:	85 ff                	test   %edi,%edi
f01062a9:	75 05                	jne    f01062b0 <readline+0x6a>
			i--;
f01062ab:	83 ee 01             	sub    $0x1,%esi
f01062ae:	eb 24                	jmp    f01062d4 <readline+0x8e>
				cputchar('\b');
f01062b0:	83 ec 0c             	sub    $0xc,%esp
f01062b3:	6a 08                	push   $0x8
f01062b5:	e8 0e a5 ff ff       	call   f01007c8 <cputchar>
f01062ba:	83 c4 10             	add    $0x10,%esp
f01062bd:	eb ec                	jmp    f01062ab <readline+0x65>
				cputchar(c);
f01062bf:	83 ec 0c             	sub    $0xc,%esp
f01062c2:	53                   	push   %ebx
f01062c3:	e8 00 a5 ff ff       	call   f01007c8 <cputchar>
f01062c8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01062cb:	88 9e 80 aa 57 f0    	mov    %bl,-0xfa85580(%esi)
f01062d1:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01062d4:	e8 ff a4 ff ff       	call   f01007d8 <getchar>
f01062d9:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01062db:	85 c0                	test   %eax,%eax
f01062dd:	78 9e                	js     f010627d <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01062df:	83 f8 08             	cmp    $0x8,%eax
f01062e2:	0f 94 c2             	sete   %dl
f01062e5:	83 f8 7f             	cmp    $0x7f,%eax
f01062e8:	0f 94 c0             	sete   %al
f01062eb:	08 c2                	or     %al,%dl
f01062ed:	74 04                	je     f01062f3 <readline+0xad>
f01062ef:	85 f6                	test   %esi,%esi
f01062f1:	7f b4                	jg     f01062a7 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01062f3:	83 fb 1f             	cmp    $0x1f,%ebx
f01062f6:	7e 0e                	jle    f0106306 <readline+0xc0>
f01062f8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01062fe:	7f 06                	jg     f0106306 <readline+0xc0>
			if (echoing)
f0106300:	85 ff                	test   %edi,%edi
f0106302:	74 c7                	je     f01062cb <readline+0x85>
f0106304:	eb b9                	jmp    f01062bf <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f0106306:	83 fb 0a             	cmp    $0xa,%ebx
f0106309:	74 05                	je     f0106310 <readline+0xca>
f010630b:	83 fb 0d             	cmp    $0xd,%ebx
f010630e:	75 c4                	jne    f01062d4 <readline+0x8e>
			if (echoing)
f0106310:	85 ff                	test   %edi,%edi
f0106312:	75 11                	jne    f0106325 <readline+0xdf>
			buf[i] = 0;
f0106314:	c6 86 80 aa 57 f0 00 	movb   $0x0,-0xfa85580(%esi)
			return buf;
f010631b:	b8 80 aa 57 f0       	mov    $0xf057aa80,%eax
f0106320:	e9 62 ff ff ff       	jmp    f0106287 <readline+0x41>
				cputchar('\n');
f0106325:	83 ec 0c             	sub    $0xc,%esp
f0106328:	6a 0a                	push   $0xa
f010632a:	e8 99 a4 ff ff       	call   f01007c8 <cputchar>
f010632f:	83 c4 10             	add    $0x10,%esp
f0106332:	eb e0                	jmp    f0106314 <readline+0xce>

f0106334 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106334:	55                   	push   %ebp
f0106335:	89 e5                	mov    %esp,%ebp
f0106337:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010633a:	b8 00 00 00 00       	mov    $0x0,%eax
f010633f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106343:	74 05                	je     f010634a <strlen+0x16>
		n++;
f0106345:	83 c0 01             	add    $0x1,%eax
f0106348:	eb f5                	jmp    f010633f <strlen+0xb>
	return n;
}
f010634a:	5d                   	pop    %ebp
f010634b:	c3                   	ret    

f010634c <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010634c:	55                   	push   %ebp
f010634d:	89 e5                	mov    %esp,%ebp
f010634f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106352:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106355:	ba 00 00 00 00       	mov    $0x0,%edx
f010635a:	39 c2                	cmp    %eax,%edx
f010635c:	74 0d                	je     f010636b <strnlen+0x1f>
f010635e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106362:	74 05                	je     f0106369 <strnlen+0x1d>
		n++;
f0106364:	83 c2 01             	add    $0x1,%edx
f0106367:	eb f1                	jmp    f010635a <strnlen+0xe>
f0106369:	89 d0                	mov    %edx,%eax
	return n;
}
f010636b:	5d                   	pop    %ebp
f010636c:	c3                   	ret    

f010636d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010636d:	55                   	push   %ebp
f010636e:	89 e5                	mov    %esp,%ebp
f0106370:	53                   	push   %ebx
f0106371:	8b 45 08             	mov    0x8(%ebp),%eax
f0106374:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106377:	ba 00 00 00 00       	mov    $0x0,%edx
f010637c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106380:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0106383:	83 c2 01             	add    $0x1,%edx
f0106386:	84 c9                	test   %cl,%cl
f0106388:	75 f2                	jne    f010637c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f010638a:	5b                   	pop    %ebx
f010638b:	5d                   	pop    %ebp
f010638c:	c3                   	ret    

f010638d <strcat>:

char *
strcat(char *dst, const char *src)
{
f010638d:	55                   	push   %ebp
f010638e:	89 e5                	mov    %esp,%ebp
f0106390:	53                   	push   %ebx
f0106391:	83 ec 10             	sub    $0x10,%esp
f0106394:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106397:	53                   	push   %ebx
f0106398:	e8 97 ff ff ff       	call   f0106334 <strlen>
f010639d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01063a0:	ff 75 0c             	pushl  0xc(%ebp)
f01063a3:	01 d8                	add    %ebx,%eax
f01063a5:	50                   	push   %eax
f01063a6:	e8 c2 ff ff ff       	call   f010636d <strcpy>
	return dst;
}
f01063ab:	89 d8                	mov    %ebx,%eax
f01063ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01063b0:	c9                   	leave  
f01063b1:	c3                   	ret    

f01063b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01063b2:	55                   	push   %ebp
f01063b3:	89 e5                	mov    %esp,%ebp
f01063b5:	56                   	push   %esi
f01063b6:	53                   	push   %ebx
f01063b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01063ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01063bd:	89 c6                	mov    %eax,%esi
f01063bf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01063c2:	89 c2                	mov    %eax,%edx
f01063c4:	39 f2                	cmp    %esi,%edx
f01063c6:	74 11                	je     f01063d9 <strncpy+0x27>
		*dst++ = *src;
f01063c8:	83 c2 01             	add    $0x1,%edx
f01063cb:	0f b6 19             	movzbl (%ecx),%ebx
f01063ce:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01063d1:	80 fb 01             	cmp    $0x1,%bl
f01063d4:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01063d7:	eb eb                	jmp    f01063c4 <strncpy+0x12>
	}
	return ret;
}
f01063d9:	5b                   	pop    %ebx
f01063da:	5e                   	pop    %esi
f01063db:	5d                   	pop    %ebp
f01063dc:	c3                   	ret    

f01063dd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01063dd:	55                   	push   %ebp
f01063de:	89 e5                	mov    %esp,%ebp
f01063e0:	56                   	push   %esi
f01063e1:	53                   	push   %ebx
f01063e2:	8b 75 08             	mov    0x8(%ebp),%esi
f01063e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01063e8:	8b 55 10             	mov    0x10(%ebp),%edx
f01063eb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01063ed:	85 d2                	test   %edx,%edx
f01063ef:	74 21                	je     f0106412 <strlcpy+0x35>
f01063f1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01063f5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01063f7:	39 c2                	cmp    %eax,%edx
f01063f9:	74 14                	je     f010640f <strlcpy+0x32>
f01063fb:	0f b6 19             	movzbl (%ecx),%ebx
f01063fe:	84 db                	test   %bl,%bl
f0106400:	74 0b                	je     f010640d <strlcpy+0x30>
			*dst++ = *src++;
f0106402:	83 c1 01             	add    $0x1,%ecx
f0106405:	83 c2 01             	add    $0x1,%edx
f0106408:	88 5a ff             	mov    %bl,-0x1(%edx)
f010640b:	eb ea                	jmp    f01063f7 <strlcpy+0x1a>
f010640d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f010640f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106412:	29 f0                	sub    %esi,%eax
}
f0106414:	5b                   	pop    %ebx
f0106415:	5e                   	pop    %esi
f0106416:	5d                   	pop    %ebp
f0106417:	c3                   	ret    

f0106418 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0106418:	55                   	push   %ebp
f0106419:	89 e5                	mov    %esp,%ebp
f010641b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010641e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106421:	0f b6 01             	movzbl (%ecx),%eax
f0106424:	84 c0                	test   %al,%al
f0106426:	74 0c                	je     f0106434 <strcmp+0x1c>
f0106428:	3a 02                	cmp    (%edx),%al
f010642a:	75 08                	jne    f0106434 <strcmp+0x1c>
		p++, q++;
f010642c:	83 c1 01             	add    $0x1,%ecx
f010642f:	83 c2 01             	add    $0x1,%edx
f0106432:	eb ed                	jmp    f0106421 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106434:	0f b6 c0             	movzbl %al,%eax
f0106437:	0f b6 12             	movzbl (%edx),%edx
f010643a:	29 d0                	sub    %edx,%eax
}
f010643c:	5d                   	pop    %ebp
f010643d:	c3                   	ret    

f010643e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010643e:	55                   	push   %ebp
f010643f:	89 e5                	mov    %esp,%ebp
f0106441:	53                   	push   %ebx
f0106442:	8b 45 08             	mov    0x8(%ebp),%eax
f0106445:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106448:	89 c3                	mov    %eax,%ebx
f010644a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010644d:	eb 06                	jmp    f0106455 <strncmp+0x17>
		n--, p++, q++;
f010644f:	83 c0 01             	add    $0x1,%eax
f0106452:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0106455:	39 d8                	cmp    %ebx,%eax
f0106457:	74 16                	je     f010646f <strncmp+0x31>
f0106459:	0f b6 08             	movzbl (%eax),%ecx
f010645c:	84 c9                	test   %cl,%cl
f010645e:	74 04                	je     f0106464 <strncmp+0x26>
f0106460:	3a 0a                	cmp    (%edx),%cl
f0106462:	74 eb                	je     f010644f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106464:	0f b6 00             	movzbl (%eax),%eax
f0106467:	0f b6 12             	movzbl (%edx),%edx
f010646a:	29 d0                	sub    %edx,%eax
}
f010646c:	5b                   	pop    %ebx
f010646d:	5d                   	pop    %ebp
f010646e:	c3                   	ret    
		return 0;
f010646f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106474:	eb f6                	jmp    f010646c <strncmp+0x2e>

f0106476 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106476:	55                   	push   %ebp
f0106477:	89 e5                	mov    %esp,%ebp
f0106479:	8b 45 08             	mov    0x8(%ebp),%eax
f010647c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106480:	0f b6 10             	movzbl (%eax),%edx
f0106483:	84 d2                	test   %dl,%dl
f0106485:	74 09                	je     f0106490 <strchr+0x1a>
		if (*s == c)
f0106487:	38 ca                	cmp    %cl,%dl
f0106489:	74 0a                	je     f0106495 <strchr+0x1f>
	for (; *s; s++)
f010648b:	83 c0 01             	add    $0x1,%eax
f010648e:	eb f0                	jmp    f0106480 <strchr+0xa>
			return (char *) s;
	return 0;
f0106490:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106495:	5d                   	pop    %ebp
f0106496:	c3                   	ret    

f0106497 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0106497:	55                   	push   %ebp
f0106498:	89 e5                	mov    %esp,%ebp
f010649a:	8b 45 08             	mov    0x8(%ebp),%eax
f010649d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01064a1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01064a4:	38 ca                	cmp    %cl,%dl
f01064a6:	74 09                	je     f01064b1 <strfind+0x1a>
f01064a8:	84 d2                	test   %dl,%dl
f01064aa:	74 05                	je     f01064b1 <strfind+0x1a>
	for (; *s; s++)
f01064ac:	83 c0 01             	add    $0x1,%eax
f01064af:	eb f0                	jmp    f01064a1 <strfind+0xa>
			break;
	return (char *) s;
}
f01064b1:	5d                   	pop    %ebp
f01064b2:	c3                   	ret    

f01064b3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01064b3:	55                   	push   %ebp
f01064b4:	89 e5                	mov    %esp,%ebp
f01064b6:	57                   	push   %edi
f01064b7:	56                   	push   %esi
f01064b8:	53                   	push   %ebx
f01064b9:	8b 7d 08             	mov    0x8(%ebp),%edi
f01064bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01064bf:	85 c9                	test   %ecx,%ecx
f01064c1:	74 31                	je     f01064f4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01064c3:	89 f8                	mov    %edi,%eax
f01064c5:	09 c8                	or     %ecx,%eax
f01064c7:	a8 03                	test   $0x3,%al
f01064c9:	75 23                	jne    f01064ee <memset+0x3b>
		c &= 0xFF;
f01064cb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01064cf:	89 d3                	mov    %edx,%ebx
f01064d1:	c1 e3 08             	shl    $0x8,%ebx
f01064d4:	89 d0                	mov    %edx,%eax
f01064d6:	c1 e0 18             	shl    $0x18,%eax
f01064d9:	89 d6                	mov    %edx,%esi
f01064db:	c1 e6 10             	shl    $0x10,%esi
f01064de:	09 f0                	or     %esi,%eax
f01064e0:	09 c2                	or     %eax,%edx
f01064e2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01064e4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01064e7:	89 d0                	mov    %edx,%eax
f01064e9:	fc                   	cld    
f01064ea:	f3 ab                	rep stos %eax,%es:(%edi)
f01064ec:	eb 06                	jmp    f01064f4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01064ee:	8b 45 0c             	mov    0xc(%ebp),%eax
f01064f1:	fc                   	cld    
f01064f2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01064f4:	89 f8                	mov    %edi,%eax
f01064f6:	5b                   	pop    %ebx
f01064f7:	5e                   	pop    %esi
f01064f8:	5f                   	pop    %edi
f01064f9:	5d                   	pop    %ebp
f01064fa:	c3                   	ret    

f01064fb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01064fb:	55                   	push   %ebp
f01064fc:	89 e5                	mov    %esp,%ebp
f01064fe:	57                   	push   %edi
f01064ff:	56                   	push   %esi
f0106500:	8b 45 08             	mov    0x8(%ebp),%eax
f0106503:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106506:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106509:	39 c6                	cmp    %eax,%esi
f010650b:	73 32                	jae    f010653f <memmove+0x44>
f010650d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106510:	39 c2                	cmp    %eax,%edx
f0106512:	76 2b                	jbe    f010653f <memmove+0x44>
		s += n;
		d += n;
f0106514:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106517:	89 fe                	mov    %edi,%esi
f0106519:	09 ce                	or     %ecx,%esi
f010651b:	09 d6                	or     %edx,%esi
f010651d:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106523:	75 0e                	jne    f0106533 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106525:	83 ef 04             	sub    $0x4,%edi
f0106528:	8d 72 fc             	lea    -0x4(%edx),%esi
f010652b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010652e:	fd                   	std    
f010652f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106531:	eb 09                	jmp    f010653c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106533:	83 ef 01             	sub    $0x1,%edi
f0106536:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0106539:	fd                   	std    
f010653a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010653c:	fc                   	cld    
f010653d:	eb 1a                	jmp    f0106559 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010653f:	89 c2                	mov    %eax,%edx
f0106541:	09 ca                	or     %ecx,%edx
f0106543:	09 f2                	or     %esi,%edx
f0106545:	f6 c2 03             	test   $0x3,%dl
f0106548:	75 0a                	jne    f0106554 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010654a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010654d:	89 c7                	mov    %eax,%edi
f010654f:	fc                   	cld    
f0106550:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106552:	eb 05                	jmp    f0106559 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0106554:	89 c7                	mov    %eax,%edi
f0106556:	fc                   	cld    
f0106557:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106559:	5e                   	pop    %esi
f010655a:	5f                   	pop    %edi
f010655b:	5d                   	pop    %ebp
f010655c:	c3                   	ret    

f010655d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010655d:	55                   	push   %ebp
f010655e:	89 e5                	mov    %esp,%ebp
f0106560:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106563:	ff 75 10             	pushl  0x10(%ebp)
f0106566:	ff 75 0c             	pushl  0xc(%ebp)
f0106569:	ff 75 08             	pushl  0x8(%ebp)
f010656c:	e8 8a ff ff ff       	call   f01064fb <memmove>
}
f0106571:	c9                   	leave  
f0106572:	c3                   	ret    

f0106573 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106573:	55                   	push   %ebp
f0106574:	89 e5                	mov    %esp,%ebp
f0106576:	56                   	push   %esi
f0106577:	53                   	push   %ebx
f0106578:	8b 45 08             	mov    0x8(%ebp),%eax
f010657b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010657e:	89 c6                	mov    %eax,%esi
f0106580:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106583:	39 f0                	cmp    %esi,%eax
f0106585:	74 1c                	je     f01065a3 <memcmp+0x30>
		if (*s1 != *s2)
f0106587:	0f b6 08             	movzbl (%eax),%ecx
f010658a:	0f b6 1a             	movzbl (%edx),%ebx
f010658d:	38 d9                	cmp    %bl,%cl
f010658f:	75 08                	jne    f0106599 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0106591:	83 c0 01             	add    $0x1,%eax
f0106594:	83 c2 01             	add    $0x1,%edx
f0106597:	eb ea                	jmp    f0106583 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0106599:	0f b6 c1             	movzbl %cl,%eax
f010659c:	0f b6 db             	movzbl %bl,%ebx
f010659f:	29 d8                	sub    %ebx,%eax
f01065a1:	eb 05                	jmp    f01065a8 <memcmp+0x35>
	}

	return 0;
f01065a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01065a8:	5b                   	pop    %ebx
f01065a9:	5e                   	pop    %esi
f01065aa:	5d                   	pop    %ebp
f01065ab:	c3                   	ret    

f01065ac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01065ac:	55                   	push   %ebp
f01065ad:	89 e5                	mov    %esp,%ebp
f01065af:	8b 45 08             	mov    0x8(%ebp),%eax
f01065b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01065b5:	89 c2                	mov    %eax,%edx
f01065b7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01065ba:	39 d0                	cmp    %edx,%eax
f01065bc:	73 09                	jae    f01065c7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01065be:	38 08                	cmp    %cl,(%eax)
f01065c0:	74 05                	je     f01065c7 <memfind+0x1b>
	for (; s < ends; s++)
f01065c2:	83 c0 01             	add    $0x1,%eax
f01065c5:	eb f3                	jmp    f01065ba <memfind+0xe>
			break;
	return (void *) s;
}
f01065c7:	5d                   	pop    %ebp
f01065c8:	c3                   	ret    

f01065c9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01065c9:	55                   	push   %ebp
f01065ca:	89 e5                	mov    %esp,%ebp
f01065cc:	57                   	push   %edi
f01065cd:	56                   	push   %esi
f01065ce:	53                   	push   %ebx
f01065cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01065d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01065d5:	eb 03                	jmp    f01065da <strtol+0x11>
		s++;
f01065d7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01065da:	0f b6 01             	movzbl (%ecx),%eax
f01065dd:	3c 20                	cmp    $0x20,%al
f01065df:	74 f6                	je     f01065d7 <strtol+0xe>
f01065e1:	3c 09                	cmp    $0x9,%al
f01065e3:	74 f2                	je     f01065d7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01065e5:	3c 2b                	cmp    $0x2b,%al
f01065e7:	74 2a                	je     f0106613 <strtol+0x4a>
	int neg = 0;
f01065e9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01065ee:	3c 2d                	cmp    $0x2d,%al
f01065f0:	74 2b                	je     f010661d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01065f2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01065f8:	75 0f                	jne    f0106609 <strtol+0x40>
f01065fa:	80 39 30             	cmpb   $0x30,(%ecx)
f01065fd:	74 28                	je     f0106627 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01065ff:	85 db                	test   %ebx,%ebx
f0106601:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106606:	0f 44 d8             	cmove  %eax,%ebx
f0106609:	b8 00 00 00 00       	mov    $0x0,%eax
f010660e:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106611:	eb 50                	jmp    f0106663 <strtol+0x9a>
		s++;
f0106613:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0106616:	bf 00 00 00 00       	mov    $0x0,%edi
f010661b:	eb d5                	jmp    f01065f2 <strtol+0x29>
		s++, neg = 1;
f010661d:	83 c1 01             	add    $0x1,%ecx
f0106620:	bf 01 00 00 00       	mov    $0x1,%edi
f0106625:	eb cb                	jmp    f01065f2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106627:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010662b:	74 0e                	je     f010663b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f010662d:	85 db                	test   %ebx,%ebx
f010662f:	75 d8                	jne    f0106609 <strtol+0x40>
		s++, base = 8;
f0106631:	83 c1 01             	add    $0x1,%ecx
f0106634:	bb 08 00 00 00       	mov    $0x8,%ebx
f0106639:	eb ce                	jmp    f0106609 <strtol+0x40>
		s += 2, base = 16;
f010663b:	83 c1 02             	add    $0x2,%ecx
f010663e:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106643:	eb c4                	jmp    f0106609 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106645:	8d 72 9f             	lea    -0x61(%edx),%esi
f0106648:	89 f3                	mov    %esi,%ebx
f010664a:	80 fb 19             	cmp    $0x19,%bl
f010664d:	77 29                	ja     f0106678 <strtol+0xaf>
			dig = *s - 'a' + 10;
f010664f:	0f be d2             	movsbl %dl,%edx
f0106652:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106655:	3b 55 10             	cmp    0x10(%ebp),%edx
f0106658:	7d 30                	jge    f010668a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010665a:	83 c1 01             	add    $0x1,%ecx
f010665d:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106661:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106663:	0f b6 11             	movzbl (%ecx),%edx
f0106666:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106669:	89 f3                	mov    %esi,%ebx
f010666b:	80 fb 09             	cmp    $0x9,%bl
f010666e:	77 d5                	ja     f0106645 <strtol+0x7c>
			dig = *s - '0';
f0106670:	0f be d2             	movsbl %dl,%edx
f0106673:	83 ea 30             	sub    $0x30,%edx
f0106676:	eb dd                	jmp    f0106655 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f0106678:	8d 72 bf             	lea    -0x41(%edx),%esi
f010667b:	89 f3                	mov    %esi,%ebx
f010667d:	80 fb 19             	cmp    $0x19,%bl
f0106680:	77 08                	ja     f010668a <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106682:	0f be d2             	movsbl %dl,%edx
f0106685:	83 ea 37             	sub    $0x37,%edx
f0106688:	eb cb                	jmp    f0106655 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f010668a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010668e:	74 05                	je     f0106695 <strtol+0xcc>
		*endptr = (char *) s;
f0106690:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106693:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0106695:	89 c2                	mov    %eax,%edx
f0106697:	f7 da                	neg    %edx
f0106699:	85 ff                	test   %edi,%edi
f010669b:	0f 45 c2             	cmovne %edx,%eax
}
f010669e:	5b                   	pop    %ebx
f010669f:	5e                   	pop    %esi
f01066a0:	5f                   	pop    %edi
f01066a1:	5d                   	pop    %ebp
f01066a2:	c3                   	ret    
f01066a3:	90                   	nop

f01066a4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01066a4:	fa                   	cli    

	xorw    %ax, %ax
f01066a5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01066a7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01066a9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01066ab:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01066ad:	0f 01 16             	lgdtl  (%esi)
f01066b0:	7c 70                	jl     f0106722 <gdtdesc+0x2>
	movl    %cr0, %eax
f01066b2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01066b5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01066b9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01066bc:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01066c2:	08 00                	or     %al,(%eax)

f01066c4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01066c4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01066c8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01066ca:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01066cc:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01066ce:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01066d2:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01066d4:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01066d6:	b8 00 60 12 00       	mov    $0x126000,%eax
	movl    %eax, %cr3
f01066db:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f01066de:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f01066e1:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f01066e4:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f01066e7:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01066ea:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01066ef:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01066f2:	8b 25 a4 be 57 f0    	mov    0xf057bea4,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01066f8:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01066fd:	b8 fa 01 10 f0       	mov    $0xf01001fa,%eax
	call    *%eax
f0106702:	ff d0                	call   *%eax

f0106704 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106704:	eb fe                	jmp    f0106704 <spin>
f0106706:	66 90                	xchg   %ax,%ax

f0106708 <gdt>:
	...
f0106710:	ff                   	(bad)  
f0106711:	ff 00                	incl   (%eax)
f0106713:	00 00                	add    %al,(%eax)
f0106715:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010671c:	00                   	.byte 0x0
f010671d:	92                   	xchg   %eax,%edx
f010671e:	cf                   	iret   
	...

f0106720 <gdtdesc>:
f0106720:	17                   	pop    %ss
f0106721:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0106726 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106726:	90                   	nop

f0106727 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106727:	55                   	push   %ebp
f0106728:	89 e5                	mov    %esp,%ebp
f010672a:	57                   	push   %edi
f010672b:	56                   	push   %esi
f010672c:	53                   	push   %ebx
f010672d:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106730:	8b 0d a8 be 57 f0    	mov    0xf057bea8,%ecx
f0106736:	89 c3                	mov    %eax,%ebx
f0106738:	c1 eb 0c             	shr    $0xc,%ebx
f010673b:	39 cb                	cmp    %ecx,%ebx
f010673d:	73 1a                	jae    f0106759 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f010673f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106745:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106748:	89 f8                	mov    %edi,%eax
f010674a:	c1 e8 0c             	shr    $0xc,%eax
f010674d:	39 c8                	cmp    %ecx,%eax
f010674f:	73 1a                	jae    f010676b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106751:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106757:	eb 27                	jmp    f0106780 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106759:	50                   	push   %eax
f010675a:	68 b4 78 10 f0       	push   $0xf01078b4
f010675f:	6a 57                	push   $0x57
f0106761:	68 81 9a 10 f0       	push   $0xf0109a81
f0106766:	e8 de 98 ff ff       	call   f0100049 <_panic>
f010676b:	57                   	push   %edi
f010676c:	68 b4 78 10 f0       	push   $0xf01078b4
f0106771:	6a 57                	push   $0x57
f0106773:	68 81 9a 10 f0       	push   $0xf0109a81
f0106778:	e8 cc 98 ff ff       	call   f0100049 <_panic>
f010677d:	83 c3 10             	add    $0x10,%ebx
f0106780:	39 fb                	cmp    %edi,%ebx
f0106782:	73 30                	jae    f01067b4 <mpsearch1+0x8d>
f0106784:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106786:	83 ec 04             	sub    $0x4,%esp
f0106789:	6a 04                	push   $0x4
f010678b:	68 91 9a 10 f0       	push   $0xf0109a91
f0106790:	53                   	push   %ebx
f0106791:	e8 dd fd ff ff       	call   f0106573 <memcmp>
f0106796:	83 c4 10             	add    $0x10,%esp
f0106799:	85 c0                	test   %eax,%eax
f010679b:	75 e0                	jne    f010677d <mpsearch1+0x56>
f010679d:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f010679f:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f01067a2:	0f b6 0a             	movzbl (%edx),%ecx
f01067a5:	01 c8                	add    %ecx,%eax
f01067a7:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f01067aa:	39 f2                	cmp    %esi,%edx
f01067ac:	75 f4                	jne    f01067a2 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01067ae:	84 c0                	test   %al,%al
f01067b0:	75 cb                	jne    f010677d <mpsearch1+0x56>
f01067b2:	eb 05                	jmp    f01067b9 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01067b4:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01067b9:	89 d8                	mov    %ebx,%eax
f01067bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01067be:	5b                   	pop    %ebx
f01067bf:	5e                   	pop    %esi
f01067c0:	5f                   	pop    %edi
f01067c1:	5d                   	pop    %ebp
f01067c2:	c3                   	ret    

f01067c3 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01067c3:	55                   	push   %ebp
f01067c4:	89 e5                	mov    %esp,%ebp
f01067c6:	57                   	push   %edi
f01067c7:	56                   	push   %esi
f01067c8:	53                   	push   %ebx
f01067c9:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01067cc:	c7 05 c0 c3 57 f0 20 	movl   $0xf057c020,0xf057c3c0
f01067d3:	c0 57 f0 
	if (PGNUM(pa) >= npages)
f01067d6:	83 3d a8 be 57 f0 00 	cmpl   $0x0,0xf057bea8
f01067dd:	0f 84 a3 00 00 00    	je     f0106886 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01067e3:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01067ea:	85 c0                	test   %eax,%eax
f01067ec:	0f 84 aa 00 00 00    	je     f010689c <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f01067f2:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01067f5:	ba 00 04 00 00       	mov    $0x400,%edx
f01067fa:	e8 28 ff ff ff       	call   f0106727 <mpsearch1>
f01067ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106802:	85 c0                	test   %eax,%eax
f0106804:	75 1a                	jne    f0106820 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0106806:	ba 00 00 01 00       	mov    $0x10000,%edx
f010680b:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106810:	e8 12 ff ff ff       	call   f0106727 <mpsearch1>
f0106815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0106818:	85 c0                	test   %eax,%eax
f010681a:	0f 84 31 02 00 00    	je     f0106a51 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106823:	8b 58 04             	mov    0x4(%eax),%ebx
f0106826:	85 db                	test   %ebx,%ebx
f0106828:	0f 84 97 00 00 00    	je     f01068c5 <mp_init+0x102>
f010682e:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106832:	0f 85 8d 00 00 00    	jne    f01068c5 <mp_init+0x102>
f0106838:	89 d8                	mov    %ebx,%eax
f010683a:	c1 e8 0c             	shr    $0xc,%eax
f010683d:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f0106843:	0f 83 91 00 00 00    	jae    f01068da <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106849:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f010684f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106851:	83 ec 04             	sub    $0x4,%esp
f0106854:	6a 04                	push   $0x4
f0106856:	68 96 9a 10 f0       	push   $0xf0109a96
f010685b:	53                   	push   %ebx
f010685c:	e8 12 fd ff ff       	call   f0106573 <memcmp>
f0106861:	83 c4 10             	add    $0x10,%esp
f0106864:	85 c0                	test   %eax,%eax
f0106866:	0f 85 83 00 00 00    	jne    f01068ef <mp_init+0x12c>
f010686c:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106870:	01 df                	add    %ebx,%edi
	sum = 0;
f0106872:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106874:	39 fb                	cmp    %edi,%ebx
f0106876:	0f 84 88 00 00 00    	je     f0106904 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f010687c:	0f b6 0b             	movzbl (%ebx),%ecx
f010687f:	01 ca                	add    %ecx,%edx
f0106881:	83 c3 01             	add    $0x1,%ebx
f0106884:	eb ee                	jmp    f0106874 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106886:	68 00 04 00 00       	push   $0x400
f010688b:	68 b4 78 10 f0       	push   $0xf01078b4
f0106890:	6a 6f                	push   $0x6f
f0106892:	68 81 9a 10 f0       	push   $0xf0109a81
f0106897:	e8 ad 97 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f010689c:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01068a3:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f01068a6:	2d 00 04 00 00       	sub    $0x400,%eax
f01068ab:	ba 00 04 00 00       	mov    $0x400,%edx
f01068b0:	e8 72 fe ff ff       	call   f0106727 <mpsearch1>
f01068b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01068b8:	85 c0                	test   %eax,%eax
f01068ba:	0f 85 60 ff ff ff    	jne    f0106820 <mp_init+0x5d>
f01068c0:	e9 41 ff ff ff       	jmp    f0106806 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f01068c5:	83 ec 0c             	sub    $0xc,%esp
f01068c8:	68 f4 98 10 f0       	push   $0xf01098f4
f01068cd:	e8 9d d5 ff ff       	call   f0103e6f <cprintf>
f01068d2:	83 c4 10             	add    $0x10,%esp
f01068d5:	e9 77 01 00 00       	jmp    f0106a51 <mp_init+0x28e>
f01068da:	53                   	push   %ebx
f01068db:	68 b4 78 10 f0       	push   $0xf01078b4
f01068e0:	68 90 00 00 00       	push   $0x90
f01068e5:	68 81 9a 10 f0       	push   $0xf0109a81
f01068ea:	e8 5a 97 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01068ef:	83 ec 0c             	sub    $0xc,%esp
f01068f2:	68 24 99 10 f0       	push   $0xf0109924
f01068f7:	e8 73 d5 ff ff       	call   f0103e6f <cprintf>
f01068fc:	83 c4 10             	add    $0x10,%esp
f01068ff:	e9 4d 01 00 00       	jmp    f0106a51 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0106904:	84 d2                	test   %dl,%dl
f0106906:	75 16                	jne    f010691e <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0106908:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f010690c:	80 fa 01             	cmp    $0x1,%dl
f010690f:	74 05                	je     f0106916 <mp_init+0x153>
f0106911:	80 fa 04             	cmp    $0x4,%dl
f0106914:	75 1d                	jne    f0106933 <mp_init+0x170>
f0106916:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f010691a:	01 d9                	add    %ebx,%ecx
f010691c:	eb 36                	jmp    f0106954 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f010691e:	83 ec 0c             	sub    $0xc,%esp
f0106921:	68 58 99 10 f0       	push   $0xf0109958
f0106926:	e8 44 d5 ff ff       	call   f0103e6f <cprintf>
f010692b:	83 c4 10             	add    $0x10,%esp
f010692e:	e9 1e 01 00 00       	jmp    f0106a51 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106933:	83 ec 08             	sub    $0x8,%esp
f0106936:	0f b6 d2             	movzbl %dl,%edx
f0106939:	52                   	push   %edx
f010693a:	68 7c 99 10 f0       	push   $0xf010997c
f010693f:	e8 2b d5 ff ff       	call   f0103e6f <cprintf>
f0106944:	83 c4 10             	add    $0x10,%esp
f0106947:	e9 05 01 00 00       	jmp    f0106a51 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f010694c:	0f b6 13             	movzbl (%ebx),%edx
f010694f:	01 d0                	add    %edx,%eax
f0106951:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106954:	39 d9                	cmp    %ebx,%ecx
f0106956:	75 f4                	jne    f010694c <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106958:	02 46 2a             	add    0x2a(%esi),%al
f010695b:	75 1c                	jne    f0106979 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f010695d:	c7 05 00 c0 57 f0 01 	movl   $0x1,0xf057c000
f0106964:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106967:	8b 46 24             	mov    0x24(%esi),%eax
f010696a:	a3 00 d0 5b f0       	mov    %eax,0xf05bd000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f010696f:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106972:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106977:	eb 4d                	jmp    f01069c6 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106979:	83 ec 0c             	sub    $0xc,%esp
f010697c:	68 9c 99 10 f0       	push   $0xf010999c
f0106981:	e8 e9 d4 ff ff       	call   f0103e6f <cprintf>
f0106986:	83 c4 10             	add    $0x10,%esp
f0106989:	e9 c3 00 00 00       	jmp    f0106a51 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f010698e:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106992:	74 11                	je     f01069a5 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106994:	6b 05 c4 c3 57 f0 74 	imul   $0x74,0xf057c3c4,%eax
f010699b:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f01069a0:	a3 c0 c3 57 f0       	mov    %eax,0xf057c3c0
			if (ncpu < NCPU) {
f01069a5:	a1 c4 c3 57 f0       	mov    0xf057c3c4,%eax
f01069aa:	83 f8 07             	cmp    $0x7,%eax
f01069ad:	7f 2f                	jg     f01069de <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f01069af:	6b d0 74             	imul   $0x74,%eax,%edx
f01069b2:	88 82 20 c0 57 f0    	mov    %al,-0xfa83fe0(%edx)
				ncpu++;
f01069b8:	83 c0 01             	add    $0x1,%eax
f01069bb:	a3 c4 c3 57 f0       	mov    %eax,0xf057c3c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f01069c0:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01069c3:	83 c3 01             	add    $0x1,%ebx
f01069c6:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f01069ca:	39 d8                	cmp    %ebx,%eax
f01069cc:	76 4b                	jbe    f0106a19 <mp_init+0x256>
		switch (*p) {
f01069ce:	0f b6 07             	movzbl (%edi),%eax
f01069d1:	84 c0                	test   %al,%al
f01069d3:	74 b9                	je     f010698e <mp_init+0x1cb>
f01069d5:	3c 04                	cmp    $0x4,%al
f01069d7:	77 1c                	ja     f01069f5 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f01069d9:	83 c7 08             	add    $0x8,%edi
			continue;
f01069dc:	eb e5                	jmp    f01069c3 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f01069de:	83 ec 08             	sub    $0x8,%esp
f01069e1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f01069e5:	50                   	push   %eax
f01069e6:	68 cc 99 10 f0       	push   $0xf01099cc
f01069eb:	e8 7f d4 ff ff       	call   f0103e6f <cprintf>
f01069f0:	83 c4 10             	add    $0x10,%esp
f01069f3:	eb cb                	jmp    f01069c0 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f01069f5:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f01069f8:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f01069fb:	50                   	push   %eax
f01069fc:	68 f4 99 10 f0       	push   $0xf01099f4
f0106a01:	e8 69 d4 ff ff       	call   f0103e6f <cprintf>
			ismp = 0;
f0106a06:	c7 05 00 c0 57 f0 00 	movl   $0x0,0xf057c000
f0106a0d:	00 00 00 
			i = conf->entry;
f0106a10:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106a14:	83 c4 10             	add    $0x10,%esp
f0106a17:	eb aa                	jmp    f01069c3 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106a19:	a1 c0 c3 57 f0       	mov    0xf057c3c0,%eax
f0106a1e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106a25:	83 3d 00 c0 57 f0 00 	cmpl   $0x0,0xf057c000
f0106a2c:	74 2b                	je     f0106a59 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106a2e:	83 ec 04             	sub    $0x4,%esp
f0106a31:	ff 35 c4 c3 57 f0    	pushl  0xf057c3c4
f0106a37:	0f b6 00             	movzbl (%eax),%eax
f0106a3a:	50                   	push   %eax
f0106a3b:	68 9b 9a 10 f0       	push   $0xf0109a9b
f0106a40:	e8 2a d4 ff ff       	call   f0103e6f <cprintf>

	if (mp->imcrp) {
f0106a45:	83 c4 10             	add    $0x10,%esp
f0106a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106a4b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106a4f:	75 2e                	jne    f0106a7f <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106a54:	5b                   	pop    %ebx
f0106a55:	5e                   	pop    %esi
f0106a56:	5f                   	pop    %edi
f0106a57:	5d                   	pop    %ebp
f0106a58:	c3                   	ret    
		ncpu = 1;
f0106a59:	c7 05 c4 c3 57 f0 01 	movl   $0x1,0xf057c3c4
f0106a60:	00 00 00 
		lapicaddr = 0;
f0106a63:	c7 05 00 d0 5b f0 00 	movl   $0x0,0xf05bd000
f0106a6a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106a6d:	83 ec 0c             	sub    $0xc,%esp
f0106a70:	68 14 9a 10 f0       	push   $0xf0109a14
f0106a75:	e8 f5 d3 ff ff       	call   f0103e6f <cprintf>
		return;
f0106a7a:	83 c4 10             	add    $0x10,%esp
f0106a7d:	eb d2                	jmp    f0106a51 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106a7f:	83 ec 0c             	sub    $0xc,%esp
f0106a82:	68 40 9a 10 f0       	push   $0xf0109a40
f0106a87:	e8 e3 d3 ff ff       	call   f0103e6f <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106a8c:	b8 70 00 00 00       	mov    $0x70,%eax
f0106a91:	ba 22 00 00 00       	mov    $0x22,%edx
f0106a96:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106a97:	ba 23 00 00 00       	mov    $0x23,%edx
f0106a9c:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106a9d:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106aa0:	ee                   	out    %al,(%dx)
f0106aa1:	83 c4 10             	add    $0x10,%esp
f0106aa4:	eb ab                	jmp    f0106a51 <mp_init+0x28e>

f0106aa6 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106aa6:	8b 0d 04 d0 5b f0    	mov    0xf05bd004,%ecx
f0106aac:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106aaf:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106ab1:	a1 04 d0 5b f0       	mov    0xf05bd004,%eax
f0106ab6:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106ab9:	c3                   	ret    

f0106aba <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f0106aba:	8b 15 04 d0 5b f0    	mov    0xf05bd004,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f0106ac0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f0106ac5:	85 d2                	test   %edx,%edx
f0106ac7:	74 06                	je     f0106acf <cpunum+0x15>
		return lapic[ID] >> 24;
f0106ac9:	8b 42 20             	mov    0x20(%edx),%eax
f0106acc:	c1 e8 18             	shr    $0x18,%eax
}
f0106acf:	c3                   	ret    

f0106ad0 <lapic_init>:
	if (!lapicaddr)
f0106ad0:	a1 00 d0 5b f0       	mov    0xf05bd000,%eax
f0106ad5:	85 c0                	test   %eax,%eax
f0106ad7:	75 01                	jne    f0106ada <lapic_init+0xa>
f0106ad9:	c3                   	ret    
{
f0106ada:	55                   	push   %ebp
f0106adb:	89 e5                	mov    %esp,%ebp
f0106add:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106ae0:	68 00 10 00 00       	push   $0x1000
f0106ae5:	50                   	push   %eax
f0106ae6:	e8 06 ac ff ff       	call   f01016f1 <mmio_map_region>
f0106aeb:	a3 04 d0 5b f0       	mov    %eax,0xf05bd004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106af0:	ba 27 01 00 00       	mov    $0x127,%edx
f0106af5:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106afa:	e8 a7 ff ff ff       	call   f0106aa6 <lapicw>
	lapicw(TDCR, X1);
f0106aff:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106b04:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106b09:	e8 98 ff ff ff       	call   f0106aa6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106b0e:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106b13:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106b18:	e8 89 ff ff ff       	call   f0106aa6 <lapicw>
	lapicw(TICR, 10000000); 
f0106b1d:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106b22:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106b27:	e8 7a ff ff ff       	call   f0106aa6 <lapicw>
	if (thiscpu != bootcpu)
f0106b2c:	e8 89 ff ff ff       	call   f0106aba <cpunum>
f0106b31:	6b c0 74             	imul   $0x74,%eax,%eax
f0106b34:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0106b39:	83 c4 10             	add    $0x10,%esp
f0106b3c:	39 05 c0 c3 57 f0    	cmp    %eax,0xf057c3c0
f0106b42:	74 0f                	je     f0106b53 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106b44:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106b49:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106b4e:	e8 53 ff ff ff       	call   f0106aa6 <lapicw>
	lapicw(LINT1, MASKED);
f0106b53:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106b58:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106b5d:	e8 44 ff ff ff       	call   f0106aa6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106b62:	a1 04 d0 5b f0       	mov    0xf05bd004,%eax
f0106b67:	8b 40 30             	mov    0x30(%eax),%eax
f0106b6a:	c1 e8 10             	shr    $0x10,%eax
f0106b6d:	a8 fc                	test   $0xfc,%al
f0106b6f:	75 7c                	jne    f0106bed <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106b71:	ba 33 00 00 00       	mov    $0x33,%edx
f0106b76:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106b7b:	e8 26 ff ff ff       	call   f0106aa6 <lapicw>
	lapicw(ESR, 0);
f0106b80:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b85:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106b8a:	e8 17 ff ff ff       	call   f0106aa6 <lapicw>
	lapicw(ESR, 0);
f0106b8f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b94:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106b99:	e8 08 ff ff ff       	call   f0106aa6 <lapicw>
	lapicw(EOI, 0);
f0106b9e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ba3:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106ba8:	e8 f9 fe ff ff       	call   f0106aa6 <lapicw>
	lapicw(ICRHI, 0);
f0106bad:	ba 00 00 00 00       	mov    $0x0,%edx
f0106bb2:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106bb7:	e8 ea fe ff ff       	call   f0106aa6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106bbc:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106bc1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106bc6:	e8 db fe ff ff       	call   f0106aa6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106bcb:	8b 15 04 d0 5b f0    	mov    0xf05bd004,%edx
f0106bd1:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106bd7:	f6 c4 10             	test   $0x10,%ah
f0106bda:	75 f5                	jne    f0106bd1 <lapic_init+0x101>
	lapicw(TPR, 0);
f0106bdc:	ba 00 00 00 00       	mov    $0x0,%edx
f0106be1:	b8 20 00 00 00       	mov    $0x20,%eax
f0106be6:	e8 bb fe ff ff       	call   f0106aa6 <lapicw>
}
f0106beb:	c9                   	leave  
f0106bec:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106bed:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106bf2:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106bf7:	e8 aa fe ff ff       	call   f0106aa6 <lapicw>
f0106bfc:	e9 70 ff ff ff       	jmp    f0106b71 <lapic_init+0xa1>

f0106c01 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106c01:	83 3d 04 d0 5b f0 00 	cmpl   $0x0,0xf05bd004
f0106c08:	74 17                	je     f0106c21 <lapic_eoi+0x20>
{
f0106c0a:	55                   	push   %ebp
f0106c0b:	89 e5                	mov    %esp,%ebp
f0106c0d:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106c10:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c15:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106c1a:	e8 87 fe ff ff       	call   f0106aa6 <lapicw>
}
f0106c1f:	c9                   	leave  
f0106c20:	c3                   	ret    
f0106c21:	c3                   	ret    

f0106c22 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106c22:	55                   	push   %ebp
f0106c23:	89 e5                	mov    %esp,%ebp
f0106c25:	56                   	push   %esi
f0106c26:	53                   	push   %ebx
f0106c27:	8b 75 08             	mov    0x8(%ebp),%esi
f0106c2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106c2d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106c32:	ba 70 00 00 00       	mov    $0x70,%edx
f0106c37:	ee                   	out    %al,(%dx)
f0106c38:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106c3d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106c42:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106c43:	83 3d a8 be 57 f0 00 	cmpl   $0x0,0xf057bea8
f0106c4a:	74 7e                	je     f0106cca <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106c4c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106c53:	00 00 
	wrv[1] = addr >> 4;
f0106c55:	89 d8                	mov    %ebx,%eax
f0106c57:	c1 e8 04             	shr    $0x4,%eax
f0106c5a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106c60:	c1 e6 18             	shl    $0x18,%esi
f0106c63:	89 f2                	mov    %esi,%edx
f0106c65:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106c6a:	e8 37 fe ff ff       	call   f0106aa6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106c6f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106c74:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c79:	e8 28 fe ff ff       	call   f0106aa6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106c7e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106c83:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c88:	e8 19 fe ff ff       	call   f0106aa6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106c8d:	c1 eb 0c             	shr    $0xc,%ebx
f0106c90:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106c93:	89 f2                	mov    %esi,%edx
f0106c95:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106c9a:	e8 07 fe ff ff       	call   f0106aa6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106c9f:	89 da                	mov    %ebx,%edx
f0106ca1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106ca6:	e8 fb fd ff ff       	call   f0106aa6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106cab:	89 f2                	mov    %esi,%edx
f0106cad:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106cb2:	e8 ef fd ff ff       	call   f0106aa6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106cb7:	89 da                	mov    %ebx,%edx
f0106cb9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106cbe:	e8 e3 fd ff ff       	call   f0106aa6 <lapicw>
		microdelay(200);
	}
}
f0106cc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106cc6:	5b                   	pop    %ebx
f0106cc7:	5e                   	pop    %esi
f0106cc8:	5d                   	pop    %ebp
f0106cc9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106cca:	68 67 04 00 00       	push   $0x467
f0106ccf:	68 b4 78 10 f0       	push   $0xf01078b4
f0106cd4:	68 9c 00 00 00       	push   $0x9c
f0106cd9:	68 b8 9a 10 f0       	push   $0xf0109ab8
f0106cde:	e8 66 93 ff ff       	call   f0100049 <_panic>

f0106ce3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106ce3:	55                   	push   %ebp
f0106ce4:	89 e5                	mov    %esp,%ebp
f0106ce6:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106ce9:	8b 55 08             	mov    0x8(%ebp),%edx
f0106cec:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106cf2:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106cf7:	e8 aa fd ff ff       	call   f0106aa6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106cfc:	8b 15 04 d0 5b f0    	mov    0xf05bd004,%edx
f0106d02:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106d08:	f6 c4 10             	test   $0x10,%ah
f0106d0b:	75 f5                	jne    f0106d02 <lapic_ipi+0x1f>
		;
}
f0106d0d:	c9                   	leave  
f0106d0e:	c3                   	ret    

f0106d0f <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106d0f:	55                   	push   %ebp
f0106d10:	89 e5                	mov    %esp,%ebp
f0106d12:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106d15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106d1e:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106d21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106d28:	5d                   	pop    %ebp
f0106d29:	c3                   	ret    

f0106d2a <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106d2a:	55                   	push   %ebp
f0106d2b:	89 e5                	mov    %esp,%ebp
f0106d2d:	56                   	push   %esi
f0106d2e:	53                   	push   %ebx
f0106d2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106d32:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106d35:	75 12                	jne    f0106d49 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0106d37:	ba 01 00 00 00       	mov    $0x1,%edx
f0106d3c:	89 d0                	mov    %edx,%eax
f0106d3e:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106d41:	85 c0                	test   %eax,%eax
f0106d43:	74 36                	je     f0106d7b <spin_lock+0x51>
		asm volatile ("pause");
f0106d45:	f3 90                	pause  
f0106d47:	eb f3                	jmp    f0106d3c <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0106d49:	8b 73 08             	mov    0x8(%ebx),%esi
f0106d4c:	e8 69 fd ff ff       	call   f0106aba <cpunum>
f0106d51:	6b c0 74             	imul   $0x74,%eax,%eax
f0106d54:	05 20 c0 57 f0       	add    $0xf057c020,%eax
	if (holding(lk))
f0106d59:	39 c6                	cmp    %eax,%esi
f0106d5b:	75 da                	jne    f0106d37 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106d5d:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106d60:	e8 55 fd ff ff       	call   f0106aba <cpunum>
f0106d65:	83 ec 0c             	sub    $0xc,%esp
f0106d68:	53                   	push   %ebx
f0106d69:	50                   	push   %eax
f0106d6a:	68 c8 9a 10 f0       	push   $0xf0109ac8
f0106d6f:	6a 41                	push   $0x41
f0106d71:	68 2a 9b 10 f0       	push   $0xf0109b2a
f0106d76:	e8 ce 92 ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106d7b:	e8 3a fd ff ff       	call   f0106aba <cpunum>
f0106d80:	6b c0 74             	imul   $0x74,%eax,%eax
f0106d83:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0106d88:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0106d8b:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106d8d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106d92:	83 f8 09             	cmp    $0x9,%eax
f0106d95:	7f 16                	jg     f0106dad <spin_lock+0x83>
f0106d97:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106d9d:	76 0e                	jbe    f0106dad <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106d9f:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106da2:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106da6:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106da8:	83 c0 01             	add    $0x1,%eax
f0106dab:	eb e5                	jmp    f0106d92 <spin_lock+0x68>
	for (; i < 10; i++)
f0106dad:	83 f8 09             	cmp    $0x9,%eax
f0106db0:	7f 0d                	jg     f0106dbf <spin_lock+0x95>
		pcs[i] = 0;
f0106db2:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106db9:	00 
	for (; i < 10; i++)
f0106dba:	83 c0 01             	add    $0x1,%eax
f0106dbd:	eb ee                	jmp    f0106dad <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106dc2:	5b                   	pop    %ebx
f0106dc3:	5e                   	pop    %esi
f0106dc4:	5d                   	pop    %ebp
f0106dc5:	c3                   	ret    

f0106dc6 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106dc6:	55                   	push   %ebp
f0106dc7:	89 e5                	mov    %esp,%ebp
f0106dc9:	57                   	push   %edi
f0106dca:	56                   	push   %esi
f0106dcb:	53                   	push   %ebx
f0106dcc:	83 ec 4c             	sub    $0x4c,%esp
f0106dcf:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106dd2:	83 3e 00             	cmpl   $0x0,(%esi)
f0106dd5:	75 35                	jne    f0106e0c <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106dd7:	83 ec 04             	sub    $0x4,%esp
f0106dda:	6a 28                	push   $0x28
f0106ddc:	8d 46 0c             	lea    0xc(%esi),%eax
f0106ddf:	50                   	push   %eax
f0106de0:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106de3:	53                   	push   %ebx
f0106de4:	e8 12 f7 ff ff       	call   f01064fb <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106de9:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106dec:	0f b6 38             	movzbl (%eax),%edi
f0106def:	8b 76 04             	mov    0x4(%esi),%esi
f0106df2:	e8 c3 fc ff ff       	call   f0106aba <cpunum>
f0106df7:	57                   	push   %edi
f0106df8:	56                   	push   %esi
f0106df9:	50                   	push   %eax
f0106dfa:	68 f4 9a 10 f0       	push   $0xf0109af4
f0106dff:	e8 6b d0 ff ff       	call   f0103e6f <cprintf>
f0106e04:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106e07:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106e0a:	eb 4e                	jmp    f0106e5a <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0106e0c:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106e0f:	e8 a6 fc ff ff       	call   f0106aba <cpunum>
f0106e14:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e17:	05 20 c0 57 f0       	add    $0xf057c020,%eax
	if (!holding(lk)) {
f0106e1c:	39 c3                	cmp    %eax,%ebx
f0106e1e:	75 b7                	jne    f0106dd7 <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0106e20:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106e27:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106e2e:	b8 00 00 00 00       	mov    $0x0,%eax
f0106e33:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106e39:	5b                   	pop    %ebx
f0106e3a:	5e                   	pop    %esi
f0106e3b:	5f                   	pop    %edi
f0106e3c:	5d                   	pop    %ebp
f0106e3d:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106e3e:	83 ec 08             	sub    $0x8,%esp
f0106e41:	ff 36                	pushl  (%esi)
f0106e43:	68 51 9b 10 f0       	push   $0xf0109b51
f0106e48:	e8 22 d0 ff ff       	call   f0103e6f <cprintf>
f0106e4d:	83 c4 10             	add    $0x10,%esp
f0106e50:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106e53:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106e56:	39 c3                	cmp    %eax,%ebx
f0106e58:	74 40                	je     f0106e9a <spin_unlock+0xd4>
f0106e5a:	89 de                	mov    %ebx,%esi
f0106e5c:	8b 03                	mov    (%ebx),%eax
f0106e5e:	85 c0                	test   %eax,%eax
f0106e60:	74 38                	je     f0106e9a <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106e62:	83 ec 08             	sub    $0x8,%esp
f0106e65:	57                   	push   %edi
f0106e66:	50                   	push   %eax
f0106e67:	e8 e0 e9 ff ff       	call   f010584c <debuginfo_eip>
f0106e6c:	83 c4 10             	add    $0x10,%esp
f0106e6f:	85 c0                	test   %eax,%eax
f0106e71:	78 cb                	js     f0106e3e <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106e73:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106e75:	83 ec 04             	sub    $0x4,%esp
f0106e78:	89 c2                	mov    %eax,%edx
f0106e7a:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106e7d:	52                   	push   %edx
f0106e7e:	ff 75 b0             	pushl  -0x50(%ebp)
f0106e81:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106e84:	ff 75 ac             	pushl  -0x54(%ebp)
f0106e87:	ff 75 a8             	pushl  -0x58(%ebp)
f0106e8a:	50                   	push   %eax
f0106e8b:	68 3a 9b 10 f0       	push   $0xf0109b3a
f0106e90:	e8 da cf ff ff       	call   f0103e6f <cprintf>
f0106e95:	83 c4 20             	add    $0x20,%esp
f0106e98:	eb b6                	jmp    f0106e50 <spin_unlock+0x8a>
		panic("spin_unlock");
f0106e9a:	83 ec 04             	sub    $0x4,%esp
f0106e9d:	68 59 9b 10 f0       	push   $0xf0109b59
f0106ea2:	6a 67                	push   $0x67
f0106ea4:	68 2a 9b 10 f0       	push   $0xf0109b2a
f0106ea9:	e8 9b 91 ff ff       	call   f0100049 <_panic>

f0106eae <e1000_tx_init>:
    ptr->status |= E1000_TX_STATUS_DD;
}

int
e1000_tx_init()
{
f0106eae:	55                   	push   %ebp
f0106eaf:	89 e5                	mov    %esp,%ebp
f0106eb1:	57                   	push   %edi
f0106eb2:	56                   	push   %esi
f0106eb3:	53                   	push   %ebx
f0106eb4:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
f0106eb7:	68 bc 9b 10 f0       	push   $0xf0109bbc
f0106ebc:	68 71 9b 10 f0       	push   $0xf0109b71
f0106ec1:	e8 a9 cf ff ff       	call   f0103e6f <cprintf>
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0106ec6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0106ecd:	e8 01 a4 ff ff       	call   f01012d3 <page_alloc>
	if(page == NULL)
f0106ed2:	83 c4 10             	add    $0x10,%esp
f0106ed5:	85 c0                	test   %eax,%eax
f0106ed7:	0f 84 0a 01 00 00    	je     f0106fe7 <e1000_tx_init+0x139>
	return (pp - pages) << PGSHIFT;
f0106edd:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0106ee3:	c1 f8 03             	sar    $0x3,%eax
f0106ee6:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0106ee9:	89 c2                	mov    %eax,%edx
f0106eeb:	c1 ea 0c             	shr    $0xc,%edx
f0106eee:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0106ef4:	0f 83 01 01 00 00    	jae    f0106ffb <e1000_tx_init+0x14d>
	return (void *)(pa + KERNBASE);
f0106efa:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0106eff:	a3 20 d0 5b f0       	mov    %eax,0xf05bd020
f0106f04:	ba 40 d0 5b f0       	mov    $0xf05bd040,%edx
f0106f09:	b8 40 d0 5b 00       	mov    $0x5bd040,%eax
f0106f0e:	89 c6                	mov    %eax,%esi
f0106f10:	bf 00 00 00 00       	mov    $0x0,%edi
			panic("page_alloc panic\n");
	// r = page_insert(kern_pgdir, page, page2kva(page), PTE_P|PTE_U|PTE_W|PTE_PCD|PTE_PWT);
	// if(r < 0)
		// panic("page insert panic\n");
	tx_descs = (struct tx_desc *)page2kva(page);
f0106f15:	b9 00 00 00 00       	mov    $0x0,%ecx
	if ((uint32_t)kva < KERNBASE)
f0106f1a:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0106f20:	0f 86 e7 00 00 00    	jbe    f010700d <e1000_tx_init+0x15f>
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(&tx_buffer[i]);
f0106f26:	a1 20 d0 5b f0       	mov    0xf05bd020,%eax
f0106f2b:	89 34 08             	mov    %esi,(%eax,%ecx,1)
f0106f2e:	89 7c 08 04          	mov    %edi,0x4(%eax,%ecx,1)
		tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0106f32:	8b 1d 20 d0 5b f0    	mov    0xf05bd020,%ebx
f0106f38:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
f0106f3b:	80 48 0b 05          	orb    $0x5,0xb(%eax)
		tx_descs[i].status |= E1000_TX_STATUS_DD;
f0106f3f:	80 48 0c 01          	orb    $0x1,0xc(%eax)
		tx_descs[i].length = 0;
f0106f43:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		tx_descs[i].cso = 0;
f0106f49:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
		tx_descs[i].css = 0;
f0106f4d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
		tx_descs[i].special = 0;
f0106f51:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
f0106f57:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f0106f5d:	83 c1 10             	add    $0x10,%ecx
f0106f60:	81 c6 ee 05 00 00    	add    $0x5ee,%esi
f0106f66:	83 d7 00             	adc    $0x0,%edi
	for(int i = 0; i < N_TXDESC; i++){
f0106f69:	81 fa 40 be 61 f0    	cmp    $0xf061be40,%edx
f0106f6f:	75 a9                	jne    f0106f1a <e1000_tx_init+0x6c>
	}
	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->TDBAL = PADDR(tx_descs);
f0106f71:	a1 80 ae 57 f0       	mov    0xf057ae80,%eax
f0106f76:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0106f7c:	0f 86 9d 00 00 00    	jbe    f010701f <e1000_tx_init+0x171>
	return (physaddr_t)kva - KERNBASE;
f0106f82:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f0106f88:	89 98 00 38 00 00    	mov    %ebx,0x3800(%eax)
	base->TDBAH = (uint32_t)0;
f0106f8e:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f0106f95:	00 00 00 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 
f0106f98:	c7 80 08 38 00 00 00 	movl   $0x1000,0x3808(%eax)
f0106f9f:	10 00 00 

	base->TDH = 0;
f0106fa2:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f0106fa9:	00 00 00 
	base->TDT = 0;
f0106fac:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f0106fb3:	00 00 00 
	base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
f0106fb6:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0106fbc:	81 ca 0a 01 04 00    	or     $0x4010a,%edx
f0106fc2:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	base->TIPG |= E1000_TIPG_DEFAULT;
f0106fc8:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
f0106fce:	81 ca 0a 10 60 00    	or     $0x60100a,%edx
f0106fd4:	89 90 10 04 00 00    	mov    %edx,0x410(%eax)
	return 0;
}
f0106fda:	b8 00 00 00 00       	mov    $0x0,%eax
f0106fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106fe2:	5b                   	pop    %ebx
f0106fe3:	5e                   	pop    %esi
f0106fe4:	5f                   	pop    %edi
f0106fe5:	5d                   	pop    %ebp
f0106fe6:	c3                   	ret    
			panic("page_alloc panic\n");
f0106fe7:	83 ec 04             	sub    $0x4,%esp
f0106fea:	68 78 9b 10 f0       	push   $0xf0109b78
f0106fef:	6a 19                	push   $0x19
f0106ff1:	68 8a 9b 10 f0       	push   $0xf0109b8a
f0106ff6:	e8 4e 90 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106ffb:	50                   	push   %eax
f0106ffc:	68 b4 78 10 f0       	push   $0xf01078b4
f0107001:	6a 58                	push   $0x58
f0107003:	68 51 8a 10 f0       	push   $0xf0108a51
f0107008:	e8 3c 90 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010700d:	52                   	push   %edx
f010700e:	68 d8 78 10 f0       	push   $0xf01078d8
f0107013:	6a 20                	push   $0x20
f0107015:	68 8a 9b 10 f0       	push   $0xf0109b8a
f010701a:	e8 2a 90 ff ff       	call   f0100049 <_panic>
f010701f:	53                   	push   %ebx
f0107020:	68 d8 78 10 f0       	push   $0xf01078d8
f0107025:	6a 2b                	push   $0x2b
f0107027:	68 8a 9b 10 f0       	push   $0xf0109b8a
f010702c:	e8 18 90 ff ff       	call   f0100049 <_panic>

f0107031 <e1000_rx_init>:
struct rx_desc *rx_descs;
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))

int
e1000_rx_init()
{
f0107031:	55                   	push   %ebp
f0107032:	89 e5                	mov    %esp,%ebp
f0107034:	83 ec 10             	sub    $0x10,%esp
	cprintf("in %s\n", __FUNCTION__);
f0107037:	68 ac 9b 10 f0       	push   $0xf0109bac
f010703c:	68 71 9b 10 f0       	push   $0xf0109b71
f0107041:	e8 29 ce ff ff       	call   f0103e6f <cprintf>
	// base->RDLEN = N_RXDESC * sizeof(struct rx_desc); 

	// base->RDH = 0;
	// base->RDT = 0;
	return 0;
}
f0107046:	b8 00 00 00 00       	mov    $0x0,%eax
f010704b:	c9                   	leave  
f010704c:	c3                   	ret    

f010704d <pci_e1000_attach>:

int
pci_e1000_attach(struct pci_func *pcif)
{
f010704d:	55                   	push   %ebp
f010704e:	89 e5                	mov    %esp,%ebp
f0107050:	53                   	push   %ebx
f0107051:	83 ec 0c             	sub    $0xc,%esp
f0107054:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0107057:	68 98 9b 10 f0       	push   $0xf0109b98
f010705c:	68 71 9b 10 f0       	push   $0xf0109b71
f0107061:	e8 09 ce ff ff       	call   f0103e6f <cprintf>
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
f0107066:	89 1c 24             	mov    %ebx,(%esp)
f0107069:	e8 fe 03 00 00       	call   f010746c <pci_func_enable>
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f010706e:	83 c4 08             	add    $0x8,%esp
f0107071:	ff 73 2c             	pushl  0x2c(%ebx)
f0107074:	ff 73 14             	pushl  0x14(%ebx)
f0107077:	e8 75 a6 ff ff       	call   f01016f1 <mmio_map_region>
f010707c:	a3 80 ae 57 f0       	mov    %eax,0xf057ae80
	e1000_tx_init();
f0107081:	e8 28 fe ff ff       	call   f0106eae <e1000_tx_init>
	e1000_rx_init();
f0107086:	e8 a6 ff ff ff       	call   f0107031 <e1000_rx_init>
	return 0;
}
f010708b:	b8 00 00 00 00       	mov    $0x0,%eax
f0107090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107093:	c9                   	leave  
f0107094:	c3                   	ret    

f0107095 <e1000_tx>:
{
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address

	return 0;
}
f0107095:	b8 00 00 00 00       	mov    $0x0,%eax
f010709a:	c3                   	ret    

f010709b <e1000_rx>:
	// the packet
	// Do not forget to reset the decscriptor and
	// give it back to hardware by modifying RDT

	return 0;
}
f010709b:	b8 00 00 00 00       	mov    $0x0,%eax
f01070a0:	c3                   	ret    

f01070a1 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f01070a1:	55                   	push   %ebp
f01070a2:	89 e5                	mov    %esp,%ebp
f01070a4:	57                   	push   %edi
f01070a5:	56                   	push   %esi
f01070a6:	53                   	push   %ebx
f01070a7:	83 ec 0c             	sub    $0xc,%esp
f01070aa:	8b 7d 08             	mov    0x8(%ebp),%edi
f01070ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f01070b0:	eb 03                	jmp    f01070b5 <pci_attach_match+0x14>
f01070b2:	83 c3 0c             	add    $0xc,%ebx
f01070b5:	89 de                	mov    %ebx,%esi
f01070b7:	8b 43 08             	mov    0x8(%ebx),%eax
f01070ba:	85 c0                	test   %eax,%eax
f01070bc:	74 37                	je     f01070f5 <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f01070be:	39 3b                	cmp    %edi,(%ebx)
f01070c0:	75 f0                	jne    f01070b2 <pci_attach_match+0x11>
f01070c2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01070c5:	39 56 04             	cmp    %edx,0x4(%esi)
f01070c8:	75 e8                	jne    f01070b2 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f01070ca:	83 ec 0c             	sub    $0xc,%esp
f01070cd:	ff 75 14             	pushl  0x14(%ebp)
f01070d0:	ff d0                	call   *%eax
			if (r > 0)
f01070d2:	83 c4 10             	add    $0x10,%esp
f01070d5:	85 c0                	test   %eax,%eax
f01070d7:	7f 1c                	jg     f01070f5 <pci_attach_match+0x54>
				return r;
			if (r < 0)
f01070d9:	79 d7                	jns    f01070b2 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f01070db:	83 ec 0c             	sub    $0xc,%esp
f01070de:	50                   	push   %eax
f01070df:	ff 76 08             	pushl  0x8(%esi)
f01070e2:	ff 75 0c             	pushl  0xc(%ebp)
f01070e5:	57                   	push   %edi
f01070e6:	68 cc 9b 10 f0       	push   $0xf0109bcc
f01070eb:	e8 7f cd ff ff       	call   f0103e6f <cprintf>
f01070f0:	83 c4 20             	add    $0x20,%esp
f01070f3:	eb bd                	jmp    f01070b2 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f01070f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01070f8:	5b                   	pop    %ebx
f01070f9:	5e                   	pop    %esi
f01070fa:	5f                   	pop    %edi
f01070fb:	5d                   	pop    %ebp
f01070fc:	c3                   	ret    

f01070fd <pci_conf1_set_addr>:
{
f01070fd:	55                   	push   %ebp
f01070fe:	89 e5                	mov    %esp,%ebp
f0107100:	53                   	push   %ebx
f0107101:	83 ec 04             	sub    $0x4,%esp
f0107104:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0107107:	3d ff 00 00 00       	cmp    $0xff,%eax
f010710c:	77 36                	ja     f0107144 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f010710e:	83 fa 1f             	cmp    $0x1f,%edx
f0107111:	77 47                	ja     f010715a <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f0107113:	83 f9 07             	cmp    $0x7,%ecx
f0107116:	77 58                	ja     f0107170 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f0107118:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f010711e:	77 66                	ja     f0107186 <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f0107120:	f6 c3 03             	test   $0x3,%bl
f0107123:	75 77                	jne    f010719c <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0107125:	c1 e0 10             	shl    $0x10,%eax
f0107128:	09 d8                	or     %ebx,%eax
f010712a:	c1 e1 08             	shl    $0x8,%ecx
f010712d:	09 c8                	or     %ecx,%eax
f010712f:	c1 e2 0b             	shl    $0xb,%edx
f0107132:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f0107134:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107139:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f010713e:	ef                   	out    %eax,(%dx)
}
f010713f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107142:	c9                   	leave  
f0107143:	c3                   	ret    
	assert(bus < 256);
f0107144:	68 24 9d 10 f0       	push   $0xf0109d24
f0107149:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010714e:	6a 2c                	push   $0x2c
f0107150:	68 2e 9d 10 f0       	push   $0xf0109d2e
f0107155:	e8 ef 8e ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f010715a:	68 39 9d 10 f0       	push   $0xf0109d39
f010715f:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0107164:	6a 2d                	push   $0x2d
f0107166:	68 2e 9d 10 f0       	push   $0xf0109d2e
f010716b:	e8 d9 8e ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f0107170:	68 42 9d 10 f0       	push   $0xf0109d42
f0107175:	68 6b 8a 10 f0       	push   $0xf0108a6b
f010717a:	6a 2e                	push   $0x2e
f010717c:	68 2e 9d 10 f0       	push   $0xf0109d2e
f0107181:	e8 c3 8e ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f0107186:	68 4b 9d 10 f0       	push   $0xf0109d4b
f010718b:	68 6b 8a 10 f0       	push   $0xf0108a6b
f0107190:	6a 2f                	push   $0x2f
f0107192:	68 2e 9d 10 f0       	push   $0xf0109d2e
f0107197:	e8 ad 8e ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f010719c:	68 58 9d 10 f0       	push   $0xf0109d58
f01071a1:	68 6b 8a 10 f0       	push   $0xf0108a6b
f01071a6:	6a 30                	push   $0x30
f01071a8:	68 2e 9d 10 f0       	push   $0xf0109d2e
f01071ad:	e8 97 8e ff ff       	call   f0100049 <_panic>

f01071b2 <pci_conf_read>:
{
f01071b2:	55                   	push   %ebp
f01071b3:	89 e5                	mov    %esp,%ebp
f01071b5:	53                   	push   %ebx
f01071b6:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01071b9:	8b 48 08             	mov    0x8(%eax),%ecx
f01071bc:	8b 58 04             	mov    0x4(%eax),%ebx
f01071bf:	8b 00                	mov    (%eax),%eax
f01071c1:	8b 40 04             	mov    0x4(%eax),%eax
f01071c4:	52                   	push   %edx
f01071c5:	89 da                	mov    %ebx,%edx
f01071c7:	e8 31 ff ff ff       	call   f01070fd <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f01071cc:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01071d1:	ed                   	in     (%dx),%eax
}
f01071d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01071d5:	c9                   	leave  
f01071d6:	c3                   	ret    

f01071d7 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f01071d7:	55                   	push   %ebp
f01071d8:	89 e5                	mov    %esp,%ebp
f01071da:	57                   	push   %edi
f01071db:	56                   	push   %esi
f01071dc:	53                   	push   %ebx
f01071dd:	81 ec 00 01 00 00    	sub    $0x100,%esp
f01071e3:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f01071e5:	6a 48                	push   $0x48
f01071e7:	6a 00                	push   $0x0
f01071e9:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01071ec:	50                   	push   %eax
f01071ed:	e8 c1 f2 ff ff       	call   f01064b3 <memset>
	df.bus = bus;
f01071f2:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f01071f5:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01071fc:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f01071ff:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0107206:	00 00 00 
f0107209:	e9 25 01 00 00       	jmp    f0107333 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010720e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107214:	83 ec 08             	sub    $0x8,%esp
f0107217:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f010721b:	57                   	push   %edi
f010721c:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f010721d:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107220:	0f b6 c0             	movzbl %al,%eax
f0107223:	50                   	push   %eax
f0107224:	51                   	push   %ecx
f0107225:	89 d0                	mov    %edx,%eax
f0107227:	c1 e8 10             	shr    $0x10,%eax
f010722a:	50                   	push   %eax
f010722b:	0f b7 d2             	movzwl %dx,%edx
f010722e:	52                   	push   %edx
f010722f:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0107235:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f010723b:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107241:	ff 70 04             	pushl  0x4(%eax)
f0107244:	68 f8 9b 10 f0       	push   $0xf0109bf8
f0107249:	e8 21 cc ff ff       	call   f0103e6f <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f010724e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107254:	83 c4 30             	add    $0x30,%esp
f0107257:	53                   	push   %ebx
f0107258:	68 0c 74 12 f0       	push   $0xf012740c
				 PCI_SUBCLASS(f->dev_class),
f010725d:	89 c2                	mov    %eax,%edx
f010725f:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107262:	0f b6 d2             	movzbl %dl,%edx
f0107265:	52                   	push   %edx
f0107266:	c1 e8 18             	shr    $0x18,%eax
f0107269:	50                   	push   %eax
f010726a:	e8 32 fe ff ff       	call   f01070a1 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f010726f:	83 c4 10             	add    $0x10,%esp
f0107272:	85 c0                	test   %eax,%eax
f0107274:	0f 84 88 00 00 00    	je     f0107302 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f010727a:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107281:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0107287:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f010728d:	0f 83 92 00 00 00    	jae    f0107325 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f0107293:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f0107299:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f010729f:	b9 12 00 00 00       	mov    $0x12,%ecx
f01072a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f01072a6:	ba 00 00 00 00       	mov    $0x0,%edx
f01072ab:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f01072b1:	e8 fc fe ff ff       	call   f01071b2 <pci_conf_read>
f01072b6:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f01072bc:	66 83 f8 ff          	cmp    $0xffff,%ax
f01072c0:	74 b8                	je     f010727a <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01072c2:	ba 3c 00 00 00       	mov    $0x3c,%edx
f01072c7:	89 d8                	mov    %ebx,%eax
f01072c9:	e8 e4 fe ff ff       	call   f01071b2 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f01072ce:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f01072d1:	ba 08 00 00 00       	mov    $0x8,%edx
f01072d6:	89 d8                	mov    %ebx,%eax
f01072d8:	e8 d5 fe ff ff       	call   f01071b2 <pci_conf_read>
f01072dd:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f01072e3:	89 c1                	mov    %eax,%ecx
f01072e5:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f01072e8:	be 6c 9d 10 f0       	mov    $0xf0109d6c,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f01072ed:	83 f9 06             	cmp    $0x6,%ecx
f01072f0:	0f 87 18 ff ff ff    	ja     f010720e <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f01072f6:	8b 34 8d e0 9d 10 f0 	mov    -0xfef6220(,%ecx,4),%esi
f01072fd:	e9 0c ff ff ff       	jmp    f010720e <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0107302:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107308:	53                   	push   %ebx
f0107309:	68 f4 73 12 f0       	push   $0xf01273f4
f010730e:	89 c2                	mov    %eax,%edx
f0107310:	c1 ea 10             	shr    $0x10,%edx
f0107313:	52                   	push   %edx
f0107314:	0f b7 c0             	movzwl %ax,%eax
f0107317:	50                   	push   %eax
f0107318:	e8 84 fd ff ff       	call   f01070a1 <pci_attach_match>
f010731d:	83 c4 10             	add    $0x10,%esp
f0107320:	e9 55 ff ff ff       	jmp    f010727a <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107325:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107328:	83 c0 01             	add    $0x1,%eax
f010732b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f010732e:	83 f8 1f             	cmp    $0x1f,%eax
f0107331:	77 59                	ja     f010738c <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107333:	ba 0c 00 00 00       	mov    $0xc,%edx
f0107338:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010733b:	e8 72 fe ff ff       	call   f01071b2 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107340:	89 c2                	mov    %eax,%edx
f0107342:	c1 ea 10             	shr    $0x10,%edx
f0107345:	f6 c2 7e             	test   $0x7e,%dl
f0107348:	75 db                	jne    f0107325 <pci_scan_bus+0x14e>
		totaldev++;
f010734a:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0107351:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107357:	8d 75 a0             	lea    -0x60(%ebp),%esi
f010735a:	b9 12 00 00 00       	mov    $0x12,%ecx
f010735f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107361:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107368:	00 00 00 
f010736b:	25 00 00 80 00       	and    $0x800000,%eax
f0107370:	83 f8 01             	cmp    $0x1,%eax
f0107373:	19 c0                	sbb    %eax,%eax
f0107375:	83 e0 f9             	and    $0xfffffff9,%eax
f0107378:	83 c0 08             	add    $0x8,%eax
f010737b:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107381:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107387:	e9 f5 fe ff ff       	jmp    f0107281 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f010738c:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107392:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107395:	5b                   	pop    %ebx
f0107396:	5e                   	pop    %esi
f0107397:	5f                   	pop    %edi
f0107398:	5d                   	pop    %ebp
f0107399:	c3                   	ret    

f010739a <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f010739a:	55                   	push   %ebp
f010739b:	89 e5                	mov    %esp,%ebp
f010739d:	57                   	push   %edi
f010739e:	56                   	push   %esi
f010739f:	53                   	push   %ebx
f01073a0:	83 ec 1c             	sub    $0x1c,%esp
f01073a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01073a6:	ba 1c 00 00 00       	mov    $0x1c,%edx
f01073ab:	89 d8                	mov    %ebx,%eax
f01073ad:	e8 00 fe ff ff       	call   f01071b2 <pci_conf_read>
f01073b2:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f01073b4:	ba 18 00 00 00       	mov    $0x18,%edx
f01073b9:	89 d8                	mov    %ebx,%eax
f01073bb:	e8 f2 fd ff ff       	call   f01071b2 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f01073c0:	83 e7 0f             	and    $0xf,%edi
f01073c3:	83 ff 01             	cmp    $0x1,%edi
f01073c6:	74 56                	je     f010741e <pci_bridge_attach+0x84>
f01073c8:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01073ca:	83 ec 04             	sub    $0x4,%esp
f01073cd:	6a 08                	push   $0x8
f01073cf:	6a 00                	push   $0x0
f01073d1:	8d 7d e0             	lea    -0x20(%ebp),%edi
f01073d4:	57                   	push   %edi
f01073d5:	e8 d9 f0 ff ff       	call   f01064b3 <memset>
	nbus.parent_bridge = pcif;
f01073da:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f01073dd:	89 f0                	mov    %esi,%eax
f01073df:	0f b6 c4             	movzbl %ah,%eax
f01073e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f01073e5:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f01073e8:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f01073eb:	89 f1                	mov    %esi,%ecx
f01073ed:	0f b6 f1             	movzbl %cl,%esi
f01073f0:	56                   	push   %esi
f01073f1:	50                   	push   %eax
f01073f2:	ff 73 08             	pushl  0x8(%ebx)
f01073f5:	ff 73 04             	pushl  0x4(%ebx)
f01073f8:	8b 03                	mov    (%ebx),%eax
f01073fa:	ff 70 04             	pushl  0x4(%eax)
f01073fd:	68 68 9c 10 f0       	push   $0xf0109c68
f0107402:	e8 68 ca ff ff       	call   f0103e6f <cprintf>

	pci_scan_bus(&nbus);
f0107407:	83 c4 20             	add    $0x20,%esp
f010740a:	89 f8                	mov    %edi,%eax
f010740c:	e8 c6 fd ff ff       	call   f01071d7 <pci_scan_bus>
	return 1;
f0107411:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107416:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107419:	5b                   	pop    %ebx
f010741a:	5e                   	pop    %esi
f010741b:	5f                   	pop    %edi
f010741c:	5d                   	pop    %ebp
f010741d:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f010741e:	ff 73 08             	pushl  0x8(%ebx)
f0107421:	ff 73 04             	pushl  0x4(%ebx)
f0107424:	8b 03                	mov    (%ebx),%eax
f0107426:	ff 70 04             	pushl  0x4(%eax)
f0107429:	68 34 9c 10 f0       	push   $0xf0109c34
f010742e:	e8 3c ca ff ff       	call   f0103e6f <cprintf>
		return 0;
f0107433:	83 c4 10             	add    $0x10,%esp
f0107436:	b8 00 00 00 00       	mov    $0x0,%eax
f010743b:	eb d9                	jmp    f0107416 <pci_bridge_attach+0x7c>

f010743d <pci_conf_write>:
{
f010743d:	55                   	push   %ebp
f010743e:	89 e5                	mov    %esp,%ebp
f0107440:	56                   	push   %esi
f0107441:	53                   	push   %ebx
f0107442:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107444:	8b 48 08             	mov    0x8(%eax),%ecx
f0107447:	8b 70 04             	mov    0x4(%eax),%esi
f010744a:	8b 00                	mov    (%eax),%eax
f010744c:	8b 40 04             	mov    0x4(%eax),%eax
f010744f:	83 ec 0c             	sub    $0xc,%esp
f0107452:	52                   	push   %edx
f0107453:	89 f2                	mov    %esi,%edx
f0107455:	e8 a3 fc ff ff       	call   f01070fd <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010745a:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f010745f:	89 d8                	mov    %ebx,%eax
f0107461:	ef                   	out    %eax,(%dx)
}
f0107462:	83 c4 10             	add    $0x10,%esp
f0107465:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107468:	5b                   	pop    %ebx
f0107469:	5e                   	pop    %esi
f010746a:	5d                   	pop    %ebp
f010746b:	c3                   	ret    

f010746c <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f010746c:	55                   	push   %ebp
f010746d:	89 e5                	mov    %esp,%ebp
f010746f:	57                   	push   %edi
f0107470:	56                   	push   %esi
f0107471:	53                   	push   %ebx
f0107472:	83 ec 2c             	sub    $0x2c,%esp
f0107475:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107478:	b9 07 00 00 00       	mov    $0x7,%ecx
f010747d:	ba 04 00 00 00       	mov    $0x4,%edx
f0107482:	89 f8                	mov    %edi,%eax
f0107484:	e8 b4 ff ff ff       	call   f010743d <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107489:	be 10 00 00 00       	mov    $0x10,%esi
f010748e:	eb 27                	jmp    f01074b7 <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107490:	89 c3                	mov    %eax,%ebx
f0107492:	83 e3 fc             	and    $0xfffffffc,%ebx
f0107495:	f7 db                	neg    %ebx
f0107497:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107499:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010749c:	83 e0 fc             	and    $0xfffffffc,%eax
f010749f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f01074a2:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f01074a9:	eb 74                	jmp    f010751f <pci_func_enable+0xb3>
	     bar += bar_width)
f01074ab:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01074ae:	83 fe 27             	cmp    $0x27,%esi
f01074b1:	0f 87 c5 00 00 00    	ja     f010757c <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f01074b7:	89 f2                	mov    %esi,%edx
f01074b9:	89 f8                	mov    %edi,%eax
f01074bb:	e8 f2 fc ff ff       	call   f01071b2 <pci_conf_read>
f01074c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f01074c3:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01074c8:	89 f2                	mov    %esi,%edx
f01074ca:	89 f8                	mov    %edi,%eax
f01074cc:	e8 6c ff ff ff       	call   f010743d <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f01074d1:	89 f2                	mov    %esi,%edx
f01074d3:	89 f8                	mov    %edi,%eax
f01074d5:	e8 d8 fc ff ff       	call   f01071b2 <pci_conf_read>
		bar_width = 4;
f01074da:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f01074e1:	85 c0                	test   %eax,%eax
f01074e3:	74 c6                	je     f01074ab <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f01074e5:	8d 4e f0             	lea    -0x10(%esi),%ecx
f01074e8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01074eb:	c1 e9 02             	shr    $0x2,%ecx
f01074ee:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f01074f1:	a8 01                	test   $0x1,%al
f01074f3:	75 9b                	jne    f0107490 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f01074f5:	89 c2                	mov    %eax,%edx
f01074f7:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f01074fa:	83 fa 04             	cmp    $0x4,%edx
f01074fd:	0f 94 c1             	sete   %cl
f0107500:	0f b6 c9             	movzbl %cl,%ecx
f0107503:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f010750a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f010750d:	89 c3                	mov    %eax,%ebx
f010750f:	83 e3 f0             	and    $0xfffffff0,%ebx
f0107512:	f7 db                	neg    %ebx
f0107514:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107516:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107519:	83 e0 f0             	and    $0xfffffff0,%eax
f010751c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f010751f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0107522:	89 f2                	mov    %esi,%edx
f0107524:	89 f8                	mov    %edi,%eax
f0107526:	e8 12 ff ff ff       	call   f010743d <pci_conf_write>
f010752b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010752e:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0107530:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107533:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0107536:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f0107539:	85 db                	test   %ebx,%ebx
f010753b:	0f 84 6a ff ff ff    	je     f01074ab <pci_func_enable+0x3f>
f0107541:	85 d2                	test   %edx,%edx
f0107543:	0f 85 62 ff ff ff    	jne    f01074ab <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107549:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f010754c:	83 ec 0c             	sub    $0xc,%esp
f010754f:	53                   	push   %ebx
f0107550:	6a 00                	push   $0x0
f0107552:	ff 75 d4             	pushl  -0x2c(%ebp)
f0107555:	89 c2                	mov    %eax,%edx
f0107557:	c1 ea 10             	shr    $0x10,%edx
f010755a:	52                   	push   %edx
f010755b:	0f b7 c0             	movzwl %ax,%eax
f010755e:	50                   	push   %eax
f010755f:	ff 77 08             	pushl  0x8(%edi)
f0107562:	ff 77 04             	pushl  0x4(%edi)
f0107565:	8b 07                	mov    (%edi),%eax
f0107567:	ff 70 04             	pushl  0x4(%eax)
f010756a:	68 98 9c 10 f0       	push   $0xf0109c98
f010756f:	e8 fb c8 ff ff       	call   f0103e6f <cprintf>
f0107574:	83 c4 30             	add    $0x30,%esp
f0107577:	e9 2f ff ff ff       	jmp    f01074ab <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f010757c:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f010757f:	83 ec 08             	sub    $0x8,%esp
f0107582:	89 c2                	mov    %eax,%edx
f0107584:	c1 ea 10             	shr    $0x10,%edx
f0107587:	52                   	push   %edx
f0107588:	0f b7 c0             	movzwl %ax,%eax
f010758b:	50                   	push   %eax
f010758c:	ff 77 08             	pushl  0x8(%edi)
f010758f:	ff 77 04             	pushl  0x4(%edi)
f0107592:	8b 07                	mov    (%edi),%eax
f0107594:	ff 70 04             	pushl  0x4(%eax)
f0107597:	68 f4 9c 10 f0       	push   $0xf0109cf4
f010759c:	e8 ce c8 ff ff       	call   f0103e6f <cprintf>
}
f01075a1:	83 c4 20             	add    $0x20,%esp
f01075a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01075a7:	5b                   	pop    %ebx
f01075a8:	5e                   	pop    %esi
f01075a9:	5f                   	pop    %edi
f01075aa:	5d                   	pop    %ebp
f01075ab:	c3                   	ret    

f01075ac <pci_init>:

int
pci_init(void)
{
f01075ac:	55                   	push   %ebp
f01075ad:	89 e5                	mov    %esp,%ebp
f01075af:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f01075b2:	6a 08                	push   $0x8
f01075b4:	6a 00                	push   $0x0
f01075b6:	68 84 ae 57 f0       	push   $0xf057ae84
f01075bb:	e8 f3 ee ff ff       	call   f01064b3 <memset>

	return pci_scan_bus(&root_bus);
f01075c0:	b8 84 ae 57 f0       	mov    $0xf057ae84,%eax
f01075c5:	e8 0d fc ff ff       	call   f01071d7 <pci_scan_bus>
}
f01075ca:	c9                   	leave  
f01075cb:	c3                   	ret    

f01075cc <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f01075cc:	c7 05 8c ae 57 f0 00 	movl   $0x0,0xf057ae8c
f01075d3:	00 00 00 
}
f01075d6:	c3                   	ret    

f01075d7 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f01075d7:	a1 8c ae 57 f0       	mov    0xf057ae8c,%eax
f01075dc:	83 c0 01             	add    $0x1,%eax
f01075df:	a3 8c ae 57 f0       	mov    %eax,0xf057ae8c
	if (ticks * 10 < ticks)
f01075e4:	8d 14 80             	lea    (%eax,%eax,4),%edx
f01075e7:	01 d2                	add    %edx,%edx
f01075e9:	39 d0                	cmp    %edx,%eax
f01075eb:	77 01                	ja     f01075ee <time_tick+0x17>
f01075ed:	c3                   	ret    
{
f01075ee:	55                   	push   %ebp
f01075ef:	89 e5                	mov    %esp,%ebp
f01075f1:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f01075f4:	68 fc 9d 10 f0       	push   $0xf0109dfc
f01075f9:	6a 13                	push   $0x13
f01075fb:	68 17 9e 10 f0       	push   $0xf0109e17
f0107600:	e8 44 8a ff ff       	call   f0100049 <_panic>

f0107605 <time_msec>:
}

unsigned int
time_msec(void)
{
	return ticks * 10;
f0107605:	a1 8c ae 57 f0       	mov    0xf057ae8c,%eax
f010760a:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010760d:	01 c0                	add    %eax,%eax
}
f010760f:	c3                   	ret    

f0107610 <__udivdi3>:
f0107610:	55                   	push   %ebp
f0107611:	57                   	push   %edi
f0107612:	56                   	push   %esi
f0107613:	53                   	push   %ebx
f0107614:	83 ec 1c             	sub    $0x1c,%esp
f0107617:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010761b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010761f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0107623:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0107627:	85 d2                	test   %edx,%edx
f0107629:	75 4d                	jne    f0107678 <__udivdi3+0x68>
f010762b:	39 f3                	cmp    %esi,%ebx
f010762d:	76 19                	jbe    f0107648 <__udivdi3+0x38>
f010762f:	31 ff                	xor    %edi,%edi
f0107631:	89 e8                	mov    %ebp,%eax
f0107633:	89 f2                	mov    %esi,%edx
f0107635:	f7 f3                	div    %ebx
f0107637:	89 fa                	mov    %edi,%edx
f0107639:	83 c4 1c             	add    $0x1c,%esp
f010763c:	5b                   	pop    %ebx
f010763d:	5e                   	pop    %esi
f010763e:	5f                   	pop    %edi
f010763f:	5d                   	pop    %ebp
f0107640:	c3                   	ret    
f0107641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107648:	89 d9                	mov    %ebx,%ecx
f010764a:	85 db                	test   %ebx,%ebx
f010764c:	75 0b                	jne    f0107659 <__udivdi3+0x49>
f010764e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107653:	31 d2                	xor    %edx,%edx
f0107655:	f7 f3                	div    %ebx
f0107657:	89 c1                	mov    %eax,%ecx
f0107659:	31 d2                	xor    %edx,%edx
f010765b:	89 f0                	mov    %esi,%eax
f010765d:	f7 f1                	div    %ecx
f010765f:	89 c6                	mov    %eax,%esi
f0107661:	89 e8                	mov    %ebp,%eax
f0107663:	89 f7                	mov    %esi,%edi
f0107665:	f7 f1                	div    %ecx
f0107667:	89 fa                	mov    %edi,%edx
f0107669:	83 c4 1c             	add    $0x1c,%esp
f010766c:	5b                   	pop    %ebx
f010766d:	5e                   	pop    %esi
f010766e:	5f                   	pop    %edi
f010766f:	5d                   	pop    %ebp
f0107670:	c3                   	ret    
f0107671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107678:	39 f2                	cmp    %esi,%edx
f010767a:	77 1c                	ja     f0107698 <__udivdi3+0x88>
f010767c:	0f bd fa             	bsr    %edx,%edi
f010767f:	83 f7 1f             	xor    $0x1f,%edi
f0107682:	75 2c                	jne    f01076b0 <__udivdi3+0xa0>
f0107684:	39 f2                	cmp    %esi,%edx
f0107686:	72 06                	jb     f010768e <__udivdi3+0x7e>
f0107688:	31 c0                	xor    %eax,%eax
f010768a:	39 eb                	cmp    %ebp,%ebx
f010768c:	77 a9                	ja     f0107637 <__udivdi3+0x27>
f010768e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107693:	eb a2                	jmp    f0107637 <__udivdi3+0x27>
f0107695:	8d 76 00             	lea    0x0(%esi),%esi
f0107698:	31 ff                	xor    %edi,%edi
f010769a:	31 c0                	xor    %eax,%eax
f010769c:	89 fa                	mov    %edi,%edx
f010769e:	83 c4 1c             	add    $0x1c,%esp
f01076a1:	5b                   	pop    %ebx
f01076a2:	5e                   	pop    %esi
f01076a3:	5f                   	pop    %edi
f01076a4:	5d                   	pop    %ebp
f01076a5:	c3                   	ret    
f01076a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01076ad:	8d 76 00             	lea    0x0(%esi),%esi
f01076b0:	89 f9                	mov    %edi,%ecx
f01076b2:	b8 20 00 00 00       	mov    $0x20,%eax
f01076b7:	29 f8                	sub    %edi,%eax
f01076b9:	d3 e2                	shl    %cl,%edx
f01076bb:	89 54 24 08          	mov    %edx,0x8(%esp)
f01076bf:	89 c1                	mov    %eax,%ecx
f01076c1:	89 da                	mov    %ebx,%edx
f01076c3:	d3 ea                	shr    %cl,%edx
f01076c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01076c9:	09 d1                	or     %edx,%ecx
f01076cb:	89 f2                	mov    %esi,%edx
f01076cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01076d1:	89 f9                	mov    %edi,%ecx
f01076d3:	d3 e3                	shl    %cl,%ebx
f01076d5:	89 c1                	mov    %eax,%ecx
f01076d7:	d3 ea                	shr    %cl,%edx
f01076d9:	89 f9                	mov    %edi,%ecx
f01076db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01076df:	89 eb                	mov    %ebp,%ebx
f01076e1:	d3 e6                	shl    %cl,%esi
f01076e3:	89 c1                	mov    %eax,%ecx
f01076e5:	d3 eb                	shr    %cl,%ebx
f01076e7:	09 de                	or     %ebx,%esi
f01076e9:	89 f0                	mov    %esi,%eax
f01076eb:	f7 74 24 08          	divl   0x8(%esp)
f01076ef:	89 d6                	mov    %edx,%esi
f01076f1:	89 c3                	mov    %eax,%ebx
f01076f3:	f7 64 24 0c          	mull   0xc(%esp)
f01076f7:	39 d6                	cmp    %edx,%esi
f01076f9:	72 15                	jb     f0107710 <__udivdi3+0x100>
f01076fb:	89 f9                	mov    %edi,%ecx
f01076fd:	d3 e5                	shl    %cl,%ebp
f01076ff:	39 c5                	cmp    %eax,%ebp
f0107701:	73 04                	jae    f0107707 <__udivdi3+0xf7>
f0107703:	39 d6                	cmp    %edx,%esi
f0107705:	74 09                	je     f0107710 <__udivdi3+0x100>
f0107707:	89 d8                	mov    %ebx,%eax
f0107709:	31 ff                	xor    %edi,%edi
f010770b:	e9 27 ff ff ff       	jmp    f0107637 <__udivdi3+0x27>
f0107710:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107713:	31 ff                	xor    %edi,%edi
f0107715:	e9 1d ff ff ff       	jmp    f0107637 <__udivdi3+0x27>
f010771a:	66 90                	xchg   %ax,%ax
f010771c:	66 90                	xchg   %ax,%ax
f010771e:	66 90                	xchg   %ax,%ax

f0107720 <__umoddi3>:
f0107720:	55                   	push   %ebp
f0107721:	57                   	push   %edi
f0107722:	56                   	push   %esi
f0107723:	53                   	push   %ebx
f0107724:	83 ec 1c             	sub    $0x1c,%esp
f0107727:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f010772b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f010772f:	8b 74 24 30          	mov    0x30(%esp),%esi
f0107733:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107737:	89 da                	mov    %ebx,%edx
f0107739:	85 c0                	test   %eax,%eax
f010773b:	75 43                	jne    f0107780 <__umoddi3+0x60>
f010773d:	39 df                	cmp    %ebx,%edi
f010773f:	76 17                	jbe    f0107758 <__umoddi3+0x38>
f0107741:	89 f0                	mov    %esi,%eax
f0107743:	f7 f7                	div    %edi
f0107745:	89 d0                	mov    %edx,%eax
f0107747:	31 d2                	xor    %edx,%edx
f0107749:	83 c4 1c             	add    $0x1c,%esp
f010774c:	5b                   	pop    %ebx
f010774d:	5e                   	pop    %esi
f010774e:	5f                   	pop    %edi
f010774f:	5d                   	pop    %ebp
f0107750:	c3                   	ret    
f0107751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107758:	89 fd                	mov    %edi,%ebp
f010775a:	85 ff                	test   %edi,%edi
f010775c:	75 0b                	jne    f0107769 <__umoddi3+0x49>
f010775e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107763:	31 d2                	xor    %edx,%edx
f0107765:	f7 f7                	div    %edi
f0107767:	89 c5                	mov    %eax,%ebp
f0107769:	89 d8                	mov    %ebx,%eax
f010776b:	31 d2                	xor    %edx,%edx
f010776d:	f7 f5                	div    %ebp
f010776f:	89 f0                	mov    %esi,%eax
f0107771:	f7 f5                	div    %ebp
f0107773:	89 d0                	mov    %edx,%eax
f0107775:	eb d0                	jmp    f0107747 <__umoddi3+0x27>
f0107777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010777e:	66 90                	xchg   %ax,%ax
f0107780:	89 f1                	mov    %esi,%ecx
f0107782:	39 d8                	cmp    %ebx,%eax
f0107784:	76 0a                	jbe    f0107790 <__umoddi3+0x70>
f0107786:	89 f0                	mov    %esi,%eax
f0107788:	83 c4 1c             	add    $0x1c,%esp
f010778b:	5b                   	pop    %ebx
f010778c:	5e                   	pop    %esi
f010778d:	5f                   	pop    %edi
f010778e:	5d                   	pop    %ebp
f010778f:	c3                   	ret    
f0107790:	0f bd e8             	bsr    %eax,%ebp
f0107793:	83 f5 1f             	xor    $0x1f,%ebp
f0107796:	75 20                	jne    f01077b8 <__umoddi3+0x98>
f0107798:	39 d8                	cmp    %ebx,%eax
f010779a:	0f 82 b0 00 00 00    	jb     f0107850 <__umoddi3+0x130>
f01077a0:	39 f7                	cmp    %esi,%edi
f01077a2:	0f 86 a8 00 00 00    	jbe    f0107850 <__umoddi3+0x130>
f01077a8:	89 c8                	mov    %ecx,%eax
f01077aa:	83 c4 1c             	add    $0x1c,%esp
f01077ad:	5b                   	pop    %ebx
f01077ae:	5e                   	pop    %esi
f01077af:	5f                   	pop    %edi
f01077b0:	5d                   	pop    %ebp
f01077b1:	c3                   	ret    
f01077b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01077b8:	89 e9                	mov    %ebp,%ecx
f01077ba:	ba 20 00 00 00       	mov    $0x20,%edx
f01077bf:	29 ea                	sub    %ebp,%edx
f01077c1:	d3 e0                	shl    %cl,%eax
f01077c3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01077c7:	89 d1                	mov    %edx,%ecx
f01077c9:	89 f8                	mov    %edi,%eax
f01077cb:	d3 e8                	shr    %cl,%eax
f01077cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01077d1:	89 54 24 04          	mov    %edx,0x4(%esp)
f01077d5:	8b 54 24 04          	mov    0x4(%esp),%edx
f01077d9:	09 c1                	or     %eax,%ecx
f01077db:	89 d8                	mov    %ebx,%eax
f01077dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01077e1:	89 e9                	mov    %ebp,%ecx
f01077e3:	d3 e7                	shl    %cl,%edi
f01077e5:	89 d1                	mov    %edx,%ecx
f01077e7:	d3 e8                	shr    %cl,%eax
f01077e9:	89 e9                	mov    %ebp,%ecx
f01077eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01077ef:	d3 e3                	shl    %cl,%ebx
f01077f1:	89 c7                	mov    %eax,%edi
f01077f3:	89 d1                	mov    %edx,%ecx
f01077f5:	89 f0                	mov    %esi,%eax
f01077f7:	d3 e8                	shr    %cl,%eax
f01077f9:	89 e9                	mov    %ebp,%ecx
f01077fb:	89 fa                	mov    %edi,%edx
f01077fd:	d3 e6                	shl    %cl,%esi
f01077ff:	09 d8                	or     %ebx,%eax
f0107801:	f7 74 24 08          	divl   0x8(%esp)
f0107805:	89 d1                	mov    %edx,%ecx
f0107807:	89 f3                	mov    %esi,%ebx
f0107809:	f7 64 24 0c          	mull   0xc(%esp)
f010780d:	89 c6                	mov    %eax,%esi
f010780f:	89 d7                	mov    %edx,%edi
f0107811:	39 d1                	cmp    %edx,%ecx
f0107813:	72 06                	jb     f010781b <__umoddi3+0xfb>
f0107815:	75 10                	jne    f0107827 <__umoddi3+0x107>
f0107817:	39 c3                	cmp    %eax,%ebx
f0107819:	73 0c                	jae    f0107827 <__umoddi3+0x107>
f010781b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010781f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0107823:	89 d7                	mov    %edx,%edi
f0107825:	89 c6                	mov    %eax,%esi
f0107827:	89 ca                	mov    %ecx,%edx
f0107829:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010782e:	29 f3                	sub    %esi,%ebx
f0107830:	19 fa                	sbb    %edi,%edx
f0107832:	89 d0                	mov    %edx,%eax
f0107834:	d3 e0                	shl    %cl,%eax
f0107836:	89 e9                	mov    %ebp,%ecx
f0107838:	d3 eb                	shr    %cl,%ebx
f010783a:	d3 ea                	shr    %cl,%edx
f010783c:	09 d8                	or     %ebx,%eax
f010783e:	83 c4 1c             	add    $0x1c,%esp
f0107841:	5b                   	pop    %ebx
f0107842:	5e                   	pop    %esi
f0107843:	5f                   	pop    %edi
f0107844:	5d                   	pop    %ebp
f0107845:	c3                   	ret    
f0107846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010784d:	8d 76 00             	lea    0x0(%esi),%esi
f0107850:	89 da                	mov    %ebx,%edx
f0107852:	29 fe                	sub    %edi,%esi
f0107854:	19 c2                	sbb    %eax,%edx
f0107856:	89 f1                	mov    %esi,%ecx
f0107858:	89 c8                	mov    %ecx,%eax
f010785a:	e9 4b ff ff ff       	jmp    f01077aa <__umoddi3+0x8a>
