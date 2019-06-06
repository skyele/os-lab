
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
f010005f:	e8 ed 0b 00 00       	call   f0100c51 <monitor>
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
f0100074:	e8 61 6b 00 00       	call   f0106bda <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 20 7c 10 f0       	push   $0xf0107c20
f0100085:	e8 37 3e 00 00       	call   f0103ec1 <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 07 3e 00 00       	call   f0103e9b <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 1b 91 10 f0 	movl   $0xf010911b,(%esp)
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
f01000b6:	68 44 7c 10 f0       	push   $0xf0107c44
f01000bb:	e8 01 3e 00 00       	call   f0103ec1 <cprintf>
	cprintf("%n", NULL);
f01000c0:	83 c4 08             	add    $0x8,%esp
f01000c3:	6a 00                	push   $0x0
f01000c5:	68 bc 7c 10 f0       	push   $0xf0107cbc
f01000ca:	e8 f2 3d 00 00       	call   f0103ec1 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000cf:	83 c4 0c             	add    $0xc,%esp
f01000d2:	68 00 fc ff ff       	push   $0xfffffc00
f01000d7:	68 00 04 00 00       	push   $0x400
f01000dc:	68 bf 7c 10 f0       	push   $0xf0107cbf
f01000e1:	e8 db 3d 00 00       	call   f0103ec1 <cprintf>
	mem_init();
f01000e6:	e8 57 16 00 00       	call   f0101742 <mem_init>
	env_init();
f01000eb:	e8 47 35 00 00       	call   f0103637 <env_init>
	trap_init();
f01000f0:	e8 b0 3e 00 00       	call   f0103fa5 <trap_init>
	mp_init();
f01000f5:	e8 e9 67 00 00       	call   f01068e3 <mp_init>
	lapic_init();
f01000fa:	e8 f1 6a 00 00       	call   f0106bf0 <lapic_init>
	pic_init();
f01000ff:	e8 c2 3c 00 00       	call   f0103dc6 <pic_init>
	time_init();
f0100104:	e8 67 78 00 00       	call   f0107970 <time_init>
	pci_init();
f0100109:	e8 42 78 00 00       	call   f0107950 <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010010e:	c7 04 24 c0 83 12 f0 	movl   $0xf01283c0,(%esp)
f0100115:	e8 30 6d 00 00       	call   f0106e4a <spin_lock>
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
f0100129:	b8 46 68 10 f0       	mov    $0xf0106846,%eax
f010012e:	2d c4 67 10 f0       	sub    $0xf01067c4,%eax
f0100133:	50                   	push   %eax
f0100134:	68 c4 67 10 f0       	push   $0xf01067c4
f0100139:	68 00 70 00 f0       	push   $0xf0007000
f010013e:	e8 d8 64 00 00       	call   f010661b <memmove>
f0100143:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100146:	bb 20 10 58 f0       	mov    $0xf0581020,%ebx
f010014b:	eb 19                	jmp    f0100166 <i386_init+0xc1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010014d:	68 00 70 00 00       	push   $0x7000
f0100152:	68 74 7c 10 f0       	push   $0xf0107c74
f0100157:	6a 66                	push   $0x66
f0100159:	68 db 7c 10 f0       	push   $0xf0107cdb
f010015e:	e8 e6 fe ff ff       	call   f0100049 <_panic>
f0100163:	83 c3 74             	add    $0x74,%ebx
f0100166:	6b 05 c4 13 58 f0 74 	imul   $0x74,0xf05813c4,%eax
f010016d:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0100172:	39 c3                	cmp    %eax,%ebx
f0100174:	73 4d                	jae    f01001c3 <i386_init+0x11e>
		if (c == cpus + cpunum())  // We've started already.
f0100176:	e8 5f 6a 00 00       	call   f0106bda <cpunum>
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
f01001b1:	e8 8c 6b 00 00       	call   f0106d42 <lapic_startap>
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
f01001d7:	68 8c 38 47 f0       	push   $0xf047388c
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
f01001f1:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0100205:	e8 d0 69 00 00       	call   f0106bda <cpunum>
f010020a:	83 ec 08             	sub    $0x8,%esp
f010020d:	50                   	push   %eax
f010020e:	68 e7 7c 10 f0       	push   $0xf0107ce7
f0100213:	e8 a9 3c 00 00       	call   f0103ec1 <cprintf>
	lapic_init();
f0100218:	e8 d3 69 00 00       	call   f0106bf0 <lapic_init>
	env_init_percpu();
f010021d:	e8 e9 33 00 00       	call   f010360b <env_init_percpu>
	trap_init_percpu();
f0100222:	e8 ae 3c 00 00       	call   f0103ed5 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100227:	e8 ae 69 00 00       	call   f0106bda <cpunum>
f010022c:	6b d0 74             	imul   $0x74,%eax,%edx
f010022f:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100232:	b8 01 00 00 00       	mov    $0x1,%eax
f0100237:	f0 87 82 20 10 58 f0 	lock xchg %eax,-0xfa7efe0(%edx)
f010023e:	c7 04 24 c0 83 12 f0 	movl   $0xf01283c0,(%esp)
f0100245:	e8 00 6c 00 00       	call   f0106e4a <spin_lock>
	sched_yield();
f010024a:	e8 1f 4c 00 00       	call   f0104e6e <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010024f:	50                   	push   %eax
f0100250:	68 98 7c 10 f0       	push   $0xf0107c98
f0100255:	6a 7e                	push   $0x7e
f0100257:	68 db 7c 10 f0       	push   $0xf0107cdb
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
f0100271:	68 fd 7c 10 f0       	push   $0xf0107cfd
f0100276:	e8 46 3c 00 00       	call   f0103ec1 <cprintf>
	vcprintf(fmt, ap);
f010027b:	83 c4 08             	add    $0x8,%esp
f010027e:	53                   	push   %ebx
f010027f:	ff 75 10             	pushl  0x10(%ebp)
f0100282:	e8 14 3c 00 00       	call   f0103e9b <vcprintf>
	cprintf("\n");
f0100287:	c7 04 24 1b 91 10 f0 	movl   $0xf010911b,(%esp)
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
f01002c9:	8b 0d 24 f2 57 f0    	mov    0xf057f224,%ecx
f01002cf:	8d 51 01             	lea    0x1(%ecx),%edx
f01002d2:	88 81 20 f0 57 f0    	mov    %al,-0xfa80fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002d8:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002de:	b8 00 00 00 00       	mov    $0x0,%eax
f01002e3:	0f 44 d0             	cmove  %eax,%edx
f01002e6:	89 15 24 f2 57 f0    	mov    %edx,0xf057f224
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
f0100321:	8b 0d 00 f0 57 f0    	mov    0xf057f000,%ecx
f0100327:	f6 c1 40             	test   $0x40,%cl
f010032a:	74 0e                	je     f010033a <kbd_proc_data+0x46>
		data |= 0x80;
f010032c:	83 c8 80             	or     $0xffffff80,%eax
f010032f:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100331:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100334:	89 0d 00 f0 57 f0    	mov    %ecx,0xf057f000
	shift |= shiftcode[data];
f010033a:	0f b6 d2             	movzbl %dl,%edx
f010033d:	0f b6 82 60 7e 10 f0 	movzbl -0xfef81a0(%edx),%eax
f0100344:	0b 05 00 f0 57 f0    	or     0xf057f000,%eax
	shift ^= togglecode[data];
f010034a:	0f b6 8a 60 7d 10 f0 	movzbl -0xfef82a0(%edx),%ecx
f0100351:	31 c8                	xor    %ecx,%eax
f0100353:	a3 00 f0 57 f0       	mov    %eax,0xf057f000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100358:	89 c1                	mov    %eax,%ecx
f010035a:	83 e1 03             	and    $0x3,%ecx
f010035d:	8b 0c 8d 40 7d 10 f0 	mov    -0xfef82c0(,%ecx,4),%ecx
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
f010037e:	83 0d 00 f0 57 f0 40 	orl    $0x40,0xf057f000
		return 0;
f0100385:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010038a:	89 d8                	mov    %ebx,%eax
f010038c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010038f:	c9                   	leave  
f0100390:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100391:	8b 0d 00 f0 57 f0    	mov    0xf057f000,%ecx
f0100397:	89 cb                	mov    %ecx,%ebx
f0100399:	83 e3 40             	and    $0x40,%ebx
f010039c:	83 e0 7f             	and    $0x7f,%eax
f010039f:	85 db                	test   %ebx,%ebx
f01003a1:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003a4:	0f b6 d2             	movzbl %dl,%edx
f01003a7:	0f b6 82 60 7e 10 f0 	movzbl -0xfef81a0(%edx),%eax
f01003ae:	83 c8 40             	or     $0x40,%eax
f01003b1:	0f b6 c0             	movzbl %al,%eax
f01003b4:	f7 d0                	not    %eax
f01003b6:	21 c8                	and    %ecx,%eax
f01003b8:	a3 00 f0 57 f0       	mov    %eax,0xf057f000
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
f01003e1:	68 17 7d 10 f0       	push   $0xf0107d17
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
f01004be:	0f b7 05 28 f2 57 f0 	movzwl 0xf057f228,%eax
f01004c5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004cb:	c1 e8 16             	shr    $0x16,%eax
f01004ce:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004d1:	c1 e0 04             	shl    $0x4,%eax
f01004d4:	66 a3 28 f2 57 f0    	mov    %ax,0xf057f228
	if (crt_pos >= CRT_SIZE) {
f01004da:	66 81 3d 28 f2 57 f0 	cmpw   $0x7cf,0xf057f228
f01004e1:	cf 07 
f01004e3:	0f 87 cb 00 00 00    	ja     f01005b4 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004e9:	8b 0d 30 f2 57 f0    	mov    0xf057f230,%ecx
f01004ef:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004f4:	89 ca                	mov    %ecx,%edx
f01004f6:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004f7:	0f b7 1d 28 f2 57 f0 	movzwl 0xf057f228,%ebx
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
f0100524:	0f b7 05 28 f2 57 f0 	movzwl 0xf057f228,%eax
f010052b:	66 85 c0             	test   %ax,%ax
f010052e:	74 b9                	je     f01004e9 <cons_putc+0xe0>
			crt_pos--;
f0100530:	83 e8 01             	sub    $0x1,%eax
f0100533:	66 a3 28 f2 57 f0    	mov    %ax,0xf057f228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100539:	0f b7 c0             	movzwl %ax,%eax
f010053c:	b1 00                	mov    $0x0,%cl
f010053e:	83 c9 20             	or     $0x20,%ecx
f0100541:	8b 15 2c f2 57 f0    	mov    0xf057f22c,%edx
f0100547:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010054b:	eb 8d                	jmp    f01004da <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f010054d:	66 83 05 28 f2 57 f0 	addw   $0x50,0xf057f228
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
f0100591:	0f b7 05 28 f2 57 f0 	movzwl 0xf057f228,%eax
f0100598:	8d 50 01             	lea    0x1(%eax),%edx
f010059b:	66 89 15 28 f2 57 f0 	mov    %dx,0xf057f228
f01005a2:	0f b7 c0             	movzwl %ax,%eax
f01005a5:	8b 15 2c f2 57 f0    	mov    0xf057f22c,%edx
f01005ab:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005af:	e9 26 ff ff ff       	jmp    f01004da <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005b4:	a1 2c f2 57 f0       	mov    0xf057f22c,%eax
f01005b9:	83 ec 04             	sub    $0x4,%esp
f01005bc:	68 00 0f 00 00       	push   $0xf00
f01005c1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005c7:	52                   	push   %edx
f01005c8:	50                   	push   %eax
f01005c9:	e8 4d 60 00 00       	call   f010661b <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005ce:	8b 15 2c f2 57 f0    	mov    0xf057f22c,%edx
f01005d4:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005da:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005e0:	83 c4 10             	add    $0x10,%esp
f01005e3:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e8:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005eb:	39 d0                	cmp    %edx,%eax
f01005ed:	75 f4                	jne    f01005e3 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005ef:	66 83 2d 28 f2 57 f0 	subw   $0x50,0xf057f228
f01005f6:	50 
f01005f7:	e9 ed fe ff ff       	jmp    f01004e9 <cons_putc+0xe0>

f01005fc <serial_intr>:
	if (serial_exists)
f01005fc:	80 3d 34 f2 57 f0 00 	cmpb   $0x0,0xf057f234
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
f010063a:	8b 15 20 f2 57 f0    	mov    0xf057f220,%edx
	return 0;
f0100640:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100645:	3b 15 24 f2 57 f0    	cmp    0xf057f224,%edx
f010064b:	74 1e                	je     f010066b <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010064d:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100650:	0f b6 82 20 f0 57 f0 	movzbl -0xfa80fe0(%edx),%eax
			cons.rpos = 0;
f0100657:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010065d:	ba 00 00 00 00       	mov    $0x0,%edx
f0100662:	0f 44 ca             	cmove  %edx,%ecx
f0100665:	89 0d 20 f2 57 f0    	mov    %ecx,0xf057f220
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
f0100697:	c7 05 30 f2 57 f0 b4 	movl   $0x3b4,0xf057f230
f010069e:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006a1:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006a6:	8b 3d 30 f2 57 f0    	mov    0xf057f230,%edi
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
f01006cd:	89 35 2c f2 57 f0    	mov    %esi,0xf057f22c
	pos |= inb(addr_6845 + 1);
f01006d3:	0f b6 c0             	movzbl %al,%eax
f01006d6:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006d8:	66 a3 28 f2 57 f0    	mov    %ax,0xf057f228
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
f010074e:	0f 95 05 34 f2 57 f0 	setne  0xf057f234
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
f0100766:	68 23 7d 10 f0       	push   $0xf0107d23
f010076b:	e8 51 37 00 00       	call   f0103ec1 <cprintf>
f0100770:	83 c4 10             	add    $0x10,%esp
}
f0100773:	eb 3c                	jmp    f01007b1 <cons_init+0x144>
		*cp = was;
f0100775:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010077c:	c7 05 30 f2 57 f0 d4 	movl   $0x3d4,0xf057f230
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
f01007a8:	80 3d 34 f2 57 f0 00 	cmpb   $0x0,0xf057f234
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
f01007ef:	ff b3 c4 83 10 f0    	pushl  -0xfef7c3c(%ebx)
f01007f5:	ff b3 c0 83 10 f0    	pushl  -0xfef7c40(%ebx)
f01007fb:	68 60 7f 10 f0       	push   $0xf0107f60
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
f0100820:	68 69 7f 10 f0       	push   $0xf0107f69
f0100825:	e8 97 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010082a:	83 c4 08             	add    $0x8,%esp
f010082d:	68 0c 00 10 00       	push   $0x10000c
f0100832:	68 cc 80 10 f0       	push   $0xf01080cc
f0100837:	e8 85 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010083c:	83 c4 0c             	add    $0xc,%esp
f010083f:	68 0c 00 10 00       	push   $0x10000c
f0100844:	68 0c 00 10 f0       	push   $0xf010000c
f0100849:	68 f4 80 10 f0       	push   $0xf01080f4
f010084e:	e8 6e 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100853:	83 c4 0c             	add    $0xc,%esp
f0100856:	68 0f 7c 10 00       	push   $0x107c0f
f010085b:	68 0f 7c 10 f0       	push   $0xf0107c0f
f0100860:	68 18 81 10 f0       	push   $0xf0108118
f0100865:	e8 57 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010086a:	83 c4 0c             	add    $0xc,%esp
f010086d:	68 00 f0 57 00       	push   $0x57f000
f0100872:	68 00 f0 57 f0       	push   $0xf057f000
f0100877:	68 3c 81 10 f0       	push   $0xf010813c
f010087c:	e8 40 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100881:	83 c4 0c             	add    $0xc,%esp
f0100884:	68 40 ea 75 00       	push   $0x75ea40
f0100889:	68 40 ea 75 f0       	push   $0xf075ea40
f010088e:	68 60 81 10 f0       	push   $0xf0108160
f0100893:	e8 29 36 00 00       	call   f0103ec1 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100898:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010089b:	b8 40 ea 75 f0       	mov    $0xf075ea40,%eax
f01008a0:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a5:	c1 f8 0a             	sar    $0xa,%eax
f01008a8:	50                   	push   %eax
f01008a9:	68 84 81 10 f0       	push   $0xf0108184
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
f01008d5:	68 82 7f 10 f0       	push   $0xf0107f82
f01008da:	e8 e2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f01008df:	83 c4 08             	add    $0x8,%esp
f01008e2:	ff 73 08             	pushl  0x8(%ebx)
f01008e5:	68 91 7f 10 f0       	push   $0xf0107f91
f01008ea:	e8 d2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f01008ef:	83 c4 08             	add    $0x8,%esp
f01008f2:	ff 73 0c             	pushl  0xc(%ebx)
f01008f5:	68 a0 7f 10 f0       	push   $0xf0107fa0
f01008fa:	e8 c2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f01008ff:	83 c4 08             	add    $0x8,%esp
f0100902:	ff 73 10             	pushl  0x10(%ebx)
f0100905:	68 af 7f 10 f0       	push   $0xf0107faf
f010090a:	e8 b2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f010090f:	83 c4 08             	add    $0x8,%esp
f0100912:	ff 73 14             	pushl  0x14(%ebx)
f0100915:	68 be 7f 10 f0       	push   $0xf0107fbe
f010091a:	e8 a2 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f010091f:	83 c4 08             	add    $0x8,%esp
f0100922:	ff 73 18             	pushl  0x18(%ebx)
f0100925:	68 cd 7f 10 f0       	push   $0xf0107fcd
f010092a:	e8 92 35 00 00       	call   f0103ec1 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f010092f:	ff 73 18             	pushl  0x18(%ebx)
f0100932:	ff 73 14             	pushl  0x14(%ebx)
f0100935:	ff 73 10             	pushl  0x10(%ebx)
f0100938:	ff 73 0c             	pushl  0xc(%ebx)
f010093b:	ff 73 08             	pushl  0x8(%ebx)
f010093e:	53                   	push   %ebx
f010093f:	ff 73 04             	pushl  0x4(%ebx)
f0100942:	68 b0 81 10 f0       	push   $0xf01081b0
f0100947:	e8 75 35 00 00       	call   f0103ec1 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f010094c:	83 c4 28             	add    $0x28,%esp
f010094f:	56                   	push   %esi
f0100950:	ff 73 04             	pushl  0x4(%ebx)
f0100953:	e8 14 50 00 00       	call   f010596c <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f0100958:	83 c4 08             	add    $0x8,%esp
f010095b:	8b 43 04             	mov    0x4(%ebx),%eax
f010095e:	2b 45 f0             	sub    -0x10(%ebp),%eax
f0100961:	50                   	push   %eax
f0100962:	ff 75 e8             	pushl  -0x18(%ebp)
f0100965:	ff 75 ec             	pushl  -0x14(%ebp)
f0100968:	ff 75 e4             	pushl  -0x1c(%ebp)
f010096b:	ff 75 e0             	pushl  -0x20(%ebp)
f010096e:	68 dc 7f 10 f0       	push   $0xf0107fdc
f0100973:	e8 49 35 00 00       	call   f0103ec1 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f0100978:	8b 1b                	mov    (%ebx),%ebx
f010097a:	83 c4 20             	add    $0x20,%esp
f010097d:	e9 45 ff ff ff       	jmp    f01008c7 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f0100982:	83 ec 0c             	sub    $0xc,%esp
f0100985:	68 f2 7f 10 f0       	push   $0xf0107ff2
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
f01009cf:	68 20 82 10 f0       	push   $0xf0108220
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
f01009ec:	68 a0 83 10 f0       	push   $0xf01083a0
f01009f1:	68 e4 81 10 f0       	push   $0xf01081e4
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
f0100a0a:	e8 da 5c 00 00       	call   f01066e9 <strtol>
f0100a0f:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f0100a11:	83 c4 0c             	add    $0xc,%esp
f0100a14:	6a 10                	push   $0x10
f0100a16:	56                   	push   %esi
f0100a17:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100a1a:	ff 70 08             	pushl  0x8(%eax)
f0100a1d:	e8 c7 5c 00 00       	call   f01066e9 <strtol>
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
f0100a3e:	68 48 82 10 f0       	push   $0xf0108248
f0100a43:	e8 79 34 00 00       	call   f0103ec1 <cprintf>
		return 0;
f0100a48:	83 c4 10             	add    $0x10,%esp
f0100a4b:	eb 8f                	jmp    f01009dc <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100a4d:	83 ec 04             	sub    $0x4,%esp
f0100a50:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100a56:	50                   	push   %eax
f0100a57:	53                   	push   %ebx
f0100a58:	68 05 80 10 f0       	push   $0xf0108005
f0100a5d:	e8 5f 34 00 00       	call   f0103ec1 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100a62:	8b 06                	mov    (%esi),%eax
f0100a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a69:	83 c4 0c             	add    $0xc,%esp
f0100a6c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100a72:	52                   	push   %edx
f0100a73:	50                   	push   %eax
f0100a74:	68 14 80 10 f0       	push   $0xf0108014
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
f0100aad:	68 23 80 10 f0       	push   $0xf0108023
f0100ab2:	e8 0a 34 00 00       	call   f0103ec1 <cprintf>
f0100ab7:	83 c4 20             	add    $0x20,%esp
f0100aba:	e9 dc 00 00 00       	jmp    f0100b9b <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100abf:	83 ec 04             	sub    $0x4,%esp
f0100ac2:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100ac8:	50                   	push   %eax
f0100ac9:	53                   	push   %ebx
f0100aca:	68 05 80 10 f0       	push   $0xf0108005
f0100acf:	e8 ed 33 00 00       	call   f0103ec1 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100ad4:	8b 07                	mov    (%edi),%eax
f0100ad6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100adb:	83 c4 0c             	add    $0xc,%esp
f0100ade:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100ae4:	52                   	push   %edx
f0100ae5:	50                   	push   %eax
f0100ae6:	68 14 80 10 f0       	push   $0xf0108014
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
f0100b1f:	68 23 80 10 f0       	push   $0xf0108023
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
f0100b5c:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0100bf4:	ff 14 b5 c8 83 10 f0 	call   *-0xfef7c38(,%esi,4)
f0100bfb:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100bfe:	83 c3 01             	add    $0x1,%ebx
f0100c01:	39 1d 00 83 12 f0    	cmp    %ebx,0xf0128300
f0100c07:	7e 1c                	jle    f0100c25 <mon_time+0x78>
f0100c09:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100c0c:	83 ec 08             	sub    $0x8,%esp
f0100c0f:	57                   	push   %edi
f0100c10:	ff 34 b5 c0 83 10 f0 	pushl  -0xfef7c40(,%esi,4)
f0100c17:	e8 1c 59 00 00       	call   f0106538 <strcmp>
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
f0100c30:	68 36 80 10 f0       	push   $0xf0108036
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
f0100c5a:	68 6c 82 10 f0       	push   $0xf010826c
f0100c5f:	e8 5d 32 00 00       	call   f0103ec1 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c64:	c7 04 24 90 82 10 f0 	movl   $0xf0108290,(%esp)
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
f0100c97:	68 4a 80 10 f0       	push   $0xf010804a
f0100c9c:	e8 f5 58 00 00       	call   f0106596 <strchr>
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
f0100cd4:	ff 34 85 c0 83 10 f0 	pushl  -0xfef7c40(,%eax,4)
f0100cdb:	ff 75 a8             	pushl  -0x58(%ebp)
f0100cde:	e8 55 58 00 00       	call   f0106538 <strcmp>
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
f0100cfc:	68 6c 80 10 f0       	push   $0xf010806c
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
f0100d2a:	68 4a 80 10 f0       	push   $0xf010804a
f0100d2f:	e8 62 58 00 00       	call   f0106596 <strchr>
f0100d34:	83 c4 10             	add    $0x10,%esp
f0100d37:	85 c0                	test   %eax,%eax
f0100d39:	0f 85 71 ff ff ff    	jne    f0100cb0 <monitor+0x5f>
			buf++;
f0100d3f:	83 c3 01             	add    $0x1,%ebx
f0100d42:	eb d8                	jmp    f0100d1c <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d44:	83 ec 08             	sub    $0x8,%esp
f0100d47:	6a 10                	push   $0x10
f0100d49:	68 4f 80 10 f0       	push   $0xf010804f
f0100d4e:	e8 6e 31 00 00       	call   f0103ec1 <cprintf>
f0100d53:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100d56:	83 ec 0c             	sub    $0xc,%esp
f0100d59:	68 46 80 10 f0       	push   $0xf0108046
f0100d5e:	e8 03 56 00 00       	call   f0106366 <readline>
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
f0100d8b:	ff 14 85 c8 83 10 f0 	call   *-0xfef7c38(,%eax,4)
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
f0100de3:	3b 0d a8 0e 58 f0    	cmp    0xf0580ea8,%ecx
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
f0100e17:	68 74 7c 10 f0       	push   $0xf0107c74
f0100e1c:	68 ad 03 00 00       	push   $0x3ad
f0100e21:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0100e38:	83 3d 38 f2 57 f0 00 	cmpl   $0x0,0xf057f238
f0100e3f:	74 40                	je     f0100e81 <boot_alloc+0x50>
	if(!n)
f0100e41:	85 c0                	test   %eax,%eax
f0100e43:	74 65                	je     f0100eaa <boot_alloc+0x79>
f0100e45:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100e47:	a1 38 f2 57 f0       	mov    0xf057f238,%eax
	if ((uint32_t)kva < KERNBASE)
f0100e4c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e51:	76 5e                	jbe    f0100eb1 <boot_alloc+0x80>
f0100e53:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100e5a:	c1 e9 0c             	shr    $0xc,%ecx
f0100e5d:	83 c1 01             	add    $0x1,%ecx
f0100e60:	3b 0d a8 0e 58 f0    	cmp    0xf0580ea8,%ecx
f0100e66:	77 5b                	ja     f0100ec3 <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100e68:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e6e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e74:	01 c2                	add    %eax,%edx
f0100e76:	89 15 38 f2 57 f0    	mov    %edx,0xf057f238
}
f0100e7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100e7f:	c9                   	leave  
f0100e80:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e81:	b9 40 ea 75 f0       	mov    $0xf075ea40,%ecx
f0100e86:	ba 3f fa 75 f0       	mov    $0xf075fa3f,%edx
f0100e8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100e91:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e97:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100e9d:	85 c9                	test   %ecx,%ecx
f0100e9f:	0f 44 d3             	cmove  %ebx,%edx
f0100ea2:	89 15 38 f2 57 f0    	mov    %edx,0xf057f238
f0100ea8:	eb 97                	jmp    f0100e41 <boot_alloc+0x10>
		return nextfree;
f0100eaa:	a1 38 f2 57 f0       	mov    0xf057f238,%eax
f0100eaf:	eb cb                	jmp    f0100e7c <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100eb1:	50                   	push   %eax
f0100eb2:	68 98 7c 10 f0       	push   $0xf0107c98
f0100eb7:	6a 72                	push   $0x72
f0100eb9:	68 05 8e 10 f0       	push   $0xf0108e05
f0100ebe:	e8 86 f1 ff ff       	call   f0100049 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100ec3:	83 ec 04             	sub    $0x4,%esp
f0100ec6:	68 fc 83 10 f0       	push   $0xf01083fc
f0100ecb:	6a 73                	push   $0x73
f0100ecd:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0100ee8:	83 3d 40 f2 57 f0 00 	cmpl   $0x0,0xf057f240
f0100eef:	74 0a                	je     f0100efb <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ef1:	be 00 04 00 00       	mov    $0x400,%esi
f0100ef6:	e9 bf 02 00 00       	jmp    f01011ba <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100efb:	83 ec 04             	sub    $0x4,%esp
f0100efe:	68 34 84 10 f0       	push   $0xf0108434
f0100f03:	68 dd 02 00 00       	push   $0x2dd
f0100f08:	68 05 8e 10 f0       	push   $0xf0108e05
f0100f0d:	e8 37 f1 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f12:	50                   	push   %eax
f0100f13:	68 74 7c 10 f0       	push   $0xf0107c74
f0100f18:	6a 58                	push   $0x58
f0100f1a:	68 11 8e 10 f0       	push   $0xf0108e11
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
f0100f2c:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0100f46:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0100f4c:	73 c4                	jae    f0100f12 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100f4e:	83 ec 04             	sub    $0x4,%esp
f0100f51:	68 80 00 00 00       	push   $0x80
f0100f56:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100f5b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f60:	50                   	push   %eax
f0100f61:	e8 6d 56 00 00       	call   f01065d3 <memset>
f0100f66:	83 c4 10             	add    $0x10,%esp
f0100f69:	eb b9                	jmp    f0100f24 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100f6b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f70:	e8 bc fe ff ff       	call   f0100e31 <boot_alloc>
f0100f75:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f78:	8b 15 40 f2 57 f0    	mov    0xf057f240,%edx
		assert(pp >= pages);
f0100f7e:	8b 0d b0 0e 58 f0    	mov    0xf0580eb0,%ecx
		assert(pp < pages + npages);
f0100f84:	a1 a8 0e 58 f0       	mov    0xf0580ea8,%eax
f0100f89:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f8c:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100f8f:	bf 00 00 00 00       	mov    $0x0,%edi
f0100f94:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f97:	e9 f9 00 00 00       	jmp    f0101095 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100f9c:	68 1f 8e 10 f0       	push   $0xf0108e1f
f0100fa1:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0100fa6:	68 f6 02 00 00       	push   $0x2f6
f0100fab:	68 05 8e 10 f0       	push   $0xf0108e05
f0100fb0:	e8 94 f0 ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0100fb5:	68 40 8e 10 f0       	push   $0xf0108e40
f0100fba:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0100fbf:	68 f7 02 00 00       	push   $0x2f7
f0100fc4:	68 05 8e 10 f0       	push   $0xf0108e05
f0100fc9:	e8 7b f0 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100fce:	68 58 84 10 f0       	push   $0xf0108458
f0100fd3:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0100fd8:	68 f8 02 00 00       	push   $0x2f8
f0100fdd:	68 05 8e 10 f0       	push   $0xf0108e05
f0100fe2:	e8 62 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0100fe7:	68 54 8e 10 f0       	push   $0xf0108e54
f0100fec:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0100ff1:	68 fb 02 00 00       	push   $0x2fb
f0100ff6:	68 05 8e 10 f0       	push   $0xf0108e05
f0100ffb:	e8 49 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101000:	68 65 8e 10 f0       	push   $0xf0108e65
f0101005:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010100a:	68 fc 02 00 00       	push   $0x2fc
f010100f:	68 05 8e 10 f0       	push   $0xf0108e05
f0101014:	e8 30 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101019:	68 8c 84 10 f0       	push   $0xf010848c
f010101e:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101023:	68 fd 02 00 00       	push   $0x2fd
f0101028:	68 05 8e 10 f0       	push   $0xf0108e05
f010102d:	e8 17 f0 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101032:	68 7e 8e 10 f0       	push   $0xf0108e7e
f0101037:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010103c:	68 fe 02 00 00       	push   $0x2fe
f0101041:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0101065:	68 74 7c 10 f0       	push   $0xf0107c74
f010106a:	6a 58                	push   $0x58
f010106c:	68 11 8e 10 f0       	push   $0xf0108e11
f0101071:	e8 d3 ef ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101076:	68 b0 84 10 f0       	push   $0xf01084b0
f010107b:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101080:	68 ff 02 00 00       	push   $0x2ff
f0101085:	68 05 8e 10 f0       	push   $0xf0108e05
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
f01010f4:	68 98 8e 10 f0       	push   $0xf0108e98
f01010f9:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01010fe:	68 01 03 00 00       	push   $0x301
f0101103:	68 05 8e 10 f0       	push   $0xf0108e05
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
f010111b:	68 f8 84 10 f0       	push   $0xf01084f8
f0101120:	e8 9c 2d 00 00       	call   f0103ec1 <cprintf>
}
f0101125:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101128:	5b                   	pop    %ebx
f0101129:	5e                   	pop    %esi
f010112a:	5f                   	pop    %edi
f010112b:	5d                   	pop    %ebp
f010112c:	c3                   	ret    
	assert(nfree_basemem > 0);
f010112d:	68 b5 8e 10 f0       	push   $0xf0108eb5
f0101132:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101137:	68 08 03 00 00       	push   $0x308
f010113c:	68 05 8e 10 f0       	push   $0xf0108e05
f0101141:	e8 03 ef ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f0101146:	68 c7 8e 10 f0       	push   $0xf0108ec7
f010114b:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101150:	68 09 03 00 00       	push   $0x309
f0101155:	68 05 8e 10 f0       	push   $0xf0108e05
f010115a:	e8 ea ee ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f010115f:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f0101164:	85 c0                	test   %eax,%eax
f0101166:	0f 84 8f fd ff ff    	je     f0100efb <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010116c:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010116f:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101172:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101175:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101178:	89 c2                	mov    %eax,%edx
f010117a:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f01011b0:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01011b5:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f01011ba:	8b 1d 40 f2 57 f0    	mov    0xf057f240,%ebx
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
f01011e9:	03 15 b0 0e 58 f0    	add    0xf0580eb0,%edx
f01011ef:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f01011f5:	8b 0d 40 f2 57 f0    	mov    0xf057f240,%ecx
f01011fb:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f01011fd:	03 05 b0 0e 58 f0    	add    0xf0580eb0,%eax
f0101203:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
f0101208:	eb 12                	jmp    f010121c <page_init+0x57>
			pages[i].pp_ref = 1;
f010120a:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
f010120f:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f0101215:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f010121c:	83 c3 01             	add    $0x1,%ebx
f010121f:	39 1d a8 0e 58 f0    	cmp    %ebx,0xf0580ea8
f0101225:	0f 86 94 00 00 00    	jbe    f01012bf <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f010122b:	85 db                	test   %ebx,%ebx
f010122d:	75 a4                	jne    f01011d3 <page_init+0xe>
			pages[i].pp_ref = 1;
f010122f:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
f0101234:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f010123a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101240:	eb da                	jmp    f010121c <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f0101242:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0101248:	77 16                	ja     f0101260 <page_init+0x9b>
			pages[i].pp_ref = 1;
f010124a:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
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
f0101286:	03 15 b0 0e 58 f0    	add    0xf0580eb0,%edx
f010128c:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101292:	8b 0d 40 f2 57 f0    	mov    0xf057f240,%ecx
f0101298:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f010129a:	03 05 b0 0e 58 f0    	add    0xf0580eb0,%eax
f01012a0:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
f01012a5:	e9 72 ff ff ff       	jmp    f010121c <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01012aa:	50                   	push   %eax
f01012ab:	68 98 7c 10 f0       	push   $0xf0107c98
f01012b0:	68 4d 01 00 00       	push   $0x14d
f01012b5:	68 05 8e 10 f0       	push   $0xf0108e05
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
f01012cb:	8b 1d 40 f2 57 f0    	mov    0xf057f240,%ebx
f01012d1:	85 db                	test   %ebx,%ebx
f01012d3:	74 13                	je     f01012e8 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f01012d5:	8b 03                	mov    (%ebx),%eax
f01012d7:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
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
f01012f1:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01012f7:	c1 f8 03             	sar    $0x3,%eax
f01012fa:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01012fd:	89 c2                	mov    %eax,%edx
f01012ff:	c1 ea 0c             	shr    $0xc,%edx
f0101302:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0101308:	73 1a                	jae    f0101324 <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f010130a:	83 ec 04             	sub    $0x4,%esp
f010130d:	68 00 10 00 00       	push   $0x1000
f0101312:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101314:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101319:	50                   	push   %eax
f010131a:	e8 b4 52 00 00       	call   f01065d3 <memset>
f010131f:	83 c4 10             	add    $0x10,%esp
f0101322:	eb c4                	jmp    f01012e8 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101324:	50                   	push   %eax
f0101325:	68 74 7c 10 f0       	push   $0xf0107c74
f010132a:	6a 58                	push   $0x58
f010132c:	68 11 8e 10 f0       	push   $0xf0108e11
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
f010134b:	8b 15 40 f2 57 f0    	mov    0xf057f240,%edx
f0101351:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101353:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
}
f0101358:	c9                   	leave  
f0101359:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f010135a:	83 ec 04             	sub    $0x4,%esp
f010135d:	68 1c 85 10 f0       	push   $0xf010851c
f0101362:	68 81 01 00 00       	push   $0x181
f0101367:	68 05 8e 10 f0       	push   $0xf0108e05
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
f01013c8:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
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
f01013ff:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
f0101405:	c1 fa 03             	sar    $0x3,%edx
f0101408:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f010140b:	83 ca 07             	or     $0x7,%edx
f010140e:	89 13                	mov    %edx,(%ebx)
f0101410:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0101416:	c1 f8 03             	sar    $0x3,%eax
f0101419:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010141c:	89 c2                	mov    %eax,%edx
f010141e:	c1 ea 0c             	shr    $0xc,%edx
f0101421:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0101427:	73 12                	jae    f010143b <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f0101429:	c1 ee 0a             	shr    $0xa,%esi
f010142c:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101432:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0101439:	eb a5                	jmp    f01013e0 <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010143b:	50                   	push   %eax
f010143c:	68 74 7c 10 f0       	push   $0xf0107c74
f0101441:	6a 58                	push   $0x58
f0101443:	68 11 8e 10 f0       	push   $0xf0108e11
f0101448:	e8 fc eb ff ff       	call   f0100049 <_panic>
f010144d:	50                   	push   %eax
f010144e:	68 74 7c 10 f0       	push   $0xf0107c74
f0101453:	68 bb 01 00 00       	push   $0x1bb
f0101458:	68 05 8e 10 f0       	push   $0xf0108e05
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
f01014cd:	68 d8 8e 10 f0       	push   $0xf0108ed8
f01014d2:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01014d7:	68 d0 01 00 00       	push   $0x1d0
f01014dc:	68 05 8e 10 f0       	push   $0xf0108e05
f01014e1:	e8 63 eb ff ff       	call   f0100049 <_panic>
	assert(pa%PGSIZE==0);
f01014e6:	68 e5 8e 10 f0       	push   $0xf0108ee5
f01014eb:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01014f0:	68 d1 01 00 00       	push   $0x1d1
f01014f5:	68 05 8e 10 f0       	push   $0xf0108e05
f01014fa:	e8 4a eb ff ff       	call   f0100049 <_panic>
			panic("%s error\n", __FUNCTION__);
f01014ff:	68 64 91 10 f0       	push   $0xf0109164
f0101504:	68 f2 8e 10 f0       	push   $0xf0108ef2
f0101509:	68 d5 01 00 00       	push   $0x1d5
f010150e:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0101554:	39 05 a8 0e 58 f0    	cmp    %eax,0xf0580ea8
f010155a:	76 0e                	jbe    f010156a <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010155c:	8b 15 b0 0e 58 f0    	mov    0xf0580eb0,%edx
f0101562:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101568:	c9                   	leave  
f0101569:	c3                   	ret    
		panic("pa2page called with invalid pa");
f010156a:	83 ec 04             	sub    $0x4,%esp
f010156d:	68 50 85 10 f0       	push   $0xf0108550
f0101572:	6a 51                	push   $0x51
f0101574:	68 11 8e 10 f0       	push   $0xf0108e11
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
f010158b:	e8 4a 56 00 00       	call   f0106bda <cpunum>
f0101590:	6b c0 74             	imul   $0x74,%eax,%eax
f0101593:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f010159a:	74 16                	je     f01015b2 <tlb_invalidate+0x2d>
f010159c:	e8 39 56 00 00       	call   f0106bda <cpunum>
f01015a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01015a4:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
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
f010162e:	8b 0d a8 0e 58 f0    	mov    0xf0580ea8,%ecx
f0101634:	89 d0                	mov    %edx,%eax
f0101636:	c1 e8 0c             	shr    $0xc,%eax
f0101639:	39 c1                	cmp    %eax,%ecx
f010163b:	76 5f                	jbe    f010169c <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f010163d:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f0101643:	89 d8                	mov    %ebx,%eax
f0101645:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0101676:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f010169d:	68 74 7c 10 f0       	push   $0xf0107c74
f01016a2:	68 17 02 00 00       	push   $0x217
f01016a7:	68 05 8e 10 f0       	push   $0xf0108e05
f01016ac:	e8 98 e9 ff ff       	call   f0100049 <_panic>
f01016b1:	50                   	push   %eax
f01016b2:	68 74 7c 10 f0       	push   $0xf0107c74
f01016b7:	6a 58                	push   $0x58
f01016b9:	68 11 8e 10 f0       	push   $0xf0108e11
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
f0101712:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f010172e:	68 fc 8e 10 f0       	push   $0xf0108efc
f0101733:	68 88 02 00 00       	push   $0x288
f0101738:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0101780:	89 15 a8 0e 58 f0    	mov    %edx,0xf0580ea8
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101786:	89 c2                	mov    %eax,%edx
f0101788:	29 da                	sub    %ebx,%edx
f010178a:	52                   	push   %edx
f010178b:	53                   	push   %ebx
f010178c:	50                   	push   %eax
f010178d:	68 70 85 10 f0       	push   $0xf0108570
f0101792:	e8 2a 27 00 00       	call   f0103ec1 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101797:	b8 00 10 00 00       	mov    $0x1000,%eax
f010179c:	e8 90 f6 ff ff       	call   f0100e31 <boot_alloc>
f01017a1:	a3 ac 0e 58 f0       	mov    %eax,0xf0580eac
	memset(kern_pgdir, 0, PGSIZE);
f01017a6:	83 c4 0c             	add    $0xc,%esp
f01017a9:	68 00 10 00 00       	push   $0x1000
f01017ae:	6a 00                	push   $0x0
f01017b0:	50                   	push   %eax
f01017b1:	e8 1d 4e 00 00       	call   f01065d3 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01017b6:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
	if ((uint32_t)kva < KERNBASE)
f01017bb:	83 c4 10             	add    $0x10,%esp
f01017be:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017c3:	0f 86 a2 00 00 00    	jbe    f010186b <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f01017c9:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017cf:	83 ca 05             	or     $0x5,%edx
f01017d2:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f01017d8:	a1 a8 0e 58 f0       	mov    0xf0580ea8,%eax
f01017dd:	c1 e0 03             	shl    $0x3,%eax
f01017e0:	e8 4c f6 ff ff       	call   f0100e31 <boot_alloc>
f01017e5:	a3 b0 0e 58 f0       	mov    %eax,0xf0580eb0
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01017ea:	83 ec 04             	sub    $0x4,%esp
f01017ed:	8b 15 a8 0e 58 f0    	mov    0xf0580ea8,%edx
f01017f3:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f01017fa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101800:	52                   	push   %edx
f0101801:	6a 00                	push   $0x0
f0101803:	50                   	push   %eax
f0101804:	e8 ca 4d 00 00       	call   f01065d3 <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101809:	b8 00 00 02 00       	mov    $0x20000,%eax
f010180e:	e8 1e f6 ff ff       	call   f0100e31 <boot_alloc>
f0101813:	a3 44 f2 57 f0       	mov    %eax,0xf057f244
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f0101818:	83 c4 0c             	add    $0xc,%esp
f010181b:	68 00 00 02 00       	push   $0x20000
f0101820:	6a 00                	push   $0x0
f0101822:	50                   	push   %eax
f0101823:	e8 ab 4d 00 00       	call   f01065d3 <memset>
	page_init();
f0101828:	e8 98 f9 ff ff       	call   f01011c5 <page_init>
	check_page_free_list(1);
f010182d:	b8 01 00 00 00       	mov    $0x1,%eax
f0101832:	e8 a0 f6 ff ff       	call   f0100ed7 <check_page_free_list>
	if (!pages)
f0101837:	83 c4 10             	add    $0x10,%esp
f010183a:	83 3d b0 0e 58 f0 00 	cmpl   $0x0,0xf0580eb0
f0101841:	74 3d                	je     f0101880 <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101843:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
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
f010186c:	68 98 7c 10 f0       	push   $0xf0107c98
f0101871:	68 9a 00 00 00       	push   $0x9a
f0101876:	68 05 8e 10 f0       	push   $0xf0108e05
f010187b:	e8 c9 e7 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f0101880:	83 ec 04             	sub    $0x4,%esp
f0101883:	68 0e 8f 10 f0       	push   $0xf0108f0e
f0101888:	68 1c 03 00 00       	push   $0x31c
f010188d:	68 05 8e 10 f0       	push   $0xf0108e05
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
f01018f4:	8b 0d b0 0e 58 f0    	mov    0xf0580eb0,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01018fa:	8b 15 a8 0e 58 f0    	mov    0xf0580ea8,%edx
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
f0101939:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f010193e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101941:	c7 05 40 f2 57 f0 00 	movl   $0x0,0xf057f240
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
f01019ef:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01019f5:	c1 f8 03             	sar    $0x3,%eax
f01019f8:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01019fb:	89 c2                	mov    %eax,%edx
f01019fd:	c1 ea 0c             	shr    $0xc,%edx
f0101a00:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0101a06:	0f 83 19 02 00 00    	jae    f0101c25 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f0101a0c:	83 ec 04             	sub    $0x4,%esp
f0101a0f:	68 00 10 00 00       	push   $0x1000
f0101a14:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101a16:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a1b:	50                   	push   %eax
f0101a1c:	e8 b2 4b 00 00       	call   f01065d3 <memset>
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
f0101a48:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0101a4e:	c1 f8 03             	sar    $0x3,%eax
f0101a51:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a54:	89 c2                	mov    %eax,%edx
f0101a56:	c1 ea 0c             	shr    $0xc,%edx
f0101a59:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
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
f0101a83:	a3 40 f2 57 f0       	mov    %eax,0xf057f240
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
f0101aa1:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f0101aa6:	83 c4 10             	add    $0x10,%esp
f0101aa9:	e9 ec 01 00 00       	jmp    f0101c9a <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101aae:	68 29 8f 10 f0       	push   $0xf0108f29
f0101ab3:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101ab8:	68 24 03 00 00       	push   $0x324
f0101abd:	68 05 8e 10 f0       	push   $0xf0108e05
f0101ac2:	e8 82 e5 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ac7:	68 3f 8f 10 f0       	push   $0xf0108f3f
f0101acc:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101ad1:	68 25 03 00 00       	push   $0x325
f0101ad6:	68 05 8e 10 f0       	push   $0xf0108e05
f0101adb:	e8 69 e5 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101ae0:	68 55 8f 10 f0       	push   $0xf0108f55
f0101ae5:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101aea:	68 26 03 00 00       	push   $0x326
f0101aef:	68 05 8e 10 f0       	push   $0xf0108e05
f0101af4:	e8 50 e5 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101af9:	68 6b 8f 10 f0       	push   $0xf0108f6b
f0101afe:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101b03:	68 29 03 00 00       	push   $0x329
f0101b08:	68 05 8e 10 f0       	push   $0xf0108e05
f0101b0d:	e8 37 e5 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b12:	68 ac 85 10 f0       	push   $0xf01085ac
f0101b17:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101b1c:	68 2a 03 00 00       	push   $0x32a
f0101b21:	68 05 8e 10 f0       	push   $0xf0108e05
f0101b26:	e8 1e e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b2b:	68 7d 8f 10 f0       	push   $0xf0108f7d
f0101b30:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101b35:	68 2b 03 00 00       	push   $0x32b
f0101b3a:	68 05 8e 10 f0       	push   $0xf0108e05
f0101b3f:	e8 05 e5 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b44:	68 9a 8f 10 f0       	push   $0xf0108f9a
f0101b49:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101b4e:	68 2c 03 00 00       	push   $0x32c
f0101b53:	68 05 8e 10 f0       	push   $0xf0108e05
f0101b58:	e8 ec e4 ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b5d:	68 b7 8f 10 f0       	push   $0xf0108fb7
f0101b62:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101b67:	68 2d 03 00 00       	push   $0x32d
f0101b6c:	68 05 8e 10 f0       	push   $0xf0108e05
f0101b71:	e8 d3 e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101b76:	68 d4 8f 10 f0       	push   $0xf0108fd4
f0101b7b:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101b80:	68 34 03 00 00       	push   $0x334
f0101b85:	68 05 8e 10 f0       	push   $0xf0108e05
f0101b8a:	e8 ba e4 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101b8f:	68 29 8f 10 f0       	push   $0xf0108f29
f0101b94:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101b99:	68 3b 03 00 00       	push   $0x33b
f0101b9e:	68 05 8e 10 f0       	push   $0xf0108e05
f0101ba3:	e8 a1 e4 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ba8:	68 3f 8f 10 f0       	push   $0xf0108f3f
f0101bad:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101bb2:	68 3c 03 00 00       	push   $0x33c
f0101bb7:	68 05 8e 10 f0       	push   $0xf0108e05
f0101bbc:	e8 88 e4 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0101bc1:	68 55 8f 10 f0       	push   $0xf0108f55
f0101bc6:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101bcb:	68 3d 03 00 00       	push   $0x33d
f0101bd0:	68 05 8e 10 f0       	push   $0xf0108e05
f0101bd5:	e8 6f e4 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0101bda:	68 6b 8f 10 f0       	push   $0xf0108f6b
f0101bdf:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101be4:	68 3f 03 00 00       	push   $0x33f
f0101be9:	68 05 8e 10 f0       	push   $0xf0108e05
f0101bee:	e8 56 e4 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101bf3:	68 ac 85 10 f0       	push   $0xf01085ac
f0101bf8:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101bfd:	68 40 03 00 00       	push   $0x340
f0101c02:	68 05 8e 10 f0       	push   $0xf0108e05
f0101c07:	e8 3d e4 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0101c0c:	68 d4 8f 10 f0       	push   $0xf0108fd4
f0101c11:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101c16:	68 41 03 00 00       	push   $0x341
f0101c1b:	68 05 8e 10 f0       	push   $0xf0108e05
f0101c20:	e8 24 e4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c25:	50                   	push   %eax
f0101c26:	68 74 7c 10 f0       	push   $0xf0107c74
f0101c2b:	6a 58                	push   $0x58
f0101c2d:	68 11 8e 10 f0       	push   $0xf0108e11
f0101c32:	e8 12 e4 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101c37:	68 e3 8f 10 f0       	push   $0xf0108fe3
f0101c3c:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101c41:	68 46 03 00 00       	push   $0x346
f0101c46:	68 05 8e 10 f0       	push   $0xf0108e05
f0101c4b:	e8 f9 e3 ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f0101c50:	68 01 90 10 f0       	push   $0xf0109001
f0101c55:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101c5a:	68 47 03 00 00       	push   $0x347
f0101c5f:	68 05 8e 10 f0       	push   $0xf0108e05
f0101c64:	e8 e0 e3 ff ff       	call   f0100049 <_panic>
f0101c69:	50                   	push   %eax
f0101c6a:	68 74 7c 10 f0       	push   $0xf0107c74
f0101c6f:	6a 58                	push   $0x58
f0101c71:	68 11 8e 10 f0       	push   $0xf0108e11
f0101c76:	e8 ce e3 ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0101c7b:	68 11 90 10 f0       	push   $0xf0109011
f0101c80:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0101c85:	68 4a 03 00 00       	push   $0x34a
f0101c8a:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0101cab:	68 cc 85 10 f0       	push   $0xf01085cc
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
f0101d17:	a1 40 f2 57 f0       	mov    0xf057f240,%eax
f0101d1c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101d1f:	c7 05 40 f2 57 f0 00 	movl   $0x0,0xf057f240
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
f0101d47:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101d4d:	e8 ce f7 ff ff       	call   f0101520 <page_lookup>
f0101d52:	83 c4 10             	add    $0x10,%esp
f0101d55:	85 c0                	test   %eax,%eax
f0101d57:	0f 85 5f 09 00 00    	jne    f01026bc <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101d5d:	6a 02                	push   $0x2
f0101d5f:	6a 00                	push   $0x0
f0101d61:	57                   	push   %edi
f0101d62:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f0101d88:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101d8e:	e8 6d f8 ff ff       	call   f0101600 <page_insert>
f0101d93:	83 c4 20             	add    $0x20,%esp
f0101d96:	85 c0                	test   %eax,%eax
f0101d98:	0f 85 50 09 00 00    	jne    f01026ee <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d9e:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
	return (pp - pages) << PGSHIFT;
f0101da4:	8b 0d b0 0e 58 f0    	mov    0xf0580eb0,%ecx
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
f0101e1e:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0101e23:	e8 a5 ef ff ff       	call   f0100dcd <check_va2pa>
f0101e28:	89 da                	mov    %ebx,%edx
f0101e2a:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0101e66:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101e6c:	e8 8f f7 ff ff       	call   f0101600 <page_insert>
f0101e71:	83 c4 10             	add    $0x10,%esp
f0101e74:	85 c0                	test   %eax,%eax
f0101e76:	0f 85 53 09 00 00    	jne    f01027cf <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e7c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e81:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0101e86:	e8 42 ef ff ff       	call   f0100dcd <check_va2pa>
f0101e8b:	89 da                	mov    %ebx,%edx
f0101e8d:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0101ec1:	8b 15 ac 0e 58 f0    	mov    0xf0580eac,%edx
f0101ec7:	8b 02                	mov    (%edx),%eax
f0101ec9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101ece:	89 c1                	mov    %eax,%ecx
f0101ed0:	c1 e9 0c             	shr    $0xc,%ecx
f0101ed3:	3b 0d a8 0e 58 f0    	cmp    0xf0580ea8,%ecx
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
f0101f10:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101f16:	e8 e5 f6 ff ff       	call   f0101600 <page_insert>
f0101f1b:	83 c4 10             	add    $0x10,%esp
f0101f1e:	85 c0                	test   %eax,%eax
f0101f20:	0f 85 3b 09 00 00    	jne    f0102861 <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f26:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
f0101f2c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f31:	89 f0                	mov    %esi,%eax
f0101f33:	e8 95 ee ff ff       	call   f0100dcd <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101f38:	89 da                	mov    %ebx,%edx
f0101f3a:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0101f75:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0101fa6:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101fac:	e8 e9 f3 ff ff       	call   f010139a <pgdir_walk>
f0101fb1:	83 c4 10             	add    $0x10,%esp
f0101fb4:	f6 00 02             	testb  $0x2,(%eax)
f0101fb7:	0f 84 3a 09 00 00    	je     f01028f7 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101fbd:	83 ec 04             	sub    $0x4,%esp
f0101fc0:	6a 00                	push   $0x0
f0101fc2:	68 00 10 00 00       	push   $0x1000
f0101fc7:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101fcd:	e8 c8 f3 ff ff       	call   f010139a <pgdir_walk>
f0101fd2:	83 c4 10             	add    $0x10,%esp
f0101fd5:	f6 00 04             	testb  $0x4,(%eax)
f0101fd8:	0f 85 32 09 00 00    	jne    f0102910 <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101fde:	6a 02                	push   $0x2
f0101fe0:	68 00 00 40 00       	push   $0x400000
f0101fe5:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101fe8:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0101fee:	e8 0d f6 ff ff       	call   f0101600 <page_insert>
f0101ff3:	83 c4 10             	add    $0x10,%esp
f0101ff6:	85 c0                	test   %eax,%eax
f0101ff8:	0f 89 2b 09 00 00    	jns    f0102929 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101ffe:	6a 02                	push   $0x2
f0102000:	68 00 10 00 00       	push   $0x1000
f0102005:	57                   	push   %edi
f0102006:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010200c:	e8 ef f5 ff ff       	call   f0101600 <page_insert>
f0102011:	83 c4 10             	add    $0x10,%esp
f0102014:	85 c0                	test   %eax,%eax
f0102016:	0f 85 26 09 00 00    	jne    f0102942 <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010201c:	83 ec 04             	sub    $0x4,%esp
f010201f:	6a 00                	push   $0x0
f0102021:	68 00 10 00 00       	push   $0x1000
f0102026:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010202c:	e8 69 f3 ff ff       	call   f010139a <pgdir_walk>
f0102031:	83 c4 10             	add    $0x10,%esp
f0102034:	f6 00 04             	testb  $0x4,(%eax)
f0102037:	0f 85 1e 09 00 00    	jne    f010295b <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010203d:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102042:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102045:	ba 00 00 00 00       	mov    $0x0,%edx
f010204a:	e8 7e ed ff ff       	call   f0100dcd <check_va2pa>
f010204f:	89 fe                	mov    %edi,%esi
f0102051:	2b 35 b0 0e 58 f0    	sub    0xf0580eb0,%esi
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
f01020b2:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01020b8:	e8 fd f4 ff ff       	call   f01015ba <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01020bd:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
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
f01020e9:	2b 15 b0 0e 58 f0    	sub    0xf0580eb0,%edx
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
f0102148:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010214e:	e8 67 f4 ff ff       	call   f01015ba <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102153:	8b 35 ac 0e 58 f0    	mov    0xf0580eac,%esi
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
f01021ce:	8b 0d ac 0e 58 f0    	mov    0xf0580eac,%ecx
f01021d4:	8b 11                	mov    (%ecx),%edx
f01021d6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01021dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021df:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0102223:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0102229:	e8 6c f1 ff ff       	call   f010139a <pgdir_walk>
f010222e:	89 c1                	mov    %eax,%ecx
f0102230:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102233:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102238:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010223b:	8b 40 04             	mov    0x4(%eax),%eax
f010223e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102243:	8b 35 a8 0e 58 f0    	mov    0xf0580ea8,%esi
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
f0102279:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f01022a5:	e8 29 43 00 00       	call   f01065d3 <memset>
	page_free(pp0);
f01022aa:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01022ad:	89 34 24             	mov    %esi,(%esp)
f01022b0:	e8 81 f0 ff ff       	call   f0101336 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01022b5:	83 c4 0c             	add    $0xc,%esp
f01022b8:	6a 01                	push   $0x1
f01022ba:	6a 00                	push   $0x0
f01022bc:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01022c2:	e8 d3 f0 ff ff       	call   f010139a <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01022c7:	89 f0                	mov    %esi,%eax
f01022c9:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01022cf:	c1 f8 03             	sar    $0x3,%eax
f01022d2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022d5:	89 c2                	mov    %eax,%edx
f01022d7:	c1 ea 0c             	shr    $0xc,%edx
f01022da:	83 c4 10             	add    $0x10,%esp
f01022dd:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
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
f0102307:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f010230c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102315:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f010231b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010231e:	89 0d 40 f2 57 f0    	mov    %ecx,0xf057f240

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
f01023b5:	8b 3d ac 0e 58 f0    	mov    0xf0580eac,%edi
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
f010242e:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f010244f:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0102455:	e8 40 ef ff ff       	call   f010139a <pgdir_walk>
f010245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102460:	83 c4 0c             	add    $0xc,%esp
f0102463:	6a 00                	push   $0x0
f0102465:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102468:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f010246e:	e8 27 ef ff ff       	call   f010139a <pgdir_walk>
f0102473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102479:	83 c4 0c             	add    $0xc,%esp
f010247c:	6a 00                	push   $0x0
f010247e:	56                   	push   %esi
f010247f:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f0102485:	e8 10 ef ff ff       	call   f010139a <pgdir_walk>
f010248a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102490:	c7 04 24 04 91 10 f0 	movl   $0xf0109104,(%esp)
f0102497:	e8 25 1a 00 00       	call   f0103ec1 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010249c:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
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
f01024c4:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f01024c9:	e8 9e ef ff ff       	call   f010146c <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01024ce:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
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
f01024f6:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0102527:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f010252c:	e8 3b ef ff ff       	call   f010146c <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f0102531:	83 c4 08             	add    $0x8,%esp
f0102534:	6a 02                	push   $0x2
f0102536:	6a 00                	push   $0x0
f0102538:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010253d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102542:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102547:	e8 20 ef ff ff       	call   f010146c <boot_map_region>
f010254c:	c7 45 d0 00 20 58 f0 	movl   $0xf0582000,-0x30(%ebp)
f0102553:	83 c4 10             	add    $0x10,%esp
f0102556:	bb 00 20 58 f0       	mov    $0xf0582000,%ebx
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
f010257f:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f0102584:	e8 e3 ee ff ff       	call   f010146c <boot_map_region>
f0102589:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010258f:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f0102595:	83 c4 10             	add    $0x10,%esp
f0102598:	81 fb 00 20 5c f0    	cmp    $0xf05c2000,%ebx
f010259e:	75 c0                	jne    f0102560 <mem_init+0xe1e>
	pgdir = kern_pgdir;
f01025a0:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
f01025a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01025a8:	a1 a8 0e 58 f0       	mov    0xf0580ea8,%eax
f01025ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01025b0:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01025b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025bf:	8b 35 b0 0e 58 f0    	mov    0xf0580eb0,%esi
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
f010260d:	68 1b 90 10 f0       	push   $0xf010901b
f0102612:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102617:	68 57 03 00 00       	push   $0x357
f010261c:	68 05 8e 10 f0       	push   $0xf0108e05
f0102621:	e8 23 da ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0102626:	68 29 8f 10 f0       	push   $0xf0108f29
f010262b:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102630:	68 ca 03 00 00       	push   $0x3ca
f0102635:	68 05 8e 10 f0       	push   $0xf0108e05
f010263a:	e8 0a da ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010263f:	68 3f 8f 10 f0       	push   $0xf0108f3f
f0102644:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102649:	68 cb 03 00 00       	push   $0x3cb
f010264e:	68 05 8e 10 f0       	push   $0xf0108e05
f0102653:	e8 f1 d9 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0102658:	68 55 8f 10 f0       	push   $0xf0108f55
f010265d:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102662:	68 cc 03 00 00       	push   $0x3cc
f0102667:	68 05 8e 10 f0       	push   $0xf0108e05
f010266c:	e8 d8 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0102671:	68 6b 8f 10 f0       	push   $0xf0108f6b
f0102676:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010267b:	68 cf 03 00 00       	push   $0x3cf
f0102680:	68 05 8e 10 f0       	push   $0xf0108e05
f0102685:	e8 bf d9 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010268a:	68 ac 85 10 f0       	push   $0xf01085ac
f010268f:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102694:	68 d0 03 00 00       	push   $0x3d0
f0102699:	68 05 8e 10 f0       	push   $0xf0108e05
f010269e:	e8 a6 d9 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01026a3:	68 d4 8f 10 f0       	push   $0xf0108fd4
f01026a8:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01026ad:	68 d7 03 00 00       	push   $0x3d7
f01026b2:	68 05 8e 10 f0       	push   $0xf0108e05
f01026b7:	e8 8d d9 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01026bc:	68 ec 85 10 f0       	push   $0xf01085ec
f01026c1:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01026c6:	68 da 03 00 00       	push   $0x3da
f01026cb:	68 05 8e 10 f0       	push   $0xf0108e05
f01026d0:	e8 74 d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01026d5:	68 24 86 10 f0       	push   $0xf0108624
f01026da:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01026df:	68 dd 03 00 00       	push   $0x3dd
f01026e4:	68 05 8e 10 f0       	push   $0xf0108e05
f01026e9:	e8 5b d9 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01026ee:	68 54 86 10 f0       	push   $0xf0108654
f01026f3:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01026f8:	68 e1 03 00 00       	push   $0x3e1
f01026fd:	68 05 8e 10 f0       	push   $0xf0108e05
f0102702:	e8 42 d9 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102707:	68 84 86 10 f0       	push   $0xf0108684
f010270c:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102711:	68 e2 03 00 00       	push   $0x3e2
f0102716:	68 05 8e 10 f0       	push   $0xf0108e05
f010271b:	e8 29 d9 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102720:	68 ac 86 10 f0       	push   $0xf01086ac
f0102725:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010272a:	68 e3 03 00 00       	push   $0x3e3
f010272f:	68 05 8e 10 f0       	push   $0xf0108e05
f0102734:	e8 10 d9 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102739:	68 26 90 10 f0       	push   $0xf0109026
f010273e:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102743:	68 e4 03 00 00       	push   $0x3e4
f0102748:	68 05 8e 10 f0       	push   $0xf0108e05
f010274d:	e8 f7 d8 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102752:	68 37 90 10 f0       	push   $0xf0109037
f0102757:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010275c:	68 e5 03 00 00       	push   $0x3e5
f0102761:	68 05 8e 10 f0       	push   $0xf0108e05
f0102766:	e8 de d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010276b:	68 dc 86 10 f0       	push   $0xf01086dc
f0102770:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102775:	68 e8 03 00 00       	push   $0x3e8
f010277a:	68 05 8e 10 f0       	push   $0xf0108e05
f010277f:	e8 c5 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102784:	68 18 87 10 f0       	push   $0xf0108718
f0102789:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010278e:	68 e9 03 00 00       	push   $0x3e9
f0102793:	68 05 8e 10 f0       	push   $0xf0108e05
f0102798:	e8 ac d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010279d:	68 48 90 10 f0       	push   $0xf0109048
f01027a2:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01027a7:	68 ea 03 00 00       	push   $0x3ea
f01027ac:	68 05 8e 10 f0       	push   $0xf0108e05
f01027b1:	e8 93 d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f01027b6:	68 d4 8f 10 f0       	push   $0xf0108fd4
f01027bb:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01027c0:	68 ed 03 00 00       	push   $0x3ed
f01027c5:	68 05 8e 10 f0       	push   $0xf0108e05
f01027ca:	e8 7a d8 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027cf:	68 dc 86 10 f0       	push   $0xf01086dc
f01027d4:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01027d9:	68 f0 03 00 00       	push   $0x3f0
f01027de:	68 05 8e 10 f0       	push   $0xf0108e05
f01027e3:	e8 61 d8 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027e8:	68 18 87 10 f0       	push   $0xf0108718
f01027ed:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01027f2:	68 f1 03 00 00       	push   $0x3f1
f01027f7:	68 05 8e 10 f0       	push   $0xf0108e05
f01027fc:	e8 48 d8 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102801:	68 48 90 10 f0       	push   $0xf0109048
f0102806:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010280b:	68 f2 03 00 00       	push   $0x3f2
f0102810:	68 05 8e 10 f0       	push   $0xf0108e05
f0102815:	e8 2f d8 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f010281a:	68 d4 8f 10 f0       	push   $0xf0108fd4
f010281f:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102824:	68 f6 03 00 00       	push   $0x3f6
f0102829:	68 05 8e 10 f0       	push   $0xf0108e05
f010282e:	e8 16 d8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102833:	50                   	push   %eax
f0102834:	68 74 7c 10 f0       	push   $0xf0107c74
f0102839:	68 f9 03 00 00       	push   $0x3f9
f010283e:	68 05 8e 10 f0       	push   $0xf0108e05
f0102843:	e8 01 d8 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102848:	68 48 87 10 f0       	push   $0xf0108748
f010284d:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102852:	68 fa 03 00 00       	push   $0x3fa
f0102857:	68 05 8e 10 f0       	push   $0xf0108e05
f010285c:	e8 e8 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102861:	68 88 87 10 f0       	push   $0xf0108788
f0102866:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010286b:	68 fd 03 00 00       	push   $0x3fd
f0102870:	68 05 8e 10 f0       	push   $0xf0108e05
f0102875:	e8 cf d7 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010287a:	68 18 87 10 f0       	push   $0xf0108718
f010287f:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102884:	68 fe 03 00 00       	push   $0x3fe
f0102889:	68 05 8e 10 f0       	push   $0xf0108e05
f010288e:	e8 b6 d7 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102893:	68 48 90 10 f0       	push   $0xf0109048
f0102898:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010289d:	68 ff 03 00 00       	push   $0x3ff
f01028a2:	68 05 8e 10 f0       	push   $0xf0108e05
f01028a7:	e8 9d d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01028ac:	68 c8 87 10 f0       	push   $0xf01087c8
f01028b1:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01028b6:	68 00 04 00 00       	push   $0x400
f01028bb:	68 05 8e 10 f0       	push   $0xf0108e05
f01028c0:	e8 84 d7 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01028c5:	68 59 90 10 f0       	push   $0xf0109059
f01028ca:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01028cf:	68 01 04 00 00       	push   $0x401
f01028d4:	68 05 8e 10 f0       	push   $0xf0108e05
f01028d9:	e8 6b d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01028de:	68 dc 86 10 f0       	push   $0xf01086dc
f01028e3:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01028e8:	68 04 04 00 00       	push   $0x404
f01028ed:	68 05 8e 10 f0       	push   $0xf0108e05
f01028f2:	e8 52 d7 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01028f7:	68 fc 87 10 f0       	push   $0xf01087fc
f01028fc:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102901:	68 05 04 00 00       	push   $0x405
f0102906:	68 05 8e 10 f0       	push   $0xf0108e05
f010290b:	e8 39 d7 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102910:	68 30 88 10 f0       	push   $0xf0108830
f0102915:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010291a:	68 06 04 00 00       	push   $0x406
f010291f:	68 05 8e 10 f0       	push   $0xf0108e05
f0102924:	e8 20 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102929:	68 68 88 10 f0       	push   $0xf0108868
f010292e:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102933:	68 09 04 00 00       	push   $0x409
f0102938:	68 05 8e 10 f0       	push   $0xf0108e05
f010293d:	e8 07 d7 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102942:	68 a0 88 10 f0       	push   $0xf01088a0
f0102947:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010294c:	68 0c 04 00 00       	push   $0x40c
f0102951:	68 05 8e 10 f0       	push   $0xf0108e05
f0102956:	e8 ee d6 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010295b:	68 30 88 10 f0       	push   $0xf0108830
f0102960:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102965:	68 0d 04 00 00       	push   $0x40d
f010296a:	68 05 8e 10 f0       	push   $0xf0108e05
f010296f:	e8 d5 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102974:	68 dc 88 10 f0       	push   $0xf01088dc
f0102979:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010297e:	68 10 04 00 00       	push   $0x410
f0102983:	68 05 8e 10 f0       	push   $0xf0108e05
f0102988:	e8 bc d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010298d:	68 08 89 10 f0       	push   $0xf0108908
f0102992:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102997:	68 11 04 00 00       	push   $0x411
f010299c:	68 05 8e 10 f0       	push   $0xf0108e05
f01029a1:	e8 a3 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f01029a6:	68 6f 90 10 f0       	push   $0xf010906f
f01029ab:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01029b0:	68 13 04 00 00       	push   $0x413
f01029b5:	68 05 8e 10 f0       	push   $0xf0108e05
f01029ba:	e8 8a d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01029bf:	68 80 90 10 f0       	push   $0xf0109080
f01029c4:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01029c9:	68 14 04 00 00       	push   $0x414
f01029ce:	68 05 8e 10 f0       	push   $0xf0108e05
f01029d3:	e8 71 d6 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01029d8:	68 38 89 10 f0       	push   $0xf0108938
f01029dd:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01029e2:	68 17 04 00 00       	push   $0x417
f01029e7:	68 05 8e 10 f0       	push   $0xf0108e05
f01029ec:	e8 58 d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01029f1:	68 5c 89 10 f0       	push   $0xf010895c
f01029f6:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01029fb:	68 1b 04 00 00       	push   $0x41b
f0102a00:	68 05 8e 10 f0       	push   $0xf0108e05
f0102a05:	e8 3f d6 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a0a:	68 08 89 10 f0       	push   $0xf0108908
f0102a0f:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102a14:	68 1c 04 00 00       	push   $0x41c
f0102a19:	68 05 8e 10 f0       	push   $0xf0108e05
f0102a1e:	e8 26 d6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102a23:	68 26 90 10 f0       	push   $0xf0109026
f0102a28:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102a2d:	68 1d 04 00 00       	push   $0x41d
f0102a32:	68 05 8e 10 f0       	push   $0xf0108e05
f0102a37:	e8 0d d6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102a3c:	68 80 90 10 f0       	push   $0xf0109080
f0102a41:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102a46:	68 1e 04 00 00       	push   $0x41e
f0102a4b:	68 05 8e 10 f0       	push   $0xf0108e05
f0102a50:	e8 f4 d5 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102a55:	68 80 89 10 f0       	push   $0xf0108980
f0102a5a:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102a5f:	68 21 04 00 00       	push   $0x421
f0102a64:	68 05 8e 10 f0       	push   $0xf0108e05
f0102a69:	e8 db d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0102a6e:	68 91 90 10 f0       	push   $0xf0109091
f0102a73:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102a78:	68 22 04 00 00       	push   $0x422
f0102a7d:	68 05 8e 10 f0       	push   $0xf0108e05
f0102a82:	e8 c2 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f0102a87:	68 9d 90 10 f0       	push   $0xf010909d
f0102a8c:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102a91:	68 23 04 00 00       	push   $0x423
f0102a96:	68 05 8e 10 f0       	push   $0xf0108e05
f0102a9b:	e8 a9 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102aa0:	68 5c 89 10 f0       	push   $0xf010895c
f0102aa5:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102aaa:	68 27 04 00 00       	push   $0x427
f0102aaf:	68 05 8e 10 f0       	push   $0xf0108e05
f0102ab4:	e8 90 d5 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102ab9:	68 b8 89 10 f0       	push   $0xf01089b8
f0102abe:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102ac3:	68 28 04 00 00       	push   $0x428
f0102ac8:	68 05 8e 10 f0       	push   $0xf0108e05
f0102acd:	e8 77 d5 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0102ad2:	68 b2 90 10 f0       	push   $0xf01090b2
f0102ad7:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102adc:	68 29 04 00 00       	push   $0x429
f0102ae1:	68 05 8e 10 f0       	push   $0xf0108e05
f0102ae6:	e8 5e d5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0102aeb:	68 80 90 10 f0       	push   $0xf0109080
f0102af0:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102af5:	68 2a 04 00 00       	push   $0x42a
f0102afa:	68 05 8e 10 f0       	push   $0xf0108e05
f0102aff:	e8 45 d5 ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102b04:	68 e0 89 10 f0       	push   $0xf01089e0
f0102b09:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102b0e:	68 2d 04 00 00       	push   $0x42d
f0102b13:	68 05 8e 10 f0       	push   $0xf0108e05
f0102b18:	e8 2c d5 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102b1d:	68 d4 8f 10 f0       	push   $0xf0108fd4
f0102b22:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102b27:	68 30 04 00 00       	push   $0x430
f0102b2c:	68 05 8e 10 f0       	push   $0xf0108e05
f0102b31:	e8 13 d5 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b36:	68 84 86 10 f0       	push   $0xf0108684
f0102b3b:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102b40:	68 33 04 00 00       	push   $0x433
f0102b45:	68 05 8e 10 f0       	push   $0xf0108e05
f0102b4a:	e8 fa d4 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102b4f:	68 37 90 10 f0       	push   $0xf0109037
f0102b54:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102b59:	68 35 04 00 00       	push   $0x435
f0102b5e:	68 05 8e 10 f0       	push   $0xf0108e05
f0102b63:	e8 e1 d4 ff ff       	call   f0100049 <_panic>
f0102b68:	50                   	push   %eax
f0102b69:	68 74 7c 10 f0       	push   $0xf0107c74
f0102b6e:	68 3c 04 00 00       	push   $0x43c
f0102b73:	68 05 8e 10 f0       	push   $0xf0108e05
f0102b78:	e8 cc d4 ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102b7d:	68 c3 90 10 f0       	push   $0xf01090c3
f0102b82:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102b87:	68 3d 04 00 00       	push   $0x43d
f0102b8c:	68 05 8e 10 f0       	push   $0xf0108e05
f0102b91:	e8 b3 d4 ff ff       	call   f0100049 <_panic>
f0102b96:	50                   	push   %eax
f0102b97:	68 74 7c 10 f0       	push   $0xf0107c74
f0102b9c:	6a 58                	push   $0x58
f0102b9e:	68 11 8e 10 f0       	push   $0xf0108e11
f0102ba3:	e8 a1 d4 ff ff       	call   f0100049 <_panic>
f0102ba8:	50                   	push   %eax
f0102ba9:	68 74 7c 10 f0       	push   $0xf0107c74
f0102bae:	6a 58                	push   $0x58
f0102bb0:	68 11 8e 10 f0       	push   $0xf0108e11
f0102bb5:	e8 8f d4 ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102bba:	68 db 90 10 f0       	push   $0xf01090db
f0102bbf:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102bc4:	68 47 04 00 00       	push   $0x447
f0102bc9:	68 05 8e 10 f0       	push   $0xf0108e05
f0102bce:	e8 76 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102bd3:	68 04 8a 10 f0       	push   $0xf0108a04
f0102bd8:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102bdd:	68 57 04 00 00       	push   $0x457
f0102be2:	68 05 8e 10 f0       	push   $0xf0108e05
f0102be7:	e8 5d d4 ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102bec:	68 2c 8a 10 f0       	push   $0xf0108a2c
f0102bf1:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102bf6:	68 58 04 00 00       	push   $0x458
f0102bfb:	68 05 8e 10 f0       	push   $0xf0108e05
f0102c00:	e8 44 d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102c05:	68 54 8a 10 f0       	push   $0xf0108a54
f0102c0a:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102c0f:	68 5a 04 00 00       	push   $0x45a
f0102c14:	68 05 8e 10 f0       	push   $0xf0108e05
f0102c19:	e8 2b d4 ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102c1e:	68 f2 90 10 f0       	push   $0xf01090f2
f0102c23:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102c28:	68 5c 04 00 00       	push   $0x45c
f0102c2d:	68 05 8e 10 f0       	push   $0xf0108e05
f0102c32:	e8 12 d4 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c37:	68 7c 8a 10 f0       	push   $0xf0108a7c
f0102c3c:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102c41:	68 5e 04 00 00       	push   $0x45e
f0102c46:	68 05 8e 10 f0       	push   $0xf0108e05
f0102c4b:	e8 f9 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c50:	68 a0 8a 10 f0       	push   $0xf0108aa0
f0102c55:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102c5a:	68 5f 04 00 00       	push   $0x45f
f0102c5f:	68 05 8e 10 f0       	push   $0xf0108e05
f0102c64:	e8 e0 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c69:	68 d0 8a 10 f0       	push   $0xf0108ad0
f0102c6e:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102c73:	68 60 04 00 00       	push   $0x460
f0102c78:	68 05 8e 10 f0       	push   $0xf0108e05
f0102c7d:	e8 c7 d3 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102c82:	68 f4 8a 10 f0       	push   $0xf0108af4
f0102c87:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102c8c:	68 61 04 00 00       	push   $0x461
f0102c91:	68 05 8e 10 f0       	push   $0xf0108e05
f0102c96:	e8 ae d3 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102c9b:	68 20 8b 10 f0       	push   $0xf0108b20
f0102ca0:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102ca5:	68 63 04 00 00       	push   $0x463
f0102caa:	68 05 8e 10 f0       	push   $0xf0108e05
f0102caf:	e8 95 d3 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102cb4:	68 64 8b 10 f0       	push   $0xf0108b64
f0102cb9:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102cbe:	68 64 04 00 00       	push   $0x464
f0102cc3:	68 05 8e 10 f0       	push   $0xf0108e05
f0102cc8:	e8 7c d3 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ccd:	50                   	push   %eax
f0102cce:	68 98 7c 10 f0       	push   $0xf0107c98
f0102cd3:	68 be 00 00 00       	push   $0xbe
f0102cd8:	68 05 8e 10 f0       	push   $0xf0108e05
f0102cdd:	e8 67 d3 ff ff       	call   f0100049 <_panic>
f0102ce2:	50                   	push   %eax
f0102ce3:	68 98 7c 10 f0       	push   $0xf0107c98
f0102ce8:	68 c6 00 00 00       	push   $0xc6
f0102ced:	68 05 8e 10 f0       	push   $0xf0108e05
f0102cf2:	e8 52 d3 ff ff       	call   f0100049 <_panic>
f0102cf7:	50                   	push   %eax
f0102cf8:	68 98 7c 10 f0       	push   $0xf0107c98
f0102cfd:	68 d2 00 00 00       	push   $0xd2
f0102d02:	68 05 8e 10 f0       	push   $0xf0108e05
f0102d07:	e8 3d d3 ff ff       	call   f0100049 <_panic>
f0102d0c:	53                   	push   %ebx
f0102d0d:	68 98 7c 10 f0       	push   $0xf0107c98
f0102d12:	68 17 01 00 00       	push   $0x117
f0102d17:	68 05 8e 10 f0       	push   $0xf0108e05
f0102d1c:	e8 28 d3 ff ff       	call   f0100049 <_panic>
f0102d21:	56                   	push   %esi
f0102d22:	68 98 7c 10 f0       	push   $0xf0107c98
f0102d27:	68 6e 03 00 00       	push   $0x36e
f0102d2c:	68 05 8e 10 f0       	push   $0xf0108e05
f0102d31:	e8 13 d3 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d36:	68 98 8b 10 f0       	push   $0xf0108b98
f0102d3b:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102d40:	68 6e 03 00 00       	push   $0x36e
f0102d45:	68 05 8e 10 f0       	push   $0xf0108e05
f0102d4a:	e8 fa d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102d4f:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
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
f0102dc0:	68 98 7c 10 f0       	push   $0xf0107c98
f0102dc5:	68 73 03 00 00       	push   $0x373
f0102dca:	68 05 8e 10 f0       	push   $0xf0108e05
f0102dcf:	e8 75 d2 ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102dd4:	68 cc 8b 10 f0       	push   $0xf0108bcc
f0102dd9:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102dde:	68 73 03 00 00       	push   $0x373
f0102de3:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0102e1c:	68 00 8c 10 f0       	push   $0xf0108c00
f0102e21:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102e26:	68 78 03 00 00       	push   $0x378
f0102e2b:	68 05 8e 10 f0       	push   $0xf0108e05
f0102e30:	e8 14 d2 ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f0102e35:	83 ec 0c             	sub    $0xc,%esp
f0102e38:	68 1d 91 10 f0       	push   $0xf010911d
f0102e3d:	e8 7f 10 00 00       	call   f0103ec1 <cprintf>
f0102e42:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e45:	b8 00 20 58 f0       	mov    $0xf0582000,%eax
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
f0102ed2:	81 ff 00 20 5c f0    	cmp    $0xf05c2000,%edi
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
f0102f06:	68 2c 8c 10 f0       	push   $0xf0108c2c
f0102f0b:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102f10:	68 7d 03 00 00       	push   $0x37d
f0102f15:	68 05 8e 10 f0       	push   $0xf0108e05
f0102f1a:	e8 2a d1 ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f1f:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f22:	c1 e6 0c             	shl    $0xc,%esi
f0102f25:	89 fb                	mov    %edi,%ebx
f0102f27:	eb c3                	jmp    f0102eec <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f29:	ff 75 c0             	pushl  -0x40(%ebp)
f0102f2c:	68 98 7c 10 f0       	push   $0xf0107c98
f0102f31:	68 85 03 00 00       	push   $0x385
f0102f36:	68 05 8e 10 f0       	push   $0xf0108e05
f0102f3b:	e8 09 d1 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102f40:	68 54 8c 10 f0       	push   $0xf0108c54
f0102f45:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102f4a:	68 85 03 00 00       	push   $0x385
f0102f4f:	68 05 8e 10 f0       	push   $0xf0108e05
f0102f54:	e8 f0 d0 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f59:	68 9c 8c 10 f0       	push   $0xf0108c9c
f0102f5e:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102f63:	68 87 03 00 00       	push   $0x387
f0102f68:	68 05 8e 10 f0       	push   $0xf0108e05
f0102f6d:	e8 d7 d0 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0102f72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f75:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102f79:	75 4e                	jne    f0102fc9 <mem_init+0x1887>
f0102f7b:	68 34 91 10 f0       	push   $0xf0109134
f0102f80:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102f85:	68 92 03 00 00       	push   $0x392
f0102f8a:	68 05 8e 10 f0       	push   $0xf0108e05
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
f0102fce:	68 34 91 10 f0       	push   $0xf0109134
f0102fd3:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102fd8:	68 96 03 00 00       	push   $0x396
f0102fdd:	68 05 8e 10 f0       	push   $0xf0108e05
f0102fe2:	e8 62 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f0102fe7:	68 45 91 10 f0       	push   $0xf0109145
f0102fec:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0102ff1:	68 97 03 00 00       	push   $0x397
f0102ff6:	68 05 8e 10 f0       	push   $0xf0108e05
f0102ffb:	e8 49 d0 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f0103000:	68 56 91 10 f0       	push   $0xf0109156
f0103005:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010300a:	68 99 03 00 00       	push   $0x399
f010300f:	68 05 8e 10 f0       	push   $0xf0108e05
f0103014:	e8 30 d0 ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0103019:	83 ec 0c             	sub    $0xc,%esp
f010301c:	68 c0 8c 10 f0       	push   $0xf0108cc0
f0103021:	e8 9b 0e 00 00       	call   f0103ec1 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f0103026:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f0103029:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f010302c:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f010302f:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f01030b2:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01030b8:	c1 f8 03             	sar    $0x3,%eax
f01030bb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030be:	89 c2                	mov    %eax,%edx
f01030c0:	c1 ea 0c             	shr    $0xc,%edx
f01030c3:	83 c4 10             	add    $0x10,%esp
f01030c6:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01030cc:	0f 83 cb 01 00 00    	jae    f010329d <mem_init+0x1b5b>
	memset(page2kva(pp1), 1, PGSIZE);
f01030d2:	83 ec 04             	sub    $0x4,%esp
f01030d5:	68 00 10 00 00       	push   $0x1000
f01030da:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01030dc:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01030e1:	50                   	push   %eax
f01030e2:	e8 ec 34 00 00       	call   f01065d3 <memset>
	return (pp - pages) << PGSHIFT;
f01030e7:	89 d8                	mov    %ebx,%eax
f01030e9:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01030ef:	c1 f8 03             	sar    $0x3,%eax
f01030f2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030f5:	89 c2                	mov    %eax,%edx
f01030f7:	c1 ea 0c             	shr    $0xc,%edx
f01030fa:	83 c4 10             	add    $0x10,%esp
f01030fd:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0103103:	0f 83 a6 01 00 00    	jae    f01032af <mem_init+0x1b6d>
	memset(page2kva(pp2), 2, PGSIZE);
f0103109:	83 ec 04             	sub    $0x4,%esp
f010310c:	68 00 10 00 00       	push   $0x1000
f0103111:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0103113:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103118:	50                   	push   %eax
f0103119:	e8 b5 34 00 00       	call   f01065d3 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f010311e:	6a 02                	push   $0x2
f0103120:	68 00 10 00 00       	push   $0x1000
f0103125:	57                   	push   %edi
f0103126:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f0103157:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
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
f0103197:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f010319d:	c1 f8 03             	sar    $0x3,%eax
f01031a0:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01031a3:	89 c2                	mov    %eax,%edx
f01031a5:	c1 ea 0c             	shr    $0xc,%edx
f01031a8:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01031ae:	0f 83 8a 01 00 00    	jae    f010333e <mem_init+0x1bfc>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01031b4:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01031bb:	03 03 03 
f01031be:	0f 85 8c 01 00 00    	jne    f0103350 <mem_init+0x1c0e>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01031c4:	83 ec 08             	sub    $0x8,%esp
f01031c7:	68 00 10 00 00       	push   $0x1000
f01031cc:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01031d2:	e8 e3 e3 ff ff       	call   f01015ba <page_remove>
	assert(pp2->pp_ref == 0);
f01031d7:	83 c4 10             	add    $0x10,%esp
f01031da:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01031df:	0f 85 84 01 00 00    	jne    f0103369 <mem_init+0x1c27>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01031e5:	8b 0d ac 0e 58 f0    	mov    0xf0580eac,%ecx
f01031eb:	8b 11                	mov    (%ecx),%edx
f01031ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f01031f3:	89 f0                	mov    %esi,%eax
f01031f5:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
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
f0103229:	c7 04 24 54 8d 10 f0 	movl   $0xf0108d54,(%esp)
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
f010323e:	68 98 7c 10 f0       	push   $0xf0107c98
f0103243:	68 ef 00 00 00       	push   $0xef
f0103248:	68 05 8e 10 f0       	push   $0xf0108e05
f010324d:	e8 f7 cd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0103252:	68 29 8f 10 f0       	push   $0xf0108f29
f0103257:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010325c:	68 79 04 00 00       	push   $0x479
f0103261:	68 05 8e 10 f0       	push   $0xf0108e05
f0103266:	e8 de cd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f010326b:	68 3f 8f 10 f0       	push   $0xf0108f3f
f0103270:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0103275:	68 7a 04 00 00       	push   $0x47a
f010327a:	68 05 8e 10 f0       	push   $0xf0108e05
f010327f:	e8 c5 cd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0103284:	68 55 8f 10 f0       	push   $0xf0108f55
f0103289:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010328e:	68 7b 04 00 00       	push   $0x47b
f0103293:	68 05 8e 10 f0       	push   $0xf0108e05
f0103298:	e8 ac cd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010329d:	50                   	push   %eax
f010329e:	68 74 7c 10 f0       	push   $0xf0107c74
f01032a3:	6a 58                	push   $0x58
f01032a5:	68 11 8e 10 f0       	push   $0xf0108e11
f01032aa:	e8 9a cd ff ff       	call   f0100049 <_panic>
f01032af:	50                   	push   %eax
f01032b0:	68 74 7c 10 f0       	push   $0xf0107c74
f01032b5:	6a 58                	push   $0x58
f01032b7:	68 11 8e 10 f0       	push   $0xf0108e11
f01032bc:	e8 88 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01032c1:	68 26 90 10 f0       	push   $0xf0109026
f01032c6:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01032cb:	68 80 04 00 00       	push   $0x480
f01032d0:	68 05 8e 10 f0       	push   $0xf0108e05
f01032d5:	e8 6f cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032da:	68 e0 8c 10 f0       	push   $0xf0108ce0
f01032df:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01032e4:	68 81 04 00 00       	push   $0x481
f01032e9:	68 05 8e 10 f0       	push   $0xf0108e05
f01032ee:	e8 56 cd ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01032f3:	68 04 8d 10 f0       	push   $0xf0108d04
f01032f8:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01032fd:	68 83 04 00 00       	push   $0x483
f0103302:	68 05 8e 10 f0       	push   $0xf0108e05
f0103307:	e8 3d cd ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f010330c:	68 48 90 10 f0       	push   $0xf0109048
f0103311:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0103316:	68 84 04 00 00       	push   $0x484
f010331b:	68 05 8e 10 f0       	push   $0xf0108e05
f0103320:	e8 24 cd ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0103325:	68 b2 90 10 f0       	push   $0xf01090b2
f010332a:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010332f:	68 85 04 00 00       	push   $0x485
f0103334:	68 05 8e 10 f0       	push   $0xf0108e05
f0103339:	e8 0b cd ff ff       	call   f0100049 <_panic>
f010333e:	50                   	push   %eax
f010333f:	68 74 7c 10 f0       	push   $0xf0107c74
f0103344:	6a 58                	push   $0x58
f0103346:	68 11 8e 10 f0       	push   $0xf0108e11
f010334b:	e8 f9 cc ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103350:	68 28 8d 10 f0       	push   $0xf0108d28
f0103355:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010335a:	68 87 04 00 00       	push   $0x487
f010335f:	68 05 8e 10 f0       	push   $0xf0108e05
f0103364:	e8 e0 cc ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103369:	68 80 90 10 f0       	push   $0xf0109080
f010336e:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0103373:	68 89 04 00 00       	push   $0x489
f0103378:	68 05 8e 10 f0       	push   $0xf0108e05
f010337d:	e8 c7 cc ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103382:	68 84 86 10 f0       	push   $0xf0108684
f0103387:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010338c:	68 8c 04 00 00       	push   $0x48c
f0103391:	68 05 8e 10 f0       	push   $0xf0108e05
f0103396:	e8 ae cc ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f010339b:	68 37 90 10 f0       	push   $0xf0109037
f01033a0:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01033a5:	68 8e 04 00 00       	push   $0x48e
f01033aa:	68 05 8e 10 f0       	push   $0xf0108e05
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
f01033d6:	89 1d 3c f2 57 f0    	mov    %ebx,0xf057f23c
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
f0103422:	68 80 8d 10 f0       	push   $0xf0108d80
f0103427:	e8 95 0a 00 00       	call   f0103ec1 <cprintf>
			cprintf("the perm: 0x%x, *the_pte & perm: 0x%x\n", perm, *the_pte & perm);
f010342c:	83 c4 0c             	add    $0xc,%esp
f010342f:	89 f8                	mov    %edi,%eax
f0103431:	23 06                	and    (%esi),%eax
f0103433:	50                   	push   %eax
f0103434:	57                   	push   %edi
f0103435:	68 a8 8d 10 f0       	push   $0xf0108da8
f010343a:	e8 82 0a 00 00       	call   f0103ec1 <cprintf>
			user_mem_check_addr = (uintptr_t)i;
f010343f:	89 1d 3c f2 57 f0    	mov    %ebx,0xf057f23c
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
f0103488:	ff 35 3c f2 57 f0    	pushl  0xf057f23c
f010348e:	ff 73 48             	pushl  0x48(%ebx)
f0103491:	68 d0 8d 10 f0       	push   $0xf0108dd0
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
f01034fb:	68 74 91 10 f0       	push   $0xf0109174
f0103500:	68 2a 01 00 00       	push   $0x12a
f0103505:	68 86 91 10 f0       	push   $0xf0109186
f010350a:	e8 3a cb ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f010350f:	83 ec 04             	sub    $0x4,%esp
f0103512:	68 91 91 10 f0       	push   $0xf0109191
f0103517:	68 2d 01 00 00       	push   $0x12d
f010351c:	68 86 91 10 f0       	push   $0xf0109186
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
f0103548:	03 1d 44 f2 57 f0    	add    0xf057f244,%ebx
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
f010356e:	e8 67 36 00 00       	call   f0106bda <cpunum>
f0103573:	6b c0 74             	imul   $0x74,%eax,%eax
f0103576:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
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
f0103597:	68 c1 91 10 f0       	push   $0xf01091c1
f010359c:	e8 20 09 00 00       	call   f0103ec1 <cprintf>
		return -E_BAD_ENV;
f01035a1:	83 c4 10             	add    $0x10,%esp
f01035a4:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01035a9:	eb bc                	jmp    f0103567 <envid2env+0x39>
			cprintf("ssssssssssssssssss %d\n", envid);
f01035ab:	83 ec 08             	sub    $0x8,%esp
f01035ae:	56                   	push   %esi
f01035af:	68 aa 91 10 f0       	push   $0xf01091aa
f01035b4:	e8 08 09 00 00       	call   f0103ec1 <cprintf>
f01035b9:	83 c4 10             	add    $0x10,%esp
f01035bc:	eb d6                	jmp    f0103594 <envid2env+0x66>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01035be:	e8 17 36 00 00       	call   f0106bda <cpunum>
f01035c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01035c6:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f01035cc:	74 8f                	je     f010355d <envid2env+0x2f>
f01035ce:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01035d1:	e8 04 36 00 00       	call   f0106bda <cpunum>
f01035d6:	6b c0 74             	imul   $0x74,%eax,%eax
f01035d9:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01035df:	3b 70 48             	cmp    0x48(%eax),%esi
f01035e2:	0f 84 75 ff ff ff    	je     f010355d <envid2env+0x2f>
		*env_store = 0;
f01035e8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		cprintf("33333333333333333333333\n");
f01035f1:	83 ec 0c             	sub    $0xc,%esp
f01035f4:	68 d8 91 10 f0       	push   $0xf01091d8
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
f010363d:	8b 15 44 f2 57 f0    	mov    0xf057f244,%edx
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
f0103660:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
f0103665:	a3 48 f2 57 f0       	mov    %eax,0xf057f248
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
f0103678:	8b 1d 48 f2 57 f0    	mov    0xf057f248,%ebx
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
f01036a0:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01036a6:	c1 f8 03             	sar    $0x3,%eax
f01036a9:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01036ac:	89 c2                	mov    %eax,%edx
f01036ae:	c1 ea 0c             	shr    $0xc,%edx
f01036b1:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01036b7:	0f 83 17 01 00 00    	jae    f01037d4 <env_alloc+0x163>
	return (void *)(pa + KERNBASE);
f01036bd:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f01036c2:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy((void *)e->env_pgdir, (void *)kern_pgdir, PGSIZE);
f01036c5:	83 ec 04             	sub    $0x4,%esp
f01036c8:	68 00 10 00 00       	push   $0x1000
f01036cd:	ff 35 ac 0e 58 f0    	pushl  0xf0580eac
f01036d3:	50                   	push   %eax
f01036d4:	e8 a4 2f 00 00       	call   f010667d <memcpy>
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
f0103710:	2b 15 44 f2 57 f0    	sub    0xf057f244,%edx
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
f0103748:	e8 86 2e 00 00       	call   f01065d3 <memset>
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
f0103781:	a3 48 f2 57 f0       	mov    %eax,0xf057f248
	*newenv_store = e;
f0103786:	8b 45 08             	mov    0x8(%ebp),%eax
f0103789:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010378b:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010378e:	e8 47 34 00 00       	call   f0106bda <cpunum>
f0103793:	6b c0 74             	imul   $0x74,%eax,%eax
f0103796:	83 c4 10             	add    $0x10,%esp
f0103799:	ba 00 00 00 00       	mov    $0x0,%edx
f010379e:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f01037a5:	74 11                	je     f01037b8 <env_alloc+0x147>
f01037a7:	e8 2e 34 00 00       	call   f0106bda <cpunum>
f01037ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01037af:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01037b5:	8b 50 48             	mov    0x48(%eax),%edx
f01037b8:	83 ec 04             	sub    $0x4,%esp
f01037bb:	53                   	push   %ebx
f01037bc:	52                   	push   %edx
f01037bd:	68 f1 91 10 f0       	push   $0xf01091f1
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
f01037d5:	68 74 7c 10 f0       	push   $0xf0107c74
f01037da:	6a 58                	push   $0x58
f01037dc:	68 11 8e 10 f0       	push   $0xf0108e11
f01037e1:	e8 63 c8 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037e6:	50                   	push   %eax
f01037e7:	68 98 7c 10 f0       	push   $0xf0107c98
f01037ec:	68 c6 00 00 00       	push   $0xc6
f01037f1:	68 86 91 10 f0       	push   $0xf0109186
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
f0103818:	68 7c 92 10 f0       	push   $0xf010927c
f010381d:	68 06 92 10 f0       	push   $0xf0109206
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
f0103888:	68 0d 92 10 f0       	push   $0xf010920d
f010388d:	68 9d 01 00 00       	push   $0x19d
f0103892:	68 86 91 10 f0       	push   $0xf0109186
f0103897:	e8 ad c7 ff ff       	call   f0100049 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f010389c:	81 4e 38 00 30 00 00 	orl    $0x3000,0x38(%esi)
f01038a3:	eb a9                	jmp    f010384e <env_create+0x45>
		panic("is this a valid ELF");
f01038a5:	83 ec 04             	sub    $0x4,%esp
f01038a8:	68 1f 92 10 f0       	push   $0xf010921f
f01038ad:	68 74 01 00 00       	push   $0x174
f01038b2:	68 86 91 10 f0       	push   $0xf0109186
f01038b7:	e8 8d c7 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038bc:	50                   	push   %eax
f01038bd:	68 98 7c 10 f0       	push   $0xf0107c98
f01038c2:	68 79 01 00 00       	push   $0x179
f01038c7:	68 86 91 10 f0       	push   $0xf0109186
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
f01038e9:	e8 e5 2c 00 00       	call   f01065d3 <memset>
			memcpy((void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f01038ee:	83 c4 0c             	add    $0xc,%esp
f01038f1:	ff 73 10             	pushl  0x10(%ebx)
f01038f4:	89 f8                	mov    %edi,%eax
f01038f6:	03 43 04             	add    0x4(%ebx),%eax
f01038f9:	50                   	push   %eax
f01038fa:	ff 73 08             	pushl  0x8(%ebx)
f01038fd:	e8 7b 2d 00 00       	call   f010667d <memcpy>
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
f010393c:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0103959:	68 98 7c 10 f0       	push   $0xf0107c98
f010395e:	68 89 01 00 00       	push   $0x189
f0103963:	68 86 91 10 f0       	push   $0xf0109186
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
f0103979:	e8 5c 32 00 00       	call   f0106bda <cpunum>
f010397e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103981:	39 b8 28 10 58 f0    	cmp    %edi,-0xfa7efd8(%eax)
f0103987:	74 48                	je     f01039d1 <env_free+0x64>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103989:	8b 5f 48             	mov    0x48(%edi),%ebx
f010398c:	e8 49 32 00 00       	call   f0106bda <cpunum>
f0103991:	6b c0 74             	imul   $0x74,%eax,%eax
f0103994:	ba 00 00 00 00       	mov    $0x0,%edx
f0103999:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f01039a0:	74 11                	je     f01039b3 <env_free+0x46>
f01039a2:	e8 33 32 00 00       	call   f0106bda <cpunum>
f01039a7:	6b c0 74             	imul   $0x74,%eax,%eax
f01039aa:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01039b0:	8b 50 48             	mov    0x48(%eax),%edx
f01039b3:	83 ec 04             	sub    $0x4,%esp
f01039b6:	53                   	push   %ebx
f01039b7:	52                   	push   %edx
f01039b8:	68 33 92 10 f0       	push   $0xf0109233
f01039bd:	e8 ff 04 00 00       	call   f0103ec1 <cprintf>
f01039c2:	83 c4 10             	add    $0x10,%esp
f01039c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01039cc:	e9 a9 00 00 00       	jmp    f0103a7a <env_free+0x10d>
		lcr3(PADDR(kern_pgdir));
f01039d1:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
	if ((uint32_t)kva < KERNBASE)
f01039d6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039db:	76 0a                	jbe    f01039e7 <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f01039dd:	05 00 00 00 10       	add    $0x10000000,%eax
f01039e2:	0f 22 d8             	mov    %eax,%cr3
f01039e5:	eb a2                	jmp    f0103989 <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01039e7:	50                   	push   %eax
f01039e8:	68 98 7c 10 f0       	push   $0xf0107c98
f01039ed:	68 b4 01 00 00       	push   $0x1b4
f01039f2:	68 86 91 10 f0       	push   $0xf0109186
f01039f7:	e8 4d c6 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01039fc:	56                   	push   %esi
f01039fd:	68 74 7c 10 f0       	push   $0xf0107c74
f0103a02:	68 c3 01 00 00       	push   $0x1c3
f0103a07:	68 86 91 10 f0       	push   $0xf0109186
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
f0103a4d:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f0103a53:	73 69                	jae    f0103abe <env_free+0x151>
		page_decref(pa2page(pa));
f0103a55:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103a58:	a1 b0 0e 58 f0       	mov    0xf0580eb0,%eax
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
f0103a99:	39 05 a8 0e 58 f0    	cmp    %eax,0xf0580ea8
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
f0103ac1:	68 50 85 10 f0       	push   $0xf0108550
f0103ac6:	6a 51                	push   $0x51
f0103ac8:	68 11 8e 10 f0       	push   $0xf0108e11
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
f0103aeb:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f0103af1:	73 53                	jae    f0103b46 <env_free+0x1d9>
	page_decref(pa2page(pa));
f0103af3:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103af6:	8b 15 b0 0e 58 f0    	mov    0xf0580eb0,%edx
f0103afc:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103aff:	50                   	push   %eax
f0103b00:	e8 6c d8 ff ff       	call   f0101371 <page_decref>
	cprintf("in env_free we set the ENV_FREE\n");
f0103b05:	c7 04 24 58 92 10 f0 	movl   $0xf0109258,(%esp)
f0103b0c:	e8 b0 03 00 00       	call   f0103ec1 <cprintf>
	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103b11:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103b18:	a1 48 f2 57 f0       	mov    0xf057f248,%eax
f0103b1d:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103b20:	89 3d 48 f2 57 f0    	mov    %edi,0xf057f248
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
f0103b32:	68 98 7c 10 f0       	push   $0xf0107c98
f0103b37:	68 d1 01 00 00       	push   $0x1d1
f0103b3c:	68 86 91 10 f0       	push   $0xf0109186
f0103b41:	e8 03 c5 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0103b46:	83 ec 04             	sub    $0x4,%esp
f0103b49:	68 50 85 10 f0       	push   $0xf0108550
f0103b4e:	6a 51                	push   $0x51
f0103b50:	68 11 8e 10 f0       	push   $0xf0108e11
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
f0103b73:	e8 62 30 00 00       	call   f0106bda <cpunum>
f0103b78:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b7b:	83 c4 10             	add    $0x10,%esp
f0103b7e:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f0103b84:	74 1e                	je     f0103ba4 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b89:	c9                   	leave  
f0103b8a:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103b8b:	e8 4a 30 00 00       	call   f0106bda <cpunum>
f0103b90:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b93:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f0103b99:	74 cf                	je     f0103b6a <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103b9b:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103ba2:	eb e2                	jmp    f0103b86 <env_destroy+0x2c>
		curenv = NULL;
f0103ba4:	e8 31 30 00 00       	call   f0106bda <cpunum>
f0103ba9:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bac:	c7 80 28 10 58 f0 00 	movl   $0x0,-0xfa7efd8(%eax)
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
f0103bc2:	e8 13 30 00 00       	call   f0106bda <cpunum>
f0103bc7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bca:	8b 98 28 10 58 f0    	mov    -0xfa7efd8(%eax),%ebx
f0103bd0:	e8 05 30 00 00       	call   f0106bda <cpunum>
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
f0103be5:	68 49 92 10 f0       	push   $0xf0109249
f0103bea:	68 08 02 00 00       	push   $0x208
f0103bef:	68 86 91 10 f0       	push   $0xf0109186
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
f0103c03:	e8 d2 2f 00 00       	call   f0106bda <cpunum>
f0103c08:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c0b:	39 98 28 10 58 f0    	cmp    %ebx,-0xfa7efd8(%eax)
f0103c11:	74 7e                	je     f0103c91 <env_run+0x98>
		if(curenv && curenv->env_status == ENV_RUNNING)
f0103c13:	e8 c2 2f 00 00       	call   f0106bda <cpunum>
f0103c18:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c1b:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f0103c22:	74 18                	je     f0103c3c <env_run+0x43>
f0103c24:	e8 b1 2f 00 00       	call   f0106bda <cpunum>
f0103c29:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c2c:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c32:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103c36:	0f 84 9a 00 00 00    	je     f0103cd6 <env_run+0xdd>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f0103c3c:	e8 99 2f 00 00       	call   f0106bda <cpunum>
f0103c41:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c44:	89 98 28 10 58 f0    	mov    %ebx,-0xfa7efd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0103c4a:	e8 8b 2f 00 00       	call   f0106bda <cpunum>
f0103c4f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c52:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c58:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0103c5f:	e8 76 2f 00 00       	call   f0106bda <cpunum>
f0103c64:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c67:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c6d:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f0103c71:	e8 64 2f 00 00       	call   f0106bda <cpunum>
f0103c76:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c79:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103c7f:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103c82:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c87:	76 67                	jbe    f0103cf0 <env_run+0xf7>
	return (physaddr_t)kva - KERNBASE;
f0103c89:	05 00 00 00 10       	add    $0x10000000,%eax
f0103c8e:	0f 22 d8             	mov    %eax,%cr3
	}
	lcr3(PADDR(curenv->env_pgdir));
f0103c91:	e8 44 2f 00 00       	call   f0106bda <cpunum>
f0103c96:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c99:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
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
f0103cb9:	e8 28 32 00 00       	call   f0106ee6 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103cbe:	f3 90                	pause  
	unlock_kernel(); //lab4 bug?
	env_pop_tf(&curenv->env_tf);
f0103cc0:	e8 15 2f 00 00       	call   f0106bda <cpunum>
f0103cc5:	83 c4 04             	add    $0x4,%esp
f0103cc8:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ccb:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0103cd1:	e8 e5 fe ff ff       	call   f0103bbb <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0103cd6:	e8 ff 2e 00 00       	call   f0106bda <cpunum>
f0103cdb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cde:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0103ce4:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103ceb:	e9 4c ff ff ff       	jmp    f0103c3c <env_run+0x43>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103cf0:	50                   	push   %eax
f0103cf1:	68 98 7c 10 f0       	push   $0xf0107c98
f0103cf6:	68 2c 02 00 00       	push   $0x22c
f0103cfb:	68 86 91 10 f0       	push   $0xf0109186
f0103d00:	e8 44 c3 ff ff       	call   f0100049 <_panic>
f0103d05:	50                   	push   %eax
f0103d06:	68 98 7c 10 f0       	push   $0xf0107c98
f0103d0b:	68 2e 02 00 00       	push   $0x22e
f0103d10:	68 86 91 10 f0       	push   $0xf0109186
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
f0103d56:	80 3d 4c f2 57 f0 00 	cmpb   $0x0,0xf057f24c
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
f0103d7b:	68 87 92 10 f0       	push   $0xf0109287
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
f0103d98:	68 cf 99 10 f0       	push   $0xf01099cf
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
f0103db7:	68 1b 91 10 f0       	push   $0xf010911b
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
f0103dcf:	c6 05 4c f2 57 f0 01 	movb   $0x1,0xf057f24c
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
f0103eb7:	e8 b1 1e 00 00       	call   f0105d6d <vprintfmt>
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
f0103ede:	e8 f7 2c 00 00       	call   f0106bda <cpunum>
f0103ee3:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0103ee5:	e8 f0 2c 00 00       	call   f0106bda <cpunum>
f0103eea:	6b c0 74             	imul   $0x74,%eax,%eax
f0103eed:	89 d9                	mov    %ebx,%ecx
f0103eef:	c1 e1 10             	shl    $0x10,%ecx
f0103ef2:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103ef7:	29 ca                	sub    %ecx,%edx
f0103ef9:	89 90 30 10 58 f0    	mov    %edx,-0xfa7efd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f0103eff:	e8 d6 2c 00 00       	call   f0106bda <cpunum>
f0103f04:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f07:	66 c7 80 34 10 58 f0 	movw   $0x10,-0xfa7efcc(%eax)
f0103f0e:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f0103f10:	e8 c5 2c 00 00       	call   f0106bda <cpunum>
f0103f15:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f18:	66 c7 80 92 10 58 f0 	movw   $0x68,-0xfa7ef6e(%eax)
f0103f1f:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0103f21:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103f28:	89 fb                	mov    %edi,%ebx
f0103f2a:	c1 fb 03             	sar    $0x3,%ebx
f0103f2d:	e8 a8 2c 00 00       	call   f0106bda <cpunum>
f0103f32:	89 c6                	mov    %eax,%esi
f0103f34:	e8 a1 2c 00 00       	call   f0106bda <cpunum>
f0103f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103f3c:	e8 99 2c 00 00       	call   f0106bda <cpunum>
f0103f41:	66 c7 04 dd 40 83 12 	movw   $0x67,-0xfed7cc0(,%ebx,8)
f0103f48:	f0 67 00 
f0103f4b:	6b f6 74             	imul   $0x74,%esi,%esi
f0103f4e:	81 c6 2c 10 58 f0    	add    $0xf058102c,%esi
f0103f54:	66 89 34 dd 42 83 12 	mov    %si,-0xfed7cbe(,%ebx,8)
f0103f5b:	f0 
f0103f5c:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103f60:	81 c2 2c 10 58 f0    	add    $0xf058102c,%edx
f0103f66:	c1 ea 10             	shr    $0x10,%edx
f0103f69:	88 14 dd 44 83 12 f0 	mov    %dl,-0xfed7cbc(,%ebx,8)
f0103f70:	c6 04 dd 46 83 12 f0 	movb   $0x40,-0xfed7cba(,%ebx,8)
f0103f77:	40 
f0103f78:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f7b:	05 2c 10 58 f0       	add    $0xf058102c,%eax
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
f0103fb0:	66 a3 60 f2 57 f0    	mov    %ax,0xf057f260
f0103fb6:	66 c7 05 62 f2 57 f0 	movw   $0x8,0xf057f262
f0103fbd:	08 00 
f0103fbf:	c6 05 64 f2 57 f0 00 	movb   $0x0,0xf057f264
f0103fc6:	c6 05 65 f2 57 f0 8e 	movb   $0x8e,0xf057f265
f0103fcd:	c1 e8 10             	shr    $0x10,%eax
f0103fd0:	66 a3 66 f2 57 f0    	mov    %ax,0xf057f266
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f0103fd6:	b8 80 4c 10 f0       	mov    $0xf0104c80,%eax
f0103fdb:	66 a3 68 f2 57 f0    	mov    %ax,0xf057f268
f0103fe1:	66 c7 05 6a f2 57 f0 	movw   $0x8,0xf057f26a
f0103fe8:	08 00 
f0103fea:	c6 05 6c f2 57 f0 00 	movb   $0x0,0xf057f26c
f0103ff1:	c6 05 6d f2 57 f0 8e 	movb   $0x8e,0xf057f26d
f0103ff8:	c1 e8 10             	shr    $0x10,%eax
f0103ffb:	66 a3 6e f2 57 f0    	mov    %ax,0xf057f26e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0104001:	b8 8a 4c 10 f0       	mov    $0xf0104c8a,%eax
f0104006:	66 a3 70 f2 57 f0    	mov    %ax,0xf057f270
f010400c:	66 c7 05 72 f2 57 f0 	movw   $0x8,0xf057f272
f0104013:	08 00 
f0104015:	c6 05 74 f2 57 f0 00 	movb   $0x0,0xf057f274
f010401c:	c6 05 75 f2 57 f0 8e 	movb   $0x8e,0xf057f275
f0104023:	c1 e8 10             	shr    $0x10,%eax
f0104026:	66 a3 76 f2 57 f0    	mov    %ax,0xf057f276
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f010402c:	b8 94 4c 10 f0       	mov    $0xf0104c94,%eax
f0104031:	66 a3 78 f2 57 f0    	mov    %ax,0xf057f278
f0104037:	66 c7 05 7a f2 57 f0 	movw   $0x8,0xf057f27a
f010403e:	08 00 
f0104040:	c6 05 7c f2 57 f0 00 	movb   $0x0,0xf057f27c
f0104047:	c6 05 7d f2 57 f0 ee 	movb   $0xee,0xf057f27d
f010404e:	c1 e8 10             	shr    $0x10,%eax
f0104051:	66 a3 7e f2 57 f0    	mov    %ax,0xf057f27e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f0104057:	b8 9e 4c 10 f0       	mov    $0xf0104c9e,%eax
f010405c:	66 a3 80 f2 57 f0    	mov    %ax,0xf057f280
f0104062:	66 c7 05 82 f2 57 f0 	movw   $0x8,0xf057f282
f0104069:	08 00 
f010406b:	c6 05 84 f2 57 f0 00 	movb   $0x0,0xf057f284
f0104072:	c6 05 85 f2 57 f0 ee 	movb   $0xee,0xf057f285
f0104079:	c1 e8 10             	shr    $0x10,%eax
f010407c:	66 a3 86 f2 57 f0    	mov    %ax,0xf057f286
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f0104082:	b8 a8 4c 10 f0       	mov    $0xf0104ca8,%eax
f0104087:	66 a3 88 f2 57 f0    	mov    %ax,0xf057f288
f010408d:	66 c7 05 8a f2 57 f0 	movw   $0x8,0xf057f28a
f0104094:	08 00 
f0104096:	c6 05 8c f2 57 f0 00 	movb   $0x0,0xf057f28c
f010409d:	c6 05 8d f2 57 f0 ee 	movb   $0xee,0xf057f28d
f01040a4:	c1 e8 10             	shr    $0x10,%eax
f01040a7:	66 a3 8e f2 57 f0    	mov    %ax,0xf057f28e
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f01040ad:	b8 b2 4c 10 f0       	mov    $0xf0104cb2,%eax
f01040b2:	66 a3 90 f2 57 f0    	mov    %ax,0xf057f290
f01040b8:	66 c7 05 92 f2 57 f0 	movw   $0x8,0xf057f292
f01040bf:	08 00 
f01040c1:	c6 05 94 f2 57 f0 00 	movb   $0x0,0xf057f294
f01040c8:	c6 05 95 f2 57 f0 8e 	movb   $0x8e,0xf057f295
f01040cf:	c1 e8 10             	shr    $0x10,%eax
f01040d2:	66 a3 96 f2 57 f0    	mov    %ax,0xf057f296
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f01040d8:	b8 bc 4c 10 f0       	mov    $0xf0104cbc,%eax
f01040dd:	66 a3 98 f2 57 f0    	mov    %ax,0xf057f298
f01040e3:	66 c7 05 9a f2 57 f0 	movw   $0x8,0xf057f29a
f01040ea:	08 00 
f01040ec:	c6 05 9c f2 57 f0 00 	movb   $0x0,0xf057f29c
f01040f3:	c6 05 9d f2 57 f0 8e 	movb   $0x8e,0xf057f29d
f01040fa:	c1 e8 10             	shr    $0x10,%eax
f01040fd:	66 a3 9e f2 57 f0    	mov    %ax,0xf057f29e
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f0104103:	b8 c6 4c 10 f0       	mov    $0xf0104cc6,%eax
f0104108:	66 a3 a0 f2 57 f0    	mov    %ax,0xf057f2a0
f010410e:	66 c7 05 a2 f2 57 f0 	movw   $0x8,0xf057f2a2
f0104115:	08 00 
f0104117:	c6 05 a4 f2 57 f0 00 	movb   $0x0,0xf057f2a4
f010411e:	c6 05 a5 f2 57 f0 8e 	movb   $0x8e,0xf057f2a5
f0104125:	c1 e8 10             	shr    $0x10,%eax
f0104128:	66 a3 a6 f2 57 f0    	mov    %ax,0xf057f2a6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f010412e:	b8 ce 4c 10 f0       	mov    $0xf0104cce,%eax
f0104133:	66 a3 b0 f2 57 f0    	mov    %ax,0xf057f2b0
f0104139:	66 c7 05 b2 f2 57 f0 	movw   $0x8,0xf057f2b2
f0104140:	08 00 
f0104142:	c6 05 b4 f2 57 f0 00 	movb   $0x0,0xf057f2b4
f0104149:	c6 05 b5 f2 57 f0 8e 	movb   $0x8e,0xf057f2b5
f0104150:	c1 e8 10             	shr    $0x10,%eax
f0104153:	66 a3 b6 f2 57 f0    	mov    %ax,0xf057f2b6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f0104159:	b8 d6 4c 10 f0       	mov    $0xf0104cd6,%eax
f010415e:	66 a3 b8 f2 57 f0    	mov    %ax,0xf057f2b8
f0104164:	66 c7 05 ba f2 57 f0 	movw   $0x8,0xf057f2ba
f010416b:	08 00 
f010416d:	c6 05 bc f2 57 f0 00 	movb   $0x0,0xf057f2bc
f0104174:	c6 05 bd f2 57 f0 8e 	movb   $0x8e,0xf057f2bd
f010417b:	c1 e8 10             	shr    $0x10,%eax
f010417e:	66 a3 be f2 57 f0    	mov    %ax,0xf057f2be
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f0104184:	b8 de 4c 10 f0       	mov    $0xf0104cde,%eax
f0104189:	66 a3 c0 f2 57 f0    	mov    %ax,0xf057f2c0
f010418f:	66 c7 05 c2 f2 57 f0 	movw   $0x8,0xf057f2c2
f0104196:	08 00 
f0104198:	c6 05 c4 f2 57 f0 00 	movb   $0x0,0xf057f2c4
f010419f:	c6 05 c5 f2 57 f0 8e 	movb   $0x8e,0xf057f2c5
f01041a6:	c1 e8 10             	shr    $0x10,%eax
f01041a9:	66 a3 c6 f2 57 f0    	mov    %ax,0xf057f2c6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f01041af:	b8 e6 4c 10 f0       	mov    $0xf0104ce6,%eax
f01041b4:	66 a3 c8 f2 57 f0    	mov    %ax,0xf057f2c8
f01041ba:	66 c7 05 ca f2 57 f0 	movw   $0x8,0xf057f2ca
f01041c1:	08 00 
f01041c3:	c6 05 cc f2 57 f0 00 	movb   $0x0,0xf057f2cc
f01041ca:	c6 05 cd f2 57 f0 8e 	movb   $0x8e,0xf057f2cd
f01041d1:	c1 e8 10             	shr    $0x10,%eax
f01041d4:	66 a3 ce f2 57 f0    	mov    %ax,0xf057f2ce
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f01041da:	b8 ee 4c 10 f0       	mov    $0xf0104cee,%eax
f01041df:	66 a3 d0 f2 57 f0    	mov    %ax,0xf057f2d0
f01041e5:	66 c7 05 d2 f2 57 f0 	movw   $0x8,0xf057f2d2
f01041ec:	08 00 
f01041ee:	c6 05 d4 f2 57 f0 00 	movb   $0x0,0xf057f2d4
f01041f5:	c6 05 d5 f2 57 f0 8e 	movb   $0x8e,0xf057f2d5
f01041fc:	c1 e8 10             	shr    $0x10,%eax
f01041ff:	66 a3 d6 f2 57 f0    	mov    %ax,0xf057f2d6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f0104205:	b8 f6 4c 10 f0       	mov    $0xf0104cf6,%eax
f010420a:	66 a3 e0 f2 57 f0    	mov    %ax,0xf057f2e0
f0104210:	66 c7 05 e2 f2 57 f0 	movw   $0x8,0xf057f2e2
f0104217:	08 00 
f0104219:	c6 05 e4 f2 57 f0 00 	movb   $0x0,0xf057f2e4
f0104220:	c6 05 e5 f2 57 f0 8e 	movb   $0x8e,0xf057f2e5
f0104227:	c1 e8 10             	shr    $0x10,%eax
f010422a:	66 a3 e6 f2 57 f0    	mov    %ax,0xf057f2e6
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f0104230:	b8 fc 4c 10 f0       	mov    $0xf0104cfc,%eax
f0104235:	66 a3 e8 f2 57 f0    	mov    %ax,0xf057f2e8
f010423b:	66 c7 05 ea f2 57 f0 	movw   $0x8,0xf057f2ea
f0104242:	08 00 
f0104244:	c6 05 ec f2 57 f0 00 	movb   $0x0,0xf057f2ec
f010424b:	c6 05 ed f2 57 f0 8e 	movb   $0x8e,0xf057f2ed
f0104252:	c1 e8 10             	shr    $0x10,%eax
f0104255:	66 a3 ee f2 57 f0    	mov    %ax,0xf057f2ee
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f010425b:	b8 00 4d 10 f0       	mov    $0xf0104d00,%eax
f0104260:	66 a3 f0 f2 57 f0    	mov    %ax,0xf057f2f0
f0104266:	66 c7 05 f2 f2 57 f0 	movw   $0x8,0xf057f2f2
f010426d:	08 00 
f010426f:	c6 05 f4 f2 57 f0 00 	movb   $0x0,0xf057f2f4
f0104276:	c6 05 f5 f2 57 f0 8e 	movb   $0x8e,0xf057f2f5
f010427d:	c1 e8 10             	shr    $0x10,%eax
f0104280:	66 a3 f6 f2 57 f0    	mov    %ax,0xf057f2f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f0104286:	b8 06 4d 10 f0       	mov    $0xf0104d06,%eax
f010428b:	66 a3 f8 f2 57 f0    	mov    %ax,0xf057f2f8
f0104291:	66 c7 05 fa f2 57 f0 	movw   $0x8,0xf057f2fa
f0104298:	08 00 
f010429a:	c6 05 fc f2 57 f0 00 	movb   $0x0,0xf057f2fc
f01042a1:	c6 05 fd f2 57 f0 8e 	movb   $0x8e,0xf057f2fd
f01042a8:	c1 e8 10             	shr    $0x10,%eax
f01042ab:	66 a3 fe f2 57 f0    	mov    %ax,0xf057f2fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f01042b1:	b8 0c 4d 10 f0       	mov    $0xf0104d0c,%eax
f01042b6:	66 a3 e0 f3 57 f0    	mov    %ax,0xf057f3e0
f01042bc:	66 c7 05 e2 f3 57 f0 	movw   $0x8,0xf057f3e2
f01042c3:	08 00 
f01042c5:	c6 05 e4 f3 57 f0 00 	movb   $0x0,0xf057f3e4
f01042cc:	c6 05 e5 f3 57 f0 ee 	movb   $0xee,0xf057f3e5
f01042d3:	c1 e8 10             	shr    $0x10,%eax
f01042d6:	66 a3 e6 f3 57 f0    	mov    %ax,0xf057f3e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f01042dc:	b8 12 4d 10 f0       	mov    $0xf0104d12,%eax
f01042e1:	66 a3 60 f3 57 f0    	mov    %ax,0xf057f360
f01042e7:	66 c7 05 62 f3 57 f0 	movw   $0x8,0xf057f362
f01042ee:	08 00 
f01042f0:	c6 05 64 f3 57 f0 00 	movb   $0x0,0xf057f364
f01042f7:	c6 05 65 f3 57 f0 8e 	movb   $0x8e,0xf057f365
f01042fe:	c1 e8 10             	shr    $0x10,%eax
f0104301:	66 a3 66 f3 57 f0    	mov    %ax,0xf057f366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f0104307:	b8 18 4d 10 f0       	mov    $0xf0104d18,%eax
f010430c:	66 a3 68 f3 57 f0    	mov    %ax,0xf057f368
f0104312:	66 c7 05 6a f3 57 f0 	movw   $0x8,0xf057f36a
f0104319:	08 00 
f010431b:	c6 05 6c f3 57 f0 00 	movb   $0x0,0xf057f36c
f0104322:	c6 05 6d f3 57 f0 8e 	movb   $0x8e,0xf057f36d
f0104329:	c1 e8 10             	shr    $0x10,%eax
f010432c:	66 a3 6e f3 57 f0    	mov    %ax,0xf057f36e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f0104332:	b8 1e 4d 10 f0       	mov    $0xf0104d1e,%eax
f0104337:	66 a3 70 f3 57 f0    	mov    %ax,0xf057f370
f010433d:	66 c7 05 72 f3 57 f0 	movw   $0x8,0xf057f372
f0104344:	08 00 
f0104346:	c6 05 74 f3 57 f0 00 	movb   $0x0,0xf057f374
f010434d:	c6 05 75 f3 57 f0 8e 	movb   $0x8e,0xf057f375
f0104354:	c1 e8 10             	shr    $0x10,%eax
f0104357:	66 a3 76 f3 57 f0    	mov    %ax,0xf057f376
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f010435d:	b8 24 4d 10 f0       	mov    $0xf0104d24,%eax
f0104362:	66 a3 78 f3 57 f0    	mov    %ax,0xf057f378
f0104368:	66 c7 05 7a f3 57 f0 	movw   $0x8,0xf057f37a
f010436f:	08 00 
f0104371:	c6 05 7c f3 57 f0 00 	movb   $0x0,0xf057f37c
f0104378:	c6 05 7d f3 57 f0 8e 	movb   $0x8e,0xf057f37d
f010437f:	c1 e8 10             	shr    $0x10,%eax
f0104382:	66 a3 7e f3 57 f0    	mov    %ax,0xf057f37e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f0104388:	b8 2a 4d 10 f0       	mov    $0xf0104d2a,%eax
f010438d:	66 a3 80 f3 57 f0    	mov    %ax,0xf057f380
f0104393:	66 c7 05 82 f3 57 f0 	movw   $0x8,0xf057f382
f010439a:	08 00 
f010439c:	c6 05 84 f3 57 f0 00 	movb   $0x0,0xf057f384
f01043a3:	c6 05 85 f3 57 f0 8e 	movb   $0x8e,0xf057f385
f01043aa:	c1 e8 10             	shr    $0x10,%eax
f01043ad:	66 a3 86 f3 57 f0    	mov    %ax,0xf057f386
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f01043b3:	b8 30 4d 10 f0       	mov    $0xf0104d30,%eax
f01043b8:	66 a3 88 f3 57 f0    	mov    %ax,0xf057f388
f01043be:	66 c7 05 8a f3 57 f0 	movw   $0x8,0xf057f38a
f01043c5:	08 00 
f01043c7:	c6 05 8c f3 57 f0 00 	movb   $0x0,0xf057f38c
f01043ce:	c6 05 8d f3 57 f0 8e 	movb   $0x8e,0xf057f38d
f01043d5:	c1 e8 10             	shr    $0x10,%eax
f01043d8:	66 a3 8e f3 57 f0    	mov    %ax,0xf057f38e
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f01043de:	b8 36 4d 10 f0       	mov    $0xf0104d36,%eax
f01043e3:	66 a3 90 f3 57 f0    	mov    %ax,0xf057f390
f01043e9:	66 c7 05 92 f3 57 f0 	movw   $0x8,0xf057f392
f01043f0:	08 00 
f01043f2:	c6 05 94 f3 57 f0 00 	movb   $0x0,0xf057f394
f01043f9:	c6 05 95 f3 57 f0 8e 	movb   $0x8e,0xf057f395
f0104400:	c1 e8 10             	shr    $0x10,%eax
f0104403:	66 a3 96 f3 57 f0    	mov    %ax,0xf057f396
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f0104409:	b8 3c 4d 10 f0       	mov    $0xf0104d3c,%eax
f010440e:	66 a3 98 f3 57 f0    	mov    %ax,0xf057f398
f0104414:	66 c7 05 9a f3 57 f0 	movw   $0x8,0xf057f39a
f010441b:	08 00 
f010441d:	c6 05 9c f3 57 f0 00 	movb   $0x0,0xf057f39c
f0104424:	c6 05 9d f3 57 f0 8e 	movb   $0x8e,0xf057f39d
f010442b:	c1 e8 10             	shr    $0x10,%eax
f010442e:	66 a3 9e f3 57 f0    	mov    %ax,0xf057f39e
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f0104434:	b8 42 4d 10 f0       	mov    $0xf0104d42,%eax
f0104439:	66 a3 a0 f3 57 f0    	mov    %ax,0xf057f3a0
f010443f:	66 c7 05 a2 f3 57 f0 	movw   $0x8,0xf057f3a2
f0104446:	08 00 
f0104448:	c6 05 a4 f3 57 f0 00 	movb   $0x0,0xf057f3a4
f010444f:	c6 05 a5 f3 57 f0 8e 	movb   $0x8e,0xf057f3a5
f0104456:	c1 e8 10             	shr    $0x10,%eax
f0104459:	66 a3 a6 f3 57 f0    	mov    %ax,0xf057f3a6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f010445f:	b8 48 4d 10 f0       	mov    $0xf0104d48,%eax
f0104464:	66 a3 a8 f3 57 f0    	mov    %ax,0xf057f3a8
f010446a:	66 c7 05 aa f3 57 f0 	movw   $0x8,0xf057f3aa
f0104471:	08 00 
f0104473:	c6 05 ac f3 57 f0 00 	movb   $0x0,0xf057f3ac
f010447a:	c6 05 ad f3 57 f0 8e 	movb   $0x8e,0xf057f3ad
f0104481:	c1 e8 10             	shr    $0x10,%eax
f0104484:	66 a3 ae f3 57 f0    	mov    %ax,0xf057f3ae
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f010448a:	b8 4e 4d 10 f0       	mov    $0xf0104d4e,%eax
f010448f:	66 a3 b0 f3 57 f0    	mov    %ax,0xf057f3b0
f0104495:	66 c7 05 b2 f3 57 f0 	movw   $0x8,0xf057f3b2
f010449c:	08 00 
f010449e:	c6 05 b4 f3 57 f0 00 	movb   $0x0,0xf057f3b4
f01044a5:	c6 05 b5 f3 57 f0 8e 	movb   $0x8e,0xf057f3b5
f01044ac:	c1 e8 10             	shr    $0x10,%eax
f01044af:	66 a3 b6 f3 57 f0    	mov    %ax,0xf057f3b6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f01044b5:	b8 54 4d 10 f0       	mov    $0xf0104d54,%eax
f01044ba:	66 a3 b8 f3 57 f0    	mov    %ax,0xf057f3b8
f01044c0:	66 c7 05 ba f3 57 f0 	movw   $0x8,0xf057f3ba
f01044c7:	08 00 
f01044c9:	c6 05 bc f3 57 f0 00 	movb   $0x0,0xf057f3bc
f01044d0:	c6 05 bd f3 57 f0 8e 	movb   $0x8e,0xf057f3bd
f01044d7:	c1 e8 10             	shr    $0x10,%eax
f01044da:	66 a3 be f3 57 f0    	mov    %ax,0xf057f3be
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f01044e0:	b8 5a 4d 10 f0       	mov    $0xf0104d5a,%eax
f01044e5:	66 a3 c0 f3 57 f0    	mov    %ax,0xf057f3c0
f01044eb:	66 c7 05 c2 f3 57 f0 	movw   $0x8,0xf057f3c2
f01044f2:	08 00 
f01044f4:	c6 05 c4 f3 57 f0 00 	movb   $0x0,0xf057f3c4
f01044fb:	c6 05 c5 f3 57 f0 8e 	movb   $0x8e,0xf057f3c5
f0104502:	c1 e8 10             	shr    $0x10,%eax
f0104505:	66 a3 c6 f3 57 f0    	mov    %ax,0xf057f3c6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f010450b:	b8 60 4d 10 f0       	mov    $0xf0104d60,%eax
f0104510:	66 a3 c8 f3 57 f0    	mov    %ax,0xf057f3c8
f0104516:	66 c7 05 ca f3 57 f0 	movw   $0x8,0xf057f3ca
f010451d:	08 00 
f010451f:	c6 05 cc f3 57 f0 00 	movb   $0x0,0xf057f3cc
f0104526:	c6 05 cd f3 57 f0 8e 	movb   $0x8e,0xf057f3cd
f010452d:	c1 e8 10             	shr    $0x10,%eax
f0104530:	66 a3 ce f3 57 f0    	mov    %ax,0xf057f3ce
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f0104536:	b8 66 4d 10 f0       	mov    $0xf0104d66,%eax
f010453b:	66 a3 d0 f3 57 f0    	mov    %ax,0xf057f3d0
f0104541:	66 c7 05 d2 f3 57 f0 	movw   $0x8,0xf057f3d2
f0104548:	08 00 
f010454a:	c6 05 d4 f3 57 f0 00 	movb   $0x0,0xf057f3d4
f0104551:	c6 05 d5 f3 57 f0 8e 	movb   $0x8e,0xf057f3d5
f0104558:	c1 e8 10             	shr    $0x10,%eax
f010455b:	66 a3 d6 f3 57 f0    	mov    %ax,0xf057f3d6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f0104561:	b8 6c 4d 10 f0       	mov    $0xf0104d6c,%eax
f0104566:	66 a3 d8 f3 57 f0    	mov    %ax,0xf057f3d8
f010456c:	66 c7 05 da f3 57 f0 	movw   $0x8,0xf057f3da
f0104573:	08 00 
f0104575:	c6 05 dc f3 57 f0 00 	movb   $0x0,0xf057f3dc
f010457c:	c6 05 dd f3 57 f0 8e 	movb   $0x8e,0xf057f3dd
f0104583:	c1 e8 10             	shr    $0x10,%eax
f0104586:	66 a3 de f3 57 f0    	mov    %ax,0xf057f3de
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f010458c:	b8 72 4d 10 f0       	mov    $0xf0104d72,%eax
f0104591:	66 a3 f8 f3 57 f0    	mov    %ax,0xf057f3f8
f0104597:	66 c7 05 fa f3 57 f0 	movw   $0x8,0xf057f3fa
f010459e:	08 00 
f01045a0:	c6 05 fc f3 57 f0 00 	movb   $0x0,0xf057f3fc
f01045a7:	c6 05 fd f3 57 f0 8e 	movb   $0x8e,0xf057f3fd
f01045ae:	c1 e8 10             	shr    $0x10,%eax
f01045b1:	66 a3 fe f3 57 f0    	mov    %ax,0xf057f3fe
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
f01045ca:	68 9b 92 10 f0       	push   $0xf010929b
f01045cf:	e8 ed f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01045d4:	83 c4 08             	add    $0x8,%esp
f01045d7:	ff 73 04             	pushl  0x4(%ebx)
f01045da:	68 aa 92 10 f0       	push   $0xf01092aa
f01045df:	e8 dd f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01045e4:	83 c4 08             	add    $0x8,%esp
f01045e7:	ff 73 08             	pushl  0x8(%ebx)
f01045ea:	68 b9 92 10 f0       	push   $0xf01092b9
f01045ef:	e8 cd f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01045f4:	83 c4 08             	add    $0x8,%esp
f01045f7:	ff 73 0c             	pushl  0xc(%ebx)
f01045fa:	68 c8 92 10 f0       	push   $0xf01092c8
f01045ff:	e8 bd f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104604:	83 c4 08             	add    $0x8,%esp
f0104607:	ff 73 10             	pushl  0x10(%ebx)
f010460a:	68 d7 92 10 f0       	push   $0xf01092d7
f010460f:	e8 ad f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104614:	83 c4 08             	add    $0x8,%esp
f0104617:	ff 73 14             	pushl  0x14(%ebx)
f010461a:	68 e6 92 10 f0       	push   $0xf01092e6
f010461f:	e8 9d f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104624:	83 c4 08             	add    $0x8,%esp
f0104627:	ff 73 18             	pushl  0x18(%ebx)
f010462a:	68 f5 92 10 f0       	push   $0xf01092f5
f010462f:	e8 8d f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104634:	83 c4 08             	add    $0x8,%esp
f0104637:	ff 73 1c             	pushl  0x1c(%ebx)
f010463a:	68 04 93 10 f0       	push   $0xf0109304
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
f0104654:	e8 81 25 00 00       	call   f0106bda <cpunum>
f0104659:	83 ec 04             	sub    $0x4,%esp
f010465c:	50                   	push   %eax
f010465d:	53                   	push   %ebx
f010465e:	68 68 93 10 f0       	push   $0xf0109368
f0104663:	e8 59 f8 ff ff       	call   f0103ec1 <cprintf>
	print_regs(&tf->tf_regs);
f0104668:	89 1c 24             	mov    %ebx,(%esp)
f010466b:	e8 4e ff ff ff       	call   f01045be <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104670:	83 c4 08             	add    $0x8,%esp
f0104673:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104677:	50                   	push   %eax
f0104678:	68 86 93 10 f0       	push   $0xf0109386
f010467d:	e8 3f f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104682:	83 c4 08             	add    $0x8,%esp
f0104685:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104689:	50                   	push   %eax
f010468a:	68 99 93 10 f0       	push   $0xf0109399
f010468f:	e8 2d f8 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104694:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104697:	83 c4 10             	add    $0x10,%esp
f010469a:	83 f8 13             	cmp    $0x13,%eax
f010469d:	0f 86 e1 00 00 00    	jbe    f0104784 <print_trapframe+0x138>
		return "System call";
f01046a3:	ba 13 93 10 f0       	mov    $0xf0109313,%edx
	if (trapno == T_SYSCALL)
f01046a8:	83 f8 30             	cmp    $0x30,%eax
f01046ab:	74 13                	je     f01046c0 <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01046ad:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01046b0:	83 fa 0f             	cmp    $0xf,%edx
f01046b3:	ba 1f 93 10 f0       	mov    $0xf010931f,%edx
f01046b8:	b9 2e 93 10 f0       	mov    $0xf010932e,%ecx
f01046bd:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01046c0:	83 ec 04             	sub    $0x4,%esp
f01046c3:	52                   	push   %edx
f01046c4:	50                   	push   %eax
f01046c5:	68 ac 93 10 f0       	push   $0xf01093ac
f01046ca:	e8 f2 f7 ff ff       	call   f0103ec1 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01046cf:	83 c4 10             	add    $0x10,%esp
f01046d2:	39 1d 60 fa 57 f0    	cmp    %ebx,0xf057fa60
f01046d8:	0f 84 b2 00 00 00    	je     f0104790 <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f01046de:	83 ec 08             	sub    $0x8,%esp
f01046e1:	ff 73 2c             	pushl  0x2c(%ebx)
f01046e4:	68 cd 93 10 f0       	push   $0xf01093cd
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
f0104703:	b9 41 93 10 f0       	mov    $0xf0109341,%ecx
f0104708:	ba 4c 93 10 f0       	mov    $0xf010934c,%edx
f010470d:	0f 44 ca             	cmove  %edx,%ecx
f0104710:	89 c2                	mov    %eax,%edx
f0104712:	83 e2 02             	and    $0x2,%edx
f0104715:	be 58 93 10 f0       	mov    $0xf0109358,%esi
f010471a:	ba 5e 93 10 f0       	mov    $0xf010935e,%edx
f010471f:	0f 45 d6             	cmovne %esi,%edx
f0104722:	83 e0 04             	and    $0x4,%eax
f0104725:	b8 63 93 10 f0       	mov    $0xf0109363,%eax
f010472a:	be b0 95 10 f0       	mov    $0xf01095b0,%esi
f010472f:	0f 44 c6             	cmove  %esi,%eax
f0104732:	51                   	push   %ecx
f0104733:	52                   	push   %edx
f0104734:	50                   	push   %eax
f0104735:	68 db 93 10 f0       	push   $0xf01093db
f010473a:	e8 82 f7 ff ff       	call   f0103ec1 <cprintf>
f010473f:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104742:	83 ec 08             	sub    $0x8,%esp
f0104745:	ff 73 30             	pushl  0x30(%ebx)
f0104748:	68 ea 93 10 f0       	push   $0xf01093ea
f010474d:	e8 6f f7 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104752:	83 c4 08             	add    $0x8,%esp
f0104755:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104759:	50                   	push   %eax
f010475a:	68 f9 93 10 f0       	push   $0xf01093f9
f010475f:	e8 5d f7 ff ff       	call   f0103ec1 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104764:	83 c4 08             	add    $0x8,%esp
f0104767:	ff 73 38             	pushl  0x38(%ebx)
f010476a:	68 0c 94 10 f0       	push   $0xf010940c
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
f0104784:	8b 14 85 00 98 10 f0 	mov    -0xfef6800(,%eax,4),%edx
f010478b:	e9 30 ff ff ff       	jmp    f01046c0 <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104790:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104794:	0f 85 44 ff ff ff    	jne    f01046de <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f010479a:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010479d:	83 ec 08             	sub    $0x8,%esp
f01047a0:	50                   	push   %eax
f01047a1:	68 be 93 10 f0       	push   $0xf01093be
f01047a6:	e8 16 f7 ff ff       	call   f0103ec1 <cprintf>
f01047ab:	83 c4 10             	add    $0x10,%esp
f01047ae:	e9 2b ff ff ff       	jmp    f01046de <print_trapframe+0x92>
		cprintf("\n");
f01047b3:	83 ec 0c             	sub    $0xc,%esp
f01047b6:	68 1b 91 10 f0       	push   $0xf010911b
f01047bb:	e8 01 f7 ff ff       	call   f0103ec1 <cprintf>
f01047c0:	83 c4 10             	add    $0x10,%esp
f01047c3:	e9 7a ff ff ff       	jmp    f0104742 <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f01047c8:	83 ec 08             	sub    $0x8,%esp
f01047cb:	ff 73 3c             	pushl  0x3c(%ebx)
f01047ce:	68 1b 94 10 f0       	push   $0xf010941b
f01047d3:	e8 e9 f6 ff ff       	call   f0103ec1 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01047d8:	83 c4 08             	add    $0x8,%esp
f01047db:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01047df:	50                   	push   %eax
f01047e0:	68 2a 94 10 f0       	push   $0xf010942a
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
f010480b:	e8 ca 23 00 00       	call   f0106bda <cpunum>
f0104810:	6b c0 74             	imul   $0x74,%eax,%eax
f0104813:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104819:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010481d:	75 69                	jne    f0104888 <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010481f:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f0104822:	e8 b3 23 00 00       	call   f0106bda <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104827:	57                   	push   %edi
f0104828:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f0104829:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010482c:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104832:	ff 70 48             	pushl  0x48(%eax)
f0104835:	68 fc 96 10 f0       	push   $0xf01096fc
f010483a:	e8 82 f6 ff ff       	call   f0103ec1 <cprintf>
	print_trapframe(tf);
f010483f:	89 1c 24             	mov    %ebx,(%esp)
f0104842:	e8 05 fe ff ff       	call   f010464c <print_trapframe>
	env_destroy(curenv);
f0104847:	e8 8e 23 00 00       	call   f0106bda <cpunum>
f010484c:	83 c4 04             	add    $0x4,%esp
f010484f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104852:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
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
f0104874:	68 3d 94 10 f0       	push   $0xf010943d
f0104879:	68 c1 01 00 00       	push   $0x1c1
f010487e:	68 59 94 10 f0       	push   $0xf0109459
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
f01048a3:	e8 32 23 00 00       	call   f0106bda <cpunum>
f01048a8:	6a 02                	push   $0x2
f01048aa:	6a 34                	push   $0x34
f01048ac:	57                   	push   %edi
f01048ad:	6b c0 74             	imul   $0x74,%eax,%eax
f01048b0:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
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
f01048e5:	e8 f0 22 00 00       	call   f0106bda <cpunum>
f01048ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01048ed:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01048f3:	8b 58 64             	mov    0x64(%eax),%ebx
f01048f6:	e8 df 22 00 00       	call   f0106bda <cpunum>
f01048fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01048fe:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104904:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104907:	e8 ce 22 00 00       	call   f0106bda <cpunum>
f010490c:	6b c0 74             	imul   $0x74,%eax,%eax
f010490f:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104915:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104918:	e8 bd 22 00 00       	call   f0106bda <cpunum>
f010491d:	83 c4 04             	add    $0x4,%esp
f0104920:	6b c0 74             	imul   $0x74,%eax,%eax
f0104923:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
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
f0104937:	83 3d a0 0e 58 f0 00 	cmpl   $0x0,0xf0580ea0
f010493e:	74 01                	je     f0104941 <trap+0x13>
		asm volatile("hlt");
f0104940:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104941:	e8 94 22 00 00       	call   f0106bda <cpunum>
f0104946:	6b d0 74             	imul   $0x74,%eax,%edx
f0104949:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010494c:	b8 01 00 00 00       	mov    $0x1,%eax
f0104951:	f0 87 82 20 10 58 f0 	lock xchg %eax,-0xfa7efe0(%edx)
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
f0104971:	89 35 60 fa 57 f0    	mov    %esi,0xf057fa60
	switch (tf->tf_trapno)
f0104977:	8b 46 28             	mov    0x28(%esi),%eax
f010497a:	83 e8 03             	sub    $0x3,%eax
f010497d:	83 f8 30             	cmp    $0x30,%eax
f0104980:	0f 87 92 02 00 00    	ja     f0104c18 <trap+0x2ea>
f0104986:	ff 24 85 20 97 10 f0 	jmp    *-0xfef68e0(,%eax,4)
	spin_lock(&kernel_lock);
f010498d:	83 ec 0c             	sub    $0xc,%esp
f0104990:	68 c0 83 12 f0       	push   $0xf01283c0
f0104995:	e8 b0 24 00 00       	call   f0106e4a <spin_lock>
f010499a:	83 c4 10             	add    $0x10,%esp
f010499d:	eb be                	jmp    f010495d <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f010499f:	68 65 94 10 f0       	push   $0xf0109465
f01049a4:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01049a9:	68 8c 01 00 00       	push   $0x18c
f01049ae:	68 59 94 10 f0       	push   $0xf0109459
f01049b3:	e8 91 b6 ff ff       	call   f0100049 <_panic>
f01049b8:	83 ec 0c             	sub    $0xc,%esp
f01049bb:	68 c0 83 12 f0       	push   $0xf01283c0
f01049c0:	e8 85 24 00 00       	call   f0106e4a <spin_lock>
		assert(curenv);
f01049c5:	e8 10 22 00 00       	call   f0106bda <cpunum>
f01049ca:	6b c0 74             	imul   $0x74,%eax,%eax
f01049cd:	83 c4 10             	add    $0x10,%esp
f01049d0:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f01049d7:	74 3e                	je     f0104a17 <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f01049d9:	e8 fc 21 00 00       	call   f0106bda <cpunum>
f01049de:	6b c0 74             	imul   $0x74,%eax,%eax
f01049e1:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01049e7:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01049eb:	74 43                	je     f0104a30 <trap+0x102>
		curenv->env_tf = *tf;
f01049ed:	e8 e8 21 00 00       	call   f0106bda <cpunum>
f01049f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01049f5:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01049fb:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a00:	89 c7                	mov    %eax,%edi
f0104a02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104a04:	e8 d1 21 00 00       	call   f0106bda <cpunum>
f0104a09:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a0c:	8b b0 28 10 58 f0    	mov    -0xfa7efd8(%eax),%esi
f0104a12:	e9 5a ff ff ff       	jmp    f0104971 <trap+0x43>
		assert(curenv);
f0104a17:	68 7e 94 10 f0       	push   $0xf010947e
f0104a1c:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0104a21:	68 93 01 00 00       	push   $0x193
f0104a26:	68 59 94 10 f0       	push   $0xf0109459
f0104a2b:	e8 19 b6 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f0104a30:	e8 a5 21 00 00       	call   f0106bda <cpunum>
f0104a35:	83 ec 0c             	sub    $0xc,%esp
f0104a38:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a3b:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104a41:	e8 27 ef ff ff       	call   f010396d <env_free>
			curenv = NULL;
f0104a46:	e8 8f 21 00 00       	call   f0106bda <cpunum>
f0104a4b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a4e:	c7 80 28 10 58 f0 00 	movl   $0x0,-0xfa7efd8(%eax)
f0104a55:	00 00 00 
			sched_yield();
f0104a58:	e8 11 04 00 00       	call   f0104e6e <sched_yield>
			page_fault_handler(tf);
f0104a5d:	83 ec 0c             	sub    $0xc,%esp
f0104a60:	56                   	push   %esi
f0104a61:	e8 89 fd ff ff       	call   f01047ef <page_fault_handler>
f0104a66:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104a69:	e8 6c 21 00 00       	call   f0106bda <cpunum>
f0104a6e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a71:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f0104a78:	74 18                	je     f0104a92 <trap+0x164>
f0104a7a:	e8 5b 21 00 00       	call   f0106bda <cpunum>
f0104a7f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a82:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
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
f0104ab9:	e8 01 05 00 00       	call   f0104fbf <syscall>
f0104abe:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104ac1:	83 c4 20             	add    $0x20,%esp
f0104ac4:	eb a3                	jmp    f0104a69 <trap+0x13b>
			time_tick();
f0104ac6:	e8 b0 2e 00 00       	call   f010797b <time_tick>
			lapic_eoi();
f0104acb:	e8 51 22 00 00       	call   f0106d21 <lapic_eoi>
			sched_yield();
f0104ad0:	e8 99 03 00 00       	call   f0104e6e <sched_yield>
			kbd_intr();
f0104ad5:	e8 3e bb ff ff       	call   f0100618 <kbd_intr>
f0104ada:	eb 8d                	jmp    f0104a69 <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f0104adc:	83 ec 0c             	sub    $0xc,%esp
f0104adf:	68 20 95 10 f0       	push   $0xf0109520
f0104ae4:	e8 d8 f3 ff ff       	call   f0103ec1 <cprintf>
f0104ae9:	83 c4 10             	add    $0x10,%esp
f0104aec:	e9 78 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f0104af1:	83 ec 0c             	sub    $0xc,%esp
f0104af4:	68 37 95 10 f0       	push   $0xf0109537
f0104af9:	e8 c3 f3 ff ff       	call   f0103ec1 <cprintf>
f0104afe:	83 c4 10             	add    $0x10,%esp
f0104b01:	e9 63 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			serial_intr();
f0104b06:	e8 f1 ba ff ff       	call   f01005fc <serial_intr>
f0104b0b:	e9 59 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f0104b10:	83 ec 0c             	sub    $0xc,%esp
f0104b13:	68 6a 95 10 f0       	push   $0xf010956a
f0104b18:	e8 a4 f3 ff ff       	call   f0103ec1 <cprintf>
f0104b1d:	83 c4 10             	add    $0x10,%esp
f0104b20:	e9 44 ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f0104b25:	83 ec 0c             	sub    $0xc,%esp
f0104b28:	68 85 94 10 f0       	push   $0xf0109485
f0104b2d:	e8 8f f3 ff ff       	call   f0103ec1 <cprintf>
f0104b32:	83 c4 10             	add    $0x10,%esp
f0104b35:	e9 2f ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("in Spurious\n");
f0104b3a:	83 ec 0c             	sub    $0xc,%esp
f0104b3d:	68 9b 94 10 f0       	push   $0xf010949b
f0104b42:	e8 7a f3 ff ff       	call   f0103ec1 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104b47:	c7 04 24 a8 94 10 f0 	movl   $0xf01094a8,(%esp)
f0104b4e:	e8 6e f3 ff ff       	call   f0103ec1 <cprintf>
f0104b53:	83 c4 10             	add    $0x10,%esp
f0104b56:	e9 0e ff ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104b5b:	83 ec 0c             	sub    $0xc,%esp
f0104b5e:	68 c5 94 10 f0       	push   $0xf01094c5
f0104b63:	e8 59 f3 ff ff       	call   f0103ec1 <cprintf>
f0104b68:	83 c4 10             	add    $0x10,%esp
f0104b6b:	e9 f9 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104b70:	83 ec 0c             	sub    $0xc,%esp
f0104b73:	68 db 94 10 f0       	push   $0xf01094db
f0104b78:	e8 44 f3 ff ff       	call   f0103ec1 <cprintf>
f0104b7d:	83 c4 10             	add    $0x10,%esp
f0104b80:	e9 e4 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104b85:	83 ec 0c             	sub    $0xc,%esp
f0104b88:	68 f1 94 10 f0       	push   $0xf01094f1
f0104b8d:	e8 2f f3 ff ff       	call   f0103ec1 <cprintf>
f0104b92:	83 c4 10             	add    $0x10,%esp
f0104b95:	e9 cf fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104b9a:	83 ec 0c             	sub    $0xc,%esp
f0104b9d:	68 08 95 10 f0       	push   $0xf0109508
f0104ba2:	e8 1a f3 ff ff       	call   f0103ec1 <cprintf>
f0104ba7:	83 c4 10             	add    $0x10,%esp
f0104baa:	e9 ba fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104baf:	83 ec 0c             	sub    $0xc,%esp
f0104bb2:	68 1f 95 10 f0       	push   $0xf010951f
f0104bb7:	e8 05 f3 ff ff       	call   f0103ec1 <cprintf>
f0104bbc:	83 c4 10             	add    $0x10,%esp
f0104bbf:	e9 a5 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104bc4:	83 ec 0c             	sub    $0xc,%esp
f0104bc7:	68 36 95 10 f0       	push   $0xf0109536
f0104bcc:	e8 f0 f2 ff ff       	call   f0103ec1 <cprintf>
f0104bd1:	83 c4 10             	add    $0x10,%esp
f0104bd4:	e9 90 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104bd9:	83 ec 0c             	sub    $0xc,%esp
f0104bdc:	68 4d 95 10 f0       	push   $0xf010954d
f0104be1:	e8 db f2 ff ff       	call   f0103ec1 <cprintf>
f0104be6:	83 c4 10             	add    $0x10,%esp
f0104be9:	e9 7b fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104bee:	83 ec 0c             	sub    $0xc,%esp
f0104bf1:	68 69 95 10 f0       	push   $0xf0109569
f0104bf6:	e8 c6 f2 ff ff       	call   f0103ec1 <cprintf>
f0104bfb:	83 c4 10             	add    $0x10,%esp
f0104bfe:	e9 66 fe ff ff       	jmp    f0104a69 <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104c03:	83 ec 0c             	sub    $0xc,%esp
f0104c06:	68 80 95 10 f0       	push   $0xf0109580
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
f0104c2b:	e8 aa 1f 00 00       	call   f0106bda <cpunum>
f0104c30:	83 ec 0c             	sub    $0xc,%esp
f0104c33:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c36:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104c3c:	e8 19 ef ff ff       	call   f0103b5a <env_destroy>
f0104c41:	83 c4 10             	add    $0x10,%esp
f0104c44:	e9 20 fe ff ff       	jmp    f0104a69 <trap+0x13b>
				panic("unhandled trap in kernel");
f0104c49:	83 ec 04             	sub    $0x4,%esp
f0104c4c:	68 9e 95 10 f0       	push   $0xf010959e
f0104c51:	68 6f 01 00 00       	push   $0x16f
f0104c56:	68 59 94 10 f0       	push   $0xf0109459
f0104c5b:	e8 e9 b3 ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f0104c60:	e8 75 1f 00 00       	call   f0106bda <cpunum>
f0104c65:	83 ec 0c             	sub    $0xc,%esp
f0104c68:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c6b:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
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
f0104d98:	e8 22 02 00 00       	call   f0104fbf <syscall>
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
f0104da9:	8b 0d 44 f2 57 f0    	mov    0xf057f244,%ecx
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
f0104dd2:	68 50 98 10 f0       	push   $0xf0109850
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
f0104dee:	e8 e7 1d 00 00       	call   f0106bda <cpunum>
f0104df3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104df6:	c7 80 28 10 58 f0 00 	movl   $0x0,-0xfa7efd8(%eax)
f0104dfd:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104e00:	a1 ac 0e 58 f0       	mov    0xf0580eac,%eax
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
f0104e14:	e8 c1 1d 00 00       	call   f0106bda <cpunum>
f0104e19:	6b d0 74             	imul   $0x74,%eax,%edx
f0104e1c:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104e1f:	b8 02 00 00 00       	mov    $0x2,%eax
f0104e24:	f0 87 82 20 10 58 f0 	lock xchg %eax,-0xfa7efe0(%edx)
	spin_unlock(&kernel_lock);
f0104e2b:	83 ec 0c             	sub    $0xc,%esp
f0104e2e:	68 c0 83 12 f0       	push   $0xf01283c0
f0104e33:	e8 ae 20 00 00       	call   f0106ee6 <spin_unlock>
	asm volatile("pause");
f0104e38:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104e3a:	e8 9b 1d 00 00       	call   f0106bda <cpunum>
f0104e3f:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104e42:	8b 80 30 10 58 f0    	mov    -0xfa7efd0(%eax),%eax
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
f0104e5d:	68 98 7c 10 f0       	push   $0xf0107c98
f0104e62:	6a 4c                	push   $0x4c
f0104e64:	68 79 98 10 f0       	push   $0xf0109879
f0104e69:	e8 db b1 ff ff       	call   f0100049 <_panic>

f0104e6e <sched_yield>:
{
f0104e6e:	55                   	push   %ebp
f0104e6f:	89 e5                	mov    %esp,%ebp
f0104e71:	53                   	push   %ebx
f0104e72:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f0104e75:	e8 60 1d 00 00       	call   f0106bda <cpunum>
f0104e7a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e7d:	83 b8 28 10 58 f0 00 	cmpl   $0x0,-0xfa7efd8(%eax)
f0104e84:	74 7d                	je     f0104f03 <sched_yield+0x95>
		envid_t cur_tone = ENVX(curenv->env_id);
f0104e86:	e8 4f 1d 00 00       	call   f0106bda <cpunum>
f0104e8b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e8e:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104e94:	8b 48 48             	mov    0x48(%eax),%ecx
f0104e97:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104e9d:	8d 41 01             	lea    0x1(%ecx),%eax
f0104ea0:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104ea5:	8b 1d 44 f2 57 f0    	mov    0xf057f244,%ebx
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
f0104ecf:	e8 06 1d 00 00       	call   f0106bda <cpunum>
f0104ed4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ed7:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0104edd:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104ee1:	74 0a                	je     f0104eed <sched_yield+0x7f>
	sched_halt();
f0104ee3:	e8 bb fe ff ff       	call   f0104da3 <sched_halt>
}
f0104ee8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104eeb:	c9                   	leave  
f0104eec:	c3                   	ret    
			env_run(curenv);
f0104eed:	e8 e8 1c 00 00       	call   f0106bda <cpunum>
f0104ef2:	83 ec 0c             	sub    $0xc,%esp
f0104ef5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ef8:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104efe:	e8 f6 ec ff ff       	call   f0103bf9 <env_run>
f0104f03:	a1 44 f2 57 f0       	mov    0xf057f244,%eax
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
f0104f29:	57                   	push   %edi
f0104f2a:	56                   	push   %esi
f0104f2b:	53                   	push   %ebx
f0104f2c:	83 ec 0c             	sub    $0xc,%esp
f0104f2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104f32:	8b 75 0c             	mov    0xc(%ebp),%esi
	// if(r < 0)
	// 	return r;
	// return 0;

	int r;
	if((r = user_mem_check(curenv, buf, len, PTE_W|PTE_U)) < 0){
f0104f35:	e8 a0 1c 00 00       	call   f0106bda <cpunum>
f0104f3a:	6a 06                	push   $0x6
f0104f3c:	56                   	push   %esi
f0104f3d:	53                   	push   %ebx
f0104f3e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f41:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104f47:	e8 68 e4 ff ff       	call   f01033b4 <user_mem_check>
f0104f4c:	83 c4 10             	add    $0x10,%esp
f0104f4f:	85 c0                	test   %eax,%eax
f0104f51:	78 19                	js     f0104f6c <sys_net_send+0x46>
		cprintf("address:%x\n", (uint32_t)buf);
		return r;
	}
	return e1000_tx(buf, len);
f0104f53:	83 ec 08             	sub    $0x8,%esp
f0104f56:	56                   	push   %esi
f0104f57:	53                   	push   %ebx
f0104f58:	e8 72 23 00 00       	call   f01072cf <e1000_tx>
f0104f5d:	89 c7                	mov    %eax,%edi
f0104f5f:	83 c4 10             	add    $0x10,%esp

}
f0104f62:	89 f8                	mov    %edi,%eax
f0104f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104f67:	5b                   	pop    %ebx
f0104f68:	5e                   	pop    %esi
f0104f69:	5f                   	pop    %edi
f0104f6a:	5d                   	pop    %ebp
f0104f6b:	c3                   	ret    
f0104f6c:	89 c7                	mov    %eax,%edi
		cprintf("address:%x\n", (uint32_t)buf);
f0104f6e:	83 ec 08             	sub    $0x8,%esp
f0104f71:	53                   	push   %ebx
f0104f72:	68 86 98 10 f0       	push   $0xf0109886
f0104f77:	e8 45 ef ff ff       	call   f0103ec1 <cprintf>
		return r;
f0104f7c:	83 c4 10             	add    $0x10,%esp
f0104f7f:	eb e1                	jmp    f0104f62 <sys_net_send+0x3c>

f0104f81 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
f0104f81:	55                   	push   %ebp
f0104f82:	89 e5                	mov    %esp,%ebp
f0104f84:	53                   	push   %ebx
f0104f85:	83 ec 04             	sub    $0x4,%esp
f0104f88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 6: Your code here.
	// Check the user permission to [buf, buf + len]
	// Call e1000_rx to fill the buffer
	// Hint: e1000_rx only accept kernel virtual address
	user_mem_assert(curenv, ROUNDDOWN(buf, PGSIZE), PGSIZE, PTE_U | PTE_W);   // check permission
f0104f8b:	e8 4a 1c 00 00       	call   f0106bda <cpunum>
f0104f90:	6a 06                	push   $0x6
f0104f92:	68 00 10 00 00       	push   $0x1000
f0104f97:	89 da                	mov    %ebx,%edx
f0104f99:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0104f9f:	52                   	push   %edx
f0104fa0:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fa3:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104fa9:	e8 ae e4 ff ff       	call   f010345c <user_mem_assert>
  	return e1000_rx(buf,len);
f0104fae:	83 c4 08             	add    $0x8,%esp
f0104fb1:	ff 75 0c             	pushl  0xc(%ebp)
f0104fb4:	53                   	push   %ebx
f0104fb5:	e8 fc 23 00 00       	call   f01073b6 <e1000_rx>
}
f0104fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104fbd:	c9                   	leave  
f0104fbe:	c3                   	ret    

f0104fbf <syscall>:
	return 0;
}
// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104fbf:	55                   	push   %ebp
f0104fc0:	89 e5                	mov    %esp,%ebp
f0104fc2:	57                   	push   %edi
f0104fc3:	56                   	push   %esi
f0104fc4:	53                   	push   %ebx
f0104fc5:	83 ec 1c             	sub    $0x1c,%esp
f0104fc8:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	int ret = 0;
	switch (syscallno)
f0104fcb:	83 f8 14             	cmp    $0x14,%eax
f0104fce:	0f 87 94 08 00 00    	ja     f0105868 <syscall+0x8a9>
f0104fd4:	ff 24 85 54 99 10 f0 	jmp    *-0xfef66ac(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f0104fdb:	e8 fa 1b 00 00       	call   f0106bda <cpunum>
f0104fe0:	6a 04                	push   $0x4
f0104fe2:	ff 75 10             	pushl  0x10(%ebp)
f0104fe5:	ff 75 0c             	pushl  0xc(%ebp)
f0104fe8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104feb:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0104ff1:	e8 66 e4 ff ff       	call   f010345c <user_mem_assert>
	cprintf("%.*s", len, s);
f0104ff6:	83 c4 0c             	add    $0xc,%esp
f0104ff9:	ff 75 0c             	pushl  0xc(%ebp)
f0104ffc:	ff 75 10             	pushl  0x10(%ebp)
f0104fff:	68 92 98 10 f0       	push   $0xf0109892
f0105004:	e8 b8 ee ff ff       	call   f0103ec1 <cprintf>
f0105009:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f010500c:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f0105011:	89 d8                	mov    %ebx,%eax
f0105013:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105016:	5b                   	pop    %ebx
f0105017:	5e                   	pop    %esi
f0105018:	5f                   	pop    %edi
f0105019:	5d                   	pop    %ebp
f010501a:	c3                   	ret    
	return cons_getc();
f010501b:	e8 0a b6 ff ff       	call   f010062a <cons_getc>
f0105020:	89 c3                	mov    %eax,%ebx
			break;
f0105022:	eb ed                	jmp    f0105011 <syscall+0x52>
	return curenv->env_id;
f0105024:	e8 b1 1b 00 00       	call   f0106bda <cpunum>
f0105029:	6b c0 74             	imul   $0x74,%eax,%eax
f010502c:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105032:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0105035:	eb da                	jmp    f0105011 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0105037:	83 ec 04             	sub    $0x4,%esp
f010503a:	6a 01                	push   $0x1
f010503c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010503f:	50                   	push   %eax
f0105040:	ff 75 0c             	pushl  0xc(%ebp)
f0105043:	e8 e6 e4 ff ff       	call   f010352e <envid2env>
f0105048:	89 c3                	mov    %eax,%ebx
f010504a:	83 c4 10             	add    $0x10,%esp
f010504d:	85 c0                	test   %eax,%eax
f010504f:	78 c0                	js     f0105011 <syscall+0x52>
	if (e == curenv)
f0105051:	e8 84 1b 00 00       	call   f0106bda <cpunum>
f0105056:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105059:	6b c0 74             	imul   $0x74,%eax,%eax
f010505c:	39 90 28 10 58 f0    	cmp    %edx,-0xfa7efd8(%eax)
f0105062:	74 3d                	je     f01050a1 <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0105064:	8b 5a 48             	mov    0x48(%edx),%ebx
f0105067:	e8 6e 1b 00 00       	call   f0106bda <cpunum>
f010506c:	83 ec 04             	sub    $0x4,%esp
f010506f:	53                   	push   %ebx
f0105070:	6b c0 74             	imul   $0x74,%eax,%eax
f0105073:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105079:	ff 70 48             	pushl  0x48(%eax)
f010507c:	68 b2 98 10 f0       	push   $0xf01098b2
f0105081:	e8 3b ee ff ff       	call   f0103ec1 <cprintf>
f0105086:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0105089:	83 ec 0c             	sub    $0xc,%esp
f010508c:	ff 75 e4             	pushl  -0x1c(%ebp)
f010508f:	e8 c6 ea ff ff       	call   f0103b5a <env_destroy>
f0105094:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105097:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f010509c:	e9 70 ff ff ff       	jmp    f0105011 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01050a1:	e8 34 1b 00 00       	call   f0106bda <cpunum>
f01050a6:	83 ec 08             	sub    $0x8,%esp
f01050a9:	6b c0 74             	imul   $0x74,%eax,%eax
f01050ac:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01050b2:	ff 70 48             	pushl  0x48(%eax)
f01050b5:	68 97 98 10 f0       	push   $0xf0109897
f01050ba:	e8 02 ee ff ff       	call   f0103ec1 <cprintf>
f01050bf:	83 c4 10             	add    $0x10,%esp
f01050c2:	eb c5                	jmp    f0105089 <syscall+0xca>
	if ((uint32_t)kva < KERNBASE)
f01050c4:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f01050cb:	76 4a                	jbe    f0105117 <syscall+0x158>
	return (physaddr_t)kva - KERNBASE;
f01050cd:	8b 45 0c             	mov    0xc(%ebp),%eax
f01050d0:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01050d5:	c1 e8 0c             	shr    $0xc,%eax
f01050d8:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f01050de:	73 4e                	jae    f010512e <syscall+0x16f>
	return &pages[PGNUM(pa)];
f01050e0:	8b 15 b0 0e 58 f0    	mov    0xf0580eb0,%edx
f01050e6:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f01050e9:	85 db                	test   %ebx,%ebx
f01050eb:	0f 84 81 07 00 00    	je     f0105872 <syscall+0x8b3>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f01050f1:	e8 e4 1a 00 00       	call   f0106bda <cpunum>
f01050f6:	6a 06                	push   $0x6
f01050f8:	ff 75 10             	pushl  0x10(%ebp)
f01050fb:	53                   	push   %ebx
f01050fc:	6b c0 74             	imul   $0x74,%eax,%eax
f01050ff:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105105:	ff 70 60             	pushl  0x60(%eax)
f0105108:	e8 f3 c4 ff ff       	call   f0101600 <page_insert>
f010510d:	89 c3                	mov    %eax,%ebx
f010510f:	83 c4 10             	add    $0x10,%esp
f0105112:	e9 fa fe ff ff       	jmp    f0105011 <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0105117:	ff 75 0c             	pushl  0xc(%ebp)
f010511a:	68 98 7c 10 f0       	push   $0xf0107c98
f010511f:	68 af 01 00 00       	push   $0x1af
f0105124:	68 ca 98 10 f0       	push   $0xf01098ca
f0105129:	e8 1b af ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f010512e:	83 ec 04             	sub    $0x4,%esp
f0105131:	68 50 85 10 f0       	push   $0xf0108550
f0105136:	6a 51                	push   $0x51
f0105138:	68 11 8e 10 f0       	push   $0xf0108e11
f010513d:	e8 07 af ff ff       	call   f0100049 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105142:	e8 93 1a 00 00       	call   f0106bda <cpunum>
	if(inc < PGSIZE){
f0105147:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f010514e:	77 1b                	ja     f010516b <syscall+0x1ac>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0105150:	6b c0 74             	imul   $0x74,%eax,%eax
f0105153:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105159:	8b 40 7c             	mov    0x7c(%eax),%eax
f010515c:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f0105161:	03 45 0c             	add    0xc(%ebp),%eax
f0105164:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0105169:	76 7c                	jbe    f01051e7 <syscall+0x228>
	int i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f010516b:	e8 6a 1a 00 00       	call   f0106bda <cpunum>
f0105170:	6b c0 74             	imul   $0x74,%eax,%eax
f0105173:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105179:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010517c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f0105182:	e8 53 1a 00 00       	call   f0106bda <cpunum>
f0105187:	6b c0 74             	imul   $0x74,%eax,%eax
f010518a:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105190:	8b 40 7c             	mov    0x7c(%eax),%eax
f0105193:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105196:	8d b4 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%esi
f010519d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f01051a3:	39 de                	cmp    %ebx,%esi
f01051a5:	0f 8e 94 00 00 00    	jle    f010523f <syscall+0x280>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f01051ab:	83 ec 0c             	sub    $0xc,%esp
f01051ae:	6a 01                	push   $0x1
f01051b0:	e8 0f c1 ff ff       	call   f01012c4 <page_alloc>
f01051b5:	89 c7                	mov    %eax,%edi
		if(!page)
f01051b7:	83 c4 10             	add    $0x10,%esp
f01051ba:	85 c0                	test   %eax,%eax
f01051bc:	74 53                	je     f0105211 <syscall+0x252>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f01051be:	e8 17 1a 00 00       	call   f0106bda <cpunum>
f01051c3:	6a 06                	push   $0x6
f01051c5:	53                   	push   %ebx
f01051c6:	57                   	push   %edi
f01051c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01051ca:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01051d0:	ff 70 60             	pushl  0x60(%eax)
f01051d3:	e8 28 c4 ff ff       	call   f0101600 <page_insert>
		if(ret)
f01051d8:	83 c4 10             	add    $0x10,%esp
f01051db:	85 c0                	test   %eax,%eax
f01051dd:	75 49                	jne    f0105228 <syscall+0x269>
	for(; i < end; i+=PGSIZE){
f01051df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01051e5:	eb bc                	jmp    f01051a3 <syscall+0x1e4>
			curenv->env_sbrk+=inc;
f01051e7:	e8 ee 19 00 00       	call   f0106bda <cpunum>
f01051ec:	6b c0 74             	imul   $0x74,%eax,%eax
f01051ef:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f01051f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01051f8:	01 48 7c             	add    %ecx,0x7c(%eax)
			return curenv->env_sbrk;
f01051fb:	e8 da 19 00 00       	call   f0106bda <cpunum>
f0105200:	6b c0 74             	imul   $0x74,%eax,%eax
f0105203:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105209:	8b 58 7c             	mov    0x7c(%eax),%ebx
f010520c:	e9 00 fe ff ff       	jmp    f0105011 <syscall+0x52>
			panic("there is no page\n");
f0105211:	83 ec 04             	sub    $0x4,%esp
f0105214:	68 74 91 10 f0       	push   $0xf0109174
f0105219:	68 c4 01 00 00       	push   $0x1c4
f010521e:	68 ca 98 10 f0       	push   $0xf01098ca
f0105223:	e8 21 ae ff ff       	call   f0100049 <_panic>
			panic("there is error in insert");
f0105228:	83 ec 04             	sub    $0x4,%esp
f010522b:	68 91 91 10 f0       	push   $0xf0109191
f0105230:	68 c7 01 00 00       	push   $0x1c7
f0105235:	68 ca 98 10 f0       	push   $0xf01098ca
f010523a:	e8 0a ae ff ff       	call   f0100049 <_panic>
	curenv->env_sbrk+=inc;
f010523f:	e8 96 19 00 00       	call   f0106bda <cpunum>
f0105244:	6b c0 74             	imul   $0x74,%eax,%eax
f0105247:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010524d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105250:	01 48 7c             	add    %ecx,0x7c(%eax)
	return curenv->env_sbrk;
f0105253:	e8 82 19 00 00       	call   f0106bda <cpunum>
f0105258:	6b c0 74             	imul   $0x74,%eax,%eax
f010525b:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105261:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0105264:	e9 a8 fd ff ff       	jmp    f0105011 <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f0105269:	83 ec 04             	sub    $0x4,%esp
f010526c:	68 f0 98 10 f0       	push   $0xf01098f0
f0105271:	68 3a 02 00 00       	push   $0x23a
f0105276:	68 ca 98 10 f0       	push   $0xf01098ca
f010527b:	e8 c9 ad ff ff       	call   f0100049 <_panic>
	sched_yield();
f0105280:	e8 e9 fb ff ff       	call   f0104e6e <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105285:	e8 50 19 00 00       	call   f0106bda <cpunum>
f010528a:	83 ec 08             	sub    $0x8,%esp
f010528d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105290:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105296:	ff 70 48             	pushl  0x48(%eax)
f0105299:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010529c:	50                   	push   %eax
f010529d:	e8 cf e3 ff ff       	call   f0103671 <env_alloc>
f01052a2:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01052a4:	83 c4 10             	add    $0x10,%esp
f01052a7:	85 c0                	test   %eax,%eax
f01052a9:	0f 88 62 fd ff ff    	js     f0105011 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f01052af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052b2:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f01052b9:	e8 1c 19 00 00       	call   f0106bda <cpunum>
f01052be:	6b c0 74             	imul   $0x74,%eax,%eax
f01052c1:	8b b0 28 10 58 f0    	mov    -0xfa7efd8(%eax),%esi
f01052c7:	b9 11 00 00 00       	mov    $0x11,%ecx
f01052cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01052cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01052d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052d4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01052db:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01052de:	e9 2e fd ff ff       	jmp    f0105011 <syscall+0x52>
	switch (status)
f01052e3:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01052e7:	74 06                	je     f01052ef <syscall+0x330>
f01052e9:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f01052ed:	75 54                	jne    f0105343 <syscall+0x384>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01052ef:	8b 45 10             	mov    0x10(%ebp),%eax
f01052f2:	83 e8 02             	sub    $0x2,%eax
f01052f5:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01052fa:	75 31                	jne    f010532d <syscall+0x36e>
	int ret = envid2env(envid, &e, 1);
f01052fc:	83 ec 04             	sub    $0x4,%esp
f01052ff:	6a 01                	push   $0x1
f0105301:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105304:	50                   	push   %eax
f0105305:	ff 75 0c             	pushl  0xc(%ebp)
f0105308:	e8 21 e2 ff ff       	call   f010352e <envid2env>
f010530d:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f010530f:	83 c4 10             	add    $0x10,%esp
f0105312:	85 c0                	test   %eax,%eax
f0105314:	0f 88 f7 fc ff ff    	js     f0105011 <syscall+0x52>
	e->env_status = status;
f010531a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010531d:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105320:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0105323:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105328:	e9 e4 fc ff ff       	jmp    f0105011 <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f010532d:	68 1c 99 10 f0       	push   $0xf010991c
f0105332:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0105337:	6a 7b                	push   $0x7b
f0105339:	68 ca 98 10 f0       	push   $0xf01098ca
f010533e:	e8 06 ad ff ff       	call   f0100049 <_panic>
			return -E_INVAL;
f0105343:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105348:	e9 c4 fc ff ff       	jmp    f0105011 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f010534d:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105354:	0f 87 cd 00 00 00    	ja     f0105427 <syscall+0x468>
f010535a:	8b 45 10             	mov    0x10(%ebp),%eax
f010535d:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105362:	8b 55 14             	mov    0x14(%ebp),%edx
f0105365:	83 e2 05             	and    $0x5,%edx
f0105368:	83 fa 05             	cmp    $0x5,%edx
f010536b:	0f 85 c0 00 00 00    	jne    f0105431 <syscall+0x472>
	if(perm & ~PTE_SYSCALL)
f0105371:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105374:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f010537a:	09 c3                	or     %eax,%ebx
f010537c:	0f 85 b9 00 00 00    	jne    f010543b <syscall+0x47c>
	int ret = envid2env(envid, &e, 1);
f0105382:	83 ec 04             	sub    $0x4,%esp
f0105385:	6a 01                	push   $0x1
f0105387:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010538a:	50                   	push   %eax
f010538b:	ff 75 0c             	pushl  0xc(%ebp)
f010538e:	e8 9b e1 ff ff       	call   f010352e <envid2env>
	if(ret < 0)
f0105393:	83 c4 10             	add    $0x10,%esp
f0105396:	85 c0                	test   %eax,%eax
f0105398:	0f 88 a7 00 00 00    	js     f0105445 <syscall+0x486>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f010539e:	83 ec 0c             	sub    $0xc,%esp
f01053a1:	6a 01                	push   $0x1
f01053a3:	e8 1c bf ff ff       	call   f01012c4 <page_alloc>
f01053a8:	89 c6                	mov    %eax,%esi
	if(page == NULL)
f01053aa:	83 c4 10             	add    $0x10,%esp
f01053ad:	85 c0                	test   %eax,%eax
f01053af:	0f 84 97 00 00 00    	je     f010544c <syscall+0x48d>
	return (pp - pages) << PGSHIFT;
f01053b5:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f01053bb:	c1 f8 03             	sar    $0x3,%eax
f01053be:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01053c1:	89 c2                	mov    %eax,%edx
f01053c3:	c1 ea 0c             	shr    $0xc,%edx
f01053c6:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f01053cc:	73 47                	jae    f0105415 <syscall+0x456>
	memset(page2kva(page), 0, PGSIZE);
f01053ce:	83 ec 04             	sub    $0x4,%esp
f01053d1:	68 00 10 00 00       	push   $0x1000
f01053d6:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01053d8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01053dd:	50                   	push   %eax
f01053de:	e8 f0 11 00 00       	call   f01065d3 <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f01053e3:	ff 75 14             	pushl  0x14(%ebp)
f01053e6:	ff 75 10             	pushl  0x10(%ebp)
f01053e9:	56                   	push   %esi
f01053ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01053ed:	ff 70 60             	pushl  0x60(%eax)
f01053f0:	e8 0b c2 ff ff       	call   f0101600 <page_insert>
f01053f5:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f01053f7:	83 c4 20             	add    $0x20,%esp
f01053fa:	85 c0                	test   %eax,%eax
f01053fc:	0f 89 0f fc ff ff    	jns    f0105011 <syscall+0x52>
		page_free(page);
f0105402:	83 ec 0c             	sub    $0xc,%esp
f0105405:	56                   	push   %esi
f0105406:	e8 2b bf ff ff       	call   f0101336 <page_free>
f010540b:	83 c4 10             	add    $0x10,%esp
		return ret;
f010540e:	89 fb                	mov    %edi,%ebx
f0105410:	e9 fc fb ff ff       	jmp    f0105011 <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105415:	50                   	push   %eax
f0105416:	68 74 7c 10 f0       	push   $0xf0107c74
f010541b:	6a 58                	push   $0x58
f010541d:	68 11 8e 10 f0       	push   $0xf0108e11
f0105422:	e8 22 ac ff ff       	call   f0100049 <_panic>
		return -E_INVAL;
f0105427:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010542c:	e9 e0 fb ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f0105431:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105436:	e9 d6 fb ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f010543b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105440:	e9 cc fb ff ff       	jmp    f0105011 <syscall+0x52>
		return ret;
f0105445:	89 c3                	mov    %eax,%ebx
f0105447:	e9 c5 fb ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_NO_MEM;
f010544c:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105451:	e9 bb fb ff ff       	jmp    f0105011 <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105456:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105459:	83 e0 05             	and    $0x5,%eax
f010545c:	83 f8 05             	cmp    $0x5,%eax
f010545f:	0f 85 c0 00 00 00    	jne    f0105525 <syscall+0x566>
	if(perm & ~PTE_SYSCALL)
f0105465:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0105468:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f010546d:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105474:	0f 87 b5 00 00 00    	ja     f010552f <syscall+0x570>
f010547a:	8b 55 10             	mov    0x10(%ebp),%edx
f010547d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f0105483:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010548a:	0f 87 a9 00 00 00    	ja     f0105539 <syscall+0x57a>
f0105490:	09 d0                	or     %edx,%eax
f0105492:	8b 55 18             	mov    0x18(%ebp),%edx
f0105495:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f010549b:	09 d0                	or     %edx,%eax
f010549d:	0f 85 a0 00 00 00    	jne    f0105543 <syscall+0x584>
	int ret = envid2env(srcenvid, &src_env, 1);
f01054a3:	83 ec 04             	sub    $0x4,%esp
f01054a6:	6a 01                	push   $0x1
f01054a8:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01054ab:	50                   	push   %eax
f01054ac:	ff 75 0c             	pushl  0xc(%ebp)
f01054af:	e8 7a e0 ff ff       	call   f010352e <envid2env>
f01054b4:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01054b6:	83 c4 10             	add    $0x10,%esp
f01054b9:	85 c0                	test   %eax,%eax
f01054bb:	0f 88 50 fb ff ff    	js     f0105011 <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f01054c1:	83 ec 04             	sub    $0x4,%esp
f01054c4:	6a 01                	push   $0x1
f01054c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01054c9:	50                   	push   %eax
f01054ca:	ff 75 14             	pushl  0x14(%ebp)
f01054cd:	e8 5c e0 ff ff       	call   f010352e <envid2env>
f01054d2:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01054d4:	83 c4 10             	add    $0x10,%esp
f01054d7:	85 c0                	test   %eax,%eax
f01054d9:	0f 88 32 fb ff ff    	js     f0105011 <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f01054df:	83 ec 04             	sub    $0x4,%esp
f01054e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01054e5:	50                   	push   %eax
f01054e6:	ff 75 10             	pushl  0x10(%ebp)
f01054e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01054ec:	ff 70 60             	pushl  0x60(%eax)
f01054ef:	e8 2c c0 ff ff       	call   f0101520 <page_lookup>
	if(src_page == NULL)
f01054f4:	83 c4 10             	add    $0x10,%esp
f01054f7:	85 c0                	test   %eax,%eax
f01054f9:	74 52                	je     f010554d <syscall+0x58e>
	if(perm & PTE_W){
f01054fb:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01054ff:	74 08                	je     f0105509 <syscall+0x54a>
		if((*pte_store & PTE_W) == 0)
f0105501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105504:	f6 02 02             	testb  $0x2,(%edx)
f0105507:	74 4e                	je     f0105557 <syscall+0x598>
	return page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f0105509:	ff 75 1c             	pushl  0x1c(%ebp)
f010550c:	ff 75 18             	pushl  0x18(%ebp)
f010550f:	50                   	push   %eax
f0105510:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105513:	ff 70 60             	pushl  0x60(%eax)
f0105516:	e8 e5 c0 ff ff       	call   f0101600 <page_insert>
f010551b:	89 c3                	mov    %eax,%ebx
f010551d:	83 c4 10             	add    $0x10,%esp
f0105520:	e9 ec fa ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f0105525:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010552a:	e9 e2 fa ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f010552f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105534:	e9 d8 fa ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f0105539:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010553e:	e9 ce fa ff ff       	jmp    f0105011 <syscall+0x52>
f0105543:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105548:	e9 c4 fa ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f010554d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105552:	e9 ba fa ff ff       	jmp    f0105011 <syscall+0x52>
			return -E_INVAL;
f0105557:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010555c:	e9 b0 fa ff ff       	jmp    f0105011 <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105561:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105568:	77 45                	ja     f01055af <syscall+0x5f0>
f010556a:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105571:	75 46                	jne    f01055b9 <syscall+0x5fa>
	int ret = envid2env(envid, &env, 1);
f0105573:	83 ec 04             	sub    $0x4,%esp
f0105576:	6a 01                	push   $0x1
f0105578:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010557b:	50                   	push   %eax
f010557c:	ff 75 0c             	pushl  0xc(%ebp)
f010557f:	e8 aa df ff ff       	call   f010352e <envid2env>
f0105584:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105586:	83 c4 10             	add    $0x10,%esp
f0105589:	85 c0                	test   %eax,%eax
f010558b:	0f 88 80 fa ff ff    	js     f0105011 <syscall+0x52>
	page_remove(env->env_pgdir, va);
f0105591:	83 ec 08             	sub    $0x8,%esp
f0105594:	ff 75 10             	pushl  0x10(%ebp)
f0105597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010559a:	ff 70 60             	pushl  0x60(%eax)
f010559d:	e8 18 c0 ff ff       	call   f01015ba <page_remove>
f01055a2:	83 c4 10             	add    $0x10,%esp
	return 0;
f01055a5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01055aa:	e9 62 fa ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f01055af:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01055b4:	e9 58 fa ff ff       	jmp    f0105011 <syscall+0x52>
f01055b9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01055be:	e9 4e fa ff ff       	jmp    f0105011 <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f01055c3:	83 ec 04             	sub    $0x4,%esp
f01055c6:	6a 00                	push   $0x0
f01055c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01055cb:	50                   	push   %eax
f01055cc:	ff 75 0c             	pushl  0xc(%ebp)
f01055cf:	e8 5a df ff ff       	call   f010352e <envid2env>
f01055d4:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f01055d6:	83 c4 10             	add    $0x10,%esp
f01055d9:	85 c0                	test   %eax,%eax
f01055db:	0f 88 30 fa ff ff    	js     f0105011 <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f01055e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01055e4:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01055e8:	0f 84 09 01 00 00    	je     f01056f7 <syscall+0x738>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f01055ee:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01055f5:	77 78                	ja     f010566f <syscall+0x6b0>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01055f7:	8b 45 18             	mov    0x18(%ebp),%eax
f01055fa:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f01055fd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105602:	83 f8 05             	cmp    $0x5,%eax
f0105605:	0f 85 06 fa ff ff    	jne    f0105011 <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0)
f010560b:	8b 55 14             	mov    0x14(%ebp),%edx
f010560e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f0105614:	8b 45 18             	mov    0x18(%ebp),%eax
f0105617:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f010561c:	09 c2                	or     %eax,%edx
f010561e:	0f 85 ed f9 ff ff    	jne    f0105011 <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105624:	e8 b1 15 00 00       	call   f0106bda <cpunum>
f0105629:	83 ec 04             	sub    $0x4,%esp
f010562c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010562f:	52                   	push   %edx
f0105630:	ff 75 14             	pushl  0x14(%ebp)
f0105633:	6b c0 74             	imul   $0x74,%eax,%eax
f0105636:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010563c:	ff 70 60             	pushl  0x60(%eax)
f010563f:	e8 dc be ff ff       	call   f0101520 <page_lookup>
		if(!page)
f0105644:	83 c4 10             	add    $0x10,%esp
f0105647:	85 c0                	test   %eax,%eax
f0105649:	0f 84 9e 00 00 00    	je     f01056ed <syscall+0x72e>
		if((perm & PTE_W) && !(*pte & PTE_W))
f010564f:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105653:	74 0c                	je     f0105661 <syscall+0x6a2>
f0105655:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105658:	f6 02 02             	testb  $0x2,(%edx)
f010565b:	0f 84 b0 f9 ff ff    	je     f0105011 <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105661:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105664:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105667:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010566d:	76 52                	jbe    f01056c1 <syscall+0x702>
	dst_env->env_ipc_recving = 0;
f010566f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105672:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105676:	e8 5f 15 00 00       	call   f0106bda <cpunum>
f010567b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010567e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105681:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105687:	8b 40 48             	mov    0x48(%eax),%eax
f010568a:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_value = value;
f010568d:	8b 45 10             	mov    0x10(%ebp),%eax
f0105690:	89 42 70             	mov    %eax,0x70(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f0105693:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f010569a:	b8 00 00 00 00       	mov    $0x0,%eax
f010569f:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f01056a3:	89 45 18             	mov    %eax,0x18(%ebp)
f01056a6:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f01056a9:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f01056b0:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f01056b7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01056bc:	e9 50 f9 ff ff       	jmp    f0105011 <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f01056c1:	ff 75 18             	pushl  0x18(%ebp)
f01056c4:	51                   	push   %ecx
f01056c5:	50                   	push   %eax
f01056c6:	ff 72 60             	pushl  0x60(%edx)
f01056c9:	e8 32 bf ff ff       	call   f0101600 <page_insert>
f01056ce:	89 c3                	mov    %eax,%ebx
			if(ret < 0){
f01056d0:	83 c4 10             	add    $0x10,%esp
f01056d3:	85 c0                	test   %eax,%eax
f01056d5:	79 98                	jns    f010566f <syscall+0x6b0>
				cprintf("2the ret in rece %d\n", ret);
f01056d7:	83 ec 08             	sub    $0x8,%esp
f01056da:	50                   	push   %eax
f01056db:	68 d9 98 10 f0       	push   $0xf01098d9
f01056e0:	e8 dc e7 ff ff       	call   f0103ec1 <cprintf>
f01056e5:	83 c4 10             	add    $0x10,%esp
f01056e8:	e9 24 f9 ff ff       	jmp    f0105011 <syscall+0x52>
			return -E_INVAL;		
f01056ed:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01056f2:	e9 1a f9 ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_IPC_NOT_RECV;
f01056f7:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f01056fc:	e9 10 f9 ff ff       	jmp    f0105011 <syscall+0x52>
	if(dstva < (void *)UTOP){
f0105701:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105708:	77 13                	ja     f010571d <syscall+0x75e>
		if((uint32_t)dstva % PGSIZE != 0)
f010570a:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0105711:	74 0a                	je     f010571d <syscall+0x75e>
			ret = sys_ipc_recv((void *)a1);
f0105713:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f0105718:	e9 f4 f8 ff ff       	jmp    f0105011 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f010571d:	e8 b8 14 00 00       	call   f0106bda <cpunum>
f0105722:	6b c0 74             	imul   $0x74,%eax,%eax
f0105725:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010572b:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f010572f:	e8 a6 14 00 00       	call   f0106bda <cpunum>
f0105734:	6b c0 74             	imul   $0x74,%eax,%eax
f0105737:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f010573d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105740:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105743:	e8 92 14 00 00       	call   f0106bda <cpunum>
f0105748:	6b c0 74             	imul   $0x74,%eax,%eax
f010574b:	8b 80 28 10 58 f0    	mov    -0xfa7efd8(%eax),%eax
f0105751:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105758:	e8 11 f7 ff ff       	call   f0104e6e <sched_yield>
	int ret = envid2env(envid, &e, 1);
f010575d:	83 ec 04             	sub    $0x4,%esp
f0105760:	6a 01                	push   $0x1
f0105762:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105765:	50                   	push   %eax
f0105766:	ff 75 0c             	pushl  0xc(%ebp)
f0105769:	e8 c0 dd ff ff       	call   f010352e <envid2env>
f010576e:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105770:	83 c4 10             	add    $0x10,%esp
f0105773:	85 c0                	test   %eax,%eax
f0105775:	0f 88 96 f8 ff ff    	js     f0105011 <syscall+0x52>
	e->env_pgfault_upcall = func;
f010577b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010577e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105781:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0105784:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105789:	e9 83 f8 ff ff       	jmp    f0105011 <syscall+0x52>
	r = envid2env(envid, &e, 0);
f010578e:	83 ec 04             	sub    $0x4,%esp
f0105791:	6a 00                	push   $0x0
f0105793:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105796:	50                   	push   %eax
f0105797:	ff 75 0c             	pushl  0xc(%ebp)
f010579a:	e8 8f dd ff ff       	call   f010352e <envid2env>
f010579f:	89 c3                	mov    %eax,%ebx
	if(r < 0)
f01057a1:	83 c4 10             	add    $0x10,%esp
f01057a4:	85 c0                	test   %eax,%eax
f01057a6:	0f 88 65 f8 ff ff    	js     f0105011 <syscall+0x52>
	e->env_tf = *tf;
f01057ac:	b9 11 00 00 00       	mov    $0x11,%ecx
f01057b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01057b4:	8b 75 10             	mov    0x10(%ebp),%esi
f01057b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f01057b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01057bc:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	e->env_tf.tf_eflags |= FL_IF;
f01057c1:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
	return 0;
f01057c8:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f01057cd:	e9 3f f8 ff ff       	jmp    f0105011 <syscall+0x52>
	ret = envid2env(envid, &env, 0);
f01057d2:	83 ec 04             	sub    $0x4,%esp
f01057d5:	6a 00                	push   $0x0
f01057d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01057da:	50                   	push   %eax
f01057db:	ff 75 0c             	pushl  0xc(%ebp)
f01057de:	e8 4b dd ff ff       	call   f010352e <envid2env>
f01057e3:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01057e5:	83 c4 10             	add    $0x10,%esp
f01057e8:	85 c0                	test   %eax,%eax
f01057ea:	0f 88 21 f8 ff ff    	js     f0105011 <syscall+0x52>
	struct PageInfo* page = page_lookup(env->env_pgdir, va, &pte_store);
f01057f0:	83 ec 04             	sub    $0x4,%esp
f01057f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01057f6:	50                   	push   %eax
f01057f7:	ff 75 10             	pushl  0x10(%ebp)
f01057fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057fd:	ff 70 60             	pushl  0x60(%eax)
f0105800:	e8 1b bd ff ff       	call   f0101520 <page_lookup>
	if(page == NULL)
f0105805:	83 c4 10             	add    $0x10,%esp
f0105808:	85 c0                	test   %eax,%eax
f010580a:	74 16                	je     f0105822 <syscall+0x863>
	*pte_store |= PTE_A;
f010580c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010580f:	83 08 20             	orl    $0x20,(%eax)
	*pte_store ^= PTE_A;
f0105812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105815:	83 30 20             	xorl   $0x20,(%eax)
	return 0;
f0105818:	bb 00 00 00 00       	mov    $0x0,%ebx
f010581d:	e9 ef f7 ff ff       	jmp    f0105011 <syscall+0x52>
		return -E_INVAL;
f0105822:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105827:	e9 e5 f7 ff ff       	jmp    f0105011 <syscall+0x52>
	return time_msec();
f010582c:	e8 78 21 00 00       	call   f01079a9 <time_msec>
f0105831:	89 c3                	mov    %eax,%ebx
			break;
f0105833:	e9 d9 f7 ff ff       	jmp    f0105011 <syscall+0x52>
			ret = sys_net_send((void *)a1, (uint32_t)a2);
f0105838:	83 ec 08             	sub    $0x8,%esp
f010583b:	ff 75 10             	pushl  0x10(%ebp)
f010583e:	ff 75 0c             	pushl  0xc(%ebp)
f0105841:	e8 e0 f6 ff ff       	call   f0104f26 <sys_net_send>
f0105846:	89 c3                	mov    %eax,%ebx
			break;
f0105848:	83 c4 10             	add    $0x10,%esp
f010584b:	e9 c1 f7 ff ff       	jmp    f0105011 <syscall+0x52>
			ret = sys_net_recv((void *)a1, (uint32_t)a2);
f0105850:	83 ec 08             	sub    $0x8,%esp
f0105853:	ff 75 10             	pushl  0x10(%ebp)
f0105856:	ff 75 0c             	pushl  0xc(%ebp)
f0105859:	e8 23 f7 ff ff       	call   f0104f81 <sys_net_recv>
f010585e:	89 c3                	mov    %eax,%ebx
			break;
f0105860:	83 c4 10             	add    $0x10,%esp
f0105863:	e9 a9 f7 ff ff       	jmp    f0105011 <syscall+0x52>
			ret = -E_INVAL;
f0105868:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010586d:	e9 9f f7 ff ff       	jmp    f0105011 <syscall+0x52>
        return E_INVAL;
f0105872:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105877:	e9 95 f7 ff ff       	jmp    f0105011 <syscall+0x52>

f010587c <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010587c:	55                   	push   %ebp
f010587d:	89 e5                	mov    %esp,%ebp
f010587f:	57                   	push   %edi
f0105880:	56                   	push   %esi
f0105881:	53                   	push   %ebx
f0105882:	83 ec 14             	sub    $0x14,%esp
f0105885:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105888:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010588b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f010588e:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105891:	8b 1a                	mov    (%edx),%ebx
f0105893:	8b 01                	mov    (%ecx),%eax
f0105895:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105898:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f010589f:	eb 23                	jmp    f01058c4 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f01058a1:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f01058a4:	eb 1e                	jmp    f01058c4 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01058a6:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01058a9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01058ac:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01058b0:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01058b3:	73 41                	jae    f01058f6 <stab_binsearch+0x7a>
			*region_left = m;
f01058b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01058b8:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01058ba:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01058bd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01058c4:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01058c7:	7f 5a                	jg     f0105923 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f01058c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01058cc:	01 d8                	add    %ebx,%eax
f01058ce:	89 c7                	mov    %eax,%edi
f01058d0:	c1 ef 1f             	shr    $0x1f,%edi
f01058d3:	01 c7                	add    %eax,%edi
f01058d5:	d1 ff                	sar    %edi
f01058d7:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f01058da:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01058dd:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01058e1:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f01058e3:	39 c3                	cmp    %eax,%ebx
f01058e5:	7f ba                	jg     f01058a1 <stab_binsearch+0x25>
f01058e7:	0f b6 0a             	movzbl (%edx),%ecx
f01058ea:	83 ea 0c             	sub    $0xc,%edx
f01058ed:	39 f1                	cmp    %esi,%ecx
f01058ef:	74 b5                	je     f01058a6 <stab_binsearch+0x2a>
			m--;
f01058f1:	83 e8 01             	sub    $0x1,%eax
f01058f4:	eb ed                	jmp    f01058e3 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f01058f6:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01058f9:	76 14                	jbe    f010590f <stab_binsearch+0x93>
			*region_right = m - 1;
f01058fb:	83 e8 01             	sub    $0x1,%eax
f01058fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105901:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105904:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0105906:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010590d:	eb b5                	jmp    f01058c4 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f010590f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105912:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0105914:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105918:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f010591a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105921:	eb a1                	jmp    f01058c4 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105923:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105927:	75 15                	jne    f010593e <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0105929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010592c:	8b 00                	mov    (%eax),%eax
f010592e:	83 e8 01             	sub    $0x1,%eax
f0105931:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105934:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105936:	83 c4 14             	add    $0x14,%esp
f0105939:	5b                   	pop    %ebx
f010593a:	5e                   	pop    %esi
f010593b:	5f                   	pop    %edi
f010593c:	5d                   	pop    %ebp
f010593d:	c3                   	ret    
		for (l = *region_right;
f010593e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105941:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105943:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105946:	8b 0f                	mov    (%edi),%ecx
f0105948:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010594b:	8b 7d ec             	mov    -0x14(%ebp),%edi
f010594e:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105952:	eb 03                	jmp    f0105957 <stab_binsearch+0xdb>
		     l--)
f0105954:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105957:	39 c1                	cmp    %eax,%ecx
f0105959:	7d 0a                	jge    f0105965 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f010595b:	0f b6 1a             	movzbl (%edx),%ebx
f010595e:	83 ea 0c             	sub    $0xc,%edx
f0105961:	39 f3                	cmp    %esi,%ebx
f0105963:	75 ef                	jne    f0105954 <stab_binsearch+0xd8>
		*region_left = l;
f0105965:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105968:	89 06                	mov    %eax,(%esi)
}
f010596a:	eb ca                	jmp    f0105936 <stab_binsearch+0xba>

f010596c <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010596c:	55                   	push   %ebp
f010596d:	89 e5                	mov    %esp,%ebp
f010596f:	57                   	push   %edi
f0105970:	56                   	push   %esi
f0105971:	53                   	push   %ebx
f0105972:	83 ec 4c             	sub    $0x4c,%esp
f0105975:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105978:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f010597b:	c7 03 a8 99 10 f0    	movl   $0xf01099a8,(%ebx)
	info->eip_line = 0;
f0105981:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105988:	c7 43 08 a8 99 10 f0 	movl   $0xf01099a8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f010598f:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105996:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105999:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f01059a0:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f01059a6:	0f 86 23 01 00 00    	jbe    f0105acf <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01059ac:	c7 45 b8 de e5 11 f0 	movl   $0xf011e5de,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f01059b3:	c7 45 b4 7d 9b 11 f0 	movl   $0xf0119b7d,-0x4c(%ebp)
		stab_end = __STAB_END__;
f01059ba:	be 7c 9b 11 f0       	mov    $0xf0119b7c,%esi
		stabs = __STAB_BEGIN__;
f01059bf:	c7 45 bc 88 a2 10 f0 	movl   $0xf010a288,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01059c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
f01059c9:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f01059cc:	0f 83 59 02 00 00    	jae    f0105c2b <debuginfo_eip+0x2bf>
f01059d2:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01059d6:	0f 85 56 02 00 00    	jne    f0105c32 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01059dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01059e3:	2b 75 bc             	sub    -0x44(%ebp),%esi
f01059e6:	c1 fe 02             	sar    $0x2,%esi
f01059e9:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f01059ef:	83 e8 01             	sub    $0x1,%eax
f01059f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01059f5:	83 ec 08             	sub    $0x8,%esp
f01059f8:	57                   	push   %edi
f01059f9:	6a 64                	push   $0x64
f01059fb:	8d 55 e0             	lea    -0x20(%ebp),%edx
f01059fe:	89 d1                	mov    %edx,%ecx
f0105a00:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105a03:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105a06:	89 f0                	mov    %esi,%eax
f0105a08:	e8 6f fe ff ff       	call   f010587c <stab_binsearch>
	if (lfile == 0)
f0105a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a10:	83 c4 10             	add    $0x10,%esp
f0105a13:	85 c0                	test   %eax,%eax
f0105a15:	0f 84 1e 02 00 00    	je     f0105c39 <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105a1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a21:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105a24:	83 ec 08             	sub    $0x8,%esp
f0105a27:	57                   	push   %edi
f0105a28:	6a 24                	push   $0x24
f0105a2a:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105a2d:	89 d1                	mov    %edx,%ecx
f0105a2f:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105a32:	89 f0                	mov    %esi,%eax
f0105a34:	e8 43 fe ff ff       	call   f010587c <stab_binsearch>

	if (lfun <= rfun) {
f0105a39:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105a3c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105a3f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105a42:	83 c4 10             	add    $0x10,%esp
f0105a45:	39 c8                	cmp    %ecx,%eax
f0105a47:	0f 8f 26 01 00 00    	jg     f0105b73 <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105a4d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105a50:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f0105a53:	8b 11                	mov    (%ecx),%edx
f0105a55:	8b 75 b8             	mov    -0x48(%ebp),%esi
f0105a58:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105a5b:	39 f2                	cmp    %esi,%edx
f0105a5d:	73 06                	jae    f0105a65 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105a5f:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105a62:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105a65:	8b 51 08             	mov    0x8(%ecx),%edx
f0105a68:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105a6b:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105a70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105a73:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105a76:	83 ec 08             	sub    $0x8,%esp
f0105a79:	6a 3a                	push   $0x3a
f0105a7b:	ff 73 08             	pushl  0x8(%ebx)
f0105a7e:	e8 34 0b 00 00       	call   f01065b7 <strfind>
f0105a83:	2b 43 08             	sub    0x8(%ebx),%eax
f0105a86:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105a89:	83 c4 08             	add    $0x8,%esp
f0105a8c:	57                   	push   %edi
f0105a8d:	6a 44                	push   $0x44
f0105a8f:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105a92:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105a95:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105a98:	89 f0                	mov    %esi,%eax
f0105a9a:	e8 dd fd ff ff       	call   f010587c <stab_binsearch>
	if(lline <= rline){
f0105a9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105aa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105aa5:	83 c4 10             	add    $0x10,%esp
f0105aa8:	39 c2                	cmp    %eax,%edx
f0105aaa:	0f 8f 90 01 00 00    	jg     f0105c40 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f0105ab0:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105ab3:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f0105ab7:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105aba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105abd:	89 d0                	mov    %edx,%eax
f0105abf:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105ac2:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105ac6:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0105aca:	e9 c2 00 00 00       	jmp    f0105b91 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f0105acf:	e8 06 11 00 00       	call   f0106bda <cpunum>
f0105ad4:	6a 06                	push   $0x6
f0105ad6:	6a 10                	push   $0x10
f0105ad8:	68 00 00 20 00       	push   $0x200000
f0105add:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ae0:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0105ae6:	e8 c9 d8 ff ff       	call   f01033b4 <user_mem_check>
f0105aeb:	83 c4 10             	add    $0x10,%esp
f0105aee:	85 c0                	test   %eax,%eax
f0105af0:	0f 88 27 01 00 00    	js     f0105c1d <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f0105af6:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105afc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105aff:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105b05:	a1 08 00 20 00       	mov    0x200008,%eax
f0105b0a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105b0d:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105b13:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f0105b16:	e8 bf 10 00 00       	call   f0106bda <cpunum>
f0105b1b:	6a 06                	push   $0x6
f0105b1d:	89 f2                	mov    %esi,%edx
f0105b1f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105b22:	29 ca                	sub    %ecx,%edx
f0105b24:	52                   	push   %edx
f0105b25:	51                   	push   %ecx
f0105b26:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b29:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0105b2f:	e8 80 d8 ff ff       	call   f01033b4 <user_mem_check>
f0105b34:	83 c4 10             	add    $0x10,%esp
f0105b37:	85 c0                	test   %eax,%eax
f0105b39:	0f 88 e5 00 00 00    	js     f0105c24 <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105b3f:	e8 96 10 00 00       	call   f0106bda <cpunum>
f0105b44:	6a 06                	push   $0x6
f0105b46:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105b49:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105b4c:	29 ca                	sub    %ecx,%edx
f0105b4e:	52                   	push   %edx
f0105b4f:	51                   	push   %ecx
f0105b50:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b53:	ff b0 28 10 58 f0    	pushl  -0xfa7efd8(%eax)
f0105b59:	e8 56 d8 ff ff       	call   f01033b4 <user_mem_check>
f0105b5e:	83 c4 10             	add    $0x10,%esp
f0105b61:	85 c0                	test   %eax,%eax
f0105b63:	0f 89 5d fe ff ff    	jns    f01059c6 <debuginfo_eip+0x5a>
			return -1;
f0105b69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105b6e:	e9 d9 00 00 00       	jmp    f0105c4c <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105b73:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105b76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105b82:	e9 ef fe ff ff       	jmp    f0105a76 <debuginfo_eip+0x10a>
f0105b87:	83 e8 01             	sub    $0x1,%eax
f0105b8a:	83 ea 0c             	sub    $0xc,%edx
f0105b8d:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105b91:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105b94:	39 c7                	cmp    %eax,%edi
f0105b96:	7f 45                	jg     f0105bdd <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f0105b98:	0f b6 0a             	movzbl (%edx),%ecx
f0105b9b:	80 f9 84             	cmp    $0x84,%cl
f0105b9e:	74 19                	je     f0105bb9 <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105ba0:	80 f9 64             	cmp    $0x64,%cl
f0105ba3:	75 e2                	jne    f0105b87 <debuginfo_eip+0x21b>
f0105ba5:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105ba9:	74 dc                	je     f0105b87 <debuginfo_eip+0x21b>
f0105bab:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105baf:	74 11                	je     f0105bc2 <debuginfo_eip+0x256>
f0105bb1:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105bb4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105bb7:	eb 09                	jmp    f0105bc2 <debuginfo_eip+0x256>
f0105bb9:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105bbd:	74 03                	je     f0105bc2 <debuginfo_eip+0x256>
f0105bbf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105bc2:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105bc5:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105bc8:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105bcb:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105bce:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105bd1:	29 f8                	sub    %edi,%eax
f0105bd3:	39 c2                	cmp    %eax,%edx
f0105bd5:	73 06                	jae    f0105bdd <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105bd7:	89 f8                	mov    %edi,%eax
f0105bd9:	01 d0                	add    %edx,%eax
f0105bdb:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105bdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105be0:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f0105be3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105be8:	39 f2                	cmp    %esi,%edx
f0105bea:	7d 60                	jge    f0105c4c <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f0105bec:	83 c2 01             	add    $0x1,%edx
f0105bef:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105bf2:	89 d0                	mov    %edx,%eax
f0105bf4:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105bf7:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105bfa:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105bfe:	eb 04                	jmp    f0105c04 <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f0105c00:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105c04:	39 c6                	cmp    %eax,%esi
f0105c06:	7e 3f                	jle    f0105c47 <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105c08:	0f b6 0a             	movzbl (%edx),%ecx
f0105c0b:	83 c0 01             	add    $0x1,%eax
f0105c0e:	83 c2 0c             	add    $0xc,%edx
f0105c11:	80 f9 a0             	cmp    $0xa0,%cl
f0105c14:	74 ea                	je     f0105c00 <debuginfo_eip+0x294>
	return 0;
f0105c16:	b8 00 00 00 00       	mov    $0x0,%eax
f0105c1b:	eb 2f                	jmp    f0105c4c <debuginfo_eip+0x2e0>
			return -1;
f0105c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c22:	eb 28                	jmp    f0105c4c <debuginfo_eip+0x2e0>
			return -1;
f0105c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c29:	eb 21                	jmp    f0105c4c <debuginfo_eip+0x2e0>
		return -1;
f0105c2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c30:	eb 1a                	jmp    f0105c4c <debuginfo_eip+0x2e0>
f0105c32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c37:	eb 13                	jmp    f0105c4c <debuginfo_eip+0x2e0>
		return -1;
f0105c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c3e:	eb 0c                	jmp    f0105c4c <debuginfo_eip+0x2e0>
		return -1;
f0105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105c45:	eb 05                	jmp    f0105c4c <debuginfo_eip+0x2e0>
	return 0;
f0105c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105c4f:	5b                   	pop    %ebx
f0105c50:	5e                   	pop    %esi
f0105c51:	5f                   	pop    %edi
f0105c52:	5d                   	pop    %ebp
f0105c53:	c3                   	ret    

f0105c54 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105c54:	55                   	push   %ebp
f0105c55:	89 e5                	mov    %esp,%ebp
f0105c57:	57                   	push   %edi
f0105c58:	56                   	push   %esi
f0105c59:	53                   	push   %ebx
f0105c5a:	83 ec 1c             	sub    $0x1c,%esp
f0105c5d:	89 c6                	mov    %eax,%esi
f0105c5f:	89 d7                	mov    %edx,%edi
f0105c61:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c64:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105c6a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105c6d:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c70:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105c73:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105c77:	74 2c                	je     f0105ca5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f0105c79:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105c7c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105c83:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105c86:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105c89:	39 c2                	cmp    %eax,%edx
f0105c8b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105c8e:	73 43                	jae    f0105cd3 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105c90:	83 eb 01             	sub    $0x1,%ebx
f0105c93:	85 db                	test   %ebx,%ebx
f0105c95:	7e 6c                	jle    f0105d03 <printnum+0xaf>
				putch(padc, putdat);
f0105c97:	83 ec 08             	sub    $0x8,%esp
f0105c9a:	57                   	push   %edi
f0105c9b:	ff 75 18             	pushl  0x18(%ebp)
f0105c9e:	ff d6                	call   *%esi
f0105ca0:	83 c4 10             	add    $0x10,%esp
f0105ca3:	eb eb                	jmp    f0105c90 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105ca5:	83 ec 0c             	sub    $0xc,%esp
f0105ca8:	6a 20                	push   $0x20
f0105caa:	6a 00                	push   $0x0
f0105cac:	50                   	push   %eax
f0105cad:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cb0:	ff 75 e0             	pushl  -0x20(%ebp)
f0105cb3:	89 fa                	mov    %edi,%edx
f0105cb5:	89 f0                	mov    %esi,%eax
f0105cb7:	e8 98 ff ff ff       	call   f0105c54 <printnum>
		while (--width > 0)
f0105cbc:	83 c4 20             	add    $0x20,%esp
f0105cbf:	83 eb 01             	sub    $0x1,%ebx
f0105cc2:	85 db                	test   %ebx,%ebx
f0105cc4:	7e 65                	jle    f0105d2b <printnum+0xd7>
			putch(padc, putdat);
f0105cc6:	83 ec 08             	sub    $0x8,%esp
f0105cc9:	57                   	push   %edi
f0105cca:	6a 20                	push   $0x20
f0105ccc:	ff d6                	call   *%esi
f0105cce:	83 c4 10             	add    $0x10,%esp
f0105cd1:	eb ec                	jmp    f0105cbf <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f0105cd3:	83 ec 0c             	sub    $0xc,%esp
f0105cd6:	ff 75 18             	pushl  0x18(%ebp)
f0105cd9:	83 eb 01             	sub    $0x1,%ebx
f0105cdc:	53                   	push   %ebx
f0105cdd:	50                   	push   %eax
f0105cde:	83 ec 08             	sub    $0x8,%esp
f0105ce1:	ff 75 dc             	pushl  -0x24(%ebp)
f0105ce4:	ff 75 d8             	pushl  -0x28(%ebp)
f0105ce7:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105cea:	ff 75 e0             	pushl  -0x20(%ebp)
f0105ced:	e8 ce 1c 00 00       	call   f01079c0 <__udivdi3>
f0105cf2:	83 c4 18             	add    $0x18,%esp
f0105cf5:	52                   	push   %edx
f0105cf6:	50                   	push   %eax
f0105cf7:	89 fa                	mov    %edi,%edx
f0105cf9:	89 f0                	mov    %esi,%eax
f0105cfb:	e8 54 ff ff ff       	call   f0105c54 <printnum>
f0105d00:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f0105d03:	83 ec 08             	sub    $0x8,%esp
f0105d06:	57                   	push   %edi
f0105d07:	83 ec 04             	sub    $0x4,%esp
f0105d0a:	ff 75 dc             	pushl  -0x24(%ebp)
f0105d0d:	ff 75 d8             	pushl  -0x28(%ebp)
f0105d10:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105d13:	ff 75 e0             	pushl  -0x20(%ebp)
f0105d16:	e8 b5 1d 00 00       	call   f0107ad0 <__umoddi3>
f0105d1b:	83 c4 14             	add    $0x14,%esp
f0105d1e:	0f be 80 b2 99 10 f0 	movsbl -0xfef664e(%eax),%eax
f0105d25:	50                   	push   %eax
f0105d26:	ff d6                	call   *%esi
f0105d28:	83 c4 10             	add    $0x10,%esp
	}
}
f0105d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d2e:	5b                   	pop    %ebx
f0105d2f:	5e                   	pop    %esi
f0105d30:	5f                   	pop    %edi
f0105d31:	5d                   	pop    %ebp
f0105d32:	c3                   	ret    

f0105d33 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105d33:	55                   	push   %ebp
f0105d34:	89 e5                	mov    %esp,%ebp
f0105d36:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105d39:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105d3d:	8b 10                	mov    (%eax),%edx
f0105d3f:	3b 50 04             	cmp    0x4(%eax),%edx
f0105d42:	73 0a                	jae    f0105d4e <sprintputch+0x1b>
		*b->buf++ = ch;
f0105d44:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105d47:	89 08                	mov    %ecx,(%eax)
f0105d49:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d4c:	88 02                	mov    %al,(%edx)
}
f0105d4e:	5d                   	pop    %ebp
f0105d4f:	c3                   	ret    

f0105d50 <printfmt>:
{
f0105d50:	55                   	push   %ebp
f0105d51:	89 e5                	mov    %esp,%ebp
f0105d53:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105d56:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105d59:	50                   	push   %eax
f0105d5a:	ff 75 10             	pushl  0x10(%ebp)
f0105d5d:	ff 75 0c             	pushl  0xc(%ebp)
f0105d60:	ff 75 08             	pushl  0x8(%ebp)
f0105d63:	e8 05 00 00 00       	call   f0105d6d <vprintfmt>
}
f0105d68:	83 c4 10             	add    $0x10,%esp
f0105d6b:	c9                   	leave  
f0105d6c:	c3                   	ret    

f0105d6d <vprintfmt>:
{
f0105d6d:	55                   	push   %ebp
f0105d6e:	89 e5                	mov    %esp,%ebp
f0105d70:	57                   	push   %edi
f0105d71:	56                   	push   %esi
f0105d72:	53                   	push   %ebx
f0105d73:	83 ec 3c             	sub    $0x3c,%esp
f0105d76:	8b 75 08             	mov    0x8(%ebp),%esi
f0105d79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105d7c:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105d7f:	e9 32 04 00 00       	jmp    f01061b6 <vprintfmt+0x449>
		padc = ' ';
f0105d84:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f0105d88:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f0105d8f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0105d96:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105d9d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105da4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0105dab:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105db0:	8d 47 01             	lea    0x1(%edi),%eax
f0105db3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105db6:	0f b6 17             	movzbl (%edi),%edx
f0105db9:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105dbc:	3c 55                	cmp    $0x55,%al
f0105dbe:	0f 87 12 05 00 00    	ja     f01062d6 <vprintfmt+0x569>
f0105dc4:	0f b6 c0             	movzbl %al,%eax
f0105dc7:	ff 24 85 a0 9b 10 f0 	jmp    *-0xfef6460(,%eax,4)
f0105dce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105dd1:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0105dd5:	eb d9                	jmp    f0105db0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105dd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105dda:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0105dde:	eb d0                	jmp    f0105db0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105de0:	0f b6 d2             	movzbl %dl,%edx
f0105de3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105de6:	b8 00 00 00 00       	mov    $0x0,%eax
f0105deb:	89 75 08             	mov    %esi,0x8(%ebp)
f0105dee:	eb 03                	jmp    f0105df3 <vprintfmt+0x86>
f0105df0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105df3:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105df6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0105dfa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105dfd:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105e00:	83 fe 09             	cmp    $0x9,%esi
f0105e03:	76 eb                	jbe    f0105df0 <vprintfmt+0x83>
f0105e05:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e08:	8b 75 08             	mov    0x8(%ebp),%esi
f0105e0b:	eb 14                	jmp    f0105e21 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0105e0d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e10:	8b 00                	mov    (%eax),%eax
f0105e12:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e15:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e18:	8d 40 04             	lea    0x4(%eax),%eax
f0105e1b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105e21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105e25:	79 89                	jns    f0105db0 <vprintfmt+0x43>
				width = precision, precision = -1;
f0105e27:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105e2d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105e34:	e9 77 ff ff ff       	jmp    f0105db0 <vprintfmt+0x43>
f0105e39:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e3c:	85 c0                	test   %eax,%eax
f0105e3e:	0f 48 c1             	cmovs  %ecx,%eax
f0105e41:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e44:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105e47:	e9 64 ff ff ff       	jmp    f0105db0 <vprintfmt+0x43>
f0105e4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105e4f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0105e56:	e9 55 ff ff ff       	jmp    f0105db0 <vprintfmt+0x43>
			lflag++;
f0105e5b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105e5f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105e62:	e9 49 ff ff ff       	jmp    f0105db0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0105e67:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e6a:	8d 78 04             	lea    0x4(%eax),%edi
f0105e6d:	83 ec 08             	sub    $0x8,%esp
f0105e70:	53                   	push   %ebx
f0105e71:	ff 30                	pushl  (%eax)
f0105e73:	ff d6                	call   *%esi
			break;
f0105e75:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105e78:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105e7b:	e9 33 03 00 00       	jmp    f01061b3 <vprintfmt+0x446>
			err = va_arg(ap, int);
f0105e80:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e83:	8d 78 04             	lea    0x4(%eax),%edi
f0105e86:	8b 00                	mov    (%eax),%eax
f0105e88:	99                   	cltd   
f0105e89:	31 d0                	xor    %edx,%eax
f0105e8b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105e8d:	83 f8 11             	cmp    $0x11,%eax
f0105e90:	7f 23                	jg     f0105eb5 <vprintfmt+0x148>
f0105e92:	8b 14 85 00 9d 10 f0 	mov    -0xfef6300(,%eax,4),%edx
f0105e99:	85 d2                	test   %edx,%edx
f0105e9b:	74 18                	je     f0105eb5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f0105e9d:	52                   	push   %edx
f0105e9e:	68 3d 8e 10 f0       	push   $0xf0108e3d
f0105ea3:	53                   	push   %ebx
f0105ea4:	56                   	push   %esi
f0105ea5:	e8 a6 fe ff ff       	call   f0105d50 <printfmt>
f0105eaa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105ead:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105eb0:	e9 fe 02 00 00       	jmp    f01061b3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f0105eb5:	50                   	push   %eax
f0105eb6:	68 ca 99 10 f0       	push   $0xf01099ca
f0105ebb:	53                   	push   %ebx
f0105ebc:	56                   	push   %esi
f0105ebd:	e8 8e fe ff ff       	call   f0105d50 <printfmt>
f0105ec2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105ec5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105ec8:	e9 e6 02 00 00       	jmp    f01061b3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f0105ecd:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ed0:	83 c0 04             	add    $0x4,%eax
f0105ed3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105ed6:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ed9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f0105edb:	85 c9                	test   %ecx,%ecx
f0105edd:	b8 c3 99 10 f0       	mov    $0xf01099c3,%eax
f0105ee2:	0f 45 c1             	cmovne %ecx,%eax
f0105ee5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0105ee8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105eec:	7e 06                	jle    f0105ef4 <vprintfmt+0x187>
f0105eee:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0105ef2:	75 0d                	jne    f0105f01 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105ef4:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105ef7:	89 c7                	mov    %eax,%edi
f0105ef9:	03 45 e0             	add    -0x20(%ebp),%eax
f0105efc:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105eff:	eb 53                	jmp    f0105f54 <vprintfmt+0x1e7>
f0105f01:	83 ec 08             	sub    $0x8,%esp
f0105f04:	ff 75 d8             	pushl  -0x28(%ebp)
f0105f07:	50                   	push   %eax
f0105f08:	e8 5f 05 00 00       	call   f010646c <strnlen>
f0105f0d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105f10:	29 c1                	sub    %eax,%ecx
f0105f12:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0105f15:	83 c4 10             	add    $0x10,%esp
f0105f18:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0105f1a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0105f1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f21:	eb 0f                	jmp    f0105f32 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0105f23:	83 ec 08             	sub    $0x8,%esp
f0105f26:	53                   	push   %ebx
f0105f27:	ff 75 e0             	pushl  -0x20(%ebp)
f0105f2a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105f2c:	83 ef 01             	sub    $0x1,%edi
f0105f2f:	83 c4 10             	add    $0x10,%esp
f0105f32:	85 ff                	test   %edi,%edi
f0105f34:	7f ed                	jg     f0105f23 <vprintfmt+0x1b6>
f0105f36:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105f39:	85 c9                	test   %ecx,%ecx
f0105f3b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f40:	0f 49 c1             	cmovns %ecx,%eax
f0105f43:	29 c1                	sub    %eax,%ecx
f0105f45:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105f48:	eb aa                	jmp    f0105ef4 <vprintfmt+0x187>
					putch(ch, putdat);
f0105f4a:	83 ec 08             	sub    $0x8,%esp
f0105f4d:	53                   	push   %ebx
f0105f4e:	52                   	push   %edx
f0105f4f:	ff d6                	call   *%esi
f0105f51:	83 c4 10             	add    $0x10,%esp
f0105f54:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105f57:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105f59:	83 c7 01             	add    $0x1,%edi
f0105f5c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105f60:	0f be d0             	movsbl %al,%edx
f0105f63:	85 d2                	test   %edx,%edx
f0105f65:	74 4b                	je     f0105fb2 <vprintfmt+0x245>
f0105f67:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105f6b:	78 06                	js     f0105f73 <vprintfmt+0x206>
f0105f6d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105f71:	78 1e                	js     f0105f91 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f0105f73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0105f77:	74 d1                	je     f0105f4a <vprintfmt+0x1dd>
f0105f79:	0f be c0             	movsbl %al,%eax
f0105f7c:	83 e8 20             	sub    $0x20,%eax
f0105f7f:	83 f8 5e             	cmp    $0x5e,%eax
f0105f82:	76 c6                	jbe    f0105f4a <vprintfmt+0x1dd>
					putch('?', putdat);
f0105f84:	83 ec 08             	sub    $0x8,%esp
f0105f87:	53                   	push   %ebx
f0105f88:	6a 3f                	push   $0x3f
f0105f8a:	ff d6                	call   *%esi
f0105f8c:	83 c4 10             	add    $0x10,%esp
f0105f8f:	eb c3                	jmp    f0105f54 <vprintfmt+0x1e7>
f0105f91:	89 cf                	mov    %ecx,%edi
f0105f93:	eb 0e                	jmp    f0105fa3 <vprintfmt+0x236>
				putch(' ', putdat);
f0105f95:	83 ec 08             	sub    $0x8,%esp
f0105f98:	53                   	push   %ebx
f0105f99:	6a 20                	push   $0x20
f0105f9b:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105f9d:	83 ef 01             	sub    $0x1,%edi
f0105fa0:	83 c4 10             	add    $0x10,%esp
f0105fa3:	85 ff                	test   %edi,%edi
f0105fa5:	7f ee                	jg     f0105f95 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f0105fa7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105faa:	89 45 14             	mov    %eax,0x14(%ebp)
f0105fad:	e9 01 02 00 00       	jmp    f01061b3 <vprintfmt+0x446>
f0105fb2:	89 cf                	mov    %ecx,%edi
f0105fb4:	eb ed                	jmp    f0105fa3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f0105fb6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f0105fb9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f0105fc0:	e9 eb fd ff ff       	jmp    f0105db0 <vprintfmt+0x43>
	if (lflag >= 2)
f0105fc5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105fc9:	7f 21                	jg     f0105fec <vprintfmt+0x27f>
	else if (lflag)
f0105fcb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105fcf:	74 68                	je     f0106039 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f0105fd1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fd4:	8b 00                	mov    (%eax),%eax
f0105fd6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105fd9:	89 c1                	mov    %eax,%ecx
f0105fdb:	c1 f9 1f             	sar    $0x1f,%ecx
f0105fde:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105fe1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fe4:	8d 40 04             	lea    0x4(%eax),%eax
f0105fe7:	89 45 14             	mov    %eax,0x14(%ebp)
f0105fea:	eb 17                	jmp    f0106003 <vprintfmt+0x296>
		return va_arg(*ap, long long);
f0105fec:	8b 45 14             	mov    0x14(%ebp),%eax
f0105fef:	8b 50 04             	mov    0x4(%eax),%edx
f0105ff2:	8b 00                	mov    (%eax),%eax
f0105ff4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105ff7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105ffa:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ffd:	8d 40 08             	lea    0x8(%eax),%eax
f0106000:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0106003:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106006:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106009:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010600c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f010600f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106013:	78 3f                	js     f0106054 <vprintfmt+0x2e7>
			base = 10;
f0106015:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f010601a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f010601e:	0f 84 71 01 00 00    	je     f0106195 <vprintfmt+0x428>
				putch('+', putdat);
f0106024:	83 ec 08             	sub    $0x8,%esp
f0106027:	53                   	push   %ebx
f0106028:	6a 2b                	push   $0x2b
f010602a:	ff d6                	call   *%esi
f010602c:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010602f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106034:	e9 5c 01 00 00       	jmp    f0106195 <vprintfmt+0x428>
		return va_arg(*ap, int);
f0106039:	8b 45 14             	mov    0x14(%ebp),%eax
f010603c:	8b 00                	mov    (%eax),%eax
f010603e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106041:	89 c1                	mov    %eax,%ecx
f0106043:	c1 f9 1f             	sar    $0x1f,%ecx
f0106046:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0106049:	8b 45 14             	mov    0x14(%ebp),%eax
f010604c:	8d 40 04             	lea    0x4(%eax),%eax
f010604f:	89 45 14             	mov    %eax,0x14(%ebp)
f0106052:	eb af                	jmp    f0106003 <vprintfmt+0x296>
				putch('-', putdat);
f0106054:	83 ec 08             	sub    $0x8,%esp
f0106057:	53                   	push   %ebx
f0106058:	6a 2d                	push   $0x2d
f010605a:	ff d6                	call   *%esi
				num = -(long long) num;
f010605c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010605f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0106062:	f7 d8                	neg    %eax
f0106064:	83 d2 00             	adc    $0x0,%edx
f0106067:	f7 da                	neg    %edx
f0106069:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010606c:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010606f:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0106072:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106077:	e9 19 01 00 00       	jmp    f0106195 <vprintfmt+0x428>
	if (lflag >= 2)
f010607c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0106080:	7f 29                	jg     f01060ab <vprintfmt+0x33e>
	else if (lflag)
f0106082:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106086:	74 44                	je     f01060cc <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f0106088:	8b 45 14             	mov    0x14(%ebp),%eax
f010608b:	8b 00                	mov    (%eax),%eax
f010608d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106092:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106095:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106098:	8b 45 14             	mov    0x14(%ebp),%eax
f010609b:	8d 40 04             	lea    0x4(%eax),%eax
f010609e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01060a1:	b8 0a 00 00 00       	mov    $0xa,%eax
f01060a6:	e9 ea 00 00 00       	jmp    f0106195 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f01060ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01060ae:	8b 50 04             	mov    0x4(%eax),%edx
f01060b1:	8b 00                	mov    (%eax),%eax
f01060b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060b9:	8b 45 14             	mov    0x14(%ebp),%eax
f01060bc:	8d 40 08             	lea    0x8(%eax),%eax
f01060bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01060c2:	b8 0a 00 00 00       	mov    $0xa,%eax
f01060c7:	e9 c9 00 00 00       	jmp    f0106195 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f01060cc:	8b 45 14             	mov    0x14(%ebp),%eax
f01060cf:	8b 00                	mov    (%eax),%eax
f01060d1:	ba 00 00 00 00       	mov    $0x0,%edx
f01060d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01060d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01060dc:	8b 45 14             	mov    0x14(%ebp),%eax
f01060df:	8d 40 04             	lea    0x4(%eax),%eax
f01060e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01060e5:	b8 0a 00 00 00       	mov    $0xa,%eax
f01060ea:	e9 a6 00 00 00       	jmp    f0106195 <vprintfmt+0x428>
			putch('0', putdat);
f01060ef:	83 ec 08             	sub    $0x8,%esp
f01060f2:	53                   	push   %ebx
f01060f3:	6a 30                	push   $0x30
f01060f5:	ff d6                	call   *%esi
	if (lflag >= 2)
f01060f7:	83 c4 10             	add    $0x10,%esp
f01060fa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01060fe:	7f 26                	jg     f0106126 <vprintfmt+0x3b9>
	else if (lflag)
f0106100:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0106104:	74 3e                	je     f0106144 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f0106106:	8b 45 14             	mov    0x14(%ebp),%eax
f0106109:	8b 00                	mov    (%eax),%eax
f010610b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106110:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106113:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106116:	8b 45 14             	mov    0x14(%ebp),%eax
f0106119:	8d 40 04             	lea    0x4(%eax),%eax
f010611c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010611f:	b8 08 00 00 00       	mov    $0x8,%eax
f0106124:	eb 6f                	jmp    f0106195 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106126:	8b 45 14             	mov    0x14(%ebp),%eax
f0106129:	8b 50 04             	mov    0x4(%eax),%edx
f010612c:	8b 00                	mov    (%eax),%eax
f010612e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106131:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106134:	8b 45 14             	mov    0x14(%ebp),%eax
f0106137:	8d 40 08             	lea    0x8(%eax),%eax
f010613a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010613d:	b8 08 00 00 00       	mov    $0x8,%eax
f0106142:	eb 51                	jmp    f0106195 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106144:	8b 45 14             	mov    0x14(%ebp),%eax
f0106147:	8b 00                	mov    (%eax),%eax
f0106149:	ba 00 00 00 00       	mov    $0x0,%edx
f010614e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106151:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106154:	8b 45 14             	mov    0x14(%ebp),%eax
f0106157:	8d 40 04             	lea    0x4(%eax),%eax
f010615a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010615d:	b8 08 00 00 00       	mov    $0x8,%eax
f0106162:	eb 31                	jmp    f0106195 <vprintfmt+0x428>
			putch('0', putdat);
f0106164:	83 ec 08             	sub    $0x8,%esp
f0106167:	53                   	push   %ebx
f0106168:	6a 30                	push   $0x30
f010616a:	ff d6                	call   *%esi
			putch('x', putdat);
f010616c:	83 c4 08             	add    $0x8,%esp
f010616f:	53                   	push   %ebx
f0106170:	6a 78                	push   $0x78
f0106172:	ff d6                	call   *%esi
			num = (unsigned long long)
f0106174:	8b 45 14             	mov    0x14(%ebp),%eax
f0106177:	8b 00                	mov    (%eax),%eax
f0106179:	ba 00 00 00 00       	mov    $0x0,%edx
f010617e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106181:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f0106184:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0106187:	8b 45 14             	mov    0x14(%ebp),%eax
f010618a:	8d 40 04             	lea    0x4(%eax),%eax
f010618d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106190:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0106195:	83 ec 0c             	sub    $0xc,%esp
f0106198:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f010619c:	52                   	push   %edx
f010619d:	ff 75 e0             	pushl  -0x20(%ebp)
f01061a0:	50                   	push   %eax
f01061a1:	ff 75 dc             	pushl  -0x24(%ebp)
f01061a4:	ff 75 d8             	pushl  -0x28(%ebp)
f01061a7:	89 da                	mov    %ebx,%edx
f01061a9:	89 f0                	mov    %esi,%eax
f01061ab:	e8 a4 fa ff ff       	call   f0105c54 <printnum>
			break;
f01061b0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01061b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01061b6:	83 c7 01             	add    $0x1,%edi
f01061b9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01061bd:	83 f8 25             	cmp    $0x25,%eax
f01061c0:	0f 84 be fb ff ff    	je     f0105d84 <vprintfmt+0x17>
			if (ch == '\0')
f01061c6:	85 c0                	test   %eax,%eax
f01061c8:	0f 84 28 01 00 00    	je     f01062f6 <vprintfmt+0x589>
			putch(ch, putdat);
f01061ce:	83 ec 08             	sub    $0x8,%esp
f01061d1:	53                   	push   %ebx
f01061d2:	50                   	push   %eax
f01061d3:	ff d6                	call   *%esi
f01061d5:	83 c4 10             	add    $0x10,%esp
f01061d8:	eb dc                	jmp    f01061b6 <vprintfmt+0x449>
	if (lflag >= 2)
f01061da:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f01061de:	7f 26                	jg     f0106206 <vprintfmt+0x499>
	else if (lflag)
f01061e0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01061e4:	74 41                	je     f0106227 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f01061e6:	8b 45 14             	mov    0x14(%ebp),%eax
f01061e9:	8b 00                	mov    (%eax),%eax
f01061eb:	ba 00 00 00 00       	mov    $0x0,%edx
f01061f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01061f6:	8b 45 14             	mov    0x14(%ebp),%eax
f01061f9:	8d 40 04             	lea    0x4(%eax),%eax
f01061fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01061ff:	b8 10 00 00 00       	mov    $0x10,%eax
f0106204:	eb 8f                	jmp    f0106195 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0106206:	8b 45 14             	mov    0x14(%ebp),%eax
f0106209:	8b 50 04             	mov    0x4(%eax),%edx
f010620c:	8b 00                	mov    (%eax),%eax
f010620e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106211:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106214:	8b 45 14             	mov    0x14(%ebp),%eax
f0106217:	8d 40 08             	lea    0x8(%eax),%eax
f010621a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010621d:	b8 10 00 00 00       	mov    $0x10,%eax
f0106222:	e9 6e ff ff ff       	jmp    f0106195 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0106227:	8b 45 14             	mov    0x14(%ebp),%eax
f010622a:	8b 00                	mov    (%eax),%eax
f010622c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106231:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106234:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106237:	8b 45 14             	mov    0x14(%ebp),%eax
f010623a:	8d 40 04             	lea    0x4(%eax),%eax
f010623d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106240:	b8 10 00 00 00       	mov    $0x10,%eax
f0106245:	e9 4b ff ff ff       	jmp    f0106195 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f010624a:	8b 45 14             	mov    0x14(%ebp),%eax
f010624d:	83 c0 04             	add    $0x4,%eax
f0106250:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106253:	8b 45 14             	mov    0x14(%ebp),%eax
f0106256:	8b 00                	mov    (%eax),%eax
f0106258:	85 c0                	test   %eax,%eax
f010625a:	74 14                	je     f0106270 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f010625c:	8b 13                	mov    (%ebx),%edx
f010625e:	83 fa 7f             	cmp    $0x7f,%edx
f0106261:	7f 37                	jg     f010629a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f0106263:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f0106265:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106268:	89 45 14             	mov    %eax,0x14(%ebp)
f010626b:	e9 43 ff ff ff       	jmp    f01061b3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f0106270:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106275:	bf e9 9a 10 f0       	mov    $0xf0109ae9,%edi
							putch(ch, putdat);
f010627a:	83 ec 08             	sub    $0x8,%esp
f010627d:	53                   	push   %ebx
f010627e:	50                   	push   %eax
f010627f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0106281:	83 c7 01             	add    $0x1,%edi
f0106284:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f0106288:	83 c4 10             	add    $0x10,%esp
f010628b:	85 c0                	test   %eax,%eax
f010628d:	75 eb                	jne    f010627a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f010628f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106292:	89 45 14             	mov    %eax,0x14(%ebp)
f0106295:	e9 19 ff ff ff       	jmp    f01061b3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f010629a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f010629c:	b8 0a 00 00 00       	mov    $0xa,%eax
f01062a1:	bf 21 9b 10 f0       	mov    $0xf0109b21,%edi
							putch(ch, putdat);
f01062a6:	83 ec 08             	sub    $0x8,%esp
f01062a9:	53                   	push   %ebx
f01062aa:	50                   	push   %eax
f01062ab:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f01062ad:	83 c7 01             	add    $0x1,%edi
f01062b0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f01062b4:	83 c4 10             	add    $0x10,%esp
f01062b7:	85 c0                	test   %eax,%eax
f01062b9:	75 eb                	jne    f01062a6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f01062bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01062be:	89 45 14             	mov    %eax,0x14(%ebp)
f01062c1:	e9 ed fe ff ff       	jmp    f01061b3 <vprintfmt+0x446>
			putch(ch, putdat);
f01062c6:	83 ec 08             	sub    $0x8,%esp
f01062c9:	53                   	push   %ebx
f01062ca:	6a 25                	push   $0x25
f01062cc:	ff d6                	call   *%esi
			break;
f01062ce:	83 c4 10             	add    $0x10,%esp
f01062d1:	e9 dd fe ff ff       	jmp    f01061b3 <vprintfmt+0x446>
			putch('%', putdat);
f01062d6:	83 ec 08             	sub    $0x8,%esp
f01062d9:	53                   	push   %ebx
f01062da:	6a 25                	push   $0x25
f01062dc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01062de:	83 c4 10             	add    $0x10,%esp
f01062e1:	89 f8                	mov    %edi,%eax
f01062e3:	eb 03                	jmp    f01062e8 <vprintfmt+0x57b>
f01062e5:	83 e8 01             	sub    $0x1,%eax
f01062e8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01062ec:	75 f7                	jne    f01062e5 <vprintfmt+0x578>
f01062ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01062f1:	e9 bd fe ff ff       	jmp    f01061b3 <vprintfmt+0x446>
}
f01062f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01062f9:	5b                   	pop    %ebx
f01062fa:	5e                   	pop    %esi
f01062fb:	5f                   	pop    %edi
f01062fc:	5d                   	pop    %ebp
f01062fd:	c3                   	ret    

f01062fe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01062fe:	55                   	push   %ebp
f01062ff:	89 e5                	mov    %esp,%ebp
f0106301:	83 ec 18             	sub    $0x18,%esp
f0106304:	8b 45 08             	mov    0x8(%ebp),%eax
f0106307:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f010630a:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010630d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106311:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0106314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010631b:	85 c0                	test   %eax,%eax
f010631d:	74 26                	je     f0106345 <vsnprintf+0x47>
f010631f:	85 d2                	test   %edx,%edx
f0106321:	7e 22                	jle    f0106345 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106323:	ff 75 14             	pushl  0x14(%ebp)
f0106326:	ff 75 10             	pushl  0x10(%ebp)
f0106329:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010632c:	50                   	push   %eax
f010632d:	68 33 5d 10 f0       	push   $0xf0105d33
f0106332:	e8 36 fa ff ff       	call   f0105d6d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106337:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010633a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010633d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106340:	83 c4 10             	add    $0x10,%esp
}
f0106343:	c9                   	leave  
f0106344:	c3                   	ret    
		return -E_INVAL;
f0106345:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010634a:	eb f7                	jmp    f0106343 <vsnprintf+0x45>

f010634c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010634c:	55                   	push   %ebp
f010634d:	89 e5                	mov    %esp,%ebp
f010634f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106352:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106355:	50                   	push   %eax
f0106356:	ff 75 10             	pushl  0x10(%ebp)
f0106359:	ff 75 0c             	pushl  0xc(%ebp)
f010635c:	ff 75 08             	pushl  0x8(%ebp)
f010635f:	e8 9a ff ff ff       	call   f01062fe <vsnprintf>
	va_end(ap);

	return rc;
}
f0106364:	c9                   	leave  
f0106365:	c3                   	ret    

f0106366 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106366:	55                   	push   %ebp
f0106367:	89 e5                	mov    %esp,%ebp
f0106369:	57                   	push   %edi
f010636a:	56                   	push   %esi
f010636b:	53                   	push   %ebx
f010636c:	83 ec 0c             	sub    $0xc,%esp
f010636f:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106372:	85 c0                	test   %eax,%eax
f0106374:	74 11                	je     f0106387 <readline+0x21>
		cprintf("%s", prompt);
f0106376:	83 ec 08             	sub    $0x8,%esp
f0106379:	50                   	push   %eax
f010637a:	68 3d 8e 10 f0       	push   $0xf0108e3d
f010637f:	e8 3d db ff ff       	call   f0103ec1 <cprintf>
f0106384:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106387:	83 ec 0c             	sub    $0xc,%esp
f010638a:	6a 00                	push   $0x0
f010638c:	e8 49 a4 ff ff       	call   f01007da <iscons>
f0106391:	89 c7                	mov    %eax,%edi
f0106393:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0106396:	be 00 00 00 00       	mov    $0x0,%esi
f010639b:	eb 57                	jmp    f01063f4 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f010639d:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f01063a2:	83 fb f8             	cmp    $0xfffffff8,%ebx
f01063a5:	75 08                	jne    f01063af <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f01063a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01063aa:	5b                   	pop    %ebx
f01063ab:	5e                   	pop    %esi
f01063ac:	5f                   	pop    %edi
f01063ad:	5d                   	pop    %ebp
f01063ae:	c3                   	ret    
				cprintf("read error: %e\n", c);
f01063af:	83 ec 08             	sub    $0x8,%esp
f01063b2:	53                   	push   %ebx
f01063b3:	68 48 9d 10 f0       	push   $0xf0109d48
f01063b8:	e8 04 db ff ff       	call   f0103ec1 <cprintf>
f01063bd:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01063c0:	b8 00 00 00 00       	mov    $0x0,%eax
f01063c5:	eb e0                	jmp    f01063a7 <readline+0x41>
			if (echoing)
f01063c7:	85 ff                	test   %edi,%edi
f01063c9:	75 05                	jne    f01063d0 <readline+0x6a>
			i--;
f01063cb:	83 ee 01             	sub    $0x1,%esi
f01063ce:	eb 24                	jmp    f01063f4 <readline+0x8e>
				cputchar('\b');
f01063d0:	83 ec 0c             	sub    $0xc,%esp
f01063d3:	6a 08                	push   $0x8
f01063d5:	e8 df a3 ff ff       	call   f01007b9 <cputchar>
f01063da:	83 c4 10             	add    $0x10,%esp
f01063dd:	eb ec                	jmp    f01063cb <readline+0x65>
				cputchar(c);
f01063df:	83 ec 0c             	sub    $0xc,%esp
f01063e2:	53                   	push   %ebx
f01063e3:	e8 d1 a3 ff ff       	call   f01007b9 <cputchar>
f01063e8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01063eb:	88 9e 80 fa 57 f0    	mov    %bl,-0xfa80580(%esi)
f01063f1:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01063f4:	e8 d0 a3 ff ff       	call   f01007c9 <getchar>
f01063f9:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01063fb:	85 c0                	test   %eax,%eax
f01063fd:	78 9e                	js     f010639d <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01063ff:	83 f8 08             	cmp    $0x8,%eax
f0106402:	0f 94 c2             	sete   %dl
f0106405:	83 f8 7f             	cmp    $0x7f,%eax
f0106408:	0f 94 c0             	sete   %al
f010640b:	08 c2                	or     %al,%dl
f010640d:	74 04                	je     f0106413 <readline+0xad>
f010640f:	85 f6                	test   %esi,%esi
f0106411:	7f b4                	jg     f01063c7 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106413:	83 fb 1f             	cmp    $0x1f,%ebx
f0106416:	7e 0e                	jle    f0106426 <readline+0xc0>
f0106418:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f010641e:	7f 06                	jg     f0106426 <readline+0xc0>
			if (echoing)
f0106420:	85 ff                	test   %edi,%edi
f0106422:	74 c7                	je     f01063eb <readline+0x85>
f0106424:	eb b9                	jmp    f01063df <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f0106426:	83 fb 0a             	cmp    $0xa,%ebx
f0106429:	74 05                	je     f0106430 <readline+0xca>
f010642b:	83 fb 0d             	cmp    $0xd,%ebx
f010642e:	75 c4                	jne    f01063f4 <readline+0x8e>
			if (echoing)
f0106430:	85 ff                	test   %edi,%edi
f0106432:	75 11                	jne    f0106445 <readline+0xdf>
			buf[i] = 0;
f0106434:	c6 86 80 fa 57 f0 00 	movb   $0x0,-0xfa80580(%esi)
			return buf;
f010643b:	b8 80 fa 57 f0       	mov    $0xf057fa80,%eax
f0106440:	e9 62 ff ff ff       	jmp    f01063a7 <readline+0x41>
				cputchar('\n');
f0106445:	83 ec 0c             	sub    $0xc,%esp
f0106448:	6a 0a                	push   $0xa
f010644a:	e8 6a a3 ff ff       	call   f01007b9 <cputchar>
f010644f:	83 c4 10             	add    $0x10,%esp
f0106452:	eb e0                	jmp    f0106434 <readline+0xce>

f0106454 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106454:	55                   	push   %ebp
f0106455:	89 e5                	mov    %esp,%ebp
f0106457:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010645a:	b8 00 00 00 00       	mov    $0x0,%eax
f010645f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106463:	74 05                	je     f010646a <strlen+0x16>
		n++;
f0106465:	83 c0 01             	add    $0x1,%eax
f0106468:	eb f5                	jmp    f010645f <strlen+0xb>
	return n;
}
f010646a:	5d                   	pop    %ebp
f010646b:	c3                   	ret    

f010646c <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010646c:	55                   	push   %ebp
f010646d:	89 e5                	mov    %esp,%ebp
f010646f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106472:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106475:	ba 00 00 00 00       	mov    $0x0,%edx
f010647a:	39 c2                	cmp    %eax,%edx
f010647c:	74 0d                	je     f010648b <strnlen+0x1f>
f010647e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106482:	74 05                	je     f0106489 <strnlen+0x1d>
		n++;
f0106484:	83 c2 01             	add    $0x1,%edx
f0106487:	eb f1                	jmp    f010647a <strnlen+0xe>
f0106489:	89 d0                	mov    %edx,%eax
	return n;
}
f010648b:	5d                   	pop    %ebp
f010648c:	c3                   	ret    

f010648d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010648d:	55                   	push   %ebp
f010648e:	89 e5                	mov    %esp,%ebp
f0106490:	53                   	push   %ebx
f0106491:	8b 45 08             	mov    0x8(%ebp),%eax
f0106494:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106497:	ba 00 00 00 00       	mov    $0x0,%edx
f010649c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f01064a0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f01064a3:	83 c2 01             	add    $0x1,%edx
f01064a6:	84 c9                	test   %cl,%cl
f01064a8:	75 f2                	jne    f010649c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f01064aa:	5b                   	pop    %ebx
f01064ab:	5d                   	pop    %ebp
f01064ac:	c3                   	ret    

f01064ad <strcat>:

char *
strcat(char *dst, const char *src)
{
f01064ad:	55                   	push   %ebp
f01064ae:	89 e5                	mov    %esp,%ebp
f01064b0:	53                   	push   %ebx
f01064b1:	83 ec 10             	sub    $0x10,%esp
f01064b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01064b7:	53                   	push   %ebx
f01064b8:	e8 97 ff ff ff       	call   f0106454 <strlen>
f01064bd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01064c0:	ff 75 0c             	pushl  0xc(%ebp)
f01064c3:	01 d8                	add    %ebx,%eax
f01064c5:	50                   	push   %eax
f01064c6:	e8 c2 ff ff ff       	call   f010648d <strcpy>
	return dst;
}
f01064cb:	89 d8                	mov    %ebx,%eax
f01064cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01064d0:	c9                   	leave  
f01064d1:	c3                   	ret    

f01064d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01064d2:	55                   	push   %ebp
f01064d3:	89 e5                	mov    %esp,%ebp
f01064d5:	56                   	push   %esi
f01064d6:	53                   	push   %ebx
f01064d7:	8b 45 08             	mov    0x8(%ebp),%eax
f01064da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01064dd:	89 c6                	mov    %eax,%esi
f01064df:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01064e2:	89 c2                	mov    %eax,%edx
f01064e4:	39 f2                	cmp    %esi,%edx
f01064e6:	74 11                	je     f01064f9 <strncpy+0x27>
		*dst++ = *src;
f01064e8:	83 c2 01             	add    $0x1,%edx
f01064eb:	0f b6 19             	movzbl (%ecx),%ebx
f01064ee:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01064f1:	80 fb 01             	cmp    $0x1,%bl
f01064f4:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01064f7:	eb eb                	jmp    f01064e4 <strncpy+0x12>
	}
	return ret;
}
f01064f9:	5b                   	pop    %ebx
f01064fa:	5e                   	pop    %esi
f01064fb:	5d                   	pop    %ebp
f01064fc:	c3                   	ret    

f01064fd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01064fd:	55                   	push   %ebp
f01064fe:	89 e5                	mov    %esp,%ebp
f0106500:	56                   	push   %esi
f0106501:	53                   	push   %ebx
f0106502:	8b 75 08             	mov    0x8(%ebp),%esi
f0106505:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106508:	8b 55 10             	mov    0x10(%ebp),%edx
f010650b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f010650d:	85 d2                	test   %edx,%edx
f010650f:	74 21                	je     f0106532 <strlcpy+0x35>
f0106511:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f0106515:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f0106517:	39 c2                	cmp    %eax,%edx
f0106519:	74 14                	je     f010652f <strlcpy+0x32>
f010651b:	0f b6 19             	movzbl (%ecx),%ebx
f010651e:	84 db                	test   %bl,%bl
f0106520:	74 0b                	je     f010652d <strlcpy+0x30>
			*dst++ = *src++;
f0106522:	83 c1 01             	add    $0x1,%ecx
f0106525:	83 c2 01             	add    $0x1,%edx
f0106528:	88 5a ff             	mov    %bl,-0x1(%edx)
f010652b:	eb ea                	jmp    f0106517 <strlcpy+0x1a>
f010652d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f010652f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106532:	29 f0                	sub    %esi,%eax
}
f0106534:	5b                   	pop    %ebx
f0106535:	5e                   	pop    %esi
f0106536:	5d                   	pop    %ebp
f0106537:	c3                   	ret    

f0106538 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0106538:	55                   	push   %ebp
f0106539:	89 e5                	mov    %esp,%ebp
f010653b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010653e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106541:	0f b6 01             	movzbl (%ecx),%eax
f0106544:	84 c0                	test   %al,%al
f0106546:	74 0c                	je     f0106554 <strcmp+0x1c>
f0106548:	3a 02                	cmp    (%edx),%al
f010654a:	75 08                	jne    f0106554 <strcmp+0x1c>
		p++, q++;
f010654c:	83 c1 01             	add    $0x1,%ecx
f010654f:	83 c2 01             	add    $0x1,%edx
f0106552:	eb ed                	jmp    f0106541 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106554:	0f b6 c0             	movzbl %al,%eax
f0106557:	0f b6 12             	movzbl (%edx),%edx
f010655a:	29 d0                	sub    %edx,%eax
}
f010655c:	5d                   	pop    %ebp
f010655d:	c3                   	ret    

f010655e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010655e:	55                   	push   %ebp
f010655f:	89 e5                	mov    %esp,%ebp
f0106561:	53                   	push   %ebx
f0106562:	8b 45 08             	mov    0x8(%ebp),%eax
f0106565:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106568:	89 c3                	mov    %eax,%ebx
f010656a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010656d:	eb 06                	jmp    f0106575 <strncmp+0x17>
		n--, p++, q++;
f010656f:	83 c0 01             	add    $0x1,%eax
f0106572:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0106575:	39 d8                	cmp    %ebx,%eax
f0106577:	74 16                	je     f010658f <strncmp+0x31>
f0106579:	0f b6 08             	movzbl (%eax),%ecx
f010657c:	84 c9                	test   %cl,%cl
f010657e:	74 04                	je     f0106584 <strncmp+0x26>
f0106580:	3a 0a                	cmp    (%edx),%cl
f0106582:	74 eb                	je     f010656f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106584:	0f b6 00             	movzbl (%eax),%eax
f0106587:	0f b6 12             	movzbl (%edx),%edx
f010658a:	29 d0                	sub    %edx,%eax
}
f010658c:	5b                   	pop    %ebx
f010658d:	5d                   	pop    %ebp
f010658e:	c3                   	ret    
		return 0;
f010658f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106594:	eb f6                	jmp    f010658c <strncmp+0x2e>

f0106596 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106596:	55                   	push   %ebp
f0106597:	89 e5                	mov    %esp,%ebp
f0106599:	8b 45 08             	mov    0x8(%ebp),%eax
f010659c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01065a0:	0f b6 10             	movzbl (%eax),%edx
f01065a3:	84 d2                	test   %dl,%dl
f01065a5:	74 09                	je     f01065b0 <strchr+0x1a>
		if (*s == c)
f01065a7:	38 ca                	cmp    %cl,%dl
f01065a9:	74 0a                	je     f01065b5 <strchr+0x1f>
	for (; *s; s++)
f01065ab:	83 c0 01             	add    $0x1,%eax
f01065ae:	eb f0                	jmp    f01065a0 <strchr+0xa>
			return (char *) s;
	return 0;
f01065b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01065b5:	5d                   	pop    %ebp
f01065b6:	c3                   	ret    

f01065b7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01065b7:	55                   	push   %ebp
f01065b8:	89 e5                	mov    %esp,%ebp
f01065ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01065bd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01065c1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01065c4:	38 ca                	cmp    %cl,%dl
f01065c6:	74 09                	je     f01065d1 <strfind+0x1a>
f01065c8:	84 d2                	test   %dl,%dl
f01065ca:	74 05                	je     f01065d1 <strfind+0x1a>
	for (; *s; s++)
f01065cc:	83 c0 01             	add    $0x1,%eax
f01065cf:	eb f0                	jmp    f01065c1 <strfind+0xa>
			break;
	return (char *) s;
}
f01065d1:	5d                   	pop    %ebp
f01065d2:	c3                   	ret    

f01065d3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01065d3:	55                   	push   %ebp
f01065d4:	89 e5                	mov    %esp,%ebp
f01065d6:	57                   	push   %edi
f01065d7:	56                   	push   %esi
f01065d8:	53                   	push   %ebx
f01065d9:	8b 7d 08             	mov    0x8(%ebp),%edi
f01065dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01065df:	85 c9                	test   %ecx,%ecx
f01065e1:	74 31                	je     f0106614 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01065e3:	89 f8                	mov    %edi,%eax
f01065e5:	09 c8                	or     %ecx,%eax
f01065e7:	a8 03                	test   $0x3,%al
f01065e9:	75 23                	jne    f010660e <memset+0x3b>
		c &= 0xFF;
f01065eb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01065ef:	89 d3                	mov    %edx,%ebx
f01065f1:	c1 e3 08             	shl    $0x8,%ebx
f01065f4:	89 d0                	mov    %edx,%eax
f01065f6:	c1 e0 18             	shl    $0x18,%eax
f01065f9:	89 d6                	mov    %edx,%esi
f01065fb:	c1 e6 10             	shl    $0x10,%esi
f01065fe:	09 f0                	or     %esi,%eax
f0106600:	09 c2                	or     %eax,%edx
f0106602:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0106604:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0106607:	89 d0                	mov    %edx,%eax
f0106609:	fc                   	cld    
f010660a:	f3 ab                	rep stos %eax,%es:(%edi)
f010660c:	eb 06                	jmp    f0106614 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010660e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106611:	fc                   	cld    
f0106612:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0106614:	89 f8                	mov    %edi,%eax
f0106616:	5b                   	pop    %ebx
f0106617:	5e                   	pop    %esi
f0106618:	5f                   	pop    %edi
f0106619:	5d                   	pop    %ebp
f010661a:	c3                   	ret    

f010661b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010661b:	55                   	push   %ebp
f010661c:	89 e5                	mov    %esp,%ebp
f010661e:	57                   	push   %edi
f010661f:	56                   	push   %esi
f0106620:	8b 45 08             	mov    0x8(%ebp),%eax
f0106623:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106626:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106629:	39 c6                	cmp    %eax,%esi
f010662b:	73 32                	jae    f010665f <memmove+0x44>
f010662d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106630:	39 c2                	cmp    %eax,%edx
f0106632:	76 2b                	jbe    f010665f <memmove+0x44>
		s += n;
		d += n;
f0106634:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106637:	89 fe                	mov    %edi,%esi
f0106639:	09 ce                	or     %ecx,%esi
f010663b:	09 d6                	or     %edx,%esi
f010663d:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106643:	75 0e                	jne    f0106653 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106645:	83 ef 04             	sub    $0x4,%edi
f0106648:	8d 72 fc             	lea    -0x4(%edx),%esi
f010664b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010664e:	fd                   	std    
f010664f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106651:	eb 09                	jmp    f010665c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106653:	83 ef 01             	sub    $0x1,%edi
f0106656:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0106659:	fd                   	std    
f010665a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010665c:	fc                   	cld    
f010665d:	eb 1a                	jmp    f0106679 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010665f:	89 c2                	mov    %eax,%edx
f0106661:	09 ca                	or     %ecx,%edx
f0106663:	09 f2                	or     %esi,%edx
f0106665:	f6 c2 03             	test   $0x3,%dl
f0106668:	75 0a                	jne    f0106674 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010666a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010666d:	89 c7                	mov    %eax,%edi
f010666f:	fc                   	cld    
f0106670:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106672:	eb 05                	jmp    f0106679 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0106674:	89 c7                	mov    %eax,%edi
f0106676:	fc                   	cld    
f0106677:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106679:	5e                   	pop    %esi
f010667a:	5f                   	pop    %edi
f010667b:	5d                   	pop    %ebp
f010667c:	c3                   	ret    

f010667d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010667d:	55                   	push   %ebp
f010667e:	89 e5                	mov    %esp,%ebp
f0106680:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106683:	ff 75 10             	pushl  0x10(%ebp)
f0106686:	ff 75 0c             	pushl  0xc(%ebp)
f0106689:	ff 75 08             	pushl  0x8(%ebp)
f010668c:	e8 8a ff ff ff       	call   f010661b <memmove>
}
f0106691:	c9                   	leave  
f0106692:	c3                   	ret    

f0106693 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106693:	55                   	push   %ebp
f0106694:	89 e5                	mov    %esp,%ebp
f0106696:	56                   	push   %esi
f0106697:	53                   	push   %ebx
f0106698:	8b 45 08             	mov    0x8(%ebp),%eax
f010669b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010669e:	89 c6                	mov    %eax,%esi
f01066a0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01066a3:	39 f0                	cmp    %esi,%eax
f01066a5:	74 1c                	je     f01066c3 <memcmp+0x30>
		if (*s1 != *s2)
f01066a7:	0f b6 08             	movzbl (%eax),%ecx
f01066aa:	0f b6 1a             	movzbl (%edx),%ebx
f01066ad:	38 d9                	cmp    %bl,%cl
f01066af:	75 08                	jne    f01066b9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01066b1:	83 c0 01             	add    $0x1,%eax
f01066b4:	83 c2 01             	add    $0x1,%edx
f01066b7:	eb ea                	jmp    f01066a3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01066b9:	0f b6 c1             	movzbl %cl,%eax
f01066bc:	0f b6 db             	movzbl %bl,%ebx
f01066bf:	29 d8                	sub    %ebx,%eax
f01066c1:	eb 05                	jmp    f01066c8 <memcmp+0x35>
	}

	return 0;
f01066c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01066c8:	5b                   	pop    %ebx
f01066c9:	5e                   	pop    %esi
f01066ca:	5d                   	pop    %ebp
f01066cb:	c3                   	ret    

f01066cc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01066cc:	55                   	push   %ebp
f01066cd:	89 e5                	mov    %esp,%ebp
f01066cf:	8b 45 08             	mov    0x8(%ebp),%eax
f01066d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01066d5:	89 c2                	mov    %eax,%edx
f01066d7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01066da:	39 d0                	cmp    %edx,%eax
f01066dc:	73 09                	jae    f01066e7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01066de:	38 08                	cmp    %cl,(%eax)
f01066e0:	74 05                	je     f01066e7 <memfind+0x1b>
	for (; s < ends; s++)
f01066e2:	83 c0 01             	add    $0x1,%eax
f01066e5:	eb f3                	jmp    f01066da <memfind+0xe>
			break;
	return (void *) s;
}
f01066e7:	5d                   	pop    %ebp
f01066e8:	c3                   	ret    

f01066e9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01066e9:	55                   	push   %ebp
f01066ea:	89 e5                	mov    %esp,%ebp
f01066ec:	57                   	push   %edi
f01066ed:	56                   	push   %esi
f01066ee:	53                   	push   %ebx
f01066ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01066f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01066f5:	eb 03                	jmp    f01066fa <strtol+0x11>
		s++;
f01066f7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01066fa:	0f b6 01             	movzbl (%ecx),%eax
f01066fd:	3c 20                	cmp    $0x20,%al
f01066ff:	74 f6                	je     f01066f7 <strtol+0xe>
f0106701:	3c 09                	cmp    $0x9,%al
f0106703:	74 f2                	je     f01066f7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0106705:	3c 2b                	cmp    $0x2b,%al
f0106707:	74 2a                	je     f0106733 <strtol+0x4a>
	int neg = 0;
f0106709:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f010670e:	3c 2d                	cmp    $0x2d,%al
f0106710:	74 2b                	je     f010673d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106712:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0106718:	75 0f                	jne    f0106729 <strtol+0x40>
f010671a:	80 39 30             	cmpb   $0x30,(%ecx)
f010671d:	74 28                	je     f0106747 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f010671f:	85 db                	test   %ebx,%ebx
f0106721:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106726:	0f 44 d8             	cmove  %eax,%ebx
f0106729:	b8 00 00 00 00       	mov    $0x0,%eax
f010672e:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106731:	eb 50                	jmp    f0106783 <strtol+0x9a>
		s++;
f0106733:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0106736:	bf 00 00 00 00       	mov    $0x0,%edi
f010673b:	eb d5                	jmp    f0106712 <strtol+0x29>
		s++, neg = 1;
f010673d:	83 c1 01             	add    $0x1,%ecx
f0106740:	bf 01 00 00 00       	mov    $0x1,%edi
f0106745:	eb cb                	jmp    f0106712 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106747:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010674b:	74 0e                	je     f010675b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f010674d:	85 db                	test   %ebx,%ebx
f010674f:	75 d8                	jne    f0106729 <strtol+0x40>
		s++, base = 8;
f0106751:	83 c1 01             	add    $0x1,%ecx
f0106754:	bb 08 00 00 00       	mov    $0x8,%ebx
f0106759:	eb ce                	jmp    f0106729 <strtol+0x40>
		s += 2, base = 16;
f010675b:	83 c1 02             	add    $0x2,%ecx
f010675e:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106763:	eb c4                	jmp    f0106729 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106765:	8d 72 9f             	lea    -0x61(%edx),%esi
f0106768:	89 f3                	mov    %esi,%ebx
f010676a:	80 fb 19             	cmp    $0x19,%bl
f010676d:	77 29                	ja     f0106798 <strtol+0xaf>
			dig = *s - 'a' + 10;
f010676f:	0f be d2             	movsbl %dl,%edx
f0106772:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106775:	3b 55 10             	cmp    0x10(%ebp),%edx
f0106778:	7d 30                	jge    f01067aa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010677a:	83 c1 01             	add    $0x1,%ecx
f010677d:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106781:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106783:	0f b6 11             	movzbl (%ecx),%edx
f0106786:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106789:	89 f3                	mov    %esi,%ebx
f010678b:	80 fb 09             	cmp    $0x9,%bl
f010678e:	77 d5                	ja     f0106765 <strtol+0x7c>
			dig = *s - '0';
f0106790:	0f be d2             	movsbl %dl,%edx
f0106793:	83 ea 30             	sub    $0x30,%edx
f0106796:	eb dd                	jmp    f0106775 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f0106798:	8d 72 bf             	lea    -0x41(%edx),%esi
f010679b:	89 f3                	mov    %esi,%ebx
f010679d:	80 fb 19             	cmp    $0x19,%bl
f01067a0:	77 08                	ja     f01067aa <strtol+0xc1>
			dig = *s - 'A' + 10;
f01067a2:	0f be d2             	movsbl %dl,%edx
f01067a5:	83 ea 37             	sub    $0x37,%edx
f01067a8:	eb cb                	jmp    f0106775 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f01067aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01067ae:	74 05                	je     f01067b5 <strtol+0xcc>
		*endptr = (char *) s;
f01067b0:	8b 75 0c             	mov    0xc(%ebp),%esi
f01067b3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01067b5:	89 c2                	mov    %eax,%edx
f01067b7:	f7 da                	neg    %edx
f01067b9:	85 ff                	test   %edi,%edi
f01067bb:	0f 45 c2             	cmovne %edx,%eax
}
f01067be:	5b                   	pop    %ebx
f01067bf:	5e                   	pop    %esi
f01067c0:	5f                   	pop    %edi
f01067c1:	5d                   	pop    %ebp
f01067c2:	c3                   	ret    
f01067c3:	90                   	nop

f01067c4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01067c4:	fa                   	cli    

	xorw    %ax, %ax
f01067c5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01067c7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01067c9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01067cb:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01067cd:	0f 01 16             	lgdtl  (%esi)
f01067d0:	7c 70                	jl     f0106842 <gdtdesc+0x2>
	movl    %cr0, %eax
f01067d2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01067d5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01067d9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01067dc:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01067e2:	08 00                	or     %al,(%eax)

f01067e4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01067e4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01067e8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01067ea:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01067ec:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01067ee:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01067f2:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01067f4:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01067f6:	b8 00 70 12 00       	mov    $0x127000,%eax
	movl    %eax, %cr3
f01067fb:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f01067fe:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f0106801:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f0106804:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f0106807:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f010680a:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f010680f:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106812:	8b 25 a4 0e 58 f0    	mov    0xf0580ea4,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106818:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f010681d:	b8 eb 01 10 f0       	mov    $0xf01001eb,%eax
	call    *%eax
f0106822:	ff d0                	call   *%eax

f0106824 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106824:	eb fe                	jmp    f0106824 <spin>
f0106826:	66 90                	xchg   %ax,%ax

f0106828 <gdt>:
	...
f0106830:	ff                   	(bad)  
f0106831:	ff 00                	incl   (%eax)
f0106833:	00 00                	add    %al,(%eax)
f0106835:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010683c:	00                   	.byte 0x0
f010683d:	92                   	xchg   %eax,%edx
f010683e:	cf                   	iret   
	...

f0106840 <gdtdesc>:
f0106840:	17                   	pop    %ss
f0106841:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0106846 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106846:	90                   	nop

f0106847 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106847:	55                   	push   %ebp
f0106848:	89 e5                	mov    %esp,%ebp
f010684a:	57                   	push   %edi
f010684b:	56                   	push   %esi
f010684c:	53                   	push   %ebx
f010684d:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106850:	8b 0d a8 0e 58 f0    	mov    0xf0580ea8,%ecx
f0106856:	89 c3                	mov    %eax,%ebx
f0106858:	c1 eb 0c             	shr    $0xc,%ebx
f010685b:	39 cb                	cmp    %ecx,%ebx
f010685d:	73 1a                	jae    f0106879 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f010685f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106865:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106868:	89 f8                	mov    %edi,%eax
f010686a:	c1 e8 0c             	shr    $0xc,%eax
f010686d:	39 c8                	cmp    %ecx,%eax
f010686f:	73 1a                	jae    f010688b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106871:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106877:	eb 27                	jmp    f01068a0 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106879:	50                   	push   %eax
f010687a:	68 74 7c 10 f0       	push   $0xf0107c74
f010687f:	6a 57                	push   $0x57
f0106881:	68 e5 9e 10 f0       	push   $0xf0109ee5
f0106886:	e8 be 97 ff ff       	call   f0100049 <_panic>
f010688b:	57                   	push   %edi
f010688c:	68 74 7c 10 f0       	push   $0xf0107c74
f0106891:	6a 57                	push   $0x57
f0106893:	68 e5 9e 10 f0       	push   $0xf0109ee5
f0106898:	e8 ac 97 ff ff       	call   f0100049 <_panic>
f010689d:	83 c3 10             	add    $0x10,%ebx
f01068a0:	39 fb                	cmp    %edi,%ebx
f01068a2:	73 30                	jae    f01068d4 <mpsearch1+0x8d>
f01068a4:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01068a6:	83 ec 04             	sub    $0x4,%esp
f01068a9:	6a 04                	push   $0x4
f01068ab:	68 f5 9e 10 f0       	push   $0xf0109ef5
f01068b0:	53                   	push   %ebx
f01068b1:	e8 dd fd ff ff       	call   f0106693 <memcmp>
f01068b6:	83 c4 10             	add    $0x10,%esp
f01068b9:	85 c0                	test   %eax,%eax
f01068bb:	75 e0                	jne    f010689d <mpsearch1+0x56>
f01068bd:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f01068bf:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f01068c2:	0f b6 0a             	movzbl (%edx),%ecx
f01068c5:	01 c8                	add    %ecx,%eax
f01068c7:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f01068ca:	39 f2                	cmp    %esi,%edx
f01068cc:	75 f4                	jne    f01068c2 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01068ce:	84 c0                	test   %al,%al
f01068d0:	75 cb                	jne    f010689d <mpsearch1+0x56>
f01068d2:	eb 05                	jmp    f01068d9 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01068d4:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01068d9:	89 d8                	mov    %ebx,%eax
f01068db:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01068de:	5b                   	pop    %ebx
f01068df:	5e                   	pop    %esi
f01068e0:	5f                   	pop    %edi
f01068e1:	5d                   	pop    %ebp
f01068e2:	c3                   	ret    

f01068e3 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01068e3:	55                   	push   %ebp
f01068e4:	89 e5                	mov    %esp,%ebp
f01068e6:	57                   	push   %edi
f01068e7:	56                   	push   %esi
f01068e8:	53                   	push   %ebx
f01068e9:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01068ec:	c7 05 c0 13 58 f0 20 	movl   $0xf0581020,0xf05813c0
f01068f3:	10 58 f0 
	if (PGNUM(pa) >= npages)
f01068f6:	83 3d a8 0e 58 f0 00 	cmpl   $0x0,0xf0580ea8
f01068fd:	0f 84 a3 00 00 00    	je     f01069a6 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106903:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f010690a:	85 c0                	test   %eax,%eax
f010690c:	0f 84 aa 00 00 00    	je     f01069bc <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f0106912:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106915:	ba 00 04 00 00       	mov    $0x400,%edx
f010691a:	e8 28 ff ff ff       	call   f0106847 <mpsearch1>
f010691f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106922:	85 c0                	test   %eax,%eax
f0106924:	75 1a                	jne    f0106940 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0106926:	ba 00 00 01 00       	mov    $0x10000,%edx
f010692b:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106930:	e8 12 ff ff ff       	call   f0106847 <mpsearch1>
f0106935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0106938:	85 c0                	test   %eax,%eax
f010693a:	0f 84 31 02 00 00    	je     f0106b71 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106943:	8b 58 04             	mov    0x4(%eax),%ebx
f0106946:	85 db                	test   %ebx,%ebx
f0106948:	0f 84 97 00 00 00    	je     f01069e5 <mp_init+0x102>
f010694e:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106952:	0f 85 8d 00 00 00    	jne    f01069e5 <mp_init+0x102>
f0106958:	89 d8                	mov    %ebx,%eax
f010695a:	c1 e8 0c             	shr    $0xc,%eax
f010695d:	3b 05 a8 0e 58 f0    	cmp    0xf0580ea8,%eax
f0106963:	0f 83 91 00 00 00    	jae    f01069fa <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106969:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f010696f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106971:	83 ec 04             	sub    $0x4,%esp
f0106974:	6a 04                	push   $0x4
f0106976:	68 fa 9e 10 f0       	push   $0xf0109efa
f010697b:	53                   	push   %ebx
f010697c:	e8 12 fd ff ff       	call   f0106693 <memcmp>
f0106981:	83 c4 10             	add    $0x10,%esp
f0106984:	85 c0                	test   %eax,%eax
f0106986:	0f 85 83 00 00 00    	jne    f0106a0f <mp_init+0x12c>
f010698c:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106990:	01 df                	add    %ebx,%edi
	sum = 0;
f0106992:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106994:	39 fb                	cmp    %edi,%ebx
f0106996:	0f 84 88 00 00 00    	je     f0106a24 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f010699c:	0f b6 0b             	movzbl (%ebx),%ecx
f010699f:	01 ca                	add    %ecx,%edx
f01069a1:	83 c3 01             	add    $0x1,%ebx
f01069a4:	eb ee                	jmp    f0106994 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01069a6:	68 00 04 00 00       	push   $0x400
f01069ab:	68 74 7c 10 f0       	push   $0xf0107c74
f01069b0:	6a 6f                	push   $0x6f
f01069b2:	68 e5 9e 10 f0       	push   $0xf0109ee5
f01069b7:	e8 8d 96 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f01069bc:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01069c3:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f01069c6:	2d 00 04 00 00       	sub    $0x400,%eax
f01069cb:	ba 00 04 00 00       	mov    $0x400,%edx
f01069d0:	e8 72 fe ff ff       	call   f0106847 <mpsearch1>
f01069d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01069d8:	85 c0                	test   %eax,%eax
f01069da:	0f 85 60 ff ff ff    	jne    f0106940 <mp_init+0x5d>
f01069e0:	e9 41 ff ff ff       	jmp    f0106926 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f01069e5:	83 ec 0c             	sub    $0xc,%esp
f01069e8:	68 58 9d 10 f0       	push   $0xf0109d58
f01069ed:	e8 cf d4 ff ff       	call   f0103ec1 <cprintf>
f01069f2:	83 c4 10             	add    $0x10,%esp
f01069f5:	e9 77 01 00 00       	jmp    f0106b71 <mp_init+0x28e>
f01069fa:	53                   	push   %ebx
f01069fb:	68 74 7c 10 f0       	push   $0xf0107c74
f0106a00:	68 90 00 00 00       	push   $0x90
f0106a05:	68 e5 9e 10 f0       	push   $0xf0109ee5
f0106a0a:	e8 3a 96 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106a0f:	83 ec 0c             	sub    $0xc,%esp
f0106a12:	68 88 9d 10 f0       	push   $0xf0109d88
f0106a17:	e8 a5 d4 ff ff       	call   f0103ec1 <cprintf>
f0106a1c:	83 c4 10             	add    $0x10,%esp
f0106a1f:	e9 4d 01 00 00       	jmp    f0106b71 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0106a24:	84 d2                	test   %dl,%dl
f0106a26:	75 16                	jne    f0106a3e <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0106a28:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0106a2c:	80 fa 01             	cmp    $0x1,%dl
f0106a2f:	74 05                	je     f0106a36 <mp_init+0x153>
f0106a31:	80 fa 04             	cmp    $0x4,%dl
f0106a34:	75 1d                	jne    f0106a53 <mp_init+0x170>
f0106a36:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0106a3a:	01 d9                	add    %ebx,%ecx
f0106a3c:	eb 36                	jmp    f0106a74 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106a3e:	83 ec 0c             	sub    $0xc,%esp
f0106a41:	68 bc 9d 10 f0       	push   $0xf0109dbc
f0106a46:	e8 76 d4 ff ff       	call   f0103ec1 <cprintf>
f0106a4b:	83 c4 10             	add    $0x10,%esp
f0106a4e:	e9 1e 01 00 00       	jmp    f0106b71 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106a53:	83 ec 08             	sub    $0x8,%esp
f0106a56:	0f b6 d2             	movzbl %dl,%edx
f0106a59:	52                   	push   %edx
f0106a5a:	68 e0 9d 10 f0       	push   $0xf0109de0
f0106a5f:	e8 5d d4 ff ff       	call   f0103ec1 <cprintf>
f0106a64:	83 c4 10             	add    $0x10,%esp
f0106a67:	e9 05 01 00 00       	jmp    f0106b71 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106a6c:	0f b6 13             	movzbl (%ebx),%edx
f0106a6f:	01 d0                	add    %edx,%eax
f0106a71:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106a74:	39 d9                	cmp    %ebx,%ecx
f0106a76:	75 f4                	jne    f0106a6c <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106a78:	02 46 2a             	add    0x2a(%esi),%al
f0106a7b:	75 1c                	jne    f0106a99 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106a7d:	c7 05 00 10 58 f0 01 	movl   $0x1,0xf0581000
f0106a84:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106a87:	8b 46 24             	mov    0x24(%esi),%eax
f0106a8a:	a3 00 20 5c f0       	mov    %eax,0xf05c2000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106a8f:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106a92:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106a97:	eb 4d                	jmp    f0106ae6 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106a99:	83 ec 0c             	sub    $0xc,%esp
f0106a9c:	68 00 9e 10 f0       	push   $0xf0109e00
f0106aa1:	e8 1b d4 ff ff       	call   f0103ec1 <cprintf>
f0106aa6:	83 c4 10             	add    $0x10,%esp
f0106aa9:	e9 c3 00 00 00       	jmp    f0106b71 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106aae:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106ab2:	74 11                	je     f0106ac5 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106ab4:	6b 05 c4 13 58 f0 74 	imul   $0x74,0xf05813c4,%eax
f0106abb:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0106ac0:	a3 c0 13 58 f0       	mov    %eax,0xf05813c0
			if (ncpu < NCPU) {
f0106ac5:	a1 c4 13 58 f0       	mov    0xf05813c4,%eax
f0106aca:	83 f8 07             	cmp    $0x7,%eax
f0106acd:	7f 2f                	jg     f0106afe <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0106acf:	6b d0 74             	imul   $0x74,%eax,%edx
f0106ad2:	88 82 20 10 58 f0    	mov    %al,-0xfa7efe0(%edx)
				ncpu++;
f0106ad8:	83 c0 01             	add    $0x1,%eax
f0106adb:	a3 c4 13 58 f0       	mov    %eax,0xf05813c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106ae0:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106ae3:	83 c3 01             	add    $0x1,%ebx
f0106ae6:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0106aea:	39 d8                	cmp    %ebx,%eax
f0106aec:	76 4b                	jbe    f0106b39 <mp_init+0x256>
		switch (*p) {
f0106aee:	0f b6 07             	movzbl (%edi),%eax
f0106af1:	84 c0                	test   %al,%al
f0106af3:	74 b9                	je     f0106aae <mp_init+0x1cb>
f0106af5:	3c 04                	cmp    $0x4,%al
f0106af7:	77 1c                	ja     f0106b15 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106af9:	83 c7 08             	add    $0x8,%edi
			continue;
f0106afc:	eb e5                	jmp    f0106ae3 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106afe:	83 ec 08             	sub    $0x8,%esp
f0106b01:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106b05:	50                   	push   %eax
f0106b06:	68 30 9e 10 f0       	push   $0xf0109e30
f0106b0b:	e8 b1 d3 ff ff       	call   f0103ec1 <cprintf>
f0106b10:	83 c4 10             	add    $0x10,%esp
f0106b13:	eb cb                	jmp    f0106ae0 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106b15:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106b18:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106b1b:	50                   	push   %eax
f0106b1c:	68 58 9e 10 f0       	push   $0xf0109e58
f0106b21:	e8 9b d3 ff ff       	call   f0103ec1 <cprintf>
			ismp = 0;
f0106b26:	c7 05 00 10 58 f0 00 	movl   $0x0,0xf0581000
f0106b2d:	00 00 00 
			i = conf->entry;
f0106b30:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106b34:	83 c4 10             	add    $0x10,%esp
f0106b37:	eb aa                	jmp    f0106ae3 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106b39:	a1 c0 13 58 f0       	mov    0xf05813c0,%eax
f0106b3e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106b45:	83 3d 00 10 58 f0 00 	cmpl   $0x0,0xf0581000
f0106b4c:	74 2b                	je     f0106b79 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106b4e:	83 ec 04             	sub    $0x4,%esp
f0106b51:	ff 35 c4 13 58 f0    	pushl  0xf05813c4
f0106b57:	0f b6 00             	movzbl (%eax),%eax
f0106b5a:	50                   	push   %eax
f0106b5b:	68 ff 9e 10 f0       	push   $0xf0109eff
f0106b60:	e8 5c d3 ff ff       	call   f0103ec1 <cprintf>

	if (mp->imcrp) {
f0106b65:	83 c4 10             	add    $0x10,%esp
f0106b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106b6b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106b6f:	75 2e                	jne    f0106b9f <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106b74:	5b                   	pop    %ebx
f0106b75:	5e                   	pop    %esi
f0106b76:	5f                   	pop    %edi
f0106b77:	5d                   	pop    %ebp
f0106b78:	c3                   	ret    
		ncpu = 1;
f0106b79:	c7 05 c4 13 58 f0 01 	movl   $0x1,0xf05813c4
f0106b80:	00 00 00 
		lapicaddr = 0;
f0106b83:	c7 05 00 20 5c f0 00 	movl   $0x0,0xf05c2000
f0106b8a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106b8d:	83 ec 0c             	sub    $0xc,%esp
f0106b90:	68 78 9e 10 f0       	push   $0xf0109e78
f0106b95:	e8 27 d3 ff ff       	call   f0103ec1 <cprintf>
		return;
f0106b9a:	83 c4 10             	add    $0x10,%esp
f0106b9d:	eb d2                	jmp    f0106b71 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106b9f:	83 ec 0c             	sub    $0xc,%esp
f0106ba2:	68 a4 9e 10 f0       	push   $0xf0109ea4
f0106ba7:	e8 15 d3 ff ff       	call   f0103ec1 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106bac:	b8 70 00 00 00       	mov    $0x70,%eax
f0106bb1:	ba 22 00 00 00       	mov    $0x22,%edx
f0106bb6:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106bb7:	ba 23 00 00 00       	mov    $0x23,%edx
f0106bbc:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106bbd:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106bc0:	ee                   	out    %al,(%dx)
f0106bc1:	83 c4 10             	add    $0x10,%esp
f0106bc4:	eb ab                	jmp    f0106b71 <mp_init+0x28e>

f0106bc6 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106bc6:	8b 0d 04 20 5c f0    	mov    0xf05c2004,%ecx
f0106bcc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106bcf:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106bd1:	a1 04 20 5c f0       	mov    0xf05c2004,%eax
f0106bd6:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106bd9:	c3                   	ret    

f0106bda <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f0106bda:	8b 15 04 20 5c f0    	mov    0xf05c2004,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f0106be0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f0106be5:	85 d2                	test   %edx,%edx
f0106be7:	74 06                	je     f0106bef <cpunum+0x15>
		return lapic[ID] >> 24;
f0106be9:	8b 42 20             	mov    0x20(%edx),%eax
f0106bec:	c1 e8 18             	shr    $0x18,%eax
}
f0106bef:	c3                   	ret    

f0106bf0 <lapic_init>:
	if (!lapicaddr)
f0106bf0:	a1 00 20 5c f0       	mov    0xf05c2000,%eax
f0106bf5:	85 c0                	test   %eax,%eax
f0106bf7:	75 01                	jne    f0106bfa <lapic_init+0xa>
f0106bf9:	c3                   	ret    
{
f0106bfa:	55                   	push   %ebp
f0106bfb:	89 e5                	mov    %esp,%ebp
f0106bfd:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106c00:	68 00 10 00 00       	push   $0x1000
f0106c05:	50                   	push   %eax
f0106c06:	e8 d7 aa ff ff       	call   f01016e2 <mmio_map_region>
f0106c0b:	a3 04 20 5c f0       	mov    %eax,0xf05c2004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106c10:	ba 27 01 00 00       	mov    $0x127,%edx
f0106c15:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106c1a:	e8 a7 ff ff ff       	call   f0106bc6 <lapicw>
	lapicw(TDCR, X1);
f0106c1f:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106c24:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106c29:	e8 98 ff ff ff       	call   f0106bc6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106c2e:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106c33:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106c38:	e8 89 ff ff ff       	call   f0106bc6 <lapicw>
	lapicw(TICR, 10000000); 
f0106c3d:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106c42:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106c47:	e8 7a ff ff ff       	call   f0106bc6 <lapicw>
	if (thiscpu != bootcpu)
f0106c4c:	e8 89 ff ff ff       	call   f0106bda <cpunum>
f0106c51:	6b c0 74             	imul   $0x74,%eax,%eax
f0106c54:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0106c59:	83 c4 10             	add    $0x10,%esp
f0106c5c:	39 05 c0 13 58 f0    	cmp    %eax,0xf05813c0
f0106c62:	74 0f                	je     f0106c73 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106c64:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c69:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106c6e:	e8 53 ff ff ff       	call   f0106bc6 <lapicw>
	lapicw(LINT1, MASKED);
f0106c73:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106c78:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106c7d:	e8 44 ff ff ff       	call   f0106bc6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106c82:	a1 04 20 5c f0       	mov    0xf05c2004,%eax
f0106c87:	8b 40 30             	mov    0x30(%eax),%eax
f0106c8a:	c1 e8 10             	shr    $0x10,%eax
f0106c8d:	a8 fc                	test   $0xfc,%al
f0106c8f:	75 7c                	jne    f0106d0d <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106c91:	ba 33 00 00 00       	mov    $0x33,%edx
f0106c96:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106c9b:	e8 26 ff ff ff       	call   f0106bc6 <lapicw>
	lapicw(ESR, 0);
f0106ca0:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ca5:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106caa:	e8 17 ff ff ff       	call   f0106bc6 <lapicw>
	lapicw(ESR, 0);
f0106caf:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cb4:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106cb9:	e8 08 ff ff ff       	call   f0106bc6 <lapicw>
	lapicw(EOI, 0);
f0106cbe:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cc3:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106cc8:	e8 f9 fe ff ff       	call   f0106bc6 <lapicw>
	lapicw(ICRHI, 0);
f0106ccd:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cd2:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106cd7:	e8 ea fe ff ff       	call   f0106bc6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106cdc:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106ce1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106ce6:	e8 db fe ff ff       	call   f0106bc6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106ceb:	8b 15 04 20 5c f0    	mov    0xf05c2004,%edx
f0106cf1:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106cf7:	f6 c4 10             	test   $0x10,%ah
f0106cfa:	75 f5                	jne    f0106cf1 <lapic_init+0x101>
	lapicw(TPR, 0);
f0106cfc:	ba 00 00 00 00       	mov    $0x0,%edx
f0106d01:	b8 20 00 00 00       	mov    $0x20,%eax
f0106d06:	e8 bb fe ff ff       	call   f0106bc6 <lapicw>
}
f0106d0b:	c9                   	leave  
f0106d0c:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106d0d:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106d12:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106d17:	e8 aa fe ff ff       	call   f0106bc6 <lapicw>
f0106d1c:	e9 70 ff ff ff       	jmp    f0106c91 <lapic_init+0xa1>

f0106d21 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106d21:	83 3d 04 20 5c f0 00 	cmpl   $0x0,0xf05c2004
f0106d28:	74 17                	je     f0106d41 <lapic_eoi+0x20>
{
f0106d2a:	55                   	push   %ebp
f0106d2b:	89 e5                	mov    %esp,%ebp
f0106d2d:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106d30:	ba 00 00 00 00       	mov    $0x0,%edx
f0106d35:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106d3a:	e8 87 fe ff ff       	call   f0106bc6 <lapicw>
}
f0106d3f:	c9                   	leave  
f0106d40:	c3                   	ret    
f0106d41:	c3                   	ret    

f0106d42 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106d42:	55                   	push   %ebp
f0106d43:	89 e5                	mov    %esp,%ebp
f0106d45:	56                   	push   %esi
f0106d46:	53                   	push   %ebx
f0106d47:	8b 75 08             	mov    0x8(%ebp),%esi
f0106d4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106d4d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106d52:	ba 70 00 00 00       	mov    $0x70,%edx
f0106d57:	ee                   	out    %al,(%dx)
f0106d58:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106d5d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106d62:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106d63:	83 3d a8 0e 58 f0 00 	cmpl   $0x0,0xf0580ea8
f0106d6a:	74 7e                	je     f0106dea <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106d6c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106d73:	00 00 
	wrv[1] = addr >> 4;
f0106d75:	89 d8                	mov    %ebx,%eax
f0106d77:	c1 e8 04             	shr    $0x4,%eax
f0106d7a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106d80:	c1 e6 18             	shl    $0x18,%esi
f0106d83:	89 f2                	mov    %esi,%edx
f0106d85:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106d8a:	e8 37 fe ff ff       	call   f0106bc6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106d8f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106d94:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106d99:	e8 28 fe ff ff       	call   f0106bc6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106d9e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106da3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106da8:	e8 19 fe ff ff       	call   f0106bc6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106dad:	c1 eb 0c             	shr    $0xc,%ebx
f0106db0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106db3:	89 f2                	mov    %esi,%edx
f0106db5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106dba:	e8 07 fe ff ff       	call   f0106bc6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106dbf:	89 da                	mov    %ebx,%edx
f0106dc1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106dc6:	e8 fb fd ff ff       	call   f0106bc6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106dcb:	89 f2                	mov    %esi,%edx
f0106dcd:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106dd2:	e8 ef fd ff ff       	call   f0106bc6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106dd7:	89 da                	mov    %ebx,%edx
f0106dd9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106dde:	e8 e3 fd ff ff       	call   f0106bc6 <lapicw>
		microdelay(200);
	}
}
f0106de3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106de6:	5b                   	pop    %ebx
f0106de7:	5e                   	pop    %esi
f0106de8:	5d                   	pop    %ebp
f0106de9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106dea:	68 67 04 00 00       	push   $0x467
f0106def:	68 74 7c 10 f0       	push   $0xf0107c74
f0106df4:	68 9c 00 00 00       	push   $0x9c
f0106df9:	68 1c 9f 10 f0       	push   $0xf0109f1c
f0106dfe:	e8 46 92 ff ff       	call   f0100049 <_panic>

f0106e03 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106e03:	55                   	push   %ebp
f0106e04:	89 e5                	mov    %esp,%ebp
f0106e06:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106e09:	8b 55 08             	mov    0x8(%ebp),%edx
f0106e0c:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106e12:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106e17:	e8 aa fd ff ff       	call   f0106bc6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106e1c:	8b 15 04 20 5c f0    	mov    0xf05c2004,%edx
f0106e22:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106e28:	f6 c4 10             	test   $0x10,%ah
f0106e2b:	75 f5                	jne    f0106e22 <lapic_ipi+0x1f>
		;
}
f0106e2d:	c9                   	leave  
f0106e2e:	c3                   	ret    

f0106e2f <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106e2f:	55                   	push   %ebp
f0106e30:	89 e5                	mov    %esp,%ebp
f0106e32:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106e35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106e3e:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106e41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106e48:	5d                   	pop    %ebp
f0106e49:	c3                   	ret    

f0106e4a <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106e4a:	55                   	push   %ebp
f0106e4b:	89 e5                	mov    %esp,%ebp
f0106e4d:	56                   	push   %esi
f0106e4e:	53                   	push   %ebx
f0106e4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106e52:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106e55:	75 12                	jne    f0106e69 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0106e57:	ba 01 00 00 00       	mov    $0x1,%edx
f0106e5c:	89 d0                	mov    %edx,%eax
f0106e5e:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106e61:	85 c0                	test   %eax,%eax
f0106e63:	74 36                	je     f0106e9b <spin_lock+0x51>
		asm volatile ("pause");
f0106e65:	f3 90                	pause  
f0106e67:	eb f3                	jmp    f0106e5c <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0106e69:	8b 73 08             	mov    0x8(%ebx),%esi
f0106e6c:	e8 69 fd ff ff       	call   f0106bda <cpunum>
f0106e71:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e74:	05 20 10 58 f0       	add    $0xf0581020,%eax
	if (holding(lk))
f0106e79:	39 c6                	cmp    %eax,%esi
f0106e7b:	75 da                	jne    f0106e57 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106e7d:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106e80:	e8 55 fd ff ff       	call   f0106bda <cpunum>
f0106e85:	83 ec 0c             	sub    $0xc,%esp
f0106e88:	53                   	push   %ebx
f0106e89:	50                   	push   %eax
f0106e8a:	68 2c 9f 10 f0       	push   $0xf0109f2c
f0106e8f:	6a 41                	push   $0x41
f0106e91:	68 8e 9f 10 f0       	push   $0xf0109f8e
f0106e96:	e8 ae 91 ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106e9b:	e8 3a fd ff ff       	call   f0106bda <cpunum>
f0106ea0:	6b c0 74             	imul   $0x74,%eax,%eax
f0106ea3:	05 20 10 58 f0       	add    $0xf0581020,%eax
f0106ea8:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0106eab:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106ead:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106eb2:	83 f8 09             	cmp    $0x9,%eax
f0106eb5:	7f 16                	jg     f0106ecd <spin_lock+0x83>
f0106eb7:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106ebd:	76 0e                	jbe    f0106ecd <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106ebf:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106ec2:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106ec6:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106ec8:	83 c0 01             	add    $0x1,%eax
f0106ecb:	eb e5                	jmp    f0106eb2 <spin_lock+0x68>
	for (; i < 10; i++)
f0106ecd:	83 f8 09             	cmp    $0x9,%eax
f0106ed0:	7f 0d                	jg     f0106edf <spin_lock+0x95>
		pcs[i] = 0;
f0106ed2:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106ed9:	00 
	for (; i < 10; i++)
f0106eda:	83 c0 01             	add    $0x1,%eax
f0106edd:	eb ee                	jmp    f0106ecd <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106edf:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106ee2:	5b                   	pop    %ebx
f0106ee3:	5e                   	pop    %esi
f0106ee4:	5d                   	pop    %ebp
f0106ee5:	c3                   	ret    

f0106ee6 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106ee6:	55                   	push   %ebp
f0106ee7:	89 e5                	mov    %esp,%ebp
f0106ee9:	57                   	push   %edi
f0106eea:	56                   	push   %esi
f0106eeb:	53                   	push   %ebx
f0106eec:	83 ec 4c             	sub    $0x4c,%esp
f0106eef:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106ef2:	83 3e 00             	cmpl   $0x0,(%esi)
f0106ef5:	75 35                	jne    f0106f2c <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106ef7:	83 ec 04             	sub    $0x4,%esp
f0106efa:	6a 28                	push   $0x28
f0106efc:	8d 46 0c             	lea    0xc(%esi),%eax
f0106eff:	50                   	push   %eax
f0106f00:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106f03:	53                   	push   %ebx
f0106f04:	e8 12 f7 ff ff       	call   f010661b <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106f09:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106f0c:	0f b6 38             	movzbl (%eax),%edi
f0106f0f:	8b 76 04             	mov    0x4(%esi),%esi
f0106f12:	e8 c3 fc ff ff       	call   f0106bda <cpunum>
f0106f17:	57                   	push   %edi
f0106f18:	56                   	push   %esi
f0106f19:	50                   	push   %eax
f0106f1a:	68 58 9f 10 f0       	push   $0xf0109f58
f0106f1f:	e8 9d cf ff ff       	call   f0103ec1 <cprintf>
f0106f24:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106f27:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106f2a:	eb 4e                	jmp    f0106f7a <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0106f2c:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106f2f:	e8 a6 fc ff ff       	call   f0106bda <cpunum>
f0106f34:	6b c0 74             	imul   $0x74,%eax,%eax
f0106f37:	05 20 10 58 f0       	add    $0xf0581020,%eax
	if (!holding(lk)) {
f0106f3c:	39 c3                	cmp    %eax,%ebx
f0106f3e:	75 b7                	jne    f0106ef7 <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0106f40:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106f47:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106f4e:	b8 00 00 00 00       	mov    $0x0,%eax
f0106f53:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106f59:	5b                   	pop    %ebx
f0106f5a:	5e                   	pop    %esi
f0106f5b:	5f                   	pop    %edi
f0106f5c:	5d                   	pop    %ebp
f0106f5d:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106f5e:	83 ec 08             	sub    $0x8,%esp
f0106f61:	ff 36                	pushl  (%esi)
f0106f63:	68 b5 9f 10 f0       	push   $0xf0109fb5
f0106f68:	e8 54 cf ff ff       	call   f0103ec1 <cprintf>
f0106f6d:	83 c4 10             	add    $0x10,%esp
f0106f70:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106f73:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106f76:	39 c3                	cmp    %eax,%ebx
f0106f78:	74 40                	je     f0106fba <spin_unlock+0xd4>
f0106f7a:	89 de                	mov    %ebx,%esi
f0106f7c:	8b 03                	mov    (%ebx),%eax
f0106f7e:	85 c0                	test   %eax,%eax
f0106f80:	74 38                	je     f0106fba <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106f82:	83 ec 08             	sub    $0x8,%esp
f0106f85:	57                   	push   %edi
f0106f86:	50                   	push   %eax
f0106f87:	e8 e0 e9 ff ff       	call   f010596c <debuginfo_eip>
f0106f8c:	83 c4 10             	add    $0x10,%esp
f0106f8f:	85 c0                	test   %eax,%eax
f0106f91:	78 cb                	js     f0106f5e <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106f93:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106f95:	83 ec 04             	sub    $0x4,%esp
f0106f98:	89 c2                	mov    %eax,%edx
f0106f9a:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106f9d:	52                   	push   %edx
f0106f9e:	ff 75 b0             	pushl  -0x50(%ebp)
f0106fa1:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106fa4:	ff 75 ac             	pushl  -0x54(%ebp)
f0106fa7:	ff 75 a8             	pushl  -0x58(%ebp)
f0106faa:	50                   	push   %eax
f0106fab:	68 9e 9f 10 f0       	push   $0xf0109f9e
f0106fb0:	e8 0c cf ff ff       	call   f0103ec1 <cprintf>
f0106fb5:	83 c4 20             	add    $0x20,%esp
f0106fb8:	eb b6                	jmp    f0106f70 <spin_unlock+0x8a>
		panic("spin_unlock");
f0106fba:	83 ec 04             	sub    $0x4,%esp
f0106fbd:	68 bd 9f 10 f0       	push   $0xf0109fbd
f0106fc2:	6a 67                	push   $0x67
f0106fc4:	68 8e 9f 10 f0       	push   $0xf0109f8e
f0106fc9:	e8 7b 90 ff ff       	call   f0100049 <_panic>

f0106fce <e1000_tx_init>:
    base->RDH = head;
}

int
e1000_tx_init()
{
f0106fce:	55                   	push   %ebp
f0106fcf:	89 e5                	mov    %esp,%ebp
f0106fd1:	57                   	push   %edi
f0106fd2:	56                   	push   %esi
f0106fd3:	53                   	push   %ebx
f0106fd4:	83 ec 18             	sub    $0x18,%esp
	// base->TIPG |= E1000_TIPG_DEFAULT;
	// return 0;


		// Allocate one page for descriptors
	struct PageInfo* page =  page_alloc(1);
f0106fd7:	6a 01                	push   $0x1
f0106fd9:	e8 e6 a2 ff ff       	call   f01012c4 <page_alloc>
	return (pp - pages) << PGSHIFT;
f0106fde:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0106fe4:	c1 f8 03             	sar    $0x3,%eax
f0106fe7:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0106fea:	89 c2                	mov    %eax,%edx
f0106fec:	c1 ea 0c             	shr    $0xc,%edx
f0106fef:	83 c4 10             	add    $0x10,%esp
f0106ff2:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0106ff8:	0f 83 f8 00 00 00    	jae    f01070f6 <e1000_tx_init+0x128>
	return (void *)(pa + KERNBASE);
f0106ffe:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107003:	a3 20 20 5c f0       	mov    %eax,0xf05c2020
f0107008:	ba 40 fc 6f f0       	mov    $0xf06ffc40,%edx
f010700d:	b9 40 fc 6f 00       	mov    $0x6ffc40,%ecx
f0107012:	bb 00 00 00 00       	mov    $0x0,%ebx
f0107017:	bf 40 ea 75 f0       	mov    $0xf075ea40,%edi
	tx_descs = page2kva(page);
f010701c:	b8 00 00 00 00       	mov    $0x0,%eax
	if ((uint32_t)kva < KERNBASE)
f0107021:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0107027:	0f 86 db 00 00 00    	jbe    f0107108 <e1000_tx_init+0x13a>
	
	// Initialize all descriptors
	for(int i = 0; i < N_TXDESC; i++){
		tx_descs[i].addr = PADDR(transmit_packet_buffer[i]);
f010702d:	8b 35 20 20 5c f0    	mov    0xf05c2020,%esi
f0107033:	89 0c 06             	mov    %ecx,(%esi,%eax,1)
f0107036:	89 5c 06 04          	mov    %ebx,0x4(%esi,%eax,1)
		set_dd_bit(&tx_descs[i]);
f010703a:	8b 35 20 20 5c f0    	mov    0xf05c2020,%esi
    ptr->status |= E1000_TX_STATUS_DD;
f0107040:	80 4c 06 0c 01       	orb    $0x1,0xc(%esi,%eax,1)
f0107045:	81 c2 ee 05 00 00    	add    $0x5ee,%edx
f010704b:	83 c0 10             	add    $0x10,%eax
f010704e:	81 c1 ee 05 00 00    	add    $0x5ee,%ecx
f0107054:	83 d3 00             	adc    $0x0,%ebx
	for(int i = 0; i < N_TXDESC; i++){
f0107057:	39 fa                	cmp    %edi,%edx
f0107059:	75 c6                	jne    f0107021 <e1000_tx_init+0x53>
	}

	// Set hardware registers
	// Look kern/e1000.h to find useful definations
	base->TDBAL = (uint32_t)PADDR(tx_descs);
f010705b:	a1 84 fe 57 f0       	mov    0xf057fe84,%eax
f0107060:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f0107066:	0f 86 ae 00 00 00    	jbe    f010711a <e1000_tx_init+0x14c>
	return (physaddr_t)kva - KERNBASE;
f010706c:	81 c6 00 00 00 10    	add    $0x10000000,%esi
f0107072:	89 b0 00 38 00 00    	mov    %esi,0x3800(%eax)
	base->TDBAH = 0;
f0107078:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f010707f:	00 00 00 
	base->TDLEN = N_TXDESC * sizeof(struct tx_desc);
f0107082:	c7 80 08 38 00 00 00 	movl   $0x1000,0x3808(%eax)
f0107089:	10 00 00 
	base->TDH = 0;
f010708c:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f0107093:	00 00 00 
	base->TDT = 0;
f0107096:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f010709d:	00 00 00 
	//TCTL.EN
	base->TCTL |= E1000_TCTL_EN;
f01070a0:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f01070a6:	83 ca 02             	or     $0x2,%edx
f01070a9:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	//TCTL.PSP
	base->TCTL |= E1000_TCTL_PSP;
f01070af:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f01070b5:	83 ca 08             	or     $0x8,%edx
f01070b8:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	//base->TCTL &= ~E1000_TCTL_CT;
	//TCTL.CT
	base->TCTL |= E1000_TCTL_CT_ETHER;
f01070be:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f01070c4:	80 ce 01             	or     $0x1,%dh
f01070c7:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	//base->TCTL &= ~E1000_TCTL_COLD;
	//TCTL.COLD
	base->TCTL |= E1000_TCTL_COLD_FULL_DUPLEX;
f01070cd:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f01070d3:	81 ca 00 00 04 00    	or     $0x40000,%edx
f01070d9:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	//TIPG
	base->TIPG = E1000_TIPG_DEFAULT;
f01070df:	c7 80 10 04 00 00 0a 	movl   $0x60100a,0x410(%eax)
f01070e6:	10 60 00 
	return 0;
}
f01070e9:	b8 00 00 00 00       	mov    $0x0,%eax
f01070ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01070f1:	5b                   	pop    %ebx
f01070f2:	5e                   	pop    %esi
f01070f3:	5f                   	pop    %edi
f01070f4:	5d                   	pop    %ebp
f01070f5:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01070f6:	50                   	push   %eax
f01070f7:	68 74 7c 10 f0       	push   $0xf0107c74
f01070fc:	6a 58                	push   $0x58
f01070fe:	68 11 8e 10 f0       	push   $0xf0108e11
f0107103:	e8 41 8f ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107108:	52                   	push   %edx
f0107109:	68 98 7c 10 f0       	push   $0xf0107c98
f010710e:	6a 62                	push   $0x62
f0107110:	68 d5 9f 10 f0       	push   $0xf0109fd5
f0107115:	e8 2f 8f ff ff       	call   f0100049 <_panic>
f010711a:	56                   	push   %esi
f010711b:	68 98 7c 10 f0       	push   $0xf0107c98
f0107120:	6a 68                	push   $0x68
f0107122:	68 d5 9f 10 f0       	push   $0xf0109fd5
f0107127:	e8 1d 8f ff ff       	call   f0100049 <_panic>

f010712c <e1000_rx_init>:
char rx_buffer[N_RXDESC][RX_PKT_SIZE];
char receive_packet_buffer[N_RXDESC][MAX_PKT_SIZE];

int
e1000_rx_init()
{
f010712c:	55                   	push   %ebp
f010712d:	89 e5                	mov    %esp,%ebp
f010712f:	57                   	push   %edi
f0107130:	56                   	push   %esi
f0107131:	53                   	push   %ebx
f0107132:	83 ec 18             	sub    $0x18,%esp
	// return 0;


int r;
	// Allocate one page for descriptors
	struct PageInfo *p = page_alloc(ALLOC_ZERO);
f0107135:	6a 01                	push   $0x1
f0107137:	e8 88 a1 ff ff       	call   f01012c4 <page_alloc>
	return (pp - pages) << PGSHIFT;
f010713c:	2b 05 b0 0e 58 f0    	sub    0xf0580eb0,%eax
f0107142:	c1 f8 03             	sar    $0x3,%eax
f0107145:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0107148:	89 c2                	mov    %eax,%edx
f010714a:	c1 ea 0c             	shr    $0xc,%edx
f010714d:	83 c4 10             	add    $0x10,%esp
f0107150:	3b 15 a8 0e 58 f0    	cmp    0xf0580ea8,%edx
f0107156:	0f 83 ef 00 00 00    	jae    f010724b <e1000_rx_init+0x11f>
	return (void *)(pa + KERNBASE);
f010715c:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0107161:	a3 24 20 5c f0       	mov    %eax,0xf05c2024
f0107166:	b8 40 0e 62 f0       	mov    $0xf0620e40,%eax
f010716b:	b9 40 0e 62 00       	mov    $0x620e40,%ecx
f0107170:	bb 00 00 00 00       	mov    $0x0,%ebx
f0107175:	be 40 0e 6a f0       	mov    $0xf06a0e40,%esi
	rx_descs = page2kva(p);
f010717a:	ba 00 00 00 00       	mov    $0x0,%edx
	if ((uint32_t)kva < KERNBASE)
f010717f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0107184:	0f 86 d3 00 00 00    	jbe    f010725d <e1000_rx_init+0x131>

	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	for (int i = 0; i < N_RXDESC; ++i) {
		rx_descs[i].addr = PADDR(rx_buffer[i]);
f010718a:	8b 3d 24 20 5c f0    	mov    0xf05c2024,%edi
f0107190:	89 0c 17             	mov    %ecx,(%edi,%edx,1)
f0107193:	89 5c 17 04          	mov    %ebx,0x4(%edi,%edx,1)
f0107197:	05 00 08 00 00       	add    $0x800,%eax
f010719c:	83 c2 10             	add    $0x10,%edx
f010719f:	81 c1 00 08 00 00    	add    $0x800,%ecx
f01071a5:	83 d3 00             	adc    $0x0,%ebx
	for (int i = 0; i < N_RXDESC; ++i) {
f01071a8:	39 f0                	cmp    %esi,%eax
f01071aa:	75 d3                	jne    f010717f <e1000_rx_init+0x53>
    }
	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	base->RCTL =0;
f01071ac:	a1 84 fe 57 f0       	mov    0xf057fe84,%eax
f01071b1:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
f01071b8:	00 00 00 
	base->RCTL |= E1000_RCTL_EN;
f01071bb:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f01071c1:	83 ca 02             	or     $0x2,%edx
f01071c4:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	base->RCTL |= E1000_RCTL_BSIZE_2048;  
f01071ca:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f01071d0:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	base->RCTL |= E1000_RCTL_SECRC;
f01071d6:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f01071dc:	81 ca 00 00 00 04    	or     $0x4000000,%edx
f01071e2:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	base->RDBAL = PADDR(rx_descs);
f01071e8:	8b 15 24 20 5c f0    	mov    0xf05c2024,%edx
f01071ee:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01071f4:	76 7c                	jbe    f0107272 <e1000_rx_init+0x146>
	return (physaddr_t)kva - KERNBASE;
f01071f6:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f01071fc:	89 90 00 28 00 00    	mov    %edx,0x2800(%eax)
	base->RDBAH = 0;
f0107202:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
f0107209:	00 00 00 
	base->RDLEN = N_RXDESC* sizeof(struct rx_desc);
f010720c:	c7 80 08 28 00 00 00 	movl   $0x1000,0x2808(%eax)
f0107213:	10 00 00 
	base->RDH = 0;
f0107216:	c7 80 10 28 00 00 00 	movl   $0x0,0x2810(%eax)
f010721d:	00 00 00 
	base->RDT = N_RXDESC-1;
f0107220:	c7 80 18 28 00 00 ff 	movl   $0xff,0x2818(%eax)
f0107227:	00 00 00 
	base->RAL = QEMU_MAC_LOW;
f010722a:	c7 80 1c 3a 00 00 52 	movl   $0x12005452,0x3a1c(%eax)
f0107231:	54 00 12 
	base->RAH = QEMU_MAC_HIGH;
f0107234:	c7 80 20 3a 00 00 34 	movl   $0x5634,0x3a20(%eax)
f010723b:	56 00 00 

	return 0;


	// return 0;
}
f010723e:	b8 00 00 00 00       	mov    $0x0,%eax
f0107243:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107246:	5b                   	pop    %ebx
f0107247:	5e                   	pop    %esi
f0107248:	5f                   	pop    %edi
f0107249:	5d                   	pop    %ebp
f010724a:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010724b:	50                   	push   %eax
f010724c:	68 74 7c 10 f0       	push   $0xf0107c74
f0107251:	6a 58                	push   $0x58
f0107253:	68 11 8e 10 f0       	push   $0xf0108e11
f0107258:	e8 ec 8d ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010725d:	50                   	push   %eax
f010725e:	68 98 7c 10 f0       	push   $0xf0107c98
f0107263:	68 a9 00 00 00       	push   $0xa9
f0107268:	68 d5 9f 10 f0       	push   $0xf0109fd5
f010726d:	e8 d7 8d ff ff       	call   f0100049 <_panic>
f0107272:	52                   	push   %edx
f0107273:	68 98 7c 10 f0       	push   $0xf0107c98
f0107278:	68 b1 00 00 00       	push   $0xb1
f010727d:	68 d5 9f 10 f0       	push   $0xf0109fd5
f0107282:	e8 c2 8d ff ff       	call   f0100049 <_panic>

f0107287 <pci_e1000_attach>:

int
pci_e1000_attach(struct pci_func *pcif)
{
f0107287:	55                   	push   %ebp
f0107288:	89 e5                	mov    %esp,%ebp
f010728a:	53                   	push   %ebx
f010728b:	83 ec 0c             	sub    $0xc,%esp
f010728e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in %s\n", __FUNCTION__);
f0107291:	68 1c a0 10 f0       	push   $0xf010a01c
f0107296:	68 06 92 10 f0       	push   $0xf0109206
f010729b:	e8 21 cc ff ff       	call   f0103ec1 <cprintf>
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);
f01072a0:	89 1c 24             	mov    %ebx,(%esp)
f01072a3:	e8 68 05 00 00       	call   f0107810 <pci_func_enable>
	
	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f01072a8:	83 c4 08             	add    $0x8,%esp
f01072ab:	ff 73 2c             	pushl  0x2c(%ebx)
f01072ae:	ff 73 14             	pushl  0x14(%ebx)
f01072b1:	e8 2c a4 ff ff       	call   f01016e2 <mmio_map_region>
f01072b6:	a3 84 fe 57 f0       	mov    %eax,0xf057fe84
	e1000_tx_init();
f01072bb:	e8 0e fd ff ff       	call   f0106fce <e1000_tx_init>
	e1000_rx_init();
f01072c0:	e8 67 fe ff ff       	call   f010712c <e1000_rx_init>

	return 0;
}
f01072c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01072ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01072cd:	c9                   	leave  
f01072ce:	c3                   	ret    

f01072cf <e1000_tx>:

int
e1000_tx(const void *buf, uint32_t len)
{
f01072cf:	55                   	push   %ebp
f01072d0:	89 e5                	mov    %esp,%ebp
f01072d2:	57                   	push   %edi
f01072d3:	56                   	push   %esi
f01072d4:	53                   	push   %ebx
f01072d5:	83 ec 24             	sub    $0x24,%esp
f01072d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// else{
	// 	return -E_TX_FULL;
	// }
	// return 0;

	cprintf("in %s\n", __FUNCTION__);
f01072db:	68 10 a0 10 f0       	push   $0xf010a010
f01072e0:	68 06 92 10 f0       	push   $0xf0109206
f01072e5:	e8 d7 cb ff ff       	call   f0103ec1 <cprintf>
    return base->TDT;
f01072ea:	a1 84 fe 57 f0       	mov    0xf057fe84,%eax
f01072ef:	8b 98 18 38 00 00    	mov    0x3818(%eax),%ebx
f01072f5:	89 5d e0             	mov    %ebx,-0x20(%ebp)
f01072f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	uint64_t tx_tail = read_tdt();
	if(len > MAX_PKT_SIZE){
f01072ff:	83 c4 10             	add    $0x10,%esp
f0107302:	81 ff ee 05 00 00    	cmp    $0x5ee,%edi
f0107308:	0f 87 8a 00 00 00    	ja     f0107398 <e1000_tx+0xc9>
		cprintf("dsafsfda\n");
		return -E_INVAL;
	}
	if(!check_dd_bit(&tx_descs[tx_tail])){
f010730e:	89 de                	mov    %ebx,%esi
f0107310:	c1 e6 04             	shl    $0x4,%esi
f0107313:	a1 20 20 5c f0       	mov    0xf05c2020,%eax
f0107318:	f6 44 30 0c 01       	testb  $0x1,0xc(%eax,%esi,1)
f010731d:	0f 84 8c 00 00 00    	je     f01073af <e1000_tx+0xe0>
		return -E_AGAIN;
	}
	cprintf("tail index:%d\n", tx_tail);
f0107323:	83 ec 04             	sub    $0x4,%esp
f0107326:	ff 75 e4             	pushl  -0x1c(%ebp)
f0107329:	ff 75 e0             	pushl  -0x20(%ebp)
f010732c:	68 ec 9f 10 f0       	push   $0xf0109fec
f0107331:	e8 8b cb ff ff       	call   f0103ec1 <cprintf>
	memset(transmit_packet_buffer[tx_tail], 0, MAX_PKT_SIZE);
f0107336:	69 db ee 05 00 00    	imul   $0x5ee,%ebx,%ebx
f010733c:	81 c3 40 fc 6f f0    	add    $0xf06ffc40,%ebx
f0107342:	83 c4 0c             	add    $0xc,%esp
f0107345:	68 ee 05 00 00       	push   $0x5ee
f010734a:	6a 00                	push   $0x0
f010734c:	53                   	push   %ebx
f010734d:	e8 81 f2 ff ff       	call   f01065d3 <memset>
	memmove(transmit_packet_buffer[tx_tail], buf, len);
f0107352:	83 c4 0c             	add    $0xc,%esp
f0107355:	57                   	push   %edi
f0107356:	ff 75 08             	pushl  0x8(%ebp)
f0107359:	53                   	push   %ebx
f010735a:	e8 bc f2 ff ff       	call   f010661b <memmove>
	set_length(&tx_descs[tx_tail], len);
f010735f:	03 35 20 20 5c f0    	add    0xf05c2020,%esi
    ptr->length = len;
f0107365:	66 89 7e 08          	mov    %di,0x8(%esi)
	ptr->cmd |= E1000_TX_CMD_EOP;
f0107369:	80 4e 0b 09          	orb    $0x9,0xb(%esi)
    ptr->status &= (~E1000_TX_STATUS_DD);
f010736d:	80 66 0c fe          	andb   $0xfe,0xc(%esi)
	set_rs_bit(&tx_descs[tx_tail]);
	set_eop_bit(&tx_descs[tx_tail]);
	clear_dd_bit(&tx_descs[tx_tail]);
	tx_tail = (tx_tail+1) % N_TXDESC;
f0107371:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107374:	83 c0 01             	add    $0x1,%eax
f0107377:	25 ff 00 00 00       	and    $0xff,%eax
    base->TDT = tail;
f010737c:	8b 15 84 fe 57 f0    	mov    0xf057fe84,%edx
f0107382:	89 82 18 38 00 00    	mov    %eax,0x3818(%edx)
f0107388:	83 c4 10             	add    $0x10,%esp
	set_tdt(tx_tail);
	return 0;
f010738b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0107390:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107393:	5b                   	pop    %ebx
f0107394:	5e                   	pop    %esi
f0107395:	5f                   	pop    %edi
f0107396:	5d                   	pop    %ebp
f0107397:	c3                   	ret    
		cprintf("dsafsfda\n");
f0107398:	83 ec 0c             	sub    $0xc,%esp
f010739b:	68 e2 9f 10 f0       	push   $0xf0109fe2
f01073a0:	e8 1c cb ff ff       	call   f0103ec1 <cprintf>
		return -E_INVAL;
f01073a5:	83 c4 10             	add    $0x10,%esp
f01073a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01073ad:	eb e1                	jmp    f0107390 <e1000_tx+0xc1>
		return -E_AGAIN;
f01073af:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
f01073b4:	eb da                	jmp    f0107390 <e1000_tx+0xc1>

f01073b6 <e1000_rx>:
	
  	// base->RDT = rdt;
	// return len;

	static uint32_t next =0;
	if(!(rx_descs[next].status & E1000_RX_STATUS_DD)) {	
f01073b6:	8b 15 80 fe 57 f0    	mov    0xf057fe80,%edx
f01073bc:	89 d0                	mov    %edx,%eax
f01073be:	c1 e0 04             	shl    $0x4,%eax
f01073c1:	03 05 24 20 5c f0    	add    0xf05c2024,%eax
f01073c7:	f6 40 0c 01          	testb  $0x1,0xc(%eax)
f01073cb:	74 72                	je     f010743f <e1000_rx+0x89>
{
f01073cd:	55                   	push   %ebp
f01073ce:	89 e5                	mov    %esp,%ebp
f01073d0:	53                   	push   %ebx
f01073d1:	83 ec 04             	sub    $0x4,%esp
					return -E_AGAIN;
	}
	if(rx_descs[next].error) {
f01073d4:	80 78 0d 00          	cmpb   $0x0,0xd(%eax)
f01073d8:	75 4e                	jne    f0107428 <e1000_rx+0x72>
					cprintf("[rx]error occours\n");
					return -E_UNSPECIFIED;
	}
	len = rx_descs[next].length;
	memmove(buf, rx_buffer[next], len);
f01073da:	83 ec 04             	sub    $0x4,%esp
	len = rx_descs[next].length;
f01073dd:	0f b7 58 08          	movzwl 0x8(%eax),%ebx
	memmove(buf, rx_buffer[next], len);
f01073e1:	53                   	push   %ebx
f01073e2:	c1 e2 0b             	shl    $0xb,%edx
f01073e5:	81 c2 40 0e 62 f0    	add    $0xf0620e40,%edx
f01073eb:	52                   	push   %edx
f01073ec:	ff 75 08             	pushl  0x8(%ebp)
f01073ef:	e8 27 f2 ff ff       	call   f010661b <memmove>

	base->RDT = (base->RDT + 1) % N_RXDESC;
f01073f4:	8b 15 84 fe 57 f0    	mov    0xf057fe84,%edx
f01073fa:	8b 82 18 28 00 00    	mov    0x2818(%edx),%eax
f0107400:	83 c0 01             	add    $0x1,%eax
f0107403:	0f b6 c0             	movzbl %al,%eax
f0107406:	89 82 18 28 00 00    	mov    %eax,0x2818(%edx)
	next = (next + 1) % N_RXDESC;
f010740c:	a1 80 fe 57 f0       	mov    0xf057fe80,%eax
f0107411:	83 c0 01             	add    $0x1,%eax
f0107414:	25 ff 00 00 00       	and    $0xff,%eax
f0107419:	a3 80 fe 57 f0       	mov    %eax,0xf057fe80
	return len;
f010741e:	89 d8                	mov    %ebx,%eax
f0107420:	83 c4 10             	add    $0x10,%esp

}
f0107423:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107426:	c9                   	leave  
f0107427:	c3                   	ret    
					cprintf("[rx]error occours\n");
f0107428:	83 ec 0c             	sub    $0xc,%esp
f010742b:	68 fb 9f 10 f0       	push   $0xf0109ffb
f0107430:	e8 8c ca ff ff       	call   f0103ec1 <cprintf>
					return -E_UNSPECIFIED;
f0107435:	83 c4 10             	add    $0x10,%esp
f0107438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010743d:	eb e4                	jmp    f0107423 <e1000_rx+0x6d>
					return -E_AGAIN;
f010743f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
}
f0107444:	c3                   	ret    

f0107445 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0107445:	55                   	push   %ebp
f0107446:	89 e5                	mov    %esp,%ebp
f0107448:	57                   	push   %edi
f0107449:	56                   	push   %esi
f010744a:	53                   	push   %ebx
f010744b:	83 ec 0c             	sub    $0xc,%esp
f010744e:	8b 7d 08             	mov    0x8(%ebp),%edi
f0107451:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107454:	eb 03                	jmp    f0107459 <pci_attach_match+0x14>
f0107456:	83 c3 0c             	add    $0xc,%ebx
f0107459:	89 de                	mov    %ebx,%esi
f010745b:	8b 43 08             	mov    0x8(%ebx),%eax
f010745e:	85 c0                	test   %eax,%eax
f0107460:	74 37                	je     f0107499 <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0107462:	39 3b                	cmp    %edi,(%ebx)
f0107464:	75 f0                	jne    f0107456 <pci_attach_match+0x11>
f0107466:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107469:	39 56 04             	cmp    %edx,0x4(%esi)
f010746c:	75 e8                	jne    f0107456 <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f010746e:	83 ec 0c             	sub    $0xc,%esp
f0107471:	ff 75 14             	pushl  0x14(%ebp)
f0107474:	ff d0                	call   *%eax
			if (r > 0)
f0107476:	83 c4 10             	add    $0x10,%esp
f0107479:	85 c0                	test   %eax,%eax
f010747b:	7f 1c                	jg     f0107499 <pci_attach_match+0x54>
				return r;
			if (r < 0)
f010747d:	79 d7                	jns    f0107456 <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f010747f:	83 ec 0c             	sub    $0xc,%esp
f0107482:	50                   	push   %eax
f0107483:	ff 76 08             	pushl  0x8(%esi)
f0107486:	ff 75 0c             	pushl  0xc(%ebp)
f0107489:	57                   	push   %edi
f010748a:	68 30 a0 10 f0       	push   $0xf010a030
f010748f:	e8 2d ca ff ff       	call   f0103ec1 <cprintf>
f0107494:	83 c4 20             	add    $0x20,%esp
f0107497:	eb bd                	jmp    f0107456 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0107499:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010749c:	5b                   	pop    %ebx
f010749d:	5e                   	pop    %esi
f010749e:	5f                   	pop    %edi
f010749f:	5d                   	pop    %ebp
f01074a0:	c3                   	ret    

f01074a1 <pci_conf1_set_addr>:
{
f01074a1:	55                   	push   %ebp
f01074a2:	89 e5                	mov    %esp,%ebp
f01074a4:	53                   	push   %ebx
f01074a5:	83 ec 04             	sub    $0x4,%esp
f01074a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01074ab:	3d ff 00 00 00       	cmp    $0xff,%eax
f01074b0:	77 36                	ja     f01074e8 <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f01074b2:	83 fa 1f             	cmp    $0x1f,%edx
f01074b5:	77 47                	ja     f01074fe <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f01074b7:	83 f9 07             	cmp    $0x7,%ecx
f01074ba:	77 58                	ja     f0107514 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f01074bc:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01074c2:	77 66                	ja     f010752a <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f01074c4:	f6 c3 03             	test   $0x3,%bl
f01074c7:	75 77                	jne    f0107540 <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f01074c9:	c1 e0 10             	shl    $0x10,%eax
f01074cc:	09 d8                	or     %ebx,%eax
f01074ce:	c1 e1 08             	shl    $0x8,%ecx
f01074d1:	09 c8                	or     %ecx,%eax
f01074d3:	c1 e2 0b             	shl    $0xb,%edx
f01074d6:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f01074d8:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01074dd:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f01074e2:	ef                   	out    %eax,(%dx)
}
f01074e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01074e6:	c9                   	leave  
f01074e7:	c3                   	ret    
	assert(bus < 256);
f01074e8:	68 88 a1 10 f0       	push   $0xf010a188
f01074ed:	68 2b 8e 10 f0       	push   $0xf0108e2b
f01074f2:	6a 2c                	push   $0x2c
f01074f4:	68 92 a1 10 f0       	push   $0xf010a192
f01074f9:	e8 4b 8b ff ff       	call   f0100049 <_panic>
	assert(dev < 32);
f01074fe:	68 9d a1 10 f0       	push   $0xf010a19d
f0107503:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0107508:	6a 2d                	push   $0x2d
f010750a:	68 92 a1 10 f0       	push   $0xf010a192
f010750f:	e8 35 8b ff ff       	call   f0100049 <_panic>
	assert(func < 8);
f0107514:	68 a6 a1 10 f0       	push   $0xf010a1a6
f0107519:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010751e:	6a 2e                	push   $0x2e
f0107520:	68 92 a1 10 f0       	push   $0xf010a192
f0107525:	e8 1f 8b ff ff       	call   f0100049 <_panic>
	assert(offset < 256);
f010752a:	68 af a1 10 f0       	push   $0xf010a1af
f010752f:	68 2b 8e 10 f0       	push   $0xf0108e2b
f0107534:	6a 2f                	push   $0x2f
f0107536:	68 92 a1 10 f0       	push   $0xf010a192
f010753b:	e8 09 8b ff ff       	call   f0100049 <_panic>
	assert((offset & 0x3) == 0);
f0107540:	68 bc a1 10 f0       	push   $0xf010a1bc
f0107545:	68 2b 8e 10 f0       	push   $0xf0108e2b
f010754a:	6a 30                	push   $0x30
f010754c:	68 92 a1 10 f0       	push   $0xf010a192
f0107551:	e8 f3 8a ff ff       	call   f0100049 <_panic>

f0107556 <pci_conf_read>:
{
f0107556:	55                   	push   %ebp
f0107557:	89 e5                	mov    %esp,%ebp
f0107559:	53                   	push   %ebx
f010755a:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010755d:	8b 48 08             	mov    0x8(%eax),%ecx
f0107560:	8b 58 04             	mov    0x4(%eax),%ebx
f0107563:	8b 00                	mov    (%eax),%eax
f0107565:	8b 40 04             	mov    0x4(%eax),%eax
f0107568:	52                   	push   %edx
f0107569:	89 da                	mov    %ebx,%edx
f010756b:	e8 31 ff ff ff       	call   f01074a1 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0107570:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107575:	ed                   	in     (%dx),%eax
}
f0107576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0107579:	c9                   	leave  
f010757a:	c3                   	ret    

f010757b <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f010757b:	55                   	push   %ebp
f010757c:	89 e5                	mov    %esp,%ebp
f010757e:	57                   	push   %edi
f010757f:	56                   	push   %esi
f0107580:	53                   	push   %ebx
f0107581:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0107587:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107589:	6a 48                	push   $0x48
f010758b:	6a 00                	push   $0x0
f010758d:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107590:	50                   	push   %eax
f0107591:	e8 3d f0 ff ff       	call   f01065d3 <memset>
	df.bus = bus;
f0107596:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107599:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f01075a0:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f01075a3:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f01075aa:	00 00 00 
f01075ad:	e9 25 01 00 00       	jmp    f01076d7 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01075b2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01075b8:	83 ec 08             	sub    $0x8,%esp
f01075bb:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f01075bf:	57                   	push   %edi
f01075c0:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f01075c1:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01075c4:	0f b6 c0             	movzbl %al,%eax
f01075c7:	50                   	push   %eax
f01075c8:	51                   	push   %ecx
f01075c9:	89 d0                	mov    %edx,%eax
f01075cb:	c1 e8 10             	shr    $0x10,%eax
f01075ce:	50                   	push   %eax
f01075cf:	0f b7 d2             	movzwl %dx,%edx
f01075d2:	52                   	push   %edx
f01075d3:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f01075d9:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f01075df:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f01075e5:	ff 70 04             	pushl  0x4(%eax)
f01075e8:	68 5c a0 10 f0       	push   $0xf010a05c
f01075ed:	e8 cf c8 ff ff       	call   f0103ec1 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f01075f2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f01075f8:	83 c4 30             	add    $0x30,%esp
f01075fb:	53                   	push   %ebx
f01075fc:	68 0c 84 12 f0       	push   $0xf012840c
				 PCI_SUBCLASS(f->dev_class),
f0107601:	89 c2                	mov    %eax,%edx
f0107603:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107606:	0f b6 d2             	movzbl %dl,%edx
f0107609:	52                   	push   %edx
f010760a:	c1 e8 18             	shr    $0x18,%eax
f010760d:	50                   	push   %eax
f010760e:	e8 32 fe ff ff       	call   f0107445 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0107613:	83 c4 10             	add    $0x10,%esp
f0107616:	85 c0                	test   %eax,%eax
f0107618:	0f 84 88 00 00 00    	je     f01076a6 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f010761e:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107625:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f010762b:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f0107631:	0f 83 92 00 00 00    	jae    f01076c9 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f0107637:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f010763d:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107643:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107648:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f010764a:	ba 00 00 00 00       	mov    $0x0,%edx
f010764f:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107655:	e8 fc fe ff ff       	call   f0107556 <pci_conf_read>
f010765a:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107660:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107664:	74 b8                	je     f010761e <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107666:	ba 3c 00 00 00       	mov    $0x3c,%edx
f010766b:	89 d8                	mov    %ebx,%eax
f010766d:	e8 e4 fe ff ff       	call   f0107556 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107672:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107675:	ba 08 00 00 00       	mov    $0x8,%edx
f010767a:	89 d8                	mov    %ebx,%eax
f010767c:	e8 d5 fe ff ff       	call   f0107556 <pci_conf_read>
f0107681:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107687:	89 c1                	mov    %eax,%ecx
f0107689:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f010768c:	be d0 a1 10 f0       	mov    $0xf010a1d0,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107691:	83 f9 06             	cmp    $0x6,%ecx
f0107694:	0f 87 18 ff ff ff    	ja     f01075b2 <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f010769a:	8b 34 8d 44 a2 10 f0 	mov    -0xfef5dbc(,%ecx,4),%esi
f01076a1:	e9 0c ff ff ff       	jmp    f01075b2 <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f01076a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f01076ac:	53                   	push   %ebx
f01076ad:	68 f4 83 12 f0       	push   $0xf01283f4
f01076b2:	89 c2                	mov    %eax,%edx
f01076b4:	c1 ea 10             	shr    $0x10,%edx
f01076b7:	52                   	push   %edx
f01076b8:	0f b7 c0             	movzwl %ax,%eax
f01076bb:	50                   	push   %eax
f01076bc:	e8 84 fd ff ff       	call   f0107445 <pci_attach_match>
f01076c1:	83 c4 10             	add    $0x10,%esp
f01076c4:	e9 55 ff ff ff       	jmp    f010761e <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f01076c9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f01076cc:	83 c0 01             	add    $0x1,%eax
f01076cf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f01076d2:	83 f8 1f             	cmp    $0x1f,%eax
f01076d5:	77 59                	ja     f0107730 <pci_scan_bus+0x1b5>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01076d7:	ba 0c 00 00 00       	mov    $0xc,%edx
f01076dc:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01076df:	e8 72 fe ff ff       	call   f0107556 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f01076e4:	89 c2                	mov    %eax,%edx
f01076e6:	c1 ea 10             	shr    $0x10,%edx
f01076e9:	f6 c2 7e             	test   $0x7e,%dl
f01076ec:	75 db                	jne    f01076c9 <pci_scan_bus+0x14e>
		totaldev++;
f01076ee:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f01076f5:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f01076fb:	8d 75 a0             	lea    -0x60(%ebp),%esi
f01076fe:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107703:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107705:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f010770c:	00 00 00 
f010770f:	25 00 00 80 00       	and    $0x800000,%eax
f0107714:	83 f8 01             	cmp    $0x1,%eax
f0107717:	19 c0                	sbb    %eax,%eax
f0107719:	83 e0 f9             	and    $0xfffffff9,%eax
f010771c:	83 c0 08             	add    $0x8,%eax
f010771f:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107725:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f010772b:	e9 f5 fe ff ff       	jmp    f0107625 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107730:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107736:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107739:	5b                   	pop    %ebx
f010773a:	5e                   	pop    %esi
f010773b:	5f                   	pop    %edi
f010773c:	5d                   	pop    %ebp
f010773d:	c3                   	ret    

f010773e <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f010773e:	55                   	push   %ebp
f010773f:	89 e5                	mov    %esp,%ebp
f0107741:	57                   	push   %edi
f0107742:	56                   	push   %esi
f0107743:	53                   	push   %ebx
f0107744:	83 ec 1c             	sub    $0x1c,%esp
f0107747:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f010774a:	ba 1c 00 00 00       	mov    $0x1c,%edx
f010774f:	89 d8                	mov    %ebx,%eax
f0107751:	e8 00 fe ff ff       	call   f0107556 <pci_conf_read>
f0107756:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107758:	ba 18 00 00 00       	mov    $0x18,%edx
f010775d:	89 d8                	mov    %ebx,%eax
f010775f:	e8 f2 fd ff ff       	call   f0107556 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107764:	83 e7 0f             	and    $0xf,%edi
f0107767:	83 ff 01             	cmp    $0x1,%edi
f010776a:	74 56                	je     f01077c2 <pci_bridge_attach+0x84>
f010776c:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f010776e:	83 ec 04             	sub    $0x4,%esp
f0107771:	6a 08                	push   $0x8
f0107773:	6a 00                	push   $0x0
f0107775:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107778:	57                   	push   %edi
f0107779:	e8 55 ee ff ff       	call   f01065d3 <memset>
	nbus.parent_bridge = pcif;
f010777e:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0107781:	89 f0                	mov    %esi,%eax
f0107783:	0f b6 c4             	movzbl %ah,%eax
f0107786:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107789:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f010778c:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f010778f:	89 f1                	mov    %esi,%ecx
f0107791:	0f b6 f1             	movzbl %cl,%esi
f0107794:	56                   	push   %esi
f0107795:	50                   	push   %eax
f0107796:	ff 73 08             	pushl  0x8(%ebx)
f0107799:	ff 73 04             	pushl  0x4(%ebx)
f010779c:	8b 03                	mov    (%ebx),%eax
f010779e:	ff 70 04             	pushl  0x4(%eax)
f01077a1:	68 cc a0 10 f0       	push   $0xf010a0cc
f01077a6:	e8 16 c7 ff ff       	call   f0103ec1 <cprintf>

	pci_scan_bus(&nbus);
f01077ab:	83 c4 20             	add    $0x20,%esp
f01077ae:	89 f8                	mov    %edi,%eax
f01077b0:	e8 c6 fd ff ff       	call   f010757b <pci_scan_bus>
	return 1;
f01077b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
f01077ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01077bd:	5b                   	pop    %ebx
f01077be:	5e                   	pop    %esi
f01077bf:	5f                   	pop    %edi
f01077c0:	5d                   	pop    %ebp
f01077c1:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f01077c2:	ff 73 08             	pushl  0x8(%ebx)
f01077c5:	ff 73 04             	pushl  0x4(%ebx)
f01077c8:	8b 03                	mov    (%ebx),%eax
f01077ca:	ff 70 04             	pushl  0x4(%eax)
f01077cd:	68 98 a0 10 f0       	push   $0xf010a098
f01077d2:	e8 ea c6 ff ff       	call   f0103ec1 <cprintf>
		return 0;
f01077d7:	83 c4 10             	add    $0x10,%esp
f01077da:	b8 00 00 00 00       	mov    $0x0,%eax
f01077df:	eb d9                	jmp    f01077ba <pci_bridge_attach+0x7c>

f01077e1 <pci_conf_write>:
{
f01077e1:	55                   	push   %ebp
f01077e2:	89 e5                	mov    %esp,%ebp
f01077e4:	56                   	push   %esi
f01077e5:	53                   	push   %ebx
f01077e6:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01077e8:	8b 48 08             	mov    0x8(%eax),%ecx
f01077eb:	8b 70 04             	mov    0x4(%eax),%esi
f01077ee:	8b 00                	mov    (%eax),%eax
f01077f0:	8b 40 04             	mov    0x4(%eax),%eax
f01077f3:	83 ec 0c             	sub    $0xc,%esp
f01077f6:	52                   	push   %edx
f01077f7:	89 f2                	mov    %esi,%edx
f01077f9:	e8 a3 fc ff ff       	call   f01074a1 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01077fe:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107803:	89 d8                	mov    %ebx,%eax
f0107805:	ef                   	out    %eax,(%dx)
}
f0107806:	83 c4 10             	add    $0x10,%esp
f0107809:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010780c:	5b                   	pop    %ebx
f010780d:	5e                   	pop    %esi
f010780e:	5d                   	pop    %ebp
f010780f:	c3                   	ret    

f0107810 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107810:	55                   	push   %ebp
f0107811:	89 e5                	mov    %esp,%ebp
f0107813:	57                   	push   %edi
f0107814:	56                   	push   %esi
f0107815:	53                   	push   %ebx
f0107816:	83 ec 2c             	sub    $0x2c,%esp
f0107819:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f010781c:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107821:	ba 04 00 00 00       	mov    $0x4,%edx
f0107826:	89 f8                	mov    %edi,%eax
f0107828:	e8 b4 ff ff ff       	call   f01077e1 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f010782d:	be 10 00 00 00       	mov    $0x10,%esi
f0107832:	eb 27                	jmp    f010785b <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107834:	89 c3                	mov    %eax,%ebx
f0107836:	83 e3 fc             	and    $0xfffffffc,%ebx
f0107839:	f7 db                	neg    %ebx
f010783b:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f010783d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107840:	83 e0 fc             	and    $0xfffffffc,%eax
f0107843:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f0107846:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f010784d:	eb 74                	jmp    f01078c3 <pci_func_enable+0xb3>
	     bar += bar_width)
f010784f:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107852:	83 fe 27             	cmp    $0x27,%esi
f0107855:	0f 87 c5 00 00 00    	ja     f0107920 <pci_func_enable+0x110>
		uint32_t oldv = pci_conf_read(f, bar);
f010785b:	89 f2                	mov    %esi,%edx
f010785d:	89 f8                	mov    %edi,%eax
f010785f:	e8 f2 fc ff ff       	call   f0107556 <pci_conf_read>
f0107864:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0107867:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f010786c:	89 f2                	mov    %esi,%edx
f010786e:	89 f8                	mov    %edi,%eax
f0107870:	e8 6c ff ff ff       	call   f01077e1 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0107875:	89 f2                	mov    %esi,%edx
f0107877:	89 f8                	mov    %edi,%eax
f0107879:	e8 d8 fc ff ff       	call   f0107556 <pci_conf_read>
		bar_width = 4;
f010787e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0107885:	85 c0                	test   %eax,%eax
f0107887:	74 c6                	je     f010784f <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0107889:	8d 4e f0             	lea    -0x10(%esi),%ecx
f010788c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010788f:	c1 e9 02             	shr    $0x2,%ecx
f0107892:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107895:	a8 01                	test   $0x1,%al
f0107897:	75 9b                	jne    f0107834 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107899:	89 c2                	mov    %eax,%edx
f010789b:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f010789e:	83 fa 04             	cmp    $0x4,%edx
f01078a1:	0f 94 c1             	sete   %cl
f01078a4:	0f b6 c9             	movzbl %cl,%ecx
f01078a7:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f01078ae:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f01078b1:	89 c3                	mov    %eax,%ebx
f01078b3:	83 e3 f0             	and    $0xfffffff0,%ebx
f01078b6:	f7 db                	neg    %ebx
f01078b8:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f01078ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01078bd:	83 e0 f0             	and    $0xfffffff0,%eax
f01078c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f01078c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01078c6:	89 f2                	mov    %esi,%edx
f01078c8:	89 f8                	mov    %edi,%eax
f01078ca:	e8 12 ff ff ff       	call   f01077e1 <pci_conf_write>
f01078cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01078d2:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f01078d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01078d7:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f01078da:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f01078dd:	85 db                	test   %ebx,%ebx
f01078df:	0f 84 6a ff ff ff    	je     f010784f <pci_func_enable+0x3f>
f01078e5:	85 d2                	test   %edx,%edx
f01078e7:	0f 85 62 ff ff ff    	jne    f010784f <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01078ed:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f01078f0:	83 ec 0c             	sub    $0xc,%esp
f01078f3:	53                   	push   %ebx
f01078f4:	6a 00                	push   $0x0
f01078f6:	ff 75 d4             	pushl  -0x2c(%ebp)
f01078f9:	89 c2                	mov    %eax,%edx
f01078fb:	c1 ea 10             	shr    $0x10,%edx
f01078fe:	52                   	push   %edx
f01078ff:	0f b7 c0             	movzwl %ax,%eax
f0107902:	50                   	push   %eax
f0107903:	ff 77 08             	pushl  0x8(%edi)
f0107906:	ff 77 04             	pushl  0x4(%edi)
f0107909:	8b 07                	mov    (%edi),%eax
f010790b:	ff 70 04             	pushl  0x4(%eax)
f010790e:	68 fc a0 10 f0       	push   $0xf010a0fc
f0107913:	e8 a9 c5 ff ff       	call   f0103ec1 <cprintf>
f0107918:	83 c4 30             	add    $0x30,%esp
f010791b:	e9 2f ff ff ff       	jmp    f010784f <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107920:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107923:	83 ec 08             	sub    $0x8,%esp
f0107926:	89 c2                	mov    %eax,%edx
f0107928:	c1 ea 10             	shr    $0x10,%edx
f010792b:	52                   	push   %edx
f010792c:	0f b7 c0             	movzwl %ax,%eax
f010792f:	50                   	push   %eax
f0107930:	ff 77 08             	pushl  0x8(%edi)
f0107933:	ff 77 04             	pushl  0x4(%edi)
f0107936:	8b 07                	mov    (%edi),%eax
f0107938:	ff 70 04             	pushl  0x4(%eax)
f010793b:	68 58 a1 10 f0       	push   $0xf010a158
f0107940:	e8 7c c5 ff ff       	call   f0103ec1 <cprintf>
}
f0107945:	83 c4 20             	add    $0x20,%esp
f0107948:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010794b:	5b                   	pop    %ebx
f010794c:	5e                   	pop    %esi
f010794d:	5f                   	pop    %edi
f010794e:	5d                   	pop    %ebp
f010794f:	c3                   	ret    

f0107950 <pci_init>:

int
pci_init(void)
{
f0107950:	55                   	push   %ebp
f0107951:	89 e5                	mov    %esp,%ebp
f0107953:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107956:	6a 08                	push   $0x8
f0107958:	6a 00                	push   $0x0
f010795a:	68 88 fe 57 f0       	push   $0xf057fe88
f010795f:	e8 6f ec ff ff       	call   f01065d3 <memset>

	return pci_scan_bus(&root_bus);
f0107964:	b8 88 fe 57 f0       	mov    $0xf057fe88,%eax
f0107969:	e8 0d fc ff ff       	call   f010757b <pci_scan_bus>
}
f010796e:	c9                   	leave  
f010796f:	c3                   	ret    

f0107970 <time_init>:
static unsigned int ticks;

void
time_init(void)
{
	ticks = 0;
f0107970:	c7 05 90 fe 57 f0 00 	movl   $0x0,0xf057fe90
f0107977:	00 00 00 
}
f010797a:	c3                   	ret    

f010797b <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f010797b:	a1 90 fe 57 f0       	mov    0xf057fe90,%eax
f0107980:	83 c0 01             	add    $0x1,%eax
f0107983:	a3 90 fe 57 f0       	mov    %eax,0xf057fe90
	if (ticks * 10 < ticks)
f0107988:	8d 14 80             	lea    (%eax,%eax,4),%edx
f010798b:	01 d2                	add    %edx,%edx
f010798d:	39 d0                	cmp    %edx,%eax
f010798f:	77 01                	ja     f0107992 <time_tick+0x17>
f0107991:	c3                   	ret    
{
f0107992:	55                   	push   %ebp
f0107993:	89 e5                	mov    %esp,%ebp
f0107995:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0107998:	68 60 a2 10 f0       	push   $0xf010a260
f010799d:	6a 13                	push   $0x13
f010799f:	68 7b a2 10 f0       	push   $0xf010a27b
f01079a4:	e8 a0 86 ff ff       	call   f0100049 <_panic>

f01079a9 <time_msec>:
}

unsigned int
time_msec(void)
{
	return ticks * 10;
f01079a9:	a1 90 fe 57 f0       	mov    0xf057fe90,%eax
f01079ae:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01079b1:	01 c0                	add    %eax,%eax
}
f01079b3:	c3                   	ret    
f01079b4:	66 90                	xchg   %ax,%ax
f01079b6:	66 90                	xchg   %ax,%ax
f01079b8:	66 90                	xchg   %ax,%ax
f01079ba:	66 90                	xchg   %ax,%ax
f01079bc:	66 90                	xchg   %ax,%ax
f01079be:	66 90                	xchg   %ax,%ax

f01079c0 <__udivdi3>:
f01079c0:	55                   	push   %ebp
f01079c1:	57                   	push   %edi
f01079c2:	56                   	push   %esi
f01079c3:	53                   	push   %ebx
f01079c4:	83 ec 1c             	sub    $0x1c,%esp
f01079c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f01079cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01079cf:	8b 74 24 34          	mov    0x34(%esp),%esi
f01079d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01079d7:	85 d2                	test   %edx,%edx
f01079d9:	75 4d                	jne    f0107a28 <__udivdi3+0x68>
f01079db:	39 f3                	cmp    %esi,%ebx
f01079dd:	76 19                	jbe    f01079f8 <__udivdi3+0x38>
f01079df:	31 ff                	xor    %edi,%edi
f01079e1:	89 e8                	mov    %ebp,%eax
f01079e3:	89 f2                	mov    %esi,%edx
f01079e5:	f7 f3                	div    %ebx
f01079e7:	89 fa                	mov    %edi,%edx
f01079e9:	83 c4 1c             	add    $0x1c,%esp
f01079ec:	5b                   	pop    %ebx
f01079ed:	5e                   	pop    %esi
f01079ee:	5f                   	pop    %edi
f01079ef:	5d                   	pop    %ebp
f01079f0:	c3                   	ret    
f01079f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01079f8:	89 d9                	mov    %ebx,%ecx
f01079fa:	85 db                	test   %ebx,%ebx
f01079fc:	75 0b                	jne    f0107a09 <__udivdi3+0x49>
f01079fe:	b8 01 00 00 00       	mov    $0x1,%eax
f0107a03:	31 d2                	xor    %edx,%edx
f0107a05:	f7 f3                	div    %ebx
f0107a07:	89 c1                	mov    %eax,%ecx
f0107a09:	31 d2                	xor    %edx,%edx
f0107a0b:	89 f0                	mov    %esi,%eax
f0107a0d:	f7 f1                	div    %ecx
f0107a0f:	89 c6                	mov    %eax,%esi
f0107a11:	89 e8                	mov    %ebp,%eax
f0107a13:	89 f7                	mov    %esi,%edi
f0107a15:	f7 f1                	div    %ecx
f0107a17:	89 fa                	mov    %edi,%edx
f0107a19:	83 c4 1c             	add    $0x1c,%esp
f0107a1c:	5b                   	pop    %ebx
f0107a1d:	5e                   	pop    %esi
f0107a1e:	5f                   	pop    %edi
f0107a1f:	5d                   	pop    %ebp
f0107a20:	c3                   	ret    
f0107a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107a28:	39 f2                	cmp    %esi,%edx
f0107a2a:	77 1c                	ja     f0107a48 <__udivdi3+0x88>
f0107a2c:	0f bd fa             	bsr    %edx,%edi
f0107a2f:	83 f7 1f             	xor    $0x1f,%edi
f0107a32:	75 2c                	jne    f0107a60 <__udivdi3+0xa0>
f0107a34:	39 f2                	cmp    %esi,%edx
f0107a36:	72 06                	jb     f0107a3e <__udivdi3+0x7e>
f0107a38:	31 c0                	xor    %eax,%eax
f0107a3a:	39 eb                	cmp    %ebp,%ebx
f0107a3c:	77 a9                	ja     f01079e7 <__udivdi3+0x27>
f0107a3e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107a43:	eb a2                	jmp    f01079e7 <__udivdi3+0x27>
f0107a45:	8d 76 00             	lea    0x0(%esi),%esi
f0107a48:	31 ff                	xor    %edi,%edi
f0107a4a:	31 c0                	xor    %eax,%eax
f0107a4c:	89 fa                	mov    %edi,%edx
f0107a4e:	83 c4 1c             	add    $0x1c,%esp
f0107a51:	5b                   	pop    %ebx
f0107a52:	5e                   	pop    %esi
f0107a53:	5f                   	pop    %edi
f0107a54:	5d                   	pop    %ebp
f0107a55:	c3                   	ret    
f0107a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107a5d:	8d 76 00             	lea    0x0(%esi),%esi
f0107a60:	89 f9                	mov    %edi,%ecx
f0107a62:	b8 20 00 00 00       	mov    $0x20,%eax
f0107a67:	29 f8                	sub    %edi,%eax
f0107a69:	d3 e2                	shl    %cl,%edx
f0107a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
f0107a6f:	89 c1                	mov    %eax,%ecx
f0107a71:	89 da                	mov    %ebx,%edx
f0107a73:	d3 ea                	shr    %cl,%edx
f0107a75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107a79:	09 d1                	or     %edx,%ecx
f0107a7b:	89 f2                	mov    %esi,%edx
f0107a7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107a81:	89 f9                	mov    %edi,%ecx
f0107a83:	d3 e3                	shl    %cl,%ebx
f0107a85:	89 c1                	mov    %eax,%ecx
f0107a87:	d3 ea                	shr    %cl,%edx
f0107a89:	89 f9                	mov    %edi,%ecx
f0107a8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107a8f:	89 eb                	mov    %ebp,%ebx
f0107a91:	d3 e6                	shl    %cl,%esi
f0107a93:	89 c1                	mov    %eax,%ecx
f0107a95:	d3 eb                	shr    %cl,%ebx
f0107a97:	09 de                	or     %ebx,%esi
f0107a99:	89 f0                	mov    %esi,%eax
f0107a9b:	f7 74 24 08          	divl   0x8(%esp)
f0107a9f:	89 d6                	mov    %edx,%esi
f0107aa1:	89 c3                	mov    %eax,%ebx
f0107aa3:	f7 64 24 0c          	mull   0xc(%esp)
f0107aa7:	39 d6                	cmp    %edx,%esi
f0107aa9:	72 15                	jb     f0107ac0 <__udivdi3+0x100>
f0107aab:	89 f9                	mov    %edi,%ecx
f0107aad:	d3 e5                	shl    %cl,%ebp
f0107aaf:	39 c5                	cmp    %eax,%ebp
f0107ab1:	73 04                	jae    f0107ab7 <__udivdi3+0xf7>
f0107ab3:	39 d6                	cmp    %edx,%esi
f0107ab5:	74 09                	je     f0107ac0 <__udivdi3+0x100>
f0107ab7:	89 d8                	mov    %ebx,%eax
f0107ab9:	31 ff                	xor    %edi,%edi
f0107abb:	e9 27 ff ff ff       	jmp    f01079e7 <__udivdi3+0x27>
f0107ac0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107ac3:	31 ff                	xor    %edi,%edi
f0107ac5:	e9 1d ff ff ff       	jmp    f01079e7 <__udivdi3+0x27>
f0107aca:	66 90                	xchg   %ax,%ax
f0107acc:	66 90                	xchg   %ax,%ax
f0107ace:	66 90                	xchg   %ax,%ax

f0107ad0 <__umoddi3>:
f0107ad0:	55                   	push   %ebp
f0107ad1:	57                   	push   %edi
f0107ad2:	56                   	push   %esi
f0107ad3:	53                   	push   %ebx
f0107ad4:	83 ec 1c             	sub    $0x1c,%esp
f0107ad7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0107adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0107adf:	8b 74 24 30          	mov    0x30(%esp),%esi
f0107ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107ae7:	89 da                	mov    %ebx,%edx
f0107ae9:	85 c0                	test   %eax,%eax
f0107aeb:	75 43                	jne    f0107b30 <__umoddi3+0x60>
f0107aed:	39 df                	cmp    %ebx,%edi
f0107aef:	76 17                	jbe    f0107b08 <__umoddi3+0x38>
f0107af1:	89 f0                	mov    %esi,%eax
f0107af3:	f7 f7                	div    %edi
f0107af5:	89 d0                	mov    %edx,%eax
f0107af7:	31 d2                	xor    %edx,%edx
f0107af9:	83 c4 1c             	add    $0x1c,%esp
f0107afc:	5b                   	pop    %ebx
f0107afd:	5e                   	pop    %esi
f0107afe:	5f                   	pop    %edi
f0107aff:	5d                   	pop    %ebp
f0107b00:	c3                   	ret    
f0107b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107b08:	89 fd                	mov    %edi,%ebp
f0107b0a:	85 ff                	test   %edi,%edi
f0107b0c:	75 0b                	jne    f0107b19 <__umoddi3+0x49>
f0107b0e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107b13:	31 d2                	xor    %edx,%edx
f0107b15:	f7 f7                	div    %edi
f0107b17:	89 c5                	mov    %eax,%ebp
f0107b19:	89 d8                	mov    %ebx,%eax
f0107b1b:	31 d2                	xor    %edx,%edx
f0107b1d:	f7 f5                	div    %ebp
f0107b1f:	89 f0                	mov    %esi,%eax
f0107b21:	f7 f5                	div    %ebp
f0107b23:	89 d0                	mov    %edx,%eax
f0107b25:	eb d0                	jmp    f0107af7 <__umoddi3+0x27>
f0107b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107b2e:	66 90                	xchg   %ax,%ax
f0107b30:	89 f1                	mov    %esi,%ecx
f0107b32:	39 d8                	cmp    %ebx,%eax
f0107b34:	76 0a                	jbe    f0107b40 <__umoddi3+0x70>
f0107b36:	89 f0                	mov    %esi,%eax
f0107b38:	83 c4 1c             	add    $0x1c,%esp
f0107b3b:	5b                   	pop    %ebx
f0107b3c:	5e                   	pop    %esi
f0107b3d:	5f                   	pop    %edi
f0107b3e:	5d                   	pop    %ebp
f0107b3f:	c3                   	ret    
f0107b40:	0f bd e8             	bsr    %eax,%ebp
f0107b43:	83 f5 1f             	xor    $0x1f,%ebp
f0107b46:	75 20                	jne    f0107b68 <__umoddi3+0x98>
f0107b48:	39 d8                	cmp    %ebx,%eax
f0107b4a:	0f 82 b0 00 00 00    	jb     f0107c00 <__umoddi3+0x130>
f0107b50:	39 f7                	cmp    %esi,%edi
f0107b52:	0f 86 a8 00 00 00    	jbe    f0107c00 <__umoddi3+0x130>
f0107b58:	89 c8                	mov    %ecx,%eax
f0107b5a:	83 c4 1c             	add    $0x1c,%esp
f0107b5d:	5b                   	pop    %ebx
f0107b5e:	5e                   	pop    %esi
f0107b5f:	5f                   	pop    %edi
f0107b60:	5d                   	pop    %ebp
f0107b61:	c3                   	ret    
f0107b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107b68:	89 e9                	mov    %ebp,%ecx
f0107b6a:	ba 20 00 00 00       	mov    $0x20,%edx
f0107b6f:	29 ea                	sub    %ebp,%edx
f0107b71:	d3 e0                	shl    %cl,%eax
f0107b73:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107b77:	89 d1                	mov    %edx,%ecx
f0107b79:	89 f8                	mov    %edi,%eax
f0107b7b:	d3 e8                	shr    %cl,%eax
f0107b7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107b81:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107b85:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107b89:	09 c1                	or     %eax,%ecx
f0107b8b:	89 d8                	mov    %ebx,%eax
f0107b8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107b91:	89 e9                	mov    %ebp,%ecx
f0107b93:	d3 e7                	shl    %cl,%edi
f0107b95:	89 d1                	mov    %edx,%ecx
f0107b97:	d3 e8                	shr    %cl,%eax
f0107b99:	89 e9                	mov    %ebp,%ecx
f0107b9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0107b9f:	d3 e3                	shl    %cl,%ebx
f0107ba1:	89 c7                	mov    %eax,%edi
f0107ba3:	89 d1                	mov    %edx,%ecx
f0107ba5:	89 f0                	mov    %esi,%eax
f0107ba7:	d3 e8                	shr    %cl,%eax
f0107ba9:	89 e9                	mov    %ebp,%ecx
f0107bab:	89 fa                	mov    %edi,%edx
f0107bad:	d3 e6                	shl    %cl,%esi
f0107baf:	09 d8                	or     %ebx,%eax
f0107bb1:	f7 74 24 08          	divl   0x8(%esp)
f0107bb5:	89 d1                	mov    %edx,%ecx
f0107bb7:	89 f3                	mov    %esi,%ebx
f0107bb9:	f7 64 24 0c          	mull   0xc(%esp)
f0107bbd:	89 c6                	mov    %eax,%esi
f0107bbf:	89 d7                	mov    %edx,%edi
f0107bc1:	39 d1                	cmp    %edx,%ecx
f0107bc3:	72 06                	jb     f0107bcb <__umoddi3+0xfb>
f0107bc5:	75 10                	jne    f0107bd7 <__umoddi3+0x107>
f0107bc7:	39 c3                	cmp    %eax,%ebx
f0107bc9:	73 0c                	jae    f0107bd7 <__umoddi3+0x107>
f0107bcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
f0107bcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0107bd3:	89 d7                	mov    %edx,%edi
f0107bd5:	89 c6                	mov    %eax,%esi
f0107bd7:	89 ca                	mov    %ecx,%edx
f0107bd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107bde:	29 f3                	sub    %esi,%ebx
f0107be0:	19 fa                	sbb    %edi,%edx
f0107be2:	89 d0                	mov    %edx,%eax
f0107be4:	d3 e0                	shl    %cl,%eax
f0107be6:	89 e9                	mov    %ebp,%ecx
f0107be8:	d3 eb                	shr    %cl,%ebx
f0107bea:	d3 ea                	shr    %cl,%edx
f0107bec:	09 d8                	or     %ebx,%eax
f0107bee:	83 c4 1c             	add    $0x1c,%esp
f0107bf1:	5b                   	pop    %ebx
f0107bf2:	5e                   	pop    %esi
f0107bf3:	5f                   	pop    %edi
f0107bf4:	5d                   	pop    %ebp
f0107bf5:	c3                   	ret    
f0107bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107bfd:	8d 76 00             	lea    0x0(%esi),%esi
f0107c00:	89 da                	mov    %ebx,%edx
f0107c02:	29 fe                	sub    %edi,%esi
f0107c04:	19 c2                	sbb    %eax,%edx
f0107c06:	89 f1                	mov    %esi,%ecx
f0107c08:	89 c8                	mov    %ecx,%eax
f0107c0a:	e9 4b ff ff ff       	jmp    f0107b5a <__umoddi3+0x8a>
