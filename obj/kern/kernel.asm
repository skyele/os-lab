
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
f010005f:	e8 ed 0b 00 00       	call   f0100c51 <monitor>
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
f0100074:	e8 35 6a 00 00       	call   f0106aae <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 80 76 10 f0       	push   $0xf0107680
f0100085:	e8 d6 3d 00 00       	call   f0103e60 <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 a6 3d 00 00       	call   f0103e3a <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 7b 8b 10 f0 	movl   $0xf0108b7b,(%esp)
f010009b:	e8 c0 3d 00 00       	call   f0103e60 <cprintf>
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
f01000b6:	68 a4 76 10 f0       	push   $0xf01076a4
f01000bb:	e8 a0 3d 00 00       	call   f0103e60 <cprintf>
	cprintf("%n", NULL);
f01000c0:	83 c4 08             	add    $0x8,%esp
f01000c3:	6a 00                	push   $0x0
f01000c5:	68 1c 77 10 f0       	push   $0xf010771c
f01000ca:	e8 91 3d 00 00       	call   f0103e60 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000cf:	83 c4 0c             	add    $0xc,%esp
f01000d2:	68 00 fc ff ff       	push   $0xfffffc00
f01000d7:	68 00 04 00 00       	push   $0x400
f01000dc:	68 1f 77 10 f0       	push   $0xf010771f
f01000e1:	e8 7a 3d 00 00       	call   f0103e60 <cprintf>
	mem_init();
f01000e6:	e8 57 16 00 00       	call   f0101742 <mem_init>
	env_init();
f01000eb:	e8 04 35 00 00       	call   f01035f4 <env_init>
	trap_init();
f01000f0:	e8 4f 3e 00 00       	call   f0103f44 <trap_init>
	mp_init();
f01000f5:	e8 bd 66 00 00       	call   f01067b7 <mp_init>
	lapic_init();
f01000fa:	e8 c5 69 00 00       	call   f0106ac4 <lapic_init>
	pic_init();
f01000ff:	e8 61 3c 00 00       	call   f0103d65 <pic_init>
	time_init();
f0100104:	e8 e2 72 00 00       	call   f01073eb <time_init>
	pci_init();
f0100109:	e8 bd 72 00 00       	call   f01073cb <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010010e:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f0100115:	e8 04 6c 00 00       	call   f0106d1e <spin_lock>
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
f0100129:	b8 1a 67 10 f0       	mov    $0xf010671a,%eax
f010012e:	2d 98 66 10 f0       	sub    $0xf0106698,%eax
f0100133:	50                   	push   %eax
f0100134:	68 98 66 10 f0       	push   $0xf0106698
f0100139:	68 00 70 00 f0       	push   $0xf0007000
f010013e:	e8 aa 63 00 00       	call   f01064ed <memmove>
f0100143:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100146:	bb 20 c0 57 f0       	mov    $0xf057c020,%ebx
f010014b:	eb 19                	jmp    f0100166 <i386_init+0xc1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010014d:	68 00 70 00 00       	push   $0x7000
f0100152:	68 d4 76 10 f0       	push   $0xf01076d4
f0100157:	6a 65                	push   $0x65
f0100159:	68 3b 77 10 f0       	push   $0xf010773b
f010015e:	e8 e6 fe ff ff       	call   f0100049 <_panic>
f0100163:	83 c3 74             	add    $0x74,%ebx
f0100166:	6b 05 c4 c3 57 f0 74 	imul   $0x74,0xf057c3c4,%eax
f010016d:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0100172:	39 c3                	cmp    %eax,%ebx
f0100174:	73 4d                	jae    f01001c3 <i386_init+0x11e>
		if (c == cpus + cpunum())  // We've started already.
f0100176:	e8 33 69 00 00       	call   f0106aae <cpunum>
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
f01001b1:	e8 60 6a 00 00       	call   f0106c16 <lapic_startap>
f01001b6:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f01001b9:	8b 43 04             	mov    0x4(%ebx),%eax
f01001bc:	83 f8 01             	cmp    $0x1,%eax
f01001bf:	75 f8                	jne    f01001b9 <i386_init+0x114>
f01001c1:	eb a0                	jmp    f0100163 <i386_init+0xbe>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001c3:	83 ec 08             	sub    $0x8,%esp
f01001c6:	6a 01                	push   $0x1
f01001c8:	68 ec ea 3e f0       	push   $0xf03eeaec
f01001cd:	e8 f4 35 00 00       	call   f01037c6 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001d2:	83 c4 08             	add    $0x8,%esp
f01001d5:	6a 00                	push   $0x0
f01001d7:	68 fc c3 40 f0       	push   $0xf040c3fc
f01001dc:	e8 e5 35 00 00       	call   f01037c6 <env_create>
	kbd_intr();
f01001e1:	e8 32 04 00 00       	call   f0100618 <kbd_intr>
	sched_yield();
f01001e6:	e8 23 4c 00 00       	call   f0104e0e <sched_yield>

f01001eb <mp_main>:
{
f01001eb:	55                   	push   %ebp
f01001ec:	89 e5                	mov    %esp,%ebp
f01001ee:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001f1:	a1 ac be 57 f0       	mov    0xf057beac,%eax
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
f0100205:	e8 a4 68 00 00       	call   f0106aae <cpunum>
f010020a:	83 ec 08             	sub    $0x8,%esp
f010020d:	50                   	push   %eax
f010020e:	68 47 77 10 f0       	push   $0xf0107747
f0100213:	e8 48 3c 00 00       	call   f0103e60 <cprintf>
	lapic_init();
f0100218:	e8 a7 68 00 00       	call   f0106ac4 <lapic_init>
	env_init_percpu();
f010021d:	e8 a6 33 00 00       	call   f01035c8 <env_init_percpu>
	trap_init_percpu();
f0100222:	e8 4d 3c 00 00       	call   f0103e74 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100227:	e8 82 68 00 00       	call   f0106aae <cpunum>
f010022c:	6b d0 74             	imul   $0x74,%eax,%edx
f010022f:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100232:	b8 01 00 00 00       	mov    $0x1,%eax
f0100237:	f0 87 82 20 c0 57 f0 	lock xchg %eax,-0xfa83fe0(%edx)
f010023e:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f0100245:	e8 d4 6a 00 00       	call   f0106d1e <spin_lock>
	sched_yield();
f010024a:	e8 bf 4b 00 00       	call   f0104e0e <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010024f:	50                   	push   %eax
f0100250:	68 f8 76 10 f0       	push   $0xf01076f8
f0100255:	6a 7d                	push   $0x7d
f0100257:	68 3b 77 10 f0       	push   $0xf010773b
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
f0100271:	68 5d 77 10 f0       	push   $0xf010775d
f0100276:	e8 e5 3b 00 00       	call   f0103e60 <cprintf>
	vcprintf(fmt, ap);
f010027b:	83 c4 08             	add    $0x8,%esp
f010027e:	53                   	push   %ebx
f010027f:	ff 75 10             	pushl  0x10(%ebp)
f0100282:	e8 b3 3b 00 00       	call   f0103e3a <vcprintf>
	cprintf("\n");
f0100287:	c7 04 24 7b 8b 10 f0 	movl   $0xf0108b7b,(%esp)
f010028e:	e8 cd 3b 00 00       	call   f0103e60 <cprintf>
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
f01002c9:	8b 0d 24 a2 57 f0    	mov    0xf057a224,%ecx
f01002cf:	8d 51 01             	lea    0x1(%ecx),%edx
f01002d2:	88 81 20 a0 57 f0    	mov    %al,-0xfa85fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002d8:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002de:	b8 00 00 00 00       	mov    $0x0,%eax
f01002e3:	0f 44 d0             	cmove  %eax,%edx
f01002e6:	89 15 24 a2 57 f0    	mov    %edx,0xf057a224
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
f0100321:	8b 0d 00 a0 57 f0    	mov    0xf057a000,%ecx
f0100327:	f6 c1 40             	test   $0x40,%cl
f010032a:	74 0e                	je     f010033a <kbd_proc_data+0x46>
		data |= 0x80;
f010032c:	83 c8 80             	or     $0xffffff80,%eax
f010032f:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100331:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100334:	89 0d 00 a0 57 f0    	mov    %ecx,0xf057a000
	shift |= shiftcode[data];
f010033a:	0f b6 d2             	movzbl %dl,%edx
f010033d:	0f b6 82 c0 78 10 f0 	movzbl -0xfef8740(%edx),%eax
f0100344:	0b 05 00 a0 57 f0    	or     0xf057a000,%eax
	shift ^= togglecode[data];
f010034a:	0f b6 8a c0 77 10 f0 	movzbl -0xfef8840(%edx),%ecx
f0100351:	31 c8                	xor    %ecx,%eax
f0100353:	a3 00 a0 57 f0       	mov    %eax,0xf057a000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100358:	89 c1                	mov    %eax,%ecx
f010035a:	83 e1 03             	and    $0x3,%ecx
f010035d:	8b 0c 8d a0 77 10 f0 	mov    -0xfef8860(,%ecx,4),%ecx
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
f010037e:	83 0d 00 a0 57 f0 40 	orl    $0x40,0xf057a000
		return 0;
f0100385:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010038a:	89 d8                	mov    %ebx,%eax
f010038c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010038f:	c9                   	leave  
f0100390:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100391:	8b 0d 00 a0 57 f0    	mov    0xf057a000,%ecx
f0100397:	89 cb                	mov    %ecx,%ebx
f0100399:	83 e3 40             	and    $0x40,%ebx
f010039c:	83 e0 7f             	and    $0x7f,%eax
f010039f:	85 db                	test   %ebx,%ebx
f01003a1:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003a4:	0f b6 d2             	movzbl %dl,%edx
f01003a7:	0f b6 82 c0 78 10 f0 	movzbl -0xfef8740(%edx),%eax
f01003ae:	83 c8 40             	or     $0x40,%eax
f01003b1:	0f b6 c0             	movzbl %al,%eax
f01003b4:	f7 d0                	not    %eax
f01003b6:	21 c8                	and    %ecx,%eax
f01003b8:	a3 00 a0 57 f0       	mov    %eax,0xf057a000
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
f01003e1:	68 77 77 10 f0       	push   $0xf0107777
f01003e6:	e8 75 3a 00 00       	call   f0103e60 <cprintf>
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
f01004be:	0f b7 05 28 a2 57 f0 	movzwl 0xf057a228,%eax
f01004c5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004cb:	c1 e8 16             	shr    $0x16,%eax
f01004ce:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004d1:	c1 e0 04             	shl    $0x4,%eax
f01004d4:	66 a3 28 a2 57 f0    	mov    %ax,0xf057a228
	if (crt_pos >= CRT_SIZE) {
f01004da:	66 81 3d 28 a2 57 f0 	cmpw   $0x7cf,0xf057a228
f01004e1:	cf 07 
f01004e3:	0f 87 cb 00 00 00    	ja     f01005b4 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004e9:	8b 0d 30 a2 57 f0    	mov    0xf057a230,%ecx
f01004ef:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004f4:	89 ca                	mov    %ecx,%edx
f01004f6:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004f7:	0f b7 1d 28 a2 57 f0 	movzwl 0xf057a228,%ebx
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
f0100524:	0f b7 05 28 a2 57 f0 	movzwl 0xf057a228,%eax
f010052b:	66 85 c0             	test   %ax,%ax
f010052e:	74 b9                	je     f01004e9 <cons_putc+0xe0>
			crt_pos--;
f0100530:	83 e8 01             	sub    $0x1,%eax
f0100533:	66 a3 28 a2 57 f0    	mov    %ax,0xf057a228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100539:	0f b7 c0             	movzwl %ax,%eax
f010053c:	b1 00                	mov    $0x0,%cl
f010053e:	83 c9 20             	or     $0x20,%ecx
f0100541:	8b 15 2c a2 57 f0    	mov    0xf057a22c,%edx
f0100547:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010054b:	eb 8d                	jmp    f01004da <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f010054d:	66 83 05 28 a2 57 f0 	addw   $0x50,0xf057a228
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
f0100591:	0f b7 05 28 a2 57 f0 	movzwl 0xf057a228,%eax
f0100598:	8d 50 01             	lea    0x1(%eax),%edx
f010059b:	66 89 15 28 a2 57 f0 	mov    %dx,0xf057a228
f01005a2:	0f b7 c0             	movzwl %ax,%eax
f01005a5:	8b 15 2c a2 57 f0    	mov    0xf057a22c,%edx
f01005ab:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005af:	e9 26 ff ff ff       	jmp    f01004da <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005b4:	a1 2c a2 57 f0       	mov    0xf057a22c,%eax
f01005b9:	83 ec 04             	sub    $0x4,%esp
f01005bc:	68 00 0f 00 00       	push   $0xf00
f01005c1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005c7:	52                   	push   %edx
f01005c8:	50                   	push   %eax
f01005c9:	e8 1f 5f 00 00       	call   f01064ed <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005ce:	8b 15 2c a2 57 f0    	mov    0xf057a22c,%edx
f01005d4:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005da:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005e0:	83 c4 10             	add    $0x10,%esp
f01005e3:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e8:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005eb:	39 d0                	cmp    %edx,%eax
f01005ed:	75 f4                	jne    f01005e3 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005ef:	66 83 2d 28 a2 57 f0 	subw   $0x50,0xf057a228
f01005f6:	50 
f01005f7:	e9 ed fe ff ff       	jmp    f01004e9 <cons_putc+0xe0>

f01005fc <serial_intr>:
	if (serial_exists)
f01005fc:	80 3d 34 a2 57 f0 00 	cmpb   $0x0,0xf057a234
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
f010063a:	8b 15 20 a2 57 f0    	mov    0xf057a220,%edx
	return 0;
f0100640:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100645:	3b 15 24 a2 57 f0    	cmp    0xf057a224,%edx
f010064b:	74 1e                	je     f010066b <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010064d:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100650:	0f b6 82 20 a0 57 f0 	movzbl -0xfa85fe0(%edx),%eax
			cons.rpos = 0;
f0100657:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010065d:	ba 00 00 00 00       	mov    $0x0,%edx
f0100662:	0f 44 ca             	cmove  %edx,%ecx
f0100665:	89 0d 20 a2 57 f0    	mov    %ecx,0xf057a220
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
f0100697:	c7 05 30 a2 57 f0 b4 	movl   $0x3b4,0xf057a230
f010069e:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006a1:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006a6:	8b 3d 30 a2 57 f0    	mov    0xf057a230,%edi
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
f01006cd:	89 35 2c a2 57 f0    	mov    %esi,0xf057a22c
	pos |= inb(addr_6845 + 1);
f01006d3:	0f b6 c0             	movzbl %al,%eax
f01006d6:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006d8:	66 a3 28 a2 57 f0    	mov    %ax,0xf057a228
	kbd_intr();
f01006de:	e8 35 ff ff ff       	call   f0100618 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006e3:	83 ec 0c             	sub    $0xc,%esp
f01006e6:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f01006ed:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006f2:	50                   	push   %eax
f01006f3:	e8 ef 35 00 00       	call   f0103ce7 <irq_setmask_8259A>
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
f010074e:	0f 95 05 34 a2 57 f0 	setne  0xf057a234
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
f0100766:	68 83 77 10 f0       	push   $0xf0107783
f010076b:	e8 f0 36 00 00       	call   f0103e60 <cprintf>
f0100770:	83 c4 10             	add    $0x10,%esp
}
f0100773:	eb 3c                	jmp    f01007b1 <cons_init+0x144>
		*cp = was;
f0100775:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010077c:	c7 05 30 a2 57 f0 d4 	movl   $0x3d4,0xf057a230
f0100783:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100786:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010078b:	e9 16 ff ff ff       	jmp    f01006a6 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100790:	83 ec 0c             	sub    $0xc,%esp
f0100793:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f010079a:	25 ef ff 00 00       	and    $0xffef,%eax
f010079f:	50                   	push   %eax
f01007a0:	e8 42 35 00 00       	call   f0103ce7 <irq_setmask_8259A>
	if (!serial_exists)
f01007a5:	83 c4 10             	add    $0x10,%esp
f01007a8:	80 3d 34 a2 57 f0 00 	cmpb   $0x0,0xf057a234
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
f01007ef:	ff b3 24 7e 10 f0    	pushl  -0xfef81dc(%ebx)
f01007f5:	ff b3 20 7e 10 f0    	pushl  -0xfef81e0(%ebx)
f01007fb:	68 c0 79 10 f0       	push   $0xf01079c0
f0100800:	e8 5b 36 00 00       	call   f0103e60 <cprintf>
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
f0100820:	68 c9 79 10 f0       	push   $0xf01079c9
f0100825:	e8 36 36 00 00       	call   f0103e60 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010082a:	83 c4 08             	add    $0x8,%esp
f010082d:	68 0c 00 10 00       	push   $0x10000c
f0100832:	68 2c 7b 10 f0       	push   $0xf0107b2c
f0100837:	e8 24 36 00 00       	call   f0103e60 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010083c:	83 c4 0c             	add    $0xc,%esp
f010083f:	68 0c 00 10 00       	push   $0x10000c
f0100844:	68 0c 00 10 f0       	push   $0xf010000c
f0100849:	68 54 7b 10 f0       	push   $0xf0107b54
f010084e:	e8 0d 36 00 00       	call   f0103e60 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100853:	83 c4 0c             	add    $0xc,%esp
f0100856:	68 7f 76 10 00       	push   $0x10767f
f010085b:	68 7f 76 10 f0       	push   $0xf010767f
f0100860:	68 78 7b 10 f0       	push   $0xf0107b78
f0100865:	e8 f6 35 00 00       	call   f0103e60 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010086a:	83 c4 0c             	add    $0xc,%esp
f010086d:	68 00 a0 57 00       	push   $0x57a000
f0100872:	68 00 a0 57 f0       	push   $0xf057a000
f0100877:	68 9c 7b 10 f0       	push   $0xf0107b9c
f010087c:	e8 df 35 00 00       	call   f0103e60 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100881:	83 c4 0c             	add    $0xc,%esp
f0100884:	68 10 d0 5b 00       	push   $0x5bd010
f0100889:	68 10 d0 5b f0       	push   $0xf05bd010
f010088e:	68 c0 7b 10 f0       	push   $0xf0107bc0
f0100893:	e8 c8 35 00 00       	call   f0103e60 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100898:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010089b:	b8 10 d0 5b f0       	mov    $0xf05bd010,%eax
f01008a0:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a5:	c1 f8 0a             	sar    $0xa,%eax
f01008a8:	50                   	push   %eax
f01008a9:	68 e4 7b 10 f0       	push   $0xf0107be4
f01008ae:	e8 ad 35 00 00       	call   f0103e60 <cprintf>
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
f01008d5:	68 e2 79 10 f0       	push   $0xf01079e2
f01008da:	e8 81 35 00 00       	call   f0103e60 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f01008df:	83 c4 08             	add    $0x8,%esp
f01008e2:	ff 73 08             	pushl  0x8(%ebx)
f01008e5:	68 f1 79 10 f0       	push   $0xf01079f1
f01008ea:	e8 71 35 00 00       	call   f0103e60 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f01008ef:	83 c4 08             	add    $0x8,%esp
f01008f2:	ff 73 0c             	pushl  0xc(%ebx)
f01008f5:	68 00 7a 10 f0       	push   $0xf0107a00
f01008fa:	e8 61 35 00 00       	call   f0103e60 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f01008ff:	83 c4 08             	add    $0x8,%esp
f0100902:	ff 73 10             	pushl  0x10(%ebx)
f0100905:	68 0f 7a 10 f0       	push   $0xf0107a0f
f010090a:	e8 51 35 00 00       	call   f0103e60 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f010090f:	83 c4 08             	add    $0x8,%esp
f0100912:	ff 73 14             	pushl  0x14(%ebx)
f0100915:	68 1e 7a 10 f0       	push   $0xf0107a1e
f010091a:	e8 41 35 00 00       	call   f0103e60 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f010091f:	83 c4 08             	add    $0x8,%esp
f0100922:	ff 73 18             	pushl  0x18(%ebx)
f0100925:	68 2d 7a 10 f0       	push   $0xf0107a2d
f010092a:	e8 31 35 00 00       	call   f0103e60 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f010092f:	ff 73 18             	pushl  0x18(%ebx)
f0100932:	ff 73 14             	pushl  0x14(%ebx)
f0100935:	ff 73 10             	pushl  0x10(%ebx)
f0100938:	ff 73 0c             	pushl  0xc(%ebx)
f010093b:	ff 73 08             	pushl  0x8(%ebx)
f010093e:	53                   	push   %ebx
f010093f:	ff 73 04             	pushl  0x4(%ebx)
f0100942:	68 10 7c 10 f0       	push   $0xf0107c10
f0100947:	e8 14 35 00 00       	call   f0103e60 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f010094c:	83 c4 28             	add    $0x28,%esp
f010094f:	56                   	push   %esi
f0100950:	ff 73 04             	pushl  0x4(%ebx)
f0100953:	e8 e6 4e 00 00       	call   f010583e <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f0100958:	83 c4 08             	add    $0x8,%esp
f010095b:	8b 43 04             	mov    0x4(%ebx),%eax
f010095e:	2b 45 f0             	sub    -0x10(%ebp),%eax
f0100961:	50                   	push   %eax
f0100962:	ff 75 e8             	pushl  -0x18(%ebp)
f0100965:	ff 75 ec             	pushl  -0x14(%ebp)
f0100968:	ff 75 e4             	pushl  -0x1c(%ebp)
f010096b:	ff 75 e0             	pushl  -0x20(%ebp)
f010096e:	68 3c 7a 10 f0       	push   $0xf0107a3c
f0100973:	e8 e8 34 00 00       	call   f0103e60 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f0100978:	8b 1b                	mov    (%ebx),%ebx
f010097a:	83 c4 20             	add    $0x20,%esp
f010097d:	e9 45 ff ff ff       	jmp    f01008c7 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f0100982:	83 ec 0c             	sub    $0xc,%esp
f0100985:	68 52 7a 10 f0       	push   $0xf0107a52
f010098a:	e8 d1 34 00 00       	call   f0103e60 <cprintf>
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
f01009cf:	68 80 7c 10 f0       	push   $0xf0107c80
f01009d4:	e8 87 34 00 00       	call   f0103e60 <cprintf>
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
f01009ec:	68 00 7e 10 f0       	push   $0xf0107e00
f01009f1:	68 44 7c 10 f0       	push   $0xf0107c44
f01009f6:	e8 65 34 00 00       	call   f0103e60 <cprintf>
		return 0;
f01009fb:	83 c4 10             	add    $0x10,%esp
f01009fe:	eb dc                	jmp    f01009dc <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f0100a00:	83 ec 04             	sub    $0x4,%esp
f0100a03:	6a 10                	push   $0x10
f0100a05:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f0100a08:	56                   	push   %esi
f0100a09:	50                   	push   %eax
f0100a0a:	e8 ac 5b 00 00       	call   f01065bb <strtol>
f0100a0f:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a11:	83 c4 0c             	add    $0xc,%esp
f0100a14:	6a 10                	push   $0x10
f0100a16:	56                   	push   %esi
f0100a17:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a1a:	ff 70 08             	pushl  0x8(%eax)
f0100a1d:	e8 99 5b 00 00       	call   f01065bb <strtol>
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
f0100a3e:	68 a8 7c 10 f0       	push   $0xf0107ca8
f0100a43:	e8 18 34 00 00       	call   f0103e60 <cprintf>
		return 0;
f0100a48:	83 c4 10             	add    $0x10,%esp
f0100a4b:	eb 8f                	jmp    f01009dc <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100a4d:	83 ec 04             	sub    $0x4,%esp
f0100a50:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100a56:	50                   	push   %eax
f0100a57:	53                   	push   %ebx
f0100a58:	68 65 7a 10 f0       	push   $0xf0107a65
f0100a5d:	e8 fe 33 00 00       	call   f0103e60 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100a62:	8b 06                	mov    (%esi),%eax
f0100a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a69:	83 c4 0c             	add    $0xc,%esp
f0100a6c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100a72:	52                   	push   %edx
f0100a73:	50                   	push   %eax
f0100a74:	68 74 7a 10 f0       	push   $0xf0107a74
f0100a79:	e8 e2 33 00 00       	call   f0103e60 <cprintf>
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
f0100aad:	68 83 7a 10 f0       	push   $0xf0107a83
f0100ab2:	e8 a9 33 00 00       	call   f0103e60 <cprintf>
f0100ab7:	83 c4 20             	add    $0x20,%esp
f0100aba:	e9 dc 00 00 00       	jmp    f0100b9b <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100abf:	83 ec 04             	sub    $0x4,%esp
f0100ac2:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100ac8:	50                   	push   %eax
f0100ac9:	53                   	push   %ebx
f0100aca:	68 65 7a 10 f0       	push   $0xf0107a65
f0100acf:	e8 8c 33 00 00       	call   f0103e60 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100ad4:	8b 07                	mov    (%edi),%eax
f0100ad6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100adb:	83 c4 0c             	add    $0xc,%esp
f0100ade:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100ae4:	52                   	push   %edx
f0100ae5:	50                   	push   %eax
f0100ae6:	68 74 7a 10 f0       	push   $0xf0107a74
f0100aeb:	e8 70 33 00 00       	call   f0103e60 <cprintf>
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
f0100b1f:	68 83 7a 10 f0       	push   $0xf0107a83
f0100b24:	e8 37 33 00 00       	call   f0103e60 <cprintf>
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
f0100b5c:	a1 ac be 57 f0       	mov    0xf057beac,%eax
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
f0100bf4:	ff 14 b5 28 7e 10 f0 	call   *-0xfef81d8(,%esi,4)
f0100bfb:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100bfe:	83 c3 01             	add    $0x1,%ebx
f0100c01:	39 1d 00 73 12 f0    	cmp    %ebx,0xf0127300
f0100c07:	7e 1c                	jle    f0100c25 <mon_time+0x78>
f0100c09:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c0c:	83 ec 08             	sub    $0x8,%esp
f0100c0f:	57                   	push   %edi
f0100c10:	ff 34 b5 20 7e 10 f0 	pushl  -0xfef81e0(,%esi,4)
f0100c17:	e8 ee 57 00 00       	call   f010640a <strcmp>
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
f0100c30:	68 96 7a 10 f0       	push   $0xf0107a96
f0100c35:	e8 26 32 00 00       	call   f0103e60 <cprintf>
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
f0100c5a:	68 cc 7c 10 f0       	push   $0xf0107ccc
f0100c5f:	e8 fc 31 00 00       	call   f0103e60 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c64:	c7 04 24 f0 7c 10 f0 	movl   $0xf0107cf0,(%esp)
f0100c6b:	e8 f0 31 00 00       	call   f0103e60 <cprintf>
	if (tf != NULL)
f0100c70:	83 c4 10             	add    $0x10,%esp
f0100c73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100c77:	0f 84 d9 00 00 00    	je     f0100d56 <monitor+0x105>
		print_trapframe(tf);
f0100c7d:	83 ec 0c             	sub    $0xc,%esp
f0100c80:	ff 75 08             	pushl  0x8(%ebp)
f0100c83:	e8 63 39 00 00       	call   f01045eb <print_trapframe>
f0100c88:	83 c4 10             	add    $0x10,%esp
f0100c8b:	e9 c6 00 00 00       	jmp    f0100d56 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100c90:	83 ec 08             	sub    $0x8,%esp
f0100c93:	0f be c0             	movsbl %al,%eax
f0100c96:	50                   	push   %eax
f0100c97:	68 aa 7a 10 f0       	push   $0xf0107aaa
f0100c9c:	e8 c7 57 00 00       	call   f0106468 <strchr>
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
f0100cd4:	ff 34 85 20 7e 10 f0 	pushl  -0xfef81e0(,%eax,4)
f0100cdb:	ff 75 a8             	pushl  -0x58(%ebp)
f0100cde:	e8 27 57 00 00       	call   f010640a <strcmp>
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
f0100cfc:	68 cc 7a 10 f0       	push   $0xf0107acc
f0100d01:	e8 5a 31 00 00       	call   f0103e60 <cprintf>
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
f0100d2a:	68 aa 7a 10 f0       	push   $0xf0107aaa
f0100d2f:	e8 34 57 00 00       	call   f0106468 <strchr>
f0100d34:	83 c4 10             	add    $0x10,%esp
f0100d37:	85 c0                	test   %eax,%eax
f0100d39:	0f 85 71 ff ff ff    	jne    f0100cb0 <monitor+0x5f>
			buf++;
f0100d3f:	83 c3 01             	add    $0x1,%ebx
f0100d42:	eb d8                	jmp    f0100d1c <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d44:	83 ec 08             	sub    $0x8,%esp
f0100d47:	6a 10                	push   $0x10
f0100d49:	68 af 7a 10 f0       	push   $0xf0107aaf
f0100d4e:	e8 0d 31 00 00       	call   f0103e60 <cprintf>
f0100d53:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100d56:	83 ec 0c             	sub    $0xc,%esp
f0100d59:	68 a6 7a 10 f0       	push   $0xf0107aa6
f0100d5e:	e8 d5 54 00 00       	call   f0106238 <readline>
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
f0100d8b:	ff 14 85 28 7e 10 f0 	call   *-0xfef81d8(,%eax,4)
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
f0100daf:	e8 05 2f 00 00       	call   f0103cb9 <mc146818_read>
f0100db4:	89 c3                	mov    %eax,%ebx
f0100db6:	83 c6 01             	add    $0x1,%esi
f0100db9:	89 34 24             	mov    %esi,(%esp)
f0100dbc:	e8 f8 2e 00 00       	call   f0103cb9 <mc146818_read>
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
f0100de3:	3b 0d a8 be 57 f0    	cmp    0xf057bea8,%ecx
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
f0100e17:	68 d4 76 10 f0       	push   $0xf01076d4
f0100e1c:	68 ad 03 00 00       	push   $0x3ad
f0100e21:	68 65 88 10 f0       	push   $0xf0108865
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
f0100e38:	83 3d 38 a2 57 f0 00 	cmpl   $0x0,0xf057a238
f0100e3f:	74 40                	je     f0100e81 <boot_alloc+0x50>
	if(!n)
f0100e41:	85 c0                	test   %eax,%eax
f0100e43:	74 65                	je     f0100eaa <boot_alloc+0x79>
f0100e45:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100e47:	a1 38 a2 57 f0       	mov    0xf057a238,%eax
	if ((uint32_t)kva < KERNBASE)
f0100e4c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e51:	76 5e                	jbe    f0100eb1 <boot_alloc+0x80>
f0100e53:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100e5a:	c1 e9 0c             	shr    $0xc,%ecx
f0100e5d:	83 c1 01             	add    $0x1,%ecx
f0100e60:	3b 0d a8 be 57 f0    	cmp    0xf057bea8,%ecx
f0100e66:	77 5b                	ja     f0100ec3 <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100e68:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e6e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e74:	01 c2                	add    %eax,%edx
f0100e76:	89 15 38 a2 57 f0    	mov    %edx,0xf057a238
}
f0100e7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100e7f:	c9                   	leave  
f0100e80:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e81:	b9 10 d0 5b f0       	mov    $0xf05bd010,%ecx
f0100e86:	ba 0f e0 5b f0       	mov    $0xf05be00f,%edx
f0100e8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100e91:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e97:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100e9d:	85 c9                	test   %ecx,%ecx
f0100e9f:	0f 44 d3             	cmove  %ebx,%edx
f0100ea2:	89 15 38 a2 57 f0    	mov    %edx,0xf057a238
f0100ea8:	eb 97                	jmp    f0100e41 <boot_alloc+0x10>
		return nextfree;
f0100eaa:	a1 38 a2 57 f0       	mov    0xf057a238,%eax
f0100eaf:	eb cb                	jmp    f0100e7c <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100eb1:	50                   	push   %eax
f0100eb2:	68 f8 76 10 f0       	push   $0xf01076f8
f0100eb7:	6a 72                	push   $0x72
f0100eb9:	68 65 88 10 f0       	push   $0xf0108865
f0100ebe:	e8 86 f1 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100ec3:	83 ec 04             	sub    $0x4,%esp
f0100ec6:	68 5c 7e 10 f0       	push   $0xf0107e5c
f0100ecb:	6a 73                	push   $0x73
f0100ecd:	68 65 88 10 f0       	push   $0xf0108865
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
f0100ee8:	83 3d 40 a2 57 f0 00 	cmpl   $0x0,0xf057a240
f0100eef:	74 0a                	je     f0100efb <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ef1:	be 00 04 00 00       	mov    $0x400,%esi
f0100ef6:	e9 bf 02 00 00       	jmp    f01011ba <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100efb:	83 ec 04             	sub    $0x4,%esp
f0100efe:	68 94 7e 10 f0       	push   $0xf0107e94
f0100f03:	68 dd 02 00 00       	push   $0x2dd
f0100f08:	68 65 88 10 f0       	push   $0xf0108865
f0100f0d:	e8 37 f1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f12:	50                   	push   %eax
f0100f13:	68 d4 76 10 f0       	push   $0xf01076d4
f0100f18:	6a 58                	push   $0x58
f0100f1a:	68 71 88 10 f0       	push   $0xf0108871
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
f0100f2c:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
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
f0100f46:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0100f4c:	73 c4                	jae    f0100f12 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100f4e:	83 ec 04             	sub    $0x4,%esp
f0100f51:	68 80 00 00 00       	push   $0x80
f0100f56:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100f5b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f60:	50                   	push   %eax
f0100f61:	e8 3f 55 00 00       	call   f01064a5 <memset>
f0100f66:	83 c4 10             	add    $0x10,%esp
f0100f69:	eb b9                	jmp    f0100f24 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100f6b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f70:	e8 bc fe ff ff       	call   f0100e31 <boot_alloc>
f0100f75:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f78:	8b 15 40 a2 57 f0    	mov    0xf057a240,%edx
		assert(pp >= pages);
f0100f7e:	8b 0d b0 be 57 f0    	mov    0xf057beb0,%ecx
		assert(pp < pages + npages);
f0100f84:	a1 a8 be 57 f0       	mov    0xf057bea8,%eax
f0100f89:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f8c:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100f8f:	bf 00 00 00 00       	mov    $0x0,%edi
f0100f94:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f97:	e9 f9 00 00 00       	jmp    f0101095 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100f9c:	68 7f 88 10 f0       	push   $0xf010887f
f0100fa1:	68 8b 88 10 f0       	push   $0xf010888b
f0100fa6:	68 f6 02 00 00       	push   $0x2f6
f0100fab:	68 65 88 10 f0       	push   $0xf0108865
f0100fb0:	e8 94 f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0100fb5:	68 a0 88 10 f0       	push   $0xf01088a0
f0100fba:	68 8b 88 10 f0       	push   $0xf010888b
f0100fbf:	68 f7 02 00 00       	push   $0x2f7
f0100fc4:	68 65 88 10 f0       	push   $0xf0108865
f0100fc9:	e8 7b f0 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100fce:	68 b8 7e 10 f0       	push   $0xf0107eb8
f0100fd3:	68 8b 88 10 f0       	push   $0xf010888b
f0100fd8:	68 f8 02 00 00       	push   $0x2f8
f0100fdd:	68 65 88 10 f0       	push   $0xf0108865
f0100fe2:	e8 62 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0100fe7:	68 b4 88 10 f0       	push   $0xf01088b4
f0100fec:	68 8b 88 10 f0       	push   $0xf010888b
f0100ff1:	68 fb 02 00 00       	push   $0x2fb
f0100ff6:	68 65 88 10 f0       	push   $0xf0108865
f0100ffb:	e8 49 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101000:	68 c5 88 10 f0       	push   $0xf01088c5
f0101005:	68 8b 88 10 f0       	push   $0xf010888b
f010100a:	68 fc 02 00 00       	push   $0x2fc
f010100f:	68 65 88 10 f0       	push   $0xf0108865
f0101014:	e8 30 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101019:	68 ec 7e 10 f0       	push   $0xf0107eec
f010101e:	68 8b 88 10 f0       	push   $0xf010888b
f0101023:	68 fd 02 00 00       	push   $0x2fd
f0101028:	68 65 88 10 f0       	push   $0xf0108865
f010102d:	e8 17 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101032:	68 de 88 10 f0       	push   $0xf01088de
f0101037:	68 8b 88 10 f0       	push   $0xf010888b
f010103c:	68 fe 02 00 00       	push   $0x2fe
f0101041:	68 65 88 10 f0       	push   $0xf0108865
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
f0101065:	68 d4 76 10 f0       	push   $0xf01076d4
f010106a:	6a 58                	push   $0x58
f010106c:	68 71 88 10 f0       	push   $0xf0108871
f0101071:	e8 d3 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101076:	68 10 7f 10 f0       	push   $0xf0107f10
f010107b:	68 8b 88 10 f0       	push   $0xf010888b
f0101080:	68 ff 02 00 00       	push   $0x2ff
f0101085:	68 65 88 10 f0       	push   $0xf0108865
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
f01010f4:	68 f8 88 10 f0       	push   $0xf01088f8
f01010f9:	68 8b 88 10 f0       	push   $0xf010888b
f01010fe:	68 01 03 00 00       	push   $0x301
f0101103:	68 65 88 10 f0       	push   $0xf0108865
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
f010111b:	68 58 7f 10 f0       	push   $0xf0107f58
f0101120:	e8 3b 2d 00 00       	call   f0103e60 <cprintf>
}
f0101125:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101128:	5b                   	pop    %ebx
f0101129:	5e                   	pop    %esi
f010112a:	5f                   	pop    %edi
f010112b:	5d                   	pop    %ebp
f010112c:	c3                   	ret    
	assert(nfree_basemem > 0);
f010112d:	68 15 89 10 f0       	push   $0xf0108915
f0101132:	68 8b 88 10 f0       	push   $0xf010888b
f0101137:	68 08 03 00 00       	push   $0x308
f010113c:	68 65 88 10 f0       	push   $0xf0108865
f0101141:	e8 03 ef ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f0101146:	68 27 89 10 f0       	push   $0xf0108927
f010114b:	68 8b 88 10 f0       	push   $0xf010888b
f0101150:	68 09 03 00 00       	push   $0x309
f0101155:	68 65 88 10 f0       	push   $0xf0108865
f010115a:	e8 ea ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f010115f:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f0101164:	85 c0                	test   %eax,%eax
f0101166:	0f 84 8f fd ff ff    	je     f0100efb <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010116c:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010116f:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101172:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101175:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101178:	89 c2                	mov    %eax,%edx
f010117a:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
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
f01011b0:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01011b5:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f01011ba:	8b 1d 40 a2 57 f0    	mov    0xf057a240,%ebx
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
f01011e9:	03 15 b0 be 57 f0    	add    0xf057beb0,%edx
f01011ef:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f01011f5:	8b 0d 40 a2 57 f0    	mov    0xf057a240,%ecx
f01011fb:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f01011fd:	03 05 b0 be 57 f0    	add    0xf057beb0,%eax
f0101203:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
f0101208:	eb 12                	jmp    f010121c <page_init+0x57>
			pages[i].pp_ref = 1;
f010120a:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
f010120f:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f0101215:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f010121c:	83 c3 01             	add    $0x1,%ebx
f010121f:	39 1d a8 be 57 f0    	cmp    %ebx,0xf057bea8
f0101225:	0f 86 94 00 00 00    	jbe    f01012bf <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f010122b:	85 db                	test   %ebx,%ebx
f010122d:	75 a4                	jne    f01011d3 <page_init+0xe>
			pages[i].pp_ref = 1;
f010122f:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
f0101234:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f010123a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101240:	eb da                	jmp    f010121c <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f0101242:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0101248:	77 16                	ja     f0101260 <page_init+0x9b>
			pages[i].pp_ref = 1;
f010124a:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
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
f0101286:	03 15 b0 be 57 f0    	add    0xf057beb0,%edx
f010128c:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101292:	8b 0d 40 a2 57 f0    	mov    0xf057a240,%ecx
f0101298:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f010129a:	03 05 b0 be 57 f0    	add    0xf057beb0,%eax
f01012a0:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
f01012a5:	e9 72 ff ff ff       	jmp    f010121c <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01012aa:	50                   	push   %eax
f01012ab:	68 f8 76 10 f0       	push   $0xf01076f8
f01012b0:	68 4d 01 00 00       	push   $0x14d
f01012b5:	68 65 88 10 f0       	push   $0xf0108865
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
f01012cb:	8b 1d 40 a2 57 f0    	mov    0xf057a240,%ebx
f01012d1:	85 db                	test   %ebx,%ebx
f01012d3:	74 13                	je     f01012e8 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f01012d5:	8b 03                	mov    (%ebx),%eax
f01012d7:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
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
f01012f1:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01012f7:	c1 f8 03             	sar    $0x3,%eax
f01012fa:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01012fd:	89 c2                	mov    %eax,%edx
f01012ff:	c1 ea 0c             	shr    $0xc,%edx
f0101302:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0101308:	73 1a                	jae    f0101324 <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f010130a:	83 ec 04             	sub    $0x4,%esp
f010130d:	68 00 10 00 00       	push   $0x1000
f0101312:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101314:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101319:	50                   	push   %eax
f010131a:	e8 86 51 00 00       	call   f01064a5 <memset>
f010131f:	83 c4 10             	add    $0x10,%esp
f0101322:	eb c4                	jmp    f01012e8 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101324:	50                   	push   %eax
f0101325:	68 d4 76 10 f0       	push   $0xf01076d4
f010132a:	6a 58                	push   $0x58
f010132c:	68 71 88 10 f0       	push   $0xf0108871
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
f010134b:	8b 15 40 a2 57 f0    	mov    0xf057a240,%edx
f0101351:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101353:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
}
f0101358:	c9                   	leave  
f0101359:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f010135a:	83 ec 04             	sub    $0x4,%esp
f010135d:	68 7c 7f 10 f0       	push   $0xf0107f7c
f0101362:	68 81 01 00 00       	push   $0x181
f0101367:	68 65 88 10 f0       	push   $0xf0108865
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
f01013c8:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
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
f01013ff:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
f0101405:	c1 fa 03             	sar    $0x3,%edx
f0101408:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f010140b:	83 ca 07             	or     $0x7,%edx
f010140e:	89 13                	mov    %edx,(%ebx)
f0101410:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0101416:	c1 f8 03             	sar    $0x3,%eax
f0101419:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010141c:	89 c2                	mov    %eax,%edx
f010141e:	c1 ea 0c             	shr    $0xc,%edx
f0101421:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0101427:	73 12                	jae    f010143b <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f0101429:	c1 ee 0a             	shr    $0xa,%esi
f010142c:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101432:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0101439:	eb a5                	jmp    f01013e0 <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010143b:	50                   	push   %eax
f010143c:	68 d4 76 10 f0       	push   $0xf01076d4
f0101441:	6a 58                	push   $0x58
f0101443:	68 71 88 10 f0       	push   $0xf0108871
f0101448:	e8 fc eb ff ff       	call   f0100049 <_panic>
f010144d:	50                   	push   %eax
f010144e:	68 d4 76 10 f0       	push   $0xf01076d4
f0101453:	68 bb 01 00 00       	push   $0x1bb
f0101458:	68 65 88 10 f0       	push   $0xf0108865
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
f01014cd:	68 38 89 10 f0       	push   $0xf0108938
f01014d2:	68 8b 88 10 f0       	push   $0xf010888b
f01014d7:	68 d0 01 00 00       	push   $0x1d0
f01014dc:	68 65 88 10 f0       	push   $0xf0108865
f01014e1:	e8 63 eb ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f01014e6:	68 45 89 10 f0       	push   $0xf0108945
f01014eb:	68 8b 88 10 f0       	push   $0xf010888b
f01014f0:	68 d1 01 00 00       	push   $0x1d1
f01014f5:	68 65 88 10 f0       	push   $0xf0108865
f01014fa:	e8 4a eb ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f01014ff:	68 c4 8b 10 f0       	push   $0xf0108bc4
f0101504:	68 52 89 10 f0       	push   $0xf0108952
f0101509:	68 d5 01 00 00       	push   $0x1d5
f010150e:	68 65 88 10 f0       	push   $0xf0108865
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
f0101554:	39 05 a8 be 57 f0    	cmp    %eax,0xf057bea8
f010155a:	76 0e                	jbe    f010156a <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010155c:	8b 15 b0 be 57 f0    	mov    0xf057beb0,%edx
f0101562:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101568:	c9                   	leave  
f0101569:	c3                   	ret    
		panic("pa2page called with invalid pa");
f010156a:	83 ec 04             	sub    $0x4,%esp
f010156d:	68 b0 7f 10 f0       	push   $0xf0107fb0
f0101572:	6a 51                	push   $0x51
f0101574:	68 71 88 10 f0       	push   $0xf0108871
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
f010158b:	e8 1e 55 00 00       	call   f0106aae <cpunum>
f0101590:	6b c0 74             	imul   $0x74,%eax,%eax
f0101593:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f010159a:	74 16                	je     f01015b2 <tlb_invalidate+0x2d>
f010159c:	e8 0d 55 00 00       	call   f0106aae <cpunum>
f01015a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01015a4:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
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
f010162e:	8b 0d a8 be 57 f0    	mov    0xf057bea8,%ecx
f0101634:	89 d0                	mov    %edx,%eax
f0101636:	c1 e8 0c             	shr    $0xc,%eax
f0101639:	39 c1                	cmp    %eax,%ecx
f010163b:	76 5f                	jbe    f010169c <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f010163d:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f0101643:	89 d8                	mov    %ebx,%eax
f0101645:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
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
f0101676:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
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
f010169d:	68 d4 76 10 f0       	push   $0xf01076d4
f01016a2:	68 17 02 00 00       	push   $0x217
f01016a7:	68 65 88 10 f0       	push   $0xf0108865
f01016ac:	e8 98 e9 ff ff       	call   f0100049 <_panic>
f01016b1:	50                   	push   %eax
f01016b2:	68 d4 76 10 f0       	push   $0xf01076d4
f01016b7:	6a 58                	push   $0x58
f01016b9:	68 71 88 10 f0       	push   $0xf0108871
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
f01016f6:	8b 35 04 73 12 f0    	mov    0xf0127304,%esi
f01016fc:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01016ff:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101704:	77 25                	ja     f010172b <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f0101706:	83 ec 08             	sub    $0x8,%esp
f0101709:	6a 1a                	push   $0x1a
f010170b:	ff 75 08             	pushl  0x8(%ebp)
f010170e:	89 d9                	mov    %ebx,%ecx
f0101710:	89 f2                	mov    %esi,%edx
f0101712:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0101717:	e8 50 fd ff ff       	call   f010146c <boot_map_region>
	base += size;
f010171c:	01 1d 04 73 12 f0    	add    %ebx,0xf0127304
}
f0101722:	89 f0                	mov    %esi,%eax
f0101724:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101727:	5b                   	pop    %ebx
f0101728:	5e                   	pop    %esi
f0101729:	5d                   	pop    %ebp
f010172a:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f010172b:	83 ec 04             	sub    $0x4,%esp
f010172e:	68 5c 89 10 f0       	push   $0xf010895c
f0101733:	68 88 02 00 00       	push   $0x288
f0101738:	68 65 88 10 f0       	push   $0xf0108865
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
f0101780:	89 15 a8 be 57 f0    	mov    %edx,0xf057bea8
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101786:	89 c2                	mov    %eax,%edx
f0101788:	29 da                	sub    %ebx,%edx
f010178a:	52                   	push   %edx
f010178b:	53                   	push   %ebx
f010178c:	50                   	push   %eax
f010178d:	68 d0 7f 10 f0       	push   $0xf0107fd0
f0101792:	e8 c9 26 00 00       	call   f0103e60 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101797:	b8 00 10 00 00       	mov    $0x1000,%eax
f010179c:	e8 90 f6 ff ff       	call   f0100e31 <boot_alloc>
f01017a1:	a3 ac be 57 f0       	mov    %eax,0xf057beac
	memset(kern_pgdir, 0, PGSIZE);
f01017a6:	83 c4 0c             	add    $0xc,%esp
f01017a9:	68 00 10 00 00       	push   $0x1000
f01017ae:	6a 00                	push   $0x0
f01017b0:	50                   	push   %eax
f01017b1:	e8 ef 4c 00 00       	call   f01064a5 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01017b6:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f01017bb:	83 c4 10             	add    $0x10,%esp
f01017be:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017c3:	0f 86 a2 00 00 00    	jbe    f010186b <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f01017c9:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017cf:	83 ca 05             	or     $0x5,%edx
f01017d2:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f01017d8:	a1 a8 be 57 f0       	mov    0xf057bea8,%eax
f01017dd:	c1 e0 03             	shl    $0x3,%eax
f01017e0:	e8 4c f6 ff ff       	call   f0100e31 <boot_alloc>
f01017e5:	a3 b0 be 57 f0       	mov    %eax,0xf057beb0
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01017ea:	83 ec 04             	sub    $0x4,%esp
f01017ed:	8b 15 a8 be 57 f0    	mov    0xf057bea8,%edx
f01017f3:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f01017fa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101800:	52                   	push   %edx
f0101801:	6a 00                	push   $0x0
f0101803:	50                   	push   %eax
f0101804:	e8 9c 4c 00 00       	call   f01064a5 <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101809:	b8 00 00 02 00       	mov    $0x20000,%eax
f010180e:	e8 1e f6 ff ff       	call   f0100e31 <boot_alloc>
f0101813:	a3 44 a2 57 f0       	mov    %eax,0xf057a244
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101818:	83 c4 0c             	add    $0xc,%esp
f010181b:	68 00 00 02 00       	push   $0x20000
f0101820:	6a 00                	push   $0x0
f0101822:	50                   	push   %eax
f0101823:	e8 7d 4c 00 00       	call   f01064a5 <memset>
	page_init();
f0101828:	e8 98 f9 ff ff       	call   f01011c5 <page_init>
	check_page_free_list(1);
f010182d:	b8 01 00 00 00       	mov    $0x1,%eax
f0101832:	e8 a0 f6 ff ff       	call   f0100ed7 <check_page_free_list>
	if (!pages)
f0101837:	83 c4 10             	add    $0x10,%esp
f010183a:	83 3d b0 be 57 f0 00 	cmpl   $0x0,0xf057beb0
f0101841:	74 3d                	je     f0101880 <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101843:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
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
f010186c:	68 f8 76 10 f0       	push   $0xf01076f8
f0101871:	68 9a 00 00 00       	push   $0x9a
f0101876:	68 65 88 10 f0       	push   $0xf0108865
f010187b:	e8 c9 e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f0101880:	83 ec 04             	sub    $0x4,%esp
f0101883:	68 6e 89 10 f0       	push   $0xf010896e
f0101888:	68 1c 03 00 00       	push   $0x31c
f010188d:	68 65 88 10 f0       	push   $0xf0108865
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
f01018f4:	8b 0d b0 be 57 f0    	mov    0xf057beb0,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01018fa:	8b 15 a8 be 57 f0    	mov    0xf057bea8,%edx
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
f0101939:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f010193e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101941:	c7 05 40 a2 57 f0 00 	movl   $0x0,0xf057a240
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
f01019ef:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01019f5:	c1 f8 03             	sar    $0x3,%eax
f01019f8:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01019fb:	89 c2                	mov    %eax,%edx
f01019fd:	c1 ea 0c             	shr    $0xc,%edx
f0101a00:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0101a06:	0f 83 19 02 00 00    	jae    f0101c25 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a0c:	83 ec 04             	sub    $0x4,%esp
f0101a0f:	68 00 10 00 00       	push   $0x1000
f0101a14:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101a16:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a1b:	50                   	push   %eax
f0101a1c:	e8 84 4a 00 00       	call   f01064a5 <memset>
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
f0101a48:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0101a4e:	c1 f8 03             	sar    $0x3,%eax
f0101a51:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a54:	89 c2                	mov    %eax,%edx
f0101a56:	c1 ea 0c             	shr    $0xc,%edx
f0101a59:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
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
f0101a83:	a3 40 a2 57 f0       	mov    %eax,0xf057a240
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
f0101aa1:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f0101aa6:	83 c4 10             	add    $0x10,%esp
f0101aa9:	e9 ec 01 00 00       	jmp    f0101c9a <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101aae:	68 89 89 10 f0       	push   $0xf0108989
f0101ab3:	68 8b 88 10 f0       	push   $0xf010888b
f0101ab8:	68 24 03 00 00       	push   $0x324
f0101abd:	68 65 88 10 f0       	push   $0xf0108865
f0101ac2:	e8 82 e5 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ac7:	68 9f 89 10 f0       	push   $0xf010899f
f0101acc:	68 8b 88 10 f0       	push   $0xf010888b
f0101ad1:	68 25 03 00 00       	push   $0x325
f0101ad6:	68 65 88 10 f0       	push   $0xf0108865
f0101adb:	e8 69 e5 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101ae0:	68 b5 89 10 f0       	push   $0xf01089b5
f0101ae5:	68 8b 88 10 f0       	push   $0xf010888b
f0101aea:	68 26 03 00 00       	push   $0x326
f0101aef:	68 65 88 10 f0       	push   $0xf0108865
f0101af4:	e8 50 e5 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101af9:	68 cb 89 10 f0       	push   $0xf01089cb
f0101afe:	68 8b 88 10 f0       	push   $0xf010888b
f0101b03:	68 29 03 00 00       	push   $0x329
f0101b08:	68 65 88 10 f0       	push   $0xf0108865
f0101b0d:	e8 37 e5 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b12:	68 0c 80 10 f0       	push   $0xf010800c
f0101b17:	68 8b 88 10 f0       	push   $0xf010888b
f0101b1c:	68 2a 03 00 00       	push   $0x32a
f0101b21:	68 65 88 10 f0       	push   $0xf0108865
f0101b26:	e8 1e e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b2b:	68 dd 89 10 f0       	push   $0xf01089dd
f0101b30:	68 8b 88 10 f0       	push   $0xf010888b
f0101b35:	68 2b 03 00 00       	push   $0x32b
f0101b3a:	68 65 88 10 f0       	push   $0xf0108865
f0101b3f:	e8 05 e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b44:	68 fa 89 10 f0       	push   $0xf01089fa
f0101b49:	68 8b 88 10 f0       	push   $0xf010888b
f0101b4e:	68 2c 03 00 00       	push   $0x32c
f0101b53:	68 65 88 10 f0       	push   $0xf0108865
f0101b58:	e8 ec e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b5d:	68 17 8a 10 f0       	push   $0xf0108a17
f0101b62:	68 8b 88 10 f0       	push   $0xf010888b
f0101b67:	68 2d 03 00 00       	push   $0x32d
f0101b6c:	68 65 88 10 f0       	push   $0xf0108865
f0101b71:	e8 d3 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101b76:	68 34 8a 10 f0       	push   $0xf0108a34
f0101b7b:	68 8b 88 10 f0       	push   $0xf010888b
f0101b80:	68 34 03 00 00       	push   $0x334
f0101b85:	68 65 88 10 f0       	push   $0xf0108865
f0101b8a:	e8 ba e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101b8f:	68 89 89 10 f0       	push   $0xf0108989
f0101b94:	68 8b 88 10 f0       	push   $0xf010888b
f0101b99:	68 3b 03 00 00       	push   $0x33b
f0101b9e:	68 65 88 10 f0       	push   $0xf0108865
f0101ba3:	e8 a1 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ba8:	68 9f 89 10 f0       	push   $0xf010899f
f0101bad:	68 8b 88 10 f0       	push   $0xf010888b
f0101bb2:	68 3c 03 00 00       	push   $0x33c
f0101bb7:	68 65 88 10 f0       	push   $0xf0108865
f0101bbc:	e8 88 e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101bc1:	68 b5 89 10 f0       	push   $0xf01089b5
f0101bc6:	68 8b 88 10 f0       	push   $0xf010888b
f0101bcb:	68 3d 03 00 00       	push   $0x33d
f0101bd0:	68 65 88 10 f0       	push   $0xf0108865
f0101bd5:	e8 6f e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101bda:	68 cb 89 10 f0       	push   $0xf01089cb
f0101bdf:	68 8b 88 10 f0       	push   $0xf010888b
f0101be4:	68 3f 03 00 00       	push   $0x33f
f0101be9:	68 65 88 10 f0       	push   $0xf0108865
f0101bee:	e8 56 e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101bf3:	68 0c 80 10 f0       	push   $0xf010800c
f0101bf8:	68 8b 88 10 f0       	push   $0xf010888b
f0101bfd:	68 40 03 00 00       	push   $0x340
f0101c02:	68 65 88 10 f0       	push   $0xf0108865
f0101c07:	e8 3d e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c0c:	68 34 8a 10 f0       	push   $0xf0108a34
f0101c11:	68 8b 88 10 f0       	push   $0xf010888b
f0101c16:	68 41 03 00 00       	push   $0x341
f0101c1b:	68 65 88 10 f0       	push   $0xf0108865
f0101c20:	e8 24 e4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c25:	50                   	push   %eax
f0101c26:	68 d4 76 10 f0       	push   $0xf01076d4
f0101c2b:	6a 58                	push   $0x58
f0101c2d:	68 71 88 10 f0       	push   $0xf0108871
f0101c32:	e8 12 e4 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101c37:	68 43 8a 10 f0       	push   $0xf0108a43
f0101c3c:	68 8b 88 10 f0       	push   $0xf010888b
f0101c41:	68 46 03 00 00       	push   $0x346
f0101c46:	68 65 88 10 f0       	push   $0xf0108865
f0101c4b:	e8 f9 e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101c50:	68 61 8a 10 f0       	push   $0xf0108a61
f0101c55:	68 8b 88 10 f0       	push   $0xf010888b
f0101c5a:	68 47 03 00 00       	push   $0x347
f0101c5f:	68 65 88 10 f0       	push   $0xf0108865
f0101c64:	e8 e0 e3 ff ff       	call   f0100049 <_panic>
f0101c69:	50                   	push   %eax
f0101c6a:	68 d4 76 10 f0       	push   $0xf01076d4
f0101c6f:	6a 58                	push   $0x58
f0101c71:	68 71 88 10 f0       	push   $0xf0108871
f0101c76:	e8 ce e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101c7b:	68 71 8a 10 f0       	push   $0xf0108a71
f0101c80:	68 8b 88 10 f0       	push   $0xf010888b
f0101c85:	68 4a 03 00 00       	push   $0x34a
f0101c8a:	68 65 88 10 f0       	push   $0xf0108865
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
f0101cab:	68 2c 80 10 f0       	push   $0xf010802c
f0101cb0:	e8 ab 21 00 00       	call   f0103e60 <cprintf>
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
f0101d17:	a1 40 a2 57 f0       	mov    0xf057a240,%eax
f0101d1c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101d1f:	c7 05 40 a2 57 f0 00 	movl   $0x0,0xf057a240
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
f0101d47:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101d4d:	e8 ce f7 ff ff       	call   f0101520 <page_lookup>
f0101d52:	83 c4 10             	add    $0x10,%esp
f0101d55:	85 c0                	test   %eax,%eax
f0101d57:	0f 85 5f 09 00 00    	jne    f01026bc <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101d5d:	6a 02                	push   $0x2
f0101d5f:	6a 00                	push   $0x0
f0101d61:	57                   	push   %edi
f0101d62:	ff 35 ac be 57 f0    	pushl  0xf057beac
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
f0101d88:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101d8e:	e8 6d f8 ff ff       	call   f0101600 <page_insert>
f0101d93:	83 c4 20             	add    $0x20,%esp
f0101d96:	85 c0                	test   %eax,%eax
f0101d98:	0f 85 50 09 00 00    	jne    f01026ee <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d9e:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
	return (pp - pages) << PGSHIFT;
f0101da4:	8b 0d b0 be 57 f0    	mov    0xf057beb0,%ecx
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
f0101e1e:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0101e23:	e8 a5 ef ff ff       	call   f0100dcd <check_va2pa>
f0101e28:	89 da                	mov    %ebx,%edx
f0101e2a:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
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
f0101e66:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101e6c:	e8 8f f7 ff ff       	call   f0101600 <page_insert>
f0101e71:	83 c4 10             	add    $0x10,%esp
f0101e74:	85 c0                	test   %eax,%eax
f0101e76:	0f 85 53 09 00 00    	jne    f01027cf <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e7c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e81:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0101e86:	e8 42 ef ff ff       	call   f0100dcd <check_va2pa>
f0101e8b:	89 da                	mov    %ebx,%edx
f0101e8d:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
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
f0101ec1:	8b 15 ac be 57 f0    	mov    0xf057beac,%edx
f0101ec7:	8b 02                	mov    (%edx),%eax
f0101ec9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101ece:	89 c1                	mov    %eax,%ecx
f0101ed0:	c1 e9 0c             	shr    $0xc,%ecx
f0101ed3:	3b 0d a8 be 57 f0    	cmp    0xf057bea8,%ecx
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
f0101f10:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101f16:	e8 e5 f6 ff ff       	call   f0101600 <page_insert>
f0101f1b:	83 c4 10             	add    $0x10,%esp
f0101f1e:	85 c0                	test   %eax,%eax
f0101f20:	0f 85 3b 09 00 00    	jne    f0102861 <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f26:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
f0101f2c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f31:	89 f0                	mov    %esi,%eax
f0101f33:	e8 95 ee ff ff       	call   f0100dcd <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101f38:	89 da                	mov    %ebx,%edx
f0101f3a:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
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
f0101f75:	a1 ac be 57 f0       	mov    0xf057beac,%eax
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
f0101fa6:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101fac:	e8 e9 f3 ff ff       	call   f010139a <pgdir_walk>
f0101fb1:	83 c4 10             	add    $0x10,%esp
f0101fb4:	f6 00 02             	testb  $0x2,(%eax)
f0101fb7:	0f 84 3a 09 00 00    	je     f01028f7 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101fbd:	83 ec 04             	sub    $0x4,%esp
f0101fc0:	6a 00                	push   $0x0
f0101fc2:	68 00 10 00 00       	push   $0x1000
f0101fc7:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101fcd:	e8 c8 f3 ff ff       	call   f010139a <pgdir_walk>
f0101fd2:	83 c4 10             	add    $0x10,%esp
f0101fd5:	f6 00 04             	testb  $0x4,(%eax)
f0101fd8:	0f 85 32 09 00 00    	jne    f0102910 <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101fde:	6a 02                	push   $0x2
f0101fe0:	68 00 00 40 00       	push   $0x400000
f0101fe5:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101fe8:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0101fee:	e8 0d f6 ff ff       	call   f0101600 <page_insert>
f0101ff3:	83 c4 10             	add    $0x10,%esp
f0101ff6:	85 c0                	test   %eax,%eax
f0101ff8:	0f 89 2b 09 00 00    	jns    f0102929 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101ffe:	6a 02                	push   $0x2
f0102000:	68 00 10 00 00       	push   $0x1000
f0102005:	57                   	push   %edi
f0102006:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010200c:	e8 ef f5 ff ff       	call   f0101600 <page_insert>
f0102011:	83 c4 10             	add    $0x10,%esp
f0102014:	85 c0                	test   %eax,%eax
f0102016:	0f 85 26 09 00 00    	jne    f0102942 <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010201c:	83 ec 04             	sub    $0x4,%esp
f010201f:	6a 00                	push   $0x0
f0102021:	68 00 10 00 00       	push   $0x1000
f0102026:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010202c:	e8 69 f3 ff ff       	call   f010139a <pgdir_walk>
f0102031:	83 c4 10             	add    $0x10,%esp
f0102034:	f6 00 04             	testb  $0x4,(%eax)
f0102037:	0f 85 1e 09 00 00    	jne    f010295b <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010203d:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102042:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102045:	ba 00 00 00 00       	mov    $0x0,%edx
f010204a:	e8 7e ed ff ff       	call   f0100dcd <check_va2pa>
f010204f:	89 fe                	mov    %edi,%esi
f0102051:	2b 35 b0 be 57 f0    	sub    0xf057beb0,%esi
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
f01020b2:	ff 35 ac be 57 f0    	pushl  0xf057beac
f01020b8:	e8 fd f4 ff ff       	call   f01015ba <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01020bd:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
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
f01020e9:	2b 15 b0 be 57 f0    	sub    0xf057beb0,%edx
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
f0102148:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010214e:	e8 67 f4 ff ff       	call   f01015ba <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102153:	8b 35 ac be 57 f0    	mov    0xf057beac,%esi
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
f01021ce:	8b 0d ac be 57 f0    	mov    0xf057beac,%ecx
f01021d4:	8b 11                	mov    (%ecx),%edx
f01021d6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01021dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021df:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
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
f0102223:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0102229:	e8 6c f1 ff ff       	call   f010139a <pgdir_walk>
f010222e:	89 c1                	mov    %eax,%ecx
f0102230:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102233:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102238:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010223b:	8b 40 04             	mov    0x4(%eax),%eax
f010223e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102243:	8b 35 a8 be 57 f0    	mov    0xf057bea8,%esi
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
f0102279:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
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
f01022a5:	e8 fb 41 00 00       	call   f01064a5 <memset>
	page_free(pp0);
f01022aa:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01022ad:	89 34 24             	mov    %esi,(%esp)
f01022b0:	e8 81 f0 ff ff       	call   f0101336 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01022b5:	83 c4 0c             	add    $0xc,%esp
f01022b8:	6a 01                	push   $0x1
f01022ba:	6a 00                	push   $0x0
f01022bc:	ff 35 ac be 57 f0    	pushl  0xf057beac
f01022c2:	e8 d3 f0 ff ff       	call   f010139a <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01022c7:	89 f0                	mov    %esi,%eax
f01022c9:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01022cf:	c1 f8 03             	sar    $0x3,%eax
f01022d2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022d5:	89 c2                	mov    %eax,%edx
f01022d7:	c1 ea 0c             	shr    $0xc,%edx
f01022da:	83 c4 10             	add    $0x10,%esp
f01022dd:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
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
f0102307:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f010230c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102315:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f010231b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010231e:	89 0d 40 a2 57 f0    	mov    %ecx,0xf057a240

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
f01023b5:	8b 3d ac be 57 f0    	mov    0xf057beac,%edi
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
f010242e:	ff 35 ac be 57 f0    	pushl  0xf057beac
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
f010244f:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0102455:	e8 40 ef ff ff       	call   f010139a <pgdir_walk>
f010245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102460:	83 c4 0c             	add    $0xc,%esp
f0102463:	6a 00                	push   $0x0
f0102465:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102468:	ff 35 ac be 57 f0    	pushl  0xf057beac
f010246e:	e8 27 ef ff ff       	call   f010139a <pgdir_walk>
f0102473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102479:	83 c4 0c             	add    $0xc,%esp
f010247c:	6a 00                	push   $0x0
f010247e:	56                   	push   %esi
f010247f:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0102485:	e8 10 ef ff ff       	call   f010139a <pgdir_walk>
f010248a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102490:	c7 04 24 64 8b 10 f0 	movl   $0xf0108b64,(%esp)
f0102497:	e8 c4 19 00 00       	call   f0103e60 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010249c:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
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
f01024c4:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f01024c9:	e8 9e ef ff ff       	call   f010146c <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01024ce:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
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
f01024f6:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f01024fb:	e8 6c ef ff ff       	call   f010146c <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102500:	83 c4 10             	add    $0x10,%esp
f0102503:	b8 00 e0 11 f0       	mov    $0xf011e000,%eax
f0102508:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010250d:	0f 86 e4 07 00 00    	jbe    f0102cf7 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102513:	83 ec 08             	sub    $0x8,%esp
f0102516:	6a 02                	push   $0x2
f0102518:	68 00 e0 11 00       	push   $0x11e000
f010251d:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102522:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102527:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f010252c:	e8 3b ef ff ff       	call   f010146c <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f0102531:	83 c4 08             	add    $0x8,%esp
f0102534:	6a 02                	push   $0x2
f0102536:	6a 00                	push   $0x0
f0102538:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010253d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102542:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102547:	e8 20 ef ff ff       	call   f010146c <boot_map_region>
f010254c:	c7 45 d0 00 d0 57 f0 	movl   $0xf057d000,-0x30(%ebp)
f0102553:	83 c4 10             	add    $0x10,%esp
f0102556:	bb 00 d0 57 f0       	mov    $0xf057d000,%ebx
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
f010257f:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f0102584:	e8 e3 ee ff ff       	call   f010146c <boot_map_region>
f0102589:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010258f:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f0102595:	83 c4 10             	add    $0x10,%esp
f0102598:	81 fb 00 d0 5b f0    	cmp    $0xf05bd000,%ebx
f010259e:	75 c0                	jne    f0102560 <mem_init+0xe1e>
	pgdir = kern_pgdir;
f01025a0:	a1 ac be 57 f0       	mov    0xf057beac,%eax
f01025a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01025a8:	a1 a8 be 57 f0       	mov    0xf057bea8,%eax
f01025ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01025b0:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01025b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025bf:	8b 35 b0 be 57 f0    	mov    0xf057beb0,%esi
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
f010260d:	68 7b 8a 10 f0       	push   $0xf0108a7b
f0102612:	68 8b 88 10 f0       	push   $0xf010888b
f0102617:	68 57 03 00 00       	push   $0x357
f010261c:	68 65 88 10 f0       	push   $0xf0108865
f0102621:	e8 23 da ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0102626:	68 89 89 10 f0       	push   $0xf0108989
f010262b:	68 8b 88 10 f0       	push   $0xf010888b
f0102630:	68 ca 03 00 00       	push   $0x3ca
f0102635:	68 65 88 10 f0       	push   $0xf0108865
f010263a:	e8 0a da ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010263f:	68 9f 89 10 f0       	push   $0xf010899f
f0102644:	68 8b 88 10 f0       	push   $0xf010888b
f0102649:	68 cb 03 00 00       	push   $0x3cb
f010264e:	68 65 88 10 f0       	push   $0xf0108865
f0102653:	e8 f1 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0102658:	68 b5 89 10 f0       	push   $0xf01089b5
f010265d:	68 8b 88 10 f0       	push   $0xf010888b
f0102662:	68 cc 03 00 00       	push   $0x3cc
f0102667:	68 65 88 10 f0       	push   $0xf0108865
f010266c:	e8 d8 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0102671:	68 cb 89 10 f0       	push   $0xf01089cb
f0102676:	68 8b 88 10 f0       	push   $0xf010888b
f010267b:	68 cf 03 00 00       	push   $0x3cf
f0102680:	68 65 88 10 f0       	push   $0xf0108865
f0102685:	e8 bf d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010268a:	68 0c 80 10 f0       	push   $0xf010800c
f010268f:	68 8b 88 10 f0       	push   $0xf010888b
f0102694:	68 d0 03 00 00       	push   $0x3d0
f0102699:	68 65 88 10 f0       	push   $0xf0108865
f010269e:	e8 a6 d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01026a3:	68 34 8a 10 f0       	push   $0xf0108a34
f01026a8:	68 8b 88 10 f0       	push   $0xf010888b
f01026ad:	68 d7 03 00 00       	push   $0x3d7
f01026b2:	68 65 88 10 f0       	push   $0xf0108865
f01026b7:	e8 8d d9 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01026bc:	68 4c 80 10 f0       	push   $0xf010804c
f01026c1:	68 8b 88 10 f0       	push   $0xf010888b
f01026c6:	68 da 03 00 00       	push   $0x3da
f01026cb:	68 65 88 10 f0       	push   $0xf0108865
f01026d0:	e8 74 d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01026d5:	68 84 80 10 f0       	push   $0xf0108084
f01026da:	68 8b 88 10 f0       	push   $0xf010888b
f01026df:	68 dd 03 00 00       	push   $0x3dd
f01026e4:	68 65 88 10 f0       	push   $0xf0108865
f01026e9:	e8 5b d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01026ee:	68 b4 80 10 f0       	push   $0xf01080b4
f01026f3:	68 8b 88 10 f0       	push   $0xf010888b
f01026f8:	68 e1 03 00 00       	push   $0x3e1
f01026fd:	68 65 88 10 f0       	push   $0xf0108865
f0102702:	e8 42 d9 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102707:	68 e4 80 10 f0       	push   $0xf01080e4
f010270c:	68 8b 88 10 f0       	push   $0xf010888b
f0102711:	68 e2 03 00 00       	push   $0x3e2
f0102716:	68 65 88 10 f0       	push   $0xf0108865
f010271b:	e8 29 d9 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102720:	68 0c 81 10 f0       	push   $0xf010810c
f0102725:	68 8b 88 10 f0       	push   $0xf010888b
f010272a:	68 e3 03 00 00       	push   $0x3e3
f010272f:	68 65 88 10 f0       	push   $0xf0108865
f0102734:	e8 10 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102739:	68 86 8a 10 f0       	push   $0xf0108a86
f010273e:	68 8b 88 10 f0       	push   $0xf010888b
f0102743:	68 e4 03 00 00       	push   $0x3e4
f0102748:	68 65 88 10 f0       	push   $0xf0108865
f010274d:	e8 f7 d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102752:	68 97 8a 10 f0       	push   $0xf0108a97
f0102757:	68 8b 88 10 f0       	push   $0xf010888b
f010275c:	68 e5 03 00 00       	push   $0x3e5
f0102761:	68 65 88 10 f0       	push   $0xf0108865
f0102766:	e8 de d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010276b:	68 3c 81 10 f0       	push   $0xf010813c
f0102770:	68 8b 88 10 f0       	push   $0xf010888b
f0102775:	68 e8 03 00 00       	push   $0x3e8
f010277a:	68 65 88 10 f0       	push   $0xf0108865
f010277f:	e8 c5 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102784:	68 78 81 10 f0       	push   $0xf0108178
f0102789:	68 8b 88 10 f0       	push   $0xf010888b
f010278e:	68 e9 03 00 00       	push   $0x3e9
f0102793:	68 65 88 10 f0       	push   $0xf0108865
f0102798:	e8 ac d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010279d:	68 a8 8a 10 f0       	push   $0xf0108aa8
f01027a2:	68 8b 88 10 f0       	push   $0xf010888b
f01027a7:	68 ea 03 00 00       	push   $0x3ea
f01027ac:	68 65 88 10 f0       	push   $0xf0108865
f01027b1:	e8 93 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01027b6:	68 34 8a 10 f0       	push   $0xf0108a34
f01027bb:	68 8b 88 10 f0       	push   $0xf010888b
f01027c0:	68 ed 03 00 00       	push   $0x3ed
f01027c5:	68 65 88 10 f0       	push   $0xf0108865
f01027ca:	e8 7a d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027cf:	68 3c 81 10 f0       	push   $0xf010813c
f01027d4:	68 8b 88 10 f0       	push   $0xf010888b
f01027d9:	68 f0 03 00 00       	push   $0x3f0
f01027de:	68 65 88 10 f0       	push   $0xf0108865
f01027e3:	e8 61 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027e8:	68 78 81 10 f0       	push   $0xf0108178
f01027ed:	68 8b 88 10 f0       	push   $0xf010888b
f01027f2:	68 f1 03 00 00       	push   $0x3f1
f01027f7:	68 65 88 10 f0       	push   $0xf0108865
f01027fc:	e8 48 d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102801:	68 a8 8a 10 f0       	push   $0xf0108aa8
f0102806:	68 8b 88 10 f0       	push   $0xf010888b
f010280b:	68 f2 03 00 00       	push   $0x3f2
f0102810:	68 65 88 10 f0       	push   $0xf0108865
f0102815:	e8 2f d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f010281a:	68 34 8a 10 f0       	push   $0xf0108a34
f010281f:	68 8b 88 10 f0       	push   $0xf010888b
f0102824:	68 f6 03 00 00       	push   $0x3f6
f0102829:	68 65 88 10 f0       	push   $0xf0108865
f010282e:	e8 16 d8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102833:	50                   	push   %eax
f0102834:	68 d4 76 10 f0       	push   $0xf01076d4
f0102839:	68 f9 03 00 00       	push   $0x3f9
f010283e:	68 65 88 10 f0       	push   $0xf0108865
f0102843:	e8 01 d8 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102848:	68 a8 81 10 f0       	push   $0xf01081a8
f010284d:	68 8b 88 10 f0       	push   $0xf010888b
f0102852:	68 fa 03 00 00       	push   $0x3fa
f0102857:	68 65 88 10 f0       	push   $0xf0108865
f010285c:	e8 e8 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102861:	68 e8 81 10 f0       	push   $0xf01081e8
f0102866:	68 8b 88 10 f0       	push   $0xf010888b
f010286b:	68 fd 03 00 00       	push   $0x3fd
f0102870:	68 65 88 10 f0       	push   $0xf0108865
f0102875:	e8 cf d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010287a:	68 78 81 10 f0       	push   $0xf0108178
f010287f:	68 8b 88 10 f0       	push   $0xf010888b
f0102884:	68 fe 03 00 00       	push   $0x3fe
f0102889:	68 65 88 10 f0       	push   $0xf0108865
f010288e:	e8 b6 d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102893:	68 a8 8a 10 f0       	push   $0xf0108aa8
f0102898:	68 8b 88 10 f0       	push   $0xf010888b
f010289d:	68 ff 03 00 00       	push   $0x3ff
f01028a2:	68 65 88 10 f0       	push   $0xf0108865
f01028a7:	e8 9d d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01028ac:	68 28 82 10 f0       	push   $0xf0108228
f01028b1:	68 8b 88 10 f0       	push   $0xf010888b
f01028b6:	68 00 04 00 00       	push   $0x400
f01028bb:	68 65 88 10 f0       	push   $0xf0108865
f01028c0:	e8 84 d7 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01028c5:	68 b9 8a 10 f0       	push   $0xf0108ab9
f01028ca:	68 8b 88 10 f0       	push   $0xf010888b
f01028cf:	68 01 04 00 00       	push   $0x401
f01028d4:	68 65 88 10 f0       	push   $0xf0108865
f01028d9:	e8 6b d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01028de:	68 3c 81 10 f0       	push   $0xf010813c
f01028e3:	68 8b 88 10 f0       	push   $0xf010888b
f01028e8:	68 04 04 00 00       	push   $0x404
f01028ed:	68 65 88 10 f0       	push   $0xf0108865
f01028f2:	e8 52 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01028f7:	68 5c 82 10 f0       	push   $0xf010825c
f01028fc:	68 8b 88 10 f0       	push   $0xf010888b
f0102901:	68 05 04 00 00       	push   $0x405
f0102906:	68 65 88 10 f0       	push   $0xf0108865
f010290b:	e8 39 d7 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102910:	68 90 82 10 f0       	push   $0xf0108290
f0102915:	68 8b 88 10 f0       	push   $0xf010888b
f010291a:	68 06 04 00 00       	push   $0x406
f010291f:	68 65 88 10 f0       	push   $0xf0108865
f0102924:	e8 20 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102929:	68 c8 82 10 f0       	push   $0xf01082c8
f010292e:	68 8b 88 10 f0       	push   $0xf010888b
f0102933:	68 09 04 00 00       	push   $0x409
f0102938:	68 65 88 10 f0       	push   $0xf0108865
f010293d:	e8 07 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102942:	68 00 83 10 f0       	push   $0xf0108300
f0102947:	68 8b 88 10 f0       	push   $0xf010888b
f010294c:	68 0c 04 00 00       	push   $0x40c
f0102951:	68 65 88 10 f0       	push   $0xf0108865
f0102956:	e8 ee d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010295b:	68 90 82 10 f0       	push   $0xf0108290
f0102960:	68 8b 88 10 f0       	push   $0xf010888b
f0102965:	68 0d 04 00 00       	push   $0x40d
f010296a:	68 65 88 10 f0       	push   $0xf0108865
f010296f:	e8 d5 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102974:	68 3c 83 10 f0       	push   $0xf010833c
f0102979:	68 8b 88 10 f0       	push   $0xf010888b
f010297e:	68 10 04 00 00       	push   $0x410
f0102983:	68 65 88 10 f0       	push   $0xf0108865
f0102988:	e8 bc d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010298d:	68 68 83 10 f0       	push   $0xf0108368
f0102992:	68 8b 88 10 f0       	push   $0xf010888b
f0102997:	68 11 04 00 00       	push   $0x411
f010299c:	68 65 88 10 f0       	push   $0xf0108865
f01029a1:	e8 a3 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f01029a6:	68 cf 8a 10 f0       	push   $0xf0108acf
f01029ab:	68 8b 88 10 f0       	push   $0xf010888b
f01029b0:	68 13 04 00 00       	push   $0x413
f01029b5:	68 65 88 10 f0       	push   $0xf0108865
f01029ba:	e8 8a d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01029bf:	68 e0 8a 10 f0       	push   $0xf0108ae0
f01029c4:	68 8b 88 10 f0       	push   $0xf010888b
f01029c9:	68 14 04 00 00       	push   $0x414
f01029ce:	68 65 88 10 f0       	push   $0xf0108865
f01029d3:	e8 71 d6 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01029d8:	68 98 83 10 f0       	push   $0xf0108398
f01029dd:	68 8b 88 10 f0       	push   $0xf010888b
f01029e2:	68 17 04 00 00       	push   $0x417
f01029e7:	68 65 88 10 f0       	push   $0xf0108865
f01029ec:	e8 58 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01029f1:	68 bc 83 10 f0       	push   $0xf01083bc
f01029f6:	68 8b 88 10 f0       	push   $0xf010888b
f01029fb:	68 1b 04 00 00       	push   $0x41b
f0102a00:	68 65 88 10 f0       	push   $0xf0108865
f0102a05:	e8 3f d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a0a:	68 68 83 10 f0       	push   $0xf0108368
f0102a0f:	68 8b 88 10 f0       	push   $0xf010888b
f0102a14:	68 1c 04 00 00       	push   $0x41c
f0102a19:	68 65 88 10 f0       	push   $0xf0108865
f0102a1e:	e8 26 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102a23:	68 86 8a 10 f0       	push   $0xf0108a86
f0102a28:	68 8b 88 10 f0       	push   $0xf010888b
f0102a2d:	68 1d 04 00 00       	push   $0x41d
f0102a32:	68 65 88 10 f0       	push   $0xf0108865
f0102a37:	e8 0d d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a3c:	68 e0 8a 10 f0       	push   $0xf0108ae0
f0102a41:	68 8b 88 10 f0       	push   $0xf010888b
f0102a46:	68 1e 04 00 00       	push   $0x41e
f0102a4b:	68 65 88 10 f0       	push   $0xf0108865
f0102a50:	e8 f4 d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102a55:	68 e0 83 10 f0       	push   $0xf01083e0
f0102a5a:	68 8b 88 10 f0       	push   $0xf010888b
f0102a5f:	68 21 04 00 00       	push   $0x421
f0102a64:	68 65 88 10 f0       	push   $0xf0108865
f0102a69:	e8 db d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102a6e:	68 f1 8a 10 f0       	push   $0xf0108af1
f0102a73:	68 8b 88 10 f0       	push   $0xf010888b
f0102a78:	68 22 04 00 00       	push   $0x422
f0102a7d:	68 65 88 10 f0       	push   $0xf0108865
f0102a82:	e8 c2 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102a87:	68 fd 8a 10 f0       	push   $0xf0108afd
f0102a8c:	68 8b 88 10 f0       	push   $0xf010888b
f0102a91:	68 23 04 00 00       	push   $0x423
f0102a96:	68 65 88 10 f0       	push   $0xf0108865
f0102a9b:	e8 a9 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102aa0:	68 bc 83 10 f0       	push   $0xf01083bc
f0102aa5:	68 8b 88 10 f0       	push   $0xf010888b
f0102aaa:	68 27 04 00 00       	push   $0x427
f0102aaf:	68 65 88 10 f0       	push   $0xf0108865
f0102ab4:	e8 90 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102ab9:	68 18 84 10 f0       	push   $0xf0108418
f0102abe:	68 8b 88 10 f0       	push   $0xf010888b
f0102ac3:	68 28 04 00 00       	push   $0x428
f0102ac8:	68 65 88 10 f0       	push   $0xf0108865
f0102acd:	e8 77 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102ad2:	68 12 8b 10 f0       	push   $0xf0108b12
f0102ad7:	68 8b 88 10 f0       	push   $0xf010888b
f0102adc:	68 29 04 00 00       	push   $0x429
f0102ae1:	68 65 88 10 f0       	push   $0xf0108865
f0102ae6:	e8 5e d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102aeb:	68 e0 8a 10 f0       	push   $0xf0108ae0
f0102af0:	68 8b 88 10 f0       	push   $0xf010888b
f0102af5:	68 2a 04 00 00       	push   $0x42a
f0102afa:	68 65 88 10 f0       	push   $0xf0108865
f0102aff:	e8 45 d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b04:	68 40 84 10 f0       	push   $0xf0108440
f0102b09:	68 8b 88 10 f0       	push   $0xf010888b
f0102b0e:	68 2d 04 00 00       	push   $0x42d
f0102b13:	68 65 88 10 f0       	push   $0xf0108865
f0102b18:	e8 2c d5 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102b1d:	68 34 8a 10 f0       	push   $0xf0108a34
f0102b22:	68 8b 88 10 f0       	push   $0xf010888b
f0102b27:	68 30 04 00 00       	push   $0x430
f0102b2c:	68 65 88 10 f0       	push   $0xf0108865
f0102b31:	e8 13 d5 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b36:	68 e4 80 10 f0       	push   $0xf01080e4
f0102b3b:	68 8b 88 10 f0       	push   $0xf010888b
f0102b40:	68 33 04 00 00       	push   $0x433
f0102b45:	68 65 88 10 f0       	push   $0xf0108865
f0102b4a:	e8 fa d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102b4f:	68 97 8a 10 f0       	push   $0xf0108a97
f0102b54:	68 8b 88 10 f0       	push   $0xf010888b
f0102b59:	68 35 04 00 00       	push   $0x435
f0102b5e:	68 65 88 10 f0       	push   $0xf0108865
f0102b63:	e8 e1 d4 ff ff       	call   f0100049 <_panic>
f0102b68:	50                   	push   %eax
f0102b69:	68 d4 76 10 f0       	push   $0xf01076d4
f0102b6e:	68 3c 04 00 00       	push   $0x43c
f0102b73:	68 65 88 10 f0       	push   $0xf0108865
f0102b78:	e8 cc d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102b7d:	68 23 8b 10 f0       	push   $0xf0108b23
f0102b82:	68 8b 88 10 f0       	push   $0xf010888b
f0102b87:	68 3d 04 00 00       	push   $0x43d
f0102b8c:	68 65 88 10 f0       	push   $0xf0108865
f0102b91:	e8 b3 d4 ff ff       	call   f0100049 <_panic>
f0102b96:	50                   	push   %eax
f0102b97:	68 d4 76 10 f0       	push   $0xf01076d4
f0102b9c:	6a 58                	push   $0x58
f0102b9e:	68 71 88 10 f0       	push   $0xf0108871
f0102ba3:	e8 a1 d4 ff ff       	call   f0100049 <_panic>
f0102ba8:	50                   	push   %eax
f0102ba9:	68 d4 76 10 f0       	push   $0xf01076d4
f0102bae:	6a 58                	push   $0x58
f0102bb0:	68 71 88 10 f0       	push   $0xf0108871
f0102bb5:	e8 8f d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102bba:	68 3b 8b 10 f0       	push   $0xf0108b3b
f0102bbf:	68 8b 88 10 f0       	push   $0xf010888b
f0102bc4:	68 47 04 00 00       	push   $0x447
f0102bc9:	68 65 88 10 f0       	push   $0xf0108865
f0102bce:	e8 76 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102bd3:	68 64 84 10 f0       	push   $0xf0108464
f0102bd8:	68 8b 88 10 f0       	push   $0xf010888b
f0102bdd:	68 57 04 00 00       	push   $0x457
f0102be2:	68 65 88 10 f0       	push   $0xf0108865
f0102be7:	e8 5d d4 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102bec:	68 8c 84 10 f0       	push   $0xf010848c
f0102bf1:	68 8b 88 10 f0       	push   $0xf010888b
f0102bf6:	68 58 04 00 00       	push   $0x458
f0102bfb:	68 65 88 10 f0       	push   $0xf0108865
f0102c00:	e8 44 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c05:	68 b4 84 10 f0       	push   $0xf01084b4
f0102c0a:	68 8b 88 10 f0       	push   $0xf010888b
f0102c0f:	68 5a 04 00 00       	push   $0x45a
f0102c14:	68 65 88 10 f0       	push   $0xf0108865
f0102c19:	e8 2b d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102c1e:	68 52 8b 10 f0       	push   $0xf0108b52
f0102c23:	68 8b 88 10 f0       	push   $0xf010888b
f0102c28:	68 5c 04 00 00       	push   $0x45c
f0102c2d:	68 65 88 10 f0       	push   $0xf0108865
f0102c32:	e8 12 d4 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c37:	68 dc 84 10 f0       	push   $0xf01084dc
f0102c3c:	68 8b 88 10 f0       	push   $0xf010888b
f0102c41:	68 5e 04 00 00       	push   $0x45e
f0102c46:	68 65 88 10 f0       	push   $0xf0108865
f0102c4b:	e8 f9 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c50:	68 00 85 10 f0       	push   $0xf0108500
f0102c55:	68 8b 88 10 f0       	push   $0xf010888b
f0102c5a:	68 5f 04 00 00       	push   $0x45f
f0102c5f:	68 65 88 10 f0       	push   $0xf0108865
f0102c64:	e8 e0 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c69:	68 30 85 10 f0       	push   $0xf0108530
f0102c6e:	68 8b 88 10 f0       	push   $0xf010888b
f0102c73:	68 60 04 00 00       	push   $0x460
f0102c78:	68 65 88 10 f0       	push   $0xf0108865
f0102c7d:	e8 c7 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102c82:	68 54 85 10 f0       	push   $0xf0108554
f0102c87:	68 8b 88 10 f0       	push   $0xf010888b
f0102c8c:	68 61 04 00 00       	push   $0x461
f0102c91:	68 65 88 10 f0       	push   $0xf0108865
f0102c96:	e8 ae d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102c9b:	68 80 85 10 f0       	push   $0xf0108580
f0102ca0:	68 8b 88 10 f0       	push   $0xf010888b
f0102ca5:	68 63 04 00 00       	push   $0x463
f0102caa:	68 65 88 10 f0       	push   $0xf0108865
f0102caf:	e8 95 d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102cb4:	68 c4 85 10 f0       	push   $0xf01085c4
f0102cb9:	68 8b 88 10 f0       	push   $0xf010888b
f0102cbe:	68 64 04 00 00       	push   $0x464
f0102cc3:	68 65 88 10 f0       	push   $0xf0108865
f0102cc8:	e8 7c d3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ccd:	50                   	push   %eax
f0102cce:	68 f8 76 10 f0       	push   $0xf01076f8
f0102cd3:	68 be 00 00 00       	push   $0xbe
f0102cd8:	68 65 88 10 f0       	push   $0xf0108865
f0102cdd:	e8 67 d3 ff ff       	call   f0100049 <_panic>
f0102ce2:	50                   	push   %eax
f0102ce3:	68 f8 76 10 f0       	push   $0xf01076f8
f0102ce8:	68 c6 00 00 00       	push   $0xc6
f0102ced:	68 65 88 10 f0       	push   $0xf0108865
f0102cf2:	e8 52 d3 ff ff       	call   f0100049 <_panic>
f0102cf7:	50                   	push   %eax
f0102cf8:	68 f8 76 10 f0       	push   $0xf01076f8
f0102cfd:	68 d2 00 00 00       	push   $0xd2
f0102d02:	68 65 88 10 f0       	push   $0xf0108865
f0102d07:	e8 3d d3 ff ff       	call   f0100049 <_panic>
f0102d0c:	53                   	push   %ebx
f0102d0d:	68 f8 76 10 f0       	push   $0xf01076f8
f0102d12:	68 17 01 00 00       	push   $0x117
f0102d17:	68 65 88 10 f0       	push   $0xf0108865
f0102d1c:	e8 28 d3 ff ff       	call   f0100049 <_panic>
f0102d21:	56                   	push   %esi
f0102d22:	68 f8 76 10 f0       	push   $0xf01076f8
f0102d27:	68 6e 03 00 00       	push   $0x36e
f0102d2c:	68 65 88 10 f0       	push   $0xf0108865
f0102d31:	e8 13 d3 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d36:	68 f8 85 10 f0       	push   $0xf01085f8
f0102d3b:	68 8b 88 10 f0       	push   $0xf010888b
f0102d40:	68 6e 03 00 00       	push   $0x36e
f0102d45:	68 65 88 10 f0       	push   $0xf0108865
f0102d4a:	e8 fa d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102d4f:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
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
f0102dc0:	68 f8 76 10 f0       	push   $0xf01076f8
f0102dc5:	68 73 03 00 00       	push   $0x373
f0102dca:	68 65 88 10 f0       	push   $0xf0108865
f0102dcf:	e8 75 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102dd4:	68 2c 86 10 f0       	push   $0xf010862c
f0102dd9:	68 8b 88 10 f0       	push   $0xf010888b
f0102dde:	68 73 03 00 00       	push   $0x373
f0102de3:	68 65 88 10 f0       	push   $0xf0108865
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
f0102e1c:	68 60 86 10 f0       	push   $0xf0108660
f0102e21:	68 8b 88 10 f0       	push   $0xf010888b
f0102e26:	68 78 03 00 00       	push   $0x378
f0102e2b:	68 65 88 10 f0       	push   $0xf0108865
f0102e30:	e8 14 d2 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102e35:	83 ec 0c             	sub    $0xc,%esp
f0102e38:	68 7d 8b 10 f0       	push   $0xf0108b7d
f0102e3d:	e8 1e 10 00 00       	call   f0103e60 <cprintf>
f0102e42:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e45:	b8 00 d0 57 f0       	mov    $0xf057d000,%eax
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
f0102ed2:	81 ff 00 d0 5b f0    	cmp    $0xf05bd000,%edi
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
f0102f06:	68 8c 86 10 f0       	push   $0xf010868c
f0102f0b:	68 8b 88 10 f0       	push   $0xf010888b
f0102f10:	68 7d 03 00 00       	push   $0x37d
f0102f15:	68 65 88 10 f0       	push   $0xf0108865
f0102f1a:	e8 2a d1 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f1f:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f22:	c1 e6 0c             	shl    $0xc,%esi
f0102f25:	89 fb                	mov    %edi,%ebx
f0102f27:	eb c3                	jmp    f0102eec <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f29:	ff 75 c0             	pushl  -0x40(%ebp)
f0102f2c:	68 f8 76 10 f0       	push   $0xf01076f8
f0102f31:	68 85 03 00 00       	push   $0x385
f0102f36:	68 65 88 10 f0       	push   $0xf0108865
f0102f3b:	e8 09 d1 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102f40:	68 b4 86 10 f0       	push   $0xf01086b4
f0102f45:	68 8b 88 10 f0       	push   $0xf010888b
f0102f4a:	68 85 03 00 00       	push   $0x385
f0102f4f:	68 65 88 10 f0       	push   $0xf0108865
f0102f54:	e8 f0 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f59:	68 fc 86 10 f0       	push   $0xf01086fc
f0102f5e:	68 8b 88 10 f0       	push   $0xf010888b
f0102f63:	68 87 03 00 00       	push   $0x387
f0102f68:	68 65 88 10 f0       	push   $0xf0108865
f0102f6d:	e8 d7 d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0102f72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f75:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102f79:	75 4e                	jne    f0102fc9 <mem_init+0x1887>
f0102f7b:	68 94 8b 10 f0       	push   $0xf0108b94
f0102f80:	68 8b 88 10 f0       	push   $0xf010888b
f0102f85:	68 92 03 00 00       	push   $0x392
f0102f8a:	68 65 88 10 f0       	push   $0xf0108865
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
f0102fce:	68 94 8b 10 f0       	push   $0xf0108b94
f0102fd3:	68 8b 88 10 f0       	push   $0xf010888b
f0102fd8:	68 96 03 00 00       	push   $0x396
f0102fdd:	68 65 88 10 f0       	push   $0xf0108865
f0102fe2:	e8 62 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0102fe7:	68 a5 8b 10 f0       	push   $0xf0108ba5
f0102fec:	68 8b 88 10 f0       	push   $0xf010888b
f0102ff1:	68 97 03 00 00       	push   $0x397
f0102ff6:	68 65 88 10 f0       	push   $0xf0108865
f0102ffb:	e8 49 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f0103000:	68 b6 8b 10 f0       	push   $0xf0108bb6
f0103005:	68 8b 88 10 f0       	push   $0xf010888b
f010300a:	68 99 03 00 00       	push   $0x399
f010300f:	68 65 88 10 f0       	push   $0xf0108865
f0103014:	e8 30 d0 ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103019:	83 ec 0c             	sub    $0xc,%esp
f010301c:	68 20 87 10 f0       	push   $0xf0108720
f0103021:	e8 3a 0e 00 00       	call   f0103e60 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f0103026:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f0103029:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f010302c:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f010302f:	a1 ac be 57 f0       	mov    0xf057beac,%eax
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
f01030b2:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01030b8:	c1 f8 03             	sar    $0x3,%eax
f01030bb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030be:	89 c2                	mov    %eax,%edx
f01030c0:	c1 ea 0c             	shr    $0xc,%edx
f01030c3:	83 c4 10             	add    $0x10,%esp
f01030c6:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01030cc:	0f 83 cb 01 00 00    	jae    f010329d <mem_init+0x1b5b>
	memset(page2kva(pp1), 1, PGSIZE);
f01030d2:	83 ec 04             	sub    $0x4,%esp
f01030d5:	68 00 10 00 00       	push   $0x1000
f01030da:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01030dc:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01030e1:	50                   	push   %eax
f01030e2:	e8 be 33 00 00       	call   f01064a5 <memset>
	return (pp - pages) << PGSHIFT;
f01030e7:	89 d8                	mov    %ebx,%eax
f01030e9:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01030ef:	c1 f8 03             	sar    $0x3,%eax
f01030f2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030f5:	89 c2                	mov    %eax,%edx
f01030f7:	c1 ea 0c             	shr    $0xc,%edx
f01030fa:	83 c4 10             	add    $0x10,%esp
f01030fd:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0103103:	0f 83 a6 01 00 00    	jae    f01032af <mem_init+0x1b6d>
	memset(page2kva(pp2), 2, PGSIZE);
f0103109:	83 ec 04             	sub    $0x4,%esp
f010310c:	68 00 10 00 00       	push   $0x1000
f0103111:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0103113:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103118:	50                   	push   %eax
f0103119:	e8 87 33 00 00       	call   f01064a5 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f010311e:	6a 02                	push   $0x2
f0103120:	68 00 10 00 00       	push   $0x1000
f0103125:	57                   	push   %edi
f0103126:	ff 35 ac be 57 f0    	pushl  0xf057beac
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
f0103157:	ff 35 ac be 57 f0    	pushl  0xf057beac
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
f0103197:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f010319d:	c1 f8 03             	sar    $0x3,%eax
f01031a0:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01031a3:	89 c2                	mov    %eax,%edx
f01031a5:	c1 ea 0c             	shr    $0xc,%edx
f01031a8:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01031ae:	0f 83 8a 01 00 00    	jae    f010333e <mem_init+0x1bfc>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01031b4:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01031bb:	03 03 03 
f01031be:	0f 85 8c 01 00 00    	jne    f0103350 <mem_init+0x1c0e>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01031c4:	83 ec 08             	sub    $0x8,%esp
f01031c7:	68 00 10 00 00       	push   $0x1000
f01031cc:	ff 35 ac be 57 f0    	pushl  0xf057beac
f01031d2:	e8 e3 e3 ff ff       	call   f01015ba <page_remove>
	assert(pp2->pp_ref == 0);
f01031d7:	83 c4 10             	add    $0x10,%esp
f01031da:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01031df:	0f 85 84 01 00 00    	jne    f0103369 <mem_init+0x1c27>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01031e5:	8b 0d ac be 57 f0    	mov    0xf057beac,%ecx
f01031eb:	8b 11                	mov    (%ecx),%edx
f01031ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f01031f3:	89 f0                	mov    %esi,%eax
f01031f5:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
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
f0103229:	c7 04 24 b4 87 10 f0 	movl   $0xf01087b4,(%esp)
f0103230:	e8 2b 0c 00 00       	call   f0103e60 <cprintf>
}
f0103235:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103238:	5b                   	pop    %ebx
f0103239:	5e                   	pop    %esi
f010323a:	5f                   	pop    %edi
f010323b:	5d                   	pop    %ebp
f010323c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010323d:	50                   	push   %eax
f010323e:	68 f8 76 10 f0       	push   $0xf01076f8
f0103243:	68 ef 00 00 00       	push   $0xef
f0103248:	68 65 88 10 f0       	push   $0xf0108865
f010324d:	e8 f7 cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0103252:	68 89 89 10 f0       	push   $0xf0108989
f0103257:	68 8b 88 10 f0       	push   $0xf010888b
f010325c:	68 79 04 00 00       	push   $0x479
f0103261:	68 65 88 10 f0       	push   $0xf0108865
f0103266:	e8 de cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010326b:	68 9f 89 10 f0       	push   $0xf010899f
f0103270:	68 8b 88 10 f0       	push   $0xf010888b
f0103275:	68 7a 04 00 00       	push   $0x47a
f010327a:	68 65 88 10 f0       	push   $0xf0108865
f010327f:	e8 c5 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0103284:	68 b5 89 10 f0       	push   $0xf01089b5
f0103289:	68 8b 88 10 f0       	push   $0xf010888b
f010328e:	68 7b 04 00 00       	push   $0x47b
f0103293:	68 65 88 10 f0       	push   $0xf0108865
f0103298:	e8 ac cd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010329d:	50                   	push   %eax
f010329e:	68 d4 76 10 f0       	push   $0xf01076d4
f01032a3:	6a 58                	push   $0x58
f01032a5:	68 71 88 10 f0       	push   $0xf0108871
f01032aa:	e8 9a cd ff ff       	call   f0100049 <_panic>
f01032af:	50                   	push   %eax
f01032b0:	68 d4 76 10 f0       	push   $0xf01076d4
f01032b5:	6a 58                	push   $0x58
f01032b7:	68 71 88 10 f0       	push   $0xf0108871
f01032bc:	e8 88 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01032c1:	68 86 8a 10 f0       	push   $0xf0108a86
f01032c6:	68 8b 88 10 f0       	push   $0xf010888b
f01032cb:	68 80 04 00 00       	push   $0x480
f01032d0:	68 65 88 10 f0       	push   $0xf0108865
f01032d5:	e8 6f cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032da:	68 40 87 10 f0       	push   $0xf0108740
f01032df:	68 8b 88 10 f0       	push   $0xf010888b
f01032e4:	68 81 04 00 00       	push   $0x481
f01032e9:	68 65 88 10 f0       	push   $0xf0108865
f01032ee:	e8 56 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01032f3:	68 64 87 10 f0       	push   $0xf0108764
f01032f8:	68 8b 88 10 f0       	push   $0xf010888b
f01032fd:	68 83 04 00 00       	push   $0x483
f0103302:	68 65 88 10 f0       	push   $0xf0108865
f0103307:	e8 3d cd ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010330c:	68 a8 8a 10 f0       	push   $0xf0108aa8
f0103311:	68 8b 88 10 f0       	push   $0xf010888b
f0103316:	68 84 04 00 00       	push   $0x484
f010331b:	68 65 88 10 f0       	push   $0xf0108865
f0103320:	e8 24 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0103325:	68 12 8b 10 f0       	push   $0xf0108b12
f010332a:	68 8b 88 10 f0       	push   $0xf010888b
f010332f:	68 85 04 00 00       	push   $0x485
f0103334:	68 65 88 10 f0       	push   $0xf0108865
f0103339:	e8 0b cd ff ff       	call   f0100049 <_panic>
f010333e:	50                   	push   %eax
f010333f:	68 d4 76 10 f0       	push   $0xf01076d4
f0103344:	6a 58                	push   $0x58
f0103346:	68 71 88 10 f0       	push   $0xf0108871
f010334b:	e8 f9 cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103350:	68 88 87 10 f0       	push   $0xf0108788
f0103355:	68 8b 88 10 f0       	push   $0xf010888b
f010335a:	68 87 04 00 00       	push   $0x487
f010335f:	68 65 88 10 f0       	push   $0xf0108865
f0103364:	e8 e0 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103369:	68 e0 8a 10 f0       	push   $0xf0108ae0
f010336e:	68 8b 88 10 f0       	push   $0xf010888b
f0103373:	68 89 04 00 00       	push   $0x489
f0103378:	68 65 88 10 f0       	push   $0xf0108865
f010337d:	e8 c7 cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103382:	68 e4 80 10 f0       	push   $0xf01080e4
f0103387:	68 8b 88 10 f0       	push   $0xf010888b
f010338c:	68 8c 04 00 00       	push   $0x48c
f0103391:	68 65 88 10 f0       	push   $0xf0108865
f0103396:	e8 ae cc ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f010339b:	68 97 8a 10 f0       	push   $0xf0108a97
f01033a0:	68 8b 88 10 f0       	push   $0xf010888b
f01033a5:	68 8e 04 00 00       	push   $0x48e
f01033aa:	68 65 88 10 f0       	push   $0xf0108865
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
f01033d6:	89 1d 3c a2 57 f0    	mov    %ebx,0xf057a23c
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
f0103422:	68 e0 87 10 f0       	push   $0xf01087e0
f0103427:	e8 34 0a 00 00       	call   f0103e60 <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f010342c:	83 c4 0c             	add    $0xc,%esp
f010342f:	89 f8                	mov    %edi,%eax
f0103431:	23 06                	and    (%esi),%eax
f0103433:	50                   	push   %eax
f0103434:	57                   	push   %edi
f0103435:	68 08 88 10 f0       	push   $0xf0108808
f010343a:	e8 21 0a 00 00       	call   f0103e60 <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f010343f:	89 1d 3c a2 57 f0    	mov    %ebx,0xf057a23c
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
f0103488:	ff 35 3c a2 57 f0    	pushl  0xf057a23c
f010348e:	ff 73 48             	pushl  0x48(%ebx)
f0103491:	68 30 88 10 f0       	push   $0xf0108830
f0103496:	e8 c5 09 00 00       	call   f0103e60 <cprintf>
		env_destroy(env);	// may not return
f010349b:	89 1c 24             	mov    %ebx,(%esp)
f010349e:	e8 56 06 00 00       	call   f0103af9 <env_destroy>
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
f01034fb:	68 d4 8b 10 f0       	push   $0xf0108bd4
f0103500:	68 26 01 00 00       	push   $0x126
f0103505:	68 e6 8b 10 f0       	push   $0xf0108be6
f010350a:	e8 3a cb ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f010350f:	83 ec 04             	sub    $0x4,%esp
f0103512:	68 f1 8b 10 f0       	push   $0xf0108bf1
f0103517:	68 29 01 00 00       	push   $0x129
f010351c:	68 e6 8b 10 f0       	push   $0xf0108be6
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
f010353b:	74 2e                	je     f010356b <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f010353d:	89 f3                	mov    %esi,%ebx
f010353f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103545:	c1 e3 07             	shl    $0x7,%ebx
f0103548:	03 1d 44 a2 57 f0    	add    0xf057a244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010354e:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103552:	74 2e                	je     f0103582 <envid2env+0x54>
f0103554:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103557:	75 29                	jne    f0103582 <envid2env+0x54>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103559:	84 c0                	test   %al,%al
f010355b:	75 35                	jne    f0103592 <envid2env+0x64>
	*env_store = e;
f010355d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103560:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103562:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103567:	5b                   	pop    %ebx
f0103568:	5e                   	pop    %esi
f0103569:	5d                   	pop    %ebp
f010356a:	c3                   	ret    
		*env_store = curenv;
f010356b:	e8 3e 35 00 00       	call   f0106aae <cpunum>
f0103570:	6b c0 74             	imul   $0x74,%eax,%eax
f0103573:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103579:	8b 55 0c             	mov    0xc(%ebp),%edx
f010357c:	89 02                	mov    %eax,(%edx)
		return 0;
f010357e:	89 f0                	mov    %esi,%eax
f0103580:	eb e5                	jmp    f0103567 <envid2env+0x39>
		*env_store = 0;
f0103582:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010358b:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103590:	eb d5                	jmp    f0103567 <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103592:	e8 17 35 00 00       	call   f0106aae <cpunum>
f0103597:	6b c0 74             	imul   $0x74,%eax,%eax
f010359a:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f01035a0:	74 bb                	je     f010355d <envid2env+0x2f>
f01035a2:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01035a5:	e8 04 35 00 00       	call   f0106aae <cpunum>
f01035aa:	6b c0 74             	imul   $0x74,%eax,%eax
f01035ad:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01035b3:	3b 70 48             	cmp    0x48(%eax),%esi
f01035b6:	74 a5                	je     f010355d <envid2env+0x2f>
		*env_store = 0;
f01035b8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01035c1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01035c6:	eb 9f                	jmp    f0103567 <envid2env+0x39>

f01035c8 <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f01035c8:	b8 20 73 12 f0       	mov    $0xf0127320,%eax
f01035cd:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01035d0:	b8 23 00 00 00       	mov    $0x23,%eax
f01035d5:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01035d7:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01035d9:	b8 10 00 00 00       	mov    $0x10,%eax
f01035de:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01035e0:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01035e2:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01035e4:	ea eb 35 10 f0 08 00 	ljmp   $0x8,$0xf01035eb
	asm volatile("lldt %0" : : "r" (sel));
f01035eb:	b8 00 00 00 00       	mov    $0x0,%eax
f01035f0:	0f 00 d0             	lldt   %ax
}
f01035f3:	c3                   	ret    

f01035f4 <env_init>:
{
f01035f4:	55                   	push   %ebp
f01035f5:	89 e5                	mov    %esp,%ebp
f01035f7:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f01035fa:	8b 15 44 a2 57 f0    	mov    0xf057a244,%edx
f0103600:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
f0103606:	81 c2 00 00 02 00    	add    $0x20000,%edx
f010360c:	c7 40 c8 00 00 00 00 	movl   $0x0,-0x38(%eax)
		envs[i].env_link = &envs[i+1];
f0103613:	89 40 c4             	mov    %eax,-0x3c(%eax)
f0103616:	83 e8 80             	sub    $0xffffff80,%eax
	for(int i = 0; i < NENV - 1; i++){
f0103619:	39 d0                	cmp    %edx,%eax
f010361b:	75 ef                	jne    f010360c <env_init+0x18>
	env_free_list = envs;
f010361d:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
f0103622:	a3 48 a2 57 f0       	mov    %eax,0xf057a248
	env_init_percpu();
f0103627:	e8 9c ff ff ff       	call   f01035c8 <env_init_percpu>
}
f010362c:	c9                   	leave  
f010362d:	c3                   	ret    

f010362e <env_alloc>:
{
f010362e:	55                   	push   %ebp
f010362f:	89 e5                	mov    %esp,%ebp
f0103631:	53                   	push   %ebx
f0103632:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103635:	8b 1d 48 a2 57 f0    	mov    0xf057a248,%ebx
f010363b:	85 db                	test   %ebx,%ebx
f010363d:	0f 84 75 01 00 00    	je     f01037b8 <env_alloc+0x18a>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103643:	83 ec 0c             	sub    $0xc,%esp
f0103646:	6a 01                	push   $0x1
f0103648:	e8 77 dc ff ff       	call   f01012c4 <page_alloc>
f010364d:	83 c4 10             	add    $0x10,%esp
f0103650:	85 c0                	test   %eax,%eax
f0103652:	0f 84 67 01 00 00    	je     f01037bf <env_alloc+0x191>
	p->pp_ref++;
f0103658:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010365d:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f0103663:	c1 f8 03             	sar    $0x3,%eax
f0103666:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103669:	89 c2                	mov    %eax,%edx
f010366b:	c1 ea 0c             	shr    $0xc,%edx
f010366e:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f0103674:	0f 83 17 01 00 00    	jae    f0103791 <env_alloc+0x163>
	return (void *)(pa + KERNBASE);
f010367a:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f010367f:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy((void *)e->env_pgdir, (void *)kern_pgdir, PGSIZE);
f0103682:	83 ec 04             	sub    $0x4,%esp
f0103685:	68 00 10 00 00       	push   $0x1000
f010368a:	ff 35 ac be 57 f0    	pushl  0xf057beac
f0103690:	50                   	push   %eax
f0103691:	e8 b9 2e 00 00       	call   f010654f <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103696:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103699:	83 c4 10             	add    $0x10,%esp
f010369c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01036a1:	0f 86 fc 00 00 00    	jbe    f01037a3 <env_alloc+0x175>
	return (physaddr_t)kva - KERNBASE;
f01036a7:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01036ad:	83 ca 05             	or     $0x5,%edx
f01036b0:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01036b6:	8b 43 48             	mov    0x48(%ebx),%eax
f01036b9:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f01036be:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f01036c3:	ba 00 10 00 00       	mov    $0x1000,%edx
f01036c8:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01036cb:	89 da                	mov    %ebx,%edx
f01036cd:	2b 15 44 a2 57 f0    	sub    0xf057a244,%edx
f01036d3:	c1 fa 07             	sar    $0x7,%edx
f01036d6:	09 d0                	or     %edx,%eax
f01036d8:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01036db:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036de:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01036e1:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01036e8:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01036ef:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f01036f6:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01036fd:	83 ec 04             	sub    $0x4,%esp
f0103700:	6a 44                	push   $0x44
f0103702:	6a 00                	push   $0x0
f0103704:	53                   	push   %ebx
f0103705:	e8 9b 2d 00 00       	call   f01064a5 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f010370a:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103710:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103716:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010371c:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103723:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103729:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103730:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103737:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f010373b:	8b 43 44             	mov    0x44(%ebx),%eax
f010373e:	a3 48 a2 57 f0       	mov    %eax,0xf057a248
	*newenv_store = e;
f0103743:	8b 45 08             	mov    0x8(%ebp),%eax
f0103746:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103748:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010374b:	e8 5e 33 00 00       	call   f0106aae <cpunum>
f0103750:	6b c0 74             	imul   $0x74,%eax,%eax
f0103753:	83 c4 10             	add    $0x10,%esp
f0103756:	ba 00 00 00 00       	mov    $0x0,%edx
f010375b:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0103762:	74 11                	je     f0103775 <env_alloc+0x147>
f0103764:	e8 45 33 00 00       	call   f0106aae <cpunum>
f0103769:	6b c0 74             	imul   $0x74,%eax,%eax
f010376c:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103772:	8b 50 48             	mov    0x48(%eax),%edx
f0103775:	83 ec 04             	sub    $0x4,%esp
f0103778:	53                   	push   %ebx
f0103779:	52                   	push   %edx
f010377a:	68 0a 8c 10 f0       	push   $0xf0108c0a
f010377f:	e8 dc 06 00 00       	call   f0103e60 <cprintf>
	return 0;
f0103784:	83 c4 10             	add    $0x10,%esp
f0103787:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010378c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010378f:	c9                   	leave  
f0103790:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103791:	50                   	push   %eax
f0103792:	68 d4 76 10 f0       	push   $0xf01076d4
f0103797:	6a 58                	push   $0x58
f0103799:	68 71 88 10 f0       	push   $0xf0108871
f010379e:	e8 a6 c8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037a3:	50                   	push   %eax
f01037a4:	68 f8 76 10 f0       	push   $0xf01076f8
f01037a9:	68 c2 00 00 00       	push   $0xc2
f01037ae:	68 e6 8b 10 f0       	push   $0xf0108be6
f01037b3:	e8 91 c8 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f01037b8:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01037bd:	eb cd                	jmp    f010378c <env_alloc+0x15e>
		return -E_NO_MEM;
f01037bf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01037c4:	eb c6                	jmp    f010378c <env_alloc+0x15e>

f01037c6 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f01037c6:	55                   	push   %ebp
f01037c7:	89 e5                	mov    %esp,%ebp
f01037c9:	57                   	push   %edi
f01037ca:	56                   	push   %esi
f01037cb:	53                   	push   %ebx
f01037cc:	83 ec 34             	sub    $0x34,%esp
f01037cf:	8b 7d 08             	mov    0x8(%ebp),%edi
f01037d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	struct Env *e;
	int ret = env_alloc(&e, 0);
f01037d5:	6a 00                	push   $0x0
f01037d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01037da:	50                   	push   %eax
f01037db:	e8 4e fe ff ff       	call   f010362e <env_alloc>
	if(ret)
f01037e0:	83 c4 10             	add    $0x10,%esp
f01037e3:	85 c0                	test   %eax,%eax
f01037e5:	75 49                	jne    f0103830 <env_create+0x6a>
		panic("env_alloc failed\n");
	e->env_parent_id = 0;
f01037e7:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01037ea:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
	e->env_type = type;
f01037f1:	89 5e 50             	mov    %ebx,0x50(%esi)
	if(type == ENV_TYPE_FS){
f01037f4:	83 fb 01             	cmp    $0x1,%ebx
f01037f7:	74 4e                	je     f0103847 <env_create+0x81>
	if (elf->e_magic != ELF_MAGIC)
f01037f9:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f01037ff:	75 4f                	jne    f0103850 <env_create+0x8a>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103801:	89 fb                	mov    %edi,%ebx
f0103803:	03 5f 1c             	add    0x1c(%edi),%ebx
	eph = ph + elf->e_phnum;
f0103806:	0f b7 47 2c          	movzwl 0x2c(%edi),%eax
f010380a:	c1 e0 05             	shl    $0x5,%eax
f010380d:	01 d8                	add    %ebx,%eax
f010380f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	lcr3(PADDR(e->env_pgdir));
f0103812:	8b 46 60             	mov    0x60(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103815:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010381a:	76 4b                	jbe    f0103867 <env_create+0xa1>
	return (physaddr_t)kva - KERNBASE;
f010381c:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103821:	0f 22 d8             	mov    %eax,%cr3
	uint32_t elf_load_sz = 0;
f0103824:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010382b:	e9 89 00 00 00       	jmp    f01038b9 <env_create+0xf3>
		panic("env_alloc failed\n");
f0103830:	83 ec 04             	sub    $0x4,%esp
f0103833:	68 1f 8c 10 f0       	push   $0xf0108c1f
f0103838:	68 99 01 00 00       	push   $0x199
f010383d:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103842:	e8 02 c8 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103847:	81 4e 38 00 30 00 00 	orl    $0x3000,0x38(%esi)
f010384e:	eb a9                	jmp    f01037f9 <env_create+0x33>
		panic("is this a valid ELF");
f0103850:	83 ec 04             	sub    $0x4,%esp
f0103853:	68 31 8c 10 f0       	push   $0xf0108c31
f0103858:	68 70 01 00 00       	push   $0x170
f010385d:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103862:	e8 e2 c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103867:	50                   	push   %eax
f0103868:	68 f8 76 10 f0       	push   $0xf01076f8
f010386d:	68 75 01 00 00       	push   $0x175
f0103872:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103877:	e8 cd c7 ff ff       	call   f0100049 <_panic>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f010387c:	8b 4b 14             	mov    0x14(%ebx),%ecx
f010387f:	8b 53 08             	mov    0x8(%ebx),%edx
f0103882:	89 f0                	mov    %esi,%eax
f0103884:	e8 1f fc ff ff       	call   f01034a8 <region_alloc>
			memset((void *)ph->p_va, 0, ph->p_memsz);
f0103889:	83 ec 04             	sub    $0x4,%esp
f010388c:	ff 73 14             	pushl  0x14(%ebx)
f010388f:	6a 00                	push   $0x0
f0103891:	ff 73 08             	pushl  0x8(%ebx)
f0103894:	e8 0c 2c 00 00       	call   f01064a5 <memset>
			memcpy((void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f0103899:	83 c4 0c             	add    $0xc,%esp
f010389c:	ff 73 10             	pushl  0x10(%ebx)
f010389f:	89 f8                	mov    %edi,%eax
f01038a1:	03 43 04             	add    0x4(%ebx),%eax
f01038a4:	50                   	push   %eax
f01038a5:	ff 73 08             	pushl  0x8(%ebx)
f01038a8:	e8 a2 2c 00 00       	call   f010654f <memcpy>
			elf_load_sz += ph->p_memsz;
f01038ad:	8b 53 14             	mov    0x14(%ebx),%edx
f01038b0:	01 55 d4             	add    %edx,-0x2c(%ebp)
f01038b3:	83 c4 10             	add    $0x10,%esp
	for (; ph < eph; ph++){
f01038b6:	83 c3 20             	add    $0x20,%ebx
f01038b9:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f01038bc:	76 07                	jbe    f01038c5 <env_create+0xff>
		if(ph->p_type == ELF_PROG_LOAD){
f01038be:	83 3b 01             	cmpl   $0x1,(%ebx)
f01038c1:	75 f3                	jne    f01038b6 <env_create+0xf0>
f01038c3:	eb b7                	jmp    f010387c <env_create+0xb6>
	e->env_tf.tf_eip = elf->e_entry;
f01038c5:	8b 47 18             	mov    0x18(%edi),%eax
f01038c8:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f01038cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01038ce:	05 00 00 80 00       	add    $0x800000,%eax
f01038d3:	89 46 7c             	mov    %eax,0x7c(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f01038d6:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01038db:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01038e0:	89 f0                	mov    %esi,%eax
f01038e2:	e8 c1 fb ff ff       	call   f01034a8 <region_alloc>
	lcr3(PADDR(kern_pgdir));
f01038e7:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f01038ec:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01038f1:	76 10                	jbe    f0103903 <env_create+0x13d>
	return (physaddr_t)kva - KERNBASE;
f01038f3:	05 00 00 00 10       	add    $0x10000000,%eax
f01038f8:	0f 22 d8             	mov    %eax,%cr3
	}
	load_icode(e, binary);
}
f01038fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01038fe:	5b                   	pop    %ebx
f01038ff:	5e                   	pop    %esi
f0103900:	5f                   	pop    %edi
f0103901:	5d                   	pop    %ebp
f0103902:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103903:	50                   	push   %eax
f0103904:	68 f8 76 10 f0       	push   $0xf01076f8
f0103909:	68 85 01 00 00       	push   $0x185
f010390e:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103913:	e8 31 c7 ff ff       	call   f0100049 <_panic>

f0103918 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103918:	55                   	push   %ebp
f0103919:	89 e5                	mov    %esp,%ebp
f010391b:	57                   	push   %edi
f010391c:	56                   	push   %esi
f010391d:	53                   	push   %ebx
f010391e:	83 ec 1c             	sub    $0x1c,%esp
f0103921:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103924:	e8 85 31 00 00       	call   f0106aae <cpunum>
f0103929:	6b c0 74             	imul   $0x74,%eax,%eax
f010392c:	39 b8 28 c0 57 f0    	cmp    %edi,-0xfa83fd8(%eax)
f0103932:	74 48                	je     f010397c <env_free+0x64>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103934:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103937:	e8 72 31 00 00       	call   f0106aae <cpunum>
f010393c:	6b c0 74             	imul   $0x74,%eax,%eax
f010393f:	ba 00 00 00 00       	mov    $0x0,%edx
f0103944:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f010394b:	74 11                	je     f010395e <env_free+0x46>
f010394d:	e8 5c 31 00 00       	call   f0106aae <cpunum>
f0103952:	6b c0 74             	imul   $0x74,%eax,%eax
f0103955:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010395b:	8b 50 48             	mov    0x48(%eax),%edx
f010395e:	83 ec 04             	sub    $0x4,%esp
f0103961:	53                   	push   %ebx
f0103962:	52                   	push   %edx
f0103963:	68 45 8c 10 f0       	push   $0xf0108c45
f0103968:	e8 f3 04 00 00       	call   f0103e60 <cprintf>
f010396d:	83 c4 10             	add    $0x10,%esp
f0103970:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103977:	e9 a9 00 00 00       	jmp    f0103a25 <env_free+0x10d>
		lcr3(PADDR(kern_pgdir));
f010397c:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f0103981:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103986:	76 0a                	jbe    f0103992 <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f0103988:	05 00 00 00 10       	add    $0x10000000,%eax
f010398d:	0f 22 d8             	mov    %eax,%cr3
f0103990:	eb a2                	jmp    f0103934 <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103992:	50                   	push   %eax
f0103993:	68 f8 76 10 f0       	push   $0xf01076f8
f0103998:	68 b0 01 00 00       	push   $0x1b0
f010399d:	68 e6 8b 10 f0       	push   $0xf0108be6
f01039a2:	e8 a2 c6 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01039a7:	56                   	push   %esi
f01039a8:	68 d4 76 10 f0       	push   $0xf01076d4
f01039ad:	68 bf 01 00 00       	push   $0x1bf
f01039b2:	68 e6 8b 10 f0       	push   $0xf0108be6
f01039b7:	e8 8d c6 ff ff       	call   f0100049 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01039bc:	83 ec 08             	sub    $0x8,%esp
f01039bf:	89 d8                	mov    %ebx,%eax
f01039c1:	c1 e0 0c             	shl    $0xc,%eax
f01039c4:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01039c7:	50                   	push   %eax
f01039c8:	ff 77 60             	pushl  0x60(%edi)
f01039cb:	e8 ea db ff ff       	call   f01015ba <page_remove>
f01039d0:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01039d3:	83 c3 01             	add    $0x1,%ebx
f01039d6:	83 c6 04             	add    $0x4,%esi
f01039d9:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f01039df:	74 07                	je     f01039e8 <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f01039e1:	f6 06 01             	testb  $0x1,(%esi)
f01039e4:	74 ed                	je     f01039d3 <env_free+0xbb>
f01039e6:	eb d4                	jmp    f01039bc <env_free+0xa4>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f01039e8:	8b 47 60             	mov    0x60(%edi),%eax
f01039eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01039ee:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f01039f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01039f8:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f01039fe:	73 69                	jae    f0103a69 <env_free+0x151>
		page_decref(pa2page(pa));
f0103a00:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103a03:	a1 b0 be 57 f0       	mov    0xf057beb0,%eax
f0103a08:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103a0b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103a0e:	50                   	push   %eax
f0103a0f:	e8 5d d9 ff ff       	call   f0101371 <page_decref>
f0103a14:	83 c4 10             	add    $0x10,%esp
f0103a17:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103a1e:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103a23:	74 58                	je     f0103a7d <env_free+0x165>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103a25:	8b 47 60             	mov    0x60(%edi),%eax
f0103a28:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a2b:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103a2e:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103a34:	74 e1                	je     f0103a17 <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103a36:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103a3c:	89 f0                	mov    %esi,%eax
f0103a3e:	c1 e8 0c             	shr    $0xc,%eax
f0103a41:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103a44:	39 05 a8 be 57 f0    	cmp    %eax,0xf057bea8
f0103a4a:	0f 86 57 ff ff ff    	jbe    f01039a7 <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0103a50:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103a59:	c1 e0 14             	shl    $0x14,%eax
f0103a5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103a5f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103a64:	e9 78 ff ff ff       	jmp    f01039e1 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f0103a69:	83 ec 04             	sub    $0x4,%esp
f0103a6c:	68 b0 7f 10 f0       	push   $0xf0107fb0
f0103a71:	6a 51                	push   $0x51
f0103a73:	68 71 88 10 f0       	push   $0xf0108871
f0103a78:	e8 cc c5 ff ff       	call   f0100049 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103a7d:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103a80:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a85:	76 49                	jbe    f0103ad0 <env_free+0x1b8>
	e->env_pgdir = 0;
f0103a87:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103a8e:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0103a93:	c1 e8 0c             	shr    $0xc,%eax
f0103a96:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f0103a9c:	73 47                	jae    f0103ae5 <env_free+0x1cd>
	page_decref(pa2page(pa));
f0103a9e:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103aa1:	8b 15 b0 be 57 f0    	mov    0xf057beb0,%edx
f0103aa7:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103aaa:	50                   	push   %eax
f0103aab:	e8 c1 d8 ff ff       	call   f0101371 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103ab0:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103ab7:	a1 48 a2 57 f0       	mov    0xf057a248,%eax
f0103abc:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103abf:	89 3d 48 a2 57 f0    	mov    %edi,0xf057a248
}
f0103ac5:	83 c4 10             	add    $0x10,%esp
f0103ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103acb:	5b                   	pop    %ebx
f0103acc:	5e                   	pop    %esi
f0103acd:	5f                   	pop    %edi
f0103ace:	5d                   	pop    %ebp
f0103acf:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103ad0:	50                   	push   %eax
f0103ad1:	68 f8 76 10 f0       	push   $0xf01076f8
f0103ad6:	68 cd 01 00 00       	push   $0x1cd
f0103adb:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103ae0:	e8 64 c5 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0103ae5:	83 ec 04             	sub    $0x4,%esp
f0103ae8:	68 b0 7f 10 f0       	push   $0xf0107fb0
f0103aed:	6a 51                	push   $0x51
f0103aef:	68 71 88 10 f0       	push   $0xf0108871
f0103af4:	e8 50 c5 ff ff       	call   f0100049 <_panic>

f0103af9 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103af9:	55                   	push   %ebp
f0103afa:	89 e5                	mov    %esp,%ebp
f0103afc:	53                   	push   %ebx
f0103afd:	83 ec 04             	sub    $0x4,%esp
f0103b00:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b03:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103b07:	74 21                	je     f0103b2a <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103b09:	83 ec 0c             	sub    $0xc,%esp
f0103b0c:	53                   	push   %ebx
f0103b0d:	e8 06 fe ff ff       	call   f0103918 <env_free>

	if (curenv == e) {
f0103b12:	e8 97 2f 00 00       	call   f0106aae <cpunum>
f0103b17:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b1a:	83 c4 10             	add    $0x10,%esp
f0103b1d:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f0103b23:	74 1e                	je     f0103b43 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b28:	c9                   	leave  
f0103b29:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b2a:	e8 7f 2f 00 00       	call   f0106aae <cpunum>
f0103b2f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b32:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f0103b38:	74 cf                	je     f0103b09 <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103b3a:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103b41:	eb e2                	jmp    f0103b25 <env_destroy+0x2c>
		curenv = NULL;
f0103b43:	e8 66 2f 00 00       	call   f0106aae <cpunum>
f0103b48:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b4b:	c7 80 28 c0 57 f0 00 	movl   $0x0,-0xfa83fd8(%eax)
f0103b52:	00 00 00 
		sched_yield();
f0103b55:	e8 b4 12 00 00       	call   f0104e0e <sched_yield>

f0103b5a <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103b5a:	55                   	push   %ebp
f0103b5b:	89 e5                	mov    %esp,%ebp
f0103b5d:	53                   	push   %ebx
f0103b5e:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103b61:	e8 48 2f 00 00       	call   f0106aae <cpunum>
f0103b66:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b69:	8b 98 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%ebx
f0103b6f:	e8 3a 2f 00 00       	call   f0106aae <cpunum>
f0103b74:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f0103b77:	8b 65 08             	mov    0x8(%ebp),%esp
f0103b7a:	61                   	popa   
f0103b7b:	07                   	pop    %es
f0103b7c:	1f                   	pop    %ds
f0103b7d:	83 c4 08             	add    $0x8,%esp
f0103b80:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103b81:	83 ec 04             	sub    $0x4,%esp
f0103b84:	68 5b 8c 10 f0       	push   $0xf0108c5b
f0103b89:	68 04 02 00 00       	push   $0x204
f0103b8e:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103b93:	e8 b1 c4 ff ff       	call   f0100049 <_panic>

f0103b98 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103b98:	55                   	push   %ebp
f0103b99:	89 e5                	mov    %esp,%ebp
f0103b9b:	53                   	push   %ebx
f0103b9c:	83 ec 04             	sub    $0x4,%esp
f0103b9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f0103ba2:	e8 07 2f 00 00       	call   f0106aae <cpunum>
f0103ba7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103baa:	39 98 28 c0 57 f0    	cmp    %ebx,-0xfa83fd8(%eax)
f0103bb0:	74 7e                	je     f0103c30 <env_run+0x98>
		if(curenv && curenv->env_status == ENV_RUNNING)
f0103bb2:	e8 f7 2e 00 00       	call   f0106aae <cpunum>
f0103bb7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bba:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0103bc1:	74 18                	je     f0103bdb <env_run+0x43>
f0103bc3:	e8 e6 2e 00 00       	call   f0106aae <cpunum>
f0103bc8:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bcb:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103bd1:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103bd5:	0f 84 9a 00 00 00    	je     f0103c75 <env_run+0xdd>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f0103bdb:	e8 ce 2e 00 00       	call   f0106aae <cpunum>
f0103be0:	6b c0 74             	imul   $0x74,%eax,%eax
f0103be3:	89 98 28 c0 57 f0    	mov    %ebx,-0xfa83fd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0103be9:	e8 c0 2e 00 00       	call   f0106aae <cpunum>
f0103bee:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bf1:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103bf7:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0103bfe:	e8 ab 2e 00 00       	call   f0106aae <cpunum>
f0103c03:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c06:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c0c:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f0103c10:	e8 99 2e 00 00       	call   f0106aae <cpunum>
f0103c15:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c18:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c1e:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103c21:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c26:	76 67                	jbe    f0103c8f <env_run+0xf7>
	return (physaddr_t)kva - KERNBASE;
f0103c28:	05 00 00 00 10       	add    $0x10000000,%eax
f0103c2d:	0f 22 d8             	mov    %eax,%cr3
	}
	lcr3(PADDR(curenv->env_pgdir));
f0103c30:	e8 79 2e 00 00       	call   f0106aae <cpunum>
f0103c35:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c38:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c3e:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103c41:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c46:	76 5c                	jbe    f0103ca4 <env_run+0x10c>
	return (physaddr_t)kva - KERNBASE;
f0103c48:	05 00 00 00 10       	add    $0x10000000,%eax
f0103c4d:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103c50:	83 ec 0c             	sub    $0xc,%esp
f0103c53:	68 c0 73 12 f0       	push   $0xf01273c0
f0103c58:	e8 5d 31 00 00       	call   f0106dba <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103c5d:	f3 90                	pause  
	unlock_kernel(); //lab4 bug?
	env_pop_tf(&curenv->env_tf);
f0103c5f:	e8 4a 2e 00 00       	call   f0106aae <cpunum>
f0103c64:	83 c4 04             	add    $0x4,%esp
f0103c67:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c6a:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0103c70:	e8 e5 fe ff ff       	call   f0103b5a <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0103c75:	e8 34 2e 00 00       	call   f0106aae <cpunum>
f0103c7a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c7d:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0103c83:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103c8a:	e9 4c ff ff ff       	jmp    f0103bdb <env_run+0x43>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103c8f:	50                   	push   %eax
f0103c90:	68 f8 76 10 f0       	push   $0xf01076f8
f0103c95:	68 28 02 00 00       	push   $0x228
f0103c9a:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103c9f:	e8 a5 c3 ff ff       	call   f0100049 <_panic>
f0103ca4:	50                   	push   %eax
f0103ca5:	68 f8 76 10 f0       	push   $0xf01076f8
f0103caa:	68 2a 02 00 00       	push   $0x22a
f0103caf:	68 e6 8b 10 f0       	push   $0xf0108be6
f0103cb4:	e8 90 c3 ff ff       	call   f0100049 <_panic>

f0103cb9 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103cb9:	55                   	push   %ebp
f0103cba:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103cbc:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cbf:	ba 70 00 00 00       	mov    $0x70,%edx
f0103cc4:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103cc5:	ba 71 00 00 00       	mov    $0x71,%edx
f0103cca:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103ccb:	0f b6 c0             	movzbl %al,%eax
}
f0103cce:	5d                   	pop    %ebp
f0103ccf:	c3                   	ret    

f0103cd0 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103cd0:	55                   	push   %ebp
f0103cd1:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103cd3:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cd6:	ba 70 00 00 00       	mov    $0x70,%edx
f0103cdb:	ee                   	out    %al,(%dx)
f0103cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103cdf:	ba 71 00 00 00       	mov    $0x71,%edx
f0103ce4:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103ce5:	5d                   	pop    %ebp
f0103ce6:	c3                   	ret    

f0103ce7 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103ce7:	55                   	push   %ebp
f0103ce8:	89 e5                	mov    %esp,%ebp
f0103cea:	56                   	push   %esi
f0103ceb:	53                   	push   %ebx
f0103cec:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103cef:	66 a3 a8 73 12 f0    	mov    %ax,0xf01273a8
	if (!didinit)
f0103cf5:	80 3d 4c a2 57 f0 00 	cmpb   $0x0,0xf057a24c
f0103cfc:	75 07                	jne    f0103d05 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103d01:	5b                   	pop    %ebx
f0103d02:	5e                   	pop    %esi
f0103d03:	5d                   	pop    %ebp
f0103d04:	c3                   	ret    
f0103d05:	89 c6                	mov    %eax,%esi
f0103d07:	ba 21 00 00 00       	mov    $0x21,%edx
f0103d0c:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103d0d:	66 c1 e8 08          	shr    $0x8,%ax
f0103d11:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103d16:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103d17:	83 ec 0c             	sub    $0xc,%esp
f0103d1a:	68 67 8c 10 f0       	push   $0xf0108c67
f0103d1f:	e8 3c 01 00 00       	call   f0103e60 <cprintf>
f0103d24:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103d27:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103d2c:	0f b7 f6             	movzwl %si,%esi
f0103d2f:	f7 d6                	not    %esi
f0103d31:	eb 19                	jmp    f0103d4c <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f0103d33:	83 ec 08             	sub    $0x8,%esp
f0103d36:	53                   	push   %ebx
f0103d37:	68 8f 93 10 f0       	push   $0xf010938f
f0103d3c:	e8 1f 01 00 00       	call   f0103e60 <cprintf>
f0103d41:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103d44:	83 c3 01             	add    $0x1,%ebx
f0103d47:	83 fb 10             	cmp    $0x10,%ebx
f0103d4a:	74 07                	je     f0103d53 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103d4c:	0f a3 de             	bt     %ebx,%esi
f0103d4f:	73 f3                	jae    f0103d44 <irq_setmask_8259A+0x5d>
f0103d51:	eb e0                	jmp    f0103d33 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103d53:	83 ec 0c             	sub    $0xc,%esp
f0103d56:	68 7b 8b 10 f0       	push   $0xf0108b7b
f0103d5b:	e8 00 01 00 00       	call   f0103e60 <cprintf>
f0103d60:	83 c4 10             	add    $0x10,%esp
f0103d63:	eb 99                	jmp    f0103cfe <irq_setmask_8259A+0x17>

f0103d65 <pic_init>:
{
f0103d65:	55                   	push   %ebp
f0103d66:	89 e5                	mov    %esp,%ebp
f0103d68:	57                   	push   %edi
f0103d69:	56                   	push   %esi
f0103d6a:	53                   	push   %ebx
f0103d6b:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103d6e:	c6 05 4c a2 57 f0 01 	movb   $0x1,0xf057a24c
f0103d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103d7a:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103d7f:	89 da                	mov    %ebx,%edx
f0103d81:	ee                   	out    %al,(%dx)
f0103d82:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103d87:	89 ca                	mov    %ecx,%edx
f0103d89:	ee                   	out    %al,(%dx)
f0103d8a:	bf 11 00 00 00       	mov    $0x11,%edi
f0103d8f:	be 20 00 00 00       	mov    $0x20,%esi
f0103d94:	89 f8                	mov    %edi,%eax
f0103d96:	89 f2                	mov    %esi,%edx
f0103d98:	ee                   	out    %al,(%dx)
f0103d99:	b8 20 00 00 00       	mov    $0x20,%eax
f0103d9e:	89 da                	mov    %ebx,%edx
f0103da0:	ee                   	out    %al,(%dx)
f0103da1:	b8 04 00 00 00       	mov    $0x4,%eax
f0103da6:	ee                   	out    %al,(%dx)
f0103da7:	b8 03 00 00 00       	mov    $0x3,%eax
f0103dac:	ee                   	out    %al,(%dx)
f0103dad:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103db2:	89 f8                	mov    %edi,%eax
f0103db4:	89 da                	mov    %ebx,%edx
f0103db6:	ee                   	out    %al,(%dx)
f0103db7:	b8 28 00 00 00       	mov    $0x28,%eax
f0103dbc:	89 ca                	mov    %ecx,%edx
f0103dbe:	ee                   	out    %al,(%dx)
f0103dbf:	b8 02 00 00 00       	mov    $0x2,%eax
f0103dc4:	ee                   	out    %al,(%dx)
f0103dc5:	b8 01 00 00 00       	mov    $0x1,%eax
f0103dca:	ee                   	out    %al,(%dx)
f0103dcb:	bf 68 00 00 00       	mov    $0x68,%edi
f0103dd0:	89 f8                	mov    %edi,%eax
f0103dd2:	89 f2                	mov    %esi,%edx
f0103dd4:	ee                   	out    %al,(%dx)
f0103dd5:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103dda:	89 c8                	mov    %ecx,%eax
f0103ddc:	ee                   	out    %al,(%dx)
f0103ddd:	89 f8                	mov    %edi,%eax
f0103ddf:	89 da                	mov    %ebx,%edx
f0103de1:	ee                   	out    %al,(%dx)
f0103de2:	89 c8                	mov    %ecx,%eax
f0103de4:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103de5:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f0103dec:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103df0:	75 08                	jne    f0103dfa <pic_init+0x95>
}
f0103df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103df5:	5b                   	pop    %ebx
f0103df6:	5e                   	pop    %esi
f0103df7:	5f                   	pop    %edi
f0103df8:	5d                   	pop    %ebp
f0103df9:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103dfa:	83 ec 0c             	sub    $0xc,%esp
f0103dfd:	0f b7 c0             	movzwl %ax,%eax
f0103e00:	50                   	push   %eax
f0103e01:	e8 e1 fe ff ff       	call   f0103ce7 <irq_setmask_8259A>
f0103e06:	83 c4 10             	add    $0x10,%esp
}
f0103e09:	eb e7                	jmp    f0103df2 <pic_init+0x8d>

f0103e0b <irq_eoi>:
f0103e0b:	b8 20 00 00 00       	mov    $0x20,%eax
f0103e10:	ba 20 00 00 00       	mov    $0x20,%edx
f0103e15:	ee                   	out    %al,(%dx)
f0103e16:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103e1b:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103e1c:	c3                   	ret    

f0103e1d <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103e1d:	55                   	push   %ebp
f0103e1e:	89 e5                	mov    %esp,%ebp
f0103e20:	53                   	push   %ebx
f0103e21:	83 ec 10             	sub    $0x10,%esp
f0103e24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0103e27:	ff 75 08             	pushl  0x8(%ebp)
f0103e2a:	e8 8a c9 ff ff       	call   f01007b9 <cputchar>
	(*cnt)++;
f0103e2f:	83 03 01             	addl   $0x1,(%ebx)
}
f0103e32:	83 c4 10             	add    $0x10,%esp
f0103e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103e38:	c9                   	leave  
f0103e39:	c3                   	ret    

f0103e3a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103e3a:	55                   	push   %ebp
f0103e3b:	89 e5                	mov    %esp,%ebp
f0103e3d:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103e40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103e47:	ff 75 0c             	pushl  0xc(%ebp)
f0103e4a:	ff 75 08             	pushl  0x8(%ebp)
f0103e4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103e50:	50                   	push   %eax
f0103e51:	68 1d 3e 10 f0       	push   $0xf0103e1d
f0103e56:	e8 e4 1d 00 00       	call   f0105c3f <vprintfmt>
	return cnt;
}
f0103e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103e5e:	c9                   	leave  
f0103e5f:	c3                   	ret    

f0103e60 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103e60:	55                   	push   %ebp
f0103e61:	89 e5                	mov    %esp,%ebp
f0103e63:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103e66:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103e69:	50                   	push   %eax
f0103e6a:	ff 75 08             	pushl  0x8(%ebp)
f0103e6d:	e8 c8 ff ff ff       	call   f0103e3a <vcprintf>
	va_end(ap);
	return cnt;
}
f0103e72:	c9                   	leave  
f0103e73:	c3                   	ret    

f0103e74 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103e74:	55                   	push   %ebp
f0103e75:	89 e5                	mov    %esp,%ebp
f0103e77:	57                   	push   %edi
f0103e78:	56                   	push   %esi
f0103e79:	53                   	push   %ebx
f0103e7a:	83 ec 1c             	sub    $0x1c,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int i = cpunum();
f0103e7d:	e8 2c 2c 00 00       	call   f0106aae <cpunum>
f0103e82:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0103e84:	e8 25 2c 00 00       	call   f0106aae <cpunum>
f0103e89:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e8c:	89 d9                	mov    %ebx,%ecx
f0103e8e:	c1 e1 10             	shl    $0x10,%ecx
f0103e91:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103e96:	29 ca                	sub    %ecx,%edx
f0103e98:	89 90 30 c0 57 f0    	mov    %edx,-0xfa83fd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f0103e9e:	e8 0b 2c 00 00       	call   f0106aae <cpunum>
f0103ea3:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ea6:	66 c7 80 34 c0 57 f0 	movw   $0x10,-0xfa83fcc(%eax)
f0103ead:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f0103eaf:	e8 fa 2b 00 00       	call   f0106aae <cpunum>
f0103eb4:	6b c0 74             	imul   $0x74,%eax,%eax
f0103eb7:	66 c7 80 92 c0 57 f0 	movw   $0x68,-0xfa83f6e(%eax)
f0103ebe:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0103ec0:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103ec7:	89 fb                	mov    %edi,%ebx
f0103ec9:	c1 fb 03             	sar    $0x3,%ebx
f0103ecc:	e8 dd 2b 00 00       	call   f0106aae <cpunum>
f0103ed1:	89 c6                	mov    %eax,%esi
f0103ed3:	e8 d6 2b 00 00       	call   f0106aae <cpunum>
f0103ed8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103edb:	e8 ce 2b 00 00       	call   f0106aae <cpunum>
f0103ee0:	66 c7 04 dd 40 73 12 	movw   $0x67,-0xfed8cc0(,%ebx,8)
f0103ee7:	f0 67 00 
f0103eea:	6b f6 74             	imul   $0x74,%esi,%esi
f0103eed:	81 c6 2c c0 57 f0    	add    $0xf057c02c,%esi
f0103ef3:	66 89 34 dd 42 73 12 	mov    %si,-0xfed8cbe(,%ebx,8)
f0103efa:	f0 
f0103efb:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103eff:	81 c2 2c c0 57 f0    	add    $0xf057c02c,%edx
f0103f05:	c1 ea 10             	shr    $0x10,%edx
f0103f08:	88 14 dd 44 73 12 f0 	mov    %dl,-0xfed8cbc(,%ebx,8)
f0103f0f:	c6 04 dd 46 73 12 f0 	movb   $0x40,-0xfed8cba(,%ebx,8)
f0103f16:	40 
f0103f17:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f1a:	05 2c c0 57 f0       	add    $0xf057c02c,%eax
f0103f1f:	c1 e8 18             	shr    $0x18,%eax
f0103f22:	88 04 dd 47 73 12 f0 	mov    %al,-0xfed8cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f0103f29:	c6 04 dd 45 73 12 f0 	movb   $0x89,-0xfed8cbb(,%ebx,8)
f0103f30:	89 
	asm volatile("ltr %0" : : "r" (sel));
f0103f31:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f0103f34:	b8 ac 73 12 f0       	mov    $0xf01273ac,%eax
f0103f39:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f0103f3c:	83 c4 1c             	add    $0x1c,%esp
f0103f3f:	5b                   	pop    %ebx
f0103f40:	5e                   	pop    %esi
f0103f41:	5f                   	pop    %edi
f0103f42:	5d                   	pop    %ebp
f0103f43:	c3                   	ret    

f0103f44 <trap_init>:
{
f0103f44:	55                   	push   %ebp
f0103f45:	89 e5                	mov    %esp,%ebp
f0103f47:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f0103f4a:	b8 16 4c 10 f0       	mov    $0xf0104c16,%eax
f0103f4f:	66 a3 60 a2 57 f0    	mov    %ax,0xf057a260
f0103f55:	66 c7 05 62 a2 57 f0 	movw   $0x8,0xf057a262
f0103f5c:	08 00 
f0103f5e:	c6 05 64 a2 57 f0 00 	movb   $0x0,0xf057a264
f0103f65:	c6 05 65 a2 57 f0 8e 	movb   $0x8e,0xf057a265
f0103f6c:	c1 e8 10             	shr    $0x10,%eax
f0103f6f:	66 a3 66 a2 57 f0    	mov    %ax,0xf057a266
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f0103f75:	b8 20 4c 10 f0       	mov    $0xf0104c20,%eax
f0103f7a:	66 a3 68 a2 57 f0    	mov    %ax,0xf057a268
f0103f80:	66 c7 05 6a a2 57 f0 	movw   $0x8,0xf057a26a
f0103f87:	08 00 
f0103f89:	c6 05 6c a2 57 f0 00 	movb   $0x0,0xf057a26c
f0103f90:	c6 05 6d a2 57 f0 8e 	movb   $0x8e,0xf057a26d
f0103f97:	c1 e8 10             	shr    $0x10,%eax
f0103f9a:	66 a3 6e a2 57 f0    	mov    %ax,0xf057a26e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0103fa0:	b8 2a 4c 10 f0       	mov    $0xf0104c2a,%eax
f0103fa5:	66 a3 70 a2 57 f0    	mov    %ax,0xf057a270
f0103fab:	66 c7 05 72 a2 57 f0 	movw   $0x8,0xf057a272
f0103fb2:	08 00 
f0103fb4:	c6 05 74 a2 57 f0 00 	movb   $0x0,0xf057a274
f0103fbb:	c6 05 75 a2 57 f0 8e 	movb   $0x8e,0xf057a275
f0103fc2:	c1 e8 10             	shr    $0x10,%eax
f0103fc5:	66 a3 76 a2 57 f0    	mov    %ax,0xf057a276
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f0103fcb:	b8 34 4c 10 f0       	mov    $0xf0104c34,%eax
f0103fd0:	66 a3 78 a2 57 f0    	mov    %ax,0xf057a278
f0103fd6:	66 c7 05 7a a2 57 f0 	movw   $0x8,0xf057a27a
f0103fdd:	08 00 
f0103fdf:	c6 05 7c a2 57 f0 00 	movb   $0x0,0xf057a27c
f0103fe6:	c6 05 7d a2 57 f0 ee 	movb   $0xee,0xf057a27d
f0103fed:	c1 e8 10             	shr    $0x10,%eax
f0103ff0:	66 a3 7e a2 57 f0    	mov    %ax,0xf057a27e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f0103ff6:	b8 3e 4c 10 f0       	mov    $0xf0104c3e,%eax
f0103ffb:	66 a3 80 a2 57 f0    	mov    %ax,0xf057a280
f0104001:	66 c7 05 82 a2 57 f0 	movw   $0x8,0xf057a282
f0104008:	08 00 
f010400a:	c6 05 84 a2 57 f0 00 	movb   $0x0,0xf057a284
f0104011:	c6 05 85 a2 57 f0 ee 	movb   $0xee,0xf057a285
f0104018:	c1 e8 10             	shr    $0x10,%eax
f010401b:	66 a3 86 a2 57 f0    	mov    %ax,0xf057a286
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f0104021:	b8 48 4c 10 f0       	mov    $0xf0104c48,%eax
f0104026:	66 a3 88 a2 57 f0    	mov    %ax,0xf057a288
f010402c:	66 c7 05 8a a2 57 f0 	movw   $0x8,0xf057a28a
f0104033:	08 00 
f0104035:	c6 05 8c a2 57 f0 00 	movb   $0x0,0xf057a28c
f010403c:	c6 05 8d a2 57 f0 ee 	movb   $0xee,0xf057a28d
f0104043:	c1 e8 10             	shr    $0x10,%eax
f0104046:	66 a3 8e a2 57 f0    	mov    %ax,0xf057a28e
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f010404c:	b8 52 4c 10 f0       	mov    $0xf0104c52,%eax
f0104051:	66 a3 90 a2 57 f0    	mov    %ax,0xf057a290
f0104057:	66 c7 05 92 a2 57 f0 	movw   $0x8,0xf057a292
f010405e:	08 00 
f0104060:	c6 05 94 a2 57 f0 00 	movb   $0x0,0xf057a294
f0104067:	c6 05 95 a2 57 f0 8e 	movb   $0x8e,0xf057a295
f010406e:	c1 e8 10             	shr    $0x10,%eax
f0104071:	66 a3 96 a2 57 f0    	mov    %ax,0xf057a296
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f0104077:	b8 5c 4c 10 f0       	mov    $0xf0104c5c,%eax
f010407c:	66 a3 98 a2 57 f0    	mov    %ax,0xf057a298
f0104082:	66 c7 05 9a a2 57 f0 	movw   $0x8,0xf057a29a
f0104089:	08 00 
f010408b:	c6 05 9c a2 57 f0 00 	movb   $0x0,0xf057a29c
f0104092:	c6 05 9d a2 57 f0 8e 	movb   $0x8e,0xf057a29d
f0104099:	c1 e8 10             	shr    $0x10,%eax
f010409c:	66 a3 9e a2 57 f0    	mov    %ax,0xf057a29e
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f01040a2:	b8 66 4c 10 f0       	mov    $0xf0104c66,%eax
f01040a7:	66 a3 a0 a2 57 f0    	mov    %ax,0xf057a2a0
f01040ad:	66 c7 05 a2 a2 57 f0 	movw   $0x8,0xf057a2a2
f01040b4:	08 00 
f01040b6:	c6 05 a4 a2 57 f0 00 	movb   $0x0,0xf057a2a4
f01040bd:	c6 05 a5 a2 57 f0 8e 	movb   $0x8e,0xf057a2a5
f01040c4:	c1 e8 10             	shr    $0x10,%eax
f01040c7:	66 a3 a6 a2 57 f0    	mov    %ax,0xf057a2a6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f01040cd:	b8 6e 4c 10 f0       	mov    $0xf0104c6e,%eax
f01040d2:	66 a3 b0 a2 57 f0    	mov    %ax,0xf057a2b0
f01040d8:	66 c7 05 b2 a2 57 f0 	movw   $0x8,0xf057a2b2
f01040df:	08 00 
f01040e1:	c6 05 b4 a2 57 f0 00 	movb   $0x0,0xf057a2b4
f01040e8:	c6 05 b5 a2 57 f0 8e 	movb   $0x8e,0xf057a2b5
f01040ef:	c1 e8 10             	shr    $0x10,%eax
f01040f2:	66 a3 b6 a2 57 f0    	mov    %ax,0xf057a2b6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f01040f8:	b8 76 4c 10 f0       	mov    $0xf0104c76,%eax
f01040fd:	66 a3 b8 a2 57 f0    	mov    %ax,0xf057a2b8
f0104103:	66 c7 05 ba a2 57 f0 	movw   $0x8,0xf057a2ba
f010410a:	08 00 
f010410c:	c6 05 bc a2 57 f0 00 	movb   $0x0,0xf057a2bc
f0104113:	c6 05 bd a2 57 f0 8e 	movb   $0x8e,0xf057a2bd
f010411a:	c1 e8 10             	shr    $0x10,%eax
f010411d:	66 a3 be a2 57 f0    	mov    %ax,0xf057a2be
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f0104123:	b8 7e 4c 10 f0       	mov    $0xf0104c7e,%eax
f0104128:	66 a3 c0 a2 57 f0    	mov    %ax,0xf057a2c0
f010412e:	66 c7 05 c2 a2 57 f0 	movw   $0x8,0xf057a2c2
f0104135:	08 00 
f0104137:	c6 05 c4 a2 57 f0 00 	movb   $0x0,0xf057a2c4
f010413e:	c6 05 c5 a2 57 f0 8e 	movb   $0x8e,0xf057a2c5
f0104145:	c1 e8 10             	shr    $0x10,%eax
f0104148:	66 a3 c6 a2 57 f0    	mov    %ax,0xf057a2c6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f010414e:	b8 86 4c 10 f0       	mov    $0xf0104c86,%eax
f0104153:	66 a3 c8 a2 57 f0    	mov    %ax,0xf057a2c8
f0104159:	66 c7 05 ca a2 57 f0 	movw   $0x8,0xf057a2ca
f0104160:	08 00 
f0104162:	c6 05 cc a2 57 f0 00 	movb   $0x0,0xf057a2cc
f0104169:	c6 05 cd a2 57 f0 8e 	movb   $0x8e,0xf057a2cd
f0104170:	c1 e8 10             	shr    $0x10,%eax
f0104173:	66 a3 ce a2 57 f0    	mov    %ax,0xf057a2ce
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f0104179:	b8 8e 4c 10 f0       	mov    $0xf0104c8e,%eax
f010417e:	66 a3 d0 a2 57 f0    	mov    %ax,0xf057a2d0
f0104184:	66 c7 05 d2 a2 57 f0 	movw   $0x8,0xf057a2d2
f010418b:	08 00 
f010418d:	c6 05 d4 a2 57 f0 00 	movb   $0x0,0xf057a2d4
f0104194:	c6 05 d5 a2 57 f0 8e 	movb   $0x8e,0xf057a2d5
f010419b:	c1 e8 10             	shr    $0x10,%eax
f010419e:	66 a3 d6 a2 57 f0    	mov    %ax,0xf057a2d6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f01041a4:	b8 96 4c 10 f0       	mov    $0xf0104c96,%eax
f01041a9:	66 a3 e0 a2 57 f0    	mov    %ax,0xf057a2e0
f01041af:	66 c7 05 e2 a2 57 f0 	movw   $0x8,0xf057a2e2
f01041b6:	08 00 
f01041b8:	c6 05 e4 a2 57 f0 00 	movb   $0x0,0xf057a2e4
f01041bf:	c6 05 e5 a2 57 f0 8e 	movb   $0x8e,0xf057a2e5
f01041c6:	c1 e8 10             	shr    $0x10,%eax
f01041c9:	66 a3 e6 a2 57 f0    	mov    %ax,0xf057a2e6
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f01041cf:	b8 9c 4c 10 f0       	mov    $0xf0104c9c,%eax
f01041d4:	66 a3 e8 a2 57 f0    	mov    %ax,0xf057a2e8
f01041da:	66 c7 05 ea a2 57 f0 	movw   $0x8,0xf057a2ea
f01041e1:	08 00 
f01041e3:	c6 05 ec a2 57 f0 00 	movb   $0x0,0xf057a2ec
f01041ea:	c6 05 ed a2 57 f0 8e 	movb   $0x8e,0xf057a2ed
f01041f1:	c1 e8 10             	shr    $0x10,%eax
f01041f4:	66 a3 ee a2 57 f0    	mov    %ax,0xf057a2ee
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f01041fa:	b8 a0 4c 10 f0       	mov    $0xf0104ca0,%eax
f01041ff:	66 a3 f0 a2 57 f0    	mov    %ax,0xf057a2f0
f0104205:	66 c7 05 f2 a2 57 f0 	movw   $0x8,0xf057a2f2
f010420c:	08 00 
f010420e:	c6 05 f4 a2 57 f0 00 	movb   $0x0,0xf057a2f4
f0104215:	c6 05 f5 a2 57 f0 8e 	movb   $0x8e,0xf057a2f5
f010421c:	c1 e8 10             	shr    $0x10,%eax
f010421f:	66 a3 f6 a2 57 f0    	mov    %ax,0xf057a2f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f0104225:	b8 a6 4c 10 f0       	mov    $0xf0104ca6,%eax
f010422a:	66 a3 f8 a2 57 f0    	mov    %ax,0xf057a2f8
f0104230:	66 c7 05 fa a2 57 f0 	movw   $0x8,0xf057a2fa
f0104237:	08 00 
f0104239:	c6 05 fc a2 57 f0 00 	movb   $0x0,0xf057a2fc
f0104240:	c6 05 fd a2 57 f0 8e 	movb   $0x8e,0xf057a2fd
f0104247:	c1 e8 10             	shr    $0x10,%eax
f010424a:	66 a3 fe a2 57 f0    	mov    %ax,0xf057a2fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f0104250:	b8 ac 4c 10 f0       	mov    $0xf0104cac,%eax
f0104255:	66 a3 e0 a3 57 f0    	mov    %ax,0xf057a3e0
f010425b:	66 c7 05 e2 a3 57 f0 	movw   $0x8,0xf057a3e2
f0104262:	08 00 
f0104264:	c6 05 e4 a3 57 f0 00 	movb   $0x0,0xf057a3e4
f010426b:	c6 05 e5 a3 57 f0 ee 	movb   $0xee,0xf057a3e5
f0104272:	c1 e8 10             	shr    $0x10,%eax
f0104275:	66 a3 e6 a3 57 f0    	mov    %ax,0xf057a3e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f010427b:	b8 b2 4c 10 f0       	mov    $0xf0104cb2,%eax
f0104280:	66 a3 60 a3 57 f0    	mov    %ax,0xf057a360
f0104286:	66 c7 05 62 a3 57 f0 	movw   $0x8,0xf057a362
f010428d:	08 00 
f010428f:	c6 05 64 a3 57 f0 00 	movb   $0x0,0xf057a364
f0104296:	c6 05 65 a3 57 f0 8e 	movb   $0x8e,0xf057a365
f010429d:	c1 e8 10             	shr    $0x10,%eax
f01042a0:	66 a3 66 a3 57 f0    	mov    %ax,0xf057a366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f01042a6:	b8 b8 4c 10 f0       	mov    $0xf0104cb8,%eax
f01042ab:	66 a3 68 a3 57 f0    	mov    %ax,0xf057a368
f01042b1:	66 c7 05 6a a3 57 f0 	movw   $0x8,0xf057a36a
f01042b8:	08 00 
f01042ba:	c6 05 6c a3 57 f0 00 	movb   $0x0,0xf057a36c
f01042c1:	c6 05 6d a3 57 f0 8e 	movb   $0x8e,0xf057a36d
f01042c8:	c1 e8 10             	shr    $0x10,%eax
f01042cb:	66 a3 6e a3 57 f0    	mov    %ax,0xf057a36e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f01042d1:	b8 be 4c 10 f0       	mov    $0xf0104cbe,%eax
f01042d6:	66 a3 70 a3 57 f0    	mov    %ax,0xf057a370
f01042dc:	66 c7 05 72 a3 57 f0 	movw   $0x8,0xf057a372
f01042e3:	08 00 
f01042e5:	c6 05 74 a3 57 f0 00 	movb   $0x0,0xf057a374
f01042ec:	c6 05 75 a3 57 f0 8e 	movb   $0x8e,0xf057a375
f01042f3:	c1 e8 10             	shr    $0x10,%eax
f01042f6:	66 a3 76 a3 57 f0    	mov    %ax,0xf057a376
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f01042fc:	b8 c4 4c 10 f0       	mov    $0xf0104cc4,%eax
f0104301:	66 a3 78 a3 57 f0    	mov    %ax,0xf057a378
f0104307:	66 c7 05 7a a3 57 f0 	movw   $0x8,0xf057a37a
f010430e:	08 00 
f0104310:	c6 05 7c a3 57 f0 00 	movb   $0x0,0xf057a37c
f0104317:	c6 05 7d a3 57 f0 8e 	movb   $0x8e,0xf057a37d
f010431e:	c1 e8 10             	shr    $0x10,%eax
f0104321:	66 a3 7e a3 57 f0    	mov    %ax,0xf057a37e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f0104327:	b8 ca 4c 10 f0       	mov    $0xf0104cca,%eax
f010432c:	66 a3 80 a3 57 f0    	mov    %ax,0xf057a380
f0104332:	66 c7 05 82 a3 57 f0 	movw   $0x8,0xf057a382
f0104339:	08 00 
f010433b:	c6 05 84 a3 57 f0 00 	movb   $0x0,0xf057a384
f0104342:	c6 05 85 a3 57 f0 8e 	movb   $0x8e,0xf057a385
f0104349:	c1 e8 10             	shr    $0x10,%eax
f010434c:	66 a3 86 a3 57 f0    	mov    %ax,0xf057a386
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f0104352:	b8 d0 4c 10 f0       	mov    $0xf0104cd0,%eax
f0104357:	66 a3 88 a3 57 f0    	mov    %ax,0xf057a388
f010435d:	66 c7 05 8a a3 57 f0 	movw   $0x8,0xf057a38a
f0104364:	08 00 
f0104366:	c6 05 8c a3 57 f0 00 	movb   $0x0,0xf057a38c
f010436d:	c6 05 8d a3 57 f0 8e 	movb   $0x8e,0xf057a38d
f0104374:	c1 e8 10             	shr    $0x10,%eax
f0104377:	66 a3 8e a3 57 f0    	mov    %ax,0xf057a38e
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f010437d:	b8 d6 4c 10 f0       	mov    $0xf0104cd6,%eax
f0104382:	66 a3 90 a3 57 f0    	mov    %ax,0xf057a390
f0104388:	66 c7 05 92 a3 57 f0 	movw   $0x8,0xf057a392
f010438f:	08 00 
f0104391:	c6 05 94 a3 57 f0 00 	movb   $0x0,0xf057a394
f0104398:	c6 05 95 a3 57 f0 8e 	movb   $0x8e,0xf057a395
f010439f:	c1 e8 10             	shr    $0x10,%eax
f01043a2:	66 a3 96 a3 57 f0    	mov    %ax,0xf057a396
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f01043a8:	b8 dc 4c 10 f0       	mov    $0xf0104cdc,%eax
f01043ad:	66 a3 98 a3 57 f0    	mov    %ax,0xf057a398
f01043b3:	66 c7 05 9a a3 57 f0 	movw   $0x8,0xf057a39a
f01043ba:	08 00 
f01043bc:	c6 05 9c a3 57 f0 00 	movb   $0x0,0xf057a39c
f01043c3:	c6 05 9d a3 57 f0 8e 	movb   $0x8e,0xf057a39d
f01043ca:	c1 e8 10             	shr    $0x10,%eax
f01043cd:	66 a3 9e a3 57 f0    	mov    %ax,0xf057a39e
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f01043d3:	b8 e2 4c 10 f0       	mov    $0xf0104ce2,%eax
f01043d8:	66 a3 a0 a3 57 f0    	mov    %ax,0xf057a3a0
f01043de:	66 c7 05 a2 a3 57 f0 	movw   $0x8,0xf057a3a2
f01043e5:	08 00 
f01043e7:	c6 05 a4 a3 57 f0 00 	movb   $0x0,0xf057a3a4
f01043ee:	c6 05 a5 a3 57 f0 8e 	movb   $0x8e,0xf057a3a5
f01043f5:	c1 e8 10             	shr    $0x10,%eax
f01043f8:	66 a3 a6 a3 57 f0    	mov    %ax,0xf057a3a6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f01043fe:	b8 e8 4c 10 f0       	mov    $0xf0104ce8,%eax
f0104403:	66 a3 a8 a3 57 f0    	mov    %ax,0xf057a3a8
f0104409:	66 c7 05 aa a3 57 f0 	movw   $0x8,0xf057a3aa
f0104410:	08 00 
f0104412:	c6 05 ac a3 57 f0 00 	movb   $0x0,0xf057a3ac
f0104419:	c6 05 ad a3 57 f0 8e 	movb   $0x8e,0xf057a3ad
f0104420:	c1 e8 10             	shr    $0x10,%eax
f0104423:	66 a3 ae a3 57 f0    	mov    %ax,0xf057a3ae
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f0104429:	b8 ee 4c 10 f0       	mov    $0xf0104cee,%eax
f010442e:	66 a3 b0 a3 57 f0    	mov    %ax,0xf057a3b0
f0104434:	66 c7 05 b2 a3 57 f0 	movw   $0x8,0xf057a3b2
f010443b:	08 00 
f010443d:	c6 05 b4 a3 57 f0 00 	movb   $0x0,0xf057a3b4
f0104444:	c6 05 b5 a3 57 f0 8e 	movb   $0x8e,0xf057a3b5
f010444b:	c1 e8 10             	shr    $0x10,%eax
f010444e:	66 a3 b6 a3 57 f0    	mov    %ax,0xf057a3b6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f0104454:	b8 f4 4c 10 f0       	mov    $0xf0104cf4,%eax
f0104459:	66 a3 b8 a3 57 f0    	mov    %ax,0xf057a3b8
f010445f:	66 c7 05 ba a3 57 f0 	movw   $0x8,0xf057a3ba
f0104466:	08 00 
f0104468:	c6 05 bc a3 57 f0 00 	movb   $0x0,0xf057a3bc
f010446f:	c6 05 bd a3 57 f0 8e 	movb   $0x8e,0xf057a3bd
f0104476:	c1 e8 10             	shr    $0x10,%eax
f0104479:	66 a3 be a3 57 f0    	mov    %ax,0xf057a3be
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f010447f:	b8 fa 4c 10 f0       	mov    $0xf0104cfa,%eax
f0104484:	66 a3 c0 a3 57 f0    	mov    %ax,0xf057a3c0
f010448a:	66 c7 05 c2 a3 57 f0 	movw   $0x8,0xf057a3c2
f0104491:	08 00 
f0104493:	c6 05 c4 a3 57 f0 00 	movb   $0x0,0xf057a3c4
f010449a:	c6 05 c5 a3 57 f0 8e 	movb   $0x8e,0xf057a3c5
f01044a1:	c1 e8 10             	shr    $0x10,%eax
f01044a4:	66 a3 c6 a3 57 f0    	mov    %ax,0xf057a3c6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f01044aa:	b8 00 4d 10 f0       	mov    $0xf0104d00,%eax
f01044af:	66 a3 c8 a3 57 f0    	mov    %ax,0xf057a3c8
f01044b5:	66 c7 05 ca a3 57 f0 	movw   $0x8,0xf057a3ca
f01044bc:	08 00 
f01044be:	c6 05 cc a3 57 f0 00 	movb   $0x0,0xf057a3cc
f01044c5:	c6 05 cd a3 57 f0 8e 	movb   $0x8e,0xf057a3cd
f01044cc:	c1 e8 10             	shr    $0x10,%eax
f01044cf:	66 a3 ce a3 57 f0    	mov    %ax,0xf057a3ce
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f01044d5:	b8 06 4d 10 f0       	mov    $0xf0104d06,%eax
f01044da:	66 a3 d0 a3 57 f0    	mov    %ax,0xf057a3d0
f01044e0:	66 c7 05 d2 a3 57 f0 	movw   $0x8,0xf057a3d2
f01044e7:	08 00 
f01044e9:	c6 05 d4 a3 57 f0 00 	movb   $0x0,0xf057a3d4
f01044f0:	c6 05 d5 a3 57 f0 8e 	movb   $0x8e,0xf057a3d5
f01044f7:	c1 e8 10             	shr    $0x10,%eax
f01044fa:	66 a3 d6 a3 57 f0    	mov    %ax,0xf057a3d6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f0104500:	b8 0c 4d 10 f0       	mov    $0xf0104d0c,%eax
f0104505:	66 a3 d8 a3 57 f0    	mov    %ax,0xf057a3d8
f010450b:	66 c7 05 da a3 57 f0 	movw   $0x8,0xf057a3da
f0104512:	08 00 
f0104514:	c6 05 dc a3 57 f0 00 	movb   $0x0,0xf057a3dc
f010451b:	c6 05 dd a3 57 f0 8e 	movb   $0x8e,0xf057a3dd
f0104522:	c1 e8 10             	shr    $0x10,%eax
f0104525:	66 a3 de a3 57 f0    	mov    %ax,0xf057a3de
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f010452b:	b8 12 4d 10 f0       	mov    $0xf0104d12,%eax
f0104530:	66 a3 f8 a3 57 f0    	mov    %ax,0xf057a3f8
f0104536:	66 c7 05 fa a3 57 f0 	movw   $0x8,0xf057a3fa
f010453d:	08 00 
f010453f:	c6 05 fc a3 57 f0 00 	movb   $0x0,0xf057a3fc
f0104546:	c6 05 fd a3 57 f0 8e 	movb   $0x8e,0xf057a3fd
f010454d:	c1 e8 10             	shr    $0x10,%eax
f0104550:	66 a3 fe a3 57 f0    	mov    %ax,0xf057a3fe
	trap_init_percpu();
f0104556:	e8 19 f9 ff ff       	call   f0103e74 <trap_init_percpu>
}
f010455b:	c9                   	leave  
f010455c:	c3                   	ret    

f010455d <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f010455d:	55                   	push   %ebp
f010455e:	89 e5                	mov    %esp,%ebp
f0104560:	53                   	push   %ebx
f0104561:	83 ec 0c             	sub    $0xc,%esp
f0104564:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104567:	ff 33                	pushl  (%ebx)
f0104569:	68 7b 8c 10 f0       	push   $0xf0108c7b
f010456e:	e8 ed f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104573:	83 c4 08             	add    $0x8,%esp
f0104576:	ff 73 04             	pushl  0x4(%ebx)
f0104579:	68 8a 8c 10 f0       	push   $0xf0108c8a
f010457e:	e8 dd f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104583:	83 c4 08             	add    $0x8,%esp
f0104586:	ff 73 08             	pushl  0x8(%ebx)
f0104589:	68 99 8c 10 f0       	push   $0xf0108c99
f010458e:	e8 cd f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104593:	83 c4 08             	add    $0x8,%esp
f0104596:	ff 73 0c             	pushl  0xc(%ebx)
f0104599:	68 a8 8c 10 f0       	push   $0xf0108ca8
f010459e:	e8 bd f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01045a3:	83 c4 08             	add    $0x8,%esp
f01045a6:	ff 73 10             	pushl  0x10(%ebx)
f01045a9:	68 b7 8c 10 f0       	push   $0xf0108cb7
f01045ae:	e8 ad f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01045b3:	83 c4 08             	add    $0x8,%esp
f01045b6:	ff 73 14             	pushl  0x14(%ebx)
f01045b9:	68 c6 8c 10 f0       	push   $0xf0108cc6
f01045be:	e8 9d f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01045c3:	83 c4 08             	add    $0x8,%esp
f01045c6:	ff 73 18             	pushl  0x18(%ebx)
f01045c9:	68 d5 8c 10 f0       	push   $0xf0108cd5
f01045ce:	e8 8d f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01045d3:	83 c4 08             	add    $0x8,%esp
f01045d6:	ff 73 1c             	pushl  0x1c(%ebx)
f01045d9:	68 e4 8c 10 f0       	push   $0xf0108ce4
f01045de:	e8 7d f8 ff ff       	call   f0103e60 <cprintf>
}
f01045e3:	83 c4 10             	add    $0x10,%esp
f01045e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01045e9:	c9                   	leave  
f01045ea:	c3                   	ret    

f01045eb <print_trapframe>:
{
f01045eb:	55                   	push   %ebp
f01045ec:	89 e5                	mov    %esp,%ebp
f01045ee:	56                   	push   %esi
f01045ef:	53                   	push   %ebx
f01045f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01045f3:	e8 b6 24 00 00       	call   f0106aae <cpunum>
f01045f8:	83 ec 04             	sub    $0x4,%esp
f01045fb:	50                   	push   %eax
f01045fc:	53                   	push   %ebx
f01045fd:	68 48 8d 10 f0       	push   $0xf0108d48
f0104602:	e8 59 f8 ff ff       	call   f0103e60 <cprintf>
	print_regs(&tf->tf_regs);
f0104607:	89 1c 24             	mov    %ebx,(%esp)
f010460a:	e8 4e ff ff ff       	call   f010455d <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f010460f:	83 c4 08             	add    $0x8,%esp
f0104612:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104616:	50                   	push   %eax
f0104617:	68 66 8d 10 f0       	push   $0xf0108d66
f010461c:	e8 3f f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104621:	83 c4 08             	add    $0x8,%esp
f0104624:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104628:	50                   	push   %eax
f0104629:	68 79 8d 10 f0       	push   $0xf0108d79
f010462e:	e8 2d f8 ff ff       	call   f0103e60 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104633:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104636:	83 c4 10             	add    $0x10,%esp
f0104639:	83 f8 13             	cmp    $0x13,%eax
f010463c:	0f 86 e1 00 00 00    	jbe    f0104723 <print_trapframe+0x138>
		return "System call";
f0104642:	ba f3 8c 10 f0       	mov    $0xf0108cf3,%edx
	if (trapno == T_SYSCALL)
f0104647:	83 f8 30             	cmp    $0x30,%eax
f010464a:	74 13                	je     f010465f <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f010464c:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f010464f:	83 fa 0f             	cmp    $0xf,%edx
f0104652:	ba ff 8c 10 f0       	mov    $0xf0108cff,%edx
f0104657:	b9 0e 8d 10 f0       	mov    $0xf0108d0e,%ecx
f010465c:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010465f:	83 ec 04             	sub    $0x4,%esp
f0104662:	52                   	push   %edx
f0104663:	50                   	push   %eax
f0104664:	68 8c 8d 10 f0       	push   $0xf0108d8c
f0104669:	e8 f2 f7 ff ff       	call   f0103e60 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010466e:	83 c4 10             	add    $0x10,%esp
f0104671:	39 1d 60 aa 57 f0    	cmp    %ebx,0xf057aa60
f0104677:	0f 84 b2 00 00 00    	je     f010472f <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f010467d:	83 ec 08             	sub    $0x8,%esp
f0104680:	ff 73 2c             	pushl  0x2c(%ebx)
f0104683:	68 ad 8d 10 f0       	push   $0xf0108dad
f0104688:	e8 d3 f7 ff ff       	call   f0103e60 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f010468d:	83 c4 10             	add    $0x10,%esp
f0104690:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104694:	0f 85 b8 00 00 00    	jne    f0104752 <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f010469a:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f010469d:	89 c2                	mov    %eax,%edx
f010469f:	83 e2 01             	and    $0x1,%edx
f01046a2:	b9 21 8d 10 f0       	mov    $0xf0108d21,%ecx
f01046a7:	ba 2c 8d 10 f0       	mov    $0xf0108d2c,%edx
f01046ac:	0f 44 ca             	cmove  %edx,%ecx
f01046af:	89 c2                	mov    %eax,%edx
f01046b1:	83 e2 02             	and    $0x2,%edx
f01046b4:	be 38 8d 10 f0       	mov    $0xf0108d38,%esi
f01046b9:	ba 3e 8d 10 f0       	mov    $0xf0108d3e,%edx
f01046be:	0f 45 d6             	cmovne %esi,%edx
f01046c1:	83 e0 04             	and    $0x4,%eax
f01046c4:	b8 43 8d 10 f0       	mov    $0xf0108d43,%eax
f01046c9:	be 90 8f 10 f0       	mov    $0xf0108f90,%esi
f01046ce:	0f 44 c6             	cmove  %esi,%eax
f01046d1:	51                   	push   %ecx
f01046d2:	52                   	push   %edx
f01046d3:	50                   	push   %eax
f01046d4:	68 bb 8d 10 f0       	push   $0xf0108dbb
f01046d9:	e8 82 f7 ff ff       	call   f0103e60 <cprintf>
f01046de:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01046e1:	83 ec 08             	sub    $0x8,%esp
f01046e4:	ff 73 30             	pushl  0x30(%ebx)
f01046e7:	68 ca 8d 10 f0       	push   $0xf0108dca
f01046ec:	e8 6f f7 ff ff       	call   f0103e60 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01046f1:	83 c4 08             	add    $0x8,%esp
f01046f4:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01046f8:	50                   	push   %eax
f01046f9:	68 d9 8d 10 f0       	push   $0xf0108dd9
f01046fe:	e8 5d f7 ff ff       	call   f0103e60 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104703:	83 c4 08             	add    $0x8,%esp
f0104706:	ff 73 38             	pushl  0x38(%ebx)
f0104709:	68 ec 8d 10 f0       	push   $0xf0108dec
f010470e:	e8 4d f7 ff ff       	call   f0103e60 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104713:	83 c4 10             	add    $0x10,%esp
f0104716:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010471a:	75 4b                	jne    f0104767 <print_trapframe+0x17c>
}
f010471c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010471f:	5b                   	pop    %ebx
f0104720:	5e                   	pop    %esi
f0104721:	5d                   	pop    %ebp
f0104722:	c3                   	ret    
		return excnames[trapno];
f0104723:	8b 14 85 e0 91 10 f0 	mov    -0xfef6e20(,%eax,4),%edx
f010472a:	e9 30 ff ff ff       	jmp    f010465f <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010472f:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104733:	0f 85 44 ff ff ff    	jne    f010467d <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104739:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010473c:	83 ec 08             	sub    $0x8,%esp
f010473f:	50                   	push   %eax
f0104740:	68 9e 8d 10 f0       	push   $0xf0108d9e
f0104745:	e8 16 f7 ff ff       	call   f0103e60 <cprintf>
f010474a:	83 c4 10             	add    $0x10,%esp
f010474d:	e9 2b ff ff ff       	jmp    f010467d <print_trapframe+0x92>
		cprintf("\n");
f0104752:	83 ec 0c             	sub    $0xc,%esp
f0104755:	68 7b 8b 10 f0       	push   $0xf0108b7b
f010475a:	e8 01 f7 ff ff       	call   f0103e60 <cprintf>
f010475f:	83 c4 10             	add    $0x10,%esp
f0104762:	e9 7a ff ff ff       	jmp    f01046e1 <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104767:	83 ec 08             	sub    $0x8,%esp
f010476a:	ff 73 3c             	pushl  0x3c(%ebx)
f010476d:	68 fb 8d 10 f0       	push   $0xf0108dfb
f0104772:	e8 e9 f6 ff ff       	call   f0103e60 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104777:	83 c4 08             	add    $0x8,%esp
f010477a:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f010477e:	50                   	push   %eax
f010477f:	68 0a 8e 10 f0       	push   $0xf0108e0a
f0104784:	e8 d7 f6 ff ff       	call   f0103e60 <cprintf>
f0104789:	83 c4 10             	add    $0x10,%esp
}
f010478c:	eb 8e                	jmp    f010471c <print_trapframe+0x131>

f010478e <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f010478e:	55                   	push   %ebp
f010478f:	89 e5                	mov    %esp,%ebp
f0104791:	57                   	push   %edi
f0104792:	56                   	push   %esi
f0104793:	53                   	push   %ebx
f0104794:	83 ec 0c             	sub    $0xc,%esp
f0104797:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010479a:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f010479d:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01047a1:	83 e0 03             	and    $0x3,%eax
f01047a4:	66 83 f8 03          	cmp    $0x3,%ax
f01047a8:	75 5d                	jne    f0104807 <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f01047aa:	e8 ff 22 00 00       	call   f0106aae <cpunum>
f01047af:	6b c0 74             	imul   $0x74,%eax,%eax
f01047b2:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01047b8:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f01047bc:	75 69                	jne    f0104827 <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01047be:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f01047c1:	e8 e8 22 00 00       	call   f0106aae <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01047c6:	57                   	push   %edi
f01047c7:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f01047c8:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01047cb:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01047d1:	ff 70 48             	pushl  0x48(%eax)
f01047d4:	68 dc 90 10 f0       	push   $0xf01090dc
f01047d9:	e8 82 f6 ff ff       	call   f0103e60 <cprintf>
	print_trapframe(tf);
f01047de:	89 1c 24             	mov    %ebx,(%esp)
f01047e1:	e8 05 fe ff ff       	call   f01045eb <print_trapframe>
	env_destroy(curenv);
f01047e6:	e8 c3 22 00 00       	call   f0106aae <cpunum>
f01047eb:	83 c4 04             	add    $0x4,%esp
f01047ee:	6b c0 74             	imul   $0x74,%eax,%eax
f01047f1:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f01047f7:	e8 fd f2 ff ff       	call   f0103af9 <env_destroy>
}
f01047fc:	83 c4 10             	add    $0x10,%esp
f01047ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104802:	5b                   	pop    %ebx
f0104803:	5e                   	pop    %esi
f0104804:	5f                   	pop    %edi
f0104805:	5d                   	pop    %ebp
f0104806:	c3                   	ret    
		print_trapframe(tf);//just test
f0104807:	83 ec 0c             	sub    $0xc,%esp
f010480a:	53                   	push   %ebx
f010480b:	e8 db fd ff ff       	call   f01045eb <print_trapframe>
		panic("panic at kernel page_fault\n");
f0104810:	83 c4 0c             	add    $0xc,%esp
f0104813:	68 1d 8e 10 f0       	push   $0xf0108e1d
f0104818:	68 c1 01 00 00       	push   $0x1c1
f010481d:	68 39 8e 10 f0       	push   $0xf0108e39
f0104822:	e8 22 b8 ff ff       	call   f0100049 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104827:	8b 53 3c             	mov    0x3c(%ebx),%edx
f010482a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f010482f:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));		
f0104831:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104836:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f010483b:	77 05                	ja     f0104842 <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f010483d:	8d 42 c8             	lea    -0x38(%edx),%eax
f0104840:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f0104842:	e8 67 22 00 00       	call   f0106aae <cpunum>
f0104847:	6a 02                	push   $0x2
f0104849:	6a 34                	push   $0x34
f010484b:	57                   	push   %edi
f010484c:	6b c0 74             	imul   $0x74,%eax,%eax
f010484f:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104855:	e8 02 ec ff ff       	call   f010345c <user_mem_assert>
		utf->utf_fault_va = fault_va;
f010485a:	89 fa                	mov    %edi,%edx
f010485c:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f010485e:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104861:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0104864:	8d 7f 08             	lea    0x8(%edi),%edi
f0104867:	b9 08 00 00 00       	mov    $0x8,%ecx
f010486c:	89 de                	mov    %ebx,%esi
f010486e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0104870:	8b 43 30             	mov    0x30(%ebx),%eax
f0104873:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0104876:	8b 43 38             	mov    0x38(%ebx),%eax
f0104879:	89 d7                	mov    %edx,%edi
f010487b:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f010487e:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104881:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0104884:	e8 25 22 00 00       	call   f0106aae <cpunum>
f0104889:	6b c0 74             	imul   $0x74,%eax,%eax
f010488c:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104892:	8b 58 64             	mov    0x64(%eax),%ebx
f0104895:	e8 14 22 00 00       	call   f0106aae <cpunum>
f010489a:	6b c0 74             	imul   $0x74,%eax,%eax
f010489d:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01048a3:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f01048a6:	e8 03 22 00 00       	call   f0106aae <cpunum>
f01048ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01048ae:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01048b4:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f01048b7:	e8 f2 21 00 00       	call   f0106aae <cpunum>
f01048bc:	83 c4 04             	add    $0x4,%esp
f01048bf:	6b c0 74             	imul   $0x74,%eax,%eax
f01048c2:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f01048c8:	e8 cb f2 ff ff       	call   f0103b98 <env_run>

f01048cd <trap>:
{
f01048cd:	55                   	push   %ebp
f01048ce:	89 e5                	mov    %esp,%ebp
f01048d0:	57                   	push   %edi
f01048d1:	56                   	push   %esi
f01048d2:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f01048d5:	fc                   	cld    
	if (panicstr)
f01048d6:	83 3d a0 be 57 f0 00 	cmpl   $0x0,0xf057bea0
f01048dd:	74 01                	je     f01048e0 <trap+0x13>
		asm volatile("hlt");
f01048df:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01048e0:	e8 c9 21 00 00       	call   f0106aae <cpunum>
f01048e5:	6b d0 74             	imul   $0x74,%eax,%edx
f01048e8:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01048eb:	b8 01 00 00 00       	mov    $0x1,%eax
f01048f0:	f0 87 82 20 c0 57 f0 	lock xchg %eax,-0xfa83fe0(%edx)
f01048f7:	83 f8 02             	cmp    $0x2,%eax
f01048fa:	74 30                	je     f010492c <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01048fc:	9c                   	pushf  
f01048fd:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f01048fe:	f6 c4 02             	test   $0x2,%ah
f0104901:	75 3b                	jne    f010493e <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0104903:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104907:	83 e0 03             	and    $0x3,%eax
f010490a:	66 83 f8 03          	cmp    $0x3,%ax
f010490e:	74 47                	je     f0104957 <trap+0x8a>
	last_tf = tf;
f0104910:	89 35 60 aa 57 f0    	mov    %esi,0xf057aa60
	switch (tf->tf_trapno)
f0104916:	8b 46 28             	mov    0x28(%esi),%eax
f0104919:	83 e8 03             	sub    $0x3,%eax
f010491c:	83 f8 30             	cmp    $0x30,%eax
f010491f:	0f 87 92 02 00 00    	ja     f0104bb7 <trap+0x2ea>
f0104925:	ff 24 85 00 91 10 f0 	jmp    *-0xfef6f00(,%eax,4)
	spin_lock(&kernel_lock);
f010492c:	83 ec 0c             	sub    $0xc,%esp
f010492f:	68 c0 73 12 f0       	push   $0xf01273c0
f0104934:	e8 e5 23 00 00       	call   f0106d1e <spin_lock>
f0104939:	83 c4 10             	add    $0x10,%esp
f010493c:	eb be                	jmp    f01048fc <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f010493e:	68 45 8e 10 f0       	push   $0xf0108e45
f0104943:	68 8b 88 10 f0       	push   $0xf010888b
f0104948:	68 8c 01 00 00       	push   $0x18c
f010494d:	68 39 8e 10 f0       	push   $0xf0108e39
f0104952:	e8 f2 b6 ff ff       	call   f0100049 <_panic>
f0104957:	83 ec 0c             	sub    $0xc,%esp
f010495a:	68 c0 73 12 f0       	push   $0xf01273c0
f010495f:	e8 ba 23 00 00       	call   f0106d1e <spin_lock>
		assert(curenv);
f0104964:	e8 45 21 00 00       	call   f0106aae <cpunum>
f0104969:	6b c0 74             	imul   $0x74,%eax,%eax
f010496c:	83 c4 10             	add    $0x10,%esp
f010496f:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0104976:	74 3e                	je     f01049b6 <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f0104978:	e8 31 21 00 00       	call   f0106aae <cpunum>
f010497d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104980:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104986:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010498a:	74 43                	je     f01049cf <trap+0x102>
		curenv->env_tf = *tf;
f010498c:	e8 1d 21 00 00       	call   f0106aae <cpunum>
f0104991:	6b c0 74             	imul   $0x74,%eax,%eax
f0104994:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010499a:	b9 11 00 00 00       	mov    $0x11,%ecx
f010499f:	89 c7                	mov    %eax,%edi
f01049a1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01049a3:	e8 06 21 00 00       	call   f0106aae <cpunum>
f01049a8:	6b c0 74             	imul   $0x74,%eax,%eax
f01049ab:	8b b0 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%esi
f01049b1:	e9 5a ff ff ff       	jmp    f0104910 <trap+0x43>
		assert(curenv);
f01049b6:	68 5e 8e 10 f0       	push   $0xf0108e5e
f01049bb:	68 8b 88 10 f0       	push   $0xf010888b
f01049c0:	68 93 01 00 00       	push   $0x193
f01049c5:	68 39 8e 10 f0       	push   $0xf0108e39
f01049ca:	e8 7a b6 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f01049cf:	e8 da 20 00 00       	call   f0106aae <cpunum>
f01049d4:	83 ec 0c             	sub    $0xc,%esp
f01049d7:	6b c0 74             	imul   $0x74,%eax,%eax
f01049da:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f01049e0:	e8 33 ef ff ff       	call   f0103918 <env_free>
			curenv = NULL;
f01049e5:	e8 c4 20 00 00       	call   f0106aae <cpunum>
f01049ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01049ed:	c7 80 28 c0 57 f0 00 	movl   $0x0,-0xfa83fd8(%eax)
f01049f4:	00 00 00 
			sched_yield();
f01049f7:	e8 12 04 00 00       	call   f0104e0e <sched_yield>
			page_fault_handler(tf);
f01049fc:	83 ec 0c             	sub    $0xc,%esp
f01049ff:	56                   	push   %esi
f0104a00:	e8 89 fd ff ff       	call   f010478e <page_fault_handler>
f0104a05:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104a08:	e8 a1 20 00 00       	call   f0106aae <cpunum>
f0104a0d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a10:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0104a17:	74 18                	je     f0104a31 <trap+0x164>
f0104a19:	e8 90 20 00 00       	call   f0106aae <cpunum>
f0104a1e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a21:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104a27:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104a2b:	0f 84 ce 01 00 00    	je     f0104bff <trap+0x332>
		sched_yield();
f0104a31:	e8 d8 03 00 00       	call   f0104e0e <sched_yield>
			monitor(tf);
f0104a36:	83 ec 0c             	sub    $0xc,%esp
f0104a39:	56                   	push   %esi
f0104a3a:	e8 12 c2 ff ff       	call   f0100c51 <monitor>
f0104a3f:	83 c4 10             	add    $0x10,%esp
f0104a42:	eb c4                	jmp    f0104a08 <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0104a44:	83 ec 08             	sub    $0x8,%esp
f0104a47:	ff 76 04             	pushl  0x4(%esi)
f0104a4a:	ff 36                	pushl  (%esi)
f0104a4c:	ff 76 10             	pushl  0x10(%esi)
f0104a4f:	ff 76 18             	pushl  0x18(%esi)
f0104a52:	ff 76 14             	pushl  0x14(%esi)
f0104a55:	ff 76 1c             	pushl  0x1c(%esi)
f0104a58:	e8 75 04 00 00       	call   f0104ed2 <syscall>
f0104a5d:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104a60:	83 c4 20             	add    $0x20,%esp
f0104a63:	eb a3                	jmp    f0104a08 <trap+0x13b>
			time_tick();
f0104a65:	e8 8c 29 00 00       	call   f01073f6 <time_tick>
			lapic_eoi();
f0104a6a:	e8 86 21 00 00       	call   f0106bf5 <lapic_eoi>
			sched_yield();
f0104a6f:	e8 9a 03 00 00       	call   f0104e0e <sched_yield>
			kbd_intr();
f0104a74:	e8 9f bb ff ff       	call   f0100618 <kbd_intr>
f0104a79:	eb 8d                	jmp    f0104a08 <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0104a7b:	83 ec 0c             	sub    $0xc,%esp
f0104a7e:	68 00 8f 10 f0       	push   $0xf0108f00
f0104a83:	e8 d8 f3 ff ff       	call   f0103e60 <cprintf>
f0104a88:	83 c4 10             	add    $0x10,%esp
f0104a8b:	e9 78 ff ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0104a90:	83 ec 0c             	sub    $0xc,%esp
f0104a93:	68 17 8f 10 f0       	push   $0xf0108f17
f0104a98:	e8 c3 f3 ff ff       	call   f0103e60 <cprintf>
f0104a9d:	83 c4 10             	add    $0x10,%esp
f0104aa0:	e9 63 ff ff ff       	jmp    f0104a08 <trap+0x13b>
			serial_intr();
f0104aa5:	e8 52 bb ff ff       	call   f01005fc <serial_intr>
f0104aaa:	e9 59 ff ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0104aaf:	83 ec 0c             	sub    $0xc,%esp
f0104ab2:	68 4a 8f 10 f0       	push   $0xf0108f4a
f0104ab7:	e8 a4 f3 ff ff       	call   f0103e60 <cprintf>
f0104abc:	83 c4 10             	add    $0x10,%esp
f0104abf:	e9 44 ff ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0104ac4:	83 ec 0c             	sub    $0xc,%esp
f0104ac7:	68 65 8e 10 f0       	push   $0xf0108e65
f0104acc:	e8 8f f3 ff ff       	call   f0103e60 <cprintf>
f0104ad1:	83 c4 10             	add    $0x10,%esp
f0104ad4:	e9 2f ff ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("in Spurious\n");
f0104ad9:	83 ec 0c             	sub    $0xc,%esp
f0104adc:	68 7b 8e 10 f0       	push   $0xf0108e7b
f0104ae1:	e8 7a f3 ff ff       	call   f0103e60 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104ae6:	c7 04 24 88 8e 10 f0 	movl   $0xf0108e88,(%esp)
f0104aed:	e8 6e f3 ff ff       	call   f0103e60 <cprintf>
f0104af2:	83 c4 10             	add    $0x10,%esp
f0104af5:	e9 0e ff ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104afa:	83 ec 0c             	sub    $0xc,%esp
f0104afd:	68 a5 8e 10 f0       	push   $0xf0108ea5
f0104b02:	e8 59 f3 ff ff       	call   f0103e60 <cprintf>
f0104b07:	83 c4 10             	add    $0x10,%esp
f0104b0a:	e9 f9 fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104b0f:	83 ec 0c             	sub    $0xc,%esp
f0104b12:	68 bb 8e 10 f0       	push   $0xf0108ebb
f0104b17:	e8 44 f3 ff ff       	call   f0103e60 <cprintf>
f0104b1c:	83 c4 10             	add    $0x10,%esp
f0104b1f:	e9 e4 fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104b24:	83 ec 0c             	sub    $0xc,%esp
f0104b27:	68 d1 8e 10 f0       	push   $0xf0108ed1
f0104b2c:	e8 2f f3 ff ff       	call   f0103e60 <cprintf>
f0104b31:	83 c4 10             	add    $0x10,%esp
f0104b34:	e9 cf fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104b39:	83 ec 0c             	sub    $0xc,%esp
f0104b3c:	68 e8 8e 10 f0       	push   $0xf0108ee8
f0104b41:	e8 1a f3 ff ff       	call   f0103e60 <cprintf>
f0104b46:	83 c4 10             	add    $0x10,%esp
f0104b49:	e9 ba fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104b4e:	83 ec 0c             	sub    $0xc,%esp
f0104b51:	68 ff 8e 10 f0       	push   $0xf0108eff
f0104b56:	e8 05 f3 ff ff       	call   f0103e60 <cprintf>
f0104b5b:	83 c4 10             	add    $0x10,%esp
f0104b5e:	e9 a5 fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104b63:	83 ec 0c             	sub    $0xc,%esp
f0104b66:	68 16 8f 10 f0       	push   $0xf0108f16
f0104b6b:	e8 f0 f2 ff ff       	call   f0103e60 <cprintf>
f0104b70:	83 c4 10             	add    $0x10,%esp
f0104b73:	e9 90 fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104b78:	83 ec 0c             	sub    $0xc,%esp
f0104b7b:	68 2d 8f 10 f0       	push   $0xf0108f2d
f0104b80:	e8 db f2 ff ff       	call   f0103e60 <cprintf>
f0104b85:	83 c4 10             	add    $0x10,%esp
f0104b88:	e9 7b fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104b8d:	83 ec 0c             	sub    $0xc,%esp
f0104b90:	68 49 8f 10 f0       	push   $0xf0108f49
f0104b95:	e8 c6 f2 ff ff       	call   f0103e60 <cprintf>
f0104b9a:	83 c4 10             	add    $0x10,%esp
f0104b9d:	e9 66 fe ff ff       	jmp    f0104a08 <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104ba2:	83 ec 0c             	sub    $0xc,%esp
f0104ba5:	68 60 8f 10 f0       	push   $0xf0108f60
f0104baa:	e8 b1 f2 ff ff       	call   f0103e60 <cprintf>
f0104baf:	83 c4 10             	add    $0x10,%esp
f0104bb2:	e9 51 fe ff ff       	jmp    f0104a08 <trap+0x13b>
			print_trapframe(tf);
f0104bb7:	83 ec 0c             	sub    $0xc,%esp
f0104bba:	56                   	push   %esi
f0104bbb:	e8 2b fa ff ff       	call   f01045eb <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104bc0:	83 c4 10             	add    $0x10,%esp
f0104bc3:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104bc8:	74 1e                	je     f0104be8 <trap+0x31b>
				env_destroy(curenv);
f0104bca:	e8 df 1e 00 00       	call   f0106aae <cpunum>
f0104bcf:	83 ec 0c             	sub    $0xc,%esp
f0104bd2:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bd5:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104bdb:	e8 19 ef ff ff       	call   f0103af9 <env_destroy>
f0104be0:	83 c4 10             	add    $0x10,%esp
f0104be3:	e9 20 fe ff ff       	jmp    f0104a08 <trap+0x13b>
				panic("unhandled trap in kernel");
f0104be8:	83 ec 04             	sub    $0x4,%esp
f0104beb:	68 7e 8f 10 f0       	push   $0xf0108f7e
f0104bf0:	68 6f 01 00 00       	push   $0x16f
f0104bf5:	68 39 8e 10 f0       	push   $0xf0108e39
f0104bfa:	e8 4a b4 ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f0104bff:	e8 aa 1e 00 00       	call   f0106aae <cpunum>
f0104c04:	83 ec 0c             	sub    $0xc,%esp
f0104c07:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c0a:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104c10:	e8 83 ef ff ff       	call   f0103b98 <env_run>
f0104c15:	90                   	nop

f0104c16 <DIVIDE_HANDLER>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(DIVIDE_HANDLER   , T_DIVIDE )
f0104c16:	6a 00                	push   $0x0
f0104c18:	6a 00                	push   $0x0
f0104c1a:	e9 f9 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c1f:	90                   	nop

f0104c20 <DEBUG_HANDLER>:
	TRAPHANDLER_NOEC(DEBUG_HANDLER    , T_DEBUG  )
f0104c20:	6a 00                	push   $0x0
f0104c22:	6a 01                	push   $0x1
f0104c24:	e9 ef 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c29:	90                   	nop

f0104c2a <NMI_HANDLER>:
	TRAPHANDLER_NOEC(NMI_HANDLER      , T_NMI    )
f0104c2a:	6a 00                	push   $0x0
f0104c2c:	6a 02                	push   $0x2
f0104c2e:	e9 e5 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c33:	90                   	nop

f0104c34 <BRKPT_HANDLER>:
	TRAPHANDLER_NOEC(BRKPT_HANDLER    , T_BRKPT  )
f0104c34:	6a 00                	push   $0x0
f0104c36:	6a 03                	push   $0x3
f0104c38:	e9 db 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c3d:	90                   	nop

f0104c3e <OFLOW_HANDLER>:
	TRAPHANDLER_NOEC(OFLOW_HANDLER    , T_OFLOW  )
f0104c3e:	6a 00                	push   $0x0
f0104c40:	6a 04                	push   $0x4
f0104c42:	e9 d1 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c47:	90                   	nop

f0104c48 <BOUND_HANDLER>:
	TRAPHANDLER_NOEC(BOUND_HANDLER    , T_BOUND  )
f0104c48:	6a 00                	push   $0x0
f0104c4a:	6a 05                	push   $0x5
f0104c4c:	e9 c7 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c51:	90                   	nop

f0104c52 <ILLOP_HANDLER>:
	TRAPHANDLER_NOEC(ILLOP_HANDLER    , T_ILLOP  )
f0104c52:	6a 00                	push   $0x0
f0104c54:	6a 06                	push   $0x6
f0104c56:	e9 bd 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c5b:	90                   	nop

f0104c5c <DEVICE_HANDLER>:
	TRAPHANDLER_NOEC(DEVICE_HANDLER   , T_DEVICE )
f0104c5c:	6a 00                	push   $0x0
f0104c5e:	6a 07                	push   $0x7
f0104c60:	e9 b3 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c65:	90                   	nop

f0104c66 <DBLFLT_HANDLER>:
	TRAPHANDLER(	 DBLFLT_HANDLER   , T_DBLFLT )
f0104c66:	6a 08                	push   $0x8
f0104c68:	e9 ab 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c6d:	90                   	nop

f0104c6e <TSS_HANDLER>:
	TRAPHANDLER(	 TSS_HANDLER      , T_TSS	 )
f0104c6e:	6a 0a                	push   $0xa
f0104c70:	e9 a3 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c75:	90                   	nop

f0104c76 <SEGNP_HANDLER>:
	TRAPHANDLER(	 SEGNP_HANDLER    , T_SEGNP  )
f0104c76:	6a 0b                	push   $0xb
f0104c78:	e9 9b 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c7d:	90                   	nop

f0104c7e <STACK_HANDLER>:
	TRAPHANDLER(	 STACK_HANDLER    , T_STACK  )
f0104c7e:	6a 0c                	push   $0xc
f0104c80:	e9 93 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c85:	90                   	nop

f0104c86 <GPFLT_HANDLER>:
	TRAPHANDLER(	 GPFLT_HANDLER    , T_GPFLT  )
f0104c86:	6a 0d                	push   $0xd
f0104c88:	e9 8b 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c8d:	90                   	nop

f0104c8e <PGFLT_HANDLER>:
	TRAPHANDLER(	 PGFLT_HANDLER    , T_PGFLT  )
f0104c8e:	6a 0e                	push   $0xe
f0104c90:	e9 83 00 00 00       	jmp    f0104d18 <_alltraps>
f0104c95:	90                   	nop

f0104c96 <FPERR_HANDLER>:
	TRAPHANDLER_NOEC(FPERR_HANDLER 	  , T_FPERR  )
f0104c96:	6a 00                	push   $0x0
f0104c98:	6a 10                	push   $0x10
f0104c9a:	eb 7c                	jmp    f0104d18 <_alltraps>

f0104c9c <ALIGN_HANDLER>:
	TRAPHANDLER(	 ALIGN_HANDLER    , T_ALIGN  )
f0104c9c:	6a 11                	push   $0x11
f0104c9e:	eb 78                	jmp    f0104d18 <_alltraps>

f0104ca0 <MCHK_HANDLER>:
	TRAPHANDLER_NOEC(MCHK_HANDLER     , T_MCHK   )
f0104ca0:	6a 00                	push   $0x0
f0104ca2:	6a 12                	push   $0x12
f0104ca4:	eb 72                	jmp    f0104d18 <_alltraps>

f0104ca6 <SIMDERR_HANDLER>:
	TRAPHANDLER_NOEC(SIMDERR_HANDLER  , T_SIMDERR)
f0104ca6:	6a 00                	push   $0x0
f0104ca8:	6a 13                	push   $0x13
f0104caa:	eb 6c                	jmp    f0104d18 <_alltraps>

f0104cac <SYSCALL_HANDLER>:
	TRAPHANDLER_NOEC(SYSCALL_HANDLER  , T_SYSCALL) /* just test*/
f0104cac:	6a 00                	push   $0x0
f0104cae:	6a 30                	push   $0x30
f0104cb0:	eb 66                	jmp    f0104d18 <_alltraps>

f0104cb2 <TIMER_HANDLER>:

	TRAPHANDLER_NOEC(TIMER_HANDLER	  , IRQ_OFFSET + IRQ_TIMER)
f0104cb2:	6a 00                	push   $0x0
f0104cb4:	6a 20                	push   $0x20
f0104cb6:	eb 60                	jmp    f0104d18 <_alltraps>

f0104cb8 <KBD_HANDLER>:
	TRAPHANDLER_NOEC(KBD_HANDLER	  , IRQ_OFFSET + IRQ_KBD)
f0104cb8:	6a 00                	push   $0x0
f0104cba:	6a 21                	push   $0x21
f0104cbc:	eb 5a                	jmp    f0104d18 <_alltraps>

f0104cbe <SECOND_HANDLER>:
	TRAPHANDLER_NOEC(SECOND_HANDLER	  , IRQ_OFFSET + 2)
f0104cbe:	6a 00                	push   $0x0
f0104cc0:	6a 22                	push   $0x22
f0104cc2:	eb 54                	jmp    f0104d18 <_alltraps>

f0104cc4 <THIRD_HANDLER>:
	TRAPHANDLER_NOEC(THIRD_HANDLER	  , IRQ_OFFSET + 3)
f0104cc4:	6a 00                	push   $0x0
f0104cc6:	6a 23                	push   $0x23
f0104cc8:	eb 4e                	jmp    f0104d18 <_alltraps>

f0104cca <SERIAL_HANDLER>:
	TRAPHANDLER_NOEC(SERIAL_HANDLER	  , IRQ_OFFSET + IRQ_SERIAL)
f0104cca:	6a 00                	push   $0x0
f0104ccc:	6a 24                	push   $0x24
f0104cce:	eb 48                	jmp    f0104d18 <_alltraps>

f0104cd0 <FIFTH_HANDLER>:
	TRAPHANDLER_NOEC(FIFTH_HANDLER	  , IRQ_OFFSET + 5)
f0104cd0:	6a 00                	push   $0x0
f0104cd2:	6a 25                	push   $0x25
f0104cd4:	eb 42                	jmp    f0104d18 <_alltraps>

f0104cd6 <SIXTH_HANDLER>:
	TRAPHANDLER_NOEC(SIXTH_HANDLER	  , IRQ_OFFSET + 6)
f0104cd6:	6a 00                	push   $0x0
f0104cd8:	6a 26                	push   $0x26
f0104cda:	eb 3c                	jmp    f0104d18 <_alltraps>

f0104cdc <SPURIOUS_HANDLER>:
	TRAPHANDLER_NOEC(SPURIOUS_HANDLER , IRQ_OFFSET + IRQ_SPURIOUS)
f0104cdc:	6a 00                	push   $0x0
f0104cde:	6a 27                	push   $0x27
f0104ce0:	eb 36                	jmp    f0104d18 <_alltraps>

f0104ce2 <EIGHTH_HANDLER>:
	TRAPHANDLER_NOEC(EIGHTH_HANDLER	  , IRQ_OFFSET + 8)
f0104ce2:	6a 00                	push   $0x0
f0104ce4:	6a 28                	push   $0x28
f0104ce6:	eb 30                	jmp    f0104d18 <_alltraps>

f0104ce8 <NINTH_HANDLER>:
	TRAPHANDLER_NOEC(NINTH_HANDLER	  , IRQ_OFFSET + 9)
f0104ce8:	6a 00                	push   $0x0
f0104cea:	6a 29                	push   $0x29
f0104cec:	eb 2a                	jmp    f0104d18 <_alltraps>

f0104cee <TENTH_HANDLER>:
	TRAPHANDLER_NOEC(TENTH_HANDLER	  , IRQ_OFFSET + 10)
f0104cee:	6a 00                	push   $0x0
f0104cf0:	6a 2a                	push   $0x2a
f0104cf2:	eb 24                	jmp    f0104d18 <_alltraps>

f0104cf4 <ELEVEN_HANDLER>:
	TRAPHANDLER_NOEC(ELEVEN_HANDLER	  , IRQ_OFFSET + 11)
f0104cf4:	6a 00                	push   $0x0
f0104cf6:	6a 2b                	push   $0x2b
f0104cf8:	eb 1e                	jmp    f0104d18 <_alltraps>

f0104cfa <TWELVE_HANDLER>:
	TRAPHANDLER_NOEC(TWELVE_HANDLER	  , IRQ_OFFSET + 12)
f0104cfa:	6a 00                	push   $0x0
f0104cfc:	6a 2c                	push   $0x2c
f0104cfe:	eb 18                	jmp    f0104d18 <_alltraps>

f0104d00 <THIRTEEN_HANDLER>:
	TRAPHANDLER_NOEC(THIRTEEN_HANDLER , IRQ_OFFSET + 13)
f0104d00:	6a 00                	push   $0x0
f0104d02:	6a 2d                	push   $0x2d
f0104d04:	eb 12                	jmp    f0104d18 <_alltraps>

f0104d06 <IDE_HANDLER>:
	TRAPHANDLER_NOEC(IDE_HANDLER	  , IRQ_OFFSET + IRQ_IDE)
f0104d06:	6a 00                	push   $0x0
f0104d08:	6a 2e                	push   $0x2e
f0104d0a:	eb 0c                	jmp    f0104d18 <_alltraps>

f0104d0c <FIFTEEN_HANDLER>:
	TRAPHANDLER_NOEC(FIFTEEN_HANDLER  , IRQ_OFFSET + 15)
f0104d0c:	6a 00                	push   $0x0
f0104d0e:	6a 2f                	push   $0x2f
f0104d10:	eb 06                	jmp    f0104d18 <_alltraps>

f0104d12 <ERROR_HANDLER>:
	TRAPHANDLER_NOEC(ERROR_HANDLER	  , IRQ_OFFSET + IRQ_ERROR)
f0104d12:	6a 00                	push   $0x0
f0104d14:	6a 33                	push   $0x33
f0104d16:	eb 00                	jmp    f0104d18 <_alltraps>

f0104d18 <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */

.globl _alltraps
_alltraps:
	pushw $0
f0104d18:	66 6a 00             	pushw  $0x0
	pushw %ds 
f0104d1b:	66 1e                	pushw  %ds
	pushw $0
f0104d1d:	66 6a 00             	pushw  $0x0
	pushw %es 
f0104d20:	66 06                	pushw  %es
	pushal
f0104d22:	60                   	pusha  

	movl $(GD_KD), %eax 
f0104d23:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds 
f0104d28:	8e d8                	mov    %eax,%ds
	movw %ax, %es 
f0104d2a:	8e c0                	mov    %eax,%es

	pushl %esp 
f0104d2c:	54                   	push   %esp
	call trap
f0104d2d:	e8 9b fb ff ff       	call   f01048cd <trap>

f0104d32 <sysenter_handler>:

; .global sysenter_handler
; sysenter_handler:
; 	pushl %esi 
f0104d32:	56                   	push   %esi
; 	pushl %edi
f0104d33:	57                   	push   %edi
; 	pushl %ebx
f0104d34:	53                   	push   %ebx
; 	pushl %ecx 
f0104d35:	51                   	push   %ecx
; 	pushl %edx
f0104d36:	52                   	push   %edx
; 	pushl %eax
f0104d37:	50                   	push   %eax
; 	call syscall
f0104d38:	e8 95 01 00 00       	call   f0104ed2 <syscall>
; 	movl %esi, %edx
f0104d3d:	89 f2                	mov    %esi,%edx
; 	movl %ebp, %ecx 
f0104d3f:	89 e9                	mov    %ebp,%ecx
f0104d41:	0f 35                	sysexit 

f0104d43 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104d43:	55                   	push   %ebp
f0104d44:	89 e5                	mov    %esp,%ebp
f0104d46:	83 ec 08             	sub    $0x8,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104d49:	8b 0d 44 a2 57 f0    	mov    0xf057a244,%ecx
	for (i = 0; i < NENV; i++) {
f0104d4f:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104d54:	89 c2                	mov    %eax,%edx
f0104d56:	c1 e2 07             	shl    $0x7,%edx
		     envs[i].env_status == ENV_RUNNING ||
f0104d59:	8b 54 11 54          	mov    0x54(%ecx,%edx,1),%edx
f0104d5d:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104d60:	83 fa 02             	cmp    $0x2,%edx
f0104d63:	76 29                	jbe    f0104d8e <sched_halt+0x4b>
	for (i = 0; i < NENV; i++) {
f0104d65:	83 c0 01             	add    $0x1,%eax
f0104d68:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104d6d:	75 e5                	jne    f0104d54 <sched_halt+0x11>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104d6f:	83 ec 0c             	sub    $0xc,%esp
f0104d72:	68 30 92 10 f0       	push   $0xf0109230
f0104d77:	e8 e4 f0 ff ff       	call   f0103e60 <cprintf>
f0104d7c:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104d7f:	83 ec 0c             	sub    $0xc,%esp
f0104d82:	6a 00                	push   $0x0
f0104d84:	e8 c8 be ff ff       	call   f0100c51 <monitor>
f0104d89:	83 c4 10             	add    $0x10,%esp
f0104d8c:	eb f1                	jmp    f0104d7f <sched_halt+0x3c>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104d8e:	e8 1b 1d 00 00       	call   f0106aae <cpunum>
f0104d93:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d96:	c7 80 28 c0 57 f0 00 	movl   $0x0,-0xfa83fd8(%eax)
f0104d9d:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104da0:	a1 ac be 57 f0       	mov    0xf057beac,%eax
	if ((uint32_t)kva < KERNBASE)
f0104da5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104daa:	76 50                	jbe    f0104dfc <sched_halt+0xb9>
	return (physaddr_t)kva - KERNBASE;
f0104dac:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104db1:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104db4:	e8 f5 1c 00 00       	call   f0106aae <cpunum>
f0104db9:	6b d0 74             	imul   $0x74,%eax,%edx
f0104dbc:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104dbf:	b8 02 00 00 00       	mov    $0x2,%eax
f0104dc4:	f0 87 82 20 c0 57 f0 	lock xchg %eax,-0xfa83fe0(%edx)
	spin_unlock(&kernel_lock);
f0104dcb:	83 ec 0c             	sub    $0xc,%esp
f0104dce:	68 c0 73 12 f0       	push   $0xf01273c0
f0104dd3:	e8 e2 1f 00 00       	call   f0106dba <spin_unlock>
	asm volatile("pause");
f0104dd8:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104dda:	e8 cf 1c 00 00       	call   f0106aae <cpunum>
f0104ddf:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104de2:	8b 80 30 c0 57 f0    	mov    -0xfa83fd0(%eax),%eax
f0104de8:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104ded:	89 c4                	mov    %eax,%esp
f0104def:	6a 00                	push   $0x0
f0104df1:	6a 00                	push   $0x0
f0104df3:	fb                   	sti    
f0104df4:	f4                   	hlt    
f0104df5:	eb fd                	jmp    f0104df4 <sched_halt+0xb1>
}
f0104df7:	83 c4 10             	add    $0x10,%esp
f0104dfa:	c9                   	leave  
f0104dfb:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104dfc:	50                   	push   %eax
f0104dfd:	68 f8 76 10 f0       	push   $0xf01076f8
f0104e02:	6a 4c                	push   $0x4c
f0104e04:	68 59 92 10 f0       	push   $0xf0109259
f0104e09:	e8 3b b2 ff ff       	call   f0100049 <_panic>

f0104e0e <sched_yield>:
{
f0104e0e:	55                   	push   %ebp
f0104e0f:	89 e5                	mov    %esp,%ebp
f0104e11:	53                   	push   %ebx
f0104e12:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f0104e15:	e8 94 1c 00 00       	call   f0106aae <cpunum>
f0104e1a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e1d:	83 b8 28 c0 57 f0 00 	cmpl   $0x0,-0xfa83fd8(%eax)
f0104e24:	74 7d                	je     f0104ea3 <sched_yield+0x95>
		envid_t cur_tone = ENVX(curenv->env_id);
f0104e26:	e8 83 1c 00 00       	call   f0106aae <cpunum>
f0104e2b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e2e:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104e34:	8b 48 48             	mov    0x48(%eax),%ecx
f0104e37:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e3d:	8d 41 01             	lea    0x1(%ecx),%eax
f0104e40:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104e45:	8b 1d 44 a2 57 f0    	mov    0xf057a244,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e4b:	39 c8                	cmp    %ecx,%eax
f0104e4d:	74 20                	je     f0104e6f <sched_yield+0x61>
			if(envs[i].env_status == ENV_RUNNABLE){
f0104e4f:	89 c2                	mov    %eax,%edx
f0104e51:	c1 e2 07             	shl    $0x7,%edx
f0104e54:	01 da                	add    %ebx,%edx
f0104e56:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0104e5a:	74 0a                	je     f0104e66 <sched_yield+0x58>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e5c:	83 c0 01             	add    $0x1,%eax
f0104e5f:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104e64:	eb e5                	jmp    f0104e4b <sched_yield+0x3d>
				env_run(&envs[i]);
f0104e66:	83 ec 0c             	sub    $0xc,%esp
f0104e69:	52                   	push   %edx
f0104e6a:	e8 29 ed ff ff       	call   f0103b98 <env_run>
		if(curenv->env_status == ENV_RUNNING)
f0104e6f:	e8 3a 1c 00 00       	call   f0106aae <cpunum>
f0104e74:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e77:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104e7d:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104e81:	74 0a                	je     f0104e8d <sched_yield+0x7f>
	sched_halt();
f0104e83:	e8 bb fe ff ff       	call   f0104d43 <sched_halt>
}
f0104e88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104e8b:	c9                   	leave  
f0104e8c:	c3                   	ret    
			env_run(curenv);
f0104e8d:	e8 1c 1c 00 00       	call   f0106aae <cpunum>
f0104e92:	83 ec 0c             	sub    $0xc,%esp
f0104e95:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e98:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104e9e:	e8 f5 ec ff ff       	call   f0103b98 <env_run>
f0104ea3:	a1 44 a2 57 f0       	mov    0xf057a244,%eax
f0104ea8:	8d 90 00 00 02 00    	lea    0x20000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f0104eae:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104eb2:	74 09                	je     f0104ebd <sched_yield+0xaf>
f0104eb4:	83 e8 80             	sub    $0xffffff80,%eax
		for(i = 0 ; i < NENV; i++)
f0104eb7:	39 d0                	cmp    %edx,%eax
f0104eb9:	75 f3                	jne    f0104eae <sched_yield+0xa0>
f0104ebb:	eb c6                	jmp    f0104e83 <sched_yield+0x75>
		  		env_run(&envs[i]);
f0104ebd:	83 ec 0c             	sub    $0xc,%esp
f0104ec0:	50                   	push   %eax
f0104ec1:	e8 d2 ec ff ff       	call   f0103b98 <env_run>

f0104ec6 <sys_net_send>:
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_tx to send the packet
	// Hint: e1000_tx only accept kernel virtual address
	return -1;
}
f0104ec6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104ecb:	c3                   	ret    

f0104ecc <sys_net_recv>:
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	return -1;
}
f0104ecc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104ed1:	c3                   	ret    

f0104ed2 <syscall>:
	return 0;
}
// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104ed2:	55                   	push   %ebp
f0104ed3:	89 e5                	mov    %esp,%ebp
f0104ed5:	57                   	push   %edi
f0104ed6:	56                   	push   %esi
f0104ed7:	53                   	push   %ebx
f0104ed8:	83 ec 1c             	sub    $0x1c,%esp
f0104edb:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f0104ede:	83 f8 14             	cmp    $0x14,%eax
f0104ee1:	0f 87 53 08 00 00    	ja     f010573a <syscall+0x868>
f0104ee7:	ff 24 85 14 93 10 f0 	jmp    *-0xfef6cec(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f0104eee:	e8 bb 1b 00 00       	call   f0106aae <cpunum>
f0104ef3:	6a 04                	push   $0x4
f0104ef5:	ff 75 10             	pushl  0x10(%ebp)
f0104ef8:	ff 75 0c             	pushl  0xc(%ebp)
f0104efb:	6b c0 74             	imul   $0x74,%eax,%eax
f0104efe:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0104f04:	e8 53 e5 ff ff       	call   f010345c <user_mem_assert>
	cprintf("%.*s", len, s);
f0104f09:	83 c4 0c             	add    $0xc,%esp
f0104f0c:	ff 75 0c             	pushl  0xc(%ebp)
f0104f0f:	ff 75 10             	pushl  0x10(%ebp)
f0104f12:	68 66 92 10 f0       	push   $0xf0109266
f0104f17:	e8 44 ef ff ff       	call   f0103e60 <cprintf>
f0104f1c:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f0104f1f:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f0104f24:	89 d8                	mov    %ebx,%eax
f0104f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104f29:	5b                   	pop    %ebx
f0104f2a:	5e                   	pop    %esi
f0104f2b:	5f                   	pop    %edi
f0104f2c:	5d                   	pop    %ebp
f0104f2d:	c3                   	ret    
	return cons_getc();
f0104f2e:	e8 f7 b6 ff ff       	call   f010062a <cons_getc>
f0104f33:	89 c3                	mov    %eax,%ebx
			break;
f0104f35:	eb ed                	jmp    f0104f24 <syscall+0x52>
	return curenv->env_id;
f0104f37:	e8 72 1b 00 00       	call   f0106aae <cpunum>
f0104f3c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f3f:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104f45:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0104f48:	eb da                	jmp    f0104f24 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104f4a:	83 ec 04             	sub    $0x4,%esp
f0104f4d:	6a 01                	push   $0x1
f0104f4f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104f52:	50                   	push   %eax
f0104f53:	ff 75 0c             	pushl  0xc(%ebp)
f0104f56:	e8 d3 e5 ff ff       	call   f010352e <envid2env>
f0104f5b:	89 c3                	mov    %eax,%ebx
f0104f5d:	83 c4 10             	add    $0x10,%esp
f0104f60:	85 c0                	test   %eax,%eax
f0104f62:	78 c0                	js     f0104f24 <syscall+0x52>
	if (e == curenv)
f0104f64:	e8 45 1b 00 00       	call   f0106aae <cpunum>
f0104f69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104f6c:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f6f:	39 90 28 c0 57 f0    	cmp    %edx,-0xfa83fd8(%eax)
f0104f75:	74 3d                	je     f0104fb4 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0104f77:	8b 5a 48             	mov    0x48(%edx),%ebx
f0104f7a:	e8 2f 1b 00 00       	call   f0106aae <cpunum>
f0104f7f:	83 ec 04             	sub    $0x4,%esp
f0104f82:	53                   	push   %ebx
f0104f83:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f86:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104f8c:	ff 70 48             	pushl  0x48(%eax)
f0104f8f:	68 86 92 10 f0       	push   $0xf0109286
f0104f94:	e8 c7 ee ff ff       	call   f0103e60 <cprintf>
f0104f99:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0104f9c:	83 ec 0c             	sub    $0xc,%esp
f0104f9f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104fa2:	e8 52 eb ff ff       	call   f0103af9 <env_destroy>
f0104fa7:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104faa:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0104faf:	e9 70 ff ff ff       	jmp    f0104f24 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104fb4:	e8 f5 1a 00 00       	call   f0106aae <cpunum>
f0104fb9:	83 ec 08             	sub    $0x8,%esp
f0104fbc:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fbf:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0104fc5:	ff 70 48             	pushl  0x48(%eax)
f0104fc8:	68 6b 92 10 f0       	push   $0xf010926b
f0104fcd:	e8 8e ee ff ff       	call   f0103e60 <cprintf>
f0104fd2:	83 c4 10             	add    $0x10,%esp
f0104fd5:	eb c5                	jmp    f0104f9c <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f0104fd7:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f0104fde:	76 4a                	jbe    f010502a <syscall+0x158>
	return (physaddr_t)kva - KERNBASE;
f0104fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104fe3:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0104fe8:	c1 e8 0c             	shr    $0xc,%eax
f0104feb:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f0104ff1:	73 4e                	jae    f0105041 <syscall+0x16f>
	return &pages[PGNUM(pa)];
f0104ff3:	8b 15 b0 be 57 f0    	mov    0xf057beb0,%edx
f0104ff9:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f0104ffc:	85 db                	test   %ebx,%ebx
f0104ffe:	0f 84 40 07 00 00    	je     f0105744 <syscall+0x872>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f0105004:	e8 a5 1a 00 00       	call   f0106aae <cpunum>
f0105009:	6a 06                	push   $0x6
f010500b:	ff 75 10             	pushl  0x10(%ebp)
f010500e:	53                   	push   %ebx
f010500f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105012:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105018:	ff 70 60             	pushl  0x60(%eax)
f010501b:	e8 e0 c5 ff ff       	call   f0101600 <page_insert>
f0105020:	89 c3                	mov    %eax,%ebx
f0105022:	83 c4 10             	add    $0x10,%esp
f0105025:	e9 fa fe ff ff       	jmp    f0104f24 <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010502a:	ff 75 0c             	pushl  0xc(%ebp)
f010502d:	68 f8 76 10 f0       	push   $0xf01076f8
f0105032:	68 ad 01 00 00       	push   $0x1ad
f0105037:	68 9e 92 10 f0       	push   $0xf010929e
f010503c:	e8 08 b0 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0105041:	83 ec 04             	sub    $0x4,%esp
f0105044:	68 b0 7f 10 f0       	push   $0xf0107fb0
f0105049:	6a 51                	push   $0x51
f010504b:	68 71 88 10 f0       	push   $0xf0108871
f0105050:	e8 f4 af ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105055:	e8 54 1a 00 00       	call   f0106aae <cpunum>
	if(inc < PGSIZE){
f010505a:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f0105061:	77 1b                	ja     f010507e <syscall+0x1ac>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105063:	6b c0 74             	imul   $0x74,%eax,%eax
f0105066:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010506c:	8b 40 7c             	mov    0x7c(%eax),%eax
f010506f:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f0105074:	03 45 0c             	add    0xc(%ebp),%eax
f0105077:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f010507c:	76 7c                	jbe    f01050fa <syscall+0x228>
	int i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f010507e:	e8 2b 1a 00 00       	call   f0106aae <cpunum>
f0105083:	6b c0 74             	imul   $0x74,%eax,%eax
f0105086:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010508c:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010508f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f0105095:	e8 14 1a 00 00       	call   f0106aae <cpunum>
f010509a:	6b c0 74             	imul   $0x74,%eax,%eax
f010509d:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01050a3:	8b 40 7c             	mov    0x7c(%eax),%eax
f01050a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01050a9:	8d b4 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%esi
f01050b0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01050b6:	39 de                	cmp    %ebx,%esi
f01050b8:	0f 8e 94 00 00 00    	jle    f0105152 <syscall+0x280>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01050be:	83 ec 0c             	sub    $0xc,%esp
f01050c1:	6a 01                	push   $0x1
f01050c3:	e8 fc c1 ff ff       	call   f01012c4 <page_alloc>
f01050c8:	89 c7                	mov    %eax,%edi
		if(!page)
f01050ca:	83 c4 10             	add    $0x10,%esp
f01050cd:	85 c0                	test   %eax,%eax
f01050cf:	74 53                	je     f0105124 <syscall+0x252>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f01050d1:	e8 d8 19 00 00       	call   f0106aae <cpunum>
f01050d6:	6a 06                	push   $0x6
f01050d8:	53                   	push   %ebx
f01050d9:	57                   	push   %edi
f01050da:	6b c0 74             	imul   $0x74,%eax,%eax
f01050dd:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01050e3:	ff 70 60             	pushl  0x60(%eax)
f01050e6:	e8 15 c5 ff ff       	call   f0101600 <page_insert>
		if(ret)
f01050eb:	83 c4 10             	add    $0x10,%esp
f01050ee:	85 c0                	test   %eax,%eax
f01050f0:	75 49                	jne    f010513b <syscall+0x269>
	for(; i < end; i+=PGSIZE){
f01050f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01050f8:	eb bc                	jmp    f01050b6 <syscall+0x1e4>
			curenv->env_sbrk+=inc;
f01050fa:	e8 af 19 00 00       	call   f0106aae <cpunum>
f01050ff:	6b c0 74             	imul   $0x74,%eax,%eax
f0105102:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105108:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010510b:	01 48 7c             	add    %ecx,0x7c(%eax)
			return curenv->env_sbrk;
f010510e:	e8 9b 19 00 00       	call   f0106aae <cpunum>
f0105113:	6b c0 74             	imul   $0x74,%eax,%eax
f0105116:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010511c:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010511f:	e9 00 fe ff ff       	jmp    f0104f24 <syscall+0x52>
			panic("there is no page\n");
f0105124:	83 ec 04             	sub    $0x4,%esp
f0105127:	68 d4 8b 10 f0       	push   $0xf0108bd4
f010512c:	68 c2 01 00 00       	push   $0x1c2
f0105131:	68 9e 92 10 f0       	push   $0xf010929e
f0105136:	e8 0e af ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f010513b:	83 ec 04             	sub    $0x4,%esp
f010513e:	68 f1 8b 10 f0       	push   $0xf0108bf1
f0105143:	68 c5 01 00 00       	push   $0x1c5
f0105148:	68 9e 92 10 f0       	push   $0xf010929e
f010514d:	e8 f7 ae ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f0105152:	e8 57 19 00 00       	call   f0106aae <cpunum>
f0105157:	6b c0 74             	imul   $0x74,%eax,%eax
f010515a:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105160:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105163:	01 48 7c             	add    %ecx,0x7c(%eax)
	return curenv->env_sbrk;
f0105166:	e8 43 19 00 00       	call   f0106aae <cpunum>
f010516b:	6b c0 74             	imul   $0x74,%eax,%eax
f010516e:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105174:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0105177:	e9 a8 fd ff ff       	jmp    f0104f24 <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f010517c:	83 ec 04             	sub    $0x4,%esp
f010517f:	68 b0 92 10 f0       	push   $0xf01092b0
f0105184:	68 17 02 00 00       	push   $0x217
f0105189:	68 9e 92 10 f0       	push   $0xf010929e
f010518e:	e8 b6 ae ff ff       	call   f0100049 <_panic>
	sched_yield();
f0105193:	e8 76 fc ff ff       	call   f0104e0e <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105198:	e8 11 19 00 00       	call   f0106aae <cpunum>
f010519d:	83 ec 08             	sub    $0x8,%esp
f01051a0:	6b c0 74             	imul   $0x74,%eax,%eax
f01051a3:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f01051a9:	ff 70 48             	pushl  0x48(%eax)
f01051ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01051af:	50                   	push   %eax
f01051b0:	e8 79 e4 ff ff       	call   f010362e <env_alloc>
f01051b5:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01051b7:	83 c4 10             	add    $0x10,%esp
f01051ba:	85 c0                	test   %eax,%eax
f01051bc:	0f 88 62 fd ff ff    	js     f0104f24 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f01051c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051c5:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f01051cc:	e8 dd 18 00 00       	call   f0106aae <cpunum>
f01051d1:	6b c0 74             	imul   $0x74,%eax,%eax
f01051d4:	8b b0 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%esi
f01051da:	b9 11 00 00 00       	mov    $0x11,%ecx
f01051df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01051e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01051e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051e7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01051ee:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01051f1:	e9 2e fd ff ff       	jmp    f0104f24 <syscall+0x52>
	switch (status)
f01051f6:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01051fa:	74 06                	je     f0105202 <syscall+0x330>
f01051fc:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f0105200:	75 54                	jne    f0105256 <syscall+0x384>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f0105202:	8b 45 10             	mov    0x10(%ebp),%eax
f0105205:	83 e8 02             	sub    $0x2,%eax
f0105208:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f010520d:	75 31                	jne    f0105240 <syscall+0x36e>
	int ret = envid2env(envid, &e, 1);
f010520f:	83 ec 04             	sub    $0x4,%esp
f0105212:	6a 01                	push   $0x1
f0105214:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105217:	50                   	push   %eax
f0105218:	ff 75 0c             	pushl  0xc(%ebp)
f010521b:	e8 0e e3 ff ff       	call   f010352e <envid2env>
f0105220:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105222:	83 c4 10             	add    $0x10,%esp
f0105225:	85 c0                	test   %eax,%eax
f0105227:	0f 88 f7 fc ff ff    	js     f0104f24 <syscall+0x52>
	e->env_status = status;
f010522d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105230:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105233:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0105236:	bb 00 00 00 00       	mov    $0x0,%ebx
f010523b:	e9 e4 fc ff ff       	jmp    f0104f24 <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f0105240:	68 dc 92 10 f0       	push   $0xf01092dc
f0105245:	68 8b 88 10 f0       	push   $0xf010888b
f010524a:	6a 7b                	push   $0x7b
f010524c:	68 9e 92 10 f0       	push   $0xf010929e
f0105251:	e8 f3 ad ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f0105256:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010525b:	e9 c4 fc ff ff       	jmp    f0104f24 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105260:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105267:	0f 87 cd 00 00 00    	ja     f010533a <syscall+0x468>
f010526d:	8b 45 10             	mov    0x10(%ebp),%eax
f0105270:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105275:	8b 55 14             	mov    0x14(%ebp),%edx
f0105278:	83 e2 05             	and    $0x5,%edx
f010527b:	83 fa 05             	cmp    $0x5,%edx
f010527e:	0f 85 c0 00 00 00    	jne    f0105344 <syscall+0x472>
	if(perm & ~PTE_SYSCALL)
f0105284:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105287:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f010528d:	09 c3                	or     %eax,%ebx
f010528f:	0f 85 b9 00 00 00    	jne    f010534e <syscall+0x47c>
	int ret = envid2env(envid, &e, 1);
f0105295:	83 ec 04             	sub    $0x4,%esp
f0105298:	6a 01                	push   $0x1
f010529a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010529d:	50                   	push   %eax
f010529e:	ff 75 0c             	pushl  0xc(%ebp)
f01052a1:	e8 88 e2 ff ff       	call   f010352e <envid2env>
	if(ret < 0)
f01052a6:	83 c4 10             	add    $0x10,%esp
f01052a9:	85 c0                	test   %eax,%eax
f01052ab:	0f 88 a7 00 00 00    	js     f0105358 <syscall+0x486>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f01052b1:	83 ec 0c             	sub    $0xc,%esp
f01052b4:	6a 01                	push   $0x1
f01052b6:	e8 09 c0 ff ff       	call   f01012c4 <page_alloc>
f01052bb:	89 c6                	mov    %eax,%esi
	if(page == NULL)
f01052bd:	83 c4 10             	add    $0x10,%esp
f01052c0:	85 c0                	test   %eax,%eax
f01052c2:	0f 84 97 00 00 00    	je     f010535f <syscall+0x48d>
	return (pp - pages) << PGSHIFT;
f01052c8:	2b 05 b0 be 57 f0    	sub    0xf057beb0,%eax
f01052ce:	c1 f8 03             	sar    $0x3,%eax
f01052d1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01052d4:	89 c2                	mov    %eax,%edx
f01052d6:	c1 ea 0c             	shr    $0xc,%edx
f01052d9:	3b 15 a8 be 57 f0    	cmp    0xf057bea8,%edx
f01052df:	73 47                	jae    f0105328 <syscall+0x456>
	memset(page2kva(page), 0, PGSIZE);
f01052e1:	83 ec 04             	sub    $0x4,%esp
f01052e4:	68 00 10 00 00       	push   $0x1000
f01052e9:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01052eb:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01052f0:	50                   	push   %eax
f01052f1:	e8 af 11 00 00       	call   f01064a5 <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f01052f6:	ff 75 14             	pushl  0x14(%ebp)
f01052f9:	ff 75 10             	pushl  0x10(%ebp)
f01052fc:	56                   	push   %esi
f01052fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105300:	ff 70 60             	pushl  0x60(%eax)
f0105303:	e8 f8 c2 ff ff       	call   f0101600 <page_insert>
f0105308:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f010530a:	83 c4 20             	add    $0x20,%esp
f010530d:	85 c0                	test   %eax,%eax
f010530f:	0f 89 0f fc ff ff    	jns    f0104f24 <syscall+0x52>
		page_free(page);
f0105315:	83 ec 0c             	sub    $0xc,%esp
f0105318:	56                   	push   %esi
f0105319:	e8 18 c0 ff ff       	call   f0101336 <page_free>
f010531e:	83 c4 10             	add    $0x10,%esp
		return ret;
f0105321:	89 fb                	mov    %edi,%ebx
f0105323:	e9 fc fb ff ff       	jmp    f0104f24 <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105328:	50                   	push   %eax
f0105329:	68 d4 76 10 f0       	push   $0xf01076d4
f010532e:	6a 58                	push   $0x58
f0105330:	68 71 88 10 f0       	push   $0xf0108871
f0105335:	e8 0f ad ff ff       	call   f0100049 <_panic>
		return -E_INVAL;
f010533a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010533f:	e9 e0 fb ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f0105344:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105349:	e9 d6 fb ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f010534e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105353:	e9 cc fb ff ff       	jmp    f0104f24 <syscall+0x52>
		return ret;
f0105358:	89 c3                	mov    %eax,%ebx
f010535a:	e9 c5 fb ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_NO_MEM;
f010535f:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105364:	e9 bb fb ff ff       	jmp    f0104f24 <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105369:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010536c:	83 e0 05             	and    $0x5,%eax
f010536f:	83 f8 05             	cmp    $0x5,%eax
f0105372:	0f 85 c0 00 00 00    	jne    f0105438 <syscall+0x566>
	if(perm & ~PTE_SYSCALL)
f0105378:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010537b:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f0105380:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105387:	0f 87 b5 00 00 00    	ja     f0105442 <syscall+0x570>
f010538d:	8b 55 10             	mov    0x10(%ebp),%edx
f0105390:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f0105396:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010539d:	0f 87 a9 00 00 00    	ja     f010544c <syscall+0x57a>
f01053a3:	09 d0                	or     %edx,%eax
f01053a5:	8b 55 18             	mov    0x18(%ebp),%edx
f01053a8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f01053ae:	09 d0                	or     %edx,%eax
f01053b0:	0f 85 a0 00 00 00    	jne    f0105456 <syscall+0x584>
	int ret = envid2env(srcenvid, &src_env, 1);
f01053b6:	83 ec 04             	sub    $0x4,%esp
f01053b9:	6a 01                	push   $0x1
f01053bb:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01053be:	50                   	push   %eax
f01053bf:	ff 75 0c             	pushl  0xc(%ebp)
f01053c2:	e8 67 e1 ff ff       	call   f010352e <envid2env>
f01053c7:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01053c9:	83 c4 10             	add    $0x10,%esp
f01053cc:	85 c0                	test   %eax,%eax
f01053ce:	0f 88 50 fb ff ff    	js     f0104f24 <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f01053d4:	83 ec 04             	sub    $0x4,%esp
f01053d7:	6a 01                	push   $0x1
f01053d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01053dc:	50                   	push   %eax
f01053dd:	ff 75 14             	pushl  0x14(%ebp)
f01053e0:	e8 49 e1 ff ff       	call   f010352e <envid2env>
f01053e5:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01053e7:	83 c4 10             	add    $0x10,%esp
f01053ea:	85 c0                	test   %eax,%eax
f01053ec:	0f 88 32 fb ff ff    	js     f0104f24 <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f01053f2:	83 ec 04             	sub    $0x4,%esp
f01053f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01053f8:	50                   	push   %eax
f01053f9:	ff 75 10             	pushl  0x10(%ebp)
f01053fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01053ff:	ff 70 60             	pushl  0x60(%eax)
f0105402:	e8 19 c1 ff ff       	call   f0101520 <page_lookup>
	if(src_page == NULL)
f0105407:	83 c4 10             	add    $0x10,%esp
f010540a:	85 c0                	test   %eax,%eax
f010540c:	74 52                	je     f0105460 <syscall+0x58e>
	if(perm & PTE_W){
f010540e:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0105412:	74 08                	je     f010541c <syscall+0x54a>
		if((*pte_store & PTE_W) == 0)
f0105414:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105417:	f6 02 02             	testb  $0x2,(%edx)
f010541a:	74 4e                	je     f010546a <syscall+0x598>
	return page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f010541c:	ff 75 1c             	pushl  0x1c(%ebp)
f010541f:	ff 75 18             	pushl  0x18(%ebp)
f0105422:	50                   	push   %eax
f0105423:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105426:	ff 70 60             	pushl  0x60(%eax)
f0105429:	e8 d2 c1 ff ff       	call   f0101600 <page_insert>
f010542e:	89 c3                	mov    %eax,%ebx
f0105430:	83 c4 10             	add    $0x10,%esp
f0105433:	e9 ec fa ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f0105438:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010543d:	e9 e2 fa ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f0105442:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105447:	e9 d8 fa ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f010544c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105451:	e9 ce fa ff ff       	jmp    f0104f24 <syscall+0x52>
f0105456:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010545b:	e9 c4 fa ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f0105460:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105465:	e9 ba fa ff ff       	jmp    f0104f24 <syscall+0x52>
			return -E_INVAL;
f010546a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010546f:	e9 b0 fa ff ff       	jmp    f0104f24 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105474:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010547b:	77 45                	ja     f01054c2 <syscall+0x5f0>
f010547d:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105484:	75 46                	jne    f01054cc <syscall+0x5fa>
	int ret = envid2env(envid, &env, 1);
f0105486:	83 ec 04             	sub    $0x4,%esp
f0105489:	6a 01                	push   $0x1
f010548b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010548e:	50                   	push   %eax
f010548f:	ff 75 0c             	pushl  0xc(%ebp)
f0105492:	e8 97 e0 ff ff       	call   f010352e <envid2env>
f0105497:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105499:	83 c4 10             	add    $0x10,%esp
f010549c:	85 c0                	test   %eax,%eax
f010549e:	0f 88 80 fa ff ff    	js     f0104f24 <syscall+0x52>
	page_remove(env->env_pgdir, va);
f01054a4:	83 ec 08             	sub    $0x8,%esp
f01054a7:	ff 75 10             	pushl  0x10(%ebp)
f01054aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01054ad:	ff 70 60             	pushl  0x60(%eax)
f01054b0:	e8 05 c1 ff ff       	call   f01015ba <page_remove>
f01054b5:	83 c4 10             	add    $0x10,%esp
	return 0;
f01054b8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01054bd:	e9 62 fa ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f01054c2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01054c7:	e9 58 fa ff ff       	jmp    f0104f24 <syscall+0x52>
f01054cc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01054d1:	e9 4e fa ff ff       	jmp    f0104f24 <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f01054d6:	83 ec 04             	sub    $0x4,%esp
f01054d9:	6a 00                	push   $0x0
f01054db:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01054de:	50                   	push   %eax
f01054df:	ff 75 0c             	pushl  0xc(%ebp)
f01054e2:	e8 47 e0 ff ff       	call   f010352e <envid2env>
f01054e7:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01054e9:	83 c4 10             	add    $0x10,%esp
f01054ec:	85 c0                	test   %eax,%eax
f01054ee:	0f 88 30 fa ff ff    	js     f0104f24 <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f01054f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01054f7:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01054fb:	0f 84 f8 00 00 00    	je     f01055f9 <syscall+0x727>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f0105501:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0105508:	77 78                	ja     f0105582 <syscall+0x6b0>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f010550a:	8b 45 18             	mov    0x18(%ebp),%eax
f010550d:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f0105510:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105515:	83 f8 05             	cmp    $0x5,%eax
f0105518:	0f 85 06 fa ff ff    	jne    f0104f24 <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f010551e:	8b 55 14             	mov    0x14(%ebp),%edx
f0105521:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f0105527:	8b 45 18             	mov    0x18(%ebp),%eax
f010552a:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f010552f:	09 c2                	or     %eax,%edx
f0105531:	0f 85 ed f9 ff ff    	jne    f0104f24 <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105537:	e8 72 15 00 00       	call   f0106aae <cpunum>
f010553c:	83 ec 04             	sub    $0x4,%esp
f010553f:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105542:	52                   	push   %edx
f0105543:	ff 75 14             	pushl  0x14(%ebp)
f0105546:	6b c0 74             	imul   $0x74,%eax,%eax
f0105549:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010554f:	ff 70 60             	pushl  0x60(%eax)
f0105552:	e8 c9 bf ff ff       	call   f0101520 <page_lookup>
		if(!page)
f0105557:	83 c4 10             	add    $0x10,%esp
f010555a:	85 c0                	test   %eax,%eax
f010555c:	0f 84 8d 00 00 00    	je     f01055ef <syscall+0x71d>
		if((perm & PTE_W) && !(*pte & PTE_W))
f0105562:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105566:	74 0c                	je     f0105574 <syscall+0x6a2>
f0105568:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010556b:	f6 02 02             	testb  $0x2,(%edx)
f010556e:	0f 84 b0 f9 ff ff    	je     f0104f24 <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105574:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105577:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f010557a:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0105580:	76 52                	jbe    f01055d4 <syscall+0x702>
	dst_env->env_ipc_recving = 0;
f0105582:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105585:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105589:	e8 20 15 00 00       	call   f0106aae <cpunum>
f010558e:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105591:	6b c0 74             	imul   $0x74,%eax,%eax
f0105594:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010559a:	8b 40 48             	mov    0x48(%eax),%eax
f010559d:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_value = value;
f01055a0:	8b 45 10             	mov    0x10(%ebp),%eax
f01055a3:	89 42 70             	mov    %eax,0x70(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f01055a6:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f01055ad:	b8 00 00 00 00       	mov    $0x0,%eax
f01055b2:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f01055b6:	89 45 18             	mov    %eax,0x18(%ebp)
f01055b9:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f01055bc:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f01055c3:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f01055ca:	bb 00 00 00 00       	mov    $0x0,%ebx
f01055cf:	e9 50 f9 ff ff       	jmp    f0104f24 <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f01055d4:	ff 75 18             	pushl  0x18(%ebp)
f01055d7:	51                   	push   %ecx
f01055d8:	50                   	push   %eax
f01055d9:	ff 72 60             	pushl  0x60(%edx)
f01055dc:	e8 1f c0 ff ff       	call   f0101600 <page_insert>
f01055e1:	89 c3                	mov    %eax,%ebx
			if(ret < 0)
f01055e3:	83 c4 10             	add    $0x10,%esp
f01055e6:	85 c0                	test   %eax,%eax
f01055e8:	79 98                	jns    f0105582 <syscall+0x6b0>
f01055ea:	e9 35 f9 ff ff       	jmp    f0104f24 <syscall+0x52>
			return -E_INVAL;		
f01055ef:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01055f4:	e9 2b f9 ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_IPC_NOT_RECV;
f01055f9:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f01055fe:	e9 21 f9 ff ff       	jmp    f0104f24 <syscall+0x52>
	if(dstva < (void *)UTOP){
f0105603:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f010560a:	77 13                	ja     f010561f <syscall+0x74d>
		if((uint32_t)dstva % PGSIZE != 0)
f010560c:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0105613:	74 0a                	je     f010561f <syscall+0x74d>
			ret = sys_ipc_recv((void *)a1);
f0105615:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f010561a:	e9 05 f9 ff ff       	jmp    f0104f24 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f010561f:	e8 8a 14 00 00       	call   f0106aae <cpunum>
f0105624:	6b c0 74             	imul   $0x74,%eax,%eax
f0105627:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010562d:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0105631:	e8 78 14 00 00       	call   f0106aae <cpunum>
f0105636:	6b c0 74             	imul   $0x74,%eax,%eax
f0105639:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f010563f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105642:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105645:	e8 64 14 00 00       	call   f0106aae <cpunum>
f010564a:	6b c0 74             	imul   $0x74,%eax,%eax
f010564d:	8b 80 28 c0 57 f0    	mov    -0xfa83fd8(%eax),%eax
f0105653:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f010565a:	e8 af f7 ff ff       	call   f0104e0e <sched_yield>
	int ret = envid2env(envid, &e, 1);
f010565f:	83 ec 04             	sub    $0x4,%esp
f0105662:	6a 01                	push   $0x1
f0105664:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105667:	50                   	push   %eax
f0105668:	ff 75 0c             	pushl  0xc(%ebp)
f010566b:	e8 be de ff ff       	call   f010352e <envid2env>
f0105670:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105672:	83 c4 10             	add    $0x10,%esp
f0105675:	85 c0                	test   %eax,%eax
f0105677:	0f 88 a7 f8 ff ff    	js     f0104f24 <syscall+0x52>
	e->env_pgfault_upcall = func;
f010567d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105680:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105683:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0105686:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f010568b:	e9 94 f8 ff ff       	jmp    f0104f24 <syscall+0x52>
	r = envid2env(envid, &e, 0);
f0105690:	83 ec 04             	sub    $0x4,%esp
f0105693:	6a 00                	push   $0x0
f0105695:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105698:	50                   	push   %eax
f0105699:	ff 75 0c             	pushl  0xc(%ebp)
f010569c:	e8 8d de ff ff       	call   f010352e <envid2env>
f01056a1:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f01056a3:	83 c4 10             	add    $0x10,%esp
f01056a6:	85 c0                	test   %eax,%eax
f01056a8:	0f 88 76 f8 ff ff    	js     f0104f24 <syscall+0x52>
	e->env_tf = *tf;
f01056ae:	b9 11 00 00 00       	mov    $0x11,%ecx
f01056b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01056b6:	8b 75 10             	mov    0x10(%ebp),%esi
f01056b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f01056bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01056be:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f01056c3:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f01056ca:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01056cf:	e9 50 f8 ff ff       	jmp    f0104f24 <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f01056d4:	83 ec 04             	sub    $0x4,%esp
f01056d7:	6a 00                	push   $0x0
f01056d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01056dc:	50                   	push   %eax
f01056dd:	ff 75 0c             	pushl  0xc(%ebp)
f01056e0:	e8 49 de ff ff       	call   f010352e <envid2env>
f01056e5:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01056e7:	83 c4 10             	add    $0x10,%esp
f01056ea:	85 c0                	test   %eax,%eax
f01056ec:	0f 88 32 f8 ff ff    	js     f0104f24 <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f01056f2:	83 ec 04             	sub    $0x4,%esp
f01056f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01056f8:	50                   	push   %eax
f01056f9:	ff 75 10             	pushl  0x10(%ebp)
f01056fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01056ff:	ff 70 60             	pushl  0x60(%eax)
f0105702:	e8 19 be ff ff       	call   f0101520 <page_lookup>
	if(page == NULL)
f0105707:	83 c4 10             	add    $0x10,%esp
f010570a:	85 c0                	test   %eax,%eax
f010570c:	74 16                	je     f0105724 <syscall+0x852>
	*pte_store |= PTE_A;
f010570e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105711:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f0105714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105717:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f010571a:	bb 00 00 00 00       	mov    $0x0,%ebx
f010571f:	e9 00 f8 ff ff       	jmp    f0104f24 <syscall+0x52>
		return -E_INVAL;
f0105724:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105729:	e9 f6 f7 ff ff       	jmp    f0104f24 <syscall+0x52>
	return time_msec();
f010572e:	e8 f1 1c 00 00       	call   f0107424 <time_msec>
f0105733:	89 c3                	mov    %eax,%ebx
			break;
f0105735:	e9 ea f7 ff ff       	jmp    f0104f24 <syscall+0x52>
			ret = -E_INVAL;
f010573a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010573f:	e9 e0 f7 ff ff       	jmp    f0104f24 <syscall+0x52>
        return E_INVAL;
f0105744:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105749:	e9 d6 f7 ff ff       	jmp    f0104f24 <syscall+0x52>

f010574e <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010574e:	55                   	push   %ebp
f010574f:	89 e5                	mov    %esp,%ebp
f0105751:	57                   	push   %edi
f0105752:	56                   	push   %esi
f0105753:	53                   	push   %ebx
f0105754:	83 ec 14             	sub    $0x14,%esp
f0105757:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010575a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010575d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105760:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105763:	8b 1a                	mov    (%edx),%ebx
f0105765:	8b 01                	mov    (%ecx),%eax
f0105767:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010576a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105771:	eb 23                	jmp    f0105796 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105773:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105776:	eb 1e                	jmp    f0105796 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105778:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010577b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010577e:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105782:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105785:	73 41                	jae    f01057c8 <stab_binsearch+0x7a>
			*region_left = m;
f0105787:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010578a:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f010578c:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f010578f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0105796:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0105799:	7f 5a                	jg     f01057f5 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f010579b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010579e:	01 d8                	add    %ebx,%eax
f01057a0:	89 c7                	mov    %eax,%edi
f01057a2:	c1 ef 1f             	shr    $0x1f,%edi
f01057a5:	01 c7                	add    %eax,%edi
f01057a7:	d1 ff                	sar    %edi
f01057a9:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f01057ac:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01057af:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01057b3:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f01057b5:	39 c3                	cmp    %eax,%ebx
f01057b7:	7f ba                	jg     f0105773 <stab_binsearch+0x25>
f01057b9:	0f b6 0a             	movzbl (%edx),%ecx
f01057bc:	83 ea 0c             	sub    $0xc,%edx
f01057bf:	39 f1                	cmp    %esi,%ecx
f01057c1:	74 b5                	je     f0105778 <stab_binsearch+0x2a>
			m--;
f01057c3:	83 e8 01             	sub    $0x1,%eax
f01057c6:	eb ed                	jmp    f01057b5 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f01057c8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01057cb:	76 14                	jbe    f01057e1 <stab_binsearch+0x93>
			*region_right = m - 1;
f01057cd:	83 e8 01             	sub    $0x1,%eax
f01057d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01057d3:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01057d6:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f01057d8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01057df:	eb b5                	jmp    f0105796 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01057e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01057e4:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f01057e6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01057ea:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f01057ec:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01057f3:	eb a1                	jmp    f0105796 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f01057f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01057f9:	75 15                	jne    f0105810 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f01057fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01057fe:	8b 00                	mov    (%eax),%eax
f0105800:	83 e8 01             	sub    $0x1,%eax
f0105803:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105806:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105808:	83 c4 14             	add    $0x14,%esp
f010580b:	5b                   	pop    %ebx
f010580c:	5e                   	pop    %esi
f010580d:	5f                   	pop    %edi
f010580e:	5d                   	pop    %ebp
f010580f:	c3                   	ret    
		for (l = *region_right;
f0105810:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105813:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105815:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105818:	8b 0f                	mov    (%edi),%ecx
f010581a:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010581d:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0105820:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105824:	eb 03                	jmp    f0105829 <stab_binsearch+0xdb>
		     l--)
f0105826:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105829:	39 c1                	cmp    %eax,%ecx
f010582b:	7d 0a                	jge    f0105837 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f010582d:	0f b6 1a             	movzbl (%edx),%ebx
f0105830:	83 ea 0c             	sub    $0xc,%edx
f0105833:	39 f3                	cmp    %esi,%ebx
f0105835:	75 ef                	jne    f0105826 <stab_binsearch+0xd8>
		*region_left = l;
f0105837:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010583a:	89 06                	mov    %eax,(%esi)
}
f010583c:	eb ca                	jmp    f0105808 <stab_binsearch+0xba>

f010583e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010583e:	55                   	push   %ebp
f010583f:	89 e5                	mov    %esp,%ebp
f0105841:	57                   	push   %edi
f0105842:	56                   	push   %esi
f0105843:	53                   	push   %ebx
f0105844:	83 ec 4c             	sub    $0x4c,%esp
f0105847:	8b 7d 08             	mov    0x8(%ebp),%edi
f010584a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f010584d:	c7 03 68 93 10 f0    	movl   $0xf0109368,(%ebx)
	info->eip_line = 0;
f0105853:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f010585a:	c7 43 08 68 93 10 f0 	movl   $0xf0109368,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105861:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105868:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f010586b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105872:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0105878:	0f 86 23 01 00 00    	jbe    f01059a1 <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f010587e:	c7 45 b8 6c d5 11 f0 	movl   $0xf011d56c,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0105885:	c7 45 b4 dd 8c 11 f0 	movl   $0xf0118cdd,-0x4c(%ebp)
		stab_end = __STAB_END__;
f010588c:	be dc 8c 11 f0       	mov    $0xf0118cdc,%esi
		stabs = __STAB_BEGIN__;
f0105891:	c7 45 bc ec 9b 10 f0 	movl   $0xf0109bec,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105898:	8b 45 b8             	mov    -0x48(%ebp),%eax
f010589b:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f010589e:	0f 83 59 02 00 00    	jae    f0105afd <debuginfo_eip+0x2bf>
f01058a4:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01058a8:	0f 85 56 02 00 00    	jne    f0105b04 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01058ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01058b5:	2b 75 bc             	sub    -0x44(%ebp),%esi
f01058b8:	c1 fe 02             	sar    $0x2,%esi
f01058bb:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f01058c1:	83 e8 01             	sub    $0x1,%eax
f01058c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01058c7:	83 ec 08             	sub    $0x8,%esp
f01058ca:	57                   	push   %edi
f01058cb:	6a 64                	push   $0x64
f01058cd:	8d 55 e0             	lea    -0x20(%ebp),%edx
f01058d0:	89 d1                	mov    %edx,%ecx
f01058d2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01058d5:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01058d8:	89 f0                	mov    %esi,%eax
f01058da:	e8 6f fe ff ff       	call   f010574e <stab_binsearch>
	if (lfile == 0)
f01058df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058e2:	83 c4 10             	add    $0x10,%esp
f01058e5:	85 c0                	test   %eax,%eax
f01058e7:	0f 84 1e 02 00 00    	je     f0105b0b <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01058ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f01058f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f01058f6:	83 ec 08             	sub    $0x8,%esp
f01058f9:	57                   	push   %edi
f01058fa:	6a 24                	push   $0x24
f01058fc:	8d 55 d8             	lea    -0x28(%ebp),%edx
f01058ff:	89 d1                	mov    %edx,%ecx
f0105901:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105904:	89 f0                	mov    %esi,%eax
f0105906:	e8 43 fe ff ff       	call   f010574e <stab_binsearch>

	if (lfun <= rfun) {
f010590b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010590e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105911:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105914:	83 c4 10             	add    $0x10,%esp
f0105917:	39 c8                	cmp    %ecx,%eax
f0105919:	0f 8f 26 01 00 00    	jg     f0105a45 <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f010591f:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105922:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f0105925:	8b 11                	mov    (%ecx),%edx
f0105927:	8b 75 b8             	mov    -0x48(%ebp),%esi
f010592a:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f010592d:	39 f2                	cmp    %esi,%edx
f010592f:	73 06                	jae    f0105937 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105931:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105934:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105937:	8b 51 08             	mov    0x8(%ecx),%edx
f010593a:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f010593d:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f010593f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105942:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105945:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105948:	83 ec 08             	sub    $0x8,%esp
f010594b:	6a 3a                	push   $0x3a
f010594d:	ff 73 08             	pushl  0x8(%ebx)
f0105950:	e8 34 0b 00 00       	call   f0106489 <strfind>
f0105955:	2b 43 08             	sub    0x8(%ebx),%eax
f0105958:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f010595b:	83 c4 08             	add    $0x8,%esp
f010595e:	57                   	push   %edi
f010595f:	6a 44                	push   $0x44
f0105961:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105964:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105967:	8b 75 bc             	mov    -0x44(%ebp),%esi
f010596a:	89 f0                	mov    %esi,%eax
f010596c:	e8 dd fd ff ff       	call   f010574e <stab_binsearch>
	if(lline <= rline){
f0105971:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105974:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105977:	83 c4 10             	add    $0x10,%esp
f010597a:	39 c2                	cmp    %eax,%edx
f010597c:	0f 8f 90 01 00 00    	jg     f0105b12 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f0105982:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105985:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105989:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010598c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010598f:	89 d0                	mov    %edx,%eax
f0105991:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105994:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105998:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f010599c:	e9 c2 00 00 00       	jmp    f0105a63 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f01059a1:	e8 08 11 00 00       	call   f0106aae <cpunum>
f01059a6:	6a 06                	push   $0x6
f01059a8:	6a 10                	push   $0x10
f01059aa:	68 00 00 20 00       	push   $0x200000
f01059af:	6b c0 74             	imul   $0x74,%eax,%eax
f01059b2:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f01059b8:	e8 f7 d9 ff ff       	call   f01033b4 <user_mem_check>
f01059bd:	83 c4 10             	add    $0x10,%esp
f01059c0:	85 c0                	test   %eax,%eax
f01059c2:	0f 88 27 01 00 00    	js     f0105aef <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f01059c8:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f01059ce:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f01059d1:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f01059d7:	a1 08 00 20 00       	mov    0x200008,%eax
f01059dc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f01059df:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f01059e5:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f01059e8:	e8 c1 10 00 00       	call   f0106aae <cpunum>
f01059ed:	6a 06                	push   $0x6
f01059ef:	89 f2                	mov    %esi,%edx
f01059f1:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f01059f4:	29 ca                	sub    %ecx,%edx
f01059f6:	52                   	push   %edx
f01059f7:	51                   	push   %ecx
f01059f8:	6b c0 74             	imul   $0x74,%eax,%eax
f01059fb:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0105a01:	e8 ae d9 ff ff       	call   f01033b4 <user_mem_check>
f0105a06:	83 c4 10             	add    $0x10,%esp
f0105a09:	85 c0                	test   %eax,%eax
f0105a0b:	0f 88 e5 00 00 00    	js     f0105af6 <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105a11:	e8 98 10 00 00       	call   f0106aae <cpunum>
f0105a16:	6a 06                	push   $0x6
f0105a18:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105a1b:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105a1e:	29 ca                	sub    %ecx,%edx
f0105a20:	52                   	push   %edx
f0105a21:	51                   	push   %ecx
f0105a22:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a25:	ff b0 28 c0 57 f0    	pushl  -0xfa83fd8(%eax)
f0105a2b:	e8 84 d9 ff ff       	call   f01033b4 <user_mem_check>
f0105a30:	83 c4 10             	add    $0x10,%esp
f0105a33:	85 c0                	test   %eax,%eax
f0105a35:	0f 89 5d fe ff ff    	jns    f0105898 <debuginfo_eip+0x5a>
			return -1;
f0105a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105a40:	e9 d9 00 00 00       	jmp    f0105b1e <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105a45:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a4b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a51:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105a54:	e9 ef fe ff ff       	jmp    f0105948 <debuginfo_eip+0x10a>
f0105a59:	83 e8 01             	sub    $0x1,%eax
f0105a5c:	83 ea 0c             	sub    $0xc,%edx
f0105a5f:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105a63:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105a66:	39 c7                	cmp    %eax,%edi
f0105a68:	7f 45                	jg     f0105aaf <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f0105a6a:	0f b6 0a             	movzbl (%edx),%ecx
f0105a6d:	80 f9 84             	cmp    $0x84,%cl
f0105a70:	74 19                	je     f0105a8b <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105a72:	80 f9 64             	cmp    $0x64,%cl
f0105a75:	75 e2                	jne    f0105a59 <debuginfo_eip+0x21b>
f0105a77:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105a7b:	74 dc                	je     f0105a59 <debuginfo_eip+0x21b>
f0105a7d:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105a81:	74 11                	je     f0105a94 <debuginfo_eip+0x256>
f0105a83:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105a86:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105a89:	eb 09                	jmp    f0105a94 <debuginfo_eip+0x256>
f0105a8b:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105a8f:	74 03                	je     f0105a94 <debuginfo_eip+0x256>
f0105a91:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105a94:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105a97:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105a9a:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105a9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105aa0:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105aa3:	29 f8                	sub    %edi,%eax
f0105aa5:	39 c2                	cmp    %eax,%edx
f0105aa7:	73 06                	jae    f0105aaf <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105aa9:	89 f8                	mov    %edi,%eax
f0105aab:	01 d0                	add    %edx,%eax
f0105aad:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105aaf:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105ab2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f0105ab5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105aba:	39 f2                	cmp    %esi,%edx
f0105abc:	7d 60                	jge    f0105b1e <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0105abe:	83 c2 01             	add    $0x1,%edx
f0105ac1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105ac4:	89 d0                	mov    %edx,%eax
f0105ac6:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105ac9:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105acc:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105ad0:	eb 04                	jmp    f0105ad6 <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f0105ad2:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105ad6:	39 c6                	cmp    %eax,%esi
f0105ad8:	7e 3f                	jle    f0105b19 <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105ada:	0f b6 0a             	movzbl (%edx),%ecx
f0105add:	83 c0 01             	add    $0x1,%eax
f0105ae0:	83 c2 0c             	add    $0xc,%edx
f0105ae3:	80 f9 a0             	cmp    $0xa0,%cl
f0105ae6:	74 ea                	je     f0105ad2 <debuginfo_eip+0x294>
	return 0;
f0105ae8:	b8 00 00 00 00       	mov    $0x0,%eax
f0105aed:	eb 2f                	jmp    f0105b1e <debuginfo_eip+0x2e0>
			return -1;
f0105aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105af4:	eb 28                	jmp    f0105b1e <debuginfo_eip+0x2e0>
			return -1;
f0105af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105afb:	eb 21                	jmp    f0105b1e <debuginfo_eip+0x2e0>
		return -1;
f0105afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b02:	eb 1a                	jmp    f0105b1e <debuginfo_eip+0x2e0>
f0105b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b09:	eb 13                	jmp    f0105b1e <debuginfo_eip+0x2e0>
		return -1;
f0105b0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b10:	eb 0c                	jmp    f0105b1e <debuginfo_eip+0x2e0>
		return -1;
f0105b12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b17:	eb 05                	jmp    f0105b1e <debuginfo_eip+0x2e0>
	return 0;
f0105b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105b1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b21:	5b                   	pop    %ebx
f0105b22:	5e                   	pop    %esi
f0105b23:	5f                   	pop    %edi
f0105b24:	5d                   	pop    %ebp
f0105b25:	c3                   	ret    

f0105b26 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105b26:	55                   	push   %ebp
f0105b27:	89 e5                	mov    %esp,%ebp
f0105b29:	57                   	push   %edi
f0105b2a:	56                   	push   %esi
f0105b2b:	53                   	push   %ebx
f0105b2c:	83 ec 1c             	sub    $0x1c,%esp
f0105b2f:	89 c6                	mov    %eax,%esi
f0105b31:	89 d7                	mov    %edx,%edi
f0105b33:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b36:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105b39:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105b3c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105b3f:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b42:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105b45:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105b49:	74 2c                	je     f0105b77 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f0105b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105b4e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105b55:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105b58:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105b5b:	39 c2                	cmp    %eax,%edx
f0105b5d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105b60:	73 43                	jae    f0105ba5 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105b62:	83 eb 01             	sub    $0x1,%ebx
f0105b65:	85 db                	test   %ebx,%ebx
f0105b67:	7e 6c                	jle    f0105bd5 <printnum+0xaf>
				putch(padc, putdat);
f0105b69:	83 ec 08             	sub    $0x8,%esp
f0105b6c:	57                   	push   %edi
f0105b6d:	ff 75 18             	pushl  0x18(%ebp)
f0105b70:	ff d6                	call   *%esi
f0105b72:	83 c4 10             	add    $0x10,%esp
f0105b75:	eb eb                	jmp    f0105b62 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105b77:	83 ec 0c             	sub    $0xc,%esp
f0105b7a:	6a 20                	push   $0x20
f0105b7c:	6a 00                	push   $0x0
f0105b7e:	50                   	push   %eax
f0105b7f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105b82:	ff 75 e0             	pushl  -0x20(%ebp)
f0105b85:	89 fa                	mov    %edi,%edx
f0105b87:	89 f0                	mov    %esi,%eax
f0105b89:	e8 98 ff ff ff       	call   f0105b26 <printnum>
		while (--width > 0)
f0105b8e:	83 c4 20             	add    $0x20,%esp
f0105b91:	83 eb 01             	sub    $0x1,%ebx
f0105b94:	85 db                	test   %ebx,%ebx
f0105b96:	7e 65                	jle    f0105bfd <printnum+0xd7>
			putch(padc, putdat);
f0105b98:	83 ec 08             	sub    $0x8,%esp
f0105b9b:	57                   	push   %edi
f0105b9c:	6a 20                	push   $0x20
f0105b9e:	ff d6                	call   *%esi
f0105ba0:	83 c4 10             	add    $0x10,%esp
f0105ba3:	eb ec                	jmp    f0105b91 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f0105ba5:	83 ec 0c             	sub    $0xc,%esp
f0105ba8:	ff 75 18             	pushl  0x18(%ebp)
f0105bab:	83 eb 01             	sub    $0x1,%ebx
f0105bae:	53                   	push   %ebx
f0105baf:	50                   	push   %eax
f0105bb0:	83 ec 08             	sub    $0x8,%esp
f0105bb3:	ff 75 dc             	pushl  -0x24(%ebp)
f0105bb6:	ff 75 d8             	pushl  -0x28(%ebp)
f0105bb9:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105bbc:	ff 75 e0             	pushl  -0x20(%ebp)
f0105bbf:	e8 6c 18 00 00       	call   f0107430 <__udivdi3>
f0105bc4:	83 c4 18             	add    $0x18,%esp
f0105bc7:	52                   	push   %edx
f0105bc8:	50                   	push   %eax
f0105bc9:	89 fa                	mov    %edi,%edx
f0105bcb:	89 f0                	mov    %esi,%eax
f0105bcd:	e8 54 ff ff ff       	call   f0105b26 <printnum>
f0105bd2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f0105bd5:	83 ec 08             	sub    $0x8,%esp
f0105bd8:	57                   	push   %edi
f0105bd9:	83 ec 04             	sub    $0x4,%esp
f0105bdc:	ff 75 dc             	pushl  -0x24(%ebp)
f0105bdf:	ff 75 d8             	pushl  -0x28(%ebp)
f0105be2:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105be5:	ff 75 e0             	pushl  -0x20(%ebp)
f0105be8:	e8 53 19 00 00       	call   f0107540 <__umoddi3>
f0105bed:	83 c4 14             	add    $0x14,%esp
f0105bf0:	0f be 80 72 93 10 f0 	movsbl -0xfef6c8e(%eax),%eax
f0105bf7:	50                   	push   %eax
f0105bf8:	ff d6                	call   *%esi
f0105bfa:	83 c4 10             	add    $0x10,%esp
	}
}
f0105bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105c00:	5b                   	pop    %ebx
f0105c01:	5e                   	pop    %esi
f0105c02:	5f                   	pop    %edi
f0105c03:	5d                   	pop    %ebp
f0105c04:	c3                   	ret    

f0105c05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105c05:	55                   	push   %ebp
f0105c06:	89 e5                	mov    %esp,%ebp
f0105c08:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105c0b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105c0f:	8b 10                	mov    (%eax),%edx
f0105c11:	3b 50 04             	cmp    0x4(%eax),%edx
f0105c14:	73 0a                	jae    f0105c20 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105c16:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105c19:	89 08                	mov    %ecx,(%eax)
f0105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c1e:	88 02                	mov    %al,(%edx)
}
f0105c20:	5d                   	pop    %ebp
f0105c21:	c3                   	ret    

f0105c22 <printfmt>:
{
f0105c22:	55                   	push   %ebp
f0105c23:	89 e5                	mov    %esp,%ebp
f0105c25:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105c28:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105c2b:	50                   	push   %eax
f0105c2c:	ff 75 10             	pushl  0x10(%ebp)
f0105c2f:	ff 75 0c             	pushl  0xc(%ebp)
f0105c32:	ff 75 08             	pushl  0x8(%ebp)
f0105c35:	e8 05 00 00 00       	call   f0105c3f <vprintfmt>
}
f0105c3a:	83 c4 10             	add    $0x10,%esp
f0105c3d:	c9                   	leave  
f0105c3e:	c3                   	ret    

f0105c3f <vprintfmt>:
{
f0105c3f:	55                   	push   %ebp
f0105c40:	89 e5                	mov    %esp,%ebp
f0105c42:	57                   	push   %edi
f0105c43:	56                   	push   %esi
f0105c44:	53                   	push   %ebx
f0105c45:	83 ec 3c             	sub    $0x3c,%esp
f0105c48:	8b 75 08             	mov    0x8(%ebp),%esi
f0105c4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105c4e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105c51:	e9 32 04 00 00       	jmp    f0106088 <vprintfmt+0x449>
		padc = ' ';
f0105c56:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f0105c5a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f0105c61:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0105c68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105c6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105c76:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0105c7d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105c82:	8d 47 01             	lea    0x1(%edi),%eax
f0105c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105c88:	0f b6 17             	movzbl (%edi),%edx
f0105c8b:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105c8e:	3c 55                	cmp    $0x55,%al
f0105c90:	0f 87 12 05 00 00    	ja     f01061a8 <vprintfmt+0x569>
f0105c96:	0f b6 c0             	movzbl %al,%eax
f0105c99:	ff 24 85 60 95 10 f0 	jmp    *-0xfef6aa0(,%eax,4)
f0105ca0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105ca3:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0105ca7:	eb d9                	jmp    f0105c82 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105ca9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105cac:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0105cb0:	eb d0                	jmp    f0105c82 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105cb2:	0f b6 d2             	movzbl %dl,%edx
f0105cb5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105cb8:	b8 00 00 00 00       	mov    $0x0,%eax
f0105cbd:	89 75 08             	mov    %esi,0x8(%ebp)
f0105cc0:	eb 03                	jmp    f0105cc5 <vprintfmt+0x86>
f0105cc2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105cc5:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105cc8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0105ccc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105ccf:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105cd2:	83 fe 09             	cmp    $0x9,%esi
f0105cd5:	76 eb                	jbe    f0105cc2 <vprintfmt+0x83>
f0105cd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105cda:	8b 75 08             	mov    0x8(%ebp),%esi
f0105cdd:	eb 14                	jmp    f0105cf3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0105cdf:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ce2:	8b 00                	mov    (%eax),%eax
f0105ce4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105ce7:	8b 45 14             	mov    0x14(%ebp),%eax
f0105cea:	8d 40 04             	lea    0x4(%eax),%eax
f0105ced:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105cf0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105cf3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105cf7:	79 89                	jns    f0105c82 <vprintfmt+0x43>
				width = precision, precision = -1;
f0105cf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105cfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105cff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105d06:	e9 77 ff ff ff       	jmp    f0105c82 <vprintfmt+0x43>
f0105d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d0e:	85 c0                	test   %eax,%eax
f0105d10:	0f 48 c1             	cmovs  %ecx,%eax
f0105d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105d16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105d19:	e9 64 ff ff ff       	jmp    f0105c82 <vprintfmt+0x43>
f0105d1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105d21:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0105d28:	e9 55 ff ff ff       	jmp    f0105c82 <vprintfmt+0x43>
			lflag++;
f0105d2d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105d31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105d34:	e9 49 ff ff ff       	jmp    f0105c82 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0105d39:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d3c:	8d 78 04             	lea    0x4(%eax),%edi
f0105d3f:	83 ec 08             	sub    $0x8,%esp
f0105d42:	53                   	push   %ebx
f0105d43:	ff 30                	pushl  (%eax)
f0105d45:	ff d6                	call   *%esi
			break;
f0105d47:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105d4a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105d4d:	e9 33 03 00 00       	jmp    f0106085 <vprintfmt+0x446>
			err = va_arg(ap, int);
f0105d52:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d55:	8d 78 04             	lea    0x4(%eax),%edi
f0105d58:	8b 00                	mov    (%eax),%eax
f0105d5a:	99                   	cltd   
f0105d5b:	31 d0                	xor    %edx,%eax
f0105d5d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105d5f:	83 f8 10             	cmp    $0x10,%eax
f0105d62:	7f 23                	jg     f0105d87 <vprintfmt+0x148>
f0105d64:	8b 14 85 c0 96 10 f0 	mov    -0xfef6940(,%eax,4),%edx
f0105d6b:	85 d2                	test   %edx,%edx
f0105d6d:	74 18                	je     f0105d87 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f0105d6f:	52                   	push   %edx
f0105d70:	68 9d 88 10 f0       	push   $0xf010889d
f0105d75:	53                   	push   %ebx
f0105d76:	56                   	push   %esi
f0105d77:	e8 a6 fe ff ff       	call   f0105c22 <printfmt>
f0105d7c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105d7f:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105d82:	e9 fe 02 00 00       	jmp    f0106085 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f0105d87:	50                   	push   %eax
f0105d88:	68 8a 93 10 f0       	push   $0xf010938a
f0105d8d:	53                   	push   %ebx
f0105d8e:	56                   	push   %esi
f0105d8f:	e8 8e fe ff ff       	call   f0105c22 <printfmt>
f0105d94:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105d97:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105d9a:	e9 e6 02 00 00       	jmp    f0106085 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f0105d9f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105da2:	83 c0 04             	add    $0x4,%eax
f0105da5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105da8:	8b 45 14             	mov    0x14(%ebp),%eax
f0105dab:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f0105dad:	85 c9                	test   %ecx,%ecx
f0105daf:	b8 83 93 10 f0       	mov    $0xf0109383,%eax
f0105db4:	0f 45 c1             	cmovne %ecx,%eax
f0105db7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0105dba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105dbe:	7e 06                	jle    f0105dc6 <vprintfmt+0x187>
f0105dc0:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0105dc4:	75 0d                	jne    f0105dd3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105dc6:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105dc9:	89 c7                	mov    %eax,%edi
f0105dcb:	03 45 e0             	add    -0x20(%ebp),%eax
f0105dce:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105dd1:	eb 53                	jmp    f0105e26 <vprintfmt+0x1e7>
f0105dd3:	83 ec 08             	sub    $0x8,%esp
f0105dd6:	ff 75 d8             	pushl  -0x28(%ebp)
f0105dd9:	50                   	push   %eax
f0105dda:	e8 5f 05 00 00       	call   f010633e <strnlen>
f0105ddf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105de2:	29 c1                	sub    %eax,%ecx
f0105de4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0105de7:	83 c4 10             	add    $0x10,%esp
f0105dea:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0105dec:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0105df0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105df3:	eb 0f                	jmp    f0105e04 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0105df5:	83 ec 08             	sub    $0x8,%esp
f0105df8:	53                   	push   %ebx
f0105df9:	ff 75 e0             	pushl  -0x20(%ebp)
f0105dfc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105dfe:	83 ef 01             	sub    $0x1,%edi
f0105e01:	83 c4 10             	add    $0x10,%esp
f0105e04:	85 ff                	test   %edi,%edi
f0105e06:	7f ed                	jg     f0105df5 <vprintfmt+0x1b6>
f0105e08:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105e0b:	85 c9                	test   %ecx,%ecx
f0105e0d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e12:	0f 49 c1             	cmovns %ecx,%eax
f0105e15:	29 c1                	sub    %eax,%ecx
f0105e17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105e1a:	eb aa                	jmp    f0105dc6 <vprintfmt+0x187>
					putch(ch, putdat);
f0105e1c:	83 ec 08             	sub    $0x8,%esp
f0105e1f:	53                   	push   %ebx
f0105e20:	52                   	push   %edx
f0105e21:	ff d6                	call   *%esi
f0105e23:	83 c4 10             	add    $0x10,%esp
f0105e26:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105e29:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105e2b:	83 c7 01             	add    $0x1,%edi
f0105e2e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105e32:	0f be d0             	movsbl %al,%edx
f0105e35:	85 d2                	test   %edx,%edx
f0105e37:	74 4b                	je     f0105e84 <vprintfmt+0x245>
f0105e39:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105e3d:	78 06                	js     f0105e45 <vprintfmt+0x206>
f0105e3f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105e43:	78 1e                	js     f0105e63 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f0105e45:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0105e49:	74 d1                	je     f0105e1c <vprintfmt+0x1dd>
f0105e4b:	0f be c0             	movsbl %al,%eax
f0105e4e:	83 e8 20             	sub    $0x20,%eax
f0105e51:	83 f8 5e             	cmp    $0x5e,%eax
f0105e54:	76 c6                	jbe    f0105e1c <vprintfmt+0x1dd>
					putch('?', putdat);
f0105e56:	83 ec 08             	sub    $0x8,%esp
f0105e59:	53                   	push   %ebx
f0105e5a:	6a 3f                	push   $0x3f
f0105e5c:	ff d6                	call   *%esi
f0105e5e:	83 c4 10             	add    $0x10,%esp
f0105e61:	eb c3                	jmp    f0105e26 <vprintfmt+0x1e7>
f0105e63:	89 cf                	mov    %ecx,%edi
f0105e65:	eb 0e                	jmp    f0105e75 <vprintfmt+0x236>
				putch(' ', putdat);
f0105e67:	83 ec 08             	sub    $0x8,%esp
f0105e6a:	53                   	push   %ebx
f0105e6b:	6a 20                	push   $0x20
f0105e6d:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105e6f:	83 ef 01             	sub    $0x1,%edi
f0105e72:	83 c4 10             	add    $0x10,%esp
f0105e75:	85 ff                	test   %edi,%edi
f0105e77:	7f ee                	jg     f0105e67 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f0105e79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105e7c:	89 45 14             	mov    %eax,0x14(%ebp)
f0105e7f:	e9 01 02 00 00       	jmp    f0106085 <vprintfmt+0x446>
f0105e84:	89 cf                	mov    %ecx,%edi
f0105e86:	eb ed                	jmp    f0105e75 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f0105e88:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f0105e8b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f0105e92:	e9 eb fd ff ff       	jmp    f0105c82 <vprintfmt+0x43>
	if (lflag >= 2)
f0105e97:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105e9b:	7f 21                	jg     f0105ebe <vprintfmt+0x27f>
	else if (lflag)
f0105e9d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105ea1:	74 68                	je     f0105f0b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f0105ea3:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ea6:	8b 00                	mov    (%eax),%eax
f0105ea8:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105eab:	89 c1                	mov    %eax,%ecx
f0105ead:	c1 f9 1f             	sar    $0x1f,%ecx
f0105eb0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105eb3:	8b 45 14             	mov    0x14(%ebp),%eax
f0105eb6:	8d 40 04             	lea    0x4(%eax),%eax
f0105eb9:	89 45 14             	mov    %eax,0x14(%ebp)
f0105ebc:	eb 17                	jmp    f0105ed5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
f0105ebe:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ec1:	8b 50 04             	mov    0x4(%eax),%edx
f0105ec4:	8b 00                	mov    (%eax),%eax
f0105ec6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105ec9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105ecc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ecf:	8d 40 08             	lea    0x8(%eax),%eax
f0105ed2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0105ed5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105ed8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105edb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105ede:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f0105ee1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105ee5:	78 3f                	js     f0105f26 <vprintfmt+0x2e7>
			base = 10;
f0105ee7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f0105eec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f0105ef0:	0f 84 71 01 00 00    	je     f0106067 <vprintfmt+0x428>
				putch('+', putdat);
f0105ef6:	83 ec 08             	sub    $0x8,%esp
f0105ef9:	53                   	push   %ebx
f0105efa:	6a 2b                	push   $0x2b
f0105efc:	ff d6                	call   *%esi
f0105efe:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105f01:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f06:	e9 5c 01 00 00       	jmp    f0106067 <vprintfmt+0x428>
		return va_arg(*ap, int);
f0105f0b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f0e:	8b 00                	mov    (%eax),%eax
f0105f10:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105f13:	89 c1                	mov    %eax,%ecx
f0105f15:	c1 f9 1f             	sar    $0x1f,%ecx
f0105f18:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105f1b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f1e:	8d 40 04             	lea    0x4(%eax),%eax
f0105f21:	89 45 14             	mov    %eax,0x14(%ebp)
f0105f24:	eb af                	jmp    f0105ed5 <vprintfmt+0x296>
				putch('-', putdat);
f0105f26:	83 ec 08             	sub    $0x8,%esp
f0105f29:	53                   	push   %ebx
f0105f2a:	6a 2d                	push   $0x2d
f0105f2c:	ff d6                	call   *%esi
				num = -(long long) num;
f0105f2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105f31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105f34:	f7 d8                	neg    %eax
f0105f36:	83 d2 00             	adc    $0x0,%edx
f0105f39:	f7 da                	neg    %edx
f0105f3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f3e:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f41:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105f44:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f49:	e9 19 01 00 00       	jmp    f0106067 <vprintfmt+0x428>
	if (lflag >= 2)
f0105f4e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105f52:	7f 29                	jg     f0105f7d <vprintfmt+0x33e>
	else if (lflag)
f0105f54:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105f58:	74 44                	je     f0105f9e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f0105f5a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f5d:	8b 00                	mov    (%eax),%eax
f0105f5f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f64:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f67:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f6a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f6d:	8d 40 04             	lea    0x4(%eax),%eax
f0105f70:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105f73:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f78:	e9 ea 00 00 00       	jmp    f0106067 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0105f7d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f80:	8b 50 04             	mov    0x4(%eax),%edx
f0105f83:	8b 00                	mov    (%eax),%eax
f0105f85:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f88:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f8b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f8e:	8d 40 08             	lea    0x8(%eax),%eax
f0105f91:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105f94:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f99:	e9 c9 00 00 00       	jmp    f0106067 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0105f9e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fa1:	8b 00                	mov    (%eax),%eax
f0105fa3:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fa8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105fab:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105fae:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fb1:	8d 40 04             	lea    0x4(%eax),%eax
f0105fb4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105fb7:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105fbc:	e9 a6 00 00 00       	jmp    f0106067 <vprintfmt+0x428>
			putch('0', putdat);
f0105fc1:	83 ec 08             	sub    $0x8,%esp
f0105fc4:	53                   	push   %ebx
f0105fc5:	6a 30                	push   $0x30
f0105fc7:	ff d6                	call   *%esi
	if (lflag >= 2)
f0105fc9:	83 c4 10             	add    $0x10,%esp
f0105fcc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105fd0:	7f 26                	jg     f0105ff8 <vprintfmt+0x3b9>
	else if (lflag)
f0105fd2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105fd6:	74 3e                	je     f0106016 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f0105fd8:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fdb:	8b 00                	mov    (%eax),%eax
f0105fdd:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fe2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105fe5:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105fe8:	8b 45 14             	mov    0x14(%ebp),%eax
f0105feb:	8d 40 04             	lea    0x4(%eax),%eax
f0105fee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105ff1:	b8 08 00 00 00       	mov    $0x8,%eax
f0105ff6:	eb 6f                	jmp    f0106067 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0105ff8:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ffb:	8b 50 04             	mov    0x4(%eax),%edx
f0105ffe:	8b 00                	mov    (%eax),%eax
f0106000:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106003:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106006:	8b 45 14             	mov    0x14(%ebp),%eax
f0106009:	8d 40 08             	lea    0x8(%eax),%eax
f010600c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010600f:	b8 08 00 00 00       	mov    $0x8,%eax
f0106014:	eb 51                	jmp    f0106067 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106016:	8b 45 14             	mov    0x14(%ebp),%eax
f0106019:	8b 00                	mov    (%eax),%eax
f010601b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106020:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106023:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106026:	8b 45 14             	mov    0x14(%ebp),%eax
f0106029:	8d 40 04             	lea    0x4(%eax),%eax
f010602c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010602f:	b8 08 00 00 00       	mov    $0x8,%eax
f0106034:	eb 31                	jmp    f0106067 <vprintfmt+0x428>
			putch('0', putdat);
f0106036:	83 ec 08             	sub    $0x8,%esp
f0106039:	53                   	push   %ebx
f010603a:	6a 30                	push   $0x30
f010603c:	ff d6                	call   *%esi
			putch('x', putdat);
f010603e:	83 c4 08             	add    $0x8,%esp
f0106041:	53                   	push   %ebx
f0106042:	6a 78                	push   $0x78
f0106044:	ff d6                	call   *%esi
			num = (unsigned long long)
f0106046:	8b 45 14             	mov    0x14(%ebp),%eax
f0106049:	8b 00                	mov    (%eax),%eax
f010604b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106050:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106053:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f0106056:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0106059:	8b 45 14             	mov    0x14(%ebp),%eax
f010605c:	8d 40 04             	lea    0x4(%eax),%eax
f010605f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106062:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0106067:	83 ec 0c             	sub    $0xc,%esp
f010606a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f010606e:	52                   	push   %edx
f010606f:	ff 75 e0             	pushl  -0x20(%ebp)
f0106072:	50                   	push   %eax
f0106073:	ff 75 dc             	pushl  -0x24(%ebp)
f0106076:	ff 75 d8             	pushl  -0x28(%ebp)
f0106079:	89 da                	mov    %ebx,%edx
f010607b:	89 f0                	mov    %esi,%eax
f010607d:	e8 a4 fa ff ff       	call   f0105b26 <printnum>
			break;
f0106082:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f0106085:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106088:	83 c7 01             	add    $0x1,%edi
f010608b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010608f:	83 f8 25             	cmp    $0x25,%eax
f0106092:	0f 84 be fb ff ff    	je     f0105c56 <vprintfmt+0x17>
			if (ch == '\0')
f0106098:	85 c0                	test   %eax,%eax
f010609a:	0f 84 28 01 00 00    	je     f01061c8 <vprintfmt+0x589>
			putch(ch, putdat);
f01060a0:	83 ec 08             	sub    $0x8,%esp
f01060a3:	53                   	push   %ebx
f01060a4:	50                   	push   %eax
f01060a5:	ff d6                	call   *%esi
f01060a7:	83 c4 10             	add    $0x10,%esp
f01060aa:	eb dc                	jmp    f0106088 <vprintfmt+0x449>
	if (lflag >= 2)
f01060ac:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01060b0:	7f 26                	jg     f01060d8 <vprintfmt+0x499>
	else if (lflag)
f01060b2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01060b6:	74 41                	je     f01060f9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f01060b8:	8b 45 14             	mov    0x14(%ebp),%eax
f01060bb:	8b 00                	mov    (%eax),%eax
f01060bd:	ba 00 00 00 00       	mov    $0x0,%edx
f01060c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060c8:	8b 45 14             	mov    0x14(%ebp),%eax
f01060cb:	8d 40 04             	lea    0x4(%eax),%eax
f01060ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01060d1:	b8 10 00 00 00       	mov    $0x10,%eax
f01060d6:	eb 8f                	jmp    f0106067 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01060d8:	8b 45 14             	mov    0x14(%ebp),%eax
f01060db:	8b 50 04             	mov    0x4(%eax),%edx
f01060de:	8b 00                	mov    (%eax),%eax
f01060e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01060e9:	8d 40 08             	lea    0x8(%eax),%eax
f01060ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01060ef:	b8 10 00 00 00       	mov    $0x10,%eax
f01060f4:	e9 6e ff ff ff       	jmp    f0106067 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f01060f9:	8b 45 14             	mov    0x14(%ebp),%eax
f01060fc:	8b 00                	mov    (%eax),%eax
f01060fe:	ba 00 00 00 00       	mov    $0x0,%edx
f0106103:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106106:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106109:	8b 45 14             	mov    0x14(%ebp),%eax
f010610c:	8d 40 04             	lea    0x4(%eax),%eax
f010610f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106112:	b8 10 00 00 00       	mov    $0x10,%eax
f0106117:	e9 4b ff ff ff       	jmp    f0106067 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f010611c:	8b 45 14             	mov    0x14(%ebp),%eax
f010611f:	83 c0 04             	add    $0x4,%eax
f0106122:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106125:	8b 45 14             	mov    0x14(%ebp),%eax
f0106128:	8b 00                	mov    (%eax),%eax
f010612a:	85 c0                	test   %eax,%eax
f010612c:	74 14                	je     f0106142 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f010612e:	8b 13                	mov    (%ebx),%edx
f0106130:	83 fa 7f             	cmp    $0x7f,%edx
f0106133:	7f 37                	jg     f010616c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f0106135:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f0106137:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010613a:	89 45 14             	mov    %eax,0x14(%ebp)
f010613d:	e9 43 ff ff ff       	jmp    f0106085 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f0106142:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106147:	bf a9 94 10 f0       	mov    $0xf01094a9,%edi
							putch(ch, putdat);
f010614c:	83 ec 08             	sub    $0x8,%esp
f010614f:	53                   	push   %ebx
f0106150:	50                   	push   %eax
f0106151:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0106153:	83 c7 01             	add    $0x1,%edi
f0106156:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f010615a:	83 c4 10             	add    $0x10,%esp
f010615d:	85 c0                	test   %eax,%eax
f010615f:	75 eb                	jne    f010614c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f0106161:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106164:	89 45 14             	mov    %eax,0x14(%ebp)
f0106167:	e9 19 ff ff ff       	jmp    f0106085 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f010616c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f010616e:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106173:	bf e1 94 10 f0       	mov    $0xf01094e1,%edi
							putch(ch, putdat);
f0106178:	83 ec 08             	sub    $0x8,%esp
f010617b:	53                   	push   %ebx
f010617c:	50                   	push   %eax
f010617d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f010617f:	83 c7 01             	add    $0x1,%edi
f0106182:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f0106186:	83 c4 10             	add    $0x10,%esp
f0106189:	85 c0                	test   %eax,%eax
f010618b:	75 eb                	jne    f0106178 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f010618d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106190:	89 45 14             	mov    %eax,0x14(%ebp)
f0106193:	e9 ed fe ff ff       	jmp    f0106085 <vprintfmt+0x446>
			putch(ch, putdat);
f0106198:	83 ec 08             	sub    $0x8,%esp
f010619b:	53                   	push   %ebx
f010619c:	6a 25                	push   $0x25
f010619e:	ff d6                	call   *%esi
			break;
f01061a0:	83 c4 10             	add    $0x10,%esp
f01061a3:	e9 dd fe ff ff       	jmp    f0106085 <vprintfmt+0x446>
			putch('%', putdat);
f01061a8:	83 ec 08             	sub    $0x8,%esp
f01061ab:	53                   	push   %ebx
f01061ac:	6a 25                	push   $0x25
f01061ae:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01061b0:	83 c4 10             	add    $0x10,%esp
f01061b3:	89 f8                	mov    %edi,%eax
f01061b5:	eb 03                	jmp    f01061ba <vprintfmt+0x57b>
f01061b7:	83 e8 01             	sub    $0x1,%eax
f01061ba:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01061be:	75 f7                	jne    f01061b7 <vprintfmt+0x578>
f01061c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01061c3:	e9 bd fe ff ff       	jmp    f0106085 <vprintfmt+0x446>
}
f01061c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01061cb:	5b                   	pop    %ebx
f01061cc:	5e                   	pop    %esi
f01061cd:	5f                   	pop    %edi
f01061ce:	5d                   	pop    %ebp
f01061cf:	c3                   	ret    

f01061d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01061d0:	55                   	push   %ebp
f01061d1:	89 e5                	mov    %esp,%ebp
f01061d3:	83 ec 18             	sub    $0x18,%esp
f01061d6:	8b 45 08             	mov    0x8(%ebp),%eax
f01061d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01061dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01061df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01061e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01061e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01061ed:	85 c0                	test   %eax,%eax
f01061ef:	74 26                	je     f0106217 <vsnprintf+0x47>
f01061f1:	85 d2                	test   %edx,%edx
f01061f3:	7e 22                	jle    f0106217 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01061f5:	ff 75 14             	pushl  0x14(%ebp)
f01061f8:	ff 75 10             	pushl  0x10(%ebp)
f01061fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01061fe:	50                   	push   %eax
f01061ff:	68 05 5c 10 f0       	push   $0xf0105c05
f0106204:	e8 36 fa ff ff       	call   f0105c3f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106209:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010620c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010620f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106212:	83 c4 10             	add    $0x10,%esp
}
f0106215:	c9                   	leave  
f0106216:	c3                   	ret    
		return -E_INVAL;
f0106217:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010621c:	eb f7                	jmp    f0106215 <vsnprintf+0x45>

f010621e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010621e:	55                   	push   %ebp
f010621f:	89 e5                	mov    %esp,%ebp
f0106221:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106224:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106227:	50                   	push   %eax
f0106228:	ff 75 10             	pushl  0x10(%ebp)
f010622b:	ff 75 0c             	pushl  0xc(%ebp)
f010622e:	ff 75 08             	pushl  0x8(%ebp)
f0106231:	e8 9a ff ff ff       	call   f01061d0 <vsnprintf>
	va_end(ap);

	return rc;
}
f0106236:	c9                   	leave  
f0106237:	c3                   	ret    

f0106238 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106238:	55                   	push   %ebp
f0106239:	89 e5                	mov    %esp,%ebp
f010623b:	57                   	push   %edi
f010623c:	56                   	push   %esi
f010623d:	53                   	push   %ebx
f010623e:	83 ec 0c             	sub    $0xc,%esp
f0106241:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106244:	85 c0                	test   %eax,%eax
f0106246:	74 11                	je     f0106259 <readline+0x21>
		cprintf("%s", prompt);
f0106248:	83 ec 08             	sub    $0x8,%esp
f010624b:	50                   	push   %eax
f010624c:	68 9d 88 10 f0       	push   $0xf010889d
f0106251:	e8 0a dc ff ff       	call   f0103e60 <cprintf>
f0106256:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106259:	83 ec 0c             	sub    $0xc,%esp
f010625c:	6a 00                	push   $0x0
f010625e:	e8 77 a5 ff ff       	call   f01007da <iscons>
f0106263:	89 c7                	mov    %eax,%edi
f0106265:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0106268:	be 00 00 00 00       	mov    $0x0,%esi
f010626d:	eb 57                	jmp    f01062c6 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f010626f:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106274:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106277:	75 08                	jne    f0106281 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0106279:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010627c:	5b                   	pop    %ebx
f010627d:	5e                   	pop    %esi
f010627e:	5f                   	pop    %edi
f010627f:	5d                   	pop    %ebp
f0106280:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0106281:	83 ec 08             	sub    $0x8,%esp
f0106284:	53                   	push   %ebx
f0106285:	68 04 97 10 f0       	push   $0xf0109704
f010628a:	e8 d1 db ff ff       	call   f0103e60 <cprintf>
f010628f:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0106292:	b8 00 00 00 00       	mov    $0x0,%eax
f0106297:	eb e0                	jmp    f0106279 <readline+0x41>
			if (echoing)
f0106299:	85 ff                	test   %edi,%edi
f010629b:	75 05                	jne    f01062a2 <readline+0x6a>
			i--;
f010629d:	83 ee 01             	sub    $0x1,%esi
f01062a0:	eb 24                	jmp    f01062c6 <readline+0x8e>
				cputchar('\b');
f01062a2:	83 ec 0c             	sub    $0xc,%esp
f01062a5:	6a 08                	push   $0x8
f01062a7:	e8 0d a5 ff ff       	call   f01007b9 <cputchar>
f01062ac:	83 c4 10             	add    $0x10,%esp
f01062af:	eb ec                	jmp    f010629d <readline+0x65>
				cputchar(c);
f01062b1:	83 ec 0c             	sub    $0xc,%esp
f01062b4:	53                   	push   %ebx
f01062b5:	e8 ff a4 ff ff       	call   f01007b9 <cputchar>
f01062ba:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01062bd:	88 9e 80 aa 57 f0    	mov    %bl,-0xfa85580(%esi)
f01062c3:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01062c6:	e8 fe a4 ff ff       	call   f01007c9 <getchar>
f01062cb:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01062cd:	85 c0                	test   %eax,%eax
f01062cf:	78 9e                	js     f010626f <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01062d1:	83 f8 08             	cmp    $0x8,%eax
f01062d4:	0f 94 c2             	sete   %dl
f01062d7:	83 f8 7f             	cmp    $0x7f,%eax
f01062da:	0f 94 c0             	sete   %al
f01062dd:	08 c2                	or     %al,%dl
f01062df:	74 04                	je     f01062e5 <readline+0xad>
f01062e1:	85 f6                	test   %esi,%esi
f01062e3:	7f b4                	jg     f0106299 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01062e5:	83 fb 1f             	cmp    $0x1f,%ebx
f01062e8:	7e 0e                	jle    f01062f8 <readline+0xc0>
f01062ea:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01062f0:	7f 06                	jg     f01062f8 <readline+0xc0>
			if (echoing)
f01062f2:	85 ff                	test   %edi,%edi
f01062f4:	74 c7                	je     f01062bd <readline+0x85>
f01062f6:	eb b9                	jmp    f01062b1 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f01062f8:	83 fb 0a             	cmp    $0xa,%ebx
f01062fb:	74 05                	je     f0106302 <readline+0xca>
f01062fd:	83 fb 0d             	cmp    $0xd,%ebx
f0106300:	75 c4                	jne    f01062c6 <readline+0x8e>
			if (echoing)
f0106302:	85 ff                	test   %edi,%edi
f0106304:	75 11                	jne    f0106317 <readline+0xdf>
			buf[i] = 0;
f0106306:	c6 86 80 aa 57 f0 00 	movb   $0x0,-0xfa85580(%esi)
			return buf;
f010630d:	b8 80 aa 57 f0       	mov    $0xf057aa80,%eax
f0106312:	e9 62 ff ff ff       	jmp    f0106279 <readline+0x41>
				cputchar('\n');
f0106317:	83 ec 0c             	sub    $0xc,%esp
f010631a:	6a 0a                	push   $0xa
f010631c:	e8 98 a4 ff ff       	call   f01007b9 <cputchar>
f0106321:	83 c4 10             	add    $0x10,%esp
f0106324:	eb e0                	jmp    f0106306 <readline+0xce>

f0106326 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106326:	55                   	push   %ebp
f0106327:	89 e5                	mov    %esp,%ebp
f0106329:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010632c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106331:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106335:	74 05                	je     f010633c <strlen+0x16>
		n++;
f0106337:	83 c0 01             	add    $0x1,%eax
f010633a:	eb f5                	jmp    f0106331 <strlen+0xb>
	return n;
}
f010633c:	5d                   	pop    %ebp
f010633d:	c3                   	ret    

f010633e <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010633e:	55                   	push   %ebp
f010633f:	89 e5                	mov    %esp,%ebp
f0106341:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106344:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106347:	ba 00 00 00 00       	mov    $0x0,%edx
f010634c:	39 c2                	cmp    %eax,%edx
f010634e:	74 0d                	je     f010635d <strnlen+0x1f>
f0106350:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106354:	74 05                	je     f010635b <strnlen+0x1d>
		n++;
f0106356:	83 c2 01             	add    $0x1,%edx
f0106359:	eb f1                	jmp    f010634c <strnlen+0xe>
f010635b:	89 d0                	mov    %edx,%eax
	return n;
}
f010635d:	5d                   	pop    %ebp
f010635e:	c3                   	ret    

f010635f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010635f:	55                   	push   %ebp
f0106360:	89 e5                	mov    %esp,%ebp
f0106362:	53                   	push   %ebx
f0106363:	8b 45 08             	mov    0x8(%ebp),%eax
f0106366:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106369:	ba 00 00 00 00       	mov    $0x0,%edx
f010636e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106372:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0106375:	83 c2 01             	add    $0x1,%edx
f0106378:	84 c9                	test   %cl,%cl
f010637a:	75 f2                	jne    f010636e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f010637c:	5b                   	pop    %ebx
f010637d:	5d                   	pop    %ebp
f010637e:	c3                   	ret    

f010637f <strcat>:

char *
strcat(char *dst, const char *src)
{
f010637f:	55                   	push   %ebp
f0106380:	89 e5                	mov    %esp,%ebp
f0106382:	53                   	push   %ebx
f0106383:	83 ec 10             	sub    $0x10,%esp
f0106386:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106389:	53                   	push   %ebx
f010638a:	e8 97 ff ff ff       	call   f0106326 <strlen>
f010638f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0106392:	ff 75 0c             	pushl  0xc(%ebp)
f0106395:	01 d8                	add    %ebx,%eax
f0106397:	50                   	push   %eax
f0106398:	e8 c2 ff ff ff       	call   f010635f <strcpy>
	return dst;
}
f010639d:	89 d8                	mov    %ebx,%eax
f010639f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01063a2:	c9                   	leave  
f01063a3:	c3                   	ret    

f01063a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01063a4:	55                   	push   %ebp
f01063a5:	89 e5                	mov    %esp,%ebp
f01063a7:	56                   	push   %esi
f01063a8:	53                   	push   %ebx
f01063a9:	8b 45 08             	mov    0x8(%ebp),%eax
f01063ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01063af:	89 c6                	mov    %eax,%esi
f01063b1:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01063b4:	89 c2                	mov    %eax,%edx
f01063b6:	39 f2                	cmp    %esi,%edx
f01063b8:	74 11                	je     f01063cb <strncpy+0x27>
		*dst++ = *src;
f01063ba:	83 c2 01             	add    $0x1,%edx
f01063bd:	0f b6 19             	movzbl (%ecx),%ebx
f01063c0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01063c3:	80 fb 01             	cmp    $0x1,%bl
f01063c6:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01063c9:	eb eb                	jmp    f01063b6 <strncpy+0x12>
	}
	return ret;
}
f01063cb:	5b                   	pop    %ebx
f01063cc:	5e                   	pop    %esi
f01063cd:	5d                   	pop    %ebp
f01063ce:	c3                   	ret    

f01063cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01063cf:	55                   	push   %ebp
f01063d0:	89 e5                	mov    %esp,%ebp
f01063d2:	56                   	push   %esi
f01063d3:	53                   	push   %ebx
f01063d4:	8b 75 08             	mov    0x8(%ebp),%esi
f01063d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01063da:	8b 55 10             	mov    0x10(%ebp),%edx
f01063dd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01063df:	85 d2                	test   %edx,%edx
f01063e1:	74 21                	je     f0106404 <strlcpy+0x35>
f01063e3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01063e7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01063e9:	39 c2                	cmp    %eax,%edx
f01063eb:	74 14                	je     f0106401 <strlcpy+0x32>
f01063ed:	0f b6 19             	movzbl (%ecx),%ebx
f01063f0:	84 db                	test   %bl,%bl
f01063f2:	74 0b                	je     f01063ff <strlcpy+0x30>
			*dst++ = *src++;
f01063f4:	83 c1 01             	add    $0x1,%ecx
f01063f7:	83 c2 01             	add    $0x1,%edx
f01063fa:	88 5a ff             	mov    %bl,-0x1(%edx)
f01063fd:	eb ea                	jmp    f01063e9 <strlcpy+0x1a>
f01063ff:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0106401:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106404:	29 f0                	sub    %esi,%eax
}
f0106406:	5b                   	pop    %ebx
f0106407:	5e                   	pop    %esi
f0106408:	5d                   	pop    %ebp
f0106409:	c3                   	ret    

f010640a <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010640a:	55                   	push   %ebp
f010640b:	89 e5                	mov    %esp,%ebp
f010640d:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106410:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106413:	0f b6 01             	movzbl (%ecx),%eax
f0106416:	84 c0                	test   %al,%al
f0106418:	74 0c                	je     f0106426 <strcmp+0x1c>
f010641a:	3a 02                	cmp    (%edx),%al
f010641c:	75 08                	jne    f0106426 <strcmp+0x1c>
		p++, q++;
f010641e:	83 c1 01             	add    $0x1,%ecx
f0106421:	83 c2 01             	add    $0x1,%edx
f0106424:	eb ed                	jmp    f0106413 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106426:	0f b6 c0             	movzbl %al,%eax
f0106429:	0f b6 12             	movzbl (%edx),%edx
f010642c:	29 d0                	sub    %edx,%eax
}
f010642e:	5d                   	pop    %ebp
f010642f:	c3                   	ret    

f0106430 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106430:	55                   	push   %ebp
f0106431:	89 e5                	mov    %esp,%ebp
f0106433:	53                   	push   %ebx
f0106434:	8b 45 08             	mov    0x8(%ebp),%eax
f0106437:	8b 55 0c             	mov    0xc(%ebp),%edx
f010643a:	89 c3                	mov    %eax,%ebx
f010643c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010643f:	eb 06                	jmp    f0106447 <strncmp+0x17>
		n--, p++, q++;
f0106441:	83 c0 01             	add    $0x1,%eax
f0106444:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0106447:	39 d8                	cmp    %ebx,%eax
f0106449:	74 16                	je     f0106461 <strncmp+0x31>
f010644b:	0f b6 08             	movzbl (%eax),%ecx
f010644e:	84 c9                	test   %cl,%cl
f0106450:	74 04                	je     f0106456 <strncmp+0x26>
f0106452:	3a 0a                	cmp    (%edx),%cl
f0106454:	74 eb                	je     f0106441 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106456:	0f b6 00             	movzbl (%eax),%eax
f0106459:	0f b6 12             	movzbl (%edx),%edx
f010645c:	29 d0                	sub    %edx,%eax
}
f010645e:	5b                   	pop    %ebx
f010645f:	5d                   	pop    %ebp
f0106460:	c3                   	ret    
		return 0;
f0106461:	b8 00 00 00 00       	mov    $0x0,%eax
f0106466:	eb f6                	jmp    f010645e <strncmp+0x2e>

f0106468 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106468:	55                   	push   %ebp
f0106469:	89 e5                	mov    %esp,%ebp
f010646b:	8b 45 08             	mov    0x8(%ebp),%eax
f010646e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106472:	0f b6 10             	movzbl (%eax),%edx
f0106475:	84 d2                	test   %dl,%dl
f0106477:	74 09                	je     f0106482 <strchr+0x1a>
		if (*s == c)
f0106479:	38 ca                	cmp    %cl,%dl
f010647b:	74 0a                	je     f0106487 <strchr+0x1f>
	for (; *s; s++)
f010647d:	83 c0 01             	add    $0x1,%eax
f0106480:	eb f0                	jmp    f0106472 <strchr+0xa>
			return (char *) s;
	return 0;
f0106482:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106487:	5d                   	pop    %ebp
f0106488:	c3                   	ret    

f0106489 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0106489:	55                   	push   %ebp
f010648a:	89 e5                	mov    %esp,%ebp
f010648c:	8b 45 08             	mov    0x8(%ebp),%eax
f010648f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106493:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0106496:	38 ca                	cmp    %cl,%dl
f0106498:	74 09                	je     f01064a3 <strfind+0x1a>
f010649a:	84 d2                	test   %dl,%dl
f010649c:	74 05                	je     f01064a3 <strfind+0x1a>
	for (; *s; s++)
f010649e:	83 c0 01             	add    $0x1,%eax
f01064a1:	eb f0                	jmp    f0106493 <strfind+0xa>
			break;
	return (char *) s;
}
f01064a3:	5d                   	pop    %ebp
f01064a4:	c3                   	ret    

f01064a5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01064a5:	55                   	push   %ebp
f01064a6:	89 e5                	mov    %esp,%ebp
f01064a8:	57                   	push   %edi
f01064a9:	56                   	push   %esi
f01064aa:	53                   	push   %ebx
f01064ab:	8b 7d 08             	mov    0x8(%ebp),%edi
f01064ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01064b1:	85 c9                	test   %ecx,%ecx
f01064b3:	74 31                	je     f01064e6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01064b5:	89 f8                	mov    %edi,%eax
f01064b7:	09 c8                	or     %ecx,%eax
f01064b9:	a8 03                	test   $0x3,%al
f01064bb:	75 23                	jne    f01064e0 <memset+0x3b>
		c &= 0xFF;
f01064bd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01064c1:	89 d3                	mov    %edx,%ebx
f01064c3:	c1 e3 08             	shl    $0x8,%ebx
f01064c6:	89 d0                	mov    %edx,%eax
f01064c8:	c1 e0 18             	shl    $0x18,%eax
f01064cb:	89 d6                	mov    %edx,%esi
f01064cd:	c1 e6 10             	shl    $0x10,%esi
f01064d0:	09 f0                	or     %esi,%eax
f01064d2:	09 c2                	or     %eax,%edx
f01064d4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01064d6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01064d9:	89 d0                	mov    %edx,%eax
f01064db:	fc                   	cld    
f01064dc:	f3 ab                	rep stos %eax,%es:(%edi)
f01064de:	eb 06                	jmp    f01064e6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01064e0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01064e3:	fc                   	cld    
f01064e4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01064e6:	89 f8                	mov    %edi,%eax
f01064e8:	5b                   	pop    %ebx
f01064e9:	5e                   	pop    %esi
f01064ea:	5f                   	pop    %edi
f01064eb:	5d                   	pop    %ebp
f01064ec:	c3                   	ret    

f01064ed <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01064ed:	55                   	push   %ebp
f01064ee:	89 e5                	mov    %esp,%ebp
f01064f0:	57                   	push   %edi
f01064f1:	56                   	push   %esi
f01064f2:	8b 45 08             	mov    0x8(%ebp),%eax
f01064f5:	8b 75 0c             	mov    0xc(%ebp),%esi
f01064f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01064fb:	39 c6                	cmp    %eax,%esi
f01064fd:	73 32                	jae    f0106531 <memmove+0x44>
f01064ff:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106502:	39 c2                	cmp    %eax,%edx
f0106504:	76 2b                	jbe    f0106531 <memmove+0x44>
		s += n;
		d += n;
f0106506:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106509:	89 fe                	mov    %edi,%esi
f010650b:	09 ce                	or     %ecx,%esi
f010650d:	09 d6                	or     %edx,%esi
f010650f:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106515:	75 0e                	jne    f0106525 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106517:	83 ef 04             	sub    $0x4,%edi
f010651a:	8d 72 fc             	lea    -0x4(%edx),%esi
f010651d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0106520:	fd                   	std    
f0106521:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106523:	eb 09                	jmp    f010652e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106525:	83 ef 01             	sub    $0x1,%edi
f0106528:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010652b:	fd                   	std    
f010652c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010652e:	fc                   	cld    
f010652f:	eb 1a                	jmp    f010654b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106531:	89 c2                	mov    %eax,%edx
f0106533:	09 ca                	or     %ecx,%edx
f0106535:	09 f2                	or     %esi,%edx
f0106537:	f6 c2 03             	test   $0x3,%dl
f010653a:	75 0a                	jne    f0106546 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010653c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010653f:	89 c7                	mov    %eax,%edi
f0106541:	fc                   	cld    
f0106542:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106544:	eb 05                	jmp    f010654b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0106546:	89 c7                	mov    %eax,%edi
f0106548:	fc                   	cld    
f0106549:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010654b:	5e                   	pop    %esi
f010654c:	5f                   	pop    %edi
f010654d:	5d                   	pop    %ebp
f010654e:	c3                   	ret    

f010654f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010654f:	55                   	push   %ebp
f0106550:	89 e5                	mov    %esp,%ebp
f0106552:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106555:	ff 75 10             	pushl  0x10(%ebp)
f0106558:	ff 75 0c             	pushl  0xc(%ebp)
f010655b:	ff 75 08             	pushl  0x8(%ebp)
f010655e:	e8 8a ff ff ff       	call   f01064ed <memmove>
}
f0106563:	c9                   	leave  
f0106564:	c3                   	ret    

f0106565 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106565:	55                   	push   %ebp
f0106566:	89 e5                	mov    %esp,%ebp
f0106568:	56                   	push   %esi
f0106569:	53                   	push   %ebx
f010656a:	8b 45 08             	mov    0x8(%ebp),%eax
f010656d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106570:	89 c6                	mov    %eax,%esi
f0106572:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106575:	39 f0                	cmp    %esi,%eax
f0106577:	74 1c                	je     f0106595 <memcmp+0x30>
		if (*s1 != *s2)
f0106579:	0f b6 08             	movzbl (%eax),%ecx
f010657c:	0f b6 1a             	movzbl (%edx),%ebx
f010657f:	38 d9                	cmp    %bl,%cl
f0106581:	75 08                	jne    f010658b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0106583:	83 c0 01             	add    $0x1,%eax
f0106586:	83 c2 01             	add    $0x1,%edx
f0106589:	eb ea                	jmp    f0106575 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f010658b:	0f b6 c1             	movzbl %cl,%eax
f010658e:	0f b6 db             	movzbl %bl,%ebx
f0106591:	29 d8                	sub    %ebx,%eax
f0106593:	eb 05                	jmp    f010659a <memcmp+0x35>
	}

	return 0;
f0106595:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010659a:	5b                   	pop    %ebx
f010659b:	5e                   	pop    %esi
f010659c:	5d                   	pop    %ebp
f010659d:	c3                   	ret    

f010659e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f010659e:	55                   	push   %ebp
f010659f:	89 e5                	mov    %esp,%ebp
f01065a1:	8b 45 08             	mov    0x8(%ebp),%eax
f01065a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01065a7:	89 c2                	mov    %eax,%edx
f01065a9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01065ac:	39 d0                	cmp    %edx,%eax
f01065ae:	73 09                	jae    f01065b9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01065b0:	38 08                	cmp    %cl,(%eax)
f01065b2:	74 05                	je     f01065b9 <memfind+0x1b>
	for (; s < ends; s++)
f01065b4:	83 c0 01             	add    $0x1,%eax
f01065b7:	eb f3                	jmp    f01065ac <memfind+0xe>
			break;
	return (void *) s;
}
f01065b9:	5d                   	pop    %ebp
f01065ba:	c3                   	ret    

f01065bb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01065bb:	55                   	push   %ebp
f01065bc:	89 e5                	mov    %esp,%ebp
f01065be:	57                   	push   %edi
f01065bf:	56                   	push   %esi
f01065c0:	53                   	push   %ebx
f01065c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01065c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01065c7:	eb 03                	jmp    f01065cc <strtol+0x11>
		s++;
f01065c9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01065cc:	0f b6 01             	movzbl (%ecx),%eax
f01065cf:	3c 20                	cmp    $0x20,%al
f01065d1:	74 f6                	je     f01065c9 <strtol+0xe>
f01065d3:	3c 09                	cmp    $0x9,%al
f01065d5:	74 f2                	je     f01065c9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01065d7:	3c 2b                	cmp    $0x2b,%al
f01065d9:	74 2a                	je     f0106605 <strtol+0x4a>
	int neg = 0;
f01065db:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01065e0:	3c 2d                	cmp    $0x2d,%al
f01065e2:	74 2b                	je     f010660f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01065e4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01065ea:	75 0f                	jne    f01065fb <strtol+0x40>
f01065ec:	80 39 30             	cmpb   $0x30,(%ecx)
f01065ef:	74 28                	je     f0106619 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01065f1:	85 db                	test   %ebx,%ebx
f01065f3:	b8 0a 00 00 00       	mov    $0xa,%eax
f01065f8:	0f 44 d8             	cmove  %eax,%ebx
f01065fb:	b8 00 00 00 00       	mov    $0x0,%eax
f0106600:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106603:	eb 50                	jmp    f0106655 <strtol+0x9a>
		s++;
f0106605:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0106608:	bf 00 00 00 00       	mov    $0x0,%edi
f010660d:	eb d5                	jmp    f01065e4 <strtol+0x29>
		s++, neg = 1;
f010660f:	83 c1 01             	add    $0x1,%ecx
f0106612:	bf 01 00 00 00       	mov    $0x1,%edi
f0106617:	eb cb                	jmp    f01065e4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106619:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010661d:	74 0e                	je     f010662d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f010661f:	85 db                	test   %ebx,%ebx
f0106621:	75 d8                	jne    f01065fb <strtol+0x40>
		s++, base = 8;
f0106623:	83 c1 01             	add    $0x1,%ecx
f0106626:	bb 08 00 00 00       	mov    $0x8,%ebx
f010662b:	eb ce                	jmp    f01065fb <strtol+0x40>
		s += 2, base = 16;
f010662d:	83 c1 02             	add    $0x2,%ecx
f0106630:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106635:	eb c4                	jmp    f01065fb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106637:	8d 72 9f             	lea    -0x61(%edx),%esi
f010663a:	89 f3                	mov    %esi,%ebx
f010663c:	80 fb 19             	cmp    $0x19,%bl
f010663f:	77 29                	ja     f010666a <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106641:	0f be d2             	movsbl %dl,%edx
f0106644:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106647:	3b 55 10             	cmp    0x10(%ebp),%edx
f010664a:	7d 30                	jge    f010667c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010664c:	83 c1 01             	add    $0x1,%ecx
f010664f:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106653:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106655:	0f b6 11             	movzbl (%ecx),%edx
f0106658:	8d 72 d0             	lea    -0x30(%edx),%esi
f010665b:	89 f3                	mov    %esi,%ebx
f010665d:	80 fb 09             	cmp    $0x9,%bl
f0106660:	77 d5                	ja     f0106637 <strtol+0x7c>
			dig = *s - '0';
f0106662:	0f be d2             	movsbl %dl,%edx
f0106665:	83 ea 30             	sub    $0x30,%edx
f0106668:	eb dd                	jmp    f0106647 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f010666a:	8d 72 bf             	lea    -0x41(%edx),%esi
f010666d:	89 f3                	mov    %esi,%ebx
f010666f:	80 fb 19             	cmp    $0x19,%bl
f0106672:	77 08                	ja     f010667c <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106674:	0f be d2             	movsbl %dl,%edx
f0106677:	83 ea 37             	sub    $0x37,%edx
f010667a:	eb cb                	jmp    f0106647 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f010667c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106680:	74 05                	je     f0106687 <strtol+0xcc>
		*endptr = (char *) s;
f0106682:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106685:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0106687:	89 c2                	mov    %eax,%edx
f0106689:	f7 da                	neg    %edx
f010668b:	85 ff                	test   %edi,%edi
f010668d:	0f 45 c2             	cmovne %edx,%eax
}
f0106690:	5b                   	pop    %ebx
f0106691:	5e                   	pop    %esi
f0106692:	5f                   	pop    %edi
f0106693:	5d                   	pop    %ebp
f0106694:	c3                   	ret    
f0106695:	66 90                	xchg   %ax,%ax
f0106697:	90                   	nop

f0106698 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106698:	fa                   	cli    

	xorw    %ax, %ax
f0106699:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f010669b:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f010669d:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f010669f:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01066a1:	0f 01 16             	lgdtl  (%esi)
f01066a4:	7c 70                	jl     f0106716 <gdtdesc+0x2>
	movl    %cr0, %eax
f01066a6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01066a9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01066ad:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01066b0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01066b6:	08 00                	or     %al,(%eax)

f01066b8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01066b8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01066bc:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01066be:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01066c0:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01066c2:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01066c6:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01066c8:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01066ca:	b8 00 60 12 00       	mov    $0x126000,%eax
	movl    %eax, %cr3
f01066cf:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f01066d2:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f01066d5:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f01066d8:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f01066db:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01066de:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01066e3:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01066e6:	8b 25 a4 be 57 f0    	mov    0xf057bea4,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01066ec:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01066f1:	b8 eb 01 10 f0       	mov    $0xf01001eb,%eax
	call    *%eax
f01066f6:	ff d0                	call   *%eax

f01066f8 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f01066f8:	eb fe                	jmp    f01066f8 <spin>
f01066fa:	66 90                	xchg   %ax,%ax

f01066fc <gdt>:
	...
f0106704:	ff                   	(bad)  
f0106705:	ff 00                	incl   (%eax)
f0106707:	00 00                	add    %al,(%eax)
f0106709:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0106710:	00                   	.byte 0x0
f0106711:	92                   	xchg   %eax,%edx
f0106712:	cf                   	iret   
	...

f0106714 <gdtdesc>:
f0106714:	17                   	pop    %ss
f0106715:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f010671a <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f010671a:	90                   	nop

f010671b <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f010671b:	55                   	push   %ebp
f010671c:	89 e5                	mov    %esp,%ebp
f010671e:	57                   	push   %edi
f010671f:	56                   	push   %esi
f0106720:	53                   	push   %ebx
f0106721:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106724:	8b 0d a8 be 57 f0    	mov    0xf057bea8,%ecx
f010672a:	89 c3                	mov    %eax,%ebx
f010672c:	c1 eb 0c             	shr    $0xc,%ebx
f010672f:	39 cb                	cmp    %ecx,%ebx
f0106731:	73 1a                	jae    f010674d <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0106733:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106739:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f010673c:	89 f8                	mov    %edi,%eax
f010673e:	c1 e8 0c             	shr    $0xc,%eax
f0106741:	39 c8                	cmp    %ecx,%eax
f0106743:	73 1a                	jae    f010675f <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106745:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f010674b:	eb 27                	jmp    f0106774 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010674d:	50                   	push   %eax
f010674e:	68 d4 76 10 f0       	push   $0xf01076d4
f0106753:	6a 57                	push   $0x57
f0106755:	68 a1 98 10 f0       	push   $0xf01098a1
f010675a:	e8 ea 98 ff ff       	call   f0100049 <_panic>
f010675f:	57                   	push   %edi
f0106760:	68 d4 76 10 f0       	push   $0xf01076d4
f0106765:	6a 57                	push   $0x57
f0106767:	68 a1 98 10 f0       	push   $0xf01098a1
f010676c:	e8 d8 98 ff ff       	call   f0100049 <_panic>
f0106771:	83 c3 10             	add    $0x10,%ebx
f0106774:	39 fb                	cmp    %edi,%ebx
f0106776:	73 30                	jae    f01067a8 <mpsearch1+0x8d>
f0106778:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010677a:	83 ec 04             	sub    $0x4,%esp
f010677d:	6a 04                	push   $0x4
f010677f:	68 b1 98 10 f0       	push   $0xf01098b1
f0106784:	53                   	push   %ebx
f0106785:	e8 db fd ff ff       	call   f0106565 <memcmp>
f010678a:	83 c4 10             	add    $0x10,%esp
f010678d:	85 c0                	test   %eax,%eax
f010678f:	75 e0                	jne    f0106771 <mpsearch1+0x56>
f0106791:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0106793:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0106796:	0f b6 0a             	movzbl (%edx),%ecx
f0106799:	01 c8                	add    %ecx,%eax
f010679b:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f010679e:	39 f2                	cmp    %esi,%edx
f01067a0:	75 f4                	jne    f0106796 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01067a2:	84 c0                	test   %al,%al
f01067a4:	75 cb                	jne    f0106771 <mpsearch1+0x56>
f01067a6:	eb 05                	jmp    f01067ad <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01067a8:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01067ad:	89 d8                	mov    %ebx,%eax
f01067af:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01067b2:	5b                   	pop    %ebx
f01067b3:	5e                   	pop    %esi
f01067b4:	5f                   	pop    %edi
f01067b5:	5d                   	pop    %ebp
f01067b6:	c3                   	ret    

f01067b7 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01067b7:	55                   	push   %ebp
f01067b8:	89 e5                	mov    %esp,%ebp
f01067ba:	57                   	push   %edi
f01067bb:	56                   	push   %esi
f01067bc:	53                   	push   %ebx
f01067bd:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01067c0:	c7 05 c0 c3 57 f0 20 	movl   $0xf057c020,0xf057c3c0
f01067c7:	c0 57 f0 
	if (PGNUM(pa) >= npages)
f01067ca:	83 3d a8 be 57 f0 00 	cmpl   $0x0,0xf057bea8
f01067d1:	0f 84 a3 00 00 00    	je     f010687a <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01067d7:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01067de:	85 c0                	test   %eax,%eax
f01067e0:	0f 84 aa 00 00 00    	je     f0106890 <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f01067e6:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01067e9:	ba 00 04 00 00       	mov    $0x400,%edx
f01067ee:	e8 28 ff ff ff       	call   f010671b <mpsearch1>
f01067f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01067f6:	85 c0                	test   %eax,%eax
f01067f8:	75 1a                	jne    f0106814 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f01067fa:	ba 00 00 01 00       	mov    $0x10000,%edx
f01067ff:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106804:	e8 12 ff ff ff       	call   f010671b <mpsearch1>
f0106809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f010680c:	85 c0                	test   %eax,%eax
f010680e:	0f 84 31 02 00 00    	je     f0106a45 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106817:	8b 58 04             	mov    0x4(%eax),%ebx
f010681a:	85 db                	test   %ebx,%ebx
f010681c:	0f 84 97 00 00 00    	je     f01068b9 <mp_init+0x102>
f0106822:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106826:	0f 85 8d 00 00 00    	jne    f01068b9 <mp_init+0x102>
f010682c:	89 d8                	mov    %ebx,%eax
f010682e:	c1 e8 0c             	shr    $0xc,%eax
f0106831:	3b 05 a8 be 57 f0    	cmp    0xf057bea8,%eax
f0106837:	0f 83 91 00 00 00    	jae    f01068ce <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f010683d:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0106843:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106845:	83 ec 04             	sub    $0x4,%esp
f0106848:	6a 04                	push   $0x4
f010684a:	68 b6 98 10 f0       	push   $0xf01098b6
f010684f:	53                   	push   %ebx
f0106850:	e8 10 fd ff ff       	call   f0106565 <memcmp>
f0106855:	83 c4 10             	add    $0x10,%esp
f0106858:	85 c0                	test   %eax,%eax
f010685a:	0f 85 83 00 00 00    	jne    f01068e3 <mp_init+0x12c>
f0106860:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106864:	01 df                	add    %ebx,%edi
	sum = 0;
f0106866:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106868:	39 fb                	cmp    %edi,%ebx
f010686a:	0f 84 88 00 00 00    	je     f01068f8 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f0106870:	0f b6 0b             	movzbl (%ebx),%ecx
f0106873:	01 ca                	add    %ecx,%edx
f0106875:	83 c3 01             	add    $0x1,%ebx
f0106878:	eb ee                	jmp    f0106868 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010687a:	68 00 04 00 00       	push   $0x400
f010687f:	68 d4 76 10 f0       	push   $0xf01076d4
f0106884:	6a 6f                	push   $0x6f
f0106886:	68 a1 98 10 f0       	push   $0xf01098a1
f010688b:	e8 b9 97 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0106890:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0106897:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f010689a:	2d 00 04 00 00       	sub    $0x400,%eax
f010689f:	ba 00 04 00 00       	mov    $0x400,%edx
f01068a4:	e8 72 fe ff ff       	call   f010671b <mpsearch1>
f01068a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01068ac:	85 c0                	test   %eax,%eax
f01068ae:	0f 85 60 ff ff ff    	jne    f0106814 <mp_init+0x5d>
f01068b4:	e9 41 ff ff ff       	jmp    f01067fa <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f01068b9:	83 ec 0c             	sub    $0xc,%esp
f01068bc:	68 14 97 10 f0       	push   $0xf0109714
f01068c1:	e8 9a d5 ff ff       	call   f0103e60 <cprintf>
f01068c6:	83 c4 10             	add    $0x10,%esp
f01068c9:	e9 77 01 00 00       	jmp    f0106a45 <mp_init+0x28e>
f01068ce:	53                   	push   %ebx
f01068cf:	68 d4 76 10 f0       	push   $0xf01076d4
f01068d4:	68 90 00 00 00       	push   $0x90
f01068d9:	68 a1 98 10 f0       	push   $0xf01098a1
f01068de:	e8 66 97 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01068e3:	83 ec 0c             	sub    $0xc,%esp
f01068e6:	68 44 97 10 f0       	push   $0xf0109744
f01068eb:	e8 70 d5 ff ff       	call   f0103e60 <cprintf>
f01068f0:	83 c4 10             	add    $0x10,%esp
f01068f3:	e9 4d 01 00 00       	jmp    f0106a45 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f01068f8:	84 d2                	test   %dl,%dl
f01068fa:	75 16                	jne    f0106912 <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f01068fc:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0106900:	80 fa 01             	cmp    $0x1,%dl
f0106903:	74 05                	je     f010690a <mp_init+0x153>
f0106905:	80 fa 04             	cmp    $0x4,%dl
f0106908:	75 1d                	jne    f0106927 <mp_init+0x170>
f010690a:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f010690e:	01 d9                	add    %ebx,%ecx
f0106910:	eb 36                	jmp    f0106948 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106912:	83 ec 0c             	sub    $0xc,%esp
f0106915:	68 78 97 10 f0       	push   $0xf0109778
f010691a:	e8 41 d5 ff ff       	call   f0103e60 <cprintf>
f010691f:	83 c4 10             	add    $0x10,%esp
f0106922:	e9 1e 01 00 00       	jmp    f0106a45 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106927:	83 ec 08             	sub    $0x8,%esp
f010692a:	0f b6 d2             	movzbl %dl,%edx
f010692d:	52                   	push   %edx
f010692e:	68 9c 97 10 f0       	push   $0xf010979c
f0106933:	e8 28 d5 ff ff       	call   f0103e60 <cprintf>
f0106938:	83 c4 10             	add    $0x10,%esp
f010693b:	e9 05 01 00 00       	jmp    f0106a45 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106940:	0f b6 13             	movzbl (%ebx),%edx
f0106943:	01 d0                	add    %edx,%eax
f0106945:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106948:	39 d9                	cmp    %ebx,%ecx
f010694a:	75 f4                	jne    f0106940 <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f010694c:	02 46 2a             	add    0x2a(%esi),%al
f010694f:	75 1c                	jne    f010696d <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106951:	c7 05 00 c0 57 f0 01 	movl   $0x1,0xf057c000
f0106958:	00 00 00 
	lapicaddr = conf->lapicaddr;
f010695b:	8b 46 24             	mov    0x24(%esi),%eax
f010695e:	a3 00 d0 5b f0       	mov    %eax,0xf05bd000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106963:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106966:	bb 00 00 00 00       	mov    $0x0,%ebx
f010696b:	eb 4d                	jmp    f01069ba <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f010696d:	83 ec 0c             	sub    $0xc,%esp
f0106970:	68 bc 97 10 f0       	push   $0xf01097bc
f0106975:	e8 e6 d4 ff ff       	call   f0103e60 <cprintf>
f010697a:	83 c4 10             	add    $0x10,%esp
f010697d:	e9 c3 00 00 00       	jmp    f0106a45 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106982:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106986:	74 11                	je     f0106999 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106988:	6b 05 c4 c3 57 f0 74 	imul   $0x74,0xf057c3c4,%eax
f010698f:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0106994:	a3 c0 c3 57 f0       	mov    %eax,0xf057c3c0
			if (ncpu < NCPU) {
f0106999:	a1 c4 c3 57 f0       	mov    0xf057c3c4,%eax
f010699e:	83 f8 07             	cmp    $0x7,%eax
f01069a1:	7f 2f                	jg     f01069d2 <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f01069a3:	6b d0 74             	imul   $0x74,%eax,%edx
f01069a6:	88 82 20 c0 57 f0    	mov    %al,-0xfa83fe0(%edx)
				ncpu++;
f01069ac:	83 c0 01             	add    $0x1,%eax
f01069af:	a3 c4 c3 57 f0       	mov    %eax,0xf057c3c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f01069b4:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01069b7:	83 c3 01             	add    $0x1,%ebx
f01069ba:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f01069be:	39 d8                	cmp    %ebx,%eax
f01069c0:	76 4b                	jbe    f0106a0d <mp_init+0x256>
		switch (*p) {
f01069c2:	0f b6 07             	movzbl (%edi),%eax
f01069c5:	84 c0                	test   %al,%al
f01069c7:	74 b9                	je     f0106982 <mp_init+0x1cb>
f01069c9:	3c 04                	cmp    $0x4,%al
f01069cb:	77 1c                	ja     f01069e9 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f01069cd:	83 c7 08             	add    $0x8,%edi
			continue;
f01069d0:	eb e5                	jmp    f01069b7 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f01069d2:	83 ec 08             	sub    $0x8,%esp
f01069d5:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f01069d9:	50                   	push   %eax
f01069da:	68 ec 97 10 f0       	push   $0xf01097ec
f01069df:	e8 7c d4 ff ff       	call   f0103e60 <cprintf>
f01069e4:	83 c4 10             	add    $0x10,%esp
f01069e7:	eb cb                	jmp    f01069b4 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f01069e9:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f01069ec:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f01069ef:	50                   	push   %eax
f01069f0:	68 14 98 10 f0       	push   $0xf0109814
f01069f5:	e8 66 d4 ff ff       	call   f0103e60 <cprintf>
			ismp = 0;
f01069fa:	c7 05 00 c0 57 f0 00 	movl   $0x0,0xf057c000
f0106a01:	00 00 00 
			i = conf->entry;
f0106a04:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106a08:	83 c4 10             	add    $0x10,%esp
f0106a0b:	eb aa                	jmp    f01069b7 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106a0d:	a1 c0 c3 57 f0       	mov    0xf057c3c0,%eax
f0106a12:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106a19:	83 3d 00 c0 57 f0 00 	cmpl   $0x0,0xf057c000
f0106a20:	74 2b                	je     f0106a4d <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106a22:	83 ec 04             	sub    $0x4,%esp
f0106a25:	ff 35 c4 c3 57 f0    	pushl  0xf057c3c4
f0106a2b:	0f b6 00             	movzbl (%eax),%eax
f0106a2e:	50                   	push   %eax
f0106a2f:	68 bb 98 10 f0       	push   $0xf01098bb
f0106a34:	e8 27 d4 ff ff       	call   f0103e60 <cprintf>

	if (mp->imcrp) {
f0106a39:	83 c4 10             	add    $0x10,%esp
f0106a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106a3f:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106a43:	75 2e                	jne    f0106a73 <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106a48:	5b                   	pop    %ebx
f0106a49:	5e                   	pop    %esi
f0106a4a:	5f                   	pop    %edi
f0106a4b:	5d                   	pop    %ebp
f0106a4c:	c3                   	ret    
		ncpu = 1;
f0106a4d:	c7 05 c4 c3 57 f0 01 	movl   $0x1,0xf057c3c4
f0106a54:	00 00 00 
		lapicaddr = 0;
f0106a57:	c7 05 00 d0 5b f0 00 	movl   $0x0,0xf05bd000
f0106a5e:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106a61:	83 ec 0c             	sub    $0xc,%esp
f0106a64:	68 34 98 10 f0       	push   $0xf0109834
f0106a69:	e8 f2 d3 ff ff       	call   f0103e60 <cprintf>
		return;
f0106a6e:	83 c4 10             	add    $0x10,%esp
f0106a71:	eb d2                	jmp    f0106a45 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106a73:	83 ec 0c             	sub    $0xc,%esp
f0106a76:	68 60 98 10 f0       	push   $0xf0109860
f0106a7b:	e8 e0 d3 ff ff       	call   f0103e60 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106a80:	b8 70 00 00 00       	mov    $0x70,%eax
f0106a85:	ba 22 00 00 00       	mov    $0x22,%edx
f0106a8a:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106a8b:	ba 23 00 00 00       	mov    $0x23,%edx
f0106a90:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106a91:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106a94:	ee                   	out    %al,(%dx)
f0106a95:	83 c4 10             	add    $0x10,%esp
f0106a98:	eb ab                	jmp    f0106a45 <mp_init+0x28e>

f0106a9a <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106a9a:	8b 0d 04 d0 5b f0    	mov    0xf05bd004,%ecx
f0106aa0:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106aa3:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106aa5:	a1 04 d0 5b f0       	mov    0xf05bd004,%eax
f0106aaa:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106aad:	c3                   	ret    

f0106aae <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f0106aae:	8b 15 04 d0 5b f0    	mov    0xf05bd004,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f0106ab4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f0106ab9:	85 d2                	test   %edx,%edx
f0106abb:	74 06                	je     f0106ac3 <cpunum+0x15>
		return lapic[ID] >> 24;
f0106abd:	8b 42 20             	mov    0x20(%edx),%eax
f0106ac0:	c1 e8 18             	shr    $0x18,%eax
}
f0106ac3:	c3                   	ret    

f0106ac4 <lapic_init>:
	if (!lapicaddr)
f0106ac4:	a1 00 d0 5b f0       	mov    0xf05bd000,%eax
f0106ac9:	85 c0                	test   %eax,%eax
f0106acb:	75 01                	jne    f0106ace <lapic_init+0xa>
f0106acd:	c3                   	ret    
{
f0106ace:	55                   	push   %ebp
f0106acf:	89 e5                	mov    %esp,%ebp
f0106ad1:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106ad4:	68 00 10 00 00       	push   $0x1000
f0106ad9:	50                   	push   %eax
f0106ada:	e8 03 ac ff ff       	call   f01016e2 <mmio_map_region>
f0106adf:	a3 04 d0 5b f0       	mov    %eax,0xf05bd004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106ae4:	ba 27 01 00 00       	mov    $0x127,%edx
f0106ae9:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106aee:	e8 a7 ff ff ff       	call   f0106a9a <lapicw>
	lapicw(TDCR, X1);
f0106af3:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106af8:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106afd:	e8 98 ff ff ff       	call   f0106a9a <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106b02:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106b07:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106b0c:	e8 89 ff ff ff       	call   f0106a9a <lapicw>
	lapicw(TICR, 10000000); 
f0106b11:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106b16:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106b1b:	e8 7a ff ff ff       	call   f0106a9a <lapicw>
	if (thiscpu != bootcpu)
f0106b20:	e8 89 ff ff ff       	call   f0106aae <cpunum>
f0106b25:	6b c0 74             	imul   $0x74,%eax,%eax
f0106b28:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0106b2d:	83 c4 10             	add    $0x10,%esp
f0106b30:	39 05 c0 c3 57 f0    	cmp    %eax,0xf057c3c0
f0106b36:	74 0f                	je     f0106b47 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106b38:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106b3d:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106b42:	e8 53 ff ff ff       	call   f0106a9a <lapicw>
	lapicw(LINT1, MASKED);
f0106b47:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106b4c:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106b51:	e8 44 ff ff ff       	call   f0106a9a <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106b56:	a1 04 d0 5b f0       	mov    0xf05bd004,%eax
f0106b5b:	8b 40 30             	mov    0x30(%eax),%eax
f0106b5e:	c1 e8 10             	shr    $0x10,%eax
f0106b61:	a8 fc                	test   $0xfc,%al
f0106b63:	75 7c                	jne    f0106be1 <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106b65:	ba 33 00 00 00       	mov    $0x33,%edx
f0106b6a:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106b6f:	e8 26 ff ff ff       	call   f0106a9a <lapicw>
	lapicw(ESR, 0);
f0106b74:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b79:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106b7e:	e8 17 ff ff ff       	call   f0106a9a <lapicw>
	lapicw(ESR, 0);
f0106b83:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b88:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106b8d:	e8 08 ff ff ff       	call   f0106a9a <lapicw>
	lapicw(EOI, 0);
f0106b92:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b97:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106b9c:	e8 f9 fe ff ff       	call   f0106a9a <lapicw>
	lapicw(ICRHI, 0);
f0106ba1:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ba6:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106bab:	e8 ea fe ff ff       	call   f0106a9a <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106bb0:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106bb5:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106bba:	e8 db fe ff ff       	call   f0106a9a <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106bbf:	8b 15 04 d0 5b f0    	mov    0xf05bd004,%edx
f0106bc5:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106bcb:	f6 c4 10             	test   $0x10,%ah
f0106bce:	75 f5                	jne    f0106bc5 <lapic_init+0x101>
	lapicw(TPR, 0);
f0106bd0:	ba 00 00 00 00       	mov    $0x0,%edx
f0106bd5:	b8 20 00 00 00       	mov    $0x20,%eax
f0106bda:	e8 bb fe ff ff       	call   f0106a9a <lapicw>
}
f0106bdf:	c9                   	leave  
f0106be0:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106be1:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106be6:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106beb:	e8 aa fe ff ff       	call   f0106a9a <lapicw>
f0106bf0:	e9 70 ff ff ff       	jmp    f0106b65 <lapic_init+0xa1>

f0106bf5 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106bf5:	83 3d 04 d0 5b f0 00 	cmpl   $0x0,0xf05bd004
f0106bfc:	74 17                	je     f0106c15 <lapic_eoi+0x20>
{
f0106bfe:	55                   	push   %ebp
f0106bff:	89 e5                	mov    %esp,%ebp
f0106c01:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106c04:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c09:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106c0e:	e8 87 fe ff ff       	call   f0106a9a <lapicw>
}
f0106c13:	c9                   	leave  
f0106c14:	c3                   	ret    
f0106c15:	c3                   	ret    

f0106c16 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106c16:	55                   	push   %ebp
f0106c17:	89 e5                	mov    %esp,%ebp
f0106c19:	56                   	push   %esi
f0106c1a:	53                   	push   %ebx
f0106c1b:	8b 75 08             	mov    0x8(%ebp),%esi
f0106c1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106c21:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106c26:	ba 70 00 00 00       	mov    $0x70,%edx
f0106c2b:	ee                   	out    %al,(%dx)
f0106c2c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106c31:	ba 71 00 00 00       	mov    $0x71,%edx
f0106c36:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106c37:	83 3d a8 be 57 f0 00 	cmpl   $0x0,0xf057bea8
f0106c3e:	74 7e                	je     f0106cbe <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106c40:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106c47:	00 00 
	wrv[1] = addr >> 4;
f0106c49:	89 d8                	mov    %ebx,%eax
f0106c4b:	c1 e8 04             	shr    $0x4,%eax
f0106c4e:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106c54:	c1 e6 18             	shl    $0x18,%esi
f0106c57:	89 f2                	mov    %esi,%edx
f0106c59:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106c5e:	e8 37 fe ff ff       	call   f0106a9a <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106c63:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106c68:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c6d:	e8 28 fe ff ff       	call   f0106a9a <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106c72:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106c77:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c7c:	e8 19 fe ff ff       	call   f0106a9a <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106c81:	c1 eb 0c             	shr    $0xc,%ebx
f0106c84:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106c87:	89 f2                	mov    %esi,%edx
f0106c89:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106c8e:	e8 07 fe ff ff       	call   f0106a9a <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106c93:	89 da                	mov    %ebx,%edx
f0106c95:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106c9a:	e8 fb fd ff ff       	call   f0106a9a <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106c9f:	89 f2                	mov    %esi,%edx
f0106ca1:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106ca6:	e8 ef fd ff ff       	call   f0106a9a <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106cab:	89 da                	mov    %ebx,%edx
f0106cad:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106cb2:	e8 e3 fd ff ff       	call   f0106a9a <lapicw>
		microdelay(200);
	}
}
f0106cb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106cba:	5b                   	pop    %ebx
f0106cbb:	5e                   	pop    %esi
f0106cbc:	5d                   	pop    %ebp
f0106cbd:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106cbe:	68 67 04 00 00       	push   $0x467
f0106cc3:	68 d4 76 10 f0       	push   $0xf01076d4
f0106cc8:	68 9c 00 00 00       	push   $0x9c
f0106ccd:	68 d8 98 10 f0       	push   $0xf01098d8
f0106cd2:	e8 72 93 ff ff       	call   f0100049 <_panic>

f0106cd7 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106cd7:	55                   	push   %ebp
f0106cd8:	89 e5                	mov    %esp,%ebp
f0106cda:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106cdd:	8b 55 08             	mov    0x8(%ebp),%edx
f0106ce0:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106ce6:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106ceb:	e8 aa fd ff ff       	call   f0106a9a <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106cf0:	8b 15 04 d0 5b f0    	mov    0xf05bd004,%edx
f0106cf6:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106cfc:	f6 c4 10             	test   $0x10,%ah
f0106cff:	75 f5                	jne    f0106cf6 <lapic_ipi+0x1f>
		;
}
f0106d01:	c9                   	leave  
f0106d02:	c3                   	ret    

f0106d03 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106d03:	55                   	push   %ebp
f0106d04:	89 e5                	mov    %esp,%ebp
f0106d06:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106d12:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106d15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106d1c:	5d                   	pop    %ebp
f0106d1d:	c3                   	ret    

f0106d1e <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106d1e:	55                   	push   %ebp
f0106d1f:	89 e5                	mov    %esp,%ebp
f0106d21:	56                   	push   %esi
f0106d22:	53                   	push   %ebx
f0106d23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106d26:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106d29:	75 12                	jne    f0106d3d <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0106d2b:	ba 01 00 00 00       	mov    $0x1,%edx
f0106d30:	89 d0                	mov    %edx,%eax
f0106d32:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106d35:	85 c0                	test   %eax,%eax
f0106d37:	74 36                	je     f0106d6f <spin_lock+0x51>
		asm volatile ("pause");
f0106d39:	f3 90                	pause  
f0106d3b:	eb f3                	jmp    f0106d30 <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0106d3d:	8b 73 08             	mov    0x8(%ebx),%esi
f0106d40:	e8 69 fd ff ff       	call   f0106aae <cpunum>
f0106d45:	6b c0 74             	imul   $0x74,%eax,%eax
f0106d48:	05 20 c0 57 f0       	add    $0xf057c020,%eax
	if (holding(lk))
f0106d4d:	39 c6                	cmp    %eax,%esi
f0106d4f:	75 da                	jne    f0106d2b <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106d51:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106d54:	e8 55 fd ff ff       	call   f0106aae <cpunum>
f0106d59:	83 ec 0c             	sub    $0xc,%esp
f0106d5c:	53                   	push   %ebx
f0106d5d:	50                   	push   %eax
f0106d5e:	68 e8 98 10 f0       	push   $0xf01098e8
f0106d63:	6a 41                	push   $0x41
f0106d65:	68 4a 99 10 f0       	push   $0xf010994a
f0106d6a:	e8 da 92 ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106d6f:	e8 3a fd ff ff       	call   f0106aae <cpunum>
f0106d74:	6b c0 74             	imul   $0x74,%eax,%eax
f0106d77:	05 20 c0 57 f0       	add    $0xf057c020,%eax
f0106d7c:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0106d7f:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106d81:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106d86:	83 f8 09             	cmp    $0x9,%eax
f0106d89:	7f 16                	jg     f0106da1 <spin_lock+0x83>
f0106d8b:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106d91:	76 0e                	jbe    f0106da1 <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106d93:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106d96:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106d9a:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106d9c:	83 c0 01             	add    $0x1,%eax
f0106d9f:	eb e5                	jmp    f0106d86 <spin_lock+0x68>
	for (; i < 10; i++)
f0106da1:	83 f8 09             	cmp    $0x9,%eax
f0106da4:	7f 0d                	jg     f0106db3 <spin_lock+0x95>
		pcs[i] = 0;
f0106da6:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106dad:	00 
	for (; i < 10; i++)
f0106dae:	83 c0 01             	add    $0x1,%eax
f0106db1:	eb ee                	jmp    f0106da1 <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106db6:	5b                   	pop    %ebx
f0106db7:	5e                   	pop    %esi
f0106db8:	5d                   	pop    %ebp
f0106db9:	c3                   	ret    

f0106dba <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106dba:	55                   	push   %ebp
f0106dbb:	89 e5                	mov    %esp,%ebp
f0106dbd:	57                   	push   %edi
f0106dbe:	56                   	push   %esi
f0106dbf:	53                   	push   %ebx
f0106dc0:	83 ec 4c             	sub    $0x4c,%esp
f0106dc3:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106dc6:	83 3e 00             	cmpl   $0x0,(%esi)
f0106dc9:	75 35                	jne    f0106e00 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106dcb:	83 ec 04             	sub    $0x4,%esp
f0106dce:	6a 28                	push   $0x28
f0106dd0:	8d 46 0c             	lea    0xc(%esi),%eax
f0106dd3:	50                   	push   %eax
f0106dd4:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106dd7:	53                   	push   %ebx
f0106dd8:	e8 10 f7 ff ff       	call   f01064ed <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106ddd:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106de0:	0f b6 38             	movzbl (%eax),%edi
f0106de3:	8b 76 04             	mov    0x4(%esi),%esi
f0106de6:	e8 c3 fc ff ff       	call   f0106aae <cpunum>
f0106deb:	57                   	push   %edi
f0106dec:	56                   	push   %esi
f0106ded:	50                   	push   %eax
f0106dee:	68 14 99 10 f0       	push   $0xf0109914
f0106df3:	e8 68 d0 ff ff       	call   f0103e60 <cprintf>
f0106df8:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106dfb:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106dfe:	eb 4e                	jmp    f0106e4e <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0106e00:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106e03:	e8 a6 fc ff ff       	call   f0106aae <cpunum>
f0106e08:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e0b:	05 20 c0 57 f0       	add    $0xf057c020,%eax
	if (!holding(lk)) {
f0106e10:	39 c3                	cmp    %eax,%ebx
f0106e12:	75 b7                	jne    f0106dcb <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0106e14:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106e1b:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106e22:	b8 00 00 00 00       	mov    $0x0,%eax
f0106e27:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106e2d:	5b                   	pop    %ebx
f0106e2e:	5e                   	pop    %esi
f0106e2f:	5f                   	pop    %edi
f0106e30:	5d                   	pop    %ebp
f0106e31:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106e32:	83 ec 08             	sub    $0x8,%esp
f0106e35:	ff 36                	pushl  (%esi)
f0106e37:	68 71 99 10 f0       	push   $0xf0109971
f0106e3c:	e8 1f d0 ff ff       	call   f0103e60 <cprintf>
f0106e41:	83 c4 10             	add    $0x10,%esp
f0106e44:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106e47:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106e4a:	39 c3                	cmp    %eax,%ebx
f0106e4c:	74 40                	je     f0106e8e <spin_unlock+0xd4>
f0106e4e:	89 de                	mov    %ebx,%esi
f0106e50:	8b 03                	mov    (%ebx),%eax
f0106e52:	85 c0                	test   %eax,%eax
f0106e54:	74 38                	je     f0106e8e <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106e56:	83 ec 08             	sub    $0x8,%esp
f0106e59:	57                   	push   %edi
f0106e5a:	50                   	push   %eax
f0106e5b:	e8 de e9 ff ff       	call   f010583e <debuginfo_eip>
f0106e60:	83 c4 10             	add    $0x10,%esp
f0106e63:	85 c0                	test   %eax,%eax
f0106e65:	78 cb                	js     f0106e32 <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106e67:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106e69:	83 ec 04             	sub    $0x4,%esp
f0106e6c:	89 c2                	mov    %eax,%edx
f0106e6e:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106e71:	52                   	push   %edx
f0106e72:	ff 75 b0             	pushl  -0x50(%ebp)
f0106e75:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106e78:	ff 75 ac             	pushl  -0x54(%ebp)
f0106e7b:	ff 75 a8             	pushl  -0x58(%ebp)
f0106e7e:	50                   	push   %eax
f0106e7f:	68 5a 99 10 f0       	push   $0xf010995a
f0106e84:	e8 d7 cf ff ff       	call   f0103e60 <cprintf>
f0106e89:	83 c4 20             	add    $0x20,%esp
f0106e8c:	eb b6                	jmp    f0106e44 <spin_unlock+0x8a>
		panic("spin_unlock");
f0106e8e:	83 ec 04             	sub    $0x4,%esp
f0106e91:	68 79 99 10 f0       	push   $0xf0109979
f0106e96:	6a 67                	push   $0x67
f0106e98:	68 4a 99 10 f0       	push   $0xf010994a
f0106e9d:	e8 a7 91 ff ff       	call   f0100049 <_panic>

f0106ea2 <e1000_tx_init>:

	// Set hardward registers
	// Look kern/e1000.h to find useful definations

	return 0;
}
f0106ea2:	b8 00 00 00 00       	mov    $0x0,%eax
f0106ea7:	c3                   	ret    

f0106ea8 <e1000_rx_init>:

	// Set hardward registers
	// Look kern/e1000.h to find useful definations

	return 0;
}
f0106ea8:	b8 00 00 00 00       	mov    $0x0,%eax
f0106ead:	c3                   	ret    

f0106eae <pci_e1000_attach>:
	// Map MMIO region and save the address in 'base;

	e1000_tx_init();
	e1000_rx_init();
	return 0;
}
f0106eae:	b8 00 00 00 00       	mov    $0x0,%eax
f0106eb3:	c3                   	ret    

f0106eb4 <e1000_tx>:
{
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address

	return 0;
}
f0106eb4:	b8 00 00 00 00       	mov    $0x0,%eax
f0106eb9:	c3                   	ret    

f0106eba <e1000_rx>:
	// the packet
	// Do not forget to reset the decscriptor and
	// give it back to hardware by modifying RDT

	return 0;
}
f0106eba:	b8 00 00 00 00       	mov    $0x0,%eax
f0106ebf:	c3                   	ret    

f0106ec0 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0106ec0:	55                   	push   %ebp
f0106ec1:	89 e5                	mov    %esp,%ebp
f0106ec3:	57                   	push   %edi
f0106ec4:	56                   	push   %esi
f0106ec5:	53                   	push   %ebx
f0106ec6:	83 ec 0c             	sub    $0xc,%esp
f0106ec9:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106ecc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106ecf:	eb 03                	jmp    f0106ed4 <pci_attach_match+0x14>
f0106ed1:	83 c3 0c             	add    $0xc,%ebx
f0106ed4:	89 de                	mov    %ebx,%esi
f0106ed6:	8b 43 08             	mov    0x8(%ebx),%eax
f0106ed9:	85 c0                	test   %eax,%eax
f0106edb:	74 37                	je     f0106f14 <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0106edd:	39 3b                	cmp    %edi,(%ebx)
f0106edf:	75 f0                	jne    f0106ed1 <pci_attach_match+0x11>
f0106ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106ee4:	39 56 04             	cmp    %edx,0x4(%esi)
f0106ee7:	75 e8                	jne    f0106ed1 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f0106ee9:	83 ec 0c             	sub    $0xc,%esp
f0106eec:	ff 75 14             	pushl  0x14(%ebp)
f0106eef:	ff d0                	call   *%eax
			if (r > 0)
f0106ef1:	83 c4 10             	add    $0x10,%esp
f0106ef4:	85 c0                	test   %eax,%eax
f0106ef6:	7f 1c                	jg     f0106f14 <pci_attach_match+0x54>
				return r;
			if (r < 0)
f0106ef8:	79 d7                	jns    f0106ed1 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f0106efa:	83 ec 0c             	sub    $0xc,%esp
f0106efd:	50                   	push   %eax
f0106efe:	ff 76 08             	pushl  0x8(%esi)
f0106f01:	ff 75 0c             	pushl  0xc(%ebp)
f0106f04:	57                   	push   %edi
f0106f05:	68 94 99 10 f0       	push   $0xf0109994
f0106f0a:	e8 51 cf ff ff       	call   f0103e60 <cprintf>
f0106f0f:	83 c4 20             	add    $0x20,%esp
f0106f12:	eb bd                	jmp    f0106ed1 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0106f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106f17:	5b                   	pop    %ebx
f0106f18:	5e                   	pop    %esi
f0106f19:	5f                   	pop    %edi
f0106f1a:	5d                   	pop    %ebp
f0106f1b:	c3                   	ret    

f0106f1c <pci_conf1_set_addr>:
{
f0106f1c:	55                   	push   %ebp
f0106f1d:	89 e5                	mov    %esp,%ebp
f0106f1f:	53                   	push   %ebx
f0106f20:	83 ec 04             	sub    $0x4,%esp
f0106f23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0106f26:	3d ff 00 00 00       	cmp    $0xff,%eax
f0106f2b:	77 36                	ja     f0106f63 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f0106f2d:	83 fa 1f             	cmp    $0x1f,%edx
f0106f30:	77 47                	ja     f0106f79 <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f0106f32:	83 f9 07             	cmp    $0x7,%ecx
f0106f35:	77 58                	ja     f0106f8f <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f0106f37:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0106f3d:	77 66                	ja     f0106fa5 <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f0106f3f:	f6 c3 03             	test   $0x3,%bl
f0106f42:	75 77                	jne    f0106fbb <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106f44:	c1 e0 10             	shl    $0x10,%eax
f0106f47:	09 d8                	or     %ebx,%eax
f0106f49:	c1 e1 08             	shl    $0x8,%ecx
f0106f4c:	09 c8                	or     %ecx,%eax
f0106f4e:	c1 e2 0b             	shl    $0xb,%edx
f0106f51:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f0106f53:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106f58:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0106f5d:	ef                   	out    %eax,(%dx)
}
f0106f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106f61:	c9                   	leave  
f0106f62:	c3                   	ret    
	assert(bus < 256);
f0106f63:	68 ec 9a 10 f0       	push   $0xf0109aec
f0106f68:	68 8b 88 10 f0       	push   $0xf010888b
f0106f6d:	6a 2b                	push   $0x2b
f0106f6f:	68 f6 9a 10 f0       	push   $0xf0109af6
f0106f74:	e8 d0 90 ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f0106f79:	68 01 9b 10 f0       	push   $0xf0109b01
f0106f7e:	68 8b 88 10 f0       	push   $0xf010888b
f0106f83:	6a 2c                	push   $0x2c
f0106f85:	68 f6 9a 10 f0       	push   $0xf0109af6
f0106f8a:	e8 ba 90 ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f0106f8f:	68 0a 9b 10 f0       	push   $0xf0109b0a
f0106f94:	68 8b 88 10 f0       	push   $0xf010888b
f0106f99:	6a 2d                	push   $0x2d
f0106f9b:	68 f6 9a 10 f0       	push   $0xf0109af6
f0106fa0:	e8 a4 90 ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f0106fa5:	68 13 9b 10 f0       	push   $0xf0109b13
f0106faa:	68 8b 88 10 f0       	push   $0xf010888b
f0106faf:	6a 2e                	push   $0x2e
f0106fb1:	68 f6 9a 10 f0       	push   $0xf0109af6
f0106fb6:	e8 8e 90 ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f0106fbb:	68 20 9b 10 f0       	push   $0xf0109b20
f0106fc0:	68 8b 88 10 f0       	push   $0xf010888b
f0106fc5:	6a 2f                	push   $0x2f
f0106fc7:	68 f6 9a 10 f0       	push   $0xf0109af6
f0106fcc:	e8 78 90 ff ff       	call   f0100049 <_panic>

f0106fd1 <pci_conf_read>:
{
f0106fd1:	55                   	push   %ebp
f0106fd2:	89 e5                	mov    %esp,%ebp
f0106fd4:	53                   	push   %ebx
f0106fd5:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106fd8:	8b 48 08             	mov    0x8(%eax),%ecx
f0106fdb:	8b 58 04             	mov    0x4(%eax),%ebx
f0106fde:	8b 00                	mov    (%eax),%eax
f0106fe0:	8b 40 04             	mov    0x4(%eax),%eax
f0106fe3:	52                   	push   %edx
f0106fe4:	89 da                	mov    %ebx,%edx
f0106fe6:	e8 31 ff ff ff       	call   f0106f1c <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0106feb:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106ff0:	ed                   	in     (%dx),%eax
}
f0106ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106ff4:	c9                   	leave  
f0106ff5:	c3                   	ret    

f0106ff6 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0106ff6:	55                   	push   %ebp
f0106ff7:	89 e5                	mov    %esp,%ebp
f0106ff9:	57                   	push   %edi
f0106ffa:	56                   	push   %esi
f0106ffb:	53                   	push   %ebx
f0106ffc:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0107002:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107004:	6a 48                	push   $0x48
f0107006:	6a 00                	push   $0x0
f0107008:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010700b:	50                   	push   %eax
f010700c:	e8 94 f4 ff ff       	call   f01064a5 <memset>
	df.bus = bus;
f0107011:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107014:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f010701b:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f010701e:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0107025:	00 00 00 
f0107028:	e9 25 01 00 00       	jmp    f0107152 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010702d:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107033:	83 ec 08             	sub    $0x8,%esp
f0107036:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f010703a:	57                   	push   %edi
f010703b:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f010703c:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f010703f:	0f b6 c0             	movzbl %al,%eax
f0107042:	50                   	push   %eax
f0107043:	51                   	push   %ecx
f0107044:	89 d0                	mov    %edx,%eax
f0107046:	c1 e8 10             	shr    $0x10,%eax
f0107049:	50                   	push   %eax
f010704a:	0f b7 d2             	movzwl %dx,%edx
f010704d:	52                   	push   %edx
f010704e:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0107054:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f010705a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107060:	ff 70 04             	pushl  0x4(%eax)
f0107063:	68 c0 99 10 f0       	push   $0xf01099c0
f0107068:	e8 f3 cd ff ff       	call   f0103e60 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f010706d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107073:	83 c4 30             	add    $0x30,%esp
f0107076:	53                   	push   %ebx
f0107077:	68 f4 73 12 f0       	push   $0xf01273f4
				 PCI_SUBCLASS(f->dev_class),
f010707c:	89 c2                	mov    %eax,%edx
f010707e:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107081:	0f b6 d2             	movzbl %dl,%edx
f0107084:	52                   	push   %edx
f0107085:	c1 e8 18             	shr    $0x18,%eax
f0107088:	50                   	push   %eax
f0107089:	e8 32 fe ff ff       	call   f0106ec0 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f010708e:	83 c4 10             	add    $0x10,%esp
f0107091:	85 c0                	test   %eax,%eax
f0107093:	0f 84 88 00 00 00    	je     f0107121 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107099:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01070a0:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01070a6:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f01070ac:	0f 83 92 00 00 00    	jae    f0107144 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f01070b2:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f01070b8:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f01070be:	b9 12 00 00 00       	mov    $0x12,%ecx
f01070c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f01070c5:	ba 00 00 00 00       	mov    $0x0,%edx
f01070ca:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f01070d0:	e8 fc fe ff ff       	call   f0106fd1 <pci_conf_read>
f01070d5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f01070db:	66 83 f8 ff          	cmp    $0xffff,%ax
f01070df:	74 b8                	je     f0107099 <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01070e1:	ba 3c 00 00 00       	mov    $0x3c,%edx
f01070e6:	89 d8                	mov    %ebx,%eax
f01070e8:	e8 e4 fe ff ff       	call   f0106fd1 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f01070ed:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f01070f0:	ba 08 00 00 00       	mov    $0x8,%edx
f01070f5:	89 d8                	mov    %ebx,%eax
f01070f7:	e8 d5 fe ff ff       	call   f0106fd1 <pci_conf_read>
f01070fc:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107102:	89 c1                	mov    %eax,%ecx
f0107104:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0107107:	be 34 9b 10 f0       	mov    $0xf0109b34,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f010710c:	83 f9 06             	cmp    $0x6,%ecx
f010710f:	0f 87 18 ff ff ff    	ja     f010702d <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107115:	8b 34 8d a8 9b 10 f0 	mov    -0xfef6458(,%ecx,4),%esi
f010711c:	e9 0c ff ff ff       	jmp    f010702d <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f0107121:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107127:	53                   	push   %ebx
f0107128:	68 80 ae 57 f0       	push   $0xf057ae80
f010712d:	89 c2                	mov    %eax,%edx
f010712f:	c1 ea 10             	shr    $0x10,%edx
f0107132:	52                   	push   %edx
f0107133:	0f b7 c0             	movzwl %ax,%eax
f0107136:	50                   	push   %eax
f0107137:	e8 84 fd ff ff       	call   f0106ec0 <pci_attach_match>
f010713c:	83 c4 10             	add    $0x10,%esp
f010713f:	e9 55 ff ff ff       	jmp    f0107099 <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107144:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107147:	83 c0 01             	add    $0x1,%eax
f010714a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f010714d:	83 f8 1f             	cmp    $0x1f,%eax
f0107150:	77 59                	ja     f01071ab <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107152:	ba 0c 00 00 00       	mov    $0xc,%edx
f0107157:	8d 45 a0             	lea    -0x60(%ebp),%eax
f010715a:	e8 72 fe ff ff       	call   f0106fd1 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f010715f:	89 c2                	mov    %eax,%edx
f0107161:	c1 ea 10             	shr    $0x10,%edx
f0107164:	f6 c2 7e             	test   $0x7e,%dl
f0107167:	75 db                	jne    f0107144 <pci_scan_bus+0x14e>
		totaldev++;
f0107169:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0107170:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107176:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107179:	b9 12 00 00 00       	mov    $0x12,%ecx
f010717e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107180:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107187:	00 00 00 
f010718a:	25 00 00 80 00       	and    $0x800000,%eax
f010718f:	83 f8 01             	cmp    $0x1,%eax
f0107192:	19 c0                	sbb    %eax,%eax
f0107194:	83 e0 f9             	and    $0xfffffff9,%eax
f0107197:	83 c0 08             	add    $0x8,%eax
f010719a:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01071a0:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01071a6:	e9 f5 fe ff ff       	jmp    f01070a0 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f01071ab:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f01071b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01071b4:	5b                   	pop    %ebx
f01071b5:	5e                   	pop    %esi
f01071b6:	5f                   	pop    %edi
f01071b7:	5d                   	pop    %ebp
f01071b8:	c3                   	ret    

f01071b9 <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f01071b9:	55                   	push   %ebp
f01071ba:	89 e5                	mov    %esp,%ebp
f01071bc:	57                   	push   %edi
f01071bd:	56                   	push   %esi
f01071be:	53                   	push   %ebx
f01071bf:	83 ec 1c             	sub    $0x1c,%esp
f01071c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01071c5:	ba 1c 00 00 00       	mov    $0x1c,%edx
f01071ca:	89 d8                	mov    %ebx,%eax
f01071cc:	e8 00 fe ff ff       	call   f0106fd1 <pci_conf_read>
f01071d1:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f01071d3:	ba 18 00 00 00       	mov    $0x18,%edx
f01071d8:	89 d8                	mov    %ebx,%eax
f01071da:	e8 f2 fd ff ff       	call   f0106fd1 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f01071df:	83 e7 0f             	and    $0xf,%edi
f01071e2:	83 ff 01             	cmp    $0x1,%edi
f01071e5:	74 56                	je     f010723d <pci_bridge_attach+0x84>
f01071e7:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01071e9:	83 ec 04             	sub    $0x4,%esp
f01071ec:	6a 08                	push   $0x8
f01071ee:	6a 00                	push   $0x0
f01071f0:	8d 7d e0             	lea    -0x20(%ebp),%edi
f01071f3:	57                   	push   %edi
f01071f4:	e8 ac f2 ff ff       	call   f01064a5 <memset>
	nbus.parent_bridge = pcif;
f01071f9:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f01071fc:	89 f0                	mov    %esi,%eax
f01071fe:	0f b6 c4             	movzbl %ah,%eax
f0107201:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107204:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0107207:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f010720a:	89 f1                	mov    %esi,%ecx
f010720c:	0f b6 f1             	movzbl %cl,%esi
f010720f:	56                   	push   %esi
f0107210:	50                   	push   %eax
f0107211:	ff 73 08             	pushl  0x8(%ebx)
f0107214:	ff 73 04             	pushl  0x4(%ebx)
f0107217:	8b 03                	mov    (%ebx),%eax
f0107219:	ff 70 04             	pushl  0x4(%eax)
f010721c:	68 30 9a 10 f0       	push   $0xf0109a30
f0107221:	e8 3a cc ff ff       	call   f0103e60 <cprintf>

	pci_scan_bus(&nbus);
f0107226:	83 c4 20             	add    $0x20,%esp
f0107229:	89 f8                	mov    %edi,%eax
f010722b:	e8 c6 fd ff ff       	call   f0106ff6 <pci_scan_bus>
	return 1;
f0107230:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107235:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107238:	5b                   	pop    %ebx
f0107239:	5e                   	pop    %esi
f010723a:	5f                   	pop    %edi
f010723b:	5d                   	pop    %ebp
f010723c:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f010723d:	ff 73 08             	pushl  0x8(%ebx)
f0107240:	ff 73 04             	pushl  0x4(%ebx)
f0107243:	8b 03                	mov    (%ebx),%eax
f0107245:	ff 70 04             	pushl  0x4(%eax)
f0107248:	68 fc 99 10 f0       	push   $0xf01099fc
f010724d:	e8 0e cc ff ff       	call   f0103e60 <cprintf>
		return 0;
f0107252:	83 c4 10             	add    $0x10,%esp
f0107255:	b8 00 00 00 00       	mov    $0x0,%eax
f010725a:	eb d9                	jmp    f0107235 <pci_bridge_attach+0x7c>

f010725c <pci_conf_write>:
{
f010725c:	55                   	push   %ebp
f010725d:	89 e5                	mov    %esp,%ebp
f010725f:	56                   	push   %esi
f0107260:	53                   	push   %ebx
f0107261:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107263:	8b 48 08             	mov    0x8(%eax),%ecx
f0107266:	8b 70 04             	mov    0x4(%eax),%esi
f0107269:	8b 00                	mov    (%eax),%eax
f010726b:	8b 40 04             	mov    0x4(%eax),%eax
f010726e:	83 ec 0c             	sub    $0xc,%esp
f0107271:	52                   	push   %edx
f0107272:	89 f2                	mov    %esi,%edx
f0107274:	e8 a3 fc ff ff       	call   f0106f1c <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107279:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f010727e:	89 d8                	mov    %ebx,%eax
f0107280:	ef                   	out    %eax,(%dx)
}
f0107281:	83 c4 10             	add    $0x10,%esp
f0107284:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107287:	5b                   	pop    %ebx
f0107288:	5e                   	pop    %esi
f0107289:	5d                   	pop    %ebp
f010728a:	c3                   	ret    

f010728b <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f010728b:	55                   	push   %ebp
f010728c:	89 e5                	mov    %esp,%ebp
f010728e:	57                   	push   %edi
f010728f:	56                   	push   %esi
f0107290:	53                   	push   %ebx
f0107291:	83 ec 2c             	sub    $0x2c,%esp
f0107294:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107297:	b9 07 00 00 00       	mov    $0x7,%ecx
f010729c:	ba 04 00 00 00       	mov    $0x4,%edx
f01072a1:	89 f8                	mov    %edi,%eax
f01072a3:	e8 b4 ff ff ff       	call   f010725c <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01072a8:	be 10 00 00 00       	mov    $0x10,%esi
f01072ad:	eb 27                	jmp    f01072d6 <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01072af:	89 c3                	mov    %eax,%ebx
f01072b1:	83 e3 fc             	and    $0xfffffffc,%ebx
f01072b4:	f7 db                	neg    %ebx
f01072b6:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f01072b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01072bb:	83 e0 fc             	and    $0xfffffffc,%eax
f01072be:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f01072c1:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f01072c8:	eb 74                	jmp    f010733e <pci_func_enable+0xb3>
	     bar += bar_width)
f01072ca:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01072cd:	83 fe 27             	cmp    $0x27,%esi
f01072d0:	0f 87 c5 00 00 00    	ja     f010739b <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f01072d6:	89 f2                	mov    %esi,%edx
f01072d8:	89 f8                	mov    %edi,%eax
f01072da:	e8 f2 fc ff ff       	call   f0106fd1 <pci_conf_read>
f01072df:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f01072e2:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01072e7:	89 f2                	mov    %esi,%edx
f01072e9:	89 f8                	mov    %edi,%eax
f01072eb:	e8 6c ff ff ff       	call   f010725c <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f01072f0:	89 f2                	mov    %esi,%edx
f01072f2:	89 f8                	mov    %edi,%eax
f01072f4:	e8 d8 fc ff ff       	call   f0106fd1 <pci_conf_read>
		bar_width = 4;
f01072f9:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0107300:	85 c0                	test   %eax,%eax
f0107302:	74 c6                	je     f01072ca <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0107304:	8d 4e f0             	lea    -0x10(%esi),%ecx
f0107307:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010730a:	c1 e9 02             	shr    $0x2,%ecx
f010730d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107310:	a8 01                	test   $0x1,%al
f0107312:	75 9b                	jne    f01072af <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107314:	89 c2                	mov    %eax,%edx
f0107316:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f0107319:	83 fa 04             	cmp    $0x4,%edx
f010731c:	0f 94 c1             	sete   %cl
f010731f:	0f b6 c9             	movzbl %cl,%ecx
f0107322:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f0107329:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f010732c:	89 c3                	mov    %eax,%ebx
f010732e:	83 e3 f0             	and    $0xfffffff0,%ebx
f0107331:	f7 db                	neg    %ebx
f0107333:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107335:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107338:	83 e0 f0             	and    $0xfffffff0,%eax
f010733b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f010733e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0107341:	89 f2                	mov    %esi,%edx
f0107343:	89 f8                	mov    %edi,%eax
f0107345:	e8 12 ff ff ff       	call   f010725c <pci_conf_write>
f010734a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010734d:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f010734f:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107352:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0107355:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f0107358:	85 db                	test   %ebx,%ebx
f010735a:	0f 84 6a ff ff ff    	je     f01072ca <pci_func_enable+0x3f>
f0107360:	85 d2                	test   %edx,%edx
f0107362:	0f 85 62 ff ff ff    	jne    f01072ca <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107368:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f010736b:	83 ec 0c             	sub    $0xc,%esp
f010736e:	53                   	push   %ebx
f010736f:	6a 00                	push   $0x0
f0107371:	ff 75 d4             	pushl  -0x2c(%ebp)
f0107374:	89 c2                	mov    %eax,%edx
f0107376:	c1 ea 10             	shr    $0x10,%edx
f0107379:	52                   	push   %edx
f010737a:	0f b7 c0             	movzwl %ax,%eax
f010737d:	50                   	push   %eax
f010737e:	ff 77 08             	pushl  0x8(%edi)
f0107381:	ff 77 04             	pushl  0x4(%edi)
f0107384:	8b 07                	mov    (%edi),%eax
f0107386:	ff 70 04             	pushl  0x4(%eax)
f0107389:	68 60 9a 10 f0       	push   $0xf0109a60
f010738e:	e8 cd ca ff ff       	call   f0103e60 <cprintf>
f0107393:	83 c4 30             	add    $0x30,%esp
f0107396:	e9 2f ff ff ff       	jmp    f01072ca <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f010739b:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f010739e:	83 ec 08             	sub    $0x8,%esp
f01073a1:	89 c2                	mov    %eax,%edx
f01073a3:	c1 ea 10             	shr    $0x10,%edx
f01073a6:	52                   	push   %edx
f01073a7:	0f b7 c0             	movzwl %ax,%eax
f01073aa:	50                   	push   %eax
f01073ab:	ff 77 08             	pushl  0x8(%edi)
f01073ae:	ff 77 04             	pushl  0x4(%edi)
f01073b1:	8b 07                	mov    (%edi),%eax
f01073b3:	ff 70 04             	pushl  0x4(%eax)
f01073b6:	68 bc 9a 10 f0       	push   $0xf0109abc
f01073bb:	e8 a0 ca ff ff       	call   f0103e60 <cprintf>
}
f01073c0:	83 c4 20             	add    $0x20,%esp
f01073c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01073c6:	5b                   	pop    %ebx
f01073c7:	5e                   	pop    %esi
f01073c8:	5f                   	pop    %edi
f01073c9:	5d                   	pop    %ebp
f01073ca:	c3                   	ret    

f01073cb <pci_init>:

int
pci_init(void)
{
f01073cb:	55                   	push   %ebp
f01073cc:	89 e5                	mov    %esp,%ebp
f01073ce:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f01073d1:	6a 08                	push   $0x8
f01073d3:	6a 00                	push   $0x0
f01073d5:	68 8c ae 57 f0       	push   $0xf057ae8c
f01073da:	e8 c6 f0 ff ff       	call   f01064a5 <memset>

	return pci_scan_bus(&root_bus);
f01073df:	b8 8c ae 57 f0       	mov    $0xf057ae8c,%eax
f01073e4:	e8 0d fc ff ff       	call   f0106ff6 <pci_scan_bus>
}
f01073e9:	c9                   	leave  
f01073ea:	c3                   	ret    

f01073eb <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f01073eb:	c7 05 94 ae 57 f0 00 	movl   $0x0,0xf057ae94
f01073f2:	00 00 00 
}
f01073f5:	c3                   	ret    

f01073f6 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f01073f6:	a1 94 ae 57 f0       	mov    0xf057ae94,%eax
f01073fb:	83 c0 01             	add    $0x1,%eax
f01073fe:	a3 94 ae 57 f0       	mov    %eax,0xf057ae94
	if (ticks * 10 < ticks)
f0107403:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107406:	01 d2                	add    %edx,%edx
f0107408:	39 d0                	cmp    %edx,%eax
f010740a:	77 01                	ja     f010740d <time_tick+0x17>
f010740c:	c3                   	ret    
{
f010740d:	55                   	push   %ebp
f010740e:	89 e5                	mov    %esp,%ebp
f0107410:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0107413:	68 c4 9b 10 f0       	push   $0xf0109bc4
f0107418:	6a 13                	push   $0x13
f010741a:	68 df 9b 10 f0       	push   $0xf0109bdf
f010741f:	e8 25 8c ff ff       	call   f0100049 <_panic>

f0107424 <time_msec>:
}

unsigned int
time_msec(void)
{
	return ticks * 10;
f0107424:	a1 94 ae 57 f0       	mov    0xf057ae94,%eax
f0107429:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010742c:	01 c0                	add    %eax,%eax
}
f010742e:	c3                   	ret    
f010742f:	90                   	nop

f0107430 <__udivdi3>:
f0107430:	55                   	push   %ebp
f0107431:	57                   	push   %edi
f0107432:	56                   	push   %esi
f0107433:	53                   	push   %ebx
f0107434:	83 ec 1c             	sub    $0x1c,%esp
f0107437:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010743b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010743f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0107443:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0107447:	85 d2                	test   %edx,%edx
f0107449:	75 4d                	jne    f0107498 <__udivdi3+0x68>
f010744b:	39 f3                	cmp    %esi,%ebx
f010744d:	76 19                	jbe    f0107468 <__udivdi3+0x38>
f010744f:	31 ff                	xor    %edi,%edi
f0107451:	89 e8                	mov    %ebp,%eax
f0107453:	89 f2                	mov    %esi,%edx
f0107455:	f7 f3                	div    %ebx
f0107457:	89 fa                	mov    %edi,%edx
f0107459:	83 c4 1c             	add    $0x1c,%esp
f010745c:	5b                   	pop    %ebx
f010745d:	5e                   	pop    %esi
f010745e:	5f                   	pop    %edi
f010745f:	5d                   	pop    %ebp
f0107460:	c3                   	ret    
f0107461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107468:	89 d9                	mov    %ebx,%ecx
f010746a:	85 db                	test   %ebx,%ebx
f010746c:	75 0b                	jne    f0107479 <__udivdi3+0x49>
f010746e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107473:	31 d2                	xor    %edx,%edx
f0107475:	f7 f3                	div    %ebx
f0107477:	89 c1                	mov    %eax,%ecx
f0107479:	31 d2                	xor    %edx,%edx
f010747b:	89 f0                	mov    %esi,%eax
f010747d:	f7 f1                	div    %ecx
f010747f:	89 c6                	mov    %eax,%esi
f0107481:	89 e8                	mov    %ebp,%eax
f0107483:	89 f7                	mov    %esi,%edi
f0107485:	f7 f1                	div    %ecx
f0107487:	89 fa                	mov    %edi,%edx
f0107489:	83 c4 1c             	add    $0x1c,%esp
f010748c:	5b                   	pop    %ebx
f010748d:	5e                   	pop    %esi
f010748e:	5f                   	pop    %edi
f010748f:	5d                   	pop    %ebp
f0107490:	c3                   	ret    
f0107491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107498:	39 f2                	cmp    %esi,%edx
f010749a:	77 1c                	ja     f01074b8 <__udivdi3+0x88>
f010749c:	0f bd fa             	bsr    %edx,%edi
f010749f:	83 f7 1f             	xor    $0x1f,%edi
f01074a2:	75 2c                	jne    f01074d0 <__udivdi3+0xa0>
f01074a4:	39 f2                	cmp    %esi,%edx
f01074a6:	72 06                	jb     f01074ae <__udivdi3+0x7e>
f01074a8:	31 c0                	xor    %eax,%eax
f01074aa:	39 eb                	cmp    %ebp,%ebx
f01074ac:	77 a9                	ja     f0107457 <__udivdi3+0x27>
f01074ae:	b8 01 00 00 00       	mov    $0x1,%eax
f01074b3:	eb a2                	jmp    f0107457 <__udivdi3+0x27>
f01074b5:	8d 76 00             	lea    0x0(%esi),%esi
f01074b8:	31 ff                	xor    %edi,%edi
f01074ba:	31 c0                	xor    %eax,%eax
f01074bc:	89 fa                	mov    %edi,%edx
f01074be:	83 c4 1c             	add    $0x1c,%esp
f01074c1:	5b                   	pop    %ebx
f01074c2:	5e                   	pop    %esi
f01074c3:	5f                   	pop    %edi
f01074c4:	5d                   	pop    %ebp
f01074c5:	c3                   	ret    
f01074c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01074cd:	8d 76 00             	lea    0x0(%esi),%esi
f01074d0:	89 f9                	mov    %edi,%ecx
f01074d2:	b8 20 00 00 00       	mov    $0x20,%eax
f01074d7:	29 f8                	sub    %edi,%eax
f01074d9:	d3 e2                	shl    %cl,%edx
f01074db:	89 54 24 08          	mov    %edx,0x8(%esp)
f01074df:	89 c1                	mov    %eax,%ecx
f01074e1:	89 da                	mov    %ebx,%edx
f01074e3:	d3 ea                	shr    %cl,%edx
f01074e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01074e9:	09 d1                	or     %edx,%ecx
f01074eb:	89 f2                	mov    %esi,%edx
f01074ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01074f1:	89 f9                	mov    %edi,%ecx
f01074f3:	d3 e3                	shl    %cl,%ebx
f01074f5:	89 c1                	mov    %eax,%ecx
f01074f7:	d3 ea                	shr    %cl,%edx
f01074f9:	89 f9                	mov    %edi,%ecx
f01074fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01074ff:	89 eb                	mov    %ebp,%ebx
f0107501:	d3 e6                	shl    %cl,%esi
f0107503:	89 c1                	mov    %eax,%ecx
f0107505:	d3 eb                	shr    %cl,%ebx
f0107507:	09 de                	or     %ebx,%esi
f0107509:	89 f0                	mov    %esi,%eax
f010750b:	f7 74 24 08          	divl   0x8(%esp)
f010750f:	89 d6                	mov    %edx,%esi
f0107511:	89 c3                	mov    %eax,%ebx
f0107513:	f7 64 24 0c          	mull   0xc(%esp)
f0107517:	39 d6                	cmp    %edx,%esi
f0107519:	72 15                	jb     f0107530 <__udivdi3+0x100>
f010751b:	89 f9                	mov    %edi,%ecx
f010751d:	d3 e5                	shl    %cl,%ebp
f010751f:	39 c5                	cmp    %eax,%ebp
f0107521:	73 04                	jae    f0107527 <__udivdi3+0xf7>
f0107523:	39 d6                	cmp    %edx,%esi
f0107525:	74 09                	je     f0107530 <__udivdi3+0x100>
f0107527:	89 d8                	mov    %ebx,%eax
f0107529:	31 ff                	xor    %edi,%edi
f010752b:	e9 27 ff ff ff       	jmp    f0107457 <__udivdi3+0x27>
f0107530:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107533:	31 ff                	xor    %edi,%edi
f0107535:	e9 1d ff ff ff       	jmp    f0107457 <__udivdi3+0x27>
f010753a:	66 90                	xchg   %ax,%ax
f010753c:	66 90                	xchg   %ax,%ax
f010753e:	66 90                	xchg   %ax,%ax

f0107540 <__umoddi3>:
f0107540:	55                   	push   %ebp
f0107541:	57                   	push   %edi
f0107542:	56                   	push   %esi
f0107543:	53                   	push   %ebx
f0107544:	83 ec 1c             	sub    $0x1c,%esp
f0107547:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f010754b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f010754f:	8b 74 24 30          	mov    0x30(%esp),%esi
f0107553:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107557:	89 da                	mov    %ebx,%edx
f0107559:	85 c0                	test   %eax,%eax
f010755b:	75 43                	jne    f01075a0 <__umoddi3+0x60>
f010755d:	39 df                	cmp    %ebx,%edi
f010755f:	76 17                	jbe    f0107578 <__umoddi3+0x38>
f0107561:	89 f0                	mov    %esi,%eax
f0107563:	f7 f7                	div    %edi
f0107565:	89 d0                	mov    %edx,%eax
f0107567:	31 d2                	xor    %edx,%edx
f0107569:	83 c4 1c             	add    $0x1c,%esp
f010756c:	5b                   	pop    %ebx
f010756d:	5e                   	pop    %esi
f010756e:	5f                   	pop    %edi
f010756f:	5d                   	pop    %ebp
f0107570:	c3                   	ret    
f0107571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107578:	89 fd                	mov    %edi,%ebp
f010757a:	85 ff                	test   %edi,%edi
f010757c:	75 0b                	jne    f0107589 <__umoddi3+0x49>
f010757e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107583:	31 d2                	xor    %edx,%edx
f0107585:	f7 f7                	div    %edi
f0107587:	89 c5                	mov    %eax,%ebp
f0107589:	89 d8                	mov    %ebx,%eax
f010758b:	31 d2                	xor    %edx,%edx
f010758d:	f7 f5                	div    %ebp
f010758f:	89 f0                	mov    %esi,%eax
f0107591:	f7 f5                	div    %ebp
f0107593:	89 d0                	mov    %edx,%eax
f0107595:	eb d0                	jmp    f0107567 <__umoddi3+0x27>
f0107597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010759e:	66 90                	xchg   %ax,%ax
f01075a0:	89 f1                	mov    %esi,%ecx
f01075a2:	39 d8                	cmp    %ebx,%eax
f01075a4:	76 0a                	jbe    f01075b0 <__umoddi3+0x70>
f01075a6:	89 f0                	mov    %esi,%eax
f01075a8:	83 c4 1c             	add    $0x1c,%esp
f01075ab:	5b                   	pop    %ebx
f01075ac:	5e                   	pop    %esi
f01075ad:	5f                   	pop    %edi
f01075ae:	5d                   	pop    %ebp
f01075af:	c3                   	ret    
f01075b0:	0f bd e8             	bsr    %eax,%ebp
f01075b3:	83 f5 1f             	xor    $0x1f,%ebp
f01075b6:	75 20                	jne    f01075d8 <__umoddi3+0x98>
f01075b8:	39 d8                	cmp    %ebx,%eax
f01075ba:	0f 82 b0 00 00 00    	jb     f0107670 <__umoddi3+0x130>
f01075c0:	39 f7                	cmp    %esi,%edi
f01075c2:	0f 86 a8 00 00 00    	jbe    f0107670 <__umoddi3+0x130>
f01075c8:	89 c8                	mov    %ecx,%eax
f01075ca:	83 c4 1c             	add    $0x1c,%esp
f01075cd:	5b                   	pop    %ebx
f01075ce:	5e                   	pop    %esi
f01075cf:	5f                   	pop    %edi
f01075d0:	5d                   	pop    %ebp
f01075d1:	c3                   	ret    
f01075d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01075d8:	89 e9                	mov    %ebp,%ecx
f01075da:	ba 20 00 00 00       	mov    $0x20,%edx
f01075df:	29 ea                	sub    %ebp,%edx
f01075e1:	d3 e0                	shl    %cl,%eax
f01075e3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01075e7:	89 d1                	mov    %edx,%ecx
f01075e9:	89 f8                	mov    %edi,%eax
f01075eb:	d3 e8                	shr    %cl,%eax
f01075ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01075f1:	89 54 24 04          	mov    %edx,0x4(%esp)
f01075f5:	8b 54 24 04          	mov    0x4(%esp),%edx
f01075f9:	09 c1                	or     %eax,%ecx
f01075fb:	89 d8                	mov    %ebx,%eax
f01075fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107601:	89 e9                	mov    %ebp,%ecx
f0107603:	d3 e7                	shl    %cl,%edi
f0107605:	89 d1                	mov    %edx,%ecx
f0107607:	d3 e8                	shr    %cl,%eax
f0107609:	89 e9                	mov    %ebp,%ecx
f010760b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010760f:	d3 e3                	shl    %cl,%ebx
f0107611:	89 c7                	mov    %eax,%edi
f0107613:	89 d1                	mov    %edx,%ecx
f0107615:	89 f0                	mov    %esi,%eax
f0107617:	d3 e8                	shr    %cl,%eax
f0107619:	89 e9                	mov    %ebp,%ecx
f010761b:	89 fa                	mov    %edi,%edx
f010761d:	d3 e6                	shl    %cl,%esi
f010761f:	09 d8                	or     %ebx,%eax
f0107621:	f7 74 24 08          	divl   0x8(%esp)
f0107625:	89 d1                	mov    %edx,%ecx
f0107627:	89 f3                	mov    %esi,%ebx
f0107629:	f7 64 24 0c          	mull   0xc(%esp)
f010762d:	89 c6                	mov    %eax,%esi
f010762f:	89 d7                	mov    %edx,%edi
f0107631:	39 d1                	cmp    %edx,%ecx
f0107633:	72 06                	jb     f010763b <__umoddi3+0xfb>
f0107635:	75 10                	jne    f0107647 <__umoddi3+0x107>
f0107637:	39 c3                	cmp    %eax,%ebx
f0107639:	73 0c                	jae    f0107647 <__umoddi3+0x107>
f010763b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010763f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0107643:	89 d7                	mov    %edx,%edi
f0107645:	89 c6                	mov    %eax,%esi
f0107647:	89 ca                	mov    %ecx,%edx
f0107649:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010764e:	29 f3                	sub    %esi,%ebx
f0107650:	19 fa                	sbb    %edi,%edx
f0107652:	89 d0                	mov    %edx,%eax
f0107654:	d3 e0                	shl    %cl,%eax
f0107656:	89 e9                	mov    %ebp,%ecx
f0107658:	d3 eb                	shr    %cl,%ebx
f010765a:	d3 ea                	shr    %cl,%edx
f010765c:	09 d8                	or     %ebx,%eax
f010765e:	83 c4 1c             	add    $0x1c,%esp
f0107661:	5b                   	pop    %ebx
f0107662:	5e                   	pop    %esi
f0107663:	5f                   	pop    %edi
f0107664:	5d                   	pop    %ebp
f0107665:	c3                   	ret    
f0107666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010766d:	8d 76 00             	lea    0x0(%esi),%esi
f0107670:	89 da                	mov    %ebx,%edx
f0107672:	29 fe                	sub    %edi,%esi
f0107674:	19 c2                	sbb    %eax,%edx
f0107676:	89 f1                	mov    %esi,%ecx
f0107678:	89 c8                	mov    %ecx,%eax
f010767a:	e9 4b ff ff ff       	jmp    f01075ca <__umoddi3+0x8a>
