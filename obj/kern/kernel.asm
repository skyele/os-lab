
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
f0100051:	83 3d a0 fe 57 f0 00 	cmpl   $0x0,0xf057fea0
f0100058:	74 0f                	je     f0100069 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010005a:	83 ec 0c             	sub    $0xc,%esp
f010005d:	6a 00                	push   $0x0
f010005f:	e8 ed 0b 00 00       	call   f0100c51 <monitor>
f0100064:	83 c4 10             	add    $0x10,%esp
f0100067:	eb f1                	jmp    f010005a <_panic+0x11>
	panicstr = fmt;
f0100069:	89 35 a0 fe 57 f0    	mov    %esi,0xf057fea0
	asm volatile("cli; cld");
f010006f:	fa                   	cli    
f0100070:	fc                   	cld    
	va_start(ap, fmt);
f0100071:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100074:	e8 09 6b 00 00       	call   f0106b82 <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 c0 7b 10 f0       	push   $0xf0107bc0
f0100085:	e8 37 3e 00 00       	call   f0103ec1 <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 07 3e 00 00       	call   f0103e9b <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 bb 90 10 f0 	movl   $0xf01090bb,(%esp)
f010009b:	e8 21 3e 00 00       	call   f0103ec1 <cprintf>
f01000a0:	83 c4 10             	add    $0x10,%esp
f01000a3:	eb b5                	jmp    f010005a <_panic+0x11>

f01000a5 <i386_init>:
{
f01000a5:	55                   	push   %ebp
f01000a6:	89 e5                	mov    %esp,%ebp
f01000a8:	53                   	push   %ebx
f01000a9:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000ac:	e8 bc 05 00 00       	call   f010066d <cons_init>
	cprintf("pading space in the right to number 22: %-8d.\n", 22);
f01000b1:	83 ec 08             	sub    $0x8,%esp
f01000b4:	6a 16                	push   $0x16
f01000b6:	68 e4 7b 10 f0       	push   $0xf0107be4
f01000bb:	e8 01 3e 00 00       	call   f0103ec1 <cprintf>
	cprintf("%n", NULL);
f01000c0:	83 c4 08             	add    $0x8,%esp
f01000c3:	6a 00                	push   $0x0
f01000c5:	68 5c 7c 10 f0       	push   $0xf0107c5c
f01000ca:	e8 f2 3d 00 00       	call   f0103ec1 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000cf:	83 c4 0c             	add    $0xc,%esp
f01000d2:	68 00 fc ff ff       	push   $0xfffffc00
f01000d7:	68 00 04 00 00       	push   $0x400
f01000dc:	68 5f 7c 10 f0       	push   $0xf0107c5f
f01000e1:	e8 db 3d 00 00       	call   f0103ec1 <cprintf>
	mem_init();
f01000e6:	e8 57 16 00 00       	call   f0101742 <mem_init>
	env_init();
f01000eb:	e8 47 35 00 00       	call   f0103637 <env_init>
	trap_init();
f01000f0:	e8 b0 3e 00 00       	call   f0103fa5 <trap_init>
	mp_init();
f01000f5:	e8 91 67 00 00       	call   f010688b <mp_init>
	lapic_init();
f01000fa:	e8 99 6a 00 00       	call   f0106b98 <lapic_init>
	pic_init();
f01000ff:	e8 c2 3c 00 00       	call   f0103dc6 <pic_init>
	time_init();
f0100104:	e8 15 78 00 00       	call   f010791e <time_init>
	pci_init();
f0100109:	e8 f0 77 00 00       	call   f01078fe <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010010e:	c7 04 24 c0 83 12 f0 	movl   $0xf01283c0,(%esp)
f0100115:	e8 d8 6c 00 00       	call   f0106df2 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010011a:	83 c4 10             	add    $0x10,%esp
f010011d:	83 3d a8 fe 57 f0 07 	cmpl   $0x7,0xf057fea8
f0100124:	76 27                	jbe    f010014d <i386_init+0xa8>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100126:	83 ec 04             	sub    $0x4,%esp
f0100129:	b8 ee 67 10 f0       	mov    $0xf01067ee,%eax
f010012e:	2d 6c 67 10 f0       	sub    $0xf010676c,%eax
f0100133:	50                   	push   %eax
f0100134:	68 6c 67 10 f0       	push   $0xf010676c
f0100139:	68 00 70 00 f0       	push   $0xf0007000
f010013e:	e8 7f 64 00 00       	call   f01065c2 <memmove>
f0100143:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100146:	bb 20 00 58 f0       	mov    $0xf0580020,%ebx
f010014b:	eb 19                	jmp    f0100166 <i386_init+0xc1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010014d:	68 00 70 00 00       	push   $0x7000
f0100152:	68 14 7c 10 f0       	push   $0xf0107c14
f0100157:	6a 66                	push   $0x66
f0100159:	68 7b 7c 10 f0       	push   $0xf0107c7b
f010015e:	e8 e6 fe ff ff       	call   f0100049 <_panic>
f0100163:	83 c3 74             	add    $0x74,%ebx
f0100166:	6b 05 c4 03 58 f0 74 	imul   $0x74,0xf05803c4,%eax
f010016d:	05 20 00 58 f0       	add    $0xf0580020,%eax
f0100172:	39 c3                	cmp    %eax,%ebx
f0100174:	73 4d                	jae    f01001c3 <i386_init+0x11e>
		if (c == cpus + cpunum())  // We've started already.
f0100176:	e8 07 6a 00 00       	call   f0106b82 <cpunum>
f010017b:	6b c0 74             	imul   $0x74,%eax,%eax
f010017e:	05 20 00 58 f0       	add    $0xf0580020,%eax
f0100183:	39 c3                	cmp    %eax,%ebx
f0100185:	74 dc                	je     f0100163 <i386_init+0xbe>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100187:	89 d8                	mov    %ebx,%eax
f0100189:	2d 20 00 58 f0       	sub    $0xf0580020,%eax
f010018e:	c1 f8 02             	sar    $0x2,%eax
f0100191:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100197:	c1 e0 0f             	shl    $0xf,%eax
f010019a:	8d 80 00 90 58 f0    	lea    -0xfa77000(%eax),%eax
f01001a0:	a3 a4 fe 57 f0       	mov    %eax,0xf057fea4
		lapic_startap(c->cpu_id, PADDR(code));
f01001a5:	83 ec 08             	sub    $0x8,%esp
f01001a8:	68 00 70 00 00       	push   $0x7000
f01001ad:	0f b6 03             	movzbl (%ebx),%eax
f01001b0:	50                   	push   %eax
f01001b1:	e8 34 6b 00 00       	call   f0106cea <lapic_startap>
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
f01001cd:	e8 37 36 00 00       	call   f0103809 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001d2:	83 c4 08             	add    $0x8,%esp
f01001d5:	6a 00                	push   $0x0
f01001d7:	68 78 38 47 f0       	push   $0xf0473878
f01001dc:	e8 28 36 00 00       	call   f0103809 <env_create>
	kbd_intr();
f01001e1:	e8 32 04 00 00       	call   f0100618 <kbd_intr>
	sched_yield();
f01001e6:	e8 83 4c 00 00       	call   f0104e6e <sched_yield>

f01001eb <mp_main>:
{
f01001eb:	55                   	push   %ebp
f01001ec:	89 e5                	mov    %esp,%ebp
f01001ee:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001f1:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
	if ((uint32_t)kva < KERNBASE)
f01001f6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001fb:	76 52                	jbe    f010024f <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f01001fd:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100202:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100205:	e8 78 69 00 00       	call   f0106b82 <cpunum>
f010020a:	83 ec 08             	sub    $0x8,%esp
f010020d:	50                   	push   %eax
f010020e:	68 87 7c 10 f0       	push   $0xf0107c87
f0100213:	e8 a9 3c 00 00       	call   f0103ec1 <cprintf>
	lapic_init();
f0100218:	e8 7b 69 00 00       	call   f0106b98 <lapic_init>
	env_init_percpu();
f010021d:	e8 e9 33 00 00       	call   f010360b <env_init_percpu>
	trap_init_percpu();
f0100222:	e8 ae 3c 00 00       	call   f0103ed5 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100227:	e8 56 69 00 00       	call   f0106b82 <cpunum>
f010022c:	6b d0 74             	imul   $0x74,%eax,%edx
f010022f:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100232:	b8 01 00 00 00       	mov    $0x1,%eax
f0100237:	f0 87 82 20 00 58 f0 	lock xchg %eax,-0xfa7ffe0(%edx)
f010023e:	c7 04 24 c0 83 12 f0 	movl   $0xf01283c0,(%esp)
f0100245:	e8 a8 6b 00 00       	call   f0106df2 <spin_lock>
	sched_yield();
f010024a:	e8 1f 4c 00 00       	call   f0104e6e <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010024f:	50                   	push   %eax
f0100250:	68 38 7c 10 f0       	push   $0xf0107c38
f0100255:	6a 7e                	push   $0x7e
f0100257:	68 7b 7c 10 f0       	push   $0xf0107c7b
f010025c:	e8 e8 fd ff ff       	call   f0100049 <_panic>

f0100261 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100261:	55                   	push   %ebp
f0100262:	89 e5                	mov    %esp,%ebp
f0100264:	53                   	push   %ebx
f0100265:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100268:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010026b:	ff 75 0c             	pushl  0xc(%ebp)
f010026e:	ff 75 08             	pushl  0x8(%ebp)
f0100271:	68 9d 7c 10 f0       	push   $0xf0107c9d
f0100276:	e8 46 3c 00 00       	call   f0103ec1 <cprintf>
	vcprintf(fmt, ap);
f010027b:	83 c4 08             	add    $0x8,%esp
f010027e:	53                   	push   %ebx
f010027f:	ff 75 10             	pushl  0x10(%ebp)
f0100282:	e8 14 3c 00 00       	call   f0103e9b <vcprintf>
	cprintf("\n");
f0100287:	c7 04 24 bb 90 10 f0 	movl   $0xf01090bb,(%esp)
f010028e:	e8 2e 3c 00 00       	call   f0103ec1 <cprintf>
	va_end(ap);
}
f0100293:	83 c4 10             	add    $0x10,%esp
f0100296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100299:	c9                   	leave  
f010029a:	c3                   	ret    

f010029b <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010029b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002a0:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002a1:	a8 01                	test   $0x1,%al
f01002a3:	74 0a                	je     f01002af <serial_proc_data+0x14>
f01002a5:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002aa:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01002ab:	0f b6 c0             	movzbl %al,%eax
f01002ae:	c3                   	ret    
		return -1;
f01002af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01002b4:	c3                   	ret    

f01002b5 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01002b5:	55                   	push   %ebp
f01002b6:	89 e5                	mov    %esp,%ebp
f01002b8:	53                   	push   %ebx
f01002b9:	83 ec 04             	sub    $0x4,%esp
f01002bc:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002be:	ff d3                	call   *%ebx
f01002c0:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002c3:	74 29                	je     f01002ee <cons_intr+0x39>
		if (c == 0)
f01002c5:	85 c0                	test   %eax,%eax
f01002c7:	74 f5                	je     f01002be <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002c9:	8b 0d 24 e2 57 f0    	mov    0xf057e224,%ecx
f01002cf:	8d 51 01             	lea    0x1(%ecx),%edx
f01002d2:	88 81 20 e0 57 f0    	mov    %al,-0xfa81fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002d8:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002de:	b8 00 00 00 00       	mov    $0x0,%eax
f01002e3:	0f 44 d0             	cmove  %eax,%edx
f01002e6:	89 15 24 e2 57 f0    	mov    %edx,0xf057e224
f01002ec:	eb d0                	jmp    f01002be <cons_intr+0x9>
	}
}
f01002ee:	83 c4 04             	add    $0x4,%esp
f01002f1:	5b                   	pop    %ebx
f01002f2:	5d                   	pop    %ebp
f01002f3:	c3                   	ret    

f01002f4 <kbd_proc_data>:
{
f01002f4:	55                   	push   %ebp
f01002f5:	89 e5                	mov    %esp,%ebp
f01002f7:	53                   	push   %ebx
f01002f8:	83 ec 04             	sub    $0x4,%esp
f01002fb:	ba 64 00 00 00       	mov    $0x64,%edx
f0100300:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f0100301:	a8 01                	test   $0x1,%al
f0100303:	0f 84 f2 00 00 00    	je     f01003fb <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f0100309:	a8 20                	test   $0x20,%al
f010030b:	0f 85 f1 00 00 00    	jne    f0100402 <kbd_proc_data+0x10e>
f0100311:	ba 60 00 00 00       	mov    $0x60,%edx
f0100316:	ec                   	in     (%dx),%al
f0100317:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100319:	3c e0                	cmp    $0xe0,%al
f010031b:	74 61                	je     f010037e <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f010031d:	84 c0                	test   %al,%al
f010031f:	78 70                	js     f0100391 <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f0100321:	8b 0d 00 e0 57 f0    	mov    0xf057e000,%ecx
f0100327:	f6 c1 40             	test   $0x40,%cl
f010032a:	74 0e                	je     f010033a <kbd_proc_data+0x46>
		data |= 0x80;
f010032c:	83 c8 80             	or     $0xffffff80,%eax
f010032f:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100331:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100334:	89 0d 00 e0 57 f0    	mov    %ecx,0xf057e000
	shift |= shiftcode[data];
f010033a:	0f b6 d2             	movzbl %dl,%edx
f010033d:	0f b6 82 00 7e 10 f0 	movzbl -0xfef8200(%edx),%eax
f0100344:	0b 05 00 e0 57 f0    	or     0xf057e000,%eax
	shift ^= togglecode[data];
f010034a:	0f b6 8a 00 7d 10 f0 	movzbl -0xfef8300(%edx),%ecx
f0100351:	31 c8                	xor    %ecx,%eax
f0100353:	a3 00 e0 57 f0       	mov    %eax,0xf057e000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100358:	89 c1                	mov    %eax,%ecx
f010035a:	83 e1 03             	and    $0x3,%ecx
f010035d:	8b 0c 8d e0 7c 10 f0 	mov    -0xfef8320(,%ecx,4),%ecx
f0100364:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100368:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010036b:	a8 08                	test   $0x8,%al
f010036d:	74 61                	je     f01003d0 <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f010036f:	89 da                	mov    %ebx,%edx
f0100371:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100374:	83 f9 19             	cmp    $0x19,%ecx
f0100377:	77 4b                	ja     f01003c4 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f0100379:	83 eb 20             	sub    $0x20,%ebx
f010037c:	eb 0c                	jmp    f010038a <kbd_proc_data+0x96>
		shift |= E0ESC;
f010037e:	83 0d 00 e0 57 f0 40 	orl    $0x40,0xf057e000
		return 0;
f0100385:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010038a:	89 d8                	mov    %ebx,%eax
f010038c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010038f:	c9                   	leave  
f0100390:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100391:	8b 0d 00 e0 57 f0    	mov    0xf057e000,%ecx
f0100397:	89 cb                	mov    %ecx,%ebx
f0100399:	83 e3 40             	and    $0x40,%ebx
f010039c:	83 e0 7f             	and    $0x7f,%eax
f010039f:	85 db                	test   %ebx,%ebx
f01003a1:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003a4:	0f b6 d2             	movzbl %dl,%edx
f01003a7:	0f b6 82 00 7e 10 f0 	movzbl -0xfef8200(%edx),%eax
f01003ae:	83 c8 40             	or     $0x40,%eax
f01003b1:	0f b6 c0             	movzbl %al,%eax
f01003b4:	f7 d0                	not    %eax
f01003b6:	21 c8                	and    %ecx,%eax
f01003b8:	a3 00 e0 57 f0       	mov    %eax,0xf057e000
		return 0;
f01003bd:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003c2:	eb c6                	jmp    f010038a <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f01003c4:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003c7:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003ca:	83 fa 1a             	cmp    $0x1a,%edx
f01003cd:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003d0:	f7 d0                	not    %eax
f01003d2:	a8 06                	test   $0x6,%al
f01003d4:	75 b4                	jne    f010038a <kbd_proc_data+0x96>
f01003d6:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003dc:	75 ac                	jne    f010038a <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f01003de:	83 ec 0c             	sub    $0xc,%esp
f01003e1:	68 b7 7c 10 f0       	push   $0xf0107cb7
f01003e6:	e8 d6 3a 00 00       	call   f0103ec1 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003eb:	b8 03 00 00 00       	mov    $0x3,%eax
f01003f0:	ba 92 00 00 00       	mov    $0x92,%edx
f01003f5:	ee                   	out    %al,(%dx)
f01003f6:	83 c4 10             	add    $0x10,%esp
f01003f9:	eb 8f                	jmp    f010038a <kbd_proc_data+0x96>
		return -1;
f01003fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100400:	eb 88                	jmp    f010038a <kbd_proc_data+0x96>
		return -1;
f0100402:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100407:	eb 81                	jmp    f010038a <kbd_proc_data+0x96>

f0100409 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100409:	55                   	push   %ebp
f010040a:	89 e5                	mov    %esp,%ebp
f010040c:	57                   	push   %edi
f010040d:	56                   	push   %esi
f010040e:	53                   	push   %ebx
f010040f:	83 ec 1c             	sub    $0x1c,%esp
f0100412:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f0100414:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100419:	bf fd 03 00 00       	mov    $0x3fd,%edi
f010041e:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100423:	89 fa                	mov    %edi,%edx
f0100425:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100426:	a8 20                	test   $0x20,%al
f0100428:	75 13                	jne    f010043d <cons_putc+0x34>
f010042a:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100430:	7f 0b                	jg     f010043d <cons_putc+0x34>
f0100432:	89 da                	mov    %ebx,%edx
f0100434:	ec                   	in     (%dx),%al
f0100435:	ec                   	in     (%dx),%al
f0100436:	ec                   	in     (%dx),%al
f0100437:	ec                   	in     (%dx),%al
	     i++)
f0100438:	83 c6 01             	add    $0x1,%esi
f010043b:	eb e6                	jmp    f0100423 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f010043d:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100440:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100445:	89 c8                	mov    %ecx,%eax
f0100447:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100448:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010044d:	bf 79 03 00 00       	mov    $0x379,%edi
f0100452:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100457:	89 fa                	mov    %edi,%edx
f0100459:	ec                   	in     (%dx),%al
f010045a:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100460:	7f 0f                	jg     f0100471 <cons_putc+0x68>
f0100462:	84 c0                	test   %al,%al
f0100464:	78 0b                	js     f0100471 <cons_putc+0x68>
f0100466:	89 da                	mov    %ebx,%edx
f0100468:	ec                   	in     (%dx),%al
f0100469:	ec                   	in     (%dx),%al
f010046a:	ec                   	in     (%dx),%al
f010046b:	ec                   	in     (%dx),%al
f010046c:	83 c6 01             	add    $0x1,%esi
f010046f:	eb e6                	jmp    f0100457 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100471:	ba 78 03 00 00       	mov    $0x378,%edx
f0100476:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f010047a:	ee                   	out    %al,(%dx)
f010047b:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100480:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100485:	ee                   	out    %al,(%dx)
f0100486:	b8 08 00 00 00       	mov    $0x8,%eax
f010048b:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010048c:	89 ca                	mov    %ecx,%edx
f010048e:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100494:	89 c8                	mov    %ecx,%eax
f0100496:	80 cc 07             	or     $0x7,%ah
f0100499:	85 d2                	test   %edx,%edx
f010049b:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f010049e:	0f b6 c1             	movzbl %cl,%eax
f01004a1:	83 f8 09             	cmp    $0x9,%eax
f01004a4:	0f 84 b0 00 00 00    	je     f010055a <cons_putc+0x151>
f01004aa:	7e 73                	jle    f010051f <cons_putc+0x116>
f01004ac:	83 f8 0a             	cmp    $0xa,%eax
f01004af:	0f 84 98 00 00 00    	je     f010054d <cons_putc+0x144>
f01004b5:	83 f8 0d             	cmp    $0xd,%eax
f01004b8:	0f 85 d3 00 00 00    	jne    f0100591 <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f01004be:	0f b7 05 28 e2 57 f0 	movzwl 0xf057e228,%eax
f01004c5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004cb:	c1 e8 16             	shr    $0x16,%eax
f01004ce:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004d1:	c1 e0 04             	shl    $0x4,%eax
f01004d4:	66 a3 28 e2 57 f0    	mov    %ax,0xf057e228
	if (crt_pos >= CRT_SIZE) {
f01004da:	66 81 3d 28 e2 57 f0 	cmpw   $0x7cf,0xf057e228
f01004e1:	cf 07 
f01004e3:	0f 87 cb 00 00 00    	ja     f01005b4 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004e9:	8b 0d 30 e2 57 f0    	mov    0xf057e230,%ecx
f01004ef:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004f4:	89 ca                	mov    %ecx,%edx
f01004f6:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004f7:	0f b7 1d 28 e2 57 f0 	movzwl 0xf057e228,%ebx
f01004fe:	8d 71 01             	lea    0x1(%ecx),%esi
f0100501:	89 d8                	mov    %ebx,%eax
f0100503:	66 c1 e8 08          	shr    $0x8,%ax
f0100507:	89 f2                	mov    %esi,%edx
f0100509:	ee                   	out    %al,(%dx)
f010050a:	b8 0f 00 00 00       	mov    $0xf,%eax
f010050f:	89 ca                	mov    %ecx,%edx
f0100511:	ee                   	out    %al,(%dx)
f0100512:	89 d8                	mov    %ebx,%eax
f0100514:	89 f2                	mov    %esi,%edx
f0100516:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100517:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010051a:	5b                   	pop    %ebx
f010051b:	5e                   	pop    %esi
f010051c:	5f                   	pop    %edi
f010051d:	5d                   	pop    %ebp
f010051e:	c3                   	ret    
	switch (c & 0xff) {
f010051f:	83 f8 08             	cmp    $0x8,%eax
f0100522:	75 6d                	jne    f0100591 <cons_putc+0x188>
		if (crt_pos > 0) {
f0100524:	0f b7 05 28 e2 57 f0 	movzwl 0xf057e228,%eax
f010052b:	66 85 c0             	test   %ax,%ax
f010052e:	74 b9                	je     f01004e9 <cons_putc+0xe0>
			crt_pos--;
f0100530:	83 e8 01             	sub    $0x1,%eax
f0100533:	66 a3 28 e2 57 f0    	mov    %ax,0xf057e228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100539:	0f b7 c0             	movzwl %ax,%eax
f010053c:	b1 00                	mov    $0x0,%cl
f010053e:	83 c9 20             	or     $0x20,%ecx
f0100541:	8b 15 2c e2 57 f0    	mov    0xf057e22c,%edx
f0100547:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010054b:	eb 8d                	jmp    f01004da <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f010054d:	66 83 05 28 e2 57 f0 	addw   $0x50,0xf057e228
f0100554:	50 
f0100555:	e9 64 ff ff ff       	jmp    f01004be <cons_putc+0xb5>
		cons_putc(' ');
f010055a:	b8 20 00 00 00       	mov    $0x20,%eax
f010055f:	e8 a5 fe ff ff       	call   f0100409 <cons_putc>
		cons_putc(' ');
f0100564:	b8 20 00 00 00       	mov    $0x20,%eax
f0100569:	e8 9b fe ff ff       	call   f0100409 <cons_putc>
		cons_putc(' ');
f010056e:	b8 20 00 00 00       	mov    $0x20,%eax
f0100573:	e8 91 fe ff ff       	call   f0100409 <cons_putc>
		cons_putc(' ');
f0100578:	b8 20 00 00 00       	mov    $0x20,%eax
f010057d:	e8 87 fe ff ff       	call   f0100409 <cons_putc>
		cons_putc(' ');
f0100582:	b8 20 00 00 00       	mov    $0x20,%eax
f0100587:	e8 7d fe ff ff       	call   f0100409 <cons_putc>
f010058c:	e9 49 ff ff ff       	jmp    f01004da <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100591:	0f b7 05 28 e2 57 f0 	movzwl 0xf057e228,%eax
f0100598:	8d 50 01             	lea    0x1(%eax),%edx
f010059b:	66 89 15 28 e2 57 f0 	mov    %dx,0xf057e228
f01005a2:	0f b7 c0             	movzwl %ax,%eax
f01005a5:	8b 15 2c e2 57 f0    	mov    0xf057e22c,%edx
f01005ab:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005af:	e9 26 ff ff ff       	jmp    f01004da <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005b4:	a1 2c e2 57 f0       	mov    0xf057e22c,%eax
f01005b9:	83 ec 04             	sub    $0x4,%esp
f01005bc:	68 00 0f 00 00       	push   $0xf00
f01005c1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005c7:	52                   	push   %edx
f01005c8:	50                   	push   %eax
f01005c9:	e8 f4 5f 00 00       	call   f01065c2 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005ce:	8b 15 2c e2 57 f0    	mov    0xf057e22c,%edx
f01005d4:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005da:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005e0:	83 c4 10             	add    $0x10,%esp
f01005e3:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e8:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005eb:	39 d0                	cmp    %edx,%eax
f01005ed:	75 f4                	jne    f01005e3 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005ef:	66 83 2d 28 e2 57 f0 	subw   $0x50,0xf057e228
f01005f6:	50 
f01005f7:	e9 ed fe ff ff       	jmp    f01004e9 <cons_putc+0xe0>

f01005fc <serial_intr>:
	if (serial_exists)
f01005fc:	80 3d 34 e2 57 f0 00 	cmpb   $0x0,0xf057e234
f0100603:	75 01                	jne    f0100606 <serial_intr+0xa>
f0100605:	c3                   	ret    
{
f0100606:	55                   	push   %ebp
f0100607:	89 e5                	mov    %esp,%ebp
f0100609:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010060c:	b8 9b 02 10 f0       	mov    $0xf010029b,%eax
f0100611:	e8 9f fc ff ff       	call   f01002b5 <cons_intr>
}
f0100616:	c9                   	leave  
f0100617:	c3                   	ret    

f0100618 <kbd_intr>:
{
f0100618:	55                   	push   %ebp
f0100619:	89 e5                	mov    %esp,%ebp
f010061b:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f010061e:	b8 f4 02 10 f0       	mov    $0xf01002f4,%eax
f0100623:	e8 8d fc ff ff       	call   f01002b5 <cons_intr>
}
f0100628:	c9                   	leave  
f0100629:	c3                   	ret    

f010062a <cons_getc>:
{
f010062a:	55                   	push   %ebp
f010062b:	89 e5                	mov    %esp,%ebp
f010062d:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100630:	e8 c7 ff ff ff       	call   f01005fc <serial_intr>
	kbd_intr();
f0100635:	e8 de ff ff ff       	call   f0100618 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f010063a:	8b 15 20 e2 57 f0    	mov    0xf057e220,%edx
	return 0;
f0100640:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100645:	3b 15 24 e2 57 f0    	cmp    0xf057e224,%edx
f010064b:	74 1e                	je     f010066b <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010064d:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100650:	0f b6 82 20 e0 57 f0 	movzbl -0xfa81fe0(%edx),%eax
			cons.rpos = 0;
f0100657:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010065d:	ba 00 00 00 00       	mov    $0x0,%edx
f0100662:	0f 44 ca             	cmove  %edx,%ecx
f0100665:	89 0d 20 e2 57 f0    	mov    %ecx,0xf057e220
}
f010066b:	c9                   	leave  
f010066c:	c3                   	ret    

f010066d <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010066d:	55                   	push   %ebp
f010066e:	89 e5                	mov    %esp,%ebp
f0100670:	57                   	push   %edi
f0100671:	56                   	push   %esi
f0100672:	53                   	push   %ebx
f0100673:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100676:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010067d:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100684:	5a a5 
	if (*cp != 0xA55A) {
f0100686:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010068d:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100691:	0f 84 de 00 00 00    	je     f0100775 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100697:	c7 05 30 e2 57 f0 b4 	movl   $0x3b4,0xf057e230
f010069e:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006a1:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006a6:	8b 3d 30 e2 57 f0    	mov    0xf057e230,%edi
f01006ac:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006b1:	89 fa                	mov    %edi,%edx
f01006b3:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006b4:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006b7:	89 ca                	mov    %ecx,%edx
f01006b9:	ec                   	in     (%dx),%al
f01006ba:	0f b6 c0             	movzbl %al,%eax
f01006bd:	c1 e0 08             	shl    $0x8,%eax
f01006c0:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006c2:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006c7:	89 fa                	mov    %edi,%edx
f01006c9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006ca:	89 ca                	mov    %ecx,%edx
f01006cc:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006cd:	89 35 2c e2 57 f0    	mov    %esi,0xf057e22c
	pos |= inb(addr_6845 + 1);
f01006d3:	0f b6 c0             	movzbl %al,%eax
f01006d6:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006d8:	66 a3 28 e2 57 f0    	mov    %ax,0xf057e228
	kbd_intr();
f01006de:	e8 35 ff ff ff       	call   f0100618 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006e3:	83 ec 0c             	sub    $0xc,%esp
f01006e6:	0f b7 05 a8 83 12 f0 	movzwl 0xf01283a8,%eax
f01006ed:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006f2:	50                   	push   %eax
f01006f3:	e8 50 36 00 00       	call   f0103d48 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006f8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006fd:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f0100702:	89 d8                	mov    %ebx,%eax
f0100704:	89 ca                	mov    %ecx,%edx
f0100706:	ee                   	out    %al,(%dx)
f0100707:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010070c:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100711:	89 fa                	mov    %edi,%edx
f0100713:	ee                   	out    %al,(%dx)
f0100714:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100719:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010071e:	ee                   	out    %al,(%dx)
f010071f:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100724:	89 d8                	mov    %ebx,%eax
f0100726:	89 f2                	mov    %esi,%edx
f0100728:	ee                   	out    %al,(%dx)
f0100729:	b8 03 00 00 00       	mov    $0x3,%eax
f010072e:	89 fa                	mov    %edi,%edx
f0100730:	ee                   	out    %al,(%dx)
f0100731:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100736:	89 d8                	mov    %ebx,%eax
f0100738:	ee                   	out    %al,(%dx)
f0100739:	b8 01 00 00 00       	mov    $0x1,%eax
f010073e:	89 f2                	mov    %esi,%edx
f0100740:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100741:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100746:	ec                   	in     (%dx),%al
f0100747:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100749:	83 c4 10             	add    $0x10,%esp
f010074c:	3c ff                	cmp    $0xff,%al
f010074e:	0f 95 05 34 e2 57 f0 	setne  0xf057e234
f0100755:	89 ca                	mov    %ecx,%edx
f0100757:	ec                   	in     (%dx),%al
f0100758:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010075d:	ec                   	in     (%dx),%al
	if (serial_exists)
f010075e:	80 fb ff             	cmp    $0xff,%bl
f0100761:	75 2d                	jne    f0100790 <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100763:	83 ec 0c             	sub    $0xc,%esp
f0100766:	68 c3 7c 10 f0       	push   $0xf0107cc3
f010076b:	e8 51 37 00 00       	call   f0103ec1 <cprintf>
f0100770:	83 c4 10             	add    $0x10,%esp
}
f0100773:	eb 3c                	jmp    f01007b1 <cons_init+0x144>
		*cp = was;
f0100775:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010077c:	c7 05 30 e2 57 f0 d4 	movl   $0x3d4,0xf057e230
f0100783:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100786:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010078b:	e9 16 ff ff ff       	jmp    f01006a6 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100790:	83 ec 0c             	sub    $0xc,%esp
f0100793:	0f b7 05 a8 83 12 f0 	movzwl 0xf01283a8,%eax
f010079a:	25 ef ff 00 00       	and    $0xffef,%eax
f010079f:	50                   	push   %eax
f01007a0:	e8 a3 35 00 00       	call   f0103d48 <irq_setmask_8259A>
	if (!serial_exists)
f01007a5:	83 c4 10             	add    $0x10,%esp
f01007a8:	80 3d 34 e2 57 f0 00 	cmpb   $0x0,0xf057e234
f01007af:	74 b2                	je     f0100763 <cons_init+0xf6>
}
f01007b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007b4:	5b                   	pop    %ebx
f01007b5:	5e                   	pop    %esi
f01007b6:	5f                   	pop    %edi
f01007b7:	5d                   	pop    %ebp
f01007b8:	c3                   	ret    

f01007b9 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007b9:	55                   	push   %ebp
f01007ba:	89 e5                	mov    %esp,%ebp
f01007bc:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01007c2:	e8 42 fc ff ff       	call   f0100409 <cons_putc>
}
f01007c7:	c9                   	leave  
f01007c8:	c3                   	ret    

f01007c9 <getchar>:

int
getchar(void)
{
f01007c9:	55                   	push   %ebp
f01007ca:	89 e5                	mov    %esp,%ebp
f01007cc:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007cf:	e8 56 fe ff ff       	call   f010062a <cons_getc>
f01007d4:	85 c0                	test   %eax,%eax
f01007d6:	74 f7                	je     f01007cf <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007d8:	c9                   	leave  
f01007d9:	c3                   	ret    

f01007da <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f01007da:	b8 01 00 00 00       	mov    $0x1,%eax
f01007df:	c3                   	ret    

f01007e0 <mon_help>:
/***** Implementations of basic kernel monitor commands *****/
static long atol(const char *nptr);

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007e0:	55                   	push   %ebp
f01007e1:	89 e5                	mov    %esp,%ebp
f01007e3:	53                   	push   %ebx
f01007e4:	83 ec 04             	sub    $0x4,%esp
f01007e7:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007ec:	83 ec 04             	sub    $0x4,%esp
f01007ef:	ff b3 64 83 10 f0    	pushl  -0xfef7c9c(%ebx)
f01007f5:	ff b3 60 83 10 f0    	pushl  -0xfef7ca0(%ebx)
f01007fb:	68 00 7f 10 f0       	push   $0xf0107f00
f0100800:	e8 bc 36 00 00       	call   f0103ec1 <cprintf>
f0100805:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100808:	83 c4 10             	add    $0x10,%esp
f010080b:	83 fb 3c             	cmp    $0x3c,%ebx
f010080e:	75 dc                	jne    f01007ec <mon_help+0xc>
	return 0;
}
f0100810:	b8 00 00 00 00       	mov    $0x0,%eax
f0100815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100818:	c9                   	leave  
f0100819:	c3                   	ret    

f010081a <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f010081a:	55                   	push   %ebp
f010081b:	89 e5                	mov    %esp,%ebp
f010081d:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100820:	68 09 7f 10 f0       	push   $0xf0107f09
f0100825:	e8 97 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010082a:	83 c4 08             	add    $0x8,%esp
f010082d:	68 0c 00 10 00       	push   $0x10000c
f0100832:	68 6c 80 10 f0       	push   $0xf010806c
f0100837:	e8 85 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010083c:	83 c4 0c             	add    $0xc,%esp
f010083f:	68 0c 00 10 00       	push   $0x10000c
f0100844:	68 0c 00 10 f0       	push   $0xf010000c
f0100849:	68 94 80 10 f0       	push   $0xf0108094
f010084e:	e8 6e 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100853:	83 c4 0c             	add    $0xc,%esp
f0100856:	68 bf 7b 10 00       	push   $0x107bbf
f010085b:	68 bf 7b 10 f0       	push   $0xf0107bbf
f0100860:	68 b8 80 10 f0       	push   $0xf01080b8
f0100865:	e8 57 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010086a:	83 c4 0c             	add    $0xc,%esp
f010086d:	68 00 e0 57 00       	push   $0x57e000
f0100872:	68 00 e0 57 f0       	push   $0xf057e000
f0100877:	68 dc 80 10 f0       	push   $0xf01080dc
f010087c:	e8 40 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100881:	83 c4 0c             	add    $0xc,%esp
f0100884:	68 40 ec 67 00       	push   $0x67ec40
f0100889:	68 40 ec 67 f0       	push   $0xf067ec40
f010088e:	68 00 81 10 f0       	push   $0xf0108100
f0100893:	e8 29 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100898:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010089b:	b8 40 ec 67 f0       	mov    $0xf067ec40,%eax
f01008a0:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a5:	c1 f8 0a             	sar    $0xa,%eax
f01008a8:	50                   	push   %eax
f01008a9:	68 24 81 10 f0       	push   $0xf0108124
f01008ae:	e8 0e 36 00 00       	call   f0103ec1 <cprintf>
	return 0;
}
f01008b3:	b8 00 00 00 00       	mov    $0x0,%eax
f01008b8:	c9                   	leave  
f01008b9:	c3                   	ret    

f01008ba <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008ba:	55                   	push   %ebp
f01008bb:	89 e5                	mov    %esp,%ebp
f01008bd:	56                   	push   %esi
f01008be:	53                   	push   %ebx
f01008bf:	83 ec 20             	sub    $0x20,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008c2:	89 eb                	mov    %ebp,%ebx
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
		debuginfo_eip(the_ebp[1], &info);
f01008c4:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(the_ebp != NULL){
f01008c7:	85 db                	test   %ebx,%ebx
f01008c9:	0f 84 b3 00 00 00    	je     f0100982 <mon_backtrace+0xc8>
		cprintf("the ebp1 0x%x\n", the_ebp[1]);
f01008cf:	83 ec 08             	sub    $0x8,%esp
f01008d2:	ff 73 04             	pushl  0x4(%ebx)
f01008d5:	68 22 7f 10 f0       	push   $0xf0107f22
f01008da:	e8 e2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f01008df:	83 c4 08             	add    $0x8,%esp
f01008e2:	ff 73 08             	pushl  0x8(%ebx)
f01008e5:	68 31 7f 10 f0       	push   $0xf0107f31
f01008ea:	e8 d2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f01008ef:	83 c4 08             	add    $0x8,%esp
f01008f2:	ff 73 0c             	pushl  0xc(%ebx)
f01008f5:	68 40 7f 10 f0       	push   $0xf0107f40
f01008fa:	e8 c2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f01008ff:	83 c4 08             	add    $0x8,%esp
f0100902:	ff 73 10             	pushl  0x10(%ebx)
f0100905:	68 4f 7f 10 f0       	push   $0xf0107f4f
f010090a:	e8 b2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f010090f:	83 c4 08             	add    $0x8,%esp
f0100912:	ff 73 14             	pushl  0x14(%ebx)
f0100915:	68 5e 7f 10 f0       	push   $0xf0107f5e
f010091a:	e8 a2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f010091f:	83 c4 08             	add    $0x8,%esp
f0100922:	ff 73 18             	pushl  0x18(%ebx)
f0100925:	68 6d 7f 10 f0       	push   $0xf0107f6d
f010092a:	e8 92 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f010092f:	ff 73 18             	pushl  0x18(%ebx)
f0100932:	ff 73 14             	pushl  0x14(%ebx)
f0100935:	ff 73 10             	pushl  0x10(%ebx)
f0100938:	ff 73 0c             	pushl  0xc(%ebx)
f010093b:	ff 73 08             	pushl  0x8(%ebx)
f010093e:	53                   	push   %ebx
f010093f:	ff 73 04             	pushl  0x4(%ebx)
f0100942:	68 50 81 10 f0       	push   $0xf0108150
f0100947:	e8 75 35 00 00       	call   f0103ec1 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f010094c:	83 c4 28             	add    $0x28,%esp
f010094f:	56                   	push   %esi
f0100950:	ff 73 04             	pushl  0x4(%ebx)
f0100953:	e8 bb 4f 00 00       	call   f0105913 <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f0100958:	83 c4 08             	add    $0x8,%esp
f010095b:	8b 43 04             	mov    0x4(%ebx),%eax
f010095e:	2b 45 f0             	sub    -0x10(%ebp),%eax
f0100961:	50                   	push   %eax
f0100962:	ff 75 e8             	pushl  -0x18(%ebp)
f0100965:	ff 75 ec             	pushl  -0x14(%ebp)
f0100968:	ff 75 e4             	pushl  -0x1c(%ebp)
f010096b:	ff 75 e0             	pushl  -0x20(%ebp)
f010096e:	68 7c 7f 10 f0       	push   $0xf0107f7c
f0100973:	e8 49 35 00 00       	call   f0103ec1 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f0100978:	8b 1b                	mov    (%ebx),%ebx
f010097a:	83 c4 20             	add    $0x20,%esp
f010097d:	e9 45 ff ff ff       	jmp    f01008c7 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f0100982:	83 ec 0c             	sub    $0xc,%esp
f0100985:	68 92 7f 10 f0       	push   $0xf0107f92
f010098a:	e8 32 35 00 00       	call   f0103ec1 <cprintf>
	return 0;
}
f010098f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100994:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100997:	5b                   	pop    %ebx
f0100998:	5e                   	pop    %esi
f0100999:	5d                   	pop    %ebp
f010099a:	c3                   	ret    

f010099b <mon_showmappings>:
	cycles_t end = currentcycles();
	cprintf("%s cycles: %ul\n", fun_n, end - start);
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f010099b:	55                   	push   %ebp
f010099c:	89 e5                	mov    %esp,%ebp
f010099e:	57                   	push   %edi
f010099f:	56                   	push   %esi
f01009a0:	53                   	push   %ebx
f01009a1:	83 ec 2c             	sub    $0x2c,%esp
	if(argc != 3){
f01009a4:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f01009a8:	75 3f                	jne    f01009e9 <mon_showmappings+0x4e>
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
		return 0;
	}
	uint32_t low_va = 0, high_va = 0, old_va;
	if(argv[1][0]!='0'||argv[1][1]!='x'||argv[2][0]!='0'||argv[2][1]!='x'){
f01009aa:	8b 45 0c             	mov    0xc(%ebp),%eax
f01009ad:	8b 40 04             	mov    0x4(%eax),%eax
f01009b0:	80 38 30             	cmpb   $0x30,(%eax)
f01009b3:	75 17                	jne    f01009cc <mon_showmappings+0x31>
f01009b5:	80 78 01 78          	cmpb   $0x78,0x1(%eax)
f01009b9:	75 11                	jne    f01009cc <mon_showmappings+0x31>
f01009bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01009be:	8b 51 08             	mov    0x8(%ecx),%edx
f01009c1:	80 3a 30             	cmpb   $0x30,(%edx)
f01009c4:	75 06                	jne    f01009cc <mon_showmappings+0x31>
f01009c6:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01009ca:	74 34                	je     f0100a00 <mon_showmappings+0x65>
		cprintf("the virtual-address should be 16-base\n");
f01009cc:	83 ec 0c             	sub    $0xc,%esp
f01009cf:	68 c0 81 10 f0       	push   $0xf01081c0
f01009d4:	e8 e8 34 00 00       	call   f0103ec1 <cprintf>
		return 0;
f01009d9:	83 c4 10             	add    $0x10,%esp
		low_va += PTSIZE;
		if(low_va <= old_va)
			break;
    }
    return 0;
}
f01009dc:	b8 00 00 00 00       	mov    $0x0,%eax
f01009e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01009e4:	5b                   	pop    %ebx
f01009e5:	5e                   	pop    %esi
f01009e6:	5f                   	pop    %edi
f01009e7:	5d                   	pop    %ebp
f01009e8:	c3                   	ret    
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
f01009e9:	83 ec 08             	sub    $0x8,%esp
f01009ec:	68 40 83 10 f0       	push   $0xf0108340
f01009f1:	68 84 81 10 f0       	push   $0xf0108184
f01009f6:	e8 c6 34 00 00       	call   f0103ec1 <cprintf>
		return 0;
f01009fb:	83 c4 10             	add    $0x10,%esp
f01009fe:	eb dc                	jmp    f01009dc <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f0100a00:	83 ec 04             	sub    $0x4,%esp
f0100a03:	6a 10                	push   $0x10
f0100a05:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f0100a08:	56                   	push   %esi
f0100a09:	50                   	push   %eax
f0100a0a:	e8 81 5c 00 00       	call   f0106690 <strtol>
f0100a0f:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a11:	83 c4 0c             	add    $0xc,%esp
f0100a14:	6a 10                	push   $0x10
f0100a16:	56                   	push   %esi
f0100a17:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a1a:	ff 70 08             	pushl  0x8(%eax)
f0100a1d:	e8 6e 5c 00 00       	call   f0106690 <strtol>
	low_va = low_va/PGSIZE * PGSIZE;
f0100a22:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	high_va = high_va/PGSIZE * PGSIZE;
f0100a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(low_va > high_va){
f0100a30:	83 c4 10             	add    $0x10,%esp
f0100a33:	39 c3                	cmp    %eax,%ebx
f0100a35:	0f 86 1c 01 00 00    	jbe    f0100b57 <mon_showmappings+0x1bc>
		cprintf("the start-va should < the end-va\n");
f0100a3b:	83 ec 0c             	sub    $0xc,%esp
f0100a3e:	68 e8 81 10 f0       	push   $0xf01081e8
f0100a43:	e8 79 34 00 00       	call   f0103ec1 <cprintf>
		return 0;
f0100a48:	83 c4 10             	add    $0x10,%esp
f0100a4b:	eb 8f                	jmp    f01009dc <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100a4d:	83 ec 04             	sub    $0x4,%esp
f0100a50:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100a56:	50                   	push   %eax
f0100a57:	53                   	push   %ebx
f0100a58:	68 a5 7f 10 f0       	push   $0xf0107fa5
f0100a5d:	e8 5f 34 00 00       	call   f0103ec1 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100a62:	8b 06                	mov    (%esi),%eax
f0100a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a69:	83 c4 0c             	add    $0xc,%esp
f0100a6c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100a72:	52                   	push   %edx
f0100a73:	50                   	push   %eax
f0100a74:	68 b4 7f 10 f0       	push   $0xf0107fb4
f0100a79:	e8 43 34 00 00       	call   f0103ec1 <cprintf>
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a7e:	83 c4 0c             	add    $0xc,%esp
f0100a81:	89 f8                	mov    %edi,%eax
f0100a83:	83 e0 01             	and    $0x1,%eax
f0100a86:	50                   	push   %eax
					u_bit = pte[PTX(low_va)] & PTE_U;
f0100a87:	89 f8                	mov    %edi,%eax
f0100a89:	83 e0 04             	and    $0x4,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a8c:	0f be c0             	movsbl %al,%eax
f0100a8f:	50                   	push   %eax
					w_bit = pte[PTX(low_va)] & PTE_W;
f0100a90:	89 f8                	mov    %edi,%eax
f0100a92:	83 e0 02             	and    $0x2,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a95:	0f be c0             	movsbl %al,%eax
f0100a98:	50                   	push   %eax
					a_bit = pte[PTX(low_va)] & PTE_A;
f0100a99:	89 f8                	mov    %edi,%eax
f0100a9b:	83 e0 20             	and    $0x20,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a9e:	0f be c0             	movsbl %al,%eax
f0100aa1:	50                   	push   %eax
					d_bit = pte[PTX(low_va)] & PTE_D;
f0100aa2:	89 f8                	mov    %edi,%eax
f0100aa4:	83 e0 40             	and    $0x40,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100aa7:	0f be c0             	movsbl %al,%eax
f0100aaa:	50                   	push   %eax
f0100aab:	6a 00                	push   $0x0
f0100aad:	68 c3 7f 10 f0       	push   $0xf0107fc3
f0100ab2:	e8 0a 34 00 00       	call   f0103ec1 <cprintf>
f0100ab7:	83 c4 20             	add    $0x20,%esp
f0100aba:	e9 dc 00 00 00       	jmp    f0100b9b <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100abf:	83 ec 04             	sub    $0x4,%esp
f0100ac2:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100ac8:	50                   	push   %eax
f0100ac9:	53                   	push   %ebx
f0100aca:	68 a5 7f 10 f0       	push   $0xf0107fa5
f0100acf:	e8 ed 33 00 00       	call   f0103ec1 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100ad4:	8b 07                	mov    (%edi),%eax
f0100ad6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100adb:	83 c4 0c             	add    $0xc,%esp
f0100ade:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100ae4:	52                   	push   %edx
f0100ae5:	50                   	push   %eax
f0100ae6:	68 b4 7f 10 f0       	push   $0xf0107fb4
f0100aeb:	e8 d1 33 00 00       	call   f0103ec1 <cprintf>
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100af0:	83 c4 0c             	add    $0xc,%esp
f0100af3:	89 f0                	mov    %esi,%eax
f0100af5:	83 e0 01             	and    $0x1,%eax
f0100af8:	50                   	push   %eax
				u_bit = *pde & PTE_U;
f0100af9:	89 f0                	mov    %esi,%eax
f0100afb:	83 e0 04             	and    $0x4,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100afe:	0f be c0             	movsbl %al,%eax
f0100b01:	50                   	push   %eax
				w_bit = *pde & PTE_W;
f0100b02:	89 f0                	mov    %esi,%eax
f0100b04:	83 e0 02             	and    $0x2,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b07:	0f be c0             	movsbl %al,%eax
f0100b0a:	50                   	push   %eax
				a_bit = *pde & PTE_A;
f0100b0b:	89 f0                	mov    %esi,%eax
f0100b0d:	83 e0 20             	and    $0x20,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b10:	0f be c0             	movsbl %al,%eax
f0100b13:	50                   	push   %eax
				d_bit = *pde & PTE_D;
f0100b14:	89 f0                	mov    %esi,%eax
f0100b16:	83 e0 40             	and    $0x40,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100b19:	0f be c0             	movsbl %al,%eax
f0100b1c:	50                   	push   %eax
f0100b1d:	6a 00                	push   $0x0
f0100b1f:	68 c3 7f 10 f0       	push   $0xf0107fc3
f0100b24:	e8 98 33 00 00       	call   f0103ec1 <cprintf>
				low_va += PTSIZE;
f0100b29:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
				if(low_va <= old_va)
f0100b2f:	83 c4 20             	add    $0x20,%esp
f0100b32:	39 d8                	cmp    %ebx,%eax
f0100b34:	0f 86 a2 fe ff ff    	jbe    f01009dc <mon_showmappings+0x41>
				low_va += PTSIZE;
f0100b3a:	89 c3                	mov    %eax,%ebx
f0100b3c:	eb 10                	jmp    f0100b4e <mon_showmappings+0x1b3>
		low_va += PTSIZE;
f0100b3e:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
		if(low_va <= old_va)
f0100b44:	39 d8                	cmp    %ebx,%eax
f0100b46:	0f 86 90 fe ff ff    	jbe    f01009dc <mon_showmappings+0x41>
		low_va += PTSIZE;
f0100b4c:	89 c3                	mov    %eax,%ebx
    while (low_va <= high_va) {
f0100b4e:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0100b51:	0f 87 85 fe ff ff    	ja     f01009dc <mon_showmappings+0x41>
        pde_t *pde = &kern_pgdir[PDX(low_va)];
f0100b57:	89 da                	mov    %ebx,%edx
f0100b59:	c1 ea 16             	shr    $0x16,%edx
f0100b5c:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0100b61:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if (*pde) {
f0100b64:	8b 37                	mov    (%edi),%esi
f0100b66:	85 f6                	test   %esi,%esi
f0100b68:	74 d4                	je     f0100b3e <mon_showmappings+0x1a3>
            if (low_va < (uint32_t)KERNBASE) {
f0100b6a:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100b70:	0f 87 49 ff ff ff    	ja     f0100abf <mon_showmappings+0x124>
                pte_t *pte = (pte_t*)(PTE_ADDR(*pde)+KERNBASE);
f0100b76:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
				if(pte[PTX(low_va)] & PTE_P){
f0100b7c:	89 d8                	mov    %ebx,%eax
f0100b7e:	c1 e8 0a             	shr    $0xa,%eax
f0100b81:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100b86:	8d b4 06 00 00 00 f0 	lea    -0x10000000(%esi,%eax,1),%esi
f0100b8d:	8b 3e                	mov    (%esi),%edi
f0100b8f:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0100b95:	0f 85 b2 fe ff ff    	jne    f0100a4d <mon_showmappings+0xb2>
				low_va += PGSIZE;
f0100b9b:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
				if(low_va <= old_va)
f0100ba1:	39 d8                	cmp    %ebx,%eax
f0100ba3:	0f 86 33 fe ff ff    	jbe    f01009dc <mon_showmappings+0x41>
				low_va += PGSIZE;
f0100ba9:	89 c3                	mov    %eax,%ebx
f0100bab:	eb a1                	jmp    f0100b4e <mon_showmappings+0x1b3>

f0100bad <mon_time>:
mon_time(int argc, char **argv, struct Trapframe *tf){
f0100bad:	55                   	push   %ebp
f0100bae:	89 e5                	mov    %esp,%ebp
f0100bb0:	57                   	push   %edi
f0100bb1:	56                   	push   %esi
f0100bb2:	53                   	push   %ebx
f0100bb3:	83 ec 1c             	sub    $0x1c,%esp
f0100bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
	char *fun_n = argv[1];
f0100bb9:	8b 78 04             	mov    0x4(%eax),%edi
	if(argc != 2)
f0100bbc:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100bc0:	0f 85 84 00 00 00    	jne    f0100c4a <mon_time+0x9d>
	for(int i = 0; i < command_size; i++){
f0100bc6:	bb 00 00 00 00       	mov    $0x0,%ebx
	cycles_t start = 0;
f0100bcb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0100bd2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100bd9:	83 c0 08             	add    $0x8,%eax
f0100bdc:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100bdf:	eb 20                	jmp    f0100c01 <mon_time+0x54>
	}
}

cycles_t currentcycles() {
    cycles_t result;
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100be1:	0f 31                	rdtsc  
f0100be3:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100be6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100be9:	83 ec 04             	sub    $0x4,%esp
f0100bec:	ff 75 10             	pushl  0x10(%ebp)
f0100bef:	ff 75 dc             	pushl  -0x24(%ebp)
f0100bf2:	6a 00                	push   $0x0
f0100bf4:	ff 14 b5 68 83 10 f0 	call   *-0xfef7c98(,%esi,4)
f0100bfb:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100bfe:	83 c3 01             	add    $0x1,%ebx
f0100c01:	39 1d 00 83 12 f0    	cmp    %ebx,0xf0128300
f0100c07:	7e 1c                	jle    f0100c25 <mon_time+0x78>
f0100c09:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c0c:	83 ec 08             	sub    $0x8,%esp
f0100c0f:	57                   	push   %edi
f0100c10:	ff 34 b5 60 83 10 f0 	pushl  -0xfef7ca0(,%esi,4)
f0100c17:	e8 c3 58 00 00       	call   f01064df <strcmp>
f0100c1c:	83 c4 10             	add    $0x10,%esp
f0100c1f:	85 c0                	test   %eax,%eax
f0100c21:	75 db                	jne    f0100bfe <mon_time+0x51>
f0100c23:	eb bc                	jmp    f0100be1 <mon_time+0x34>
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c25:	0f 31                	rdtsc  
	cprintf("%s cycles: %ul\n", fun_n, end - start);
f0100c27:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100c2a:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
f0100c2d:	52                   	push   %edx
f0100c2e:	50                   	push   %eax
f0100c2f:	57                   	push   %edi
f0100c30:	68 d6 7f 10 f0       	push   $0xf0107fd6
f0100c35:	e8 87 32 00 00       	call   f0103ec1 <cprintf>
	return 0;
f0100c3a:	83 c4 10             	add    $0x10,%esp
f0100c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c45:	5b                   	pop    %ebx
f0100c46:	5e                   	pop    %esi
f0100c47:	5f                   	pop    %edi
f0100c48:	5d                   	pop    %ebp
f0100c49:	c3                   	ret    
		return -1;
f0100c4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c4f:	eb f1                	jmp    f0100c42 <mon_time+0x95>

f0100c51 <monitor>:
{
f0100c51:	55                   	push   %ebp
f0100c52:	89 e5                	mov    %esp,%ebp
f0100c54:	57                   	push   %edi
f0100c55:	56                   	push   %esi
f0100c56:	53                   	push   %ebx
f0100c57:	83 ec 58             	sub    $0x58,%esp
	cprintf("Welcome to the JOS kernel monitor!\n");
f0100c5a:	68 0c 82 10 f0       	push   $0xf010820c
f0100c5f:	e8 5d 32 00 00       	call   f0103ec1 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c64:	c7 04 24 30 82 10 f0 	movl   $0xf0108230,(%esp)
f0100c6b:	e8 51 32 00 00       	call   f0103ec1 <cprintf>
	if (tf != NULL)
f0100c70:	83 c4 10             	add    $0x10,%esp
f0100c73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100c77:	0f 84 d9 00 00 00    	je     f0100d56 <monitor+0x105>
		print_trapframe(tf);
f0100c7d:	83 ec 0c             	sub    $0xc,%esp
f0100c80:	ff 75 08             	pushl  0x8(%ebp)
f0100c83:	e8 c4 39 00 00       	call   f010464c <print_trapframe>
f0100c88:	83 c4 10             	add    $0x10,%esp
f0100c8b:	e9 c6 00 00 00       	jmp    f0100d56 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100c90:	83 ec 08             	sub    $0x8,%esp
f0100c93:	0f be c0             	movsbl %al,%eax
f0100c96:	50                   	push   %eax
f0100c97:	68 ea 7f 10 f0       	push   $0xf0107fea
f0100c9c:	e8 9c 58 00 00       	call   f010653d <strchr>
f0100ca1:	83 c4 10             	add    $0x10,%esp
f0100ca4:	85 c0                	test   %eax,%eax
f0100ca6:	74 63                	je     f0100d0b <monitor+0xba>
			*buf++ = 0;
f0100ca8:	c6 03 00             	movb   $0x0,(%ebx)
f0100cab:	89 f7                	mov    %esi,%edi
f0100cad:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100cb0:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100cb2:	0f b6 03             	movzbl (%ebx),%eax
f0100cb5:	84 c0                	test   %al,%al
f0100cb7:	75 d7                	jne    f0100c90 <monitor+0x3f>
	argv[argc] = 0;
f0100cb9:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100cc0:	00 
	if (argc == 0)
f0100cc1:	85 f6                	test   %esi,%esi
f0100cc3:	0f 84 8d 00 00 00    	je     f0100d56 <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100cc9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100cce:	83 ec 08             	sub    $0x8,%esp
f0100cd1:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100cd4:	ff 34 85 60 83 10 f0 	pushl  -0xfef7ca0(,%eax,4)
f0100cdb:	ff 75 a8             	pushl  -0x58(%ebp)
f0100cde:	e8 fc 57 00 00       	call   f01064df <strcmp>
f0100ce3:	83 c4 10             	add    $0x10,%esp
f0100ce6:	85 c0                	test   %eax,%eax
f0100ce8:	0f 84 8f 00 00 00    	je     f0100d7d <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100cee:	83 c3 01             	add    $0x1,%ebx
f0100cf1:	83 fb 05             	cmp    $0x5,%ebx
f0100cf4:	75 d8                	jne    f0100cce <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100cf6:	83 ec 08             	sub    $0x8,%esp
f0100cf9:	ff 75 a8             	pushl  -0x58(%ebp)
f0100cfc:	68 0c 80 10 f0       	push   $0xf010800c
f0100d01:	e8 bb 31 00 00       	call   f0103ec1 <cprintf>
f0100d06:	83 c4 10             	add    $0x10,%esp
f0100d09:	eb 4b                	jmp    f0100d56 <monitor+0x105>
		if (*buf == 0)
f0100d0b:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100d0e:	74 a9                	je     f0100cb9 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100d10:	83 fe 0f             	cmp    $0xf,%esi
f0100d13:	74 2f                	je     f0100d44 <monitor+0xf3>
		argv[argc++] = buf;
f0100d15:	8d 7e 01             	lea    0x1(%esi),%edi
f0100d18:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100d1c:	0f b6 03             	movzbl (%ebx),%eax
f0100d1f:	84 c0                	test   %al,%al
f0100d21:	74 8d                	je     f0100cb0 <monitor+0x5f>
f0100d23:	83 ec 08             	sub    $0x8,%esp
f0100d26:	0f be c0             	movsbl %al,%eax
f0100d29:	50                   	push   %eax
f0100d2a:	68 ea 7f 10 f0       	push   $0xf0107fea
f0100d2f:	e8 09 58 00 00       	call   f010653d <strchr>
f0100d34:	83 c4 10             	add    $0x10,%esp
f0100d37:	85 c0                	test   %eax,%eax
f0100d39:	0f 85 71 ff ff ff    	jne    f0100cb0 <monitor+0x5f>
			buf++;
f0100d3f:	83 c3 01             	add    $0x1,%ebx
f0100d42:	eb d8                	jmp    f0100d1c <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d44:	83 ec 08             	sub    $0x8,%esp
f0100d47:	6a 10                	push   $0x10
f0100d49:	68 ef 7f 10 f0       	push   $0xf0107fef
f0100d4e:	e8 6e 31 00 00       	call   f0103ec1 <cprintf>
f0100d53:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100d56:	83 ec 0c             	sub    $0xc,%esp
f0100d59:	68 e6 7f 10 f0       	push   $0xf0107fe6
f0100d5e:	e8 aa 55 00 00       	call   f010630d <readline>
f0100d63:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100d65:	83 c4 10             	add    $0x10,%esp
f0100d68:	85 c0                	test   %eax,%eax
f0100d6a:	74 ea                	je     f0100d56 <monitor+0x105>
	argv[argc] = 0;
f0100d6c:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100d73:	be 00 00 00 00       	mov    $0x0,%esi
f0100d78:	e9 35 ff ff ff       	jmp    f0100cb2 <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100d7d:	83 ec 04             	sub    $0x4,%esp
f0100d80:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100d83:	ff 75 08             	pushl  0x8(%ebp)
f0100d86:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100d89:	52                   	push   %edx
f0100d8a:	56                   	push   %esi
f0100d8b:	ff 14 85 68 83 10 f0 	call   *-0xfef7c98(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100d92:	83 c4 10             	add    $0x10,%esp
f0100d95:	85 c0                	test   %eax,%eax
f0100d97:	79 bd                	jns    f0100d56 <monitor+0x105>
}
f0100d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d9c:	5b                   	pop    %ebx
f0100d9d:	5e                   	pop    %esi
f0100d9e:	5f                   	pop    %edi
f0100d9f:	5d                   	pop    %ebp
f0100da0:	c3                   	ret    

f0100da1 <currentcycles>:
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100da1:	0f 31                	rdtsc  
    return result;
}
f0100da3:	c3                   	ret    

f0100da4 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100da4:	55                   	push   %ebp
f0100da5:	89 e5                	mov    %esp,%ebp
f0100da7:	56                   	push   %esi
f0100da8:	53                   	push   %ebx
f0100da9:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100dab:	83 ec 0c             	sub    $0xc,%esp
f0100dae:	50                   	push   %eax
f0100daf:	e8 66 2f 00 00       	call   f0103d1a <mc146818_read>
f0100db4:	89 c3                	mov    %eax,%ebx
f0100db6:	83 c6 01             	add    $0x1,%esi
f0100db9:	89 34 24             	mov    %esi,(%esp)
f0100dbc:	e8 59 2f 00 00       	call   f0103d1a <mc146818_read>
f0100dc1:	c1 e0 08             	shl    $0x8,%eax
f0100dc4:	09 d8                	or     %ebx,%eax
}
f0100dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100dc9:	5b                   	pop    %ebx
f0100dca:	5e                   	pop    %esi
f0100dcb:	5d                   	pop    %ebp
f0100dcc:	c3                   	ret    

f0100dcd <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100dcd:	89 d1                	mov    %edx,%ecx
f0100dcf:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100dd2:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100dd5:	a8 01                	test   $0x1,%al
f0100dd7:	74 52                	je     f0100e2b <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100dd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100dde:	89 c1                	mov    %eax,%ecx
f0100de0:	c1 e9 0c             	shr    $0xc,%ecx
f0100de3:	3b 0d a8 fe 57 f0    	cmp    0xf057fea8,%ecx
f0100de9:	73 25                	jae    f0100e10 <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100deb:	c1 ea 0c             	shr    $0xc,%edx
f0100dee:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100df4:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100dfb:	89 c2                	mov    %eax,%edx
f0100dfd:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100e00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e05:	85 d2                	test   %edx,%edx
f0100e07:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100e0c:	0f 44 c2             	cmove  %edx,%eax
f0100e0f:	c3                   	ret    
{
f0100e10:	55                   	push   %ebp
f0100e11:	89 e5                	mov    %esp,%ebp
f0100e13:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e16:	50                   	push   %eax
f0100e17:	68 14 7c 10 f0       	push   $0xf0107c14
f0100e1c:	68 ad 03 00 00       	push   $0x3ad
f0100e21:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100e26:	e8 1e f2 ff ff       	call   f0100049 <_panic>
		return ~0;
f0100e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100e30:	c3                   	ret    

f0100e31 <boot_alloc>:
{
f0100e31:	55                   	push   %ebp
f0100e32:	89 e5                	mov    %esp,%ebp
f0100e34:	53                   	push   %ebx
f0100e35:	83 ec 04             	sub    $0x4,%esp
	if (!nextfree) {
f0100e38:	83 3d 38 e2 57 f0 00 	cmpl   $0x0,0xf057e238
f0100e3f:	74 40                	je     f0100e81 <boot_alloc+0x50>
	if(!n)
f0100e41:	85 c0                	test   %eax,%eax
f0100e43:	74 65                	je     f0100eaa <boot_alloc+0x79>
f0100e45:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100e47:	a1 38 e2 57 f0       	mov    0xf057e238,%eax
	if ((uint32_t)kva < KERNBASE)
f0100e4c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e51:	76 5e                	jbe    f0100eb1 <boot_alloc+0x80>
f0100e53:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100e5a:	c1 e9 0c             	shr    $0xc,%ecx
f0100e5d:	83 c1 01             	add    $0x1,%ecx
f0100e60:	3b 0d a8 fe 57 f0    	cmp    0xf057fea8,%ecx
f0100e66:	77 5b                	ja     f0100ec3 <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100e68:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e6e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e74:	01 c2                	add    %eax,%edx
f0100e76:	89 15 38 e2 57 f0    	mov    %edx,0xf057e238
}
f0100e7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100e7f:	c9                   	leave  
f0100e80:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e81:	b9 40 ec 67 f0       	mov    $0xf067ec40,%ecx
f0100e86:	ba 3f fc 67 f0       	mov    $0xf067fc3f,%edx
f0100e8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100e91:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e97:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100e9d:	85 c9                	test   %ecx,%ecx
f0100e9f:	0f 44 d3             	cmove  %ebx,%edx
f0100ea2:	89 15 38 e2 57 f0    	mov    %edx,0xf057e238
f0100ea8:	eb 97                	jmp    f0100e41 <boot_alloc+0x10>
		return nextfree;
f0100eaa:	a1 38 e2 57 f0       	mov    0xf057e238,%eax
f0100eaf:	eb cb                	jmp    f0100e7c <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100eb1:	50                   	push   %eax
f0100eb2:	68 38 7c 10 f0       	push   $0xf0107c38
f0100eb7:	6a 72                	push   $0x72
f0100eb9:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100ebe:	e8 86 f1 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100ec3:	83 ec 04             	sub    $0x4,%esp
f0100ec6:	68 9c 83 10 f0       	push   $0xf010839c
f0100ecb:	6a 73                	push   $0x73
f0100ecd:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100ed2:	e8 72 f1 ff ff       	call   f0100049 <_panic>

f0100ed7 <check_page_free_list>:
{
f0100ed7:	55                   	push   %ebp
f0100ed8:	89 e5                	mov    %esp,%ebp
f0100eda:	57                   	push   %edi
f0100edb:	56                   	push   %esi
f0100edc:	53                   	push   %ebx
f0100edd:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ee0:	84 c0                	test   %al,%al
f0100ee2:	0f 85 77 02 00 00    	jne    f010115f <check_page_free_list+0x288>
	if (!page_free_list)
f0100ee8:	83 3d 40 e2 57 f0 00 	cmpl   $0x0,0xf057e240
f0100eef:	74 0a                	je     f0100efb <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ef1:	be 00 04 00 00       	mov    $0x400,%esi
f0100ef6:	e9 bf 02 00 00       	jmp    f01011ba <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100efb:	83 ec 04             	sub    $0x4,%esp
f0100efe:	68 d4 83 10 f0       	push   $0xf01083d4
f0100f03:	68 dd 02 00 00       	push   $0x2dd
f0100f08:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100f0d:	e8 37 f1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f12:	50                   	push   %eax
f0100f13:	68 14 7c 10 f0       	push   $0xf0107c14
f0100f18:	6a 58                	push   $0x58
f0100f1a:	68 b1 8d 10 f0       	push   $0xf0108db1
f0100f1f:	e8 25 f1 ff ff       	call   f0100049 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0100f24:	8b 1b                	mov    (%ebx),%ebx
f0100f26:	85 db                	test   %ebx,%ebx
f0100f28:	74 41                	je     f0100f6b <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100f2a:	89 d8                	mov    %ebx,%eax
f0100f2c:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f0100f32:	c1 f8 03             	sar    $0x3,%eax
f0100f35:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100f38:	89 c2                	mov    %eax,%edx
f0100f3a:	c1 ea 16             	shr    $0x16,%edx
f0100f3d:	39 f2                	cmp    %esi,%edx
f0100f3f:	73 e3                	jae    f0100f24 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100f41:	89 c2                	mov    %eax,%edx
f0100f43:	c1 ea 0c             	shr    $0xc,%edx
f0100f46:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0100f4c:	73 c4                	jae    f0100f12 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100f4e:	83 ec 04             	sub    $0x4,%esp
f0100f51:	68 80 00 00 00       	push   $0x80
f0100f56:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100f5b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f60:	50                   	push   %eax
f0100f61:	e8 14 56 00 00       	call   f010657a <memset>
f0100f66:	83 c4 10             	add    $0x10,%esp
f0100f69:	eb b9                	jmp    f0100f24 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100f6b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f70:	e8 bc fe ff ff       	call   f0100e31 <boot_alloc>
f0100f75:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f78:	8b 15 40 e2 57 f0    	mov    0xf057e240,%edx
		assert(pp >= pages);
f0100f7e:	8b 0d b0 fe 57 f0    	mov    0xf057feb0,%ecx
		assert(pp < pages + npages);
f0100f84:	a1 a8 fe 57 f0       	mov    0xf057fea8,%eax
f0100f89:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f8c:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100f8f:	bf 00 00 00 00       	mov    $0x0,%edi
f0100f94:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f97:	e9 f9 00 00 00       	jmp    f0101095 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100f9c:	68 bf 8d 10 f0       	push   $0xf0108dbf
f0100fa1:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0100fa6:	68 f6 02 00 00       	push   $0x2f6
f0100fab:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100fb0:	e8 94 f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0100fb5:	68 e0 8d 10 f0       	push   $0xf0108de0
f0100fba:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0100fbf:	68 f7 02 00 00       	push   $0x2f7
f0100fc4:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100fc9:	e8 7b f0 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100fce:	68 f8 83 10 f0       	push   $0xf01083f8
f0100fd3:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0100fd8:	68 f8 02 00 00       	push   $0x2f8
f0100fdd:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100fe2:	e8 62 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0100fe7:	68 f4 8d 10 f0       	push   $0xf0108df4
f0100fec:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0100ff1:	68 fb 02 00 00       	push   $0x2fb
f0100ff6:	68 a5 8d 10 f0       	push   $0xf0108da5
f0100ffb:	e8 49 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101000:	68 05 8e 10 f0       	push   $0xf0108e05
f0101005:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010100a:	68 fc 02 00 00       	push   $0x2fc
f010100f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101014:	e8 30 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101019:	68 2c 84 10 f0       	push   $0xf010842c
f010101e:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101023:	68 fd 02 00 00       	push   $0x2fd
f0101028:	68 a5 8d 10 f0       	push   $0xf0108da5
f010102d:	e8 17 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101032:	68 1e 8e 10 f0       	push   $0xf0108e1e
f0101037:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010103c:	68 fe 02 00 00       	push   $0x2fe
f0101041:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101046:	e8 fe ef ff ff       	call   f0100049 <_panic>
	if (PGNUM(pa) >= npages)
f010104b:	89 c3                	mov    %eax,%ebx
f010104d:	c1 eb 0c             	shr    $0xc,%ebx
f0101050:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0101053:	76 0f                	jbe    f0101064 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0101055:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f010105a:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f010105d:	77 17                	ja     f0101076 <check_page_free_list+0x19f>
			++nfree_extmem;
f010105f:	83 c7 01             	add    $0x1,%edi
f0101062:	eb 2f                	jmp    f0101093 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101064:	50                   	push   %eax
f0101065:	68 14 7c 10 f0       	push   $0xf0107c14
f010106a:	6a 58                	push   $0x58
f010106c:	68 b1 8d 10 f0       	push   $0xf0108db1
f0101071:	e8 d3 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101076:	68 50 84 10 f0       	push   $0xf0108450
f010107b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101080:	68 ff 02 00 00       	push   $0x2ff
f0101085:	68 a5 8d 10 f0       	push   $0xf0108da5
f010108a:	e8 ba ef ff ff       	call   f0100049 <_panic>
			++nfree_basemem;
f010108f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101093:	8b 12                	mov    (%edx),%edx
f0101095:	85 d2                	test   %edx,%edx
f0101097:	74 74                	je     f010110d <check_page_free_list+0x236>
		assert(pp >= pages);
f0101099:	39 d1                	cmp    %edx,%ecx
f010109b:	0f 87 fb fe ff ff    	ja     f0100f9c <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f01010a1:	39 d6                	cmp    %edx,%esi
f01010a3:	0f 86 0c ff ff ff    	jbe    f0100fb5 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01010a9:	89 d0                	mov    %edx,%eax
f01010ab:	29 c8                	sub    %ecx,%eax
f01010ad:	a8 07                	test   $0x7,%al
f01010af:	0f 85 19 ff ff ff    	jne    f0100fce <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f01010b5:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f01010b8:	c1 e0 0c             	shl    $0xc,%eax
f01010bb:	0f 84 26 ff ff ff    	je     f0100fe7 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f01010c1:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f01010c6:	0f 84 34 ff ff ff    	je     f0101000 <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f01010cc:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01010d1:	0f 84 42 ff ff ff    	je     f0101019 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f01010d7:	3d 00 00 10 00       	cmp    $0x100000,%eax
f01010dc:	0f 84 50 ff ff ff    	je     f0101032 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01010e2:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01010e7:	0f 87 5e ff ff ff    	ja     f010104b <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f01010ed:	3d 00 70 00 00       	cmp    $0x7000,%eax
f01010f2:	75 9b                	jne    f010108f <check_page_free_list+0x1b8>
f01010f4:	68 38 8e 10 f0       	push   $0xf0108e38
f01010f9:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01010fe:	68 01 03 00 00       	push   $0x301
f0101103:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101108:	e8 3c ef ff ff       	call   f0100049 <_panic>
f010110d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0101110:	85 db                	test   %ebx,%ebx
f0101112:	7e 19                	jle    f010112d <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0101114:	85 ff                	test   %edi,%edi
f0101116:	7e 2e                	jle    f0101146 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0101118:	83 ec 0c             	sub    $0xc,%esp
f010111b:	68 98 84 10 f0       	push   $0xf0108498
f0101120:	e8 9c 2d 00 00       	call   f0103ec1 <cprintf>
}
f0101125:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101128:	5b                   	pop    %ebx
f0101129:	5e                   	pop    %esi
f010112a:	5f                   	pop    %edi
f010112b:	5d                   	pop    %ebp
f010112c:	c3                   	ret    
	assert(nfree_basemem > 0);
f010112d:	68 55 8e 10 f0       	push   $0xf0108e55
f0101132:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101137:	68 08 03 00 00       	push   $0x308
f010113c:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101141:	e8 03 ef ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f0101146:	68 67 8e 10 f0       	push   $0xf0108e67
f010114b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101150:	68 09 03 00 00       	push   $0x309
f0101155:	68 a5 8d 10 f0       	push   $0xf0108da5
f010115a:	e8 ea ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f010115f:	a1 40 e2 57 f0       	mov    0xf057e240,%eax
f0101164:	85 c0                	test   %eax,%eax
f0101166:	0f 84 8f fd ff ff    	je     f0100efb <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010116c:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010116f:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101172:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101175:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101178:	89 c2                	mov    %eax,%edx
f010117a:	2b 15 b0 fe 57 f0    	sub    0xf057feb0,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0101180:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0101186:	0f 95 c2             	setne  %dl
f0101189:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f010118c:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0101190:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0101192:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101196:	8b 00                	mov    (%eax),%eax
f0101198:	85 c0                	test   %eax,%eax
f010119a:	75 dc                	jne    f0101178 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f010119c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010119f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f01011a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01011a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01011ab:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f01011ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01011b0:	a3 40 e2 57 f0       	mov    %eax,0xf057e240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01011b5:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f01011ba:	8b 1d 40 e2 57 f0    	mov    0xf057e240,%ebx
f01011c0:	e9 61 fd ff ff       	jmp    f0100f26 <check_page_free_list+0x4f>

f01011c5 <page_init>:
{
f01011c5:	55                   	push   %ebp
f01011c6:	89 e5                	mov    %esp,%ebp
f01011c8:	53                   	push   %ebx
f01011c9:	83 ec 04             	sub    $0x4,%esp
	for (size_t i = 0; i < npages; i++) {
f01011cc:	bb 00 00 00 00       	mov    $0x0,%ebx
f01011d1:	eb 4c                	jmp    f010121f <page_init+0x5a>
		else if(i == MPENTRY_PADDR/PGSIZE){
f01011d3:	83 fb 07             	cmp    $0x7,%ebx
f01011d6:	74 32                	je     f010120a <page_init+0x45>
		else if(i < IOPHYSMEM/PGSIZE){ //[PGSIZE, npages_basemem * PGSIZE)
f01011d8:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f01011de:	77 62                	ja     f0101242 <page_init+0x7d>
f01011e0:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f01011e7:	89 c2                	mov    %eax,%edx
f01011e9:	03 15 b0 fe 57 f0    	add    0xf057feb0,%edx
f01011ef:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f01011f5:	8b 0d 40 e2 57 f0    	mov    0xf057e240,%ecx
f01011fb:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f01011fd:	03 05 b0 fe 57 f0    	add    0xf057feb0,%eax
f0101203:	a3 40 e2 57 f0       	mov    %eax,0xf057e240
f0101208:	eb 12                	jmp    f010121c <page_init+0x57>
			pages[i].pp_ref = 1;
f010120a:	a1 b0 fe 57 f0       	mov    0xf057feb0,%eax
f010120f:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f0101215:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f010121c:	83 c3 01             	add    $0x1,%ebx
f010121f:	39 1d a8 fe 57 f0    	cmp    %ebx,0xf057fea8
f0101225:	0f 86 94 00 00 00    	jbe    f01012bf <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f010122b:	85 db                	test   %ebx,%ebx
f010122d:	75 a4                	jne    f01011d3 <page_init+0xe>
			pages[i].pp_ref = 1;
f010122f:	a1 b0 fe 57 f0       	mov    0xf057feb0,%eax
f0101234:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f010123a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101240:	eb da                	jmp    f010121c <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f0101242:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0101248:	77 16                	ja     f0101260 <page_init+0x9b>
			pages[i].pp_ref = 1;
f010124a:	a1 b0 fe 57 f0       	mov    0xf057feb0,%eax
f010124f:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
f0101252:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010125e:	eb bc                	jmp    f010121c <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f0101260:	b8 00 00 00 00       	mov    $0x0,%eax
f0101265:	e8 c7 fb ff ff       	call   f0100e31 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f010126a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010126f:	76 39                	jbe    f01012aa <page_init+0xe5>
	return (physaddr_t)kva - KERNBASE;
f0101271:	05 00 00 00 10       	add    $0x10000000,%eax
f0101276:	c1 e8 0c             	shr    $0xc,%eax
f0101279:	39 d8                	cmp    %ebx,%eax
f010127b:	77 cd                	ja     f010124a <page_init+0x85>
f010127d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f0101284:	89 c2                	mov    %eax,%edx
f0101286:	03 15 b0 fe 57 f0    	add    0xf057feb0,%edx
f010128c:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101292:	8b 0d 40 e2 57 f0    	mov    0xf057e240,%ecx
f0101298:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f010129a:	03 05 b0 fe 57 f0    	add    0xf057feb0,%eax
f01012a0:	a3 40 e2 57 f0       	mov    %eax,0xf057e240
f01012a5:	e9 72 ff ff ff       	jmp    f010121c <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01012aa:	50                   	push   %eax
f01012ab:	68 38 7c 10 f0       	push   $0xf0107c38
f01012b0:	68 4d 01 00 00       	push   $0x14d
f01012b5:	68 a5 8d 10 f0       	push   $0xf0108da5
f01012ba:	e8 8a ed ff ff       	call   f0100049 <_panic>
}
f01012bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012c2:	c9                   	leave  
f01012c3:	c3                   	ret    

f01012c4 <page_alloc>:
{
f01012c4:	55                   	push   %ebp
f01012c5:	89 e5                	mov    %esp,%ebp
f01012c7:	53                   	push   %ebx
f01012c8:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list)
f01012cb:	8b 1d 40 e2 57 f0    	mov    0xf057e240,%ebx
f01012d1:	85 db                	test   %ebx,%ebx
f01012d3:	74 13                	je     f01012e8 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f01012d5:	8b 03                	mov    (%ebx),%eax
f01012d7:	a3 40 e2 57 f0       	mov    %eax,0xf057e240
	result->pp_link = NULL;
f01012dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f01012e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01012e6:	75 07                	jne    f01012ef <page_alloc+0x2b>
}
f01012e8:	89 d8                	mov    %ebx,%eax
f01012ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012ed:	c9                   	leave  
f01012ee:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f01012ef:	89 d8                	mov    %ebx,%eax
f01012f1:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01012f7:	c1 f8 03             	sar    $0x3,%eax
f01012fa:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01012fd:	89 c2                	mov    %eax,%edx
f01012ff:	c1 ea 0c             	shr    $0xc,%edx
f0101302:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0101308:	73 1a                	jae    f0101324 <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f010130a:	83 ec 04             	sub    $0x4,%esp
f010130d:	68 00 10 00 00       	push   $0x1000
f0101312:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101314:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101319:	50                   	push   %eax
f010131a:	e8 5b 52 00 00       	call   f010657a <memset>
f010131f:	83 c4 10             	add    $0x10,%esp
f0101322:	eb c4                	jmp    f01012e8 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101324:	50                   	push   %eax
f0101325:	68 14 7c 10 f0       	push   $0xf0107c14
f010132a:	6a 58                	push   $0x58
f010132c:	68 b1 8d 10 f0       	push   $0xf0108db1
f0101331:	e8 13 ed ff ff       	call   f0100049 <_panic>

f0101336 <page_free>:
{
f0101336:	55                   	push   %ebp
f0101337:	89 e5                	mov    %esp,%ebp
f0101339:	83 ec 08             	sub    $0x8,%esp
f010133c:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0 || pp->pp_link != NULL){
f010133f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101344:	75 14                	jne    f010135a <page_free+0x24>
f0101346:	83 38 00             	cmpl   $0x0,(%eax)
f0101349:	75 0f                	jne    f010135a <page_free+0x24>
	pp->pp_link = page_free_list;
f010134b:	8b 15 40 e2 57 f0    	mov    0xf057e240,%edx
f0101351:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101353:	a3 40 e2 57 f0       	mov    %eax,0xf057e240
}
f0101358:	c9                   	leave  
f0101359:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f010135a:	83 ec 04             	sub    $0x4,%esp
f010135d:	68 bc 84 10 f0       	push   $0xf01084bc
f0101362:	68 81 01 00 00       	push   $0x181
f0101367:	68 a5 8d 10 f0       	push   $0xf0108da5
f010136c:	e8 d8 ec ff ff       	call   f0100049 <_panic>

f0101371 <page_decref>:
{
f0101371:	55                   	push   %ebp
f0101372:	89 e5                	mov    %esp,%ebp
f0101374:	83 ec 08             	sub    $0x8,%esp
f0101377:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f010137a:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010137e:	83 e8 01             	sub    $0x1,%eax
f0101381:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101385:	66 85 c0             	test   %ax,%ax
f0101388:	74 02                	je     f010138c <page_decref+0x1b>
}
f010138a:	c9                   	leave  
f010138b:	c3                   	ret    
		page_free(pp);
f010138c:	83 ec 0c             	sub    $0xc,%esp
f010138f:	52                   	push   %edx
f0101390:	e8 a1 ff ff ff       	call   f0101336 <page_free>
f0101395:	83 c4 10             	add    $0x10,%esp
}
f0101398:	eb f0                	jmp    f010138a <page_decref+0x19>

f010139a <pgdir_walk>:
{
f010139a:	55                   	push   %ebp
f010139b:	89 e5                	mov    %esp,%ebp
f010139d:	56                   	push   %esi
f010139e:	53                   	push   %ebx
f010139f:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *fir_level = &pgdir[PDX(va)];
f01013a2:	89 f3                	mov    %esi,%ebx
f01013a4:	c1 eb 16             	shr    $0x16,%ebx
f01013a7:	c1 e3 02             	shl    $0x2,%ebx
f01013aa:	03 5d 08             	add    0x8(%ebp),%ebx
	if(*fir_level==0 && create == false){
f01013ad:	8b 03                	mov    (%ebx),%eax
f01013af:	89 c1                	mov    %eax,%ecx
f01013b1:	0b 4d 10             	or     0x10(%ebp),%ecx
f01013b4:	0f 84 a8 00 00 00    	je     f0101462 <pgdir_walk+0xc8>
	else if(*fir_level==0){
f01013ba:	85 c0                	test   %eax,%eax
f01013bc:	74 29                	je     f01013e7 <pgdir_walk+0x4d>
		sec_level = (pte_t *)(KADDR(PTE_ADDR(*fir_level)));
f01013be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01013c3:	89 c2                	mov    %eax,%edx
f01013c5:	c1 ea 0c             	shr    $0xc,%edx
f01013c8:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f01013ce:	73 7d                	jae    f010144d <pgdir_walk+0xb3>
		return &sec_level[PTX(va)];
f01013d0:	c1 ee 0a             	shr    $0xa,%esi
f01013d3:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01013d9:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f01013e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01013e3:	5b                   	pop    %ebx
f01013e4:	5e                   	pop    %esi
f01013e5:	5d                   	pop    %ebp
f01013e6:	c3                   	ret    
		struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
f01013e7:	83 ec 0c             	sub    $0xc,%esp
f01013ea:	6a 01                	push   $0x1
f01013ec:	e8 d3 fe ff ff       	call   f01012c4 <page_alloc>
		if(new_page == NULL)
f01013f1:	83 c4 10             	add    $0x10,%esp
f01013f4:	85 c0                	test   %eax,%eax
f01013f6:	74 e8                	je     f01013e0 <pgdir_walk+0x46>
		new_page->pp_ref++;
f01013f8:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01013fd:	89 c2                	mov    %eax,%edx
f01013ff:	2b 15 b0 fe 57 f0    	sub    0xf057feb0,%edx
f0101405:	c1 fa 03             	sar    $0x3,%edx
f0101408:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f010140b:	83 ca 07             	or     $0x7,%edx
f010140e:	89 13                	mov    %edx,(%ebx)
f0101410:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f0101416:	c1 f8 03             	sar    $0x3,%eax
f0101419:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010141c:	89 c2                	mov    %eax,%edx
f010141e:	c1 ea 0c             	shr    $0xc,%edx
f0101421:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0101427:	73 12                	jae    f010143b <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f0101429:	c1 ee 0a             	shr    $0xa,%esi
f010142c:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101432:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0101439:	eb a5                	jmp    f01013e0 <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010143b:	50                   	push   %eax
f010143c:	68 14 7c 10 f0       	push   $0xf0107c14
f0101441:	6a 58                	push   $0x58
f0101443:	68 b1 8d 10 f0       	push   $0xf0108db1
f0101448:	e8 fc eb ff ff       	call   f0100049 <_panic>
f010144d:	50                   	push   %eax
f010144e:	68 14 7c 10 f0       	push   $0xf0107c14
f0101453:	68 bb 01 00 00       	push   $0x1bb
f0101458:	68 a5 8d 10 f0       	push   $0xf0108da5
f010145d:	e8 e7 eb ff ff       	call   f0100049 <_panic>
		return NULL;
f0101462:	b8 00 00 00 00       	mov    $0x0,%eax
f0101467:	e9 74 ff ff ff       	jmp    f01013e0 <pgdir_walk+0x46>

f010146c <boot_map_region>:
{
f010146c:	55                   	push   %ebp
f010146d:	89 e5                	mov    %esp,%ebp
f010146f:	57                   	push   %edi
f0101470:	56                   	push   %esi
f0101471:	53                   	push   %ebx
f0101472:	83 ec 1c             	sub    $0x1c,%esp
f0101475:	89 c7                	mov    %eax,%edi
f0101477:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(va%PGSIZE==0);
f010147a:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0101480:	75 4b                	jne    f01014cd <boot_map_region+0x61>
	assert(pa%PGSIZE==0);
f0101482:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0101487:	75 5d                	jne    f01014e6 <boot_map_region+0x7a>
f0101489:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010148f:	01 c1                	add    %eax,%ecx
f0101491:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0101494:	89 c3                	mov    %eax,%ebx
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f0101496:	89 d6                	mov    %edx,%esi
f0101498:	29 c6                	sub    %eax,%esi
	for(int i = 0; i < size/PGSIZE; i++){
f010149a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010149d:	74 79                	je     f0101518 <boot_map_region+0xac>
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f010149f:	83 ec 04             	sub    $0x4,%esp
f01014a2:	6a 01                	push   $0x1
f01014a4:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01014a7:	50                   	push   %eax
f01014a8:	57                   	push   %edi
f01014a9:	e8 ec fe ff ff       	call   f010139a <pgdir_walk>
		if(the_pte==NULL)
f01014ae:	83 c4 10             	add    $0x10,%esp
f01014b1:	85 c0                	test   %eax,%eax
f01014b3:	74 4a                	je     f01014ff <boot_map_region+0x93>
		*the_pte = PTE_ADDR(pa) | perm | PTE_P;
f01014b5:	89 da                	mov    %ebx,%edx
f01014b7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01014bd:	0b 55 0c             	or     0xc(%ebp),%edx
f01014c0:	83 ca 01             	or     $0x1,%edx
f01014c3:	89 10                	mov    %edx,(%eax)
		pa+=PGSIZE;
f01014c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01014cb:	eb cd                	jmp    f010149a <boot_map_region+0x2e>
	assert(va%PGSIZE==0);
f01014cd:	68 78 8e 10 f0       	push   $0xf0108e78
f01014d2:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01014d7:	68 d0 01 00 00       	push   $0x1d0
f01014dc:	68 a5 8d 10 f0       	push   $0xf0108da5
f01014e1:	e8 63 eb ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f01014e6:	68 85 8e 10 f0       	push   $0xf0108e85
f01014eb:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01014f0:	68 d1 01 00 00       	push   $0x1d1
f01014f5:	68 a5 8d 10 f0       	push   $0xf0108da5
f01014fa:	e8 4a eb ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f01014ff:	68 04 91 10 f0       	push   $0xf0109104
f0101504:	68 92 8e 10 f0       	push   $0xf0108e92
f0101509:	68 d5 01 00 00       	push   $0x1d5
f010150e:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101513:	e8 31 eb ff ff       	call   f0100049 <_panic>
}
f0101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010151b:	5b                   	pop    %ebx
f010151c:	5e                   	pop    %esi
f010151d:	5f                   	pop    %edi
f010151e:	5d                   	pop    %ebp
f010151f:	c3                   	ret    

f0101520 <page_lookup>:
{
f0101520:	55                   	push   %ebp
f0101521:	89 e5                	mov    %esp,%ebp
f0101523:	53                   	push   %ebx
f0101524:	83 ec 08             	sub    $0x8,%esp
f0101527:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *look_mapping = pgdir_walk(pgdir, va, 0);
f010152a:	6a 00                	push   $0x0
f010152c:	ff 75 0c             	pushl  0xc(%ebp)
f010152f:	ff 75 08             	pushl  0x8(%ebp)
f0101532:	e8 63 fe ff ff       	call   f010139a <pgdir_walk>
	if(look_mapping == NULL)
f0101537:	83 c4 10             	add    $0x10,%esp
f010153a:	85 c0                	test   %eax,%eax
f010153c:	74 27                	je     f0101565 <page_lookup+0x45>
	if(*look_mapping==0)
f010153e:	8b 10                	mov    (%eax),%edx
f0101540:	85 d2                	test   %edx,%edx
f0101542:	74 3a                	je     f010157e <page_lookup+0x5e>
	if(pte_store!=NULL && (*look_mapping&PTE_P))
f0101544:	85 db                	test   %ebx,%ebx
f0101546:	74 07                	je     f010154f <page_lookup+0x2f>
f0101548:	f6 c2 01             	test   $0x1,%dl
f010154b:	74 02                	je     f010154f <page_lookup+0x2f>
		*pte_store = look_mapping;
f010154d:	89 03                	mov    %eax,(%ebx)
f010154f:	8b 00                	mov    (%eax),%eax
f0101551:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101554:	39 05 a8 fe 57 f0    	cmp    %eax,0xf057fea8
f010155a:	76 0e                	jbe    f010156a <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010155c:	8b 15 b0 fe 57 f0    	mov    0xf057feb0,%edx
f0101562:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101568:	c9                   	leave  
f0101569:	c3                   	ret    
		panic("pa2page called with invalid pa");
f010156a:	83 ec 04             	sub    $0x4,%esp
f010156d:	68 f0 84 10 f0       	push   $0xf01084f0
f0101572:	6a 51                	push   $0x51
f0101574:	68 b1 8d 10 f0       	push   $0xf0108db1
f0101579:	e8 cb ea ff ff       	call   f0100049 <_panic>
		return NULL;
f010157e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101583:	eb e0                	jmp    f0101565 <page_lookup+0x45>

f0101585 <tlb_invalidate>:
{
f0101585:	55                   	push   %ebp
f0101586:	89 e5                	mov    %esp,%ebp
f0101588:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f010158b:	e8 f2 55 00 00       	call   f0106b82 <cpunum>
f0101590:	6b c0 74             	imul   $0x74,%eax,%eax
f0101593:	83 b8 28 00 58 f0 00 	cmpl   $0x0,-0xfa7ffd8(%eax)
f010159a:	74 16                	je     f01015b2 <tlb_invalidate+0x2d>
f010159c:	e8 e1 55 00 00       	call   f0106b82 <cpunum>
f01015a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01015a4:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01015aa:	8b 55 08             	mov    0x8(%ebp),%edx
f01015ad:	39 50 60             	cmp    %edx,0x60(%eax)
f01015b0:	75 06                	jne    f01015b8 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015b5:	0f 01 38             	invlpg (%eax)
}
f01015b8:	c9                   	leave  
f01015b9:	c3                   	ret    

f01015ba <page_remove>:
{
f01015ba:	55                   	push   %ebp
f01015bb:	89 e5                	mov    %esp,%ebp
f01015bd:	56                   	push   %esi
f01015be:	53                   	push   %ebx
f01015bf:	83 ec 14             	sub    $0x14,%esp
f01015c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01015c5:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *the_page = page_lookup(pgdir, va, &pg_store);
f01015c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01015cb:	50                   	push   %eax
f01015cc:	56                   	push   %esi
f01015cd:	53                   	push   %ebx
f01015ce:	e8 4d ff ff ff       	call   f0101520 <page_lookup>
	if(!the_page)
f01015d3:	83 c4 10             	add    $0x10,%esp
f01015d6:	85 c0                	test   %eax,%eax
f01015d8:	74 1f                	je     f01015f9 <page_remove+0x3f>
	page_decref(the_page);
f01015da:	83 ec 0c             	sub    $0xc,%esp
f01015dd:	50                   	push   %eax
f01015de:	e8 8e fd ff ff       	call   f0101371 <page_decref>
	*pg_store = 0;
f01015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01015e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f01015ec:	83 c4 08             	add    $0x8,%esp
f01015ef:	56                   	push   %esi
f01015f0:	53                   	push   %ebx
f01015f1:	e8 8f ff ff ff       	call   f0101585 <tlb_invalidate>
f01015f6:	83 c4 10             	add    $0x10,%esp
}
f01015f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01015fc:	5b                   	pop    %ebx
f01015fd:	5e                   	pop    %esi
f01015fe:	5d                   	pop    %ebp
f01015ff:	c3                   	ret    

f0101600 <page_insert>:
{
f0101600:	55                   	push   %ebp
f0101601:	89 e5                	mov    %esp,%ebp
f0101603:	57                   	push   %edi
f0101604:	56                   	push   %esi
f0101605:	53                   	push   %ebx
f0101606:	83 ec 10             	sub    $0x10,%esp
f0101609:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *the_pte = pgdir_walk(pgdir, va, 1);
f010160c:	6a 01                	push   $0x1
f010160e:	ff 75 10             	pushl  0x10(%ebp)
f0101611:	ff 75 08             	pushl  0x8(%ebp)
f0101614:	e8 81 fd ff ff       	call   f010139a <pgdir_walk>
	if(the_pte == NULL){
f0101619:	83 c4 10             	add    $0x10,%esp
f010161c:	85 c0                	test   %eax,%eax
f010161e:	0f 84 b7 00 00 00    	je     f01016db <page_insert+0xdb>
f0101624:	89 c6                	mov    %eax,%esi
		if(KADDR(PTE_ADDR(*the_pte)) == page2kva(pp)){
f0101626:	8b 10                	mov    (%eax),%edx
f0101628:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f010162e:	8b 0d a8 fe 57 f0    	mov    0xf057fea8,%ecx
f0101634:	89 d0                	mov    %edx,%eax
f0101636:	c1 e8 0c             	shr    $0xc,%eax
f0101639:	39 c1                	cmp    %eax,%ecx
f010163b:	76 5f                	jbe    f010169c <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f010163d:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f0101643:	89 d8                	mov    %ebx,%eax
f0101645:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f010164b:	c1 f8 03             	sar    $0x3,%eax
f010164e:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101651:	89 c7                	mov    %eax,%edi
f0101653:	c1 ef 0c             	shr    $0xc,%edi
f0101656:	39 f9                	cmp    %edi,%ecx
f0101658:	76 57                	jbe    f01016b1 <page_insert+0xb1>
	return (void *)(pa + KERNBASE);
f010165a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010165f:	39 c2                	cmp    %eax,%edx
f0101661:	74 60                	je     f01016c3 <page_insert+0xc3>
			page_remove(pgdir, va);
f0101663:	83 ec 08             	sub    $0x8,%esp
f0101666:	ff 75 10             	pushl  0x10(%ebp)
f0101669:	ff 75 08             	pushl  0x8(%ebp)
f010166c:	e8 49 ff ff ff       	call   f01015ba <page_remove>
f0101671:	83 c4 10             	add    $0x10,%esp
	return (pp - pages) << PGSHIFT;
f0101674:	89 d8                	mov    %ebx,%eax
f0101676:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f010167c:	c1 f8 03             	sar    $0x3,%eax
f010167f:	c1 e0 0c             	shl    $0xc,%eax
	*the_pte = page2pa(pp) | perm | PTE_P;
f0101682:	0b 45 14             	or     0x14(%ebp),%eax
f0101685:	83 c8 01             	or     $0x1,%eax
f0101688:	89 06                	mov    %eax,(%esi)
	pp->pp_ref++;
f010168a:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	return 0;
f010168f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101694:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101697:	5b                   	pop    %ebx
f0101698:	5e                   	pop    %esi
f0101699:	5f                   	pop    %edi
f010169a:	5d                   	pop    %ebp
f010169b:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010169c:	52                   	push   %edx
f010169d:	68 14 7c 10 f0       	push   $0xf0107c14
f01016a2:	68 17 02 00 00       	push   $0x217
f01016a7:	68 a5 8d 10 f0       	push   $0xf0108da5
f01016ac:	e8 98 e9 ff ff       	call   f0100049 <_panic>
f01016b1:	50                   	push   %eax
f01016b2:	68 14 7c 10 f0       	push   $0xf0107c14
f01016b7:	6a 58                	push   $0x58
f01016b9:	68 b1 8d 10 f0       	push   $0xf0108db1
f01016be:	e8 86 e9 ff ff       	call   f0100049 <_panic>
			tlb_invalidate(pgdir, va);
f01016c3:	83 ec 08             	sub    $0x8,%esp
f01016c6:	ff 75 10             	pushl  0x10(%ebp)
f01016c9:	ff 75 08             	pushl  0x8(%ebp)
f01016cc:	e8 b4 fe ff ff       	call   f0101585 <tlb_invalidate>
			pp->pp_ref--;
f01016d1:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
f01016d6:	83 c4 10             	add    $0x10,%esp
f01016d9:	eb 99                	jmp    f0101674 <page_insert+0x74>
		return -E_NO_MEM;
f01016db:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01016e0:	eb b2                	jmp    f0101694 <page_insert+0x94>

f01016e2 <mmio_map_region>:
{
f01016e2:	55                   	push   %ebp
f01016e3:	89 e5                	mov    %esp,%ebp
f01016e5:	56                   	push   %esi
f01016e6:	53                   	push   %ebx
	size = ROUNDUP(size, PGSIZE);
f01016e7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f01016f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((base + size) > MMIOLIM){
f01016f6:	8b 35 04 83 12 f0    	mov    0xf0128304,%esi
f01016fc:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01016ff:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101704:	77 25                	ja     f010172b <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101706:	83 ec 08             	sub    $0x8,%esp
f0101709:	6a 1a                	push   $0x1a
f010170b:	ff 75 08             	pushl  0x8(%ebp)
f010170e:	89 d9                	mov    %ebx,%ecx
f0101710:	89 f2                	mov    %esi,%edx
f0101712:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0101717:	e8 50 fd ff ff       	call   f010146c <boot_map_region>
	base += size;
f010171c:	01 1d 04 83 12 f0    	add    %ebx,0xf0128304
}
f0101722:	89 f0                	mov    %esi,%eax
f0101724:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101727:	5b                   	pop    %ebx
f0101728:	5e                   	pop    %esi
f0101729:	5d                   	pop    %ebp
f010172a:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f010172b:	83 ec 04             	sub    $0x4,%esp
f010172e:	68 9c 8e 10 f0       	push   $0xf0108e9c
f0101733:	68 88 02 00 00       	push   $0x288
f0101738:	68 a5 8d 10 f0       	push   $0xf0108da5
f010173d:	e8 07 e9 ff ff       	call   f0100049 <_panic>

f0101742 <mem_init>:
{
f0101742:	55                   	push   %ebp
f0101743:	89 e5                	mov    %esp,%ebp
f0101745:	57                   	push   %edi
f0101746:	56                   	push   %esi
f0101747:	53                   	push   %ebx
f0101748:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f010174b:	b8 15 00 00 00       	mov    $0x15,%eax
f0101750:	e8 4f f6 ff ff       	call   f0100da4 <nvram_read>
f0101755:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101757:	b8 17 00 00 00       	mov    $0x17,%eax
f010175c:	e8 43 f6 ff ff       	call   f0100da4 <nvram_read>
f0101761:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101763:	b8 34 00 00 00       	mov    $0x34,%eax
f0101768:	e8 37 f6 ff ff       	call   f0100da4 <nvram_read>
	if (ext16mem)
f010176d:	c1 e0 06             	shl    $0x6,%eax
f0101770:	0f 84 e5 00 00 00    	je     f010185b <mem_init+0x119>
		totalmem = 16 * 1024 + ext16mem;
f0101776:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010177b:	89 c2                	mov    %eax,%edx
f010177d:	c1 ea 02             	shr    $0x2,%edx
f0101780:	89 15 a8 fe 57 f0    	mov    %edx,0xf057fea8
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101786:	89 c2                	mov    %eax,%edx
f0101788:	29 da                	sub    %ebx,%edx
f010178a:	52                   	push   %edx
f010178b:	53                   	push   %ebx
f010178c:	50                   	push   %eax
f010178d:	68 10 85 10 f0       	push   $0xf0108510
f0101792:	e8 2a 27 00 00       	call   f0103ec1 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101797:	b8 00 10 00 00       	mov    $0x1000,%eax
f010179c:	e8 90 f6 ff ff       	call   f0100e31 <boot_alloc>
f01017a1:	a3 ac fe 57 f0       	mov    %eax,0xf057feac
	memset(kern_pgdir, 0, PGSIZE);
f01017a6:	83 c4 0c             	add    $0xc,%esp
f01017a9:	68 00 10 00 00       	push   $0x1000
f01017ae:	6a 00                	push   $0x0
f01017b0:	50                   	push   %eax
f01017b1:	e8 c4 4d 00 00       	call   f010657a <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01017b6:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
	if ((uint32_t)kva < KERNBASE)
f01017bb:	83 c4 10             	add    $0x10,%esp
f01017be:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017c3:	0f 86 a2 00 00 00    	jbe    f010186b <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f01017c9:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017cf:	83 ca 05             	or     $0x5,%edx
f01017d2:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f01017d8:	a1 a8 fe 57 f0       	mov    0xf057fea8,%eax
f01017dd:	c1 e0 03             	shl    $0x3,%eax
f01017e0:	e8 4c f6 ff ff       	call   f0100e31 <boot_alloc>
f01017e5:	a3 b0 fe 57 f0       	mov    %eax,0xf057feb0
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01017ea:	83 ec 04             	sub    $0x4,%esp
f01017ed:	8b 15 a8 fe 57 f0    	mov    0xf057fea8,%edx
f01017f3:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f01017fa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101800:	52                   	push   %edx
f0101801:	6a 00                	push   $0x0
f0101803:	50                   	push   %eax
f0101804:	e8 71 4d 00 00       	call   f010657a <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101809:	b8 00 00 02 00       	mov    $0x20000,%eax
f010180e:	e8 1e f6 ff ff       	call   f0100e31 <boot_alloc>
f0101813:	a3 44 e2 57 f0       	mov    %eax,0xf057e244
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101818:	83 c4 0c             	add    $0xc,%esp
f010181b:	68 00 00 02 00       	push   $0x20000
f0101820:	6a 00                	push   $0x0
f0101822:	50                   	push   %eax
f0101823:	e8 52 4d 00 00       	call   f010657a <memset>
	page_init();
f0101828:	e8 98 f9 ff ff       	call   f01011c5 <page_init>
	check_page_free_list(1);
f010182d:	b8 01 00 00 00       	mov    $0x1,%eax
f0101832:	e8 a0 f6 ff ff       	call   f0100ed7 <check_page_free_list>
	if (!pages)
f0101837:	83 c4 10             	add    $0x10,%esp
f010183a:	83 3d b0 fe 57 f0 00 	cmpl   $0x0,0xf057feb0
f0101841:	74 3d                	je     f0101880 <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101843:	a1 40 e2 57 f0       	mov    0xf057e240,%eax
f0101848:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010184f:	85 c0                	test   %eax,%eax
f0101851:	74 44                	je     f0101897 <mem_init+0x155>
		++nfree;
f0101853:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101857:	8b 00                	mov    (%eax),%eax
f0101859:	eb f4                	jmp    f010184f <mem_init+0x10d>
		totalmem = 1 * 1024 + extmem;
f010185b:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101861:	85 f6                	test   %esi,%esi
f0101863:	0f 44 c3             	cmove  %ebx,%eax
f0101866:	e9 10 ff ff ff       	jmp    f010177b <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010186b:	50                   	push   %eax
f010186c:	68 38 7c 10 f0       	push   $0xf0107c38
f0101871:	68 9a 00 00 00       	push   $0x9a
f0101876:	68 a5 8d 10 f0       	push   $0xf0108da5
f010187b:	e8 c9 e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f0101880:	83 ec 04             	sub    $0x4,%esp
f0101883:	68 ae 8e 10 f0       	push   $0xf0108eae
f0101888:	68 1c 03 00 00       	push   $0x31c
f010188d:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101892:	e8 b2 e7 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101897:	83 ec 0c             	sub    $0xc,%esp
f010189a:	6a 00                	push   $0x0
f010189c:	e8 23 fa ff ff       	call   f01012c4 <page_alloc>
f01018a1:	89 c3                	mov    %eax,%ebx
f01018a3:	83 c4 10             	add    $0x10,%esp
f01018a6:	85 c0                	test   %eax,%eax
f01018a8:	0f 84 00 02 00 00    	je     f0101aae <mem_init+0x36c>
	assert((pp1 = page_alloc(0)));
f01018ae:	83 ec 0c             	sub    $0xc,%esp
f01018b1:	6a 00                	push   $0x0
f01018b3:	e8 0c fa ff ff       	call   f01012c4 <page_alloc>
f01018b8:	89 c6                	mov    %eax,%esi
f01018ba:	83 c4 10             	add    $0x10,%esp
f01018bd:	85 c0                	test   %eax,%eax
f01018bf:	0f 84 02 02 00 00    	je     f0101ac7 <mem_init+0x385>
	assert((pp2 = page_alloc(0)));
f01018c5:	83 ec 0c             	sub    $0xc,%esp
f01018c8:	6a 00                	push   $0x0
f01018ca:	e8 f5 f9 ff ff       	call   f01012c4 <page_alloc>
f01018cf:	89 c7                	mov    %eax,%edi
f01018d1:	83 c4 10             	add    $0x10,%esp
f01018d4:	85 c0                	test   %eax,%eax
f01018d6:	0f 84 04 02 00 00    	je     f0101ae0 <mem_init+0x39e>
	assert(pp1 && pp1 != pp0);
f01018dc:	39 f3                	cmp    %esi,%ebx
f01018de:	0f 84 15 02 00 00    	je     f0101af9 <mem_init+0x3b7>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018e4:	39 c3                	cmp    %eax,%ebx
f01018e6:	0f 84 26 02 00 00    	je     f0101b12 <mem_init+0x3d0>
f01018ec:	39 c6                	cmp    %eax,%esi
f01018ee:	0f 84 1e 02 00 00    	je     f0101b12 <mem_init+0x3d0>
	return (pp - pages) << PGSHIFT;
f01018f4:	8b 0d b0 fe 57 f0    	mov    0xf057feb0,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01018fa:	8b 15 a8 fe 57 f0    	mov    0xf057fea8,%edx
f0101900:	c1 e2 0c             	shl    $0xc,%edx
f0101903:	89 d8                	mov    %ebx,%eax
f0101905:	29 c8                	sub    %ecx,%eax
f0101907:	c1 f8 03             	sar    $0x3,%eax
f010190a:	c1 e0 0c             	shl    $0xc,%eax
f010190d:	39 d0                	cmp    %edx,%eax
f010190f:	0f 83 16 02 00 00    	jae    f0101b2b <mem_init+0x3e9>
f0101915:	89 f0                	mov    %esi,%eax
f0101917:	29 c8                	sub    %ecx,%eax
f0101919:	c1 f8 03             	sar    $0x3,%eax
f010191c:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f010191f:	39 c2                	cmp    %eax,%edx
f0101921:	0f 86 1d 02 00 00    	jbe    f0101b44 <mem_init+0x402>
f0101927:	89 f8                	mov    %edi,%eax
f0101929:	29 c8                	sub    %ecx,%eax
f010192b:	c1 f8 03             	sar    $0x3,%eax
f010192e:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101931:	39 c2                	cmp    %eax,%edx
f0101933:	0f 86 24 02 00 00    	jbe    f0101b5d <mem_init+0x41b>
	fl = page_free_list;
f0101939:	a1 40 e2 57 f0       	mov    0xf057e240,%eax
f010193e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101941:	c7 05 40 e2 57 f0 00 	movl   $0x0,0xf057e240
f0101948:	00 00 00 
	assert(!page_alloc(0));
f010194b:	83 ec 0c             	sub    $0xc,%esp
f010194e:	6a 00                	push   $0x0
f0101950:	e8 6f f9 ff ff       	call   f01012c4 <page_alloc>
f0101955:	83 c4 10             	add    $0x10,%esp
f0101958:	85 c0                	test   %eax,%eax
f010195a:	0f 85 16 02 00 00    	jne    f0101b76 <mem_init+0x434>
	page_free(pp0);
f0101960:	83 ec 0c             	sub    $0xc,%esp
f0101963:	53                   	push   %ebx
f0101964:	e8 cd f9 ff ff       	call   f0101336 <page_free>
	page_free(pp1);
f0101969:	89 34 24             	mov    %esi,(%esp)
f010196c:	e8 c5 f9 ff ff       	call   f0101336 <page_free>
	page_free(pp2);
f0101971:	89 3c 24             	mov    %edi,(%esp)
f0101974:	e8 bd f9 ff ff       	call   f0101336 <page_free>
	assert((pp0 = page_alloc(0)));
f0101979:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101980:	e8 3f f9 ff ff       	call   f01012c4 <page_alloc>
f0101985:	89 c3                	mov    %eax,%ebx
f0101987:	83 c4 10             	add    $0x10,%esp
f010198a:	85 c0                	test   %eax,%eax
f010198c:	0f 84 fd 01 00 00    	je     f0101b8f <mem_init+0x44d>
	assert((pp1 = page_alloc(0)));
f0101992:	83 ec 0c             	sub    $0xc,%esp
f0101995:	6a 00                	push   $0x0
f0101997:	e8 28 f9 ff ff       	call   f01012c4 <page_alloc>
f010199c:	89 c6                	mov    %eax,%esi
f010199e:	83 c4 10             	add    $0x10,%esp
f01019a1:	85 c0                	test   %eax,%eax
f01019a3:	0f 84 ff 01 00 00    	je     f0101ba8 <mem_init+0x466>
	assert((pp2 = page_alloc(0)));
f01019a9:	83 ec 0c             	sub    $0xc,%esp
f01019ac:	6a 00                	push   $0x0
f01019ae:	e8 11 f9 ff ff       	call   f01012c4 <page_alloc>
f01019b3:	89 c7                	mov    %eax,%edi
f01019b5:	83 c4 10             	add    $0x10,%esp
f01019b8:	85 c0                	test   %eax,%eax
f01019ba:	0f 84 01 02 00 00    	je     f0101bc1 <mem_init+0x47f>
	assert(pp1 && pp1 != pp0);
f01019c0:	39 f3                	cmp    %esi,%ebx
f01019c2:	0f 84 12 02 00 00    	je     f0101bda <mem_init+0x498>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019c8:	39 c6                	cmp    %eax,%esi
f01019ca:	0f 84 23 02 00 00    	je     f0101bf3 <mem_init+0x4b1>
f01019d0:	39 c3                	cmp    %eax,%ebx
f01019d2:	0f 84 1b 02 00 00    	je     f0101bf3 <mem_init+0x4b1>
	assert(!page_alloc(0));
f01019d8:	83 ec 0c             	sub    $0xc,%esp
f01019db:	6a 00                	push   $0x0
f01019dd:	e8 e2 f8 ff ff       	call   f01012c4 <page_alloc>
f01019e2:	83 c4 10             	add    $0x10,%esp
f01019e5:	85 c0                	test   %eax,%eax
f01019e7:	0f 85 1f 02 00 00    	jne    f0101c0c <mem_init+0x4ca>
f01019ed:	89 d8                	mov    %ebx,%eax
f01019ef:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01019f5:	c1 f8 03             	sar    $0x3,%eax
f01019f8:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01019fb:	89 c2                	mov    %eax,%edx
f01019fd:	c1 ea 0c             	shr    $0xc,%edx
f0101a00:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0101a06:	0f 83 19 02 00 00    	jae    f0101c25 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a0c:	83 ec 04             	sub    $0x4,%esp
f0101a0f:	68 00 10 00 00       	push   $0x1000
f0101a14:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101a16:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a1b:	50                   	push   %eax
f0101a1c:	e8 59 4b 00 00       	call   f010657a <memset>
	page_free(pp0);
f0101a21:	89 1c 24             	mov    %ebx,(%esp)
f0101a24:	e8 0d f9 ff ff       	call   f0101336 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101a29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101a30:	e8 8f f8 ff ff       	call   f01012c4 <page_alloc>
f0101a35:	83 c4 10             	add    $0x10,%esp
f0101a38:	85 c0                	test   %eax,%eax
f0101a3a:	0f 84 f7 01 00 00    	je     f0101c37 <mem_init+0x4f5>
	assert(pp && pp0 == pp);
f0101a40:	39 c3                	cmp    %eax,%ebx
f0101a42:	0f 85 08 02 00 00    	jne    f0101c50 <mem_init+0x50e>
	return (pp - pages) << PGSHIFT;
f0101a48:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f0101a4e:	c1 f8 03             	sar    $0x3,%eax
f0101a51:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a54:	89 c2                	mov    %eax,%edx
f0101a56:	c1 ea 0c             	shr    $0xc,%edx
f0101a59:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0101a5f:	0f 83 04 02 00 00    	jae    f0101c69 <mem_init+0x527>
	return (void *)(pa + KERNBASE);
f0101a65:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101a6b:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101a70:	80 3a 00             	cmpb   $0x0,(%edx)
f0101a73:	0f 85 02 02 00 00    	jne    f0101c7b <mem_init+0x539>
f0101a79:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101a7c:	39 c2                	cmp    %eax,%edx
f0101a7e:	75 f0                	jne    f0101a70 <mem_init+0x32e>
	page_free_list = fl;
f0101a80:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101a83:	a3 40 e2 57 f0       	mov    %eax,0xf057e240
	page_free(pp0);
f0101a88:	83 ec 0c             	sub    $0xc,%esp
f0101a8b:	53                   	push   %ebx
f0101a8c:	e8 a5 f8 ff ff       	call   f0101336 <page_free>
	page_free(pp1);
f0101a91:	89 34 24             	mov    %esi,(%esp)
f0101a94:	e8 9d f8 ff ff       	call   f0101336 <page_free>
	page_free(pp2);
f0101a99:	89 3c 24             	mov    %edi,(%esp)
f0101a9c:	e8 95 f8 ff ff       	call   f0101336 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101aa1:	a1 40 e2 57 f0       	mov    0xf057e240,%eax
f0101aa6:	83 c4 10             	add    $0x10,%esp
f0101aa9:	e9 ec 01 00 00       	jmp    f0101c9a <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101aae:	68 c9 8e 10 f0       	push   $0xf0108ec9
f0101ab3:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101ab8:	68 24 03 00 00       	push   $0x324
f0101abd:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101ac2:	e8 82 e5 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ac7:	68 df 8e 10 f0       	push   $0xf0108edf
f0101acc:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101ad1:	68 25 03 00 00       	push   $0x325
f0101ad6:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101adb:	e8 69 e5 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101ae0:	68 f5 8e 10 f0       	push   $0xf0108ef5
f0101ae5:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101aea:	68 26 03 00 00       	push   $0x326
f0101aef:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101af4:	e8 50 e5 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101af9:	68 0b 8f 10 f0       	push   $0xf0108f0b
f0101afe:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101b03:	68 29 03 00 00       	push   $0x329
f0101b08:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101b0d:	e8 37 e5 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b12:	68 4c 85 10 f0       	push   $0xf010854c
f0101b17:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101b1c:	68 2a 03 00 00       	push   $0x32a
f0101b21:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101b26:	e8 1e e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b2b:	68 1d 8f 10 f0       	push   $0xf0108f1d
f0101b30:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101b35:	68 2b 03 00 00       	push   $0x32b
f0101b3a:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101b3f:	e8 05 e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b44:	68 3a 8f 10 f0       	push   $0xf0108f3a
f0101b49:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101b4e:	68 2c 03 00 00       	push   $0x32c
f0101b53:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101b58:	e8 ec e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b5d:	68 57 8f 10 f0       	push   $0xf0108f57
f0101b62:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101b67:	68 2d 03 00 00       	push   $0x32d
f0101b6c:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101b71:	e8 d3 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101b76:	68 74 8f 10 f0       	push   $0xf0108f74
f0101b7b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101b80:	68 34 03 00 00       	push   $0x334
f0101b85:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101b8a:	e8 ba e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101b8f:	68 c9 8e 10 f0       	push   $0xf0108ec9
f0101b94:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101b99:	68 3b 03 00 00       	push   $0x33b
f0101b9e:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101ba3:	e8 a1 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ba8:	68 df 8e 10 f0       	push   $0xf0108edf
f0101bad:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101bb2:	68 3c 03 00 00       	push   $0x33c
f0101bb7:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101bbc:	e8 88 e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101bc1:	68 f5 8e 10 f0       	push   $0xf0108ef5
f0101bc6:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101bcb:	68 3d 03 00 00       	push   $0x33d
f0101bd0:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101bd5:	e8 6f e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101bda:	68 0b 8f 10 f0       	push   $0xf0108f0b
f0101bdf:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101be4:	68 3f 03 00 00       	push   $0x33f
f0101be9:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101bee:	e8 56 e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101bf3:	68 4c 85 10 f0       	push   $0xf010854c
f0101bf8:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101bfd:	68 40 03 00 00       	push   $0x340
f0101c02:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101c07:	e8 3d e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c0c:	68 74 8f 10 f0       	push   $0xf0108f74
f0101c11:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101c16:	68 41 03 00 00       	push   $0x341
f0101c1b:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101c20:	e8 24 e4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c25:	50                   	push   %eax
f0101c26:	68 14 7c 10 f0       	push   $0xf0107c14
f0101c2b:	6a 58                	push   $0x58
f0101c2d:	68 b1 8d 10 f0       	push   $0xf0108db1
f0101c32:	e8 12 e4 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101c37:	68 83 8f 10 f0       	push   $0xf0108f83
f0101c3c:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101c41:	68 46 03 00 00       	push   $0x346
f0101c46:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101c4b:	e8 f9 e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101c50:	68 a1 8f 10 f0       	push   $0xf0108fa1
f0101c55:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101c5a:	68 47 03 00 00       	push   $0x347
f0101c5f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101c64:	e8 e0 e3 ff ff       	call   f0100049 <_panic>
f0101c69:	50                   	push   %eax
f0101c6a:	68 14 7c 10 f0       	push   $0xf0107c14
f0101c6f:	6a 58                	push   $0x58
f0101c71:	68 b1 8d 10 f0       	push   $0xf0108db1
f0101c76:	e8 ce e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101c7b:	68 b1 8f 10 f0       	push   $0xf0108fb1
f0101c80:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0101c85:	68 4a 03 00 00       	push   $0x34a
f0101c8a:	68 a5 8d 10 f0       	push   $0xf0108da5
f0101c8f:	e8 b5 e3 ff ff       	call   f0100049 <_panic>
		--nfree;
f0101c94:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101c98:	8b 00                	mov    (%eax),%eax
f0101c9a:	85 c0                	test   %eax,%eax
f0101c9c:	75 f6                	jne    f0101c94 <mem_init+0x552>
	assert(nfree == 0);
f0101c9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101ca2:	0f 85 65 09 00 00    	jne    f010260d <mem_init+0xecb>
	cprintf("check_page_alloc() succeeded!\n");
f0101ca8:	83 ec 0c             	sub    $0xc,%esp
f0101cab:	68 6c 85 10 f0       	push   $0xf010856c
f0101cb0:	e8 0c 22 00 00       	call   f0103ec1 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101cb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101cbc:	e8 03 f6 ff ff       	call   f01012c4 <page_alloc>
f0101cc1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101cc4:	83 c4 10             	add    $0x10,%esp
f0101cc7:	85 c0                	test   %eax,%eax
f0101cc9:	0f 84 57 09 00 00    	je     f0102626 <mem_init+0xee4>
	assert((pp1 = page_alloc(0)));
f0101ccf:	83 ec 0c             	sub    $0xc,%esp
f0101cd2:	6a 00                	push   $0x0
f0101cd4:	e8 eb f5 ff ff       	call   f01012c4 <page_alloc>
f0101cd9:	89 c7                	mov    %eax,%edi
f0101cdb:	83 c4 10             	add    $0x10,%esp
f0101cde:	85 c0                	test   %eax,%eax
f0101ce0:	0f 84 59 09 00 00    	je     f010263f <mem_init+0xefd>
	assert((pp2 = page_alloc(0)));
f0101ce6:	83 ec 0c             	sub    $0xc,%esp
f0101ce9:	6a 00                	push   $0x0
f0101ceb:	e8 d4 f5 ff ff       	call   f01012c4 <page_alloc>
f0101cf0:	89 c3                	mov    %eax,%ebx
f0101cf2:	83 c4 10             	add    $0x10,%esp
f0101cf5:	85 c0                	test   %eax,%eax
f0101cf7:	0f 84 5b 09 00 00    	je     f0102658 <mem_init+0xf16>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101cfd:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101d00:	0f 84 6b 09 00 00    	je     f0102671 <mem_init+0xf2f>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d06:	39 c7                	cmp    %eax,%edi
f0101d08:	0f 84 7c 09 00 00    	je     f010268a <mem_init+0xf48>
f0101d0e:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101d11:	0f 84 73 09 00 00    	je     f010268a <mem_init+0xf48>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101d17:	a1 40 e2 57 f0       	mov    0xf057e240,%eax
f0101d1c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101d1f:	c7 05 40 e2 57 f0 00 	movl   $0x0,0xf057e240
f0101d26:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101d29:	83 ec 0c             	sub    $0xc,%esp
f0101d2c:	6a 00                	push   $0x0
f0101d2e:	e8 91 f5 ff ff       	call   f01012c4 <page_alloc>
f0101d33:	83 c4 10             	add    $0x10,%esp
f0101d36:	85 c0                	test   %eax,%eax
f0101d38:	0f 85 65 09 00 00    	jne    f01026a3 <mem_init+0xf61>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101d3e:	83 ec 04             	sub    $0x4,%esp
f0101d41:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d44:	50                   	push   %eax
f0101d45:	6a 00                	push   $0x0
f0101d47:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101d4d:	e8 ce f7 ff ff       	call   f0101520 <page_lookup>
f0101d52:	83 c4 10             	add    $0x10,%esp
f0101d55:	85 c0                	test   %eax,%eax
f0101d57:	0f 85 5f 09 00 00    	jne    f01026bc <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101d5d:	6a 02                	push   $0x2
f0101d5f:	6a 00                	push   $0x0
f0101d61:	57                   	push   %edi
f0101d62:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101d68:	e8 93 f8 ff ff       	call   f0101600 <page_insert>
f0101d6d:	83 c4 10             	add    $0x10,%esp
f0101d70:	85 c0                	test   %eax,%eax
f0101d72:	0f 89 5d 09 00 00    	jns    f01026d5 <mem_init+0xf93>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101d78:	83 ec 0c             	sub    $0xc,%esp
f0101d7b:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101d7e:	e8 b3 f5 ff ff       	call   f0101336 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101d83:	6a 02                	push   $0x2
f0101d85:	6a 00                	push   $0x0
f0101d87:	57                   	push   %edi
f0101d88:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101d8e:	e8 6d f8 ff ff       	call   f0101600 <page_insert>
f0101d93:	83 c4 20             	add    $0x20,%esp
f0101d96:	85 c0                	test   %eax,%eax
f0101d98:	0f 85 50 09 00 00    	jne    f01026ee <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d9e:	8b 35 ac fe 57 f0    	mov    0xf057feac,%esi
	return (pp - pages) << PGSHIFT;
f0101da4:	8b 0d b0 fe 57 f0    	mov    0xf057feb0,%ecx
f0101daa:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101dad:	8b 16                	mov    (%esi),%edx
f0101daf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101db5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101db8:	29 c8                	sub    %ecx,%eax
f0101dba:	c1 f8 03             	sar    $0x3,%eax
f0101dbd:	c1 e0 0c             	shl    $0xc,%eax
f0101dc0:	39 c2                	cmp    %eax,%edx
f0101dc2:	0f 85 3f 09 00 00    	jne    f0102707 <mem_init+0xfc5>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101dc8:	ba 00 00 00 00       	mov    $0x0,%edx
f0101dcd:	89 f0                	mov    %esi,%eax
f0101dcf:	e8 f9 ef ff ff       	call   f0100dcd <check_va2pa>
f0101dd4:	89 fa                	mov    %edi,%edx
f0101dd6:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101dd9:	c1 fa 03             	sar    $0x3,%edx
f0101ddc:	c1 e2 0c             	shl    $0xc,%edx
f0101ddf:	39 d0                	cmp    %edx,%eax
f0101de1:	0f 85 39 09 00 00    	jne    f0102720 <mem_init+0xfde>
	assert(pp1->pp_ref == 1);
f0101de7:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101dec:	0f 85 47 09 00 00    	jne    f0102739 <mem_init+0xff7>
	assert(pp0->pp_ref == 1);
f0101df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101df5:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101dfa:	0f 85 52 09 00 00    	jne    f0102752 <mem_init+0x1010>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e00:	6a 02                	push   $0x2
f0101e02:	68 00 10 00 00       	push   $0x1000
f0101e07:	53                   	push   %ebx
f0101e08:	56                   	push   %esi
f0101e09:	e8 f2 f7 ff ff       	call   f0101600 <page_insert>
f0101e0e:	83 c4 10             	add    $0x10,%esp
f0101e11:	85 c0                	test   %eax,%eax
f0101e13:	0f 85 52 09 00 00    	jne    f010276b <mem_init+0x1029>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e19:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e1e:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0101e23:	e8 a5 ef ff ff       	call   f0100dcd <check_va2pa>
f0101e28:	89 da                	mov    %ebx,%edx
f0101e2a:	2b 15 b0 fe 57 f0    	sub    0xf057feb0,%edx
f0101e30:	c1 fa 03             	sar    $0x3,%edx
f0101e33:	c1 e2 0c             	shl    $0xc,%edx
f0101e36:	39 d0                	cmp    %edx,%eax
f0101e38:	0f 85 46 09 00 00    	jne    f0102784 <mem_init+0x1042>
	assert(pp2->pp_ref == 1);
f0101e3e:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101e43:	0f 85 54 09 00 00    	jne    f010279d <mem_init+0x105b>

	// should be no free memory
	assert(!page_alloc(0));
f0101e49:	83 ec 0c             	sub    $0xc,%esp
f0101e4c:	6a 00                	push   $0x0
f0101e4e:	e8 71 f4 ff ff       	call   f01012c4 <page_alloc>
f0101e53:	83 c4 10             	add    $0x10,%esp
f0101e56:	85 c0                	test   %eax,%eax
f0101e58:	0f 85 58 09 00 00    	jne    f01027b6 <mem_init+0x1074>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e5e:	6a 02                	push   $0x2
f0101e60:	68 00 10 00 00       	push   $0x1000
f0101e65:	53                   	push   %ebx
f0101e66:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101e6c:	e8 8f f7 ff ff       	call   f0101600 <page_insert>
f0101e71:	83 c4 10             	add    $0x10,%esp
f0101e74:	85 c0                	test   %eax,%eax
f0101e76:	0f 85 53 09 00 00    	jne    f01027cf <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e7c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e81:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0101e86:	e8 42 ef ff ff       	call   f0100dcd <check_va2pa>
f0101e8b:	89 da                	mov    %ebx,%edx
f0101e8d:	2b 15 b0 fe 57 f0    	sub    0xf057feb0,%edx
f0101e93:	c1 fa 03             	sar    $0x3,%edx
f0101e96:	c1 e2 0c             	shl    $0xc,%edx
f0101e99:	39 d0                	cmp    %edx,%eax
f0101e9b:	0f 85 47 09 00 00    	jne    f01027e8 <mem_init+0x10a6>
	assert(pp2->pp_ref == 1);
f0101ea1:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101ea6:	0f 85 55 09 00 00    	jne    f0102801 <mem_init+0x10bf>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101eac:	83 ec 0c             	sub    $0xc,%esp
f0101eaf:	6a 00                	push   $0x0
f0101eb1:	e8 0e f4 ff ff       	call   f01012c4 <page_alloc>
f0101eb6:	83 c4 10             	add    $0x10,%esp
f0101eb9:	85 c0                	test   %eax,%eax
f0101ebb:	0f 85 59 09 00 00    	jne    f010281a <mem_init+0x10d8>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101ec1:	8b 15 ac fe 57 f0    	mov    0xf057feac,%edx
f0101ec7:	8b 02                	mov    (%edx),%eax
f0101ec9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101ece:	89 c1                	mov    %eax,%ecx
f0101ed0:	c1 e9 0c             	shr    $0xc,%ecx
f0101ed3:	3b 0d a8 fe 57 f0    	cmp    0xf057fea8,%ecx
f0101ed9:	0f 83 54 09 00 00    	jae    f0102833 <mem_init+0x10f1>
	return (void *)(pa + KERNBASE);
f0101edf:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101ee4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101ee7:	83 ec 04             	sub    $0x4,%esp
f0101eea:	6a 00                	push   $0x0
f0101eec:	68 00 10 00 00       	push   $0x1000
f0101ef1:	52                   	push   %edx
f0101ef2:	e8 a3 f4 ff ff       	call   f010139a <pgdir_walk>
f0101ef7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101efa:	8d 51 04             	lea    0x4(%ecx),%edx
f0101efd:	83 c4 10             	add    $0x10,%esp
f0101f00:	39 d0                	cmp    %edx,%eax
f0101f02:	0f 85 40 09 00 00    	jne    f0102848 <mem_init+0x1106>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101f08:	6a 06                	push   $0x6
f0101f0a:	68 00 10 00 00       	push   $0x1000
f0101f0f:	53                   	push   %ebx
f0101f10:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101f16:	e8 e5 f6 ff ff       	call   f0101600 <page_insert>
f0101f1b:	83 c4 10             	add    $0x10,%esp
f0101f1e:	85 c0                	test   %eax,%eax
f0101f20:	0f 85 3b 09 00 00    	jne    f0102861 <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f26:	8b 35 ac fe 57 f0    	mov    0xf057feac,%esi
f0101f2c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f31:	89 f0                	mov    %esi,%eax
f0101f33:	e8 95 ee ff ff       	call   f0100dcd <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101f38:	89 da                	mov    %ebx,%edx
f0101f3a:	2b 15 b0 fe 57 f0    	sub    0xf057feb0,%edx
f0101f40:	c1 fa 03             	sar    $0x3,%edx
f0101f43:	c1 e2 0c             	shl    $0xc,%edx
f0101f46:	39 d0                	cmp    %edx,%eax
f0101f48:	0f 85 2c 09 00 00    	jne    f010287a <mem_init+0x1138>
	assert(pp2->pp_ref == 1);
f0101f4e:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101f53:	0f 85 3a 09 00 00    	jne    f0102893 <mem_init+0x1151>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101f59:	83 ec 04             	sub    $0x4,%esp
f0101f5c:	6a 00                	push   $0x0
f0101f5e:	68 00 10 00 00       	push   $0x1000
f0101f63:	56                   	push   %esi
f0101f64:	e8 31 f4 ff ff       	call   f010139a <pgdir_walk>
f0101f69:	83 c4 10             	add    $0x10,%esp
f0101f6c:	f6 00 04             	testb  $0x4,(%eax)
f0101f6f:	0f 84 37 09 00 00    	je     f01028ac <mem_init+0x116a>
	assert(kern_pgdir[0] & PTE_U);
f0101f75:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0101f7a:	f6 00 04             	testb  $0x4,(%eax)
f0101f7d:	0f 84 42 09 00 00    	je     f01028c5 <mem_init+0x1183>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101f83:	6a 02                	push   $0x2
f0101f85:	68 00 10 00 00       	push   $0x1000
f0101f8a:	53                   	push   %ebx
f0101f8b:	50                   	push   %eax
f0101f8c:	e8 6f f6 ff ff       	call   f0101600 <page_insert>
f0101f91:	83 c4 10             	add    $0x10,%esp
f0101f94:	85 c0                	test   %eax,%eax
f0101f96:	0f 85 42 09 00 00    	jne    f01028de <mem_init+0x119c>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101f9c:	83 ec 04             	sub    $0x4,%esp
f0101f9f:	6a 00                	push   $0x0
f0101fa1:	68 00 10 00 00       	push   $0x1000
f0101fa6:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101fac:	e8 e9 f3 ff ff       	call   f010139a <pgdir_walk>
f0101fb1:	83 c4 10             	add    $0x10,%esp
f0101fb4:	f6 00 02             	testb  $0x2,(%eax)
f0101fb7:	0f 84 3a 09 00 00    	je     f01028f7 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101fbd:	83 ec 04             	sub    $0x4,%esp
f0101fc0:	6a 00                	push   $0x0
f0101fc2:	68 00 10 00 00       	push   $0x1000
f0101fc7:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101fcd:	e8 c8 f3 ff ff       	call   f010139a <pgdir_walk>
f0101fd2:	83 c4 10             	add    $0x10,%esp
f0101fd5:	f6 00 04             	testb  $0x4,(%eax)
f0101fd8:	0f 85 32 09 00 00    	jne    f0102910 <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101fde:	6a 02                	push   $0x2
f0101fe0:	68 00 00 40 00       	push   $0x400000
f0101fe5:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101fe8:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0101fee:	e8 0d f6 ff ff       	call   f0101600 <page_insert>
f0101ff3:	83 c4 10             	add    $0x10,%esp
f0101ff6:	85 c0                	test   %eax,%eax
f0101ff8:	0f 89 2b 09 00 00    	jns    f0102929 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101ffe:	6a 02                	push   $0x2
f0102000:	68 00 10 00 00       	push   $0x1000
f0102005:	57                   	push   %edi
f0102006:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f010200c:	e8 ef f5 ff ff       	call   f0101600 <page_insert>
f0102011:	83 c4 10             	add    $0x10,%esp
f0102014:	85 c0                	test   %eax,%eax
f0102016:	0f 85 26 09 00 00    	jne    f0102942 <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010201c:	83 ec 04             	sub    $0x4,%esp
f010201f:	6a 00                	push   $0x0
f0102021:	68 00 10 00 00       	push   $0x1000
f0102026:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f010202c:	e8 69 f3 ff ff       	call   f010139a <pgdir_walk>
f0102031:	83 c4 10             	add    $0x10,%esp
f0102034:	f6 00 04             	testb  $0x4,(%eax)
f0102037:	0f 85 1e 09 00 00    	jne    f010295b <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010203d:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0102042:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102045:	ba 00 00 00 00       	mov    $0x0,%edx
f010204a:	e8 7e ed ff ff       	call   f0100dcd <check_va2pa>
f010204f:	89 fe                	mov    %edi,%esi
f0102051:	2b 35 b0 fe 57 f0    	sub    0xf057feb0,%esi
f0102057:	c1 fe 03             	sar    $0x3,%esi
f010205a:	c1 e6 0c             	shl    $0xc,%esi
f010205d:	39 f0                	cmp    %esi,%eax
f010205f:	0f 85 0f 09 00 00    	jne    f0102974 <mem_init+0x1232>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102065:	ba 00 10 00 00       	mov    $0x1000,%edx
f010206a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010206d:	e8 5b ed ff ff       	call   f0100dcd <check_va2pa>
f0102072:	39 c6                	cmp    %eax,%esi
f0102074:	0f 85 13 09 00 00    	jne    f010298d <mem_init+0x124b>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f010207a:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f010207f:	0f 85 21 09 00 00    	jne    f01029a6 <mem_init+0x1264>
	assert(pp2->pp_ref == 0);
f0102085:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010208a:	0f 85 2f 09 00 00    	jne    f01029bf <mem_init+0x127d>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102090:	83 ec 0c             	sub    $0xc,%esp
f0102093:	6a 00                	push   $0x0
f0102095:	e8 2a f2 ff ff       	call   f01012c4 <page_alloc>
f010209a:	83 c4 10             	add    $0x10,%esp
f010209d:	39 c3                	cmp    %eax,%ebx
f010209f:	0f 85 33 09 00 00    	jne    f01029d8 <mem_init+0x1296>
f01020a5:	85 c0                	test   %eax,%eax
f01020a7:	0f 84 2b 09 00 00    	je     f01029d8 <mem_init+0x1296>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f01020ad:	83 ec 08             	sub    $0x8,%esp
f01020b0:	6a 00                	push   $0x0
f01020b2:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f01020b8:	e8 fd f4 ff ff       	call   f01015ba <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01020bd:	8b 35 ac fe 57 f0    	mov    0xf057feac,%esi
f01020c3:	ba 00 00 00 00       	mov    $0x0,%edx
f01020c8:	89 f0                	mov    %esi,%eax
f01020ca:	e8 fe ec ff ff       	call   f0100dcd <check_va2pa>
f01020cf:	83 c4 10             	add    $0x10,%esp
f01020d2:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020d5:	0f 85 16 09 00 00    	jne    f01029f1 <mem_init+0x12af>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01020db:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020e0:	89 f0                	mov    %esi,%eax
f01020e2:	e8 e6 ec ff ff       	call   f0100dcd <check_va2pa>
f01020e7:	89 fa                	mov    %edi,%edx
f01020e9:	2b 15 b0 fe 57 f0    	sub    0xf057feb0,%edx
f01020ef:	c1 fa 03             	sar    $0x3,%edx
f01020f2:	c1 e2 0c             	shl    $0xc,%edx
f01020f5:	39 d0                	cmp    %edx,%eax
f01020f7:	0f 85 0d 09 00 00    	jne    f0102a0a <mem_init+0x12c8>
	assert(pp1->pp_ref == 1);
f01020fd:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102102:	0f 85 1b 09 00 00    	jne    f0102a23 <mem_init+0x12e1>
	assert(pp2->pp_ref == 0);
f0102108:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010210d:	0f 85 29 09 00 00    	jne    f0102a3c <mem_init+0x12fa>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102113:	6a 00                	push   $0x0
f0102115:	68 00 10 00 00       	push   $0x1000
f010211a:	57                   	push   %edi
f010211b:	56                   	push   %esi
f010211c:	e8 df f4 ff ff       	call   f0101600 <page_insert>
f0102121:	83 c4 10             	add    $0x10,%esp
f0102124:	85 c0                	test   %eax,%eax
f0102126:	0f 85 29 09 00 00    	jne    f0102a55 <mem_init+0x1313>
	assert(pp1->pp_ref);
f010212c:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102131:	0f 84 37 09 00 00    	je     f0102a6e <mem_init+0x132c>
	assert(pp1->pp_link == NULL);
f0102137:	83 3f 00             	cmpl   $0x0,(%edi)
f010213a:	0f 85 47 09 00 00    	jne    f0102a87 <mem_init+0x1345>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102140:	83 ec 08             	sub    $0x8,%esp
f0102143:	68 00 10 00 00       	push   $0x1000
f0102148:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f010214e:	e8 67 f4 ff ff       	call   f01015ba <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102153:	8b 35 ac fe 57 f0    	mov    0xf057feac,%esi
f0102159:	ba 00 00 00 00       	mov    $0x0,%edx
f010215e:	89 f0                	mov    %esi,%eax
f0102160:	e8 68 ec ff ff       	call   f0100dcd <check_va2pa>
f0102165:	83 c4 10             	add    $0x10,%esp
f0102168:	83 f8 ff             	cmp    $0xffffffff,%eax
f010216b:	0f 85 2f 09 00 00    	jne    f0102aa0 <mem_init+0x135e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102171:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102176:	89 f0                	mov    %esi,%eax
f0102178:	e8 50 ec ff ff       	call   f0100dcd <check_va2pa>
f010217d:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102180:	0f 85 33 09 00 00    	jne    f0102ab9 <mem_init+0x1377>
	assert(pp1->pp_ref == 0);
f0102186:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010218b:	0f 85 41 09 00 00    	jne    f0102ad2 <mem_init+0x1390>
	assert(pp2->pp_ref == 0);
f0102191:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102196:	0f 85 4f 09 00 00    	jne    f0102aeb <mem_init+0x13a9>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f010219c:	83 ec 0c             	sub    $0xc,%esp
f010219f:	6a 00                	push   $0x0
f01021a1:	e8 1e f1 ff ff       	call   f01012c4 <page_alloc>
f01021a6:	83 c4 10             	add    $0x10,%esp
f01021a9:	85 c0                	test   %eax,%eax
f01021ab:	0f 84 53 09 00 00    	je     f0102b04 <mem_init+0x13c2>
f01021b1:	39 c7                	cmp    %eax,%edi
f01021b3:	0f 85 4b 09 00 00    	jne    f0102b04 <mem_init+0x13c2>

	// should be no free memory
	assert(!page_alloc(0));
f01021b9:	83 ec 0c             	sub    $0xc,%esp
f01021bc:	6a 00                	push   $0x0
f01021be:	e8 01 f1 ff ff       	call   f01012c4 <page_alloc>
f01021c3:	83 c4 10             	add    $0x10,%esp
f01021c6:	85 c0                	test   %eax,%eax
f01021c8:	0f 85 4f 09 00 00    	jne    f0102b1d <mem_init+0x13db>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01021ce:	8b 0d ac fe 57 f0    	mov    0xf057feac,%ecx
f01021d4:	8b 11                	mov    (%ecx),%edx
f01021d6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01021dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021df:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01021e5:	c1 f8 03             	sar    $0x3,%eax
f01021e8:	c1 e0 0c             	shl    $0xc,%eax
f01021eb:	39 c2                	cmp    %eax,%edx
f01021ed:	0f 85 43 09 00 00    	jne    f0102b36 <mem_init+0x13f4>
	kern_pgdir[0] = 0;
f01021f3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f01021f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021fc:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102201:	0f 85 48 09 00 00    	jne    f0102b4f <mem_init+0x140d>
	pp0->pp_ref = 0;
f0102207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010220a:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102210:	83 ec 0c             	sub    $0xc,%esp
f0102213:	50                   	push   %eax
f0102214:	e8 1d f1 ff ff       	call   f0101336 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102219:	83 c4 0c             	add    $0xc,%esp
f010221c:	6a 01                	push   $0x1
f010221e:	68 00 10 40 00       	push   $0x401000
f0102223:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0102229:	e8 6c f1 ff ff       	call   f010139a <pgdir_walk>
f010222e:	89 c1                	mov    %eax,%ecx
f0102230:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102233:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0102238:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010223b:	8b 40 04             	mov    0x4(%eax),%eax
f010223e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102243:	8b 35 a8 fe 57 f0    	mov    0xf057fea8,%esi
f0102249:	89 c2                	mov    %eax,%edx
f010224b:	c1 ea 0c             	shr    $0xc,%edx
f010224e:	83 c4 10             	add    $0x10,%esp
f0102251:	39 f2                	cmp    %esi,%edx
f0102253:	0f 83 0f 09 00 00    	jae    f0102b68 <mem_init+0x1426>
	assert(ptep == ptep1 + PTX(va));
f0102259:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f010225e:	39 c1                	cmp    %eax,%ecx
f0102260:	0f 85 17 09 00 00    	jne    f0102b7d <mem_init+0x143b>
	kern_pgdir[PDX(va)] = 0;
f0102266:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102269:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f0102270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102273:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0102279:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f010227f:	c1 f8 03             	sar    $0x3,%eax
f0102282:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102285:	89 c2                	mov    %eax,%edx
f0102287:	c1 ea 0c             	shr    $0xc,%edx
f010228a:	39 d6                	cmp    %edx,%esi
f010228c:	0f 86 04 09 00 00    	jbe    f0102b96 <mem_init+0x1454>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102292:	83 ec 04             	sub    $0x4,%esp
f0102295:	68 00 10 00 00       	push   $0x1000
f010229a:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f010229f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01022a4:	50                   	push   %eax
f01022a5:	e8 d0 42 00 00       	call   f010657a <memset>
	page_free(pp0);
f01022aa:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01022ad:	89 34 24             	mov    %esi,(%esp)
f01022b0:	e8 81 f0 ff ff       	call   f0101336 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01022b5:	83 c4 0c             	add    $0xc,%esp
f01022b8:	6a 01                	push   $0x1
f01022ba:	6a 00                	push   $0x0
f01022bc:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f01022c2:	e8 d3 f0 ff ff       	call   f010139a <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01022c7:	89 f0                	mov    %esi,%eax
f01022c9:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01022cf:	c1 f8 03             	sar    $0x3,%eax
f01022d2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022d5:	89 c2                	mov    %eax,%edx
f01022d7:	c1 ea 0c             	shr    $0xc,%edx
f01022da:	83 c4 10             	add    $0x10,%esp
f01022dd:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f01022e3:	0f 83 bf 08 00 00    	jae    f0102ba8 <mem_init+0x1466>
	return (void *)(pa + KERNBASE);
f01022e9:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f01022ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01022f2:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f01022f7:	f6 02 01             	testb  $0x1,(%edx)
f01022fa:	0f 85 ba 08 00 00    	jne    f0102bba <mem_init+0x1478>
f0102300:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f0102303:	39 c2                	cmp    %eax,%edx
f0102305:	75 f0                	jne    f01022f7 <mem_init+0xbb5>
	kern_pgdir[0] = 0;
f0102307:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f010230c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102315:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f010231b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010231e:	89 0d 40 e2 57 f0    	mov    %ecx,0xf057e240

	// free the pages we took
	page_free(pp0);
f0102324:	83 ec 0c             	sub    $0xc,%esp
f0102327:	50                   	push   %eax
f0102328:	e8 09 f0 ff ff       	call   f0101336 <page_free>
	page_free(pp1);
f010232d:	89 3c 24             	mov    %edi,(%esp)
f0102330:	e8 01 f0 ff ff       	call   f0101336 <page_free>
	page_free(pp2);
f0102335:	89 1c 24             	mov    %ebx,(%esp)
f0102338:	e8 f9 ef ff ff       	call   f0101336 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f010233d:	83 c4 08             	add    $0x8,%esp
f0102340:	68 01 10 00 00       	push   $0x1001
f0102345:	6a 00                	push   $0x0
f0102347:	e8 96 f3 ff ff       	call   f01016e2 <mmio_map_region>
f010234c:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f010234e:	83 c4 08             	add    $0x8,%esp
f0102351:	68 00 10 00 00       	push   $0x1000
f0102356:	6a 00                	push   $0x0
f0102358:	e8 85 f3 ff ff       	call   f01016e2 <mmio_map_region>
f010235d:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010235f:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102365:	83 c4 10             	add    $0x10,%esp
f0102368:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010236e:	0f 86 5f 08 00 00    	jbe    f0102bd3 <mem_init+0x1491>
f0102374:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102379:	0f 87 54 08 00 00    	ja     f0102bd3 <mem_init+0x1491>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010237f:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102385:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f010238b:	0f 87 5b 08 00 00    	ja     f0102bec <mem_init+0x14aa>
f0102391:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102397:	0f 86 4f 08 00 00    	jbe    f0102bec <mem_init+0x14aa>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010239d:	89 da                	mov    %ebx,%edx
f010239f:	09 f2                	or     %esi,%edx
f01023a1:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01023a7:	0f 85 58 08 00 00    	jne    f0102c05 <mem_init+0x14c3>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f01023ad:	39 c6                	cmp    %eax,%esi
f01023af:	0f 82 69 08 00 00    	jb     f0102c1e <mem_init+0x14dc>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01023b5:	8b 3d ac fe 57 f0    	mov    0xf057feac,%edi
f01023bb:	89 da                	mov    %ebx,%edx
f01023bd:	89 f8                	mov    %edi,%eax
f01023bf:	e8 09 ea ff ff       	call   f0100dcd <check_va2pa>
f01023c4:	85 c0                	test   %eax,%eax
f01023c6:	0f 85 6b 08 00 00    	jne    f0102c37 <mem_init+0x14f5>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01023cc:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01023d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01023d5:	89 c2                	mov    %eax,%edx
f01023d7:	89 f8                	mov    %edi,%eax
f01023d9:	e8 ef e9 ff ff       	call   f0100dcd <check_va2pa>
f01023de:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01023e3:	0f 85 67 08 00 00    	jne    f0102c50 <mem_init+0x150e>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01023e9:	89 f2                	mov    %esi,%edx
f01023eb:	89 f8                	mov    %edi,%eax
f01023ed:	e8 db e9 ff ff       	call   f0100dcd <check_va2pa>
f01023f2:	85 c0                	test   %eax,%eax
f01023f4:	0f 85 6f 08 00 00    	jne    f0102c69 <mem_init+0x1527>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01023fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102400:	89 f8                	mov    %edi,%eax
f0102402:	e8 c6 e9 ff ff       	call   f0100dcd <check_va2pa>
f0102407:	83 f8 ff             	cmp    $0xffffffff,%eax
f010240a:	0f 85 72 08 00 00    	jne    f0102c82 <mem_init+0x1540>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102410:	83 ec 04             	sub    $0x4,%esp
f0102413:	6a 00                	push   $0x0
f0102415:	53                   	push   %ebx
f0102416:	57                   	push   %edi
f0102417:	e8 7e ef ff ff       	call   f010139a <pgdir_walk>
f010241c:	83 c4 10             	add    $0x10,%esp
f010241f:	f6 00 1a             	testb  $0x1a,(%eax)
f0102422:	0f 84 73 08 00 00    	je     f0102c9b <mem_init+0x1559>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102428:	83 ec 04             	sub    $0x4,%esp
f010242b:	6a 00                	push   $0x0
f010242d:	53                   	push   %ebx
f010242e:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0102434:	e8 61 ef ff ff       	call   f010139a <pgdir_walk>
f0102439:	8b 00                	mov    (%eax),%eax
f010243b:	83 c4 10             	add    $0x10,%esp
f010243e:	83 e0 04             	and    $0x4,%eax
f0102441:	89 c7                	mov    %eax,%edi
f0102443:	0f 85 6b 08 00 00    	jne    f0102cb4 <mem_init+0x1572>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102449:	83 ec 04             	sub    $0x4,%esp
f010244c:	6a 00                	push   $0x0
f010244e:	53                   	push   %ebx
f010244f:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0102455:	e8 40 ef ff ff       	call   f010139a <pgdir_walk>
f010245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102460:	83 c4 0c             	add    $0xc,%esp
f0102463:	6a 00                	push   $0x0
f0102465:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102468:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f010246e:	e8 27 ef ff ff       	call   f010139a <pgdir_walk>
f0102473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102479:	83 c4 0c             	add    $0xc,%esp
f010247c:	6a 00                	push   $0x0
f010247e:	56                   	push   %esi
f010247f:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f0102485:	e8 10 ef ff ff       	call   f010139a <pgdir_walk>
f010248a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102490:	c7 04 24 a4 90 10 f0 	movl   $0xf01090a4,(%esp)
f0102497:	e8 25 1a 00 00       	call   f0103ec1 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010249c:	a1 b0 fe 57 f0       	mov    0xf057feb0,%eax
	if ((uint32_t)kva < KERNBASE)
f01024a1:	83 c4 10             	add    $0x10,%esp
f01024a4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01024a9:	0f 86 1e 08 00 00    	jbe    f0102ccd <mem_init+0x158b>
f01024af:	83 ec 08             	sub    $0x8,%esp
f01024b2:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01024b4:	05 00 00 00 10       	add    $0x10000000,%eax
f01024b9:	50                   	push   %eax
f01024ba:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01024bf:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01024c4:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f01024c9:	e8 9e ef ff ff       	call   f010146c <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01024ce:	a1 44 e2 57 f0       	mov    0xf057e244,%eax
	if ((uint32_t)kva < KERNBASE)
f01024d3:	83 c4 10             	add    $0x10,%esp
f01024d6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01024db:	0f 86 01 08 00 00    	jbe    f0102ce2 <mem_init+0x15a0>
f01024e1:	83 ec 08             	sub    $0x8,%esp
f01024e4:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01024e6:	05 00 00 00 10       	add    $0x10000000,%eax
f01024eb:	50                   	push   %eax
f01024ec:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01024f1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01024f6:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f01024fb:	e8 6c ef ff ff       	call   f010146c <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102500:	83 c4 10             	add    $0x10,%esp
f0102503:	b8 00 f0 11 f0       	mov    $0xf011f000,%eax
f0102508:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010250d:	0f 86 e4 07 00 00    	jbe    f0102cf7 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102513:	83 ec 08             	sub    $0x8,%esp
f0102516:	6a 02                	push   $0x2
f0102518:	68 00 f0 11 00       	push   $0x11f000
f010251d:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102522:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102527:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f010252c:	e8 3b ef ff ff       	call   f010146c <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f0102531:	83 c4 08             	add    $0x8,%esp
f0102534:	6a 02                	push   $0x2
f0102536:	6a 00                	push   $0x0
f0102538:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010253d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102542:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0102547:	e8 20 ef ff ff       	call   f010146c <boot_map_region>
f010254c:	c7 45 d0 00 10 58 f0 	movl   $0xf0581000,-0x30(%ebp)
f0102553:	83 c4 10             	add    $0x10,%esp
f0102556:	bb 00 10 58 f0       	mov    $0xf0581000,%ebx
f010255b:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102560:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102566:	0f 86 a0 07 00 00    	jbe    f0102d0c <mem_init+0x15ca>
		boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f010256c:	83 ec 08             	sub    $0x8,%esp
f010256f:	6a 02                	push   $0x2
f0102571:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102577:	50                   	push   %eax
f0102578:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010257d:	89 f2                	mov    %esi,%edx
f010257f:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f0102584:	e8 e3 ee ff ff       	call   f010146c <boot_map_region>
f0102589:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010258f:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f0102595:	83 c4 10             	add    $0x10,%esp
f0102598:	81 fb 00 10 5c f0    	cmp    $0xf05c1000,%ebx
f010259e:	75 c0                	jne    f0102560 <mem_init+0xe1e>
	pgdir = kern_pgdir;
f01025a0:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
f01025a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01025a8:	a1 a8 fe 57 f0       	mov    0xf057fea8,%eax
f01025ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01025b0:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01025b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025bf:	8b 35 b0 fe 57 f0    	mov    0xf057feb0,%esi
f01025c5:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01025c8:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01025ce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01025d1:	89 fb                	mov    %edi,%ebx
f01025d3:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f01025d6:	0f 86 73 07 00 00    	jbe    f0102d4f <mem_init+0x160d>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025dc:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01025e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01025e5:	e8 e3 e7 ff ff       	call   f0100dcd <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01025ea:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f01025f1:	0f 86 2a 07 00 00    	jbe    f0102d21 <mem_init+0x15df>
f01025f7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f01025fa:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f01025fd:	39 d0                	cmp    %edx,%eax
f01025ff:	0f 85 31 07 00 00    	jne    f0102d36 <mem_init+0x15f4>
	for (i = 0; i < n; i += PGSIZE)
f0102605:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010260b:	eb c6                	jmp    f01025d3 <mem_init+0xe91>
	assert(nfree == 0);
f010260d:	68 bb 8f 10 f0       	push   $0xf0108fbb
f0102612:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102617:	68 57 03 00 00       	push   $0x357
f010261c:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102621:	e8 23 da ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0102626:	68 c9 8e 10 f0       	push   $0xf0108ec9
f010262b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102630:	68 ca 03 00 00       	push   $0x3ca
f0102635:	68 a5 8d 10 f0       	push   $0xf0108da5
f010263a:	e8 0a da ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010263f:	68 df 8e 10 f0       	push   $0xf0108edf
f0102644:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102649:	68 cb 03 00 00       	push   $0x3cb
f010264e:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102653:	e8 f1 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0102658:	68 f5 8e 10 f0       	push   $0xf0108ef5
f010265d:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102662:	68 cc 03 00 00       	push   $0x3cc
f0102667:	68 a5 8d 10 f0       	push   $0xf0108da5
f010266c:	e8 d8 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0102671:	68 0b 8f 10 f0       	push   $0xf0108f0b
f0102676:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010267b:	68 cf 03 00 00       	push   $0x3cf
f0102680:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102685:	e8 bf d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010268a:	68 4c 85 10 f0       	push   $0xf010854c
f010268f:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102694:	68 d0 03 00 00       	push   $0x3d0
f0102699:	68 a5 8d 10 f0       	push   $0xf0108da5
f010269e:	e8 a6 d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01026a3:	68 74 8f 10 f0       	push   $0xf0108f74
f01026a8:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01026ad:	68 d7 03 00 00       	push   $0x3d7
f01026b2:	68 a5 8d 10 f0       	push   $0xf0108da5
f01026b7:	e8 8d d9 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01026bc:	68 8c 85 10 f0       	push   $0xf010858c
f01026c1:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01026c6:	68 da 03 00 00       	push   $0x3da
f01026cb:	68 a5 8d 10 f0       	push   $0xf0108da5
f01026d0:	e8 74 d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01026d5:	68 c4 85 10 f0       	push   $0xf01085c4
f01026da:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01026df:	68 dd 03 00 00       	push   $0x3dd
f01026e4:	68 a5 8d 10 f0       	push   $0xf0108da5
f01026e9:	e8 5b d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01026ee:	68 f4 85 10 f0       	push   $0xf01085f4
f01026f3:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01026f8:	68 e1 03 00 00       	push   $0x3e1
f01026fd:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102702:	e8 42 d9 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102707:	68 24 86 10 f0       	push   $0xf0108624
f010270c:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102711:	68 e2 03 00 00       	push   $0x3e2
f0102716:	68 a5 8d 10 f0       	push   $0xf0108da5
f010271b:	e8 29 d9 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102720:	68 4c 86 10 f0       	push   $0xf010864c
f0102725:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010272a:	68 e3 03 00 00       	push   $0x3e3
f010272f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102734:	e8 10 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102739:	68 c6 8f 10 f0       	push   $0xf0108fc6
f010273e:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102743:	68 e4 03 00 00       	push   $0x3e4
f0102748:	68 a5 8d 10 f0       	push   $0xf0108da5
f010274d:	e8 f7 d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102752:	68 d7 8f 10 f0       	push   $0xf0108fd7
f0102757:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010275c:	68 e5 03 00 00       	push   $0x3e5
f0102761:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102766:	e8 de d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010276b:	68 7c 86 10 f0       	push   $0xf010867c
f0102770:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102775:	68 e8 03 00 00       	push   $0x3e8
f010277a:	68 a5 8d 10 f0       	push   $0xf0108da5
f010277f:	e8 c5 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102784:	68 b8 86 10 f0       	push   $0xf01086b8
f0102789:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010278e:	68 e9 03 00 00       	push   $0x3e9
f0102793:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102798:	e8 ac d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010279d:	68 e8 8f 10 f0       	push   $0xf0108fe8
f01027a2:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01027a7:	68 ea 03 00 00       	push   $0x3ea
f01027ac:	68 a5 8d 10 f0       	push   $0xf0108da5
f01027b1:	e8 93 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01027b6:	68 74 8f 10 f0       	push   $0xf0108f74
f01027bb:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01027c0:	68 ed 03 00 00       	push   $0x3ed
f01027c5:	68 a5 8d 10 f0       	push   $0xf0108da5
f01027ca:	e8 7a d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027cf:	68 7c 86 10 f0       	push   $0xf010867c
f01027d4:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01027d9:	68 f0 03 00 00       	push   $0x3f0
f01027de:	68 a5 8d 10 f0       	push   $0xf0108da5
f01027e3:	e8 61 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027e8:	68 b8 86 10 f0       	push   $0xf01086b8
f01027ed:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01027f2:	68 f1 03 00 00       	push   $0x3f1
f01027f7:	68 a5 8d 10 f0       	push   $0xf0108da5
f01027fc:	e8 48 d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102801:	68 e8 8f 10 f0       	push   $0xf0108fe8
f0102806:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010280b:	68 f2 03 00 00       	push   $0x3f2
f0102810:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102815:	e8 2f d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f010281a:	68 74 8f 10 f0       	push   $0xf0108f74
f010281f:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102824:	68 f6 03 00 00       	push   $0x3f6
f0102829:	68 a5 8d 10 f0       	push   $0xf0108da5
f010282e:	e8 16 d8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102833:	50                   	push   %eax
f0102834:	68 14 7c 10 f0       	push   $0xf0107c14
f0102839:	68 f9 03 00 00       	push   $0x3f9
f010283e:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102843:	e8 01 d8 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102848:	68 e8 86 10 f0       	push   $0xf01086e8
f010284d:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102852:	68 fa 03 00 00       	push   $0x3fa
f0102857:	68 a5 8d 10 f0       	push   $0xf0108da5
f010285c:	e8 e8 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102861:	68 28 87 10 f0       	push   $0xf0108728
f0102866:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010286b:	68 fd 03 00 00       	push   $0x3fd
f0102870:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102875:	e8 cf d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010287a:	68 b8 86 10 f0       	push   $0xf01086b8
f010287f:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102884:	68 fe 03 00 00       	push   $0x3fe
f0102889:	68 a5 8d 10 f0       	push   $0xf0108da5
f010288e:	e8 b6 d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102893:	68 e8 8f 10 f0       	push   $0xf0108fe8
f0102898:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010289d:	68 ff 03 00 00       	push   $0x3ff
f01028a2:	68 a5 8d 10 f0       	push   $0xf0108da5
f01028a7:	e8 9d d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01028ac:	68 68 87 10 f0       	push   $0xf0108768
f01028b1:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01028b6:	68 00 04 00 00       	push   $0x400
f01028bb:	68 a5 8d 10 f0       	push   $0xf0108da5
f01028c0:	e8 84 d7 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01028c5:	68 f9 8f 10 f0       	push   $0xf0108ff9
f01028ca:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01028cf:	68 01 04 00 00       	push   $0x401
f01028d4:	68 a5 8d 10 f0       	push   $0xf0108da5
f01028d9:	e8 6b d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01028de:	68 7c 86 10 f0       	push   $0xf010867c
f01028e3:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01028e8:	68 04 04 00 00       	push   $0x404
f01028ed:	68 a5 8d 10 f0       	push   $0xf0108da5
f01028f2:	e8 52 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01028f7:	68 9c 87 10 f0       	push   $0xf010879c
f01028fc:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102901:	68 05 04 00 00       	push   $0x405
f0102906:	68 a5 8d 10 f0       	push   $0xf0108da5
f010290b:	e8 39 d7 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102910:	68 d0 87 10 f0       	push   $0xf01087d0
f0102915:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010291a:	68 06 04 00 00       	push   $0x406
f010291f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102924:	e8 20 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102929:	68 08 88 10 f0       	push   $0xf0108808
f010292e:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102933:	68 09 04 00 00       	push   $0x409
f0102938:	68 a5 8d 10 f0       	push   $0xf0108da5
f010293d:	e8 07 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102942:	68 40 88 10 f0       	push   $0xf0108840
f0102947:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010294c:	68 0c 04 00 00       	push   $0x40c
f0102951:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102956:	e8 ee d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010295b:	68 d0 87 10 f0       	push   $0xf01087d0
f0102960:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102965:	68 0d 04 00 00       	push   $0x40d
f010296a:	68 a5 8d 10 f0       	push   $0xf0108da5
f010296f:	e8 d5 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102974:	68 7c 88 10 f0       	push   $0xf010887c
f0102979:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010297e:	68 10 04 00 00       	push   $0x410
f0102983:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102988:	e8 bc d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010298d:	68 a8 88 10 f0       	push   $0xf01088a8
f0102992:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102997:	68 11 04 00 00       	push   $0x411
f010299c:	68 a5 8d 10 f0       	push   $0xf0108da5
f01029a1:	e8 a3 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f01029a6:	68 0f 90 10 f0       	push   $0xf010900f
f01029ab:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01029b0:	68 13 04 00 00       	push   $0x413
f01029b5:	68 a5 8d 10 f0       	push   $0xf0108da5
f01029ba:	e8 8a d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01029bf:	68 20 90 10 f0       	push   $0xf0109020
f01029c4:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01029c9:	68 14 04 00 00       	push   $0x414
f01029ce:	68 a5 8d 10 f0       	push   $0xf0108da5
f01029d3:	e8 71 d6 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01029d8:	68 d8 88 10 f0       	push   $0xf01088d8
f01029dd:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01029e2:	68 17 04 00 00       	push   $0x417
f01029e7:	68 a5 8d 10 f0       	push   $0xf0108da5
f01029ec:	e8 58 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01029f1:	68 fc 88 10 f0       	push   $0xf01088fc
f01029f6:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01029fb:	68 1b 04 00 00       	push   $0x41b
f0102a00:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102a05:	e8 3f d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a0a:	68 a8 88 10 f0       	push   $0xf01088a8
f0102a0f:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102a14:	68 1c 04 00 00       	push   $0x41c
f0102a19:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102a1e:	e8 26 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102a23:	68 c6 8f 10 f0       	push   $0xf0108fc6
f0102a28:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102a2d:	68 1d 04 00 00       	push   $0x41d
f0102a32:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102a37:	e8 0d d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a3c:	68 20 90 10 f0       	push   $0xf0109020
f0102a41:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102a46:	68 1e 04 00 00       	push   $0x41e
f0102a4b:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102a50:	e8 f4 d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102a55:	68 20 89 10 f0       	push   $0xf0108920
f0102a5a:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102a5f:	68 21 04 00 00       	push   $0x421
f0102a64:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102a69:	e8 db d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102a6e:	68 31 90 10 f0       	push   $0xf0109031
f0102a73:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102a78:	68 22 04 00 00       	push   $0x422
f0102a7d:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102a82:	e8 c2 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102a87:	68 3d 90 10 f0       	push   $0xf010903d
f0102a8c:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102a91:	68 23 04 00 00       	push   $0x423
f0102a96:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102a9b:	e8 a9 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102aa0:	68 fc 88 10 f0       	push   $0xf01088fc
f0102aa5:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102aaa:	68 27 04 00 00       	push   $0x427
f0102aaf:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102ab4:	e8 90 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102ab9:	68 58 89 10 f0       	push   $0xf0108958
f0102abe:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102ac3:	68 28 04 00 00       	push   $0x428
f0102ac8:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102acd:	e8 77 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102ad2:	68 52 90 10 f0       	push   $0xf0109052
f0102ad7:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102adc:	68 29 04 00 00       	push   $0x429
f0102ae1:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102ae6:	e8 5e d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102aeb:	68 20 90 10 f0       	push   $0xf0109020
f0102af0:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102af5:	68 2a 04 00 00       	push   $0x42a
f0102afa:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102aff:	e8 45 d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b04:	68 80 89 10 f0       	push   $0xf0108980
f0102b09:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102b0e:	68 2d 04 00 00       	push   $0x42d
f0102b13:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102b18:	e8 2c d5 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102b1d:	68 74 8f 10 f0       	push   $0xf0108f74
f0102b22:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102b27:	68 30 04 00 00       	push   $0x430
f0102b2c:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102b31:	e8 13 d5 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b36:	68 24 86 10 f0       	push   $0xf0108624
f0102b3b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102b40:	68 33 04 00 00       	push   $0x433
f0102b45:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102b4a:	e8 fa d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102b4f:	68 d7 8f 10 f0       	push   $0xf0108fd7
f0102b54:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102b59:	68 35 04 00 00       	push   $0x435
f0102b5e:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102b63:	e8 e1 d4 ff ff       	call   f0100049 <_panic>
f0102b68:	50                   	push   %eax
f0102b69:	68 14 7c 10 f0       	push   $0xf0107c14
f0102b6e:	68 3c 04 00 00       	push   $0x43c
f0102b73:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102b78:	e8 cc d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102b7d:	68 63 90 10 f0       	push   $0xf0109063
f0102b82:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102b87:	68 3d 04 00 00       	push   $0x43d
f0102b8c:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102b91:	e8 b3 d4 ff ff       	call   f0100049 <_panic>
f0102b96:	50                   	push   %eax
f0102b97:	68 14 7c 10 f0       	push   $0xf0107c14
f0102b9c:	6a 58                	push   $0x58
f0102b9e:	68 b1 8d 10 f0       	push   $0xf0108db1
f0102ba3:	e8 a1 d4 ff ff       	call   f0100049 <_panic>
f0102ba8:	50                   	push   %eax
f0102ba9:	68 14 7c 10 f0       	push   $0xf0107c14
f0102bae:	6a 58                	push   $0x58
f0102bb0:	68 b1 8d 10 f0       	push   $0xf0108db1
f0102bb5:	e8 8f d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102bba:	68 7b 90 10 f0       	push   $0xf010907b
f0102bbf:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102bc4:	68 47 04 00 00       	push   $0x447
f0102bc9:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102bce:	e8 76 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102bd3:	68 a4 89 10 f0       	push   $0xf01089a4
f0102bd8:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102bdd:	68 57 04 00 00       	push   $0x457
f0102be2:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102be7:	e8 5d d4 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102bec:	68 cc 89 10 f0       	push   $0xf01089cc
f0102bf1:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102bf6:	68 58 04 00 00       	push   $0x458
f0102bfb:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102c00:	e8 44 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c05:	68 f4 89 10 f0       	push   $0xf01089f4
f0102c0a:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102c0f:	68 5a 04 00 00       	push   $0x45a
f0102c14:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102c19:	e8 2b d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102c1e:	68 92 90 10 f0       	push   $0xf0109092
f0102c23:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102c28:	68 5c 04 00 00       	push   $0x45c
f0102c2d:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102c32:	e8 12 d4 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c37:	68 1c 8a 10 f0       	push   $0xf0108a1c
f0102c3c:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102c41:	68 5e 04 00 00       	push   $0x45e
f0102c46:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102c4b:	e8 f9 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c50:	68 40 8a 10 f0       	push   $0xf0108a40
f0102c55:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102c5a:	68 5f 04 00 00       	push   $0x45f
f0102c5f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102c64:	e8 e0 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c69:	68 70 8a 10 f0       	push   $0xf0108a70
f0102c6e:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102c73:	68 60 04 00 00       	push   $0x460
f0102c78:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102c7d:	e8 c7 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102c82:	68 94 8a 10 f0       	push   $0xf0108a94
f0102c87:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102c8c:	68 61 04 00 00       	push   $0x461
f0102c91:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102c96:	e8 ae d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102c9b:	68 c0 8a 10 f0       	push   $0xf0108ac0
f0102ca0:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102ca5:	68 63 04 00 00       	push   $0x463
f0102caa:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102caf:	e8 95 d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102cb4:	68 04 8b 10 f0       	push   $0xf0108b04
f0102cb9:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102cbe:	68 64 04 00 00       	push   $0x464
f0102cc3:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102cc8:	e8 7c d3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ccd:	50                   	push   %eax
f0102cce:	68 38 7c 10 f0       	push   $0xf0107c38
f0102cd3:	68 be 00 00 00       	push   $0xbe
f0102cd8:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102cdd:	e8 67 d3 ff ff       	call   f0100049 <_panic>
f0102ce2:	50                   	push   %eax
f0102ce3:	68 38 7c 10 f0       	push   $0xf0107c38
f0102ce8:	68 c6 00 00 00       	push   $0xc6
f0102ced:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102cf2:	e8 52 d3 ff ff       	call   f0100049 <_panic>
f0102cf7:	50                   	push   %eax
f0102cf8:	68 38 7c 10 f0       	push   $0xf0107c38
f0102cfd:	68 d2 00 00 00       	push   $0xd2
f0102d02:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102d07:	e8 3d d3 ff ff       	call   f0100049 <_panic>
f0102d0c:	53                   	push   %ebx
f0102d0d:	68 38 7c 10 f0       	push   $0xf0107c38
f0102d12:	68 17 01 00 00       	push   $0x117
f0102d17:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102d1c:	e8 28 d3 ff ff       	call   f0100049 <_panic>
f0102d21:	56                   	push   %esi
f0102d22:	68 38 7c 10 f0       	push   $0xf0107c38
f0102d27:	68 6e 03 00 00       	push   $0x36e
f0102d2c:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102d31:	e8 13 d3 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d36:	68 38 8b 10 f0       	push   $0xf0108b38
f0102d3b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102d40:	68 6e 03 00 00       	push   $0x36e
f0102d45:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102d4a:	e8 fa d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102d4f:	a1 44 e2 57 f0       	mov    0xf057e244,%eax
f0102d54:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102d57:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102d5a:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102d5f:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102d65:	89 da                	mov    %ebx,%edx
f0102d67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d6a:	e8 5e e0 ff ff       	call   f0100dcd <check_va2pa>
f0102d6f:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102d76:	76 45                	jbe    f0102dbd <mem_init+0x167b>
f0102d78:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102d7b:	39 d0                	cmp    %edx,%eax
f0102d7d:	75 55                	jne    f0102dd4 <mem_init+0x1692>
f0102d7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102d85:	81 fb 00 00 c2 ee    	cmp    $0xeec20000,%ebx
f0102d8b:	75 d8                	jne    f0102d65 <mem_init+0x1623>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102d8d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102d90:	8b 81 00 0f 00 00    	mov    0xf00(%ecx),%eax
f0102d96:	89 c2                	mov    %eax,%edx
f0102d98:	81 e2 81 00 00 00    	and    $0x81,%edx
f0102d9e:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f0102da4:	0f 85 75 01 00 00    	jne    f0102f1f <mem_init+0x17dd>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f0102daa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102daf:	0f 85 6a 01 00 00    	jne    f0102f1f <mem_init+0x17dd>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102db5:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102db8:	c1 e6 0c             	shl    $0xc,%esi
f0102dbb:	eb 3f                	jmp    f0102dfc <mem_init+0x16ba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102dbd:	ff 75 c8             	pushl  -0x38(%ebp)
f0102dc0:	68 38 7c 10 f0       	push   $0xf0107c38
f0102dc5:	68 73 03 00 00       	push   $0x373
f0102dca:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102dcf:	e8 75 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102dd4:	68 6c 8b 10 f0       	push   $0xf0108b6c
f0102dd9:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102dde:	68 73 03 00 00       	push   $0x373
f0102de3:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102de8:	e8 5c d2 ff ff       	call   f0100049 <_panic>
	return PTE_ADDR(*pgdir);
f0102ded:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102df3:	39 d0                	cmp    %edx,%eax
f0102df5:	75 25                	jne    f0102e1c <mem_init+0x16da>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102df7:	05 00 00 40 00       	add    $0x400000,%eax
f0102dfc:	39 f0                	cmp    %esi,%eax
f0102dfe:	73 35                	jae    f0102e35 <mem_init+0x16f3>
	pgdir = &pgdir[PDX(va)];
f0102e00:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102e06:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102e09:	8b 14 91             	mov    (%ecx,%edx,4),%edx
f0102e0c:	89 d3                	mov    %edx,%ebx
f0102e0e:	81 e3 81 00 00 00    	and    $0x81,%ebx
f0102e14:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
f0102e1a:	74 d1                	je     f0102ded <mem_init+0x16ab>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102e1c:	68 a0 8b 10 f0       	push   $0xf0108ba0
f0102e21:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102e26:	68 78 03 00 00       	push   $0x378
f0102e2b:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102e30:	e8 14 d2 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102e35:	83 ec 0c             	sub    $0xc,%esp
f0102e38:	68 bd 90 10 f0       	push   $0xf01090bd
f0102e3d:	e8 7f 10 00 00       	call   f0103ec1 <cprintf>
f0102e42:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e45:	b8 00 10 58 f0       	mov    $0xf0581000,%eax
f0102e4a:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102e4f:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102e52:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e54:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102e57:	89 f3                	mov    %esi,%ebx
f0102e59:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e5c:	05 00 80 00 20       	add    $0x20008000,%eax
f0102e61:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102e64:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102e6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e6d:	89 da                	mov    %ebx,%edx
f0102e6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e72:	e8 56 df ff ff       	call   f0100dcd <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102e77:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102e7d:	0f 86 a6 00 00 00    	jbe    f0102f29 <mem_init+0x17e7>
f0102e83:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102e86:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102e89:	39 d0                	cmp    %edx,%eax
f0102e8b:	0f 85 af 00 00 00    	jne    f0102f40 <mem_init+0x17fe>
f0102e91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102e97:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0102e9a:	75 d1                	jne    f0102e6d <mem_init+0x172b>
f0102e9c:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102ea2:	89 da                	mov    %ebx,%edx
f0102ea4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ea7:	e8 21 df ff ff       	call   f0100dcd <check_va2pa>
f0102eac:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102eaf:	0f 85 a4 00 00 00    	jne    f0102f59 <mem_init+0x1817>
f0102eb5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102ebb:	39 f3                	cmp    %esi,%ebx
f0102ebd:	75 e3                	jne    f0102ea2 <mem_init+0x1760>
f0102ebf:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102ec5:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102ecc:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f0102ed2:	81 ff 00 10 5c f0    	cmp    $0xf05c1000,%edi
f0102ed8:	0f 85 76 ff ff ff    	jne    f0102e54 <mem_init+0x1712>
f0102ede:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0102ee1:	e9 c7 00 00 00       	jmp    f0102fad <mem_init+0x186b>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ee6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102eec:	39 f3                	cmp    %esi,%ebx
f0102eee:	0f 83 51 ff ff ff    	jae    f0102e45 <mem_init+0x1703>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102ef4:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102efa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102efd:	e8 cb de ff ff       	call   f0100dcd <check_va2pa>
f0102f02:	39 c3                	cmp    %eax,%ebx
f0102f04:	74 e0                	je     f0102ee6 <mem_init+0x17a4>
f0102f06:	68 cc 8b 10 f0       	push   $0xf0108bcc
f0102f0b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102f10:	68 7d 03 00 00       	push   $0x37d
f0102f15:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102f1a:	e8 2a d1 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f1f:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f22:	c1 e6 0c             	shl    $0xc,%esi
f0102f25:	89 fb                	mov    %edi,%ebx
f0102f27:	eb c3                	jmp    f0102eec <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f29:	ff 75 c0             	pushl  -0x40(%ebp)
f0102f2c:	68 38 7c 10 f0       	push   $0xf0107c38
f0102f31:	68 85 03 00 00       	push   $0x385
f0102f36:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102f3b:	e8 09 d1 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102f40:	68 f4 8b 10 f0       	push   $0xf0108bf4
f0102f45:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102f4a:	68 85 03 00 00       	push   $0x385
f0102f4f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102f54:	e8 f0 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f59:	68 3c 8c 10 f0       	push   $0xf0108c3c
f0102f5e:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102f63:	68 87 03 00 00       	push   $0x387
f0102f68:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102f6d:	e8 d7 d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0102f72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f75:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102f79:	75 4e                	jne    f0102fc9 <mem_init+0x1887>
f0102f7b:	68 d4 90 10 f0       	push   $0xf01090d4
f0102f80:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102f85:	68 92 03 00 00       	push   $0x392
f0102f8a:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102f8f:	e8 b5 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_P);
f0102f94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f97:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102f9a:	a8 01                	test   $0x1,%al
f0102f9c:	74 30                	je     f0102fce <mem_init+0x188c>
				assert(pgdir[i] & PTE_W);
f0102f9e:	a8 02                	test   $0x2,%al
f0102fa0:	74 45                	je     f0102fe7 <mem_init+0x18a5>
	for (i = 0; i < NPDENTRIES; i++) {
f0102fa2:	83 c7 01             	add    $0x1,%edi
f0102fa5:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102fab:	74 6c                	je     f0103019 <mem_init+0x18d7>
		switch (i) {
f0102fad:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102fb3:	83 f8 04             	cmp    $0x4,%eax
f0102fb6:	76 ba                	jbe    f0102f72 <mem_init+0x1830>
			if (i >= PDX(KERNBASE)) {
f0102fb8:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102fbe:	77 d4                	ja     f0102f94 <mem_init+0x1852>
				assert(pgdir[i] == 0);
f0102fc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fc3:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102fc7:	75 37                	jne    f0103000 <mem_init+0x18be>
	for (i = 0; i < NPDENTRIES; i++) {
f0102fc9:	83 c7 01             	add    $0x1,%edi
f0102fcc:	eb df                	jmp    f0102fad <mem_init+0x186b>
				assert(pgdir[i] & PTE_P);
f0102fce:	68 d4 90 10 f0       	push   $0xf01090d4
f0102fd3:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102fd8:	68 96 03 00 00       	push   $0x396
f0102fdd:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102fe2:	e8 62 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0102fe7:	68 e5 90 10 f0       	push   $0xf01090e5
f0102fec:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0102ff1:	68 97 03 00 00       	push   $0x397
f0102ff6:	68 a5 8d 10 f0       	push   $0xf0108da5
f0102ffb:	e8 49 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f0103000:	68 f6 90 10 f0       	push   $0xf01090f6
f0103005:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010300a:	68 99 03 00 00       	push   $0x399
f010300f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103014:	e8 30 d0 ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103019:	83 ec 0c             	sub    $0xc,%esp
f010301c:	68 60 8c 10 f0       	push   $0xf0108c60
f0103021:	e8 9b 0e 00 00       	call   f0103ec1 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f0103026:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f0103029:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f010302c:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f010302f:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
	if ((uint32_t)kva < KERNBASE)
f0103034:	83 c4 10             	add    $0x10,%esp
f0103037:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010303c:	0f 86 fb 01 00 00    	jbe    f010323d <mem_init+0x1afb>
	return (physaddr_t)kva - KERNBASE;
f0103042:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103047:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f010304a:	b8 00 00 00 00       	mov    $0x0,%eax
f010304f:	e8 83 de ff ff       	call   f0100ed7 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0103054:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103057:	83 e0 f3             	and    $0xfffffff3,%eax
f010305a:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f010305f:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103062:	83 ec 0c             	sub    $0xc,%esp
f0103065:	6a 00                	push   $0x0
f0103067:	e8 58 e2 ff ff       	call   f01012c4 <page_alloc>
f010306c:	89 c6                	mov    %eax,%esi
f010306e:	83 c4 10             	add    $0x10,%esp
f0103071:	85 c0                	test   %eax,%eax
f0103073:	0f 84 d9 01 00 00    	je     f0103252 <mem_init+0x1b10>
	assert((pp1 = page_alloc(0)));
f0103079:	83 ec 0c             	sub    $0xc,%esp
f010307c:	6a 00                	push   $0x0
f010307e:	e8 41 e2 ff ff       	call   f01012c4 <page_alloc>
f0103083:	89 c7                	mov    %eax,%edi
f0103085:	83 c4 10             	add    $0x10,%esp
f0103088:	85 c0                	test   %eax,%eax
f010308a:	0f 84 db 01 00 00    	je     f010326b <mem_init+0x1b29>
	assert((pp2 = page_alloc(0)));
f0103090:	83 ec 0c             	sub    $0xc,%esp
f0103093:	6a 00                	push   $0x0
f0103095:	e8 2a e2 ff ff       	call   f01012c4 <page_alloc>
f010309a:	89 c3                	mov    %eax,%ebx
f010309c:	83 c4 10             	add    $0x10,%esp
f010309f:	85 c0                	test   %eax,%eax
f01030a1:	0f 84 dd 01 00 00    	je     f0103284 <mem_init+0x1b42>
	page_free(pp0);
f01030a7:	83 ec 0c             	sub    $0xc,%esp
f01030aa:	56                   	push   %esi
f01030ab:	e8 86 e2 ff ff       	call   f0101336 <page_free>
	return (pp - pages) << PGSHIFT;
f01030b0:	89 f8                	mov    %edi,%eax
f01030b2:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01030b8:	c1 f8 03             	sar    $0x3,%eax
f01030bb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030be:	89 c2                	mov    %eax,%edx
f01030c0:	c1 ea 0c             	shr    $0xc,%edx
f01030c3:	83 c4 10             	add    $0x10,%esp
f01030c6:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f01030cc:	0f 83 cb 01 00 00    	jae    f010329d <mem_init+0x1b5b>
	memset(page2kva(pp1), 1, PGSIZE);
f01030d2:	83 ec 04             	sub    $0x4,%esp
f01030d5:	68 00 10 00 00       	push   $0x1000
f01030da:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01030dc:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01030e1:	50                   	push   %eax
f01030e2:	e8 93 34 00 00       	call   f010657a <memset>
	return (pp - pages) << PGSHIFT;
f01030e7:	89 d8                	mov    %ebx,%eax
f01030e9:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01030ef:	c1 f8 03             	sar    $0x3,%eax
f01030f2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030f5:	89 c2                	mov    %eax,%edx
f01030f7:	c1 ea 0c             	shr    $0xc,%edx
f01030fa:	83 c4 10             	add    $0x10,%esp
f01030fd:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0103103:	0f 83 a6 01 00 00    	jae    f01032af <mem_init+0x1b6d>
	memset(page2kva(pp2), 2, PGSIZE);
f0103109:	83 ec 04             	sub    $0x4,%esp
f010310c:	68 00 10 00 00       	push   $0x1000
f0103111:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0103113:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103118:	50                   	push   %eax
f0103119:	e8 5c 34 00 00       	call   f010657a <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f010311e:	6a 02                	push   $0x2
f0103120:	68 00 10 00 00       	push   $0x1000
f0103125:	57                   	push   %edi
f0103126:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f010312c:	e8 cf e4 ff ff       	call   f0101600 <page_insert>
	assert(pp1->pp_ref == 1);
f0103131:	83 c4 20             	add    $0x20,%esp
f0103134:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103139:	0f 85 82 01 00 00    	jne    f01032c1 <mem_init+0x1b7f>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f010313f:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0103146:	01 01 01 
f0103149:	0f 85 8b 01 00 00    	jne    f01032da <mem_init+0x1b98>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f010314f:	6a 02                	push   $0x2
f0103151:	68 00 10 00 00       	push   $0x1000
f0103156:	53                   	push   %ebx
f0103157:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f010315d:	e8 9e e4 ff ff       	call   f0101600 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103162:	83 c4 10             	add    $0x10,%esp
f0103165:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f010316c:	02 02 02 
f010316f:	0f 85 7e 01 00 00    	jne    f01032f3 <mem_init+0x1bb1>
	assert(pp2->pp_ref == 1);
f0103175:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010317a:	0f 85 8c 01 00 00    	jne    f010330c <mem_init+0x1bca>
	assert(pp1->pp_ref == 0);
f0103180:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103185:	0f 85 9a 01 00 00    	jne    f0103325 <mem_init+0x1be3>
	*(uint32_t *)PGSIZE = 0x03030303U;
f010318b:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103192:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0103195:	89 d8                	mov    %ebx,%eax
f0103197:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f010319d:	c1 f8 03             	sar    $0x3,%eax
f01031a0:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01031a3:	89 c2                	mov    %eax,%edx
f01031a5:	c1 ea 0c             	shr    $0xc,%edx
f01031a8:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f01031ae:	0f 83 8a 01 00 00    	jae    f010333e <mem_init+0x1bfc>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01031b4:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01031bb:	03 03 03 
f01031be:	0f 85 8c 01 00 00    	jne    f0103350 <mem_init+0x1c0e>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01031c4:	83 ec 08             	sub    $0x8,%esp
f01031c7:	68 00 10 00 00       	push   $0x1000
f01031cc:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f01031d2:	e8 e3 e3 ff ff       	call   f01015ba <page_remove>
	assert(pp2->pp_ref == 0);
f01031d7:	83 c4 10             	add    $0x10,%esp
f01031da:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01031df:	0f 85 84 01 00 00    	jne    f0103369 <mem_init+0x1c27>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01031e5:	8b 0d ac fe 57 f0    	mov    0xf057feac,%ecx
f01031eb:	8b 11                	mov    (%ecx),%edx
f01031ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f01031f3:	89 f0                	mov    %esi,%eax
f01031f5:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01031fb:	c1 f8 03             	sar    $0x3,%eax
f01031fe:	c1 e0 0c             	shl    $0xc,%eax
f0103201:	39 c2                	cmp    %eax,%edx
f0103203:	0f 85 79 01 00 00    	jne    f0103382 <mem_init+0x1c40>
	kern_pgdir[0] = 0;
f0103209:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f010320f:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103214:	0f 85 81 01 00 00    	jne    f010339b <mem_init+0x1c59>
	pp0->pp_ref = 0;
f010321a:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0103220:	83 ec 0c             	sub    $0xc,%esp
f0103223:	56                   	push   %esi
f0103224:	e8 0d e1 ff ff       	call   f0101336 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103229:	c7 04 24 f4 8c 10 f0 	movl   $0xf0108cf4,(%esp)
f0103230:	e8 8c 0c 00 00       	call   f0103ec1 <cprintf>
}
f0103235:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103238:	5b                   	pop    %ebx
f0103239:	5e                   	pop    %esi
f010323a:	5f                   	pop    %edi
f010323b:	5d                   	pop    %ebp
f010323c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010323d:	50                   	push   %eax
f010323e:	68 38 7c 10 f0       	push   $0xf0107c38
f0103243:	68 ef 00 00 00       	push   $0xef
f0103248:	68 a5 8d 10 f0       	push   $0xf0108da5
f010324d:	e8 f7 cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0103252:	68 c9 8e 10 f0       	push   $0xf0108ec9
f0103257:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010325c:	68 79 04 00 00       	push   $0x479
f0103261:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103266:	e8 de cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010326b:	68 df 8e 10 f0       	push   $0xf0108edf
f0103270:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0103275:	68 7a 04 00 00       	push   $0x47a
f010327a:	68 a5 8d 10 f0       	push   $0xf0108da5
f010327f:	e8 c5 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0103284:	68 f5 8e 10 f0       	push   $0xf0108ef5
f0103289:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010328e:	68 7b 04 00 00       	push   $0x47b
f0103293:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103298:	e8 ac cd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010329d:	50                   	push   %eax
f010329e:	68 14 7c 10 f0       	push   $0xf0107c14
f01032a3:	6a 58                	push   $0x58
f01032a5:	68 b1 8d 10 f0       	push   $0xf0108db1
f01032aa:	e8 9a cd ff ff       	call   f0100049 <_panic>
f01032af:	50                   	push   %eax
f01032b0:	68 14 7c 10 f0       	push   $0xf0107c14
f01032b5:	6a 58                	push   $0x58
f01032b7:	68 b1 8d 10 f0       	push   $0xf0108db1
f01032bc:	e8 88 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01032c1:	68 c6 8f 10 f0       	push   $0xf0108fc6
f01032c6:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01032cb:	68 80 04 00 00       	push   $0x480
f01032d0:	68 a5 8d 10 f0       	push   $0xf0108da5
f01032d5:	e8 6f cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032da:	68 80 8c 10 f0       	push   $0xf0108c80
f01032df:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01032e4:	68 81 04 00 00       	push   $0x481
f01032e9:	68 a5 8d 10 f0       	push   $0xf0108da5
f01032ee:	e8 56 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01032f3:	68 a4 8c 10 f0       	push   $0xf0108ca4
f01032f8:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01032fd:	68 83 04 00 00       	push   $0x483
f0103302:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103307:	e8 3d cd ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010330c:	68 e8 8f 10 f0       	push   $0xf0108fe8
f0103311:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0103316:	68 84 04 00 00       	push   $0x484
f010331b:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103320:	e8 24 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0103325:	68 52 90 10 f0       	push   $0xf0109052
f010332a:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010332f:	68 85 04 00 00       	push   $0x485
f0103334:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103339:	e8 0b cd ff ff       	call   f0100049 <_panic>
f010333e:	50                   	push   %eax
f010333f:	68 14 7c 10 f0       	push   $0xf0107c14
f0103344:	6a 58                	push   $0x58
f0103346:	68 b1 8d 10 f0       	push   $0xf0108db1
f010334b:	e8 f9 cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103350:	68 c8 8c 10 f0       	push   $0xf0108cc8
f0103355:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010335a:	68 87 04 00 00       	push   $0x487
f010335f:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103364:	e8 e0 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103369:	68 20 90 10 f0       	push   $0xf0109020
f010336e:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0103373:	68 89 04 00 00       	push   $0x489
f0103378:	68 a5 8d 10 f0       	push   $0xf0108da5
f010337d:	e8 c7 cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103382:	68 24 86 10 f0       	push   $0xf0108624
f0103387:	68 cb 8d 10 f0       	push   $0xf0108dcb
f010338c:	68 8c 04 00 00       	push   $0x48c
f0103391:	68 a5 8d 10 f0       	push   $0xf0108da5
f0103396:	e8 ae cc ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f010339b:	68 d7 8f 10 f0       	push   $0xf0108fd7
f01033a0:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01033a5:	68 8e 04 00 00       	push   $0x48e
f01033aa:	68 a5 8d 10 f0       	push   $0xf0108da5
f01033af:	e8 95 cc ff ff       	call   f0100049 <_panic>

f01033b4 <user_mem_check>:
{
f01033b4:	55                   	push   %ebp
f01033b5:	89 e5                	mov    %esp,%ebp
f01033b7:	57                   	push   %edi
f01033b8:	56                   	push   %esi
f01033b9:	53                   	push   %ebx
f01033ba:	83 ec 1c             	sub    $0x1c,%esp
f01033bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	perm |= PTE_P;
f01033c0:	8b 7d 14             	mov    0x14(%ebp),%edi
f01033c3:	83 cf 01             	or     $0x1,%edi
	uint32_t i = (uint32_t)va; //buggy lab3 buggy
f01033c6:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	uint32_t end = (uint32_t)va + len;
f01033c9:	89 d8                	mov    %ebx,%eax
f01033cb:	03 45 10             	add    0x10(%ebp),%eax
f01033ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01033d1:	8b 75 08             	mov    0x8(%ebp),%esi
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f01033d4:	eb 19                	jmp    f01033ef <user_mem_check+0x3b>
			user_mem_check_addr = (uintptr_t)i;
f01033d6:	89 1d 3c e2 57 f0    	mov    %ebx,0xf057e23c
			return -E_FAULT;
f01033dc:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01033e1:	eb 6a                	jmp    f010344d <user_mem_check+0x99>
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f01033e3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01033e9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01033ef:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f01033f2:	73 61                	jae    f0103455 <user_mem_check+0xa1>
		if((uint32_t)va >= ULIM){
f01033f4:	81 7d e0 ff ff 7f ef 	cmpl   $0xef7fffff,-0x20(%ebp)
f01033fb:	77 d9                	ja     f01033d6 <user_mem_check+0x22>
		pte_t *the_pte = pgdir_walk(env->env_pgdir, (void *)i, 0);
f01033fd:	83 ec 04             	sub    $0x4,%esp
f0103400:	6a 00                	push   $0x0
f0103402:	53                   	push   %ebx
f0103403:	ff 76 60             	pushl  0x60(%esi)
f0103406:	e8 8f df ff ff       	call   f010139a <pgdir_walk>
		if(!the_pte || (*the_pte & perm) != perm){//lab4 bug
f010340b:	83 c4 10             	add    $0x10,%esp
f010340e:	85 c0                	test   %eax,%eax
f0103410:	74 08                	je     f010341a <user_mem_check+0x66>
f0103412:	89 fa                	mov    %edi,%edx
f0103414:	23 10                	and    (%eax),%edx
f0103416:	39 d7                	cmp    %edx,%edi
f0103418:	74 c9                	je     f01033e3 <user_mem_check+0x2f>
f010341a:	89 c6                	mov    %eax,%esi
			cprintf("PTE_P: 0x%x PTE_W: 0x%x PTE_U: 0x%x\n", PTE_P, PTE_W, PTE_U);
f010341c:	6a 04                	push   $0x4
f010341e:	6a 02                	push   $0x2
f0103420:	6a 01                	push   $0x1
f0103422:	68 20 8d 10 f0       	push   $0xf0108d20
f0103427:	e8 95 0a 00 00       	call   f0103ec1 <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f010342c:	83 c4 0c             	add    $0xc,%esp
f010342f:	89 f8                	mov    %edi,%eax
f0103431:	23 06                	and    (%esi),%eax
f0103433:	50                   	push   %eax
f0103434:	57                   	push   %edi
f0103435:	68 48 8d 10 f0       	push   $0xf0108d48
f010343a:	e8 82 0a 00 00       	call   f0103ec1 <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f010343f:	89 1d 3c e2 57 f0    	mov    %ebx,0xf057e23c
			return -E_FAULT;
f0103445:	83 c4 10             	add    $0x10,%esp
f0103448:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f010344d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103450:	5b                   	pop    %ebx
f0103451:	5e                   	pop    %esi
f0103452:	5f                   	pop    %edi
f0103453:	5d                   	pop    %ebp
f0103454:	c3                   	ret    
	return 0;
f0103455:	b8 00 00 00 00       	mov    $0x0,%eax
f010345a:	eb f1                	jmp    f010344d <user_mem_check+0x99>

f010345c <user_mem_assert>:
{
f010345c:	55                   	push   %ebp
f010345d:	89 e5                	mov    %esp,%ebp
f010345f:	53                   	push   %ebx
f0103460:	83 ec 04             	sub    $0x4,%esp
f0103463:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103466:	8b 45 14             	mov    0x14(%ebp),%eax
f0103469:	83 c8 04             	or     $0x4,%eax
f010346c:	50                   	push   %eax
f010346d:	ff 75 10             	pushl  0x10(%ebp)
f0103470:	ff 75 0c             	pushl  0xc(%ebp)
f0103473:	53                   	push   %ebx
f0103474:	e8 3b ff ff ff       	call   f01033b4 <user_mem_check>
f0103479:	83 c4 10             	add    $0x10,%esp
f010347c:	85 c0                	test   %eax,%eax
f010347e:	78 05                	js     f0103485 <user_mem_assert+0x29>
}
f0103480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103483:	c9                   	leave  
f0103484:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103485:	83 ec 04             	sub    $0x4,%esp
f0103488:	ff 35 3c e2 57 f0    	pushl  0xf057e23c
f010348e:	ff 73 48             	pushl  0x48(%ebx)
f0103491:	68 70 8d 10 f0       	push   $0xf0108d70
f0103496:	e8 26 0a 00 00       	call   f0103ec1 <cprintf>
		env_destroy(env);	// may not return
f010349b:	89 1c 24             	mov    %ebx,(%esp)
f010349e:	e8 b7 06 00 00       	call   f0103b5a <env_destroy>
f01034a3:	83 c4 10             	add    $0x10,%esp
}
f01034a6:	eb d8                	jmp    f0103480 <user_mem_assert+0x24>

f01034a8 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f01034a8:	55                   	push   %ebp
f01034a9:	89 e5                	mov    %esp,%ebp
f01034ab:	57                   	push   %edi
f01034ac:	56                   	push   %esi
f01034ad:	53                   	push   %ebx
f01034ae:	83 ec 0c             	sub    $0xc,%esp
f01034b1:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	int i = ROUNDDOWN((uint32_t)va, PGSIZE);
f01034b3:	89 d3                	mov    %edx,%ebx
f01034b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)va + len, PGSIZE);
f01034bb:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01034c2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01034c8:	39 f3                	cmp    %esi,%ebx
f01034ca:	7d 5a                	jge    f0103526 <region_alloc+0x7e>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01034cc:	83 ec 0c             	sub    $0xc,%esp
f01034cf:	6a 01                	push   $0x1
f01034d1:	e8 ee dd ff ff       	call   f01012c4 <page_alloc>
		if(!page)
f01034d6:	83 c4 10             	add    $0x10,%esp
f01034d9:	85 c0                	test   %eax,%eax
f01034db:	74 1b                	je     f01034f8 <region_alloc+0x50>
			panic("there is no page\n");
		int ret = page_insert(e->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f01034dd:	6a 06                	push   $0x6
f01034df:	53                   	push   %ebx
f01034e0:	50                   	push   %eax
f01034e1:	ff 77 60             	pushl  0x60(%edi)
f01034e4:	e8 17 e1 ff ff       	call   f0101600 <page_insert>
		if(ret)
f01034e9:	83 c4 10             	add    $0x10,%esp
f01034ec:	85 c0                	test   %eax,%eax
f01034ee:	75 1f                	jne    f010350f <region_alloc+0x67>
	for(; i < end; i+=PGSIZE){
f01034f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01034f6:	eb d0                	jmp    f01034c8 <region_alloc+0x20>
			panic("there is no page\n");
f01034f8:	83 ec 04             	sub    $0x4,%esp
f01034fb:	68 14 91 10 f0       	push   $0xf0109114
f0103500:	68 2a 01 00 00       	push   $0x12a
f0103505:	68 26 91 10 f0       	push   $0xf0109126
f010350a:	e8 3a cb ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f010350f:	83 ec 04             	sub    $0x4,%esp
f0103512:	68 31 91 10 f0       	push   $0xf0109131
f0103517:	68 2d 01 00 00       	push   $0x12d
f010351c:	68 26 91 10 f0       	push   $0xf0109126
f0103521:	e8 23 cb ff ff       	call   f0100049 <_panic>
	}
}
f0103526:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103529:	5b                   	pop    %ebx
f010352a:	5e                   	pop    %esi
f010352b:	5f                   	pop    %edi
f010352c:	5d                   	pop    %ebp
f010352d:	c3                   	ret    

f010352e <envid2env>:
{
f010352e:	55                   	push   %ebp
f010352f:	89 e5                	mov    %esp,%ebp
f0103531:	56                   	push   %esi
f0103532:	53                   	push   %ebx
f0103533:	8b 75 08             	mov    0x8(%ebp),%esi
f0103536:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103539:	85 f6                	test   %esi,%esi
f010353b:	74 31                	je     f010356e <envid2env+0x40>
	e = &envs[ENVX(envid)];
f010353d:	89 f3                	mov    %esi,%ebx
f010353f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103545:	c1 e3 07             	shl    $0x7,%ebx
f0103548:	03 1d 44 e2 57 f0    	add    0xf057e244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010354e:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103552:	74 31                	je     f0103585 <envid2env+0x57>
f0103554:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103557:	75 2c                	jne    f0103585 <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103559:	84 c0                	test   %al,%al
f010355b:	75 61                	jne    f01035be <envid2env+0x90>
	*env_store = e;
f010355d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103560:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103562:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103567:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010356a:	5b                   	pop    %ebx
f010356b:	5e                   	pop    %esi
f010356c:	5d                   	pop    %ebp
f010356d:	c3                   	ret    
		*env_store = curenv;
f010356e:	e8 0f 36 00 00       	call   f0106b82 <cpunum>
f0103573:	6b c0 74             	imul   $0x74,%eax,%eax
f0103576:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f010357c:	8b 55 0c             	mov    0xc(%ebp),%edx
f010357f:	89 02                	mov    %eax,(%edx)
		return 0;
f0103581:	89 f0                	mov    %esi,%eax
f0103583:	eb e2                	jmp    f0103567 <envid2env+0x39>
		*env_store = 0;
f0103585:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		if(e->env_status == ENV_FREE)
f010358e:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103592:	74 17                	je     f01035ab <envid2env+0x7d>
		cprintf("222222222222222222222\n");
f0103594:	83 ec 0c             	sub    $0xc,%esp
f0103597:	68 61 91 10 f0       	push   $0xf0109161
f010359c:	e8 20 09 00 00       	call   f0103ec1 <cprintf>
		return -E_BAD_ENV;
f01035a1:	83 c4 10             	add    $0x10,%esp
f01035a4:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01035a9:	eb bc                	jmp    f0103567 <envid2env+0x39>
			cprintf("ssssssssssssssssss %d\n", envid);
f01035ab:	83 ec 08             	sub    $0x8,%esp
f01035ae:	56                   	push   %esi
f01035af:	68 4a 91 10 f0       	push   $0xf010914a
f01035b4:	e8 08 09 00 00       	call   f0103ec1 <cprintf>
f01035b9:	83 c4 10             	add    $0x10,%esp
f01035bc:	eb d6                	jmp    f0103594 <envid2env+0x66>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01035be:	e8 bf 35 00 00       	call   f0106b82 <cpunum>
f01035c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01035c6:	39 98 28 00 58 f0    	cmp    %ebx,-0xfa7ffd8(%eax)
f01035cc:	74 8f                	je     f010355d <envid2env+0x2f>
f01035ce:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01035d1:	e8 ac 35 00 00       	call   f0106b82 <cpunum>
f01035d6:	6b c0 74             	imul   $0x74,%eax,%eax
f01035d9:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01035df:	3b 70 48             	cmp    0x48(%eax),%esi
f01035e2:	0f 84 75 ff ff ff    	je     f010355d <envid2env+0x2f>
		*env_store = 0;
f01035e8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		cprintf("33333333333333333333333\n");
f01035f1:	83 ec 0c             	sub    $0xc,%esp
f01035f4:	68 78 91 10 f0       	push   $0xf0109178
f01035f9:	e8 c3 08 00 00       	call   f0103ec1 <cprintf>
		return -E_BAD_ENV;
f01035fe:	83 c4 10             	add    $0x10,%esp
f0103601:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103606:	e9 5c ff ff ff       	jmp    f0103567 <envid2env+0x39>

f010360b <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f010360b:	b8 20 83 12 f0       	mov    $0xf0128320,%eax
f0103610:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103613:	b8 23 00 00 00       	mov    $0x23,%eax
f0103618:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f010361a:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f010361c:	b8 10 00 00 00       	mov    $0x10,%eax
f0103621:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103623:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103625:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103627:	ea 2e 36 10 f0 08 00 	ljmp   $0x8,$0xf010362e
	asm volatile("lldt %0" : : "r" (sel));
f010362e:	b8 00 00 00 00       	mov    $0x0,%eax
f0103633:	0f 00 d0             	lldt   %ax
}
f0103636:	c3                   	ret    

f0103637 <env_init>:
{
f0103637:	55                   	push   %ebp
f0103638:	89 e5                	mov    %esp,%ebp
f010363a:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f010363d:	8b 15 44 e2 57 f0    	mov    0xf057e244,%edx
f0103643:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
f0103649:	81 c2 00 00 02 00    	add    $0x20000,%edx
f010364f:	c7 40 c8 00 00 00 00 	movl   $0x0,-0x38(%eax)
		envs[i].env_link = &envs[i+1];
f0103656:	89 40 c4             	mov    %eax,-0x3c(%eax)
f0103659:	83 e8 80             	sub    $0xffffff80,%eax
	for(int i = 0; i < NENV - 1; i++){
f010365c:	39 d0                	cmp    %edx,%eax
f010365e:	75 ef                	jne    f010364f <env_init+0x18>
	env_free_list = envs;
f0103660:	a1 44 e2 57 f0       	mov    0xf057e244,%eax
f0103665:	a3 48 e2 57 f0       	mov    %eax,0xf057e248
	env_init_percpu();
f010366a:	e8 9c ff ff ff       	call   f010360b <env_init_percpu>
}
f010366f:	c9                   	leave  
f0103670:	c3                   	ret    

f0103671 <env_alloc>:
{
f0103671:	55                   	push   %ebp
f0103672:	89 e5                	mov    %esp,%ebp
f0103674:	53                   	push   %ebx
f0103675:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103678:	8b 1d 48 e2 57 f0    	mov    0xf057e248,%ebx
f010367e:	85 db                	test   %ebx,%ebx
f0103680:	0f 84 75 01 00 00    	je     f01037fb <env_alloc+0x18a>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103686:	83 ec 0c             	sub    $0xc,%esp
f0103689:	6a 01                	push   $0x1
f010368b:	e8 34 dc ff ff       	call   f01012c4 <page_alloc>
f0103690:	83 c4 10             	add    $0x10,%esp
f0103693:	85 c0                	test   %eax,%eax
f0103695:	0f 84 67 01 00 00    	je     f0103802 <env_alloc+0x191>
	p->pp_ref++;
f010369b:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01036a0:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f01036a6:	c1 f8 03             	sar    $0x3,%eax
f01036a9:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01036ac:	89 c2                	mov    %eax,%edx
f01036ae:	c1 ea 0c             	shr    $0xc,%edx
f01036b1:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f01036b7:	0f 83 17 01 00 00    	jae    f01037d4 <env_alloc+0x163>
	return (void *)(pa + KERNBASE);
f01036bd:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f01036c2:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy((void *)e->env_pgdir, (void *)kern_pgdir, PGSIZE);
f01036c5:	83 ec 04             	sub    $0x4,%esp
f01036c8:	68 00 10 00 00       	push   $0x1000
f01036cd:	ff 35 ac fe 57 f0    	pushl  0xf057feac
f01036d3:	50                   	push   %eax
f01036d4:	e8 4b 2f 00 00       	call   f0106624 <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01036d9:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01036dc:	83 c4 10             	add    $0x10,%esp
f01036df:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036e4:	0f 86 fc 00 00 00    	jbe    f01037e6 <env_alloc+0x175>
	return (physaddr_t)kva - KERNBASE;
f01036ea:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01036f0:	83 ca 05             	or     $0x5,%edx
f01036f3:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01036f9:	8b 43 48             	mov    0x48(%ebx),%eax
f01036fc:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103701:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103706:	ba 00 10 00 00       	mov    $0x1000,%edx
f010370b:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f010370e:	89 da                	mov    %ebx,%edx
f0103710:	2b 15 44 e2 57 f0    	sub    0xf057e244,%edx
f0103716:	c1 fa 07             	sar    $0x7,%edx
f0103719:	09 d0                	or     %edx,%eax
f010371b:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f010371e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103721:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103724:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f010372b:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103732:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f0103739:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103740:	83 ec 04             	sub    $0x4,%esp
f0103743:	6a 44                	push   $0x44
f0103745:	6a 00                	push   $0x0
f0103747:	53                   	push   %ebx
f0103748:	e8 2d 2e 00 00       	call   f010657a <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f010374d:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103753:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103759:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010375f:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103766:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f010376c:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103773:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f010377a:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f010377e:	8b 43 44             	mov    0x44(%ebx),%eax
f0103781:	a3 48 e2 57 f0       	mov    %eax,0xf057e248
	*newenv_store = e;
f0103786:	8b 45 08             	mov    0x8(%ebp),%eax
f0103789:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010378b:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010378e:	e8 ef 33 00 00       	call   f0106b82 <cpunum>
f0103793:	6b c0 74             	imul   $0x74,%eax,%eax
f0103796:	83 c4 10             	add    $0x10,%esp
f0103799:	ba 00 00 00 00       	mov    $0x0,%edx
f010379e:	83 b8 28 00 58 f0 00 	cmpl   $0x0,-0xfa7ffd8(%eax)
f01037a5:	74 11                	je     f01037b8 <env_alloc+0x147>
f01037a7:	e8 d6 33 00 00       	call   f0106b82 <cpunum>
f01037ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01037af:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01037b5:	8b 50 48             	mov    0x48(%eax),%edx
f01037b8:	83 ec 04             	sub    $0x4,%esp
f01037bb:	53                   	push   %ebx
f01037bc:	52                   	push   %edx
f01037bd:	68 91 91 10 f0       	push   $0xf0109191
f01037c2:	e8 fa 06 00 00       	call   f0103ec1 <cprintf>
	return 0;
f01037c7:	83 c4 10             	add    $0x10,%esp
f01037ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01037cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01037d2:	c9                   	leave  
f01037d3:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01037d4:	50                   	push   %eax
f01037d5:	68 14 7c 10 f0       	push   $0xf0107c14
f01037da:	6a 58                	push   $0x58
f01037dc:	68 b1 8d 10 f0       	push   $0xf0108db1
f01037e1:	e8 63 c8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037e6:	50                   	push   %eax
f01037e7:	68 38 7c 10 f0       	push   $0xf0107c38
f01037ec:	68 c6 00 00 00       	push   $0xc6
f01037f1:	68 26 91 10 f0       	push   $0xf0109126
f01037f6:	e8 4e c8 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f01037fb:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103800:	eb cd                	jmp    f01037cf <env_alloc+0x15e>
		return -E_NO_MEM;
f0103802:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103807:	eb c6                	jmp    f01037cf <env_alloc+0x15e>

f0103809 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103809:	55                   	push   %ebp
f010380a:	89 e5                	mov    %esp,%ebp
f010380c:	57                   	push   %edi
f010380d:	56                   	push   %esi
f010380e:	53                   	push   %ebx
f010380f:	83 ec 34             	sub    $0x34,%esp
f0103812:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103815:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.
	cprintf("in %s\n", __FUNCTION__);
f0103818:	68 1c 92 10 f0       	push   $0xf010921c
f010381d:	68 a6 91 10 f0       	push   $0xf01091a6
f0103822:	e8 9a 06 00 00       	call   f0103ec1 <cprintf>
	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	struct Env *e;
	int ret = env_alloc(&e, 0);
f0103827:	83 c4 08             	add    $0x8,%esp
f010382a:	6a 00                	push   $0x0
f010382c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010382f:	50                   	push   %eax
f0103830:	e8 3c fe ff ff       	call   f0103671 <env_alloc>
	if(ret)
f0103835:	83 c4 10             	add    $0x10,%esp
f0103838:	85 c0                	test   %eax,%eax
f010383a:	75 49                	jne    f0103885 <env_create+0x7c>
		panic("env_alloc failed\n");
	e->env_parent_id = 0;
f010383c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010383f:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
	e->env_type = type;
f0103846:	89 5e 50             	mov    %ebx,0x50(%esi)
	if(type == ENV_TYPE_FS){
f0103849:	83 fb 01             	cmp    $0x1,%ebx
f010384c:	74 4e                	je     f010389c <env_create+0x93>
	if (elf->e_magic != ELF_MAGIC)
f010384e:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f0103854:	75 4f                	jne    f01038a5 <env_create+0x9c>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103856:	89 fb                	mov    %edi,%ebx
f0103858:	03 5f 1c             	add    0x1c(%edi),%ebx
	eph = ph + elf->e_phnum;
f010385b:	0f b7 47 2c          	movzwl 0x2c(%edi),%eax
f010385f:	c1 e0 05             	shl    $0x5,%eax
f0103862:	01 d8                	add    %ebx,%eax
f0103864:	89 45 d0             	mov    %eax,-0x30(%ebp)
	lcr3(PADDR(e->env_pgdir));
f0103867:	8b 46 60             	mov    0x60(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f010386a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010386f:	76 4b                	jbe    f01038bc <env_create+0xb3>
	return (physaddr_t)kva - KERNBASE;
f0103871:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103876:	0f 22 d8             	mov    %eax,%cr3
	uint32_t elf_load_sz = 0;
f0103879:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0103880:	e9 89 00 00 00       	jmp    f010390e <env_create+0x105>
		panic("env_alloc failed\n");
f0103885:	83 ec 04             	sub    $0x4,%esp
f0103888:	68 ad 91 10 f0       	push   $0xf01091ad
f010388d:	68 9d 01 00 00       	push   $0x19d
f0103892:	68 26 91 10 f0       	push   $0xf0109126
f0103897:	e8 ad c7 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f010389c:	81 4e 38 00 30 00 00 	orl    $0x3000,0x38(%esi)
f01038a3:	eb a9                	jmp    f010384e <env_create+0x45>
		panic("is this a valid ELF");
f01038a5:	83 ec 04             	sub    $0x4,%esp
f01038a8:	68 bf 91 10 f0       	push   $0xf01091bf
f01038ad:	68 74 01 00 00       	push   $0x174
f01038b2:	68 26 91 10 f0       	push   $0xf0109126
f01038b7:	e8 8d c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038bc:	50                   	push   %eax
f01038bd:	68 38 7c 10 f0       	push   $0xf0107c38
f01038c2:	68 79 01 00 00       	push   $0x179
f01038c7:	68 26 91 10 f0       	push   $0xf0109126
f01038cc:	e8 78 c7 ff ff       	call   f0100049 <_panic>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f01038d1:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01038d4:	8b 53 08             	mov    0x8(%ebx),%edx
f01038d7:	89 f0                	mov    %esi,%eax
f01038d9:	e8 ca fb ff ff       	call   f01034a8 <region_alloc>
			memset((void *)ph->p_va, 0, ph->p_memsz);
f01038de:	83 ec 04             	sub    $0x4,%esp
f01038e1:	ff 73 14             	pushl  0x14(%ebx)
f01038e4:	6a 00                	push   $0x0
f01038e6:	ff 73 08             	pushl  0x8(%ebx)
f01038e9:	e8 8c 2c 00 00       	call   f010657a <memset>
			memcpy((void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f01038ee:	83 c4 0c             	add    $0xc,%esp
f01038f1:	ff 73 10             	pushl  0x10(%ebx)
f01038f4:	89 f8                	mov    %edi,%eax
f01038f6:	03 43 04             	add    0x4(%ebx),%eax
f01038f9:	50                   	push   %eax
f01038fa:	ff 73 08             	pushl  0x8(%ebx)
f01038fd:	e8 22 2d 00 00       	call   f0106624 <memcpy>
			elf_load_sz += ph->p_memsz;
f0103902:	8b 53 14             	mov    0x14(%ebx),%edx
f0103905:	01 55 d4             	add    %edx,-0x2c(%ebp)
f0103908:	83 c4 10             	add    $0x10,%esp
	for (; ph < eph; ph++){
f010390b:	83 c3 20             	add    $0x20,%ebx
f010390e:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0103911:	76 07                	jbe    f010391a <env_create+0x111>
		if(ph->p_type == ELF_PROG_LOAD){
f0103913:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103916:	75 f3                	jne    f010390b <env_create+0x102>
f0103918:	eb b7                	jmp    f01038d1 <env_create+0xc8>
	e->env_tf.tf_eip = elf->e_entry;
f010391a:	8b 47 18             	mov    0x18(%edi),%eax
f010391d:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f0103920:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103923:	05 00 00 80 00       	add    $0x800000,%eax
f0103928:	89 46 7c             	mov    %eax,0x7c(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f010392b:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103930:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103935:	89 f0                	mov    %esi,%eax
f0103937:	e8 6c fb ff ff       	call   f01034a8 <region_alloc>
	lcr3(PADDR(kern_pgdir));
f010393c:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
	if ((uint32_t)kva < KERNBASE)
f0103941:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103946:	76 10                	jbe    f0103958 <env_create+0x14f>
	return (physaddr_t)kva - KERNBASE;
f0103948:	05 00 00 00 10       	add    $0x10000000,%eax
f010394d:	0f 22 d8             	mov    %eax,%cr3
	}
	load_icode(e, binary);
}
f0103950:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103953:	5b                   	pop    %ebx
f0103954:	5e                   	pop    %esi
f0103955:	5f                   	pop    %edi
f0103956:	5d                   	pop    %ebp
f0103957:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103958:	50                   	push   %eax
f0103959:	68 38 7c 10 f0       	push   $0xf0107c38
f010395e:	68 89 01 00 00       	push   $0x189
f0103963:	68 26 91 10 f0       	push   $0xf0109126
f0103968:	e8 dc c6 ff ff       	call   f0100049 <_panic>

f010396d <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f010396d:	55                   	push   %ebp
f010396e:	89 e5                	mov    %esp,%ebp
f0103970:	57                   	push   %edi
f0103971:	56                   	push   %esi
f0103972:	53                   	push   %ebx
f0103973:	83 ec 1c             	sub    $0x1c,%esp
f0103976:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103979:	e8 04 32 00 00       	call   f0106b82 <cpunum>
f010397e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103981:	39 b8 28 00 58 f0    	cmp    %edi,-0xfa7ffd8(%eax)
f0103987:	74 48                	je     f01039d1 <env_free+0x64>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103989:	8b 5f 48             	mov    0x48(%edi),%ebx
f010398c:	e8 f1 31 00 00       	call   f0106b82 <cpunum>
f0103991:	6b c0 74             	imul   $0x74,%eax,%eax
f0103994:	ba 00 00 00 00       	mov    $0x0,%edx
f0103999:	83 b8 28 00 58 f0 00 	cmpl   $0x0,-0xfa7ffd8(%eax)
f01039a0:	74 11                	je     f01039b3 <env_free+0x46>
f01039a2:	e8 db 31 00 00       	call   f0106b82 <cpunum>
f01039a7:	6b c0 74             	imul   $0x74,%eax,%eax
f01039aa:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01039b0:	8b 50 48             	mov    0x48(%eax),%edx
f01039b3:	83 ec 04             	sub    $0x4,%esp
f01039b6:	53                   	push   %ebx
f01039b7:	52                   	push   %edx
f01039b8:	68 d3 91 10 f0       	push   $0xf01091d3
f01039bd:	e8 ff 04 00 00       	call   f0103ec1 <cprintf>
f01039c2:	83 c4 10             	add    $0x10,%esp
f01039c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01039cc:	e9 a9 00 00 00       	jmp    f0103a7a <env_free+0x10d>
		lcr3(PADDR(kern_pgdir));
f01039d1:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
	if ((uint32_t)kva < KERNBASE)
f01039d6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039db:	76 0a                	jbe    f01039e7 <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f01039dd:	05 00 00 00 10       	add    $0x10000000,%eax
f01039e2:	0f 22 d8             	mov    %eax,%cr3
f01039e5:	eb a2                	jmp    f0103989 <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01039e7:	50                   	push   %eax
f01039e8:	68 38 7c 10 f0       	push   $0xf0107c38
f01039ed:	68 b4 01 00 00       	push   $0x1b4
f01039f2:	68 26 91 10 f0       	push   $0xf0109126
f01039f7:	e8 4d c6 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01039fc:	56                   	push   %esi
f01039fd:	68 14 7c 10 f0       	push   $0xf0107c14
f0103a02:	68 c3 01 00 00       	push   $0x1c3
f0103a07:	68 26 91 10 f0       	push   $0xf0109126
f0103a0c:	e8 38 c6 ff ff       	call   f0100049 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103a11:	83 ec 08             	sub    $0x8,%esp
f0103a14:	89 d8                	mov    %ebx,%eax
f0103a16:	c1 e0 0c             	shl    $0xc,%eax
f0103a19:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103a1c:	50                   	push   %eax
f0103a1d:	ff 77 60             	pushl  0x60(%edi)
f0103a20:	e8 95 db ff ff       	call   f01015ba <page_remove>
f0103a25:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103a28:	83 c3 01             	add    $0x1,%ebx
f0103a2b:	83 c6 04             	add    $0x4,%esi
f0103a2e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103a34:	74 07                	je     f0103a3d <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f0103a36:	f6 06 01             	testb  $0x1,(%esi)
f0103a39:	74 ed                	je     f0103a28 <env_free+0xbb>
f0103a3b:	eb d4                	jmp    f0103a11 <env_free+0xa4>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103a3d:	8b 47 60             	mov    0x60(%edi),%eax
f0103a40:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a43:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103a4d:	3b 05 a8 fe 57 f0    	cmp    0xf057fea8,%eax
f0103a53:	73 69                	jae    f0103abe <env_free+0x151>
		page_decref(pa2page(pa));
f0103a55:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103a58:	a1 b0 fe 57 f0       	mov    0xf057feb0,%eax
f0103a5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103a60:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103a63:	50                   	push   %eax
f0103a64:	e8 08 d9 ff ff       	call   f0101371 <page_decref>
f0103a69:	83 c4 10             	add    $0x10,%esp
f0103a6c:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103a73:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103a78:	74 58                	je     f0103ad2 <env_free+0x165>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103a7a:	8b 47 60             	mov    0x60(%edi),%eax
f0103a7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a80:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103a83:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103a89:	74 e1                	je     f0103a6c <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103a8b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103a91:	89 f0                	mov    %esi,%eax
f0103a93:	c1 e8 0c             	shr    $0xc,%eax
f0103a96:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103a99:	39 05 a8 fe 57 f0    	cmp    %eax,0xf057fea8
f0103a9f:	0f 86 57 ff ff ff    	jbe    f01039fc <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0103aa5:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103aae:	c1 e0 14             	shl    $0x14,%eax
f0103ab1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103ab4:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103ab9:	e9 78 ff ff ff       	jmp    f0103a36 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f0103abe:	83 ec 04             	sub    $0x4,%esp
f0103ac1:	68 f0 84 10 f0       	push   $0xf01084f0
f0103ac6:	6a 51                	push   $0x51
f0103ac8:	68 b1 8d 10 f0       	push   $0xf0108db1
f0103acd:	e8 77 c5 ff ff       	call   f0100049 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103ad2:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103ad5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ada:	76 55                	jbe    f0103b31 <env_free+0x1c4>
	e->env_pgdir = 0;
f0103adc:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103ae3:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103ae8:	c1 e8 0c             	shr    $0xc,%eax
f0103aeb:	3b 05 a8 fe 57 f0    	cmp    0xf057fea8,%eax
f0103af1:	73 53                	jae    f0103b46 <env_free+0x1d9>
	page_decref(pa2page(pa));
f0103af3:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103af6:	8b 15 b0 fe 57 f0    	mov    0xf057feb0,%edx
f0103afc:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103aff:	50                   	push   %eax
f0103b00:	e8 6c d8 ff ff       	call   f0101371 <page_decref>
	cprintf("in env_free we set the ENV_FREE\n");
f0103b05:	c7 04 24 f8 91 10 f0 	movl   $0xf01091f8,(%esp)
f0103b0c:	e8 b0 03 00 00       	call   f0103ec1 <cprintf>
	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103b11:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103b18:	a1 48 e2 57 f0       	mov    0xf057e248,%eax
f0103b1d:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103b20:	89 3d 48 e2 57 f0    	mov    %edi,0xf057e248
}
f0103b26:	83 c4 10             	add    $0x10,%esp
f0103b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103b2c:	5b                   	pop    %ebx
f0103b2d:	5e                   	pop    %esi
f0103b2e:	5f                   	pop    %edi
f0103b2f:	5d                   	pop    %ebp
f0103b30:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103b31:	50                   	push   %eax
f0103b32:	68 38 7c 10 f0       	push   $0xf0107c38
f0103b37:	68 d1 01 00 00       	push   $0x1d1
f0103b3c:	68 26 91 10 f0       	push   $0xf0109126
f0103b41:	e8 03 c5 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0103b46:	83 ec 04             	sub    $0x4,%esp
f0103b49:	68 f0 84 10 f0       	push   $0xf01084f0
f0103b4e:	6a 51                	push   $0x51
f0103b50:	68 b1 8d 10 f0       	push   $0xf0108db1
f0103b55:	e8 ef c4 ff ff       	call   f0100049 <_panic>

f0103b5a <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103b5a:	55                   	push   %ebp
f0103b5b:	89 e5                	mov    %esp,%ebp
f0103b5d:	53                   	push   %ebx
f0103b5e:	83 ec 04             	sub    $0x4,%esp
f0103b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b64:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103b68:	74 21                	je     f0103b8b <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103b6a:	83 ec 0c             	sub    $0xc,%esp
f0103b6d:	53                   	push   %ebx
f0103b6e:	e8 fa fd ff ff       	call   f010396d <env_free>

	if (curenv == e) {
f0103b73:	e8 0a 30 00 00       	call   f0106b82 <cpunum>
f0103b78:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b7b:	83 c4 10             	add    $0x10,%esp
f0103b7e:	39 98 28 00 58 f0    	cmp    %ebx,-0xfa7ffd8(%eax)
f0103b84:	74 1e                	je     f0103ba4 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b89:	c9                   	leave  
f0103b8a:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b8b:	e8 f2 2f 00 00       	call   f0106b82 <cpunum>
f0103b90:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b93:	39 98 28 00 58 f0    	cmp    %ebx,-0xfa7ffd8(%eax)
f0103b99:	74 cf                	je     f0103b6a <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103b9b:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103ba2:	eb e2                	jmp    f0103b86 <env_destroy+0x2c>
		curenv = NULL;
f0103ba4:	e8 d9 2f 00 00       	call   f0106b82 <cpunum>
f0103ba9:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bac:	c7 80 28 00 58 f0 00 	movl   $0x0,-0xfa7ffd8(%eax)
f0103bb3:	00 00 00 
		sched_yield();
f0103bb6:	e8 b3 12 00 00       	call   f0104e6e <sched_yield>

f0103bbb <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103bbb:	55                   	push   %ebp
f0103bbc:	89 e5                	mov    %esp,%ebp
f0103bbe:	53                   	push   %ebx
f0103bbf:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103bc2:	e8 bb 2f 00 00       	call   f0106b82 <cpunum>
f0103bc7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bca:	8b 98 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%ebx
f0103bd0:	e8 ad 2f 00 00       	call   f0106b82 <cpunum>
f0103bd5:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f0103bd8:	8b 65 08             	mov    0x8(%ebp),%esp
f0103bdb:	61                   	popa   
f0103bdc:	07                   	pop    %es
f0103bdd:	1f                   	pop    %ds
f0103bde:	83 c4 08             	add    $0x8,%esp
f0103be1:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103be2:	83 ec 04             	sub    $0x4,%esp
f0103be5:	68 e9 91 10 f0       	push   $0xf01091e9
f0103bea:	68 08 02 00 00       	push   $0x208
f0103bef:	68 26 91 10 f0       	push   $0xf0109126
f0103bf4:	e8 50 c4 ff ff       	call   f0100049 <_panic>

f0103bf9 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103bf9:	55                   	push   %ebp
f0103bfa:	89 e5                	mov    %esp,%ebp
f0103bfc:	53                   	push   %ebx
f0103bfd:	83 ec 04             	sub    $0x4,%esp
f0103c00:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f0103c03:	e8 7a 2f 00 00       	call   f0106b82 <cpunum>
f0103c08:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c0b:	39 98 28 00 58 f0    	cmp    %ebx,-0xfa7ffd8(%eax)
f0103c11:	74 7e                	je     f0103c91 <env_run+0x98>
		if(curenv && curenv->env_status == ENV_RUNNING)
f0103c13:	e8 6a 2f 00 00       	call   f0106b82 <cpunum>
f0103c18:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c1b:	83 b8 28 00 58 f0 00 	cmpl   $0x0,-0xfa7ffd8(%eax)
f0103c22:	74 18                	je     f0103c3c <env_run+0x43>
f0103c24:	e8 59 2f 00 00       	call   f0106b82 <cpunum>
f0103c29:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c2c:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0103c32:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103c36:	0f 84 9a 00 00 00    	je     f0103cd6 <env_run+0xdd>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f0103c3c:	e8 41 2f 00 00       	call   f0106b82 <cpunum>
f0103c41:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c44:	89 98 28 00 58 f0    	mov    %ebx,-0xfa7ffd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0103c4a:	e8 33 2f 00 00       	call   f0106b82 <cpunum>
f0103c4f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c52:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0103c58:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0103c5f:	e8 1e 2f 00 00       	call   f0106b82 <cpunum>
f0103c64:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c67:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0103c6d:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f0103c71:	e8 0c 2f 00 00       	call   f0106b82 <cpunum>
f0103c76:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c79:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0103c7f:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103c82:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c87:	76 67                	jbe    f0103cf0 <env_run+0xf7>
	return (physaddr_t)kva - KERNBASE;
f0103c89:	05 00 00 00 10       	add    $0x10000000,%eax
f0103c8e:	0f 22 d8             	mov    %eax,%cr3
	}
	lcr3(PADDR(curenv->env_pgdir));
f0103c91:	e8 ec 2e 00 00       	call   f0106b82 <cpunum>
f0103c96:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c99:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0103c9f:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103ca2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ca7:	76 5c                	jbe    f0103d05 <env_run+0x10c>
	return (physaddr_t)kva - KERNBASE;
f0103ca9:	05 00 00 00 10       	add    $0x10000000,%eax
f0103cae:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103cb1:	83 ec 0c             	sub    $0xc,%esp
f0103cb4:	68 c0 83 12 f0       	push   $0xf01283c0
f0103cb9:	e8 d0 31 00 00       	call   f0106e8e <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103cbe:	f3 90                	pause  
	unlock_kernel(); //lab4 bug?
	env_pop_tf(&curenv->env_tf);
f0103cc0:	e8 bd 2e 00 00       	call   f0106b82 <cpunum>
f0103cc5:	83 c4 04             	add    $0x4,%esp
f0103cc8:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ccb:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0103cd1:	e8 e5 fe ff ff       	call   f0103bbb <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0103cd6:	e8 a7 2e 00 00       	call   f0106b82 <cpunum>
f0103cdb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cde:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0103ce4:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103ceb:	e9 4c ff ff ff       	jmp    f0103c3c <env_run+0x43>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103cf0:	50                   	push   %eax
f0103cf1:	68 38 7c 10 f0       	push   $0xf0107c38
f0103cf6:	68 2c 02 00 00       	push   $0x22c
f0103cfb:	68 26 91 10 f0       	push   $0xf0109126
f0103d00:	e8 44 c3 ff ff       	call   f0100049 <_panic>
f0103d05:	50                   	push   %eax
f0103d06:	68 38 7c 10 f0       	push   $0xf0107c38
f0103d0b:	68 2e 02 00 00       	push   $0x22e
f0103d10:	68 26 91 10 f0       	push   $0xf0109126
f0103d15:	e8 2f c3 ff ff       	call   f0100049 <_panic>

f0103d1a <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103d1a:	55                   	push   %ebp
f0103d1b:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103d1d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d20:	ba 70 00 00 00       	mov    $0x70,%edx
f0103d25:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103d26:	ba 71 00 00 00       	mov    $0x71,%edx
f0103d2b:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103d2c:	0f b6 c0             	movzbl %al,%eax
}
f0103d2f:	5d                   	pop    %ebp
f0103d30:	c3                   	ret    

f0103d31 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103d31:	55                   	push   %ebp
f0103d32:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103d34:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d37:	ba 70 00 00 00       	mov    $0x70,%edx
f0103d3c:	ee                   	out    %al,(%dx)
f0103d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d40:	ba 71 00 00 00       	mov    $0x71,%edx
f0103d45:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103d46:	5d                   	pop    %ebp
f0103d47:	c3                   	ret    

f0103d48 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103d48:	55                   	push   %ebp
f0103d49:	89 e5                	mov    %esp,%ebp
f0103d4b:	56                   	push   %esi
f0103d4c:	53                   	push   %ebx
f0103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103d50:	66 a3 a8 83 12 f0    	mov    %ax,0xf01283a8
	if (!didinit)
f0103d56:	80 3d 4c e2 57 f0 00 	cmpb   $0x0,0xf057e24c
f0103d5d:	75 07                	jne    f0103d66 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103d5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103d62:	5b                   	pop    %ebx
f0103d63:	5e                   	pop    %esi
f0103d64:	5d                   	pop    %ebp
f0103d65:	c3                   	ret    
f0103d66:	89 c6                	mov    %eax,%esi
f0103d68:	ba 21 00 00 00       	mov    $0x21,%edx
f0103d6d:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103d6e:	66 c1 e8 08          	shr    $0x8,%ax
f0103d72:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103d77:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103d78:	83 ec 0c             	sub    $0xc,%esp
f0103d7b:	68 27 92 10 f0       	push   $0xf0109227
f0103d80:	e8 3c 01 00 00       	call   f0103ec1 <cprintf>
f0103d85:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103d88:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103d8d:	0f b7 f6             	movzwl %si,%esi
f0103d90:	f7 d6                	not    %esi
f0103d92:	eb 19                	jmp    f0103dad <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f0103d94:	83 ec 08             	sub    $0x8,%esp
f0103d97:	53                   	push   %ebx
f0103d98:	68 70 99 10 f0       	push   $0xf0109970
f0103d9d:	e8 1f 01 00 00       	call   f0103ec1 <cprintf>
f0103da2:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103da5:	83 c3 01             	add    $0x1,%ebx
f0103da8:	83 fb 10             	cmp    $0x10,%ebx
f0103dab:	74 07                	je     f0103db4 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103dad:	0f a3 de             	bt     %ebx,%esi
f0103db0:	73 f3                	jae    f0103da5 <irq_setmask_8259A+0x5d>
f0103db2:	eb e0                	jmp    f0103d94 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103db4:	83 ec 0c             	sub    $0xc,%esp
f0103db7:	68 bb 90 10 f0       	push   $0xf01090bb
f0103dbc:	e8 00 01 00 00       	call   f0103ec1 <cprintf>
f0103dc1:	83 c4 10             	add    $0x10,%esp
f0103dc4:	eb 99                	jmp    f0103d5f <irq_setmask_8259A+0x17>

f0103dc6 <pic_init>:
{
f0103dc6:	55                   	push   %ebp
f0103dc7:	89 e5                	mov    %esp,%ebp
f0103dc9:	57                   	push   %edi
f0103dca:	56                   	push   %esi
f0103dcb:	53                   	push   %ebx
f0103dcc:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103dcf:	c6 05 4c e2 57 f0 01 	movb   $0x1,0xf057e24c
f0103dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103ddb:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103de0:	89 da                	mov    %ebx,%edx
f0103de2:	ee                   	out    %al,(%dx)
f0103de3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103de8:	89 ca                	mov    %ecx,%edx
f0103dea:	ee                   	out    %al,(%dx)
f0103deb:	bf 11 00 00 00       	mov    $0x11,%edi
f0103df0:	be 20 00 00 00       	mov    $0x20,%esi
f0103df5:	89 f8                	mov    %edi,%eax
f0103df7:	89 f2                	mov    %esi,%edx
f0103df9:	ee                   	out    %al,(%dx)
f0103dfa:	b8 20 00 00 00       	mov    $0x20,%eax
f0103dff:	89 da                	mov    %ebx,%edx
f0103e01:	ee                   	out    %al,(%dx)
f0103e02:	b8 04 00 00 00       	mov    $0x4,%eax
f0103e07:	ee                   	out    %al,(%dx)
f0103e08:	b8 03 00 00 00       	mov    $0x3,%eax
f0103e0d:	ee                   	out    %al,(%dx)
f0103e0e:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103e13:	89 f8                	mov    %edi,%eax
f0103e15:	89 da                	mov    %ebx,%edx
f0103e17:	ee                   	out    %al,(%dx)
f0103e18:	b8 28 00 00 00       	mov    $0x28,%eax
f0103e1d:	89 ca                	mov    %ecx,%edx
f0103e1f:	ee                   	out    %al,(%dx)
f0103e20:	b8 02 00 00 00       	mov    $0x2,%eax
f0103e25:	ee                   	out    %al,(%dx)
f0103e26:	b8 01 00 00 00       	mov    $0x1,%eax
f0103e2b:	ee                   	out    %al,(%dx)
f0103e2c:	bf 68 00 00 00       	mov    $0x68,%edi
f0103e31:	89 f8                	mov    %edi,%eax
f0103e33:	89 f2                	mov    %esi,%edx
f0103e35:	ee                   	out    %al,(%dx)
f0103e36:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103e3b:	89 c8                	mov    %ecx,%eax
f0103e3d:	ee                   	out    %al,(%dx)
f0103e3e:	89 f8                	mov    %edi,%eax
f0103e40:	89 da                	mov    %ebx,%edx
f0103e42:	ee                   	out    %al,(%dx)
f0103e43:	89 c8                	mov    %ecx,%eax
f0103e45:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103e46:	0f b7 05 a8 83 12 f0 	movzwl 0xf01283a8,%eax
f0103e4d:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103e51:	75 08                	jne    f0103e5b <pic_init+0x95>
}
f0103e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103e56:	5b                   	pop    %ebx
f0103e57:	5e                   	pop    %esi
f0103e58:	5f                   	pop    %edi
f0103e59:	5d                   	pop    %ebp
f0103e5a:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103e5b:	83 ec 0c             	sub    $0xc,%esp
f0103e5e:	0f b7 c0             	movzwl %ax,%eax
f0103e61:	50                   	push   %eax
f0103e62:	e8 e1 fe ff ff       	call   f0103d48 <irq_setmask_8259A>
f0103e67:	83 c4 10             	add    $0x10,%esp
}
f0103e6a:	eb e7                	jmp    f0103e53 <pic_init+0x8d>

f0103e6c <irq_eoi>:
f0103e6c:	b8 20 00 00 00       	mov    $0x20,%eax
f0103e71:	ba 20 00 00 00       	mov    $0x20,%edx
f0103e76:	ee                   	out    %al,(%dx)
f0103e77:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103e7c:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103e7d:	c3                   	ret    

f0103e7e <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103e7e:	55                   	push   %ebp
f0103e7f:	89 e5                	mov    %esp,%ebp
f0103e81:	53                   	push   %ebx
f0103e82:	83 ec 10             	sub    $0x10,%esp
f0103e85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0103e88:	ff 75 08             	pushl  0x8(%ebp)
f0103e8b:	e8 29 c9 ff ff       	call   f01007b9 <cputchar>
	(*cnt)++;
f0103e90:	83 03 01             	addl   $0x1,(%ebx)
}
f0103e93:	83 c4 10             	add    $0x10,%esp
f0103e96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103e99:	c9                   	leave  
f0103e9a:	c3                   	ret    

f0103e9b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103e9b:	55                   	push   %ebp
f0103e9c:	89 e5                	mov    %esp,%ebp
f0103e9e:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103ea8:	ff 75 0c             	pushl  0xc(%ebp)
f0103eab:	ff 75 08             	pushl  0x8(%ebp)
f0103eae:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103eb1:	50                   	push   %eax
f0103eb2:	68 7e 3e 10 f0       	push   $0xf0103e7e
f0103eb7:	e8 58 1e 00 00       	call   f0105d14 <vprintfmt>
	return cnt;
}
f0103ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103ebf:	c9                   	leave  
f0103ec0:	c3                   	ret    

f0103ec1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103ec1:	55                   	push   %ebp
f0103ec2:	89 e5                	mov    %esp,%ebp
f0103ec4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103ec7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103eca:	50                   	push   %eax
f0103ecb:	ff 75 08             	pushl  0x8(%ebp)
f0103ece:	e8 c8 ff ff ff       	call   f0103e9b <vcprintf>
	va_end(ap);
	return cnt;
}
f0103ed3:	c9                   	leave  
f0103ed4:	c3                   	ret    

f0103ed5 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103ed5:	55                   	push   %ebp
f0103ed6:	89 e5                	mov    %esp,%ebp
f0103ed8:	57                   	push   %edi
f0103ed9:	56                   	push   %esi
f0103eda:	53                   	push   %ebx
f0103edb:	83 ec 1c             	sub    $0x1c,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int i = cpunum();
f0103ede:	e8 9f 2c 00 00       	call   f0106b82 <cpunum>
f0103ee3:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0103ee5:	e8 98 2c 00 00       	call   f0106b82 <cpunum>
f0103eea:	6b c0 74             	imul   $0x74,%eax,%eax
f0103eed:	89 d9                	mov    %ebx,%ecx
f0103eef:	c1 e1 10             	shl    $0x10,%ecx
f0103ef2:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103ef7:	29 ca                	sub    %ecx,%edx
f0103ef9:	89 90 30 00 58 f0    	mov    %edx,-0xfa7ffd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f0103eff:	e8 7e 2c 00 00       	call   f0106b82 <cpunum>
f0103f04:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f07:	66 c7 80 34 00 58 f0 	movw   $0x10,-0xfa7ffcc(%eax)
f0103f0e:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f0103f10:	e8 6d 2c 00 00       	call   f0106b82 <cpunum>
f0103f15:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f18:	66 c7 80 92 00 58 f0 	movw   $0x68,-0xfa7ff6e(%eax)
f0103f1f:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0103f21:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103f28:	89 fb                	mov    %edi,%ebx
f0103f2a:	c1 fb 03             	sar    $0x3,%ebx
f0103f2d:	e8 50 2c 00 00       	call   f0106b82 <cpunum>
f0103f32:	89 c6                	mov    %eax,%esi
f0103f34:	e8 49 2c 00 00       	call   f0106b82 <cpunum>
f0103f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103f3c:	e8 41 2c 00 00       	call   f0106b82 <cpunum>
f0103f41:	66 c7 04 dd 40 83 12 	movw   $0x67,-0xfed7cc0(,%ebx,8)
f0103f48:	f0 67 00 
f0103f4b:	6b f6 74             	imul   $0x74,%esi,%esi
f0103f4e:	81 c6 2c 00 58 f0    	add    $0xf058002c,%esi
f0103f54:	66 89 34 dd 42 83 12 	mov    %si,-0xfed7cbe(,%ebx,8)
f0103f5b:	f0 
f0103f5c:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103f60:	81 c2 2c 00 58 f0    	add    $0xf058002c,%edx
f0103f66:	c1 ea 10             	shr    $0x10,%edx
f0103f69:	88 14 dd 44 83 12 f0 	mov    %dl,-0xfed7cbc(,%ebx,8)
f0103f70:	c6 04 dd 46 83 12 f0 	movb   $0x40,-0xfed7cba(,%ebx,8)
f0103f77:	40 
f0103f78:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f7b:	05 2c 00 58 f0       	add    $0xf058002c,%eax
f0103f80:	c1 e8 18             	shr    $0x18,%eax
f0103f83:	88 04 dd 47 83 12 f0 	mov    %al,-0xfed7cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f0103f8a:	c6 04 dd 45 83 12 f0 	movb   $0x89,-0xfed7cbb(,%ebx,8)
f0103f91:	89 
	asm volatile("ltr %0" : : "r" (sel));
f0103f92:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f0103f95:	b8 ac 83 12 f0       	mov    $0xf01283ac,%eax
f0103f9a:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f0103f9d:	83 c4 1c             	add    $0x1c,%esp
f0103fa0:	5b                   	pop    %ebx
f0103fa1:	5e                   	pop    %esi
f0103fa2:	5f                   	pop    %edi
f0103fa3:	5d                   	pop    %ebp
f0103fa4:	c3                   	ret    

f0103fa5 <trap_init>:
{
f0103fa5:	55                   	push   %ebp
f0103fa6:	89 e5                	mov    %esp,%ebp
f0103fa8:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f0103fab:	b8 76 4c 10 f0       	mov    $0xf0104c76,%eax
f0103fb0:	66 a3 60 e2 57 f0    	mov    %ax,0xf057e260
f0103fb6:	66 c7 05 62 e2 57 f0 	movw   $0x8,0xf057e262
f0103fbd:	08 00 
f0103fbf:	c6 05 64 e2 57 f0 00 	movb   $0x0,0xf057e264
f0103fc6:	c6 05 65 e2 57 f0 8e 	movb   $0x8e,0xf057e265
f0103fcd:	c1 e8 10             	shr    $0x10,%eax
f0103fd0:	66 a3 66 e2 57 f0    	mov    %ax,0xf057e266
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f0103fd6:	b8 80 4c 10 f0       	mov    $0xf0104c80,%eax
f0103fdb:	66 a3 68 e2 57 f0    	mov    %ax,0xf057e268
f0103fe1:	66 c7 05 6a e2 57 f0 	movw   $0x8,0xf057e26a
f0103fe8:	08 00 
f0103fea:	c6 05 6c e2 57 f0 00 	movb   $0x0,0xf057e26c
f0103ff1:	c6 05 6d e2 57 f0 8e 	movb   $0x8e,0xf057e26d
f0103ff8:	c1 e8 10             	shr    $0x10,%eax
f0103ffb:	66 a3 6e e2 57 f0    	mov    %ax,0xf057e26e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0104001:	b8 8a 4c 10 f0       	mov    $0xf0104c8a,%eax
f0104006:	66 a3 70 e2 57 f0    	mov    %ax,0xf057e270
f010400c:	66 c7 05 72 e2 57 f0 	movw   $0x8,0xf057e272
f0104013:	08 00 
f0104015:	c6 05 74 e2 57 f0 00 	movb   $0x0,0xf057e274
f010401c:	c6 05 75 e2 57 f0 8e 	movb   $0x8e,0xf057e275
f0104023:	c1 e8 10             	shr    $0x10,%eax
f0104026:	66 a3 76 e2 57 f0    	mov    %ax,0xf057e276
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f010402c:	b8 94 4c 10 f0       	mov    $0xf0104c94,%eax
f0104031:	66 a3 78 e2 57 f0    	mov    %ax,0xf057e278
f0104037:	66 c7 05 7a e2 57 f0 	movw   $0x8,0xf057e27a
f010403e:	08 00 
f0104040:	c6 05 7c e2 57 f0 00 	movb   $0x0,0xf057e27c
f0104047:	c6 05 7d e2 57 f0 ee 	movb   $0xee,0xf057e27d
f010404e:	c1 e8 10             	shr    $0x10,%eax
f0104051:	66 a3 7e e2 57 f0    	mov    %ax,0xf057e27e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f0104057:	b8 9e 4c 10 f0       	mov    $0xf0104c9e,%eax
f010405c:	66 a3 80 e2 57 f0    	mov    %ax,0xf057e280
f0104062:	66 c7 05 82 e2 57 f0 	movw   $0x8,0xf057e282
f0104069:	08 00 
f010406b:	c6 05 84 e2 57 f0 00 	movb   $0x0,0xf057e284
f0104072:	c6 05 85 e2 57 f0 ee 	movb   $0xee,0xf057e285
f0104079:	c1 e8 10             	shr    $0x10,%eax
f010407c:	66 a3 86 e2 57 f0    	mov    %ax,0xf057e286
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f0104082:	b8 a8 4c 10 f0       	mov    $0xf0104ca8,%eax
f0104087:	66 a3 88 e2 57 f0    	mov    %ax,0xf057e288
f010408d:	66 c7 05 8a e2 57 f0 	movw   $0x8,0xf057e28a
f0104094:	08 00 
f0104096:	c6 05 8c e2 57 f0 00 	movb   $0x0,0xf057e28c
f010409d:	c6 05 8d e2 57 f0 ee 	movb   $0xee,0xf057e28d
f01040a4:	c1 e8 10             	shr    $0x10,%eax
f01040a7:	66 a3 8e e2 57 f0    	mov    %ax,0xf057e28e
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f01040ad:	b8 b2 4c 10 f0       	mov    $0xf0104cb2,%eax
f01040b2:	66 a3 90 e2 57 f0    	mov    %ax,0xf057e290
f01040b8:	66 c7 05 92 e2 57 f0 	movw   $0x8,0xf057e292
f01040bf:	08 00 
f01040c1:	c6 05 94 e2 57 f0 00 	movb   $0x0,0xf057e294
f01040c8:	c6 05 95 e2 57 f0 8e 	movb   $0x8e,0xf057e295
f01040cf:	c1 e8 10             	shr    $0x10,%eax
f01040d2:	66 a3 96 e2 57 f0    	mov    %ax,0xf057e296
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f01040d8:	b8 bc 4c 10 f0       	mov    $0xf0104cbc,%eax
f01040dd:	66 a3 98 e2 57 f0    	mov    %ax,0xf057e298
f01040e3:	66 c7 05 9a e2 57 f0 	movw   $0x8,0xf057e29a
f01040ea:	08 00 
f01040ec:	c6 05 9c e2 57 f0 00 	movb   $0x0,0xf057e29c
f01040f3:	c6 05 9d e2 57 f0 8e 	movb   $0x8e,0xf057e29d
f01040fa:	c1 e8 10             	shr    $0x10,%eax
f01040fd:	66 a3 9e e2 57 f0    	mov    %ax,0xf057e29e
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f0104103:	b8 c6 4c 10 f0       	mov    $0xf0104cc6,%eax
f0104108:	66 a3 a0 e2 57 f0    	mov    %ax,0xf057e2a0
f010410e:	66 c7 05 a2 e2 57 f0 	movw   $0x8,0xf057e2a2
f0104115:	08 00 
f0104117:	c6 05 a4 e2 57 f0 00 	movb   $0x0,0xf057e2a4
f010411e:	c6 05 a5 e2 57 f0 8e 	movb   $0x8e,0xf057e2a5
f0104125:	c1 e8 10             	shr    $0x10,%eax
f0104128:	66 a3 a6 e2 57 f0    	mov    %ax,0xf057e2a6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f010412e:	b8 ce 4c 10 f0       	mov    $0xf0104cce,%eax
f0104133:	66 a3 b0 e2 57 f0    	mov    %ax,0xf057e2b0
f0104139:	66 c7 05 b2 e2 57 f0 	movw   $0x8,0xf057e2b2
f0104140:	08 00 
f0104142:	c6 05 b4 e2 57 f0 00 	movb   $0x0,0xf057e2b4
f0104149:	c6 05 b5 e2 57 f0 8e 	movb   $0x8e,0xf057e2b5
f0104150:	c1 e8 10             	shr    $0x10,%eax
f0104153:	66 a3 b6 e2 57 f0    	mov    %ax,0xf057e2b6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f0104159:	b8 d6 4c 10 f0       	mov    $0xf0104cd6,%eax
f010415e:	66 a3 b8 e2 57 f0    	mov    %ax,0xf057e2b8
f0104164:	66 c7 05 ba e2 57 f0 	movw   $0x8,0xf057e2ba
f010416b:	08 00 
f010416d:	c6 05 bc e2 57 f0 00 	movb   $0x0,0xf057e2bc
f0104174:	c6 05 bd e2 57 f0 8e 	movb   $0x8e,0xf057e2bd
f010417b:	c1 e8 10             	shr    $0x10,%eax
f010417e:	66 a3 be e2 57 f0    	mov    %ax,0xf057e2be
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f0104184:	b8 de 4c 10 f0       	mov    $0xf0104cde,%eax
f0104189:	66 a3 c0 e2 57 f0    	mov    %ax,0xf057e2c0
f010418f:	66 c7 05 c2 e2 57 f0 	movw   $0x8,0xf057e2c2
f0104196:	08 00 
f0104198:	c6 05 c4 e2 57 f0 00 	movb   $0x0,0xf057e2c4
f010419f:	c6 05 c5 e2 57 f0 8e 	movb   $0x8e,0xf057e2c5
f01041a6:	c1 e8 10             	shr    $0x10,%eax
f01041a9:	66 a3 c6 e2 57 f0    	mov    %ax,0xf057e2c6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f01041af:	b8 e6 4c 10 f0       	mov    $0xf0104ce6,%eax
f01041b4:	66 a3 c8 e2 57 f0    	mov    %ax,0xf057e2c8
f01041ba:	66 c7 05 ca e2 57 f0 	movw   $0x8,0xf057e2ca
f01041c1:	08 00 
f01041c3:	c6 05 cc e2 57 f0 00 	movb   $0x0,0xf057e2cc
f01041ca:	c6 05 cd e2 57 f0 8e 	movb   $0x8e,0xf057e2cd
f01041d1:	c1 e8 10             	shr    $0x10,%eax
f01041d4:	66 a3 ce e2 57 f0    	mov    %ax,0xf057e2ce
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f01041da:	b8 ee 4c 10 f0       	mov    $0xf0104cee,%eax
f01041df:	66 a3 d0 e2 57 f0    	mov    %ax,0xf057e2d0
f01041e5:	66 c7 05 d2 e2 57 f0 	movw   $0x8,0xf057e2d2
f01041ec:	08 00 
f01041ee:	c6 05 d4 e2 57 f0 00 	movb   $0x0,0xf057e2d4
f01041f5:	c6 05 d5 e2 57 f0 8e 	movb   $0x8e,0xf057e2d5
f01041fc:	c1 e8 10             	shr    $0x10,%eax
f01041ff:	66 a3 d6 e2 57 f0    	mov    %ax,0xf057e2d6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f0104205:	b8 f6 4c 10 f0       	mov    $0xf0104cf6,%eax
f010420a:	66 a3 e0 e2 57 f0    	mov    %ax,0xf057e2e0
f0104210:	66 c7 05 e2 e2 57 f0 	movw   $0x8,0xf057e2e2
f0104217:	08 00 
f0104219:	c6 05 e4 e2 57 f0 00 	movb   $0x0,0xf057e2e4
f0104220:	c6 05 e5 e2 57 f0 8e 	movb   $0x8e,0xf057e2e5
f0104227:	c1 e8 10             	shr    $0x10,%eax
f010422a:	66 a3 e6 e2 57 f0    	mov    %ax,0xf057e2e6
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f0104230:	b8 fc 4c 10 f0       	mov    $0xf0104cfc,%eax
f0104235:	66 a3 e8 e2 57 f0    	mov    %ax,0xf057e2e8
f010423b:	66 c7 05 ea e2 57 f0 	movw   $0x8,0xf057e2ea
f0104242:	08 00 
f0104244:	c6 05 ec e2 57 f0 00 	movb   $0x0,0xf057e2ec
f010424b:	c6 05 ed e2 57 f0 8e 	movb   $0x8e,0xf057e2ed
f0104252:	c1 e8 10             	shr    $0x10,%eax
f0104255:	66 a3 ee e2 57 f0    	mov    %ax,0xf057e2ee
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f010425b:	b8 00 4d 10 f0       	mov    $0xf0104d00,%eax
f0104260:	66 a3 f0 e2 57 f0    	mov    %ax,0xf057e2f0
f0104266:	66 c7 05 f2 e2 57 f0 	movw   $0x8,0xf057e2f2
f010426d:	08 00 
f010426f:	c6 05 f4 e2 57 f0 00 	movb   $0x0,0xf057e2f4
f0104276:	c6 05 f5 e2 57 f0 8e 	movb   $0x8e,0xf057e2f5
f010427d:	c1 e8 10             	shr    $0x10,%eax
f0104280:	66 a3 f6 e2 57 f0    	mov    %ax,0xf057e2f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f0104286:	b8 06 4d 10 f0       	mov    $0xf0104d06,%eax
f010428b:	66 a3 f8 e2 57 f0    	mov    %ax,0xf057e2f8
f0104291:	66 c7 05 fa e2 57 f0 	movw   $0x8,0xf057e2fa
f0104298:	08 00 
f010429a:	c6 05 fc e2 57 f0 00 	movb   $0x0,0xf057e2fc
f01042a1:	c6 05 fd e2 57 f0 8e 	movb   $0x8e,0xf057e2fd
f01042a8:	c1 e8 10             	shr    $0x10,%eax
f01042ab:	66 a3 fe e2 57 f0    	mov    %ax,0xf057e2fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f01042b1:	b8 0c 4d 10 f0       	mov    $0xf0104d0c,%eax
f01042b6:	66 a3 e0 e3 57 f0    	mov    %ax,0xf057e3e0
f01042bc:	66 c7 05 e2 e3 57 f0 	movw   $0x8,0xf057e3e2
f01042c3:	08 00 
f01042c5:	c6 05 e4 e3 57 f0 00 	movb   $0x0,0xf057e3e4
f01042cc:	c6 05 e5 e3 57 f0 ee 	movb   $0xee,0xf057e3e5
f01042d3:	c1 e8 10             	shr    $0x10,%eax
f01042d6:	66 a3 e6 e3 57 f0    	mov    %ax,0xf057e3e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f01042dc:	b8 12 4d 10 f0       	mov    $0xf0104d12,%eax
f01042e1:	66 a3 60 e3 57 f0    	mov    %ax,0xf057e360
f01042e7:	66 c7 05 62 e3 57 f0 	movw   $0x8,0xf057e362
f01042ee:	08 00 
f01042f0:	c6 05 64 e3 57 f0 00 	movb   $0x0,0xf057e364
f01042f7:	c6 05 65 e3 57 f0 8e 	movb   $0x8e,0xf057e365
f01042fe:	c1 e8 10             	shr    $0x10,%eax
f0104301:	66 a3 66 e3 57 f0    	mov    %ax,0xf057e366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f0104307:	b8 18 4d 10 f0       	mov    $0xf0104d18,%eax
f010430c:	66 a3 68 e3 57 f0    	mov    %ax,0xf057e368
f0104312:	66 c7 05 6a e3 57 f0 	movw   $0x8,0xf057e36a
f0104319:	08 00 
f010431b:	c6 05 6c e3 57 f0 00 	movb   $0x0,0xf057e36c
f0104322:	c6 05 6d e3 57 f0 8e 	movb   $0x8e,0xf057e36d
f0104329:	c1 e8 10             	shr    $0x10,%eax
f010432c:	66 a3 6e e3 57 f0    	mov    %ax,0xf057e36e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f0104332:	b8 1e 4d 10 f0       	mov    $0xf0104d1e,%eax
f0104337:	66 a3 70 e3 57 f0    	mov    %ax,0xf057e370
f010433d:	66 c7 05 72 e3 57 f0 	movw   $0x8,0xf057e372
f0104344:	08 00 
f0104346:	c6 05 74 e3 57 f0 00 	movb   $0x0,0xf057e374
f010434d:	c6 05 75 e3 57 f0 8e 	movb   $0x8e,0xf057e375
f0104354:	c1 e8 10             	shr    $0x10,%eax
f0104357:	66 a3 76 e3 57 f0    	mov    %ax,0xf057e376
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f010435d:	b8 24 4d 10 f0       	mov    $0xf0104d24,%eax
f0104362:	66 a3 78 e3 57 f0    	mov    %ax,0xf057e378
f0104368:	66 c7 05 7a e3 57 f0 	movw   $0x8,0xf057e37a
f010436f:	08 00 
f0104371:	c6 05 7c e3 57 f0 00 	movb   $0x0,0xf057e37c
f0104378:	c6 05 7d e3 57 f0 8e 	movb   $0x8e,0xf057e37d
f010437f:	c1 e8 10             	shr    $0x10,%eax
f0104382:	66 a3 7e e3 57 f0    	mov    %ax,0xf057e37e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f0104388:	b8 2a 4d 10 f0       	mov    $0xf0104d2a,%eax
f010438d:	66 a3 80 e3 57 f0    	mov    %ax,0xf057e380
f0104393:	66 c7 05 82 e3 57 f0 	movw   $0x8,0xf057e382
f010439a:	08 00 
f010439c:	c6 05 84 e3 57 f0 00 	movb   $0x0,0xf057e384
f01043a3:	c6 05 85 e3 57 f0 8e 	movb   $0x8e,0xf057e385
f01043aa:	c1 e8 10             	shr    $0x10,%eax
f01043ad:	66 a3 86 e3 57 f0    	mov    %ax,0xf057e386
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f01043b3:	b8 30 4d 10 f0       	mov    $0xf0104d30,%eax
f01043b8:	66 a3 88 e3 57 f0    	mov    %ax,0xf057e388
f01043be:	66 c7 05 8a e3 57 f0 	movw   $0x8,0xf057e38a
f01043c5:	08 00 
f01043c7:	c6 05 8c e3 57 f0 00 	movb   $0x0,0xf057e38c
f01043ce:	c6 05 8d e3 57 f0 8e 	movb   $0x8e,0xf057e38d
f01043d5:	c1 e8 10             	shr    $0x10,%eax
f01043d8:	66 a3 8e e3 57 f0    	mov    %ax,0xf057e38e
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f01043de:	b8 36 4d 10 f0       	mov    $0xf0104d36,%eax
f01043e3:	66 a3 90 e3 57 f0    	mov    %ax,0xf057e390
f01043e9:	66 c7 05 92 e3 57 f0 	movw   $0x8,0xf057e392
f01043f0:	08 00 
f01043f2:	c6 05 94 e3 57 f0 00 	movb   $0x0,0xf057e394
f01043f9:	c6 05 95 e3 57 f0 8e 	movb   $0x8e,0xf057e395
f0104400:	c1 e8 10             	shr    $0x10,%eax
f0104403:	66 a3 96 e3 57 f0    	mov    %ax,0xf057e396
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f0104409:	b8 3c 4d 10 f0       	mov    $0xf0104d3c,%eax
f010440e:	66 a3 98 e3 57 f0    	mov    %ax,0xf057e398
f0104414:	66 c7 05 9a e3 57 f0 	movw   $0x8,0xf057e39a
f010441b:	08 00 
f010441d:	c6 05 9c e3 57 f0 00 	movb   $0x0,0xf057e39c
f0104424:	c6 05 9d e3 57 f0 8e 	movb   $0x8e,0xf057e39d
f010442b:	c1 e8 10             	shr    $0x10,%eax
f010442e:	66 a3 9e e3 57 f0    	mov    %ax,0xf057e39e
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f0104434:	b8 42 4d 10 f0       	mov    $0xf0104d42,%eax
f0104439:	66 a3 a0 e3 57 f0    	mov    %ax,0xf057e3a0
f010443f:	66 c7 05 a2 e3 57 f0 	movw   $0x8,0xf057e3a2
f0104446:	08 00 
f0104448:	c6 05 a4 e3 57 f0 00 	movb   $0x0,0xf057e3a4
f010444f:	c6 05 a5 e3 57 f0 8e 	movb   $0x8e,0xf057e3a5
f0104456:	c1 e8 10             	shr    $0x10,%eax
f0104459:	66 a3 a6 e3 57 f0    	mov    %ax,0xf057e3a6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f010445f:	b8 48 4d 10 f0       	mov    $0xf0104d48,%eax
f0104464:	66 a3 a8 e3 57 f0    	mov    %ax,0xf057e3a8
f010446a:	66 c7 05 aa e3 57 f0 	movw   $0x8,0xf057e3aa
f0104471:	08 00 
f0104473:	c6 05 ac e3 57 f0 00 	movb   $0x0,0xf057e3ac
f010447a:	c6 05 ad e3 57 f0 8e 	movb   $0x8e,0xf057e3ad
f0104481:	c1 e8 10             	shr    $0x10,%eax
f0104484:	66 a3 ae e3 57 f0    	mov    %ax,0xf057e3ae
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f010448a:	b8 4e 4d 10 f0       	mov    $0xf0104d4e,%eax
f010448f:	66 a3 b0 e3 57 f0    	mov    %ax,0xf057e3b0
f0104495:	66 c7 05 b2 e3 57 f0 	movw   $0x8,0xf057e3b2
f010449c:	08 00 
f010449e:	c6 05 b4 e3 57 f0 00 	movb   $0x0,0xf057e3b4
f01044a5:	c6 05 b5 e3 57 f0 8e 	movb   $0x8e,0xf057e3b5
f01044ac:	c1 e8 10             	shr    $0x10,%eax
f01044af:	66 a3 b6 e3 57 f0    	mov    %ax,0xf057e3b6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f01044b5:	b8 54 4d 10 f0       	mov    $0xf0104d54,%eax
f01044ba:	66 a3 b8 e3 57 f0    	mov    %ax,0xf057e3b8
f01044c0:	66 c7 05 ba e3 57 f0 	movw   $0x8,0xf057e3ba
f01044c7:	08 00 
f01044c9:	c6 05 bc e3 57 f0 00 	movb   $0x0,0xf057e3bc
f01044d0:	c6 05 bd e3 57 f0 8e 	movb   $0x8e,0xf057e3bd
f01044d7:	c1 e8 10             	shr    $0x10,%eax
f01044da:	66 a3 be e3 57 f0    	mov    %ax,0xf057e3be
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f01044e0:	b8 5a 4d 10 f0       	mov    $0xf0104d5a,%eax
f01044e5:	66 a3 c0 e3 57 f0    	mov    %ax,0xf057e3c0
f01044eb:	66 c7 05 c2 e3 57 f0 	movw   $0x8,0xf057e3c2
f01044f2:	08 00 
f01044f4:	c6 05 c4 e3 57 f0 00 	movb   $0x0,0xf057e3c4
f01044fb:	c6 05 c5 e3 57 f0 8e 	movb   $0x8e,0xf057e3c5
f0104502:	c1 e8 10             	shr    $0x10,%eax
f0104505:	66 a3 c6 e3 57 f0    	mov    %ax,0xf057e3c6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f010450b:	b8 60 4d 10 f0       	mov    $0xf0104d60,%eax
f0104510:	66 a3 c8 e3 57 f0    	mov    %ax,0xf057e3c8
f0104516:	66 c7 05 ca e3 57 f0 	movw   $0x8,0xf057e3ca
f010451d:	08 00 
f010451f:	c6 05 cc e3 57 f0 00 	movb   $0x0,0xf057e3cc
f0104526:	c6 05 cd e3 57 f0 8e 	movb   $0x8e,0xf057e3cd
f010452d:	c1 e8 10             	shr    $0x10,%eax
f0104530:	66 a3 ce e3 57 f0    	mov    %ax,0xf057e3ce
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f0104536:	b8 66 4d 10 f0       	mov    $0xf0104d66,%eax
f010453b:	66 a3 d0 e3 57 f0    	mov    %ax,0xf057e3d0
f0104541:	66 c7 05 d2 e3 57 f0 	movw   $0x8,0xf057e3d2
f0104548:	08 00 
f010454a:	c6 05 d4 e3 57 f0 00 	movb   $0x0,0xf057e3d4
f0104551:	c6 05 d5 e3 57 f0 8e 	movb   $0x8e,0xf057e3d5
f0104558:	c1 e8 10             	shr    $0x10,%eax
f010455b:	66 a3 d6 e3 57 f0    	mov    %ax,0xf057e3d6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f0104561:	b8 6c 4d 10 f0       	mov    $0xf0104d6c,%eax
f0104566:	66 a3 d8 e3 57 f0    	mov    %ax,0xf057e3d8
f010456c:	66 c7 05 da e3 57 f0 	movw   $0x8,0xf057e3da
f0104573:	08 00 
f0104575:	c6 05 dc e3 57 f0 00 	movb   $0x0,0xf057e3dc
f010457c:	c6 05 dd e3 57 f0 8e 	movb   $0x8e,0xf057e3dd
f0104583:	c1 e8 10             	shr    $0x10,%eax
f0104586:	66 a3 de e3 57 f0    	mov    %ax,0xf057e3de
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f010458c:	b8 72 4d 10 f0       	mov    $0xf0104d72,%eax
f0104591:	66 a3 f8 e3 57 f0    	mov    %ax,0xf057e3f8
f0104597:	66 c7 05 fa e3 57 f0 	movw   $0x8,0xf057e3fa
f010459e:	08 00 
f01045a0:	c6 05 fc e3 57 f0 00 	movb   $0x0,0xf057e3fc
f01045a7:	c6 05 fd e3 57 f0 8e 	movb   $0x8e,0xf057e3fd
f01045ae:	c1 e8 10             	shr    $0x10,%eax
f01045b1:	66 a3 fe e3 57 f0    	mov    %ax,0xf057e3fe
	trap_init_percpu();
f01045b7:	e8 19 f9 ff ff       	call   f0103ed5 <trap_init_percpu>
}
f01045bc:	c9                   	leave  
f01045bd:	c3                   	ret    

f01045be <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f01045be:	55                   	push   %ebp
f01045bf:	89 e5                	mov    %esp,%ebp
f01045c1:	53                   	push   %ebx
f01045c2:	83 ec 0c             	sub    $0xc,%esp
f01045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01045c8:	ff 33                	pushl  (%ebx)
f01045ca:	68 3b 92 10 f0       	push   $0xf010923b
f01045cf:	e8 ed f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01045d4:	83 c4 08             	add    $0x8,%esp
f01045d7:	ff 73 04             	pushl  0x4(%ebx)
f01045da:	68 4a 92 10 f0       	push   $0xf010924a
f01045df:	e8 dd f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01045e4:	83 c4 08             	add    $0x8,%esp
f01045e7:	ff 73 08             	pushl  0x8(%ebx)
f01045ea:	68 59 92 10 f0       	push   $0xf0109259
f01045ef:	e8 cd f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01045f4:	83 c4 08             	add    $0x8,%esp
f01045f7:	ff 73 0c             	pushl  0xc(%ebx)
f01045fa:	68 68 92 10 f0       	push   $0xf0109268
f01045ff:	e8 bd f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104604:	83 c4 08             	add    $0x8,%esp
f0104607:	ff 73 10             	pushl  0x10(%ebx)
f010460a:	68 77 92 10 f0       	push   $0xf0109277
f010460f:	e8 ad f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104614:	83 c4 08             	add    $0x8,%esp
f0104617:	ff 73 14             	pushl  0x14(%ebx)
f010461a:	68 86 92 10 f0       	push   $0xf0109286
f010461f:	e8 9d f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104624:	83 c4 08             	add    $0x8,%esp
f0104627:	ff 73 18             	pushl  0x18(%ebx)
f010462a:	68 95 92 10 f0       	push   $0xf0109295
f010462f:	e8 8d f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104634:	83 c4 08             	add    $0x8,%esp
f0104637:	ff 73 1c             	pushl  0x1c(%ebx)
f010463a:	68 a4 92 10 f0       	push   $0xf01092a4
f010463f:	e8 7d f8 ff ff       	call   f0103ec1 <cprintf>
}
f0104644:	83 c4 10             	add    $0x10,%esp
f0104647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010464a:	c9                   	leave  
f010464b:	c3                   	ret    

f010464c <print_trapframe>:
{
f010464c:	55                   	push   %ebp
f010464d:	89 e5                	mov    %esp,%ebp
f010464f:	56                   	push   %esi
f0104650:	53                   	push   %ebx
f0104651:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104654:	e8 29 25 00 00       	call   f0106b82 <cpunum>
f0104659:	83 ec 04             	sub    $0x4,%esp
f010465c:	50                   	push   %eax
f010465d:	53                   	push   %ebx
f010465e:	68 08 93 10 f0       	push   $0xf0109308
f0104663:	e8 59 f8 ff ff       	call   f0103ec1 <cprintf>
	print_regs(&tf->tf_regs);
f0104668:	89 1c 24             	mov    %ebx,(%esp)
f010466b:	e8 4e ff ff ff       	call   f01045be <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104670:	83 c4 08             	add    $0x8,%esp
f0104673:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104677:	50                   	push   %eax
f0104678:	68 26 93 10 f0       	push   $0xf0109326
f010467d:	e8 3f f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104682:	83 c4 08             	add    $0x8,%esp
f0104685:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104689:	50                   	push   %eax
f010468a:	68 39 93 10 f0       	push   $0xf0109339
f010468f:	e8 2d f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104694:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104697:	83 c4 10             	add    $0x10,%esp
f010469a:	83 f8 13             	cmp    $0x13,%eax
f010469d:	0f 86 e1 00 00 00    	jbe    f0104784 <print_trapframe+0x138>
		return "System call";
f01046a3:	ba b3 92 10 f0       	mov    $0xf01092b3,%edx
	if (trapno == T_SYSCALL)
f01046a8:	83 f8 30             	cmp    $0x30,%eax
f01046ab:	74 13                	je     f01046c0 <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01046ad:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01046b0:	83 fa 0f             	cmp    $0xf,%edx
f01046b3:	ba bf 92 10 f0       	mov    $0xf01092bf,%edx
f01046b8:	b9 ce 92 10 f0       	mov    $0xf01092ce,%ecx
f01046bd:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01046c0:	83 ec 04             	sub    $0x4,%esp
f01046c3:	52                   	push   %edx
f01046c4:	50                   	push   %eax
f01046c5:	68 4c 93 10 f0       	push   $0xf010934c
f01046ca:	e8 f2 f7 ff ff       	call   f0103ec1 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01046cf:	83 c4 10             	add    $0x10,%esp
f01046d2:	39 1d 60 ea 57 f0    	cmp    %ebx,0xf057ea60
f01046d8:	0f 84 b2 00 00 00    	je     f0104790 <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f01046de:	83 ec 08             	sub    $0x8,%esp
f01046e1:	ff 73 2c             	pushl  0x2c(%ebx)
f01046e4:	68 6d 93 10 f0       	push   $0xf010936d
f01046e9:	e8 d3 f7 ff ff       	call   f0103ec1 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f01046ee:	83 c4 10             	add    $0x10,%esp
f01046f1:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01046f5:	0f 85 b8 00 00 00    	jne    f01047b3 <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f01046fb:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f01046fe:	89 c2                	mov    %eax,%edx
f0104700:	83 e2 01             	and    $0x1,%edx
f0104703:	b9 e1 92 10 f0       	mov    $0xf01092e1,%ecx
f0104708:	ba ec 92 10 f0       	mov    $0xf01092ec,%edx
f010470d:	0f 44 ca             	cmove  %edx,%ecx
f0104710:	89 c2                	mov    %eax,%edx
f0104712:	83 e2 02             	and    $0x2,%edx
f0104715:	be f8 92 10 f0       	mov    $0xf01092f8,%esi
f010471a:	ba fe 92 10 f0       	mov    $0xf01092fe,%edx
f010471f:	0f 45 d6             	cmovne %esi,%edx
f0104722:	83 e0 04             	and    $0x4,%eax
f0104725:	b8 03 93 10 f0       	mov    $0xf0109303,%eax
f010472a:	be 50 95 10 f0       	mov    $0xf0109550,%esi
f010472f:	0f 44 c6             	cmove  %esi,%eax
f0104732:	51                   	push   %ecx
f0104733:	52                   	push   %edx
f0104734:	50                   	push   %eax
f0104735:	68 7b 93 10 f0       	push   $0xf010937b
f010473a:	e8 82 f7 ff ff       	call   f0103ec1 <cprintf>
f010473f:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104742:	83 ec 08             	sub    $0x8,%esp
f0104745:	ff 73 30             	pushl  0x30(%ebx)
f0104748:	68 8a 93 10 f0       	push   $0xf010938a
f010474d:	e8 6f f7 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104752:	83 c4 08             	add    $0x8,%esp
f0104755:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104759:	50                   	push   %eax
f010475a:	68 99 93 10 f0       	push   $0xf0109399
f010475f:	e8 5d f7 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104764:	83 c4 08             	add    $0x8,%esp
f0104767:	ff 73 38             	pushl  0x38(%ebx)
f010476a:	68 ac 93 10 f0       	push   $0xf01093ac
f010476f:	e8 4d f7 ff ff       	call   f0103ec1 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104774:	83 c4 10             	add    $0x10,%esp
f0104777:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010477b:	75 4b                	jne    f01047c8 <print_trapframe+0x17c>
}
f010477d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104780:	5b                   	pop    %ebx
f0104781:	5e                   	pop    %esi
f0104782:	5d                   	pop    %ebp
f0104783:	c3                   	ret    
		return excnames[trapno];
f0104784:	8b 14 85 a0 97 10 f0 	mov    -0xfef6860(,%eax,4),%edx
f010478b:	e9 30 ff ff ff       	jmp    f01046c0 <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104790:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104794:	0f 85 44 ff ff ff    	jne    f01046de <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f010479a:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010479d:	83 ec 08             	sub    $0x8,%esp
f01047a0:	50                   	push   %eax
f01047a1:	68 5e 93 10 f0       	push   $0xf010935e
f01047a6:	e8 16 f7 ff ff       	call   f0103ec1 <cprintf>
f01047ab:	83 c4 10             	add    $0x10,%esp
f01047ae:	e9 2b ff ff ff       	jmp    f01046de <print_trapframe+0x92>
		cprintf("\n");
f01047b3:	83 ec 0c             	sub    $0xc,%esp
f01047b6:	68 bb 90 10 f0       	push   $0xf01090bb
f01047bb:	e8 01 f7 ff ff       	call   f0103ec1 <cprintf>
f01047c0:	83 c4 10             	add    $0x10,%esp
f01047c3:	e9 7a ff ff ff       	jmp    f0104742 <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01047c8:	83 ec 08             	sub    $0x8,%esp
f01047cb:	ff 73 3c             	pushl  0x3c(%ebx)
f01047ce:	68 bb 93 10 f0       	push   $0xf01093bb
f01047d3:	e8 e9 f6 ff ff       	call   f0103ec1 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01047d8:	83 c4 08             	add    $0x8,%esp
f01047db:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01047df:	50                   	push   %eax
f01047e0:	68 ca 93 10 f0       	push   $0xf01093ca
f01047e5:	e8 d7 f6 ff ff       	call   f0103ec1 <cprintf>
f01047ea:	83 c4 10             	add    $0x10,%esp
}
f01047ed:	eb 8e                	jmp    f010477d <print_trapframe+0x131>

f01047ef <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f01047ef:	55                   	push   %ebp
f01047f0:	89 e5                	mov    %esp,%ebp
f01047f2:	57                   	push   %edi
f01047f3:	56                   	push   %esi
f01047f4:	53                   	push   %ebx
f01047f5:	83 ec 0c             	sub    $0xc,%esp
f01047f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01047fb:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f01047fe:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104802:	83 e0 03             	and    $0x3,%eax
f0104805:	66 83 f8 03          	cmp    $0x3,%ax
f0104809:	75 5d                	jne    f0104868 <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f010480b:	e8 72 23 00 00       	call   f0106b82 <cpunum>
f0104810:	6b c0 74             	imul   $0x74,%eax,%eax
f0104813:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104819:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010481d:	75 69                	jne    f0104888 <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010481f:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f0104822:	e8 5b 23 00 00       	call   f0106b82 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104827:	57                   	push   %edi
f0104828:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f0104829:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010482c:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104832:	ff 70 48             	pushl  0x48(%eax)
f0104835:	68 9c 96 10 f0       	push   $0xf010969c
f010483a:	e8 82 f6 ff ff       	call   f0103ec1 <cprintf>
	print_trapframe(tf);
f010483f:	89 1c 24             	mov    %ebx,(%esp)
f0104842:	e8 05 fe ff ff       	call   f010464c <print_trapframe>
	env_destroy(curenv);
f0104847:	e8 36 23 00 00       	call   f0106b82 <cpunum>
f010484c:	83 c4 04             	add    $0x4,%esp
f010484f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104852:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104858:	e8 fd f2 ff ff       	call   f0103b5a <env_destroy>
}
f010485d:	83 c4 10             	add    $0x10,%esp
f0104860:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104863:	5b                   	pop    %ebx
f0104864:	5e                   	pop    %esi
f0104865:	5f                   	pop    %edi
f0104866:	5d                   	pop    %ebp
f0104867:	c3                   	ret    
		print_trapframe(tf);//just test
f0104868:	83 ec 0c             	sub    $0xc,%esp
f010486b:	53                   	push   %ebx
f010486c:	e8 db fd ff ff       	call   f010464c <print_trapframe>
		panic("panic at kernel page_fault\n");
f0104871:	83 c4 0c             	add    $0xc,%esp
f0104874:	68 dd 93 10 f0       	push   $0xf01093dd
f0104879:	68 c1 01 00 00       	push   $0x1c1
f010487e:	68 f9 93 10 f0       	push   $0xf01093f9
f0104883:	e8 c1 b7 ff ff       	call   f0100049 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104888:	8b 53 3c             	mov    0x3c(%ebx),%edx
f010488b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f0104890:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));		
f0104892:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104897:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f010489c:	77 05                	ja     f01048a3 <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f010489e:	8d 42 c8             	lea    -0x38(%edx),%eax
f01048a1:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f01048a3:	e8 da 22 00 00       	call   f0106b82 <cpunum>
f01048a8:	6a 02                	push   $0x2
f01048aa:	6a 34                	push   $0x34
f01048ac:	57                   	push   %edi
f01048ad:	6b c0 74             	imul   $0x74,%eax,%eax
f01048b0:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f01048b6:	e8 a1 eb ff ff       	call   f010345c <user_mem_assert>
		utf->utf_fault_va = fault_va;
f01048bb:	89 fa                	mov    %edi,%edx
f01048bd:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f01048bf:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01048c2:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f01048c5:	8d 7f 08             	lea    0x8(%edi),%edi
f01048c8:	b9 08 00 00 00       	mov    $0x8,%ecx
f01048cd:	89 de                	mov    %ebx,%esi
f01048cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f01048d1:	8b 43 30             	mov    0x30(%ebx),%eax
f01048d4:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f01048d7:	8b 43 38             	mov    0x38(%ebx),%eax
f01048da:	89 d7                	mov    %edx,%edi
f01048dc:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f01048df:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01048e2:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f01048e5:	e8 98 22 00 00       	call   f0106b82 <cpunum>
f01048ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01048ed:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01048f3:	8b 58 64             	mov    0x64(%eax),%ebx
f01048f6:	e8 87 22 00 00       	call   f0106b82 <cpunum>
f01048fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01048fe:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104904:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104907:	e8 76 22 00 00       	call   f0106b82 <cpunum>
f010490c:	6b c0 74             	imul   $0x74,%eax,%eax
f010490f:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104915:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104918:	e8 65 22 00 00       	call   f0106b82 <cpunum>
f010491d:	83 c4 04             	add    $0x4,%esp
f0104920:	6b c0 74             	imul   $0x74,%eax,%eax
f0104923:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104929:	e8 cb f2 ff ff       	call   f0103bf9 <env_run>

f010492e <trap>:
{
f010492e:	55                   	push   %ebp
f010492f:	89 e5                	mov    %esp,%ebp
f0104931:	57                   	push   %edi
f0104932:	56                   	push   %esi
f0104933:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104936:	fc                   	cld    
	if (panicstr)
f0104937:	83 3d a0 fe 57 f0 00 	cmpl   $0x0,0xf057fea0
f010493e:	74 01                	je     f0104941 <trap+0x13>
		asm volatile("hlt");
f0104940:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104941:	e8 3c 22 00 00       	call   f0106b82 <cpunum>
f0104946:	6b d0 74             	imul   $0x74,%eax,%edx
f0104949:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010494c:	b8 01 00 00 00       	mov    $0x1,%eax
f0104951:	f0 87 82 20 00 58 f0 	lock xchg %eax,-0xfa7ffe0(%edx)
f0104958:	83 f8 02             	cmp    $0x2,%eax
f010495b:	74 30                	je     f010498d <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010495d:	9c                   	pushf  
f010495e:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f010495f:	f6 c4 02             	test   $0x2,%ah
f0104962:	75 3b                	jne    f010499f <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0104964:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104968:	83 e0 03             	and    $0x3,%eax
f010496b:	66 83 f8 03          	cmp    $0x3,%ax
f010496f:	74 47                	je     f01049b8 <trap+0x8a>
	last_tf = tf;
f0104971:	89 35 60 ea 57 f0    	mov    %esi,0xf057ea60
	switch (tf->tf_trapno)
f0104977:	8b 46 28             	mov    0x28(%esi),%eax
f010497a:	83 e8 03             	sub    $0x3,%eax
f010497d:	83 f8 30             	cmp    $0x30,%eax
f0104980:	0f 87 92 02 00 00    	ja     f0104c18 <trap+0x2ea>
f0104986:	ff 24 85 c0 96 10 f0 	jmp    *-0xfef6940(,%eax,4)
	spin_lock(&kernel_lock);
f010498d:	83 ec 0c             	sub    $0xc,%esp
f0104990:	68 c0 83 12 f0       	push   $0xf01283c0
f0104995:	e8 58 24 00 00       	call   f0106df2 <spin_lock>
f010499a:	83 c4 10             	add    $0x10,%esp
f010499d:	eb be                	jmp    f010495d <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f010499f:	68 05 94 10 f0       	push   $0xf0109405
f01049a4:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01049a9:	68 8c 01 00 00       	push   $0x18c
f01049ae:	68 f9 93 10 f0       	push   $0xf01093f9
f01049b3:	e8 91 b6 ff ff       	call   f0100049 <_panic>
f01049b8:	83 ec 0c             	sub    $0xc,%esp
f01049bb:	68 c0 83 12 f0       	push   $0xf01283c0
f01049c0:	e8 2d 24 00 00       	call   f0106df2 <spin_lock>
		assert(curenv);
f01049c5:	e8 b8 21 00 00       	call   f0106b82 <cpunum>
f01049ca:	6b c0 74             	imul   $0x74,%eax,%eax
f01049cd:	83 c4 10             	add    $0x10,%esp
f01049d0:	83 b8 28 00 58 f0 00 	cmpl   $0x0,-0xfa7ffd8(%eax)
f01049d7:	74 3e                	je     f0104a17 <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f01049d9:	e8 a4 21 00 00       	call   f0106b82 <cpunum>
f01049de:	6b c0 74             	imul   $0x74,%eax,%eax
f01049e1:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01049e7:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01049eb:	74 43                	je     f0104a30 <trap+0x102>
		curenv->env_tf = *tf;
f01049ed:	e8 90 21 00 00       	call   f0106b82 <cpunum>
f01049f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01049f5:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01049fb:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a00:	89 c7                	mov    %eax,%edi
f0104a02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104a04:	e8 79 21 00 00       	call   f0106b82 <cpunum>
f0104a09:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a0c:	8b b0 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%esi
f0104a12:	e9 5a ff ff ff       	jmp    f0104971 <trap+0x43>
		assert(curenv);
f0104a17:	68 1e 94 10 f0       	push   $0xf010941e
f0104a1c:	68 cb 8d 10 f0       	push   $0xf0108dcb
f0104a21:	68 93 01 00 00       	push   $0x193
f0104a26:	68 f9 93 10 f0       	push   $0xf01093f9
f0104a2b:	e8 19 b6 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f0104a30:	e8 4d 21 00 00       	call   f0106b82 <cpunum>
f0104a35:	83 ec 0c             	sub    $0xc,%esp
f0104a38:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a3b:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104a41:	e8 27 ef ff ff       	call   f010396d <env_free>
			curenv = NULL;
f0104a46:	e8 37 21 00 00       	call   f0106b82 <cpunum>
f0104a4b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a4e:	c7 80 28 00 58 f0 00 	movl   $0x0,-0xfa7ffd8(%eax)
f0104a55:	00 00 00 
			sched_yield();
f0104a58:	e8 11 04 00 00       	call   f0104e6e <sched_yield>
			page_fault_handler(tf);
f0104a5d:	83 ec 0c             	sub    $0xc,%esp
f0104a60:	56                   	push   %esi
f0104a61:	e8 89 fd ff ff       	call   f01047ef <page_fault_handler>
f0104a66:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104a69:	e8 14 21 00 00       	call   f0106b82 <cpunum>
f0104a6e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a71:	83 b8 28 00 58 f0 00 	cmpl   $0x0,-0xfa7ffd8(%eax)
f0104a78:	74 18                	je     f0104a92 <trap+0x164>
f0104a7a:	e8 03 21 00 00       	call   f0106b82 <cpunum>
f0104a7f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a82:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104a88:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104a8c:	0f 84 ce 01 00 00    	je     f0104c60 <trap+0x332>
		sched_yield();
f0104a92:	e8 d7 03 00 00       	call   f0104e6e <sched_yield>
			monitor(tf);
f0104a97:	83 ec 0c             	sub    $0xc,%esp
f0104a9a:	56                   	push   %esi
f0104a9b:	e8 b1 c1 ff ff       	call   f0100c51 <monitor>
f0104aa0:	83 c4 10             	add    $0x10,%esp
f0104aa3:	eb c4                	jmp    f0104a69 <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0104aa5:	83 ec 08             	sub    $0x8,%esp
f0104aa8:	ff 76 04             	pushl  0x4(%esi)
f0104aab:	ff 36                	pushl  (%esi)
f0104aad:	ff 76 10             	pushl  0x10(%esi)
f0104ab0:	ff 76 18             	pushl  0x18(%esi)
f0104ab3:	ff 76 14             	pushl  0x14(%esi)
f0104ab6:	ff 76 1c             	pushl  0x1c(%esi)
f0104ab9:	e8 c0 04 00 00       	call   f0104f7e <syscall>
f0104abe:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104ac1:	83 c4 20             	add    $0x20,%esp
f0104ac4:	eb a3                	jmp    f0104a69 <trap+0x13b>
			time_tick();
f0104ac6:	e8 5e 2e 00 00       	call   f0107929 <time_tick>
			lapic_eoi();
f0104acb:	e8 f9 21 00 00       	call   f0106cc9 <lapic_eoi>
			sched_yield();
f0104ad0:	e8 99 03 00 00       	call   f0104e6e <sched_yield>
			kbd_intr();
f0104ad5:	e8 3e bb ff ff       	call   f0100618 <kbd_intr>
f0104ada:	eb 8d                	jmp    f0104a69 <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0104adc:	83 ec 0c             	sub    $0xc,%esp
f0104adf:	68 c0 94 10 f0       	push   $0xf01094c0
f0104ae4:	e8 d8 f3 ff ff       	call   f0103ec1 <cprintf>
f0104ae9:	83 c4 10             	add    $0x10,%esp
f0104aec:	e9 78 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0104af1:	83 ec 0c             	sub    $0xc,%esp
f0104af4:	68 d7 94 10 f0       	push   $0xf01094d7
f0104af9:	e8 c3 f3 ff ff       	call   f0103ec1 <cprintf>
f0104afe:	83 c4 10             	add    $0x10,%esp
f0104b01:	e9 63 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			serial_intr();
f0104b06:	e8 f1 ba ff ff       	call   f01005fc <serial_intr>
f0104b0b:	e9 59 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0104b10:	83 ec 0c             	sub    $0xc,%esp
f0104b13:	68 0a 95 10 f0       	push   $0xf010950a
f0104b18:	e8 a4 f3 ff ff       	call   f0103ec1 <cprintf>
f0104b1d:	83 c4 10             	add    $0x10,%esp
f0104b20:	e9 44 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0104b25:	83 ec 0c             	sub    $0xc,%esp
f0104b28:	68 25 94 10 f0       	push   $0xf0109425
f0104b2d:	e8 8f f3 ff ff       	call   f0103ec1 <cprintf>
f0104b32:	83 c4 10             	add    $0x10,%esp
f0104b35:	e9 2f ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("in Spurious\n");
f0104b3a:	83 ec 0c             	sub    $0xc,%esp
f0104b3d:	68 3b 94 10 f0       	push   $0xf010943b
f0104b42:	e8 7a f3 ff ff       	call   f0103ec1 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104b47:	c7 04 24 48 94 10 f0 	movl   $0xf0109448,(%esp)
f0104b4e:	e8 6e f3 ff ff       	call   f0103ec1 <cprintf>
f0104b53:	83 c4 10             	add    $0x10,%esp
f0104b56:	e9 0e ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104b5b:	83 ec 0c             	sub    $0xc,%esp
f0104b5e:	68 65 94 10 f0       	push   $0xf0109465
f0104b63:	e8 59 f3 ff ff       	call   f0103ec1 <cprintf>
f0104b68:	83 c4 10             	add    $0x10,%esp
f0104b6b:	e9 f9 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104b70:	83 ec 0c             	sub    $0xc,%esp
f0104b73:	68 7b 94 10 f0       	push   $0xf010947b
f0104b78:	e8 44 f3 ff ff       	call   f0103ec1 <cprintf>
f0104b7d:	83 c4 10             	add    $0x10,%esp
f0104b80:	e9 e4 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104b85:	83 ec 0c             	sub    $0xc,%esp
f0104b88:	68 91 94 10 f0       	push   $0xf0109491
f0104b8d:	e8 2f f3 ff ff       	call   f0103ec1 <cprintf>
f0104b92:	83 c4 10             	add    $0x10,%esp
f0104b95:	e9 cf fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104b9a:	83 ec 0c             	sub    $0xc,%esp
f0104b9d:	68 a8 94 10 f0       	push   $0xf01094a8
f0104ba2:	e8 1a f3 ff ff       	call   f0103ec1 <cprintf>
f0104ba7:	83 c4 10             	add    $0x10,%esp
f0104baa:	e9 ba fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104baf:	83 ec 0c             	sub    $0xc,%esp
f0104bb2:	68 bf 94 10 f0       	push   $0xf01094bf
f0104bb7:	e8 05 f3 ff ff       	call   f0103ec1 <cprintf>
f0104bbc:	83 c4 10             	add    $0x10,%esp
f0104bbf:	e9 a5 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104bc4:	83 ec 0c             	sub    $0xc,%esp
f0104bc7:	68 d6 94 10 f0       	push   $0xf01094d6
f0104bcc:	e8 f0 f2 ff ff       	call   f0103ec1 <cprintf>
f0104bd1:	83 c4 10             	add    $0x10,%esp
f0104bd4:	e9 90 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104bd9:	83 ec 0c             	sub    $0xc,%esp
f0104bdc:	68 ed 94 10 f0       	push   $0xf01094ed
f0104be1:	e8 db f2 ff ff       	call   f0103ec1 <cprintf>
f0104be6:	83 c4 10             	add    $0x10,%esp
f0104be9:	e9 7b fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104bee:	83 ec 0c             	sub    $0xc,%esp
f0104bf1:	68 09 95 10 f0       	push   $0xf0109509
f0104bf6:	e8 c6 f2 ff ff       	call   f0103ec1 <cprintf>
f0104bfb:	83 c4 10             	add    $0x10,%esp
f0104bfe:	e9 66 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104c03:	83 ec 0c             	sub    $0xc,%esp
f0104c06:	68 20 95 10 f0       	push   $0xf0109520
f0104c0b:	e8 b1 f2 ff ff       	call   f0103ec1 <cprintf>
f0104c10:	83 c4 10             	add    $0x10,%esp
f0104c13:	e9 51 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			print_trapframe(tf);
f0104c18:	83 ec 0c             	sub    $0xc,%esp
f0104c1b:	56                   	push   %esi
f0104c1c:	e8 2b fa ff ff       	call   f010464c <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104c21:	83 c4 10             	add    $0x10,%esp
f0104c24:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104c29:	74 1e                	je     f0104c49 <trap+0x31b>
				env_destroy(curenv);
f0104c2b:	e8 52 1f 00 00       	call   f0106b82 <cpunum>
f0104c30:	83 ec 0c             	sub    $0xc,%esp
f0104c33:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c36:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104c3c:	e8 19 ef ff ff       	call   f0103b5a <env_destroy>
f0104c41:	83 c4 10             	add    $0x10,%esp
f0104c44:	e9 20 fe ff ff       	jmp    f0104a69 <trap+0x13b>
				panic("unhandled trap in kernel");
f0104c49:	83 ec 04             	sub    $0x4,%esp
f0104c4c:	68 3e 95 10 f0       	push   $0xf010953e
f0104c51:	68 6f 01 00 00       	push   $0x16f
f0104c56:	68 f9 93 10 f0       	push   $0xf01093f9
f0104c5b:	e8 e9 b3 ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f0104c60:	e8 1d 1f 00 00       	call   f0106b82 <cpunum>
f0104c65:	83 ec 0c             	sub    $0xc,%esp
f0104c68:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c6b:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104c71:	e8 83 ef ff ff       	call   f0103bf9 <env_run>

f0104c76 <DIVIDE_HANDLER>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(DIVIDE_HANDLER   , T_DIVIDE )
f0104c76:	6a 00                	push   $0x0
f0104c78:	6a 00                	push   $0x0
f0104c7a:	e9 f9 00 00 00       	jmp    f0104d78 <_alltraps>
f0104c7f:	90                   	nop

f0104c80 <DEBUG_HANDLER>:
	TRAPHANDLER_NOEC(DEBUG_HANDLER    , T_DEBUG  )
f0104c80:	6a 00                	push   $0x0
f0104c82:	6a 01                	push   $0x1
f0104c84:	e9 ef 00 00 00       	jmp    f0104d78 <_alltraps>
f0104c89:	90                   	nop

f0104c8a <NMI_HANDLER>:
	TRAPHANDLER_NOEC(NMI_HANDLER      , T_NMI    )
f0104c8a:	6a 00                	push   $0x0
f0104c8c:	6a 02                	push   $0x2
f0104c8e:	e9 e5 00 00 00       	jmp    f0104d78 <_alltraps>
f0104c93:	90                   	nop

f0104c94 <BRKPT_HANDLER>:
	TRAPHANDLER_NOEC(BRKPT_HANDLER    , T_BRKPT  )
f0104c94:	6a 00                	push   $0x0
f0104c96:	6a 03                	push   $0x3
f0104c98:	e9 db 00 00 00       	jmp    f0104d78 <_alltraps>
f0104c9d:	90                   	nop

f0104c9e <OFLOW_HANDLER>:
	TRAPHANDLER_NOEC(OFLOW_HANDLER    , T_OFLOW  )
f0104c9e:	6a 00                	push   $0x0
f0104ca0:	6a 04                	push   $0x4
f0104ca2:	e9 d1 00 00 00       	jmp    f0104d78 <_alltraps>
f0104ca7:	90                   	nop

f0104ca8 <BOUND_HANDLER>:
	TRAPHANDLER_NOEC(BOUND_HANDLER    , T_BOUND  )
f0104ca8:	6a 00                	push   $0x0
f0104caa:	6a 05                	push   $0x5
f0104cac:	e9 c7 00 00 00       	jmp    f0104d78 <_alltraps>
f0104cb1:	90                   	nop

f0104cb2 <ILLOP_HANDLER>:
	TRAPHANDLER_NOEC(ILLOP_HANDLER    , T_ILLOP  )
f0104cb2:	6a 00                	push   $0x0
f0104cb4:	6a 06                	push   $0x6
f0104cb6:	e9 bd 00 00 00       	jmp    f0104d78 <_alltraps>
f0104cbb:	90                   	nop

f0104cbc <DEVICE_HANDLER>:
	TRAPHANDLER_NOEC(DEVICE_HANDLER   , T_DEVICE )
f0104cbc:	6a 00                	push   $0x0
f0104cbe:	6a 07                	push   $0x7
f0104cc0:	e9 b3 00 00 00       	jmp    f0104d78 <_alltraps>
f0104cc5:	90                   	nop

f0104cc6 <DBLFLT_HANDLER>:
	TRAPHANDLER(	 DBLFLT_HANDLER   , T_DBLFLT )
f0104cc6:	6a 08                	push   $0x8
f0104cc8:	e9 ab 00 00 00       	jmp    f0104d78 <_alltraps>
f0104ccd:	90                   	nop

f0104cce <TSS_HANDLER>:
	TRAPHANDLER(	 TSS_HANDLER      , T_TSS	 )
f0104cce:	6a 0a                	push   $0xa
f0104cd0:	e9 a3 00 00 00       	jmp    f0104d78 <_alltraps>
f0104cd5:	90                   	nop

f0104cd6 <SEGNP_HANDLER>:
	TRAPHANDLER(	 SEGNP_HANDLER    , T_SEGNP  )
f0104cd6:	6a 0b                	push   $0xb
f0104cd8:	e9 9b 00 00 00       	jmp    f0104d78 <_alltraps>
f0104cdd:	90                   	nop

f0104cde <STACK_HANDLER>:
	TRAPHANDLER(	 STACK_HANDLER    , T_STACK  )
f0104cde:	6a 0c                	push   $0xc
f0104ce0:	e9 93 00 00 00       	jmp    f0104d78 <_alltraps>
f0104ce5:	90                   	nop

f0104ce6 <GPFLT_HANDLER>:
	TRAPHANDLER(	 GPFLT_HANDLER    , T_GPFLT  )
f0104ce6:	6a 0d                	push   $0xd
f0104ce8:	e9 8b 00 00 00       	jmp    f0104d78 <_alltraps>
f0104ced:	90                   	nop

f0104cee <PGFLT_HANDLER>:
	TRAPHANDLER(	 PGFLT_HANDLER    , T_PGFLT  )
f0104cee:	6a 0e                	push   $0xe
f0104cf0:	e9 83 00 00 00       	jmp    f0104d78 <_alltraps>
f0104cf5:	90                   	nop

f0104cf6 <FPERR_HANDLER>:
	TRAPHANDLER_NOEC(FPERR_HANDLER 	  , T_FPERR  )
f0104cf6:	6a 00                	push   $0x0
f0104cf8:	6a 10                	push   $0x10
f0104cfa:	eb 7c                	jmp    f0104d78 <_alltraps>

f0104cfc <ALIGN_HANDLER>:
	TRAPHANDLER(	 ALIGN_HANDLER    , T_ALIGN  )
f0104cfc:	6a 11                	push   $0x11
f0104cfe:	eb 78                	jmp    f0104d78 <_alltraps>

f0104d00 <MCHK_HANDLER>:
	TRAPHANDLER_NOEC(MCHK_HANDLER     , T_MCHK   )
f0104d00:	6a 00                	push   $0x0
f0104d02:	6a 12                	push   $0x12
f0104d04:	eb 72                	jmp    f0104d78 <_alltraps>

f0104d06 <SIMDERR_HANDLER>:
	TRAPHANDLER_NOEC(SIMDERR_HANDLER  , T_SIMDERR)
f0104d06:	6a 00                	push   $0x0
f0104d08:	6a 13                	push   $0x13
f0104d0a:	eb 6c                	jmp    f0104d78 <_alltraps>

f0104d0c <SYSCALL_HANDLER>:
	TRAPHANDLER_NOEC(SYSCALL_HANDLER  , T_SYSCALL) /* just test*/
f0104d0c:	6a 00                	push   $0x0
f0104d0e:	6a 30                	push   $0x30
f0104d10:	eb 66                	jmp    f0104d78 <_alltraps>

f0104d12 <TIMER_HANDLER>:

	TRAPHANDLER_NOEC(TIMER_HANDLER	  , IRQ_OFFSET + IRQ_TIMER)
f0104d12:	6a 00                	push   $0x0
f0104d14:	6a 20                	push   $0x20
f0104d16:	eb 60                	jmp    f0104d78 <_alltraps>

f0104d18 <KBD_HANDLER>:
	TRAPHANDLER_NOEC(KBD_HANDLER	  , IRQ_OFFSET + IRQ_KBD)
f0104d18:	6a 00                	push   $0x0
f0104d1a:	6a 21                	push   $0x21
f0104d1c:	eb 5a                	jmp    f0104d78 <_alltraps>

f0104d1e <SECOND_HANDLER>:
	TRAPHANDLER_NOEC(SECOND_HANDLER	  , IRQ_OFFSET + 2)
f0104d1e:	6a 00                	push   $0x0
f0104d20:	6a 22                	push   $0x22
f0104d22:	eb 54                	jmp    f0104d78 <_alltraps>

f0104d24 <THIRD_HANDLER>:
	TRAPHANDLER_NOEC(THIRD_HANDLER	  , IRQ_OFFSET + 3)
f0104d24:	6a 00                	push   $0x0
f0104d26:	6a 23                	push   $0x23
f0104d28:	eb 4e                	jmp    f0104d78 <_alltraps>

f0104d2a <SERIAL_HANDLER>:
	TRAPHANDLER_NOEC(SERIAL_HANDLER	  , IRQ_OFFSET + IRQ_SERIAL)
f0104d2a:	6a 00                	push   $0x0
f0104d2c:	6a 24                	push   $0x24
f0104d2e:	eb 48                	jmp    f0104d78 <_alltraps>

f0104d30 <FIFTH_HANDLER>:
	TRAPHANDLER_NOEC(FIFTH_HANDLER	  , IRQ_OFFSET + 5)
f0104d30:	6a 00                	push   $0x0
f0104d32:	6a 25                	push   $0x25
f0104d34:	eb 42                	jmp    f0104d78 <_alltraps>

f0104d36 <SIXTH_HANDLER>:
	TRAPHANDLER_NOEC(SIXTH_HANDLER	  , IRQ_OFFSET + 6)
f0104d36:	6a 00                	push   $0x0
f0104d38:	6a 26                	push   $0x26
f0104d3a:	eb 3c                	jmp    f0104d78 <_alltraps>

f0104d3c <SPURIOUS_HANDLER>:
	TRAPHANDLER_NOEC(SPURIOUS_HANDLER , IRQ_OFFSET + IRQ_SPURIOUS)
f0104d3c:	6a 00                	push   $0x0
f0104d3e:	6a 27                	push   $0x27
f0104d40:	eb 36                	jmp    f0104d78 <_alltraps>

f0104d42 <EIGHTH_HANDLER>:
	TRAPHANDLER_NOEC(EIGHTH_HANDLER	  , IRQ_OFFSET + 8)
f0104d42:	6a 00                	push   $0x0
f0104d44:	6a 28                	push   $0x28
f0104d46:	eb 30                	jmp    f0104d78 <_alltraps>

f0104d48 <NINTH_HANDLER>:
	TRAPHANDLER_NOEC(NINTH_HANDLER	  , IRQ_OFFSET + 9)
f0104d48:	6a 00                	push   $0x0
f0104d4a:	6a 29                	push   $0x29
f0104d4c:	eb 2a                	jmp    f0104d78 <_alltraps>

f0104d4e <TENTH_HANDLER>:
	TRAPHANDLER_NOEC(TENTH_HANDLER	  , IRQ_OFFSET + 10)
f0104d4e:	6a 00                	push   $0x0
f0104d50:	6a 2a                	push   $0x2a
f0104d52:	eb 24                	jmp    f0104d78 <_alltraps>

f0104d54 <ELEVEN_HANDLER>:
	TRAPHANDLER_NOEC(ELEVEN_HANDLER	  , IRQ_OFFSET + 11)
f0104d54:	6a 00                	push   $0x0
f0104d56:	6a 2b                	push   $0x2b
f0104d58:	eb 1e                	jmp    f0104d78 <_alltraps>

f0104d5a <TWELVE_HANDLER>:
	TRAPHANDLER_NOEC(TWELVE_HANDLER	  , IRQ_OFFSET + 12)
f0104d5a:	6a 00                	push   $0x0
f0104d5c:	6a 2c                	push   $0x2c
f0104d5e:	eb 18                	jmp    f0104d78 <_alltraps>

f0104d60 <THIRTEEN_HANDLER>:
	TRAPHANDLER_NOEC(THIRTEEN_HANDLER , IRQ_OFFSET + 13)
f0104d60:	6a 00                	push   $0x0
f0104d62:	6a 2d                	push   $0x2d
f0104d64:	eb 12                	jmp    f0104d78 <_alltraps>

f0104d66 <IDE_HANDLER>:
	TRAPHANDLER_NOEC(IDE_HANDLER	  , IRQ_OFFSET + IRQ_IDE)
f0104d66:	6a 00                	push   $0x0
f0104d68:	6a 2e                	push   $0x2e
f0104d6a:	eb 0c                	jmp    f0104d78 <_alltraps>

f0104d6c <FIFTEEN_HANDLER>:
	TRAPHANDLER_NOEC(FIFTEEN_HANDLER  , IRQ_OFFSET + 15)
f0104d6c:	6a 00                	push   $0x0
f0104d6e:	6a 2f                	push   $0x2f
f0104d70:	eb 06                	jmp    f0104d78 <_alltraps>

f0104d72 <ERROR_HANDLER>:
	TRAPHANDLER_NOEC(ERROR_HANDLER	  , IRQ_OFFSET + IRQ_ERROR)
f0104d72:	6a 00                	push   $0x0
f0104d74:	6a 33                	push   $0x33
f0104d76:	eb 00                	jmp    f0104d78 <_alltraps>

f0104d78 <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */

.globl _alltraps
_alltraps:
	pushw $0
f0104d78:	66 6a 00             	pushw  $0x0
	pushw %ds 
f0104d7b:	66 1e                	pushw  %ds
	pushw $0
f0104d7d:	66 6a 00             	pushw  $0x0
	pushw %es 
f0104d80:	66 06                	pushw  %es
	pushal
f0104d82:	60                   	pusha  

	movl $(GD_KD), %eax 
f0104d83:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds 
f0104d88:	8e d8                	mov    %eax,%ds
	movw %ax, %es 
f0104d8a:	8e c0                	mov    %eax,%es

	pushl %esp 
f0104d8c:	54                   	push   %esp
	call trap
f0104d8d:	e8 9c fb ff ff       	call   f010492e <trap>

f0104d92 <sysenter_handler>:

; .global sysenter_handler
; sysenter_handler:
; 	pushl %esi 
f0104d92:	56                   	push   %esi
; 	pushl %edi
f0104d93:	57                   	push   %edi
; 	pushl %ebx
f0104d94:	53                   	push   %ebx
; 	pushl %ecx 
f0104d95:	51                   	push   %ecx
; 	pushl %edx
f0104d96:	52                   	push   %edx
; 	pushl %eax
f0104d97:	50                   	push   %eax
; 	call syscall
f0104d98:	e8 e1 01 00 00       	call   f0104f7e <syscall>
; 	movl %esi, %edx
f0104d9d:	89 f2                	mov    %esi,%edx
; 	movl %ebp, %ecx 
f0104d9f:	89 e9                	mov    %ebp,%ecx
f0104da1:	0f 35                	sysexit 

f0104da3 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104da3:	55                   	push   %ebp
f0104da4:	89 e5                	mov    %esp,%ebp
f0104da6:	83 ec 08             	sub    $0x8,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104da9:	8b 0d 44 e2 57 f0    	mov    0xf057e244,%ecx
	for (i = 0; i < NENV; i++) {
f0104daf:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104db4:	89 c2                	mov    %eax,%edx
f0104db6:	c1 e2 07             	shl    $0x7,%edx
		     envs[i].env_status == ENV_RUNNING ||
f0104db9:	8b 54 11 54          	mov    0x54(%ecx,%edx,1),%edx
f0104dbd:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104dc0:	83 fa 02             	cmp    $0x2,%edx
f0104dc3:	76 29                	jbe    f0104dee <sched_halt+0x4b>
	for (i = 0; i < NENV; i++) {
f0104dc5:	83 c0 01             	add    $0x1,%eax
f0104dc8:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104dcd:	75 e5                	jne    f0104db4 <sched_halt+0x11>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104dcf:	83 ec 0c             	sub    $0xc,%esp
f0104dd2:	68 f0 97 10 f0       	push   $0xf01097f0
f0104dd7:	e8 e5 f0 ff ff       	call   f0103ec1 <cprintf>
f0104ddc:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104ddf:	83 ec 0c             	sub    $0xc,%esp
f0104de2:	6a 00                	push   $0x0
f0104de4:	e8 68 be ff ff       	call   f0100c51 <monitor>
f0104de9:	83 c4 10             	add    $0x10,%esp
f0104dec:	eb f1                	jmp    f0104ddf <sched_halt+0x3c>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104dee:	e8 8f 1d 00 00       	call   f0106b82 <cpunum>
f0104df3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104df6:	c7 80 28 00 58 f0 00 	movl   $0x0,-0xfa7ffd8(%eax)
f0104dfd:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104e00:	a1 ac fe 57 f0       	mov    0xf057feac,%eax
	if ((uint32_t)kva < KERNBASE)
f0104e05:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104e0a:	76 50                	jbe    f0104e5c <sched_halt+0xb9>
	return (physaddr_t)kva - KERNBASE;
f0104e0c:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104e11:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104e14:	e8 69 1d 00 00       	call   f0106b82 <cpunum>
f0104e19:	6b d0 74             	imul   $0x74,%eax,%edx
f0104e1c:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104e1f:	b8 02 00 00 00       	mov    $0x2,%eax
f0104e24:	f0 87 82 20 00 58 f0 	lock xchg %eax,-0xfa7ffe0(%edx)
	spin_unlock(&kernel_lock);
f0104e2b:	83 ec 0c             	sub    $0xc,%esp
f0104e2e:	68 c0 83 12 f0       	push   $0xf01283c0
f0104e33:	e8 56 20 00 00       	call   f0106e8e <spin_unlock>
	asm volatile("pause");
f0104e38:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104e3a:	e8 43 1d 00 00       	call   f0106b82 <cpunum>
f0104e3f:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104e42:	8b 80 30 00 58 f0    	mov    -0xfa7ffd0(%eax),%eax
f0104e48:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104e4d:	89 c4                	mov    %eax,%esp
f0104e4f:	6a 00                	push   $0x0
f0104e51:	6a 00                	push   $0x0
f0104e53:	fb                   	sti    
f0104e54:	f4                   	hlt    
f0104e55:	eb fd                	jmp    f0104e54 <sched_halt+0xb1>
}
f0104e57:	83 c4 10             	add    $0x10,%esp
f0104e5a:	c9                   	leave  
f0104e5b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104e5c:	50                   	push   %eax
f0104e5d:	68 38 7c 10 f0       	push   $0xf0107c38
f0104e62:	6a 4c                	push   $0x4c
f0104e64:	68 19 98 10 f0       	push   $0xf0109819
f0104e69:	e8 db b1 ff ff       	call   f0100049 <_panic>

f0104e6e <sched_yield>:
{
f0104e6e:	55                   	push   %ebp
f0104e6f:	89 e5                	mov    %esp,%ebp
f0104e71:	53                   	push   %ebx
f0104e72:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f0104e75:	e8 08 1d 00 00       	call   f0106b82 <cpunum>
f0104e7a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e7d:	83 b8 28 00 58 f0 00 	cmpl   $0x0,-0xfa7ffd8(%eax)
f0104e84:	74 7d                	je     f0104f03 <sched_yield+0x95>
		envid_t cur_tone = ENVX(curenv->env_id);
f0104e86:	e8 f7 1c 00 00       	call   f0106b82 <cpunum>
f0104e8b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e8e:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104e94:	8b 48 48             	mov    0x48(%eax),%ecx
f0104e97:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e9d:	8d 41 01             	lea    0x1(%ecx),%eax
f0104ea0:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104ea5:	8b 1d 44 e2 57 f0    	mov    0xf057e244,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104eab:	39 c8                	cmp    %ecx,%eax
f0104ead:	74 20                	je     f0104ecf <sched_yield+0x61>
			if(envs[i].env_status == ENV_RUNNABLE){
f0104eaf:	89 c2                	mov    %eax,%edx
f0104eb1:	c1 e2 07             	shl    $0x7,%edx
f0104eb4:	01 da                	add    %ebx,%edx
f0104eb6:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0104eba:	74 0a                	je     f0104ec6 <sched_yield+0x58>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104ebc:	83 c0 01             	add    $0x1,%eax
f0104ebf:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104ec4:	eb e5                	jmp    f0104eab <sched_yield+0x3d>
				env_run(&envs[i]);
f0104ec6:	83 ec 0c             	sub    $0xc,%esp
f0104ec9:	52                   	push   %edx
f0104eca:	e8 2a ed ff ff       	call   f0103bf9 <env_run>
		if(curenv->env_status == ENV_RUNNING)
f0104ecf:	e8 ae 1c 00 00       	call   f0106b82 <cpunum>
f0104ed4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ed7:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104edd:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104ee1:	74 0a                	je     f0104eed <sched_yield+0x7f>
	sched_halt();
f0104ee3:	e8 bb fe ff ff       	call   f0104da3 <sched_halt>
}
f0104ee8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104eeb:	c9                   	leave  
f0104eec:	c3                   	ret    
			env_run(curenv);
f0104eed:	e8 90 1c 00 00       	call   f0106b82 <cpunum>
f0104ef2:	83 ec 0c             	sub    $0xc,%esp
f0104ef5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ef8:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104efe:	e8 f6 ec ff ff       	call   f0103bf9 <env_run>
f0104f03:	a1 44 e2 57 f0       	mov    0xf057e244,%eax
f0104f08:	8d 90 00 00 02 00    	lea    0x20000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f0104f0e:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104f12:	74 09                	je     f0104f1d <sched_yield+0xaf>
f0104f14:	83 e8 80             	sub    $0xffffff80,%eax
		for(i = 0 ; i < NENV; i++)
f0104f17:	39 d0                	cmp    %edx,%eax
f0104f19:	75 f3                	jne    f0104f0e <sched_yield+0xa0>
f0104f1b:	eb c6                	jmp    f0104ee3 <sched_yield+0x75>
		  		env_run(&envs[i]);
f0104f1d:	83 ec 0c             	sub    $0xc,%esp
f0104f20:	50                   	push   %eax
f0104f21:	e8 d3 ec ff ff       	call   f0103bf9 <env_run>

f0104f26 <sys_net_send>:
	return time_msec();
}

int
sys_net_send(const void *buf, uint32_t len)
{
f0104f26:	55                   	push   %ebp
f0104f27:	89 e5                	mov    %esp,%ebp
f0104f29:	56                   	push   %esi
f0104f2a:	53                   	push   %ebx
f0104f2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104f2e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_tx to send the packet
	// Hint: e1000_tx only accept kernel virtual address
	cprintf("in %s\n", __FUNCTION__);
f0104f31:	83 ec 08             	sub    $0x8,%esp
f0104f34:	68 3c 99 10 f0       	push   $0xf010993c
f0104f39:	68 a6 91 10 f0       	push   $0xf01091a6
f0104f3e:	e8 7e ef ff ff       	call   f0103ec1 <cprintf>
	int r = 0;
	// int cur_len = len;
	// char *cur_buf = (char *)buf;
	user_mem_assert(curenv, buf, len, PTE_U);
f0104f43:	e8 3a 1c 00 00       	call   f0106b82 <cpunum>
f0104f48:	6a 04                	push   $0x4
f0104f4a:	56                   	push   %esi
f0104f4b:	53                   	push   %ebx
f0104f4c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f4f:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104f55:	e8 02 e5 ff ff       	call   f010345c <user_mem_assert>
	// 		return r;
	// 	cur_len -= copy_len;
	// 	cur_buf += copy_len;
	// 	memset(page2kva(page), 0, copy_len);
	// }
	r = e1000_tx(buf, len);	
f0104f5a:	83 c4 18             	add    $0x18,%esp
f0104f5d:	56                   	push   %esi
f0104f5e:	53                   	push   %ebx
f0104f5f:	e8 64 23 00 00       	call   f01072c8 <e1000_tx>
f0104f64:	83 c4 10             	add    $0x10,%esp
f0104f67:	85 c0                	test   %eax,%eax
f0104f69:	ba 00 00 00 00       	mov    $0x0,%edx
f0104f6e:	0f 4f c2             	cmovg  %edx,%eax
	if(r < 0)
		return r;
	return 0;
}
f0104f71:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104f74:	5b                   	pop    %ebx
f0104f75:	5e                   	pop    %esi
f0104f76:	5d                   	pop    %ebp
f0104f77:	c3                   	ret    

f0104f78 <sys_net_recv>:
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	return -1;
}
f0104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f7d:	c3                   	ret    

f0104f7e <syscall>:
	return 0;
}
// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104f7e:	55                   	push   %ebp
f0104f7f:	89 e5                	mov    %esp,%ebp
f0104f81:	57                   	push   %edi
f0104f82:	56                   	push   %esi
f0104f83:	53                   	push   %ebx
f0104f84:	83 ec 1c             	sub    $0x1c,%esp
f0104f87:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f0104f8a:	83 f8 14             	cmp    $0x14,%eax
f0104f8d:	0f 87 7c 08 00 00    	ja     f010580f <syscall+0x891>
f0104f93:	ff 24 85 e8 98 10 f0 	jmp    *-0xfef6718(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f0104f9a:	e8 e3 1b 00 00       	call   f0106b82 <cpunum>
f0104f9f:	6a 04                	push   $0x4
f0104fa1:	ff 75 10             	pushl  0x10(%ebp)
f0104fa4:	ff 75 0c             	pushl  0xc(%ebp)
f0104fa7:	6b c0 74             	imul   $0x74,%eax,%eax
f0104faa:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0104fb0:	e8 a7 e4 ff ff       	call   f010345c <user_mem_assert>
	cprintf("%.*s", len, s);
f0104fb5:	83 c4 0c             	add    $0xc,%esp
f0104fb8:	ff 75 0c             	pushl  0xc(%ebp)
f0104fbb:	ff 75 10             	pushl  0x10(%ebp)
f0104fbe:	68 26 98 10 f0       	push   $0xf0109826
f0104fc3:	e8 f9 ee ff ff       	call   f0103ec1 <cprintf>
f0104fc8:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f0104fcb:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f0104fd0:	89 d8                	mov    %ebx,%eax
f0104fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104fd5:	5b                   	pop    %ebx
f0104fd6:	5e                   	pop    %esi
f0104fd7:	5f                   	pop    %edi
f0104fd8:	5d                   	pop    %ebp
f0104fd9:	c3                   	ret    
	return cons_getc();
f0104fda:	e8 4b b6 ff ff       	call   f010062a <cons_getc>
f0104fdf:	89 c3                	mov    %eax,%ebx
			break;
f0104fe1:	eb ed                	jmp    f0104fd0 <syscall+0x52>
	return curenv->env_id;
f0104fe3:	e8 9a 1b 00 00       	call   f0106b82 <cpunum>
f0104fe8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104feb:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0104ff1:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0104ff4:	eb da                	jmp    f0104fd0 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104ff6:	83 ec 04             	sub    $0x4,%esp
f0104ff9:	6a 01                	push   $0x1
f0104ffb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104ffe:	50                   	push   %eax
f0104fff:	ff 75 0c             	pushl  0xc(%ebp)
f0105002:	e8 27 e5 ff ff       	call   f010352e <envid2env>
f0105007:	89 c3                	mov    %eax,%ebx
f0105009:	83 c4 10             	add    $0x10,%esp
f010500c:	85 c0                	test   %eax,%eax
f010500e:	78 c0                	js     f0104fd0 <syscall+0x52>
	if (e == curenv)
f0105010:	e8 6d 1b 00 00       	call   f0106b82 <cpunum>
f0105015:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105018:	6b c0 74             	imul   $0x74,%eax,%eax
f010501b:	39 90 28 00 58 f0    	cmp    %edx,-0xfa7ffd8(%eax)
f0105021:	74 3d                	je     f0105060 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0105023:	8b 5a 48             	mov    0x48(%edx),%ebx
f0105026:	e8 57 1b 00 00       	call   f0106b82 <cpunum>
f010502b:	83 ec 04             	sub    $0x4,%esp
f010502e:	53                   	push   %ebx
f010502f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105032:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105038:	ff 70 48             	pushl  0x48(%eax)
f010503b:	68 46 98 10 f0       	push   $0xf0109846
f0105040:	e8 7c ee ff ff       	call   f0103ec1 <cprintf>
f0105045:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0105048:	83 ec 0c             	sub    $0xc,%esp
f010504b:	ff 75 e4             	pushl  -0x1c(%ebp)
f010504e:	e8 07 eb ff ff       	call   f0103b5a <env_destroy>
f0105053:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105056:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f010505b:	e9 70 ff ff ff       	jmp    f0104fd0 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0105060:	e8 1d 1b 00 00       	call   f0106b82 <cpunum>
f0105065:	83 ec 08             	sub    $0x8,%esp
f0105068:	6b c0 74             	imul   $0x74,%eax,%eax
f010506b:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105071:	ff 70 48             	pushl  0x48(%eax)
f0105074:	68 2b 98 10 f0       	push   $0xf010982b
f0105079:	e8 43 ee ff ff       	call   f0103ec1 <cprintf>
f010507e:	83 c4 10             	add    $0x10,%esp
f0105081:	eb c5                	jmp    f0105048 <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f0105083:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f010508a:	76 4a                	jbe    f01050d6 <syscall+0x158>
	return (physaddr_t)kva - KERNBASE;
f010508c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010508f:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0105094:	c1 e8 0c             	shr    $0xc,%eax
f0105097:	3b 05 a8 fe 57 f0    	cmp    0xf057fea8,%eax
f010509d:	73 4e                	jae    f01050ed <syscall+0x16f>
	return &pages[PGNUM(pa)];
f010509f:	8b 15 b0 fe 57 f0    	mov    0xf057feb0,%edx
f01050a5:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f01050a8:	85 db                	test   %ebx,%ebx
f01050aa:	0f 84 69 07 00 00    	je     f0105819 <syscall+0x89b>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f01050b0:	e8 cd 1a 00 00       	call   f0106b82 <cpunum>
f01050b5:	6a 06                	push   $0x6
f01050b7:	ff 75 10             	pushl  0x10(%ebp)
f01050ba:	53                   	push   %ebx
f01050bb:	6b c0 74             	imul   $0x74,%eax,%eax
f01050be:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01050c4:	ff 70 60             	pushl  0x60(%eax)
f01050c7:	e8 34 c5 ff ff       	call   f0101600 <page_insert>
f01050cc:	89 c3                	mov    %eax,%ebx
f01050ce:	83 c4 10             	add    $0x10,%esp
f01050d1:	e9 fa fe ff ff       	jmp    f0104fd0 <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01050d6:	ff 75 0c             	pushl  0xc(%ebp)
f01050d9:	68 38 7c 10 f0       	push   $0xf0107c38
f01050de:	68 af 01 00 00       	push   $0x1af
f01050e3:	68 5e 98 10 f0       	push   $0xf010985e
f01050e8:	e8 5c af ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f01050ed:	83 ec 04             	sub    $0x4,%esp
f01050f0:	68 f0 84 10 f0       	push   $0xf01084f0
f01050f5:	6a 51                	push   $0x51
f01050f7:	68 b1 8d 10 f0       	push   $0xf0108db1
f01050fc:	e8 48 af ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105101:	e8 7c 1a 00 00       	call   f0106b82 <cpunum>
	if(inc < PGSIZE){
f0105106:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f010510d:	77 1b                	ja     f010512a <syscall+0x1ac>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f010510f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105112:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105118:	8b 40 7c             	mov    0x7c(%eax),%eax
f010511b:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f0105120:	03 45 0c             	add    0xc(%ebp),%eax
f0105123:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0105128:	76 7c                	jbe    f01051a6 <syscall+0x228>
	int i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f010512a:	e8 53 1a 00 00       	call   f0106b82 <cpunum>
f010512f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105132:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105138:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010513b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f0105141:	e8 3c 1a 00 00       	call   f0106b82 <cpunum>
f0105146:	6b c0 74             	imul   $0x74,%eax,%eax
f0105149:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f010514f:	8b 40 7c             	mov    0x7c(%eax),%eax
f0105152:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105155:	8d b4 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%esi
f010515c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f0105162:	39 de                	cmp    %ebx,%esi
f0105164:	0f 8e 94 00 00 00    	jle    f01051fe <syscall+0x280>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f010516a:	83 ec 0c             	sub    $0xc,%esp
f010516d:	6a 01                	push   $0x1
f010516f:	e8 50 c1 ff ff       	call   f01012c4 <page_alloc>
f0105174:	89 c7                	mov    %eax,%edi
		if(!page)
f0105176:	83 c4 10             	add    $0x10,%esp
f0105179:	85 c0                	test   %eax,%eax
f010517b:	74 53                	je     f01051d0 <syscall+0x252>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f010517d:	e8 00 1a 00 00       	call   f0106b82 <cpunum>
f0105182:	6a 06                	push   $0x6
f0105184:	53                   	push   %ebx
f0105185:	57                   	push   %edi
f0105186:	6b c0 74             	imul   $0x74,%eax,%eax
f0105189:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f010518f:	ff 70 60             	pushl  0x60(%eax)
f0105192:	e8 69 c4 ff ff       	call   f0101600 <page_insert>
		if(ret)
f0105197:	83 c4 10             	add    $0x10,%esp
f010519a:	85 c0                	test   %eax,%eax
f010519c:	75 49                	jne    f01051e7 <syscall+0x269>
	for(; i < end; i+=PGSIZE){
f010519e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01051a4:	eb bc                	jmp    f0105162 <syscall+0x1e4>
			curenv->env_sbrk+=inc;
f01051a6:	e8 d7 19 00 00       	call   f0106b82 <cpunum>
f01051ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01051ae:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01051b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01051b7:	01 48 7c             	add    %ecx,0x7c(%eax)
			return curenv->env_sbrk;
f01051ba:	e8 c3 19 00 00       	call   f0106b82 <cpunum>
f01051bf:	6b c0 74             	imul   $0x74,%eax,%eax
f01051c2:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01051c8:	8b 58 7c             	mov    0x7c(%eax),%ebx
f01051cb:	e9 00 fe ff ff       	jmp    f0104fd0 <syscall+0x52>
			panic("there is no page\n");
f01051d0:	83 ec 04             	sub    $0x4,%esp
f01051d3:	68 14 91 10 f0       	push   $0xf0109114
f01051d8:	68 c4 01 00 00       	push   $0x1c4
f01051dd:	68 5e 98 10 f0       	push   $0xf010985e
f01051e2:	e8 62 ae ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f01051e7:	83 ec 04             	sub    $0x4,%esp
f01051ea:	68 31 91 10 f0       	push   $0xf0109131
f01051ef:	68 c7 01 00 00       	push   $0x1c7
f01051f4:	68 5e 98 10 f0       	push   $0xf010985e
f01051f9:	e8 4b ae ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f01051fe:	e8 7f 19 00 00       	call   f0106b82 <cpunum>
f0105203:	6b c0 74             	imul   $0x74,%eax,%eax
f0105206:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f010520c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010520f:	01 48 7c             	add    %ecx,0x7c(%eax)
	return curenv->env_sbrk;
f0105212:	e8 6b 19 00 00       	call   f0106b82 <cpunum>
f0105217:	6b c0 74             	imul   $0x74,%eax,%eax
f010521a:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105220:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0105223:	e9 a8 fd ff ff       	jmp    f0104fd0 <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f0105228:	83 ec 04             	sub    $0x4,%esp
f010522b:	68 84 98 10 f0       	push   $0xf0109884
f0105230:	68 31 02 00 00       	push   $0x231
f0105235:	68 5e 98 10 f0       	push   $0xf010985e
f010523a:	e8 0a ae ff ff       	call   f0100049 <_panic>
	sched_yield();
f010523f:	e8 2a fc ff ff       	call   f0104e6e <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105244:	e8 39 19 00 00       	call   f0106b82 <cpunum>
f0105249:	83 ec 08             	sub    $0x8,%esp
f010524c:	6b c0 74             	imul   $0x74,%eax,%eax
f010524f:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105255:	ff 70 48             	pushl  0x48(%eax)
f0105258:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010525b:	50                   	push   %eax
f010525c:	e8 10 e4 ff ff       	call   f0103671 <env_alloc>
f0105261:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105263:	83 c4 10             	add    $0x10,%esp
f0105266:	85 c0                	test   %eax,%eax
f0105268:	0f 88 62 fd ff ff    	js     f0104fd0 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f010526e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105271:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f0105278:	e8 05 19 00 00       	call   f0106b82 <cpunum>
f010527d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105280:	8b b0 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%esi
f0105286:	b9 11 00 00 00       	mov    $0x11,%ecx
f010528b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010528e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f0105290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105293:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f010529a:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f010529d:	e9 2e fd ff ff       	jmp    f0104fd0 <syscall+0x52>
	switch (status)
f01052a2:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01052a6:	74 06                	je     f01052ae <syscall+0x330>
f01052a8:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f01052ac:	75 54                	jne    f0105302 <syscall+0x384>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01052ae:	8b 45 10             	mov    0x10(%ebp),%eax
f01052b1:	83 e8 02             	sub    $0x2,%eax
f01052b4:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01052b9:	75 31                	jne    f01052ec <syscall+0x36e>
	int ret = envid2env(envid, &e, 1);
f01052bb:	83 ec 04             	sub    $0x4,%esp
f01052be:	6a 01                	push   $0x1
f01052c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01052c3:	50                   	push   %eax
f01052c4:	ff 75 0c             	pushl  0xc(%ebp)
f01052c7:	e8 62 e2 ff ff       	call   f010352e <envid2env>
f01052cc:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01052ce:	83 c4 10             	add    $0x10,%esp
f01052d1:	85 c0                	test   %eax,%eax
f01052d3:	0f 88 f7 fc ff ff    	js     f0104fd0 <syscall+0x52>
	e->env_status = status;
f01052d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01052df:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f01052e2:	bb 00 00 00 00       	mov    $0x0,%ebx
f01052e7:	e9 e4 fc ff ff       	jmp    f0104fd0 <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01052ec:	68 b0 98 10 f0       	push   $0xf01098b0
f01052f1:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01052f6:	6a 7b                	push   $0x7b
f01052f8:	68 5e 98 10 f0       	push   $0xf010985e
f01052fd:	e8 47 ad ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f0105302:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105307:	e9 c4 fc ff ff       	jmp    f0104fd0 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f010530c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105313:	0f 87 cd 00 00 00    	ja     f01053e6 <syscall+0x468>
f0105319:	8b 45 10             	mov    0x10(%ebp),%eax
f010531c:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105321:	8b 55 14             	mov    0x14(%ebp),%edx
f0105324:	83 e2 05             	and    $0x5,%edx
f0105327:	83 fa 05             	cmp    $0x5,%edx
f010532a:	0f 85 c0 00 00 00    	jne    f01053f0 <syscall+0x472>
	if(perm & ~PTE_SYSCALL)
f0105330:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105333:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0105339:	09 c3                	or     %eax,%ebx
f010533b:	0f 85 b9 00 00 00    	jne    f01053fa <syscall+0x47c>
	int ret = envid2env(envid, &e, 1);
f0105341:	83 ec 04             	sub    $0x4,%esp
f0105344:	6a 01                	push   $0x1
f0105346:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105349:	50                   	push   %eax
f010534a:	ff 75 0c             	pushl  0xc(%ebp)
f010534d:	e8 dc e1 ff ff       	call   f010352e <envid2env>
	if(ret < 0)
f0105352:	83 c4 10             	add    $0x10,%esp
f0105355:	85 c0                	test   %eax,%eax
f0105357:	0f 88 a7 00 00 00    	js     f0105404 <syscall+0x486>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f010535d:	83 ec 0c             	sub    $0xc,%esp
f0105360:	6a 01                	push   $0x1
f0105362:	e8 5d bf ff ff       	call   f01012c4 <page_alloc>
f0105367:	89 c6                	mov    %eax,%esi
	if(page == NULL)
f0105369:	83 c4 10             	add    $0x10,%esp
f010536c:	85 c0                	test   %eax,%eax
f010536e:	0f 84 97 00 00 00    	je     f010540b <syscall+0x48d>
	return (pp - pages) << PGSHIFT;
f0105374:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f010537a:	c1 f8 03             	sar    $0x3,%eax
f010537d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0105380:	89 c2                	mov    %eax,%edx
f0105382:	c1 ea 0c             	shr    $0xc,%edx
f0105385:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f010538b:	73 47                	jae    f01053d4 <syscall+0x456>
	memset(page2kva(page), 0, PGSIZE);
f010538d:	83 ec 04             	sub    $0x4,%esp
f0105390:	68 00 10 00 00       	push   $0x1000
f0105395:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0105397:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010539c:	50                   	push   %eax
f010539d:	e8 d8 11 00 00       	call   f010657a <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f01053a2:	ff 75 14             	pushl  0x14(%ebp)
f01053a5:	ff 75 10             	pushl  0x10(%ebp)
f01053a8:	56                   	push   %esi
f01053a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01053ac:	ff 70 60             	pushl  0x60(%eax)
f01053af:	e8 4c c2 ff ff       	call   f0101600 <page_insert>
f01053b4:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f01053b6:	83 c4 20             	add    $0x20,%esp
f01053b9:	85 c0                	test   %eax,%eax
f01053bb:	0f 89 0f fc ff ff    	jns    f0104fd0 <syscall+0x52>
		page_free(page);
f01053c1:	83 ec 0c             	sub    $0xc,%esp
f01053c4:	56                   	push   %esi
f01053c5:	e8 6c bf ff ff       	call   f0101336 <page_free>
f01053ca:	83 c4 10             	add    $0x10,%esp
		return ret;
f01053cd:	89 fb                	mov    %edi,%ebx
f01053cf:	e9 fc fb ff ff       	jmp    f0104fd0 <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01053d4:	50                   	push   %eax
f01053d5:	68 14 7c 10 f0       	push   $0xf0107c14
f01053da:	6a 58                	push   $0x58
f01053dc:	68 b1 8d 10 f0       	push   $0xf0108db1
f01053e1:	e8 63 ac ff ff       	call   f0100049 <_panic>
		return -E_INVAL;
f01053e6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01053eb:	e9 e0 fb ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f01053f0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01053f5:	e9 d6 fb ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f01053fa:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01053ff:	e9 cc fb ff ff       	jmp    f0104fd0 <syscall+0x52>
		return ret;
f0105404:	89 c3                	mov    %eax,%ebx
f0105406:	e9 c5 fb ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_NO_MEM;
f010540b:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105410:	e9 bb fb ff ff       	jmp    f0104fd0 <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105415:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105418:	83 e0 05             	and    $0x5,%eax
f010541b:	83 f8 05             	cmp    $0x5,%eax
f010541e:	0f 85 c0 00 00 00    	jne    f01054e4 <syscall+0x566>
	if(perm & ~PTE_SYSCALL)
f0105424:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105427:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f010542c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105433:	0f 87 b5 00 00 00    	ja     f01054ee <syscall+0x570>
f0105439:	8b 55 10             	mov    0x10(%ebp),%edx
f010543c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f0105442:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105449:	0f 87 a9 00 00 00    	ja     f01054f8 <syscall+0x57a>
f010544f:	09 d0                	or     %edx,%eax
f0105451:	8b 55 18             	mov    0x18(%ebp),%edx
f0105454:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f010545a:	09 d0                	or     %edx,%eax
f010545c:	0f 85 a0 00 00 00    	jne    f0105502 <syscall+0x584>
	int ret = envid2env(srcenvid, &src_env, 1);
f0105462:	83 ec 04             	sub    $0x4,%esp
f0105465:	6a 01                	push   $0x1
f0105467:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010546a:	50                   	push   %eax
f010546b:	ff 75 0c             	pushl  0xc(%ebp)
f010546e:	e8 bb e0 ff ff       	call   f010352e <envid2env>
f0105473:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105475:	83 c4 10             	add    $0x10,%esp
f0105478:	85 c0                	test   %eax,%eax
f010547a:	0f 88 50 fb ff ff    	js     f0104fd0 <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f0105480:	83 ec 04             	sub    $0x4,%esp
f0105483:	6a 01                	push   $0x1
f0105485:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105488:	50                   	push   %eax
f0105489:	ff 75 14             	pushl  0x14(%ebp)
f010548c:	e8 9d e0 ff ff       	call   f010352e <envid2env>
f0105491:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105493:	83 c4 10             	add    $0x10,%esp
f0105496:	85 c0                	test   %eax,%eax
f0105498:	0f 88 32 fb ff ff    	js     f0104fd0 <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f010549e:	83 ec 04             	sub    $0x4,%esp
f01054a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01054a4:	50                   	push   %eax
f01054a5:	ff 75 10             	pushl  0x10(%ebp)
f01054a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01054ab:	ff 70 60             	pushl  0x60(%eax)
f01054ae:	e8 6d c0 ff ff       	call   f0101520 <page_lookup>
	if(src_page == NULL)
f01054b3:	83 c4 10             	add    $0x10,%esp
f01054b6:	85 c0                	test   %eax,%eax
f01054b8:	74 52                	je     f010550c <syscall+0x58e>
	if(perm & PTE_W){
f01054ba:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01054be:	74 08                	je     f01054c8 <syscall+0x54a>
		if((*pte_store & PTE_W) == 0)
f01054c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01054c3:	f6 02 02             	testb  $0x2,(%edx)
f01054c6:	74 4e                	je     f0105516 <syscall+0x598>
	return page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f01054c8:	ff 75 1c             	pushl  0x1c(%ebp)
f01054cb:	ff 75 18             	pushl  0x18(%ebp)
f01054ce:	50                   	push   %eax
f01054cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01054d2:	ff 70 60             	pushl  0x60(%eax)
f01054d5:	e8 26 c1 ff ff       	call   f0101600 <page_insert>
f01054da:	89 c3                	mov    %eax,%ebx
f01054dc:	83 c4 10             	add    $0x10,%esp
f01054df:	e9 ec fa ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f01054e4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01054e9:	e9 e2 fa ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f01054ee:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01054f3:	e9 d8 fa ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f01054f8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01054fd:	e9 ce fa ff ff       	jmp    f0104fd0 <syscall+0x52>
f0105502:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105507:	e9 c4 fa ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f010550c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105511:	e9 ba fa ff ff       	jmp    f0104fd0 <syscall+0x52>
			return -E_INVAL;
f0105516:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010551b:	e9 b0 fa ff ff       	jmp    f0104fd0 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105520:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105527:	77 45                	ja     f010556e <syscall+0x5f0>
f0105529:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105530:	75 46                	jne    f0105578 <syscall+0x5fa>
	int ret = envid2env(envid, &env, 1);
f0105532:	83 ec 04             	sub    $0x4,%esp
f0105535:	6a 01                	push   $0x1
f0105537:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010553a:	50                   	push   %eax
f010553b:	ff 75 0c             	pushl  0xc(%ebp)
f010553e:	e8 eb df ff ff       	call   f010352e <envid2env>
f0105543:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105545:	83 c4 10             	add    $0x10,%esp
f0105548:	85 c0                	test   %eax,%eax
f010554a:	0f 88 80 fa ff ff    	js     f0104fd0 <syscall+0x52>
	page_remove(env->env_pgdir, va);
f0105550:	83 ec 08             	sub    $0x8,%esp
f0105553:	ff 75 10             	pushl  0x10(%ebp)
f0105556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105559:	ff 70 60             	pushl  0x60(%eax)
f010555c:	e8 59 c0 ff ff       	call   f01015ba <page_remove>
f0105561:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105564:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105569:	e9 62 fa ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f010556e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105573:	e9 58 fa ff ff       	jmp    f0104fd0 <syscall+0x52>
f0105578:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010557d:	e9 4e fa ff ff       	jmp    f0104fd0 <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f0105582:	83 ec 04             	sub    $0x4,%esp
f0105585:	6a 00                	push   $0x0
f0105587:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010558a:	50                   	push   %eax
f010558b:	ff 75 0c             	pushl  0xc(%ebp)
f010558e:	e8 9b df ff ff       	call   f010352e <envid2env>
f0105593:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105595:	83 c4 10             	add    $0x10,%esp
f0105598:	85 c0                	test   %eax,%eax
f010559a:	0f 88 30 fa ff ff    	js     f0104fd0 <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f01055a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01055a3:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01055a7:	0f 84 09 01 00 00    	je     f01056b6 <syscall+0x738>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f01055ad:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01055b4:	77 78                	ja     f010562e <syscall+0x6b0>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01055b6:	8b 45 18             	mov    0x18(%ebp),%eax
f01055b9:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f01055bc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01055c1:	83 f8 05             	cmp    $0x5,%eax
f01055c4:	0f 85 06 fa ff ff    	jne    f0104fd0 <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f01055ca:	8b 55 14             	mov    0x14(%ebp),%edx
f01055cd:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f01055d3:	8b 45 18             	mov    0x18(%ebp),%eax
f01055d6:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f01055db:	09 c2                	or     %eax,%edx
f01055dd:	0f 85 ed f9 ff ff    	jne    f0104fd0 <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f01055e3:	e8 9a 15 00 00       	call   f0106b82 <cpunum>
f01055e8:	83 ec 04             	sub    $0x4,%esp
f01055eb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01055ee:	52                   	push   %edx
f01055ef:	ff 75 14             	pushl  0x14(%ebp)
f01055f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01055f5:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01055fb:	ff 70 60             	pushl  0x60(%eax)
f01055fe:	e8 1d bf ff ff       	call   f0101520 <page_lookup>
		if(!page)
f0105603:	83 c4 10             	add    $0x10,%esp
f0105606:	85 c0                	test   %eax,%eax
f0105608:	0f 84 9e 00 00 00    	je     f01056ac <syscall+0x72e>
		if((perm & PTE_W) && !(*pte & PTE_W))
f010560e:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105612:	74 0c                	je     f0105620 <syscall+0x6a2>
f0105614:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105617:	f6 02 02             	testb  $0x2,(%edx)
f010561a:	0f 84 b0 f9 ff ff    	je     f0104fd0 <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105620:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105623:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105626:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010562c:	76 52                	jbe    f0105680 <syscall+0x702>
	dst_env->env_ipc_recving = 0;
f010562e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105631:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105635:	e8 48 15 00 00       	call   f0106b82 <cpunum>
f010563a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010563d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105640:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105646:	8b 40 48             	mov    0x48(%eax),%eax
f0105649:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_value = value;
f010564c:	8b 45 10             	mov    0x10(%ebp),%eax
f010564f:	89 42 70             	mov    %eax,0x70(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f0105652:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f0105659:	b8 00 00 00 00       	mov    $0x0,%eax
f010565e:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f0105662:	89 45 18             	mov    %eax,0x18(%ebp)
f0105665:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f0105668:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f010566f:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f0105676:	bb 00 00 00 00       	mov    $0x0,%ebx
f010567b:	e9 50 f9 ff ff       	jmp    f0104fd0 <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f0105680:	ff 75 18             	pushl  0x18(%ebp)
f0105683:	51                   	push   %ecx
f0105684:	50                   	push   %eax
f0105685:	ff 72 60             	pushl  0x60(%edx)
f0105688:	e8 73 bf ff ff       	call   f0101600 <page_insert>
f010568d:	89 c3                	mov    %eax,%ebx
			if(ret < 0){
f010568f:	83 c4 10             	add    $0x10,%esp
f0105692:	85 c0                	test   %eax,%eax
f0105694:	79 98                	jns    f010562e <syscall+0x6b0>
				cprintf("2the ret in rece %d\n", ret);
f0105696:	83 ec 08             	sub    $0x8,%esp
f0105699:	50                   	push   %eax
f010569a:	68 6d 98 10 f0       	push   $0xf010986d
f010569f:	e8 1d e8 ff ff       	call   f0103ec1 <cprintf>
f01056a4:	83 c4 10             	add    $0x10,%esp
f01056a7:	e9 24 f9 ff ff       	jmp    f0104fd0 <syscall+0x52>
			return -E_INVAL;		
f01056ac:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01056b1:	e9 1a f9 ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_IPC_NOT_RECV;
f01056b6:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f01056bb:	e9 10 f9 ff ff       	jmp    f0104fd0 <syscall+0x52>
	if(dstva < (void *)UTOP){
f01056c0:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f01056c7:	77 13                	ja     f01056dc <syscall+0x75e>
		if((uint32_t)dstva % PGSIZE != 0)
f01056c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f01056d0:	74 0a                	je     f01056dc <syscall+0x75e>
			ret = sys_ipc_recv((void *)a1);
f01056d2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f01056d7:	e9 f4 f8 ff ff       	jmp    f0104fd0 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f01056dc:	e8 a1 14 00 00       	call   f0106b82 <cpunum>
f01056e1:	6b c0 74             	imul   $0x74,%eax,%eax
f01056e4:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01056ea:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f01056ee:	e8 8f 14 00 00       	call   f0106b82 <cpunum>
f01056f3:	6b c0 74             	imul   $0x74,%eax,%eax
f01056f6:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f01056fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01056ff:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105702:	e8 7b 14 00 00       	call   f0106b82 <cpunum>
f0105707:	6b c0 74             	imul   $0x74,%eax,%eax
f010570a:	8b 80 28 00 58 f0    	mov    -0xfa7ffd8(%eax),%eax
f0105710:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105717:	e8 52 f7 ff ff       	call   f0104e6e <sched_yield>
	int ret = envid2env(envid, &e, 1);
f010571c:	83 ec 04             	sub    $0x4,%esp
f010571f:	6a 01                	push   $0x1
f0105721:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105724:	50                   	push   %eax
f0105725:	ff 75 0c             	pushl  0xc(%ebp)
f0105728:	e8 01 de ff ff       	call   f010352e <envid2env>
f010572d:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f010572f:	83 c4 10             	add    $0x10,%esp
f0105732:	85 c0                	test   %eax,%eax
f0105734:	0f 88 96 f8 ff ff    	js     f0104fd0 <syscall+0x52>
	e->env_pgfault_upcall = func;
f010573a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010573d:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105740:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0105743:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105748:	e9 83 f8 ff ff       	jmp    f0104fd0 <syscall+0x52>
	r = envid2env(envid, &e, 0);
f010574d:	83 ec 04             	sub    $0x4,%esp
f0105750:	6a 00                	push   $0x0
f0105752:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105755:	50                   	push   %eax
f0105756:	ff 75 0c             	pushl  0xc(%ebp)
f0105759:	e8 d0 dd ff ff       	call   f010352e <envid2env>
f010575e:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f0105760:	83 c4 10             	add    $0x10,%esp
f0105763:	85 c0                	test   %eax,%eax
f0105765:	0f 88 65 f8 ff ff    	js     f0104fd0 <syscall+0x52>
	e->env_tf = *tf;
f010576b:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105770:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105773:	8b 75 10             	mov    0x10(%ebp),%esi
f0105776:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f0105778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010577b:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f0105780:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f0105787:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f010578c:	e9 3f f8 ff ff       	jmp    f0104fd0 <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f0105791:	83 ec 04             	sub    $0x4,%esp
f0105794:	6a 00                	push   $0x0
f0105796:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105799:	50                   	push   %eax
f010579a:	ff 75 0c             	pushl  0xc(%ebp)
f010579d:	e8 8c dd ff ff       	call   f010352e <envid2env>
f01057a2:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01057a4:	83 c4 10             	add    $0x10,%esp
f01057a7:	85 c0                	test   %eax,%eax
f01057a9:	0f 88 21 f8 ff ff    	js     f0104fd0 <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f01057af:	83 ec 04             	sub    $0x4,%esp
f01057b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01057b5:	50                   	push   %eax
f01057b6:	ff 75 10             	pushl  0x10(%ebp)
f01057b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057bc:	ff 70 60             	pushl  0x60(%eax)
f01057bf:	e8 5c bd ff ff       	call   f0101520 <page_lookup>
	if(page == NULL)
f01057c4:	83 c4 10             	add    $0x10,%esp
f01057c7:	85 c0                	test   %eax,%eax
f01057c9:	74 16                	je     f01057e1 <syscall+0x863>
	*pte_store |= PTE_A;
f01057cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01057ce:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f01057d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01057d4:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f01057d7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01057dc:	e9 ef f7 ff ff       	jmp    f0104fd0 <syscall+0x52>
		return -E_INVAL;
f01057e1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01057e6:	e9 e5 f7 ff ff       	jmp    f0104fd0 <syscall+0x52>
	return time_msec();
f01057eb:	e8 67 21 00 00       	call   f0107957 <time_msec>
f01057f0:	89 c3                	mov    %eax,%ebx
			break;
f01057f2:	e9 d9 f7 ff ff       	jmp    f0104fd0 <syscall+0x52>
			ret = sys_net_send((void *)a1, (uint32_t)a2);
f01057f7:	83 ec 08             	sub    $0x8,%esp
f01057fa:	ff 75 10             	pushl  0x10(%ebp)
f01057fd:	ff 75 0c             	pushl  0xc(%ebp)
f0105800:	e8 21 f7 ff ff       	call   f0104f26 <sys_net_send>
f0105805:	89 c3                	mov    %eax,%ebx
			break;
f0105807:	83 c4 10             	add    $0x10,%esp
f010580a:	e9 c1 f7 ff ff       	jmp    f0104fd0 <syscall+0x52>
			ret = -E_INVAL;
f010580f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105814:	e9 b7 f7 ff ff       	jmp    f0104fd0 <syscall+0x52>
        return E_INVAL;
f0105819:	bb 03 00 00 00       	mov    $0x3,%ebx
f010581e:	e9 ad f7 ff ff       	jmp    f0104fd0 <syscall+0x52>

f0105823 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105823:	55                   	push   %ebp
f0105824:	89 e5                	mov    %esp,%ebp
f0105826:	57                   	push   %edi
f0105827:	56                   	push   %esi
f0105828:	53                   	push   %ebx
f0105829:	83 ec 14             	sub    $0x14,%esp
f010582c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010582f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105832:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105835:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105838:	8b 1a                	mov    (%edx),%ebx
f010583a:	8b 01                	mov    (%ecx),%eax
f010583c:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010583f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105846:	eb 23                	jmp    f010586b <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105848:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f010584b:	eb 1e                	jmp    f010586b <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f010584d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105850:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105853:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105857:	3b 55 0c             	cmp    0xc(%ebp),%edx
f010585a:	73 41                	jae    f010589d <stab_binsearch+0x7a>
			*region_left = m;
f010585c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010585f:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0105861:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0105864:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f010586b:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f010586e:	7f 5a                	jg     f01058ca <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0105870:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105873:	01 d8                	add    %ebx,%eax
f0105875:	89 c7                	mov    %eax,%edi
f0105877:	c1 ef 1f             	shr    $0x1f,%edi
f010587a:	01 c7                	add    %eax,%edi
f010587c:	d1 ff                	sar    %edi
f010587e:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105881:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105884:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0105888:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f010588a:	39 c3                	cmp    %eax,%ebx
f010588c:	7f ba                	jg     f0105848 <stab_binsearch+0x25>
f010588e:	0f b6 0a             	movzbl (%edx),%ecx
f0105891:	83 ea 0c             	sub    $0xc,%edx
f0105894:	39 f1                	cmp    %esi,%ecx
f0105896:	74 b5                	je     f010584d <stab_binsearch+0x2a>
			m--;
f0105898:	83 e8 01             	sub    $0x1,%eax
f010589b:	eb ed                	jmp    f010588a <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f010589d:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01058a0:	76 14                	jbe    f01058b6 <stab_binsearch+0x93>
			*region_right = m - 1;
f01058a2:	83 e8 01             	sub    $0x1,%eax
f01058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01058a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01058ab:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f01058ad:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01058b4:	eb b5                	jmp    f010586b <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01058b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01058b9:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f01058bb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01058bf:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f01058c1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01058c8:	eb a1                	jmp    f010586b <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f01058ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01058ce:	75 15                	jne    f01058e5 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f01058d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058d3:	8b 00                	mov    (%eax),%eax
f01058d5:	83 e8 01             	sub    $0x1,%eax
f01058d8:	8b 75 e0             	mov    -0x20(%ebp),%esi
f01058db:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f01058dd:	83 c4 14             	add    $0x14,%esp
f01058e0:	5b                   	pop    %ebx
f01058e1:	5e                   	pop    %esi
f01058e2:	5f                   	pop    %edi
f01058e3:	5d                   	pop    %ebp
f01058e4:	c3                   	ret    
		for (l = *region_right;
f01058e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058e8:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f01058ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01058ed:	8b 0f                	mov    (%edi),%ecx
f01058ef:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01058f2:	8b 7d ec             	mov    -0x14(%ebp),%edi
f01058f5:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f01058f9:	eb 03                	jmp    f01058fe <stab_binsearch+0xdb>
		     l--)
f01058fb:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f01058fe:	39 c1                	cmp    %eax,%ecx
f0105900:	7d 0a                	jge    f010590c <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0105902:	0f b6 1a             	movzbl (%edx),%ebx
f0105905:	83 ea 0c             	sub    $0xc,%edx
f0105908:	39 f3                	cmp    %esi,%ebx
f010590a:	75 ef                	jne    f01058fb <stab_binsearch+0xd8>
		*region_left = l;
f010590c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010590f:	89 06                	mov    %eax,(%esi)
}
f0105911:	eb ca                	jmp    f01058dd <stab_binsearch+0xba>

f0105913 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105913:	55                   	push   %ebp
f0105914:	89 e5                	mov    %esp,%ebp
f0105916:	57                   	push   %edi
f0105917:	56                   	push   %esi
f0105918:	53                   	push   %ebx
f0105919:	83 ec 4c             	sub    $0x4c,%esp
f010591c:	8b 7d 08             	mov    0x8(%ebp),%edi
f010591f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105922:	c7 03 49 99 10 f0    	movl   $0xf0109949,(%ebx)
	info->eip_line = 0;
f0105928:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f010592f:	c7 43 08 49 99 10 f0 	movl   $0xf0109949,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105936:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f010593d:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105940:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105947:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f010594d:	0f 86 23 01 00 00    	jbe    f0105a76 <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105953:	c7 45 b8 6a e5 11 f0 	movl   $0xf011e56a,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f010595a:	c7 45 b4 15 9b 11 f0 	movl   $0xf0119b15,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0105961:	be 14 9b 11 f0       	mov    $0xf0119b14,%esi
		stabs = __STAB_BEGIN__;
f0105966:	c7 45 bc 2c a2 10 f0 	movl   $0xf010a22c,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f010596d:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105970:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f0105973:	0f 83 59 02 00 00    	jae    f0105bd2 <debuginfo_eip+0x2bf>
f0105979:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f010597d:	0f 85 56 02 00 00    	jne    f0105bd9 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105983:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f010598a:	2b 75 bc             	sub    -0x44(%ebp),%esi
f010598d:	c1 fe 02             	sar    $0x2,%esi
f0105990:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0105996:	83 e8 01             	sub    $0x1,%eax
f0105999:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010599c:	83 ec 08             	sub    $0x8,%esp
f010599f:	57                   	push   %edi
f01059a0:	6a 64                	push   $0x64
f01059a2:	8d 55 e0             	lea    -0x20(%ebp),%edx
f01059a5:	89 d1                	mov    %edx,%ecx
f01059a7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01059aa:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01059ad:	89 f0                	mov    %esi,%eax
f01059af:	e8 6f fe ff ff       	call   f0105823 <stab_binsearch>
	if (lfile == 0)
f01059b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01059b7:	83 c4 10             	add    $0x10,%esp
f01059ba:	85 c0                	test   %eax,%eax
f01059bc:	0f 84 1e 02 00 00    	je     f0105be0 <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01059c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f01059c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01059c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f01059cb:	83 ec 08             	sub    $0x8,%esp
f01059ce:	57                   	push   %edi
f01059cf:	6a 24                	push   $0x24
f01059d1:	8d 55 d8             	lea    -0x28(%ebp),%edx
f01059d4:	89 d1                	mov    %edx,%ecx
f01059d6:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01059d9:	89 f0                	mov    %esi,%eax
f01059db:	e8 43 fe ff ff       	call   f0105823 <stab_binsearch>

	if (lfun <= rfun) {
f01059e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01059e3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01059e6:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f01059e9:	83 c4 10             	add    $0x10,%esp
f01059ec:	39 c8                	cmp    %ecx,%eax
f01059ee:	0f 8f 26 01 00 00    	jg     f0105b1a <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f01059f4:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01059f7:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f01059fa:	8b 11                	mov    (%ecx),%edx
f01059fc:	8b 75 b8             	mov    -0x48(%ebp),%esi
f01059ff:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105a02:	39 f2                	cmp    %esi,%edx
f0105a04:	73 06                	jae    f0105a0c <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105a06:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105a09:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105a0c:	8b 51 08             	mov    0x8(%ecx),%edx
f0105a0f:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105a12:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105a14:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105a17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105a1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105a1d:	83 ec 08             	sub    $0x8,%esp
f0105a20:	6a 3a                	push   $0x3a
f0105a22:	ff 73 08             	pushl  0x8(%ebx)
f0105a25:	e8 34 0b 00 00       	call   f010655e <strfind>
f0105a2a:	2b 43 08             	sub    0x8(%ebx),%eax
f0105a2d:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105a30:	83 c4 08             	add    $0x8,%esp
f0105a33:	57                   	push   %edi
f0105a34:	6a 44                	push   $0x44
f0105a36:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105a39:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105a3c:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105a3f:	89 f0                	mov    %esi,%eax
f0105a41:	e8 dd fd ff ff       	call   f0105823 <stab_binsearch>
	if(lline <= rline){
f0105a46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105a49:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105a4c:	83 c4 10             	add    $0x10,%esp
f0105a4f:	39 c2                	cmp    %eax,%edx
f0105a51:	0f 8f 90 01 00 00    	jg     f0105be7 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f0105a57:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105a5a:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105a5e:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105a61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105a64:	89 d0                	mov    %edx,%eax
f0105a66:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105a69:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105a6d:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0105a71:	e9 c2 00 00 00       	jmp    f0105b38 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f0105a76:	e8 07 11 00 00       	call   f0106b82 <cpunum>
f0105a7b:	6a 06                	push   $0x6
f0105a7d:	6a 10                	push   $0x10
f0105a7f:	68 00 00 20 00       	push   $0x200000
f0105a84:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a87:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0105a8d:	e8 22 d9 ff ff       	call   f01033b4 <user_mem_check>
f0105a92:	83 c4 10             	add    $0x10,%esp
f0105a95:	85 c0                	test   %eax,%eax
f0105a97:	0f 88 27 01 00 00    	js     f0105bc4 <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f0105a9d:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105aa3:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105aa6:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105aac:	a1 08 00 20 00       	mov    0x200008,%eax
f0105ab1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105ab4:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105aba:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f0105abd:	e8 c0 10 00 00       	call   f0106b82 <cpunum>
f0105ac2:	6a 06                	push   $0x6
f0105ac4:	89 f2                	mov    %esi,%edx
f0105ac6:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105ac9:	29 ca                	sub    %ecx,%edx
f0105acb:	52                   	push   %edx
f0105acc:	51                   	push   %ecx
f0105acd:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ad0:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0105ad6:	e8 d9 d8 ff ff       	call   f01033b4 <user_mem_check>
f0105adb:	83 c4 10             	add    $0x10,%esp
f0105ade:	85 c0                	test   %eax,%eax
f0105ae0:	0f 88 e5 00 00 00    	js     f0105bcb <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105ae6:	e8 97 10 00 00       	call   f0106b82 <cpunum>
f0105aeb:	6a 06                	push   $0x6
f0105aed:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105af0:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105af3:	29 ca                	sub    %ecx,%edx
f0105af5:	52                   	push   %edx
f0105af6:	51                   	push   %ecx
f0105af7:	6b c0 74             	imul   $0x74,%eax,%eax
f0105afa:	ff b0 28 00 58 f0    	pushl  -0xfa7ffd8(%eax)
f0105b00:	e8 af d8 ff ff       	call   f01033b4 <user_mem_check>
f0105b05:	83 c4 10             	add    $0x10,%esp
f0105b08:	85 c0                	test   %eax,%eax
f0105b0a:	0f 89 5d fe ff ff    	jns    f010596d <debuginfo_eip+0x5a>
			return -1;
f0105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b15:	e9 d9 00 00 00       	jmp    f0105bf3 <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105b1a:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105b23:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b26:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105b29:	e9 ef fe ff ff       	jmp    f0105a1d <debuginfo_eip+0x10a>
f0105b2e:	83 e8 01             	sub    $0x1,%eax
f0105b31:	83 ea 0c             	sub    $0xc,%edx
f0105b34:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105b38:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105b3b:	39 c7                	cmp    %eax,%edi
f0105b3d:	7f 45                	jg     f0105b84 <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f0105b3f:	0f b6 0a             	movzbl (%edx),%ecx
f0105b42:	80 f9 84             	cmp    $0x84,%cl
f0105b45:	74 19                	je     f0105b60 <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105b47:	80 f9 64             	cmp    $0x64,%cl
f0105b4a:	75 e2                	jne    f0105b2e <debuginfo_eip+0x21b>
f0105b4c:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105b50:	74 dc                	je     f0105b2e <debuginfo_eip+0x21b>
f0105b52:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105b56:	74 11                	je     f0105b69 <debuginfo_eip+0x256>
f0105b58:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105b5b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105b5e:	eb 09                	jmp    f0105b69 <debuginfo_eip+0x256>
f0105b60:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105b64:	74 03                	je     f0105b69 <debuginfo_eip+0x256>
f0105b66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105b69:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105b6c:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105b6f:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105b72:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105b75:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105b78:	29 f8                	sub    %edi,%eax
f0105b7a:	39 c2                	cmp    %eax,%edx
f0105b7c:	73 06                	jae    f0105b84 <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105b7e:	89 f8                	mov    %edi,%eax
f0105b80:	01 d0                	add    %edx,%eax
f0105b82:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105b84:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105b87:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f0105b8a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105b8f:	39 f2                	cmp    %esi,%edx
f0105b91:	7d 60                	jge    f0105bf3 <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0105b93:	83 c2 01             	add    $0x1,%edx
f0105b96:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105b99:	89 d0                	mov    %edx,%eax
f0105b9b:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105b9e:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105ba1:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105ba5:	eb 04                	jmp    f0105bab <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f0105ba7:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105bab:	39 c6                	cmp    %eax,%esi
f0105bad:	7e 3f                	jle    f0105bee <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105baf:	0f b6 0a             	movzbl (%edx),%ecx
f0105bb2:	83 c0 01             	add    $0x1,%eax
f0105bb5:	83 c2 0c             	add    $0xc,%edx
f0105bb8:	80 f9 a0             	cmp    $0xa0,%cl
f0105bbb:	74 ea                	je     f0105ba7 <debuginfo_eip+0x294>
	return 0;
f0105bbd:	b8 00 00 00 00       	mov    $0x0,%eax
f0105bc2:	eb 2f                	jmp    f0105bf3 <debuginfo_eip+0x2e0>
			return -1;
f0105bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105bc9:	eb 28                	jmp    f0105bf3 <debuginfo_eip+0x2e0>
			return -1;
f0105bcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105bd0:	eb 21                	jmp    f0105bf3 <debuginfo_eip+0x2e0>
		return -1;
f0105bd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105bd7:	eb 1a                	jmp    f0105bf3 <debuginfo_eip+0x2e0>
f0105bd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105bde:	eb 13                	jmp    f0105bf3 <debuginfo_eip+0x2e0>
		return -1;
f0105be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105be5:	eb 0c                	jmp    f0105bf3 <debuginfo_eip+0x2e0>
		return -1;
f0105be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105bec:	eb 05                	jmp    f0105bf3 <debuginfo_eip+0x2e0>
	return 0;
f0105bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105bf6:	5b                   	pop    %ebx
f0105bf7:	5e                   	pop    %esi
f0105bf8:	5f                   	pop    %edi
f0105bf9:	5d                   	pop    %ebp
f0105bfa:	c3                   	ret    

f0105bfb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105bfb:	55                   	push   %ebp
f0105bfc:	89 e5                	mov    %esp,%ebp
f0105bfe:	57                   	push   %edi
f0105bff:	56                   	push   %esi
f0105c00:	53                   	push   %ebx
f0105c01:	83 ec 1c             	sub    $0x1c,%esp
f0105c04:	89 c6                	mov    %eax,%esi
f0105c06:	89 d7                	mov    %edx,%edi
f0105c08:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105c11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105c14:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c17:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105c1a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105c1e:	74 2c                	je     f0105c4c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f0105c20:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105c23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105c2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105c2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105c30:	39 c2                	cmp    %eax,%edx
f0105c32:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105c35:	73 43                	jae    f0105c7a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105c37:	83 eb 01             	sub    $0x1,%ebx
f0105c3a:	85 db                	test   %ebx,%ebx
f0105c3c:	7e 6c                	jle    f0105caa <printnum+0xaf>
				putch(padc, putdat);
f0105c3e:	83 ec 08             	sub    $0x8,%esp
f0105c41:	57                   	push   %edi
f0105c42:	ff 75 18             	pushl  0x18(%ebp)
f0105c45:	ff d6                	call   *%esi
f0105c47:	83 c4 10             	add    $0x10,%esp
f0105c4a:	eb eb                	jmp    f0105c37 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105c4c:	83 ec 0c             	sub    $0xc,%esp
f0105c4f:	6a 20                	push   $0x20
f0105c51:	6a 00                	push   $0x0
f0105c53:	50                   	push   %eax
f0105c54:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105c57:	ff 75 e0             	pushl  -0x20(%ebp)
f0105c5a:	89 fa                	mov    %edi,%edx
f0105c5c:	89 f0                	mov    %esi,%eax
f0105c5e:	e8 98 ff ff ff       	call   f0105bfb <printnum>
		while (--width > 0)
f0105c63:	83 c4 20             	add    $0x20,%esp
f0105c66:	83 eb 01             	sub    $0x1,%ebx
f0105c69:	85 db                	test   %ebx,%ebx
f0105c6b:	7e 65                	jle    f0105cd2 <printnum+0xd7>
			putch(padc, putdat);
f0105c6d:	83 ec 08             	sub    $0x8,%esp
f0105c70:	57                   	push   %edi
f0105c71:	6a 20                	push   $0x20
f0105c73:	ff d6                	call   *%esi
f0105c75:	83 c4 10             	add    $0x10,%esp
f0105c78:	eb ec                	jmp    f0105c66 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f0105c7a:	83 ec 0c             	sub    $0xc,%esp
f0105c7d:	ff 75 18             	pushl  0x18(%ebp)
f0105c80:	83 eb 01             	sub    $0x1,%ebx
f0105c83:	53                   	push   %ebx
f0105c84:	50                   	push   %eax
f0105c85:	83 ec 08             	sub    $0x8,%esp
f0105c88:	ff 75 dc             	pushl  -0x24(%ebp)
f0105c8b:	ff 75 d8             	pushl  -0x28(%ebp)
f0105c8e:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105c91:	ff 75 e0             	pushl  -0x20(%ebp)
f0105c94:	e8 d7 1c 00 00       	call   f0107970 <__udivdi3>
f0105c99:	83 c4 18             	add    $0x18,%esp
f0105c9c:	52                   	push   %edx
f0105c9d:	50                   	push   %eax
f0105c9e:	89 fa                	mov    %edi,%edx
f0105ca0:	89 f0                	mov    %esi,%eax
f0105ca2:	e8 54 ff ff ff       	call   f0105bfb <printnum>
f0105ca7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f0105caa:	83 ec 08             	sub    $0x8,%esp
f0105cad:	57                   	push   %edi
f0105cae:	83 ec 04             	sub    $0x4,%esp
f0105cb1:	ff 75 dc             	pushl  -0x24(%ebp)
f0105cb4:	ff 75 d8             	pushl  -0x28(%ebp)
f0105cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cba:	ff 75 e0             	pushl  -0x20(%ebp)
f0105cbd:	e8 be 1d 00 00       	call   f0107a80 <__umoddi3>
f0105cc2:	83 c4 14             	add    $0x14,%esp
f0105cc5:	0f be 80 53 99 10 f0 	movsbl -0xfef66ad(%eax),%eax
f0105ccc:	50                   	push   %eax
f0105ccd:	ff d6                	call   *%esi
f0105ccf:	83 c4 10             	add    $0x10,%esp
	}
}
f0105cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105cd5:	5b                   	pop    %ebx
f0105cd6:	5e                   	pop    %esi
f0105cd7:	5f                   	pop    %edi
f0105cd8:	5d                   	pop    %ebp
f0105cd9:	c3                   	ret    

f0105cda <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105cda:	55                   	push   %ebp
f0105cdb:	89 e5                	mov    %esp,%ebp
f0105cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105ce0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105ce4:	8b 10                	mov    (%eax),%edx
f0105ce6:	3b 50 04             	cmp    0x4(%eax),%edx
f0105ce9:	73 0a                	jae    f0105cf5 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105ceb:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105cee:	89 08                	mov    %ecx,(%eax)
f0105cf0:	8b 45 08             	mov    0x8(%ebp),%eax
f0105cf3:	88 02                	mov    %al,(%edx)
}
f0105cf5:	5d                   	pop    %ebp
f0105cf6:	c3                   	ret    

f0105cf7 <printfmt>:
{
f0105cf7:	55                   	push   %ebp
f0105cf8:	89 e5                	mov    %esp,%ebp
f0105cfa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105cfd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105d00:	50                   	push   %eax
f0105d01:	ff 75 10             	pushl  0x10(%ebp)
f0105d04:	ff 75 0c             	pushl  0xc(%ebp)
f0105d07:	ff 75 08             	pushl  0x8(%ebp)
f0105d0a:	e8 05 00 00 00       	call   f0105d14 <vprintfmt>
}
f0105d0f:	83 c4 10             	add    $0x10,%esp
f0105d12:	c9                   	leave  
f0105d13:	c3                   	ret    

f0105d14 <vprintfmt>:
{
f0105d14:	55                   	push   %ebp
f0105d15:	89 e5                	mov    %esp,%ebp
f0105d17:	57                   	push   %edi
f0105d18:	56                   	push   %esi
f0105d19:	53                   	push   %ebx
f0105d1a:	83 ec 3c             	sub    $0x3c,%esp
f0105d1d:	8b 75 08             	mov    0x8(%ebp),%esi
f0105d20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105d23:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105d26:	e9 32 04 00 00       	jmp    f010615d <vprintfmt+0x449>
		padc = ' ';
f0105d2b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f0105d2f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f0105d36:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0105d3d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105d4b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0105d52:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105d57:	8d 47 01             	lea    0x1(%edi),%eax
f0105d5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105d5d:	0f b6 17             	movzbl (%edi),%edx
f0105d60:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105d63:	3c 55                	cmp    $0x55,%al
f0105d65:	0f 87 12 05 00 00    	ja     f010627d <vprintfmt+0x569>
f0105d6b:	0f b6 c0             	movzbl %al,%eax
f0105d6e:	ff 24 85 40 9b 10 f0 	jmp    *-0xfef64c0(,%eax,4)
f0105d75:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105d78:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0105d7c:	eb d9                	jmp    f0105d57 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105d7e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105d81:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0105d85:	eb d0                	jmp    f0105d57 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105d87:	0f b6 d2             	movzbl %dl,%edx
f0105d8a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105d8d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105d92:	89 75 08             	mov    %esi,0x8(%ebp)
f0105d95:	eb 03                	jmp    f0105d9a <vprintfmt+0x86>
f0105d97:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105d9a:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105d9d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0105da1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105da4:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105da7:	83 fe 09             	cmp    $0x9,%esi
f0105daa:	76 eb                	jbe    f0105d97 <vprintfmt+0x83>
f0105dac:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105daf:	8b 75 08             	mov    0x8(%ebp),%esi
f0105db2:	eb 14                	jmp    f0105dc8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0105db4:	8b 45 14             	mov    0x14(%ebp),%eax
f0105db7:	8b 00                	mov    (%eax),%eax
f0105db9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105dbc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105dbf:	8d 40 04             	lea    0x4(%eax),%eax
f0105dc2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105dc5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105dc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105dcc:	79 89                	jns    f0105d57 <vprintfmt+0x43>
				width = precision, precision = -1;
f0105dce:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105dd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105dd4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105ddb:	e9 77 ff ff ff       	jmp    f0105d57 <vprintfmt+0x43>
f0105de0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105de3:	85 c0                	test   %eax,%eax
f0105de5:	0f 48 c1             	cmovs  %ecx,%eax
f0105de8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105deb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105dee:	e9 64 ff ff ff       	jmp    f0105d57 <vprintfmt+0x43>
f0105df3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105df6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0105dfd:	e9 55 ff ff ff       	jmp    f0105d57 <vprintfmt+0x43>
			lflag++;
f0105e02:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105e09:	e9 49 ff ff ff       	jmp    f0105d57 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0105e0e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e11:	8d 78 04             	lea    0x4(%eax),%edi
f0105e14:	83 ec 08             	sub    $0x8,%esp
f0105e17:	53                   	push   %ebx
f0105e18:	ff 30                	pushl  (%eax)
f0105e1a:	ff d6                	call   *%esi
			break;
f0105e1c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105e1f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105e22:	e9 33 03 00 00       	jmp    f010615a <vprintfmt+0x446>
			err = va_arg(ap, int);
f0105e27:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e2a:	8d 78 04             	lea    0x4(%eax),%edi
f0105e2d:	8b 00                	mov    (%eax),%eax
f0105e2f:	99                   	cltd   
f0105e30:	31 d0                	xor    %edx,%eax
f0105e32:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105e34:	83 f8 11             	cmp    $0x11,%eax
f0105e37:	7f 23                	jg     f0105e5c <vprintfmt+0x148>
f0105e39:	8b 14 85 a0 9c 10 f0 	mov    -0xfef6360(,%eax,4),%edx
f0105e40:	85 d2                	test   %edx,%edx
f0105e42:	74 18                	je     f0105e5c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f0105e44:	52                   	push   %edx
f0105e45:	68 dd 8d 10 f0       	push   $0xf0108ddd
f0105e4a:	53                   	push   %ebx
f0105e4b:	56                   	push   %esi
f0105e4c:	e8 a6 fe ff ff       	call   f0105cf7 <printfmt>
f0105e51:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105e54:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105e57:	e9 fe 02 00 00       	jmp    f010615a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f0105e5c:	50                   	push   %eax
f0105e5d:	68 6b 99 10 f0       	push   $0xf010996b
f0105e62:	53                   	push   %ebx
f0105e63:	56                   	push   %esi
f0105e64:	e8 8e fe ff ff       	call   f0105cf7 <printfmt>
f0105e69:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105e6c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105e6f:	e9 e6 02 00 00       	jmp    f010615a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f0105e74:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e77:	83 c0 04             	add    $0x4,%eax
f0105e7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105e7d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e80:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f0105e82:	85 c9                	test   %ecx,%ecx
f0105e84:	b8 64 99 10 f0       	mov    $0xf0109964,%eax
f0105e89:	0f 45 c1             	cmovne %ecx,%eax
f0105e8c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0105e8f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105e93:	7e 06                	jle    f0105e9b <vprintfmt+0x187>
f0105e95:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0105e99:	75 0d                	jne    f0105ea8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105e9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105e9e:	89 c7                	mov    %eax,%edi
f0105ea0:	03 45 e0             	add    -0x20(%ebp),%eax
f0105ea3:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105ea6:	eb 53                	jmp    f0105efb <vprintfmt+0x1e7>
f0105ea8:	83 ec 08             	sub    $0x8,%esp
f0105eab:	ff 75 d8             	pushl  -0x28(%ebp)
f0105eae:	50                   	push   %eax
f0105eaf:	e8 5f 05 00 00       	call   f0106413 <strnlen>
f0105eb4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105eb7:	29 c1                	sub    %eax,%ecx
f0105eb9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0105ebc:	83 c4 10             	add    $0x10,%esp
f0105ebf:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0105ec1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0105ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105ec8:	eb 0f                	jmp    f0105ed9 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0105eca:	83 ec 08             	sub    $0x8,%esp
f0105ecd:	53                   	push   %ebx
f0105ece:	ff 75 e0             	pushl  -0x20(%ebp)
f0105ed1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105ed3:	83 ef 01             	sub    $0x1,%edi
f0105ed6:	83 c4 10             	add    $0x10,%esp
f0105ed9:	85 ff                	test   %edi,%edi
f0105edb:	7f ed                	jg     f0105eca <vprintfmt+0x1b6>
f0105edd:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105ee0:	85 c9                	test   %ecx,%ecx
f0105ee2:	b8 00 00 00 00       	mov    $0x0,%eax
f0105ee7:	0f 49 c1             	cmovns %ecx,%eax
f0105eea:	29 c1                	sub    %eax,%ecx
f0105eec:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105eef:	eb aa                	jmp    f0105e9b <vprintfmt+0x187>
					putch(ch, putdat);
f0105ef1:	83 ec 08             	sub    $0x8,%esp
f0105ef4:	53                   	push   %ebx
f0105ef5:	52                   	push   %edx
f0105ef6:	ff d6                	call   *%esi
f0105ef8:	83 c4 10             	add    $0x10,%esp
f0105efb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105efe:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105f00:	83 c7 01             	add    $0x1,%edi
f0105f03:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105f07:	0f be d0             	movsbl %al,%edx
f0105f0a:	85 d2                	test   %edx,%edx
f0105f0c:	74 4b                	je     f0105f59 <vprintfmt+0x245>
f0105f0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105f12:	78 06                	js     f0105f1a <vprintfmt+0x206>
f0105f14:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105f18:	78 1e                	js     f0105f38 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f0105f1a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0105f1e:	74 d1                	je     f0105ef1 <vprintfmt+0x1dd>
f0105f20:	0f be c0             	movsbl %al,%eax
f0105f23:	83 e8 20             	sub    $0x20,%eax
f0105f26:	83 f8 5e             	cmp    $0x5e,%eax
f0105f29:	76 c6                	jbe    f0105ef1 <vprintfmt+0x1dd>
					putch('?', putdat);
f0105f2b:	83 ec 08             	sub    $0x8,%esp
f0105f2e:	53                   	push   %ebx
f0105f2f:	6a 3f                	push   $0x3f
f0105f31:	ff d6                	call   *%esi
f0105f33:	83 c4 10             	add    $0x10,%esp
f0105f36:	eb c3                	jmp    f0105efb <vprintfmt+0x1e7>
f0105f38:	89 cf                	mov    %ecx,%edi
f0105f3a:	eb 0e                	jmp    f0105f4a <vprintfmt+0x236>
				putch(' ', putdat);
f0105f3c:	83 ec 08             	sub    $0x8,%esp
f0105f3f:	53                   	push   %ebx
f0105f40:	6a 20                	push   $0x20
f0105f42:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105f44:	83 ef 01             	sub    $0x1,%edi
f0105f47:	83 c4 10             	add    $0x10,%esp
f0105f4a:	85 ff                	test   %edi,%edi
f0105f4c:	7f ee                	jg     f0105f3c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f0105f4e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105f51:	89 45 14             	mov    %eax,0x14(%ebp)
f0105f54:	e9 01 02 00 00       	jmp    f010615a <vprintfmt+0x446>
f0105f59:	89 cf                	mov    %ecx,%edi
f0105f5b:	eb ed                	jmp    f0105f4a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f0105f5d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f0105f60:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f0105f67:	e9 eb fd ff ff       	jmp    f0105d57 <vprintfmt+0x43>
	if (lflag >= 2)
f0105f6c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105f70:	7f 21                	jg     f0105f93 <vprintfmt+0x27f>
	else if (lflag)
f0105f72:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105f76:	74 68                	je     f0105fe0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f0105f78:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f7b:	8b 00                	mov    (%eax),%eax
f0105f7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105f80:	89 c1                	mov    %eax,%ecx
f0105f82:	c1 f9 1f             	sar    $0x1f,%ecx
f0105f85:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105f88:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f8b:	8d 40 04             	lea    0x4(%eax),%eax
f0105f8e:	89 45 14             	mov    %eax,0x14(%ebp)
f0105f91:	eb 17                	jmp    f0105faa <vprintfmt+0x296>
		return va_arg(*ap, long long);
f0105f93:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f96:	8b 50 04             	mov    0x4(%eax),%edx
f0105f99:	8b 00                	mov    (%eax),%eax
f0105f9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105f9e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105fa1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fa4:	8d 40 08             	lea    0x8(%eax),%eax
f0105fa7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0105faa:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105fad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105fb0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105fb3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f0105fb6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105fba:	78 3f                	js     f0105ffb <vprintfmt+0x2e7>
			base = 10;
f0105fbc:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f0105fc1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f0105fc5:	0f 84 71 01 00 00    	je     f010613c <vprintfmt+0x428>
				putch('+', putdat);
f0105fcb:	83 ec 08             	sub    $0x8,%esp
f0105fce:	53                   	push   %ebx
f0105fcf:	6a 2b                	push   $0x2b
f0105fd1:	ff d6                	call   *%esi
f0105fd3:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105fd6:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105fdb:	e9 5c 01 00 00       	jmp    f010613c <vprintfmt+0x428>
		return va_arg(*ap, int);
f0105fe0:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fe3:	8b 00                	mov    (%eax),%eax
f0105fe5:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105fe8:	89 c1                	mov    %eax,%ecx
f0105fea:	c1 f9 1f             	sar    $0x1f,%ecx
f0105fed:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105ff0:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ff3:	8d 40 04             	lea    0x4(%eax),%eax
f0105ff6:	89 45 14             	mov    %eax,0x14(%ebp)
f0105ff9:	eb af                	jmp    f0105faa <vprintfmt+0x296>
				putch('-', putdat);
f0105ffb:	83 ec 08             	sub    $0x8,%esp
f0105ffe:	53                   	push   %ebx
f0105fff:	6a 2d                	push   $0x2d
f0106001:	ff d6                	call   *%esi
				num = -(long long) num;
f0106003:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106006:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106009:	f7 d8                	neg    %eax
f010600b:	83 d2 00             	adc    $0x0,%edx
f010600e:	f7 da                	neg    %edx
f0106010:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106013:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106016:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0106019:	b8 0a 00 00 00       	mov    $0xa,%eax
f010601e:	e9 19 01 00 00       	jmp    f010613c <vprintfmt+0x428>
	if (lflag >= 2)
f0106023:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0106027:	7f 29                	jg     f0106052 <vprintfmt+0x33e>
	else if (lflag)
f0106029:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f010602d:	74 44                	je     f0106073 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f010602f:	8b 45 14             	mov    0x14(%ebp),%eax
f0106032:	8b 00                	mov    (%eax),%eax
f0106034:	ba 00 00 00 00       	mov    $0x0,%edx
f0106039:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010603c:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010603f:	8b 45 14             	mov    0x14(%ebp),%eax
f0106042:	8d 40 04             	lea    0x4(%eax),%eax
f0106045:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106048:	b8 0a 00 00 00       	mov    $0xa,%eax
f010604d:	e9 ea 00 00 00       	jmp    f010613c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106052:	8b 45 14             	mov    0x14(%ebp),%eax
f0106055:	8b 50 04             	mov    0x4(%eax),%edx
f0106058:	8b 00                	mov    (%eax),%eax
f010605a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010605d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106060:	8b 45 14             	mov    0x14(%ebp),%eax
f0106063:	8d 40 08             	lea    0x8(%eax),%eax
f0106066:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106069:	b8 0a 00 00 00       	mov    $0xa,%eax
f010606e:	e9 c9 00 00 00       	jmp    f010613c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106073:	8b 45 14             	mov    0x14(%ebp),%eax
f0106076:	8b 00                	mov    (%eax),%eax
f0106078:	ba 00 00 00 00       	mov    $0x0,%edx
f010607d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106080:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106083:	8b 45 14             	mov    0x14(%ebp),%eax
f0106086:	8d 40 04             	lea    0x4(%eax),%eax
f0106089:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010608c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106091:	e9 a6 00 00 00       	jmp    f010613c <vprintfmt+0x428>
			putch('0', putdat);
f0106096:	83 ec 08             	sub    $0x8,%esp
f0106099:	53                   	push   %ebx
f010609a:	6a 30                	push   $0x30
f010609c:	ff d6                	call   *%esi
	if (lflag >= 2)
f010609e:	83 c4 10             	add    $0x10,%esp
f01060a1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01060a5:	7f 26                	jg     f01060cd <vprintfmt+0x3b9>
	else if (lflag)
f01060a7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01060ab:	74 3e                	je     f01060eb <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f01060ad:	8b 45 14             	mov    0x14(%ebp),%eax
f01060b0:	8b 00                	mov    (%eax),%eax
f01060b2:	ba 00 00 00 00       	mov    $0x0,%edx
f01060b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060bd:	8b 45 14             	mov    0x14(%ebp),%eax
f01060c0:	8d 40 04             	lea    0x4(%eax),%eax
f01060c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01060c6:	b8 08 00 00 00       	mov    $0x8,%eax
f01060cb:	eb 6f                	jmp    f010613c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01060cd:	8b 45 14             	mov    0x14(%ebp),%eax
f01060d0:	8b 50 04             	mov    0x4(%eax),%edx
f01060d3:	8b 00                	mov    (%eax),%eax
f01060d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060db:	8b 45 14             	mov    0x14(%ebp),%eax
f01060de:	8d 40 08             	lea    0x8(%eax),%eax
f01060e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01060e4:	b8 08 00 00 00       	mov    $0x8,%eax
f01060e9:	eb 51                	jmp    f010613c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f01060eb:	8b 45 14             	mov    0x14(%ebp),%eax
f01060ee:	8b 00                	mov    (%eax),%eax
f01060f0:	ba 00 00 00 00       	mov    $0x0,%edx
f01060f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01060fe:	8d 40 04             	lea    0x4(%eax),%eax
f0106101:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106104:	b8 08 00 00 00       	mov    $0x8,%eax
f0106109:	eb 31                	jmp    f010613c <vprintfmt+0x428>
			putch('0', putdat);
f010610b:	83 ec 08             	sub    $0x8,%esp
f010610e:	53                   	push   %ebx
f010610f:	6a 30                	push   $0x30
f0106111:	ff d6                	call   *%esi
			putch('x', putdat);
f0106113:	83 c4 08             	add    $0x8,%esp
f0106116:	53                   	push   %ebx
f0106117:	6a 78                	push   $0x78
f0106119:	ff d6                	call   *%esi
			num = (unsigned long long)
f010611b:	8b 45 14             	mov    0x14(%ebp),%eax
f010611e:	8b 00                	mov    (%eax),%eax
f0106120:	ba 00 00 00 00       	mov    $0x0,%edx
f0106125:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106128:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f010612b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f010612e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106131:	8d 40 04             	lea    0x4(%eax),%eax
f0106134:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106137:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010613c:	83 ec 0c             	sub    $0xc,%esp
f010613f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f0106143:	52                   	push   %edx
f0106144:	ff 75 e0             	pushl  -0x20(%ebp)
f0106147:	50                   	push   %eax
f0106148:	ff 75 dc             	pushl  -0x24(%ebp)
f010614b:	ff 75 d8             	pushl  -0x28(%ebp)
f010614e:	89 da                	mov    %ebx,%edx
f0106150:	89 f0                	mov    %esi,%eax
f0106152:	e8 a4 fa ff ff       	call   f0105bfb <printnum>
			break;
f0106157:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f010615a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010615d:	83 c7 01             	add    $0x1,%edi
f0106160:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0106164:	83 f8 25             	cmp    $0x25,%eax
f0106167:	0f 84 be fb ff ff    	je     f0105d2b <vprintfmt+0x17>
			if (ch == '\0')
f010616d:	85 c0                	test   %eax,%eax
f010616f:	0f 84 28 01 00 00    	je     f010629d <vprintfmt+0x589>
			putch(ch, putdat);
f0106175:	83 ec 08             	sub    $0x8,%esp
f0106178:	53                   	push   %ebx
f0106179:	50                   	push   %eax
f010617a:	ff d6                	call   *%esi
f010617c:	83 c4 10             	add    $0x10,%esp
f010617f:	eb dc                	jmp    f010615d <vprintfmt+0x449>
	if (lflag >= 2)
f0106181:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0106185:	7f 26                	jg     f01061ad <vprintfmt+0x499>
	else if (lflag)
f0106187:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f010618b:	74 41                	je     f01061ce <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f010618d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106190:	8b 00                	mov    (%eax),%eax
f0106192:	ba 00 00 00 00       	mov    $0x0,%edx
f0106197:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010619a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010619d:	8b 45 14             	mov    0x14(%ebp),%eax
f01061a0:	8d 40 04             	lea    0x4(%eax),%eax
f01061a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061a6:	b8 10 00 00 00       	mov    $0x10,%eax
f01061ab:	eb 8f                	jmp    f010613c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01061ad:	8b 45 14             	mov    0x14(%ebp),%eax
f01061b0:	8b 50 04             	mov    0x4(%eax),%edx
f01061b3:	8b 00                	mov    (%eax),%eax
f01061b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01061bb:	8b 45 14             	mov    0x14(%ebp),%eax
f01061be:	8d 40 08             	lea    0x8(%eax),%eax
f01061c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061c4:	b8 10 00 00 00       	mov    $0x10,%eax
f01061c9:	e9 6e ff ff ff       	jmp    f010613c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f01061ce:	8b 45 14             	mov    0x14(%ebp),%eax
f01061d1:	8b 00                	mov    (%eax),%eax
f01061d3:	ba 00 00 00 00       	mov    $0x0,%edx
f01061d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061db:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01061de:	8b 45 14             	mov    0x14(%ebp),%eax
f01061e1:	8d 40 04             	lea    0x4(%eax),%eax
f01061e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061e7:	b8 10 00 00 00       	mov    $0x10,%eax
f01061ec:	e9 4b ff ff ff       	jmp    f010613c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f01061f1:	8b 45 14             	mov    0x14(%ebp),%eax
f01061f4:	83 c0 04             	add    $0x4,%eax
f01061f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01061fd:	8b 00                	mov    (%eax),%eax
f01061ff:	85 c0                	test   %eax,%eax
f0106201:	74 14                	je     f0106217 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f0106203:	8b 13                	mov    (%ebx),%edx
f0106205:	83 fa 7f             	cmp    $0x7f,%edx
f0106208:	7f 37                	jg     f0106241 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f010620a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f010620c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010620f:	89 45 14             	mov    %eax,0x14(%ebp)
f0106212:	e9 43 ff ff ff       	jmp    f010615a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f0106217:	b8 0a 00 00 00       	mov    $0xa,%eax
f010621c:	bf 89 9a 10 f0       	mov    $0xf0109a89,%edi
							putch(ch, putdat);
f0106221:	83 ec 08             	sub    $0x8,%esp
f0106224:	53                   	push   %ebx
f0106225:	50                   	push   %eax
f0106226:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0106228:	83 c7 01             	add    $0x1,%edi
f010622b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f010622f:	83 c4 10             	add    $0x10,%esp
f0106232:	85 c0                	test   %eax,%eax
f0106234:	75 eb                	jne    f0106221 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f0106236:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106239:	89 45 14             	mov    %eax,0x14(%ebp)
f010623c:	e9 19 ff ff ff       	jmp    f010615a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f0106241:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f0106243:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106248:	bf c1 9a 10 f0       	mov    $0xf0109ac1,%edi
							putch(ch, putdat);
f010624d:	83 ec 08             	sub    $0x8,%esp
f0106250:	53                   	push   %ebx
f0106251:	50                   	push   %eax
f0106252:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0106254:	83 c7 01             	add    $0x1,%edi
f0106257:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f010625b:	83 c4 10             	add    $0x10,%esp
f010625e:	85 c0                	test   %eax,%eax
f0106260:	75 eb                	jne    f010624d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f0106262:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106265:	89 45 14             	mov    %eax,0x14(%ebp)
f0106268:	e9 ed fe ff ff       	jmp    f010615a <vprintfmt+0x446>
			putch(ch, putdat);
f010626d:	83 ec 08             	sub    $0x8,%esp
f0106270:	53                   	push   %ebx
f0106271:	6a 25                	push   $0x25
f0106273:	ff d6                	call   *%esi
			break;
f0106275:	83 c4 10             	add    $0x10,%esp
f0106278:	e9 dd fe ff ff       	jmp    f010615a <vprintfmt+0x446>
			putch('%', putdat);
f010627d:	83 ec 08             	sub    $0x8,%esp
f0106280:	53                   	push   %ebx
f0106281:	6a 25                	push   $0x25
f0106283:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0106285:	83 c4 10             	add    $0x10,%esp
f0106288:	89 f8                	mov    %edi,%eax
f010628a:	eb 03                	jmp    f010628f <vprintfmt+0x57b>
f010628c:	83 e8 01             	sub    $0x1,%eax
f010628f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0106293:	75 f7                	jne    f010628c <vprintfmt+0x578>
f0106295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106298:	e9 bd fe ff ff       	jmp    f010615a <vprintfmt+0x446>
}
f010629d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01062a0:	5b                   	pop    %ebx
f01062a1:	5e                   	pop    %esi
f01062a2:	5f                   	pop    %edi
f01062a3:	5d                   	pop    %ebp
f01062a4:	c3                   	ret    

f01062a5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01062a5:	55                   	push   %ebp
f01062a6:	89 e5                	mov    %esp,%ebp
f01062a8:	83 ec 18             	sub    $0x18,%esp
f01062ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01062ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01062b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01062b4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01062b8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01062bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01062c2:	85 c0                	test   %eax,%eax
f01062c4:	74 26                	je     f01062ec <vsnprintf+0x47>
f01062c6:	85 d2                	test   %edx,%edx
f01062c8:	7e 22                	jle    f01062ec <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01062ca:	ff 75 14             	pushl  0x14(%ebp)
f01062cd:	ff 75 10             	pushl  0x10(%ebp)
f01062d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01062d3:	50                   	push   %eax
f01062d4:	68 da 5c 10 f0       	push   $0xf0105cda
f01062d9:	e8 36 fa ff ff       	call   f0105d14 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01062de:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01062e1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01062e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01062e7:	83 c4 10             	add    $0x10,%esp
}
f01062ea:	c9                   	leave  
f01062eb:	c3                   	ret    
		return -E_INVAL;
f01062ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01062f1:	eb f7                	jmp    f01062ea <vsnprintf+0x45>

f01062f3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01062f3:	55                   	push   %ebp
f01062f4:	89 e5                	mov    %esp,%ebp
f01062f6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01062f9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01062fc:	50                   	push   %eax
f01062fd:	ff 75 10             	pushl  0x10(%ebp)
f0106300:	ff 75 0c             	pushl  0xc(%ebp)
f0106303:	ff 75 08             	pushl  0x8(%ebp)
f0106306:	e8 9a ff ff ff       	call   f01062a5 <vsnprintf>
	va_end(ap);

	return rc;
}
f010630b:	c9                   	leave  
f010630c:	c3                   	ret    

f010630d <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010630d:	55                   	push   %ebp
f010630e:	89 e5                	mov    %esp,%ebp
f0106310:	57                   	push   %edi
f0106311:	56                   	push   %esi
f0106312:	53                   	push   %ebx
f0106313:	83 ec 0c             	sub    $0xc,%esp
f0106316:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106319:	85 c0                	test   %eax,%eax
f010631b:	74 11                	je     f010632e <readline+0x21>
		cprintf("%s", prompt);
f010631d:	83 ec 08             	sub    $0x8,%esp
f0106320:	50                   	push   %eax
f0106321:	68 dd 8d 10 f0       	push   $0xf0108ddd
f0106326:	e8 96 db ff ff       	call   f0103ec1 <cprintf>
f010632b:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010632e:	83 ec 0c             	sub    $0xc,%esp
f0106331:	6a 00                	push   $0x0
f0106333:	e8 a2 a4 ff ff       	call   f01007da <iscons>
f0106338:	89 c7                	mov    %eax,%edi
f010633a:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010633d:	be 00 00 00 00       	mov    $0x0,%esi
f0106342:	eb 57                	jmp    f010639b <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0106344:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106349:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010634c:	75 08                	jne    f0106356 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010634e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106351:	5b                   	pop    %ebx
f0106352:	5e                   	pop    %esi
f0106353:	5f                   	pop    %edi
f0106354:	5d                   	pop    %ebp
f0106355:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0106356:	83 ec 08             	sub    $0x8,%esp
f0106359:	53                   	push   %ebx
f010635a:	68 e8 9c 10 f0       	push   $0xf0109ce8
f010635f:	e8 5d db ff ff       	call   f0103ec1 <cprintf>
f0106364:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0106367:	b8 00 00 00 00       	mov    $0x0,%eax
f010636c:	eb e0                	jmp    f010634e <readline+0x41>
			if (echoing)
f010636e:	85 ff                	test   %edi,%edi
f0106370:	75 05                	jne    f0106377 <readline+0x6a>
			i--;
f0106372:	83 ee 01             	sub    $0x1,%esi
f0106375:	eb 24                	jmp    f010639b <readline+0x8e>
				cputchar('\b');
f0106377:	83 ec 0c             	sub    $0xc,%esp
f010637a:	6a 08                	push   $0x8
f010637c:	e8 38 a4 ff ff       	call   f01007b9 <cputchar>
f0106381:	83 c4 10             	add    $0x10,%esp
f0106384:	eb ec                	jmp    f0106372 <readline+0x65>
				cputchar(c);
f0106386:	83 ec 0c             	sub    $0xc,%esp
f0106389:	53                   	push   %ebx
f010638a:	e8 2a a4 ff ff       	call   f01007b9 <cputchar>
f010638f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0106392:	88 9e 80 ea 57 f0    	mov    %bl,-0xfa81580(%esi)
f0106398:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f010639b:	e8 29 a4 ff ff       	call   f01007c9 <getchar>
f01063a0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01063a2:	85 c0                	test   %eax,%eax
f01063a4:	78 9e                	js     f0106344 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01063a6:	83 f8 08             	cmp    $0x8,%eax
f01063a9:	0f 94 c2             	sete   %dl
f01063ac:	83 f8 7f             	cmp    $0x7f,%eax
f01063af:	0f 94 c0             	sete   %al
f01063b2:	08 c2                	or     %al,%dl
f01063b4:	74 04                	je     f01063ba <readline+0xad>
f01063b6:	85 f6                	test   %esi,%esi
f01063b8:	7f b4                	jg     f010636e <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01063ba:	83 fb 1f             	cmp    $0x1f,%ebx
f01063bd:	7e 0e                	jle    f01063cd <readline+0xc0>
f01063bf:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01063c5:	7f 06                	jg     f01063cd <readline+0xc0>
			if (echoing)
f01063c7:	85 ff                	test   %edi,%edi
f01063c9:	74 c7                	je     f0106392 <readline+0x85>
f01063cb:	eb b9                	jmp    f0106386 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f01063cd:	83 fb 0a             	cmp    $0xa,%ebx
f01063d0:	74 05                	je     f01063d7 <readline+0xca>
f01063d2:	83 fb 0d             	cmp    $0xd,%ebx
f01063d5:	75 c4                	jne    f010639b <readline+0x8e>
			if (echoing)
f01063d7:	85 ff                	test   %edi,%edi
f01063d9:	75 11                	jne    f01063ec <readline+0xdf>
			buf[i] = 0;
f01063db:	c6 86 80 ea 57 f0 00 	movb   $0x0,-0xfa81580(%esi)
			return buf;
f01063e2:	b8 80 ea 57 f0       	mov    $0xf057ea80,%eax
f01063e7:	e9 62 ff ff ff       	jmp    f010634e <readline+0x41>
				cputchar('\n');
f01063ec:	83 ec 0c             	sub    $0xc,%esp
f01063ef:	6a 0a                	push   $0xa
f01063f1:	e8 c3 a3 ff ff       	call   f01007b9 <cputchar>
f01063f6:	83 c4 10             	add    $0x10,%esp
f01063f9:	eb e0                	jmp    f01063db <readline+0xce>

f01063fb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01063fb:	55                   	push   %ebp
f01063fc:	89 e5                	mov    %esp,%ebp
f01063fe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106401:	b8 00 00 00 00       	mov    $0x0,%eax
f0106406:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010640a:	74 05                	je     f0106411 <strlen+0x16>
		n++;
f010640c:	83 c0 01             	add    $0x1,%eax
f010640f:	eb f5                	jmp    f0106406 <strlen+0xb>
	return n;
}
f0106411:	5d                   	pop    %ebp
f0106412:	c3                   	ret    

f0106413 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106413:	55                   	push   %ebp
f0106414:	89 e5                	mov    %esp,%ebp
f0106416:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106419:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010641c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106421:	39 c2                	cmp    %eax,%edx
f0106423:	74 0d                	je     f0106432 <strnlen+0x1f>
f0106425:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106429:	74 05                	je     f0106430 <strnlen+0x1d>
		n++;
f010642b:	83 c2 01             	add    $0x1,%edx
f010642e:	eb f1                	jmp    f0106421 <strnlen+0xe>
f0106430:	89 d0                	mov    %edx,%eax
	return n;
}
f0106432:	5d                   	pop    %ebp
f0106433:	c3                   	ret    

f0106434 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106434:	55                   	push   %ebp
f0106435:	89 e5                	mov    %esp,%ebp
f0106437:	53                   	push   %ebx
f0106438:	8b 45 08             	mov    0x8(%ebp),%eax
f010643b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010643e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106443:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106447:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f010644a:	83 c2 01             	add    $0x1,%edx
f010644d:	84 c9                	test   %cl,%cl
f010644f:	75 f2                	jne    f0106443 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0106451:	5b                   	pop    %ebx
f0106452:	5d                   	pop    %ebp
f0106453:	c3                   	ret    

f0106454 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106454:	55                   	push   %ebp
f0106455:	89 e5                	mov    %esp,%ebp
f0106457:	53                   	push   %ebx
f0106458:	83 ec 10             	sub    $0x10,%esp
f010645b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f010645e:	53                   	push   %ebx
f010645f:	e8 97 ff ff ff       	call   f01063fb <strlen>
f0106464:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0106467:	ff 75 0c             	pushl  0xc(%ebp)
f010646a:	01 d8                	add    %ebx,%eax
f010646c:	50                   	push   %eax
f010646d:	e8 c2 ff ff ff       	call   f0106434 <strcpy>
	return dst;
}
f0106472:	89 d8                	mov    %ebx,%eax
f0106474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106477:	c9                   	leave  
f0106478:	c3                   	ret    

f0106479 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106479:	55                   	push   %ebp
f010647a:	89 e5                	mov    %esp,%ebp
f010647c:	56                   	push   %esi
f010647d:	53                   	push   %ebx
f010647e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106481:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106484:	89 c6                	mov    %eax,%esi
f0106486:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106489:	89 c2                	mov    %eax,%edx
f010648b:	39 f2                	cmp    %esi,%edx
f010648d:	74 11                	je     f01064a0 <strncpy+0x27>
		*dst++ = *src;
f010648f:	83 c2 01             	add    $0x1,%edx
f0106492:	0f b6 19             	movzbl (%ecx),%ebx
f0106495:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0106498:	80 fb 01             	cmp    $0x1,%bl
f010649b:	83 d9 ff             	sbb    $0xffffffff,%ecx
f010649e:	eb eb                	jmp    f010648b <strncpy+0x12>
	}
	return ret;
}
f01064a0:	5b                   	pop    %ebx
f01064a1:	5e                   	pop    %esi
f01064a2:	5d                   	pop    %ebp
f01064a3:	c3                   	ret    

f01064a4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01064a4:	55                   	push   %ebp
f01064a5:	89 e5                	mov    %esp,%ebp
f01064a7:	56                   	push   %esi
f01064a8:	53                   	push   %ebx
f01064a9:	8b 75 08             	mov    0x8(%ebp),%esi
f01064ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01064af:	8b 55 10             	mov    0x10(%ebp),%edx
f01064b2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01064b4:	85 d2                	test   %edx,%edx
f01064b6:	74 21                	je     f01064d9 <strlcpy+0x35>
f01064b8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01064bc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01064be:	39 c2                	cmp    %eax,%edx
f01064c0:	74 14                	je     f01064d6 <strlcpy+0x32>
f01064c2:	0f b6 19             	movzbl (%ecx),%ebx
f01064c5:	84 db                	test   %bl,%bl
f01064c7:	74 0b                	je     f01064d4 <strlcpy+0x30>
			*dst++ = *src++;
f01064c9:	83 c1 01             	add    $0x1,%ecx
f01064cc:	83 c2 01             	add    $0x1,%edx
f01064cf:	88 5a ff             	mov    %bl,-0x1(%edx)
f01064d2:	eb ea                	jmp    f01064be <strlcpy+0x1a>
f01064d4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01064d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01064d9:	29 f0                	sub    %esi,%eax
}
f01064db:	5b                   	pop    %ebx
f01064dc:	5e                   	pop    %esi
f01064dd:	5d                   	pop    %ebp
f01064de:	c3                   	ret    

f01064df <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01064df:	55                   	push   %ebp
f01064e0:	89 e5                	mov    %esp,%ebp
f01064e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01064e5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01064e8:	0f b6 01             	movzbl (%ecx),%eax
f01064eb:	84 c0                	test   %al,%al
f01064ed:	74 0c                	je     f01064fb <strcmp+0x1c>
f01064ef:	3a 02                	cmp    (%edx),%al
f01064f1:	75 08                	jne    f01064fb <strcmp+0x1c>
		p++, q++;
f01064f3:	83 c1 01             	add    $0x1,%ecx
f01064f6:	83 c2 01             	add    $0x1,%edx
f01064f9:	eb ed                	jmp    f01064e8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f01064fb:	0f b6 c0             	movzbl %al,%eax
f01064fe:	0f b6 12             	movzbl (%edx),%edx
f0106501:	29 d0                	sub    %edx,%eax
}
f0106503:	5d                   	pop    %ebp
f0106504:	c3                   	ret    

f0106505 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106505:	55                   	push   %ebp
f0106506:	89 e5                	mov    %esp,%ebp
f0106508:	53                   	push   %ebx
f0106509:	8b 45 08             	mov    0x8(%ebp),%eax
f010650c:	8b 55 0c             	mov    0xc(%ebp),%edx
f010650f:	89 c3                	mov    %eax,%ebx
f0106511:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106514:	eb 06                	jmp    f010651c <strncmp+0x17>
		n--, p++, q++;
f0106516:	83 c0 01             	add    $0x1,%eax
f0106519:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f010651c:	39 d8                	cmp    %ebx,%eax
f010651e:	74 16                	je     f0106536 <strncmp+0x31>
f0106520:	0f b6 08             	movzbl (%eax),%ecx
f0106523:	84 c9                	test   %cl,%cl
f0106525:	74 04                	je     f010652b <strncmp+0x26>
f0106527:	3a 0a                	cmp    (%edx),%cl
f0106529:	74 eb                	je     f0106516 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010652b:	0f b6 00             	movzbl (%eax),%eax
f010652e:	0f b6 12             	movzbl (%edx),%edx
f0106531:	29 d0                	sub    %edx,%eax
}
f0106533:	5b                   	pop    %ebx
f0106534:	5d                   	pop    %ebp
f0106535:	c3                   	ret    
		return 0;
f0106536:	b8 00 00 00 00       	mov    $0x0,%eax
f010653b:	eb f6                	jmp    f0106533 <strncmp+0x2e>

f010653d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010653d:	55                   	push   %ebp
f010653e:	89 e5                	mov    %esp,%ebp
f0106540:	8b 45 08             	mov    0x8(%ebp),%eax
f0106543:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106547:	0f b6 10             	movzbl (%eax),%edx
f010654a:	84 d2                	test   %dl,%dl
f010654c:	74 09                	je     f0106557 <strchr+0x1a>
		if (*s == c)
f010654e:	38 ca                	cmp    %cl,%dl
f0106550:	74 0a                	je     f010655c <strchr+0x1f>
	for (; *s; s++)
f0106552:	83 c0 01             	add    $0x1,%eax
f0106555:	eb f0                	jmp    f0106547 <strchr+0xa>
			return (char *) s;
	return 0;
f0106557:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010655c:	5d                   	pop    %ebp
f010655d:	c3                   	ret    

f010655e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010655e:	55                   	push   %ebp
f010655f:	89 e5                	mov    %esp,%ebp
f0106561:	8b 45 08             	mov    0x8(%ebp),%eax
f0106564:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106568:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f010656b:	38 ca                	cmp    %cl,%dl
f010656d:	74 09                	je     f0106578 <strfind+0x1a>
f010656f:	84 d2                	test   %dl,%dl
f0106571:	74 05                	je     f0106578 <strfind+0x1a>
	for (; *s; s++)
f0106573:	83 c0 01             	add    $0x1,%eax
f0106576:	eb f0                	jmp    f0106568 <strfind+0xa>
			break;
	return (char *) s;
}
f0106578:	5d                   	pop    %ebp
f0106579:	c3                   	ret    

f010657a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f010657a:	55                   	push   %ebp
f010657b:	89 e5                	mov    %esp,%ebp
f010657d:	57                   	push   %edi
f010657e:	56                   	push   %esi
f010657f:	53                   	push   %ebx
f0106580:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106583:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0106586:	85 c9                	test   %ecx,%ecx
f0106588:	74 31                	je     f01065bb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f010658a:	89 f8                	mov    %edi,%eax
f010658c:	09 c8                	or     %ecx,%eax
f010658e:	a8 03                	test   $0x3,%al
f0106590:	75 23                	jne    f01065b5 <memset+0x3b>
		c &= 0xFF;
f0106592:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0106596:	89 d3                	mov    %edx,%ebx
f0106598:	c1 e3 08             	shl    $0x8,%ebx
f010659b:	89 d0                	mov    %edx,%eax
f010659d:	c1 e0 18             	shl    $0x18,%eax
f01065a0:	89 d6                	mov    %edx,%esi
f01065a2:	c1 e6 10             	shl    $0x10,%esi
f01065a5:	09 f0                	or     %esi,%eax
f01065a7:	09 c2                	or     %eax,%edx
f01065a9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01065ab:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01065ae:	89 d0                	mov    %edx,%eax
f01065b0:	fc                   	cld    
f01065b1:	f3 ab                	rep stos %eax,%es:(%edi)
f01065b3:	eb 06                	jmp    f01065bb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01065b5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01065b8:	fc                   	cld    
f01065b9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01065bb:	89 f8                	mov    %edi,%eax
f01065bd:	5b                   	pop    %ebx
f01065be:	5e                   	pop    %esi
f01065bf:	5f                   	pop    %edi
f01065c0:	5d                   	pop    %ebp
f01065c1:	c3                   	ret    

f01065c2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01065c2:	55                   	push   %ebp
f01065c3:	89 e5                	mov    %esp,%ebp
f01065c5:	57                   	push   %edi
f01065c6:	56                   	push   %esi
f01065c7:	8b 45 08             	mov    0x8(%ebp),%eax
f01065ca:	8b 75 0c             	mov    0xc(%ebp),%esi
f01065cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01065d0:	39 c6                	cmp    %eax,%esi
f01065d2:	73 32                	jae    f0106606 <memmove+0x44>
f01065d4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01065d7:	39 c2                	cmp    %eax,%edx
f01065d9:	76 2b                	jbe    f0106606 <memmove+0x44>
		s += n;
		d += n;
f01065db:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01065de:	89 fe                	mov    %edi,%esi
f01065e0:	09 ce                	or     %ecx,%esi
f01065e2:	09 d6                	or     %edx,%esi
f01065e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01065ea:	75 0e                	jne    f01065fa <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f01065ec:	83 ef 04             	sub    $0x4,%edi
f01065ef:	8d 72 fc             	lea    -0x4(%edx),%esi
f01065f2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f01065f5:	fd                   	std    
f01065f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01065f8:	eb 09                	jmp    f0106603 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01065fa:	83 ef 01             	sub    $0x1,%edi
f01065fd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0106600:	fd                   	std    
f0106601:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106603:	fc                   	cld    
f0106604:	eb 1a                	jmp    f0106620 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106606:	89 c2                	mov    %eax,%edx
f0106608:	09 ca                	or     %ecx,%edx
f010660a:	09 f2                	or     %esi,%edx
f010660c:	f6 c2 03             	test   $0x3,%dl
f010660f:	75 0a                	jne    f010661b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106611:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0106614:	89 c7                	mov    %eax,%edi
f0106616:	fc                   	cld    
f0106617:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106619:	eb 05                	jmp    f0106620 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f010661b:	89 c7                	mov    %eax,%edi
f010661d:	fc                   	cld    
f010661e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106620:	5e                   	pop    %esi
f0106621:	5f                   	pop    %edi
f0106622:	5d                   	pop    %ebp
f0106623:	c3                   	ret    

f0106624 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106624:	55                   	push   %ebp
f0106625:	89 e5                	mov    %esp,%ebp
f0106627:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f010662a:	ff 75 10             	pushl  0x10(%ebp)
f010662d:	ff 75 0c             	pushl  0xc(%ebp)
f0106630:	ff 75 08             	pushl  0x8(%ebp)
f0106633:	e8 8a ff ff ff       	call   f01065c2 <memmove>
}
f0106638:	c9                   	leave  
f0106639:	c3                   	ret    

f010663a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010663a:	55                   	push   %ebp
f010663b:	89 e5                	mov    %esp,%ebp
f010663d:	56                   	push   %esi
f010663e:	53                   	push   %ebx
f010663f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106642:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106645:	89 c6                	mov    %eax,%esi
f0106647:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010664a:	39 f0                	cmp    %esi,%eax
f010664c:	74 1c                	je     f010666a <memcmp+0x30>
		if (*s1 != *s2)
f010664e:	0f b6 08             	movzbl (%eax),%ecx
f0106651:	0f b6 1a             	movzbl (%edx),%ebx
f0106654:	38 d9                	cmp    %bl,%cl
f0106656:	75 08                	jne    f0106660 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0106658:	83 c0 01             	add    $0x1,%eax
f010665b:	83 c2 01             	add    $0x1,%edx
f010665e:	eb ea                	jmp    f010664a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0106660:	0f b6 c1             	movzbl %cl,%eax
f0106663:	0f b6 db             	movzbl %bl,%ebx
f0106666:	29 d8                	sub    %ebx,%eax
f0106668:	eb 05                	jmp    f010666f <memcmp+0x35>
	}

	return 0;
f010666a:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010666f:	5b                   	pop    %ebx
f0106670:	5e                   	pop    %esi
f0106671:	5d                   	pop    %ebp
f0106672:	c3                   	ret    

f0106673 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0106673:	55                   	push   %ebp
f0106674:	89 e5                	mov    %esp,%ebp
f0106676:	8b 45 08             	mov    0x8(%ebp),%eax
f0106679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f010667c:	89 c2                	mov    %eax,%edx
f010667e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0106681:	39 d0                	cmp    %edx,%eax
f0106683:	73 09                	jae    f010668e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106685:	38 08                	cmp    %cl,(%eax)
f0106687:	74 05                	je     f010668e <memfind+0x1b>
	for (; s < ends; s++)
f0106689:	83 c0 01             	add    $0x1,%eax
f010668c:	eb f3                	jmp    f0106681 <memfind+0xe>
			break;
	return (void *) s;
}
f010668e:	5d                   	pop    %ebp
f010668f:	c3                   	ret    

f0106690 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106690:	55                   	push   %ebp
f0106691:	89 e5                	mov    %esp,%ebp
f0106693:	57                   	push   %edi
f0106694:	56                   	push   %esi
f0106695:	53                   	push   %ebx
f0106696:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106699:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010669c:	eb 03                	jmp    f01066a1 <strtol+0x11>
		s++;
f010669e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01066a1:	0f b6 01             	movzbl (%ecx),%eax
f01066a4:	3c 20                	cmp    $0x20,%al
f01066a6:	74 f6                	je     f010669e <strtol+0xe>
f01066a8:	3c 09                	cmp    $0x9,%al
f01066aa:	74 f2                	je     f010669e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01066ac:	3c 2b                	cmp    $0x2b,%al
f01066ae:	74 2a                	je     f01066da <strtol+0x4a>
	int neg = 0;
f01066b0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01066b5:	3c 2d                	cmp    $0x2d,%al
f01066b7:	74 2b                	je     f01066e4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01066b9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01066bf:	75 0f                	jne    f01066d0 <strtol+0x40>
f01066c1:	80 39 30             	cmpb   $0x30,(%ecx)
f01066c4:	74 28                	je     f01066ee <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01066c6:	85 db                	test   %ebx,%ebx
f01066c8:	b8 0a 00 00 00       	mov    $0xa,%eax
f01066cd:	0f 44 d8             	cmove  %eax,%ebx
f01066d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01066d5:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01066d8:	eb 50                	jmp    f010672a <strtol+0x9a>
		s++;
f01066da:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01066dd:	bf 00 00 00 00       	mov    $0x0,%edi
f01066e2:	eb d5                	jmp    f01066b9 <strtol+0x29>
		s++, neg = 1;
f01066e4:	83 c1 01             	add    $0x1,%ecx
f01066e7:	bf 01 00 00 00       	mov    $0x1,%edi
f01066ec:	eb cb                	jmp    f01066b9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01066ee:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f01066f2:	74 0e                	je     f0106702 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f01066f4:	85 db                	test   %ebx,%ebx
f01066f6:	75 d8                	jne    f01066d0 <strtol+0x40>
		s++, base = 8;
f01066f8:	83 c1 01             	add    $0x1,%ecx
f01066fb:	bb 08 00 00 00       	mov    $0x8,%ebx
f0106700:	eb ce                	jmp    f01066d0 <strtol+0x40>
		s += 2, base = 16;
f0106702:	83 c1 02             	add    $0x2,%ecx
f0106705:	bb 10 00 00 00       	mov    $0x10,%ebx
f010670a:	eb c4                	jmp    f01066d0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f010670c:	8d 72 9f             	lea    -0x61(%edx),%esi
f010670f:	89 f3                	mov    %esi,%ebx
f0106711:	80 fb 19             	cmp    $0x19,%bl
f0106714:	77 29                	ja     f010673f <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106716:	0f be d2             	movsbl %dl,%edx
f0106719:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010671c:	3b 55 10             	cmp    0x10(%ebp),%edx
f010671f:	7d 30                	jge    f0106751 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0106721:	83 c1 01             	add    $0x1,%ecx
f0106724:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106728:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f010672a:	0f b6 11             	movzbl (%ecx),%edx
f010672d:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106730:	89 f3                	mov    %esi,%ebx
f0106732:	80 fb 09             	cmp    $0x9,%bl
f0106735:	77 d5                	ja     f010670c <strtol+0x7c>
			dig = *s - '0';
f0106737:	0f be d2             	movsbl %dl,%edx
f010673a:	83 ea 30             	sub    $0x30,%edx
f010673d:	eb dd                	jmp    f010671c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f010673f:	8d 72 bf             	lea    -0x41(%edx),%esi
f0106742:	89 f3                	mov    %esi,%ebx
f0106744:	80 fb 19             	cmp    $0x19,%bl
f0106747:	77 08                	ja     f0106751 <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106749:	0f be d2             	movsbl %dl,%edx
f010674c:	83 ea 37             	sub    $0x37,%edx
f010674f:	eb cb                	jmp    f010671c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f0106751:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106755:	74 05                	je     f010675c <strtol+0xcc>
		*endptr = (char *) s;
f0106757:	8b 75 0c             	mov    0xc(%ebp),%esi
f010675a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f010675c:	89 c2                	mov    %eax,%edx
f010675e:	f7 da                	neg    %edx
f0106760:	85 ff                	test   %edi,%edi
f0106762:	0f 45 c2             	cmovne %edx,%eax
}
f0106765:	5b                   	pop    %ebx
f0106766:	5e                   	pop    %esi
f0106767:	5f                   	pop    %edi
f0106768:	5d                   	pop    %ebp
f0106769:	c3                   	ret    
f010676a:	66 90                	xchg   %ax,%ax

f010676c <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f010676c:	fa                   	cli    

	xorw    %ax, %ax
f010676d:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f010676f:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106771:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106773:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106775:	0f 01 16             	lgdtl  (%esi)
f0106778:	7c 70                	jl     f01067ea <gdtdesc+0x2>
	movl    %cr0, %eax
f010677a:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f010677d:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106781:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106784:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f010678a:	08 00                	or     %al,(%eax)

f010678c <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f010678c:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106790:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106792:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106794:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106796:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f010679a:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f010679c:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f010679e:	b8 00 70 12 00       	mov    $0x127000,%eax
	movl    %eax, %cr3
f01067a3:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f01067a6:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f01067a9:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f01067ac:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f01067af:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01067b2:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01067b7:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01067ba:	8b 25 a4 fe 57 f0    	mov    0xf057fea4,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01067c0:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01067c5:	b8 eb 01 10 f0       	mov    $0xf01001eb,%eax
	call    *%eax
f01067ca:	ff d0                	call   *%eax

f01067cc <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f01067cc:	eb fe                	jmp    f01067cc <spin>
f01067ce:	66 90                	xchg   %ax,%ax

f01067d0 <gdt>:
	...
f01067d8:	ff                   	(bad)  
f01067d9:	ff 00                	incl   (%eax)
f01067db:	00 00                	add    %al,(%eax)
f01067dd:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f01067e4:	00                   	.byte 0x0
f01067e5:	92                   	xchg   %eax,%edx
f01067e6:	cf                   	iret   
	...

f01067e8 <gdtdesc>:
f01067e8:	17                   	pop    %ss
f01067e9:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f01067ee <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f01067ee:	90                   	nop

f01067ef <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f01067ef:	55                   	push   %ebp
f01067f0:	89 e5                	mov    %esp,%ebp
f01067f2:	57                   	push   %edi
f01067f3:	56                   	push   %esi
f01067f4:	53                   	push   %ebx
f01067f5:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f01067f8:	8b 0d a8 fe 57 f0    	mov    0xf057fea8,%ecx
f01067fe:	89 c3                	mov    %eax,%ebx
f0106800:	c1 eb 0c             	shr    $0xc,%ebx
f0106803:	39 cb                	cmp    %ecx,%ebx
f0106805:	73 1a                	jae    f0106821 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0106807:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f010680d:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106810:	89 f8                	mov    %edi,%eax
f0106812:	c1 e8 0c             	shr    $0xc,%eax
f0106815:	39 c8                	cmp    %ecx,%eax
f0106817:	73 1a                	jae    f0106833 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106819:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f010681f:	eb 27                	jmp    f0106848 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106821:	50                   	push   %eax
f0106822:	68 14 7c 10 f0       	push   $0xf0107c14
f0106827:	6a 57                	push   $0x57
f0106829:	68 85 9e 10 f0       	push   $0xf0109e85
f010682e:	e8 16 98 ff ff       	call   f0100049 <_panic>
f0106833:	57                   	push   %edi
f0106834:	68 14 7c 10 f0       	push   $0xf0107c14
f0106839:	6a 57                	push   $0x57
f010683b:	68 85 9e 10 f0       	push   $0xf0109e85
f0106840:	e8 04 98 ff ff       	call   f0100049 <_panic>
f0106845:	83 c3 10             	add    $0x10,%ebx
f0106848:	39 fb                	cmp    %edi,%ebx
f010684a:	73 30                	jae    f010687c <mpsearch1+0x8d>
f010684c:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010684e:	83 ec 04             	sub    $0x4,%esp
f0106851:	6a 04                	push   $0x4
f0106853:	68 95 9e 10 f0       	push   $0xf0109e95
f0106858:	53                   	push   %ebx
f0106859:	e8 dc fd ff ff       	call   f010663a <memcmp>
f010685e:	83 c4 10             	add    $0x10,%esp
f0106861:	85 c0                	test   %eax,%eax
f0106863:	75 e0                	jne    f0106845 <mpsearch1+0x56>
f0106865:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0106867:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f010686a:	0f b6 0a             	movzbl (%edx),%ecx
f010686d:	01 c8                	add    %ecx,%eax
f010686f:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0106872:	39 f2                	cmp    %esi,%edx
f0106874:	75 f4                	jne    f010686a <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106876:	84 c0                	test   %al,%al
f0106878:	75 cb                	jne    f0106845 <mpsearch1+0x56>
f010687a:	eb 05                	jmp    f0106881 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f010687c:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0106881:	89 d8                	mov    %ebx,%eax
f0106883:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106886:	5b                   	pop    %ebx
f0106887:	5e                   	pop    %esi
f0106888:	5f                   	pop    %edi
f0106889:	5d                   	pop    %ebp
f010688a:	c3                   	ret    

f010688b <mp_init>:
	return conf;
}

void
mp_init(void)
{
f010688b:	55                   	push   %ebp
f010688c:	89 e5                	mov    %esp,%ebp
f010688e:	57                   	push   %edi
f010688f:	56                   	push   %esi
f0106890:	53                   	push   %ebx
f0106891:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106894:	c7 05 c0 03 58 f0 20 	movl   $0xf0580020,0xf05803c0
f010689b:	00 58 f0 
	if (PGNUM(pa) >= npages)
f010689e:	83 3d a8 fe 57 f0 00 	cmpl   $0x0,0xf057fea8
f01068a5:	0f 84 a3 00 00 00    	je     f010694e <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01068ab:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01068b2:	85 c0                	test   %eax,%eax
f01068b4:	0f 84 aa 00 00 00    	je     f0106964 <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f01068ba:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01068bd:	ba 00 04 00 00       	mov    $0x400,%edx
f01068c2:	e8 28 ff ff ff       	call   f01067ef <mpsearch1>
f01068c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01068ca:	85 c0                	test   %eax,%eax
f01068cc:	75 1a                	jne    f01068e8 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f01068ce:	ba 00 00 01 00       	mov    $0x10000,%edx
f01068d3:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f01068d8:	e8 12 ff ff ff       	call   f01067ef <mpsearch1>
f01068dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f01068e0:	85 c0                	test   %eax,%eax
f01068e2:	0f 84 31 02 00 00    	je     f0106b19 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f01068e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01068eb:	8b 58 04             	mov    0x4(%eax),%ebx
f01068ee:	85 db                	test   %ebx,%ebx
f01068f0:	0f 84 97 00 00 00    	je     f010698d <mp_init+0x102>
f01068f6:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f01068fa:	0f 85 8d 00 00 00    	jne    f010698d <mp_init+0x102>
f0106900:	89 d8                	mov    %ebx,%eax
f0106902:	c1 e8 0c             	shr    $0xc,%eax
f0106905:	3b 05 a8 fe 57 f0    	cmp    0xf057fea8,%eax
f010690b:	0f 83 91 00 00 00    	jae    f01069a2 <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106911:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0106917:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106919:	83 ec 04             	sub    $0x4,%esp
f010691c:	6a 04                	push   $0x4
f010691e:	68 9a 9e 10 f0       	push   $0xf0109e9a
f0106923:	53                   	push   %ebx
f0106924:	e8 11 fd ff ff       	call   f010663a <memcmp>
f0106929:	83 c4 10             	add    $0x10,%esp
f010692c:	85 c0                	test   %eax,%eax
f010692e:	0f 85 83 00 00 00    	jne    f01069b7 <mp_init+0x12c>
f0106934:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106938:	01 df                	add    %ebx,%edi
	sum = 0;
f010693a:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f010693c:	39 fb                	cmp    %edi,%ebx
f010693e:	0f 84 88 00 00 00    	je     f01069cc <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f0106944:	0f b6 0b             	movzbl (%ebx),%ecx
f0106947:	01 ca                	add    %ecx,%edx
f0106949:	83 c3 01             	add    $0x1,%ebx
f010694c:	eb ee                	jmp    f010693c <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010694e:	68 00 04 00 00       	push   $0x400
f0106953:	68 14 7c 10 f0       	push   $0xf0107c14
f0106958:	6a 6f                	push   $0x6f
f010695a:	68 85 9e 10 f0       	push   $0xf0109e85
f010695f:	e8 e5 96 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0106964:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f010696b:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f010696e:	2d 00 04 00 00       	sub    $0x400,%eax
f0106973:	ba 00 04 00 00       	mov    $0x400,%edx
f0106978:	e8 72 fe ff ff       	call   f01067ef <mpsearch1>
f010697d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106980:	85 c0                	test   %eax,%eax
f0106982:	0f 85 60 ff ff ff    	jne    f01068e8 <mp_init+0x5d>
f0106988:	e9 41 ff ff ff       	jmp    f01068ce <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f010698d:	83 ec 0c             	sub    $0xc,%esp
f0106990:	68 f8 9c 10 f0       	push   $0xf0109cf8
f0106995:	e8 27 d5 ff ff       	call   f0103ec1 <cprintf>
f010699a:	83 c4 10             	add    $0x10,%esp
f010699d:	e9 77 01 00 00       	jmp    f0106b19 <mp_init+0x28e>
f01069a2:	53                   	push   %ebx
f01069a3:	68 14 7c 10 f0       	push   $0xf0107c14
f01069a8:	68 90 00 00 00       	push   $0x90
f01069ad:	68 85 9e 10 f0       	push   $0xf0109e85
f01069b2:	e8 92 96 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01069b7:	83 ec 0c             	sub    $0xc,%esp
f01069ba:	68 28 9d 10 f0       	push   $0xf0109d28
f01069bf:	e8 fd d4 ff ff       	call   f0103ec1 <cprintf>
f01069c4:	83 c4 10             	add    $0x10,%esp
f01069c7:	e9 4d 01 00 00       	jmp    f0106b19 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f01069cc:	84 d2                	test   %dl,%dl
f01069ce:	75 16                	jne    f01069e6 <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f01069d0:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f01069d4:	80 fa 01             	cmp    $0x1,%dl
f01069d7:	74 05                	je     f01069de <mp_init+0x153>
f01069d9:	80 fa 04             	cmp    $0x4,%dl
f01069dc:	75 1d                	jne    f01069fb <mp_init+0x170>
f01069de:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f01069e2:	01 d9                	add    %ebx,%ecx
f01069e4:	eb 36                	jmp    f0106a1c <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f01069e6:	83 ec 0c             	sub    $0xc,%esp
f01069e9:	68 5c 9d 10 f0       	push   $0xf0109d5c
f01069ee:	e8 ce d4 ff ff       	call   f0103ec1 <cprintf>
f01069f3:	83 c4 10             	add    $0x10,%esp
f01069f6:	e9 1e 01 00 00       	jmp    f0106b19 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f01069fb:	83 ec 08             	sub    $0x8,%esp
f01069fe:	0f b6 d2             	movzbl %dl,%edx
f0106a01:	52                   	push   %edx
f0106a02:	68 80 9d 10 f0       	push   $0xf0109d80
f0106a07:	e8 b5 d4 ff ff       	call   f0103ec1 <cprintf>
f0106a0c:	83 c4 10             	add    $0x10,%esp
f0106a0f:	e9 05 01 00 00       	jmp    f0106b19 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106a14:	0f b6 13             	movzbl (%ebx),%edx
f0106a17:	01 d0                	add    %edx,%eax
f0106a19:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106a1c:	39 d9                	cmp    %ebx,%ecx
f0106a1e:	75 f4                	jne    f0106a14 <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106a20:	02 46 2a             	add    0x2a(%esi),%al
f0106a23:	75 1c                	jne    f0106a41 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106a25:	c7 05 00 00 58 f0 01 	movl   $0x1,0xf0580000
f0106a2c:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106a2f:	8b 46 24             	mov    0x24(%esi),%eax
f0106a32:	a3 00 10 5c f0       	mov    %eax,0xf05c1000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106a37:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106a3a:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106a3f:	eb 4d                	jmp    f0106a8e <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106a41:	83 ec 0c             	sub    $0xc,%esp
f0106a44:	68 a0 9d 10 f0       	push   $0xf0109da0
f0106a49:	e8 73 d4 ff ff       	call   f0103ec1 <cprintf>
f0106a4e:	83 c4 10             	add    $0x10,%esp
f0106a51:	e9 c3 00 00 00       	jmp    f0106b19 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106a56:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106a5a:	74 11                	je     f0106a6d <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106a5c:	6b 05 c4 03 58 f0 74 	imul   $0x74,0xf05803c4,%eax
f0106a63:	05 20 00 58 f0       	add    $0xf0580020,%eax
f0106a68:	a3 c0 03 58 f0       	mov    %eax,0xf05803c0
			if (ncpu < NCPU) {
f0106a6d:	a1 c4 03 58 f0       	mov    0xf05803c4,%eax
f0106a72:	83 f8 07             	cmp    $0x7,%eax
f0106a75:	7f 2f                	jg     f0106aa6 <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0106a77:	6b d0 74             	imul   $0x74,%eax,%edx
f0106a7a:	88 82 20 00 58 f0    	mov    %al,-0xfa7ffe0(%edx)
				ncpu++;
f0106a80:	83 c0 01             	add    $0x1,%eax
f0106a83:	a3 c4 03 58 f0       	mov    %eax,0xf05803c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106a88:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106a8b:	83 c3 01             	add    $0x1,%ebx
f0106a8e:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0106a92:	39 d8                	cmp    %ebx,%eax
f0106a94:	76 4b                	jbe    f0106ae1 <mp_init+0x256>
		switch (*p) {
f0106a96:	0f b6 07             	movzbl (%edi),%eax
f0106a99:	84 c0                	test   %al,%al
f0106a9b:	74 b9                	je     f0106a56 <mp_init+0x1cb>
f0106a9d:	3c 04                	cmp    $0x4,%al
f0106a9f:	77 1c                	ja     f0106abd <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106aa1:	83 c7 08             	add    $0x8,%edi
			continue;
f0106aa4:	eb e5                	jmp    f0106a8b <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106aa6:	83 ec 08             	sub    $0x8,%esp
f0106aa9:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106aad:	50                   	push   %eax
f0106aae:	68 d0 9d 10 f0       	push   $0xf0109dd0
f0106ab3:	e8 09 d4 ff ff       	call   f0103ec1 <cprintf>
f0106ab8:	83 c4 10             	add    $0x10,%esp
f0106abb:	eb cb                	jmp    f0106a88 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106abd:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106ac0:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106ac3:	50                   	push   %eax
f0106ac4:	68 f8 9d 10 f0       	push   $0xf0109df8
f0106ac9:	e8 f3 d3 ff ff       	call   f0103ec1 <cprintf>
			ismp = 0;
f0106ace:	c7 05 00 00 58 f0 00 	movl   $0x0,0xf0580000
f0106ad5:	00 00 00 
			i = conf->entry;
f0106ad8:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106adc:	83 c4 10             	add    $0x10,%esp
f0106adf:	eb aa                	jmp    f0106a8b <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106ae1:	a1 c0 03 58 f0       	mov    0xf05803c0,%eax
f0106ae6:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106aed:	83 3d 00 00 58 f0 00 	cmpl   $0x0,0xf0580000
f0106af4:	74 2b                	je     f0106b21 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106af6:	83 ec 04             	sub    $0x4,%esp
f0106af9:	ff 35 c4 03 58 f0    	pushl  0xf05803c4
f0106aff:	0f b6 00             	movzbl (%eax),%eax
f0106b02:	50                   	push   %eax
f0106b03:	68 9f 9e 10 f0       	push   $0xf0109e9f
f0106b08:	e8 b4 d3 ff ff       	call   f0103ec1 <cprintf>

	if (mp->imcrp) {
f0106b0d:	83 c4 10             	add    $0x10,%esp
f0106b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106b13:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106b17:	75 2e                	jne    f0106b47 <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106b1c:	5b                   	pop    %ebx
f0106b1d:	5e                   	pop    %esi
f0106b1e:	5f                   	pop    %edi
f0106b1f:	5d                   	pop    %ebp
f0106b20:	c3                   	ret    
		ncpu = 1;
f0106b21:	c7 05 c4 03 58 f0 01 	movl   $0x1,0xf05803c4
f0106b28:	00 00 00 
		lapicaddr = 0;
f0106b2b:	c7 05 00 10 5c f0 00 	movl   $0x0,0xf05c1000
f0106b32:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106b35:	83 ec 0c             	sub    $0xc,%esp
f0106b38:	68 18 9e 10 f0       	push   $0xf0109e18
f0106b3d:	e8 7f d3 ff ff       	call   f0103ec1 <cprintf>
		return;
f0106b42:	83 c4 10             	add    $0x10,%esp
f0106b45:	eb d2                	jmp    f0106b19 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106b47:	83 ec 0c             	sub    $0xc,%esp
f0106b4a:	68 44 9e 10 f0       	push   $0xf0109e44
f0106b4f:	e8 6d d3 ff ff       	call   f0103ec1 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106b54:	b8 70 00 00 00       	mov    $0x70,%eax
f0106b59:	ba 22 00 00 00       	mov    $0x22,%edx
f0106b5e:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106b5f:	ba 23 00 00 00       	mov    $0x23,%edx
f0106b64:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106b65:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106b68:	ee                   	out    %al,(%dx)
f0106b69:	83 c4 10             	add    $0x10,%esp
f0106b6c:	eb ab                	jmp    f0106b19 <mp_init+0x28e>

f0106b6e <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106b6e:	8b 0d 04 10 5c f0    	mov    0xf05c1004,%ecx
f0106b74:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106b77:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106b79:	a1 04 10 5c f0       	mov    0xf05c1004,%eax
f0106b7e:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106b81:	c3                   	ret    

f0106b82 <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f0106b82:	8b 15 04 10 5c f0    	mov    0xf05c1004,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f0106b88:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f0106b8d:	85 d2                	test   %edx,%edx
f0106b8f:	74 06                	je     f0106b97 <cpunum+0x15>
		return lapic[ID] >> 24;
f0106b91:	8b 42 20             	mov    0x20(%edx),%eax
f0106b94:	c1 e8 18             	shr    $0x18,%eax
}
f0106b97:	c3                   	ret    

f0106b98 <lapic_init>:
	if (!lapicaddr)
f0106b98:	a1 00 10 5c f0       	mov    0xf05c1000,%eax
f0106b9d:	85 c0                	test   %eax,%eax
f0106b9f:	75 01                	jne    f0106ba2 <lapic_init+0xa>
f0106ba1:	c3                   	ret    
{
f0106ba2:	55                   	push   %ebp
f0106ba3:	89 e5                	mov    %esp,%ebp
f0106ba5:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106ba8:	68 00 10 00 00       	push   $0x1000
f0106bad:	50                   	push   %eax
f0106bae:	e8 2f ab ff ff       	call   f01016e2 <mmio_map_region>
f0106bb3:	a3 04 10 5c f0       	mov    %eax,0xf05c1004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106bb8:	ba 27 01 00 00       	mov    $0x127,%edx
f0106bbd:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106bc2:	e8 a7 ff ff ff       	call   f0106b6e <lapicw>
	lapicw(TDCR, X1);
f0106bc7:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106bcc:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106bd1:	e8 98 ff ff ff       	call   f0106b6e <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106bd6:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106bdb:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106be0:	e8 89 ff ff ff       	call   f0106b6e <lapicw>
	lapicw(TICR, 10000000); 
f0106be5:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106bea:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106bef:	e8 7a ff ff ff       	call   f0106b6e <lapicw>
	if (thiscpu != bootcpu)
f0106bf4:	e8 89 ff ff ff       	call   f0106b82 <cpunum>
f0106bf9:	6b c0 74             	imul   $0x74,%eax,%eax
f0106bfc:	05 20 00 58 f0       	add    $0xf0580020,%eax
f0106c01:	83 c4 10             	add    $0x10,%esp
f0106c04:	39 05 c0 03 58 f0    	cmp    %eax,0xf05803c0
f0106c0a:	74 0f                	je     f0106c1b <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106c0c:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c11:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106c16:	e8 53 ff ff ff       	call   f0106b6e <lapicw>
	lapicw(LINT1, MASKED);
f0106c1b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c20:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106c25:	e8 44 ff ff ff       	call   f0106b6e <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106c2a:	a1 04 10 5c f0       	mov    0xf05c1004,%eax
f0106c2f:	8b 40 30             	mov    0x30(%eax),%eax
f0106c32:	c1 e8 10             	shr    $0x10,%eax
f0106c35:	a8 fc                	test   $0xfc,%al
f0106c37:	75 7c                	jne    f0106cb5 <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106c39:	ba 33 00 00 00       	mov    $0x33,%edx
f0106c3e:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106c43:	e8 26 ff ff ff       	call   f0106b6e <lapicw>
	lapicw(ESR, 0);
f0106c48:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c4d:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106c52:	e8 17 ff ff ff       	call   f0106b6e <lapicw>
	lapicw(ESR, 0);
f0106c57:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c5c:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106c61:	e8 08 ff ff ff       	call   f0106b6e <lapicw>
	lapicw(EOI, 0);
f0106c66:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c6b:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106c70:	e8 f9 fe ff ff       	call   f0106b6e <lapicw>
	lapicw(ICRHI, 0);
f0106c75:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c7a:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106c7f:	e8 ea fe ff ff       	call   f0106b6e <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106c84:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106c89:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c8e:	e8 db fe ff ff       	call   f0106b6e <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106c93:	8b 15 04 10 5c f0    	mov    0xf05c1004,%edx
f0106c99:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106c9f:	f6 c4 10             	test   $0x10,%ah
f0106ca2:	75 f5                	jne    f0106c99 <lapic_init+0x101>
	lapicw(TPR, 0);
f0106ca4:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ca9:	b8 20 00 00 00       	mov    $0x20,%eax
f0106cae:	e8 bb fe ff ff       	call   f0106b6e <lapicw>
}
f0106cb3:	c9                   	leave  
f0106cb4:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106cb5:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106cba:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106cbf:	e8 aa fe ff ff       	call   f0106b6e <lapicw>
f0106cc4:	e9 70 ff ff ff       	jmp    f0106c39 <lapic_init+0xa1>

f0106cc9 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106cc9:	83 3d 04 10 5c f0 00 	cmpl   $0x0,0xf05c1004
f0106cd0:	74 17                	je     f0106ce9 <lapic_eoi+0x20>
{
f0106cd2:	55                   	push   %ebp
f0106cd3:	89 e5                	mov    %esp,%ebp
f0106cd5:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106cd8:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cdd:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106ce2:	e8 87 fe ff ff       	call   f0106b6e <lapicw>
}
f0106ce7:	c9                   	leave  
f0106ce8:	c3                   	ret    
f0106ce9:	c3                   	ret    

f0106cea <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106cea:	55                   	push   %ebp
f0106ceb:	89 e5                	mov    %esp,%ebp
f0106ced:	56                   	push   %esi
f0106cee:	53                   	push   %ebx
f0106cef:	8b 75 08             	mov    0x8(%ebp),%esi
f0106cf2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106cf5:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106cfa:	ba 70 00 00 00       	mov    $0x70,%edx
f0106cff:	ee                   	out    %al,(%dx)
f0106d00:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106d05:	ba 71 00 00 00       	mov    $0x71,%edx
f0106d0a:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106d0b:	83 3d a8 fe 57 f0 00 	cmpl   $0x0,0xf057fea8
f0106d12:	74 7e                	je     f0106d92 <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106d14:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106d1b:	00 00 
	wrv[1] = addr >> 4;
f0106d1d:	89 d8                	mov    %ebx,%eax
f0106d1f:	c1 e8 04             	shr    $0x4,%eax
f0106d22:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106d28:	c1 e6 18             	shl    $0x18,%esi
f0106d2b:	89 f2                	mov    %esi,%edx
f0106d2d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d32:	e8 37 fe ff ff       	call   f0106b6e <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106d37:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106d3c:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d41:	e8 28 fe ff ff       	call   f0106b6e <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106d46:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106d4b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d50:	e8 19 fe ff ff       	call   f0106b6e <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106d55:	c1 eb 0c             	shr    $0xc,%ebx
f0106d58:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106d5b:	89 f2                	mov    %esi,%edx
f0106d5d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d62:	e8 07 fe ff ff       	call   f0106b6e <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106d67:	89 da                	mov    %ebx,%edx
f0106d69:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d6e:	e8 fb fd ff ff       	call   f0106b6e <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106d73:	89 f2                	mov    %esi,%edx
f0106d75:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d7a:	e8 ef fd ff ff       	call   f0106b6e <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106d7f:	89 da                	mov    %ebx,%edx
f0106d81:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d86:	e8 e3 fd ff ff       	call   f0106b6e <lapicw>
		microdelay(200);
	}
}
f0106d8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106d8e:	5b                   	pop    %ebx
f0106d8f:	5e                   	pop    %esi
f0106d90:	5d                   	pop    %ebp
f0106d91:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106d92:	68 67 04 00 00       	push   $0x467
f0106d97:	68 14 7c 10 f0       	push   $0xf0107c14
f0106d9c:	68 9c 00 00 00       	push   $0x9c
f0106da1:	68 bc 9e 10 f0       	push   $0xf0109ebc
f0106da6:	e8 9e 92 ff ff       	call   f0100049 <_panic>

f0106dab <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106dab:	55                   	push   %ebp
f0106dac:	89 e5                	mov    %esp,%ebp
f0106dae:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106db1:	8b 55 08             	mov    0x8(%ebp),%edx
f0106db4:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106dba:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106dbf:	e8 aa fd ff ff       	call   f0106b6e <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106dc4:	8b 15 04 10 5c f0    	mov    0xf05c1004,%edx
f0106dca:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106dd0:	f6 c4 10             	test   $0x10,%ah
f0106dd3:	75 f5                	jne    f0106dca <lapic_ipi+0x1f>
		;
}
f0106dd5:	c9                   	leave  
f0106dd6:	c3                   	ret    

f0106dd7 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106dd7:	55                   	push   %ebp
f0106dd8:	89 e5                	mov    %esp,%ebp
f0106dda:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106ddd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106de3:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106de6:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106de9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106df0:	5d                   	pop    %ebp
f0106df1:	c3                   	ret    

f0106df2 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106df2:	55                   	push   %ebp
f0106df3:	89 e5                	mov    %esp,%ebp
f0106df5:	56                   	push   %esi
f0106df6:	53                   	push   %ebx
f0106df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106dfa:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106dfd:	75 12                	jne    f0106e11 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0106dff:	ba 01 00 00 00       	mov    $0x1,%edx
f0106e04:	89 d0                	mov    %edx,%eax
f0106e06:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106e09:	85 c0                	test   %eax,%eax
f0106e0b:	74 36                	je     f0106e43 <spin_lock+0x51>
		asm volatile ("pause");
f0106e0d:	f3 90                	pause  
f0106e0f:	eb f3                	jmp    f0106e04 <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0106e11:	8b 73 08             	mov    0x8(%ebx),%esi
f0106e14:	e8 69 fd ff ff       	call   f0106b82 <cpunum>
f0106e19:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e1c:	05 20 00 58 f0       	add    $0xf0580020,%eax
	if (holding(lk))
f0106e21:	39 c6                	cmp    %eax,%esi
f0106e23:	75 da                	jne    f0106dff <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106e25:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106e28:	e8 55 fd ff ff       	call   f0106b82 <cpunum>
f0106e2d:	83 ec 0c             	sub    $0xc,%esp
f0106e30:	53                   	push   %ebx
f0106e31:	50                   	push   %eax
f0106e32:	68 cc 9e 10 f0       	push   $0xf0109ecc
f0106e37:	6a 41                	push   $0x41
f0106e39:	68 2e 9f 10 f0       	push   $0xf0109f2e
f0106e3e:	e8 06 92 ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106e43:	e8 3a fd ff ff       	call   f0106b82 <cpunum>
f0106e48:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e4b:	05 20 00 58 f0       	add    $0xf0580020,%eax
f0106e50:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0106e53:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106e55:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106e5a:	83 f8 09             	cmp    $0x9,%eax
f0106e5d:	7f 16                	jg     f0106e75 <spin_lock+0x83>
f0106e5f:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106e65:	76 0e                	jbe    f0106e75 <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106e67:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106e6a:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106e6e:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106e70:	83 c0 01             	add    $0x1,%eax
f0106e73:	eb e5                	jmp    f0106e5a <spin_lock+0x68>
	for (; i < 10; i++)
f0106e75:	83 f8 09             	cmp    $0x9,%eax
f0106e78:	7f 0d                	jg     f0106e87 <spin_lock+0x95>
		pcs[i] = 0;
f0106e7a:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106e81:	00 
	for (; i < 10; i++)
f0106e82:	83 c0 01             	add    $0x1,%eax
f0106e85:	eb ee                	jmp    f0106e75 <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106e87:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106e8a:	5b                   	pop    %ebx
f0106e8b:	5e                   	pop    %esi
f0106e8c:	5d                   	pop    %ebp
f0106e8d:	c3                   	ret    

f0106e8e <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106e8e:	55                   	push   %ebp
f0106e8f:	89 e5                	mov    %esp,%ebp
f0106e91:	57                   	push   %edi
f0106e92:	56                   	push   %esi
f0106e93:	53                   	push   %ebx
f0106e94:	83 ec 4c             	sub    $0x4c,%esp
f0106e97:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106e9a:	83 3e 00             	cmpl   $0x0,(%esi)
f0106e9d:	75 35                	jne    f0106ed4 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106e9f:	83 ec 04             	sub    $0x4,%esp
f0106ea2:	6a 28                	push   $0x28
f0106ea4:	8d 46 0c             	lea    0xc(%esi),%eax
f0106ea7:	50                   	push   %eax
f0106ea8:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106eab:	53                   	push   %ebx
f0106eac:	e8 11 f7 ff ff       	call   f01065c2 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106eb1:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106eb4:	0f b6 38             	movzbl (%eax),%edi
f0106eb7:	8b 76 04             	mov    0x4(%esi),%esi
f0106eba:	e8 c3 fc ff ff       	call   f0106b82 <cpunum>
f0106ebf:	57                   	push   %edi
f0106ec0:	56                   	push   %esi
f0106ec1:	50                   	push   %eax
f0106ec2:	68 f8 9e 10 f0       	push   $0xf0109ef8
f0106ec7:	e8 f5 cf ff ff       	call   f0103ec1 <cprintf>
f0106ecc:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106ecf:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106ed2:	eb 4e                	jmp    f0106f22 <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0106ed4:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106ed7:	e8 a6 fc ff ff       	call   f0106b82 <cpunum>
f0106edc:	6b c0 74             	imul   $0x74,%eax,%eax
f0106edf:	05 20 00 58 f0       	add    $0xf0580020,%eax
	if (!holding(lk)) {
f0106ee4:	39 c3                	cmp    %eax,%ebx
f0106ee6:	75 b7                	jne    f0106e9f <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0106ee8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106eef:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106ef6:	b8 00 00 00 00       	mov    $0x0,%eax
f0106efb:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106f01:	5b                   	pop    %ebx
f0106f02:	5e                   	pop    %esi
f0106f03:	5f                   	pop    %edi
f0106f04:	5d                   	pop    %ebp
f0106f05:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106f06:	83 ec 08             	sub    $0x8,%esp
f0106f09:	ff 36                	pushl  (%esi)
f0106f0b:	68 55 9f 10 f0       	push   $0xf0109f55
f0106f10:	e8 ac cf ff ff       	call   f0103ec1 <cprintf>
f0106f15:	83 c4 10             	add    $0x10,%esp
f0106f18:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106f1b:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106f1e:	39 c3                	cmp    %eax,%ebx
f0106f20:	74 40                	je     f0106f62 <spin_unlock+0xd4>
f0106f22:	89 de                	mov    %ebx,%esi
f0106f24:	8b 03                	mov    (%ebx),%eax
f0106f26:	85 c0                	test   %eax,%eax
f0106f28:	74 38                	je     f0106f62 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106f2a:	83 ec 08             	sub    $0x8,%esp
f0106f2d:	57                   	push   %edi
f0106f2e:	50                   	push   %eax
f0106f2f:	e8 df e9 ff ff       	call   f0105913 <debuginfo_eip>
f0106f34:	83 c4 10             	add    $0x10,%esp
f0106f37:	85 c0                	test   %eax,%eax
f0106f39:	78 cb                	js     f0106f06 <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106f3b:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106f3d:	83 ec 04             	sub    $0x4,%esp
f0106f40:	89 c2                	mov    %eax,%edx
f0106f42:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106f45:	52                   	push   %edx
f0106f46:	ff 75 b0             	pushl  -0x50(%ebp)
f0106f49:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106f4c:	ff 75 ac             	pushl  -0x54(%ebp)
f0106f4f:	ff 75 a8             	pushl  -0x58(%ebp)
f0106f52:	50                   	push   %eax
f0106f53:	68 3e 9f 10 f0       	push   $0xf0109f3e
f0106f58:	e8 64 cf ff ff       	call   f0103ec1 <cprintf>
f0106f5d:	83 c4 20             	add    $0x20,%esp
f0106f60:	eb b6                	jmp    f0106f18 <spin_unlock+0x8a>
		panic("spin_unlock");
f0106f62:	83 ec 04             	sub    $0x4,%esp
f0106f65:	68 5d 9f 10 f0       	push   $0xf0109f5d
f0106f6a:	6a 67                	push   $0x67
f0106f6c:	68 2e 9f 10 f0       	push   $0xf0109f2e
f0106f71:	e8 d3 90 ff ff       	call   f0100049 <_panic>

f0106f76 <e1000_tx_init>:
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_buffer[N_TXDESC][PKT_SIZE];

int
e1000_tx_init()
{
f0106f76:	55                   	push   %ebp
f0106f77:	89 e5                	mov    %esp,%ebp
f0106f79:	57                   	push   %edi
f0106f7a:	56                   	push   %esi
f0106f7b:	53                   	push   %ebx
f0106f7c:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
f0106f7f:	68 c4 9f 10 f0       	push   $0xf0109fc4
f0106f84:	68 a6 91 10 f0       	push   $0xf01091a6
f0106f89:	e8 33 cf ff ff       	call   f0103ec1 <cprintf>
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0106f8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0106f95:	e8 2a a3 ff ff       	call   f01012c4 <page_alloc>
	if(page == NULL)
f0106f9a:	83 c4 10             	add    $0x10,%esp
f0106f9d:	85 c0                	test   %eax,%eax
f0106f9f:	0f 84 0a 01 00 00    	je     f01070af <e1000_tx_init+0x139>
	return (pp - pages) << PGSHIFT;
f0106fa5:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f0106fab:	c1 f8 03             	sar    $0x3,%eax
f0106fae:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0106fb1:	89 c2                	mov    %eax,%edx
f0106fb3:	c1 ea 0c             	shr    $0xc,%edx
f0106fb6:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0106fbc:	0f 83 01 01 00 00    	jae    f01070c3 <e1000_tx_init+0x14d>
	return (void *)(pa + KERNBASE);
f0106fc2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0106fc7:	a3 20 10 5c f0       	mov    %eax,0xf05c1020
f0106fcc:	ba 40 fe 61 f0       	mov    $0xf061fe40,%edx
f0106fd1:	b8 40 fe 61 00       	mov    $0x61fe40,%eax
f0106fd6:	89 c6                	mov    %eax,%esi
f0106fd8:	bf 00 00 00 00       	mov    $0x0,%edi
			panic("page_alloc panic\n");
	// r = page_insert(kern_pgdir, page, page2kva(page), PTE_P|PTE_U|PTE_W|PTE_PCD|PTE_PWT);
	// if(r < 0)
		// panic("page insert panic\n");
	tx_descs = (struct tx_desc *)page2kva(page);
f0106fdd:	b9 00 00 00 00       	mov    $0x0,%ecx
	if ((uint32_t)kva < KERNBASE)
f0106fe2:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0106fe8:	0f 86 e7 00 00 00    	jbe    f01070d5 <e1000_tx_init+0x15f>
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(tx_buffer[i]);
f0106fee:	a1 20 10 5c f0       	mov    0xf05c1020,%eax
f0106ff3:	89 34 08             	mov    %esi,(%eax,%ecx,1)
f0106ff6:	89 7c 08 04          	mov    %edi,0x4(%eax,%ecx,1)
		tx_descs[i].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0106ffa:	8b 1d 20 10 5c f0    	mov    0xf05c1020,%ebx
f0107000:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
f0107003:	80 48 0b 05          	orb    $0x5,0xb(%eax)
		tx_descs[i].status |= E1000_TX_STATUS_DD;
f0107007:	80 48 0c 01          	orb    $0x1,0xc(%eax)
		tx_descs[i].length = 0;
f010700b:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		tx_descs[i].cso = 0;
f0107011:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
		tx_descs[i].css = 0;
f0107015:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
		tx_descs[i].special = 0;
f0107019:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
f010701f:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f0107025:	83 c1 10             	add    $0x10,%ecx
f0107028:	81 c6 ee 05 00 00    	add    $0x5ee,%esi
f010702e:	83 d7 00             	adc    $0x0,%edi
	for(int i = 0; i < N_TXDESC; i++){
f0107031:	81 fa 40 ec 67 f0    	cmp    $0xf067ec40,%edx
f0107037:	75 a9                	jne    f0106fe2 <e1000_tx_init+0x6c>
	}
	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->TDBAL = PADDR(tx_descs);
f0107039:	a1 80 ee 57 f0       	mov    0xf057ee80,%eax
f010703e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0107044:	0f 86 9d 00 00 00    	jbe    f01070e7 <e1000_tx_init+0x171>
	return (physaddr_t)kva - KERNBASE;
f010704a:	81 c3 00 00 00 10    	add    $0x10000000,%ebx
f0107050:	89 98 00 38 00 00    	mov    %ebx,0x3800(%eax)
	base->TDBAH = (uint32_t)0;
f0107056:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f010705d:	00 00 00 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc); 
f0107060:	c7 80 08 38 00 00 00 	movl   $0x1000,0x3808(%eax)
f0107067:	10 00 00 

	base->TDH = 0;
f010706a:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f0107071:	00 00 00 
	base->TDT = 0;
f0107074:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f010707b:	00 00 00 
	base->TCTL |= E1000_TCTL_EN|E1000_TCTL_PSP|E1000_TCTL_CT_ETHER|E1000_TCTL_COLD_FULL_DUPLEX;
f010707e:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0107084:	81 ca 0a 01 04 00    	or     $0x4010a,%edx
f010708a:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	base->TIPG |= E1000_TIPG_DEFAULT;
f0107090:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
f0107096:	81 ca 0a 10 60 00    	or     $0x60100a,%edx
f010709c:	89 90 10 04 00 00    	mov    %edx,0x410(%eax)
	return 0;
}
f01070a2:	b8 00 00 00 00       	mov    $0x0,%eax
f01070a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01070aa:	5b                   	pop    %ebx
f01070ab:	5e                   	pop    %esi
f01070ac:	5f                   	pop    %edi
f01070ad:	5d                   	pop    %ebp
f01070ae:	c3                   	ret    
			panic("page_alloc panic\n");
f01070af:	83 ec 04             	sub    $0x4,%esp
f01070b2:	68 75 9f 10 f0       	push   $0xf0109f75
f01070b7:	6a 14                	push   $0x14
f01070b9:	68 87 9f 10 f0       	push   $0xf0109f87
f01070be:	e8 86 8f ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01070c3:	50                   	push   %eax
f01070c4:	68 14 7c 10 f0       	push   $0xf0107c14
f01070c9:	6a 58                	push   $0x58
f01070cb:	68 b1 8d 10 f0       	push   $0xf0108db1
f01070d0:	e8 74 8f ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01070d5:	52                   	push   %edx
f01070d6:	68 38 7c 10 f0       	push   $0xf0107c38
f01070db:	6a 1b                	push   $0x1b
f01070dd:	68 87 9f 10 f0       	push   $0xf0109f87
f01070e2:	e8 62 8f ff ff       	call   f0100049 <_panic>
f01070e7:	53                   	push   %ebx
f01070e8:	68 38 7c 10 f0       	push   $0xf0107c38
f01070ed:	6a 26                	push   $0x26
f01070ef:	68 87 9f 10 f0       	push   $0xf0109f87
f01070f4:	e8 50 8f ff ff       	call   f0100049 <_panic>

f01070f9 <e1000_rx_init>:
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_buffer[N_RXDESC][PKT_SIZE];

int
e1000_rx_init()
{
f01070f9:	55                   	push   %ebp
f01070fa:	89 e5                	mov    %esp,%ebp
f01070fc:	57                   	push   %edi
f01070fd:	56                   	push   %esi
f01070fe:	53                   	push   %ebx
f01070ff:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n",__FUNCTION__);
f0107102:	68 b4 9f 10 f0       	push   $0xf0109fb4
f0107107:	68 a6 91 10 f0       	push   $0xf01091a6
f010710c:	e8 b0 cd ff ff       	call   f0103ec1 <cprintf>
	int r;
	// Allocate one page for descriptors
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f0107111:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0107118:	e8 a7 a1 ff ff       	call   f01012c4 <page_alloc>
	if(page == NULL)
f010711d:	83 c4 10             	add    $0x10,%esp
f0107120:	85 c0                	test   %eax,%eax
f0107122:	0f 84 0e 01 00 00    	je     f0107236 <e1000_rx_init+0x13d>
	return (pp - pages) << PGSHIFT;
f0107128:	2b 05 b0 fe 57 f0    	sub    0xf057feb0,%eax
f010712e:	c1 f8 03             	sar    $0x3,%eax
f0107131:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0107134:	89 c2                	mov    %eax,%edx
f0107136:	c1 ea 0c             	shr    $0xc,%edx
f0107139:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f010713f:	0f 83 05 01 00 00    	jae    f010724a <e1000_rx_init+0x151>
	return (void *)(pa + KERNBASE);
f0107145:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010714a:	a3 24 10 5c f0       	mov    %eax,0xf05c1024
f010714f:	ba 40 10 5c f0       	mov    $0xf05c1040,%edx
f0107154:	b9 40 10 5c 00       	mov    $0x5c1040,%ecx
f0107159:	bb 00 00 00 00       	mov    $0x0,%ebx
f010715e:	bf 40 fe 61 f0       	mov    $0xf061fe40,%edi
			panic("page_alloc panic\n");
	rx_descs = (struct rx_desc *)page2kva(page);
f0107163:	b8 00 00 00 00       	mov    $0x0,%eax
	if ((uint32_t)kva < KERNBASE)
f0107168:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010716e:	0f 86 e8 00 00 00    	jbe    f010725c <e1000_rx_init+0x163>
	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for(int i = 0; i < N_RXDESC; i++){
		rx_descs[i].addr = PADDR(&rx_buffer[i]);
f0107174:	8b 35 24 10 5c f0    	mov    0xf05c1024,%esi
f010717a:	89 0c 06             	mov    %ecx,(%esi,%eax,1)
f010717d:	89 5c 06 04          	mov    %ebx,0x4(%esi,%eax,1)
		rx_descs[i].status |= E1000_RX_STATUS_DD;
f0107181:	8b 35 24 10 5c f0    	mov    0xf05c1024,%esi
f0107187:	80 4c 06 0c 01       	orb    $0x1,0xc(%esi,%eax,1)
f010718c:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f0107192:	83 c0 10             	add    $0x10,%eax
f0107195:	81 c1 ee 05 00 00    	add    $0x5ee,%ecx
f010719b:	83 d3 00             	adc    $0x0,%ebx
	for(int i = 0; i < N_RXDESC; i++){
f010719e:	39 fa                	cmp    %edi,%edx
f01071a0:	75 c6                	jne    f0107168 <e1000_rx_init+0x6f>
	}
	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	//lab6 bug?
	base->RAL = QEMU_MAC_LOW;
f01071a2:	a1 80 ee 57 f0       	mov    0xf057ee80,%eax
f01071a7:	c7 80 1c 3a 00 00 52 	movl   $0x12005452,0x3a1c(%eax)
f01071ae:	54 00 12 
	base->RAH = QEMU_MAC_HIGH;
f01071b1:	c7 80 20 3a 00 00 34 	movl   $0x5634,0x3a20(%eax)
f01071b8:	56 00 00 
	// memset(base->MTA, 0, 128);
	base->IMS = 0;
f01071bb:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%eax)
f01071c2:	00 00 00 
f01071c5:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f01071cb:	0f 86 9d 00 00 00    	jbe    f010726e <e1000_rx_init+0x175>
	return (physaddr_t)kva - KERNBASE;
f01071d1:	81 c6 00 00 00 10    	add    $0x10000000,%esi
	base->RDBAL = PADDR(rx_descs);
f01071d7:	89 b0 00 28 00 00    	mov    %esi,0x2800(%eax)
	base->RDBAH = (uint32_t)0;
f01071dd:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
f01071e4:	00 00 00 
	base->RDLEN = N_RXDESC * sizeof(struct rx_desc); 
f01071e7:	c7 80 08 28 00 00 00 	movl   $0x1000,0x2808(%eax)
f01071ee:	10 00 00 

	base->RCTL |= E1000_RCTL_EN|E1000_RCTL_BSIZE_2048|E1000_RCTL_SECRC;
f01071f1:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f01071f7:	81 ca 02 00 00 04    	or     $0x4000002,%edx
f01071fd:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)

	base->RDH = 0;
f0107203:	c7 80 10 28 00 00 00 	movl   $0x0,0x2810(%eax)
f010720a:	00 00 00 
	base->RDT = N_RXDESC;
f010720d:	c7 80 18 28 00 00 00 	movl   $0x100,0x2818(%eax)
f0107214:	01 00 00 

	base->RCTL |= E1000_RCTL_BSIZE_2048 | E1000_RCTL_EN | E1000_RCTL_SECRC;
f0107217:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f010721d:	81 ca 02 00 00 04    	or     $0x4000002,%edx
f0107223:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	return 0;
}
f0107229:	b8 00 00 00 00       	mov    $0x0,%eax
f010722e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107231:	5b                   	pop    %ebx
f0107232:	5e                   	pop    %esi
f0107233:	5f                   	pop    %edi
f0107234:	5d                   	pop    %ebp
f0107235:	c3                   	ret    
			panic("page_alloc panic\n");
f0107236:	83 ec 04             	sub    $0x4,%esp
f0107239:	68 75 9f 10 f0       	push   $0xf0109f75
f010723e:	6a 3d                	push   $0x3d
f0107240:	68 87 9f 10 f0       	push   $0xf0109f87
f0107245:	e8 ff 8d ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010724a:	50                   	push   %eax
f010724b:	68 14 7c 10 f0       	push   $0xf0107c14
f0107250:	6a 58                	push   $0x58
f0107252:	68 b1 8d 10 f0       	push   $0xf0108db1
f0107257:	e8 ed 8d ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010725c:	52                   	push   %edx
f010725d:	68 38 7c 10 f0       	push   $0xf0107c38
f0107262:	6a 42                	push   $0x42
f0107264:	68 87 9f 10 f0       	push   $0xf0109f87
f0107269:	e8 db 8d ff ff       	call   f0100049 <_panic>
f010726e:	56                   	push   %esi
f010726f:	68 38 7c 10 f0       	push   $0xf0107c38
f0107274:	6a 4c                	push   $0x4c
f0107276:	68 87 9f 10 f0       	push   $0xf0109f87
f010727b:	e8 c9 8d ff ff       	call   f0100049 <_panic>

f0107280 <pci_e1000_attach>:

int
pci_e1000_attach(struct pci_func *pcif)
{
f0107280:	55                   	push   %ebp
f0107281:	89 e5                	mov    %esp,%ebp
f0107283:	53                   	push   %ebx
f0107284:	83 ec 0c             	sub    $0xc,%esp
f0107287:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f010728a:	68 a0 9f 10 f0       	push   $0xf0109fa0
f010728f:	68 a6 91 10 f0       	push   $0xf01091a6
f0107294:	e8 28 cc ff ff       	call   f0103ec1 <cprintf>
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
f0107299:	89 1c 24             	mov    %ebx,(%esp)
f010729c:	e8 1d 05 00 00       	call   f01077be <pci_func_enable>
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f01072a1:	83 c4 08             	add    $0x8,%esp
f01072a4:	ff 73 2c             	pushl  0x2c(%ebx)
f01072a7:	ff 73 14             	pushl  0x14(%ebx)
f01072aa:	e8 33 a4 ff ff       	call   f01016e2 <mmio_map_region>
f01072af:	a3 80 ee 57 f0       	mov    %eax,0xf057ee80
	e1000_tx_init();
f01072b4:	e8 bd fc ff ff       	call   f0106f76 <e1000_tx_init>
	e1000_rx_init();
f01072b9:	e8 3b fe ff ff       	call   f01070f9 <e1000_rx_init>

	// char test[100]="123456";
	// e1000_tx(test,3);
	return 0;
}
f01072be:	b8 00 00 00 00       	mov    $0x0,%eax
f01072c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01072c6:	c9                   	leave  
f01072c7:	c3                   	ret    

f01072c8 <e1000_tx>:

int
e1000_tx(const void *buf, uint32_t len)
{
f01072c8:	55                   	push   %ebp
f01072c9:	89 e5                	mov    %esp,%ebp
f01072cb:	53                   	push   %ebx
f01072cc:	83 ec 0c             	sub    $0xc,%esp
f01072cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address
	cprintf("in %s\n", __FUNCTION__);
f01072d2:	68 94 9f 10 f0       	push   $0xf0109f94
f01072d7:	68 a6 91 10 f0       	push   $0xf01091a6
f01072dc:	e8 e0 cb ff ff       	call   f0103ec1 <cprintf>
	if(tx_descs[base->TDT].status & E1000_TX_STATUS_DD){
f01072e1:	a1 20 10 5c f0       	mov    0xf05c1020,%eax
f01072e6:	8b 0d 80 ee 57 f0    	mov    0xf057ee80,%ecx
f01072ec:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f01072f2:	c1 e2 04             	shl    $0x4,%edx
f01072f5:	83 c4 10             	add    $0x10,%esp
f01072f8:	f6 44 10 0c 01       	testb  $0x1,0xc(%eax,%edx,1)
f01072fd:	0f 84 e3 00 00 00    	je     f01073e6 <e1000_tx+0x11e>
		tx_descs[base->TDT].status ^= E1000_TX_STATUS_DD;
f0107303:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f0107309:	c1 e2 04             	shl    $0x4,%edx
f010730c:	80 74 10 0c 01       	xorb   $0x1,0xc(%eax,%edx,1)
		memset(KADDR(tx_descs[base->TDT].addr), 0 , PKT_SIZE);
f0107311:	8b 91 18 38 00 00    	mov    0x3818(%ecx),%edx
f0107317:	c1 e2 04             	shl    $0x4,%edx
f010731a:	8b 04 10             	mov    (%eax,%edx,1),%eax
	if (PGNUM(pa) >= npages)
f010731d:	89 c2                	mov    %eax,%edx
f010731f:	c1 ea 0c             	shr    $0xc,%edx
f0107322:	3b 15 a8 fe 57 f0    	cmp    0xf057fea8,%edx
f0107328:	0f 83 94 00 00 00    	jae    f01073c2 <e1000_tx+0xfa>
f010732e:	83 ec 04             	sub    $0x4,%esp
f0107331:	68 ee 05 00 00       	push   $0x5ee
f0107336:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0107338:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010733d:	50                   	push   %eax
f010733e:	e8 37 f2 ff ff       	call   f010657a <memset>
		memcpy(KADDR(tx_descs[base->TDT].addr), buf, len);
f0107343:	a1 80 ee 57 f0       	mov    0xf057ee80,%eax
f0107348:	8b 80 18 38 00 00    	mov    0x3818(%eax),%eax
f010734e:	c1 e0 04             	shl    $0x4,%eax
f0107351:	03 05 20 10 5c f0    	add    0xf05c1020,%eax
f0107357:	8b 00                	mov    (%eax),%eax
	if (PGNUM(pa) >= npages)
f0107359:	89 c2                	mov    %eax,%edx
f010735b:	c1 ea 0c             	shr    $0xc,%edx
f010735e:	83 c4 10             	add    $0x10,%esp
f0107361:	39 15 a8 fe 57 f0    	cmp    %edx,0xf057fea8
f0107367:	76 6b                	jbe    f01073d4 <e1000_tx+0x10c>
f0107369:	83 ec 04             	sub    $0x4,%esp
f010736c:	53                   	push   %ebx
f010736d:	ff 75 08             	pushl  0x8(%ebp)
	return (void *)(pa + KERNBASE);
f0107370:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107375:	50                   	push   %eax
f0107376:	e8 a9 f2 ff ff       	call   f0106624 <memcpy>
		tx_descs[base->TDT].length = len;
f010737b:	8b 0d 20 10 5c f0    	mov    0xf05c1020,%ecx
f0107381:	8b 15 80 ee 57 f0    	mov    0xf057ee80,%edx
f0107387:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f010738d:	c1 e0 04             	shl    $0x4,%eax
f0107390:	66 89 5c 01 08       	mov    %bx,0x8(%ecx,%eax,1)
		tx_descs[base->TDT].cmd |= E1000_TX_CMD_EOP|E1000_TX_CMD_RS;
f0107395:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f010739b:	c1 e0 04             	shl    $0x4,%eax
f010739e:	80 4c 01 0b 05       	orb    $0x5,0xb(%ecx,%eax,1)

		base->TDT = (base->TDT + 1)%N_TXDESC;
f01073a3:	8b 82 18 38 00 00    	mov    0x3818(%edx),%eax
f01073a9:	83 c0 01             	add    $0x1,%eax
f01073ac:	0f b6 c0             	movzbl %al,%eax
f01073af:	89 82 18 38 00 00    	mov    %eax,0x3818(%edx)
	}
	else{
		return -E_TX_FULL;
	}
	return 0;
f01073b5:	83 c4 10             	add    $0x10,%esp
f01073b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01073bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01073c0:	c9                   	leave  
f01073c1:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01073c2:	50                   	push   %eax
f01073c3:	68 14 7c 10 f0       	push   $0xf0107c14
f01073c8:	6a 72                	push   $0x72
f01073ca:	68 87 9f 10 f0       	push   $0xf0109f87
f01073cf:	e8 75 8c ff ff       	call   f0100049 <_panic>
f01073d4:	50                   	push   %eax
f01073d5:	68 14 7c 10 f0       	push   $0xf0107c14
f01073da:	6a 73                	push   $0x73
f01073dc:	68 87 9f 10 f0       	push   $0xf0109f87
f01073e1:	e8 63 8c ff ff       	call   f0100049 <_panic>
		return -E_TX_FULL;
f01073e6:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
f01073eb:	eb d0                	jmp    f01073bd <e1000_tx+0xf5>

f01073ed <e1000_rx>:
	// the packet
	// Do not forget to reset the decscriptor and
	// give it back to hardware by modifying RDT

	return 0;
}
f01073ed:	b8 00 00 00 00       	mov    $0x0,%eax
f01073f2:	c3                   	ret    

f01073f3 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f01073f3:	55                   	push   %ebp
f01073f4:	89 e5                	mov    %esp,%ebp
f01073f6:	57                   	push   %edi
f01073f7:	56                   	push   %esi
f01073f8:	53                   	push   %ebx
f01073f9:	83 ec 0c             	sub    $0xc,%esp
f01073fc:	8b 7d 08             	mov    0x8(%ebp),%edi
f01073ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107402:	eb 03                	jmp    f0107407 <pci_attach_match+0x14>
f0107404:	83 c3 0c             	add    $0xc,%ebx
f0107407:	89 de                	mov    %ebx,%esi
f0107409:	8b 43 08             	mov    0x8(%ebx),%eax
f010740c:	85 c0                	test   %eax,%eax
f010740e:	74 37                	je     f0107447 <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0107410:	39 3b                	cmp    %edi,(%ebx)
f0107412:	75 f0                	jne    f0107404 <pci_attach_match+0x11>
f0107414:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107417:	39 56 04             	cmp    %edx,0x4(%esi)
f010741a:	75 e8                	jne    f0107404 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f010741c:	83 ec 0c             	sub    $0xc,%esp
f010741f:	ff 75 14             	pushl  0x14(%ebp)
f0107422:	ff d0                	call   *%eax
			if (r > 0)
f0107424:	83 c4 10             	add    $0x10,%esp
f0107427:	85 c0                	test   %eax,%eax
f0107429:	7f 1c                	jg     f0107447 <pci_attach_match+0x54>
				return r;
			if (r < 0)
f010742b:	79 d7                	jns    f0107404 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f010742d:	83 ec 0c             	sub    $0xc,%esp
f0107430:	50                   	push   %eax
f0107431:	ff 76 08             	pushl  0x8(%esi)
f0107434:	ff 75 0c             	pushl  0xc(%ebp)
f0107437:	57                   	push   %edi
f0107438:	68 d4 9f 10 f0       	push   $0xf0109fd4
f010743d:	e8 7f ca ff ff       	call   f0103ec1 <cprintf>
f0107442:	83 c4 20             	add    $0x20,%esp
f0107445:	eb bd                	jmp    f0107404 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0107447:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010744a:	5b                   	pop    %ebx
f010744b:	5e                   	pop    %esi
f010744c:	5f                   	pop    %edi
f010744d:	5d                   	pop    %ebp
f010744e:	c3                   	ret    

f010744f <pci_conf1_set_addr>:
{
f010744f:	55                   	push   %ebp
f0107450:	89 e5                	mov    %esp,%ebp
f0107452:	53                   	push   %ebx
f0107453:	83 ec 04             	sub    $0x4,%esp
f0107456:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0107459:	3d ff 00 00 00       	cmp    $0xff,%eax
f010745e:	77 36                	ja     f0107496 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f0107460:	83 fa 1f             	cmp    $0x1f,%edx
f0107463:	77 47                	ja     f01074ac <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f0107465:	83 f9 07             	cmp    $0x7,%ecx
f0107468:	77 58                	ja     f01074c2 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f010746a:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0107470:	77 66                	ja     f01074d8 <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f0107472:	f6 c3 03             	test   $0x3,%bl
f0107475:	75 77                	jne    f01074ee <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0107477:	c1 e0 10             	shl    $0x10,%eax
f010747a:	09 d8                	or     %ebx,%eax
f010747c:	c1 e1 08             	shl    $0x8,%ecx
f010747f:	09 c8                	or     %ecx,%eax
f0107481:	c1 e2 0b             	shl    $0xb,%edx
f0107484:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f0107486:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010748b:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0107490:	ef                   	out    %eax,(%dx)
}
f0107491:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107494:	c9                   	leave  
f0107495:	c3                   	ret    
	assert(bus < 256);
f0107496:	68 2c a1 10 f0       	push   $0xf010a12c
f010749b:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01074a0:	6a 2c                	push   $0x2c
f01074a2:	68 36 a1 10 f0       	push   $0xf010a136
f01074a7:	e8 9d 8b ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f01074ac:	68 41 a1 10 f0       	push   $0xf010a141
f01074b1:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01074b6:	6a 2d                	push   $0x2d
f01074b8:	68 36 a1 10 f0       	push   $0xf010a136
f01074bd:	e8 87 8b ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f01074c2:	68 4a a1 10 f0       	push   $0xf010a14a
f01074c7:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01074cc:	6a 2e                	push   $0x2e
f01074ce:	68 36 a1 10 f0       	push   $0xf010a136
f01074d3:	e8 71 8b ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f01074d8:	68 53 a1 10 f0       	push   $0xf010a153
f01074dd:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01074e2:	6a 2f                	push   $0x2f
f01074e4:	68 36 a1 10 f0       	push   $0xf010a136
f01074e9:	e8 5b 8b ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f01074ee:	68 60 a1 10 f0       	push   $0xf010a160
f01074f3:	68 cb 8d 10 f0       	push   $0xf0108dcb
f01074f8:	6a 30                	push   $0x30
f01074fa:	68 36 a1 10 f0       	push   $0xf010a136
f01074ff:	e8 45 8b ff ff       	call   f0100049 <_panic>

f0107504 <pci_conf_read>:
{
f0107504:	55                   	push   %ebp
f0107505:	89 e5                	mov    %esp,%ebp
f0107507:	53                   	push   %ebx
f0107508:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010750b:	8b 48 08             	mov    0x8(%eax),%ecx
f010750e:	8b 58 04             	mov    0x4(%eax),%ebx
f0107511:	8b 00                	mov    (%eax),%eax
f0107513:	8b 40 04             	mov    0x4(%eax),%eax
f0107516:	52                   	push   %edx
f0107517:	89 da                	mov    %ebx,%edx
f0107519:	e8 31 ff ff ff       	call   f010744f <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f010751e:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107523:	ed                   	in     (%dx),%eax
}
f0107524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107527:	c9                   	leave  
f0107528:	c3                   	ret    

f0107529 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0107529:	55                   	push   %ebp
f010752a:	89 e5                	mov    %esp,%ebp
f010752c:	57                   	push   %edi
f010752d:	56                   	push   %esi
f010752e:	53                   	push   %ebx
f010752f:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0107535:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107537:	6a 48                	push   $0x48
f0107539:	6a 00                	push   $0x0
f010753b:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010753e:	50                   	push   %eax
f010753f:	e8 36 f0 ff ff       	call   f010657a <memset>
	df.bus = bus;
f0107544:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107547:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f010754e:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f0107551:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0107558:	00 00 00 
f010755b:	e9 25 01 00 00       	jmp    f0107685 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107560:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107566:	83 ec 08             	sub    $0x8,%esp
f0107569:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f010756d:	57                   	push   %edi
f010756e:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f010756f:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107572:	0f b6 c0             	movzbl %al,%eax
f0107575:	50                   	push   %eax
f0107576:	51                   	push   %ecx
f0107577:	89 d0                	mov    %edx,%eax
f0107579:	c1 e8 10             	shr    $0x10,%eax
f010757c:	50                   	push   %eax
f010757d:	0f b7 d2             	movzwl %dx,%edx
f0107580:	52                   	push   %edx
f0107581:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0107587:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f010758d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107593:	ff 70 04             	pushl  0x4(%eax)
f0107596:	68 00 a0 10 f0       	push   $0xf010a000
f010759b:	e8 21 c9 ff ff       	call   f0103ec1 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f01075a0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f01075a6:	83 c4 30             	add    $0x30,%esp
f01075a9:	53                   	push   %ebx
f01075aa:	68 0c 84 12 f0       	push   $0xf012840c
				 PCI_SUBCLASS(f->dev_class),
f01075af:	89 c2                	mov    %eax,%edx
f01075b1:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f01075b4:	0f b6 d2             	movzbl %dl,%edx
f01075b7:	52                   	push   %edx
f01075b8:	c1 e8 18             	shr    $0x18,%eax
f01075bb:	50                   	push   %eax
f01075bc:	e8 32 fe ff ff       	call   f01073f3 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f01075c1:	83 c4 10             	add    $0x10,%esp
f01075c4:	85 c0                	test   %eax,%eax
f01075c6:	0f 84 88 00 00 00    	je     f0107654 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f01075cc:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01075d3:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01075d9:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f01075df:	0f 83 92 00 00 00    	jae    f0107677 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f01075e5:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f01075eb:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f01075f1:	b9 12 00 00 00       	mov    $0x12,%ecx
f01075f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f01075f8:	ba 00 00 00 00       	mov    $0x0,%edx
f01075fd:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107603:	e8 fc fe ff ff       	call   f0107504 <pci_conf_read>
f0107608:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f010760e:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107612:	74 b8                	je     f01075cc <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107614:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107619:	89 d8                	mov    %ebx,%eax
f010761b:	e8 e4 fe ff ff       	call   f0107504 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107620:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107623:	ba 08 00 00 00       	mov    $0x8,%edx
f0107628:	89 d8                	mov    %ebx,%eax
f010762a:	e8 d5 fe ff ff       	call   f0107504 <pci_conf_read>
f010762f:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107635:	89 c1                	mov    %eax,%ecx
f0107637:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f010763a:	be 74 a1 10 f0       	mov    $0xf010a174,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f010763f:	83 f9 06             	cmp    $0x6,%ecx
f0107642:	0f 87 18 ff ff ff    	ja     f0107560 <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107648:	8b 34 8d e8 a1 10 f0 	mov    -0xfef5e18(,%ecx,4),%esi
f010764f:	e9 0c ff ff ff       	jmp    f0107560 <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0107654:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f010765a:	53                   	push   %ebx
f010765b:	68 f4 83 12 f0       	push   $0xf01283f4
f0107660:	89 c2                	mov    %eax,%edx
f0107662:	c1 ea 10             	shr    $0x10,%edx
f0107665:	52                   	push   %edx
f0107666:	0f b7 c0             	movzwl %ax,%eax
f0107669:	50                   	push   %eax
f010766a:	e8 84 fd ff ff       	call   f01073f3 <pci_attach_match>
f010766f:	83 c4 10             	add    $0x10,%esp
f0107672:	e9 55 ff ff ff       	jmp    f01075cc <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107677:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f010767a:	83 c0 01             	add    $0x1,%eax
f010767d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107680:	83 f8 1f             	cmp    $0x1f,%eax
f0107683:	77 59                	ja     f01076de <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107685:	ba 0c 00 00 00       	mov    $0xc,%edx
f010768a:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010768d:	e8 72 fe ff ff       	call   f0107504 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107692:	89 c2                	mov    %eax,%edx
f0107694:	c1 ea 10             	shr    $0x10,%edx
f0107697:	f6 c2 7e             	test   $0x7e,%dl
f010769a:	75 db                	jne    f0107677 <pci_scan_bus+0x14e>
		totaldev++;
f010769c:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f01076a3:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f01076a9:	8d 75 a0             	lea    -0x60(%ebp),%esi
f01076ac:	b9 12 00 00 00       	mov    $0x12,%ecx
f01076b1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01076b3:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f01076ba:	00 00 00 
f01076bd:	25 00 00 80 00       	and    $0x800000,%eax
f01076c2:	83 f8 01             	cmp    $0x1,%eax
f01076c5:	19 c0                	sbb    %eax,%eax
f01076c7:	83 e0 f9             	and    $0xfffffff9,%eax
f01076ca:	83 c0 08             	add    $0x8,%eax
f01076cd:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01076d3:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01076d9:	e9 f5 fe ff ff       	jmp    f01075d3 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f01076de:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f01076e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01076e7:	5b                   	pop    %ebx
f01076e8:	5e                   	pop    %esi
f01076e9:	5f                   	pop    %edi
f01076ea:	5d                   	pop    %ebp
f01076eb:	c3                   	ret    

f01076ec <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f01076ec:	55                   	push   %ebp
f01076ed:	89 e5                	mov    %esp,%ebp
f01076ef:	57                   	push   %edi
f01076f0:	56                   	push   %esi
f01076f1:	53                   	push   %ebx
f01076f2:	83 ec 1c             	sub    $0x1c,%esp
f01076f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01076f8:	ba 1c 00 00 00       	mov    $0x1c,%edx
f01076fd:	89 d8                	mov    %ebx,%eax
f01076ff:	e8 00 fe ff ff       	call   f0107504 <pci_conf_read>
f0107704:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107706:	ba 18 00 00 00       	mov    $0x18,%edx
f010770b:	89 d8                	mov    %ebx,%eax
f010770d:	e8 f2 fd ff ff       	call   f0107504 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107712:	83 e7 0f             	and    $0xf,%edi
f0107715:	83 ff 01             	cmp    $0x1,%edi
f0107718:	74 56                	je     f0107770 <pci_bridge_attach+0x84>
f010771a:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f010771c:	83 ec 04             	sub    $0x4,%esp
f010771f:	6a 08                	push   $0x8
f0107721:	6a 00                	push   $0x0
f0107723:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107726:	57                   	push   %edi
f0107727:	e8 4e ee ff ff       	call   f010657a <memset>
	nbus.parent_bridge = pcif;
f010772c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f010772f:	89 f0                	mov    %esi,%eax
f0107731:	0f b6 c4             	movzbl %ah,%eax
f0107734:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107737:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f010773a:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f010773d:	89 f1                	mov    %esi,%ecx
f010773f:	0f b6 f1             	movzbl %cl,%esi
f0107742:	56                   	push   %esi
f0107743:	50                   	push   %eax
f0107744:	ff 73 08             	pushl  0x8(%ebx)
f0107747:	ff 73 04             	pushl  0x4(%ebx)
f010774a:	8b 03                	mov    (%ebx),%eax
f010774c:	ff 70 04             	pushl  0x4(%eax)
f010774f:	68 70 a0 10 f0       	push   $0xf010a070
f0107754:	e8 68 c7 ff ff       	call   f0103ec1 <cprintf>

	pci_scan_bus(&nbus);
f0107759:	83 c4 20             	add    $0x20,%esp
f010775c:	89 f8                	mov    %edi,%eax
f010775e:	e8 c6 fd ff ff       	call   f0107529 <pci_scan_bus>
	return 1;
f0107763:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107768:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010776b:	5b                   	pop    %ebx
f010776c:	5e                   	pop    %esi
f010776d:	5f                   	pop    %edi
f010776e:	5d                   	pop    %ebp
f010776f:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107770:	ff 73 08             	pushl  0x8(%ebx)
f0107773:	ff 73 04             	pushl  0x4(%ebx)
f0107776:	8b 03                	mov    (%ebx),%eax
f0107778:	ff 70 04             	pushl  0x4(%eax)
f010777b:	68 3c a0 10 f0       	push   $0xf010a03c
f0107780:	e8 3c c7 ff ff       	call   f0103ec1 <cprintf>
		return 0;
f0107785:	83 c4 10             	add    $0x10,%esp
f0107788:	b8 00 00 00 00       	mov    $0x0,%eax
f010778d:	eb d9                	jmp    f0107768 <pci_bridge_attach+0x7c>

f010778f <pci_conf_write>:
{
f010778f:	55                   	push   %ebp
f0107790:	89 e5                	mov    %esp,%ebp
f0107792:	56                   	push   %esi
f0107793:	53                   	push   %ebx
f0107794:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107796:	8b 48 08             	mov    0x8(%eax),%ecx
f0107799:	8b 70 04             	mov    0x4(%eax),%esi
f010779c:	8b 00                	mov    (%eax),%eax
f010779e:	8b 40 04             	mov    0x4(%eax),%eax
f01077a1:	83 ec 0c             	sub    $0xc,%esp
f01077a4:	52                   	push   %edx
f01077a5:	89 f2                	mov    %esi,%edx
f01077a7:	e8 a3 fc ff ff       	call   f010744f <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01077ac:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01077b1:	89 d8                	mov    %ebx,%eax
f01077b3:	ef                   	out    %eax,(%dx)
}
f01077b4:	83 c4 10             	add    $0x10,%esp
f01077b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01077ba:	5b                   	pop    %ebx
f01077bb:	5e                   	pop    %esi
f01077bc:	5d                   	pop    %ebp
f01077bd:	c3                   	ret    

f01077be <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f01077be:	55                   	push   %ebp
f01077bf:	89 e5                	mov    %esp,%ebp
f01077c1:	57                   	push   %edi
f01077c2:	56                   	push   %esi
f01077c3:	53                   	push   %ebx
f01077c4:	83 ec 2c             	sub    $0x2c,%esp
f01077c7:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f01077ca:	b9 07 00 00 00       	mov    $0x7,%ecx
f01077cf:	ba 04 00 00 00       	mov    $0x4,%edx
f01077d4:	89 f8                	mov    %edi,%eax
f01077d6:	e8 b4 ff ff ff       	call   f010778f <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01077db:	be 10 00 00 00       	mov    $0x10,%esi
f01077e0:	eb 27                	jmp    f0107809 <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01077e2:	89 c3                	mov    %eax,%ebx
f01077e4:	83 e3 fc             	and    $0xfffffffc,%ebx
f01077e7:	f7 db                	neg    %ebx
f01077e9:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f01077eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01077ee:	83 e0 fc             	and    $0xfffffffc,%eax
f01077f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f01077f4:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f01077fb:	eb 74                	jmp    f0107871 <pci_func_enable+0xb3>
	     bar += bar_width)
f01077fd:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107800:	83 fe 27             	cmp    $0x27,%esi
f0107803:	0f 87 c5 00 00 00    	ja     f01078ce <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f0107809:	89 f2                	mov    %esi,%edx
f010780b:	89 f8                	mov    %edi,%eax
f010780d:	e8 f2 fc ff ff       	call   f0107504 <pci_conf_read>
f0107812:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0107815:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f010781a:	89 f2                	mov    %esi,%edx
f010781c:	89 f8                	mov    %edi,%eax
f010781e:	e8 6c ff ff ff       	call   f010778f <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0107823:	89 f2                	mov    %esi,%edx
f0107825:	89 f8                	mov    %edi,%eax
f0107827:	e8 d8 fc ff ff       	call   f0107504 <pci_conf_read>
		bar_width = 4;
f010782c:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0107833:	85 c0                	test   %eax,%eax
f0107835:	74 c6                	je     f01077fd <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0107837:	8d 4e f0             	lea    -0x10(%esi),%ecx
f010783a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010783d:	c1 e9 02             	shr    $0x2,%ecx
f0107840:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107843:	a8 01                	test   $0x1,%al
f0107845:	75 9b                	jne    f01077e2 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107847:	89 c2                	mov    %eax,%edx
f0107849:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f010784c:	83 fa 04             	cmp    $0x4,%edx
f010784f:	0f 94 c1             	sete   %cl
f0107852:	0f b6 c9             	movzbl %cl,%ecx
f0107855:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f010785c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f010785f:	89 c3                	mov    %eax,%ebx
f0107861:	83 e3 f0             	and    $0xfffffff0,%ebx
f0107864:	f7 db                	neg    %ebx
f0107866:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107868:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010786b:	83 e0 f0             	and    $0xfffffff0,%eax
f010786e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107871:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0107874:	89 f2                	mov    %esi,%edx
f0107876:	89 f8                	mov    %edi,%eax
f0107878:	e8 12 ff ff ff       	call   f010778f <pci_conf_write>
f010787d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0107880:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0107882:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107885:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0107888:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f010788b:	85 db                	test   %ebx,%ebx
f010788d:	0f 84 6a ff ff ff    	je     f01077fd <pci_func_enable+0x3f>
f0107893:	85 d2                	test   %edx,%edx
f0107895:	0f 85 62 ff ff ff    	jne    f01077fd <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010789b:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f010789e:	83 ec 0c             	sub    $0xc,%esp
f01078a1:	53                   	push   %ebx
f01078a2:	6a 00                	push   $0x0
f01078a4:	ff 75 d4             	pushl  -0x2c(%ebp)
f01078a7:	89 c2                	mov    %eax,%edx
f01078a9:	c1 ea 10             	shr    $0x10,%edx
f01078ac:	52                   	push   %edx
f01078ad:	0f b7 c0             	movzwl %ax,%eax
f01078b0:	50                   	push   %eax
f01078b1:	ff 77 08             	pushl  0x8(%edi)
f01078b4:	ff 77 04             	pushl  0x4(%edi)
f01078b7:	8b 07                	mov    (%edi),%eax
f01078b9:	ff 70 04             	pushl  0x4(%eax)
f01078bc:	68 a0 a0 10 f0       	push   $0xf010a0a0
f01078c1:	e8 fb c5 ff ff       	call   f0103ec1 <cprintf>
f01078c6:	83 c4 30             	add    $0x30,%esp
f01078c9:	e9 2f ff ff ff       	jmp    f01077fd <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f01078ce:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f01078d1:	83 ec 08             	sub    $0x8,%esp
f01078d4:	89 c2                	mov    %eax,%edx
f01078d6:	c1 ea 10             	shr    $0x10,%edx
f01078d9:	52                   	push   %edx
f01078da:	0f b7 c0             	movzwl %ax,%eax
f01078dd:	50                   	push   %eax
f01078de:	ff 77 08             	pushl  0x8(%edi)
f01078e1:	ff 77 04             	pushl  0x4(%edi)
f01078e4:	8b 07                	mov    (%edi),%eax
f01078e6:	ff 70 04             	pushl  0x4(%eax)
f01078e9:	68 fc a0 10 f0       	push   $0xf010a0fc
f01078ee:	e8 ce c5 ff ff       	call   f0103ec1 <cprintf>
}
f01078f3:	83 c4 20             	add    $0x20,%esp
f01078f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01078f9:	5b                   	pop    %ebx
f01078fa:	5e                   	pop    %esi
f01078fb:	5f                   	pop    %edi
f01078fc:	5d                   	pop    %ebp
f01078fd:	c3                   	ret    

f01078fe <pci_init>:

int
pci_init(void)
{
f01078fe:	55                   	push   %ebp
f01078ff:	89 e5                	mov    %esp,%ebp
f0107901:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107904:	6a 08                	push   $0x8
f0107906:	6a 00                	push   $0x0
f0107908:	68 84 ee 57 f0       	push   $0xf057ee84
f010790d:	e8 68 ec ff ff       	call   f010657a <memset>

	return pci_scan_bus(&root_bus);
f0107912:	b8 84 ee 57 f0       	mov    $0xf057ee84,%eax
f0107917:	e8 0d fc ff ff       	call   f0107529 <pci_scan_bus>
}
f010791c:	c9                   	leave  
f010791d:	c3                   	ret    

f010791e <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f010791e:	c7 05 8c ee 57 f0 00 	movl   $0x0,0xf057ee8c
f0107925:	00 00 00 
}
f0107928:	c3                   	ret    

f0107929 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f0107929:	a1 8c ee 57 f0       	mov    0xf057ee8c,%eax
f010792e:	83 c0 01             	add    $0x1,%eax
f0107931:	a3 8c ee 57 f0       	mov    %eax,0xf057ee8c
	if (ticks * 10 < ticks)
f0107936:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107939:	01 d2                	add    %edx,%edx
f010793b:	39 d0                	cmp    %edx,%eax
f010793d:	77 01                	ja     f0107940 <time_tick+0x17>
f010793f:	c3                   	ret    
{
f0107940:	55                   	push   %ebp
f0107941:	89 e5                	mov    %esp,%ebp
f0107943:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0107946:	68 04 a2 10 f0       	push   $0xf010a204
f010794b:	6a 13                	push   $0x13
f010794d:	68 1f a2 10 f0       	push   $0xf010a21f
f0107952:	e8 f2 86 ff ff       	call   f0100049 <_panic>

f0107957 <time_msec>:
}

unsigned int
time_msec(void)
{
	return ticks * 10;
f0107957:	a1 8c ee 57 f0       	mov    0xf057ee8c,%eax
f010795c:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010795f:	01 c0                	add    %eax,%eax
}
f0107961:	c3                   	ret    
f0107962:	66 90                	xchg   %ax,%ax
f0107964:	66 90                	xchg   %ax,%ax
f0107966:	66 90                	xchg   %ax,%ax
f0107968:	66 90                	xchg   %ax,%ax
f010796a:	66 90                	xchg   %ax,%ax
f010796c:	66 90                	xchg   %ax,%ax
f010796e:	66 90                	xchg   %ax,%ax

f0107970 <__udivdi3>:
f0107970:	55                   	push   %ebp
f0107971:	57                   	push   %edi
f0107972:	56                   	push   %esi
f0107973:	53                   	push   %ebx
f0107974:	83 ec 1c             	sub    $0x1c,%esp
f0107977:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010797b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010797f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0107983:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0107987:	85 d2                	test   %edx,%edx
f0107989:	75 4d                	jne    f01079d8 <__udivdi3+0x68>
f010798b:	39 f3                	cmp    %esi,%ebx
f010798d:	76 19                	jbe    f01079a8 <__udivdi3+0x38>
f010798f:	31 ff                	xor    %edi,%edi
f0107991:	89 e8                	mov    %ebp,%eax
f0107993:	89 f2                	mov    %esi,%edx
f0107995:	f7 f3                	div    %ebx
f0107997:	89 fa                	mov    %edi,%edx
f0107999:	83 c4 1c             	add    $0x1c,%esp
f010799c:	5b                   	pop    %ebx
f010799d:	5e                   	pop    %esi
f010799e:	5f                   	pop    %edi
f010799f:	5d                   	pop    %ebp
f01079a0:	c3                   	ret    
f01079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01079a8:	89 d9                	mov    %ebx,%ecx
f01079aa:	85 db                	test   %ebx,%ebx
f01079ac:	75 0b                	jne    f01079b9 <__udivdi3+0x49>
f01079ae:	b8 01 00 00 00       	mov    $0x1,%eax
f01079b3:	31 d2                	xor    %edx,%edx
f01079b5:	f7 f3                	div    %ebx
f01079b7:	89 c1                	mov    %eax,%ecx
f01079b9:	31 d2                	xor    %edx,%edx
f01079bb:	89 f0                	mov    %esi,%eax
f01079bd:	f7 f1                	div    %ecx
f01079bf:	89 c6                	mov    %eax,%esi
f01079c1:	89 e8                	mov    %ebp,%eax
f01079c3:	89 f7                	mov    %esi,%edi
f01079c5:	f7 f1                	div    %ecx
f01079c7:	89 fa                	mov    %edi,%edx
f01079c9:	83 c4 1c             	add    $0x1c,%esp
f01079cc:	5b                   	pop    %ebx
f01079cd:	5e                   	pop    %esi
f01079ce:	5f                   	pop    %edi
f01079cf:	5d                   	pop    %ebp
f01079d0:	c3                   	ret    
f01079d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01079d8:	39 f2                	cmp    %esi,%edx
f01079da:	77 1c                	ja     f01079f8 <__udivdi3+0x88>
f01079dc:	0f bd fa             	bsr    %edx,%edi
f01079df:	83 f7 1f             	xor    $0x1f,%edi
f01079e2:	75 2c                	jne    f0107a10 <__udivdi3+0xa0>
f01079e4:	39 f2                	cmp    %esi,%edx
f01079e6:	72 06                	jb     f01079ee <__udivdi3+0x7e>
f01079e8:	31 c0                	xor    %eax,%eax
f01079ea:	39 eb                	cmp    %ebp,%ebx
f01079ec:	77 a9                	ja     f0107997 <__udivdi3+0x27>
f01079ee:	b8 01 00 00 00       	mov    $0x1,%eax
f01079f3:	eb a2                	jmp    f0107997 <__udivdi3+0x27>
f01079f5:	8d 76 00             	lea    0x0(%esi),%esi
f01079f8:	31 ff                	xor    %edi,%edi
f01079fa:	31 c0                	xor    %eax,%eax
f01079fc:	89 fa                	mov    %edi,%edx
f01079fe:	83 c4 1c             	add    $0x1c,%esp
f0107a01:	5b                   	pop    %ebx
f0107a02:	5e                   	pop    %esi
f0107a03:	5f                   	pop    %edi
f0107a04:	5d                   	pop    %ebp
f0107a05:	c3                   	ret    
f0107a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107a0d:	8d 76 00             	lea    0x0(%esi),%esi
f0107a10:	89 f9                	mov    %edi,%ecx
f0107a12:	b8 20 00 00 00       	mov    $0x20,%eax
f0107a17:	29 f8                	sub    %edi,%eax
f0107a19:	d3 e2                	shl    %cl,%edx
f0107a1b:	89 54 24 08          	mov    %edx,0x8(%esp)
f0107a1f:	89 c1                	mov    %eax,%ecx
f0107a21:	89 da                	mov    %ebx,%edx
f0107a23:	d3 ea                	shr    %cl,%edx
f0107a25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107a29:	09 d1                	or     %edx,%ecx
f0107a2b:	89 f2                	mov    %esi,%edx
f0107a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107a31:	89 f9                	mov    %edi,%ecx
f0107a33:	d3 e3                	shl    %cl,%ebx
f0107a35:	89 c1                	mov    %eax,%ecx
f0107a37:	d3 ea                	shr    %cl,%edx
f0107a39:	89 f9                	mov    %edi,%ecx
f0107a3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107a3f:	89 eb                	mov    %ebp,%ebx
f0107a41:	d3 e6                	shl    %cl,%esi
f0107a43:	89 c1                	mov    %eax,%ecx
f0107a45:	d3 eb                	shr    %cl,%ebx
f0107a47:	09 de                	or     %ebx,%esi
f0107a49:	89 f0                	mov    %esi,%eax
f0107a4b:	f7 74 24 08          	divl   0x8(%esp)
f0107a4f:	89 d6                	mov    %edx,%esi
f0107a51:	89 c3                	mov    %eax,%ebx
f0107a53:	f7 64 24 0c          	mull   0xc(%esp)
f0107a57:	39 d6                	cmp    %edx,%esi
f0107a59:	72 15                	jb     f0107a70 <__udivdi3+0x100>
f0107a5b:	89 f9                	mov    %edi,%ecx
f0107a5d:	d3 e5                	shl    %cl,%ebp
f0107a5f:	39 c5                	cmp    %eax,%ebp
f0107a61:	73 04                	jae    f0107a67 <__udivdi3+0xf7>
f0107a63:	39 d6                	cmp    %edx,%esi
f0107a65:	74 09                	je     f0107a70 <__udivdi3+0x100>
f0107a67:	89 d8                	mov    %ebx,%eax
f0107a69:	31 ff                	xor    %edi,%edi
f0107a6b:	e9 27 ff ff ff       	jmp    f0107997 <__udivdi3+0x27>
f0107a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107a73:	31 ff                	xor    %edi,%edi
f0107a75:	e9 1d ff ff ff       	jmp    f0107997 <__udivdi3+0x27>
f0107a7a:	66 90                	xchg   %ax,%ax
f0107a7c:	66 90                	xchg   %ax,%ax
f0107a7e:	66 90                	xchg   %ax,%ax

f0107a80 <__umoddi3>:
f0107a80:	55                   	push   %ebp
f0107a81:	57                   	push   %edi
f0107a82:	56                   	push   %esi
f0107a83:	53                   	push   %ebx
f0107a84:	83 ec 1c             	sub    $0x1c,%esp
f0107a87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0107a8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0107a8f:	8b 74 24 30          	mov    0x30(%esp),%esi
f0107a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107a97:	89 da                	mov    %ebx,%edx
f0107a99:	85 c0                	test   %eax,%eax
f0107a9b:	75 43                	jne    f0107ae0 <__umoddi3+0x60>
f0107a9d:	39 df                	cmp    %ebx,%edi
f0107a9f:	76 17                	jbe    f0107ab8 <__umoddi3+0x38>
f0107aa1:	89 f0                	mov    %esi,%eax
f0107aa3:	f7 f7                	div    %edi
f0107aa5:	89 d0                	mov    %edx,%eax
f0107aa7:	31 d2                	xor    %edx,%edx
f0107aa9:	83 c4 1c             	add    $0x1c,%esp
f0107aac:	5b                   	pop    %ebx
f0107aad:	5e                   	pop    %esi
f0107aae:	5f                   	pop    %edi
f0107aaf:	5d                   	pop    %ebp
f0107ab0:	c3                   	ret    
f0107ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107ab8:	89 fd                	mov    %edi,%ebp
f0107aba:	85 ff                	test   %edi,%edi
f0107abc:	75 0b                	jne    f0107ac9 <__umoddi3+0x49>
f0107abe:	b8 01 00 00 00       	mov    $0x1,%eax
f0107ac3:	31 d2                	xor    %edx,%edx
f0107ac5:	f7 f7                	div    %edi
f0107ac7:	89 c5                	mov    %eax,%ebp
f0107ac9:	89 d8                	mov    %ebx,%eax
f0107acb:	31 d2                	xor    %edx,%edx
f0107acd:	f7 f5                	div    %ebp
f0107acf:	89 f0                	mov    %esi,%eax
f0107ad1:	f7 f5                	div    %ebp
f0107ad3:	89 d0                	mov    %edx,%eax
f0107ad5:	eb d0                	jmp    f0107aa7 <__umoddi3+0x27>
f0107ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107ade:	66 90                	xchg   %ax,%ax
f0107ae0:	89 f1                	mov    %esi,%ecx
f0107ae2:	39 d8                	cmp    %ebx,%eax
f0107ae4:	76 0a                	jbe    f0107af0 <__umoddi3+0x70>
f0107ae6:	89 f0                	mov    %esi,%eax
f0107ae8:	83 c4 1c             	add    $0x1c,%esp
f0107aeb:	5b                   	pop    %ebx
f0107aec:	5e                   	pop    %esi
f0107aed:	5f                   	pop    %edi
f0107aee:	5d                   	pop    %ebp
f0107aef:	c3                   	ret    
f0107af0:	0f bd e8             	bsr    %eax,%ebp
f0107af3:	83 f5 1f             	xor    $0x1f,%ebp
f0107af6:	75 20                	jne    f0107b18 <__umoddi3+0x98>
f0107af8:	39 d8                	cmp    %ebx,%eax
f0107afa:	0f 82 b0 00 00 00    	jb     f0107bb0 <__umoddi3+0x130>
f0107b00:	39 f7                	cmp    %esi,%edi
f0107b02:	0f 86 a8 00 00 00    	jbe    f0107bb0 <__umoddi3+0x130>
f0107b08:	89 c8                	mov    %ecx,%eax
f0107b0a:	83 c4 1c             	add    $0x1c,%esp
f0107b0d:	5b                   	pop    %ebx
f0107b0e:	5e                   	pop    %esi
f0107b0f:	5f                   	pop    %edi
f0107b10:	5d                   	pop    %ebp
f0107b11:	c3                   	ret    
f0107b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107b18:	89 e9                	mov    %ebp,%ecx
f0107b1a:	ba 20 00 00 00       	mov    $0x20,%edx
f0107b1f:	29 ea                	sub    %ebp,%edx
f0107b21:	d3 e0                	shl    %cl,%eax
f0107b23:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107b27:	89 d1                	mov    %edx,%ecx
f0107b29:	89 f8                	mov    %edi,%eax
f0107b2b:	d3 e8                	shr    %cl,%eax
f0107b2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107b31:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107b35:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107b39:	09 c1                	or     %eax,%ecx
f0107b3b:	89 d8                	mov    %ebx,%eax
f0107b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107b41:	89 e9                	mov    %ebp,%ecx
f0107b43:	d3 e7                	shl    %cl,%edi
f0107b45:	89 d1                	mov    %edx,%ecx
f0107b47:	d3 e8                	shr    %cl,%eax
f0107b49:	89 e9                	mov    %ebp,%ecx
f0107b4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0107b4f:	d3 e3                	shl    %cl,%ebx
f0107b51:	89 c7                	mov    %eax,%edi
f0107b53:	89 d1                	mov    %edx,%ecx
f0107b55:	89 f0                	mov    %esi,%eax
f0107b57:	d3 e8                	shr    %cl,%eax
f0107b59:	89 e9                	mov    %ebp,%ecx
f0107b5b:	89 fa                	mov    %edi,%edx
f0107b5d:	d3 e6                	shl    %cl,%esi
f0107b5f:	09 d8                	or     %ebx,%eax
f0107b61:	f7 74 24 08          	divl   0x8(%esp)
f0107b65:	89 d1                	mov    %edx,%ecx
f0107b67:	89 f3                	mov    %esi,%ebx
f0107b69:	f7 64 24 0c          	mull   0xc(%esp)
f0107b6d:	89 c6                	mov    %eax,%esi
f0107b6f:	89 d7                	mov    %edx,%edi
f0107b71:	39 d1                	cmp    %edx,%ecx
f0107b73:	72 06                	jb     f0107b7b <__umoddi3+0xfb>
f0107b75:	75 10                	jne    f0107b87 <__umoddi3+0x107>
f0107b77:	39 c3                	cmp    %eax,%ebx
f0107b79:	73 0c                	jae    f0107b87 <__umoddi3+0x107>
f0107b7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f0107b7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0107b83:	89 d7                	mov    %edx,%edi
f0107b85:	89 c6                	mov    %eax,%esi
f0107b87:	89 ca                	mov    %ecx,%edx
f0107b89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107b8e:	29 f3                	sub    %esi,%ebx
f0107b90:	19 fa                	sbb    %edi,%edx
f0107b92:	89 d0                	mov    %edx,%eax
f0107b94:	d3 e0                	shl    %cl,%eax
f0107b96:	89 e9                	mov    %ebp,%ecx
f0107b98:	d3 eb                	shr    %cl,%ebx
f0107b9a:	d3 ea                	shr    %cl,%edx
f0107b9c:	09 d8                	or     %ebx,%eax
f0107b9e:	83 c4 1c             	add    $0x1c,%esp
f0107ba1:	5b                   	pop    %ebx
f0107ba2:	5e                   	pop    %esi
f0107ba3:	5f                   	pop    %edi
f0107ba4:	5d                   	pop    %ebp
f0107ba5:	c3                   	ret    
f0107ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107bad:	8d 76 00             	lea    0x0(%esi),%esi
f0107bb0:	89 da                	mov    %ebx,%edx
f0107bb2:	29 fe                	sub    %edi,%esi
f0107bb4:	19 c2                	sbb    %eax,%edx
f0107bb6:	89 f1                	mov    %esi,%ecx
f0107bb8:	89 c8                	mov    %ecx,%eax
f0107bba:	e9 4b ff ff ff       	jmp    f0107b0a <__umoddi3+0x8a>
