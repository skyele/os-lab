
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
f0100015:	b8 00 70 12 00       	mov    $0x127000,%eax
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
f010003d:	bc 00 70 12 f0       	mov    $0xf0127000,%esp

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
f0100051:	83 3d a0 0e 58 f0 00 	cmpl   $0x0,0xf0580ea0
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
f0100069:	89 35 a0 0e 58 f0    	mov    %esi,0xf0580ea0
	asm volatile("cli; cld");
f010006f:	fa                   	cli    
f0100070:	fc                   	cld    
	va_start(ap, fmt);
f0100071:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100074:	e8 71 6b 00 00       	call   f0106bea <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 60 7c 10 f0       	push   $0xf0107c60
f0100085:	e8 46 3e 00 00       	call   f0103ed0 <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 16 3e 00 00       	call   f0103eaa <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 5b 91 10 f0 	movl   $0xf010915b,(%esp)
f010009b:	e8 30 3e 00 00       	call   f0103ed0 <cprintf>
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
f01000b6:	68 84 7c 10 f0       	push   $0xf0107c84
f01000bb:	e8 10 3e 00 00       	call   f0103ed0 <cprintf>
	cprintf("%n", NULL);
f01000c0:	83 c4 08             	add    $0x8,%esp
f01000c3:	6a 00                	push   $0x0
f01000c5:	68 fc 7c 10 f0       	push   $0xf0107cfc
f01000ca:	e8 01 3e 00 00       	call   f0103ed0 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000cf:	83 c4 0c             	add    $0xc,%esp
f01000d2:	68 00 fc ff ff       	push   $0xfffffc00
f01000d7:	68 00 04 00 00       	push   $0x400
f01000dc:	68 ff 7c 10 f0       	push   $0xf0107cff
f01000e1:	e8 ea 3d 00 00       	call   f0103ed0 <cprintf>
	mem_init();
f01000e6:	e8 66 16 00 00       	call   f0101751 <mem_init>
	env_init();
f01000eb:	e8 56 35 00 00       	call   f0103646 <env_init>
	trap_init();
f01000f0:	e8 bf 3e 00 00       	call   f0103fb4 <trap_init>
	mp_init();
f01000f5:	e8 f9 67 00 00       	call   f01068f3 <mp_init>
	lapic_init();
f01000fa:	e8 01 6b 00 00       	call   f0106c00 <lapic_init>
	pic_init();
f01000ff:	e8 d1 3c 00 00       	call   f0103dd5 <pic_init>
	time_init();
f0100104:	e8 aa 78 00 00       	call   f01079b3 <time_init>
	pci_init();
f0100109:	e8 85 78 00 00       	call   f0107993 <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010010e:	c7 04 24 c0 83 12 f0 	movl   $0xf01283c0,(%esp)
f0100115:	e8 40 6d 00 00       	call   f0106e5a <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010011a:	83 c4 10             	add    $0x10,%esp
f010011d:	83 3d a8 0e 58 f0 07 	cmpl   $0x7,0xf0580ea8
f0100124:	76 27                	jbe    f010014d <i386_init+0xa8>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100126:	83 ec 04             	sub    $0x4,%esp
f0100129:	b8 56 68 10 f0       	mov    $0xf0106856,%eax
f010012e:	2d d4 67 10 f0       	sub    $0xf01067d4,%eax
f0100133:	50                   	push   %eax
f0100134:	68 d4 67 10 f0       	push   $0xf01067d4
f0100139:	68 00 70 00 f0       	push   $0xf0007000
f010013e:	e8 e8 64 00 00       	call   f010662b <memmove>
f0100143:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100146:	bb 20 10 58 f0       	mov    $0xf0581020,%ebx
f010014b:	eb 19                	jmp    f0100166 <i386_init+0xc1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010014d:	68 00 70 00 00       	push   $0x7000
f0100152:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0100157:	6a 66                	push   $0x66
f0100159:	68 1b 7d 10 f0       	push   $0xf0107d1b
f010015e:	e8 e6 fe ff ff       	call   f0100049 <_panic>
f0100163:	83 c3 74             	add    $0x74,%ebx
f0100166:	6b 05 c4 13 58 f0 74 	imul   $0x74,0xf05813c4,%eax
f010016d:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0100172:	39 c3                	cmp    %eax,%ebx
f0100174:	73 4d                	jae    f01001c3 <i386_init+0x11e>
		if (c == cpus + cpunum())  // We've started already.
f0100176:	e8 6f 6a 00 00       	call   f0106bea <cpunum>
f010017b:	6b c0 74             	imul   $0x74,%eax,%eax
f010017e:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0100183:	39 c3                	cmp    %eax,%ebx
f0100185:	74 dc                	je     f0100163 <i386_init+0xbe>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100187:	89 d8                	mov    %ebx,%eax
f0100189:	2d 20 10 58 f0       	sub    $0xf0581020,%eax
f010018e:	c1 f8 02             	sar    $0x2,%eax
f0100191:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100197:	c1 e0 0f             	shl    $0xf,%eax
f010019a:	8d 80 00 a0 58 f0    	lea    -0xfa76000(%eax),%eax
f01001a0:	a3 a4 0e 58 f0       	mov    %eax,0xf0580ea4
		lapic_startap(c->cpu_id, PADDR(code));
f01001a5:	83 ec 08             	sub    $0x8,%esp
f01001a8:	68 00 70 00 00       	push   $0x7000
f01001ad:	0f b6 03             	movzbl (%ebx),%eax
f01001b0:	50                   	push   %eax
f01001b1:	e8 9c 6b 00 00       	call   f0106d52 <lapic_startap>
f01001b6:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f01001b9:	8b 43 04             	mov    0x4(%ebx),%eax
f01001bc:	83 f8 01             	cmp    $0x1,%eax
f01001bf:	75 f8                	jne    f01001b9 <i386_init+0x114>
f01001c1:	eb a0                	jmp    f0100163 <i386_init+0xbe>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001c3:	83 ec 08             	sub    $0x8,%esp
f01001c6:	6a 01                	push   $0x1
f01001c8:	68 04 0f 3f f0       	push   $0xf03f0f04
f01001cd:	e8 46 36 00 00       	call   f0103818 <env_create>
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f01001d2:	83 c4 08             	add    $0x8,%esp
f01001d5:	6a 02                	push   $0x2
f01001d7:	68 c8 9d 48 f0       	push   $0xf0489dc8
f01001dc:	e8 37 36 00 00       	call   f0103818 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001e1:	83 c4 08             	add    $0x8,%esp
f01001e4:	6a 00                	push   $0x0
f01001e6:	68 5c 0a 42 f0       	push   $0xf0420a5c
f01001eb:	e8 28 36 00 00       	call   f0103818 <env_create>
	kbd_intr();
f01001f0:	e8 32 04 00 00       	call   f0100627 <kbd_intr>
	sched_yield();
f01001f5:	e8 84 4c 00 00       	call   f0104e7e <sched_yield>

f01001fa <mp_main>:
{
f01001fa:	55                   	push   %ebp
f01001fb:	89 e5                	mov    %esp,%ebp
f01001fd:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f0100200:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0100214:	e8 d1 69 00 00       	call   f0106bea <cpunum>
f0100219:	83 ec 08             	sub    $0x8,%esp
f010021c:	50                   	push   %eax
f010021d:	68 27 7d 10 f0       	push   $0xf0107d27
f0100222:	e8 a9 3c 00 00       	call   f0103ed0 <cprintf>
	lapic_init();
f0100227:	e8 d4 69 00 00       	call   f0106c00 <lapic_init>
	env_init_percpu();
f010022c:	e8 e9 33 00 00       	call   f010361a <env_init_percpu>
	trap_init_percpu();
f0100231:	e8 ae 3c 00 00       	call   f0103ee4 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100236:	e8 af 69 00 00       	call   f0106bea <cpunum>
f010023b:	6b d0 74             	imul   $0x74,%eax,%edx
f010023e:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100241:	b8 01 00 00 00       	mov    $0x1,%eax
f0100246:	f0 87 82 20 10 58 f0 	lock xchg %eax,-0xfa7efe0(%edx)
f010024d:	c7 04 24 c0 83 12 f0 	movl   $0xf01283c0,(%esp)
f0100254:	e8 01 6c 00 00       	call   f0106e5a <spin_lock>
	sched_yield();
f0100259:	e8 20 4c 00 00       	call   f0104e7e <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010025e:	50                   	push   %eax
f010025f:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0100264:	6a 7e                	push   $0x7e
f0100266:	68 1b 7d 10 f0       	push   $0xf0107d1b
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
f0100280:	68 3d 7d 10 f0       	push   $0xf0107d3d
f0100285:	e8 46 3c 00 00       	call   f0103ed0 <cprintf>
	vcprintf(fmt, ap);
f010028a:	83 c4 08             	add    $0x8,%esp
f010028d:	53                   	push   %ebx
f010028e:	ff 75 10             	pushl  0x10(%ebp)
f0100291:	e8 14 3c 00 00       	call   f0103eaa <vcprintf>
	cprintf("\n");
f0100296:	c7 04 24 5b 91 10 f0 	movl   $0xf010915b,(%esp)
f010029d:	e8 2e 3c 00 00       	call   f0103ed0 <cprintf>
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
f01002d8:	8b 0d 24 f2 57 f0    	mov    0xf057f224,%ecx
f01002de:	8d 51 01             	lea    0x1(%ecx),%edx
f01002e1:	88 81 20 f0 57 f0    	mov    %al,-0xfa80fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002e7:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002ed:	b8 00 00 00 00       	mov    $0x0,%eax
f01002f2:	0f 44 d0             	cmove  %eax,%edx
f01002f5:	89 15 24 f2 57 f0    	mov    %edx,0xf057f224
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
f0100330:	8b 0d 00 f0 57 f0    	mov    0xf057f000,%ecx
f0100336:	f6 c1 40             	test   $0x40,%cl
f0100339:	74 0e                	je     f0100349 <kbd_proc_data+0x46>
		data |= 0x80;
f010033b:	83 c8 80             	or     $0xffffff80,%eax
f010033e:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100340:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100343:	89 0d 00 f0 57 f0    	mov    %ecx,0xf057f000
	shift |= shiftcode[data];
f0100349:	0f b6 d2             	movzbl %dl,%edx
f010034c:	0f b6 82 a0 7e 10 f0 	movzbl -0xfef8160(%edx),%eax
f0100353:	0b 05 00 f0 57 f0    	or     0xf057f000,%eax
	shift ^= togglecode[data];
f0100359:	0f b6 8a a0 7d 10 f0 	movzbl -0xfef8260(%edx),%ecx
f0100360:	31 c8                	xor    %ecx,%eax
f0100362:	a3 00 f0 57 f0       	mov    %eax,0xf057f000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100367:	89 c1                	mov    %eax,%ecx
f0100369:	83 e1 03             	and    $0x3,%ecx
f010036c:	8b 0c 8d 80 7d 10 f0 	mov    -0xfef8280(,%ecx,4),%ecx
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
f010038d:	83 0d 00 f0 57 f0 40 	orl    $0x40,0xf057f000
		return 0;
f0100394:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100399:	89 d8                	mov    %ebx,%eax
f010039b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010039e:	c9                   	leave  
f010039f:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003a0:	8b 0d 00 f0 57 f0    	mov    0xf057f000,%ecx
f01003a6:	89 cb                	mov    %ecx,%ebx
f01003a8:	83 e3 40             	and    $0x40,%ebx
f01003ab:	83 e0 7f             	and    $0x7f,%eax
f01003ae:	85 db                	test   %ebx,%ebx
f01003b0:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003b3:	0f b6 d2             	movzbl %dl,%edx
f01003b6:	0f b6 82 a0 7e 10 f0 	movzbl -0xfef8160(%edx),%eax
f01003bd:	83 c8 40             	or     $0x40,%eax
f01003c0:	0f b6 c0             	movzbl %al,%eax
f01003c3:	f7 d0                	not    %eax
f01003c5:	21 c8                	and    %ecx,%eax
f01003c7:	a3 00 f0 57 f0       	mov    %eax,0xf057f000
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
f01003f0:	68 57 7d 10 f0       	push   $0xf0107d57
f01003f5:	e8 d6 3a 00 00       	call   f0103ed0 <cprintf>
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
f01004cd:	0f b7 05 28 f2 57 f0 	movzwl 0xf057f228,%eax
f01004d4:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004da:	c1 e8 16             	shr    $0x16,%eax
f01004dd:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004e0:	c1 e0 04             	shl    $0x4,%eax
f01004e3:	66 a3 28 f2 57 f0    	mov    %ax,0xf057f228
	if (crt_pos >= CRT_SIZE) {
f01004e9:	66 81 3d 28 f2 57 f0 	cmpw   $0x7cf,0xf057f228
f01004f0:	cf 07 
f01004f2:	0f 87 cb 00 00 00    	ja     f01005c3 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004f8:	8b 0d 30 f2 57 f0    	mov    0xf057f230,%ecx
f01004fe:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100503:	89 ca                	mov    %ecx,%edx
f0100505:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100506:	0f b7 1d 28 f2 57 f0 	movzwl 0xf057f228,%ebx
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
f0100533:	0f b7 05 28 f2 57 f0 	movzwl 0xf057f228,%eax
f010053a:	66 85 c0             	test   %ax,%ax
f010053d:	74 b9                	je     f01004f8 <cons_putc+0xe0>
			crt_pos--;
f010053f:	83 e8 01             	sub    $0x1,%eax
f0100542:	66 a3 28 f2 57 f0    	mov    %ax,0xf057f228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100548:	0f b7 c0             	movzwl %ax,%eax
f010054b:	b1 00                	mov    $0x0,%cl
f010054d:	83 c9 20             	or     $0x20,%ecx
f0100550:	8b 15 2c f2 57 f0    	mov    0xf057f22c,%edx
f0100556:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010055a:	eb 8d                	jmp    f01004e9 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f010055c:	66 83 05 28 f2 57 f0 	addw   $0x50,0xf057f228
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
f01005a0:	0f b7 05 28 f2 57 f0 	movzwl 0xf057f228,%eax
f01005a7:	8d 50 01             	lea    0x1(%eax),%edx
f01005aa:	66 89 15 28 f2 57 f0 	mov    %dx,0xf057f228
f01005b1:	0f b7 c0             	movzwl %ax,%eax
f01005b4:	8b 15 2c f2 57 f0    	mov    0xf057f22c,%edx
f01005ba:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005be:	e9 26 ff ff ff       	jmp    f01004e9 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005c3:	a1 2c f2 57 f0       	mov    0xf057f22c,%eax
f01005c8:	83 ec 04             	sub    $0x4,%esp
f01005cb:	68 00 0f 00 00       	push   $0xf00
f01005d0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005d6:	52                   	push   %edx
f01005d7:	50                   	push   %eax
f01005d8:	e8 4e 60 00 00       	call   f010662b <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005dd:	8b 15 2c f2 57 f0    	mov    0xf057f22c,%edx
f01005e3:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005e9:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005ef:	83 c4 10             	add    $0x10,%esp
f01005f2:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005f7:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005fa:	39 d0                	cmp    %edx,%eax
f01005fc:	75 f4                	jne    f01005f2 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005fe:	66 83 2d 28 f2 57 f0 	subw   $0x50,0xf057f228
f0100605:	50 
f0100606:	e9 ed fe ff ff       	jmp    f01004f8 <cons_putc+0xe0>

f010060b <serial_intr>:
	if (serial_exists)
f010060b:	80 3d 34 f2 57 f0 00 	cmpb   $0x0,0xf057f234
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
f0100649:	8b 15 20 f2 57 f0    	mov    0xf057f220,%edx
	return 0;
f010064f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100654:	3b 15 24 f2 57 f0    	cmp    0xf057f224,%edx
f010065a:	74 1e                	je     f010067a <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010065c:	8d 4a 01             	lea    0x1(%edx),%ecx
f010065f:	0f b6 82 20 f0 57 f0 	movzbl -0xfa80fe0(%edx),%eax
			cons.rpos = 0;
f0100666:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010066c:	ba 00 00 00 00       	mov    $0x0,%edx
f0100671:	0f 44 ca             	cmove  %edx,%ecx
f0100674:	89 0d 20 f2 57 f0    	mov    %ecx,0xf057f220
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
f01006a6:	c7 05 30 f2 57 f0 b4 	movl   $0x3b4,0xf057f230
f01006ad:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006b0:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006b5:	8b 3d 30 f2 57 f0    	mov    0xf057f230,%edi
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
f01006dc:	89 35 2c f2 57 f0    	mov    %esi,0xf057f22c
	pos |= inb(addr_6845 + 1);
f01006e2:	0f b6 c0             	movzbl %al,%eax
f01006e5:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006e7:	66 a3 28 f2 57 f0    	mov    %ax,0xf057f228
	kbd_intr();
f01006ed:	e8 35 ff ff ff       	call   f0100627 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006f2:	83 ec 0c             	sub    $0xc,%esp
f01006f5:	0f b7 05 a8 83 12 f0 	movzwl 0xf01283a8,%eax
f01006fc:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100701:	50                   	push   %eax
f0100702:	e8 50 36 00 00       	call   f0103d57 <irq_setmask_8259A>
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
f010075d:	0f 95 05 34 f2 57 f0 	setne  0xf057f234
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
f0100775:	68 63 7d 10 f0       	push   $0xf0107d63
f010077a:	e8 51 37 00 00       	call   f0103ed0 <cprintf>
f010077f:	83 c4 10             	add    $0x10,%esp
}
f0100782:	eb 3c                	jmp    f01007c0 <cons_init+0x144>
		*cp = was;
f0100784:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010078b:	c7 05 30 f2 57 f0 d4 	movl   $0x3d4,0xf057f230
f0100792:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100795:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010079a:	e9 16 ff ff ff       	jmp    f01006b5 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010079f:	83 ec 0c             	sub    $0xc,%esp
f01007a2:	0f b7 05 a8 83 12 f0 	movzwl 0xf01283a8,%eax
f01007a9:	25 ef ff 00 00       	and    $0xffef,%eax
f01007ae:	50                   	push   %eax
f01007af:	e8 a3 35 00 00       	call   f0103d57 <irq_setmask_8259A>
	if (!serial_exists)
f01007b4:	83 c4 10             	add    $0x10,%esp
f01007b7:	80 3d 34 f2 57 f0 00 	cmpb   $0x0,0xf057f234
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
f01007fe:	ff b3 04 84 10 f0    	pushl  -0xfef7bfc(%ebx)
f0100804:	ff b3 00 84 10 f0    	pushl  -0xfef7c00(%ebx)
f010080a:	68 a0 7f 10 f0       	push   $0xf0107fa0
f010080f:	e8 bc 36 00 00       	call   f0103ed0 <cprintf>
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
f010082f:	68 a9 7f 10 f0       	push   $0xf0107fa9
f0100834:	e8 97 36 00 00       	call   f0103ed0 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100839:	83 c4 08             	add    $0x8,%esp
f010083c:	68 0c 00 10 00       	push   $0x10000c
f0100841:	68 0c 81 10 f0       	push   $0xf010810c
f0100846:	e8 85 36 00 00       	call   f0103ed0 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010084b:	83 c4 0c             	add    $0xc,%esp
f010084e:	68 0c 00 10 00       	push   $0x10000c
f0100853:	68 0c 00 10 f0       	push   $0xf010000c
f0100858:	68 34 81 10 f0       	push   $0xf0108134
f010085d:	e8 6e 36 00 00       	call   f0103ed0 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100862:	83 c4 0c             	add    $0xc,%esp
f0100865:	68 4f 7c 10 00       	push   $0x107c4f
f010086a:	68 4f 7c 10 f0       	push   $0xf0107c4f
f010086f:	68 58 81 10 f0       	push   $0xf0108158
f0100874:	e8 57 36 00 00       	call   f0103ed0 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100879:	83 c4 0c             	add    $0xc,%esp
f010087c:	68 00 f0 57 00       	push   $0x57f000
f0100881:	68 00 f0 57 f0       	push   $0xf057f000
f0100886:	68 7c 81 10 f0       	push   $0xf010817c
f010088b:	e8 40 36 00 00       	call   f0103ed0 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100890:	83 c4 0c             	add    $0xc,%esp
f0100893:	68 40 0e 6a 00       	push   $0x6a0e40
f0100898:	68 40 0e 6a f0       	push   $0xf06a0e40
f010089d:	68 a0 81 10 f0       	push   $0xf01081a0
f01008a2:	e8 29 36 00 00       	call   f0103ed0 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a7:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008aa:	b8 40 0e 6a f0       	mov    $0xf06a0e40,%eax
f01008af:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008b4:	c1 f8 0a             	sar    $0xa,%eax
f01008b7:	50                   	push   %eax
f01008b8:	68 c4 81 10 f0       	push   $0xf01081c4
f01008bd:	e8 0e 36 00 00       	call   f0103ed0 <cprintf>
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
f01008e4:	68 c2 7f 10 f0       	push   $0xf0107fc2
f01008e9:	e8 e2 35 00 00       	call   f0103ed0 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f01008ee:	83 c4 08             	add    $0x8,%esp
f01008f1:	ff 73 08             	pushl  0x8(%ebx)
f01008f4:	68 d1 7f 10 f0       	push   $0xf0107fd1
f01008f9:	e8 d2 35 00 00       	call   f0103ed0 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f01008fe:	83 c4 08             	add    $0x8,%esp
f0100901:	ff 73 0c             	pushl  0xc(%ebx)
f0100904:	68 e0 7f 10 f0       	push   $0xf0107fe0
f0100909:	e8 c2 35 00 00       	call   f0103ed0 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f010090e:	83 c4 08             	add    $0x8,%esp
f0100911:	ff 73 10             	pushl  0x10(%ebx)
f0100914:	68 ef 7f 10 f0       	push   $0xf0107fef
f0100919:	e8 b2 35 00 00       	call   f0103ed0 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f010091e:	83 c4 08             	add    $0x8,%esp
f0100921:	ff 73 14             	pushl  0x14(%ebx)
f0100924:	68 fe 7f 10 f0       	push   $0xf0107ffe
f0100929:	e8 a2 35 00 00       	call   f0103ed0 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f010092e:	83 c4 08             	add    $0x8,%esp
f0100931:	ff 73 18             	pushl  0x18(%ebx)
f0100934:	68 0d 80 10 f0       	push   $0xf010800d
f0100939:	e8 92 35 00 00       	call   f0103ed0 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f010093e:	ff 73 18             	pushl  0x18(%ebx)
f0100941:	ff 73 14             	pushl  0x14(%ebx)
f0100944:	ff 73 10             	pushl  0x10(%ebx)
f0100947:	ff 73 0c             	pushl  0xc(%ebx)
f010094a:	ff 73 08             	pushl  0x8(%ebx)
f010094d:	53                   	push   %ebx
f010094e:	ff 73 04             	pushl  0x4(%ebx)
f0100951:	68 f0 81 10 f0       	push   $0xf01081f0
f0100956:	e8 75 35 00 00       	call   f0103ed0 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f010095b:	83 c4 28             	add    $0x28,%esp
f010095e:	56                   	push   %esi
f010095f:	ff 73 04             	pushl  0x4(%ebx)
f0100962:	e8 15 50 00 00       	call   f010597c <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f0100967:	83 c4 08             	add    $0x8,%esp
f010096a:	8b 43 04             	mov    0x4(%ebx),%eax
f010096d:	2b 45 f0             	sub    -0x10(%ebp),%eax
f0100970:	50                   	push   %eax
f0100971:	ff 75 e8             	pushl  -0x18(%ebp)
f0100974:	ff 75 ec             	pushl  -0x14(%ebp)
f0100977:	ff 75 e4             	pushl  -0x1c(%ebp)
f010097a:	ff 75 e0             	pushl  -0x20(%ebp)
f010097d:	68 1c 80 10 f0       	push   $0xf010801c
f0100982:	e8 49 35 00 00       	call   f0103ed0 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f0100987:	8b 1b                	mov    (%ebx),%ebx
f0100989:	83 c4 20             	add    $0x20,%esp
f010098c:	e9 45 ff ff ff       	jmp    f01008d6 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f0100991:	83 ec 0c             	sub    $0xc,%esp
f0100994:	68 32 80 10 f0       	push   $0xf0108032
f0100999:	e8 32 35 00 00       	call   f0103ed0 <cprintf>
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
f01009de:	68 60 82 10 f0       	push   $0xf0108260
f01009e3:	e8 e8 34 00 00       	call   f0103ed0 <cprintf>
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
f01009fb:	68 e0 83 10 f0       	push   $0xf01083e0
f0100a00:	68 24 82 10 f0       	push   $0xf0108224
f0100a05:	e8 c6 34 00 00       	call   f0103ed0 <cprintf>
		return 0;
f0100a0a:	83 c4 10             	add    $0x10,%esp
f0100a0d:	eb dc                	jmp    f01009eb <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f0100a0f:	83 ec 04             	sub    $0x4,%esp
f0100a12:	6a 10                	push   $0x10
f0100a14:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f0100a17:	56                   	push   %esi
f0100a18:	50                   	push   %eax
f0100a19:	e8 db 5c 00 00       	call   f01066f9 <strtol>
f0100a1e:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a20:	83 c4 0c             	add    $0xc,%esp
f0100a23:	6a 10                	push   $0x10
f0100a25:	56                   	push   %esi
f0100a26:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a29:	ff 70 08             	pushl  0x8(%eax)
f0100a2c:	e8 c8 5c 00 00       	call   f01066f9 <strtol>
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
f0100a4d:	68 88 82 10 f0       	push   $0xf0108288
f0100a52:	e8 79 34 00 00       	call   f0103ed0 <cprintf>
		return 0;
f0100a57:	83 c4 10             	add    $0x10,%esp
f0100a5a:	eb 8f                	jmp    f01009eb <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100a5c:	83 ec 04             	sub    $0x4,%esp
f0100a5f:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100a65:	50                   	push   %eax
f0100a66:	53                   	push   %ebx
f0100a67:	68 45 80 10 f0       	push   $0xf0108045
f0100a6c:	e8 5f 34 00 00       	call   f0103ed0 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100a71:	8b 06                	mov    (%esi),%eax
f0100a73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a78:	83 c4 0c             	add    $0xc,%esp
f0100a7b:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100a81:	52                   	push   %edx
f0100a82:	50                   	push   %eax
f0100a83:	68 54 80 10 f0       	push   $0xf0108054
f0100a88:	e8 43 34 00 00       	call   f0103ed0 <cprintf>
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
f0100abc:	68 63 80 10 f0       	push   $0xf0108063
f0100ac1:	e8 0a 34 00 00       	call   f0103ed0 <cprintf>
f0100ac6:	83 c4 20             	add    $0x20,%esp
f0100ac9:	e9 dc 00 00 00       	jmp    f0100baa <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100ace:	83 ec 04             	sub    $0x4,%esp
f0100ad1:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100ad7:	50                   	push   %eax
f0100ad8:	53                   	push   %ebx
f0100ad9:	68 45 80 10 f0       	push   $0xf0108045
f0100ade:	e8 ed 33 00 00       	call   f0103ed0 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100ae3:	8b 07                	mov    (%edi),%eax
f0100ae5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100aea:	83 c4 0c             	add    $0xc,%esp
f0100aed:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100af3:	52                   	push   %edx
f0100af4:	50                   	push   %eax
f0100af5:	68 54 80 10 f0       	push   $0xf0108054
f0100afa:	e8 d1 33 00 00       	call   f0103ed0 <cprintf>
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
f0100b2e:	68 63 80 10 f0       	push   $0xf0108063
f0100b33:	e8 98 33 00 00       	call   f0103ed0 <cprintf>
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
f0100b6b:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0100c03:	ff 14 b5 08 84 10 f0 	call   *-0xfef7bf8(,%esi,4)
f0100c0a:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100c0d:	83 c3 01             	add    $0x1,%ebx
f0100c10:	39 1d 00 83 12 f0    	cmp    %ebx,0xf0128300
f0100c16:	7e 1c                	jle    f0100c34 <mon_time+0x78>
f0100c18:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c1b:	83 ec 08             	sub    $0x8,%esp
f0100c1e:	57                   	push   %edi
f0100c1f:	ff 34 b5 00 84 10 f0 	pushl  -0xfef7c00(,%esi,4)
f0100c26:	e8 1d 59 00 00       	call   f0106548 <strcmp>
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
f0100c3f:	68 76 80 10 f0       	push   $0xf0108076
f0100c44:	e8 87 32 00 00       	call   f0103ed0 <cprintf>
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
f0100c69:	68 ac 82 10 f0       	push   $0xf01082ac
f0100c6e:	e8 5d 32 00 00       	call   f0103ed0 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c73:	c7 04 24 d0 82 10 f0 	movl   $0xf01082d0,(%esp)
f0100c7a:	e8 51 32 00 00       	call   f0103ed0 <cprintf>
	if (tf != NULL)
f0100c7f:	83 c4 10             	add    $0x10,%esp
f0100c82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100c86:	0f 84 d9 00 00 00    	je     f0100d65 <monitor+0x105>
		print_trapframe(tf);
f0100c8c:	83 ec 0c             	sub    $0xc,%esp
f0100c8f:	ff 75 08             	pushl  0x8(%ebp)
f0100c92:	e8 c4 39 00 00       	call   f010465b <print_trapframe>
f0100c97:	83 c4 10             	add    $0x10,%esp
f0100c9a:	e9 c6 00 00 00       	jmp    f0100d65 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100c9f:	83 ec 08             	sub    $0x8,%esp
f0100ca2:	0f be c0             	movsbl %al,%eax
f0100ca5:	50                   	push   %eax
f0100ca6:	68 8a 80 10 f0       	push   $0xf010808a
f0100cab:	e8 f6 58 00 00       	call   f01065a6 <strchr>
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
f0100ce3:	ff 34 85 00 84 10 f0 	pushl  -0xfef7c00(,%eax,4)
f0100cea:	ff 75 a8             	pushl  -0x58(%ebp)
f0100ced:	e8 56 58 00 00       	call   f0106548 <strcmp>
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
f0100d0b:	68 ac 80 10 f0       	push   $0xf01080ac
f0100d10:	e8 bb 31 00 00       	call   f0103ed0 <cprintf>
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
f0100d39:	68 8a 80 10 f0       	push   $0xf010808a
f0100d3e:	e8 63 58 00 00       	call   f01065a6 <strchr>
f0100d43:	83 c4 10             	add    $0x10,%esp
f0100d46:	85 c0                	test   %eax,%eax
f0100d48:	0f 85 71 ff ff ff    	jne    f0100cbf <monitor+0x5f>
			buf++;
f0100d4e:	83 c3 01             	add    $0x1,%ebx
f0100d51:	eb d8                	jmp    f0100d2b <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d53:	83 ec 08             	sub    $0x8,%esp
f0100d56:	6a 10                	push   $0x10
f0100d58:	68 8f 80 10 f0       	push   $0xf010808f
f0100d5d:	e8 6e 31 00 00       	call   f0103ed0 <cprintf>
f0100d62:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100d65:	83 ec 0c             	sub    $0xc,%esp
f0100d68:	68 86 80 10 f0       	push   $0xf0108086
f0100d6d:	e8 04 56 00 00       	call   f0106376 <readline>
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
f0100d9a:	ff 14 85 08 84 10 f0 	call   *-0xfef7bf8(,%eax,4)
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
f0100dbe:	e8 66 2f 00 00       	call   f0103d29 <mc146818_read>
f0100dc3:	89 c3                	mov    %eax,%ebx
f0100dc5:	83 c6 01             	add    $0x1,%esi
f0100dc8:	89 34 24             	mov    %esi,(%esp)
f0100dcb:	e8 59 2f 00 00       	call   f0103d29 <mc146818_read>
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
f0100df2:	3b 0d a8 0e 58 f0    	cmp    0xf0580ea8,%ecx
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
f0100e26:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0100e2b:	68 ad 03 00 00       	push   $0x3ad
f0100e30:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0100e47:	83 3d 38 f2 57 f0 00 	cmpl   $0x0,0xf057f238
f0100e4e:	74 40                	je     f0100e90 <boot_alloc+0x50>
	if(!n)
f0100e50:	85 c0                	test   %eax,%eax
f0100e52:	74 65                	je     f0100eb9 <boot_alloc+0x79>
f0100e54:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100e56:	a1 38 f2 57 f0       	mov    0xf057f238,%eax
	if ((uint32_t)kva < KERNBASE)
f0100e5b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e60:	76 5e                	jbe    f0100ec0 <boot_alloc+0x80>
f0100e62:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100e69:	c1 e9 0c             	shr    $0xc,%ecx
f0100e6c:	83 c1 01             	add    $0x1,%ecx
f0100e6f:	3b 0d a8 0e 58 f0    	cmp    0xf0580ea8,%ecx
f0100e75:	77 5b                	ja     f0100ed2 <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100e77:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e7d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e83:	01 c2                	add    %eax,%edx
f0100e85:	89 15 38 f2 57 f0    	mov    %edx,0xf057f238
}
f0100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100e8e:	c9                   	leave  
f0100e8f:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e90:	b9 40 0e 6a f0       	mov    $0xf06a0e40,%ecx
f0100e95:	ba 3f 1e 6a f0       	mov    $0xf06a1e3f,%edx
f0100e9a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100ea0:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100ea6:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100eac:	85 c9                	test   %ecx,%ecx
f0100eae:	0f 44 d3             	cmove  %ebx,%edx
f0100eb1:	89 15 38 f2 57 f0    	mov    %edx,0xf057f238
f0100eb7:	eb 97                	jmp    f0100e50 <boot_alloc+0x10>
		return nextfree;
f0100eb9:	a1 38 f2 57 f0       	mov    0xf057f238,%eax
f0100ebe:	eb cb                	jmp    f0100e8b <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100ec0:	50                   	push   %eax
f0100ec1:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0100ec6:	6a 72                	push   $0x72
f0100ec8:	68 45 8e 10 f0       	push   $0xf0108e45
f0100ecd:	e8 77 f1 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100ed2:	83 ec 04             	sub    $0x4,%esp
f0100ed5:	68 3c 84 10 f0       	push   $0xf010843c
f0100eda:	6a 73                	push   $0x73
f0100edc:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0100ef7:	83 3d 40 f2 57 f0 00 	cmpl   $0x0,0xf057f240
f0100efe:	74 0a                	je     f0100f0a <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f00:	be 00 04 00 00       	mov    $0x400,%esi
f0100f05:	e9 bf 02 00 00       	jmp    f01011c9 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100f0a:	83 ec 04             	sub    $0x4,%esp
f0100f0d:	68 74 84 10 f0       	push   $0xf0108474
f0100f12:	68 dd 02 00 00       	push   $0x2dd
f0100f17:	68 45 8e 10 f0       	push   $0xf0108e45
f0100f1c:	e8 28 f1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f21:	50                   	push   %eax
f0100f22:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0100f27:	6a 58                	push   $0x58
f0100f29:	68 51 8e 10 f0       	push   $0xf0108e51
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
f0100f3b:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0100f55:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0100f5b:	73 c4                	jae    f0100f21 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100f5d:	83 ec 04             	sub    $0x4,%esp
f0100f60:	68 80 00 00 00       	push   $0x80
f0100f65:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100f6a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f6f:	50                   	push   %eax
f0100f70:	e8 6e 56 00 00       	call   f01065e3 <memset>
f0100f75:	83 c4 10             	add    $0x10,%esp
f0100f78:	eb b9                	jmp    f0100f33 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100f7a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f7f:	e8 bc fe ff ff       	call   f0100e40 <boot_alloc>
f0100f84:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f87:	8b 15 40 f2 57 f0    	mov    0xf057f240,%edx
		assert(pp >= pages);
f0100f8d:	8b 0d b0 0e 58 f0    	mov    0xf0580eb0,%ecx
		assert(pp < pages + npages);
f0100f93:	a1 a8 0e 58 f0       	mov    0xf0580ea8,%eax
f0100f98:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f9b:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100f9e:	bf 00 00 00 00       	mov    $0x0,%edi
f0100fa3:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100fa6:	e9 f9 00 00 00       	jmp    f01010a4 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100fab:	68 5f 8e 10 f0       	push   $0xf0108e5f
f0100fb0:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0100fb5:	68 f6 02 00 00       	push   $0x2f6
f0100fba:	68 45 8e 10 f0       	push   $0xf0108e45
f0100fbf:	e8 85 f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0100fc4:	68 80 8e 10 f0       	push   $0xf0108e80
f0100fc9:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0100fce:	68 f7 02 00 00       	push   $0x2f7
f0100fd3:	68 45 8e 10 f0       	push   $0xf0108e45
f0100fd8:	e8 6c f0 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100fdd:	68 98 84 10 f0       	push   $0xf0108498
f0100fe2:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0100fe7:	68 f8 02 00 00       	push   $0x2f8
f0100fec:	68 45 8e 10 f0       	push   $0xf0108e45
f0100ff1:	e8 53 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0100ff6:	68 94 8e 10 f0       	push   $0xf0108e94
f0100ffb:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101000:	68 fb 02 00 00       	push   $0x2fb
f0101005:	68 45 8e 10 f0       	push   $0xf0108e45
f010100a:	e8 3a f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f010100f:	68 a5 8e 10 f0       	push   $0xf0108ea5
f0101014:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101019:	68 fc 02 00 00       	push   $0x2fc
f010101e:	68 45 8e 10 f0       	push   $0xf0108e45
f0101023:	e8 21 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101028:	68 cc 84 10 f0       	push   $0xf01084cc
f010102d:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101032:	68 fd 02 00 00       	push   $0x2fd
f0101037:	68 45 8e 10 f0       	push   $0xf0108e45
f010103c:	e8 08 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101041:	68 be 8e 10 f0       	push   $0xf0108ebe
f0101046:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010104b:	68 fe 02 00 00       	push   $0x2fe
f0101050:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0101074:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0101079:	6a 58                	push   $0x58
f010107b:	68 51 8e 10 f0       	push   $0xf0108e51
f0101080:	e8 c4 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101085:	68 f0 84 10 f0       	push   $0xf01084f0
f010108a:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010108f:	68 ff 02 00 00       	push   $0x2ff
f0101094:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0101103:	68 d8 8e 10 f0       	push   $0xf0108ed8
f0101108:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010110d:	68 01 03 00 00       	push   $0x301
f0101112:	68 45 8e 10 f0       	push   $0xf0108e45
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
f010112a:	68 38 85 10 f0       	push   $0xf0108538
f010112f:	e8 9c 2d 00 00       	call   f0103ed0 <cprintf>
}
f0101134:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101137:	5b                   	pop    %ebx
f0101138:	5e                   	pop    %esi
f0101139:	5f                   	pop    %edi
f010113a:	5d                   	pop    %ebp
f010113b:	c3                   	ret    
	assert(nfree_basemem > 0);
f010113c:	68 f5 8e 10 f0       	push   $0xf0108ef5
f0101141:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101146:	68 08 03 00 00       	push   $0x308
f010114b:	68 45 8e 10 f0       	push   $0xf0108e45
f0101150:	e8 f4 ee ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f0101155:	68 07 8f 10 f0       	push   $0xf0108f07
f010115a:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010115f:	68 09 03 00 00       	push   $0x309
f0101164:	68 45 8e 10 f0       	push   $0xf0108e45
f0101169:	e8 db ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f010116e:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f0101173:	85 c0                	test   %eax,%eax
f0101175:	0f 84 8f fd ff ff    	je     f0100f0a <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010117b:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010117e:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101181:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101184:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101187:	89 c2                	mov    %eax,%edx
f0101189:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f01011bf:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01011c4:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f01011c9:	8b 1d 40 f2 57 f0    	mov    0xf057f240,%ebx
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
f01011f8:	03 15 b0 0e 58 f0    	add    0xf0580eb0,%edx
f01011fe:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101204:	8b 0d 40 f2 57 f0    	mov    0xf057f240,%ecx
f010120a:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f010120c:	03 05 b0 0e 58 f0    	add    0xf0580eb0,%eax
f0101212:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
f0101217:	eb 12                	jmp    f010122b <page_init+0x57>
			pages[i].pp_ref = 1;
f0101219:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
f010121e:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f0101224:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f010122b:	83 c3 01             	add    $0x1,%ebx
f010122e:	39 1d a8 0e 58 f0    	cmp    %ebx,0xf0580ea8
f0101234:	0f 86 94 00 00 00    	jbe    f01012ce <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f010123a:	85 db                	test   %ebx,%ebx
f010123c:	75 a4                	jne    f01011e2 <page_init+0xe>
			pages[i].pp_ref = 1;
f010123e:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
f0101243:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010124f:	eb da                	jmp    f010122b <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f0101251:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0101257:	77 16                	ja     f010126f <page_init+0x9b>
			pages[i].pp_ref = 1;
f0101259:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
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
f0101295:	03 15 b0 0e 58 f0    	add    0xf0580eb0,%edx
f010129b:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f01012a1:	8b 0d 40 f2 57 f0    	mov    0xf057f240,%ecx
f01012a7:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f01012a9:	03 05 b0 0e 58 f0    	add    0xf0580eb0,%eax
f01012af:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
f01012b4:	e9 72 ff ff ff       	jmp    f010122b <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01012b9:	50                   	push   %eax
f01012ba:	68 d8 7c 10 f0       	push   $0xf0107cd8
f01012bf:	68 4d 01 00 00       	push   $0x14d
f01012c4:	68 45 8e 10 f0       	push   $0xf0108e45
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
f01012da:	8b 1d 40 f2 57 f0    	mov    0xf057f240,%ebx
f01012e0:	85 db                	test   %ebx,%ebx
f01012e2:	74 13                	je     f01012f7 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f01012e4:	8b 03                	mov    (%ebx),%eax
f01012e6:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
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
f0101300:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0101306:	c1 f8 03             	sar    $0x3,%eax
f0101309:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010130c:	89 c2                	mov    %eax,%edx
f010130e:	c1 ea 0c             	shr    $0xc,%edx
f0101311:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0101317:	73 1a                	jae    f0101333 <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f0101319:	83 ec 04             	sub    $0x4,%esp
f010131c:	68 00 10 00 00       	push   $0x1000
f0101321:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101323:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101328:	50                   	push   %eax
f0101329:	e8 b5 52 00 00       	call   f01065e3 <memset>
f010132e:	83 c4 10             	add    $0x10,%esp
f0101331:	eb c4                	jmp    f01012f7 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101333:	50                   	push   %eax
f0101334:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0101339:	6a 58                	push   $0x58
f010133b:	68 51 8e 10 f0       	push   $0xf0108e51
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
f010135a:	8b 15 40 f2 57 f0    	mov    0xf057f240,%edx
f0101360:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101362:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
}
f0101367:	c9                   	leave  
f0101368:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f0101369:	83 ec 04             	sub    $0x4,%esp
f010136c:	68 5c 85 10 f0       	push   $0xf010855c
f0101371:	68 81 01 00 00       	push   $0x181
f0101376:	68 45 8e 10 f0       	push   $0xf0108e45
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
f01013d7:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
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
f010140e:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
f0101414:	c1 fa 03             	sar    $0x3,%edx
f0101417:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f010141a:	83 ca 07             	or     $0x7,%edx
f010141d:	89 13                	mov    %edx,(%ebx)
f010141f:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0101425:	c1 f8 03             	sar    $0x3,%eax
f0101428:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010142b:	89 c2                	mov    %eax,%edx
f010142d:	c1 ea 0c             	shr    $0xc,%edx
f0101430:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0101436:	73 12                	jae    f010144a <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f0101438:	c1 ee 0a             	shr    $0xa,%esi
f010143b:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101441:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0101448:	eb a5                	jmp    f01013ef <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010144a:	50                   	push   %eax
f010144b:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0101450:	6a 58                	push   $0x58
f0101452:	68 51 8e 10 f0       	push   $0xf0108e51
f0101457:	e8 ed eb ff ff       	call   f0100049 <_panic>
f010145c:	50                   	push   %eax
f010145d:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0101462:	68 bb 01 00 00       	push   $0x1bb
f0101467:	68 45 8e 10 f0       	push   $0xf0108e45
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
f01014dc:	68 18 8f 10 f0       	push   $0xf0108f18
f01014e1:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01014e6:	68 d0 01 00 00       	push   $0x1d0
f01014eb:	68 45 8e 10 f0       	push   $0xf0108e45
f01014f0:	e8 54 eb ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f01014f5:	68 25 8f 10 f0       	push   $0xf0108f25
f01014fa:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01014ff:	68 d1 01 00 00       	push   $0x1d1
f0101504:	68 45 8e 10 f0       	push   $0xf0108e45
f0101509:	e8 3b eb ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f010150e:	68 a4 91 10 f0       	push   $0xf01091a4
f0101513:	68 32 8f 10 f0       	push   $0xf0108f32
f0101518:	68 d5 01 00 00       	push   $0x1d5
f010151d:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0101563:	39 05 a8 0e 58 f0    	cmp    %eax,0xf0580ea8
f0101569:	76 0e                	jbe    f0101579 <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010156b:	8b 15 b0 0e 58 f0    	mov    0xf0580eb0,%edx
f0101571:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101577:	c9                   	leave  
f0101578:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101579:	83 ec 04             	sub    $0x4,%esp
f010157c:	68 90 85 10 f0       	push   $0xf0108590
f0101581:	6a 51                	push   $0x51
f0101583:	68 51 8e 10 f0       	push   $0xf0108e51
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
f010159a:	e8 4b 56 00 00       	call   f0106bea <cpunum>
f010159f:	6b c0 74             	imul   $0x74,%eax,%eax
f01015a2:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f01015a9:	74 16                	je     f01015c1 <tlb_invalidate+0x2d>
f01015ab:	e8 3a 56 00 00       	call   f0106bea <cpunum>
f01015b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01015b3:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
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
f010163d:	8b 0d a8 0e 58 f0    	mov    0xf0580ea8,%ecx
f0101643:	89 d0                	mov    %edx,%eax
f0101645:	c1 e8 0c             	shr    $0xc,%eax
f0101648:	39 c1                	cmp    %eax,%ecx
f010164a:	76 5f                	jbe    f01016ab <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f010164c:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f0101652:	89 d8                	mov    %ebx,%eax
f0101654:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0101685:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f01016ac:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01016b1:	68 17 02 00 00       	push   $0x217
f01016b6:	68 45 8e 10 f0       	push   $0xf0108e45
f01016bb:	e8 89 e9 ff ff       	call   f0100049 <_panic>
f01016c0:	50                   	push   %eax
f01016c1:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01016c6:	6a 58                	push   $0x58
f01016c8:	68 51 8e 10 f0       	push   $0xf0108e51
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
f0101705:	8b 35 04 83 12 f0    	mov    0xf0128304,%esi
f010170b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f010170e:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101713:	77 25                	ja     f010173a <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101715:	83 ec 08             	sub    $0x8,%esp
f0101718:	6a 1a                	push   $0x1a
f010171a:	ff 75 08             	pushl  0x8(%ebp)
f010171d:	89 d9                	mov    %ebx,%ecx
f010171f:	89 f2                	mov    %esi,%edx
f0101721:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0101726:	e8 50 fd ff ff       	call   f010147b <boot_map_region>
	base += size;
f010172b:	01 1d 04 83 12 f0    	add    %ebx,0xf0128304
}
f0101731:	89 f0                	mov    %esi,%eax
f0101733:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101736:	5b                   	pop    %ebx
f0101737:	5e                   	pop    %esi
f0101738:	5d                   	pop    %ebp
f0101739:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f010173a:	83 ec 04             	sub    $0x4,%esp
f010173d:	68 3c 8f 10 f0       	push   $0xf0108f3c
f0101742:	68 88 02 00 00       	push   $0x288
f0101747:	68 45 8e 10 f0       	push   $0xf0108e45
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
f010178f:	89 15 a8 0e 58 f0    	mov    %edx,0xf0580ea8
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101795:	89 c2                	mov    %eax,%edx
f0101797:	29 da                	sub    %ebx,%edx
f0101799:	52                   	push   %edx
f010179a:	53                   	push   %ebx
f010179b:	50                   	push   %eax
f010179c:	68 b0 85 10 f0       	push   $0xf01085b0
f01017a1:	e8 2a 27 00 00       	call   f0103ed0 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01017a6:	b8 00 10 00 00       	mov    $0x1000,%eax
f01017ab:	e8 90 f6 ff ff       	call   f0100e40 <boot_alloc>
f01017b0:	a3 ac 0e 58 f0       	mov    %eax,0xf0580eac
	memset(kern_pgdir, 0, PGSIZE);
f01017b5:	83 c4 0c             	add    $0xc,%esp
f01017b8:	68 00 10 00 00       	push   $0x1000
f01017bd:	6a 00                	push   $0x0
f01017bf:	50                   	push   %eax
f01017c0:	e8 1e 4e 00 00       	call   f01065e3 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01017c5:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
	if ((uint32_t)kva < KERNBASE)
f01017ca:	83 c4 10             	add    $0x10,%esp
f01017cd:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017d2:	0f 86 a2 00 00 00    	jbe    f010187a <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f01017d8:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017de:	83 ca 05             	or     $0x5,%edx
f01017e1:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f01017e7:	a1 a8 0e 58 f0       	mov    0xf0580ea8,%eax
f01017ec:	c1 e0 03             	shl    $0x3,%eax
f01017ef:	e8 4c f6 ff ff       	call   f0100e40 <boot_alloc>
f01017f4:	a3 b0 0e 58 f0       	mov    %eax,0xf0580eb0
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01017f9:	83 ec 04             	sub    $0x4,%esp
f01017fc:	8b 15 a8 0e 58 f0    	mov    0xf0580ea8,%edx
f0101802:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f0101809:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010180f:	52                   	push   %edx
f0101810:	6a 00                	push   $0x0
f0101812:	50                   	push   %eax
f0101813:	e8 cb 4d 00 00       	call   f01065e3 <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101818:	b8 00 00 02 00       	mov    $0x20000,%eax
f010181d:	e8 1e f6 ff ff       	call   f0100e40 <boot_alloc>
f0101822:	a3 44 f2 57 f0       	mov    %eax,0xf057f244
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101827:	83 c4 0c             	add    $0xc,%esp
f010182a:	68 00 00 02 00       	push   $0x20000
f010182f:	6a 00                	push   $0x0
f0101831:	50                   	push   %eax
f0101832:	e8 ac 4d 00 00       	call   f01065e3 <memset>
	page_init();
f0101837:	e8 98 f9 ff ff       	call   f01011d4 <page_init>
	check_page_free_list(1);
f010183c:	b8 01 00 00 00       	mov    $0x1,%eax
f0101841:	e8 a0 f6 ff ff       	call   f0100ee6 <check_page_free_list>
	if (!pages)
f0101846:	83 c4 10             	add    $0x10,%esp
f0101849:	83 3d b0 0e 58 f0 00 	cmpl   $0x0,0xf0580eb0
f0101850:	74 3d                	je     f010188f <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101852:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
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
f010187b:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0101880:	68 9a 00 00 00       	push   $0x9a
f0101885:	68 45 8e 10 f0       	push   $0xf0108e45
f010188a:	e8 ba e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f010188f:	83 ec 04             	sub    $0x4,%esp
f0101892:	68 4e 8f 10 f0       	push   $0xf0108f4e
f0101897:	68 1c 03 00 00       	push   $0x31c
f010189c:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0101903:	8b 0d b0 0e 58 f0    	mov    0xf0580eb0,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101909:	8b 15 a8 0e 58 f0    	mov    0xf0580ea8,%edx
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
f0101948:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f010194d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101950:	c7 05 40 f2 57 f0 00 	movl   $0x0,0xf057f240
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
f01019fe:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0101a04:	c1 f8 03             	sar    $0x3,%eax
f0101a07:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a0a:	89 c2                	mov    %eax,%edx
f0101a0c:	c1 ea 0c             	shr    $0xc,%edx
f0101a0f:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0101a15:	0f 83 19 02 00 00    	jae    f0101c34 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a1b:	83 ec 04             	sub    $0x4,%esp
f0101a1e:	68 00 10 00 00       	push   $0x1000
f0101a23:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101a25:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a2a:	50                   	push   %eax
f0101a2b:	e8 b3 4b 00 00       	call   f01065e3 <memset>
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
f0101a57:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0101a5d:	c1 f8 03             	sar    $0x3,%eax
f0101a60:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a63:	89 c2                	mov    %eax,%edx
f0101a65:	c1 ea 0c             	shr    $0xc,%edx
f0101a68:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
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
f0101a92:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
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
f0101ab0:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f0101ab5:	83 c4 10             	add    $0x10,%esp
f0101ab8:	e9 ec 01 00 00       	jmp    f0101ca9 <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101abd:	68 69 8f 10 f0       	push   $0xf0108f69
f0101ac2:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101ac7:	68 24 03 00 00       	push   $0x324
f0101acc:	68 45 8e 10 f0       	push   $0xf0108e45
f0101ad1:	e8 73 e5 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ad6:	68 7f 8f 10 f0       	push   $0xf0108f7f
f0101adb:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101ae0:	68 25 03 00 00       	push   $0x325
f0101ae5:	68 45 8e 10 f0       	push   $0xf0108e45
f0101aea:	e8 5a e5 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101aef:	68 95 8f 10 f0       	push   $0xf0108f95
f0101af4:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101af9:	68 26 03 00 00       	push   $0x326
f0101afe:	68 45 8e 10 f0       	push   $0xf0108e45
f0101b03:	e8 41 e5 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101b08:	68 ab 8f 10 f0       	push   $0xf0108fab
f0101b0d:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101b12:	68 29 03 00 00       	push   $0x329
f0101b17:	68 45 8e 10 f0       	push   $0xf0108e45
f0101b1c:	e8 28 e5 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b21:	68 ec 85 10 f0       	push   $0xf01085ec
f0101b26:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101b2b:	68 2a 03 00 00       	push   $0x32a
f0101b30:	68 45 8e 10 f0       	push   $0xf0108e45
f0101b35:	e8 0f e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b3a:	68 bd 8f 10 f0       	push   $0xf0108fbd
f0101b3f:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101b44:	68 2b 03 00 00       	push   $0x32b
f0101b49:	68 45 8e 10 f0       	push   $0xf0108e45
f0101b4e:	e8 f6 e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b53:	68 da 8f 10 f0       	push   $0xf0108fda
f0101b58:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101b5d:	68 2c 03 00 00       	push   $0x32c
f0101b62:	68 45 8e 10 f0       	push   $0xf0108e45
f0101b67:	e8 dd e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b6c:	68 f7 8f 10 f0       	push   $0xf0108ff7
f0101b71:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101b76:	68 2d 03 00 00       	push   $0x32d
f0101b7b:	68 45 8e 10 f0       	push   $0xf0108e45
f0101b80:	e8 c4 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101b85:	68 14 90 10 f0       	push   $0xf0109014
f0101b8a:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101b8f:	68 34 03 00 00       	push   $0x334
f0101b94:	68 45 8e 10 f0       	push   $0xf0108e45
f0101b99:	e8 ab e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101b9e:	68 69 8f 10 f0       	push   $0xf0108f69
f0101ba3:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101ba8:	68 3b 03 00 00       	push   $0x33b
f0101bad:	68 45 8e 10 f0       	push   $0xf0108e45
f0101bb2:	e8 92 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101bb7:	68 7f 8f 10 f0       	push   $0xf0108f7f
f0101bbc:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101bc1:	68 3c 03 00 00       	push   $0x33c
f0101bc6:	68 45 8e 10 f0       	push   $0xf0108e45
f0101bcb:	e8 79 e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101bd0:	68 95 8f 10 f0       	push   $0xf0108f95
f0101bd5:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101bda:	68 3d 03 00 00       	push   $0x33d
f0101bdf:	68 45 8e 10 f0       	push   $0xf0108e45
f0101be4:	e8 60 e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101be9:	68 ab 8f 10 f0       	push   $0xf0108fab
f0101bee:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101bf3:	68 3f 03 00 00       	push   $0x33f
f0101bf8:	68 45 8e 10 f0       	push   $0xf0108e45
f0101bfd:	e8 47 e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c02:	68 ec 85 10 f0       	push   $0xf01085ec
f0101c07:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101c0c:	68 40 03 00 00       	push   $0x340
f0101c11:	68 45 8e 10 f0       	push   $0xf0108e45
f0101c16:	e8 2e e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c1b:	68 14 90 10 f0       	push   $0xf0109014
f0101c20:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101c25:	68 41 03 00 00       	push   $0x341
f0101c2a:	68 45 8e 10 f0       	push   $0xf0108e45
f0101c2f:	e8 15 e4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c34:	50                   	push   %eax
f0101c35:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0101c3a:	6a 58                	push   $0x58
f0101c3c:	68 51 8e 10 f0       	push   $0xf0108e51
f0101c41:	e8 03 e4 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101c46:	68 23 90 10 f0       	push   $0xf0109023
f0101c4b:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101c50:	68 46 03 00 00       	push   $0x346
f0101c55:	68 45 8e 10 f0       	push   $0xf0108e45
f0101c5a:	e8 ea e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101c5f:	68 41 90 10 f0       	push   $0xf0109041
f0101c64:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101c69:	68 47 03 00 00       	push   $0x347
f0101c6e:	68 45 8e 10 f0       	push   $0xf0108e45
f0101c73:	e8 d1 e3 ff ff       	call   f0100049 <_panic>
f0101c78:	50                   	push   %eax
f0101c79:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0101c7e:	6a 58                	push   $0x58
f0101c80:	68 51 8e 10 f0       	push   $0xf0108e51
f0101c85:	e8 bf e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101c8a:	68 51 90 10 f0       	push   $0xf0109051
f0101c8f:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0101c94:	68 4a 03 00 00       	push   $0x34a
f0101c99:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0101cba:	68 0c 86 10 f0       	push   $0xf010860c
f0101cbf:	e8 0c 22 00 00       	call   f0103ed0 <cprintf>
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
f0101d26:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f0101d2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101d2e:	c7 05 40 f2 57 f0 00 	movl   $0x0,0xf057f240
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
f0101d56:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101d5c:	e8 ce f7 ff ff       	call   f010152f <page_lookup>
f0101d61:	83 c4 10             	add    $0x10,%esp
f0101d64:	85 c0                	test   %eax,%eax
f0101d66:	0f 85 5f 09 00 00    	jne    f01026cb <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101d6c:	6a 02                	push   $0x2
f0101d6e:	6a 00                	push   $0x0
f0101d70:	57                   	push   %edi
f0101d71:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f0101d97:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101d9d:	e8 6d f8 ff ff       	call   f010160f <page_insert>
f0101da2:	83 c4 20             	add    $0x20,%esp
f0101da5:	85 c0                	test   %eax,%eax
f0101da7:	0f 85 50 09 00 00    	jne    f01026fd <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101dad:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
	return (pp - pages) << PGSHIFT;
f0101db3:	8b 0d b0 0e 58 f0    	mov    0xf0580eb0,%ecx
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
f0101e2d:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0101e32:	e8 a5 ef ff ff       	call   f0100ddc <check_va2pa>
f0101e37:	89 da                	mov    %ebx,%edx
f0101e39:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0101e75:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101e7b:	e8 8f f7 ff ff       	call   f010160f <page_insert>
f0101e80:	83 c4 10             	add    $0x10,%esp
f0101e83:	85 c0                	test   %eax,%eax
f0101e85:	0f 85 53 09 00 00    	jne    f01027de <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e8b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e90:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0101e95:	e8 42 ef ff ff       	call   f0100ddc <check_va2pa>
f0101e9a:	89 da                	mov    %ebx,%edx
f0101e9c:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0101ed0:	8b 15 ac 0e 58 f0    	mov    0xf0580eac,%edx
f0101ed6:	8b 02                	mov    (%edx),%eax
f0101ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101edd:	89 c1                	mov    %eax,%ecx
f0101edf:	c1 e9 0c             	shr    $0xc,%ecx
f0101ee2:	3b 0d a8 0e 58 f0    	cmp    0xf0580ea8,%ecx
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
f0101f1f:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101f25:	e8 e5 f6 ff ff       	call   f010160f <page_insert>
f0101f2a:	83 c4 10             	add    $0x10,%esp
f0101f2d:	85 c0                	test   %eax,%eax
f0101f2f:	0f 85 3b 09 00 00    	jne    f0102870 <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f35:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
f0101f3b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f40:	89 f0                	mov    %esi,%eax
f0101f42:	e8 95 ee ff ff       	call   f0100ddc <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101f47:	89 da                	mov    %ebx,%edx
f0101f49:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0101f84:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0101fb5:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101fbb:	e8 e9 f3 ff ff       	call   f01013a9 <pgdir_walk>
f0101fc0:	83 c4 10             	add    $0x10,%esp
f0101fc3:	f6 00 02             	testb  $0x2,(%eax)
f0101fc6:	0f 84 3a 09 00 00    	je     f0102906 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101fcc:	83 ec 04             	sub    $0x4,%esp
f0101fcf:	6a 00                	push   $0x0
f0101fd1:	68 00 10 00 00       	push   $0x1000
f0101fd6:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101fdc:	e8 c8 f3 ff ff       	call   f01013a9 <pgdir_walk>
f0101fe1:	83 c4 10             	add    $0x10,%esp
f0101fe4:	f6 00 04             	testb  $0x4,(%eax)
f0101fe7:	0f 85 32 09 00 00    	jne    f010291f <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101fed:	6a 02                	push   $0x2
f0101fef:	68 00 00 40 00       	push   $0x400000
f0101ff4:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101ff7:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101ffd:	e8 0d f6 ff ff       	call   f010160f <page_insert>
f0102002:	83 c4 10             	add    $0x10,%esp
f0102005:	85 c0                	test   %eax,%eax
f0102007:	0f 89 2b 09 00 00    	jns    f0102938 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010200d:	6a 02                	push   $0x2
f010200f:	68 00 10 00 00       	push   $0x1000
f0102014:	57                   	push   %edi
f0102015:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010201b:	e8 ef f5 ff ff       	call   f010160f <page_insert>
f0102020:	83 c4 10             	add    $0x10,%esp
f0102023:	85 c0                	test   %eax,%eax
f0102025:	0f 85 26 09 00 00    	jne    f0102951 <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010202b:	83 ec 04             	sub    $0x4,%esp
f010202e:	6a 00                	push   $0x0
f0102030:	68 00 10 00 00       	push   $0x1000
f0102035:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010203b:	e8 69 f3 ff ff       	call   f01013a9 <pgdir_walk>
f0102040:	83 c4 10             	add    $0x10,%esp
f0102043:	f6 00 04             	testb  $0x4,(%eax)
f0102046:	0f 85 1e 09 00 00    	jne    f010296a <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010204c:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102051:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102054:	ba 00 00 00 00       	mov    $0x0,%edx
f0102059:	e8 7e ed ff ff       	call   f0100ddc <check_va2pa>
f010205e:	89 fe                	mov    %edi,%esi
f0102060:	2b 35 b0 0e 58 f0    	sub    0xf0580eb0,%esi
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
f01020c1:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01020c7:	e8 fd f4 ff ff       	call   f01015c9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01020cc:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
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
f01020f8:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0102157:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010215d:	e8 67 f4 ff ff       	call   f01015c9 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102162:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
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
f01021dd:	8b 0d ac 0e 58 f0    	mov    0xf0580eac,%ecx
f01021e3:	8b 11                	mov    (%ecx),%edx
f01021e5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01021eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021ee:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0102232:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0102238:	e8 6c f1 ff ff       	call   f01013a9 <pgdir_walk>
f010223d:	89 c1                	mov    %eax,%ecx
f010223f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102242:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102247:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010224a:	8b 40 04             	mov    0x4(%eax),%eax
f010224d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102252:	8b 35 a8 0e 58 f0    	mov    0xf0580ea8,%esi
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
f0102288:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f01022b4:	e8 2a 43 00 00       	call   f01065e3 <memset>
	page_free(pp0);
f01022b9:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01022bc:	89 34 24             	mov    %esi,(%esp)
f01022bf:	e8 81 f0 ff ff       	call   f0101345 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01022c4:	83 c4 0c             	add    $0xc,%esp
f01022c7:	6a 01                	push   $0x1
f01022c9:	6a 00                	push   $0x0
f01022cb:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01022d1:	e8 d3 f0 ff ff       	call   f01013a9 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01022d6:	89 f0                	mov    %esi,%eax
f01022d8:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01022de:	c1 f8 03             	sar    $0x3,%eax
f01022e1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022e4:	89 c2                	mov    %eax,%edx
f01022e6:	c1 ea 0c             	shr    $0xc,%edx
f01022e9:	83 c4 10             	add    $0x10,%esp
f01022ec:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
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
f0102316:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f010231b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102321:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102324:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f010232a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010232d:	89 0d 40 f2 57 f0    	mov    %ecx,0xf057f240

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
f01023c4:	8b 3d ac 0e 58 f0    	mov    0xf0580eac,%edi
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
f010243d:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f010245e:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0102464:	e8 40 ef ff ff       	call   f01013a9 <pgdir_walk>
f0102469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f010246f:	83 c4 0c             	add    $0xc,%esp
f0102472:	6a 00                	push   $0x0
f0102474:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102477:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010247d:	e8 27 ef ff ff       	call   f01013a9 <pgdir_walk>
f0102482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102488:	83 c4 0c             	add    $0xc,%esp
f010248b:	6a 00                	push   $0x0
f010248d:	56                   	push   %esi
f010248e:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0102494:	e8 10 ef ff ff       	call   f01013a9 <pgdir_walk>
f0102499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f010249f:	c7 04 24 44 91 10 f0 	movl   $0xf0109144,(%esp)
f01024a6:	e8 25 1a 00 00       	call   f0103ed0 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01024ab:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
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
f01024d3:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f01024d8:	e8 9e ef ff ff       	call   f010147b <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01024dd:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
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
f0102505:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f010250a:	e8 6c ef ff ff       	call   f010147b <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010250f:	83 c4 10             	add    $0x10,%esp
f0102512:	b8 00 f0 11 f0       	mov    $0xf011f000,%eax
f0102517:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010251c:	0f 86 e4 07 00 00    	jbe    f0102d06 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102522:	83 ec 08             	sub    $0x8,%esp
f0102525:	6a 02                	push   $0x2
f0102527:	68 00 f0 11 00       	push   $0x11f000
f010252c:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102531:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102536:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f010253b:	e8 3b ef ff ff       	call   f010147b <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f0102540:	83 c4 08             	add    $0x8,%esp
f0102543:	6a 02                	push   $0x2
f0102545:	6a 00                	push   $0x0
f0102547:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010254c:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102551:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102556:	e8 20 ef ff ff       	call   f010147b <boot_map_region>
f010255b:	c7 45 d0 00 20 58 f0 	movl   $0xf0582000,-0x30(%ebp)
f0102562:	83 c4 10             	add    $0x10,%esp
f0102565:	bb 00 20 58 f0       	mov    $0xf0582000,%ebx
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
f010258e:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102593:	e8 e3 ee ff ff       	call   f010147b <boot_map_region>
f0102598:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010259e:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f01025a4:	83 c4 10             	add    $0x10,%esp
f01025a7:	81 fb 00 20 5c f0    	cmp    $0xf05c2000,%ebx
f01025ad:	75 c0                	jne    f010256f <mem_init+0xe1e>
	pgdir = kern_pgdir;
f01025af:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f01025b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01025b7:	a1 a8 0e 58 f0       	mov    0xf0580ea8,%eax
f01025bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01025bf:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01025c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025ce:	8b 35 b0 0e 58 f0    	mov    0xf0580eb0,%esi
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
f010261c:	68 5b 90 10 f0       	push   $0xf010905b
f0102621:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102626:	68 57 03 00 00       	push   $0x357
f010262b:	68 45 8e 10 f0       	push   $0xf0108e45
f0102630:	e8 14 da ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0102635:	68 69 8f 10 f0       	push   $0xf0108f69
f010263a:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010263f:	68 ca 03 00 00       	push   $0x3ca
f0102644:	68 45 8e 10 f0       	push   $0xf0108e45
f0102649:	e8 fb d9 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010264e:	68 7f 8f 10 f0       	push   $0xf0108f7f
f0102653:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102658:	68 cb 03 00 00       	push   $0x3cb
f010265d:	68 45 8e 10 f0       	push   $0xf0108e45
f0102662:	e8 e2 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0102667:	68 95 8f 10 f0       	push   $0xf0108f95
f010266c:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102671:	68 cc 03 00 00       	push   $0x3cc
f0102676:	68 45 8e 10 f0       	push   $0xf0108e45
f010267b:	e8 c9 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0102680:	68 ab 8f 10 f0       	push   $0xf0108fab
f0102685:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010268a:	68 cf 03 00 00       	push   $0x3cf
f010268f:	68 45 8e 10 f0       	push   $0xf0108e45
f0102694:	e8 b0 d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102699:	68 ec 85 10 f0       	push   $0xf01085ec
f010269e:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01026a3:	68 d0 03 00 00       	push   $0x3d0
f01026a8:	68 45 8e 10 f0       	push   $0xf0108e45
f01026ad:	e8 97 d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01026b2:	68 14 90 10 f0       	push   $0xf0109014
f01026b7:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01026bc:	68 d7 03 00 00       	push   $0x3d7
f01026c1:	68 45 8e 10 f0       	push   $0xf0108e45
f01026c6:	e8 7e d9 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01026cb:	68 2c 86 10 f0       	push   $0xf010862c
f01026d0:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01026d5:	68 da 03 00 00       	push   $0x3da
f01026da:	68 45 8e 10 f0       	push   $0xf0108e45
f01026df:	e8 65 d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01026e4:	68 64 86 10 f0       	push   $0xf0108664
f01026e9:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01026ee:	68 dd 03 00 00       	push   $0x3dd
f01026f3:	68 45 8e 10 f0       	push   $0xf0108e45
f01026f8:	e8 4c d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01026fd:	68 94 86 10 f0       	push   $0xf0108694
f0102702:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102707:	68 e1 03 00 00       	push   $0x3e1
f010270c:	68 45 8e 10 f0       	push   $0xf0108e45
f0102711:	e8 33 d9 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102716:	68 c4 86 10 f0       	push   $0xf01086c4
f010271b:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102720:	68 e2 03 00 00       	push   $0x3e2
f0102725:	68 45 8e 10 f0       	push   $0xf0108e45
f010272a:	e8 1a d9 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010272f:	68 ec 86 10 f0       	push   $0xf01086ec
f0102734:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102739:	68 e3 03 00 00       	push   $0x3e3
f010273e:	68 45 8e 10 f0       	push   $0xf0108e45
f0102743:	e8 01 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102748:	68 66 90 10 f0       	push   $0xf0109066
f010274d:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102752:	68 e4 03 00 00       	push   $0x3e4
f0102757:	68 45 8e 10 f0       	push   $0xf0108e45
f010275c:	e8 e8 d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102761:	68 77 90 10 f0       	push   $0xf0109077
f0102766:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010276b:	68 e5 03 00 00       	push   $0x3e5
f0102770:	68 45 8e 10 f0       	push   $0xf0108e45
f0102775:	e8 cf d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010277a:	68 1c 87 10 f0       	push   $0xf010871c
f010277f:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102784:	68 e8 03 00 00       	push   $0x3e8
f0102789:	68 45 8e 10 f0       	push   $0xf0108e45
f010278e:	e8 b6 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102793:	68 58 87 10 f0       	push   $0xf0108758
f0102798:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010279d:	68 e9 03 00 00       	push   $0x3e9
f01027a2:	68 45 8e 10 f0       	push   $0xf0108e45
f01027a7:	e8 9d d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01027ac:	68 88 90 10 f0       	push   $0xf0109088
f01027b1:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01027b6:	68 ea 03 00 00       	push   $0x3ea
f01027bb:	68 45 8e 10 f0       	push   $0xf0108e45
f01027c0:	e8 84 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01027c5:	68 14 90 10 f0       	push   $0xf0109014
f01027ca:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01027cf:	68 ed 03 00 00       	push   $0x3ed
f01027d4:	68 45 8e 10 f0       	push   $0xf0108e45
f01027d9:	e8 6b d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027de:	68 1c 87 10 f0       	push   $0xf010871c
f01027e3:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01027e8:	68 f0 03 00 00       	push   $0x3f0
f01027ed:	68 45 8e 10 f0       	push   $0xf0108e45
f01027f2:	e8 52 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027f7:	68 58 87 10 f0       	push   $0xf0108758
f01027fc:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102801:	68 f1 03 00 00       	push   $0x3f1
f0102806:	68 45 8e 10 f0       	push   $0xf0108e45
f010280b:	e8 39 d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102810:	68 88 90 10 f0       	push   $0xf0109088
f0102815:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010281a:	68 f2 03 00 00       	push   $0x3f2
f010281f:	68 45 8e 10 f0       	push   $0xf0108e45
f0102824:	e8 20 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102829:	68 14 90 10 f0       	push   $0xf0109014
f010282e:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102833:	68 f6 03 00 00       	push   $0x3f6
f0102838:	68 45 8e 10 f0       	push   $0xf0108e45
f010283d:	e8 07 d8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102842:	50                   	push   %eax
f0102843:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0102848:	68 f9 03 00 00       	push   $0x3f9
f010284d:	68 45 8e 10 f0       	push   $0xf0108e45
f0102852:	e8 f2 d7 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102857:	68 88 87 10 f0       	push   $0xf0108788
f010285c:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102861:	68 fa 03 00 00       	push   $0x3fa
f0102866:	68 45 8e 10 f0       	push   $0xf0108e45
f010286b:	e8 d9 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102870:	68 c8 87 10 f0       	push   $0xf01087c8
f0102875:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010287a:	68 fd 03 00 00       	push   $0x3fd
f010287f:	68 45 8e 10 f0       	push   $0xf0108e45
f0102884:	e8 c0 d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102889:	68 58 87 10 f0       	push   $0xf0108758
f010288e:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102893:	68 fe 03 00 00       	push   $0x3fe
f0102898:	68 45 8e 10 f0       	push   $0xf0108e45
f010289d:	e8 a7 d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f01028a2:	68 88 90 10 f0       	push   $0xf0109088
f01028a7:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01028ac:	68 ff 03 00 00       	push   $0x3ff
f01028b1:	68 45 8e 10 f0       	push   $0xf0108e45
f01028b6:	e8 8e d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01028bb:	68 08 88 10 f0       	push   $0xf0108808
f01028c0:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01028c5:	68 00 04 00 00       	push   $0x400
f01028ca:	68 45 8e 10 f0       	push   $0xf0108e45
f01028cf:	e8 75 d7 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01028d4:	68 99 90 10 f0       	push   $0xf0109099
f01028d9:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01028de:	68 01 04 00 00       	push   $0x401
f01028e3:	68 45 8e 10 f0       	push   $0xf0108e45
f01028e8:	e8 5c d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01028ed:	68 1c 87 10 f0       	push   $0xf010871c
f01028f2:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01028f7:	68 04 04 00 00       	push   $0x404
f01028fc:	68 45 8e 10 f0       	push   $0xf0108e45
f0102901:	e8 43 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102906:	68 3c 88 10 f0       	push   $0xf010883c
f010290b:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102910:	68 05 04 00 00       	push   $0x405
f0102915:	68 45 8e 10 f0       	push   $0xf0108e45
f010291a:	e8 2a d7 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010291f:	68 70 88 10 f0       	push   $0xf0108870
f0102924:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102929:	68 06 04 00 00       	push   $0x406
f010292e:	68 45 8e 10 f0       	push   $0xf0108e45
f0102933:	e8 11 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102938:	68 a8 88 10 f0       	push   $0xf01088a8
f010293d:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102942:	68 09 04 00 00       	push   $0x409
f0102947:	68 45 8e 10 f0       	push   $0xf0108e45
f010294c:	e8 f8 d6 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102951:	68 e0 88 10 f0       	push   $0xf01088e0
f0102956:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010295b:	68 0c 04 00 00       	push   $0x40c
f0102960:	68 45 8e 10 f0       	push   $0xf0108e45
f0102965:	e8 df d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010296a:	68 70 88 10 f0       	push   $0xf0108870
f010296f:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102974:	68 0d 04 00 00       	push   $0x40d
f0102979:	68 45 8e 10 f0       	push   $0xf0108e45
f010297e:	e8 c6 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102983:	68 1c 89 10 f0       	push   $0xf010891c
f0102988:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010298d:	68 10 04 00 00       	push   $0x410
f0102992:	68 45 8e 10 f0       	push   $0xf0108e45
f0102997:	e8 ad d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010299c:	68 48 89 10 f0       	push   $0xf0108948
f01029a1:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01029a6:	68 11 04 00 00       	push   $0x411
f01029ab:	68 45 8e 10 f0       	push   $0xf0108e45
f01029b0:	e8 94 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f01029b5:	68 af 90 10 f0       	push   $0xf01090af
f01029ba:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01029bf:	68 13 04 00 00       	push   $0x413
f01029c4:	68 45 8e 10 f0       	push   $0xf0108e45
f01029c9:	e8 7b d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01029ce:	68 c0 90 10 f0       	push   $0xf01090c0
f01029d3:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01029d8:	68 14 04 00 00       	push   $0x414
f01029dd:	68 45 8e 10 f0       	push   $0xf0108e45
f01029e2:	e8 62 d6 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01029e7:	68 78 89 10 f0       	push   $0xf0108978
f01029ec:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01029f1:	68 17 04 00 00       	push   $0x417
f01029f6:	68 45 8e 10 f0       	push   $0xf0108e45
f01029fb:	e8 49 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a00:	68 9c 89 10 f0       	push   $0xf010899c
f0102a05:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102a0a:	68 1b 04 00 00       	push   $0x41b
f0102a0f:	68 45 8e 10 f0       	push   $0xf0108e45
f0102a14:	e8 30 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a19:	68 48 89 10 f0       	push   $0xf0108948
f0102a1e:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102a23:	68 1c 04 00 00       	push   $0x41c
f0102a28:	68 45 8e 10 f0       	push   $0xf0108e45
f0102a2d:	e8 17 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102a32:	68 66 90 10 f0       	push   $0xf0109066
f0102a37:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102a3c:	68 1d 04 00 00       	push   $0x41d
f0102a41:	68 45 8e 10 f0       	push   $0xf0108e45
f0102a46:	e8 fe d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a4b:	68 c0 90 10 f0       	push   $0xf01090c0
f0102a50:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102a55:	68 1e 04 00 00       	push   $0x41e
f0102a5a:	68 45 8e 10 f0       	push   $0xf0108e45
f0102a5f:	e8 e5 d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102a64:	68 c0 89 10 f0       	push   $0xf01089c0
f0102a69:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102a6e:	68 21 04 00 00       	push   $0x421
f0102a73:	68 45 8e 10 f0       	push   $0xf0108e45
f0102a78:	e8 cc d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102a7d:	68 d1 90 10 f0       	push   $0xf01090d1
f0102a82:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102a87:	68 22 04 00 00       	push   $0x422
f0102a8c:	68 45 8e 10 f0       	push   $0xf0108e45
f0102a91:	e8 b3 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102a96:	68 dd 90 10 f0       	push   $0xf01090dd
f0102a9b:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102aa0:	68 23 04 00 00       	push   $0x423
f0102aa5:	68 45 8e 10 f0       	push   $0xf0108e45
f0102aaa:	e8 9a d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102aaf:	68 9c 89 10 f0       	push   $0xf010899c
f0102ab4:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102ab9:	68 27 04 00 00       	push   $0x427
f0102abe:	68 45 8e 10 f0       	push   $0xf0108e45
f0102ac3:	e8 81 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102ac8:	68 f8 89 10 f0       	push   $0xf01089f8
f0102acd:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102ad2:	68 28 04 00 00       	push   $0x428
f0102ad7:	68 45 8e 10 f0       	push   $0xf0108e45
f0102adc:	e8 68 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102ae1:	68 f2 90 10 f0       	push   $0xf01090f2
f0102ae6:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102aeb:	68 29 04 00 00       	push   $0x429
f0102af0:	68 45 8e 10 f0       	push   $0xf0108e45
f0102af5:	e8 4f d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102afa:	68 c0 90 10 f0       	push   $0xf01090c0
f0102aff:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102b04:	68 2a 04 00 00       	push   $0x42a
f0102b09:	68 45 8e 10 f0       	push   $0xf0108e45
f0102b0e:	e8 36 d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b13:	68 20 8a 10 f0       	push   $0xf0108a20
f0102b18:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102b1d:	68 2d 04 00 00       	push   $0x42d
f0102b22:	68 45 8e 10 f0       	push   $0xf0108e45
f0102b27:	e8 1d d5 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102b2c:	68 14 90 10 f0       	push   $0xf0109014
f0102b31:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102b36:	68 30 04 00 00       	push   $0x430
f0102b3b:	68 45 8e 10 f0       	push   $0xf0108e45
f0102b40:	e8 04 d5 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b45:	68 c4 86 10 f0       	push   $0xf01086c4
f0102b4a:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102b4f:	68 33 04 00 00       	push   $0x433
f0102b54:	68 45 8e 10 f0       	push   $0xf0108e45
f0102b59:	e8 eb d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102b5e:	68 77 90 10 f0       	push   $0xf0109077
f0102b63:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102b68:	68 35 04 00 00       	push   $0x435
f0102b6d:	68 45 8e 10 f0       	push   $0xf0108e45
f0102b72:	e8 d2 d4 ff ff       	call   f0100049 <_panic>
f0102b77:	50                   	push   %eax
f0102b78:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0102b7d:	68 3c 04 00 00       	push   $0x43c
f0102b82:	68 45 8e 10 f0       	push   $0xf0108e45
f0102b87:	e8 bd d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102b8c:	68 03 91 10 f0       	push   $0xf0109103
f0102b91:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102b96:	68 3d 04 00 00       	push   $0x43d
f0102b9b:	68 45 8e 10 f0       	push   $0xf0108e45
f0102ba0:	e8 a4 d4 ff ff       	call   f0100049 <_panic>
f0102ba5:	50                   	push   %eax
f0102ba6:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0102bab:	6a 58                	push   $0x58
f0102bad:	68 51 8e 10 f0       	push   $0xf0108e51
f0102bb2:	e8 92 d4 ff ff       	call   f0100049 <_panic>
f0102bb7:	50                   	push   %eax
f0102bb8:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0102bbd:	6a 58                	push   $0x58
f0102bbf:	68 51 8e 10 f0       	push   $0xf0108e51
f0102bc4:	e8 80 d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102bc9:	68 1b 91 10 f0       	push   $0xf010911b
f0102bce:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102bd3:	68 47 04 00 00       	push   $0x447
f0102bd8:	68 45 8e 10 f0       	push   $0xf0108e45
f0102bdd:	e8 67 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102be2:	68 44 8a 10 f0       	push   $0xf0108a44
f0102be7:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102bec:	68 57 04 00 00       	push   $0x457
f0102bf1:	68 45 8e 10 f0       	push   $0xf0108e45
f0102bf6:	e8 4e d4 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102bfb:	68 6c 8a 10 f0       	push   $0xf0108a6c
f0102c00:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102c05:	68 58 04 00 00       	push   $0x458
f0102c0a:	68 45 8e 10 f0       	push   $0xf0108e45
f0102c0f:	e8 35 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c14:	68 94 8a 10 f0       	push   $0xf0108a94
f0102c19:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102c1e:	68 5a 04 00 00       	push   $0x45a
f0102c23:	68 45 8e 10 f0       	push   $0xf0108e45
f0102c28:	e8 1c d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102c2d:	68 32 91 10 f0       	push   $0xf0109132
f0102c32:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102c37:	68 5c 04 00 00       	push   $0x45c
f0102c3c:	68 45 8e 10 f0       	push   $0xf0108e45
f0102c41:	e8 03 d4 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c46:	68 bc 8a 10 f0       	push   $0xf0108abc
f0102c4b:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102c50:	68 5e 04 00 00       	push   $0x45e
f0102c55:	68 45 8e 10 f0       	push   $0xf0108e45
f0102c5a:	e8 ea d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c5f:	68 e0 8a 10 f0       	push   $0xf0108ae0
f0102c64:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102c69:	68 5f 04 00 00       	push   $0x45f
f0102c6e:	68 45 8e 10 f0       	push   $0xf0108e45
f0102c73:	e8 d1 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c78:	68 10 8b 10 f0       	push   $0xf0108b10
f0102c7d:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102c82:	68 60 04 00 00       	push   $0x460
f0102c87:	68 45 8e 10 f0       	push   $0xf0108e45
f0102c8c:	e8 b8 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102c91:	68 34 8b 10 f0       	push   $0xf0108b34
f0102c96:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102c9b:	68 61 04 00 00       	push   $0x461
f0102ca0:	68 45 8e 10 f0       	push   $0xf0108e45
f0102ca5:	e8 9f d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102caa:	68 60 8b 10 f0       	push   $0xf0108b60
f0102caf:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102cb4:	68 63 04 00 00       	push   $0x463
f0102cb9:	68 45 8e 10 f0       	push   $0xf0108e45
f0102cbe:	e8 86 d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102cc3:	68 a4 8b 10 f0       	push   $0xf0108ba4
f0102cc8:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102ccd:	68 64 04 00 00       	push   $0x464
f0102cd2:	68 45 8e 10 f0       	push   $0xf0108e45
f0102cd7:	e8 6d d3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102cdc:	50                   	push   %eax
f0102cdd:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0102ce2:	68 be 00 00 00       	push   $0xbe
f0102ce7:	68 45 8e 10 f0       	push   $0xf0108e45
f0102cec:	e8 58 d3 ff ff       	call   f0100049 <_panic>
f0102cf1:	50                   	push   %eax
f0102cf2:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0102cf7:	68 c6 00 00 00       	push   $0xc6
f0102cfc:	68 45 8e 10 f0       	push   $0xf0108e45
f0102d01:	e8 43 d3 ff ff       	call   f0100049 <_panic>
f0102d06:	50                   	push   %eax
f0102d07:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0102d0c:	68 d2 00 00 00       	push   $0xd2
f0102d11:	68 45 8e 10 f0       	push   $0xf0108e45
f0102d16:	e8 2e d3 ff ff       	call   f0100049 <_panic>
f0102d1b:	53                   	push   %ebx
f0102d1c:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0102d21:	68 17 01 00 00       	push   $0x117
f0102d26:	68 45 8e 10 f0       	push   $0xf0108e45
f0102d2b:	e8 19 d3 ff ff       	call   f0100049 <_panic>
f0102d30:	56                   	push   %esi
f0102d31:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0102d36:	68 6e 03 00 00       	push   $0x36e
f0102d3b:	68 45 8e 10 f0       	push   $0xf0108e45
f0102d40:	e8 04 d3 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d45:	68 d8 8b 10 f0       	push   $0xf0108bd8
f0102d4a:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102d4f:	68 6e 03 00 00       	push   $0x36e
f0102d54:	68 45 8e 10 f0       	push   $0xf0108e45
f0102d59:	e8 eb d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102d5e:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
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
f0102dcf:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0102dd4:	68 73 03 00 00       	push   $0x373
f0102dd9:	68 45 8e 10 f0       	push   $0xf0108e45
f0102dde:	e8 66 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102de3:	68 0c 8c 10 f0       	push   $0xf0108c0c
f0102de8:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102ded:	68 73 03 00 00       	push   $0x373
f0102df2:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0102e2b:	68 40 8c 10 f0       	push   $0xf0108c40
f0102e30:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102e35:	68 78 03 00 00       	push   $0x378
f0102e3a:	68 45 8e 10 f0       	push   $0xf0108e45
f0102e3f:	e8 05 d2 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102e44:	83 ec 0c             	sub    $0xc,%esp
f0102e47:	68 5d 91 10 f0       	push   $0xf010915d
f0102e4c:	e8 7f 10 00 00       	call   f0103ed0 <cprintf>
f0102e51:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e54:	b8 00 20 58 f0       	mov    $0xf0582000,%eax
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
f0102ee1:	81 ff 00 20 5c f0    	cmp    $0xf05c2000,%edi
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
f0102f15:	68 6c 8c 10 f0       	push   $0xf0108c6c
f0102f1a:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102f1f:	68 7d 03 00 00       	push   $0x37d
f0102f24:	68 45 8e 10 f0       	push   $0xf0108e45
f0102f29:	e8 1b d1 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f2e:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f31:	c1 e6 0c             	shl    $0xc,%esi
f0102f34:	89 fb                	mov    %edi,%ebx
f0102f36:	eb c3                	jmp    f0102efb <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f38:	ff 75 c0             	pushl  -0x40(%ebp)
f0102f3b:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0102f40:	68 85 03 00 00       	push   $0x385
f0102f45:	68 45 8e 10 f0       	push   $0xf0108e45
f0102f4a:	e8 fa d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102f4f:	68 94 8c 10 f0       	push   $0xf0108c94
f0102f54:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102f59:	68 85 03 00 00       	push   $0x385
f0102f5e:	68 45 8e 10 f0       	push   $0xf0108e45
f0102f63:	e8 e1 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f68:	68 dc 8c 10 f0       	push   $0xf0108cdc
f0102f6d:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102f72:	68 87 03 00 00       	push   $0x387
f0102f77:	68 45 8e 10 f0       	push   $0xf0108e45
f0102f7c:	e8 c8 d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0102f81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f84:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102f88:	75 4e                	jne    f0102fd8 <mem_init+0x1887>
f0102f8a:	68 74 91 10 f0       	push   $0xf0109174
f0102f8f:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102f94:	68 92 03 00 00       	push   $0x392
f0102f99:	68 45 8e 10 f0       	push   $0xf0108e45
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
f0102fdd:	68 74 91 10 f0       	push   $0xf0109174
f0102fe2:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0102fe7:	68 96 03 00 00       	push   $0x396
f0102fec:	68 45 8e 10 f0       	push   $0xf0108e45
f0102ff1:	e8 53 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0102ff6:	68 85 91 10 f0       	push   $0xf0109185
f0102ffb:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0103000:	68 97 03 00 00       	push   $0x397
f0103005:	68 45 8e 10 f0       	push   $0xf0108e45
f010300a:	e8 3a d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f010300f:	68 96 91 10 f0       	push   $0xf0109196
f0103014:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0103019:	68 99 03 00 00       	push   $0x399
f010301e:	68 45 8e 10 f0       	push   $0xf0108e45
f0103023:	e8 21 d0 ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103028:	83 ec 0c             	sub    $0xc,%esp
f010302b:	68 00 8d 10 f0       	push   $0xf0108d00
f0103030:	e8 9b 0e 00 00       	call   f0103ed0 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f0103035:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f0103038:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f010303b:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f010303e:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f01030c1:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01030c7:	c1 f8 03             	sar    $0x3,%eax
f01030ca:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030cd:	89 c2                	mov    %eax,%edx
f01030cf:	c1 ea 0c             	shr    $0xc,%edx
f01030d2:	83 c4 10             	add    $0x10,%esp
f01030d5:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01030db:	0f 83 cb 01 00 00    	jae    f01032ac <mem_init+0x1b5b>
	memset(page2kva(pp1), 1, PGSIZE);
f01030e1:	83 ec 04             	sub    $0x4,%esp
f01030e4:	68 00 10 00 00       	push   $0x1000
f01030e9:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01030eb:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01030f0:	50                   	push   %eax
f01030f1:	e8 ed 34 00 00       	call   f01065e3 <memset>
	return (pp - pages) << PGSHIFT;
f01030f6:	89 d8                	mov    %ebx,%eax
f01030f8:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01030fe:	c1 f8 03             	sar    $0x3,%eax
f0103101:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103104:	89 c2                	mov    %eax,%edx
f0103106:	c1 ea 0c             	shr    $0xc,%edx
f0103109:	83 c4 10             	add    $0x10,%esp
f010310c:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0103112:	0f 83 a6 01 00 00    	jae    f01032be <mem_init+0x1b6d>
	memset(page2kva(pp2), 2, PGSIZE);
f0103118:	83 ec 04             	sub    $0x4,%esp
f010311b:	68 00 10 00 00       	push   $0x1000
f0103120:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0103122:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103127:	50                   	push   %eax
f0103128:	e8 b6 34 00 00       	call   f01065e3 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f010312d:	6a 02                	push   $0x2
f010312f:	68 00 10 00 00       	push   $0x1000
f0103134:	57                   	push   %edi
f0103135:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f0103166:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f01031a6:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01031ac:	c1 f8 03             	sar    $0x3,%eax
f01031af:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01031b2:	89 c2                	mov    %eax,%edx
f01031b4:	c1 ea 0c             	shr    $0xc,%edx
f01031b7:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01031bd:	0f 83 8a 01 00 00    	jae    f010334d <mem_init+0x1bfc>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01031c3:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01031ca:	03 03 03 
f01031cd:	0f 85 8c 01 00 00    	jne    f010335f <mem_init+0x1c0e>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01031d3:	83 ec 08             	sub    $0x8,%esp
f01031d6:	68 00 10 00 00       	push   $0x1000
f01031db:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01031e1:	e8 e3 e3 ff ff       	call   f01015c9 <page_remove>
	assert(pp2->pp_ref == 0);
f01031e6:	83 c4 10             	add    $0x10,%esp
f01031e9:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01031ee:	0f 85 84 01 00 00    	jne    f0103378 <mem_init+0x1c27>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01031f4:	8b 0d ac 0e 58 f0    	mov    0xf0580eac,%ecx
f01031fa:	8b 11                	mov    (%ecx),%edx
f01031fc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0103202:	89 f0                	mov    %esi,%eax
f0103204:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0103238:	c7 04 24 94 8d 10 f0 	movl   $0xf0108d94,(%esp)
f010323f:	e8 8c 0c 00 00       	call   f0103ed0 <cprintf>
}
f0103244:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103247:	5b                   	pop    %ebx
f0103248:	5e                   	pop    %esi
f0103249:	5f                   	pop    %edi
f010324a:	5d                   	pop    %ebp
f010324b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010324c:	50                   	push   %eax
f010324d:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0103252:	68 ef 00 00 00       	push   $0xef
f0103257:	68 45 8e 10 f0       	push   $0xf0108e45
f010325c:	e8 e8 cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0103261:	68 69 8f 10 f0       	push   $0xf0108f69
f0103266:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010326b:	68 79 04 00 00       	push   $0x479
f0103270:	68 45 8e 10 f0       	push   $0xf0108e45
f0103275:	e8 cf cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010327a:	68 7f 8f 10 f0       	push   $0xf0108f7f
f010327f:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0103284:	68 7a 04 00 00       	push   $0x47a
f0103289:	68 45 8e 10 f0       	push   $0xf0108e45
f010328e:	e8 b6 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0103293:	68 95 8f 10 f0       	push   $0xf0108f95
f0103298:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010329d:	68 7b 04 00 00       	push   $0x47b
f01032a2:	68 45 8e 10 f0       	push   $0xf0108e45
f01032a7:	e8 9d cd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01032ac:	50                   	push   %eax
f01032ad:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01032b2:	6a 58                	push   $0x58
f01032b4:	68 51 8e 10 f0       	push   $0xf0108e51
f01032b9:	e8 8b cd ff ff       	call   f0100049 <_panic>
f01032be:	50                   	push   %eax
f01032bf:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01032c4:	6a 58                	push   $0x58
f01032c6:	68 51 8e 10 f0       	push   $0xf0108e51
f01032cb:	e8 79 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01032d0:	68 66 90 10 f0       	push   $0xf0109066
f01032d5:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01032da:	68 80 04 00 00       	push   $0x480
f01032df:	68 45 8e 10 f0       	push   $0xf0108e45
f01032e4:	e8 60 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032e9:	68 20 8d 10 f0       	push   $0xf0108d20
f01032ee:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01032f3:	68 81 04 00 00       	push   $0x481
f01032f8:	68 45 8e 10 f0       	push   $0xf0108e45
f01032fd:	e8 47 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103302:	68 44 8d 10 f0       	push   $0xf0108d44
f0103307:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010330c:	68 83 04 00 00       	push   $0x483
f0103311:	68 45 8e 10 f0       	push   $0xf0108e45
f0103316:	e8 2e cd ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010331b:	68 88 90 10 f0       	push   $0xf0109088
f0103320:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0103325:	68 84 04 00 00       	push   $0x484
f010332a:	68 45 8e 10 f0       	push   $0xf0108e45
f010332f:	e8 15 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0103334:	68 f2 90 10 f0       	push   $0xf01090f2
f0103339:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010333e:	68 85 04 00 00       	push   $0x485
f0103343:	68 45 8e 10 f0       	push   $0xf0108e45
f0103348:	e8 fc cc ff ff       	call   f0100049 <_panic>
f010334d:	50                   	push   %eax
f010334e:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0103353:	6a 58                	push   $0x58
f0103355:	68 51 8e 10 f0       	push   $0xf0108e51
f010335a:	e8 ea cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010335f:	68 68 8d 10 f0       	push   $0xf0108d68
f0103364:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0103369:	68 87 04 00 00       	push   $0x487
f010336e:	68 45 8e 10 f0       	push   $0xf0108e45
f0103373:	e8 d1 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103378:	68 c0 90 10 f0       	push   $0xf01090c0
f010337d:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0103382:	68 89 04 00 00       	push   $0x489
f0103387:	68 45 8e 10 f0       	push   $0xf0108e45
f010338c:	e8 b8 cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103391:	68 c4 86 10 f0       	push   $0xf01086c4
f0103396:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010339b:	68 8c 04 00 00       	push   $0x48c
f01033a0:	68 45 8e 10 f0       	push   $0xf0108e45
f01033a5:	e8 9f cc ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f01033aa:	68 77 90 10 f0       	push   $0xf0109077
f01033af:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01033b4:	68 8e 04 00 00       	push   $0x48e
f01033b9:	68 45 8e 10 f0       	push   $0xf0108e45
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
f01033e5:	89 1d 3c f2 57 f0    	mov    %ebx,0xf057f23c
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
f0103431:	68 c0 8d 10 f0       	push   $0xf0108dc0
f0103436:	e8 95 0a 00 00       	call   f0103ed0 <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f010343b:	83 c4 0c             	add    $0xc,%esp
f010343e:	89 f8                	mov    %edi,%eax
f0103440:	23 06                	and    (%esi),%eax
f0103442:	50                   	push   %eax
f0103443:	57                   	push   %edi
f0103444:	68 e8 8d 10 f0       	push   $0xf0108de8
f0103449:	e8 82 0a 00 00       	call   f0103ed0 <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f010344e:	89 1d 3c f2 57 f0    	mov    %ebx,0xf057f23c
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
f0103497:	ff 35 3c f2 57 f0    	pushl  0xf057f23c
f010349d:	ff 73 48             	pushl  0x48(%ebx)
f01034a0:	68 10 8e 10 f0       	push   $0xf0108e10
f01034a5:	e8 26 0a 00 00       	call   f0103ed0 <cprintf>
		env_destroy(env);	// may not return
f01034aa:	89 1c 24             	mov    %ebx,(%esp)
f01034ad:	e8 b7 06 00 00       	call   f0103b69 <env_destroy>
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
f010350a:	68 b4 91 10 f0       	push   $0xf01091b4
f010350f:	68 2a 01 00 00       	push   $0x12a
f0103514:	68 c6 91 10 f0       	push   $0xf01091c6
f0103519:	e8 2b cb ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f010351e:	83 ec 04             	sub    $0x4,%esp
f0103521:	68 d1 91 10 f0       	push   $0xf01091d1
f0103526:	68 2d 01 00 00       	push   $0x12d
f010352b:	68 c6 91 10 f0       	push   $0xf01091c6
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
f010354a:	74 31                	je     f010357d <envid2env+0x40>
	e = &envs[ENVX(envid)];
f010354c:	89 f3                	mov    %esi,%ebx
f010354e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103554:	c1 e3 07             	shl    $0x7,%ebx
f0103557:	03 1d 44 f2 57 f0    	add    0xf057f244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010355d:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103561:	74 31                	je     f0103594 <envid2env+0x57>
f0103563:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103566:	75 2c                	jne    f0103594 <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103568:	84 c0                	test   %al,%al
f010356a:	75 61                	jne    f01035cd <envid2env+0x90>
	*env_store = e;
f010356c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010356f:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103571:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103576:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103579:	5b                   	pop    %ebx
f010357a:	5e                   	pop    %esi
f010357b:	5d                   	pop    %ebp
f010357c:	c3                   	ret    
		*env_store = curenv;
f010357d:	e8 68 36 00 00       	call   f0106bea <cpunum>
f0103582:	6b c0 74             	imul   $0x74,%eax,%eax
f0103585:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010358b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010358e:	89 02                	mov    %eax,(%edx)
		return 0;
f0103590:	89 f0                	mov    %esi,%eax
f0103592:	eb e2                	jmp    f0103576 <envid2env+0x39>
		*env_store = 0;
f0103594:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		if(e->env_status == ENV_FREE)
f010359d:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01035a1:	74 17                	je     f01035ba <envid2env+0x7d>
		cprintf("222222222222222222222\n");
f01035a3:	83 ec 0c             	sub    $0xc,%esp
f01035a6:	68 01 92 10 f0       	push   $0xf0109201
f01035ab:	e8 20 09 00 00       	call   f0103ed0 <cprintf>
		return -E_BAD_ENV;
f01035b0:	83 c4 10             	add    $0x10,%esp
f01035b3:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01035b8:	eb bc                	jmp    f0103576 <envid2env+0x39>
			cprintf("ssssssssssssssssss %d\n", envid);
f01035ba:	83 ec 08             	sub    $0x8,%esp
f01035bd:	56                   	push   %esi
f01035be:	68 ea 91 10 f0       	push   $0xf01091ea
f01035c3:	e8 08 09 00 00       	call   f0103ed0 <cprintf>
f01035c8:	83 c4 10             	add    $0x10,%esp
f01035cb:	eb d6                	jmp    f01035a3 <envid2env+0x66>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01035cd:	e8 18 36 00 00       	call   f0106bea <cpunum>
f01035d2:	6b c0 74             	imul   $0x74,%eax,%eax
f01035d5:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f01035db:	74 8f                	je     f010356c <envid2env+0x2f>
f01035dd:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01035e0:	e8 05 36 00 00       	call   f0106bea <cpunum>
f01035e5:	6b c0 74             	imul   $0x74,%eax,%eax
f01035e8:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01035ee:	3b 70 48             	cmp    0x48(%eax),%esi
f01035f1:	0f 84 75 ff ff ff    	je     f010356c <envid2env+0x2f>
		*env_store = 0;
f01035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		cprintf("33333333333333333333333\n");
f0103600:	83 ec 0c             	sub    $0xc,%esp
f0103603:	68 18 92 10 f0       	push   $0xf0109218
f0103608:	e8 c3 08 00 00       	call   f0103ed0 <cprintf>
		return -E_BAD_ENV;
f010360d:	83 c4 10             	add    $0x10,%esp
f0103610:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103615:	e9 5c ff ff ff       	jmp    f0103576 <envid2env+0x39>

f010361a <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f010361a:	b8 20 83 12 f0       	mov    $0xf0128320,%eax
f010361f:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103622:	b8 23 00 00 00       	mov    $0x23,%eax
f0103627:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103629:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f010362b:	b8 10 00 00 00       	mov    $0x10,%eax
f0103630:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103632:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103634:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103636:	ea 3d 36 10 f0 08 00 	ljmp   $0x8,$0xf010363d
	asm volatile("lldt %0" : : "r" (sel));
f010363d:	b8 00 00 00 00       	mov    $0x0,%eax
f0103642:	0f 00 d0             	lldt   %ax
}
f0103645:	c3                   	ret    

f0103646 <env_init>:
{
f0103646:	55                   	push   %ebp
f0103647:	89 e5                	mov    %esp,%ebp
f0103649:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f010364c:	8b 15 44 f2 57 f0    	mov    0xf057f244,%edx
f0103652:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
f0103658:	81 c2 00 00 02 00    	add    $0x20000,%edx
f010365e:	c7 40 c8 00 00 00 00 	movl   $0x0,-0x38(%eax)
		envs[i].env_link = &envs[i+1];
f0103665:	89 40 c4             	mov    %eax,-0x3c(%eax)
f0103668:	83 e8 80             	sub    $0xffffff80,%eax
	for(int i = 0; i < NENV - 1; i++){
f010366b:	39 d0                	cmp    %edx,%eax
f010366d:	75 ef                	jne    f010365e <env_init+0x18>
	env_free_list = envs;
f010366f:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
f0103674:	a3 48 f2 57 f0       	mov    %eax,0xf057f248
	env_init_percpu();
f0103679:	e8 9c ff ff ff       	call   f010361a <env_init_percpu>
}
f010367e:	c9                   	leave  
f010367f:	c3                   	ret    

f0103680 <env_alloc>:
{
f0103680:	55                   	push   %ebp
f0103681:	89 e5                	mov    %esp,%ebp
f0103683:	53                   	push   %ebx
f0103684:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103687:	8b 1d 48 f2 57 f0    	mov    0xf057f248,%ebx
f010368d:	85 db                	test   %ebx,%ebx
f010368f:	0f 84 75 01 00 00    	je     f010380a <env_alloc+0x18a>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103695:	83 ec 0c             	sub    $0xc,%esp
f0103698:	6a 01                	push   $0x1
f010369a:	e8 34 dc ff ff       	call   f01012d3 <page_alloc>
f010369f:	83 c4 10             	add    $0x10,%esp
f01036a2:	85 c0                	test   %eax,%eax
f01036a4:	0f 84 67 01 00 00    	je     f0103811 <env_alloc+0x191>
	p->pp_ref++;
f01036aa:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01036af:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01036b5:	c1 f8 03             	sar    $0x3,%eax
f01036b8:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01036bb:	89 c2                	mov    %eax,%edx
f01036bd:	c1 ea 0c             	shr    $0xc,%edx
f01036c0:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01036c6:	0f 83 17 01 00 00    	jae    f01037e3 <env_alloc+0x163>
	return (void *)(pa + KERNBASE);
f01036cc:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f01036d1:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy((void *)e->env_pgdir, (void *)kern_pgdir, PGSIZE);
f01036d4:	83 ec 04             	sub    $0x4,%esp
f01036d7:	68 00 10 00 00       	push   $0x1000
f01036dc:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01036e2:	50                   	push   %eax
f01036e3:	e8 a5 2f 00 00       	call   f010668d <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01036e8:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01036eb:	83 c4 10             	add    $0x10,%esp
f01036ee:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036f3:	0f 86 fc 00 00 00    	jbe    f01037f5 <env_alloc+0x175>
	return (physaddr_t)kva - KERNBASE;
f01036f9:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01036ff:	83 ca 05             	or     $0x5,%edx
f0103702:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103708:	8b 43 48             	mov    0x48(%ebx),%eax
f010370b:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103710:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103715:	ba 00 10 00 00       	mov    $0x1000,%edx
f010371a:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f010371d:	89 da                	mov    %ebx,%edx
f010371f:	2b 15 44 f2 57 f0    	sub    0xf057f244,%edx
f0103725:	c1 fa 07             	sar    $0x7,%edx
f0103728:	09 d0                	or     %edx,%eax
f010372a:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f010372d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103730:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103733:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f010373a:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103741:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f0103748:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f010374f:	83 ec 04             	sub    $0x4,%esp
f0103752:	6a 44                	push   $0x44
f0103754:	6a 00                	push   $0x0
f0103756:	53                   	push   %ebx
f0103757:	e8 87 2e 00 00       	call   f01065e3 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f010375c:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103762:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103768:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010376e:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103775:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f010377b:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103782:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103789:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f010378d:	8b 43 44             	mov    0x44(%ebx),%eax
f0103790:	a3 48 f2 57 f0       	mov    %eax,0xf057f248
	*newenv_store = e;
f0103795:	8b 45 08             	mov    0x8(%ebp),%eax
f0103798:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010379a:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010379d:	e8 48 34 00 00       	call   f0106bea <cpunum>
f01037a2:	6b c0 74             	imul   $0x74,%eax,%eax
f01037a5:	83 c4 10             	add    $0x10,%esp
f01037a8:	ba 00 00 00 00       	mov    $0x0,%edx
f01037ad:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f01037b4:	74 11                	je     f01037c7 <env_alloc+0x147>
f01037b6:	e8 2f 34 00 00       	call   f0106bea <cpunum>
f01037bb:	6b c0 74             	imul   $0x74,%eax,%eax
f01037be:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01037c4:	8b 50 48             	mov    0x48(%eax),%edx
f01037c7:	83 ec 04             	sub    $0x4,%esp
f01037ca:	53                   	push   %ebx
f01037cb:	52                   	push   %edx
f01037cc:	68 31 92 10 f0       	push   $0xf0109231
f01037d1:	e8 fa 06 00 00       	call   f0103ed0 <cprintf>
	return 0;
f01037d6:	83 c4 10             	add    $0x10,%esp
f01037d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01037de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01037e1:	c9                   	leave  
f01037e2:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01037e3:	50                   	push   %eax
f01037e4:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01037e9:	6a 58                	push   $0x58
f01037eb:	68 51 8e 10 f0       	push   $0xf0108e51
f01037f0:	e8 54 c8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037f5:	50                   	push   %eax
f01037f6:	68 d8 7c 10 f0       	push   $0xf0107cd8
f01037fb:	68 c6 00 00 00       	push   $0xc6
f0103800:	68 c6 91 10 f0       	push   $0xf01091c6
f0103805:	e8 3f c8 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f010380a:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f010380f:	eb cd                	jmp    f01037de <env_alloc+0x15e>
		return -E_NO_MEM;
f0103811:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103816:	eb c6                	jmp    f01037de <env_alloc+0x15e>

f0103818 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103818:	55                   	push   %ebp
f0103819:	89 e5                	mov    %esp,%ebp
f010381b:	57                   	push   %edi
f010381c:	56                   	push   %esi
f010381d:	53                   	push   %ebx
f010381e:	83 ec 34             	sub    $0x34,%esp
f0103821:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103824:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.
	cprintf("in %s\n", __FUNCTION__);
f0103827:	68 bc 92 10 f0       	push   $0xf01092bc
f010382c:	68 46 92 10 f0       	push   $0xf0109246
f0103831:	e8 9a 06 00 00       	call   f0103ed0 <cprintf>
	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	struct Env *e;
	int ret = env_alloc(&e, 0);
f0103836:	83 c4 08             	add    $0x8,%esp
f0103839:	6a 00                	push   $0x0
f010383b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010383e:	50                   	push   %eax
f010383f:	e8 3c fe ff ff       	call   f0103680 <env_alloc>
	if(ret)
f0103844:	83 c4 10             	add    $0x10,%esp
f0103847:	85 c0                	test   %eax,%eax
f0103849:	75 49                	jne    f0103894 <env_create+0x7c>
		panic("env_alloc failed\n");
	e->env_parent_id = 0;
f010384b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010384e:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
	e->env_type = type;
f0103855:	89 5e 50             	mov    %ebx,0x50(%esi)
	if(type == ENV_TYPE_FS){
f0103858:	83 fb 01             	cmp    $0x1,%ebx
f010385b:	74 4e                	je     f01038ab <env_create+0x93>
	if (elf->e_magic != ELF_MAGIC)
f010385d:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f0103863:	75 4f                	jne    f01038b4 <env_create+0x9c>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103865:	89 fb                	mov    %edi,%ebx
f0103867:	03 5f 1c             	add    0x1c(%edi),%ebx
	eph = ph + elf->e_phnum;
f010386a:	0f b7 47 2c          	movzwl 0x2c(%edi),%eax
f010386e:	c1 e0 05             	shl    $0x5,%eax
f0103871:	01 d8                	add    %ebx,%eax
f0103873:	89 45 d0             	mov    %eax,-0x30(%ebp)
	lcr3(PADDR(e->env_pgdir));
f0103876:	8b 46 60             	mov    0x60(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103879:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010387e:	76 4b                	jbe    f01038cb <env_create+0xb3>
	return (physaddr_t)kva - KERNBASE;
f0103880:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103885:	0f 22 d8             	mov    %eax,%cr3
	uint32_t elf_load_sz = 0;
f0103888:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010388f:	e9 89 00 00 00       	jmp    f010391d <env_create+0x105>
		panic("env_alloc failed\n");
f0103894:	83 ec 04             	sub    $0x4,%esp
f0103897:	68 4d 92 10 f0       	push   $0xf010924d
f010389c:	68 9d 01 00 00       	push   $0x19d
f01038a1:	68 c6 91 10 f0       	push   $0xf01091c6
f01038a6:	e8 9e c7 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f01038ab:	81 4e 38 00 30 00 00 	orl    $0x3000,0x38(%esi)
f01038b2:	eb a9                	jmp    f010385d <env_create+0x45>
		panic("is this a valid ELF");
f01038b4:	83 ec 04             	sub    $0x4,%esp
f01038b7:	68 5f 92 10 f0       	push   $0xf010925f
f01038bc:	68 74 01 00 00       	push   $0x174
f01038c1:	68 c6 91 10 f0       	push   $0xf01091c6
f01038c6:	e8 7e c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038cb:	50                   	push   %eax
f01038cc:	68 d8 7c 10 f0       	push   $0xf0107cd8
f01038d1:	68 79 01 00 00       	push   $0x179
f01038d6:	68 c6 91 10 f0       	push   $0xf01091c6
f01038db:	e8 69 c7 ff ff       	call   f0100049 <_panic>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f01038e0:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01038e3:	8b 53 08             	mov    0x8(%ebx),%edx
f01038e6:	89 f0                	mov    %esi,%eax
f01038e8:	e8 ca fb ff ff       	call   f01034b7 <region_alloc>
			memset((void *)ph->p_va, 0, ph->p_memsz);
f01038ed:	83 ec 04             	sub    $0x4,%esp
f01038f0:	ff 73 14             	pushl  0x14(%ebx)
f01038f3:	6a 00                	push   $0x0
f01038f5:	ff 73 08             	pushl  0x8(%ebx)
f01038f8:	e8 e6 2c 00 00       	call   f01065e3 <memset>
			memcpy((void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f01038fd:	83 c4 0c             	add    $0xc,%esp
f0103900:	ff 73 10             	pushl  0x10(%ebx)
f0103903:	89 f8                	mov    %edi,%eax
f0103905:	03 43 04             	add    0x4(%ebx),%eax
f0103908:	50                   	push   %eax
f0103909:	ff 73 08             	pushl  0x8(%ebx)
f010390c:	e8 7c 2d 00 00       	call   f010668d <memcpy>
			elf_load_sz += ph->p_memsz;
f0103911:	8b 53 14             	mov    0x14(%ebx),%edx
f0103914:	01 55 d4             	add    %edx,-0x2c(%ebp)
f0103917:	83 c4 10             	add    $0x10,%esp
	for (; ph < eph; ph++){
f010391a:	83 c3 20             	add    $0x20,%ebx
f010391d:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0103920:	76 07                	jbe    f0103929 <env_create+0x111>
		if(ph->p_type == ELF_PROG_LOAD){
f0103922:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103925:	75 f3                	jne    f010391a <env_create+0x102>
f0103927:	eb b7                	jmp    f01038e0 <env_create+0xc8>
	e->env_tf.tf_eip = elf->e_entry;
f0103929:	8b 47 18             	mov    0x18(%edi),%eax
f010392c:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f010392f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103932:	05 00 00 80 00       	add    $0x800000,%eax
f0103937:	89 46 7c             	mov    %eax,0x7c(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f010393a:	b9 00 10 00 00       	mov    $0x1000,%ecx
f010393f:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103944:	89 f0                	mov    %esi,%eax
f0103946:	e8 6c fb ff ff       	call   f01034b7 <region_alloc>
	lcr3(PADDR(kern_pgdir));
f010394b:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
	if ((uint32_t)kva < KERNBASE)
f0103950:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103955:	76 10                	jbe    f0103967 <env_create+0x14f>
	return (physaddr_t)kva - KERNBASE;
f0103957:	05 00 00 00 10       	add    $0x10000000,%eax
f010395c:	0f 22 d8             	mov    %eax,%cr3
	}
	load_icode(e, binary);
}
f010395f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103962:	5b                   	pop    %ebx
f0103963:	5e                   	pop    %esi
f0103964:	5f                   	pop    %edi
f0103965:	5d                   	pop    %ebp
f0103966:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103967:	50                   	push   %eax
f0103968:	68 d8 7c 10 f0       	push   $0xf0107cd8
f010396d:	68 89 01 00 00       	push   $0x189
f0103972:	68 c6 91 10 f0       	push   $0xf01091c6
f0103977:	e8 cd c6 ff ff       	call   f0100049 <_panic>

f010397c <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f010397c:	55                   	push   %ebp
f010397d:	89 e5                	mov    %esp,%ebp
f010397f:	57                   	push   %edi
f0103980:	56                   	push   %esi
f0103981:	53                   	push   %ebx
f0103982:	83 ec 1c             	sub    $0x1c,%esp
f0103985:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103988:	e8 5d 32 00 00       	call   f0106bea <cpunum>
f010398d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103990:	39 b8 28 10 58 f0    	cmp    %edi,-0xfa7efd8(%eax)
f0103996:	74 48                	je     f01039e0 <env_free+0x64>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103998:	8b 5f 48             	mov    0x48(%edi),%ebx
f010399b:	e8 4a 32 00 00       	call   f0106bea <cpunum>
f01039a0:	6b c0 74             	imul   $0x74,%eax,%eax
f01039a3:	ba 00 00 00 00       	mov    $0x0,%edx
f01039a8:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f01039af:	74 11                	je     f01039c2 <env_free+0x46>
f01039b1:	e8 34 32 00 00       	call   f0106bea <cpunum>
f01039b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01039b9:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01039bf:	8b 50 48             	mov    0x48(%eax),%edx
f01039c2:	83 ec 04             	sub    $0x4,%esp
f01039c5:	53                   	push   %ebx
f01039c6:	52                   	push   %edx
f01039c7:	68 73 92 10 f0       	push   $0xf0109273
f01039cc:	e8 ff 04 00 00       	call   f0103ed0 <cprintf>
f01039d1:	83 c4 10             	add    $0x10,%esp
f01039d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01039db:	e9 a9 00 00 00       	jmp    f0103a89 <env_free+0x10d>
		lcr3(PADDR(kern_pgdir));
f01039e0:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
	if ((uint32_t)kva < KERNBASE)
f01039e5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039ea:	76 0a                	jbe    f01039f6 <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f01039ec:	05 00 00 00 10       	add    $0x10000000,%eax
f01039f1:	0f 22 d8             	mov    %eax,%cr3
f01039f4:	eb a2                	jmp    f0103998 <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01039f6:	50                   	push   %eax
f01039f7:	68 d8 7c 10 f0       	push   $0xf0107cd8
f01039fc:	68 b4 01 00 00       	push   $0x1b4
f0103a01:	68 c6 91 10 f0       	push   $0xf01091c6
f0103a06:	e8 3e c6 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103a0b:	56                   	push   %esi
f0103a0c:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0103a11:	68 c3 01 00 00       	push   $0x1c3
f0103a16:	68 c6 91 10 f0       	push   $0xf01091c6
f0103a1b:	e8 29 c6 ff ff       	call   f0100049 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103a20:	83 ec 08             	sub    $0x8,%esp
f0103a23:	89 d8                	mov    %ebx,%eax
f0103a25:	c1 e0 0c             	shl    $0xc,%eax
f0103a28:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103a2b:	50                   	push   %eax
f0103a2c:	ff 77 60             	pushl  0x60(%edi)
f0103a2f:	e8 95 db ff ff       	call   f01015c9 <page_remove>
f0103a34:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103a37:	83 c3 01             	add    $0x1,%ebx
f0103a3a:	83 c6 04             	add    $0x4,%esi
f0103a3d:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103a43:	74 07                	je     f0103a4c <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f0103a45:	f6 06 01             	testb  $0x1,(%esi)
f0103a48:	74 ed                	je     f0103a37 <env_free+0xbb>
f0103a4a:	eb d4                	jmp    f0103a20 <env_free+0xa4>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103a4c:	8b 47 60             	mov    0x60(%edi),%eax
f0103a4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a52:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103a59:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103a5c:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f0103a62:	73 69                	jae    f0103acd <env_free+0x151>
		page_decref(pa2page(pa));
f0103a64:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103a67:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
f0103a6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103a6f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103a72:	50                   	push   %eax
f0103a73:	e8 08 d9 ff ff       	call   f0101380 <page_decref>
f0103a78:	83 c4 10             	add    $0x10,%esp
f0103a7b:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103a82:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103a87:	74 58                	je     f0103ae1 <env_free+0x165>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103a89:	8b 47 60             	mov    0x60(%edi),%eax
f0103a8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a8f:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103a92:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103a98:	74 e1                	je     f0103a7b <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103a9a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103aa0:	89 f0                	mov    %esi,%eax
f0103aa2:	c1 e8 0c             	shr    $0xc,%eax
f0103aa5:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103aa8:	39 05 a8 0e 58 f0    	cmp    %eax,0xf0580ea8
f0103aae:	0f 86 57 ff ff ff    	jbe    f0103a0b <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0103ab4:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103abd:	c1 e0 14             	shl    $0x14,%eax
f0103ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103ac3:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103ac8:	e9 78 ff ff ff       	jmp    f0103a45 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f0103acd:	83 ec 04             	sub    $0x4,%esp
f0103ad0:	68 90 85 10 f0       	push   $0xf0108590
f0103ad5:	6a 51                	push   $0x51
f0103ad7:	68 51 8e 10 f0       	push   $0xf0108e51
f0103adc:	e8 68 c5 ff ff       	call   f0100049 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103ae1:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103ae4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ae9:	76 55                	jbe    f0103b40 <env_free+0x1c4>
	e->env_pgdir = 0;
f0103aeb:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103af2:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103af7:	c1 e8 0c             	shr    $0xc,%eax
f0103afa:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f0103b00:	73 53                	jae    f0103b55 <env_free+0x1d9>
	page_decref(pa2page(pa));
f0103b02:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103b05:	8b 15 b0 0e 58 f0    	mov    0xf0580eb0,%edx
f0103b0b:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103b0e:	50                   	push   %eax
f0103b0f:	e8 6c d8 ff ff       	call   f0101380 <page_decref>
	cprintf("in env_free we set the ENV_FREE\n");
f0103b14:	c7 04 24 98 92 10 f0 	movl   $0xf0109298,(%esp)
f0103b1b:	e8 b0 03 00 00       	call   f0103ed0 <cprintf>
	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103b20:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103b27:	a1 48 f2 57 f0       	mov    0xf057f248,%eax
f0103b2c:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103b2f:	89 3d 48 f2 57 f0    	mov    %edi,0xf057f248
}
f0103b35:	83 c4 10             	add    $0x10,%esp
f0103b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103b3b:	5b                   	pop    %ebx
f0103b3c:	5e                   	pop    %esi
f0103b3d:	5f                   	pop    %edi
f0103b3e:	5d                   	pop    %ebp
f0103b3f:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103b40:	50                   	push   %eax
f0103b41:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0103b46:	68 d1 01 00 00       	push   $0x1d1
f0103b4b:	68 c6 91 10 f0       	push   $0xf01091c6
f0103b50:	e8 f4 c4 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0103b55:	83 ec 04             	sub    $0x4,%esp
f0103b58:	68 90 85 10 f0       	push   $0xf0108590
f0103b5d:	6a 51                	push   $0x51
f0103b5f:	68 51 8e 10 f0       	push   $0xf0108e51
f0103b64:	e8 e0 c4 ff ff       	call   f0100049 <_panic>

f0103b69 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103b69:	55                   	push   %ebp
f0103b6a:	89 e5                	mov    %esp,%ebp
f0103b6c:	53                   	push   %ebx
f0103b6d:	83 ec 04             	sub    $0x4,%esp
f0103b70:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b73:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103b77:	74 21                	je     f0103b9a <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103b79:	83 ec 0c             	sub    $0xc,%esp
f0103b7c:	53                   	push   %ebx
f0103b7d:	e8 fa fd ff ff       	call   f010397c <env_free>

	if (curenv == e) {
f0103b82:	e8 63 30 00 00       	call   f0106bea <cpunum>
f0103b87:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b8a:	83 c4 10             	add    $0x10,%esp
f0103b8d:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f0103b93:	74 1e                	je     f0103bb3 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b98:	c9                   	leave  
f0103b99:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b9a:	e8 4b 30 00 00       	call   f0106bea <cpunum>
f0103b9f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ba2:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f0103ba8:	74 cf                	je     f0103b79 <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103baa:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103bb1:	eb e2                	jmp    f0103b95 <env_destroy+0x2c>
		curenv = NULL;
f0103bb3:	e8 32 30 00 00       	call   f0106bea <cpunum>
f0103bb8:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bbb:	c7 80 28 10 58 f0 00 	movl   $0x0,-0xfa7efd8(%eax)
f0103bc2:	00 00 00 
		sched_yield();
f0103bc5:	e8 b4 12 00 00       	call   f0104e7e <sched_yield>

f0103bca <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103bca:	55                   	push   %ebp
f0103bcb:	89 e5                	mov    %esp,%ebp
f0103bcd:	53                   	push   %ebx
f0103bce:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103bd1:	e8 14 30 00 00       	call   f0106bea <cpunum>
f0103bd6:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bd9:	8b 98 28 10 58 f0    	mov    -0xfa7efd8(%eax),%ebx
f0103bdf:	e8 06 30 00 00       	call   f0106bea <cpunum>
f0103be4:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f0103be7:	8b 65 08             	mov    0x8(%ebp),%esp
f0103bea:	61                   	popa   
f0103beb:	07                   	pop    %es
f0103bec:	1f                   	pop    %ds
f0103bed:	83 c4 08             	add    $0x8,%esp
f0103bf0:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103bf1:	83 ec 04             	sub    $0x4,%esp
f0103bf4:	68 89 92 10 f0       	push   $0xf0109289
f0103bf9:	68 08 02 00 00       	push   $0x208
f0103bfe:	68 c6 91 10 f0       	push   $0xf01091c6
f0103c03:	e8 41 c4 ff ff       	call   f0100049 <_panic>

f0103c08 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103c08:	55                   	push   %ebp
f0103c09:	89 e5                	mov    %esp,%ebp
f0103c0b:	53                   	push   %ebx
f0103c0c:	83 ec 04             	sub    $0x4,%esp
f0103c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f0103c12:	e8 d3 2f 00 00       	call   f0106bea <cpunum>
f0103c17:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c1a:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f0103c20:	74 7e                	je     f0103ca0 <env_run+0x98>
		if(curenv && curenv->env_status == ENV_RUNNING)
f0103c22:	e8 c3 2f 00 00       	call   f0106bea <cpunum>
f0103c27:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c2a:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f0103c31:	74 18                	je     f0103c4b <env_run+0x43>
f0103c33:	e8 b2 2f 00 00       	call   f0106bea <cpunum>
f0103c38:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c3b:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c41:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103c45:	0f 84 9a 00 00 00    	je     f0103ce5 <env_run+0xdd>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f0103c4b:	e8 9a 2f 00 00       	call   f0106bea <cpunum>
f0103c50:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c53:	89 98 28 10 58 f0    	mov    %ebx,-0xfa7efd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0103c59:	e8 8c 2f 00 00       	call   f0106bea <cpunum>
f0103c5e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c61:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c67:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0103c6e:	e8 77 2f 00 00       	call   f0106bea <cpunum>
f0103c73:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c76:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c7c:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f0103c80:	e8 65 2f 00 00       	call   f0106bea <cpunum>
f0103c85:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c88:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c8e:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103c91:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c96:	76 67                	jbe    f0103cff <env_run+0xf7>
	return (physaddr_t)kva - KERNBASE;
f0103c98:	05 00 00 00 10       	add    $0x10000000,%eax
f0103c9d:	0f 22 d8             	mov    %eax,%cr3
	}
	lcr3(PADDR(curenv->env_pgdir));
f0103ca0:	e8 45 2f 00 00       	call   f0106bea <cpunum>
f0103ca5:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ca8:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103cae:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103cb1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103cb6:	76 5c                	jbe    f0103d14 <env_run+0x10c>
	return (physaddr_t)kva - KERNBASE;
f0103cb8:	05 00 00 00 10       	add    $0x10000000,%eax
f0103cbd:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103cc0:	83 ec 0c             	sub    $0xc,%esp
f0103cc3:	68 c0 83 12 f0       	push   $0xf01283c0
f0103cc8:	e8 29 32 00 00       	call   f0106ef6 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103ccd:	f3 90                	pause  
	unlock_kernel(); //lab4 bug?
	env_pop_tf(&curenv->env_tf);
f0103ccf:	e8 16 2f 00 00       	call   f0106bea <cpunum>
f0103cd4:	83 c4 04             	add    $0x4,%esp
f0103cd7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cda:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0103ce0:	e8 e5 fe ff ff       	call   f0103bca <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0103ce5:	e8 00 2f 00 00       	call   f0106bea <cpunum>
f0103cea:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ced:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103cf3:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103cfa:	e9 4c ff ff ff       	jmp    f0103c4b <env_run+0x43>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103cff:	50                   	push   %eax
f0103d00:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0103d05:	68 2c 02 00 00       	push   $0x22c
f0103d0a:	68 c6 91 10 f0       	push   $0xf01091c6
f0103d0f:	e8 35 c3 ff ff       	call   f0100049 <_panic>
f0103d14:	50                   	push   %eax
f0103d15:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0103d1a:	68 2e 02 00 00       	push   $0x22e
f0103d1f:	68 c6 91 10 f0       	push   $0xf01091c6
f0103d24:	e8 20 c3 ff ff       	call   f0100049 <_panic>

f0103d29 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103d29:	55                   	push   %ebp
f0103d2a:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103d2c:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d2f:	ba 70 00 00 00       	mov    $0x70,%edx
f0103d34:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103d35:	ba 71 00 00 00       	mov    $0x71,%edx
f0103d3a:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103d3b:	0f b6 c0             	movzbl %al,%eax
}
f0103d3e:	5d                   	pop    %ebp
f0103d3f:	c3                   	ret    

f0103d40 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103d40:	55                   	push   %ebp
f0103d41:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103d43:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d46:	ba 70 00 00 00       	mov    $0x70,%edx
f0103d4b:	ee                   	out    %al,(%dx)
f0103d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d4f:	ba 71 00 00 00       	mov    $0x71,%edx
f0103d54:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103d55:	5d                   	pop    %ebp
f0103d56:	c3                   	ret    

f0103d57 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103d57:	55                   	push   %ebp
f0103d58:	89 e5                	mov    %esp,%ebp
f0103d5a:	56                   	push   %esi
f0103d5b:	53                   	push   %ebx
f0103d5c:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103d5f:	66 a3 a8 83 12 f0    	mov    %ax,0xf01283a8
	if (!didinit)
f0103d65:	80 3d 4c f2 57 f0 00 	cmpb   $0x0,0xf057f24c
f0103d6c:	75 07                	jne    f0103d75 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103d71:	5b                   	pop    %ebx
f0103d72:	5e                   	pop    %esi
f0103d73:	5d                   	pop    %ebp
f0103d74:	c3                   	ret    
f0103d75:	89 c6                	mov    %eax,%esi
f0103d77:	ba 21 00 00 00       	mov    $0x21,%edx
f0103d7c:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103d7d:	66 c1 e8 08          	shr    $0x8,%ax
f0103d81:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103d86:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103d87:	83 ec 0c             	sub    $0xc,%esp
f0103d8a:	68 c7 92 10 f0       	push   $0xf01092c7
f0103d8f:	e8 3c 01 00 00       	call   f0103ed0 <cprintf>
f0103d94:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103d97:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103d9c:	0f b7 f6             	movzwl %si,%esi
f0103d9f:	f7 d6                	not    %esi
f0103da1:	eb 19                	jmp    f0103dbc <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f0103da3:	83 ec 08             	sub    $0x8,%esp
f0103da6:	53                   	push   %ebx
f0103da7:	68 0f 9a 10 f0       	push   $0xf0109a0f
f0103dac:	e8 1f 01 00 00       	call   f0103ed0 <cprintf>
f0103db1:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103db4:	83 c3 01             	add    $0x1,%ebx
f0103db7:	83 fb 10             	cmp    $0x10,%ebx
f0103dba:	74 07                	je     f0103dc3 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103dbc:	0f a3 de             	bt     %ebx,%esi
f0103dbf:	73 f3                	jae    f0103db4 <irq_setmask_8259A+0x5d>
f0103dc1:	eb e0                	jmp    f0103da3 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103dc3:	83 ec 0c             	sub    $0xc,%esp
f0103dc6:	68 5b 91 10 f0       	push   $0xf010915b
f0103dcb:	e8 00 01 00 00       	call   f0103ed0 <cprintf>
f0103dd0:	83 c4 10             	add    $0x10,%esp
f0103dd3:	eb 99                	jmp    f0103d6e <irq_setmask_8259A+0x17>

f0103dd5 <pic_init>:
{
f0103dd5:	55                   	push   %ebp
f0103dd6:	89 e5                	mov    %esp,%ebp
f0103dd8:	57                   	push   %edi
f0103dd9:	56                   	push   %esi
f0103dda:	53                   	push   %ebx
f0103ddb:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103dde:	c6 05 4c f2 57 f0 01 	movb   $0x1,0xf057f24c
f0103de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103dea:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103def:	89 da                	mov    %ebx,%edx
f0103df1:	ee                   	out    %al,(%dx)
f0103df2:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103df7:	89 ca                	mov    %ecx,%edx
f0103df9:	ee                   	out    %al,(%dx)
f0103dfa:	bf 11 00 00 00       	mov    $0x11,%edi
f0103dff:	be 20 00 00 00       	mov    $0x20,%esi
f0103e04:	89 f8                	mov    %edi,%eax
f0103e06:	89 f2                	mov    %esi,%edx
f0103e08:	ee                   	out    %al,(%dx)
f0103e09:	b8 20 00 00 00       	mov    $0x20,%eax
f0103e0e:	89 da                	mov    %ebx,%edx
f0103e10:	ee                   	out    %al,(%dx)
f0103e11:	b8 04 00 00 00       	mov    $0x4,%eax
f0103e16:	ee                   	out    %al,(%dx)
f0103e17:	b8 03 00 00 00       	mov    $0x3,%eax
f0103e1c:	ee                   	out    %al,(%dx)
f0103e1d:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103e22:	89 f8                	mov    %edi,%eax
f0103e24:	89 da                	mov    %ebx,%edx
f0103e26:	ee                   	out    %al,(%dx)
f0103e27:	b8 28 00 00 00       	mov    $0x28,%eax
f0103e2c:	89 ca                	mov    %ecx,%edx
f0103e2e:	ee                   	out    %al,(%dx)
f0103e2f:	b8 02 00 00 00       	mov    $0x2,%eax
f0103e34:	ee                   	out    %al,(%dx)
f0103e35:	b8 01 00 00 00       	mov    $0x1,%eax
f0103e3a:	ee                   	out    %al,(%dx)
f0103e3b:	bf 68 00 00 00       	mov    $0x68,%edi
f0103e40:	89 f8                	mov    %edi,%eax
f0103e42:	89 f2                	mov    %esi,%edx
f0103e44:	ee                   	out    %al,(%dx)
f0103e45:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103e4a:	89 c8                	mov    %ecx,%eax
f0103e4c:	ee                   	out    %al,(%dx)
f0103e4d:	89 f8                	mov    %edi,%eax
f0103e4f:	89 da                	mov    %ebx,%edx
f0103e51:	ee                   	out    %al,(%dx)
f0103e52:	89 c8                	mov    %ecx,%eax
f0103e54:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103e55:	0f b7 05 a8 83 12 f0 	movzwl 0xf01283a8,%eax
f0103e5c:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103e60:	75 08                	jne    f0103e6a <pic_init+0x95>
}
f0103e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103e65:	5b                   	pop    %ebx
f0103e66:	5e                   	pop    %esi
f0103e67:	5f                   	pop    %edi
f0103e68:	5d                   	pop    %ebp
f0103e69:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103e6a:	83 ec 0c             	sub    $0xc,%esp
f0103e6d:	0f b7 c0             	movzwl %ax,%eax
f0103e70:	50                   	push   %eax
f0103e71:	e8 e1 fe ff ff       	call   f0103d57 <irq_setmask_8259A>
f0103e76:	83 c4 10             	add    $0x10,%esp
}
f0103e79:	eb e7                	jmp    f0103e62 <pic_init+0x8d>

f0103e7b <irq_eoi>:
f0103e7b:	b8 20 00 00 00       	mov    $0x20,%eax
f0103e80:	ba 20 00 00 00       	mov    $0x20,%edx
f0103e85:	ee                   	out    %al,(%dx)
f0103e86:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103e8b:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103e8c:	c3                   	ret    

f0103e8d <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103e8d:	55                   	push   %ebp
f0103e8e:	89 e5                	mov    %esp,%ebp
f0103e90:	53                   	push   %ebx
f0103e91:	83 ec 10             	sub    $0x10,%esp
f0103e94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0103e97:	ff 75 08             	pushl  0x8(%ebp)
f0103e9a:	e8 29 c9 ff ff       	call   f01007c8 <cputchar>
	(*cnt)++;
f0103e9f:	83 03 01             	addl   $0x1,(%ebx)
}
f0103ea2:	83 c4 10             	add    $0x10,%esp
f0103ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103ea8:	c9                   	leave  
f0103ea9:	c3                   	ret    

f0103eaa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103eaa:	55                   	push   %ebp
f0103eab:	89 e5                	mov    %esp,%ebp
f0103ead:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103eb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103eb7:	ff 75 0c             	pushl  0xc(%ebp)
f0103eba:	ff 75 08             	pushl  0x8(%ebp)
f0103ebd:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103ec0:	50                   	push   %eax
f0103ec1:	68 8d 3e 10 f0       	push   $0xf0103e8d
f0103ec6:	e8 b2 1e 00 00       	call   f0105d7d <vprintfmt>
	return cnt;
}
f0103ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103ece:	c9                   	leave  
f0103ecf:	c3                   	ret    

f0103ed0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103ed0:	55                   	push   %ebp
f0103ed1:	89 e5                	mov    %esp,%ebp
f0103ed3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103ed6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103ed9:	50                   	push   %eax
f0103eda:	ff 75 08             	pushl  0x8(%ebp)
f0103edd:	e8 c8 ff ff ff       	call   f0103eaa <vcprintf>
	va_end(ap);
	return cnt;
}
f0103ee2:	c9                   	leave  
f0103ee3:	c3                   	ret    

f0103ee4 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103ee4:	55                   	push   %ebp
f0103ee5:	89 e5                	mov    %esp,%ebp
f0103ee7:	57                   	push   %edi
f0103ee8:	56                   	push   %esi
f0103ee9:	53                   	push   %ebx
f0103eea:	83 ec 1c             	sub    $0x1c,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int i = cpunum();
f0103eed:	e8 f8 2c 00 00       	call   f0106bea <cpunum>
f0103ef2:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0103ef4:	e8 f1 2c 00 00       	call   f0106bea <cpunum>
f0103ef9:	6b c0 74             	imul   $0x74,%eax,%eax
f0103efc:	89 d9                	mov    %ebx,%ecx
f0103efe:	c1 e1 10             	shl    $0x10,%ecx
f0103f01:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103f06:	29 ca                	sub    %ecx,%edx
f0103f08:	89 90 30 10 58 f0    	mov    %edx,-0xfa7efd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f0103f0e:	e8 d7 2c 00 00       	call   f0106bea <cpunum>
f0103f13:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f16:	66 c7 80 34 10 58 f0 	movw   $0x10,-0xfa7efcc(%eax)
f0103f1d:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f0103f1f:	e8 c6 2c 00 00       	call   f0106bea <cpunum>
f0103f24:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f27:	66 c7 80 92 10 58 f0 	movw   $0x68,-0xfa7ef6e(%eax)
f0103f2e:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0103f30:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103f37:	89 fb                	mov    %edi,%ebx
f0103f39:	c1 fb 03             	sar    $0x3,%ebx
f0103f3c:	e8 a9 2c 00 00       	call   f0106bea <cpunum>
f0103f41:	89 c6                	mov    %eax,%esi
f0103f43:	e8 a2 2c 00 00       	call   f0106bea <cpunum>
f0103f48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103f4b:	e8 9a 2c 00 00       	call   f0106bea <cpunum>
f0103f50:	66 c7 04 dd 40 83 12 	movw   $0x67,-0xfed7cc0(,%ebx,8)
f0103f57:	f0 67 00 
f0103f5a:	6b f6 74             	imul   $0x74,%esi,%esi
f0103f5d:	81 c6 2c 10 58 f0    	add    $0xf058102c,%esi
f0103f63:	66 89 34 dd 42 83 12 	mov    %si,-0xfed7cbe(,%ebx,8)
f0103f6a:	f0 
f0103f6b:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103f6f:	81 c2 2c 10 58 f0    	add    $0xf058102c,%edx
f0103f75:	c1 ea 10             	shr    $0x10,%edx
f0103f78:	88 14 dd 44 83 12 f0 	mov    %dl,-0xfed7cbc(,%ebx,8)
f0103f7f:	c6 04 dd 46 83 12 f0 	movb   $0x40,-0xfed7cba(,%ebx,8)
f0103f86:	40 
f0103f87:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f8a:	05 2c 10 58 f0       	add    $0xf058102c,%eax
f0103f8f:	c1 e8 18             	shr    $0x18,%eax
f0103f92:	88 04 dd 47 83 12 f0 	mov    %al,-0xfed7cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f0103f99:	c6 04 dd 45 83 12 f0 	movb   $0x89,-0xfed7cbb(,%ebx,8)
f0103fa0:	89 
	asm volatile("ltr %0" : : "r" (sel));
f0103fa1:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f0103fa4:	b8 ac 83 12 f0       	mov    $0xf01283ac,%eax
f0103fa9:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f0103fac:	83 c4 1c             	add    $0x1c,%esp
f0103faf:	5b                   	pop    %ebx
f0103fb0:	5e                   	pop    %esi
f0103fb1:	5f                   	pop    %edi
f0103fb2:	5d                   	pop    %ebp
f0103fb3:	c3                   	ret    

f0103fb4 <trap_init>:
{
f0103fb4:	55                   	push   %ebp
f0103fb5:	89 e5                	mov    %esp,%ebp
f0103fb7:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f0103fba:	b8 86 4c 10 f0       	mov    $0xf0104c86,%eax
f0103fbf:	66 a3 60 f2 57 f0    	mov    %ax,0xf057f260
f0103fc5:	66 c7 05 62 f2 57 f0 	movw   $0x8,0xf057f262
f0103fcc:	08 00 
f0103fce:	c6 05 64 f2 57 f0 00 	movb   $0x0,0xf057f264
f0103fd5:	c6 05 65 f2 57 f0 8e 	movb   $0x8e,0xf057f265
f0103fdc:	c1 e8 10             	shr    $0x10,%eax
f0103fdf:	66 a3 66 f2 57 f0    	mov    %ax,0xf057f266
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f0103fe5:	b8 90 4c 10 f0       	mov    $0xf0104c90,%eax
f0103fea:	66 a3 68 f2 57 f0    	mov    %ax,0xf057f268
f0103ff0:	66 c7 05 6a f2 57 f0 	movw   $0x8,0xf057f26a
f0103ff7:	08 00 
f0103ff9:	c6 05 6c f2 57 f0 00 	movb   $0x0,0xf057f26c
f0104000:	c6 05 6d f2 57 f0 8e 	movb   $0x8e,0xf057f26d
f0104007:	c1 e8 10             	shr    $0x10,%eax
f010400a:	66 a3 6e f2 57 f0    	mov    %ax,0xf057f26e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0104010:	b8 9a 4c 10 f0       	mov    $0xf0104c9a,%eax
f0104015:	66 a3 70 f2 57 f0    	mov    %ax,0xf057f270
f010401b:	66 c7 05 72 f2 57 f0 	movw   $0x8,0xf057f272
f0104022:	08 00 
f0104024:	c6 05 74 f2 57 f0 00 	movb   $0x0,0xf057f274
f010402b:	c6 05 75 f2 57 f0 8e 	movb   $0x8e,0xf057f275
f0104032:	c1 e8 10             	shr    $0x10,%eax
f0104035:	66 a3 76 f2 57 f0    	mov    %ax,0xf057f276
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f010403b:	b8 a4 4c 10 f0       	mov    $0xf0104ca4,%eax
f0104040:	66 a3 78 f2 57 f0    	mov    %ax,0xf057f278
f0104046:	66 c7 05 7a f2 57 f0 	movw   $0x8,0xf057f27a
f010404d:	08 00 
f010404f:	c6 05 7c f2 57 f0 00 	movb   $0x0,0xf057f27c
f0104056:	c6 05 7d f2 57 f0 ee 	movb   $0xee,0xf057f27d
f010405d:	c1 e8 10             	shr    $0x10,%eax
f0104060:	66 a3 7e f2 57 f0    	mov    %ax,0xf057f27e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f0104066:	b8 ae 4c 10 f0       	mov    $0xf0104cae,%eax
f010406b:	66 a3 80 f2 57 f0    	mov    %ax,0xf057f280
f0104071:	66 c7 05 82 f2 57 f0 	movw   $0x8,0xf057f282
f0104078:	08 00 
f010407a:	c6 05 84 f2 57 f0 00 	movb   $0x0,0xf057f284
f0104081:	c6 05 85 f2 57 f0 ee 	movb   $0xee,0xf057f285
f0104088:	c1 e8 10             	shr    $0x10,%eax
f010408b:	66 a3 86 f2 57 f0    	mov    %ax,0xf057f286
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f0104091:	b8 b8 4c 10 f0       	mov    $0xf0104cb8,%eax
f0104096:	66 a3 88 f2 57 f0    	mov    %ax,0xf057f288
f010409c:	66 c7 05 8a f2 57 f0 	movw   $0x8,0xf057f28a
f01040a3:	08 00 
f01040a5:	c6 05 8c f2 57 f0 00 	movb   $0x0,0xf057f28c
f01040ac:	c6 05 8d f2 57 f0 ee 	movb   $0xee,0xf057f28d
f01040b3:	c1 e8 10             	shr    $0x10,%eax
f01040b6:	66 a3 8e f2 57 f0    	mov    %ax,0xf057f28e
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f01040bc:	b8 c2 4c 10 f0       	mov    $0xf0104cc2,%eax
f01040c1:	66 a3 90 f2 57 f0    	mov    %ax,0xf057f290
f01040c7:	66 c7 05 92 f2 57 f0 	movw   $0x8,0xf057f292
f01040ce:	08 00 
f01040d0:	c6 05 94 f2 57 f0 00 	movb   $0x0,0xf057f294
f01040d7:	c6 05 95 f2 57 f0 8e 	movb   $0x8e,0xf057f295
f01040de:	c1 e8 10             	shr    $0x10,%eax
f01040e1:	66 a3 96 f2 57 f0    	mov    %ax,0xf057f296
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f01040e7:	b8 cc 4c 10 f0       	mov    $0xf0104ccc,%eax
f01040ec:	66 a3 98 f2 57 f0    	mov    %ax,0xf057f298
f01040f2:	66 c7 05 9a f2 57 f0 	movw   $0x8,0xf057f29a
f01040f9:	08 00 
f01040fb:	c6 05 9c f2 57 f0 00 	movb   $0x0,0xf057f29c
f0104102:	c6 05 9d f2 57 f0 8e 	movb   $0x8e,0xf057f29d
f0104109:	c1 e8 10             	shr    $0x10,%eax
f010410c:	66 a3 9e f2 57 f0    	mov    %ax,0xf057f29e
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f0104112:	b8 d6 4c 10 f0       	mov    $0xf0104cd6,%eax
f0104117:	66 a3 a0 f2 57 f0    	mov    %ax,0xf057f2a0
f010411d:	66 c7 05 a2 f2 57 f0 	movw   $0x8,0xf057f2a2
f0104124:	08 00 
f0104126:	c6 05 a4 f2 57 f0 00 	movb   $0x0,0xf057f2a4
f010412d:	c6 05 a5 f2 57 f0 8e 	movb   $0x8e,0xf057f2a5
f0104134:	c1 e8 10             	shr    $0x10,%eax
f0104137:	66 a3 a6 f2 57 f0    	mov    %ax,0xf057f2a6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f010413d:	b8 de 4c 10 f0       	mov    $0xf0104cde,%eax
f0104142:	66 a3 b0 f2 57 f0    	mov    %ax,0xf057f2b0
f0104148:	66 c7 05 b2 f2 57 f0 	movw   $0x8,0xf057f2b2
f010414f:	08 00 
f0104151:	c6 05 b4 f2 57 f0 00 	movb   $0x0,0xf057f2b4
f0104158:	c6 05 b5 f2 57 f0 8e 	movb   $0x8e,0xf057f2b5
f010415f:	c1 e8 10             	shr    $0x10,%eax
f0104162:	66 a3 b6 f2 57 f0    	mov    %ax,0xf057f2b6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f0104168:	b8 e6 4c 10 f0       	mov    $0xf0104ce6,%eax
f010416d:	66 a3 b8 f2 57 f0    	mov    %ax,0xf057f2b8
f0104173:	66 c7 05 ba f2 57 f0 	movw   $0x8,0xf057f2ba
f010417a:	08 00 
f010417c:	c6 05 bc f2 57 f0 00 	movb   $0x0,0xf057f2bc
f0104183:	c6 05 bd f2 57 f0 8e 	movb   $0x8e,0xf057f2bd
f010418a:	c1 e8 10             	shr    $0x10,%eax
f010418d:	66 a3 be f2 57 f0    	mov    %ax,0xf057f2be
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f0104193:	b8 ee 4c 10 f0       	mov    $0xf0104cee,%eax
f0104198:	66 a3 c0 f2 57 f0    	mov    %ax,0xf057f2c0
f010419e:	66 c7 05 c2 f2 57 f0 	movw   $0x8,0xf057f2c2
f01041a5:	08 00 
f01041a7:	c6 05 c4 f2 57 f0 00 	movb   $0x0,0xf057f2c4
f01041ae:	c6 05 c5 f2 57 f0 8e 	movb   $0x8e,0xf057f2c5
f01041b5:	c1 e8 10             	shr    $0x10,%eax
f01041b8:	66 a3 c6 f2 57 f0    	mov    %ax,0xf057f2c6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f01041be:	b8 f6 4c 10 f0       	mov    $0xf0104cf6,%eax
f01041c3:	66 a3 c8 f2 57 f0    	mov    %ax,0xf057f2c8
f01041c9:	66 c7 05 ca f2 57 f0 	movw   $0x8,0xf057f2ca
f01041d0:	08 00 
f01041d2:	c6 05 cc f2 57 f0 00 	movb   $0x0,0xf057f2cc
f01041d9:	c6 05 cd f2 57 f0 8e 	movb   $0x8e,0xf057f2cd
f01041e0:	c1 e8 10             	shr    $0x10,%eax
f01041e3:	66 a3 ce f2 57 f0    	mov    %ax,0xf057f2ce
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f01041e9:	b8 fe 4c 10 f0       	mov    $0xf0104cfe,%eax
f01041ee:	66 a3 d0 f2 57 f0    	mov    %ax,0xf057f2d0
f01041f4:	66 c7 05 d2 f2 57 f0 	movw   $0x8,0xf057f2d2
f01041fb:	08 00 
f01041fd:	c6 05 d4 f2 57 f0 00 	movb   $0x0,0xf057f2d4
f0104204:	c6 05 d5 f2 57 f0 8e 	movb   $0x8e,0xf057f2d5
f010420b:	c1 e8 10             	shr    $0x10,%eax
f010420e:	66 a3 d6 f2 57 f0    	mov    %ax,0xf057f2d6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f0104214:	b8 06 4d 10 f0       	mov    $0xf0104d06,%eax
f0104219:	66 a3 e0 f2 57 f0    	mov    %ax,0xf057f2e0
f010421f:	66 c7 05 e2 f2 57 f0 	movw   $0x8,0xf057f2e2
f0104226:	08 00 
f0104228:	c6 05 e4 f2 57 f0 00 	movb   $0x0,0xf057f2e4
f010422f:	c6 05 e5 f2 57 f0 8e 	movb   $0x8e,0xf057f2e5
f0104236:	c1 e8 10             	shr    $0x10,%eax
f0104239:	66 a3 e6 f2 57 f0    	mov    %ax,0xf057f2e6
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f010423f:	b8 0c 4d 10 f0       	mov    $0xf0104d0c,%eax
f0104244:	66 a3 e8 f2 57 f0    	mov    %ax,0xf057f2e8
f010424a:	66 c7 05 ea f2 57 f0 	movw   $0x8,0xf057f2ea
f0104251:	08 00 
f0104253:	c6 05 ec f2 57 f0 00 	movb   $0x0,0xf057f2ec
f010425a:	c6 05 ed f2 57 f0 8e 	movb   $0x8e,0xf057f2ed
f0104261:	c1 e8 10             	shr    $0x10,%eax
f0104264:	66 a3 ee f2 57 f0    	mov    %ax,0xf057f2ee
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f010426a:	b8 10 4d 10 f0       	mov    $0xf0104d10,%eax
f010426f:	66 a3 f0 f2 57 f0    	mov    %ax,0xf057f2f0
f0104275:	66 c7 05 f2 f2 57 f0 	movw   $0x8,0xf057f2f2
f010427c:	08 00 
f010427e:	c6 05 f4 f2 57 f0 00 	movb   $0x0,0xf057f2f4
f0104285:	c6 05 f5 f2 57 f0 8e 	movb   $0x8e,0xf057f2f5
f010428c:	c1 e8 10             	shr    $0x10,%eax
f010428f:	66 a3 f6 f2 57 f0    	mov    %ax,0xf057f2f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f0104295:	b8 16 4d 10 f0       	mov    $0xf0104d16,%eax
f010429a:	66 a3 f8 f2 57 f0    	mov    %ax,0xf057f2f8
f01042a0:	66 c7 05 fa f2 57 f0 	movw   $0x8,0xf057f2fa
f01042a7:	08 00 
f01042a9:	c6 05 fc f2 57 f0 00 	movb   $0x0,0xf057f2fc
f01042b0:	c6 05 fd f2 57 f0 8e 	movb   $0x8e,0xf057f2fd
f01042b7:	c1 e8 10             	shr    $0x10,%eax
f01042ba:	66 a3 fe f2 57 f0    	mov    %ax,0xf057f2fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f01042c0:	b8 1c 4d 10 f0       	mov    $0xf0104d1c,%eax
f01042c5:	66 a3 e0 f3 57 f0    	mov    %ax,0xf057f3e0
f01042cb:	66 c7 05 e2 f3 57 f0 	movw   $0x8,0xf057f3e2
f01042d2:	08 00 
f01042d4:	c6 05 e4 f3 57 f0 00 	movb   $0x0,0xf057f3e4
f01042db:	c6 05 e5 f3 57 f0 ee 	movb   $0xee,0xf057f3e5
f01042e2:	c1 e8 10             	shr    $0x10,%eax
f01042e5:	66 a3 e6 f3 57 f0    	mov    %ax,0xf057f3e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f01042eb:	b8 22 4d 10 f0       	mov    $0xf0104d22,%eax
f01042f0:	66 a3 60 f3 57 f0    	mov    %ax,0xf057f360
f01042f6:	66 c7 05 62 f3 57 f0 	movw   $0x8,0xf057f362
f01042fd:	08 00 
f01042ff:	c6 05 64 f3 57 f0 00 	movb   $0x0,0xf057f364
f0104306:	c6 05 65 f3 57 f0 8e 	movb   $0x8e,0xf057f365
f010430d:	c1 e8 10             	shr    $0x10,%eax
f0104310:	66 a3 66 f3 57 f0    	mov    %ax,0xf057f366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f0104316:	b8 28 4d 10 f0       	mov    $0xf0104d28,%eax
f010431b:	66 a3 68 f3 57 f0    	mov    %ax,0xf057f368
f0104321:	66 c7 05 6a f3 57 f0 	movw   $0x8,0xf057f36a
f0104328:	08 00 
f010432a:	c6 05 6c f3 57 f0 00 	movb   $0x0,0xf057f36c
f0104331:	c6 05 6d f3 57 f0 8e 	movb   $0x8e,0xf057f36d
f0104338:	c1 e8 10             	shr    $0x10,%eax
f010433b:	66 a3 6e f3 57 f0    	mov    %ax,0xf057f36e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f0104341:	b8 2e 4d 10 f0       	mov    $0xf0104d2e,%eax
f0104346:	66 a3 70 f3 57 f0    	mov    %ax,0xf057f370
f010434c:	66 c7 05 72 f3 57 f0 	movw   $0x8,0xf057f372
f0104353:	08 00 
f0104355:	c6 05 74 f3 57 f0 00 	movb   $0x0,0xf057f374
f010435c:	c6 05 75 f3 57 f0 8e 	movb   $0x8e,0xf057f375
f0104363:	c1 e8 10             	shr    $0x10,%eax
f0104366:	66 a3 76 f3 57 f0    	mov    %ax,0xf057f376
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f010436c:	b8 34 4d 10 f0       	mov    $0xf0104d34,%eax
f0104371:	66 a3 78 f3 57 f0    	mov    %ax,0xf057f378
f0104377:	66 c7 05 7a f3 57 f0 	movw   $0x8,0xf057f37a
f010437e:	08 00 
f0104380:	c6 05 7c f3 57 f0 00 	movb   $0x0,0xf057f37c
f0104387:	c6 05 7d f3 57 f0 8e 	movb   $0x8e,0xf057f37d
f010438e:	c1 e8 10             	shr    $0x10,%eax
f0104391:	66 a3 7e f3 57 f0    	mov    %ax,0xf057f37e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f0104397:	b8 3a 4d 10 f0       	mov    $0xf0104d3a,%eax
f010439c:	66 a3 80 f3 57 f0    	mov    %ax,0xf057f380
f01043a2:	66 c7 05 82 f3 57 f0 	movw   $0x8,0xf057f382
f01043a9:	08 00 
f01043ab:	c6 05 84 f3 57 f0 00 	movb   $0x0,0xf057f384
f01043b2:	c6 05 85 f3 57 f0 8e 	movb   $0x8e,0xf057f385
f01043b9:	c1 e8 10             	shr    $0x10,%eax
f01043bc:	66 a3 86 f3 57 f0    	mov    %ax,0xf057f386
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f01043c2:	b8 40 4d 10 f0       	mov    $0xf0104d40,%eax
f01043c7:	66 a3 88 f3 57 f0    	mov    %ax,0xf057f388
f01043cd:	66 c7 05 8a f3 57 f0 	movw   $0x8,0xf057f38a
f01043d4:	08 00 
f01043d6:	c6 05 8c f3 57 f0 00 	movb   $0x0,0xf057f38c
f01043dd:	c6 05 8d f3 57 f0 8e 	movb   $0x8e,0xf057f38d
f01043e4:	c1 e8 10             	shr    $0x10,%eax
f01043e7:	66 a3 8e f3 57 f0    	mov    %ax,0xf057f38e
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f01043ed:	b8 46 4d 10 f0       	mov    $0xf0104d46,%eax
f01043f2:	66 a3 90 f3 57 f0    	mov    %ax,0xf057f390
f01043f8:	66 c7 05 92 f3 57 f0 	movw   $0x8,0xf057f392
f01043ff:	08 00 
f0104401:	c6 05 94 f3 57 f0 00 	movb   $0x0,0xf057f394
f0104408:	c6 05 95 f3 57 f0 8e 	movb   $0x8e,0xf057f395
f010440f:	c1 e8 10             	shr    $0x10,%eax
f0104412:	66 a3 96 f3 57 f0    	mov    %ax,0xf057f396
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f0104418:	b8 4c 4d 10 f0       	mov    $0xf0104d4c,%eax
f010441d:	66 a3 98 f3 57 f0    	mov    %ax,0xf057f398
f0104423:	66 c7 05 9a f3 57 f0 	movw   $0x8,0xf057f39a
f010442a:	08 00 
f010442c:	c6 05 9c f3 57 f0 00 	movb   $0x0,0xf057f39c
f0104433:	c6 05 9d f3 57 f0 8e 	movb   $0x8e,0xf057f39d
f010443a:	c1 e8 10             	shr    $0x10,%eax
f010443d:	66 a3 9e f3 57 f0    	mov    %ax,0xf057f39e
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f0104443:	b8 52 4d 10 f0       	mov    $0xf0104d52,%eax
f0104448:	66 a3 a0 f3 57 f0    	mov    %ax,0xf057f3a0
f010444e:	66 c7 05 a2 f3 57 f0 	movw   $0x8,0xf057f3a2
f0104455:	08 00 
f0104457:	c6 05 a4 f3 57 f0 00 	movb   $0x0,0xf057f3a4
f010445e:	c6 05 a5 f3 57 f0 8e 	movb   $0x8e,0xf057f3a5
f0104465:	c1 e8 10             	shr    $0x10,%eax
f0104468:	66 a3 a6 f3 57 f0    	mov    %ax,0xf057f3a6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f010446e:	b8 58 4d 10 f0       	mov    $0xf0104d58,%eax
f0104473:	66 a3 a8 f3 57 f0    	mov    %ax,0xf057f3a8
f0104479:	66 c7 05 aa f3 57 f0 	movw   $0x8,0xf057f3aa
f0104480:	08 00 
f0104482:	c6 05 ac f3 57 f0 00 	movb   $0x0,0xf057f3ac
f0104489:	c6 05 ad f3 57 f0 8e 	movb   $0x8e,0xf057f3ad
f0104490:	c1 e8 10             	shr    $0x10,%eax
f0104493:	66 a3 ae f3 57 f0    	mov    %ax,0xf057f3ae
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f0104499:	b8 5e 4d 10 f0       	mov    $0xf0104d5e,%eax
f010449e:	66 a3 b0 f3 57 f0    	mov    %ax,0xf057f3b0
f01044a4:	66 c7 05 b2 f3 57 f0 	movw   $0x8,0xf057f3b2
f01044ab:	08 00 
f01044ad:	c6 05 b4 f3 57 f0 00 	movb   $0x0,0xf057f3b4
f01044b4:	c6 05 b5 f3 57 f0 8e 	movb   $0x8e,0xf057f3b5
f01044bb:	c1 e8 10             	shr    $0x10,%eax
f01044be:	66 a3 b6 f3 57 f0    	mov    %ax,0xf057f3b6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f01044c4:	b8 64 4d 10 f0       	mov    $0xf0104d64,%eax
f01044c9:	66 a3 b8 f3 57 f0    	mov    %ax,0xf057f3b8
f01044cf:	66 c7 05 ba f3 57 f0 	movw   $0x8,0xf057f3ba
f01044d6:	08 00 
f01044d8:	c6 05 bc f3 57 f0 00 	movb   $0x0,0xf057f3bc
f01044df:	c6 05 bd f3 57 f0 8e 	movb   $0x8e,0xf057f3bd
f01044e6:	c1 e8 10             	shr    $0x10,%eax
f01044e9:	66 a3 be f3 57 f0    	mov    %ax,0xf057f3be
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f01044ef:	b8 6a 4d 10 f0       	mov    $0xf0104d6a,%eax
f01044f4:	66 a3 c0 f3 57 f0    	mov    %ax,0xf057f3c0
f01044fa:	66 c7 05 c2 f3 57 f0 	movw   $0x8,0xf057f3c2
f0104501:	08 00 
f0104503:	c6 05 c4 f3 57 f0 00 	movb   $0x0,0xf057f3c4
f010450a:	c6 05 c5 f3 57 f0 8e 	movb   $0x8e,0xf057f3c5
f0104511:	c1 e8 10             	shr    $0x10,%eax
f0104514:	66 a3 c6 f3 57 f0    	mov    %ax,0xf057f3c6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f010451a:	b8 70 4d 10 f0       	mov    $0xf0104d70,%eax
f010451f:	66 a3 c8 f3 57 f0    	mov    %ax,0xf057f3c8
f0104525:	66 c7 05 ca f3 57 f0 	movw   $0x8,0xf057f3ca
f010452c:	08 00 
f010452e:	c6 05 cc f3 57 f0 00 	movb   $0x0,0xf057f3cc
f0104535:	c6 05 cd f3 57 f0 8e 	movb   $0x8e,0xf057f3cd
f010453c:	c1 e8 10             	shr    $0x10,%eax
f010453f:	66 a3 ce f3 57 f0    	mov    %ax,0xf057f3ce
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f0104545:	b8 76 4d 10 f0       	mov    $0xf0104d76,%eax
f010454a:	66 a3 d0 f3 57 f0    	mov    %ax,0xf057f3d0
f0104550:	66 c7 05 d2 f3 57 f0 	movw   $0x8,0xf057f3d2
f0104557:	08 00 
f0104559:	c6 05 d4 f3 57 f0 00 	movb   $0x0,0xf057f3d4
f0104560:	c6 05 d5 f3 57 f0 8e 	movb   $0x8e,0xf057f3d5
f0104567:	c1 e8 10             	shr    $0x10,%eax
f010456a:	66 a3 d6 f3 57 f0    	mov    %ax,0xf057f3d6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f0104570:	b8 7c 4d 10 f0       	mov    $0xf0104d7c,%eax
f0104575:	66 a3 d8 f3 57 f0    	mov    %ax,0xf057f3d8
f010457b:	66 c7 05 da f3 57 f0 	movw   $0x8,0xf057f3da
f0104582:	08 00 
f0104584:	c6 05 dc f3 57 f0 00 	movb   $0x0,0xf057f3dc
f010458b:	c6 05 dd f3 57 f0 8e 	movb   $0x8e,0xf057f3dd
f0104592:	c1 e8 10             	shr    $0x10,%eax
f0104595:	66 a3 de f3 57 f0    	mov    %ax,0xf057f3de
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f010459b:	b8 82 4d 10 f0       	mov    $0xf0104d82,%eax
f01045a0:	66 a3 f8 f3 57 f0    	mov    %ax,0xf057f3f8
f01045a6:	66 c7 05 fa f3 57 f0 	movw   $0x8,0xf057f3fa
f01045ad:	08 00 
f01045af:	c6 05 fc f3 57 f0 00 	movb   $0x0,0xf057f3fc
f01045b6:	c6 05 fd f3 57 f0 8e 	movb   $0x8e,0xf057f3fd
f01045bd:	c1 e8 10             	shr    $0x10,%eax
f01045c0:	66 a3 fe f3 57 f0    	mov    %ax,0xf057f3fe
	trap_init_percpu();
f01045c6:	e8 19 f9 ff ff       	call   f0103ee4 <trap_init_percpu>
}
f01045cb:	c9                   	leave  
f01045cc:	c3                   	ret    

f01045cd <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f01045cd:	55                   	push   %ebp
f01045ce:	89 e5                	mov    %esp,%ebp
f01045d0:	53                   	push   %ebx
f01045d1:	83 ec 0c             	sub    $0xc,%esp
f01045d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01045d7:	ff 33                	pushl  (%ebx)
f01045d9:	68 db 92 10 f0       	push   $0xf01092db
f01045de:	e8 ed f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01045e3:	83 c4 08             	add    $0x8,%esp
f01045e6:	ff 73 04             	pushl  0x4(%ebx)
f01045e9:	68 ea 92 10 f0       	push   $0xf01092ea
f01045ee:	e8 dd f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01045f3:	83 c4 08             	add    $0x8,%esp
f01045f6:	ff 73 08             	pushl  0x8(%ebx)
f01045f9:	68 f9 92 10 f0       	push   $0xf01092f9
f01045fe:	e8 cd f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104603:	83 c4 08             	add    $0x8,%esp
f0104606:	ff 73 0c             	pushl  0xc(%ebx)
f0104609:	68 08 93 10 f0       	push   $0xf0109308
f010460e:	e8 bd f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104613:	83 c4 08             	add    $0x8,%esp
f0104616:	ff 73 10             	pushl  0x10(%ebx)
f0104619:	68 17 93 10 f0       	push   $0xf0109317
f010461e:	e8 ad f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104623:	83 c4 08             	add    $0x8,%esp
f0104626:	ff 73 14             	pushl  0x14(%ebx)
f0104629:	68 26 93 10 f0       	push   $0xf0109326
f010462e:	e8 9d f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104633:	83 c4 08             	add    $0x8,%esp
f0104636:	ff 73 18             	pushl  0x18(%ebx)
f0104639:	68 35 93 10 f0       	push   $0xf0109335
f010463e:	e8 8d f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104643:	83 c4 08             	add    $0x8,%esp
f0104646:	ff 73 1c             	pushl  0x1c(%ebx)
f0104649:	68 44 93 10 f0       	push   $0xf0109344
f010464e:	e8 7d f8 ff ff       	call   f0103ed0 <cprintf>
}
f0104653:	83 c4 10             	add    $0x10,%esp
f0104656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104659:	c9                   	leave  
f010465a:	c3                   	ret    

f010465b <print_trapframe>:
{
f010465b:	55                   	push   %ebp
f010465c:	89 e5                	mov    %esp,%ebp
f010465e:	56                   	push   %esi
f010465f:	53                   	push   %ebx
f0104660:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104663:	e8 82 25 00 00       	call   f0106bea <cpunum>
f0104668:	83 ec 04             	sub    $0x4,%esp
f010466b:	50                   	push   %eax
f010466c:	53                   	push   %ebx
f010466d:	68 a8 93 10 f0       	push   $0xf01093a8
f0104672:	e8 59 f8 ff ff       	call   f0103ed0 <cprintf>
	print_regs(&tf->tf_regs);
f0104677:	89 1c 24             	mov    %ebx,(%esp)
f010467a:	e8 4e ff ff ff       	call   f01045cd <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f010467f:	83 c4 08             	add    $0x8,%esp
f0104682:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104686:	50                   	push   %eax
f0104687:	68 c6 93 10 f0       	push   $0xf01093c6
f010468c:	e8 3f f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104691:	83 c4 08             	add    $0x8,%esp
f0104694:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104698:	50                   	push   %eax
f0104699:	68 d9 93 10 f0       	push   $0xf01093d9
f010469e:	e8 2d f8 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01046a3:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f01046a6:	83 c4 10             	add    $0x10,%esp
f01046a9:	83 f8 13             	cmp    $0x13,%eax
f01046ac:	0f 86 e1 00 00 00    	jbe    f0104793 <print_trapframe+0x138>
		return "System call";
f01046b2:	ba 53 93 10 f0       	mov    $0xf0109353,%edx
	if (trapno == T_SYSCALL)
f01046b7:	83 f8 30             	cmp    $0x30,%eax
f01046ba:	74 13                	je     f01046cf <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01046bc:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01046bf:	83 fa 0f             	cmp    $0xf,%edx
f01046c2:	ba 5f 93 10 f0       	mov    $0xf010935f,%edx
f01046c7:	b9 6e 93 10 f0       	mov    $0xf010936e,%ecx
f01046cc:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01046cf:	83 ec 04             	sub    $0x4,%esp
f01046d2:	52                   	push   %edx
f01046d3:	50                   	push   %eax
f01046d4:	68 ec 93 10 f0       	push   $0xf01093ec
f01046d9:	e8 f2 f7 ff ff       	call   f0103ed0 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01046de:	83 c4 10             	add    $0x10,%esp
f01046e1:	39 1d 60 fa 57 f0    	cmp    %ebx,0xf057fa60
f01046e7:	0f 84 b2 00 00 00    	je     f010479f <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f01046ed:	83 ec 08             	sub    $0x8,%esp
f01046f0:	ff 73 2c             	pushl  0x2c(%ebx)
f01046f3:	68 0d 94 10 f0       	push   $0xf010940d
f01046f8:	e8 d3 f7 ff ff       	call   f0103ed0 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f01046fd:	83 c4 10             	add    $0x10,%esp
f0104700:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104704:	0f 85 b8 00 00 00    	jne    f01047c2 <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f010470a:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f010470d:	89 c2                	mov    %eax,%edx
f010470f:	83 e2 01             	and    $0x1,%edx
f0104712:	b9 81 93 10 f0       	mov    $0xf0109381,%ecx
f0104717:	ba 8c 93 10 f0       	mov    $0xf010938c,%edx
f010471c:	0f 44 ca             	cmove  %edx,%ecx
f010471f:	89 c2                	mov    %eax,%edx
f0104721:	83 e2 02             	and    $0x2,%edx
f0104724:	be 98 93 10 f0       	mov    $0xf0109398,%esi
f0104729:	ba 9e 93 10 f0       	mov    $0xf010939e,%edx
f010472e:	0f 45 d6             	cmovne %esi,%edx
f0104731:	83 e0 04             	and    $0x4,%eax
f0104734:	b8 a3 93 10 f0       	mov    $0xf01093a3,%eax
f0104739:	be f0 95 10 f0       	mov    $0xf01095f0,%esi
f010473e:	0f 44 c6             	cmove  %esi,%eax
f0104741:	51                   	push   %ecx
f0104742:	52                   	push   %edx
f0104743:	50                   	push   %eax
f0104744:	68 1b 94 10 f0       	push   $0xf010941b
f0104749:	e8 82 f7 ff ff       	call   f0103ed0 <cprintf>
f010474e:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104751:	83 ec 08             	sub    $0x8,%esp
f0104754:	ff 73 30             	pushl  0x30(%ebx)
f0104757:	68 2a 94 10 f0       	push   $0xf010942a
f010475c:	e8 6f f7 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104761:	83 c4 08             	add    $0x8,%esp
f0104764:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104768:	50                   	push   %eax
f0104769:	68 39 94 10 f0       	push   $0xf0109439
f010476e:	e8 5d f7 ff ff       	call   f0103ed0 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104773:	83 c4 08             	add    $0x8,%esp
f0104776:	ff 73 38             	pushl  0x38(%ebx)
f0104779:	68 4c 94 10 f0       	push   $0xf010944c
f010477e:	e8 4d f7 ff ff       	call   f0103ed0 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104783:	83 c4 10             	add    $0x10,%esp
f0104786:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010478a:	75 4b                	jne    f01047d7 <print_trapframe+0x17c>
}
f010478c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010478f:	5b                   	pop    %ebx
f0104790:	5e                   	pop    %esi
f0104791:	5d                   	pop    %ebp
f0104792:	c3                   	ret    
		return excnames[trapno];
f0104793:	8b 14 85 40 98 10 f0 	mov    -0xfef67c0(,%eax,4),%edx
f010479a:	e9 30 ff ff ff       	jmp    f01046cf <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010479f:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01047a3:	0f 85 44 ff ff ff    	jne    f01046ed <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01047a9:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01047ac:	83 ec 08             	sub    $0x8,%esp
f01047af:	50                   	push   %eax
f01047b0:	68 fe 93 10 f0       	push   $0xf01093fe
f01047b5:	e8 16 f7 ff ff       	call   f0103ed0 <cprintf>
f01047ba:	83 c4 10             	add    $0x10,%esp
f01047bd:	e9 2b ff ff ff       	jmp    f01046ed <print_trapframe+0x92>
		cprintf("\n");
f01047c2:	83 ec 0c             	sub    $0xc,%esp
f01047c5:	68 5b 91 10 f0       	push   $0xf010915b
f01047ca:	e8 01 f7 ff ff       	call   f0103ed0 <cprintf>
f01047cf:	83 c4 10             	add    $0x10,%esp
f01047d2:	e9 7a ff ff ff       	jmp    f0104751 <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01047d7:	83 ec 08             	sub    $0x8,%esp
f01047da:	ff 73 3c             	pushl  0x3c(%ebx)
f01047dd:	68 5b 94 10 f0       	push   $0xf010945b
f01047e2:	e8 e9 f6 ff ff       	call   f0103ed0 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01047e7:	83 c4 08             	add    $0x8,%esp
f01047ea:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01047ee:	50                   	push   %eax
f01047ef:	68 6a 94 10 f0       	push   $0xf010946a
f01047f4:	e8 d7 f6 ff ff       	call   f0103ed0 <cprintf>
f01047f9:	83 c4 10             	add    $0x10,%esp
}
f01047fc:	eb 8e                	jmp    f010478c <print_trapframe+0x131>

f01047fe <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f01047fe:	55                   	push   %ebp
f01047ff:	89 e5                	mov    %esp,%ebp
f0104801:	57                   	push   %edi
f0104802:	56                   	push   %esi
f0104803:	53                   	push   %ebx
f0104804:	83 ec 0c             	sub    $0xc,%esp
f0104807:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010480a:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f010480d:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104811:	83 e0 03             	and    $0x3,%eax
f0104814:	66 83 f8 03          	cmp    $0x3,%ax
f0104818:	75 5d                	jne    f0104877 <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f010481a:	e8 cb 23 00 00       	call   f0106bea <cpunum>
f010481f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104822:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104828:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010482c:	75 69                	jne    f0104897 <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010482e:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f0104831:	e8 b4 23 00 00       	call   f0106bea <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104836:	57                   	push   %edi
f0104837:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f0104838:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010483b:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104841:	ff 70 48             	pushl  0x48(%eax)
f0104844:	68 3c 97 10 f0       	push   $0xf010973c
f0104849:	e8 82 f6 ff ff       	call   f0103ed0 <cprintf>
	print_trapframe(tf);
f010484e:	89 1c 24             	mov    %ebx,(%esp)
f0104851:	e8 05 fe ff ff       	call   f010465b <print_trapframe>
	env_destroy(curenv);
f0104856:	e8 8f 23 00 00       	call   f0106bea <cpunum>
f010485b:	83 c4 04             	add    $0x4,%esp
f010485e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104861:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104867:	e8 fd f2 ff ff       	call   f0103b69 <env_destroy>
}
f010486c:	83 c4 10             	add    $0x10,%esp
f010486f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104872:	5b                   	pop    %ebx
f0104873:	5e                   	pop    %esi
f0104874:	5f                   	pop    %edi
f0104875:	5d                   	pop    %ebp
f0104876:	c3                   	ret    
		print_trapframe(tf);//just test
f0104877:	83 ec 0c             	sub    $0xc,%esp
f010487a:	53                   	push   %ebx
f010487b:	e8 db fd ff ff       	call   f010465b <print_trapframe>
		panic("panic at kernel page_fault\n");
f0104880:	83 c4 0c             	add    $0xc,%esp
f0104883:	68 7d 94 10 f0       	push   $0xf010947d
f0104888:	68 c1 01 00 00       	push   $0x1c1
f010488d:	68 99 94 10 f0       	push   $0xf0109499
f0104892:	e8 b2 b7 ff ff       	call   f0100049 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104897:	8b 53 3c             	mov    0x3c(%ebx),%edx
f010489a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f010489f:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));		
f01048a1:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f01048a6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f01048ab:	77 05                	ja     f01048b2 <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f01048ad:	8d 42 c8             	lea    -0x38(%edx),%eax
f01048b0:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f01048b2:	e8 33 23 00 00       	call   f0106bea <cpunum>
f01048b7:	6a 02                	push   $0x2
f01048b9:	6a 34                	push   $0x34
f01048bb:	57                   	push   %edi
f01048bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01048bf:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f01048c5:	e8 a1 eb ff ff       	call   f010346b <user_mem_assert>
		utf->utf_fault_va = fault_va;
f01048ca:	89 fa                	mov    %edi,%edx
f01048cc:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f01048ce:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01048d1:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f01048d4:	8d 7f 08             	lea    0x8(%edi),%edi
f01048d7:	b9 08 00 00 00       	mov    $0x8,%ecx
f01048dc:	89 de                	mov    %ebx,%esi
f01048de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f01048e0:	8b 43 30             	mov    0x30(%ebx),%eax
f01048e3:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f01048e6:	8b 43 38             	mov    0x38(%ebx),%eax
f01048e9:	89 d7                	mov    %edx,%edi
f01048eb:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f01048ee:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01048f1:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f01048f4:	e8 f1 22 00 00       	call   f0106bea <cpunum>
f01048f9:	6b c0 74             	imul   $0x74,%eax,%eax
f01048fc:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104902:	8b 58 64             	mov    0x64(%eax),%ebx
f0104905:	e8 e0 22 00 00       	call   f0106bea <cpunum>
f010490a:	6b c0 74             	imul   $0x74,%eax,%eax
f010490d:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104913:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104916:	e8 cf 22 00 00       	call   f0106bea <cpunum>
f010491b:	6b c0 74             	imul   $0x74,%eax,%eax
f010491e:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104924:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104927:	e8 be 22 00 00       	call   f0106bea <cpunum>
f010492c:	83 c4 04             	add    $0x4,%esp
f010492f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104932:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104938:	e8 cb f2 ff ff       	call   f0103c08 <env_run>

f010493d <trap>:
{
f010493d:	55                   	push   %ebp
f010493e:	89 e5                	mov    %esp,%ebp
f0104940:	57                   	push   %edi
f0104941:	56                   	push   %esi
f0104942:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104945:	fc                   	cld    
	if (panicstr)
f0104946:	83 3d a0 0e 58 f0 00 	cmpl   $0x0,0xf0580ea0
f010494d:	74 01                	je     f0104950 <trap+0x13>
		asm volatile("hlt");
f010494f:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104950:	e8 95 22 00 00       	call   f0106bea <cpunum>
f0104955:	6b d0 74             	imul   $0x74,%eax,%edx
f0104958:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010495b:	b8 01 00 00 00       	mov    $0x1,%eax
f0104960:	f0 87 82 20 10 58 f0 	lock xchg %eax,-0xfa7efe0(%edx)
f0104967:	83 f8 02             	cmp    $0x2,%eax
f010496a:	74 30                	je     f010499c <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010496c:	9c                   	pushf  
f010496d:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f010496e:	f6 c4 02             	test   $0x2,%ah
f0104971:	75 3b                	jne    f01049ae <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0104973:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104977:	83 e0 03             	and    $0x3,%eax
f010497a:	66 83 f8 03          	cmp    $0x3,%ax
f010497e:	74 47                	je     f01049c7 <trap+0x8a>
	last_tf = tf;
f0104980:	89 35 60 fa 57 f0    	mov    %esi,0xf057fa60
	switch (tf->tf_trapno)
f0104986:	8b 46 28             	mov    0x28(%esi),%eax
f0104989:	83 e8 03             	sub    $0x3,%eax
f010498c:	83 f8 30             	cmp    $0x30,%eax
f010498f:	0f 87 92 02 00 00    	ja     f0104c27 <trap+0x2ea>
f0104995:	ff 24 85 60 97 10 f0 	jmp    *-0xfef68a0(,%eax,4)
	spin_lock(&kernel_lock);
f010499c:	83 ec 0c             	sub    $0xc,%esp
f010499f:	68 c0 83 12 f0       	push   $0xf01283c0
f01049a4:	e8 b1 24 00 00       	call   f0106e5a <spin_lock>
f01049a9:	83 c4 10             	add    $0x10,%esp
f01049ac:	eb be                	jmp    f010496c <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f01049ae:	68 a5 94 10 f0       	push   $0xf01094a5
f01049b3:	68 6b 8e 10 f0       	push   $0xf0108e6b
f01049b8:	68 8c 01 00 00       	push   $0x18c
f01049bd:	68 99 94 10 f0       	push   $0xf0109499
f01049c2:	e8 82 b6 ff ff       	call   f0100049 <_panic>
f01049c7:	83 ec 0c             	sub    $0xc,%esp
f01049ca:	68 c0 83 12 f0       	push   $0xf01283c0
f01049cf:	e8 86 24 00 00       	call   f0106e5a <spin_lock>
		assert(curenv);
f01049d4:	e8 11 22 00 00       	call   f0106bea <cpunum>
f01049d9:	6b c0 74             	imul   $0x74,%eax,%eax
f01049dc:	83 c4 10             	add    $0x10,%esp
f01049df:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f01049e6:	74 3e                	je     f0104a26 <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f01049e8:	e8 fd 21 00 00       	call   f0106bea <cpunum>
f01049ed:	6b c0 74             	imul   $0x74,%eax,%eax
f01049f0:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01049f6:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01049fa:	74 43                	je     f0104a3f <trap+0x102>
		curenv->env_tf = *tf;
f01049fc:	e8 e9 21 00 00       	call   f0106bea <cpunum>
f0104a01:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a04:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104a0a:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a0f:	89 c7                	mov    %eax,%edi
f0104a11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104a13:	e8 d2 21 00 00       	call   f0106bea <cpunum>
f0104a18:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a1b:	8b b0 28 10 58 f0    	mov    -0xfa7efd8(%eax),%esi
f0104a21:	e9 5a ff ff ff       	jmp    f0104980 <trap+0x43>
		assert(curenv);
f0104a26:	68 be 94 10 f0       	push   $0xf01094be
f0104a2b:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0104a30:	68 93 01 00 00       	push   $0x193
f0104a35:	68 99 94 10 f0       	push   $0xf0109499
f0104a3a:	e8 0a b6 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f0104a3f:	e8 a6 21 00 00       	call   f0106bea <cpunum>
f0104a44:	83 ec 0c             	sub    $0xc,%esp
f0104a47:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a4a:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104a50:	e8 27 ef ff ff       	call   f010397c <env_free>
			curenv = NULL;
f0104a55:	e8 90 21 00 00       	call   f0106bea <cpunum>
f0104a5a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a5d:	c7 80 28 10 58 f0 00 	movl   $0x0,-0xfa7efd8(%eax)
f0104a64:	00 00 00 
			sched_yield();
f0104a67:	e8 12 04 00 00       	call   f0104e7e <sched_yield>
			page_fault_handler(tf);
f0104a6c:	83 ec 0c             	sub    $0xc,%esp
f0104a6f:	56                   	push   %esi
f0104a70:	e8 89 fd ff ff       	call   f01047fe <page_fault_handler>
f0104a75:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104a78:	e8 6d 21 00 00       	call   f0106bea <cpunum>
f0104a7d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a80:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f0104a87:	74 18                	je     f0104aa1 <trap+0x164>
f0104a89:	e8 5c 21 00 00       	call   f0106bea <cpunum>
f0104a8e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a91:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104a97:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104a9b:	0f 84 ce 01 00 00    	je     f0104c6f <trap+0x332>
		sched_yield();
f0104aa1:	e8 d8 03 00 00       	call   f0104e7e <sched_yield>
			monitor(tf);
f0104aa6:	83 ec 0c             	sub    $0xc,%esp
f0104aa9:	56                   	push   %esi
f0104aaa:	e8 b1 c1 ff ff       	call   f0100c60 <monitor>
f0104aaf:	83 c4 10             	add    $0x10,%esp
f0104ab2:	eb c4                	jmp    f0104a78 <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0104ab4:	83 ec 08             	sub    $0x8,%esp
f0104ab7:	ff 76 04             	pushl  0x4(%esi)
f0104aba:	ff 36                	pushl  (%esi)
f0104abc:	ff 76 10             	pushl  0x10(%esi)
f0104abf:	ff 76 18             	pushl  0x18(%esi)
f0104ac2:	ff 76 14             	pushl  0x14(%esi)
f0104ac5:	ff 76 1c             	pushl  0x1c(%esi)
f0104ac8:	e8 02 05 00 00       	call   f0104fcf <syscall>
f0104acd:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104ad0:	83 c4 20             	add    $0x20,%esp
f0104ad3:	eb a3                	jmp    f0104a78 <trap+0x13b>
			time_tick();
f0104ad5:	e8 e4 2e 00 00       	call   f01079be <time_tick>
			lapic_eoi();
f0104ada:	e8 52 22 00 00       	call   f0106d31 <lapic_eoi>
			sched_yield();
f0104adf:	e8 9a 03 00 00       	call   f0104e7e <sched_yield>
			kbd_intr();
f0104ae4:	e8 3e bb ff ff       	call   f0100627 <kbd_intr>
f0104ae9:	eb 8d                	jmp    f0104a78 <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0104aeb:	83 ec 0c             	sub    $0xc,%esp
f0104aee:	68 60 95 10 f0       	push   $0xf0109560
f0104af3:	e8 d8 f3 ff ff       	call   f0103ed0 <cprintf>
f0104af8:	83 c4 10             	add    $0x10,%esp
f0104afb:	e9 78 ff ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0104b00:	83 ec 0c             	sub    $0xc,%esp
f0104b03:	68 77 95 10 f0       	push   $0xf0109577
f0104b08:	e8 c3 f3 ff ff       	call   f0103ed0 <cprintf>
f0104b0d:	83 c4 10             	add    $0x10,%esp
f0104b10:	e9 63 ff ff ff       	jmp    f0104a78 <trap+0x13b>
			serial_intr();
f0104b15:	e8 f1 ba ff ff       	call   f010060b <serial_intr>
f0104b1a:	e9 59 ff ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0104b1f:	83 ec 0c             	sub    $0xc,%esp
f0104b22:	68 aa 95 10 f0       	push   $0xf01095aa
f0104b27:	e8 a4 f3 ff ff       	call   f0103ed0 <cprintf>
f0104b2c:	83 c4 10             	add    $0x10,%esp
f0104b2f:	e9 44 ff ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0104b34:	83 ec 0c             	sub    $0xc,%esp
f0104b37:	68 c5 94 10 f0       	push   $0xf01094c5
f0104b3c:	e8 8f f3 ff ff       	call   f0103ed0 <cprintf>
f0104b41:	83 c4 10             	add    $0x10,%esp
f0104b44:	e9 2f ff ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("in Spurious\n");
f0104b49:	83 ec 0c             	sub    $0xc,%esp
f0104b4c:	68 db 94 10 f0       	push   $0xf01094db
f0104b51:	e8 7a f3 ff ff       	call   f0103ed0 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104b56:	c7 04 24 e8 94 10 f0 	movl   $0xf01094e8,(%esp)
f0104b5d:	e8 6e f3 ff ff       	call   f0103ed0 <cprintf>
f0104b62:	83 c4 10             	add    $0x10,%esp
f0104b65:	e9 0e ff ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104b6a:	83 ec 0c             	sub    $0xc,%esp
f0104b6d:	68 05 95 10 f0       	push   $0xf0109505
f0104b72:	e8 59 f3 ff ff       	call   f0103ed0 <cprintf>
f0104b77:	83 c4 10             	add    $0x10,%esp
f0104b7a:	e9 f9 fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104b7f:	83 ec 0c             	sub    $0xc,%esp
f0104b82:	68 1b 95 10 f0       	push   $0xf010951b
f0104b87:	e8 44 f3 ff ff       	call   f0103ed0 <cprintf>
f0104b8c:	83 c4 10             	add    $0x10,%esp
f0104b8f:	e9 e4 fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104b94:	83 ec 0c             	sub    $0xc,%esp
f0104b97:	68 31 95 10 f0       	push   $0xf0109531
f0104b9c:	e8 2f f3 ff ff       	call   f0103ed0 <cprintf>
f0104ba1:	83 c4 10             	add    $0x10,%esp
f0104ba4:	e9 cf fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104ba9:	83 ec 0c             	sub    $0xc,%esp
f0104bac:	68 48 95 10 f0       	push   $0xf0109548
f0104bb1:	e8 1a f3 ff ff       	call   f0103ed0 <cprintf>
f0104bb6:	83 c4 10             	add    $0x10,%esp
f0104bb9:	e9 ba fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104bbe:	83 ec 0c             	sub    $0xc,%esp
f0104bc1:	68 5f 95 10 f0       	push   $0xf010955f
f0104bc6:	e8 05 f3 ff ff       	call   f0103ed0 <cprintf>
f0104bcb:	83 c4 10             	add    $0x10,%esp
f0104bce:	e9 a5 fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104bd3:	83 ec 0c             	sub    $0xc,%esp
f0104bd6:	68 76 95 10 f0       	push   $0xf0109576
f0104bdb:	e8 f0 f2 ff ff       	call   f0103ed0 <cprintf>
f0104be0:	83 c4 10             	add    $0x10,%esp
f0104be3:	e9 90 fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104be8:	83 ec 0c             	sub    $0xc,%esp
f0104beb:	68 8d 95 10 f0       	push   $0xf010958d
f0104bf0:	e8 db f2 ff ff       	call   f0103ed0 <cprintf>
f0104bf5:	83 c4 10             	add    $0x10,%esp
f0104bf8:	e9 7b fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104bfd:	83 ec 0c             	sub    $0xc,%esp
f0104c00:	68 a9 95 10 f0       	push   $0xf01095a9
f0104c05:	e8 c6 f2 ff ff       	call   f0103ed0 <cprintf>
f0104c0a:	83 c4 10             	add    $0x10,%esp
f0104c0d:	e9 66 fe ff ff       	jmp    f0104a78 <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104c12:	83 ec 0c             	sub    $0xc,%esp
f0104c15:	68 c0 95 10 f0       	push   $0xf01095c0
f0104c1a:	e8 b1 f2 ff ff       	call   f0103ed0 <cprintf>
f0104c1f:	83 c4 10             	add    $0x10,%esp
f0104c22:	e9 51 fe ff ff       	jmp    f0104a78 <trap+0x13b>
			print_trapframe(tf);
f0104c27:	83 ec 0c             	sub    $0xc,%esp
f0104c2a:	56                   	push   %esi
f0104c2b:	e8 2b fa ff ff       	call   f010465b <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104c30:	83 c4 10             	add    $0x10,%esp
f0104c33:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104c38:	74 1e                	je     f0104c58 <trap+0x31b>
				env_destroy(curenv);
f0104c3a:	e8 ab 1f 00 00       	call   f0106bea <cpunum>
f0104c3f:	83 ec 0c             	sub    $0xc,%esp
f0104c42:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c45:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104c4b:	e8 19 ef ff ff       	call   f0103b69 <env_destroy>
f0104c50:	83 c4 10             	add    $0x10,%esp
f0104c53:	e9 20 fe ff ff       	jmp    f0104a78 <trap+0x13b>
				panic("unhandled trap in kernel");
f0104c58:	83 ec 04             	sub    $0x4,%esp
f0104c5b:	68 de 95 10 f0       	push   $0xf01095de
f0104c60:	68 6f 01 00 00       	push   $0x16f
f0104c65:	68 99 94 10 f0       	push   $0xf0109499
f0104c6a:	e8 da b3 ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f0104c6f:	e8 76 1f 00 00       	call   f0106bea <cpunum>
f0104c74:	83 ec 0c             	sub    $0xc,%esp
f0104c77:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c7a:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104c80:	e8 83 ef ff ff       	call   f0103c08 <env_run>
f0104c85:	90                   	nop

f0104c86 <DIVIDE_HANDLER>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(DIVIDE_HANDLER   , T_DIVIDE )
f0104c86:	6a 00                	push   $0x0
f0104c88:	6a 00                	push   $0x0
f0104c8a:	e9 f9 00 00 00       	jmp    f0104d88 <_alltraps>
f0104c8f:	90                   	nop

f0104c90 <DEBUG_HANDLER>:
	TRAPHANDLER_NOEC(DEBUG_HANDLER    , T_DEBUG  )
f0104c90:	6a 00                	push   $0x0
f0104c92:	6a 01                	push   $0x1
f0104c94:	e9 ef 00 00 00       	jmp    f0104d88 <_alltraps>
f0104c99:	90                   	nop

f0104c9a <NMI_HANDLER>:
	TRAPHANDLER_NOEC(NMI_HANDLER      , T_NMI    )
f0104c9a:	6a 00                	push   $0x0
f0104c9c:	6a 02                	push   $0x2
f0104c9e:	e9 e5 00 00 00       	jmp    f0104d88 <_alltraps>
f0104ca3:	90                   	nop

f0104ca4 <BRKPT_HANDLER>:
	TRAPHANDLER_NOEC(BRKPT_HANDLER    , T_BRKPT  )
f0104ca4:	6a 00                	push   $0x0
f0104ca6:	6a 03                	push   $0x3
f0104ca8:	e9 db 00 00 00       	jmp    f0104d88 <_alltraps>
f0104cad:	90                   	nop

f0104cae <OFLOW_HANDLER>:
	TRAPHANDLER_NOEC(OFLOW_HANDLER    , T_OFLOW  )
f0104cae:	6a 00                	push   $0x0
f0104cb0:	6a 04                	push   $0x4
f0104cb2:	e9 d1 00 00 00       	jmp    f0104d88 <_alltraps>
f0104cb7:	90                   	nop

f0104cb8 <BOUND_HANDLER>:
	TRAPHANDLER_NOEC(BOUND_HANDLER    , T_BOUND  )
f0104cb8:	6a 00                	push   $0x0
f0104cba:	6a 05                	push   $0x5
f0104cbc:	e9 c7 00 00 00       	jmp    f0104d88 <_alltraps>
f0104cc1:	90                   	nop

f0104cc2 <ILLOP_HANDLER>:
	TRAPHANDLER_NOEC(ILLOP_HANDLER    , T_ILLOP  )
f0104cc2:	6a 00                	push   $0x0
f0104cc4:	6a 06                	push   $0x6
f0104cc6:	e9 bd 00 00 00       	jmp    f0104d88 <_alltraps>
f0104ccb:	90                   	nop

f0104ccc <DEVICE_HANDLER>:
	TRAPHANDLER_NOEC(DEVICE_HANDLER   , T_DEVICE )
f0104ccc:	6a 00                	push   $0x0
f0104cce:	6a 07                	push   $0x7
f0104cd0:	e9 b3 00 00 00       	jmp    f0104d88 <_alltraps>
f0104cd5:	90                   	nop

f0104cd6 <DBLFLT_HANDLER>:
	TRAPHANDLER(	 DBLFLT_HANDLER   , T_DBLFLT )
f0104cd6:	6a 08                	push   $0x8
f0104cd8:	e9 ab 00 00 00       	jmp    f0104d88 <_alltraps>
f0104cdd:	90                   	nop

f0104cde <TSS_HANDLER>:
	TRAPHANDLER(	 TSS_HANDLER      , T_TSS	 )
f0104cde:	6a 0a                	push   $0xa
f0104ce0:	e9 a3 00 00 00       	jmp    f0104d88 <_alltraps>
f0104ce5:	90                   	nop

f0104ce6 <SEGNP_HANDLER>:
	TRAPHANDLER(	 SEGNP_HANDLER    , T_SEGNP  )
f0104ce6:	6a 0b                	push   $0xb
f0104ce8:	e9 9b 00 00 00       	jmp    f0104d88 <_alltraps>
f0104ced:	90                   	nop

f0104cee <STACK_HANDLER>:
	TRAPHANDLER(	 STACK_HANDLER    , T_STACK  )
f0104cee:	6a 0c                	push   $0xc
f0104cf0:	e9 93 00 00 00       	jmp    f0104d88 <_alltraps>
f0104cf5:	90                   	nop

f0104cf6 <GPFLT_HANDLER>:
	TRAPHANDLER(	 GPFLT_HANDLER    , T_GPFLT  )
f0104cf6:	6a 0d                	push   $0xd
f0104cf8:	e9 8b 00 00 00       	jmp    f0104d88 <_alltraps>
f0104cfd:	90                   	nop

f0104cfe <PGFLT_HANDLER>:
	TRAPHANDLER(	 PGFLT_HANDLER    , T_PGFLT  )
f0104cfe:	6a 0e                	push   $0xe
f0104d00:	e9 83 00 00 00       	jmp    f0104d88 <_alltraps>
f0104d05:	90                   	nop

f0104d06 <FPERR_HANDLER>:
	TRAPHANDLER_NOEC(FPERR_HANDLER 	  , T_FPERR  )
f0104d06:	6a 00                	push   $0x0
f0104d08:	6a 10                	push   $0x10
f0104d0a:	eb 7c                	jmp    f0104d88 <_alltraps>

f0104d0c <ALIGN_HANDLER>:
	TRAPHANDLER(	 ALIGN_HANDLER    , T_ALIGN  )
f0104d0c:	6a 11                	push   $0x11
f0104d0e:	eb 78                	jmp    f0104d88 <_alltraps>

f0104d10 <MCHK_HANDLER>:
	TRAPHANDLER_NOEC(MCHK_HANDLER     , T_MCHK   )
f0104d10:	6a 00                	push   $0x0
f0104d12:	6a 12                	push   $0x12
f0104d14:	eb 72                	jmp    f0104d88 <_alltraps>

f0104d16 <SIMDERR_HANDLER>:
	TRAPHANDLER_NOEC(SIMDERR_HANDLER  , T_SIMDERR)
f0104d16:	6a 00                	push   $0x0
f0104d18:	6a 13                	push   $0x13
f0104d1a:	eb 6c                	jmp    f0104d88 <_alltraps>

f0104d1c <SYSCALL_HANDLER>:
	TRAPHANDLER_NOEC(SYSCALL_HANDLER  , T_SYSCALL) /* just test*/
f0104d1c:	6a 00                	push   $0x0
f0104d1e:	6a 30                	push   $0x30
f0104d20:	eb 66                	jmp    f0104d88 <_alltraps>

f0104d22 <TIMER_HANDLER>:

	TRAPHANDLER_NOEC(TIMER_HANDLER	  , IRQ_OFFSET + IRQ_TIMER)
f0104d22:	6a 00                	push   $0x0
f0104d24:	6a 20                	push   $0x20
f0104d26:	eb 60                	jmp    f0104d88 <_alltraps>

f0104d28 <KBD_HANDLER>:
	TRAPHANDLER_NOEC(KBD_HANDLER	  , IRQ_OFFSET + IRQ_KBD)
f0104d28:	6a 00                	push   $0x0
f0104d2a:	6a 21                	push   $0x21
f0104d2c:	eb 5a                	jmp    f0104d88 <_alltraps>

f0104d2e <SECOND_HANDLER>:
	TRAPHANDLER_NOEC(SECOND_HANDLER	  , IRQ_OFFSET + 2)
f0104d2e:	6a 00                	push   $0x0
f0104d30:	6a 22                	push   $0x22
f0104d32:	eb 54                	jmp    f0104d88 <_alltraps>

f0104d34 <THIRD_HANDLER>:
	TRAPHANDLER_NOEC(THIRD_HANDLER	  , IRQ_OFFSET + 3)
f0104d34:	6a 00                	push   $0x0
f0104d36:	6a 23                	push   $0x23
f0104d38:	eb 4e                	jmp    f0104d88 <_alltraps>

f0104d3a <SERIAL_HANDLER>:
	TRAPHANDLER_NOEC(SERIAL_HANDLER	  , IRQ_OFFSET + IRQ_SERIAL)
f0104d3a:	6a 00                	push   $0x0
f0104d3c:	6a 24                	push   $0x24
f0104d3e:	eb 48                	jmp    f0104d88 <_alltraps>

f0104d40 <FIFTH_HANDLER>:
	TRAPHANDLER_NOEC(FIFTH_HANDLER	  , IRQ_OFFSET + 5)
f0104d40:	6a 00                	push   $0x0
f0104d42:	6a 25                	push   $0x25
f0104d44:	eb 42                	jmp    f0104d88 <_alltraps>

f0104d46 <SIXTH_HANDLER>:
	TRAPHANDLER_NOEC(SIXTH_HANDLER	  , IRQ_OFFSET + 6)
f0104d46:	6a 00                	push   $0x0
f0104d48:	6a 26                	push   $0x26
f0104d4a:	eb 3c                	jmp    f0104d88 <_alltraps>

f0104d4c <SPURIOUS_HANDLER>:
	TRAPHANDLER_NOEC(SPURIOUS_HANDLER , IRQ_OFFSET + IRQ_SPURIOUS)
f0104d4c:	6a 00                	push   $0x0
f0104d4e:	6a 27                	push   $0x27
f0104d50:	eb 36                	jmp    f0104d88 <_alltraps>

f0104d52 <EIGHTH_HANDLER>:
	TRAPHANDLER_NOEC(EIGHTH_HANDLER	  , IRQ_OFFSET + 8)
f0104d52:	6a 00                	push   $0x0
f0104d54:	6a 28                	push   $0x28
f0104d56:	eb 30                	jmp    f0104d88 <_alltraps>

f0104d58 <NINTH_HANDLER>:
	TRAPHANDLER_NOEC(NINTH_HANDLER	  , IRQ_OFFSET + 9)
f0104d58:	6a 00                	push   $0x0
f0104d5a:	6a 29                	push   $0x29
f0104d5c:	eb 2a                	jmp    f0104d88 <_alltraps>

f0104d5e <TENTH_HANDLER>:
	TRAPHANDLER_NOEC(TENTH_HANDLER	  , IRQ_OFFSET + 10)
f0104d5e:	6a 00                	push   $0x0
f0104d60:	6a 2a                	push   $0x2a
f0104d62:	eb 24                	jmp    f0104d88 <_alltraps>

f0104d64 <ELEVEN_HANDLER>:
	TRAPHANDLER_NOEC(ELEVEN_HANDLER	  , IRQ_OFFSET + 11)
f0104d64:	6a 00                	push   $0x0
f0104d66:	6a 2b                	push   $0x2b
f0104d68:	eb 1e                	jmp    f0104d88 <_alltraps>

f0104d6a <TWELVE_HANDLER>:
	TRAPHANDLER_NOEC(TWELVE_HANDLER	  , IRQ_OFFSET + 12)
f0104d6a:	6a 00                	push   $0x0
f0104d6c:	6a 2c                	push   $0x2c
f0104d6e:	eb 18                	jmp    f0104d88 <_alltraps>

f0104d70 <THIRTEEN_HANDLER>:
	TRAPHANDLER_NOEC(THIRTEEN_HANDLER , IRQ_OFFSET + 13)
f0104d70:	6a 00                	push   $0x0
f0104d72:	6a 2d                	push   $0x2d
f0104d74:	eb 12                	jmp    f0104d88 <_alltraps>

f0104d76 <IDE_HANDLER>:
	TRAPHANDLER_NOEC(IDE_HANDLER	  , IRQ_OFFSET + IRQ_IDE)
f0104d76:	6a 00                	push   $0x0
f0104d78:	6a 2e                	push   $0x2e
f0104d7a:	eb 0c                	jmp    f0104d88 <_alltraps>

f0104d7c <FIFTEEN_HANDLER>:
	TRAPHANDLER_NOEC(FIFTEEN_HANDLER  , IRQ_OFFSET + 15)
f0104d7c:	6a 00                	push   $0x0
f0104d7e:	6a 2f                	push   $0x2f
f0104d80:	eb 06                	jmp    f0104d88 <_alltraps>

f0104d82 <ERROR_HANDLER>:
	TRAPHANDLER_NOEC(ERROR_HANDLER	  , IRQ_OFFSET + IRQ_ERROR)
f0104d82:	6a 00                	push   $0x0
f0104d84:	6a 33                	push   $0x33
f0104d86:	eb 00                	jmp    f0104d88 <_alltraps>

f0104d88 <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */

.globl _alltraps
_alltraps:
	pushw $0
f0104d88:	66 6a 00             	pushw  $0x0
	pushw %ds 
f0104d8b:	66 1e                	pushw  %ds
	pushw $0
f0104d8d:	66 6a 00             	pushw  $0x0
	pushw %es 
f0104d90:	66 06                	pushw  %es
	pushal
f0104d92:	60                   	pusha  

	movl $(GD_KD), %eax 
f0104d93:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds 
f0104d98:	8e d8                	mov    %eax,%ds
	movw %ax, %es 
f0104d9a:	8e c0                	mov    %eax,%es

	pushl %esp 
f0104d9c:	54                   	push   %esp
	call trap
f0104d9d:	e8 9b fb ff ff       	call   f010493d <trap>

f0104da2 <sysenter_handler>:

; .global sysenter_handler
; sysenter_handler:
; 	pushl %esi 
f0104da2:	56                   	push   %esi
; 	pushl %edi
f0104da3:	57                   	push   %edi
; 	pushl %ebx
f0104da4:	53                   	push   %ebx
; 	pushl %ecx 
f0104da5:	51                   	push   %ecx
; 	pushl %edx
f0104da6:	52                   	push   %edx
; 	pushl %eax
f0104da7:	50                   	push   %eax
; 	call syscall
f0104da8:	e8 22 02 00 00       	call   f0104fcf <syscall>
; 	movl %esi, %edx
f0104dad:	89 f2                	mov    %esi,%edx
; 	movl %ebp, %ecx 
f0104daf:	89 e9                	mov    %ebp,%ecx
f0104db1:	0f 35                	sysexit 

f0104db3 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104db3:	55                   	push   %ebp
f0104db4:	89 e5                	mov    %esp,%ebp
f0104db6:	83 ec 08             	sub    $0x8,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104db9:	8b 0d 44 f2 57 f0    	mov    0xf057f244,%ecx
	for (i = 0; i < NENV; i++) {
f0104dbf:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104dc4:	89 c2                	mov    %eax,%edx
f0104dc6:	c1 e2 07             	shl    $0x7,%edx
		     envs[i].env_status == ENV_RUNNING ||
f0104dc9:	8b 54 11 54          	mov    0x54(%ecx,%edx,1),%edx
f0104dcd:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104dd0:	83 fa 02             	cmp    $0x2,%edx
f0104dd3:	76 29                	jbe    f0104dfe <sched_halt+0x4b>
	for (i = 0; i < NENV; i++) {
f0104dd5:	83 c0 01             	add    $0x1,%eax
f0104dd8:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104ddd:	75 e5                	jne    f0104dc4 <sched_halt+0x11>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104ddf:	83 ec 0c             	sub    $0xc,%esp
f0104de2:	68 90 98 10 f0       	push   $0xf0109890
f0104de7:	e8 e4 f0 ff ff       	call   f0103ed0 <cprintf>
f0104dec:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104def:	83 ec 0c             	sub    $0xc,%esp
f0104df2:	6a 00                	push   $0x0
f0104df4:	e8 67 be ff ff       	call   f0100c60 <monitor>
f0104df9:	83 c4 10             	add    $0x10,%esp
f0104dfc:	eb f1                	jmp    f0104def <sched_halt+0x3c>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104dfe:	e8 e7 1d 00 00       	call   f0106bea <cpunum>
f0104e03:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e06:	c7 80 28 10 58 f0 00 	movl   $0x0,-0xfa7efd8(%eax)
f0104e0d:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104e10:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
	if ((uint32_t)kva < KERNBASE)
f0104e15:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104e1a:	76 50                	jbe    f0104e6c <sched_halt+0xb9>
	return (physaddr_t)kva - KERNBASE;
f0104e1c:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104e21:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104e24:	e8 c1 1d 00 00       	call   f0106bea <cpunum>
f0104e29:	6b d0 74             	imul   $0x74,%eax,%edx
f0104e2c:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104e2f:	b8 02 00 00 00       	mov    $0x2,%eax
f0104e34:	f0 87 82 20 10 58 f0 	lock xchg %eax,-0xfa7efe0(%edx)
	spin_unlock(&kernel_lock);
f0104e3b:	83 ec 0c             	sub    $0xc,%esp
f0104e3e:	68 c0 83 12 f0       	push   $0xf01283c0
f0104e43:	e8 ae 20 00 00       	call   f0106ef6 <spin_unlock>
	asm volatile("pause");
f0104e48:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104e4a:	e8 9b 1d 00 00       	call   f0106bea <cpunum>
f0104e4f:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104e52:	8b 80 30 10 58 f0    	mov    -0xfa7efd0(%eax),%eax
f0104e58:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104e5d:	89 c4                	mov    %eax,%esp
f0104e5f:	6a 00                	push   $0x0
f0104e61:	6a 00                	push   $0x0
f0104e63:	fb                   	sti    
f0104e64:	f4                   	hlt    
f0104e65:	eb fd                	jmp    f0104e64 <sched_halt+0xb1>
}
f0104e67:	83 c4 10             	add    $0x10,%esp
f0104e6a:	c9                   	leave  
f0104e6b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104e6c:	50                   	push   %eax
f0104e6d:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0104e72:	6a 4c                	push   $0x4c
f0104e74:	68 b9 98 10 f0       	push   $0xf01098b9
f0104e79:	e8 cb b1 ff ff       	call   f0100049 <_panic>

f0104e7e <sched_yield>:
{
f0104e7e:	55                   	push   %ebp
f0104e7f:	89 e5                	mov    %esp,%ebp
f0104e81:	53                   	push   %ebx
f0104e82:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f0104e85:	e8 60 1d 00 00       	call   f0106bea <cpunum>
f0104e8a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e8d:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f0104e94:	74 7d                	je     f0104f13 <sched_yield+0x95>
		envid_t cur_tone = ENVX(curenv->env_id);
f0104e96:	e8 4f 1d 00 00       	call   f0106bea <cpunum>
f0104e9b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e9e:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104ea4:	8b 48 48             	mov    0x48(%eax),%ecx
f0104ea7:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104ead:	8d 41 01             	lea    0x1(%ecx),%eax
f0104eb0:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104eb5:	8b 1d 44 f2 57 f0    	mov    0xf057f244,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104ebb:	39 c8                	cmp    %ecx,%eax
f0104ebd:	74 20                	je     f0104edf <sched_yield+0x61>
			if(envs[i].env_status == ENV_RUNNABLE){
f0104ebf:	89 c2                	mov    %eax,%edx
f0104ec1:	c1 e2 07             	shl    $0x7,%edx
f0104ec4:	01 da                	add    %ebx,%edx
f0104ec6:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0104eca:	74 0a                	je     f0104ed6 <sched_yield+0x58>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104ecc:	83 c0 01             	add    $0x1,%eax
f0104ecf:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104ed4:	eb e5                	jmp    f0104ebb <sched_yield+0x3d>
				env_run(&envs[i]);
f0104ed6:	83 ec 0c             	sub    $0xc,%esp
f0104ed9:	52                   	push   %edx
f0104eda:	e8 29 ed ff ff       	call   f0103c08 <env_run>
		if(curenv->env_status == ENV_RUNNING)
f0104edf:	e8 06 1d 00 00       	call   f0106bea <cpunum>
f0104ee4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ee7:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104eed:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104ef1:	74 0a                	je     f0104efd <sched_yield+0x7f>
	sched_halt();
f0104ef3:	e8 bb fe ff ff       	call   f0104db3 <sched_halt>
}
f0104ef8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104efb:	c9                   	leave  
f0104efc:	c3                   	ret    
			env_run(curenv);
f0104efd:	e8 e8 1c 00 00       	call   f0106bea <cpunum>
f0104f02:	83 ec 0c             	sub    $0xc,%esp
f0104f05:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f08:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104f0e:	e8 f5 ec ff ff       	call   f0103c08 <env_run>
f0104f13:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
f0104f18:	8d 90 00 00 02 00    	lea    0x20000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f0104f1e:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104f22:	74 09                	je     f0104f2d <sched_yield+0xaf>
f0104f24:	83 e8 80             	sub    $0xffffff80,%eax
		for(i = 0 ; i < NENV; i++)
f0104f27:	39 d0                	cmp    %edx,%eax
f0104f29:	75 f3                	jne    f0104f1e <sched_yield+0xa0>
f0104f2b:	eb c6                	jmp    f0104ef3 <sched_yield+0x75>
		  		env_run(&envs[i]);
f0104f2d:	83 ec 0c             	sub    $0xc,%esp
f0104f30:	50                   	push   %eax
f0104f31:	e8 d2 ec ff ff       	call   f0103c08 <env_run>

f0104f36 <sys_net_send>:
	return time_msec();
}

int
sys_net_send(const void *buf, uint32_t len)
{
f0104f36:	55                   	push   %ebp
f0104f37:	89 e5                	mov    %esp,%ebp
f0104f39:	57                   	push   %edi
f0104f3a:	56                   	push   %esi
f0104f3b:	53                   	push   %ebx
f0104f3c:	83 ec 0c             	sub    $0xc,%esp
f0104f3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104f42:	8b 75 0c             	mov    0xc(%ebp),%esi
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_tx to send the packet
	// Hint: e1000_tx only accept kernel virtual address
	int r;
	if((r = user_mem_check(curenv, buf, len, PTE_W|PTE_U)) < 0){
f0104f45:	e8 a0 1c 00 00       	call   f0106bea <cpunum>
f0104f4a:	6a 06                	push   $0x6
f0104f4c:	56                   	push   %esi
f0104f4d:	53                   	push   %ebx
f0104f4e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f51:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104f57:	e8 67 e4 ff ff       	call   f01033c3 <user_mem_check>
f0104f5c:	83 c4 10             	add    $0x10,%esp
f0104f5f:	85 c0                	test   %eax,%eax
f0104f61:	78 19                	js     f0104f7c <sys_net_send+0x46>
		cprintf("address:%x\n", (uint32_t)buf);
		return r;
	}
	return e1000_tx(buf, len);
f0104f63:	83 ec 08             	sub    $0x8,%esp
f0104f66:	56                   	push   %esi
f0104f67:	53                   	push   %ebx
f0104f68:	e8 68 23 00 00       	call   f01072d5 <e1000_tx>
f0104f6d:	89 c7                	mov    %eax,%edi
f0104f6f:	83 c4 10             	add    $0x10,%esp

}
f0104f72:	89 f8                	mov    %edi,%eax
f0104f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104f77:	5b                   	pop    %ebx
f0104f78:	5e                   	pop    %esi
f0104f79:	5f                   	pop    %edi
f0104f7a:	5d                   	pop    %ebp
f0104f7b:	c3                   	ret    
f0104f7c:	89 c7                	mov    %eax,%edi
		cprintf("address:%x\n", (uint32_t)buf);
f0104f7e:	83 ec 08             	sub    $0x8,%esp
f0104f81:	53                   	push   %ebx
f0104f82:	68 c6 98 10 f0       	push   $0xf01098c6
f0104f87:	e8 44 ef ff ff       	call   f0103ed0 <cprintf>
		return r;
f0104f8c:	83 c4 10             	add    $0x10,%esp
f0104f8f:	eb e1                	jmp    f0104f72 <sys_net_send+0x3c>

f0104f91 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
f0104f91:	55                   	push   %ebp
f0104f92:	89 e5                	mov    %esp,%ebp
f0104f94:	53                   	push   %ebx
f0104f95:	83 ec 04             	sub    $0x4,%esp
f0104f98:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	user_mem_assert(curenv, ROUNDDOWN(buf, PGSIZE), PGSIZE, PTE_U | PTE_W);   // check permission
f0104f9b:	e8 4a 1c 00 00       	call   f0106bea <cpunum>
f0104fa0:	6a 06                	push   $0x6
f0104fa2:	68 00 10 00 00       	push   $0x1000
f0104fa7:	89 da                	mov    %ebx,%edx
f0104fa9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0104faf:	52                   	push   %edx
f0104fb0:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fb3:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104fb9:	e8 ad e4 ff ff       	call   f010346b <user_mem_assert>
  	return e1000_rx(buf,len);
f0104fbe:	83 c4 08             	add    $0x8,%esp
f0104fc1:	ff 75 0c             	pushl  0xc(%ebp)
f0104fc4:	53                   	push   %ebx
f0104fc5:	e8 30 24 00 00       	call   f01073fa <e1000_rx>
}
f0104fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104fcd:	c9                   	leave  
f0104fce:	c3                   	ret    

f0104fcf <syscall>:
	return 0;
}
// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104fcf:	55                   	push   %ebp
f0104fd0:	89 e5                	mov    %esp,%ebp
f0104fd2:	57                   	push   %edi
f0104fd3:	56                   	push   %esi
f0104fd4:	53                   	push   %ebx
f0104fd5:	83 ec 1c             	sub    $0x1c,%esp
f0104fd8:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f0104fdb:	83 f8 14             	cmp    $0x14,%eax
f0104fde:	0f 87 94 08 00 00    	ja     f0105878 <syscall+0x8a9>
f0104fe4:	ff 24 85 94 99 10 f0 	jmp    *-0xfef666c(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f0104feb:	e8 fa 1b 00 00       	call   f0106bea <cpunum>
f0104ff0:	6a 04                	push   $0x4
f0104ff2:	ff 75 10             	pushl  0x10(%ebp)
f0104ff5:	ff 75 0c             	pushl  0xc(%ebp)
f0104ff8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ffb:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0105001:	e8 65 e4 ff ff       	call   f010346b <user_mem_assert>
	cprintf("%.*s", len, s);
f0105006:	83 c4 0c             	add    $0xc,%esp
f0105009:	ff 75 0c             	pushl  0xc(%ebp)
f010500c:	ff 75 10             	pushl  0x10(%ebp)
f010500f:	68 d2 98 10 f0       	push   $0xf01098d2
f0105014:	e8 b7 ee ff ff       	call   f0103ed0 <cprintf>
f0105019:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f010501c:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f0105021:	89 d8                	mov    %ebx,%eax
f0105023:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105026:	5b                   	pop    %ebx
f0105027:	5e                   	pop    %esi
f0105028:	5f                   	pop    %edi
f0105029:	5d                   	pop    %ebp
f010502a:	c3                   	ret    
	return cons_getc();
f010502b:	e8 09 b6 ff ff       	call   f0100639 <cons_getc>
f0105030:	89 c3                	mov    %eax,%ebx
			break;
f0105032:	eb ed                	jmp    f0105021 <syscall+0x52>
	return curenv->env_id;
f0105034:	e8 b1 1b 00 00       	call   f0106bea <cpunum>
f0105039:	6b c0 74             	imul   $0x74,%eax,%eax
f010503c:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105042:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0105045:	eb da                	jmp    f0105021 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0105047:	83 ec 04             	sub    $0x4,%esp
f010504a:	6a 01                	push   $0x1
f010504c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010504f:	50                   	push   %eax
f0105050:	ff 75 0c             	pushl  0xc(%ebp)
f0105053:	e8 e5 e4 ff ff       	call   f010353d <envid2env>
f0105058:	89 c3                	mov    %eax,%ebx
f010505a:	83 c4 10             	add    $0x10,%esp
f010505d:	85 c0                	test   %eax,%eax
f010505f:	78 c0                	js     f0105021 <syscall+0x52>
	if (e == curenv)
f0105061:	e8 84 1b 00 00       	call   f0106bea <cpunum>
f0105066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105069:	6b c0 74             	imul   $0x74,%eax,%eax
f010506c:	39 90 28 10 58 f0    	cmp    %edx,-0xfa7efd8(%eax)
f0105072:	74 3d                	je     f01050b1 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0105074:	8b 5a 48             	mov    0x48(%edx),%ebx
f0105077:	e8 6e 1b 00 00       	call   f0106bea <cpunum>
f010507c:	83 ec 04             	sub    $0x4,%esp
f010507f:	53                   	push   %ebx
f0105080:	6b c0 74             	imul   $0x74,%eax,%eax
f0105083:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105089:	ff 70 48             	pushl  0x48(%eax)
f010508c:	68 f2 98 10 f0       	push   $0xf01098f2
f0105091:	e8 3a ee ff ff       	call   f0103ed0 <cprintf>
f0105096:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0105099:	83 ec 0c             	sub    $0xc,%esp
f010509c:	ff 75 e4             	pushl  -0x1c(%ebp)
f010509f:	e8 c5 ea ff ff       	call   f0103b69 <env_destroy>
f01050a4:	83 c4 10             	add    $0x10,%esp
	return 0;
f01050a7:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01050ac:	e9 70 ff ff ff       	jmp    f0105021 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01050b1:	e8 34 1b 00 00       	call   f0106bea <cpunum>
f01050b6:	83 ec 08             	sub    $0x8,%esp
f01050b9:	6b c0 74             	imul   $0x74,%eax,%eax
f01050bc:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01050c2:	ff 70 48             	pushl  0x48(%eax)
f01050c5:	68 d7 98 10 f0       	push   $0xf01098d7
f01050ca:	e8 01 ee ff ff       	call   f0103ed0 <cprintf>
f01050cf:	83 c4 10             	add    $0x10,%esp
f01050d2:	eb c5                	jmp    f0105099 <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f01050d4:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f01050db:	76 4a                	jbe    f0105127 <syscall+0x158>
	return (physaddr_t)kva - KERNBASE;
f01050dd:	8b 45 0c             	mov    0xc(%ebp),%eax
f01050e0:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01050e5:	c1 e8 0c             	shr    $0xc,%eax
f01050e8:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f01050ee:	73 4e                	jae    f010513e <syscall+0x16f>
	return &pages[PGNUM(pa)];
f01050f0:	8b 15 b0 0e 58 f0    	mov    0xf0580eb0,%edx
f01050f6:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f01050f9:	85 db                	test   %ebx,%ebx
f01050fb:	0f 84 81 07 00 00    	je     f0105882 <syscall+0x8b3>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f0105101:	e8 e4 1a 00 00       	call   f0106bea <cpunum>
f0105106:	6a 06                	push   $0x6
f0105108:	ff 75 10             	pushl  0x10(%ebp)
f010510b:	53                   	push   %ebx
f010510c:	6b c0 74             	imul   $0x74,%eax,%eax
f010510f:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105115:	ff 70 60             	pushl  0x60(%eax)
f0105118:	e8 f2 c4 ff ff       	call   f010160f <page_insert>
f010511d:	89 c3                	mov    %eax,%ebx
f010511f:	83 c4 10             	add    $0x10,%esp
f0105122:	e9 fa fe ff ff       	jmp    f0105021 <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0105127:	ff 75 0c             	pushl  0xc(%ebp)
f010512a:	68 d8 7c 10 f0       	push   $0xf0107cd8
f010512f:	68 af 01 00 00       	push   $0x1af
f0105134:	68 0a 99 10 f0       	push   $0xf010990a
f0105139:	e8 0b af ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f010513e:	83 ec 04             	sub    $0x4,%esp
f0105141:	68 90 85 10 f0       	push   $0xf0108590
f0105146:	6a 51                	push   $0x51
f0105148:	68 51 8e 10 f0       	push   $0xf0108e51
f010514d:	e8 f7 ae ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105152:	e8 93 1a 00 00       	call   f0106bea <cpunum>
	if(inc < PGSIZE){
f0105157:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f010515e:	77 1b                	ja     f010517b <syscall+0x1ac>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105160:	6b c0 74             	imul   $0x74,%eax,%eax
f0105163:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105169:	8b 40 7c             	mov    0x7c(%eax),%eax
f010516c:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f0105171:	03 45 0c             	add    0xc(%ebp),%eax
f0105174:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0105179:	76 7c                	jbe    f01051f7 <syscall+0x228>
	int i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f010517b:	e8 6a 1a 00 00       	call   f0106bea <cpunum>
f0105180:	6b c0 74             	imul   $0x74,%eax,%eax
f0105183:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105189:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010518c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f0105192:	e8 53 1a 00 00       	call   f0106bea <cpunum>
f0105197:	6b c0 74             	imul   $0x74,%eax,%eax
f010519a:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01051a0:	8b 40 7c             	mov    0x7c(%eax),%eax
f01051a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01051a6:	8d b4 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%esi
f01051ad:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01051b3:	39 de                	cmp    %ebx,%esi
f01051b5:	0f 8e 94 00 00 00    	jle    f010524f <syscall+0x280>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01051bb:	83 ec 0c             	sub    $0xc,%esp
f01051be:	6a 01                	push   $0x1
f01051c0:	e8 0e c1 ff ff       	call   f01012d3 <page_alloc>
f01051c5:	89 c7                	mov    %eax,%edi
		if(!page)
f01051c7:	83 c4 10             	add    $0x10,%esp
f01051ca:	85 c0                	test   %eax,%eax
f01051cc:	74 53                	je     f0105221 <syscall+0x252>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f01051ce:	e8 17 1a 00 00       	call   f0106bea <cpunum>
f01051d3:	6a 06                	push   $0x6
f01051d5:	53                   	push   %ebx
f01051d6:	57                   	push   %edi
f01051d7:	6b c0 74             	imul   $0x74,%eax,%eax
f01051da:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01051e0:	ff 70 60             	pushl  0x60(%eax)
f01051e3:	e8 27 c4 ff ff       	call   f010160f <page_insert>
		if(ret)
f01051e8:	83 c4 10             	add    $0x10,%esp
f01051eb:	85 c0                	test   %eax,%eax
f01051ed:	75 49                	jne    f0105238 <syscall+0x269>
	for(; i < end; i+=PGSIZE){
f01051ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01051f5:	eb bc                	jmp    f01051b3 <syscall+0x1e4>
			curenv->env_sbrk+=inc;
f01051f7:	e8 ee 19 00 00       	call   f0106bea <cpunum>
f01051fc:	6b c0 74             	imul   $0x74,%eax,%eax
f01051ff:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105208:	01 48 7c             	add    %ecx,0x7c(%eax)
			return curenv->env_sbrk;
f010520b:	e8 da 19 00 00       	call   f0106bea <cpunum>
f0105210:	6b c0 74             	imul   $0x74,%eax,%eax
f0105213:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105219:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010521c:	e9 00 fe ff ff       	jmp    f0105021 <syscall+0x52>
			panic("there is no page\n");
f0105221:	83 ec 04             	sub    $0x4,%esp
f0105224:	68 b4 91 10 f0       	push   $0xf01091b4
f0105229:	68 c4 01 00 00       	push   $0x1c4
f010522e:	68 0a 99 10 f0       	push   $0xf010990a
f0105233:	e8 11 ae ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f0105238:	83 ec 04             	sub    $0x4,%esp
f010523b:	68 d1 91 10 f0       	push   $0xf01091d1
f0105240:	68 c7 01 00 00       	push   $0x1c7
f0105245:	68 0a 99 10 f0       	push   $0xf010990a
f010524a:	e8 fa ad ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f010524f:	e8 96 19 00 00       	call   f0106bea <cpunum>
f0105254:	6b c0 74             	imul   $0x74,%eax,%eax
f0105257:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010525d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105260:	01 48 7c             	add    %ecx,0x7c(%eax)
	return curenv->env_sbrk;
f0105263:	e8 82 19 00 00       	call   f0106bea <cpunum>
f0105268:	6b c0 74             	imul   $0x74,%eax,%eax
f010526b:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105271:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0105274:	e9 a8 fd ff ff       	jmp    f0105021 <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f0105279:	83 ec 04             	sub    $0x4,%esp
f010527c:	68 30 99 10 f0       	push   $0xf0109930
f0105281:	68 20 02 00 00       	push   $0x220
f0105286:	68 0a 99 10 f0       	push   $0xf010990a
f010528b:	e8 b9 ad ff ff       	call   f0100049 <_panic>
	sched_yield();
f0105290:	e8 e9 fb ff ff       	call   f0104e7e <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105295:	e8 50 19 00 00       	call   f0106bea <cpunum>
f010529a:	83 ec 08             	sub    $0x8,%esp
f010529d:	6b c0 74             	imul   $0x74,%eax,%eax
f01052a0:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01052a6:	ff 70 48             	pushl  0x48(%eax)
f01052a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01052ac:	50                   	push   %eax
f01052ad:	e8 ce e3 ff ff       	call   f0103680 <env_alloc>
f01052b2:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01052b4:	83 c4 10             	add    $0x10,%esp
f01052b7:	85 c0                	test   %eax,%eax
f01052b9:	0f 88 62 fd ff ff    	js     f0105021 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f01052bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052c2:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f01052c9:	e8 1c 19 00 00       	call   f0106bea <cpunum>
f01052ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01052d1:	8b b0 28 10 58 f0    	mov    -0xfa7efd8(%eax),%esi
f01052d7:	b9 11 00 00 00       	mov    $0x11,%ecx
f01052dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01052df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01052e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052e4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01052eb:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01052ee:	e9 2e fd ff ff       	jmp    f0105021 <syscall+0x52>
	switch (status)
f01052f3:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01052f7:	74 06                	je     f01052ff <syscall+0x330>
f01052f9:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f01052fd:	75 54                	jne    f0105353 <syscall+0x384>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01052ff:	8b 45 10             	mov    0x10(%ebp),%eax
f0105302:	83 e8 02             	sub    $0x2,%eax
f0105305:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f010530a:	75 31                	jne    f010533d <syscall+0x36e>
	int ret = envid2env(envid, &e, 1);
f010530c:	83 ec 04             	sub    $0x4,%esp
f010530f:	6a 01                	push   $0x1
f0105311:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105314:	50                   	push   %eax
f0105315:	ff 75 0c             	pushl  0xc(%ebp)
f0105318:	e8 20 e2 ff ff       	call   f010353d <envid2env>
f010531d:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f010531f:	83 c4 10             	add    $0x10,%esp
f0105322:	85 c0                	test   %eax,%eax
f0105324:	0f 88 f7 fc ff ff    	js     f0105021 <syscall+0x52>
	e->env_status = status;
f010532a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010532d:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105330:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0105333:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105338:	e9 e4 fc ff ff       	jmp    f0105021 <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f010533d:	68 5c 99 10 f0       	push   $0xf010995c
f0105342:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0105347:	6a 7b                	push   $0x7b
f0105349:	68 0a 99 10 f0       	push   $0xf010990a
f010534e:	e8 f6 ac ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f0105353:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105358:	e9 c4 fc ff ff       	jmp    f0105021 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f010535d:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105364:	0f 87 cd 00 00 00    	ja     f0105437 <syscall+0x468>
f010536a:	8b 45 10             	mov    0x10(%ebp),%eax
f010536d:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105372:	8b 55 14             	mov    0x14(%ebp),%edx
f0105375:	83 e2 05             	and    $0x5,%edx
f0105378:	83 fa 05             	cmp    $0x5,%edx
f010537b:	0f 85 c0 00 00 00    	jne    f0105441 <syscall+0x472>
	if(perm & ~PTE_SYSCALL)
f0105381:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105384:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f010538a:	09 c3                	or     %eax,%ebx
f010538c:	0f 85 b9 00 00 00    	jne    f010544b <syscall+0x47c>
	int ret = envid2env(envid, &e, 1);
f0105392:	83 ec 04             	sub    $0x4,%esp
f0105395:	6a 01                	push   $0x1
f0105397:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010539a:	50                   	push   %eax
f010539b:	ff 75 0c             	pushl  0xc(%ebp)
f010539e:	e8 9a e1 ff ff       	call   f010353d <envid2env>
	if(ret < 0)
f01053a3:	83 c4 10             	add    $0x10,%esp
f01053a6:	85 c0                	test   %eax,%eax
f01053a8:	0f 88 a7 00 00 00    	js     f0105455 <syscall+0x486>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01053ae:	83 ec 0c             	sub    $0xc,%esp
f01053b1:	6a 01                	push   $0x1
f01053b3:	e8 1b bf ff ff       	call   f01012d3 <page_alloc>
f01053b8:	89 c6                	mov    %eax,%esi
	if(page == NULL)
f01053ba:	83 c4 10             	add    $0x10,%esp
f01053bd:	85 c0                	test   %eax,%eax
f01053bf:	0f 84 97 00 00 00    	je     f010545c <syscall+0x48d>
	return (pp - pages) << PGSHIFT;
f01053c5:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01053cb:	c1 f8 03             	sar    $0x3,%eax
f01053ce:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01053d1:	89 c2                	mov    %eax,%edx
f01053d3:	c1 ea 0c             	shr    $0xc,%edx
f01053d6:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01053dc:	73 47                	jae    f0105425 <syscall+0x456>
	memset(page2kva(page), 0, PGSIZE);
f01053de:	83 ec 04             	sub    $0x4,%esp
f01053e1:	68 00 10 00 00       	push   $0x1000
f01053e6:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01053e8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01053ed:	50                   	push   %eax
f01053ee:	e8 f0 11 00 00       	call   f01065e3 <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f01053f3:	ff 75 14             	pushl  0x14(%ebp)
f01053f6:	ff 75 10             	pushl  0x10(%ebp)
f01053f9:	56                   	push   %esi
f01053fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01053fd:	ff 70 60             	pushl  0x60(%eax)
f0105400:	e8 0a c2 ff ff       	call   f010160f <page_insert>
f0105405:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f0105407:	83 c4 20             	add    $0x20,%esp
f010540a:	85 c0                	test   %eax,%eax
f010540c:	0f 89 0f fc ff ff    	jns    f0105021 <syscall+0x52>
		page_free(page);
f0105412:	83 ec 0c             	sub    $0xc,%esp
f0105415:	56                   	push   %esi
f0105416:	e8 2a bf ff ff       	call   f0101345 <page_free>
f010541b:	83 c4 10             	add    $0x10,%esp
		return ret;
f010541e:	89 fb                	mov    %edi,%ebx
f0105420:	e9 fc fb ff ff       	jmp    f0105021 <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105425:	50                   	push   %eax
f0105426:	68 b4 7c 10 f0       	push   $0xf0107cb4
f010542b:	6a 58                	push   $0x58
f010542d:	68 51 8e 10 f0       	push   $0xf0108e51
f0105432:	e8 12 ac ff ff       	call   f0100049 <_panic>
		return -E_INVAL;
f0105437:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010543c:	e9 e0 fb ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f0105441:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105446:	e9 d6 fb ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f010544b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105450:	e9 cc fb ff ff       	jmp    f0105021 <syscall+0x52>
		return ret;
f0105455:	89 c3                	mov    %eax,%ebx
f0105457:	e9 c5 fb ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_NO_MEM;
f010545c:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105461:	e9 bb fb ff ff       	jmp    f0105021 <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105466:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105469:	83 e0 05             	and    $0x5,%eax
f010546c:	83 f8 05             	cmp    $0x5,%eax
f010546f:	0f 85 c0 00 00 00    	jne    f0105535 <syscall+0x566>
	if(perm & ~PTE_SYSCALL)
f0105475:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105478:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f010547d:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105484:	0f 87 b5 00 00 00    	ja     f010553f <syscall+0x570>
f010548a:	8b 55 10             	mov    0x10(%ebp),%edx
f010548d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f0105493:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010549a:	0f 87 a9 00 00 00    	ja     f0105549 <syscall+0x57a>
f01054a0:	09 d0                	or     %edx,%eax
f01054a2:	8b 55 18             	mov    0x18(%ebp),%edx
f01054a5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f01054ab:	09 d0                	or     %edx,%eax
f01054ad:	0f 85 a0 00 00 00    	jne    f0105553 <syscall+0x584>
	int ret = envid2env(srcenvid, &src_env, 1);
f01054b3:	83 ec 04             	sub    $0x4,%esp
f01054b6:	6a 01                	push   $0x1
f01054b8:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01054bb:	50                   	push   %eax
f01054bc:	ff 75 0c             	pushl  0xc(%ebp)
f01054bf:	e8 79 e0 ff ff       	call   f010353d <envid2env>
f01054c4:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01054c6:	83 c4 10             	add    $0x10,%esp
f01054c9:	85 c0                	test   %eax,%eax
f01054cb:	0f 88 50 fb ff ff    	js     f0105021 <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f01054d1:	83 ec 04             	sub    $0x4,%esp
f01054d4:	6a 01                	push   $0x1
f01054d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01054d9:	50                   	push   %eax
f01054da:	ff 75 14             	pushl  0x14(%ebp)
f01054dd:	e8 5b e0 ff ff       	call   f010353d <envid2env>
f01054e2:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01054e4:	83 c4 10             	add    $0x10,%esp
f01054e7:	85 c0                	test   %eax,%eax
f01054e9:	0f 88 32 fb ff ff    	js     f0105021 <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f01054ef:	83 ec 04             	sub    $0x4,%esp
f01054f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01054f5:	50                   	push   %eax
f01054f6:	ff 75 10             	pushl  0x10(%ebp)
f01054f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01054fc:	ff 70 60             	pushl  0x60(%eax)
f01054ff:	e8 2b c0 ff ff       	call   f010152f <page_lookup>
	if(src_page == NULL)
f0105504:	83 c4 10             	add    $0x10,%esp
f0105507:	85 c0                	test   %eax,%eax
f0105509:	74 52                	je     f010555d <syscall+0x58e>
	if(perm & PTE_W){
f010550b:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f010550f:	74 08                	je     f0105519 <syscall+0x54a>
		if((*pte_store & PTE_W) == 0)
f0105511:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105514:	f6 02 02             	testb  $0x2,(%edx)
f0105517:	74 4e                	je     f0105567 <syscall+0x598>
	return page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f0105519:	ff 75 1c             	pushl  0x1c(%ebp)
f010551c:	ff 75 18             	pushl  0x18(%ebp)
f010551f:	50                   	push   %eax
f0105520:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105523:	ff 70 60             	pushl  0x60(%eax)
f0105526:	e8 e4 c0 ff ff       	call   f010160f <page_insert>
f010552b:	89 c3                	mov    %eax,%ebx
f010552d:	83 c4 10             	add    $0x10,%esp
f0105530:	e9 ec fa ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f0105535:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010553a:	e9 e2 fa ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f010553f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105544:	e9 d8 fa ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f0105549:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010554e:	e9 ce fa ff ff       	jmp    f0105021 <syscall+0x52>
f0105553:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105558:	e9 c4 fa ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f010555d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105562:	e9 ba fa ff ff       	jmp    f0105021 <syscall+0x52>
			return -E_INVAL;
f0105567:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010556c:	e9 b0 fa ff ff       	jmp    f0105021 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105571:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105578:	77 45                	ja     f01055bf <syscall+0x5f0>
f010557a:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105581:	75 46                	jne    f01055c9 <syscall+0x5fa>
	int ret = envid2env(envid, &env, 1);
f0105583:	83 ec 04             	sub    $0x4,%esp
f0105586:	6a 01                	push   $0x1
f0105588:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010558b:	50                   	push   %eax
f010558c:	ff 75 0c             	pushl  0xc(%ebp)
f010558f:	e8 a9 df ff ff       	call   f010353d <envid2env>
f0105594:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105596:	83 c4 10             	add    $0x10,%esp
f0105599:	85 c0                	test   %eax,%eax
f010559b:	0f 88 80 fa ff ff    	js     f0105021 <syscall+0x52>
	page_remove(env->env_pgdir, va);
f01055a1:	83 ec 08             	sub    $0x8,%esp
f01055a4:	ff 75 10             	pushl  0x10(%ebp)
f01055a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055aa:	ff 70 60             	pushl  0x60(%eax)
f01055ad:	e8 17 c0 ff ff       	call   f01015c9 <page_remove>
f01055b2:	83 c4 10             	add    $0x10,%esp
	return 0;
f01055b5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01055ba:	e9 62 fa ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f01055bf:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01055c4:	e9 58 fa ff ff       	jmp    f0105021 <syscall+0x52>
f01055c9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01055ce:	e9 4e fa ff ff       	jmp    f0105021 <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f01055d3:	83 ec 04             	sub    $0x4,%esp
f01055d6:	6a 00                	push   $0x0
f01055d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01055db:	50                   	push   %eax
f01055dc:	ff 75 0c             	pushl  0xc(%ebp)
f01055df:	e8 59 df ff ff       	call   f010353d <envid2env>
f01055e4:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f01055e6:	83 c4 10             	add    $0x10,%esp
f01055e9:	85 c0                	test   %eax,%eax
f01055eb:	0f 88 30 fa ff ff    	js     f0105021 <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f01055f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01055f4:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01055f8:	0f 84 09 01 00 00    	je     f0105707 <syscall+0x738>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f01055fe:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0105605:	77 78                	ja     f010567f <syscall+0x6b0>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105607:	8b 45 18             	mov    0x18(%ebp),%eax
f010560a:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f010560d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105612:	83 f8 05             	cmp    $0x5,%eax
f0105615:	0f 85 06 fa ff ff    	jne    f0105021 <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f010561b:	8b 55 14             	mov    0x14(%ebp),%edx
f010561e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f0105624:	8b 45 18             	mov    0x18(%ebp),%eax
f0105627:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f010562c:	09 c2                	or     %eax,%edx
f010562e:	0f 85 ed f9 ff ff    	jne    f0105021 <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105634:	e8 b1 15 00 00       	call   f0106bea <cpunum>
f0105639:	83 ec 04             	sub    $0x4,%esp
f010563c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010563f:	52                   	push   %edx
f0105640:	ff 75 14             	pushl  0x14(%ebp)
f0105643:	6b c0 74             	imul   $0x74,%eax,%eax
f0105646:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010564c:	ff 70 60             	pushl  0x60(%eax)
f010564f:	e8 db be ff ff       	call   f010152f <page_lookup>
		if(!page)
f0105654:	83 c4 10             	add    $0x10,%esp
f0105657:	85 c0                	test   %eax,%eax
f0105659:	0f 84 9e 00 00 00    	je     f01056fd <syscall+0x72e>
		if((perm & PTE_W) && !(*pte & PTE_W))
f010565f:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105663:	74 0c                	je     f0105671 <syscall+0x6a2>
f0105665:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105668:	f6 02 02             	testb  $0x2,(%edx)
f010566b:	0f 84 b0 f9 ff ff    	je     f0105021 <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105671:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105674:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105677:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010567d:	76 52                	jbe    f01056d1 <syscall+0x702>
	dst_env->env_ipc_recving = 0;
f010567f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105682:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105686:	e8 5f 15 00 00       	call   f0106bea <cpunum>
f010568b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010568e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105691:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105697:	8b 40 48             	mov    0x48(%eax),%eax
f010569a:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_value = value;
f010569d:	8b 45 10             	mov    0x10(%ebp),%eax
f01056a0:	89 42 70             	mov    %eax,0x70(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f01056a3:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f01056aa:	b8 00 00 00 00       	mov    $0x0,%eax
f01056af:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f01056b3:	89 45 18             	mov    %eax,0x18(%ebp)
f01056b6:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f01056b9:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f01056c0:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f01056c7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01056cc:	e9 50 f9 ff ff       	jmp    f0105021 <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f01056d1:	ff 75 18             	pushl  0x18(%ebp)
f01056d4:	51                   	push   %ecx
f01056d5:	50                   	push   %eax
f01056d6:	ff 72 60             	pushl  0x60(%edx)
f01056d9:	e8 31 bf ff ff       	call   f010160f <page_insert>
f01056de:	89 c3                	mov    %eax,%ebx
			if(ret < 0){
f01056e0:	83 c4 10             	add    $0x10,%esp
f01056e3:	85 c0                	test   %eax,%eax
f01056e5:	79 98                	jns    f010567f <syscall+0x6b0>
				cprintf("2the ret in rece %d\n", ret);
f01056e7:	83 ec 08             	sub    $0x8,%esp
f01056ea:	50                   	push   %eax
f01056eb:	68 19 99 10 f0       	push   $0xf0109919
f01056f0:	e8 db e7 ff ff       	call   f0103ed0 <cprintf>
f01056f5:	83 c4 10             	add    $0x10,%esp
f01056f8:	e9 24 f9 ff ff       	jmp    f0105021 <syscall+0x52>
			return -E_INVAL;		
f01056fd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105702:	e9 1a f9 ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_IPC_NOT_RECV;
f0105707:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f010570c:	e9 10 f9 ff ff       	jmp    f0105021 <syscall+0x52>
	if(dstva < (void *)UTOP){
f0105711:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105718:	77 13                	ja     f010572d <syscall+0x75e>
		if((uint32_t)dstva % PGSIZE != 0)
f010571a:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0105721:	74 0a                	je     f010572d <syscall+0x75e>
			ret = sys_ipc_recv((void *)a1);
f0105723:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f0105728:	e9 f4 f8 ff ff       	jmp    f0105021 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f010572d:	e8 b8 14 00 00       	call   f0106bea <cpunum>
f0105732:	6b c0 74             	imul   $0x74,%eax,%eax
f0105735:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010573b:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f010573f:	e8 a6 14 00 00       	call   f0106bea <cpunum>
f0105744:	6b c0 74             	imul   $0x74,%eax,%eax
f0105747:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010574d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105750:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105753:	e8 92 14 00 00       	call   f0106bea <cpunum>
f0105758:	6b c0 74             	imul   $0x74,%eax,%eax
f010575b:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105761:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105768:	e8 11 f7 ff ff       	call   f0104e7e <sched_yield>
	int ret = envid2env(envid, &e, 1);
f010576d:	83 ec 04             	sub    $0x4,%esp
f0105770:	6a 01                	push   $0x1
f0105772:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105775:	50                   	push   %eax
f0105776:	ff 75 0c             	pushl  0xc(%ebp)
f0105779:	e8 bf dd ff ff       	call   f010353d <envid2env>
f010577e:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105780:	83 c4 10             	add    $0x10,%esp
f0105783:	85 c0                	test   %eax,%eax
f0105785:	0f 88 96 f8 ff ff    	js     f0105021 <syscall+0x52>
	e->env_pgfault_upcall = func;
f010578b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010578e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105791:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0105794:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105799:	e9 83 f8 ff ff       	jmp    f0105021 <syscall+0x52>
	r = envid2env(envid, &e, 0);
f010579e:	83 ec 04             	sub    $0x4,%esp
f01057a1:	6a 00                	push   $0x0
f01057a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01057a6:	50                   	push   %eax
f01057a7:	ff 75 0c             	pushl  0xc(%ebp)
f01057aa:	e8 8e dd ff ff       	call   f010353d <envid2env>
f01057af:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f01057b1:	83 c4 10             	add    $0x10,%esp
f01057b4:	85 c0                	test   %eax,%eax
f01057b6:	0f 88 65 f8 ff ff    	js     f0105021 <syscall+0x52>
	e->env_tf = *tf;
f01057bc:	b9 11 00 00 00       	mov    $0x11,%ecx
f01057c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01057c4:	8b 75 10             	mov    0x10(%ebp),%esi
f01057c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f01057c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01057cc:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f01057d1:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f01057d8:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01057dd:	e9 3f f8 ff ff       	jmp    f0105021 <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f01057e2:	83 ec 04             	sub    $0x4,%esp
f01057e5:	6a 00                	push   $0x0
f01057e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01057ea:	50                   	push   %eax
f01057eb:	ff 75 0c             	pushl  0xc(%ebp)
f01057ee:	e8 4a dd ff ff       	call   f010353d <envid2env>
f01057f3:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01057f5:	83 c4 10             	add    $0x10,%esp
f01057f8:	85 c0                	test   %eax,%eax
f01057fa:	0f 88 21 f8 ff ff    	js     f0105021 <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f0105800:	83 ec 04             	sub    $0x4,%esp
f0105803:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105806:	50                   	push   %eax
f0105807:	ff 75 10             	pushl  0x10(%ebp)
f010580a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010580d:	ff 70 60             	pushl  0x60(%eax)
f0105810:	e8 1a bd ff ff       	call   f010152f <page_lookup>
	if(page == NULL)
f0105815:	83 c4 10             	add    $0x10,%esp
f0105818:	85 c0                	test   %eax,%eax
f010581a:	74 16                	je     f0105832 <syscall+0x863>
	*pte_store |= PTE_A;
f010581c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010581f:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f0105822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105825:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f0105828:	bb 00 00 00 00       	mov    $0x0,%ebx
f010582d:	e9 ef f7 ff ff       	jmp    f0105021 <syscall+0x52>
		return -E_INVAL;
f0105832:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105837:	e9 e5 f7 ff ff       	jmp    f0105021 <syscall+0x52>
	return time_msec();
f010583c:	e8 ab 21 00 00       	call   f01079ec <time_msec>
f0105841:	89 c3                	mov    %eax,%ebx
			break;
f0105843:	e9 d9 f7 ff ff       	jmp    f0105021 <syscall+0x52>
			ret = sys_net_send((void *)a1, (uint32_t)a2);
f0105848:	83 ec 08             	sub    $0x8,%esp
f010584b:	ff 75 10             	pushl  0x10(%ebp)
f010584e:	ff 75 0c             	pushl  0xc(%ebp)
f0105851:	e8 e0 f6 ff ff       	call   f0104f36 <sys_net_send>
f0105856:	89 c3                	mov    %eax,%ebx
			break;
f0105858:	83 c4 10             	add    $0x10,%esp
f010585b:	e9 c1 f7 ff ff       	jmp    f0105021 <syscall+0x52>
			ret = sys_net_recv((void *)a1, (uint32_t)a2);
f0105860:	83 ec 08             	sub    $0x8,%esp
f0105863:	ff 75 10             	pushl  0x10(%ebp)
f0105866:	ff 75 0c             	pushl  0xc(%ebp)
f0105869:	e8 23 f7 ff ff       	call   f0104f91 <sys_net_recv>
f010586e:	89 c3                	mov    %eax,%ebx
			break;
f0105870:	83 c4 10             	add    $0x10,%esp
f0105873:	e9 a9 f7 ff ff       	jmp    f0105021 <syscall+0x52>
			ret = -E_INVAL;
f0105878:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010587d:	e9 9f f7 ff ff       	jmp    f0105021 <syscall+0x52>
        return E_INVAL;
f0105882:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105887:	e9 95 f7 ff ff       	jmp    f0105021 <syscall+0x52>

f010588c <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010588c:	55                   	push   %ebp
f010588d:	89 e5                	mov    %esp,%ebp
f010588f:	57                   	push   %edi
f0105890:	56                   	push   %esi
f0105891:	53                   	push   %ebx
f0105892:	83 ec 14             	sub    $0x14,%esp
f0105895:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105898:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010589b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f010589e:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f01058a1:	8b 1a                	mov    (%edx),%ebx
f01058a3:	8b 01                	mov    (%ecx),%eax
f01058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01058a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f01058af:	eb 23                	jmp    f01058d4 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f01058b1:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01058b4:	eb 1e                	jmp    f01058d4 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01058b6:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01058b9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01058bc:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01058c0:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01058c3:	73 41                	jae    f0105906 <stab_binsearch+0x7a>
			*region_left = m;
f01058c5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01058c8:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01058ca:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01058cd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01058d4:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01058d7:	7f 5a                	jg     f0105933 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f01058d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01058dc:	01 d8                	add    %ebx,%eax
f01058de:	89 c7                	mov    %eax,%edi
f01058e0:	c1 ef 1f             	shr    $0x1f,%edi
f01058e3:	01 c7                	add    %eax,%edi
f01058e5:	d1 ff                	sar    %edi
f01058e7:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f01058ea:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01058ed:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01058f1:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f01058f3:	39 c3                	cmp    %eax,%ebx
f01058f5:	7f ba                	jg     f01058b1 <stab_binsearch+0x25>
f01058f7:	0f b6 0a             	movzbl (%edx),%ecx
f01058fa:	83 ea 0c             	sub    $0xc,%edx
f01058fd:	39 f1                	cmp    %esi,%ecx
f01058ff:	74 b5                	je     f01058b6 <stab_binsearch+0x2a>
			m--;
f0105901:	83 e8 01             	sub    $0x1,%eax
f0105904:	eb ed                	jmp    f01058f3 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0105906:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105909:	76 14                	jbe    f010591f <stab_binsearch+0x93>
			*region_right = m - 1;
f010590b:	83 e8 01             	sub    $0x1,%eax
f010590e:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105911:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105914:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0105916:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010591d:	eb b5                	jmp    f01058d4 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f010591f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105922:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0105924:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105928:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f010592a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105931:	eb a1                	jmp    f01058d4 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105933:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105937:	75 15                	jne    f010594e <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0105939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010593c:	8b 00                	mov    (%eax),%eax
f010593e:	83 e8 01             	sub    $0x1,%eax
f0105941:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105944:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105946:	83 c4 14             	add    $0x14,%esp
f0105949:	5b                   	pop    %ebx
f010594a:	5e                   	pop    %esi
f010594b:	5f                   	pop    %edi
f010594c:	5d                   	pop    %ebp
f010594d:	c3                   	ret    
		for (l = *region_right;
f010594e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105951:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105953:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105956:	8b 0f                	mov    (%edi),%ecx
f0105958:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010595b:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010595e:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105962:	eb 03                	jmp    f0105967 <stab_binsearch+0xdb>
		     l--)
f0105964:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105967:	39 c1                	cmp    %eax,%ecx
f0105969:	7d 0a                	jge    f0105975 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f010596b:	0f b6 1a             	movzbl (%edx),%ebx
f010596e:	83 ea 0c             	sub    $0xc,%edx
f0105971:	39 f3                	cmp    %esi,%ebx
f0105973:	75 ef                	jne    f0105964 <stab_binsearch+0xd8>
		*region_left = l;
f0105975:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105978:	89 06                	mov    %eax,(%esi)
}
f010597a:	eb ca                	jmp    f0105946 <stab_binsearch+0xba>

f010597c <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010597c:	55                   	push   %ebp
f010597d:	89 e5                	mov    %esp,%ebp
f010597f:	57                   	push   %edi
f0105980:	56                   	push   %esi
f0105981:	53                   	push   %ebx
f0105982:	83 ec 4c             	sub    $0x4c,%esp
f0105985:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105988:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f010598b:	c7 03 e8 99 10 f0    	movl   $0xf01099e8,(%ebx)
	info->eip_line = 0;
f0105991:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105998:	c7 43 08 e8 99 10 f0 	movl   $0xf01099e8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f010599f:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f01059a6:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f01059a9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01059b0:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f01059b6:	0f 86 23 01 00 00    	jbe    f0105adf <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01059bc:	c7 45 b8 2d e7 11 f0 	movl   $0xf011e72d,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f01059c3:	c7 45 b4 c1 9c 11 f0 	movl   $0xf0119cc1,-0x4c(%ebp)
		stab_end = __STAB_END__;
f01059ca:	be c0 9c 11 f0       	mov    $0xf0119cc0,%esi
		stabs = __STAB_BEGIN__;
f01059cf:	c7 45 bc d0 a2 10 f0 	movl   $0xf010a2d0,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01059d6:	8b 45 b8             	mov    -0x48(%ebp),%eax
f01059d9:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f01059dc:	0f 83 59 02 00 00    	jae    f0105c3b <debuginfo_eip+0x2bf>
f01059e2:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01059e6:	0f 85 56 02 00 00    	jne    f0105c42 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01059ec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01059f3:	2b 75 bc             	sub    -0x44(%ebp),%esi
f01059f6:	c1 fe 02             	sar    $0x2,%esi
f01059f9:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f01059ff:	83 e8 01             	sub    $0x1,%eax
f0105a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105a05:	83 ec 08             	sub    $0x8,%esp
f0105a08:	57                   	push   %edi
f0105a09:	6a 64                	push   $0x64
f0105a0b:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0105a0e:	89 d1                	mov    %edx,%ecx
f0105a10:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105a13:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105a16:	89 f0                	mov    %esi,%eax
f0105a18:	e8 6f fe ff ff       	call   f010588c <stab_binsearch>
	if (lfile == 0)
f0105a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a20:	83 c4 10             	add    $0x10,%esp
f0105a23:	85 c0                	test   %eax,%eax
f0105a25:	0f 84 1e 02 00 00    	je     f0105c49 <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105a34:	83 ec 08             	sub    $0x8,%esp
f0105a37:	57                   	push   %edi
f0105a38:	6a 24                	push   $0x24
f0105a3a:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105a3d:	89 d1                	mov    %edx,%ecx
f0105a3f:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105a42:	89 f0                	mov    %esi,%eax
f0105a44:	e8 43 fe ff ff       	call   f010588c <stab_binsearch>

	if (lfun <= rfun) {
f0105a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105a4c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105a4f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105a52:	83 c4 10             	add    $0x10,%esp
f0105a55:	39 c8                	cmp    %ecx,%eax
f0105a57:	0f 8f 26 01 00 00    	jg     f0105b83 <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105a5d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105a60:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f0105a63:	8b 11                	mov    (%ecx),%edx
f0105a65:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0105a68:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105a6b:	39 f2                	cmp    %esi,%edx
f0105a6d:	73 06                	jae    f0105a75 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105a6f:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105a72:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105a75:	8b 51 08             	mov    0x8(%ecx),%edx
f0105a78:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105a7b:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105a80:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105a83:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105a86:	83 ec 08             	sub    $0x8,%esp
f0105a89:	6a 3a                	push   $0x3a
f0105a8b:	ff 73 08             	pushl  0x8(%ebx)
f0105a8e:	e8 34 0b 00 00       	call   f01065c7 <strfind>
f0105a93:	2b 43 08             	sub    0x8(%ebx),%eax
f0105a96:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105a99:	83 c4 08             	add    $0x8,%esp
f0105a9c:	57                   	push   %edi
f0105a9d:	6a 44                	push   $0x44
f0105a9f:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105aa2:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105aa5:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105aa8:	89 f0                	mov    %esi,%eax
f0105aaa:	e8 dd fd ff ff       	call   f010588c <stab_binsearch>
	if(lline <= rline){
f0105aaf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105ab2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105ab5:	83 c4 10             	add    $0x10,%esp
f0105ab8:	39 c2                	cmp    %eax,%edx
f0105aba:	0f 8f 90 01 00 00    	jg     f0105c50 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f0105ac0:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105ac3:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105ac7:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105aca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105acd:	89 d0                	mov    %edx,%eax
f0105acf:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105ad2:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105ad6:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0105ada:	e9 c2 00 00 00       	jmp    f0105ba1 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f0105adf:	e8 06 11 00 00       	call   f0106bea <cpunum>
f0105ae4:	6a 06                	push   $0x6
f0105ae6:	6a 10                	push   $0x10
f0105ae8:	68 00 00 20 00       	push   $0x200000
f0105aed:	6b c0 74             	imul   $0x74,%eax,%eax
f0105af0:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0105af6:	e8 c8 d8 ff ff       	call   f01033c3 <user_mem_check>
f0105afb:	83 c4 10             	add    $0x10,%esp
f0105afe:	85 c0                	test   %eax,%eax
f0105b00:	0f 88 27 01 00 00    	js     f0105c2d <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f0105b06:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105b0c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105b0f:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105b15:	a1 08 00 20 00       	mov    0x200008,%eax
f0105b1a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105b1d:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105b23:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f0105b26:	e8 bf 10 00 00       	call   f0106bea <cpunum>
f0105b2b:	6a 06                	push   $0x6
f0105b2d:	89 f2                	mov    %esi,%edx
f0105b2f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105b32:	29 ca                	sub    %ecx,%edx
f0105b34:	52                   	push   %edx
f0105b35:	51                   	push   %ecx
f0105b36:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b39:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0105b3f:	e8 7f d8 ff ff       	call   f01033c3 <user_mem_check>
f0105b44:	83 c4 10             	add    $0x10,%esp
f0105b47:	85 c0                	test   %eax,%eax
f0105b49:	0f 88 e5 00 00 00    	js     f0105c34 <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105b4f:	e8 96 10 00 00       	call   f0106bea <cpunum>
f0105b54:	6a 06                	push   $0x6
f0105b56:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105b59:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105b5c:	29 ca                	sub    %ecx,%edx
f0105b5e:	52                   	push   %edx
f0105b5f:	51                   	push   %ecx
f0105b60:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b63:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0105b69:	e8 55 d8 ff ff       	call   f01033c3 <user_mem_check>
f0105b6e:	83 c4 10             	add    $0x10,%esp
f0105b71:	85 c0                	test   %eax,%eax
f0105b73:	0f 89 5d fe ff ff    	jns    f01059d6 <debuginfo_eip+0x5a>
			return -1;
f0105b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b7e:	e9 d9 00 00 00       	jmp    f0105c5c <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105b83:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b89:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105b8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105b92:	e9 ef fe ff ff       	jmp    f0105a86 <debuginfo_eip+0x10a>
f0105b97:	83 e8 01             	sub    $0x1,%eax
f0105b9a:	83 ea 0c             	sub    $0xc,%edx
f0105b9d:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105ba1:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105ba4:	39 c7                	cmp    %eax,%edi
f0105ba6:	7f 45                	jg     f0105bed <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f0105ba8:	0f b6 0a             	movzbl (%edx),%ecx
f0105bab:	80 f9 84             	cmp    $0x84,%cl
f0105bae:	74 19                	je     f0105bc9 <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105bb0:	80 f9 64             	cmp    $0x64,%cl
f0105bb3:	75 e2                	jne    f0105b97 <debuginfo_eip+0x21b>
f0105bb5:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105bb9:	74 dc                	je     f0105b97 <debuginfo_eip+0x21b>
f0105bbb:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105bbf:	74 11                	je     f0105bd2 <debuginfo_eip+0x256>
f0105bc1:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105bc4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105bc7:	eb 09                	jmp    f0105bd2 <debuginfo_eip+0x256>
f0105bc9:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105bcd:	74 03                	je     f0105bd2 <debuginfo_eip+0x256>
f0105bcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105bd2:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105bd5:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105bd8:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105bdb:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105bde:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105be1:	29 f8                	sub    %edi,%eax
f0105be3:	39 c2                	cmp    %eax,%edx
f0105be5:	73 06                	jae    f0105bed <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105be7:	89 f8                	mov    %edi,%eax
f0105be9:	01 d0                	add    %edx,%eax
f0105beb:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105bed:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105bf0:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f0105bf3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105bf8:	39 f2                	cmp    %esi,%edx
f0105bfa:	7d 60                	jge    f0105c5c <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0105bfc:	83 c2 01             	add    $0x1,%edx
f0105bff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105c02:	89 d0                	mov    %edx,%eax
f0105c04:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105c07:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105c0a:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105c0e:	eb 04                	jmp    f0105c14 <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f0105c10:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105c14:	39 c6                	cmp    %eax,%esi
f0105c16:	7e 3f                	jle    f0105c57 <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105c18:	0f b6 0a             	movzbl (%edx),%ecx
f0105c1b:	83 c0 01             	add    $0x1,%eax
f0105c1e:	83 c2 0c             	add    $0xc,%edx
f0105c21:	80 f9 a0             	cmp    $0xa0,%cl
f0105c24:	74 ea                	je     f0105c10 <debuginfo_eip+0x294>
	return 0;
f0105c26:	b8 00 00 00 00       	mov    $0x0,%eax
f0105c2b:	eb 2f                	jmp    f0105c5c <debuginfo_eip+0x2e0>
			return -1;
f0105c2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c32:	eb 28                	jmp    f0105c5c <debuginfo_eip+0x2e0>
			return -1;
f0105c34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c39:	eb 21                	jmp    f0105c5c <debuginfo_eip+0x2e0>
		return -1;
f0105c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c40:	eb 1a                	jmp    f0105c5c <debuginfo_eip+0x2e0>
f0105c42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c47:	eb 13                	jmp    f0105c5c <debuginfo_eip+0x2e0>
		return -1;
f0105c49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c4e:	eb 0c                	jmp    f0105c5c <debuginfo_eip+0x2e0>
		return -1;
f0105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c55:	eb 05                	jmp    f0105c5c <debuginfo_eip+0x2e0>
	return 0;
f0105c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105c5f:	5b                   	pop    %ebx
f0105c60:	5e                   	pop    %esi
f0105c61:	5f                   	pop    %edi
f0105c62:	5d                   	pop    %ebp
f0105c63:	c3                   	ret    

f0105c64 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105c64:	55                   	push   %ebp
f0105c65:	89 e5                	mov    %esp,%ebp
f0105c67:	57                   	push   %edi
f0105c68:	56                   	push   %esi
f0105c69:	53                   	push   %ebx
f0105c6a:	83 ec 1c             	sub    $0x1c,%esp
f0105c6d:	89 c6                	mov    %eax,%esi
f0105c6f:	89 d7                	mov    %edx,%edi
f0105c71:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c74:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c77:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105c7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105c7d:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c80:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105c83:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105c87:	74 2c                	je     f0105cb5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f0105c89:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105c8c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105c93:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105c96:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105c99:	39 c2                	cmp    %eax,%edx
f0105c9b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105c9e:	73 43                	jae    f0105ce3 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105ca0:	83 eb 01             	sub    $0x1,%ebx
f0105ca3:	85 db                	test   %ebx,%ebx
f0105ca5:	7e 6c                	jle    f0105d13 <printnum+0xaf>
				putch(padc, putdat);
f0105ca7:	83 ec 08             	sub    $0x8,%esp
f0105caa:	57                   	push   %edi
f0105cab:	ff 75 18             	pushl  0x18(%ebp)
f0105cae:	ff d6                	call   *%esi
f0105cb0:	83 c4 10             	add    $0x10,%esp
f0105cb3:	eb eb                	jmp    f0105ca0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105cb5:	83 ec 0c             	sub    $0xc,%esp
f0105cb8:	6a 20                	push   $0x20
f0105cba:	6a 00                	push   $0x0
f0105cbc:	50                   	push   %eax
f0105cbd:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cc0:	ff 75 e0             	pushl  -0x20(%ebp)
f0105cc3:	89 fa                	mov    %edi,%edx
f0105cc5:	89 f0                	mov    %esi,%eax
f0105cc7:	e8 98 ff ff ff       	call   f0105c64 <printnum>
		while (--width > 0)
f0105ccc:	83 c4 20             	add    $0x20,%esp
f0105ccf:	83 eb 01             	sub    $0x1,%ebx
f0105cd2:	85 db                	test   %ebx,%ebx
f0105cd4:	7e 65                	jle    f0105d3b <printnum+0xd7>
			putch(padc, putdat);
f0105cd6:	83 ec 08             	sub    $0x8,%esp
f0105cd9:	57                   	push   %edi
f0105cda:	6a 20                	push   $0x20
f0105cdc:	ff d6                	call   *%esi
f0105cde:	83 c4 10             	add    $0x10,%esp
f0105ce1:	eb ec                	jmp    f0105ccf <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f0105ce3:	83 ec 0c             	sub    $0xc,%esp
f0105ce6:	ff 75 18             	pushl  0x18(%ebp)
f0105ce9:	83 eb 01             	sub    $0x1,%ebx
f0105cec:	53                   	push   %ebx
f0105ced:	50                   	push   %eax
f0105cee:	83 ec 08             	sub    $0x8,%esp
f0105cf1:	ff 75 dc             	pushl  -0x24(%ebp)
f0105cf4:	ff 75 d8             	pushl  -0x28(%ebp)
f0105cf7:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cfa:	ff 75 e0             	pushl  -0x20(%ebp)
f0105cfd:	e8 fe 1c 00 00       	call   f0107a00 <__udivdi3>
f0105d02:	83 c4 18             	add    $0x18,%esp
f0105d05:	52                   	push   %edx
f0105d06:	50                   	push   %eax
f0105d07:	89 fa                	mov    %edi,%edx
f0105d09:	89 f0                	mov    %esi,%eax
f0105d0b:	e8 54 ff ff ff       	call   f0105c64 <printnum>
f0105d10:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f0105d13:	83 ec 08             	sub    $0x8,%esp
f0105d16:	57                   	push   %edi
f0105d17:	83 ec 04             	sub    $0x4,%esp
f0105d1a:	ff 75 dc             	pushl  -0x24(%ebp)
f0105d1d:	ff 75 d8             	pushl  -0x28(%ebp)
f0105d20:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105d23:	ff 75 e0             	pushl  -0x20(%ebp)
f0105d26:	e8 e5 1d 00 00       	call   f0107b10 <__umoddi3>
f0105d2b:	83 c4 14             	add    $0x14,%esp
f0105d2e:	0f be 80 f2 99 10 f0 	movsbl -0xfef660e(%eax),%eax
f0105d35:	50                   	push   %eax
f0105d36:	ff d6                	call   *%esi
f0105d38:	83 c4 10             	add    $0x10,%esp
	}
}
f0105d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d3e:	5b                   	pop    %ebx
f0105d3f:	5e                   	pop    %esi
f0105d40:	5f                   	pop    %edi
f0105d41:	5d                   	pop    %ebp
f0105d42:	c3                   	ret    

f0105d43 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105d43:	55                   	push   %ebp
f0105d44:	89 e5                	mov    %esp,%ebp
f0105d46:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105d49:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105d4d:	8b 10                	mov    (%eax),%edx
f0105d4f:	3b 50 04             	cmp    0x4(%eax),%edx
f0105d52:	73 0a                	jae    f0105d5e <sprintputch+0x1b>
		*b->buf++ = ch;
f0105d54:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105d57:	89 08                	mov    %ecx,(%eax)
f0105d59:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d5c:	88 02                	mov    %al,(%edx)
}
f0105d5e:	5d                   	pop    %ebp
f0105d5f:	c3                   	ret    

f0105d60 <printfmt>:
{
f0105d60:	55                   	push   %ebp
f0105d61:	89 e5                	mov    %esp,%ebp
f0105d63:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105d66:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105d69:	50                   	push   %eax
f0105d6a:	ff 75 10             	pushl  0x10(%ebp)
f0105d6d:	ff 75 0c             	pushl  0xc(%ebp)
f0105d70:	ff 75 08             	pushl  0x8(%ebp)
f0105d73:	e8 05 00 00 00       	call   f0105d7d <vprintfmt>
}
f0105d78:	83 c4 10             	add    $0x10,%esp
f0105d7b:	c9                   	leave  
f0105d7c:	c3                   	ret    

f0105d7d <vprintfmt>:
{
f0105d7d:	55                   	push   %ebp
f0105d7e:	89 e5                	mov    %esp,%ebp
f0105d80:	57                   	push   %edi
f0105d81:	56                   	push   %esi
f0105d82:	53                   	push   %ebx
f0105d83:	83 ec 3c             	sub    $0x3c,%esp
f0105d86:	8b 75 08             	mov    0x8(%ebp),%esi
f0105d89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105d8c:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105d8f:	e9 32 04 00 00       	jmp    f01061c6 <vprintfmt+0x449>
		padc = ' ';
f0105d94:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f0105d98:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f0105d9f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0105da6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105dad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105db4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0105dbb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105dc0:	8d 47 01             	lea    0x1(%edi),%eax
f0105dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105dc6:	0f b6 17             	movzbl (%edi),%edx
f0105dc9:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105dcc:	3c 55                	cmp    $0x55,%al
f0105dce:	0f 87 12 05 00 00    	ja     f01062e6 <vprintfmt+0x569>
f0105dd4:	0f b6 c0             	movzbl %al,%eax
f0105dd7:	ff 24 85 e0 9b 10 f0 	jmp    *-0xfef6420(,%eax,4)
f0105dde:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105de1:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0105de5:	eb d9                	jmp    f0105dc0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105de7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105dea:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0105dee:	eb d0                	jmp    f0105dc0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105df0:	0f b6 d2             	movzbl %dl,%edx
f0105df3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105df6:	b8 00 00 00 00       	mov    $0x0,%eax
f0105dfb:	89 75 08             	mov    %esi,0x8(%ebp)
f0105dfe:	eb 03                	jmp    f0105e03 <vprintfmt+0x86>
f0105e00:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105e03:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105e06:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0105e0a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105e0d:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105e10:	83 fe 09             	cmp    $0x9,%esi
f0105e13:	76 eb                	jbe    f0105e00 <vprintfmt+0x83>
f0105e15:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e18:	8b 75 08             	mov    0x8(%ebp),%esi
f0105e1b:	eb 14                	jmp    f0105e31 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0105e1d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e20:	8b 00                	mov    (%eax),%eax
f0105e22:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e25:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e28:	8d 40 04             	lea    0x4(%eax),%eax
f0105e2b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e2e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105e31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105e35:	79 89                	jns    f0105dc0 <vprintfmt+0x43>
				width = precision, precision = -1;
f0105e37:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105e3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105e3d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105e44:	e9 77 ff ff ff       	jmp    f0105dc0 <vprintfmt+0x43>
f0105e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e4c:	85 c0                	test   %eax,%eax
f0105e4e:	0f 48 c1             	cmovs  %ecx,%eax
f0105e51:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e54:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105e57:	e9 64 ff ff ff       	jmp    f0105dc0 <vprintfmt+0x43>
f0105e5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105e5f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0105e66:	e9 55 ff ff ff       	jmp    f0105dc0 <vprintfmt+0x43>
			lflag++;
f0105e6b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105e72:	e9 49 ff ff ff       	jmp    f0105dc0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0105e77:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e7a:	8d 78 04             	lea    0x4(%eax),%edi
f0105e7d:	83 ec 08             	sub    $0x8,%esp
f0105e80:	53                   	push   %ebx
f0105e81:	ff 30                	pushl  (%eax)
f0105e83:	ff d6                	call   *%esi
			break;
f0105e85:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105e88:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105e8b:	e9 33 03 00 00       	jmp    f01061c3 <vprintfmt+0x446>
			err = va_arg(ap, int);
f0105e90:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e93:	8d 78 04             	lea    0x4(%eax),%edi
f0105e96:	8b 00                	mov    (%eax),%eax
f0105e98:	99                   	cltd   
f0105e99:	31 d0                	xor    %edx,%eax
f0105e9b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105e9d:	83 f8 11             	cmp    $0x11,%eax
f0105ea0:	7f 23                	jg     f0105ec5 <vprintfmt+0x148>
f0105ea2:	8b 14 85 40 9d 10 f0 	mov    -0xfef62c0(,%eax,4),%edx
f0105ea9:	85 d2                	test   %edx,%edx
f0105eab:	74 18                	je     f0105ec5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f0105ead:	52                   	push   %edx
f0105eae:	68 7d 8e 10 f0       	push   $0xf0108e7d
f0105eb3:	53                   	push   %ebx
f0105eb4:	56                   	push   %esi
f0105eb5:	e8 a6 fe ff ff       	call   f0105d60 <printfmt>
f0105eba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105ebd:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105ec0:	e9 fe 02 00 00       	jmp    f01061c3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f0105ec5:	50                   	push   %eax
f0105ec6:	68 0a 9a 10 f0       	push   $0xf0109a0a
f0105ecb:	53                   	push   %ebx
f0105ecc:	56                   	push   %esi
f0105ecd:	e8 8e fe ff ff       	call   f0105d60 <printfmt>
f0105ed2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105ed5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105ed8:	e9 e6 02 00 00       	jmp    f01061c3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f0105edd:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ee0:	83 c0 04             	add    $0x4,%eax
f0105ee3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105ee6:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ee9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f0105eeb:	85 c9                	test   %ecx,%ecx
f0105eed:	b8 03 9a 10 f0       	mov    $0xf0109a03,%eax
f0105ef2:	0f 45 c1             	cmovne %ecx,%eax
f0105ef5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0105ef8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105efc:	7e 06                	jle    f0105f04 <vprintfmt+0x187>
f0105efe:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0105f02:	75 0d                	jne    f0105f11 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f04:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105f07:	89 c7                	mov    %eax,%edi
f0105f09:	03 45 e0             	add    -0x20(%ebp),%eax
f0105f0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105f0f:	eb 53                	jmp    f0105f64 <vprintfmt+0x1e7>
f0105f11:	83 ec 08             	sub    $0x8,%esp
f0105f14:	ff 75 d8             	pushl  -0x28(%ebp)
f0105f17:	50                   	push   %eax
f0105f18:	e8 5f 05 00 00       	call   f010647c <strnlen>
f0105f1d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105f20:	29 c1                	sub    %eax,%ecx
f0105f22:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0105f25:	83 c4 10             	add    $0x10,%esp
f0105f28:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0105f2a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0105f2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f31:	eb 0f                	jmp    f0105f42 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0105f33:	83 ec 08             	sub    $0x8,%esp
f0105f36:	53                   	push   %ebx
f0105f37:	ff 75 e0             	pushl  -0x20(%ebp)
f0105f3a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f3c:	83 ef 01             	sub    $0x1,%edi
f0105f3f:	83 c4 10             	add    $0x10,%esp
f0105f42:	85 ff                	test   %edi,%edi
f0105f44:	7f ed                	jg     f0105f33 <vprintfmt+0x1b6>
f0105f46:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105f49:	85 c9                	test   %ecx,%ecx
f0105f4b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f50:	0f 49 c1             	cmovns %ecx,%eax
f0105f53:	29 c1                	sub    %eax,%ecx
f0105f55:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105f58:	eb aa                	jmp    f0105f04 <vprintfmt+0x187>
					putch(ch, putdat);
f0105f5a:	83 ec 08             	sub    $0x8,%esp
f0105f5d:	53                   	push   %ebx
f0105f5e:	52                   	push   %edx
f0105f5f:	ff d6                	call   *%esi
f0105f61:	83 c4 10             	add    $0x10,%esp
f0105f64:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105f67:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105f69:	83 c7 01             	add    $0x1,%edi
f0105f6c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105f70:	0f be d0             	movsbl %al,%edx
f0105f73:	85 d2                	test   %edx,%edx
f0105f75:	74 4b                	je     f0105fc2 <vprintfmt+0x245>
f0105f77:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105f7b:	78 06                	js     f0105f83 <vprintfmt+0x206>
f0105f7d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105f81:	78 1e                	js     f0105fa1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f0105f83:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0105f87:	74 d1                	je     f0105f5a <vprintfmt+0x1dd>
f0105f89:	0f be c0             	movsbl %al,%eax
f0105f8c:	83 e8 20             	sub    $0x20,%eax
f0105f8f:	83 f8 5e             	cmp    $0x5e,%eax
f0105f92:	76 c6                	jbe    f0105f5a <vprintfmt+0x1dd>
					putch('?', putdat);
f0105f94:	83 ec 08             	sub    $0x8,%esp
f0105f97:	53                   	push   %ebx
f0105f98:	6a 3f                	push   $0x3f
f0105f9a:	ff d6                	call   *%esi
f0105f9c:	83 c4 10             	add    $0x10,%esp
f0105f9f:	eb c3                	jmp    f0105f64 <vprintfmt+0x1e7>
f0105fa1:	89 cf                	mov    %ecx,%edi
f0105fa3:	eb 0e                	jmp    f0105fb3 <vprintfmt+0x236>
				putch(' ', putdat);
f0105fa5:	83 ec 08             	sub    $0x8,%esp
f0105fa8:	53                   	push   %ebx
f0105fa9:	6a 20                	push   $0x20
f0105fab:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105fad:	83 ef 01             	sub    $0x1,%edi
f0105fb0:	83 c4 10             	add    $0x10,%esp
f0105fb3:	85 ff                	test   %edi,%edi
f0105fb5:	7f ee                	jg     f0105fa5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f0105fb7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105fba:	89 45 14             	mov    %eax,0x14(%ebp)
f0105fbd:	e9 01 02 00 00       	jmp    f01061c3 <vprintfmt+0x446>
f0105fc2:	89 cf                	mov    %ecx,%edi
f0105fc4:	eb ed                	jmp    f0105fb3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f0105fc6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f0105fc9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f0105fd0:	e9 eb fd ff ff       	jmp    f0105dc0 <vprintfmt+0x43>
	if (lflag >= 2)
f0105fd5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105fd9:	7f 21                	jg     f0105ffc <vprintfmt+0x27f>
	else if (lflag)
f0105fdb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105fdf:	74 68                	je     f0106049 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f0105fe1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fe4:	8b 00                	mov    (%eax),%eax
f0105fe6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105fe9:	89 c1                	mov    %eax,%ecx
f0105feb:	c1 f9 1f             	sar    $0x1f,%ecx
f0105fee:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105ff1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ff4:	8d 40 04             	lea    0x4(%eax),%eax
f0105ff7:	89 45 14             	mov    %eax,0x14(%ebp)
f0105ffa:	eb 17                	jmp    f0106013 <vprintfmt+0x296>
		return va_arg(*ap, long long);
f0105ffc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fff:	8b 50 04             	mov    0x4(%eax),%edx
f0106002:	8b 00                	mov    (%eax),%eax
f0106004:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106007:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010600a:	8b 45 14             	mov    0x14(%ebp),%eax
f010600d:	8d 40 08             	lea    0x8(%eax),%eax
f0106010:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0106013:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106016:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106019:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010601c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f010601f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106023:	78 3f                	js     f0106064 <vprintfmt+0x2e7>
			base = 10;
f0106025:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f010602a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f010602e:	0f 84 71 01 00 00    	je     f01061a5 <vprintfmt+0x428>
				putch('+', putdat);
f0106034:	83 ec 08             	sub    $0x8,%esp
f0106037:	53                   	push   %ebx
f0106038:	6a 2b                	push   $0x2b
f010603a:	ff d6                	call   *%esi
f010603c:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010603f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106044:	e9 5c 01 00 00       	jmp    f01061a5 <vprintfmt+0x428>
		return va_arg(*ap, int);
f0106049:	8b 45 14             	mov    0x14(%ebp),%eax
f010604c:	8b 00                	mov    (%eax),%eax
f010604e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106051:	89 c1                	mov    %eax,%ecx
f0106053:	c1 f9 1f             	sar    $0x1f,%ecx
f0106056:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0106059:	8b 45 14             	mov    0x14(%ebp),%eax
f010605c:	8d 40 04             	lea    0x4(%eax),%eax
f010605f:	89 45 14             	mov    %eax,0x14(%ebp)
f0106062:	eb af                	jmp    f0106013 <vprintfmt+0x296>
				putch('-', putdat);
f0106064:	83 ec 08             	sub    $0x8,%esp
f0106067:	53                   	push   %ebx
f0106068:	6a 2d                	push   $0x2d
f010606a:	ff d6                	call   *%esi
				num = -(long long) num;
f010606c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010606f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106072:	f7 d8                	neg    %eax
f0106074:	83 d2 00             	adc    $0x0,%edx
f0106077:	f7 da                	neg    %edx
f0106079:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010607c:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010607f:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0106082:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106087:	e9 19 01 00 00       	jmp    f01061a5 <vprintfmt+0x428>
	if (lflag >= 2)
f010608c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0106090:	7f 29                	jg     f01060bb <vprintfmt+0x33e>
	else if (lflag)
f0106092:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106096:	74 44                	je     f01060dc <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f0106098:	8b 45 14             	mov    0x14(%ebp),%eax
f010609b:	8b 00                	mov    (%eax),%eax
f010609d:	ba 00 00 00 00       	mov    $0x0,%edx
f01060a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060a8:	8b 45 14             	mov    0x14(%ebp),%eax
f01060ab:	8d 40 04             	lea    0x4(%eax),%eax
f01060ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01060b1:	b8 0a 00 00 00       	mov    $0xa,%eax
f01060b6:	e9 ea 00 00 00       	jmp    f01061a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01060bb:	8b 45 14             	mov    0x14(%ebp),%eax
f01060be:	8b 50 04             	mov    0x4(%eax),%edx
f01060c1:	8b 00                	mov    (%eax),%eax
f01060c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060c9:	8b 45 14             	mov    0x14(%ebp),%eax
f01060cc:	8d 40 08             	lea    0x8(%eax),%eax
f01060cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01060d2:	b8 0a 00 00 00       	mov    $0xa,%eax
f01060d7:	e9 c9 00 00 00       	jmp    f01061a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f01060dc:	8b 45 14             	mov    0x14(%ebp),%eax
f01060df:	8b 00                	mov    (%eax),%eax
f01060e1:	ba 00 00 00 00       	mov    $0x0,%edx
f01060e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060ec:	8b 45 14             	mov    0x14(%ebp),%eax
f01060ef:	8d 40 04             	lea    0x4(%eax),%eax
f01060f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01060f5:	b8 0a 00 00 00       	mov    $0xa,%eax
f01060fa:	e9 a6 00 00 00       	jmp    f01061a5 <vprintfmt+0x428>
			putch('0', putdat);
f01060ff:	83 ec 08             	sub    $0x8,%esp
f0106102:	53                   	push   %ebx
f0106103:	6a 30                	push   $0x30
f0106105:	ff d6                	call   *%esi
	if (lflag >= 2)
f0106107:	83 c4 10             	add    $0x10,%esp
f010610a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f010610e:	7f 26                	jg     f0106136 <vprintfmt+0x3b9>
	else if (lflag)
f0106110:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106114:	74 3e                	je     f0106154 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f0106116:	8b 45 14             	mov    0x14(%ebp),%eax
f0106119:	8b 00                	mov    (%eax),%eax
f010611b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106120:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106123:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106126:	8b 45 14             	mov    0x14(%ebp),%eax
f0106129:	8d 40 04             	lea    0x4(%eax),%eax
f010612c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010612f:	b8 08 00 00 00       	mov    $0x8,%eax
f0106134:	eb 6f                	jmp    f01061a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106136:	8b 45 14             	mov    0x14(%ebp),%eax
f0106139:	8b 50 04             	mov    0x4(%eax),%edx
f010613c:	8b 00                	mov    (%eax),%eax
f010613e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106141:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106144:	8b 45 14             	mov    0x14(%ebp),%eax
f0106147:	8d 40 08             	lea    0x8(%eax),%eax
f010614a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010614d:	b8 08 00 00 00       	mov    $0x8,%eax
f0106152:	eb 51                	jmp    f01061a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106154:	8b 45 14             	mov    0x14(%ebp),%eax
f0106157:	8b 00                	mov    (%eax),%eax
f0106159:	ba 00 00 00 00       	mov    $0x0,%edx
f010615e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106161:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106164:	8b 45 14             	mov    0x14(%ebp),%eax
f0106167:	8d 40 04             	lea    0x4(%eax),%eax
f010616a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010616d:	b8 08 00 00 00       	mov    $0x8,%eax
f0106172:	eb 31                	jmp    f01061a5 <vprintfmt+0x428>
			putch('0', putdat);
f0106174:	83 ec 08             	sub    $0x8,%esp
f0106177:	53                   	push   %ebx
f0106178:	6a 30                	push   $0x30
f010617a:	ff d6                	call   *%esi
			putch('x', putdat);
f010617c:	83 c4 08             	add    $0x8,%esp
f010617f:	53                   	push   %ebx
f0106180:	6a 78                	push   $0x78
f0106182:	ff d6                	call   *%esi
			num = (unsigned long long)
f0106184:	8b 45 14             	mov    0x14(%ebp),%eax
f0106187:	8b 00                	mov    (%eax),%eax
f0106189:	ba 00 00 00 00       	mov    $0x0,%edx
f010618e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106191:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f0106194:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0106197:	8b 45 14             	mov    0x14(%ebp),%eax
f010619a:	8d 40 04             	lea    0x4(%eax),%eax
f010619d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061a0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01061a5:	83 ec 0c             	sub    $0xc,%esp
f01061a8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f01061ac:	52                   	push   %edx
f01061ad:	ff 75 e0             	pushl  -0x20(%ebp)
f01061b0:	50                   	push   %eax
f01061b1:	ff 75 dc             	pushl  -0x24(%ebp)
f01061b4:	ff 75 d8             	pushl  -0x28(%ebp)
f01061b7:	89 da                	mov    %ebx,%edx
f01061b9:	89 f0                	mov    %esi,%eax
f01061bb:	e8 a4 fa ff ff       	call   f0105c64 <printnum>
			break;
f01061c0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01061c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01061c6:	83 c7 01             	add    $0x1,%edi
f01061c9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01061cd:	83 f8 25             	cmp    $0x25,%eax
f01061d0:	0f 84 be fb ff ff    	je     f0105d94 <vprintfmt+0x17>
			if (ch == '\0')
f01061d6:	85 c0                	test   %eax,%eax
f01061d8:	0f 84 28 01 00 00    	je     f0106306 <vprintfmt+0x589>
			putch(ch, putdat);
f01061de:	83 ec 08             	sub    $0x8,%esp
f01061e1:	53                   	push   %ebx
f01061e2:	50                   	push   %eax
f01061e3:	ff d6                	call   *%esi
f01061e5:	83 c4 10             	add    $0x10,%esp
f01061e8:	eb dc                	jmp    f01061c6 <vprintfmt+0x449>
	if (lflag >= 2)
f01061ea:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01061ee:	7f 26                	jg     f0106216 <vprintfmt+0x499>
	else if (lflag)
f01061f0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01061f4:	74 41                	je     f0106237 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f01061f6:	8b 45 14             	mov    0x14(%ebp),%eax
f01061f9:	8b 00                	mov    (%eax),%eax
f01061fb:	ba 00 00 00 00       	mov    $0x0,%edx
f0106200:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106203:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106206:	8b 45 14             	mov    0x14(%ebp),%eax
f0106209:	8d 40 04             	lea    0x4(%eax),%eax
f010620c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010620f:	b8 10 00 00 00       	mov    $0x10,%eax
f0106214:	eb 8f                	jmp    f01061a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106216:	8b 45 14             	mov    0x14(%ebp),%eax
f0106219:	8b 50 04             	mov    0x4(%eax),%edx
f010621c:	8b 00                	mov    (%eax),%eax
f010621e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106221:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106224:	8b 45 14             	mov    0x14(%ebp),%eax
f0106227:	8d 40 08             	lea    0x8(%eax),%eax
f010622a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010622d:	b8 10 00 00 00       	mov    $0x10,%eax
f0106232:	e9 6e ff ff ff       	jmp    f01061a5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106237:	8b 45 14             	mov    0x14(%ebp),%eax
f010623a:	8b 00                	mov    (%eax),%eax
f010623c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106241:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106244:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106247:	8b 45 14             	mov    0x14(%ebp),%eax
f010624a:	8d 40 04             	lea    0x4(%eax),%eax
f010624d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106250:	b8 10 00 00 00       	mov    $0x10,%eax
f0106255:	e9 4b ff ff ff       	jmp    f01061a5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f010625a:	8b 45 14             	mov    0x14(%ebp),%eax
f010625d:	83 c0 04             	add    $0x4,%eax
f0106260:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106263:	8b 45 14             	mov    0x14(%ebp),%eax
f0106266:	8b 00                	mov    (%eax),%eax
f0106268:	85 c0                	test   %eax,%eax
f010626a:	74 14                	je     f0106280 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f010626c:	8b 13                	mov    (%ebx),%edx
f010626e:	83 fa 7f             	cmp    $0x7f,%edx
f0106271:	7f 37                	jg     f01062aa <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f0106273:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f0106275:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106278:	89 45 14             	mov    %eax,0x14(%ebp)
f010627b:	e9 43 ff ff ff       	jmp    f01061c3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f0106280:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106285:	bf 29 9b 10 f0       	mov    $0xf0109b29,%edi
							putch(ch, putdat);
f010628a:	83 ec 08             	sub    $0x8,%esp
f010628d:	53                   	push   %ebx
f010628e:	50                   	push   %eax
f010628f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0106291:	83 c7 01             	add    $0x1,%edi
f0106294:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f0106298:	83 c4 10             	add    $0x10,%esp
f010629b:	85 c0                	test   %eax,%eax
f010629d:	75 eb                	jne    f010628a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f010629f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01062a2:	89 45 14             	mov    %eax,0x14(%ebp)
f01062a5:	e9 19 ff ff ff       	jmp    f01061c3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f01062aa:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f01062ac:	b8 0a 00 00 00       	mov    $0xa,%eax
f01062b1:	bf 61 9b 10 f0       	mov    $0xf0109b61,%edi
							putch(ch, putdat);
f01062b6:	83 ec 08             	sub    $0x8,%esp
f01062b9:	53                   	push   %ebx
f01062ba:	50                   	push   %eax
f01062bb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f01062bd:	83 c7 01             	add    $0x1,%edi
f01062c0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f01062c4:	83 c4 10             	add    $0x10,%esp
f01062c7:	85 c0                	test   %eax,%eax
f01062c9:	75 eb                	jne    f01062b6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f01062cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01062ce:	89 45 14             	mov    %eax,0x14(%ebp)
f01062d1:	e9 ed fe ff ff       	jmp    f01061c3 <vprintfmt+0x446>
			putch(ch, putdat);
f01062d6:	83 ec 08             	sub    $0x8,%esp
f01062d9:	53                   	push   %ebx
f01062da:	6a 25                	push   $0x25
f01062dc:	ff d6                	call   *%esi
			break;
f01062de:	83 c4 10             	add    $0x10,%esp
f01062e1:	e9 dd fe ff ff       	jmp    f01061c3 <vprintfmt+0x446>
			putch('%', putdat);
f01062e6:	83 ec 08             	sub    $0x8,%esp
f01062e9:	53                   	push   %ebx
f01062ea:	6a 25                	push   $0x25
f01062ec:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01062ee:	83 c4 10             	add    $0x10,%esp
f01062f1:	89 f8                	mov    %edi,%eax
f01062f3:	eb 03                	jmp    f01062f8 <vprintfmt+0x57b>
f01062f5:	83 e8 01             	sub    $0x1,%eax
f01062f8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01062fc:	75 f7                	jne    f01062f5 <vprintfmt+0x578>
f01062fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106301:	e9 bd fe ff ff       	jmp    f01061c3 <vprintfmt+0x446>
}
f0106306:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106309:	5b                   	pop    %ebx
f010630a:	5e                   	pop    %esi
f010630b:	5f                   	pop    %edi
f010630c:	5d                   	pop    %ebp
f010630d:	c3                   	ret    

f010630e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010630e:	55                   	push   %ebp
f010630f:	89 e5                	mov    %esp,%ebp
f0106311:	83 ec 18             	sub    $0x18,%esp
f0106314:	8b 45 08             	mov    0x8(%ebp),%eax
f0106317:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f010631a:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010631d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106321:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0106324:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010632b:	85 c0                	test   %eax,%eax
f010632d:	74 26                	je     f0106355 <vsnprintf+0x47>
f010632f:	85 d2                	test   %edx,%edx
f0106331:	7e 22                	jle    f0106355 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106333:	ff 75 14             	pushl  0x14(%ebp)
f0106336:	ff 75 10             	pushl  0x10(%ebp)
f0106339:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010633c:	50                   	push   %eax
f010633d:	68 43 5d 10 f0       	push   $0xf0105d43
f0106342:	e8 36 fa ff ff       	call   f0105d7d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106347:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010634a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010634d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106350:	83 c4 10             	add    $0x10,%esp
}
f0106353:	c9                   	leave  
f0106354:	c3                   	ret    
		return -E_INVAL;
f0106355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010635a:	eb f7                	jmp    f0106353 <vsnprintf+0x45>

f010635c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010635c:	55                   	push   %ebp
f010635d:	89 e5                	mov    %esp,%ebp
f010635f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106362:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106365:	50                   	push   %eax
f0106366:	ff 75 10             	pushl  0x10(%ebp)
f0106369:	ff 75 0c             	pushl  0xc(%ebp)
f010636c:	ff 75 08             	pushl  0x8(%ebp)
f010636f:	e8 9a ff ff ff       	call   f010630e <vsnprintf>
	va_end(ap);

	return rc;
}
f0106374:	c9                   	leave  
f0106375:	c3                   	ret    

f0106376 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106376:	55                   	push   %ebp
f0106377:	89 e5                	mov    %esp,%ebp
f0106379:	57                   	push   %edi
f010637a:	56                   	push   %esi
f010637b:	53                   	push   %ebx
f010637c:	83 ec 0c             	sub    $0xc,%esp
f010637f:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106382:	85 c0                	test   %eax,%eax
f0106384:	74 11                	je     f0106397 <readline+0x21>
		cprintf("%s", prompt);
f0106386:	83 ec 08             	sub    $0x8,%esp
f0106389:	50                   	push   %eax
f010638a:	68 7d 8e 10 f0       	push   $0xf0108e7d
f010638f:	e8 3c db ff ff       	call   f0103ed0 <cprintf>
f0106394:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106397:	83 ec 0c             	sub    $0xc,%esp
f010639a:	6a 00                	push   $0x0
f010639c:	e8 48 a4 ff ff       	call   f01007e9 <iscons>
f01063a1:	89 c7                	mov    %eax,%edi
f01063a3:	83 c4 10             	add    $0x10,%esp
	i = 0;
f01063a6:	be 00 00 00 00       	mov    $0x0,%esi
f01063ab:	eb 57                	jmp    f0106404 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f01063ad:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f01063b2:	83 fb f8             	cmp    $0xfffffff8,%ebx
f01063b5:	75 08                	jne    f01063bf <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01063b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01063ba:	5b                   	pop    %ebx
f01063bb:	5e                   	pop    %esi
f01063bc:	5f                   	pop    %edi
f01063bd:	5d                   	pop    %ebp
f01063be:	c3                   	ret    
				cprintf("read error: %e\n", c);
f01063bf:	83 ec 08             	sub    $0x8,%esp
f01063c2:	53                   	push   %ebx
f01063c3:	68 88 9d 10 f0       	push   $0xf0109d88
f01063c8:	e8 03 db ff ff       	call   f0103ed0 <cprintf>
f01063cd:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01063d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01063d5:	eb e0                	jmp    f01063b7 <readline+0x41>
			if (echoing)
f01063d7:	85 ff                	test   %edi,%edi
f01063d9:	75 05                	jne    f01063e0 <readline+0x6a>
			i--;
f01063db:	83 ee 01             	sub    $0x1,%esi
f01063de:	eb 24                	jmp    f0106404 <readline+0x8e>
				cputchar('\b');
f01063e0:	83 ec 0c             	sub    $0xc,%esp
f01063e3:	6a 08                	push   $0x8
f01063e5:	e8 de a3 ff ff       	call   f01007c8 <cputchar>
f01063ea:	83 c4 10             	add    $0x10,%esp
f01063ed:	eb ec                	jmp    f01063db <readline+0x65>
				cputchar(c);
f01063ef:	83 ec 0c             	sub    $0xc,%esp
f01063f2:	53                   	push   %ebx
f01063f3:	e8 d0 a3 ff ff       	call   f01007c8 <cputchar>
f01063f8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01063fb:	88 9e 80 fa 57 f0    	mov    %bl,-0xfa80580(%esi)
f0106401:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f0106404:	e8 cf a3 ff ff       	call   f01007d8 <getchar>
f0106409:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010640b:	85 c0                	test   %eax,%eax
f010640d:	78 9e                	js     f01063ad <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f010640f:	83 f8 08             	cmp    $0x8,%eax
f0106412:	0f 94 c2             	sete   %dl
f0106415:	83 f8 7f             	cmp    $0x7f,%eax
f0106418:	0f 94 c0             	sete   %al
f010641b:	08 c2                	or     %al,%dl
f010641d:	74 04                	je     f0106423 <readline+0xad>
f010641f:	85 f6                	test   %esi,%esi
f0106421:	7f b4                	jg     f01063d7 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106423:	83 fb 1f             	cmp    $0x1f,%ebx
f0106426:	7e 0e                	jle    f0106436 <readline+0xc0>
f0106428:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f010642e:	7f 06                	jg     f0106436 <readline+0xc0>
			if (echoing)
f0106430:	85 ff                	test   %edi,%edi
f0106432:	74 c7                	je     f01063fb <readline+0x85>
f0106434:	eb b9                	jmp    f01063ef <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f0106436:	83 fb 0a             	cmp    $0xa,%ebx
f0106439:	74 05                	je     f0106440 <readline+0xca>
f010643b:	83 fb 0d             	cmp    $0xd,%ebx
f010643e:	75 c4                	jne    f0106404 <readline+0x8e>
			if (echoing)
f0106440:	85 ff                	test   %edi,%edi
f0106442:	75 11                	jne    f0106455 <readline+0xdf>
			buf[i] = 0;
f0106444:	c6 86 80 fa 57 f0 00 	movb   $0x0,-0xfa80580(%esi)
			return buf;
f010644b:	b8 80 fa 57 f0       	mov    $0xf057fa80,%eax
f0106450:	e9 62 ff ff ff       	jmp    f01063b7 <readline+0x41>
				cputchar('\n');
f0106455:	83 ec 0c             	sub    $0xc,%esp
f0106458:	6a 0a                	push   $0xa
f010645a:	e8 69 a3 ff ff       	call   f01007c8 <cputchar>
f010645f:	83 c4 10             	add    $0x10,%esp
f0106462:	eb e0                	jmp    f0106444 <readline+0xce>

f0106464 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106464:	55                   	push   %ebp
f0106465:	89 e5                	mov    %esp,%ebp
f0106467:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010646a:	b8 00 00 00 00       	mov    $0x0,%eax
f010646f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106473:	74 05                	je     f010647a <strlen+0x16>
		n++;
f0106475:	83 c0 01             	add    $0x1,%eax
f0106478:	eb f5                	jmp    f010646f <strlen+0xb>
	return n;
}
f010647a:	5d                   	pop    %ebp
f010647b:	c3                   	ret    

f010647c <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010647c:	55                   	push   %ebp
f010647d:	89 e5                	mov    %esp,%ebp
f010647f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106482:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106485:	ba 00 00 00 00       	mov    $0x0,%edx
f010648a:	39 c2                	cmp    %eax,%edx
f010648c:	74 0d                	je     f010649b <strnlen+0x1f>
f010648e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106492:	74 05                	je     f0106499 <strnlen+0x1d>
		n++;
f0106494:	83 c2 01             	add    $0x1,%edx
f0106497:	eb f1                	jmp    f010648a <strnlen+0xe>
f0106499:	89 d0                	mov    %edx,%eax
	return n;
}
f010649b:	5d                   	pop    %ebp
f010649c:	c3                   	ret    

f010649d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010649d:	55                   	push   %ebp
f010649e:	89 e5                	mov    %esp,%ebp
f01064a0:	53                   	push   %ebx
f01064a1:	8b 45 08             	mov    0x8(%ebp),%eax
f01064a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01064a7:	ba 00 00 00 00       	mov    $0x0,%edx
f01064ac:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f01064b0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f01064b3:	83 c2 01             	add    $0x1,%edx
f01064b6:	84 c9                	test   %cl,%cl
f01064b8:	75 f2                	jne    f01064ac <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f01064ba:	5b                   	pop    %ebx
f01064bb:	5d                   	pop    %ebp
f01064bc:	c3                   	ret    

f01064bd <strcat>:

char *
strcat(char *dst, const char *src)
{
f01064bd:	55                   	push   %ebp
f01064be:	89 e5                	mov    %esp,%ebp
f01064c0:	53                   	push   %ebx
f01064c1:	83 ec 10             	sub    $0x10,%esp
f01064c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01064c7:	53                   	push   %ebx
f01064c8:	e8 97 ff ff ff       	call   f0106464 <strlen>
f01064cd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01064d0:	ff 75 0c             	pushl  0xc(%ebp)
f01064d3:	01 d8                	add    %ebx,%eax
f01064d5:	50                   	push   %eax
f01064d6:	e8 c2 ff ff ff       	call   f010649d <strcpy>
	return dst;
}
f01064db:	89 d8                	mov    %ebx,%eax
f01064dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01064e0:	c9                   	leave  
f01064e1:	c3                   	ret    

f01064e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01064e2:	55                   	push   %ebp
f01064e3:	89 e5                	mov    %esp,%ebp
f01064e5:	56                   	push   %esi
f01064e6:	53                   	push   %ebx
f01064e7:	8b 45 08             	mov    0x8(%ebp),%eax
f01064ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01064ed:	89 c6                	mov    %eax,%esi
f01064ef:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01064f2:	89 c2                	mov    %eax,%edx
f01064f4:	39 f2                	cmp    %esi,%edx
f01064f6:	74 11                	je     f0106509 <strncpy+0x27>
		*dst++ = *src;
f01064f8:	83 c2 01             	add    $0x1,%edx
f01064fb:	0f b6 19             	movzbl (%ecx),%ebx
f01064fe:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0106501:	80 fb 01             	cmp    $0x1,%bl
f0106504:	83 d9 ff             	sbb    $0xffffffff,%ecx
f0106507:	eb eb                	jmp    f01064f4 <strncpy+0x12>
	}
	return ret;
}
f0106509:	5b                   	pop    %ebx
f010650a:	5e                   	pop    %esi
f010650b:	5d                   	pop    %ebp
f010650c:	c3                   	ret    

f010650d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f010650d:	55                   	push   %ebp
f010650e:	89 e5                	mov    %esp,%ebp
f0106510:	56                   	push   %esi
f0106511:	53                   	push   %ebx
f0106512:	8b 75 08             	mov    0x8(%ebp),%esi
f0106515:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106518:	8b 55 10             	mov    0x10(%ebp),%edx
f010651b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f010651d:	85 d2                	test   %edx,%edx
f010651f:	74 21                	je     f0106542 <strlcpy+0x35>
f0106521:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0106525:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0106527:	39 c2                	cmp    %eax,%edx
f0106529:	74 14                	je     f010653f <strlcpy+0x32>
f010652b:	0f b6 19             	movzbl (%ecx),%ebx
f010652e:	84 db                	test   %bl,%bl
f0106530:	74 0b                	je     f010653d <strlcpy+0x30>
			*dst++ = *src++;
f0106532:	83 c1 01             	add    $0x1,%ecx
f0106535:	83 c2 01             	add    $0x1,%edx
f0106538:	88 5a ff             	mov    %bl,-0x1(%edx)
f010653b:	eb ea                	jmp    f0106527 <strlcpy+0x1a>
f010653d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f010653f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106542:	29 f0                	sub    %esi,%eax
}
f0106544:	5b                   	pop    %ebx
f0106545:	5e                   	pop    %esi
f0106546:	5d                   	pop    %ebp
f0106547:	c3                   	ret    

f0106548 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0106548:	55                   	push   %ebp
f0106549:	89 e5                	mov    %esp,%ebp
f010654b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010654e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106551:	0f b6 01             	movzbl (%ecx),%eax
f0106554:	84 c0                	test   %al,%al
f0106556:	74 0c                	je     f0106564 <strcmp+0x1c>
f0106558:	3a 02                	cmp    (%edx),%al
f010655a:	75 08                	jne    f0106564 <strcmp+0x1c>
		p++, q++;
f010655c:	83 c1 01             	add    $0x1,%ecx
f010655f:	83 c2 01             	add    $0x1,%edx
f0106562:	eb ed                	jmp    f0106551 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106564:	0f b6 c0             	movzbl %al,%eax
f0106567:	0f b6 12             	movzbl (%edx),%edx
f010656a:	29 d0                	sub    %edx,%eax
}
f010656c:	5d                   	pop    %ebp
f010656d:	c3                   	ret    

f010656e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010656e:	55                   	push   %ebp
f010656f:	89 e5                	mov    %esp,%ebp
f0106571:	53                   	push   %ebx
f0106572:	8b 45 08             	mov    0x8(%ebp),%eax
f0106575:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106578:	89 c3                	mov    %eax,%ebx
f010657a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010657d:	eb 06                	jmp    f0106585 <strncmp+0x17>
		n--, p++, q++;
f010657f:	83 c0 01             	add    $0x1,%eax
f0106582:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0106585:	39 d8                	cmp    %ebx,%eax
f0106587:	74 16                	je     f010659f <strncmp+0x31>
f0106589:	0f b6 08             	movzbl (%eax),%ecx
f010658c:	84 c9                	test   %cl,%cl
f010658e:	74 04                	je     f0106594 <strncmp+0x26>
f0106590:	3a 0a                	cmp    (%edx),%cl
f0106592:	74 eb                	je     f010657f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106594:	0f b6 00             	movzbl (%eax),%eax
f0106597:	0f b6 12             	movzbl (%edx),%edx
f010659a:	29 d0                	sub    %edx,%eax
}
f010659c:	5b                   	pop    %ebx
f010659d:	5d                   	pop    %ebp
f010659e:	c3                   	ret    
		return 0;
f010659f:	b8 00 00 00 00       	mov    $0x0,%eax
f01065a4:	eb f6                	jmp    f010659c <strncmp+0x2e>

f01065a6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01065a6:	55                   	push   %ebp
f01065a7:	89 e5                	mov    %esp,%ebp
f01065a9:	8b 45 08             	mov    0x8(%ebp),%eax
f01065ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01065b0:	0f b6 10             	movzbl (%eax),%edx
f01065b3:	84 d2                	test   %dl,%dl
f01065b5:	74 09                	je     f01065c0 <strchr+0x1a>
		if (*s == c)
f01065b7:	38 ca                	cmp    %cl,%dl
f01065b9:	74 0a                	je     f01065c5 <strchr+0x1f>
	for (; *s; s++)
f01065bb:	83 c0 01             	add    $0x1,%eax
f01065be:	eb f0                	jmp    f01065b0 <strchr+0xa>
			return (char *) s;
	return 0;
f01065c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01065c5:	5d                   	pop    %ebp
f01065c6:	c3                   	ret    

f01065c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01065c7:	55                   	push   %ebp
f01065c8:	89 e5                	mov    %esp,%ebp
f01065ca:	8b 45 08             	mov    0x8(%ebp),%eax
f01065cd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01065d1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01065d4:	38 ca                	cmp    %cl,%dl
f01065d6:	74 09                	je     f01065e1 <strfind+0x1a>
f01065d8:	84 d2                	test   %dl,%dl
f01065da:	74 05                	je     f01065e1 <strfind+0x1a>
	for (; *s; s++)
f01065dc:	83 c0 01             	add    $0x1,%eax
f01065df:	eb f0                	jmp    f01065d1 <strfind+0xa>
			break;
	return (char *) s;
}
f01065e1:	5d                   	pop    %ebp
f01065e2:	c3                   	ret    

f01065e3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01065e3:	55                   	push   %ebp
f01065e4:	89 e5                	mov    %esp,%ebp
f01065e6:	57                   	push   %edi
f01065e7:	56                   	push   %esi
f01065e8:	53                   	push   %ebx
f01065e9:	8b 7d 08             	mov    0x8(%ebp),%edi
f01065ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01065ef:	85 c9                	test   %ecx,%ecx
f01065f1:	74 31                	je     f0106624 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01065f3:	89 f8                	mov    %edi,%eax
f01065f5:	09 c8                	or     %ecx,%eax
f01065f7:	a8 03                	test   $0x3,%al
f01065f9:	75 23                	jne    f010661e <memset+0x3b>
		c &= 0xFF;
f01065fb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01065ff:	89 d3                	mov    %edx,%ebx
f0106601:	c1 e3 08             	shl    $0x8,%ebx
f0106604:	89 d0                	mov    %edx,%eax
f0106606:	c1 e0 18             	shl    $0x18,%eax
f0106609:	89 d6                	mov    %edx,%esi
f010660b:	c1 e6 10             	shl    $0x10,%esi
f010660e:	09 f0                	or     %esi,%eax
f0106610:	09 c2                	or     %eax,%edx
f0106612:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0106614:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0106617:	89 d0                	mov    %edx,%eax
f0106619:	fc                   	cld    
f010661a:	f3 ab                	rep stos %eax,%es:(%edi)
f010661c:	eb 06                	jmp    f0106624 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010661e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106621:	fc                   	cld    
f0106622:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0106624:	89 f8                	mov    %edi,%eax
f0106626:	5b                   	pop    %ebx
f0106627:	5e                   	pop    %esi
f0106628:	5f                   	pop    %edi
f0106629:	5d                   	pop    %ebp
f010662a:	c3                   	ret    

f010662b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010662b:	55                   	push   %ebp
f010662c:	89 e5                	mov    %esp,%ebp
f010662e:	57                   	push   %edi
f010662f:	56                   	push   %esi
f0106630:	8b 45 08             	mov    0x8(%ebp),%eax
f0106633:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106636:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106639:	39 c6                	cmp    %eax,%esi
f010663b:	73 32                	jae    f010666f <memmove+0x44>
f010663d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106640:	39 c2                	cmp    %eax,%edx
f0106642:	76 2b                	jbe    f010666f <memmove+0x44>
		s += n;
		d += n;
f0106644:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106647:	89 fe                	mov    %edi,%esi
f0106649:	09 ce                	or     %ecx,%esi
f010664b:	09 d6                	or     %edx,%esi
f010664d:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106653:	75 0e                	jne    f0106663 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106655:	83 ef 04             	sub    $0x4,%edi
f0106658:	8d 72 fc             	lea    -0x4(%edx),%esi
f010665b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010665e:	fd                   	std    
f010665f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106661:	eb 09                	jmp    f010666c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106663:	83 ef 01             	sub    $0x1,%edi
f0106666:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0106669:	fd                   	std    
f010666a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010666c:	fc                   	cld    
f010666d:	eb 1a                	jmp    f0106689 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010666f:	89 c2                	mov    %eax,%edx
f0106671:	09 ca                	or     %ecx,%edx
f0106673:	09 f2                	or     %esi,%edx
f0106675:	f6 c2 03             	test   $0x3,%dl
f0106678:	75 0a                	jne    f0106684 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010667a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010667d:	89 c7                	mov    %eax,%edi
f010667f:	fc                   	cld    
f0106680:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106682:	eb 05                	jmp    f0106689 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0106684:	89 c7                	mov    %eax,%edi
f0106686:	fc                   	cld    
f0106687:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106689:	5e                   	pop    %esi
f010668a:	5f                   	pop    %edi
f010668b:	5d                   	pop    %ebp
f010668c:	c3                   	ret    

f010668d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010668d:	55                   	push   %ebp
f010668e:	89 e5                	mov    %esp,%ebp
f0106690:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106693:	ff 75 10             	pushl  0x10(%ebp)
f0106696:	ff 75 0c             	pushl  0xc(%ebp)
f0106699:	ff 75 08             	pushl  0x8(%ebp)
f010669c:	e8 8a ff ff ff       	call   f010662b <memmove>
}
f01066a1:	c9                   	leave  
f01066a2:	c3                   	ret    

f01066a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01066a3:	55                   	push   %ebp
f01066a4:	89 e5                	mov    %esp,%ebp
f01066a6:	56                   	push   %esi
f01066a7:	53                   	push   %ebx
f01066a8:	8b 45 08             	mov    0x8(%ebp),%eax
f01066ab:	8b 55 0c             	mov    0xc(%ebp),%edx
f01066ae:	89 c6                	mov    %eax,%esi
f01066b0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01066b3:	39 f0                	cmp    %esi,%eax
f01066b5:	74 1c                	je     f01066d3 <memcmp+0x30>
		if (*s1 != *s2)
f01066b7:	0f b6 08             	movzbl (%eax),%ecx
f01066ba:	0f b6 1a             	movzbl (%edx),%ebx
f01066bd:	38 d9                	cmp    %bl,%cl
f01066bf:	75 08                	jne    f01066c9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01066c1:	83 c0 01             	add    $0x1,%eax
f01066c4:	83 c2 01             	add    $0x1,%edx
f01066c7:	eb ea                	jmp    f01066b3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01066c9:	0f b6 c1             	movzbl %cl,%eax
f01066cc:	0f b6 db             	movzbl %bl,%ebx
f01066cf:	29 d8                	sub    %ebx,%eax
f01066d1:	eb 05                	jmp    f01066d8 <memcmp+0x35>
	}

	return 0;
f01066d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01066d8:	5b                   	pop    %ebx
f01066d9:	5e                   	pop    %esi
f01066da:	5d                   	pop    %ebp
f01066db:	c3                   	ret    

f01066dc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01066dc:	55                   	push   %ebp
f01066dd:	89 e5                	mov    %esp,%ebp
f01066df:	8b 45 08             	mov    0x8(%ebp),%eax
f01066e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01066e5:	89 c2                	mov    %eax,%edx
f01066e7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01066ea:	39 d0                	cmp    %edx,%eax
f01066ec:	73 09                	jae    f01066f7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01066ee:	38 08                	cmp    %cl,(%eax)
f01066f0:	74 05                	je     f01066f7 <memfind+0x1b>
	for (; s < ends; s++)
f01066f2:	83 c0 01             	add    $0x1,%eax
f01066f5:	eb f3                	jmp    f01066ea <memfind+0xe>
			break;
	return (void *) s;
}
f01066f7:	5d                   	pop    %ebp
f01066f8:	c3                   	ret    

f01066f9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01066f9:	55                   	push   %ebp
f01066fa:	89 e5                	mov    %esp,%ebp
f01066fc:	57                   	push   %edi
f01066fd:	56                   	push   %esi
f01066fe:	53                   	push   %ebx
f01066ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106702:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106705:	eb 03                	jmp    f010670a <strtol+0x11>
		s++;
f0106707:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f010670a:	0f b6 01             	movzbl (%ecx),%eax
f010670d:	3c 20                	cmp    $0x20,%al
f010670f:	74 f6                	je     f0106707 <strtol+0xe>
f0106711:	3c 09                	cmp    $0x9,%al
f0106713:	74 f2                	je     f0106707 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0106715:	3c 2b                	cmp    $0x2b,%al
f0106717:	74 2a                	je     f0106743 <strtol+0x4a>
	int neg = 0;
f0106719:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f010671e:	3c 2d                	cmp    $0x2d,%al
f0106720:	74 2b                	je     f010674d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106722:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0106728:	75 0f                	jne    f0106739 <strtol+0x40>
f010672a:	80 39 30             	cmpb   $0x30,(%ecx)
f010672d:	74 28                	je     f0106757 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f010672f:	85 db                	test   %ebx,%ebx
f0106731:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106736:	0f 44 d8             	cmove  %eax,%ebx
f0106739:	b8 00 00 00 00       	mov    $0x0,%eax
f010673e:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106741:	eb 50                	jmp    f0106793 <strtol+0x9a>
		s++;
f0106743:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0106746:	bf 00 00 00 00       	mov    $0x0,%edi
f010674b:	eb d5                	jmp    f0106722 <strtol+0x29>
		s++, neg = 1;
f010674d:	83 c1 01             	add    $0x1,%ecx
f0106750:	bf 01 00 00 00       	mov    $0x1,%edi
f0106755:	eb cb                	jmp    f0106722 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106757:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010675b:	74 0e                	je     f010676b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f010675d:	85 db                	test   %ebx,%ebx
f010675f:	75 d8                	jne    f0106739 <strtol+0x40>
		s++, base = 8;
f0106761:	83 c1 01             	add    $0x1,%ecx
f0106764:	bb 08 00 00 00       	mov    $0x8,%ebx
f0106769:	eb ce                	jmp    f0106739 <strtol+0x40>
		s += 2, base = 16;
f010676b:	83 c1 02             	add    $0x2,%ecx
f010676e:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106773:	eb c4                	jmp    f0106739 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106775:	8d 72 9f             	lea    -0x61(%edx),%esi
f0106778:	89 f3                	mov    %esi,%ebx
f010677a:	80 fb 19             	cmp    $0x19,%bl
f010677d:	77 29                	ja     f01067a8 <strtol+0xaf>
			dig = *s - 'a' + 10;
f010677f:	0f be d2             	movsbl %dl,%edx
f0106782:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106785:	3b 55 10             	cmp    0x10(%ebp),%edx
f0106788:	7d 30                	jge    f01067ba <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010678a:	83 c1 01             	add    $0x1,%ecx
f010678d:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106791:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106793:	0f b6 11             	movzbl (%ecx),%edx
f0106796:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106799:	89 f3                	mov    %esi,%ebx
f010679b:	80 fb 09             	cmp    $0x9,%bl
f010679e:	77 d5                	ja     f0106775 <strtol+0x7c>
			dig = *s - '0';
f01067a0:	0f be d2             	movsbl %dl,%edx
f01067a3:	83 ea 30             	sub    $0x30,%edx
f01067a6:	eb dd                	jmp    f0106785 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f01067a8:	8d 72 bf             	lea    -0x41(%edx),%esi
f01067ab:	89 f3                	mov    %esi,%ebx
f01067ad:	80 fb 19             	cmp    $0x19,%bl
f01067b0:	77 08                	ja     f01067ba <strtol+0xc1>
			dig = *s - 'A' + 10;
f01067b2:	0f be d2             	movsbl %dl,%edx
f01067b5:	83 ea 37             	sub    $0x37,%edx
f01067b8:	eb cb                	jmp    f0106785 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f01067ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01067be:	74 05                	je     f01067c5 <strtol+0xcc>
		*endptr = (char *) s;
f01067c0:	8b 75 0c             	mov    0xc(%ebp),%esi
f01067c3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01067c5:	89 c2                	mov    %eax,%edx
f01067c7:	f7 da                	neg    %edx
f01067c9:	85 ff                	test   %edi,%edi
f01067cb:	0f 45 c2             	cmovne %edx,%eax
}
f01067ce:	5b                   	pop    %ebx
f01067cf:	5e                   	pop    %esi
f01067d0:	5f                   	pop    %edi
f01067d1:	5d                   	pop    %ebp
f01067d2:	c3                   	ret    
f01067d3:	90                   	nop

f01067d4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01067d4:	fa                   	cli    

	xorw    %ax, %ax
f01067d5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01067d7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01067d9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01067db:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01067dd:	0f 01 16             	lgdtl  (%esi)
f01067e0:	7c 70                	jl     f0106852 <gdtdesc+0x2>
	movl    %cr0, %eax
f01067e2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01067e5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01067e9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01067ec:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01067f2:	08 00                	or     %al,(%eax)

f01067f4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01067f4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01067f8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01067fa:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01067fc:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01067fe:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0106802:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106804:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0106806:	b8 00 70 12 00       	mov    $0x127000,%eax
	movl    %eax, %cr3
f010680b:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f010680e:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f0106811:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f0106814:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f0106817:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f010681a:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f010681f:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106822:	8b 25 a4 0e 58 f0    	mov    0xf0580ea4,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106828:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f010682d:	b8 fa 01 10 f0       	mov    $0xf01001fa,%eax
	call    *%eax
f0106832:	ff d0                	call   *%eax

f0106834 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106834:	eb fe                	jmp    f0106834 <spin>
f0106836:	66 90                	xchg   %ax,%ax

f0106838 <gdt>:
	...
f0106840:	ff                   	(bad)  
f0106841:	ff 00                	incl   (%eax)
f0106843:	00 00                	add    %al,(%eax)
f0106845:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010684c:	00                   	.byte 0x0
f010684d:	92                   	xchg   %eax,%edx
f010684e:	cf                   	iret   
	...

f0106850 <gdtdesc>:
f0106850:	17                   	pop    %ss
f0106851:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0106856 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106856:	90                   	nop

f0106857 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106857:	55                   	push   %ebp
f0106858:	89 e5                	mov    %esp,%ebp
f010685a:	57                   	push   %edi
f010685b:	56                   	push   %esi
f010685c:	53                   	push   %ebx
f010685d:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106860:	8b 0d a8 0e 58 f0    	mov    0xf0580ea8,%ecx
f0106866:	89 c3                	mov    %eax,%ebx
f0106868:	c1 eb 0c             	shr    $0xc,%ebx
f010686b:	39 cb                	cmp    %ecx,%ebx
f010686d:	73 1a                	jae    f0106889 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f010686f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106875:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106878:	89 f8                	mov    %edi,%eax
f010687a:	c1 e8 0c             	shr    $0xc,%eax
f010687d:	39 c8                	cmp    %ecx,%eax
f010687f:	73 1a                	jae    f010689b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106881:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106887:	eb 27                	jmp    f01068b0 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106889:	50                   	push   %eax
f010688a:	68 b4 7c 10 f0       	push   $0xf0107cb4
f010688f:	6a 57                	push   $0x57
f0106891:	68 25 9f 10 f0       	push   $0xf0109f25
f0106896:	e8 ae 97 ff ff       	call   f0100049 <_panic>
f010689b:	57                   	push   %edi
f010689c:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01068a1:	6a 57                	push   $0x57
f01068a3:	68 25 9f 10 f0       	push   $0xf0109f25
f01068a8:	e8 9c 97 ff ff       	call   f0100049 <_panic>
f01068ad:	83 c3 10             	add    $0x10,%ebx
f01068b0:	39 fb                	cmp    %edi,%ebx
f01068b2:	73 30                	jae    f01068e4 <mpsearch1+0x8d>
f01068b4:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01068b6:	83 ec 04             	sub    $0x4,%esp
f01068b9:	6a 04                	push   $0x4
f01068bb:	68 35 9f 10 f0       	push   $0xf0109f35
f01068c0:	53                   	push   %ebx
f01068c1:	e8 dd fd ff ff       	call   f01066a3 <memcmp>
f01068c6:	83 c4 10             	add    $0x10,%esp
f01068c9:	85 c0                	test   %eax,%eax
f01068cb:	75 e0                	jne    f01068ad <mpsearch1+0x56>
f01068cd:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f01068cf:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f01068d2:	0f b6 0a             	movzbl (%edx),%ecx
f01068d5:	01 c8                	add    %ecx,%eax
f01068d7:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f01068da:	39 f2                	cmp    %esi,%edx
f01068dc:	75 f4                	jne    f01068d2 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01068de:	84 c0                	test   %al,%al
f01068e0:	75 cb                	jne    f01068ad <mpsearch1+0x56>
f01068e2:	eb 05                	jmp    f01068e9 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01068e4:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01068e9:	89 d8                	mov    %ebx,%eax
f01068eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01068ee:	5b                   	pop    %ebx
f01068ef:	5e                   	pop    %esi
f01068f0:	5f                   	pop    %edi
f01068f1:	5d                   	pop    %ebp
f01068f2:	c3                   	ret    

f01068f3 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01068f3:	55                   	push   %ebp
f01068f4:	89 e5                	mov    %esp,%ebp
f01068f6:	57                   	push   %edi
f01068f7:	56                   	push   %esi
f01068f8:	53                   	push   %ebx
f01068f9:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01068fc:	c7 05 c0 13 58 f0 20 	movl   $0xf0581020,0xf05813c0
f0106903:	10 58 f0 
	if (PGNUM(pa) >= npages)
f0106906:	83 3d a8 0e 58 f0 00 	cmpl   $0x0,0xf0580ea8
f010690d:	0f 84 a3 00 00 00    	je     f01069b6 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106913:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f010691a:	85 c0                	test   %eax,%eax
f010691c:	0f 84 aa 00 00 00    	je     f01069cc <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f0106922:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106925:	ba 00 04 00 00       	mov    $0x400,%edx
f010692a:	e8 28 ff ff ff       	call   f0106857 <mpsearch1>
f010692f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106932:	85 c0                	test   %eax,%eax
f0106934:	75 1a                	jne    f0106950 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0106936:	ba 00 00 01 00       	mov    $0x10000,%edx
f010693b:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106940:	e8 12 ff ff ff       	call   f0106857 <mpsearch1>
f0106945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0106948:	85 c0                	test   %eax,%eax
f010694a:	0f 84 31 02 00 00    	je     f0106b81 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106953:	8b 58 04             	mov    0x4(%eax),%ebx
f0106956:	85 db                	test   %ebx,%ebx
f0106958:	0f 84 97 00 00 00    	je     f01069f5 <mp_init+0x102>
f010695e:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106962:	0f 85 8d 00 00 00    	jne    f01069f5 <mp_init+0x102>
f0106968:	89 d8                	mov    %ebx,%eax
f010696a:	c1 e8 0c             	shr    $0xc,%eax
f010696d:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f0106973:	0f 83 91 00 00 00    	jae    f0106a0a <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106979:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f010697f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106981:	83 ec 04             	sub    $0x4,%esp
f0106984:	6a 04                	push   $0x4
f0106986:	68 3a 9f 10 f0       	push   $0xf0109f3a
f010698b:	53                   	push   %ebx
f010698c:	e8 12 fd ff ff       	call   f01066a3 <memcmp>
f0106991:	83 c4 10             	add    $0x10,%esp
f0106994:	85 c0                	test   %eax,%eax
f0106996:	0f 85 83 00 00 00    	jne    f0106a1f <mp_init+0x12c>
f010699c:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f01069a0:	01 df                	add    %ebx,%edi
	sum = 0;
f01069a2:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f01069a4:	39 fb                	cmp    %edi,%ebx
f01069a6:	0f 84 88 00 00 00    	je     f0106a34 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f01069ac:	0f b6 0b             	movzbl (%ebx),%ecx
f01069af:	01 ca                	add    %ecx,%edx
f01069b1:	83 c3 01             	add    $0x1,%ebx
f01069b4:	eb ee                	jmp    f01069a4 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01069b6:	68 00 04 00 00       	push   $0x400
f01069bb:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01069c0:	6a 6f                	push   $0x6f
f01069c2:	68 25 9f 10 f0       	push   $0xf0109f25
f01069c7:	e8 7d 96 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f01069cc:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01069d3:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f01069d6:	2d 00 04 00 00       	sub    $0x400,%eax
f01069db:	ba 00 04 00 00       	mov    $0x400,%edx
f01069e0:	e8 72 fe ff ff       	call   f0106857 <mpsearch1>
f01069e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01069e8:	85 c0                	test   %eax,%eax
f01069ea:	0f 85 60 ff ff ff    	jne    f0106950 <mp_init+0x5d>
f01069f0:	e9 41 ff ff ff       	jmp    f0106936 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f01069f5:	83 ec 0c             	sub    $0xc,%esp
f01069f8:	68 98 9d 10 f0       	push   $0xf0109d98
f01069fd:	e8 ce d4 ff ff       	call   f0103ed0 <cprintf>
f0106a02:	83 c4 10             	add    $0x10,%esp
f0106a05:	e9 77 01 00 00       	jmp    f0106b81 <mp_init+0x28e>
f0106a0a:	53                   	push   %ebx
f0106a0b:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0106a10:	68 90 00 00 00       	push   $0x90
f0106a15:	68 25 9f 10 f0       	push   $0xf0109f25
f0106a1a:	e8 2a 96 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106a1f:	83 ec 0c             	sub    $0xc,%esp
f0106a22:	68 c8 9d 10 f0       	push   $0xf0109dc8
f0106a27:	e8 a4 d4 ff ff       	call   f0103ed0 <cprintf>
f0106a2c:	83 c4 10             	add    $0x10,%esp
f0106a2f:	e9 4d 01 00 00       	jmp    f0106b81 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0106a34:	84 d2                	test   %dl,%dl
f0106a36:	75 16                	jne    f0106a4e <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0106a38:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0106a3c:	80 fa 01             	cmp    $0x1,%dl
f0106a3f:	74 05                	je     f0106a46 <mp_init+0x153>
f0106a41:	80 fa 04             	cmp    $0x4,%dl
f0106a44:	75 1d                	jne    f0106a63 <mp_init+0x170>
f0106a46:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0106a4a:	01 d9                	add    %ebx,%ecx
f0106a4c:	eb 36                	jmp    f0106a84 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106a4e:	83 ec 0c             	sub    $0xc,%esp
f0106a51:	68 fc 9d 10 f0       	push   $0xf0109dfc
f0106a56:	e8 75 d4 ff ff       	call   f0103ed0 <cprintf>
f0106a5b:	83 c4 10             	add    $0x10,%esp
f0106a5e:	e9 1e 01 00 00       	jmp    f0106b81 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106a63:	83 ec 08             	sub    $0x8,%esp
f0106a66:	0f b6 d2             	movzbl %dl,%edx
f0106a69:	52                   	push   %edx
f0106a6a:	68 20 9e 10 f0       	push   $0xf0109e20
f0106a6f:	e8 5c d4 ff ff       	call   f0103ed0 <cprintf>
f0106a74:	83 c4 10             	add    $0x10,%esp
f0106a77:	e9 05 01 00 00       	jmp    f0106b81 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106a7c:	0f b6 13             	movzbl (%ebx),%edx
f0106a7f:	01 d0                	add    %edx,%eax
f0106a81:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106a84:	39 d9                	cmp    %ebx,%ecx
f0106a86:	75 f4                	jne    f0106a7c <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106a88:	02 46 2a             	add    0x2a(%esi),%al
f0106a8b:	75 1c                	jne    f0106aa9 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106a8d:	c7 05 00 10 58 f0 01 	movl   $0x1,0xf0581000
f0106a94:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106a97:	8b 46 24             	mov    0x24(%esi),%eax
f0106a9a:	a3 00 20 5c f0       	mov    %eax,0xf05c2000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106a9f:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106aa2:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106aa7:	eb 4d                	jmp    f0106af6 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106aa9:	83 ec 0c             	sub    $0xc,%esp
f0106aac:	68 40 9e 10 f0       	push   $0xf0109e40
f0106ab1:	e8 1a d4 ff ff       	call   f0103ed0 <cprintf>
f0106ab6:	83 c4 10             	add    $0x10,%esp
f0106ab9:	e9 c3 00 00 00       	jmp    f0106b81 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106abe:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106ac2:	74 11                	je     f0106ad5 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106ac4:	6b 05 c4 13 58 f0 74 	imul   $0x74,0xf05813c4,%eax
f0106acb:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0106ad0:	a3 c0 13 58 f0       	mov    %eax,0xf05813c0
			if (ncpu < NCPU) {
f0106ad5:	a1 c4 13 58 f0       	mov    0xf05813c4,%eax
f0106ada:	83 f8 07             	cmp    $0x7,%eax
f0106add:	7f 2f                	jg     f0106b0e <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0106adf:	6b d0 74             	imul   $0x74,%eax,%edx
f0106ae2:	88 82 20 10 58 f0    	mov    %al,-0xfa7efe0(%edx)
				ncpu++;
f0106ae8:	83 c0 01             	add    $0x1,%eax
f0106aeb:	a3 c4 13 58 f0       	mov    %eax,0xf05813c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106af0:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106af3:	83 c3 01             	add    $0x1,%ebx
f0106af6:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0106afa:	39 d8                	cmp    %ebx,%eax
f0106afc:	76 4b                	jbe    f0106b49 <mp_init+0x256>
		switch (*p) {
f0106afe:	0f b6 07             	movzbl (%edi),%eax
f0106b01:	84 c0                	test   %al,%al
f0106b03:	74 b9                	je     f0106abe <mp_init+0x1cb>
f0106b05:	3c 04                	cmp    $0x4,%al
f0106b07:	77 1c                	ja     f0106b25 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106b09:	83 c7 08             	add    $0x8,%edi
			continue;
f0106b0c:	eb e5                	jmp    f0106af3 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106b0e:	83 ec 08             	sub    $0x8,%esp
f0106b11:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106b15:	50                   	push   %eax
f0106b16:	68 70 9e 10 f0       	push   $0xf0109e70
f0106b1b:	e8 b0 d3 ff ff       	call   f0103ed0 <cprintf>
f0106b20:	83 c4 10             	add    $0x10,%esp
f0106b23:	eb cb                	jmp    f0106af0 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106b25:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106b28:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106b2b:	50                   	push   %eax
f0106b2c:	68 98 9e 10 f0       	push   $0xf0109e98
f0106b31:	e8 9a d3 ff ff       	call   f0103ed0 <cprintf>
			ismp = 0;
f0106b36:	c7 05 00 10 58 f0 00 	movl   $0x0,0xf0581000
f0106b3d:	00 00 00 
			i = conf->entry;
f0106b40:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106b44:	83 c4 10             	add    $0x10,%esp
f0106b47:	eb aa                	jmp    f0106af3 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106b49:	a1 c0 13 58 f0       	mov    0xf05813c0,%eax
f0106b4e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106b55:	83 3d 00 10 58 f0 00 	cmpl   $0x0,0xf0581000
f0106b5c:	74 2b                	je     f0106b89 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106b5e:	83 ec 04             	sub    $0x4,%esp
f0106b61:	ff 35 c4 13 58 f0    	pushl  0xf05813c4
f0106b67:	0f b6 00             	movzbl (%eax),%eax
f0106b6a:	50                   	push   %eax
f0106b6b:	68 3f 9f 10 f0       	push   $0xf0109f3f
f0106b70:	e8 5b d3 ff ff       	call   f0103ed0 <cprintf>

	if (mp->imcrp) {
f0106b75:	83 c4 10             	add    $0x10,%esp
f0106b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106b7b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106b7f:	75 2e                	jne    f0106baf <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106b84:	5b                   	pop    %ebx
f0106b85:	5e                   	pop    %esi
f0106b86:	5f                   	pop    %edi
f0106b87:	5d                   	pop    %ebp
f0106b88:	c3                   	ret    
		ncpu = 1;
f0106b89:	c7 05 c4 13 58 f0 01 	movl   $0x1,0xf05813c4
f0106b90:	00 00 00 
		lapicaddr = 0;
f0106b93:	c7 05 00 20 5c f0 00 	movl   $0x0,0xf05c2000
f0106b9a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106b9d:	83 ec 0c             	sub    $0xc,%esp
f0106ba0:	68 b8 9e 10 f0       	push   $0xf0109eb8
f0106ba5:	e8 26 d3 ff ff       	call   f0103ed0 <cprintf>
		return;
f0106baa:	83 c4 10             	add    $0x10,%esp
f0106bad:	eb d2                	jmp    f0106b81 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106baf:	83 ec 0c             	sub    $0xc,%esp
f0106bb2:	68 e4 9e 10 f0       	push   $0xf0109ee4
f0106bb7:	e8 14 d3 ff ff       	call   f0103ed0 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106bbc:	b8 70 00 00 00       	mov    $0x70,%eax
f0106bc1:	ba 22 00 00 00       	mov    $0x22,%edx
f0106bc6:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106bc7:	ba 23 00 00 00       	mov    $0x23,%edx
f0106bcc:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106bcd:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106bd0:	ee                   	out    %al,(%dx)
f0106bd1:	83 c4 10             	add    $0x10,%esp
f0106bd4:	eb ab                	jmp    f0106b81 <mp_init+0x28e>

f0106bd6 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106bd6:	8b 0d 04 20 5c f0    	mov    0xf05c2004,%ecx
f0106bdc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106bdf:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106be1:	a1 04 20 5c f0       	mov    0xf05c2004,%eax
f0106be6:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106be9:	c3                   	ret    

f0106bea <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f0106bea:	8b 15 04 20 5c f0    	mov    0xf05c2004,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f0106bf0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f0106bf5:	85 d2                	test   %edx,%edx
f0106bf7:	74 06                	je     f0106bff <cpunum+0x15>
		return lapic[ID] >> 24;
f0106bf9:	8b 42 20             	mov    0x20(%edx),%eax
f0106bfc:	c1 e8 18             	shr    $0x18,%eax
}
f0106bff:	c3                   	ret    

f0106c00 <lapic_init>:
	if (!lapicaddr)
f0106c00:	a1 00 20 5c f0       	mov    0xf05c2000,%eax
f0106c05:	85 c0                	test   %eax,%eax
f0106c07:	75 01                	jne    f0106c0a <lapic_init+0xa>
f0106c09:	c3                   	ret    
{
f0106c0a:	55                   	push   %ebp
f0106c0b:	89 e5                	mov    %esp,%ebp
f0106c0d:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106c10:	68 00 10 00 00       	push   $0x1000
f0106c15:	50                   	push   %eax
f0106c16:	e8 d6 aa ff ff       	call   f01016f1 <mmio_map_region>
f0106c1b:	a3 04 20 5c f0       	mov    %eax,0xf05c2004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106c20:	ba 27 01 00 00       	mov    $0x127,%edx
f0106c25:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106c2a:	e8 a7 ff ff ff       	call   f0106bd6 <lapicw>
	lapicw(TDCR, X1);
f0106c2f:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106c34:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106c39:	e8 98 ff ff ff       	call   f0106bd6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106c3e:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106c43:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106c48:	e8 89 ff ff ff       	call   f0106bd6 <lapicw>
	lapicw(TICR, 10000000); 
f0106c4d:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106c52:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106c57:	e8 7a ff ff ff       	call   f0106bd6 <lapicw>
	if (thiscpu != bootcpu)
f0106c5c:	e8 89 ff ff ff       	call   f0106bea <cpunum>
f0106c61:	6b c0 74             	imul   $0x74,%eax,%eax
f0106c64:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0106c69:	83 c4 10             	add    $0x10,%esp
f0106c6c:	39 05 c0 13 58 f0    	cmp    %eax,0xf05813c0
f0106c72:	74 0f                	je     f0106c83 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106c74:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c79:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106c7e:	e8 53 ff ff ff       	call   f0106bd6 <lapicw>
	lapicw(LINT1, MASKED);
f0106c83:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c88:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106c8d:	e8 44 ff ff ff       	call   f0106bd6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106c92:	a1 04 20 5c f0       	mov    0xf05c2004,%eax
f0106c97:	8b 40 30             	mov    0x30(%eax),%eax
f0106c9a:	c1 e8 10             	shr    $0x10,%eax
f0106c9d:	a8 fc                	test   $0xfc,%al
f0106c9f:	75 7c                	jne    f0106d1d <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106ca1:	ba 33 00 00 00       	mov    $0x33,%edx
f0106ca6:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106cab:	e8 26 ff ff ff       	call   f0106bd6 <lapicw>
	lapicw(ESR, 0);
f0106cb0:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cb5:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106cba:	e8 17 ff ff ff       	call   f0106bd6 <lapicw>
	lapicw(ESR, 0);
f0106cbf:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cc4:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106cc9:	e8 08 ff ff ff       	call   f0106bd6 <lapicw>
	lapicw(EOI, 0);
f0106cce:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cd3:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106cd8:	e8 f9 fe ff ff       	call   f0106bd6 <lapicw>
	lapicw(ICRHI, 0);
f0106cdd:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ce2:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106ce7:	e8 ea fe ff ff       	call   f0106bd6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106cec:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106cf1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106cf6:	e8 db fe ff ff       	call   f0106bd6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106cfb:	8b 15 04 20 5c f0    	mov    0xf05c2004,%edx
f0106d01:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106d07:	f6 c4 10             	test   $0x10,%ah
f0106d0a:	75 f5                	jne    f0106d01 <lapic_init+0x101>
	lapicw(TPR, 0);
f0106d0c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106d11:	b8 20 00 00 00       	mov    $0x20,%eax
f0106d16:	e8 bb fe ff ff       	call   f0106bd6 <lapicw>
}
f0106d1b:	c9                   	leave  
f0106d1c:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106d1d:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106d22:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106d27:	e8 aa fe ff ff       	call   f0106bd6 <lapicw>
f0106d2c:	e9 70 ff ff ff       	jmp    f0106ca1 <lapic_init+0xa1>

f0106d31 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106d31:	83 3d 04 20 5c f0 00 	cmpl   $0x0,0xf05c2004
f0106d38:	74 17                	je     f0106d51 <lapic_eoi+0x20>
{
f0106d3a:	55                   	push   %ebp
f0106d3b:	89 e5                	mov    %esp,%ebp
f0106d3d:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106d40:	ba 00 00 00 00       	mov    $0x0,%edx
f0106d45:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106d4a:	e8 87 fe ff ff       	call   f0106bd6 <lapicw>
}
f0106d4f:	c9                   	leave  
f0106d50:	c3                   	ret    
f0106d51:	c3                   	ret    

f0106d52 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106d52:	55                   	push   %ebp
f0106d53:	89 e5                	mov    %esp,%ebp
f0106d55:	56                   	push   %esi
f0106d56:	53                   	push   %ebx
f0106d57:	8b 75 08             	mov    0x8(%ebp),%esi
f0106d5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106d5d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106d62:	ba 70 00 00 00       	mov    $0x70,%edx
f0106d67:	ee                   	out    %al,(%dx)
f0106d68:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106d6d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106d72:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106d73:	83 3d a8 0e 58 f0 00 	cmpl   $0x0,0xf0580ea8
f0106d7a:	74 7e                	je     f0106dfa <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106d7c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106d83:	00 00 
	wrv[1] = addr >> 4;
f0106d85:	89 d8                	mov    %ebx,%eax
f0106d87:	c1 e8 04             	shr    $0x4,%eax
f0106d8a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106d90:	c1 e6 18             	shl    $0x18,%esi
f0106d93:	89 f2                	mov    %esi,%edx
f0106d95:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d9a:	e8 37 fe ff ff       	call   f0106bd6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106d9f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106da4:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106da9:	e8 28 fe ff ff       	call   f0106bd6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106dae:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106db3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106db8:	e8 19 fe ff ff       	call   f0106bd6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106dbd:	c1 eb 0c             	shr    $0xc,%ebx
f0106dc0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106dc3:	89 f2                	mov    %esi,%edx
f0106dc5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106dca:	e8 07 fe ff ff       	call   f0106bd6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106dcf:	89 da                	mov    %ebx,%edx
f0106dd1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106dd6:	e8 fb fd ff ff       	call   f0106bd6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106ddb:	89 f2                	mov    %esi,%edx
f0106ddd:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106de2:	e8 ef fd ff ff       	call   f0106bd6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106de7:	89 da                	mov    %ebx,%edx
f0106de9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106dee:	e8 e3 fd ff ff       	call   f0106bd6 <lapicw>
		microdelay(200);
	}
}
f0106df3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106df6:	5b                   	pop    %ebx
f0106df7:	5e                   	pop    %esi
f0106df8:	5d                   	pop    %ebp
f0106df9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106dfa:	68 67 04 00 00       	push   $0x467
f0106dff:	68 b4 7c 10 f0       	push   $0xf0107cb4
f0106e04:	68 9c 00 00 00       	push   $0x9c
f0106e09:	68 5c 9f 10 f0       	push   $0xf0109f5c
f0106e0e:	e8 36 92 ff ff       	call   f0100049 <_panic>

f0106e13 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106e13:	55                   	push   %ebp
f0106e14:	89 e5                	mov    %esp,%ebp
f0106e16:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106e19:	8b 55 08             	mov    0x8(%ebp),%edx
f0106e1c:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106e22:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106e27:	e8 aa fd ff ff       	call   f0106bd6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106e2c:	8b 15 04 20 5c f0    	mov    0xf05c2004,%edx
f0106e32:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106e38:	f6 c4 10             	test   $0x10,%ah
f0106e3b:	75 f5                	jne    f0106e32 <lapic_ipi+0x1f>
		;
}
f0106e3d:	c9                   	leave  
f0106e3e:	c3                   	ret    

f0106e3f <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106e3f:	55                   	push   %ebp
f0106e40:	89 e5                	mov    %esp,%ebp
f0106e42:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106e4e:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106e51:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106e58:	5d                   	pop    %ebp
f0106e59:	c3                   	ret    

f0106e5a <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106e5a:	55                   	push   %ebp
f0106e5b:	89 e5                	mov    %esp,%ebp
f0106e5d:	56                   	push   %esi
f0106e5e:	53                   	push   %ebx
f0106e5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106e62:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106e65:	75 12                	jne    f0106e79 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0106e67:	ba 01 00 00 00       	mov    $0x1,%edx
f0106e6c:	89 d0                	mov    %edx,%eax
f0106e6e:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106e71:	85 c0                	test   %eax,%eax
f0106e73:	74 36                	je     f0106eab <spin_lock+0x51>
		asm volatile ("pause");
f0106e75:	f3 90                	pause  
f0106e77:	eb f3                	jmp    f0106e6c <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0106e79:	8b 73 08             	mov    0x8(%ebx),%esi
f0106e7c:	e8 69 fd ff ff       	call   f0106bea <cpunum>
f0106e81:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e84:	05 20 10 58 f0       	add    $0xf0581020,%eax
	if (holding(lk))
f0106e89:	39 c6                	cmp    %eax,%esi
f0106e8b:	75 da                	jne    f0106e67 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106e8d:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106e90:	e8 55 fd ff ff       	call   f0106bea <cpunum>
f0106e95:	83 ec 0c             	sub    $0xc,%esp
f0106e98:	53                   	push   %ebx
f0106e99:	50                   	push   %eax
f0106e9a:	68 6c 9f 10 f0       	push   $0xf0109f6c
f0106e9f:	6a 41                	push   $0x41
f0106ea1:	68 ce 9f 10 f0       	push   $0xf0109fce
f0106ea6:	e8 9e 91 ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106eab:	e8 3a fd ff ff       	call   f0106bea <cpunum>
f0106eb0:	6b c0 74             	imul   $0x74,%eax,%eax
f0106eb3:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0106eb8:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0106ebb:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106ebd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106ec2:	83 f8 09             	cmp    $0x9,%eax
f0106ec5:	7f 16                	jg     f0106edd <spin_lock+0x83>
f0106ec7:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106ecd:	76 0e                	jbe    f0106edd <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106ecf:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106ed2:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106ed6:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106ed8:	83 c0 01             	add    $0x1,%eax
f0106edb:	eb e5                	jmp    f0106ec2 <spin_lock+0x68>
	for (; i < 10; i++)
f0106edd:	83 f8 09             	cmp    $0x9,%eax
f0106ee0:	7f 0d                	jg     f0106eef <spin_lock+0x95>
		pcs[i] = 0;
f0106ee2:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106ee9:	00 
	for (; i < 10; i++)
f0106eea:	83 c0 01             	add    $0x1,%eax
f0106eed:	eb ee                	jmp    f0106edd <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106eef:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106ef2:	5b                   	pop    %ebx
f0106ef3:	5e                   	pop    %esi
f0106ef4:	5d                   	pop    %ebp
f0106ef5:	c3                   	ret    

f0106ef6 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106ef6:	55                   	push   %ebp
f0106ef7:	89 e5                	mov    %esp,%ebp
f0106ef9:	57                   	push   %edi
f0106efa:	56                   	push   %esi
f0106efb:	53                   	push   %ebx
f0106efc:	83 ec 4c             	sub    $0x4c,%esp
f0106eff:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106f02:	83 3e 00             	cmpl   $0x0,(%esi)
f0106f05:	75 35                	jne    f0106f3c <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106f07:	83 ec 04             	sub    $0x4,%esp
f0106f0a:	6a 28                	push   $0x28
f0106f0c:	8d 46 0c             	lea    0xc(%esi),%eax
f0106f0f:	50                   	push   %eax
f0106f10:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106f13:	53                   	push   %ebx
f0106f14:	e8 12 f7 ff ff       	call   f010662b <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106f19:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106f1c:	0f b6 38             	movzbl (%eax),%edi
f0106f1f:	8b 76 04             	mov    0x4(%esi),%esi
f0106f22:	e8 c3 fc ff ff       	call   f0106bea <cpunum>
f0106f27:	57                   	push   %edi
f0106f28:	56                   	push   %esi
f0106f29:	50                   	push   %eax
f0106f2a:	68 98 9f 10 f0       	push   $0xf0109f98
f0106f2f:	e8 9c cf ff ff       	call   f0103ed0 <cprintf>
f0106f34:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106f37:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106f3a:	eb 4e                	jmp    f0106f8a <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0106f3c:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106f3f:	e8 a6 fc ff ff       	call   f0106bea <cpunum>
f0106f44:	6b c0 74             	imul   $0x74,%eax,%eax
f0106f47:	05 20 10 58 f0       	add    $0xf0581020,%eax
	if (!holding(lk)) {
f0106f4c:	39 c3                	cmp    %eax,%ebx
f0106f4e:	75 b7                	jne    f0106f07 <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0106f50:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106f57:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106f5e:	b8 00 00 00 00       	mov    $0x0,%eax
f0106f63:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106f69:	5b                   	pop    %ebx
f0106f6a:	5e                   	pop    %esi
f0106f6b:	5f                   	pop    %edi
f0106f6c:	5d                   	pop    %ebp
f0106f6d:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106f6e:	83 ec 08             	sub    $0x8,%esp
f0106f71:	ff 36                	pushl  (%esi)
f0106f73:	68 f5 9f 10 f0       	push   $0xf0109ff5
f0106f78:	e8 53 cf ff ff       	call   f0103ed0 <cprintf>
f0106f7d:	83 c4 10             	add    $0x10,%esp
f0106f80:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106f83:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106f86:	39 c3                	cmp    %eax,%ebx
f0106f88:	74 40                	je     f0106fca <spin_unlock+0xd4>
f0106f8a:	89 de                	mov    %ebx,%esi
f0106f8c:	8b 03                	mov    (%ebx),%eax
f0106f8e:	85 c0                	test   %eax,%eax
f0106f90:	74 38                	je     f0106fca <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106f92:	83 ec 08             	sub    $0x8,%esp
f0106f95:	57                   	push   %edi
f0106f96:	50                   	push   %eax
f0106f97:	e8 e0 e9 ff ff       	call   f010597c <debuginfo_eip>
f0106f9c:	83 c4 10             	add    $0x10,%esp
f0106f9f:	85 c0                	test   %eax,%eax
f0106fa1:	78 cb                	js     f0106f6e <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106fa3:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106fa5:	83 ec 04             	sub    $0x4,%esp
f0106fa8:	89 c2                	mov    %eax,%edx
f0106faa:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106fad:	52                   	push   %edx
f0106fae:	ff 75 b0             	pushl  -0x50(%ebp)
f0106fb1:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106fb4:	ff 75 ac             	pushl  -0x54(%ebp)
f0106fb7:	ff 75 a8             	pushl  -0x58(%ebp)
f0106fba:	50                   	push   %eax
f0106fbb:	68 de 9f 10 f0       	push   $0xf0109fde
f0106fc0:	e8 0b cf ff ff       	call   f0103ed0 <cprintf>
f0106fc5:	83 c4 20             	add    $0x20,%esp
f0106fc8:	eb b6                	jmp    f0106f80 <spin_unlock+0x8a>
		panic("spin_unlock");
f0106fca:	83 ec 04             	sub    $0x4,%esp
f0106fcd:	68 fd 9f 10 f0       	push   $0xf0109ffd
f0106fd2:	6a 67                	push   $0x67
f0106fd4:	68 ce 9f 10 f0       	push   $0xf0109fce
f0106fd9:	e8 6b 90 ff ff       	call   f0100049 <_panic>

f0106fde <e1000_tx_init>:
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_buffer[N_TXDESC][TX_PKT_SIZE];

int
e1000_tx_init()
{
f0106fde:	55                   	push   %ebp
f0106fdf:	89 e5                	mov    %esp,%ebp
f0106fe1:	57                   	push   %edi
f0106fe2:	56                   	push   %esi
f0106fe3:	53                   	push   %ebx
f0106fe4:	83 ec 18             	sub    $0x18,%esp
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0106fe7:	6a 01                	push   $0x1
f0106fe9:	e8 e5 a2 ff ff       	call   f01012d3 <page_alloc>
	return (pp - pages) << PGSHIFT;
f0106fee:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0106ff4:	c1 f8 03             	sar    $0x3,%eax
f0106ff7:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0106ffa:	89 c2                	mov    %eax,%edx
f0106ffc:	c1 ea 0c             	shr    $0xc,%edx
f0106fff:	83 c4 10             	add    $0x10,%esp
f0107002:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0107008:	0f 83 e5 00 00 00    	jae    f01070f3 <e1000_tx_init+0x115>
	return (void *)(pa + KERNBASE);
f010700e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107013:	a3 20 20 5c f0       	mov    %eax,0xf05c2020
f0107018:	ba 40 20 64 f0       	mov    $0xf0642040,%edx
f010701d:	b8 40 20 64 00       	mov    $0x642040,%eax
f0107022:	89 c6                	mov    %eax,%esi
f0107024:	bf 00 00 00 00       	mov    $0x0,%edi
	tx_descs = (struct tx_desc *)page2kva(page);
f0107029:	b9 00 00 00 00       	mov    $0x0,%ecx
	if ((uint32_t)kva < KERNBASE)
f010702e:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0107034:	0f 86 cb 00 00 00    	jbe    f0107105 <e1000_tx_init+0x127>
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(tx_buffer[i]);
f010703a:	a1 20 20 5c f0       	mov    0xf05c2020,%eax
f010703f:	89 34 08             	mov    %esi,(%eax,%ecx,1)
f0107042:	89 7c 08 04          	mov    %edi,0x4(%eax,%ecx,1)
		tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0107046:	8b 1d 20 20 5c f0    	mov    0xf05c2020,%ebx
f010704c:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
f010704f:	80 48 0b 05          	orb    $0x5,0xb(%eax)
		tx_descs[i].status |= E1000_TX_STATUS_DD;
f0107053:	80 48 0c 01          	orb    $0x1,0xc(%eax)
		tx_descs[i].length = 0;
f0107057:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		tx_descs[i].cso = 0;
f010705d:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
		tx_descs[i].css = 0;
f0107061:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
		tx_descs[i].special = 0;
f0107065:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
f010706b:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f0107071:	83 c1 10             	add    $0x10,%ecx
f0107074:	81 c6 ee 05 00 00    	add    $0x5ee,%esi
f010707a:	83 d7 00             	adc    $0x0,%edi
	for(int i = 0; i < N_TXDESC; i++){
f010707d:	81 fa 40 0e 6a f0    	cmp    $0xf06a0e40,%edx
f0107083:	75 a9                	jne    f010702e <e1000_tx_init+0x50>
	}
	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->TDBAL = (uint32_t)PADDR(tx_descs);
f0107085:	a1 80 fe 57 f0       	mov    0xf057fe80,%eax
f010708a:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0107090:	0f 86 81 00 00 00    	jbe    f0107117 <e1000_tx_init+0x139>
	return (physaddr_t)kva - KERNBASE;
f0107096:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f010709c:	89 98 00 38 00 00    	mov    %ebx,0x3800(%eax)
	base->TDBAH = (uint32_t)0;
f01070a2:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f01070a9:	00 00 00 
	// base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc);
f01070ac:	c7 80 08 38 00 00 00 	movl   $0x1000,0x3808(%eax)
f01070b3:	10 00 00 

	base->TDH = 0;
f01070b6:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f01070bd:	00 00 00 
	base->TDT = 0;
f01070c0:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f01070c7:	00 00 00 

	base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
f01070ca:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f01070d0:	81 ca 0a 01 04 00    	or     $0x4010a,%edx
f01070d6:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	base->TIPG = E1000_TIPG_DEFAULT;
f01070dc:	c7 80 10 04 00 00 0a 	movl   $0x60100a,0x410(%eax)
f01070e3:	10 60 00 
	return 0;
}
f01070e6:	b8 00 00 00 00       	mov    $0x0,%eax
f01070eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01070ee:	5b                   	pop    %ebx
f01070ef:	5e                   	pop    %esi
f01070f0:	5f                   	pop    %edi
f01070f1:	5d                   	pop    %ebp
f01070f2:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01070f3:	50                   	push   %eax
f01070f4:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01070f9:	6a 58                	push   $0x58
f01070fb:	68 51 8e 10 f0       	push   $0xf0108e51
f0107100:	e8 44 8f ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107105:	52                   	push   %edx
f0107106:	68 d8 7c 10 f0       	push   $0xf0107cd8
f010710b:	6a 15                	push   $0x15
f010710d:	68 15 a0 10 f0       	push   $0xf010a015
f0107112:	e8 32 8f ff ff       	call   f0100049 <_panic>
f0107117:	53                   	push   %ebx
f0107118:	68 d8 7c 10 f0       	push   $0xf0107cd8
f010711d:	6a 20                	push   $0x20
f010711f:	68 15 a0 10 f0       	push   $0xf010a015
f0107124:	e8 20 8f ff ff       	call   f0100049 <_panic>

f0107129 <e1000_rx_init>:
struct rx_desc *rx_descs;
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_buffer[N_RXDESC][RX_PKT_SIZE];
int
e1000_rx_init()
{
f0107129:	55                   	push   %ebp
f010712a:	89 e5                	mov    %esp,%ebp
f010712c:	57                   	push   %edi
f010712d:	56                   	push   %esi
f010712e:	53                   	push   %ebx
f010712f:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n",__FUNCTION__);
f0107132:	68 68 a0 10 f0       	push   $0xf010a068
f0107137:	68 46 92 10 f0       	push   $0xf0109246
f010713c:	e8 8f cd ff ff       	call   f0103ed0 <cprintf>
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0107141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0107148:	e8 86 a1 ff ff       	call   f01012d3 <page_alloc>
	if(page == NULL)
f010714d:	83 c4 10             	add    $0x10,%esp
f0107150:	85 c0                	test   %eax,%eax
f0107152:	0f 84 eb 00 00 00    	je     f0107243 <e1000_rx_init+0x11a>
	return (pp - pages) << PGSHIFT;
f0107158:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f010715e:	c1 f8 03             	sar    $0x3,%eax
f0107161:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0107164:	89 c2                	mov    %eax,%edx
f0107166:	c1 ea 0c             	shr    $0xc,%edx
f0107169:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f010716f:	0f 83 e2 00 00 00    	jae    f0107257 <e1000_rx_init+0x12e>
	return (void *)(pa + KERNBASE);
f0107175:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010717a:	a3 24 20 5c f0       	mov    %eax,0xf05c2024
f010717f:	b8 40 20 5c f0       	mov    $0xf05c2040,%eax
f0107184:	b9 40 20 5c 00       	mov    $0x5c2040,%ecx
f0107189:	bb 00 00 00 00       	mov    $0x0,%ebx
f010718e:	be 40 20 64 f0       	mov    $0xf0642040,%esi
			panic("page_alloc panic\n");
	rx_descs = (struct rx_desc *)page2kva(page);
f0107193:	ba 00 00 00 00       	mov    $0x0,%edx
	if ((uint32_t)kva < KERNBASE)
f0107198:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010719d:	0f 86 c6 00 00 00    	jbe    f0107269 <e1000_rx_init+0x140>
	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for(int i = 0; i < N_RXDESC; i++){
		rx_descs[i].addr = PADDR(rx_buffer[i]);
f01071a3:	8b 3d 24 20 5c f0    	mov    0xf05c2024,%edi
f01071a9:	89 0c 17             	mov    %ecx,(%edi,%edx,1)
f01071ac:	89 5c 17 04          	mov    %ebx,0x4(%edi,%edx,1)
f01071b0:	05 00 08 00 00       	add    $0x800,%eax
f01071b5:	83 c2 10             	add    $0x10,%edx
f01071b8:	81 c1 00 08 00 00    	add    $0x800,%ecx
f01071be:	83 d3 00             	adc    $0x0,%ebx
	for(int i = 0; i < N_RXDESC; i++){
f01071c1:	39 f0                	cmp    %esi,%eax
f01071c3:	75 d3                	jne    f0107198 <e1000_rx_init+0x6f>
	}
	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->RCTL |= E1000_RCTL_EN|E1000_RCTL_BSIZE_2048|E1000_RCTL_SECRC;
f01071c5:	a1 80 fe 57 f0       	mov    0xf057fe80,%eax
f01071ca:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f01071d0:	81 ca 02 00 00 04    	or     $0x4000002,%edx
f01071d6:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	base->RDBAL = PADDR(rx_descs);
f01071dc:	8b 15 24 20 5c f0    	mov    0xf05c2024,%edx
f01071e2:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01071e8:	0f 86 8d 00 00 00    	jbe    f010727b <e1000_rx_init+0x152>
	return (physaddr_t)kva - KERNBASE;
f01071ee:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f01071f4:	89 90 00 28 00 00    	mov    %edx,0x2800(%eax)
	base->RDBAH = (uint32_t)0;
f01071fa:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
f0107201:	00 00 00 
	base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
f0107204:	c7 80 08 28 00 00 00 	movl   $0x1000,0x2808(%eax)
f010720b:	10 00 00 
	base->RDH = 0;
f010720e:	c7 80 10 28 00 00 00 	movl   $0x0,0x2810(%eax)
f0107215:	00 00 00 
	base->RDT = N_RXDESC-1;
f0107218:	c7 80 18 28 00 00 ff 	movl   $0xff,0x2818(%eax)
f010721f:	00 00 00 
	base->RAL = QEMU_MAC_LOW;
f0107222:	c7 80 1c 3a 00 00 52 	movl   $0x12005452,0x3a1c(%eax)
f0107229:	54 00 12 
	base->RAH = QEMU_MAC_HIGH;
f010722c:	c7 80 20 3a 00 00 34 	movl   $0x5634,0x3a20(%eax)
f0107233:	56 00 00 

	return 0;
}
f0107236:	b8 00 00 00 00       	mov    $0x0,%eax
f010723b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010723e:	5b                   	pop    %ebx
f010723f:	5e                   	pop    %esi
f0107240:	5f                   	pop    %edi
f0107241:	5d                   	pop    %ebp
f0107242:	c3                   	ret    
			panic("page_alloc panic\n");
f0107243:	83 ec 04             	sub    $0x4,%esp
f0107246:	68 22 a0 10 f0       	push   $0xf010a022
f010724b:	6a 38                	push   $0x38
f010724d:	68 15 a0 10 f0       	push   $0xf010a015
f0107252:	e8 f2 8d ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107257:	50                   	push   %eax
f0107258:	68 b4 7c 10 f0       	push   $0xf0107cb4
f010725d:	6a 58                	push   $0x58
f010725f:	68 51 8e 10 f0       	push   $0xf0108e51
f0107264:	e8 e0 8d ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107269:	50                   	push   %eax
f010726a:	68 d8 7c 10 f0       	push   $0xf0107cd8
f010726f:	6a 3d                	push   $0x3d
f0107271:	68 15 a0 10 f0       	push   $0xf010a015
f0107276:	e8 ce 8d ff ff       	call   f0100049 <_panic>
f010727b:	52                   	push   %edx
f010727c:	68 d8 7c 10 f0       	push   $0xf0107cd8
f0107281:	6a 43                	push   $0x43
f0107283:	68 15 a0 10 f0       	push   $0xf010a015
f0107288:	e8 bc 8d ff ff       	call   f0100049 <_panic>

f010728d <pci_e1000_attach>:

int
pci_e1000_attach(struct pci_func *pcif)
{
f010728d:	55                   	push   %ebp
f010728e:	89 e5                	mov    %esp,%ebp
f0107290:	53                   	push   %ebx
f0107291:	83 ec 0c             	sub    $0xc,%esp
f0107294:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0107297:	68 54 a0 10 f0       	push   $0xf010a054
f010729c:	68 46 92 10 f0       	push   $0xf0109246
f01072a1:	e8 2a cc ff ff       	call   f0103ed0 <cprintf>
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
f01072a6:	89 1c 24             	mov    %ebx,(%esp)
f01072a9:	e8 a5 05 00 00       	call   f0107853 <pci_func_enable>
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f01072ae:	83 c4 08             	add    $0x8,%esp
f01072b1:	ff 73 2c             	pushl  0x2c(%ebx)
f01072b4:	ff 73 14             	pushl  0x14(%ebx)
f01072b7:	e8 35 a4 ff ff       	call   f01016f1 <mmio_map_region>
f01072bc:	a3 80 fe 57 f0       	mov    %eax,0xf057fe80
	e1000_tx_init();
f01072c1:	e8 18 fd ff ff       	call   f0106fde <e1000_tx_init>
	e1000_rx_init();
f01072c6:	e8 5e fe ff ff       	call   f0107129 <e1000_rx_init>

	return 0;
}
f01072cb:	b8 00 00 00 00       	mov    $0x0,%eax
f01072d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01072d3:	c9                   	leave  
f01072d4:	c3                   	ret    

f01072d5 <e1000_tx>:

int
e1000_tx(const void *buf, uint32_t len)
{
f01072d5:	55                   	push   %ebp
f01072d6:	89 e5                	mov    %esp,%ebp
f01072d8:	53                   	push   %ebx
f01072d9:	83 ec 0c             	sub    $0xc,%esp
f01072dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address
	cprintf("in %s\n", __FUNCTION__);
f01072df:	68 48 a0 10 f0       	push   $0xf010a048
f01072e4:	68 46 92 10 f0       	push   $0xf0109246
f01072e9:	e8 e2 cb ff ff       	call   f0103ed0 <cprintf>
	if(tx_descs[base->TDT].status & E1000_TX_STATUS_DD){
f01072ee:	a1 20 20 5c f0       	mov    0xf05c2020,%eax
f01072f3:	8b 0d 80 fe 57 f0    	mov    0xf057fe80,%ecx
f01072f9:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01072ff:	c1 e2 04             	shl    $0x4,%edx
f0107302:	83 c4 10             	add    $0x10,%esp
f0107305:	f6 44 10 0c 01       	testb  $0x1,0xc(%eax,%edx,1)
f010730a:	0f 84 e3 00 00 00    	je     f01073f3 <e1000_tx+0x11e>
		tx_descs[base->TDT].status ^= E1000_TX_STATUS_DD;
f0107310:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f0107316:	c1 e2 04             	shl    $0x4,%edx
f0107319:	80 74 10 0c 01       	xorb   $0x1,0xc(%eax,%edx,1)
		memset(KADDR(tx_descs[base->TDT].addr), 0 , TX_PKT_SIZE);
f010731e:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f0107324:	c1 e2 04             	shl    $0x4,%edx
f0107327:	8b 04 10             	mov    (%eax,%edx,1),%eax
	if (PGNUM(pa) >= npages)
f010732a:	89 c2                	mov    %eax,%edx
f010732c:	c1 ea 0c             	shr    $0xc,%edx
f010732f:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0107335:	0f 83 94 00 00 00    	jae    f01073cf <e1000_tx+0xfa>
f010733b:	83 ec 04             	sub    $0x4,%esp
f010733e:	68 ee 05 00 00       	push   $0x5ee
f0107343:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0107345:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010734a:	50                   	push   %eax
f010734b:	e8 93 f2 ff ff       	call   f01065e3 <memset>
		memcpy(KADDR(tx_descs[base->TDT].addr), buf, len);
f0107350:	a1 80 fe 57 f0       	mov    0xf057fe80,%eax
f0107355:	8b 80 18 38 00 00    	mov    0x3818(%eax),%eax
f010735b:	c1 e0 04             	shl    $0x4,%eax
f010735e:	03 05 20 20 5c f0    	add    0xf05c2020,%eax
f0107364:	8b 00                	mov    (%eax),%eax
	if (PGNUM(pa) >= npages)
f0107366:	89 c2                	mov    %eax,%edx
f0107368:	c1 ea 0c             	shr    $0xc,%edx
f010736b:	83 c4 10             	add    $0x10,%esp
f010736e:	39 15 a8 0e 58 f0    	cmp    %edx,0xf0580ea8
f0107374:	76 6b                	jbe    f01073e1 <e1000_tx+0x10c>
f0107376:	83 ec 04             	sub    $0x4,%esp
f0107379:	53                   	push   %ebx
f010737a:	ff 75 08             	pushl  0x8(%ebp)
	return (void *)(pa + KERNBASE);
f010737d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107382:	50                   	push   %eax
f0107383:	e8 05 f3 ff ff       	call   f010668d <memcpy>
		tx_descs[base->TDT].length = len;
f0107388:	8b 0d 20 20 5c f0    	mov    0xf05c2020,%ecx
f010738e:	8b 15 80 fe 57 f0    	mov    0xf057fe80,%edx
f0107394:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f010739a:	c1 e0 04             	shl    $0x4,%eax
f010739d:	66 89 5c 01 08       	mov    %bx,0x8(%ecx,%eax,1)
		tx_descs[base->TDT].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f01073a2:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f01073a8:	c1 e0 04             	shl    $0x4,%eax
f01073ab:	80 4c 01 0b 05       	orb    $0x5,0xb(%ecx,%eax,1)

		base->TDT = (base->TDT + 1)%N_TXDESC;
f01073b0:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f01073b6:	83 c0 01             	add    $0x1,%eax
f01073b9:	0f b6 c0             	movzbl %al,%eax
f01073bc:	89 82 18 38 00 00    	mov    %eax,0x3818(%edx)
	}
	else{
		return -E_TX_FULL;
	}
	return 0;
f01073c2:	83 c4 10             	add    $0x10,%esp
f01073c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01073ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01073cd:	c9                   	leave  
f01073ce:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01073cf:	50                   	push   %eax
f01073d0:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01073d5:	6a 65                	push   $0x65
f01073d7:	68 15 a0 10 f0       	push   $0xf010a015
f01073dc:	e8 68 8c ff ff       	call   f0100049 <_panic>
f01073e1:	50                   	push   %eax
f01073e2:	68 b4 7c 10 f0       	push   $0xf0107cb4
f01073e7:	6a 66                	push   $0x66
f01073e9:	68 15 a0 10 f0       	push   $0xf010a015
f01073ee:	e8 56 8c ff ff       	call   f0100049 <_panic>
		return -E_TX_FULL;
f01073f3:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
f01073f8:	eb d0                	jmp    f01073ca <e1000_tx+0xf5>

f01073fa <e1000_rx>:

// char rx_bufs[N_RXDESC][RX_PKT_SIZE];

int
e1000_rx(void *buf, uint32_t len)
{
f01073fa:	55                   	push   %ebp
f01073fb:	89 e5                	mov    %esp,%ebp
f01073fd:	57                   	push   %edi
f01073fe:	56                   	push   %esi
f01073ff:	53                   	push   %ebx
f0107400:	83 ec 0c             	sub    $0xc,%esp
	// 	assert(len > rx_descs[base->RDH].length);
	// 	memcpy(buf, KADDR(rx_descs[base->RDH].addr), len);
	// 	memset(KADDR(rx_descs[base->RDH].addr), 0, PKT_SIZE);
	// 	base->RDT = base->RDH;
	// }
	uint32_t rdt = (base->RDT + 1) % N_RXDESC;
f0107403:	a1 80 fe 57 f0       	mov    0xf057fe80,%eax
f0107408:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
f010740e:	83 c3 01             	add    $0x1,%ebx
f0107411:	0f b6 db             	movzbl %bl,%ebx
  	if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD)){
f0107414:	89 de                	mov    %ebx,%esi
f0107416:	c1 e6 04             	shl    $0x4,%esi
f0107419:	89 f0                	mov    %esi,%eax
f010741b:	03 05 24 20 5c f0    	add    0xf05c2024,%eax
f0107421:	f6 40 0c 01          	testb  $0x1,0xc(%eax)
f0107425:	74 5a                	je     f0107481 <e1000_rx+0x87>
		return -E_AGAIN;
	}

	if(rx_descs[rdt].error) {
f0107427:	80 78 0d 00          	cmpb   $0x0,0xd(%eax)
f010742b:	75 3d                	jne    f010746a <e1000_rx+0x70>
		cprintf("[rx]error occours\n");
		return -E_UNSPECIFIED;
	}
	len = rx_descs[rdt].length;
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f010742d:	83 ec 04             	sub    $0x4,%esp
	len = rx_descs[rdt].length;
f0107430:	0f b7 78 08          	movzwl 0x8(%eax),%edi
  	memcpy(buf, rx_buffer[rdt], rx_descs[rdt].length);
f0107434:	57                   	push   %edi
f0107435:	89 d8                	mov    %ebx,%eax
f0107437:	c1 e0 0b             	shl    $0xb,%eax
f010743a:	05 40 20 5c f0       	add    $0xf05c2040,%eax
f010743f:	50                   	push   %eax
f0107440:	ff 75 08             	pushl  0x8(%ebp)
f0107443:	e8 45 f2 ff ff       	call   f010668d <memcpy>
  	rx_descs[rdt].status ^= E1000_RX_STATUS_DD;//lab6 bug?
f0107448:	03 35 24 20 5c f0    	add    0xf05c2024,%esi
f010744e:	80 76 0c 01          	xorb   $0x1,0xc(%esi)

  	base->RDT = rdt;
f0107452:	a1 80 fe 57 f0       	mov    0xf057fe80,%eax
f0107457:	89 98 18 28 00 00    	mov    %ebx,0x2818(%eax)
	return len;
f010745d:	89 f8                	mov    %edi,%eax
f010745f:	83 c4 10             	add    $0x10,%esp
}
f0107462:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107465:	5b                   	pop    %ebx
f0107466:	5e                   	pop    %esi
f0107467:	5f                   	pop    %edi
f0107468:	5d                   	pop    %ebp
f0107469:	c3                   	ret    
		cprintf("[rx]error occours\n");
f010746a:	83 ec 0c             	sub    $0xc,%esp
f010746d:	68 34 a0 10 f0       	push   $0xf010a034
f0107472:	e8 59 ca ff ff       	call   f0103ed0 <cprintf>
		return -E_UNSPECIFIED;
f0107477:	83 c4 10             	add    $0x10,%esp
f010747a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010747f:	eb e1                	jmp    f0107462 <e1000_rx+0x68>
		return -E_AGAIN;
f0107481:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f0107486:	eb da                	jmp    f0107462 <e1000_rx+0x68>

f0107488 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0107488:	55                   	push   %ebp
f0107489:	89 e5                	mov    %esp,%ebp
f010748b:	57                   	push   %edi
f010748c:	56                   	push   %esi
f010748d:	53                   	push   %ebx
f010748e:	83 ec 0c             	sub    $0xc,%esp
f0107491:	8b 7d 08             	mov    0x8(%ebp),%edi
f0107494:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107497:	eb 03                	jmp    f010749c <pci_attach_match+0x14>
f0107499:	83 c3 0c             	add    $0xc,%ebx
f010749c:	89 de                	mov    %ebx,%esi
f010749e:	8b 43 08             	mov    0x8(%ebx),%eax
f01074a1:	85 c0                	test   %eax,%eax
f01074a3:	74 37                	je     f01074dc <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f01074a5:	39 3b                	cmp    %edi,(%ebx)
f01074a7:	75 f0                	jne    f0107499 <pci_attach_match+0x11>
f01074a9:	8b 55 0c             	mov    0xc(%ebp),%edx
f01074ac:	39 56 04             	cmp    %edx,0x4(%esi)
f01074af:	75 e8                	jne    f0107499 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f01074b1:	83 ec 0c             	sub    $0xc,%esp
f01074b4:	ff 75 14             	pushl  0x14(%ebp)
f01074b7:	ff d0                	call   *%eax
			if (r > 0)
f01074b9:	83 c4 10             	add    $0x10,%esp
f01074bc:	85 c0                	test   %eax,%eax
f01074be:	7f 1c                	jg     f01074dc <pci_attach_match+0x54>
				return r;
			if (r < 0)
f01074c0:	79 d7                	jns    f0107499 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f01074c2:	83 ec 0c             	sub    $0xc,%esp
f01074c5:	50                   	push   %eax
f01074c6:	ff 76 08             	pushl  0x8(%esi)
f01074c9:	ff 75 0c             	pushl  0xc(%ebp)
f01074cc:	57                   	push   %edi
f01074cd:	68 78 a0 10 f0       	push   $0xf010a078
f01074d2:	e8 f9 c9 ff ff       	call   f0103ed0 <cprintf>
f01074d7:	83 c4 20             	add    $0x20,%esp
f01074da:	eb bd                	jmp    f0107499 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f01074dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01074df:	5b                   	pop    %ebx
f01074e0:	5e                   	pop    %esi
f01074e1:	5f                   	pop    %edi
f01074e2:	5d                   	pop    %ebp
f01074e3:	c3                   	ret    

f01074e4 <pci_conf1_set_addr>:
{
f01074e4:	55                   	push   %ebp
f01074e5:	89 e5                	mov    %esp,%ebp
f01074e7:	53                   	push   %ebx
f01074e8:	83 ec 04             	sub    $0x4,%esp
f01074eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01074ee:	3d ff 00 00 00       	cmp    $0xff,%eax
f01074f3:	77 36                	ja     f010752b <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f01074f5:	83 fa 1f             	cmp    $0x1f,%edx
f01074f8:	77 47                	ja     f0107541 <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f01074fa:	83 f9 07             	cmp    $0x7,%ecx
f01074fd:	77 58                	ja     f0107557 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f01074ff:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0107505:	77 66                	ja     f010756d <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f0107507:	f6 c3 03             	test   $0x3,%bl
f010750a:	75 77                	jne    f0107583 <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f010750c:	c1 e0 10             	shl    $0x10,%eax
f010750f:	09 d8                	or     %ebx,%eax
f0107511:	c1 e1 08             	shl    $0x8,%ecx
f0107514:	09 c8                	or     %ecx,%eax
f0107516:	c1 e2 0b             	shl    $0xb,%edx
f0107519:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f010751b:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107520:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0107525:	ef                   	out    %eax,(%dx)
}
f0107526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107529:	c9                   	leave  
f010752a:	c3                   	ret    
	assert(bus < 256);
f010752b:	68 d0 a1 10 f0       	push   $0xf010a1d0
f0107530:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0107535:	6a 2c                	push   $0x2c
f0107537:	68 da a1 10 f0       	push   $0xf010a1da
f010753c:	e8 08 8b ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f0107541:	68 e5 a1 10 f0       	push   $0xf010a1e5
f0107546:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010754b:	6a 2d                	push   $0x2d
f010754d:	68 da a1 10 f0       	push   $0xf010a1da
f0107552:	e8 f2 8a ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f0107557:	68 ee a1 10 f0       	push   $0xf010a1ee
f010755c:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0107561:	6a 2e                	push   $0x2e
f0107563:	68 da a1 10 f0       	push   $0xf010a1da
f0107568:	e8 dc 8a ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f010756d:	68 f7 a1 10 f0       	push   $0xf010a1f7
f0107572:	68 6b 8e 10 f0       	push   $0xf0108e6b
f0107577:	6a 2f                	push   $0x2f
f0107579:	68 da a1 10 f0       	push   $0xf010a1da
f010757e:	e8 c6 8a ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f0107583:	68 04 a2 10 f0       	push   $0xf010a204
f0107588:	68 6b 8e 10 f0       	push   $0xf0108e6b
f010758d:	6a 30                	push   $0x30
f010758f:	68 da a1 10 f0       	push   $0xf010a1da
f0107594:	e8 b0 8a ff ff       	call   f0100049 <_panic>

f0107599 <pci_conf_read>:
{
f0107599:	55                   	push   %ebp
f010759a:	89 e5                	mov    %esp,%ebp
f010759c:	53                   	push   %ebx
f010759d:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01075a0:	8b 48 08             	mov    0x8(%eax),%ecx
f01075a3:	8b 58 04             	mov    0x4(%eax),%ebx
f01075a6:	8b 00                	mov    (%eax),%eax
f01075a8:	8b 40 04             	mov    0x4(%eax),%eax
f01075ab:	52                   	push   %edx
f01075ac:	89 da                	mov    %ebx,%edx
f01075ae:	e8 31 ff ff ff       	call   f01074e4 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f01075b3:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01075b8:	ed                   	in     (%dx),%eax
}
f01075b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01075bc:	c9                   	leave  
f01075bd:	c3                   	ret    

f01075be <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f01075be:	55                   	push   %ebp
f01075bf:	89 e5                	mov    %esp,%ebp
f01075c1:	57                   	push   %edi
f01075c2:	56                   	push   %esi
f01075c3:	53                   	push   %ebx
f01075c4:	81 ec 00 01 00 00    	sub    $0x100,%esp
f01075ca:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f01075cc:	6a 48                	push   $0x48
f01075ce:	6a 00                	push   $0x0
f01075d0:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01075d3:	50                   	push   %eax
f01075d4:	e8 0a f0 ff ff       	call   f01065e3 <memset>
	df.bus = bus;
f01075d9:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f01075dc:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01075e3:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f01075e6:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f01075ed:	00 00 00 
f01075f0:	e9 25 01 00 00       	jmp    f010771a <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01075f5:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01075fb:	83 ec 08             	sub    $0x8,%esp
f01075fe:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0107602:	57                   	push   %edi
f0107603:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f0107604:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107607:	0f b6 c0             	movzbl %al,%eax
f010760a:	50                   	push   %eax
f010760b:	51                   	push   %ecx
f010760c:	89 d0                	mov    %edx,%eax
f010760e:	c1 e8 10             	shr    $0x10,%eax
f0107611:	50                   	push   %eax
f0107612:	0f b7 d2             	movzwl %dx,%edx
f0107615:	52                   	push   %edx
f0107616:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f010761c:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f0107622:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107628:	ff 70 04             	pushl  0x4(%eax)
f010762b:	68 a4 a0 10 f0       	push   $0xf010a0a4
f0107630:	e8 9b c8 ff ff       	call   f0103ed0 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f0107635:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f010763b:	83 c4 30             	add    $0x30,%esp
f010763e:	53                   	push   %ebx
f010763f:	68 0c 84 12 f0       	push   $0xf012840c
				 PCI_SUBCLASS(f->dev_class),
f0107644:	89 c2                	mov    %eax,%edx
f0107646:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107649:	0f b6 d2             	movzbl %dl,%edx
f010764c:	52                   	push   %edx
f010764d:	c1 e8 18             	shr    $0x18,%eax
f0107650:	50                   	push   %eax
f0107651:	e8 32 fe ff ff       	call   f0107488 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0107656:	83 c4 10             	add    $0x10,%esp
f0107659:	85 c0                	test   %eax,%eax
f010765b:	0f 84 88 00 00 00    	je     f01076e9 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107661:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107668:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f010766e:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f0107674:	0f 83 92 00 00 00    	jae    f010770c <pci_scan_bus+0x14e>
			struct pci_func af = f;
f010767a:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f0107680:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107686:	b9 12 00 00 00       	mov    $0x12,%ecx
f010768b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f010768d:	ba 00 00 00 00       	mov    $0x0,%edx
f0107692:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107698:	e8 fc fe ff ff       	call   f0107599 <pci_conf_read>
f010769d:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f01076a3:	66 83 f8 ff          	cmp    $0xffff,%ax
f01076a7:	74 b8                	je     f0107661 <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01076a9:	ba 3c 00 00 00       	mov    $0x3c,%edx
f01076ae:	89 d8                	mov    %ebx,%eax
f01076b0:	e8 e4 fe ff ff       	call   f0107599 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f01076b5:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f01076b8:	ba 08 00 00 00       	mov    $0x8,%edx
f01076bd:	89 d8                	mov    %ebx,%eax
f01076bf:	e8 d5 fe ff ff       	call   f0107599 <pci_conf_read>
f01076c4:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f01076ca:	89 c1                	mov    %eax,%ecx
f01076cc:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f01076cf:	be 18 a2 10 f0       	mov    $0xf010a218,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f01076d4:	83 f9 06             	cmp    $0x6,%ecx
f01076d7:	0f 87 18 ff ff ff    	ja     f01075f5 <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f01076dd:	8b 34 8d 8c a2 10 f0 	mov    -0xfef5d74(,%ecx,4),%esi
f01076e4:	e9 0c ff ff ff       	jmp    f01075f5 <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f01076e9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f01076ef:	53                   	push   %ebx
f01076f0:	68 f4 83 12 f0       	push   $0xf01283f4
f01076f5:	89 c2                	mov    %eax,%edx
f01076f7:	c1 ea 10             	shr    $0x10,%edx
f01076fa:	52                   	push   %edx
f01076fb:	0f b7 c0             	movzwl %ax,%eax
f01076fe:	50                   	push   %eax
f01076ff:	e8 84 fd ff ff       	call   f0107488 <pci_attach_match>
f0107704:	83 c4 10             	add    $0x10,%esp
f0107707:	e9 55 ff ff ff       	jmp    f0107661 <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f010770c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f010770f:	83 c0 01             	add    $0x1,%eax
f0107712:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107715:	83 f8 1f             	cmp    $0x1f,%eax
f0107718:	77 59                	ja     f0107773 <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f010771a:	ba 0c 00 00 00       	mov    $0xc,%edx
f010771f:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107722:	e8 72 fe ff ff       	call   f0107599 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107727:	89 c2                	mov    %eax,%edx
f0107729:	c1 ea 10             	shr    $0x10,%edx
f010772c:	f6 c2 7e             	test   $0x7e,%dl
f010772f:	75 db                	jne    f010770c <pci_scan_bus+0x14e>
		totaldev++;
f0107731:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0107738:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f010773e:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107741:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107746:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107748:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f010774f:	00 00 00 
f0107752:	25 00 00 80 00       	and    $0x800000,%eax
f0107757:	83 f8 01             	cmp    $0x1,%eax
f010775a:	19 c0                	sbb    %eax,%eax
f010775c:	83 e0 f9             	and    $0xfffffff9,%eax
f010775f:	83 c0 08             	add    $0x8,%eax
f0107762:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107768:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f010776e:	e9 f5 fe ff ff       	jmp    f0107668 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107773:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107779:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010777c:	5b                   	pop    %ebx
f010777d:	5e                   	pop    %esi
f010777e:	5f                   	pop    %edi
f010777f:	5d                   	pop    %ebp
f0107780:	c3                   	ret    

f0107781 <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0107781:	55                   	push   %ebp
f0107782:	89 e5                	mov    %esp,%ebp
f0107784:	57                   	push   %edi
f0107785:	56                   	push   %esi
f0107786:	53                   	push   %ebx
f0107787:	83 ec 1c             	sub    $0x1c,%esp
f010778a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f010778d:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0107792:	89 d8                	mov    %ebx,%eax
f0107794:	e8 00 fe ff ff       	call   f0107599 <pci_conf_read>
f0107799:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f010779b:	ba 18 00 00 00       	mov    $0x18,%edx
f01077a0:	89 d8                	mov    %ebx,%eax
f01077a2:	e8 f2 fd ff ff       	call   f0107599 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f01077a7:	83 e7 0f             	and    $0xf,%edi
f01077aa:	83 ff 01             	cmp    $0x1,%edi
f01077ad:	74 56                	je     f0107805 <pci_bridge_attach+0x84>
f01077af:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01077b1:	83 ec 04             	sub    $0x4,%esp
f01077b4:	6a 08                	push   $0x8
f01077b6:	6a 00                	push   $0x0
f01077b8:	8d 7d e0             	lea    -0x20(%ebp),%edi
f01077bb:	57                   	push   %edi
f01077bc:	e8 22 ee ff ff       	call   f01065e3 <memset>
	nbus.parent_bridge = pcif;
f01077c1:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f01077c4:	89 f0                	mov    %esi,%eax
f01077c6:	0f b6 c4             	movzbl %ah,%eax
f01077c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f01077cc:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f01077cf:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f01077d2:	89 f1                	mov    %esi,%ecx
f01077d4:	0f b6 f1             	movzbl %cl,%esi
f01077d7:	56                   	push   %esi
f01077d8:	50                   	push   %eax
f01077d9:	ff 73 08             	pushl  0x8(%ebx)
f01077dc:	ff 73 04             	pushl  0x4(%ebx)
f01077df:	8b 03                	mov    (%ebx),%eax
f01077e1:	ff 70 04             	pushl  0x4(%eax)
f01077e4:	68 14 a1 10 f0       	push   $0xf010a114
f01077e9:	e8 e2 c6 ff ff       	call   f0103ed0 <cprintf>

	pci_scan_bus(&nbus);
f01077ee:	83 c4 20             	add    $0x20,%esp
f01077f1:	89 f8                	mov    %edi,%eax
f01077f3:	e8 c6 fd ff ff       	call   f01075be <pci_scan_bus>
	return 1;
f01077f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
f01077fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107800:	5b                   	pop    %ebx
f0107801:	5e                   	pop    %esi
f0107802:	5f                   	pop    %edi
f0107803:	5d                   	pop    %ebp
f0107804:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107805:	ff 73 08             	pushl  0x8(%ebx)
f0107808:	ff 73 04             	pushl  0x4(%ebx)
f010780b:	8b 03                	mov    (%ebx),%eax
f010780d:	ff 70 04             	pushl  0x4(%eax)
f0107810:	68 e0 a0 10 f0       	push   $0xf010a0e0
f0107815:	e8 b6 c6 ff ff       	call   f0103ed0 <cprintf>
		return 0;
f010781a:	83 c4 10             	add    $0x10,%esp
f010781d:	b8 00 00 00 00       	mov    $0x0,%eax
f0107822:	eb d9                	jmp    f01077fd <pci_bridge_attach+0x7c>

f0107824 <pci_conf_write>:
{
f0107824:	55                   	push   %ebp
f0107825:	89 e5                	mov    %esp,%ebp
f0107827:	56                   	push   %esi
f0107828:	53                   	push   %ebx
f0107829:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010782b:	8b 48 08             	mov    0x8(%eax),%ecx
f010782e:	8b 70 04             	mov    0x4(%eax),%esi
f0107831:	8b 00                	mov    (%eax),%eax
f0107833:	8b 40 04             	mov    0x4(%eax),%eax
f0107836:	83 ec 0c             	sub    $0xc,%esp
f0107839:	52                   	push   %edx
f010783a:	89 f2                	mov    %esi,%edx
f010783c:	e8 a3 fc ff ff       	call   f01074e4 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107841:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107846:	89 d8                	mov    %ebx,%eax
f0107848:	ef                   	out    %eax,(%dx)
}
f0107849:	83 c4 10             	add    $0x10,%esp
f010784c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010784f:	5b                   	pop    %ebx
f0107850:	5e                   	pop    %esi
f0107851:	5d                   	pop    %ebp
f0107852:	c3                   	ret    

f0107853 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107853:	55                   	push   %ebp
f0107854:	89 e5                	mov    %esp,%ebp
f0107856:	57                   	push   %edi
f0107857:	56                   	push   %esi
f0107858:	53                   	push   %ebx
f0107859:	83 ec 2c             	sub    $0x2c,%esp
f010785c:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f010785f:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107864:	ba 04 00 00 00       	mov    $0x4,%edx
f0107869:	89 f8                	mov    %edi,%eax
f010786b:	e8 b4 ff ff ff       	call   f0107824 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107870:	be 10 00 00 00       	mov    $0x10,%esi
f0107875:	eb 27                	jmp    f010789e <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107877:	89 c3                	mov    %eax,%ebx
f0107879:	83 e3 fc             	and    $0xfffffffc,%ebx
f010787c:	f7 db                	neg    %ebx
f010787e:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107880:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107883:	83 e0 fc             	and    $0xfffffffc,%eax
f0107886:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f0107889:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f0107890:	eb 74                	jmp    f0107906 <pci_func_enable+0xb3>
	     bar += bar_width)
f0107892:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107895:	83 fe 27             	cmp    $0x27,%esi
f0107898:	0f 87 c5 00 00 00    	ja     f0107963 <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f010789e:	89 f2                	mov    %esi,%edx
f01078a0:	89 f8                	mov    %edi,%eax
f01078a2:	e8 f2 fc ff ff       	call   f0107599 <pci_conf_read>
f01078a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f01078aa:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01078af:	89 f2                	mov    %esi,%edx
f01078b1:	89 f8                	mov    %edi,%eax
f01078b3:	e8 6c ff ff ff       	call   f0107824 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f01078b8:	89 f2                	mov    %esi,%edx
f01078ba:	89 f8                	mov    %edi,%eax
f01078bc:	e8 d8 fc ff ff       	call   f0107599 <pci_conf_read>
		bar_width = 4;
f01078c1:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f01078c8:	85 c0                	test   %eax,%eax
f01078ca:	74 c6                	je     f0107892 <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f01078cc:	8d 4e f0             	lea    -0x10(%esi),%ecx
f01078cf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01078d2:	c1 e9 02             	shr    $0x2,%ecx
f01078d5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f01078d8:	a8 01                	test   $0x1,%al
f01078da:	75 9b                	jne    f0107877 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f01078dc:	89 c2                	mov    %eax,%edx
f01078de:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f01078e1:	83 fa 04             	cmp    $0x4,%edx
f01078e4:	0f 94 c1             	sete   %cl
f01078e7:	0f b6 c9             	movzbl %cl,%ecx
f01078ea:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f01078f1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f01078f4:	89 c3                	mov    %eax,%ebx
f01078f6:	83 e3 f0             	and    $0xfffffff0,%ebx
f01078f9:	f7 db                	neg    %ebx
f01078fb:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f01078fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107900:	83 e0 f0             	and    $0xfffffff0,%eax
f0107903:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107906:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0107909:	89 f2                	mov    %esi,%edx
f010790b:	89 f8                	mov    %edi,%eax
f010790d:	e8 12 ff ff ff       	call   f0107824 <pci_conf_write>
f0107912:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0107915:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0107917:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010791a:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f010791d:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f0107920:	85 db                	test   %ebx,%ebx
f0107922:	0f 84 6a ff ff ff    	je     f0107892 <pci_func_enable+0x3f>
f0107928:	85 d2                	test   %edx,%edx
f010792a:	0f 85 62 ff ff ff    	jne    f0107892 <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107930:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0107933:	83 ec 0c             	sub    $0xc,%esp
f0107936:	53                   	push   %ebx
f0107937:	6a 00                	push   $0x0
f0107939:	ff 75 d4             	pushl  -0x2c(%ebp)
f010793c:	89 c2                	mov    %eax,%edx
f010793e:	c1 ea 10             	shr    $0x10,%edx
f0107941:	52                   	push   %edx
f0107942:	0f b7 c0             	movzwl %ax,%eax
f0107945:	50                   	push   %eax
f0107946:	ff 77 08             	pushl  0x8(%edi)
f0107949:	ff 77 04             	pushl  0x4(%edi)
f010794c:	8b 07                	mov    (%edi),%eax
f010794e:	ff 70 04             	pushl  0x4(%eax)
f0107951:	68 44 a1 10 f0       	push   $0xf010a144
f0107956:	e8 75 c5 ff ff       	call   f0103ed0 <cprintf>
f010795b:	83 c4 30             	add    $0x30,%esp
f010795e:	e9 2f ff ff ff       	jmp    f0107892 <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107963:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107966:	83 ec 08             	sub    $0x8,%esp
f0107969:	89 c2                	mov    %eax,%edx
f010796b:	c1 ea 10             	shr    $0x10,%edx
f010796e:	52                   	push   %edx
f010796f:	0f b7 c0             	movzwl %ax,%eax
f0107972:	50                   	push   %eax
f0107973:	ff 77 08             	pushl  0x8(%edi)
f0107976:	ff 77 04             	pushl  0x4(%edi)
f0107979:	8b 07                	mov    (%edi),%eax
f010797b:	ff 70 04             	pushl  0x4(%eax)
f010797e:	68 a0 a1 10 f0       	push   $0xf010a1a0
f0107983:	e8 48 c5 ff ff       	call   f0103ed0 <cprintf>
}
f0107988:	83 c4 20             	add    $0x20,%esp
f010798b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010798e:	5b                   	pop    %ebx
f010798f:	5e                   	pop    %esi
f0107990:	5f                   	pop    %edi
f0107991:	5d                   	pop    %ebp
f0107992:	c3                   	ret    

f0107993 <pci_init>:

int
pci_init(void)
{
f0107993:	55                   	push   %ebp
f0107994:	89 e5                	mov    %esp,%ebp
f0107996:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107999:	6a 08                	push   $0x8
f010799b:	6a 00                	push   $0x0
f010799d:	68 84 fe 57 f0       	push   $0xf057fe84
f01079a2:	e8 3c ec ff ff       	call   f01065e3 <memset>

	return pci_scan_bus(&root_bus);
f01079a7:	b8 84 fe 57 f0       	mov    $0xf057fe84,%eax
f01079ac:	e8 0d fc ff ff       	call   f01075be <pci_scan_bus>
}
f01079b1:	c9                   	leave  
f01079b2:	c3                   	ret    

f01079b3 <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f01079b3:	c7 05 8c fe 57 f0 00 	movl   $0x0,0xf057fe8c
f01079ba:	00 00 00 
}
f01079bd:	c3                   	ret    

f01079be <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f01079be:	a1 8c fe 57 f0       	mov    0xf057fe8c,%eax
f01079c3:	83 c0 01             	add    $0x1,%eax
f01079c6:	a3 8c fe 57 f0       	mov    %eax,0xf057fe8c
	if (ticks * 10 < ticks)
f01079cb:	8d 14 80             	lea    (%eax,%eax,4),%edx
f01079ce:	01 d2                	add    %edx,%edx
f01079d0:	39 d0                	cmp    %edx,%eax
f01079d2:	77 01                	ja     f01079d5 <time_tick+0x17>
f01079d4:	c3                   	ret    
{
f01079d5:	55                   	push   %ebp
f01079d6:	89 e5                	mov    %esp,%ebp
f01079d8:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f01079db:	68 a8 a2 10 f0       	push   $0xf010a2a8
f01079e0:	6a 13                	push   $0x13
f01079e2:	68 c3 a2 10 f0       	push   $0xf010a2c3
f01079e7:	e8 5d 86 ff ff       	call   f0100049 <_panic>

f01079ec <time_msec>:
}

unsigned int
time_msec(void)
{
	return ticks * 10;
f01079ec:	a1 8c fe 57 f0       	mov    0xf057fe8c,%eax
f01079f1:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01079f4:	01 c0                	add    %eax,%eax
}
f01079f6:	c3                   	ret    
f01079f7:	66 90                	xchg   %ax,%ax
f01079f9:	66 90                	xchg   %ax,%ax
f01079fb:	66 90                	xchg   %ax,%ax
f01079fd:	66 90                	xchg   %ax,%ax
f01079ff:	90                   	nop

f0107a00 <__udivdi3>:
f0107a00:	55                   	push   %ebp
f0107a01:	57                   	push   %edi
f0107a02:	56                   	push   %esi
f0107a03:	53                   	push   %ebx
f0107a04:	83 ec 1c             	sub    $0x1c,%esp
f0107a07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0107a0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0107a0f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0107a13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0107a17:	85 d2                	test   %edx,%edx
f0107a19:	75 4d                	jne    f0107a68 <__udivdi3+0x68>
f0107a1b:	39 f3                	cmp    %esi,%ebx
f0107a1d:	76 19                	jbe    f0107a38 <__udivdi3+0x38>
f0107a1f:	31 ff                	xor    %edi,%edi
f0107a21:	89 e8                	mov    %ebp,%eax
f0107a23:	89 f2                	mov    %esi,%edx
f0107a25:	f7 f3                	div    %ebx
f0107a27:	89 fa                	mov    %edi,%edx
f0107a29:	83 c4 1c             	add    $0x1c,%esp
f0107a2c:	5b                   	pop    %ebx
f0107a2d:	5e                   	pop    %esi
f0107a2e:	5f                   	pop    %edi
f0107a2f:	5d                   	pop    %ebp
f0107a30:	c3                   	ret    
f0107a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107a38:	89 d9                	mov    %ebx,%ecx
f0107a3a:	85 db                	test   %ebx,%ebx
f0107a3c:	75 0b                	jne    f0107a49 <__udivdi3+0x49>
f0107a3e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107a43:	31 d2                	xor    %edx,%edx
f0107a45:	f7 f3                	div    %ebx
f0107a47:	89 c1                	mov    %eax,%ecx
f0107a49:	31 d2                	xor    %edx,%edx
f0107a4b:	89 f0                	mov    %esi,%eax
f0107a4d:	f7 f1                	div    %ecx
f0107a4f:	89 c6                	mov    %eax,%esi
f0107a51:	89 e8                	mov    %ebp,%eax
f0107a53:	89 f7                	mov    %esi,%edi
f0107a55:	f7 f1                	div    %ecx
f0107a57:	89 fa                	mov    %edi,%edx
f0107a59:	83 c4 1c             	add    $0x1c,%esp
f0107a5c:	5b                   	pop    %ebx
f0107a5d:	5e                   	pop    %esi
f0107a5e:	5f                   	pop    %edi
f0107a5f:	5d                   	pop    %ebp
f0107a60:	c3                   	ret    
f0107a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107a68:	39 f2                	cmp    %esi,%edx
f0107a6a:	77 1c                	ja     f0107a88 <__udivdi3+0x88>
f0107a6c:	0f bd fa             	bsr    %edx,%edi
f0107a6f:	83 f7 1f             	xor    $0x1f,%edi
f0107a72:	75 2c                	jne    f0107aa0 <__udivdi3+0xa0>
f0107a74:	39 f2                	cmp    %esi,%edx
f0107a76:	72 06                	jb     f0107a7e <__udivdi3+0x7e>
f0107a78:	31 c0                	xor    %eax,%eax
f0107a7a:	39 eb                	cmp    %ebp,%ebx
f0107a7c:	77 a9                	ja     f0107a27 <__udivdi3+0x27>
f0107a7e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107a83:	eb a2                	jmp    f0107a27 <__udivdi3+0x27>
f0107a85:	8d 76 00             	lea    0x0(%esi),%esi
f0107a88:	31 ff                	xor    %edi,%edi
f0107a8a:	31 c0                	xor    %eax,%eax
f0107a8c:	89 fa                	mov    %edi,%edx
f0107a8e:	83 c4 1c             	add    $0x1c,%esp
f0107a91:	5b                   	pop    %ebx
f0107a92:	5e                   	pop    %esi
f0107a93:	5f                   	pop    %edi
f0107a94:	5d                   	pop    %ebp
f0107a95:	c3                   	ret    
f0107a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107a9d:	8d 76 00             	lea    0x0(%esi),%esi
f0107aa0:	89 f9                	mov    %edi,%ecx
f0107aa2:	b8 20 00 00 00       	mov    $0x20,%eax
f0107aa7:	29 f8                	sub    %edi,%eax
f0107aa9:	d3 e2                	shl    %cl,%edx
f0107aab:	89 54 24 08          	mov    %edx,0x8(%esp)
f0107aaf:	89 c1                	mov    %eax,%ecx
f0107ab1:	89 da                	mov    %ebx,%edx
f0107ab3:	d3 ea                	shr    %cl,%edx
f0107ab5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107ab9:	09 d1                	or     %edx,%ecx
f0107abb:	89 f2                	mov    %esi,%edx
f0107abd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107ac1:	89 f9                	mov    %edi,%ecx
f0107ac3:	d3 e3                	shl    %cl,%ebx
f0107ac5:	89 c1                	mov    %eax,%ecx
f0107ac7:	d3 ea                	shr    %cl,%edx
f0107ac9:	89 f9                	mov    %edi,%ecx
f0107acb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107acf:	89 eb                	mov    %ebp,%ebx
f0107ad1:	d3 e6                	shl    %cl,%esi
f0107ad3:	89 c1                	mov    %eax,%ecx
f0107ad5:	d3 eb                	shr    %cl,%ebx
f0107ad7:	09 de                	or     %ebx,%esi
f0107ad9:	89 f0                	mov    %esi,%eax
f0107adb:	f7 74 24 08          	divl   0x8(%esp)
f0107adf:	89 d6                	mov    %edx,%esi
f0107ae1:	89 c3                	mov    %eax,%ebx
f0107ae3:	f7 64 24 0c          	mull   0xc(%esp)
f0107ae7:	39 d6                	cmp    %edx,%esi
f0107ae9:	72 15                	jb     f0107b00 <__udivdi3+0x100>
f0107aeb:	89 f9                	mov    %edi,%ecx
f0107aed:	d3 e5                	shl    %cl,%ebp
f0107aef:	39 c5                	cmp    %eax,%ebp
f0107af1:	73 04                	jae    f0107af7 <__udivdi3+0xf7>
f0107af3:	39 d6                	cmp    %edx,%esi
f0107af5:	74 09                	je     f0107b00 <__udivdi3+0x100>
f0107af7:	89 d8                	mov    %ebx,%eax
f0107af9:	31 ff                	xor    %edi,%edi
f0107afb:	e9 27 ff ff ff       	jmp    f0107a27 <__udivdi3+0x27>
f0107b00:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107b03:	31 ff                	xor    %edi,%edi
f0107b05:	e9 1d ff ff ff       	jmp    f0107a27 <__udivdi3+0x27>
f0107b0a:	66 90                	xchg   %ax,%ax
f0107b0c:	66 90                	xchg   %ax,%ax
f0107b0e:	66 90                	xchg   %ax,%ax

f0107b10 <__umoddi3>:
f0107b10:	55                   	push   %ebp
f0107b11:	57                   	push   %edi
f0107b12:	56                   	push   %esi
f0107b13:	53                   	push   %ebx
f0107b14:	83 ec 1c             	sub    $0x1c,%esp
f0107b17:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0107b1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0107b1f:	8b 74 24 30          	mov    0x30(%esp),%esi
f0107b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107b27:	89 da                	mov    %ebx,%edx
f0107b29:	85 c0                	test   %eax,%eax
f0107b2b:	75 43                	jne    f0107b70 <__umoddi3+0x60>
f0107b2d:	39 df                	cmp    %ebx,%edi
f0107b2f:	76 17                	jbe    f0107b48 <__umoddi3+0x38>
f0107b31:	89 f0                	mov    %esi,%eax
f0107b33:	f7 f7                	div    %edi
f0107b35:	89 d0                	mov    %edx,%eax
f0107b37:	31 d2                	xor    %edx,%edx
f0107b39:	83 c4 1c             	add    $0x1c,%esp
f0107b3c:	5b                   	pop    %ebx
f0107b3d:	5e                   	pop    %esi
f0107b3e:	5f                   	pop    %edi
f0107b3f:	5d                   	pop    %ebp
f0107b40:	c3                   	ret    
f0107b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107b48:	89 fd                	mov    %edi,%ebp
f0107b4a:	85 ff                	test   %edi,%edi
f0107b4c:	75 0b                	jne    f0107b59 <__umoddi3+0x49>
f0107b4e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107b53:	31 d2                	xor    %edx,%edx
f0107b55:	f7 f7                	div    %edi
f0107b57:	89 c5                	mov    %eax,%ebp
f0107b59:	89 d8                	mov    %ebx,%eax
f0107b5b:	31 d2                	xor    %edx,%edx
f0107b5d:	f7 f5                	div    %ebp
f0107b5f:	89 f0                	mov    %esi,%eax
f0107b61:	f7 f5                	div    %ebp
f0107b63:	89 d0                	mov    %edx,%eax
f0107b65:	eb d0                	jmp    f0107b37 <__umoddi3+0x27>
f0107b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107b6e:	66 90                	xchg   %ax,%ax
f0107b70:	89 f1                	mov    %esi,%ecx
f0107b72:	39 d8                	cmp    %ebx,%eax
f0107b74:	76 0a                	jbe    f0107b80 <__umoddi3+0x70>
f0107b76:	89 f0                	mov    %esi,%eax
f0107b78:	83 c4 1c             	add    $0x1c,%esp
f0107b7b:	5b                   	pop    %ebx
f0107b7c:	5e                   	pop    %esi
f0107b7d:	5f                   	pop    %edi
f0107b7e:	5d                   	pop    %ebp
f0107b7f:	c3                   	ret    
f0107b80:	0f bd e8             	bsr    %eax,%ebp
f0107b83:	83 f5 1f             	xor    $0x1f,%ebp
f0107b86:	75 20                	jne    f0107ba8 <__umoddi3+0x98>
f0107b88:	39 d8                	cmp    %ebx,%eax
f0107b8a:	0f 82 b0 00 00 00    	jb     f0107c40 <__umoddi3+0x130>
f0107b90:	39 f7                	cmp    %esi,%edi
f0107b92:	0f 86 a8 00 00 00    	jbe    f0107c40 <__umoddi3+0x130>
f0107b98:	89 c8                	mov    %ecx,%eax
f0107b9a:	83 c4 1c             	add    $0x1c,%esp
f0107b9d:	5b                   	pop    %ebx
f0107b9e:	5e                   	pop    %esi
f0107b9f:	5f                   	pop    %edi
f0107ba0:	5d                   	pop    %ebp
f0107ba1:	c3                   	ret    
f0107ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107ba8:	89 e9                	mov    %ebp,%ecx
f0107baa:	ba 20 00 00 00       	mov    $0x20,%edx
f0107baf:	29 ea                	sub    %ebp,%edx
f0107bb1:	d3 e0                	shl    %cl,%eax
f0107bb3:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107bb7:	89 d1                	mov    %edx,%ecx
f0107bb9:	89 f8                	mov    %edi,%eax
f0107bbb:	d3 e8                	shr    %cl,%eax
f0107bbd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107bc1:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107bc5:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107bc9:	09 c1                	or     %eax,%ecx
f0107bcb:	89 d8                	mov    %ebx,%eax
f0107bcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107bd1:	89 e9                	mov    %ebp,%ecx
f0107bd3:	d3 e7                	shl    %cl,%edi
f0107bd5:	89 d1                	mov    %edx,%ecx
f0107bd7:	d3 e8                	shr    %cl,%eax
f0107bd9:	89 e9                	mov    %ebp,%ecx
f0107bdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0107bdf:	d3 e3                	shl    %cl,%ebx
f0107be1:	89 c7                	mov    %eax,%edi
f0107be3:	89 d1                	mov    %edx,%ecx
f0107be5:	89 f0                	mov    %esi,%eax
f0107be7:	d3 e8                	shr    %cl,%eax
f0107be9:	89 e9                	mov    %ebp,%ecx
f0107beb:	89 fa                	mov    %edi,%edx
f0107bed:	d3 e6                	shl    %cl,%esi
f0107bef:	09 d8                	or     %ebx,%eax
f0107bf1:	f7 74 24 08          	divl   0x8(%esp)
f0107bf5:	89 d1                	mov    %edx,%ecx
f0107bf7:	89 f3                	mov    %esi,%ebx
f0107bf9:	f7 64 24 0c          	mull   0xc(%esp)
f0107bfd:	89 c6                	mov    %eax,%esi
f0107bff:	89 d7                	mov    %edx,%edi
f0107c01:	39 d1                	cmp    %edx,%ecx
f0107c03:	72 06                	jb     f0107c0b <__umoddi3+0xfb>
f0107c05:	75 10                	jne    f0107c17 <__umoddi3+0x107>
f0107c07:	39 c3                	cmp    %eax,%ebx
f0107c09:	73 0c                	jae    f0107c17 <__umoddi3+0x107>
f0107c0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f0107c0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0107c13:	89 d7                	mov    %edx,%edi
f0107c15:	89 c6                	mov    %eax,%esi
f0107c17:	89 ca                	mov    %ecx,%edx
f0107c19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107c1e:	29 f3                	sub    %esi,%ebx
f0107c20:	19 fa                	sbb    %edi,%edx
f0107c22:	89 d0                	mov    %edx,%eax
f0107c24:	d3 e0                	shl    %cl,%eax
f0107c26:	89 e9                	mov    %ebp,%ecx
f0107c28:	d3 eb                	shr    %cl,%ebx
f0107c2a:	d3 ea                	shr    %cl,%edx
f0107c2c:	09 d8                	or     %ebx,%eax
f0107c2e:	83 c4 1c             	add    $0x1c,%esp
f0107c31:	5b                   	pop    %ebx
f0107c32:	5e                   	pop    %esi
f0107c33:	5f                   	pop    %edi
f0107c34:	5d                   	pop    %ebp
f0107c35:	c3                   	ret    
f0107c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107c3d:	8d 76 00             	lea    0x0(%esi),%esi
f0107c40:	89 da                	mov    %ebx,%edx
f0107c42:	29 fe                	sub    %edi,%esi
f0107c44:	19 c2                	sbb    %eax,%edx
f0107c46:	89 f1                	mov    %esi,%ecx
f0107c48:	89 c8                	mov    %ecx,%eax
f0107c4a:	e9 4b ff ff ff       	jmp    f0107b9a <__umoddi3+0x8a>
