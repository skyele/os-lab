
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
f0100015:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0
	# Turn on page size extension.

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 30 12 f0       	mov    $0xf0123000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 80 7e 34 f0 00 	cmpl   $0x0,0xf0347e80
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 d4 0b 00 00       	call   f0100c2f <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 80 7e 34 f0    	mov    %esi,0xf0347e80
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 5a 68 00 00       	call   f01068ca <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 20 6f 10 f0       	push   $0xf0106f20
f010007c:	e8 02 3d 00 00       	call   f0103d83 <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 d2 3c 00 00       	call   f0103d5d <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 cb 83 10 f0 	movl   $0xf01083cb,(%esp)
f0100092:	e8 ec 3c 00 00       	call   f0103d83 <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 a3 05 00 00       	call   f010064b <cons_init>
	cprintf("pading space in the right to number 22: %-8d.\n", 22);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	6a 16                	push   $0x16
f01000ad:	68 44 6f 10 f0       	push   $0xf0106f44
f01000b2:	e8 cc 3c 00 00       	call   f0103d83 <cprintf>
	cprintf("%n", NULL);
f01000b7:	83 c4 08             	add    $0x8,%esp
f01000ba:	6a 00                	push   $0x0
f01000bc:	68 bc 6f 10 f0       	push   $0xf0106fbc
f01000c1:	e8 bd 3c 00 00       	call   f0103d83 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f01000c6:	83 c4 0c             	add    $0xc,%esp
f01000c9:	68 00 fc ff ff       	push   $0xfffffc00
f01000ce:	68 00 04 00 00       	push   $0x400
f01000d3:	68 bf 6f 10 f0       	push   $0xf0106fbf
f01000d8:	e8 a6 3c 00 00       	call   f0103d83 <cprintf>
	mem_init();
f01000dd:	e8 3e 16 00 00       	call   f0101720 <mem_init>
	env_init();
f01000e2:	e8 bf 34 00 00       	call   f01035a6 <env_init>
	trap_init();
f01000e7:	e8 7b 3d 00 00       	call   f0103e67 <trap_init>
	mp_init();
f01000ec:	e8 e2 64 00 00       	call   f01065d3 <mp_init>
	lapic_init();
f01000f1:	e8 ea 67 00 00       	call   f01068e0 <lapic_init>
	pic_init();
f01000f6:	e8 9f 3b 00 00       	call   f0103c9a <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000fb:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f0100102:	e8 33 6a 00 00       	call   f0106b3a <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100107:	83 c4 10             	add    $0x10,%esp
f010010a:	83 3d 88 7e 34 f0 07 	cmpl   $0x7,0xf0347e88
f0100111:	76 27                	jbe    f010013a <i386_init+0x9e>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100113:	83 ec 04             	sub    $0x4,%esp
f0100116:	b8 36 65 10 f0       	mov    $0xf0106536,%eax
f010011b:	2d bc 64 10 f0       	sub    $0xf01064bc,%eax
f0100120:	50                   	push   %eax
f0100121:	68 bc 64 10 f0       	push   $0xf01064bc
f0100126:	68 00 70 00 f0       	push   $0xf0007000
f010012b:	e8 e1 61 00 00       	call   f0106311 <memmove>
f0100130:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f0100133:	bb 20 80 34 f0       	mov    $0xf0348020,%ebx
f0100138:	eb 19                	jmp    f0100153 <i386_init+0xb7>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010013a:	68 00 70 00 00       	push   $0x7000
f010013f:	68 74 6f 10 f0       	push   $0xf0106f74
f0100144:	6a 59                	push   $0x59
f0100146:	68 db 6f 10 f0       	push   $0xf0106fdb
f010014b:	e8 f0 fe ff ff       	call   f0100040 <_panic>
f0100150:	83 c3 74             	add    $0x74,%ebx
f0100153:	6b 05 c4 83 34 f0 74 	imul   $0x74,0xf03483c4,%eax
f010015a:	05 20 80 34 f0       	add    $0xf0348020,%eax
f010015f:	39 c3                	cmp    %eax,%ebx
f0100161:	73 4d                	jae    f01001b0 <i386_init+0x114>
		if (c == cpus + cpunum())  // We've started already.
f0100163:	e8 62 67 00 00       	call   f01068ca <cpunum>
f0100168:	6b c0 74             	imul   $0x74,%eax,%eax
f010016b:	05 20 80 34 f0       	add    $0xf0348020,%eax
f0100170:	39 c3                	cmp    %eax,%ebx
f0100172:	74 dc                	je     f0100150 <i386_init+0xb4>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100174:	89 d8                	mov    %ebx,%eax
f0100176:	2d 20 80 34 f0       	sub    $0xf0348020,%eax
f010017b:	c1 f8 02             	sar    $0x2,%eax
f010017e:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100184:	c1 e0 0f             	shl    $0xf,%eax
f0100187:	8d 80 00 10 35 f0    	lea    -0xfcaf000(%eax),%eax
f010018d:	a3 84 7e 34 f0       	mov    %eax,0xf0347e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100192:	83 ec 08             	sub    $0x8,%esp
f0100195:	68 00 70 00 00       	push   $0x7000
f010019a:	0f b6 03             	movzbl (%ebx),%eax
f010019d:	50                   	push   %eax
f010019e:	e8 8f 68 00 00       	call   f0106a32 <lapic_startap>
f01001a3:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f01001a6:	8b 43 04             	mov    0x4(%ebx),%eax
f01001a9:	83 f8 01             	cmp    $0x1,%eax
f01001ac:	75 f8                	jne    f01001a6 <i386_init+0x10a>
f01001ae:	eb a0                	jmp    f0100150 <i386_init+0xb4>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001b0:	83 ec 08             	sub    $0x8,%esp
f01001b3:	6a 00                	push   $0x0
f01001b5:	68 ac a0 24 f0       	push   $0xf024a0ac
f01001ba:	e8 7d 35 00 00       	call   f010373c <env_create>
	kbd_intr();
f01001bf:	e8 32 04 00 00       	call   f01005f6 <kbd_intr>
	sched_yield();
f01001c4:	e8 79 4b 00 00       	call   f0104d42 <sched_yield>

f01001c9 <mp_main>:
{
f01001c9:	55                   	push   %ebp
f01001ca:	89 e5                	mov    %esp,%ebp
f01001cc:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001cf:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001d4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001d9:	76 52                	jbe    f010022d <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f01001db:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001e0:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001e3:	e8 e2 66 00 00       	call   f01068ca <cpunum>
f01001e8:	83 ec 08             	sub    $0x8,%esp
f01001eb:	50                   	push   %eax
f01001ec:	68 e7 6f 10 f0       	push   $0xf0106fe7
f01001f1:	e8 8d 3b 00 00       	call   f0103d83 <cprintf>
	lapic_init();
f01001f6:	e8 e5 66 00 00       	call   f01068e0 <lapic_init>
	env_init_percpu();
f01001fb:	e8 7a 33 00 00       	call   f010357a <env_init_percpu>
	trap_init_percpu();
f0100200:	e8 92 3b 00 00       	call   f0103d97 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100205:	e8 c0 66 00 00       	call   f01068ca <cpunum>
f010020a:	6b d0 74             	imul   $0x74,%eax,%edx
f010020d:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100210:	b8 01 00 00 00       	mov    $0x1,%eax
f0100215:	f0 87 82 20 80 34 f0 	lock xchg %eax,-0xfcb7fe0(%edx)
f010021c:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f0100223:	e8 12 69 00 00       	call   f0106b3a <spin_lock>
	sched_yield();
f0100228:	e8 15 4b 00 00       	call   f0104d42 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010022d:	50                   	push   %eax
f010022e:	68 98 6f 10 f0       	push   $0xf0106f98
f0100233:	6a 71                	push   $0x71
f0100235:	68 db 6f 10 f0       	push   $0xf0106fdb
f010023a:	e8 01 fe ff ff       	call   f0100040 <_panic>

f010023f <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010023f:	55                   	push   %ebp
f0100240:	89 e5                	mov    %esp,%ebp
f0100242:	53                   	push   %ebx
f0100243:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100246:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100249:	ff 75 0c             	pushl  0xc(%ebp)
f010024c:	ff 75 08             	pushl  0x8(%ebp)
f010024f:	68 fd 6f 10 f0       	push   $0xf0106ffd
f0100254:	e8 2a 3b 00 00       	call   f0103d83 <cprintf>
	vcprintf(fmt, ap);
f0100259:	83 c4 08             	add    $0x8,%esp
f010025c:	53                   	push   %ebx
f010025d:	ff 75 10             	pushl  0x10(%ebp)
f0100260:	e8 f8 3a 00 00       	call   f0103d5d <vcprintf>
	cprintf("\n");
f0100265:	c7 04 24 cb 83 10 f0 	movl   $0xf01083cb,(%esp)
f010026c:	e8 12 3b 00 00       	call   f0103d83 <cprintf>
	va_end(ap);
}
f0100271:	83 c4 10             	add    $0x10,%esp
f0100274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100277:	c9                   	leave  
f0100278:	c3                   	ret    

f0100279 <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100279:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010027e:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010027f:	a8 01                	test   $0x1,%al
f0100281:	74 0a                	je     f010028d <serial_proc_data+0x14>
f0100283:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100288:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100289:	0f b6 c0             	movzbl %al,%eax
f010028c:	c3                   	ret    
		return -1;
f010028d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100292:	c3                   	ret    

f0100293 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100293:	55                   	push   %ebp
f0100294:	89 e5                	mov    %esp,%ebp
f0100296:	53                   	push   %ebx
f0100297:	83 ec 04             	sub    $0x4,%esp
f010029a:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010029c:	ff d3                	call   *%ebx
f010029e:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002a1:	74 29                	je     f01002cc <cons_intr+0x39>
		if (c == 0)
f01002a3:	85 c0                	test   %eax,%eax
f01002a5:	74 f5                	je     f010029c <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002a7:	8b 0d 24 72 34 f0    	mov    0xf0347224,%ecx
f01002ad:	8d 51 01             	lea    0x1(%ecx),%edx
f01002b0:	88 81 20 70 34 f0    	mov    %al,-0xfcb8fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002b6:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002bc:	b8 00 00 00 00       	mov    $0x0,%eax
f01002c1:	0f 44 d0             	cmove  %eax,%edx
f01002c4:	89 15 24 72 34 f0    	mov    %edx,0xf0347224
f01002ca:	eb d0                	jmp    f010029c <cons_intr+0x9>
	}
}
f01002cc:	83 c4 04             	add    $0x4,%esp
f01002cf:	5b                   	pop    %ebx
f01002d0:	5d                   	pop    %ebp
f01002d1:	c3                   	ret    

f01002d2 <kbd_proc_data>:
{
f01002d2:	55                   	push   %ebp
f01002d3:	89 e5                	mov    %esp,%ebp
f01002d5:	53                   	push   %ebx
f01002d6:	83 ec 04             	sub    $0x4,%esp
f01002d9:	ba 64 00 00 00       	mov    $0x64,%edx
f01002de:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002df:	a8 01                	test   $0x1,%al
f01002e1:	0f 84 f2 00 00 00    	je     f01003d9 <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f01002e7:	a8 20                	test   $0x20,%al
f01002e9:	0f 85 f1 00 00 00    	jne    f01003e0 <kbd_proc_data+0x10e>
f01002ef:	ba 60 00 00 00       	mov    $0x60,%edx
f01002f4:	ec                   	in     (%dx),%al
f01002f5:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002f7:	3c e0                	cmp    $0xe0,%al
f01002f9:	74 61                	je     f010035c <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f01002fb:	84 c0                	test   %al,%al
f01002fd:	78 70                	js     f010036f <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f01002ff:	8b 0d 00 70 34 f0    	mov    0xf0347000,%ecx
f0100305:	f6 c1 40             	test   $0x40,%cl
f0100308:	74 0e                	je     f0100318 <kbd_proc_data+0x46>
		data |= 0x80;
f010030a:	83 c8 80             	or     $0xffffff80,%eax
f010030d:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010030f:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100312:	89 0d 00 70 34 f0    	mov    %ecx,0xf0347000
	shift |= shiftcode[data];
f0100318:	0f b6 d2             	movzbl %dl,%edx
f010031b:	0f b6 82 60 71 10 f0 	movzbl -0xfef8ea0(%edx),%eax
f0100322:	0b 05 00 70 34 f0    	or     0xf0347000,%eax
	shift ^= togglecode[data];
f0100328:	0f b6 8a 60 70 10 f0 	movzbl -0xfef8fa0(%edx),%ecx
f010032f:	31 c8                	xor    %ecx,%eax
f0100331:	a3 00 70 34 f0       	mov    %eax,0xf0347000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100336:	89 c1                	mov    %eax,%ecx
f0100338:	83 e1 03             	and    $0x3,%ecx
f010033b:	8b 0c 8d 40 70 10 f0 	mov    -0xfef8fc0(,%ecx,4),%ecx
f0100342:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100346:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100349:	a8 08                	test   $0x8,%al
f010034b:	74 61                	je     f01003ae <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f010034d:	89 da                	mov    %ebx,%edx
f010034f:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100352:	83 f9 19             	cmp    $0x19,%ecx
f0100355:	77 4b                	ja     f01003a2 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f0100357:	83 eb 20             	sub    $0x20,%ebx
f010035a:	eb 0c                	jmp    f0100368 <kbd_proc_data+0x96>
		shift |= E0ESC;
f010035c:	83 0d 00 70 34 f0 40 	orl    $0x40,0xf0347000
		return 0;
f0100363:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100368:	89 d8                	mov    %ebx,%eax
f010036a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010036d:	c9                   	leave  
f010036e:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010036f:	8b 0d 00 70 34 f0    	mov    0xf0347000,%ecx
f0100375:	89 cb                	mov    %ecx,%ebx
f0100377:	83 e3 40             	and    $0x40,%ebx
f010037a:	83 e0 7f             	and    $0x7f,%eax
f010037d:	85 db                	test   %ebx,%ebx
f010037f:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100382:	0f b6 d2             	movzbl %dl,%edx
f0100385:	0f b6 82 60 71 10 f0 	movzbl -0xfef8ea0(%edx),%eax
f010038c:	83 c8 40             	or     $0x40,%eax
f010038f:	0f b6 c0             	movzbl %al,%eax
f0100392:	f7 d0                	not    %eax
f0100394:	21 c8                	and    %ecx,%eax
f0100396:	a3 00 70 34 f0       	mov    %eax,0xf0347000
		return 0;
f010039b:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003a0:	eb c6                	jmp    f0100368 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f01003a2:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003a5:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003a8:	83 fa 1a             	cmp    $0x1a,%edx
f01003ab:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003ae:	f7 d0                	not    %eax
f01003b0:	a8 06                	test   $0x6,%al
f01003b2:	75 b4                	jne    f0100368 <kbd_proc_data+0x96>
f01003b4:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003ba:	75 ac                	jne    f0100368 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f01003bc:	83 ec 0c             	sub    $0xc,%esp
f01003bf:	68 17 70 10 f0       	push   $0xf0107017
f01003c4:	e8 ba 39 00 00       	call   f0103d83 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003c9:	b8 03 00 00 00       	mov    $0x3,%eax
f01003ce:	ba 92 00 00 00       	mov    $0x92,%edx
f01003d3:	ee                   	out    %al,(%dx)
f01003d4:	83 c4 10             	add    $0x10,%esp
f01003d7:	eb 8f                	jmp    f0100368 <kbd_proc_data+0x96>
		return -1;
f01003d9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003de:	eb 88                	jmp    f0100368 <kbd_proc_data+0x96>
		return -1;
f01003e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003e5:	eb 81                	jmp    f0100368 <kbd_proc_data+0x96>

f01003e7 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003e7:	55                   	push   %ebp
f01003e8:	89 e5                	mov    %esp,%ebp
f01003ea:	57                   	push   %edi
f01003eb:	56                   	push   %esi
f01003ec:	53                   	push   %ebx
f01003ed:	83 ec 1c             	sub    $0x1c,%esp
f01003f0:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f01003f2:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003f7:	bf fd 03 00 00       	mov    $0x3fd,%edi
f01003fc:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100401:	89 fa                	mov    %edi,%edx
f0100403:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100404:	a8 20                	test   $0x20,%al
f0100406:	75 13                	jne    f010041b <cons_putc+0x34>
f0100408:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010040e:	7f 0b                	jg     f010041b <cons_putc+0x34>
f0100410:	89 da                	mov    %ebx,%edx
f0100412:	ec                   	in     (%dx),%al
f0100413:	ec                   	in     (%dx),%al
f0100414:	ec                   	in     (%dx),%al
f0100415:	ec                   	in     (%dx),%al
	     i++)
f0100416:	83 c6 01             	add    $0x1,%esi
f0100419:	eb e6                	jmp    f0100401 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f010041b:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010041e:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100423:	89 c8                	mov    %ecx,%eax
f0100425:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100426:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010042b:	bf 79 03 00 00       	mov    $0x379,%edi
f0100430:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100435:	89 fa                	mov    %edi,%edx
f0100437:	ec                   	in     (%dx),%al
f0100438:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010043e:	7f 0f                	jg     f010044f <cons_putc+0x68>
f0100440:	84 c0                	test   %al,%al
f0100442:	78 0b                	js     f010044f <cons_putc+0x68>
f0100444:	89 da                	mov    %ebx,%edx
f0100446:	ec                   	in     (%dx),%al
f0100447:	ec                   	in     (%dx),%al
f0100448:	ec                   	in     (%dx),%al
f0100449:	ec                   	in     (%dx),%al
f010044a:	83 c6 01             	add    $0x1,%esi
f010044d:	eb e6                	jmp    f0100435 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010044f:	ba 78 03 00 00       	mov    $0x378,%edx
f0100454:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100458:	ee                   	out    %al,(%dx)
f0100459:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010045e:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100463:	ee                   	out    %al,(%dx)
f0100464:	b8 08 00 00 00       	mov    $0x8,%eax
f0100469:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010046a:	89 ca                	mov    %ecx,%edx
f010046c:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100472:	89 c8                	mov    %ecx,%eax
f0100474:	80 cc 07             	or     $0x7,%ah
f0100477:	85 d2                	test   %edx,%edx
f0100479:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f010047c:	0f b6 c1             	movzbl %cl,%eax
f010047f:	83 f8 09             	cmp    $0x9,%eax
f0100482:	0f 84 b0 00 00 00    	je     f0100538 <cons_putc+0x151>
f0100488:	7e 73                	jle    f01004fd <cons_putc+0x116>
f010048a:	83 f8 0a             	cmp    $0xa,%eax
f010048d:	0f 84 98 00 00 00    	je     f010052b <cons_putc+0x144>
f0100493:	83 f8 0d             	cmp    $0xd,%eax
f0100496:	0f 85 d3 00 00 00    	jne    f010056f <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f010049c:	0f b7 05 28 72 34 f0 	movzwl 0xf0347228,%eax
f01004a3:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004a9:	c1 e8 16             	shr    $0x16,%eax
f01004ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004af:	c1 e0 04             	shl    $0x4,%eax
f01004b2:	66 a3 28 72 34 f0    	mov    %ax,0xf0347228
	if (crt_pos >= CRT_SIZE) {
f01004b8:	66 81 3d 28 72 34 f0 	cmpw   $0x7cf,0xf0347228
f01004bf:	cf 07 
f01004c1:	0f 87 cb 00 00 00    	ja     f0100592 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f01004c7:	8b 0d 30 72 34 f0    	mov    0xf0347230,%ecx
f01004cd:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004d2:	89 ca                	mov    %ecx,%edx
f01004d4:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004d5:	0f b7 1d 28 72 34 f0 	movzwl 0xf0347228,%ebx
f01004dc:	8d 71 01             	lea    0x1(%ecx),%esi
f01004df:	89 d8                	mov    %ebx,%eax
f01004e1:	66 c1 e8 08          	shr    $0x8,%ax
f01004e5:	89 f2                	mov    %esi,%edx
f01004e7:	ee                   	out    %al,(%dx)
f01004e8:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004ed:	89 ca                	mov    %ecx,%edx
f01004ef:	ee                   	out    %al,(%dx)
f01004f0:	89 d8                	mov    %ebx,%eax
f01004f2:	89 f2                	mov    %esi,%edx
f01004f4:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01004f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01004f8:	5b                   	pop    %ebx
f01004f9:	5e                   	pop    %esi
f01004fa:	5f                   	pop    %edi
f01004fb:	5d                   	pop    %ebp
f01004fc:	c3                   	ret    
	switch (c & 0xff) {
f01004fd:	83 f8 08             	cmp    $0x8,%eax
f0100500:	75 6d                	jne    f010056f <cons_putc+0x188>
		if (crt_pos > 0) {
f0100502:	0f b7 05 28 72 34 f0 	movzwl 0xf0347228,%eax
f0100509:	66 85 c0             	test   %ax,%ax
f010050c:	74 b9                	je     f01004c7 <cons_putc+0xe0>
			crt_pos--;
f010050e:	83 e8 01             	sub    $0x1,%eax
f0100511:	66 a3 28 72 34 f0    	mov    %ax,0xf0347228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100517:	0f b7 c0             	movzwl %ax,%eax
f010051a:	b1 00                	mov    $0x0,%cl
f010051c:	83 c9 20             	or     $0x20,%ecx
f010051f:	8b 15 2c 72 34 f0    	mov    0xf034722c,%edx
f0100525:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f0100529:	eb 8d                	jmp    f01004b8 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f010052b:	66 83 05 28 72 34 f0 	addw   $0x50,0xf0347228
f0100532:	50 
f0100533:	e9 64 ff ff ff       	jmp    f010049c <cons_putc+0xb5>
		cons_putc(' ');
f0100538:	b8 20 00 00 00       	mov    $0x20,%eax
f010053d:	e8 a5 fe ff ff       	call   f01003e7 <cons_putc>
		cons_putc(' ');
f0100542:	b8 20 00 00 00       	mov    $0x20,%eax
f0100547:	e8 9b fe ff ff       	call   f01003e7 <cons_putc>
		cons_putc(' ');
f010054c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100551:	e8 91 fe ff ff       	call   f01003e7 <cons_putc>
		cons_putc(' ');
f0100556:	b8 20 00 00 00       	mov    $0x20,%eax
f010055b:	e8 87 fe ff ff       	call   f01003e7 <cons_putc>
		cons_putc(' ');
f0100560:	b8 20 00 00 00       	mov    $0x20,%eax
f0100565:	e8 7d fe ff ff       	call   f01003e7 <cons_putc>
f010056a:	e9 49 ff ff ff       	jmp    f01004b8 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f010056f:	0f b7 05 28 72 34 f0 	movzwl 0xf0347228,%eax
f0100576:	8d 50 01             	lea    0x1(%eax),%edx
f0100579:	66 89 15 28 72 34 f0 	mov    %dx,0xf0347228
f0100580:	0f b7 c0             	movzwl %ax,%eax
f0100583:	8b 15 2c 72 34 f0    	mov    0xf034722c,%edx
f0100589:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010058d:	e9 26 ff ff ff       	jmp    f01004b8 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100592:	a1 2c 72 34 f0       	mov    0xf034722c,%eax
f0100597:	83 ec 04             	sub    $0x4,%esp
f010059a:	68 00 0f 00 00       	push   $0xf00
f010059f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005a5:	52                   	push   %edx
f01005a6:	50                   	push   %eax
f01005a7:	e8 65 5d 00 00       	call   f0106311 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005ac:	8b 15 2c 72 34 f0    	mov    0xf034722c,%edx
f01005b2:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005b8:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005be:	83 c4 10             	add    $0x10,%esp
f01005c1:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005c6:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005c9:	39 d0                	cmp    %edx,%eax
f01005cb:	75 f4                	jne    f01005c1 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f01005cd:	66 83 2d 28 72 34 f0 	subw   $0x50,0xf0347228
f01005d4:	50 
f01005d5:	e9 ed fe ff ff       	jmp    f01004c7 <cons_putc+0xe0>

f01005da <serial_intr>:
	if (serial_exists)
f01005da:	80 3d 34 72 34 f0 00 	cmpb   $0x0,0xf0347234
f01005e1:	75 01                	jne    f01005e4 <serial_intr+0xa>
f01005e3:	c3                   	ret    
{
f01005e4:	55                   	push   %ebp
f01005e5:	89 e5                	mov    %esp,%ebp
f01005e7:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005ea:	b8 79 02 10 f0       	mov    $0xf0100279,%eax
f01005ef:	e8 9f fc ff ff       	call   f0100293 <cons_intr>
}
f01005f4:	c9                   	leave  
f01005f5:	c3                   	ret    

f01005f6 <kbd_intr>:
{
f01005f6:	55                   	push   %ebp
f01005f7:	89 e5                	mov    %esp,%ebp
f01005f9:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01005fc:	b8 d2 02 10 f0       	mov    $0xf01002d2,%eax
f0100601:	e8 8d fc ff ff       	call   f0100293 <cons_intr>
}
f0100606:	c9                   	leave  
f0100607:	c3                   	ret    

f0100608 <cons_getc>:
{
f0100608:	55                   	push   %ebp
f0100609:	89 e5                	mov    %esp,%ebp
f010060b:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010060e:	e8 c7 ff ff ff       	call   f01005da <serial_intr>
	kbd_intr();
f0100613:	e8 de ff ff ff       	call   f01005f6 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100618:	8b 15 20 72 34 f0    	mov    0xf0347220,%edx
	return 0;
f010061e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100623:	3b 15 24 72 34 f0    	cmp    0xf0347224,%edx
f0100629:	74 1e                	je     f0100649 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f010062b:	8d 4a 01             	lea    0x1(%edx),%ecx
f010062e:	0f b6 82 20 70 34 f0 	movzbl -0xfcb8fe0(%edx),%eax
			cons.rpos = 0;
f0100635:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010063b:	ba 00 00 00 00       	mov    $0x0,%edx
f0100640:	0f 44 ca             	cmove  %edx,%ecx
f0100643:	89 0d 20 72 34 f0    	mov    %ecx,0xf0347220
}
f0100649:	c9                   	leave  
f010064a:	c3                   	ret    

f010064b <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010064b:	55                   	push   %ebp
f010064c:	89 e5                	mov    %esp,%ebp
f010064e:	57                   	push   %edi
f010064f:	56                   	push   %esi
f0100650:	53                   	push   %ebx
f0100651:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100654:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010065b:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100662:	5a a5 
	if (*cp != 0xA55A) {
f0100664:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010066b:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010066f:	0f 84 de 00 00 00    	je     f0100753 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100675:	c7 05 30 72 34 f0 b4 	movl   $0x3b4,0xf0347230
f010067c:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010067f:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f0100684:	8b 3d 30 72 34 f0    	mov    0xf0347230,%edi
f010068a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010068f:	89 fa                	mov    %edi,%edx
f0100691:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100692:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100695:	89 ca                	mov    %ecx,%edx
f0100697:	ec                   	in     (%dx),%al
f0100698:	0f b6 c0             	movzbl %al,%eax
f010069b:	c1 e0 08             	shl    $0x8,%eax
f010069e:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006a0:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006a5:	89 fa                	mov    %edi,%edx
f01006a7:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006a8:	89 ca                	mov    %ecx,%edx
f01006aa:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006ab:	89 35 2c 72 34 f0    	mov    %esi,0xf034722c
	pos |= inb(addr_6845 + 1);
f01006b1:	0f b6 c0             	movzbl %al,%eax
f01006b4:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006b6:	66 a3 28 72 34 f0    	mov    %ax,0xf0347228
	kbd_intr();
f01006bc:	e8 35 ff ff ff       	call   f01005f6 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006c1:	83 ec 0c             	sub    $0xc,%esp
f01006c4:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f01006cb:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006d0:	50                   	push   %eax
f01006d1:	e8 46 35 00 00       	call   f0103c1c <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006d6:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006db:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006e0:	89 d8                	mov    %ebx,%eax
f01006e2:	89 ca                	mov    %ecx,%edx
f01006e4:	ee                   	out    %al,(%dx)
f01006e5:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01006ef:	89 fa                	mov    %edi,%edx
f01006f1:	ee                   	out    %al,(%dx)
f01006f2:	b8 0c 00 00 00       	mov    $0xc,%eax
f01006f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006fc:	ee                   	out    %al,(%dx)
f01006fd:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100702:	89 d8                	mov    %ebx,%eax
f0100704:	89 f2                	mov    %esi,%edx
f0100706:	ee                   	out    %al,(%dx)
f0100707:	b8 03 00 00 00       	mov    $0x3,%eax
f010070c:	89 fa                	mov    %edi,%edx
f010070e:	ee                   	out    %al,(%dx)
f010070f:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100714:	89 d8                	mov    %ebx,%eax
f0100716:	ee                   	out    %al,(%dx)
f0100717:	b8 01 00 00 00       	mov    $0x1,%eax
f010071c:	89 f2                	mov    %esi,%edx
f010071e:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010071f:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100724:	ec                   	in     (%dx),%al
f0100725:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100727:	83 c4 10             	add    $0x10,%esp
f010072a:	3c ff                	cmp    $0xff,%al
f010072c:	0f 95 05 34 72 34 f0 	setne  0xf0347234
f0100733:	89 ca                	mov    %ecx,%edx
f0100735:	ec                   	in     (%dx),%al
f0100736:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010073b:	ec                   	in     (%dx),%al
	if (serial_exists)
f010073c:	80 fb ff             	cmp    $0xff,%bl
f010073f:	75 2d                	jne    f010076e <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100741:	83 ec 0c             	sub    $0xc,%esp
f0100744:	68 23 70 10 f0       	push   $0xf0107023
f0100749:	e8 35 36 00 00       	call   f0103d83 <cprintf>
f010074e:	83 c4 10             	add    $0x10,%esp
}
f0100751:	eb 3c                	jmp    f010078f <cons_init+0x144>
		*cp = was;
f0100753:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010075a:	c7 05 30 72 34 f0 d4 	movl   $0x3d4,0xf0347230
f0100761:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100764:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100769:	e9 16 ff ff ff       	jmp    f0100684 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010076e:	83 ec 0c             	sub    $0xc,%esp
f0100771:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0100778:	25 ef ff 00 00       	and    $0xffef,%eax
f010077d:	50                   	push   %eax
f010077e:	e8 99 34 00 00       	call   f0103c1c <irq_setmask_8259A>
	if (!serial_exists)
f0100783:	83 c4 10             	add    $0x10,%esp
f0100786:	80 3d 34 72 34 f0 00 	cmpb   $0x0,0xf0347234
f010078d:	74 b2                	je     f0100741 <cons_init+0xf6>
}
f010078f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100792:	5b                   	pop    %ebx
f0100793:	5e                   	pop    %esi
f0100794:	5f                   	pop    %edi
f0100795:	5d                   	pop    %ebp
f0100796:	c3                   	ret    

f0100797 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100797:	55                   	push   %ebp
f0100798:	89 e5                	mov    %esp,%ebp
f010079a:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010079d:	8b 45 08             	mov    0x8(%ebp),%eax
f01007a0:	e8 42 fc ff ff       	call   f01003e7 <cons_putc>
}
f01007a5:	c9                   	leave  
f01007a6:	c3                   	ret    

f01007a7 <getchar>:

int
getchar(void)
{
f01007a7:	55                   	push   %ebp
f01007a8:	89 e5                	mov    %esp,%ebp
f01007aa:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007ad:	e8 56 fe ff ff       	call   f0100608 <cons_getc>
f01007b2:	85 c0                	test   %eax,%eax
f01007b4:	74 f7                	je     f01007ad <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007b6:	c9                   	leave  
f01007b7:	c3                   	ret    

f01007b8 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f01007b8:	b8 01 00 00 00       	mov    $0x1,%eax
f01007bd:	c3                   	ret    

f01007be <mon_help>:
/***** Implementations of basic kernel monitor commands *****/
static long atol(const char *nptr);

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007be:	55                   	push   %ebp
f01007bf:	89 e5                	mov    %esp,%ebp
f01007c1:	53                   	push   %ebx
f01007c2:	83 ec 04             	sub    $0x4,%esp
f01007c5:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007ca:	83 ec 04             	sub    $0x4,%esp
f01007cd:	ff b3 c4 76 10 f0    	pushl  -0xfef893c(%ebx)
f01007d3:	ff b3 c0 76 10 f0    	pushl  -0xfef8940(%ebx)
f01007d9:	68 60 72 10 f0       	push   $0xf0107260
f01007de:	e8 a0 35 00 00       	call   f0103d83 <cprintf>
f01007e3:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f01007e6:	83 c4 10             	add    $0x10,%esp
f01007e9:	83 fb 3c             	cmp    $0x3c,%ebx
f01007ec:	75 dc                	jne    f01007ca <mon_help+0xc>
	return 0;
}
f01007ee:	b8 00 00 00 00       	mov    $0x0,%eax
f01007f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01007f6:	c9                   	leave  
f01007f7:	c3                   	ret    

f01007f8 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007f8:	55                   	push   %ebp
f01007f9:	89 e5                	mov    %esp,%ebp
f01007fb:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007fe:	68 69 72 10 f0       	push   $0xf0107269
f0100803:	e8 7b 35 00 00       	call   f0103d83 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100808:	83 c4 08             	add    $0x8,%esp
f010080b:	68 0c 00 10 00       	push   $0x10000c
f0100810:	68 cc 73 10 f0       	push   $0xf01073cc
f0100815:	e8 69 35 00 00       	call   f0103d83 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010081a:	83 c4 0c             	add    $0xc,%esp
f010081d:	68 0c 00 10 00       	push   $0x10000c
f0100822:	68 0c 00 10 f0       	push   $0xf010000c
f0100827:	68 f4 73 10 f0       	push   $0xf01073f4
f010082c:	e8 52 35 00 00       	call   f0103d83 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100831:	83 c4 0c             	add    $0xc,%esp
f0100834:	68 0f 6f 10 00       	push   $0x106f0f
f0100839:	68 0f 6f 10 f0       	push   $0xf0106f0f
f010083e:	68 18 74 10 f0       	push   $0xf0107418
f0100843:	e8 3b 35 00 00       	call   f0103d83 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100848:	83 c4 0c             	add    $0xc,%esp
f010084b:	68 00 70 34 00       	push   $0x347000
f0100850:	68 00 70 34 f0       	push   $0xf0347000
f0100855:	68 3c 74 10 f0       	push   $0xf010743c
f010085a:	e8 24 35 00 00       	call   f0103d83 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010085f:	83 c4 0c             	add    $0xc,%esp
f0100862:	68 08 90 38 00       	push   $0x389008
f0100867:	68 08 90 38 f0       	push   $0xf0389008
f010086c:	68 60 74 10 f0       	push   $0xf0107460
f0100871:	e8 0d 35 00 00       	call   f0103d83 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100876:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100879:	b8 08 90 38 f0       	mov    $0xf0389008,%eax
f010087e:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100883:	c1 f8 0a             	sar    $0xa,%eax
f0100886:	50                   	push   %eax
f0100887:	68 84 74 10 f0       	push   $0xf0107484
f010088c:	e8 f2 34 00 00       	call   f0103d83 <cprintf>
	return 0;
}
f0100891:	b8 00 00 00 00       	mov    $0x0,%eax
f0100896:	c9                   	leave  
f0100897:	c3                   	ret    

f0100898 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100898:	55                   	push   %ebp
f0100899:	89 e5                	mov    %esp,%ebp
f010089b:	56                   	push   %esi
f010089c:	53                   	push   %ebx
f010089d:	83 ec 20             	sub    $0x20,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008a0:	89 eb                	mov    %ebp,%ebx
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
		debuginfo_eip(the_ebp[1], &info);
f01008a2:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(the_ebp != NULL){
f01008a5:	85 db                	test   %ebx,%ebx
f01008a7:	0f 84 b3 00 00 00    	je     f0100960 <mon_backtrace+0xc8>
		cprintf("the ebp1 0x%x\n", the_ebp[1]);
f01008ad:	83 ec 08             	sub    $0x8,%esp
f01008b0:	ff 73 04             	pushl  0x4(%ebx)
f01008b3:	68 82 72 10 f0       	push   $0xf0107282
f01008b8:	e8 c6 34 00 00       	call   f0103d83 <cprintf>
		cprintf("the ebp2 0x%x\n", the_ebp[2]);
f01008bd:	83 c4 08             	add    $0x8,%esp
f01008c0:	ff 73 08             	pushl  0x8(%ebx)
f01008c3:	68 91 72 10 f0       	push   $0xf0107291
f01008c8:	e8 b6 34 00 00       	call   f0103d83 <cprintf>
		cprintf("the ebp3 0x%x\n", the_ebp[3]);
f01008cd:	83 c4 08             	add    $0x8,%esp
f01008d0:	ff 73 0c             	pushl  0xc(%ebx)
f01008d3:	68 a0 72 10 f0       	push   $0xf01072a0
f01008d8:	e8 a6 34 00 00       	call   f0103d83 <cprintf>
		cprintf("the ebp4 0x%x\n", the_ebp[4]);
f01008dd:	83 c4 08             	add    $0x8,%esp
f01008e0:	ff 73 10             	pushl  0x10(%ebx)
f01008e3:	68 af 72 10 f0       	push   $0xf01072af
f01008e8:	e8 96 34 00 00       	call   f0103d83 <cprintf>
		cprintf("the ebp5 0x%x\n", the_ebp[5]);
f01008ed:	83 c4 08             	add    $0x8,%esp
f01008f0:	ff 73 14             	pushl  0x14(%ebx)
f01008f3:	68 be 72 10 f0       	push   $0xf01072be
f01008f8:	e8 86 34 00 00       	call   f0103d83 <cprintf>
		cprintf("the ebp6 0x%x\n", the_ebp[6]);//just test
f01008fd:	83 c4 08             	add    $0x8,%esp
f0100900:	ff 73 18             	pushl  0x18(%ebx)
f0100903:	68 cd 72 10 f0       	push   $0xf01072cd
f0100908:	e8 76 34 00 00       	call   f0103d83 <cprintf>
		cprintf("eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", the_ebp[1], the_ebp, the_ebp[2], the_ebp[3], the_ebp[4], the_ebp[5], the_ebp[6]);
f010090d:	ff 73 18             	pushl  0x18(%ebx)
f0100910:	ff 73 14             	pushl  0x14(%ebx)
f0100913:	ff 73 10             	pushl  0x10(%ebx)
f0100916:	ff 73 0c             	pushl  0xc(%ebx)
f0100919:	ff 73 08             	pushl  0x8(%ebx)
f010091c:	53                   	push   %ebx
f010091d:	ff 73 04             	pushl  0x4(%ebx)
f0100920:	68 b0 74 10 f0       	push   $0xf01074b0
f0100925:	e8 59 34 00 00       	call   f0103d83 <cprintf>
		debuginfo_eip(the_ebp[1], &info);
f010092a:	83 c4 28             	add    $0x28,%esp
f010092d:	56                   	push   %esi
f010092e:	ff 73 04             	pushl  0x4(%ebx)
f0100931:	e8 2c 4d 00 00       	call   f0105662 <debuginfo_eip>
		cprintf("       %s:%d %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, the_ebp[1] - (uint32_t)info.eip_fn_addr);
f0100936:	83 c4 08             	add    $0x8,%esp
f0100939:	8b 43 04             	mov    0x4(%ebx),%eax
f010093c:	2b 45 f0             	sub    -0x10(%ebp),%eax
f010093f:	50                   	push   %eax
f0100940:	ff 75 e8             	pushl  -0x18(%ebp)
f0100943:	ff 75 ec             	pushl  -0x14(%ebp)
f0100946:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100949:	ff 75 e0             	pushl  -0x20(%ebp)
f010094c:	68 dc 72 10 f0       	push   $0xf01072dc
f0100951:	e8 2d 34 00 00       	call   f0103d83 <cprintf>
		the_ebp = (uint32_t *)*the_ebp;
f0100956:	8b 1b                	mov    (%ebx),%ebx
f0100958:	83 c4 20             	add    $0x20,%esp
f010095b:	e9 45 ff ff ff       	jmp    f01008a5 <mon_backtrace+0xd>
	}
    cprintf("Backtrace success\n");
f0100960:	83 ec 0c             	sub    $0xc,%esp
f0100963:	68 f2 72 10 f0       	push   $0xf01072f2
f0100968:	e8 16 34 00 00       	call   f0103d83 <cprintf>
	return 0;
}
f010096d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100972:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100975:	5b                   	pop    %ebx
f0100976:	5e                   	pop    %esi
f0100977:	5d                   	pop    %ebp
f0100978:	c3                   	ret    

f0100979 <mon_showmappings>:
	cycles_t end = currentcycles();
	cprintf("%s cycles: %ul\n", fun_n, end - start);
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f0100979:	55                   	push   %ebp
f010097a:	89 e5                	mov    %esp,%ebp
f010097c:	57                   	push   %edi
f010097d:	56                   	push   %esi
f010097e:	53                   	push   %ebx
f010097f:	83 ec 2c             	sub    $0x2c,%esp
	if(argc != 3){
f0100982:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100986:	75 3f                	jne    f01009c7 <mon_showmappings+0x4e>
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
		return 0;
	}
	uint32_t low_va = 0, high_va = 0, old_va;
	if(argv[1][0]!='0'||argv[1][1]!='x'||argv[2][0]!='0'||argv[2][1]!='x'){
f0100988:	8b 45 0c             	mov    0xc(%ebp),%eax
f010098b:	8b 40 04             	mov    0x4(%eax),%eax
f010098e:	80 38 30             	cmpb   $0x30,(%eax)
f0100991:	75 17                	jne    f01009aa <mon_showmappings+0x31>
f0100993:	80 78 01 78          	cmpb   $0x78,0x1(%eax)
f0100997:	75 11                	jne    f01009aa <mon_showmappings+0x31>
f0100999:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010099c:	8b 51 08             	mov    0x8(%ecx),%edx
f010099f:	80 3a 30             	cmpb   $0x30,(%edx)
f01009a2:	75 06                	jne    f01009aa <mon_showmappings+0x31>
f01009a4:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01009a8:	74 34                	je     f01009de <mon_showmappings+0x65>
		cprintf("the virtual-address should be 16-base\n");
f01009aa:	83 ec 0c             	sub    $0xc,%esp
f01009ad:	68 20 75 10 f0       	push   $0xf0107520
f01009b2:	e8 cc 33 00 00       	call   f0103d83 <cprintf>
		return 0;
f01009b7:	83 c4 10             	add    $0x10,%esp
		low_va += PTSIZE;
		if(low_va <= old_va)
			break;
    }
    return 0;
}
f01009ba:	b8 00 00 00 00       	mov    $0x0,%eax
f01009bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01009c2:	5b                   	pop    %ebx
f01009c3:	5e                   	pop    %esi
f01009c4:	5f                   	pop    %edi
f01009c5:	5d                   	pop    %ebp
f01009c6:	c3                   	ret    
		cprintf("usage: %s <start-virtual-address> <end-virtual-address>\n", __FUNCTION__);
f01009c7:	83 ec 08             	sub    $0x8,%esp
f01009ca:	68 a0 76 10 f0       	push   $0xf01076a0
f01009cf:	68 e4 74 10 f0       	push   $0xf01074e4
f01009d4:	e8 aa 33 00 00       	call   f0103d83 <cprintf>
		return 0;
f01009d9:	83 c4 10             	add    $0x10,%esp
f01009dc:	eb dc                	jmp    f01009ba <mon_showmappings+0x41>
	low_va = (uint32_t)strtol(argv[1], &tmp, 16);
f01009de:	83 ec 04             	sub    $0x4,%esp
f01009e1:	6a 10                	push   $0x10
f01009e3:	8d 75 e4             	lea    -0x1c(%ebp),%esi
f01009e6:	56                   	push   %esi
f01009e7:	50                   	push   %eax
f01009e8:	e8 f2 59 00 00       	call   f01063df <strtol>
f01009ed:	89 c3                	mov    %eax,%ebx
	high_va = (uint32_t)strtol(argv[2], &tmp, 16);
f01009ef:	83 c4 0c             	add    $0xc,%esp
f01009f2:	6a 10                	push   $0x10
f01009f4:	56                   	push   %esi
f01009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01009f8:	ff 70 08             	pushl  0x8(%eax)
f01009fb:	e8 df 59 00 00       	call   f01063df <strtol>
	low_va = low_va/PGSIZE * PGSIZE;
f0100a00:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	high_va = high_va/PGSIZE * PGSIZE;
f0100a06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a0b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(low_va > high_va){
f0100a0e:	83 c4 10             	add    $0x10,%esp
f0100a11:	39 c3                	cmp    %eax,%ebx
f0100a13:	0f 86 1c 01 00 00    	jbe    f0100b35 <mon_showmappings+0x1bc>
		cprintf("the start-va should < the end-va\n");
f0100a19:	83 ec 0c             	sub    $0xc,%esp
f0100a1c:	68 48 75 10 f0       	push   $0xf0107548
f0100a21:	e8 5d 33 00 00       	call   f0103d83 <cprintf>
		return 0;
f0100a26:	83 c4 10             	add    $0x10,%esp
f0100a29:	eb 8f                	jmp    f01009ba <mon_showmappings+0x41>
					cprintf("va: [%x - %x] ", low_va, low_va + PGSIZE - 1);
f0100a2b:	83 ec 04             	sub    $0x4,%esp
f0100a2e:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0100a34:	50                   	push   %eax
f0100a35:	53                   	push   %ebx
f0100a36:	68 05 73 10 f0       	push   $0xf0107305
f0100a3b:	e8 43 33 00 00       	call   f0103d83 <cprintf>
					cprintf("pa: [%x - %x] ", PTE_ADDR(pte[PTX(low_va)]), PTE_ADDR(pte[PTX(low_va)]) + PGSIZE - 1);
f0100a40:	8b 06                	mov    (%esi),%eax
f0100a42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a47:	83 c4 0c             	add    $0xc,%esp
f0100a4a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100a50:	52                   	push   %edx
f0100a51:	50                   	push   %eax
f0100a52:	68 14 73 10 f0       	push   $0xf0107314
f0100a57:	e8 27 33 00 00       	call   f0103d83 <cprintf>
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a5c:	83 c4 0c             	add    $0xc,%esp
f0100a5f:	89 f8                	mov    %edi,%eax
f0100a61:	83 e0 01             	and    $0x1,%eax
f0100a64:	50                   	push   %eax
					u_bit = pte[PTX(low_va)] & PTE_U;
f0100a65:	89 f8                	mov    %edi,%eax
f0100a67:	83 e0 04             	and    $0x4,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a6a:	0f be c0             	movsbl %al,%eax
f0100a6d:	50                   	push   %eax
					w_bit = pte[PTX(low_va)] & PTE_W;
f0100a6e:	89 f8                	mov    %edi,%eax
f0100a70:	83 e0 02             	and    $0x2,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a73:	0f be c0             	movsbl %al,%eax
f0100a76:	50                   	push   %eax
					a_bit = pte[PTX(low_va)] & PTE_A;
f0100a77:	89 f8                	mov    %edi,%eax
f0100a79:	83 e0 20             	and    $0x20,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a7c:	0f be c0             	movsbl %al,%eax
f0100a7f:	50                   	push   %eax
					d_bit = pte[PTX(low_va)] & PTE_D;
f0100a80:	89 f8                	mov    %edi,%eax
f0100a82:	83 e0 40             	and    $0x40,%eax
					cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100a85:	0f be c0             	movsbl %al,%eax
f0100a88:	50                   	push   %eax
f0100a89:	6a 00                	push   $0x0
f0100a8b:	68 23 73 10 f0       	push   $0xf0107323
f0100a90:	e8 ee 32 00 00       	call   f0103d83 <cprintf>
f0100a95:	83 c4 20             	add    $0x20,%esp
f0100a98:	e9 dc 00 00 00       	jmp    f0100b79 <mon_showmappings+0x200>
				cprintf("va: [%x - %x] ", low_va, low_va + PTSIZE - 1);
f0100a9d:	83 ec 04             	sub    $0x4,%esp
f0100aa0:	8d 83 ff ff 3f 00    	lea    0x3fffff(%ebx),%eax
f0100aa6:	50                   	push   %eax
f0100aa7:	53                   	push   %ebx
f0100aa8:	68 05 73 10 f0       	push   $0xf0107305
f0100aad:	e8 d1 32 00 00       	call   f0103d83 <cprintf>
				cprintf("pa: [%x - %x] ", PTE_ADDR(*pde), PTE_ADDR(*pde) + PTSIZE -1);
f0100ab2:	8b 07                	mov    (%edi),%eax
f0100ab4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ab9:	83 c4 0c             	add    $0xc,%esp
f0100abc:	8d 90 ff ff 3f 00    	lea    0x3fffff(%eax),%edx
f0100ac2:	52                   	push   %edx
f0100ac3:	50                   	push   %eax
f0100ac4:	68 14 73 10 f0       	push   $0xf0107314
f0100ac9:	e8 b5 32 00 00       	call   f0103d83 <cprintf>
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ace:	83 c4 0c             	add    $0xc,%esp
f0100ad1:	89 f0                	mov    %esi,%eax
f0100ad3:	83 e0 01             	and    $0x1,%eax
f0100ad6:	50                   	push   %eax
				u_bit = *pde & PTE_U;
f0100ad7:	89 f0                	mov    %esi,%eax
f0100ad9:	83 e0 04             	and    $0x4,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100adc:	0f be c0             	movsbl %al,%eax
f0100adf:	50                   	push   %eax
				w_bit = *pde & PTE_W;
f0100ae0:	89 f0                	mov    %esi,%eax
f0100ae2:	83 e0 02             	and    $0x2,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100ae5:	0f be c0             	movsbl %al,%eax
f0100ae8:	50                   	push   %eax
				a_bit = *pde & PTE_A;
f0100ae9:	89 f0                	mov    %esi,%eax
f0100aeb:	83 e0 20             	and    $0x20,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100aee:	0f be c0             	movsbl %al,%eax
f0100af1:	50                   	push   %eax
				d_bit = *pde & PTE_D;
f0100af2:	89 f0                	mov    %esi,%eax
f0100af4:	83 e0 40             	and    $0x40,%eax
				cprintf("--%x0%x%x-%x%x-%x\n", g_bit, d_bit, a_bit, w_bit, u_bit, p_bit);
f0100af7:	0f be c0             	movsbl %al,%eax
f0100afa:	50                   	push   %eax
f0100afb:	6a 00                	push   $0x0
f0100afd:	68 23 73 10 f0       	push   $0xf0107323
f0100b02:	e8 7c 32 00 00       	call   f0103d83 <cprintf>
				low_va += PTSIZE;
f0100b07:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
				if(low_va <= old_va)
f0100b0d:	83 c4 20             	add    $0x20,%esp
f0100b10:	39 d8                	cmp    %ebx,%eax
f0100b12:	0f 86 a2 fe ff ff    	jbe    f01009ba <mon_showmappings+0x41>
				low_va += PTSIZE;
f0100b18:	89 c3                	mov    %eax,%ebx
f0100b1a:	eb 10                	jmp    f0100b2c <mon_showmappings+0x1b3>
		low_va += PTSIZE;
f0100b1c:	8d 83 00 00 40 00    	lea    0x400000(%ebx),%eax
		if(low_va <= old_va)
f0100b22:	39 d8                	cmp    %ebx,%eax
f0100b24:	0f 86 90 fe ff ff    	jbe    f01009ba <mon_showmappings+0x41>
		low_va += PTSIZE;
f0100b2a:	89 c3                	mov    %eax,%ebx
    while (low_va <= high_va) {
f0100b2c:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0100b2f:	0f 87 85 fe ff ff    	ja     f01009ba <mon_showmappings+0x41>
        pde_t *pde = &kern_pgdir[PDX(low_va)];
f0100b35:	89 da                	mov    %ebx,%edx
f0100b37:	c1 ea 16             	shr    $0x16,%edx
f0100b3a:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0100b3f:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if (*pde) {
f0100b42:	8b 37                	mov    (%edi),%esi
f0100b44:	85 f6                	test   %esi,%esi
f0100b46:	74 d4                	je     f0100b1c <mon_showmappings+0x1a3>
            if (low_va < (uint32_t)KERNBASE) {
f0100b48:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100b4e:	0f 87 49 ff ff ff    	ja     f0100a9d <mon_showmappings+0x124>
                pte_t *pte = (pte_t*)(PTE_ADDR(*pde)+KERNBASE);
f0100b54:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
				if(pte[PTX(low_va)] & PTE_P){
f0100b5a:	89 d8                	mov    %ebx,%eax
f0100b5c:	c1 e8 0a             	shr    $0xa,%eax
f0100b5f:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100b64:	8d b4 06 00 00 00 f0 	lea    -0x10000000(%esi,%eax,1),%esi
f0100b6b:	8b 3e                	mov    (%esi),%edi
f0100b6d:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0100b73:	0f 85 b2 fe ff ff    	jne    f0100a2b <mon_showmappings+0xb2>
				low_va += PGSIZE;
f0100b79:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
				if(low_va <= old_va)
f0100b7f:	39 d8                	cmp    %ebx,%eax
f0100b81:	0f 86 33 fe ff ff    	jbe    f01009ba <mon_showmappings+0x41>
				low_va += PGSIZE;
f0100b87:	89 c3                	mov    %eax,%ebx
f0100b89:	eb a1                	jmp    f0100b2c <mon_showmappings+0x1b3>

f0100b8b <mon_time>:
mon_time(int argc, char **argv, struct Trapframe *tf){
f0100b8b:	55                   	push   %ebp
f0100b8c:	89 e5                	mov    %esp,%ebp
f0100b8e:	57                   	push   %edi
f0100b8f:	56                   	push   %esi
f0100b90:	53                   	push   %ebx
f0100b91:	83 ec 1c             	sub    $0x1c,%esp
f0100b94:	8b 45 0c             	mov    0xc(%ebp),%eax
	char *fun_n = argv[1];
f0100b97:	8b 78 04             	mov    0x4(%eax),%edi
	if(argc != 2)
f0100b9a:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100b9e:	0f 85 84 00 00 00    	jne    f0100c28 <mon_time+0x9d>
	for(int i = 0; i < command_size; i++){
f0100ba4:	bb 00 00 00 00       	mov    $0x0,%ebx
	cycles_t start = 0;
f0100ba9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0100bb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100bb7:	83 c0 08             	add    $0x8,%eax
f0100bba:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100bbd:	eb 20                	jmp    f0100bdf <mon_time+0x54>
	}
}

cycles_t currentcycles() {
    cycles_t result;
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100bbf:	0f 31                	rdtsc  
f0100bc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100bc4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			commands[i].func(argc-2, argv + 2, tf);
f0100bc7:	83 ec 04             	sub    $0x4,%esp
f0100bca:	ff 75 10             	pushl  0x10(%ebp)
f0100bcd:	ff 75 dc             	pushl  -0x24(%ebp)
f0100bd0:	6a 00                	push   $0x0
f0100bd2:	ff 14 b5 c8 76 10 f0 	call   *-0xfef8938(,%esi,4)
f0100bd9:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < command_size; i++){
f0100bdc:	83 c3 01             	add    $0x1,%ebx
f0100bdf:	39 1d 00 53 12 f0    	cmp    %ebx,0xf0125300
f0100be5:	7e 1c                	jle    f0100c03 <mon_time+0x78>
f0100be7:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
		if(strcmp(commands[i].name, fun_n) == 0){
f0100bea:	83 ec 08             	sub    $0x8,%esp
f0100bed:	57                   	push   %edi
f0100bee:	ff 34 b5 c0 76 10 f0 	pushl  -0xfef8940(,%esi,4)
f0100bf5:	e8 34 56 00 00       	call   f010622e <strcmp>
f0100bfa:	83 c4 10             	add    $0x10,%esp
f0100bfd:	85 c0                	test   %eax,%eax
f0100bff:	75 db                	jne    f0100bdc <mon_time+0x51>
f0100c01:	eb bc                	jmp    f0100bbf <mon_time+0x34>
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100c03:	0f 31                	rdtsc  
	cprintf("%s cycles: %ul\n", fun_n, end - start);
f0100c05:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100c08:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
f0100c0b:	52                   	push   %edx
f0100c0c:	50                   	push   %eax
f0100c0d:	57                   	push   %edi
f0100c0e:	68 36 73 10 f0       	push   $0xf0107336
f0100c13:	e8 6b 31 00 00       	call   f0103d83 <cprintf>
	return 0;
f0100c18:	83 c4 10             	add    $0x10,%esp
f0100c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c23:	5b                   	pop    %ebx
f0100c24:	5e                   	pop    %esi
f0100c25:	5f                   	pop    %edi
f0100c26:	5d                   	pop    %ebp
f0100c27:	c3                   	ret    
		return -1;
f0100c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c2d:	eb f1                	jmp    f0100c20 <mon_time+0x95>

f0100c2f <monitor>:
{
f0100c2f:	55                   	push   %ebp
f0100c30:	89 e5                	mov    %esp,%ebp
f0100c32:	57                   	push   %edi
f0100c33:	56                   	push   %esi
f0100c34:	53                   	push   %ebx
f0100c35:	83 ec 58             	sub    $0x58,%esp
	cprintf("Welcome to the JOS kernel monitor!\n");
f0100c38:	68 6c 75 10 f0       	push   $0xf010756c
f0100c3d:	e8 41 31 00 00       	call   f0103d83 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c42:	c7 04 24 90 75 10 f0 	movl   $0xf0107590,(%esp)
f0100c49:	e8 35 31 00 00       	call   f0103d83 <cprintf>
	if (tf != NULL)
f0100c4e:	83 c4 10             	add    $0x10,%esp
f0100c51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100c55:	0f 84 d9 00 00 00    	je     f0100d34 <monitor+0x105>
		print_trapframe(tf);
f0100c5b:	83 ec 0c             	sub    $0xc,%esp
f0100c5e:	ff 75 08             	pushl  0x8(%ebp)
f0100c61:	e8 a8 38 00 00       	call   f010450e <print_trapframe>
f0100c66:	83 c4 10             	add    $0x10,%esp
f0100c69:	e9 c6 00 00 00       	jmp    f0100d34 <monitor+0x105>
		while (*buf && strchr(WHITESPACE, *buf))
f0100c6e:	83 ec 08             	sub    $0x8,%esp
f0100c71:	0f be c0             	movsbl %al,%eax
f0100c74:	50                   	push   %eax
f0100c75:	68 4a 73 10 f0       	push   $0xf010734a
f0100c7a:	e8 0d 56 00 00       	call   f010628c <strchr>
f0100c7f:	83 c4 10             	add    $0x10,%esp
f0100c82:	85 c0                	test   %eax,%eax
f0100c84:	74 63                	je     f0100ce9 <monitor+0xba>
			*buf++ = 0;
f0100c86:	c6 03 00             	movb   $0x0,(%ebx)
f0100c89:	89 f7                	mov    %esi,%edi
f0100c8b:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100c8e:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100c90:	0f b6 03             	movzbl (%ebx),%eax
f0100c93:	84 c0                	test   %al,%al
f0100c95:	75 d7                	jne    f0100c6e <monitor+0x3f>
	argv[argc] = 0;
f0100c97:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100c9e:	00 
	if (argc == 0)
f0100c9f:	85 f6                	test   %esi,%esi
f0100ca1:	0f 84 8d 00 00 00    	je     f0100d34 <monitor+0x105>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100ca7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100cac:	83 ec 08             	sub    $0x8,%esp
f0100caf:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100cb2:	ff 34 85 c0 76 10 f0 	pushl  -0xfef8940(,%eax,4)
f0100cb9:	ff 75 a8             	pushl  -0x58(%ebp)
f0100cbc:	e8 6d 55 00 00       	call   f010622e <strcmp>
f0100cc1:	83 c4 10             	add    $0x10,%esp
f0100cc4:	85 c0                	test   %eax,%eax
f0100cc6:	0f 84 8f 00 00 00    	je     f0100d5b <monitor+0x12c>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100ccc:	83 c3 01             	add    $0x1,%ebx
f0100ccf:	83 fb 05             	cmp    $0x5,%ebx
f0100cd2:	75 d8                	jne    f0100cac <monitor+0x7d>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100cd4:	83 ec 08             	sub    $0x8,%esp
f0100cd7:	ff 75 a8             	pushl  -0x58(%ebp)
f0100cda:	68 6c 73 10 f0       	push   $0xf010736c
f0100cdf:	e8 9f 30 00 00       	call   f0103d83 <cprintf>
f0100ce4:	83 c4 10             	add    $0x10,%esp
f0100ce7:	eb 4b                	jmp    f0100d34 <monitor+0x105>
		if (*buf == 0)
f0100ce9:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100cec:	74 a9                	je     f0100c97 <monitor+0x68>
		if (argc == MAXARGS-1) {
f0100cee:	83 fe 0f             	cmp    $0xf,%esi
f0100cf1:	74 2f                	je     f0100d22 <monitor+0xf3>
		argv[argc++] = buf;
f0100cf3:	8d 7e 01             	lea    0x1(%esi),%edi
f0100cf6:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100cfa:	0f b6 03             	movzbl (%ebx),%eax
f0100cfd:	84 c0                	test   %al,%al
f0100cff:	74 8d                	je     f0100c8e <monitor+0x5f>
f0100d01:	83 ec 08             	sub    $0x8,%esp
f0100d04:	0f be c0             	movsbl %al,%eax
f0100d07:	50                   	push   %eax
f0100d08:	68 4a 73 10 f0       	push   $0xf010734a
f0100d0d:	e8 7a 55 00 00       	call   f010628c <strchr>
f0100d12:	83 c4 10             	add    $0x10,%esp
f0100d15:	85 c0                	test   %eax,%eax
f0100d17:	0f 85 71 ff ff ff    	jne    f0100c8e <monitor+0x5f>
			buf++;
f0100d1d:	83 c3 01             	add    $0x1,%ebx
f0100d20:	eb d8                	jmp    f0100cfa <monitor+0xcb>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d22:	83 ec 08             	sub    $0x8,%esp
f0100d25:	6a 10                	push   $0x10
f0100d27:	68 4f 73 10 f0       	push   $0xf010734f
f0100d2c:	e8 52 30 00 00       	call   f0103d83 <cprintf>
f0100d31:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f0100d34:	83 ec 0c             	sub    $0xc,%esp
f0100d37:	68 46 73 10 f0       	push   $0xf0107346
f0100d3c:	e8 1b 53 00 00       	call   f010605c <readline>
f0100d41:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100d43:	83 c4 10             	add    $0x10,%esp
f0100d46:	85 c0                	test   %eax,%eax
f0100d48:	74 ea                	je     f0100d34 <monitor+0x105>
	argv[argc] = 0;
f0100d4a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100d51:	be 00 00 00 00       	mov    $0x0,%esi
f0100d56:	e9 35 ff ff ff       	jmp    f0100c90 <monitor+0x61>
			return commands[i].func(argc, argv, tf);
f0100d5b:	83 ec 04             	sub    $0x4,%esp
f0100d5e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100d61:	ff 75 08             	pushl  0x8(%ebp)
f0100d64:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100d67:	52                   	push   %edx
f0100d68:	56                   	push   %esi
f0100d69:	ff 14 85 c8 76 10 f0 	call   *-0xfef8938(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100d70:	83 c4 10             	add    $0x10,%esp
f0100d73:	85 c0                	test   %eax,%eax
f0100d75:	79 bd                	jns    f0100d34 <monitor+0x105>
}
f0100d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d7a:	5b                   	pop    %ebx
f0100d7b:	5e                   	pop    %esi
f0100d7c:	5f                   	pop    %edi
f0100d7d:	5d                   	pop    %ebp
f0100d7e:	c3                   	ret    

f0100d7f <currentcycles>:
    __asm__ __volatile__("rdtsc" : "=A" (result));
f0100d7f:	0f 31                	rdtsc  
    return result;
}
f0100d81:	c3                   	ret    

f0100d82 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100d82:	55                   	push   %ebp
f0100d83:	89 e5                	mov    %esp,%ebp
f0100d85:	56                   	push   %esi
f0100d86:	53                   	push   %ebx
f0100d87:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100d89:	83 ec 0c             	sub    $0xc,%esp
f0100d8c:	50                   	push   %eax
f0100d8d:	e8 5c 2e 00 00       	call   f0103bee <mc146818_read>
f0100d92:	89 c3                	mov    %eax,%ebx
f0100d94:	83 c6 01             	add    $0x1,%esi
f0100d97:	89 34 24             	mov    %esi,(%esp)
f0100d9a:	e8 4f 2e 00 00       	call   f0103bee <mc146818_read>
f0100d9f:	c1 e0 08             	shl    $0x8,%eax
f0100da2:	09 d8                	or     %ebx,%eax
}
f0100da4:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100da7:	5b                   	pop    %ebx
f0100da8:	5e                   	pop    %esi
f0100da9:	5d                   	pop    %ebp
f0100daa:	c3                   	ret    

f0100dab <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100dab:	89 d1                	mov    %edx,%ecx
f0100dad:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100db0:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100db3:	a8 01                	test   $0x1,%al
f0100db5:	74 52                	je     f0100e09 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100db7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100dbc:	89 c1                	mov    %eax,%ecx
f0100dbe:	c1 e9 0c             	shr    $0xc,%ecx
f0100dc1:	3b 0d 88 7e 34 f0    	cmp    0xf0347e88,%ecx
f0100dc7:	73 25                	jae    f0100dee <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100dc9:	c1 ea 0c             	shr    $0xc,%edx
f0100dcc:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100dd2:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100dd9:	89 c2                	mov    %eax,%edx
f0100ddb:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100dde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100de3:	85 d2                	test   %edx,%edx
f0100de5:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100dea:	0f 44 c2             	cmove  %edx,%eax
f0100ded:	c3                   	ret    
{
f0100dee:	55                   	push   %ebp
f0100def:	89 e5                	mov    %esp,%ebp
f0100df1:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100df4:	50                   	push   %eax
f0100df5:	68 74 6f 10 f0       	push   $0xf0106f74
f0100dfa:	68 ab 03 00 00       	push   $0x3ab
f0100dff:	68 b5 80 10 f0       	push   $0xf01080b5
f0100e04:	e8 37 f2 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100e0e:	c3                   	ret    

f0100e0f <boot_alloc>:
{
f0100e0f:	55                   	push   %ebp
f0100e10:	89 e5                	mov    %esp,%ebp
f0100e12:	53                   	push   %ebx
f0100e13:	83 ec 04             	sub    $0x4,%esp
	if (!nextfree) {
f0100e16:	83 3d 38 72 34 f0 00 	cmpl   $0x0,0xf0347238
f0100e1d:	74 40                	je     f0100e5f <boot_alloc+0x50>
	if(!n)
f0100e1f:	85 c0                	test   %eax,%eax
f0100e21:	74 65                	je     f0100e88 <boot_alloc+0x79>
f0100e23:	89 c2                	mov    %eax,%edx
	if(((PADDR(nextfree)+n-1)/PGSIZE)+1 > npages){
f0100e25:	a1 38 72 34 f0       	mov    0xf0347238,%eax
	if ((uint32_t)kva < KERNBASE)
f0100e2a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e2f:	76 5e                	jbe    f0100e8f <boot_alloc+0x80>
f0100e31:	8d 8c 10 ff ff ff 0f 	lea    0xfffffff(%eax,%edx,1),%ecx
f0100e38:	c1 e9 0c             	shr    $0xc,%ecx
f0100e3b:	83 c1 01             	add    $0x1,%ecx
f0100e3e:	3b 0d 88 7e 34 f0    	cmp    0xf0347e88,%ecx
f0100e44:	77 5b                	ja     f0100ea1 <boot_alloc+0x92>
	nextfree += ((n + PGSIZE - 1)/PGSIZE)*PGSIZE;
f0100e46:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0100e4c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100e52:	01 c2                	add    %eax,%edx
f0100e54:	89 15 38 72 34 f0    	mov    %edx,0xf0347238
}
f0100e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100e5d:	c9                   	leave  
f0100e5e:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e5f:	b9 08 90 38 f0       	mov    $0xf0389008,%ecx
f0100e64:	ba 07 a0 38 f0       	mov    $0xf038a007,%edx
f0100e69:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if((uint32_t)end % PGSIZE == 0)
f0100e6f:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100e75:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
f0100e7b:	85 c9                	test   %ecx,%ecx
f0100e7d:	0f 44 d3             	cmove  %ebx,%edx
f0100e80:	89 15 38 72 34 f0    	mov    %edx,0xf0347238
f0100e86:	eb 97                	jmp    f0100e1f <boot_alloc+0x10>
		return nextfree;
f0100e88:	a1 38 72 34 f0       	mov    0xf0347238,%eax
f0100e8d:	eb cb                	jmp    f0100e5a <boot_alloc+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100e8f:	50                   	push   %eax
f0100e90:	68 98 6f 10 f0       	push   $0xf0106f98
f0100e95:	6a 72                	push   $0x72
f0100e97:	68 b5 80 10 f0       	push   $0xf01080b5
f0100e9c:	e8 9f f1 ff ff       	call   f0100040 <_panic>
		panic("in bool_alloc(), there is no enough memory to malloc\n");
f0100ea1:	83 ec 04             	sub    $0x4,%esp
f0100ea4:	68 fc 76 10 f0       	push   $0xf01076fc
f0100ea9:	6a 73                	push   $0x73
f0100eab:	68 b5 80 10 f0       	push   $0xf01080b5
f0100eb0:	e8 8b f1 ff ff       	call   f0100040 <_panic>

f0100eb5 <check_page_free_list>:
{
f0100eb5:	55                   	push   %ebp
f0100eb6:	89 e5                	mov    %esp,%ebp
f0100eb8:	57                   	push   %edi
f0100eb9:	56                   	push   %esi
f0100eba:	53                   	push   %ebx
f0100ebb:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ebe:	84 c0                	test   %al,%al
f0100ec0:	0f 85 77 02 00 00    	jne    f010113d <check_page_free_list+0x288>
	if (!page_free_list)
f0100ec6:	83 3d 40 72 34 f0 00 	cmpl   $0x0,0xf0347240
f0100ecd:	74 0a                	je     f0100ed9 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ecf:	be 00 04 00 00       	mov    $0x400,%esi
f0100ed4:	e9 bf 02 00 00       	jmp    f0101198 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100ed9:	83 ec 04             	sub    $0x4,%esp
f0100edc:	68 34 77 10 f0       	push   $0xf0107734
f0100ee1:	68 db 02 00 00       	push   $0x2db
f0100ee6:	68 b5 80 10 f0       	push   $0xf01080b5
f0100eeb:	e8 50 f1 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ef0:	50                   	push   %eax
f0100ef1:	68 74 6f 10 f0       	push   $0xf0106f74
f0100ef6:	6a 58                	push   $0x58
f0100ef8:	68 c1 80 10 f0       	push   $0xf01080c1
f0100efd:	e8 3e f1 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0100f02:	8b 1b                	mov    (%ebx),%ebx
f0100f04:	85 db                	test   %ebx,%ebx
f0100f06:	74 41                	je     f0100f49 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100f08:	89 d8                	mov    %ebx,%eax
f0100f0a:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f0100f10:	c1 f8 03             	sar    $0x3,%eax
f0100f13:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100f16:	89 c2                	mov    %eax,%edx
f0100f18:	c1 ea 16             	shr    $0x16,%edx
f0100f1b:	39 f2                	cmp    %esi,%edx
f0100f1d:	73 e3                	jae    f0100f02 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100f1f:	89 c2                	mov    %eax,%edx
f0100f21:	c1 ea 0c             	shr    $0xc,%edx
f0100f24:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f0100f2a:	73 c4                	jae    f0100ef0 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100f2c:	83 ec 04             	sub    $0x4,%esp
f0100f2f:	68 80 00 00 00       	push   $0x80
f0100f34:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100f39:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f3e:	50                   	push   %eax
f0100f3f:	e8 85 53 00 00       	call   f01062c9 <memset>
f0100f44:	83 c4 10             	add    $0x10,%esp
f0100f47:	eb b9                	jmp    f0100f02 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100f49:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f4e:	e8 bc fe ff ff       	call   f0100e0f <boot_alloc>
f0100f53:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f56:	8b 15 40 72 34 f0    	mov    0xf0347240,%edx
		assert(pp >= pages);
f0100f5c:	8b 0d 90 7e 34 f0    	mov    0xf0347e90,%ecx
		assert(pp < pages + npages);
f0100f62:	a1 88 7e 34 f0       	mov    0xf0347e88,%eax
f0100f67:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100f6a:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100f6d:	bf 00 00 00 00       	mov    $0x0,%edi
f0100f72:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f75:	e9 f9 00 00 00       	jmp    f0101073 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100f7a:	68 cf 80 10 f0       	push   $0xf01080cf
f0100f7f:	68 db 80 10 f0       	push   $0xf01080db
f0100f84:	68 f4 02 00 00       	push   $0x2f4
f0100f89:	68 b5 80 10 f0       	push   $0xf01080b5
f0100f8e:	e8 ad f0 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100f93:	68 f0 80 10 f0       	push   $0xf01080f0
f0100f98:	68 db 80 10 f0       	push   $0xf01080db
f0100f9d:	68 f5 02 00 00       	push   $0x2f5
f0100fa2:	68 b5 80 10 f0       	push   $0xf01080b5
f0100fa7:	e8 94 f0 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100fac:	68 58 77 10 f0       	push   $0xf0107758
f0100fb1:	68 db 80 10 f0       	push   $0xf01080db
f0100fb6:	68 f6 02 00 00       	push   $0x2f6
f0100fbb:	68 b5 80 10 f0       	push   $0xf01080b5
f0100fc0:	e8 7b f0 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100fc5:	68 04 81 10 f0       	push   $0xf0108104
f0100fca:	68 db 80 10 f0       	push   $0xf01080db
f0100fcf:	68 f9 02 00 00       	push   $0x2f9
f0100fd4:	68 b5 80 10 f0       	push   $0xf01080b5
f0100fd9:	e8 62 f0 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100fde:	68 15 81 10 f0       	push   $0xf0108115
f0100fe3:	68 db 80 10 f0       	push   $0xf01080db
f0100fe8:	68 fa 02 00 00       	push   $0x2fa
f0100fed:	68 b5 80 10 f0       	push   $0xf01080b5
f0100ff2:	e8 49 f0 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100ff7:	68 8c 77 10 f0       	push   $0xf010778c
f0100ffc:	68 db 80 10 f0       	push   $0xf01080db
f0101001:	68 fb 02 00 00       	push   $0x2fb
f0101006:	68 b5 80 10 f0       	push   $0xf01080b5
f010100b:	e8 30 f0 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101010:	68 2e 81 10 f0       	push   $0xf010812e
f0101015:	68 db 80 10 f0       	push   $0xf01080db
f010101a:	68 fc 02 00 00       	push   $0x2fc
f010101f:	68 b5 80 10 f0       	push   $0xf01080b5
f0101024:	e8 17 f0 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0101029:	89 c3                	mov    %eax,%ebx
f010102b:	c1 eb 0c             	shr    $0xc,%ebx
f010102e:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0101031:	76 0f                	jbe    f0101042 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0101033:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101038:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f010103b:	77 17                	ja     f0101054 <check_page_free_list+0x19f>
			++nfree_extmem;
f010103d:	83 c7 01             	add    $0x1,%edi
f0101040:	eb 2f                	jmp    f0101071 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101042:	50                   	push   %eax
f0101043:	68 74 6f 10 f0       	push   $0xf0106f74
f0101048:	6a 58                	push   $0x58
f010104a:	68 c1 80 10 f0       	push   $0xf01080c1
f010104f:	e8 ec ef ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101054:	68 b0 77 10 f0       	push   $0xf01077b0
f0101059:	68 db 80 10 f0       	push   $0xf01080db
f010105e:	68 fd 02 00 00       	push   $0x2fd
f0101063:	68 b5 80 10 f0       	push   $0xf01080b5
f0101068:	e8 d3 ef ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f010106d:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101071:	8b 12                	mov    (%edx),%edx
f0101073:	85 d2                	test   %edx,%edx
f0101075:	74 74                	je     f01010eb <check_page_free_list+0x236>
		assert(pp >= pages);
f0101077:	39 d1                	cmp    %edx,%ecx
f0101079:	0f 87 fb fe ff ff    	ja     f0100f7a <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f010107f:	39 d6                	cmp    %edx,%esi
f0101081:	0f 86 0c ff ff ff    	jbe    f0100f93 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101087:	89 d0                	mov    %edx,%eax
f0101089:	29 c8                	sub    %ecx,%eax
f010108b:	a8 07                	test   $0x7,%al
f010108d:	0f 85 19 ff ff ff    	jne    f0100fac <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0101093:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0101096:	c1 e0 0c             	shl    $0xc,%eax
f0101099:	0f 84 26 ff ff ff    	je     f0100fc5 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f010109f:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f01010a4:	0f 84 34 ff ff ff    	je     f0100fde <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f01010aa:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01010af:	0f 84 42 ff ff ff    	je     f0100ff7 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f01010b5:	3d 00 00 10 00       	cmp    $0x100000,%eax
f01010ba:	0f 84 50 ff ff ff    	je     f0101010 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01010c0:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01010c5:	0f 87 5e ff ff ff    	ja     f0101029 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f01010cb:	3d 00 70 00 00       	cmp    $0x7000,%eax
f01010d0:	75 9b                	jne    f010106d <check_page_free_list+0x1b8>
f01010d2:	68 48 81 10 f0       	push   $0xf0108148
f01010d7:	68 db 80 10 f0       	push   $0xf01080db
f01010dc:	68 ff 02 00 00       	push   $0x2ff
f01010e1:	68 b5 80 10 f0       	push   $0xf01080b5
f01010e6:	e8 55 ef ff ff       	call   f0100040 <_panic>
f01010eb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f01010ee:	85 db                	test   %ebx,%ebx
f01010f0:	7e 19                	jle    f010110b <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f01010f2:	85 ff                	test   %edi,%edi
f01010f4:	7e 2e                	jle    f0101124 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f01010f6:	83 ec 0c             	sub    $0xc,%esp
f01010f9:	68 f8 77 10 f0       	push   $0xf01077f8
f01010fe:	e8 80 2c 00 00       	call   f0103d83 <cprintf>
}
f0101103:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101106:	5b                   	pop    %ebx
f0101107:	5e                   	pop    %esi
f0101108:	5f                   	pop    %edi
f0101109:	5d                   	pop    %ebp
f010110a:	c3                   	ret    
	assert(nfree_basemem > 0);
f010110b:	68 65 81 10 f0       	push   $0xf0108165
f0101110:	68 db 80 10 f0       	push   $0xf01080db
f0101115:	68 06 03 00 00       	push   $0x306
f010111a:	68 b5 80 10 f0       	push   $0xf01080b5
f010111f:	e8 1c ef ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0101124:	68 77 81 10 f0       	push   $0xf0108177
f0101129:	68 db 80 10 f0       	push   $0xf01080db
f010112e:	68 07 03 00 00       	push   $0x307
f0101133:	68 b5 80 10 f0       	push   $0xf01080b5
f0101138:	e8 03 ef ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f010113d:	a1 40 72 34 f0       	mov    0xf0347240,%eax
f0101142:	85 c0                	test   %eax,%eax
f0101144:	0f 84 8f fd ff ff    	je     f0100ed9 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010114a:	8d 55 d8             	lea    -0x28(%ebp),%edx
f010114d:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101150:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101153:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101156:	89 c2                	mov    %eax,%edx
f0101158:	2b 15 90 7e 34 f0    	sub    0xf0347e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f010115e:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0101164:	0f 95 c2             	setne  %dl
f0101167:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f010116a:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f010116e:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0101170:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101174:	8b 00                	mov    (%eax),%eax
f0101176:	85 c0                	test   %eax,%eax
f0101178:	75 dc                	jne    f0101156 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010117d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101183:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101186:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101189:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f010118b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010118e:	a3 40 72 34 f0       	mov    %eax,0xf0347240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101193:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link){
f0101198:	8b 1d 40 72 34 f0    	mov    0xf0347240,%ebx
f010119e:	e9 61 fd ff ff       	jmp    f0100f04 <check_page_free_list+0x4f>

f01011a3 <page_init>:
{
f01011a3:	55                   	push   %ebp
f01011a4:	89 e5                	mov    %esp,%ebp
f01011a6:	53                   	push   %ebx
f01011a7:	83 ec 04             	sub    $0x4,%esp
	for (size_t i = 0; i < npages; i++) {
f01011aa:	bb 00 00 00 00       	mov    $0x0,%ebx
f01011af:	eb 4c                	jmp    f01011fd <page_init+0x5a>
		else if(i == MPENTRY_PADDR/PGSIZE){
f01011b1:	83 fb 07             	cmp    $0x7,%ebx
f01011b4:	74 32                	je     f01011e8 <page_init+0x45>
		else if(i < IOPHYSMEM/PGSIZE){ //[PGSIZE, npages_basemem * PGSIZE)
f01011b6:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f01011bc:	77 62                	ja     f0101220 <page_init+0x7d>
f01011be:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f01011c5:	89 c2                	mov    %eax,%edx
f01011c7:	03 15 90 7e 34 f0    	add    0xf0347e90,%edx
f01011cd:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f01011d3:	8b 0d 40 72 34 f0    	mov    0xf0347240,%ecx
f01011d9:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f01011db:	03 05 90 7e 34 f0    	add    0xf0347e90,%eax
f01011e1:	a3 40 72 34 f0       	mov    %eax,0xf0347240
f01011e6:	eb 12                	jmp    f01011fa <page_init+0x57>
			pages[i].pp_ref = 1;
f01011e8:	a1 90 7e 34 f0       	mov    0xf0347e90,%eax
f01011ed:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			pages[i].pp_link = NULL;
f01011f3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	for (size_t i = 0; i < npages; i++) {
f01011fa:	83 c3 01             	add    $0x1,%ebx
f01011fd:	39 1d 88 7e 34 f0    	cmp    %ebx,0xf0347e88
f0101203:	0f 86 94 00 00 00    	jbe    f010129d <page_init+0xfa>
		if(i == 0){ //real-mode IDT
f0101209:	85 db                	test   %ebx,%ebx
f010120b:	75 a4                	jne    f01011b1 <page_init+0xe>
			pages[i].pp_ref = 1;
f010120d:	a1 90 7e 34 f0       	mov    0xf0347e90,%eax
f0101212:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010121e:	eb da                	jmp    f01011fa <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f0101220:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0101226:	77 16                	ja     f010123e <page_init+0x9b>
			pages[i].pp_ref = 1;
f0101228:	a1 90 7e 34 f0       	mov    0xf0347e90,%eax
f010122d:	8d 04 d8             	lea    (%eax,%ebx,8),%eax
f0101230:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
			pages[i].pp_link = NULL;
f0101236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010123c:	eb bc                	jmp    f01011fa <page_init+0x57>
		else if(i < EXTPHYSMEM/PGSIZE || i < (PADDR((struct PageInfo*)boot_alloc(0)))/PGSIZE){ //[IOPHYSMEM, EXTPHYSMEM) & some other
f010123e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101243:	e8 c7 fb ff ff       	call   f0100e0f <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0101248:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010124d:	76 39                	jbe    f0101288 <page_init+0xe5>
	return (physaddr_t)kva - KERNBASE;
f010124f:	05 00 00 00 10       	add    $0x10000000,%eax
f0101254:	c1 e8 0c             	shr    $0xc,%eax
f0101257:	39 d8                	cmp    %ebx,%eax
f0101259:	77 cd                	ja     f0101228 <page_init+0x85>
f010125b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
			pages[i].pp_ref = 0;
f0101262:	89 c2                	mov    %eax,%edx
f0101264:	03 15 90 7e 34 f0    	add    0xf0347e90,%edx
f010126a:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			pages[i].pp_link = page_free_list;
f0101270:	8b 0d 40 72 34 f0    	mov    0xf0347240,%ecx
f0101276:	89 0a                	mov    %ecx,(%edx)
			page_free_list = &pages[i];
f0101278:	03 05 90 7e 34 f0    	add    0xf0347e90,%eax
f010127e:	a3 40 72 34 f0       	mov    %eax,0xf0347240
f0101283:	e9 72 ff ff ff       	jmp    f01011fa <page_init+0x57>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101288:	50                   	push   %eax
f0101289:	68 98 6f 10 f0       	push   $0xf0106f98
f010128e:	68 4d 01 00 00       	push   $0x14d
f0101293:	68 b5 80 10 f0       	push   $0xf01080b5
f0101298:	e8 a3 ed ff ff       	call   f0100040 <_panic>
}
f010129d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012a0:	c9                   	leave  
f01012a1:	c3                   	ret    

f01012a2 <page_alloc>:
{
f01012a2:	55                   	push   %ebp
f01012a3:	89 e5                	mov    %esp,%ebp
f01012a5:	53                   	push   %ebx
f01012a6:	83 ec 04             	sub    $0x4,%esp
	if(!page_free_list)
f01012a9:	8b 1d 40 72 34 f0    	mov    0xf0347240,%ebx
f01012af:	85 db                	test   %ebx,%ebx
f01012b1:	74 13                	je     f01012c6 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f01012b3:	8b 03                	mov    (%ebx),%eax
f01012b5:	a3 40 72 34 f0       	mov    %eax,0xf0347240
	result->pp_link = NULL;
f01012ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f01012c0:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01012c4:	75 07                	jne    f01012cd <page_alloc+0x2b>
}
f01012c6:	89 d8                	mov    %ebx,%eax
f01012c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012cb:	c9                   	leave  
f01012cc:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f01012cd:	89 d8                	mov    %ebx,%eax
f01012cf:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f01012d5:	c1 f8 03             	sar    $0x3,%eax
f01012d8:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01012db:	89 c2                	mov    %eax,%edx
f01012dd:	c1 ea 0c             	shr    $0xc,%edx
f01012e0:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f01012e6:	73 1a                	jae    f0101302 <page_alloc+0x60>
		memset(alloc_page, '\0', PGSIZE);
f01012e8:	83 ec 04             	sub    $0x4,%esp
f01012eb:	68 00 10 00 00       	push   $0x1000
f01012f0:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01012f2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01012f7:	50                   	push   %eax
f01012f8:	e8 cc 4f 00 00       	call   f01062c9 <memset>
f01012fd:	83 c4 10             	add    $0x10,%esp
f0101300:	eb c4                	jmp    f01012c6 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101302:	50                   	push   %eax
f0101303:	68 74 6f 10 f0       	push   $0xf0106f74
f0101308:	6a 58                	push   $0x58
f010130a:	68 c1 80 10 f0       	push   $0xf01080c1
f010130f:	e8 2c ed ff ff       	call   f0100040 <_panic>

f0101314 <page_free>:
{
f0101314:	55                   	push   %ebp
f0101315:	89 e5                	mov    %esp,%ebp
f0101317:	83 ec 08             	sub    $0x8,%esp
f010131a:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0 || pp->pp_link != NULL){
f010131d:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101322:	75 14                	jne    f0101338 <page_free+0x24>
f0101324:	83 38 00             	cmpl   $0x0,(%eax)
f0101327:	75 0f                	jne    f0101338 <page_free+0x24>
	pp->pp_link = page_free_list;
f0101329:	8b 15 40 72 34 f0    	mov    0xf0347240,%edx
f010132f:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101331:	a3 40 72 34 f0       	mov    %eax,0xf0347240
}
f0101336:	c9                   	leave  
f0101337:	c3                   	ret    
		panic("pp->pp_ref is nonzero or pp->pp_link is not NULL.");
f0101338:	83 ec 04             	sub    $0x4,%esp
f010133b:	68 1c 78 10 f0       	push   $0xf010781c
f0101340:	68 81 01 00 00       	push   $0x181
f0101345:	68 b5 80 10 f0       	push   $0xf01080b5
f010134a:	e8 f1 ec ff ff       	call   f0100040 <_panic>

f010134f <page_decref>:
{
f010134f:	55                   	push   %ebp
f0101350:	89 e5                	mov    %esp,%ebp
f0101352:	83 ec 08             	sub    $0x8,%esp
f0101355:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101358:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f010135c:	83 e8 01             	sub    $0x1,%eax
f010135f:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101363:	66 85 c0             	test   %ax,%ax
f0101366:	74 02                	je     f010136a <page_decref+0x1b>
}
f0101368:	c9                   	leave  
f0101369:	c3                   	ret    
		page_free(pp);
f010136a:	83 ec 0c             	sub    $0xc,%esp
f010136d:	52                   	push   %edx
f010136e:	e8 a1 ff ff ff       	call   f0101314 <page_free>
f0101373:	83 c4 10             	add    $0x10,%esp
}
f0101376:	eb f0                	jmp    f0101368 <page_decref+0x19>

f0101378 <pgdir_walk>:
{
f0101378:	55                   	push   %ebp
f0101379:	89 e5                	mov    %esp,%ebp
f010137b:	56                   	push   %esi
f010137c:	53                   	push   %ebx
f010137d:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *fir_level = &pgdir[PDX(va)];
f0101380:	89 f3                	mov    %esi,%ebx
f0101382:	c1 eb 16             	shr    $0x16,%ebx
f0101385:	c1 e3 02             	shl    $0x2,%ebx
f0101388:	03 5d 08             	add    0x8(%ebp),%ebx
	if(*fir_level==0 && create == false){
f010138b:	8b 03                	mov    (%ebx),%eax
f010138d:	89 c1                	mov    %eax,%ecx
f010138f:	0b 4d 10             	or     0x10(%ebp),%ecx
f0101392:	0f 84 a8 00 00 00    	je     f0101440 <pgdir_walk+0xc8>
	else if(*fir_level==0){
f0101398:	85 c0                	test   %eax,%eax
f010139a:	74 29                	je     f01013c5 <pgdir_walk+0x4d>
		sec_level = (pte_t *)(KADDR(PTE_ADDR(*fir_level)));
f010139c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01013a1:	89 c2                	mov    %eax,%edx
f01013a3:	c1 ea 0c             	shr    $0xc,%edx
f01013a6:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f01013ac:	73 7d                	jae    f010142b <pgdir_walk+0xb3>
		return &sec_level[PTX(va)];
f01013ae:	c1 ee 0a             	shr    $0xa,%esi
f01013b1:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01013b7:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f01013be:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01013c1:	5b                   	pop    %ebx
f01013c2:	5e                   	pop    %esi
f01013c3:	5d                   	pop    %ebp
f01013c4:	c3                   	ret    
		struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
f01013c5:	83 ec 0c             	sub    $0xc,%esp
f01013c8:	6a 01                	push   $0x1
f01013ca:	e8 d3 fe ff ff       	call   f01012a2 <page_alloc>
		if(new_page == NULL)
f01013cf:	83 c4 10             	add    $0x10,%esp
f01013d2:	85 c0                	test   %eax,%eax
f01013d4:	74 e8                	je     f01013be <pgdir_walk+0x46>
		new_page->pp_ref++;
f01013d6:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01013db:	89 c2                	mov    %eax,%edx
f01013dd:	2b 15 90 7e 34 f0    	sub    0xf0347e90,%edx
f01013e3:	c1 fa 03             	sar    $0x3,%edx
f01013e6:	c1 e2 0c             	shl    $0xc,%edx
		*fir_level = page2pa(new_page) | PTE_P | PTE_U | PTE_W;
f01013e9:	83 ca 07             	or     $0x7,%edx
f01013ec:	89 13                	mov    %edx,(%ebx)
f01013ee:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f01013f4:	c1 f8 03             	sar    $0x3,%eax
f01013f7:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01013fa:	89 c2                	mov    %eax,%edx
f01013fc:	c1 ea 0c             	shr    $0xc,%edx
f01013ff:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f0101405:	73 12                	jae    f0101419 <pgdir_walk+0xa1>
		return &sec_level[PTX(va)];
f0101407:	c1 ee 0a             	shr    $0xa,%esi
f010140a:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101410:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f0101417:	eb a5                	jmp    f01013be <pgdir_walk+0x46>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101419:	50                   	push   %eax
f010141a:	68 74 6f 10 f0       	push   $0xf0106f74
f010141f:	6a 58                	push   $0x58
f0101421:	68 c1 80 10 f0       	push   $0xf01080c1
f0101426:	e8 15 ec ff ff       	call   f0100040 <_panic>
f010142b:	50                   	push   %eax
f010142c:	68 74 6f 10 f0       	push   $0xf0106f74
f0101431:	68 bb 01 00 00       	push   $0x1bb
f0101436:	68 b5 80 10 f0       	push   $0xf01080b5
f010143b:	e8 00 ec ff ff       	call   f0100040 <_panic>
		return NULL;
f0101440:	b8 00 00 00 00       	mov    $0x0,%eax
f0101445:	e9 74 ff ff ff       	jmp    f01013be <pgdir_walk+0x46>

f010144a <boot_map_region>:
{
f010144a:	55                   	push   %ebp
f010144b:	89 e5                	mov    %esp,%ebp
f010144d:	57                   	push   %edi
f010144e:	56                   	push   %esi
f010144f:	53                   	push   %ebx
f0101450:	83 ec 1c             	sub    $0x1c,%esp
f0101453:	89 c7                	mov    %eax,%edi
f0101455:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(va%PGSIZE==0);
f0101458:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010145e:	75 4b                	jne    f01014ab <boot_map_region+0x61>
	assert(pa%PGSIZE==0);
f0101460:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0101465:	75 5d                	jne    f01014c4 <boot_map_region+0x7a>
f0101467:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010146d:	01 c1                	add    %eax,%ecx
f010146f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0101472:	89 c3                	mov    %eax,%ebx
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f0101474:	89 d6                	mov    %edx,%esi
f0101476:	29 c6                	sub    %eax,%esi
	for(int i = 0; i < size/PGSIZE; i++){
f0101478:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010147b:	74 79                	je     f01014f6 <boot_map_region+0xac>
		pte_t *the_pte = pgdir_walk(pgdir, (void *)va, 1);
f010147d:	83 ec 04             	sub    $0x4,%esp
f0101480:	6a 01                	push   $0x1
f0101482:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f0101485:	50                   	push   %eax
f0101486:	57                   	push   %edi
f0101487:	e8 ec fe ff ff       	call   f0101378 <pgdir_walk>
		if(the_pte==NULL)
f010148c:	83 c4 10             	add    $0x10,%esp
f010148f:	85 c0                	test   %eax,%eax
f0101491:	74 4a                	je     f01014dd <boot_map_region+0x93>
		*the_pte = PTE_ADDR(pa) | perm | PTE_P;
f0101493:	89 da                	mov    %ebx,%edx
f0101495:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010149b:	0b 55 0c             	or     0xc(%ebp),%edx
f010149e:	83 ca 01             	or     $0x1,%edx
f01014a1:	89 10                	mov    %edx,(%eax)
		pa+=PGSIZE;
f01014a3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01014a9:	eb cd                	jmp    f0101478 <boot_map_region+0x2e>
	assert(va%PGSIZE==0);
f01014ab:	68 88 81 10 f0       	push   $0xf0108188
f01014b0:	68 db 80 10 f0       	push   $0xf01080db
f01014b5:	68 d0 01 00 00       	push   $0x1d0
f01014ba:	68 b5 80 10 f0       	push   $0xf01080b5
f01014bf:	e8 7c eb ff ff       	call   f0100040 <_panic>
	assert(pa%PGSIZE==0);
f01014c4:	68 95 81 10 f0       	push   $0xf0108195
f01014c9:	68 db 80 10 f0       	push   $0xf01080db
f01014ce:	68 d1 01 00 00       	push   $0x1d1
f01014d3:	68 b5 80 10 f0       	push   $0xf01080b5
f01014d8:	e8 63 eb ff ff       	call   f0100040 <_panic>
			panic("%s error\n", __FUNCTION__);
f01014dd:	68 14 84 10 f0       	push   $0xf0108414
f01014e2:	68 a2 81 10 f0       	push   $0xf01081a2
f01014e7:	68 d5 01 00 00       	push   $0x1d5
f01014ec:	68 b5 80 10 f0       	push   $0xf01080b5
f01014f1:	e8 4a eb ff ff       	call   f0100040 <_panic>
}
f01014f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01014f9:	5b                   	pop    %ebx
f01014fa:	5e                   	pop    %esi
f01014fb:	5f                   	pop    %edi
f01014fc:	5d                   	pop    %ebp
f01014fd:	c3                   	ret    

f01014fe <page_lookup>:
{
f01014fe:	55                   	push   %ebp
f01014ff:	89 e5                	mov    %esp,%ebp
f0101501:	53                   	push   %ebx
f0101502:	83 ec 08             	sub    $0x8,%esp
f0101505:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *look_mapping = pgdir_walk(pgdir, va, 0);
f0101508:	6a 00                	push   $0x0
f010150a:	ff 75 0c             	pushl  0xc(%ebp)
f010150d:	ff 75 08             	pushl  0x8(%ebp)
f0101510:	e8 63 fe ff ff       	call   f0101378 <pgdir_walk>
	if(look_mapping == NULL)
f0101515:	83 c4 10             	add    $0x10,%esp
f0101518:	85 c0                	test   %eax,%eax
f010151a:	74 27                	je     f0101543 <page_lookup+0x45>
	if(*look_mapping==0)
f010151c:	8b 10                	mov    (%eax),%edx
f010151e:	85 d2                	test   %edx,%edx
f0101520:	74 3a                	je     f010155c <page_lookup+0x5e>
	if(pte_store!=NULL && (*look_mapping&PTE_P))
f0101522:	85 db                	test   %ebx,%ebx
f0101524:	74 07                	je     f010152d <page_lookup+0x2f>
f0101526:	f6 c2 01             	test   $0x1,%dl
f0101529:	74 02                	je     f010152d <page_lookup+0x2f>
		*pte_store = look_mapping;
f010152b:	89 03                	mov    %eax,(%ebx)
f010152d:	8b 00                	mov    (%eax),%eax
f010152f:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101532:	39 05 88 7e 34 f0    	cmp    %eax,0xf0347e88
f0101538:	76 0e                	jbe    f0101548 <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010153a:	8b 15 90 7e 34 f0    	mov    0xf0347e90,%edx
f0101540:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101546:	c9                   	leave  
f0101547:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101548:	83 ec 04             	sub    $0x4,%esp
f010154b:	68 50 78 10 f0       	push   $0xf0107850
f0101550:	6a 51                	push   $0x51
f0101552:	68 c1 80 10 f0       	push   $0xf01080c1
f0101557:	e8 e4 ea ff ff       	call   f0100040 <_panic>
		return NULL;
f010155c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101561:	eb e0                	jmp    f0101543 <page_lookup+0x45>

f0101563 <tlb_invalidate>:
{
f0101563:	55                   	push   %ebp
f0101564:	89 e5                	mov    %esp,%ebp
f0101566:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101569:	e8 5c 53 00 00       	call   f01068ca <cpunum>
f010156e:	6b c0 74             	imul   $0x74,%eax,%eax
f0101571:	83 b8 28 80 34 f0 00 	cmpl   $0x0,-0xfcb7fd8(%eax)
f0101578:	74 16                	je     f0101590 <tlb_invalidate+0x2d>
f010157a:	e8 4b 53 00 00       	call   f01068ca <cpunum>
f010157f:	6b c0 74             	imul   $0x74,%eax,%eax
f0101582:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0101588:	8b 55 08             	mov    0x8(%ebp),%edx
f010158b:	39 50 60             	cmp    %edx,0x60(%eax)
f010158e:	75 06                	jne    f0101596 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101590:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101593:	0f 01 38             	invlpg (%eax)
}
f0101596:	c9                   	leave  
f0101597:	c3                   	ret    

f0101598 <page_remove>:
{
f0101598:	55                   	push   %ebp
f0101599:	89 e5                	mov    %esp,%ebp
f010159b:	56                   	push   %esi
f010159c:	53                   	push   %ebx
f010159d:	83 ec 14             	sub    $0x14,%esp
f01015a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01015a3:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *the_page = page_lookup(pgdir, va, &pg_store);
f01015a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01015a9:	50                   	push   %eax
f01015aa:	56                   	push   %esi
f01015ab:	53                   	push   %ebx
f01015ac:	e8 4d ff ff ff       	call   f01014fe <page_lookup>
	if(!the_page)
f01015b1:	83 c4 10             	add    $0x10,%esp
f01015b4:	85 c0                	test   %eax,%eax
f01015b6:	74 1f                	je     f01015d7 <page_remove+0x3f>
	page_decref(the_page);
f01015b8:	83 ec 0c             	sub    $0xc,%esp
f01015bb:	50                   	push   %eax
f01015bc:	e8 8e fd ff ff       	call   f010134f <page_decref>
	*pg_store = 0;
f01015c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01015c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va);
f01015ca:	83 c4 08             	add    $0x8,%esp
f01015cd:	56                   	push   %esi
f01015ce:	53                   	push   %ebx
f01015cf:	e8 8f ff ff ff       	call   f0101563 <tlb_invalidate>
f01015d4:	83 c4 10             	add    $0x10,%esp
}
f01015d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01015da:	5b                   	pop    %ebx
f01015db:	5e                   	pop    %esi
f01015dc:	5d                   	pop    %ebp
f01015dd:	c3                   	ret    

f01015de <page_insert>:
{
f01015de:	55                   	push   %ebp
f01015df:	89 e5                	mov    %esp,%ebp
f01015e1:	57                   	push   %edi
f01015e2:	56                   	push   %esi
f01015e3:	53                   	push   %ebx
f01015e4:	83 ec 10             	sub    $0x10,%esp
f01015e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *the_pte = pgdir_walk(pgdir, va, 1);
f01015ea:	6a 01                	push   $0x1
f01015ec:	ff 75 10             	pushl  0x10(%ebp)
f01015ef:	ff 75 08             	pushl  0x8(%ebp)
f01015f2:	e8 81 fd ff ff       	call   f0101378 <pgdir_walk>
	if(the_pte == NULL){
f01015f7:	83 c4 10             	add    $0x10,%esp
f01015fa:	85 c0                	test   %eax,%eax
f01015fc:	0f 84 b7 00 00 00    	je     f01016b9 <page_insert+0xdb>
f0101602:	89 c6                	mov    %eax,%esi
		if(KADDR(PTE_ADDR(*the_pte)) == page2kva(pp)){
f0101604:	8b 10                	mov    (%eax),%edx
f0101606:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f010160c:	8b 0d 88 7e 34 f0    	mov    0xf0347e88,%ecx
f0101612:	89 d0                	mov    %edx,%eax
f0101614:	c1 e8 0c             	shr    $0xc,%eax
f0101617:	39 c1                	cmp    %eax,%ecx
f0101619:	76 5f                	jbe    f010167a <page_insert+0x9c>
	return (void *)(pa + KERNBASE);
f010161b:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	return (pp - pages) << PGSHIFT;
f0101621:	89 d8                	mov    %ebx,%eax
f0101623:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f0101629:	c1 f8 03             	sar    $0x3,%eax
f010162c:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010162f:	89 c7                	mov    %eax,%edi
f0101631:	c1 ef 0c             	shr    $0xc,%edi
f0101634:	39 f9                	cmp    %edi,%ecx
f0101636:	76 57                	jbe    f010168f <page_insert+0xb1>
	return (void *)(pa + KERNBASE);
f0101638:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010163d:	39 c2                	cmp    %eax,%edx
f010163f:	74 60                	je     f01016a1 <page_insert+0xc3>
			page_remove(pgdir, va);
f0101641:	83 ec 08             	sub    $0x8,%esp
f0101644:	ff 75 10             	pushl  0x10(%ebp)
f0101647:	ff 75 08             	pushl  0x8(%ebp)
f010164a:	e8 49 ff ff ff       	call   f0101598 <page_remove>
f010164f:	83 c4 10             	add    $0x10,%esp
	return (pp - pages) << PGSHIFT;
f0101652:	89 d8                	mov    %ebx,%eax
f0101654:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f010165a:	c1 f8 03             	sar    $0x3,%eax
f010165d:	c1 e0 0c             	shl    $0xc,%eax
	*the_pte = page2pa(pp) | perm | PTE_P;
f0101660:	0b 45 14             	or     0x14(%ebp),%eax
f0101663:	83 c8 01             	or     $0x1,%eax
f0101666:	89 06                	mov    %eax,(%esi)
	pp->pp_ref++;
f0101668:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	return 0;
f010166d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101672:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101675:	5b                   	pop    %ebx
f0101676:	5e                   	pop    %esi
f0101677:	5f                   	pop    %edi
f0101678:	5d                   	pop    %ebp
f0101679:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010167a:	52                   	push   %edx
f010167b:	68 74 6f 10 f0       	push   $0xf0106f74
f0101680:	68 17 02 00 00       	push   $0x217
f0101685:	68 b5 80 10 f0       	push   $0xf01080b5
f010168a:	e8 b1 e9 ff ff       	call   f0100040 <_panic>
f010168f:	50                   	push   %eax
f0101690:	68 74 6f 10 f0       	push   $0xf0106f74
f0101695:	6a 58                	push   $0x58
f0101697:	68 c1 80 10 f0       	push   $0xf01080c1
f010169c:	e8 9f e9 ff ff       	call   f0100040 <_panic>
			tlb_invalidate(pgdir, va);
f01016a1:	83 ec 08             	sub    $0x8,%esp
f01016a4:	ff 75 10             	pushl  0x10(%ebp)
f01016a7:	ff 75 08             	pushl  0x8(%ebp)
f01016aa:	e8 b4 fe ff ff       	call   f0101563 <tlb_invalidate>
			pp->pp_ref--;
f01016af:	66 83 6b 04 01       	subw   $0x1,0x4(%ebx)
f01016b4:	83 c4 10             	add    $0x10,%esp
f01016b7:	eb 99                	jmp    f0101652 <page_insert+0x74>
		return -E_NO_MEM;
f01016b9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01016be:	eb b2                	jmp    f0101672 <page_insert+0x94>

f01016c0 <mmio_map_region>:
{
f01016c0:	55                   	push   %ebp
f01016c1:	89 e5                	mov    %esp,%ebp
f01016c3:	56                   	push   %esi
f01016c4:	53                   	push   %ebx
	size = ROUNDUP(size, PGSIZE);
f01016c5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016c8:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f01016ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if((base + size) > MMIOLIM){
f01016d4:	8b 35 04 53 12 f0    	mov    0xf0125304,%esi
f01016da:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f01016dd:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f01016e2:	77 25                	ja     f0101709 <mmio_map_region+0x49>
	boot_map_region(kern_pgdir, base, size, pa, PTE_PCD|PTE_PWT|PTE_W);
f01016e4:	83 ec 08             	sub    $0x8,%esp
f01016e7:	6a 1a                	push   $0x1a
f01016e9:	ff 75 08             	pushl  0x8(%ebp)
f01016ec:	89 d9                	mov    %ebx,%ecx
f01016ee:	89 f2                	mov    %esi,%edx
f01016f0:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f01016f5:	e8 50 fd ff ff       	call   f010144a <boot_map_region>
	base += size;
f01016fa:	01 1d 04 53 12 f0    	add    %ebx,0xf0125304
}
f0101700:	89 f0                	mov    %esi,%eax
f0101702:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101705:	5b                   	pop    %ebx
f0101706:	5e                   	pop    %esi
f0101707:	5d                   	pop    %ebp
f0101708:	c3                   	ret    
		panic("overflow MMIOLIM\n");
f0101709:	83 ec 04             	sub    $0x4,%esp
f010170c:	68 ac 81 10 f0       	push   $0xf01081ac
f0101711:	68 88 02 00 00       	push   $0x288
f0101716:	68 b5 80 10 f0       	push   $0xf01080b5
f010171b:	e8 20 e9 ff ff       	call   f0100040 <_panic>

f0101720 <mem_init>:
{
f0101720:	55                   	push   %ebp
f0101721:	89 e5                	mov    %esp,%ebp
f0101723:	57                   	push   %edi
f0101724:	56                   	push   %esi
f0101725:	53                   	push   %ebx
f0101726:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f0101729:	b8 15 00 00 00       	mov    $0x15,%eax
f010172e:	e8 4f f6 ff ff       	call   f0100d82 <nvram_read>
f0101733:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101735:	b8 17 00 00 00       	mov    $0x17,%eax
f010173a:	e8 43 f6 ff ff       	call   f0100d82 <nvram_read>
f010173f:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101741:	b8 34 00 00 00       	mov    $0x34,%eax
f0101746:	e8 37 f6 ff ff       	call   f0100d82 <nvram_read>
	if (ext16mem)
f010174b:	c1 e0 06             	shl    $0x6,%eax
f010174e:	0f 84 e5 00 00 00    	je     f0101839 <mem_init+0x119>
		totalmem = 16 * 1024 + ext16mem;
f0101754:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f0101759:	89 c2                	mov    %eax,%edx
f010175b:	c1 ea 02             	shr    $0x2,%edx
f010175e:	89 15 88 7e 34 f0    	mov    %edx,0xf0347e88
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101764:	89 c2                	mov    %eax,%edx
f0101766:	29 da                	sub    %ebx,%edx
f0101768:	52                   	push   %edx
f0101769:	53                   	push   %ebx
f010176a:	50                   	push   %eax
f010176b:	68 70 78 10 f0       	push   $0xf0107870
f0101770:	e8 0e 26 00 00       	call   f0103d83 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101775:	b8 00 10 00 00       	mov    $0x1000,%eax
f010177a:	e8 90 f6 ff ff       	call   f0100e0f <boot_alloc>
f010177f:	a3 8c 7e 34 f0       	mov    %eax,0xf0347e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101784:	83 c4 0c             	add    $0xc,%esp
f0101787:	68 00 10 00 00       	push   $0x1000
f010178c:	6a 00                	push   $0x0
f010178e:	50                   	push   %eax
f010178f:	e8 35 4b 00 00       	call   f01062c9 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101794:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101799:	83 c4 10             	add    $0x10,%esp
f010179c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01017a1:	0f 86 a2 00 00 00    	jbe    f0101849 <mem_init+0x129>
	return (physaddr_t)kva - KERNBASE;
f01017a7:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01017ad:	83 ca 05             	or     $0x5,%edx
f01017b0:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));	//total size: 0x40000
f01017b6:	a1 88 7e 34 f0       	mov    0xf0347e88,%eax
f01017bb:	c1 e0 03             	shl    $0x3,%eax
f01017be:	e8 4c f6 ff ff       	call   f0100e0f <boot_alloc>
f01017c3:	a3 90 7e 34 f0       	mov    %eax,0xf0347e90
	memset(pages, 0, ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE));
f01017c8:	83 ec 04             	sub    $0x4,%esp
f01017cb:	8b 15 88 7e 34 f0    	mov    0xf0347e88,%edx
f01017d1:	8d 14 d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edx
f01017d8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01017de:	52                   	push   %edx
f01017df:	6a 00                	push   $0x0
f01017e1:	50                   	push   %eax
f01017e2:	e8 e2 4a 00 00       	call   f01062c9 <memset>
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f01017e7:	b8 00 00 02 00       	mov    $0x20000,%eax
f01017ec:	e8 1e f6 ff ff       	call   f0100e0f <boot_alloc>
f01017f1:	a3 44 72 34 f0       	mov    %eax,0xf0347244
	memset(envs, 0, ROUNDUP(NENV * sizeof(struct Env), PGSIZE));
f01017f6:	83 c4 0c             	add    $0xc,%esp
f01017f9:	68 00 00 02 00       	push   $0x20000
f01017fe:	6a 00                	push   $0x0
f0101800:	50                   	push   %eax
f0101801:	e8 c3 4a 00 00       	call   f01062c9 <memset>
	page_init();
f0101806:	e8 98 f9 ff ff       	call   f01011a3 <page_init>
	check_page_free_list(1);
f010180b:	b8 01 00 00 00       	mov    $0x1,%eax
f0101810:	e8 a0 f6 ff ff       	call   f0100eb5 <check_page_free_list>
	if (!pages)
f0101815:	83 c4 10             	add    $0x10,%esp
f0101818:	83 3d 90 7e 34 f0 00 	cmpl   $0x0,0xf0347e90
f010181f:	74 3d                	je     f010185e <mem_init+0x13e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101821:	a1 40 72 34 f0       	mov    0xf0347240,%eax
f0101826:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010182d:	85 c0                	test   %eax,%eax
f010182f:	74 44                	je     f0101875 <mem_init+0x155>
		++nfree;
f0101831:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101835:	8b 00                	mov    (%eax),%eax
f0101837:	eb f4                	jmp    f010182d <mem_init+0x10d>
		totalmem = 1 * 1024 + extmem;
f0101839:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010183f:	85 f6                	test   %esi,%esi
f0101841:	0f 44 c3             	cmove  %ebx,%eax
f0101844:	e9 10 ff ff ff       	jmp    f0101759 <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101849:	50                   	push   %eax
f010184a:	68 98 6f 10 f0       	push   $0xf0106f98
f010184f:	68 9a 00 00 00       	push   $0x9a
f0101854:	68 b5 80 10 f0       	push   $0xf01080b5
f0101859:	e8 e2 e7 ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f010185e:	83 ec 04             	sub    $0x4,%esp
f0101861:	68 be 81 10 f0       	push   $0xf01081be
f0101866:	68 1a 03 00 00       	push   $0x31a
f010186b:	68 b5 80 10 f0       	push   $0xf01080b5
f0101870:	e8 cb e7 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101875:	83 ec 0c             	sub    $0xc,%esp
f0101878:	6a 00                	push   $0x0
f010187a:	e8 23 fa ff ff       	call   f01012a2 <page_alloc>
f010187f:	89 c3                	mov    %eax,%ebx
f0101881:	83 c4 10             	add    $0x10,%esp
f0101884:	85 c0                	test   %eax,%eax
f0101886:	0f 84 00 02 00 00    	je     f0101a8c <mem_init+0x36c>
	assert((pp1 = page_alloc(0)));
f010188c:	83 ec 0c             	sub    $0xc,%esp
f010188f:	6a 00                	push   $0x0
f0101891:	e8 0c fa ff ff       	call   f01012a2 <page_alloc>
f0101896:	89 c6                	mov    %eax,%esi
f0101898:	83 c4 10             	add    $0x10,%esp
f010189b:	85 c0                	test   %eax,%eax
f010189d:	0f 84 02 02 00 00    	je     f0101aa5 <mem_init+0x385>
	assert((pp2 = page_alloc(0)));
f01018a3:	83 ec 0c             	sub    $0xc,%esp
f01018a6:	6a 00                	push   $0x0
f01018a8:	e8 f5 f9 ff ff       	call   f01012a2 <page_alloc>
f01018ad:	89 c7                	mov    %eax,%edi
f01018af:	83 c4 10             	add    $0x10,%esp
f01018b2:	85 c0                	test   %eax,%eax
f01018b4:	0f 84 04 02 00 00    	je     f0101abe <mem_init+0x39e>
	assert(pp1 && pp1 != pp0);
f01018ba:	39 f3                	cmp    %esi,%ebx
f01018bc:	0f 84 15 02 00 00    	je     f0101ad7 <mem_init+0x3b7>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018c2:	39 c3                	cmp    %eax,%ebx
f01018c4:	0f 84 26 02 00 00    	je     f0101af0 <mem_init+0x3d0>
f01018ca:	39 c6                	cmp    %eax,%esi
f01018cc:	0f 84 1e 02 00 00    	je     f0101af0 <mem_init+0x3d0>
	return (pp - pages) << PGSHIFT;
f01018d2:	8b 0d 90 7e 34 f0    	mov    0xf0347e90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f01018d8:	8b 15 88 7e 34 f0    	mov    0xf0347e88,%edx
f01018de:	c1 e2 0c             	shl    $0xc,%edx
f01018e1:	89 d8                	mov    %ebx,%eax
f01018e3:	29 c8                	sub    %ecx,%eax
f01018e5:	c1 f8 03             	sar    $0x3,%eax
f01018e8:	c1 e0 0c             	shl    $0xc,%eax
f01018eb:	39 d0                	cmp    %edx,%eax
f01018ed:	0f 83 16 02 00 00    	jae    f0101b09 <mem_init+0x3e9>
f01018f3:	89 f0                	mov    %esi,%eax
f01018f5:	29 c8                	sub    %ecx,%eax
f01018f7:	c1 f8 03             	sar    $0x3,%eax
f01018fa:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f01018fd:	39 c2                	cmp    %eax,%edx
f01018ff:	0f 86 1d 02 00 00    	jbe    f0101b22 <mem_init+0x402>
f0101905:	89 f8                	mov    %edi,%eax
f0101907:	29 c8                	sub    %ecx,%eax
f0101909:	c1 f8 03             	sar    $0x3,%eax
f010190c:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f010190f:	39 c2                	cmp    %eax,%edx
f0101911:	0f 86 24 02 00 00    	jbe    f0101b3b <mem_init+0x41b>
	fl = page_free_list;
f0101917:	a1 40 72 34 f0       	mov    0xf0347240,%eax
f010191c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f010191f:	c7 05 40 72 34 f0 00 	movl   $0x0,0xf0347240
f0101926:	00 00 00 
	assert(!page_alloc(0));
f0101929:	83 ec 0c             	sub    $0xc,%esp
f010192c:	6a 00                	push   $0x0
f010192e:	e8 6f f9 ff ff       	call   f01012a2 <page_alloc>
f0101933:	83 c4 10             	add    $0x10,%esp
f0101936:	85 c0                	test   %eax,%eax
f0101938:	0f 85 16 02 00 00    	jne    f0101b54 <mem_init+0x434>
	page_free(pp0);
f010193e:	83 ec 0c             	sub    $0xc,%esp
f0101941:	53                   	push   %ebx
f0101942:	e8 cd f9 ff ff       	call   f0101314 <page_free>
	page_free(pp1);
f0101947:	89 34 24             	mov    %esi,(%esp)
f010194a:	e8 c5 f9 ff ff       	call   f0101314 <page_free>
	page_free(pp2);
f010194f:	89 3c 24             	mov    %edi,(%esp)
f0101952:	e8 bd f9 ff ff       	call   f0101314 <page_free>
	assert((pp0 = page_alloc(0)));
f0101957:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010195e:	e8 3f f9 ff ff       	call   f01012a2 <page_alloc>
f0101963:	89 c3                	mov    %eax,%ebx
f0101965:	83 c4 10             	add    $0x10,%esp
f0101968:	85 c0                	test   %eax,%eax
f010196a:	0f 84 fd 01 00 00    	je     f0101b6d <mem_init+0x44d>
	assert((pp1 = page_alloc(0)));
f0101970:	83 ec 0c             	sub    $0xc,%esp
f0101973:	6a 00                	push   $0x0
f0101975:	e8 28 f9 ff ff       	call   f01012a2 <page_alloc>
f010197a:	89 c6                	mov    %eax,%esi
f010197c:	83 c4 10             	add    $0x10,%esp
f010197f:	85 c0                	test   %eax,%eax
f0101981:	0f 84 ff 01 00 00    	je     f0101b86 <mem_init+0x466>
	assert((pp2 = page_alloc(0)));
f0101987:	83 ec 0c             	sub    $0xc,%esp
f010198a:	6a 00                	push   $0x0
f010198c:	e8 11 f9 ff ff       	call   f01012a2 <page_alloc>
f0101991:	89 c7                	mov    %eax,%edi
f0101993:	83 c4 10             	add    $0x10,%esp
f0101996:	85 c0                	test   %eax,%eax
f0101998:	0f 84 01 02 00 00    	je     f0101b9f <mem_init+0x47f>
	assert(pp1 && pp1 != pp0);
f010199e:	39 f3                	cmp    %esi,%ebx
f01019a0:	0f 84 12 02 00 00    	je     f0101bb8 <mem_init+0x498>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01019a6:	39 c6                	cmp    %eax,%esi
f01019a8:	0f 84 23 02 00 00    	je     f0101bd1 <mem_init+0x4b1>
f01019ae:	39 c3                	cmp    %eax,%ebx
f01019b0:	0f 84 1b 02 00 00    	je     f0101bd1 <mem_init+0x4b1>
	assert(!page_alloc(0));
f01019b6:	83 ec 0c             	sub    $0xc,%esp
f01019b9:	6a 00                	push   $0x0
f01019bb:	e8 e2 f8 ff ff       	call   f01012a2 <page_alloc>
f01019c0:	83 c4 10             	add    $0x10,%esp
f01019c3:	85 c0                	test   %eax,%eax
f01019c5:	0f 85 1f 02 00 00    	jne    f0101bea <mem_init+0x4ca>
f01019cb:	89 d8                	mov    %ebx,%eax
f01019cd:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f01019d3:	c1 f8 03             	sar    $0x3,%eax
f01019d6:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01019d9:	89 c2                	mov    %eax,%edx
f01019db:	c1 ea 0c             	shr    $0xc,%edx
f01019de:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f01019e4:	0f 83 19 02 00 00    	jae    f0101c03 <mem_init+0x4e3>
	memset(page2kva(pp0), 1, PGSIZE);
f01019ea:	83 ec 04             	sub    $0x4,%esp
f01019ed:	68 00 10 00 00       	push   $0x1000
f01019f2:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01019f4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01019f9:	50                   	push   %eax
f01019fa:	e8 ca 48 00 00       	call   f01062c9 <memset>
	page_free(pp0);
f01019ff:	89 1c 24             	mov    %ebx,(%esp)
f0101a02:	e8 0d f9 ff ff       	call   f0101314 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101a07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101a0e:	e8 8f f8 ff ff       	call   f01012a2 <page_alloc>
f0101a13:	83 c4 10             	add    $0x10,%esp
f0101a16:	85 c0                	test   %eax,%eax
f0101a18:	0f 84 f7 01 00 00    	je     f0101c15 <mem_init+0x4f5>
	assert(pp && pp0 == pp);
f0101a1e:	39 c3                	cmp    %eax,%ebx
f0101a20:	0f 85 08 02 00 00    	jne    f0101c2e <mem_init+0x50e>
	return (pp - pages) << PGSHIFT;
f0101a26:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f0101a2c:	c1 f8 03             	sar    $0x3,%eax
f0101a2f:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101a32:	89 c2                	mov    %eax,%edx
f0101a34:	c1 ea 0c             	shr    $0xc,%edx
f0101a37:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f0101a3d:	0f 83 04 02 00 00    	jae    f0101c47 <mem_init+0x527>
	return (void *)(pa + KERNBASE);
f0101a43:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101a49:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f0101a4e:	80 3a 00             	cmpb   $0x0,(%edx)
f0101a51:	0f 85 02 02 00 00    	jne    f0101c59 <mem_init+0x539>
f0101a57:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0101a5a:	39 c2                	cmp    %eax,%edx
f0101a5c:	75 f0                	jne    f0101a4e <mem_init+0x32e>
	page_free_list = fl;
f0101a5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101a61:	a3 40 72 34 f0       	mov    %eax,0xf0347240
	page_free(pp0);
f0101a66:	83 ec 0c             	sub    $0xc,%esp
f0101a69:	53                   	push   %ebx
f0101a6a:	e8 a5 f8 ff ff       	call   f0101314 <page_free>
	page_free(pp1);
f0101a6f:	89 34 24             	mov    %esi,(%esp)
f0101a72:	e8 9d f8 ff ff       	call   f0101314 <page_free>
	page_free(pp2);
f0101a77:	89 3c 24             	mov    %edi,(%esp)
f0101a7a:	e8 95 f8 ff ff       	call   f0101314 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101a7f:	a1 40 72 34 f0       	mov    0xf0347240,%eax
f0101a84:	83 c4 10             	add    $0x10,%esp
f0101a87:	e9 ec 01 00 00       	jmp    f0101c78 <mem_init+0x558>
	assert((pp0 = page_alloc(0)));
f0101a8c:	68 d9 81 10 f0       	push   $0xf01081d9
f0101a91:	68 db 80 10 f0       	push   $0xf01080db
f0101a96:	68 22 03 00 00       	push   $0x322
f0101a9b:	68 b5 80 10 f0       	push   $0xf01080b5
f0101aa0:	e8 9b e5 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101aa5:	68 ef 81 10 f0       	push   $0xf01081ef
f0101aaa:	68 db 80 10 f0       	push   $0xf01080db
f0101aaf:	68 23 03 00 00       	push   $0x323
f0101ab4:	68 b5 80 10 f0       	push   $0xf01080b5
f0101ab9:	e8 82 e5 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101abe:	68 05 82 10 f0       	push   $0xf0108205
f0101ac3:	68 db 80 10 f0       	push   $0xf01080db
f0101ac8:	68 24 03 00 00       	push   $0x324
f0101acd:	68 b5 80 10 f0       	push   $0xf01080b5
f0101ad2:	e8 69 e5 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101ad7:	68 1b 82 10 f0       	push   $0xf010821b
f0101adc:	68 db 80 10 f0       	push   $0xf01080db
f0101ae1:	68 27 03 00 00       	push   $0x327
f0101ae6:	68 b5 80 10 f0       	push   $0xf01080b5
f0101aeb:	e8 50 e5 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101af0:	68 ac 78 10 f0       	push   $0xf01078ac
f0101af5:	68 db 80 10 f0       	push   $0xf01080db
f0101afa:	68 28 03 00 00       	push   $0x328
f0101aff:	68 b5 80 10 f0       	push   $0xf01080b5
f0101b04:	e8 37 e5 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b09:	68 2d 82 10 f0       	push   $0xf010822d
f0101b0e:	68 db 80 10 f0       	push   $0xf01080db
f0101b13:	68 29 03 00 00       	push   $0x329
f0101b18:	68 b5 80 10 f0       	push   $0xf01080b5
f0101b1d:	e8 1e e5 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b22:	68 4a 82 10 f0       	push   $0xf010824a
f0101b27:	68 db 80 10 f0       	push   $0xf01080db
f0101b2c:	68 2a 03 00 00       	push   $0x32a
f0101b31:	68 b5 80 10 f0       	push   $0xf01080b5
f0101b36:	e8 05 e5 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101b3b:	68 67 82 10 f0       	push   $0xf0108267
f0101b40:	68 db 80 10 f0       	push   $0xf01080db
f0101b45:	68 2b 03 00 00       	push   $0x32b
f0101b4a:	68 b5 80 10 f0       	push   $0xf01080b5
f0101b4f:	e8 ec e4 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101b54:	68 84 82 10 f0       	push   $0xf0108284
f0101b59:	68 db 80 10 f0       	push   $0xf01080db
f0101b5e:	68 32 03 00 00       	push   $0x332
f0101b63:	68 b5 80 10 f0       	push   $0xf01080b5
f0101b68:	e8 d3 e4 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101b6d:	68 d9 81 10 f0       	push   $0xf01081d9
f0101b72:	68 db 80 10 f0       	push   $0xf01080db
f0101b77:	68 39 03 00 00       	push   $0x339
f0101b7c:	68 b5 80 10 f0       	push   $0xf01080b5
f0101b81:	e8 ba e4 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101b86:	68 ef 81 10 f0       	push   $0xf01081ef
f0101b8b:	68 db 80 10 f0       	push   $0xf01080db
f0101b90:	68 3a 03 00 00       	push   $0x33a
f0101b95:	68 b5 80 10 f0       	push   $0xf01080b5
f0101b9a:	e8 a1 e4 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101b9f:	68 05 82 10 f0       	push   $0xf0108205
f0101ba4:	68 db 80 10 f0       	push   $0xf01080db
f0101ba9:	68 3b 03 00 00       	push   $0x33b
f0101bae:	68 b5 80 10 f0       	push   $0xf01080b5
f0101bb3:	e8 88 e4 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101bb8:	68 1b 82 10 f0       	push   $0xf010821b
f0101bbd:	68 db 80 10 f0       	push   $0xf01080db
f0101bc2:	68 3d 03 00 00       	push   $0x33d
f0101bc7:	68 b5 80 10 f0       	push   $0xf01080b5
f0101bcc:	e8 6f e4 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101bd1:	68 ac 78 10 f0       	push   $0xf01078ac
f0101bd6:	68 db 80 10 f0       	push   $0xf01080db
f0101bdb:	68 3e 03 00 00       	push   $0x33e
f0101be0:	68 b5 80 10 f0       	push   $0xf01080b5
f0101be5:	e8 56 e4 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101bea:	68 84 82 10 f0       	push   $0xf0108284
f0101bef:	68 db 80 10 f0       	push   $0xf01080db
f0101bf4:	68 3f 03 00 00       	push   $0x33f
f0101bf9:	68 b5 80 10 f0       	push   $0xf01080b5
f0101bfe:	e8 3d e4 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c03:	50                   	push   %eax
f0101c04:	68 74 6f 10 f0       	push   $0xf0106f74
f0101c09:	6a 58                	push   $0x58
f0101c0b:	68 c1 80 10 f0       	push   $0xf01080c1
f0101c10:	e8 2b e4 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101c15:	68 93 82 10 f0       	push   $0xf0108293
f0101c1a:	68 db 80 10 f0       	push   $0xf01080db
f0101c1f:	68 44 03 00 00       	push   $0x344
f0101c24:	68 b5 80 10 f0       	push   $0xf01080b5
f0101c29:	e8 12 e4 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101c2e:	68 b1 82 10 f0       	push   $0xf01082b1
f0101c33:	68 db 80 10 f0       	push   $0xf01080db
f0101c38:	68 45 03 00 00       	push   $0x345
f0101c3d:	68 b5 80 10 f0       	push   $0xf01080b5
f0101c42:	e8 f9 e3 ff ff       	call   f0100040 <_panic>
f0101c47:	50                   	push   %eax
f0101c48:	68 74 6f 10 f0       	push   $0xf0106f74
f0101c4d:	6a 58                	push   $0x58
f0101c4f:	68 c1 80 10 f0       	push   $0xf01080c1
f0101c54:	e8 e7 e3 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f0101c59:	68 c1 82 10 f0       	push   $0xf01082c1
f0101c5e:	68 db 80 10 f0       	push   $0xf01080db
f0101c63:	68 48 03 00 00       	push   $0x348
f0101c68:	68 b5 80 10 f0       	push   $0xf01080b5
f0101c6d:	e8 ce e3 ff ff       	call   f0100040 <_panic>
		--nfree;
f0101c72:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101c76:	8b 00                	mov    (%eax),%eax
f0101c78:	85 c0                	test   %eax,%eax
f0101c7a:	75 f6                	jne    f0101c72 <mem_init+0x552>
	assert(nfree == 0);
f0101c7c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101c80:	0f 85 65 09 00 00    	jne    f01025eb <mem_init+0xecb>
	cprintf("check_page_alloc() succeeded!\n");
f0101c86:	83 ec 0c             	sub    $0xc,%esp
f0101c89:	68 cc 78 10 f0       	push   $0xf01078cc
f0101c8e:	e8 f0 20 00 00       	call   f0103d83 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101c93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c9a:	e8 03 f6 ff ff       	call   f01012a2 <page_alloc>
f0101c9f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101ca2:	83 c4 10             	add    $0x10,%esp
f0101ca5:	85 c0                	test   %eax,%eax
f0101ca7:	0f 84 57 09 00 00    	je     f0102604 <mem_init+0xee4>
	assert((pp1 = page_alloc(0)));
f0101cad:	83 ec 0c             	sub    $0xc,%esp
f0101cb0:	6a 00                	push   $0x0
f0101cb2:	e8 eb f5 ff ff       	call   f01012a2 <page_alloc>
f0101cb7:	89 c7                	mov    %eax,%edi
f0101cb9:	83 c4 10             	add    $0x10,%esp
f0101cbc:	85 c0                	test   %eax,%eax
f0101cbe:	0f 84 59 09 00 00    	je     f010261d <mem_init+0xefd>
	assert((pp2 = page_alloc(0)));
f0101cc4:	83 ec 0c             	sub    $0xc,%esp
f0101cc7:	6a 00                	push   $0x0
f0101cc9:	e8 d4 f5 ff ff       	call   f01012a2 <page_alloc>
f0101cce:	89 c3                	mov    %eax,%ebx
f0101cd0:	83 c4 10             	add    $0x10,%esp
f0101cd3:	85 c0                	test   %eax,%eax
f0101cd5:	0f 84 5b 09 00 00    	je     f0102636 <mem_init+0xf16>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101cdb:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101cde:	0f 84 6b 09 00 00    	je     f010264f <mem_init+0xf2f>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101ce4:	39 c7                	cmp    %eax,%edi
f0101ce6:	0f 84 7c 09 00 00    	je     f0102668 <mem_init+0xf48>
f0101cec:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101cef:	0f 84 73 09 00 00    	je     f0102668 <mem_init+0xf48>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101cf5:	a1 40 72 34 f0       	mov    0xf0347240,%eax
f0101cfa:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101cfd:	c7 05 40 72 34 f0 00 	movl   $0x0,0xf0347240
f0101d04:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101d07:	83 ec 0c             	sub    $0xc,%esp
f0101d0a:	6a 00                	push   $0x0
f0101d0c:	e8 91 f5 ff ff       	call   f01012a2 <page_alloc>
f0101d11:	83 c4 10             	add    $0x10,%esp
f0101d14:	85 c0                	test   %eax,%eax
f0101d16:	0f 85 65 09 00 00    	jne    f0102681 <mem_init+0xf61>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101d1c:	83 ec 04             	sub    $0x4,%esp
f0101d1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d22:	50                   	push   %eax
f0101d23:	6a 00                	push   $0x0
f0101d25:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101d2b:	e8 ce f7 ff ff       	call   f01014fe <page_lookup>
f0101d30:	83 c4 10             	add    $0x10,%esp
f0101d33:	85 c0                	test   %eax,%eax
f0101d35:	0f 85 5f 09 00 00    	jne    f010269a <mem_init+0xf7a>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101d3b:	6a 02                	push   $0x2
f0101d3d:	6a 00                	push   $0x0
f0101d3f:	57                   	push   %edi
f0101d40:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101d46:	e8 93 f8 ff ff       	call   f01015de <page_insert>
f0101d4b:	83 c4 10             	add    $0x10,%esp
f0101d4e:	85 c0                	test   %eax,%eax
f0101d50:	0f 89 5d 09 00 00    	jns    f01026b3 <mem_init+0xf93>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101d56:	83 ec 0c             	sub    $0xc,%esp
f0101d59:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101d5c:	e8 b3 f5 ff ff       	call   f0101314 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101d61:	6a 02                	push   $0x2
f0101d63:	6a 00                	push   $0x0
f0101d65:	57                   	push   %edi
f0101d66:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101d6c:	e8 6d f8 ff ff       	call   f01015de <page_insert>
f0101d71:	83 c4 20             	add    $0x20,%esp
f0101d74:	85 c0                	test   %eax,%eax
f0101d76:	0f 85 50 09 00 00    	jne    f01026cc <mem_init+0xfac>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d7c:	8b 35 8c 7e 34 f0    	mov    0xf0347e8c,%esi
	return (pp - pages) << PGSHIFT;
f0101d82:	8b 0d 90 7e 34 f0    	mov    0xf0347e90,%ecx
f0101d88:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101d8b:	8b 16                	mov    (%esi),%edx
f0101d8d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101d93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d96:	29 c8                	sub    %ecx,%eax
f0101d98:	c1 f8 03             	sar    $0x3,%eax
f0101d9b:	c1 e0 0c             	shl    $0xc,%eax
f0101d9e:	39 c2                	cmp    %eax,%edx
f0101da0:	0f 85 3f 09 00 00    	jne    f01026e5 <mem_init+0xfc5>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101da6:	ba 00 00 00 00       	mov    $0x0,%edx
f0101dab:	89 f0                	mov    %esi,%eax
f0101dad:	e8 f9 ef ff ff       	call   f0100dab <check_va2pa>
f0101db2:	89 fa                	mov    %edi,%edx
f0101db4:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101db7:	c1 fa 03             	sar    $0x3,%edx
f0101dba:	c1 e2 0c             	shl    $0xc,%edx
f0101dbd:	39 d0                	cmp    %edx,%eax
f0101dbf:	0f 85 39 09 00 00    	jne    f01026fe <mem_init+0xfde>
	assert(pp1->pp_ref == 1);
f0101dc5:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101dca:	0f 85 47 09 00 00    	jne    f0102717 <mem_init+0xff7>
	assert(pp0->pp_ref == 1);
f0101dd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dd3:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101dd8:	0f 85 52 09 00 00    	jne    f0102730 <mem_init+0x1010>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101dde:	6a 02                	push   $0x2
f0101de0:	68 00 10 00 00       	push   $0x1000
f0101de5:	53                   	push   %ebx
f0101de6:	56                   	push   %esi
f0101de7:	e8 f2 f7 ff ff       	call   f01015de <page_insert>
f0101dec:	83 c4 10             	add    $0x10,%esp
f0101def:	85 c0                	test   %eax,%eax
f0101df1:	0f 85 52 09 00 00    	jne    f0102749 <mem_init+0x1029>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101df7:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101dfc:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0101e01:	e8 a5 ef ff ff       	call   f0100dab <check_va2pa>
f0101e06:	89 da                	mov    %ebx,%edx
f0101e08:	2b 15 90 7e 34 f0    	sub    0xf0347e90,%edx
f0101e0e:	c1 fa 03             	sar    $0x3,%edx
f0101e11:	c1 e2 0c             	shl    $0xc,%edx
f0101e14:	39 d0                	cmp    %edx,%eax
f0101e16:	0f 85 46 09 00 00    	jne    f0102762 <mem_init+0x1042>
	assert(pp2->pp_ref == 1);
f0101e1c:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101e21:	0f 85 54 09 00 00    	jne    f010277b <mem_init+0x105b>

	// should be no free memory
	assert(!page_alloc(0));
f0101e27:	83 ec 0c             	sub    $0xc,%esp
f0101e2a:	6a 00                	push   $0x0
f0101e2c:	e8 71 f4 ff ff       	call   f01012a2 <page_alloc>
f0101e31:	83 c4 10             	add    $0x10,%esp
f0101e34:	85 c0                	test   %eax,%eax
f0101e36:	0f 85 58 09 00 00    	jne    f0102794 <mem_init+0x1074>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e3c:	6a 02                	push   $0x2
f0101e3e:	68 00 10 00 00       	push   $0x1000
f0101e43:	53                   	push   %ebx
f0101e44:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101e4a:	e8 8f f7 ff ff       	call   f01015de <page_insert>
f0101e4f:	83 c4 10             	add    $0x10,%esp
f0101e52:	85 c0                	test   %eax,%eax
f0101e54:	0f 85 53 09 00 00    	jne    f01027ad <mem_init+0x108d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e5a:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e5f:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0101e64:	e8 42 ef ff ff       	call   f0100dab <check_va2pa>
f0101e69:	89 da                	mov    %ebx,%edx
f0101e6b:	2b 15 90 7e 34 f0    	sub    0xf0347e90,%edx
f0101e71:	c1 fa 03             	sar    $0x3,%edx
f0101e74:	c1 e2 0c             	shl    $0xc,%edx
f0101e77:	39 d0                	cmp    %edx,%eax
f0101e79:	0f 85 47 09 00 00    	jne    f01027c6 <mem_init+0x10a6>
	assert(pp2->pp_ref == 1);
f0101e7f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101e84:	0f 85 55 09 00 00    	jne    f01027df <mem_init+0x10bf>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101e8a:	83 ec 0c             	sub    $0xc,%esp
f0101e8d:	6a 00                	push   $0x0
f0101e8f:	e8 0e f4 ff ff       	call   f01012a2 <page_alloc>
f0101e94:	83 c4 10             	add    $0x10,%esp
f0101e97:	85 c0                	test   %eax,%eax
f0101e99:	0f 85 59 09 00 00    	jne    f01027f8 <mem_init+0x10d8>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101e9f:	8b 15 8c 7e 34 f0    	mov    0xf0347e8c,%edx
f0101ea5:	8b 02                	mov    (%edx),%eax
f0101ea7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101eac:	89 c1                	mov    %eax,%ecx
f0101eae:	c1 e9 0c             	shr    $0xc,%ecx
f0101eb1:	3b 0d 88 7e 34 f0    	cmp    0xf0347e88,%ecx
f0101eb7:	0f 83 54 09 00 00    	jae    f0102811 <mem_init+0x10f1>
	return (void *)(pa + KERNBASE);
f0101ebd:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101ec2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101ec5:	83 ec 04             	sub    $0x4,%esp
f0101ec8:	6a 00                	push   $0x0
f0101eca:	68 00 10 00 00       	push   $0x1000
f0101ecf:	52                   	push   %edx
f0101ed0:	e8 a3 f4 ff ff       	call   f0101378 <pgdir_walk>
f0101ed5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101ed8:	8d 51 04             	lea    0x4(%ecx),%edx
f0101edb:	83 c4 10             	add    $0x10,%esp
f0101ede:	39 d0                	cmp    %edx,%eax
f0101ee0:	0f 85 40 09 00 00    	jne    f0102826 <mem_init+0x1106>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101ee6:	6a 06                	push   $0x6
f0101ee8:	68 00 10 00 00       	push   $0x1000
f0101eed:	53                   	push   %ebx
f0101eee:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101ef4:	e8 e5 f6 ff ff       	call   f01015de <page_insert>
f0101ef9:	83 c4 10             	add    $0x10,%esp
f0101efc:	85 c0                	test   %eax,%eax
f0101efe:	0f 85 3b 09 00 00    	jne    f010283f <mem_init+0x111f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f04:	8b 35 8c 7e 34 f0    	mov    0xf0347e8c,%esi
f0101f0a:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f0f:	89 f0                	mov    %esi,%eax
f0101f11:	e8 95 ee ff ff       	call   f0100dab <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101f16:	89 da                	mov    %ebx,%edx
f0101f18:	2b 15 90 7e 34 f0    	sub    0xf0347e90,%edx
f0101f1e:	c1 fa 03             	sar    $0x3,%edx
f0101f21:	c1 e2 0c             	shl    $0xc,%edx
f0101f24:	39 d0                	cmp    %edx,%eax
f0101f26:	0f 85 2c 09 00 00    	jne    f0102858 <mem_init+0x1138>
	assert(pp2->pp_ref == 1);
f0101f2c:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101f31:	0f 85 3a 09 00 00    	jne    f0102871 <mem_init+0x1151>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101f37:	83 ec 04             	sub    $0x4,%esp
f0101f3a:	6a 00                	push   $0x0
f0101f3c:	68 00 10 00 00       	push   $0x1000
f0101f41:	56                   	push   %esi
f0101f42:	e8 31 f4 ff ff       	call   f0101378 <pgdir_walk>
f0101f47:	83 c4 10             	add    $0x10,%esp
f0101f4a:	f6 00 04             	testb  $0x4,(%eax)
f0101f4d:	0f 84 37 09 00 00    	je     f010288a <mem_init+0x116a>
	assert(kern_pgdir[0] & PTE_U);
f0101f53:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0101f58:	f6 00 04             	testb  $0x4,(%eax)
f0101f5b:	0f 84 42 09 00 00    	je     f01028a3 <mem_init+0x1183>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101f61:	6a 02                	push   $0x2
f0101f63:	68 00 10 00 00       	push   $0x1000
f0101f68:	53                   	push   %ebx
f0101f69:	50                   	push   %eax
f0101f6a:	e8 6f f6 ff ff       	call   f01015de <page_insert>
f0101f6f:	83 c4 10             	add    $0x10,%esp
f0101f72:	85 c0                	test   %eax,%eax
f0101f74:	0f 85 42 09 00 00    	jne    f01028bc <mem_init+0x119c>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101f7a:	83 ec 04             	sub    $0x4,%esp
f0101f7d:	6a 00                	push   $0x0
f0101f7f:	68 00 10 00 00       	push   $0x1000
f0101f84:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101f8a:	e8 e9 f3 ff ff       	call   f0101378 <pgdir_walk>
f0101f8f:	83 c4 10             	add    $0x10,%esp
f0101f92:	f6 00 02             	testb  $0x2,(%eax)
f0101f95:	0f 84 3a 09 00 00    	je     f01028d5 <mem_init+0x11b5>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101f9b:	83 ec 04             	sub    $0x4,%esp
f0101f9e:	6a 00                	push   $0x0
f0101fa0:	68 00 10 00 00       	push   $0x1000
f0101fa5:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101fab:	e8 c8 f3 ff ff       	call   f0101378 <pgdir_walk>
f0101fb0:	83 c4 10             	add    $0x10,%esp
f0101fb3:	f6 00 04             	testb  $0x4,(%eax)
f0101fb6:	0f 85 32 09 00 00    	jne    f01028ee <mem_init+0x11ce>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101fbc:	6a 02                	push   $0x2
f0101fbe:	68 00 00 40 00       	push   $0x400000
f0101fc3:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101fc6:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101fcc:	e8 0d f6 ff ff       	call   f01015de <page_insert>
f0101fd1:	83 c4 10             	add    $0x10,%esp
f0101fd4:	85 c0                	test   %eax,%eax
f0101fd6:	0f 89 2b 09 00 00    	jns    f0102907 <mem_init+0x11e7>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101fdc:	6a 02                	push   $0x2
f0101fde:	68 00 10 00 00       	push   $0x1000
f0101fe3:	57                   	push   %edi
f0101fe4:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0101fea:	e8 ef f5 ff ff       	call   f01015de <page_insert>
f0101fef:	83 c4 10             	add    $0x10,%esp
f0101ff2:	85 c0                	test   %eax,%eax
f0101ff4:	0f 85 26 09 00 00    	jne    f0102920 <mem_init+0x1200>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101ffa:	83 ec 04             	sub    $0x4,%esp
f0101ffd:	6a 00                	push   $0x0
f0101fff:	68 00 10 00 00       	push   $0x1000
f0102004:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f010200a:	e8 69 f3 ff ff       	call   f0101378 <pgdir_walk>
f010200f:	83 c4 10             	add    $0x10,%esp
f0102012:	f6 00 04             	testb  $0x4,(%eax)
f0102015:	0f 85 1e 09 00 00    	jne    f0102939 <mem_init+0x1219>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010201b:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0102020:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102023:	ba 00 00 00 00       	mov    $0x0,%edx
f0102028:	e8 7e ed ff ff       	call   f0100dab <check_va2pa>
f010202d:	89 fe                	mov    %edi,%esi
f010202f:	2b 35 90 7e 34 f0    	sub    0xf0347e90,%esi
f0102035:	c1 fe 03             	sar    $0x3,%esi
f0102038:	c1 e6 0c             	shl    $0xc,%esi
f010203b:	39 f0                	cmp    %esi,%eax
f010203d:	0f 85 0f 09 00 00    	jne    f0102952 <mem_init+0x1232>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102043:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102048:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010204b:	e8 5b ed ff ff       	call   f0100dab <check_va2pa>
f0102050:	39 c6                	cmp    %eax,%esi
f0102052:	0f 85 13 09 00 00    	jne    f010296b <mem_init+0x124b>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0102058:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f010205d:	0f 85 21 09 00 00    	jne    f0102984 <mem_init+0x1264>
	assert(pp2->pp_ref == 0);
f0102063:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102068:	0f 85 2f 09 00 00    	jne    f010299d <mem_init+0x127d>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f010206e:	83 ec 0c             	sub    $0xc,%esp
f0102071:	6a 00                	push   $0x0
f0102073:	e8 2a f2 ff ff       	call   f01012a2 <page_alloc>
f0102078:	83 c4 10             	add    $0x10,%esp
f010207b:	39 c3                	cmp    %eax,%ebx
f010207d:	0f 85 33 09 00 00    	jne    f01029b6 <mem_init+0x1296>
f0102083:	85 c0                	test   %eax,%eax
f0102085:	0f 84 2b 09 00 00    	je     f01029b6 <mem_init+0x1296>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f010208b:	83 ec 08             	sub    $0x8,%esp
f010208e:	6a 00                	push   $0x0
f0102090:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0102096:	e8 fd f4 ff ff       	call   f0101598 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010209b:	8b 35 8c 7e 34 f0    	mov    0xf0347e8c,%esi
f01020a1:	ba 00 00 00 00       	mov    $0x0,%edx
f01020a6:	89 f0                	mov    %esi,%eax
f01020a8:	e8 fe ec ff ff       	call   f0100dab <check_va2pa>
f01020ad:	83 c4 10             	add    $0x10,%esp
f01020b0:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020b3:	0f 85 16 09 00 00    	jne    f01029cf <mem_init+0x12af>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01020b9:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020be:	89 f0                	mov    %esi,%eax
f01020c0:	e8 e6 ec ff ff       	call   f0100dab <check_va2pa>
f01020c5:	89 fa                	mov    %edi,%edx
f01020c7:	2b 15 90 7e 34 f0    	sub    0xf0347e90,%edx
f01020cd:	c1 fa 03             	sar    $0x3,%edx
f01020d0:	c1 e2 0c             	shl    $0xc,%edx
f01020d3:	39 d0                	cmp    %edx,%eax
f01020d5:	0f 85 0d 09 00 00    	jne    f01029e8 <mem_init+0x12c8>
	assert(pp1->pp_ref == 1);
f01020db:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f01020e0:	0f 85 1b 09 00 00    	jne    f0102a01 <mem_init+0x12e1>
	assert(pp2->pp_ref == 0);
f01020e6:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01020eb:	0f 85 29 09 00 00    	jne    f0102a1a <mem_init+0x12fa>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01020f1:	6a 00                	push   $0x0
f01020f3:	68 00 10 00 00       	push   $0x1000
f01020f8:	57                   	push   %edi
f01020f9:	56                   	push   %esi
f01020fa:	e8 df f4 ff ff       	call   f01015de <page_insert>
f01020ff:	83 c4 10             	add    $0x10,%esp
f0102102:	85 c0                	test   %eax,%eax
f0102104:	0f 85 29 09 00 00    	jne    f0102a33 <mem_init+0x1313>
	assert(pp1->pp_ref);
f010210a:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010210f:	0f 84 37 09 00 00    	je     f0102a4c <mem_init+0x132c>
	assert(pp1->pp_link == NULL);
f0102115:	83 3f 00             	cmpl   $0x0,(%edi)
f0102118:	0f 85 47 09 00 00    	jne    f0102a65 <mem_init+0x1345>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f010211e:	83 ec 08             	sub    $0x8,%esp
f0102121:	68 00 10 00 00       	push   $0x1000
f0102126:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f010212c:	e8 67 f4 ff ff       	call   f0101598 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102131:	8b 35 8c 7e 34 f0    	mov    0xf0347e8c,%esi
f0102137:	ba 00 00 00 00       	mov    $0x0,%edx
f010213c:	89 f0                	mov    %esi,%eax
f010213e:	e8 68 ec ff ff       	call   f0100dab <check_va2pa>
f0102143:	83 c4 10             	add    $0x10,%esp
f0102146:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102149:	0f 85 2f 09 00 00    	jne    f0102a7e <mem_init+0x135e>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010214f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102154:	89 f0                	mov    %esi,%eax
f0102156:	e8 50 ec ff ff       	call   f0100dab <check_va2pa>
f010215b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010215e:	0f 85 33 09 00 00    	jne    f0102a97 <mem_init+0x1377>
	assert(pp1->pp_ref == 0);
f0102164:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102169:	0f 85 41 09 00 00    	jne    f0102ab0 <mem_init+0x1390>
	assert(pp2->pp_ref == 0);
f010216f:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102174:	0f 85 4f 09 00 00    	jne    f0102ac9 <mem_init+0x13a9>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f010217a:	83 ec 0c             	sub    $0xc,%esp
f010217d:	6a 00                	push   $0x0
f010217f:	e8 1e f1 ff ff       	call   f01012a2 <page_alloc>
f0102184:	83 c4 10             	add    $0x10,%esp
f0102187:	85 c0                	test   %eax,%eax
f0102189:	0f 84 53 09 00 00    	je     f0102ae2 <mem_init+0x13c2>
f010218f:	39 c7                	cmp    %eax,%edi
f0102191:	0f 85 4b 09 00 00    	jne    f0102ae2 <mem_init+0x13c2>

	// should be no free memory
	assert(!page_alloc(0));
f0102197:	83 ec 0c             	sub    $0xc,%esp
f010219a:	6a 00                	push   $0x0
f010219c:	e8 01 f1 ff ff       	call   f01012a2 <page_alloc>
f01021a1:	83 c4 10             	add    $0x10,%esp
f01021a4:	85 c0                	test   %eax,%eax
f01021a6:	0f 85 4f 09 00 00    	jne    f0102afb <mem_init+0x13db>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01021ac:	8b 0d 8c 7e 34 f0    	mov    0xf0347e8c,%ecx
f01021b2:	8b 11                	mov    (%ecx),%edx
f01021b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01021ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021bd:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f01021c3:	c1 f8 03             	sar    $0x3,%eax
f01021c6:	c1 e0 0c             	shl    $0xc,%eax
f01021c9:	39 c2                	cmp    %eax,%edx
f01021cb:	0f 85 43 09 00 00    	jne    f0102b14 <mem_init+0x13f4>
	kern_pgdir[0] = 0;
f01021d1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f01021d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021da:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01021df:	0f 85 48 09 00 00    	jne    f0102b2d <mem_init+0x140d>
	pp0->pp_ref = 0;
f01021e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021e8:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01021ee:	83 ec 0c             	sub    $0xc,%esp
f01021f1:	50                   	push   %eax
f01021f2:	e8 1d f1 ff ff       	call   f0101314 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01021f7:	83 c4 0c             	add    $0xc,%esp
f01021fa:	6a 01                	push   $0x1
f01021fc:	68 00 10 40 00       	push   $0x401000
f0102201:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0102207:	e8 6c f1 ff ff       	call   f0101378 <pgdir_walk>
f010220c:	89 c1                	mov    %eax,%ecx
f010220e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102211:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0102216:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102219:	8b 40 04             	mov    0x4(%eax),%eax
f010221c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0102221:	8b 35 88 7e 34 f0    	mov    0xf0347e88,%esi
f0102227:	89 c2                	mov    %eax,%edx
f0102229:	c1 ea 0c             	shr    $0xc,%edx
f010222c:	83 c4 10             	add    $0x10,%esp
f010222f:	39 f2                	cmp    %esi,%edx
f0102231:	0f 83 0f 09 00 00    	jae    f0102b46 <mem_init+0x1426>
	assert(ptep == ptep1 + PTX(va));
f0102237:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f010223c:	39 c1                	cmp    %eax,%ecx
f010223e:	0f 85 17 09 00 00    	jne    f0102b5b <mem_init+0x143b>
	kern_pgdir[PDX(va)] = 0;
f0102244:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102247:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f010224e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102251:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0102257:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f010225d:	c1 f8 03             	sar    $0x3,%eax
f0102260:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102263:	89 c2                	mov    %eax,%edx
f0102265:	c1 ea 0c             	shr    $0xc,%edx
f0102268:	39 d6                	cmp    %edx,%esi
f010226a:	0f 86 04 09 00 00    	jbe    f0102b74 <mem_init+0x1454>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102270:	83 ec 04             	sub    $0x4,%esp
f0102273:	68 00 10 00 00       	push   $0x1000
f0102278:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f010227d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102282:	50                   	push   %eax
f0102283:	e8 41 40 00 00       	call   f01062c9 <memset>
	page_free(pp0);
f0102288:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f010228b:	89 34 24             	mov    %esi,(%esp)
f010228e:	e8 81 f0 ff ff       	call   f0101314 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102293:	83 c4 0c             	add    $0xc,%esp
f0102296:	6a 01                	push   $0x1
f0102298:	6a 00                	push   $0x0
f010229a:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f01022a0:	e8 d3 f0 ff ff       	call   f0101378 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01022a5:	89 f0                	mov    %esi,%eax
f01022a7:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f01022ad:	c1 f8 03             	sar    $0x3,%eax
f01022b0:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01022b3:	89 c2                	mov    %eax,%edx
f01022b5:	c1 ea 0c             	shr    $0xc,%edx
f01022b8:	83 c4 10             	add    $0x10,%esp
f01022bb:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f01022c1:	0f 83 bf 08 00 00    	jae    f0102b86 <mem_init+0x1466>
	return (void *)(pa + KERNBASE);
f01022c7:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f01022cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01022d0:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f01022d5:	f6 02 01             	testb  $0x1,(%edx)
f01022d8:	0f 85 ba 08 00 00    	jne    f0102b98 <mem_init+0x1478>
f01022de:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f01022e1:	39 c2                	cmp    %eax,%edx
f01022e3:	75 f0                	jne    f01022d5 <mem_init+0xbb5>
	kern_pgdir[0] = 0;
f01022e5:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f01022ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01022f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01022f3:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f01022f9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01022fc:	89 0d 40 72 34 f0    	mov    %ecx,0xf0347240

	// free the pages we took
	page_free(pp0);
f0102302:	83 ec 0c             	sub    $0xc,%esp
f0102305:	50                   	push   %eax
f0102306:	e8 09 f0 ff ff       	call   f0101314 <page_free>
	page_free(pp1);
f010230b:	89 3c 24             	mov    %edi,(%esp)
f010230e:	e8 01 f0 ff ff       	call   f0101314 <page_free>
	page_free(pp2);
f0102313:	89 1c 24             	mov    %ebx,(%esp)
f0102316:	e8 f9 ef ff ff       	call   f0101314 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f010231b:	83 c4 08             	add    $0x8,%esp
f010231e:	68 01 10 00 00       	push   $0x1001
f0102323:	6a 00                	push   $0x0
f0102325:	e8 96 f3 ff ff       	call   f01016c0 <mmio_map_region>
f010232a:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f010232c:	83 c4 08             	add    $0x8,%esp
f010232f:	68 00 10 00 00       	push   $0x1000
f0102334:	6a 00                	push   $0x0
f0102336:	e8 85 f3 ff ff       	call   f01016c0 <mmio_map_region>
f010233b:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f010233d:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102343:	83 c4 10             	add    $0x10,%esp
f0102346:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010234c:	0f 86 5f 08 00 00    	jbe    f0102bb1 <mem_init+0x1491>
f0102352:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102357:	0f 87 54 08 00 00    	ja     f0102bb1 <mem_init+0x1491>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010235d:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102363:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102369:	0f 87 5b 08 00 00    	ja     f0102bca <mem_init+0x14aa>
f010236f:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102375:	0f 86 4f 08 00 00    	jbe    f0102bca <mem_init+0x14aa>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010237b:	89 da                	mov    %ebx,%edx
f010237d:	09 f2                	or     %esi,%edx
f010237f:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102385:	0f 85 58 08 00 00    	jne    f0102be3 <mem_init+0x14c3>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f010238b:	39 c6                	cmp    %eax,%esi
f010238d:	0f 82 69 08 00 00    	jb     f0102bfc <mem_init+0x14dc>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102393:	8b 3d 8c 7e 34 f0    	mov    0xf0347e8c,%edi
f0102399:	89 da                	mov    %ebx,%edx
f010239b:	89 f8                	mov    %edi,%eax
f010239d:	e8 09 ea ff ff       	call   f0100dab <check_va2pa>
f01023a2:	85 c0                	test   %eax,%eax
f01023a4:	0f 85 6b 08 00 00    	jne    f0102c15 <mem_init+0x14f5>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01023aa:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f01023b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01023b3:	89 c2                	mov    %eax,%edx
f01023b5:	89 f8                	mov    %edi,%eax
f01023b7:	e8 ef e9 ff ff       	call   f0100dab <check_va2pa>
f01023bc:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01023c1:	0f 85 67 08 00 00    	jne    f0102c2e <mem_init+0x150e>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01023c7:	89 f2                	mov    %esi,%edx
f01023c9:	89 f8                	mov    %edi,%eax
f01023cb:	e8 db e9 ff ff       	call   f0100dab <check_va2pa>
f01023d0:	85 c0                	test   %eax,%eax
f01023d2:	0f 85 6f 08 00 00    	jne    f0102c47 <mem_init+0x1527>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01023d8:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f01023de:	89 f8                	mov    %edi,%eax
f01023e0:	e8 c6 e9 ff ff       	call   f0100dab <check_va2pa>
f01023e5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01023e8:	0f 85 72 08 00 00    	jne    f0102c60 <mem_init+0x1540>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01023ee:	83 ec 04             	sub    $0x4,%esp
f01023f1:	6a 00                	push   $0x0
f01023f3:	53                   	push   %ebx
f01023f4:	57                   	push   %edi
f01023f5:	e8 7e ef ff ff       	call   f0101378 <pgdir_walk>
f01023fa:	83 c4 10             	add    $0x10,%esp
f01023fd:	f6 00 1a             	testb  $0x1a,(%eax)
f0102400:	0f 84 73 08 00 00    	je     f0102c79 <mem_init+0x1559>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102406:	83 ec 04             	sub    $0x4,%esp
f0102409:	6a 00                	push   $0x0
f010240b:	53                   	push   %ebx
f010240c:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0102412:	e8 61 ef ff ff       	call   f0101378 <pgdir_walk>
f0102417:	8b 00                	mov    (%eax),%eax
f0102419:	83 c4 10             	add    $0x10,%esp
f010241c:	83 e0 04             	and    $0x4,%eax
f010241f:	89 c7                	mov    %eax,%edi
f0102421:	0f 85 6b 08 00 00    	jne    f0102c92 <mem_init+0x1572>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102427:	83 ec 04             	sub    $0x4,%esp
f010242a:	6a 00                	push   $0x0
f010242c:	53                   	push   %ebx
f010242d:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0102433:	e8 40 ef ff ff       	call   f0101378 <pgdir_walk>
f0102438:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f010243e:	83 c4 0c             	add    $0xc,%esp
f0102441:	6a 00                	push   $0x0
f0102443:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102446:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f010244c:	e8 27 ef ff ff       	call   f0101378 <pgdir_walk>
f0102451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102457:	83 c4 0c             	add    $0xc,%esp
f010245a:	6a 00                	push   $0x0
f010245c:	56                   	push   %esi
f010245d:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0102463:	e8 10 ef ff ff       	call   f0101378 <pgdir_walk>
f0102468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f010246e:	c7 04 24 b4 83 10 f0 	movl   $0xf01083b4,(%esp)
f0102475:	e8 09 19 00 00       	call   f0103d83 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010247a:	a1 90 7e 34 f0       	mov    0xf0347e90,%eax
	if ((uint32_t)kva < KERNBASE)
f010247f:	83 c4 10             	add    $0x10,%esp
f0102482:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102487:	0f 86 1e 08 00 00    	jbe    f0102cab <mem_init+0x158b>
f010248d:	83 ec 08             	sub    $0x8,%esp
f0102490:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102492:	05 00 00 00 10       	add    $0x10000000,%eax
f0102497:	50                   	push   %eax
f0102498:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010249d:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01024a2:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f01024a7:	e8 9e ef ff ff       	call   f010144a <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01024ac:	a1 44 72 34 f0       	mov    0xf0347244,%eax
	if ((uint32_t)kva < KERNBASE)
f01024b1:	83 c4 10             	add    $0x10,%esp
f01024b4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01024b9:	0f 86 01 08 00 00    	jbe    f0102cc0 <mem_init+0x15a0>
f01024bf:	83 ec 08             	sub    $0x8,%esp
f01024c2:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01024c4:	05 00 00 00 10       	add    $0x10000000,%eax
f01024c9:	50                   	push   %eax
f01024ca:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01024cf:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01024d4:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f01024d9:	e8 6c ef ff ff       	call   f010144a <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f01024de:	83 c4 10             	add    $0x10,%esp
f01024e1:	b8 00 b0 11 f0       	mov    $0xf011b000,%eax
f01024e6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01024eb:	0f 86 e4 07 00 00    	jbe    f0102cd5 <mem_init+0x15b5>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f01024f1:	83 ec 08             	sub    $0x8,%esp
f01024f4:	6a 02                	push   $0x2
f01024f6:	68 00 b0 11 00       	push   $0x11b000
f01024fb:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102500:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102505:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f010250a:	e8 3b ef ff ff       	call   f010144a <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (uint32_t)(0 - KERNBASE), 0, PTE_W);
f010250f:	83 c4 08             	add    $0x8,%esp
f0102512:	6a 02                	push   $0x2
f0102514:	6a 00                	push   $0x0
f0102516:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010251b:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102520:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0102525:	e8 20 ef ff ff       	call   f010144a <boot_map_region>
f010252a:	c7 45 d0 00 90 34 f0 	movl   $0xf0349000,-0x30(%ebp)
f0102531:	83 c4 10             	add    $0x10,%esp
f0102534:	bb 00 90 34 f0       	mov    $0xf0349000,%ebx
f0102539:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f010253e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102544:	0f 86 a0 07 00 00    	jbe    f0102cea <mem_init+0x15ca>
		boot_map_region(kern_pgdir, KSTACKTOP - i * (KSTKSIZE + KSTKGAP) - KSTKSIZE,
f010254a:	83 ec 08             	sub    $0x8,%esp
f010254d:	6a 02                	push   $0x2
f010254f:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102555:	50                   	push   %eax
f0102556:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010255b:	89 f2                	mov    %esi,%edx
f010255d:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0102562:	e8 e3 ee ff ff       	call   f010144a <boot_map_region>
f0102567:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f010256d:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(int i = 0; i < NCPU; i++){
f0102573:	83 c4 10             	add    $0x10,%esp
f0102576:	81 fb 00 90 38 f0    	cmp    $0xf0389000,%ebx
f010257c:	75 c0                	jne    f010253e <mem_init+0xe1e>
	pgdir = kern_pgdir;
f010257e:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
f0102583:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102586:	a1 88 7e 34 f0       	mov    0xf0347e88,%eax
f010258b:	89 45 c0             	mov    %eax,-0x40(%ebp)
f010258e:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010259a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010259d:	8b 35 90 7e 34 f0    	mov    0xf0347e90,%esi
f01025a3:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01025a6:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01025ac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01025af:	89 fb                	mov    %edi,%ebx
f01025b1:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f01025b4:	0f 86 73 07 00 00    	jbe    f0102d2d <mem_init+0x160d>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01025ba:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01025c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01025c3:	e8 e3 e7 ff ff       	call   f0100dab <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01025c8:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f01025cf:	0f 86 2a 07 00 00    	jbe    f0102cff <mem_init+0x15df>
f01025d5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f01025d8:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f01025db:	39 d0                	cmp    %edx,%eax
f01025dd:	0f 85 31 07 00 00    	jne    f0102d14 <mem_init+0x15f4>
	for (i = 0; i < n; i += PGSIZE)
f01025e3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01025e9:	eb c6                	jmp    f01025b1 <mem_init+0xe91>
	assert(nfree == 0);
f01025eb:	68 cb 82 10 f0       	push   $0xf01082cb
f01025f0:	68 db 80 10 f0       	push   $0xf01080db
f01025f5:	68 55 03 00 00       	push   $0x355
f01025fa:	68 b5 80 10 f0       	push   $0xf01080b5
f01025ff:	e8 3c da ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102604:	68 d9 81 10 f0       	push   $0xf01081d9
f0102609:	68 db 80 10 f0       	push   $0xf01080db
f010260e:	68 c8 03 00 00       	push   $0x3c8
f0102613:	68 b5 80 10 f0       	push   $0xf01080b5
f0102618:	e8 23 da ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010261d:	68 ef 81 10 f0       	push   $0xf01081ef
f0102622:	68 db 80 10 f0       	push   $0xf01080db
f0102627:	68 c9 03 00 00       	push   $0x3c9
f010262c:	68 b5 80 10 f0       	push   $0xf01080b5
f0102631:	e8 0a da ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102636:	68 05 82 10 f0       	push   $0xf0108205
f010263b:	68 db 80 10 f0       	push   $0xf01080db
f0102640:	68 ca 03 00 00       	push   $0x3ca
f0102645:	68 b5 80 10 f0       	push   $0xf01080b5
f010264a:	e8 f1 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f010264f:	68 1b 82 10 f0       	push   $0xf010821b
f0102654:	68 db 80 10 f0       	push   $0xf01080db
f0102659:	68 cd 03 00 00       	push   $0x3cd
f010265e:	68 b5 80 10 f0       	push   $0xf01080b5
f0102663:	e8 d8 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102668:	68 ac 78 10 f0       	push   $0xf01078ac
f010266d:	68 db 80 10 f0       	push   $0xf01080db
f0102672:	68 ce 03 00 00       	push   $0x3ce
f0102677:	68 b5 80 10 f0       	push   $0xf01080b5
f010267c:	e8 bf d9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102681:	68 84 82 10 f0       	push   $0xf0108284
f0102686:	68 db 80 10 f0       	push   $0xf01080db
f010268b:	68 d5 03 00 00       	push   $0x3d5
f0102690:	68 b5 80 10 f0       	push   $0xf01080b5
f0102695:	e8 a6 d9 ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010269a:	68 ec 78 10 f0       	push   $0xf01078ec
f010269f:	68 db 80 10 f0       	push   $0xf01080db
f01026a4:	68 d8 03 00 00       	push   $0x3d8
f01026a9:	68 b5 80 10 f0       	push   $0xf01080b5
f01026ae:	e8 8d d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01026b3:	68 24 79 10 f0       	push   $0xf0107924
f01026b8:	68 db 80 10 f0       	push   $0xf01080db
f01026bd:	68 db 03 00 00       	push   $0x3db
f01026c2:	68 b5 80 10 f0       	push   $0xf01080b5
f01026c7:	e8 74 d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01026cc:	68 54 79 10 f0       	push   $0xf0107954
f01026d1:	68 db 80 10 f0       	push   $0xf01080db
f01026d6:	68 df 03 00 00       	push   $0x3df
f01026db:	68 b5 80 10 f0       	push   $0xf01080b5
f01026e0:	e8 5b d9 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01026e5:	68 84 79 10 f0       	push   $0xf0107984
f01026ea:	68 db 80 10 f0       	push   $0xf01080db
f01026ef:	68 e0 03 00 00       	push   $0x3e0
f01026f4:	68 b5 80 10 f0       	push   $0xf01080b5
f01026f9:	e8 42 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01026fe:	68 ac 79 10 f0       	push   $0xf01079ac
f0102703:	68 db 80 10 f0       	push   $0xf01080db
f0102708:	68 e1 03 00 00       	push   $0x3e1
f010270d:	68 b5 80 10 f0       	push   $0xf01080b5
f0102712:	e8 29 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102717:	68 d6 82 10 f0       	push   $0xf01082d6
f010271c:	68 db 80 10 f0       	push   $0xf01080db
f0102721:	68 e2 03 00 00       	push   $0x3e2
f0102726:	68 b5 80 10 f0       	push   $0xf01080b5
f010272b:	e8 10 d9 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102730:	68 e7 82 10 f0       	push   $0xf01082e7
f0102735:	68 db 80 10 f0       	push   $0xf01080db
f010273a:	68 e3 03 00 00       	push   $0x3e3
f010273f:	68 b5 80 10 f0       	push   $0xf01080b5
f0102744:	e8 f7 d8 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102749:	68 dc 79 10 f0       	push   $0xf01079dc
f010274e:	68 db 80 10 f0       	push   $0xf01080db
f0102753:	68 e6 03 00 00       	push   $0x3e6
f0102758:	68 b5 80 10 f0       	push   $0xf01080b5
f010275d:	e8 de d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102762:	68 18 7a 10 f0       	push   $0xf0107a18
f0102767:	68 db 80 10 f0       	push   $0xf01080db
f010276c:	68 e7 03 00 00       	push   $0x3e7
f0102771:	68 b5 80 10 f0       	push   $0xf01080b5
f0102776:	e8 c5 d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010277b:	68 f8 82 10 f0       	push   $0xf01082f8
f0102780:	68 db 80 10 f0       	push   $0xf01080db
f0102785:	68 e8 03 00 00       	push   $0x3e8
f010278a:	68 b5 80 10 f0       	push   $0xf01080b5
f010278f:	e8 ac d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102794:	68 84 82 10 f0       	push   $0xf0108284
f0102799:	68 db 80 10 f0       	push   $0xf01080db
f010279e:	68 eb 03 00 00       	push   $0x3eb
f01027a3:	68 b5 80 10 f0       	push   $0xf01080b5
f01027a8:	e8 93 d8 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01027ad:	68 dc 79 10 f0       	push   $0xf01079dc
f01027b2:	68 db 80 10 f0       	push   $0xf01080db
f01027b7:	68 ee 03 00 00       	push   $0x3ee
f01027bc:	68 b5 80 10 f0       	push   $0xf01080b5
f01027c1:	e8 7a d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027c6:	68 18 7a 10 f0       	push   $0xf0107a18
f01027cb:	68 db 80 10 f0       	push   $0xf01080db
f01027d0:	68 ef 03 00 00       	push   $0x3ef
f01027d5:	68 b5 80 10 f0       	push   $0xf01080b5
f01027da:	e8 61 d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01027df:	68 f8 82 10 f0       	push   $0xf01082f8
f01027e4:	68 db 80 10 f0       	push   $0xf01080db
f01027e9:	68 f0 03 00 00       	push   $0x3f0
f01027ee:	68 b5 80 10 f0       	push   $0xf01080b5
f01027f3:	e8 48 d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01027f8:	68 84 82 10 f0       	push   $0xf0108284
f01027fd:	68 db 80 10 f0       	push   $0xf01080db
f0102802:	68 f4 03 00 00       	push   $0x3f4
f0102807:	68 b5 80 10 f0       	push   $0xf01080b5
f010280c:	e8 2f d8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102811:	50                   	push   %eax
f0102812:	68 74 6f 10 f0       	push   $0xf0106f74
f0102817:	68 f7 03 00 00       	push   $0x3f7
f010281c:	68 b5 80 10 f0       	push   $0xf01080b5
f0102821:	e8 1a d8 ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102826:	68 48 7a 10 f0       	push   $0xf0107a48
f010282b:	68 db 80 10 f0       	push   $0xf01080db
f0102830:	68 f8 03 00 00       	push   $0x3f8
f0102835:	68 b5 80 10 f0       	push   $0xf01080b5
f010283a:	e8 01 d8 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010283f:	68 88 7a 10 f0       	push   $0xf0107a88
f0102844:	68 db 80 10 f0       	push   $0xf01080db
f0102849:	68 fb 03 00 00       	push   $0x3fb
f010284e:	68 b5 80 10 f0       	push   $0xf01080b5
f0102853:	e8 e8 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102858:	68 18 7a 10 f0       	push   $0xf0107a18
f010285d:	68 db 80 10 f0       	push   $0xf01080db
f0102862:	68 fc 03 00 00       	push   $0x3fc
f0102867:	68 b5 80 10 f0       	push   $0xf01080b5
f010286c:	e8 cf d7 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102871:	68 f8 82 10 f0       	push   $0xf01082f8
f0102876:	68 db 80 10 f0       	push   $0xf01080db
f010287b:	68 fd 03 00 00       	push   $0x3fd
f0102880:	68 b5 80 10 f0       	push   $0xf01080b5
f0102885:	e8 b6 d7 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010288a:	68 c8 7a 10 f0       	push   $0xf0107ac8
f010288f:	68 db 80 10 f0       	push   $0xf01080db
f0102894:	68 fe 03 00 00       	push   $0x3fe
f0102899:	68 b5 80 10 f0       	push   $0xf01080b5
f010289e:	e8 9d d7 ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01028a3:	68 09 83 10 f0       	push   $0xf0108309
f01028a8:	68 db 80 10 f0       	push   $0xf01080db
f01028ad:	68 ff 03 00 00       	push   $0x3ff
f01028b2:	68 b5 80 10 f0       	push   $0xf01080b5
f01028b7:	e8 84 d7 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01028bc:	68 dc 79 10 f0       	push   $0xf01079dc
f01028c1:	68 db 80 10 f0       	push   $0xf01080db
f01028c6:	68 02 04 00 00       	push   $0x402
f01028cb:	68 b5 80 10 f0       	push   $0xf01080b5
f01028d0:	e8 6b d7 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01028d5:	68 fc 7a 10 f0       	push   $0xf0107afc
f01028da:	68 db 80 10 f0       	push   $0xf01080db
f01028df:	68 03 04 00 00       	push   $0x403
f01028e4:	68 b5 80 10 f0       	push   $0xf01080b5
f01028e9:	e8 52 d7 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01028ee:	68 30 7b 10 f0       	push   $0xf0107b30
f01028f3:	68 db 80 10 f0       	push   $0xf01080db
f01028f8:	68 04 04 00 00       	push   $0x404
f01028fd:	68 b5 80 10 f0       	push   $0xf01080b5
f0102902:	e8 39 d7 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102907:	68 68 7b 10 f0       	push   $0xf0107b68
f010290c:	68 db 80 10 f0       	push   $0xf01080db
f0102911:	68 07 04 00 00       	push   $0x407
f0102916:	68 b5 80 10 f0       	push   $0xf01080b5
f010291b:	e8 20 d7 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102920:	68 a0 7b 10 f0       	push   $0xf0107ba0
f0102925:	68 db 80 10 f0       	push   $0xf01080db
f010292a:	68 0a 04 00 00       	push   $0x40a
f010292f:	68 b5 80 10 f0       	push   $0xf01080b5
f0102934:	e8 07 d7 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102939:	68 30 7b 10 f0       	push   $0xf0107b30
f010293e:	68 db 80 10 f0       	push   $0xf01080db
f0102943:	68 0b 04 00 00       	push   $0x40b
f0102948:	68 b5 80 10 f0       	push   $0xf01080b5
f010294d:	e8 ee d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102952:	68 dc 7b 10 f0       	push   $0xf0107bdc
f0102957:	68 db 80 10 f0       	push   $0xf01080db
f010295c:	68 0e 04 00 00       	push   $0x40e
f0102961:	68 b5 80 10 f0       	push   $0xf01080b5
f0102966:	e8 d5 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010296b:	68 08 7c 10 f0       	push   $0xf0107c08
f0102970:	68 db 80 10 f0       	push   $0xf01080db
f0102975:	68 0f 04 00 00       	push   $0x40f
f010297a:	68 b5 80 10 f0       	push   $0xf01080b5
f010297f:	e8 bc d6 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102984:	68 1f 83 10 f0       	push   $0xf010831f
f0102989:	68 db 80 10 f0       	push   $0xf01080db
f010298e:	68 11 04 00 00       	push   $0x411
f0102993:	68 b5 80 10 f0       	push   $0xf01080b5
f0102998:	e8 a3 d6 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010299d:	68 30 83 10 f0       	push   $0xf0108330
f01029a2:	68 db 80 10 f0       	push   $0xf01080db
f01029a7:	68 12 04 00 00       	push   $0x412
f01029ac:	68 b5 80 10 f0       	push   $0xf01080b5
f01029b1:	e8 8a d6 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01029b6:	68 38 7c 10 f0       	push   $0xf0107c38
f01029bb:	68 db 80 10 f0       	push   $0xf01080db
f01029c0:	68 15 04 00 00       	push   $0x415
f01029c5:	68 b5 80 10 f0       	push   $0xf01080b5
f01029ca:	e8 71 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01029cf:	68 5c 7c 10 f0       	push   $0xf0107c5c
f01029d4:	68 db 80 10 f0       	push   $0xf01080db
f01029d9:	68 19 04 00 00       	push   $0x419
f01029de:	68 b5 80 10 f0       	push   $0xf01080b5
f01029e3:	e8 58 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01029e8:	68 08 7c 10 f0       	push   $0xf0107c08
f01029ed:	68 db 80 10 f0       	push   $0xf01080db
f01029f2:	68 1a 04 00 00       	push   $0x41a
f01029f7:	68 b5 80 10 f0       	push   $0xf01080b5
f01029fc:	e8 3f d6 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102a01:	68 d6 82 10 f0       	push   $0xf01082d6
f0102a06:	68 db 80 10 f0       	push   $0xf01080db
f0102a0b:	68 1b 04 00 00       	push   $0x41b
f0102a10:	68 b5 80 10 f0       	push   $0xf01080b5
f0102a15:	e8 26 d6 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102a1a:	68 30 83 10 f0       	push   $0xf0108330
f0102a1f:	68 db 80 10 f0       	push   $0xf01080db
f0102a24:	68 1c 04 00 00       	push   $0x41c
f0102a29:	68 b5 80 10 f0       	push   $0xf01080b5
f0102a2e:	e8 0d d6 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102a33:	68 80 7c 10 f0       	push   $0xf0107c80
f0102a38:	68 db 80 10 f0       	push   $0xf01080db
f0102a3d:	68 1f 04 00 00       	push   $0x41f
f0102a42:	68 b5 80 10 f0       	push   $0xf01080b5
f0102a47:	e8 f4 d5 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f0102a4c:	68 41 83 10 f0       	push   $0xf0108341
f0102a51:	68 db 80 10 f0       	push   $0xf01080db
f0102a56:	68 20 04 00 00       	push   $0x420
f0102a5b:	68 b5 80 10 f0       	push   $0xf01080b5
f0102a60:	e8 db d5 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102a65:	68 4d 83 10 f0       	push   $0xf010834d
f0102a6a:	68 db 80 10 f0       	push   $0xf01080db
f0102a6f:	68 21 04 00 00       	push   $0x421
f0102a74:	68 b5 80 10 f0       	push   $0xf01080b5
f0102a79:	e8 c2 d5 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a7e:	68 5c 7c 10 f0       	push   $0xf0107c5c
f0102a83:	68 db 80 10 f0       	push   $0xf01080db
f0102a88:	68 25 04 00 00       	push   $0x425
f0102a8d:	68 b5 80 10 f0       	push   $0xf01080b5
f0102a92:	e8 a9 d5 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102a97:	68 b8 7c 10 f0       	push   $0xf0107cb8
f0102a9c:	68 db 80 10 f0       	push   $0xf01080db
f0102aa1:	68 26 04 00 00       	push   $0x426
f0102aa6:	68 b5 80 10 f0       	push   $0xf01080b5
f0102aab:	e8 90 d5 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102ab0:	68 62 83 10 f0       	push   $0xf0108362
f0102ab5:	68 db 80 10 f0       	push   $0xf01080db
f0102aba:	68 27 04 00 00       	push   $0x427
f0102abf:	68 b5 80 10 f0       	push   $0xf01080b5
f0102ac4:	e8 77 d5 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102ac9:	68 30 83 10 f0       	push   $0xf0108330
f0102ace:	68 db 80 10 f0       	push   $0xf01080db
f0102ad3:	68 28 04 00 00       	push   $0x428
f0102ad8:	68 b5 80 10 f0       	push   $0xf01080b5
f0102add:	e8 5e d5 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102ae2:	68 e0 7c 10 f0       	push   $0xf0107ce0
f0102ae7:	68 db 80 10 f0       	push   $0xf01080db
f0102aec:	68 2b 04 00 00       	push   $0x42b
f0102af1:	68 b5 80 10 f0       	push   $0xf01080b5
f0102af6:	e8 45 d5 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102afb:	68 84 82 10 f0       	push   $0xf0108284
f0102b00:	68 db 80 10 f0       	push   $0xf01080db
f0102b05:	68 2e 04 00 00       	push   $0x42e
f0102b0a:	68 b5 80 10 f0       	push   $0xf01080b5
f0102b0f:	e8 2c d5 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b14:	68 84 79 10 f0       	push   $0xf0107984
f0102b19:	68 db 80 10 f0       	push   $0xf01080db
f0102b1e:	68 31 04 00 00       	push   $0x431
f0102b23:	68 b5 80 10 f0       	push   $0xf01080b5
f0102b28:	e8 13 d5 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102b2d:	68 e7 82 10 f0       	push   $0xf01082e7
f0102b32:	68 db 80 10 f0       	push   $0xf01080db
f0102b37:	68 33 04 00 00       	push   $0x433
f0102b3c:	68 b5 80 10 f0       	push   $0xf01080b5
f0102b41:	e8 fa d4 ff ff       	call   f0100040 <_panic>
f0102b46:	50                   	push   %eax
f0102b47:	68 74 6f 10 f0       	push   $0xf0106f74
f0102b4c:	68 3a 04 00 00       	push   $0x43a
f0102b51:	68 b5 80 10 f0       	push   $0xf01080b5
f0102b56:	e8 e5 d4 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102b5b:	68 73 83 10 f0       	push   $0xf0108373
f0102b60:	68 db 80 10 f0       	push   $0xf01080db
f0102b65:	68 3b 04 00 00       	push   $0x43b
f0102b6a:	68 b5 80 10 f0       	push   $0xf01080b5
f0102b6f:	e8 cc d4 ff ff       	call   f0100040 <_panic>
f0102b74:	50                   	push   %eax
f0102b75:	68 74 6f 10 f0       	push   $0xf0106f74
f0102b7a:	6a 58                	push   $0x58
f0102b7c:	68 c1 80 10 f0       	push   $0xf01080c1
f0102b81:	e8 ba d4 ff ff       	call   f0100040 <_panic>
f0102b86:	50                   	push   %eax
f0102b87:	68 74 6f 10 f0       	push   $0xf0106f74
f0102b8c:	6a 58                	push   $0x58
f0102b8e:	68 c1 80 10 f0       	push   $0xf01080c1
f0102b93:	e8 a8 d4 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102b98:	68 8b 83 10 f0       	push   $0xf010838b
f0102b9d:	68 db 80 10 f0       	push   $0xf01080db
f0102ba2:	68 45 04 00 00       	push   $0x445
f0102ba7:	68 b5 80 10 f0       	push   $0xf01080b5
f0102bac:	e8 8f d4 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102bb1:	68 04 7d 10 f0       	push   $0xf0107d04
f0102bb6:	68 db 80 10 f0       	push   $0xf01080db
f0102bbb:	68 55 04 00 00       	push   $0x455
f0102bc0:	68 b5 80 10 f0       	push   $0xf01080b5
f0102bc5:	e8 76 d4 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102bca:	68 2c 7d 10 f0       	push   $0xf0107d2c
f0102bcf:	68 db 80 10 f0       	push   $0xf01080db
f0102bd4:	68 56 04 00 00       	push   $0x456
f0102bd9:	68 b5 80 10 f0       	push   $0xf01080b5
f0102bde:	e8 5d d4 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102be3:	68 54 7d 10 f0       	push   $0xf0107d54
f0102be8:	68 db 80 10 f0       	push   $0xf01080db
f0102bed:	68 58 04 00 00       	push   $0x458
f0102bf2:	68 b5 80 10 f0       	push   $0xf01080b5
f0102bf7:	e8 44 d4 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102bfc:	68 a2 83 10 f0       	push   $0xf01083a2
f0102c01:	68 db 80 10 f0       	push   $0xf01080db
f0102c06:	68 5a 04 00 00       	push   $0x45a
f0102c0b:	68 b5 80 10 f0       	push   $0xf01080b5
f0102c10:	e8 2b d4 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102c15:	68 7c 7d 10 f0       	push   $0xf0107d7c
f0102c1a:	68 db 80 10 f0       	push   $0xf01080db
f0102c1f:	68 5c 04 00 00       	push   $0x45c
f0102c24:	68 b5 80 10 f0       	push   $0xf01080b5
f0102c29:	e8 12 d4 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102c2e:	68 a0 7d 10 f0       	push   $0xf0107da0
f0102c33:	68 db 80 10 f0       	push   $0xf01080db
f0102c38:	68 5d 04 00 00       	push   $0x45d
f0102c3d:	68 b5 80 10 f0       	push   $0xf01080b5
f0102c42:	e8 f9 d3 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102c47:	68 d0 7d 10 f0       	push   $0xf0107dd0
f0102c4c:	68 db 80 10 f0       	push   $0xf01080db
f0102c51:	68 5e 04 00 00       	push   $0x45e
f0102c56:	68 b5 80 10 f0       	push   $0xf01080b5
f0102c5b:	e8 e0 d3 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102c60:	68 f4 7d 10 f0       	push   $0xf0107df4
f0102c65:	68 db 80 10 f0       	push   $0xf01080db
f0102c6a:	68 5f 04 00 00       	push   $0x45f
f0102c6f:	68 b5 80 10 f0       	push   $0xf01080b5
f0102c74:	e8 c7 d3 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102c79:	68 20 7e 10 f0       	push   $0xf0107e20
f0102c7e:	68 db 80 10 f0       	push   $0xf01080db
f0102c83:	68 61 04 00 00       	push   $0x461
f0102c88:	68 b5 80 10 f0       	push   $0xf01080b5
f0102c8d:	e8 ae d3 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102c92:	68 64 7e 10 f0       	push   $0xf0107e64
f0102c97:	68 db 80 10 f0       	push   $0xf01080db
f0102c9c:	68 62 04 00 00       	push   $0x462
f0102ca1:	68 b5 80 10 f0       	push   $0xf01080b5
f0102ca6:	e8 95 d3 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102cab:	50                   	push   %eax
f0102cac:	68 98 6f 10 f0       	push   $0xf0106f98
f0102cb1:	68 be 00 00 00       	push   $0xbe
f0102cb6:	68 b5 80 10 f0       	push   $0xf01080b5
f0102cbb:	e8 80 d3 ff ff       	call   f0100040 <_panic>
f0102cc0:	50                   	push   %eax
f0102cc1:	68 98 6f 10 f0       	push   $0xf0106f98
f0102cc6:	68 c6 00 00 00       	push   $0xc6
f0102ccb:	68 b5 80 10 f0       	push   $0xf01080b5
f0102cd0:	e8 6b d3 ff ff       	call   f0100040 <_panic>
f0102cd5:	50                   	push   %eax
f0102cd6:	68 98 6f 10 f0       	push   $0xf0106f98
f0102cdb:	68 d2 00 00 00       	push   $0xd2
f0102ce0:	68 b5 80 10 f0       	push   $0xf01080b5
f0102ce5:	e8 56 d3 ff ff       	call   f0100040 <_panic>
f0102cea:	53                   	push   %ebx
f0102ceb:	68 98 6f 10 f0       	push   $0xf0106f98
f0102cf0:	68 17 01 00 00       	push   $0x117
f0102cf5:	68 b5 80 10 f0       	push   $0xf01080b5
f0102cfa:	e8 41 d3 ff ff       	call   f0100040 <_panic>
f0102cff:	56                   	push   %esi
f0102d00:	68 98 6f 10 f0       	push   $0xf0106f98
f0102d05:	68 6c 03 00 00       	push   $0x36c
f0102d0a:	68 b5 80 10 f0       	push   $0xf01080b5
f0102d0f:	e8 2c d3 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d14:	68 98 7e 10 f0       	push   $0xf0107e98
f0102d19:	68 db 80 10 f0       	push   $0xf01080db
f0102d1e:	68 6c 03 00 00       	push   $0x36c
f0102d23:	68 b5 80 10 f0       	push   $0xf01080b5
f0102d28:	e8 13 d3 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102d2d:	a1 44 72 34 f0       	mov    0xf0347244,%eax
f0102d32:	89 45 c8             	mov    %eax,-0x38(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102d35:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102d38:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102d3d:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102d43:	89 da                	mov    %ebx,%edx
f0102d45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d48:	e8 5e e0 ff ff       	call   f0100dab <check_va2pa>
f0102d4d:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102d54:	76 45                	jbe    f0102d9b <mem_init+0x167b>
f0102d56:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102d59:	39 d0                	cmp    %edx,%eax
f0102d5b:	75 55                	jne    f0102db2 <mem_init+0x1692>
f0102d5d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102d63:	81 fb 00 00 c2 ee    	cmp    $0xeec20000,%ebx
f0102d69:	75 d8                	jne    f0102d43 <mem_init+0x1623>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102d6b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102d6e:	8b 81 00 0f 00 00    	mov    0xf00(%ecx),%eax
f0102d74:	89 c2                	mov    %eax,%edx
f0102d76:	81 e2 81 00 00 00    	and    $0x81,%edx
f0102d7c:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f0102d82:	0f 85 75 01 00 00    	jne    f0102efd <mem_init+0x17dd>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f0102d88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102d8d:	0f 85 6a 01 00 00    	jne    f0102efd <mem_init+0x17dd>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102d93:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102d96:	c1 e6 0c             	shl    $0xc,%esi
f0102d99:	eb 3f                	jmp    f0102dda <mem_init+0x16ba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d9b:	ff 75 c8             	pushl  -0x38(%ebp)
f0102d9e:	68 98 6f 10 f0       	push   $0xf0106f98
f0102da3:	68 71 03 00 00       	push   $0x371
f0102da8:	68 b5 80 10 f0       	push   $0xf01080b5
f0102dad:	e8 8e d2 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102db2:	68 cc 7e 10 f0       	push   $0xf0107ecc
f0102db7:	68 db 80 10 f0       	push   $0xf01080db
f0102dbc:	68 71 03 00 00       	push   $0x371
f0102dc1:	68 b5 80 10 f0       	push   $0xf01080b5
f0102dc6:	e8 75 d2 ff ff       	call   f0100040 <_panic>
	return PTE_ADDR(*pgdir);
f0102dcb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102dd1:	39 d0                	cmp    %edx,%eax
f0102dd3:	75 25                	jne    f0102dfa <mem_init+0x16da>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f0102dd5:	05 00 00 40 00       	add    $0x400000,%eax
f0102dda:	39 f0                	cmp    %esi,%eax
f0102ddc:	73 35                	jae    f0102e13 <mem_init+0x16f3>
	pgdir = &pgdir[PDX(va)];
f0102dde:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102de4:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0102de7:	8b 14 91             	mov    (%ecx,%edx,4),%edx
f0102dea:	89 d3                	mov    %edx,%ebx
f0102dec:	81 e3 81 00 00 00    	and    $0x81,%ebx
f0102df2:	81 fb 81 00 00 00    	cmp    $0x81,%ebx
f0102df8:	74 d1                	je     f0102dcb <mem_init+0x16ab>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0102dfa:	68 00 7f 10 f0       	push   $0xf0107f00
f0102dff:	68 db 80 10 f0       	push   $0xf01080db
f0102e04:	68 76 03 00 00       	push   $0x376
f0102e09:	68 b5 80 10 f0       	push   $0xf01080b5
f0102e0e:	e8 2d d2 ff ff       	call   f0100040 <_panic>
		cprintf("large page installed!\n");
f0102e13:	83 ec 0c             	sub    $0xc,%esp
f0102e16:	68 cd 83 10 f0       	push   $0xf01083cd
f0102e1b:	e8 63 0f 00 00       	call   f0103d83 <cprintf>
f0102e20:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e23:	b8 00 90 34 f0       	mov    $0xf0349000,%eax
f0102e28:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102e2d:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f0102e30:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e32:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102e35:	89 f3                	mov    %esi,%ebx
f0102e37:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e3a:	05 00 80 00 20       	add    $0x20008000,%eax
f0102e3f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102e42:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102e48:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e4b:	89 da                	mov    %ebx,%edx
f0102e4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e50:	e8 56 df ff ff       	call   f0100dab <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102e55:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0102e5b:	0f 86 a6 00 00 00    	jbe    f0102f07 <mem_init+0x17e7>
f0102e61:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102e64:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0102e67:	39 d0                	cmp    %edx,%eax
f0102e69:	0f 85 af 00 00 00    	jne    f0102f1e <mem_init+0x17fe>
f0102e6f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102e75:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f0102e78:	75 d1                	jne    f0102e4b <mem_init+0x172b>
f0102e7a:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102e80:	89 da                	mov    %ebx,%edx
f0102e82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e85:	e8 21 df ff ff       	call   f0100dab <check_va2pa>
f0102e8a:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102e8d:	0f 85 a4 00 00 00    	jne    f0102f37 <mem_init+0x1817>
f0102e93:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102e99:	39 f3                	cmp    %esi,%ebx
f0102e9b:	75 e3                	jne    f0102e80 <mem_init+0x1760>
f0102e9d:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102ea3:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102eaa:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f0102eb0:	81 ff 00 90 38 f0    	cmp    $0xf0389000,%edi
f0102eb6:	0f 85 76 ff ff ff    	jne    f0102e32 <mem_init+0x1712>
f0102ebc:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0102ebf:	e9 c7 00 00 00       	jmp    f0102f8b <mem_init+0x186b>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ec4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102eca:	39 f3                	cmp    %esi,%ebx
f0102ecc:	0f 83 51 ff ff ff    	jae    f0102e23 <mem_init+0x1703>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102ed2:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102edb:	e8 cb de ff ff       	call   f0100dab <check_va2pa>
f0102ee0:	39 c3                	cmp    %eax,%ebx
f0102ee2:	74 e0                	je     f0102ec4 <mem_init+0x17a4>
f0102ee4:	68 2c 7f 10 f0       	push   $0xf0107f2c
f0102ee9:	68 db 80 10 f0       	push   $0xf01080db
f0102eee:	68 7b 03 00 00       	push   $0x37b
f0102ef3:	68 b5 80 10 f0       	push   $0xf01080b5
f0102ef8:	e8 43 d1 ff ff       	call   f0100040 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102efd:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102f00:	c1 e6 0c             	shl    $0xc,%esi
f0102f03:	89 fb                	mov    %edi,%ebx
f0102f05:	eb c3                	jmp    f0102eca <mem_init+0x17aa>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f07:	ff 75 c0             	pushl  -0x40(%ebp)
f0102f0a:	68 98 6f 10 f0       	push   $0xf0106f98
f0102f0f:	68 83 03 00 00       	push   $0x383
f0102f14:	68 b5 80 10 f0       	push   $0xf01080b5
f0102f19:	e8 22 d1 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102f1e:	68 54 7f 10 f0       	push   $0xf0107f54
f0102f23:	68 db 80 10 f0       	push   $0xf01080db
f0102f28:	68 83 03 00 00       	push   $0x383
f0102f2d:	68 b5 80 10 f0       	push   $0xf01080b5
f0102f32:	e8 09 d1 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f37:	68 9c 7f 10 f0       	push   $0xf0107f9c
f0102f3c:	68 db 80 10 f0       	push   $0xf01080db
f0102f41:	68 85 03 00 00       	push   $0x385
f0102f46:	68 b5 80 10 f0       	push   $0xf01080b5
f0102f4b:	e8 f0 d0 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102f50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f53:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102f57:	75 4e                	jne    f0102fa7 <mem_init+0x1887>
f0102f59:	68 e4 83 10 f0       	push   $0xf01083e4
f0102f5e:	68 db 80 10 f0       	push   $0xf01080db
f0102f63:	68 90 03 00 00       	push   $0x390
f0102f68:	68 b5 80 10 f0       	push   $0xf01080b5
f0102f6d:	e8 ce d0 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102f72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f75:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102f78:	a8 01                	test   $0x1,%al
f0102f7a:	74 30                	je     f0102fac <mem_init+0x188c>
				assert(pgdir[i] & PTE_W);
f0102f7c:	a8 02                	test   $0x2,%al
f0102f7e:	74 45                	je     f0102fc5 <mem_init+0x18a5>
	for (i = 0; i < NPDENTRIES; i++) {
f0102f80:	83 c7 01             	add    $0x1,%edi
f0102f83:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102f89:	74 6c                	je     f0102ff7 <mem_init+0x18d7>
		switch (i) {
f0102f8b:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102f91:	83 f8 04             	cmp    $0x4,%eax
f0102f94:	76 ba                	jbe    f0102f50 <mem_init+0x1830>
			if (i >= PDX(KERNBASE)) {
f0102f96:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102f9c:	77 d4                	ja     f0102f72 <mem_init+0x1852>
				assert(pgdir[i] == 0);
f0102f9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102fa1:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102fa5:	75 37                	jne    f0102fde <mem_init+0x18be>
	for (i = 0; i < NPDENTRIES; i++) {
f0102fa7:	83 c7 01             	add    $0x1,%edi
f0102faa:	eb df                	jmp    f0102f8b <mem_init+0x186b>
				assert(pgdir[i] & PTE_P);
f0102fac:	68 e4 83 10 f0       	push   $0xf01083e4
f0102fb1:	68 db 80 10 f0       	push   $0xf01080db
f0102fb6:	68 94 03 00 00       	push   $0x394
f0102fbb:	68 b5 80 10 f0       	push   $0xf01080b5
f0102fc0:	e8 7b d0 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102fc5:	68 f5 83 10 f0       	push   $0xf01083f5
f0102fca:	68 db 80 10 f0       	push   $0xf01080db
f0102fcf:	68 95 03 00 00       	push   $0x395
f0102fd4:	68 b5 80 10 f0       	push   $0xf01080b5
f0102fd9:	e8 62 d0 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102fde:	68 06 84 10 f0       	push   $0xf0108406
f0102fe3:	68 db 80 10 f0       	push   $0xf01080db
f0102fe8:	68 97 03 00 00       	push   $0x397
f0102fed:	68 b5 80 10 f0       	push   $0xf01080b5
f0102ff2:	e8 49 d0 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102ff7:	83 ec 0c             	sub    $0xc,%esp
f0102ffa:	68 c0 7f 10 f0       	push   $0xf0107fc0
f0102fff:	e8 7f 0d 00 00       	call   f0103d83 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f0103004:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f0103007:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f010300a:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f010300d:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103012:	83 c4 10             	add    $0x10,%esp
f0103015:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010301a:	0f 86 fb 01 00 00    	jbe    f010321b <mem_init+0x1afb>
	return (physaddr_t)kva - KERNBASE;
f0103020:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103025:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0103028:	b8 00 00 00 00       	mov    $0x0,%eax
f010302d:	e8 83 de ff ff       	call   f0100eb5 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0103032:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103035:	83 e0 f3             	and    $0xfffffff3,%eax
f0103038:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f010303d:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103040:	83 ec 0c             	sub    $0xc,%esp
f0103043:	6a 00                	push   $0x0
f0103045:	e8 58 e2 ff ff       	call   f01012a2 <page_alloc>
f010304a:	89 c6                	mov    %eax,%esi
f010304c:	83 c4 10             	add    $0x10,%esp
f010304f:	85 c0                	test   %eax,%eax
f0103051:	0f 84 d9 01 00 00    	je     f0103230 <mem_init+0x1b10>
	assert((pp1 = page_alloc(0)));
f0103057:	83 ec 0c             	sub    $0xc,%esp
f010305a:	6a 00                	push   $0x0
f010305c:	e8 41 e2 ff ff       	call   f01012a2 <page_alloc>
f0103061:	89 c7                	mov    %eax,%edi
f0103063:	83 c4 10             	add    $0x10,%esp
f0103066:	85 c0                	test   %eax,%eax
f0103068:	0f 84 db 01 00 00    	je     f0103249 <mem_init+0x1b29>
	assert((pp2 = page_alloc(0)));
f010306e:	83 ec 0c             	sub    $0xc,%esp
f0103071:	6a 00                	push   $0x0
f0103073:	e8 2a e2 ff ff       	call   f01012a2 <page_alloc>
f0103078:	89 c3                	mov    %eax,%ebx
f010307a:	83 c4 10             	add    $0x10,%esp
f010307d:	85 c0                	test   %eax,%eax
f010307f:	0f 84 dd 01 00 00    	je     f0103262 <mem_init+0x1b42>
	page_free(pp0);
f0103085:	83 ec 0c             	sub    $0xc,%esp
f0103088:	56                   	push   %esi
f0103089:	e8 86 e2 ff ff       	call   f0101314 <page_free>
	return (pp - pages) << PGSHIFT;
f010308e:	89 f8                	mov    %edi,%eax
f0103090:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f0103096:	c1 f8 03             	sar    $0x3,%eax
f0103099:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010309c:	89 c2                	mov    %eax,%edx
f010309e:	c1 ea 0c             	shr    $0xc,%edx
f01030a1:	83 c4 10             	add    $0x10,%esp
f01030a4:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f01030aa:	0f 83 cb 01 00 00    	jae    f010327b <mem_init+0x1b5b>
	memset(page2kva(pp1), 1, PGSIZE);
f01030b0:	83 ec 04             	sub    $0x4,%esp
f01030b3:	68 00 10 00 00       	push   $0x1000
f01030b8:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01030ba:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01030bf:	50                   	push   %eax
f01030c0:	e8 04 32 00 00       	call   f01062c9 <memset>
	return (pp - pages) << PGSHIFT;
f01030c5:	89 d8                	mov    %ebx,%eax
f01030c7:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f01030cd:	c1 f8 03             	sar    $0x3,%eax
f01030d0:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01030d3:	89 c2                	mov    %eax,%edx
f01030d5:	c1 ea 0c             	shr    $0xc,%edx
f01030d8:	83 c4 10             	add    $0x10,%esp
f01030db:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f01030e1:	0f 83 a6 01 00 00    	jae    f010328d <mem_init+0x1b6d>
	memset(page2kva(pp2), 2, PGSIZE);
f01030e7:	83 ec 04             	sub    $0x4,%esp
f01030ea:	68 00 10 00 00       	push   $0x1000
f01030ef:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f01030f1:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01030f6:	50                   	push   %eax
f01030f7:	e8 cd 31 00 00       	call   f01062c9 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f01030fc:	6a 02                	push   $0x2
f01030fe:	68 00 10 00 00       	push   $0x1000
f0103103:	57                   	push   %edi
f0103104:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f010310a:	e8 cf e4 ff ff       	call   f01015de <page_insert>
	assert(pp1->pp_ref == 1);
f010310f:	83 c4 20             	add    $0x20,%esp
f0103112:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103117:	0f 85 82 01 00 00    	jne    f010329f <mem_init+0x1b7f>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f010311d:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0103124:	01 01 01 
f0103127:	0f 85 8b 01 00 00    	jne    f01032b8 <mem_init+0x1b98>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f010312d:	6a 02                	push   $0x2
f010312f:	68 00 10 00 00       	push   $0x1000
f0103134:	53                   	push   %ebx
f0103135:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f010313b:	e8 9e e4 ff ff       	call   f01015de <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103140:	83 c4 10             	add    $0x10,%esp
f0103143:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f010314a:	02 02 02 
f010314d:	0f 85 7e 01 00 00    	jne    f01032d1 <mem_init+0x1bb1>
	assert(pp2->pp_ref == 1);
f0103153:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103158:	0f 85 8c 01 00 00    	jne    f01032ea <mem_init+0x1bca>
	assert(pp1->pp_ref == 0);
f010315e:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103163:	0f 85 9a 01 00 00    	jne    f0103303 <mem_init+0x1be3>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103169:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103170:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0103173:	89 d8                	mov    %ebx,%eax
f0103175:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f010317b:	c1 f8 03             	sar    $0x3,%eax
f010317e:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103181:	89 c2                	mov    %eax,%edx
f0103183:	c1 ea 0c             	shr    $0xc,%edx
f0103186:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f010318c:	0f 83 8a 01 00 00    	jae    f010331c <mem_init+0x1bfc>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103192:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0103199:	03 03 03 
f010319c:	0f 85 8c 01 00 00    	jne    f010332e <mem_init+0x1c0e>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01031a2:	83 ec 08             	sub    $0x8,%esp
f01031a5:	68 00 10 00 00       	push   $0x1000
f01031aa:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f01031b0:	e8 e3 e3 ff ff       	call   f0101598 <page_remove>
	assert(pp2->pp_ref == 0);
f01031b5:	83 c4 10             	add    $0x10,%esp
f01031b8:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01031bd:	0f 85 84 01 00 00    	jne    f0103347 <mem_init+0x1c27>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01031c3:	8b 0d 8c 7e 34 f0    	mov    0xf0347e8c,%ecx
f01031c9:	8b 11                	mov    (%ecx),%edx
f01031cb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f01031d1:	89 f0                	mov    %esi,%eax
f01031d3:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f01031d9:	c1 f8 03             	sar    $0x3,%eax
f01031dc:	c1 e0 0c             	shl    $0xc,%eax
f01031df:	39 c2                	cmp    %eax,%edx
f01031e1:	0f 85 79 01 00 00    	jne    f0103360 <mem_init+0x1c40>
	kern_pgdir[0] = 0;
f01031e7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f01031ed:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01031f2:	0f 85 81 01 00 00    	jne    f0103379 <mem_init+0x1c59>
	pp0->pp_ref = 0;
f01031f8:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f01031fe:	83 ec 0c             	sub    $0xc,%esp
f0103201:	56                   	push   %esi
f0103202:	e8 0d e1 ff ff       	call   f0101314 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103207:	c7 04 24 54 80 10 f0 	movl   $0xf0108054,(%esp)
f010320e:	e8 70 0b 00 00       	call   f0103d83 <cprintf>
}
f0103213:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103216:	5b                   	pop    %ebx
f0103217:	5e                   	pop    %esi
f0103218:	5f                   	pop    %edi
f0103219:	5d                   	pop    %ebp
f010321a:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010321b:	50                   	push   %eax
f010321c:	68 98 6f 10 f0       	push   $0xf0106f98
f0103221:	68 ef 00 00 00       	push   $0xef
f0103226:	68 b5 80 10 f0       	push   $0xf01080b5
f010322b:	e8 10 ce ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0103230:	68 d9 81 10 f0       	push   $0xf01081d9
f0103235:	68 db 80 10 f0       	push   $0xf01080db
f010323a:	68 77 04 00 00       	push   $0x477
f010323f:	68 b5 80 10 f0       	push   $0xf01080b5
f0103244:	e8 f7 cd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0103249:	68 ef 81 10 f0       	push   $0xf01081ef
f010324e:	68 db 80 10 f0       	push   $0xf01080db
f0103253:	68 78 04 00 00       	push   $0x478
f0103258:	68 b5 80 10 f0       	push   $0xf01080b5
f010325d:	e8 de cd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0103262:	68 05 82 10 f0       	push   $0xf0108205
f0103267:	68 db 80 10 f0       	push   $0xf01080db
f010326c:	68 79 04 00 00       	push   $0x479
f0103271:	68 b5 80 10 f0       	push   $0xf01080b5
f0103276:	e8 c5 cd ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010327b:	50                   	push   %eax
f010327c:	68 74 6f 10 f0       	push   $0xf0106f74
f0103281:	6a 58                	push   $0x58
f0103283:	68 c1 80 10 f0       	push   $0xf01080c1
f0103288:	e8 b3 cd ff ff       	call   f0100040 <_panic>
f010328d:	50                   	push   %eax
f010328e:	68 74 6f 10 f0       	push   $0xf0106f74
f0103293:	6a 58                	push   $0x58
f0103295:	68 c1 80 10 f0       	push   $0xf01080c1
f010329a:	e8 a1 cd ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f010329f:	68 d6 82 10 f0       	push   $0xf01082d6
f01032a4:	68 db 80 10 f0       	push   $0xf01080db
f01032a9:	68 7e 04 00 00       	push   $0x47e
f01032ae:	68 b5 80 10 f0       	push   $0xf01080b5
f01032b3:	e8 88 cd ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032b8:	68 e0 7f 10 f0       	push   $0xf0107fe0
f01032bd:	68 db 80 10 f0       	push   $0xf01080db
f01032c2:	68 7f 04 00 00       	push   $0x47f
f01032c7:	68 b5 80 10 f0       	push   $0xf01080b5
f01032cc:	e8 6f cd ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01032d1:	68 04 80 10 f0       	push   $0xf0108004
f01032d6:	68 db 80 10 f0       	push   $0xf01080db
f01032db:	68 81 04 00 00       	push   $0x481
f01032e0:	68 b5 80 10 f0       	push   $0xf01080b5
f01032e5:	e8 56 cd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01032ea:	68 f8 82 10 f0       	push   $0xf01082f8
f01032ef:	68 db 80 10 f0       	push   $0xf01080db
f01032f4:	68 82 04 00 00       	push   $0x482
f01032f9:	68 b5 80 10 f0       	push   $0xf01080b5
f01032fe:	e8 3d cd ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0103303:	68 62 83 10 f0       	push   $0xf0108362
f0103308:	68 db 80 10 f0       	push   $0xf01080db
f010330d:	68 83 04 00 00       	push   $0x483
f0103312:	68 b5 80 10 f0       	push   $0xf01080b5
f0103317:	e8 24 cd ff ff       	call   f0100040 <_panic>
f010331c:	50                   	push   %eax
f010331d:	68 74 6f 10 f0       	push   $0xf0106f74
f0103322:	6a 58                	push   $0x58
f0103324:	68 c1 80 10 f0       	push   $0xf01080c1
f0103329:	e8 12 cd ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010332e:	68 28 80 10 f0       	push   $0xf0108028
f0103333:	68 db 80 10 f0       	push   $0xf01080db
f0103338:	68 85 04 00 00       	push   $0x485
f010333d:	68 b5 80 10 f0       	push   $0xf01080b5
f0103342:	e8 f9 cc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0103347:	68 30 83 10 f0       	push   $0xf0108330
f010334c:	68 db 80 10 f0       	push   $0xf01080db
f0103351:	68 87 04 00 00       	push   $0x487
f0103356:	68 b5 80 10 f0       	push   $0xf01080b5
f010335b:	e8 e0 cc ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103360:	68 84 79 10 f0       	push   $0xf0107984
f0103365:	68 db 80 10 f0       	push   $0xf01080db
f010336a:	68 8a 04 00 00       	push   $0x48a
f010336f:	68 b5 80 10 f0       	push   $0xf01080b5
f0103374:	e8 c7 cc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0103379:	68 e7 82 10 f0       	push   $0xf01082e7
f010337e:	68 db 80 10 f0       	push   $0xf01080db
f0103383:	68 8c 04 00 00       	push   $0x48c
f0103388:	68 b5 80 10 f0       	push   $0xf01080b5
f010338d:	e8 ae cc ff ff       	call   f0100040 <_panic>

f0103392 <user_mem_check>:
{
f0103392:	55                   	push   %ebp
f0103393:	89 e5                	mov    %esp,%ebp
f0103395:	57                   	push   %edi
f0103396:	56                   	push   %esi
f0103397:	53                   	push   %ebx
f0103398:	83 ec 1c             	sub    $0x1c,%esp
f010339b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	perm |= PTE_P;
f010339e:	8b 75 14             	mov    0x14(%ebp),%esi
f01033a1:	83 ce 01             	or     $0x1,%esi
	uint32_t i = (uint32_t)va; //buggy lab3 buggy
f01033a4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	uint32_t end = (uint32_t)va + len;
f01033a7:	89 df                	mov    %ebx,%edi
f01033a9:	03 7d 10             	add    0x10(%ebp),%edi
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f01033ac:	eb 19                	jmp    f01033c7 <user_mem_check+0x35>
			user_mem_check_addr = (uintptr_t)i;
f01033ae:	89 1d 3c 72 34 f0    	mov    %ebx,0xf034723c
			return -E_FAULT;
f01033b4:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01033b9:	eb 44                	jmp    f01033ff <user_mem_check+0x6d>
	for(; i < end; i=ROUNDDOWN(i+PGSIZE, PGSIZE)){
f01033bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01033c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01033c7:	39 fb                	cmp    %edi,%ebx
f01033c9:	73 3c                	jae    f0103407 <user_mem_check+0x75>
		if((uint32_t)va >= ULIM){
f01033cb:	81 7d e4 ff ff 7f ef 	cmpl   $0xef7fffff,-0x1c(%ebp)
f01033d2:	77 da                	ja     f01033ae <user_mem_check+0x1c>
		pte_t *the_pte = pgdir_walk(env->env_pgdir, (void *)i, 0);
f01033d4:	83 ec 04             	sub    $0x4,%esp
f01033d7:	6a 00                	push   $0x0
f01033d9:	53                   	push   %ebx
f01033da:	8b 45 08             	mov    0x8(%ebp),%eax
f01033dd:	ff 70 60             	pushl  0x60(%eax)
f01033e0:	e8 93 df ff ff       	call   f0101378 <pgdir_walk>
		if(!the_pte || (*the_pte & perm) != perm){//lab4 bug
f01033e5:	83 c4 10             	add    $0x10,%esp
f01033e8:	85 c0                	test   %eax,%eax
f01033ea:	74 08                	je     f01033f4 <user_mem_check+0x62>
f01033ec:	89 f2                	mov    %esi,%edx
f01033ee:	23 10                	and    (%eax),%edx
f01033f0:	39 d6                	cmp    %edx,%esi
f01033f2:	74 c7                	je     f01033bb <user_mem_check+0x29>
			user_mem_check_addr = (uintptr_t)i;
f01033f4:	89 1d 3c 72 34 f0    	mov    %ebx,0xf034723c
			return -E_FAULT;
f01033fa:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f01033ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103402:	5b                   	pop    %ebx
f0103403:	5e                   	pop    %esi
f0103404:	5f                   	pop    %edi
f0103405:	5d                   	pop    %ebp
f0103406:	c3                   	ret    
	return 0;
f0103407:	b8 00 00 00 00       	mov    $0x0,%eax
f010340c:	eb f1                	jmp    f01033ff <user_mem_check+0x6d>

f010340e <user_mem_assert>:
{
f010340e:	55                   	push   %ebp
f010340f:	89 e5                	mov    %esp,%ebp
f0103411:	53                   	push   %ebx
f0103412:	83 ec 04             	sub    $0x4,%esp
f0103415:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103418:	8b 45 14             	mov    0x14(%ebp),%eax
f010341b:	83 c8 04             	or     $0x4,%eax
f010341e:	50                   	push   %eax
f010341f:	ff 75 10             	pushl  0x10(%ebp)
f0103422:	ff 75 0c             	pushl  0xc(%ebp)
f0103425:	53                   	push   %ebx
f0103426:	e8 67 ff ff ff       	call   f0103392 <user_mem_check>
f010342b:	83 c4 10             	add    $0x10,%esp
f010342e:	85 c0                	test   %eax,%eax
f0103430:	78 05                	js     f0103437 <user_mem_assert+0x29>
}
f0103432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103435:	c9                   	leave  
f0103436:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103437:	83 ec 04             	sub    $0x4,%esp
f010343a:	ff 35 3c 72 34 f0    	pushl  0xf034723c
f0103440:	ff 73 48             	pushl  0x48(%ebx)
f0103443:	68 80 80 10 f0       	push   $0xf0108080
f0103448:	e8 36 09 00 00       	call   f0103d83 <cprintf>
		env_destroy(env);	// may not return
f010344d:	89 1c 24             	mov    %ebx,(%esp)
f0103450:	e8 d9 05 00 00       	call   f0103a2e <env_destroy>
f0103455:	83 c4 10             	add    $0x10,%esp
}
f0103458:	eb d8                	jmp    f0103432 <user_mem_assert+0x24>

f010345a <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f010345a:	55                   	push   %ebp
f010345b:	89 e5                	mov    %esp,%ebp
f010345d:	57                   	push   %edi
f010345e:	56                   	push   %esi
f010345f:	53                   	push   %ebx
f0103460:	83 ec 0c             	sub    $0xc,%esp
f0103463:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	int i = ROUNDDOWN((uint32_t)va, PGSIZE);
f0103465:	89 d3                	mov    %edx,%ebx
f0103467:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)va + len, PGSIZE);
f010346d:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0103474:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(; i < end; i+=PGSIZE){
f010347a:	39 f3                	cmp    %esi,%ebx
f010347c:	7d 5a                	jge    f01034d8 <region_alloc+0x7e>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f010347e:	83 ec 0c             	sub    $0xc,%esp
f0103481:	6a 01                	push   $0x1
f0103483:	e8 1a de ff ff       	call   f01012a2 <page_alloc>
		if(!page)
f0103488:	83 c4 10             	add    $0x10,%esp
f010348b:	85 c0                	test   %eax,%eax
f010348d:	74 1b                	je     f01034aa <region_alloc+0x50>
			panic("there is no page\n");
		int ret = page_insert(e->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f010348f:	6a 06                	push   $0x6
f0103491:	53                   	push   %ebx
f0103492:	50                   	push   %eax
f0103493:	ff 77 60             	pushl  0x60(%edi)
f0103496:	e8 43 e1 ff ff       	call   f01015de <page_insert>
		if(ret)
f010349b:	83 c4 10             	add    $0x10,%esp
f010349e:	85 c0                	test   %eax,%eax
f01034a0:	75 1f                	jne    f01034c1 <region_alloc+0x67>
	for(; i < end; i+=PGSIZE){
f01034a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01034a8:	eb d0                	jmp    f010347a <region_alloc+0x20>
			panic("there is no page\n");
f01034aa:	83 ec 04             	sub    $0x4,%esp
f01034ad:	68 24 84 10 f0       	push   $0xf0108424
f01034b2:	68 27 01 00 00       	push   $0x127
f01034b7:	68 36 84 10 f0       	push   $0xf0108436
f01034bc:	e8 7f cb ff ff       	call   f0100040 <_panic>
			panic("there is error in insert");
f01034c1:	83 ec 04             	sub    $0x4,%esp
f01034c4:	68 41 84 10 f0       	push   $0xf0108441
f01034c9:	68 2a 01 00 00       	push   $0x12a
f01034ce:	68 36 84 10 f0       	push   $0xf0108436
f01034d3:	e8 68 cb ff ff       	call   f0100040 <_panic>
	}
}
f01034d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01034db:	5b                   	pop    %ebx
f01034dc:	5e                   	pop    %esi
f01034dd:	5f                   	pop    %edi
f01034de:	5d                   	pop    %ebp
f01034df:	c3                   	ret    

f01034e0 <envid2env>:
{
f01034e0:	55                   	push   %ebp
f01034e1:	89 e5                	mov    %esp,%ebp
f01034e3:	56                   	push   %esi
f01034e4:	53                   	push   %ebx
f01034e5:	8b 75 08             	mov    0x8(%ebp),%esi
f01034e8:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f01034eb:	85 f6                	test   %esi,%esi
f01034ed:	74 2e                	je     f010351d <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f01034ef:	89 f3                	mov    %esi,%ebx
f01034f1:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f01034f7:	c1 e3 07             	shl    $0x7,%ebx
f01034fa:	03 1d 44 72 34 f0    	add    0xf0347244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103500:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103504:	74 2e                	je     f0103534 <envid2env+0x54>
f0103506:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103509:	75 29                	jne    f0103534 <envid2env+0x54>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010350b:	84 c0                	test   %al,%al
f010350d:	75 35                	jne    f0103544 <envid2env+0x64>
	*env_store = e;
f010350f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103512:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103514:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103519:	5b                   	pop    %ebx
f010351a:	5e                   	pop    %esi
f010351b:	5d                   	pop    %ebp
f010351c:	c3                   	ret    
		*env_store = curenv;
f010351d:	e8 a8 33 00 00       	call   f01068ca <cpunum>
f0103522:	6b c0 74             	imul   $0x74,%eax,%eax
f0103525:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f010352b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010352e:	89 02                	mov    %eax,(%edx)
		return 0;
f0103530:	89 f0                	mov    %esi,%eax
f0103532:	eb e5                	jmp    f0103519 <envid2env+0x39>
		*env_store = 0;
f0103534:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010353d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103542:	eb d5                	jmp    f0103519 <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103544:	e8 81 33 00 00       	call   f01068ca <cpunum>
f0103549:	6b c0 74             	imul   $0x74,%eax,%eax
f010354c:	39 98 28 80 34 f0    	cmp    %ebx,-0xfcb7fd8(%eax)
f0103552:	74 bb                	je     f010350f <envid2env+0x2f>
f0103554:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103557:	e8 6e 33 00 00       	call   f01068ca <cpunum>
f010355c:	6b c0 74             	imul   $0x74,%eax,%eax
f010355f:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0103565:	3b 70 48             	cmp    0x48(%eax),%esi
f0103568:	74 a5                	je     f010350f <envid2env+0x2f>
		*env_store = 0;
f010356a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010356d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103573:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103578:	eb 9f                	jmp    f0103519 <envid2env+0x39>

f010357a <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f010357a:	b8 20 53 12 f0       	mov    $0xf0125320,%eax
f010357f:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103582:	b8 23 00 00 00       	mov    $0x23,%eax
f0103587:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103589:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f010358b:	b8 10 00 00 00       	mov    $0x10,%eax
f0103590:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103592:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103594:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103596:	ea 9d 35 10 f0 08 00 	ljmp   $0x8,$0xf010359d
	asm volatile("lldt %0" : : "r" (sel));
f010359d:	b8 00 00 00 00       	mov    $0x0,%eax
f01035a2:	0f 00 d0             	lldt   %ax
}
f01035a5:	c3                   	ret    

f01035a6 <env_init>:
{
f01035a6:	55                   	push   %ebp
f01035a7:	89 e5                	mov    %esp,%ebp
f01035a9:	83 ec 08             	sub    $0x8,%esp
		envs[i].env_id = 0;
f01035ac:	8b 15 44 72 34 f0    	mov    0xf0347244,%edx
f01035b2:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
f01035b8:	81 c2 00 00 02 00    	add    $0x20000,%edx
f01035be:	c7 40 c8 00 00 00 00 	movl   $0x0,-0x38(%eax)
		envs[i].env_link = &envs[i+1];
f01035c5:	89 40 c4             	mov    %eax,-0x3c(%eax)
f01035c8:	83 e8 80             	sub    $0xffffff80,%eax
	for(int i = 0; i < NENV - 1; i++){
f01035cb:	39 d0                	cmp    %edx,%eax
f01035cd:	75 ef                	jne    f01035be <env_init+0x18>
	env_free_list = envs;
f01035cf:	a1 44 72 34 f0       	mov    0xf0347244,%eax
f01035d4:	a3 48 72 34 f0       	mov    %eax,0xf0347248
	env_init_percpu();
f01035d9:	e8 9c ff ff ff       	call   f010357a <env_init_percpu>
}
f01035de:	c9                   	leave  
f01035df:	c3                   	ret    

f01035e0 <env_alloc>:
{
f01035e0:	55                   	push   %ebp
f01035e1:	89 e5                	mov    %esp,%ebp
f01035e3:	53                   	push   %ebx
f01035e4:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f01035e7:	8b 1d 48 72 34 f0    	mov    0xf0347248,%ebx
f01035ed:	85 db                	test   %ebx,%ebx
f01035ef:	0f 84 39 01 00 00    	je     f010372e <env_alloc+0x14e>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01035f5:	83 ec 0c             	sub    $0xc,%esp
f01035f8:	6a 01                	push   $0x1
f01035fa:	e8 a3 dc ff ff       	call   f01012a2 <page_alloc>
f01035ff:	83 c4 10             	add    $0x10,%esp
f0103602:	85 c0                	test   %eax,%eax
f0103604:	0f 84 2b 01 00 00    	je     f0103735 <env_alloc+0x155>
	p->pp_ref++;
f010360a:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010360f:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f0103615:	c1 f8 03             	sar    $0x3,%eax
f0103618:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010361b:	89 c2                	mov    %eax,%edx
f010361d:	c1 ea 0c             	shr    $0xc,%edx
f0103620:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f0103626:	0f 83 db 00 00 00    	jae    f0103707 <env_alloc+0x127>
	return (void *)(pa + KERNBASE);
f010362c:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = (pde_t *)page2kva(p);
f0103631:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy((void *)e->env_pgdir, (void *)kern_pgdir, PGSIZE);
f0103634:	83 ec 04             	sub    $0x4,%esp
f0103637:	68 00 10 00 00       	push   $0x1000
f010363c:	ff 35 8c 7e 34 f0    	pushl  0xf0347e8c
f0103642:	50                   	push   %eax
f0103643:	e8 2b 2d 00 00       	call   f0106373 <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103648:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010364b:	83 c4 10             	add    $0x10,%esp
f010364e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103653:	0f 86 c0 00 00 00    	jbe    f0103719 <env_alloc+0x139>
	return (physaddr_t)kva - KERNBASE;
f0103659:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010365f:	83 ca 05             	or     $0x5,%edx
f0103662:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103668:	8b 43 48             	mov    0x48(%ebx),%eax
f010366b:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103670:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103675:	ba 00 10 00 00       	mov    $0x1000,%edx
f010367a:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f010367d:	89 da                	mov    %ebx,%edx
f010367f:	2b 15 44 72 34 f0    	sub    0xf0347244,%edx
f0103685:	c1 fa 07             	sar    $0x7,%edx
f0103688:	09 d0                	or     %edx,%eax
f010368a:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f010368d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103690:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103693:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f010369a:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01036a1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_sbrk = 0;
f01036a8:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01036af:	83 ec 04             	sub    $0x4,%esp
f01036b2:	6a 44                	push   $0x44
f01036b4:	6a 00                	push   $0x0
f01036b6:	53                   	push   %ebx
f01036b7:	e8 0d 2c 00 00       	call   f01062c9 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01036bc:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01036c2:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01036c8:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01036ce:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01036d5:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f01036db:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f01036e2:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f01036e9:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f01036ed:	8b 43 44             	mov    0x44(%ebx),%eax
f01036f0:	a3 48 72 34 f0       	mov    %eax,0xf0347248
	*newenv_store = e;
f01036f5:	8b 45 08             	mov    0x8(%ebp),%eax
f01036f8:	89 18                	mov    %ebx,(%eax)
	return 0;
f01036fa:	83 c4 10             	add    $0x10,%esp
f01036fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103705:	c9                   	leave  
f0103706:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103707:	50                   	push   %eax
f0103708:	68 74 6f 10 f0       	push   $0xf0106f74
f010370d:	6a 58                	push   $0x58
f010370f:	68 c1 80 10 f0       	push   $0xf01080c1
f0103714:	e8 27 c9 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103719:	50                   	push   %eax
f010371a:	68 98 6f 10 f0       	push   $0xf0106f98
f010371f:	68 c3 00 00 00       	push   $0xc3
f0103724:	68 36 84 10 f0       	push   $0xf0108436
f0103729:	e8 12 c9 ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f010372e:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103733:	eb cd                	jmp    f0103702 <env_alloc+0x122>
		return -E_NO_MEM;
f0103735:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010373a:	eb c6                	jmp    f0103702 <env_alloc+0x122>

f010373c <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f010373c:	55                   	push   %ebp
f010373d:	89 e5                	mov    %esp,%ebp
f010373f:	57                   	push   %edi
f0103740:	56                   	push   %esi
f0103741:	53                   	push   %ebx
f0103742:	83 ec 34             	sub    $0x34,%esp
f0103745:	8b 7d 08             	mov    0x8(%ebp),%edi

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	
	struct Env *e;
	int ret = env_alloc(&e, 0);
f0103748:	6a 00                	push   $0x0
f010374a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010374d:	50                   	push   %eax
f010374e:	e8 8d fe ff ff       	call   f01035e0 <env_alloc>
	if(ret)
f0103753:	83 c4 10             	add    $0x10,%esp
f0103756:	85 c0                	test   %eax,%eax
f0103758:	75 47                	jne    f01037a1 <env_create+0x65>
		panic("env_alloc failed\n");
	e->env_parent_id = 0;
f010375a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010375d:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
	e->env_type = type;
f0103764:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103767:	89 46 50             	mov    %eax,0x50(%esi)
	if (elf->e_magic != ELF_MAGIC)
f010376a:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f0103770:	75 46                	jne    f01037b8 <env_create+0x7c>
	ph = (struct Proghdr *) (binary + elf->e_phoff);
f0103772:	89 fb                	mov    %edi,%ebx
f0103774:	03 5f 1c             	add    0x1c(%edi),%ebx
	eph = ph + elf->e_phnum;
f0103777:	0f b7 47 2c          	movzwl 0x2c(%edi),%eax
f010377b:	c1 e0 05             	shl    $0x5,%eax
f010377e:	01 d8                	add    %ebx,%eax
f0103780:	89 45 d0             	mov    %eax,-0x30(%ebp)
	lcr3(PADDR(e->env_pgdir));
f0103783:	8b 46 60             	mov    0x60(%esi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103786:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010378b:	76 42                	jbe    f01037cf <env_create+0x93>
	return (physaddr_t)kva - KERNBASE;
f010378d:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103792:	0f 22 d8             	mov    %eax,%cr3
	uint32_t elf_load_sz = 0;
f0103795:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f010379c:	e9 80 00 00 00       	jmp    f0103821 <env_create+0xe5>
		panic("env_alloc failed\n");
f01037a1:	83 ec 04             	sub    $0x4,%esp
f01037a4:	68 5a 84 10 f0       	push   $0xf010845a
f01037a9:	68 9b 01 00 00       	push   $0x19b
f01037ae:	68 36 84 10 f0       	push   $0xf0108436
f01037b3:	e8 88 c8 ff ff       	call   f0100040 <_panic>
		panic("is this a valid ELF");
f01037b8:	83 ec 04             	sub    $0x4,%esp
f01037bb:	68 6c 84 10 f0       	push   $0xf010846c
f01037c0:	68 71 01 00 00       	push   $0x171
f01037c5:	68 36 84 10 f0       	push   $0xf0108436
f01037ca:	e8 71 c8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01037cf:	50                   	push   %eax
f01037d0:	68 98 6f 10 f0       	push   $0xf0106f98
f01037d5:	68 76 01 00 00       	push   $0x176
f01037da:	68 36 84 10 f0       	push   $0xf0108436
f01037df:	e8 5c c8 ff ff       	call   f0100040 <_panic>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f01037e4:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01037e7:	8b 53 08             	mov    0x8(%ebx),%edx
f01037ea:	89 f0                	mov    %esi,%eax
f01037ec:	e8 69 fc ff ff       	call   f010345a <region_alloc>
			memset((void *)ph->p_va, 0, ph->p_memsz);
f01037f1:	83 ec 04             	sub    $0x4,%esp
f01037f4:	ff 73 14             	pushl  0x14(%ebx)
f01037f7:	6a 00                	push   $0x0
f01037f9:	ff 73 08             	pushl  0x8(%ebx)
f01037fc:	e8 c8 2a 00 00       	call   f01062c9 <memset>
			memcpy((void *)ph->p_va, (void *)binary + ph->p_offset, ph->p_filesz);
f0103801:	83 c4 0c             	add    $0xc,%esp
f0103804:	ff 73 10             	pushl  0x10(%ebx)
f0103807:	89 f8                	mov    %edi,%eax
f0103809:	03 43 04             	add    0x4(%ebx),%eax
f010380c:	50                   	push   %eax
f010380d:	ff 73 08             	pushl  0x8(%ebx)
f0103810:	e8 5e 2b 00 00       	call   f0106373 <memcpy>
			elf_load_sz += ph->p_memsz;
f0103815:	8b 53 14             	mov    0x14(%ebx),%edx
f0103818:	01 55 d4             	add    %edx,-0x2c(%ebp)
f010381b:	83 c4 10             	add    $0x10,%esp
	for (; ph < eph; ph++){
f010381e:	83 c3 20             	add    $0x20,%ebx
f0103821:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0103824:	76 07                	jbe    f010382d <env_create+0xf1>
		if(ph->p_type == ELF_PROG_LOAD){
f0103826:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103829:	75 f3                	jne    f010381e <env_create+0xe2>
f010382b:	eb b7                	jmp    f01037e4 <env_create+0xa8>
	e->env_tf.tf_eip = elf->e_entry;
f010382d:	8b 47 18             	mov    0x18(%edi),%eax
f0103830:	89 46 30             	mov    %eax,0x30(%esi)
	e->env_sbrk = UTEXT + elf_load_sz;
f0103833:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103836:	05 00 00 80 00       	add    $0x800000,%eax
f010383b:	89 46 7c             	mov    %eax,0x7c(%esi)
	region_alloc(e, (void*)(USTACKTOP-PGSIZE), PGSIZE);
f010383e:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103843:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103848:	89 f0                	mov    %esi,%eax
f010384a:	e8 0b fc ff ff       	call   f010345a <region_alloc>
	lcr3(PADDR(kern_pgdir));
f010384f:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103854:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103859:	76 10                	jbe    f010386b <env_create+0x12f>
	return (physaddr_t)kva - KERNBASE;
f010385b:	05 00 00 00 10       	add    $0x10000000,%eax
f0103860:	0f 22 d8             	mov    %eax,%cr3
	load_icode(e, binary);
}
f0103863:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103866:	5b                   	pop    %ebx
f0103867:	5e                   	pop    %esi
f0103868:	5f                   	pop    %edi
f0103869:	5d                   	pop    %ebp
f010386a:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010386b:	50                   	push   %eax
f010386c:	68 98 6f 10 f0       	push   $0xf0106f98
f0103871:	68 86 01 00 00       	push   $0x186
f0103876:	68 36 84 10 f0       	push   $0xf0108436
f010387b:	e8 c0 c7 ff ff       	call   f0100040 <_panic>

f0103880 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103880:	55                   	push   %ebp
f0103881:	89 e5                	mov    %esp,%ebp
f0103883:	57                   	push   %edi
f0103884:	56                   	push   %esi
f0103885:	53                   	push   %ebx
f0103886:	83 ec 1c             	sub    $0x1c,%esp
f0103889:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f010388c:	e8 39 30 00 00       	call   f01068ca <cpunum>
f0103891:	6b c0 74             	imul   $0x74,%eax,%eax
f0103894:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010389b:	39 b8 28 80 34 f0    	cmp    %edi,-0xfcb7fd8(%eax)
f01038a1:	0f 85 b3 00 00 00    	jne    f010395a <env_free+0xda>
		lcr3(PADDR(kern_pgdir));
f01038a7:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01038ac:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01038b1:	76 14                	jbe    f01038c7 <env_free+0x47>
	return (physaddr_t)kva - KERNBASE;
f01038b3:	05 00 00 00 10       	add    $0x10000000,%eax
f01038b8:	0f 22 d8             	mov    %eax,%cr3
f01038bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01038c2:	e9 93 00 00 00       	jmp    f010395a <env_free+0xda>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01038c7:	50                   	push   %eax
f01038c8:	68 98 6f 10 f0       	push   $0xf0106f98
f01038cd:	68 af 01 00 00       	push   $0x1af
f01038d2:	68 36 84 10 f0       	push   $0xf0108436
f01038d7:	e8 64 c7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01038dc:	56                   	push   %esi
f01038dd:	68 74 6f 10 f0       	push   $0xf0106f74
f01038e2:	68 be 01 00 00       	push   $0x1be
f01038e7:	68 36 84 10 f0       	push   $0xf0108436
f01038ec:	e8 4f c7 ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01038f1:	83 ec 08             	sub    $0x8,%esp
f01038f4:	89 d8                	mov    %ebx,%eax
f01038f6:	c1 e0 0c             	shl    $0xc,%eax
f01038f9:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01038fc:	50                   	push   %eax
f01038fd:	ff 77 60             	pushl  0x60(%edi)
f0103900:	e8 93 dc ff ff       	call   f0101598 <page_remove>
f0103905:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103908:	83 c3 01             	add    $0x1,%ebx
f010390b:	83 c6 04             	add    $0x4,%esi
f010390e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103914:	74 07                	je     f010391d <env_free+0x9d>
			if (pt[pteno] & PTE_P)
f0103916:	f6 06 01             	testb  $0x1,(%esi)
f0103919:	74 ed                	je     f0103908 <env_free+0x88>
f010391b:	eb d4                	jmp    f01038f1 <env_free+0x71>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f010391d:	8b 47 60             	mov    0x60(%edi),%eax
f0103920:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103923:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f010392a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010392d:	3b 05 88 7e 34 f0    	cmp    0xf0347e88,%eax
f0103933:	73 69                	jae    f010399e <env_free+0x11e>
		page_decref(pa2page(pa));
f0103935:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103938:	a1 90 7e 34 f0       	mov    0xf0347e90,%eax
f010393d:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103940:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103943:	50                   	push   %eax
f0103944:	e8 06 da ff ff       	call   f010134f <page_decref>
f0103949:	83 c4 10             	add    $0x10,%esp
f010394c:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103950:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103953:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103958:	74 58                	je     f01039b2 <env_free+0x132>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010395a:	8b 47 60             	mov    0x60(%edi),%eax
f010395d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103960:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0103963:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103969:	74 e1                	je     f010394c <env_free+0xcc>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010396b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103971:	89 f0                	mov    %esi,%eax
f0103973:	c1 e8 0c             	shr    $0xc,%eax
f0103976:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103979:	39 05 88 7e 34 f0    	cmp    %eax,0xf0347e88
f010397f:	0f 86 57 ff ff ff    	jbe    f01038dc <env_free+0x5c>
	return (void *)(pa + KERNBASE);
f0103985:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f010398b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010398e:	c1 e0 14             	shl    $0x14,%eax
f0103991:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103994:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103999:	e9 78 ff ff ff       	jmp    f0103916 <env_free+0x96>
		panic("pa2page called with invalid pa");
f010399e:	83 ec 04             	sub    $0x4,%esp
f01039a1:	68 50 78 10 f0       	push   $0xf0107850
f01039a6:	6a 51                	push   $0x51
f01039a8:	68 c1 80 10 f0       	push   $0xf01080c1
f01039ad:	e8 8e c6 ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01039b2:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f01039b5:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039ba:	76 49                	jbe    f0103a05 <env_free+0x185>
	e->env_pgdir = 0;
f01039bc:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f01039c3:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01039c8:	c1 e8 0c             	shr    $0xc,%eax
f01039cb:	3b 05 88 7e 34 f0    	cmp    0xf0347e88,%eax
f01039d1:	73 47                	jae    f0103a1a <env_free+0x19a>
	page_decref(pa2page(pa));
f01039d3:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01039d6:	8b 15 90 7e 34 f0    	mov    0xf0347e90,%edx
f01039dc:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01039df:	50                   	push   %eax
f01039e0:	e8 6a d9 ff ff       	call   f010134f <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01039e5:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01039ec:	a1 48 72 34 f0       	mov    0xf0347248,%eax
f01039f1:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f01039f4:	89 3d 48 72 34 f0    	mov    %edi,0xf0347248
}
f01039fa:	83 c4 10             	add    $0x10,%esp
f01039fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103a00:	5b                   	pop    %ebx
f0103a01:	5e                   	pop    %esi
f0103a02:	5f                   	pop    %edi
f0103a03:	5d                   	pop    %ebp
f0103a04:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103a05:	50                   	push   %eax
f0103a06:	68 98 6f 10 f0       	push   $0xf0106f98
f0103a0b:	68 cc 01 00 00       	push   $0x1cc
f0103a10:	68 36 84 10 f0       	push   $0xf0108436
f0103a15:	e8 26 c6 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103a1a:	83 ec 04             	sub    $0x4,%esp
f0103a1d:	68 50 78 10 f0       	push   $0xf0107850
f0103a22:	6a 51                	push   $0x51
f0103a24:	68 c1 80 10 f0       	push   $0xf01080c1
f0103a29:	e8 12 c6 ff ff       	call   f0100040 <_panic>

f0103a2e <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103a2e:	55                   	push   %ebp
f0103a2f:	89 e5                	mov    %esp,%ebp
f0103a31:	53                   	push   %ebx
f0103a32:	83 ec 04             	sub    $0x4,%esp
f0103a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103a38:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103a3c:	74 21                	je     f0103a5f <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103a3e:	83 ec 0c             	sub    $0xc,%esp
f0103a41:	53                   	push   %ebx
f0103a42:	e8 39 fe ff ff       	call   f0103880 <env_free>

	if (curenv == e) {
f0103a47:	e8 7e 2e 00 00       	call   f01068ca <cpunum>
f0103a4c:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a4f:	83 c4 10             	add    $0x10,%esp
f0103a52:	39 98 28 80 34 f0    	cmp    %ebx,-0xfcb7fd8(%eax)
f0103a58:	74 1e                	je     f0103a78 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f0103a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103a5d:	c9                   	leave  
f0103a5e:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103a5f:	e8 66 2e 00 00       	call   f01068ca <cpunum>
f0103a64:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a67:	39 98 28 80 34 f0    	cmp    %ebx,-0xfcb7fd8(%eax)
f0103a6d:	74 cf                	je     f0103a3e <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103a6f:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103a76:	eb e2                	jmp    f0103a5a <env_destroy+0x2c>
		curenv = NULL;
f0103a78:	e8 4d 2e 00 00       	call   f01068ca <cpunum>
f0103a7d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a80:	c7 80 28 80 34 f0 00 	movl   $0x0,-0xfcb7fd8(%eax)
f0103a87:	00 00 00 
		sched_yield();
f0103a8a:	e8 b3 12 00 00       	call   f0104d42 <sched_yield>

f0103a8f <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103a8f:	55                   	push   %ebp
f0103a90:	89 e5                	mov    %esp,%ebp
f0103a92:	53                   	push   %ebx
f0103a93:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103a96:	e8 2f 2e 00 00       	call   f01068ca <cpunum>
f0103a9b:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a9e:	8b 98 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%ebx
f0103aa4:	e8 21 2e 00 00       	call   f01068ca <cpunum>
f0103aa9:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f0103aac:	8b 65 08             	mov    0x8(%ebp),%esp
f0103aaf:	61                   	popa   
f0103ab0:	07                   	pop    %es
f0103ab1:	1f                   	pop    %ds
f0103ab2:	83 c4 08             	add    $0x8,%esp
f0103ab5:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103ab6:	83 ec 04             	sub    $0x4,%esp
f0103ab9:	68 80 84 10 f0       	push   $0xf0108480
f0103abe:	68 03 02 00 00       	push   $0x203
f0103ac3:	68 36 84 10 f0       	push   $0xf0108436
f0103ac8:	e8 73 c5 ff ff       	call   f0100040 <_panic>

f0103acd <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103acd:	55                   	push   %ebp
f0103ace:	89 e5                	mov    %esp,%ebp
f0103ad0:	53                   	push   %ebx
f0103ad1:	83 ec 04             	sub    $0x4,%esp
f0103ad4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv != e){//lab4 bug
f0103ad7:	e8 ee 2d 00 00       	call   f01068ca <cpunum>
f0103adc:	6b c0 74             	imul   $0x74,%eax,%eax
f0103adf:	39 98 28 80 34 f0    	cmp    %ebx,-0xfcb7fd8(%eax)
f0103ae5:	74 7e                	je     f0103b65 <env_run+0x98>
		if(curenv && curenv->env_status == ENV_RUNNING)
f0103ae7:	e8 de 2d 00 00       	call   f01068ca <cpunum>
f0103aec:	6b c0 74             	imul   $0x74,%eax,%eax
f0103aef:	83 b8 28 80 34 f0 00 	cmpl   $0x0,-0xfcb7fd8(%eax)
f0103af6:	74 18                	je     f0103b10 <env_run+0x43>
f0103af8:	e8 cd 2d 00 00       	call   f01068ca <cpunum>
f0103afd:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b00:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0103b06:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103b0a:	0f 84 9a 00 00 00    	je     f0103baa <env_run+0xdd>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f0103b10:	e8 b5 2d 00 00       	call   f01068ca <cpunum>
f0103b15:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b18:	89 98 28 80 34 f0    	mov    %ebx,-0xfcb7fd8(%eax)
		curenv->env_status = ENV_RUNNING;
f0103b1e:	e8 a7 2d 00 00       	call   f01068ca <cpunum>
f0103b23:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b26:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0103b2c:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f0103b33:	e8 92 2d 00 00       	call   f01068ca <cpunum>
f0103b38:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b3b:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0103b41:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f0103b45:	e8 80 2d 00 00       	call   f01068ca <cpunum>
f0103b4a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b4d:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0103b53:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103b56:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103b5b:	76 67                	jbe    f0103bc4 <env_run+0xf7>
	return (physaddr_t)kva - KERNBASE;
f0103b5d:	05 00 00 00 10       	add    $0x10000000,%eax
f0103b62:	0f 22 d8             	mov    %eax,%cr3
	}
	lcr3(PADDR(curenv->env_pgdir));
f0103b65:	e8 60 2d 00 00       	call   f01068ca <cpunum>
f0103b6a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b6d:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0103b73:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103b76:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103b7b:	76 5c                	jbe    f0103bd9 <env_run+0x10c>
	return (physaddr_t)kva - KERNBASE;
f0103b7d:	05 00 00 00 10       	add    $0x10000000,%eax
f0103b82:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103b85:	83 ec 0c             	sub    $0xc,%esp
f0103b88:	68 c0 53 12 f0       	push   $0xf01253c0
f0103b8d:	e8 44 30 00 00       	call   f0106bd6 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103b92:	f3 90                	pause  
	unlock_kernel(); //lab4 bug?
	env_pop_tf(&curenv->env_tf);
f0103b94:	e8 31 2d 00 00       	call   f01068ca <cpunum>
f0103b99:	83 c4 04             	add    $0x4,%esp
f0103b9c:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b9f:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0103ba5:	e8 e5 fe ff ff       	call   f0103a8f <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f0103baa:	e8 1b 2d 00 00       	call   f01068ca <cpunum>
f0103baf:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bb2:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0103bb8:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103bbf:	e9 4c ff ff ff       	jmp    f0103b10 <env_run+0x43>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bc4:	50                   	push   %eax
f0103bc5:	68 98 6f 10 f0       	push   $0xf0106f98
f0103bca:	68 27 02 00 00       	push   $0x227
f0103bcf:	68 36 84 10 f0       	push   $0xf0108436
f0103bd4:	e8 67 c4 ff ff       	call   f0100040 <_panic>
f0103bd9:	50                   	push   %eax
f0103bda:	68 98 6f 10 f0       	push   $0xf0106f98
f0103bdf:	68 29 02 00 00       	push   $0x229
f0103be4:	68 36 84 10 f0       	push   $0xf0108436
f0103be9:	e8 52 c4 ff ff       	call   f0100040 <_panic>

f0103bee <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103bee:	55                   	push   %ebp
f0103bef:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103bf1:	8b 45 08             	mov    0x8(%ebp),%eax
f0103bf4:	ba 70 00 00 00       	mov    $0x70,%edx
f0103bf9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103bfa:	ba 71 00 00 00       	mov    $0x71,%edx
f0103bff:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103c00:	0f b6 c0             	movzbl %al,%eax
}
f0103c03:	5d                   	pop    %ebp
f0103c04:	c3                   	ret    

f0103c05 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103c05:	55                   	push   %ebp
f0103c06:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103c08:	8b 45 08             	mov    0x8(%ebp),%eax
f0103c0b:	ba 70 00 00 00       	mov    $0x70,%edx
f0103c10:	ee                   	out    %al,(%dx)
f0103c11:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c14:	ba 71 00 00 00       	mov    $0x71,%edx
f0103c19:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103c1a:	5d                   	pop    %ebp
f0103c1b:	c3                   	ret    

f0103c1c <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103c1c:	55                   	push   %ebp
f0103c1d:	89 e5                	mov    %esp,%ebp
f0103c1f:	56                   	push   %esi
f0103c20:	53                   	push   %ebx
f0103c21:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103c24:	66 a3 a8 53 12 f0    	mov    %ax,0xf01253a8
	if (!didinit)
f0103c2a:	80 3d 4c 72 34 f0 00 	cmpb   $0x0,0xf034724c
f0103c31:	75 07                	jne    f0103c3a <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103c36:	5b                   	pop    %ebx
f0103c37:	5e                   	pop    %esi
f0103c38:	5d                   	pop    %ebp
f0103c39:	c3                   	ret    
f0103c3a:	89 c6                	mov    %eax,%esi
f0103c3c:	ba 21 00 00 00       	mov    $0x21,%edx
f0103c41:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103c42:	66 c1 e8 08          	shr    $0x8,%ax
f0103c46:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103c4b:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103c4c:	83 ec 0c             	sub    $0xc,%esp
f0103c4f:	68 8c 84 10 f0       	push   $0xf010848c
f0103c54:	e8 2a 01 00 00       	call   f0103d83 <cprintf>
f0103c59:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103c5c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103c61:	0f b7 f6             	movzwl %si,%esi
f0103c64:	f7 d6                	not    %esi
f0103c66:	eb 19                	jmp    f0103c81 <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f0103c68:	83 ec 08             	sub    $0x8,%esp
f0103c6b:	53                   	push   %ebx
f0103c6c:	68 ab 8b 10 f0       	push   $0xf0108bab
f0103c71:	e8 0d 01 00 00       	call   f0103d83 <cprintf>
f0103c76:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103c79:	83 c3 01             	add    $0x1,%ebx
f0103c7c:	83 fb 10             	cmp    $0x10,%ebx
f0103c7f:	74 07                	je     f0103c88 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103c81:	0f a3 de             	bt     %ebx,%esi
f0103c84:	73 f3                	jae    f0103c79 <irq_setmask_8259A+0x5d>
f0103c86:	eb e0                	jmp    f0103c68 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103c88:	83 ec 0c             	sub    $0xc,%esp
f0103c8b:	68 cb 83 10 f0       	push   $0xf01083cb
f0103c90:	e8 ee 00 00 00       	call   f0103d83 <cprintf>
f0103c95:	83 c4 10             	add    $0x10,%esp
f0103c98:	eb 99                	jmp    f0103c33 <irq_setmask_8259A+0x17>

f0103c9a <pic_init>:
{
f0103c9a:	55                   	push   %ebp
f0103c9b:	89 e5                	mov    %esp,%ebp
f0103c9d:	57                   	push   %edi
f0103c9e:	56                   	push   %esi
f0103c9f:	53                   	push   %ebx
f0103ca0:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103ca3:	c6 05 4c 72 34 f0 01 	movb   $0x1,0xf034724c
f0103caa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103caf:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103cb4:	89 da                	mov    %ebx,%edx
f0103cb6:	ee                   	out    %al,(%dx)
f0103cb7:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103cbc:	89 ca                	mov    %ecx,%edx
f0103cbe:	ee                   	out    %al,(%dx)
f0103cbf:	bf 11 00 00 00       	mov    $0x11,%edi
f0103cc4:	be 20 00 00 00       	mov    $0x20,%esi
f0103cc9:	89 f8                	mov    %edi,%eax
f0103ccb:	89 f2                	mov    %esi,%edx
f0103ccd:	ee                   	out    %al,(%dx)
f0103cce:	b8 20 00 00 00       	mov    $0x20,%eax
f0103cd3:	89 da                	mov    %ebx,%edx
f0103cd5:	ee                   	out    %al,(%dx)
f0103cd6:	b8 04 00 00 00       	mov    $0x4,%eax
f0103cdb:	ee                   	out    %al,(%dx)
f0103cdc:	b8 03 00 00 00       	mov    $0x3,%eax
f0103ce1:	ee                   	out    %al,(%dx)
f0103ce2:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103ce7:	89 f8                	mov    %edi,%eax
f0103ce9:	89 da                	mov    %ebx,%edx
f0103ceb:	ee                   	out    %al,(%dx)
f0103cec:	b8 28 00 00 00       	mov    $0x28,%eax
f0103cf1:	89 ca                	mov    %ecx,%edx
f0103cf3:	ee                   	out    %al,(%dx)
f0103cf4:	b8 02 00 00 00       	mov    $0x2,%eax
f0103cf9:	ee                   	out    %al,(%dx)
f0103cfa:	b8 01 00 00 00       	mov    $0x1,%eax
f0103cff:	ee                   	out    %al,(%dx)
f0103d00:	bf 68 00 00 00       	mov    $0x68,%edi
f0103d05:	89 f8                	mov    %edi,%eax
f0103d07:	89 f2                	mov    %esi,%edx
f0103d09:	ee                   	out    %al,(%dx)
f0103d0a:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103d0f:	89 c8                	mov    %ecx,%eax
f0103d11:	ee                   	out    %al,(%dx)
f0103d12:	89 f8                	mov    %edi,%eax
f0103d14:	89 da                	mov    %ebx,%edx
f0103d16:	ee                   	out    %al,(%dx)
f0103d17:	89 c8                	mov    %ecx,%eax
f0103d19:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103d1a:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0103d21:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103d25:	75 08                	jne    f0103d2f <pic_init+0x95>
}
f0103d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103d2a:	5b                   	pop    %ebx
f0103d2b:	5e                   	pop    %esi
f0103d2c:	5f                   	pop    %edi
f0103d2d:	5d                   	pop    %ebp
f0103d2e:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103d2f:	83 ec 0c             	sub    $0xc,%esp
f0103d32:	0f b7 c0             	movzwl %ax,%eax
f0103d35:	50                   	push   %eax
f0103d36:	e8 e1 fe ff ff       	call   f0103c1c <irq_setmask_8259A>
f0103d3b:	83 c4 10             	add    $0x10,%esp
}
f0103d3e:	eb e7                	jmp    f0103d27 <pic_init+0x8d>

f0103d40 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103d40:	55                   	push   %ebp
f0103d41:	89 e5                	mov    %esp,%ebp
f0103d43:	53                   	push   %ebx
f0103d44:	83 ec 10             	sub    $0x10,%esp
f0103d47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0103d4a:	ff 75 08             	pushl  0x8(%ebp)
f0103d4d:	e8 45 ca ff ff       	call   f0100797 <cputchar>
	(*cnt)++;
f0103d52:	83 03 01             	addl   $0x1,(%ebx)
}
f0103d55:	83 c4 10             	add    $0x10,%esp
f0103d58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103d5b:	c9                   	leave  
f0103d5c:	c3                   	ret    

f0103d5d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103d5d:	55                   	push   %ebp
f0103d5e:	89 e5                	mov    %esp,%ebp
f0103d60:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103d63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103d6a:	ff 75 0c             	pushl  0xc(%ebp)
f0103d6d:	ff 75 08             	pushl  0x8(%ebp)
f0103d70:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103d73:	50                   	push   %eax
f0103d74:	68 40 3d 10 f0       	push   $0xf0103d40
f0103d79:	e8 e5 1c 00 00       	call   f0105a63 <vprintfmt>
	return cnt;
}
f0103d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103d81:	c9                   	leave  
f0103d82:	c3                   	ret    

f0103d83 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103d83:	55                   	push   %ebp
f0103d84:	89 e5                	mov    %esp,%ebp
f0103d86:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103d89:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103d8c:	50                   	push   %eax
f0103d8d:	ff 75 08             	pushl  0x8(%ebp)
f0103d90:	e8 c8 ff ff ff       	call   f0103d5d <vcprintf>
	va_end(ap);
	return cnt;
}
f0103d95:	c9                   	leave  
f0103d96:	c3                   	ret    

f0103d97 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103d97:	55                   	push   %ebp
f0103d98:	89 e5                	mov    %esp,%ebp
f0103d9a:	57                   	push   %edi
f0103d9b:	56                   	push   %esi
f0103d9c:	53                   	push   %ebx
f0103d9d:	83 ec 1c             	sub    $0x1c,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int i = cpunum();
f0103da0:	e8 25 2b 00 00       	call   f01068ca <cpunum>
f0103da5:	89 c3                	mov    %eax,%ebx
	(thiscpu->cpu_ts).ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0103da7:	e8 1e 2b 00 00       	call   f01068ca <cpunum>
f0103dac:	6b c0 74             	imul   $0x74,%eax,%eax
f0103daf:	89 d9                	mov    %ebx,%ecx
f0103db1:	c1 e1 10             	shl    $0x10,%ecx
f0103db4:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103db9:	29 ca                	sub    %ecx,%edx
f0103dbb:	89 90 30 80 34 f0    	mov    %edx,-0xfcb7fd0(%eax)
	(thiscpu->cpu_ts).ts_ss0 = GD_KD;
f0103dc1:	e8 04 2b 00 00       	call   f01068ca <cpunum>
f0103dc6:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dc9:	66 c7 80 34 80 34 f0 	movw   $0x10,-0xfcb7fcc(%eax)
f0103dd0:	10 00 
	(thiscpu->cpu_ts).ts_iomb = sizeof(struct Taskstate);
f0103dd2:	e8 f3 2a 00 00       	call   f01068ca <cpunum>
f0103dd7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dda:	66 c7 80 92 80 34 f0 	movw   $0x68,-0xfcb7f6e(%eax)
f0103de1:	68 00 

	// Initialize the TSS slot of the gdt.
	// gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
	// 				sizeof(struct Taskstate) - 1, 0);
	int GD_TSSi = GD_TSS0 + (i << 3);
f0103de3:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSSi >> 3] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0103dea:	89 fb                	mov    %edi,%ebx
f0103dec:	c1 fb 03             	sar    $0x3,%ebx
f0103def:	e8 d6 2a 00 00       	call   f01068ca <cpunum>
f0103df4:	89 c6                	mov    %eax,%esi
f0103df6:	e8 cf 2a 00 00       	call   f01068ca <cpunum>
f0103dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103dfe:	e8 c7 2a 00 00       	call   f01068ca <cpunum>
f0103e03:	66 c7 04 dd 40 53 12 	movw   $0x67,-0xfedacc0(,%ebx,8)
f0103e0a:	f0 67 00 
f0103e0d:	6b f6 74             	imul   $0x74,%esi,%esi
f0103e10:	81 c6 2c 80 34 f0    	add    $0xf034802c,%esi
f0103e16:	66 89 34 dd 42 53 12 	mov    %si,-0xfedacbe(,%ebx,8)
f0103e1d:	f0 
f0103e1e:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103e22:	81 c2 2c 80 34 f0    	add    $0xf034802c,%edx
f0103e28:	c1 ea 10             	shr    $0x10,%edx
f0103e2b:	88 14 dd 44 53 12 f0 	mov    %dl,-0xfedacbc(,%ebx,8)
f0103e32:	c6 04 dd 46 53 12 f0 	movb   $0x40,-0xfedacba(,%ebx,8)
f0103e39:	40 
f0103e3a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e3d:	05 2c 80 34 f0       	add    $0xf034802c,%eax
f0103e42:	c1 e8 18             	shr    $0x18,%eax
f0103e45:	88 04 dd 47 53 12 f0 	mov    %al,-0xfedacb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSSi >> 3].sd_s = 0;
f0103e4c:	c6 04 dd 45 53 12 f0 	movb   $0x89,-0xfedacbb(,%ebx,8)
f0103e53:	89 
	asm volatile("ltr %0" : : "r" (sel));
f0103e54:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f0103e57:	b8 ac 53 12 f0       	mov    $0xf01253ac,%eax
f0103e5c:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSSi);

	// Load the IDT
	lidt(&idt_pd);
}
f0103e5f:	83 c4 1c             	add    $0x1c,%esp
f0103e62:	5b                   	pop    %ebx
f0103e63:	5e                   	pop    %esi
f0103e64:	5f                   	pop    %edi
f0103e65:	5d                   	pop    %ebp
f0103e66:	c3                   	ret    

f0103e67 <trap_init>:
{
f0103e67:	55                   	push   %ebp
f0103e68:	89 e5                	mov    %esp,%ebp
f0103e6a:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE] , 0, GD_KT, DIVIDE_HANDLER , 0);
f0103e6d:	b8 4a 4b 10 f0       	mov    $0xf0104b4a,%eax
f0103e72:	66 a3 60 72 34 f0    	mov    %ax,0xf0347260
f0103e78:	66 c7 05 62 72 34 f0 	movw   $0x8,0xf0347262
f0103e7f:	08 00 
f0103e81:	c6 05 64 72 34 f0 00 	movb   $0x0,0xf0347264
f0103e88:	c6 05 65 72 34 f0 8e 	movb   $0x8e,0xf0347265
f0103e8f:	c1 e8 10             	shr    $0x10,%eax
f0103e92:	66 a3 66 72 34 f0    	mov    %ax,0xf0347266
	SETGATE(idt[T_DEBUG]  , 0, GD_KT, DEBUG_HANDLER  , 0);
f0103e98:	b8 54 4b 10 f0       	mov    $0xf0104b54,%eax
f0103e9d:	66 a3 68 72 34 f0    	mov    %ax,0xf0347268
f0103ea3:	66 c7 05 6a 72 34 f0 	movw   $0x8,0xf034726a
f0103eaa:	08 00 
f0103eac:	c6 05 6c 72 34 f0 00 	movb   $0x0,0xf034726c
f0103eb3:	c6 05 6d 72 34 f0 8e 	movb   $0x8e,0xf034726d
f0103eba:	c1 e8 10             	shr    $0x10,%eax
f0103ebd:	66 a3 6e 72 34 f0    	mov    %ax,0xf034726e
	SETGATE(idt[T_NMI]    , 0, GD_KT, NMI_HANDLER    , 0);
f0103ec3:	b8 5e 4b 10 f0       	mov    $0xf0104b5e,%eax
f0103ec8:	66 a3 70 72 34 f0    	mov    %ax,0xf0347270
f0103ece:	66 c7 05 72 72 34 f0 	movw   $0x8,0xf0347272
f0103ed5:	08 00 
f0103ed7:	c6 05 74 72 34 f0 00 	movb   $0x0,0xf0347274
f0103ede:	c6 05 75 72 34 f0 8e 	movb   $0x8e,0xf0347275
f0103ee5:	c1 e8 10             	shr    $0x10,%eax
f0103ee8:	66 a3 76 72 34 f0    	mov    %ax,0xf0347276
	SETGATE(idt[T_BRKPT]  , 0, GD_KT, BRKPT_HANDLER  , 3);
f0103eee:	b8 68 4b 10 f0       	mov    $0xf0104b68,%eax
f0103ef3:	66 a3 78 72 34 f0    	mov    %ax,0xf0347278
f0103ef9:	66 c7 05 7a 72 34 f0 	movw   $0x8,0xf034727a
f0103f00:	08 00 
f0103f02:	c6 05 7c 72 34 f0 00 	movb   $0x0,0xf034727c
f0103f09:	c6 05 7d 72 34 f0 ee 	movb   $0xee,0xf034727d
f0103f10:	c1 e8 10             	shr    $0x10,%eax
f0103f13:	66 a3 7e 72 34 f0    	mov    %ax,0xf034727e
	SETGATE(idt[T_OFLOW]  , 0, GD_KT, OFLOW_HANDLER  , 3);
f0103f19:	b8 72 4b 10 f0       	mov    $0xf0104b72,%eax
f0103f1e:	66 a3 80 72 34 f0    	mov    %ax,0xf0347280
f0103f24:	66 c7 05 82 72 34 f0 	movw   $0x8,0xf0347282
f0103f2b:	08 00 
f0103f2d:	c6 05 84 72 34 f0 00 	movb   $0x0,0xf0347284
f0103f34:	c6 05 85 72 34 f0 ee 	movb   $0xee,0xf0347285
f0103f3b:	c1 e8 10             	shr    $0x10,%eax
f0103f3e:	66 a3 86 72 34 f0    	mov    %ax,0xf0347286
	SETGATE(idt[T_BOUND]  , 0, GD_KT, BOUND_HANDLER  , 3);
f0103f44:	b8 7c 4b 10 f0       	mov    $0xf0104b7c,%eax
f0103f49:	66 a3 88 72 34 f0    	mov    %ax,0xf0347288
f0103f4f:	66 c7 05 8a 72 34 f0 	movw   $0x8,0xf034728a
f0103f56:	08 00 
f0103f58:	c6 05 8c 72 34 f0 00 	movb   $0x0,0xf034728c
f0103f5f:	c6 05 8d 72 34 f0 ee 	movb   $0xee,0xf034728d
f0103f66:	c1 e8 10             	shr    $0x10,%eax
f0103f69:	66 a3 8e 72 34 f0    	mov    %ax,0xf034728e
	SETGATE(idt[T_ILLOP]  , 0, GD_KT, ILLOP_HANDLER  , 0);
f0103f6f:	b8 86 4b 10 f0       	mov    $0xf0104b86,%eax
f0103f74:	66 a3 90 72 34 f0    	mov    %ax,0xf0347290
f0103f7a:	66 c7 05 92 72 34 f0 	movw   $0x8,0xf0347292
f0103f81:	08 00 
f0103f83:	c6 05 94 72 34 f0 00 	movb   $0x0,0xf0347294
f0103f8a:	c6 05 95 72 34 f0 8e 	movb   $0x8e,0xf0347295
f0103f91:	c1 e8 10             	shr    $0x10,%eax
f0103f94:	66 a3 96 72 34 f0    	mov    %ax,0xf0347296
	SETGATE(idt[T_DEVICE] , 0, GD_KT, DEVICE_HANDLER , 0);
f0103f9a:	b8 90 4b 10 f0       	mov    $0xf0104b90,%eax
f0103f9f:	66 a3 98 72 34 f0    	mov    %ax,0xf0347298
f0103fa5:	66 c7 05 9a 72 34 f0 	movw   $0x8,0xf034729a
f0103fac:	08 00 
f0103fae:	c6 05 9c 72 34 f0 00 	movb   $0x0,0xf034729c
f0103fb5:	c6 05 9d 72 34 f0 8e 	movb   $0x8e,0xf034729d
f0103fbc:	c1 e8 10             	shr    $0x10,%eax
f0103fbf:	66 a3 9e 72 34 f0    	mov    %ax,0xf034729e
	SETGATE(idt[T_DBLFLT] , 0, GD_KT, DBLFLT_HANDLER , 0);
f0103fc5:	b8 9a 4b 10 f0       	mov    $0xf0104b9a,%eax
f0103fca:	66 a3 a0 72 34 f0    	mov    %ax,0xf03472a0
f0103fd0:	66 c7 05 a2 72 34 f0 	movw   $0x8,0xf03472a2
f0103fd7:	08 00 
f0103fd9:	c6 05 a4 72 34 f0 00 	movb   $0x0,0xf03472a4
f0103fe0:	c6 05 a5 72 34 f0 8e 	movb   $0x8e,0xf03472a5
f0103fe7:	c1 e8 10             	shr    $0x10,%eax
f0103fea:	66 a3 a6 72 34 f0    	mov    %ax,0xf03472a6
	SETGATE(idt[T_TSS]    , 0, GD_KT, TSS_HANDLER    , 0);
f0103ff0:	b8 a2 4b 10 f0       	mov    $0xf0104ba2,%eax
f0103ff5:	66 a3 b0 72 34 f0    	mov    %ax,0xf03472b0
f0103ffb:	66 c7 05 b2 72 34 f0 	movw   $0x8,0xf03472b2
f0104002:	08 00 
f0104004:	c6 05 b4 72 34 f0 00 	movb   $0x0,0xf03472b4
f010400b:	c6 05 b5 72 34 f0 8e 	movb   $0x8e,0xf03472b5
f0104012:	c1 e8 10             	shr    $0x10,%eax
f0104015:	66 a3 b6 72 34 f0    	mov    %ax,0xf03472b6
	SETGATE(idt[T_SEGNP]  , 0, GD_KT, SEGNP_HANDLER  , 0);
f010401b:	b8 aa 4b 10 f0       	mov    $0xf0104baa,%eax
f0104020:	66 a3 b8 72 34 f0    	mov    %ax,0xf03472b8
f0104026:	66 c7 05 ba 72 34 f0 	movw   $0x8,0xf03472ba
f010402d:	08 00 
f010402f:	c6 05 bc 72 34 f0 00 	movb   $0x0,0xf03472bc
f0104036:	c6 05 bd 72 34 f0 8e 	movb   $0x8e,0xf03472bd
f010403d:	c1 e8 10             	shr    $0x10,%eax
f0104040:	66 a3 be 72 34 f0    	mov    %ax,0xf03472be
	SETGATE(idt[T_STACK]  , 0, GD_KT, STACK_HANDLER  , 0);
f0104046:	b8 b2 4b 10 f0       	mov    $0xf0104bb2,%eax
f010404b:	66 a3 c0 72 34 f0    	mov    %ax,0xf03472c0
f0104051:	66 c7 05 c2 72 34 f0 	movw   $0x8,0xf03472c2
f0104058:	08 00 
f010405a:	c6 05 c4 72 34 f0 00 	movb   $0x0,0xf03472c4
f0104061:	c6 05 c5 72 34 f0 8e 	movb   $0x8e,0xf03472c5
f0104068:	c1 e8 10             	shr    $0x10,%eax
f010406b:	66 a3 c6 72 34 f0    	mov    %ax,0xf03472c6
	SETGATE(idt[T_GPFLT]  , 0, GD_KT, GPFLT_HANDLER  , 0);
f0104071:	b8 ba 4b 10 f0       	mov    $0xf0104bba,%eax
f0104076:	66 a3 c8 72 34 f0    	mov    %ax,0xf03472c8
f010407c:	66 c7 05 ca 72 34 f0 	movw   $0x8,0xf03472ca
f0104083:	08 00 
f0104085:	c6 05 cc 72 34 f0 00 	movb   $0x0,0xf03472cc
f010408c:	c6 05 cd 72 34 f0 8e 	movb   $0x8e,0xf03472cd
f0104093:	c1 e8 10             	shr    $0x10,%eax
f0104096:	66 a3 ce 72 34 f0    	mov    %ax,0xf03472ce
	SETGATE(idt[T_PGFLT]  , 0, GD_KT, PGFLT_HANDLER  , 0);
f010409c:	b8 c2 4b 10 f0       	mov    $0xf0104bc2,%eax
f01040a1:	66 a3 d0 72 34 f0    	mov    %ax,0xf03472d0
f01040a7:	66 c7 05 d2 72 34 f0 	movw   $0x8,0xf03472d2
f01040ae:	08 00 
f01040b0:	c6 05 d4 72 34 f0 00 	movb   $0x0,0xf03472d4
f01040b7:	c6 05 d5 72 34 f0 8e 	movb   $0x8e,0xf03472d5
f01040be:	c1 e8 10             	shr    $0x10,%eax
f01040c1:	66 a3 d6 72 34 f0    	mov    %ax,0xf03472d6
	SETGATE(idt[T_FPERR]  , 0, GD_KT, FPERR_HANDLER  , 0);
f01040c7:	b8 ca 4b 10 f0       	mov    $0xf0104bca,%eax
f01040cc:	66 a3 e0 72 34 f0    	mov    %ax,0xf03472e0
f01040d2:	66 c7 05 e2 72 34 f0 	movw   $0x8,0xf03472e2
f01040d9:	08 00 
f01040db:	c6 05 e4 72 34 f0 00 	movb   $0x0,0xf03472e4
f01040e2:	c6 05 e5 72 34 f0 8e 	movb   $0x8e,0xf03472e5
f01040e9:	c1 e8 10             	shr    $0x10,%eax
f01040ec:	66 a3 e6 72 34 f0    	mov    %ax,0xf03472e6
	SETGATE(idt[T_ALIGN]  , 0, GD_KT, ALIGN_HANDLER  , 0);
f01040f2:	b8 d0 4b 10 f0       	mov    $0xf0104bd0,%eax
f01040f7:	66 a3 e8 72 34 f0    	mov    %ax,0xf03472e8
f01040fd:	66 c7 05 ea 72 34 f0 	movw   $0x8,0xf03472ea
f0104104:	08 00 
f0104106:	c6 05 ec 72 34 f0 00 	movb   $0x0,0xf03472ec
f010410d:	c6 05 ed 72 34 f0 8e 	movb   $0x8e,0xf03472ed
f0104114:	c1 e8 10             	shr    $0x10,%eax
f0104117:	66 a3 ee 72 34 f0    	mov    %ax,0xf03472ee
	SETGATE(idt[T_MCHK]   , 0, GD_KT, MCHK_HANDLER   , 0);
f010411d:	b8 d4 4b 10 f0       	mov    $0xf0104bd4,%eax
f0104122:	66 a3 f0 72 34 f0    	mov    %ax,0xf03472f0
f0104128:	66 c7 05 f2 72 34 f0 	movw   $0x8,0xf03472f2
f010412f:	08 00 
f0104131:	c6 05 f4 72 34 f0 00 	movb   $0x0,0xf03472f4
f0104138:	c6 05 f5 72 34 f0 8e 	movb   $0x8e,0xf03472f5
f010413f:	c1 e8 10             	shr    $0x10,%eax
f0104142:	66 a3 f6 72 34 f0    	mov    %ax,0xf03472f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR_HANDLER, 0);
f0104148:	b8 da 4b 10 f0       	mov    $0xf0104bda,%eax
f010414d:	66 a3 f8 72 34 f0    	mov    %ax,0xf03472f8
f0104153:	66 c7 05 fa 72 34 f0 	movw   $0x8,0xf03472fa
f010415a:	08 00 
f010415c:	c6 05 fc 72 34 f0 00 	movb   $0x0,0xf03472fc
f0104163:	c6 05 fd 72 34 f0 8e 	movb   $0x8e,0xf03472fd
f010416a:	c1 e8 10             	shr    $0x10,%eax
f010416d:	66 a3 fe 72 34 f0    	mov    %ax,0xf03472fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL_HANDLER, 3);	//just test
f0104173:	b8 e0 4b 10 f0       	mov    $0xf0104be0,%eax
f0104178:	66 a3 e0 73 34 f0    	mov    %ax,0xf03473e0
f010417e:	66 c7 05 e2 73 34 f0 	movw   $0x8,0xf03473e2
f0104185:	08 00 
f0104187:	c6 05 e4 73 34 f0 00 	movb   $0x0,0xf03473e4
f010418e:	c6 05 e5 73 34 f0 ee 	movb   $0xee,0xf03473e5
f0104195:	c1 e8 10             	shr    $0x10,%eax
f0104198:	66 a3 e6 73 34 f0    	mov    %ax,0xf03473e6
	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER]    , 0, GD_KT, TIMER_HANDLER	, 0);	
f010419e:	b8 e6 4b 10 f0       	mov    $0xf0104be6,%eax
f01041a3:	66 a3 60 73 34 f0    	mov    %ax,0xf0347360
f01041a9:	66 c7 05 62 73 34 f0 	movw   $0x8,0xf0347362
f01041b0:	08 00 
f01041b2:	c6 05 64 73 34 f0 00 	movb   $0x0,0xf0347364
f01041b9:	c6 05 65 73 34 f0 8e 	movb   $0x8e,0xf0347365
f01041c0:	c1 e8 10             	shr    $0x10,%eax
f01041c3:	66 a3 66 73 34 f0    	mov    %ax,0xf0347366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD]	   , 0, GD_KT, KBD_HANDLER		, 0);
f01041c9:	b8 ec 4b 10 f0       	mov    $0xf0104bec,%eax
f01041ce:	66 a3 68 73 34 f0    	mov    %ax,0xf0347368
f01041d4:	66 c7 05 6a 73 34 f0 	movw   $0x8,0xf034736a
f01041db:	08 00 
f01041dd:	c6 05 6c 73 34 f0 00 	movb   $0x0,0xf034736c
f01041e4:	c6 05 6d 73 34 f0 8e 	movb   $0x8e,0xf034736d
f01041eb:	c1 e8 10             	shr    $0x10,%eax
f01041ee:	66 a3 6e 73 34 f0    	mov    %ax,0xf034736e
	SETGATE(idt[IRQ_OFFSET + 2]			   , 0, GD_KT, SECOND_HANDLER	, 0);
f01041f4:	b8 f2 4b 10 f0       	mov    $0xf0104bf2,%eax
f01041f9:	66 a3 70 73 34 f0    	mov    %ax,0xf0347370
f01041ff:	66 c7 05 72 73 34 f0 	movw   $0x8,0xf0347372
f0104206:	08 00 
f0104208:	c6 05 74 73 34 f0 00 	movb   $0x0,0xf0347374
f010420f:	c6 05 75 73 34 f0 8e 	movb   $0x8e,0xf0347375
f0104216:	c1 e8 10             	shr    $0x10,%eax
f0104219:	66 a3 76 73 34 f0    	mov    %ax,0xf0347376
	SETGATE(idt[IRQ_OFFSET + 3]			   , 0, GD_KT, THIRD_HANDLER	, 0);
f010421f:	b8 f8 4b 10 f0       	mov    $0xf0104bf8,%eax
f0104224:	66 a3 78 73 34 f0    	mov    %ax,0xf0347378
f010422a:	66 c7 05 7a 73 34 f0 	movw   $0x8,0xf034737a
f0104231:	08 00 
f0104233:	c6 05 7c 73 34 f0 00 	movb   $0x0,0xf034737c
f010423a:	c6 05 7d 73 34 f0 8e 	movb   $0x8e,0xf034737d
f0104241:	c1 e8 10             	shr    $0x10,%eax
f0104244:	66 a3 7e 73 34 f0    	mov    %ax,0xf034737e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL]   , 0, GD_KT, SERIAL_HANDLER	, 0);
f010424a:	b8 fe 4b 10 f0       	mov    $0xf0104bfe,%eax
f010424f:	66 a3 80 73 34 f0    	mov    %ax,0xf0347380
f0104255:	66 c7 05 82 73 34 f0 	movw   $0x8,0xf0347382
f010425c:	08 00 
f010425e:	c6 05 84 73 34 f0 00 	movb   $0x0,0xf0347384
f0104265:	c6 05 85 73 34 f0 8e 	movb   $0x8e,0xf0347385
f010426c:	c1 e8 10             	shr    $0x10,%eax
f010426f:	66 a3 86 73 34 f0    	mov    %ax,0xf0347386
	SETGATE(idt[IRQ_OFFSET + 5]			   , 0, GD_KT, FIFTH_HANDLER	, 0);
f0104275:	b8 04 4c 10 f0       	mov    $0xf0104c04,%eax
f010427a:	66 a3 88 73 34 f0    	mov    %ax,0xf0347388
f0104280:	66 c7 05 8a 73 34 f0 	movw   $0x8,0xf034738a
f0104287:	08 00 
f0104289:	c6 05 8c 73 34 f0 00 	movb   $0x0,0xf034738c
f0104290:	c6 05 8d 73 34 f0 8e 	movb   $0x8e,0xf034738d
f0104297:	c1 e8 10             	shr    $0x10,%eax
f010429a:	66 a3 8e 73 34 f0    	mov    %ax,0xf034738e
	SETGATE(idt[IRQ_OFFSET + 6]			   , 0, GD_KT, SIXTH_HANDLER	, 0);
f01042a0:	b8 0a 4c 10 f0       	mov    $0xf0104c0a,%eax
f01042a5:	66 a3 90 73 34 f0    	mov    %ax,0xf0347390
f01042ab:	66 c7 05 92 73 34 f0 	movw   $0x8,0xf0347392
f01042b2:	08 00 
f01042b4:	c6 05 94 73 34 f0 00 	movb   $0x0,0xf0347394
f01042bb:	c6 05 95 73 34 f0 8e 	movb   $0x8e,0xf0347395
f01042c2:	c1 e8 10             	shr    $0x10,%eax
f01042c5:	66 a3 96 73 34 f0    	mov    %ax,0xf0347396
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS] , 0, GD_KT, SPURIOUS_HANDLER	, 0);
f01042cb:	b8 10 4c 10 f0       	mov    $0xf0104c10,%eax
f01042d0:	66 a3 98 73 34 f0    	mov    %ax,0xf0347398
f01042d6:	66 c7 05 9a 73 34 f0 	movw   $0x8,0xf034739a
f01042dd:	08 00 
f01042df:	c6 05 9c 73 34 f0 00 	movb   $0x0,0xf034739c
f01042e6:	c6 05 9d 73 34 f0 8e 	movb   $0x8e,0xf034739d
f01042ed:	c1 e8 10             	shr    $0x10,%eax
f01042f0:	66 a3 9e 73 34 f0    	mov    %ax,0xf034739e
	SETGATE(idt[IRQ_OFFSET + 8]			   , 0, GD_KT, EIGHTH_HANDLER	, 0);
f01042f6:	b8 16 4c 10 f0       	mov    $0xf0104c16,%eax
f01042fb:	66 a3 a0 73 34 f0    	mov    %ax,0xf03473a0
f0104301:	66 c7 05 a2 73 34 f0 	movw   $0x8,0xf03473a2
f0104308:	08 00 
f010430a:	c6 05 a4 73 34 f0 00 	movb   $0x0,0xf03473a4
f0104311:	c6 05 a5 73 34 f0 8e 	movb   $0x8e,0xf03473a5
f0104318:	c1 e8 10             	shr    $0x10,%eax
f010431b:	66 a3 a6 73 34 f0    	mov    %ax,0xf03473a6
	SETGATE(idt[IRQ_OFFSET + 9]			   , 0, GD_KT, NINTH_HANDLER	, 0);
f0104321:	b8 1c 4c 10 f0       	mov    $0xf0104c1c,%eax
f0104326:	66 a3 a8 73 34 f0    	mov    %ax,0xf03473a8
f010432c:	66 c7 05 aa 73 34 f0 	movw   $0x8,0xf03473aa
f0104333:	08 00 
f0104335:	c6 05 ac 73 34 f0 00 	movb   $0x0,0xf03473ac
f010433c:	c6 05 ad 73 34 f0 8e 	movb   $0x8e,0xf03473ad
f0104343:	c1 e8 10             	shr    $0x10,%eax
f0104346:	66 a3 ae 73 34 f0    	mov    %ax,0xf03473ae
	SETGATE(idt[IRQ_OFFSET + 10]	   	   , 0, GD_KT, TENTH_HANDLER	, 0);
f010434c:	b8 22 4c 10 f0       	mov    $0xf0104c22,%eax
f0104351:	66 a3 b0 73 34 f0    	mov    %ax,0xf03473b0
f0104357:	66 c7 05 b2 73 34 f0 	movw   $0x8,0xf03473b2
f010435e:	08 00 
f0104360:	c6 05 b4 73 34 f0 00 	movb   $0x0,0xf03473b4
f0104367:	c6 05 b5 73 34 f0 8e 	movb   $0x8e,0xf03473b5
f010436e:	c1 e8 10             	shr    $0x10,%eax
f0104371:	66 a3 b6 73 34 f0    	mov    %ax,0xf03473b6
	SETGATE(idt[IRQ_OFFSET + 11]		   , 0, GD_KT, ELEVEN_HANDLER	, 0);
f0104377:	b8 28 4c 10 f0       	mov    $0xf0104c28,%eax
f010437c:	66 a3 b8 73 34 f0    	mov    %ax,0xf03473b8
f0104382:	66 c7 05 ba 73 34 f0 	movw   $0x8,0xf03473ba
f0104389:	08 00 
f010438b:	c6 05 bc 73 34 f0 00 	movb   $0x0,0xf03473bc
f0104392:	c6 05 bd 73 34 f0 8e 	movb   $0x8e,0xf03473bd
f0104399:	c1 e8 10             	shr    $0x10,%eax
f010439c:	66 a3 be 73 34 f0    	mov    %ax,0xf03473be
	SETGATE(idt[IRQ_OFFSET + 12]		   , 0, GD_KT, TWELVE_HANDLER	, 0);
f01043a2:	b8 2e 4c 10 f0       	mov    $0xf0104c2e,%eax
f01043a7:	66 a3 c0 73 34 f0    	mov    %ax,0xf03473c0
f01043ad:	66 c7 05 c2 73 34 f0 	movw   $0x8,0xf03473c2
f01043b4:	08 00 
f01043b6:	c6 05 c4 73 34 f0 00 	movb   $0x0,0xf03473c4
f01043bd:	c6 05 c5 73 34 f0 8e 	movb   $0x8e,0xf03473c5
f01043c4:	c1 e8 10             	shr    $0x10,%eax
f01043c7:	66 a3 c6 73 34 f0    	mov    %ax,0xf03473c6
	SETGATE(idt[IRQ_OFFSET + 13]		   , 0, GD_KT, THIRTEEN_HANDLER , 0);
f01043cd:	b8 34 4c 10 f0       	mov    $0xf0104c34,%eax
f01043d2:	66 a3 c8 73 34 f0    	mov    %ax,0xf03473c8
f01043d8:	66 c7 05 ca 73 34 f0 	movw   $0x8,0xf03473ca
f01043df:	08 00 
f01043e1:	c6 05 cc 73 34 f0 00 	movb   $0x0,0xf03473cc
f01043e8:	c6 05 cd 73 34 f0 8e 	movb   $0x8e,0xf03473cd
f01043ef:	c1 e8 10             	shr    $0x10,%eax
f01043f2:	66 a3 ce 73 34 f0    	mov    %ax,0xf03473ce
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE]	   , 0, GD_KT, IDE_HANDLER		, 0);
f01043f8:	b8 3a 4c 10 f0       	mov    $0xf0104c3a,%eax
f01043fd:	66 a3 d0 73 34 f0    	mov    %ax,0xf03473d0
f0104403:	66 c7 05 d2 73 34 f0 	movw   $0x8,0xf03473d2
f010440a:	08 00 
f010440c:	c6 05 d4 73 34 f0 00 	movb   $0x0,0xf03473d4
f0104413:	c6 05 d5 73 34 f0 8e 	movb   $0x8e,0xf03473d5
f010441a:	c1 e8 10             	shr    $0x10,%eax
f010441d:	66 a3 d6 73 34 f0    	mov    %ax,0xf03473d6
	SETGATE(idt[IRQ_OFFSET + 15]		   , 0, GD_KT, FIFTEEN_HANDLER  , 0);
f0104423:	b8 40 4c 10 f0       	mov    $0xf0104c40,%eax
f0104428:	66 a3 d8 73 34 f0    	mov    %ax,0xf03473d8
f010442e:	66 c7 05 da 73 34 f0 	movw   $0x8,0xf03473da
f0104435:	08 00 
f0104437:	c6 05 dc 73 34 f0 00 	movb   $0x0,0xf03473dc
f010443e:	c6 05 dd 73 34 f0 8e 	movb   $0x8e,0xf03473dd
f0104445:	c1 e8 10             	shr    $0x10,%eax
f0104448:	66 a3 de 73 34 f0    	mov    %ax,0xf03473de
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR]	   , 0, GD_KT, ERROR_HANDLER	, 0);
f010444e:	b8 46 4c 10 f0       	mov    $0xf0104c46,%eax
f0104453:	66 a3 f8 73 34 f0    	mov    %ax,0xf03473f8
f0104459:	66 c7 05 fa 73 34 f0 	movw   $0x8,0xf03473fa
f0104460:	08 00 
f0104462:	c6 05 fc 73 34 f0 00 	movb   $0x0,0xf03473fc
f0104469:	c6 05 fd 73 34 f0 8e 	movb   $0x8e,0xf03473fd
f0104470:	c1 e8 10             	shr    $0x10,%eax
f0104473:	66 a3 fe 73 34 f0    	mov    %ax,0xf03473fe
	trap_init_percpu();
f0104479:	e8 19 f9 ff ff       	call   f0103d97 <trap_init_percpu>
}
f010447e:	c9                   	leave  
f010447f:	c3                   	ret    

f0104480 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0104480:	55                   	push   %ebp
f0104481:	89 e5                	mov    %esp,%ebp
f0104483:	53                   	push   %ebx
f0104484:	83 ec 0c             	sub    $0xc,%esp
f0104487:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f010448a:	ff 33                	pushl  (%ebx)
f010448c:	68 a0 84 10 f0       	push   $0xf01084a0
f0104491:	e8 ed f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104496:	83 c4 08             	add    $0x8,%esp
f0104499:	ff 73 04             	pushl  0x4(%ebx)
f010449c:	68 af 84 10 f0       	push   $0xf01084af
f01044a1:	e8 dd f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01044a6:	83 c4 08             	add    $0x8,%esp
f01044a9:	ff 73 08             	pushl  0x8(%ebx)
f01044ac:	68 be 84 10 f0       	push   $0xf01084be
f01044b1:	e8 cd f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01044b6:	83 c4 08             	add    $0x8,%esp
f01044b9:	ff 73 0c             	pushl  0xc(%ebx)
f01044bc:	68 cd 84 10 f0       	push   $0xf01084cd
f01044c1:	e8 bd f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01044c6:	83 c4 08             	add    $0x8,%esp
f01044c9:	ff 73 10             	pushl  0x10(%ebx)
f01044cc:	68 dc 84 10 f0       	push   $0xf01084dc
f01044d1:	e8 ad f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01044d6:	83 c4 08             	add    $0x8,%esp
f01044d9:	ff 73 14             	pushl  0x14(%ebx)
f01044dc:	68 eb 84 10 f0       	push   $0xf01084eb
f01044e1:	e8 9d f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01044e6:	83 c4 08             	add    $0x8,%esp
f01044e9:	ff 73 18             	pushl  0x18(%ebx)
f01044ec:	68 fa 84 10 f0       	push   $0xf01084fa
f01044f1:	e8 8d f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01044f6:	83 c4 08             	add    $0x8,%esp
f01044f9:	ff 73 1c             	pushl  0x1c(%ebx)
f01044fc:	68 09 85 10 f0       	push   $0xf0108509
f0104501:	e8 7d f8 ff ff       	call   f0103d83 <cprintf>
}
f0104506:	83 c4 10             	add    $0x10,%esp
f0104509:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010450c:	c9                   	leave  
f010450d:	c3                   	ret    

f010450e <print_trapframe>:
{
f010450e:	55                   	push   %ebp
f010450f:	89 e5                	mov    %esp,%ebp
f0104511:	56                   	push   %esi
f0104512:	53                   	push   %ebx
f0104513:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104516:	e8 af 23 00 00       	call   f01068ca <cpunum>
f010451b:	83 ec 04             	sub    $0x4,%esp
f010451e:	50                   	push   %eax
f010451f:	53                   	push   %ebx
f0104520:	68 6d 85 10 f0       	push   $0xf010856d
f0104525:	e8 59 f8 ff ff       	call   f0103d83 <cprintf>
	print_regs(&tf->tf_regs);
f010452a:	89 1c 24             	mov    %ebx,(%esp)
f010452d:	e8 4e ff ff ff       	call   f0104480 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104532:	83 c4 08             	add    $0x8,%esp
f0104535:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104539:	50                   	push   %eax
f010453a:	68 8b 85 10 f0       	push   $0xf010858b
f010453f:	e8 3f f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104544:	83 c4 08             	add    $0x8,%esp
f0104547:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f010454b:	50                   	push   %eax
f010454c:	68 9e 85 10 f0       	push   $0xf010859e
f0104551:	e8 2d f8 ff ff       	call   f0103d83 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104556:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104559:	83 c4 10             	add    $0x10,%esp
f010455c:	83 f8 13             	cmp    $0x13,%eax
f010455f:	0f 86 e1 00 00 00    	jbe    f0104646 <print_trapframe+0x138>
		return "System call";
f0104565:	ba 18 85 10 f0       	mov    $0xf0108518,%edx
	if (trapno == T_SYSCALL)
f010456a:	83 f8 30             	cmp    $0x30,%eax
f010456d:	74 13                	je     f0104582 <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f010456f:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104572:	83 fa 0f             	cmp    $0xf,%edx
f0104575:	ba 24 85 10 f0       	mov    $0xf0108524,%edx
f010457a:	b9 33 85 10 f0       	mov    $0xf0108533,%ecx
f010457f:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104582:	83 ec 04             	sub    $0x4,%esp
f0104585:	52                   	push   %edx
f0104586:	50                   	push   %eax
f0104587:	68 b1 85 10 f0       	push   $0xf01085b1
f010458c:	e8 f2 f7 ff ff       	call   f0103d83 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104591:	83 c4 10             	add    $0x10,%esp
f0104594:	39 1d 60 7a 34 f0    	cmp    %ebx,0xf0347a60
f010459a:	0f 84 b2 00 00 00    	je     f0104652 <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f01045a0:	83 ec 08             	sub    $0x8,%esp
f01045a3:	ff 73 2c             	pushl  0x2c(%ebx)
f01045a6:	68 d2 85 10 f0       	push   $0xf01085d2
f01045ab:	e8 d3 f7 ff ff       	call   f0103d83 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f01045b0:	83 c4 10             	add    $0x10,%esp
f01045b3:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01045b7:	0f 85 b8 00 00 00    	jne    f0104675 <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f01045bd:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f01045c0:	89 c2                	mov    %eax,%edx
f01045c2:	83 e2 01             	and    $0x1,%edx
f01045c5:	b9 46 85 10 f0       	mov    $0xf0108546,%ecx
f01045ca:	ba 51 85 10 f0       	mov    $0xf0108551,%edx
f01045cf:	0f 44 ca             	cmove  %edx,%ecx
f01045d2:	89 c2                	mov    %eax,%edx
f01045d4:	83 e2 02             	and    $0x2,%edx
f01045d7:	be 5d 85 10 f0       	mov    $0xf010855d,%esi
f01045dc:	ba 63 85 10 f0       	mov    $0xf0108563,%edx
f01045e1:	0f 45 d6             	cmovne %esi,%edx
f01045e4:	83 e0 04             	and    $0x4,%eax
f01045e7:	b8 68 85 10 f0       	mov    $0xf0108568,%eax
f01045ec:	be d1 87 10 f0       	mov    $0xf01087d1,%esi
f01045f1:	0f 44 c6             	cmove  %esi,%eax
f01045f4:	51                   	push   %ecx
f01045f5:	52                   	push   %edx
f01045f6:	50                   	push   %eax
f01045f7:	68 e0 85 10 f0       	push   $0xf01085e0
f01045fc:	e8 82 f7 ff ff       	call   f0103d83 <cprintf>
f0104601:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104604:	83 ec 08             	sub    $0x8,%esp
f0104607:	ff 73 30             	pushl  0x30(%ebx)
f010460a:	68 ef 85 10 f0       	push   $0xf01085ef
f010460f:	e8 6f f7 ff ff       	call   f0103d83 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104614:	83 c4 08             	add    $0x8,%esp
f0104617:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010461b:	50                   	push   %eax
f010461c:	68 fe 85 10 f0       	push   $0xf01085fe
f0104621:	e8 5d f7 ff ff       	call   f0103d83 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104626:	83 c4 08             	add    $0x8,%esp
f0104629:	ff 73 38             	pushl  0x38(%ebx)
f010462c:	68 11 86 10 f0       	push   $0xf0108611
f0104631:	e8 4d f7 ff ff       	call   f0103d83 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104636:	83 c4 10             	add    $0x10,%esp
f0104639:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010463d:	75 4b                	jne    f010468a <print_trapframe+0x17c>
}
f010463f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104642:	5b                   	pop    %ebx
f0104643:	5e                   	pop    %esi
f0104644:	5d                   	pop    %ebp
f0104645:	c3                   	ret    
		return excnames[trapno];
f0104646:	8b 14 85 40 8a 10 f0 	mov    -0xfef75c0(,%eax,4),%edx
f010464d:	e9 30 ff ff ff       	jmp    f0104582 <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104652:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104656:	0f 85 44 ff ff ff    	jne    f01045a0 <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f010465c:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f010465f:	83 ec 08             	sub    $0x8,%esp
f0104662:	50                   	push   %eax
f0104663:	68 c3 85 10 f0       	push   $0xf01085c3
f0104668:	e8 16 f7 ff ff       	call   f0103d83 <cprintf>
f010466d:	83 c4 10             	add    $0x10,%esp
f0104670:	e9 2b ff ff ff       	jmp    f01045a0 <print_trapframe+0x92>
		cprintf("\n");
f0104675:	83 ec 0c             	sub    $0xc,%esp
f0104678:	68 cb 83 10 f0       	push   $0xf01083cb
f010467d:	e8 01 f7 ff ff       	call   f0103d83 <cprintf>
f0104682:	83 c4 10             	add    $0x10,%esp
f0104685:	e9 7a ff ff ff       	jmp    f0104604 <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f010468a:	83 ec 08             	sub    $0x8,%esp
f010468d:	ff 73 3c             	pushl  0x3c(%ebx)
f0104690:	68 20 86 10 f0       	push   $0xf0108620
f0104695:	e8 e9 f6 ff ff       	call   f0103d83 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010469a:	83 c4 08             	add    $0x8,%esp
f010469d:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01046a1:	50                   	push   %eax
f01046a2:	68 2f 86 10 f0       	push   $0xf010862f
f01046a7:	e8 d7 f6 ff ff       	call   f0103d83 <cprintf>
f01046ac:	83 c4 10             	add    $0x10,%esp
}
f01046af:	eb 8e                	jmp    f010463f <print_trapframe+0x131>

f01046b1 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f01046b1:	55                   	push   %ebp
f01046b2:	89 e5                	mov    %esp,%ebp
f01046b4:	57                   	push   %edi
f01046b5:	56                   	push   %esi
f01046b6:	53                   	push   %ebx
f01046b7:	83 ec 0c             	sub    $0xc,%esp
f01046ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01046bd:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if((tf->tf_cs & 3) != 3){
f01046c0:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01046c4:	83 e0 03             	and    $0x3,%eax
f01046c7:	66 83 f8 03          	cmp    $0x3,%ax
f01046cb:	75 5d                	jne    f010472a <page_fault_handler+0x79>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Destroy the environment that caused the fault.
	if(curenv->env_pgfault_upcall){
f01046cd:	e8 f8 21 00 00       	call   f01068ca <cpunum>
f01046d2:	6b c0 74             	imul   $0x74,%eax,%eax
f01046d5:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01046db:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f01046df:	75 69                	jne    f010474a <page_fault_handler+0x99>

		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01046e1:	8b 7b 30             	mov    0x30(%ebx),%edi
	curenv->env_id, fault_va, tf->tf_eip);
f01046e4:	e8 e1 21 00 00       	call   f01068ca <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01046e9:	57                   	push   %edi
f01046ea:	56                   	push   %esi
	curenv->env_id, fault_va, tf->tf_eip);
f01046eb:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01046ee:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01046f4:	ff 70 48             	pushl  0x48(%eax)
f01046f7:	68 1c 89 10 f0       	push   $0xf010891c
f01046fc:	e8 82 f6 ff ff       	call   f0103d83 <cprintf>
	print_trapframe(tf);
f0104701:	89 1c 24             	mov    %ebx,(%esp)
f0104704:	e8 05 fe ff ff       	call   f010450e <print_trapframe>
	env_destroy(curenv);
f0104709:	e8 bc 21 00 00       	call   f01068ca <cpunum>
f010470e:	83 c4 04             	add    $0x4,%esp
f0104711:	6b c0 74             	imul   $0x74,%eax,%eax
f0104714:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f010471a:	e8 0f f3 ff ff       	call   f0103a2e <env_destroy>
}
f010471f:	83 c4 10             	add    $0x10,%esp
f0104722:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104725:	5b                   	pop    %ebx
f0104726:	5e                   	pop    %esi
f0104727:	5f                   	pop    %edi
f0104728:	5d                   	pop    %ebp
f0104729:	c3                   	ret    
		print_trapframe(tf);//just test
f010472a:	83 ec 0c             	sub    $0xc,%esp
f010472d:	53                   	push   %ebx
f010472e:	e8 db fd ff ff       	call   f010450e <print_trapframe>
		panic("panic at kernel page_fault\n");
f0104733:	83 c4 0c             	add    $0xc,%esp
f0104736:	68 42 86 10 f0       	push   $0xf0108642
f010473b:	68 bb 01 00 00       	push   $0x1bb
f0104740:	68 5e 86 10 f0       	push   $0xf010865e
f0104745:	e8 f6 b8 ff ff       	call   f0100040 <_panic>
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f010474a:	8b 53 3c             	mov    0x3c(%ebx),%edx
f010474d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f0104752:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));		
f0104754:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104759:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f010475e:	77 05                	ja     f0104765 <page_fault_handler+0xb4>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f0104760:	8d 42 c8             	lea    -0x38(%edx),%eax
f0104763:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f0104765:	e8 60 21 00 00       	call   f01068ca <cpunum>
f010476a:	6a 02                	push   $0x2
f010476c:	6a 34                	push   $0x34
f010476e:	57                   	push   %edi
f010476f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104772:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0104778:	e8 91 ec ff ff       	call   f010340e <user_mem_assert>
		utf->utf_fault_va = fault_va;
f010477d:	89 fa                	mov    %edi,%edx
f010477f:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f0104781:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104784:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0104787:	8d 7f 08             	lea    0x8(%edi),%edi
f010478a:	b9 08 00 00 00       	mov    $0x8,%ecx
f010478f:	89 de                	mov    %ebx,%esi
f0104791:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0104793:	8b 43 30             	mov    0x30(%ebx),%eax
f0104796:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0104799:	8b 43 38             	mov    0x38(%ebx),%eax
f010479c:	89 d7                	mov    %edx,%edi
f010479e:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f01047a1:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01047a4:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f01047a7:	e8 1e 21 00 00       	call   f01068ca <cpunum>
f01047ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01047af:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01047b5:	8b 58 64             	mov    0x64(%eax),%ebx
f01047b8:	e8 0d 21 00 00       	call   f01068ca <cpunum>
f01047bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01047c0:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01047c6:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f01047c9:	e8 fc 20 00 00       	call   f01068ca <cpunum>
f01047ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01047d1:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01047d7:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f01047da:	e8 eb 20 00 00       	call   f01068ca <cpunum>
f01047df:	83 c4 04             	add    $0x4,%esp
f01047e2:	6b c0 74             	imul   $0x74,%eax,%eax
f01047e5:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f01047eb:	e8 dd f2 ff ff       	call   f0103acd <env_run>

f01047f0 <trap>:
{
f01047f0:	55                   	push   %ebp
f01047f1:	89 e5                	mov    %esp,%ebp
f01047f3:	57                   	push   %edi
f01047f4:	56                   	push   %esi
f01047f5:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f01047f8:	fc                   	cld    
	if (panicstr)
f01047f9:	83 3d 80 7e 34 f0 00 	cmpl   $0x0,0xf0347e80
f0104800:	74 01                	je     f0104803 <trap+0x13>
		asm volatile("hlt");
f0104802:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104803:	e8 c2 20 00 00       	call   f01068ca <cpunum>
f0104808:	6b d0 74             	imul   $0x74,%eax,%edx
f010480b:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010480e:	b8 01 00 00 00       	mov    $0x1,%eax
f0104813:	f0 87 82 20 80 34 f0 	lock xchg %eax,-0xfcb7fe0(%edx)
f010481a:	83 f8 02             	cmp    $0x2,%eax
f010481d:	74 30                	je     f010484f <trap+0x5f>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010481f:	9c                   	pushf  
f0104820:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104821:	f6 c4 02             	test   $0x2,%ah
f0104824:	75 3b                	jne    f0104861 <trap+0x71>
	if ((tf->tf_cs & 3) == 3) {
f0104826:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010482a:	83 e0 03             	and    $0x3,%eax
f010482d:	66 83 f8 03          	cmp    $0x3,%ax
f0104831:	74 47                	je     f010487a <trap+0x8a>
	last_tf = tf;
f0104833:	89 35 60 7a 34 f0    	mov    %esi,0xf0347a60
	switch (tf->tf_trapno)
f0104839:	8b 46 28             	mov    0x28(%esi),%eax
f010483c:	83 e8 03             	sub    $0x3,%eax
f010483f:	83 f8 30             	cmp    $0x30,%eax
f0104842:	0f 87 a3 02 00 00    	ja     f0104aeb <trap+0x2fb>
f0104848:	ff 24 85 60 89 10 f0 	jmp    *-0xfef76a0(,%eax,4)
	spin_lock(&kernel_lock);
f010484f:	83 ec 0c             	sub    $0xc,%esp
f0104852:	68 c0 53 12 f0       	push   $0xf01253c0
f0104857:	e8 de 22 00 00       	call   f0106b3a <spin_lock>
f010485c:	83 c4 10             	add    $0x10,%esp
f010485f:	eb be                	jmp    f010481f <trap+0x2f>
	assert(!(read_eflags() & FL_IF));
f0104861:	68 6a 86 10 f0       	push   $0xf010866a
f0104866:	68 db 80 10 f0       	push   $0xf01080db
f010486b:	68 86 01 00 00       	push   $0x186
f0104870:	68 5e 86 10 f0       	push   $0xf010865e
f0104875:	e8 c6 b7 ff ff       	call   f0100040 <_panic>
f010487a:	83 ec 0c             	sub    $0xc,%esp
f010487d:	68 c0 53 12 f0       	push   $0xf01253c0
f0104882:	e8 b3 22 00 00       	call   f0106b3a <spin_lock>
		assert(curenv);
f0104887:	e8 3e 20 00 00       	call   f01068ca <cpunum>
f010488c:	6b c0 74             	imul   $0x74,%eax,%eax
f010488f:	83 c4 10             	add    $0x10,%esp
f0104892:	83 b8 28 80 34 f0 00 	cmpl   $0x0,-0xfcb7fd8(%eax)
f0104899:	74 3e                	je     f01048d9 <trap+0xe9>
		if (curenv->env_status == ENV_DYING) {
f010489b:	e8 2a 20 00 00       	call   f01068ca <cpunum>
f01048a0:	6b c0 74             	imul   $0x74,%eax,%eax
f01048a3:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01048a9:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01048ad:	74 43                	je     f01048f2 <trap+0x102>
		curenv->env_tf = *tf;
f01048af:	e8 16 20 00 00       	call   f01068ca <cpunum>
f01048b4:	6b c0 74             	imul   $0x74,%eax,%eax
f01048b7:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01048bd:	b9 11 00 00 00       	mov    $0x11,%ecx
f01048c2:	89 c7                	mov    %eax,%edi
f01048c4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01048c6:	e8 ff 1f 00 00       	call   f01068ca <cpunum>
f01048cb:	6b c0 74             	imul   $0x74,%eax,%eax
f01048ce:	8b b0 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%esi
f01048d4:	e9 5a ff ff ff       	jmp    f0104833 <trap+0x43>
		assert(curenv);
f01048d9:	68 83 86 10 f0       	push   $0xf0108683
f01048de:	68 db 80 10 f0       	push   $0xf01080db
f01048e3:	68 8d 01 00 00       	push   $0x18d
f01048e8:	68 5e 86 10 f0       	push   $0xf010865e
f01048ed:	e8 4e b7 ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f01048f2:	e8 d3 1f 00 00       	call   f01068ca <cpunum>
f01048f7:	83 ec 0c             	sub    $0xc,%esp
f01048fa:	6b c0 74             	imul   $0x74,%eax,%eax
f01048fd:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0104903:	e8 78 ef ff ff       	call   f0103880 <env_free>
			curenv = NULL;
f0104908:	e8 bd 1f 00 00       	call   f01068ca <cpunum>
f010490d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104910:	c7 80 28 80 34 f0 00 	movl   $0x0,-0xfcb7fd8(%eax)
f0104917:	00 00 00 
			sched_yield();
f010491a:	e8 23 04 00 00       	call   f0104d42 <sched_yield>
			page_fault_handler(tf);
f010491f:	83 ec 0c             	sub    $0xc,%esp
f0104922:	56                   	push   %esi
f0104923:	e8 89 fd ff ff       	call   f01046b1 <page_fault_handler>
f0104928:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f010492b:	e8 9a 1f 00 00       	call   f01068ca <cpunum>
f0104930:	6b c0 74             	imul   $0x74,%eax,%eax
f0104933:	83 b8 28 80 34 f0 00 	cmpl   $0x0,-0xfcb7fd8(%eax)
f010493a:	74 18                	je     f0104954 <trap+0x164>
f010493c:	e8 89 1f 00 00       	call   f01068ca <cpunum>
f0104941:	6b c0 74             	imul   $0x74,%eax,%eax
f0104944:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f010494a:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010494e:	0f 84 df 01 00 00    	je     f0104b33 <trap+0x343>
		sched_yield();
f0104954:	e8 e9 03 00 00       	call   f0104d42 <sched_yield>
			monitor(tf);
f0104959:	83 ec 0c             	sub    $0xc,%esp
f010495c:	56                   	push   %esi
f010495d:	e8 cd c2 ff ff       	call   f0100c2f <monitor>
f0104962:	83 c4 10             	add    $0x10,%esp
f0104965:	eb c4                	jmp    f010492b <trap+0x13b>
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, 
f0104967:	83 ec 08             	sub    $0x8,%esp
f010496a:	ff 76 04             	pushl  0x4(%esi)
f010496d:	ff 36                	pushl  (%esi)
f010496f:	ff 76 10             	pushl  0x10(%esi)
f0104972:	ff 76 18             	pushl  0x18(%esi)
f0104975:	ff 76 14             	pushl  0x14(%esi)
f0104978:	ff 76 1c             	pushl  0x1c(%esi)
f010497b:	e8 7a 04 00 00       	call   f0104dfa <syscall>
f0104980:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104983:	83 c4 20             	add    $0x20,%esp
f0104986:	eb a3                	jmp    f010492b <trap+0x13b>
			lapic_eoi();
f0104988:	e8 84 20 00 00       	call   f0106a11 <lapic_eoi>
			sched_yield();
f010498d:	e8 b0 03 00 00       	call   f0104d42 <sched_yield>
			cprintf("IRQ_KBD interrupt on irq 7\n");
f0104992:	83 ec 0c             	sub    $0xc,%esp
f0104995:	68 8a 86 10 f0       	push   $0xf010868a
f010499a:	e8 e4 f3 ff ff       	call   f0103d83 <cprintf>
f010499f:	83 c4 10             	add    $0x10,%esp
f01049a2:	eb 87                	jmp    f010492b <trap+0x13b>
			cprintf("2 interrupt on irq 7\n");
f01049a4:	83 ec 0c             	sub    $0xc,%esp
f01049a7:	68 41 87 10 f0       	push   $0xf0108741
f01049ac:	e8 d2 f3 ff ff       	call   f0103d83 <cprintf>
f01049b1:	83 c4 10             	add    $0x10,%esp
f01049b4:	e9 72 ff ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("3 interrupt on irq 7\n");
f01049b9:	83 ec 0c             	sub    $0xc,%esp
f01049bc:	68 58 87 10 f0       	push   $0xf0108758
f01049c1:	e8 bd f3 ff ff       	call   f0103d83 <cprintf>
f01049c6:	83 c4 10             	add    $0x10,%esp
f01049c9:	e9 5d ff ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("IRQ_SERIAL interrupt on irq 7\n");
f01049ce:	83 ec 0c             	sub    $0xc,%esp
f01049d1:	68 40 89 10 f0       	push   $0xf0108940
f01049d6:	e8 a8 f3 ff ff       	call   f0103d83 <cprintf>
f01049db:	83 c4 10             	add    $0x10,%esp
f01049de:	e9 48 ff ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("5 interrupt on irq 7\n");
f01049e3:	83 ec 0c             	sub    $0xc,%esp
f01049e6:	68 8b 87 10 f0       	push   $0xf010878b
f01049eb:	e8 93 f3 ff ff       	call   f0103d83 <cprintf>
f01049f0:	83 c4 10             	add    $0x10,%esp
f01049f3:	e9 33 ff ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("6 interrupt on irq 7\n");
f01049f8:	83 ec 0c             	sub    $0xc,%esp
f01049fb:	68 a6 86 10 f0       	push   $0xf01086a6
f0104a00:	e8 7e f3 ff ff       	call   f0103d83 <cprintf>
f0104a05:	83 c4 10             	add    $0x10,%esp
f0104a08:	e9 1e ff ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("in Spurious\n");
f0104a0d:	83 ec 0c             	sub    $0xc,%esp
f0104a10:	68 bc 86 10 f0       	push   $0xf01086bc
f0104a15:	e8 69 f3 ff ff       	call   f0103d83 <cprintf>
			cprintf("Spurious interrupt on irq 7\n");
f0104a1a:	c7 04 24 c9 86 10 f0 	movl   $0xf01086c9,(%esp)
f0104a21:	e8 5d f3 ff ff       	call   f0103d83 <cprintf>
f0104a26:	83 c4 10             	add    $0x10,%esp
f0104a29:	e9 fd fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("8 interrupt on irq 7\n");
f0104a2e:	83 ec 0c             	sub    $0xc,%esp
f0104a31:	68 e6 86 10 f0       	push   $0xf01086e6
f0104a36:	e8 48 f3 ff ff       	call   f0103d83 <cprintf>
f0104a3b:	83 c4 10             	add    $0x10,%esp
f0104a3e:	e9 e8 fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("9 interrupt on irq 7\n");
f0104a43:	83 ec 0c             	sub    $0xc,%esp
f0104a46:	68 fc 86 10 f0       	push   $0xf01086fc
f0104a4b:	e8 33 f3 ff ff       	call   f0103d83 <cprintf>
f0104a50:	83 c4 10             	add    $0x10,%esp
f0104a53:	e9 d3 fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("10 interrupt on irq 7\n");
f0104a58:	83 ec 0c             	sub    $0xc,%esp
f0104a5b:	68 12 87 10 f0       	push   $0xf0108712
f0104a60:	e8 1e f3 ff ff       	call   f0103d83 <cprintf>
f0104a65:	83 c4 10             	add    $0x10,%esp
f0104a68:	e9 be fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("11 interrupt on irq 7\n");
f0104a6d:	83 ec 0c             	sub    $0xc,%esp
f0104a70:	68 29 87 10 f0       	push   $0xf0108729
f0104a75:	e8 09 f3 ff ff       	call   f0103d83 <cprintf>
f0104a7a:	83 c4 10             	add    $0x10,%esp
f0104a7d:	e9 a9 fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("12 interrupt on irq 7\n");
f0104a82:	83 ec 0c             	sub    $0xc,%esp
f0104a85:	68 40 87 10 f0       	push   $0xf0108740
f0104a8a:	e8 f4 f2 ff ff       	call   f0103d83 <cprintf>
f0104a8f:	83 c4 10             	add    $0x10,%esp
f0104a92:	e9 94 fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("13 interrupt on irq 7\n");
f0104a97:	83 ec 0c             	sub    $0xc,%esp
f0104a9a:	68 57 87 10 f0       	push   $0xf0108757
f0104a9f:	e8 df f2 ff ff       	call   f0103d83 <cprintf>
f0104aa4:	83 c4 10             	add    $0x10,%esp
f0104aa7:	e9 7f fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("IRQ_IDE interrupt on irq 7\n");
f0104aac:	83 ec 0c             	sub    $0xc,%esp
f0104aaf:	68 6e 87 10 f0       	push   $0xf010876e
f0104ab4:	e8 ca f2 ff ff       	call   f0103d83 <cprintf>
f0104ab9:	83 c4 10             	add    $0x10,%esp
f0104abc:	e9 6a fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("15 interrupt on irq 7\n");
f0104ac1:	83 ec 0c             	sub    $0xc,%esp
f0104ac4:	68 8a 87 10 f0       	push   $0xf010878a
f0104ac9:	e8 b5 f2 ff ff       	call   f0103d83 <cprintf>
f0104ace:	83 c4 10             	add    $0x10,%esp
f0104ad1:	e9 55 fe ff ff       	jmp    f010492b <trap+0x13b>
			cprintf("IRQ_ERROR interrupt on irq 7\n");
f0104ad6:	83 ec 0c             	sub    $0xc,%esp
f0104ad9:	68 a1 87 10 f0       	push   $0xf01087a1
f0104ade:	e8 a0 f2 ff ff       	call   f0103d83 <cprintf>
f0104ae3:	83 c4 10             	add    $0x10,%esp
f0104ae6:	e9 40 fe ff ff       	jmp    f010492b <trap+0x13b>
			print_trapframe(tf);
f0104aeb:	83 ec 0c             	sub    $0xc,%esp
f0104aee:	56                   	push   %esi
f0104aef:	e8 1a fa ff ff       	call   f010450e <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104af4:	83 c4 10             	add    $0x10,%esp
f0104af7:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104afc:	74 1e                	je     f0104b1c <trap+0x32c>
				env_destroy(curenv);
f0104afe:	e8 c7 1d 00 00       	call   f01068ca <cpunum>
f0104b03:	83 ec 0c             	sub    $0xc,%esp
f0104b06:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b09:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0104b0f:	e8 1a ef ff ff       	call   f0103a2e <env_destroy>
f0104b14:	83 c4 10             	add    $0x10,%esp
f0104b17:	e9 0f fe ff ff       	jmp    f010492b <trap+0x13b>
				panic("unhandled trap in kernel");
f0104b1c:	83 ec 04             	sub    $0x4,%esp
f0104b1f:	68 bf 87 10 f0       	push   $0xf01087bf
f0104b24:	68 69 01 00 00       	push   $0x169
f0104b29:	68 5e 86 10 f0       	push   $0xf010865e
f0104b2e:	e8 0d b5 ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0104b33:	e8 92 1d 00 00       	call   f01068ca <cpunum>
f0104b38:	83 ec 0c             	sub    $0xc,%esp
f0104b3b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b3e:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0104b44:	e8 84 ef ff ff       	call   f0103acd <env_run>
f0104b49:	90                   	nop

f0104b4a <DIVIDE_HANDLER>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(DIVIDE_HANDLER   , T_DIVIDE )
f0104b4a:	6a 00                	push   $0x0
f0104b4c:	6a 00                	push   $0x0
f0104b4e:	e9 f9 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b53:	90                   	nop

f0104b54 <DEBUG_HANDLER>:
	TRAPHANDLER_NOEC(DEBUG_HANDLER    , T_DEBUG  )
f0104b54:	6a 00                	push   $0x0
f0104b56:	6a 01                	push   $0x1
f0104b58:	e9 ef 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b5d:	90                   	nop

f0104b5e <NMI_HANDLER>:
	TRAPHANDLER_NOEC(NMI_HANDLER      , T_NMI    )
f0104b5e:	6a 00                	push   $0x0
f0104b60:	6a 02                	push   $0x2
f0104b62:	e9 e5 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b67:	90                   	nop

f0104b68 <BRKPT_HANDLER>:
	TRAPHANDLER_NOEC(BRKPT_HANDLER    , T_BRKPT  )
f0104b68:	6a 00                	push   $0x0
f0104b6a:	6a 03                	push   $0x3
f0104b6c:	e9 db 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b71:	90                   	nop

f0104b72 <OFLOW_HANDLER>:
	TRAPHANDLER_NOEC(OFLOW_HANDLER    , T_OFLOW  )
f0104b72:	6a 00                	push   $0x0
f0104b74:	6a 04                	push   $0x4
f0104b76:	e9 d1 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b7b:	90                   	nop

f0104b7c <BOUND_HANDLER>:
	TRAPHANDLER_NOEC(BOUND_HANDLER    , T_BOUND  )
f0104b7c:	6a 00                	push   $0x0
f0104b7e:	6a 05                	push   $0x5
f0104b80:	e9 c7 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b85:	90                   	nop

f0104b86 <ILLOP_HANDLER>:
	TRAPHANDLER_NOEC(ILLOP_HANDLER    , T_ILLOP  )
f0104b86:	6a 00                	push   $0x0
f0104b88:	6a 06                	push   $0x6
f0104b8a:	e9 bd 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b8f:	90                   	nop

f0104b90 <DEVICE_HANDLER>:
	TRAPHANDLER_NOEC(DEVICE_HANDLER   , T_DEVICE )
f0104b90:	6a 00                	push   $0x0
f0104b92:	6a 07                	push   $0x7
f0104b94:	e9 b3 00 00 00       	jmp    f0104c4c <_alltraps>
f0104b99:	90                   	nop

f0104b9a <DBLFLT_HANDLER>:
	TRAPHANDLER(	 DBLFLT_HANDLER   , T_DBLFLT )
f0104b9a:	6a 08                	push   $0x8
f0104b9c:	e9 ab 00 00 00       	jmp    f0104c4c <_alltraps>
f0104ba1:	90                   	nop

f0104ba2 <TSS_HANDLER>:
	TRAPHANDLER(	 TSS_HANDLER      , T_TSS	 )
f0104ba2:	6a 0a                	push   $0xa
f0104ba4:	e9 a3 00 00 00       	jmp    f0104c4c <_alltraps>
f0104ba9:	90                   	nop

f0104baa <SEGNP_HANDLER>:
	TRAPHANDLER(	 SEGNP_HANDLER    , T_SEGNP  )
f0104baa:	6a 0b                	push   $0xb
f0104bac:	e9 9b 00 00 00       	jmp    f0104c4c <_alltraps>
f0104bb1:	90                   	nop

f0104bb2 <STACK_HANDLER>:
	TRAPHANDLER(	 STACK_HANDLER    , T_STACK  )
f0104bb2:	6a 0c                	push   $0xc
f0104bb4:	e9 93 00 00 00       	jmp    f0104c4c <_alltraps>
f0104bb9:	90                   	nop

f0104bba <GPFLT_HANDLER>:
	TRAPHANDLER(	 GPFLT_HANDLER    , T_GPFLT  )
f0104bba:	6a 0d                	push   $0xd
f0104bbc:	e9 8b 00 00 00       	jmp    f0104c4c <_alltraps>
f0104bc1:	90                   	nop

f0104bc2 <PGFLT_HANDLER>:
	TRAPHANDLER(	 PGFLT_HANDLER    , T_PGFLT  )
f0104bc2:	6a 0e                	push   $0xe
f0104bc4:	e9 83 00 00 00       	jmp    f0104c4c <_alltraps>
f0104bc9:	90                   	nop

f0104bca <FPERR_HANDLER>:
	TRAPHANDLER_NOEC(FPERR_HANDLER 	  , T_FPERR  )
f0104bca:	6a 00                	push   $0x0
f0104bcc:	6a 10                	push   $0x10
f0104bce:	eb 7c                	jmp    f0104c4c <_alltraps>

f0104bd0 <ALIGN_HANDLER>:
	TRAPHANDLER(	 ALIGN_HANDLER    , T_ALIGN  )
f0104bd0:	6a 11                	push   $0x11
f0104bd2:	eb 78                	jmp    f0104c4c <_alltraps>

f0104bd4 <MCHK_HANDLER>:
	TRAPHANDLER_NOEC(MCHK_HANDLER     , T_MCHK   )
f0104bd4:	6a 00                	push   $0x0
f0104bd6:	6a 12                	push   $0x12
f0104bd8:	eb 72                	jmp    f0104c4c <_alltraps>

f0104bda <SIMDERR_HANDLER>:
	TRAPHANDLER_NOEC(SIMDERR_HANDLER  , T_SIMDERR)
f0104bda:	6a 00                	push   $0x0
f0104bdc:	6a 13                	push   $0x13
f0104bde:	eb 6c                	jmp    f0104c4c <_alltraps>

f0104be0 <SYSCALL_HANDLER>:
	TRAPHANDLER_NOEC(SYSCALL_HANDLER  , T_SYSCALL) /* just test*/
f0104be0:	6a 00                	push   $0x0
f0104be2:	6a 30                	push   $0x30
f0104be4:	eb 66                	jmp    f0104c4c <_alltraps>

f0104be6 <TIMER_HANDLER>:

	TRAPHANDLER_NOEC(TIMER_HANDLER	  , IRQ_OFFSET + IRQ_TIMER)
f0104be6:	6a 00                	push   $0x0
f0104be8:	6a 20                	push   $0x20
f0104bea:	eb 60                	jmp    f0104c4c <_alltraps>

f0104bec <KBD_HANDLER>:
	TRAPHANDLER_NOEC(KBD_HANDLER	  , IRQ_OFFSET + IRQ_KBD)
f0104bec:	6a 00                	push   $0x0
f0104bee:	6a 21                	push   $0x21
f0104bf0:	eb 5a                	jmp    f0104c4c <_alltraps>

f0104bf2 <SECOND_HANDLER>:
	TRAPHANDLER_NOEC(SECOND_HANDLER	  , IRQ_OFFSET + 2)
f0104bf2:	6a 00                	push   $0x0
f0104bf4:	6a 22                	push   $0x22
f0104bf6:	eb 54                	jmp    f0104c4c <_alltraps>

f0104bf8 <THIRD_HANDLER>:
	TRAPHANDLER_NOEC(THIRD_HANDLER	  , IRQ_OFFSET + 3)
f0104bf8:	6a 00                	push   $0x0
f0104bfa:	6a 23                	push   $0x23
f0104bfc:	eb 4e                	jmp    f0104c4c <_alltraps>

f0104bfe <SERIAL_HANDLER>:
	TRAPHANDLER_NOEC(SERIAL_HANDLER	  , IRQ_OFFSET + IRQ_SERIAL)
f0104bfe:	6a 00                	push   $0x0
f0104c00:	6a 24                	push   $0x24
f0104c02:	eb 48                	jmp    f0104c4c <_alltraps>

f0104c04 <FIFTH_HANDLER>:
	TRAPHANDLER_NOEC(FIFTH_HANDLER	  , IRQ_OFFSET + 5)
f0104c04:	6a 00                	push   $0x0
f0104c06:	6a 25                	push   $0x25
f0104c08:	eb 42                	jmp    f0104c4c <_alltraps>

f0104c0a <SIXTH_HANDLER>:
	TRAPHANDLER_NOEC(SIXTH_HANDLER	  , IRQ_OFFSET + 6)
f0104c0a:	6a 00                	push   $0x0
f0104c0c:	6a 26                	push   $0x26
f0104c0e:	eb 3c                	jmp    f0104c4c <_alltraps>

f0104c10 <SPURIOUS_HANDLER>:
	TRAPHANDLER_NOEC(SPURIOUS_HANDLER , IRQ_OFFSET + IRQ_SPURIOUS)
f0104c10:	6a 00                	push   $0x0
f0104c12:	6a 27                	push   $0x27
f0104c14:	eb 36                	jmp    f0104c4c <_alltraps>

f0104c16 <EIGHTH_HANDLER>:
	TRAPHANDLER_NOEC(EIGHTH_HANDLER	  , IRQ_OFFSET + 8)
f0104c16:	6a 00                	push   $0x0
f0104c18:	6a 28                	push   $0x28
f0104c1a:	eb 30                	jmp    f0104c4c <_alltraps>

f0104c1c <NINTH_HANDLER>:
	TRAPHANDLER_NOEC(NINTH_HANDLER	  , IRQ_OFFSET + 9)
f0104c1c:	6a 00                	push   $0x0
f0104c1e:	6a 29                	push   $0x29
f0104c20:	eb 2a                	jmp    f0104c4c <_alltraps>

f0104c22 <TENTH_HANDLER>:
	TRAPHANDLER_NOEC(TENTH_HANDLER	  , IRQ_OFFSET + 10)
f0104c22:	6a 00                	push   $0x0
f0104c24:	6a 2a                	push   $0x2a
f0104c26:	eb 24                	jmp    f0104c4c <_alltraps>

f0104c28 <ELEVEN_HANDLER>:
	TRAPHANDLER_NOEC(ELEVEN_HANDLER	  , IRQ_OFFSET + 11)
f0104c28:	6a 00                	push   $0x0
f0104c2a:	6a 2b                	push   $0x2b
f0104c2c:	eb 1e                	jmp    f0104c4c <_alltraps>

f0104c2e <TWELVE_HANDLER>:
	TRAPHANDLER_NOEC(TWELVE_HANDLER	  , IRQ_OFFSET + 12)
f0104c2e:	6a 00                	push   $0x0
f0104c30:	6a 2c                	push   $0x2c
f0104c32:	eb 18                	jmp    f0104c4c <_alltraps>

f0104c34 <THIRTEEN_HANDLER>:
	TRAPHANDLER_NOEC(THIRTEEN_HANDLER , IRQ_OFFSET + 13)
f0104c34:	6a 00                	push   $0x0
f0104c36:	6a 2d                	push   $0x2d
f0104c38:	eb 12                	jmp    f0104c4c <_alltraps>

f0104c3a <IDE_HANDLER>:
	TRAPHANDLER_NOEC(IDE_HANDLER	  , IRQ_OFFSET + IRQ_IDE)
f0104c3a:	6a 00                	push   $0x0
f0104c3c:	6a 2e                	push   $0x2e
f0104c3e:	eb 0c                	jmp    f0104c4c <_alltraps>

f0104c40 <FIFTEEN_HANDLER>:
	TRAPHANDLER_NOEC(FIFTEEN_HANDLER  , IRQ_OFFSET + 15)
f0104c40:	6a 00                	push   $0x0
f0104c42:	6a 2f                	push   $0x2f
f0104c44:	eb 06                	jmp    f0104c4c <_alltraps>

f0104c46 <ERROR_HANDLER>:
	TRAPHANDLER_NOEC(ERROR_HANDLER	  , IRQ_OFFSET + IRQ_ERROR)
f0104c46:	6a 00                	push   $0x0
f0104c48:	6a 33                	push   $0x33
f0104c4a:	eb 00                	jmp    f0104c4c <_alltraps>

f0104c4c <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */

.globl _alltraps
_alltraps:
	pushw $0
f0104c4c:	66 6a 00             	pushw  $0x0
	pushw %ds 
f0104c4f:	66 1e                	pushw  %ds
	pushw $0
f0104c51:	66 6a 00             	pushw  $0x0
	pushw %es 
f0104c54:	66 06                	pushw  %es
	pushal
f0104c56:	60                   	pusha  

	movl $(GD_KD), %eax 
f0104c57:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds 
f0104c5c:	8e d8                	mov    %eax,%ds
	movw %ax, %es 
f0104c5e:	8e c0                	mov    %eax,%es

	pushl %esp 
f0104c60:	54                   	push   %esp
	call trap
f0104c61:	e8 8a fb ff ff       	call   f01047f0 <trap>

f0104c66 <sysenter_handler>:

; .global sysenter_handler
; sysenter_handler:
; 	pushl %esi 
f0104c66:	56                   	push   %esi
; 	pushl %edi
f0104c67:	57                   	push   %edi
; 	pushl %ebx
f0104c68:	53                   	push   %ebx
; 	pushl %ecx 
f0104c69:	51                   	push   %ecx
; 	pushl %edx
f0104c6a:	52                   	push   %edx
; 	pushl %eax
f0104c6b:	50                   	push   %eax
; 	call syscall
f0104c6c:	e8 89 01 00 00       	call   f0104dfa <syscall>
; 	movl %esi, %edx
f0104c71:	89 f2                	mov    %esi,%edx
; 	movl %ebp, %ecx 
f0104c73:	89 e9                	mov    %ebp,%ecx
f0104c75:	0f 35                	sysexit 

f0104c77 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104c77:	55                   	push   %ebp
f0104c78:	89 e5                	mov    %esp,%ebp
f0104c7a:	83 ec 08             	sub    $0x8,%esp
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104c7d:	8b 0d 44 72 34 f0    	mov    0xf0347244,%ecx
	for (i = 0; i < NENV; i++) {
f0104c83:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104c88:	89 c2                	mov    %eax,%edx
f0104c8a:	c1 e2 07             	shl    $0x7,%edx
		     envs[i].env_status == ENV_RUNNING ||
f0104c8d:	8b 54 11 54          	mov    0x54(%ecx,%edx,1),%edx
f0104c91:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104c94:	83 fa 02             	cmp    $0x2,%edx
f0104c97:	76 29                	jbe    f0104cc2 <sched_halt+0x4b>
	for (i = 0; i < NENV; i++) {
f0104c99:	83 c0 01             	add    $0x1,%eax
f0104c9c:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104ca1:	75 e5                	jne    f0104c88 <sched_halt+0x11>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104ca3:	83 ec 0c             	sub    $0xc,%esp
f0104ca6:	68 90 8a 10 f0       	push   $0xf0108a90
f0104cab:	e8 d3 f0 ff ff       	call   f0103d83 <cprintf>
f0104cb0:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104cb3:	83 ec 0c             	sub    $0xc,%esp
f0104cb6:	6a 00                	push   $0x0
f0104cb8:	e8 72 bf ff ff       	call   f0100c2f <monitor>
f0104cbd:	83 c4 10             	add    $0x10,%esp
f0104cc0:	eb f1                	jmp    f0104cb3 <sched_halt+0x3c>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104cc2:	e8 03 1c 00 00       	call   f01068ca <cpunum>
f0104cc7:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cca:	c7 80 28 80 34 f0 00 	movl   $0x0,-0xfcb7fd8(%eax)
f0104cd1:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104cd4:	a1 8c 7e 34 f0       	mov    0xf0347e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0104cd9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104cde:	76 50                	jbe    f0104d30 <sched_halt+0xb9>
	return (physaddr_t)kva - KERNBASE;
f0104ce0:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104ce5:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104ce8:	e8 dd 1b 00 00       	call   f01068ca <cpunum>
f0104ced:	6b d0 74             	imul   $0x74,%eax,%edx
f0104cf0:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104cf3:	b8 02 00 00 00       	mov    $0x2,%eax
f0104cf8:	f0 87 82 20 80 34 f0 	lock xchg %eax,-0xfcb7fe0(%edx)
	spin_unlock(&kernel_lock);
f0104cff:	83 ec 0c             	sub    $0xc,%esp
f0104d02:	68 c0 53 12 f0       	push   $0xf01253c0
f0104d07:	e8 ca 1e 00 00       	call   f0106bd6 <spin_unlock>
	asm volatile("pause");
f0104d0c:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104d0e:	e8 b7 1b 00 00       	call   f01068ca <cpunum>
f0104d13:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104d16:	8b 80 30 80 34 f0    	mov    -0xfcb7fd0(%eax),%eax
f0104d1c:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104d21:	89 c4                	mov    %eax,%esp
f0104d23:	6a 00                	push   $0x0
f0104d25:	6a 00                	push   $0x0
f0104d27:	fb                   	sti    
f0104d28:	f4                   	hlt    
f0104d29:	eb fd                	jmp    f0104d28 <sched_halt+0xb1>
}
f0104d2b:	83 c4 10             	add    $0x10,%esp
f0104d2e:	c9                   	leave  
f0104d2f:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104d30:	50                   	push   %eax
f0104d31:	68 98 6f 10 f0       	push   $0xf0106f98
f0104d36:	6a 4c                	push   $0x4c
f0104d38:	68 b9 8a 10 f0       	push   $0xf0108ab9
f0104d3d:	e8 fe b2 ff ff       	call   f0100040 <_panic>

f0104d42 <sched_yield>:
{
f0104d42:	55                   	push   %ebp
f0104d43:	89 e5                	mov    %esp,%ebp
f0104d45:	53                   	push   %ebx
f0104d46:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f0104d49:	e8 7c 1b 00 00       	call   f01068ca <cpunum>
f0104d4e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d51:	83 b8 28 80 34 f0 00 	cmpl   $0x0,-0xfcb7fd8(%eax)
f0104d58:	74 7d                	je     f0104dd7 <sched_yield+0x95>
		envid_t cur_tone = ENVX(curenv->env_id);
f0104d5a:	e8 6b 1b 00 00       	call   f01068ca <cpunum>
f0104d5f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d62:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104d68:	8b 48 48             	mov    0x48(%eax),%ecx
f0104d6b:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104d71:	8d 41 01             	lea    0x1(%ecx),%eax
f0104d74:	25 ff 03 00 00       	and    $0x3ff,%eax
			if(envs[i].env_status == ENV_RUNNABLE){
f0104d79:	8b 1d 44 72 34 f0    	mov    0xf0347244,%ebx
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104d7f:	39 c8                	cmp    %ecx,%eax
f0104d81:	74 20                	je     f0104da3 <sched_yield+0x61>
			if(envs[i].env_status == ENV_RUNNABLE){
f0104d83:	89 c2                	mov    %eax,%edx
f0104d85:	c1 e2 07             	shl    $0x7,%edx
f0104d88:	01 da                	add    %ebx,%edx
f0104d8a:	83 7a 54 02          	cmpl   $0x2,0x54(%edx)
f0104d8e:	74 0a                	je     f0104d9a <sched_yield+0x58>
		for(i = ENVX(cur_tone + 1); i != cur_tone; i = ENVX(i+1)){
f0104d90:	83 c0 01             	add    $0x1,%eax
f0104d93:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104d98:	eb e5                	jmp    f0104d7f <sched_yield+0x3d>
				env_run(&envs[i]);
f0104d9a:	83 ec 0c             	sub    $0xc,%esp
f0104d9d:	52                   	push   %edx
f0104d9e:	e8 2a ed ff ff       	call   f0103acd <env_run>
		if(curenv->env_status == ENV_RUNNING)
f0104da3:	e8 22 1b 00 00       	call   f01068ca <cpunum>
f0104da8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dab:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104db1:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104db5:	74 0a                	je     f0104dc1 <sched_yield+0x7f>
	sched_halt();
f0104db7:	e8 bb fe ff ff       	call   f0104c77 <sched_halt>
}
f0104dbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104dbf:	c9                   	leave  
f0104dc0:	c3                   	ret    
			env_run(curenv);
f0104dc1:	e8 04 1b 00 00       	call   f01068ca <cpunum>
f0104dc6:	83 ec 0c             	sub    $0xc,%esp
f0104dc9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dcc:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0104dd2:	e8 f6 ec ff ff       	call   f0103acd <env_run>
f0104dd7:	a1 44 72 34 f0       	mov    0xf0347244,%eax
f0104ddc:	8d 90 00 00 02 00    	lea    0x20000(%eax),%edx
     		if(envs[i].env_status == ENV_RUNNABLE) {
f0104de2:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104de6:	74 09                	je     f0104df1 <sched_yield+0xaf>
f0104de8:	83 e8 80             	sub    $0xffffff80,%eax
		for(i = 0 ; i < NENV; i++)
f0104deb:	39 d0                	cmp    %edx,%eax
f0104ded:	75 f3                	jne    f0104de2 <sched_yield+0xa0>
f0104def:	eb c6                	jmp    f0104db7 <sched_yield+0x75>
		  		env_run(&envs[i]);
f0104df1:	83 ec 0c             	sub    $0xc,%esp
f0104df4:	50                   	push   %eax
f0104df5:	e8 d3 ec ff ff       	call   f0103acd <env_run>

f0104dfa <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104dfa:	55                   	push   %ebp
f0104dfb:	89 e5                	mov    %esp,%ebp
f0104dfd:	57                   	push   %edi
f0104dfe:	56                   	push   %esi
f0104dff:	53                   	push   %ebx
f0104e00:	83 ec 1c             	sub    $0x1c,%esp
f0104e03:	8b 45 08             	mov    0x8(%ebp),%eax
	// cprintf("try to get lock\n");
	// lock_kernel();
	// asm volatile("cli\n");
	// cprintf("%d: in %s\n", curenv->env_id, __FUNCTION__);
	int ret = 0;
	switch (syscallno)
f0104e06:	83 f8 10             	cmp    $0x10,%eax
f0104e09:	0f 87 4f 07 00 00    	ja     f010555e <syscall+0x764>
f0104e0f:	ff 24 85 40 8b 10 f0 	jmp    *-0xfef74c0(,%eax,4)
	user_mem_assert(curenv, s, len, PTE_U);
f0104e16:	e8 af 1a 00 00       	call   f01068ca <cpunum>
f0104e1b:	6a 04                	push   $0x4
f0104e1d:	ff 75 10             	pushl  0x10(%ebp)
f0104e20:	ff 75 0c             	pushl  0xc(%ebp)
f0104e23:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e26:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0104e2c:	e8 dd e5 ff ff       	call   f010340e <user_mem_assert>
	cprintf("%.*s", len, s);
f0104e31:	83 c4 0c             	add    $0xc,%esp
f0104e34:	ff 75 0c             	pushl  0xc(%ebp)
f0104e37:	ff 75 10             	pushl  0x10(%ebp)
f0104e3a:	68 c6 8a 10 f0       	push   $0xf0108ac6
f0104e3f:	e8 3f ef ff ff       	call   f0103d83 <cprintf>
f0104e44:	83 c4 10             	add    $0x10,%esp
	int ret = 0;
f0104e47:	bb 00 00 00 00       	mov    $0x0,%ebx
			ret = -E_INVAL;
	}
	// unlock_kernel();
	// asm volatile("sti\n"); //lab4 bug? corresponding to /lib/syscall.c cli
	return ret;
}
f0104e4c:	89 d8                	mov    %ebx,%eax
f0104e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104e51:	5b                   	pop    %ebx
f0104e52:	5e                   	pop    %esi
f0104e53:	5f                   	pop    %edi
f0104e54:	5d                   	pop    %ebp
f0104e55:	c3                   	ret    
	return cons_getc();
f0104e56:	e8 ad b7 ff ff       	call   f0100608 <cons_getc>
f0104e5b:	89 c3                	mov    %eax,%ebx
			break;
f0104e5d:	eb ed                	jmp    f0104e4c <syscall+0x52>
	return curenv->env_id;
f0104e5f:	e8 66 1a 00 00       	call   f01068ca <cpunum>
f0104e64:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e67:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104e6d:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f0104e70:	eb da                	jmp    f0104e4c <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104e72:	83 ec 04             	sub    $0x4,%esp
f0104e75:	6a 01                	push   $0x1
f0104e77:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104e7a:	50                   	push   %eax
f0104e7b:	ff 75 0c             	pushl  0xc(%ebp)
f0104e7e:	e8 5d e6 ff ff       	call   f01034e0 <envid2env>
f0104e83:	89 c3                	mov    %eax,%ebx
f0104e85:	83 c4 10             	add    $0x10,%esp
f0104e88:	85 c0                	test   %eax,%eax
f0104e8a:	78 c0                	js     f0104e4c <syscall+0x52>
	env_destroy(e);
f0104e8c:	83 ec 0c             	sub    $0xc,%esp
f0104e8f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104e92:	e8 97 eb ff ff       	call   f0103a2e <env_destroy>
f0104e97:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0104e9f:	eb ab                	jmp    f0104e4c <syscall+0x52>
	if ((uint32_t)kva < KERNBASE)
f0104ea1:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f0104ea8:	76 4a                	jbe    f0104ef4 <syscall+0xfa>
	return (physaddr_t)kva - KERNBASE;
f0104eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104ead:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0104eb2:	c1 e8 0c             	shr    $0xc,%eax
f0104eb5:	3b 05 88 7e 34 f0    	cmp    0xf0347e88,%eax
f0104ebb:	73 4e                	jae    f0104f0b <syscall+0x111>
	return &pages[PGNUM(pa)];
f0104ebd:	8b 15 90 7e 34 f0    	mov    0xf0347e90,%edx
f0104ec3:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f0104ec6:	85 db                	test   %ebx,%ebx
f0104ec8:	0f 84 9a 06 00 00    	je     f0105568 <syscall+0x76e>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f0104ece:	e8 f7 19 00 00       	call   f01068ca <cpunum>
f0104ed3:	6a 06                	push   $0x6
f0104ed5:	ff 75 10             	pushl  0x10(%ebp)
f0104ed8:	53                   	push   %ebx
f0104ed9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104edc:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104ee2:	ff 70 60             	pushl  0x60(%eax)
f0104ee5:	e8 f4 c6 ff ff       	call   f01015de <page_insert>
f0104eea:	89 c3                	mov    %eax,%ebx
f0104eec:	83 c4 10             	add    $0x10,%esp
f0104eef:	e9 58 ff ff ff       	jmp    f0104e4c <syscall+0x52>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104ef4:	ff 75 0c             	pushl  0xc(%ebp)
f0104ef7:	68 98 6f 10 f0       	push   $0xf0106f98
f0104efc:	68 9d 01 00 00       	push   $0x19d
f0104f01:	68 cb 8a 10 f0       	push   $0xf0108acb
f0104f06:	e8 35 b1 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0104f0b:	83 ec 04             	sub    $0x4,%esp
f0104f0e:	68 50 78 10 f0       	push   $0xf0107850
f0104f13:	6a 51                	push   $0x51
f0104f15:	68 c1 80 10 f0       	push   $0xf01080c1
f0104f1a:	e8 21 b1 ff ff       	call   f0100040 <_panic>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0104f1f:	e8 a6 19 00 00       	call   f01068ca <cpunum>
	if(inc < PGSIZE){
f0104f24:	81 7d 0c ff 0f 00 00 	cmpl   $0xfff,0xc(%ebp)
f0104f2b:	77 1b                	ja     f0104f48 <syscall+0x14e>
	uint32_t mod = ((uint32_t)curenv->env_sbrk)%PGSIZE;
f0104f2d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f30:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104f36:	8b 40 7c             	mov    0x7c(%eax),%eax
f0104f39:	25 ff 0f 00 00       	and    $0xfff,%eax
		if((mod + inc) < PGSIZE){
f0104f3e:	03 45 0c             	add    0xc(%ebp),%eax
f0104f41:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0104f46:	76 7c                	jbe    f0104fc4 <syscall+0x1ca>
	int i = ROUNDDOWN((uint32_t)curenv->env_sbrk, PGSIZE);
f0104f48:	e8 7d 19 00 00       	call   f01068ca <cpunum>
f0104f4d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f50:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104f56:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0104f59:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int end = ROUNDUP((uint32_t)curenv->env_sbrk + inc, PGSIZE);
f0104f5f:	e8 66 19 00 00       	call   f01068ca <cpunum>
f0104f64:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f67:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104f6d:	8b 40 7c             	mov    0x7c(%eax),%eax
f0104f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104f73:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f0104f7a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for(; i < end; i+=PGSIZE){
f0104f80:	39 df                	cmp    %ebx,%edi
f0104f82:	0f 8e 94 00 00 00    	jle    f010501c <syscall+0x222>
		struct PageInfo * page = page_alloc(ALLOC_ZERO);
f0104f88:	83 ec 0c             	sub    $0xc,%esp
f0104f8b:	6a 01                	push   $0x1
f0104f8d:	e8 10 c3 ff ff       	call   f01012a2 <page_alloc>
f0104f92:	89 c6                	mov    %eax,%esi
		if(!page)
f0104f94:	83 c4 10             	add    $0x10,%esp
f0104f97:	85 c0                	test   %eax,%eax
f0104f99:	74 53                	je     f0104fee <syscall+0x1f4>
		int ret = page_insert(curenv->env_pgdir, page, (void*)((uint32_t)i), PTE_U | PTE_W);
f0104f9b:	e8 2a 19 00 00       	call   f01068ca <cpunum>
f0104fa0:	6a 06                	push   $0x6
f0104fa2:	53                   	push   %ebx
f0104fa3:	56                   	push   %esi
f0104fa4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fa7:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104fad:	ff 70 60             	pushl  0x60(%eax)
f0104fb0:	e8 29 c6 ff ff       	call   f01015de <page_insert>
		if(ret)
f0104fb5:	83 c4 10             	add    $0x10,%esp
f0104fb8:	85 c0                	test   %eax,%eax
f0104fba:	75 49                	jne    f0105005 <syscall+0x20b>
	for(; i < end; i+=PGSIZE){
f0104fbc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0104fc2:	eb bc                	jmp    f0104f80 <syscall+0x186>
			curenv->env_sbrk+=inc;
f0104fc4:	e8 01 19 00 00       	call   f01068ca <cpunum>
f0104fc9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fcc:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104fd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104fd5:	01 48 7c             	add    %ecx,0x7c(%eax)
			return curenv->env_sbrk;
f0104fd8:	e8 ed 18 00 00       	call   f01068ca <cpunum>
f0104fdd:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fe0:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0104fe6:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0104fe9:	e9 5e fe ff ff       	jmp    f0104e4c <syscall+0x52>
			panic("there is no page\n");
f0104fee:	83 ec 04             	sub    $0x4,%esp
f0104ff1:	68 24 84 10 f0       	push   $0xf0108424
f0104ff6:	68 b2 01 00 00       	push   $0x1b2
f0104ffb:	68 cb 8a 10 f0       	push   $0xf0108acb
f0105000:	e8 3b b0 ff ff       	call   f0100040 <_panic>
			panic("there is error in insert");
f0105005:	83 ec 04             	sub    $0x4,%esp
f0105008:	68 41 84 10 f0       	push   $0xf0108441
f010500d:	68 b5 01 00 00       	push   $0x1b5
f0105012:	68 cb 8a 10 f0       	push   $0xf0108acb
f0105017:	e8 24 b0 ff ff       	call   f0100040 <_panic>
	curenv->env_sbrk+=inc;
f010501c:	e8 a9 18 00 00       	call   f01068ca <cpunum>
f0105021:	6b c0 74             	imul   $0x74,%eax,%eax
f0105024:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f010502a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010502d:	01 48 7c             	add    %ecx,0x7c(%eax)
	return curenv->env_sbrk;
f0105030:	e8 95 18 00 00       	call   f01068ca <cpunum>
f0105035:	6b c0 74             	imul   $0x74,%eax,%eax
f0105038:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f010503e:	8b 58 7c             	mov    0x7c(%eax),%ebx
f0105041:	e9 06 fe ff ff       	jmp    f0104e4c <syscall+0x52>
			panic("what NSYSCALLSsssssssssssssssssssssssss\n");
f0105046:	83 ec 04             	sub    $0x4,%esp
f0105049:	68 dc 8a 10 f0       	push   $0xf0108adc
f010504e:	68 dc 01 00 00       	push   $0x1dc
f0105053:	68 cb 8a 10 f0       	push   $0xf0108acb
f0105058:	e8 e3 af ff ff       	call   f0100040 <_panic>
	sched_yield();
f010505d:	e8 e0 fc ff ff       	call   f0104d42 <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0105062:	e8 63 18 00 00       	call   f01068ca <cpunum>
f0105067:	83 ec 08             	sub    $0x8,%esp
f010506a:	6b c0 74             	imul   $0x74,%eax,%eax
f010506d:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0105073:	ff 70 48             	pushl  0x48(%eax)
f0105076:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105079:	50                   	push   %eax
f010507a:	e8 61 e5 ff ff       	call   f01035e0 <env_alloc>
f010507f:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105081:	83 c4 10             	add    $0x10,%esp
f0105084:	85 c0                	test   %eax,%eax
f0105086:	0f 88 c0 fd ff ff    	js     f0104e4c <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f010508c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010508f:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f0105096:	e8 2f 18 00 00       	call   f01068ca <cpunum>
f010509b:	6b c0 74             	imul   $0x74,%eax,%eax
f010509e:	8b b0 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%esi
f01050a4:	b9 11 00 00 00       	mov    $0x11,%ecx
f01050a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01050ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01050ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01050b1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01050b8:	8b 58 48             	mov    0x48(%eax),%ebx
			break;
f01050bb:	e9 8c fd ff ff       	jmp    f0104e4c <syscall+0x52>
	switch (status)
f01050c0:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f01050c4:	74 06                	je     f01050cc <syscall+0x2d2>
f01050c6:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f01050ca:	75 54                	jne    f0105120 <syscall+0x326>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f01050cc:	8b 45 10             	mov    0x10(%ebp),%eax
f01050cf:	83 e8 02             	sub    $0x2,%eax
f01050d2:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01050d7:	75 31                	jne    f010510a <syscall+0x310>
	int ret = envid2env(envid, &e, 1);
f01050d9:	83 ec 04             	sub    $0x4,%esp
f01050dc:	6a 01                	push   $0x1
f01050de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01050e1:	50                   	push   %eax
f01050e2:	ff 75 0c             	pushl  0xc(%ebp)
f01050e5:	e8 f6 e3 ff ff       	call   f01034e0 <envid2env>
f01050ea:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01050ec:	83 c4 10             	add    $0x10,%esp
f01050ef:	85 c0                	test   %eax,%eax
f01050f1:	0f 88 55 fd ff ff    	js     f0104e4c <syscall+0x52>
	e->env_status = status;
f01050f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01050fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01050fd:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f0105100:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105105:	e9 42 fd ff ff       	jmp    f0104e4c <syscall+0x52>
	assert(status == ENV_RUNNABLE || status == ENV_NOT_RUNNABLE);
f010510a:	68 08 8b 10 f0       	push   $0xf0108b08
f010510f:	68 db 80 10 f0       	push   $0xf01080db
f0105114:	6a 75                	push   $0x75
f0105116:	68 cb 8a 10 f0       	push   $0xf0108acb
f010511b:	e8 20 af ff ff       	call   f0100040 <_panic>
			return -E_INVAL;
f0105120:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f0105125:	e9 22 fd ff ff       	jmp    f0104e4c <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f010512a:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105131:	0f 87 d2 00 00 00    	ja     f0105209 <syscall+0x40f>
f0105137:	8b 45 10             	mov    0x10(%ebp),%eax
f010513a:	25 ff 0f 00 00       	and    $0xfff,%eax
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f010513f:	8b 55 14             	mov    0x14(%ebp),%edx
f0105142:	83 e2 05             	and    $0x5,%edx
f0105145:	83 fa 05             	cmp    $0x5,%edx
f0105148:	0f 85 c5 00 00 00    	jne    f0105213 <syscall+0x419>
	if(perm & ~PTE_SYSCALL)
f010514e:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105151:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0105157:	09 c3                	or     %eax,%ebx
f0105159:	0f 85 be 00 00 00    	jne    f010521d <syscall+0x423>
	int ret = envid2env(envid, &e, 1);
f010515f:	83 ec 04             	sub    $0x4,%esp
f0105162:	6a 01                	push   $0x1
f0105164:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105167:	50                   	push   %eax
f0105168:	ff 75 0c             	pushl  0xc(%ebp)
f010516b:	e8 70 e3 ff ff       	call   f01034e0 <envid2env>
	if(ret < 0)
f0105170:	83 c4 10             	add    $0x10,%esp
f0105173:	85 c0                	test   %eax,%eax
f0105175:	0f 88 ac 00 00 00    	js     f0105227 <syscall+0x42d>
	struct PageInfo* page = page_alloc(ALLOC_ZERO);
f010517b:	83 ec 0c             	sub    $0xc,%esp
f010517e:	6a 01                	push   $0x1
f0105180:	e8 1d c1 ff ff       	call   f01012a2 <page_alloc>
f0105185:	89 c6                	mov    %eax,%esi
	if(page == NULL)
f0105187:	83 c4 10             	add    $0x10,%esp
f010518a:	85 c0                	test   %eax,%eax
f010518c:	0f 84 9c 00 00 00    	je     f010522e <syscall+0x434>
	page->pp_ref++;//lab4 bug?
f0105192:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0105197:	2b 05 90 7e 34 f0    	sub    0xf0347e90,%eax
f010519d:	c1 f8 03             	sar    $0x3,%eax
f01051a0:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01051a3:	89 c2                	mov    %eax,%edx
f01051a5:	c1 ea 0c             	shr    $0xc,%edx
f01051a8:	3b 15 88 7e 34 f0    	cmp    0xf0347e88,%edx
f01051ae:	73 47                	jae    f01051f7 <syscall+0x3fd>
	memset(page2kva(page), 0, PGSIZE);
f01051b0:	83 ec 04             	sub    $0x4,%esp
f01051b3:	68 00 10 00 00       	push   $0x1000
f01051b8:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01051ba:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01051bf:	50                   	push   %eax
f01051c0:	e8 04 11 00 00       	call   f01062c9 <memset>
	ret = page_insert(e->env_pgdir, page, va, perm);
f01051c5:	ff 75 14             	pushl  0x14(%ebp)
f01051c8:	ff 75 10             	pushl  0x10(%ebp)
f01051cb:	56                   	push   %esi
f01051cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051cf:	ff 70 60             	pushl  0x60(%eax)
f01051d2:	e8 07 c4 ff ff       	call   f01015de <page_insert>
f01051d7:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f01051d9:	83 c4 20             	add    $0x20,%esp
f01051dc:	85 c0                	test   %eax,%eax
f01051de:	0f 89 68 fc ff ff    	jns    f0104e4c <syscall+0x52>
		page_free(page);
f01051e4:	83 ec 0c             	sub    $0xc,%esp
f01051e7:	56                   	push   %esi
f01051e8:	e8 27 c1 ff ff       	call   f0101314 <page_free>
f01051ed:	83 c4 10             	add    $0x10,%esp
		return ret;
f01051f0:	89 fb                	mov    %edi,%ebx
f01051f2:	e9 55 fc ff ff       	jmp    f0104e4c <syscall+0x52>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01051f7:	50                   	push   %eax
f01051f8:	68 74 6f 10 f0       	push   $0xf0106f74
f01051fd:	6a 58                	push   $0x58
f01051ff:	68 c1 80 10 f0       	push   $0xf01080c1
f0105204:	e8 37 ae ff ff       	call   f0100040 <_panic>
		return -E_INVAL;
f0105209:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010520e:	e9 39 fc ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_INVAL;
f0105213:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105218:	e9 2f fc ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_INVAL;
f010521d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105222:	e9 25 fc ff ff       	jmp    f0104e4c <syscall+0x52>
		return ret;
f0105227:	89 c3                	mov    %eax,%ebx
f0105229:	e9 1e fc ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_NO_MEM;
f010522e:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			break;
f0105233:	e9 14 fc ff ff       	jmp    f0104e4c <syscall+0x52>
	if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f0105238:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010523b:	83 e0 05             	and    $0x5,%eax
f010523e:	83 f8 05             	cmp    $0x5,%eax
f0105241:	0f 85 c0 00 00 00    	jne    f0105307 <syscall+0x50d>
	if(perm & ~PTE_SYSCALL)
f0105247:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010524a:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
	if((uint32_t)srcva >= UTOP || (uint32_t)srcva%PGSIZE != 0)
f010524f:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105256:	0f 87 b5 00 00 00    	ja     f0105311 <syscall+0x517>
f010525c:	8b 55 10             	mov    0x10(%ebp),%edx
f010525f:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	if((uint32_t)dstva >= UTOP || (uint32_t)dstva%PGSIZE != 0)
f0105265:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010526c:	0f 87 a9 00 00 00    	ja     f010531b <syscall+0x521>
f0105272:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105275:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
f010527b:	09 d0                	or     %edx,%eax
f010527d:	09 c1                	or     %eax,%ecx
f010527f:	0f 85 a0 00 00 00    	jne    f0105325 <syscall+0x52b>
	int ret = envid2env(srcenvid, &src_env, 1);
f0105285:	83 ec 04             	sub    $0x4,%esp
f0105288:	6a 01                	push   $0x1
f010528a:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010528d:	50                   	push   %eax
f010528e:	ff 75 0c             	pushl  0xc(%ebp)
f0105291:	e8 4a e2 ff ff       	call   f01034e0 <envid2env>
f0105296:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105298:	83 c4 10             	add    $0x10,%esp
f010529b:	85 c0                	test   %eax,%eax
f010529d:	0f 88 a9 fb ff ff    	js     f0104e4c <syscall+0x52>
	ret = envid2env(dstenvid, &dst_env, 1);
f01052a3:	83 ec 04             	sub    $0x4,%esp
f01052a6:	6a 01                	push   $0x1
f01052a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01052ab:	50                   	push   %eax
f01052ac:	ff 75 14             	pushl  0x14(%ebp)
f01052af:	e8 2c e2 ff ff       	call   f01034e0 <envid2env>
f01052b4:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01052b6:	83 c4 10             	add    $0x10,%esp
f01052b9:	85 c0                	test   %eax,%eax
f01052bb:	0f 88 8b fb ff ff    	js     f0104e4c <syscall+0x52>
	struct PageInfo* src_page = page_lookup(src_env->env_pgdir, srcva, 
f01052c1:	83 ec 04             	sub    $0x4,%esp
f01052c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01052c7:	50                   	push   %eax
f01052c8:	ff 75 10             	pushl  0x10(%ebp)
f01052cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01052ce:	ff 70 60             	pushl  0x60(%eax)
f01052d1:	e8 28 c2 ff ff       	call   f01014fe <page_lookup>
	if(src_page == NULL)
f01052d6:	83 c4 10             	add    $0x10,%esp
f01052d9:	85 c0                	test   %eax,%eax
f01052db:	74 52                	je     f010532f <syscall+0x535>
	if(perm & PTE_W){
f01052dd:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01052e1:	74 08                	je     f01052eb <syscall+0x4f1>
		if((*pte_store & PTE_W) == 0)
f01052e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01052e6:	f6 02 02             	testb  $0x2,(%edx)
f01052e9:	74 4e                	je     f0105339 <syscall+0x53f>
	return page_insert(dst_env->env_pgdir, src_page, (void *)dstva, perm);
f01052eb:	ff 75 1c             	pushl  0x1c(%ebp)
f01052ee:	ff 75 18             	pushl  0x18(%ebp)
f01052f1:	50                   	push   %eax
f01052f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01052f5:	ff 70 60             	pushl  0x60(%eax)
f01052f8:	e8 e1 c2 ff ff       	call   f01015de <page_insert>
f01052fd:	89 c3                	mov    %eax,%ebx
f01052ff:	83 c4 10             	add    $0x10,%esp
f0105302:	e9 45 fb ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_INVAL;
f0105307:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010530c:	e9 3b fb ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_INVAL;
f0105311:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105316:	e9 31 fb ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_INVAL;
f010531b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105320:	e9 27 fb ff ff       	jmp    f0104e4c <syscall+0x52>
f0105325:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010532a:	e9 1d fb ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_INVAL;
f010532f:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105334:	e9 13 fb ff ff       	jmp    f0104e4c <syscall+0x52>
			return -E_INVAL;
f0105339:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f010533e:	e9 09 fb ff ff       	jmp    f0104e4c <syscall+0x52>
	if((uint32_t)va >= UTOP || ((uint32_t)va)%PGSIZE != 0)
f0105343:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010534a:	77 45                	ja     f0105391 <syscall+0x597>
f010534c:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105353:	75 46                	jne    f010539b <syscall+0x5a1>
	int ret = envid2env(envid, &env, 1);
f0105355:	83 ec 04             	sub    $0x4,%esp
f0105358:	6a 01                	push   $0x1
f010535a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010535d:	50                   	push   %eax
f010535e:	ff 75 0c             	pushl  0xc(%ebp)
f0105361:	e8 7a e1 ff ff       	call   f01034e0 <envid2env>
f0105366:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f0105368:	83 c4 10             	add    $0x10,%esp
f010536b:	85 c0                	test   %eax,%eax
f010536d:	0f 88 d9 fa ff ff    	js     f0104e4c <syscall+0x52>
	page_remove(env->env_pgdir, va);
f0105373:	83 ec 08             	sub    $0x8,%esp
f0105376:	ff 75 10             	pushl  0x10(%ebp)
f0105379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010537c:	ff 70 60             	pushl  0x60(%eax)
f010537f:	e8 14 c2 ff ff       	call   f0101598 <page_remove>
f0105384:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105387:	bb 00 00 00 00       	mov    $0x0,%ebx
f010538c:	e9 bb fa ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_INVAL;
f0105391:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105396:	e9 b1 fa ff ff       	jmp    f0104e4c <syscall+0x52>
f010539b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			break;
f01053a0:	e9 a7 fa ff ff       	jmp    f0104e4c <syscall+0x52>
	ret = envid2env(envid, &dst_env, 0);
f01053a5:	83 ec 04             	sub    $0x4,%esp
f01053a8:	6a 00                	push   $0x0
f01053aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01053ad:	50                   	push   %eax
f01053ae:	ff 75 0c             	pushl  0xc(%ebp)
f01053b1:	e8 2a e1 ff ff       	call   f01034e0 <envid2env>
f01053b6:	89 c3                	mov    %eax,%ebx
	if(ret < 0)
f01053b8:	83 c4 10             	add    $0x10,%esp
f01053bb:	85 c0                	test   %eax,%eax
f01053bd:	0f 88 89 fa ff ff    	js     f0104e4c <syscall+0x52>
	if(!dst_env->env_ipc_recving)
f01053c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01053c6:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01053ca:	0f 84 f7 00 00 00    	je     f01054c7 <syscall+0x6cd>
	if(srcva < (void *)UTOP){	//lab4 bug?{
f01053d0:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01053d7:	77 77                	ja     f0105450 <syscall+0x656>
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01053d9:	8b 45 18             	mov    0x18(%ebp),%eax
f01053dc:	83 e0 05             	and    $0x5,%eax
			return -E_INVAL;
f01053df:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P))
f01053e4:	83 f8 05             	cmp    $0x5,%eax
f01053e7:	0f 85 5f fa ff ff    	jne    f0104e4c <syscall+0x52>
		if((uint32_t)srcva%PGSIZE != 0){
f01053ed:	8b 55 14             	mov    0x14(%ebp),%edx
f01053f0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(perm & ~PTE_SYSCALL)
f01053f6:	8b 45 18             	mov    0x18(%ebp),%eax
f01053f9:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f01053fe:	09 c2                	or     %eax,%edx
f0105400:	0f 85 46 fa ff ff    	jne    f0104e4c <syscall+0x52>
		struct PageInfo* page = page_lookup(curenv->env_pgdir, srcva, &pte);
f0105406:	e8 bf 14 00 00       	call   f01068ca <cpunum>
f010540b:	83 ec 04             	sub    $0x4,%esp
f010540e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105411:	52                   	push   %edx
f0105412:	ff 75 14             	pushl  0x14(%ebp)
f0105415:	6b c0 74             	imul   $0x74,%eax,%eax
f0105418:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f010541e:	ff 70 60             	pushl  0x60(%eax)
f0105421:	e8 d8 c0 ff ff       	call   f01014fe <page_lookup>
		if(!page)
f0105426:	83 c4 10             	add    $0x10,%esp
f0105429:	85 c0                	test   %eax,%eax
f010542b:	0f 84 8c 00 00 00    	je     f01054bd <syscall+0x6c3>
		if((*pte & perm) != perm)
f0105431:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105434:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105437:	23 0a                	and    (%edx),%ecx
f0105439:	39 4d 18             	cmp    %ecx,0x18(%ebp)
f010543c:	0f 85 0a fa ff ff    	jne    f0104e4c <syscall+0x52>
		if(dst_env->env_ipc_dstva < (void *)UTOP){
f0105442:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105445:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105448:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010544e:	76 52                	jbe    f01054a2 <syscall+0x6a8>
	dst_env->env_ipc_recving = 0;
f0105450:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105453:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	dst_env->env_ipc_from = curenv->env_id;
f0105457:	e8 6e 14 00 00       	call   f01068ca <cpunum>
f010545c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010545f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105462:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0105468:	8b 40 48             	mov    0x48(%eax),%eax
f010546b:	89 42 74             	mov    %eax,0x74(%edx)
	dst_env->env_ipc_value = value;
f010546e:	8b 45 10             	mov    0x10(%ebp),%eax
f0105471:	89 42 70             	mov    %eax,0x70(%edx)
	dst_env->env_ipc_perm = srcva == (void *)UTOP ? 0 : perm;
f0105474:	81 7d 14 00 00 c0 ee 	cmpl   $0xeec00000,0x14(%ebp)
f010547b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105480:	0f 45 45 18          	cmovne 0x18(%ebp),%eax
f0105484:	89 45 18             	mov    %eax,0x18(%ebp)
f0105487:	89 42 78             	mov    %eax,0x78(%edx)
	dst_env->env_status = ENV_RUNNABLE;
f010548a:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f0105491:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f0105498:	bb 00 00 00 00       	mov    $0x0,%ebx
f010549d:	e9 aa f9 ff ff       	jmp    f0104e4c <syscall+0x52>
			ret = page_insert(dst_env->env_pgdir, page, dst_env->env_ipc_dstva, perm);
f01054a2:	ff 75 18             	pushl  0x18(%ebp)
f01054a5:	51                   	push   %ecx
f01054a6:	50                   	push   %eax
f01054a7:	ff 72 60             	pushl  0x60(%edx)
f01054aa:	e8 2f c1 ff ff       	call   f01015de <page_insert>
f01054af:	89 c3                	mov    %eax,%ebx
			if(ret < 0)
f01054b1:	83 c4 10             	add    $0x10,%esp
f01054b4:	85 c0                	test   %eax,%eax
f01054b6:	79 98                	jns    f0105450 <syscall+0x656>
f01054b8:	e9 8f f9 ff ff       	jmp    f0104e4c <syscall+0x52>
			return -E_INVAL;
f01054bd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01054c2:	e9 85 f9 ff ff       	jmp    f0104e4c <syscall+0x52>
		return -E_IPC_NOT_RECV;
f01054c7:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			break;
f01054cc:	e9 7b f9 ff ff       	jmp    f0104e4c <syscall+0x52>
	if(dstva < (void *)UTOP){
f01054d1:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f01054d8:	77 13                	ja     f01054ed <syscall+0x6f3>
		if((uint32_t)dstva % PGSIZE != 0)
f01054da:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f01054e1:	74 0a                	je     f01054ed <syscall+0x6f3>
			ret = sys_ipc_recv((void *)a1);
f01054e3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
	return ret;
f01054e8:	e9 5f f9 ff ff       	jmp    f0104e4c <syscall+0x52>
	curenv->env_ipc_recving = 1;
f01054ed:	e8 d8 13 00 00       	call   f01068ca <cpunum>
f01054f2:	6b c0 74             	imul   $0x74,%eax,%eax
f01054f5:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f01054fb:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f01054ff:	e8 c6 13 00 00       	call   f01068ca <cpunum>
f0105504:	6b c0 74             	imul   $0x74,%eax,%eax
f0105507:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f010550d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105510:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105513:	e8 b2 13 00 00       	call   f01068ca <cpunum>
f0105518:	6b c0 74             	imul   $0x74,%eax,%eax
f010551b:	8b 80 28 80 34 f0    	mov    -0xfcb7fd8(%eax),%eax
f0105521:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105528:	e8 15 f8 ff ff       	call   f0104d42 <sched_yield>
	int ret = envid2env(envid, &e, 1);
f010552d:	83 ec 04             	sub    $0x4,%esp
f0105530:	6a 01                	push   $0x1
f0105532:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105535:	50                   	push   %eax
f0105536:	ff 75 0c             	pushl  0xc(%ebp)
f0105539:	e8 a2 df ff ff       	call   f01034e0 <envid2env>
f010553e:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105540:	83 c4 10             	add    $0x10,%esp
f0105543:	85 c0                	test   %eax,%eax
f0105545:	0f 88 01 f9 ff ff    	js     f0104e4c <syscall+0x52>
	e->env_pgfault_upcall = func;
f010554b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010554e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105551:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0105554:	bb 00 00 00 00       	mov    $0x0,%ebx
			break;
f0105559:	e9 ee f8 ff ff       	jmp    f0104e4c <syscall+0x52>
			ret = -E_INVAL;
f010555e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105563:	e9 e4 f8 ff ff       	jmp    f0104e4c <syscall+0x52>
        return E_INVAL;
f0105568:	bb 03 00 00 00       	mov    $0x3,%ebx
f010556d:	e9 da f8 ff ff       	jmp    f0104e4c <syscall+0x52>

f0105572 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105572:	55                   	push   %ebp
f0105573:	89 e5                	mov    %esp,%ebp
f0105575:	57                   	push   %edi
f0105576:	56                   	push   %esi
f0105577:	53                   	push   %ebx
f0105578:	83 ec 14             	sub    $0x14,%esp
f010557b:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010557e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105581:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105584:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105587:	8b 1a                	mov    (%edx),%ebx
f0105589:	8b 01                	mov    (%ecx),%eax
f010558b:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010558e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105595:	eb 23                	jmp    f01055ba <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105597:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f010559a:	eb 1e                	jmp    f01055ba <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f010559c:	8d 14 40             	lea    (%eax,%eax,2),%edx
f010559f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01055a2:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f01055a6:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01055a9:	73 41                	jae    f01055ec <stab_binsearch+0x7a>
			*region_left = m;
f01055ab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01055ae:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f01055b0:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f01055b3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01055ba:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01055bd:	7f 5a                	jg     f0105619 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f01055bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01055c2:	01 d8                	add    %ebx,%eax
f01055c4:	89 c7                	mov    %eax,%edi
f01055c6:	c1 ef 1f             	shr    $0x1f,%edi
f01055c9:	01 c7                	add    %eax,%edi
f01055cb:	d1 ff                	sar    %edi
f01055cd:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f01055d0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01055d3:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01055d7:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f01055d9:	39 c3                	cmp    %eax,%ebx
f01055db:	7f ba                	jg     f0105597 <stab_binsearch+0x25>
f01055dd:	0f b6 0a             	movzbl (%edx),%ecx
f01055e0:	83 ea 0c             	sub    $0xc,%edx
f01055e3:	39 f1                	cmp    %esi,%ecx
f01055e5:	74 b5                	je     f010559c <stab_binsearch+0x2a>
			m--;
f01055e7:	83 e8 01             	sub    $0x1,%eax
f01055ea:	eb ed                	jmp    f01055d9 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f01055ec:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01055ef:	76 14                	jbe    f0105605 <stab_binsearch+0x93>
			*region_right = m - 1;
f01055f1:	83 e8 01             	sub    $0x1,%eax
f01055f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01055f7:	8b 7d e0             	mov    -0x20(%ebp),%edi
f01055fa:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f01055fc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105603:	eb b5                	jmp    f01055ba <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105605:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105608:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f010560a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f010560e:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0105610:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105617:	eb a1                	jmp    f01055ba <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105619:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f010561d:	75 15                	jne    f0105634 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f010561f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105622:	8b 00                	mov    (%eax),%eax
f0105624:	83 e8 01             	sub    $0x1,%eax
f0105627:	8b 75 e0             	mov    -0x20(%ebp),%esi
f010562a:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f010562c:	83 c4 14             	add    $0x14,%esp
f010562f:	5b                   	pop    %ebx
f0105630:	5e                   	pop    %esi
f0105631:	5f                   	pop    %edi
f0105632:	5d                   	pop    %ebp
f0105633:	c3                   	ret    
		for (l = *region_right;
f0105634:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105637:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105639:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010563c:	8b 0f                	mov    (%edi),%ecx
f010563e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105641:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0105644:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105648:	eb 03                	jmp    f010564d <stab_binsearch+0xdb>
		     l--)
f010564a:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f010564d:	39 c1                	cmp    %eax,%ecx
f010564f:	7d 0a                	jge    f010565b <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0105651:	0f b6 1a             	movzbl (%edx),%ebx
f0105654:	83 ea 0c             	sub    $0xc,%edx
f0105657:	39 f3                	cmp    %esi,%ebx
f0105659:	75 ef                	jne    f010564a <stab_binsearch+0xd8>
		*region_left = l;
f010565b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010565e:	89 06                	mov    %eax,(%esi)
}
f0105660:	eb ca                	jmp    f010562c <stab_binsearch+0xba>

f0105662 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105662:	55                   	push   %ebp
f0105663:	89 e5                	mov    %esp,%ebp
f0105665:	57                   	push   %edi
f0105666:	56                   	push   %esi
f0105667:	53                   	push   %ebx
f0105668:	83 ec 4c             	sub    $0x4c,%esp
f010566b:	8b 7d 08             	mov    0x8(%ebp),%edi
f010566e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105671:	c7 03 84 8b 10 f0    	movl   $0xf0108b84,(%ebx)
	info->eip_line = 0;
f0105677:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f010567e:	c7 43 08 84 8b 10 f0 	movl   $0xf0108b84,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105685:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f010568c:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f010568f:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105696:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f010569c:	0f 86 23 01 00 00    	jbe    f01057c5 <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f01056a2:	c7 45 b8 b0 a5 11 f0 	movl   $0xf011a5b0,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f01056a9:	c7 45 b4 25 6c 11 f0 	movl   $0xf0116c25,-0x4c(%ebp)
		stab_end = __STAB_END__;
f01056b0:	be 24 6c 11 f0       	mov    $0xf0116c24,%esi
		stabs = __STAB_BEGIN__;
f01056b5:	c7 45 bc 90 91 10 f0 	movl   $0xf0109190,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
			return -1;
		}
	}
	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01056bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
f01056bf:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
f01056c2:	0f 83 59 02 00 00    	jae    f0105921 <debuginfo_eip+0x2bf>
f01056c8:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01056cc:	0f 85 56 02 00 00    	jne    f0105928 <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01056d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01056d9:	2b 75 bc             	sub    -0x44(%ebp),%esi
f01056dc:	c1 fe 02             	sar    $0x2,%esi
f01056df:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f01056e5:	83 e8 01             	sub    $0x1,%eax
f01056e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01056eb:	83 ec 08             	sub    $0x8,%esp
f01056ee:	57                   	push   %edi
f01056ef:	6a 64                	push   $0x64
f01056f1:	8d 55 e0             	lea    -0x20(%ebp),%edx
f01056f4:	89 d1                	mov    %edx,%ecx
f01056f6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01056f9:	8b 75 bc             	mov    -0x44(%ebp),%esi
f01056fc:	89 f0                	mov    %esi,%eax
f01056fe:	e8 6f fe ff ff       	call   f0105572 <stab_binsearch>
	if (lfile == 0)
f0105703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105706:	83 c4 10             	add    $0x10,%esp
f0105709:	85 c0                	test   %eax,%eax
f010570b:	0f 84 1e 02 00 00    	je     f010592f <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105711:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105714:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105717:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010571a:	83 ec 08             	sub    $0x8,%esp
f010571d:	57                   	push   %edi
f010571e:	6a 24                	push   $0x24
f0105720:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105723:	89 d1                	mov    %edx,%ecx
f0105725:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105728:	89 f0                	mov    %esi,%eax
f010572a:	e8 43 fe ff ff       	call   f0105572 <stab_binsearch>

	if (lfun <= rfun) {
f010572f:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105732:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105735:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0105738:	83 c4 10             	add    $0x10,%esp
f010573b:	39 c8                	cmp    %ecx,%eax
f010573d:	0f 8f 26 01 00 00    	jg     f0105869 <debuginfo_eip+0x207>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105743:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105746:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
f0105749:	8b 11                	mov    (%ecx),%edx
f010574b:	8b 75 b8             	mov    -0x48(%ebp),%esi
f010574e:	2b 75 b4             	sub    -0x4c(%ebp),%esi
f0105751:	39 f2                	cmp    %esi,%edx
f0105753:	73 06                	jae    f010575b <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105755:	03 55 b4             	add    -0x4c(%ebp),%edx
f0105758:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f010575b:	8b 51 08             	mov    0x8(%ecx),%edx
f010575e:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105761:	29 d7                	sub    %edx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105763:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105766:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105769:	89 45 d0             	mov    %eax,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f010576c:	83 ec 08             	sub    $0x8,%esp
f010576f:	6a 3a                	push   $0x3a
f0105771:	ff 73 08             	pushl  0x8(%ebx)
f0105774:	e8 34 0b 00 00       	call   f01062ad <strfind>
f0105779:	2b 43 08             	sub    0x8(%ebx),%eax
f010577c:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f010577f:	83 c4 08             	add    $0x8,%esp
f0105782:	57                   	push   %edi
f0105783:	6a 44                	push   $0x44
f0105785:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105788:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f010578b:	8b 75 bc             	mov    -0x44(%ebp),%esi
f010578e:	89 f0                	mov    %esi,%eax
f0105790:	e8 dd fd ff ff       	call   f0105572 <stab_binsearch>
	if(lline <= rline){
f0105795:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105798:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010579b:	83 c4 10             	add    $0x10,%esp
f010579e:	39 c2                	cmp    %eax,%edx
f01057a0:	0f 8f 90 01 00 00    	jg     f0105936 <debuginfo_eip+0x2d4>
		info->eip_line = stabs[rline].n_value;
f01057a6:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01057a9:	8b 44 86 08          	mov    0x8(%esi,%eax,4),%eax
f01057ad:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01057b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01057b3:	89 d0                	mov    %edx,%eax
f01057b5:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01057b8:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f01057bc:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f01057c0:	e9 c2 00 00 00       	jmp    f0105887 <debuginfo_eip+0x225>
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U | PTE_W) < 0){
f01057c5:	e8 00 11 00 00       	call   f01068ca <cpunum>
f01057ca:	6a 06                	push   $0x6
f01057cc:	6a 10                	push   $0x10
f01057ce:	68 00 00 20 00       	push   $0x200000
f01057d3:	6b c0 74             	imul   $0x74,%eax,%eax
f01057d6:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f01057dc:	e8 b1 db ff ff       	call   f0103392 <user_mem_check>
f01057e1:	83 c4 10             	add    $0x10,%esp
f01057e4:	85 c0                	test   %eax,%eax
f01057e6:	0f 88 27 01 00 00    	js     f0105913 <debuginfo_eip+0x2b1>
		stabs = usd->stabs;
f01057ec:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f01057f2:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f01057f5:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f01057fb:	a1 08 00 20 00       	mov    0x200008,%eax
f0105800:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105803:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105809:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, (stab_end - stabs) * sizeof(struct Stab), PTE_U | PTE_W) < 0){
f010580c:	e8 b9 10 00 00       	call   f01068ca <cpunum>
f0105811:	6a 06                	push   $0x6
f0105813:	89 f2                	mov    %esi,%edx
f0105815:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105818:	29 ca                	sub    %ecx,%edx
f010581a:	52                   	push   %edx
f010581b:	51                   	push   %ecx
f010581c:	6b c0 74             	imul   $0x74,%eax,%eax
f010581f:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f0105825:	e8 68 db ff ff       	call   f0103392 <user_mem_check>
f010582a:	83 c4 10             	add    $0x10,%esp
f010582d:	85 c0                	test   %eax,%eax
f010582f:	0f 88 e5 00 00 00    	js     f010591a <debuginfo_eip+0x2b8>
		if(user_mem_check(curenv, stabstr, (stabstr_end - stabstr) * sizeof(char), PTE_U | PTE_W) < 0){
f0105835:	e8 90 10 00 00       	call   f01068ca <cpunum>
f010583a:	6a 06                	push   $0x6
f010583c:	8b 55 b8             	mov    -0x48(%ebp),%edx
f010583f:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105842:	29 ca                	sub    %ecx,%edx
f0105844:	52                   	push   %edx
f0105845:	51                   	push   %ecx
f0105846:	6b c0 74             	imul   $0x74,%eax,%eax
f0105849:	ff b0 28 80 34 f0    	pushl  -0xfcb7fd8(%eax)
f010584f:	e8 3e db ff ff       	call   f0103392 <user_mem_check>
f0105854:	83 c4 10             	add    $0x10,%esp
f0105857:	85 c0                	test   %eax,%eax
f0105859:	0f 89 5d fe ff ff    	jns    f01056bc <debuginfo_eip+0x5a>
			return -1;
f010585f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105864:	e9 d9 00 00 00       	jmp    f0105942 <debuginfo_eip+0x2e0>
		info->eip_fn_addr = addr;
f0105869:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f010586c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010586f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105872:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105875:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105878:	e9 ef fe ff ff       	jmp    f010576c <debuginfo_eip+0x10a>
f010587d:	83 e8 01             	sub    $0x1,%eax
f0105880:	83 ea 0c             	sub    $0xc,%edx
f0105883:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105887:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f010588a:	39 c7                	cmp    %eax,%edi
f010588c:	7f 45                	jg     f01058d3 <debuginfo_eip+0x271>
	       && stabs[lline].n_type != N_SOL
f010588e:	0f b6 0a             	movzbl (%edx),%ecx
f0105891:	80 f9 84             	cmp    $0x84,%cl
f0105894:	74 19                	je     f01058af <debuginfo_eip+0x24d>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105896:	80 f9 64             	cmp    $0x64,%cl
f0105899:	75 e2                	jne    f010587d <debuginfo_eip+0x21b>
f010589b:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f010589f:	74 dc                	je     f010587d <debuginfo_eip+0x21b>
f01058a1:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01058a5:	74 11                	je     f01058b8 <debuginfo_eip+0x256>
f01058a7:	8b 7d c0             	mov    -0x40(%ebp),%edi
f01058aa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01058ad:	eb 09                	jmp    f01058b8 <debuginfo_eip+0x256>
f01058af:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01058b3:	74 03                	je     f01058b8 <debuginfo_eip+0x256>
f01058b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01058b8:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01058bb:	8b 7d bc             	mov    -0x44(%ebp),%edi
f01058be:	8b 14 87             	mov    (%edi,%eax,4),%edx
f01058c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
f01058c4:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f01058c7:	29 f8                	sub    %edi,%eax
f01058c9:	39 c2                	cmp    %eax,%edx
f01058cb:	73 06                	jae    f01058d3 <debuginfo_eip+0x271>
		info->eip_file = stabstr + stabs[lline].n_strx;
f01058cd:	89 f8                	mov    %edi,%eax
f01058cf:	01 d0                	add    %edx,%eax
f01058d1:	89 03                	mov    %eax,(%ebx)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01058d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01058d6:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
	return 0;
f01058d9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f01058de:	39 f2                	cmp    %esi,%edx
f01058e0:	7d 60                	jge    f0105942 <debuginfo_eip+0x2e0>
		for (lline = lfun + 1;
f01058e2:	83 c2 01             	add    $0x1,%edx
f01058e5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f01058e8:	89 d0                	mov    %edx,%eax
f01058ea:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01058ed:	8b 7d bc             	mov    -0x44(%ebp),%edi
f01058f0:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f01058f4:	eb 04                	jmp    f01058fa <debuginfo_eip+0x298>
			info->eip_fn_narg++;
f01058f6:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f01058fa:	39 c6                	cmp    %eax,%esi
f01058fc:	7e 3f                	jle    f010593d <debuginfo_eip+0x2db>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01058fe:	0f b6 0a             	movzbl (%edx),%ecx
f0105901:	83 c0 01             	add    $0x1,%eax
f0105904:	83 c2 0c             	add    $0xc,%edx
f0105907:	80 f9 a0             	cmp    $0xa0,%cl
f010590a:	74 ea                	je     f01058f6 <debuginfo_eip+0x294>
	return 0;
f010590c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105911:	eb 2f                	jmp    f0105942 <debuginfo_eip+0x2e0>
			return -1;
f0105913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105918:	eb 28                	jmp    f0105942 <debuginfo_eip+0x2e0>
			return -1;
f010591a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010591f:	eb 21                	jmp    f0105942 <debuginfo_eip+0x2e0>
		return -1;
f0105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105926:	eb 1a                	jmp    f0105942 <debuginfo_eip+0x2e0>
f0105928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010592d:	eb 13                	jmp    f0105942 <debuginfo_eip+0x2e0>
		return -1;
f010592f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105934:	eb 0c                	jmp    f0105942 <debuginfo_eip+0x2e0>
		return -1;
f0105936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010593b:	eb 05                	jmp    f0105942 <debuginfo_eip+0x2e0>
	return 0;
f010593d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105942:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105945:	5b                   	pop    %ebx
f0105946:	5e                   	pop    %esi
f0105947:	5f                   	pop    %edi
f0105948:	5d                   	pop    %ebp
f0105949:	c3                   	ret    

f010594a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010594a:	55                   	push   %ebp
f010594b:	89 e5                	mov    %esp,%ebp
f010594d:	57                   	push   %edi
f010594e:	56                   	push   %esi
f010594f:	53                   	push   %ebx
f0105950:	83 ec 1c             	sub    $0x1c,%esp
f0105953:	89 c6                	mov    %eax,%esi
f0105955:	89 d7                	mov    %edx,%edi
f0105957:	8b 45 08             	mov    0x8(%ebp),%eax
f010595a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010595d:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105960:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105963:	8b 45 10             	mov    0x10(%ebp),%eax
f0105966:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
f0105969:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f010596d:	74 2c                	je     f010599b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
f010596f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105972:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105979:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010597c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010597f:	39 c2                	cmp    %eax,%edx
f0105981:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105984:	73 43                	jae    f01059c9 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
f0105986:	83 eb 01             	sub    $0x1,%ebx
f0105989:	85 db                	test   %ebx,%ebx
f010598b:	7e 6c                	jle    f01059f9 <printnum+0xaf>
				putch(padc, putdat);
f010598d:	83 ec 08             	sub    $0x8,%esp
f0105990:	57                   	push   %edi
f0105991:	ff 75 18             	pushl  0x18(%ebp)
f0105994:	ff d6                	call   *%esi
f0105996:	83 c4 10             	add    $0x10,%esp
f0105999:	eb eb                	jmp    f0105986 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f010599b:	83 ec 0c             	sub    $0xc,%esp
f010599e:	6a 20                	push   $0x20
f01059a0:	6a 00                	push   $0x0
f01059a2:	50                   	push   %eax
f01059a3:	ff 75 e4             	pushl  -0x1c(%ebp)
f01059a6:	ff 75 e0             	pushl  -0x20(%ebp)
f01059a9:	89 fa                	mov    %edi,%edx
f01059ab:	89 f0                	mov    %esi,%eax
f01059ad:	e8 98 ff ff ff       	call   f010594a <printnum>
		while (--width > 0)
f01059b2:	83 c4 20             	add    $0x20,%esp
f01059b5:	83 eb 01             	sub    $0x1,%ebx
f01059b8:	85 db                	test   %ebx,%ebx
f01059ba:	7e 65                	jle    f0105a21 <printnum+0xd7>
			putch(padc, putdat);
f01059bc:	83 ec 08             	sub    $0x8,%esp
f01059bf:	57                   	push   %edi
f01059c0:	6a 20                	push   $0x20
f01059c2:	ff d6                	call   *%esi
f01059c4:	83 c4 10             	add    $0x10,%esp
f01059c7:	eb ec                	jmp    f01059b5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
f01059c9:	83 ec 0c             	sub    $0xc,%esp
f01059cc:	ff 75 18             	pushl  0x18(%ebp)
f01059cf:	83 eb 01             	sub    $0x1,%ebx
f01059d2:	53                   	push   %ebx
f01059d3:	50                   	push   %eax
f01059d4:	83 ec 08             	sub    $0x8,%esp
f01059d7:	ff 75 dc             	pushl  -0x24(%ebp)
f01059da:	ff 75 d8             	pushl  -0x28(%ebp)
f01059dd:	ff 75 e4             	pushl  -0x1c(%ebp)
f01059e0:	ff 75 e0             	pushl  -0x20(%ebp)
f01059e3:	e8 d8 12 00 00       	call   f0106cc0 <__udivdi3>
f01059e8:	83 c4 18             	add    $0x18,%esp
f01059eb:	52                   	push   %edx
f01059ec:	50                   	push   %eax
f01059ed:	89 fa                	mov    %edi,%edx
f01059ef:	89 f0                	mov    %esi,%eax
f01059f1:	e8 54 ff ff ff       	call   f010594a <printnum>
f01059f6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
f01059f9:	83 ec 08             	sub    $0x8,%esp
f01059fc:	57                   	push   %edi
f01059fd:	83 ec 04             	sub    $0x4,%esp
f0105a00:	ff 75 dc             	pushl  -0x24(%ebp)
f0105a03:	ff 75 d8             	pushl  -0x28(%ebp)
f0105a06:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105a09:	ff 75 e0             	pushl  -0x20(%ebp)
f0105a0c:	e8 bf 13 00 00       	call   f0106dd0 <__umoddi3>
f0105a11:	83 c4 14             	add    $0x14,%esp
f0105a14:	0f be 80 8e 8b 10 f0 	movsbl -0xfef7472(%eax),%eax
f0105a1b:	50                   	push   %eax
f0105a1c:	ff d6                	call   *%esi
f0105a1e:	83 c4 10             	add    $0x10,%esp
	}
}
f0105a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105a24:	5b                   	pop    %ebx
f0105a25:	5e                   	pop    %esi
f0105a26:	5f                   	pop    %edi
f0105a27:	5d                   	pop    %ebp
f0105a28:	c3                   	ret    

f0105a29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105a29:	55                   	push   %ebp
f0105a2a:	89 e5                	mov    %esp,%ebp
f0105a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105a2f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105a33:	8b 10                	mov    (%eax),%edx
f0105a35:	3b 50 04             	cmp    0x4(%eax),%edx
f0105a38:	73 0a                	jae    f0105a44 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105a3a:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105a3d:	89 08                	mov    %ecx,(%eax)
f0105a3f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a42:	88 02                	mov    %al,(%edx)
}
f0105a44:	5d                   	pop    %ebp
f0105a45:	c3                   	ret    

f0105a46 <printfmt>:
{
f0105a46:	55                   	push   %ebp
f0105a47:	89 e5                	mov    %esp,%ebp
f0105a49:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105a4c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105a4f:	50                   	push   %eax
f0105a50:	ff 75 10             	pushl  0x10(%ebp)
f0105a53:	ff 75 0c             	pushl  0xc(%ebp)
f0105a56:	ff 75 08             	pushl  0x8(%ebp)
f0105a59:	e8 05 00 00 00       	call   f0105a63 <vprintfmt>
}
f0105a5e:	83 c4 10             	add    $0x10,%esp
f0105a61:	c9                   	leave  
f0105a62:	c3                   	ret    

f0105a63 <vprintfmt>:
{
f0105a63:	55                   	push   %ebp
f0105a64:	89 e5                	mov    %esp,%ebp
f0105a66:	57                   	push   %edi
f0105a67:	56                   	push   %esi
f0105a68:	53                   	push   %ebx
f0105a69:	83 ec 3c             	sub    $0x3c,%esp
f0105a6c:	8b 75 08             	mov    0x8(%ebp),%esi
f0105a6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105a72:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105a75:	e9 32 04 00 00       	jmp    f0105eac <vprintfmt+0x449>
		padc = ' ';
f0105a7a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
f0105a7e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
f0105a85:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
f0105a8c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105a93:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105a9a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0105aa1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105aa6:	8d 47 01             	lea    0x1(%edi),%eax
f0105aa9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105aac:	0f b6 17             	movzbl (%edi),%edx
f0105aaf:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105ab2:	3c 55                	cmp    $0x55,%al
f0105ab4:	0f 87 12 05 00 00    	ja     f0105fcc <vprintfmt+0x569>
f0105aba:	0f b6 c0             	movzbl %al,%eax
f0105abd:	ff 24 85 60 8d 10 f0 	jmp    *-0xfef72a0(,%eax,4)
f0105ac4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105ac7:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
f0105acb:	eb d9                	jmp    f0105aa6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105acd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105ad0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
f0105ad4:	eb d0                	jmp    f0105aa6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105ad6:	0f b6 d2             	movzbl %dl,%edx
f0105ad9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105adc:	b8 00 00 00 00       	mov    $0x0,%eax
f0105ae1:	89 75 08             	mov    %esi,0x8(%ebp)
f0105ae4:	eb 03                	jmp    f0105ae9 <vprintfmt+0x86>
f0105ae6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105ae9:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105aec:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0105af0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105af3:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105af6:	83 fe 09             	cmp    $0x9,%esi
f0105af9:	76 eb                	jbe    f0105ae6 <vprintfmt+0x83>
f0105afb:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105afe:	8b 75 08             	mov    0x8(%ebp),%esi
f0105b01:	eb 14                	jmp    f0105b17 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
f0105b03:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b06:	8b 00                	mov    (%eax),%eax
f0105b08:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105b0b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b0e:	8d 40 04             	lea    0x4(%eax),%eax
f0105b11:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105b14:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0105b17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105b1b:	79 89                	jns    f0105aa6 <vprintfmt+0x43>
				width = precision, precision = -1;
f0105b1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105b20:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105b23:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105b2a:	e9 77 ff ff ff       	jmp    f0105aa6 <vprintfmt+0x43>
f0105b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b32:	85 c0                	test   %eax,%eax
f0105b34:	0f 48 c1             	cmovs  %ecx,%eax
f0105b37:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105b3a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105b3d:	e9 64 ff ff ff       	jmp    f0105aa6 <vprintfmt+0x43>
f0105b42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0105b45:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
f0105b4c:	e9 55 ff ff ff       	jmp    f0105aa6 <vprintfmt+0x43>
			lflag++;
f0105b51:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105b55:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105b58:	e9 49 ff ff ff       	jmp    f0105aa6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0105b5d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b60:	8d 78 04             	lea    0x4(%eax),%edi
f0105b63:	83 ec 08             	sub    $0x8,%esp
f0105b66:	53                   	push   %ebx
f0105b67:	ff 30                	pushl  (%eax)
f0105b69:	ff d6                	call   *%esi
			break;
f0105b6b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0105b6e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105b71:	e9 33 03 00 00       	jmp    f0105ea9 <vprintfmt+0x446>
			err = va_arg(ap, int);
f0105b76:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b79:	8d 78 04             	lea    0x4(%eax),%edi
f0105b7c:	8b 00                	mov    (%eax),%eax
f0105b7e:	99                   	cltd   
f0105b7f:	31 d0                	xor    %edx,%eax
f0105b81:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105b83:	83 f8 0f             	cmp    $0xf,%eax
f0105b86:	7f 23                	jg     f0105bab <vprintfmt+0x148>
f0105b88:	8b 14 85 c0 8e 10 f0 	mov    -0xfef7140(,%eax,4),%edx
f0105b8f:	85 d2                	test   %edx,%edx
f0105b91:	74 18                	je     f0105bab <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
f0105b93:	52                   	push   %edx
f0105b94:	68 ed 80 10 f0       	push   $0xf01080ed
f0105b99:	53                   	push   %ebx
f0105b9a:	56                   	push   %esi
f0105b9b:	e8 a6 fe ff ff       	call   f0105a46 <printfmt>
f0105ba0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105ba3:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105ba6:	e9 fe 02 00 00       	jmp    f0105ea9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
f0105bab:	50                   	push   %eax
f0105bac:	68 a6 8b 10 f0       	push   $0xf0108ba6
f0105bb1:	53                   	push   %ebx
f0105bb2:	56                   	push   %esi
f0105bb3:	e8 8e fe ff ff       	call   f0105a46 <printfmt>
f0105bb8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105bbb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105bbe:	e9 e6 02 00 00       	jmp    f0105ea9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
f0105bc3:	8b 45 14             	mov    0x14(%ebp),%eax
f0105bc6:	83 c0 04             	add    $0x4,%eax
f0105bc9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105bcc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105bcf:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f0105bd1:	85 c9                	test   %ecx,%ecx
f0105bd3:	b8 9f 8b 10 f0       	mov    $0xf0108b9f,%eax
f0105bd8:	0f 45 c1             	cmovne %ecx,%eax
f0105bdb:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
f0105bde:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105be2:	7e 06                	jle    f0105bea <vprintfmt+0x187>
f0105be4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
f0105be8:	75 0d                	jne    f0105bf7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105bea:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105bed:	89 c7                	mov    %eax,%edi
f0105bef:	03 45 e0             	add    -0x20(%ebp),%eax
f0105bf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105bf5:	eb 53                	jmp    f0105c4a <vprintfmt+0x1e7>
f0105bf7:	83 ec 08             	sub    $0x8,%esp
f0105bfa:	ff 75 d8             	pushl  -0x28(%ebp)
f0105bfd:	50                   	push   %eax
f0105bfe:	e8 5f 05 00 00       	call   f0106162 <strnlen>
f0105c03:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105c06:	29 c1                	sub    %eax,%ecx
f0105c08:	89 4d c0             	mov    %ecx,-0x40(%ebp)
f0105c0b:	83 c4 10             	add    $0x10,%esp
f0105c0e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0105c10:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
f0105c14:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105c17:	eb 0f                	jmp    f0105c28 <vprintfmt+0x1c5>
					putch(padc, putdat);
f0105c19:	83 ec 08             	sub    $0x8,%esp
f0105c1c:	53                   	push   %ebx
f0105c1d:	ff 75 e0             	pushl  -0x20(%ebp)
f0105c20:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105c22:	83 ef 01             	sub    $0x1,%edi
f0105c25:	83 c4 10             	add    $0x10,%esp
f0105c28:	85 ff                	test   %edi,%edi
f0105c2a:	7f ed                	jg     f0105c19 <vprintfmt+0x1b6>
f0105c2c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105c2f:	85 c9                	test   %ecx,%ecx
f0105c31:	b8 00 00 00 00       	mov    $0x0,%eax
f0105c36:	0f 49 c1             	cmovns %ecx,%eax
f0105c39:	29 c1                	sub    %eax,%ecx
f0105c3b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105c3e:	eb aa                	jmp    f0105bea <vprintfmt+0x187>
					putch(ch, putdat);
f0105c40:	83 ec 08             	sub    $0x8,%esp
f0105c43:	53                   	push   %ebx
f0105c44:	52                   	push   %edx
f0105c45:	ff d6                	call   *%esi
f0105c47:	83 c4 10             	add    $0x10,%esp
f0105c4a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105c4d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105c4f:	83 c7 01             	add    $0x1,%edi
f0105c52:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105c56:	0f be d0             	movsbl %al,%edx
f0105c59:	85 d2                	test   %edx,%edx
f0105c5b:	74 4b                	je     f0105ca8 <vprintfmt+0x245>
f0105c5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105c61:	78 06                	js     f0105c69 <vprintfmt+0x206>
f0105c63:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105c67:	78 1e                	js     f0105c87 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
f0105c69:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0105c6d:	74 d1                	je     f0105c40 <vprintfmt+0x1dd>
f0105c6f:	0f be c0             	movsbl %al,%eax
f0105c72:	83 e8 20             	sub    $0x20,%eax
f0105c75:	83 f8 5e             	cmp    $0x5e,%eax
f0105c78:	76 c6                	jbe    f0105c40 <vprintfmt+0x1dd>
					putch('?', putdat);
f0105c7a:	83 ec 08             	sub    $0x8,%esp
f0105c7d:	53                   	push   %ebx
f0105c7e:	6a 3f                	push   $0x3f
f0105c80:	ff d6                	call   *%esi
f0105c82:	83 c4 10             	add    $0x10,%esp
f0105c85:	eb c3                	jmp    f0105c4a <vprintfmt+0x1e7>
f0105c87:	89 cf                	mov    %ecx,%edi
f0105c89:	eb 0e                	jmp    f0105c99 <vprintfmt+0x236>
				putch(' ', putdat);
f0105c8b:	83 ec 08             	sub    $0x8,%esp
f0105c8e:	53                   	push   %ebx
f0105c8f:	6a 20                	push   $0x20
f0105c91:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105c93:	83 ef 01             	sub    $0x1,%edi
f0105c96:	83 c4 10             	add    $0x10,%esp
f0105c99:	85 ff                	test   %edi,%edi
f0105c9b:	7f ee                	jg     f0105c8b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
f0105c9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0105ca0:	89 45 14             	mov    %eax,0x14(%ebp)
f0105ca3:	e9 01 02 00 00       	jmp    f0105ea9 <vprintfmt+0x446>
f0105ca8:	89 cf                	mov    %ecx,%edi
f0105caa:	eb ed                	jmp    f0105c99 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
f0105cac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
f0105caf:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
f0105cb6:	e9 eb fd ff ff       	jmp    f0105aa6 <vprintfmt+0x43>
	if (lflag >= 2)
f0105cbb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105cbf:	7f 21                	jg     f0105ce2 <vprintfmt+0x27f>
	else if (lflag)
f0105cc1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105cc5:	74 68                	je     f0105d2f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
f0105cc7:	8b 45 14             	mov    0x14(%ebp),%eax
f0105cca:	8b 00                	mov    (%eax),%eax
f0105ccc:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105ccf:	89 c1                	mov    %eax,%ecx
f0105cd1:	c1 f9 1f             	sar    $0x1f,%ecx
f0105cd4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105cd7:	8b 45 14             	mov    0x14(%ebp),%eax
f0105cda:	8d 40 04             	lea    0x4(%eax),%eax
f0105cdd:	89 45 14             	mov    %eax,0x14(%ebp)
f0105ce0:	eb 17                	jmp    f0105cf9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
f0105ce2:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ce5:	8b 50 04             	mov    0x4(%eax),%edx
f0105ce8:	8b 00                	mov    (%eax),%eax
f0105cea:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105ced:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105cf0:	8b 45 14             	mov    0x14(%ebp),%eax
f0105cf3:	8d 40 08             	lea    0x8(%eax),%eax
f0105cf6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0105cf9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105cfc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105cff:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105d02:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
f0105d05:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0105d09:	78 3f                	js     f0105d4a <vprintfmt+0x2e7>
			base = 10;
f0105d0b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
f0105d10:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f0105d14:	0f 84 71 01 00 00    	je     f0105e8b <vprintfmt+0x428>
				putch('+', putdat);
f0105d1a:	83 ec 08             	sub    $0x8,%esp
f0105d1d:	53                   	push   %ebx
f0105d1e:	6a 2b                	push   $0x2b
f0105d20:	ff d6                	call   *%esi
f0105d22:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105d25:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105d2a:	e9 5c 01 00 00       	jmp    f0105e8b <vprintfmt+0x428>
		return va_arg(*ap, int);
f0105d2f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d32:	8b 00                	mov    (%eax),%eax
f0105d34:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105d37:	89 c1                	mov    %eax,%ecx
f0105d39:	c1 f9 1f             	sar    $0x1f,%ecx
f0105d3c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0105d3f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d42:	8d 40 04             	lea    0x4(%eax),%eax
f0105d45:	89 45 14             	mov    %eax,0x14(%ebp)
f0105d48:	eb af                	jmp    f0105cf9 <vprintfmt+0x296>
				putch('-', putdat);
f0105d4a:	83 ec 08             	sub    $0x8,%esp
f0105d4d:	53                   	push   %ebx
f0105d4e:	6a 2d                	push   $0x2d
f0105d50:	ff d6                	call   *%esi
				num = -(long long) num;
f0105d52:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105d55:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105d58:	f7 d8                	neg    %eax
f0105d5a:	83 d2 00             	adc    $0x0,%edx
f0105d5d:	f7 da                	neg    %edx
f0105d5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105d62:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105d65:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105d68:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105d6d:	e9 19 01 00 00       	jmp    f0105e8b <vprintfmt+0x428>
	if (lflag >= 2)
f0105d72:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105d76:	7f 29                	jg     f0105da1 <vprintfmt+0x33e>
	else if (lflag)
f0105d78:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105d7c:	74 44                	je     f0105dc2 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
f0105d7e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d81:	8b 00                	mov    (%eax),%eax
f0105d83:	ba 00 00 00 00       	mov    $0x0,%edx
f0105d88:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105d8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105d8e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d91:	8d 40 04             	lea    0x4(%eax),%eax
f0105d94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105d97:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105d9c:	e9 ea 00 00 00       	jmp    f0105e8b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0105da1:	8b 45 14             	mov    0x14(%ebp),%eax
f0105da4:	8b 50 04             	mov    0x4(%eax),%edx
f0105da7:	8b 00                	mov    (%eax),%eax
f0105da9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105dac:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105daf:	8b 45 14             	mov    0x14(%ebp),%eax
f0105db2:	8d 40 08             	lea    0x8(%eax),%eax
f0105db5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105db8:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105dbd:	e9 c9 00 00 00       	jmp    f0105e8b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0105dc2:	8b 45 14             	mov    0x14(%ebp),%eax
f0105dc5:	8b 00                	mov    (%eax),%eax
f0105dc7:	ba 00 00 00 00       	mov    $0x0,%edx
f0105dcc:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105dcf:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105dd2:	8b 45 14             	mov    0x14(%ebp),%eax
f0105dd5:	8d 40 04             	lea    0x4(%eax),%eax
f0105dd8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105ddb:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105de0:	e9 a6 00 00 00       	jmp    f0105e8b <vprintfmt+0x428>
			putch('0', putdat);
f0105de5:	83 ec 08             	sub    $0x8,%esp
f0105de8:	53                   	push   %ebx
f0105de9:	6a 30                	push   $0x30
f0105deb:	ff d6                	call   *%esi
	if (lflag >= 2)
f0105ded:	83 c4 10             	add    $0x10,%esp
f0105df0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105df4:	7f 26                	jg     f0105e1c <vprintfmt+0x3b9>
	else if (lflag)
f0105df6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105dfa:	74 3e                	je     f0105e3a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
f0105dfc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105dff:	8b 00                	mov    (%eax),%eax
f0105e01:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e06:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e09:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105e0c:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e0f:	8d 40 04             	lea    0x4(%eax),%eax
f0105e12:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105e15:	b8 08 00 00 00       	mov    $0x8,%eax
f0105e1a:	eb 6f                	jmp    f0105e8b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0105e1c:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e1f:	8b 50 04             	mov    0x4(%eax),%edx
f0105e22:	8b 00                	mov    (%eax),%eax
f0105e24:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e27:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105e2a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e2d:	8d 40 08             	lea    0x8(%eax),%eax
f0105e30:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105e33:	b8 08 00 00 00       	mov    $0x8,%eax
f0105e38:	eb 51                	jmp    f0105e8b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0105e3a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e3d:	8b 00                	mov    (%eax),%eax
f0105e3f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e44:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e47:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105e4a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e4d:	8d 40 04             	lea    0x4(%eax),%eax
f0105e50:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105e53:	b8 08 00 00 00       	mov    $0x8,%eax
f0105e58:	eb 31                	jmp    f0105e8b <vprintfmt+0x428>
			putch('0', putdat);
f0105e5a:	83 ec 08             	sub    $0x8,%esp
f0105e5d:	53                   	push   %ebx
f0105e5e:	6a 30                	push   $0x30
f0105e60:	ff d6                	call   *%esi
			putch('x', putdat);
f0105e62:	83 c4 08             	add    $0x8,%esp
f0105e65:	53                   	push   %ebx
f0105e66:	6a 78                	push   $0x78
f0105e68:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105e6a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e6d:	8b 00                	mov    (%eax),%eax
f0105e6f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e74:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e77:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f0105e7a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0105e7d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e80:	8d 40 04             	lea    0x4(%eax),%eax
f0105e83:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105e86:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0105e8b:	83 ec 0c             	sub    $0xc,%esp
f0105e8e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
f0105e92:	52                   	push   %edx
f0105e93:	ff 75 e0             	pushl  -0x20(%ebp)
f0105e96:	50                   	push   %eax
f0105e97:	ff 75 dc             	pushl  -0x24(%ebp)
f0105e9a:	ff 75 d8             	pushl  -0x28(%ebp)
f0105e9d:	89 da                	mov    %ebx,%edx
f0105e9f:	89 f0                	mov    %esi,%eax
f0105ea1:	e8 a4 fa ff ff       	call   f010594a <printnum>
			break;
f0105ea6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f0105ea9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105eac:	83 c7 01             	add    $0x1,%edi
f0105eaf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105eb3:	83 f8 25             	cmp    $0x25,%eax
f0105eb6:	0f 84 be fb ff ff    	je     f0105a7a <vprintfmt+0x17>
			if (ch == '\0')
f0105ebc:	85 c0                	test   %eax,%eax
f0105ebe:	0f 84 28 01 00 00    	je     f0105fec <vprintfmt+0x589>
			putch(ch, putdat);
f0105ec4:	83 ec 08             	sub    $0x8,%esp
f0105ec7:	53                   	push   %ebx
f0105ec8:	50                   	push   %eax
f0105ec9:	ff d6                	call   *%esi
f0105ecb:	83 c4 10             	add    $0x10,%esp
f0105ece:	eb dc                	jmp    f0105eac <vprintfmt+0x449>
	if (lflag >= 2)
f0105ed0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
f0105ed4:	7f 26                	jg     f0105efc <vprintfmt+0x499>
	else if (lflag)
f0105ed6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f0105eda:	74 41                	je     f0105f1d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
f0105edc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105edf:	8b 00                	mov    (%eax),%eax
f0105ee1:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ee6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105ee9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105eec:	8b 45 14             	mov    0x14(%ebp),%eax
f0105eef:	8d 40 04             	lea    0x4(%eax),%eax
f0105ef2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105ef5:	b8 10 00 00 00       	mov    $0x10,%eax
f0105efa:	eb 8f                	jmp    f0105e8b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
f0105efc:	8b 45 14             	mov    0x14(%ebp),%eax
f0105eff:	8b 50 04             	mov    0x4(%eax),%edx
f0105f02:	8b 00                	mov    (%eax),%eax
f0105f04:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f07:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f0a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f0d:	8d 40 08             	lea    0x8(%eax),%eax
f0105f10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105f13:	b8 10 00 00 00       	mov    $0x10,%eax
f0105f18:	e9 6e ff ff ff       	jmp    f0105e8b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
f0105f1d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f20:	8b 00                	mov    (%eax),%eax
f0105f22:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f27:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105f2d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f30:	8d 40 04             	lea    0x4(%eax),%eax
f0105f33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105f36:	b8 10 00 00 00       	mov    $0x10,%eax
f0105f3b:	e9 4b ff ff ff       	jmp    f0105e8b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
f0105f40:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f43:	83 c0 04             	add    $0x4,%eax
f0105f46:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105f49:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f4c:	8b 00                	mov    (%eax),%eax
f0105f4e:	85 c0                	test   %eax,%eax
f0105f50:	74 14                	je     f0105f66 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
f0105f52:	8b 13                	mov    (%ebx),%edx
f0105f54:	83 fa 7f             	cmp    $0x7f,%edx
f0105f57:	7f 37                	jg     f0105f90 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
f0105f59:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
f0105f5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105f5e:	89 45 14             	mov    %eax,0x14(%ebp)
f0105f61:	e9 43 ff ff ff       	jmp    f0105ea9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
f0105f66:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f6b:	bf c5 8c 10 f0       	mov    $0xf0108cc5,%edi
							putch(ch, putdat);
f0105f70:	83 ec 08             	sub    $0x8,%esp
f0105f73:	53                   	push   %ebx
f0105f74:	50                   	push   %eax
f0105f75:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0105f77:	83 c7 01             	add    $0x1,%edi
f0105f7a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f0105f7e:	83 c4 10             	add    $0x10,%esp
f0105f81:	85 c0                	test   %eax,%eax
f0105f83:	75 eb                	jne    f0105f70 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
f0105f85:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105f88:	89 45 14             	mov    %eax,0x14(%ebp)
f0105f8b:	e9 19 ff ff ff       	jmp    f0105ea9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
f0105f90:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
f0105f92:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f97:	bf fd 8c 10 f0       	mov    $0xf0108cfd,%edi
							putch(ch, putdat);
f0105f9c:	83 ec 08             	sub    $0x8,%esp
f0105f9f:	53                   	push   %ebx
f0105fa0:	50                   	push   %eax
f0105fa1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
f0105fa3:	83 c7 01             	add    $0x1,%edi
f0105fa6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
f0105faa:	83 c4 10             	add    $0x10,%esp
f0105fad:	85 c0                	test   %eax,%eax
f0105faf:	75 eb                	jne    f0105f9c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
f0105fb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105fb4:	89 45 14             	mov    %eax,0x14(%ebp)
f0105fb7:	e9 ed fe ff ff       	jmp    f0105ea9 <vprintfmt+0x446>
			putch(ch, putdat);
f0105fbc:	83 ec 08             	sub    $0x8,%esp
f0105fbf:	53                   	push   %ebx
f0105fc0:	6a 25                	push   $0x25
f0105fc2:	ff d6                	call   *%esi
			break;
f0105fc4:	83 c4 10             	add    $0x10,%esp
f0105fc7:	e9 dd fe ff ff       	jmp    f0105ea9 <vprintfmt+0x446>
			putch('%', putdat);
f0105fcc:	83 ec 08             	sub    $0x8,%esp
f0105fcf:	53                   	push   %ebx
f0105fd0:	6a 25                	push   $0x25
f0105fd2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105fd4:	83 c4 10             	add    $0x10,%esp
f0105fd7:	89 f8                	mov    %edi,%eax
f0105fd9:	eb 03                	jmp    f0105fde <vprintfmt+0x57b>
f0105fdb:	83 e8 01             	sub    $0x1,%eax
f0105fde:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0105fe2:	75 f7                	jne    f0105fdb <vprintfmt+0x578>
f0105fe4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105fe7:	e9 bd fe ff ff       	jmp    f0105ea9 <vprintfmt+0x446>
}
f0105fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105fef:	5b                   	pop    %ebx
f0105ff0:	5e                   	pop    %esi
f0105ff1:	5f                   	pop    %edi
f0105ff2:	5d                   	pop    %ebp
f0105ff3:	c3                   	ret    

f0105ff4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105ff4:	55                   	push   %ebp
f0105ff5:	89 e5                	mov    %esp,%ebp
f0105ff7:	83 ec 18             	sub    $0x18,%esp
f0105ffa:	8b 45 08             	mov    0x8(%ebp),%eax
f0105ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0106000:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0106003:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106007:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010600a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0106011:	85 c0                	test   %eax,%eax
f0106013:	74 26                	je     f010603b <vsnprintf+0x47>
f0106015:	85 d2                	test   %edx,%edx
f0106017:	7e 22                	jle    f010603b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106019:	ff 75 14             	pushl  0x14(%ebp)
f010601c:	ff 75 10             	pushl  0x10(%ebp)
f010601f:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0106022:	50                   	push   %eax
f0106023:	68 29 5a 10 f0       	push   $0xf0105a29
f0106028:	e8 36 fa ff ff       	call   f0105a63 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010602d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106030:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0106033:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106036:	83 c4 10             	add    $0x10,%esp
}
f0106039:	c9                   	leave  
f010603a:	c3                   	ret    
		return -E_INVAL;
f010603b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0106040:	eb f7                	jmp    f0106039 <vsnprintf+0x45>

f0106042 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0106042:	55                   	push   %ebp
f0106043:	89 e5                	mov    %esp,%ebp
f0106045:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106048:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010604b:	50                   	push   %eax
f010604c:	ff 75 10             	pushl  0x10(%ebp)
f010604f:	ff 75 0c             	pushl  0xc(%ebp)
f0106052:	ff 75 08             	pushl  0x8(%ebp)
f0106055:	e8 9a ff ff ff       	call   f0105ff4 <vsnprintf>
	va_end(ap);

	return rc;
}
f010605a:	c9                   	leave  
f010605b:	c3                   	ret    

f010605c <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010605c:	55                   	push   %ebp
f010605d:	89 e5                	mov    %esp,%ebp
f010605f:	57                   	push   %edi
f0106060:	56                   	push   %esi
f0106061:	53                   	push   %ebx
f0106062:	83 ec 0c             	sub    $0xc,%esp
f0106065:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106068:	85 c0                	test   %eax,%eax
f010606a:	74 11                	je     f010607d <readline+0x21>
		cprintf("%s", prompt);
f010606c:	83 ec 08             	sub    $0x8,%esp
f010606f:	50                   	push   %eax
f0106070:	68 ed 80 10 f0       	push   $0xf01080ed
f0106075:	e8 09 dd ff ff       	call   f0103d83 <cprintf>
f010607a:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010607d:	83 ec 0c             	sub    $0xc,%esp
f0106080:	6a 00                	push   $0x0
f0106082:	e8 31 a7 ff ff       	call   f01007b8 <iscons>
f0106087:	89 c7                	mov    %eax,%edi
f0106089:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010608c:	be 00 00 00 00       	mov    $0x0,%esi
f0106091:	eb 57                	jmp    f01060ea <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0106093:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106098:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010609b:	75 08                	jne    f01060a5 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010609d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01060a0:	5b                   	pop    %ebx
f01060a1:	5e                   	pop    %esi
f01060a2:	5f                   	pop    %edi
f01060a3:	5d                   	pop    %ebp
f01060a4:	c3                   	ret    
				cprintf("read error: %e\n", c);
f01060a5:	83 ec 08             	sub    $0x8,%esp
f01060a8:	53                   	push   %ebx
f01060a9:	68 00 8f 10 f0       	push   $0xf0108f00
f01060ae:	e8 d0 dc ff ff       	call   f0103d83 <cprintf>
f01060b3:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01060b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01060bb:	eb e0                	jmp    f010609d <readline+0x41>
			if (echoing)
f01060bd:	85 ff                	test   %edi,%edi
f01060bf:	75 05                	jne    f01060c6 <readline+0x6a>
			i--;
f01060c1:	83 ee 01             	sub    $0x1,%esi
f01060c4:	eb 24                	jmp    f01060ea <readline+0x8e>
				cputchar('\b');
f01060c6:	83 ec 0c             	sub    $0xc,%esp
f01060c9:	6a 08                	push   $0x8
f01060cb:	e8 c7 a6 ff ff       	call   f0100797 <cputchar>
f01060d0:	83 c4 10             	add    $0x10,%esp
f01060d3:	eb ec                	jmp    f01060c1 <readline+0x65>
				cputchar(c);
f01060d5:	83 ec 0c             	sub    $0xc,%esp
f01060d8:	53                   	push   %ebx
f01060d9:	e8 b9 a6 ff ff       	call   f0100797 <cputchar>
f01060de:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01060e1:	88 9e 80 7a 34 f0    	mov    %bl,-0xfcb8580(%esi)
f01060e7:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01060ea:	e8 b8 a6 ff ff       	call   f01007a7 <getchar>
f01060ef:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01060f1:	85 c0                	test   %eax,%eax
f01060f3:	78 9e                	js     f0106093 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01060f5:	83 f8 08             	cmp    $0x8,%eax
f01060f8:	0f 94 c2             	sete   %dl
f01060fb:	83 f8 7f             	cmp    $0x7f,%eax
f01060fe:	0f 94 c0             	sete   %al
f0106101:	08 c2                	or     %al,%dl
f0106103:	74 04                	je     f0106109 <readline+0xad>
f0106105:	85 f6                	test   %esi,%esi
f0106107:	7f b4                	jg     f01060bd <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106109:	83 fb 1f             	cmp    $0x1f,%ebx
f010610c:	7e 0e                	jle    f010611c <readline+0xc0>
f010610e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0106114:	7f 06                	jg     f010611c <readline+0xc0>
			if (echoing)
f0106116:	85 ff                	test   %edi,%edi
f0106118:	74 c7                	je     f01060e1 <readline+0x85>
f010611a:	eb b9                	jmp    f01060d5 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f010611c:	83 fb 0a             	cmp    $0xa,%ebx
f010611f:	74 05                	je     f0106126 <readline+0xca>
f0106121:	83 fb 0d             	cmp    $0xd,%ebx
f0106124:	75 c4                	jne    f01060ea <readline+0x8e>
			if (echoing)
f0106126:	85 ff                	test   %edi,%edi
f0106128:	75 11                	jne    f010613b <readline+0xdf>
			buf[i] = 0;
f010612a:	c6 86 80 7a 34 f0 00 	movb   $0x0,-0xfcb8580(%esi)
			return buf;
f0106131:	b8 80 7a 34 f0       	mov    $0xf0347a80,%eax
f0106136:	e9 62 ff ff ff       	jmp    f010609d <readline+0x41>
				cputchar('\n');
f010613b:	83 ec 0c             	sub    $0xc,%esp
f010613e:	6a 0a                	push   $0xa
f0106140:	e8 52 a6 ff ff       	call   f0100797 <cputchar>
f0106145:	83 c4 10             	add    $0x10,%esp
f0106148:	eb e0                	jmp    f010612a <readline+0xce>

f010614a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010614a:	55                   	push   %ebp
f010614b:	89 e5                	mov    %esp,%ebp
f010614d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106150:	b8 00 00 00 00       	mov    $0x0,%eax
f0106155:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106159:	74 05                	je     f0106160 <strlen+0x16>
		n++;
f010615b:	83 c0 01             	add    $0x1,%eax
f010615e:	eb f5                	jmp    f0106155 <strlen+0xb>
	return n;
}
f0106160:	5d                   	pop    %ebp
f0106161:	c3                   	ret    

f0106162 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106162:	55                   	push   %ebp
f0106163:	89 e5                	mov    %esp,%ebp
f0106165:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106168:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010616b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106170:	39 c2                	cmp    %eax,%edx
f0106172:	74 0d                	je     f0106181 <strnlen+0x1f>
f0106174:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106178:	74 05                	je     f010617f <strnlen+0x1d>
		n++;
f010617a:	83 c2 01             	add    $0x1,%edx
f010617d:	eb f1                	jmp    f0106170 <strnlen+0xe>
f010617f:	89 d0                	mov    %edx,%eax
	return n;
}
f0106181:	5d                   	pop    %ebp
f0106182:	c3                   	ret    

f0106183 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106183:	55                   	push   %ebp
f0106184:	89 e5                	mov    %esp,%ebp
f0106186:	53                   	push   %ebx
f0106187:	8b 45 08             	mov    0x8(%ebp),%eax
f010618a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010618d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106192:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106196:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0106199:	83 c2 01             	add    $0x1,%edx
f010619c:	84 c9                	test   %cl,%cl
f010619e:	75 f2                	jne    f0106192 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f01061a0:	5b                   	pop    %ebx
f01061a1:	5d                   	pop    %ebp
f01061a2:	c3                   	ret    

f01061a3 <strcat>:

char *
strcat(char *dst, const char *src)
{
f01061a3:	55                   	push   %ebp
f01061a4:	89 e5                	mov    %esp,%ebp
f01061a6:	53                   	push   %ebx
f01061a7:	83 ec 10             	sub    $0x10,%esp
f01061aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01061ad:	53                   	push   %ebx
f01061ae:	e8 97 ff ff ff       	call   f010614a <strlen>
f01061b3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01061b6:	ff 75 0c             	pushl  0xc(%ebp)
f01061b9:	01 d8                	add    %ebx,%eax
f01061bb:	50                   	push   %eax
f01061bc:	e8 c2 ff ff ff       	call   f0106183 <strcpy>
	return dst;
}
f01061c1:	89 d8                	mov    %ebx,%eax
f01061c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01061c6:	c9                   	leave  
f01061c7:	c3                   	ret    

f01061c8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01061c8:	55                   	push   %ebp
f01061c9:	89 e5                	mov    %esp,%ebp
f01061cb:	56                   	push   %esi
f01061cc:	53                   	push   %ebx
f01061cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01061d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01061d3:	89 c6                	mov    %eax,%esi
f01061d5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01061d8:	89 c2                	mov    %eax,%edx
f01061da:	39 f2                	cmp    %esi,%edx
f01061dc:	74 11                	je     f01061ef <strncpy+0x27>
		*dst++ = *src;
f01061de:	83 c2 01             	add    $0x1,%edx
f01061e1:	0f b6 19             	movzbl (%ecx),%ebx
f01061e4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01061e7:	80 fb 01             	cmp    $0x1,%bl
f01061ea:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01061ed:	eb eb                	jmp    f01061da <strncpy+0x12>
	}
	return ret;
}
f01061ef:	5b                   	pop    %ebx
f01061f0:	5e                   	pop    %esi
f01061f1:	5d                   	pop    %ebp
f01061f2:	c3                   	ret    

f01061f3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01061f3:	55                   	push   %ebp
f01061f4:	89 e5                	mov    %esp,%ebp
f01061f6:	56                   	push   %esi
f01061f7:	53                   	push   %ebx
f01061f8:	8b 75 08             	mov    0x8(%ebp),%esi
f01061fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01061fe:	8b 55 10             	mov    0x10(%ebp),%edx
f0106201:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0106203:	85 d2                	test   %edx,%edx
f0106205:	74 21                	je     f0106228 <strlcpy+0x35>
f0106207:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f010620b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f010620d:	39 c2                	cmp    %eax,%edx
f010620f:	74 14                	je     f0106225 <strlcpy+0x32>
f0106211:	0f b6 19             	movzbl (%ecx),%ebx
f0106214:	84 db                	test   %bl,%bl
f0106216:	74 0b                	je     f0106223 <strlcpy+0x30>
			*dst++ = *src++;
f0106218:	83 c1 01             	add    $0x1,%ecx
f010621b:	83 c2 01             	add    $0x1,%edx
f010621e:	88 5a ff             	mov    %bl,-0x1(%edx)
f0106221:	eb ea                	jmp    f010620d <strlcpy+0x1a>
f0106223:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0106225:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106228:	29 f0                	sub    %esi,%eax
}
f010622a:	5b                   	pop    %ebx
f010622b:	5e                   	pop    %esi
f010622c:	5d                   	pop    %ebp
f010622d:	c3                   	ret    

f010622e <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010622e:	55                   	push   %ebp
f010622f:	89 e5                	mov    %esp,%ebp
f0106231:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106234:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106237:	0f b6 01             	movzbl (%ecx),%eax
f010623a:	84 c0                	test   %al,%al
f010623c:	74 0c                	je     f010624a <strcmp+0x1c>
f010623e:	3a 02                	cmp    (%edx),%al
f0106240:	75 08                	jne    f010624a <strcmp+0x1c>
		p++, q++;
f0106242:	83 c1 01             	add    $0x1,%ecx
f0106245:	83 c2 01             	add    $0x1,%edx
f0106248:	eb ed                	jmp    f0106237 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010624a:	0f b6 c0             	movzbl %al,%eax
f010624d:	0f b6 12             	movzbl (%edx),%edx
f0106250:	29 d0                	sub    %edx,%eax
}
f0106252:	5d                   	pop    %ebp
f0106253:	c3                   	ret    

f0106254 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106254:	55                   	push   %ebp
f0106255:	89 e5                	mov    %esp,%ebp
f0106257:	53                   	push   %ebx
f0106258:	8b 45 08             	mov    0x8(%ebp),%eax
f010625b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010625e:	89 c3                	mov    %eax,%ebx
f0106260:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106263:	eb 06                	jmp    f010626b <strncmp+0x17>
		n--, p++, q++;
f0106265:	83 c0 01             	add    $0x1,%eax
f0106268:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f010626b:	39 d8                	cmp    %ebx,%eax
f010626d:	74 16                	je     f0106285 <strncmp+0x31>
f010626f:	0f b6 08             	movzbl (%eax),%ecx
f0106272:	84 c9                	test   %cl,%cl
f0106274:	74 04                	je     f010627a <strncmp+0x26>
f0106276:	3a 0a                	cmp    (%edx),%cl
f0106278:	74 eb                	je     f0106265 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f010627a:	0f b6 00             	movzbl (%eax),%eax
f010627d:	0f b6 12             	movzbl (%edx),%edx
f0106280:	29 d0                	sub    %edx,%eax
}
f0106282:	5b                   	pop    %ebx
f0106283:	5d                   	pop    %ebp
f0106284:	c3                   	ret    
		return 0;
f0106285:	b8 00 00 00 00       	mov    $0x0,%eax
f010628a:	eb f6                	jmp    f0106282 <strncmp+0x2e>

f010628c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010628c:	55                   	push   %ebp
f010628d:	89 e5                	mov    %esp,%ebp
f010628f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106292:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106296:	0f b6 10             	movzbl (%eax),%edx
f0106299:	84 d2                	test   %dl,%dl
f010629b:	74 09                	je     f01062a6 <strchr+0x1a>
		if (*s == c)
f010629d:	38 ca                	cmp    %cl,%dl
f010629f:	74 0a                	je     f01062ab <strchr+0x1f>
	for (; *s; s++)
f01062a1:	83 c0 01             	add    $0x1,%eax
f01062a4:	eb f0                	jmp    f0106296 <strchr+0xa>
			return (char *) s;
	return 0;
f01062a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01062ab:	5d                   	pop    %ebp
f01062ac:	c3                   	ret    

f01062ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01062ad:	55                   	push   %ebp
f01062ae:	89 e5                	mov    %esp,%ebp
f01062b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01062b3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01062b7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01062ba:	38 ca                	cmp    %cl,%dl
f01062bc:	74 09                	je     f01062c7 <strfind+0x1a>
f01062be:	84 d2                	test   %dl,%dl
f01062c0:	74 05                	je     f01062c7 <strfind+0x1a>
	for (; *s; s++)
f01062c2:	83 c0 01             	add    $0x1,%eax
f01062c5:	eb f0                	jmp    f01062b7 <strfind+0xa>
			break;
	return (char *) s;
}
f01062c7:	5d                   	pop    %ebp
f01062c8:	c3                   	ret    

f01062c9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01062c9:	55                   	push   %ebp
f01062ca:	89 e5                	mov    %esp,%ebp
f01062cc:	57                   	push   %edi
f01062cd:	56                   	push   %esi
f01062ce:	53                   	push   %ebx
f01062cf:	8b 7d 08             	mov    0x8(%ebp),%edi
f01062d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01062d5:	85 c9                	test   %ecx,%ecx
f01062d7:	74 31                	je     f010630a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01062d9:	89 f8                	mov    %edi,%eax
f01062db:	09 c8                	or     %ecx,%eax
f01062dd:	a8 03                	test   $0x3,%al
f01062df:	75 23                	jne    f0106304 <memset+0x3b>
		c &= 0xFF;
f01062e1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01062e5:	89 d3                	mov    %edx,%ebx
f01062e7:	c1 e3 08             	shl    $0x8,%ebx
f01062ea:	89 d0                	mov    %edx,%eax
f01062ec:	c1 e0 18             	shl    $0x18,%eax
f01062ef:	89 d6                	mov    %edx,%esi
f01062f1:	c1 e6 10             	shl    $0x10,%esi
f01062f4:	09 f0                	or     %esi,%eax
f01062f6:	09 c2                	or     %eax,%edx
f01062f8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01062fa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01062fd:	89 d0                	mov    %edx,%eax
f01062ff:	fc                   	cld    
f0106300:	f3 ab                	rep stos %eax,%es:(%edi)
f0106302:	eb 06                	jmp    f010630a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0106304:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106307:	fc                   	cld    
f0106308:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010630a:	89 f8                	mov    %edi,%eax
f010630c:	5b                   	pop    %ebx
f010630d:	5e                   	pop    %esi
f010630e:	5f                   	pop    %edi
f010630f:	5d                   	pop    %ebp
f0106310:	c3                   	ret    

f0106311 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106311:	55                   	push   %ebp
f0106312:	89 e5                	mov    %esp,%ebp
f0106314:	57                   	push   %edi
f0106315:	56                   	push   %esi
f0106316:	8b 45 08             	mov    0x8(%ebp),%eax
f0106319:	8b 75 0c             	mov    0xc(%ebp),%esi
f010631c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010631f:	39 c6                	cmp    %eax,%esi
f0106321:	73 32                	jae    f0106355 <memmove+0x44>
f0106323:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106326:	39 c2                	cmp    %eax,%edx
f0106328:	76 2b                	jbe    f0106355 <memmove+0x44>
		s += n;
		d += n;
f010632a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010632d:	89 fe                	mov    %edi,%esi
f010632f:	09 ce                	or     %ecx,%esi
f0106331:	09 d6                	or     %edx,%esi
f0106333:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106339:	75 0e                	jne    f0106349 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f010633b:	83 ef 04             	sub    $0x4,%edi
f010633e:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106341:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0106344:	fd                   	std    
f0106345:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106347:	eb 09                	jmp    f0106352 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106349:	83 ef 01             	sub    $0x1,%edi
f010634c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010634f:	fd                   	std    
f0106350:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106352:	fc                   	cld    
f0106353:	eb 1a                	jmp    f010636f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106355:	89 c2                	mov    %eax,%edx
f0106357:	09 ca                	or     %ecx,%edx
f0106359:	09 f2                	or     %esi,%edx
f010635b:	f6 c2 03             	test   $0x3,%dl
f010635e:	75 0a                	jne    f010636a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106360:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0106363:	89 c7                	mov    %eax,%edi
f0106365:	fc                   	cld    
f0106366:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106368:	eb 05                	jmp    f010636f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f010636a:	89 c7                	mov    %eax,%edi
f010636c:	fc                   	cld    
f010636d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010636f:	5e                   	pop    %esi
f0106370:	5f                   	pop    %edi
f0106371:	5d                   	pop    %ebp
f0106372:	c3                   	ret    

f0106373 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106373:	55                   	push   %ebp
f0106374:	89 e5                	mov    %esp,%ebp
f0106376:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106379:	ff 75 10             	pushl  0x10(%ebp)
f010637c:	ff 75 0c             	pushl  0xc(%ebp)
f010637f:	ff 75 08             	pushl  0x8(%ebp)
f0106382:	e8 8a ff ff ff       	call   f0106311 <memmove>
}
f0106387:	c9                   	leave  
f0106388:	c3                   	ret    

f0106389 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106389:	55                   	push   %ebp
f010638a:	89 e5                	mov    %esp,%ebp
f010638c:	56                   	push   %esi
f010638d:	53                   	push   %ebx
f010638e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106391:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106394:	89 c6                	mov    %eax,%esi
f0106396:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106399:	39 f0                	cmp    %esi,%eax
f010639b:	74 1c                	je     f01063b9 <memcmp+0x30>
		if (*s1 != *s2)
f010639d:	0f b6 08             	movzbl (%eax),%ecx
f01063a0:	0f b6 1a             	movzbl (%edx),%ebx
f01063a3:	38 d9                	cmp    %bl,%cl
f01063a5:	75 08                	jne    f01063af <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f01063a7:	83 c0 01             	add    $0x1,%eax
f01063aa:	83 c2 01             	add    $0x1,%edx
f01063ad:	eb ea                	jmp    f0106399 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01063af:	0f b6 c1             	movzbl %cl,%eax
f01063b2:	0f b6 db             	movzbl %bl,%ebx
f01063b5:	29 d8                	sub    %ebx,%eax
f01063b7:	eb 05                	jmp    f01063be <memcmp+0x35>
	}

	return 0;
f01063b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01063be:	5b                   	pop    %ebx
f01063bf:	5e                   	pop    %esi
f01063c0:	5d                   	pop    %ebp
f01063c1:	c3                   	ret    

f01063c2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01063c2:	55                   	push   %ebp
f01063c3:	89 e5                	mov    %esp,%ebp
f01063c5:	8b 45 08             	mov    0x8(%ebp),%eax
f01063c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01063cb:	89 c2                	mov    %eax,%edx
f01063cd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01063d0:	39 d0                	cmp    %edx,%eax
f01063d2:	73 09                	jae    f01063dd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01063d4:	38 08                	cmp    %cl,(%eax)
f01063d6:	74 05                	je     f01063dd <memfind+0x1b>
	for (; s < ends; s++)
f01063d8:	83 c0 01             	add    $0x1,%eax
f01063db:	eb f3                	jmp    f01063d0 <memfind+0xe>
			break;
	return (void *) s;
}
f01063dd:	5d                   	pop    %ebp
f01063de:	c3                   	ret    

f01063df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01063df:	55                   	push   %ebp
f01063e0:	89 e5                	mov    %esp,%ebp
f01063e2:	57                   	push   %edi
f01063e3:	56                   	push   %esi
f01063e4:	53                   	push   %ebx
f01063e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01063e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01063eb:	eb 03                	jmp    f01063f0 <strtol+0x11>
		s++;
f01063ed:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01063f0:	0f b6 01             	movzbl (%ecx),%eax
f01063f3:	3c 20                	cmp    $0x20,%al
f01063f5:	74 f6                	je     f01063ed <strtol+0xe>
f01063f7:	3c 09                	cmp    $0x9,%al
f01063f9:	74 f2                	je     f01063ed <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01063fb:	3c 2b                	cmp    $0x2b,%al
f01063fd:	74 2a                	je     f0106429 <strtol+0x4a>
	int neg = 0;
f01063ff:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0106404:	3c 2d                	cmp    $0x2d,%al
f0106406:	74 2b                	je     f0106433 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106408:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f010640e:	75 0f                	jne    f010641f <strtol+0x40>
f0106410:	80 39 30             	cmpb   $0x30,(%ecx)
f0106413:	74 28                	je     f010643d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106415:	85 db                	test   %ebx,%ebx
f0106417:	b8 0a 00 00 00       	mov    $0xa,%eax
f010641c:	0f 44 d8             	cmove  %eax,%ebx
f010641f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106424:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106427:	eb 50                	jmp    f0106479 <strtol+0x9a>
		s++;
f0106429:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f010642c:	bf 00 00 00 00       	mov    $0x0,%edi
f0106431:	eb d5                	jmp    f0106408 <strtol+0x29>
		s++, neg = 1;
f0106433:	83 c1 01             	add    $0x1,%ecx
f0106436:	bf 01 00 00 00       	mov    $0x1,%edi
f010643b:	eb cb                	jmp    f0106408 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010643d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0106441:	74 0e                	je     f0106451 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f0106443:	85 db                	test   %ebx,%ebx
f0106445:	75 d8                	jne    f010641f <strtol+0x40>
		s++, base = 8;
f0106447:	83 c1 01             	add    $0x1,%ecx
f010644a:	bb 08 00 00 00       	mov    $0x8,%ebx
f010644f:	eb ce                	jmp    f010641f <strtol+0x40>
		s += 2, base = 16;
f0106451:	83 c1 02             	add    $0x2,%ecx
f0106454:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106459:	eb c4                	jmp    f010641f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f010645b:	8d 72 9f             	lea    -0x61(%edx),%esi
f010645e:	89 f3                	mov    %esi,%ebx
f0106460:	80 fb 19             	cmp    $0x19,%bl
f0106463:	77 29                	ja     f010648e <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106465:	0f be d2             	movsbl %dl,%edx
f0106468:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010646b:	3b 55 10             	cmp    0x10(%ebp),%edx
f010646e:	7d 30                	jge    f01064a0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f0106470:	83 c1 01             	add    $0x1,%ecx
f0106473:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106477:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106479:	0f b6 11             	movzbl (%ecx),%edx
f010647c:	8d 72 d0             	lea    -0x30(%edx),%esi
f010647f:	89 f3                	mov    %esi,%ebx
f0106481:	80 fb 09             	cmp    $0x9,%bl
f0106484:	77 d5                	ja     f010645b <strtol+0x7c>
			dig = *s - '0';
f0106486:	0f be d2             	movsbl %dl,%edx
f0106489:	83 ea 30             	sub    $0x30,%edx
f010648c:	eb dd                	jmp    f010646b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f010648e:	8d 72 bf             	lea    -0x41(%edx),%esi
f0106491:	89 f3                	mov    %esi,%ebx
f0106493:	80 fb 19             	cmp    $0x19,%bl
f0106496:	77 08                	ja     f01064a0 <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106498:	0f be d2             	movsbl %dl,%edx
f010649b:	83 ea 37             	sub    $0x37,%edx
f010649e:	eb cb                	jmp    f010646b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f01064a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01064a4:	74 05                	je     f01064ab <strtol+0xcc>
		*endptr = (char *) s;
f01064a6:	8b 75 0c             	mov    0xc(%ebp),%esi
f01064a9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01064ab:	89 c2                	mov    %eax,%edx
f01064ad:	f7 da                	neg    %edx
f01064af:	85 ff                	test   %edi,%edi
f01064b1:	0f 45 c2             	cmovne %edx,%eax
}
f01064b4:	5b                   	pop    %ebx
f01064b5:	5e                   	pop    %esi
f01064b6:	5f                   	pop    %edi
f01064b7:	5d                   	pop    %ebp
f01064b8:	c3                   	ret    
f01064b9:	66 90                	xchg   %ax,%ax
f01064bb:	90                   	nop

f01064bc <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01064bc:	fa                   	cli    

	xorw    %ax, %ax
f01064bd:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01064bf:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01064c1:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01064c3:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01064c5:	0f 01 16             	lgdtl  (%esi)
f01064c8:	74 70                	je     f010653a <mpsearch1+0x3>
	movl    %cr0, %eax
f01064ca:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01064cd:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01064d1:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01064d4:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01064da:	08 00                	or     %al,(%eax)

f01064dc <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01064dc:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01064e0:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01064e2:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01064e4:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01064e6:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01064ea:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01064ec:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01064ee:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl    %eax, %cr3
f01064f3:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01064f6:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01064f9:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01064fe:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106501:	8b 25 84 7e 34 f0    	mov    0xf0347e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106507:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f010650c:	b8 c9 01 10 f0       	mov    $0xf01001c9,%eax
	call    *%eax
f0106511:	ff d0                	call   *%eax

f0106513 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106513:	eb fe                	jmp    f0106513 <spin>
f0106515:	8d 76 00             	lea    0x0(%esi),%esi

f0106518 <gdt>:
	...
f0106520:	ff                   	(bad)  
f0106521:	ff 00                	incl   (%eax)
f0106523:	00 00                	add    %al,(%eax)
f0106525:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010652c:	00                   	.byte 0x0
f010652d:	92                   	xchg   %eax,%edx
f010652e:	cf                   	iret   
	...

f0106530 <gdtdesc>:
f0106530:	17                   	pop    %ss
f0106531:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0106536 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106536:	90                   	nop

f0106537 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106537:	55                   	push   %ebp
f0106538:	89 e5                	mov    %esp,%ebp
f010653a:	57                   	push   %edi
f010653b:	56                   	push   %esi
f010653c:	53                   	push   %ebx
f010653d:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106540:	8b 0d 88 7e 34 f0    	mov    0xf0347e88,%ecx
f0106546:	89 c3                	mov    %eax,%ebx
f0106548:	c1 eb 0c             	shr    $0xc,%ebx
f010654b:	39 cb                	cmp    %ecx,%ebx
f010654d:	73 1a                	jae    f0106569 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f010654f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106555:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106558:	89 f8                	mov    %edi,%eax
f010655a:	c1 e8 0c             	shr    $0xc,%eax
f010655d:	39 c8                	cmp    %ecx,%eax
f010655f:	73 1a                	jae    f010657b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106561:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106567:	eb 27                	jmp    f0106590 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106569:	50                   	push   %eax
f010656a:	68 74 6f 10 f0       	push   $0xf0106f74
f010656f:	6a 57                	push   $0x57
f0106571:	68 9d 90 10 f0       	push   $0xf010909d
f0106576:	e8 c5 9a ff ff       	call   f0100040 <_panic>
f010657b:	57                   	push   %edi
f010657c:	68 74 6f 10 f0       	push   $0xf0106f74
f0106581:	6a 57                	push   $0x57
f0106583:	68 9d 90 10 f0       	push   $0xf010909d
f0106588:	e8 b3 9a ff ff       	call   f0100040 <_panic>
f010658d:	83 c3 10             	add    $0x10,%ebx
f0106590:	39 fb                	cmp    %edi,%ebx
f0106592:	73 30                	jae    f01065c4 <mpsearch1+0x8d>
f0106594:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106596:	83 ec 04             	sub    $0x4,%esp
f0106599:	6a 04                	push   $0x4
f010659b:	68 ad 90 10 f0       	push   $0xf01090ad
f01065a0:	53                   	push   %ebx
f01065a1:	e8 e3 fd ff ff       	call   f0106389 <memcmp>
f01065a6:	83 c4 10             	add    $0x10,%esp
f01065a9:	85 c0                	test   %eax,%eax
f01065ab:	75 e0                	jne    f010658d <mpsearch1+0x56>
f01065ad:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f01065af:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f01065b2:	0f b6 0a             	movzbl (%edx),%ecx
f01065b5:	01 c8                	add    %ecx,%eax
f01065b7:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f01065ba:	39 f2                	cmp    %esi,%edx
f01065bc:	75 f4                	jne    f01065b2 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01065be:	84 c0                	test   %al,%al
f01065c0:	75 cb                	jne    f010658d <mpsearch1+0x56>
f01065c2:	eb 05                	jmp    f01065c9 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01065c4:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01065c9:	89 d8                	mov    %ebx,%eax
f01065cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01065ce:	5b                   	pop    %ebx
f01065cf:	5e                   	pop    %esi
f01065d0:	5f                   	pop    %edi
f01065d1:	5d                   	pop    %ebp
f01065d2:	c3                   	ret    

f01065d3 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01065d3:	55                   	push   %ebp
f01065d4:	89 e5                	mov    %esp,%ebp
f01065d6:	57                   	push   %edi
f01065d7:	56                   	push   %esi
f01065d8:	53                   	push   %ebx
f01065d9:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01065dc:	c7 05 c0 83 34 f0 20 	movl   $0xf0348020,0xf03483c0
f01065e3:	80 34 f0 
	if (PGNUM(pa) >= npages)
f01065e6:	83 3d 88 7e 34 f0 00 	cmpl   $0x0,0xf0347e88
f01065ed:	0f 84 a3 00 00 00    	je     f0106696 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01065f3:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01065fa:	85 c0                	test   %eax,%eax
f01065fc:	0f 84 aa 00 00 00    	je     f01066ac <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f0106602:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106605:	ba 00 04 00 00       	mov    $0x400,%edx
f010660a:	e8 28 ff ff ff       	call   f0106537 <mpsearch1>
f010660f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106612:	85 c0                	test   %eax,%eax
f0106614:	75 1a                	jne    f0106630 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0106616:	ba 00 00 01 00       	mov    $0x10000,%edx
f010661b:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106620:	e8 12 ff ff ff       	call   f0106537 <mpsearch1>
f0106625:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0106628:	85 c0                	test   %eax,%eax
f010662a:	0f 84 31 02 00 00    	je     f0106861 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106633:	8b 58 04             	mov    0x4(%eax),%ebx
f0106636:	85 db                	test   %ebx,%ebx
f0106638:	0f 84 97 00 00 00    	je     f01066d5 <mp_init+0x102>
f010663e:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106642:	0f 85 8d 00 00 00    	jne    f01066d5 <mp_init+0x102>
f0106648:	89 d8                	mov    %ebx,%eax
f010664a:	c1 e8 0c             	shr    $0xc,%eax
f010664d:	3b 05 88 7e 34 f0    	cmp    0xf0347e88,%eax
f0106653:	0f 83 91 00 00 00    	jae    f01066ea <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106659:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f010665f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106661:	83 ec 04             	sub    $0x4,%esp
f0106664:	6a 04                	push   $0x4
f0106666:	68 b2 90 10 f0       	push   $0xf01090b2
f010666b:	53                   	push   %ebx
f010666c:	e8 18 fd ff ff       	call   f0106389 <memcmp>
f0106671:	83 c4 10             	add    $0x10,%esp
f0106674:	85 c0                	test   %eax,%eax
f0106676:	0f 85 83 00 00 00    	jne    f01066ff <mp_init+0x12c>
f010667c:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106680:	01 df                	add    %ebx,%edi
	sum = 0;
f0106682:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106684:	39 fb                	cmp    %edi,%ebx
f0106686:	0f 84 88 00 00 00    	je     f0106714 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f010668c:	0f b6 0b             	movzbl (%ebx),%ecx
f010668f:	01 ca                	add    %ecx,%edx
f0106691:	83 c3 01             	add    $0x1,%ebx
f0106694:	eb ee                	jmp    f0106684 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106696:	68 00 04 00 00       	push   $0x400
f010669b:	68 74 6f 10 f0       	push   $0xf0106f74
f01066a0:	6a 6f                	push   $0x6f
f01066a2:	68 9d 90 10 f0       	push   $0xf010909d
f01066a7:	e8 94 99 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f01066ac:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01066b3:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f01066b6:	2d 00 04 00 00       	sub    $0x400,%eax
f01066bb:	ba 00 04 00 00       	mov    $0x400,%edx
f01066c0:	e8 72 fe ff ff       	call   f0106537 <mpsearch1>
f01066c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01066c8:	85 c0                	test   %eax,%eax
f01066ca:	0f 85 60 ff ff ff    	jne    f0106630 <mp_init+0x5d>
f01066d0:	e9 41 ff ff ff       	jmp    f0106616 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f01066d5:	83 ec 0c             	sub    $0xc,%esp
f01066d8:	68 10 8f 10 f0       	push   $0xf0108f10
f01066dd:	e8 a1 d6 ff ff       	call   f0103d83 <cprintf>
f01066e2:	83 c4 10             	add    $0x10,%esp
f01066e5:	e9 77 01 00 00       	jmp    f0106861 <mp_init+0x28e>
f01066ea:	53                   	push   %ebx
f01066eb:	68 74 6f 10 f0       	push   $0xf0106f74
f01066f0:	68 90 00 00 00       	push   $0x90
f01066f5:	68 9d 90 10 f0       	push   $0xf010909d
f01066fa:	e8 41 99 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01066ff:	83 ec 0c             	sub    $0xc,%esp
f0106702:	68 40 8f 10 f0       	push   $0xf0108f40
f0106707:	e8 77 d6 ff ff       	call   f0103d83 <cprintf>
f010670c:	83 c4 10             	add    $0x10,%esp
f010670f:	e9 4d 01 00 00       	jmp    f0106861 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0106714:	84 d2                	test   %dl,%dl
f0106716:	75 16                	jne    f010672e <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0106718:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f010671c:	80 fa 01             	cmp    $0x1,%dl
f010671f:	74 05                	je     f0106726 <mp_init+0x153>
f0106721:	80 fa 04             	cmp    $0x4,%dl
f0106724:	75 1d                	jne    f0106743 <mp_init+0x170>
f0106726:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f010672a:	01 d9                	add    %ebx,%ecx
f010672c:	eb 36                	jmp    f0106764 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f010672e:	83 ec 0c             	sub    $0xc,%esp
f0106731:	68 74 8f 10 f0       	push   $0xf0108f74
f0106736:	e8 48 d6 ff ff       	call   f0103d83 <cprintf>
f010673b:	83 c4 10             	add    $0x10,%esp
f010673e:	e9 1e 01 00 00       	jmp    f0106861 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106743:	83 ec 08             	sub    $0x8,%esp
f0106746:	0f b6 d2             	movzbl %dl,%edx
f0106749:	52                   	push   %edx
f010674a:	68 98 8f 10 f0       	push   $0xf0108f98
f010674f:	e8 2f d6 ff ff       	call   f0103d83 <cprintf>
f0106754:	83 c4 10             	add    $0x10,%esp
f0106757:	e9 05 01 00 00       	jmp    f0106861 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f010675c:	0f b6 13             	movzbl (%ebx),%edx
f010675f:	01 d0                	add    %edx,%eax
f0106761:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106764:	39 d9                	cmp    %ebx,%ecx
f0106766:	75 f4                	jne    f010675c <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106768:	02 46 2a             	add    0x2a(%esi),%al
f010676b:	75 1c                	jne    f0106789 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f010676d:	c7 05 00 80 34 f0 01 	movl   $0x1,0xf0348000
f0106774:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106777:	8b 46 24             	mov    0x24(%esi),%eax
f010677a:	a3 00 90 38 f0       	mov    %eax,0xf0389000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f010677f:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106782:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106787:	eb 4d                	jmp    f01067d6 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106789:	83 ec 0c             	sub    $0xc,%esp
f010678c:	68 b8 8f 10 f0       	push   $0xf0108fb8
f0106791:	e8 ed d5 ff ff       	call   f0103d83 <cprintf>
f0106796:	83 c4 10             	add    $0x10,%esp
f0106799:	e9 c3 00 00 00       	jmp    f0106861 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f010679e:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f01067a2:	74 11                	je     f01067b5 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f01067a4:	6b 05 c4 83 34 f0 74 	imul   $0x74,0xf03483c4,%eax
f01067ab:	05 20 80 34 f0       	add    $0xf0348020,%eax
f01067b0:	a3 c0 83 34 f0       	mov    %eax,0xf03483c0
			if (ncpu < NCPU) {
f01067b5:	a1 c4 83 34 f0       	mov    0xf03483c4,%eax
f01067ba:	83 f8 07             	cmp    $0x7,%eax
f01067bd:	7f 2f                	jg     f01067ee <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f01067bf:	6b d0 74             	imul   $0x74,%eax,%edx
f01067c2:	88 82 20 80 34 f0    	mov    %al,-0xfcb7fe0(%edx)
				ncpu++;
f01067c8:	83 c0 01             	add    $0x1,%eax
f01067cb:	a3 c4 83 34 f0       	mov    %eax,0xf03483c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f01067d0:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01067d3:	83 c3 01             	add    $0x1,%ebx
f01067d6:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f01067da:	39 d8                	cmp    %ebx,%eax
f01067dc:	76 4b                	jbe    f0106829 <mp_init+0x256>
		switch (*p) {
f01067de:	0f b6 07             	movzbl (%edi),%eax
f01067e1:	84 c0                	test   %al,%al
f01067e3:	74 b9                	je     f010679e <mp_init+0x1cb>
f01067e5:	3c 04                	cmp    $0x4,%al
f01067e7:	77 1c                	ja     f0106805 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f01067e9:	83 c7 08             	add    $0x8,%edi
			continue;
f01067ec:	eb e5                	jmp    f01067d3 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f01067ee:	83 ec 08             	sub    $0x8,%esp
f01067f1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f01067f5:	50                   	push   %eax
f01067f6:	68 e8 8f 10 f0       	push   $0xf0108fe8
f01067fb:	e8 83 d5 ff ff       	call   f0103d83 <cprintf>
f0106800:	83 c4 10             	add    $0x10,%esp
f0106803:	eb cb                	jmp    f01067d0 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106805:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106808:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f010680b:	50                   	push   %eax
f010680c:	68 10 90 10 f0       	push   $0xf0109010
f0106811:	e8 6d d5 ff ff       	call   f0103d83 <cprintf>
			ismp = 0;
f0106816:	c7 05 00 80 34 f0 00 	movl   $0x0,0xf0348000
f010681d:	00 00 00 
			i = conf->entry;
f0106820:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106824:	83 c4 10             	add    $0x10,%esp
f0106827:	eb aa                	jmp    f01067d3 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106829:	a1 c0 83 34 f0       	mov    0xf03483c0,%eax
f010682e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106835:	83 3d 00 80 34 f0 00 	cmpl   $0x0,0xf0348000
f010683c:	74 2b                	je     f0106869 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f010683e:	83 ec 04             	sub    $0x4,%esp
f0106841:	ff 35 c4 83 34 f0    	pushl  0xf03483c4
f0106847:	0f b6 00             	movzbl (%eax),%eax
f010684a:	50                   	push   %eax
f010684b:	68 b7 90 10 f0       	push   $0xf01090b7
f0106850:	e8 2e d5 ff ff       	call   f0103d83 <cprintf>

	if (mp->imcrp) {
f0106855:	83 c4 10             	add    $0x10,%esp
f0106858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010685b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f010685f:	75 2e                	jne    f010688f <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106861:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106864:	5b                   	pop    %ebx
f0106865:	5e                   	pop    %esi
f0106866:	5f                   	pop    %edi
f0106867:	5d                   	pop    %ebp
f0106868:	c3                   	ret    
		ncpu = 1;
f0106869:	c7 05 c4 83 34 f0 01 	movl   $0x1,0xf03483c4
f0106870:	00 00 00 
		lapicaddr = 0;
f0106873:	c7 05 00 90 38 f0 00 	movl   $0x0,0xf0389000
f010687a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f010687d:	83 ec 0c             	sub    $0xc,%esp
f0106880:	68 30 90 10 f0       	push   $0xf0109030
f0106885:	e8 f9 d4 ff ff       	call   f0103d83 <cprintf>
		return;
f010688a:	83 c4 10             	add    $0x10,%esp
f010688d:	eb d2                	jmp    f0106861 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f010688f:	83 ec 0c             	sub    $0xc,%esp
f0106892:	68 5c 90 10 f0       	push   $0xf010905c
f0106897:	e8 e7 d4 ff ff       	call   f0103d83 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010689c:	b8 70 00 00 00       	mov    $0x70,%eax
f01068a1:	ba 22 00 00 00       	mov    $0x22,%edx
f01068a6:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01068a7:	ba 23 00 00 00       	mov    $0x23,%edx
f01068ac:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f01068ad:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01068b0:	ee                   	out    %al,(%dx)
f01068b1:	83 c4 10             	add    $0x10,%esp
f01068b4:	eb ab                	jmp    f0106861 <mp_init+0x28e>

f01068b6 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f01068b6:	8b 0d 04 90 38 f0    	mov    0xf0389004,%ecx
f01068bc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f01068bf:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f01068c1:	a1 04 90 38 f0       	mov    0xf0389004,%eax
f01068c6:	8b 40 20             	mov    0x20(%eax),%eax
}
f01068c9:	c3                   	ret    

f01068ca <cpunum>:
}

int
cpunum(void)
{
	if (lapic){
f01068ca:	8b 15 04 90 38 f0    	mov    0xf0389004,%edx
		return lapic[ID] >> 24;
	}
	return 0;
f01068d0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic){
f01068d5:	85 d2                	test   %edx,%edx
f01068d7:	74 06                	je     f01068df <cpunum+0x15>
		return lapic[ID] >> 24;
f01068d9:	8b 42 20             	mov    0x20(%edx),%eax
f01068dc:	c1 e8 18             	shr    $0x18,%eax
}
f01068df:	c3                   	ret    

f01068e0 <lapic_init>:
	if (!lapicaddr)
f01068e0:	a1 00 90 38 f0       	mov    0xf0389000,%eax
f01068e5:	85 c0                	test   %eax,%eax
f01068e7:	75 01                	jne    f01068ea <lapic_init+0xa>
f01068e9:	c3                   	ret    
{
f01068ea:	55                   	push   %ebp
f01068eb:	89 e5                	mov    %esp,%ebp
f01068ed:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f01068f0:	68 00 10 00 00       	push   $0x1000
f01068f5:	50                   	push   %eax
f01068f6:	e8 c5 ad ff ff       	call   f01016c0 <mmio_map_region>
f01068fb:	a3 04 90 38 f0       	mov    %eax,0xf0389004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106900:	ba 27 01 00 00       	mov    $0x127,%edx
f0106905:	b8 3c 00 00 00       	mov    $0x3c,%eax
f010690a:	e8 a7 ff ff ff       	call   f01068b6 <lapicw>
	lapicw(TDCR, X1);
f010690f:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106914:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106919:	e8 98 ff ff ff       	call   f01068b6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f010691e:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106923:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106928:	e8 89 ff ff ff       	call   f01068b6 <lapicw>
	lapicw(TICR, 10000000); 
f010692d:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106932:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106937:	e8 7a ff ff ff       	call   f01068b6 <lapicw>
	if (thiscpu != bootcpu)
f010693c:	e8 89 ff ff ff       	call   f01068ca <cpunum>
f0106941:	6b c0 74             	imul   $0x74,%eax,%eax
f0106944:	05 20 80 34 f0       	add    $0xf0348020,%eax
f0106949:	83 c4 10             	add    $0x10,%esp
f010694c:	39 05 c0 83 34 f0    	cmp    %eax,0xf03483c0
f0106952:	74 0f                	je     f0106963 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106954:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106959:	b8 d4 00 00 00       	mov    $0xd4,%eax
f010695e:	e8 53 ff ff ff       	call   f01068b6 <lapicw>
	lapicw(LINT1, MASKED);
f0106963:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106968:	b8 d8 00 00 00       	mov    $0xd8,%eax
f010696d:	e8 44 ff ff ff       	call   f01068b6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106972:	a1 04 90 38 f0       	mov    0xf0389004,%eax
f0106977:	8b 40 30             	mov    0x30(%eax),%eax
f010697a:	c1 e8 10             	shr    $0x10,%eax
f010697d:	a8 fc                	test   $0xfc,%al
f010697f:	75 7c                	jne    f01069fd <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106981:	ba 33 00 00 00       	mov    $0x33,%edx
f0106986:	b8 dc 00 00 00       	mov    $0xdc,%eax
f010698b:	e8 26 ff ff ff       	call   f01068b6 <lapicw>
	lapicw(ESR, 0);
f0106990:	ba 00 00 00 00       	mov    $0x0,%edx
f0106995:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010699a:	e8 17 ff ff ff       	call   f01068b6 <lapicw>
	lapicw(ESR, 0);
f010699f:	ba 00 00 00 00       	mov    $0x0,%edx
f01069a4:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01069a9:	e8 08 ff ff ff       	call   f01068b6 <lapicw>
	lapicw(EOI, 0);
f01069ae:	ba 00 00 00 00       	mov    $0x0,%edx
f01069b3:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01069b8:	e8 f9 fe ff ff       	call   f01068b6 <lapicw>
	lapicw(ICRHI, 0);
f01069bd:	ba 00 00 00 00       	mov    $0x0,%edx
f01069c2:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01069c7:	e8 ea fe ff ff       	call   f01068b6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f01069cc:	ba 00 85 08 00       	mov    $0x88500,%edx
f01069d1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01069d6:	e8 db fe ff ff       	call   f01068b6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f01069db:	8b 15 04 90 38 f0    	mov    0xf0389004,%edx
f01069e1:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01069e7:	f6 c4 10             	test   $0x10,%ah
f01069ea:	75 f5                	jne    f01069e1 <lapic_init+0x101>
	lapicw(TPR, 0);
f01069ec:	ba 00 00 00 00       	mov    $0x0,%edx
f01069f1:	b8 20 00 00 00       	mov    $0x20,%eax
f01069f6:	e8 bb fe ff ff       	call   f01068b6 <lapicw>
}
f01069fb:	c9                   	leave  
f01069fc:	c3                   	ret    
		lapicw(PCINT, MASKED);
f01069fd:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106a02:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106a07:	e8 aa fe ff ff       	call   f01068b6 <lapicw>
f0106a0c:	e9 70 ff ff ff       	jmp    f0106981 <lapic_init+0xa1>

f0106a11 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106a11:	83 3d 04 90 38 f0 00 	cmpl   $0x0,0xf0389004
f0106a18:	74 17                	je     f0106a31 <lapic_eoi+0x20>
{
f0106a1a:	55                   	push   %ebp
f0106a1b:	89 e5                	mov    %esp,%ebp
f0106a1d:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106a20:	ba 00 00 00 00       	mov    $0x0,%edx
f0106a25:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106a2a:	e8 87 fe ff ff       	call   f01068b6 <lapicw>
}
f0106a2f:	c9                   	leave  
f0106a30:	c3                   	ret    
f0106a31:	c3                   	ret    

f0106a32 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106a32:	55                   	push   %ebp
f0106a33:	89 e5                	mov    %esp,%ebp
f0106a35:	56                   	push   %esi
f0106a36:	53                   	push   %ebx
f0106a37:	8b 75 08             	mov    0x8(%ebp),%esi
f0106a3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106a3d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106a42:	ba 70 00 00 00       	mov    $0x70,%edx
f0106a47:	ee                   	out    %al,(%dx)
f0106a48:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106a4d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106a52:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106a53:	83 3d 88 7e 34 f0 00 	cmpl   $0x0,0xf0347e88
f0106a5a:	74 7e                	je     f0106ada <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106a5c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106a63:	00 00 
	wrv[1] = addr >> 4;
f0106a65:	89 d8                	mov    %ebx,%eax
f0106a67:	c1 e8 04             	shr    $0x4,%eax
f0106a6a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106a70:	c1 e6 18             	shl    $0x18,%esi
f0106a73:	89 f2                	mov    %esi,%edx
f0106a75:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106a7a:	e8 37 fe ff ff       	call   f01068b6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106a7f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106a84:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106a89:	e8 28 fe ff ff       	call   f01068b6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106a8e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106a93:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106a98:	e8 19 fe ff ff       	call   f01068b6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106a9d:	c1 eb 0c             	shr    $0xc,%ebx
f0106aa0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106aa3:	89 f2                	mov    %esi,%edx
f0106aa5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106aaa:	e8 07 fe ff ff       	call   f01068b6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106aaf:	89 da                	mov    %ebx,%edx
f0106ab1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106ab6:	e8 fb fd ff ff       	call   f01068b6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106abb:	89 f2                	mov    %esi,%edx
f0106abd:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106ac2:	e8 ef fd ff ff       	call   f01068b6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106ac7:	89 da                	mov    %ebx,%edx
f0106ac9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106ace:	e8 e3 fd ff ff       	call   f01068b6 <lapicw>
		microdelay(200);
	}
}
f0106ad3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106ad6:	5b                   	pop    %ebx
f0106ad7:	5e                   	pop    %esi
f0106ad8:	5d                   	pop    %ebp
f0106ad9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106ada:	68 67 04 00 00       	push   $0x467
f0106adf:	68 74 6f 10 f0       	push   $0xf0106f74
f0106ae4:	68 9c 00 00 00       	push   $0x9c
f0106ae9:	68 d4 90 10 f0       	push   $0xf01090d4
f0106aee:	e8 4d 95 ff ff       	call   f0100040 <_panic>

f0106af3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106af3:	55                   	push   %ebp
f0106af4:	89 e5                	mov    %esp,%ebp
f0106af6:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106af9:	8b 55 08             	mov    0x8(%ebp),%edx
f0106afc:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106b02:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106b07:	e8 aa fd ff ff       	call   f01068b6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106b0c:	8b 15 04 90 38 f0    	mov    0xf0389004,%edx
f0106b12:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106b18:	f6 c4 10             	test   $0x10,%ah
f0106b1b:	75 f5                	jne    f0106b12 <lapic_ipi+0x1f>
		;
}
f0106b1d:	c9                   	leave  
f0106b1e:	c3                   	ret    

f0106b1f <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106b1f:	55                   	push   %ebp
f0106b20:	89 e5                	mov    %esp,%ebp
f0106b22:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106b2e:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106b31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106b38:	5d                   	pop    %ebp
f0106b39:	c3                   	ret    

f0106b3a <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106b3a:	55                   	push   %ebp
f0106b3b:	89 e5                	mov    %esp,%ebp
f0106b3d:	56                   	push   %esi
f0106b3e:	53                   	push   %ebx
f0106b3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106b42:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106b45:	75 12                	jne    f0106b59 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0106b47:	ba 01 00 00 00       	mov    $0x1,%edx
f0106b4c:	89 d0                	mov    %edx,%eax
f0106b4e:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106b51:	85 c0                	test   %eax,%eax
f0106b53:	74 36                	je     f0106b8b <spin_lock+0x51>
		asm volatile ("pause");
f0106b55:	f3 90                	pause  
f0106b57:	eb f3                	jmp    f0106b4c <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0106b59:	8b 73 08             	mov    0x8(%ebx),%esi
f0106b5c:	e8 69 fd ff ff       	call   f01068ca <cpunum>
f0106b61:	6b c0 74             	imul   $0x74,%eax,%eax
f0106b64:	05 20 80 34 f0       	add    $0xf0348020,%eax
	if (holding(lk))
f0106b69:	39 c6                	cmp    %eax,%esi
f0106b6b:	75 da                	jne    f0106b47 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106b6d:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106b70:	e8 55 fd ff ff       	call   f01068ca <cpunum>
f0106b75:	83 ec 0c             	sub    $0xc,%esp
f0106b78:	53                   	push   %ebx
f0106b79:	50                   	push   %eax
f0106b7a:	68 e4 90 10 f0       	push   $0xf01090e4
f0106b7f:	6a 41                	push   $0x41
f0106b81:	68 48 91 10 f0       	push   $0xf0109148
f0106b86:	e8 b5 94 ff ff       	call   f0100040 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106b8b:	e8 3a fd ff ff       	call   f01068ca <cpunum>
f0106b90:	6b c0 74             	imul   $0x74,%eax,%eax
f0106b93:	05 20 80 34 f0       	add    $0xf0348020,%eax
f0106b98:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0106b9b:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106b9d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106ba2:	83 f8 09             	cmp    $0x9,%eax
f0106ba5:	7f 16                	jg     f0106bbd <spin_lock+0x83>
f0106ba7:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106bad:	76 0e                	jbe    f0106bbd <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f0106baf:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106bb2:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106bb6:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106bb8:	83 c0 01             	add    $0x1,%eax
f0106bbb:	eb e5                	jmp    f0106ba2 <spin_lock+0x68>
	for (; i < 10; i++)
f0106bbd:	83 f8 09             	cmp    $0x9,%eax
f0106bc0:	7f 0d                	jg     f0106bcf <spin_lock+0x95>
		pcs[i] = 0;
f0106bc2:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106bc9:	00 
	for (; i < 10; i++)
f0106bca:	83 c0 01             	add    $0x1,%eax
f0106bcd:	eb ee                	jmp    f0106bbd <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f0106bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106bd2:	5b                   	pop    %ebx
f0106bd3:	5e                   	pop    %esi
f0106bd4:	5d                   	pop    %ebp
f0106bd5:	c3                   	ret    

f0106bd6 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106bd6:	55                   	push   %ebp
f0106bd7:	89 e5                	mov    %esp,%ebp
f0106bd9:	57                   	push   %edi
f0106bda:	56                   	push   %esi
f0106bdb:	53                   	push   %ebx
f0106bdc:	83 ec 4c             	sub    $0x4c,%esp
f0106bdf:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106be2:	83 3e 00             	cmpl   $0x0,(%esi)
f0106be5:	75 35                	jne    f0106c1c <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106be7:	83 ec 04             	sub    $0x4,%esp
f0106bea:	6a 28                	push   $0x28
f0106bec:	8d 46 0c             	lea    0xc(%esi),%eax
f0106bef:	50                   	push   %eax
f0106bf0:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106bf3:	53                   	push   %ebx
f0106bf4:	e8 18 f7 ff ff       	call   f0106311 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106bf9:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106bfc:	0f b6 38             	movzbl (%eax),%edi
f0106bff:	8b 76 04             	mov    0x4(%esi),%esi
f0106c02:	e8 c3 fc ff ff       	call   f01068ca <cpunum>
f0106c07:	57                   	push   %edi
f0106c08:	56                   	push   %esi
f0106c09:	50                   	push   %eax
f0106c0a:	68 10 91 10 f0       	push   $0xf0109110
f0106c0f:	e8 6f d1 ff ff       	call   f0103d83 <cprintf>
f0106c14:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106c17:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106c1a:	eb 4e                	jmp    f0106c6a <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f0106c1c:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106c1f:	e8 a6 fc ff ff       	call   f01068ca <cpunum>
f0106c24:	6b c0 74             	imul   $0x74,%eax,%eax
f0106c27:	05 20 80 34 f0       	add    $0xf0348020,%eax
	if (!holding(lk)) {
f0106c2c:	39 c3                	cmp    %eax,%ebx
f0106c2e:	75 b7                	jne    f0106be7 <spin_unlock+0x11>
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}
	lk->pcs[0] = 0;
f0106c30:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106c37:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106c3e:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c43:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106c49:	5b                   	pop    %ebx
f0106c4a:	5e                   	pop    %esi
f0106c4b:	5f                   	pop    %edi
f0106c4c:	5d                   	pop    %ebp
f0106c4d:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106c4e:	83 ec 08             	sub    $0x8,%esp
f0106c51:	ff 36                	pushl  (%esi)
f0106c53:	68 6f 91 10 f0       	push   $0xf010916f
f0106c58:	e8 26 d1 ff ff       	call   f0103d83 <cprintf>
f0106c5d:	83 c4 10             	add    $0x10,%esp
f0106c60:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106c63:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106c66:	39 c3                	cmp    %eax,%ebx
f0106c68:	74 40                	je     f0106caa <spin_unlock+0xd4>
f0106c6a:	89 de                	mov    %ebx,%esi
f0106c6c:	8b 03                	mov    (%ebx),%eax
f0106c6e:	85 c0                	test   %eax,%eax
f0106c70:	74 38                	je     f0106caa <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106c72:	83 ec 08             	sub    $0x8,%esp
f0106c75:	57                   	push   %edi
f0106c76:	50                   	push   %eax
f0106c77:	e8 e6 e9 ff ff       	call   f0105662 <debuginfo_eip>
f0106c7c:	83 c4 10             	add    $0x10,%esp
f0106c7f:	85 c0                	test   %eax,%eax
f0106c81:	78 cb                	js     f0106c4e <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0106c83:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106c85:	83 ec 04             	sub    $0x4,%esp
f0106c88:	89 c2                	mov    %eax,%edx
f0106c8a:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106c8d:	52                   	push   %edx
f0106c8e:	ff 75 b0             	pushl  -0x50(%ebp)
f0106c91:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106c94:	ff 75 ac             	pushl  -0x54(%ebp)
f0106c97:	ff 75 a8             	pushl  -0x58(%ebp)
f0106c9a:	50                   	push   %eax
f0106c9b:	68 58 91 10 f0       	push   $0xf0109158
f0106ca0:	e8 de d0 ff ff       	call   f0103d83 <cprintf>
f0106ca5:	83 c4 20             	add    $0x20,%esp
f0106ca8:	eb b6                	jmp    f0106c60 <spin_unlock+0x8a>
		panic("spin_unlock");
f0106caa:	83 ec 04             	sub    $0x4,%esp
f0106cad:	68 77 91 10 f0       	push   $0xf0109177
f0106cb2:	6a 67                	push   $0x67
f0106cb4:	68 48 91 10 f0       	push   $0xf0109148
f0106cb9:	e8 82 93 ff ff       	call   f0100040 <_panic>
f0106cbe:	66 90                	xchg   %ax,%ax

f0106cc0 <__udivdi3>:
f0106cc0:	55                   	push   %ebp
f0106cc1:	57                   	push   %edi
f0106cc2:	56                   	push   %esi
f0106cc3:	53                   	push   %ebx
f0106cc4:	83 ec 1c             	sub    $0x1c,%esp
f0106cc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0106ccb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0106ccf:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106cd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106cd7:	85 d2                	test   %edx,%edx
f0106cd9:	75 4d                	jne    f0106d28 <__udivdi3+0x68>
f0106cdb:	39 f3                	cmp    %esi,%ebx
f0106cdd:	76 19                	jbe    f0106cf8 <__udivdi3+0x38>
f0106cdf:	31 ff                	xor    %edi,%edi
f0106ce1:	89 e8                	mov    %ebp,%eax
f0106ce3:	89 f2                	mov    %esi,%edx
f0106ce5:	f7 f3                	div    %ebx
f0106ce7:	89 fa                	mov    %edi,%edx
f0106ce9:	83 c4 1c             	add    $0x1c,%esp
f0106cec:	5b                   	pop    %ebx
f0106ced:	5e                   	pop    %esi
f0106cee:	5f                   	pop    %edi
f0106cef:	5d                   	pop    %ebp
f0106cf0:	c3                   	ret    
f0106cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106cf8:	89 d9                	mov    %ebx,%ecx
f0106cfa:	85 db                	test   %ebx,%ebx
f0106cfc:	75 0b                	jne    f0106d09 <__udivdi3+0x49>
f0106cfe:	b8 01 00 00 00       	mov    $0x1,%eax
f0106d03:	31 d2                	xor    %edx,%edx
f0106d05:	f7 f3                	div    %ebx
f0106d07:	89 c1                	mov    %eax,%ecx
f0106d09:	31 d2                	xor    %edx,%edx
f0106d0b:	89 f0                	mov    %esi,%eax
f0106d0d:	f7 f1                	div    %ecx
f0106d0f:	89 c6                	mov    %eax,%esi
f0106d11:	89 e8                	mov    %ebp,%eax
f0106d13:	89 f7                	mov    %esi,%edi
f0106d15:	f7 f1                	div    %ecx
f0106d17:	89 fa                	mov    %edi,%edx
f0106d19:	83 c4 1c             	add    $0x1c,%esp
f0106d1c:	5b                   	pop    %ebx
f0106d1d:	5e                   	pop    %esi
f0106d1e:	5f                   	pop    %edi
f0106d1f:	5d                   	pop    %ebp
f0106d20:	c3                   	ret    
f0106d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106d28:	39 f2                	cmp    %esi,%edx
f0106d2a:	77 1c                	ja     f0106d48 <__udivdi3+0x88>
f0106d2c:	0f bd fa             	bsr    %edx,%edi
f0106d2f:	83 f7 1f             	xor    $0x1f,%edi
f0106d32:	75 2c                	jne    f0106d60 <__udivdi3+0xa0>
f0106d34:	39 f2                	cmp    %esi,%edx
f0106d36:	72 06                	jb     f0106d3e <__udivdi3+0x7e>
f0106d38:	31 c0                	xor    %eax,%eax
f0106d3a:	39 eb                	cmp    %ebp,%ebx
f0106d3c:	77 a9                	ja     f0106ce7 <__udivdi3+0x27>
f0106d3e:	b8 01 00 00 00       	mov    $0x1,%eax
f0106d43:	eb a2                	jmp    f0106ce7 <__udivdi3+0x27>
f0106d45:	8d 76 00             	lea    0x0(%esi),%esi
f0106d48:	31 ff                	xor    %edi,%edi
f0106d4a:	31 c0                	xor    %eax,%eax
f0106d4c:	89 fa                	mov    %edi,%edx
f0106d4e:	83 c4 1c             	add    $0x1c,%esp
f0106d51:	5b                   	pop    %ebx
f0106d52:	5e                   	pop    %esi
f0106d53:	5f                   	pop    %edi
f0106d54:	5d                   	pop    %ebp
f0106d55:	c3                   	ret    
f0106d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106d5d:	8d 76 00             	lea    0x0(%esi),%esi
f0106d60:	89 f9                	mov    %edi,%ecx
f0106d62:	b8 20 00 00 00       	mov    $0x20,%eax
f0106d67:	29 f8                	sub    %edi,%eax
f0106d69:	d3 e2                	shl    %cl,%edx
f0106d6b:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106d6f:	89 c1                	mov    %eax,%ecx
f0106d71:	89 da                	mov    %ebx,%edx
f0106d73:	d3 ea                	shr    %cl,%edx
f0106d75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106d79:	09 d1                	or     %edx,%ecx
f0106d7b:	89 f2                	mov    %esi,%edx
f0106d7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106d81:	89 f9                	mov    %edi,%ecx
f0106d83:	d3 e3                	shl    %cl,%ebx
f0106d85:	89 c1                	mov    %eax,%ecx
f0106d87:	d3 ea                	shr    %cl,%edx
f0106d89:	89 f9                	mov    %edi,%ecx
f0106d8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0106d8f:	89 eb                	mov    %ebp,%ebx
f0106d91:	d3 e6                	shl    %cl,%esi
f0106d93:	89 c1                	mov    %eax,%ecx
f0106d95:	d3 eb                	shr    %cl,%ebx
f0106d97:	09 de                	or     %ebx,%esi
f0106d99:	89 f0                	mov    %esi,%eax
f0106d9b:	f7 74 24 08          	divl   0x8(%esp)
f0106d9f:	89 d6                	mov    %edx,%esi
f0106da1:	89 c3                	mov    %eax,%ebx
f0106da3:	f7 64 24 0c          	mull   0xc(%esp)
f0106da7:	39 d6                	cmp    %edx,%esi
f0106da9:	72 15                	jb     f0106dc0 <__udivdi3+0x100>
f0106dab:	89 f9                	mov    %edi,%ecx
f0106dad:	d3 e5                	shl    %cl,%ebp
f0106daf:	39 c5                	cmp    %eax,%ebp
f0106db1:	73 04                	jae    f0106db7 <__udivdi3+0xf7>
f0106db3:	39 d6                	cmp    %edx,%esi
f0106db5:	74 09                	je     f0106dc0 <__udivdi3+0x100>
f0106db7:	89 d8                	mov    %ebx,%eax
f0106db9:	31 ff                	xor    %edi,%edi
f0106dbb:	e9 27 ff ff ff       	jmp    f0106ce7 <__udivdi3+0x27>
f0106dc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0106dc3:	31 ff                	xor    %edi,%edi
f0106dc5:	e9 1d ff ff ff       	jmp    f0106ce7 <__udivdi3+0x27>
f0106dca:	66 90                	xchg   %ax,%ax
f0106dcc:	66 90                	xchg   %ax,%ax
f0106dce:	66 90                	xchg   %ax,%ax

f0106dd0 <__umoddi3>:
f0106dd0:	55                   	push   %ebp
f0106dd1:	57                   	push   %edi
f0106dd2:	56                   	push   %esi
f0106dd3:	53                   	push   %ebx
f0106dd4:	83 ec 1c             	sub    $0x1c,%esp
f0106dd7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0106ddb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0106ddf:	8b 74 24 30          	mov    0x30(%esp),%esi
f0106de3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106de7:	89 da                	mov    %ebx,%edx
f0106de9:	85 c0                	test   %eax,%eax
f0106deb:	75 43                	jne    f0106e30 <__umoddi3+0x60>
f0106ded:	39 df                	cmp    %ebx,%edi
f0106def:	76 17                	jbe    f0106e08 <__umoddi3+0x38>
f0106df1:	89 f0                	mov    %esi,%eax
f0106df3:	f7 f7                	div    %edi
f0106df5:	89 d0                	mov    %edx,%eax
f0106df7:	31 d2                	xor    %edx,%edx
f0106df9:	83 c4 1c             	add    $0x1c,%esp
f0106dfc:	5b                   	pop    %ebx
f0106dfd:	5e                   	pop    %esi
f0106dfe:	5f                   	pop    %edi
f0106dff:	5d                   	pop    %ebp
f0106e00:	c3                   	ret    
f0106e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106e08:	89 fd                	mov    %edi,%ebp
f0106e0a:	85 ff                	test   %edi,%edi
f0106e0c:	75 0b                	jne    f0106e19 <__umoddi3+0x49>
f0106e0e:	b8 01 00 00 00       	mov    $0x1,%eax
f0106e13:	31 d2                	xor    %edx,%edx
f0106e15:	f7 f7                	div    %edi
f0106e17:	89 c5                	mov    %eax,%ebp
f0106e19:	89 d8                	mov    %ebx,%eax
f0106e1b:	31 d2                	xor    %edx,%edx
f0106e1d:	f7 f5                	div    %ebp
f0106e1f:	89 f0                	mov    %esi,%eax
f0106e21:	f7 f5                	div    %ebp
f0106e23:	89 d0                	mov    %edx,%eax
f0106e25:	eb d0                	jmp    f0106df7 <__umoddi3+0x27>
f0106e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106e2e:	66 90                	xchg   %ax,%ax
f0106e30:	89 f1                	mov    %esi,%ecx
f0106e32:	39 d8                	cmp    %ebx,%eax
f0106e34:	76 0a                	jbe    f0106e40 <__umoddi3+0x70>
f0106e36:	89 f0                	mov    %esi,%eax
f0106e38:	83 c4 1c             	add    $0x1c,%esp
f0106e3b:	5b                   	pop    %ebx
f0106e3c:	5e                   	pop    %esi
f0106e3d:	5f                   	pop    %edi
f0106e3e:	5d                   	pop    %ebp
f0106e3f:	c3                   	ret    
f0106e40:	0f bd e8             	bsr    %eax,%ebp
f0106e43:	83 f5 1f             	xor    $0x1f,%ebp
f0106e46:	75 20                	jne    f0106e68 <__umoddi3+0x98>
f0106e48:	39 d8                	cmp    %ebx,%eax
f0106e4a:	0f 82 b0 00 00 00    	jb     f0106f00 <__umoddi3+0x130>
f0106e50:	39 f7                	cmp    %esi,%edi
f0106e52:	0f 86 a8 00 00 00    	jbe    f0106f00 <__umoddi3+0x130>
f0106e58:	89 c8                	mov    %ecx,%eax
f0106e5a:	83 c4 1c             	add    $0x1c,%esp
f0106e5d:	5b                   	pop    %ebx
f0106e5e:	5e                   	pop    %esi
f0106e5f:	5f                   	pop    %edi
f0106e60:	5d                   	pop    %ebp
f0106e61:	c3                   	ret    
f0106e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106e68:	89 e9                	mov    %ebp,%ecx
f0106e6a:	ba 20 00 00 00       	mov    $0x20,%edx
f0106e6f:	29 ea                	sub    %ebp,%edx
f0106e71:	d3 e0                	shl    %cl,%eax
f0106e73:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106e77:	89 d1                	mov    %edx,%ecx
f0106e79:	89 f8                	mov    %edi,%eax
f0106e7b:	d3 e8                	shr    %cl,%eax
f0106e7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106e81:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106e85:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106e89:	09 c1                	or     %eax,%ecx
f0106e8b:	89 d8                	mov    %ebx,%eax
f0106e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106e91:	89 e9                	mov    %ebp,%ecx
f0106e93:	d3 e7                	shl    %cl,%edi
f0106e95:	89 d1                	mov    %edx,%ecx
f0106e97:	d3 e8                	shr    %cl,%eax
f0106e99:	89 e9                	mov    %ebp,%ecx
f0106e9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0106e9f:	d3 e3                	shl    %cl,%ebx
f0106ea1:	89 c7                	mov    %eax,%edi
f0106ea3:	89 d1                	mov    %edx,%ecx
f0106ea5:	89 f0                	mov    %esi,%eax
f0106ea7:	d3 e8                	shr    %cl,%eax
f0106ea9:	89 e9                	mov    %ebp,%ecx
f0106eab:	89 fa                	mov    %edi,%edx
f0106ead:	d3 e6                	shl    %cl,%esi
f0106eaf:	09 d8                	or     %ebx,%eax
f0106eb1:	f7 74 24 08          	divl   0x8(%esp)
f0106eb5:	89 d1                	mov    %edx,%ecx
f0106eb7:	89 f3                	mov    %esi,%ebx
f0106eb9:	f7 64 24 0c          	mull   0xc(%esp)
f0106ebd:	89 c6                	mov    %eax,%esi
f0106ebf:	89 d7                	mov    %edx,%edi
f0106ec1:	39 d1                	cmp    %edx,%ecx
f0106ec3:	72 06                	jb     f0106ecb <__umoddi3+0xfb>
f0106ec5:	75 10                	jne    f0106ed7 <__umoddi3+0x107>
f0106ec7:	39 c3                	cmp    %eax,%ebx
f0106ec9:	73 0c                	jae    f0106ed7 <__umoddi3+0x107>
f0106ecb:	2b 44 24 0c          	sub    0xc(%esp),%eax
f0106ecf:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0106ed3:	89 d7                	mov    %edx,%edi
f0106ed5:	89 c6                	mov    %eax,%esi
f0106ed7:	89 ca                	mov    %ecx,%edx
f0106ed9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106ede:	29 f3                	sub    %esi,%ebx
f0106ee0:	19 fa                	sbb    %edi,%edx
f0106ee2:	89 d0                	mov    %edx,%eax
f0106ee4:	d3 e0                	shl    %cl,%eax
f0106ee6:	89 e9                	mov    %ebp,%ecx
f0106ee8:	d3 eb                	shr    %cl,%ebx
f0106eea:	d3 ea                	shr    %cl,%edx
f0106eec:	09 d8                	or     %ebx,%eax
f0106eee:	83 c4 1c             	add    $0x1c,%esp
f0106ef1:	5b                   	pop    %ebx
f0106ef2:	5e                   	pop    %esi
f0106ef3:	5f                   	pop    %edi
f0106ef4:	5d                   	pop    %ebp
f0106ef5:	c3                   	ret    
f0106ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106efd:	8d 76 00             	lea    0x0(%esi),%esi
f0106f00:	89 da                	mov    %ebx,%edx
f0106f02:	29 fe                	sub    %edi,%esi
f0106f04:	19 c2                	sbb    %eax,%edx
f0106f06:	89 f1                	mov    %esi,%ecx
f0106f08:	89 c8                	mov    %ecx,%eax
f0106f0a:	e9 4b ff ff ff       	jmp    f0106e5a <__umoddi3+0x8a>
